$(BUILD)/host/image-to-macho: host/macho-tools/image-to-macho.c | $(BUILD)/host/
	gcc -Os -I$(BUILD)/host/macho-tools -o $@ $<

$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/perform-alignment..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/x8r8g8b8..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/enable-all-clocks..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/save-boot-args..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/restore-boot-args..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/nop..h
$(BUILD)/host/image-to-macho: $(BUILD)/host/macho-tools/bring-up-phys..h

$(BUILD)/host/macho-to-image: host/macho-tools/macho-to-image.c | $(BUILD)/host/
	gcc -Os -I$(BUILD)/host/macho-tools -o $@ $<

$(BUILD)/host/macho-to-image: $(BUILD)/host/macho-tools/macho-boot..h
$(BUILD)/host/macho-to-image: $(BUILD)/host/macho-tools/image-header..h
$(BUILD)/host/macho-to-image: $(BUILD)/host/macho-tools/disable-timers..h

$(BUILD)/macho-image-fill: host/macho-tools/macho-image-fill
	$(MKDIR) $(dir $@)
	$(CP) $< $@

$(BUILD)/%.image.macho: $(BUILD)/%.image $(BUILD)/host/image-to-macho
	$(BUILD)/host/image-to-macho $< $@ --version "$* of `date --iso=s`"

$(BUILD)/%.macho.image: $(BUILD)/%.macho $(BUILD)/host/macho-to-image
	$(BUILD)/host/macho-to-image $< $@
