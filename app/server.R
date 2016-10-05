library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(ggplot2)

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
    eventReactive(input$detailed_plot,{
    #code here adding the popups    := Max           
                  
                  })
    
    
    
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



