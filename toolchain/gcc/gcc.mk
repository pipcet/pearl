DEP_gcc += $(call done,toolchain/gcc,gcc/install)
$(call done,toolchain/gcc,gcc/install): $(call done,toolchain/gcc,gcc/build) $(call done,pearl,install/mkdir)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/gcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	$(TIMESTAMP)

$(BUILD)/toolchain/gcc.tar: $(call done,toolchain/gcc,gcc/build)
	tar -C $(BUILD) -cf $@ gcc/gcc/build

$(call done,toolchain/gcc,gcc/build): $(call done,toolchain/gcc,gcc/configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/gcc/build
	$(TIMESTAMP)

$(call done,toolchain/gcc,gcc/configure): $(call done,toolchain/gcc,gcc/copy) | $(call done,linux,headers/install) $(call done,userspace/glibc,headers/install) $(call done,toolchain/binutils-gdb,install) $(BUILD)/toolchain/gcc/gcc/build/
	(cd $(BUILD)/toolchain/gcc/gcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,lto --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --disable-shared --with-static-standard-libraries --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	$(TIMESTAMP)

$(call done,toolchain/gcc,gcc/copy): $(call done,toolchain/gcc,checkout) | $(call done,toolchain/gcc,gcc/) $(BUILD)/toolchain/gcc/gcc/source/
	$(COPY_SAUNA) $(PWD)/toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/gcc/source/
	$(TIMESTAMP)

$(call done,toolchain/gcc,g++/install): $(call done,toolchain/gcc,libgcc/install) | $(call done,toolchain/gcc,g++/)
	$(TIMESTAMP)

$(call done,toolchain/gcc,libgcc/install): $(call done,toolchain/gcc,libgcc/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/libgcc/build DESTDIR="$(BUILD)/pearl/toolchain" install
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so $(BUILD)/pearl/install/lib
	$(CP) -a $(BUILD)/pearl/toolchain/aarch64-linux-gnu/lib64/libgcc_s.so.1 $(BUILD)/pearl/install/lib
	$(TIMESTAMP)

$(call done,toolchain/gcc,libgcc/build): $(call done,toolchain/gcc,libgcc/configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/toolchain/gcc/libgcc/build
	$(TIMESTAMP)

$(call done,toolchain/gcc,libgcc/configure): $(call done,toolchain/gcc,libgcc/copy) | $(call done,linux,headers/install) $(call done,userspace/glibc,headers/install) $(call done,toolchain/binutils-gdb,install) $(call done,userspace/glibc,glibc/install) $(BUILD)/toolchain/gcc/libgcc/build/
	(cd $(BUILD)/toolchain/gcc/libgcc/build; $(WITH_CROSS_PATH) ../source/configure --target=aarch64-linux-gnu --enable-languages=c,c++,lto --enable-shared --disable-bootstrap --prefix=/ --with-sysroot="$(BUILD)/pearl/install" --disable-libssp --disable-libquadmath --disable-libatomic --disable-libgomp --without-headers --with-build-sysroot="$(BUILD)/pearl/install" --disable-c++tools)
	$(TIMESTAMP)

$(call done,toolchain/gcc,libgcc/copy): $(call done,toolchain/gcc,checkout) | $(call done,toolchain/gcc,libgcc/) $(BUILD)/toolchain/gcc/libgcc/source/
	$(COPY_SAUNA) $(PWD)/toolchain/gcc/gcc/* $(BUILD)/toolchain/gcc/libgcc/source/
	$(TIMESTAMP)

$(call done,toolchain/gcc,checkout): | $(call done,toolchain/gcc,)
	$(MAKE) toolchain/gcc/gcc{checkout}
	$(TIMESTAMP)
