packs += debian

common-debian = devdir.cpio kexec.tar
stages-debian = stage2 linux

build/packs/debian.cpiospec: build/packs/debian/debootstrap.tar

build/packs/debian/debootstrap.tar: build/debootstrap/stage15.tar
	$(MKDIR) $(dir $@)
	$(CP) $< $@
