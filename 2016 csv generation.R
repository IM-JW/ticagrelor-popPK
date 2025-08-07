#Mrgsolve script for ticagrelor

install.packages("mrgsolve")


#Setting working directory (Define your own directory.)
setwd ("C:/mrgsolve/python")
getwd ()

#Open libraries
library(mrgsolve)
library(dplyr)
library(ggplot2)



for (i in 0:249){
  
  mod <- mread(paste0("C:/mrgsolve/python/cpp_sigma0/2016/1_result_", i))
  
  data <- expand.ev(ID=1:1, amt= 60000, ii=12, addl=54)
  
  mod %>%
    data_set(data) %>%
    Req(CP, CM) %>%
    mrgsim(start=0, end = 144, delta = 1.5, output="df") -> a

  
  a$amt <- data$amt
  a$ii <- data$ii
  a$SMKH <- mod$SMKH
  a$MINH <- mod$MINH
  a$MIND <- mod$MIND
  a$VISIT1 <- mod$VISIT1
  a$SEX <- mod$SEX
  a$RACEA <- mod$RACEA
  a$RACEB <- mod$RACEB

  write.csv(a, paste0("C:/mrgsolve/python/csv_amt/2016_60/result_",i,".csv"))
}
