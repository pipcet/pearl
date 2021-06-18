# XXX this currently makes all files executable

$(BUILD)/linux/pearl.cpio: $(BUILD)/initramfs/pearl.cpio ; $(COPY)
$(BUILD)/initramfs/%: local/initramfs/% ; $(COPY)
$(BUILD)/initramfs/pearl.cpio: $(BUILD)/initramfs/pearl.cpiospec
	$(MKDIR) $(dir $@)
	(cat $<; $(foreach file,$(patsubst $(BUILD)/initramfs/pearl/%,/%,$(wordlist 2,$(words $^),$^)),echo dir $(dir $(patsubst %/,%,$(file))) 755 0 0; echo file $(file) $(BUILD)/initramfs/pearl/$(file) 755 0 0;)) | sort | uniq > $@
