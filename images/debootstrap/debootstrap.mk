images += debootstrap
linux-images += debootstrap

build/images/debootstrap/debootstrap.image: | build/images/debootstrap/
build/images/debootstrap/debootstrap.image: build/packs/debootstrap.cpio

build/images/debootstrap/debootstrap.image: build/images/debootstrap/debootstrap.dts.dtb.h

build/images/debootstrap/debootstrap.dts: images/debootstrap/debootstrap.dts
	$(MKDIR) $(dir $@)
	$(CP) $< $@
