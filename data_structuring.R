#install.packages(dplyr)
#install.packages("ggplot2")
require(dplyr)
require(ggplot2)

# Update Data

# read saved data#

US=read.csv("./Stone Age Covid project/data/raw_national_data.csv")
states=read.csv("./Stone Age Covid project/data/raw_state_data.csv")

US %>% names()

states %>% names()

setdiff(states %>% names(),US %>% names())
setdiff(US %>% names(),states %>% names())


US=US[order(US$date),]
                                                
US$date_p<-as.character(US$date)  %>% as.Date(format="%Y%m%d")
US$day=format(US$date_p,"%d") 
US$month=format(US$date_p,"%m") 
US$year=format(US$date_p,"%Y") 
US$week=format(US$date_p,"%V")
US$d_w=weekdays(US$date_p)

#US=US %>% filter(states==56) 
US=US %>% filter(date_p>=as.Date("2020-03-16")) # começando sem os dados onde nem todos os estados tinha publicado ainda
US<-US %>% select(setdiff(names(US),c("date","dateChecked","lastModified","recovered","total","posNeg","hash")))

US_validadte=US %>% filter(date_p<="2020-12-31" & date_p>="2020-12-01")
US_test_1d=US %>% filter(date_p=="2020-11-01" )
US_test_1w=US %>% filter(date_p<="2020-11-07" & date_p>="2020-11-01")
US_test_1m=US %>% filter(date_p<="2020-11-30" & date_p>="2020-11-01")
US_train=US %>% filter(date_p<="2020-11-01")

save(US,US_validadte,US_test_1d,US_test_1w,US_test_1m,US_train
     ,file="./Stone Age Covid project/data/data_set_US.rdata")


ggplot() +
  geom_line(aes(x=US$date_p, y=US$death))

ggplot() +
  geom_line(aes(x=US$date_p, y=US$deathIncrease))

ggplot(data=US,aes(x=d_w, y=deathIncrease, group=week)) +
  geom_line(aes(color=week)) #  sasonalidade forte semanal

ggplot(data=US,aes(x=day, y=deathIncrease, group=month)) +
  geom_line(aes(color=month)) # nem tanto no mes


