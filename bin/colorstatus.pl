#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use File::Basename ();
use lib Cwd::abs_path(File::Basename::dirname(__FILE__) . '/../lib');
use Color qw(:all);

# Turn auto-flush (unbuffered) output on.
local $| = 1;

while (my $line = <>) {
	$line =~ s/[\r\n]+$//;
	
	if ($line =~ /^M/) {
		$line = sprintf "%s%s%s", color(bright blue), $line, color(reset);
	} elsif ($line =~ /^C/) {
		$line = sprintf "%s%s%s", color(bg red), $line, color(reset);
	} elsif ($line =~ /^A/) {
		$line = sprintf "%s%s%s", color(bright green), $line, color(reset);
	} elsif ($line =~ /^D/) {
		$line = sprintf "%s%s%s", color(bright red), $line, color(reset);
	} elsif ($line =~ /^\?/) {
		$line = sprintf "%s%s%s", color(white), $line, color(reset);
	}
	
	printf "%s\n", $line;
}
