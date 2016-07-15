#!/usr/bin/Rscript --vanilla
#
# Generate weight gain/loss factor chart
#
eprintf <- function(...) cat(sprintf(...), sep='', file=stderr())

suppressPackageStartupMessages(library(ggplot2))

# --- styles
ratio = 1.61803398875
W = 10
H = W * ratio
DPI = 200
FONTSIZE = 8
MyGray = 'grey50'

title.theme   = element_text(family="FreeSans", face="bold.italic",
                            size=FONTSIZE)
x.title.theme = element_text(family="FreeSans", face="bold.italic",
                            size=FONTSIZE-1, vjust=-0.1)
y.title.theme = element_text(family="FreeSans", face="bold.italic",
                           size=FONTSIZE-1, angle=90, vjust=0.2)
x.axis.theme  = element_text(family="FreeSans", face="bold",
                            size=FONTSIZE-2, colour=MyGray)
y.axis.theme  = element_text(family="FreeSans", face="bold",
                            size=FONTSIZE-2, colour=MyGray)
legend.theme  = element_text(family="FreeSans", face="bold.italic",
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
   'Relative weight-loss factor importance\n(negative means causing weight loss)'
)

d <- read.csv(CsvFile, h=T, sep=',', colClasses=c('character', 'numeric'))
N = nrow(d)
FeatureNo = 1:N
TextOffset = ifelse(d$RelScore > 0, -2, +2)
TextJust = d$RelScore > 0
FillColor = ifelse(d$RelScore > 0, '#ff0000', '#00cc00')

g <- ggplot(
        data=d,
        aes(
            x=FeatureNo,
            y=RelScore,
        ),
        xlim(-100, 100)
    ) +
    geom_bar(
        stat="identity",
        position="identity",
        width=0.8,
        fill=FillColor,
        # colour='grey80'
    ) +
    coord_flip() +
    geom_text(label=d$FeatureName, size=2.0, angle=0, y=TextOffset, x=FeatureNo, hjust=TextJust) +
    ggtitle(Title) +
    ylab('Relative Importance (%pct)') +
    xlab(NULL) +
    theme(
        plot.title=title.theme,
        axis.title.y=y.title.theme,
        axis.title.x=x.axis.theme,
        axis.text.x=x.axis.theme,
        axis.text.y=element_blank()
    )

ggsave(g, file=PngFile, width=W, height=H, dpi=DPI)

