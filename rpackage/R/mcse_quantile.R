#' Computes MCSE for quantile estimates based on independent draws
#' @param draws Monte Carlo draws
#' @param prob probability for which quantiles is computed
#' @export
#' @importFrom stats qbeta
mcse_quantile <- function(draws, prob) {
  checkmate::assertNumber(prob, lower = 0, upper = 1)
  checkmate::assertNumeric(draws)

  S <- length(draws)
  if (is.vector(draws)) {
    dim(draws) <- c(S, 1)
  }
  p <- c(0.1586553, 0.8413447, 0.05, 0.95)
  a <- qbeta(p, S * prob + 1, S * (1 - prob) + 1)
  sdraws <- sort(draws)
  S <- length(sdraws)
  th1 <- sdraws[max(round(a[1] * S), 1)]
  th2 <- sdraws[min(round(a[2] * S), S)]
  mcse <- (th2 - th1) / 2
  data.frame(mcse = mcse)
}
