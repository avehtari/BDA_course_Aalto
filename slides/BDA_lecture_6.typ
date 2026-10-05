#import "@preview/mosaic:0.0.1" as m
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 6],
  //authors: [Aki Vehtari, Osvaldo Martin],
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

#show raw.where(lang: "stan"): set raw(
  syntaxes: "Stan.sublime-syntax",
  theme: "Stan.tmTheme",
)
#m.slide(layout: "title")


== BDA Chapter 12

- #graytext[12.1 Efficient Gibbs samplers (not part of the course)]
- #graytext[12.2 Efficient Metropolis jump rules (not part of the course)]
- #graytext[12.3 Further extensions to Gibbs and Metropolis (not part of the course)]
- 12.4 Hamiltonian Monte Carlo (important)
- 12.5 Hamiltonian dynamics for a simple hierarchical model (useful example)
- 12.6 Stan: developing a computing environment (useful intro)


== Objectives of this Lecture

- Introduce more advanced and modern MCMC methods
  - Hamiltonian Monte Carlo (HMC) and the No-U-Turn Sampler (NUTS)
- Introduce probabilistic programming languages and in particular Stan


== Elevator Pitch 

- Hamiltonian Monte Carlo (HMC) is a subclass of MCMC methods that uses gradient information to generate proposals 
- In practice this allows HMC to (potentially) explore high-dimensional posterior distributions in an efficient manner
- Why it works: by using gradient information, HMC can propose distant states with high acceptance probability, reducing random-walk behavior and improving sampling efficiency
#v(1fr)
Demo #link("https://chi-feng.github.io/mcmc-demo/app.html?algorithm=HamiltonianMC&target=banana")[Hamiltonian Monte Carlo demo]


== A little bit of history

- Originally for quantum-chromo-dynamic simulation (Duane et al., 1987)
- Radford Neal started using for Bayesian neural networks in 1990's
- Hoffman and Gelman's (2014) presented the first version of NUTS, making HMC more robust and easier to use in practice
- Nowadays most popular probabilistic programming languages/frameworks use it: Stan, PyMC, NumPyro, Turing.jl, etc
- It is often used as the gold standard for evaluating other inference methods
- What today people informally call "NUTS" has many improvements over the original 2014 version by Hoffman and Gelman.


== Hamiltonian dynamics: a physical picture

- Imagine a frictionless particle moving in a 1D "bowl"
  - Position $theta$: where the particle is
  - Momentum $phi$: how fast and in which direction it is moving
  #v(0.5cm)
- This mechanical system can be fully described in terms of:
  - Potential energy $U(theta)$: depends on the position $theta$
  - Kinetic energy $K(phi)$: depends on how fast the particle moves
- Total energy $H(theta, phi) = U(theta) + K(phi)$ stays constant along the motion

#align(center)[#image("figs/energy_split.pdf", width: 22cm)]


== Hamiltonian mechanics

- $H(theta, phi) = U(theta) + K(phi)$ is called the Hamiltonian of the system
- Hamilton's equations describe how position and momentum change in time:

$ (dif theta) / (dif t) = (partial H) / (partial phi) = M^(-1) phi, quad quad (dif phi) / (dif t) = - (partial H) / (partial theta) = - nabla U(theta) $

- Interpretation:
  - Position, $theta$, changes in proportion to the momentum, with velocity $M^(-1) phi$ ($M$: mass matrix)
  - Momentum, $phi$, changes in the direction of steepest descent of $U$, i.e. the force is $-nabla U(theta)$
- Key properties, also important for MCMC:
  - Energy, $H(theta, phi)$, is conserved
  - The trajectories are reversible
  - Volume in $(theta, phi)$ space is preserved

== From physics to posterior sampling

- Potential energy: $U(theta) = - log p(theta | y) + c$ 
- Kinetic energy: $K(phi) = - log "N"(phi | 0, M) + c$
- Joint distribution: $p(theta, phi | y) prop exp(-H(theta, phi))$, with $H = U + K$
- $theta$ and $phi$ are independent, and the marginal of $theta$ is exactly the posterior
- To get samples from $p(theta | y)$, we sample $p(theta, phi | y)$ and discard $phi$

#v(1cm)
#align(center)[#image("figs/hmc_joint_plot.pdf", width: 27cm)]

== The basic HMC algorithm

+ *Refresh momentum:* draw $phi tilde "N"(0, M)$ (a random "push" in a random direction)
+ *Simulate the dynamics:* follow Hamilton's equations
+ *Accept or reject* the proposal with a Metropolis step
+ *Repeat* the steps for the desired number of draws

