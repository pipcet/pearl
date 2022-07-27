DEP_libaio += $(call done,userspace/libaio,install)
$(call done,userspace/libaio,install): $(call done,userspace/libaio,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" DESTDIR=$(call install,userspace/libaio) install
	$(INSTALL_LIBS) userspace/libaio
	$(TIMESTAMP)

$(call done,userspace/libaio,build): $(call done,userspace/libaio,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libaio/build CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -I."
	$(TIMESTAMP)

$(call done,userspace/libaio,configure): $(call done,userspace/libaio,copy) $(call deps,libblkid glibc gcc)
	$(TIMESTAMP)

$(call done,userspace/libaio,copy): $(call done,userspace/libaio,checkout) | $(BUILD)/userspace/libaio/build/ $(call done,userspace/libaio,)
	$(COPY_SAUNA) $(PWD)/userspace/libaio/libaio/* $(BUILD)/userspace/libaio/build
	$(TIMESTAMP)

$(call done,userspace/libaio,checkout): | $(call done,userspace/libaio,)
	$(MAKE) userspace/libaio/libaio{checkout}
	$(TIMESTAMP)

userspace-modules += libaio
