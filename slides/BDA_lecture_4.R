#' ---
#' title: "Bayesian data analysis - some figs for slides_ch10"
#' author: "Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' **Load packages**
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(dplyr)
library(tidyr)
library(rstanarm)
options(mc.cores = parallel::detectCores())
library(ggplot2)
library(grid)
library(gridExtra)
library(bayesplot)
library(latex2exp)
theme_set(bayesplot::theme_default(base_family = "sans", base_size=16))

#' ## Linear Gaussian model

#' The following file has Kilpisjärvi summer month temperatures 1952-2013:
d_kilpis <- read.delim('kilpisjarvi-summer-temp.csv', sep = ';')
d_lin <-data.frame(year = d_kilpis$year,
                   temp = d_kilpis[,5])

#' Plot the data
ggplot() +
  geom_point(aes(year, temp), data = data.frame(d_lin), size = 1, color='steelblue') +
  labs(y = 'Summer temp. @Kilpisjärvi', x= "Year", title='Data') +
  guides(linetype = F)

ggsave('figs/kilpis_data.pdf', width=6, height=4)

#' To analyse has there been change in the average summer month
#' temperature we use a linear model with Gaussian model for the
#' unexplained variation. rstanarm uses by default scaled priors.

#' y ~ x means y depends on the intercept and x
fit_lin <- stan_glm(temp ~ year, data = d_lin, family = gaussian(), iter = 8000)

#' Check the diagnostics
summary(fit_lin)

#' The effective sample size for slope is almost 4000, so we proceed
#' as if the draws would be independent, introducing a negligible
#' error in Monte Carlo error estimates

#' Plot data and the fit
samples_lin <- rstan::extract(fit_lin$stanfit, permuted = T)
mean(samples_lin$beta>0) # probability that beta > 0
mu_samples <- tcrossprod(cbind(1, d_lin$year), cbind(samples_lin$alpha,samples_lin$beta))

mu <- apply(mu_samples, 1, quantile, c(0.05, 0.5, 0.95)) %>%
  t() %>% data.frame(x = d_lin$year, .) %>% gather(pct, y, -x)
pfit <- ggplot() +
  geom_point(aes(year, temp), data = data.frame(d_lin), size = 1, color = 'steelblue') +
  geom_line(aes(x, y, linetype = pct), data = mu, color = 'black') +
  scale_linetype_manual(values = c(2,1,2)) +
  labs(x = 'Year', y = 'Summer temp. @Kilpisjärvi', title='Posterior fit with 90% interval') +
  guides(linetype = F) 
pfit
ggsave('figs/kilpis_pfit.pdf', width=6, height=4)

phist <- ggplot(data.frame(fit_lin, pars = c('year')), aes(x=year)) +
    geom_histogram(fill='steelblue', alpha=0.3) +
    scale_y_continuous(labels=NULL) +
    labs(title='Posterior of temperature change', x='C°/year', y='')
phist
ggsave('figs/kilpis_phist.pdf', width=5, height=4)

phist <- ggplot(data.frame(fit_lin, pars = c('year'))*100, aes(x=year)) +
    geom_histogram(fill='steelblue', alpha=0.3) +
    scale_y_continuous(labels=NULL) +
    labs(title='Posterior of temperature change', x='C°/century', y='')
phist
ggsave('figs/kilpis_phist100.pdf', width=5, height=4)

