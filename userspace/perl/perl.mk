$(BUILD)/perl/done/install: $(BUILD)/perl/done/build
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/perl/build install
	@touch $@

$(BUILD)/perl/done/build: $(BUILD)/perl/done/configure
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/perl/build
	@touch $@

$(BUILD)/perl/done/configure: $(BUILD)/perl/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/perl/build; $(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) sh ./Configure -der -Uversiononly -Uusemymalloc -Dtargetarch="aarch64-linux-gnu" -Dcc="aarch64-linux-gnu-gcc $(CORE_CFLAGS)" -Dccflags="$(CORE_CFLAGS)" -Doptimize="$(CORE_CFLAGS) -fno-strict-aliasing" -Dincpth='' -Dcccdlflags="-fPIC -Wl,--shared -shared" -Dlddlflags="-Wl,--shared -shared" -Uman1dir -Dusedevel -Dprefix="" -Dinstallprefix="$(BUILD)/pearl/install" -Dsysroot="$(BUILD)/pearl/install")
	@touch $@

$(BUILD)/perl/done/copy: $(BUILD)/perl/done/checkout | $(BUILD)/perl/build/ $(BUILD)/perl/done/
	cp -a userspace/perl/perl/* $(addprefix userspace/perl/perl/.,dir-locals.el editorconfig lgtm.yml metaconf-exclusions.txt travis.yml) $(BUILD)/perl/build/
	@touch $@

$(BUILD)/perl/done/checkout: userspace/perl/perl{checkout} | $(BUILD)/perl/done/
	@touch $@
