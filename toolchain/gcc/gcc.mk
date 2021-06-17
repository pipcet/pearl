$(BUILD)/done/toolchain/gcc/stage1/install: $(BUILD)/done/toolchain/gcc/stage1/build
	$(MAKE) -C $(BUILD)/toolchain/gcc/stage1/build install
	touch $@

$(BUILD)/done/toolchain/gcc/stage1/build: $(BUILD)/done/toolchain/gcc/stage1/configure
	$(MAKE) -C $(BUILD)/toolchain/gcc/stage1/build
	touch $@

$(BUILD)/done/toolchain/gcc/stage1/configure: $(BUILD)/done/toolchain/gcc/stage1/copy | $(BUILD)/toolchain/gcc/stage1/build/
	(cd $(BUILD)/toolchain/gcc/stage1/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --disable-shared --disable-nls --disable-threads --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/busybocs/install" --disable-libgcc --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp)
	touch $@

$(BUILD)/done/toolchain/gcc/stage1/copy: | $(BUILD)/done/toolchain/gcc/stage1/ $(BUILD)/toolchain/gcc/stage1/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/stage1/source/
	touch $@
