#import "@preview/mosaic:0.0.1" as m
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/zebraw:0.6.3": zebraw


#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 7],
  paper: "4-3",
)

#let code = zebraw.with(
  lang:false,
  numbering: false,
  background-color: white,
  highlight-color: rgb("#fac364").lighten(80%),
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

#show raw.where(lang: "stan"): set raw(
  syntaxes: "Stan.sublime-syntax",
  theme: "Stan.tmTheme",
)


#m.slide(layout: "title")



== Chapter 5

- 5.1 Lead-in to hierarchical models
- 5.2 Exchangeability (useful concept)
- #graytext[5.3 Bayesian analysis of hierarchical models (we use Stan/brms for computation)]
- #graytext[5.4 Hierarchical normal model (we use Stan/brms for computation)]
- 5.5 Example: parallel experiments in eight schools (useful discussion on benefits of hierarchical model)
- 5.6 Meta-analysis
- 5.7 Weakly informative priors for hierarchical variance parameters


// == Hierarchical model

// - In simple model: posterior for the parameters
// - In hierarchical model: posterior for the prior parameters


== Non-Hierarchical model

- Example: cardiovascular disease (CVD) treatment effectiveness
  - in hospital $j$ the survival probability is #bluetext[$theta_j$]
  - observations $y_(i, j)$ tell whether patient $i$ survived in hospital $j$
#v(2cm)
#align(center)[
#diagram(
  node((0, 0), bluetext($theta_1$)),
  node((1, 0), bluetext($theta_2$)),
  node((2, 0), $dots$),
  node((3, 0), bluetext($theta_n$)),
  node((0, 1), $y_(i, 1)$),
  node((1, 1), $y_(i, 2)$),
  node((3, 1), $y_(i, n)$),
  edge((0, 0), (0, 1)),
  edge((1, 0), (1, 1)),
  edge((3, 0), (3, 1)),
)
]

== Hierarchical model

- Example: CVD treatment effectiveness
  - in hospital $j$ the survival probability is #bluetext[$theta_j$]
  - observations $y_(i, j)$ tell whether patient $i$ survived in hospital $j$
  - sensible to assume that #bluetext[$theta_j$] are similar
#v(0.5cm)
#align(center)[
#diagram(
  node((1, 0), redtext($tau$)),
  node((0, 1), bluetext($theta_1$)),
  node((1, 1), bluetext($theta_2$)),
  node((2, 1), $dots$),
  node((3, 1), bluetext($theta_n$)),
  node((0, 2), $y_(i, 1)$),
  node((1, 2), $y_(i, 2)$),
  node((3, 2), $y_(i, n)$),
  edge((1, 0), (0, 1)),
  edge((1, 0), (1, 1)),
  edge((1, 0), (3, 1)),
  edge((0, 1), (0, 2)),
  edge((1, 1), (1, 2)),
  edge((3, 1), (3, 2)),
)
]
#v(0.5cm)
  - natural to think that #bluetext[$theta_j$] have common population distribution
  - #bluetext[$theta_j$] is not directly observed and the population distribution is unknown


== Hierarchical model: terms

- Level 1: observations given parameters $p(y_(i, j) | theta_j)$
- Level 2: parameters given hyperparameters $p(theta_j | tau)$
#v(1cm)
#align(center)[
#diagram(
  node((0, 0), $p(#redtext[$tau$])$),
  node((2, 0), redtext($tau$)),
  node((5, 0), redtext[hyperparameter]),
  node((0, 1), $p(#bluetext[$theta_j$] | #redtext[$tau$])$),
  node((1, 1), bluetext($theta_1$)),
  node((2, 1), bluetext($theta_2$)),
  node((3, 1), $dots$),
  node((4, 1), bluetext($theta_n$)),
  node((5, 1), bluetext[parameters]),
  node((0, 2), $p(y_(i, j) | #bluetext[$theta_j$])$),
  node((1, 2), $y_(i, 1)$),
  node((2, 2), $y_(i, 2)$),
  node((4, 2), $y_(i, n)$),
  node((5, 2), [observations]),
  edge((2, 0), (1, 1)),
  edge((2, 0), (2, 1)),
  edge((2, 0), (4, 1)),
  edge((1, 1), (1, 2)),
  edge((2, 1), (2, 2)),
  edge((4, 1), (4, 2)),
)
]
#v(1cm)
Joint posterior

$
  p(#bluetext[$theta$], #redtext[$tau$] | y) prop quad p(y | #bluetext[$theta$]) quad p(#bluetext[$theta$] | #redtext[$tau$]) quad p(#redtext[$tau$])
$


== Compare models


#let sm = diagram(spacing: 1.5cm,
  node((0, 0), bluetext($theta_1$)),
  node((1, 0), bluetext($theta_2$)),
  node((2, 0), $dots$),
  node((3, 0), bluetext($theta_n$)),
  node((0, 1), $y_1$),
  node((1, 1), $y_2$),
  node((3, 1), $y_n$),
  edge((0, 0), (0, 1)),
  edge((1, 0), (1, 1)),
  edge((3, 0), (3, 1)),
)


#let pm = diagram(spacing: 1.5cm,
  node((1, 0), bluetext($theta$)),
  node((0, 1), $y_1$),
  node((1, 1), $y_2$),
  node((2, 1), $dots$),
  node((3, 1), $y_n$),
  edge((1, 0), (0, 1)),
  edge((1, 0), (1, 1)),
  edge((1, 0), (3, 1)),
)


#let hm = diagram(spacing: 1.5cm,
  node((1, 0), redtext($tau$)),
  node((0, 1), bluetext($theta_1$)),
  node((1, 1), bluetext($theta_2$)),
  node((2, 1), $dots$),
  node((3, 1), bluetext($theta_n$)),
  node((0, 2), $y_1$),
  node((1, 2), $y_2$),
  node((3, 2), $y_n$),
  edge((1, 0), (0, 1)),
  edge((1, 0), (1, 1)),
  edge((1, 0), (3, 1)),
  edge((0, 1), (0, 2)),
  edge((1, 1), (1, 2)),
  edge((3, 1), (3, 2)),
)


#align(center)[
  #grid(
    columns: (auto, auto),
    rows: 3,
    align: (right + horizon, center + horizon),
    column-gutter: 5em,
    row-gutter: 3.0em,
    [*Separate/independent model*],  sm,
    [*Pooled/joint/common-effect model*], pm,
    [*Hierarchical model*], hm,
  )
]



