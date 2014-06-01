#!/usr/bin/RScript

# Create nice plot from monitoring data saved by logmyapp
# usage: log2plot.R -h
#
# Stephane Plaisance VIB-BITS June-01-2014 v1.0

# required R-packages
# once only install.packages("optparse")
suppressPackageStartupMessages(library("optparse"))

#####################################
### Handle COMMAND LINE arguments ###
#####################################

# parameters
#  make_option(c("-h", "--help"), action="store_true", default=FALSE,
#              help="plots from logmyapp monitoring data")

option_list <- list(
  make_option(c("-i", "--infile"), type="character", 
              help="input file name"),
  make_option(c("-r", "--totram"), type="integer", default=4, 
            help="total RAM available on the computer [default: %default]"),
  make_option(c("-m", "--maxram"), type="integer", default=4, 
              help="max RAM value on y-scale [default: totram]"),
  make_option(c("-t", "--title"), type="character",
              help="Graph Main Title"),
  make_option(c("-o", "--outfile"), type="character", default="monitoring_plot",
              help="base name for output [default: %default]"),
  make_option(c("-f", "--outformat"), type="integer", default=1,
              help="file format for output 1:PNG, 2:PDF [default: %default]")
  )

## parse options
opt <- parse_args(OptionParser(option_list=option_list))

# check if arguments provided
if ( length(opt) > 1 ) {

	# check that infile exists
	if( file.access(opt$infile) == -1) {
	  stop(sprintf("Specified file ( %s ) does not exist", opt$infile))
	  }

	##### load data in
	log.data <- read.table(opt$infile, quote="\"", header=TRUE, comment.char = "@")
	attach(log.data)

	# define max values
	max.time <- ceiling(max(X.time)/100)*100
	max.ram <- max(X.MEM)

	# set colors
	cpu.col="black"
	ram.col="blue"

	# title
	main.title <- ifelse(!is.null(opt$title), opt$title, "") 

	# rescale RAM axis
	max.ram <- ifelse(!is.null(opt$maxram), opt$maxram, opt$totram)

	# output format
	if (opt$outformat==1){
	  # png
	  filename <- paste(opt$outfile, ".png", sep="")
	  png(file = filename, 
		  width = 600, 
		  height = 480, 
		  units = "px", 
		  pointsize = 12,
		  bg = "white")
  
	} else {
	  # pdf
	  filename <- paste(opt$outfile, ".pdf", sep="")
	  pdf(file = filename, 
		  width = 6, 
		  height = 5,
		  pointsize = 12,
		  bg = "white")
	}

	##### create plot in two steps (cpu then ram)
	par(mar = c(5,5,2,5))
	plot(X.cpu/100~X.time, 
		 xlab = "execution time (sec)",
		 xlim = c(0, max.time), 
		 ylab = "CPU", 
		 pch = 20,
		 col = cpu.col,
		 main = main.title)
	par(new = T)
	plot(opt$totram*X.MEM/100~X.time, 
		 xlim = c(0, max.time),
		 ylim = c(0, max.ram), 
		 col = ram.col, 
		 axes = F, 
		 xlab = NA, 
		 ylab = NA, 
		 pch = 4, 
		 cex = 0.5)
	axis(side = 4, col = ram.col, col.axis = ram.col)
	mtext(side = 4, line = 3, col = ram.col, "RAM (GB)")

	dev.off()	
	##### end  happily

} 
