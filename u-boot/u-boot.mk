build/u-boot/u-boot.img: stamp/u-boot | build/u-boot/
	$(MAKE) -C submodule/u-boot O=$(PWD)/build/u-boot CROSS_COMPILE=$(CROSS_COMPILE) apple_m1_defconfig
	$(MAKE) -C submodule/u-boot O=$(PWD)/build/u-boot CROSS_COMPILE=$(CROSS_COMPILE)