#align(center)[#image("figs/hmc_levels.pdf", width: 18cm)]


== Why this works?

- For an exact simulation $H$ is conserved and every proposal would be accepted
- The proposed value $theta^*$ can be far from $theta^(t-1)$ but still has high acceptance
- In practice the simulation is not exact but we can use Metropolis acceptance to account for errors


== Simulating Hamilton's equations

- Except for toy cases, we cannot solve the equations analytically, so we approximate the trajectory with discrete steps of size $epsilon$
- The most commonly used method in HMC is the *leapfrog method*. One step:
  $ phi &arrow.l phi - epsilon/2 nabla U(theta) \
    theta &arrow.l theta + epsilon M^(-1) phi \
    phi &arrow.l phi - epsilon/2 nabla U(theta) $
- Repeat for $L$ steps to get the proposal $(theta^*, phi^*)$.
- It is reversible and volume preserving, and the energy error does not usually grow in time


== Leapfrog: step size $epsilon$

- The discretization is not exact, so after $L$ steps $H(theta^*, phi^*) eq.not H(theta^(t-1), phi^(t-1))$
- Metropolis step: accept the proposal with probability
  $ alpha = min(1, exp(H(theta^(t-1), phi^(t-1)) - H(theta^*, phi^*))) $
- Small $epsilon$: small error, so $alpha approx 1$, but many steps are needed to move far
- Large $epsilon$: fewer steps, larger error, lower $alpha$. The simulation may diverge
#v(0.5cm)
#align(center)[#image("figs/hmc_step_size.pdf", width: 22cm)]


== Leapfrog: number of steps $L$

- For a fixed $epsilon$, the trajectory length is $epsilon L$
- Too few steps: short moves, which behave like a random walk
- Too many steps: and the trajectory may make a U-turn, wasting computation
- The best $epsilon$ and $L$ depend on the posterior geometry, so they change from problem to problem

#align(center)[#image("figs/hmc_u_turn.pdf", width: 17cm)]

== No-U-Turn Sampler (NUTS)

- The NUTS algorithm automatically determines when to stop the trajectory to avoid U-turns
- It makes HMC very easy to use in practice
- It is the de-facto standard for Bayesian inference

#v(1fr)
Hoffman and Gelman (2014): #link("https://jmlr.org/papers/v15/hoffman14a.html")


== NUTS: the U-turn detection

- We need to be careful in how we detect the U-turn to ensure the correctness of the sampler

1. Start from the current state
2. Choose at random whether to extend the trajectory forward or backward in time3. Run $2^j$ new leapfrog steps in that direction ($j = 0, 1, 2, ...$)
  - Internally, a binary tree of states is used to efficiently check for U-turns and preserve reversibility
4. Check for a U-turn. If found, stop. Otherwise, go to step 2.
5. Use one of the visited states as the proposed state


== NUTS: selecting the proposal

- Original NUTS
  - choose a point along the simulation path and they accept/reject following a Metropolis criterion #text(size:15pt)[(details in the original NUTS paper)]
- NUTS with multinomial sampling
  - compute the acceptance probability for all points along the simulation path
  - select the point with multinomial sampling
  - more likely to accept a point that is not the previous one
  - No need for a separate Metropolis acceptance step

== NUTS: Other details

- Besides the U-turn detection we also stop if
  - the trajectory becomes too long (`max_treedepth`)
  - the energy error becomes too large (divergence)
- We also need to choose the step size $epsilon$ and the mass matrix $M$
  - We get them adaptively during the warmup phase
  - Mass matrix adapted using an estimate of the posterior covariance
  - Step size adjusted to be as big as possible while keeping discretization error in control (`adapt_delta`)
- After adaptation the algorithm parameters are fixed and some more iterations run to finish the warmup
#v(1fr)
#link("https://chi-feng.github.io/mcmc-demo/app.html?algorithm=DualAveragingNUTS&target=banana")[Dual averaging demo]


== Divergences

- A divergence happens when the leapfrog simulation becomes unstable and the energy error becomes very large
  - The step size $epsilon$ is too large for the local geometry of the posterior
- It is an HMC-specific diagnostic: it points to the regions where the sampler has trouble


== Divergences

- Divergences may indicate:
  - regions where the log density changes too fast for the step size
  - hence the estimates may be biased

#align(center)[#image("figs/kilpis_hier_cp_hard_scatter_08_0999.pdf", height: 12cm)
]


