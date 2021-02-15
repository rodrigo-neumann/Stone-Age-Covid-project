#install.packages(dplyr)
#install.packages("forecast")
#install.packages("ggplot2")
#install.packages("caret")


require(dplyr)
require("forecast")
require(ggplot2)
require(caret)

load("./Stone Age Covid project/data/data_set_US.rdata")

US_train_cor=US_train %>% cor()
US_train_cor %>% corrplot::corrplot(tl.pos="n")


#-------------------------------------Linear Model-------------------------------------------------------
# train_control <- trainControl(method = "cv",
#                               number = 100)

model_lm <- train(deathIncrease_next ~., data = US_train,  
                       method = "lm",
                       # family="binomial",
                       # trControl = train_control
                     ) 
#---------------------------------------TRAIN------------------------------------------------------------
US_train$predict=predict(model_lm,US_train)
ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$date_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
mean(abs((US_train$deathIncrease_next-US_train$predict)/US_train$deathIncrease_next))

importance=varImp(model_lm,scale = T)$importance

#-------------------------------------Validation-----------------------------------------------------
US_validate$predict=predict(model_lm,US_validate)
ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next-US_validate$predict,color="Erro"))+
  geom_line(aes(x=US_validate$date_n,y=abs(US_validate$deathIncrease_next-US_validate$predict),color="Erro ABS"))

mean(abs(US_validate$deathIncrease_next-US_validate$predict))
mean(abs((US_validate$deathIncrease_next-US_validate$predict)/US_validate$deathIncrease_next))


ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))+
  geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

#----------------------------------------------------------------------------------------------------------------



