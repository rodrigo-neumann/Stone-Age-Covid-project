#install.packages(dplyr)
#install.packages("ggplot2")
# installed.packages("lubridate")

require(dplyr)
require(ggplot2)
require("lubridate")

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
# US$day=format(US$date_p,"%d")
# US$month=format(US$date_p,"%m")
# US$year=format(US$date_p,"%Y")
# US$week=format(US$date_p,"%V")
US$d_w=weekdays(US$date_p)

#US=US %>% filter(states==56) 
US=US %>% filter(date_p>=as.Date("2020-03-16")) # começando sem os dados onde nem todos os estados tinha publicado ainda


death_increase_next_day<- function (line,df) 
{
  #print(line["date_p"])
  next_day=filter(df,date_p==as.Date(line["date_p"])+days(1) )
  #print(nrow(next_day))
  if (nrow(next_day)==0)
  {return(NA)}
  return(next_day$deathIncrease)
}

same_day_last_week<- function (line,df) 
{
  #print(line["date_p"])
  last_7_day=filter(df,date_p==as.Date(line["date_p"])-days(7))
  #print(nrow(last_7_day))
  if (nrow(last_7_day)==0)
  {return(NA)}
  return(last_7_day$deathIncrease)
}




US$deathIncrease_next=apply(X=US,MARGIN = 1,FUN = death_increase_next_day,df=US)
US$same_day_last_week=apply(X=US,MARGIN = 1,FUN = same_day_last_week,df=US)


US=US %>% filter(!deathIncrease_next %>% is.na())




US<-US %>% select(setdiff(names(US),c("date","dateChecked","lastModified","recovered","total","posNeg","hash"
                                      ,"negative","hospitalizedCumulative","inIcuCumulative","death","hospitalized"
                                      ,"totalTestResults","totalTestResultsIncrease","positive","onVentilatorCumulative"
                                      ,"hospitalizedCurrently")))


US[is.na(US)]<-0
US=US %>% fastDummies::dummy_cols(remove_selected_columns = T)
US$date_n= as.numeric(US$date_p-min(US$date_p),"days")
US$date_n2=US$date_n-260


US_validate=US %>% filter(date_p<="2020-12-31" & date_p>="2020-12-01")
# US_test_1d=US %>% filter(date_p=="2020-11-01" )
# US_test_1w=US %>% filter(date_p<="2020-11-07" & date_p>="2020-11-01")
# US_test_1m=US %>% filter(date_p<="2020-11-30" & date_p>="2020-11-01")
US_train=US %>% filter(date_p<="2020-11-30")

US=US %>% select(setdiff(names(US),c("date_p")))
US_validate=US_validate %>% select(setdiff(names(US),c("date_p")))
US_train=US_train %>% select(setdiff(names(US),c("date_p")))



save(US,US_validate,US_train
     ,file="./Stone Age Covid project/data/data_set_US.rdata")


ggplot() +
  geom_line(aes(x=US$date_n, y=US$death))

ggplot() +
  geom_line(aes(x=US$date_n, y=US$deathIncrease))

# ggplot(data=US,aes(x=d_w, y=deathIncrease, group=week)) +
#   geom_line(aes(color=week)) #  sasonalidade forte semanal
# 
# ggplot(data=US,aes(x=day, y=deathIncrease, group=month)) +
#   geom_line(aes(color=month)) # nem tanto no mes

US_train$date_n %>% max()

US$deathIncrease_increase= US$deathIncrease_next-US$deathIncrease

US<-US %>% select(setdiff(names(US),c("date","dateChecked","lastModified","recovered","total","posNeg","hash"
                                      ,"negative","hospitalizedCumulative","inIcuCumulative","death","hospitalized"
                                      ,"totalTestResults","totalTestResultsIncrease","positive","onVentilatorCumulative"
                                      ,"hospitalizedCurrently","deathIncrease_next")))


US_train=US %>% filter(date_n<260)
US_validate=US %>% filter(date_n>=260 & date_n<=290)


save(US,US_validate,US_train
     ,file="./Stone Age Covid project/data/data_set_US_step.rdata")

rm(list=ls())