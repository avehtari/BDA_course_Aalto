#' Produces random draws from a multivariate normal distribution
#' @param n number of draws
#' @param mean mean vector
#' @param sigma covariance matrix
#' @export
#' @importFrom stats rnorm
rmvnorm <- function(n, mean, sigma)
{
  checkmate::assertCount(n, positive = TRUE)
  checkmate::assertNumeric(mean, any.missing = FALSE, min.len = 2)
  checkmate::assertMatrix(sigma, any.missing = FALSE, min.rows = 2, min.cols = 2)
  checkmate::assert(dim(sigma)[1] == dim(sigma)[2],
                    .var.name = 'check that covariance matrix is square')
  checkmate::assert(dim(sigma)[1] == length(mean),
                    .var.name = 'check that mean vector and covariance matrix have matching sizes')

  cholesky <- chol(sigma)
  ret <- matrix(rnorm(n * ncol(sigma)), nrow = n, byrow = TRUE) %*%  cholesky
  ret <- sweep(ret, 2, mean, "+")
  ret
}
