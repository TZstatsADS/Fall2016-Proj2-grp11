library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
      
    output$map = renderLeaflet({
          leaflet() %>% 
          addTiles(
           urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiemhlaGFvbGl1IiwiYSI6ImNpdHgwb3g1aTAwYWsyeXF2eDc0aGQzcXEifQ.RMISHgo5GtXgviM7WO9F6w',
           attribution = 'Map provided by <a href="https://www.mapbox.com">Mapbox</a>'
          ) %>%
          setView(lng = -73.958, lat = 40.801453, zoom = 12)
      })
    
   
   
    #user click 'show it all', reveal the popups for every felony on the map
    observeEvent(input$detail_plot,{
            
            #get the hour input
            pos = regexpr('~', input$hour)
            if (pos == -1 ){
              start_hour = 0
              end_hour = 23
            } else {
              start_hour = as.integer(trimws(substr(input$hour, 1, pos -1)))
              end_hour = as.integer(trimws(substr(input$hour, pos + 1, nchar(input$hour))))
            }
            
            #filter data for the user specified period
            detail_plot_dt = map_data_prep(start_hour =  start_hour, end_hour = end_hour, 
                                           start_date =  input$s_date, end_date = input$e_date, 
                                           crime_type =  input$crime_list, n_obs = input$n_obs)
            
            
            #test
            leafletProxy('map', data = detail_plot_dt) %>%
                clearMarkers() %>%
                addMarkers(lng = ~lng, lat = ~lat, icon = ~crime_icons[Offense],  
                                                                popup = paste('# of', '<em>',detail_plot_dt$Offense,'</em>',':',
                                                                '<strong>', detail_plot_dt$n, '</strong>'))
                
          
                  })
    
    
    #---------------hayoung-----------
    my_address <- eventReactive(input$go,{input$address})
    output$map_output <- renderLeaflet({map})
    
    observe({
      code<-geocode(my_address())
      dt_sub<-dt[,c('lng','lat')]
      newdata<- subset(dt,distHaversine(code,dt_sub) <= input$range)
      output$table <- DT::renderDataTable(newdata[,c('Date','Day of Week','Occurrence Hour','Offense')])

      leafletProxy("map_output") %>%
        clearPopups()%>%
        clearGroup("newdata")%>%
        setView(code$lon,code$lat,zoom=13)%>%
        addPopups(code$lon,code$lat,"My Location", 
                  options=popupOptions(closeButton=TRUE))%>%
        addCircles(code$lon,code$lat,radius=input$range,color="blue",group="newdata")
    })
    
    sliderValues <- reactive({
      leaflet(subset(sub2,`Occurrence Hour`%in% input$test)) %>% addTiles() %>%
        setView(-73.9626, 40.8075, zoom = 16)%>%
        addMarkers(subset(sub2,`Occurrence Hour`%in% input$test)$lng, subset(sub2,`Occurrence Hour`%in% input$test)$lat, popup = pu,clusterOptions=markerClusterOptions())
    }) 
    
    output$map_output2 <- renderLeaflet({sliderValues()})
  
    
