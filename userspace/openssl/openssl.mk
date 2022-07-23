$(call done,userspace/openssl,install): $(call done,userspace/openssl,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build install
	@touch $@

$(call done,userspace/openssl,build): $(call done,userspace/openssl,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/openssl/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(call done,userspace/openssl,configure): $(call done,userspace/openssl,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/openssl/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" ./Configure linux-aarch64 --prefix=$(BUILD)/pearl/install)
	@touch $@

$(call done,userspace/openssl,copy): $(call done,userspace/openssl,checkout) | $(call done,userspace/openssl,) $(BUILD)/userspace/openssl/build/
	$(COPY_SAUNA) $(PWD)/userspace/openssl/openssl/* $(BUILD)/userspace/openssl/build/
	@touch $@

$(call done,userspace/openssl,checkout): | $(call done,userspace/openssl,)
	$(MAKE) userspace/openssl/openssl{checkout}
	@touch $@

userspace-modules += openssl
