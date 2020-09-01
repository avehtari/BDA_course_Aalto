bioassaylp <- function(a,b,x,y,n) {
  
  # unnormalized log-posterior for bioassay (assuming uniform prior)
  
  t <- a + b*x
  et <- exp(t)
  z <- et/(1+et)
  
  # ensure that log(z) and log(1-z) are computable
  eps <- 1e-12
  z <- pmin(z, 1-eps)
  z <- pmax(z, eps)
  lp <- sum(y*log(z) + (n-y)*log(1-z))
  return(lp)
}

