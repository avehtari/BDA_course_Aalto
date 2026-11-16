#import "@preview/mosaic:0.0.1" as m

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 11],
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
#let graytext(x) = text(fill: rgb("#777777"), x)


#m.slide(layout: "title")


== Outline

- Prior and likelihood sensitivity checks
- Variable selection


== Sensitivity checks

- Priors influence on the posterior can vary from negligible to substantial
- Whether this influence is acceptable or not is context-dependent
- We can perform sensitivity checks to assess the impact 
- The direct approach is to refit the model with different priors


== Efficient prior and likelihood sensitivity checks

- We recommend checking prior and likelihood sensitivity following Kallioinen et al., 2023
  - Provides numerical and graphical diagnostics
  - No need to refit the model
  - In R, use #link("https://mc-stan.org/priorsense/", "priorsense") package
  - In Python use the #link("https://arviz-devs.github.io/EABM/Chapters/Sensitivity_checks.html", "psense") functions in ArviZ
#v(1fr)
#link("https://link.springer.com/article/10.1007/s11222-023-10366-5", "Kallioinen et al. (2023). Detecting and diagnosing prior and likelihood sensitivity with power-scaling"   )


== How it works

- The method it is based on two main ideas:
  - Importance sampling: avoid refitting the model
  - Power-scaling: we can write $p(theta)^alpha$ and use $alpha$ the distribution more or less concentrated



== Power-scaling distributions

#v(1cm)
#align(center)[#image("figs/power_scaling.pdf", width: 25cm)]


== Power-scaling the prior

#v(1cm)
#align(center)[#image("figs/power_scaling_prior.pdf", width: 25cm)]


== Computation

#m.steps.reveal(
  [For prior power-scaling:
  $
    w_"pri"^((s))
    = (#redtext[$p(theta^((s)))^alpha$] p(theta^((s)) | y)) / (p(theta^((s))) p(theta^((s)) | y))
    = (#redtext[$p(theta^((s)))^alpha$]) / p(theta^((s)))
    = p(theta^((s)))^(alpha - 1)
  $],
  [For likelihood power-scaling:
  $
    w_"lik"^((s))
    = (p(theta^((s))) #bluetext[$p(theta^((s)) | y)^alpha$]) / (p(theta^((s))) p(theta^((s)) | y))
    = (#bluetext[$p(theta^((s)) | y)^alpha$]) / p(y | theta^((s)))
    = p(y | theta^((s)))^(alpha - 1)
  $],
)

== Example

- Dataset: `npk`
- Goal: Model effect of Nitrogen, Phosphate and Potassium on pea crop yield
- Data: 24 observations of crop yield (3 observations of each combination)

#align(center)[#image("figs/npk.png", width: 16cm)]

#align(center)[#text(size: 16pt)[Mean yield per combination]]

== Example

Model:

$ y_i &~ N(mu_i, sigma^2) \  mu_i &= beta_0  \ &+ underbrace(beta_"N" N_i + beta_"P" P_i + beta_"K" K_i, "main effects") \ & +  underbrace(beta_("N" times "K") N_i K_i + beta_("N" times "P") N_i P_i + beta_("K" times "P") K_i P_i, "2-way interactions") $ \


== Example: Initial model

Main effects only using `brms`

```r
priors <- c(
  prior(normal(0, 2.5), coef = "N1", tag = "main"),
  prior(normal(0, 2.5), coef = "P1", tag = "main"),
  prior(normal(0, 2.5), coef = "K1", tag = "main")
)

fit <- brm(
  yield ~ N + P + K,
  data  = npk,
  prior = priors
)
```
#v(1cm)
We can later use the *tags* in priorsense to selectively apply power-scaling.


== Example: Initial model checks

```r
  powerscale_plot_dens(fit, prior_selection = "main")
```
#align(center)[#image("figs/npk_model1.png", width: 20cm)]


== Example: Initial model checks

```r
  powerscale_sensitivity(fit, prior_selection = "main")
```
#v(2cm)
#align(center)[
  #text(size: 17pt)[
    #table(
      columns: (auto, auto, auto, auto),
      align: (left, right, right, left),
      table.header(
        [variable], [prior sens.], [likelihood sens.], [diagnosis],
      ),
      [`b_N1`], [0.15], [0.18], [potential prior-data conflict],
      [`b_P1`], [0.06], [0.07], [potential prior-data conflict],
      [`b_K1`], [0.11], [0.14], [potential prior-data conflict],
    )
  ]
]

