$(BUILD)/userspace/popt/done/install: $(BUILD)/userspace/popt/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/popt/popt.tar: $(BUILD)/userspace/popt/done/build
	tar -C $(BUILD)/userspace/popt -cf $@ done build

$(BUILD)/userspace/popt/done/build: $(BUILD)/userspace/popt/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build
	@touch $@

$(BUILD)/userspace/popt/done/configure: $(BUILD)/userspace/popt/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/userspace/popt/done/copy: $(BUILD)/userspace/popt/done/checkout | $(BUILD)/userspace/popt/done/ $(BUILD)/userspace/popt/build/
	$(CP) -aus $(PWD)/userspace/popt/popt/* $(BUILD)/userspace/popt/build/
	@touch $@

$(BUILD)/userspace/popt/done/checkout: | $(BUILD)/userspace/popt/done/
	$(MAKE) userspace/popt/popt{checkout}
	@touch $@

userspace-modules += popt
