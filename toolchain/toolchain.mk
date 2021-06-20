include toolchain/binutils-gdb/binutils-gdb.mk
include toolchain/gcc/gcc.mk

$(BUILD)/toolchain.tar: $(BUILD)/binutils-gdb/done/install $(BUILD)/gcc/done/gcc/install
	tar -C $(BUILD) -cf $@ pearl/toolchain $(patsubst $(BUILD)/%,%,$(wildcard $(BUILD)/*/done))
