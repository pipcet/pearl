busybox/busybox{oldconfig}: userspace/busybox/busybox.config $(call done,userspace/busybox,copy)
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build oldconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config $<

busybox/busybox{menuconfig}: userspace/busybox/busybox.config $(call done,userspace/busybox,copy)
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build menuconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config $<

$(call done,userspace/busybox,menuconfig): $(call done,userspace/busybox,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build menuconfig
	$(CP) $(BUILD)/userspace/busybox/build/.config userspace/busybox/busybox.config

$(call done,userspace/busybox,install): $(call done,userspace/busybox,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" install
	$(INSTALL_LIBS) userspace/busybox
	$(TIMESTAMP)

$(call done,userspace/busybox,build): $(call done,userspace/busybox,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)"
	$(TIMESTAMP)

$(call done,userspace/busybox,configure): userspace/busybox/busybox.config $(call done,userspace/busybox,copy) | $(call deps,glibc gcc libgcc)
	$(CP) $< $(BUILD)/userspace/busybox/build/.config
	yes "" | $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" oldconfig
	$(TIMESTAMP)

$(call done,userspace/busybox,copy): $(call done,userspace/busybox,checkout) | $(call done,userspace/busybox,) $(BUILD)/userspace/busybox/build/
	$(COPY_SAUNA) $(PWD)/userspace/busybox/busybox/* $(BUILD)/userspace/busybox/build/
	$(TIMESTAMP)

$(call done,userspace/busybox,checkout): | $(call done,userspace/busybox,)
	$(MAKE) userspace/busybox/busybox{checkout}
	$(TIMESTAMP)

userspace-modules += busybox