== Hierarchical binomial model: rats

- Medicine testing
- Type F344 female rats in control group given placebo
  - count how many get endometrial stromal polyps
  - familiar binomial model example
- Experiment has been repeated 71 times

#align(center)[
#text(size: 19pt)[
#table(
  columns: 10,
  align: right,
  table.cell[0/20], table.cell[0/20], table.cell[0/20], table.cell[0/20], table.cell[0/20], table.cell[0/20], table.cell[0/20], table.cell[0/19], table.cell[0/19], table.cell[0/19],
  table.cell[0/19], table.cell[0/18], table.cell[0/18], table.cell[0/17], table.cell[1/20], table.cell[1/20], table.cell[1/20], table.cell[1/20], table.cell[1/19], table.cell[1/19],
  table.cell[1/18], table.cell[1/18], table.cell[2/25], table.cell[2/24], table.cell[2/23], table.cell[2/20], table.cell[2/20], table.cell[2/20], table.cell[2/20], table.cell[2/20],
  table.cell[2/20], table.cell[1/10], table.cell[5/49], table.cell[2/19], table.cell[5/46], table.cell[3/27], table.cell[2/17], table.cell[7/49], table.cell[7/47], table.cell[3/20],
  table.cell[3/20], table.cell[2/13], table.cell[9/48], table.cell[10/50], table.cell[4/20], table.cell[4/20], table.cell[4/20], table.cell[4/20], table.cell[4/20], table.cell[4/20],
  table.cell[4/20], table.cell[10/48], table.cell[4/19], table.cell[4/19], table.cell[4/19], table.cell[5/22], table.cell[11/46], table.cell[12/49], table.cell[5/20], table.cell[5/20],
  table.cell[6/23], table.cell[5/19], table.cell[6/22], table.cell[6/20], table.cell[6/20], table.cell[6/20], table.cell[16/52], table.cell[15/46], table.cell[15/47], table.cell[9/24],
  table.cell[4/14],
)
]]


== Hierarchical binomial model: rats

- Hierarchical binomial model for rats \
  prior parameters #redtext[$alpha$] and #redtext[$beta$] are unknown

#align(center)[
  #diagram(
    spacing: (3.5em, 3em),
    node-stroke: none,
    // parameters
    node((-0.5, 0), redtext($alpha$), name: <alpha>, shape: circle, stroke: 0.8pt),
    node((0.5, 0), redtext($beta$), name: <beta>, shape: circle, stroke: 0.8pt),
    node((0, 1), bluetext($theta_j$), name: <theta>, shape: circle, stroke: 0.8pt),
    // observed data (circle) and fixed n_j (square)
    node((0, 2), $y_j$, name: <y>, shape: rect, stroke: 0.8pt, inset: 11pt,),
    node((1, 2), $n_j$, name: <n>, shape: rect, stroke: 0.8pt, inset: 14pt, extrude: (0, -5)),
    // edges
    edge(<alpha>, <theta>, "-|>"),
    edge(<beta>, <theta>, "-|>"),
    edge(<theta>, <y>, "-|>"),
    edge(<n>, <y>, "-|>"),
    // plate over j
    node(
      enclose: (<theta>, <y>, <n>),
      stroke: 0.8pt,
      inset: 15pt,
      snap: false,
      align(top + right, $j$),
    ),
    // model annotations
    node((-2.6, 1), $#bluetext[$theta_j$] | #redtext[$alpha$], #redtext[$beta$] ~ "Beta"(theta_j | #redtext[$alpha$], #redtext[$beta$])$),
    node((-2.56, 1.5), $y_j | n_j, #bluetext[$theta_j$] ~ "Bin"(y_j | n_j, #bluetext[$theta_j$])$),
  )
]

- Joint posterior
  $p(#bluetext[$theta_1$], ..., #bluetext[$theta_J$], #redtext[$alpha$], #redtext[$beta$] | y)$
  - multiple parameters
  - factorize $product_(j=1)^J p(#bluetext[$theta_j$] | #redtext[$alpha$], #redtext[$beta$], y) p(#redtext[$alpha$], #redtext[$beta$] | y)$


// == Hierarchical binomial model: rats

// - Population prior $"Beta"(#bluetext[$theta_j$] | #redtext[$alpha$], #redtext[$beta$])$
// - Hyperprior $p(#redtext[$alpha$], #redtext[$beta$])$?
//   - #redtext[$alpha$], #redtext[$beta$] both affect the location and scale
//   - BDA3 has $p(#redtext[$alpha$], #redtext[$beta$]) prop (#redtext[$alpha$] + #redtext[$beta$])^(-5/2)$
//     - diffuse prior for location and scale (BDA3 p. 110)
//   - demo5\_1


// == Hierarchical binomial model: rats


// #align(center)[#image("figs/rats_posterior.pdf", width:14cm)]


== Hierarchical binomial model: rats

#align(center)[#image("figs/rats_hierdraws.pdf", width: 18cm)]


== Hierarchical binomial model: rats

#align(center)[#image("figs/rats_hierprior.pdf", width: 18cm)]



== Comparison of posterior distributions


  #align(center)[
  #grid(
    columns: 2,
    [
      #image("figs/rats_pooled.pdf", width: 13.5cm)
    ],
    [
      #image("figs/rats_separate.pdf", width: 13.5cm)
    ],
    [
      #image("figs/rats_hier_less.pdf", width: 13.5cm)
    ],
  )
  ]


