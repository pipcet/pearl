$(BUILD)/done/linux/headers/install: $(BUILD)/done/linux/headers/copy $(BUILD)/done/gcc/stage1/install
	$(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/install headers_install
	@touch $@

$(BUILD)/done/linux/headers/copy: | $(BUILD)/done/linux/headers/ $(BUILD)/linux/headers/source/
	$(CP) -a linux/linux/* $(BUILD)/linux/headers/source/
	@touch $@
