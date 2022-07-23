$(call done,userspace/procps,install): $(call done,userspace/procps,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(call done,userspace/procps,build): $(call done,userspace/procps,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/procps/build
	@touch $@

$(call done,userspace/procps,configure): $(call done,userspace/procps,copy) $(call deps,glibc ncurses)
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/procps/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" PKG_CONFIG_PATH="$(BUILD)/pearl/install/lib/pkgconfig")
	@touch $@

$(call done,userspace/procps,copy): $(call done,userspace/procps,checkout) | $(call done,userspace/procps,) $(BUILD)/userspace/procps/build/
	$(CP) -aus $(PWD)/userspace/procps/procps/* $(BUILD)/userspace/procps/build/
	@touch $@

$(call done,userspace/procps,checkout): | $(call done,userspace/procps,)
	$(MAKE) userspace/procps/procps{checkout}
	@touch $@

userspace-modules += procps
