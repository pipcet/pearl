$(BUILD)/host/image-to-macho: host/macho-tools/image-to-macho.c | $(BUILD)/host/
	gcc -Os -I$(BUILD)/macho-tools -o $@ $<

$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/perform-alignment..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/x8r8g8b8..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/enable-all-clocks..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/save-boot-args..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/restore-boot-args..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/nop..h
$(BUILD)/host/image-to-macho: $(BUILD)/macho-tools/bring-up-phys..h

$(BUILD)/host/macho-to-image: host/macho-tools/macho-to-image.c | $(BUILD)/host/
	gcc -Os -Ibuild/macho-tools -o $@ $<

$(BUILD)/host/macho-to-image: $(BUILD)/macho-tools/macho-boot..h
$(BUILD)/host/macho-to-image: $(BUILD)/macho-tools/image-header..h
$(BUILD)/host/macho-to-image: $(BUILD)/macho-tools/disable-timers..h

$(BUILD)/macho-image-fill: host/macho-tools/macho-image-fill
	$(MKDIR) $(dir $@)
	$(CP) $< $@

$(BUILD)/%.image.macho: $(BUILD)/%.image $(BUILD)/host/image-to-macho
	$(BUILD)/host/image-to-macho $< $@ --version "$* of `date --iso=s`"

$(BUILD)/%.macho.image: $(BUILD)/%.macho $(BUILD)/host/macho-to-image
	$(BUILD)/host/macho-to-image $< $@
