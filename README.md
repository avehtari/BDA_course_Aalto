# Bayesian Data Aanalysis course material

This repository has course material for Bayesian Data Analysis course at Aalto (CS-E5710). Aalto students should check also [MyCourses announcements](https://mycourses.aalto.fi/mod/forum/view.php?id=448327).

The material will be updated during the course. Exercise instructions and slides will be updated at latest on Monday of the corresponding week.

## Prerequisites

- Basic terms of probability theory
  + probability, probability density, distribution
  + sum, product rule, and Bayes' rule
  + expectation, mean, variance, median
  + in Finnish, see e.g. [Stokastiikka ja tilastollinen ajattelu](http://math.aalto.fi/~lleskela/LectureNotes003.html)
  + in English, see e.g. Wikipedia and [Introduction to probability and statistics](https://ocw.mit.edu/courses/mathematics/18-05-introduction-to-probability-and-statistics-spring-2014/readings/)
- Some algebra and calculus
- Basic visualisation techniques (R or Python)
  + histogram, density plot, scatter plot
  + see e.g. [BDA_R_demos](https://github.com/avehtari/BDA_R_demos)
  + see e.g. [BDA_py_demos](https://github.com/avehtari/BDA_py_demos)

If you find BDA3 too difficult to start with, I recommend
 - For background prerequisties, see, e.g., chapters 2, 4 and 5 in [Kruschke, "Doing Bayesian Data Analysis"](https://sites.google.com/site/doingbayesiandataanalysis/). Some of my students have found this useful.
 - Richard McElreath's [Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/) book is easier and the latest videos of [Statistical Rethinking: A Bayesian Course Using R and Stan](https://github.com/rmcelreath/statrethinking_winter2019) are highly recommended even if you are following BDA3.
 - Michael Betancourt has a different point of view in his [introduction material](https://betanalpha.github.io/writing/), and many have found these also enlightening. Furthermore, his [Hamiltonian Monte Carlo videos](https://betanalpha.github.io/speaking/) are highly recommended if you are taking this course.

## Assessment

[Exercises](EXERCISES.md) (67\%) and a [project work](project_work)
(33\%). Minimum of 50\% of points must be obtained from both the
exercises and project work.

## Course contents following BDA3

Bayesian Data Analysis, 3rd ed, by by Andrew Gelman, John Carlin, Hal
Stern, David Dunson, Aki Vehtari, and Donald Rubin. [Home page for the
book](http://www.stat.columbia.edu/~gelman/book/). [Errata for the
book](http://www.stat.columbia.edu/~gelman/book/errata_bda3.txt).

- Background (Ch 1)
- Single-parameter models (Ch 2)
- Multiparameter models (Ch 3)
- Computational methods (Ch 10)
- Markov chain Monte Carlo (Ch 11--12)
- Extra material for Stan and probabilistic programming (see below)
- Hierarchical models (Ch 5)
- Model checking (Ch 6)
  + [Visualization in Bayesian workflow](https://doi.org/10.1111/rssa.12378)
- Evaluating and comparing models (Ch 7)
  + [Practical Bayesian model evaluation using leave-one-out cross-validation and WAIC](http://link.springer.com/article/10.1007/s11222-016-9696-4)
  + [Videos and case studies](https://avehtari.github.io/modelselection/)
- Decision analysis (Ch 9)
- Large sample properties and Laplace approximation (Ch 4)
- In addition you learn workflow for Bayesian data analysis

## Slides and chapter notes

- [Slides](slides)
  - including code for reproducing some of the figures
- [Chapter notes](chapter_notes)

Text licensed under CC-BY-NC 4.0. Code licensed under BSD-3.

## Videos

Shorter video clips on selected topics are available in [a Panopto folder](https://aalto.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%22f0ec3a25-9e23-4935-873b-a9f401646812%22).

- [1.1 Introduction to uncertainty and modelling](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=d841f429-9c3d-4d24-8228-a9f400efda7b)
- [1.2 Introduction to the course contents](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=13fc7889-cfd1-4d99-996c-a9f400f6e5a2)
- [2.1 Observation model, likelihood, posterior and binomial model](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=7a297f7d-bb7b-4dd0-9913-a9f500ec822d)
- [2.2 Predictive distribution and benefit of integration](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=75b9f18f-e379-4557-a5fa-a9f500f11b40)
- [2.3 Priors and prior information](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=099659a5-f707-473d-8b03-a9f500f39eb5)

2019 fall lecture videos will appear weekly to [a Panopto folder](https://aalto.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%22f0ec3a25-9e23-4935-873b-a9f401646812%22).

 - [Lecture 2.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=9c271082-5a8c-4b66-b6c2-aacc00fc683f) and [Lecture 2.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=70655a8a-0eb4-4ddd-9f52-aacc00fc67a2) on basics of Bayesian inference, observation model, likelihood, posterior and binomial model, predictive distribution and benefit of integration, priors and prior information, and one parameter normal model.
 - [Lecture 3](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=ab958b4b-e2c4-4534-8305-aad100ba191f) on multiparameter models, joint, marginal and conditional distribution, normal model, bioassay example, grid sampling and grid evaluation.

## R and Python

We strongly recommend using R in the course as there are more packages for Stan and statistical analysis in R. If you are already fluent in Python, but not in R, then using Python may be easier, but it can still be more useful to learn also R. Unless you are already experienced and have figured out your preferred way to work with R, we recommend installing [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/). TAs will provide brief introduction to use of RStudio during the first week TA sessions.

## Demos

- [R demos](https://github.com/avehtari/BDA_R_demos)
- [Python demos](https://github.com/avehtari/BDA_py_demos)

## Self study exercises

Good self study exercises for this course are listed below. Most of these have also [model solutions vailable](http://www.stat.columbia.edu/~gelman/book/solutions3.pdf).

- 1.1-1.4, 1.6-1.8 (model solutions for 1.1-1.6)
- 2.1-2.5, 2.8, 2.9, 2.14, 2.17, 2.22 (model solutions for 2.1-2.5, 2.7-2.13, 2.16, 2.17, 2.20, and 2.14 is in slides)
- 3.2, 3.3, 3.9 (model solutions for 3.1-3.3, 3.5, 3.9, 3.10)
- 4.2, 4.4, 4.6 (model solutions for 3.2-3.4, 3.6, 3.7, 3.9, 3.10)
- 5.1, 5.2 (model solutions for 5.3-5.5, 5.7-5.12)
- 6.1 (model solutions for 6.1, 6.5-6.7)
- 9.1
- 10.1, 10.2 (model solution for 10.4)
- 11.1 (model solution for 11.1)

## Stan

- [Stan home page](http://mc-stan.org/)
- [Introductory article in Journal of Statistical Software](http://www.stat.columbia.edu/~gelman/research/published/Stan-paper-aug-2015.pdf)
- [Documentation](http://mc-stan.org/documentation/)
- [RStan installation](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)
- [PyStan installation](https://pystan.readthedocs.io/en/latest/getting_started.html)
- Basics of Bayesian inference and Stan, Jonah Gabry & Lauren Kennedy [Part 1](https://www.youtube.com/watch?v=ZRpo41l02KQ&t=8s&list=PLuwyh42iHquU4hUBQs20hkBsKSMrp6H0J&index=6) and [Part 2](https://www.youtube.com/watch?v=6cc4N1vT8pk&t=0s&list=PLuwyh42iHquU4hUBQs20hkBsKSMrp6H0J&index=7)

## Extra reading

- [Dicing with the unknown](https://doi.org/10.1111/j.1740-9713.2004.00050.x)
- [Logic, Probability, and Bayesian Inference](https://github.com/betanalpha/stan_intro/blob/master/stan_intro.pdf) by Michael Betancourt
- [Origin of word Bayesian](http://jeff560.tripod.com/b.html)


## Finnish terms

Sanasta "bayesilainen" esiintyy Suomessa muutamaa erilaista
kirjoitustapaa. Muoto "bayesilainen" on muodostettu yleisen
vieraskielisten nimien taivutussääntöjen mukaan 
> "Jos nimi on kirjoitettuna takavokaalinen mutta äännettynä etuvokaalinen, kirjoitetaan päätteseen tavallisesti takavokaali etuvokaalin sijasta, esim. Birminghamissa, Thamesilla." Terho Itkonen, Kieliopas, 6. painos, Kirjayhtymä, 1997.

- [Lyhyt englanti-suomi sanasto kurssin termeistä](extra_reading/sanasto.pdf)

## Frequently Asked Questions (FAQ)

We now have an FAQ for the exercises [here](FAQ.md). Has solutions to commonly asked questions related RStudio setup, errors during package installations, etc.
