DEP_glibc += $(call done,userspace/glibc,glibc/install)
$(call done,userspace/glibc,glibc/install): $(call done,userspace/glibc,glibc/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build DESTDIR=$(BUILD)/pearl/install CXX="" install
	@touch $@

$(call done,userspace/glibc,glibc/build): $(call done,userspace/glibc,glibc/configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/glibc/build CXX=""
	@touch $@

$(call done,userspace/glibc,glibc/configure): $(call done,userspace/glibc,glibc/copy) $(call done,linux,headers/install) $(call done,toolchain/gcc,gcc/install) | $(BUILD)/userspace/glibc/glibc/build/
	(cd $(BUILD)/userspace/glibc/glibc/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS) -Wno-error=array-bounds" CXX="")
	@touch $@

$(call done,userspace/glibc,glibc/copy): $(call done,userspace/glibc,checkout) | $(BUILD)/userspace/glibc/glibc/source/ $(call done,userspace/glibc,glibc/)
	$(CP) -naus $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/glibc/source/
	@touch $@


$(call done,userspace/glibc,stage1/install): $(call done,userspace/glibc,stage1/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/stage1/build DESTDIR=$(BUILD)/pearl/install install-headers install
	@touch $@

$(call done,userspace/glibc,stage1/build): $(call done,userspace/glibc,stage1/configure)
	@touch $@

$(call done,userspace/glibc,stage1/configure): $(call done,userspace/glibc,stage1/copy) | $(BUILD)/userspace/glibc/stage1/build/
	(cd $(BUILD)/userspace/glibc/stage1/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(call done,userspace/glibc,stage1/copy): $(call done,userspace/glibc,checkout) | $(BUILD)/userspace/glibc/stage1/source/ $(call done,userspace/glibc,stage1/)
	$(COPY_SAUNA) $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/stage1/source/
	@touch $@

$(call done,userspace/glibc,headers/install): $(call done,userspace/glibc,headers/build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/glibc/headers/build DESTDIR=$(BUILD)/pearl/install install-headers
	$(MKDIR) $(BUILD)/pearl/install/include/gnu/
	touch $(BUILD)/pearl/install/include/gnu/stubs.h
	@touch $@

$(call done,userspace/glibc,headers/build): $(call done,userspace/glibc,headers/configure)
	@touch $@

$(call done,userspace/glibc,headers/configure): $(call done,userspace/glibc,headers/copy) | $(BUILD)/userspace/glibc/headers/build/
	(cd $(BUILD)/userspace/glibc/headers/build; $(WITH_CROSS_PATH) ../source/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --disable-werror --prefix=/ CFLAGS="$(CROSS_CFLAGS)" CXX="")
	@touch $@

$(call done,userspace/glibc,headers/copy): $(call done,userspace/glibc,checkout) | $(BUILD)/userspace/glibc/headers/source/ $(call done,userspace/glibc,headers/)
	$(COPY_SAUNA) $(PWD)/userspace/glibc/glibc/* $(BUILD)/userspace/glibc/headers/source/
	@touch $@

$(call done,userspace/glibc,checkout): | $(call done,userspace/glibc,)
	$(MAKE) userspace/glibc/glibc{checkout}
	@touch $@

$(call done,userspace/glibc,install): $(call done,userspace/glibc,glibc/install)
	@touch $@

userspace-modules += glibc
