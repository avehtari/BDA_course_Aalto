#import "@preview/mosaic:0.0.1" as m


#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 3],
  //authors: [Aki Vehtari, Osvaldo Martin],
  paper: "4-3",
)
#set page(fill: rgb("#ffffff"))
#set text(size: 21pt)
#show heading: set text(fill: rgb("#550e8b"))
#show "•": set text(fill: rgb("#6c3b91"))
#let redtext(x) = text(fill: rgb("#f66d7f"), weight: "bold", math.bold(x))
#let bluetext(x) = text(fill: rgb("#36acc6"), weight: "bold", math.bold(x))
#let purpletext(x) = text(fill: rgb("#7c2695"), weight: "bold", math.bold(x))
#let yellowtext(x) = text(fill: rgb("#fac364"), weight: "bold", math.bold(x))

#let graytext(x) = text(fill: rgb("#777777"), x)


#m.slide(layout: "title")


== Outline Chapter 3

- 3.1 Marginalization
- 3.2 Normal distribution with a noninformative prior (important)
- 3.3 Normal distribution with a conjugate prior (important)
- 3.4 Multinomial model (can be skipped)
- 3.5 Multivariate normal with known variance (useful for chapter 4)
- 3.6 Multivariate normal with unknown variance (glance through)
- 3.7 Bioassay example (very important, related to one of the exercises)
- 3.8 Summary

== This lecture

- Normal / Gaussian distribution with unknown mean and scale
- Marginalization by analytic integration
- Posterior predictive distribution by analytic integration
- Generalized Linear Models (GLMs)
- Gaussian process (extra-material not covered in detail)


== Normal / Gaussian

- Gaussian: favored by Germans (but it was studied earlier by De Moivre and Laplace, and Gauss avoided using it)
- Normal: some prominent statistician started to use this term systematically in the end of 19th century (but it's a bit of exaggeration)
#v(2cm)
#align(center)[#image("figs/normal.pdf", width: 15cm)]

// Not to be confused with the paranormal distribution


== Normal / Gaussian

- On its own
  - Analysis of real valued observations
  - Sometimes convenient approximation for discrete observations
  - Often convenient assumption
  #v(0.5cm)
- As a building block of more complex models
  - Normal linear regression
  - Gaussian processes (non parametric, infinite-dimensional generalization of the normal distribution)
  - Kalman filters (recursive estimation for linear Gaussian state-space models)
  #v(0.5cm)
- As an approximation tool for Bayesian inference
  - Posterior distribution approximation with Laplace, variational inference, expectation propagation

== Normal / Gaussian

#align(center)[#image("figs/normal_family.pdf", width: 25cm)]
#v(0.5cm)
#m.steps.pause
- $y tilde N(mu, #purpletext[$sigma^2$])$ with variance #purpletext[$sigma^2$] (useful in derivations)
- $y tilde "normal"(mu, #purpletext[$sigma$])$ with deviation #purpletext[$sigma$] (useful for interpretation, used in many probabilistic programming languages, like Stan)


== Normal / Gaussian

observation $y$, and parameters $mu$ and $sigma$

$
  p(y | mu, sigma)
  = 1 / (sqrt(2 pi) sigma)
    exp(-1 / (2 sigma^2) (y - mu)^2)
$
#v(1cm)
#align(center)[
  #image("figs/normal_steps_0.pdf")
]


== Normal / Gaussian

- The square of the differences

#graytext[
  $ p(y | mu, sigma)
    = 1 / (sqrt(2 pi) sigma)
    exp(-1 / (2 sigma^2) #bluetext[$(y - mu)^2$]) $
]
#v(2cm)
#align(center)[
  #image("figs/normal_steps_1.pdf")
]


== Normal / Gaussian

- The minus square of the differences

#graytext[
$
  p(y | mu, sigma)
  = 1 / (sqrt(2 pi) sigma)
    exp(#bluetext[$-$] 1 / (2 sigma^2) #bluetext[$(y - mu)^2$])
$
]
#v(1cm)
#align(center)[
  #image("figs/normal_steps_2.pdf")
]


== Normal / Gaussian

- The scaled minus square of the differences

