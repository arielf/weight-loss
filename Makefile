#
# Makefile for diet and weight-loss monitoring
# vim: ts=8 sw=8 noexpandtab nosmarttab
#
# Goal:
#	- Find out which lifestyle factors affect your weight the most
#	- Find out which foods make you gain or lose weight
#	- Find confidence-level (ranges) for each food/lifestyle item
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
# Additional 'make' targets (make <target>):
#
#    c/charts
#	Creates optional charts
#
#    sc
#	Creates the per-item scores chart only
#
#    m/model
#	Creates a model file from the daily train-file
#
#    t/train
#	Creates the daily-delta (weight change target) train file
#
#    i/items
#	Creates 'by single-item' train file. This is a "pretend"
#	data-file as if we only had one-item/day to see what's
#	its "pretend-isolated" effect assuming everything else is equal.
#
#    conf/confidence/r/range
#	Generates a sorted *.range file, in which each item appears
#	together with its 'confidence range' [min max]. This can
#	help you figure out how certain we are for each variable.
#	e.g. a line like this:
#		-0.024568 carrot -0.071207 0.026108
#	means based on the given data, the machine-learning process
#	estimates carrot makes you lose a bit of weight
#	(average is a negative: -0.024568) but the confidence
#	daily range is from -0.071207 (loss) to 0.026108 (gain)
#	so there's a low confidence in this result.
#
#   conv
#	Generates a convergence chart of the learning process
#
#   clean
#	Cleans-up generated files
#
PATH := $(PATH)::.
NAME = $(shell ./username)

# -- scripts/programs
VW = vw
TOVW := lifestyle-csv2vw
VARINFO := vw-varinfo2
SORTABS := sort-by-abs

# Adjustable parameters: to change call 'make' with NAME=Value:
# --bootsrap rounds:
BS = 7
# --passes:
P = 4
# -- learning rate
L = 0.05
# L2 regularization
L2 = 1.85201e-08

# Aggregate consecutive daily-data up to this number of days
NDAYS = 3

#
# vowpal-wabbit training args
#
VW_ARGS = \
	-k \
	--loss_function quantile \
	--progress 1 \
	--bootstrap $(BS) \
	-l $(L) \
	--l2 $(L2) \
	-c --passes $(P)



# -- Commented out random shuffling methods
#    now sorting examples by abs(delta).
#    Overfitting is countered (though not completely avoided) by:
#	* Aggregating on multiple partly overlapping N-day periods
#	* Bootstrapping each example (multiple times) via --bootstrap
#
# Mutliple orders via shuffling and averaging results should be
# considered as a future option.
#
# SHUFFLE := shuf
# SHUFFLE := unsort --seed $(SEED)
#

# -- data files
MASTERDATA = $(NAME).csv
TRAINFILE  = $(NAME).train
ITEMFILE  = $(NAME).items
MODELFILE  = $(NAME).model
RANGEFILE = $(NAME).range
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
	$(VW) $(VW_ARGS) -f $(MODELFILE) $(TRAINFILE)

# -- train-set generation
t train $(TRAINFILE): Makefile $(MASTERDATA) $(TOVW)
	$(TOVW) $(NDAYS) $(MASTERDATA) | sort-by-abs > $(TRAINFILE)

# -- generate 'by single-item' train file
i items $(ITEMFILE): $(TRAINFILE)
	train-to-items $(TRAINFILE) > $(ITEMFILE)

# -- Find daily 'range' for 'per-item'
#    This finds a ~90% confidence interval (leverages vw --bootstrap)
conf confidence r range $(RANGEFILE): $(MODELFILE) $(ITEMFILE)
	$(VW) --quiet -t -i $(MODELFILE) \
		-d $(ITEMFILE) -p /dev/stdout | sort -g > $(RANGEFILE)

# -- convergence chart
conv: $(TRAINFILE)
	$(VW) $(VW_ARGS) $(TRAINFILE) 2>&1 | vw-convergence

clean:
	/bin/rm -f $(MODELFILE) $(ITEMFILE) $(RANGEFILE) *.cache* *.tmp*

db docker-build:
	docker build -t score .

ds docker-score: docker-build
	docker run -v $(CURDIR):$(CURDIR) -w $(CURDIR) score make

dsc docker-score-chart: docker-build
	docker run -v $(CURDIR):$(CURDIR) -w $(CURDIR) score make sc

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
