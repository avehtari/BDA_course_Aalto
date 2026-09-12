
// == Marginalization

// - Joint distribution of parameters
//   $
//     p(mu, sigma | y) prop p(y | mu, sigma) p(mu, sigma)
//   $
// - Marginalization
//   $
//     p(mu | y) = integral p(mu, sigma | y) d sigma
//   $
//   $p(mu | y)$ is a marginal distribution
// - Analytic solution
//   - sometimes the integral has an analytic solution
// - Monte Carlo approximation
//   $
//     "if " quad (mu^(s), sigma^(s)) tilde p(mu, sigma | y)
//     quad "then " quad mu^(s) tilde p(mu | y)
//   $


// == Marginalization - predictive distribution

// Posterior predictive distribution for a future $tilde(y)$ is obtained by marginalizing the joint distribution of unknowns

// $
//   p(tilde(y) | y)
//   = integral p(tilde(y), mu, sigma | y) d mu d sigma
// $

// $
//   p(tilde(y) | y)
//   = integral p(tilde(y) | mu, sigma) p(mu, sigma | y) d mu d sigma
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_data.pdf", width: 10cm)
// ]


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postmean.pdf", width: 10cm)
// ]

// $
//   p(#redtext[$y$] | mu, sigma)
//   = 1 / (sqrt(2 pi) sigma)
//     exp(-1 / (2 sigma^2) (#redtext[$y$] - mu)^2)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postmeanmu.pdf", width: 10cm)
// ]

// $
//   p(y | #redtext[$mu$], sigma)
//   = 1 / (sqrt(2 pi) sigma)
//     exp(-1 / (2 sigma^2) (y - #redtext[$mu$])^2)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postmeanmusigma.pdf", width: 10cm)
// ]

// $
//   p(y | mu, #redtext[$sigma$])
//   = 1 / (sqrt(2 pi) #redtext[$sigma$])
//     exp(-1 / (2 #redtext[$sigma$]^2) (y - mu)^2)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postgaussiandraws.pdf", width: 10cm)
// ]

// $
//   #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postgaussianmudraws.pdf", width: 10cm)
// ]

// $
//   #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postdraws100.pdf", width: 10cm)
// ]

// $
//   #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
// $


// == Normal distribution example

// #align(center)[
//   #image("figs/fake3_postdraws.pdf", width: 10cm)
// ]

// $
//   #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
// $


// == Joint posterior

// #align(center)[
//   #image("figs/fake3_joint1b.pdf", width: 5cm)
// ]

// Joint posterior

// $
//   #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
// $

// with $p(mu, sigma^2) prop sigma^(-2)$












// == Joint posterior

// Joint posterior
// $
//       p(mu, sigma | y) prop product_(i=1)^n p(y_i | mu, sigma) times p(mu, sigma)
// $

// with $p(mu, sigma) prop sigma^(-2)$ 
// $
//   p(mu, sigma^2 | y) prop sigma^(-2) product_(i=1)^n 1/(sqrt(2 pi) sigma) exp(-1/(2 sigma^2) (y_i - mu)^2)
// $



// == Joint posterior


// Joint posterior

// $
//   p(mu, sigma^2 | y) prop sigma^(-n-2) exp(-1/(2 sigma^2) sum_(i=1)^n (y_i - mu)^2)
// $

// $
//   = sigma^(-n-2) exp(-1/(2 sigma^2) [sum_(i=1)^n (y_i - bar(y))^2 + n (bar(y) - mu)^2])
// $

// #graytext[where $bar(y) = 1/n sum_(i=1)^n y_i$]


// == Joint posterior


// Joint posterior

// $
//   = sigma^(-n-2) exp(-1/(2 sigma^2) [(n-1) s^2 + n (bar(y) - mu)^2])
// $

// #graytext[where $s^2 = 1/(n-1) sum_(i=1)^n (y_i - bar(y))^2$]


// == Normal - non-informative prior

// $
//   sum_(i=1)^n (y_i - mu)^2
// $

// $
//   = sum_(i=1)^n (y_i^2 - 2 y_i mu + mu^2)
// $

