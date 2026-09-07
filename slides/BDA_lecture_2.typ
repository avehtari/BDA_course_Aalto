#import "@preview/mosaic:0.0.1" as m


#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 2],
  // authors: [Aki Vehtari, Osvaldo Martin],
  paper: "4-3",
)
#set page(fill: rgb("#ffffff"))
#set text(size: 21pt)
#show heading: set text(fill: rgb("#550e8b"))
#show "•": set text(fill: rgb("#6c3b91"))

#let redtext(x) = text(fill: rgb("#f66d7f"), x)
#let bluetext(x) = text(fill: rgb("#36acc6"), x)
#let graytext(x) = text(fill: rgb("#777777"), x)

#m.slide(layout: "title")


== Outline

- The Binomial model is very simple
    - used on its own:
        - coin tossing
        - chips from bag
        - COVID tests and vaccines
    - Commonly used as a building block, e.g., classification/logistic regression.
    - Useful to introduce observation model, likelihood,
      posterior, prior, marginalization, posterior summaries

== Outline of Chapter 2

-  2.1 Binomial model (repeated experiment with binary outcome)
-  2.2 Posterior as compromise between data and prior information
-  2.3 Posterior summaries
-  2.4 Informative prior distributions (skip exponential families and sufficient statistics)
-  2.5 Gaussian model with known variance
-  2.6 Other single parameter models
  -  the normal distribution with known mean but
      unknown variance is the most important
  -  glance through Poisson and exponential
