DEP_perl += $(BUILD)/perl/done/install
$(BUILD)/perl/done/install: $(BUILD)/perl/done/build
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/perl/build install
	@touch $@

$(BUILD)/perl/done/build: $(BUILD)/perl/done/configure
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/perl/build
	@touch $@

$(BUILD)/perl/done/configure: $(BUILD)/perl/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/perl/build; $(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) sh ./Configure -der -Uversiononly -Uusemymalloc -Dtargetarch="aarch64-linux-gnu" -Dcc="aarch64-linux-gnu-gcc $(CORE_CFLAGS)" -Dccflags="$(CORE_CFLAGS)" -Doptimize="$(CORE_CFLAGS) -fno-strict-aliasing" -Dincpth='' -Dcccdlflags="-fPIC -Wl,--shared -shared" -Dlddlflags="-Wl,--shared -shared" -Uman1dir -Dusedevel -Uversiononly -Dprefix="/" -Dsitelib="/lib/perl5/site_perl /share/perl5/site_perl" -Dinstallprefix="$(BUILD)/pearl/install" -Dsysroot="$(BUILD)/pearl/install")
	@touch $@

$(BUILD)/perl/done/copy: $(BUILD)/perl/done/checkout | $(BUILD)/perl/build/ $(BUILD)/perl/done/
	$(CP) -aus $(PWD)/userspace/perl/perl/* $(addprefix $(PWD)/userspace/perl/perl/.,dir-locals.el editorconfig lgtm.yml metaconf-exclusions.txt travis.yml) $(BUILD)/perl/build/
	@touch $@

$(BUILD)/perl/done/checkout: | $(BUILD)/perl/done/
	$(MAKE) userspace/perl/perl{checkout}
	@touch $@

userspace-modules += perl
