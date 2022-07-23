$(call done,userspace/IPC-Run,install): $(call done,userspace/IPC-Run,build)
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/IPC-Run/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/IPC-Run/IPC-Run.tar: $(call done,userspace/IPC-Run,build)
	tar -C $(BUILD)/userspace/IPC-Run -cf $@ done build

$(call done,userspace/IPC-Run,build): $(call done,userspace/IPC-Run,configure)
	$(WITH_CROSS_PATH) $(WITH_QEMU) $(MAKE) -C $(BUILD)/userspace/IPC-Run/build
	@touch $@

$(call done,userspace/IPC-Run,configure): $(call done,userspace/IPC-Run,copy) $(call done,userspace/perl,install)
	(cd $(BUILD)/userspace/IPC-Run/build; $(WITH_CROSS_PATH) $(WITH_QEMU) perl Makefile.PL INSTALLSITELIB=/lib/perl5/site_perl INSTALLSITEARCH=/lib/perl5/site_perl)
	@touch $@

$(call done,userspace/IPC-Run,copy): $(call done,userspace/IPC-Run,checkout) | $(call done,userspace/IPC-Run,) $(BUILD)/userspace/IPC-Run/build/
	$(COPY_SAUNA) $(PWD)/userspace/IPC-Run/IPC-Run/* $(BUILD)/userspace/IPC-Run/build/
	@touch $@

$(call done,userspace/IPC-Run,checkout): | $(call done,userspace/IPC-Run,)
	$(MAKE) userspace/IPC-Run/IPC-Run{checkout}
	@touch $@

userspace-modules += IPC-Run
