$(BUILD)/sys-mmap/done/install: $(BUILD)/sys-mmap/done/build
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/sys-mmap/build install
	@touch $@

$(BUILD)/sys-mmap/sys-mmap.tar: $(BUILD)/sys-mmap/done/build
	tar -C $(BUILD)/sys-mmap -cf $@ done build

$(BUILD)/sys-mmap/done/build: $(BUILD)/sys-mmap/done/configure
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/sys-mmap/build
	@touch $@

$(BUILD)/sys-mmap/done/configure: $(BUILD)/sys-mmap/done/copy $(call deps,perl)
	(cd $(BUILD)/sys-mmap/build; export PERLDIR=$$(ls -d $(PWD)/build/pearl/install/lib/perl5/5.*); $(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(PWD)/build/pearl/install/bin/perl -I $$PERLDIR/linux-gnu -I $$PERLDIR Makefile.PL PERLPREFIX=$(PWD)/build/pearl/install/ PERL_ARCHLIB=$$PERLDIR/linux-gnu PERL_LIB=$$PERLDIR INSTALLDIRS=perl)
	@touch $@

$(BUILD)/sys-mmap/done/copy: $(BUILD)/sys-mmap/done/checkout | $(BUILD)/sys-mmap/done/ $(BUILD)/sys-mmap/build/
	$(CP) -aus $(PWD)/userspace/sys-mmap/sys-mmap/* $(BUILD)/sys-mmap/build/
	@touch $@

$(BUILD)/sys-mmap/done/checkout: | $(BUILD)/sys-mmap/done/
	$(MAKE) userspace/sys-mmap/sys-mmap{checkout}
	@touch $@

userspace-modules += sys-mmap
