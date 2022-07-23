DEP_zlib += $(BUILD)/userspace/zlib/done/install
$(BUILD)/userspace/zlib/done/install: $(BUILD)/userspace/zlib/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build install
	@touch $@

$(BUILD)/userspace/zlib/done/build: $(BUILD)/userspace/zlib/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/userspace/zlib/done/configure: $(BUILD)/userspace/zlib/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/zlib/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" ./configure --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/userspace/zlib/done/copy: $(BUILD)/userspace/zlib/done/checkout | $(BUILD)/userspace/zlib/done/ $(BUILD)/userspace/zlib/build/
	$(CP) -aus $(PWD)/userspace/zlib/zlib/* $(BUILD)/userspace/zlib/build/
	@touch $@

$(BUILD)/userspace/zlib/done/checkout: | $(BUILD)/userspace/zlib/done/
	$(MAKE) userspace/zlib/zlib{checkout}
	@touch $@

userspace-modules += zlib
