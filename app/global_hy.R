library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(plyr)
library(data.table)
library(shinydashboard)
setwd('C:/Users/user/Desktop/Statistics/3rd semester/ADS/Project2/Fall2016-Proj2-grp11')
#dt_raw = as.data.frame(fread('./data/NYPD_7_Major_Felony_Incidents.csv'))
#names(dt_raw)
#dt = subset(dt_raw,`Occurrence Year`%in% c(2010,2011,2012,2013,2014,2015),select=c(1,3,4,5,6,7,8,12,13,14,15,16,17,18,19,20))

#checking NA value
#colSums(is.na(dt))

#Split location column for mapping
#dt = dt %>% mutate(lat = substr(dt$`Location 1`, 2, regexpr(',', dt$`Location 1`) - 1)) %>%
#  mutate(lon = substr(dt$`Location 1`,regexpr(',', dt$`Location 1`) + 2, nchar(dt$`Location 1`)-1))

#express month in number
#dt$`Occurrence Month` = as.numeric(mapvalues(dt$`Occurrence Month`,  
#                                  from = unique(dt$`Occurrence Month`),
#                                  to = c(10,9,12,1,2,3,4,5,6,7,8,11)))

#add another date column for map plotting
#dt = mutate(dt, Date = as.Date(paste(sep = '-', dt$`Occurrence Year`, dt$`Occurrence Month`, dt$`Occurrence Day`)))

#save(dt, file =  './data/dt.RData')
#load('./data/dt.RData')

#hayoung
#Please change 17,18->lat,long column numbers based on your dataset
library(ggmap)
library(geosphere)
dt[,17]<-as.numeric(dt[,17])
dt[,18]<-as.numeric(dt[,18])
pu<-paste(sep="<br/>",dt[1:200,]$Offense,dt[1:200,]$'Occurrence Date')
map<-leaflet(dt[1:200,]) %>% addTiles() %>%
     addMarkers(dt[1:200,]$lon, dt[1:200,]$lat, popup = pu,clusterOptions=markerClusterOptions())
