font_import()

library(readr)
library(tseries)
library(forecast)
library(extrafont)
library(readxl)
library(tictoc)

#---------------------------------------------------------

sdata1 <- read_csv("C:/.../b_1.csv",
                   col_names = FALSE, col_types = cols(X1 = col_character(),
                                                       X2 = col_double()))
	
input <- sdata1

# change format of timestamp column from character "char" to datetime "dttm"
#input$X1 <- as.POSIXct(input$X1, format='%Y-%m-%d %H:%M:%OS')

# 288 data points for chosen index ranges
input <- input[7103:7390,] 
origin <- ts(input[2])
plot(input)

input[15,2] <- 0
input[56:57,2] <- NA
input[70:86,2] <- NA
input[198:227,2] <- NA
vor_recovery <- input[2]
#View(input)
plot.ts(input[2])

# Running time, start counting
tic()

# data cleansing | replacing invalid values by NA characters
max_threshold <- 140
min_threshold <- 20
i <- 0
for (val in input$X2) {
  i <- i+1
  if(val > max_threshold || val <= min_threshold || is.na(val)==TRUE) input$X2[i] = NA
  #	if( val <= min_threshold) input$X2[i] = NA
}

x2 <- input
#View(x2)

# link values from the dataset in time series 
y <- ts(x2[2])
# call function to fill gaps 
z <- fill_gaps(y, origin)
# moving back the results into the original vector
x2[2] <- z[,1]
plot.ts(x2[,2])
lines(origin, lty=2)
# Stop running time
toc()

# store result
write.csv(x2, file = "esmart1_recovered.csv")
View(x2)

par(mfrow=c(2,1))
plot.ts(input[2], lwd=1.1, ylab=("Values"), xlab="Data indexes", main="Dataset with missing values", cex=1.5, font.main=60, ylim=c(64,92))
legend(-10.2, 93, c("actual"), lty=c(1), lwd=c(1), col=c("black"))
plot.ts(x2[,2], col="red", lwd=1.1, ylab=("Values"), xlab="Data indexes", main="Recovered dataset without missing values", cex=1.5, font.main=60, ylim=c(64,92))
lines(x2[,2], col="red", lwd=1.1)
lines(input[2], col="black", lwd=1.1)
legend(-10.2, 93, c("actual", "actual for gap", "forecasts"), lty=c(1,2,1), lwd=c(1.2,1.2,1), col=c("black", "black", "red"))
lines(origin, col="black", lwd=1.1, lty=2)

#---------------------------------------------------------
