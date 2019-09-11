#' The density of a transformed t-distribution
#' 
#' @param x vector of quantiles
#' @param df The number of degrees of freedom
#' @param mean Vector of means
#' @param scale Vector of scale/standard deviations
#' @param ... Further arguments passed to dt function
#' @export
dtnew <- function(x, df, mean=0, scale=1, ...) {
  stats::dt((x-mean)/scale, df=df, ...) / scale
}
