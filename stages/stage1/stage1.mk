stages += stage1
linux-stages += stage1

build/stages/stage1/stage1.cpio: build/packs/pearl.cpio
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/stages/stage1/stage1.image: \
	build/stages/stage1/stage1.cpio

build/stages/stage1/stage1.image: \
	build/stages/stage1/stage1.dts.dtb.h

build/stages/stage1/stage1.dts: stages/stage1/stage1.dts
	$(COPY)
