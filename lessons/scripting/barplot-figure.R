################################
# Prefix part: setting variables
################################
# working directory if needed
# e.g., setwd("~/Documents/git/new/2014-05-08-datacarpentry/lessons/R")
# data input
# plot output
# plot decoration

##########################################################
# Main part: execution of data loading, analysis, plotting 
##########################################################
dat  <- read.csv("surveys.csv", header=TRUE, na.strings="")
dat2 <- dat[complete.cases(dat$wgt),]
meanvals <- aggregate(wgt~species, data=dat2, mean)

pdf("R_plot.pdf")
barplot(meanvals$wgt, names.arg=meanvals$species, cex.names=0.4, col=c("blue"))
dev.off()
