$(call done,userspace/dialog,install): $(call done,userspace/dialog,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build install
	$(INSTALL_LIBS) userspace/dialog
	$(TIMESTAMP)

$(call done,userspace/dialog,build): $(call done,userspace/dialog,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build
	$(TIMESTAMP)

$(call done,userspace/dialog,configure): $(call done,userspace/dialog,copy) | $(call done,userspace/glibc,glibc/install) $(call done,toolchain/gcc,gcc/install) $(call deps,ncurses glibc gcc)
	(cd $(BUILD)/userspace/dialog/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(call install,userspace/dialog) --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	$(TIMESTAMP)

$(call done,userspace/dialog,copy): $(call done,userspace/dialog,checkout) | $(call done,userspace/dialog,) $(BUILD)/userspace/dialog/build/
	$(COPY_SAUNA) $(PWD)/userspace/dialog/dialog/* $(BUILD)/userspace/dialog/build/
	$(TIMESTAMP)

$(call done,userspace/dialog,checkout): | $(call done,userspace/dialog,)
	$(MAKE) userspace/dialog/dialog{checkout}
	$(TIMESTAMP)

userspace-modules += dialog
