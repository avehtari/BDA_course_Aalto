#import "@preview/mosaic:0.0.1" as m
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 8],
  //authors: [Aki Vehtari],
  paper: "4-3",
  // handout: true,
)
#set page(fill: rgb("#ffffff"))
#set text(size: 21pt)
#show heading: set text(fill: rgb("#550e8b"))
#show "•": set text(fill: rgb("#6c3b91"))
#let redtext(x) = text(fill: rgb("#f66d7f"), weight: "bold", math.bold(x))
#let bluetext(x) = text(fill: rgb("#36acc6"), weight: "bold", math.bold(x))
#let purpletext(x) = text(fill: rgb("#7c2695"), weight: "bold", math.bold(x))
#let yellowtext(x) = text(fill: rgb("#fac364"), weight: "bold", math.bold(x))
#let greentext(x) = text(fill: rgb("#006400"), weight: "bold", math.bold(x))
#let navytext(x) = text(fill: rgb("#000080"), x)

#let graytext(x) = text(fill: rgb("#777777"), x)

#let missing-fig(name) = rect(
  width: 100%,
  height: 7.5cm,
  stroke: 0.5pt,
  fill: rgb("#f5f5f5"),
  align(center + horizon)[#text(size: 14pt, fill: rgb("#777777"))[Missing figure: #name]],
)

#show raw.where(lang: "stan"): set raw(
  syntaxes: "Stan.sublime-syntax",
  theme: "Stan.tmTheme",
)
#m.slide(layout: "title")



== Objectives of this Lecture

- Understand the role of model checking in applied Bayesian statistics
- Discuss posterior predictive checks
- Leave-one-out cross-validation
- PSIS-LOO_CV (Fast cross-validation)
- Model comparison and selection



== The map is not the territory

- Models are simplified representations of reality
  - They can only capture certain aspects of reality and ignore others
  - Often details are omitted intentionally to keep the model simple and tractable
#v(0.5cm)
- Model checking helps us understand the limitations of our model and if they are adequate for our purposes


== Model checking

- External validation
  - compare to domain knowledge not used in modeling
  - compare predictions to completely new observations
#v(0.5cm)
- Internal validation
  - Compare predictions to the observed data
    - posterior predictive checking
    - cross-validation predictive checking


== Posterior predictive distribution

- Distribution of a new observation $tilde(y)$ given the observed data:
$ p(tilde(y) | y) = integral p(tilde(y) | theta) p(theta | y) d theta $

- Computationally, for $s = 1, ..., S$:
  - draw $theta^((s))$ from $p(theta | y)$
  - draw $tilde(y)^((s))$ from $p(tilde(y) | theta^((s)))$

- $tilde(y)$: any new, not yet observed data we want to predict
  (any size, possibly new $x$ values)
- $y^"rep"$: a replication of the original experiment, i.e. the
  same $x$ values and the same number of observations as $y$,
  used for model checking

== Posterior predictive checking

- Compute predictions $y^"rep"$ and compare them to the observed data $y$
- Assess how well the model captures the data, where it succeeds and where it fails
- If necessary, revise data, model or assumptions and repeat


== Posterior predictive checking

- This is a very general idea that can be adapted to different models and data
- There are some standard checks (often visual) and also recomendations for good practices
  #text(size:16pt)[
  - Gabry, Simpson, Vehtari, Betancourt, and Gelman (2019). Visualization in Bayesian workflow. #link("https://doi.org/10.1111/rssa.12378").
  - Säilynoja, Johnson, Martin, and Vehtari (2026). Recommendations for visual predictive checks in Bayesian workflow. #link("https://journals.aau.dk/index.php/jovi/article/view/11478")
  - EABM: predictive checks #link("https://arviz-devs.github.io/EABM/Chapters/Prior_posterior_predictive_checks.html")
  - Graphical posterior predictive checks: 
    - Bayesplot #link("http://mc-stan.org/bayesplot/articles/graphical-ppcs.html")
    - ArviZ #link("https://python.arviz.org/projects/plots/en/latest/gallery/index.html#predictive-checks")
  - brms demos #link("https://avehtari.github.io/BDA_R_demos/demos_rstan/brms_demo.html")
  ]

== Simon Newcomb's light of speed experiment in 1882

Newcomb measured ($n=66$) the time required for light to travel from his laboratory on the Potomac River to a mirror at the base of the Washington Monument and back, a total distance of 7422 meters.


