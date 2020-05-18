#' ---
#' title: "Bayesian data analysis demo 4.1"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Hierarchical model for SAT-example data (BDA3, p. 120)
#' 

#' ggplot2, grid, and gridExtra are used for plotting, tidyr for
#' manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(gridExtra)
library(tidyr)
library(latex2exp)
library(rprojroot)
root<-has_dirname("BDA_R_demos")$make_fix_file()

#' Data 
y <- c(28,8,-3,7,-1,1,18,12)
s <- c(15,10,16,11,9,11,10,18)

#' Plot data, use normpdf to plot both the y_j and sigma_j
x <- seq(-40, 60, length.out = 500)
df_sep <- mapply(function(y, s, x) dnorm(x, y, s), y, s, MoreArgs = list(x = x)) %>%
  as.data.frame() %>% setNames(LETTERS[1:8]) %>% cbind(x) %>% gather(school, p, -x)
labs1 <- c('Other Schools', 'School A')
plot_sep <- ggplot(data = df_sep) +
  geom_line(aes(x = x, y = p, color = (school=='A'), group = school)) +
  labs(x = 'Treatment effect', y = '', title = 'Separate model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c('blue','red'), labels = labs1) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))
#+ fig.height=4
plot_sep

#' A pooled model
df_pool <- data.frame(x = x, p = dnorm(x, sum(y/s^2)/sum(1/s^2), sqrt(1/sum(1/s^2))))
#' Create plot for the pooled model
plot_pool <- ggplot(data = df_pool) +
  geom_line(aes(x = x, y = p, color = '1')) +
  labs(x = 'Treatment effect', y = '', title = 'Pooled model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = 'red', labels = 'All schools') +
  theme(legend.background = element_blank(), legend.position = c(0.7,0.9))

#' Load the pre-computed results for the hierarchical model
#' Replace this with your own code in the related exercise
load(root("demos_ch5","demo5_2.RData"))

#' Create plot for the hierarchical model
df_hier <- as.data.frame(t(pxm)) %>% setNames(LETTERS[1:8]) %>%
  cbind(x) %>% gather(school, p, -x)
plot_hier <- ggplot(data = df_hier) +
  geom_line(aes(x = x, y = p, color = (school=='A'), group = school)) +
  labs(x = 'Treatment effect', y = '', title = 'Hierarchical model', color = '') +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c('blue','red'), labels = labs1) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))

#' Plot separate, pooled, and hierarchical model
#+ fig.height=6
grid.arrange(plot_sep, plot_pool, plot_hier)

#' Various marginal and conditional posterior summaries
df_margpost = data.frame(x = t(tt), p = t(tp))
title1 <- TeX('Marginal posterior $p(\\tau | y)$')
plot_margpost <-
  ggplot(data = df_margpost) +
  geom_line(aes(x = x, y = p), color='forestgreen') +
  labs(x = expression(tau), y = TeX('$p(\\tau | y)$'), title = title1) +
    scale_y_continuous(breaks = 0) +
    xlim(c(0, 35))


df_condmeans <- as.data.frame(t(tm)) %>% setNames(LETTERS[1:8]) %>%
  cbind(x = t(tt)) %>% gather(school, p, -x)

yl <- c(-5, 40)
title2 <- TeX('Conditional means E\\[$\\theta_j | \\tau , y $\\]')
plot_condmeans <- ggplot(data = df_condmeans) +
  geom_line(aes(x = x, y = p, color = (school=='A'), group = school)) +
  coord_cartesian(ylim = yl, xlim = c(0, 35)) +
  labs(x = expression(tau), y = TeX('E\\[$\\theta_j | \\tau , y $\\]'), title = title2, color = '') +
  scale_color_manual(values = c('blue','red'), labels = labs1) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))

df_condsds <- as.data.frame(t(tsd)) %>% setNames(LETTERS[1:8]) %>%
  cbind(x = t(tt)) %>% gather(school, p, -x)

yl <- c(0, 25)
title3 <- TeX('Conditional standard deviations sd\\[$\\theta_j | \\tau , y $\\]')
plot_condsds <- ggplot(data = df_condsds) +
  geom_line(aes(x = x, y = p, color = (school=='A'), group = school)) +
  coord_cartesian(ylim = yl, xlim = c(0,35)) +
  labs(x = expression(tau), y = TeX('sd\\[$\\theta_j | \\tau , y $\\]'), title = title3, color = '') +
  scale_color_manual(values = c('blue','red'), labels = labs1) +
  theme(legend.background = element_blank(), legend.position = c(0.8,0.9))

#' Plot the posterior summaries
#+ fig.height=8
grid.arrange(plot_margpost, plot_condmeans, plot_condsds)
