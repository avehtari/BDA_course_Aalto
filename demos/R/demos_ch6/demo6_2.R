#' ---
#' title: "Bayesian data analysis demo 6.2"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Posterior predictive checking demo
#' 
#' Checking the assumption of independence in binomial trials  (BDA3 p. 147)
#' 

#' ggplot2 is used for plotting, tidyr for manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(tidyr)
library(latex2exp)

#' Data
y <- c(1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0)
#' Compute test statistic for the data.
#' Test statistic is the number of switches from 0 to 1 or from 1 to 0.
Ty <- sum(diff(y) != 0) + 0.0

#' Sufficient statistics
n <- length(y)
s <- sum(y)

#' Compute test statistic for the replicate data.
rb <- function(s, n) {
  p <- rbeta(1, s+1, n-s+1)
  yr <- rbinom(n, 1, p)
  sum(diff(yr) != 0) + 0.0
}
Tyr <- data.frame(x = replicate(10000, rb(s, n)))
#' Compute posterior predictive p-value
mean(Tyr<=Ty)

#' Plot test statistics for the data and replicates.
#' Vertical line corresponds to the original data, and
#' the histogram to the replicate data.
title1 <- 'Binomial example - number of changes?
Pr(T(yrep,theta) <= T(y,theta)|y) = 0.03'
ggplot(data = Tyr) +
  geom_histogram(aes(x = x), fill = 'steelblue',
                 color = 'black', binwidth = 1) +
  geom_vline(aes(xintercept = x), data = data.frame(x = Ty),
             color = 'red') +
  labs(x = TeX('Number of changes in \\mathit{y} and \\mathit{y}^{\\mathrm{rep}}'),
       y = '', title = title1) +
  scale_y_continuous(breaks=NULL)

