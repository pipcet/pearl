$(BUILD)/dt/build/bin/dt: local/dt/dt | $(BUILD)/dt/build/bin/
	$(COPY)

$(BUILD)/dt/build/bin/adtdump: local/dt/adtdump.c | $(BUILD)/dt/build/bin/
	$(WITH_CROSS_PATH) $(CROSS_COMPILE)gcc -Os -static -o $@ $<

$(BUILD)/dt/build/bin/macho-version: local/dt/macho-version.c | $(BUILD)/dt/build/bin/
	$(WITH_CROSS_PATH) $(CROSS_COMPILE)gcc -Os -static -o $@ $<

$(BUILD)/dt/build/bin/adtp: local/dt/adtp.cc | $(BUILD)/dt/build/bin/
	$(WITH_CROSS_PATH) $(CROSS_COMPILE)g++ -Os -static -o $@ $<

$(BUILD)/dt.tar: $(BUILD)/dt/bin/dt $(BUILD)/dt/bin/adtdump $(BUILD)/dt/bin/adtp
	(cd $(BUILD)/dt; tar c bin/dt bin/adtdump bin/adtp) > $@

$(BUILD)/%.dts.dtp: $(BUILD)/%.dts $(BUILD)/dt/bin/dt
	$(BUILD)/dt/bin/dt dts-to-dtp $< $@

$(call pearl-static,$(BUILD)/dt/build/bin/dt $(BUILD)/dt/build/bin/adtdump $(BUILD)/dt/build/bin/macho-version $(BUILD)/dt/build/bin/adtp,$(BUILD)/dt/build)