== Problematic distributions

- Funnels (next lecture)
  - optimal step size depends on location
- Non-linear dependencies
  - simple mass matrix scaling doesn't help
- Multimodal
  - difficult to move from one mode to another
- Long-tailed with non-finite variance and mean
  - efficiency of exploration is reduced


== Recent gradient based samplers

- GPU-friendly alternatives:
  - ChEES-HMC (Hoffman et al., 2021), MEADS (Hoffman & Sountsov, 2022), MALT (Riou-Durand and Vogrinc, 2022; Riou-Durand et al., 2022)
  - The problem with NUTS is that we do not know how large the tree will grow, so each chain needs a different number of leapfrog steps and the others wait for the slowest
#v(0.5cm)
- Nutpie (Seyboldt et al., 2026)
  - Better mass matrix adaptation
- WALNUTS (Bou-Rabee et al., 2025)
  - adaptive step size within dynamic simulation


== Probabilistic programming language

- A probabilistic programming language (PPL) is a programming language *designed* to describe probabilistic models and then perform *automatic inference* in those models

 #v(1cm)
- A useful PPL should have:
  - inference has to be as automatic as possible
  - fast enough (manual work replaced with automation)
  - access to diagnostics for telling if the automatic inference doesn't work
  - easy workflow and integration with other tools
 #v(1cm)
- Many PPL exist:
  Stan, PyMC, NumPyro, Turing.jl...

#v(1fr)
#text(size: 18pt)[Štrumbelj et al. (2023). Past, Present, and Future of Software for Bayesian Inference. _Statistical Science_, 39(1):46-61. #link("https://doi.org/10.1214/23-STS907")]



== Stan PPL, ecosystem and community

- Language, inference engine, user interfaces, documentation, case studies, diagnostics, packages, ...
- Named after Stanislaw Ulam
- Widely popular, 200K+ users in social, biological, and physical sciences, medicine, engineering, and business
- Several full time developers, 40+ developers, 100+ contributors
- R, Python, Julia, Scala, Stata, command line interfaces
- 300+ R packages using Stan

#align(center)[
  #image("figs/Stan_logo_blue_tm.png", width: 5cm)
  #link("https://mc-stan.org")[mc-stan.org]
]




== Stan language

- Strongly typed domain-specific language for constructing models probabilistics models:
- And then interfaces for standard programming languages like R, Python, Julia... So you can use Stan models within your preferred programming environment.
- Stan transpiles the model to C++, so sampling is fast.
- Stan is Turing complete

== Binomial model - Stan code

```stan
data {
  int<lower=0> N;         // number of experiments
  int<lower=0,upper=N> y; // number of successes
}
```
#v(1cm)
- Data type and size are declared
- Stan checks that given data matches type and constraints

== Binomial model - Stan code

```stan
parameters {
  real<lower=0,upper=1> theta; // parameter of the binomial
}
```
- Only continuous parameters allowed
 - Discrete parameters can often be integerated out in the model block
- Parameters may have constraints
- Sampling is done in unconstrained space
  - Avoids hard boundaries and hence $-oo$ log densities
  - Transformations are done automatically (including Jacobian adjustments)
    - e.g. log transformation for `<lower=a>`

== Binomial model - Stan code

```stan
model {
  theta ~ beta(1, 1);     // prior
  y ~ binomial(N, theta); // observation model
}
```

- `~` defines a _distribution statement_
- if `y` are data, and `theta` is a parameter, then that term defines log likelihood
- for Stan sampler there is no difference between prior and likelihood, all that matters is the final `target`

== Log density increment statements

```stan
model {
  target += beta_lpdf(theta | 1, 1);
  target += binomial_lpmf(y | N, theta);
}
```
- left side of $|$ denotes what is distributed as, e.g., binomial
- `target` is the log posterior density (Lecture 4 discussed log)
- `_lpdf` for continuous, `_lpmf` for discrete distributions (left of `|`)
- You can think of `~` as syntactic sugar for `target +=` statements
- Using `target +=` gives more control and can be useful to express certain models.




== CmdStanR

CmdStanR is an R interface for Stan

```r
# Load CmdStanR
library(cmdstanr) 
options(mc.cores = 1)

# Compile Stan model
mod_bin <- cmdstan_model(stan_file = 'binom.stan')

# Sample from the posterior given the model and data
d_bin <- list(N = 10, y = 7)
fit_bin <- mod_bin$sample(data = d_bin)

# Show summary and access draws
fit_bin$summary()
draws <- fit_bin$draws(format = "df")
```


