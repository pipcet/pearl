CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)
NATIVE_TRIPLE ?= amd64-linux-gnu
BUILD ?= $(PWD)/build
DONE ?= $(PWD)/done
CROSS_CFLAGS = -Os --sysroot=$(BUILD)/pearl/install -B$(BUILD)/pearl/toolchain/lib/gcc/aarch64-linux-gnu/13.0.0/ -L$(BUILD)/pearl/install/lib -I$(BUILD)/pearl/install/include
CROSS_CC = $(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-gcc
CROSS_PATH = $(BUILD)/pearl/toolchain/bin
WITH_CROSS_PATH = PATH="$(CROSS_PATH):$$PATH"
WITH_CROSS_CFLAGS = CFLAGS="$(CROSS_CFLAGS)"
WITH_CROSS_COMPILE = CROSS_COMPILE=aarch64-linux-gnu-
WITH_CROSS_CC= CC="$(CROSS_CC)"
NATIVE_CODE_ENV = QEMU_LD_PREFIX=$(BUILD)/pearl/install LD_LIBRARY_PATH=$(BUILD)/pearl/install/lib
WITH_QEMU = $(NATIVE_CODE_ENV)

all: $(BUILD)/pearl.pl

.SECONDEXPANSION:

define done
$(DONE)/$(1)/$(2)
endef

define install
$(BUILD)/pearl/install
endef

define INSTALL_LIBS
echo
endef

define pearl-static-file
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/$(patsubst $(2)/%,%,$(1))
$(BUILD)/initramfs/pearl/$(patsubst $(2)/%,%,$(1)): $(1) ; $$(COPY)
endef

define pearl-static
$(foreach file,$(1),$(eval $(call pearl-static-file,$(file),$(2))))
endef

define deps
$$(foreach dep,$(1),$$(DEP_$$(dep)))
endef

define COPY
	$(MKDIR) -p $(dir $@)
	$(CP) --reflink=auto $< $@
endef

define SYMLINK
	$(MKDIR) -p $(dir $@)
	ln -sf $< $@
endef

define COPY_SAUNA
	$(CP) -ausn
endef

define TIMESTAMP
	@date --iso=ns > $@
endef

all:

%/:
	$(MKDIR) $@

clean:
	rm -rf build

include host/host.mk

include toolchain/toolchain.mk

include linux/linux.mk

include userspace/userspace.mk

include local/local.mk

include bootloaders/bootloaders.mk

include debian/debian.mk

ifeq ($(FACTION),)
include g/github/github.mk
else
include g/faction/faction.mk
endif

include builder/builder.mk

include blobs/blobs.mk

include sendfile/sendfile.mk

include zstd/zstd.mk

include qemu/qemu.mk

include video/video.mk

$(BUILD)/install%.tar: | $(BUILD)/pearl/build/install/
	tar -C $(BUILD)/pearl/build/install -cf $@ .

$(call done,pearl,install/mkdir): | $(call done,pearl,install/) $(BUILD)/pearl/install/include/ $(BUILD)/pearl/install/bin/
	ln -sf . $(BUILD)/pearl/install/usr
	ln -sf . $(BUILD)/pearl/install/local
	ln -sf bin $(BUILD)/pearl/install/sbin
	$(TIMESTAMP)

build/%: $(PWD)/build/%
	@true

done/%: $(PWD)/done/%
	@true

%.dts.h: %.dts dtc/dtc-relocs
	$(CC) -E -x assembler-with-cpp -nostdinc $< | dtc/dtc-relocs > $@

%.xz: %
	xzcat -z --verbose < $< > $@

%.zstd: %
	zstd -cv < $< > $@

%!:
	rm -f $*
	$(MAKE) $*

.PHONY: %} %!

