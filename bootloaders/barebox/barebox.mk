bootloaders/barebox/barebox{menuconfig}: bootloaders/barebox/barebox.config | $(BUILD)/bootloaders/barebox/
	$(CP) $< bootloaders/barebox/barebox/.config
	$(MAKE) -C bootloaders/barebox/barebox ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) bootloaders/barebox/barebox/.config $<

bootloaders/barebox/barebox{oldconfig}: bootloaders/barebox/barebox.config stamp/barebox | $(BUILD)barebox/
	$(CP) $< $(BUILD)/bootloaders/barebox/.config
	$(MAKE) -C submodule/barebox oldconfig ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	$(CP) $(BUILD)/bootloaders/barebox/.config $<

$(BUILD)/bootloaders/barebox.modules:
	touch $@

$(BUILD)/bootloaders/barebox.image: $(call done,bootloaders/barebox,install)
	$(CP) $(BUILD)/bootloaders/barebox/build/images/barebox-dt-2nd.img $@

$(BUILD)/bootloaders/barebox.dtb: $(call done,bootloaders/barebox,install)
	$(CP) $(BUILD)/bootloaders/barebox/build/arch/arm/dts/apple-m1-j274.dtb $@

$(BUILD)/bootloaders/barebox.image.sendfile: $(BUILD)/bootloaders/barebox.dtb

$(BUILD)/bootloaders/barebox.image.d/sendfile: $(call done,bootloaders/barebox,install) | $(BUILD)/bootloaders/barebox.image.d/
	echo "#!/bin/sh" > $@
	echo "enable-framebuffer &" >> $@
	echo "echo > /sys/kernel/debug/dcp/trigger &" >> $@
	echo "sleep 12" >> $@
	echo "dt dtb-to-dtp barebox.dtb barebox.dtp" >> $@
	echo "cat persist/bootargs.dtp >> barebox.dtp" >> $@
	echo "dt dtp-to-dtb barebox.dtp barebox.dtb" >> $@
	echo "cat barebox.dtp" >> $@
	echo "(cd /sys/bus/platform/drivers/dwc3; for a in *0*; do echo \$$a > unbind; done)" >> $@
	echo "sleep 2" >> $@
	echo "kexec -fix barebox.image --dtb=barebox.dtb" >> $@
	chmod u+x $@

ifeq ($(filter bootloaders.tar.zstd,$(ARTIFACTS)),)
$(call done,bootloaders/barebox,install): $(call done,bootloaders/barebox,build)
	$(TIMESTAMP)
else
$(call done,bootloaders/barebox,install): $(BUILD)/artifacts/bootloaders.tar.zstd/extract | $(call done,bootloaders/barebox,)/
	$(TIMESTAMP)
endif

$(call done,bootloaders/barebox,build): $(call done,bootloaders/barebox,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	$(TIMESTAMP)

$(call done,bootloaders/barebox,configure): $(call done,bootloaders/barebox,copy) | bootloaders/barebox/barebox.config $(call done,toolchain/gcc,gcc/install) builder/packages/autopoint{} builder/packages/lzop{}
	$(CP) bootloaders/barebox/barebox.config $(BUILD)/bootloaders/barebox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	$(TIMESTAMP)

$(call done,bootloaders/barebox,copy): | $(call done,bootloaders/barebox,checkout) $(call done,bootloaders/barebox,) $(BUILD)/bootloaders/barebox/build/
	$(COPY_SAUNA) $(PWD)/bootloaders/barebox/barebox/* $(BUILD)/bootloaders/barebox/build/
	$(TIMESTAMP)

$(call done,bootloaders/barebox,checkout): | $(call done,bootloaders/barebox,)
	$(MAKE) bootloaders/barebox/barebox{checkout}
	$(TIMESTAMP)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/barebox.image
$(BUILD)/initramfs/pearl/boot/barebox.image: $(BUILD)/bootloaders/barebox.image ; $(COPY)
$(BUILD)/initramfs/pearl/boot/barebox.dtb: $(BUILD)/bootloaders/barebox.dtb ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/barebox/pearl/bin/*),bootloaders/barebox/pearl)

BOOTLOADER_FILES += $(BUILD)/initramfs/pearl/boot/barebox.image
BOOTLOADER_FILES += $(BUILD)/initramfs/pearl/boot/barebox.dtb
BOOTLOADER_FILES += $(BUILD)/bootloaders/barebox.image
BOOTLOADER_FILES += $(BUILD)/bootloaders/barebox.dtb

SECTARGETS += $(call done,bootloaders/barebox,build)
SECTARGETS += $(BUILD)/bootloaders/barebox.image
SECTARGETS += $(BUILD)/bootloaders/barebox.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/barebox.image
