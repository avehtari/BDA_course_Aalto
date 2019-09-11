#' Plot the posterior density in a grid using the implemented function p_log_posterior
#' @param alpha_limits length-2 vector representing the min and max values of the intercept parameter in the dose-response model
#' @param beta_limits length-2 vector representing the min and max values of the slope parameter in the dose-response model
#' @export
bioassay_posterior_density_plot <- function(alpha_limits = c(0,1), beta_limits = c(0,10)) {
  # grid
  na <- 100
  nb <- 100
  ag <- seq(alpha_limits[1],alpha_limits[2],len=na)
  bg <- seq(beta_limits[1],beta_limits[2],len=nb)
  
  # compute unnormalized log-posterior density
  logpost <- matrix(nrow=length(ag), ncol=length(bg))
  for (i in 1:length(ag)) {
    for (j in 1:length(bg)) {
      logpost[i,j] <- p_log_posterior(ag[i],bg[j])
    }
  }
  # unnormalized posterior
  post <- exp(logpost - max(logpost))
  
  pp <- ggplot()
  pp <- pp + geom_raster(aes(x=rep(ag,nb), y=rep(bg,each=na), fill=as.vector(post)),interpolate=T)
  pp <- pp + xlim(c(alpha_limits[1],alpha_limits[2])) + ylim(c(beta_limits[1],beta_limits[2])) + xlab('alpha') + ylab('beta')
  pp
}

