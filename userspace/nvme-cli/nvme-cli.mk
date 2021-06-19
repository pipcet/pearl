$(BUILD)/nvme-cli/done/install: $(BUILD)/nvme-cli/done/build
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/nvme-cli/build install-bin
	@touch $@

$(BUILD)/nvme-cli/done/build: $(BUILD)/nvme-cli/done/copy
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/nvme-cli/build
	@touch $@

$(BUILD)/nvme-cli/done/copy: $(BUILD)/nvme-cli/done/checkout | $(BUILD)/nvme-cli/done/ $(BUILD)/nvme-cli/build/
	cp -a userspace/nvme-cli/nvme-cli/* $(BUILD)/nvme-cli/build/
	@touch $@

$(BUILD)/nvme-cli/done/checkout: userspace/nvme-cli/nvme-cli{checkout} | $(BUILD)/nvme-cli/done/
	@touch $@

userspace-modules += nvme-cli
