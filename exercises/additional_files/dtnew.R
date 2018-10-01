#' Compute the density for the t distribution
dtnew <- function(x, df, mean=0, scale=1, ...) {
  dt((x-mean)/scale, df=df, ...) / scale
}
