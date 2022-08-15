include toolchain/binutils-gdb/binutils-gdb.mk
include toolchain/gcc/gcc.mk

ifeq ($(filter toolchain,$(RELEASED_ARTIFACTS)),)
$(BUILD)/toolchain.tar: $(call done,toolchain/binutils-gdb,install) $(call done,toolchain/gcc,gcc/install) $(call done,userspace/glibc,glibc/install)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BUILD)/pearl/install done)
else
$(BUILD)/toolchain.tar: $(BUILD)/released/pipcet/pearl-toolchain/toolchain.tar.zstd{}
	zstd -d < $(BUILD)/released/pipcet/pearl-toolchain/toolchain.tar.zstd > $@
endif

ifeq ($(filter libgcc,$(RELEASED_ARTIFACTS)),)
$(BUILD)/libgcc.tar: $(call done,toolchain/gcc,libgcc/install)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BUILD)/pearl/install done)
else
$(BUILD)/libgcc.tar: $(BUILD)/released/pipcet/pearl-toolchain/libgcc.tar.zstd{}
	zstd -d < $(BUILD)/released/pipcet/pearl-toolchain/libgcc.tar.zstd > $@
endif

SECTARGETS += $(BUILD)/toolchain.tar
