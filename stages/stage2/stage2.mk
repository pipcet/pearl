build/stages/stage2/stage2.cpiospec: \
	build/stages/stage2/initfs/boot/linux.image \
	build/stages/stage2/initfs/boot/linux.initfs \
	build/stages/stage2/initfs/boot/linux.dtb

build/stages/stage2/initfs/boot/linux.image: \
	build/stages/linux/linux.image
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage2/initfs/boot/linux.dtb: \
	build/stages/linux/linux.dtb
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage2/initfs/boot/linux.initfs: \
	build/stages/linux/linux.initfs
	$(MKDIR) $(dir $@)
	$(CP) $< $@

