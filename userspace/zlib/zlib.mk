$(BUILD)/zlib/done/install: $(BUILD)/zlib/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zlib/build install
	@touch $@

$(BUILD)/zlib/done/build: $(BUILD)/zlib/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zlib/build CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/zlib/done/configure: $(BUILD)/zlib/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/zlib/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" ./configure --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/zlib/done/copy: $(BUILD)/zlib/done/checkout | $(BUILD)/zlib/done/ $(BUILD)/zlib/build/
	$(CP) -aus $(PWD)/userspace/zlib/zlib/* $(BUILD)/zlib/build/
	@touch $@

$(BUILD)/zlib/done/checkout: | $(BUILD)/zlib/done/
	$(MAKE) userspace/zlib/zlib{checkout}
	@touch $@

userspace-modules += zlib
