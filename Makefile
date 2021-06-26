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
	$(CP) -a $< $@
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

%.zst: %
	zstd -cv < $< > $@

.PHONY: %}

random-target:
	target=$$( (echo build/linux/pearl.image.sendfile; \
	 echo build/linux/pearl.image.macho; \
	 echo build/busybox/done/install; \
	 echo build/cryptsetup/done/install; \
	 echo build/dialog/done/install; \
	 echo build/dtc/done/install; \
	 echo build/emacs/done/install; \
	 echo build/glibc/done/install; \
	 echo build/IPC-Run/done/install; \
	 echo build/json-c/done/install; \
	 echo build/kexec-tools/done/install; \
	 echo build/libaio/done/install; \
	 echo build/libnl/done/install; \
	 echo build/lvm2/done/install; \
	 echo build/memtool/done/install; \
	 echo build/ncurses/done/install; \
	 echo build/nvme-cli/done/install; \
	 echo build/openssl/done/install; \
	 echo build/perl/done/install; \
	 echo build/popt/done/install; \
	 echo build/procps/done/install; \
	 echo build/screen/done/install; \
	 echo build/slurp/done/install; \
	 echo build/libuuid/done/install; \
	 echo build/libblkid/done/install) | shuf | head -1); echo $$target; $(MAKE) $$target

.SECONDARY: %/
