#!/usr/bin/perl
my @files = @ARGV;
my $sizes = join(",", map { s/\n//rmsg } map { join("", `wc -c < $_`) } @files);
my $files = join(",", map { '"' . $_ . '"'} map { s/.*\///mrsg } @files);
print <<"EOF";
#!/usr/bin/perl
my \@sizes = ($sizes);
my \$data = join("", <DATA>);
for my \$file ($files) {
    my \$size = shift \@sizes;
    open \$fh, ">\${file}";
    print \$fh substr(\$data, 0, \$size);
    \$data = substr(\$data, \$size);
    close \$fh;
}
system("bash " . [$files]->[0]);
__DATA__
EOF
for my $file (@files) {
    my $fh;
    open $fh, $file or die;
    print join("", <$fh>);
}
