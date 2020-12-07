# Erin C Rooney
# SOMMOS data

#load libraries-------------------------------
library(tidyverse)
library(PNWColors)
library(agricolae)

#load data-------------------------------------
site_csv = read.csv("processed/SOMMOS_Site.csv")
horizon_csv = read.csv("processed/SOMMOS_Horizon.csv")

# ggplot set up-----------------------------------
theme_er <- function() {  # this for all the elements common across plots
  theme_bw() %+replace%
    theme(legend.position = "bottom",
          #legend.key=element_blank(),
          #legend.title = element_blank(),
          legend.text = element_text(size = 12),
          legend.key.size = unit(1.5, 'lines'),
          panel.border = element_rect(color="black",size=2, fill = NA),
          plot.title = element_text(hjust = 0.5, size = 14),
          plot.subtitle = element_text(hjust = 0.5, size = 12, lineheight = 1.5),
          axis.text = element_text(size = 12, color = "black"),
          axis.title = element_text(size = 12, face = "bold", color = "black"),
          # formatting for facets
          panel.background = element_blank(),
          strip.background = element_rect(colour="white", fill="white"), #facet formatting
          axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90)
          #panel.spacing.x = unit(1.5, "lines"), #facet spacing for x axis
          #panel.spacing.y = unit(1.5, "lines"), #facet spacing for x axis
          #strip.text.x = element_text(size=12, face="bold"), #facet labels
          #strip.text.y = element_text(size=12, face="bold", angle = 270) #facet labels
    )
}

#ggplots------------------------------------------

site_csv %>% 
  ggplot() +
  geom_point(aes(x = biome_Whittaker, y = Tave01, color = site, size = 3, alpha = 0.5)) +
  geom_text(aes(x = biome_Whittaker, y = Tave01, label=site),hjust=0, vjust=0, angle=90) +
  labs(y = "Ave Temp 01", x = "Whittaker Biome")+
  theme(axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90))+
  facet_grid(.~probable_soil_order_via_NRCS)
 

site_csv %>% 
  ggplot() +
  geom_point(aes(y = elevation.m, x = Tave01, color = probable_soil_order_via_NRCS, size = 3, alpha = 0.5)) +
  #geom_text(aes(y = elevation.m, x = Tave01, label=site),hjust=0, vjust=0, angle=90) +
  labs(y = "Elevation, m", x = "Temp Average 01")+
  theme(axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90))
  #facet_grid(.~probable_soil_order_via_NRCS)

site_csv %>% 
  ggplot() +
  geom_point(aes(y = elevation.m, x = Tave01, color = probable_soil_order_via_NRCS, size = 3, alpha = 0.5)) +
  geom_text(aes(y = elevation.m, x = Tave01, label=site),hjust=0, vjust=0, angle=90) +
  labs(y = "Elevation, m", x = "Temp Average 01")+
  theme(axis.text.x = element_text (vjust = 0.5, hjust=1, angle = 90))
#facet_grid(.~probable_soil_order_via_NRCS)





