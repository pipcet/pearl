ifeq ($(filter rest.tar.zstd,$(ARTIFACTS)),)
$(call done,userspace/memtool,install): $(call done,userspace/memtool,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build install
	$(INSTALL_LIBS) userspace/memtool
	$(TIMESTAMP)
else
$(call done,userspace/memtool,install): $(BUILD)/artifacts/rest.tar.zstd/extract | $(call done,userspace/memtool,)/
	$(TIMESTAMP)
endif

$(call done,userspace/memtool,build): $(call done,userspace/memtool,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/memtool/build
	$(TIMESTAMP)

$(call done,userspace/memtool,configure): $(call done,userspace/memtool,copy) | $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) autoreconf -ivf)
	(cd $(BUILD)/userspace/memtool/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix="$(call install,userspace/memtool)" CFLAGS="$(CROSS_CFLAGS)")
	$(TIMESTAMP)

$(call done,userspace/memtool,copy): | $(call done,userspace/memtool,checkout) $(call done,userspace/memtool,) $(BUILD)/userspace/memtool/build/
	$(COPY_SAUNA) $(PWD)/userspace/memtool/memtool/* $(BUILD)/userspace/memtool/build/
	$(TIMESTAMP)

$(call done,userspace/memtool,checkout): | $(call done,userspace/memtool,)
	$(MAKE) userspace/memtool/memtool{checkout}
	$(TIMESTAMP)

userspace-modules += memtool
