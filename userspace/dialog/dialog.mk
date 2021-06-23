$(BUILD)/dialog/done/install: $(BUILD)/dialog/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/dialog/build install
	@touch $@

$(BUILD)/dialog/done/build: $(BUILD)/dialog/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/dialog/build
	@touch $@

$(BUILD)/dialog/done/configure: $(BUILD)/dialog/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/dialog/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	@touch $@

$(BUILD)/dialog/done/copy: $(BUILD)/dialog/done/checkout | $(BUILD)/dialog/done/ $(BUILD)/dialog/build/
	$(CP) -aus $(PWD)/userspace/dialog/dialog/* $(BUILD)/dialog/build/
	@touch $@

$(BUILD)/dialog/done/checkout: | $(BUILD)/dialog/done/
	$(MAKE) userspace/dialog/dialog{checkout}
	@touch $@

userspace-modules += dialog
