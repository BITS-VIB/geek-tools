#!/bin/bash

# logtemp_plot.sh
# gnuplot from bash
# from http://askubuntu.com/questions/701986/how-to-execute-commands-in-gnuplot-using-shell-script

if [ $# -ne 1 ]; then
    echo "Usage: ${0##*/} <logtemp.pl output file>"
    echo "e.g. ${0##*/} ./logtmemp.txt"
    exit 1
fi

data=$1
output=${data%%.*}.png

gnuplot -persist <<-EOFMarker
	set term png
	set output "${output}"
	set title ""
	set xlabel "Time (s)"
	set ylabel "Temp (C)"
	set grid
	set datafile separator "\t"
	plot "${data}" using 2:3 with lines title 'Temperature log data'
EOFMarker
