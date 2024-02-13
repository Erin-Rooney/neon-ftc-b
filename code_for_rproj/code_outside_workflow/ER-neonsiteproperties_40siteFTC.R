#Freeze thaw across 40 NEON sites x Site properties
#EC Rooney
#11 22 2022

#packages
source("code/0-packages.R")
# library(plotly)
# library(reshape2)
# library(metR)
library(NatParksPalettes)


#load data
sommos_sites = read.csv("processed/SOMMOS_Site_11-25-19.csv") 
ftc_4_1_5C = read_rds('processed/final_dat_4hr_1.5mag.RData')
#sommos_horizon = read.csv('processed/SOMMOS_Horizon.csv')
sommos_om = read.csv("processed/SOMMOS_horizonation.csv") %>% select(c(site_ID, plot, horizon,
                                                                    top_depth.cm, bottom_depth.cm, 
                                                                    thickness.cm))

ftc_4_1_5C %>% 
  ggplot()+
  geom_violin(aes(x = as.Date(date2), y = thaw_depth_cm, group = as.Date(date2), fill = Site), alpha = 0.4)+
  labs(x = "Date",
       y = "Thaw Depth, cm")+
  geom_rect(aes(xmin=as_date('2021-06-15'), xmax= as_date('2021-08-09'), ymin=49.5, ymax=50.5), fill = "black")+
  #scale_fill_gradientn(colors = natparks.pals(name = "Banff"))+
  scale_fill_manual(values = c("#9a031e", "#40916c", "#118ab2"))+
  scale_x_date(date_breaks = "1 week", date_labels = "%b-%d")+
  ylim(90, 0)+
  facet_grid(Site~Area)+
  theme_er1()+
  theme(legend.position = "none", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9))

combo_ftc_siteproperties =
  sommos_sites %>% 
  # dplyr::select(site, biome_Whittaker, site_name_full, management, fire_management, 
  #               longitude.dec_deg, elevation.m, probable_soil_order_via_NRCS) %>% 
  rename(site_pos = site) %>% 
  left_join(ftc_4_1_5C)

combo_ftc_siteproperties %>% 
  filter(season != "NA" & Def1 > 0 & depth_m > -1) %>% 
  ggplot()+
  geom_violin(aes(x = biome_Whittaker, y = depth_m, group = biome_Whittaker, fill = biome_Whittaker), alpha = 0.4)+
  #geom_point(aes(x = biome_Whittaker, y = depth_m, color = Def1))+
  labs(x = "Biome",
       y = "Depth, m")+
  ylim(-1, 0)+
  scale_fill_manual(values = natparks.pals(name = "Yellowstone", 5))+
  facet_grid(.~season)+
  theme_er()+
  theme(legend.position = "none", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))

combo_ftc_siteproperties %>% 
  filter(season != "NA" & Def1 > 0 & depth_m > -0.25) %>% 
  ggplot()+
  geom_violin(aes(x = biome_Whittaker, y = Def1, group = biome_Whittaker, fill = biome_Whittaker), alpha = 0.4)+
  #geom_point(aes(x = biome_Whittaker, y = depth_m, color = Def1), size = 2)+
  labs(x = "Biome",
       y = "Depth, m")+
 # ylim(-0.25, 0)+
  scale_color_gradientn(colors = pnw_palette(name = "Sailboat"))+
  facet_grid(.~season)+
  theme_er()+
  theme(legend.position = "bottom", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))

combo_ftc_temp =
  combo_ftc_siteproperties %>% 
  dplyr::select(site_pos, 'Tmax01', 'Tmax02', 'Tmax03', 'Tmax04', 'Tmax05', 'Tmax06', 'Tmax07', 'Tmax08', 'Tmax09', 'Tmax10', 'Tmax11', 'Tmax12', 
                  'Tmin01', 'Tmin02', 'Tmin03', 'Tmin04', 'Tmin05', 'Tmin06', 'Tmin07', 'Tmin08', 'Tmin09', 'Tmin10', 'Tmin11', 'Tmin12',
                  'Tave01', 'Tave02', 'Tave03', 'Tave04', 'Tave05', 'Tave06', 'Tave07', 'Tave08', 'Tave09', 'Tave10', 'Tave11', 'Tave12') %>%
           tidyr::pivot_longer(
             cols = starts_with("T"),
             names_to = "Temp_ID",
             values_to = "Temp_C") %>%
           mutate(Temp_type = case_when(grepl("Tmax", Temp_ID)~"max",
                                        grepl("Tave", Temp_ID)~"ave",
                                        grepl("Tmin", Temp_ID)~"min")) %>% 
  filter(Temp_type != "ave") %>% 
  mutate(season = case_when(grepl("01", Temp_ID) ~ "winter",
                            grepl("12", Temp_ID) ~ "winter",
                            grepl("02", Temp_ID)~"winter",
                           grepl("03", Temp_ID)~"spring",
                           grepl("04", Temp_ID)~ "spring",
                           grepl("05", Temp_ID)~ "spring",
                           grepl("06", Temp_ID)~"summer",
                           grepl("07", Temp_ID)~"summer",
                           grepl("08", Temp_ID)~"summer",
                           grepl("09", Temp_ID)~"fall",
                           grepl("10", Temp_ID)~"fall",
                           grepl("11", Temp_ID)~"fall")) 
  
