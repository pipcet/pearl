$(call done,userspace/slurp,install): $(call done,userspace/slurp,build)
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/slurp/build DESTDIR="$(BUILD)/pearl/install" install
	$(TIMESTAMP)

$(BUILD)/userspace/slurp/slurp.tar: $(call done,userspace/slurp,build)
	tar -C $(BUILD)/userspace/slurp -cf $@ done build

$(call done,userspace/slurp,build): $(call done,userspace/slurp,configure)
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/slurp/build
	$(TIMESTAMP)

$(call done,userspace/slurp,configure): $(call done,userspace/slurp,copy) $(call deps,perl)
	(cd $(BUILD)/userspace/slurp/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl)
	$(TIMESTAMP)

$(call done,userspace/slurp,copy): $(call done,userspace/slurp,checkout) | $(call done,userspace/slurp,) $(BUILD)/userspace/slurp/build/
	$(COPY_SAUNA) $(PWD)/userspace/slurp/slurp/* $(BUILD)/userspace/slurp/build/
	$(TIMESTAMP)

$(call done,userspace/slurp,checkout): | $(call done,userspace/slurp,)
	$(MAKE) userspace/slurp/slurp{checkout}
	$(TIMESTAMP)

userspace-modules += slurp
