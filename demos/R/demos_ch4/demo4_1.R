#' ---
#' title: "Bayesian data analysis demo 4.1"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Normal approximation for Bioassay model.
#'

#' ggplot2, grid, and gridExtra are used for plotting, tidyr for
#' manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
library(gridExtra)
library(tidyr)
library(MASS)

#' Bioassay data, (BDA3 page 86)
df1 <- data.frame(
  x = c(-0.86, -0.30, -0.05, 0.73),
  n = c(5, 5, 5, 5),
  y = c(0, 1, 3, 5)
)

#' ### Grid sampling for Bioassay model.

#' Compute the posterior density in a grid
#' 
#' - usually should be computed in logarithms!
#' - with alternative prior, check that range and spacing of A and B
#'   are sensible
A = seq(-1.5, 7, length.out = 100)
B = seq(-5, 35, length.out = 100)
# make vectors that contain all pairwise combinations of A and B
cA <- rep(A, each = length(B))
cB <- rep(B, length(A))
# a helper function to calculate the log likelihood
logl <- function(df, a, b)
  df['y']*(a + b*df['x']) - df['n']*log1p(exp(a + b*df['x']))
# calculate likelihoods: apply logl function for each observation
# ie. each row of data frame of x, n and y
p <- apply(df1, 1, logl, cA, cB) %>% rowSums() %>% exp()

#' Sample from the grid (with replacement)
nsamp <- 1000
samp_indices <- sample(length(p), size = nsamp,
                       replace = T, prob = p/sum(p))
samp_A <- cA[samp_indices[1:nsamp]]
samp_B <- cB[samp_indices[1:nsamp]]
# add random jitter, see BDA3 p. 76
samp_A <- samp_A + runif(nsamp, A[1] - A[2], A[2] - A[1])
samp_B <- samp_B + runif(nsamp, B[1] - B[2], B[2] - B[1])

#' Compute LD50 conditional beta > 0
bpi <- samp_B > 0
samp_ld50 <- -samp_A[bpi]/samp_B[bpi]

#' Create a plot of the posterior density
# limits for the plots
xl <- c(-1.5, 7)
yl <- c(-5, 35)
pos <- ggplot(data = data.frame(cA ,cB, p), aes(x = cA, y = cB)) +
  geom_raster(aes(fill = p, alpha = p), interpolate = T) +
  geom_contour(aes(z = p), colour = 'black', size = 0.2) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = 'alpha', y = 'beta') +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) +
  scale_alpha(range = c(0, 1), guide = F)

#' Plot of the samples
sam <- ggplot(data = data.frame(samp_A, samp_B)) +
  geom_point(aes(samp_A, samp_B), color = 'blue', size = 0.3) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = 'alpha', y = 'beta')

#' Plot of the histogram of LD50
his <- ggplot() +
  geom_histogram(aes(samp_ld50), binwidth = 0.04,
                 fill = 'steelblue', color = 'black') +
  coord_cartesian(xlim = c(-0.8, 0.8)) +
  labs(x = 'LD50 = -alpha/beta')

#' ### Normal approximation for Bioassay model.

#' Define the function to be optimized
bioassayfun <- function(w, df) {
  z <- w[1] + w[2]*df$x
  -sum(df$y*(z) - df$n*log1p(exp(z)))
}

#' Optimize
w0 <- c(0,0)
optim_res <- optim(w0, bioassayfun, gr = NULL, df1, hessian = T)
w <- optim_res$par
S <- solve(optim_res$hessian)

#' Multivariate normal probability density function
dmvnorm <- function(x, mu, sig)
  exp(-0.5*(length(x)*log(2*pi) + log(det(sig)) + (x-mu)%*%solve(sig, x-mu)))

#' Evaluate likelihood at points (cA,cB) 
#' this is just for illustration and would not be needed otherwise
p <- apply(cbind(cA, cB), 1, dmvnorm, w, S)

# sample from the multivariate normal 
normsamp <- mvrnorm(nsamp, w, S)

#' Samples of LD50 conditional beta > 0:
#' Normal approximation does not take into account that the posterior
#' is not symmetric and that there is very low density for negative
#' beta values. Based on the draws from the normal approximation
#' is is estimated that there is about 5% probability that beta is negative!
bpi <- normsamp[,2] > 0
normsamp_ld50 <- -normsamp[bpi,1]/normsamp[bpi,2]

#' Create a plot of the posterior density
pos_norm <- ggplot(data = data.frame(cA ,cB, p), aes(x = cA, y = cB)) +
  geom_raster(aes(fill = p, alpha = p), interpolate = T) +
  geom_contour(aes(z = p), colour = 'black', size = 0.2) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = 'alpha', y = 'beta') +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) +
  scale_alpha(range = c(0, 1), guide = F)

#' Plot of the samples
sam_norm <- ggplot(data = data.frame(samp_A=normsamp[,1], samp_B=normsamp[,2])) +
  geom_point(aes(samp_A, samp_B), color = 'blue', size = 0.3) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = 'alpha', y = 'beta')

#' Plot of the histogram of LD50
his_norm <- ggplot() +
  geom_histogram(aes(normsamp_ld50), binwidth = 0.04,
                 fill = 'steelblue', color = 'black') +
  coord_cartesian(xlim = c(-0.8, 0.8)) +
  labs(x = 'LD50 = -alpha/beta, beta > 0')

#' Combine the plots
grid.arrange(pos, sam, his, pos_norm, sam_norm, his_norm, ncol = 3)
