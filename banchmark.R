#install.packages(dplyr)
#install.packages("forecast")

require(dplyr)
require("forecast")

load("./Stone Age Covid project/data/data_set_US.rdata")

#primiero passo bencchamark: Naive and Snaive 

naive=naive(y=US$deathIncrease,data=US ,h=30)
predict=predict(naive,US)


ggplot() +
  geom_line(aes(x=US$date_p, y=US$deathIncrease))

