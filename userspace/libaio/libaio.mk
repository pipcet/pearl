$(BUILD)/libaio/done/install: $(BUILD)/libaio/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" DESTDIR=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/libaio/done/build: $(BUILD)/libaio/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -I."
	@touch $@

$(BUILD)/libaio/done/configure: $(BUILD)/libaio/done/copy $(BUILD)/libblkid/done/install $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	@touch $@

$(BUILD)/libaio/done/copy: $(BUILD)/libaio/done/checkout | $(BUILD)/libaio/build/ $(BUILD)/libaio/done/
	cp -a userspace/libaio/libaio/* $(BUILD)/libaio/build
	@touch $@

$(BUILD)/libaio/done/checkout: userspace/libaio/libaio{checkout} | $(BUILD)/libaio/done/
	@touch $@
