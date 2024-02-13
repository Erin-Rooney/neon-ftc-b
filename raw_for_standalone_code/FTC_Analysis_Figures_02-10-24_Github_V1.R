#Freeze-thaw analysis and figures - all SOMMOS NEON sites 
#Updated 12-31-23
#Updated for JGRB submission repository, February 2024

#Packages####
library(ggplot2)
library(dplyr)
library(usmap) #Note: needed to reinstall "sp" after update
library(ggforce)
library(naniar)
library(ggrepel)
library(caret) #for binary random forest predictions
library(mlbench) #for binary random forest predictions
library(devtools) #for Whittaker biome figure
install_github("valentinitnelav/plotbiomes")
library(plotbiomes)
library(ggalt)

#Load and process data#####

#1: FTCQuant data####
FTC_12_2 = readRDS("/.../final_dat_12hr_2mag_06-20-23.RData") #Deposited to Github
FTC_4_1.5 = readRDS("/.../final_dat_4hr_1.5mag_06-20-23.RData") #Deposited to Github

#2: SOMMOS site data import####

#SOMMOS sites (from SOMMOS database; parameters in addition to EDI derived from ClimateNA, Wang et al. 2012, https://doi.org/10.1175/JAMC-D-11-043.1) 
SOMMOS_Site_1 = read.csv("/.../SOMMOS_Site_06-07-23.csv") #40 x 13

#3: SOMMOS sites (from EDI)####
SOMMOS_Site_2 = read.csv("/.../SOMMOS_site_list.csv")

#Check if equivalent: 
#MAT 

MAT_1 = as.data.frame(SOMMOS_Site_1[,c("site","MAT")])
MAT_2 = as.data.frame(SOMMOS_Site_2[,c("site_id","MAT")])

all(MAT_1$MAT == MAT_2$MAT) #NIWO and NGPR out of order - ok! 

#4: Organic mat thickness####
organic = read.csv("/.../om_sommos_allorganichorizons.csv")

#Organic mat data processing
organic_max = organic %>% 
  dplyr::group_by(site_ID, plot) %>%
  dplyr::summarize(bottom_depth.cm = max(bottom_depth.cm))

mean_organic = 
  organic_max %>% 
  dplyr::group_by(site_ID) %>%
  dplyr::summarize(mean_organic_mat.cm = mean(bottom_depth.cm), sd_organic_mat.cm = sd(bottom_depth.cm, na.rm=TRUE), n = n())

colnames(mean_organic)=c("site","mean_organic_mat.cm", "sd_organic_mat.cm","n_points_organic_mat")

#Combine with SOMMOS site data 
SOMMOS_Site_1$site = ifelse(SOMMOS_Site_1$site == "NGPR", "NOGP", SOMMOS_Site_1$site)
SOMMOS_Site_1$site = as.factor(SOMMOS_Site_1$site) #40

mean_organic$site = ifelse(mean_organic$site == "NGPR", "NOGP", mean_organic$site)
mean_organic$site = as.factor(mean_organic$site) #17

organic_site = mean_organic %>% right_join(SOMMOS_Site_1, by="site")
organic_site$mean_organic_mat.cm = ifelse(is.na(organic_site$mean_organic_mat.cm), 0, organic_site$mean_organic_mat.cm)
dim(organic_site) #40

#Check plot
h = ggplot(organic_site)
h + geom_boxplot(aes(x=mean_organic_mat.cm, y=biome_Whittaker))

#Biome grouping####

#Grouped manually based on biome plot
#Tundra and boreal forest - cold and dry
#Temperate rain forest, temperate seasonal forest, tropical seasonal forest/savanna - warm and wet
#temperate grassland/desert, subtropical desert, woodland/shrubland - warm and dry

#1: Biome grouping procedure####
Whittaker_biomes_mod = Whittaker_biomes
Whittaker_biomes_mod$precp_cm = Whittaker_biomes_mod$precp_cm * 10

plot_1 <- ggplot() +
  # add biome polygons
  geom_polygon(data = Whittaker_biomes_mod,
               aes(x    = temp_c,
                   y    = precp_cm,
                   fill = biome),
               # adjust polygon borders
               colour = "gray98",
               size   = 1) +
  geom_point(data = organic_site, 
             aes(x = MAT, 
                 y = MAP,
                 fill = biome_Whittaker), pch = 21) + 
  theme_bw() 

#Groups assigned to SOMMOS_use based on plot_1
organic_site$climate_group = ifelse(organic_site$biome_Whittaker == "Tundra" | organic_site$biome_Whittaker == "Boreal forest", "Cold and dry", NA)

organic_site$climate_group = ifelse(organic_site$biome_Whittaker == "Temperate rain forest" | organic_site$biome_Whittaker == "Temperate seasonal forest" | organic_site$biome_Whittaker == "Tropical seasonal forest/savanna", "Warm and wet", organic_site$climate_group)

organic_site$climate_group = ifelse(organic_site$biome_Whittaker == "Temperate grassland/desert" | organic_site$biome_Whittaker == "Subtropical desert" | organic_site$biome_Whittaker == "Woodland/shrubland", "Warm and dry", organic_site$climate_group)

#2: Fig 1: Final biome plot####
plot_2 <- ggplot() +
  # add biome polygons
  geom_polygon(data = Whittaker_biomes_mod,
               aes(x    = temp_c,
                   y    = precp_cm,
                   fill = biome),
               # adjust polygon borders
               colour = "gray98",
               size   = 1, 
               show.legend = FALSE) +
  geom_encircle(data = organic_site, aes(x = MAT, y = MAP, group = climate_group), fill="grey50", alpha=0.4, size=2) +
  geom_point(data = organic_site, 
             aes(x = MAT, 
                 y = MAP,
                 fill = biome_Whittaker,
                 shape = climate_group), show.legend=TRUE, size = 3.5, stroke = 1) +
  scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#317A22","#A09700","#C1E1DD","#D16E3F")) + 
  guides(fill = guide_legend(override.aes = list(pch = 22, size = 5, stroke = 0))) +
  scale_shape_manual(values = c(22,23,24)) + 
  labs(x = "MAT (degrees C)", y = "MAP (mm)", shape = "Climate group", fill = "Whittaker biome", linetype = "Climate group") + 
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"),
        axis.title=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"), 
        legend.title=element_text(size=14, color="black"))

