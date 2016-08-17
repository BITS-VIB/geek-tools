#!/usr/bin/perl -w

# Script: logtemp.pl : log temperature from a TEMPer1F USB device
# makes use of executable code from https://github.com/padelt/temper-python
# run this script in a screen session and break it with Ctrl-C when ready
# or make a cron job to continuously record temperature
# you can plot the results using the accompanying shell/gnuplot script
#
# Stephane Plaisance (VIB-NC+BITS) 2016/08/02; v1.0
# visit our Git: https://github.com/BITS-VIB

use strict;
use warnings;
use Getopt::Std;
use POSIX qw(strftime);

my $version = "1.0";

# locate the executable on your own system 
# !!! temper-poll should be executable by the current user, see developper page
my $temperpoll='/usr/bin/temper-poll';

############################
# handle command parameters
############################

getopts('s:t:o:h');
our($opt_s, $opt_t, $opt_o, $opt_h);

my $usage="## Usage: logtemp.pl -u c -t 60 -o ./logtmemp.txt
# <-s temperature scale [c|f] (c)>
# <-t period in seconds (60)>
# <-o path to log file (./templog.txt)
# <-h to display this help>";

####################
# declare variables
####################

my $outfile = $opt_o || "./templog.txt";
our $scale = $opt_s || "c";
our $period = $opt_t || 60;
defined($opt_h) && die $usage."\n";

# open stream from log file
open LOG, "> $outfile" || die $!;

# autoflush
autoflush(*LOG,  1);

our $timepoint = 0;

# infinite loop
while (1) {
	# get temperature from USB device
	my $curtmp=qx{$temperpoll -$scale};
	# handle errors
	$curtmp =~ /error/ && die $curtmp;

	# full date string	
	my $stamp = strftime '%Y-%m-%d-%H-%M-%S', localtime;
	
	# output
	print LOG $stamp."\t".$timepoint."\t".$curtmp;
	
	# wait $opt_t seconds
	$timepoint += $period;
	sleep($period);
}

close LOG;

sub autoflush {
   my $h = select($_[0]); $|=$_[1]; select($h);
}
