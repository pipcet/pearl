$(BUILD)/userspace/libnl/done/install: $(BUILD)/userspace/libnl/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libnl/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/libnl/done/build: $(BUILD)/userspace/libnl/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libnl/build
	@touch $@

$(BUILD)/userspace/libnl/done/configure: $(BUILD)/userspace/libnl/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libnl/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/libnl/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/userspace/libnl/done/copy: $(BUILD)/userspace/libnl/done/checkout | $(BUILD)/userspace/libnl/done/ $(BUILD)/userspace/libnl/build/
	$(CP) -aus $(PWD)/userspace/libnl/libnl/* $(BUILD)/userspace/libnl/build/
	@touch $@

$(BUILD)/userspace/libnl/done/checkout: | $(BUILD)/userspace/libnl/done/
	$(MAKE) userspace/libnl/libnl{checkout}
	@touch $@

userspace-modules += libnl
