#' Plot the posterior density in a grid using the implemented function p_log_posterior
#' @param alpha_limits length-2 vector representing the min and max values of the intercept parameter in the dose-response model
#' @param beta_limits length-2 vector representing the min and max values of the slope parameter in the dose-response model
#' @param x vector of doses for each observation
#' @param y vector of number of deaths for each observation
#' @param n vector of number of animals for each observation
#' @param p_log_posterior Function that outputs the logarithm of the posterior density. The function takes
#' as input 5 arguments: alpha, beta, x, y, n
#' @export
bioassay_posterior_density_plot <- function(alpha_limits = c(0,1), beta_limits = c(0,10), x, y, n, p_log_posterior) {
  checkmate::assertNumeric(alpha_limits, len = 2)
  checkmate::assertNumeric(beta_limits, len = 2)
  checkmate::assertNumeric(x, len = 4)
  checkmate::assertInteger(y, len = 4, lower = 0)
  checkmate::assertInteger(n, len = 4, lower = 1)
  checkmate::assertFunction(p_log_posterior, args = c("alpha","beta","x","y","n"))

  # grid
  na <- 100
  nb <- 100
  ag <- seq(alpha_limits[1],alpha_limits[2],len=na)
  bg <- seq(beta_limits[1],beta_limits[2],len=nb)

  # compute unnormalized log-posterior density
  logpost <- matrix(nrow=length(ag), ncol=length(bg))
  for (i in 1:length(ag)) {
    for (j in 1:length(bg)) {
      logpost[i,j] <- p_log_posterior(alpha = ag[i],beta = bg[j], x = x, y = y, n = n)
    }
  }
  # unnormalized posterior
  post <- exp(logpost - max(logpost))

  pp <- ggplot2::ggplot()
  pp <- pp + ggplot2::geom_raster(ggplot2::aes(x=rep(ag,nb), y=rep(bg,each=na), fill=as.vector(post)),interpolate=T)
  pp <- pp + ggplot2::xlim(c(alpha_limits[1],alpha_limits[2])) + ggplot2::ylim(c(beta_limits[1],beta_limits[2])) + ggplot2::xlab('alpha') + ggplot2::ylab('beta')
  pp
}

