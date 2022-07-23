$(BUILD)/userspace/zsh/done/install: $(BUILD)/userspace/zsh/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zsh/build DESTDIR="$(BUILD)/pearl/install" install.bin install.modules install.fns
	@touch $@

$(BUILD)/userspace/zsh/done/build: $(BUILD)/userspace/zsh/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/zsh/build
	@touch $@

$(BUILD)/userspace/zsh/done/configure: $(BUILD)/userspace/zsh/done/copy $(call deps,glibc gcc libgcc ncurses)
	(cd $(BUILD)/userspace/zsh/build; autoreconf -vif)
	(cd $(BUILD)/userspace/zsh/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/userspace/zsh/done/copy: $(BUILD)/userspace/zsh/done/checkout | $(BUILD)/userspace/zsh/done/ $(BUILD)/userspace/zsh/build/
	$(CP) -aus $(PWD)/userspace/zsh/zsh/* $(BUILD)/userspace/zsh/build/
	@touch $@

$(BUILD)/userspace/zsh/done/checkout: | $(BUILD)/userspace/zsh/done/
	$(MAKE) userspace/zsh/zsh{checkout}
	@touch $@

userspace-modules += zsh
