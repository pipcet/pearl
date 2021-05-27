build/stages/stage1/stage1.cpiospec: \
	build/stages/stage1/initfs/boot/stage2.image \
	build/stages/stage1/initfs/boot/stage2.dtb

build/stages/stage1/initfs/boot/stage2.image: \
	build/stages/stage2/stage2.image
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage1/initfs/boot/stage2.dtb: \
	build/stages/stage2/stage2.dtb
	$(MKDIR) $(dir $@)
	$(CP) $< $@
