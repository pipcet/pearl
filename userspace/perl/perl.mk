DEP_perl += $(call done,userspace/perl,install)
$(call done,userspace/perl,install): $(call done,userspace/perl,build)
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/perl/build install
	$(INSTALL_LIBS) userspace/perl
	$(TIMESTAMP)

$(call done,userspace/perl,build): $(call done,userspace/perl,configure)
	$(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/perl/build
	$(TIMESTAMP)

$(call done,userspace/perl,configure): $(call done,userspace/perl,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/perl/build; $(NATIVE_CODE_ENV) $(WITH_CROSS_PATH) sh ./Configure -der -Uversiononly -Uusemymalloc -Dtargetarch="aarch64-linux-gnu" -Dcc="aarch64-linux-gnu-gcc $(CORE_CFLAGS)" -Dccflags="$(CORE_CFLAGS)" -Doptimize="$(CORE_CFLAGS) -fno-strict-aliasing" -Dincpth='' -Dcccdlflags="-fPIC -Wl,--shared -shared" -Dlddlflags="-Wl,--shared -shared" -Uman1dir -Dusedevel -Uversiononly -Dprefix="/" -Dsitelib="/lib/perl5/site_perl /share/perl5/site_perl" -Dinstallprefix="$(call install,userspace/perl)" -Dsysroot="$(BUILD)/pearl/install/")
	$(TIMESTAMP)

$(call done,userspace/perl,copy): $(call done,userspace/perl,checkout) | $(BUILD)/userspace/perl/build/ $(call done,userspace/perl,)
	$(COPY_SAUNA) $(PWD)/userspace/perl/perl/* $(addprefix $(PWD)/userspace/perl/perl/.,dir-locals.el editorconfig lgtm.yml metaconf-exclusions.txt travis.yml) $(BUILD)/userspace/perl/build/
	$(TIMESTAMP)

$(call done,userspace/perl,checkout): | $(call done,userspace/perl,)
	$(MAKE) userspace/perl/perl{checkout}
	$(TIMESTAMP)

userspace-modules += perl
