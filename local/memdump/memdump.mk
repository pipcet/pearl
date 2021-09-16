$(BUILD)/memdump/bin/macho-to-memdump: local/memdump/macho-to-memdump | $(BUILD)/memdump/bin/ ; $(COPY)
$(BUILD)/memdump/bin/memdump-to-image: local/memdump/memdump-to-image.c $(call deps,glibc gcc) | $(BUILD)/memdump/bin/
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(CROSS_CC) -static -Os -I$(BUILD)/local/memdump -o $@ $<

$(BUILD)/memdump/bin/memdump-to-image: $(BUILD)/local/memdump/boot..h
$(BUILD)/memdump/bin/memdump-to-image: $(BUILD)/local/memdump/image..h

$(call pearl-static,$(BUILD)/memdump/bin/memdump-to-image $(BUILD)/memdump/bin/macho-to-memdump,$(BUILD)/memdump)
