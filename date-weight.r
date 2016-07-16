#!/usr/bin/Rscript --vanilla
#
# Generate date vs. weight chart
#
eprintf <- function(...) cat(sprintf(...), sep='', file=stderr())

library(ggplot2)
library(scales)     # for date_breaks()

MaxMonths=20
MaxDays=ceiling(MaxMonths*30.4375)

# --- styles
ratio = 1.61803398875
W = 6
H = W / ratio
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
                'weight.2015.csv'
)
PngFile <- ifelse(
                length(FileArgs) > 1 && nchar(FileArgs[2]) > 0,
                FileArgs[2],
                gsub(CsvFile, pattern='.[tc]sv', replacement='.png')
)

Title <- ifelse(length(Params$title),
                Params$title,
                'weight by date'
)

Xlab <- Params$xlab
Ylab <- ifelse(length(Params$ylab),
			Params$ylab,
			'Lb'
)

d <- read.csv(CsvFile, h=T, colClasses=c('character', 'numeric'))

# Trim data to MaxDays
N <- nrow(d)
if (N > MaxDays) {
    d <- d[(N-MaxDays):N, ]
}

g <- ggplot(data=d, aes(x=as.POSIXct(Date), y=Pounds)) +
        scale_y_continuous(breaks=150:195) +
        scale_x_datetime(breaks = date_breaks("2 months"),
                         labels = date_format("%Y\n%b")) +
        geom_line(aes(y=Pounds), size=0.3, col='#0077ff') +
        geom_point(aes(y=Pounds), pch=20, size=0.8) +
        ggtitle(Title) +
        ylab(Ylab) + xlab(Xlab) +
        theme(
            plot.title=title.theme,
            axis.title.y=y.title.theme,
            axis.title.x=x.title.theme,
            axis.text.x=x.axis.theme,
            axis.text.y=y.axis.theme
        )

ggsave(g, file=PngFile, width=W, height=H, dpi=DPI)

