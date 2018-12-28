FindAppropriateCluster <- function(C, accth)
{
  if (is.na(C[2,1]) == 'FALSE')
  {
    i <- 1
    B <- 0
    B[1] <- abs(C[1,1]-accth)
    CLap <- matrix(,1,ncol=3)
    CLap <- C[1,]
    i <- i+1
    while(i <= length(C[,1]) && is.na(C[i,1]) == 'FALSE')
    {	
      temp <- abs(C[i,1]-accth)
      if (temp < B[1])
      {
        B[1] <- temp
        CLap <- C[i,]
      }	
      i <- i+1
    }	
    B <- matrix(,,ncol=3)
    i <- 1
    j <- 1
    while(i <= length(C[,1]) && is.na(C[i,1]) == 'FALSE')
    {	
      if ((C[i,1] > CLap[1]) && (C[i,2] <= CLap[3]) && (C[i,1] !=  CLap[1]))
      {
        if (is.na(B[1,1]) == 'TRUE')
        {
          B[j,] <- C[i,]
        }
        else
          B <- rbind(B, C[i,])
      }
      i <- i+1
    }
    
    i <- 1
    if (is.na(B[i,1]) == 'FALSE')
    {
      B <- rbind(B, matrix(,,ncol=3))
      i <- 1
      CLap <- B[i,]
      if (i < length(B[,1]))
      {				
        i <- i+1
        while (i <= length(B[,1]) && is.na(B[i,1]) == 'FALSE')
        {
          if (B[i,1] > CLap[1] && B[i,2] < CLap[2])
            CLap <- B[i,]
          i <- i+1	
        }
      }
    }
    
  }
  else
  {
    CLap <- matrix(,1,ncol=3)
    CLap <- C[1,]
  }
  return (CLap)
}		