// $
//   = sum_(i=1)^n (y_i^2 - 2 y_i mu + mu^2 - bar(y)^2 + bar(y)^2 - 2 y_i bar(y) + 2 y_i bar(y))
// $

// $
//   = sum_(i=1)^n (y_i^2 - 2 y_i bar(y) + bar(y)^2) + sum_(i=1)^n (mu^2 - 2 y_i mu - bar(y)^2 + 2 y_i bar(y))
// $

// $
//   = sum_(i=1)^n (y_i - bar(y))^2 + n (mu^2 - 2 bar(y) mu - bar(y)^2 + 2 bar(y) bar(y))
// $

// $
//   = sum_(i=1)^n (y_i - bar(y))^2 + n (bar(y) - mu)^2
// $








// == Marginals

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint1.pdf", width: 5cm)

//     $
//       #bluetext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
//     $
//   ],
//   [
//     #image("figs/fake3_marginalmu.pdf", width: 5cm)

//     marginals

//     $p(mu | y) = integral p(mu, sigma | y) d sigma$
//   ],
// )

// #image("figs/fake3_marginalsigma.pdf", width: 5cm)

// $p(sigma | y) = integral p(mu, sigma | y) d mu$

// == Marginal posterior $p(sigma^2 | y)$

// #navytext[Marginal posterior $p(sigma^2 | y)$ (easier for $sigma^2$ than $sigma$)]

// $
//   p(sigma^2 | y) prop integral p(mu, sigma^2 | y) d mu
// $

// $
//   prop integral sigma^(-n-2) exp(-1/(2 sigma^2) [(n-1) s^2 + n (overline(y) - mu)^2]) d mu
// $

// $
//   prop sigma^(-n-2) exp(-1/(2 sigma^2) (n-1) s^2)
//   integral exp(-n/(2 sigma^2) (overline(y) - mu)^2) d mu
// $

// #graytext[$integral 1/(sqrt(2 pi) sigma) exp(-1/(2 sigma^2) (y - theta)^2) d theta = 1$]

// $
//   prop sigma^(-n-2) exp(-1/(2 sigma^2) (n-1) s^2) sqrt(2 pi sigma^2 / n)
// $

// $
//   prop (sigma^2)^(-(n+1)/2) exp(-((n-1) s^2) / (2 sigma^2))
// $

// $p(sigma^2 | y) = "Inv-"chi^2(sigma^2 | n-1, s^2)$


// == Normal - non-informative prior

// Known mean

// $
//   sigma^2 | y tilde "Inv-"chi^2(n, v)
//   quad "where" quad v = 1/n sum_(i=1)^n (y_i - theta)^2
// $

// Unknown mean

// $
//   sigma^2 | y tilde "Inv-"chi^2(n-1, s^2)
//   quad "where" quad s^2 = 1/(n-1) sum_(i=1)^n (y_i - overline(y))^2
// $


// == Factorization

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint2.pdf", width: 5cm)

//     #image("figs/fake3_marginalsigma2.pdf", width: 5cm)
//   ],
//   [
//     Factorization

//     $
//       p(mu, sigma^2 | y)
//       = #greentext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #bluetext[$p(sigma^2 | y)$] = "Inv-"chi^2(sigma^2 | n-1, s^2)
//     $

//     $
//       (sigma^2)^(s) tilde #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #greentext[$p(mu | sigma^2, y)$] = N(mu | overline(y), sigma^2/n)
//     $
//   ],
// )


// == Factorization

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint2.pdf", width: 5cm)

//     #image("figs/fake3_marginalsigma2.pdf", width: 5cm)
//   ],
//   [
//     Factorization

//     $
//       p(mu, sigma^2 | y)
//       = #greentext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       (sigma^2)^(s) tilde #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #greentext[$p(mu | (sigma^2)^(s), y)$] = N(mu | overline(y), (sigma^2)^(s)/n)
//     $
//   ],
// )


// == Factorization

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint2.pdf", width: 5cm)

//     #image("figs/fake3_condsmu.pdf", width: 5cm)
//   ],
//   [
//     Factorization

