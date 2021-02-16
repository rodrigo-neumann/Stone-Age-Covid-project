#install.packages(dplyr)
#install.packages("forecast")
#install.packages("ggplot2")
#install.packages("caret")


require(dplyr)
require("forecast")
require(ggplot2)
require(caret)

load("./Stone Age Covid project/data/data_set_US.rdata")

STLdecomp=US_train$deathIncrease_next %>% ts(frequency = 7) %>%
  stl(t.window=31,
      s.window=7, robust=TRUE) 

STLdecomp %>% autoplot()
seasonal=STLdecomp %>% seasonal()
trned=STLdecomp %>% trendcycle()
rest=STLdecomp %>% remainder()

US_train_cor=US_train %>% cor()
US_train_cor %>% corrplot::corrplot(tl.pos="n")

US_train_cor_remove=(abs(US_train_cor)>0.9 & abs(US_train_cor)!=1)
#-------------------------------------lqrt lin Model-------------------------------------------------------
train_control <- trainControl(method = "cv",
                              number = 5)
model_sqrt <- train(sqrt(deathIncrease_next) ~.+date_n*d_w_domingo+d_w_domingo+
                    date_n*`d_w_segunda-feira`+
                    date_n*`d_w_terça-feira`+
                    date_n*`d_w_quarta-feira`+
                    date_n*`d_w_quinta-feira`+
                    date_n*`d_w_sexta-feira`+
                    date_n*d_w_sábado+date_n2
                  , data = US_train
                  ,method = "lm"
                  ,trControl=train_control
)
#---------------------------------------TRAIN------------------------------------------------------------
US_train$predict=(predict(model_sqrt,US_train))^2
ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$date_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$date_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$date_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
mean(abs((US_train$deathIncrease_next-US_train$predict)/US_train$deathIncrease_next))
var(US_train$deathIncrease_next-US_train$predict)

importance=varImp(model_sqrt,scale = T)$importance

#-------------------------------------Validation-----------------------------------------------------
US_validate$predict=(predict(model_sqrt,US_validate))^2
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
# #----------------------------------------------------------------------------------------------------------------

save(model_sqrt,file="./Stone Age Covid project/models/sqrt_model_1.rdata")