#graytext[
$
  p(y | mu, sigma)
  = 1 / (sqrt(2 pi) sigma)
    exp(#bluetext[$-1 / (2 sigma^2) (y - mu)^2$])
$
]
#v(1cm)
#align(center)[
  #image("figs/normal_steps_3.pdf")
]


== Normal / Gaussian

- The exponentiated minus scaled square of the differences

#graytext[
$
  p(y | mu, sigma)
  = 1 / (sqrt(2 pi) sigma)
    #bluetext[$exp(-1 / (2 sigma^2) (y - mu)^2)$]
$
]
#v(1cm)
#align(center)[
  #image("figs/normal_steps_4.pdf")
]


== Normal / Gaussian

- The normalized exponentiated minus scaled square of the differences
  $
    p(y | mu, sigma)
    = #bluetext[$1 / (sqrt(2 pi) sigma)
        exp(-1 / (2 sigma^2) (y - mu)^2)$
    ]
  $
#align(center)[
  #image("figs/normal_steps_0.pdf")
]
Why $pi$ is here and how it is connected to CLT? -> https://www.youtube.com/watch?v=cy8r7WSuT1I



== Variation in helicopter flight times

- Take the mean of the helicopter flight times
- To each observation, subtract the mean to get the residuals
- Histogram of residuals
#v(1cm)
#align(center)[
  #image("figs/helicopter_hier_time_residual_hist_2025.pdf", width: 22cm)
]


== Variation in helicopter flight times

- Quantile-dot plot.
  - Each dot represents an equal fraction of the observations.
  - In this example we have 100 dots, so each dot is 1% of the observations.
#v(1cm)
#align(center)[
  #image("figs/helicopter_hier_time_residual_dots_2025.pdf", width: 22cm)
]


== Variation in helicopter flight times

- Quantile-dot plot + PDF of the normal distribution

#align(center)[
  #image("figs/helicopter_hier_time_residual_dots_normal_2025.pdf", width: 22cm)
]

- Why close to normally distributed?
  - Many small sources of variations summed together tend to be close to normally distributed
  - Central Limit Theorem (CLT)



== Normal data model and likelihood

#m.steps.reveal[
  - #bluetext[Data model] for #redtext[$y$]: $p(#redtext[$y$] | mu, sigma)$, a distribution over #redtext[$y$] for
    fixed $mu, sigma$
    #v(1cm)
  - #bluetext[Likelihood] the same, now viewed as a function of #redtext[$mu, sigma$] and fixed for $y$:
    #v(1cm)
  - With $n$ helicopter flight times $y = (y_1, ..., y_n)$ and assuming
    conditional independence.
      $
        p(y | #redtext[$mu, sigma$]) = product_(i=1)^n p(y_i | #redtext[$mu, sigma$]),
      $
]

== Posterior for $mu$ and $sigma$ given $y$


#m.steps.reveal[
- The normal has two unknown parameters ($mu, sigma$), so we need to specify a prior for them.
 #v(0.5cm)
- #bluetext[Prior] for $mu$ and $sigma$: 
  - joint $p(mu, sigma)$
  - independent $p(mu) p(sigma)$
 #v(0.5cm)
- Bayes' rule gives the joint #bluetext[posterior]
  $
    p(mu, sigma | y) prop quad product_(i=1)^n p(y_i | mu, sigma) quad p(mu, sigma)
  $
]

== Posterior for $mu$ and $sigma$ given $y$

- This posterior is 2-dimensional, covering both parameters jointly

#align(center)[#image("figs/joint_posterior.pdf", width: 20cm)]

- For some priors analytic solutions exist; for others we need numerical methods

== Non-informative prior for $mu, sigma$

#m.steps.reveal[
- Assume independence:
  $ p(mu, sigma) prop p(mu) times p(sigma) $
- Flat prior for $mu$ and $log sigma$:
  $ p(mu) &prop 1 quad "invariant under" (mu arrow c + mu) \
    p(log sigma) &prop 1 quad "invariant under" (sigma arrow c times sigma) $
- We want $p(sigma)$, not $p(log sigma)$. Change of variables (BDA3 p. 21):
  $ p(sigma) = p(log sigma) abs((dif log sigma)/(dif sigma)) = 1 times 1/sigma = sigma^(-1) $
- We want $p(sigma^2)$, not $p(sigma)$.
  $ p(sigma^2) = p(sigma) abs((dif sigma)/(dif sigma^2)) = sigma^(-1) times 1/2 times 1/sigma prop sigma^(-2) $
