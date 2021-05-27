#!/usr/bin/perl
while (<>) {
    chomp;
    my ($dir,$flags,$file) = split " ";
    my %flags;
    for my $flag (split ",", $flags) {
	$flags{$flag} = 1;
    }
    next unless $flags{CLOSE_WRITE};
    if ($dir =~ /^\.\/linux\// &&
	$dir !~ /^\.\/linux\/o(|-.*)\//) {
	warn "linux changed ($dir)";
	system("touch stamp/linux");
    }
    for my $module (qw(busybox kexec-tools)) {
	if (substr($dir, 0, length($module) + 2) eq "./$module") {
	    warn "$module changed ($dir)";
	    system("touch stamp/$module");
	}
    }
}
