$(BUILD)/blobs.tar: $(wildcard blobs/*.tar)
	$(MKDIR) $(dir $@)
	(cd blobs; tar c $(^:blobs/%=%)) > $@ || touch $@

$(call pearl-static,$(BUILD)/blobs.tar,$(BUILD))
