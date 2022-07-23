$(BUILD)/userspace/screen/done/install: $(BUILD)/userspace/screen/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/screen/build/src DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/screen/done/build: $(BUILD)/userspace/screen/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/screen/build/src
	@touch $@

$(BUILD)/userspace/screen/done/configure: $(BUILD)/userspace/screen/done/copy $(call deps,glibc ncurses)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) autoreconf --install)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ --enable-pam=no CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/userspace/screen/done/copy: $(BUILD)/userspace/screen/done/checkout | $(BUILD)/userspace/screen/done/ $(BUILD)/userspace/screen/build/
	$(CP) -aus $(PWD)/userspace/screen/screen/* $(BUILD)/userspace/screen/build/
	@touch $@

$(BUILD)/userspace/screen/done/checkout: | $(BUILD)/userspace/screen/done/
	$(MAKE) userspace/screen/screen{checkout}
	@touch $@

userspace-modules += screen
