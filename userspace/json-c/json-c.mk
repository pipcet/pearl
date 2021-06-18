$(BUILD)/done/json-c/install: $(BUILD)/done/json-c/build
$(BUILD)/done/json-c/build: $(BUILD)/done/json-c/configure
$(BUILD)/done/json-c/configure: $(BUILD)/done/json-c/copy
$(BUILD)/done/json-c/copy: | $(BUILD)/done/json-c/ $(BUILD)/json-c/build/
	cp -a userspace/json-c/* $(BUILD)/json-c/build/
	@touch $@
