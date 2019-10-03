#' Computes the density of a multivariate normal distribution
#' @param x vector or matrix of values for which the density is computed. If \code{x} is a matrix, each row is taken to be a single draw.
#' @param mean mean vector
#' @param sigma covariance matrix
#' @export
dmvnorm <- function(x, mean, sigma) {
  if (is.vector(x))
    x <- matrix(x, ncol = length(x))
  cholesky <- chol(sigma)
  tmp <- backsolve(cholesky, t(x) - mean, transpose = TRUE)
  xMx <- colSums(tmp ^ 2)
  ret <- exp(- 0.5 * (ncol(x) * log(2 * pi) + 2* sum(log(diag(cholesky))) + xMx))
  ret
}
