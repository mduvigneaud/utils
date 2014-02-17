#!/usr/bin/perl

package Color;

require v5.6;

use strict;
use Exporter;

our $VERSION = v1.0.0;
our @ISA = qw(Exporter);
our @EXPORT = ();
our @EXPORT_OK = qw(color reset bg bright bold black red green yellow blue magenta cyan white);
our %EXPORT_TAGS = (
	all => [@EXPORT_OK],
);

use constant {
	black   => 30,
	red     => 31,
	green   => 32,
	yellow  => 33,
	blue    => 34,
	magenta => 35,
	cyan    => 36,
	white   => 37,
};

sub color;
sub reset ();
sub fg;
sub bg;
sub bright;
sub bold ();

sub color {
	return "\e[" . join(';', @_) . "m";
}

sub reset () {
	return 0;
}

sub is_fg {
	my $c = shift;
	return ($c >= 30 && $c < 40); # || ($c >= 90 && $c < 100);
}

sub fg {
	my $c = shift;
	
	if (!$c) {
		$c = 39;
	}
	
	return $c;
}

sub is_bg {
	my $c = shift;
	return ($c >= 40 && $c < 50); # || ($c >= 100 && $c < 110);
}

sub bg {
	my $c = shift;
	
	if (!$c) {
		$c = 49;
	} elsif (is_fg $c) {
		$c += 10;
	}
	
	return $c;
}

sub bright {
	my $c = shift;

	if (is_fg $c || is_bg $c) {
		$c += 60;
	}
	
	return $c;
}

sub bold () {
	return 1;
}

1;
