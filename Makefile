CROSS_COMPILE ?= aarch64-linux-gnu-
M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -1)
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
build/pearl.macho: build/stages/stage1/stage1.macho | build/
	$(CP) $< $@

define perstage
build/stages/$(stage)/$(stage).image: build/stages/$(stage)/linux.config
	$$(MKDIR) build/linux/$(stage)
	$$(CP) $$< build/linux/$(stage)/.config
	$$(MAKE) -C submodule/linux ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) O=$(PWD)/build/linux/$(stage) oldconfig
	diff -u $$< build/linux/$(stage)/.config || true
	$$(MAKE) -C build/linux/$(stage) ARCH=arm64 CROSS_COMPILE=$$(CROSS_COMPILE) Image dtbs
	$$(CP) build/linux/$(stage)/arch/arm64/boot/Image $$@

build/stages/$(stage)/$(stage).image: stamp/linux

build/stages/$(stage)/linux.config: stages/$(stage)/linux.config build/stages/$(stage)/$(stage).cpiospec
	$$(CP) $$< $$@

build/stages/$(stage)/$(stage).cpiospec: \
	stages/$(stage)/fixed.cpiospec \
	build/stages/$(stage)/initfs/init
	(cat $$<; $$(foreach file,$$(patsubst build/stages/$(stage)/initfs/%,/%,$$(wordlist 2,$$(words $$^),$$^)),echo dir $$(dir $$(patsubst %/,%,$$(file))) 755 0 0; echo file $$(file) $(PWD)/build/stages/$(stage)/initfs/$$(file) 755 0 0;)) | sort | uniq > $$@

build/stages/$(stage)/initfs/init: stages/$(stage)/init | build/stages/$(stage)/initfs/
	$$(CP) $$< $$@

build/stages/$(stage)/$(stage).cpiospec: | build/stages/$(stage)/
build/stages/$(stage)/$(stage).image: | build/stages/$(stage)/
build/stages/$(stage)/initfs/init: | build/stages/$(stage)/initfs/
endef

$(foreach stage,stage1,$(eval $(perstage)))
%.dtb.h: %.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/stages/stage1/stage1.dts.dtb: stages/stage1/stage1.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@
build/stages/stage1/stage1.image: build/stages/stage1/stage1.dts.dtb.h

.SECONDARY:
.PHONY: %}