pdf("...", width=8.5, height=5)
print(plot_2)
dev.off() 

#Check plot
h = ggplot(organic_site)
h + geom_boxplot(aes(x=climate_group, y=mean_organic_mat.cm))

#Count n by group 
group = organic_site %>% dplyr::group_by(climate_group) %>% dplyr::summarize(n = n())

#3: Fig. S2: Plots of predictors/site characteristics by biome and climate group####

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=MAT)) + 
        geom_point(aes(x=climate_group, y=MAT, fill=biome_Whittaker), pch=21, size=3.5) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) +  
        theme_bw() + 
        labs(y=expression(paste("MAT (",degree,"C)")), fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=MAP)) + 
        geom_point(aes(x=climate_group, y=MAP, fill=biome_Whittaker), pch=21, size=3.5) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        theme_bw() + 
        labs(y="MAP (mm)", fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=MAP_Eref)) + 
        geom_point(aes(x=climate_group, y=MAP_Eref, fill=biome_Whittaker), pch=21, size=3.5) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        theme_bw() + 
        labs(y="MAP-Eref (mm)", fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=PAS)) + 
        geom_point(aes(x=climate_group, y=PAS, fill=biome_Whittaker), pch=21, size=3) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        theme_bw() + 
        labs(y="PAS (mm)", fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=diff_all)) + 
        geom_point(aes(x=climate_group, y=diff_all, fill=biome_Whittaker), pch=21, size=3.5) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        theme_bw() + 
        labs(y=expression(paste("Max-min air temp. (",degree,"C)")), fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=8.5, height=4)
print(ggplot(FTC_max_all) + 
        geom_boxplot(aes(x=climate_group, y=mean_organic_mat.cm)) + 
        geom_point(aes(x=climate_group, y=mean_organic_mat.cm, fill=biome_Whittaker), show.legend=TRUE, pch=21, size=3.5) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        theme_bw() + 
        labs(y="Mean organic mat thickness (cm)", fill="Whittaker biome") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_blank(), 
              axis.title.y=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"), 
              legend.title=element_text(size=14, color="black")))
dev.off() 

#4: Table S1: Site names and biomes, climate groups####

dim(organic_site)

organic_site$Tdiff = organic_site$MWMT - organic_site$MCMT 

site_table = organic_site[,c("site","latitude.dec_deg", "longitude.dec_deg", "biome_Whittaker","climate_group","MAT","Tdiff","MAP","MAP_Eref","PAS","mean_organic_mat.cm")]

head(site_table)

write.csv(site_table, "...")

#5: Table S2: Full site names####

site_names = organic_site[,c("site","site_name_full")]

write.csv(site_names, "/.../")

#6: FTC sensor table####

exclude_dat <- filter(FTC_12_2, Label == "Exclude")

exclude_summary = 
  exclude_dat %>% 
  dplyr::group_by(site, depth, season, year) %>%
  dplyr::summarize(n = n())

exclude_summary$all_excluded <- ifelse(exclude_summary$n == 5, "Y","N")

write.csv(exclude_summary, "/.../")

#FTC descriptive data#####

#1: Combined data####

FTC_combined = rbind(FTC_12_2, FTC_4_1.5)

FTC_combined$dur.vec.hr = factor(FTC_combined$dur.vec.hr, levels=c("4","12"), labels=c("4-hr FTC","12-hr FTC"))

#Combined with site data -- need to rename SOMMOS_Site NGPR = NOGP 

FTC_combined$site = as.factor(FTC_combined$site) #40

FTC_site = FTC_combined %>% right_join(organic_site, by=c("site"))

#Check plots
h = ggplot(FTC_site)
h + geom_boxplot(aes(x=climate_group, y=Def1))

#2: Fig S3: Depth distribution####

pdf("...", width=6, height=3.5)
print(ggplot(FTC_combined) + 
        geom_point(aes(x=Def1, y=depth_m), pch=21, size=3) + 
        facet_grid(.~dur.vec.hr) + 
        theme_bw() + 
        labs(x="Freeze-thaw cycles (count)", y="Depth (m)") + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black"), 
              strip.text=element_text(size=14, color="black")))
dev.off() 

#3: Fig S4: Histogram of 4 and 12-hr####

