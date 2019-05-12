#!/bin/sh
noweave -x -delay jelm.nw > jelm.tex
pdflatex jelm
pdflatex jelm
notangle -Rjelm.ijs jelm.nw > jelm.ijs
