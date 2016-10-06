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
            detail_plot_dt =  dt %>% 
                filter(Date >= input$s_date & Date <= input$e_date) %>%
                filter(`Occurrence Hour`>= start_hour & `Occurrence Hour` <= end_hour)
            
            #test
            leafletProxy('map', data = detail_plot_dt) %>%
                clearShapes() %>%
                addMarkers(lng =  -73.989282176, lat = 40.7504307680001)
                  
                  })
    
    
    #output$test = renderText(input$s_date > as.Date('2011-01-02'))
    
    #user click 'Show me the distribution!', reveal the felony counts for certain area 
    #during the user specified time period
    #maybe darker color for areas with more crime? up to you!
    eventReactive(input$dist_plot,{
      #code here adding the area polygon := hayoung           
      #you can manipulate the dataset from global.R here
      #shinyapp tutorial:http://shiny.rstudio.com/tutorial
      #guide to leaflet: https://rstudio.github.io/leaflet/
    })
    

    
})



