#' Unnormalized log-posterior for bioassay, assuming uniform prior
#' @param alpha intercept parameter in the dose-response model (single number)
#' @param beta slope parameter in the dose-response model (single number)
#' @param x vector of doses for each observation
#' @param y vector of number of deaths for each observation
#' @param n vector of number of animals for each observation
#' @export
bioassaylp <- function(alpha, beta, x, y, n) {
  checkmate::assertNumber(alpha)
  checkmate::assertNumber(beta)
  checkmate::assertNumeric(x, len = 4)
  checkmate::assertIntegerish(y, len = 4, lower = 0)
  checkmate::assertIntegerish(n, len = 4, lower = 1)

  t <- alpha + outer(beta,x)
  et <- exp(t)
  z <- et/(1 + et)

  # ensure that log(z) and log(1-z) are computable
  eps <- 1e-12
  z <- pmin(z, 1 - eps)
  z <- pmax(z, eps)
  lp <- rowSums(t(t(log(z)) * y) + t(t(log(1 - z)) * (n - y)))
  return(lp)
}