== Shrinkage

#align(center)[#image("figs/rats_shrinkage_size.pdf", width: 24cm)]


== Hierarchical model and group size: Radon

919 home radon levels in 85 counties in Minnesota:
#v(-1cm)
#align(center)[
  #grid(
    columns: (auto, auto),
    rows: 2,
    align: (right + horizon, center + horizon),
    column-gutter: 3em,
    row-gutter: 0.0em,
    [*Separate*],     image("figs/radon2.pdf", width: 12cm),
    [*Hierarchical*], image("figs/radon4.pdf", width: 12cm),
  )
]

== Diet effect on chicken weights

- We have data on chicken weights for different diets
- We measure chicken weight at age 12 days
- Which diet increase weight the most?
- We decided that we want to model the diet effect hierarchically

== Plate and notation for hierarchical model

#align(center)[
  #diagram(
    spacing: (3.5em, 3em),
    node-stroke: none,

    // hyperparameters
    node((-0.5, 0), redtext($mu_0$), name: <mu0>, shape: circle, stroke: 0.8pt),
    node((0.5, 0), redtext($s$), name: <s>, shape: circle, stroke: 0.8pt),

    // per-diet means
    node((0, 1), bluetext($mu_j$), name: <mu>, shape: circle, stroke: 0.8pt),

    // observation noise
    node((-1, 2), redtext($sigma$), name: <sigma>, shape: circle, stroke: 0.8pt),

    // observed weight and fixed diet index
    node((0, 2), $y_i$, name: <y>, shape: rect, stroke: 0.8pt, inset: 11pt),
    node((1, 2), $d_i$, name: <d>, shape: rect, stroke: 0.8pt, inset: 14pt, extrude: (0, -5)),

    // edges
    edge(<mu0>, <mu>, "-|>"),
    edge(<s>, <mu>, "-|>"),
    edge(<mu>, <y>, "-|>"),
    edge(<sigma>, <y>, "-|>"),
    edge(<d>, <y>, "-|>"),

    // plate over diets j (observation plate omitted for readability)
    node(
      enclose: (<mu>, <y>, <d>),
      stroke: 0.8pt,
      inset: 15pt,
      snap: false,
      align(top + right, $j$),
    ),
  )
]
#v(1cm)
#align(center)[
  $
    #redtext[$mu_0$] &~ "Normal"(0, 1) &&quad "(hyperprior)" \
    #redtext[$s$] &~ "HalfNormal"(1) &&quad "(hyperprior)" \
    #redtext[$sigma$] &~ "HalfNormal"(1) &&quad "(prior)" \
    #bluetext[$mu_j$] &~ "Normal"(#redtext[$mu_0$], #redtext[$s$]) &&quad "(prior)" \
    y_i &~ "Normal"(#bluetext[$mu_(d_i)$], #redtext[$sigma$])
  $
]




== Stan code for hierarchical model

- Data and parameters blocks
#v(1cm)
```stan
data {
  int<lower=1> N_observations;
  int<lower=1> N_diets;

  vector[N_observations] weight;
  array[N_observations] int diet_idx;
}
```
#v(1cm)
```stan
parameters {
  vector[N_diets] mu_diet;
  real mu_0;
  real<lower=0> sd;
  real<lower=0> sigma;
}
```

== Stan hierarchical model

`diet_idx` is a vector with each element indicating the group

#code(
  highlight-lines: (10, 11, 12, 13),
```stan
model {
  // Priors
  for (diet in 1:N_diets) {
    mu_diet[diet] ~ normal(mu_0, sd);
  }
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);

  // Observation model
  for (obs in 1:N_observations) {
    weight[obs] ~ normal(mu_diet[diet_idx[obs]], sigma);
  }
}
```
)

== Stan hierarchical model

`mu_0` and `sd` are the population mean and sd

#code(
  highlight-lines: (1, 2, 3,4,5),
```stan
model {
  // Priors
  for (diet in 1:N_diets) {
    mu_diet[diet] ~ normal(mu_0, sd);
  }
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);
  
  // Observation model
  for (obs in 1:N_observations) {
    weight[obs] ~ normal(mu_diet[diet_idx[obs]], sigma);
  }
}
```
)


== Stan hierarchical model

in the `parameters block` we defined `sd` and `sigma` as constrained to be positive 


#code(
  highlight-lines: (3, 4),
```stan
parameters {
  ...
  real<lower=0> sd;
  real<lower=0> sigma;
}
```
)
 and thus the priors are half-normal

#code(
  highlight-lines: (7, 8),
```stan
model {
  // Priors
  for (diet in 1:N_diets) {
    mu_diet[diet] ~ normal(mu_0, sd);
  }
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);
  ...
}
```
)

== Stan without loops

Vectorized statements

