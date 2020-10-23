SOURCESMD=$(shell find . -name "assignment*.md")
SOURCESRNW=$(shell find . -name "*.Rnw")
TARGETHTML = $(SOURCESMD:%.md=%.html)
TARGETPDF = $(SOURCESRNW:%.Rnw=%.pdf)

%.pdf: %.tex general_info.tex
	pdflatex $<; pdflatex $<; /bin/rm assignment*.tex assignment*.aux assignment*.log assignment*.out

%.tex: %.Rnw
	Rscript -e 'Sweave("$<")'

%.html: %.md
	Rscript -e 'rmarkdown::render("$<")'

html: $(TARGETHTML)

pdf: $(TARGETPDF)

all: pdf html
