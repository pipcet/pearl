build/grub/efi/grub-mkimage: stamp/grub | build/grub/efi/
	(cd submodule/grub; sh bootstrap)
	(cd build/grub/efi; $(PWD)/submodule/grub/configure --host=$(NATIVE_TRIPLE) --build=$(NATIVE_TRIPLE) --target=aarch64-linux-gnu --with-platform=efi --prefix=$(PWD)/build/prefix)
	$(MAKE) -C build/grub/efi
	$(MAKE) -C build/grub/efi install

build/grub/emu/grub-mkimage: stamp/grub | build/grub/emu/
	(cd submodule/grub; sh bootstrap)
	(cd build/grub/emu; $(PWD)/submodule/grub/configure --host=aarch64-linux-gnu --build=$(NATIVE_TRIPLE) --target=aarch64-linux-gnu --with-platform=emu --prefix=$(PWD)/build/prefix)
	$(MAKE) -C build/grub/emu
	$(MAKE) -C build/grub/emu install