- Putting it all together:
  $ p(mu, sigma^2) prop sigma^(-2) $
]

== Change of variable intuition

- Suppose $X ~ "Gamma"(alpha, beta)$, but we want a new variable $Y = log(X)$.
- The transformation squishes and stretches intervals, so the density must adjust to preserve probability.
#v(1cm)
#align(center)[#image("figs/jacobian_geometric.pdf", width: 26cm)]


== Change of variable intuition

- A naive transformation $p_X(exp(Y))$ gives the wrong density for $Y = log(X)$.
#v(1cm)
#align(center)[#image("figs/jacobian.pdf", width: 26cm)]

== Joint posterior

#m.steps.reveal[
- Joint posterior
  $
    p(mu, sigma^2 | y) prop quad product_(i=1)^n p(y_i | mu, sigma^2) quad p(mu, sigma^2)
  $
- Substituting the non-informative prior and the normal density for each $p(y_i | mu, sigma^2)$:
  $
    p(mu, sigma^2 | y) prop sigma^(-2) product_(i=1)^n 1/sqrt(2 pi)  1/sigma exp(-1/(2 sigma^2) (y_i - mu)^2)
  $

- Dropping the constant $1/sqrt(2 pi)$, and using $product 1/sigma = sigma^(-n)$ and $product exp(a_i) = exp(sum a_i)$:
  $
    p(mu, sigma^2 | y) prop sigma^(-n-2) exp(-1/(2 sigma^2) sum_(i=1)^n (y_i - mu)^2)
  $
]


== Joint posterior

$
  p(mu, sigma^2 | y) &prop sigma^(-n-2) exp(-1/(2 sigma^2) sum_(i=1)^n (y_i - mu)^2) \
  &prop sigma^(-n-2) exp(-1/(2 sigma^2)[sum_(i=1)^n (y_i - overline(y))^2 + n(overline(y) - mu)^2]) \
  &prop sigma^(-n-2) exp(-1/(2 sigma^2)[(n-1) s^2 + n(overline(y) - mu)^2])
$

where $overline(y) = 1/n sum_(i=1)^n y_i$ and
$s^2 = 1/(n-1) sum_(i=1)^n (y_i - overline(y))^2$.

#v(0.5em)
*Step 1 $arrow$ 2:* split the sum into a part that does not depend on $mu$
(the *within-sample* variation) plus a part that does (the *distance
from the mean*). See appendix A.1.

*Step 2 $arrow$ 3:* the first term is $(n-1)$ times the sample variance $s^2$ 
#v(0.5em)
*Takeaway:* The only thing we need from the data are $overline(y)$ (mean), $s^2$ (variance), and $n$ (the sample size).


== Joint posterior with marginals

#align(center)[#image("figs/joint_posterior_marginals.pdf")]


== Factorization

- Sampling from a #purpletext[joint posterior] is often easier if done in steps:
  - 1. First draw from a #bluetext[marginal]
  - 2. Then from a #redtext[conditional] given that draw.

$
  #purpletext[$p(mu, sigma^2 | y)$]
  = #redtext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
$

#align(center)[#image("figs/normal_factorization_0.pdf")]



== Marginal posterior $p(sigma^2 | y)$ #text(size: 20pt)[, easier for $sigma^2$ than $sigma$]

Integrate the joint posterior over the nuisance parameter $mu$:
$
  p(sigma^2 | y) &prop integral p(mu, sigma^2 | y) dif mu \
  &prop integral sigma^(-n-2) exp(-1/(2 sigma^2)[(n-1) s^2 + n(overline(y) - mu)^2]) dif mu
$

Split the exponential ($e^(a+b) = e^a e^b$):
$
  &prop integral sigma^(-n-2) exp(-(n-1) s^2/(2 sigma^2)) exp(-n/(2 sigma^2)(overline(y) - mu)^2) dif mu
$

Only the second term involves $mu$.
$
  &prop sigma^(-n-2) exp(-(n-1) s^2/(2 sigma^2)) integral exp(-n/(2 sigma^2)(overline(y) - mu)^2) dif mu
$


== Marginal posterior $p(sigma^2 | y)$ (cont.)

The remaining integral is Gaussian in $mu$, with

