DTC ?= dtc

build/%.dtb.h: build/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/%.dts.h: build/%.dts dtc/dtc-relocs
	$(CC) -E -x assembler-with-cpp -nostdinc $< | dtc/dtc-relocs > $@

build/%.dts.dtb: build/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@

build/%.dtb.dts: build/%.dtb
	$(DTC) -Idtb -Odts $< > $@.tmp && mv $@.tmp $@
