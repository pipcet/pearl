$(BUILD)/done/gcc/gcc/install: $(BUILD)/done/gcc/gcc/build
	$(MAKE) -C $(BUILD)/gcc/gcc/build DESTDIR="$(BUILD)/toolchain" install
	@touch $@

$(BUILD)/done/gcc/gcc/build: $(BUILD)/done/gcc/gcc/configure
	$(MAKE) -C $(BUILD)/gcc/gcc/build
	@touch $@

$(BUILD)/done/gcc/gcc/configure: $(BUILD)/done/gcc/gcc/copy $(BUILD)/done/linux/headers/install $(BUILD)/done/glibc/stage1/install | $(BUILD)/gcc/gcc/build/
	(cd $(BUILD)/gcc/gcc/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/install")
	@touch $@

$(BUILD)/done/gcc/gcc/copy: $(BUILD)/done/gcc/checkout | $(BUILD)/done/gcc/gcc/ $(BUILD)/gcc/gcc/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/gcc/gcc/source/
	@touch $@

$(BUILD)/done/gcc/stage1/install: $(BUILD)/done/gcc/stage1/build
	$(MAKE) -C $(BUILD)/gcc/stage1/build install
	@touch $@

$(BUILD)/done/gcc/stage1/build: $(BUILD)/done/gcc/stage1/configure
	$(MAKE) -C $(BUILD)/gcc/stage1/build all-gcc
	@touch $@

$(BUILD)/done/gcc/stage1/configure: $(BUILD)/done/gcc/stage1/copy $(BUILD)/done/install/mkdir $(BUILD)/done/binutils-gdb/install | $(BUILD)/gcc/stage1/build/
	(cd $(BUILD)/gcc/stage1/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --disable-libcc1 --disable-shared --disable-nls --disable-threads --disable-bootstrap --prefix="$(BUILD)/toolchain" --with-sysroot="$(BUILD)/install" --disable-libgcc --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/install" --disable-c++tools)
	@touch $@

$(BUILD)/done/gcc/stage1/copy: $(BUILD)/done/gcc/checkout | $(BUILD)/done/gcc/stage1/ $(BUILD)/gcc/stage1/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD:$(PWD)/%=%)/gcc/stage1/source/
	@touch $@

$(BUILD)/done/gcc/checkout: toolchain/gcc/gcc{checkout} | $(BUILD)/done/gcc/gcc/
	@touch $@
