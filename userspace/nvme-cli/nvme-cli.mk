$(BUILD)/userspace/nvme-cli/done/install: $(BUILD)/userspace/nvme-cli/done/build
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build install-bin
	@touch $@

$(BUILD)/userspace/nvme-cli/done/build: $(BUILD)/userspace/nvme-cli/done/copy $(call deps,glibc libblkid libuuid)
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build
	@touch $@

$(BUILD)/userspace/nvme-cli/done/copy: $(BUILD)/userspace/nvme-cli/done/checkout | $(BUILD)/userspace/nvme-cli/done/ $(BUILD)/userspace/nvme-cli/build/
	$(CP) -naus $(PWD)/userspace/nvme-cli/nvme-cli/* $(BUILD)/userspace/nvme-cli/build/
	@touch $@

$(BUILD)/userspace/nvme-cli/done/checkout: | $(BUILD)/userspace/nvme-cli/done/
	$(MAKE) userspace/nvme-cli/nvme-cli{checkout}
	@touch $@

userspace-modules += nvme-cli
