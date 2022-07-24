#	for a in zstd/zstdmain.c zstd/zstd/lib/decompress/*.c zstd/zstd/lib/common/*.c; do aarch64-linux-gnu-gcc -mgeneral-regs-only -static -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -O3 -Wall -fno-exceptions -fpie -mstrict-align -S -o $$a.s -ffreestanding -fno-builtin-functions -nostdlib -fno-inline $$a; done

$(BUILD)/zstd/zstdlib.elf: zstd/payload zstd/zstdmain.c | $(BUILD)/zstd/
	$(WITH_CROSS_PATH) aarch64-linux-gnu-gcc -mgeneral-regs-only -static -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -O3 -Wall -fno-exceptions -fpie -mstrict-align -o $@ -ffreestanding -fno-builtin-functions -nostdlib -fno-inline zstd/zstdmain.c zstd/zstd/lib/decompress/*.c zstd/zstd/lib/common/*.c zstd/chickens.S # -flto -fomit-frame-pointer -Os -fPIC 
#zstd/zstdlib.elf: zstd/zstd.c
#	aarch64-linux-gnu-gcc -DPAYLOAD_SIZE=$$(wc -c < zstd/payload) -Wl,--script=zstd/zstd.lds -fPIC -Os -flto  -Wall -fno-exceptions -mstrict-align -o $@ -ffreestanding -fno-builtin-functions -nostdlib -fno-inline zstd/zstd.c # -flto -fomit-frame-pointer -Os -fPIC 

$(BUILD)/zstd/zstdlib: $(BUILD)/zstd/zstdlib.elf
	$(WITH_CROSS_PATH) aarch64-linux-gnu-objcopy -Obinary $< $@

$(BUILD)/zstd/zstdout: $(BUILD)/zstd/zstdlib zstd/payload
	cat $^ > $@

%.macho.zst: %.macho
	rm -f $@
	zstd -22 --ultra --long=31 --verbose $< -o $@

%.macho.size: %.macho
	wc -c < $< > $@

%.macho.real.size: %.macho
	wc -c < $< > $@

%/pearl-debian-uncompressed.macho.real.size: %/linux/pearl.image.macho
	wc -c < $< > $@

%.macho.zst.size: %.macho.zst
	wc -c < $< > $@

%.macho.zstlib.elf: %.macho.zst.size %.macho.size %.macho.real.size zstd/zstdmain.c | $(BUILD)/zstd/
	$(WITH_CROSS_PATH) aarch64-linux-gnu-gcc -mgeneral-regs-only -static -DTOTAL_UNCOMPRESSED_SIZE=$$(cat $*.macho.size) -DUNCOMPRESSED_SIZE=$$(cat $*.macho.real.size) -DCOMPRESSED_SIZE=$$(cat $<) -Wl,--script=zstd/zstd.lds -O3 -Wall -fno-exceptions -fpie -mstrict-align -o $@ -ffreestanding -fno-builtin-functions -nostdlib -fno-inline zstd/zstdmain.c zstd/zstd/lib/decompress/*.c zstd/zstd/lib/common/*.c zstd/chickens.S # -flto -fomit-frame-pointer -Os -fPIC

%.macho.zstlib: %.macho.zstlib.elf
	$(WITH_CROSS_PATH) aarch64-linux-gnu-objcopy -Obinary $< $@

%.macho.zst.image: %.macho.zstlib %.macho.zst
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
