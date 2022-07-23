$(BUILD)/userspace/emacs/done/cross/install: $(BUILD)/userspace/emacs/done/cross/build
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/userspace/emacs/done/cross/build: $(BUILD)/userspace/emacs/done/cross/configure
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross/
	@touch $@

$(BUILD)/userspace/emacs/done/cross/configure: $(BUILD)/userspace/emacs/done/cross/copy $(BUILD)/toolchain/gcc/done/gcc/install $(BUILD)/userspace/glibc/done/glibc/install $(BUILD)/userspace/ncurses/done/install
	(cd $(BUILD)/userspace/emacs/cross; $(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --without-all --without-json --without-x --host=aarch64-linux-gnu CFLAGS="$(CROSS_CFLAGS)" --prefix=/)
	@touch $@

$(BUILD)/userspace/emacs/done/cross/copy: $(BUILD)/userspace/emacs/done/native/build $(BUILD)/userspace/emacs/done/checkout | $(BUILD)/userspace/emacs/done/cross/ $(BUILD)/userspace/emacs/cross/
	$(CP) -aus $(BUILD)/userspace/emacs/native/* $(BUILD)/userspace/emacs/cross/
	@touch $@

$(BUILD)/userspace/emacs/done/native/build: $(BUILD)/userspace/emacs/done/native/configure
	$(MAKE) -C $(BUILD)/userspace/emacs/native
	@touch $@

$(BUILD)/userspace/emacs/done/native/configure: $(BUILD)/userspace/emacs/done/native/copy
	(cd $(BUILD)/userspace/emacs/native; sh autogen.sh)
	(cd $(BUILD)/userspace/emacs/native; ./configure --without-all --without-x)
	@touch $@

$(BUILD)/userspace/emacs/done/native/copy: $(BUILD)/userspace/emacs/done/checkout | $(BUILD)/userspace/emacs/done/native/ $(BUILD)/userspace/emacs/native/
	$(CP) -aus $(PWD)/userspace/emacs/emacs/* $(BUILD)/userspace/emacs/native/
	@touch $@

$(BUILD)/userspace/emacs/done/checkout: | $(BUILD)/userspace/emacs/done/
	$(MAKE) userspace/emacs/emacs{checkout}
	@touch $@

$(BUILD)/userspace/emacs/done/install: $(BUILD)/userspace/emacs/done/cross/install
	@touch $@

userspace-modules += emacs
