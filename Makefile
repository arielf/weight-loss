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
PASSES = 10

#
# vowpal-wabbit args
#
VW_ARGS = \
	-k \
	-c --passes $(PASSES) \
	-l 2

TOVW := lifestyle-csv2vw
VW := vw $(VW_ARGS)

MASTERDATA = $(NAME).csv
TRAINFILE  = $(NAME).train
MODELFILE  = $(NAME).model

.PRECIOUS: Makefile $(MASTERDATA) $(TOVW)

# -- rules
all:: score

m $(MODELFILE): FORCE
	$(VW) $(TRAINFILE) -f $(MODELFILE)

t $(TRAINFILE): $(MASTERDATA) $(TOVW)
	$(TOVW) $(MASTERDATA) > $(TRAINFILE)

s score i: $(TRAINFILE)
	vw-varinfo $(VW_ARGS) $(TRAINFILE)

d dups check-for-dups:
	make i | field 1 | sort -n | uniq -c | sort -n | \
		grep -v '^ *1 ' || /bin/true

c chart: $(TRAINFILE)
	$(VW) $(TRAINFILE)  2>&1 | tee $(NAME).training_progress
	vw-convergence -p $(NAME).training_progress


csoaa:
	vw-varinfo -k --csoaa 25 -c --passes 3 -l 0.1 --power_t 0 --l2 0.01 csoaa.train

clean:
	/bin/rm -f $(MODELFILE) *.cache* *.tmp*

FORCE:

