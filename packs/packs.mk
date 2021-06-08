include packs/pearl/pearl.mk

include packs/debootstrap/debootstrap.mk

define perpack
build/packs/$(pack)/common.tar: $(common-$(pack):%=build/packs/$(pack)/common/%)
	$$(MKDIR) $$(dir $$@)
	(cd build/packs/$(pack); tar c $$(^:build/packs/$(pack)/%=%)) > $$@

build/packs/$(pack)/stages.tar: $(stages-$(pack):%=build/packs/$(pack)/stages/%)
	$$(MKDIR) $$(dir $$@)
	(cd build/packs/$(pack); tar c $$(^:build/packs/$(pack)/%=%)) > $$@

build/packs/$(pack).cpiospec: packs/$(pack)/$(pack).cpiospec
	$$(MKDIR) $$(dir $$@)
	(cat $$<; $$(foreach file,$$(patsubst build/packs/$(pack)/%,/%,$$(wordlist 2,$$(words $$^),$$^)),echo dir $$(dir $(patsubst %/,%,$$(file))) 755 0 0; echo file $$(file) $$(PWD)/build/packs/$(pack)/$$(file) 755 0 0;)) | sort | uniq > $$@


build/packs/$(pack)/%: packs/$(pack)/% ; $$(COPY)
build/packs/$(pack)/bin/%: build/dt/bin/% ; $$(COPY)
build/packs/$(pack)/bin/busybox: build/busybox/busybox; $$(COPY)
build/packs/$(pack)/bin/kexec: build/kexec/kexec; $$(COPY)
build/packs/$(pack)/bin/m1n1: packs/$(pack)/bin/m1n1 ; $$(COPY)
build/packs/$(pack)/bin/macho-image-fill: build/macho-image-fill ; $$(COPY)
build/packs/$(pack)/bin/memtool: build/memtool/memtool ; $$(COPY)
build/packs/$(pack)/bin/memdump-to-image: build/memdump/memdump-to-image ; $$(COPY)
build/packs/$(pack)/bin/macho-to-memdump: build/memdump/macho-to-memdump ; $$(COPY)
build/packs/$(pack)/bin/receive-commfile: build/commfile/receive-commfile ; $$(COPY)
build/packs/$(pack)/boot/linux.dtb: build/stages/linux/linux.dtb ; $$(COPY)
build/packs/$(pack)/boot/linux.image: build/stages/linux/linux.image ; $$(COPY)
build/packs/$(pack)/boot/m1n1.macho.image: build/m1n1.macho.image ; $$(COPY)
build/packs/$(pack)/boot/m1n1.macho: build/m1n1.macho ; $$(COPY)
build/packs/$(pack)/boot/stage2.dtb: build/stages/stage2/stage2.dtb ; $$(COPY)
build/packs/$(pack)/boot/stage2.image: build/stages/stage2/stage2.image ; $$(COPY)
build/packs/$(pack)/boot/u-boot.image: build/u-boot/u-boot.bin ; $$(COPY)
build/packs/$(pack)/boot/barebox.image: build/barebox/images/barebox-dt-2nd.img ; $$(COPY)
build/packs/$(pack)/boot/u-boot-plus-grub.image: build/u-boot-plus-grub.image ; $$(COPY)
build/packs/$(pack)/boot/u-boot.dtb: build/u-boot/u-boot.dtb ; $$(COPY)
build/packs/$(pack)/deb.tar: build/deb.tar ; $$(COPY)
build/packs/$(pack)/init: packs/$(pack)/bin/init ; $$(COPY)
build/packs/$(pack)/modules.tar: build/stages/linux/linux-modules.tar ; $$(COPY)
build/packs/$(pack)/blobs.tar: build/blobs.tar ; $$(COPY)

build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/adtdump
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/adtp
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/barebox
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/busybox
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/dt
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/enable-wdt
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/gadget
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/init
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/init-linux
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/init-stage1
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/init-stage2
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/init-stage3
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/interactor
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/kexec
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/linux
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/macho-image-fill
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/macho-to-memdump
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/memdump-to-image
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/memtool
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/m1n1
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/receive-commfile
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/prepare-linux
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/prepare-stage2
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/stage1
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/stage2
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/stage3
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/u-boot
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/wifi
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/x2r10g10b10
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/barebox.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/linux.dtb
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/linux.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/m1n1.macho
# build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/m1n1.macho.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/stage2.dtb
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/stage2.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/u-boot.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/u-boot-plus-grub.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/u-boot.dtb
build/packs/$(pack).cpiospec: build/packs/$(pack)/blobs.tar
build/packs/$(pack).cpiospec: build/packs/$(pack)/deb.tar
build/packs/$(pack).cpiospec: build/packs/$(pack)/modules.tar
build/packs/$(pack).cpiospec: build/packs/$(pack)/init

build/packs/$(pack).cpio: build/packs/$(pack).cpiospec build/stages/linux/linux.image
	(cd build/linux/linux; $$(PWD)/submodule/linux/usr/gen_initramfs.sh -o $$(PWD)/$$@ ../../../$$<)

endef

$(foreach pack,$(packs),$(eval $(perpack)))