//     $
//       p(mu, sigma^2 | y)
//       = #greentext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       (sigma^2)^(s) tilde #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #greentext[$p(mu | (sigma^2)^(s), y)$] = N(mu | overline(y), (sigma^2)^(s)/n)
//     $
//   ],
// )


// == Factorization

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint2.pdf", width: 5cm)

//     #image("figs/fake3_condsmumean.pdf", width: 5cm)
//   ],
//   [
//     Factorization

//     $
//       p(mu, sigma^2 | y)
//       = #greentext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       (sigma^2)^(s) tilde #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #greentext[$p(mu | (sigma^2)^(s), y)$] = N(mu | overline(y), (sigma^2)^(s)/n)
//     $

//     $
//       p(mu | y) approx #orangetext[$1/S sum_(s=1)^S N(mu | overline(y), (sigma^2)^(s)/n)$]
//     $
//   ],
// )


// == Factorization

// #grid(
//   columns: 2,
//   [
//     #image("figs/fake3_joint2.pdf", width: 5cm)

//     #image("figs/fake3_marginalmu2.pdf", width: 5cm)
//   ],
//   [
//     Factorization

//     $
//       p(mu, sigma^2 | y)
//       = #greentext[$p(mu | sigma^2, y)$] #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       (sigma^2)^(s) tilde #bluetext[$p(sigma^2 | y)$]
//     $

//     $
//       #greentext[$p(mu | (sigma^2)^(s), y)$] = N(mu | overline(y), (sigma^2)^(s)/n)
//     $

//     $
//       p(mu | y) approx #orangetext[$1/S sum_(s=1)^S N(mu | overline(y), (sigma^2)^(s)/n)$]
//     $
//   ],
// )


// == Marginal posterior $p(mu | y)$

// $
//   p(mu | y)
//   = integral_0^infinity p(mu, sigma^2 | y) d sigma^2
// $

// $
//   prop integral_0^infinity sigma^(-n-2) exp(-1/(2 sigma^2) [(n-1) s^2 + n (overline(y) - mu)^2]) d sigma^2
// $

// Transformation

// $A = (n-1) s^2 + n (mu - overline(y))^2 quad "and" quad z = A / (2 sigma^2)$

// $
//   p(mu | y) prop A^(-n/2) integral_0^infinity z^((n-2)/2) exp(-z) d z
// $

// #graytext[Recognize gamma integral $Gamma(u) = integral_0^infinity x^(u-1) exp(-x) d x$]

// $
//   prop [(n-1) s^2 + n (mu - overline(y)^2]^(-n/2)
// $

// $
//   prop [1 + (n (mu - overline(y))^2) / ((n-1) s^2)]^(-n/2)
// $

// $p(mu | y) = t_(n-1)(mu | overline(y), s^2/n)$ #graytext[Student's $t$]







// == Predictive distribution for new $tilde(y)$

// #grid(
//   columns: 2,
//   [
//     Factorization

//     $
//       p(tilde(y) | y)
//       = integral p(tilde(y) | mu, sigma) p(mu, sigma | y) d mu d sigma
//     $

//     $
//       #redtext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
//     $

//     $
//       #redtext[$tilde(y)^(s)$] tilde #bluetext[$p(tilde(y) | mu^(s), sigma^(s))$]
//     $
//   ],
//   [
//     #image("figs/fake3_pred1.pdf", width: 5cm)
//   ],
// )


// == Predictive distribution for new $tilde(y)$

// #grid(
//   columns: 2,
//   [
//     Factorization

//     $
//       p(tilde(y) | y)
//       = integral p(tilde(y) | mu, sigma) p(mu, sigma | y) d mu d sigma
//     $

//     $
//       #redtext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
//     $

//     $
//       #redtext[$tilde(y)^(s)$] tilde #bluetext[$p(tilde(y) | mu^(s), sigma^(s))$]
//     $
//   ],
//   [
//     #image("figs/fake3_pred1s.pdf", width: 5cm)
//   ],
// )


// == Predictive distribution for new $tilde(y)$

// #grid(
//   columns: 2,
//   [
//     Factorization

//     $
//       p(tilde(y) | y)
//       = integral p(tilde(y) | mu, sigma) p(mu, sigma | y) d mu d sigma
//     $

