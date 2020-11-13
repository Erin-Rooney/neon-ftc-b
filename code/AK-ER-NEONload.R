# Angela Possinger Script
# July 22 2020
# Adapted by Erin C. Rooney

#Precipitation

library(neonUtilities)
library(tidyverse)

# load--------------------------------------------------

Precip_fall1 = loadByProduct(dpID="DP1.00006.001",
                                 site=c("HEAL","BONA","BARR","TOOL"),
                                 package="basic",
                                 startdate="2018-09",
                                 enddate="2018-11")

Precip_fall2 = loadByProduct(dpID="DP1.00006.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2019-09",
                             enddate="2019-11")

Precip_fall3 = loadByProduct(dpID="DP1.00006.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2020-09",
                             enddate="2020-11")

Precip_winter1 = loadByProduct(dpID="DP1.00006.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2018-12",
                             enddate="2018-02")

Precip_winter2 = loadByProduct(dpID="DP1.00006.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2019-12",
                             enddate="2019-02")

Precip_winter3 = loadByProduct(dpID="DP1.00006.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2020-12",
                             enddate="2020-02")

Precip_spring1 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2018-03",
                               enddate="2018-05")

Precip_spring2 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2019-03",
                               enddate="2019-05")

Precip_spring3 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2020-03",
                               enddate="2020-05")

Precip_summer1 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2018-06",
                               enddate="2018-08")

Precip_summer2 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2019-06",
                               enddate="2019-08")

Precip_summer3 = loadByProduct(dpID="DP1.00006.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2020-06",
                               enddate="2020-08")

# Precip_fall1_5cores = loadByProduct(dpID="DP1.00006.001",
#                                         site=c("HEAL","BONA","BARR","TOOL"),
#                                         package="basic",
#                                         startdate="2018-09",
#                                         enddate="2020-11",
#                                         nCores=5,
#                                         avg=30)

#PRI--------------------------------
Precip_fall1 = Precip_fall1$PRIPRE_30min

Precip_fall1 = Precip_fall1 %>%
  mutate(season = "fall",
         year = "1")


Precip_fall2 = Precip_fall2$PRIPRE_30min

Precip_fall2 = Precip_fall2 %>%
  mutate(season = "fall",
         year = "2")

Precip_fall3 = Precip_fall3$PRIPRE_30min

Precip_fall3 = Precip_fall3 %>%
  mutate(season = "fall",
         year = "3")

fallcombo = Precip_fall1 %>% 
bind_rows(Precip_fall2, 
          Precip_fall3)

Precip_spring1 = Precip_spring1$PRIPRE_30min

Precip_spring1 = Precip_spring1 %>%
  mutate(season = "spring",
         year = "1")

Precip_spring2 = Precip_spring2$PRIPRE_30min

Precip_spring2 = Precip_spring2 %>%
  mutate(season = "spring",
         year = "2")

Precip_spring3 = Precip_spring3$PRIPRE_30min

Precip_spring3 = Precip_spring3 %>%
  mutate(season = "spring",
         year = "3")

springcombo = Precip_spring1 %>% 
  bind_rows(Precip_spring2, 
            Precip_spring3)

Precip_summer1 = Precip_summer1$PRIPRE_30min

Precip_summer1 = Precip_summer1 %>%
  mutate(season = "summer",
         year = "1")

Precip_summer2 = Precip_summer2$PRIPRE_30min

Precip_summer2 = Precip_summer2 %>%
  mutate(season = "summer",
         year = "2")

Precip_summer3 = Precip_summer3$PRIPRE_30min

Precip_summer3 = Precip_summer3 %>%
  mutate(season = "summer",
         year = "3")

summercombo = Precip_summer1 %>% 
  bind_rows(Precip_summer2, 
            Precip_summer3)


allseasoncombo = fallcombo %>% 
  bind_rows(springcombo,
            summercombo)


str(allseasoncombo) 

# 
# Data=Precip_2017_2020_5cores$PRIPRE_30min
# Data2=Precip_2017_2020_5cores$SECPRE_30min
# Metadata=Precip_2017_2020_5cores$variables_00006
# Metadata2=Precip_2017_2020_5cores$variables_00006

save(allseasoncombo, file="processed/Precip_allseasoncombo.RData")

load("processed/Precip_allseasoncombo.RData")


# SEC---------------------------------------------------

Precip_fall1 = Precip_fall1$SECPRE_30min

Precip_fall1 = Precip_fall1 %>%
  mutate(season = "fall",
         year = "1")


Precip_fall2 = Precip_fall2$SECPRE_30min

Precip_fall2 = Precip_fall2 %>%
  mutate(season = "fall",
         year = "2")

Precip_fall3 = Precip_fall3$SECPRE_30min

Precip_fall3 = Precip_fall3 %>%
  mutate(season = "fall",
         year = "3")

fallcombo = Precip_fall1 %>% 
  bind_rows(Precip_fall2, 
            Precip_fall3)

Precip_spring1 = Precip_spring1$SECPRE_30min

Precip_spring1 = Precip_spring1 %>%
  mutate(season = "spring",
         year = "1")

Precip_spring2 = Precip_spring2$SECPRE_30min

