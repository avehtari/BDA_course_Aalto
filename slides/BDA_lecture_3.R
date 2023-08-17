#' ---
#' title: "Bayesian data analysis - some figs for slides_ch3"
#' author: "Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' **Load packages**
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(dplyr)
library(tidyr)
library(purrr)
library(rstanarm)
options(mc.cores = parallel::detectCores())
library(ggplot2)
library(grid)
library(gridExtra)
library(bayesplot)
library(latex2exp)
theme_set(bayesplot::theme_default(base_family = "sans", base_size=16))

#' # Simple fake regression data
#'
#' Example from https://avehtari.github.io/modelselection/cv_basics.html
#' 
#' **Simulate fake data**
x <- 1:20
n <- length(x)
a <- 0.2
b <- 0.3
sigma <- 1
# set the random seed to get reproducible results
# change the seed to experiment with variation due to random noise
set.seed(2141) 
y <- a + b*x + sigma*rnorm(n)
fake <- data.frame(x, y)

#' **Fit linear model**
#+ results='hide'
fit_1 <- stan_glm(y ~ x, data = fake, seed=2141)
#+
print(fit_1, digits=2)

#' **Extract posterior draws**
sims <- as.matrix(fit_1)
n_sims <- nrow(sims)

#' **Compute predictive distribution given posterior mean and x=18**
cond<-data.frame(y=seq(0,9,length.out=100))
cond$x <- dnorm(cond$y, mean(sims[,1]) + mean(sims[,2])*18, mean(sims[,3]))*6+18

#' **Compute posterior predictive distribution given x=18**
condpred<-data.frame(y=seq(0,9,length.out=100))
condpred$x <- sapply(condpred$y, FUN=function(y) mean(dnorm(y, sims[,1] + sims[,2]*18, sims[,3])*6+18))

#' **Plot the data**
p1 <- ggplot(fake, aes(x = x, y = y)) +
    xlim(0,21) + ylim(0,9) +
    geom_point(color = "black", size = 2) +
    labs(title = "Data") 
p1
ggsave('figs/fakel_data.pdf', width=6, height=4)

#' **Plot posterior mean**
p2 <- p1 +
  geom_abline(
    intercept = mean(sims[, 1]),
    slope = mean(sims[, 2]),
    size = 1,
    color = "red"
  ) +
  labs(title = "Posterior mean") 
p2
ggsave('figs/fakel_postmean.pdf', width=6, height=4)

#' **Plot posterior mean**
p2p <- p2 +
    geom_path(data=cond,aes(x=x,y=y), color="red") +
    geom_vline(xintercept=18, linetype=2, color="red") +
    labs(title = "Predictive distribution given posterior mean") 
p2p

ggsave('figs/fakel_postmeanpred.pdf', width=6, height=4)

#' **Plot posterior draws**
p2s <- p2 +
    geom_abline(
        intercept = sims[seq(1,1001,by=10), 1],
        slope = sims[seq(1,1001,by=10), 2],
        size = 0.1,
        color = "blue",
        alpha = 0.2
    ) + ggtitle("Posterior draws")
p2s
ggsave('figs/fakel_postdraws.pdf', width=6, height=4)

#' **Plot posterior draws**
p2sp <- p2s +
    geom_path(data=condpred,aes(x=x,y=y), color="blue") +
    geom_vline(xintercept=18, linetype=2, color="blue") +
    ggtitle("Posterior draws and predictive distribution")
p2sp
ggsave('figs/fakel_postdrawspred.pdf', width=6, height=4)

p2sp <- p2s +
    geom_path(data=cond,aes(x=x,y=y), color="red") +
    geom_path(data=condpred,aes(x=x,y=y), color="blue") +
    geom_vline(xintercept=18, linetype=2, color="blue") +
    ggtitle("Posterior draws and predictive distribution")
p2sp
ggsave('figs/fakel_postdrawspred2.pdf', width=6, height=4)

#' # Simple fake univariate data

# set the random seed to get reproducible results
# change the seed to experiment with variation due to random noise
set.seed(2141) 
y <- sigma*rnorm(n)
fake <- data.frame(y)

#' **Fit normal**
#+ results='hide'
fit_1 <- stan_glm(y ~ 1, data = fake, seed=2141)
#+
print(fit_1, digits=2)

#' **Extract posterior draws**
sims <- as.matrix(fit_1)
n_sims <- nrow(sims)

#' **Compute predictive distribution given posterior mean**
pred<-data.frame(x=seq(-3,3,length.out=100))
pred$d <- dnorm(pred$x, mean(sims[,1]), mean(sims[,2]))

#' **Compute posterior predictive distribution**
postpred<-data.frame(x=seq(-3,3,length.out=100))
postpred$d <- sapply(postpred$x, FUN=function(y) mean(dnorm(y, sims[,1], sims[,2])))

#' **Plot the data**
p1 <- ggplot(fake, aes(x = y, y = 0)) +
    ylim(0,0.6) + xlim(-4,4) +
    geom_point(color = "black", size = 2) +
    labs(title = "Data", y="") 
p1
ggsave('figs/fakeg_data.pdf', width=6, height=4)

#' **Plot normal with posterior mean parameters**
p2 <- p1 +
    stat_function(fun = dnorm, n = 101,
                  args = list(mean = mean(sims[,1]), sd = mean(sims[,2]))) +
  labs(title = "Normal fit with posterior mean", y="density") 