== Posterior predictive checking -- bayesplot

```r
ppc_hist(y, yrep[1:8,])
```

#align(center)[#image("figs/Newcomb_ppc_hist.pdf", height: 15cm)]


== Posterior predictive checking -- bayesplot

```r
ppc_dens_overlay(y, yrep[1:100,])
```

#align(center)[#image("figs/Newcomb_ppc_dens_overlay.pdf", height: 15cm)]


== Posterior predictive checking -- bayesplot

```r
ppc_ecdf_overlay(y, yrep[1:100,])
```

#align(center)[#image("figs/Newcomb_ppc_ecdf_overlay.pdf", height: 15cm)]



== Posterior predictive checking with test statistic

- Choose a test statistic $T$ that summarizes the aspect of the data you want to check
- compute summary quantity for the observed data $T(y, theta)$
- compute summary quantity for a replicated data $T(y^"rep", theta)$


== Posterior predictive checking with test statistic

- Compute test statistic for data $T(y, theta) = min(y)$
- Compute test statistic $min(y^"rep")$ for many replicated datasets
#v(1cm)
```r
ppc_stat(y, yrep, stat = "min")
```
#align(center)[#image("figs/Newcomb_ppc_stat_min.pdf", height: 11cm)]


== Posterior predictive checking -- example

- Good test statistic is (almost) _ancillary_ (fi: _aputunnusluku_)
  - ancillary = distribution of T(y) does not depend on the model parameters $theta$ (like the minimum in a normal model)
- Bad test statistic is highly dependent on the parameters
  - e.g. mean or variance for normal model

#align(center)[#image("figs/light_ppc_var.pdf", width: 17cm)]


== Posterior predictive $p$-value

- Probability that replicated data are at least as extreme as observed data
  $ p = Pr(T(y^"rep", theta) >= T(y, theta) | y) $
- Discussed in BDA3, but not commonly used, as
  - not calibrated for non-ancillary test statistics
  - the full distribution of the test statistic contains more information than a single number



== Posterior predictive checking with PIT

- Instead of one $p$-value for a test statistic, check calibration of each observation
- Posterior predictive PIT (probability integral transform) for $y_i$
  $ "PIT"_i = Pr(y_i^"rep" <= y_i | y) $
- If the model is calibrated, $"PIT"_i$ are (approximately) uniformly distributed
  - the test statistic is $T(y_i^"rep") = y_i^"rep"$, so no need to choose one
  - discrete $y$: use randomized PIT

== PPC PIT -- example

#align(center)[#image("figs/ppc_pit.png", width: 22cm)]

== PPC PIT -- interpretation

#align(center)[#image("figs/ppc_pit_fails.png", width: 28cm)]


== Posterior predictive samples -- what you need

- Stan: `generated quantities` block with `_rng` functions
- rstanarm, brms: `posterior_predict(fit)`
- PyMC: `pm.sample_posterior_predictive(idata)`
- bambi: `model.predict(idata, kind="response")`


== Posterior predictive checking -- Stan code

- demo demos_rstan/ppc/poisson-ppc.Rmd

#text(size: 16pt)[
```stan
data {
  int<lower=1> N;
  array[N] int<lower=0> y;
}
parameters {
  real<lower=0> lambda;
}
model {
  lambda ~ exponential(0.2);
  y ~ poisson(lambda);
}
```
]

#text(size: 16pt)[
```stan
generated quantities {
  real log_lik[N];
  array[N] int y_rep;
  for (n in 1:N) {
    y_rep[n] = poisson_rng(lambda);
    log_lik[n] = poisson_lpmf(y[n] | lambda);
    }
}
```
]


== PPC for count data -- Poisson model

```r
ppc_dens_overlay(y, yrep[1:50,])
```

#align(center)[#image("figs/poisson_ppc_dens_overlay.pdf", height: 14cm)]


== PPC for count data -- Poisson model

```r
ppc_rootogram(y, yrep, style="discrete")
```

#align(center)[#image("figs/poisson_ppc_rootogram.png", height: 14cm)]


== PPC for count data -- Poisson model

```r
prop_zero <- function(x) mean(x == 0)
ppc_stat(y, yrep, stat = "prop_zero")
```

#align(center)[#image("figs/poisson_ppc_stat_propzero.pdf", height: 14cm)]


