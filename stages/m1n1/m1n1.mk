build/stages/m1n1/m1n1.macho: stamp/m1n1
	$(MAKE) -C submodule/m1n1
	$(MKDIR) $(dir $@)
	$(CP) submodule/m1n1/build/m1n1.macho $@
