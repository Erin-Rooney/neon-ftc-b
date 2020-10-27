# Erin C Rooney
# 10 15 2020

# load libraries-------------------------------
library(tidyverse)
library(reshape2)



# filter data and create CSV files----------------
# fall----------------------
all_fall1_pos = read.csv("processed/Pos-all_fall1.csv")

all_fall1_pos = all_fall1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_fall1_pos = read.csv("processed/Pos-HEAL_fall1.csv")

heal_fall1_pos = heal_fall1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
fall1_pos = 
  all_fall1_pos %>% 
  bind_rows(heal_fall1_pos)

#fall2--------------------------

all_fall2_pos = read.csv("processed/Pos-all_fall2.csv")

all_fall2_pos = all_fall2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_fall2_pos = read.csv("processed/Pos-HEAL_fall2.csv")

heal_fall2_pos = heal_fall2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
fall2_pos = 
  all_fall2_pos %>% 
  bind_rows(heal_fall2_pos)

# winter-------------------------------------
all_winter1_pos = read.csv("processed/Pos-all_winter1.csv")

all_winter1_pos = all_winter1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_winter1_pos = read.csv("processed/Pos-HEAL_winter1.csv")

heal_winter1_pos = heal_winter1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
winter1_pos = 
  all_winter1_pos %>% 
  bind_rows(heal_winter1_pos)

# winter2----------------------------------

all_winter2_pos = read.csv("processed/Pos-all_winter2.csv")

all_winter2_pos = all_winter2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_winter2_pos = read.csv("processed/Pos-HEAL_winter2.csv")

heal_winter2_pos = heal_winter2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
winter2_pos = 
  all_winter2_pos %>% 
  bind_rows(heal_winter2_pos)


# spring-------------------------------------
all_spring1_pos = read.csv("processed/Pos-all_spring1.csv")

all_spring1_pos = all_spring1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_spring1_pos = read.csv("processed/Pos-HEAL_spring1.csv")

heal_spring1_pos = heal_spring1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
spring1_pos = 
  all_spring1_pos %>% 
  bind_rows(heal_spring1_pos)

# spring2----------------------------------------------

all_spring2_pos = read.csv("processed/Pos-all_spring2.csv")

all_spring2_pos = all_spring2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_spring2_pos = read.csv("processed/Pos-HEAL_spring2.csv")

heal_spring2_pos = heal_spring2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
spring2_pos = 
  all_spring2_pos %>% 
  bind_rows(heal_spring2_pos)

# summer-------------------------------------
all_summer1_pos = read.csv("processed/Pos-all_summer1.csv")

all_summer1_pos = all_summer1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_summer1_pos = read.csv("processed/Pos-HEAL_summer1.csv")

heal_summer1_pos = heal_summer1_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
summer1_pos = 
  all_summer1_pos %>% 
  bind_rows(heal_summer1_pos)

#summer2---------------------------------------

all_summer2_pos = read.csv("processed/Pos-all_summer2.csv")

all_summer2_pos = all_summer2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

heal_summer2_pos = read.csv("processed/Pos-HEAL_summer2.csv")

heal_summer2_pos = heal_summer2_pos %>% 
  # keep only necessary columns
  select(siteID, HOR.VER, xOffset, yOffset, zOffset, referenceLatitude, referenceLongitude)

#bind heal and all dat files
summer2_pos = 
  all_summer2_pos %>% 
  bind_rows(heal_summer2_pos)

# Outputs---------------------------------------

write.csv(fall1_pos,"fall1_pos.csv", row.names = FALSE)
write.csv(fall2_pos,"fall2_pos.csv", row.names = FALSE)
write.csv(winter1_pos,"winter1_pos.csv", row.names = FALSE)
write.csv(winter2_pos,"winter2_pos.csv", row.names = FALSE)
write.csv(spring1_pos,"spring1_pos.csv", row.names = FALSE)
write.csv(spring2_pos,"spring2_pos.csv", row.names = FALSE)
write.csv(spring1_pos,"summer1_pos.csv", row.names = FALSE)
write.csv(spring2_pos,"summer2_pos.csv", row.names = FALSE)