#-----------------------Celia-------------------
    #########################by Time###############################
    output$timeplot = renderPlotly({
      i= as.numeric(input$timetype)
      j = i - 1
      number_vec = rbind(c(1,12),c(1,31),c(2010,2015),c(0,23))
      time_vec=c("Months Vs Number of Crimes","Days Vs Number of Crimes","Years Vs Number of Crimes","Hours Vs Number of Crimes")
      df.time=dt %>% group_by(Offense,dt[,i]) %>% summarise (n = n())
      plot_ly(x = seq(from=number_vec[j,1],to=number_vec[j,2])) %>% layout(title = time_vec[j],width=1200,height=600) %>% 
        add_lines(y = df.time[df.time$Offense=="BURGLARY",]$n, name = "BURGLARY") %>%
        add_lines(y = df.time[df.time$Offense=="FELONY ASSAULT",]$n, name = "FELONY ASSAULT") %>%
        add_lines(y = df.time[df.time$Offense=="GRAND LARCENY",]$n, name = "GRAND LARCENY") %>%
        add_lines(y = df.time[df.time$Offense=="GRAND LARCENY OF MOTOR VEHICLE",]$n, name = "GRAND LARCENY OF MOTOR VEHICLE") %>%
        add_lines(y = df.time[df.time$Offense=="MURDER & NON-NEGL. MANSLAUGHTE",]$n, name = "MURDER & NON-NEGL. MANSLAUGHTE") %>%
        add_lines(y = df.time[df.time$Offense=="RAPE",]$n, name = "RAPE") %>% 
        add_lines(y = df.time[df.time$Offense=="ROBBERY",]$n, name = "ROBBERY")
    })
    #########################by locations###############################
    output$borplot = renderHighchart({
      
      df.bor1= dt[which(dt[,9]==  input$BorGroup[1]),]
      df.bor2= dt[which(dt[,9]==  input$BorGroup[2]),]
      df.bor3= dt[which(dt[,9]==  input$BorGroup[3]),]
      df.bor4= dt[which(dt[,9]==  input$BorGroup[4]),]
      df.bor5= dt[which(dt[,9]==  input$BorGroup[5]),]
      df.bor_fel1= count(df.bor1,Offense)
      df.bor_fel2= count(df.bor2,Offense)
      df.bor_fel3= count(df.bor3,Offense)
      df.bor_fel4= count(df.bor4,Offense)
      df.bor_fel5= count(df.bor5,Offense)
      
      if(length(input$BorGroup==1)){
        highchart() %>% hc_chart(type = "bar") %>% hc_chart(width=1200,height=800) %>% hc_title(text = "Crime Counts in Different Boroughs") %>%
          hc_xAxis(categories = crimes_vec) %>%
          hc_add_series(name=input$BorGroup[1],data = list_parse(data.frame(name = df.bor_fel1$Offense, y = df.bor_fel1$n)))}
      if(length(input$BorGroup==2)){
        highchart() %>% hc_chart(type = "bar") %>% hc_chart(width=1200,height=800) %>% hc_title(text = "Crime Counts in Different Boroughs") %>% 
          hc_xAxis(categories = crimes_vec) %>%
          hc_add_series(name=input$BorGroup[1],data = list_parse(data.frame(name = df.bor_fel1$Offense, y = df.bor_fel1$n))) %>%
          hc_add_series(name=input$BorGroup[2],data = list_parse(data.frame(name = df.bor_fel2$Offense, y = df.bor_fel2$n)))}
      if(length(input$BorGroup==3)){
        highchart() %>% hc_chart(type = "bar") %>% hc_chart(width=1200,height=800) %>% hc_title(text = "Crime Counts in Different Boroughs") %>%
          hc_xAxis(categories = crimes_vec) %>%
          hc_add_series(name=input$BorGroup[1],data = list_parse(data.frame(name = df.bor_fel1$Offense, y = df.bor_fel1$n))) %>%
          hc_add_series(name=input$BorGroup[2],data = list_parse(data.frame(name = df.bor_fel2$Offense, y = df.bor_fel2$n))) %>%
          hc_add_series(name=input$BorGroup[3],data = list_parse(data.frame(name = df.bor_fel3$Offense, y = df.bor_fel3$n)))}
      if(length(input$BorGroup==4)){
        highchart() %>% hc_chart(type = "bar") %>% hc_chart(width=1200,height=800) %>% hc_title(text = "Crime Counts in Different Boroughs") %>%
          hc_xAxis(categories = crimes_vec) %>%
          hc_add_series(name=input$BorGroup[1],data = list_parse(data.frame(name = df.bor_fel1$Offense, y = df.bor_fel1$n))) %>%
          hc_add_series(name=input$BorGroup[2],data = list_parse(data.frame(name = df.bor_fel2$Offense, y = df.bor_fel2$n))) %>%
          hc_add_series(name=input$BorGroup[3],data = list_parse(data.frame(name = df.bor_fel3$Offense, y = df.bor_fel3$n))) %>%
          hc_add_series(name=input$BorGroup[4],data = list_parse(data.frame(name = df.bor_fel4$Offense, y = df.bor_fel4$n)))}
      if(length(input$BorGroup==5)){
        highchart() %>% hc_chart(type = "bar") %>% hc_chart(width=1200,height=800) %>% hc_title(text = "Crime Counts in Different Boroughs") %>% 
          hc_xAxis(categories = crimes_vec) %>%
          
          hc_add_series(name=input$BorGroup[1],data = list_parse(data.frame(name = df.bor_fel1$Offense, y = df.bor_fel1$n))) %>%
          hc_add_series(name=input$BorGroup[2],data = list_parse(data.frame(name = df.bor_fel2$Offense, y = df.bor_fel2$n))) %>%
          hc_add_series(name=input$BorGroup[3],data = list_parse(data.frame(name = df.bor_fel3$Offense, y = df.bor_fel3$n))) %>%
          hc_add_series(name=input$BorGroup[4],data = list_parse(data.frame(name = df.bor_fel4$Offense, y = df.bor_fel4$n))) %>%
          hc_add_series(name=input$BorGroup[5],data = list_parse(data.frame(name = df.bor_fel5$Offense, y = df.bor_fel5$n)))}
    })
    
    
    output$tableplot = renderDataTable({
      df_prec=count(dt,Precinct)
      df_prec.order=df_prec[order(-df_prec$n),]
      m=input$precinct[1]
      n=input$precinct[2]
      datatable(df_prec.order[m:n,])
    })
    
    #########################by crime types#############################
    output$typeplot = renderHighchart({
      # crime types
      df.crime= count(dt,Offense)
      df.crime.2010_2015=dt %>% group_by(`Borough`,Offense) %>% summarise (n = n())
      
      if(input$year=="2010-2015" & input$typeborough=="ALL BOROUGHS"){
        highchart() %>% hc_chart(type = "pie") %>%
          hc_add_series(name="How many of this felony occurred?",
                        data = list_parse(data.frame(name = df.crime$Offense, y = df.crime$n)))}
      if(input$year=="2010-2015"){
        highchart() %>% hc_chart(type = "pie") %>%
          hc_add_series(name="How many of this felony occurred?",
                        df.crime.2010_2015=dt %>% group_by(`Borough`,Offense) %>% summarise (n = n()),
                        df.crime.2010_2015.BOR = df.crime.2010_2015[which(df.crime.2010_2015$Borough ==input$typeborough),],
                        data = list_parse(data.frame(name=df.crime.2010_2015.BOR$Offense, y = df.crime.2010_2015.BOR$n)))}
      if(input$typeborough=="ALL BOROUGHS"){
        highchart() %>% hc_chart(type = "pie") %>%
          hc_add_series(name="How many of this felony occurred?",
                        df.crime.borough=dt %>% group_by(`Occurrence Year`,Offense) %>% summarise (n = n()),
                        df.crime.borough.2010_2015 = df.crime.borough[which(df.crime.borough$`Occurrence Year`==input$year),],
                        data = list_parse(data.frame(name=df.crime.borough.2010_2015$Offense, y=df.crime.borough.2010_2015$n)))}
      else{highchart() %>% hc_chart(type = "pie") %>% hc_add_series(name="How many of this felony occurred?",
                                                                    df.crime.boryear=dt %>% group_by(`Occurrence Year`,`Borough`,Offense) %>% summarise (n = n()),
                                                                    df.crime.boryear.plot=df.crime.borough[which(df.crime.boryear$`Occurrence Year`==input$year & df.crime.boryear$Borough==input$typeborough),],
                                                                    data = list_parse(data.frame(name=df.crime.boryear.plot$Offense, y=df.crime.boryear.plot$n)))}
    })
    
  
})

