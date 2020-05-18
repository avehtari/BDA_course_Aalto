#' ---
#' title: "Bayesian data analysis demo 4.1"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Hierarchical model for Rats experiment (BDA3, p. 102)
#' 

#' ggplot2, grid, and gridExtra are used for plotting, tidyr for
#' manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(gridExtra)
library(tidyr)
library(latex2exp)

#' Data
y <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,
        2,1,5,2,5,3,2,7,7,3,3,2,9,10,4,4,4,4,4,4,4,10,4,4,4,5,11,12,
        5,5,6,5,6,6,6,6,16,15,15,9,4)
n <- c(20,20,20,20,20,20,20,19,19,19,19,18,18,17,20,20,20,20,19,19,18,18,25,24,
       23,20,20,20,20,20,20,10,49,19,46,27,17,49,47,20,20,13,48,50,20,20,20,20,
       20,20,20,48,19,19,19,22,46,49,20,20,23,19,22,20,20,20,52,46,47,24,14)

#' Evaluate densities in grid
x <- seq(0.0001, 0.9999, length.out = 1000)

#' Helper function to evaluate density over observations
bdens <- function(n, y, x)
    dbeta(x, y+1, n-y+1)

#' Separate model
df_sep <- mapply(bdens, n, y, MoreArgs = list(x = x)) %>%
  as.data.frame() %>% cbind(x) %>% gather(ind, p, -x)

