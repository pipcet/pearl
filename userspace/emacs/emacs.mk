$(call done,userspace/emacs,cross/install): $(call done,userspace/emacs,cross/build)
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(call done,userspace/emacs,cross/build): $(call done,userspace/emacs,cross/configure)
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross/
	@touch $@

$(call done,userspace/emacs,cross/configure): $(call done,userspace/emacs,cross/copy) $(call done,toolchain/gcc,gcc/install) $(call done,userspace/glibc,glibc/install) $(call done,userspace/ncurses,install)
	(cd $(BUILD)/userspace/emacs/cross; $(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --without-all --without-json --without-x --host=aarch64-linux-gnu CFLAGS="$(CROSS_CFLAGS)" --prefix=/)
	@touch $@

$(call done,userspace/emacs,cross/copy): $(call done,userspace/emacs,native/build) $(call done,userspace/emacs,checkout) | $(call done,userspace/emacs,cross/) $(BUILD)/userspace/emacs/cross/
	$(CP) -aus $(BUILD)/userspace/emacs/native/* $(BUILD)/userspace/emacs/cross/
	@touch $@

$(call done,userspace/emacs,native/build): $(call done,userspace/emacs,native/configure)
	$(MAKE) -C $(BUILD)/userspace/emacs/native
	@touch $@

$(call done,userspace/emacs,native/configure): $(call done,userspace/emacs,native/copy)
	(cd $(BUILD)/userspace/emacs/native; sh autogen.sh)
	(cd $(BUILD)/userspace/emacs/native; ./configure --without-all --without-x)
	@touch $@

$(call done,userspace/emacs,native/copy): $(call done,userspace/emacs,checkout) | $(call done,userspace/emacs,native/) $(BUILD)/userspace/emacs/native/
	$(CP) -aus $(PWD)/userspace/emacs/emacs/* $(BUILD)/userspace/emacs/native/
	@touch $@

$(call done,userspace/emacs,checkout): | $(call done,userspace/emacs,)
	$(MAKE) userspace/emacs/emacs{checkout}
	@touch $@

$(call done,userspace/emacs,install): $(call done,userspace/emacs,cross/install)
	@touch $@

userspace-modules += emacs
