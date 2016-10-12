# Applied Data Science Project 2: New York 7 Felonies
# Shiny App 1 of Celia
setwd("C:/Users/celia/Documents/2015 ActSci Course/2016 Fall/STAT5243 Applied Data Science/Project 2/shinyapp_grp11")

# install.packages
# install.packages("shiny")
library(shiny)


shinyUI(
  
  ###############################################################                 
  navbarPage("NYPD 7 Major Felonies",
             ###############################################################                 
             
             
             ###############################################################                 
             # Map Tab                 
             tabPanel("Interactive Map"),
             
             
             
             ###############################################################               
             
             ###############################################################                 
             # a closer look at the data
             navbarMenu("Deep Analysis",
                        
                        
                        
                        
                        
                        ############################Ty Time###################################
                        tabPanel("Felonies by Time",
                                 # side bar
                                 sidebarLayout(position = "left",
                                 sidebarPanel(
                                 helpText("Select a type of time to illustrate how the number of 
                                          feloy incidents change with time."),
                                 radioButtons("timetype","Choose A Type of Time to display",
                                             choices = list("Year"=4,"Month"=2,"Day"=3,"Hour"=5),
                                             selected = 4)),
          
                                 # main panel 
                                 mainPanel(
                                   h1("NYPD 7 Major Felony Incidents",align = "center"),
                                   h2("A Closer Look: Classified by Time",align = "center"),
                                   br(),br(),br(),br(),br(),br(),
                                   plotlyOutput("timeplot")))),
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
                                            choices = c("2010-2015","2010","2011","2012","2013","2014","2015"),
                                            selected = "2010-2015"),br(),
                                      selectInput("typeborough","Choose a Borough to display",
                                                  choices = list("ALL BOROUGHS","BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND"),
                                                  selected = "ALL BOROUGHS")),
                                 
                                 # main panel 
                                 mainPanel(
                                   h1("NYPD 7 Major Felony Incidents",align = "center"),
                                   h2("A Closer Look: Classified by Crime Types",align = "center"),
                                   br(),br(),br(),br(),br(),br(),
                                   highchartOutput ("typeplot")
                                   )))),
            
             ###############################################################   
             
             
             ###############################################################                 
             tabPanel("Special Case"),
             
             
             
             ###############################################################                 
             
             ###############################################################                 
             tabPanel("About Us",
                      titlePanel("More on the App and Us"),
                      navlistPanel(
                        
                        
                        "About the App",
                        tabPanel("Our Vision",
                                 p("This shiny app is devoted to help those who have concerns over the",
                                   strong("safety issues"),"in New York.", 
                                   style = "font-family: 'times'; font-si16pt")),
                        
                        
                        tabPanel("The Dataset"),
                        tabPanel("Contact Us"),
                        
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
                                 p(),
                                 br(),
                                 p())))

             ###############################################################                 
             
  ))






