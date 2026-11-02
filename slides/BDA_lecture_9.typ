#import "@preview/mosaic:0.0.1" as m
#import "@preview/zebraw:0.6.3": zebraw

#let code = zebraw.with(
  lang:false,
  numbering: false,
  background-color: white,
  highlight-color: rgb("#fac364").lighten(80%),
)

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 9],
  //authors: [Aki Vehtari],
  paper: "4-3",
//   handout: true,
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

#m.slide(layout: "title")

== Objectives of this Lecture
- Model comparison with LOO-CV
- When is cross-validation applicable?
- Hypothesis testing


== Recap previous lecture

- Posterior (prior) predictive checks
- Cross-validation
  - Fast cross-validation with PSIS-LOO-CV

== The log-score

- We want to know how well the model predicts new data
#v(0.5cm)
- Log score: $log p(tilde(y) | y, M)$
  - theoretically justified
  - uses the whole predictive distribution
#v(0.5cm)
- Application specific cost/utility functions can be better, and metrics like $R^2$, RMSE, etc can be easier to interpret

== Expected log predictive density

- Log predictive density of the observed data (training fit)  
  $ "lpd" = sum_(i=1)^n log p(y_i | y) $
  $y_i$ is used both for fitting and for evaluation, so lpd is optimistic
#v(0.3cm)
- use LOO-CV to approximate the elpd
  $ "elpd_loo" = sum_(i=1)^n log p(y_i |  y_(-i)) $
#v(0.3cm)
- $"lpd" - "elpd_loo" = p_"loo"$ effective number of parameters (under certain conditions)

== Fast LOO with PSIS

- Brute-force LOO needs $n$ MCMC runs

- We can use importance sampling and only one fit
  - draws from the full posterior $theta^((s)) ~ p(theta | x, y)$ are the proposal
  - the LOO posterior $p(theta | x_(-i), y_(-i))$ is the target
  $ w_i^((s)) prop 1 / (p(y_i | x_i, theta^((s)))) $
#v(0.3cm)
- Raw weights can have very high or infinite variance
- Pareto smoothing: fit a generalized Pareto distribution to the tail (largest weights) and replace them with smoothed values


== Recap: what does Pareto-$hat(k)$ tell us?

- $hat(k)$ is the shape of the fitted Pareto tail
  - the weights have only $1 / hat(k)$ finite moments (e.g. $hat(k) < 0.5$ means finite variance)
  - it tells how far the LOO posterior is from the full posterior
#v(0.3cm)
- Rule of thumb
  - $hat(k) < 0.7$: PSIS estimate is reliable
  - $hat(k) > 0.7$: importance sampling is unreliable for that observation
#v(0.3cm)
- High $hat(k)$ means observation $i$ is highly influential
  - possible outlier, data error or model misspecification
#v(0.3cm)
- If there are many high values
  - moment matching, `reloo`, integrated LOO or $K$-fold-CV
  - `p_loo` can help as a diagnostic


== Recap: PSIS-LOO is more than elpd

- We can use the PSIS weights to approximate the LOO posterior, then any LOO quantity
$ E_(theta | x_(-i), y_(-i))[h(theta)] approx sum_(s=1)^S tilde(w)_i^((s)) h(theta^((s))) $
#v(0.3cm)
- Examples
  - LOO predictive means, quantiles and event probabilities
  - MAE, RMSE, classification accuracy, CRPS
  - LOO-$R^2$
  - LOO-PIT for calibration checking

== Model comparison

- Often we end-up having multiple models for the same data
- We can use posterior predictive checks to discard/improve poorly fitting models
- Often we reach a point where multiple models seem reasonable
- The predictive performance can be compared using measures like elpd_loo


== Using the ELPD for model comparison

- The model with the higher elpd is estimated to have better predictive performance
- Given a model $M_A$ and $M_B$
  $ "elpd_diff" = "elpd"_A - "elpd"_B $
  - $"elpd_diff" > 0$: $M_A$ is estimated to predict new data better
#v(0.3cm)
- As we already stablish PSIS-LOO-CV, give as a fast and reliable approximation to the elpd_loo
- elpd_loo, and their difference, are point estimates, we also need to consider the uncertainty


== SE for elpd_loo and their differences

- We should compare the elpd_loo difference and the SE of the difference

#align(center)[
  #image("figs/compare_plot_relative.pdf", height: 5cm)
  #v(1cm)
  #image("figs/compare_plot_absolute.pdf", height: 5cm)
]


== SE for elpd differences


#align(center)[
  #image("figs/student_retention_loo_pointwise_scatter.pdf", height: 12cm)
]

Latent hierarchical linear (fit4) vs latent hierarchical linear + spline (fit6)


== SE of the difference

