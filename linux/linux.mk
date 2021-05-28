define linux-perstage
linux/$(stage){oldconfig}: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(CP) $$< $$<.old
	$$(CP) build/linux/$(stage)/.config $$<

linux/$(stage){menuconfig}:
	$$(MKDIR) build/linux/$(stage)
	$$(CP) stages/$(stage)/linux.config build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) menuconfig
	diff -u stages/$(stage)/linux.config build/linux/$(stage)/.config || true
	$$(CP) build/linux/$(stage)/.config stages/$(stage)/linux.config

build/stages/$(stage)/$(stage).image: build/stages/$(stage)/linux.config build/stages/$(stage)/$(stage).cpiospec
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(MAKE) -C build/linux/$(stage) ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) Image dtbs
	$$(CP) build/linux/$(stage)/arch/arm64/boot/Image $$@

build/stages/$(stage)/$(stage).dtb: build/stages/$(stage)/$(stage).image
	$$(CP) build/linux/$(stage)/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $$@

build/stages/$(stage)/$(stage).image: stamp/linux
endef
