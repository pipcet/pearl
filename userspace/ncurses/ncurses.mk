$(BUILD)/ncurses/done/install: $(BUILD)/ncurses/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/ncurses/build install
	@touch $@

$(BUILD)/ncurses/done/build: $(BUILD)/ncurses/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/ncurses/build
	@touch $@

$(BUILD)/ncurses/done/configure: $(BUILD)/ncurses/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/ncurses/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding)
	@touch $@

$(BUILD)/ncurses/done/copy: $(BUILD)/ncurses/done/checkout | $(BUILD)/ncurses/done/ $(BUILD)/ncurses/build/
	$(CP) -a userspace/ncurses/ncurses/* $(BUILD)/ncurses/build/
	@touch $@

$(BUILD)/ncurses/done/checkout: userspace/ncurses/ncurses{checkout} | $(BUILD)/ncurses/done/
	@touch $@

userspace-modules += ncurses
