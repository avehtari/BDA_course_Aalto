# Frequently Asked Questions
## Error related to LC_CTYPE while installing `aaltobda` r-package.
One of the reported errors was as follows:
```
I'm having problems downloading the github code. I keep getting the following error message:
Error: (converted from warning) Setting LC_CTYPE failed, using "C"
Execution halted
Error: Failed to install 'aaltobda' from GitHub:
 (converted from warning) installation of package '/var/folders/g6/bdv4dr4s6qq4zyxw2nzy26kr0000gn/T//Rtmp3uYwuD/file121f355845a3/aaltobda_0.1.tar.gz' had non-zero exit status
 ```

### Solution
See the following StackOverflow solution. ([link](https://stackoverflow.com/a/3909546))

## Installing `knitr`
If you just installed RStudio and R, chances are you don't have `knitr` installed, the package responsible of rendering your pdf.

### Solution
```{r}
install.packages("knitr")
```

## If `knitr` is installed but the pdf won't compile
In this case it is possible that you don't have LaTeX installed, which is the package that runs the engine to process the text and render the pdf itself.

### Solution
TinyLatex is the bare minimum Latex core that you need to install in order to run the pdf compiler. If you want to go further and download a full distribution of Latex, look at texlive for linux and mactex for macOS.

```{r}
install.packages(tinylatex)
tinylatex::install_tinylatex()
```

