#' Implementation of log(1 / (1 + exp(-x))) robust to over- and under-flow
#' @param x numeric input
#' @export
log_inv_logit <- function(x) {
  ifelse(x < 0, x - log1p(exp(x)), -log1p(exp(-x)))
}

#' Implementation of log(1 - 1 / (1 + exp(-x))) robust to over- and under-flow
#' @param x numeric input
#' @export
log1m_inv_logit <- function(x) {
  ifelse(x > 0, -x - log1p(exp(-x)), -log1p(exp(x)))
}

#' Unnormalized log-posterior for bioassay, assuming uniform prior
#' @param alpha intercept parameter in the dose-response model (vector or single number)
#' @param beta slope parameter in the dose-response model (vector or single number)
#' @param x vector of doses for each observation
#' @param y vector of number of deaths for each observation
#' @param n vector of number of animals for each observation
#' @export
bioassaylp <- function(alpha, beta, x, y, n) {
  checkmate::assertNumeric(alpha)
  checkmate::assertNumeric(beta)
  checkmate::assertNumeric(x, len = 4)
  checkmate::assertIntegerish(y, len = 4, lower = 0)
  checkmate::assertIntegerish(n, len = 4, lower = 1)

  t <- alpha + outer(beta,x)
  lp <- rowSums(t(t(log_inv_logit(t)) * y) + t(t(log1m_inv_logit(t)) * (n - y)))
  return(lp)
}