Precip_spring2 = Precip_spring2 %>%
  mutate(season = "spring",
         year = "2")

Precip_spring3 = Precip_spring3$SECPRE_30min

Precip_spring3 = Precip_spring3 %>%
  mutate(season = "spring",
         year = "3")

springcombo = Precip_spring1 %>% 
  bind_rows(Precip_spring2, 
            Precip_spring3)

Precip_summer1 = Precip_summer1$SECPRE_30min

Precip_summer1 = Precip_summer1 %>%
  mutate(season = "summer",
         year = "1")

Precip_summer2 = Precip_summer2$SECPRE_30min

Precip_summer2 = Precip_summer2 %>%
  mutate(season = "summer",
         year = "2")

Precip_summer3 = Precip_summer3$SECPRE_30min

Precip_summer3 = Precip_summer3 %>%
  mutate(season = "summer",
         year = "3")

summercombo = Precip_summer1 %>% 
  bind_rows(Precip_summer2, 
            Precip_summer3)


allseasoncombo = fallcombo %>% 
  bind_rows(springcombo,
            summercombo)

save(allseasoncombo, file="processed/Secprecip_allseasoncombo.RData")

load("processed/Secprecip_allseasoncombo.RData")
write.csv(allseasoncombo, "processed/Secprecip_allseasoncombo.csv")



# step 2. info about data ----
# list the column names
# names(Data)
# names(Data2)
# 
# # structure of the columns
# # this tells you if a variable is numeric or categorical,
# # how many factors, etc.
# str(Data)
# str(Data2)
# 
# # change the format of the columns
# Data$PRIPRE_30min = as.character(Data$PRIPRE_30min)
# 
# Data$newcolumn = as.character(Data$siteID)
# 
# Data$startDateTime = as.character(Data$startDateTime)
# Data$endDateTime = as.character(Data$endDateTime)
# Data$`bulkprecip` = as.factor(Data$`priPreciptBulk`)

# Data 2

# Data2$SECPRE_30min = as.character(Data2$SECPRE_30min)
# 
# Data2$newcolumn = as.character(Data2$siteID)
# 
# Data2$startDateTime = as.character(Data2$startDateTime)
# Data2$endDateTime = as.character(Data2$endDateTime)
# Data$`bulkprecip` = as.factor(Data$`secPreciptBulk`)

#data_csv$wsoc_mg_L = data_csv$Water.Soluble.Organic.Carbon..mg.L.

# list the first 6 entries of the data table
# head(Data2)
# head(Data)
# 
# # find the dimensions of the data table (rows and columns)
# dim(Data2)
# dim(Data)
# 
# write.csv(Data, "processed/PRIPRE_2017_2020_5cores.csv")
# write.csv(Data2, "processed/SECPRE_2017_2020_5cores.csv")
write.csv(allseasoncombo, "processed/Precip_allseasoncombo.csv")



# Precipitation

library(neonUtilities)

Precip_2017_2020 = loadByProduct(dpID="DP1.00006.001",
                                site=c("HEAL","BONA","BARR","TOOL"),
                                package="basic",
                                startdate="2019-07",
                                enddate="2019-08",
                                avg=30)

Precip_2017_2020_5cores = loadByProduct(dpID="DP1.00006.001",
                                       site=c("HEAL","BONA","BARR","TOOL"),
                                       package="basic",
                                       startdate="2017-07",
                                       enddate="2020-10",
                                       nCores=5,
                                       avg=30)


str(Precip_2017_2020_5cores) 


Data=Precip_2017_2020_5cores$SECPRE_30min
Metadata=Precip_2017_2020_5cores$variables

save(Precip_2017_2020_5cores, file="processed/Precip_2017_2020_5coresER.RData")


# step 2. info about data ----
# list the column names
names(Precip_2017_2020_5cores)

# structure of the columns
# this tells you if a variable is numeric or categorical,
# how many factors, etc.
str(Precip_2017_2020_5cores)

# change the format of the columns
Precip_2017_2020_5cores$SECPRE_30min = as.character(Precip_2017_2020_5cores$SECPRE_30min)

Precip_2017_2020_5cores$newcolumn = as.character(Precip_2017_2020_5cores$siteID)

Precip_2017_2020_5cores$startDateTime = as.character(Precip_2017_2020_5cores$startDateTime)
Precip_2017_2020_5cores$endDateTime = as.character(Precip_2017_2020_5cores$endDateTime)
Precip_2017_2020_5cores$`PRIPRE_30min` = as.factor(Precip_2017_2020_5cores$`PRIPRE_30min`)
Precip_2017_2020_5cores$`SECPRE_30min` = as.factor(Precip_2017_2020_5cores$`SECPRE_30min`)
Precip_2017_2020_5cores$`THRPRE_30min` = as.factor(Precip_2017_2020_5cores$`THRPRE_30min`)



#data_csv$wsoc_mg_L = data_csv$Water.Soluble.Organic.Carbon..mg.L.

# list the first 6 entries of the data table
head(Precip_2017_2020_5cores)

# find the dimensions of the data table (rows and columns)
dim(Precip_2017_2020_5cores)

write.csv(Precip_2017_2020_5cores, "processed/Precip_2017_2020_5cores.csv")
