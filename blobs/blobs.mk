build/blobs.tar: $(wildcard blobs/*.tar)
	$(MKDIR) $(dir $@)
	(cd blobs; tar c $(^:blobs/%=%)) > $@
