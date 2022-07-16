bootloaders/barebox/barebox{menuconfig}: bootloaders/barebox/barebox.config | $(BUILD)/barebox/
	$(CP) $< bootloaders/barebox/barebox/.config
	$(MAKE) -C bootloaders/barebox/barebox ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) bootloaders/barebox/barebox/.config $<

bootloaders/barebox/barebox{oldconfig}: bootloaders/barebox/barebox.config stamp/barebox | $(BUILD)barebox/
	$(CP) $< $(BUILD)/barebox/.config
	$(MAKE) -C submodule/barebox oldconfig ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	$(CP) $(BUILD)/barebox/.config $<

$(BUILD)/barebox.modules:
	touch $@

$(BUILD)/barebox.image: $(BUILD)/barebox/done/build
	$(CP) $(BUILD)/barebox/build/images/barebox-dt-2nd.img $@

$(BUILD)/barebox.dtb: $(BUILD)/barebox/done/build
	$(CP) $(BUILD)/barebox/build/arch/arm/dts/apple-m1-j274.dtb $@

$(BUILD)/barebox.image.sendfile: $(BUILD)/barebox.dtb

$(BUILD)/barebox.image.d/sendfile: $(BUILD)/barebox/done/build | $(BUILD)/barebox.image.d/
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

$(BUILD)/barebox/done/install: $(BUILD)/barebox/done/build
	@touch $@

$(BUILD)/barebox/done/build: $(BUILD)/barebox/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	@touch $@

$(BUILD)/barebox/done/configure: bootloaders/barebox/barebox.config $(BUILD)/barebox/done/copy $(BUILD)/gcc/done/gcc/install $(BUILD)/glibc/done/glibc/install
	$(CP) $< $(BUILD)/barebox/build/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/barebox/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	@touch $@

$(BUILD)/barebox/done/copy: $(BUILD)/barebox/done/checkout | $(BUILD)/barebox/done/ $(BUILD)/barebox/build/
	$(CP) -aus $(PWD)/bootloaders/barebox/barebox/* $(BUILD)/barebox/build/
	@touch $@

$(BUILD)/barebox/done/checkout: | $(BUILD)/barebox/done/
	$(MAKE) bootloaders/barebox/barebox{checkout}
	@touch $@

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/barebox.image
$(BUILD)/initramfs/pearl/boot/barebox.image: $(BUILD)/barebox.image ; $(COPY)

$(call pearl-static,$(wildcard bootloaders/barebox/pearl/bin/*),bootloaders/barebox/pearl)

SECTARGETS += $(BUILD)/barebox/done/build
SECTARGETS += $(BUILD)/barebox.image
SECTARGETS += $(BUILD)/barebox.image.sendfile
SECTARGETS += $(BUILD)/initramfs/pearl/boot/barebox.image
