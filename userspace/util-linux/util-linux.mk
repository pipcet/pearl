$(BUILD)/libuuid/done/install: $(BUILD)/libuuid/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libuuid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/libuuid/done/build: $(BUILD)/libuuid/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libuuid/build
	@touch $@

$(BUILD)/libuuid/done/configure: $(BUILD)/libuuid/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/libuuid/build; PATH="$(CROSS_PATH):$$PATH" autoreconf -fi)
	(cd $(BUILD)/libuuid/build; PATH="$(CROSS_PATH):$$PATH" ./configure --disable-all-programs --enable-libuuid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/libuuid/done/copy: $(BUILD)/util-linux/done/checkout | $(BUILD)/libuuid/done/ $(BUILD)/libuuid/build/
	cp -a userspace/util-linux/util-linux/* $(BUILD)/libuuid/build/
	@touch $@

$(BUILD)/libblkid/done/install: $(BUILD)/libblkid/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libblkid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/libblkid/done/build: $(BUILD)/libblkid/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libblkid/build
	@touch $@

$(BUILD)/libblkid/done/configure: $(BUILD)/libblkid/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/libblkid/build; PATH="$(CROSS_PATH):$$PATH" autoreconf -fi)
	(cd $(BUILD)/libblkid/build; PATH="$(CROSS_PATH):$$PATH" ./configure --disable-all-programs --enable-libblkid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/libblkid/done/copy: $(BUILD)/util-linux/done/checkout | $(BUILD)/libblkid/done/ $(BUILD)/libblkid/build/
	cp -a userspace/util-linux/util-linux/* $(BUILD)/libblkid/build/
	@touch $@

$(BUILD)/util-linux/done/checkout: userspace/util-linux/util-linux{checkout} | $(BUILD)/util-linux/done/
	@touch $@
