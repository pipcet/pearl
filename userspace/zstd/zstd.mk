$(BUILD)/userspace/zstd/done/install: $(BUILD)/userspace/zstd/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/userspace/zstd/done/build: $(BUILD)/userspace/zstd/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/
	@touch $@

$(BUILD)/userspace/zstd/done/configure: $(BUILD)/userspace/zstd/done/copy $(call deps,glibc gcc libgcc)
	@touch $@

$(BUILD)/userspace/zstd/done/copy: $(BUILD)/userspace/zstd/done/checkout | $(BUILD)/userspace/zstd/done/ $(BUILD)/userspace/zstd/build/
	$(CP) -aus $(PWD)/userspace/zstd/zstd/* $(BUILD)/userspace/zstd/build/
	@touch $@

$(BUILD)/userspace/zstd/done/checkout: | $(BUILD)/userspace/zstd/done/
	$(MAKE) userspace/zstd/zstd{checkout}
	@touch $@

userspace-modules += zstd
