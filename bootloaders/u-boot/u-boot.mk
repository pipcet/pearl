bootloaders/u-boot/u-boot{menuconfig}: bootloaders/u-boot/u-boot.config | $(BUILD)/bootloaders/u-boot/
	$(CP) $< bootloaders/u-boot/u-boot/.config
	$(MAKE) -C bootloaders/u-boot/u-boot ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) bootloaders/u-boot/u-boot/.config $<

$(BUILD)/bootloaders/u-boot.image.sendfile: $(BUILD)/bootloaders/u-boot.dtb

$(BUILD)/bootloaders/u-boot.modules:
	touch $@

$(BUILD)/bootloaders/u-boot.image.d/sendfile: $(call done,bootloaders/u-boot,build) | $(BUILD)/bootloaders/u-boot.image.d/
	echo "#!/bin/sh" > $@
	echo "dt dtb-to-dtp u-boot.dtb u-boot.dtp" >> $@
	echo "cat persist/bootargs.dtp >> u-boot.dtp" >> $@
	echo "cat u-boot.dtp" >> $@
	echo "(cd /sys/bus/platform/drivers/dwc3; for a in *0*; do echo \$$a > unbind; done)" >> $@
	echo "sleep 2" >> $@
	echo "kexec -fix u-boot.image --dtb=u-boot.dtb" >> $@
	chmod u+x $@

$(BUILD)/bootloaders/u-boot-plus-grub.image.sendfile: $(BUILD)/bootloaders/u-boot.dtb
$(BUILD)/bootloaders/u-boot-plus-grub.image.sendfile: $(BUILD)/bootloaders/grub.efi

$(BUILD)/bootloaders/u-boot-plus-grub.image.d/sendfile: $(call done,bootloaders/u-boot,build) | $(BUILD)/bootloaders/u-boot-plus-grub.image.d/
	echo "#!/bin/sh" > $@
	echo "dt dtb-to-dtp u-boot.dtb u-boot.dtp" >> $@
	echo "cat persist/bootargs.dtp >> u-boot.dtp" >> $@
	echo "cat u-boot.dtp" >> $@
	echo "(cd /sys/bus/platform/drivers/dwc3; for a in *0*; do echo \$$a > unbind; done)" >> $@
	echo "sleep 2" >> $@
	echo "kexec -fix u-boot-plus-grub.image --dtb=u-boot.dtb --ramdisk=grub.efi" >> $@
	chmod u+x $@

$(BUILD)/bootloaders/u-boot-plus-grub.dtb: $(BUILD)/bootloaders/u-boot.dtb
	$(COPY)

$(BUILD)/bootloaders/u-boot-plus-grub.modules:
	touch $@

$(BUILD)/bootloaders/u-boot-plus-grub.image: $(BUILD)/bootloaders/u-boot.image $(BUILD)/bootloaders/grub.efi
	(cat < $<; cat $(BUILD)/bootloaders/grub.efi) > $@

$(BUILD)/bootloaders/u-boot.dtb: $(call done,bootloaders/u-boot,build)
	$(CP) $(BUILD)/bootloaders/u-boot/build/u-boot.dtb $@

$(BUILD)/bootloaders/u-boot.image: $(call done,bootloaders/u-boot,build)
	cat < $(BUILD)/bootloaders/u-boot/build/u-boot.bin > $@

$(call done,bootloaders/u-boot,install): $(call done,bootloaders/u-boot,build)
	$(TIMESTAMP)

$(call done,bootloaders/u-boot,build): $(call done,bootloaders/u-boot,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE)
	$(TIMESTAMP)

$(call done,bootloaders/u-boot,configure): bootloaders/u-boot/u-boot.config $(call done,bootloaders/u-boot,copy) | $(call done,toolchain/gcc,gcc/install)
	$(CP) $< $(BUILD)/bootloaders/u-boot/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	$(TIMESTAMP)

$(call done,bootloaders/u-boot,copy): | $(call done,bootloaders/u-boot,checkout) $(call done,bootloaders/u-boot,) $(BUILD)/bootloaders/u-boot/build/
	$(CP) -n -aus $(PWD)/bootloaders/u-boot/u-boot/* $(BUILD)/bootloaders/u-boot/build/
	$(TIMESTAMP)

$(call done,bootloaders/u-boot,checkout): | $(call done,bootloaders/u-boot,)
	$(MAKE) bootloaders/u-boot/u-boot{checkout}
	$(TIMESTAMP)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.image
$(BUILD)/initramfs/pearl/boot/u-boot.image: $(BUILD)/bootloaders/u-boot.image ; $(COPY)
$(BUILD)/initramfs/pearl/boot/u-boot-plus-grub.image: $(BUILD)/bootloaders/u-boot-plus-grub.image ; $(COPY)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.dtb
$(BUILD)/initramfs/pearl/boot/u-boot.dtb: $(BUILD)/bootloaders/u-boot.dtb ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/u-boot/pearl/bin/*),bootloaders/u-boot/pearl)

SECTARGETS += $(call done,bootloaders/u-boot,build)
SECTARGETS += $(BUILD)/bootloaders/u-boot.image
SECTARGETS += $(BUILD)/bootloaders/u-boot.dtb
SECTARGETS += $(BUILD)/bootloaders/u-boot.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot.image.sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/u-boot.image

BOOTLOADER_FILES += $(BUILD)/initramfs/pearl/boot/u-boot.image
BOOTLOADER_FILES += $(BUILD)/initramfs/pearl/boot/u-boot.dtb
BOOTLOADER_FILES += $(BUILD)/initramfs/pearl/boot/u-boot-plus-grub.image
BOOTLOADER_FILES += $(BUILD)/bootloaders/u-boot.image
BOOTLOADER_FILES += $(BUILD)/bootloaders/u-boot.dtb
BOOTLOADER_FILES += $(BUILD)/bootloaders/u-boot-plus-grub.image
