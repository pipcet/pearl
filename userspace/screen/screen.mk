$(BUILD)/screen/done/install: $(BUILD)/screen/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/screen/build/src DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/screen/done/build: $(BUILD)/screen/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/screen/build/src
	@touch $@

$(BUILD)/screen/done/configure: $(BUILD)/screen/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/ncurses/done/install
	(cd $(BUILD)/screen/build/src; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/screen/build/src; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ --enable-pam=no CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/screen/done/copy: $(BUILD)/screen/done/checkout | $(BUILD)/screen/done/ $(BUILD)/screen/build/
	$(CP) -aus $(PWD)/userspace/screen/screen/* $(BUILD)/screen/build/
	@touch $@

$(BUILD)/screen/done/checkout: | $(BUILD)/screen/done/
	$(MAKE) userspace/screen/screen{checkout}
	@touch $@

userspace-modules += screen
