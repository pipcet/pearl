#	for a in zstd/zstdmain.c zstd/zstd/lib/decompress/*.c zstd/zstd/lib/common/*.c; do aarch64-linux-gnu-gcc -mgeneral-regs-only -static -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -O3 -Wall -fno-exceptions -fpie -mstrict-align -S -o $$a.s -ffreestanding -fno-builtin-functions -nostdlib -fno-inline $$a; done
$(BUILD)/zstd/zstdlib.elf: zstd/payload zstd/zstdmain.c | $(BUILD)/zstd/
	aarch64-linux-gnu-gcc  -mgeneral-regs-only -static -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -O3 -Wall -fno-exceptions -fpie -mstrict-align -o $@ -ffreestanding -fno-builtin-functions -nostdlib -fno-inline zstd/zstdmain.c zstd/zstd/lib/decompress/*.c zstd/zstd/lib/common/*.c zstd/chickens.S # -flto -fomit-frame-pointer -Os -fPIC 
#zstd/zstdlib.elf: zstd/zstd.c
#	aarch64-linux-gnu-gcc -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -fPIC -Os -flto  -Wall -fno-exceptions -mstrict-align -o $@ -ffreestanding -fno-builtin-functions -nostdlib -fno-inline zstd/zstd.c # -flto -fomit-frame-pointer -Os -fPIC 

$(BUILD)/zstd/zstdlib: $(BUILD)/zstd/zstdlib.elf
	aarch64-linux-gnu-objcopy -Obinary $< $@

$(BUILD)/zstd/zstdout: $(BUILD)/zstd/zstdlib zstd/payload
	cat $^ > $@

%.macho.zst: %.macho
	zstd -22 --ultra --long=31 --verbose < $< > $@

%.macho.zst.image: $(BUILD)/zstd/zstdlib %.macho.zst
	cat $^ > $@

$(BUILD)/zstd/zstdout.image: $(BUILD)/zstd/zstdout
	$(COPY)

$(BUILD)/zstd/zstdout.modules:
	touch $@

$(BUILD)/zstd/zstdout.sendfile.d/sendfile: FORCE | $(BUILD)/zstd/zstdout.sendfile.d/
	echo "#!/bin/sh" > $@
	echo "kexec --mem-min=0x840000000 --mem-max=0x8c0000000 -fix zstdout.image" >> $@
	chmod u+x $@

$(BUILD)/zstd/zstdout.sendfile: $(BUILD)/zstd/zstdout.sendfile.d/sendfile
	$(CP) $(filter-out $<,$^) $@.d
	$(CP) $(BUILD)/zstd/zstdout.sendfile.d/sendfile $@.d/script
	tar -C $@.d -c . | gzip -1 > $@

$(BUILD)/zstd/zstdout.sendfile: $(BUILD)/zstd/zstdout.image
$(BUILD)/zstd/zstdout.sendfile: $(BUILD)/zstd/zstdout.modules

.PHONY: FORCE