== PPC for count data -- hurdle truncated Poisson model

```r
ppc_rootogram(y, yrep2, style="discrete")
```

#align(center)[#image("figs/poisson2_ppc_rootogram.png", height: 14cm)]


== PPC for count data -- hurdle truncated Poisson model

```r
prop_zero <- function(x) mean(x == 0)
ppc_stat(y, yrep2, stat = "prop_zero")
```

#align(center)[#image("figs/poisson2_ppc_stat_propzero.pdf", height: 14cm)]


== Posterior predictive checking

#text(size: 18pt)[meta-analysis: Pharmacologic treatments for chronic obstructive pulmonary disease]

Pooled over studies, separate for treatments

#text(size: 14pt)[
```r
fit_pooled <- brm(exac | trials(total) ~ 0 + treatment,
                  prior = prior(student_t(7, 0, 1.5), class='b'),
                  family=binomial(), data=dat.baker2009)
```
]

#align(center)[#image("figs/baker2009_pooled_studies_ppc_dens_overlay.pdf", width: 15cm)]


== Posterior predictive checking

#text(size: 18pt)[meta-analysis: Pharmacologic treatments for chronic obstructive pulmonary disease]

Hierarchical for studies, hierarchical for treatments

#text(size: 14pt)[
```r
fit_hier <- brm(exac | trials(total) ~ (1 | treatment) + (1 | study),
                family=binomial(), data=dat.baker2009)
```
]

#align(center)[#image("figs/baker2009_hier1_ppc_dens_overlay.pdf", width: 15cm)]

- For very flexible models posterior predictive checks may become very optimistic.


== Student retention #text(size: 24pt)[Posterior predictive distributions]

Latent hierarchical linear model

#align(center)[#image("figs/student_retention_lbinom_preds.pdf", height: 7cm)]

Latent hierarchical linear model + spline

#align(center)[#image("figs/student_retention_sbinom_preds.pdf", height: 7cm)]


== Student retention -- Marginal PPC

#text(size: 18pt)[`pp_check(fit, ndraws=100)`]

Latent hierarchical linear model

#align(center)[#image("figs/student_retention_lbinom_ppc_dens_overlay.pdf", height: 6.5cm)]

Latent hierarchical linear model + spline

#align(center)[#image("figs/student_retention_sbinom_ppc_dens_overlay.pdf", height: 6.5cm)]


== Student retention #text(size: 24pt)[Posterior predictive intervals]

#text(size: 18pt)[`pp_check(fit, type = "intervals_grouped", group="year")`]

Latent hierarchical linear model

#align(center)[#image("figs/student_retention_lbinom_ppc_intervals_grouped.pdf", height: 6.5cm)]

Latent hierarchical linear model + spline

#align(center)[#image("figs/student_retention_sbinom_ppc_intervals_grouped.pdf", height: 6.5cm)]



== PPC for binary target - DON'T USE BAR OR KDE PLOTS

