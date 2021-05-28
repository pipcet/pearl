CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)
DTC ?= dtc

# INCLUDE_DEBOOTSTRAP = t
INCLUDE_MODULES = t

all: build/pearl.macho

%/:
	$(MKDIR) $@

clean:
	rm -rf build

include g/stampserver/stampserver.mk

# Alias target
build/pearl.macho: build/stages/stage1/stage1.image.macho | build/
	$(CP) $< $@

define perstage
build/stages/$(stage)/linux.config: stages/$(stage)/linux.config
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/common.tar: build/initfs/common.tar
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/bin/kexec: build/kexec/kexec | build/stages/$(stage)/bin/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/deb.tar: build/deb.tar | build/stages/$(stage)/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/dt.tar: build/dt.tar | build/stages/$(stage)/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/init: stages/$(stage)/init | build/stages/$(stage)/initfs/
	$$(CP) $$< $$@

build/stages/$(stage)/$(stage).image: | build/stages/$(stage)/
build/stages/$(stage)/initfs/init: | build/stages/$(stage)/initfs/
endef

include linux/linux.mk

$(foreach stage,stage1 stage2 linux,$(eval $(perstage)))
$(foreach stage,stage1 stage2 linux,$(eval $(linux-perstage)))

build/stages/stage1/linux.config: build/initfs/complete.cpio

%.dtb.h: %.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/stages/stage1/stage1.dts.dtb: stages/stage1/stage1.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@
build/stages/stage1/stage1.image: build/stages/stage1/stage1.dts.dtb.h

build/initfs/common/kexec.tar: build/kexec/kexec
	$(MKDIR) $(dir $@)
	$(MKDIR) build/initfs/common/bin
	$(CP) $< build/initfs/common/bin
	(cd build/initfs/common; tar c bin/kexec) > $@

build/initfs/common.cpio: initfs/common.cpiospec build/stages/linux/linux.image
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)

build/initfs/complete.cpio: initfs/complete.cpiospec build/stages/linux/linux.image build/initfs/bin/busybox )build/initfs/init build/initfs/common.cpio build/initfs/common.tar
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)

build/initfs/init: stages/stage1/init
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/bin/busybox: build/busybox/busybox
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/initfs/common.tar: \
	build/initfs/common/dt.tar \
	build/initfs/common/deb.tar \
	build/initfs/common/kexec.tar
	$(MKDIR) $(dir $@)
	(cd build/initfs; tar c $(^:build/initfs/%=%)) > $@

build/initfs/common.tar: \
	build/initfs/common/stage2.image \
	build/initfs/common/linux.image

include stages/stages.mk

include deb/deb.mk

build/%..h: build/%.c.S.elf.bin.s.h
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/%..h: build/%.S.elf.bin.s.h
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/include/snippet.h: snippet/snippet.h | build/include/
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/%.S: %.S
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/%.c: %.c
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/%.c.S: build/%.c build/include/snippet.h
	$(CROSS_COMPILE)gcc -Ibuild/$(dir $<) -Ibuild/include -fno-builtin -ffunction-sections -march=armv8.5-a -Os -S -o $@ $<

build/%.S.elf: build/%.S
	$(CROSS_COMPILE)gcc -Os -static -march=armv8.5-a -nostdlib -o $@ $<

build/%.elf.bin: build/%.elf
	$(CROSS_COMPILE)objcopy -O binary -S --only-section .pretext.0 --only-section .text --only-section .data --only-section .got --only-section .last --only-section .text.2 $< $@

build/%.bin.s: build/%.bin
	$(CROSS_COMPILE)objdump -maarch64 --disassemble-zeroes -D -bbinary $< > $@

build/%.s.h: build/%.s
	(NAME=$$(echo $(notdir $*) | sed -e 's/\..*//' -e 's/-/_/g'); echo "unsigned int $$NAME[] = {";  cat $< | tail -n +8 | sed -e 's/\t/ /g' | sed -e 's/^\(.*\):[ \t]*\([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]\)[ \t]*\(.*\)$$/\t0x\2 \/\* \1: \3 \*\/,/g'; echo "};") > $@

include macho-tools/macho-tools.mk

build/%.image.macho: build/%.image build/host/image-to-macho
	build/host/image-to-macho $< $@

include busybox/busybox.mk

include kexec/kexec.mk

include dt/dt.mk

include github/github.mk

include m1n1.mk

.SECONDARY:
.PHONY: %}
