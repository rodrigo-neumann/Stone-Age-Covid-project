#install.packages(dplyr)
#install.packages("forecast")
#install.packages("ggplot2")

require(dplyr)
require("forecast")
require(ggplot2)
require(caret)

load("./Stone Age Covid project/data/data_set_US.rdata")

#primiero passo bencchamark: Naive


naive=naive(y=US_train$deathIncrease,h=30)
naive_precdictions=naive$mean


predicted_timse=seq(as.Date("2020-11-01"), as.Date("2020-11-30"), by = "days")



ggplot() +
  geom_line(aes(x=US_train$date_p, y=US_train$deathIncrease,color="Train"))+
  geom_line(aes(x=predicted_timse, y=naive_precdictions,color="Naive_ predict"))+
  geom_line(aes(x=predicted_timse, y=snaive_precdictions,color="Snaive_ predict"))
