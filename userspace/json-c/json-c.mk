$(call done,userspace/json-c,install): $(call done,userspace/json-c,build)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/json-c/build DESTDIR="$(BUILD)/pearl/install" install
	$(TIMESTAMP)

$(call done,userspace/json-c,build): $(call done,userspace/json-c,configure)
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/userspace/json-c/build
	$(TIMESTAMP)

$(call done,userspace/json-c,configure): $(call done,userspace/json-c,copy) $(call deps,glibc gcc)
	(cd $(BUILD)/userspace/json-c/build; cmake -DCMAKE_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/pearl/install/include -L$(BUILD)/pearl/install/lib --sysroot=$(BUILD)/pearl/install" .)
	$(TIMESTAMP)

$(call done,userspace/json-c,copy): $(call done,userspace/json-c,checkout) | $(call done,userspace/json-c,) $(BUILD)/userspace/json-c/build/
	$(CP) -au $(PWD)/userspace/json-c/json-c/* $(BUILD)/userspace/json-c/build/
	$(TIMESTAMP)

$(call done,userspace/json-c,checkout): | $(call done,userspace/json-c,)
	$(MAKE) userspace/json-c/json-c{checkout}
	$(TIMESTAMP)

userspace-modules += json-c