- Bar plots  are not very informative for assessing model fit.
- Even a simple model can perfectly reproduce the **overall proportion of positive outcomes**, making these plots unable to distinguish good from poor models.
- KDE are even worse
#v(2cm)
#grid(columns: (1fr, 1fr), gutter: 1em,
  [#text(fill: red)[Bad idea. Don't do this]],
  [#text(fill: red)[This is even  worse!!!]],
  image("figs/helicopter_hier_stable_ppc_bars_2024.pdf", height: 6cm),
  image("figs/helicopter_hier_stable_ppc_dens_overlay_2024.pdf", height: 6cm),
)
== Use Calibration plots for binary targets


- Compare predicted probabilities with the observed frequency of positive outcomes.
- Traditional calibration plots bin predictions (e.g., [0-0.1], [0.1-0.2],... [0.9-1.0]), but results can depend strongly on the **choice of bins**.
- A more robust approach, PAV-adjusted calibration, avoids binning.

#align(center)[#image("figs/ppc_pava.png", height: 10cm)]



== Prior predictive checking

- Similar to posterior predictive checking, but done before observing the data
- Compute predictions (before seeing the data) and compare them to the domain knowledge (not the data)
- Assess if the model predictions are consistent with the domain knowledge
- If not, revise model or assumptions
#v(1fr)
https://arviz-devs.github.io/EABM/Chapters/Prior_posterior_predictive_checks.html



== Exposure to air pollution


- Estimation of human exposure to air pollution from particulate matter measuring less than 2.5 microns in diameter ($"PM"_(2.5)$)

#align(center)[#image("figs/pm25_pp1b.pdf", width: 18cm)]


#v(1fr)
#text(size: 14pt)[Gabry, Simpson, Vehtari, Betancourt, and Gelman (2019). Visualization in Bayesian workflow. #link("https://doi.org/10.1111/rssa.12378")]

== Exposure to air pollution

- Estimation of human exposure to air pollution from particulate matter measuring less than 2.5 microns in diameter ($"PM"_(2.5)$)

#align(center)[#image("figs/pm25_pp2.pdf", width: 18cm)]

#v(1fr)
#text(size: 14pt)[Gabry, Simpson, Vehtari, Betancourt, and Gelman (2019). Visualization in Bayesian workflow. #link("https://doi.org/10.1111/rssa.12378")]


== Chapter 6

- 6.1 The place of model checking in applied Bayesian statistics
- 6.2 Do the inferences from the model make sense?
- 6.3 Posterior predictive checking
- 6.4 Graphical posterior predictive checks
  - better to read the paper Gabry et al. (2019). _Visualization in Bayesian workflow_ #link("https://doi.org/10.1111/rssa.12378")
- 6.5 Model checking for the educational testing example

== Model checking

- demo6_1: Posterior predictive checking - light speed
- demo6_2: Posterior predictive checking - sequential dependence
- demo6_3: Posterior predictive checking - poor test statistic
- #link("https://avehtari.github.io/BDA_R_demos/demos_rstan/brms_demo.html")





== Model checking and model assessment

- Posterior predictive checks
  - is the model consistent with the observed data? where does it fail?
- Predictive performance
  - how well does the model predict new data?
  - which model predicts new data better? --> model comparison


== Predictive performance

- True predictive performance is measured by making predictions and comparing predictions to new observations
  - external validation
  - this can be costly or impractical
#v(0.5cm)  
- Expected predictive performance
  - approximates the external validation using observed data


== Predictive performance

- We need to choose the utility/cost function
- In principle these are application specific
  - e.g., money, life years, quality adjusted life years, etc.
#v(0.5cm)
- If we are interested in the overall goodness of the predictive distribution, then the log-score is a good theoretically justified choice.

$ log p(y^"rep" | y, M) $


== Cross-validation

- Cross-validation is a method to estimate predictive performance by splitting the data into training and test sets.
- There are many variants of cross-validation
- k-fold cross-validation.
  - split the data into k subsets and use each subset as a test set while training on the remaining k-1 subsets
- leave-one-out cross-validation (LOO-CV).
  - each observation is used once as a test set while the remaining observations form the training set


== Toy linear model

- We know the true data-generating process for this toy linear model
- Normal with mean given by the linear model (known intercept and slope) and some variance

#align(center)[#image("figs/fake3.pdf", height: 13cm)]


== Toy linear model 

- We compute the posterior and then the posterior predictive distribution
- For posterior predictive checking we compare the observed data to the posterior predictive distribution
#align(center)[#image("figs/fake5.pdf", height: 13cm)]


== Toy linear model

- We can remove one observation ($x=18$) and compute the leave-one-out posterior mean and posterior predictive distribution (at $x=18$)
#align(center)[#image("figs/fake8.pdf", height: 13cm)]



== Toy linear model

- We can evaluate the density including or excluding the observation at $x=18$
- It's expected to be higher when including the observation and lower when excluding it
#redtext[$ p(tilde(y)=y_18 | tilde(x)=18, x, y) approx 0.07 $]
#greentext[$ p(tilde(y)=y_18 | tilde(x)=18, x_(-18), y_(-18)) approx 0.03 $]


== Toy linear model

- We remove each observation one at a time and compute the corresponding leave-one-out log density
- The sum of these leave-one-out log densities gives an estimate of the leave-one-out log predictive density for the whole dataset

#align(center)[#image("figs/fake8loopds.pdf", width: 14cm)]
$ "elpd_loo" = sum_(i=1)^20 log p(y_i | x_i, x_(-i), y_(-i)) approx -29.5 $


== Toy linear model

$ "elpd_loo" = sum_(i=1)^20 log p(y_i | x_i, x_(-i), y_(-i)) approx -29.5 $
$ "lpd" = sum_(i=1)^20 log p(y_i | x_i, x, y) approx -26.8 $

- The lpd is optimistic compared to the elpd_loo (higher values indicate better fit)

$ "p_loo" = "lpd" - "elpd_loo" approx 2.7 $

- For correctly specified regular model p_loo asymptotically approaches the number of parameters $p$ in a model

#v(1fr)
#text(size: 14pt)[see #link("http://link.springer.com/article/10.1007/s11222-016-9696-4")[Vehtari, Gelman & Gabry (2017a)] and #link("http://dx.doi.org/10.1214/12-SS102")[Vehtari & Ojanen (2012)] for more]

== Toy linear model

- elpd_loo is an estimate of the expected log predictive density for new data
- the uncertainty associated with this estimate is quantified using the standard error (SE)
$ "elpd_loo" = sum_(i=1)^20 log p(y_i | x_i, x_(-i), y_(-i)) approx -29.5 $
$ "SE" = "sd"(log p(y_i | x_i, x_(-i), y_(-i))) dot sqrt(20) approx 3.3 $




== Brute-force LOO

- Re-run MCMC $n$ times to sample from $p(theta | x_(-i), y_(-i))$
  - can take a lot of time
  - can be parallelized easily as each leave-one-out fit is independent


== Fast cross-validation

- $K$-fold cross-validation
- Pareto smoothed importance sampling leave-one-out cross-validation (PSIS-LOO-CV)
#v(1fr)
#text(size: 18pt)[see #link("http://link.springer.com/article/10.1007/s11222-016-9696-4")[Vehtari, Gelman & Gabry (2017a)] and #link("mc-stan.org/loo/")]


== Importance sampling LOO-CV


- We want to compute $p(y_i | x_i, x_(-i), y_(-i))$ $= integral p(y_i | x_i, theta) p(theta | x_(-i), y_(-i)) dif theta$
#v(0.5cm)
- We can use importance sampling and a single fit (one MCMC run)
  - Proposal distribution is full posterior $theta^((s)) ~ p(theta | x, y)$
  - Target distribution is LOO-posterior $p(theta | x_(-i), y_(-i))$
#v(0.5cm)
- Importance ratio, using that observations are conditionally independent given $theta$:
$ w_i^((s)) &prop (p(theta^((s)) | x_(-i), y_(-i))) / (p(theta^((s)) | x, y)) =
  (#hide[$p(y_i | x_i, theta^((s)))$] #graytext[$p(y_(-i) | x_(-i), theta^((s))) p(theta^((s)))$])
  / (p(y_i | x_i, theta^((s))) #graytext[$p(y_(-i) | x_(-i), theta^((s))) p(theta^((s)))$]) \
  w_i^((s)) &prop 1 / (p(y_i | x_i, theta^((s)))) $

- Normalize the weights:

$ tilde(w)_i^((s)) = (w_i^((s))) / (sum_(s'=1)^S w_i^((s'))) $



== Importance sampling LOO-CV

 - Posterior draws $theta^((s)) ~ p(theta | x, y)$ with weights $tilde(w)_i^((s))$ approximate the LOO posterior:

  $ E_(theta | x_(-i), y_(-i))[h(theta)] approx sum_(s=1)^S tilde(w)_i^((s)) h(theta^((s))) $

  - For example, the LOO predictive density of the left-out observation ($h(theta) = p(y_i | x_i, theta)$):

  $ p(y_i | x_i, x_(-i), y_(-i)) approx sum_(s=1)^S tilde(w)_i^((s)) p(y_i | x_i, theta^((s))) $


== Importance sampling LOO-CV


#text(size: 18pt)[
- LOO predictive density of the left-out observation: how well do we predict $y_i$ when it is not used for fitting?
$ p(y_i | x_i, x_(-i), y_(-i)) = integral p(y_i | x_i, theta) p(theta | x_(-i), y_(-i)) dif theta $
#v(0.3cm)
- Importance sampling with draws $theta^((s)) ~ p(theta | x, y)$ and normalized weights $tilde(w)_i^((s))$
$ p(y_i | x_i, x_(-i), y_(-i)) approx sum_(s=1)^S tilde(w)_i^((s)) p(y_i | x_i, theta^((s)))
  = (sum_(s=1)^S w_i^((s)) p(y_i | x_i, theta^((s)))) / (sum_(s'=1)^S w_i^((s'))) $
#v(0.3cm)
- With $w_i^((s)) prop 1 \/ p(y_i | x_i, theta^((s)))$ the weight cancels the likelihood in the numerator
$ &= (sum_(s=1)^S #graytext[$1 / (p(y_i | x_i, theta^((s)))) p(y_i | x_i, theta^((s)))$]) / (sum_(s'=1)^S 1 / (p(y_i | x_i, theta^((s')))))
  = 1 / (1/S sum_(s=1)^S 1 / (p(y_i | x_i, theta^((s))))) $
]

== Pareto smoothed importance sampling LOO

- The estimate is dominated by draws where $p(y_i | x_i, theta^((s)))$ is small, so the weights $1 \/ p(y_i | x_i, theta^((s)))$ can have very high or infinite variance
  - this happens when observation $i$ is highly influential, so the full and LOO posteriors differ a lot
#v(0.5cm)
- Pareto-$hat(k)$ diagnostic: fit a generalized Pareto distribution to the largest weights
  - $hat(k)$ tells how heavy the tail is, and whether the estimate can be trusted
#v(0.5cm)
- Pareto smoothed importance sampling LOO (PSIS-LOO)
  - replace the largest weights with the expected order statistics of the fitted Pareto
  - smoothed weights have lower variance, at the cost of a small bias


== Pareto smoothed importance sampling LOO


#grid(
    columns: (1fr, 1fr),
    gutter: 6pt,
    align(center)[#image("figs/fakepsisweights.pdf", width: 11cm)],
    align(center)[#image("figs/fakepsisweights4000.pdf", width: 11cm)],
  )

  $ "ESS" approx 1 / (sum_(s=1)^S (tilde(w)^((s)))^2) approx 459 $

  Pareto $hat(k) approx 0.52$

  - Pareto $hat(k)$ estimates the tail shape which determines the convergence rate of PSIS. Less than 0.7 is ok.
#v(1fr)
  #text(size: 16pt)[see #link("https://jmlr.org/papers/v25/19-556.html")[Vehtari et al. (2024)]]


== Software in R and Python

- R: loo package
- Python: arviz package

#text(size: 14pt)[
```text
Computed from 4000 by 20 log-likelihood matrix

         Estimate  SE
elpd_loo    -29.5 3.3
p_loo         2.7 1.0
```
]

#graytext[
#text(size: 14pt)[
```text
------
MCSE of elpd_loo is 0.1.
MCSE and ESS estimates assume MCMC draws (r_eff in [0.6, 1.0]).

All Pareto k estimates are good (k < 0.7).
See help('pareto-k-diagnostic') for details.
```
]
]


