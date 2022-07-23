$(call done,userspace/zsh,install): $(call done,userspace/zsh,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zsh/build DESTDIR="$(BUILD)/pearl/install" install.bin install.modules install.fns
	@touch $@

$(call done,userspace/zsh,build): $(call done,userspace/zsh,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zsh/build
	@touch $@

$(call done,userspace/zsh,configure): $(call done,userspace/zsh,copy) $(call deps,glibc gcc libgcc ncurses)
	(cd $(BUILD)/userspace/zsh/build; autoreconf -vif)
	(cd $(BUILD)/userspace/zsh/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(call done,userspace/zsh,copy): $(call done,userspace/zsh,checkout) | $(call done,userspace/zsh,) $(BUILD)/userspace/zsh/build/
	$(COPY_SAUNA) $(PWD)/userspace/zsh/zsh/* $(BUILD)/userspace/zsh/build/
	@touch $@

$(call done,userspace/zsh,checkout): | $(call done,userspace/zsh,)
	$(MAKE) userspace/zsh/zsh{checkout}
	@touch $@

userspace-modules += zsh
