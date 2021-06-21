$(BUILD)/libuuid/done/install: $(BUILD)/libuuid/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libuuid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/libuuid/done/build: $(BUILD)/libuuid/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libuuid/build
	@touch $@

$(BUILD)/libuuid/done/configure: $(BUILD)/libuuid/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/libuuid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/libuuid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libuuid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/libuuid/done/copy: $(BUILD)/util-linux/done/checkout | $(BUILD)/libuuid/done/ $(BUILD)/libuuid/build/
	$(CP) -aus userspace/util-linux/util-linux/* $(BUILD)/libuuid/build/
	@touch $@

userspace-modules += libuuid

$(BUILD)/libblkid/done/install: $(BUILD)/libblkid/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libblkid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/libblkid/done/build: $(BUILD)/libblkid/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/libblkid/build
	@touch $@

$(BUILD)/libblkid/done/configure: $(BUILD)/libblkid/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/libblkid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/libblkid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libblkid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/libblkid/done/copy: $(BUILD)/util-linux/done/checkout | $(BUILD)/libblkid/done/ $(BUILD)/libblkid/build/
	$(CP) -aus userspace/util-linux/util-linux/* $(BUILD)/libblkid/build/
	@touch $@

userspace-modules += libblkid

$(BUILD)/util-linux/done/checkout: | $(BUILD)/util-linux/done/
	$(MAKE) userspace/util-linux/util-linux{checkout}
	@touch $@

