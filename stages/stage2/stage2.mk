build/initfs/common.tar: \
	build/initfs/common/linux.image \
	build/initfs/common/linux.dtb \
	build/initfs/common/bin/stage2

build/initfs/common/bin/stage2: stages/stage2/init
	$(MKDIR) $(dir $@)
	$(CP) $< $@
	chmod ug+x $@
