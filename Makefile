#
# Makefile for diet and weight-loss monitoring
# vim: ts=8 sw=8 noexpandtab nosmarttab
#
# Goal:
#	- Find out which lifestyle factors affect your weight the most
#	- Find out which foods make you gain or lose weight
#
# Requires you to:
#	- Weight yourself once a day
#	- Record what you do/eat daily
#
# How to run this code:
#	- Install vowpal-wabbit (vw)
#	- Clone this repo: https://github.com/arielf/weight-loss
#	- Place your data in <username>.csv
#	- Type 'make'
#
PATH := $(PATH)::.
NAME = $(shell ./username)

#
# vowpal-wabbit args
#
VW_ARGS = \
	-k \
	--loss_function squared \
	--progress 1 \
	-l 1.0 \
	--l2 1.85201e-08

# -- programs
TOVW := lifestyle-csv2vw
VW := vw $(VW_ARGS)
VARINFO := vw-varinfo2
SORTABS := sort-by-abs

# SHUFFLE := shuf
# unsort --seed $(SEED)

# -- data files
MASTERDATA = $(NAME).csv
TRAINFILE  = $(NAME).train
MODELFILE  = $(NAME).model
DWCSV := weight.2015.csv
DWPNG := $(NAME).weight.png
SCPNG := $(NAME).scores.png

.PRECIOUS: Makefile $(MASTERDATA) $(TOVW)

#
# -- rules
#
all:: score

s score scores.txt: $(TRAINFILE)
	$(VARINFO) $(VW_ARGS) $(TRAINFILE) | tee scores.txt

c charts: weight-chart score-chart

# -- Weight by date chart
wc weight-chart $(DWPNG): date-weight.r $(DWCSV)
	Rscript --vanilla date-weight.r $(DWCSV) $(DWPNG)
	@echo "=== done: date-weight chart saved in: '$(DWPNG)'"

# -- Feature importance score chart
sc score-chart $(SCPNG): scores.txt score-chart.r
	@perl -ane '$$F[5] =~ tr/%//d ;print "$$F[0],$$F[5]\n"' scores.txt > scores.csv
	@Rscript --vanilla score-chart.r scores.csv $(SCPNG)
	@echo "=== done: weight-loss factors chart saved in: '$(SCPNG)'"

# -- model
m model $(MODELFILE): Makefile $(TRAINFILE)
	$(VW) -f $(MODELFILE) $(TRAINFILE)

# -- train-set generation
t train $(TRAINFILE): Makefile $(MASTERDATA) $(TOVW)
	$(TOVW) $(MASTERDATA) | sort-by-abs > $(TRAINFILE)

# -- convergence chart
conv: $(TRAINFILE)
	$(VW) $(TRAINFILE) 2>&1 | vw-convergence

clean:
	/bin/rm -f $(MODELFILE) *.cache* *.tmp*

# -- more friendly error if original data doesn't exist
$(MASTERDATA):
	@echo "=== Sorry: you must provide your data in '$(MASTERDATA)'"
	@exit 1

# commit and push
cp:
	git commit . && git push

# sync gh-pages with master & push
gh:
	git checkout gh-pages && \
	git merge master && \
	git push && \
	git checkout master