== Computing the log-likelihood

- For Stan we need to compute the log-likelihood in the generated quantities block
#text(size: 14pt)[
```stan
model {
  alpha ~ normal(pmualpha, psalpha);
  beta ~ normal(pmubeta, psbeta);
  y ~ normal(mu, sigma);
}
generated quantities {
  vector[N] log_lik;
  for (i in 1:N)
    log_lik[i] = normal_lpdf(y[i] | mu[i], sigma);
}
```
]

- stanarm and brms compute `log_lik` by default
- PyMC and bambi used to compute it by default, but now it needs to be explicitly requested using the `compute_log_likelihood` function.


== High Pareto-$hat(k)$ values

#text(size: 19pt)[
- Pareto-$hat(k)$ estimates how far the LOO posterior is from the full posterior
  - high $hat(k)$ means observation $i$ is highly influential, so importance sampling is unreliable
  - very high values often indicate misspecification, outliers or data errors
#v(0.3cm)
- If $hat(k) > 0.7$, `p_loo` can be used as a diagnostic relative to the number of parameters, see more in #link("https://users.aalto.fi/~ave/modelselection/CV-FAQ.html")[CV-FAQ]
]
#v(0.3cm)
- Not every high $hat(k)$ needs fixing, e.g. discard a model that is clearly bad by PPC or much worse elpd


