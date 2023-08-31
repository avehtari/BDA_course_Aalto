**Installing and using `CmdStanR`:** 

See the [Stan
demos](https://avehtari.github.io/BDA_course_Aalto/demos.html) on how to
use Stan in R (or Python).
[Aalto JupyterHub](https://Aalto JupyterHub) has working R and
CmdStanR/RStan environment and is probably the easiest way to use Stan.
* To use CmdStanR in [Aalto JupyterHub](https://Aalto JupyterHub):<br>
  `library(cmdstanr)`<br>
  `set_cmdstan_path('/coursedata/cmdstan')`

The Aalto Ubuntu desktops also have the necessary libraries installed.]{.aalto}

To install Stan on your laptop, run 'install.packages(\"cmdstanr\",
repos = c(\"https://mc-stan.org/r-packages/\", getOption(\"repos\")))'
in R. If you encounter problems, see additional answers in
[**FAQ**](https://avehtari.github.io/BDA_course_Aalto/FAQ.html). [If you
don't succeed in short amount of time, it is probably easier to use
[Aalto JupyterHub](https://Aalto JupyterHub).]{.aalto}

[If you use `Aalto JupyterHub`, all necessary packages have been
pre-installed.]{.aalto} In your laptop, install package `cmdstanr`. Installation
instructions on Linux, Mac and Windows can be found at
<https://mc-stan.org/cmdstanr/>. Additional useful packages are `loo`,
`bayesplot` and `posterior` (but you don't need these in this
assignment). For Python users, `PyStan`, `CmdStanPy`, and `ArviZ`
packages are useful.

Stan manual can be found at <https://mc-stan.org/users/documentation/>.
From this website, you can also find a lot of other useful material
about Stan.

If you edit files ending `.stan` in RStudio, you can click "Check" in
the editor toolbar to make syntax check. This can significantly speed-up
writing a working Stan model.