$(BUILD)/done/perl/install: $(BUILD)/done/perl/build
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/perl/build install
	@touch $@

$(BUILD)/done/perl/build: $(BUILD)/done/perl/configure
	$(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/perl/build
	@touch $@

$(BUILD)/done/perl/configure: $(BUILD)/done/perl/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/perl/build; $(NATIVE_CODE_ENV) PATH="$(CROSS_PATH):$$PATH" sh ./Configure -der -Uversiononly -Uusemymalloc -Dtargetarch="aarch64-linux-gnu" -Dcc="aarch64-linux-gnu-gcc $(CORE_CFLAGS)" -Dccflags="$(CORE_CFLAGS)" -Doptimize="$(CORE_CFLAGS) -fno-strict-aliasing" -Dincpth='' -Dcccdlflags="-fPIC -Wl,--shared -shared" -Dlddlflags="-Wl,--shared -shared" -Uman1dir -Dusedevel -Dprefix="" -Dinstallprefix="$(BUILD)/install" -Dsysroot="$(BUILD)/install")
	@touch $@

$(BUILD)/done/perl/copy: $(BUILD)/done/perl/checkout | $(BUILD)/perl/build/ $(BUILD)/done/perl/
	cp -a userspace/perl/perl/* $(addprefix userspace/perl/perl/.,dir-locals.el editorconfig lgtm.yml metaconf-exclusions.txt travis.yml) $(BUILD)/perl/build/
	@touch $@

$(BUILD)/done/perl/checkout: userspace/perl/perl{checkout} | $(BUILD)/done/perl/
	@touch $@