== What if many high Pareto-$hat(k)$'s

- `rstan::loo(..., moment_match = TRUE)` \
  `brms::loo(..., moment_match = TRUE)` \
  support implicitly adaptive importance sampling with moment matching algorithm by #link("https://doi.org/10.1007/s11222-020-09982-2")[Paananen et al. (2021)]. See #link("http://mc-stan.org/loo/articles/loo2-moment-matching.html")
- `rstanarm::loo(..., k_threshold = 0.7)` \
  `brms::loo(..., reloo = TRUE)` \
  runs MCMC for the folds with $hat(k)$ above the threshold
- Integrated LOO (for some models) \
  See #link("https://users.aalto.fi/~ave/modelselection/roaches.html")
- Use $K$-fold-CV (more about this later) \
  `rstanarm::kfold(..., K=10)` \
  `brms::kfold(..., K=10)` \
  RStan/CmdStanR vignette #link("http://mc-stan.org/loo/articles/loo2-elpd.html")




== Student retention -- loo computation

PSIS-LOO

#text(size: 14pt)[
```text
> fit4 <- add_criterion(fit4, 'loo')
Pareto k diagnostic values:
                         Count Pct.    Min. ESS
(-Inf, 0.7]   (good)     32    80.0%   114     
  (0.7, 1]    (bad)       7    17.5%   <NA>    
  (1, Inf)    (very bad)  1     2.5%   <NA>    
```
]

