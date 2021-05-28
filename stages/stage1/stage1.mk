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

build/stages/stage1/stage1.cpio: \
	stages/stage1/stage1.cpiospec \
	build/busybox/busybox \
	build/initfs/common.cpio \
	build/initfs/common.tar
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)

build/stages/stage1/stage1.image: \
	build/initfs/complete.cpio

build/initfs/common.tar: \
	build/initfs/common/stage2.image \
	build/initfs/common/stage2.dtb