== Example: Adjusted prior


  ```r
  prior(normal(0, 25), coef = "b_N1", tag = "main")
  prior(normal(0, 25), coef = "b_K1", tag = "main")
  prior(normal(0, 25), coef = "b_P1", tag = "main")
  ```

== Example: Adjusted prior checks

#m.steps.replace(
  [#align(center)[#image("figs/npk_model1adj.png", width: 21cm)]],
  [#align(center)[
    #text(size: 17pt)[
      #table(
        columns: (auto, auto, auto, auto),
        align: (left, right, right, left),
        table.header(
          [variable], [prior sens.], [likelihood sens.], [diagnosis],
        ),
        [`b_N1`], [0.00], [0.10], [-],
        [`b_P1`], [0.00], [0.09], [-],
        [`b_K1`], [0.00], [0.10], [-],
      )
    ]
  ]],
)

== Example: Second model

Main effects and two-way interaction with `brms`


```r
fit <- brm(
  yield ~ (N + P + K)^2,
  data = npk,
  prior = c(
    prior(normal(0, 25), coef = "N1", tag = "main"),
    prior(normal(0, 25), coef = "K1", tag = "main"),
    prior(normal(0, 25), coef = "P1", tag = "main"),
    prior(normal(0, 25), coef = "N1:P1", tag = "twoway"),
    prior(normal(0, 25), coef = "N1:K1", tag = "twoway"),
    prior(normal(0, 25), coef = "P1:K1", tag = "twoway")
  )
)
```


== Example: Second model checks

#align(center)[#image("figs/npk_model2.png", width: 21cm)]


== Summary

- Priors can be challenging to specify without domain knowledge
- Prior predictive checking and prior/likelihood sensitivity checking can help identify potential issues
- If checks indicate strong prior sensitivity, prior-data conflict, or weak likelihood, further thought should be put into the prior
- see more examples and documentation:
  - R #link("https://mc-stan.org/priorsense/")[https://mc-stan.org/priorsense/]
  - Python #link("EABM")[arviz-devs.github.io/EABM/Chapters/Sensitivity_checks.html]



== Variable selection

- The process of identifying the most relevant variables in a model from a larger set of predictors.
- We assume variables contribute unevenly to the outcome.
  - We may want to identify the most/least "important"ones.
  - Sometimes we also want to rank them.


== Motivation for variable selection

- We can always include all available variables in a model
- Theory says this is a good idea, in particular if we use predictively consistent priors
- However, sometimes we need to reduce the number of variables
  - measurement cost in covariates
  - interpretability of the model
  - running cost of predictive model
#v(1fr)
#link("https://arxiv.org/abs/2606.22850")[Rihan et al. (2026). To select or not to select: predictively consistent priors instead of model selection]

== The problem with variable selection

- The number of potential models is $2^p$, where $p$ is the number of variables
- Evaluating all models can be computationally infeasible even for moderate $p$
- The process is prone to overfitting

== How to overcome the problem?

- We recommend to use a technique called projection predictive inference
  - In R, it can be done with `brms` + `projpred`
  - In Python, it can be done with `bambi` + `kulprit`


== Variable selection with projpred/kulprit

- The main advantage is that it reduces overfitting
- Other advantages are:
  - Automatic model building and fitting process.
  - Reduced number of models we need to fit.
  - Reduced time it takes to fit each model.


== Main concepts

- Reference model:
  - A model that includes all available variables and describes the data well.
- Search strategy:
  - A method for searching through the model space.
- Projection:
  - A way to estimate the posterior distribution of a model given a reference model.
#v(2cm)
Using a reference model is not a novel idea: Lindley (1968), Goutis & Robert (1998). Related approaches are known as gold standard, preconditioning, teacher and student, and distilling.

== Why use a reference model?

- Intuitively: data = signal + noise
- Selecting variables directly from the data also picks up the noise
- A reference model is our best attempt to estimate the signal

== How projection is done