p2
ggsave('figs/fakeg_postmean.pdf', width=6, height=4)

#' **Plot normal with posterior mean parameters + mean and sd**
muhat <- mean(sims[,1])
sigmahat <- mean(sims[,2])
p2mu <- p2 +
    geom_segment(aes(x=0, xend=0, y=0, yend=dnorm(0, 0, sigmahat)),
                 linetype=2) +
    annotate(geom = "text", x=0.2, y=0.05, label=TeX("$\\hat{\\mu}$"), size=6)
p2mu
ggsave('figs/fakeg_postmeanmu.pdf', width=6, height=4)

p2musd <- p2mu +
    geom_segment(aes(x=0, xend=sigmahat,
                     y=dnorm(sigmahat, muhat, sigmahat),
                     yend=dnorm(sigmahat, muhat, sigmahat)),
                 linetype=2) +
    annotate(geom = "text", x=0.5, y=0.22, label=TeX("$\\hat{\\sigma}$"),
             size=6)
p2musd
ggsave('figs/fakeg_postmeanmusigma.pdf', width=6, height=4)

#' **Plot posterior draws**
draws <- as.data.frame(fit_1)[seq(1,4000,length.out=100),]
colnames(draws)[1] <- "mu"
draws$id<-1:100
postdf <- pmap_df(draws, ~ data_frame(x = seq(-4, 4, length.out = 101), id=..3,
                                   density = dnorm(x, ..1, ..2)))
p2s <- p1 + 
    geom_line(data=postdf, aes(group = id, x = x, y = density),
              linetype=1, color="blue", alpha=0.2) +
    labs(title = "Normals with posterior draw parameters", y="density") 
p2s
ggsave('figs/fakeg_postgaussiandraws.pdf', width=6, height=4)

#' **Plot posterior draws and posterior draws of means**
p2sm <- p2s + 
    geom_segment(data=draws, aes(x=mu, xend=mu, y=0, yend=dnorm(0,0,sigma)),
                 linetype=1, color="blue", alpha=0.2) +
    xlab(TeX("y / $\\mu$"))
p2sm
ggsave('figs/fakeg_postgaussianmudraws.pdf', width=6, height=4)

ggplot(draws, aes(x=mu, y=sigma)) +
    geom_point(color="blue") +
    labs(x=TeX("$\\mu$"), y=TeX("$\\sigma$"),
         title = "Draws from the joint posterior distribution")
ggsave('figs/fakeg_postdraws100.pdf', width=6, height=4)

drawsall <- as.data.frame(fit_1)
colnames(drawsall)[1] <- "mu"
ggplot(drawsall, aes(x=mu, y=sigma)) +
    geom_point(color="blue") +
    labs(x=TeX("$\\mu$"), y=TeX("$\\sigma$"),
         title = "Draws from the joint posterior distribution")
ggsave('figs/fakeg_postdraws.pdf', width=6, height=4)

#' # Simple fake univariate data
#'
#' Code adapted from https://github.com/avehtari/BDA_R_demos/blob/master/demos_ch3/demo3_1_4.R
#'
#' **Generic part common for Demos 3.1-3.4**

#' Data
y <- c(93, 112, 122, 135, 122, 150, 118, 90, 124, 114)
#' Sufficient statistics
n <- length(y)
s2 <- var(y)
my <- mean(y)

#' Factorize the joint posterior p(mu,sigma2|y) to p(sigma2|y)p(mu|sigma2,y)
#' Sample from the joint posterior using this factorization
# helper functions to sample from and evaluate
# scaled inverse chi-squared distribution
rsinvchisq <- function(n, nu, s2, ...) nu*s2 / rchisq(n , nu, ...)
dsinvchisq <- function(x, nu, s2){
  exp(log(nu/2)*nu/2 - lgamma(nu/2) + log(s2)/2*nu - log(x)*(nu/2+1) - (nu*s2/2)/x)
}

#' Sample 1000 random numbers from p(sigma2|y)
ns <- 1000
set.seed(1)
sigma2  <- rsinvchisq(ns, n-1, s2)

#' Sample from p(mu|sigma2,y)
mu <- my + sqrt(sigma2/n)*rnorm(length(sigma2))

#' Create a variable sigma and
#' sample from predictive distribution p(ynew|y) for each draw of (mu, sigma)
sigma <- sqrt(sigma2)
ynew <- rnorm(ns, mu, sigma)

#' For mu, sigma and ynew compute the density in a grid
#' ranges for the grids
t1l <- c(90, 150)
t2l <- c(10, 60)
nl <- c(35, 200)
t1 <- seq(t1l[1], t1l[2], length.out = ns)
t2 <- seq(t2l[1], t2l[2], length.out = ns)
xynew <- seq(nl[1], nl[2], length.out = ns)

#' **Compute predictive distribution given posterior mean**
sigmahat<-sqrt(n/(n-1)*s2)
pred<-data.frame(x=xynew)
pred$d <- dnorm(pred$x, my, sigmahat)

#' **Compute posterior predictive distribution**
postpred<-data.frame(x=xynew)
postpred$d <- sapply(postpred$x, FUN=function(y) mean(dnorm(y, mu, sigma)))

