CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)
NATIVE_TRIPLE ?= amd64-linux-gnu
BUILD ?= $(PWD)/build
CROSS_CFLAGS = -Os --sysroot=$(BUILD)/pearl/install -B$(BUILD)/pearl/install -L$(BUILD)/pearl/install/lib -I$(BUILD)/pearl/install/include
CROSS_CC = $(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-gcc
CROSS_PATH = $(BUILD)/pearl/toolchain/bin
WITH_CROSS_PATH = PATH="$(CROSS_PATH):$$PATH"
WITH_CROSS_CFLAGS = CFLAGS="$(CROSS_CFLAGS)"
WITH_CROSS_COMPILE = CROSS_COMPILE=aarch64-linux-gnu-
WITH_CROSS_CC= CC="$(CROSS_CC)"
NATIVE_CODE_ENV = QEMU_LD_PREFIX=$(BUILD)/pearl/install LD_LIBRARY_PATH=$(BUILD)/pearl/install/lib
WITH_QEMU = $(NATIVE_CODE_ENV)

.SECONDEXPANSION:

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

include g/github/github.mk

include blobs/blobs.mk

include sendfile/sendfile.mk

include zstd/zstd.mk

$(BUILD)/install%.tar: | $(BUILD)/pearl/build/install/
	tar -C $(BUILD)/pearl/build/install -cf $@ .

$(BUILD)/pearl/done/install/mkdir: | $(BUILD)/pearl/done/install/ $(BUILD)/pearl/install/include/ $(BUILD)/pearl/install/bin/
	ln -sf . $(BUILD)/pearl/install/usr
	ln -sf . $(BUILD)/pearl/install/local
	ln -sf bin $(BUILD)/pearl/install/sbin
	@touch $@

build/%: $(PWD)/build/%
	@true

%.dts.h: %.dts dtc/dtc-relocs
	$(CC) -E -x assembler-with-cpp -nostdinc $< | dtc/dtc-relocs > $@

%.xz: %
	xzcat -z --verbose < $< > $@

%.zstd: %
	zstd -cv < $< > $@

.PHONY: %}

random-target:
	target=$$( (echo build/linux/pearl.image.sendfile; \
	 echo build/linux/pearl.image.macho; \
	 echo build/userspace/busybox/done/install; \
	 echo build/userspace/cryptsetup/done/install; \
	 echo build/userspace/dialog/done/install; \
	 echo build/userspace/dtc/done/install; \
	 echo build/userspace/emacs/done/install; \
	 echo build/userspace/glibc/done/install; \
	 echo build/userspace/IPC-Run/done/install; \
	 echo build/userspace/json-c/done/install; \
	 echo build/userspace/kexec-tools/done/install; \
	 echo build/userspace/libaio/done/install; \
	 echo build/userspace/libnl/done/install; \
	 echo build/userspace/lvm2/done/install; \
	 echo build/userspace/memtool/done/install; \
	 echo build/userspace/ncurses/done/install; \
	 echo build/userspace/openssl/done/install; \
	 echo build/userspace/perl/done/install; \
	 echo build/userspace/popt/done/install; \
	 echo build/userspace/procps/done/install; \
	 echo build/userspace/screen/done/install; \
	 echo build/userspace/slurp/done/install; \
	 echo build/userspace/libuuid/done/install; \
	 echo build/userspace/libblkid/done/install) | shuf | head -1); echo $$target; $(MAKE) $$target

$(BUILD)/pearl-debian.macho: $(BUILD)/linux/pearl.image.macho $(BUILD)/debian.cpio.zstd.pack
	(cat $^; echo "/bin/auto-boot-debian &") > $@

# It is unfortunately necessary for this to be a real file, as zstd
# needs a real file to properly store size information in the
# compressed stream.

$(BUILD)/pearl-debian-uncompressed.macho: $(BUILD)/linux/pearl.image.macho $(BUILD)/debian.cpio
	cat $^ > $@

$(BUILD)/kmutil-script: recovery/bin/kmutil-script
	$(COPY)

$(BUILD)/kmutil-script-raw: recovery/bin/kmutil-script-raw
	$(COPY)

build/pearl.pl:
	$(MAKE) $(PWD)/build/pearl.pl

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
