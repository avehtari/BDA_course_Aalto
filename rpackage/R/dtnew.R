#' The Student-t Distribution
#'
#' Density, distribution function, quantile function and random generation for
#' the Student-t distribution with location/mean \code{mean}, scale
#' \code{scale}, and degrees of freedom \code{df}. See
#' https://en.wikipedia.org/wiki/Location\%E2\%80\%93scale_family for more details
#' on how to get from the standard t-distribution to the t-distribution with
#' additional location and scale parameters.
#'
#' @name StudentT
#'
#' @param x,q Vector of quantiles.
#' @param p Vector of probabilities.
#' @param n Number of samples to draw from the distribution.
#' @param mean Vector of location/mean values.
#' @param scale Vector of scale values.
#' @param df Vector of degrees of freedom.
#' @param log,log.p Logical; If \code{TRUE}, values are returned on the log scale.
#' @param lower.tail Logical; If \code{TRUE} (default), return P(X <= x).
#'   Else, return P(X > x) .
#'
#' @seealso \code{\link[stats:TDist]{TDist}}
#'
#' @export
dtnew <- function(x, df, mean = 0, scale = 1, log = FALSE) {
  checkmate::assertNumeric(x)
  checkmate::assertNumber(df, lower = 1e-6)
  checkmate::assertNumber(mean)
  checkmate::assertNumber(scale,lower = 1e-6)
  checkmate::assertLogical(log, len = 1)

  if (log) {
    stats::dt((x - mean) / scale, df = df, log = TRUE) - log(scale)
  } else {
    stats::dt((x - mean) / scale, df = df) / scale
  }
}

#' @rdname StudentT
#' @export
ptnew <- function(q, df, mean = 0, scale = 1,
                       lower.tail = TRUE, log.p = FALSE) {
  checkmate::assertNumeric(q)
  checkmate::assertNumber(df, lower = 1e-6)
  checkmate::assertNumber(mean)
  checkmate::assertNumber(scale,lower = 1e-6)
  checkmate::assertLogical(lower.tail, len = 1)
  checkmate::assertLogical(log.p, len = 1)

  stats::pt((q - mean) / scale, df = df, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname StudentT
#' @export
qtnew <-  function(p, df, mean = 0, scale = 1) {
  checkmate::assertNumeric(p,lower = 0, upper = 1)
  checkmate::assertNumber(df, lower = 1e-6)
  checkmate::assertNumber(mean)
  checkmate::assertNumber(scale,lower = 1e-6)

  mean + scale * stats::qt(p, df = df)
}

#' @rdname StudentT
#' @export
rtnew <- function(n, df, mean = 0, scale = 1) {
  checkmate::assertCount(n)
  checkmate::assertNumber(df, lower = 1e-6)
  checkmate::assertNumber(mean)
  checkmate::assertNumber(scale,lower = 1e-6)

  mean + scale * stats::rt(n, df = df)
}
