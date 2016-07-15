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
#	- Install vowpal-wabbit & its utility utl/vw-varinfo
#	- Clone this repo: https://github.com/arielf/weight-loss
#	- Place your data in <username>.csv
#	- Type 'make'
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
SORTABS := sort-by-abs

# SHUFFLE := shuf
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

m model $(MODELFILE): Makefile $(TRAINFILE)
	$(VW) -f $(MODELFILE) $(TRAINFILE)

t train $(TRAINFILE): Makefile $(MASTERDATA) $(TOVW)
	$(TOVW) $(MASTERDATA) | sort-by-abs > $(TRAINFILE)

c chart $(DWPNG): date-weight.r $(DWCSV)
	date-weight.r $(DWCSV) $(DWPNG)

conv: $(TRAINFILE)
	$(VW) $(TRAINFILE) 2>&1 | vw-convergence

clean:
	/bin/rm -f $(MODELFILE) *.cache* *.tmp*

# Give a more friendly error if original data doesn't exist
$(MASTERDATA):
	@echo "=== Sorry: you must provide your data in '$(MASTERDATA)'"
	@exit 1


