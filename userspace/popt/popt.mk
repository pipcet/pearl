$(BUILD)/popt/done/install: $(BUILD)/popt/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/popt/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/popt/popt.tar: $(BUILD)/popt/done/build
	tar -C $(BUILD)/popt -cf $@ done build

$(BUILD)/popt/done/build: $(BUILD)/popt/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/popt/build
	@touch $@

$(BUILD)/popt/done/configure: $(BUILD)/popt/done/copy
	(cd $(BUILD)/popt/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/popt/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/popt/done/copy: $(BUILD)/popt/done/checkout | $(BUILD)/popt/done/ $(BUILD)/popt/build/
	$(CP) -aus $(PWD)/userspace/popt/popt/* $(BUILD)/popt/build/
	@touch $@

$(BUILD)/popt/done/checkout: | $(BUILD)/popt/done/
	$(MAKE) userspace/popt/popt{checkout}
	@touch $@

userspace-modules += popt
