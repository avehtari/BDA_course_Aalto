#' ---
#' title: "Bayesian data analysis - some figs for slides_ch2"
#' author: "Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' load packages
library(tidyverse)
library(purrr)
library(ggplot2)
theme_set(bayesplot::theme_default(base_family = "sans", base_size=16))

#' # Binomial model, Beta posterior
#' 

#' Binomial distribution with theta=0.5, n=1
ggplot(data.frame(x=0:1, y=dbinom(0:1, 1, 0.5)), aes(x=x, y=y)) +
    geom_col() +
    scale_x_discrete(breaks=0:1, limits=0:1) +
    labs(x="y", y="probability", title=bquote("Binomial distribution with " ~ theta ~ "=0.5, n=1"))

#' Binomial distribution with theta=0.5, n=10
ggplot(data.frame(x=0:10, y=dbinom(0:10, 10, 0.5)), aes(x=x, y=y)) +
    geom_col() +
    scale_x_discrete(breaks=0:10, limits=0:10) +
    labs(x="y", y="probability", title=bquote("Binomial distribution with " ~ theta~ "=0.5, n=10"))

#' Binomial distribution with theta=0.9, n=10
ggplot(data.frame(x=0:10, y=dbinom(0:10, 10, 0.9)), aes(x=x, y=y)) +
    geom_col() +
    scale_x_discrete(breaks=0:10, limits=0:10) +
    labs(x="y", y="probability", title=bquote("Binomial distribution with " ~ theta ~ "=0.9, n=10"))

#' Likelihood
ggplot(data.frame(x=seq(0,1,length.out=11), y=dbinom(6, 10, seq(0,1,length.out=11))), aes(x=x, y=y)) +
    geom_point() +
    scale_x_continuous(breaks=(0:10)/10) +
    labs(x=bquote(theta), y=bquote("Likelihood (probability of y=6 given" ~ theta ~ ")"), title=bquote("Likelihood given y=6, n=10"))
ggsave('figs/lbinom10a.pdf', width=6, height=4)

#' Likelihood
ggplot(data.frame(x=seq(0,1,length.out=101), y=dbinom(6, 10, seq(0,1,length.out=101))), aes(x=x, y=y)) +
    geom_point() +
    scale_x_continuous(breaks=seq(0,1,length.out=11)) +
    labs(x=bquote(theta), y=bquote("Likelihood (probability of y=6 given" ~ theta ~ ")"), title=bquote("Likelihood given y=6, n=10"))
ggsave('figs/lbinom10b.pdf', width=6, height=4)

#' Likelihood
ggplot(data.frame(x=seq(0,1,length.out=101), y=dbinom(6, 10, seq(0,1,length.out=101))), aes(x=x, y=y)) +
    geom_point() + geom_line() +
    scale_x_continuous(breaks=seq(0,1,length.out=11)) +
    labs(x=bquote(theta), y=bquote("Likelihood (probability of y=6 given" ~ theta ~ ")"), title=bquote("Likelihood given y=6, n=10"))
ggsave('figs/lbinom10c.pdf', width=6, height=4)

#' Likelihood
ggplot(data.frame(x=seq(0,1,length.out=101), y=dbinom(6, 10, seq(0,1,length.out=101))), aes(x=x, y=y)) +
    geom_line() +
    scale_x_continuous(breaks=seq(0,1,length.out=11)) +
    labs(x=bquote(theta), y=bquote("Likelihood (probability of y=6 given" ~ theta ~ ")"), title=bquote("Likelihood given y=6, n=10"))
ggsave('figs/lbinom10d.pdf', width=6, height=4)

integrate(function(x) dbinom(6, 10, x), 0, 1)

#' Posterior of theta of Binomial model with y=6, n=10 + unif prior
ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 7, shape2 = 5),
                  color = "blue") +
    labs(x=bquote(theta), y="", title=bquote("p(" ~ theta ~ "| y=6, n=10, M=binom) + unif. prior)"))

#' Posterior of theta of Binomial model with y=0, n=0
p1=ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 1, shape2 = 11),
                  color = "blue") +
    labs(x=bquote(theta), y="",
         title=bquote("Posterior of " ~ theta ~ " of Binomial model with y=0, n=10")) +
  theme(plot.title = element_text(size=16))

p1+ annotate(geom ="text", x=1/12, y=-0.5, label="Mean", color="white")
ggsave('binom_0_10_post.pdf',width=6,height=4)

p1 + geom_segment(x=1/12, xend=1/12, y=0, yend=11, color="red") +
  annotate(geom ="text", x=1/12, y=-0.5, label="Mean")
ggsave('binom_0_10_post_mean.pdf',width=6,height=4)

p1 + geom_segment(x=0/12, xend=0/12, y=0, yend=11, color="red") +
  annotate(geom ="text", x=0/12, y=-0.5, label="Mode")
ggsave('binom_0_10_post_mode.pdf',width=6,height=4)

#' Posterior of theta of Binomial model with y=150, n=1000
p1=ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 150+1, shape2 = 850+1),
                  color = "blue") +
    labs(x=bquote(theta), y="",
         title=bquote("Posterior of " ~ theta ~ " of Binomial model with y=150, n=1000")) +
  theme(plot.title = element_text(size=16))

