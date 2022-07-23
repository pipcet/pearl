$(call done,userspace/memtool,install): $(call done,userspace/memtool,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build install
	@touch $@

$(call done,userspace/memtool,build): $(call done,userspace/memtool,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build
	@touch $@

$(call done,userspace/memtool,configure): $(call done,userspace/memtool,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) autoreconf -ivf)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(call done,userspace/memtool,copy): $(call done,userspace/memtool,checkout) | $(call done,userspace/memtool,) $(BUILD)/userspace/memtool/build/
	$(CP) -aus $(PWD)/userspace/memtool/memtool/* $(BUILD)/userspace/memtool/build/
	@touch $@

$(call done,userspace/memtool,checkout): | $(call done,userspace/memtool,)
	$(MAKE) userspace/memtool/memtool{checkout}
	@touch $@

userspace-modules += memtool
