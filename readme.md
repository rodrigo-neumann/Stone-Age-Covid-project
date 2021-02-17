
  <h3 align="center">Stone Age Take Home- COVID deaths </h3>

  <p align="center">
    Take home project on as part of Stone Age selection process
    
<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
	 </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
     <li><a href="#contact">Contact</a></li>
      </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

The goal of this project (besides getting me a good job) is to  to create a model prediction model for number of deaths in the USA. The project was done completely in R  and uses data from The COVID Tracking Project's API (https://covidtracking.com/data/api) 

<!-- GETTING STARTED -->
## Getting Started

First you will need to install all the packages used on this project it won't take long. Run the following code on your R environment 
* Required Packages
  ```sh
  install.packages(dplyr)
  nstall.packages("forecast")
  install.packages("ggplot2")
  install.packages("caret")
  install.packages("lubridate")
  install.packages("httr")
  install.packages("readr")
  ```

To make your life easier the file "main.R" has this code commented that you can simply run if you need it.. After that simply cloning this repository to your workspace in R should do the trick. This repository contains some data and an already trained model, so your first run should be simply running the "main.R" file. This project used the interval from 2020/03/16 through 2020-11-30 for training and December 2020 for validation. 

<!-- USAGE EXAMPLES -->
## Usage

This project was broken in a few files to make life easier while testing, adjusting and putting code on production. Let's discuss some of the files here:
#### data_extraction.R
This is a script that connects and extracts data directly from The COVID Tracking Project's API. It will extract both national US data as well as the data from each state and save it on the data file in csv format ("raw_national_data.csv" and "raw_state_data.csv"). This repository already comes with some date so you will only need to run this in case you want to update the data. If you want to do so you can always uncomment this line on the "main.R" file
 ```sh
#source("./Stone Age Covid project/data_extraction.R")
  ```

Since this project's goal was to predict a specific time span, there was no need for constant actualization of data,  but you might use it for another projects. 
#### data_structuring.R
This file we centralized all the data processing, feature engineering and partitioning. At the very start we read both US and state data (even though we only have used US data):
 ```sh
US=read.csv("./Stone Age Covid project/data/raw_national_data.csv")
states=read.csv("./Stone Age Covid project/data/raw_state_data.csv")
  ```
Later on we will create new variables and remove other features we do not want to sue in the training of the model. A very important feature created is "deathIncrease_next" since it works as response variable for the next step  Later data is partitioned in train and  test and the resulting data_frames (US, US_train,US_validate) are saved on a .Rdata file
 ```sh
save(US,US_validate,US_train
     ,file="./Stone Age Covid project/data/data_set_US.rdata")
  ```
  If you are sourcing the data extraction script from "main.R" you should also uncommnet this line to make sure the data you extracted is going to be structered and avaailble to used
   ```sh
#source("./Stone Age Covid project/data_structuring.R")
  ```
this is the place if you want to create different features that may want to use in your model.
#### train_model.R
Here it's where the magic happens. It starts by loading the datasets created on "data_structuring.R":
   ```sh
load("./Stone Age Covid project/data/data_set_US.rdata")
  ```
  It  will use the US_train data frame to train the model. In this case a linear model where the response variable is the square root of the our response variable (deathIncrease_next)
  ```sh
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
  ```
  After that the trained model will be saved inside the models file:
   ```sh
save(model_sqrt,file="./Stone Age Covid project/models/sqrt_model_1.rdata")
  ```
  Again this project comes with a fully trained model so you really want to use this if you to make changes to the model or as a template for training you own.
  #### main.R
  This is the main script and pulls all the the work done in the other tighter. Here the trained model it's applied on the created datasets. So we can see train and validation performance.

#### banchmark.R, model_test.R, model_test_step.R
Here are some files used in the process of crating the model, they encompass mostly comparisons between different models. They are supplied here to give an idea of how to to create, train and compare your own models.
<<!-- CONTACT -->
## Contact

Rodrigo Neumann - email: rodrigoneumann100@hotmail.com

Project Link: https://github.com/rodrigo-neumann/Stone-Age-Covid-project
