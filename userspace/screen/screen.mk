$(call done,userspace/screen,install): $(call done,userspace/screen,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/screen/build/src DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(call done,userspace/screen,build): $(call done,userspace/screen,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/screen/build/src
	@touch $@

$(call done,userspace/screen,configure): $(call done,userspace/screen,copy) $(call deps,glibc ncurses)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) autoreconf --install)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ --enable-pam=no CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(call done,userspace/screen,copy): $(call done,userspace/screen,checkout) | $(call done,userspace/screen,) $(BUILD)/userspace/screen/build/
	$(COPY_SAUNA) $(PWD)/userspace/screen/screen/* $(BUILD)/userspace/screen/build/
	@touch $@

$(call done,userspace/screen,checkout): | $(call done,userspace/screen,)
	$(MAKE) userspace/screen/screen{checkout}
	@touch $@

userspace-modules += screen