#' **Plot the data**
p1 <- ggplot(data.frame(y), aes(x = y, y = 0)) +
    ylim(0,0.03) + xlim(nl) +
    geom_point(color = "black", size = 2) +
    labs(title = "Data", y="") 
p1
ggsave('figs/fake3_data.pdf', width=6, height=4)

#' **Plot normal with posterior mean parameters**
p2 <- p1 +
    stat_function(fun = dnorm, n = 101,
                  args = list(mean = my, sd = sigmahat)) +
  labs(title = "Normal fit with posterior mean", y="density") 
p2
ggsave('figs/fake3_postmean.pdf', width=6, height=4)

#' **Plot normal with posterior mean parameters + mean and sd**
p2mu <- p2 +
    geom_segment(aes(x=my, xend=my, y=0, yend=dnorm(0, 0, sigmahat)),
                 linetype=2) +
    annotate(geom = "text", x=121.5, y=0.003, label=TeX("$\\hat{\\mu}$"), size=6)
p2mu
ggsave('figs/fake3_postmeanmu.pdf', width=6, height=4)

p2musd <- p2mu +
    geom_segment(aes(x=my, xend=my+sigmahat,
                     y=dnorm(my+sigmahat, my, sigmahat),
                     yend=dnorm(my+sigmahat, my, sigmahat)),
                 linetype=2) +
    annotate(geom = "text", x=126, y=0.0115, label=TeX("$\\hat{\\sigma}$"),
             size=6)
p2musd
ggsave('figs/fake3_postmeanmusigma.pdf', width=6, height=4)

#' **Plot posterior draws**
draws <- data.frame(mu, sigma, id=1:1000)
postdf <- pmap_df(draws[1:100,], ~ data_frame(x = xynew, id=..3,
                                              density = dnorm(x, ..1, ..2)))
p2s <- p1 + 
    geom_line(data=postdf, aes(group = id, x = x, y = density),
              linetype=1, color="blue", alpha=0.2) +
    labs(title = "Normals with posterior draw parameters", y="density") 
p2s
ggsave('figs/fake3_postgaussiandraws.pdf', width=6, height=4)

#' **Plot posterior draws and posterior draws of means**
p2sm <- p2s + 
    geom_segment(data=draws[1:100,],
                 aes(x=mu, xend=mu, y=0, yend=dnorm(0,0,sigma)),
                 linetype=1, color="blue", alpha=0.2) +
    xlab(TeX("y / $\\mu$"))
p2sm
ggsave('figs/fake3_postgaussianmudraws.pdf', width=6, height=4)

ggplot(draws[1:100,], aes(x=mu, y=sigma)) +
    geom_point(color="blue") +
    labs(x=TeX("$\\mu$"), y=TeX("$\\sigma$"),
         title = "Draws from the joint posterior distribution")
ggsave('figs/fake3_postdraws100.pdf', width=6, height=4)

ggplot(draws, aes(x=mu, y=sigma)) +
    geom_point(color="blue") +
    labs(x=TeX("$\\mu$"), y=TeX("$\\sigma$"),
         title = "Draws from the joint posterior distribution")
ggsave('figs/fake3_postdraws.pdf', width=6, height=4)

#' Compute the exact marginal density of mu
# multiplication by 1./sqrt(s2/n) is due to the transformation of
# variable z=(x-mean(y))/sqrt(s2/n), see BDA3 p. 21
pm <- dt((t1-my) / sqrt(s2/n), n-1) / sqrt(s2/n)

#' Estimate the marginal density using samples
#' and ad hoc Gaussian kernel approximation
pmk <- density(mu, adjust = 2, n = ns, from = t1l[1], to = t1l[2])$y

#' Compute the exact marginal density of sigma
# the multiplication by 2*t2 is due to the transformation of
# variable z=t2^2, see BDA3 p. 21
ps <- dsinvchisq(t2^2, n-1, s2) * 2*t2

#' Estimate the marginal density using samples
#' and ad hoc Gaussian kernel approximation
psk <- density(sigma, n = ns, from = t2l[1], to = t2l[2])$y

#' Compute the exact predictive density
# multiplication by 1./sqrt(s2/n) is due to the transformation of variable
# see BDA3 p. 21
p_new <- dt((xynew-my) / sqrt(s2*(1+1/n)), n-1) / sqrt(s2*(1+1/n))

#' Evaluate the joint density in a grid.
#' Note that the following is not normalized, but for plotting
#' contours it does not matter.
# Combine grid points into another data frame
# with all pairwise combinations
dfj <- data.frame(t1 = rep(t1, each = length(t2)),
                  t2 = rep(t2, length(t1)))
dfj$z <- dsinvchisq(dfj$t2^2, n-1, s2) * 2*dfj$t2 * dnorm(dfj$t1, my, dfj$t2/sqrt(n))
# breaks for plotting the contours
cl <- seq(1e-5, max(dfj$z), length.out = 6)

theme_set(theme_minimal(base_size=16))

#' ### Demo 3.1 Visualise the joint and marginal densities
#' Visualise the joint density and marginal densities of the posterior
#' of normal distribution with unknown mean and variance.
#' 
#' Create a plot of the marginal density of mu
dfm <- data.frame(t1, Exact = pm, Empirical = pmk) %>% gather(grp, p, -t1)
margmu <- ggplot(dfm) +
  geom_line(aes(t1, p, color = grp)) +
  coord_cartesian(xlim = t1l) +
  labs(title = 'Marginal of mu', x = '', y = '') +
  scale_y_continuous(breaks = NULL) +
  theme(legend.background = element_blank(),
        legend.position = c(0.75, 0.8),
        legend.title = element_blank())