$
mu | sigma, y ~ N(overline(y), sigma^2 / n).
$

Therefore,

$
integral exp(-n/(2 sigma^2) (overline(y) - mu)^2) dif mu
= sqrt((2 pi sigma^2)/n)
prop sigma.
$

Substituting back,

$
p(sigma^2 | y)
&prop
sigma^(-n-2) dot sigma
exp(-((n-1)s^2)/(2 sigma^2))
$

and hence

$
p(sigma^2 | y)
&prop
sigma^(-(n+1))
exp(-((n-1)s^2)/(2 sigma^2)).
$



== Marginal posterior $p(sigma^2 | y)$ (cont.)

Rewrite in terms of $sigma^2$:
$
  p(sigma^2 | y) &prop (sigma^2)^(-(n+1)/2) exp(-((n-1)s^2)/(2 sigma^2)).
$

This is the kernel of a scaled inverse-$chi^2$ distribution:
$
  sigma^2 | y ~ "Inv"-chi^2(n-1, s^2)
$


== Factorization

- Sampling from a #purpletext[joint posterior] is often easier if done in steps:
  - 1. Sample for the marginal: 
    $
      #bluetext[$p(sigma^2 | y)$] = "Inv-"chi^2(n-1, s^2)
    $
  - 2. Given that draw, then from a #redtext[conditional] given that draw.
    $
      #redtext[$p(mu | sigma^2, y)$] = N(overline(y), sigma^2/n)
    $
#align(center)[#image("figs/normal_factorization_0.pdf", width: 15cm)]



== Factorization

#m.steps.reveal[
- Repeated sampling from $mu$ (conditional on each draw of $sigma^2$) -> a #bluetext[family of normals] (one per draw)
- Averaging over all these conditional normals approximates the marginal posterior for $mu$ #yellowtext[(a mixture of normals)]:
- This mixture is in fact a *Student-$t$ distribution* (See appendix A.2)
  #align(center)[#image("figs/mixture_normals_studentt.pdf", width: 21cm)]
] 


== Predictive distribution for new $tilde(y)$

#m.steps.reveal[
- We often want to predict a *new* observation $tilde(y)$
- This requires averaging the #redtext[data model] over our #bluetext[uncertainty in $mu, sigma$]
  $
    p(tilde(y) | y) = integral #redtext[$p(tilde(y) | mu, sigma)$]  #bluetext[$p(mu, sigma | y)$] thick d mu d sigma
  $
  #v(1cm)
- Step 1: draw parameters from the posterior
  $
    mu^(s), sigma^(s) tilde #bluetext[$p(mu, sigma | y)$]
  $
- Step 2: draw a new observation from the data model
  $
    #purpletext[$tilde(y)^(s)$] tilde #redtext[$p(tilde(y) | mu^(s), sigma^(s))$]
  $
- Step 3: repeat steps 1 and 2 many times to approximate the predictive distribution
]

== Posterior predictive distribution #text(size:20pt)[(Normal with known variance)]

We integrate the data model over the conditional posterior for $mu$:
$
  p(tilde(y) | sigma^2, y) = integral p(tilde(y) | mu, sigma^2) quad p(mu | sigma^2, y) thick d mu
$

$
  p(tilde(y) | sigma^2, y) = integral N(mu, sigma^2) quad N(overline(y), sigma^2/n) thick d mu
$

The integral of a normal against a normal is again normal:
$
  = N(overline(y), sigma^2 + sigma^2 / n) = N(overline(y), (1+1/n) sigma^2)
$

The _extra_ $sigma^2/n$ comes from not knowing $mu$ exactly.

== Posterior predictive distribution

In practice $sigma^2$ is *not* known, so we also integrate over its posterior uncertainty:

$
  p(tilde(y) | y) = integral
  p(tilde(y) | sigma^2, y)
  p(sigma^2 | y)
  dif sigma^2
$

Integrating over the uncertainty in $sigma^2$ gives a Student-$t$, with $s^2$ in place of $sigma^2$:

$
  p(tilde(y) | y) = t_(n-1)(overline(y), (1 + 1/n) s^2)
$

Compared with $p(mu | y) = t_(n-1)(overline(y), s^2 / n)$:

$
  s^2 / n quad "vs." quad (1 + 1/n) s^2 = s^2/n + s^2
