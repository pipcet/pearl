$(call done,userspace/kexec-tools,install): $(call done,userspace/kexec-tools,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/kexec-tools/source DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(call done,userspace/kexec-tools,build): $(call done,userspace/kexec-tools,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/kexec-tools/source
	@touch $@

$(call done,userspace/kexec-tools,configure): $(call done,userspace/kexec-tools,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/kexec-tools/source; ./bootstrap)
	(cd $(BUILD)/userspace/kexec-tools/source; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(call done,userspace/kexec-tools,copy): $(call done,userspace/kexec-tools,checkout) | $(BUILD)/userspace/kexec-tools/source/ $(call done,userspace/kexec-tools,)
	$(CP) -aus $(PWD)/userspace/kexec-tools/kexec-tools/* $(BUILD)/userspace/kexec-tools/source/
	@touch $@

$(call done,userspace/kexec-tools,checkout): | $(call done,userspace/kexec-tools,)
	$(MAKE) userspace/kexec-tools/kexec-tools{checkout}
	@touch $@

userspace-modules += kexec-tools
