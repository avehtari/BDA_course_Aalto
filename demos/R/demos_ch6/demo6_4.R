#' ---
#' title: "Bayesian data analysis demo 6.4"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Marginal posterior predictive checking
#' 
#' Tail area probabilities of marginal predictive distributions,
#' aka probability integral transformation (PIT).
#' 
#' Normal model for light speed data.
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

#' Tail area probabilities of marginal predictive distributions,
#' aka probability integral transformation (PIT)
Ty <- data.frame(x = pt((y - my)/(sqrt(1+1/n)*s), n-1))

#* Plot histogram of PIT values. Ideally histogram should be close to uniform.
title1 <- 'Light speed example
distribution of marginal posterior tail-values'
ggplot(data = Ty) +
  geom_histogram(aes(x = x), fill = 'steelblue',
                 color = 'black', binwidth = 0.05) +
  coord_cartesian(xlim = c(0, 1)) +
  labs(x = TeX('\\mathit{p}(\\mathit{y}^{\\mathrm{rep}}_{\\mathit{i}} < \\mathit{y_i} | \\mathit{y})'),
       y = '', title = title1) +
  scale_y_continuous(breaks=NULL)

#' Repeat the PIT checking after removing two "outliers"
y <- y[y>0]
#' Sufficient statistics
n <- length(y)
s <- sd(y)
my <- mean(y)

#' Tail area probabilities of marginal predictive distributions,
#' aka probability integral transformation (PIT)
Ty <- data.frame(x = pt((y - my)/(sqrt(1+1/n)*s), n-1))

#' Plot histogram of PIT values. Ideally histogram should be close to uniform.
title1 <- 'Light speed example
distribution of marginal posterior tail-values'
ggplot(data = Ty) +
  geom_histogram(aes(x = x), fill = 'steelblue',
                 color = 'black', binwidth = 0.05) +
  coord_cartesian(xlim = c(0, 1)) +
  labs(x = TeX('\\mathit{p}(\\mathit{y}^{\\mathrm{rep}}_{\\mathit{i}} < \\mathit{y_i} | \\mathit{y})'),
       y = '', title = title1) +
  scale_y_continuous(breaks=NULL)
