build/busybocs/busybocs.tar: stamp/busybocs | build/busybocs/
	$(MAKE) -C submodule/busybocs build/busybocs.tar
	$(CP) build/busybocs.tar $@
