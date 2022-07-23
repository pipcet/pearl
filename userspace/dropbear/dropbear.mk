$(call done,userspace/dropbear,install): $(call done,userspace/dropbear,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp" install
	@touch $@

$(call done,userspace/dropbear,build): $(call done,userspace/dropbear,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp"
	@touch $@

$(call done,userspace/dropbear,configure): $(call done,userspace/dropbear,copy) $(call deps,glibc gcc zlib)
	(cd $(BUILD)/userspace/dropbear/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc ./configure CFLAGS="$(CROSS_CFLAGS)" --host=x86_64-pc-linux-gnu --disable-harden --prefix=$(BUILD)/pearl/install)
	@touch $@

$(call done,userspace/dropbear,copy): $(call done,userspace/dropbear,checkout) | $(call done,userspace/dropbear,) $(BUILD)/userspace/dropbear/build/
	$(COPY_SAUNA) $(PWD)/userspace/dropbear/dropbear/* $(BUILD)/userspace/dropbear/build/
	@touch $@

$(call done,userspace/dropbear,checkout): | $(call done,userspace/dropbear,)
	$(MAKE) userspace/dropbear/dropbear{checkout}
	@touch $@

userspace-modules += dropbear
