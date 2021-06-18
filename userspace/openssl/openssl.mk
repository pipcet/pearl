$(BUILD)/done/openssl/install: $(BUILD)/done/openssl/build
	$(MAKE) -C $(BUILD)/openssl/build install
	@touch $@

$(BUILD)/done/openssl/build: $(BUILD)/done/openssl/configure
	$(MAKE) -C $(BUILD)/openssl/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/done/openssl/configure: $(BUILD)/done/openssl/copy
	(cd $(BUILD)/openssl/build/; CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" ./Configure linux-aarch64 --prefix=$(BUILD)/install)

$(BUILD)/done/openssl/copy: | $(BUILD)/done/openssl/ $(BUILD)/openssl/build/
	cp -a userspace/openssl/openssl/* $(BUILD)/openssl/build/
	@touch $@
