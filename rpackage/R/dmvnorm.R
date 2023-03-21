#' Computes the density of a multivariate normal distribution
#' @param x vector or matrix of values for which the density is computed.
#' If \code{x} is a vector, it represents a single draw.
#' If \code{x} is a matrix, each row is taken to be a single draw.
#' @param mean mean vector
#' @param sigma covariance matrix
#' @param log logical indicating whether to return on the log scale or not.
#' False by default.
#' @return Densities of the draws x.
#' @export
dmvnorm <- function(x, mean, sigma, log = FALSE) {
  checkmate::assertNumeric(mean, any.missing = FALSE, min.len = 2)
  checkmate::assertMatrix(sigma, any.missing = FALSE, min.rows = 2, min.cols = 2)
  checkmate::assert(dim(sigma)[1] == dim(sigma)[2],
                    .var.name = 'check that covariance matrix is square')
  checkmate::assert(dim(sigma)[1] == length(mean),
                    .var.name = 'check that mean vector and covariance matrix have matching sizes')
  checkmate::assertLogical(log, len = 1)

  checkmate::assert(checkmate::checkMatrix(x),checkmate::checkVector(x))

  if (inherits(x, "matrix")) {
    checkmate::assert(dim(x)[2] == length(mean),
                      .var.name = 'check that x has correct dimensions')
  }
  else if (inherits(x, "numeric") ) {
    checkmate::assert(length(x) == length(mean),
                      .var.name = 'check that x has correct length')
  }



  if (is.vector(x))
    x <- matrix(x, ncol = length(x))
  cholesky <- chol(sigma)
  tmp <- backsolve(cholesky, t(x) - mean, transpose = TRUE)
  xMx <- colSums(tmp ^ 2)
  ret <- - 0.5 * (ncol(x) * log(2 * pi) + 2* sum(log(diag(cholesky))) + xMx)
  if (log) {
    ret
  }
  else {
    exp(ret)
  }
}
