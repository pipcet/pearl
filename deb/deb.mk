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
lvm-debs = \
	lvm2 \
	cryptsetup \
	cryptsetup-bin \
	dmeventd \
	dmsetup \
	libaio1 \
	libargon2-1 \
	libblkid1 \
	libbsd0 \
	libcryptsetup12 \
	libdevmapper-event1.02.1 \
	libdevmapper1.02.1 \
	libedit2 \
	libgcc-s1 \
	libgcrypt20 \
	libgpg-error0 \
	libjson-c5 \
	liblz4-1 \
	liblzma5 \
	libmd0 \
	libpcre2 \
	libpcre2-8 \
	libpcre2-8-0 \
	libpcre2-16 \
	libpcre2-16-0 \
	libpcre2-32 \
	libpcre2-32-0 \
	libpopt0 \
	libselinux1 \
	libssl1.1 \
	libsystemd0 \
	libtinfo6 \
	libudev1 \
	libuuid1 \
	libzstd1

build/deb.tar: \
	$(libc-debs:%=build/deb/%.deb) \
	$(perl-debs:%=build/deb/%.deb) \
	$(dtc-debs:%=build/deb/%.deb) \
	$(lvm-debs:%=build/deb/%.deb)
	rm -rf build/deb-tmp
	$(MKDIR) build/deb-tmp
	for file in $^; do dpkg -x $$file build/deb-tmp; done
	(cd build/deb-tmp; tar c .) > $@
