# stage1 is built with the pre-installed cross compiler

$(BUILD)/glibc/done/glibc/install: $(BUILD)/glibc/done/glibc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/glibc/glibc/build DESTDIR=$(BUILD)/pearl/install CXX="" install
	@touch $@

$(BUILD)/glibc/done/glibc/build: $(BUILD)/glibc/done/glibc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/glibc/glibc/build CXX=""
	@touch $@

$(BUILD)/glibc/done/glibc/configure: $(BUILD)/glibc/done/glibc/copy $(BUILD)/linux/done/headers/install $(BUILD)/gcc/done/gcc/install | $(BUILD)/glibc/glibc/build/
	(cd $(BUILD)/glibc/glibc/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/glibc/copy: $(BUILD)/glibc/done/checkout | $(BUILD)/glibc/glibc/source/ $(BUILD)/glibc/done/glibc/
	$(CP) -aus userspace/glibc/glibc/* $(BUILD)/glibc/glibc/source/
	@touch $@


$(BUILD)/glibc/done/stage1/install: $(BUILD)/glibc/done/stage1/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/glibc/stage1/build DESTDIR=$(BUILD)/pearl/install install-headers install
	@touch $@

$(BUILD)/glibc/done/stage1/build: $(BUILD)/glibc/done/stage1/configure
	@touch $@

$(BUILD)/glibc/done/stage1/configure: $(BUILD)/glibc/done/stage1/copy | $(BUILD)/glibc/stage1/build/
	(cd $(BUILD)/glibc/stage1/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/stage1/copy: $(BUILD)/glibc/done/checkout | $(BUILD)/glibc/stage1/source/ $(BUILD)/glibc/done/stage1/
	$(CP) -aus userspace/glibc/glibc/* $(BUILD)/glibc/stage1/source/
	@touch $@

$(BUILD)/glibc/done/headers/install: $(BUILD)/glibc/done/headers/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/glibc/headers/build DESTDIR=$(BUILD)/pearl/install install-headers
	$(MKDIR) $(BUILD)/pearl/install/include/gnu/
	touch $(BUILD)/pearl/install/include/gnu/stubs.h
	@touch $@

$(BUILD)/glibc/done/headers/build: $(BUILD)/glibc/done/headers/configure
	@touch $@

$(BUILD)/glibc/done/headers/configure: $(BUILD)/glibc/done/headers/copy | $(BUILD)/glibc/headers/build/
	(cd $(BUILD)/glibc/headers/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/glibc/done/headers/copy: $(BUILD)/glibc/done/checkout | $(BUILD)/glibc/headers/source/ $(BUILD)/glibc/done/headers/
	$(CP) -aus userspace/glibc/glibc/* $(BUILD)/glibc/headers/source/
	@touch $@

$(BUILD)/glibc/done/checkout: userspace/glibc/glibc{checkout} | $(BUILD)/glibc/done/
	@touch $@

$(BUILD)/glibc/done/install: $(BUILD)/glibc/done/glibc/install
	@touch $@

userspace-modules += glibc
