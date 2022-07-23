DEP_ncurses += $(BUILD)/userspace/ncurses/done/install
$(BUILD)/userspace/ncurses/done/install: $(BUILD)/userspace/ncurses/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build install
	$(MKDIR) $(BUILD)/pearl/install/lib/pkgconfig/
	$(CP) $(BUILD)/pearl/install/lib/aarch64-linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || $(CP) $(BUILD)/pearl/install/lib/x86_64-*linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || true
	@touch $@

$(BUILD)/userspace/ncurses/done/build: $(BUILD)/userspace/ncurses/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build
	@touch $@

$(BUILD)/userspace/ncurses/done/configure: $(BUILD)/userspace/ncurses/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/ncurses/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding --enable-pc-files=yes)
	@touch $@

$(BUILD)/userspace/ncurses/done/copy: $(BUILD)/userspace/ncurses/done/checkout | $(BUILD)/userspace/ncurses/done/ $(BUILD)/userspace/ncurses/build/
	$(CP) -aus $(PWD)/userspace/ncurses/ncurses/* $(BUILD)/userspace/ncurses/build/
	@touch $@

$(BUILD)/userspace/ncurses/done/checkout: | $(BUILD)/userspace/ncurses/done/
	$(MAKE) userspace/ncurses/ncurses{checkout}
	@touch $@

userspace-modules += ncurses
