kernels = linux stage2 pearl

$(BUILD)/linux/%.image: linux/%.config $(BUILD)/linux/done/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/Image $@

$(BUILD)/linux/%.image.d/sendfile: $(BUILD)/linux/%.image | $(BUILD)/linux/%.image.d/
	echo "#!/bin/sh" > $@
	echo "kexec --mem-max=0x900000000 -fix $*.image --dtb=/sys/firmware/fdt" >> $@
	chmod u+x $@

$(BUILD)/linux/pearl.dtb: linux/pearl.config $(BUILD)/linux/done/pearl/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/dts/apple/apple-m1-minimal.dtb $@

$(BUILD)/linux/%.dtb: linux/%.config $(BUILD)/linux/done/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $@

$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/done/pearl/build: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/done/pearl/build: $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/pearl.dts: linux/pearl.dts ; $(COPY)

$(BUILD)/linux/done/%/build: $(BUILD)/linux/done/%/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) Image dtbs
	@touch $@

$(BUILD)/linux/done/%/configure: linux/%.config $(BUILD)/linux/done/%/copy $(BUILD)/gcc/done/gcc/install
	cp $< $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	@touch $@

linux/%{menuconfig}: linux/%.config $(BUILD)/linux/done/%/copy $(BUILD)/gcc/done/gcc/install
	cp $< $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	cp $(BUILD)/linux/$*/build/config $<
	@touch $@

$(BUILD)/linux/done/%/copy: $(BUILD)/linux/done/checkout | $(BUILD)/linux/done/%/ $(BUILD)/linux/%/build/
	cp -as $(PWD)/linux/linux/* $(BUILD)/linux/$*/build/
	@touch $@

$(BUILD)/linux/done/headers/install: $(BUILD)/linux/done/headers/copy | $(BUILD)/pearl/done/install/mkdir
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/pearl/install headers_install
	@touch $@

$(BUILD)/linux/done/headers/copy: $(BUILD)/linux/done/checkout | $(BUILD)/linux/done/headers/ $(BUILD)/linux/headers/source/
	$(CP) -as $(PWD)/linux/linux/* $(BUILD)/linux/headers/source/
	@touch $@

$(BUILD)/linux/done/checkout: linux/linux{checkout} | $(BUILD)/linux/done/
	@touch $@

$(call pearl-static,$(wildcard $(PWD)/local/linux/pearl/bin/*),$(PWD)/local/linux/pearl)