- Both elpd_loo estimates are computed from the same $n$ observations
  - pointwise terms $log p(y_i | y_(-i))$ are correlated between the models
#v(0.3cm)
- Comparing the two SEs separately ignores this correlation
  - $"Var"(A - B) = "Var"(A) + "Var"(B) - 2 "Cov"(A, B)$
#v(0.3cm)
- Instead, compute the pointwise difference $d_i = log p(y_i | y_(-i), M_A) - log p(y_i | y_(-i), M_B)$
$ "elpd_diff" = sum_(i=1)^n d_i, quad "SE"_"diff" = "sd"(d_i) dot sqrt(n) $
  We are assuming the differences $d_i$ are normally distributed


== SE for elpd differences

#align(center)[
  #image("figs/student_retention_loo_pointwise_diff_histogram_3.pdf", height: 12cm)
]

- To compare two models we compute the pointwise difference of the ELPDs and we use a normal approximation to estimate its SE

== Reliability of the SE for elpd differences

- The normal approximation works well when $|"elpd_diff"| > 4$, the models are well specified and $n > 100$
#v(0.5cm)
- $|"elpd_diff"| < 4$: the SE is not reliable, but the difference is small anyway
- The models are badly misspecified, with outliers in the data
  - check and extend the model first
- The number of observations is small
  - any inference with small $n$ is difficult
#v(0.3cm)



#v(1fr)
#text(size: 14pt, fill: rgb("#777777"))[
  #link("https://users.aalto.fi/~ave/CV-FAQ.html")[Frequently asked questions on CV]. \ Sivula, Magnusson et al. 2025. Uncertainty in Bayesian leave-one-out cross-validation based model comparison. _Bayesian Analysis_, #link("https://doi.org/10.1214/25-BA1569")[doi:10.1214/25-BA1569].
]



== SE for elpd_loo and their differences

- We should compare the elpd_loo difference and the SE of the difference

#graytext[
Latent hierarchical linear + spline

#text(size: 14pt)[
```
> loo(fit6)
         Estimate   SE
elpd_loo   -141.7  7.2
p_loo        10.9  2.5
```
]

Latent hierarchical linear

#text(size: 14pt)[
```
> loo(fit4)
         Estimate   SE
elpd_loo   -184.3 17.3
p_loo        23.8  5.7
```
]
]
#v(1cm)
#text(size: 20pt)[
```
> loo_compare(loo(fit4), loo(fit6))
     elpd_diff se_diff
fit6   0.0       0.0
fit4 -42.6      14.3
```
]

== Log score and elpd_loo

- Log score is not easily interpretable
- but is information theoretically good utility for the goodness of the whole distribution
- and thus is useful in model comparison


== Log score and elpd\_loo

- Interpretation in discrete case
  - log probability
- For example, in student retention
  - $1/N sum_(n=1)^N exp("elpd"_("loo",n)) approx 4%$ probability that we predict the observed value
  - compare to guessing uniformly from the data range [121,310] having $1/(310-121+1) approx 0.5%$ probability
- Interpretation in continuous case
  - can be compared to a simple reference distribution



== What do we want to predict?

- LOO leaves out one observation. But, is that always the right question?
#v(0.5cm)
- Imagine a model for the weights of rats, each rat measured several weeks in a row
#v(0.5cm)
- Which prediction do we care about?
  + another measurement of a rat that is already in the data
  + a new rat that is not in the data
  + the same rats next month
#v(0.5cm)
- These are three different prediction tasks, so three different cross-validations



== Hierarchical data: existing or new group?

#v(0.3cm)
- Prediction for an existing group
  - leave out one observation: LOO
  - the group's own parameters are still learned from its other observations
#v(0.3cm)
- Prediction for a new group
  - leave-one-group-out (LOGO)
  - predictions for new groups can only rely on the population level
#v(0.3cm)
- LOO is often a good first check, since it can already reveal problems with the model for the observations
#v(1fr)
#text(size:14pt)[
Riha et al., 2026. Approximating Bayesian leave-one-group-out cross-validation
https://arxiv.org/abs/2609.05713]



== Time series: forecasting and LOO

- Usually we want to predict the future
  - future observations cannot be used to predict the past
  - Leave-future-out (LFO)
- LOO predicts $y_t$ using observations before and after $t$
  - it tells us how well each observation is predicted from the others (noise distribution, outliers, abrupt changes)
  - cheap with PSIS-LOO-CV, so a good first check
  - also matches the task if we want to fill in missing values in the middle of the series (e.g. a sensor failure)
#v(1fr)
#text(size:13pt)[
Bürkner, Gabry & Vehtari, 2020. Approximate leave-future-out cross-validation for Bayesian time series models. 
https://www.tandfonline.com/doi/full/10.1080/00949655.2020.1783262]


