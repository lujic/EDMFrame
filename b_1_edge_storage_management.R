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

fh <- 12
accth <- 90
# 3% decrement factor for the multiple forecast iteration phase
perc <- 3

sdata1 <- read_csv("C:/.../b_1.csv",
                   col_names = FALSE, col_types = cols(X1 = col_character(),
                                                       X2 = col_double()))
# sdata1[1,1] <- as.character("2016-08-16 15:50:00.000")
	input <- sdata1
# 144 data points for chosen indexes range
	input <- input[7600:7743,] 
	input <- ts(input[2])

# 144 data points, 12dp/hrs * 12hrs
# sdata1 <- x2[,2]
	sdata1 <- input
	plot.ts(sdata1, col="black", lwd=1.1, ylab=("Values"), xlab="Data indexes", main="Recovered dataset without missing values", cex=1.5, font.main=60)
	write.csv(sdata1, "dataset_cycle_1.2.csv", row.names = FALSE)
	
	tic()
	
	i <- 1
	j <- 1
	
	gamma <- matrix(,,ncol=2)
	periodicity <- findfrequency(sdata1)
	sdata1 <- ts(sdata1, frequency=1, start=1)
	input_data_len <- length(sdata1)
	train_data_len <- length(sdata1)-fh
	train_data_len_act <- train_data_len - 2*fh
  
  d_factor <- round(perc*train_data_len_act/100,digits = 0)
  if (d_factor == 0) d_factor <- 1 #to avoid the case when the algorithm never decreases training set in multiple forecast iteration phase
  
  while (i < train_data_len_act)
  {
    forecARIMA <- forecast(auto.arima(sdata1[i:train_data_len]),h=fh) 
    accuracy <- accuracy(forecARIMA, sdata1[(train_data_len+1):input_data_len])
    MAPA <- 100-accuracy[10]
    if (is.na(gamma[1,1]) == 'TRUE') {
      gamma[1,1] <- train_data_len
      gamma[1,2] <- MAPA
    } else {
      temp <- c(train_data_len-i+1,MAPA)
      gamma <- rbind(gamma, temp[])
    }
    j <- j+1
    i <- i+d_factor
  }
  write.csv(gamma, "gamma_cycle_1.2.csv", row.names = FALSE)
  
  #threshold on 1/5 or 20% of overall standard dev.
  s_factor <- 5
  C <- FindStableClusters(gamma, s_factor)

  while(is.na(C[1,1]) == 'TRUE') {
    #threshold on 1/4 or 25% of overall standard dev, and so on
    s_factor <- s_factor-1
    C <- FindStableClusters(gamma, s_factor)
  }
  
  CLap <- FindAppropriateCluster(C, accth)
  
  toc()
  
  cat(sprintf("Number of clusters: %1.f \n", nrow(C)-1))
  cat(sprintf("Number of iterations: %1.f \n", nrow(gamma)))

  release <- (input_data_len-(round((CLap[2]+CLap[3])/2, digits = 0)+fh))
  
  object_size(sdata1[1:release])
  cat(sprintf("Release %1.f data points\n", release))
  sdata1 <- sdata1[(release+1):input_data_len]
  sdata2 <- sdata1
  cat(sprintf("Keep %1.f data points, that is, %1.f%% of stored data\n", length(sdata1), (length(sdata1)/(release+length(sdata1))*100)))
    
# write.csv(results, ".csv", row.names = FALSE)
