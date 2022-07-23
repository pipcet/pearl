bootloaders/u-boot/u-boot{menuconfig}: bootloaders/u-boot/u-boot.config | $(BUILD)/bootloaders/u-boot/
	$(CP) $< bootloaders/u-boot/u-boot/.config
	$(MAKE) -C bootloaders/u-boot/u-boot ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) bootloaders/u-boot/u-boot/.config $<

$(BUILD)/bootloaders/u-boot.image.sendfile: $(BUILD)/bootloaders/u-boot.dtb

$(BUILD)/bootloaders/u-boot.modules:
	touch $@

$(BUILD)/bootloaders/u-boot.image.d/sendfile: $(BUILD)/bootloaders/u-boot/done/build | $(BUILD)/bootloaders/u-boot.image.d/
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

$(BUILD)/bootloaders/u-boot-plus-grub.image.d/sendfile: $(BUILD)/bootloaders/u-boot/done/build | $(BUILD)/bootloaders/u-boot-plus-grub.image.d/
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

$(BUILD)/bootloaders/u-boot-plus-grub.image: $(BUILD)/bootloaders/u-boot.image $(BUILD)/grub.efi
	(cat < $<; cat $(BUILD)/bootloaders/grub.efi) > $@

$(BUILD)/bootloaders/u-boot.dtb: $(BUILD)/bootloaders/u-boot/done/build
	$(CP) $(BUILD)/bootloaders/u-boot/build/u-boot.dtb $@

$(BUILD)/bootloaders/u-boot.image: $(BUILD)/bootloaders/u-boot/done/build
	cat < $(BUILD)/bootloaders/u-boot/build/u-boot.bin > $@

$(BUILD)/bootloaders/u-boot/done/install: $(BUILD)/bootloaders/u-boot/done/build
	@touch $@

$(BUILD)/bootloaders/u-boot/done/build: $(BUILD)/bootloaders/u-boot/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/bootloaders/u-boot/done/configure: bootloaders/u-boot/u-boot.config $(BUILD)/bootloaders/u-boot/done/copy $(BUILD)/gcc/done/gcc/install
	$(CP) $< $(BUILD)/bootloaders/u-boot/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/bootloaders/u-boot/done/copy: $(BUILD)/bootloaders/u-boot/done/checkout | $(BUILD)/bootloaders/u-boot/done/ $(BUILD)/bootloaders/u-boot/build/
	$(CP) -n -aus $(PWD)/bootloaders/u-boot/u-boot/* $(BUILD)/bootloaders/u-boot/build/
	@touch $@

$(BUILD)/bootloaders/u-boot/done/checkout: | $(BUILD)/bootloaders/u-boot/done/
	$(MAKE) bootloaders/u-boot/u-boot{checkout}
	@touch $@

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.image
$(BUILD)/initramfs/pearl/boot/u-boot.image: $(BUILD)/bootloaders/u-boot.image ; $(COPY)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.dtb
$(BUILD)/initramfs/pearl/boot/u-boot.dtb: $(BUILD)/bootloaders/u-boot.dtb ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/u-boot/pearl/bin/*),bootloaders/u-boot/pearl)

SECTARGETS += $(BUILD)/bootloaders/u-boot/done/build
SECTARGETS += $(BUILD)/bootloaders/u-boot.image
SECTARGETS += $(BUILD)/bootloaders/u-boot.dtb
SECTARGETS += $(BUILD)/bootloaders/u-boot.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot.image.sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image.d/sendfile
SECTARGETS += $(BUILD)/bootloaders/u-boot-plus-grub.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/u-boot.image
