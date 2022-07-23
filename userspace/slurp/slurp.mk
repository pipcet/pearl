$(BUILD)/userspace/slurp/done/install: $(BUILD)/userspace/slurp/done/build
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/slurp/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/slurp/slurp.tar: $(BUILD)/userspace/slurp/done/build
	tar -C $(BUILD)/userspace/slurp -cf $@ done build

$(BUILD)/userspace/slurp/done/build: $(BUILD)/userspace/slurp/done/configure
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/slurp/build
	@touch $@

$(BUILD)/userspace/slurp/done/configure: $(BUILD)/userspace/slurp/done/copy $(call deps,perl)
	(cd $(BUILD)/userspace/slurp/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl)
	@touch $@

$(BUILD)/userspace/slurp/done/copy: $(BUILD)/userspace/slurp/done/checkout | $(BUILD)/userspace/slurp/done/ $(BUILD)/userspace/slurp/build/
	$(CP) -aus $(PWD)/userspace/slurp/slurp/* $(BUILD)/userspace/slurp/build/
	@touch $@

$(BUILD)/userspace/slurp/done/checkout: | $(BUILD)/userspace/slurp/done/
	$(MAKE) userspace/slurp/slurp{checkout}
	@touch $@

userspace-modules += slurp