#' Plot the separate model
labs1 <- paste('posterior of', c('theta_j', 'theta_71'))
plot_sep <- ggplot(data = df_sep) +
  geom_line(aes(x = x, y = p, color = (ind=='V71'), group = ind)) +
  labs(x = expression(theta), y = '', title = 'Separate model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c('blue','red'), labels = labs1) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))
# The last one is for emphasize colored red
plot_sep

#' Pooled model
df_pool <- data.frame(x = x, p = dbeta(x, sum(y)+1, sum(n)-sum(y)+1))

#' Create a plot for the separate model
plot_pool <- ggplot(data = df_pool) +
  geom_line(aes(x = x, y = p, color = '1')) +
  labs(x = expression(theta), y = '', title = 'Pooled model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = 'red', labels = 'Posterior of common theta') +
  theme(legend.background = element_blank(), legend.position = c(0.7,0.9))

#' Plot both separate and pooled model
grid.arrange(plot_sep, plot_pool)

#' Compute the marginal posterior of alpha and beta in hierarchical model
#' Use grid
A <- seq(0.5, 6, length.out = 100)
B <- seq(3, 33, length.out = 100)
#' Make vectors that contain all pairwise combinations of A and B
cA <- rep(A, each = length(B))
cB <- rep(B, length(A))
#' Use logarithms for numerical accuracy!
lpfun <- function(a, b, y, n) log(a+b)*(-5/2) +
  sum(lgamma(a+b)-lgamma(a)-lgamma(b)+lgamma(a+y)+lgamma(b+n-y)-lgamma(a+b+n))
lp <- mapply(lpfun, cA, cB, MoreArgs = list(y, n))
#' Subtract maximum value to avoid over/underflow in exponentation
df_marg <- data.frame(x = cA, y = cB, p = exp(lp - max(lp)))

#' Create a plot of the marginal posterior density
title1 <- TeX('The marginal of $\\alpha$ and $\\beta$')
ggplot(data = df_marg, aes(x = x, y = y)) +
  geom_raster(aes(fill = p, alpha = p), interpolate = T) +
  geom_contour(aes(z = p), colour = 'black', size = 0.2) +
  coord_cartesian(xlim = c(1,5), ylim = c(4, 26)) +
  labs(x = TeX('$\\alpha$'), y = TeX('$\\beta$'), title = title1) +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) +
  scale_alpha(range = c(0, 1), guide = F)

#' Sample from the grid (with replacement)
nsamp <- 100
samp_indices <- sample(length(df_marg$p), size = nsamp,
                       replace = T, prob = df_marg$p/sum(df_marg$p))
samp_A <- cA[samp_indices[1:nsamp]]
samp_B <- cB[samp_indices[1:nsamp]]
df_psamp <- mapply(function(a, b, x) dbeta(x, a, b),
                  samp_A, samp_B, MoreArgs = list(x = x)) %>%
  as.data.frame() %>% cbind(x) %>% gather(ind, p, -x)


#' Create plot for samples from the distribution of distributions
#' Beta(alpha,beta), that is, plot Beta(alpha,beta) using posterior
#' samples of alpha and beta
# helper function to convert ind to numeric for subsetting
indtonum <- function(x) strtoi(substring(x,2))
title2 <- TeX('Beta($\\alpha,\\beta$) given posterior draws of $\\alpha$ and $\\beta$')
plot_psamp <- ggplot(data = subset(df_psamp, indtonum(ind) <= 20)) +
  geom_line(aes(x = x, y = p, group = ind), color='forestgreen') +
  labs(x = expression(theta), y = '', title = title2) +
  scale_y_continuous(breaks = NULL)

#' The average of above distributions, is the predictive distribution
#' for a new theta, and also the prior distribution for theta_j
df_psampmean <- spread(df_psamp, ind, p) %>% subset(select = -x) %>%
    rowMeans() %>% data.frame(x = x, p = .)

#' Create plot for samples from the predictive distribution for new theta
title3 <- TeX('Population distribution (prior) for $\\theta_j$')
plot_psampmean <- ggplot(data = df_psampmean) +
  geom_line(aes(x = x, y = p), color='forestgreen') +
  labs(x = expression(theta), y = '', title = title3) +
  scale_y_continuous(breaks = NULL)

#' Combine the plots
grid.arrange(plot_psamp, plot_psampmean)


#' And finally compare the separate model and hierarchical model
#' (using every seventh sample for clarity)

#' Create plot for the separate model
plot_sep7 <- ggplot(data = subset(df_sep, indtonum(ind)%%7==0)) +
  geom_line(aes(x = x, y = p, color = (ind=='V49'), group = ind)) +
  labs(x = expression(theta), y = '', title = 'Separate model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c('blue', 'red'), guide = F) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))

#' The hierarchical model
#' 
#' Note that these marginal posteriors for theta_j are more narrow than
#' in the separate model case, due to the borrowed information from the
#' other theta_j's
#' 
#' Average density over samples (of a and b) for each (n,y)-pair
#' at each point x
bdens2 <- function(n, y, a, b, x)
  rowMeans(mapply(dbeta, a + y, n - y + b, MoreArgs = list(x = x)))
df_hier <- mapply(bdens2, n, y, MoreArgs = list(samp_A, samp_B, x)) %>%
  as.data.frame() %>% cbind(x) %>% gather(ind, p, -x)

#' Create plot for the hierarchical model
plot_hier7 <- ggplot(data = subset(df_hier, indtonum(ind)%%7==0)) +
  geom_line(aes(x = x, y = p, color = (ind=='V49'), group = ind)) +
  labs(x = expression(theta), y = '', title = 'Hierarchical model', color = '') +
  scale_color_manual(values = c('blue', 'red'), guide = F) +
  scale_y_continuous(breaks = NULL) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))

#' Combine the plots
grid.arrange(plot_sep7, plot_hier7)

#' 90% intervals<br>
#' for separate models
qq_separate<-data.frame(id=1:length(n), n=n, y=y,
               q10=qbeta(0.1,y+1,n-y+1), q90=qbeta(0.9,y+1,n-y+1))
#' for hierarchical model
qh <- function(q, n, y) colMeans(mapply(function(q, n, y, a, b)
    mapply(qbeta, q, a + y, n - y + b), q, n, y, MoreArgs = list(samp_A, samp_B)))
qq_hier <- data.frame(id=1:length(n), n=n, y=y,
                      qh(0.05, n, y), qh(0.95, n, y))
#' plot

ggplot(data=qq_separate[seq(1,length(n),by=3),], aes(x=jitter(n,amount=1),ymin=q10,ymax=q90)) + geom_linerange() + xlim(c(0,60))
