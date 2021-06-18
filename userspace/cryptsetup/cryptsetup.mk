$(BUILD)/done/cryptsetup/install: $(BUILD)/done/cryptsetup/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/cryptsetup/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/cryptsetup/build: $(BUILD)/done/cryptsetup/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/cryptsetup/build
	@touch $@

$(BUILD)/done/cryptsetup/configure: $(BUILD)/done/cryptsetup/copy $(BUILD)/done/libuuid/install $(BUILD)/done/json-c/install $(BUILD)/done/popt/install $(BUILD)/done/libblkid/install $(BUILD)/done/lvm2/install $(BUILD)/done/openssl/install $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/cryptsetup/build; PATH="$(CROSS_PATH):$$PATH" sh autogen.sh)
	(cd $(BUILD)/cryptsetup/build; PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --enable-ssh-token=no --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS) -Wl,-rpath -Wl,$(BUILD)/install/lib -Wl,-rpath-link -Wl,$(BUILD)/install/lib" JSON_C_CFLAGS="-I$(BUILD)/install/include" JSON_C_LIBS="-ljson-c")
	@touch $@

$(BUILD)/done/cryptsetup/copy: | $(BUILD)/done/cryptsetup/ $(BUILD)/cryptsetup/build/
	cp -a userspace/cryptsetup/cryptsetup/* $(BUILD)/cryptsetup/build/
	@touch $@
