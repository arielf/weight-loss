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
PATH := $(HOME)/bin:/bin:/usr/bin:.
NAME := $(shell ./username)

#
# How much to "overfit" the raw data
# Data is probably stationary.
#
PASSES = 4

#
# vowpal-wabbit args
#
VW_ARGS = \
	-k \
	--loss_function squared \
	--progress 1 \
	--bootstrap 16 \
	-l 1.0 \
	--l2 1.85201e-08 \
	-c --passes $(PASSES) --holdout_off


# -- programs
TOVW := lifestyle-csv2vw
VW := vw $(VW_ARGS)
SHUFFLE := shuf
# unsort --seed $(SEED)

# -- data files
MASTERDATA = $(NAME).csv
TRAINFILE  = $(NAME).train
MODELFILE  = $(NAME).model
DWCSV := weight.2015.csv
DWPNG := weight.png

.PRECIOUS: Makefile $(MASTERDATA) $(TOVW)

#
# -- rules
#
all:: score

s score: $(TRAINFILE)
	vw-varinfo $(VW_ARGS) $(TRAINFILE)

m $(MODELFILE): FORCE
	$(VW) -f $(MODELFILE) $(TRAINFILE)

t $(TRAINFILE): $(MASTERDATA) $(TOVW)
	$(TOVW) $(MASTERDATA) > $(TRAINFILE)

c chart: $(DWCSV)
	date-weight.r $(DWCSV) $(DWPNG)

conv: $(TRAINFILE)
	$(SHUFFLE) $(TRAINFILE) | $(VW) 2>&1 | vw-convergence

clean:
	/bin/rm -f $(MODELFILE) *.cache* *.tmp*

FORCE:

