#NEON/SOMMOS
#this is for stats for FTICR transect paper
#5 13 2021
#E Rooney

#load packages----------------------------
source("code/0-packages.R")


# Load data------------------------------------

#Sommos data
sommos_horizon = read.csv("processed/SOMMOS_Horizon.csv")
sommos_site = read.csv("processed/SOMMOS_Site.csv")

#NEON temp data


allfall1 = read.csv("processed/Dat-all_fall1.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "fall",
                                                                                                                 year = 1)
allfall2 = read.csv("processed/Dat-all_fall2.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "fall",
                                                                                                                 year = 2)
allwinter1 = read.csv("processed/Dat-all_winter1.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "winter",
                                                                                                                     year = 1)
allwinter2 = read.csv("processed/Dat-all_winter2.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "winter",
                                                                                                                     year = 2)
allspring1 = read.csv("processed/Dat-all_spring1.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "spring",
                                                                                                                     year = 1)
allspring2 = read.csv("processed/Dat-all_spring2.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "spring",
                                                                                                                     year = 2)
allsummer1 = read.csv("processed/Dat-all_summer1.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "summer",
                                                                                                                     year = 1)
allsummer2 = read.csv("processed/Dat-all_summer2.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL")) %>%  mutate(season = "summer",
                                                                                                                     year = 2)
healfall1 = read.csv("processed/Dat-HEAL_fall1.csv") %>%  mutate(season = "fall",
                                                                 year = 1)
healfall2 = read.csv("processed/Dat-HEAL_fall2.csv") %>%  mutate(season = "fall",
                                                                 year = 2)
healwinter1 = read.csv("processed/Dat-HEAL_winter1.csv") %>%  mutate(season = "winter",
                                                                     year = 1)
healwinter2 = read.csv("processed/Dat-HEAL_winter2.csv") %>%  mutate(season = "winter",
                                                                     year = 2)
healspring1 = read.csv("processed/Dat-HEAL_spring1.csv") %>%  mutate(season = "spring",
                                                                     year = 1)
healspring2 = read.csv("processed/Dat-HEAL_spring2.csv") %>%  mutate(season = "spring",
                                                                     year = 2)
healsummer1 = read.csv("processed/Dat-HEAL_summer1.csv") %>%  mutate(season = "summer",
                                                                     year = 1)
healsummer2 = read.csv("processed/Dat-HEAL_summer2.csv") %>%  mutate(season = "summer",
                                                                     year = 2)

#bind files so that all four sites and all seasons are together. The current issue is that I need to 
#add season and year columns so I can filter, separate, and then combine with sitepos files.

foursite = 
  allfall1 %>% 
  bind_rows(allfall2,
            allwinter1,
            allwinter2,
            allspring1,
            allspring2,
            allsummer1,
            allsummer2,
            healfall1,
            healfall2,
            healwinter1,
            healwinter2,
            healspring1,
            healspring2,
            healsummer1,
            healsummer2)

#now I need to bring in profile positions


spring1_pos=read.csv("spring1_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "spring",
                                                                                                              year = 1)
spring2_pos=read.csv("spring2_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "spring",
                                                                                                              year = 2)
summer1_pos=read.csv("summer1_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "summer",
                                                                                                              year = 1)
summer2_pos=read.csv("summer2_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "summer",
                                                                                                              year = 2)
fall1_pos=read.csv("fall1_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "fall",
                                                                                                  year = 1)
fall2_pos=read.csv("fall2_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "fall",
                                                                                                          year = 2)
winter1_pos=read.csv("winter1_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "winter",
                                                                                                              year = 1)
winter2_pos=read.csv("winter2_pos.csv") %>% filter(siteID %in% c("BONA", "BARR", "TOOL", "HEAL")) %>%  mutate(season = "winter",
                                                                                                             year = 2)

#bind profile positions into one file

foursite_pos = 
  spring1_pos %>% 
  bind_rows(spring2_pos,
            summer1_pos,
            summer2_pos,
            fall1_pos,
            fall2_pos,
            winter1_pos,
            winter2_pos)


foursitejoin = foursite %>% 
  left_join(foursite_pos)



temp_dat=list(foursite = foursite) # list all data files
pos_dat=list(foursite = foursite_pos) # list all data files

#I don't know what's happening next. I'm just using Angela's code.

