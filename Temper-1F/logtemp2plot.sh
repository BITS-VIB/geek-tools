#!/bin/bash

# script name: logtemp2plot.sh
# make plot from a temperature log file (TEMPer1F / logtemp.pl)
## from http://askubuntu.com/questions/701986/how-to-execute-commands-in-gnuplot-using-shell-script
# Stephane Plaisance (VIB-NC+BITS) 2016/08/05; v1.0
#
# visit our Git: https://github.com/BITS-VIB

# check parameters for your system
version="1.0, 2016_08_05"

usage='Usage: '${0##*/}' <logtemp.pl output file>
# script version '${version}'
#  -i <inputfile|templog.txt>
## optional parameters (|default value)
#  -s <from time|0>
#  -e <until time|default to last recorded>
#  -b <min scale temp|0>
#  -t <max scale temp|40>'

while getopts "i:s:e:b:t:h" opt; do
  case $opt in
    i) infile=${OPTARG} ;;
    s) startt=${OPTARG} ;;
    e) endt=${OPTARG} ;;
    b) bottemp=${OPTARG} ;;
    t) toptemp=${OPTARG} ;;
    h) echo "${usage}" >&2; exit 0 ;;
    \?) echo "Invalid option: -${OPTARG}" >&2; exit 1 ;;
    *) echo "this command requires arguments, try -h" >&2; exit 1 ;;
  esac
done

# defaults
timestamp=$(date +%s)

# user-provided variables or defaults
input=${infile:-"templog.txt"}
starttime=${startt:-0}
endtime=${endt:--1}
mintemp=${bottemp:-10}
maxtemp=${toptemp:-40}

# test if minimal arguments were provided
if [ -z "${input}" ]
then
   echo "# no input provided!"
   echo "${usage}"
   exit 1
fi

# test input files
if [ ! -f ${input} ]; then
    echo "${input} file not found!"
    echo -e "${usage}"
    exit 1
else
	output=${input%%.txt}.png
fi

# get last time point from file
if [[ ${endtime} -lt 0 ]]; then
	endtime=$(tail -1 ${input} | awk 'BEGIN{FS="\t"; OFS="\t"}{print $2}')
fi

echo "# plotting values in intervals:"
echo "# Time (x): ${starttime}:${endtime}"
echo "# Temperature (y): ${mintemp}:${maxtemp}"
echo "# view plot with \`display ${output} &\`"

gnuplot -persist <<-EOFMarker
	set term png
	set output "${output}"
	set title ""
	set xlabel "Time (s)"
	set xrange ["${starttime}":"${endtime}"]
	set ylabel "Temp (C)"
	set yrange ["${mintemp}":"${maxtemp}"]
	set grid
	set datafile separator "\t"
	plot "${input}" using 2:3 with lines title 'Temperature log data'
EOFMarker
