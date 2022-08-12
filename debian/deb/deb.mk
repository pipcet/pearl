$(BUILD)/debian/deb/Packages: | $(BUILD)/debian/deb/
	curl http://http.us.debian.org/debian/dists/sid/main/binary-arm64/Packages.xz | xzcat > $@
	curl http://http.us.debian.org/debian/dists/sid/main/binary-all/Packages.xz | xzcat >> $@

$(BUILD)/debian/deb/%.deb: $(BUILD)/debian/deb/Packages debian/deb/deb.pl | $(BUILD)/debian/deb/
	curl http://http.us.debian.org/debian/$(shell perl debian/deb/deb.pl "$*" < $<) > $@

nvme-debs = \
	nvme-cli \
	libuuid1

dialog-debs = \
	dialog \
	libncurses6 \
	libncursesw6

procps-debs = \
	procps \
	libprocps8 \
	libtinfo6 \
	libsystemd0

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

libc-debs = \
	libc6 \
	libcrypt1

perl-debs = \
	perl \
	perl-base \
	perl-modules-5.32 \
	libfile-slurp-perl \
	libipc-run-perl \
	libsys-mmap-perl

dtc-debs = \
	device-tree-compiler \
	libfdt1 \
	libyaml-0-2

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

$(BUILD)/debian/deb.tar: \
	$(libc-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(perl-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(dtc-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(lvm-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(mojo-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(wifi-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(dropbear-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(screen-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(dialog-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(nvme-debs:%=$(BUILD)/debian/deb/%.deb) \
	$(procps-debs:%=$(BUILD)/debian/deb/%.deb)
	rm -rf $(BUILD)/deb-tmp $(BUILD)/deb-tmp-ar
	$(MKDIR) $(BUILD)/deb-tmp $(BUILD)/deb-tmp-ar
	for file in $^; do if which dpkg > /dev/null 2>&1; then dpkg -x $$file $(BUILD)/deb-tmp; else ar -x $$file --output $(BUILD)/deb-tmp-ar && tar -C $(BUILD)/deb-tmp -axf $(BUILD)/deb-tmp-ar/data.tar.*; rm -rf $(BUILD)/deb-tmp-ar; fi; done
	(tar -C $(BUILD)/deb-tmp -cf $@ .)

$(BUILD)/qemu-kernel: $(BUILD)/debian/deb/linux-image-5.18.0-4-cloud-arm64-unsigned.deb
	$(MKDIR) $(BUILD)/kernel
	dpkg --extract $< $(BUILD)/kernel
	cp $(BUILD)/kernel/boot/vmlinuz* $@

# $(call pearl-static,$(BUILD)/debian/deb.tar,$(BUILD))
