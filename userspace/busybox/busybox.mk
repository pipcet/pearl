busybox/busybox{oldconfig}: userspace/busybox/busybox.config $(BUILD)/userspace/busybox/done/copy
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build oldconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config $<

busybox/busybox{menuconfig}: userspace/busybox/busybox.config $(BUILD)/userspace/busybox/done/copy
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build menuconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config $<

$(BUILD)/userspace/busybox/done/menuconfig: $(BUILD)/userspace/busybox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build menuconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config userspace/busybox/busybox.config

$(BUILD)/userspace/busybox/done/install: $(BUILD)/userspace/busybox/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" install
	@touch $@

$(BUILD)/userspace/busybox/done/build: $(BUILD)/userspace/busybox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/userspace/busybox/done/configure: userspace/busybox/busybox.config $(BUILD)/userspace/busybox/done/copy $(call deps,glibc gcc libgcc)
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	yes "" | $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" oldconfig
	@touch $@

$(BUILD)/userspace/busybox/done/copy: $(BUILD)/userspace/busybox/done/checkout | $(BUILD)/userspace/busybox/done/ $(BUILD)/userspace/busybox/build/
	$(CP) -aus $(PWD)/userspace/busybox/busybox/* $(BUILD)/userspace/busybox/build/
	@touch $@

$(BUILD)/userspace/busybox/done/checkout: | $(BUILD)/userspace/busybox/done/
	$(MAKE) userspace/busybox/busybox{checkout}
	@touch $@

userspace-modules += busybox
