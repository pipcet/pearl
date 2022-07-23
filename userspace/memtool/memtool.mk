$(BUILD)/userspace/memtool/done/install: $(BUILD)/userspace/memtool/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build install
	@touch $@

$(BUILD)/userspace/memtool/done/build: $(BUILD)/userspace/memtool/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build
	@touch $@

$(BUILD)/userspace/memtool/done/configure: $(BUILD)/userspace/memtool/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) autoreconf -ivf)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/userspace/memtool/done/copy: $(BUILD)/userspace/memtool/done/checkout | $(BUILD)/userspace/memtool/done/ $(BUILD)/userspace/memtool/build/
	$(CP) -aus $(PWD)/userspace/memtool/memtool/* $(BUILD)/userspace/memtool/build/
	@touch $@

$(BUILD)/userspace/memtool/done/checkout: | $(BUILD)/userspace/memtool/done/
	$(MAKE) userspace/memtool/memtool{checkout}
	@touch $@

userspace-modules += memtool