$

Predicting a new observation is less certain than estimating $mu$: it includes parameter uncertainty + observation noise.

== Normal - conjugate prior

- There are conjugate priors for the normal model
  - Check Section 3.3 in BDA3 for details.
  - Wikipedia has a list of #link("https://en.wikipedia.org/wiki/Conjugate_prior#Table_of_conjugate_distributions")[conjugate priors] for various models
- Useful sometimes when speed and analytical convenience (or insight) are important.
- With modern methods like MCMC, conjugate priors are less critical for computation.


== Comparison of means of two normals

- The difference of two normally distributed variables is normally distributed
- The difference of two $t$ distributed variables with different variances and degrees of freedom doesn't have a closed form
  - but easy to sample from the two distributions, and obtain draws of the differences
    $
      "if " quad &mu_1^(s) tilde p(mu_1 | y_1) \
      quad &mu_2^(s) tilde p(mu_2 | y_2) \
      quad &delta^(s) = mu_1^(s) - mu_2^(s)
    $
    $
      "then " quad delta^(s) tilde p(delta | y_1, y_2)
    $
- This is related to Monte Carlo method that will be discussed in the next lecture.


== Normal linear regression

- We allow $mu$ to depend on predictors $x_i$ through a linear model:
$
  y_i tilde N(alpha + beta x_i, sigma^2), quad i = 1, dots, N
$
- For some case we can have analytical solutions for the posterior
- For the general case with arbitrary priors and unknown $sigma^2$, numerical methods are needed (discussed later in the course).
- more about regression in BDA3 Chapter 14 (not required for the course) and #link("https://avehtari.github.io/ROS-Examples")[Regression and Other Stories] book


== Generalized linear model (GLM)

- We generalized regression models to allow for non-normal observation models.
  $
    y_i &tilde f(g^(-1)(eta_i), phi) \
    eta_i &= alpha + beta x_i
  $
- $eta$: linear predictor term $eta$
- $g^(-1)$: inverse link function
- $f$: observation model
- $phi$: other parameters of the observation model (e.g., variance for normal)

More in BDA3 Chapter 16 and #link("https://avehtari.github.io/ROS-Examples")[Regression and Other Stories] book


== Bioassay

#grid(
  columns: 2,
  [
    #table(
      columns: 3,
      align: center,
      table.header(
        [Dose $x_i$ (log g/ml)],
        [Number of animals $n_i$],
        [Number of deaths $y_i$],
      ),
      [-0.86], [5], [#redtext[0]],
      [-0.30], [5], [#redtext[1]],
      [-0.05], [5], [#redtext[3]],
      [0.73], [5], [#redtext[5]],
    )
  ],
  [
    #image("figs/bioassay_data_small.pdf", width: 10cm)
  ],
)
Find out lethal dose 50% (LD50)
- used to classify how hazardous chemical is
- 1984 EEC directive has 4 levels (see the chapter notes)
Bayesian methods help to
- reduce the number of animals needed
- easy to make sequential experiment and stop as soon as desired accuracy is obtained


== Bioassay

#align(center + horizon)[
  #m.steps.replace(
    image("figs/bioassay_data.pdf", width: 20cm),
    image("figs/bioassay_fitlin.pdf", width: 20cm),
    image("figs/bioassay_fitlin2.pdf", width: 20cm),
    image("figs/bioassay_data2.pdf", width: 20cm),
  )
]

== Bioassay

#align(center)[
  #image("figs/bioassay_fitbinom.pdf", width: 20cm)
]

Binomial model
$
  y_i | theta_i tilde "Bin"(theta_i , n_i )
$


== Bioassay (GLM for binomial data)

- Generalized linear model
$
  y_i &tilde f(g^(-1)(eta_i), phi) \
  eta_i &= alpha + beta x_i \
$

- GLM for binomial data
  - $f$ is the Binomial model
  - $g^(-1)$ is the logistic function
  - $g$ is the logit function
  - $phi$ is not needed for the Binomial model

== Bioassay

