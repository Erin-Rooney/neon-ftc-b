# Angela Possinger Script
# July 22 2020
# Adapted by Erin C. Rooney

#Precipitation

library(neonUtilities)
library(tidyverse)

# Precip_2017_2020 = loadByProduct(dpID="DP1.00006.001",
#                                  site=c("HEAL","BONA","BARR","TOOL"),
#                                  package="basic",
#                                  startdate="2019-07",
#                                  enddate="2019-08",
#                                  avg=30)

Precip_2017_2020_5cores = loadByProduct(dpID="DP1.00006.001",
                                        site=c("HEAL","BONA","BARR","TOOL"),
                                        package="basic",
                                        startdate="2018-07",
                                        enddate="2020-10",
                                        nCores=5,
                                        avg=30)


str(Precip_2017_2020_5cores) 


Data=Precip_2017_2020_5cores$SECPRE_30min
Metadata=Precip_2017_2020_5cores$variables

save(Precip_2017_2020_5cores, file="processed/Precip_2017_2020_5coresER.RData")

load("processed/Precip_2017_2020_5coresER.RData")

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
Precip_2017_2020_5cores$`SECPRE_30min` = as.factor(Precip_2017_2020_5cores$`SECPRE_30min`)

#data_csv$wsoc_mg_L = data_csv$Water.Soluble.Organic.Carbon..mg.L.

# list the first 6 entries of the data table
head(Precip_2017_2020_5cores)

# find the dimensions of the data table (rows and columns)
dim(Precip_2017_2020_5cores)

write.csv(Precip_2017_2020_5cores, "processed/Precip_2017_2020_5cores.csv")




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
