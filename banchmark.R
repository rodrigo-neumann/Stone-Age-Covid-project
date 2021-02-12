#install.packages(dplyr)
#install.packages("forecast")

require(dplyr)
require("forecast")

load("./Stone Age Covid project/data/data_set_US.rdata")

#primiero passo bencchamark: Naive and Snaive 

naive=naive(y=US_train$deathIncrease,data=US ,h=30)
naive_precdictions=naive$mean

US_train$date_p %>% max()

US_train$

ggplot() +
  geom_line(aes(x=US$date_p, y=US$deathIncrease))+
  geom_line(aes(x=US$date_p, y=US$deathIncrease))