#code(
  highlight-lines: (3,9),
```stan
model {
  // Priors
  mu_diet ~ normal(mu_0, sd);
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);
  
  // Observation model
  weight ~ normal(mu_diet[diet_idx], sigma);
}
```
)

== Interfaces for Bayesian modeling

- In R, it is common to describe statistical models with a formula. Often called Wilkinson notation.
- For Bayesian modeling:
  - `brms` (R):  This is what we use for the assigments course.
  - `Bambi` (Python): built on PyMC. Can be used for the final project

#v(1cm)


#grid(
  columns: (1fr, 1fr),
  gutter: -7em,
  [
    *brms (R)*
```r
fit <- brm(
  weight ~ 1 + (1 | diet),
  data = chicks)
```
  ],
  [
    *Bambi (Python)*
```python
model = bmb.Model(
       "weight ~ 1 + (1|diet)", 
        data=chicks)
idata = model.fit()
```
  ],
)
#v(1cm)
`1` is the shared intercept $mu_0$, and `(1 | diet)` is the group-level term: it gives each diet its own offset from $mu_0$, and the spread of those offsets is $s$.

== Stan vs brms

Stan
#code(
  highlight-lines: (3,9),
```stan
model {
  // Priors
  mu_diet ~ normal(mu_0, sd);
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);
  
  // Observation model
  weight ~ normal(mu_diet[diet_idx], sigma);
}
```
)

---

brms formula

#code(
  highlight-lines: (1),
```r
brm(weight ~ 1 + (1 | Diet), data=Chick12,
```
)


== Stan vs brms

Stan

```stan
model {
  // Priors
  mu_diet ~ normal(mu_0, sd);
  mu_0 ~ normal(0, 1);
  sd ~ normal(0, 1)
  sigma ~ normal(0, 1);
  
  // Observation model
  weight ~ normal(mu_diet[diet_idx], sigma);
}
```

---

brms formula

```r
brm(weight ~ 1 + (1 | Diet), data=Chick12,
    prior=c(prior(normal(0,1), class="Intercept"),
            prior(normal(0,1), class="sd"),
            prior(normal(0,1), class="sigma")))
```

== brms generated Stan code

- brms can automatically generate the corresponding Stan code for a given formula and priors.
- The code might look complex, but it essentially translates the brms formula and priors into the corresponding Stan model.

== brms generated Stan code

#code(
  highlight-lines: (8, 9, 10),
```stan
// generated with brms 2.22.1
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  array[N] int<lower=1> J_1;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_1;
  int prior_only;  // should the likelihood be ignored?
}
```
)

== brms generated Stan code


#code(
  highlight-lines: (4,5),
```stan
parameters {
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma;  // dispersion parameter
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
}
transformed parameters {
  vector[N_1] r_1_1;  // actual group-level effects
  real lprior = 0;  // prior contributions to the log posterior
  r_1_1 = (sd_1[1] * (z_1[1]));
  lprior += normal_lpdf(Intercept | 0, 1);
  lprior += normal_lpdf(sigma | 0, 1)
    - 1 * normal_lccdf(0 | 0, 1);
  lprior += normal_lpdf(sd_1 | 0, 1)
    - 1 * normal_lccdf(0 | 0, 1);
}
```
)


== brms generated Stan code


#code(
  highlight-lines: (11,12,13,14,15),
```stan
parameters {
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma;  // dispersion parameter
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
}
transformed parameters {
  vector[N_1] r_1_1;  // actual group-level effects
  real lprior = 0;  // prior contributions to the log posterior
  r_1_1 = (sd_1[1] * (z_1[1]));
  lprior += normal_lpdf(Intercept | 0, 1);
  lprior += normal_lpdf(sigma | 0, 1)
    - 1 * normal_lccdf(0 | 0, 1);
  lprior += normal_lpdf(sd_1 | 0, 1)
    - 1 * normal_lccdf(0 | 0, 1);
}
```
)

== brms generated Stan code

#code(
  highlight-lines: (5, 6, 7, 8, 9),
```stan
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    mu += Intercept;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu[n] += r_1_1[J_1[n]] * Z_1_1[n];
    }
    target += normal_lpdf(Y | mu, sigma);
  }
  // priors including constants
  target += lprior;
  target += std_normal_lpdf(z_1[1]);
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept;
}
```
)


== brms generated Stan code

#code(
  highlight-lines: (14,15),
```stan
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    mu += Intercept;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu[n] += r_1_1[J_1[n]] * Z_1_1[n];
    }
    target += normal_lpdf(Y | mu, sigma);
  }
  // priors including constants
  target += lprior;
  target += std_normal_lpdf(z_1[1]);
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept;
}
```
)




== Paper helicopters: flight time

Separate model vs. hierarchical model

#align(center)[#image("figs/helicopter_separate_hier_time_2024.pdf", width: 24cm)]


== Paper helicopters: stability

Separate model vs. hierarchical model

#align(center)[#image("figs/helicopter_separate_hier_stable_2024.pdf", width: 24cm)]


== Paper helicopters: brms

Flight time

```r
flight_time ~ s(wing_length) + s(wing_length, by = nclips)
```

#align(center)[#image("figs/helicopter_hier_time_2024.pdf", width: 24cm)]


== Paper helicopters: brms

Stability

```r
stable_flight ~ s(wing_length) + s(wing_length, by = nclips),
family = bernoulli()
```

#align(center)[#image("figs/helicopter_hier_stable_2024.pdf", width: 24cm)]


== Student retention

Was year 2022 better than earlier year?

