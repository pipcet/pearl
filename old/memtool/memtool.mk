build/memtool/memtool: stamp/memtool | build/memtool/
	(cd submodule/memtool; autoreconf -fi)
	(cd submodule/memtool; ./configure --host=aarch64-linux-gnu)
	$(MAKE) -C submodule/memtool
	$(CP) submodule/memtool/memtool $@
