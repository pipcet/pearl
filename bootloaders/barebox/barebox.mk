bootloaders/barebox/barebox{menuconfig}: bootloaders/barebox/barebox.config | $(BUILD)/barebox/
	$(CP) $< $(BUILD)/barebox/.config
	$(MAKE) -C submodule/barebox ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) build/barebox/.config $<

barebox/barebox{oldconfig}: barebox/barebox.config stamp/barebox | build/barebox/
	$(CP) $< build/barebox/.config
	$(MAKE) -C submodule/barebox oldconfig ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	$(CP) build/barebox/.config $<

$(BUILD)/barebox.image.gz: $(BUILD)/barebox/done/build
	gzip < $< > $@

$(BUILD)/barebox/done/build: $(BUILD)/barebox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/barebox/done/configure: bootloaders/barebox/barebox.config $(BUILD)/barebox/done/copy
	$(CP) $< $(BUILD)/barebox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/barebox/done/copy: $(BUILD)/barebox/done/checkout | $(BUILD)/barebox/done/ $(BUILD)/barebox/build/
	$(CP) -aus $(PWD)/bootloaders/barebox/barebox/* $(BUILD)/barebox/build/
	@touch $@

$(BUILD)/barebox/done/checkout: | $(BUILD)/barebox/done/
	$(MAKE) bootloaders/barebox/barebox{checkout}
	@touch $@

$(call pearl-static,$(wildcard bootloaders/barebox/pearl/bin/*),bootloaders/barebox/pearl)
