# Frequently Asked Questions

## How to access course material in Github

Instead of trying to download each file separately via Github interface, it is recommnded to clone the repo or download it as a zip file.
 - If you know how to use git, just clone the repo. Pull to get the latest updates.
 - If you want to learn to use git, you need to install a [git client](https://www.google.com/search?q=git+clients&oq=git+client).
 - If you don't want to learn to use git, download a zip file. Click a green button "Clone or download" at git repo main page and choose "Download ZIP". Remember to download the latest updates.
 - If you can't find the Download ZIP, click [here](https://github.com/avehtari/BDA_course_Aalto/archive/master.zip). Remember to download the latest updates.

## Using R and RStudio via Jupyterhub

Instead of installing RStudio in your computer, you can use it in your web browser:
- go to jupyter.cs.aalto.fi
- choose R: General use (JupyterLab) 1.8.*
- in Launcher click RStudio
- in RStudio Files pane you can create folders and upload files from your computer to the server
  - **notebooks** folder is currently the only persistent folder (stays there if you sign out) so upload files (and folders) to that folder!
  - I got an error if I tried to upload whole BDA_R_demos repository as a zip file, but uploading smaller zip files work
  - the maximum filesize will be increased in near future
- after uploading files use Files pane to open, e.g., RMarkdown notebook
- knitting of R and Rmd files work, too
- when running RStan, there is currently extra dialog popping up which required clicking Yes, but this will be fixed in near future
  - there is a limited memory available (3Gib) and bigger models and datasets can run out of memory with cryptic error message

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
You can also install packages from RStudio menu `Tools->Install Packages`.

## If `knitr` is installed but the pdf won't compile
In this case it is possible that you don't have LaTeX installed, which is the package that runs the engine to process the text and render the pdf itself.

### Solution
Tinytex is the bare minimum Latex core that you need to install in order to run the pdf compiler. If you want to go further and download a full distribution of Latex, look at texlive for linux and mactex for macOS.

```{r}
install.packages("tinytex")
tinytex::install_tinytex()
```

## Windows user and have a lot of problems getting packages to install ?

> ⚠️ Note that getting the setup needed for the course working on Windows might involve a bit more effort than on Linux and Mac. Consequently, **we recommmend using either Linux or MacOS**.
> Moreover, `Stan` the probabilistic programming language which we will use later on during the course requires a C++ compiler toolchain which is not available by default in Windows (blame Microsoft).
> However, if you insist on using Windows and have a problem getting the setup working, following are some possible workarounds / solutions :

# Workaround: Use Linux via remote-desktop. (Quickest to get started with)

One workaround might be to use Linux via the `remote desktop solution` provided by Aalto-IT. A couple of students (BDA-2019) have been using this already and it has been a pretty good experience.
* Goto `vdi.aalto.fi`
* Download VMWare Horizon application (you could also use the web portal, so no need to install anything)
* Click on `New Server`.
* Enter `vdi.aalto.fi`
* Enter your aalto username (aalto email works too) and password in the respective fields.
* Select `Ubuntu 16.04`
* Click `Applications` (top left) -> `Programming` -> `RStudio`

# Install the latest version of `R` and then install `RStan`
* Remove existing R installations and install the latest version of [R](https://www.r-project.org/)
* Install `RStan` along with the necessary C++ compiler toolchain as described [here](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)

