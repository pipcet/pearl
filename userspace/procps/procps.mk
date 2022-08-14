$(call done,userspace/procps,install): $(call done,userspace/procps,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build DESTDIR="$(call install,userspace/procps)" install
	$(INSTALL_LIBS) userspace/procps
	$(TIMESTAMP)

$(call done,userspace/procps,build): $(call done,userspace/procps,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build
	$(TIMESTAMP)

$(call done,userspace/procps,configure): $(call done,userspace/procps,copy) | $(call deps,glibc ncurses) builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" PKG_CONFIG_PATH="$(BUILD)/pearl/install/lib/pkgconfig")
	$(TIMESTAMP)

$(call done,userspace/procps,copy): | $(call done,userspace/procps,checkout) $(call done,userspace/procps,) $(BUILD)/userspace/procps/build/
	$(COPY_SAUNA) $(PWD)/userspace/procps/procps/* $(BUILD)/userspace/procps/build/
	$(TIMESTAMP)

$(call done,userspace/procps,checkout): | $(call done,userspace/procps,)
	$(MAKE) userspace/procps/procps{checkout}
	$(TIMESTAMP)

userspace-modules += procps