== Difference between proportions

- An experiment was performed to estimate the effect of beta-blockers on mortality of cardiac patients
- A group of patients were randomly assigned to treatment and control groups:
  - out of 674 patients receiving the control, 39 died
  - out of 680 receiving the treatment, 22 died

== The model

- $theta_1$, $theta_2$: probability of death in the control and treatment groups
- Uniform priors: $"Beta"(1, 1)$ 
- Deaths in each group are binomial, given the group's death probability

$
  theta_1 &tilde "Beta"(1, 1) \
  theta_2 &tilde "Beta"(1, 1) \
  y_1 | theta_1 &tilde "Binomial"(N_1, theta_1) \
  y_2 | theta_2 &tilde "Binomial"(N_2, theta_2)
$

- Quantity of interest, the odds ratio (treatment vs. control):

$
  psi = (theta_2 / (1 - theta_2)) / (theta_1 / (1 - theta_1))
$

- Data: $N_1 = 674, y_1 = 39$ (control) and $N_2 = 680, y_2 = 22$ (treatment)

== The Stan model
```stan
data {
  int<lower=0> N1;
  int<lower=0> y1;
  int<lower=0> N2;
  int<lower=0> y2;
}
parameters {
  real<lower=0,upper=1> theta1;
  real<lower=0,upper=1> theta2;
}
model {
  theta1 ~ beta(1, 1);
  theta2 ~ beta(1, 1);
  y1 ~ binomial(N1, theta1);
  y2 ~ binomial(N2, theta2);
}
# Generated quantities is run after the sampling
generated quantities {
  real oddsratio;
  oddsratio = (theta2/(1-theta2))/(theta1/(1-theta1));
}
```

== Difference between proportions


```r
d_bin2 <- list(N1 = 674, y1 = 39, N2 = 680, y2 = 22)
mod_bin2 <- cmdstan_model(stan_file = 'binom2.stan')
fit_bin2 <- mod_bin2$sample(data = d_bin2, refresh=1000)
```
#v(1cm)

```
> Running MCMC with 4 parallel chains...

Chain 1 Iteration:    1 / 2000 [  0%]  (Warmup) 
Chain 1 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
Chain 1 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
Chain 1 Iteration: 2000 / 2000 [100%]  (Sampling) 
...
All 4 chains finished successfully.
Mean chain execution time: 0.0 seconds.
Total execution time: 0.2 seconds.
```



== Difference between proportions

```r
options(posterior.num_args=list(sigfig=2))
fit_bin2$summary()
```
#v(1cm)

#text(size: 18pt)[
```
  variable    mean  median     sd    mad      q5     q95  rhat ess_bulk ess_tail
1 lp__     -2.5e+2 -2.5e+2 1.0    0.74   -2.6e+2 -2.5e+2   1.0    1751.    2231.
2 theta1    5.9e-2  5.9e-2 0.0093 0.0093  4.5e-2  7.5e-2   1.0    3189.    2657.
3 theta2    3.4e-2  3.3e-2 0.0069 0.0067  2.3e-2  4.6e-2   1.0    3229.    2163.
4 oddsratio 5.7e-1  5.5e-1 0.16   0.15    3.5e-1  8.7e-1   1.0    2998.    2685.
```
]

- `lp__` is the log density, ie, same as `target`


== HMC specific diagnostics

#text(size: 18pt)[
```r
fit_bin2$diagnostic_summary(diagnostics = c("divergences",
 "treedepth"))
```
]

#text(size: 16pt)[
```
$num_divergent
[1] 0 0 0 0

$num_max_treedepth
[1] 0 0 0 0
```
]

`diagnostic_summary()` includes E-BFMI diagnostic, which I'll skip in this course


== Difference between proportions (bayesplot)

#text(size: 16pt)[
```r
draws <- fit_bin2$draws(format = "df")
mcmc_hist(draws, pars = 'oddsratio') +
  geom_vline(xintercept = 1) +
  scale_x_continuous(breaks = c(seq(0.25,1.5,by=0.25)))
```
]

#align(center)[#image("figs/betablockoddsratio.pdf", width: 17cm)]


== Difference between proportions (ggplot2)

#text(size: 16pt)[
```r
draws <- fit_bin2$draws(format = "df")
draws |> ggplot(aes(x=oddsratio)) +
  geom_histogram() +
  geom_vline(xintercept = 1) +
  scale_x_continuous(breaks = c(seq(0.25,1.5,by=0.25)))
```
]

