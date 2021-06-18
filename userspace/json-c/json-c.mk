$(BUILD)/done/json-c/install: $(BUILD)/done/json-c/build
	$(MAKE) -C $(BUILD)/json-c/build DESTDIR="$(BUILD)/install" install
	@touch $@

$(BUILD)/done/json-c/build: $(BUILD)/done/json-c/configure
	$(MAKE) -C $(BUILD)/json-c/build
	@touch $@

$(BUILD)/done/json-c/configure: $(BUILD)/done/json-c/copy
	(cd $(BUILD)/json-c/build; cmake -DCMAKE_LINKER=aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/install/include -L$(BUILD)/install/lib --sysroot=$(BUILD)/install" .)
	@touch $@

$(BUILD)/done/json-c/copy: | $(BUILD)/done/json-c/ $(BUILD)/json-c/build/
	cp -a userspace/json-c/json-c/* $(BUILD)/json-c/build/
	@touch $@
