DEP_ncurses += $(call done,userspace/ncurses,install)
ifeq ($(filter rest.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/ncurses,install): $(call done,userspace/ncurses,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build install
	$(MKDIR) $(call install,userspace/ncurses)/lib/pkgconfig/
	$(CP) $(call install,userspace/ncurses)/lib/aarch64-linux-gnu/pkgconfig/ncurses.pc $(call install,userspace/ncurses)/lib/pkgconfig/ || $(CP) $(call install,userspace/ncurses)/lib/x86_64-*linux-gnu/pkgconfig/ncurses.pc  $(call install,userspace/ncurses)/lib/pkgconfig/ || true
	$(INSTALL_LIBS) userspace/ncurses
	$(TIMESTAMP)
else
$(call done,userspace/ncurses,install): $(BUILD)/artifacts/rest.tar.zstd/extract | $(call done,userspace/ncurses,)/
	$(TIMESTAMP)
endif

$(call done,userspace/ncurses,build): $(call done,userspace/ncurses,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/ncurses/build
	$(TIMESTAMP)

$(call done,userspace/ncurses,configure): $(call done,userspace/ncurses,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/ncurses/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ --with-install-prefix=$(call install,userspace/ncurses) --disable-stripping CFLAGS="$(CROSS_CFLAGS)" CXXFLAGS="$(CROSS_CFLAGS)" --without-cxx-binding --enable-pc-files=yes)
	$(TIMESTAMP)

$(call done,userspace/ncurses,copy): | $(call done,userspace/ncurses,checkout) $(call done,userspace/ncurses,) $(BUILD)/userspace/ncurses/build/
	$(COPY_SAUNA) $(PWD)/userspace/ncurses/ncurses/* $(BUILD)/userspace/ncurses/build/
	$(TIMESTAMP)

$(call done,userspace/ncurses,checkout): | $(call done,userspace/ncurses,)
	$(MAKE) userspace/ncurses/ncurses{checkout}
	$(TIMESTAMP)

userspace-modules += ncurses
