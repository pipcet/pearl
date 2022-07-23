$(call done,userspace/dialog,install): $(call done,userspace/dialog,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build install
	@touch $@

$(call done,userspace/dialog,build): $(call done,userspace/dialog,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build
	@touch $@

$(call done,userspace/dialog,configure): $(call done,userspace/dialog,copy) $(call done,userspace/glibc,glibc/install) $(call done,toolchain/gcc,gcc/install) $(call deps,ncurses glibc gcc)
	(cd $(BUILD)/userspace/dialog/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	@touch $@

$(call done,userspace/dialog,copy): $(call done,userspace/dialog,checkout) | $(call done,userspace/dialog,) $(BUILD)/userspace/dialog/build/
	$(CP) -aus $(PWD)/userspace/dialog/dialog/* $(BUILD)/userspace/dialog/build/
	@touch $@

$(call done,userspace/dialog,checkout): | $(call done,userspace/dialog,)
	$(MAKE) userspace/dialog/dialog{checkout}
	@touch $@

userspace-modules += dialog