Tmax = 
  combo_ftc_temp %>% 
  filter(Temp_type == "max") %>% 
  group_by(site_pos, season) %>% 
  dplyr::summarise(temp_max = round(mean(Temp_C), 2))


Tmin = 
  combo_ftc_temp %>% 
  filter(Temp_type == "min") %>% 
  group_by(site_pos, season) %>% 
  dplyr::summarise(temp_min = round(mean(Temp_C), 2))

maxmin_ftc_temps =
  Tmax %>% 
  left_join(Tmin) 

diff_ftc_temps =
  Tmax %>% 
  left_join(Tmin) %>% 
  group_by(site_pos, season) %>% 
  dplyr::summarise(temp_diff = round(mean(temp_max - temp_min), 2)) 

                   
metadata =
  combo_ftc_siteproperties %>%
  select(site_pos, biome_Whittaker, elevation.m, 
         site_name_full, probable_soil_order_via_NRCS
         )
  

maxmin_metadata_ftc_temps =
  maxmin_ftc_temps %>% 
  left_join(ftc_4_1_5C) %>% 
  left_join(metadata) %>% 
  na.omit()


diff_metadata_ftc_temps =
  diff_ftc_temps %>% 
  left_join(ftc_4_1_5C) %>% 
  left_join(metadata) %>% 
  na.omit()
  
tempmin_ftcfig =
  maxmin_metadata_ftc_temps %>% 
  filter(Def1 > 0) %>% 
  ggplot()+
  geom_point(aes(x = temp_min, y = Def1, color = biome_Whittaker))+
  labs(x = "Minimum Temperature, C", y = "Freeze-thaw cycles")+
  facet_wrap(.~season, scales = "free_y")+
  scale_color_manual(values = natparks.pals(name = "Yellowstone", 5))+
  theme_er()+
  theme(legend.position = "right", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))


ggsave("output/mintemp_ftc.png", plot = tempmin_ftcfig, height = 6, width = 10)

tempmax_ftcfig =
  maxmin_metadata_ftc_temps %>% 
  filter(Def1 > 0) %>% 
  ggplot()+
  geom_point(aes(x = temp_max, y = Def1, color = biome_Whittaker))+
  labs(x = "Maximum Temperature, C", y = "Freeze-thaw cycles")+
  facet_wrap(.~season, scales = "free_y")+
  scale_color_manual(values = natparks.pals(name = "Yellowstone", 5))+
  theme_er()+
  theme(legend.position = "right", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))


ggsave("output/maxtemp_ftc.png", plot = tempmax_ftcfig, height = 6, width = 10)



diff_ftcfig =
  diff_metadata_ftc_temps %>% 
  filter(Def1 > 0) %>% 
  ggplot()+
  geom_point(aes(x = temp_diff, y = Def1, color = biome_Whittaker))+
  labs(x = "Max-Min Temperature difference, C", y = "Freeze-thaw cycles")+
  #facet_wrap(.~season, scales = "free_y")+
  scale_color_manual(values = natparks.pals(name = "Yellowstone", 5))+
  theme_er()+
  theme(legend.position = "right", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))


ggsave("output/difftemp_ftc.png", plot = diff_ftcfig, height = 6, width = 10)

ftc_top_50 =
  ftc_4_1_5C %>% 
  filter(depth_m > -0.5) %>% 
  rename(plot = core_pos) %>% 
  group_by(site_pos, plot) %>% 
  summarise(ftc = max(Def1)) %>% 
  left_join(diff_metadata_ftc_temps) %>% 
  dplyr::select(site_pos, plot, season, ftc, temp_diff, biome_Whittaker, elevation.m, site_name_full) %>% 
  na.omit()

