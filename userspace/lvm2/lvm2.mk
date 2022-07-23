$(BUILD)/userspace/lvm2/done/install: $(BUILD)/userspace/lvm2/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/lvm2/build DESTDIR=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/userspace/lvm2/done/build: $(BUILD)/userspace/lvm2/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/lvm2/build
	@touch $@

$(BUILD)/userspace/lvm2/done/configure: $(BUILD)/userspace/lvm2/done/copy $(call deps,libaio libblkid glibc gcc)
	(cd $(BUILD)/userspace/lvm2/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/userspace/lvm2/done/copy: $(BUILD)/userspace/lvm2/done/checkout | $(BUILD)/userspace/lvm2/build/ $(BUILD)/userspace/lvm2/done/
	$(CP) -aus $(PWD)/userspace/lvm2/lvm2/* $(BUILD)/userspace/lvm2/build
	@touch $@

$(BUILD)/userspace/lvm2/done/checkout: | $(BUILD)/userspace/lvm2/done/
	$(MAKE) userspace/lvm2/lvm2{checkout}
	@touch $@

userspace-modules += lvm2
