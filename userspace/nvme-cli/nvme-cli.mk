ifeq ($(filter rest.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/nvme-cli,install): $(call done,userspace/nvme-cli,build)
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build install-bin
	$(INSTALL_LIBS) userspace/nvme-cli
	$(TIMESTAMP)
else
$(call done,userspace/nvme-cli,install): $(BUILD)/artifacts/rest.tar.zstd/extract | $(call done,userspace/nvme-cli,)/
	$(TIMESTAMP)
endif

$(call done,userspace/nvme-cli,build): $(call done,userspace/nvme-cli,copy) | $(call deps,glibc libblkid libuuid)
	$(WITH_CROSS_PATH) CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(call install,userspace/nvme-cli)" $(MAKE) $(WITH_CROSS_CC) -C $(BUILD)/userspace/nvme-cli/build
	$(TIMESTAMP)

$(call done,userspace/nvme-cli,copy): | $(call done,userspace/nvme-cli,checkout) $(call done,userspace/nvme-cli,) $(BUILD)/userspace/nvme-cli/build/
	$(COPY_SAUNA) $(PWD)/userspace/nvme-cli/nvme-cli/* $(BUILD)/userspace/nvme-cli/build/
	$(TIMESTAMP)

$(call done,userspace/nvme-cli,checkout): | $(call done,userspace/nvme-cli,)
	$(MAKE) userspace/nvme-cli/nvme-cli{checkout}
	$(TIMESTAMP)

userspace-modules += nvme-cli
