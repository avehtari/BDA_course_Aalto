#' ---
#' title: "Bayesian data analysis demo 2.3"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Probability of a girl birth given placenta previa (BDA3 p. 37).
#' 
#' Simulate samples from Beta(438,544), draw a histogram with
#' quantiles, and do the same for a transformed variable.
#' 

#' ggplot2 is used for plotting, tidyr for manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(tidyr)

#' Sample from posterior Beta(438,544).
#' Obtain all draws at once and store them in vector 'theta'
a <- 438
b <- 544
theta <- rbeta(10000, a, b)
#' Compute odds ratio for all draws
phi <- (1 - theta) / theta

#' Compute 2.5% and 97.5% quantile approximation using samples
quantiles <- c(0.025, 0.975)
thetaq <- quantile(theta, quantiles)
phiq <- quantile(phi, quantiles)

#' Histogram plots with 30 bins for theta and phi
# merge the data into one data frame for plotting
df1 <- data.frame(phi,theta) %>% gather()
# merge quantiles into one data frame for plotting
df2 <- data.frame(phi = phiq, theta = thetaq) %>% gather()
ggplot() +
  geom_histogram(data = df1, aes(value), bins = 30) +
  geom_vline(data = df2, aes(xintercept = value), linetype = 'dotted') +
  facet_wrap(~key, ncol = 1, scales = 'free_x')  +
  labs(x = '', y = '') +
  scale_y_continuous(breaks = NULL)

