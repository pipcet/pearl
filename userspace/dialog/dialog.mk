$(BUILD)/userspace/dialog/done/install: $(BUILD)/userspace/dialog/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build install
	@touch $@

$(BUILD)/userspace/dialog/done/build: $(BUILD)/userspace/dialog/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dialog/build
	@touch $@

$(BUILD)/userspace/dialog/done/configure: $(BUILD)/userspace/dialog/done/copy $(BUILD)/userspace/glibc/done/glibc/install $(BUILD)/toolchain/gcc/done/gcc/install $(call deps,ncurses glibc gcc)
	(cd $(BUILD)/userspace/dialog/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	@touch $@

$(BUILD)/userspace/dialog/done/copy: $(BUILD)/userspace/dialog/done/checkout | $(BUILD)/userspace/dialog/done/ $(BUILD)/userspace/dialog/build/
	$(CP) -aus $(PWD)/userspace/dialog/dialog/* $(BUILD)/userspace/dialog/build/
	@touch $@

$(BUILD)/userspace/dialog/done/checkout: | $(BUILD)/userspace/dialog/done/
	$(MAKE) userspace/dialog/dialog{checkout}
	@touch $@

userspace-modules += dialog
