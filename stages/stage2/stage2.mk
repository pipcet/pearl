build/stages/stage2/initfs/boot/linux.image: \
	build/stages/linux/linux.image
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage2/initfs/boot/linux.dtb: \
	build/stages/linux/linux.dtb
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/common.tar: \
	build/initfs/common/linux.image \
	build/initfs/common/linux.dtb
