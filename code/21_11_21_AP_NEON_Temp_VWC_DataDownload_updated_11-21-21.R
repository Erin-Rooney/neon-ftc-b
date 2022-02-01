#NEON soil temperature and moisture
#Import - all 40 SOMMOS NEON sites 
#Updated 11-21-21

#NEON
library(neonUtilities)

#Soil temperature########
#2021 release 
#NEON (National Ecological Observatory Network). Soil temperature, RELEASE-2021 (DP1.00041.001). https://doi.org/10.48443/zayg-n802. Dataset accessed from https://data.neonscience.org on [Month 00, 0000]
#All available sites
#saveRDS for each data object ("temp_winter1.RData", etc.)

temp_winter1 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2018-12",
                             enddate="2019-02",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")

temp_spring1 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2019-03",
                             enddate="2019-05",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")

temp_summer1 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2019-06",
                             enddate="2019-08",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")

temp_fall1 = loadByProduct(dpID="DP1.00041.001",site="all",
                           package="basic",
                           startdate="2019-09",
                           enddate="2019-11",
                           nCores=5,
                           timeIndex=30,  
                           release="RELEASE-2021")

temp_winter2 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2019-12",
                             enddate="2020-02",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")


temp_spring2 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2020-03",
                             enddate="2020-05",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")

temp_summer2 = loadByProduct(dpID="DP1.00041.001",site="all",
                             package="basic",
                             startdate="2020-06",
                             enddate="2020-08",
                             nCores=5,
                             timeIndex=30,  
                             release="RELEASE-2021")

temp_fall2 = loadByProduct(dpID="DP1.00041.001",site="all",
                           package="basic",
                           startdate="2020-09",
                           enddate="2020-11",
                           nCores=5,
                           timeIndex=30,  
                           release="RELEASE-2021")

#Soil water content and water salinity########
#2021 release 
#NEON (National Ecological Observatory Network). Soil water content and water salinity, RELEASE-2021 (DP1.00094.001). https://doi.org/10.48443/bakr-aj85. Dataset accessed from https://data.neonscience.org on [Month 00, 0000]. 
#All available sites 

moisture_winter1 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2018-12",
                                 enddate="2019-02",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_spring1 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2019-03",
                                 enddate="2019-05",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_summer1 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2019-06",
                                 enddate="2019-08",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_fall1 = loadByProduct(dpID="DP1.00094.001",site="all",
                               package="basic",
                               startdate="2019-09",
                               enddate="2019-11",
                               nCores=5,
                               timeIndex=30,  
                               release="RELEASE-2021")

moisture_winter2 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2019-12",
                                 enddate="2020-02",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_spring2 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2020-03",
                                 enddate="2020-05",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_summer2 = loadByProduct(dpID="DP1.00094.001",site="all",
                                 package="basic",
                                 startdate="2020-06",
                                 enddate="2020-08",
                                 nCores=5,
                                 timeIndex=30,  
                                 release="RELEASE-2021")

moisture_fall2 = loadByProduct(dpID="DP1.00094.001",site="all",
                               package="basic",
                               startdate="2020-09",
                               enddate="2020-11",
                               nCores=5,
                               timeIndex=30,  
                               release="RELEASE-2021")

#Save to .RData (change path to local folder)
saveRDS(temp_winter1, file = "ap_download/temp_winter1.RData")
saveRDS(temp_spring1, file = "ap_download/temp_spring1.RData")
saveRDS(temp_summer1, file = "ap_download/temp_summer1.RData")
saveRDS(temp_fall1, file = "ap_download/temp_fall1.RData")
saveRDS(temp_winter2, file = "ap_download/temp_winter2.RData")
saveRDS(temp_spring2, file = "ap_download/temp_spring2.RData")
saveRDS(temp_summer2, file = "ap_download/temp_summer2.RData")
saveRDS(temp_fall2, file = "ap_download/temp_fall2.RData")

saveRDS(moisture_winter1, file = "ap_download/moisture_winter1.RData")
saveRDS(moisture_spring1, file = "ap_download/moisture_spring1.RData")
saveRDS(moisture_summer1, file = "ap_download/moisture_summer1.RData")
saveRDS(moisture_fall1, file = "ap_download/moisture_fall1.RData")
saveRDS(moisture_winter2, file = "ap_download/moisture_winter2.RData")
saveRDS(moisture_spring2, file = "ap_download/moisture_spring2.RData")
saveRDS(moisture_summer2, file = "ap_download/moisture_summer2.RData")
saveRDS(moisture_fall2, file = "/path/moisture_fall2.RData")

