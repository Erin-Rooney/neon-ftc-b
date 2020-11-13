#Erin C Rooney
#NEON precip data - combining files
#Import - permafrost only
#Updated 11-13-2020

PRIPRE = read.csv("processed/Precip_allseasoncombo.csv")
SECPRE = read.csv("processed/Secprecip_allseasoncombo.csv")
# SECPRE = read.csv("processed/SECPRE_2017_2020_5cores.csv")

# tried to combine, didn't work
# precipcombo = PRIPRE %>% 
# left_join(dplyr::select(SECPRE, secPrecipBulk, 
#                         startDateTime, endDateTime, 
#                         siteID, verticalPosition, 
#                         horizontalPosition), by = "siteID", "verticalPosition", "horizontalPosition", "startDateTime", "startEndTime")

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
          panel.spacing.x = unit(1.5, "lines"), #facet spacing for x axis
          panel.spacing.y = unit(1.5, "lines"), #facet spacing for x axis
          strip.text.x = element_text(size=12, face="bold"), #facet labels
          strip.text.y = element_text(size=12, face="bold", angle = 270) #facet labels
    )
}

library(PNWColors)

PRIPRE %>% 
  filter(priPrecipBulk > 0) %>% 
  ggplot(aes(x=siteID, y=priPrecipBulk, color=priPrecipBulk, size=priPrecipBulk))+
  geom_point(alpha = 0.5, position = position_jitter(width = 0.16))+
  theme_er()+
  scale_color_continuous(low = "blue", high = "pink")+  
  facet_grid(year~season)

SECPRE %>% 
  filter(secPrecipBulk > 0) %>% 
  ggplot(aes(x=siteID, y=secPrecipBulk, color=secPrecipBulk, size=secPrecipBulk))+
  geom_point(alpha = 0.5, position = position_jitter(width = 0.16))+
  theme_er()+
  scale_color_continuous(low = "blue", high = "pink")+  
  facet_grid(year~season)