== Summary: data-generating mechanisms and prediction tasks

- Cross-validation can be used to evaluate different prediction tasks
  - Choose a validation strategy that reflects the intended prediction task
  - Use knowledge of the data-generating process and practical objectives whenever available

- Cross-validation can be useful even when there is no clearly defined prediction task
  - It can help assess predictive performance and compare models


#v(1fr)
#text(size: 16pt)[see #link("http://dx.doi.org/10.1214/12-SS102")[Vehtari & Ojanen (2012)] and #link("https://users.aalto.fi/~ave/CV-FAQ.html")[CV-FAQ]]


== Pareto smoothed importance sampling CV variants

- PSIS-LOO for hierarchical models
  - leave-one-group out is challenging for PSIS-LOO
  - Stan demo of the challenges and integrated LOO at #link("https://users.aalto.fi/~ave/modelselection/roaches.html")[roaches]
  - #text(size: 16pt)[see also Merkel, Furr and Rabe-Hesketh (2018)]
- PSIS-LOO for non-factorized models
  - #link("http://mc-stan.org/loo/articles/loo2-non-factorizable.html")[mc-stan.org/loo/articles/loo2-non-factorizable.html]
- PSIS-LOO for time series
  - Approximate leave-future-out cross-validation (LFO-CV)
  - #link("http://mc-stan.org/loo/articles/loo2-lfo.html")[mc-stan.org/loo/articles/loo2-lfo.html]



== $K$-fold cross-validation

- $K$-fold cross-validation can approximate LOO
  - the same use cases as with LOO
- $K$-fold cross-validation can be used for hierarchical models
  - good for leave-one-group-out
- $K$-fold cross-validation can be used for time series
  - with leave-block-out


== When do we want predictive model selection?

- Models used for making predictions: predictive model selection is the natural choice
#v(0.3cm)
- Parameter of interest: look at its posterior directly, often easier and more accurate
  - instead of comparing \
    Model 1: $y tilde "normal"(alpha, sigma)$ \
    vs \
    Model 2: $y tilde "normal"(alpha + beta x, sigma)$ \
    look at the posterior of $beta$
#v(0.3cm)
- No directly interpretable parameter (e.g. spline-based terms): predictive model selection is useful even if prediction is not the goal


== Variable selection

- Variable selection aims to identify the most relevant predictors
- We can see it as a special case of model comparison for many model
  - With $p$ predictors there are $2^p$ possible models
- In principle we can use CV (and PSIS-LOO-CV) to compare them
- In practice with many (potentially similar) models overfitting is likely
- We will discuss an alternative approach: projection predictive variable selection


== Model averaging

- Bayesian Model averaging (BMA):
  - combines predictions from multiple models weighted by their posterior model probabilities
#v(0.3cm)
- Bayesian stacking
  - chooses the weights by optimizing the predictive performance of the combination
  - may work better than BMA when the models are misspecified or small data
#v(0.3cm)
- Oftern we prefer model expansion
  - hierarchical models
  - e.g. Student-$t$ instead of normal (normal is the limit when $nu -> infinity$)
  - nested models: expand so that the simpler model is a special case

#v(1fr)
#text(size: 16pt)[#link("https://projecteuclid.org/euclid.ba/1516093227")[Yao, Vehtari, Simpson, and Gelman (2018). Using stacking to average Bayesian predictive distributions (with discussion). _Bayesian Analysis_, 13(3):917-1003]]
== looic?

#text(size: 15pt)[
```
> loo(fit6)

Computed from 4000 by 40 log-likelihood matrix

         Estimate   SE
elpd_loo   -141.7  7.2
p_loo        10.9  2.5
looic       283.4 14.4  
------
Monte Carlo SE of elpd_loo is 0.1.
```
]

- `loo` output shows also looic for historical reasons
  - it's -2 \* elpd\_loo
  - ignore it, it will be removed in the future


== Information criteria

Information criteria estimate predictive performance, too

- AIC uses maximum likelihood estimate for prediction
- DIC uses posterior mean for prediction
- ... 
- WAIC is the only Bayesian information criterion

#v(1fr)
#text(size: 14pt, fill: rgb("#777777"))[#link("http://dx.doi.org/10.1214/12-SS102")[Vehtari & Ojanen (2012). A survey of Bayesian predictive methods for model assessment, selection and comparison. _Statistics Surveys_, 6:142-228.]]


== WAIC vs PSIS-LOO

- WAIC has the same target and assumptions as LOO
- PSIS-LOO is more accurate
- PSIS-LOO has better diagnostics
- We can often "fix" problematic PSIS-LOO cases with moment matching and reloo
- LOO makes the prediction assumption more clear, which helps if $K$-fold-CV is needed instead


