$(call done,userspace/zstd,install): $(call done,userspace/zstd,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/ install
	@touch $@

$(call done,userspace/zstd,build): $(call done,userspace/zstd,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(BUILD)/pearl/install/
	@touch $@

$(call done,userspace/zstd,configure): $(call done,userspace/zstd,copy) $(call deps,glibc gcc libgcc)
	@touch $@

$(call done,userspace/zstd,copy): $(call done,userspace/zstd,checkout) | $(call done,userspace/zstd,) $(BUILD)/userspace/zstd/build/
	$(CP) -aus $(PWD)/userspace/zstd/zstd/* $(BUILD)/userspace/zstd/build/
	@touch $@

$(call done,userspace/zstd,checkout): | $(call done,userspace/zstd,)
	$(MAKE) userspace/zstd/zstd{checkout}
	@touch $@

userspace-modules += zstd
