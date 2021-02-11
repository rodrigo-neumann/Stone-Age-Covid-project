

# Update Data

# read saved data#
US=read.csv("./Stone Age Covid project/data/raw_national_data.csv")
states=read.csv("./Stone Age Covid project/data/raw_state_data.csv")

US %>% names()

states %>% names()

setdiff(states %>% names(),US %>% names())
setdiff(US %>% names(),states %>% names())