#v(1fr)
#text(size: 14pt, fill: rgb("#777777"))[
#link("http://link.springer.com/article/10.1007/s11222-016-9696-4")[Vehtari, Gelman and Gabry (2017). Practical Bayesian model evaluation using leave-one-out cross-validation and WAIC. _Statistics and Computing_, 27(5):1413–1432] \
#link("http://dx.doi.org/10.1214/12-SS102")[Vehtari & Ojanen (2012). A survey of Bayesian predictive methods for model assessment, selection and comparison. _Statistics Surveys_, 6:142-228.]
]

== Marginal likelihood and Bayes factor

Bayes Factor $p(y|M_1) / p(y|M_2)$

Marginal likelihood $p(y|M_1) = integral p(y|theta,M_1)p(theta|M_1)d theta$

Marginal likelihood with chain rule: \
$p(y|M_1) = p(y_1|M_1) p(y_2|y_1,M_1) dots.c p(y_n|y_1,...,y_(n-1),M_1)$

- Bayes factor is extremely sensitive to the prior
  - the first term is a prediction from the prior alone and the subsequent terms incorporate the observed data sequentially so the result is very sensitive to the prior


#v(1fr)
#text(size: 14pt, fill: rgb("#777777"))[#link("http://dx.doi.org/10.1214/12-SS102")[Vehtari & Ojanen (2012). A survey of Bayesian predictive methods for model assessment, selection and comparison. _Statistics Surveys_, 6:142-228.]]


== Hypothesis testing

- Is there an effect? A dichotomous question: compare "no effect" ($H_0$: $beta = 0$) with "some effect"
#v(0.3cm)
- Frequentist: null hypothesis significance testing
  - p-value: probability of data at least as extreme as observed, if $H_0$ is true
  - reject $H_0$ if the p-value is below a threshold (e.g. 0.05)
#v(0.3cm)
- Bayesian: compare the models with the Bayes factor $p(y|M_1) / p(y|M_2)$
  - the ratio of the marginal likelihoods from the previous slides
#v(1fr)
#link("https://sites.google.com/site/doingbayesiandataanalysis/home?authuser=0")[Doing Bayesian Data Analysis]

== Common statistical tests as Bayesian models

- Most common statistical tests are linear models
#v(0.3cm)
#text(size: 17pt)[
#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  table.header(
    [test], [model], [formula],
  ),
  [$t$-test], [mean of data], [`y ~ 1`],
  [paired $t$-test], [mean of diffs], [`(y1 - y2) ~ 1`],
  [Pearson correl.], [linear model], [`y ~ 1 + x`],
  [two-sample $t$-test], [group means], [`y ~ 1 + gid`],
  [ANOVA], [hier. model], [`y ~ 1 + (1 | gid)`],
)
]
#v(0.3cm)
- So often instead of thinking about this "named tests" we can think in terms of the underlying linear models
  - Assumption may be more transparent and easier to check
  - We can extend them to better match our problem
#v(1fr)
Check out #link("https://lindeloev.github.io/tests-as-linear/")[lindeloev.github.io/tests-as-linear] 
  and #link("https://avehtari.github.io/ROS-Examples/")[Regression and other stories]


== Beta blockers

- Does the treatment reduce mortality of cardiac patients?
  - patients _randomly_ assigned to _control_ and `treatment`
  - out of 674 controls, 39 died; out of 680 treated, 22 died

#text(size: 15pt)[
```r
fitb1 <- brm(y | trials(N) ~ 1, family = binomial(), data = d_bin2)
fitb2 <- brm(y | trials(N) ~ 1 + grp2, family = binomial(), data = d_bin2)
```
]

#m.steps.reveal[
#text(size: 15pt)[
```r
> loo_compare(loo(fitb1),loo(fitb2))
      elpd_diff se_diff
fitb2  0.0       0.0
fitb1 -1.6       2.3
```
]
- elpd difference is small (less than 4) and smaller than its SE: CV does not tell the models apart
]

== Beta blockers

- The posterior of the treatment effect answers the question more directly: how large is it, and how certain are we of its sign?
#v(2cm)
#align(center)[
#image("figs/odds1_less.pdf", width: 18cm)
]

== Region of practical equivalence (ROPE)

- Define a range of effect sizes that are practically equivalent to no effect
- Compare if a credible interval overlaps with the ROPE
#align(center)[
#image("figs/HDIropeDecisionExamples.png", width: 21cm)
]
- Instead of a CI we can use all the draws from the posterior 

== Often we do not need a dichotomous decision

- We can report the full posterior distribution of the effect
  - this allows us to see the range of plausible effect sizes
  - we can quantify the probability that the effect is positive, negative, or practically negligible
  - this approach avoids forcing a binary decision and provides a richer summary of the evidence