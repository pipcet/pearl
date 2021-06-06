build/dt/bin/dt: dt/dt | build/dt/bin/
	$(COPY)

build/dt/bin/adtdump: dt/adtdump.c | build/dt/bin/
	$(CROSS_COMPILE)gcc -Os -static -o $@ $<

build/dt/bin/adtp: dt/adtp.cc | build/dt/bin/
	$(CROSS_COMPILE)g++ -Os -static -o $@ $<

build/dt.tar: build/dt/bin/dt build/dt/bin/adtdump build/dt/bin/adtp
	(cd build/dt; tar c bin/dt bin/adtdump bin/adtp) > $@

build/%.dts.dtp: build/%.dts build/dt/bin/dt
	build/dt/bin/dt dts-to-dtp $< $@
