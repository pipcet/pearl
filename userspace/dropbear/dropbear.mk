$(BUILD)/dropbear/done/install: $(BUILD)/dropbear/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/dropbear/build PROGRAMS="dropbear dbclient scp" install
	@touch $@

$(BUILD)/dropbear/done/build: $(BUILD)/dropbear/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/dropbear/build PROGRAMS="dropbear dbclient scp"
	@touch $@

$(BUILD)/dropbear/done/configure: $(BUILD)/dropbear/done/copy $(call deps,glibc gcc zlib)
	(cd $(BUILD)/dropbear/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc ./configure CFLAGS="$(CROSS_CFLAGS)" --host=x86_64-pc-linux-gnu --disable-harden --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/dropbear/done/copy: $(BUILD)/dropbear/done/checkout | $(BUILD)/dropbear/done/ $(BUILD)/dropbear/build/
	$(CP) -aus $(PWD)/userspace/dropbear/dropbear/* $(BUILD)/dropbear/build/
	@touch $@

$(BUILD)/dropbear/done/checkout: | $(BUILD)/dropbear/done/
	$(MAKE) userspace/dropbear/dropbear{checkout}
	@touch $@

userspace-modules += dropbear
