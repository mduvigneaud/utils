#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use File::Basename ();
use lib Cwd::abs_path(File::Basename::dirname(__FILE__) . '/../lib');
use Color qw(:all);

use constant MONTHS => {'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5, 'Jun' => 6, 'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12};
use constant WEEKDAYS => {'Sun' => 0, 'Mon' => 1, 'Tue' => 2, 'Wed' => 3, 'Thu' => 4, 'Fri' => 5, 'Sat' => 6};

# Turn auto-flush (unbuffered) output on.
local $| = 1;

while (<>) {
	s/[\r\n]+$//;
	
	my $prefix = '';
	my $suffix = '';
	
	if (/^==> (.*) <==$/) {
		my ($log) = ($1);
		printf "==> %s%s%s <==\n", color(bright blue), $log, color(reset);
	} elsif (/^([^ ]+) ([^ ]+) ([^ ]+) \[([^\]]+)\] "((?:[^"\\]+|\\\\|\\")*)" (-|\d+) (-|\d+) "([^"]*)" "((?:[^"\\]+|\\\\|\\")*)"/) {
		my ($remote, $rlog, $ruser, $datestr, $request, $status, $size, $referrer, $agent) = ($1, $2, $3, $4, $5, $6, $7, $8, $9);
		my ($method, $path, $proto) = $request =~ /^([A-Z]+) (.*) (HTTP\/1.[10])$/;
		my ($d, $b, $Y, $H, $M, $S, $z) = $datestr =~ m/([0-9]{2})\/([A-Z][a-z]{2})\/([0-9]{4}):([0-9]{2}):([0-9]{2}):([0-9]{2})  ?(-?[0-9]{4})$/;
		my $m = MONTHS->{$b};
		
		# Skip LAN/home IP addresses.
		if ($remote =~ /^(?:192\.168\.\d+\.\d+)$/) {
			next;
		}
		if ($status == 404 && $path =~ /^\/(?:robots\.txt|favicon\.ico|sitemap\/|(?:google_)?sitemap\.xml)$/) {
			# Skip certain files that are commonly not found.
			next;
		}
		
		# Colorize the timestamp.
		$datestr = sprintf "%s%04d-%02d-%02d %02d:%02d:%02d%s", color(bold, bright white), $Y, $m, $d, $H, $M, $S, color(reset);
		
		# Colorize the remote host.
		$remote = sprintf "%s%s%s", color(bold, bright green), $remote, color(reset);
		
		if ($status >= 400 && $status <= 499) {
			# Colorize 4xx responses in red.
			printf "%s%s%s\n", color(bg red), $_, color(reset);
		} else {
			printf "[%s] %s %s %s \"%s\" %s %s \"%s\" \"%s\"\n", $datestr, $remote, $rlog, $ruser, $request, $status, $size, $referrer, $agent;
		}
	} elsif (/^\[([^\[\]]+)\] \[([^\[\]]+)\] (.*$)/) {
		my ($datestr, $level, $message) = ($1, $2, $3);
		if ($datestr =~ m/([A-Z][a-z]{2}) ([A-Z][a-z]{2}) ([0-9]{1,2}) ([0-9]{2}):([0-9]{2}):([0-9]{2}) ([0-9]{4})$/) {
			my ($a, $b, $d, $H, $M, $S, $Y) = ($1, $2, $3, $4, $5, $6, $7);
			my $m = MONTHS->{$b};
			
			# Colorize the timestamp.
			$datestr = sprintf "%s%04d-%02d-%02d %02d:%02d:%02d%s", color(bold, bright white), $Y, $m, $d, $H, $M, $S, color(reset);
		}
			
		if ($level eq 'notice') {
			$level = sprintf "%s%s%s", color(bold, bright blue), $level, color(reset);
		} elsif ($level eq 'warn') {
			$level = sprintf "%s%s%s", color(bold, bright yellow), $level, color(reset);
		} elsif ($level eq 'error') {
			$level = sprintf "%s%s%s", color(bold, bright red), $level, color(reset);
		}
		
		if (my ($remote, $rest) = $message =~ /^\[client (\d+(?:\.\d+){3})\] (.*)$/) {
		  # Colorize the remote host.
		  $remote = sprintf "%s%s%s", color(bold, bright green), $remote, color(reset);
		  
		  $message = sprintf "%s %s", $remote, $rest;
		}
		
		printf "%s[%s] %s %s%s\n", $prefix, $datestr, $level, $message, $suffix;
	} else {
		printf "%s\n", $_;
	}
}