om_thickness =
  sommos_om %>% 
  #distinguish organic horizons
  dplyr::mutate(organic = case_when(grepl("O", horizon)~"organic")) %>% 
  #filter out sites without any organic horizons
  filter(organic == organic) %>% 
  #get the maximum and minimum organic depth within each plot 
  group_by(site_ID, plot) %>% 
  dplyr::summarise(max_cm = max(bottom_depth.cm),
                   min_cm = min(bottom_depth.cm)) %>% 
  ungroup() %>% 
  rename(site_pos = site_ID) 

om_mapping =
  sommos_om %>% 
  #distinguish organic horizons
  dplyr::mutate(material = case_when(grepl("O", horizon)~"organic",
                grepl("A", horizon)~"mineral",
                grepl("B", horizon)~"mineral",
                grepl("C", horizon)~"mineral")) %>% 
  #filter out sites without any organic horizons
  #filter(organic == organic) %>% 
  #get the maximum and minimum organic depth within each plot 
  rename(site_pos = site_ID) %>% 
  rename(thickness_cm = thickness.cm) %>% 
  mutate(site_plot = paste0(site_pos, "-", plot)) %>% 
  left_join(metadata) 

om_mapping %>% 
  filter(biome_Whittaker == "Boreal forest") %>% 
  ggplot()+
  geom_col(aes(y = thickness_cm, x = site_plot, fill = material), group = site_plot, position = 'stack', width = 0.7)+
  labs(fill = "", color = "",
       y = "depth, cm",
       x = "plot")+
  facet_wrap(biome_Whittaker ~ .)+
  #scale_fill_manual(values = c("#D6AB7D", "#B3895D", "#B3895D", "#734F38", "#553725", "#482919", "#482919"))+
  theme_er()+
  theme(axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9), legend.position = "right")
  


# omthickness_ftcfig =
#   om_thickness %>% 
#   #filter(ftc > 0) %>% 
#   ggplot()+
#   geom_point(aes(x = ftc, y = max_cm, color = biome_Whittaker))+
#   labs(x = "Freeze-thaw cycles", y = "maximum OM thickness (cm)")+
#   facet_wrap(.~season, scales = "free_y")+
#   scale_color_manual(values = natparks.pals(name = "Yellowstone", 6))+
#   theme_er()+
#   theme(legend.position = "bottom", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
#         panel.border = element_rect(color="white",size=2, fill = NA))

# ggsave("output/OMthickness_ftc.png", plot = omthickness_ftcfig, height = 6, width = 10)


om_airtemp_ftc =
  ftc_top_50 %>% 
  left_join(om_thickness) 

omthickness_boreal_fig =
  om_airtemp_ftc %>% 
  #filter(biome_Whittaker == "Boreal forest") %>% 
  ggplot()+
  geom_col(aes(x = site_name_full, y = max_cm, fill = ftc))+
  labs(y = "OM thickness (cm)")+
  facet_wrap(biome_Whittaker ~ .)+
  scale_color_gradientn(colors = pnw_palette(name = "Sailboat"))+
  theme_er()+
  theme(legend.position = "right", axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90, size = 9),
        panel.border = element_rect(color="white",size=2, fill = NA))

ggsave("output/Oomthickness_boreal.png", plot = omthickness_boreal_fig, height = 6, width = 10)







# 
# 
# 
#   
# combo_ftc_pas =
#   combo_ftc_siteproperties %>% 
#   dplyr::select(site_pos, 'Tmax01', 'Tmax02', 'Tmax03', 'Tmax04', 'Tmax05', 'Tmax06', 'Tmax07', 'Tmax08', 'Tmax09', 'Tmax10', 'Tmax11', 'Tmax12', 
#                 'Tmin01', 'Tmin02', 'Tmin03', 'Tmin04', 'Tmin05', 'Tmin06', 'Tmin07', 'Tmin08', 'Tmin09', 'Tmin10', 'Tmin11', 'Tmin12',
#                 'Tave01', 'Tave02', 'Tave03', 'Tave04', 'Tave05', 'Tave06', 'Tave07', 'Tave08', 'Tave09', 'Tave10', 'Tave11', 'Tave12') %>%
#   tidyr::pivot_longer(
#     cols = starts_with("T"),
#     names_to = "Temp_ID",
#     values_to = "Temp_C") %>%
#   mutate(Temp_type = case_when(grepl("Tmax", Temp_ID)~"max",
#                                grepl("Tave", Temp_ID)~"ave",
#                                grepl("Tmin", Temp_ID)~"min"))
# 
# 

