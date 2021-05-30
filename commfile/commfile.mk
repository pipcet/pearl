build/commfile/send-commfile: commfile/send-commfile
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/commfile/receive-commfile: commfile/receive-commfile.c
	$(MKDIR) $(dir $@)
	$(CROSS_COMPILE)gcc -static -Os -o $@ $<
