CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)
NATIVE_TRIPLE ?= amd64-linux-gnu
BUILD ?= $(PWD)/build
CROSS_CFLAGS = -Os --sysroot=$(BUILD)/install -B$(BUILD)/install -L$(BUILD)/install/lib -I$(BUILD)/install/include
CROSS_CC = $(BUILD)/install/bin/aarch64-linux-gnu-gcc
CROSS_PATH = $(BUILD)/install/bin
NATIVE_CODE_ENV = QEMU_LD_PREFIX=$(BUILD)/install LD_LIBRARY_PATH=$(BUILD)/install/lib

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

$(BUILD)/done/install/mkdir: | $(BUILD)/done/install/
	mkdir -p $(BUILD)/install $(BUILD)/install/include
	ln -sf . $(BUILD)/install/usr
	ln -sf . $(BUILD)/install/local
	touch $@

build/%: $(PWD)/build/%
	@true
