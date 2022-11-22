#SOMMOS horizonation OM thickness
# 2022 Feb. 01
# EC Rooney

#packages
source("code/0-packages.R")

#load data
sommos = read.csv("processed/SOMMOS_horizonation.csv") %>% select(c(site_ID, plot, horizon,
                                                                    top_depth.cm, bottom_depth.cm, 
                                                                    thickness.cm))

om_sommos_max = 
  sommos %>% 
  #distinguish organic horizons
  dplyr::mutate(organic = case_when(grepl("O", horizon)~"organic")) %>% 
  #filter out sites without any organic horizons
  filter(organic == organic) %>% 
  #get the maximum and minimum organic depth within each plot 
  group_by(site_ID, plot) %>% 
  dplyr::summarise(max = max(bottom_depth.cm),
                   min = min(thickness.cm)) %>% 
  ungroup() %>% 
  filter(max > 0) %>% 
  mutate(thickness = max) %>% 
  select(c(site_ID, plot, thickness))

om_sommos_min = 
  sommos %>% 
  #distinguish organic horizons
  dplyr::mutate(organic = case_when(grepl("O", horizon)~"organic")) %>% 
  #filter out sites without any organic horizons
  filter(organic == organic) %>% 
  #get the maximum and minimum organic depth within each plot 
  group_by(site_ID, plot) %>% 
  dplyr::summarise(max = max(bottom_depth.cm),
                   min = min(thickness.cm)) %>% 
  ungroup() %>% 
  filter(min < 0) %>% 
  mutate(thickness = min*(-1)) %>% 
  select(c(site_ID, plot, thickness))



om_sommos_mean =
  om_sommos_max %>%
  rbind(om_sommos_min) %>% 
  #calculate the mean and se lowest depth of organic horizon per site
  #calculate the number of plots with organic horizons per site
  group_by(site_ID) %>% 
  dplyr::summarise(mean = mean(thickness),
                   se = (sd(thickness)/sqrt(n())),
                   count = n())


om_sommos_none = 
  sommos %>% 
  #distinguish organic horizons
  dplyr::mutate(organic = case_when(grepl("O", horizon)~"1")) %>% 
  replace(is.na(.), 0)  %>% 
  group_by(site_ID) %>% 
  dplyr::summarise(max = max(organic)) %>%
  #filter out sites with organic horizons 
  filter(max < 1) %>% 
  rename(mean = max) %>% 
  dplyr::mutate(se = 0,
                count = 0)


om_finaldata = 
  om_sommos_mean %>% 
  rbind(om_sommos_none)
                   
om_finaldata %>%  knitr::kable()

write.csv(om_finaldata, "output/om_finaldata.csv", row.names = FALSE)

###
#september 6 2022

om_sommos_allorganic = 
  sommos %>% 
  #distinguish organic horizons
  dplyr::mutate(organic = case_when(grepl("O", horizon)~"organic")) %>% 
  #filter out sites without any organic horizons
  filter(organic == organic) 

write.csv(om_sommos_allorganic, "output/om_sommos_allorganichorizons.csv", row.names = FALSE)


