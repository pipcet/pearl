DEP_glibc += $(call done,userspace/glibc,glibc/install)
ifeq ($(filter toolchain.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/glibc,glibc/install): $(call done,userspace/glibc,glibc/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build DESTDIR=$(call install,userspace/glibc/glibc) CXX="" install
	$(INSTALL_LIBS) userspace/glibc
	$(TIMESTAMP)

else
$(call done,userspace/glibc,glibc/install): $(BUILD)/artifacts/toolchain.tar.zstd/extract
	$(TIMESTAMP)
endif

$(call done,userspace/glibc,glibc/build): $(call done,userspace/glibc,glibc/configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build CXX=""
	$(TIMESTAMP)

$(call done,userspace/glibc,glibc/configure): $(call done,userspace/glibc,glibc/copy) | $(call done,linux,headers/install) $(call done,toolchain/gcc,gcc/install) $(BUILD)/userspace/glibc/glibc/build/ builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/glibc/glibc/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS) -Wno-error=array-bounds" CXX="" --with-headers=$(BUILD)/pearl/install/usr/include/)
	$(TIMESTAMP)

$(call done,userspace/glibc,glibc/copy): | $(call done,userspace/glibc,checkout) $(BUILD)/userspace/glibc/glibc/source/ $(call done,userspace/glibc,glibc/)
	$(CP) -naus $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/glibc/source/
	$(TIMESTAMP)

$(call done,userspace/glibc,stage1/install): $(call done,userspace/glibc,stage1/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/stage1/build DESTDIR=$(call install,userspace/glibc/stage1) install
	$(INSTALL_LIBS) userspace/glibc stage1
	$(TIMESTAMP)

$(call done,userspace/glibc,stage1/build): $(call done,userspace/glibc,stage1/configure)
	$(TIMESTAMP)

$(call done,userspace/glibc,stage1/configure): $(call done,userspace/glibc,stage1/copy) | $(BUILD)/userspace/glibc/stage1/build/
	(cd $(BUILD)/userspace/glibc/stage1/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	$(TIMESTAMP)

$(call done,userspace/glibc,stage1/copy): | $(call done,userspace/glibc,checkout) $(BUILD)/userspace/glibc/stage1/source/ $(call done,userspace/glibc,stage1/)
	$(COPY_SAUNA) $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/stage1/source/
	$(TIMESTAMP)

ifeq ($(filter toolchain.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/glibc,headers/install): $(call done,userspace/glibc,headers/build) $(call done,pearl,install/mkdir)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/headers/build DESTDIR=$(call install,userspace/glibc/headers) install-headers
	$(MKDIR) $(call install,userspace/glibc/headers)/include/gnu/
	touch $(call install,userspace/glibc/headers)/include/gnu/stubs.h
	$(INSTALL_LIBS) userspace/glibc headers
	$(TIMESTAMP)

else
$(call done,userspace/glibc,headers/install): $(BUILD)/artifacts/toolchain.tar.zstd/extract
	$(TIMESTAMP)
endif
$(call done,userspace/glibc,headers/build): $(call done,userspace/glibc,headers/configure)
	$(TIMESTAMP)

$(call done,userspace/glibc,headers/configure): $(call done,userspace/glibc,headers/copy) | $(call done,linux,headers/install) $(BUILD)/userspace/glibc/headers/build/
	(cd $(BUILD)/userspace/glibc/headers/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="" --with-headers=$(BUILD)/pearl/install/usr/include/)
	$(TIMESTAMP)

$(call done,userspace/glibc,headers/copy): | $(call done,userspace/glibc,checkout) $(BUILD)/userspace/glibc/headers/source/ $(call done,userspace/glibc,headers/)
	$(COPY_SAUNA) $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/headers/source/
	$(TIMESTAMP)

$(call done,userspace/glibc,checkout): | $(call done,userspace/glibc,)
	$(MAKE) userspace/glibc/glibc{checkout}
	$(TIMESTAMP)

$(call done,userspace/glibc,install): $(call done,userspace/glibc,glibc/install)
	$(TIMESTAMP)

userspace-modules += glibc
