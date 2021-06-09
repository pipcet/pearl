# XXX we need a better way to find the precise latest sid versions of debs
# (without installing all of Debian)

build/deb/Packages: | build/deb/
	curl http://http.us.debian.org/debian/dists/sid/main/binary-arm64/Packages.xz | xzcat > $@
	curl http://http.us.debian.org/debian/dists/sid/main/binary-all/Packages.xz | xzcat >> $@

build/deb/%.deb: build/deb/Packages deb/deb.pl | build/deb/
	curl http://http.us.debian.org/debian/$(shell perl deb/deb.pl "$*" < $<) > $@

dialog-debs = \
	dialog \
	libncursesw6

screen-debs = \
	screen \
	libtinfo6 \
	libutempter0 \
	libpam0g \
	libaudit1 \
	libcap-ng0 \
	libaudit-common \
	terminfo \
	ncurses-base

dropbear-debs = \
	dropbear-bin \
	libgmp10 \
	libtomcrypt1 \
	libtommath1 \
	zlib1g

mojo-debs = \
	libmojolicious-perl \
	libmojo-ioloop-readwriteprocess-perl

wifi-debs = \
	wpasupplicant \
	libdbus-1-3 \
	libnl-3-200 \
	libnl-genl-3-200 \
	libnl-route-3-200 \
	libpcsclite1 \
	libssl1.1 \
	libsystemd0 \
	dhcpcd5

libc-debs = libc6 libcrypt1
perl-debs = perl perl-base perl-modules-5.32 libfile-slurp-perl libipc-run-perl libsys-mmap-perl
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
	libpcre2-8-0 \
	libpcre2-16-0 \
	libpcre2-32-0 \
	libpopt0 \
	libselinux1 \
	libssl1.1 \
	libsystemd0 \
	libtinfo6 \
	libudev1 \
	libuuid1 \
	libzstd1

debs = libc perl dtc lvm mojo wifi dropbear screen

build/deb.tar: \
	$(libc-debs:%=build/deb/%.deb) \
	$(perl-debs:%=build/deb/%.deb) \
	$(dtc-debs:%=build/deb/%.deb) \
	$(lvm-debs:%=build/deb/%.deb) \
	$(mojo-debs:%=build/deb/%.deb) \
	$(wifi-debs:%=build/deb/%.deb) \
	$(dropbear-debs:%=build/deb/%.deb) \
	$(screen-debs:%=build/deb/%.deb) \
	$(dialog-debs:%=build/deb/%.deb)
	rm -rf build/deb-tmp build/deb-tmp-ar
	$(MKDIR) build/deb-tmp build/deb-tmp-ar
	for file in $^; do if which dpkg > /dev/null 2>&1; then dpkg -x $$file build/deb-tmp; else ar -x $$file --output build/deb-tmp-ar && tar -C build/deb-tmp -axf build/deb-tmp-ar/data.tar.*; rm -rf build/deb-tmp-ar; fi; done
	(cd build/deb-tmp; tar c .) > $@
