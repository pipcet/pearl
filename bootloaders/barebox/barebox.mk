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

$(BUILD)/bootloaders/barebox.image: $(BUILD)/bootloaders/barebox/done/build
	$(CP) $(BUILD)/bootloaders/barebox/build/images/barebox-dt-2nd.img $@

$(BUILD)/bootloaders/barebox.dtb: $(BUILD)/bootloaders/barebox/done/build
	$(CP) $(BUILD)/bootloaders/barebox/build/arch/arm/dts/apple-m1-j274.dtb $@

$(BUILD)/bootloaders/barebox.image.sendfile: $(BUILD)/bootloaders/barebox.dtb

$(BUILD)/bootloaders/barebox.image.d/sendfile: $(BUILD)/bootloaders/barebox/done/build | $(BUILD)/bootloaders/barebox.image.d/
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

$(BUILD)/bootloaders/barebox/done/install: $(BUILD)/bootloaders/barebox/done/build
	@touch $@

$(BUILD)/bootloaders/barebox/done/build: $(BUILD)/bootloaders/barebox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/bootloaders/barebox/done/configure: bootloaders/barebox/barebox.config $(BUILD)/bootloaders/barebox/done/copy $(BUILD)/gcc/done/gcc/install $(BUILD)/glibc/done/glibc/install
	$(CP) $< $(BUILD)/bootloaders/barebox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/bootloaders/barebox/done/copy: $(BUILD)/bootloaders/barebox/done/checkout | $(BUILD)/bootloaders/barebox/done/ $(BUILD)/bootloaders/barebox/build/
	$(CP) -aus $(PWD)/bootloaders/barebox/barebox/* $(BUILD)/bootloaders/barebox/build/
	@touch $@

$(BUILD)/bootloaders/barebox/done/checkout: | $(BUILD)/bootloaders/barebox/done/
	$(MAKE) bootloaders/barebox/barebox{checkout}
	@touch $@

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/barebox.image
$(BUILD)/initramfs/pearl/boot/barebox.image: $(BUILD)/bootloaders/barebox.image ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/barebox/pearl/bin/*),bootloaders/barebox/pearl)

SECTARGETS += $(BUILD)/bootloaders/barebox/done/build
SECTARGETS += $(BUILD)/bootloaders/barebox.image
SECTARGETS += $(BUILD)/bootloaders/barebox.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/barebox.image
