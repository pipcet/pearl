$(BUILD)/userspace/cryptsetup/done/install: $(BUILD)/userspace/cryptsetup/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/cryptsetup/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/cryptsetup/done/build: $(BUILD)/userspace/cryptsetup/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/cryptsetup/build
	@touch $@

$(BUILD)/userspace/cryptsetup/done/configure: $(BUILD)/userspace/cryptsetup/done/copy $(BUILD)/userspace/libuuid/done/install $(BUILD)/userspace/json-c/done/install $(BUILD)/userspace/popt/done/install $(BUILD)/userspace/libblkid/done/install $(BUILD)/userspace/lvm2/done/install $(BUILD)/userspace/openssl/done/install $(BUILD)/userspace/glibc/done/glibc/install $(BUILD)/toolchain/gcc/done/gcc/install
	(cd $(BUILD)/userspace/cryptsetup/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/cryptsetup/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --enable-ssh-token=no --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS) -Wl,-rpath-link -Wl,$(BUILD)/pearl/install/lib" JSON_C_CFLAGS="-I$(BUILD)/pearl/install/include -I$(BUILD)/pearl/install/include/json-c" JSON_C_LIBS="-ljson-c")
	@touch $@

$(BUILD)/userspace/cryptsetup/done/copy: $(BUILD)/userspace/cryptsetup/done/checkout | $(BUILD)/userspace/cryptsetup/done/ $(BUILD)/userspace/cryptsetup/build/
	$(CP) -aus $(PWD)/userspace/cryptsetup/cryptsetup/* $(BUILD)/userspace/cryptsetup/build/
	@touch $@

$(BUILD)/userspace/cryptsetup/done/checkout: | $(BUILD)/userspace/cryptsetup/done/
	$(MAKE) userspace/cryptsetup/cryptsetup{checkout}
	@touch $@

userspace-modules += cryptsetup

