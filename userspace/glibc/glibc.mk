$(BUILD)/done/glibc/glibc/build: $(BUILD)/done/glibc/glibc/configure
	$(MAKE) -C $(BUILD)/glibc/glibc/build
	@touch $@

$(BUILD)/done/glibc/glibc/configure: $(BUILD)/done/glibc/glibc/copy | $(BUILD)/glibc/glibc/build/
	(cd $(BUILD)/glibc/glibc/build; ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/glibc/glibc/copy: | $(BUILD)/glibc/glibc/source/ $(BUILD)/done/glibc/glibc/
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/glibc/source/
	@touch $@
