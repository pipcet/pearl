stages += linux
linux-stages += linux

build/initfs/common.tar: \
	build/initfs/common/boot/linux.image \
	build/initfs/common/boot/linux.dtb

build/initfs/common/bin/linux: stages/linux/init
	$(MKDIR) $(dir $@)
	$(CP) $< $@
	chmod ug+x $@
