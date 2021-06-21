$(BUILD)/busybox/done/menuconfig: $(BUILD)/busybox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/busybox/build menuconfig
	$(CP) $(BUILD)/busybox/build/.config userspace/busybox/busybox.config

$(BUILD)/busybox/done/install: $(BUILD)/busybox/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" install
	@touch $@

$(BUILD)/busybox/done/build: $(BUILD)/busybox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/busybox/done/configure: userspace/busybox/busybox.config $(BUILD)/busybox/done/copy $(BUILD)/glibc/done/glibc/install
	$(CP) $< $(BUILD)/busybox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" oldconfig
	@touch $@

$(BUILD)/busybox/done/copy: $(BUILD)/busybox/done/checkout | $(BUILD)/busybox/done/ $(BUILD)/busybox/build/
	$(CP) -aus $(PWD)/userspace/busybox/busybox/* $(BUILD)/busybox/build/
	@touch $@

$(BUILD)/busybox/done/checkout: | $(BUILD)/busybox/done/
	$(MAKE) userspace/busybox/busybox{checkout}
	@touch $@

userspace-modules += busybox
