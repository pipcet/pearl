include toolchain/binutils-gdb/binutils-gdb.mk
include toolchain/gcc/gcc.mk

$(BUILD)/toolchain.tar: $(call done,toolchain/binutils-gdb,install) $(call done,toolchain/gcc,gcc/install)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BUILD)/pearl/install $(wildcard $(call done,toolchain/*,*)) $(wildcard $(call done,linux/*,*)) $(wildcard $(call done,userspace/*,*)))

SECTARGETS += $(BUILD)/toolchain.tar
