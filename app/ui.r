library(shiny)
library(shinydashboard)

#UI part
navbarPage(title = 'NY', theme = 'bootstrap.css',
           
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
                        )
                
                ),
               
           
                column(4,
                       
                       checkboxGroupInput('check_item', label = 'Choose item to display',
                                          choices =  list(1,2,3,4)
                          )
                
                ),
                
                column(4,
                       verticalLayout(
                       
                          actionButton('detail_plot', label = 'Show it all!'),
                       
                          actionButton('dist_plot', label = 'Show me the distribution!')
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
