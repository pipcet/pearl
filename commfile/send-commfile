#!/usr/bin/perl
use File::Slurp qw(read_file);
use Fcntl qw(SEEK_SET);
use bytes;

while (1) {
    my $data = read_file($ARGV[0]);
    for my $dev (glob "/sys/class/block/*") {
	$dev =~ s/^\/sys\/class\/block\///;
	if ($dev =~ /sd[b-z]/) {
	    my $fh;
	    open $fh, "+</dev/$dev" or next;
	    warn "opened dev $dev";
	    my $str;
	    next unless sysread($fh, $str, 32) == 32;
	    warn $str;
	    unless ($str eq "m1lli is ready and waiting\n\0\0\0\0\0") {
		sysseek($fh, 1024 * 1024, SEEK_SET);
		next unless sysread($fh, $str, 27) == 27;
		warn $str;
		next unless ($str eq "m1lli is ready and waiting\n");
	    }
	    my $size = length($data) + 32;
	    my $str = sprintf("%d", $size);
	    sysseek($fh, 0, SEEK_SET);
	    syswrite($fh, $str . "\0", length($str) + 1);
	    sysseek($fh, 32, SEEK_SET);
	    syswrite($fh, $data, length($data));
	    warn "wrote " . length($data) . " bytes";
	    system("sync");
	    sysseek($fh, $size, SEEK_SET);
	    $str = "READY";
	    syswrite($fh, $str . "\0", length($str) + 1);
	    system("sync");
	    exit(0);
	}
    }
}
