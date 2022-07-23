$(BUILD)/userspace/procps/done/install: $(BUILD)/userspace/procps/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/procps/done/build: $(BUILD)/userspace/procps/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build
	@touch $@

$(BUILD)/userspace/procps/done/configure: $(BUILD)/userspace/procps/done/copy $(call deps,glibc ncurses)
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" PKG_CONFIG_PATH="$(BUILD)/pearl/install/lib/pkgconfig")
	@touch $@

$(BUILD)/userspace/procps/done/copy: $(BUILD)/userspace/procps/done/checkout | $(BUILD)/userspace/procps/done/ $(BUILD)/userspace/procps/build/
	$(CP) -aus $(PWD)/userspace/procps/procps/* $(BUILD)/userspace/procps/build/
	@touch $@

$(BUILD)/userspace/procps/done/checkout: | $(BUILD)/userspace/procps/done/
	$(MAKE) userspace/procps/procps{checkout}
	@touch $@

userspace-modules += procps
