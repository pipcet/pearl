$(call done,userspace/wpa_supplicant,install): $(call done,userspace/wpa_supplicant,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) PKG_CONFIG=/bin/false DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(call done,userspace/wpa_supplicant,build): $(call done,userspace/wpa_supplicant,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false
	@touch $@

$(call done,userspace/wpa_supplicant,configure): userspace/wpa/wpa_supplicant.config $(call done,userspace/wpa_supplicant,copy) $(call done,libnl,install) $(call done,openssl,install)
	cp $< $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false defconfig
	@touch $@

$(call done,userspace/wpa_supplicant,copy): $(call done,userspace/wpa_supplicant,checkout) | $(BUILD)/userspace/wpa_supplicant/build/
	$(CP) -aus $(PWD)/userspace/wpa/wpa/* $(BUILD)/userspace/wpa_supplicant/build/
	@touch $@

$(call done,userspace/wpa_supplicant,checkout): | $(call done,userspace/wpa_supplicant,)
	$(MAKE) userspace/wpa/wpa{checkout}
	@touch $@

userspace-modules += wpa_supplicant
