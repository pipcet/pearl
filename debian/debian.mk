include debian/deb/deb.mk
include debian/debootstrap/debootstrap.mk

$(call pearl-static,$(wildcard $(PWD)/debian/pearl/bin/*),$(PWD)/debian/pearl)
