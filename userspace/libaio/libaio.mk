DEP_libaio += $(BUILD)/userspace/libaio/done/install
$(BUILD)/userspace/libaio/done/install: $(BUILD)/userspace/libaio/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" DESTDIR=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/userspace/libaio/done/build: $(BUILD)/userspace/libaio/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -I."
	@touch $@

$(BUILD)/userspace/libaio/done/configure: $(BUILD)/userspace/libaio/done/copy $(call deps,libblkid glibc gcc)
	@touch $@

$(BUILD)/userspace/libaio/done/copy: $(BUILD)/userspace/libaio/done/checkout | $(BUILD)/userspace/libaio/build/ $(BUILD)/userspace/libaio/done/
	$(CP) -aus $(PWD)/userspace/libaio/libaio/* $(BUILD)/userspace/libaio/build
	@touch $@

$(BUILD)/userspace/libaio/done/checkout: | $(BUILD)/userspace/libaio/done/
	$(MAKE) userspace/libaio/libaio{checkout}
	@touch $@

userspace-modules += libaio
