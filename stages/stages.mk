define perstage
build/stages/$(stage)/$(stage).image: | build/stages/$(stage)/

build/initfs/common/boot/$(stage).dtb: build/stages/$(stage)/$(stage).dtb
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@
endef

# Linux stages
include stages/stage1/stage1.mk
include stages/stage2/stage2.mk
include stages/linux/linux.mk

# m1n1 stage
include stages/m1n1/m1n1.mk

# macos stage
include stages/macos/macos.mk

# parasite stage
include stages/parasite/parasite.mk

# debian stage
include stages/debian/debian.mk

$(foreach stage,$(stages),$(eval $(perstage)))

$(foreach stage,$(linux-stages),$(eval $(linux-perstage)))