//     $
//       #redtext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
//     $

//     $
//       #redtext[$tilde(y)^(s)$] tilde #bluetext[$p(tilde(y) | mu^(s), sigma^(s))$]
//     $
//   ],
//   [
//     #image("figs/fake3_pred1ss.pdf", width: 5cm)
//   ],
// )


// == Predictive distribution for new $tilde(y)$

// #grid(
//   columns: 2,
//   [
//     Factorization

//     $
//       #orangetext[$p(tilde(y) | y)$]
//       = integral p(tilde(y) | mu, sigma) p(mu, sigma | y) d mu d sigma
//     $

//     $
//       #redtext[$mu^(s), sigma^(s)$] tilde p(mu, sigma | y)
//     $

//     $
//       #redtext[$tilde(y)^(s)$] tilde #bluetext[$p(tilde(y) | mu^(s), sigma^(s))$]
//     $
//   ],
//   [
//     #image("figs/fake3_pred1ss_exact.pdf", width: 5cm)
//   ],
// )


// == Normal - posterior predictive distribution

// Posterior predictive distribution given known variance

// $
//   p(tilde(y) | sigma^2, y)
//   = integral p(tilde(y) | mu, sigma^2) p(mu | sigma^2, y) d mu
// $

// $
//   = integral N(tilde(y) | mu, sigma^2) N(mu | overline(y), sigma^2/n) d mu
// $

// $
//   = N(tilde(y) | overline(y), (1 + 1/n) sigma^2)
// $

// this is up to scaling factor same as $p(mu | sigma^2, y)$

// $
//   p(tilde(y) | y) = t_(n-1)(tilde(y) | overline(y), (1 + 1/n) s^2)
// $


// == Normal - conjugate prior

// - Conjugate prior has to have a form $p(sigma^2) p(mu | sigma^2)$ (see the chapter notes)

// - Handy parameterization
//   $
//     mu | sigma^2 tilde N(mu_0, sigma^2/kappa_0)
//   $
//   $
//     sigma^2 tilde "Inv-"chi^2(nu_0, sigma_0^2)
//   $
//   which can be written as
//   $
//     p(mu, sigma^2) = "N-Inv-"chi^2(mu_0, sigma_0^2/kappa_0; nu_0, sigma_0^2)
//   $

// - $mu$ and $sigma^2$ are a priori dependent
//   - if $sigma^2$ is large, then $mu$ has wide prior


// == Normal - conjugate prior

// Joint posterior (exercise 3.9)

// $
//   p(mu, sigma^2 | y) = "N-Inv-"chi^2(mu_n, sigma_n^2/kappa_n; nu_n, sigma_n^2)
// $

// where

// $
//   mu_n = kappa_0 / (kappa_0 + n) mu_0 + n / (kappa_0 + n) overline(y)
// $

// $
//   kappa_n = kappa_0 + n
// $

// $
//   nu_n = nu_0 + n
// $

// $
//   nu_n sigma_n^2 = nu_0 sigma_0^2 + (n-1) s^2 + (kappa_0 n) / (kappa_0 + n) (overline(y) - mu_0)^2
// $





// == Example of uncertainty in modeling

// #v(1cm)
// #align(center)[
//   #m.steps.replace(
//     image("figs/fakel_data.pdf"),
//     image("figs/fakel_postmean.pdf", width: 15cm),
//     image("figs/fakel_postmeanpred.pdf", width: 15cm),
//     image("figs/fakel_postdraws.pdf", width: 15cm),
//     image("figs/fakel_postdrawspred.pdf", width: 15cm),
//   )
// ]











// == Normal linear regression

// - $y_i tilde N(alpha + beta x_i, sigma^2), quad i = 1, dots, N$
// - with normal fixed scale prior on $alpha$ and $beta$, and known $sigma^2$ the posterior is multivariate normal
// - with unknown $sigma^2$, the posterior is multivariate $"N-Inv-"chi^2$
// - with unknown prior scales and $sigma^2$, numerical integration needed
// - more in BDA3 Chapter 14 (not part of the course) and Regression and Other Stories book


// == Multivariate normal

