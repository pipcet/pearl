kernels = linux stage2 pearl

$(BUILD)/linux/%.image: linux/%.config $(BUILD)/done/linux/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/Image $@

$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/pearl.dts: linux/pearl.dts ; $(COPY)

$(BUILD)/done/linux/%/build: $(BUILD)/done/linux/%/configure
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) Image
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	@touch $@

$(BUILD)/done/linux/%/configure: linux/%.config $(BUILD)/done/linux/%/copy
	cp $< $(BUILD)/linux/$*/build/.config
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	@touch $@

$(BUILD)/done/linux/%/copy: | $(BUILD)/done/linux/%/ $(BUILD)/linux/%/build/
	cp -a linux/linux/* $(BUILD)/linux/$*/build/
	@touch $@

$(BUILD)/done/linux/headers/install: $(BUILD)/done/linux/headers/copy $(BUILD)/done/gcc/stage1/install
	$(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/install headers_install
	@touch $@

$(BUILD)/done/linux/headers/copy: $(BUILD)/done/linux/checkout | $(BUILD)/done/linux/headers/ $(BUILD)/linux/headers/source/
	$(CP) -a linux/linux/* $(BUILD)/linux/headers/source/
	@touch $@

$(BUILD)/done/linux/checkout: linux/linux{checkout}
	@touch $@
