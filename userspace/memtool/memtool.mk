$(BUILD)/done/memtool/install: $(BUILD)/done/memtool/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/memtool/build install
	@touch $@

$(BUILD)/done/memtool/build: $(BUILD)/done/memtool/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/memtool/build
	@touch $@

$(BUILD)/done/memtool/configure: $(BUILD)/done/memtool/copy
	(cd $(BUILD)/memtool/build; PATH="$(CROSS_PATH):$$PATH" autoreconf -ivf)
	(cd $(BUILD)/memtool/build; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix="$(BUILD)/install" CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/memtool/copy: | $(BUILD)/done/memtool/ $(BUILD)/memtool/build/
	$(CP) -a userspace/memtool/memtool/* $(BUILD)/memtool/build/
	@touch $@
