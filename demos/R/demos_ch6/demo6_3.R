#' ---
#' title: "Bayesian data analysis demo 6.3"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Posterior predictive checking demo
#' 
#' Light speed example with poorly chosen test statistic
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

#' Replicated data
sampt <- replicate(1000, rt(n, n-1)*sqrt(1+1/n)*s+my) %>%
  as.data.frame()
#' Test statistic here is variance, which is not a good choice as the
#' model has variance parameter and the posterior of that parameter
#' has been updated by the same data used now in checking.
sampt_vars <- data.frame(x = sapply(sampt, var))

#' Plot test statistics for the data and replicates.
#' Vertical line corresponds to the original data, and
#' the histogram to the replicate data.
title1 <- 'Light speed example with poorly chosen test statistic
Pr(T(yrep,theta) <= T(y,theta)|y)=0.42'
ggplot(data = sampt_vars) +
  geom_histogram(aes(x = x), fill = 'steelblue',
                 color = 'black', binwidth = 6) +
  geom_vline(aes(xintercept = x), data = data.frame(x = s^2),
             color = 'red') +
  labs(x = TeX('Variance of \\mathit{y} and \\mathit{y}^{\\mathrm{rep}}'),
       y = '', title = title1) +
  scale_y_continuous(breaks=NULL)

