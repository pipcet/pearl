kernels = linux stage2 pearl

$(BUILD)/done/linux/%.image: linux/%.config $(BUILD)/done/linux/%/build
	$(CP) $(BUILD)/linux/$*/build/arch/arm64/boot/Image $@

$(BUILD)/done/linux/%/build: $(BUILD)/done/linux/%/configure
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) Image
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	@touch $@

$(BUILD)/done/linux/%/configure: linux/%.config $(BUILD)/done/linux/%/copy
	cp $< $(BUILD)/linux/$*/build/.config
	$(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/done/linux/%/copy: $(BUILD)/done/linux/%/ $(BUILD)/linux/%/build/
	cp -a linux/linux/* $(BUILD)/linux/$*/build/
	@touch $@

$(BUILD)/done/linux/headers/install: $(BUILD)/done/linux/headers/copy $(BUILD)/done/gcc/stage1/install
	$(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/install headers_install
	@touch $@

$(BUILD)/done/linux/headers/copy: | $(BUILD)/done/linux/headers/ $(BUILD)/linux/headers/source/
	$(CP) -a linux/linux/* $(BUILD)/linux/headers/source/
	@touch $@
