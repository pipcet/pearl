$(call done,userspace/sys-mmap,install): $(call done,userspace/sys-mmap,build)
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/sys-mmap/build install
	@touch $@

$(BUILD)/userspace/sys-mmap/sys-mmap.tar: $(call done,userspace/sys-mmap,build)
	tar -C $(BUILD)/userspace/sys-mmap -cf $@ done build

$(call done,userspace/sys-mmap,build): $(call done,userspace/sys-mmap,configure)
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/sys-mmap/build
	@touch $@

$(call done,userspace/sys-mmap,configure): $(call done,userspace/sys-mmap,copy) $(call deps,perl)
	(cd $(BUILD)/userspace/sys-mmap/build; export PERLDIR=$$(ls -d $(PWD)/build/pearl/install/lib/perl5/5.*); $(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(PWD)/build/pearl/install/bin/perl -I $$PERLDIR/linux-gnu -I $$PERLDIR Makefile.PL PERLPREFIX=$(PWD)/build/pearl/install/ PERL_ARCHLIB=$$PERLDIR/linux-gnu PERL_LIB=$$PERLDIR INSTALLDIRS=perl)
	@touch $@

$(call done,userspace/sys-mmap,copy): $(call done,userspace/sys-mmap,checkout) | $(call done,userspace/sys-mmap,) $(BUILD)/userspace/sys-mmap/build/
	$(CP) -aus $(PWD)/userspace/sys-mmap/sys-mmap/* $(BUILD)/userspace/sys-mmap/build/
	@touch $@

$(call done,userspace/sys-mmap,checkout): | $(call done,userspace/sys-mmap,)
	$(MAKE) userspace/sys-mmap/sys-mmap{checkout}
	@touch $@

userspace-modules += sys-mmap