margmu
ggsave('figs/fake3_marginalmu.pdf', width=4, height=4)

#' Create a plot of the marginal density of sigma
dfs <- data.frame(t2, Exact = ps, Empirical = psk) %>% gather(grp, p, -t2)
margsig <- ggplot(dfs) +
  geom_line(aes(t2, p, color = grp)) +
  coord_cartesian(xlim = t2l) +
  coord_flip() +
  labs(title = 'Marginal of sigma', x = '', y = '') +
  scale_y_continuous(breaks = NULL) +
  theme(legend.background = element_blank(),
        legend.position = c(0.75, 0.8),
        legend.title = element_blank())
margsig
ggsave('figs/fake3_marginalsigma.pdf', width=4, height=4)

#' Create a plot of the joint density
joint1labs <- c('Samples','Exact contour')
joint1 <- ggplot() +
  geom_point(data = data.frame(mu,sigma), aes(mu, sigma, col = '1'), size = 0.1) +
  geom_contour(data = dfj, aes(t1, t2, z = z, col = '2'), breaks = cl) +
  coord_cartesian(xlim = t1l,ylim = t2l) +
  labs(title = 'Joint posterior', x = '', y = '') +
  scale_y_continuous(labels = NULL) +
  scale_x_continuous(labels = NULL) +
  scale_color_manual(values=c('blue', 'black'), labels = joint1labs) +
  guides(color = guide_legend(nrow  = 1, override.aes = list(
    shape = c(16, NA), linetype = c(0, 1), size = c(2, 1)))) +
  theme(legend.background = element_blank(),
        legend.position = c(0.5, 0.9),
        legend.title = element_blank())
joint1
ggsave('figs/fake3_joint1.pdf', width=4, height=4)

joint1 +
    labs(title = '', x = '', y = '') + guides(color=FALSE) +
    coord_cartesian(xlim = t1l,ylim = c(t2l[1],45))
ggsave('figs/fake3_joint1b.pdf', width=4, height=3)

#' Combine the plots
#+ blank, fig.show='hide'
# blank plot for combining the plots
bp <- grid.rect(gp = gpar(col = 'white'))
#+ combined
ga1<-grid.arrange(joint1, margsig, margmu, bp, nrow = 2)
ga1
ggsave('figs/fake3_joint_and_marginals.pdf', ga1, width=8, height=4)

#' ### Demo 3.2 Visualise factored distribution
#' Visualise factored sampling and the corresponding
#' marginal and conditional densities.
#' 

#' Create another plot of the joint posterior
# data frame for the conditional of mu and marginal of sigma
dfc <- data.frame(mu = t1, marg = rep(sigma[1], length(t1)),
                  cond = sigma[1] + dnorm(t1 ,my, sqrt(sigma2[1]/n)) * 100) %>%
  gather(grp, p, marg, cond)
# legend labels for the following plot
joint2labs <- c('Exact contour plot', 'Sample from joint post.',
               'Cond. distribution of mu', 'Sample from the marg. of sigma')
joint2 <- ggplot() +
  geom_contour(data = dfj, aes(t1, t2, z = z, col = '1'), breaks = cl) +
  geom_point(data = data.frame(m = mu[1], s = sigma[1]), aes(m , s, color = '2')) +
  geom_line(data = dfc, aes(mu, p, color = grp), linetype = 'dashed') +
  coord_cartesian(xlim = t1l,ylim = t2l) +
  labs(title = 'Joint posterior', x = '', y = '') +
  scale_x_continuous(labels = NULL) +
  scale_color_manual(values=c('black', 'red','darkgreen','black'), labels = joint2labs) +
  guides(color = guide_legend(nrow  = 2, override.aes = list(
    shape = c(NA, 16, NA, NA), linetype = c(1, 0, 1, 1)))) +
  theme(legend.background = element_blank(),
        legend.position = c(0.5, 0.85),
        legend.title = element_blank())
joint2
ggsave('figs/fake3_joint2.pdf', width=4, height=4)

#' Create another plot of the marginal density of sigma
margsig2 <- ggplot(data = data.frame(t2, ps)) +
  geom_line(aes(t2, ps), color = 'blue') +
  coord_cartesian(xlim = t2l) +
  coord_flip() +
  labs(title = 'Marginal of sigma', x = '', y = '') +
  scale_y_continuous(labels = NULL, breaks=NULL)
margsig2
ggsave('figs/fake3_marginalsigma2.pdf', width=4, height=4)

#' Combine the plots
grid.arrange(joint2, margsig2, ncol = 2)

#' ### Demo 3.3 Visualise the marginal distribution of mu
#' Visualise the marginal distribution of mu as a mixture of normals.
#' 

#' Calculate conditional pdfs for each sample
condpdfs <- sapply(t1, function(x) dnorm(x, my, sqrt(sigma2/n)))

#' Create a plot of some of them
# data frame of 25 first samples
dfm25 <- data.frame(t1, t(condpdfs[1:25,])) %>% gather(grp, p, -t1)
dfmean <- data.frame(t1, p=colMeans(condpdfs))
condmu <- ggplot(data = dfm25) +
  geom_line(aes(t1, p, group = grp), linetype = 'dashed') +
  labs(title = 'Cond distr of mu for 25 draws', y = '', x = '') +
    scale_y_continuous(breaks = NULL, limits = c(0, 0.1))
