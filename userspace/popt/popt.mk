$(call done,userspace/popt,install): $(call done,userspace/popt,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build DESTDIR="$(call install,userspace/popt)" install
	$(INSTALL_LIBS) userspace/popt
	$(TIMESTAMP)

$(BUILD)/userspace/popt/popt.tar: $(call done,userspace/popt,build)
	tar -C $(BUILD)/userspace/popt -cf $@ done build

$(call done,userspace/popt,build): $(call done,userspace/popt,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build
	$(TIMESTAMP)

$(call done,userspace/popt,configure): $(call done,userspace/popt,copy) | $(call deps,glibc gcc) builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	$(TIMESTAMP)

$(call done,userspace/popt,copy): | $(call done,userspace/popt,checkout) $(call done,userspace/popt,) $(BUILD)/userspace/popt/build/
	$(COPY_SAUNA) $(PWD)/userspace/popt/popt/* $(BUILD)/userspace/popt/build/
	$(TIMESTAMP)

$(call done,userspace/popt,checkout): | $(call done,userspace/popt,)
	$(MAKE) userspace/popt/popt{checkout}
	$(TIMESTAMP)

userspace-modules += popt
