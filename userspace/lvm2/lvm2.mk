$(BUILD)/done/lvm2/install: $(BUILD)/done/lvm2/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/lvm2/build DESTDIR=$(BUILD)/install/ install
	@touch $@

$(BUILD)/done/lvm2/build: $(BUILD)/done/lvm2/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/lvm2/build
	@touch $@

$(BUILD)/done/lvm2/configure: $(BUILD)/done/lvm2/copy $(BUILD)/done/libaio/install $(BUILD)/done/libblkid/install $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/lvm2/build; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/install/lib")
	@touch $@

$(BUILD)/done/lvm2/copy: $(BUILD)/done/lvm2/checkout | $(BUILD)/lvm2/build/ $(BUILD)/done/lvm2/
	cp -a userspace/lvm2/lvm2/* $(BUILD)/lvm2/build
	@touch $@

$(BUILD)/done/lvm2/checkout: userspace/lvm2/lvm2{checkout} | $(BUILD)/done/lvm2/
	@touch $@

