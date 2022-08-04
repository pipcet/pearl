$(call done,userspace/dropbear,install): $(call done,userspace/dropbear,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp" install
	$(INSTALL_LIBS) userspace/dropbear
	$(TIMESTAMP)

$(call done,userspace/dropbear,build): $(call done,userspace/dropbear,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/dropbear/build PROGRAMS="dropbear dbclient scp"
	$(TIMESTAMP)

$(call done,userspace/dropbear,configure): $(call done,userspace/dropbear,copy) | $(call deps,glibc gcc zlib)
	(cd $(BUILD)/userspace/dropbear/build/; $(WITH_CROSS_PATH) CC=aarch64-linux-gnu-gcc ./configure CFLAGS="$(CROSS_CFLAGS)" --host=x86_64-pc-linux-gnu --disable-harden --prefix=$(call install,userspace/dropbear))
	$(TIMESTAMP)

$(call done,userspace/dropbear,copy): $(call done,userspace/dropbear,checkout) | $(call done,userspace/dropbear,) $(BUILD)/userspace/dropbear/build/
	$(COPY_SAUNA) $(PWD)/userspace/dropbear/dropbear/* $(BUILD)/userspace/dropbear/build/
	$(TIMESTAMP)

$(call done,userspace/dropbear,checkout): | $(call done,userspace/dropbear,)
	$(MAKE) userspace/dropbear/dropbear{checkout}
	$(TIMESTAMP)

userspace-modules += dropbear
