$(BUILD)/done/busybox/menuconfig: $(BUILD)/done/busybox/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build menuconfig
	$(CP) $(BUILD)/busybox/build/.config userspace/busybox/busybox.config

$(BUILD)/done/busybox/install: $(BUILD)/done/busybox/build
	$(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" install
	@touch $@

$(BUILD)/done/busybox/build: $(BUILD)/done/busybox/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/done/busybox/configure: userspace/busybox/busybox.config $(BUILD)/done/busybox/copy
	$(CP) $< $(BUILD)/busybox/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build/ CFLAGS="$(CROSS_CFLAGS)" oldconfig
	@touch $@

$(BUILD)/done/busybox/copy: | $(BUILD)/done/busybox/ $(BUILD)/busybox/build/
	$(CP) -a userspace/busybox/busybox/* $(BUILD)/busybox/build/
	@touch $@
