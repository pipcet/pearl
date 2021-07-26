$(BUILD)/sys-mmap/done/install: $(BUILD)/sys-mmap/done/build
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/sys-mmap/build install
	@touch $@

$(BUILD)/sys-mmap/sys-mmap.tar: $(BUILD)/sys-mmap/done/build
	tar -C $(BUILD)/sys-mmap -cf $@ done build

$(BUILD)/sys-mmap/done/build: $(BUILD)/sys-mmap/done/configure
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) $(MAKE) -C $(BUILD)/sys-mmap/build INSTALLPRIVLIB=$(PWD)/build/pearl/install/lib/perl5/5.35.2 INSTALLSITELIB=$(PWD)/build/pearl/install/lib/perl5/site_perl
	@touch $@

$(BUILD)/sys-mmap/done/configure: $(BUILD)/sys-mmap/done/copy $(call deps,perl)
	(cd $(BUILD)/sys-mmap/build; $(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(WITH_QEMU) PERL_ARCHLIB=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu PERL_LIB=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu PERL_INCDEP=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu/CORE $(PWD)/build/pearl/install/bin/perl -I $(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu -I $(PWD)/build/pearl/install/lib/perl5/5.35.2/ Makefile.PL PERLPREFIX=$(PWD)/build/pearl/install/ PERL_ARCHLIB=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu PERL_INC=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu/CORE INC=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu/CORE PERL_INCDEP=$(PWD)/build/pearl/install/lib/perl5/5.35.2/linux-gnu/CORE PERL_LIB=$(PWD)/build/pearl/install/lib/perl5/5.35.2)
	@touch $@

$(BUILD)/sys-mmap/done/copy: $(BUILD)/sys-mmap/done/checkout | $(BUILD)/sys-mmap/done/ $(BUILD)/sys-mmap/build/
	$(CP) -aus $(PWD)/userspace/sys-mmap/sys-mmap/* $(BUILD)/sys-mmap/build/
	@touch $@

$(BUILD)/sys-mmap/done/checkout: | $(BUILD)/sys-mmap/done/
	$(MAKE) userspace/sys-mmap/sys-mmap{checkout}
	@touch $@

userspace-modules += sys-mmap
