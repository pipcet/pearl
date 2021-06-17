$(BUILD)/done/kexec-tools/build: $(BUILD)/done/kexec-tools/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/kexec-tools/source DESTDIR="$(BUILD)/install" install
	@touch $@

$(BUILD)/done/kexec-tools/build: $(BUILD)/done/kexec-tools/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/kexec-tools/source
	@touch $@

$(BUILD)/done/kexec-tools/configure: $(BUILD)/done/kexec-tools/copy
	(cd $(BUILD)/kexec-tools/source; ./bootstrap)
	(cd $(BUILD)/kexec-tools/source; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/kexec-tools/copy: | $(BUILD)/kexec-tools/source/ $(BUILD)/done/kexec-tools/
	$(CP) -a userspace/kexec-tools/kexec-tools/* $(BUILD)/kexec-tools/source/
	@touch $@
