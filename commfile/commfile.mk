build/commfile/send-commfile: commfile/send-commfile
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/commfile/receive-commfile: commfile/receive-commfile.c
	$(MKDIR) $(dir $@)
	$(CROSS_COMPILE)gcc -static -Os -o $@ $<

%.image.commfile: %.image
	$(MKDIR) $@.d
	$(CP) $< $@.d
	tar -C $@.d -c . > $@

%.commfile{send}: %.commfile
	$(SUDO) commfile/send-commfile $<
