CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)

# INCLUDE_DEBOOTSTRAP = t
INCLUDE_MODULES = t

all: build/pearl.macho build/debootstrap.macho build/m1n1.macho

%/:
	$(MKDIR) $@

clean:
	rm -rf build

# Alias targets
build/pearl.macho: build/images/pearl/pearl.image.macho | build/
	$(CP) $< $@

build/debootstrap.macho: build/images/debootstrap/debootstrap.image.macho | build/
	$(CP) $< $@

include g/stampserver/stampserver.mk

include dtc/dtc.mk

include linux/linux.mk

include deb/deb.mk

include snippet/snippet.mk

include macho-tools/macho-tools.mk

include busybox/busybox.mk

include kexec/kexec.mk

include dt/dt.mk

include blobs/blobs.mk

# Utilities not required for ordinary booting
include commfile/commfile.mk

include m1n1/m1n1.mk

include debootstrap/debootstrap.mk

# Stages, packs, images
include stages/stages.mk

include packs/packs.mk

include images/images.mk

# GitHub integration
include github/github.mk

.PHONY: %}
