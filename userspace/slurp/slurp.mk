$(BUILD)/slurp/done/install: $(BUILD)/slurp/done/build
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/slurp/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/slurp/slurp.tar: $(BUILD)/slurp/done/build
	tar -C $(BUILD)/slurp -cf $@ done build

$(BUILD)/slurp/done/build: $(BUILD)/slurp/done/configure
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/slurp/build
	@touch $@

$(BUILD)/slurp/done/configure: $(BUILD)/slurp/done/copy $(call deps,perl)
	(cd $(BUILD)/slurp/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl)
	@touch $@

$(BUILD)/slurp/done/copy: $(BUILD)/slurp/done/checkout | $(BUILD)/slurp/done/ $(BUILD)/slurp/build/
	$(CP) -aus $(PWD)/userspace/slurp/slurp/* $(BUILD)/slurp/build/
	@touch $@

$(BUILD)/slurp/done/checkout: | $(BUILD)/slurp/done/
	$(MAKE) userspace/slurp/slurp{checkout}
	@touch $@

userspace-modules += slurp