#align(center)[#image("figs/betablockoddsratio_ggplot.pdf", width: 17cm)]


== Difference between proportions (ggdist dot plot)

#text(size: 16pt)[
```r
draws <- fit_bin2$draws(format = "df")
draws |> ggplot(aes(x=oddsratio)) +
  stat_dotsinterval(quantiles = 100) + 
  geom_vline(xintercept = 1) +
  scale_x_continuous(breaks = c(seq(0.25,1.5,by=0.25)))
```
]

#align(center)[#image("figs/betablockoddsratio_dots100.pdf", width: 17cm)]


== Difference between proportions (probability and MCSE)

Probability (and corresponding MCSE) that oddsratio$<1$


```r
> draws |>
    mutate_variables(p_oddsratio_lt_1 =
                     as.numeric(oddsratio<1)) |>
    subset_draws("p_oddsratio_lt_1") |>
    summarise_draws(prob=mean, MCSE=mcse_mean)
```
#v(1cm)
```
  variable            prob    MCSE
  p_oddsratio_lt_1    0.99  0.0023
```


== Posterior object formats

Default is `draws_array`

```r
> fit_bin2$draws()
```
#v(1cm)
```
# A draws_array: 1000 iterations, 4 chains, and 4 variables
, , variable = lp__

         chain
iteration    1    2    3    4
        1 -253 -253 -254 -253
        2 -253 -253 -255 -252
        3 -254 -252 -254 -253
        4 -255 -253 -254 -254
        5 -253 -253 -253 -253
, , variable = theta1
         chain
iteration     1     2     3     4
        1 0.054 0.052 0.045 0.049
        2 0.062 0.060 0.070 0.058
...
```


== Posterior object formats

`draws_df` looks prettier and works with `ggplot()`


```r
> fit_bin2$draws(format ="df")
```
#v(1cm)
```
# A draws_df: 1000 iterations, 4 chains, and 4 variables
   lp__ theta1 theta2 oddsratio
1  -253  0.054  0.033      0.59
2  -253  0.062  0.035      0.55
3  -254  0.047  0.026      0.54
4  -255  0.049  0.049      0.99
5  -253  0.068  0.035      0.50
6  -253  0.056  0.027      0.47
7  -253  0.071  0.031      0.43
8  -253  0.049  0.036      0.72
9  -253  0.049  0.036      0.72
10 -253  0.063  0.026      0.39
# ... with 3990 more draws
# ... hidden reserved variables {'.chain', '.iteration', '.draw'}
```



== posterior object formats

`draws_rvar` makes it easy to compute derived quantities

#m.steps.replace(
  text(size: 18pt)[
```r
> as_draws_rvars(fit_bin2$draws())
```
```
# A draws_rvars: 1000 iterations, 4 chains, and 4 variables
$lp__: rvar<1000,4>[1] mean ± sd:
[1] -253 ± 1 

$theta1: rvar<1000,4>[1] mean ± sd:
[1] 0.059 ± 0.0093 

$theta2: rvar<1000,4>[1] mean ± sd:
[1] 0.034 ± 0.0069 

$oddsratio: rvar<1000,4>[1] mean ± sd:
[1] 0.57 ± 0.16
```
  ],
  text(size: 18pt)[
```r
> as_draws_rvars(fit_bin2$draws())
```
```
# A draws_rvars: 1000 iterations, 4 chains, and 4 variables
$lp__: rvar<1000,4>[1] mean ± sd:
[1] -253 ± 1 

$theta1: rvar<1000,4>[1] mean ± sd:
[1] 0.059 ± 0.0093 

$theta2: rvar<1000,4>[1] mean ± sd:
[1] 0.034 ± 0.0069 

$oddsratio: rvar<1000,4>[1] mean ± sd:
[1] 0.57 ± 0.16
```
```r
> with(draws, (theta2/(1-theta2))/(theta1/(1-theta1)))
```
```
rvar<1000,4>[1] mean ± sd:
[1] 0.5689 ± 0.1577 
```
  ],
  text(size: 18pt)[
```r
> as_draws_rvars(fit_bin2$draws())
```
```
# A draws_rvars: 1000 iterations, 4 chains, and 4 variables
$lp__: rvar<1000,4>[1] mean ± sd:
[1] -253 ± 1 

$theta1: rvar<1000,4>[1] mean ± sd:
[1] 0.059 ± 0.0093 

$theta2: rvar<1000,4>[1] mean ± sd:
[1] 0.034 ± 0.0069 

$oddsratio: rvar<1000,4>[1] mean ± sd:
[1] 0.57 ± 0.16
```
```r
> with(draws, (theta2/(1-theta2))/(theta1/(1-theta1)))
```
```
rvar<1000,4>[1] mean ± sd:
[1] 0.5689 ± 0.1577 
```
```r
> draws$oddsratio<1
```
```
rvar<1000,4>[1] mean ± sd:
[1] 0.9865 ± 0.1154 
```
  ],
)