#align(center + horizon)[
#grid(
  columns: 2,
  [
    $
      y_i | #bluetext[$theta_i$] tilde "Bin"(#bluetext[$theta_i$], n_i)
    $
    $
      "logit"(#bluetext[$theta_i$]) = log(#bluetext[$theta_i$] / (1 - #bluetext[$theta_i$]))
    $
    #v(4cm)
    $
      = #redtext[$alpha + beta x_i$]
    $
    $
      #bluetext[$theta_i$] = 1 / (1 + exp(-(#redtext[$alpha + beta x_i$])))
    $
  ],
  [
    #image("figs/bioassay_fitbinom_C0.pdf", width: 13cm)

    #image("figs/bioassay_fitlogitspace_C1.pdf", width: 13.5cm)
  ],
)
]


== Bioassay

- One curve, the posterior mean of the dose-response relationship

#align(center)[
  #image("figs/bioassay_fitbinom.pdf")
]


== Bioassay

- Many curves, representing samples from the posterior distribution of the dose-response relationship

#align(center)[
  #image("figs/bioassay_post.pdf")
]


== Bioassay

#align(center)[
  #image("figs/bioassay_postld50.pdf")
]

$
  "LD50: " E[theta] = "logit"^(-1)(alpha + beta x) = 0.5
  quad => quad x_("LD50") = -alpha/beta
$


== Bioassay

- Posterior distribution of the LD50

#align(center)[
  #image("figs/bioassay_postld50.pdf")
]

$
  "LD50: " E[theta] = "logit"^(-1)(alpha + beta x) = 0.5
  quad => quad x_("LD50") = -alpha/beta
  quad => quad x_("LD50")^(s) = -alpha^(s)/beta^(s)
$


== Bioassay

- Histogram of the posterior distribution of the LD50

#align(center)[
  #image("figs/bioassay_histld50.pdf")
]

$
  "LD50: " E[theta] = "logit"^(-1)(alpha + beta x) = 0.5
  quad => quad x_("LD50") = -alpha/beta
  quad => quad x_("LD50")^(s) = -alpha^(s)/beta^(s)
$


== Bioassay posterior

- Binomial model
  $
    y_i | theta_i tilde "Bin"(theta_i, n_i)
  $

- Link function

  $
    "logit"(theta_i) = alpha + beta x_i
  $

- Likelihood
  $
    p(y_i | alpha, beta, n_i, x_i) &prop theta_i^(y_i) [1 - theta_i]^(n_i - y_i) \

    p(y_i | alpha, beta, n_i, x_i) &prop
    ["logit"^(-1)(alpha + beta x_i)]^(y_i)
    [1 - "logit"^(-1)(alpha + beta x_i)]^(n_i - y_i)
  $

Posterior (with uniform prior on $alpha, beta$)

$
  p(alpha, beta | y, n, x) prop p(alpha, beta) product_(i=1)^n p(y_i | alpha, beta, n_i, x_i)
$


== Bioassay - grid approximation

#m.steps.reveal[
- The posterior $p(alpha, beta | y, n, x)$ has no closed-form
- But we can evaluate the posterior at any given point in the parameter space.
- Choose a grid of values for $alpha$ and $beta$: $alpha_1, ..., alpha_M$ and $beta_1, ..., beta_N$
- Evaluate the unnormalized posterior at every grid point $(alpha_j, beta_k)$
  $
    q_(j,k) = p(alpha_j, beta_k | y, n, x) prop p(alpha_j, beta_k) product_(i=1)^n p(y_i | alpha_j, beta_k, n_i, x_i)
  $
  ]

== Bioassay - grid approximation

- Density times cell area gives probability mass in each cell
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid3_2.pdf", width: 20cm)
]

== Bioassay - grid approximation


Normalization

- Since we only know the posterior up to a constant, we normalize over the grid:
$
  p(alpha_j, beta_k | y, n, x) approx q_(j,k) / (sum_(j,k) q_(j,k))
$
- This turns the grid of unnormalized values into a proper discrete probability distribution that sums to 1.




== Bioassay - grid

Density evaluated in a coarse grid
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid3_1.pdf", width: 20cm)
]


== Bioassay - grid

- Density evaluated in a finer grid
  - The finer the grid, the more accurate the approximation becomes
  - But cost can grow fast, in particular as the number of parameters increases

#align(center)[
  #image("figs/bioassay_grid3.pdf", width: 20cm)
]

== Bioassay - grid

- For an smoother visualization, we may want to interpolate
#align(center)[
  #image("figs/bioassay_grid2.pdf", width: 20cm)
]

