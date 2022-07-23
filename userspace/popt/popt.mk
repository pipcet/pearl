$(call done,userspace/popt,install): $(call done,userspace/popt,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/popt/popt.tar: $(call done,userspace/popt,build)
	tar -C $(BUILD)/userspace/popt -cf $@ done build

$(call done,userspace/popt,build): $(call done,userspace/popt,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/popt/build
	@touch $@

$(call done,userspace/popt,configure): $(call done,userspace/popt,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) sh autogen.sh)
	(cd $(BUILD)/userspace/popt/build; $(WITH_CROSS_PATH) ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(call done,userspace/popt,copy): $(call done,userspace/popt,checkout) | $(call done,userspace/popt,) $(BUILD)/userspace/popt/build/
	$(COPY_SAUNA) $(PWD)/userspace/popt/popt/* $(BUILD)/userspace/popt/build/
	@touch $@

$(call done,userspace/popt,checkout): | $(call done,userspace/popt,)
	$(MAKE) userspace/popt/popt{checkout}
	@touch $@

userspace-modules += popt
