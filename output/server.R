# Applied Data Science Project 2: New York 7 Felonies
# Shiny App 1 of Celia
setwd("C:/Users/celia/Documents/2015 ActSci Course/2016 Fall/STAT5243 Applied Data Science/Project 2/shinyapp_grp11")

# install.packages
# install.packages("shiny")
# install.packages("plotly")
# install.packages("data.table")
# install.packages("plyr")
# install.packages('dplyr')
# install.packages("highcharter")
# install.packages("DT")
library(shiny)
library(plotly)
library(data.table)
library(plyr)
library(dplyr)
library(highcharter)
library(DT)


######################################data processing#########################################
# read the data
dt = as.data.frame(fread('./NYPD_Felony_2010~2016.csv'))

# count frequencies
df.Year= dt %>% group_by(Offense,`Occurrence Year`) %>% summarise (n = n()) 
df.Month= dt %>% group_by(Offense,`Occurrence Month`) %>% summarise (n = n()) 
df.Day= dt %>% group_by(Offense,`Occurrence Day`) %>% summarise (n = n()) 
df.Week= dt %>% group_by(Offense,`Day of Week`) %>% summarise (n = n())
df.Hour= dt %>% group_by(Offense,`Occurrence Hour`) %>% summarise (n = n()) 

# crime types
df.crime= count(dt,Offense)

# List of Vectors
crimes_vec=df.crime$Offense

year_list=seq(from=2010,to=2015)
month_list=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
day_list=seq(1:31)
hour_list=seq(from=0,to=23)
##################################end of data processing########################################





shinyServer(function(input, output) {
  
  #########################A Closer Look###############################
  
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
  #############################################################################################
})