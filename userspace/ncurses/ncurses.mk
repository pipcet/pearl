DEP_ncurses += $(BUILD)/ncurses/done/install
$(BUILD)/ncurses/done/install: $(BUILD)/ncurses/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/ncurses/build install
	$(MKDIR) $(BUILD)/pearl/install/lib/pkgconfig/
	$(CP) $(BUILD)/pearl/install/lib/aarch64-linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || $(CP) $(BUILD)/pearl/install/lib/x86_64-*-linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || true
	@touch $@

$(BUILD)/ncurses/done/build: $(BUILD)/ncurses/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/ncurses/build
	@touch $@

$(BUILD)/ncurses/done/configure: $(BUILD)/ncurses/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/ncurses/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding --enable-pc-files=yes)
	@touch $@

$(BUILD)/ncurses/done/copy: $(BUILD)/ncurses/done/checkout | $(BUILD)/ncurses/done/ $(BUILD)/ncurses/build/
	$(CP) -aus $(PWD)/userspace/ncurses/ncurses/* $(BUILD)/ncurses/build/
	@touch $@

$(BUILD)/ncurses/done/checkout: | $(BUILD)/ncurses/done/
	$(MAKE) userspace/ncurses/ncurses{checkout}
	@touch $@

userspace-modules += ncurses
