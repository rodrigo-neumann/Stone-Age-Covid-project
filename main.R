# install.packages(dplyr)
# install.packages("forecast")
# install.packages("ggplot2")
# install.packages("caret")
# install.packages("lubridate")
# install.packages("httr")
# install.packages("readr")


require(dplyr)
require("forecast")
require(ggplot2)
require(caret)
require(lubridate)

#----------------------Updates data directily from API--------------------------
#source("./Stone Age Covid project/data_extraction.R")
#----------------------Structures Data------------------------------------------
#source("./Stone Age Covid project/data_structuring.R")
#----------------------Trains Model---------------------------------------------
#source("./Stone Age Covid project/train_model.R")

#-----------------------Loads data----------------------------------------------
load("./Stone Age Covid project/data/data_set_US.rdata")
#-----------------------trained Model-------------------------------------------
load("./Stone Age Covid project/models/sqrt_model_1.rdata")

#------------------------Fit in training data-----------------------------------
predict_death_increase_train=(predict(model_sqrt,US_train))^2
time_train=as.Date("2020-03-16")+days(US_train$date_n+1)
US_train$date=as.Date("2020-03-16")+days(US_train$date_n)

predictions_train=data_frame(date=time_train,deathincrease_model=predict_death_increase_train)

comp_train=select(US_train,date,deathIncrease_real=deathIncrease)
comp_train=comp_train %>% left_join(predictions_train,by=c("date"="date"))
#- Side by side results
ggplot()+geom_line(aes(x=comp_train$date,y=comp_train$deathincrease_model,color="model"))+
  geom_line(aes(x=comp_train$date,y=comp_train$deathIncrease_real,color="real"))

#- Absolute Error
ggplot()+geom_line(aes(x=comp_train$date,y=abs(comp_train$deathincrease_model-comp_train$deathIncrease_real),color="model"))

print("MAE train")
mean(abs(comp_train$deathincrease_model-comp_train$deathIncrease_real),na.rm = T)

# Relative error
ggplot()+geom_line(aes(x=comp_train$date,y=abs((comp_train$deathincrease_model-comp_train$deathIncrease_real)/comp_train$deathIncrease_real),color="model"))

print("MRE VAlidation")
mean(abs(comp_train$deathincrease_model-comp_train$deathIncrease_real)/comp_train$deathIncrease_real,na.rm = T)

#- RMSE
print("RMSE Train")
RMSE(comp_train$deathIncrease_real,comp_train$deathincrease_model, na.rm = T)
# R2
ggplot()+geom_line(aes(x=comp_train$deathIncrease_real,y=comp_train$deathIncrease_real,color="real"))+
  geom_point(aes(x=comp_train$deathIncrease_real,y=comp_train$deathincrease_model,color="model"))

print("R^2 Train")
R2(comp_train$deathIncrease_real,comp_train$deathincrease_model, na.rm = T)
#------------------------Fit in Validation data-----------------------------------
predict_death_increase_validation=(predict(model_sqrt,US_validate))^2

time_validation=as.Date("2020-03-16")+days(US_validate$date_n+1)
US_validate$date=as.Date("2020-03-16")+days(US_validate$date_n)

predictions_validation=data_frame(date=time_validation,deathincrease_model=predict_death_increase_validation)

comp_validation=select(US_validate,date,deathIncrease_real=deathIncrease)
comp_validation=comp_validation %>% left_join(predictions_validation,by=c("date"="date"))
#- Side by side results
ggplot()+geom_line(aes(x=comp_validation$date,y=comp_validation$deathincrease_model,color="model"))+
  geom_line(aes(x=comp_validation$date,y=comp_validation$deathIncrease_real,color="real"))

#- Absolute Error
ggplot()+geom_line(aes(x=comp_validation$date,y=abs(comp_validation$deathincrease_model-comp_validation$deathIncrease_real),color="model"))

print("MAE VAlidation")
mean(abs(comp_validation$deathincrease_model-comp_validation$deathIncrease_real),na.rm = T)
# Relative error
ggplot()+geom_line(aes(x=comp_validation$date,y=abs((comp_validation$deathincrease_model-comp_validation$deathIncrease_real)/comp_validation$deathIncrease_real),color="model"))

print("MRE VAlidation")
mean(abs(comp_validation$deathincrease_model-comp_validation$deathIncrease_real)/comp_validation$deathIncrease_real,na.rm = T)


#- RMSE
print("RMSE VAlidation")
RMSE(comp_validation$deathIncrease_real,comp_validation$deathincrease_model, na.rm = T)
#R2
ggplot()+geom_line(aes(x=comp_validation$deathIncrease_real,y=comp_validation$deathIncrease_real,color="real"))+
  geom_point(aes(x=comp_validation$deathIncrease_real,y=comp_validation$deathincrease_model,color="model"))

print("R^2 Validation")
R2(comp_validation$deathIncrease_real,comp_validation$deathincrease_model, na.rm = T)
#------------------------All data put together-----------------------------------
ggplot()+geom_line(aes(x=comp_validation$date,y=comp_validation$deathincrease_model,color="model"))+
  geom_line(aes(x=comp_validation$date,y=comp_validation$deathIncrease_real,color="real"))+
  geom_line(aes(x=comp_train$date,y=comp_train$deathincrease_model,color="model"))+
  geom_line(aes(x=comp_train$date,y=comp_train$deathIncrease_real,color="real"))+
  geom_vline(xintercept = as.Date("2020-12-01"))
#- Abusulote error
ggplot()+
  geom_line(aes(x=comp_train$date,y=abs(comp_train$deathincrease_model-comp_train$deathIncrease_real),color="model"))+
  geom_line(aes(x=comp_validation$date,y=abs(comp_validation$deathincrease_model-comp_validation$deathIncrease_real),color="model"))
# Relative error
ggplot()+
  geom_line(aes(x=comp_validation$date,y=abs((comp_validation$deathincrease_model-comp_validation$deathIncrease_real)/comp_validation$deathIncrease_real),color="validation"))+
  geom_line(aes(x=comp_train$date,y=abs((comp_train$deathincrease_model-comp_train$deathIncrease_real)/comp_train$deathIncrease_real),color="train"))
# R2
ggplot()+geom_line(aes(x=comp_validation$deathIncrease_real,y=comp_validation$deathIncrease_real,color="real"))+
  geom_point(aes(x=comp_validation$deathIncrease_real,y=comp_validation$deathincrease_model,color="Validation"))+
  geom_line(aes(x=comp_train$deathIncrease_real,y=comp_train$deathIncrease_real,color="real"))+
  geom_point(aes(x=comp_train$deathIncrease_real,y=comp_train$deathincrease_model,color="Train"))