== Bioassay - grid

- And maybe also compute contour lines
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid1.pdf", width: 20cm)
]


== Bioassay - grid

- We can sample based on the grid cell probabilities
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid4.png", width: 20cm)
]

== Bioassay - grid

- More samples 
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid5.png", width: 20cm)
]


== Bioassay - grid

- Several draws can be from the same grid cell
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid6.png", width: 20cm)
]



== Bioassay - grid

- Jitter can be added to improve visualization
#v(1cm)
#align(center)[
  #image("figs/bioassay_grid7.png", width: 20cm)
]



== Grid sampling

- Draws can be used to estimate expectations, for example
  $
    E[x_("LD50")] = E[-alpha/beta]
    approx 1/S sum_(s=1)^S -alpha^(s)/beta^(s)
  $
- Instead of sampling, grid could be used to evaluate functions directly, for example
  $
    E[-alpha/beta] approx sum_(t=1)^T -alpha^(t)/beta^(t) w_"cell"^(t)
  $
  where $w_"cell"^(t)$ is the normalized probability of a grid cell $t$, and $alpha^(t)$ and $beta^(t)$ are center locations of grid cells



== Example: GLM for counts


#align(center)[
  #image("figs/drownings_plot.pdf")
]
- On average \~140 drownings per year
- Finnish government has invested in measures for reducing deaths
- #link("https://yle.fi/a/74-20048960")[Recent narrative] based on effectiveness of education

Bayesian methods help
- Describe trends over time
- Evaluate uncertainty


== Example: GLM for counts

#m.steps.reveal[
- Poisson regression model for counts:
  $
    y_i | #bluetext[$mu_i$] tilde "Poisson"(#bluetext[$mu_i$])
  $
  $
    #bluetext[$mu_i$] = e^(#redtext[$alpha + beta x_i$])
  $
  #align(center)[
  #grid(
    columns: 2,
    [
      #image("figs/drownings_fittargetspace_C0.pdf", width: 13cm)
    ],
    [
      #image("figs/drownings_fitlogspace_C1.pdf", width: 13cm)
    ],
  )
  ]
- Alternatively, Negative Binomial regression can be used for overdispersed count data.
  $
    y_i | #bluetext[$mu_i$], phi tilde "Neg-bin"(y_i | #bluetext[$mu_i$], phi)
  $
]

== Gaussian processes

#m.steps.reveal[
- Imagine we want to represent a function in probabilistic terms
- We could associate a Gaussian with each function value.
  #align(center)[
    #image("figs/gps_0.pdf")
  ]
]

== Gaussian processes

- We can vary the mean and variance of the Gaussian associated with each function value.

#align(center)[
  #image("figs/gps_1.pdf")
]


== Gaussian processes

#m.steps.reveal[
- Instead of independent normals, we use a Multivariate normal distribution to model the joint behavior of all function values.
- This way, we introduce correlations between function values at different points.
  #align(center)[
    #image("figs/gps_2.pdf")
  ]
]


== Gaussian processes

#m.steps.reveal[
- Formally, it's an infinite-dimensional multivariate normal - any finite set of function values, $f(x_1), ..., f(x_n)$, is jointly normal.
- In practice we only ever evaluate a function at *finitely* many points -> Multivariate normal
- Some nice theoretical properties and many models can be seen as  as special cases of Gaussian processes.
- More about GPs
  - See #link("https://gaussianprocess.org/gpml/")[Gaussian Processes for Machine Learning]
  - GPs in BDA3 Chapter 21
  - Other courses in Aalto.
]


== Example GLM: Gaussian Process Models

$
  y_i | #bluetext[$mu_i$] tilde "Poisson"(#bluetext[$mu_i$])
  quad #bluetext[$mu_i$] tilde e^(f_i), quad f tilde "GP"(0, k("Year", theta))
$
#v(1cm)
#align(center)[
  #image("figs/drownings_gp_poisson.pdf", width: 20cm)
]



== Example GLM: Gaussian Process Models

$
  y_i | #bluetext[$mu_i$] tilde "Neg-bin"(#bluetext[$mu_i$], phi)
  quad #bluetext[$mu_i$] tilde e^(f_i), quad f tilde "GP"(0, k("Year", theta))
$

