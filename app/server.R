library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(DT)
library(plotly)
library(highcharter)

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
      dt = cbind(dt, split_location(dt$`Location 1`))
      dt[,'lat']<-as.numeric(dt[,'lat'])
      dt[,'lng']<-as.numeric(dt[,'lng'])
      dt = subset(dt, `Occurrence Year` >= 2015 )
      pu<-paste(sep="<br/>",dt$Offense,dt$Date)
      map<-leaflet(dt) %>% addTiles() %>%
        addMarkers(dt$lng, dt$lat, popup = pu,clusterOptions=markerClusterOptions())
      
      
      sub1<-subset(dt,(lng>-73.97)&(lng<-73.94))
      sub2<-subset(sub1,(lat>40.80)&(lat<40.81))
      
      
      
      code<-geocode(my_address())
      dt_sub<-dt[,c('lng','lat')]
      newdata<- subset(dt,distHaversine(code,dt_sub) <= input$range )
      output$table <- DT::renderDataTable(newdata[,c('Day of Week','Occurrence Hour','Offense')])

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
  
    

    
    #--------Celia----------------------
    dt = as.data.frame(fread('./data/NYPD_Felony_2010~2016.csv'))
    df.Year= dt %>% group_by(Offense,`Occurrence Year`) %>% dplyr::summarise (n = n()) 
    df.Month= dt %>% group_by(Offense,`Occurrence Month`) %>% dplyr::summarise (n = n()) 
    df.Day= dt %>% group_by(Offense,`Occurrence Day`) %>% dplyr::summarise (n = n()) 
    df.Week= dt %>% group_by(Offense,`Day of Week`) %>% dplyr::summarise (n = n())
    df.Hour= dt %>% group_by(Offense,`Occurrence Hour`) %>% dplyr::summarise (n = n()) 
    
    # crime types
    df.crime= dplyr::count(dt,Offense)
    
    # List of Vectors
    crimes_vec=df.crime$Offense
    
    year_list=seq(from=2010,to=2015)
    month_list=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
    day_list=seq(1:31)
    hour_list=seq(from=0,to=23)
    
    
    
    #########################by Time###############################
    output$time_plot = renderHighchart({
      i= as.numeric(input$timetypes)
      j = i - 1
      number_vec = rbind(c(1,12),c(1,31),c(2010,2015),c(0,23))
      time_vec=c("Months Vs Number of Crimes","Days Vs Number of Crimes","Years Vs Number of Crimes","Hours Vs Number of Crimes")
      df.time=dt %>% group_by(Offense,dt[,i]) %>% dplyr::summarise (n = n())
      x = seq(from=number_vec[j,1],to=number_vec[j,2])
      highchart() %>% hc_chart(type = "line") %>% hc_chart(width=1000,height=600) %>% hc_title(text=time_vec[j]) %>%
        hc_add_series(name="BURGLARY",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="BURGLARY",]$n))) %>% 
        hc_add_series(name="FELONY ASSAULT",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="FELONY ASSAULT",]$n))) %>%
        hc_add_series(name="GRAND LARCENY",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="GRAND LARCENY",]$n))) %>% 
        hc_add_series(name="GRAND LARCENY OF MOTOR VEHICLE",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="GRAND LARCENY OF MOTOR VEHICLE",]$n))) %>% 
        hc_add_series(name="MURDER & NON-NEGL. MANSLAUGHTE",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="MURDER & NON-NEGL. MANSLAUGHTE",]$n))) %>% 
        hc_add_series(name="RAPE",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="RAPE",]$n))) %>% 
        hc_add_series(name="ROBBERY",data = list_parse(data.frame(name=x, y=df.time[df.time$Offense=="ROBBERY",]$n)))
    })
    
    #########################by locations###############################
    output$borplot = renderHighchart({
      
      df.bor1= dt[which(dt[,9]==  input$BorGroup[1]),]
      df.bor2= dt[which(dt[,9]==  input$BorGroup[2]),]
      df.bor3= dt[which(dt[,9]==  input$BorGroup[3]),]
      df.bor4= dt[which(dt[,9]==  input$BorGroup[4]),]
      df.bor5= dt[which(dt[,9]==  input$BorGroup[5]),]
      df.bor_fel1= dplyr::count(df.bor1,Offense)
      df.bor_fel2= dplyr::count(df.bor2,Offense)
      df.bor_fel3= dplyr::count(df.bor3,Offense)
      df.bor_fel4= dplyr::count(df.bor4,Offense)
      df.bor_fel5= dplyr::count(df.bor5,Offense)
      
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
      df_prec=dplyr::count(dt,Precinct)
      df_prec.order=df_prec[order(-df_prec$n),]
      m=input$precinct[1]
      n=input$precinct[2]
      datatable(df_prec.order[m:n,])
    })
    
    
    #########################by crime types#############################
    output$typeplot = renderHighchart({
      # crime types
      df.crime= dt %>% group_by(Offense) %>% dplyr::summarise(n = n())
      df.crime.2010_2015=dt %>% group_by(`Borough`,Offense) %>% dplyr::summarise(n = n())
      df.crime.borough=dt %>% group_by(`Occurrence Year`,Offense) %>% dplyr::summarise(n = n())
      df.crime.boryear=dt %>% group_by(`Occurrence Year`,`Borough`,Offense) %>% dplyr::summarise(n = n())
      df.crime.2010_2015.bor = df.crime.2010_2015[which(df.crime.2010_2015$Borough == input$typeborough),]
      df.crime.borough.2010_2015 = df.crime.borough[which(df.crime.borough$`Occurrence Year`==input$year),]
      df.crime.boryear.plot=df.crime.boryear[which(df.crime.boryear$`Occurrence Year`== input$year &  df.crime.boryear$Borough==input$typeborough),]
      
      if(input$typeborough=="ALL BOROUGHS"){
        highchart() %>% hc_chart(type = "pie") %>% 
          hc_add_series(data = list_parse(data.frame(name=df.crime.borough.2010_2015$Offense, y=df.crime.borough.2010_2015$n)))}
      else{
        highchart() %>% hc_chart(type = "pie") %>% 
          hc_add_series(data = list_parse(data.frame(name=df.crime.boryear.plot$Offense, y=df.crime.boryear.plot$n)))}
      
      
    })
})

