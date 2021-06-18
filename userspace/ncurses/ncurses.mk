$(BUILD)/done/ncurses/install: $(BUILD)/done/ncurses/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/ncurses/build install
	@touch $@

$(BUILD)/done/ncurses/build: $(BUILD)/done/ncurses/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/ncurses/build
	@touch $@

$(BUILD)/done/ncurses/configure: $(BUILD)/done/ncurses/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/ncurses/build; PATH="$(CROSS_PATH):$$PATH" ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	@touch $@

$(BUILD)/done/ncurses/copy: | $(BUILD)/done/ncurses/ $(BUILD)/ncurses/build/
	$(CP) -a userspace/ncurses/ncurses/* $(BUILD)/ncurses/build/
	@touch $@
