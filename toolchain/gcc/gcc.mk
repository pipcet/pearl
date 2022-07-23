DEP_gcc += $(BUILD)/toolchain/gcc/done/gcc/install
$(BUILD)/toolchain/gcc/done/gcc/install: $(BUILD)/toolchain/gcc/done/gcc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/gcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	@touch $@

$(BUILD)/toolchain/gcc.tar: $(BUILD)/toolchain/gcc/done/gcc/build
	tar -C $(BUILD) -cf $@ gcc/gcc/build

$(BUILD)/toolchain/gcc/done/gcc/build: $(BUILD)/toolchain/gcc/done/gcc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/gcc/build
	@touch $@

$(BUILD)/toolchain/gcc/done/gcc/configure: $(BUILD)/toolchain/gcc/done/gcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/userspace/glibc/done/headers/install $(BUILD)/binutils-gdb/done/install | $(BUILD)/toolchain/gcc/gcc/build/
	(cd $(BUILD)/toolchain/gcc/gcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --disable-shared --with-static-standard-libraries --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	@touch $@

$(BUILD)/toolchain/gcc/done/gcc/copy: $(BUILD)/toolchain/gcc/done/checkout | $(BUILD)/toolchain/gcc/done/gcc/ $(BUILD)/toolchain/gcc/gcc/source/
	$(CP) -aus $(PWD)/toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/gcc/source/
	@touch $@

$(BUILD)/toolchain/gcc/done/g++/install: $(BUILD)/toolchain/gcc/done/libgcc/install | $(BUILD)/toolchain/gcc/done/g++/
	@touch $@

$(BUILD)/toolchain/gcc/done/libgcc/install: $(BUILD)/toolchain/gcc/done/libgcc/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/libgcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so $(BUILD)/pearl/install/lib
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so.1 $(BUILD)/pearl/install/lib
	@touch $@

$(BUILD)/toolchain/gcc/done/libgcc/build: $(BUILD)/toolchain/gcc/done/libgcc/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/libgcc/build
	@touch $@

$(BUILD)/toolchain/gcc/done/libgcc/configure: $(BUILD)/toolchain/gcc/done/libgcc/copy $(BUILD)/linux/done/headers/install $(BUILD)/userspace/glibc/done/headers/install $(BUILD)/binutils-gdb/done/install $(BUILD)/userspace/glibc/done/glibc/install | $(BUILD)/toolchain/gcc/libgcc/build/
	(cd $(BUILD)/toolchain/gcc/libgcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,c++,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	@touch $@

$(BUILD)/toolchain/gcc/done/libgcc/copy: $(BUILD)/toolchain/gcc/done/checkout | $(BUILD)/toolchain/gcc/done/libgcc/ $(BUILD)/toolchain/gcc/libgcc/source/
	$(CP) -aus $(PWD)/toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/libgcc/source/
	@touch $@

$(BUILD)/toolchain/gcc/done/checkout: | $(BUILD)/toolchain/gcc/done/gcc/
	$(MAKE) toolchain/gcc/gcc{checkout}
	@touch $@
