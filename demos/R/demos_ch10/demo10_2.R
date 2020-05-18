#' ---
#' title: "Bayesian data analysis demo 10.2"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Importance sampling example
#' 

#' ggplot2 and gridExtra are used for plotting, tidyr for manipulating
#' data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(gridExtra)
library(tidyr)

#' Fake interesting distribution
x <- seq(-4, 4, length.out = 200)
r <- c(1.1, 1.3, -0.1, -0.7, 0.2, -0.4, 0.06, -1.7,
       1.7, 0.3, 0.7, 1.6, -2.06, -0.74, 0.2, 0.5)

#' Compute unnormalized target density (named q, to emphasize that it
#' does not need to be normalized).
q <- density(r, bw = 0.5, n = 200, from = -4, to = 4)$y

#' Gaussian proposal distribution
g <- dnorm(x)
w <- q/g
rs <- rnorm(100)
# find nearest point for which the kernel has been evaluated for each sample
rsi <- sapply(rs, function(arg) which.min(abs(arg - x)))
#' Self-normalized importance weights and the expectation wrt q
wr <- q[rsi]/dnorm(x[rsi])
wrn <- wr/sum(wr)
(Ex <- sum(wrn*x[rsi]))

#' Create a plot of the target and proposal distributions
df1 <- data.frame(x, q, g) %>% gather(grp, p, -x)
distr <- ggplot(data = df1) +
  geom_line(aes(x, p, fill = grp, color = grp)) +
  labs(title = 'Target and proposal distributions', x = '', y = '') +
  scale_color_discrete(labels = c('q(theta|y)', 'g(theta)')) +
  theme(legend.position = 'bottom', legend.title = element_blank())

#' Create a plot of the samples and importance weights
samp <- ggplot() +
  geom_line(aes(x, w, color = '1')) +
  geom_segment(aes(x = x[rsi], xend = x[rsi], y = 0, yend = wr),
               alpha = 0.5, color = 'steelblue') +
  labs(title = 'Samples and importance weights', x = '', y = '') +
  scale_color_manual(values = c('steelblue'), labels = 'q(theta|y)/g(theta)') +
  theme(legend.position = 'bottom', legend.title = element_blank())

#' Combine the plots
grid.arrange(distr, samp)