#v(1cm)
#align(center)[
  #image("figs/drownings_gp_negbin.pdf", width: 20cm)
]

== Example GLM: Gaussian Process Models

- NegativeBinomial model is better because data is overdispersed
  - later in the course we will learn about tools to assess model fit and compare models
- Trend interpretations shouldn't be based on one observation

#align(center)[
  #image("figs/drownings_gp_negbin.pdf", width: 20cm)
]




== Thinking counts

- For simplicity of exposition, we often start learning with normal observation models
- But we observe count data on a daily basis
- Very relevant in industry (number of sold products, ad views, customer count, etc.)
- Can you think of such examples from the classroom?
  - Think of how many students attend BDA lectures over the course
  - Number of students who report getting sick over time until Christmas
  - Number of dropouts
  - Would you expect overdispersion?

== 

== Appendix A1: derivation of the sum identity

We now show the identity used above, $sum_i (y_i - mu)^2 = sum_i (y_i - overline(y))^2 + n(overline(y)-mu)^2$, by expanding the square:
$
  sum_(i=1)^n (y_i - mu)^2
$

$
  = sum_(i=1)^n (y_i^2 - 2 y_i mu + mu^2)
$

We add and subtract $overline(y)^2 - 2y_i overline(y)$ inside the sum — this doesn't change the value, but lets us regroup terms around $overline(y)$ instead of $mu$:
$
  = sum_(i=1)^n (y_i^2 - 2 y_i mu + mu^2 - overline(y)^2 + overline(y)^2 - 2 y_i overline(y) + 2 y_i overline(y))
$

== Appendix A1: derivation of the sum identity (cont)

Grouping the terms that involve only $y_i$ and $overline(y)$ into one sum, and the remaining terms into another:
$
  = sum_(i=1)^n (y_i^2 - 2 y_i overline(y) + overline(y)^2) + sum_(i=1)^n (mu^2 - 2 y_i mu - overline(y)^2 + 2 y_i overline(y))
$

The first sum is exactly $sum_i (y_i - overline(y))^2$. 
In the second sum, evaluating the summation using $sum_(i=1)^n y_i = n overline(y)$ gives $sum_(i=1)^n (-2 y_i mu + 2 y_i overline(y)) = -2 n overline(y) mu + 2 n overline(y)^2$. Factoring out $n$:
$
  = sum_(i=1)^n (y_i - overline(y))^2 + n (mu^2 - 2 overline(y) mu - overline(y)^2 + 2 overline(y)^2)
$

The bracket is a perfect square, $(overline(y) - mu)^2$:
$
  = sum_(i=1)^n (y_i - overline(y))^2 + n (overline(y) - mu)^2
$


== Appendix A2: Marginal posterior $p(mu | y)$ derivation

We now derive $p(mu | y)$ analytically, by integrating the joint posterior over $sigma^2$:
$
  p(mu | y)
  = integral_0^infinity p(mu, sigma^2 | y) d sigma^2
$

$
  prop integral_0^infinity sigma^(-n-2) exp(-1/(2 sigma^2) [(n-1) s^2 + n (overline(y) - mu)^2]) d sigma^2
$

To evaluate this, substitute a new variable $z$ that absorbs the bracket term and turns the integral into a recognizable form:

== Appendix A2: Marginal posterior $p(mu | y)$ derivation (cont)


Transformation

$A = (n-1) s^2 + n (mu - overline(y))^2 quad "and" quad z = A / (2 sigma^2)$

$
  p(mu | y) prop A^(-n/2) integral_0^infinity z^((n-2)/2) exp(-z) d z
$

Recognize gamma integral $Gamma(u) = integral_0^infinity x^(u-1) exp(-x) d x$

The integral is now just a constant (a gamma function value not depending on $mu$), leaving only $A$'s dependence on $mu$:
$
  prop [(n-1) s^2 + n (mu - overline(y))^2]^(-n/2)
$

== Appendix A2:Marginal posterior $p(mu | y)$ (cont)


Dividing through by $(n-1)s^2$ to isolate the standard Student-$t$
kernel form:
$
  prop [1 + (n (mu - overline(y))^2) / ((n-1) s^2)]^(-n/2)
$

$p(mu | y) = t_(n-1)(mu | overline(y), s^2/n)$ Student's $t$