== Kilpisjärvi summer temperature

- Temperature at Kilpisjärvi in June, July and August from 1952 to 2013
- Is the summer temperature changing?

#align(center)[#image("figs/kilpis_data.pdf", width: 17cm)]


== Normal linear model

```stan
data {
    int<lower=0> N;        // number of observations
    vector[N] x;           // years
    vector[N] y;           // temperatures
}
parameters {
    real alpha;            // intercept
    real beta;             // slope
    real<lower=0> sigma;   // observation model sd
}
transformed parameters {
    vector[N] mu;
    mu = alpha + beta*x;  // linear model
}
model {
    y ~ normal(mu, sigma); // observation model
}
```

== Normal linear model

#text(size: 18pt)[
```stan
data {
    int<lower=0> N;        // number of observations
    vector[N] x; 
    vector[N] y;  
}
```
]

- difference between `vector[N] x` and `array[N] real x`
- only integer arrays: `array[N] int x`


== Normal linear model

#text(size: 18pt)[
```stan
parameters {
    real alpha;            // intercept
    real beta;             // slope
    real<lower=0> sigma;   // observation model sd
}
transformed parameters {
    vector[N] mu;
    mu = alpha + beta*x;  // linear model
}
```
]

- transformed parameters are deterministic transformations of parameters and data


== Student-$t$ linear model

#text(size: 18pt)[
```stan
...
parameters {
  real alpha; 
  real beta; 
  real<lower=0> sigma;
  real<lower=1,upper=80> nu;
}
transformed parameters {
  vector[N] mu;
  mu = alpha + beta*x;
}
model {
  nu ~ gamma(2, 0.1);             // prior for nu
  y ~ student_t(nu, mu, sigma);  // observation model
}
```
]


== Priors for normal linear model

#text(size: 16pt)[
```stan
data {
    int<lower=0> N; // number of observations 
    vector[N] x; // 
    vector[N] y; // 
    real pmualpha; // prior mean for alpha
    real psalpha;  // prior std for alpha
    real pmubeta;  // prior mean for beta
    real psbeta;   // prior std for beta
}
...
transformed parameters {
    vector[N] mu;
    mu = alpha + beta*x;
}
model {
    alpha ~ normal(pmualpha, psalpha); // prior for alpha
    beta ~ normal(pmubeta, psbeta);    // prior for beta
    y ~ normal(mu, sigma);             // observation model
}
```
]


== Kilpisjärvi summer temperature

Posterior fit

#align(center)[#image("figs/kilpis_lin_pfit.pdf", width: 18cm)]


== Kilpisjärvi summer temperature

Posterior draws of alpha and beta

#align(center)[#image("figs/kilpis_lin_mcmc_scatter.pdf", width: 18cm)]

#text(size: 12pt)[
```r
Warning: 1 of 4000 (0.0%) transitions hit the maximum treedepth limit of 10.
See https://mc-stan.org/misc/warnings for details.
```
]

Hitting maximum treedepth (maximum number of steps) does not invalidate results, but indicates inefficient sampling


== Kilpisjärvi summer temperature

Posterior draws of alpha and beta when data is centered

#align(center)[#image("figs/kilpis_lin_std_mcmc_scatter.pdf", width: 18cm)]


== Kilpisjärvi summer temperature

Without centering

#text(size: 16pt)[
```r
> fit_lin$summary(variables=c("alpha","beta"),
                  default_convergence_measures())
```
```
  variable    rhat ess_bulk ess_tail
  alpha        1.0     919.     897.
  beta         1.0     919.     895.
```
]

With centering

#text(size: 16pt)[
```r
> fit_lin_std$summary(variables=c("alpha","beta"),
                      default_convergence_measures())
```
```
  variable    rhat ess_bulk ess_tail
  alpha        1.0    3872.    2616.
  beta         1.0    3770.    2396.
```
]


== RStanARM

- `RStanARM` provides simplified model description with pre-compiled models
  - no need to wait for compilation
  - a restricted set of models

Two group Binomial model:

