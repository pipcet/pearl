$(BUILD)/gcc/done/gcc/install: $(BUILD)/gcc/done/gcc/build
	$(MAKE) -C $(BUILD)/gcc/gcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	@touch $@

$(BUILD)/gcc/done/gcc/build: $(BUILD)/gcc/done/gcc/configure
	$(MAKE) -C $(BUILD)/gcc/gcc/build
	@touch $@

$(BUILD)/gcc/done/gcc/configure: $(BUILD)/gcc/done/gcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/glibc/done/headers/install | $(BUILD)/gcc/gcc/build/
	(cd $(BUILD)/gcc/gcc/build; ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --disable-shared --with-static-standard-libraries --with-build-sysroot="$(BUILD)/install" --disable-c++tools)
	@touch $@

$(BUILD)/gcc/done/gcc/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/gcc/ $(BUILD)/gcc/gcc/source/
	$(CP) -a toolchain/gcc/gcc/* $(BUILD)/gcc/gcc/source/
	@touch $@

$(BUILD)/gcc/done/checkout: toolchain/gcc/gcc{checkout} | $(BUILD)/gcc/done/gcc/
	@touch $@
