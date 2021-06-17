$(BUILD)/lvm2/done/install: $(BUILD)/lvm2/done/build | $(BUILD)/lvm2/done/ $(BUILD)/busybocs/install/
	$(MAKE) -C $(BUILD)/lvm2/build DESTDIR=$(BUILD)/busybocs/install/ install
	touch $@

$(BUILD)/lvm2/done/build: $(BUILD)/lvm2/done/configure | $(BUILD)/lvm2/done/
	$(MAKE) -C $(BUILD)/lvm2/build
	touch $@

$(BUILD)/lvm2/done/configure: $(BUILD)/lvm2/done/copy $(BUILD)/libaio/done/install $(BUILD)/libblkid/done/install $(BUILD)/glibc/done/install $(BUILD)/gcc/done/install | $(BUILD)/lvm2/done/
	(cd $(BUILD)/lvm2/build; ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(MY_CFLAGS) -I." LDFLAGS="-L$(BUILD)/busybocs/install/lib")
	touch $@

$(BUILD)/lvm2/done/copy: | $(BUILD)/lvm2/build/ $(BUILD)/lvm2/done/
	cp -a subrepo/lvm2/* $(BUILD)/lvm2/build
	touch $@
