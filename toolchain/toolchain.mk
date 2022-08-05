include toolchain/binutils-gdb/binutils-gdb.mk
include toolchain/gcc/gcc.mk

$(BUILD)/toolchain.tar: $(call done,toolchain/binutils-gdb,install) $(call done,toolchain/gcc,gcc/install) $(call done,toolchain/gcc,libgcc/install)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BUILD)/pearl/install done)

SECTARGETS += $(BUILD)/toolchain.tar
