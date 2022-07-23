$(BUILD)/userspace/dropbear/done/install: $(BUILD)/userspace/dropbear/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp" install
	@touch $@

$(BUILD)/userspace/dropbear/done/build: $(BUILD)/userspace/dropbear/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp"
	@touch $@

$(BUILD)/userspace/dropbear/done/configure: $(BUILD)/userspace/dropbear/done/copy $(call deps,glibc gcc zlib)
	(cd $(BUILD)/userspace/dropbear/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc ./configure CFLAGS="$(CROSS_CFLAGS)" --host=x86_64-pc-linux-gnu --disable-harden --prefix=$(BUILD)/pearl/install)
	@touch $@

$(BUILD)/userspace/dropbear/done/copy: $(BUILD)/userspace/dropbear/done/checkout | $(BUILD)/userspace/dropbear/done/ $(BUILD)/userspace/dropbear/build/
	$(CP) -aus $(PWD)/userspace/dropbear/dropbear/* $(BUILD)/userspace/dropbear/build/
	@touch $@

$(BUILD)/userspace/dropbear/done/checkout: | $(BUILD)/userspace/dropbear/done/
	$(MAKE) userspace/dropbear/dropbear{checkout}
	@touch $@

userspace-modules += dropbear
