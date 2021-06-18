$(BUILD)/done/libnl/install: $(BUILD)/done/libnl/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libnl/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/libnl/build: $(BUILD)/done/libnl/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libnl/build
	@touch $@

$(BUILD)/done/libnl/configure: $(BUILD)/done/libnl/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/libnl/build; PATH="$(CROSS_PATH):$$PATH" sh autogen.sh)
	(cd $(BUILD)/libnl/build; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/install/lib")
	@touch $@

$(BUILD)/done/libnl/copy: | $(BUILD)/done/libnl/ $(BUILD)/libnl/build/
	$(CP) -a userspace/libnl/libnl/* $(BUILD)/libnl/build/
	@touch $@
