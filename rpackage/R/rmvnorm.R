#' Produces random draws from a multivariate normal distribution
#' @param n number of draws
#' @param mean mean vector
#' @param sigma covariance matrix
#' @export
rmvnorm <- function(n, mean, sigma)
{
  cholesky <- chol(sigma)
  return <- matrix(rnorm(n * ncol(sigma)), nrow = n, byrow = TRUE) %*%  cholesky
  return <- sweep(return, 2, mean, "+")
  return
}
