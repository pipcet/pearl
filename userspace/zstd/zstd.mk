$(call done,userspace/zstd,install): $(call done,userspace/zstd,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(call install,userspace/zstd) install
	$(INSTALL_LIBS) userspace/zstd
	$(TIMESTAMP)

$(call done,userspace/zstd,build): $(call done,userspace/zstd,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zstd/build CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" PREFIX=$(call install,userspace/zstd)
	$(TIMESTAMP)

$(call done,userspace/zstd,configure): $(call done,userspace/zstd,copy) | $(call deps,glibc gcc libgcc)
	$(TIMESTAMP)

$(call done,userspace/zstd,copy): | $(call done,userspace/zstd,checkout) $(call done,userspace/zstd,) $(BUILD)/userspace/zstd/build/
	$(COPY_SAUNA) $(PWD)/userspace/zstd/zstd/* $(BUILD)/userspace/zstd/build/
	$(TIMESTAMP)

$(call done,userspace/zstd,checkout): | $(call done,userspace/zstd,)
	$(MAKE) userspace/zstd/zstd{checkout}
	$(TIMESTAMP)

userspace-modules += zstd