#text(size: 16pt)[
```r
d_bin2 <- data.frame(N = c(674, 680), y = c(39,22), grp2 = c(0,1))
fit_bin2 <- stan_glm(y/N ~ grp2,
                     weights = N,
                     family = binomial(),
                     data = d_bin2)
```
]


== RStanARM

- `RStanARM` provides simplified model description with pre-compiled models
  - no need to wait for compilation
  - a restricted set of models

Two group Binomial model:

#text(size: 18pt)[
```r
d_bin2 <- data.frame(N = c(674, 680), y = c(39,22), grp2 = c(0,1))
fit_bin2 <- stan_glm(y/N ~ grp2,
                     weights = N,
                     family = binomial(),
                     data = d_bin2)
```
]

Normal linear model

#text(size: 18pt)[
```r
    fit_lin <- stan_glm(temp ~ year,
                        data = d_lin)
```
]


== brms

- `brms` provides simplified model description
  - [+] a larger set of models than `RStanARM`, but still restricted
  - [-] need to wait for the compilation

#text(size: 18pt)[
```r
fit_bin2 <- brm(y | trials(N) ~ grp2,
                family = binomial(),
                data = d_bin2)

fit_lin_t <- brm(temp ~ year,
                 family = student(),
                 data = d_lin)
```
]


== Extreme value analysis

- Stan is extensible
  - you can define your own probability distributions and functions

- Geomagnetic storms example

#align(center)[#image("figs/stan_gpareto_geomev.png", width: 18cm)]


== Extreme value analysis

```stan
data {
  int<lower=0> N;
  vector<lower=0>[N] y;
  int<lower=0> Nt;
  vector<lower=0>[Nt] yt;
}
transformed data {
  real ymax = max(y);        // pre-compute a useful quantity
}
parameters {
  real<lower=0> sigma; 
  real<lower=-sigma/ymax> k; // constraint can depend on other parameters
}
model {
  y ~ gpareto(k, sigma);     // user defined distribution
}
generated quantities {
  vector[Nt] predccdf = gpareto_ccdf(yt, k, sigma);
}
```


== User defined functions

```stan
functions {
  real gpareto_lpdf(vector y, real k, real sigma) {
    // generalised Pareto log pdf with mu=0
    // should check and give error if k<0 
    // and max(y)/sigma > -1/k
    int N;
    N <- dims(y)[1];
    if (abs(k) > 1e-15)
      return -(1+1/k)*sum(log1pv(y*k/sigma)) -N*log(sigma);
    else
      return -sum(y/sigma) -N*log(sigma); // limit k->0
  }
  vector gpareto_ccdf(vector y, real k, real sigma) {
    // generalised Pareto log ccdf with mu=0
    // should check and give error if k<0 
    // and max(y)/sigma < -1/k
    if (abs(k) > 1e-15)
      return exp((-1/k)*log1pv(y/sigma*k));
    else
      return exp(-y/sigma); // limit k->0
  }
}
```

== Different interfaces

- `CmdStanR` / `CmdStanPy`
  - Interface on top of command-line program CmdStan
- `RStan` / `PyStan` (deprecated)
  - C++ functions of Stan are called directly from R / Python
  - Higher integration between R/Python and Stan, but maybe more difficult to install due to more requirements of compatible C++ compilers and libraries



== Other packages

- R
  - `posterior`: posterior handling and diagnostics (Lectures 5 and 6)
  - `bayesplot` and `tidybayes`: visualization and model checking (Lectures 5, 6, and 8)
  - `loo`: cross-validation model assessment and comparison (Lecture 9)
  - `priorsense`: prior and likelihood sensitivity diagnostics (Lecture 12)
  - `projpred`: projection predictive variable selection (Lecture 12)
  - `brms`: interface to fit Bayesian generalized (non-)linear multivariate multilevel models using Stan (Lecture 7)
  - `marginaleffects`: prediction and comparison visualization
  #v(0.5cm)
- Python
  - `ArviZ`: visualization, and model checking and assessment
  - `Kulprit`: projection predictive variable selection
  - `Bambi`: interface to fit Bayesian generalized (non-)linear multivariate multilevel models using PyMC



== Extra material for HMC / NUTS

- An introduction for applied users with good visualizations:
  Monnahan, Thorson, and Branch (2016) Faster estimation of Bayesian models in ecology using Hamiltonian Monte Carlo. #link("https://dx.doi.org/10.1111/2041-210X.12681")
- A technical review of why HMC works:
  Neal (2012). MCMC using Hamiltonian dynamics. #link("https://arxiv.org/abs/1206.1901")
