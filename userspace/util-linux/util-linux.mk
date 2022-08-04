DEP_libuuid += $(call done,userspace/libuuid,install)
$(call done,userspace/libuuid,install): $(call done,userspace/libuuid,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libuuid/build DESTDIR=$(call install,userspace/libuuid) install
	$(INSTALL_LIBS) userspace/libuuid
	$(TIMESTAMP)

$(call done,userspace/libuuid,build): $(call done,userspace/libuuid,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libuuid/build
	$(TIMESTAMP)

$(call done,userspace/libuuid,configure): $(call done,userspace/libuuid,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libuuid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/userspace/libuuid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libuuid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	$(TIMESTAMP)

$(call done,userspace/libuuid,copy): $(call done,userspace/util-linux,checkout) | $(call done,userspace/libuuid,) $(BUILD)/userspace/libuuid/build/
	$(COPY_SAUNA) $(PWD)/userspace/util-linux/util-linux/* $(BUILD)/userspace/libuuid/build/
	$(TIMESTAMP)

userspace-modules += libuuid

DEP_libblkid += $(call done,userspace/libblkid,install)
$(call done,userspace/libblkid,install): $(call done,userspace/libblkid,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libblkid/build DESTDIR=$(call install,userspace/libblkid) install
	$(INSTALL_LIBS) userspace/libblkid
	$(TIMESTAMP)

$(call done,userspace/libblkid,build): $(call done,userspace/libblkid,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/libblkid/build
	$(TIMESTAMP)

$(call done,userspace/libblkid,configure): $(call done,userspace/libblkid,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/libblkid/build; $(WITH_CROSS_PATH) autoreconf -fi)
	(cd $(BUILD)/userspace/libblkid/build; $(WITH_CROSS_PATH) ./configure --disable-all-programs --enable-libblkid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/pearl/install/lib")
	$(TIMESTAMP)

$(call done,userspace/libblkid,copy): $(call done,userspace/util-linux,checkout) | $(call done,userspace/libblkid,) $(BUILD)/userspace/libblkid/build/
	$(COPY_SAUNA) $(PWD)/userspace/util-linux/util-linux/* $(BUILD)/userspace/libblkid/build/
	$(TIMESTAMP)

userspace-modules += libblkid

$(call done,userspace/util-linux,checkout): | $(call done,userspace/util-linux,)
	$(MAKE) userspace/util-linux/util-linux{checkout}
	$(TIMESTAMP)

