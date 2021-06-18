$(BUILD)/done/libaio/install: $(BUILD)/done/libaio/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" DESTDIR=$(BUILD)/install/ install
	@touch $@

$(BUILD)/done/libaio/build: $(BUILD)/done/libaio/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -I."
	@touch $@

$(BUILD)/done/libaio/configure: $(BUILD)/done/libaio/copy $(BUILD)/done/libblkid/install $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	@touch $@

$(BUILD)/done/libaio/copy: | $(BUILD)/libaio/build/ $(BUILD)/done/libaio/
	cp -a userspace/libaio/libaio/* $(BUILD)/libaio/build
	@touch $@
