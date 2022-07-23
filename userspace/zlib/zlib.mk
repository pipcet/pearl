DEP_zlib += $(call done,userspace/zlib,install)
$(call done,userspace/zlib,install): $(call done,userspace/zlib,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build install
	@touch $@

$(call done,userspace/zlib,build): $(call done,userspace/zlib,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(call done,userspace/zlib,configure): $(call done,userspace/zlib,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/zlib/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" ./configure --prefix=$(BUILD)/pearl/install)
	@touch $@

$(call done,userspace/zlib,copy): $(call done,userspace/zlib,checkout) | $(call done,userspace/zlib,) $(BUILD)/userspace/zlib/build/
	$(COPY_SAUNA) $(PWD)/userspace/zlib/zlib/* $(BUILD)/userspace/zlib/build/
	@touch $@

$(call done,userspace/zlib,checkout): | $(call done,userspace/zlib,)
	$(MAKE) userspace/zlib/zlib{checkout}
	@touch $@

userspace-modules += zlib
