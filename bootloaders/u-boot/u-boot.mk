$(BUILD)/u-boot-plus-grub.image: $(BUILD)/u-boot.image.gz $(BUILD)/grub.efi
	(gunzip < $<; cat $(BUILD)/grub.efi) > $@

$(BUILD)/u-boot.dtb: $(BUILD)/u-boot/done/build
	$(CP) $(BUILD)/u-boot/build/u-boot.dtb $@

$(BUILD)/u-boot.image.gz: $(BUILD)/u-boot/done/build
	gzip < $(BUILD)/u-boot/build/u-boot.bin > $@

$(BUILD)/u-boot/done/build: $(BUILD)/u-boot/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/u-boot/done/configure: $(BUILD)/u-boot/done/copy
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) apple_m1_defconfig
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/u-boot/done/copy: $(BUILD)/u-boot/done/checkout | $(BUILD)/u-boot/done/ $(BUILD)/u-boot/build/
	$(CP) -aus $(PWD)/bootloaders/u-boot/u-boot/* $(BUILD)/u-boot/build/
	@touch $@

$(BUILD)/u-boot/done/checkout: | $(BUILD)/u-boot/done/
	$(MAKE) bootloaders/u-boot/u-boot{checkout}
	@touch $@

$(call pearl-static,$(wildcard bootloaders/u-boot/pearl/bin/*),bootloaders/u-boot/pearl)
