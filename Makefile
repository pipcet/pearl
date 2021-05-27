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

stamp/%: | stamp/
	touch $@

# echo $((1024*1024)) | sudo tee /proc/sys/fs/inotify/max_user_watches
stampserver: g/stampserver/stampserver.pl | stamp/
	inotifywait -m -r . | perl g/stampserver/stampserver.pl

# Alias target
build/pearl.macho: build/stages/stage1/stage1.image.macho | build/
	$(CP) $< $@

define perstage
linux/$(stage){oldconfig}: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(CP) $$< $$<.old
	$$(CP) build/linux/$(stage)/.config $$<

linux/$(stage){menuconfig}: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) menuconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(CP) $$< $$<.old
	$$(CP) build/linux/$(stage)/.config $$<

build/stages/$(stage)/$(stage).image: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(MAKE) -C build/linux/$(stage) ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) Image dtbs
	$$(CP) build/linux/$(stage)/arch/arm64/boot/Image $$@

build/stages/$(stage)/$(stage).dtb: build/stages/$(stage)/$(stage).image
	$$(CP) build/linux/$(stage)/arch/arm64/boot/dts/apple/apple-m1-j293.dtb $$<

build/stages/$(stage)/$(stage).image: stamp/linux

build/stages/$(stage)/linux.config: stages/$(stage)/linux.config build/stages/$(stage)/$(stage).cpiospec
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/bin/busybox: build/busybox/busybox | build/stages/$(stage)/bin/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/bin/kexec: build/kexec-tools/kexec | build/stages/$(stage)/bin/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/deb.tar.gz: build/deb.tar.gz | build/stages/$(stage)/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/initfs/dt.tar.gz: build/dt.tar.gz | build/stages/$(stage)/
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/stages/$(stage)/$(stage).cpiospec: \
	stages/$(stage)/fixed.cpiospec \
	build/stages/$(stage)/initfs/init \
	build/stages/$(stage)/initfs/bin/busybox \
	build/stages/$(stage)/initfs/bin/kexec \
	build/stages/$(stage)/initfs/deb.tar.gz \
	build/stages/$(stage)/initfs/dt.tar.gz
	(cat $$<; $$(foreach file,$$(patsubst build/stages/$(stage)/initfs/%,/%,$$(wordlist 2,$$(words $$^),$$^)),echo dir $$(dir $$(patsubst %/,%,$$(file))) 755 0 0; echo file $$(file) $(PWD)/build/stages/$(stage)/initfs/$$(file) 755 0 0;)) | sort | uniq > $$@

build/stages/$(stage)/initfs/init: stages/$(stage)/init | build/stages/$(stage)/initfs/
	$$(CP) $$< $$@

build/stages/$(stage)/$(stage).cpiospec: | build/stages/$(stage)/
build/stages/$(stage)/$(stage).image: | build/stages/$(stage)/
build/stages/$(stage)/initfs/init: | build/stages/$(stage)/initfs/
endef

$(foreach stage,stage1 linux,$(eval $(perstage)))
%.dtb.h: %.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/stages/stage1/stage1.dts.dtb: stages/stage1/stage1.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@
build/stages/stage1/stage1.image: build/stages/stage1/stage1.dts.dtb.h

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
