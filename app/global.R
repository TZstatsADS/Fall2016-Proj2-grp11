library(dplyr)
library(data.table)

setwd('/Users/Max/GitHub/Fall2016-Proj2-grp11/')
dt = as.data.frame(fread('./data/NYPD_Felony_2010~2016.csv'))

#checking NA value
colSums(is.na(dt)) #None
  
#Split location column for mapping
dt = dt %>% mutate(lng = substr(dt$`Location 1`, 2, regexpr(',', dt$`Location 1`) - 1)) %>%
  mutate(lat = substr(dt$`Location 1`,regexpr(',', dt$`Location 1`) + 2, nchar(dt$`Location 1`)-1) ) %>%
  select(-`Location 1`)


