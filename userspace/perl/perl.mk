DEP_perl += $(BUILD)/userspace/perl/done/install
$(BUILD)/userspace/perl/done/install: $(BUILD)/userspace/perl/done/build
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/perl/build install
	@touch $@

$(BUILD)/userspace/perl/done/build: $(BUILD)/userspace/perl/done/configure
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/perl/build
	@touch $@

$(BUILD)/userspace/perl/done/configure: $(BUILD)/userspace/perl/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/perl/build; $(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) sh ./Configure -der -Uversiononly -Uusemymalloc -Dtargetarch="aarch64-linux-gnu" -Dcc="aarch64-linux-gnu-gcc $(CORE_CFLAGS)" -Dccflags="$(CORE_CFLAGS)" -Doptimize="$(CORE_CFLAGS) -fno-strict-aliasing" -Dincpth='' -Dcccdlflags="-fPIC -Wl,--shared -shared" -Dlddlflags="-Wl,--shared -shared" -Uman1dir -Dusedevel -Uversiononly -Dprefix="/" -Dsitelib="/lib/perl5/site_perl /share/perl5/site_perl" -Dinstallprefix="$(BUILD)/pearl/install" -Dsysroot="$(BUILD)/pearl/install/")
	@touch $@

$(BUILD)/userspace/perl/done/copy: $(BUILD)/userspace/perl/done/checkout | $(BUILD)/userspace/perl/build/ $(BUILD)/userspace/perl/done/
	$(CP) -aus $(PWD)/userspace/perl/perl/* $(addprefix $(PWD)/userspace/perl/perl/.,dir-locals.el editorconfig lgtm.yml metaconf-exclusions.txt travis.yml) $(BUILD)/userspace/perl/build/
	@touch $@

$(BUILD)/userspace/perl/done/checkout: | $(BUILD)/userspace/perl/done/
	$(MAKE) userspace/perl/perl{checkout}
	@touch $@

userspace-modules += perl
