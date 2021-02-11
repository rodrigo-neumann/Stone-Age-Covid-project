
# install.packages("dplyr")
# install.packages("httr")
# install.packages("readr")

require(dplyr)
require(httr)
require(readr)

# Exrtract National data from API
url_call="https://api.covidtracking.com/v1/us/daily.csv"

raw_data <- GET(url_call,body=NULL,encode = "json")
data_set_US_raw<-httr::content(raw_data)

write.csv(data_set_US_raw,"./Stone Age Covid project/data/raw_national_data.csv",row.names = F)

# Exrtract State data from API
url_call="https://api.covidtracking.com/v1/states/daily.csv"

raw_data <- GET(url_call,body=NULL,encode = "json")
data_set_state_raw<-httr::content(raw_data)

write.csv(data_set_state_raw,"./Stone Age Covid project/data/raw_state_data.csv",row.names = F)
