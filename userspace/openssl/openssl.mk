ifeq ($(filter openssl.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/openssl,install): $(call done,userspace/openssl,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build install
	$(INSTALL_LIBS) userspace/openssl
	$(TIMESTAMP)
else
$(call done,userspace/openssl,install): $(BUILD)/artifacts/openssl.tar.zstd/extract | $(call done,userspace/openssl,)/
	$(TIMESTAMP)
endif

$(call done,userspace/openssl,build): $(call done,userspace/openssl,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build CFLAGS="$(CROSS_CFLAGS)"
	$(TIMESTAMP)

$(call done,userspace/openssl,configure): $(call done,userspace/openssl,copy) | $(call deps,glibc gcc) builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/openssl/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" ./Configure linux-aarch64 --prefix=$(call install,userspace/openssl))
	$(TIMESTAMP)

$(call done,userspace/openssl,copy): | $(call done,userspace/openssl,checkout) $(call done,userspace/openssl,) $(BUILD)/userspace/openssl/build/
	$(COPY_SAUNA) $(PWD)/userspace/openssl/openssl/* $(BUILD)/userspace/openssl/build/
	$(TIMESTAMP)

$(call done,userspace/openssl,checkout): | $(call done,userspace/openssl,)
	$(MAKE) userspace/openssl/openssl{checkout}
	$(TIMESTAMP)

userspace-modules += openssl
