bootloaders/u-boot/u-boot{menuconfig}: bootloaders/u-boot/u-boot.config | $(BUILD)/u-boot/
	$(CP) $< bootloaders/u-boot/u-boot/.config
	$(MAKE) -C bootloaders/u-boot/u-boot ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) bootloaders/u-boot/u-boot/.config $<

$(BUILD)/u-boot.image.sendfile: $(BUILD)/u-boot.dtb

$(BUILD)/u-boot.modules:
	touch $@

$(BUILD)/u-boot.image.d/sendfile: $(BUILD)/u-boot/done/build | $(BUILD)/u-boot.image.d/
	echo "#!/bin/sh" > $@
	echo "dt dtb-to-dtp u-boot.dtb u-boot.dtp" >> $@
	echo "cat persist/bootargs.dtp >> u-boot.dtp" >> $@
	echo "cat u-boot.dtp" >> $@
	echo "(cd /sys/bus/platform/drivers/dwc3; for a in *0*; do echo \$$a > unbind; done)" >> $@
	echo "sleep 2" >> $@
	echo "kexec -fix u-boot.image --dtb=u-boot.dtb" >> $@
	chmod u+x $@

$(BUILD)/u-boot-plus-grub.image.sendfile: $(BUILD)/u-boot.dtb
$(BUILD)/u-boot-plus-grub.image.sendfile: $(BUILD)/grub.efi

$(BUILD)/u-boot-plus-grub.image.d/sendfile: $(BUILD)/u-boot/done/build | $(BUILD)/u-boot-plus-grub.image.d/
	echo "#!/bin/sh" > $@
	echo "enable-framebuffer &" >> $@
	echo "while ! ls /sys/kernel/debug/dcp/trigger; do sleep 1; done" >> $@
	echo "echo > /sys/kernel/debug/dcp/trigger &" >> $@
	echo "sleep 6" >> $@
	echo "echo /bin/kexec -fix u-boot-plus-grub.image --dtb=u-boot.dtb --ramdisk=grub.efi" >> $@
	chmod u+x $@

$(BUILD)/u-boot-plus-grub.image: $(BUILD)/u-boot.image $(BUILD)/grub.efi
	(cat < $<; cat $(BUILD)/grub.efi) > $@

$(BUILD)/u-boot.dtb: $(BUILD)/u-boot/done/build
	$(CP) $(BUILD)/u-boot/build/u-boot.dtb $@

$(BUILD)/u-boot.image: $(BUILD)/u-boot/done/build
	cat < $(BUILD)/u-boot/build/u-boot.bin > $@

$(BUILD)/u-boot/done/install: $(BUILD)/u-boot/done/build
	@touch $@

$(BUILD)/u-boot/done/build: $(BUILD)/u-boot/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/u-boot/done/configure: bootloaders/u-boot/u-boot.config $(BUILD)/u-boot/done/copy $(BUILD)/gcc/done/gcc/install
	$(CP) $< $(BUILD)/u-boot/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/u-boot/build ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/u-boot/done/copy: $(BUILD)/u-boot/done/checkout | $(BUILD)/u-boot/done/ $(BUILD)/u-boot/build/
	$(CP) -n -aus $(PWD)/bootloaders/u-boot/u-boot/* $(BUILD)/u-boot/build/
	@touch $@

$(BUILD)/u-boot/done/checkout: | $(BUILD)/u-boot/done/
	$(MAKE) bootloaders/u-boot/u-boot{checkout}
	@touch $@

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.image
$(BUILD)/initramfs/pearl/boot/u-boot.image: $(BUILD)/u-boot.image ; $(COPY)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/u-boot.dtb
$(BUILD)/initramfs/pearl/boot/u-boot.dtb: $(BUILD)/u-boot.dtb ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/u-boot/pearl/bin/*),bootloaders/u-boot/pearl)

SECTARGETS += $(BUILD)/u-boot/done/build
SECTARGETS += $(BUILD)/u-boot.image
SECTARGETS += $(BUILD)/u-boot.dtb
SECTARGETS += $(BUILD)/u-boot.d/sendfile
SECTARGETS += $(BUILD)/u-boot.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/u-boot.image
