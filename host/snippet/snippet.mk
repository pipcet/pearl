%..h: %.c.S.elf.bin.s.h ; $(COPY)
%..h: %.S.elf.bin.s.h ; $(COPY)
%..bin: %.c.S.elf.bin ; $(COPY)
%..bin: %.S.elf.bin ; $(COPY)
$(BUILD)/include/snippet.h: snippet/snippet.h | $(BUILD)/include/ ; $(COPY)

%.c.S: %.c $(BUILD)/include/snippet.h
	$(CROSS_COMPILE)gcc -I$(dir $<) -I$(BUILD)/include -fno-builtin -ffunction-sections -march=armv8.5-a -Os -S -o $@ $<

%.S.elf: %.S
	$(CROSS_COMPILE)gcc -Os -static -march=armv8.5-a -nostdlib -o $@ $<

%.elf.bin: %.elf
	$(CROSS_COMPILE)objcopy -O binary -S --only-section .pretext.0 --only-section .text --only-section .data --only-section .got --only-section .last --only-section .text.2 $< $@

%.bin.s: %.bin
	$(CROSS_COMPILE)objdump -maarch64 --disassemble-zeroes -D -bbinary $< > $@

%.s.h: $(BUILD)/%.s
	(NAME=$$(echo $(notdir $*) | sed -e 's/\..*//' -e 's/-/_/g'); echo "unsigned int $$NAME[] = {";  cat $< | tail -n +8 | sed -e 's/\t/ /g' | sed -e 's/^\(.*\):[ \t]*\([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]\)[ \t]*\(.*\)$$/\t0x\2 \/\* \1: \3 \*\/,/g'; echo "};") > $@
