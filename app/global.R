library(dplyr)
library(plyr)
library(data.table)
library(magrittr)
library(leaflet)
library(ggmap)
library(geosphere)

setwd('/Users/Max/GitHub/Fall2016-Proj2-grp11/')
dt = as.data.frame(fread('./data/NYPD_Felony_2010~2016.csv'))

#checking NA value
#colSums(is.na(dt))
  
#express month in number
dt$`Occurrence Month` = as.numeric(mapvalues(dt$`Occurrence Month`,  
                                  from = unique(dt$`Occurrence Month`),
                                  to = c(10,9,12,1,2,3,4,5,6,7,8,11)))

#add another date column for map plotting
dt = mutate(dt, Date = as.Date(paste(sep = '-', dt$`Occurrence Year`, dt$`Occurrence Month`, dt$`Occurrence Day`)))
#save(dt, file =  './data/dt.RData')
#load('./data/dt.RData')

#----------------Max--------------------------
#function for split location into longitutde and latitude
split_location = function(location_vector){
    lat  = substr(location_vector, 2, regexpr(',', location_vector) - 1)
    lng  = substr(location_vector, regexpr(',', location_vector) + 2, nchar(location_vector) - 1)
    result_df = data.frame(lat = as.numeric(lat), lng = as.numeric(lng))
    return(result_df)
}

#rename offense type
plot_dt = dt
plot_dt$Offense[plot_dt$Offense == 'GRAND LARCENY' | plot_dt$Offense == 'GRAND LARCENY OF MOTOR VEHICLE'] = 'GRAND LARCENY'
plot_dt$Offense[plot_dt$Offense == 'MURDER & NON-NEGL. MANSLAUGHTE'] = 'MURDER'

#function for filtering ploting data within use-specifies period
map_data_prep = function(start_hour =0, end_hour = 23, start_date, end_date, crime_type, n_obs ){
    result_dt = plot_dt %>% 
        filter(Offense %in% crime_type) %>%
        filter(Date >= start_date & Date <= end_date & `Occurrence Hour` >= start_hour & `Occurrence Hour` <= end_hour) %>%
        group_by(`Location 1`, Offense) %>%
        dplyr::summarise(n = n()) %>%
        arrange(desc(n))
    
    result_dt = result_dt %>% 
        as.data.frame %>%
        cbind(split_location(result_dt$`Location 1`)) %>%
        select(-`Location 1`)
    
    return(result_dt[1:n_obs,])
}

#making icons for map
crime_icons = iconList(
    BURGLARY = makeIcon(iconUrl = './data/BUR.png',iconWidth = 23, iconHeight = 23),
    `FELONY ASSAULT` =  makeIcon(iconUrl = './data/ASSUALT.png',iconWidth = 23, iconHeight = 23),
    `GRAND LARCENY` =  makeIcon(iconUrl = './data/LARCERY.png',iconWidth = 23, iconHeight = 23),
    MURDER =  makeIcon(iconUrl = './data/MURDER.png',iconWidth = 23, iconHeight = 23),
    RAPE =  makeIcon(iconUrl = './data/RAPE.png',iconWidth = 23, iconHeight = 23),
    ROBBERY =  makeIcon(iconUrl = './data/ROBBERY.png',iconWidth = 23, iconHeight = 23)
)

#------------hayoung-----------------
dt = cbind(dt, split_location(dt$`Location 1`))
dt[,'lat']<-as.numeric(dt[,'lat'])
dt[,'lng']<-as.numeric(dt[,'lng'])
pu<-paste(sep="<br/>",dt[1:200,]$Offense,dt[1:200,]$'Occurrence Date')
map<-leaflet(dt[1:200,]) %>% addTiles() %>%
  addMarkers(dt[1:200,]$lng, dt[1:200,]$lat, popup = pu,clusterOptions=markerClusterOptions())
