#import "@preview/mosaic:0.0.1" as m

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 12],
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

== From Bayesian statistics to Bayesian workflow

- Bayesian statistics offers a coherent and flexible framework for modeling
- Traditional bottleneck: computing the posterior
- Probabilistic programming languages (Stan, PyMC, brms, bambi, Turing) make it easy to
  - specify complex models
  - run efficient inference
- But modeling is still challenging:
  - assumptions, priors, and model structure all need careful thought
  - choices depend on the specific problem and data
  - time and computational constraints matter too

== Bayesian workflow

- We need a workflow to guide the modeling process
- Three main steps:
  - model building
  - inference
  - model checking and improvement
- The steps are iterative: often simpler models to complex ones
- Goals insight and trustworthy analysis
  - better understanding of the data, assumptions, model, and conclusions
  - better tailored and justified models
  - confidence in our own analysis
  - understanding of limitations


== Bayesian workflow


#v(1cm)
#align(center)[#image("figs/workflow_simplified.png", width: 29cm)]


==


#align(center)[#image("figs/workflow_overview.pdf", width: 17cm)]


== Bayesian workflow resources

- Gelman et al. (2020), #link("https://arxiv.org/abs/2011.01808")[ArXiv Paper]
- Book free to #link("https://users.aalto.fi/~ave/Bayesian-Workflow.pdf")[download]
  - Examples in R #link("https://avehtari.github.io/Bayesian-Workflow/")[here]
  - Examples in Python #link("https://arviz-devs.github.io/bayesian-workflow/")[here]


== Project presentation overview

- Your project should be an exercise in Bayesian *workflowing*
- It should show that you can apply the concepts learned in this course
- Show and discuss the process
  - modeling decisions and why you made them
  - checks, what they revealed, and what you changed
  - limitations and open questions
- Read the project instructions: https://avehtari.github.io/BDA_course_Aalto/project.html


== Introduction

- *Title slide*: project title, your names, and contact information
  - briefly introduce yourselves
- Then one or a few slides covering:
  - the *motivation*: why is this interesting?
  - the *problem*: what question do you want to answer?
  - the *main modeling idea*: how will you approach it?
- Nice to have illustrative figures


== Description of the data

- Say where the data comes from
  - if it has been used before, mention it and briefly say how your analysis differs
- Describe what the data contains
  - number of observations, outcome variable, main predictors
  - structure, e.g. groups, repeated measurements, time
- Mention data issues and preprocessing that affect the models
  - missing values, exclusions, transformations, scaling
  - outliers: in Bayesian modeling we often prefer to model them rather than remove them


== Description of the models

- Describe *at least two* models
  - e.g., a linear regression with a negative binomial observation model, and a hierarchical version
  - e.g., a Gaussian linear model with normal vs R2D2 priors
- Make clear what each model is
  - which variables are included in each
  - highlight the differences between the models
- Showing the code and using statistical notation is encouraged, but you can also use other tools
- Tools: brms, rstanarm, Stan, PyMC, Bambi


== Brief discussion about priors

- Do not spend too much time on this section. 
- Unless you need to justify specific choices.
- You can show prior predictive checks but not mandatory.


== Inference and convergence diagnostics

- Describe the MCMC settings
  - if you changed any defaults, say which and why
- Report $hat(R)$, ESS, and divergences
  - highlight only problematic values
  - a short summary is better than showing all diagnostics, especially if they are fine
- Explain what you did to fix convergence issues


== Posterior predictive checks

- Explain what you can interpret from them
- If they showed misspecification, say what you did to improve the model
- Make sure the check matches the type of outcome and the model
  - KDEs assume a continuous outcome: bad for binary data, only usable for discrete data with many possible values
  - quantile dot plots can be useful too
  - rootograms are usually good for count data
  - calibration plots (PAV-adjusted) for binary, ordinal, and categorical outcomes
#v(1fr)
#link("https://journals.aau.dk/index.php/jovi/article/view/11478")[Recommendations for visual predictive checks in Bayesian workflow]

==  Sensitivity analysis

- You can use priorsense/ArviZ for this purpose.
- Manual checking is ok as well, in particular if you have reasons to test specific priors.


== Sensitivity analysis

- Check how much the conclusions depend on the priors (and the likelihood)
- You may use power-scaling with priorsense (R) or ArviZ (Python)
- Manual checks are fine too, especially if you have reasons to test specific priors

== Model comparison

- Compare the predictive performance of the models with an appropriate method, e.g. PSIS-LOO-CV
  - report and interpret the results, including the uncertainty in the estimates
  - report high Pareto-$hat(k)$ diagnostics
- You can use other metrics than ELPD
- Explain which model you prefer and why
  - predictive performance, interpretability, simplicity, and alignment with the modeling objectives

== Conclusion and discussion

- Go back to the original question: were you able to answer it?
- Discuss:
  - the main findings and what worked well
  - the main limitations of the analysis
  - potential improvements to the models or the analysis
- Reflect briefly on what the group learned while making the project


== Prepare and know your audience

- When possible, tailor your presentation to your audience
  - For the project presentation this is easy: focus on what we did and what we learned
- Know your material (slides and background)
- Practice that you deliver in the available time
  - Respect the audience and the other presenters
  - Better to finish early than to rush at the end
- Rehearse your delivery several times
  - Being well prepared builds confidence
  - It helps you handle unexpected situations gracefully

== Usually, less is more

- You do not have much time, so select the most relevant bits
- Highlight what matters, and make clear what does not
- The shorter the time, the cleaner the slides must be
  - simplify slides, or split them into several
  - do not show text, figures, or formulas you are not discussing
  - avoid redundancy
  - avoid math unless it really helps
- Prefer figures: they are often richer and easier to explain
- Tables are usually hard to read in a short time
- Put extra details in backup slides at the end

== Tell a story

- Use linear storytelling
  - What is the problem and why does it matter?
  - How did you explore it?
  - What did you find, and what is still open?
- Each slide should move the story forward

== Make it engaging

- You do not need to be a stand-up comedian
  - if you are not humorous or good at anecdotes, do not force it
- Memes, jokes, and funny pics are fine in moderation
- A technical audience likes technical slides

== Figures

- Make sure figures are easy to read
  - big enough fonts
  - easily distinguishable colors
  - not overcrowded
  - axes properly labeled, legends where needed

== The end

- Do not waste time on a "thank you" slide
  - it adds nothing, you can just say "thank you"
- Make the last slide the conclusion or results
  - people keep looking at your results
  - it helps them think of questions
  - it can be a hook for discussion
- Anticipate questions: you can add extra material after the conclusion


== Project report

- You can use different tools, including LaTeX, to write your project report
- One option is *Quarto*, which can combine text, code, and figures
  - one document that renders from the data to the final report
  - works with both R and Python
- Set random seeds and keep track of package versions
- Keep the output clean (see next slide)

== Control the verbosity

- Avoid long, noisy fitting output in the report
  - in Quarto, hide messages and warnings per chunk: `#| message: false`, `#| warning: false`

```r
fit <- brm(..., silent = 2, refresh = 0)
```

```python
# PyMC
idata = pm.sample(..., quiet=True)

# Bambi
idata = model.fit(..., quiet=True)
```