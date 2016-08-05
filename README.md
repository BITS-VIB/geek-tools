geek-tools
==========

These scripts are meant to help advanced users better use CLI programs and build workflows for their research.

## **Application monitoring** 

Bash and R plotting scripts to monitor a demanding application and plot the results to 'png' or 'pdf'. Working with BIG data often requires to estimate and optimize CPU and or memory usage. This pair of tools records a running application to evaluate its needs and create a plot to visualize the results.

### Creating a monitoring file with **logmyapp**

Start your favorite CLI program (or scrip running it) and monitor cpu and ram with **logmyapp**

REM: The bash script is only functional under Unix, the Apple Darwin top command lacking the -b option does not allow running it (if you know how to fix this, please let me know!!).

<pre>
Usage: logmyapp [name of the app to monitor] [interval (sec|default=5)]
</pre>

### Plotting from the log file with **log2plot.R**

Then use the **logmyapp** text log file is used as input by **log2plot.R**.

In order to use this script, you will need [R] and RScript installed on your computer (done by most package installers including yum and apt-get). You will also need the [R] package **optparse** [http://cran.r-project.org/web/packages/optparse/](http://cran.r-project.org/web/packages/optparse/) to handle command line arguments.

Installing the dependencies is documented on the top of the code. Please read the respective package documentations if you wish to improve these scripts.

**log2plot.R -h**
<pre>
Usage: ./log2plot.R [options]

Options:
	-i INFILE, --infile=INFILE
		input file name

	-r TOTRAM, --totram=TOTRAM
		total RAM available on the computer [default: 4]

	-m MAXRAM, --maxram=MAXRAM
		max RAM value on y-scale [default: totram]

	-t TITLE, --title=TITLE
		Graph Main Title

	-o OUTFILE, --outfile=OUTFILE
		base name for output [default: monitoring_plot]

	-f OUTFORMAT, --outformat=OUTFORMAT
		file format for output 1:PNG, 2:PDF [default: 1]

	-h, --help
		Show this help message and exit
</pre>

### Example screenshots

The output of a 15 million paired end reads **bowtie2** mapping job to the human reference genome (hg19) is shown as example (<a href="logmyapp/pictures/bowtie2_usage1401561413.log">bowtie2_usage1401561413.log</a>):

<pre>
#time pid %cpu %MEM App
11 1223 7.8 0.2 bowtie2-align-s
16 1223 7.8 2.8 bowtie2-align-s
22 1223 7.8 5.4 bowtie2-align-s
27 1223 9.8 8.0 bowtie2-align-s

... many more lines here

980 1223 685.0 22.6 bowtie2-align-s
985 1223 756.6 22.6 bowtie2-align-s
991 1223 780.5 22.6 bowtie2-align-s
</pre>

The monitoring data was fed to the accompanying R script with the following command:

<pre>
log2plot.R -i bowtie2_usage1401561413.log \
    -r 16 \
    -m 6 \
    -f 1 \
    -t "bowtie2 monitoring" \
    -o bowtie2_monitoring
</pre>

The resulting picture reports bowtie2 activity and RAM usage (here in png format)

<img src="logmyapp/pictures/bowtie2_monitoring.png?raw=true" alt="monitoring results" style="width: 300px;"/>

### logging all outputs to a file for inspection with **runandlog**

Uses tee to copy all output, including standard error messages to a log file. After completion, the script reports the time spent by the command. 


## Log temperature in the server room for plotting or simply controlling 

A basic Perl script **[logtemp.pl](Temper-1F/logtemp.pl)** is used to monitor the **Temper-1F** measures to file. A simple example of gnuplot code is added to generate images. This is very basic and heavily relies on the python package <a href="https://github.com/padelt/temper-python" target="_blank">temper-python</a> used to master the cheap USB device.

The customized bash/gnupot script **[logtemp2plot.sh](Temper-1F/logtemp2plot.sh)** takes care of making a nice image from the log results.

### Example

The output of a temperature log in our computer server room is shown as example (<a href="Temper-1F/example/templog.txt">templog.txt</a>). Feeding thsi file to the gnuplot tool with the command <pre>logtemp2plot.sh -i templog.txt -s 80000 -e 110000 -b 18 -t 24</pre> produced the following picture.

<img src="Temper-1F/example/templog.png?raw=true" alt="temperature log results" style="width: 300px;"/>

------------
### **come back later for more**

<h4>Please send comments and feedback to <a href="mailto:bits@vib.be">bits@vib.be</a></h4>
------------

![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png?raw=true)

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).
