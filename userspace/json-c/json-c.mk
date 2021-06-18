$(BUILD)/done/json-c/install: $(BUILD)/done/json-c/build
	PATH="$(BUILD)/toolchain/bin:$$PATH" $(MAKE) -C $(BUILD)/json-c/build DESTDIR="$(BUILD)/install" install
	@touch $@

$(BUILD)/done/json-c/build: $(BUILD)/done/json-c/configure
	PATH="$(BUILD)/toolchain/bin:$$PATH" $(MAKE) -C $(BUILD)/json-c/build
	@touch $@

$(BUILD)/done/json-c/configure: $(BUILD)/done/json-c/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/json-c/build; cmake -DCMAKE_LINKER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=$(BUILD)/toolchain/bin/aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/install/include -L$(BUILD)/install/lib --sysroot=$(BUILD)/install" .)
	@touch $@

$(BUILD)/done/json-c/copy: $(BUILD)/done/json-c/checkout | $(BUILD)/done/json-c/ $(BUILD)/json-c/build/
	cp -a userspace/json-c/json-c/* $(BUILD)/json-c/build/
	@touch $@

$(BUILD)/done/json-c/checkout: userspace/json-c/json-c{checkout} | $(BUILD)/done/json-c/
	@touch $@
