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
NATIVE_CODE_ENV = QEMU_LD_PREFIX=$(BUILD)/pearl/install LD_LIBRARY_PATH=$(BUILD)/pearl/install/lib

define COPY
	$(MKDIR) -p $(dir $@)
	$(CP) -a $< $@
endef

all:

%/:
	$(MKDIR) $@

clean:
	rm -rf build

include toolchain/toolchain.mk

include linux/linux.mk

include userspace/userspace.mk

include local/local.mk

include bootloaders/bootloaders.mk

include g/github/github.mk

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

.PHONY: %}

.SECONDARY:
