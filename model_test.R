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

#US_train=filter(US_train,date_n>200)

#-------------------------------------Linear Model-------------------------------------------------------
train_control <- trainControl(method = "cv",
                              number = 5)
 model_lm <- train(deathIncrease_next ~.+date_n*d_w_domingo+d_w_domingo+
                                            date_n*`d_w_segunda-feira`+
                                              date_n*`d_w_terça-feira`+
                                              date_n*`d_w_quarta-feira`+
                                              date_n*`d_w_quinta-feira`+
                                              date_n*`d_w_sexta-feira`+
                                              date_n*d_w_sábado
                                              , data = US_train
                                              ,method = "lm"
                                              ,trControl=train_control
                                              )
#---------------------------------------TRAIN------------------------------------------------------------
US_train$predict=predict(model_lm,US_train)
ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$date_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
mean(abs((US_train$deathIncrease_next-US_train$predict)/US_train$deathIncrease_next))
var(US_train$deathIncrease_next-US_train$predict)

importance=varImp(model_lm,scale = T)$importance

#-------------------------------------Validation-----------------------------------------------------
US_validate$predict=predict(model_lm,US_validate)
ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next-US_validate$predict,color="Erro"))+
  geom_line(aes(x=US_validate$date_n,y=abs(US_validate$deathIncrease_next-US_validate$predict),color="Erro ABS"))

mean(abs(US_validate$deathIncrease_next-US_validate$predict))
mean(abs((US_validate$deathIncrease_next-US_validate$predict)/US_validate$deathIncrease_next))
var(US_validate$deathIncrease_next-US_validate$predict)

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))+
  geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))+
  geom_vline(aes(xintercept=260))

#----------------------------------------------------------------------------------------------------------------
#-------------------------------------Random Forest-------------------------------------------------------
# train_control <- trainControl(method = "cv",
#                               number = 100)

model_lm <- train(deathIncrease_next ~.+date_n*d_w_domingo+d_w_domingo+
                    date_n*`d_w_segunda-feira`+
                    date_n*`d_w_terça-feira`+
                    date_n*`d_w_quarta-feira`+
                    date_n*`d_w_quinta-feira`+
                    date_n*`d_w_sexta-feira`+
                    date_n*d_w_sábado
                  , data = US_train
                  ,method = "rf"
                  ,trControl=train_control)
#---------------------------------------TRAIN------------------------------------------------------------
US_train$predict=predict(model_lm,US_train)
ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$date_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
mean(abs((US_train$deathIncrease_next-US_train$predict)/US_train$deathIncrease_next))
var(US_train$deathIncrease_next-US_train$predict)

importance=varImp(model_lm,scale = T)$importance

#-------------------------------------Validation-----------------------------------------------------
US_validate$predict=predict(model_lm,US_validate)
ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next-US_validate$predict,color="Erro"))+
  geom_line(aes(x=US_validate$date_n,y=abs(US_validate$deathIncrease_next-US_validate$predict),color="Erro ABS"))

mean(abs(US_validate$deathIncrease_next-US_validate$predict))
mean(abs((US_validate$deathIncrease_next-US_validate$predict)/US_validate$deathIncrease_next))
var(US_validate$deathIncrease_next-US_validate$predict)

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))+
  geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))+
  geom_vline(aes(xintercept=260))

#----------------------------------------------------------------------------------------------------------------
#-------------------------------------2 degree poly-------------------------------------------------------
# train_control <- trainControl(method = "cv",
#                               number = 100)

model_lm <- train(deathIncrease_next~.+ poly(date_n,degree = 3)
                  , data = US_train
                  ,method = "lm"
                  #,trControl=trainControl
                  )
#---------------------------------------TRAIN------------------------------------------------------------
US_train$predict=predict(model_lm,US_train)
ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$date_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
mean(abs((US_train$deathIncrease_next-US_train$predict)/US_train$deathIncrease_next))
var(US_train$deathIncrease_next-US_train$predict)

importance=varImp(model_lm,scale = T)$importance

#-------------------------------------Validation-----------------------------------------------------
US_validate$predict=predict(model_lm,US_validate)
ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next-US_validate$predict,color="Erro"))+
  geom_line(aes(x=US_validate$date_n,y=abs(US_validate$deathIncrease_next-US_validate$predict),color="Erro ABS"))

mean(abs(US_validate$deathIncrease_next-US_validate$predict))
mean(abs((US_validate$deathIncrease_next-US_validate$predict)/US_validate$deathIncrease_next))
var(US_validate$deathIncrease_next-US_validate$predict)

ggplot()+geom_line(aes(x=US_validate$date_n,y=US_validate$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_validate$date_n,y=US_validate$predict,color="Model"))+
  geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))+
  geom_vline(aes(xintercept=260))

#----------------------------------------------------------------------------------------------------------------
# 
# 
