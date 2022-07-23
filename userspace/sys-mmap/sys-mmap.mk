$(BUILD)/userspace/sys-mmap/done/install: $(BUILD)/userspace/sys-mmap/done/build
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/sys-mmap/build install
	@touch $@

$(BUILD)/userspace/sys-mmap/sys-mmap.tar: $(BUILD)/userspace/sys-mmap/done/build
	tar -C $(BUILD)/userspace/sys-mmap -cf $@ done build

$(BUILD)/userspace/sys-mmap/done/build: $(BUILD)/userspace/sys-mmap/done/configure
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/sys-mmap/build
	@touch $@

$(BUILD)/userspace/sys-mmap/done/configure: $(BUILD)/userspace/sys-mmap/done/copy $(call deps,perl)
	(cd $(BUILD)/userspace/sys-mmap/build; export PERLDIR=$$(ls -d $(PWD)/build/pearl/install/lib/perl5/5.*); $(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(PWD)/build/pearl/install/bin/perl -I $$PERLDIR/linux-gnu -I $$PERLDIR Makefile.PL PERLPREFIX=$(PWD)/build/pearl/install/ PERL_ARCHLIB=$$PERLDIR/linux-gnu PERL_LIB=$$PERLDIR INSTALLDIRS=perl)
	@touch $@

$(BUILD)/userspace/sys-mmap/done/copy: $(BUILD)/userspace/sys-mmap/done/checkout | $(BUILD)/userspace/sys-mmap/done/ $(BUILD)/userspace/sys-mmap/build/
	$(CP) -aus $(PWD)/userspace/sys-mmap/sys-mmap/* $(BUILD)/userspace/sys-mmap/build/
	@touch $@

$(BUILD)/userspace/sys-mmap/done/checkout: | $(BUILD)/userspace/sys-mmap/done/
	$(MAKE) userspace/sys-mmap/sys-mmap{checkout}
	@touch $@

userspace-modules += sys-mmap
