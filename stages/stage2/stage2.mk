build/stages/stage2/stage2.cpiospec: \
	build/stages/stage1/initfs/boot/linux.image \
	build/stages/stage1/initfs/boot/linux.dtb

build/stages/stage2/initfs/boot/linux.image: \
	build/stages/linux/linux.image
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage2/initfs/boot/linux.dtb: \
	build/stages/linux/linux.dtb
	$(MKDIR) $(dir $@)
	$(CP) $< $@

