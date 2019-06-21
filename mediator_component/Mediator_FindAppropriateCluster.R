FindAppropriateCluster <- function(C)
{
  if (is.na(C[2,1]) == 'FALSE')
  {
    i <- 1
    CLap <- matrix(,1,ncol=3)
    CLap <- C[i,]
    i <- i+1
    while(i <= length(C[,1]) && is.na(C[i,1]) == 'FALSE')
    {	
      if (CLap[1] <= C[i,1])
      {
        CLap <- C[i,]
      }	
      i <- i+1
    }	
  }
  else
  {
    CLap <- matrix(,1,ncol=3)
    CLap <- C[1,]
  }
  return (CLap)
}		

