$(BUILD)/done/popt/install: $(BUILD)/done/popt/build
	$(MAKE) -C $(BUILD)/popt/build DESTDIR="$(BUILD)/install" install
	@touch $@

$(BUILD)/done/popt/build: $(BUILD)/done/popt/configure
	$(MAKE) -C $(BUILD)/popt/build
	@touch $@

$(BUILD)/done/popt/configure: $(BUILD)/done/popt/copy
	(cd $(BUILD)/popt/build; sh autogen.sh)
	(cd $(BUILD)/popt/build; ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/popt/copy: | $(BUILD)/done/popt/ $(BUILD)/popt/build/
	cp -a userspace/popt/popt/* $(BUILD)/popt/build/
	@touch $@