p1+ annotate(geom ="text", x=151/1002, y=-0.5, label="Mean", color="white")
ggsave('binom_150_1000_post.pdf',width=6,height=4)

p1 + geom_segment(x=151/1002, xend=151/1002, y=0, yend=35, color="red") +
  annotate(geom ="text", x=151/1001, y=-0.5, label="Mean")
ggsave('binom_150_1000_post_mean.pdf',width=6,height=4)

p1 + geom_segment(x=149/998, xend=149/998, y=0, yend=35, color="red") +
  annotate(geom ="text", x=149/998, y=-0.5, label="Mode")
ggsave('binom_150_1000_post_mode.pdf',width=6,height=4)


#' Posterior of theta of Binomial model with y=10, n=10
ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 11, shape2 = 1),
                  color = "blue") +
    geom_segment(x=11/12, xend=11/12, y=0, yend=11, color="red") +
    annotate(geom ="text", x=11/12, y=-0.5, label="Mean")  +
    labs(x=bquote(theta), y="",
         title=bquote("Posterior of " ~ theta ~ " of Binomial model with y=10, n=10"))

#' Posterior of theta of Binomial model with y=10, n=10
ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 11, shape2 = 1),
                  color = "blue") +
    geom_segment(x=11/12, xend=11/12, y=0, yend=11, color="red") +
    annotate(geom ="text", x=11/12, y=-0.5, label="Mean")  +
    labs(x=bquote(theta), y="", title=bquote("p(" ~ theta ~ "| y=10, n=10, M=binom) + unif. prior"))

#' Posterior of theta of Binomial model with y=10, n=10 + Beta(2,2) prior
ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 12, shape2 = 2),
                  color = "blue") +
    geom_segment(x=12/14, xend=12/14, y=0, yend=11, color="red") +
    annotate(geom ="text", x=12/14, y=-0.5, label="Mean")  +
    labs(x=bquote(theta), y="", title=bquote("p(" ~ theta ~ "| y=10, n=10, M=binom) + Beta(2,2) prior"))

#' Posterior of theta of Binomial model with y=6, n=10 + unif prior
ggplot(data = data.frame(x = c(0, 1)), aes(x)) +
    stat_function(fun = dbeta, n = 601, args = list(shape1 = 7, shape2 = 5),
                  color = "blue") +
    labs(x=bquote(theta), y="", title=bquote("p(" ~ theta ~ "| y=6, n=10, M=binom) + unif. prior)"))


#' # Gaussian model with known variance, Gaussian posterior
#' 

#' fake data
tb <- tibble(id = c(1, 2), height_mu=c(175, 185), height_sd=c(4, 2))

#' population mean and standard deviation for male height in Finland
popmu=181;
popsd=6;

#' posterior functions
postsd <- function (priorsd, obssd) { sqrt(1/(1/priorsd^2+1/obssd^2)) }
postmu <- function (priormu, priorsd, obsmu, obssd) {
    (priormu/priorsd^2 + obsmu/obssd^2)/(1/priorsd^2+1/obssd^2) }

#' base for plots
pbase <- ggplot(data = data.frame(x = c(155, 205)), aes(x)) +
    labs(y="", x="Height in cm")

#' Plot fake guesses
guessdf <- pmap_df(tb, ~ data_frame(x = seq(150, 210, length.out = 601), id=..1,
                                   density = dnorm(x, ..2, ..3)))
pguess <- ggplot(guessdf, aes(group = id, x = x, y = density)) + 
    geom_line(linetype=1, color="blue")
pguess

#' Plot fake guesses + prior
pguess + 
    stat_function(fun = dnorm, n = 101, args = list(mean = popmu, sd = popsd),
                  color = "red")

#' Compute posterior mu and sd
tb <- mutate(tb,
             height_pmu = postmu(popmu, popsd, height_mu, height_sd),
             height_psd = postsd(popsd, height_sd)
             )

#' Compute posterior densities
postdf <- pmap_df(tb, ~ data_frame(x = seq(150, 210, length.out = 601), id=..1,
                                   density = dnorm(x, ..4, ..5)))

#' Plot posterior densities
ppost <- ggplot(guessdf, aes(group = id, x = x, y = density)) + 
    geom_line(linetype=1, color="blue") + 
    geom_line(data = postdf, linetype=1, color="violet") +
    stat_function(fun = dnorm, n = 101, args = list(mean = popmu, sd = popsd),
                  color = "red")
ppost


#' Benefits of integration and prior in the long run
library(khroma)
library(latex2exp)
library(directlabels)

#' Generate a single simulated data set for left handedness
set.seed(5710)
ntot=300
nleft=30
y=sample(c(rep(0,ntot-nleft),rep(1,nleft)), replace=FALSE, size=ntot)
#' Informative prior based on Wikipedia
a=8;b=60;

