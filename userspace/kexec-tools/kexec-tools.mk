$(BUILD)/userspace/kexec-tools/done/install: $(BUILD)/userspace/kexec-tools/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/kexec-tools/source DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/kexec-tools/done/build: $(BUILD)/userspace/kexec-tools/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/kexec-tools/source
	@touch $@

$(BUILD)/userspace/kexec-tools/done/configure: $(BUILD)/userspace/kexec-tools/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/kexec-tools/source; ./bootstrap)
	(cd $(BUILD)/userspace/kexec-tools/source; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/userspace/kexec-tools/done/copy: $(BUILD)/userspace/kexec-tools/done/checkout | $(BUILD)/userspace/kexec-tools/source/ $(BUILD)/userspace/kexec-tools/done/
	$(CP) -aus $(PWD)/userspace/kexec-tools/kexec-tools/* $(BUILD)/userspace/kexec-tools/source/
	@touch $@

$(BUILD)/userspace/kexec-tools/done/checkout: | $(BUILD)/userspace/kexec-tools/done/
	$(MAKE) userspace/kexec-tools/kexec-tools{checkout}
	@touch $@

userspace-modules += kexec-tools
