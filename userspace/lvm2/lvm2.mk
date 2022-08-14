$(call done,userspace/lvm2,install): $(call done,userspace/lvm2,build)
	$(WITH_CROSS_PATH) $(MAKE) CFLAGS="$(CROSS_CFLAGS) -I. -fPIC" LDFLAGS="-L$(BUILD)/pearl/install/lib" -C $(BUILD)/userspace/lvm2/build DESTDIR=$(call install,userspace/lvm2) install
	$(INSTALL_LIBS) userspace/lvm2
	$(TIMESTAMP)

$(call done,userspace/lvm2,build): $(call done,userspace/lvm2,configure)
	$(WITH_CROSS_PATH) $(MAKE) CFLAGS="$(CROSS_CFLAGS) -I. -fPIC" LDFLAGS="-L$(BUILD)/pearl/install/lib" -C $(BUILD)/userspace/lvm2/build
	$(TIMESTAMP)

$(call done,userspace/lvm2,configure): $(call done,userspace/lvm2,copy) | $(call deps,libaio libblkid glibc gcc) builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/lvm2/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/pearl/install/lib")
	$(TIMESTAMP)

$(call done,userspace/lvm2,copy): | $(call done,userspace/lvm2,checkout) $(BUILD)/userspace/lvm2/build/ $(call done,userspace/lvm2,)
	$(COPY_SAUNA) $(PWD)/userspace/lvm2/lvm2/* $(BUILD)/userspace/lvm2/build
	$(TIMESTAMP)

$(call done,userspace/lvm2,checkout): | $(call done,userspace/lvm2,)
	$(MAKE) userspace/lvm2/lvm2{checkout}
	$(TIMESTAMP)

userspace-modules += lvm2
