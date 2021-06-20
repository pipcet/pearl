build/host/sendfile/send-sendfile: sendfile/send-sendfile
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/pearl/bin/receive-sendfile: sendfile/receive-sendfile.c
	$(MKDIR) $(dir $@)
	$(CROSS_COMPILE)gcc -static -Os -o $@ $<

%.image.sendfile: %.image %.image.d/sendfile
	$(MKDIR) $@.d
	$(CP) $< $@.d
	$(CP) -a $*.image.d/sendfile $@.d/script
	tar -C $@.d -c . | gzip -1 > $@

%.sendfile{send}: %.sendfile
	$(SUDO) sendfile/send-sendfile $<
