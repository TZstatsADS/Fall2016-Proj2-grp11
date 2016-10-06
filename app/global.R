library(dplyr)
library(plyr)
library(data.table)

setwd('/Users/Max/GitHub/Fall2016-Proj2-grp11/')
dt = as.data.frame(fread('./data/NYPD_Felony_2010~2016.csv'))

#checking NA value
#colSums(is.na(dt))
  
#Split location column for mapping
dt = dt %>% mutate(lat = substr(dt$`Location 1`, 2, regexpr(',', dt$`Location 1`) - 1)) %>%
  mutate(lng = substr(dt$`Location 1`,regexpr(',', dt$`Location 1`) + 2, nchar(dt$`Location 1`)-1) ) 

#express month in number
dt$`Occurrence Month` = as.numeric(mapvalues(dt$`Occurrence Month`,  
                                  from = unique(dt$`Occurrence Month`),
                                  to = c(10,9,12,1,2,3,4,5,6,7,8,11)))

#add another date column for map plotting
dt = mutate(dt, Date = as.Date(paste(sep = '-', dt$`Occurrence Year`, dt$`Occurrence Month`, dt$`Occurrence Day`)))

#save(dt, file =  './data/dt.RData')
#load('./data/dt.RData')
