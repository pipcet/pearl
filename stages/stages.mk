define perstage
build/stages/$(stage)/$(stage).image: | build/stages/$(stage)/
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

$(foreach stage,$(stages),$(eval $(perstage)))

$(foreach stage,$(linux-stages),$(eval $(linux-perstage)))
