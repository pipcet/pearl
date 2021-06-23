DEP_libaio += $(BUILD)/libaio/done/install
$(BUILD)/libaio/done/install: $(BUILD)/libaio/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" DESTDIR=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/libaio/done/build: $(BUILD)/libaio/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -I."
	@touch $@

$(BUILD)/libaio/done/configure: $(BUILD)/libaio/done/copy $(call deps,libblkid glibc gcc)
	@touch $@

$(BUILD)/libaio/done/copy: $(BUILD)/libaio/done/checkout | $(BUILD)/libaio/build/ $(BUILD)/libaio/done/
	$(CP) -aus $(PWD)/userspace/libaio/libaio/* $(BUILD)/libaio/build
	@touch $@

$(BUILD)/libaio/done/checkout: | $(BUILD)/libaio/done/
	$(MAKE) userspace/libaio/libaio{checkout}
	@touch $@

userspace-modules += libaio
