#install.packages(dplyr)
#install.packages("forecast")
#install.packages("ggplot2")
#install.packages("caret")


require(dplyr)
require("forecast")
require(ggplot2)
require(caret)

load("./Stone Age Covid project/data/data_set_US.rdata")

US_train[is.na(US_train)]<-0
US_train=US_train %>% fastDummies::dummy_cols(remove_selected_columns = T)
US_train$data_n= as.numeric(US_train$date_p-min(US_train$date_p),"days")

US_train=US_train %>% select(setdiff(names(US_train),c("date_p")))
# US_train=US_train %>% select("deathIncrease" %>% append(names(US_train)))

US_train_cor=US_train %>% cor()
US_train_cor %>% corrplot::corrplot(tl.pos="n")

train_control <- trainControl(method = "cv", 
                              number = 5) 

model_lm <- train(deathIncrease_next ~., data = US_train,  
                       method = "lm",
                       #family="binomial",
                       #trControl = train_control
                     ) 
#-----------------------------------------------------------------------------------------------------------
US_train$predict=predict(model_lm,US_train)
ggplot()+geom_line(aes(x=US_train$data_n,y=US_train$deathIncrease_next,color="Real"))+
  geom_line(aes(x=US_train$data_n,y=US_train$predict,color="Model"))

ggplot()+geom_line(aes(x=US_train$data_n,y=US_train$deathIncrease_next-US_train$predict,color="Erro"))+
  geom_line(aes(x=US_train$data_n,y=abs(US_train$deathIncrease_next-US_train$predict),color="Erro ABS"))

mean(abs(US_train$deathIncrease_next-US_train$predict))
importance=varImp(model_lm,scale = T)$importance

#-------------------------------------------------------------------------------------------------------------