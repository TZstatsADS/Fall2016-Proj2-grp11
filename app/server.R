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
    
    
})