#align(center)[#image("figs/student_retention_data.pdf", width: 20cm)]


== Separate model

#align(center)[#image("figs/student_retention_9_binom.pdf", width: 13cm)]

#align(center)[#image("figs/student_retention_9_binom_comp.pdf", width: 13cm)]


== Separate vs hierarchical model

#align(center)[#image("figs/student_retention_9_binom.pdf", width: 12cm)]

#align(center)[#image("figs/student_retention_9_binom_hier.pdf", width: 12cm)]


```r
nstudents | trials(nstudents1) ~ 1 + (1 | year), family=binomial()`
```


== Student retention latent spline model

#align(center)[#image("figs/student_retention_sbinom_linpreds.pdf", height: 8cm)]

#text(size:20pt)[
```r
nstudents | trials(nstudents1) ~ s(assignment, k=4) + (assignment | year), 
                                 family=binomial()
```
]

== Student retention latent spline model

#grid(
  columns: (1fr, 1fr),
  row-gutter: 0.5cm,
  align: center + horizon,

  grid.cell(colspan: 2)[
    #image("figs/student_retention_sbinom_linpreds.pdf", height: 8cm)
  ],

  image("figs/student_retention_sbinom_hier.pdf", width: 100%),
  image("figs/student_retention_sbinom_hier_comp.pdf", width: 100%),
)


== Year 2023?

#align(center)[#image("figs/student_retention_sbinom_linpreds_2.pdf", height: 7cm)]

#align(center)[#image("figs/student_retention_sbinom_hier_2.pdf", height: 8cm)]

== Year 2023?

#grid(
  columns: (1fr, 1fr),
  row-gutter: 0.5cm,
  align: center + horizon,

  grid.cell(colspan: 2)[
    #image("figs/student_retention_sbinom_linpreds_3.pdf", height: 8cm)
  ],

  image("figs/student_retention_sbinom_hier_3.pdf", width: 100%),
  image("figs/student_retention_sbinom_hier_comp_3.pdf", width: 100%),
)

== brms summary: one varying coefficient

Year specific intercepts have prior $"N"(0, sigma_"intercept")$

#text(size: 16pt)[
`nstudents | trials(nstudents1) ~ 1 + (1 | year), family=binomial()`
]
#v(1cm)
#text(size: 12pt)[
```
 Family: binomial 
  Links: mu = logit 
Formula: nstudents | trials(nstudents1) ~ 1 + (1 | year) 
   Data: filter(tb, assignment == 9) (Number of observations: 5) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Multilevel Hyperparameters:
~year (Number of levels: 5) 
              Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)     0.16      0.13     0.01     0.50 1.00      667      878

Regression Coefficients:
          Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept     0.68      0.11     0.45     0.92 1.01      390      242
```
]


== brms summary: two varying coefficients

Year specific intercepts and slopes have independent priors $"N"(0, sigma_"intercept")$ and $"N"(0, sigma_"assignment")$

#text(size: 16pt)[
`nstudents | trials(nstudents1) ~ assignment + (assignment || year), ...`
]
#v(1cm)
#text(size: 12pt)[
```
 Family: binomial 
  Links: mu = logit 
Formula: nstudents | trials(nstudents1) ~ assignment + (assignment || year) 
   Data: filter(tb, assignment > 1) (Number of observations: 40) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Multilevel Hyperparameters:
~year (Number of levels: 5) 
               Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)      0.79      0.45     0.30     1.95 1.00      972     1470
sd(assignment)     0.07      0.06     0.01     0.23 1.01      592      720

Regression Coefficients:
           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept      2.37      0.38     1.58     3.14 1.01     1114     1471
assignment    -0.21      0.04    -0.30    -0.14 1.00     1056      803
```
]


== brms summary: two varying coefficients

Year specific intercepts and slopes have a joint prior

$
  op("N") (mat(0; 0), quad
  mat(delim: #"[",
    sigma_"intercept", 0;
    0, sigma_"slope"
  ) mat(
    1, rho;
    rho, 1
  ) mat(delim: #"[",
    sigma_"intercept", 0;
    0, sigma_"slope"
  )^T)
$

#text(size: 16pt)[
`nstudents | trials(nstudents1) ~ assignment + (assignment | year), ...`
]
#v(1cm)
#text(size: 12pt)[
```
 Family: binomial 
  Links: mu = logit 
Formula: nstudents | trials(nstudents1) ~ assignment + (assignment | year) 
   Data: filter(tb, assignment > 1) (Number of observations: 40) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Multilevel Hyperparameters:
~year (Number of levels: 5) 
                          Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)                 0.76      0.35     0.34     1.69 1.00     1079     1487
sd(assignment)                0.06      0.03     0.02     0.15 1.00     1211     1979
cor(Intercept,assignment)    -0.85      0.23    -1.00    -0.20 1.00     1730     2265

Regression Coefficients:
           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept      2.36      0.37     1.60     3.10 1.00      860     1179
