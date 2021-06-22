include toolchain/binutils-gdb/binutils-gdb.mk
include toolchain/gcc/gcc.mk

$(BUILD)/toolchain.tar: $(BUILD)/binutils-gdb/done/install $(BUILD)/gcc/done/gcc/install
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/toolchain $(BUILD)/pearl/install $(BUILD)/pearl/toolchain $(wildcard $(BUILD)/*/done))
