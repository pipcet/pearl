$(BUILD)/toolchain/binutils-gdb/done/install: $(BUILD)/toolchain/binutils-gdb/done/build
	$(MAKE) -C $(BUILD)/toolchain/binutils-gdb/source install
	@touch $@

$(BUILD)/toolchain/binutils-gdb.tar: $(BUILD)/toolchain/binutils-gdb/done/build
	tar -C $(BUILD)/toolchain/binutils-gdb -cf $@ done source

$(BUILD)/toolchain/binutils-gdb/done/build: $(BUILD)/toolchain/binutils-gdb/done/configure
	$(MAKE) -C $(BUILD)/toolchain/binutils-gdb/source
	@touch $@

$(BUILD)/toolchain/binutils-gdb/done/configure: $(BUILD)/toolchain/binutils-gdb/done/copy
	(cd $(BUILD)/toolchain/binutils-gdb/source/; ../source/configure --target=aarch64-linux-gnu --prefix=$(BUILD)/pearl/toolchain)
	@touch $@

$(BUILD)/toolchain/binutils-gdb/done/copy: $(BUILD)/toolchain/binutils-gdb/done/checkout | $(BUILD)/toolchain/binutils-gdb/source/ $(BUILD)/toolchain/binutils-gdb/done/
	$(CP) -aus $(PWD)/toolchain/binutils-gdb/binutils-gdb/* $(BUILD)/toolchain/binutils-gdb/source/
	@touch $@

$(BUILD)/toolchain/binutils-gdb/done/checkout: | $(BUILD)/toolchain/binutils-gdb/done/
	$(MAKE) toolchain/binutils-gdb/binutils-gdb{checkout}
	@touch $@
