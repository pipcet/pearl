# XXX we need a better way to find the precise latest sid versions of debs
# (without installing all of Debian)

build/deb/Packages: | build/deb/
	curl http://http.us.debian.org/debian/dists/sid/main/binary-arm64/Packages.xz | xzcat > $@
	curl http://http.us.debian.org/debian/dists/sid/main/binary-all/Packages.xz | xzcat >> $@

build/deb/%.deb: build/deb/Packages deb/deb.pl | build/deb/
	curl http://http.us.debian.org/debian/$(shell perl deb/deb.pl "$*" < $<) > $@

build/deb.tar: \
	build/deb/libc6.deb \
	build/deb/libcrypt1.deb \
	build/deb/perl.deb \
	build/deb/perl-base.deb \
	build/deb/perl-modules-5.32.deb \
	build/deb/libfile-slurp-perl.deb \
	build/deb/libipc-run-perl.deb \
	build/deb/device-tree-compiler.deb \
	build/deb/libfdt1.deb \
	build/deb/libyaml-0-2.deb
	$(MKDIR) build/deb-tmp
	for file in $^; do dpkg -x $$file build/deb-tmp; done
	(cd build/deb-tmp; tar c .) > $@
