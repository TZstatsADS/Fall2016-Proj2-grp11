library(shiny)
library(shinydashboard)
library(leaflet)

#UI part
navbarPage(title = 'NY', theme = 'bootstrap.css',
  
  tabPanel(title = 'Neighborhood Crime',
                    fluidRow(
                      column(width = 9,
                             box(width = NULL, solidHeader = TRUE,leafletOutput("map_output", height = 500)
                             )
                             
                      ),
                      column(width = 3,
                             box(width = NULL, status = "warning",
                                 textInput("address", "Type the Address:"),
                                 actionButton("go", "Zoom out")
                                 
                             ),
                             
                             br(box(width = NULL, status = "warning",
                                    sliderInput("range", "Range:", 10, 2000,1000),
                                    p("Distance in meter"))))),
                    fluidRow(column(width=12,box(title = h4("Table"),width=800,DT::dataTableOutput("table"))))
           ),
           
  
  tabPanel(title = 'Map Vaisualization',
             
              leafletOutput('map'), 
           
              hr(),
           
              fluidRow(
                
                column(4,
                       
                       dateInput('s_date', label = 'Start Date', value = '2010-01-01',
                                min = '2010-01-01', max = '2016-01-01'
                                ),
                        
                        
                        dateInput('e_date', label = 'End Date', value = '2010-01-01',
                                  min = '2010-01-01', max = '2016-01-01'
                                 ),
                       
                       textInput('hour', label = 'Time period (from 0 to 23)', placeholder = 'ex. 2 ~ 4')
                       
                       
                ),
               
           
                column(4,
                       
                       checkboxGroupInput('crime_list', label = 'Choose item to display',
                                          choices =  list('BURGLARY', 'FELONY ASSAULT', 'GRAND LARCENY',
                                                          'MURDER', 'RAPE', 'ROBBERY')
                          )
        
                
                ),
                
                column(4,
                       verticalLayout(
                       
                          
                          sliderInput('n_obs', '# of incidents on map', min = 1, max = 200, step = 1, value = 50),
                         
                          actionButton('detail_plot', label = 'Show it all!')
                          
                          
                       )
                       )
              )
  
  ),
  
  tabPanel(title ='Analysis',
           navlistPanel(
             
             tabPanel(title = 'By year',
                      fluidRow(
                        h2('place for plotting output')
                      ),
                      #dividing line
                      hr(),
                      #input area
                      fluidRow(
                        column(4,
                               selectInput('4',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        ),
                        
                        column(4,
                               selectInput('5',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        ),
                        
                        column(4,
                               selectInput('6',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        )
                        
                      )
             ),
             
             tabPanel(title = 'By felony type',
                      fluidRow(
                        h2('place for plotting output')
                      ),
                      #dividing line
                      hr(),
                      #input area
                      fluidRow(
                        column(4,
                               selectInput('7',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        ),
                        
                        column(4,
                               selectInput('8',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        ),
                        
                        column(4,
                               selectInput('9',
                                           label = 'Input value here',
                                           choices = c(1,2,3,4),
                                           selected = 3)
                        )
                      
                        )
             
           )
           

    )
  )
)
