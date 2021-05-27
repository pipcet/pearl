# XXX we need a better way to find the precise latest sid versions of debs
# (without installing all of Debian)

deb/perl.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl_5.32.1-4_arm64.deb

deb/perl-modules.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl-modules-5.32_5.32.1-4_all.deb

deb/perl-base.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl-base_5.32.1-4_arm64.deb

deb/libfile-slurp-perl.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/libf/libfile-slurp-perl/libfile-slurp-perl_9999.32-1_all.deb

deb/libipc-run-perl.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/libi/libipc-run-perl/libipc-run-perl_20200505.0-1_all.deb

deb/device-tree-compiler.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.6.0-1_arm64.deb

deb/libfdt1.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/d/device-tree-compiler/libfdt1_1.6.0-1_arm64.deb

deb/libyaml.deb: | deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/liby/libyaml/libyaml-0-2_0.2.2-1_arm64.deb