assignment    -0.21      0.03    -0.27    -0.14 1.00     1073     1464
```
]

== brms multivariate population prior

#text(size: 16pt)[
`nstudents | trials(nstudents1) ~ assignment + (assignment | year), ...`
]

Year specific intercepts and slopes have a joint prior

$
  op("N") (mat(0; 0), quad
  mat(delim: #"[",
    sigma_"intercept", 0;
    0, sigma_"slope"
  ) mat(
    1, rho;
    rho, 1
  ) mat(delim: #"[",
    sigma_"intercept", 0;
    0, sigma_"slope"
  )^T)
$

- brms uses LKJ prior for the correlation matrix
- LKJ is a good default weakly informative prior for correlation matrices


== Exchangeability

- _Exchangeability_: Parameters $theta_1, ..., theta_J$ (or observations $y_1, ..., y_J$) are
  exchangeable if the joint distribution $p$ is invariant to the
  permutation of indices $(1, ..., J)$
- e.g.
  $p(theta_1, theta_2, theta_3) = p(theta_2, theta_3, theta_1)$
- Exchangeability implies symmetry: If there is no information
  which can be used _a priori_ to separate $theta_j$ from
  each other, we can assume exchangeability.
  - "Ignorance implies exchangeability"


== Exchangeability

- Exchangeability does not mean that the results of the
  experiments could not be different
  - e.g. if we know that the experiments have been in two
    different laboratories, and we know that the other laboratory
    has better conditions for the rats, but we do not know which
    experiments have been made in which laboratory
  - a priori experiments are exchangeable
  - model could have unknown parameter for the laboratory with a
    conditional prior for rats assumed to come from the same place
    (clustering model)


== Exchangeability

- Justifies why we can use
  - a joint model for data: if $y_1,...,y_J$ are exchangeable (de Finetti), then
    $p(y_1,...,y_J) = integral product_(j=1)^J p(y_j | theta) p(theta) d theta$
    i.e. iid given $theta$
  - a joint prior for parameters: if $theta_1,...,theta_J$ are exchangeable, then
    $p(theta_1,...,theta_J) = integral product_(j=1)^J p(theta_j | tau) p(tau) d tau$
    i.e. iid given hyperparameters $tau$
- Less strict than independence
  - iid $=>$ exchangeable, but not the reverse


== Exchangeability and additional information

- Example: bioassay
  - $y_i$ number of dead animals are not exchangeable alone
  - $x_i$ dose is additional information
  - $(x_i, y_i)$ exchangeable and logistic regression was used

$
  p(alpha, beta | y, n, x) prop product_(i=1)^n p(y_i | alpha, beta, n_i, x_i) p(alpha, beta)
$


== Hierarchical exchangeability

- Example: hierarchical rats example
  - all rats not exchangeable
  - in a single laboratory rats exchangeable
  - laboratories exchangeable
  - $arrow.double$ hierarchical model
- Example: paper helicopters
  - we may assume that the groups had variation in dropping height, dropping technique, timing, and how to define unstable


== Partial or conditional exchangeability

- Conditional exchangeability
  - if $y_i$ is connected to an additional information $x_i$, so
    that $y_i$ are not exchangeable, but $(y_i, x_i)$ exchangeable
    use joint model or conditional model $(y_i | x_i)$.
- Partial exchangeability
  - if the observations can be grouped (a priori), then use
    hierarchical model


== Centered vs non-centered parameterization

HMC divergences are more likely when using hierarchical models


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_trace1.pdf", height: 10cm)]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_cummean1.pdf", height: 10cm)]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_cummean1b.pdf", height: 10cm)]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_trace.pdf", height: 10cm)]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_scatter_08.pdf", height: 10cm)]

#text(size: 18pt)[
```
Warning: 29 of 4000 (1.0%) transitions ended with a divergence.
See https://mc-stan.org/misc/warnings for details.
```
]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_hard_scatter_08_0999.pdf", height: 10cm)]

#text(size: 18pt)[
```
variable  mean median    sd   mad    q5   q95  rhat ess_bulk ess_tail
lsigma0   -1.9   -2.1  0.41  0.13  -2.3 -0.91   2.0      5.8      14.
```
]


== Divergences

- HMC specific: indicates that Hamiltonian dynamic simulation
  has problems with unexpected fast changes in log-density
  - indicates possibility of biased estimates

#align(center)[#image("figs/kilpis_hier_cp_ncp_hard_scatter.pdf", height: 10cm)]

With NCP parameterization

#text(size: 14pt)[
```
variable  mean median    sd   mad     q5   q95  rhat ess_bulk ess_tail
sigma0    0.27   0.24  0.19  0.20  0.023  0.64   1.0    1571.    1737.
lsigma0  -1.7   -1.4   1.1   0.87 -3.8   -0.45   1.0    1571.    1737.
```
]


== Centered parameterization


```stan
data {
  int<lower=0> N;                   // number of observations
  int<lower=0> K;                   // number of groups
  array[N] int<lower=1, upper=K> x; // discrete group indicators
  vector[N] y;                      // real valued observations
}
```

```stan
parameters {
  real mu0;                         // prior mean
  real<lower=0> sigma0;             // prior std constrained to be pos.
  vector[K] mu;                     // group means
  real<lower=0> sigma;              // common std constrained to be pos.
}
```

```stan
model {
  mu0 ~ normal(10, 10);             // weakly informative prior
  sigma0 ~ normal(0, 10);           // weakly informative prior
  mu ~ normal(mu0, sigma0);         // population prior with unknown param.
  sigma ~ lognormal(0, .5);         // weakly informative prior
  y ~ normal(mu[x], sigma);         // observation model
}
```


== Centered parameterization

First data with many observations per group: 3 summer months with
each having 71 observations.

A few divergences that are not clustered.

#align(center)[#image("figs/kilpis_hier_cp_easy_1.pdf", width: 10cm)]


== Centered parameterization

First data with many observations per group: 3 summer months with
each having 71 observations.

And decreasing step size a little helps.

#align(center)[#image("figs/kilpis_hier_cp_easy_2.pdf", width: 10cm)]


== Centered parameterization

Second data with a few observations per group: 71 years with
each having 3 observations.

Many divergences that are clustered.

#align(center)[#image("figs/kilpis_hier_cp_hard_1.pdf", width: 12cm)]


== Centered parameterization

Second data with a few observations per group: 71 years with
each having 3 observations.

And decreasing step size doesn't remove the problem.

#align(center)[#image("figs/kilpis_hier_cp_hard_2.pdf", width: 10cm)]


== Centered parameterization

Hierarchical model code from the course demos

```stan
parameters {
  real mu0;                         // prior mean
  real<lower=0> sigma0;             // prior std constrained to be pos.
  vector[K] mu;                     // group means
  real<lower=0> sigma;              // common std constrained to be pos.
}
```

```stan
model {
  mu0 ~ normal(10, 10);             // weakly informative prior
  sigma0 ~ normal(0, 10);           // weakly informative prior
  mu ~ normal(mu0, sigma0);         // population prior with unknown param.
  sigma ~ lognormal(0, .5);         // weakly informative prior
  y ~ normal(mu[x], sigma);         // observation model
}
```


== Non-centered parameterization

Transformation

```stan
parameters {
  real mu0;                         // prior mean
  real<lower=0> sigma0;             // prior std constrained to be pos.
  vector[K] z;                      // latent variable
  real<lower=0> sigma;              // common std constrained to be pos.
}
```

```stan
transformed parameters {
  vector[K] mu = mu0 + sigma0 * z;  // group means
}
```

```stan
model {
  mu0 ~ normal(10, 10);     // weakly informative prior
  sigma0 ~ normal(0, 10);   // weakly informative prior
  z ~ normal(0, 1);         // unit normal
  sigma ~ lognormal(0, .5); // weakly informative prior
  y ~ normal(mu[x], sigma); // observation model
}
```


== Non-centered parameterization

Second data with a few observations per group: 71 years with
each having 3 observations.

A few divergences that are not clustered.

#align(center)[#image("figs/kilpis_hier_ncp_hard_1.pdf", width: 12cm)]


== Non-centered parameterization

Second data with a few observations per group: 71 years with
each having 3 observations.

And decreasing step size a little helps.

#align(center)[#image("figs/kilpis_hier_ncp_hard_2.pdf", width: 12cm)]


== Non-centered parameterization

Second data with a few observations per group: 71 years with
each having 3 observations.

Because we're actually sampling `z` and not `mu`

#align(center)[#image("figs/kilpis_hier_ncp_hard_z_2.pdf", width: 12cm)]


== Non-centered parameterization

No free lunch

- non-centered parameterization is good when likelihood is weak
- non-centered parameterization is bad when likelihood is strong


== Non-centered parameterization

First data with many observations per group: 3 summer months with
each having 71 observations.

Many divergences that are not clustered.

#align(center)[#image("figs/kilpis_hier_ncp_easy_1.pdf", width: 12cm)]


== Non-centered parameterization

First data with many observations per group: 3 summer months with
each having 71 observations.

But decreasing step size a lot helps.

#align(center)[#image("figs/kilpis_hier_ncp_easy_2.pdf", width: 12cm)]


== Non-centered parameterization

First data with many observations per group: 3 summer months with
each having 71 observations.

Now the posterior for `z` is problematic.

#align(center)[#image("figs/kilpis_hier_ncp_easy_z_1.pdf", width: 12cm)]


// == Centered vs. non-centered parameterization

// Strong likelihood | Weak likelihood
// :---: | :---:
// #image("figs/kilpis_hier_cp_easy_2.pdf", width: 4cm) | #image("figs/kilpis_hier_cp_hard_1.pdf", width: 4cm)
// Centered | Centered
// #image("figs/kilpis_hier_ncp_easy_1.pdf", width: 4cm) | #image("figs/kilpis_hier_ncp_hard_2.pdf", width: 4cm)
// Non-centered | Non-centered


== brms and rstanarm

- brms and rstanarm use non-centered parameterization
  - as hierarchical models and Bayesian inference is most useful
    when likelihood is weak
- If the likelihood is highly informative for all groups, and
  the non-centered parameterization is causing divergences,
  - use fixed population prior model as the hierarchical part is not
    that important with strong likelihood. Instead of
    ```r
    y ~ 1 + (1 | group)
    ```
    use, for example,
    ```r
    y ~ 1 + group,
    prior = prior(normal(0, 10), class="b", coeff="group")
    ```
- There can be need for both centered and non-centered
  parameterization in the same model
  - automation not easy, but research goes on


// == brms non-centered parameterization

// ```stan
// parameters {
//   real Intercept;  // temporary intercept for centered predictors
//   real<lower=0> sigma;  // dispersion parameter
//   vector<lower=0>[M_1] sd_1;  // group-level standard deviations
//   array[M_1] vector[N_1] z_1;  // standardized group-level effects
// }
// transformed parameters {
//   vector[N_1] r_1_1;  // actual group-level effects
//   r_1_1 = (sd_1[1] * (z_1[1]));
// //...
// }
// model {
// //...
//     for (n in 1:N) {
//       // add more terms to the linear predictor
//       mu[n] += r_1_1[J_1[n]] * Z_1_1[n];
//     }
// //...
//   target += std_normal_lpdf(z_1[1]);
// }
// ```