condmu
ggsave('figs/fake3_condsmu.pdf', width=4, height=4)

condmu +
    geom_line(data = dfmean, aes(t1, p), color = 'orange', size=2)
ggsave('figs/fake3_condsmumean.pdf', width=4, height=4)

#' create a plot of their mean
dfsam <- data.frame(t1, colMeans(condpdfs), pm) %>% gather(grp,p,-t1)
# labels
mulabs <- c('avg of sampled conds', 'exact marginal of mu')
meanmu <- ggplot(data = dfsam) +
  geom_line(aes(t1, p, size = grp, color = grp)) +
  labs(y = '', x = '', title = 'Cond. distr of mu') +
  scale_y_continuous(breaks = NULL, limits = c(0, 0.1)) +
  scale_size_manual(values = c(2, 0.8), labels = mulabs) +
  scale_color_manual(values = c('orange', 'black'), labels = mulabs) +
  theme(legend.position = c(0.8, 0.8),
        legend.background = element_blank(),
        legend.title = element_blank())
meanmu
ggsave('figs/fake3_marginalmu2.pdf', width=4, height=4)

#' Combine the plots
grid.arrange(condmu, meanmu, ncol = 1)

#' ### Demo 3.4 Visualise posterior predictive distribution.
#' Visualise sampling from the posterior predictive distribution.

#' Calculate each predictive pdf with given mu and sigma
ynewdists <- sapply(xynew, function(x) dnorm(x, mu, sigma))

#' Create plot of the joint posterior with a draw
#' from the posterior predictive distribution, highlight the first sample
#' create a plot of the joint density
# data frame of dirst draw from sample the predictive along with the exact value for plotting
dfp <- data.frame(xynew, draw = ynewdists[1,], exact = p_new)
# data frame for plotting the samples
dfy <- data.frame(ynew, p = 0.04*max(ynewdists)*runif(n=ns))
# legend labels
pred1labs <- c('Sample from the predictive distribution', 'Predictive distribution given the posterior sample')
pred2labs <- c('Samples from the predictive distribution', 'Exact predictive distribution')
joint3labs <- c('Samples', 'Exact contour')
joint3 <- ggplot() +
  geom_point(data = data.frame(mu, sigma), aes(mu, sigma, col = '1'), size = 0.1) +
  geom_contour(data = dfj, aes(t1, t2, z = z, col = '2'), breaks = cl) +
  geom_point(data = data.frame(x = mu[1], y = sigma[1]), aes(x, y), color = 'red') +
  coord_cartesian(xlim = t1l,ylim = t2l) +
  labs(title = 'Joint posterior', x = 'mu', y = 'sigma') +
  scale_color_manual(values=c('blue', 'black'), labels = joint3labs) +
  guides(color = guide_legend(nrow  = 1, override.aes = list(
    shape = c(16, NA), linetype = c(0, 1), size = c(2, 1)))) +
  theme(legend.background = element_blank(),
        legend.position=c(0.5 ,0.9),
        legend.title = element_blank())
joint3
ggsave('figs/fake3_joint3.pdf', width=4, height=4)

#' Create a plot of the predicitive distribution and the respective sample
pred1 <- ggplot() +
  geom_line(data = dfp, aes(xynew, draw, color = '2')) +
  geom_point(data = dfy, aes(ynew[1], p[1], color = '1'), size=1, shape=16) +
  coord_cartesian(xlim = nl, ylim = c(0,0.04)) +
  labs(title = 'Posterior predictive distribution', x = TeX('$\\tilde{y}$'), y = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c('red', 'blue'), labels = pred1labs) +
  guides(color = guide_legend(nrow = 2, override.aes = list(
    linetype = c(0, 1), shape=c(16, NA), labels = pred1labs))) +
  theme(legend.background = element_blank(),
        legend.position = c(0.5 ,0.9),
        legend.title = element_blank())
pred1
ggsave('figs/fake3_pred1.pdf', width=4, height=4)

#' Create a plot of the predicitive distribution as mixture of normals
pred1s <- pred1 + 
  geom_line(data=postdf, aes(group = id, x = x, y = density),
           linetype=1, color='blue', alpha=0.2)
pred1s
ggsave('figs/fake3_pred1s.pdf', width=4, height=4)

#' Create a plot of the predicitive distribution as mixture of normals
#' and draw from each
pred1ss <- pred1s +
    geom_point(data = dfy, aes(ynew, p, color = '1'), alpha=0.2, shape=16, size=1)
pred1ss
ggsave('figs/fake3_pred1ss.pdf', width=4, height=4)

#' Create a plot of the predicitive distribution as mixture of normals,
#' draw from each, and the exact predicitive distribution
pred1ss +
  geom_line(data = dfp, aes(xynew, draw, color = '3'), size=2) +
  scale_color_manual(values = c('red', 'blue', 'orange'), labels = c(pred1labs,'Exact predictive distribution')) +
  guides(color = guide_legend(nrow = 3, override.aes = list(
    linetype = c(0, 1, 1), shape=c(16, NA, NA), size=c(1.5,.5,2), labels = c(pred1labs,'Exact predictive distribution'))))
