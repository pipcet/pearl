define linux-perstage
build/stages/$(stage)/linux.config: stages/$(stage)/linux.config
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

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


build/stages/$(stage)/$(stage).image: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(MAKE) -C build/linux/$(stage) ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) Image dtbs
	$$(CP) build/linux/$(stage)/arch/arm64/boot/Image $$@

build/stages/$(stage)/$(stage)-modules.tar: build/stages/$(stage)/$(stage).image
	rm -rf $$@.d
	$$(MKDIR) $$@.d
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) modules
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) INSTALL_MOD_PATH=$$@.d modules_install
	$$(TAR) -C $$@.d -c . > $$@

build/stages/$(stage)/$(stage).dtb: build/stages/$(stage)/$(stage).image
	$$(CP) build/linux/$(stage)/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $$@

build/stages/$(stage)/$(stage).image: stamp/linux

build/initfs/common/boot/$(stage).image: build/stages/$(stage)/$(stage).image
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@
endef

define linux-perimage
build/images/$(image)/linux.config: images/$(image)/linux.config
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

linux/$(image){oldconfig}: build/images/$(image)/linux.config
	$$(MKDIR) build/linux/$(image)
	$$(CP) $$< build/linux/$(image)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(image) oldconfig
	diff -u $$< build/linux/$(image)/.config || true
	$$(CP) $$< $$<.old
	$$(CP) build/linux/$(image)/.config $$<

linux/$(image){menuconfig}:
	$$(MKDIR) build/linux/$(image)
	$$(CP) images/$(image)/linux.config build/linux/$(image)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(image) menuconfig
	diff -u images/$(image)/linux.config build/linux/$(image)/.config || true
	$$(CP) build/linux/$(image)/.config images/$(image)/linux.config


build/images/$(image)/$(image).image: build/images/$(image)/linux.config
	$$(MKDIR) build/linux/$(image)
	$$(CP) $$< build/linux/$(image)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(image) oldconfig
	diff -u $$< build/linux/$(image)/.config || true
	$$(MAKE) -C build/linux/$(image) ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) Image dtbs
	$$(CP) build/linux/$(image)/arch/arm64/boot/Image $$@

build/images/$(image)/$(image).dtb: build/images/$(image)/$(image).image
	$$(CP) build/linux/$(image)/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $$@

build/images/$(image)/$(image).image: stamp/linux

build/initfs/common/boot/$(image).image: build/images/$(image)/$(image).image
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@
endef

build/initfs/common/dt.tar: build/dt.tar
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/common/deb.tar: build/deb.tar
	$(MKDIR) $(dir $@)
	$(CP) $< $@
