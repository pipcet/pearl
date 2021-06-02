build/u-boot/u-boot.bin: stamp/u-boot | build/u-boot/
	$(MAKE) -C submodule/u-boot O=$(PWD)/build/u-boot CROSS_COMPILE=$(CROSS_COMPILE) apple_m1_defconfig
	$(MAKE) -C submodule/u-boot O=$(PWD)/build/u-boot CROSS_COMPILE=$(CROSS_COMPILE)

build/u-boot.image.gz: build/u-boot/u-boot.bin
	gzip < $< > $@
