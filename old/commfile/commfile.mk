build/commfile/send-commfile: commfile/send-commfile
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/commfile/receive-commfile: commfile/receive-commfile.c
	$(MKDIR) $(dir $@)
	$(CROSS_COMPILE)gcc -static -Os -o $@ $<

%.image.commfile: %.image
	$(MKDIR) $@.d
	$(CP) $< $@.d
	$(CP) -a commfile/$(notdir $*).sh $@.d/script
	tar -C $@.d -c . | gzip -1 > $@

%.commfile{send}: %.commfile
	$(SUDO) commfile/send-commfile $<
