$(BUILD)/procps/done/install: $(BUILD)/procps/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/procps/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/procps/done/build: $(BUILD)/procps/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/procps/build
	@touch $@

$(BUILD)/procps/done/configure: $(BUILD)/procps/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/ncurses/done/install
	(cd $(BUILD)/procps/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/procps/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ --enable-pam=no CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/procps/done/copy: $(BUILD)/procps/done/checkout | $(BUILD)/procps/done/ $(BUILD)/procps/build/
	$(CP) -aus $(PWD)/userspace/procps/procps/* $(BUILD)/procps/build/
	@touch $@

$(BUILD)/procps/done/checkout: | $(BUILD)/procps/done/
	$(MAKE) userspace/procps/procps{checkout}
	@touch $@

userspace-modules += procps
