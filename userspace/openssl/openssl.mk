$(BUILD)/openssl/done/install: $(BUILD)/openssl/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/openssl/build install
	@touch $@

$(BUILD)/openssl/done/build: $(BUILD)/openssl/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/openssl/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/openssl/done/configure: $(BUILD)/openssl/done/copy
	(cd $(BUILD)/openssl/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" ./Configure linux-aarch64 --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/openssl/done/copy: $(BUILD)/openssl/done/checkout | $(BUILD)/openssl/done/ $(BUILD)/openssl/build/
	cp -a userspace/openssl/openssl/* $(BUILD)/openssl/build/
	@touch $@

$(BUILD)/openssl/done/checkout: userspace/openssl/openssl{checkout} | $(BUILD)/openssl/done/
	@touch $@
