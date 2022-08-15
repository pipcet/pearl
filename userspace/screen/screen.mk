ifeq ($(filter rest.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/screen,install): $(call done,userspace/screen,build)
	$(WITH_CROSS_PATH) $(MAKE) CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/userspace/screen/build/src DESTDIR="$(call install,userspace/screen)" install
	$(INSTALL_LIBS) userspace/screen
	$(TIMESTAMP)
else
$(call done,userspace/screen,install): $(BUILD)/artifacts/rest.tar.zstd/extract | $(call done,userspace/screen,)/
	$(TIMESTAMP)
endif

$(call done,userspace/screen,build): $(call done,userspace/screen,configure)
	$(WITH_CROSS_PATH) $(MAKE) CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/userspace/screen/build/src
	$(TIMESTAMP)

$(call done,userspace/screen,configure): $(call done,userspace/screen,copy) | $(call deps,glibc ncurses)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) autoreconf --install)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/screen/build/src; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ --enable-pam=no CFLAGS="$(CROSS_CFLAGS)")
	$(TIMESTAMP)

$(call done,userspace/screen,copy): | $(call done,userspace/screen,checkout) $(call done,userspace/screen,) $(BUILD)/userspace/screen/build/
	$(COPY_SAUNA) $(PWD)/userspace/screen/screen/* $(BUILD)/userspace/screen/build/
	$(TIMESTAMP)

$(call done,userspace/screen,checkout): | $(call done,userspace/screen,)
	$(MAKE) userspace/screen/screen{checkout}
	$(TIMESTAMP)

userspace-modules += screen
