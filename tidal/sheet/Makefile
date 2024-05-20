all: tidal_cheatsheet.pdf

cheatsheet: tidal_cheatsheet.tex
	pdflatex $<
	rm -f *.out
	rm -f *.log
	rm -f *.aux

clean:


.PHONY: all clean