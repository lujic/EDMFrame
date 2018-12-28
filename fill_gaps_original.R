library(tseries)
library(forecast)
library(ggplot2)

fill_gaps <- function(x, original)
{	
  original <- original
  x <- ts(x)
  # vector missing_index contains all the indexes on which are missing values 
  index_miss <- which (is.na(x))
  
  # numb_of_missing_values contains number of missing values
  numb_of_missing_values <- length(index_miss)
  
  # checking if there are any missing values
  if (numb_of_missing_values > 0)
  {	
    # x1 contains all data points before an index of first missing value
    x1 <- x[1:(index_miss[1]-1)]
    
    # x1_length contains number of data points before an index of first missing value
    x1_length <- length(x1)
    
    # KPSS tests for trend and level stationarity
    k1 <- kpss.test(x1, null='T')
    k1;
    k2 <- kpss.test(x1, null='L')
    k2;
    # ADF test that dataset contains a unit root (non-stationary)
    a1 <- adf.test(x1)
    a1
  }
  
  # checking for multiple missing value/values within time series and 		
  # separating for the further work only index/indexes of the current gap
  if (numb_of_missing_values > 1)
  {
    i <- 1
    temp_missing_index <- index_miss[i]
    framed_data <- index_miss[i]
    
    while (numb_of_missing_values > i)
    {
      i <- i+1
      framed_data <- framed_data+1
      if (framed_data == index_miss[i])
      {
        temp_missing_index[i] <- index_miss[i]
      }
      else
      {
		# Vector gap_curr that stores missing indexes of the current gap
        gap_curr <- temp_missing_index[1:(i-1)]
        if (length(gap_curr) == 1) 
        {
          numb_of_missing_values <- 1
        }
        else 
        {
          numb_of_missing_values <- length(gap_curr)
        }
        break
      }
    }
  }
  
  if(numb_of_missing_values == 1) 
    #if(numb_of_missing_values < floor(x1_length/100) && numb_of_missing_values != 0)
  {			
    # calculate average of a few past values before missing value 
    temp <- x[(gap_curr[1]-(numb_of_missing_values*2)):(gap_curr[1]-1)]
    temp <- mean(temp)
    
    x[gap_curr[1:numb_of_missing_values]] <- temp
    print("Average of past (2 x numb_of_missing) values is used.")
    
  }
  else if(numb_of_missing_values > 1)
  {   
    # If seasonality is greater than 24, the forecast with ets or arima wont work. Thus we use tbats 
    # model in the forecast package that can handle multiple seasonal time series 
    # 288 equals to 12 points/h through day
    period <- 288
    if (period > 24 && numb_of_missing_values > period)
    {
      # since sensors generate data every 5min, potential seasonality is 288 (daily) or 288*7 (weakly)
      #x1 <- msts(x1, start=1, seasonal.periods = c(temp))
      forecTBTS <- forecast(tbats(x1), h=numb_of_missing_values)
      
      # replacing missing values with predicted values from tbts
      write.csv(forecTBTS, file='forecTBTS.csv')
      forecTBTS <- read.csv("forecTBTS.csv")
      forec <- forecTBTS$Point.Forecast
      x[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)] <- c(forec[1:numb_of_missing_values])
      print("TBTS is used (one possible period)")	
      					
     res <- accuracy(forec, original[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)])
     print(res)
    }
    # if both of null hypothesis for KPSS test are rejected and if the result for ADF test suggest 
    # that the time series contains a unit-root, that means that it is probably NON-STATIONARY and 
    # we apply one of the ETS innovative space forecasting models 
    else if(k1$p.value <= 0.05 && k2$p.value <= 0.05 && a1$p.value > 0.05)
    {	
      temp <- findfrequency(x1) # checking for the seasonality pattern
      if(temp > 1)
      {
        x_with_freq <- ts(x1, frequency=temp, start=1)
        forecARIMA<-forecast(auto.arima(x_with_freq), h=numb_of_missing_values)
      }
      else
      {
        forecARIMA <- forecast(auto.arima(x1), h=numb_of_missing_values)
      }
      # replacing missing values with predicted values
      write.csv(forecARIMA, file='forec_ARIMA.csv')
      forecARIMA <- read.csv("forec_ARIMA.csv")
      forec <- forecARIMA$Point.Forecast
      x[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)] <- c(forec[1:numb_of_missing_values])
      print("ARIMA is used")

      res <- accuracy(forec, original[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)])
      print(res)
    }
    else 
    {
      temp <- findfrequency(x1) # checking for the seasonality pattern
      # if both null hypothesis from KPSS test are not rejected (i.e., no evidence that time-series is not 
      # trend/level stationary) and if the result for ADF test suggest that the time series contains has no 
      # unit-root, that means that the time series is probably STATIONARY and we apply auto.ARIMA forecasts 
   
      if(temp > 1)
      {
        
        x_with_freq <- ts(x1, frequency=temp, start=1)
        forecETS<-forecast(ets(x_with_freq), h=numb_of_missing_values)	
      }
      else 
      {
        forecETS<-forecast(ets(x1), h=numb_of_missing_values)
      }
      
      # replacing missing values with predicted values for ETS
      write.csv(forecETS, file='forecETS.csv')
      forecETS <- read.csv("forecETS.csv")
      forec <- forecETS$Point.Forecast
      x[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)] <- c(forec[1:numb_of_missing_values])
      print("ETS is used")
      res <- accuracy(forec, original[gap_curr[1]:(gap_curr[1]+numb_of_missing_values-1)])
      print(res)
      
    }
  }
  else 
  {
    print("There are no (more) missing values. Data set is (now) evenly-spaced time series data set.")
    # return evenly-spaced ts with predicted values for the missing values
    return(x)
  }
  fill_gaps(x, original)
}	



