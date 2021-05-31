define COPY
	$(MKDIR) -p $(dir $@)
	$(CP) -a $< $@
endef
