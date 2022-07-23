$(BUILD)/userspace/wpa_supplicant/done/install: $(BUILD)/userspace/wpa_supplicant/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) PKG_CONFIG=/bin/false DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/wpa_supplicant/done/build: $(BUILD)/userspace/wpa_supplicant/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false
	@touch $@

$(BUILD)/userspace/wpa_supplicant/done/configure: userspace/wpa/wpa_supplicant.config $(BUILD)/userspace/wpa_supplicant/done/copy $(BUILD)/libnl/done/install $(BUILD)/openssl/done/install
	cp $< $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false defconfig
	@touch $@

$(BUILD)/userspace/wpa_supplicant/done/copy: $(BUILD)/userspace/wpa_supplicant/done/checkout | $(BUILD)/userspace/wpa_supplicant/build/
	$(CP) -aus $(PWD)/userspace/wpa/wpa/* $(BUILD)/userspace/wpa_supplicant/build/
	@touch $@

$(BUILD)/userspace/wpa_supplicant/done/checkout: | $(BUILD)/userspace/wpa_supplicant/done/
	$(MAKE) userspace/wpa/wpa{checkout}
	@touch $@

userspace-modules += wpa_supplicant
