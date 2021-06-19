$(BUILD)/wpa_supplicant/done/install: $(BUILD)/wpa_supplicant/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) install

$(BUILD)/wpa_supplicant/done/build: $(BUILD)/wpa_supplicant/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC)
	@touch $@

$(BUILD)/wpa_supplicant/done/configure: userspace/wpa/wpa_supplicant.config $(BUILD)/wpa_supplicant/done/copy
	cp $< $(BUILD)/wpa_supplicant/build/wpa_supplicant/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant defconfig $(WITH_CROSS_CC)
	@touch $@

$(BUILD)/wpa_supplicant/done/copy: $(BUILD)/wpa_supplicant/done/checkout | $(BUILD)/wpa_supplicant/build/
	cp -as $(PWD)/userspace/wpa/wpa/* $(BUILD)/wpa_supplicant/build/
	@touch $@

$(BUILD)/wpa_supplicant/done/checkout: userspace/wpa/wpa{checkout} | $(BUILD)/wpa_supplicant/done/
	@touch $@

userspace-modules += wpa-supplicant
