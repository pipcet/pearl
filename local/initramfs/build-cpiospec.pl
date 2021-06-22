#!/usr/bin/perl
my %paths;
while (<STDIN>) {
    chomp;
    my $key = $_;
    for my $prefix (@ARGV) {
	if (substr($key, 0, length($prefix)) eq $prefix) {
	    $key = substr($key, length($prefix));
	}
    }
    $paths{$key} = $_;
}

my $didsomething = 1;
while ($didsomething) {
    $didsomething = 0;
    for my $path (sort keys %paths) {
	my $dir = $path;
	$dir =~ s/\/[^\/]*$//;
	next if exists $paths{$dir};
	$paths{$dir} = "/";
	$didsomething = 1;
    }
}

print "dir / 755 0 0\n";

for my $key (sort { $a cmp $b } keys %paths) {
    next if $key eq "";
    if ($paths{$key} eq "/" or -d $paths{$key}) {
	print "dir $key 755 0 0\n";
    } elsif (-l $paths{$key}) {
	print "slink $key " . readlink($paths{$key}) . " 755 0 0\n";
    } elsif (-x $paths{$key}) {
	print "file $key " . $paths{$key} . " 755 0 0\n";
    } else {
	print "file $key " . $paths{$key} . " 644 0 0\n";
    }
}
