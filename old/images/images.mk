include images/pearl/pearl.mk

include images/debootstrap/debootstrap.mk

$(foreach image,$(linux-images),$(eval $(linux-perimage)))
