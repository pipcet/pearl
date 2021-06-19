$(BUILD)/popt/done/install: $(BUILD)/popt/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/popt/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/popt/popt.tar: $(BUILD)/popt/done/build
	tar -C $(BUILD)/popt -cf $@ done build

$(BUILD)/popt/done/build: $(BUILD)/popt/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/popt/build
	@touch $@

$(BUILD)/popt/done/configure: $(BUILD)/popt/done/copy
	(cd $(BUILD)/popt/build; PATH="$(CROSS_PATH):$$PATH" sh autogen.sh)
	(cd $(BUILD)/popt/build; PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/popt/done/copy: $(BUILD)/popt/done/checkout | $(BUILD)/popt/done/ $(BUILD)/popt/build/
	cp -as $(PWD)/userspace/popt/popt/* $(BUILD)/popt/build/
	@touch $@

$(BUILD)/popt/done/checkout: userspace/popt/popt{checkout} | $(BUILD)/popt/done/
	@touch $@
