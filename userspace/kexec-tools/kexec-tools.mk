$(BUILD)/kexec-tools/done/install: $(BUILD)/kexec-tools/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/kexec-tools/source DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/kexec-tools/done/build: $(BUILD)/kexec-tools/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/kexec-tools/source
	@touch $@

$(BUILD)/kexec-tools/done/configure: $(BUILD)/kexec-tools/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/kexec-tools/source; ./bootstrap)
	(cd $(BUILD)/kexec-tools/source; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/kexec-tools/done/copy: $(BUILD)/kexec-tools/done/checkout | $(BUILD)/kexec-tools/source/ $(BUILD)/kexec-tools/done/
	$(CP) -aus $(PWD)/userspace/kexec-tools/kexec-tools/* $(BUILD)/kexec-tools/source/
	@touch $@

$(BUILD)/kexec-tools/done/checkout: | $(BUILD)/kexec-tools/done/
	$(MAKE) userspace/kexec-tools/kexec-tools{checkout}
	@touch $@

userspace-modules += kexec-tools
