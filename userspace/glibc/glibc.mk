# stage1 is built with the pre-installed cross compiler

$(BUILD)/glibc/done/glibc/install: $(BUILD)/glibc/done/glibc/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/glibc/build DESTDIR=$(BUILD)/pearl/install CXX="" install
	@touch $@

$(BUILD)/glibc/done/glibc/build: $(BUILD)/glibc/done/glibc/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/glibc/build CXX=""
	@touch $@

$(BUILD)/glibc/done/glibc/configure: $(BUILD)/glibc/done/glibc/copy $(BUILD)/linux/done/headers/install | $(BUILD)/glibc/glibc/build/
	(cd $(BUILD)/glibc/glibc/build; PATH="$(CROSS_PATH):$$PATH" ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/glibc/copy: | $(BUILD)/glibc/glibc/source/ $(BUILD)/glibc/done/glibc/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/glibc/source/
	@touch $@


$(BUILD)/glibc/done/stage1/install: $(BUILD)/glibc/done/stage1/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/stage1/build DESTDIR=$(BUILD)/pearl/install install-headers install
	@touch $@

$(BUILD)/glibc/done/stage1/build: $(BUILD)/glibc/done/stage1/configure
	@touch $@

$(BUILD)/glibc/done/stage1/configure: $(BUILD)/glibc/done/stage1/copy | $(BUILD)/glibc/stage1/build/
	(cd $(BUILD)/glibc/stage1/build; PATH="$(CROSS_PATH):$$PATH" ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/stage1/copy: $(BUILD)/glibc/done/checkout | $(BUILD)/glibc/stage1/source/ $(BUILD)/glibc/done/stage1/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/stage1/source/
	@touch $@

$(BUILD)/glibc/done/headers/install: $(BUILD)/glibc/done/headers/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/glibc/headers/build DESTDIR=$(BUILD)/pearl/install install-headers
	@touch $@

$(BUILD)/glibc/done/headers/build: $(BUILD)/glibc/done/headers/configure
	@touch $@

$(BUILD)/glibc/done/headers/configure: $(BUILD)/glibc/done/headers/copy | $(BUILD)/glibc/headers/build/
	(cd $(BUILD)/glibc/headers/build; PATH="$(CROSS_PATH):$$PATH" ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/headers/copy: $(BUILD)/glibc/done/checkout | $(BUILD)/glibc/headers/source/ $(BUILD)/glibc/done/headers/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/headers/source/
	@touch $@

$(BUILD)/glibc/done/checkout: userspace/glibc/glibc{checkout} | $(BUILD)/glibc/done/
	@touch $@
