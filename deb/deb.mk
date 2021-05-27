# XXX we need a better way to find the precise latest sid versions of debs
# (without installing all of Debian)

build/deb/perl.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl_5.32.1-4_arm64.deb

build/deb/perl-modules.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl-modules-5.32_5.32.1-4_all.deb

build/deb/perl-base.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/p/perl/perl-base_5.32.1-4_arm64.deb

build/deb/libfile-slurp-perl.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/libf/libfile-slurp-perl/libfile-slurp-perl_9999.32-1_all.deb

build/deb/libipc-run-perl.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/libi/libipc-run-perl/libipc-run-perl_20200505.0-1_all.deb

build/deb/device-tree-compiler.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.6.0-1_arm64.deb

build/deb/libfdt1.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/d/device-tree-compiler/libfdt1_1.6.0-1_arm64.deb

build/deb/libyaml.deb: | build/deb/
	wget -O $@ http://http.us.debian.org/debian/pool/main/liby/libyaml/libyaml-0-2_0.2.2-1_arm64.deb

build/deb.tar.gz: \
	build/deb/perl.deb \
	build/deb/perl-base.deb \
	build/deb/perl-modules.deb \
	build/deb/libfile-slurp-perl.deb \
	build/deb/libipc-run-perl.deb \
	build/deb/device-tree-compiler.deb \
	build/deb/libfdt1.deb \
	build/deb/libyaml.deb
	$(MKDIR) build/deb-tmp
	for file in $^; do dpkg -x $$file build/deb-tmp; done
	(cd build/deb-tmp; tar cz .) > $@
