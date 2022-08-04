DEP_zlib += $(call done,userspace/zlib,install)
$(call done,userspace/zlib,install): $(call done,userspace/zlib,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build install
	$(INSTALL_LIBS) userspace/zlib
	$(TIMESTAMP)

$(call done,userspace/zlib,build): $(call done,userspace/zlib,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zlib/build CFLAGS="$(CROSS_CFLAGS)"
	$(TIMESTAMP)

$(call done,userspace/zlib,configure): $(call done,userspace/zlib,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/zlib/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS) -fPIC" ./configure --prefix=$(call install,userspace/zlib))
	$(TIMESTAMP)

$(call done,userspace/zlib,copy): $(call done,userspace/zlib,checkout) | $(call done,userspace/zlib,) $(BUILD)/userspace/zlib/build/
	$(COPY_SAUNA) $(PWD)/userspace/zlib/zlib/* $(BUILD)/userspace/zlib/build/
	$(TIMESTAMP)

$(call done,userspace/zlib,checkout): | $(call done,userspace/zlib,)
	$(MAKE) userspace/zlib/zlib{checkout}
	$(TIMESTAMP)

userspace-modules += zlib
