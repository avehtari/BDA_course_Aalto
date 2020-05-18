#' ---
#' title: "Bayesian data analysis demo 10.1"
#' author: "Aki Vehtari, Markus Paasiniemi"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Rejection sampling example
#' 

#' ggplot2 is used for plotting, tidyr for manipulating data frames
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library(ggplot2)
theme_set(theme_minimal())
library(tidyr)

#' Fake interesting distribution
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
  labs(y = '') +
  theme(legend.position = 'bottom', legend.title = element_blank()) +
  scale_linetype_manual(values = c('dashed', 'solid'), labels = labs1) +
  scale_color_discrete(labels = labs1) +
  annotate('text', x = x[zi] + 0.1, y = c(r21, r22),
           label = c('accepted', 'rejected'), hjust = 0)

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
  labs(y = '') +
  scale_y_continuous(breaks = NULL) +
  scale_linetype_manual(values = c(2, 1, 0, 0), labels = labs2) +
  scale_color_manual(values=c('forestgreen','red','#00BFC4','red'), labels = labs2) +
  guides(color=guide_legend(override.aes=list(
    shape = c(16, 16, NA, NA), linetype = c(0, 0, 2, 1),
    color=c('forestgreen', 'red', 'red', '#00BFC4'), labels = labs2)),
    linetype=FALSE) +
  theme(legend.position = 'bottom', legend.title = element_blank())

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
  labs(y = '') +
  scale_y_continuous(breaks = NULL) +
  scale_linetype_manual(values = c(2, 1, 0, 0), labels = labs2) +
  scale_color_manual(values=c('forestgreen','red','#00BFC4','red'), labels = labs2) +
  guides(color=guide_legend(override.aes=list(
      shape = c(16, 16, NA, NA), linetype = c(0, 0, 2, 1),
      color=c('forestgreen', 'red', 'red', '#00BFC4'), labels = labs2)),
    linetype=FALSE) +
  theme(legend.position = 'bottom', legend.title = element_blank())
