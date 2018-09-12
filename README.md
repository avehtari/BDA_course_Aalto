# Bayesian Data Aanalysis course material

This repository has course material for Bayesian Data Analysis course at Aalto (CS-E5710)

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

## Course contents following BDA3

Bayesian Data Analysis, 3rd ed, by by Andrew Gelman, John Carlin, Hal
Stern, David Dunson, Aki Vehtari, and Donald Rubin. [Home page for the
book](http://www.stat.columbia.edu/~gelman/book/).

- Background (Ch 1)
- Single-parameter models (Ch 2)
- Multiparameter models (Ch 3)
- Computational methods (Ch 10)
- Markov chain Monte Carlo (Ch 11--12)
- Extra material for Stan and probabilistic programming
- Hierarchical models (Ch 5)
- Model checking (Ch 6)
- Evaluating and comparing models (Ch 7)
  + [extra material](https://avehtari.github.io/modelselection/)
- Decision analysis (Ch 9)
- Large sample properties and Laplace approximation (Ch 4)
- In addition you learn workflow for Bayesian data analysis

## Assessment

Exercises (67\%) and a project work (33\%). Minimum of 50\% of points
must be obtained from both the exercises and project work.

## R and Python

We recommend using R in the course as there are more packages for Stan in R. If you are already fluent in Python, but not in R, then using Python is probably easier. Unless you are already experienced and have figured out your preferred way to work with R, we recommend installing [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/).

## Demos

- [BDA_R_demos](https://github.com/avehtari/BDA_R_demos)
- [BDA_py_demos](https://github.com/avehtari/BDA_py_demos)

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
