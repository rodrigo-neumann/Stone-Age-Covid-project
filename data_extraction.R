
# install.packages("dplyr")
# install.packages("httr")
# install.packages("readr")

require(dplyr)
require(httr)
require(readr)


url_call="https://api.covidtracking.com/v1/us/daily.csv"

raw_data <- GET(url_call,body=NULL,encode = "json")
data_set_raw<-httr::content(raw_data)
