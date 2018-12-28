library(tseries)
library(forecast)
library(ggplot2)

fill_gaps <- function(x, original, sdata1, min_index)
{	
  original <- original
  sdata1 <- ts(sdata1)
  x <- ts(x)
  # vector missing_index contains all the indexes on which are missing values 
  index_miss <- which (is.na(x))
  
  # numb_of_missing_values contains number of missing values
  numb_of_missing_values <- length(index_miss)
  
  # checking for multiple missing value/values within time series and 		
  # separating for the further work only index/indexes for the first gap
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
	  # Vector gap_curr that contains all indexes of the current gap
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
  
  # checking if there are any missing values
  if (numb_of_missing_values > 0)
  {	
    # x1 contains all data points before an index of first missing value
    x1 <- x[1:(gap_curr[1]-1)]
    # x1_length contains number of data points before an index of first missing value
    x1_length <- length(x1)
  }
  
  if(numb_of_missing_values) 
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
    print("There are no (more) missing values. Data set is (now) evenly-spaced time series data set.")
    # return evenly-spaced ts with predicted values for the missing values
    return(x)
  }
  fill_gaps(x, original, sdata1, min_index)
}	



