DEP_glibc += $(BUILD)/userspace/glibc/done/glibc/install
$(BUILD)/userspace/glibc/done/glibc/install: $(BUILD)/userspace/glibc/done/glibc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build DESTDIR=$(BUILD)/pearl/install CXX="" install
	@touch $@

$(BUILD)/userspace/glibc/done/glibc/build: $(BUILD)/userspace/glibc/done/glibc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build CXX=""
	@touch $@

$(BUILD)/userspace/glibc/done/glibc/configure: $(BUILD)/userspace/glibc/done/glibc/copy $(BUILD)/linux/done/headers/install $(BUILD)/toolchain/gcc/done/gcc/install | $(BUILD)/userspace/glibc/glibc/build/
	(cd $(BUILD)/userspace/glibc/glibc/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS) -Wno-error=array-bounds" CXX="")
	@touch $@

$(BUILD)/userspace/glibc/done/glibc/copy: $(BUILD)/userspace/glibc/done/checkout | $(BUILD)/userspace/glibc/glibc/source/ $(BUILD)/userspace/glibc/done/glibc/
	$(CP) -naus $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/glibc/source/
	@touch $@


$(BUILD)/userspace/glibc/done/stage1/install: $(BUILD)/userspace/glibc/done/stage1/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/stage1/build DESTDIR=$(BUILD)/pearl/install install-headers install
	@touch $@

$(BUILD)/userspace/glibc/done/stage1/build: $(BUILD)/userspace/glibc/done/stage1/configure
	@touch $@

$(BUILD)/userspace/glibc/done/stage1/configure: $(BUILD)/userspace/glibc/done/stage1/copy | $(BUILD)/userspace/glibc/stage1/build/
	(cd $(BUILD)/userspace/glibc/stage1/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/userspace/glibc/done/stage1/copy: $(BUILD)/userspace/glibc/done/checkout | $(BUILD)/userspace/glibc/stage1/source/ $(BUILD)/userspace/glibc/done/stage1/
	$(CP) -aus $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/stage1/source/
	@touch $@

$(BUILD)/userspace/glibc/done/headers/install: $(BUILD)/userspace/glibc/done/headers/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/headers/build DESTDIR=$(BUILD)/pearl/install install-headers
	$(MKDIR) $(BUILD)/pearl/install/include/gnu/
	touch $(BUILD)/pearl/install/include/gnu/stubs.h
	@touch $@

$(BUILD)/userspace/glibc/done/headers/build: $(BUILD)/userspace/glibc/done/headers/configure
	@touch $@

$(BUILD)/userspace/glibc/done/headers/configure: $(BUILD)/userspace/glibc/done/headers/copy | $(BUILD)/userspace/glibc/headers/build/
	(cd $(BUILD)/userspace/glibc/headers/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(BUILD)/userspace/glibc/done/headers/copy: $(BUILD)/userspace/glibc/done/checkout | $(BUILD)/userspace/glibc/headers/source/ $(BUILD)/userspace/glibc/done/headers/
	$(CP) -aus $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/headers/source/
	@touch $@

$(BUILD)/userspace/glibc/done/checkout: | $(BUILD)/userspace/glibc/done/
	$(MAKE) userspace/glibc/glibc{checkout}
	@touch $@

$(BUILD)/userspace/glibc/done/install: $(BUILD)/userspace/glibc/done/glibc/install
	@touch $@

userspace-modules += glibc
