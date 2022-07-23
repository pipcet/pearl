$(BUILD)/userspace/openssl/done/install: $(BUILD)/userspace/openssl/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build install
	@touch $@

$(BUILD)/userspace/openssl/done/build: $(BUILD)/userspace/openssl/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/userspace/openssl/done/configure: $(BUILD)/userspace/openssl/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/openssl/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" ./Configure linux-aarch64 --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/userspace/openssl/done/copy: $(BUILD)/userspace/openssl/done/checkout | $(BUILD)/userspace/openssl/done/ $(BUILD)/userspace/openssl/build/
	$(CP) -aus $(PWD)/userspace/openssl/openssl/* $(BUILD)/userspace/openssl/build/
	@touch $@

$(BUILD)/userspace/openssl/done/checkout: | $(BUILD)/userspace/openssl/done/
	$(MAKE) userspace/openssl/openssl{checkout}
	@touch $@

userspace-modules += openssl
