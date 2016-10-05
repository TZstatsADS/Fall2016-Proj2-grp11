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
  
    
    
    
})



