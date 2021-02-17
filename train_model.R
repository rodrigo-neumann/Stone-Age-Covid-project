#install.packages(dplyr)
#install.packages("forecast")
#install.packages("ggplot2")
#install.packages("caret")


require(dplyr)
require("forecast")
require(ggplot2)
require(caret)

load("./Stone Age Covid project/data/data_set_US.rdata")
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

save(model_sqrt,file="./Stone Age Covid project/models/sqrt_model_1.rdata")
rm(list=ls())
