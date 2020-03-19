
rm(list=ls())
library(sp)
library(raster)
library(spatstat)
library(rgdal)
library(maptools)
library(rgeos)
library(GISTools)
library(shapefiles)
library(spatstat)

setwd("C:/Users/User/Box Sync/Data/TIF_data/002.Maps/Cook/CookCounty_TIFboundary_ 2015")
TIF_2015<-shapefile("TIF_2015.shp")

setwd("C:/Users/User/Box Sync/Data/TIF_data/002.Maps/Expired TIFs Shapefile")
expired<-shapefile("ExpiredTIFs.shp")

expired_data<-as.data.frame(expired)
data_2015<-as.data.frame(TIF_2015)

# 030850503 exists in 2016TIF map and explired map. my bad. Should delete in expired data. 
row<-data_2015[data_2015$agencynum %in% expired_data$AGENCYNUM,]
row

expired_data_v1<-expired[!(expired$AGENCYNUM=="030850503"),]

#excluding TID created in 2015 (should exclude-double checked)
TIF_2015_v1<-TIF_2015[!(TIF_2015$first_year=="2015"),]

#Joining existing + expired TIF map - 200315
compareCRS(expired_data_v1, data_2015)
names(expired_data_v1)
names(data_2015)

#issue - different columns. 
names(expired_data_v1)[names(expired_data_v1)=="AGENCY"]<-"agency"
names(expired_data_v1)[names(expired_data_v1)=="AGENCY_DES"]<-"tif_name"
names(expired_data_v1)[names(expired_data_v1)=="AGENCYNUM"]<-"agencynum"
names(TIF_2015_v1)[names(TIF_2015_v1)=="shape_star"]<-"SHAPE_area"
names(TIF_2015_v1)[names(TIF_2015_v1)=="shape_stle"]<-"SHAPE_len"

expired_data_v1$first_year<-NA
#column drop
expired_data_v2<-subset(expired_data_v1, select=c("agency","agencynum","first_year","SHAPE_area","SHAPE_len", "tif_name"))
TIF_2015_v2<-subset(TIF_2015_v1, select=c("agency", "agencynum" , "first_year" ,"SHAPE_area","SHAPE_len", "tif_name"  ))

#왜 2014TIFmap+explired가 내 designated area랑 row숫자가 안맞는가. checked in excel vlookup
TIF_2015_data<-as.data.frame(TIF_2015_v2)
expired_check<-as.data.frame(expired_data_v2)
data_row_check<-rbind(TIF_2015_data, expired_check)
write.csv(data_row_check,"C:/Users/User/Box Sync/Data/TIF_data/002.Maps/Expired TIFs Shapefile/data_check.csv")

#200316 need to request shape data for 28 districts. total 528 districts. 
#Then merge expired_data_v2 and TIF_2015_v2 and then 28disctircts. Then join designated year. 




