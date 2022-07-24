$(call done,userspace/cryptsetup,install): $(call done,userspace/cryptsetup,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/cryptsetup/build DESTDIR=$(BUILD)/pearl/install install
	$(TIMESTAMP)

$(call done,userspace/cryptsetup,build): $(call done,userspace/cryptsetup,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/cryptsetup/build
	$(TIMESTAMP)

$(call done,userspace/cryptsetup,configure): $(call done,userspace/cryptsetup,copy) $(call done,userspace/libuuid,install) $(call done,userspace/json-c,install) $(call done,userspace/popt,install) $(call done,userspace/libblkid,install) $(call done,userspace/lvm2,install) $(call done,userspace/openssl,install) $(call done,userspace/glibc,glibc/install) $(call done,toolchain/gcc,gcc/install)
	(cd $(BUILD)/userspace/cryptsetup/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/cryptsetup/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --disable-asciidoc --enable-ssh-token=no --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS) -Wl,-rpath-link -Wl,$(BUILD)/pearl/install/lib" JSON_C_CFLAGS="-I$(BUILD)/pearl/install/include -I$(BUILD)/pearl/install/include/json-c" JSON_C_LIBS="-ljson-c")
	$(TIMESTAMP)

$(call done,userspace/cryptsetup,copy): $(call done,userspace/cryptsetup,checkout) | $(call done,userspace/cryptsetup,) $(BUILD)/userspace/cryptsetup/build/
	$(COPY_SAUNA) $(PWD)/userspace/cryptsetup/cryptsetup/* $(BUILD)/userspace/cryptsetup/build/
	$(TIMESTAMP)

$(call done,userspace/cryptsetup,checkout): | $(call done,userspace/cryptsetup,)
	$(MAKE) userspace/cryptsetup/cryptsetup{checkout}
	$(TIMESTAMP)

userspace-modules += cryptsetup