random-target:
	target=$$( (echo build/linux/pearl.image.sendfile; \
	 echo build/linux/pearl.image.macho; \
	 echo $(call done,userspace/busybox,install); \
	 echo $(call done,userspace/cryptsetup,install); \
	 echo $(call done,userspace/dialog,install); \
	 echo $(call done,userspace/dtc,install); \
	 echo $(call done,userspace/emacs,install); \
	 echo $(call done,userspace/glibc,install); \
	 echo $(call done,userspace/IPC-Run,install); \
	 echo $(call done,userspace/json-c,install); \
	 echo $(call done,userspace/kexec-tools,install); \
	 echo $(call done,userspace/libaio,install); \
	 echo $(call done,userspace/libnl,install); \
	 echo $(call done,userspace/lvm2,install); \
	 echo $(call done,userspace/memtool,install); \
	 echo $(call done,userspace/ncurses,install); \
	 echo $(call done,userspace/openssl,install); \
	 echo $(call done,userspace/perl,install); \
	 echo $(call done,userspace/popt,install); \
	 echo $(call done,userspace/procps,install); \
	 echo $(call done,userspace/screen,install); \
	 echo $(call done,userspace/slurp,install); \
	 echo $(call done,userspace/libuuid,install); \
	 echo $(call done,userspace/libblkid,install)) | shuf | head -1); echo $$target; $(MAKE) $$target

$(BUILD)/pearl-debian.macho: $(BUILD)/linux/pearl.image.macho $(BUILD)/debian.cpio.zstd.pack
	(cat $^; echo "/bin/auto-boot-debian &") > $@

# It is unfortunately necessary for this to be a real file, as zstd
# needs a real file to properly store size information in the
# compressed stream.

$(BUILD)/pearl-debian-uncompressed.macho: $(BUILD)/linux/pearl.image.macho $(BUILD)/debian.cpio
	cat $^ > $@

$(BUILD)/pearl-dplusi-uncompressed.macho: $(BUILD)/linux/pearl.image.macho $(BUILD)/dplusi.cpio
	cat $^ > $@

$(BUILD)/pearl-debian.image: $(BUILD)/pearl-dplusi-uncompressed.macho.zst.image
	$(COPY)

$(BUILD)/kmutil-script: recovery/bin/kmutil-script
	$(COPY)

$(BUILD)/kmutil-script-raw: recovery/bin/kmutil-script-raw
	$(COPY)

build/pearl.pl:
	$(MAKE) $(PWD)/build/pearl.pl

build/qemu.tar:
	$(MAKE) $(PWD)/build/qemu.tar

build/linux/linux.dtbs:
	$(MAKE) $(PWD)/build/linux/linux.dtbs

build/linux/stage2.dtbs:
	$(MAKE) $(PWD)/build/linux/stage2.dtbs

$(BUILD)/pearl-old.pl: $(BUILD)/kmutil-script $(BUILD)/pearl-debian.macho host/pack/pack.pl recovery/bin/readline.pm
	perl host/pack/pack.pl $(BUILD)/kmutil-script recovery/bin/readline.pm $(BUILD)/pearl-debian.macho host/pack/pack.bash > $@

$(BUILD)/pearl.pl: $(BUILD)/kmutil-script-raw $(BUILD)/pearl-debian-uncompressed.macho.zst.image host/pack/pack.pl recovery/bin/readline.pm
	perl host/pack/pack.pl $(BUILD)/kmutil-script-raw recovery/bin/readline.pm $(BUILD)/pearl-debian-uncompressed.macho.zst.image host/pack/pack.bash > $@

$(call pearl-static,$(wildcard $(PWD)/pearl/bin/* $(PWD)/pearl/init),$(PWD)/pearl)

SECTARGETS += $(BUILD)/linux/pearl.image.macho
SECTARGETS += $(BUILD)/pearl-debian.macho
SECTARGETS += $(BUILD)/pearl-old.pl
SECTARGETS += $(BUILD)/pearl.pl

delsex:
	rm -f $(SECTARGETS)

.SECONDARY:
