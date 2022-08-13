include debian/deb/deb.mk
include debian/debootstrap/debootstrap.mk
include debian/debian-rootfs/debian-rootfs.mk

$(call pearl-static,$(wildcard $(PWD)/debian/pearl/bin/*),$(PWD)/debian/pearl)
