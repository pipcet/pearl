$(BUILD)/memtool/done/install: $(BUILD)/memtool/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/memtool/build install
	@touch $@

$(BUILD)/memtool/done/build: $(BUILD)/memtool/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/memtool/build
	@touch $@

$(BUILD)/memtool/done/configure: $(BUILD)/memtool/done/copy
	(cd $(BUILD)/memtool/build; $(WITH_CROSS_PATH) autoreconf -ivf)
	(cd $(BUILD)/memtool/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/memtool/done/copy: $(BUILD)/memtool/done/checkout | $(BUILD)/memtool/done/ $(BUILD)/memtool/build/
	$(CP) -aus $(PWD)/userspace/memtool/memtool/* $(BUILD)/memtool/build/
	@touch $@

$(BUILD)/memtool/done/checkout: | $(BUILD)/memtool/done/
	$(MAKE) userspace/memtool/memtool{checkout}
	@touch $@

userspace-modules += memtool