- The No-U-Turn Sampler:
  Hoffman and Gelman (2014). The No-U-Turn Sampler: Adaptively Setting Path Lengths in Hamiltonian Monte Carlo. #link("https://jmlr.csail.mit.edu/papers/v15/hoffman14a.html")
- Multinomial variant of NUTS:
  Betancourt (2018). A Conceptual Introduction to Hamiltonian Monte Carlo. #link("https://arxiv.org/abs/1701.02434")
- Seyboldt (2026). Preconditioning Hamiltonian Monte Carlo by minimizing Fisher Divergence. #link("https://arxiv.org/abs/2603.18845v1")



// // == Extra material for Stan

// // - Gelman, Lee, and Guo (2015) Stan: A probabilistic programming language for Bayesian inference and optimization. #link("http://www.stat.columbia.edu/~gelman/research/published/stan_jebs_2.pdf")
// // - Carpenter et al (2017). Stan: A probabilistic programming language. Journal of Statistical Software 76(1). #link("https://dox.doi.org/10.18637/jss.v076.i01")
// // - Stan User's Guide, Language Reference Manual, and Language Function Reference (in html and pdf) #link("https://mc-stan.org/users/documentation/")
// //   - easiest to start from Example Models in User's guide
// // - Basics of Bayesian inference and Stan, part 1 Jonah Gabry & Lauren Kennedy (StanCon 2019 Helsinki tutorial)
// //   - #link("https://www.youtube.com/watch?v=ZRpo41l02KQ&index=6&list=PLuwyh42iHquU4hUBQs20hkBsKSMrp6H0J")
// //   - #link("https://www.youtube.com/watch?v=6cc4N1vT8pk&index=7&list=PLuwyh42iHquU4hUBQs20hkBsKSMrp6H0J")


// // == Chapter 12 demos

// // - demo12\_1: HMC
// // - #link("https://chi-feng.github.io/mcmc-demo/")
// // - #link("http://elevanth.org/blog/2017/11/28/build-a-better-markov-chain/")
// // - cmdstanr\_demo, rstan\_demo
// // - #link("http://sumsar.net/blog/2017/01/bayesian-computation-with-stan-and-farmer-jons/")
// // - #link("http://mc-stan.org/documentation/case-studies.html")
// // - #link("https://mc-stan.org/cmdstanr/")
// // - #link("https://mc-stan.org/rstan/")





// == Simulating Hamilton's equations

// - Except for toy cases, we cannot solve the equations analytically, so we need to approximate the trajectory as a sequence of discrete steps.
// - Naive approach, the *Euler method*:
//   $ theta arrow.l theta + epsilon M^(-1) phi, quad quad phi arrow.l phi - epsilon nabla U(theta) $
// - Problem: errors accumulate systematically
//   - Energy drifts, so the numerical orbit spirals outwards instead of closing
//   - Not volume preserving, so we would need a Jacobian correction (and even this could be unstable for long trajectories)
// - We need an integrator that behaves like the true dynamics: *reversible* and *volume preserving*, with energy error that stays bounded

// // FIGURE: harmonic oscillator in phase space, exact orbit (circle) vs Euler (spiral out) vs leapfrog (close to circle)

// == Leapfrog discretization

// - One leapfrog step of size $epsilon$: half step for momentum, full step for position, half step for momentum

// $ phi_(t+epsilon/2) &= phi_t - epsilon/2 nabla U(theta_t) \
//   theta_(t+epsilon) &= theta_t + epsilon M^(-1) phi_(t+epsilon/2) \
//   phi_(t+epsilon) &= phi_(t+epsilon/2) - epsilon/2 nabla U(theta_(t+epsilon)) $

// - Repeat for $L$ steps to get the proposal $(theta^*, phi^*)$
//   - Consecutive half steps can be merged, so each step costs only *one new gradient* evaluation
// - Why it works so well:
//   - Preserves volume (Jacobian is exactly 1)
//   - Reversible
//   - Discretization error does not usually grow in time (it oscillates around the true energy; global error is $O(epsilon^2)$)
// - After $L$ steps, flip the momentum: $phi^* arrow.l -phi^*$
//   - Makes the proposal a proper involution, so the Metropolis step is valid
//   - It has no effect on acceptance, since $K(phi) = K(-phi)$, and $phi$ is resampled next iteration anyway

// #align(center)[
//   #image("figs/hmc_leapfrog.png", height: 9cm)
// ]

// #text(size: 14pt)[From Neal (2012)]

