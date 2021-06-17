$(BUILD)/done/ncurses/install: $(BUILD)/done/ncurses/build
	$(MAKE) -C $(BUILD)/ncurses/build install
	@touch $@

$(BUILD)/done/ncurses/build: $(BUILD)/done/ncurses/configure
	$(MAKE) -C $(BUILD)/ncurses/build
	@touch $@

$(BUILD)/done/ncurses/configure: $(BUILD)/done/ncurses/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/ncurses/build; ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/done/ncurses/copy: | $(BUILD)/done/ncurses/ $(BUILD)/ncurses/build/
	$(CP) -a userspace/ncurses/ncurses/* $(BUILD)/ncurses/build/
	@touch $@
