$(BUILD)/json-c/done/install: $(BUILD)/json-c/done/build
	PATH="$(BUILD)/toolchain/bin:$$PATH" $(MAKE) -C $(BUILD)/json-c/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/json-c/done/build: $(BUILD)/json-c/done/configure
	PATH="$(BUILD)/toolchain/bin:$$PATH" $(MAKE) -C $(BUILD)/json-c/build
	@touch $@

$(BUILD)/json-c/done/configure: $(BUILD)/json-c/done/copy $(BUILD)/glibc/done/glibc/install $(BUILD)/gcc/done/gcc/install
	(cd $(BUILD)/json-c/build; cmake -DCMAKE_LINKER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/pearl/install/include -L$(BUILD)/pearl/install/lib --sysroot=$(BUILD)/pearl/install" .)
	@touch $@

$(BUILD)/json-c/done/copy: $(BUILD)/json-c/done/checkout | $(BUILD)/json-c/done/ $(BUILD)/json-c/build/
	cp -a userspace/json-c/json-c/* $(BUILD)/json-c/build/
	@touch $@

$(BUILD)/json-c/done/checkout: userspace/json-c/json-c{checkout} | $(BUILD)/json-c/done/
	@touch $@
