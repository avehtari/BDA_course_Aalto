#' The density of a transformed t-distribution
#'
#' @param x vector of quantiles
#' @param df The number of degrees of freedom
#' @param mean Vector of means
#' @param scale Vector of scale/standard deviations
#' @param ... Further arguments passed to dt function
#' @export
dtnew <- function(x, df, mean = 0, scale = 1, ...) {
  checkmate::assertNumeric(x)
  checkmate::assertNumber(df, lower = 1e-6)
  checkmate::assertNumber(mean)
  checkmate::assertNumber(scale,lower = 1e-6)

  stats::dt((x - mean)/scale, df = df, ...) / scale
}
