$(BUILD)/cryptsetup/done/install: $(BUILD)/cryptsetup/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/cryptsetup/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/cryptsetup/done/build: $(BUILD)/cryptsetup/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/cryptsetup/build
	@touch $@

$(BUILD)/cryptsetup/done/configure: $(BUILD)/cryptsetup/done/copy $(BUILD)/libuuid/done/install $(BUILD)/json-c/done/install $(BUILD)/popt/done/install $(BUILD)/libblkid/done/install $(BUILD)/lvm2/done/install $(BUILD)/openssl/done/install $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/cryptsetup/build; PATH="$(CROSS_PATH):$$PATH" sh autogen.sh)
	(cd $(BUILD)/cryptsetup/build; PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --enable-ssh-token=no --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS) -Wl,-rpath -Wl,$(BUILD)/install/lib -Wl,-rpath-link -Wl,$(BUILD)/install/lib" JSON_C_CFLAGS="-I$(BUILD)/install/include" JSON_C_LIBS="-ljson-c")
	@touch $@

$(BUILD)/cryptsetup/done/copy: $(BUILD)/cryptsetup/done/checkout | $(BUILD)/cryptsetup/done/ $(BUILD)/cryptsetup/build/
	cp -a userspace/cryptsetup/cryptsetup/* $(BUILD)/cryptsetup/build/
	@touch $@

$(BUILD)/cryptsetup/done/checkout: userspace/cryptsetup/cryptsetup{checkout} | $(BUILD)/cryptsetup/done/
	@touch $@
