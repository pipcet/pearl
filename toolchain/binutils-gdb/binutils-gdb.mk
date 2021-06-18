$(BUILD)/done/binutils-gdb/install: $(BUILD)/done/binutils-gdb/build
	$(MAKE) -C $(BUILD)/binutils-gdb/source DESTDIR=$(BUILD)/toolchain install
	@touch $@

$(BUILD)/done/binutils-gdb/build: $(BUILD)/done/binutils-gdb/configure
	$(MAKE) -C $(BUILD)/binutils-gdb/source
	@touch $@

$(BUILD)/done/binutils-gdb/configure: $(BUILD)/done/binutils-gdb/copy
	(cd $(BUILD)/binutils-gdb/source/; ../source/configure --target=aarch64-linux-gnu --prefix=$(BUILD)/toolchain)
	@touch $@

$(BUILD)/done/binutils-gdb/copy: | $(BUILD)/binutils-gdb/source/ $(BUILD)/done/binutils-gdb/
	$(CP) -a toolchain/binutils-gdb/binutils-gdb/* $(BUILD)/binutils-gdb/source/
	@touch $@
