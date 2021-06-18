$(BUILD)/gcc/done/gcc/install: $(BUILD)/gcc/done/gcc/build
	$(MAKE) -C $(BUILD)/gcc/gcc/build DESTDIR="$(BUILD)/toolchain" install
	@touch $@

$(BUILD)/gcc/done/gcc/build: $(BUILD)/gcc/done/gcc/configure
	$(MAKE) -C $(BUILD)/gcc/gcc/build
	@touch $@

$(BUILD)/gcc/done/gcc/configure: $(BUILD)/gcc/done/gcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/glibc/done/stage1/install | $(BUILD)/gcc/gcc/build/
	(cd $(BUILD)/gcc/gcc/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/install")
	@touch $@

$(BUILD)/gcc/done/gcc/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/gcc/ $(BUILD)/gcc/gcc/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/gcc/gcc/source/
	@touch $@

# $(BUILD)/gcc/done/stage2/install: $(BUILD)/gcc/done/stage2/build
# 	$(MAKE) -C $(BUILD)/gcc/stage2/build install
# 	@touch $@

# $(BUILD)/gcc/done/stage2/build: $(BUILD)/gcc/done/stage2/configure
# 	$(MAKE) -C $(BUILD)/gcc/stage2/build
# 	@touch $@

# $(BUILD)/gcc/done/stage2/configure: $(BUILD)/gcc/done/stage2/copy $(BUILD)/install/done/mkdir $(BUILD)/binutils-gdb/done/install $(BUILD)/glibc/done/headers/install | $(BUILD)/gcc/stage2/build/
# 	(cd $(BUILD)/gcc/stage2/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --disable-libcc1 --disable-shared --disable-nls --disable-threads --disable-bootstrap --prefix="$(BUILD)/toolchain" --with-sysroot="$(BUILD)/install" --with-static-standard-libraries --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/install" --disable-c++tools)
# 	@touch $@

# $(BUILD)/gcc/done/stage2/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/stage2/ $(BUILD)/gcc/stage2/source/
# 	$(CP) -a toolchain/gcc/gcc/* $(BUILD:$(PWD)/%=%)/gcc/stage2/source/
# 	@touch $@

# $(BUILD)/gcc/done/stage1/install: $(BUILD)/gcc/done/stage1/build
# 	$(MAKE) -C $(BUILD)/gcc/stage1/build install
# 	@touch $@

# $(BUILD)/gcc/done/stage1/build: $(BUILD)/gcc/done/stage1/configure
# 	$(MAKE) -C $(BUILD)/gcc/stage1/build
# 	@touch $@

# $(BUILD)/gcc/done/stage1/configure: $(BUILD)/gcc/done/stage1/copy $(BUILD)/install/done/mkdir $(BUILD)/binutils-gdb/done/install | $(BUILD)/gcc/stage1/build/
# 	(cd $(BUILD)/gcc/stage1/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c --disable-libcc1 --disable-shared --disable-nls --disable-threads --disable-bootstrap --prefix="$(BUILD)/toolchain" --with-sysroot="$(BUILD)/install" --with-static-standard-libraries --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/install" --disable-c++tools --disable-libgcc)
# 	@touch $@

# $(BUILD)/gcc/done/stage1/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/stage1/ $(BUILD)/gcc/stage1/source/
# 	$(CP) -a toolchain/gcc/gcc/* $(BUILD:$(PWD)/%=%)/gcc/stage1/source/
# 	@touch $@

$(BUILD)/gcc/done/checkout: toolchain/gcc/gcc{checkout} | $(BUILD)/gcc/done/gcc/
	@touch $@
