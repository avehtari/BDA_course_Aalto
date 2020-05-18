# Bayesian Data Analysis course material

This repository has course material for Bayesian Data Analysis course at Aalto (CS-E5710). Aalto students should check also [MyCourses announcements](https://mycourses.aalto.fi/mod/forum/view.php?id=448327).

The course material in the repo can be used in other courses. Text and videos licensed under CC-BY-NC 4.0. Code licensed under BSD-3.

[The electronic version of the course book
Bayesian Data Analysis, 3rd ed, by by Andrew Gelman, John Carlin, Hal
Stern, David Dunson, Aki Vehtari, and Donald Rubin](https://users.aalto.fi/~ave/BDA3.pdf) is available for non-commercial purposes. Hard copies are available from [the publisher](https://www.crcpress.com/Bayesian-Data-Analysis/Gelman-Carlin-Stern-Dunson-Vehtari-Rubin/p/book/9781439840955) and many book stores.
See also [home page for the
book](http://www.stat.columbia.edu/~gelman/book/), [errata for the
book](http://www.stat.columbia.edu/~gelman/book/errata_bda3.txt), and [chapter_notes](chapter_notes).

The material will be updated during the course. Exercise instructions and slides will be updated at latest on Monday of the corresponding week. The best way to stay updated is to clone the repo and pull before checking new material. If you don't want to learn git and can't find the Download ZIP link, click [here](https://github.com/avehtari/BDA_course_Aalto/archive/master.zip).

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

This course has been designed so that there is strong emphasis in
computational aspects of Bayesian data analysis and using the latest
computational tools.

If you find BDA3 too difficult to start with, I recommend
 - Richard McElreath's [Statistical Rethinking, 2nd ed](https://xcelab.net/rm/statistical-rethinking/) book is easier than BDA3 and the 2nd ed is excellent. Statistical Rethinking doesn't go as deep in some details, math, algorithms and programming as BDA course. Richard's lecture videos of [Statistical Rethinking: A Bayesian Course Using R and Stan](https://github.com/rmcelreath/statrethinking_winter2019) are highly recommended even if you are following BDA3.
 - For background prerequisites some students have found chapters 2, 4 and 5 in [Kruschke, "Doing Bayesian Data Analysis"](https://sites.google.com/site/doingbayesiandataanalysis/) useful.
 - Michael Betancourt has a different point of view in his [introduction material](https://betanalpha.github.io/writing/), and many have found these also enlightening. Furthermore, his [Hamiltonian Monte Carlo videos](https://betanalpha.github.io/speaking/) are highly recommended if you are taking this course.

## Course contents following BDA3

Bayesian Data Analysis, 3rd ed, by by Andrew Gelman, John Carlin, Hal
Stern, David Dunson, Aki Vehtari, and Donald Rubin. [Home page for the
book](http://www.stat.columbia.edu/~gelman/book/). [Errata for the
book](http://www.stat.columbia.edu/~gelman/book/errata_bda3.txt). [Electronic edition for non-commercial purposes only](https://users.aalto.fi/~ave/BDA3.pdf).

- Background (Ch 1, Lecture 1)
- Single-parameter models (Ch 2, Lecture 2)
- Multiparameter models (Ch 3, Lecture 3)
- Computational methods (Ch 10 , Lecture 4)
- Markov chain Monte Carlo (Chs 11-12, Lectures 5-6)
- Extra material for Stan and probabilistic programming (see below, Lecture 6)
- Hierarchical models (Ch 5, Lecture 7)
- Model checking (Ch 6, Lectures 8-9)
  + [Visualization in Bayesian workflow](https://doi.org/10.1111/rssa.12378)
- Evaluating and comparing models (Ch 7)
  + [Practical Bayesian model evaluation using leave-one-out cross-validation and WAIC](http://link.springer.com/article/10.1007/s11222-016-9696-4)
  + [Videos and case studies](https://avehtari.github.io/modelselection/)
  + [Cross-validation FAQ](https://avehtari.github.io/modelselection/CV-FAQ.html)
- Decision analysis (Ch 9, Lecture 10)
- Large sample properties and Laplace approximation (Ch 4, Lecture 11-12)
- In addition you learn workflow for Bayesian data analysis

## How to study

Recommended way to go through the material is
- Read the reading instructions for a chapter in [chapter_notes](chapter_notes).
- Read the chapter in BDA3 and check that you find the terms listed in the reading instructions.
- Watch the corresponding [lecture video](https://aalto.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%22f0ec3a25-9e23-4935-873b-a9f401646812%22) to get explanations for most important parts.
- Read corresponding additional information in the [chapter notes](chapter_notes).
- Run the corresponding demos in [R demos](https://github.com/avehtari/BDA_R_demos) or 
  [Python demos](https://github.com/avehtari/BDA_py_demos).
- Read the exercise instructions and make the corresponding [exercises](exercises). Demo codes in [R demos](https://github.com/avehtari/BDA_R_demos) and 
  [Python demos](https://github.com/avehtari/BDA_py_demos) have a lot of useful examples for handling data and plotting figures. If you have problems, visit TA sessions or ask in course slack channel.
- If you want to learn more, make also self study exercises listed below

## Slides and chapter notes

- [Slides](slides)
  - including code for reproducing some of the figures
- [Chapter notes](chapter_notes)
  - including reading instructions highlighting most important parts and terms

## Videos

The following video motivates why computational probabilistic methods and probabilistic programming are important part of modern Bayesian data analysis.

- [Computational probabilistic modeling in 15mins](https://www.youtube.com/watch?v=ukE5aqdoLZI)

Short video clips on selected introductory topics are available in [a Panopto folder](https://aalto.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%22f0ec3a25-9e23-4935-873b-a9f401646812%22) and listed below.

- [1.1 Introduction to uncertainty and modelling](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=d841f429-9c3d-4d24-8228-a9f400efda7b)
- [1.2 Introduction to the course contents](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=13fc7889-cfd1-4d99-996c-a9f400f6e5a2)
- [2.1 Observation model, likelihood, posterior and binomial model](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=7a297f7d-bb7b-4dd0-9913-a9f500ec822d)
- [2.2 Predictive distribution and benefit of integration](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=75b9f18f-e379-4557-a5fa-a9f500f11b40)
- [2.3 Priors and prior information](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=099659a5-f707-473d-8b03-a9f500f39eb5)

2019 fall lecture videos are in [a Panopto folder](https://aalto.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%22f0ec3a25-9e23-4935-873b-a9f401646812%22) and listed below.

 - [Lecture 2.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=9c271082-5a8c-4b66-b6c2-aacc00fc683f) and [Lecture 2.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=70655a8a-0eb4-4ddd-9f52-aacc00fc67a2) on basics of Bayesian inference, observation model, likelihood, posterior and binomial model, predictive distribution and benefit of integration, priors and prior information, and one parameter normal model (BDA3 Ch 1+2).
 - [Lecture 3](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=ab958b4b-e2c4-4534-8305-aad100ba191f) on multiparameter models, joint, marginal and conditional distribution, normal model, bioassay example, grid sampling and grid evaluation (BDA3 Ch 3).
 - [Lecture 4.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=8a3c7bbc-e2b8-4c16-97b2-aad800ba7927) on numerical issues, Monte Carlo, how many simulation draws are needed, how many digits to report, and [Lecture 4.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=44446861-eaa2-41b5-bf33-aad800caf18a) on direct simulation, curse of dimensionality, rejection sampling, and importance sampling (BDA3 Ch 10).
 - [Lecture 5.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=098dfdb4-f3b8-46aa-b988-aadf00bd3177) on Markov chain Monte Carlo, Gibbs sampling Metropolis algorithm, and [Lecture 5.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=9f657178-d8cf-4cb8-af62-aadf00cd9423) on warm-up, convergence diagnostics, R-hat, and effective sample size (BDA3 Ch 11).
 - [Lecture 6.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=1744f6a0-84d3-4218-8a86-aae600ba7e84) on HMC, NUTS, dynamic HMC and HMC specific convergence diagnostics, and [Lecture 6.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=e60ba1a9-f752-4b0a-88c6-aae600caa61a) on probabilistic programming and Stan (BDA3 Ch 12 + extra material).
 - [Lecture 7.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=79dee6de-afa9-446f-b533-aaf400cabf2b) on hierarchical models, and [Lecture 7.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=c822561c-f95d-44fc-a1d0-aaf400d9fae3) on exchangeability (BDA3 Ch 5).
 - [Project work info](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=2820df34-d958-4c6c-93f3-aaf400dece37)
 - [Lecture 8.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=7047e366-0df6-453c-867f-aafb00ca2d78) on model checking, and [Lecture 8.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=d7849131-0afd-4ae6-ad64-aafb00da36f4) on cross-validation part 1 (BDA3 Ch 6 + extra material).
 - [Lecture 9.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=50b2e73f-af0a-4715-b627-ab0200ca7bbd) PSIS-LOO and K-fold-CV, [Lecture 9.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=b0299d53-9454-4e33-9086-ab0200db14eeb) model comparison and selection, and [Lecture 9.3](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=4b6eeb48-ae64-4860-a8c3-ab0200e40ad8) extra lecture on variable selection with projection predictive variable selection (extra material).
 - [Lecture 10.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=82943720-de0f-4195-8639-ab0900ca2085) on decision analysis (BDA3 Ch 9).
 - [Project presentation info](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=cad1e8f8-e1f0-408a-ad9d-ab0900db3977)
 - [Lecture 11.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=e22fedc7-9fd3-4d1e-8318-ab1000ca45a4) on normal approximation (Laplace approximation) and [Lecture 11.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=a8e38a95-a944-4f3d-bf95-ab1000dbdf73) on large sample theory and counter examples (BDA3 Ch 4).
 - [Lecture 12.1](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=e998b5dd-bf8e-42da-9f7c-ab1700ca2702) on frequency evaluation, hypothesis testing and variable selection and [Lecture 12.2](https://aalto.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=c43c862a-a5a4-45da-9b27-ab1700e12012) overview of modeling data collection (Ch8), linear models (Ch. 14-18), lasso, horseshoe and Gaussian processes (Ch 21).

## R and Python

We strongly recommend using R in the course as there are more packages for Stan and statistical analysis in R. If you are already fluent in Python, but not in R, then using Python may be easier, but it can still be more useful to learn also R. Unless you are already experienced and have figured out your preferred way to work with R, we recommend installing [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/). TAs will provide brief introduction to use of RStudio during the first week TA sessions. See [FAQ](FAQ.md) for frequently asked questions about R problems in this course. The demo codes linked below provide useful starting points for all the exercises. If you are interested in learning more about making nice figures in R, I recommend [Kieran Healy's "Data Visualization - A practical introduction"](https://socviz.co/).

## Demos

- [R demos](https://github.com/avehtari/BDA_R_demos)
- [Python demos](https://github.com/avehtari/BDA_py_demos)

## Assessment

[Exercises](EXERCISES.md) (67\%) and a [project work](project_work)
(33\%). Minimum of 50\% of points must be obtained from both the
exercises and project work.

## Self study exercises

Great self study exercises for this course are listed below. Most of these have also [model solutions vailable](http://www.stat.columbia.edu/~gelman/book/solutions3.pdf).

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
- [Model selection](https://avehtari.github.io/modelselection/)
- [Cross-validation FAQ](https://avehtari.github.io/modelselection/CV-FAQ.html)


## Finnish terms

Sanasta "bayesilainen" esiintyy Suomessa muutamaa erilaista
kirjoitustapaa. Muoto "bayesilainen" on muodostettu yleisen
vieraskielisten nimien taivutussääntöjen mukaan 
> "Jos nimi on kirjoitettuna takavokaalinen mutta äännettynä etuvokaalinen, kirjoitetaan päätteseen tavallisesti takavokaali etuvokaalin sijasta, esim. Birminghamissa, Thamesilla." Terho Itkonen, Kieliopas, 6. painos, Kirjayhtymä, 1997.

- [Lyhyt englanti-suomi sanasto kurssin termeistä](extra_reading/sanasto.pdf)

## Frequently Asked Questions (FAQ)

We now have an FAQ for the exercises [here](FAQ.md). Has solutions to commonly asked questions related RStudio setup, errors during package installations, etc.

## Important dates for 2019 fall

| Task | Topic | Published | Deadline | Points |
| ---- | ----- | --------- | -------- | ------ |
| [Assignment 1](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex1.pdf) | Background | 9.9 (week 37) | 15.9 at 23:59 | 3 |
| [Assignment 2](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex2.pdf) | Chapters 1 and 2 | 16.9 (week 38) | 22.9 at 23:59 | 3 |
| [Assignment 3](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex3.pdf) | Chapters 2 and 3 | 23.9 (week 39) | 29.9 at 23:59 | 9 |
| [Assignment 4](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex4.pdf) | Chapters 3 and 10 | 30.9 (week 40) | 6.10 at 23:59 | 6 |
| [Assignment 5](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex5.pdf) | Chapters 10 and 11 | 7.10 (week 41) | 13.10 at 23:59 | 6 |
| [Assignment 6](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex6.pdf) | Chapters 10-12 and Stan | 14.10 (week 42) | 27.10 at 23:59 | 6 |
| Evaluation week (21-28.10) |   |   |   |  |
| Project  | Projects introduced: form a group of 1-3 (2 is preferred) | 28.10 (week 44) | 3.11 at 23:59 | - |
| [Assignment 7](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex7.pdf) | Chapter 5 | 28.10 (week 44) | 3.11 at 23:59 | 6 |
| Project | Decide topic and start the project (no assign. on week 45) |   | 10.11 at 23:59 |  - |
| [Assignment 8](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex8.pdf) | Chapter 7 | 11.11 (week 46) | 17.11 at 23:59 | 6 |
| [Assignment 9](https://github.com/avehtari/BDA_course_Aalto/blob/master/exercises/ex9.pdf) | Chapter 9 | 18.11 (week 47) | 24.11 at 23:59 | 3 |
| Project | Finish the project work (no assign. on weeks 48 & 49) |   | 8.12 at 23:59 | 24 |
| Project presentation | Present project work during week 50 (evaluation week) |  | | |

## Acknowledgements

The course material has been greatly improved by the previous and
current course assistants (in alphabetical order): Michael Riis
Andersen, Paul Bürkner, Akash Dakar, Alejandro Catalina, Kunal Ghosh,
Joona Karjalainen, Juho Kokkala, Måns Magnusson, Janne Ojanen, Topi
Paananen, Markus Paasiniemi, Juho Piironen, Jaakko Riihimäki, Eero
Siivola, Tuomas Sivula, Teemu Säilynoja, Jarno Vanhatalo.