ggsave('figs/fake3_pred1ss_exact.pdf', width=4, height=4)


#' # Newcomb's speed of light data
#'
#' Code adapted from https://github.com/avehtari/BDA_R_demos/blob/master/demos_ch3/demo3_5.R
#'

y <- read.table("../../BDA_R_demos/demos_ch3/light.txt")$V1
#' Sufficient statistics
n <- length(y)
s2 <- var(y)
my <- mean(y)

#' Positive values only
y_pos <- y[y > 0]
#' Sufficient statistics
n_pos <- length(y_pos)
s2_pos <- var(y_pos)
my_pos <- mean(y_pos)

#' Compute the density of mu in these points
tl1 <- c(18, 34)
df1 <- data.frame(t1 = seq(tl1[1], tl1[2], length.out = 1000))

#' Compute the exact marginal density for mu
# multiplication by 1./sqrt(s2/n) is due to the transformation of variable
# z=(x-mean(y))/sqrt(s2/n), see BDA3 p. 21
df1$pm_mu <- dt((df1$t1 - my) / sqrt(s2/n), n-1) / sqrt(s2/n)

#' Compute the exact marginal density for mu for the positive data
df1$pm_mu_pos = dt((df1$t1 - my_pos) / sqrt(s2_pos/n_pos), n_pos-1) / sqrt(s2_pos/n_pos)

#' Create a histogram of the measurements
p1 <- ggplot() +
  geom_histogram(aes(y), binwidth = 2, fill = 'steelblue', color = 'black') +
  coord_cartesian(xlim = c(-42, 42)) +
  scale_y_continuous(breaks = NULL) +
  labs(title = 'Newcomb\'s measurements', x = 'y')
p1
ggsave('figs/newcomb_data.pdf', width=6, height=3)

#' Create a plot of the normal model
# gather the data points into key-value pairs
df2 <- gather(df1, grp, p, -t1)
# legend labels
labs2 <- c('Posterior of mu', 'Posterior of mu given y > 0', 'Modern estimate')
p2 <- ggplot(data = filter(df2, grp=="pm_mu")) +
    geom_line(aes(t1, p), color="blue") +
    coord_cartesian(xlim = c(-42, 42), ylim = c(0, 0.7)) +
    scale_y_continuous(breaks = NULL) +
    labs(title = 'Normal model', x = TeX('$\\mu$'), y = '') +
    annotate("text", x=24, y=0.26, label=labs2[1], hjust="right", size=5)
p2
ggsave('figs/newcomb_posterior1.pdf', width=6, height=3)

p2b <- p2 +
    geom_line(data = filter(df2, grp=="pm_mu_pos"),
              aes(t1, p), color="darkgreen") +
    annotate("text", x=26, y=0.58, label=labs2[2], hjust="right", size=5)
p2b
ggsave('figs/newcomb_posterior2.pdf', width=6, height=3)

p2c <- p2b +
  geom_vline(aes(xintercept = 33, color = '1'),
             linetype = 'dashed', color="black") +
    annotate("text", x=32, y=0.7, label=labs2[3], hjust="right", size=5)
p2c
ggsave('figs/newcomb_posterior3.pdf', width=6, height=3)


#' # Bioassay
#'
#' Code adapted from https://github.com/avehtari/BDA_R_demos/blob/master/demos_ch3/demo3_6.R
#'
#' **Generic part common for Demos 3.1-3.4**

theme_set(bayesplot::theme_default(base_family = "sans", base_size=16))
invlogit <- plogis
logit <- qlogis

#' Data
df1 <- data.frame(
  x = c(-0.86, -0.30, -0.05, 0.73),
  n = c(5, 5, 5, 5),
  y = c(0, 1, 3, 5)
)

#' Plot data small figure
theme_set(bayesplot::theme_default(base_family = "sans"))
pb1 <- ggplot(df1, aes(x=x, y=y)) +
    geom_point(size=3, color='red') +
    scale_x_continuous(breaks = df1$x, minor_breaks=NULL, limits=c(-.9,.9)) +
    scale_y_continuous(breaks = 0:5, minor_breaks=NULL) +
    labs(title = 'Data', x = 'Dose (log g/ml)', y = 'Number of deaths')
pb1
ggsave('figs/bioassay_data_small.pdf', width=3.4, height=2.9)

#' Plot data
theme_set(bayesplot::theme_default(base_family = "sans", base_size=16))
pb1 <- ggplot(df1, aes(x=x, y=y)) +
    geom_point(size=3, color='red') +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    scale_y_continuous(breaks = 0:5, minor_breaks=NULL) +
    labs(title = 'Data', x = 'Dose (log g/ml)', y = 'Number of deaths')
pb1
ggsave('figs/bioassay_data.pdf', width=6, height=4)

#' Fit normal regression (a wrong model)
fit0 <- stan_glm(y ~ x, data=df1)

#' Plot normal regression
pb2 <- pb1 +
    geom_abline(intercept = coef(fit0)[1], slope = coef(fit0)[2],
                linetype='dashed') +
    labs(title = 'Linear fit', x = 'Dose (log g/ml)', y = 'Number of deaths')
pb2
ggsave('figs/bioassay_fitlin.pdf', width=6, height=4)

