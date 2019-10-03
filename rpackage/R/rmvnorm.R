#' Produces random draws from a multivariate normal distribution
#' @param n number of draws
#' @param mean mean vector
#' @param sigma covariance matrix
#' @export
#' @importFrom stats rnorm
rmvnorm <- function(n, mean, sigma)
{
  cholesky <- chol(sigma)
  ret <- matrix(rnorm(n * ncol(sigma)), nrow = n, byrow = TRUE) %*%  cholesky
  ret <- sweep(ret, 2, mean, "+")
  ret
}