sims <- as.matrix(fit_lin)
phist +
    stat_function(fun = function(x) dnorm(x, mean(sims[,2]*100), sd(sims[,2]*100)/sqrt(100))*75, n = 501, color='black') +
    annotate('text', x=mean(sims[,2]*100), y=25, label='MCSE of posterior mean with S=100', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse1a.pdf', width=5, height=4)

phist +
    stat_function(fun = function(x) dnorm(x, mean(sims[,2]*100), sd(sims[,2]*100)/sqrt(1000))*75/sqrt(10), n = 501, color='black') +
    annotate('text', x=mean(sims[,2]*100), y=25, label='MCSE of posterior mean with S=1000', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse1b.pdf', width=5, height=4)

beta <- matrix(sims[,2]*100,nrow=100,ncol=40)
betastat<-apply(beta,2,function(x) quantile(x, probs=0.05))
phist +
    stat_function(fun = function(x) 180*dnorm(x, mean(betastat), sd(betastat)), n = 501, color='black') +
    annotate('text', x=quantile(sims[,2]*100, 0.05)+2.2, y=25, label='MCSE of 5% quantile with S=100', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse2a.pdf', width=5, height=4)

beta <- matrix(sims[,2]*100,nrow=100,ncol=40)
betastat<-apply(beta,2,function(x) quantile(x, probs=0.05))
phist +
    stat_function(fun = function(x) 180/sqrt(10)*dnorm(x, mean(betastat), sd(betastat)/sqrt(10)), n = 501, color='black') +
    annotate('text', x=quantile(sims[,2]*100, 0.05)+1.9, y=25, label='MCSE of 5% quantile with S=1000', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse2b.pdf', width=5, height=4)

betastat<-apply(beta,2,function(x) quantile(x, probs=0.01))
phist +
    stat_function(fun = function(x) 180*dnorm(x, mean(betastat), sd(betastat)), n = 501, color='black') +
    annotate('text', x=quantile(sims[,2]*100, 0.05)+2, y=25, label='MCSE of 1% quantile with S=100', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse3a.pdf', width=5, height=4)

beta <- matrix(sims[,2]*100,nrow=100,ncol=40)
betastat<-apply(beta,2,function(x) quantile(x, probs=0.01))
phist +
    stat_function(fun = function(x) 180/sqrt(10)*dnorm(x, mean(betastat), sd(betastat)/sqrt(10)), n = 501, color='black') +
    annotate('text', x=quantile(sims[,2]*100, 0.05)+1.55, y=25, label='MCSE of 1% quantile with S=1000', color='black', size=6)
ggsave('figs/kilpis_phist100_mcse3b.pdf', width=5, height=4)

pneg <- mean(sims[,2]<0)
# 0.0085 - 0.85%

pz100 <- ggplot(data = data.frame(x = c(0, 0.1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 1, shape2 = 101),
                  color = "black") +
    scale_y_continuous(labels=NULL) +
    labs(y='', x='p(temperature change < 0)', title='Posterior uncertainty p(temperature change < 0)') +
    annotate('text', x=0.005, y=75, label='Uncertainty given S=100, and 0 draws < 0', hjust='left',  size=5)
pz100
ggsave('figs/kilpis_ppneg_mcse1a.pdf', width=6, height=4)

pz100 <- pz100 +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 2, shape2 = 100),
                  color = "black") +
    annotate('text', x=0.015, y=37, label='Uncertainty given S=100, and 1 draw < 0', hjust='left',  size=5)    
pz100
ggsave('figs/kilpis_ppneg_mcse1b.pdf', width=6, height=4)

pz100 +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 3, shape2 = 99),
                  color = "black") +
    annotate('text', x=0.027, y=27, label='Uncertainty given S=100, and 2 draws < 0', hjust='left',  size=5)    
ggsave('figs/kilpis_ppneg_mcse1c.pdf', width=6, height=4)

# 1000
pz100 <- ggplot(data = data.frame(x = c(0, 0.1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 8+1, shape2 = 1000-8+1),
                  color = "black") +
    scale_y_continuous(labels=NULL) +
    labs(y='', x='p(temperature change < 0)', title='Posterior uncertainty p(temperature change < 0)') +
    annotate('text', x=0.012, y=100, label='Uncertainty given S=1000, and 8 draws < 0', hjust='left',  size=5)
pz100
ggsave('figs/kilpis_ppneg_mcse1000.pdf', width=6, height=4)

# 4000
pz100 <- ggplot(data = data.frame(x = c(0, 0.1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 34+1, shape2 = 4000-34+1),
                  color = "black") +
    scale_y_continuous(labels=NULL) +
    labs(y='', x='p(temperature change < 0)', title='Posterior uncertainty p(temperature change < 0)') +
    annotate('text', x=0.012, y=200, label='Uncertainty given S=4000, and 34 draws < 0', hjust='left',  size=5)
pz100
ggsave('figs/kilpis_ppneg_mcse4000.pdf', width=6, height=4)


#' Fake distribution
x <- seq(-4, 4, length.out = 200)
r <- c(1.1, 1.3, -0.1, -0.7, 0.2, -0.4, 0.06, -1.7,
      1.7, 0.3, 0.7, 1.6, -2.06, -0.74, 0.2, 0.5)

#' Compute unnormalized target density (named q, to emphesize that it
#' does not need to be normalized).
q <- density(r, bw = 0.5, n = 200, from = -4, to = 4)$y

#' Gaussian proposal distribution
g_mean <- 0
g_sd <- 1.1
g <- dnorm(x, g_mean, g_sd)

#' M is computed by discrete approximation
M <- max(q/g)
g <- g*M

#' One draw at -0.8
r1 = -0.8
zi = which.min(abs(x - r1)) # find the closest grid point
r21 = 0.3 * g[zi]
r22 = 0.8 * g[zi]

#' Visualize one accepted and one rejected draw:
df1 <- data.frame(x, q, g) %>% gather(grp, p, -x)
# subset with only target distribution
dfq <- subset(df1 , grp == "q")
# labels 
labs1 <- c('Mg(theta)','q(theta|y)')
ggplot() +
  geom_line(data = df1, aes(x, p, color = grp, linetype = grp)) +
  geom_area(data = dfq, aes(x, p), fill = 'lightblue', alpha = 0.3) +
  geom_point(aes(x[zi], r21), col = 'forestgreen', size = 2) +
  geom_point(aes(x[zi], r22), col = 'red', size = 2) +
  geom_segment(aes(x = x[zi], xend = x[zi], y = 0, yend = q[zi])) +
  geom_segment(aes(x = x[zi], xend = x[zi], y = q[zi], yend = g[zi]),
               linetype = 'dashed') +
  scale_y_continuous(breaks = NULL) +
  labs(y = '', x=TeX('$\\theta$')) +
  theme(legend.position = 'bottom', legend.title = element_blank()) +
  scale_linetype_manual(values = c('dashed', 'solid'), labels = labs1) +
  scale_color_discrete(labels = labs1) +
  annotate('text', x = x[zi] + 0.1, y = c(r21, r22),
           label = c('accepted', 'rejected'), hjust = 0, size=5)
ggsave('figs/rejection1.pdf', width=6, height=4)

#' 200 draws from the proposal distribution
nsamp <- 200
r1s <- rnorm(nsamp, g_mean, g_sd)
zis <- sapply(r1s, function(r) which.min(abs(x - r)))
r2s <- runif(nsamp) * g[zis]
acc <- ifelse(r2s < q[zis], 'a', 'r')

#' Visualize 200 draws, only some of which are accepted
df2 <- data.frame(r1s, r2s, acc)
# labels
labs2 <- c('Accepted', 'Rejected', 'Mg(theta)', 'q(theta|y)')
ggplot() +
  geom_line(data = df1, aes(x, p, color = grp, linetype = grp)) +
  geom_area(data = dfq, aes(x, p), fill = 'lightblue', alpha = 0.3) +
  geom_point(data = df2, aes(r1s, r2s, color = acc), size = 2) +
  geom_rug(data = subset(df2, acc== 'a'), aes(x = r1s, r2s),
           col = 'forestgreen', sides = 'b') +
  labs(y = '', x=TeX('$\\theta$')) +
  scale_y_continuous(breaks = NULL) +
  scale_linetype_manual(values = c(2, 1, 0, 0), labels = labs2) +
  scale_color_manual(values=c('forestgreen','red','#00BFC4','red'), labels = labs2) +
  guides(color=guide_legend(override.aes=list(
    shape = c(16, 16, NA, NA), linetype = c(0, 0, 2, 1),
    color=c('forestgreen', 'red', 'red', '#00BFC4'), labels = labs2)),
    linetype=FALSE) +
  theme(legend.position = 'bottom', legend.title = element_blank())
ggsave('figs/rejection2.pdf', width=6, height=4)

#' Rejection sampling for truncated distribution
q <- g
q[x < -1.5] <- 0
df1 <- data.frame(x, q, g) %>% gather(grp, p, -x)
acc <- ifelse(r1s > -1.5, 'a', 'r')
df2 <- data.frame(r1s, r2s, acc)
dfq <- subset(df1 , grp == "q")
# labels
labs2 <- c('Accepted', 'Rejected', 'Mg(theta)', 'q(theta|y)')
ggplot() +
  geom_line(data = df1, aes(x, p, color = grp, linetype = grp)) +
  geom_area(data = dfq, aes(x, p), fill = 'lightblue', alpha = 0.3) +
  geom_point(data = df2, aes(r1s, r2s, color = acc), size = 2) +
  geom_rug(data = subset(df2, acc== 'a'), aes(x = r1s, r2s),
           col = 'forestgreen', sides = 'b') +
  labs(y = '', x=TeX('$\\theta$')) +
  scale_y_continuous(breaks = NULL) +
  scale_linetype_manual(values = c(2, 1, 0, 0), labels = labs2) +
  scale_color_manual(values=c('forestgreen','red','#00BFC4','red'), labels = labs2) +
  guides(color=guide_legend(override.aes=list(
      shape = c(16, 16, NA, NA), linetype = c(0, 0, 2, 1),
      color=c('forestgreen', 'red', 'red', '#00BFC4'), labels = labs2)),
    linetype=FALSE) +
  theme(legend.position = 'bottom', legend.title = element_blank())
ggsave('figs/rejection3.pdf', width=6, height=4)

##
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
labsis <- c('q(theta)', 'g(theta|y)', 'Draws from g(theta|y)')

distr <- ggplot(data = df1) +
    geom_line(aes(x, p,  linetype = grp, color = grp)) +
    geom_point(data = df1[rsi,], aes(x = x, y = 0, color = grp),
               inherit.aes = TRUE, alpha = 0.5, color = 'red', size=2) +
  labs(title = 'Target, proposal, and draws', x = TeX('$\\theta$'), y = 'q, g') +
  theme(legend.position = 'bottom', legend.title = element_blank()) +
  scale_linetype_manual(values = c(2, 1, 1), labels = labsis) +
  scale_color_manual(values=c('red','#00BFC4','steelblue'), labels = labsis) +
  guides(color=guide_legend(override.aes=list(
      shape = c(16, 16), linetype = c(1, 2),
      color=c('#00BFC4', 'red'), labels = labsis[1:2])),
    linetype=FALSE) +
  theme(legend.position = c(0.7,0.8), legend.title = element_blank())
distr
ggsave('figs/importancesamp1.pdf', width=6, height=4)

#' Create a plot of the samples and importance weights
samp <- ggplot() +
  geom_line(aes(x, w, color = '1')) +
  geom_segment(aes(x = x[rsi], xend = x[rsi], y = 0, yend = wr),
               alpha = 0.5, color = 'red') +
  labs(title = 'Draws and importance weights', x = TeX('$\\theta$'), y = 'w') +
  scale_color_manual(values = c('steelblue'), labels = 'w(theta) = q(theta | y)/g(theta)') +
  theme(legend.position = c(0.5, 0.9), legend.title = element_blank())
samp
ggsave('figs/importancesamp2.pdf', width=6, height=4)

###
library(MASS)
library(loo)
set.seed(5710)

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
#' Make a helper function to calculate the log likelihood
#' given a dataframe with x, y, and n and evaluation
#' points a and b. For the likelihood see BDA3 p. 75
logl <- function(df, a, b)
  df['y']*(a + b*df['x']) - df['n']*log1p(exp(a + b*df['x']))
# calculate likelihoods: apply logl function for each observation
# ie. each row of data frame of x, n and y
p <- apply(df1, 1, logl, cA, cB) %>%
  # sum the log likelihoods of observations
  # and exponentiate to get the joint likelihood
  rowSums() %>% exp()

#' Sample from the grid (with replacement)
nsamp <- 1000
samp_indices <- sample(length(p), size = nsamp,
                       replace = T, prob = p/sum(p))
samp_A <- cA[samp_indices[1:nsamp]]
samp_B <- cB[samp_indices[1:nsamp]]
# add random jitter, see BDA3 p. 76
samp_A <- samp_A + runif(nsamp, (A[1] - A[2])/2, (A[2] - A[1])/2)
samp_B <- samp_B + runif(nsamp, (B[1] - B[2])/2, (B[2] - B[1])/2)

#' Compute LD50 for all draws
samp_ld50 <- -samp_A/samp_B

#' Create a plot of the posterior density
# limits for the plots
xl <- c(-2, 6)
yl <- c(-2, 35)
pos <- ggplot(data = data.frame(cA ,cB, p), aes(x = cA, y = cB)) +
  geom_raster(aes(fill = p, alpha = p), interpolate = T) +
  geom_contour(aes(z = p), colour = 'black', size = 0.2) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = TeX('$\\alpha$'), y = TeX('$\\beta$')) +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) +
  scale_alpha(range = c(0, 1), guide = F)
pos

#' Plot of the samples
sam <- ggplot(data = data.frame(samp_A, samp_B)) +
  geom_point(aes(samp_A, samp_B), color = 'blue', size = 0.3, alpha=0.5) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = TeX('$\\alpha$'), y = TeX('$\\beta$'))
sam

#' Plot of the histogram of LD50
his <- ggplot() +
  geom_histogram(aes(samp_ld50), binwidth = 0.05,
                 fill = 'steelblue', color = 'black') +
  coord_cartesian(xlim = c(-0.8, 0.8)) +
  labs(x = TeX('$LD50 = - \\alpha / \\beta$'))
his

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

#' Sample from the multivariate normal 
samp_norm <- mvrnorm(nsamp, w, S)

#' Samples of LD50 conditional beta > 0:
#' Normal approximation does not take into account that the posterior
#' is not symmetric and that there is very low density for negative
#' beta values. Based on the draws from the normal approximation
#' is is estimated that there is about 5% probability that beta is negative!
bpi <- samp_norm[,2] > 0
samp_norm_ld50 <- -samp_norm[bpi,1]/samp_norm[bpi,2]

#' Create a plot of the normal distribution approximation
pos_norm <- ggplot(data = data.frame(cA ,cB, p), aes(x = cA, y = cB)) +
  geom_raster(aes(fill = p, alpha = p), interpolate = T) +
  geom_contour(aes(z = p), colour = 'black', size = 0.2) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = TeX('$\\alpha$'), y = TeX('$\\beta$')) +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) +
  scale_alpha(range = c(0, 1), guide = F)
pos_norm

#' Plot of the samples
sam_norm <- ggplot(data = data.frame(samp_A=samp_norm[,1], samp_B=samp_norm[,2])) +
  geom_point(aes(samp_A, samp_B), color = 'blue', size = 0.3, alpha=0.5) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(x = TeX('$\\alpha$'), y = TeX('$\\beta$'))
sam_norm

#' Plot of the histogram of LD50
his_norm <- ggplot() +
  geom_histogram(aes(samp_norm_ld50), binwidth = 0.05,
                 fill = 'steelblue', color = 'black') +
  coord_cartesian(xlim = c(-0.8, 0.8)) +
  labs(x = TeX('$LD50 = - \\alpha / \\beta, \\beta > 0$'))
his_norm