#' Plot normal regression with extended range
pb3 <- pb2 +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    scale_y_continuous(breaks = -1:6, minor_breaks=NULL, limits=c(-.5,5.5)) +
    geom_hline(yintercept=c(0,5), color='lightgray')
pb3
ggsave('figs/bioassay_fitlin2.pdf', width=6, height=4)

#' Plot data as proportions
pb4 <- ggplot(df1, aes(x=x, y=y/n)) +
    geom_point(size=3, color='red') +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    scale_y_continuous(breaks=seq(0,1,length.out=6),minor_breaks=NULL) +
    labs(title = 'Data', x = 'Dose (log g/ml)', y = TeX('Proportion of deaths / $\\theta$')) +
    geom_hline(yintercept=c(0,1), color='lightgray')
pb4
ggsave('figs/bioassay_data2.pdf', width=6, height=4)

#' Fit Binomial model with logit link function
fit1 <- stan_glm(y/n ~ x, family = binomial(), weights = n, data=df1)

#' Plot Binomial model fit in logit space
pb5l <- ggplot(df1) +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    scale_y_continuous(minor_breaks=NULL) +
    labs(title = 'Logistic regression in latent space',
         x = 'Dose (log g/ml)', y = TeX('logit$(\\theta)$')) +
    stat_function(fun = function(x) (coef(fit1)[1]+coef(fit1)[2]*x), linetype = 'dashed', color='darkgreen')
         pb5l
ggsave('figs/bioassay_fitlogitspace.pdf', width=6, height=4)

#' Plot Binomial model fit in theta space
pb5 <- pb4 +
    stat_function(fun = function(x) invlogit(coef(fit1)[1]+coef(fit1)[2]*x), linetype = 'dashed', color='blue') +
    labs(title = 'Logistic regression fit',
         x = 'Dose (log g/ml)', y = TeX('Proportion of deaths / $\\theta$')) 
pb5
ggsave('figs/bioassay_fitbinom.pdf', width=6, height=4)

#' Compute posterior draws of logistic curves
draws <- as.data.frame(fit1)
colnames(draws) <- c('alpha', 'beta')
draws <- mutate(draws,
    id = 1:4000,
    ld50 = -alpha/beta
)
xr <- seq(-1.5, 1.5, length.out = 100)
draws100 <- draws[seq(1,4000,length.out=100),]
dff <- pmap_df(draws100, ~ data_frame(x = xr, id=..3,
                                   f = invlogit(..1 + ..2*x)))

#' Plot posterior draws of logistic curves
pb6 <- ggplot(df1, aes(x=x, y=y/n)) +
    geom_line(data=dff, aes(x=x, y=f, group=id),
              linetype=1, color='blue', alpha=0.2) +
    geom_point(size=3, color='red') +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    scale_y_continuous(breaks=seq(0,1,length.out=6),minor_breaks=NULL) +
    labs(title = 'Posterior draws', x = 'Dose (log g/ml)', y = TeX('Proportion of deaths / $\\theta$')) +
    geom_hline(yintercept=c(0,1), color='lightgray')
pb6
ggsave('figs/bioassay_post.pdf', width=6, height=4)

#' Plot posterior draws of logistic curves + posterior draws of LD50
pb6 + geom_hline(yintercept=c(0.5), color='lightgray',
                 linetype='dashed') +
    geom_point(data=draws100, aes(x=ld50, y=0.5), color='blue', alpha=0.2)
ggsave('figs/bioassay_postld50.pdf', width=6, height=4)

#' Plot histogram of posterior draws of LD50
ggplot(data=draws, aes(x=ld50)) +
    geom_histogram(fill='steelblue', color='black', bins=60) +
    scale_x_continuous(minor_breaks=NULL, limits=c(-1.5,1.5)) +
    labs(title = 'Bioassay LD50', x = 'Dose (log g/ml)', y = '')
ggsave('figs/bioassay_histld50.pdf', width=6, height=4)

#' Demonstrate grid evaluation and sampling
A = seq(-4, 8, length.out = 50)
B = seq(-10, 40, length.out = 50)
#' Make vectors that contain all pairwise combinations of A and B
cA <- rep(A, each = length(B))
cB <- rep(B, length(A))

#' Make a helper function to calculate the log likelihood
#' given a dataframe with x, y, and n and evaluation
#' points a and b. For the likelihood see BDA p. 75
logl <- function(df, a, b)
  df['y']*(a + b*df['x']) - df['n']*log1p(exp(a + b*df['x']))

#' Calculate likelihoods: apply logl function for each observation
#' ie. each row of data frame of x, n and y
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
#' Add random jitter, see BDA3 p. 76
samp_Aj <- samp_A + runif(nsamp, (A[1] - A[2])/2, (A[2] - A[1])/2)
samp_Bj <- samp_B + runif(nsamp, (B[1] - B[2])/2, (B[2] - B[1])/2)
#'  Create data frame
samps <- data_frame(ind = 1:nsamp, alpha = samp_A, beta = samp_B) %>%
  mutate(ld50 = - alpha/beta)
sampsj <- data_frame(ind = 1:nsamp, alpha = samp_Aj, beta = samp_Bj) %>%
  mutate(ld50 = - alpha/beta)

