DEP_ncurses += $(call done,userspace/ncurses,install)
$(call done,userspace/ncurses,install): $(call done,userspace/ncurses,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build install
	$(MKDIR) $(BUILD)/pearl/install/lib/pkgconfig/
	$(CP) $(BUILD)/pearl/install/lib/aarch64-linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || $(CP) $(BUILD)/pearl/install/lib/x86_64-*linux-gnu/pkgconfig/ncurses.pc $(BUILD)/pearl/install/lib/pkgconfig/ || true
	@touch $@

$(call done,userspace/ncurses,build): $(call done,userspace/ncurses,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build
	@touch $@

$(call done,userspace/ncurses,configure): $(call done,userspace/ncurses,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/ncurses/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(BUILD)/pearl/install --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding --enable-pc-files=yes)
	@touch $@

$(call done,userspace/ncurses,copy): $(call done,userspace/ncurses,checkout) | $(call done,userspace/ncurses,) $(BUILD)/userspace/ncurses/build/
	$(COPY_SAUNA) $(PWD)/userspace/ncurses/ncurses/* $(BUILD)/userspace/ncurses/build/
	@touch $@

$(call done,userspace/ncurses,checkout): | $(call done,userspace/ncurses,)
	$(MAKE) userspace/ncurses/ncurses{checkout}
	@touch $@

userspace-modules += ncurses
