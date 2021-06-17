#!/usr/bin/perl
while (<>) {
    chomp;
    my ($dir,$flags,$file) = split " ";
    my %flags;
    for my $flag (split ",", $flags) {
	$flags{$flag} = 1;
    }
    next unless $flags{CLOSE_WRITE};
    if ($dir =~ /^\.\/submodule\/(.*?)\/.*$/) {
	my $module = $1;
	warn "$module changed ($dir)";
	system("touch stamp/$module");
    }
}