FTC_data = function(x, #list of dataframes (element ST_30_minute from NEON data product): this is "extract_dat" above or a smaller test dataset (defined in for loop)
                    y, #list of dataframes (element sensor_positions_00041 from NEON data product): this is "pos_dat" above or a smaller test dataset (defined in for loop)
                    name, #names of elements in x and y (vector). Names must end in a single digit number (year) in this case. 0 = NA. This is defined in for loop below
                    year #last character of names, which defines the year of measurements (in this case 1 or 2). 0 = NA. This is defined in for loop below
) {
  
  #Reduce dataframe to relevant columns (speeds up dcast)
  reduced_dat <- x[,c("siteID","verticalPosition","horizontalPosition","startDateTime","soilTempMean")]
  
  #Convert vertical, horizontal, and siteID to factors
  reduced_dat$verticalPosition=as.factor(reduced_dat$verticalPosition)
  reduced_dat$horizontalPosition=as.factor(reduced_dat$horizontalPosition)
  reduced_dat$siteID=as.factor(reduced_dat$siteID)
  
  #Reformat from "long" to "wide" form. Now the first column is the date-time
  #the other columns all correspond to one individual unit (probe), i.e. 1 site, 1 core, 1 depth 
  reduced_dat_Wide <- dcast(reduced_dat, startDateTime ~ siteID + verticalPosition + horizontalPosition + soilTempMean)
  
  #Freeze.thaw.analysis function fails with too many missing values (they do not provide a cutoff) 
  #For now, replacing columns with NA > 3% of timepoints with 0s (should be a flat line)
  #Most probes with missing data >3% are missing most if not all measurements
  
  #How many NAs is 3%?
  Max_NA <- nrow(reduced_dat_Wide)*0.03
  
  #Count # of NAs in each column
  NA_count <- as.data.frame(sapply(reduced_dat_Wide, function(x) sum(is.na(x))))
  colnames(NA_count) <- c("NA_count")
  
  #Converts all columns with names that match rows in NA_count with NA > 3% to 0s 
  reduced_dat_Wide[,c(rownames(NA_count)[NA_count$NA_count >= Max_NA])] <- 0
  
  #Convert date to character
  reduced_dat_Wide$startDateTime=as.character.Date(reduced_dat_Wide$startDateTime)
  names(reduced_dat_Wide)[names(reduced_dat_Wide) == 'startDateTime'] <- 'date'
  
  # #Dimensions of final dataframe
  # dim(reduced_dat_Wide)
  
  #Freeze-thaw analysis ####################################
  #Names of all columns but date, which will become the names of each element in the data.list for freeze thaw function
  column_names=as.vector(colnames(reduced_dat_Wide[,2:ncol(reduced_dat_Wide)]))
  #Number of columns to use in the data.list 
  column_number=as.vector(2:ncol(reduced_dat_Wide))
  
  #This function makes a list of elements, extracting row 1 (date) and then sequentially each column (y)
  #Each date and data column is a new element in the list, named by the list of column names above (x) 
  fun1 <- function(name,number) {
    data.list <- list(name = reduced_dat_Wide[,c(1,number)])
  }
  
  
  #This applies the function to loop through the list of column names (name) and numbers (number) 
  data.list = mapply(fun1,column_names,column_number)
  
  #The actual analysis function: this is where the parameters can be changed. 
  #mag.vec = degrees above or below thres.vec (0 degrees C) to induce FTC
  #dur.vec = duration of time (number of timesteps) above or below mag.vec to induce FTC
  FTC=freeze.thaw.analysis(data.list, mag.vec=1.5, dur.vec=8, thres.vec=0)
  
  #Combine FTC data output (Def1) with column_names 
  FTC.dat = cbind(FTC$data, column_names)
  
  #Measurements to exclude?
  Exclude = as.data.frame(rownames(NA_count)[NA_count$NA_count >= Max_NA])
  Exclude$Label = rep("Exclude", length(Exclude))
  colnames(Exclude)=c("column_names","Label")
  
  FTC.full <- Exclude %>% right_join(FTC.dat, by=c("column_names"))
  FTC.full$Label[is.na(FTC.full$Label)] = "Keep"
  
  FTC.full$Def1[FTC.full$Label == "Exclude"] <- NA
  FTC.full$season=rep(name,nrow(FTC.full))
  FTC.full$year=rep(year,nrow(FTC.full))
  
  #Split column to create factors (depth and core)
  FTC.full$column_names_2=FTC.full$column_names
  
  #Final FTC data
  FTC.full.final = FTC.full %>% separate(column_names_2, c("site","depth","core"), sep="_")
  
  #Core depths###################
  Sensor_Pos = y
  Sensor_Pos$HOR.VER.2=Sensor_Pos$HOR.VER
  Sensor_Pos = Sensor_Pos %>% separate(HOR.VER.2, c("HOR", "VER"))  
  
  Sensor_Pos=Sensor_Pos[,c("siteID","HOR","VER","zOffset")]
  #220 rows
  
  #Remove duplicate rows? This works in this example, but it's not generalizable. 
  #Healy has two zOffsets. Negative values seem to be correct depths, keeping only first row of HEAL
  Sensor_Pos_Distinct = distinct_at(Sensor_Pos, vars(siteID, HOR, VER), .keep_all = TRUE)
  
  #Combine names for ID column
  Sensor_Pos_Distinct = as.data.frame(unite(Sensor_Pos_Distinct, "column_names", c(siteID, VER, HOR), sep = "_", remove = FALSE))
  
  colnames(Sensor_Pos_Distinct)=c("column_names","site_pos","core_pos","depth_pos","depth_m")
  
  #Combine with FTC calculations
  FTC.all = Sensor_Pos_Distinct %>% right_join(FTC.full.final, by=c("column_names"))
  
  write.csv(FTC.all, paste0("alldattrial-",name, ".csv", sep="")) #Change append to name to define parameters used in FTC function: currently "trial"
  
}

for (i in 1:length(temp_dat)){
  cur.name=names(temp_dat)[i]
  FTC_data(x=temp_dat[[i]], 
           y=pos_dat[[i]], 
           name=cur.name,
           year=substr(cur.name, nchar(cur.name),nchar(cur.name)))
}
