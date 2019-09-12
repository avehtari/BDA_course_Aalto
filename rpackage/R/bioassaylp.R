#' Unnormalized log-posterior for bioassay, assuming uniform prior
#' @param alpha intercept parameter in the dose-response model
#' @param beta slope parameter in the dose-response model
#' @param x vector of doses for each observation
#' @param y vector of number of deaths for each observation
#' @param n vector of number of animals for each observation
#' @export
bioassaylp <- function(alpha, beta, x, y, n) {
  
  t <- alpha + beta*x
  et <- exp(t)
  z <- et/(1+et)
  
  # ensure that log(z) and log(1-z) are computable
  eps <- 1e-12
  z <- pmin(z, 1-eps)
  z <- pmax(z, eps)
  lp <- sum(y*log(z) + (n-y)*log(1-z))
  return(lp)
}

