# Angela Possinger Script
# July 22 2020
# Adapted by Erin C. Rooney

#Soil water

library(neonUtilities)
library(tidyverse)

# load--------------------------------------------------

sw_fall1 = loadByProduct(dpID="DP1.00094.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2018-09",
                             enddate="2018-11")

sw_fall2 = loadByProduct(dpID="DP1.00094.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2019-09",
                             enddate="2019-11")

sw_fall3 = loadByProduct(dpID="DP1.00094.001",
                             site=c("HEAL","BONA","BARR","TOOL"),
                             package="basic",
                             startdate="2020-09",
                             enddate="2020-11")

sw_winter1 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2018-12",
                               enddate="2018-02")

sw_winter2 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2019-12",
                               enddate="2019-02")

sw_winter3 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2020-12",
                               enddate="2020-02")

sw_spring1 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2018-03",
                               enddate="2018-05")

sw_spring2 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2019-03",
                               enddate="2019-05")

sw_spring3 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2020-03",
                               enddate="2020-05")

sw_summer1 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2018-06",
                               enddate="2018-08")

sw_summer2 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2019-06",
                               enddate="2019-08")

sw_summer3 = loadByProduct(dpID="DP1.00094.001",
                               site=c("HEAL","BONA","BARR","TOOL"),
                               package="basic",
                               startdate="2020-06",
                               enddate="2020-08")