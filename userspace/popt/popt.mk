$(BUILD)/done/popt/install: $(BUILD)/done/popt/build
$(BUILD)/done/popt/build: $(BUILD)/done/popt/configure
$(BUILD)/done/popt/configure: $(BUILD)/done/popt/copy
$(BUILD)/done/popt/copy: | $(BUILD)/done/popt/ $(BUILD)/popt/build/