#' Parameter point estimates given from 1 to ntot observations
phat_ml=cumsum(y)/(1:ntot)
phat_bayes=(cumsum(y)+1)/((1:ntot)+2)
phat_bayes_prior=(cumsum(y)+a)/((1:ntot)+a+b)

#' Guess for the total number of left handed after 1 to ntot observations
yhat_ml=cumsum(y)+round(phat_ml*seq(ntot-1,0,by=-1))
yhat_bayes=cumsum(y)+round(phat_bayes*seq(ntot-1,0,by=-1))
yhat_bayes_prior=cumsum(y)+round(phat_bayes_prior*seq(ntot-1,0,by=-1))

#' Create a long format data frame for plotting
df<-data.frame(n=1:ntot,
               phat_ml, phat_bayes, phat_bayes_prior,
               yhat_ml, yhat_bayes, yhat_bayes_prior) |>
  pivot_longer(cols = matches("^[py]hat"),
               names_to = c(".value", "method"),
               names_pattern = "^(.*?)_(.*?)$") |>
  mutate(method = factor(method, levels = c("ml", "bayes", "bayes_prior"),
                         labels = c("MaxLik", "Bayes + unif.p.", "Bayes + info.p.")))

#' Plot parameter point estimates given from 1 to ntot observations
df |>
  ggplot(aes(x=n,y=phat,color=method)) +
  geom_line(size=1)+
  geom_hline(yintercept=p, linetype='dashed')+
  ylab(TeX("$\\hat{\\theta}$"))+
  theme(legend.position="none")+
  geom_dl(aes(label = method), method = list(dl.trans(x=x-0.2),cex=1.15,"first.points"))+
  scale_x_continuous(expand = expansion(mult = c(0.24, 0.02)))+
  scale_color_vibrant(name = "Estimate")+
  xlab("Number of observations")

ggsave('lefthand_simulation_phat.pdf',width=8,height=4)
  
#' Plot guess for the number of left handed after 1 to ntot observations
df |>
  ggplot(aes(x=n,y=yhat,color=method)) +
  geom_line(size=1)+
  geom_hline(yintercept=nleft, linetype='dashed')+
  ylab(TeX("$\\hat{y}$"))+
  theme(legend.position="none")+
  geom_dl(aes(label = method), method = list(dl.trans(x=x-0.2),cex=1.15,".points"))+
  scale_x_continuous(expand = expansion(mult = c(0.24, 0.02)))+
  scale_y_continuous(breaks=c(0,30,60,90))+
  scale_color_vibrant(name = "Estimate")+
  xlab("Number of observations")

ggsave('lefthand_simulation_yhat.pdf',width=8,height=4)


#' Repeat the simulation 10 000 times
#' Compute log score for predictive distributions
#' Log-score is log of the probability given the predictive distribution and the true nleft
ls_ml = ls_bayes = ls_bayes_prior = matrix(nrow=10000,ncol=ntot)
for (i in 1:10000) {
  y=sample(c(rep(0,ntot-nleft),rep(1,nleft)), replace=FALSE, size=ntot)
  phat_ml=cumsum(y)/(1:ntot)
  ls_ml[i,1:ntot]=(dbinom(x=nleft-cumsum(y),size=seq(299,0,by=-1),prob=phat_ml,log=TRUE))
  ls_bayes[i,1:ntot]=(dbbinom(x=nleft-cumsum(y),size=seq(299,0,by=-1),cumsum(y)+1,cumsum(1-y)+1,log=TRUE))
  ls_bayes_prior[i,1:ntot]=(dbbinom(x=nleft-cumsum(y),size=seq(299,0,by=-1),cumsum(y)+a,cumsum(1-y)+b,log=TRUE))
}

#' Compute the mean log score for each method
s_ml=colMeans(es_ml);
s_bayes=colMeans(es_bayes)
s_bayes_prior=colMeans(es_bayes_prior)
#' Include uniform predictive distribution as the reference
s_uniform = log(1/seq(300,1,by=-1))

#' Create a long format data frame for plotting
dfs<-data.frame(n=1:ntot,
               s_ml, s_bayes, s_bayes_prior, s_uniform) |>
  pivot_longer(cols = matches("^s"),
               names_to = c(".value", "method"),
               names_pattern = "^(.*?)_(.*?)$") |>
  mutate(method = factor(method, levels = c("ml", "bayes", "bayes_prior", "uniform"),
                         labels = c("MaxLik", "Bayes + unif.p.", "Bayes + info.p.", "Unif.p.")))

#' Plot probability of correct guess after 1 to ntot observations
dfs |>
  ggplot(aes(x=n,y=s,color=method)) +
  geom_line(aes(group=method),size=1)+
  ylab("Expected predictive log score")+
  scale_color_vibrant()+
  theme(legend.position="none")+
  geom_dl(aes(label = method), method = list(dl.trans(x=x-0.2,y=log(exp(y)+0.3)),"first.points",cex=1.15))+
  scale_x_continuous(expand = expansion(mult = c(0.24, 0.02)))+
  scale_y_continuous(expand = expansion(mult = c(0.08, 0)))+
  xlab("Number of observations")

ggsave('lefthand_simulation_logscore.pdf',width=8,height=4)
