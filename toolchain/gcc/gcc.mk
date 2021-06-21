$(BUILD)/gcc/done/gcc/install: $(BUILD)/gcc/done/gcc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/gcc/gcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	@touch $@

$(BUILD)/gcc.tar: $(BUILD)/gcc/done/gcc/build
	tar -C $(BUILD) -cf $@ gcc/gcc/build

$(BUILD)/gcc/done/gcc/build: $(BUILD)/gcc/done/gcc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/gcc/gcc/build
	@touch $@

$(BUILD)/gcc/done/gcc/configure: $(BUILD)/gcc/done/gcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/glibc/done/headers/install $(BUILD)/binutils-gdb/done/install | $(BUILD)/gcc/gcc/build/
	(cd $(BUILD)/gcc/gcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --disable-shared --with-static-standard-libraries --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	@touch $@

$(BUILD)/gcc/done/gcc/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/gcc/ $(BUILD)/gcc/gcc/source/
	$(CP) -aus $(PWD)/toolchain/gcc/gcc/* $(BUILD)/gcc/gcc/source/
	@touch $@

$(BUILD)/gcc/done/g++/install: $(BUILD)/gcc/done/libgcc/install | $(BUILD)/gcc/done/g++/
	@touch $@

$(BUILD)/gcc/done/libgcc/install: $(BUILD)/gcc/done/libgcc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/gcc/libgcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so $(BUILD)/pearl/install/lib
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so.1 $(BUILD)/pearl/install/lib
	@touch $@

$(BUILD)/gcc/done/libgcc/build: $(BUILD)/gcc/done/libgcc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/gcc/libgcc/build
	@touch $@

$(BUILD)/gcc/done/libgcc/configure: $(BUILD)/gcc/done/libgcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/glibc/done/headers/install | $(BUILD)/gcc/libgcc/build/
	(cd $(BUILD)/gcc/libgcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,c++,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	@touch $@

$(BUILD)/gcc/done/libgcc/copy: $(BUILD)/gcc/done/checkout | $(BUILD)/gcc/done/libgcc/ $(BUILD)/gcc/libgcc/source/
	$(CP) -aus $(PWD)/toolchain/gcc/gcc/* $(BUILD)/gcc/libgcc/source/
	@touch $@

$(BUILD)/gcc/done/checkout: toolchain/gcc/gcc{checkout} | $(BUILD)/gcc/done/gcc/
	@touch $@
