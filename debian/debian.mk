include debian/deb/deb.mk
include debian/debootstrap/debootstrap.mk
include debian/debian-rootfs/debian-rootfs.mk
include debian/installer/installer.mk

$(call pearl-static,$(wildcard $(PWD)/debian/pearl/bin/*),$(PWD)/debian/pearl)
