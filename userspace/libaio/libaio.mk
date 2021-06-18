$(BUILD)/done/libaio/install: $(BUILD)/done/libaio/build
	$(MAKE) -C $(BUILD)/libaio/build DESTDIR=$(BUILD)/install/ install
	@touch $@

$(BUILD)/done/libaio/build: $(BUILD)/done/libaio/configure
	$(MAKE) -C $(BUILD)/libaio/build
	@touch $@

$(BUILD)/done/libaio/configure: $(BUILD)/done/libaio/copy $(BUILD)/done/libaio/install $(BUILD)/done/libblkid/install $(BUILD)/done/glibc/install $(BUILD)/done/gcc/install
	(cd $(BUILD)/libaio/build; ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/install/lib")
	@touch $@

$(BUILD)/done/libaio/copy: | $(BUILD)/libaio/build/ $(BUILD)/done/libaio/
	cp -a userspace/libaio/libaio/* $(BUILD)/libaio/build
	@touch $@
