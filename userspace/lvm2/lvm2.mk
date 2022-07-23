$(call done,userspace/lvm2,install): $(call done,userspace/lvm2,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/lvm2/build DESTDIR=$(BUILD)/pearl/install/ install
	$(TIMESTAMP)

$(call done,userspace/lvm2,build): $(call done,userspace/lvm2,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/lvm2/build
	$(TIMESTAMP)

$(call done,userspace/lvm2,configure): $(call done,userspace/lvm2,copy) $(call deps,libaio libblkid glibc gcc)
	(cd $(BUILD)/userspace/lvm2/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/pearl/install/lib")
	$(TIMESTAMP)

$(call done,userspace/lvm2,copy): $(call done,userspace/lvm2,checkout) | $(BUILD)/userspace/lvm2/build/ $(call done,userspace/lvm2,)
	$(COPY_SAUNA) $(PWD)/userspace/lvm2/lvm2/* $(BUILD)/userspace/lvm2/build
	$(TIMESTAMP)

$(call done,userspace/lvm2,checkout): | $(call done,userspace/lvm2,)
	$(MAKE) userspace/lvm2/lvm2{checkout}
	$(TIMESTAMP)

userspace-modules += lvm2
