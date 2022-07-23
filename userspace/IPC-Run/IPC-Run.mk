$(BUILD)/userspace/IPC-Run/done/install: $(BUILD)/userspace/IPC-Run/done/build
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/IPC-Run/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/IPC-Run/IPC-Run.tar: $(BUILD)/userspace/IPC-Run/done/build
	tar -C $(BUILD)/userspace/IPC-Run -cf $@ done build

$(BUILD)/userspace/IPC-Run/done/build: $(BUILD)/userspace/IPC-Run/done/configure
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/IPC-Run/build
	@touch $@

$(BUILD)/userspace/IPC-Run/done/configure: $(BUILD)/userspace/IPC-Run/done/copy $(BUILD)/userspace/perl/done/install
	(cd $(BUILD)/userspace/IPC-Run/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl INSTALLSITEARCH=/lib/perl5/site_perl)
	@touch $@

$(BUILD)/userspace/IPC-Run/done/copy: $(BUILD)/userspace/IPC-Run/done/checkout | $(BUILD)/userspace/IPC-Run/done/ $(BUILD)/userspace/IPC-Run/build/
	$(CP) -aus $(PWD)/userspace/IPC-Run/IPC-Run/* $(BUILD)/userspace/IPC-Run/build/
	@touch $@

$(BUILD)/userspace/IPC-Run/done/checkout: | $(BUILD)/userspace/IPC-Run/done/
	$(MAKE) userspace/IPC-Run/IPC-Run{checkout}
	@touch $@

userspace-modules += IPC-Run