// - Observation model
//   $
//     p(y | mu, Sigma) prop |Sigma|^(-1/2)
//     exp(-1/2 (y - mu)^T Sigma^(-1) (y - mu))
//   $
// - BDA3 p. 72--
// - Recommended LKJ-prior mentioned in Appendix A, see more in Stan manual
// - Gaussian process and Gaussian Markov random field models are in practice computed with multivariate normals
//   - GPs in BDA3 Chapter 21, and a course in spring
//   - GPs and GMRFs often used also as priors for latent functions and combined with non-normal observation models


// == Paper helicopter flight time

// $
//   y tilde "normal"(f, sigma)
//   quad f tilde "GP"(0, K(x, theta))
// $
// #v(2em)
// #align(center)[
//   #image("figs/helicopter_time_bfit1s.pdf", width: 20cm)
// ]


// == Paper helicopter flight time

// $
//   y tilde "normal"(f, sigma)
//   quad f tilde "GP"(0, K_f(x, theta_f))
// $
// $
//   log(sigma) tilde "GP"(0, K_g(x, theta_g))
// $

// #align(center)[
//   #image("figs/helicopter_time_bfit1sh.pdf", width: 20cm)
// ]


// == Scale mixture of normals

// - Many useful distributions can be presented as scale mixture of normals, e.g.
//   - Student's $t$
//   - Cauchy
//   - Double exponential aka Laplace
//   - Horseshoe
//   - R2-D2


// == Multinomial model for categorical data

// - Extension of binomial
// - Observation model
//   $
//     p(y | theta) prop product_(j=1)^k theta_j^(y_j)
//   $
// - BDA3 p. 69--







// == Monte Carlo and posterior draws

// In Bayesian analysis we often need
// $
//   E_(p(theta | y))[g(theta)] = integral g(theta) p(theta | y) d theta
// $
// or tail probabilities like $p(theta <= c | y)$.

// For most real models $p(theta | y)$ has no closed form, so these
// integrals can't be solved analytically.

// #graytext[We'll build intuition on a case we _can_ solve exactly: a
// 1-D normal.]



// == Monte Carlo and posterior draws

// Density $p(theta | mu, sigma) = 1/(sqrt(2 pi) sigma) exp(-1/(2 sigma^2) (theta - mu)^2)$ #graytext[(#text(`dnorm()`))]

// #align(center)[
//   #image("figs/norm1d_1.pdf", width: 10cm)
// ]


// == Monte Carlo and posterior draws

// Density $p(theta | mu, sigma) = 1/(sqrt(2 pi) sigma) exp(-1/(2 sigma^2) (theta - mu)^2)$ #graytext[(#text(`dnorm()`))]

// #align(center)[
//   #image("figs/norm1d_1.pdf", width: 10cm)
// ]

// $E(theta) = integral theta p(theta | mu, sigma) d theta = mu$


// == Monte Carlo and posterior draws

// Density $p(theta | mu, sigma) = 1/(sqrt(2 pi) sigma) exp(-1/(2 sigma^2) (theta - mu)^2)$

// #align(center)[
//   #image("figs/norm1d_1b.pdf", width: 10cm)
// ]

// $p(theta <= 0) = integral_(-infinity)^0 p(theta | mu, sigma) d theta$, many numerical approximations #graytext[(pnorm())]


// == Monte Carlo and posterior draws

// Numerical (grid) integration: evaluate in finite number of locations #graytext[(dnorm())] $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_2.pdf", width: 10cm)
// ]


// == Monte Carlo and posterior draws

// Here evaluated in grid with bin width 0.5 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_2.pdf", width: 10cm)
// ]


// == Monte Carlo and posterior draws

// Here evaluated in grid with bin width 0.5 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_3.pdf", width: 10cm)
// ]

// $E(theta) = integral theta p(theta) d theta approx sum_s^S theta^(s) w_s approx 1$, where $w_s = 0.5 p(theta)$


// == Monte Carlo and posterior draws

// Here evaluated in grid with bin width 0.5 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_3b.pdf", width: 10cm)
// ]

// $p(theta <= 0) = integral_(-infinity)^0 p(theta) d theta approx sum_s^S I(theta^(s) <= 0) w_s approx 0.22$


