#' ---
#' title: "Bayesian data analysis demo 6.1"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Posterior predictive checking of normal model for light data
#' 

#' ggplot2 is used for plotting, tidyr for manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(tidyr)
library(latex2exp)
library(rprojroot)
root<-has_dirname("BDA_R_demos")$make_fix_file()

#' Data
y <- read.table(root("demos_ch6","light.txt"))$V1
#' Sufficient statistics
n <- length(y)
s <- sd(y)
my <- mean(y)

#' Create 9 random replicate data sets from the posterior
#' predictive density.
#' Each set has same number of virtual observations as the
#' original data set.
sampt <- replicate(9, rt(n, n-1)*sqrt(1+1/n)*s+my) %>%
  as.data.frame()

#' Replace one of the replicates with observed data.
#' If you can spot which one has been replaced, it means
#' that the replicates do not resemble the original data
#' and thus the model has a defect
ind <- sample(9, 1)
sampt_y <- replace(sampt, ind, y) %>% setNames(1:9) %>% gather()
ggplot(data = sampt_y) +
  geom_histogram(aes(x = value), fill = 'steelblue',
                 color = 'black', binwidth = 4) +
  facet_wrap(~key, nrow = 3) +
  coord_cartesian(xlim = c(-55, 65)) +
  labs(x = '', y = '') +
  scale_y_continuous(breaks=NULL) +
  theme(strip.background = element_blank())

#' Generate 1000 replicate data sets and compute test statistic. The
#' test statistic here is the smallest observation in the data or in
#' the replicated data.
sampt1000 <- replicate(1000, rt(n, n-1)*sqrt(1+1/n)*s+my) %>%
  as.data.frame()
minvals <- data.frame(x = sapply(sampt1000, min))
#' Plot test statistic for the data and the replicated data sets
title1 <- 'Smallest observation in the replicated
data (hist.) vs in the original data (vertical line)'
ggplot(data = minvals) +
  geom_histogram(aes(x = x), fill = 'steelblue',
                 color = 'black', binwidth = 2) +
  geom_vline(aes(xintercept = min(x)), data = data.frame(x = y),
             color = 'red') +
  coord_cartesian(xlim = c(-50, 20)) +
  labs(x = TeX('Minimum of \\mathit{y} and \\mathit{y}^{\\mathrm{rep}}'),
       y = '', title = title1) +
  scale_y_continuous(breaks=NULL)
