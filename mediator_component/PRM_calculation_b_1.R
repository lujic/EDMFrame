#---------------------------------------------------------
# ADAPTIVE ALGORITHM
#---------------------------------------------------------
font_import()

library(readr)
library(tseries)
library(forecast)
library(extrafont)
library(readxl)
library(tictoc)
library(zoo)
library(pryr)
#---------------------------------------------------------

tic()
# 3% decrement factor for the multiple forecast iteration phase
#perc <- 3
d_factor <- 3
upper_bound <- 8319

fp_test <- 1
PRM <- matrix(,,ncol=8)
colnames(PRM) <- c("fp","method", "MAPA", "to", "from", "volatility", "sfactorARIMA", "sfactorETS")
while (fp_test <= 144) {
  Tm <- matrix(,,ncol=8)
  
  fp <- fp_test
  Tm [1,1] <- fp_test  
  
  sdata1 <- read_csv("C:/.../b_1.csv",
                     col_names = FALSE, col_types = cols(X1 = col_character(),
                                                         X2 = col_double()))

  lower_bound <- upper_bound-(34*d_factor+3*fp)
  # 4d * 288dp/d -> 1152 dp
  #input <- sdata1[7211:8362,]
  input <- sdata1[lower_bound:upper_bound,]
  input <- ts(input[,2])
  sdata1 <- input
  
  plot.ts(sdata1, col="black", lwd=1.1, ylab=("Values"), xlab=upper_bound-lower_bound, main=fp_test, cex=1.5, font.main=60)
  # write.csv(sdata1, "dataset_cycle_1.2.csv", row.names = FALSE)
  
  i <- 1
  j <- 1
  
  sdata1 <- ts(sdata1, frequency=1, start=1)
  input_data_len <- length(sdata1)
  train_data_len <- length(sdata1)-fp
  train_data_len_act <- train_data_len - 2*fp
  
  # d_factor <- round(perc*train_data_len_act/100,digits = 0)
  #if (d_factor == 0) d_factor <- 1 #to avoid the case when the algorithm never decreases training set in multiple forecast iteration phase
  
  gammaARIMA <- matrix(,,ncol=2)
  gammaETS <- matrix(,,ncol=2)
  
  while (i < train_data_len_act)
  {
    # ARIMA
    forecARIMA <- forecast(auto.arima(sdata1[i:train_data_len]),h=fp) 
    accuracy <- accuracy(forecARIMA, sdata1[(train_data_len+1):input_data_len])
    MAPA <- 100-accuracy[10]
    if (is.na(gammaARIMA[1,1]) == 'TRUE') {
      gammaARIMA[1,1] <- train_data_len
      gammaARIMA[1,2] <- MAPA
    } else {
      temp <- c(train_data_len-i+1,MAPA)
      gammaARIMA <- rbind(gammaARIMA, temp[])
    }
    
    #ETS
    forecETS <- forecast(ets(sdata1[i:train_data_len]),h=fp) 
    accuracy <- accuracy(forecETS, sdata1[(train_data_len+1):input_data_len])
    MAPA <- 100-accuracy[10]
    if (is.na(gammaETS[1,1]) == 'TRUE') {
      gammaETS[1,1] <- train_data_len
      gammaETS[1,2] <- MAPA
    } else {
      temp <- c(train_data_len-i+1,MAPA)
      gammaETS <- rbind(gammaETS, temp[])
    }
    
    j <- j+1
    i <- i+d_factor
  }
  #write.csv(gammaARIMA, "gamma_cycleARIMA.2.csv", row.names = FALSE)
  #write.csv(gammaETS, "gamma_cycleETS.2.csv", row.names = FALSE)
  
  #threshold on 1/5 or 20% of overall standard dev.
  
  s_factor <- 4
  CARIMA <- FindStableClusters(gammaARIMA, s_factor)
  while(is.na(CARIMA[1,1]) == 'TRUE') {
    #threshold on 1/4 or 25% of overall standard dev, and so on
    s_factor <- s_factor-1
    CARIMA <- FindStableClusters(gammaARIMA, s_factor)
  }
  CLapARIMA <- FindAppropriateCluster(CARIMA)
  Tm [1,7] <- s_factor
  
  s_factor <- 4
  CETS <- FindStableClusters(gammaETS, s_factor)
  while(is.na(CETS[1,1]) == 'TRUE') {
    #threshold on 1/4 or 25% of overall standard dev, and so on
    s_factor <- s_factor-1
    sprintf("%i",s_factor)
    CETS <- FindStableClusters(gammaETS, s_factor)
  }
  CLapETS <- FindAppropriateCluster(CETS)
  Tm [1,8] <- s_factor
  
  if (CLapARIMA[1] > CLapETS[1]) 
  {
    CLap <- CLapARIMA
    sprintf("ARIMA used.")
    Tm [1,2] <- 'ARIMA'  
  } else if (CLapARIMA[1] < CLapETS[1])
  {
    CLap <- CLapETS
    sprintf("ETS used.")
    Tm [1,2] <- 'ETS'
  } else 
  {
    if (CLapARIMA[2] < CLapETS[2]) {
      CLap <- CLapARIMA
      sprintf("ARIMA used.")
      Tm [1,2] <- 'ARIMA'  
    } else {
      CLap <- CLapETS
      sprintf("ETS used.")
      Tm [1,2] <- 'ETS'
    }
  }
  
  Tm [1,3] <- round(CLap[1],5)
  Tm [1,4] <- CLap[2]
  Tm [1,5] <- CLap[3]
  Tm [1,6] <- sd(sdata1[(train_data_len-CLap[2]+1):train_data_len,])
  PRM <- rbind(PRM, Tm)
  
  fp_test <- fp_test + 1
}
toc()

write.csv(PRM, "PRM_b_1.csv", row.names = FALSE)
