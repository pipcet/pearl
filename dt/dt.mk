build/dt/bin/dt: dt/dt
	$(MKDIR) $(dir $@)
	$(CP) $< $@
