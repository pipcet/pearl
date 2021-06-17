$(BUILD)/done/glibc/stage1/install: $(BUILD)/done/glibc/stage1/build
	$(MAKE) -C $(BUILD)/glibc/stage1/build install
	@touch $@

$(BUILD)/done/glibc/stage1/build: $(BUILD)/done/glibc/stage1/configure
	$(MAKE) -C $(BUILD)/glibc/stage1/build
	@touch $@

$(BUILD)/done/glibc/stage1/configure: $(BUILD)/done/glibc/stage1/copy | $(BUILD)/glibc/stage1/build/
	(cd $(BUILD)/glibc/stage1/build; ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/glibc/stage1/copy: | $(BUILD)/glibc/stage1/source/ $(BUILD)/done/glibc/stage1/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/stage1/source/
	@touch $@
