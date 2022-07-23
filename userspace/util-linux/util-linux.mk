DEP_libuuid += $(BUILD)/userspace/libuuid/done/install
$(BUILD)/userspace/libuuid/done/install: $(BUILD)/userspace/libuuid/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libuuid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/libuuid/done/build: $(BUILD)/userspace/libuuid/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libuuid/build
	@touch $@

$(BUILD)/userspace/libuuid/done/configure: $(BUILD)/userspace/libuuid/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libuuid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/userspace/libuuid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libuuid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/userspace/libuuid/done/copy: $(BUILD)/userspace/util-linux/done/checkout | $(BUILD)/userspace/libuuid/done/ $(BUILD)/userspace/libuuid/build/
	$(CP) -aus $(PWD)/userspace/util-linux/util-linux/* $(BUILD)/userspace/libuuid/build/
	@touch $@

userspace-modules += libuuid

DEP_libblkid += $(BUILD)/userspace/libblkid/done/install
$(BUILD)/userspace/libblkid/done/install: $(BUILD)/userspace/libblkid/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libblkid/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/libblkid/done/build: $(BUILD)/userspace/libblkid/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libblkid/build
	@touch $@

$(BUILD)/userspace/libblkid/done/configure: $(BUILD)/userspace/libblkid/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libblkid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/userspace/libblkid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libblkid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/userspace/libblkid/done/copy: $(BUILD)/userspace/util-linux/done/checkout | $(BUILD)/userspace/libblkid/done/ $(BUILD)/userspace/libblkid/build/
	$(CP) -aus $(PWD)/userspace/util-linux/util-linux/* $(BUILD)/userspace/libblkid/build/
	@touch $@

userspace-modules += libblkid

$(BUILD)/userspace/util-linux/done/checkout: | $(BUILD)/userspace/util-linux/done/
	$(MAKE) userspace/util-linux/util-linux{checkout}
	@touch $@