#4-hr histogram
pdf("...", width=6, height=4)
print(ggplot() +
        geom_histogram(data=subset(FTC_combined, dur.vec.hr == "4-hr FTC"), aes(Def1), col="black", fill="darkcyan") + 
        labs(x="4-hr FTC", y="Count") +
        facet_zoom(ylim = c(0, 750)) + 
        theme(panel.background = element_blank(),
              axis.line.x=element_line(color="black"),
              axis.line.y=element_line(color="black"),
              axis.text=element_text(size=12, color="black"),
              axis.title=element_text(size=12, color="black"), 
              plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"))) 
dev.off() 

#12-hr histogram
pdf("...", width=6, height=4)
print(ggplot() +
        geom_histogram(data=subset(FTC_combined, dur.vec.hr == "12-hr FTC"), aes(Def1), col="black", fill="darkcyan") + 
        labs(x="12-hr FTC", y="Count") +
        facet_zoom(ylim = c(0, 750)) +
        theme(panel.background = element_blank(),
              axis.line.x=element_line(color="black"),
              axis.line.y=element_line(color="black"),
              axis.text=element_text(size=12, color="black"),
              axis.title=element_text(size=12, color="black"), 
              plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"))) 
dev.off() 

#4: Fig. 2: Correlation between 4hr and 12hr cycles#####
FTC_4_12_corr = cor.test(FTC_12_2$Def1, FTC_4_1.5$Def1, method="spearman", continuity = TRUE)
FTC_4_12_corr

#Relationship by biome
# [1] "Boreal forest"                    "Subtropical desert"               "Temperate grassland/desert"      
# [4] "Temperate rain forest"            "Temperate seasonal forest"        "Tropical seasonal forest/savanna"
# [7] "Tundra"                           "Woodland/shrubland"   
#All biomes
FTC_12 = filter(FTC_site, dur.vec.hr == "12-hr FTC") 
FTC_4 = filter(FTC_site, dur.vec.hr == "4-hr FTC")

# #Check NOGP 
# NOGP = subset(FTC_12, site == "NOGP") #Max FTC = 1
# NOGP_4 = subset(FTC_4, site == "NOGP") #Max FTC = 3

#Temperate seasonal forest
FTC_12_TSF = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Temperate seasonal forest")
FTC_4_TSF = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Temperate seasonal forest")

#Boreal forest
FTC_12_BF = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Boreal forest")
FTC_4_BF = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Boreal forest") 

#Subtropical desert
FTC_12_SD = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Subtropical desert")
FTC_4_SD = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Subtropical desert") 

#Temperate grassland/desert
FTC_12_TGD = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Temperate grassland/desert")
FTC_4_TGD = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Temperate grassland/desert") 

#Temperate rain forest
FTC_12_TRF = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Temperate rain forest")
FTC_4_TRF = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Temperate rain forest") 

#Tropical seasonal forest/savanna
FTC_12_TSFS = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Tropical seasonal forest/savanna")
FTC_4_TSFS = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Tropical seasonal forest/savanna") 

#Tundra
FTC_12_T = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Tundra")
FTC_4_T = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Tundra") 

#Woodland/shrubland
FTC_12_WS = filter(FTC_site, dur.vec.hr == "12-hr FTC", biome_Whittaker == "Woodland/shrubland")
FTC_4_WS = filter(FTC_site, dur.vec.hr == "4-hr FTC", biome_Whittaker == "Woodland/shrubland") 

# Tundra                    Boreal forest        Temperate seasonal forest 
# "#C1E1DD"                        "#A5C790"                        "#97B669" 
# Temperate rain forest             Tropical rain forest Tropical seasonal forest/savanna 
# "#75A95E"                        "#317A22"                        "#A09700" 
# Subtropical desert       Temperate grassland/desert               Woodland/shrubland 
# "#DCBB50"                        "#FCD57A"                        "#D16E3F" 

pdf("...", width=3, height=3)
print(ggplot() + 
  geom_point(aes(x = FTC_12_TSF$Def1, y = FTC_4_TSF$Def1), size=3, pch=21, fill="#97B669") + 
  labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
  ggtitle("Temperate seasonal forest") + 
  theme_bw() + 
  scale_y_continuous(limits=c(0,70)) +
  scale_x_continuous(limits=c(0,6)) + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black")))
dev.off() 
  
pdf("...", width=3, height=3)
print(ggplot() + 
  geom_point(aes(x = FTC_12_BF$Def1, y = FTC_4_BF$Def1), size=3, pch=21, fill="#A5C790") + 
  labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
  ggtitle("Boreal forest") + 
  scale_y_continuous(limits=c(0,70)) +
  scale_x_continuous(limits=c(0,6)) +
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black"))) 
dev.off() 

pdf("...", width=3, height=3)
print(ggplot() + 
  geom_point(aes(x = FTC_12_TGD$Def1, y = FTC_4_TGD$Def1), size=3, pch=21, fill="#FCD57A") + 
  labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
  ggtitle("Temperate grassland/desert") + 
  scale_y_continuous(limits=c(0,70)) +
  scale_x_continuous(limits=c(0,6)) +
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=3, height=3)
print(ggplot() + 
  geom_point(aes(x = FTC_12_T$Def1, y = FTC_4_T$Def1), size=3, pch=21, fill="#C1E1DD") + 
  labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
  ggtitle("Tundra") + 
  scale_y_continuous(limits=c(0,70)) +
  scale_x_continuous(limits=c(0,6)) +
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black")))
dev.off()

pdf("...", width=3, height=3)
print(ggplot() + 
  geom_point(aes(x = FTC_12_WS$Def1, y = FTC_4_WS$Def1), size=3, pch=21, fill="#D16E3F") + 
  labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
  ggtitle("Woodland/shrubland") + 
  scale_y_continuous(limits=c(0,70)) +
  scale_x_continuous(limits=c(0,6)) +
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black")))
dev.off()

#All 4 vs. 12
pdf("...", width=3, height=3)
print(ggplot() + 
        geom_point(aes(x = FTC_12$Def1, y = FTC_4$Def1), size=3, pch=21, fill="black") + 
        labs(x="FTC, 12 hr duration (count)", y="FTC, 4 hr duration (count)") + 
        ggtitle("All biomes") + 
        scale_y_continuous(limits=c(0,70)) +
        scale_x_continuous(limits=c(0,6)) +
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black")))
dev.off()

#Filtered data: patterns across sites####

#1: Top 0-0.5 m, 4-hr cycles####

FTC_surface = filter(FTC_site, depth_m > -0.5 & dur.vec.hr == "4-hr FTC" & Label == "Keep")

#2: Fig. 3: Surface FTC by biome and climate group####

#Data for plot only: 
plot_dat = FTC_surface
plot_dat$biome_Whittaker = factor(plot_dat$biome_Whittaker, levels=c("Temperate grassland/desert", "Woodland/shrubland","Boreal forest","Temperate seasonal forest","Tundra","Tropical seasonal forest/savanna","Temperate rain forest","Subtropical desert"))
plot_dat$climate_group = factor(plot_dat$climate_group, levels=c("Warm and wet","Cold and dry","Warm and dry"))

pdf("...", width = 8, height = 6)
print(ggplot(plot_dat) + 
        geom_violin(aes(x=Def1, y=biome_Whittaker, fill=biome_Whittaker), show.legend=FALSE) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#A09700","#C1E1DD","#D16E3F")) + 
        facet_grid(climate_group~., scales="free_y") + 
        labs(x="Freeze-thaw cycles in upper 50 cm (count)") + 
        theme_bw() + 
        theme(panel.grid=element_blank(),
              legend.title=element_blank(),
              axis.title.y=element_blank(),
              strip.text=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black")))
dev.off() 

#3: Fig. S5: Surface FTC by biome, climate group, and season####

names <- as_labeller(c("Warm and wet" = "Warm and wet", "Cold and dry" = "Cold and dry", "Warm and dry" = "Warm and dry", "fall" = "Fall", "spring" = "Spring","summer" = "Summer", "winter" = "Winter"))

pdf("...", width = 9, height = 6)
print(ggplot(FTC_surface_biome) + 
        geom_violin(aes(x=Def1, y=biome_Whittaker, fill=biome_Whittaker), show.legend=FALSE) + 
        scale_fill_manual(values=c("#A5C790","#DCBB50","#FCD57A","#75A95E","#97B669","#317A22","#A09700","#C1E1DD","#D16E3F")) + 
        facet_grid(climate_group~season, labeller = names, scales="free_y") + 
        labs(x="Freeze-thaw cycles in upper 50 cm (count)") + 
        theme_bw() + 
        theme(panel.grid=element_blank(),
              legend.title=element_blank(),
              axis.title.y=element_blank(),
              strip.text=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black")))
dev.off() 

#4: Fig. S10: HEAL and BONA only####
pdf("...", width = 9, height = 6)
print(ggplot(subset(plot_dat, site == "HEAL" | site == "BONA")) + 
        geom_point(aes(x=Def1, y=depth_m, fill=site), show.legend=TRUE, pch=21) + 
        facet_grid(.~season) + 
        labs(x="Freeze-thaw cycles in upper 50 cm (count)") +
        theme_bw() + 
        theme(panel.grid=element_blank(),
              legend.title=element_blank(),
              axis.title.y=element_blank(),
              strip.text=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black")))
dev.off() 

#4: Fig. S10: Boreal forest only####

boreal <- subset(plot_dat, biome_Whittaker == "Boreal forest")

boreal$permafrost <- ifelse(boreal$site == "BONA" | boreal$site == "HEAL", "Permafrost", "Non-permafrost")

pdf("...", width = 9, height = 6)
print(ggplot(boreal) + 
        geom_point(aes(x=Def1, y=depth_m, fill=site), show.legend=TRUE, pch=21, size=3, alpha=0.5) + 
        facet_grid(.~season) + 
        labs(x="Freeze-thaw cycles in upper 50 cm (count)") +
        theme_bw() + 
        theme(panel.grid=element_blank(),
              legend.title=element_blank(),
              axis.title.y=element_blank(),
              strip.text=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black")))
dev.off() 

#4: Fig. 4: Individual site plots - see FTC_All_Sites R code####

#CPER (grassland?)
#TOOL (tundra)
#BARR (boreal forest)
#BART (temperate forest, colder)
#SERC (temperate forest, warmer)
#DSNY (warm and wet)

#5: Fig. 5: Map and ranking of maximum FTC####

#Maximum FTC calculation - by season
FTC_max = FTC_surface %>%
  dplyr::group_by(season, site) %>%
  dplyr::summarise(FTC_max = max(Def1, na.rm=TRUE), n = n()) 

#Merge SOMMOS_Site and organic mat data with maximum FTC per site
dim(FTC_max)
FTC_max$FTC_presence = as.factor(ifelse(FTC_max$FTC_max == 0, 0, 1))
FTC_max$FTC_presence_num = as.numeric(ifelse(FTC_max$FTC_max == 0, 0, 1))

#SOMMOS site data
FTC_max_all = FTC_max %>% right_join(organic_site, by="site")

#Difference vars
FTC_max_all$diff_all = FTC_max_all$MWMT - FTC_max_all$MCMT

#Replace missing organic mat NAs with 0s
FTC_max_all$mean_organic_mat.cm = ifelse(is.na(FTC_max_all$mean_organic_mat.cm), 0, FTC_max_all$mean_organic_mat.cm)

season_names <- as_labeller(c("fall" = "Fall", "spring" = "Spring","summer" = "Summer", "winter" = "Winter"))

#Max FTC by site and season
levels = reorder(FTC_max$site, FTC_max$FTC_max)
pdf("...", width = 6, height = 8)
print(ggplot(FTC_max) + 
        geom_point(aes(x=FTC_max, y=site, fill=season), pch=21, alpha=0.5, size=4) +
        scale_fill_viridis_d(labels=season_names) + 
        labs(x="Maximum freeze-thaw cycles (< 50 cm depth)", fill="Season") + 
        scale_y_discrete(limits=levels(levels)) + 
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              legend.title=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black"), 
              axis.title.y=element_blank()))
dev.off() 

#5a: Overall max FTC####
FTC_max_site = FTC_max_all %>%
  dplyr::group_by(site) %>%
  dplyr::summarise(FTC_max = max(FTC_max, na.rm=TRUE), n = n()) 

FTC_max_site_all = FTC_max_site %>% right_join(organic_site, by="site")

#Apply to FTC_max_site
FTC_max_site_all$climate_group = ifelse(FTC_max_site_all$biome_Whittaker == "Tundra" | FTC_max_site_all$biome_Whittaker == "Boreal forest", "Cold and dry", NA)

FTC_max_site_all$climate_group = ifelse(FTC_max_site_all$biome_Whittaker == "Temperate rain forest" | FTC_max_site_all$biome_Whittaker == "Temperate seasonal forest" | FTC_max_site_all$biome_Whittaker == "Tropical seasonal forest/savanna", "Warm and wet", FTC_max_site_all$climate_group)

FTC_max_site_all$climate_group = ifelse(FTC_max_site_all$biome_Whittaker == "Temperate grassland/desert" | FTC_max_site_all$biome_Whittaker == "Subtropical desert" | FTC_max_site_all$biome_Whittaker == "Woodland/shrubland", "Warm and dry", FTC_max_site_all$climate_group)

levels_all = reorder(FTC_max_site_all$site, FTC_max_site_all$FTC_max)

#Climate group colors
#c("#5F9EA0","#D38E17","#4B8E17")) 

pdf("...", width = 4.75, height = 7)
print(ggplot(FTC_max_site_all) + 
        geom_point(aes(x=FTC_max, y=site, fill=climate_group, shape=climate_group), size=4, show.legend=FALSE) +
        #scale_fill_viridis_d(labels=season_names) + 
        scale_shape_manual(values = c(21,23,25)) + 
        scale_fill_manual(values = c("#5F9EA0","#D38E17","#4B8E17")) + 
        labs(x="Maximum freeze-thaw cycles (< 50 cm depth)") + 
        scale_y_discrete(limits=levels(levels_all)) + 
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              legend.title=element_text(size=14, color="black"), 
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title.x=element_text(size=14, color="black"), 
              axis.title.y=element_blank()))
dev.off() 

#5b: Site map of overall max FTC#####

site_map = organic_site[,c("longitude.dec_deg","latitude.dec_deg","site")]
colnames(site_map) = c("lon","lat","site") 

site_dat = FTC_max_site_all %>% right_join(site_map, by=c("site"))
site_dat = as.data.frame(site_dat[,c("lon","lat","site","FTC_max","climate_group")])

plot_dat_transformed = usmap_transform(site_dat)

pdf("...", height=6, width = 8)
print(plot_usmap() +
        geom_point(aes(x=x, y=y, size=FTC_max, fill=climate_group, shape=climate_group), data=plot_dat_transformed, color="black", show.legend=TRUE) +
        scale_shape_manual(values = c(21,23,25)) + 
        scale_fill_manual(values = c("#5F9EA0","#D38E17","#4B8E17")) + 
        scale_size_continuous(range = c(2,6)) + 
        guides(fill = guide_legend(override.aes = list(size = 3))) + 
        #geom_label_repel(aes(x=lon.1, y=lat.1, label=site), data=plot_dat_transformed, size=3, point.padding = 0.2) + 
        # scale_fill_gradient2(low="white","blue", midpoint=0.05, guide = guide_colourbar(barwidth=20, barheight=1, direction = "horizontal", reverse = FALSE, title.position="top", ticks=FALSE, label=TRUE)) +
        #scale_fill_viridis_c(option="inferno", guide = guide_colourbar(barwidth=20, barheight=1, direction = "horizontal", reverse = FALSE, title.position="top", ticks=FALSE, label=TRUE)) +
        theme(legend.position=c(0.9,0.15),
              plot.margin = unit(c(2,2,2,2), "cm"), 
              legend.title = element_blank(), 
              legend.text = element_text(size=10, color="black")))
dev.off() 


pdf("...", height=6, width = 8)
print(plot_usmap() +
        geom_point(aes(x=x, y=y, size=FTC_max, fill=climate_group, shape=climate_group), data=plot_dat_transformed, color="black", show.legend=TRUE) +
        geom_label_repel(aes(x=x, y=y, label=site), data=plot_dat_transformed) + 
        scale_shape_manual(values = c(21,23,25)) + 
        scale_fill_manual(values = c("#5F9EA0","#D38E17","#4B8E17")) + 
        scale_size_continuous(range = c(2,6)) + 
        guides(fill = guide_legend(override.aes = list(size = 3))) + 
        #geom_label_repel(aes(x=lon.1, y=lat.1, label=site), data=plot_dat_transformed, size=3, point.padding = 0.2) + 
        # scale_fill_gradient2(low="white","blue", midpoint=0.05, guide = guide_colourbar(barwidth=20, barheight=1, direction = "horizontal", reverse = FALSE, title.position="top", ticks=FALSE, label=TRUE)) +
        #scale_fill_viridis_c(option="inferno", guide = guide_colourbar(barwidth=20, barheight=1, direction = "horizontal", reverse = FALSE, title.position="top", ticks=FALSE, label=TRUE)) +
        theme(legend.position=c(0.9,0.15),
              plot.margin = unit(c(2,2,2,2), "cm"), 
              legend.title = element_blank(), 
              legend.text = element_text(size=10, color="black")))
dev.off() 

#6: Fig. 6: Correlation with depth for sites with FTC####

#Modified plot names
biome_names <- as_labeller(c("Tundra" = "Tundra", "Temperate seasonal forest" = "Temp. seasonal forest","Boreal forest" = "Boreal forest", "Woodland/shrubland" = "Woodland/shrubland","Temperate grassland/desert" = "Temp. grassland/desert"))
season_names <- as_labeller(c("fall" = "Fall", "spring" = "Spring","summer" = "Summer", "winter" = "Winter"))

pdf("...", width = 10, height = 11)
print(ggplot(subset(FTC_surface_biome, biome_Whittaker == "Tundra" | biome_Whittaker == "Temperate seasonal forest" | biome_Whittaker == "Boreal forest" | biome_Whittaker == "Woodland/shrubland" | biome_Whittaker == "Temperate grassland/desert")) + 
        geom_point(aes(x=Def1, y=depth_m), pch=21, size=3) + 
        #scale_fill_viridis_c(option="viridis", direction=1, guide = guide_colourbar(barwidth=1, barheight=10, direction = "vertical", reverse = FALSE, title.position="top", ticks=FALSE, label=TRUE)) +  
        facet_grid(biome_Whittaker~season, labeller = labeller(biome_Whittaker = biome_names, season = season_names)) + 
        labs(x="Freeze-thaw cycles < 50 cm (count)", y="Depth (m)") + 
        theme_bw() + 
        theme(panel.grid=element_blank(),
              strip.text=element_text(size=12, color="black"), 
              legend.title=element_text(size=14, color="black"),
              legend.text=element_text(size=14, color="black"),
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black")))
dev.off() 

#7: Max FTC for cold and dry sites 

tundra <- filter(FTC_max_all, biome_Whittaker == "Tundra")
tundra_spring <- filter(FTC_max_all, biome_Whittaker == "Tundra" & season == "spring")
tundra_fall <- filter(FTC_max_all, biome_Whittaker == "Tundra" & season == "fall")

max_tundra <- max(tundra$FTC_max, na.rm=TRUE)
max_tundra_spring <- max(tundra_spring$FTC_max, na.rm=TRUE)
max_tundra_fall <- max(tundra_fall$FTC_max, na.rm=TRUE)

boreal <- filter(FTC_max_all, biome_Whittaker == "Boreal forest")
boreal_spring <- filter(FTC_max_all, biome_Whittaker == "Boreal forest" & season == "spring")
boreal_fall <- filter(FTC_max_all, biome_Whittaker == "Boreal forest" & season == "fall")

min_tundra_spring <- max(tundra_spring$FTC_max, na.rm=TRUE)
min_tundra_fall <- max(tundra_fall$FTC_max, na.rm=TRUE)


#Statstical analysis of max FTC- relationships with climate variables by biome by season#######

#This contrasts the presence or absence of 4hr FTC across any season, year in the upper 50 cm 

#1: Fig. 7 and Table 1: Binomial model####

model_dat = FTC_max_all[c("site","FTC_presence","FTC_presence_num","climate_group","MAT","MAP","MAP_Eref","diff_all","PAS","mean_organic_mat.cm")]

#Test
# x = model_dat[,c("MAT")]
# var = "MAT"

binomial.mod = function(x,var) {
  
  #Model 
  FTC_glm = glm(FTC_presence ~ x*climate_group, data=model_dat, family="binomial")
  anova = as.data.frame(anova(FTC_glm, test="Chisq"))
  anova$var = rep(var, nrow(anova))
  
  #Write ANOVA table
  setwd("/.../Binomial Models/ANOVA")
  write.csv(anova, paste0(var,"-ANOVA.csv"))
  
  #Predictions and plot
  data = model_dat[,c("site","climate_group",var)] 
  data$prediction = predict(FTC_glm, newdata=data, type="response")
  
  #Write prediction table
  setwd("/.../Binomial Models/Predictions")
  write.csv(data, paste0(var,"-pred.csv"))
  
 #Plots
  setwd("/.../Binomial Models/Plots")
  pdf(paste0(var,"-glm.pdf"), width=8, height=4)
  print(ggplot() + 
          geom_point(aes(x=x, y=FTC_presence_num), data=model_dat, size=3) + 
          #geom_point(aes(x=x, y=prediction), data=data, shape=18, color="blue", size=3) + 
          geom_line(aes(x=x, y=prediction), data=data, color="blue", size=1) + 
          facet_grid(.~climate_group) + 
          labs(x = var, y = "FTC likelihood (0-1)") + 
          theme_bw() + 
          theme(panel.grid=element_blank(), 
                axis.text=element_text(size=14, color="black"), 
                axis.title=element_text(size=14, color="black"), 
                strip.text=element_text(size=14, color="black")))
  dev.off() 
  
  #Plots - climate groups combined 
  setwd("/.../Binomial Models/Combined Plots")
  pdf(paste0(var,"-glm_comb.pdf"), width=4.5, height=3)
  print(ggplot() + 
          geom_point(aes(x=x, y=FTC_presence_num, fill=climate_group, shape=climate_group), data=model_dat, size=3.5, alpha=0.4) + 
          geom_line(aes(x=x, y=prediction, color=climate_group), data=data, size=1.5) + 
          scale_shape_manual(values = c(21,23,25)) + 
          scale_fill_manual(values = c("#5F9EA0","#D38E17","#4B8E17")) + 
          scale_color_manual(values = c("#5F9EA0","#D38E17","#4B8E17")) + 
          #facet_grid(.~climate_group) + 
          labs(x = var, fill="Climate group", shape="Climate group", color="Climate group", y = "FTC likelihood (0-1)") + 
          theme_bw() + 
          theme(panel.grid=element_blank(), 
                legend.title=element_text(size=12, color="black"), 
                legend.text=element_text(size=12, color="black"), 
                axis.text=element_text(size=12, color="black"), 
                axis.title=element_text(size=12, color="black"), 
                strip.text=element_text(size=12, color="black")))
  dev.off() 
  
}

for (i in 1:length(model_dat[,5:10])){
  binomial.mod(x=model_dat[,5:10][[i]], 
           var=colnames(model_dat[,5:10])[i])
  }

#Import to make combined table
setwd("/.../Binomial Models/ANOVA")
anova = list.files(pattern="*.csv")
myfiles = lapply(anova, read.csv)

combined_anova = do.call(rbind, myfiles)

setwd("/.../Binomial Models")
write.csv(combined_anova, "combined_anova.csv")

#2: Table 2 (MLR)####

#Sites with FTC present only

#Modified as of 12-31-23 to include overall performance metric

mlr_dat = FTC_max_all[c("site","FTC_max","season","climate_group","MAT","MAP","MAP_Eref","diff_all","PAS","mean_organic_mat.cm")]
mlr_dat = mlr_dat %>% filter(FTC_max > 0)

#Plot example of tested combinations 

h = ggplot(mlr_dat)
h + geom_point(aes(x=MAT, y=FTC_max)) + 
  facet_grid(season~climate_group)

#Combinations excluded: 
#Winter - cold and dry 
#Summer - all 
#Spring - warm and wet 
#Fall - warm and wet 

var = "MAT"

mlr.mod = function(var){
  
  #Winter#########
  
  #MLR 
  winter_dat = as.data.frame(filter(mlr_dat, season =="winter" & !(climate_group == "Cold and dry")))
  winter_dat$variable = winter_dat[,(var)]
  winter = lm(log(FTC_max) ~ variable*climate_group, data=winter_dat) 
  
  #Overall model R2
  winter_summary = summary(winter)
  winter.adj.R2 = winter_summary$adj.r.squared
  
  AdjR2 = as.data.frame(winter.adj.R2)
  AdjR2$season = rep("winter", nrow(AdjR2))
  AdjR2$variable = rep(var, nrow(AdjR2))
  colnames(AdjR2) = c("AdjR2","season","variable")
  
  #Write model R2 table
  setwd("/.../MLR Models/Adjusted R2")
  write.csv(AdjR2, paste0(var,"-AdjR2-winter.csv"))
  
  #ANOVA
  anova = as.data.frame(anova(winter)) 
  anova$season = rep("winter", nrow(anova))
  anova$variable = rep(var, nrow(anova))

  #Write ANOVA table
  setwd("/.../MLR Models/ANOVA/New ANOVA")
  write.csv(anova, paste0(var,"-ANOVA-winter.csv"))
  
  # #Spearman response table - effect direction and magnitude visualization for each individual combination 
  # 
  # warm_dry = subset(winter_dat, climate_group == "Warm and dry")
  # warm_wet = subset(winter_dat, climate_group == "Warm and wet")
  # 
  # x_1 = warm_dry[,(var)]
  # x_2 = warm_wet[,(var)]
  # 
  # spearman_1 = cor.test(warm_dry$FTC_max, x_1, method="spearman", continuity=TRUE)
  # spearman_2 = cor.test(warm_wet$FTC_max, x_2, method="spearman", continuity=TRUE)
  # 
  # spearman_r_1 = spearman_1$estimate
  # spearman_r_2 = spearman_2$estimate
  # spearman_r = as.data.frame(rbind(spearman_r_1, spearman_r_2))
  # 
  # spearman_p_1 = spearman_1$p.value
  # spearman_p_2 = spearman_2$p.value
  # spearman_p = as.data.frame(rbind(spearman_p_1, spearman_p_2))
  # 
  # spearman_winter = cbind(spearman_r, spearman_p$V1)
  # spearman_winter$season = rep("winter", nrow(spearman_winter))
  # spearman_winter$climate_group = c("Warm and dry", "Warm and wet")
  # spearman_winter$variable = rep(var, nrow(spearman_winter))
  
  #Spring#############
  spring_dat = as.data.frame(filter(mlr_dat, season =="spring" & !(climate_group == "Warm and wet")))
  spring_dat$variable = spring_dat[,(var)]
  spring = lm(log(FTC_max) ~ variable*climate_group, data=spring_dat) 
  anova = as.data.frame(anova(spring)) 
  anova$season = rep("spring", nrow(anova))
  anova$variable = rep(var, nrow(anova))
  
  #Overall model R2
  spring_summary = summary(spring)
  spring.adj.R2 = spring_summary$adj.r.squared
  
  AdjR2 = as.data.frame(spring.adj.R2)
  AdjR2$season = rep("spring", nrow(AdjR2))
  AdjR2$variable = rep(var, nrow(AdjR2))
  colnames(AdjR2) = c("AdjR2","season","variable")
  
  #Write model R2 table
  setwd("/.../MLR Models/Adjusted R2")
  write.csv(AdjR2, paste0(var,"-AdjR2-spring.csv"))
  
  #Write ANOVA table
  setwd("/.../MLR Models/ANOVA/New ANOVA")
  write.csv(anova, paste0(var,"-ANOVA-spring.csv"))
  
  # #Spearman response table - effect direction and magnitude visualization for each individual combination 
  # warm_dry = subset(spring_dat, climate_group == "Warm and dry")
  # cold_dry = subset(spring_dat, climate_group == "Cold and dry")
  # 
  # x_1 = warm_dry[,(var)]
  # x_2 = cold_dry[,(var)]
  # 
  # spearman_1 = cor.test(warm_dry$FTC_max, x_1, method="spearman", continuity=TRUE)
  # spearman_2 = cor.test(cold_dry$FTC_max, x_2, method="spearman", continuity=TRUE)
  # 
  # spearman_r_1 = spearman_1$estimate
  # spearman_r_2 = spearman_2$estimate
  # spearman_r = as.data.frame(rbind(spearman_r_1, spearman_r_2))
  # 
  # spearman_p_1 = spearman_1$p.value
  # spearman_p_2 = spearman_2$p.value
  # spearman_p = as.data.frame(rbind(spearman_p_1, spearman_p_2))
  # 
  # spearman_spring = cbind(spearman_r, spearman_p$V1)
  # spearman_spring$season = rep("spring", nrow(spearman_spring))
  # spearman_spring$climate_group = c("Warm and dry", "Cold and dry")
  # spearman_spring$variable = rep(var, nrow(spearman_spring))
  
  #Fall################
  fall_dat = as.data.frame(filter(mlr_dat, season =="fall" & !(climate_group == "Warm and wet")))
  fall_dat$variable = fall_dat[,(var)]
  fall = lm(log(FTC_max) ~ variable*climate_group, data=fall_dat) 
  anova = as.data.frame(anova(fall)) 
  anova$season = rep("fall", nrow(anova))
  anova$variable = rep(var, nrow(anova))
  
  #Overall model R2
  fall_summary = summary(fall)
  fall.adj.R2 = fall_summary$adj.r.squared
  
  AdjR2 = as.data.frame(fall.adj.R2)
  AdjR2$season = rep("fall", nrow(AdjR2))
  AdjR2$variable = rep(var, nrow(AdjR2))
  colnames(AdjR2) = c("AdjR2","season","variable")
  
  #Write model R2 table
  setwd("/.../MLR Models/Adjusted R2")
  write.csv(AdjR2, paste0(var,"-AdjR2-fall.csv"))
  
  #Write ANOVA table
  setwd("/.../MLR Models/ANOVA/New ANOVA")
  write.csv(anova, paste0(var,"-ANOVA-fall.csv"))
  
  # #Spearman response table - effect direction and magnitude visualization for each individual combination 
  # warm_dry = subset(fall_dat, climate_group == "Warm and dry")
  # cold_dry = subset(fall_dat, climate_group == "Cold and dry")
  # 
  # x_1 = warm_dry[,(var)]
  # x_2 = cold_dry[,(var)]
  # 
  # spearman_1 = cor.test(warm_dry$FTC_max, x_1, method="spearman", continuity=TRUE)
  # spearman_2 = cor.test(cold_dry$FTC_max, x_2, method="spearman", continuity=TRUE)
  # 
  # spearman_r_1 = spearman_1$estimate
  # spearman_r_2 = spearman_2$estimate
  # spearman_r = as.data.frame(rbind(spearman_r_1, spearman_r_2))
  # 
  # spearman_p_1 = spearman_1$p.value
  # spearman_p_2 = spearman_2$p.value
  # spearman_p = as.data.frame(rbind(spearman_p_1, spearman_p_2))
  # 
  # spearman_fall = cbind(spearman_r, spearman_p$V1)
  # spearman_fall$season = rep("fall", nrow(spearman_fall))
  # spearman_fall$climate_group = c("Warm and dry", "Cold and dry")
  # spearman_fall$variable = rep(var, nrow(spearman_fall))
  # 
  # spearman = rbind(spearman_winter, spearman_spring, spearman_fall)
  # colnames(spearman) = c("cor","p.value","season","climate_group","variable")
  
  # #Spearman heatmap plot 
  # #Add stars to indicate p-value 
  # spearman$stars = ifelse(spearman$p.value < 0.001, "***","ns")
  # spearman$stars = ifelse(spearman$p.value > 0.001 & spearman$p.value < 0.05, "**",spearman$stars)
  # spearman$stars = ifelse(spearman$p.value > 0.05 & spearman$p.value < 0.10, "*", spearman$stars)
  # 
  # spearman$round = as.character(format(round(spearman$cor, digits=2), nsmall = 2))
  # 
  # setwd("/.../Spearman Correlation/Figures")
  # pdf(paste0(var, "-spearman_fig.pdf"), width=8, height=5)
  # print(ggplot(spearman) + 
  #         geom_tile(aes(x=climate_group, y=season, fill=cor)) + 
  #   scale_fill_gradient2(low="blue",high="red",mid="white", limits=c(-1,1)) + 
  #   geom_text(aes(x=climate_group, y=season, label=paste0(round, stars)), size=5) + 
  #   scale_y_discrete(labels = c("winter" = "Winter", "spring" = "Spring","fall" = "Fall")) + 
  #   labs(fill="Spearman's r") + 
  #   theme(panel.grid=element_blank(), 
  #         axis.text=element_text(size=14, color="black"), 
  #         axis.title=element_blank(), 
  #         legend.text=element_text(size=14, color="black"), 
  #         legend.title=element_text(size=14, color="black")))
  # dev.off()
  # 
  # #Write csv 
  # setwd("/.../Spearman Correlation/Tables")
  # write.csv(spearman, paste0(var,"-spearman.csv"))
  
}

for (i in 1:length(mlr_dat[,5:10])){
  mlr.mod(var=colnames(mlr_dat[,5:10])[i])
}

#Import to make combined table####
#Updated to check with old table
setwd("/.../MLR Models/ANOVA/New ANOVA")
anova = list.files(pattern="*.csv")
myfiles = lapply(anova, read.csv)

combined_anova_mlr = do.call(rbind, myfiles)

setwd("/.../MLR Models")
write.csv(combined_anova_mlr, "combined_anova_mlr_check.csv")

setwd("/.../MLR Models/Adjusted R2")
adjR2 = list.files(pattern="*.csv")
adjR2files = lapply(adjR2, read.csv)

combined_adjR2 = do.call(rbind, adjR2files)

setwd("/.../MLR Models")
write.csv(combined_adjR2, "combined_adjR2.csv")

#3: Fig. 8: Spearman Figure####
#Import to Spearman table
setwd("/.../Spearman Correlation/Tables")
spearman = list.files(pattern="*.csv")
myfiles = lapply(spearman, read.csv)

combined_spearman = do.call(rbind, myfiles)

setwd("/.../Spearman Correlation/")

write.csv(combined_spearman, " combined_spearman.csv")

#Faceted by season############
# MAT
# Tdiff
# Organic mat thickness
# PAS
# MAP Eref
# MAP

labels = factor(combined_spearman$variable, levels=c("MAT","diff_all","mean_organic_mat.cm","PAS","MAP_Eref","MAP"))
combined_spearman$season = factor(combined_spearman$season, levels=c("fall","winter","spring"), labels=c("Fall","Winter","Spring"))

pdf("...", width=12.5, height=5.5)
print(ggplot(combined_spearman) + 
        geom_tile(aes(x=climate_group, y=variable, fill=cor)) + 
  facet_wrap(.~season, strip.position = "bottom") + 
  scale_fill_gradient2(low="blue",high="red",mid="white", limits=c(-1,1)) + 
  geom_text(aes(x=climate_group, y=variable, label=round), size=5) + 
  scale_x_discrete(position="top", labels=scales::wrap_format(10)) + 
  scale_y_discrete(limits=levels(labels), labels = c("MAT" = "MAT", "diff_all" = "Max-min temp.","mean_organic_mat.cm" = "Organic mat","PAS" = "PAS", "MAP_Eref" = "MAP-Eref","MAP" = "MAP")) + 
  labs(fill="Spearman's r") + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_blank(), 
        strip.text=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"), 
        legend.title=element_text(size=14, color="black")))
dev.off() 

#Correlation plots 

winter_dat = subset(mlr_dat, season == "winter" & !(climate_group == "Cold and dry"))
spring_dat = subset(mlr_dat, season == "spring" & !(climate_group == "Warm and wet"))
fall_dat = subset(mlr_dat, season == "fall" & !(climate_group == "Warm and wet"))

winter_MAP = lm(FTC_max~MAP, data=winter_dat)
spring_MAP = lm(FTC_max~MAP, data=spring_dat)


#Organic mat plot#########

org_mat_subset = subset(mlr_dat, climate_group == "Cold and dry" & season == "spring")

pdf("...", width=5, height=4)
print(ggplot(org_mat_subset) + 
        stat_smooth(aes(x=mean_organic_mat.cm, y=FTC_max), method="lm", color="black") + 
        geom_point(aes(x=mean_organic_mat.cm, y=FTC_max)) + 
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black")))
dev.off() 


org_mat_subset_2 = subset(mlr_dat, climate_group == "Warm and wet" & season == "winter")

pdf("...", width=5, height=4)
print(ggplot(org_mat_subset_2) + 
        stat_smooth(aes(x=mean_organic_mat.cm, y=FTC_max), method="lm", color="black") + 
        geom_point(aes(x=mean_organic_mat.cm, y=FTC_max)) + 
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black")))
dev.off()

#MAT and PAS correlation#####

pdf("...", width=5.5, height=5)
print(ggplot(subset(FTC_max_all, climate_group == "Warm and wet")) + 
  geom_point(aes(x=MAT, y=PAS), size=3) + 
  geom_vline(xintercept=15, linetype="longdash") + 
  labs(x=expression(paste("MAT ("," ",degree,"C)")), y="Precipitation as snow (mm)") + 
  theme_bw() + 
  theme(panel.grid=element_blank(), 
        axis.text=element_text(size=14, color="black"), 
        axis.title=element_text(size=14, color="black")))
dev.off() 

pdf("...", width=5.5, height=5)
print(ggplot(subset(FTC_max_all, climate_group == "Warm and wet")) + 
        geom_point(aes(x=MAT, y=FTC_max), size=3) + 
        geom_vline(xintercept=15, linetype="longdash") + 
        labs(x=expression(paste("MAT ("," ",degree,"C)")), y="Maximum FTC (count)") + 
        theme_bw() + 
        theme(panel.grid=element_blank(), 
              axis.text=element_text(size=14, color="black"), 
              axis.title=element_text(size=14, color="black")))
dev.off()



