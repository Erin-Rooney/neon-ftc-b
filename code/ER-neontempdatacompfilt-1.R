# Erin C Rooney
# 10 15 2020

# load libraries-------------------------------
library(tidyverse)
library(reshape2)

# filter data and create CSV files----------------
# fall----------------------
all_fall1 = read.csv("processed/Dat-all_fall1.csv")

all_fall1 = all_fall1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_fall1 = read.csv("processed/Dat-HEAL_fall1.csv")

heal_fall1 = heal_fall1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
fall1 = 
  all_fall1 %>% 
  bind_rows(heal_fall1)

#fall2--------------------------

all_fall2 = read.csv("processed/Dat-all_fall2.csv")

all_fall2 = all_fall2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_fall2 = read.csv("processed/Dat-HEAL_fall2.csv")

heal_fall2 = heal_fall2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
fall2 = 
  all_fall2 %>% 
  bind_rows(heal_fall2)

# winter-------------------------------------
all_winter1 = read.csv("processed/Dat-all_winter1.csv")

all_winter1 = all_winter1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_winter1 = read.csv("processed/Dat-HEAL_winter1.csv")

heal_winter1 = heal_winter1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
winter1 = 
  all_winter1 %>% 
  bind_rows(heal_winter1)

# winter2----------------------------------

all_winter2 = read.csv("processed/Dat-all_winter2.csv")

all_winter2 = all_winter2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_winter2 = read.csv("processed/Dat-HEAL_winter2.csv")

heal_winter2 = heal_winter2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
winter2 = 
  all_winter2 %>% 
  bind_rows(heal_winter2)


# spring-------------------------------------
all_spring1 = read.csv("processed/Dat-all_spring1.csv")

all_spring1 = all_spring1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_spring1 = read.csv("processed/Dat-HEAL_spring1.csv")

heal_spring1 = heal_spring1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
spring1 = 
  all_spring1 %>% 
  bind_rows(heal_spring1)

# spring2----------------------------------------------

all_spring2 = read.csv("processed/Dat-all_spring2.csv")

all_spring2 = all_spring2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_spring2 = read.csv("processed/Dat-HEAL_spring2.csv")

heal_spring2 = heal_spring2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
spring2 = 
  all_spring2 %>% 
  bind_rows(heal_spring2)

# summer-------------------------------------
all_summer1 = read.csv("processed/Dat-all_summer1.csv")

all_summer1 = all_summer1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_summer1 = read.csv("processed/Dat-HEAL_summer1.csv")

heal_summer1 = heal_summer1 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
summer1 = 
  all_summer1 %>% 
  bind_rows(heal_summer1)

#summer2---------------------------------------

all_summer2 = read.csv("processed/Dat-all_summer2.csv")

all_summer2 = all_summer2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

heal_summer2 = read.csv("processed/Dat-HEAL_summer2.csv")

heal_summer2 = heal_summer2 %>% 
  # keep only necessary columns
  select(siteID, startDateTime, endDateTime, horizontalPosition, verticalPosition, soilTempMean)

#bind heal and all dat files
summer2 = 
  all_summer2 %>% 
  bind_rows(heal_summer2)

# Outputs---------------------------------------

write.csv(fall1,"fall1.csv", row.names = FALSE)
write.csv(fall2,"fall2.csv", row.names = FALSE)
write.csv(winter1,"winter1.csv", row.names = FALSE)
write.csv(winter2,"winter2.csv", row.names = FALSE)
write.csv(spring1,"spring1.csv", row.names = FALSE)
write.csv(spring2,"spring2.csv", row.names = FALSE)
write.csv(spring1,"summer1.csv", row.names = FALSE)
write.csv(spring2,"summer2.csv", row.names = FALSE)