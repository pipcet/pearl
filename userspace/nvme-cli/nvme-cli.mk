$(BUILD)/done/nvme-cli/install: $(BUILD)/done/nvme-cli/build
	PATH="$(CROSS_PATH):$$PATH" CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/install" $(MAKE) -C $(BUILD)/nvme-cli/build/install
	@touch $@

$(BUILD)/done/nvme-cli/build: $(BUILD)/done/nvme-cli/copy
	PATH="$(CROSS_PATH):$$PATH" CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/install" $(MAKE) -C $(BUILD)/nvme-cli/build
	@touch $@

$(BUILD)/done/nvme-cli/copy: | $(BUILD)/done/nvme-cli/ $(BUILD)/nvme-cli/build/
	cp -a userspace/nvme-cli/nvme-cli/* $(BUILD)/nvme-cli/build/
	@touch $@
