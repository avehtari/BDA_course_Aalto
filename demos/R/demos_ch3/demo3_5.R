#' ---
#' title: "Bayesian data analysis demo 3.5"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Estimating the speed of light using normal model BDA3 p. 66
#'

#' ggplot2, and gridExtra are used for plotting, tidyr for
#' manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(gridExtra)
library(tidyr)
library(rprojroot)
root<-has_dirname("BDA_R_demos")$make_fix_file()

#' Data
y <- read.table(root("demos_ch3","light.txt"))$V1
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

#' Create a plot of the normal model
# gather the data points into key-value pairs
df2 <- gather(df1, grp, p, -t1)
# legend labels
labs2 <- c('Posterior of mu', 'Posterior of mu given y > 0', 'Modern estimate')
p2 <- ggplot(data = df2) +
  geom_line(aes(t1, p, color = grp)) +
  geom_vline(aes(xintercept = 33, color = 'q'),
             linetype = 'dashed', show.legend = F) +
  coord_cartesian(xlim = c(-42, 42)) +
  scale_y_continuous(breaks = NULL) +
  labs(title = 'Normal model', x = 'mu', y = '') +
  scale_color_manual(values = c('blue', 'darkgreen', 'black')) +
  guides(color=FALSE) +
  annotate("text", x=24, y=0.26, label=labs2[1], hjust="right", size=5) +
  annotate("text", x=26, y=0.58, label=labs2[2], hjust="right", size=5) +
  annotate("text", x=32, y=0.7, label=labs2[3], hjust="right", size=5)

#' Combine the plots
grid.arrange(p1, p2)

