build/initfs/common/kexec.tar: build/kexec/kexec
	$(MKDIR) $(dir $@)
	$(MKDIR) build/initfs/common/bin
	$(CP) $< build/initfs/common/bin
	(cd build/initfs/common; tar c bin/kexec) > $@

build/initfs/common.cpio: initfs/common.cpiospec build/stages/linux/linux.image
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)

build/initfs/complete.cpiospec: initfs/complete.cpiospec build/initfs/bin/busybox build/initfs/init build/initfs/common.cpio build/initfs/common.tar
	(cat $<; $(foreach file,$(patsubst build/stages/$(stage)/initfs/%,/%,$(wordlist 2,$(words $^),$^)),echo dir $(dir $(patsubst %/,%,$(file))) 755 0 0; echo file $(file) $(PWD)/$(file) 755 0 0;)) | sort | uniq > $@

build/initfs/complete.cpio: build/initfs/complete.cpiospec
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)

build/initfs/bin/stage1: stages/stage1/init
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/init: build/initfs/bin/stage1
	$(MKDIR) $(dir $@)
	ln -sf bin/stage1 $@

build/initfs/bin/busybox: build/busybox/busybox
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/common.tar: \
	build/initfs/common/dt.tar \
	build/initfs/common/deb.tar \
	build/initfs/common/kexec.tar
	$(MKDIR) $(dir $@)
	(cd build/initfs/common; tar c $(^:build/initfs/common/%=%)) > $@

build/initfs/common.tar: \
	build/initfs/common/boot/stage2.image \
	build/initfs/common/boot/linux.image
