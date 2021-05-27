build/dt/bin/dt: dt/dt
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/dt/bin/adtdump: dt/adtdump.c
	$(CROSS_COMPILE)gcc -Os -static -o $@ $<

build/dt/bin/adtp: dt/adtp.cc
	$(CROSS_COMPILE)g++ -Os -static -o $@ $<
