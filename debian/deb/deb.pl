#!/usr/bin/perl
my $print = 0;
while (<STDIN>) {
    chomp;
    if ($print && $_ =~ /^Filename: (.*)$/) {
	print "$1\n";
	$print = 0;
	exit(1);
    }
    if ($_ eq "Package: $ARGV[0]") {
	$print = 1;
    }
}
