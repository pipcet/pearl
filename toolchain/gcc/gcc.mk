$(BUILD)/done/toolchain/gcc/gcc/configure: $(BUILD)/done/toolchain/gcc/gcc/copy $(BUILD)/done/linux/headers/install $(BUILD)/done/glibc/install | $(BUILD)/toolchain/gcc/gcc/build/
	(cd $(BUILD)/toolchain/gcc/gcc/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)")
	@touch $@

$(BUILD)/done/toolchain/gcc/gcc/copy: | $(BUILD)/done/toolchain/gcc/gcc/ $(BUILD)/toolchain/gcc/gcc/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/gcc/source/
	@touch $@

$(BUILD)/done/toolchain/gcc/stage1/install: $(BUILD)/done/toolchain/gcc/stage1/build
	$(MAKE) -C $(BUILD)/toolchain/gcc/stage1/build install
	@touch $@

$(BUILD)/done/toolchain/gcc/stage1/build: $(BUILD)/done/toolchain/gcc/stage1/configure
	$(MAKE) -C $(BUILD)/toolchain/gcc/stage1/build all-gcc
	@touch $@

$(BUILD)/done/toolchain/gcc/stage1/configure: $(BUILD)/done/toolchain/gcc/stage1/copy $(BUILD)/done/install/mkdir | $(BUILD)/toolchain/gcc/stage1/build/
	(cd $(BUILD)/toolchain/gcc/stage1/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --disable-libcc1 --disable-shared --disable-nls --disable-threads --disable-bootstrap --prefix="$(BUILD)/install" --with-sysroot="$(BUILD)/install" --disable-libgcc --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/install" --disable-c++tools)
	@touch $@

$(BUILD)/done/toolchain/gcc/stage1/copy: | $(BUILD)/done/toolchain/gcc/stage1/ $(BUILD)/toolchain/gcc/stage1/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/stage1/source/
	@touch $@
