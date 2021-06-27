kernels = linux stage2 pearl

$(BUILD)/linux/%.config: linux/%.config ; $(COPY)

$(BUILD)/linux/debian.config: linux/pearl.config
	sed -e 's/pearl\.cpio/debian.cpio/g' < $< > $@

$(BUILD)/linux/%.image: $(BUILD)/linux/%.config $(BUILD)/linux/done/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/Image $@

$(BUILD)/linux/%.image.d/sendfile: $(BUILD)/linux/%.image | $(BUILD)/linux/%.image.d/
	echo "#!/bin/sh" > $@
	echo "kexec --mem-min=0x900000000 -fix $*.image --dtb=/sys/firmware/fdt" >> $@
	chmod u+x $@

$(BUILD)/linux/pearl.dtb: $(BUILD)/linux/pearl.config $(BUILD)/linux/done/pearl/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/dts/apple/apple-m1-minimal.dtb $@

$(BUILD)/linux/%.dtb: $(BUILD)/linux/%.config $(BUILD)/linux/done/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $@

$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/done/pearl/build: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/done/pearl/build: $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/debian.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/debian.image: $(BUILD)/linux/debian.cpio

$(BUILD)/linux/done/debian/build: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/done/debian/build: $(BUILD)/linux/debian.cpio

$(BUILD)/linux/pearl.dts: linux/pearl.dts ; $(COPY)

$(BUILD)/linux/%.modules: $(BUILD)/linux/done/%/build
	rm -rf $@.d
	$(MKDIR) $@.d
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) INSTALL_MOD_PATH=$@.d modules_install
	$(TAR) -C $@.d -c . -f $@

$(BUILD)/linux/done/%/build: $(BUILD)/linux/done/%/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) Image
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) dtbs
	@touch $@

$(BUILD)/linux/done/%/configure: $(BUILD)/linux/%.config $(BUILD)/linux/done/%/copy $(BUILD)/gcc/done/gcc/install
	$(CP) $< $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	@touch $@

linux/%{menuconfig}: linux/%.config $(BUILD)/linux/done/%/copy $(BUILD)/gcc/done/gcc/install
	$(CP) $< $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) $(BUILD)/linux/$*/build/.config $<

$(BUILD)/linux/done/%/copy: $(BUILD)/linux/done/checkout | $(BUILD)/linux/done/%/ $(BUILD)/linux/%/build/
	$(CP) -aus $(PWD)/linux/linux/* $(BUILD)/linux/$*/build/
	@touch $@

$(BUILD)/linux/done/headers/install: $(BUILD)/linux/done/headers/copy | $(BUILD)/pearl/done/install/mkdir
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/pearl/install headers_install
	@touch $@

$(BUILD)/linux/done/headers/copy: $(BUILD)/linux/done/checkout | $(BUILD)/linux/done/headers/ $(BUILD)/linux/headers/source/
	$(CP) -aus $(PWD)/linux/linux/* $(BUILD)/linux/headers/source/
	@touch $@

$(BUILD)/linux/done/checkout: | $(BUILD)/linux/done/
	$(MAKE) linux/linux{checkout}
	@touch $@

$(call pearl-static,$(wildcard $(PWD)/linux/pearl/bin/*),$(PWD)/linux/pearl)

{non-intermediate}: $(BUILD)/linux/done/headers/copy $(BUILD)/linux/done/headers/configure