#' Create a plot posterior density evaluated in a grid
xl <- c(-1, 5)
yl <- c(-2, 30)
pos <- ggplot(data = data.frame(cA ,cB, p), aes(cA, cB)) +
  geom_raster(aes(fill = p), interpolate = T) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(title = 'Posterior density evaluated in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$')) +
  scale_fill_gradient(low = 'white', high = 'red') 

#' Plot posterior density evaluated in a grid with interpolation and contours
pos +  geom_contour(aes(z = p), colour = 'black', size = 0.2)
ggsave('figs/bioassay_grid1.pdf', width=6, height=4)

#' Plot posterior density evaluated in a grid with interpolation
pos
ggsave('figs/bioassay_grid2.pdf', width=6, height=4)

#' Plot posterior density evaluated in a grid without interpolation
pos <- ggplot(data = data.frame(cA ,cB, p), aes(cA, cB)) +
  geom_raster(aes(fill = p), interpolate = F) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(title = 'Posterior density evaluated in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$')) +
  scale_fill_gradient(low = 'white', high = 'red') 
pos
ggsave('figs/bioassay_grid3.pdf', width=6, height=4)
ggsave('figs/bioassay_grid3.png', width=6, height=4)

#' Plot posterior density evaluated in a grid and a posterior draw
pos + 
    geom_point(data = samps[1,], aes(alpha, beta), color = 'blue', size=1) +
    labs(title = 'Posterior density and draws in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$')) 
ggsave('figs/bioassay_grid4.pdf', width=6, height=4)
ggsave('figs/bioassay_grid4.png', width=6, height=4)

#' Plot posterior density evaluated in a grid and 100 posterior draws
pos + 
    geom_point(data = samps[1:100,], aes(alpha, beta), color = 'blue', size=1) +
    labs(title = 'Posterior density and draws in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$'))
ggsave('figs/bioassay_grid5.pdf', width=6, height=4)
ggsave('figs/bioassay_grid5.png', width=6, height=4)
## +
##     transition_reveal(id=id, along=ind) + 
##     shadow_trail(0.01)

#' Plot posterior density evaluated in a grid and 1000 posterior draws
pos + 
    geom_point(data = samps, aes(alpha, beta), color = 'blue', size=1) +
    labs(title = 'Posterior density and draws in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$')) 
ggsave('figs/bioassay_grid6.pdf', width=6, height=4)
ggsave('figs/bioassay_grid6.png', width=6, height=4)

pos + 
    geom_point(data = sampsj, aes(alpha, beta), color = 'blue', size=1) +
  labs(title = 'Posterior density in a grid and jittered draws', x = TeX('$\\alpha$'), y = TeX('$\\beta$'))
ggsave('figs/bioassay_grid7.pdf', width=6, height=4)
ggsave('figs/bioassay_grid7.png', width=6, height=4)

#' For illustration use coarser a grid
A = seq(-4, 8, length.out = 25)
B = seq(-10, 40, length.out = 25)

#' Make vectors that contain all pairwise combinations of A and B
cA <- rep(A, each = length(B))
cB <- rep(B, length(A))

#' Make a helper function to calculate the log likelihood
#' given a dataframe with x, y, and n and evaluation
#' points a and b. For the likelihood see BDA p. 75
logl <- function(df, a, b)
  df['y']*(a + b*df['x']) - df['n']*log1p(exp(a + b*df['x']))

#' Calculate likelihoods: apply logl function for each observation
#' ie. each row of data frame of x, n and y
p <- apply(df1, 1, logl, cA, cB) %>%
  # sum the log likelihoods of observations
  # and exponentiate to get the joint likelihood
    rowSums() %>% exp()

#' Plot posterior density evaluated in a coarser grid
xl <- c(-1, 5)
yl <- c(-2, 30)
posc <- ggplot(data = data.frame(cA ,cB, p), aes(cA, cB)) +
  geom_raster(aes(fill = p), interpolate = F) +
  coord_cartesian(xlim = xl, ylim = yl) +
  labs(title = 'Posterior density evaluated in a grid', x = TeX('$\\alpha$'), y = TeX('$\\beta$')) +
    scale_fill_gradient(low = 'white', high = 'red')
posc
ggsave('figs/bioassay_grid3_1.pdf', width=6, height=4)
ggsave('figs/bioassay_grid3_1.png', width=6, height=4)

#' Plot posterior density evaluated in a coarser grid and cell mid points
posc + geom_point(size=0.5)
ggsave('figs/bioassay_grid3_2.pdf', width=6, height=4)
ggsave('figs/bioassay_grid3_2.png', width=6, height=4)

#' Plot posterior density evaluated in a coarser grid and annotate three cells
posc + 
    annotate('text', x=cA[which(p==max(p))], y=cB[which(p==max(p))], label='1', size=5) +
    annotate('text', x=cA[which(p==max(p))+50], y=cB[which(p==max(p))+50], label='2', size=5) +
    annotate('text', x=cA[which(p==max(p))+100], y=cB[which(p==max(p))+100], label='3', size=5)
ggsave('figs/bioassay_grid3_3.pdf', width=6, height=4)
ggsave('figs/bioassay_grid3_3.png', width=6, height=4)

#' Densities and probabilities in three annotated cells
round(c(p[which(p==max(p))],p[which(p==max(p))+50],p[which(p==max(p))+100]),4)
pn <- p/sum(p)
round(c(pn[which(p==max(p))],pn[which(p==max(p))+50],pn[which(p==max(p))+100]),4)
