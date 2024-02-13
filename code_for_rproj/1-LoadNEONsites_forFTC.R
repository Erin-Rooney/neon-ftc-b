# Angela Possinger Script
# 4 29 2021
# Adapted by Erin C. Rooney


library(neonUtilities)
library(tidyverse)


# load--------------------------------------------------

fall1 = loadByProduct(dpID="DP1.00006.001",
                      site=c("HEAL","BONA","BARR","TOOL"),
                      package="basic",
                      startdate="2017-09",
                      enddate="2017-11",
                      nCores=5,
                      avg=30)

fall2 = loadByProduct(dpID="DP1.00006.001",
                      site=c("HEAL","BONA","BARR","TOOL"),
                      package="basic",
                      startdate="2018-09",
                      enddate="2018-11",
                      nCores=5,
                      avg=30)

fall3 = loadByProduct(dpID="DP1.00006.001",
                      site=c("HEAL","BONA","BARR","TOOL"),
                      package="basic",
                      startdate="2019-09",
                      enddate="2019-11",
                      nCores=5,
                      avg=30)

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

