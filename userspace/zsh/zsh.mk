$(BUILD)/zsh/done/install: $(BUILD)/zsh/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zsh/build DESTDIR="$(BUILD)/pearl/install" install.bin install.modules install.fns
	@touch $@

$(BUILD)/zsh/done/build: $(BUILD)/zsh/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/zsh/build
	@touch $@

$(BUILD)/zsh/done/configure: $(BUILD)/zsh/done/copy $(call deps,glibc gcc libgcc ncurses)
	(cd $(BUILD)/zsh/build; autoreconf -vif)
	(cd $(BUILD)/zsh/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)")
	@touch $@

$(BUILD)/zsh/done/copy: $(BUILD)/zsh/done/checkout | $(BUILD)/zsh/done/ $(BUILD)/zsh/build/
	$(CP) -aus $(PWD)/userspace/zsh/zsh/* $(BUILD)/zsh/build/
	@touch $@

$(BUILD)/zsh/done/checkout: | $(BUILD)/zsh/done/
	$(MAKE) userspace/zsh/zsh{checkout}
	@touch $@

userspace-modules += zsh
