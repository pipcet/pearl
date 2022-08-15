ifeq ($(filter rest.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/kexec-tools,install): $(call done,userspace/kexec-tools,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/kexec-tools/source DESTDIR="$(call install,userspace/kexec-tools)" install
	$(INSTALL_LIBS) userspace/kexec-tools
	$(TIMESTAMP)
else
$(call done,userspace/kexec-tools,install): $(BUILD)/artifacts/rest.tar.zstd/extract | $(call done,userspace/kexec-tools,)/
	$(TIMESTAMP)
endif

$(call done,userspace/kexec-tools,build): $(call done,userspace/kexec-tools,configure)
	$(WITH_CROSS_PATH) $(MAKE) CFLAGS="$(CROSS_CFLAGS) -B$(BUILD)/pearl/toolchain/lib/gcc/aarch64-linux-gnu/13.0.0/" -C $(BUILD)/userspace/kexec-tools/source
	$(TIMESTAMP)

$(call done,userspace/kexec-tools,configure): $(call done,userspace/kexec-tools,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/kexec-tools/source; ./bootstrap)
	(cd $(BUILD)/userspace/kexec-tools/source; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	$(TIMESTAMP)

$(call done,userspace/kexec-tools,copy): | $(call done,userspace/kexec-tools,checkout) $(BUILD)/userspace/kexec-tools/source/ $(call done,userspace/kexec-tools,)
	$(COPY_SAUNA) $(PWD)/userspace/kexec-tools/kexec-tools/* $(BUILD)/userspace/kexec-tools/source/
	$(TIMESTAMP)

$(call done,userspace/kexec-tools,checkout): | $(call done,userspace/kexec-tools,)
	$(MAKE) userspace/kexec-tools/kexec-tools{checkout}
	$(TIMESTAMP)

userspace-modules += kexec-tools
