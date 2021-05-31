build/blobs.tar: $(wildcard build/blobs/*.tar)
	$(MKDIR) $(dir $@)
	(cd build/blobs; tar c $(^:build/blobs/%=%)) > $@
