$(BUILD)/emacs/done/cross/install: $(BUILD)/emacs/done/cross/build
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/emacs/cross DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/emacs/done/cross/build: $(BUILD)/emacs/done/cross/configure
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/emacs/cross/
	@touch $@

$(BUILD)/emacs/done/cross/configure: $(BUILD)/emacs/done/cross/copy $(BUILD)/gcc/done/gcc/install $(BUILD)/glibc/done/glibc/install $(BUILD)/ncurses/done/install
	(cd $(BUILD)/emacs/cross; $(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --without-all --without-json --without-x --host=aarch64-linux-gnu CFLAGS="$(CROSS_CFLAGS)" --prefix=/)
	@touch $@

$(BUILD)/emacs/done/cross/copy: $(BUILD)/emacs/done/native/build $(BUILD)/emacs/done/checkout | $(BUILD)/emacs/done/cross/ $(BUILD)/emacs/cross/
	$(CP) -a $(BUILD)/emacs/native/* $(BUILD)/emacs/cross/
	@touch $@

$(BUILD)/emacs/done/native/build: $(BUILD)/emacs/done/native/configure
	$(MAKE) -C $(BUILD)/emacs/native
	@touch $@

$(BUILD)/emacs/done/native/configure: $(BUILD)/emacs/done/native/copy
	(cd $(BUILD)/emacs/native; sh autogen.sh)
	(cd $(BUILD)/emacs/native; ./configure)
	@touch $@

$(BUILD)/emacs/done/native/copy: $(BUILD)/emacs/done/checkout | $(BUILD)/emacs/done/native/ $(BUILD)/emacs/native/
	$(CP) -a userspace/emacs/emacs/* $(BUILD)/emacs/native/
	@touch $@

$(BUILD)/emacs/done/checkout: userspace/emacs/emacs{checkout} | $(BUILD)/emacs/done/
	@touch $@
