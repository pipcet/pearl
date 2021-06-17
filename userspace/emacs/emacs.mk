$(BUILD)/done/emacs/cross/install: $(BUILD)/done/emacs/cross/build
	$(NATIVE_CODE_ENV) $(MAKE) -C $(BUILD)/emacs/cross DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/emacs/cross/build: $(BUILD)/done/emacs/cross/configure
	$(NATIVE_CODE_ENV) $(MAKE) -C $(BUILD)/emacs/cross/
	@touch $@

$(BUILD)/done/emacs/cross/configure: $(BUILD)/done/emacs/cross/copy $(BUILD)/done/gcc/gcc/install $(BUILD)/done/glibc/glibc/install $(BUILD)/done/ncurses/install
	(cd $(BUILD)/emacs/cross; ./configure --target=aarch64-linux-gnu --without-all --without-json --without-x --host=aarch64-linux-gnu CFLAGS="$(CROSS_CFLAGS)" --prefix=/)
	@touch $@

$(BUILD)/done/emacs/cross/copy: $(BUILD)/done/emacs/native/build | $(BUILD)/done/emacs/cross/ $(BUILD)/emacs/cross/
	$(CP) -a $(BUILD)/emacs/native/* $(BUILD)/emacs/cross/
	@touch $@

$(BUILD)/done/emacs/native/build: $(BUILD)/done/emacs/native/configure
	$(MAKE) -C $(BUILD)/emacs/native
	@touch $@

$(BUILD)/done/emacs/native/configure: $(BUILD)/done/emacs/native/copy
	(cd $(BUILD)/emacs/native; sh autogen.sh)
	(cd $(BUILD)/emacs/native; ./configure)
	@touch $@

$(BUILD)/done/emacs/native/copy: | $(BUILD)/done/emacs/native/ $(BUILD)/emacs/native/
	$(CP) -a userspace/emacs/emacs/* $(BUILD)/emacs/native/
	@touch $@
