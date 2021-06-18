$(BUILD)/popt/done/install: $(BUILD)/popt/done/build
	$(MAKE) -C $(BUILD)/popt/build DESTDIR="$(BUILD)/install" install
	@touch $@

$(BUILD)/popt/done/build: $(BUILD)/popt/done/configure
	$(MAKE) -C $(BUILD)/popt/build
	@touch $@

$(BUILD)/popt/done/configure: $(BUILD)/popt/done/copy
	(cd $(BUILD)/popt/build; sh autogen.sh)
	(cd $(BUILD)/popt/build; ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/popt/done/copy: $(BUILD)/popt/done/checkout | $(BUILD)/popt/done/ $(BUILD)/popt/build/
	cp -a userspace/popt/popt/* $(BUILD)/popt/build/
	@touch $@

$(BUILD)/popt/done/checkout: userspace/popt/popt{checkout} | $(BUILD)/popt/done/
	@touch $@
