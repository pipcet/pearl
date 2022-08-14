ifeq ($(filter emacs.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/emacs,cross/install): $(call done,userspace/emacs,cross/build)
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross DESTDIR=$(call install,userspace/emacs) install
	$(INSTALL_LIBS) userspace/emacs
	$(TIMESTAMP)
else
$(call done,userspace/emacs,install): $(BUILD)/artifacts/emacs.tar.zstd/extract | $(call done,userspace/emacs,)/
	$(TIMESTAMP)
endif

$(call done,userspace/emacs,cross/build): $(call done,userspace/emacs,cross/configure)
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/userspace/emacs/cross/
	$(TIMESTAMP)

$(call done,userspace/emacs,cross/configure): $(call done,userspace/emacs,cross/copy) | $(call done,toolchain/gcc,gcc/install) $(call done,userspace/glibc,glibc/install) $(call done,userspace/ncurses,install) builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/emacs/cross; $(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" ./configure --target=aarch64-linux-gnu --without-all --without-json --without-x --host=aarch64-linux-gnu CFLAGS="$(CROSS_CFLAGS)" --prefix=/)
	$(TIMESTAMP)

$(call done,userspace/emacs,cross/copy): $(call done,userspace/emacs,native/build) | $(call done,userspace/emacs,checkout) $(call done,userspace/emacs,cross/) $(BUILD)/userspace/emacs/cross/
	$(COPY_SAUNA) $(BUILD)/userspace/emacs/native/* $(BUILD)/userspace/emacs/cross/
	$(TIMESTAMP)

$(call done,userspace/emacs,native/build): $(call done,userspace/emacs,native/configure)
	$(MAKE) -C $(BUILD)/userspace/emacs/native
	$(TIMESTAMP)

$(call done,userspace/emacs,native/configure): $(call done,userspace/emacs,native/copy) | builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/emacs/native; sh autogen.sh)
	(cd $(BUILD)/userspace/emacs/native; ./configure --without-all --without-x)
	$(TIMESTAMP)

$(call done,userspace/emacs,native/copy): | $(call done,userspace/emacs,checkout) $(call done,userspace/emacs,native/) $(BUILD)/userspace/emacs/native/
	$(COPY_SAUNA) $(PWD)/userspace/emacs/emacs/* $(BUILD)/userspace/emacs/native/
	$(TIMESTAMP)

$(call done,userspace/emacs,checkout): | $(call done,userspace/emacs,)
	$(MAKE) userspace/emacs/emacs{checkout}
	$(TIMESTAMP)

$(call done,userspace/emacs,install): $(call done,userspace/emacs,cross/install)
	$(TIMESTAMP)

userspace-modules += emacs
