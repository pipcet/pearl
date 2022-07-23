$(BUILD)/userspace/json-c/done/install: $(BUILD)/userspace/json-c/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/json-c/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/userspace/json-c/done/build: $(BUILD)/userspace/json-c/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/json-c/build
	@touch $@

$(BUILD)/userspace/json-c/done/configure: $(BUILD)/userspace/json-c/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/json-c/build; cmake -DCMAKE_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/pearl/install/include -L$(BUILD)/pearl/install/lib --sysroot=$(BUILD)/pearl/install" .)
	@touch $@

$(BUILD)/userspace/json-c/done/copy: $(BUILD)/userspace/json-c/done/checkout | $(BUILD)/userspace/json-c/done/ $(BUILD)/userspace/json-c/build/
	$(CP) -au $(PWD)/userspace/json-c/json-c/* $(BUILD)/userspace/json-c/build/
	@touch $@

$(BUILD)/userspace/json-c/done/checkout: | $(BUILD)/userspace/json-c/done/
	$(MAKE) userspace/json-c/json-c{checkout}
	@touch $@

userspace-modules += json-c
