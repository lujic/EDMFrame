FindStableClusters <- function(gamma, s_factor) {
  clusterized <- 0
  sdata1 <- as.numeric(unlist(gamma[,2]))
  v_gamma <- sd(sdata1)
  
  if (v_gamma != 0) {  
    CLth <- v_gamma/s_factor
    temp_vector <- rollapply(sdata1, 3, sd)
    i <- 1
    j <- 1
    C <- matrix(,,ncol=3)
    colnames(C) <- c("Mean value","From x used data points","To x used data points")
    B <- matrix(,,ncol=3)
    while (i < length(temp_vector))
    {
      # if TRUE, this is a stable cluster
      if (temp_vector[i]<CLth)
      {
        if (is.na(C[1,1]) == 'TRUE')
        {
          C[j,1] <- mean(gamma[i:(i+2),2])
          C[j,2] <- gamma[i,1]
          C[j,3] <- gamma[i+2, 1]
          clusterized <- clusterized + 3
        }
        else
        {
          B[1,1] <- mean(gamma[i:i+2,2])
          B[1,2] <- gamma[i,1]
          B[1,3] <- gamma[i+2, 1]
          C <- rbind(C, B[1,])
          clusterized <- clusterized + 3
        }	
       
        start_index <- i			
        i <- (i+1)
        if (temp_vector[i] < CLth && is.na(temp_vector[i]) == 'FALSE')
        {	
          while(temp_vector[i] < CLth && is.na(temp_vector[i]) == 'FALSE')
          {
            C[j,1] <- mean(gamma[start_index:(i+2),2])
            C[j,3] <- gamma[i+2, 1]
            i <- (i+1)
            clusterized <- clusterized + 1
          }
          j <- (j+1)
        }
        else
        {
          i <- (i+1)
          j <- (j+1)
        }
      } else 
        
        i <- (i+1)
      
    }
    B <- matrix(,,ncol=3)
    C <- rbind(C, B[1,])
  }
  else {
    i <- 1
    j <- 1
    C[j,1] <- mean(gamma[i:(i+nrow(gamma)-1),2])
    C[j,2] <- gamma[i,1]
    C[j,3] <- gamma[(i+nrow(gamma)-1), 1]
    clusterized <- nrow(gamma)
  }
  print ((clusterized/nrow(gamma)) * 100)
  return(C)
}