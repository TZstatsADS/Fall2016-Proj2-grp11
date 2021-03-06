library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(shinythemes)

#UI part
navbarPage(title = "NYPD 7 Major Felonies", theme = shinytheme("spacelab"),
  
  tabPanel(title = 'Welcome',br(),br(),br(),br(),br(),
                    h1("For your wellbeing",align="center"),br(),br(),br(),br(),br(),
                    div(img(src="new-york-scene.jpg", height = 600, width = 800, align = 'center'), style="text-align: center;"),
                    #img(src="new-york-scene.jpg", height = 600, width = 800, align = 'center'),
                    h2("Remember this: 911",align="center")),
  
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
  
  navbarMenu("Deep Analysis",
             
             
             
             
             
             ############################Ty Time###################################
             tabPanel("Felonies by Time",
                      # side bar
                      sidebarLayout(position = "left",
                                    sidebarPanel(
                                      helpText("Select a type of time to illustrate how the number of 
                                               feloy incidents change with time."),
                                      radioButtons("timetypes","Choose A Type of Time to display",
                                                   choices = c("Year"=4,"Month"=2,"Day"=3,"Hour"=5),
                                                   selected = 4)),
                                    
                                    # main panel 
                                    mainPanel(
                                      h1("NYPD 7 Major Felony Incidents",align = "center"),
                                      h2("A Closer Look: Classified by Time",align = "center"),
                                      br(),br(),br(),br(),br(),br(),
                                      highchartOutput("time_plot")))),
             ###############################################################      
             tabPanel("Felonies by Locations",sidebarLayout(position="right",                            
                                                            sidebarPanel(
                                                              conditionalPanel(condition="input.ccpanel==1",
                                                                               helpText("Compare felony incidents among different boroughs."),
                                                                               checkboxGroupInput("BorGroup", label = h3("5 Boroughs of New York"), 
                                                                                                  choices = list("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND"),
                                                                                                  selected = "BRONX"),
                                                                               helpText("Note: you can choose up to 5 boroughs.")),
                                                              
                                                              conditionalPanel(condition="input.ccpanel==2",
                                                                               helpText("Select rankings to display precints based on the number of felonies occurred in that area.
                                                                                        e.g.sliding to (20,30) means to show precincts with 20 to 30 highest number of felonies."),
                                                                               sliderInput("precinct", 
                                                                                           label = h3("Display Precints by Choosing Their Rankings"), 
                                                                                           min = 1, max = 77,value=c(1,10)))),
                                                            
                                                            mainPanel(
                                                              tabsetPanel(type="pill",id="ccpanel",
                                                                          tabPanel("By Different Boroughs",br(), br(),
                                                                                   highchartOutput("borplot"),value=1),
                                                                          tabPanel("Precints Rankings",br(),dataTableOutput("tableplot"),
                                                                                   value=2)
                                                              )))),     
             ###############################################################    
             tabPanel("Felonies by Types",
                      # sidebar
                      sidebarLayout(position = "right",
                                    sidebarPanel( 
                                      helpText("Select years and boroughs to see the distributions of 7 major felony incidents."),
                                      br(),
                                      selectInput("year","Choose a Year to display",
                                                  choices = c("2010","2011","2012","2013","2014","2015"),
                                                  selected = "2010"),br(),
                                      selectInput("typeborough","Choose a Borough to display",
                                                  choices = list("ALL BOROUGHS","BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND"),
                                                  selected = "ALL BOROUGHS")),
                                    
                                    # main panel 
                                    mainPanel(
                                      h1("NYPD 7 Major Felony Incidents",align = "center"),
                                      h2("A Closer Look: Classified by Crime Types",align = "center"),
                                      br(),br(),br(),br(),br(),br(),
                                      highchartOutput("typeplot")
                                    )))),
  
  tabPanel(title = 'Special Case',
           fluidRow(
             column(width = 9,
                    box(width = NULL, solidHeader = TRUE,leafletOutput("map_output2", height = 500)
                    )
             ),
             column(width = 3,
                    box(width = NULL, status = "warning",
                        sliderInput("test", "Crime count by hour:",
                                    min = 0, max = 23, value = 0, step = 1,
                                    sep = ",", animate=TRUE)
                    )))),
  
  ###############################################################                 
  tabPanel("About Us",
           titlePanel("More on the App and Us"),
           navlistPanel(
             
             
             "About the App",
             tabPanel("Our Vision",
                      p("This shiny app is devoted to help those who have concerns over the",
                        strong("safety issues"),"in New York.", 
                        style = "font-family: 'times'; font-si16pt")),
             
             
             tabPanel("The Dataset",
                      p("The dataset is imported from https://nycopendata.socrata.com/"),
                      br(),br(),
                      p("We will not display the raw data here as its size is enormous even after the data cleaning.")),
             
             
             tabPanel("Contact Us",
                      p("shinyapp address: not yet available."),
                      br(),
                      p("Email Address: celiahuangofficial@gmail.com") ),
             
             
             "About the Team",
             tabPanel("Chenxi(Celia) Huang",
                      
                      
                      # main panel
                      mainPanel(
                        p("Graduated from London School of Economics, Celia is currently pursuing a MS in Actuarial Science at Columbia University."),
                        br(),
                        p("Interests: music, painting, data visualization, Cooking, Travel, etc."),
                        br(),
                        img(src="Celia_Huang.png", height = 100, width = 100)

                        
                      )
             ),
             tabPanel("Zhehao(Max) Liu",
                      p("Max, Actuarial Science student at Columbia. "),
                      br(),
                      p("Powerlifting enthusiastics. Big fan of cycling and ASAP Rocky.")),
             tabPanel("Hayoung Kim",
                      p('Columbia University, M.A. in statistics'),
                      br(),
                      p('NICE Research and Consulting, Senior Research Consaltant at CS Department for 3 years
Sookmyung Women\'s University, B.S. in statistics'))))
  
  
            
             
           )
           


