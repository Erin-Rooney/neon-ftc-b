#Erin C Rooney
#Nov 3 2020

fall1 = read.csv("ALLSITETRIAL-fall1.csv")
spring1 = read.csv("ALLSITETRIAL-spring1.csv")
spring2 = read.csv("ALLSITETRIAL-spring2.csv")
summer1 = read.csv("ALLSITETRIAL-summer1.csv")
summer2 = read.csv("ALLSITETRIAL-summer2.csv")

allsite = 
  fall1 %>% 
  bind_rows(spring1,
            spring2,
            summer1,
            summer2)