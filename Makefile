# Copyright © 2010 Jonathan Rascher.

.PHONY: all clean

all: jonathan-rascher-resume.pdf jonathan-rascher-resume-public.pdf

clean:
	rm -f *.aux *.log *.out *.pdf

jonathan-rascher-resume.pdf: core.tex jonathan-rascher-resume.tex
	pdflatex jonathan-rascher-resume.tex

jonathan-rascher-resume-public.pdf: core.tex jonathan-rascher-resume-public.tex
	pdflatex jonathan-rascher-resume-public.tex
