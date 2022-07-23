$(call done,toolchain/binutils-gdb,install): $(call done,toolchain/binutils-gdb,build)
	$(MAKE) -C $(BUILD)/toolchain/binutils-gdb/source install
	$(TIMESTAMP)

$(BUILD)/toolchain/binutils-gdb.tar: $(call done,toolchain/binutils-gdb,build)
	tar -C $(BUILD)/toolchain/binutils-gdb -cf $@ done source

$(call done,toolchain/binutils-gdb,build): $(call done,toolchain/binutils-gdb,configure)
	$(MAKE) -C $(BUILD)/toolchain/binutils-gdb/source
	$(TIMESTAMP)

$(call done,toolchain/binutils-gdb,configure): $(call done,toolchain/binutils-gdb,copy)
	(cd $(BUILD)/toolchain/binutils-gdb/source/; ../source/configure --target=aarch64-linux-gnu --prefix=$(BUILD)/pearl/toolchain)
	$(TIMESTAMP)

$(call done,toolchain/binutils-gdb,copy): $(call done,toolchain/binutils-gdb,checkout) | $(BUILD)/toolchain/binutils-gdb/source/ $(call done,toolchain/binutils-gdb,)
	$(COPY_SAUNA) $(PWD)/toolchain/binutils-gdb/binutils-gdb/* $(BUILD)/toolchain/binutils-gdb/source/
	$(TIMESTAMP)

$(call done,toolchain/binutils-gdb,checkout): | $(call done,toolchain/binutils-gdb,)
	$(MAKE) toolchain/binutils-gdb/binutils-gdb{checkout}
	$(TIMESTAMP)
