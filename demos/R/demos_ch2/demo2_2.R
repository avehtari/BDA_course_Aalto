#' ---
#' title: "Bayesian data analysis demo 2.2"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Probability of a girl birth given placenta previa (BDA3 p. 37)
#'
#' Illustrate the effect of prior and compare posterior distributions
#' with different parameter values for the beta prior distribution.
#' 

#' ggplot2 is used for plotting, tidyr for manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(tidyr)

#' Observed data: 437 girls and 543 boys
a <- 437
b <- 543

#' Evaluate densities at evenly spaced points between 0.375 and 0.525
df1 <- data.frame(theta = seq(0.375, 0.525, 0.001))

#' Posterior with Beta(1,1), ie. uniform prior
df1$pu <- dbeta(df1$theta, a+1, b+1)

#' 3 different choices for priors
#'
#' - Beta(0.488\*2,(1-0.488)\*2)
#' - Beta(0.488\*20,(1-0.488)\*20)
#' - Beta(0.488\*200,(1-0.488)\*200)
n <- c(2, 20, 200) # prior counts
apr <- 0.488 # prior ratio of success

# helperf returns for given number of prior observations, prior ratio
# of successes, number of observed successes and failures and a data
# frame with values of theta, a new data frame with prior and posterior
# values evaluated at points theta.
helperf <- function(n, apr, a, b, df)
  cbind(df, pr = dbeta(df$theta, n*apr, n*(1-apr)), po = dbeta(df$theta, n*apr + a, n*(1-apr) + b), n = n)
# lapply function over prior counts n and gather results into key-value pairs.
df2 <- lapply(n, helperf, apr, a, b, df1) %>% do.call(rbind, args = .) %>%
  gather(grp, p, -c(theta, n), factor_key = T)
# add correct labels for plotting
df2$title <- factor(paste0('alpha/(alpha+beta)=0.488, alpha+beta=',df2$n))
levels(df2$grp) <- c('Posterior with unif prior', 'Prior', 'Posterior')

#' Plot distributions
ggplot(data = df2) +
  geom_line(aes(theta, p, color = grp)) +
  geom_vline(xintercept = 0.488, linetype = 'dotted') +
  facet_wrap(~title, ncol = 1) +
  labs(x = '', y = '') +
  scale_y_continuous(breaks = NULL) +
  theme(legend.position = 'bottom', legend.title = element_blank())