-  2.7 glance through this example, which illustrates benefits of prior information, no need to read all the details (it's quite long example)
-  2.8--2.9 Noninformative and weakly informative priors

== Binomial: known $theta$

#m.steps.reveal[
  - Probability of event 1 in a trial: $theta$
  - Probability of event 2 in a trial: $1-theta$
  - Probability of several events, assuming independence, is e.g. \
    $theta theta (1-theta) theta (1-theta)(1-theta) dots$
  - If there are $n$ trials and order does not matter, then the probability that event 1 happens #redtext[$y$] times
    is $ p(#redtext[$y$]|theta,n) = binom(n, #redtext[$y$]) thin theta^(#redtext[$y$]) (1-theta)^(n-#redtext[$y$]) $
]


== Binomial: known $theta$

- #bluetext[Observation model] (function of #redtext[$y$], discrete)
$ p(#redtext[$y$]|theta,n) = binom(n, #redtext[$y$]) thin theta^(#redtext[$y$]) (1-theta)^(n-#redtext[$y$]) $

#m.steps.pause
#align(center)[#image("figs/dbinom1.pdf")]


== Binomial: known $theta$

- #bluetext[Observation model] (function of #redtext[$y$], discrete)
$ p(#redtext[$y$]|theta,n) = binom(n, #redtext[$y$]) thin theta^(#redtext[$y$]) (1-theta)^(n-#redtext[$y$]) $

#align(center)[#image("figs/dbinom10.pdf")]


== Binomial,what if $y=6$?

- #bluetext[Observation model] (function of #redtext[$y$], discrete)
$ p(#redtext[$y$]|theta,n) = binom(n, #redtext[$y$]) thin theta^(#redtext[$y$]) (1-theta)^(n-#redtext[$y$]) $

#align(center)[#image("figs/dbinom10_6.pdf")]


== Binomial, what if $y=9$?

- #bluetext[Observation model] (function of #redtext[$y$], discrete)
$ p(#redtext[$y$]|theta,n) = binom(n, #redtext[$y$]) thin theta^(#redtext[$y$]) (1-theta)^(n-#redtext[$y$]) $

#align(center)[#image("figs/dbinom10b_6.pdf")]


== Binomial: unknown $theta$ and $y=6$

- #bluetext[Likelihood] (function of #redtext[$theta$], continuous)
$ p(y|#redtext[$theta$],n) = binom(n, y) thin #redtext[$theta$]^(y) (1-#redtext[$theta$])^(n-y) $

#align(center)[#image("figs/lbinom10d.pdf")]


== Binomial: unknown $theta$ and $y=6$

- Theory: We can compute the value for any #redtext[$theta$]
- Practice: We can only evaluate a finite number of values

#align(center)[#image("figs/lbinom10a.pdf")]

== Binomial: unknown $theta$ and $y=6$

- But if we compute enough values and interpolate between them, the plot looks smooth

#align(center)[#image("figs/lbinom10c.pdf")]


== Binomial: unknown $theta$ and $y=6$

- #bluetext[Likelihood] (function of #redtext[$theta$], continuous)
$ p(y|#redtext[$theta$],n) = binom(n, y) thin #redtext[$theta$]^(y) (1-#redtext[$theta$])^(n-y) $
- likelihood function describes uncertainty, but is not normalized distribution
`integrate(function(theta) dbinom(6, 10, theta), 0, 1)` $approx 0.09 != 1$


== Posterior Distribution
#m.steps.reveal[
- Joint distribution $p(theta, y | M)$
  - $M$ stand for the model, sometimes is omitted
  - factors as $p(theta,y | #graytext[M]) = p(y|theta, #graytext[M]) p(theta|#graytext[M])$
 #v(1cm)
- #bluetext[Posterior] with Bayes rule (function of #redtext[$theta$], continuous)
  $ p(#redtext[$theta$]|y) = (p(y|#redtext[$theta$]) p(#redtext[$theta$])) / p(y) $
  #v(0.5cm)
  where $p(y)= integral p(y|#redtext[$theta$]) p(#redtext[$theta$]) dif #redtext[$theta$]$
]

== Binomial Posterior
#m.steps.reveal[
- Start with uniform prior
  $ p(#redtext[$theta$]) = 1, quad "when" quad 0 <= #redtext[$theta$] <= 1 $
- Then
  $ p(#redtext[$theta$]|y) &= (p(y|#redtext[$theta$])) / (p(y))
    = (binom(n,y) #redtext[$theta$]^y (1-#redtext[$theta$])^(n-y)) / (integral_0^1 binom(n,y) #redtext[$theta$]^y (1-#redtext[$theta$])^(n-y) dif #redtext[$theta$]) \
    &= 1/Z #redtext[$theta$]^y (1-#redtext[$theta$])^(n-y) $
]

== Binomial Posterior

#m.steps.reveal[
- Normalization term $Z$ (constant given $y$)
  $ Z = p(y) = integral_0^1 #redtext[$theta$]^y (1-#redtext[$theta$])^(n-y) dif #redtext[$theta$]
      = (Gamma(y+1) Gamma(n-y+1)) / Gamma(n+2) $
- Evaluate with $y=6, n=10$ \
  #text(size: 20pt)[
    `y<-6;n<-10;` \
    `integrate(function(theta) theta^y*(1-theta)^(n-y), 0, 1)` $approx 0.0004329$
  ]
  #text(size: 20pt)[
    `gamma(6+1)*gamma(10-6+1)/gamma(10+2)` $approx 0.0004329$
  ]
- #text(size: 20pt)[ usually computed via $log Gamma(dot)$ due to the limitations of floating point representation]
]

== Binomial Posterior

- Normalization term in closed form is not in general available
- Later we  will learn approximate integration methods that work without knowing the normalization term


== Binomial: unknown $theta$

  - Posterior is:
$ p(#redtext[$theta$] | y) = frac(Gamma(n + 2), Gamma(y + 1) Gamma(n - y + 1)) #redtext[$theta$]^(y)(1- #redtext[$theta$])^(n - y), $

#m.steps.pause
which is called Beta distribution 
$ #redtext[$theta$] | y tilde "Beta"(y + 1, n - y + 1) $
#v(0.5cm)
#align(center)[#image("figs/dbbeta10c.pdf", width:18cm)]


== Binomial: computation (R)

- density #raw("dbeta")
- CDF #raw("pbeta")
- quantile #raw("qbeta")
- random number #raw("rbeta")

== Binomial: computation (Python)

- #raw("from scipy.stats import beta")
- density #raw("beta.pdf")
- CDF #raw("beta.cdf")
- quantile #raw("beta.ppf")
- random number #raw("beta.rvs") 
\ 
- #raw("from preliz import Beta")
- Similar to scipy.stats
- Nicer features to explore distributions
- #link("https://preliz.readthedocs.io")


== Binomial: computation

- No simple formula exists for the Beta CDF
- Modern software use sophisticated numerical methods 
- Over 200 years ago, Laplace hit the same wall, so he invented the normal approximation (Laplace approximation, BDA3 Ch. 4)
\
#align(center)[#image("figs/dbbeta10c.pdf", width:19cm)]


== Placenta previa

- Probability of a girl birth given placenta previa (BDA3 p. 37)
  - 437 girls and 543 boys have been observed
  - is the proportion of girls 0.445 different from the population average 0.485?
#v(0.5cm)
#m.steps.pause
#align(center)[#image("figs/demo2_1.pdf", width:19cm)]


== Predictive distribution -- #text(size:25pt)[Effect of integration]

- Predictive distribution for new $tilde(y)$ (discrete)
  $ p(#redtext[$tilde(y)$=1]|y,M) &= integral_0^1 underbrace(p(#redtext[$tilde(y)$=1]|theta,y,M), theta) p(theta|y,M) dif theta \
    &= integral_0^1 theta p(theta|y,M) dif theta \
    &= EE[theta|y] $


== Predictive distribution -- #text(size:25pt)[Effect of integration]

- With uniform prior
  $ EE[theta|y] = (y+1) / (n+2) $

- Extreme cases
  $ p(tilde(y)=1|y=0) &= 1 / (n+2) \
    p(tilde(y)=1|y=n) &= (n+1) / (n+2) $
\
- cf. maximum likelihood
  $ p(tilde(y)=1|y=0) &= 0 \
    p(tilde(y)=1|y=n) &= 1 $


== Benefits of integration

Example: $n = 10, y = 10$
\
\
#align(center)[#image("figs/dbbeta10.pdf", width:18cm)]


== Predictive distribution

- #bluetext[Prior predictive] distribution for new $tilde(y)$ (discrete)
$ p(tilde(y) = 1| M) & = integral_(0)^(1) p(tilde(y) = 1| theta, M) #bluetext[p($theta$ | M)] d theta $

- #redtext[Posterior predictive] distribution for new $tilde(y)$ (discrete)
$ p(tilde(y) = 1| y, M) & = integral_(0)^(1) p(tilde(y) = 1| theta, y, M) #redtext[p($theta$ | y, M)] d theta $


== Left handedness
#m.steps.reveal[
- If we would like to provide scissors for all students, how many left handed scissors we would need?
- Posterior distribution for $theta$ is $ op(" Beta")(alpha + l, beta + r) $
- Posterior predictive distribution for $tilde(l)$ is: 
 $ op(" Beta-Binomial")(tilde(l) | N-n, alpha+l, beta+r) $
 #v(1cm)
- Demo: https://handedness.streamlit.app
]

== Priors

- Conjugate prior (BDA3 p. 35)
- Noninformative prior (BDA3 p. 51)
- Proper and improper prior (BDA3 p. 52)
- Weakly informative prior (BDA3 p. 55)
- Informative prior (BDA3 p. 55)
- Prior sensitivity (BDA3 p. 38)


== Conjugate prior

- Prior and posterior have the same form
  - only for a few cases like exponential family distributions

- Used to be important for computational reasons, and still sometimes used for special models to allow partial analytic marginalization (Ch 3)
  - with modern sampling methods like Hamiltonian Monte Carlo / NUTS no computational benefit

== Beta prior for Binomial model

#m.steps.reveal[
- Prior
  $ "Beta"(#redtext[$theta$] | alpha, beta) prop #redtext[$theta$]^(alpha - 1) (1 - #redtext[$theta$])^(beta - 1) $

- Posterior
  $ p(#redtext[$theta$] | y, M) & prop #redtext[$theta$]^y (1 - #redtext[$theta$])^(n - y) thick#redtext[$theta$]^(alpha - 1) (1 - #redtext[$theta$])^(beta - 1) \
    & prop #redtext[$theta$]^(y + alpha - 1) (1 - #redtext[$theta$])^(n - y + beta - 1) $

  after normalization \
  $ p(#redtext[$theta$] | y, M) = "Beta"(#redtext[$theta$] | alpha + y, beta + n - y) $

- $(alpha - 1)$ and $(beta - 1)$ can be considered to be the number of prior observations
- Uniform prior when $alpha = 1$ and $beta = 1$
]



== Benefits of integration and prior

Example: $n = 10, y = 10$ -- uniform vs Beta(2,2) prior

#align(center)[#image("figs/dbbeta10a.pdf")]

#m.steps.pause
#align(center)[#image("figs/dbbeta10b.pdf")]


== Beta prior for Binomial model

#m.steps.reveal[
- Posterior
  $ p(#redtext[$theta$] | y, M) = "Beta"(#redtext[$theta$] | alpha + y, beta + n - y) $

- Posterior mean
  $ E[#redtext[$theta$] | y] = (alpha + y) / (alpha + beta + n) $
  - combination of prior and likelihood information
  - when $n arrow.r infinity$, $E[#redtext[$theta$] | y] arrow.r y/n$

- Posterior variance
  $ "Var"[#redtext[$theta$] | y] = (E[#redtext[$theta$] | y] (1 - E[#redtext[$theta$] | y])) / (alpha + beta + n + 1) $
  - decreases when $n$ increases
  - when $n arrow.r infinity$, $"Var"[#redtext[$theta$] | y] arrow.r 0$
]

== Noninformative prior, proper and improper prior

- Vague, flat, diffuse, or noninformative
  - try to "let the data speak for themselves"
  - flat is not non-informative
  - flat can be stupid
  - making prior flat somewhere can make it non-flat somewhere else
\
- Proper prior has $integral p(theta) = 1$
- Improper prior density doesn't have a finite integral
  - the posterior can still sometimes be proper


== Weakly informative priors

#m.steps.reveal[
- Weakly informative priors produce computationally better behaving posteriors
  - quite often there's at least some knowledge about the scale
  - useful also if there's more information from previous observations, but not certain how well that information is applicable in a new case

- Construction
  - Start with some version of a noninformative prior distribution and then add enough information so that inferences are constrained to be reasonable.
  - Start with a strong, highly informative prior and broaden it to account for uncertainty in one's prior beliefs and in the applicability of any historically based prior distribution to new data.

- Stan team prior choice recommendations #link("https://github.com/stan-dev/stan/wiki/Prior-Choice-Recommendations")
]


== Informative prior for left handedness

#m.steps.reveal[
- Papadatou-Pastou et al. (2020). Human handedness: A meta-analysis. Psychological Bulletin, 146(6), 481--524. #link("https://doi.org/10.1037/bul0000229")
  - totaling 2,396,170 individuals
  - varies between 9.3% and 18.1%, depending on how handedness is measured
  - varies between countries and in time
]

== Informative prior for left handedness

#align(center)[#image("figs/left_handed_infographic_1.png", width: 15cm)]
#align(center)[#image("figs/left_handed_infographic_0.png", width: 15cm)]


#text(size: 10pt)[Fig from https://www.reddit.com/r/dataisbeautiful/comments/s9x1ya/history\_of\_lefthandedness\_oc/]

== Informative prior for left handedness

#align(center)[#image("figs/beta_8_60_prior.pdf")]
Demo: https://handedness.streamlit.app


== Benefits of integration and prior

- Left handed simulation with $L = 30$ left handed and $N = 300$ total

#align(center + horizon)[#image("figs/lefthand_simulation_phat.pdf", width: 27cm)]


== Benefits of integration and prior

- Left handed simulation with $L = 30$ left handed and $N = 300$ total

#align(center + horizon)[#image("figs/lefthand_simulation_yhat.pdf", width: 27cm)]


// == Benefits of integration and prior

// - Left handed simulation with true $theta = 0.1$ and $N = 300$
//   - repeated 10,000 times
//   - average log predictive probability for guessing $L$ after $n <= N$ observations

// #align(center + horizon)[#image("figs/lefthand_simulation_logscore_new.pdf")]


== But what if my prior is wrong?

- Introduce bias, but often still produce smaller estimation error because the variance is reduced
  - bias-variance tradeoff


== Structural information in predicting future
#align(center + horizon)[#image("figs/rstan_downloads_forecast.pdf")]

== Structural information in predicting future
#align(center + horizon)[#image("figs/rstan_downloads_forecast_zoomed.pdf")]

== Structural information in predicting future
#align(center + horizon)[#image("figs/rstan_downloads_components.pdf")]


== Structural information #text(size: 25pt)[Prophet by Facebook]
#align(center + horizon)[#image("figs/rstan_downloads_forecast.pdf")]

== Structural information #text(size: 25pt)[Prophet by Facebook]
#align(center + horizon)[#image("figs/rstan_downloads_forecast_zoomed.pdf")]

== Structural information #text(size: 25pt)[Prophet by Facebook]
#align(center + horizon)[#image("figs/rstan_downloads_components.pdf")]


== Sufficient statistics

#m.steps.reveal[
- The quantity $t(y)$ is said to be a _sufficient statistic_ for $theta$, because the likelihood for $theta$ depends on the data $y$ only through the value of $t(y)$.
- For binomial model the sufficient statistics are $y$ and $n$ (the order doesn't matter)
]


== Posterior visualization and inference demos

- demo2\_3: Simulate samples from Beta(438, 544), and draw a histogram of $theta$ with quantiles.

#align(center + horizon)[#image("figs/demo2_3.pdf")]


== Posterior visualization and inference demos

- demo2\_4: Compute posterior distribution in a grid.

#align(center + horizon)[#image("figs/demo2_4a.pdf")]


== Posterior visualization and inference demos

- demo2\_4: Sample using the inverse-cdf method.

#align(center + horizon)[#image("figs/demo2_4b.pdf")]


== Algae

_Algae status is monitored in 274 sites at Finnish lakes and rivers. The observations for the 2008 algae status at each site are presented in file_ algae.(rda|txt) _('0': no algae, '1': algae present)._ Let $theta$ be the probability of a monitoring site having detectable blue-green algae levels.

- Use a binomial model for observations and a $op("Beta")(2, 10)$ prior.
- What can you say about the value of the unknown $theta$?
- Experiment how the result changes if you change the prior.


== Binomial model with $theta = f(x)$

- Next week you learn how the binomial model parameter $theta$ can depend on some other measurement $x$

#align(center + horizon)[#image("figs/helicopter_results_all_years.pdf")]


== Normal / Gaussian

- Observations #redtext[$y$] real valued
- Mean $theta$ and variance $sigma^2$ (or standard deviation $sigma$) \

$ p(#redtext[$y$] | theta) = 1 / (sqrt(2 pi) sigma) exp(-(1 / (2 sigma^2)) (#redtext[$y$] - theta)^2) $
$ #redtext[$y$] tilde N(theta, sigma^2) $

#align(center)[#image("figs/kuva2b_1.pdf", width: 13cm)]


== Reasons to use Normal distribution

- Computational convenience
- Tradition
- Often good approximation (justification based on central limit theorem)


== Central limit theorem\*

#m.steps.reveal[
- Given certain conditions, distribution of sum (and mean) of random variables approach Gaussian distribution as $n arrow.r oo$
- Problems
  - does not hold for distributions with infinite variance, e.g., Cauchy
  - may require large $n$, e.g. Binomial, when $theta$ close to $0$ or $1$
  - does not hold if one of the variables has much larger scale
]


== Normal distribution -- conjugate prior for $theta$

- Assume $sigma^2$ known
  $ &"Likelihood" & p(y | #redtext[$theta$]) & prop exp(-(1 / (2 sigma^2)) (y - #redtext[$theta$])^2) \ \
    &"Prior" & p(#redtext[$theta$]) & prop exp(-(1 / (2 tau_0^2)) (#redtext[$theta$] - mu_0)^2) \ \
    & & exp(a) exp(b) & = exp(a + b) \ \
    & "Posterior" & p(#redtext[$theta$] | y) & prop exp(-(1/2) [ (y - #redtext[$theta$])^2 / sigma^2 + (#redtext[$theta$] - mu_0)^2 / tau_0^2 ]) $


== Normal distribution -- conjugate prior for $theta$

#m.steps.reveal[
- Posterior (highly recommended to do BDA3 Ex 2.14a)
  $ p(#redtext[$theta$] | y) & prop exp(-(1/2) [ (y - #redtext[$theta$])^2 / sigma^2 + (#redtext[$theta$] - mu_0)^2 / tau_0^2 ]) \
    & prop exp(-(1 / (2 tau_1^2)) (#redtext[$theta$] - mu_1)^2) $

  $ #redtext[$theta$] | y tilde N(mu_1, tau_1^2), quad "where" quad mu_1 = ((1/tau_0^2) mu_0 + (1/sigma^2) y) / ((1/tau_0^2) + (1/sigma^2)) quad "and" quad 1/tau_1^2 = 1/tau_0^2 + 1/sigma^2 $

- 1/variance = precision
- Posterior precision = prior precision + data precision
- Posterior mean is precision weighted mean
]

== Normal distribution -- example
#align(center + horizon)[#image("figs/pguess.pdf")]

== Normal distribution -- example
#align(center + horizon)[#image("figs/pguessprior.pdf")]

== Normal distribution -- example
#align(center + horizon)[#image("figs/ppost.pdf")]


== Normal distribution -- conjugate prior for $theta$

- Posterior predictive distribution
  $ p(#redtext[$tilde(y)$] | y) & = integral p(#redtext[$tilde(y)$] | theta) p(theta | y) dif theta \
    p(#redtext[$tilde(y)$] | y) & prop integral exp(-(1 / (2 sigma^2)) (#redtext[$tilde(y)$] - theta)^2) exp(-(1 / (2 tau_1^2)) (theta - mu_1)^2) dif theta \
    #redtext[$tilde(y)$] | y & tilde N(mu_1, sigma^2 + tau_1^2) $

- Predictive variance = observation model variance $sigma^2$ + \
  posterior variance $tau_1^2$


== Normal model

#m.steps.reveal[
- Gets more interesting when both mean and variance are unknown
  - next week
- The mean can be also a function of covariates
  - e.g. normal linear regression $y tilde N(alpha + beta x, sigma^2)$
- Gaussian processes, Kalman filters, variational inference, Laplace approximation, etc.
]


== Some other one parameter models

- Poisson, useful for count data (e.g. in epidemiology)
- Exponential, useful for time to an event (e.g. particle decay)


== Poisson model for count data

- Number of traffic deaths per year (by Liikenneturva)

#align(center + horizon)[
  #m.steps.replace(
    image("figs/traffic1.pdf", width: 20cm),
    image("figs/traffic2.pdf", width: 20cm),
    image("figs/traffic3.pdf", width: 20cm),
    image("figs/traffic4.pdf", width: 20cm),
    image("figs/traffic5.pdf", width: 20cm),
  )
]

== Thinking priors

- Make a guess of some quantities and then find out useful prior information for that. E.g.
  - proportion of students using MS Windows vs. Apple macOS vs. Linux
  - proportion of students who are taller than 1.9 m
  - proportion of students, who submitted the first assignment, attending the next lecture
  - proportion of students, who submitted the first assignment, submitting the last assignment
