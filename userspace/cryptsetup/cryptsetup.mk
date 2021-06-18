$(BUILD)/done/cryptsetup/install: $(BUILD)/done/cryptsetup/build
	$(MAKE) -C $(BUILD)/cryptsetup/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/cryptsetup/build: $(BUILD)/done/cryptsetup/configure
	$(MAKE) -C $(BUILD)/cryptsetup/build
	@touch $@

$(BUILD)/done/cryptsetup/configure: $(BUILD)/done/cryptsetup/copy $(BUILD)/done/libuuid/install $(BUILD)/done/json-c/install $(BUILD)/done/popt/install $(BUILD)/done/libblkid/install $(BUILD)/done/lvm2/install $(BUILD)/done/openssl/install $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/cryptsetup/build; sh autogen.sh)
	(cd $(BUILD)/cryptsetup/build; ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" JSON_C_CFLAGS="-I$(BUILD)/install/include" JSON_C_LIBS="-ljson-c")
	@touch $@

$(BUILD)/done/cryptsetup/copy: | $(BUILD)/done/cryptsetup/ $(BUILD)/cryptsetup/build/
	cp -a userspace/cryptsetup/cryptsetup/* $(BUILD)/cryptsetup/build/
	@touch $@
