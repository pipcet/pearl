$(BUILD)/done/busybox/menuconfig: $(BUILD)/done/busybox/configure
	$(MAKE) -C $(BUILD)/busybox/build menuconfig
	$(CP) $(BUILD)/busybox/build/.config userspace/busybox/busybox.config

$(BUILD)/done/busybox/install: $(BUILD)/done/busybox/build
	$(MAKE) -C $(BUILD)/busybox/build install
	@touch $@

$(BUILD)/done/busybox/build: $(BUILD)/done/busybox/configure
	$(MAKE) -C $(BUILD)/busybox/build
	@touch $@

$(BUILD)/done/busybox/configure: userspace/busybox/busybox.config $(BUILD)/done/busybox/copy
	$(CP) $< $(BUILD)/busybox/build/.config
	$(MAKE) -C $(BUILD)/busybox/build/ oldconfig
	@touch $@

$(BUILD)/done/busybox/copy: | $(BUILD)/done/busybox/ $(BUILD)/busybox/build/
	$(CP) -a userspace/busybox/busybox/* $(BUILD)/busybox/build/
	@touch $@
