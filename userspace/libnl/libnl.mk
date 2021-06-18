$(BUILD)/libnl/done/install: $(BUILD)/libnl/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libnl/build DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/libnl/done/build: $(BUILD)/libnl/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libnl/build
	@touch $@

$(BUILD)/libnl/done/configure: $(BUILD)/libnl/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/libnl/build; PATH="$(CROSS_PATH):$$PATH" sh autogen.sh)
	(cd $(BUILD)/libnl/build; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/libnl/done/copy: $(BUILD)/libnl/done/checkout | $(BUILD)/libnl/done/ $(BUILD)/libnl/build/
	$(CP) -a userspace/libnl/libnl/* $(BUILD)/libnl/build/
	@touch $@

$(BUILD)/libnl/done/checkout: userspace/libnl/libnl{checkout} | $(BUILD)/libnl/done/
	@touch $@