PSIS-LOO + moment matching + reloo

#text(size: 14pt)[
```text
> ...(fit4, 'loo', moment_match=TRUE, reloo=TRUE, overwrite=TRUE)
All Pareto k estimates are good (k < 0.7).
```
]
#v(1fr)
#text(size: 14pt, fill: rgb("#777777"))[#link("https://doi.org/10.1007/s11222-020-09982-2")[Paananen, Piironen, Bürkner, and Vehtari (2021). Implicitly adaptive importance sampling. _Statistics and Computing_, 31, 16.]]


== Cross-validation for model assessment

- CV gives a predictive distribution for each left-out observation $y_i$
  - so we can compute any LOO quantity, not only the log score (elpd)
  - choose the one that matters for the application
#v(0.5cm)
- Examples of LOO quantities
  - predictive means, quantiles and event probabilities
  - errors and accuracy (MAE, RMSE, classification accuracy)
  - continuous ranked probability score (CRPS)
  - $R^2$
  - available in R (`loo`, `rstanarm`, `brms`) and Python (ArviZ)
#v(0.5cm)
#v(0.5cm)
- Also useful for diagnosing misspecification and for model checking
  - Pareto-$hat(k)$, `p_loo`, LOO-PIT


== LOO-PIT predictive checking

- Probability integral transform (PIT):
  - Where does the observation fall in its own predictive distribution?
  - if the model is well calibrated we should see a uniform distribution
#v(0.5cm)
- Posterior predictive PIT
  $ p_i = p(y_i^"rep" <= y_i | x_i, x, y) $
  - double dipping --> PIT values tend to concentrate around 0.5
#v(0.5cm)
- LOO-PPC-PIT
$ p_i = p(y_i^"rep" <= y_i | x_i, x_(-i), y_(-i)) $
  - $y_i$ is not used for fitting, so the check is closer to evaluating on new data
  - we can use PSIS-LOO-CV to approximate the LOO-PIT values efficiently


== Sometimes cross-validation is not needed

- Posterior predictive checking is often sufficient

#align(center)[#image("figs/mesquite_ppc.pdf", width: 16cm)]

Predicting the yields of mesquite bushes. \
#text(size: 14pt, fill: rgb("#777777"))[Gelman, Hill & Vehtari (2020): Regression and Other Stories, Chapter 11.]

#text(size: 16pt)[
- BDA3, Chapter 6
- Gabry, Simpson, Vehtari, Betancourt, Gelman (2019). Visualization in Bayesian workflow. JRSS A, #link("https://doi.org/10.1111/rssa.12378")
- #link("mc-stan.org/bayesplot/articles/graphical-ppcs.html")
]

== Chapter 7

- 7.1 Measures of predictive accuracy
- #graytext[7.2 Information criteria and cross-validation]
  - Instead of 7.2, read: \
    Vehtari, A., Gelman, A., Gabry, J. (2017). Practical Bayesian model evaluation using leave-one-out cross-validation and WAIC. Statistics and Computing. 27(5):1413–1432. #link("http://arxiv.org/abs/1507.04544")[preprint at arxiv.org/abs/1507.04544].
  - See also #link("https://users.aalto.fi/~ave/CV-FAQ.html")

Next week

- 7.3 Model comparison based on predictive performance
- 7.4 Model comparison using Bayes factors
- 7.5 Continuous model expansion / sensitivity analysis
- #graytext[7.5 Example (may be skipped)]