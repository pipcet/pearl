include bootloaders/m1n1/m1n1.mk
include bootloaders/barebox/barebox.mk
include bootloaders/u-boot/u-boot.mk
include bootloaders/grub/grub.mk

$(BUILD)/bootloaders.tar: $(call done,bootloaders/m1n1,install) $(call done,bootloaders/barebox,install) $(call done,bootloaders/u-boot,install) $(call done,bootloaders/grub,install) $(BOOTLOADER_FILES)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BOOTLOADER_FILES))

SECTARGETS += $(BUILD)/bootloaders.tar