== Kilpisjärvi summer temperature

Posterior draws of alpha and beta

#align(center)[#image("figs/kilpis_lin_mcmc_scatter.pdf", width: 13cm)]

#text(size: 14pt)[
```r
Warning: 1 of 4000 (0.0%) transitions hit the maximum treedepth limit of 10.
See https://mc-stan.org/misc/warnings for details.
```
]

Solution was to center the covariate time to have mean 0, so that the
intercept is the expected temperature in the middle of the range


// == brms covariate centering by default

// ```r
// fit_lin <- brm(temp ~ year, data = data_lin)
// ```

// ```stan
// transformed data {
//   matrix[N, Kc] Xc;  // centered version of X without an intercept
//   vector[Kc] means_X;  // column means of X before centering
//   for (i in 2:K) {
//     means_X[i - 1] = mean(X[, i]);
//     Xc[, i - 1] = X[, i] - means_X[i - 1];
//   }
// }
// parameters {
//   vector[Kc] b;  // regression coefficients
//   real Intercept;  // temporary intercept for centered predictors
//   real<lower=0> sigma;  // dispersion parameter
// }
// model {
// //...
//   target += normal_id_glm_lpdf(Y | Xc, Intercept, b, sigma);
// //...
// }
// generated quantities {
//   // actual population-level intercept
//   real b_Intercept = Intercept - dot_product(means_X, b);
// }
// ```


