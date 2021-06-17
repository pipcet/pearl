build/%..h: build/%.c.S.elf.bin.s.h ; $(COPY)
build/%..h: build/%.S.elf.bin.s.h ; $(COPY)
build/%..bin: build/%.c.S.elf.bin ; $(COPY)
build/%..bin: build/%.S.elf.bin ; $(COPY)
build/include/snippet.h: snippet/snippet.h | build/include/ ; $(COPY)
build/%.S: %.S ; $(COPY)
build/%.c: %.c ; $(COPY)

build/%.c.S: build/%.c build/include/snippet.h
	$(CROSS_COMPILE)gcc -Ibuild/$(dir $<) -Ibuild/include -fno-builtin -ffunction-sections -march=armv8.5-a -Os -S -o $@ $<

build/%.S.elf: build/%.S
	$(CROSS_COMPILE)gcc -Os -static -march=armv8.5-a -nostdlib -o $@ $<

build/%.elf.bin: build/%.elf
	$(CROSS_COMPILE)objcopy -O binary -S --only-section .pretext.0 --only-section .text --only-section .data --only-section .got --only-section .last --only-section .text.2 $< $@

build/%.bin.s: build/%.bin
	$(CROSS_COMPILE)objdump -maarch64 --disassemble-zeroes -D -bbinary $< > $@

build/%.s.h: build/%.s
	(NAME=$$(echo $(notdir $*) | sed -e 's/\..*//' -e 's/-/_/g'); echo "unsigned int $$NAME[] = {";  cat $< | tail -n +8 | sed -e 's/\t/ /g' | sed -e 's/^\(.*\):[ \t]*\([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]\)[ \t]*\(.*\)$$/\t0x\2 \/\* \1: \3 \*\/,/g'; echo "};") > $@
