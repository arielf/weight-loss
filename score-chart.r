#!/usr/bin/Rscript --vanilla
#
# Generate weight gain/loss factor chart
#
library(ggplot2)

eprintf <- function(...) cat(sprintf(...), sep='', file=stderr())

# --- styles
ratio = 1.61803398875
W = 10
H = W * ratio
DPI = 200
FONTSIZE = 8
MyGray = 'grey50'

# --- Favorite fonts
Family='FreeSans'
Face='bold.italic'

title.theme   = element_text(family=Family, face=Face,
                            size=FONTSIZE)
x.title.theme = element_text(family=Family, face=Face,
                            size=FONTSIZE-1, vjust=-0.1)
y.title.theme = element_text(family=Family, face=Face,
                           size=FONTSIZE-1, angle=90, vjust=0.2)
x.axis.theme  = element_text(family=Family, face="bold",
                            size=FONTSIZE-2, colour=MyGray)
y.axis.theme  = element_text(family=Family, face="bold",
                            size=FONTSIZE-2, colour=MyGray)
legend.theme  = element_text(family=Family, face=Face,
                            size=FONTSIZE-1, colour="black")

Params <- list()
process.args <- function() {
    argv <- commandArgs(trailingOnly = TRUE)
    fileArgs <- c()
    for (arg in argv) {
        # Arguments can be either:
        #       Params:   name=value
        # or:
        #       Files:    file arguments
        # eprintf("arg: %s\n", arg)
        var.val <- unlist(strsplit(arg, '='))
        if (length(var.val) == 2) {
            var <- var.val[1]
            val <- var.val[2]
            Params[[var]] <<- val
	    # eprintf('Params$%s=%s\n', var, val)
        } else {
            fileArgs <- c(fileArgs, arg)
        }
    }
    # for (n in names(Params)) {
    #   eprintf("Params[[%s]]: %s\n", n, Params[[n]]);
    # }
    # Params are assigned to global array Params[]
    # rest are returned as files
    fileArgs
}

# --- main
FileArgs <- process.args()
CsvFile <- ifelse(
    length(FileArgs) > 0 && nchar(FileArgs[1]) > 0,
    FileArgs[1],
    'scores.csv'
)
PngFile <- ifelse(
    length(FileArgs) > 1 && nchar(FileArgs[2]) > 0,
    FileArgs[2],
    gsub(CsvFile, pattern='.[tc]sv', replacement='.png')
)

Title <- ifelse(length(Params$title),
    Params$title,
   'Relative weight-loss factor importance\n(negative/green means causing weight-loss\npositive/red means causing weight-gain)'
)

# -- Color weight-gains in red and weigh-losses in green for effect
#    (this is one uncommon case where a 'positive' quantity is
#     actually undesired/negative)
MyGreen = '#00cc00'
MyRed = '#ff0000'

d <- read.csv(CsvFile, h=T, sep=',', colClasses=c('character', 'numeric'))

N <- nrow(d)
CrossIdx = which.min(abs(d$RelScore))

d <- transform(d,
    FeatureNo = 1:N,
    TextOffset = (ifelse(d$RelScore > 0, -2, +2)),
    TextJust = d$RelScore > 0,
    FillColor = (ifelse(d$RelScore > 0, MyRed, MyGreen)),
    FeatureLabels = sprintf("%s (%.1f%%)", d$FeatureName, d$RelScore)
)


g <- ggplot(
        data=d,
        aes(
            x=FeatureNo,
            y=RelScore
        ),
        xlim(-100, 100)
    ) +
    geom_bar(
        stat='identity',
        position='identity',
        width=0.8,
        fill=d$FillColor,
    ) +
    geom_text(label=d$FeatureLabels,
                y=d$TextOffset, x=d$FeatureNo,
                size=2.0, angle=0, hjust=d$TextJust) +
    ggtitle(Title) +
    ylab('Relative Importance (%pct)') +
    xlab(NULL) +
    annotate("text", x=CrossIdx+20, y=+35, label='Weight\nGain',
                angle=0, colour=MyRed, size=9,
                family=Family, fontface=Face) +
    annotate("text", x=CrossIdx-20, y=-35, label='Weight\nLoss',
                angle=0, colour=MyGreen, size=9,
                family=Family, fontface=Face) +
    coord_flip() +
    theme(
        plot.title=title.theme,
        axis.title.y=y.title.theme,
        axis.title.x=x.axis.theme,
        axis.text.x=x.axis.theme,
        axis.text.y=element_blank()
    )

ggsave(g, file=PngFile, width=W, height=H, dpi=DPI)