// == brms covariate centering by default

// Sometimes we want to turn off the covariate centering, which can be
// done with additional argument for brms formula function
// `bf()`

// ```r
// fit_lin <- brm(bf(temp ~ year, center=FALSE), data = data_lin)
// ```


== brms formulas

#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  stroke: none,
  table.hline(),
  table.header([*Model*], [*Formula*], [*Alternative formula*]),
  table.hline(),

  table.cell(colspan: 3)[_Intercept only_],
  [$y tilde "N"(alpha, sigma)$], [`y ~ 1`], [],

  table.hline(stroke: 0.5pt),
  table.cell(colspan: 3)[_Linear models_],
  [$y tilde "N"(alpha + beta x, sigma)$], [`y ~ x`], [`y ~ 1 + x`],
  [$y tilde "N"(beta x, sigma)$], [`y ~ 0 + x`], [`y ~ -1 + x`],

  table.hline(stroke: 0.5pt),
  table.cell(colspan: 3)[_Hierarchical models_],
  [$y tilde "N"(alpha_0 + alpha_g + beta x, sigma)$],
  [`y ~ x + (1 | g)`],
  [`y ~ 1 + x + (1 | g)`],

  [$y tilde "N"(alpha_0 + alpha_g + beta_0 x + beta_g x, sigma)$],
  [`y ~ x + (x | g)`],
  [`y ~ 1 + x + (1 + x | g)`],
  table.hline(),
)

== brms formulas

#table(
  columns: (auto, auto),
  align: (left, left),
  stroke: none,
  table.hline(),
  table.header([*Model*], [*Formula*]),
  table.hline(),

  table.cell(colspan: 2)[_Heteroskedastic_],
  [$y tilde "N"(alpha_mu + beta_mu x, exp(alpha_sigma + beta_sigma x))$],
  [`bf(y ~ x, sigma ~ x)`],
  table.hline(),
)

== brms families

#table(
  columns: (auto, auto),
  align: (left, left),
  stroke: none,
  table.hline(),
  table.header([*Model*], [*brms*]),
  table.hline(),

  [$y tilde t_nu(alpha + beta x, sigma)$],
  [`y ~ x, family = student()`],

  [$y tilde "Binomial"("logit"^(-1)(alpha + beta x), N)$],
  [`y | trials(N) ~ x, family = binomial()`],

  [$y tilde "Neg-bin"(exp(alpha + beta x), phi)$],
  [`y ~ x, family = negbinomial()`],
  table.hline(),
)

== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

```r
> head(dat.baker2009)
                  study year id   treatment exac total
1 Llewellyn-Jones 1996 1996  1 Fluticasone    0     8
2 Llewellyn-Jones 1996 1996  1     Placebo    3     8
3            Boyd 1997 1997  2  Salmeterol   47   229
4            Boyd 1997 1997  2     Placebo   59   227
5        Paggiaro 1998 1998  3 Fluticasone   45   142
6        Paggiaro 1998 1998  3     Placebo   51   139
```


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

A big variation in the number of patients per study

#align(center)[#image("figs/baker2009_n_patients_per_study.pdf", width: 22cm)]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

2--4 drugs tested per study, and some not including placebo

#align(center)[#image("figs/baker2009_treatments_and_studies.pdf", width: 22cm)]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

Pooled over studies, separate for treatments

#text(size: 16pt)[
```r
fit_pooled <- brm(exac | trials(total) ~ 0 + treatment,
                  prior = prior(student_t(7, 0, 1.5), class='b'),
                  family = binomial(), data = dat.baker2009)
```
]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

Pooled over studies, separate for treatments

#align(center)[#image("figs/baker2009_pooled_studies_odds_ratio.pdf", width: 20cm)]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

Hirerachical for studies, hierarchical for treatments

#text(size: 16pt)[
```r
fit_hier <- brm(exac | trials(total) ~ (1 | treatment) + (1 | study),
                family = binomial(), data = dat.baker2009)
```
]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

Hirerachical for studies, hierarchical for treatments

#align(center)[#image("figs/baker2009_hier1_odds_ratio.pdf", width: 20cm)]


== Meta-analysis

Pharmacologic treatments for chronic obstructive pulmonary disease

Hirerachical for studies, hierarchical for treatments

#align(center)[#image("figs/baker2009_hier1_study_effects.pdf", width: 28cm)]


== BDA course demo for brms

Link in the course web site or directly

#text(size: 18pt)[https://avehtari.github.io/BDA_R_demos/demos_rstan/brms_demo.html]
