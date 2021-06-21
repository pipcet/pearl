$(BUILD)/IPC-Run/done/install: $(BUILD)/IPC-Run/done/build
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/IPC-Run/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/IPC-Run/IPC-Run.tar: $(BUILD)/IPC-Run/done/build
	tar -C $(BUILD)/IPC-Run -cf $@ done build

$(BUILD)/IPC-Run/done/build: $(BUILD)/IPC-Run/done/configure
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/IPC-Run/build
	@touch $@

$(BUILD)/IPC-Run/done/configure: $(BUILD)/IPC-Run/done/copy $(BUILD)/perl/done/install
	(cd $(BUILD)/IPC-Run/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl INSTALLSITEARCH=/lib/perl5/site_perl)
	@touch $@

$(BUILD)/IPC-Run/done/copy: $(BUILD)/IPC-Run/done/checkout | $(BUILD)/IPC-Run/done/ $(BUILD)/IPC-Run/build/
	$(CP) -aus $(PWD)/userspace/IPC-Run/IPC-Run/* $(BUILD)/IPC-Run/build/
	@touch $@

$(BUILD)/IPC-Run/done/checkout: userspace/IPC-Run/IPC-Run{checkout} | $(BUILD)/IPC-Run/done/
	@touch $@

userspace-modules += IPC-Run
