# XXX we need a better way to find the precise latest sid versions of debs
# (without installing all of Debian)

build/deb/Packages: | build/deb/
	curl http://http.us.debian.org/debian/dists/sid/main/binary-arm64/Packages.xz | xzcat > $@
	curl http://http.us.debian.org/debian/dists/sid/main/binary-all/Packages.xz | xzcat >> $@

build/deb/%.deb: build/deb/Packages deb/deb.pl | build/deb/
	curl http://http.us.debian.org/debian/$(shell perl deb/deb.pl "$*" < $<) > $@

libc-debs = libc6 libcrypt1
perl-debs = perl perl-base perl-modules-5.32 libfile-slurp-perl libipc-run-perl
dtc-debs = device-tree-compiler libfdt1 libyaml-0-2
lvm-debs = lvm2 dmsetup dmeventd cryptsetup cryptsetup-bin libblkid1 libcryptsetup12 libpopt0 libuuid1 libdevmapper1.02.1 libdevmapper-event1.02.1

build/deb.tar: \
	$(libc-debs:%=build/deb/%.deb) \
	$(perl-debs:%=build/deb/%.deb) \
	$(dtc-debs:%=build/deb/%.deb) \
	$(lvm-debs:%=build/deb/%.deb)
	rm -rf build/deb-tmp
	$(MKDIR) build/deb-tmp
	for file in $^; do dpkg -x $$file build/deb-tmp; done
	(cd build/deb-tmp; tar c .) > $@
