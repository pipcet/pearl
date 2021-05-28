stages += stage2
linux-stages += stage2

build/initfs/common.tar: \
	build/initfs/common/bin/stage2

build/initfs/common/bin/stage2: stages/stage2/init
	$(MKDIR) $(dir $@)
	$(CP) $< $@
	chmod ug+x $@
