$(BUILD)/zstd/done/install: $(BUILD)/zstd/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/zstd/done/build: $(BUILD)/zstd/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/
	@touch $@

$(BUILD)/zstd/done/configure: $(BUILD)/zstd/done/copy $(call deps,glibc gcc libgcc)
	@touch $@

$(BUILD)/zstd/done/copy: $(BUILD)/zstd/done/checkout | $(BUILD)/zstd/done/ $(BUILD)/zstd/build/
	$(CP) -aus $(PWD)/userspace/zstd/zstd/* $(BUILD)/zstd/build/
	@touch $@

$(BUILD)/zstd/done/checkout: | $(BUILD)/zstd/done/
	$(MAKE) userspace/zstd/zstd{checkout}
	@touch $@

userspace-modules += zstd
