# stage1 is built with the pre-installed cross compiler

$(BUILD)/done/glibc/glibc/install: $(BUILD)/done/glibc/glibc/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/glibc/build DESTDIR=$(BUILD)/install CXX="" install
	@touch $@

$(BUILD)/done/glibc/glibc/build: $(BUILD)/done/glibc/glibc/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/glibc/build CXX=""
	@touch $@

$(BUILD)/done/glibc/glibc/configure: $(BUILD)/done/glibc/glibc/copy | $(BUILD)/glibc/glibc/build/
	(cd $(BUILD)/glibc/glibc/build; PATH="$(CROSS_PATH):$$PATH" ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/done/glibc/glibc/copy: | $(BUILD)/glibc/glibc/source/ $(BUILD)/done/glibc/glibc/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/glibc/source/
	@touch $@


$(BUILD)/done/glibc/stage1/install: $(BUILD)/done/glibc/stage1/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/stage1/build DESTDIR=$(BUILD)/install install-headers install
	@touch $@

$(BUILD)/done/glibc/stage1/build: $(BUILD)/done/glibc/stage1/configure
	@touch $@

$(BUILD)/done/glibc/stage1/configure: $(BUILD)/done/glibc/stage1/copy | $(BUILD)/glibc/stage1/build/
	(cd $(BUILD)/glibc/stage1/build; PATH="$(CROSS_PATH):$$PATH" ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/done/glibc/stage1/copy: $(BUILD)/done/glibc/checkout | $(BUILD)/glibc/stage1/source/ $(BUILD)/done/glibc/stage1/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/stage1/source/
	@touch $@

$(BUILD)/done/glibc/checkout: userspace/glibc/glibc{checkout} | $(BUILD)/done/glibc/
	@touch $@
