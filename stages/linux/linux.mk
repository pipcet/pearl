build/stages/linux/linux.initfs: build/stages/linux/linux.cpiospec build/stages/linux/linux.image
	(cd build/linux/linux; $(PWD)/submodule/linux/usr/gen_initramfs.sh -o $(PWD)/$@ ../../../$<)
