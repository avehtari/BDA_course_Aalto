::: {.callout-tip collapse=true}
## Further information

-   The recommended tool in this course is R (with the IDE R-Studio).
    You can download R [**here**](https://cran.r-project.org/) and
    R-Studio
    [**here**](https://www.rstudio.com/products/rstudio/download/).
    There are tons of tutorials, videos and introductions to R and
    R-Studio online. You can find some initial hints from [**RStudio
    Education pages**](https://education.rstudio.com/).
-   Instead of installing R and RStudio on you own computer, see [**how
    to use R and RStudio
    remotely**](https://avehtari.github.io/BDA_course_Aalto/FAQ.html#How_to_use_R_and_RStudio_remotely).
-   When working with R, we recommend writing the report using `quarto` and the soon to be provided template.
    The remplate includes the formatting instructions and how to include
    code and figures.
-   Instead of `quarto`, you can use other software to make the PDF
    report, but the the same instructions for formatting should be used..
-   Report all results in a single, **anonymous** \*.pdf -file and
    return it to [**peergrade.io**](peergrade.io).
-   The course has its own R package `aaltobda` with data and
    functionality to simplify coding. To install the package just run
    the following (upgrade=\"never\" skips question about updating other
    packages):
```{.r}
install.packages("remotes")
remotes::install_github("avehtari/BDA_course_Aalto", subdir = "rpackage", upgrade="never")
```
-   Many of the exercises can be checked automatically using the R
    package\
    `markmyassignment`. Information on how to install and use the
    package can be found
    [**here**](https://cran.r-project.org/web/packages/markmyassignment/vignettes/markmyassignment.html).
    There is no need to include `markmyassignment` results in the
    report.
-   Recommended additional self study exercises for each chapter in BDA3
    are listed in the course web page.
-   Common questions and answers regarding installation and technical
    problems can be found in [Frequently Asked Questions
    (FAQ)](https://avehtari.github.io/BDA_course_Aalto/FAQ.html).
-   Deadlines for all assignments can be found on the course web page
    and in peergrade. You can set email alerts for trhe deadlines in
    peergrade settings.
-   You are allowed to discuss assignments with your friends, but it is
    not allowed to copy solutions directly from other students or from
    internet. You can copy, e.g., plotting code from the course demos,
    but really try to solve the actual assignment problems with your own
    code and explanations. Do not share your answers publicly. Do not
    copy answers from the internet or from previous years. We compare
    the answers to the answers from previous years and to the answers
    from other students this year. All suspected plagiarism will be
    reported and investigated. See more about the [**Aalto University
    Code of Academic Integrity and Handling Violations
    Thereof**](https://into.aalto.fi/display/ensaannot/Aalto+University+Code+of+Academic+Integrity+and+Handling+Violations+Thereof).
-   Do not submit empty PDFs or almost empty PDFs as these are just
    harming the other students as they can't do peergrading for the
    empty or almost empty submissions. Violations of this rule will be
    reported and investigated in the same way was plagiarism.
-   If you have any suggestions or improvements to the course material,
    please post in the course chat feedback channel, create an issue, or
    submit a pull request to the public repository!


:::


        
::: {.rubric weight=7.5}    

* Can you open the PDF and it's not blank?     
* Is the report anonymous?    
     
:::      