build/dt/bin/dt: dt/dt
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/dt/bin/adtdump: dt/adtdump.c
	$(CROSS_COMPILE)gcc -Os -static -o $@ $<

build/dt/bin/adtp: dt/adtp.cc
	$(CROSS_COMPILE)g++ -Os -static -o $@ $<

build/dt.tar: build/dt/bin/dt build/dt/bin/adtdump build/dt/bin/adtp
	(cd build/dt; tar c bin/dt bin/adtdump bin/adtp) > $@
