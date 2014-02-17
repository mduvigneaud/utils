#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use File::Basename ();
use lib Cwd::abs_path(File::Basename::dirname(__FILE__) . '/../lib');
use Color qw(:all);

# Turn auto-flush (unbuffered) output on.
local $| = 1;

my %m2num = ('Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5, 'Jun' => 6, 'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12);

# Define some ANSI color codes.
my $reset = "\e[0m";            # Clear the color settings.

while (my $line = <>) {
	$line =~ s/[\r\n]+$//;
	
	# Header lines
	if ($line =~ /^(?:Index|RCS file: |retrieving revision |diff |={67})/i) {
		$line = sprintf "%s%s%s", color(bold, bright white), $line, color(reset);
	
	# Section lines
	} elsif ($line =~ /^-{3} /) {
		$line = sprintf "%s%s%s", color(bold, bright white), $line, color(reset);
	} elsif ($line =~ /^\+{3} /) {
		$line = sprintf "%s%s%s", color(bold, bright white), $line, color(reset);
	
	# Context lines
	} elsif ($line =~ /^(\@\@ .* \@\@|\d+(?:,\d+)?[acd]\d+(?:,\d+)?)(.*)$/) {
		$line = sprintf "%s%s%s%s", color(cyan), $1, color(reset), $2;
	
	# Removed lines
	} elsif ($line =~ /^[-<]/) {
		$line = sprintf "%s%s%s", color(red), $line, color(reset);
	
	# Added lines
	} elsif ($line =~ /^[\+>]/) {
		$line = sprintf "%s%s%s", color(green), $line, color(reset);
	}
	
	printf "%s\n", $line;
}