// == Monte Carlo and posterior draws

// Here evaluated in grid with bin width 0.1 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_4.pdf", width: 10cm)
// ]


// == Monte Carlo and posterior draws

// Histogram of 200 random draws (#text(`rnorm()`)), bin width 0.5 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_5.pdf", width: 10cm)
// ]


// == Monte Carlo and posterior draws

// Histogram of 200 random draws (#text(`rnorm()`)), bin width 0.1 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_6.pdf", width: 10cm)
// ]

// == From grid to samples

// As the grid gets finer, each bin holds either 0 or 1 evaluation
// points, each with a small, roughly equal weight.

// This is structurally the same as: draw $theta^(s) tilde p(theta | y)$
// at random, and give each draw equal weight $1/S$.

// Random draws are just an infinitely fine, randomly placed grid —
// but one that doesn't need a grid.


// == Monte Carlo and posterior draws

// Histogram of 200 random draws (#text(`rnorm()`)), bin width 0 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_7.pdf", width: 10cm)
// ]

// each bin has either 0 or 1 draw (and 0's can be ignored)


// == Monte Carlo and posterior draws

// Histogram of 200 random draws (#text(`rnorm()`)), bin width 0 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_7.pdf", width: 10cm)
// ]

// each bin with 1 draw has weight $1/S$


// == Monte Carlo and posterior draws

// Histogram of 200 random draws (#text(`rnorm()`)), bin width 0 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_7.pdf", width: 10cm)
// ]

// $E(theta) approx 1/S sum_s^S theta^(s) approx 1$, Monte Carlo estimate


// == Monte Carlo and posterior draws

// Histogram of 200 random draws, bin width 0 $1/(sqrt(2 pi) sigma)$

// #align(center)[
//   #image("figs/norm1d_7b.pdf", width: 10cm)
// ]

// $p(theta <= 0) approx 1/S sum_s^S I(theta^(s) <= 0) approx 0.14$


// == Monte Carlo and posterior draws

// - #bluetext[$theta^(s)$] draws from $p(theta | y)$ can be used
//   - for visualization
//   - to approximate expectations (integrals)
//     $
//       E_(p(theta | y))[#bluetext[$theta$]]
//       = integral #bluetext[$theta$] p(theta | y) d theta
//       approx 1/S sum_(s=1)^S #bluetext[$theta^(s)$]
//     $
//   - easy to approximate expectations of functions (push forward)
//     $
//       E_(p(theta | y))[#bluetext[$g(theta)$]]
//       = integral #bluetext[$g(theta)$] p(theta | y) d theta
//       approx 1/S sum_(s=1)^S #bluetext[$g(theta^(s))$]
//     $
// - If $p(#bluetext[$g(theta)$])$ has finite variance, then the Monte Carlo estimate is unbiased and the error approaches 0 with increasing $S$ based on the central limit theorem (CLT)
//   - more about this later

// == Monte Carlo and posterior draws
// MAYBE ADD THIS
// - If $p(#bluetext[$g(theta)$])$ has finite variance, then the Monte Carlo estimate is unbiased and the error approaches 0 with increasing $S$ based on the central limit theorem (CLT)
//   - the error rate, $O(1 slash sqrt(S))$, #bluetext[does not depend on the dimension of $theta$]
//   - a grid, by contrast, needs exponentially more points as dimension grows (curse of dimensionality)
//   - this is why Monte Carlo (and later MCMC) scales to realistic Bayesian models where grids don't





// == Grid sampling

// - Draws can be used to estimate expectations, for example
//   $
//     E[x_("LD50")] = E[-alpha/beta]
//     approx 1/S sum_(s=1)^S -alpha^(s)/beta^(s)
//   $
// - Instead of sampling, grid could be used to evaluate functions directly, for example
//   $
//     E[-alpha/beta] approx sum_(t=1)^T -alpha^(t)/beta^(t) w_"cell"^(t)
//   $
//   where $w_"cell"^(t)$ is the normalized probability of a grid cell $t$, and $alpha^(t)$ and $beta^(t)$ are center locations of grid cells
// - Grid sampling gets computationally too expensive in high dimensions