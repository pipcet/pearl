$(call done,userspace/libnl,install): $(call done,userspace/libnl,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libnl/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(call done,userspace/libnl,build): $(call done,userspace/libnl,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libnl/build
	@touch $@

$(call done,userspace/libnl,configure): $(call done,userspace/libnl,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libnl/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/libnl/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(call done,userspace/libnl,copy): $(call done,userspace/libnl,checkout) | $(call done,userspace/libnl,) $(BUILD)/userspace/libnl/build/
	$(COPY_SAUNA) $(PWD)/userspace/libnl/libnl/* $(BUILD)/userspace/libnl/build/
	@touch $@

$(call done,userspace/libnl,checkout): | $(call done,userspace/libnl,)
	$(MAKE) userspace/libnl/libnl{checkout}
	@touch $@

userspace-modules += libnl