- Projection can be framed as an *optimization problem*
- #redtext[Reference model]: parameters #redtext[$theta$] (a posterior draw)
- #bluetext[Submodel]: parameters #bluetext[$theta_perp$]
- $tilde(y)$: samples from the reference model's posterior predictive distribution, #redtext[$p(tilde(y) | theta)$]
- Find #bluetext[$theta_perp$] so that the submodel's predictive distribution #bluetext[$q(tilde(y) | theta_perp)$] is *as close as possible* to #redtext[$p(tilde(y) | theta)$]


== How projection is done

Use Kullback-Leibler divergence:

$ "KL"(#redtext[$p(tilde(y) | theta)$] parallel #bluetext[$q(tilde(y) | theta_perp)$]) = EE_(tilde(y) tilde #redtext[$p(tilde(y) | theta)$]) [log (#redtext[$p(tilde(y) | theta)$]) / (#bluetext[$q(tilde(y) | theta_perp)$])] $

Reordering:

$ "KL" = underbrace(EE_(tilde(y) tilde #redtext[$p(tilde(y) | theta)$]) [log #redtext[$p(tilde(y) | theta)$]], "constant") - EE_(tilde(y) tilde #redtext[$p(tilde(y) | theta)$]) [log #bluetext[$q(tilde(y) | theta_perp)$]] $

The first term does not depend on #bluetext[$theta_perp$], so

$ "minimize KL" quad <=> quad "maximize" quad EE_(tilde(y) tilde #redtext[$p(tilde(y) | theta)$]) [log #bluetext[$q(tilde(y) | theta_perp)$]] $

Take $q$ to be the #bluetext[submodel]'s likelihood (same observation model as the reference). 

The projection is the maximum likelihood fit of the #bluetext[submodel] to data $tilde(y)$ simulated from the #redtext[reference model]


== Searching for submodels

- We may not be able to evaluate the $2^p$ combinations
- Search heuristics, e.g.
  - Forward search
  - $L_1$-penalization (as in Lasso)
  - ...
- For a given model size, choose feature combination with minimal projective loss
- Use cross-validation to select the appropriate model size
  - In some cases like, $p >> n$, we need to cross-validate over the search paths


== Bodyfat: small $p$ example of projection predictive

- Predict bodyfat `siri`. The reference value is obtained by immersing person in water. $n = 251$.
- We also have measurements of various body parts: age, weight, abdomen, wrist, hip, thigh, ankle, forearm, height, neck, knee, biceps, chest
#m.steps.on("2-")[
  #align(center)[#image("figs/bodyfat_corr.pdf", width: 11cm)]
]


== Bodyfat

Marginal posteriors of coefficients

#align(center)[#image("figs/bodyfat_mcmc_areas.pdf", width: 17cm)]


== Bodyfat

Bivariate marginal of weight and height

#align(center)[#image("figs/bodyfat_mcmc_scatter.pdf", width: 11cm)]


== Bodyfat

The predictive performance of the full and submodels

#align(center)[#image("figs/bodyfat_varsel_plot.pdf", width: 20cm)]


== Bodyfat

Marginals of the reference and projected posterior
#v(0.5cm)
#align(center)[
  #grid(
    columns: 2,
    column-gutter: 0cm,
    [#image("figs/bodyfat_mcmc_areas.pdf", width: 14cm)],
    [#image("figs/bodyfat_proj_mcmc_areas.pdf", width: 14cm)],
  )
]


== Predictive performance vs. selected variables

- The initial aim: find the minimal set of variables providing similar predictive performance as the reference model
- Some keep asking can it find the true variables
  - What do you mean by true variables?
- The goal is predictive performance, not causal inference


== Variability under data perturbation

Comparing projection predictive variable selection (projpred) and stepwise maximum likelihood over bootstrapped datasets
#v(1cm)
#align(center)[#image("figs/inc_prob.pdf", width: 27cm)]


== Intro paper and examples

- McLatchie, Rögnvaldsson, Weber, and Aki Vehtari (2024). #link("https://projecteuclid.org/journals/statistical-science/volume-40/issue-1/Advances-in-Projection-Predictive-Inference/10.1214/24-STS949.full")[Advances in projection predictive inference. _Statistical Science_].
- #link("https://mc-stan.org/projpred/articles/projpred.html")[https://mc-stan.org/projpred/articles/projpred.html]
- #link("https://users.aalto.fi/~ave/casestudies.html")[https://users.aalto.fi/~ave/casestudies.html]
- #link("https://kulprit.readthedocs.io")[https://kulprit.readthedocs.io]