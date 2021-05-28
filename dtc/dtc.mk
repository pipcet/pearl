DTC ?= dtc

build/%.dtb.h: build/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/%.dts.dtb: build/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@
