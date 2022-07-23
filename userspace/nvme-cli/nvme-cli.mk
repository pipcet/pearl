$(call done,userspace/nvme-cli,install): $(call done,userspace/nvme-cli,build)
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build install-bin
	$(TIMESTAMP)

$(call done,userspace/nvme-cli,build): $(call done,userspace/nvme-cli,copy) $(call deps,glibc libblkid libuuid)
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build
	$(TIMESTAMP)

$(call done,userspace/nvme-cli,copy): $(call done,userspace/nvme-cli,checkout) | $(call done,userspace/nvme-cli,) $(BUILD)/userspace/nvme-cli/build/
	$(CP) -naus $(PWD)/userspace/nvme-cli/nvme-cli/* $(BUILD)/userspace/nvme-cli/build/
	$(TIMESTAMP)

$(call done,userspace/nvme-cli,checkout): | $(call done,userspace/nvme-cli,)
	$(MAKE) userspace/nvme-cli/nvme-cli{checkout}
	$(TIMESTAMP)

userspace-modules += nvme-cli
