$(call done,qemu,build): $(call done,qemu,configure)
	$(MAKE) -C $(BUILD)/qemu
	$(TIMESTAMP)

$(call done,qemu,configure): $(call done,qemu,copy)
	(cd $(BUILD)/qemu; ./configure --target-list=aarch64-softmmu)
	$(TIMESTAMP)

$(call done,qemu,copy): $(call done,qemu,checkout) | $(BUILD)/qemu/
	$(COPY_SAUNA) $(PWD)/qemu/qemu/* $(BUILD)/qemu/
	$(TIMESTAMP)

$(call done,qemu,checkout): | $(call done,qemu,)
	$(MAKE) qemu/qemu{checkout}
	$(TIMESTAMP)

%.image.qemu: %.image
	(./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -d unimp -device ramfb -monitor unix:$@,server,wait=off -chardev socket,path=$*.image.gdb,server=on,wait=on,id=gdb0 -gdb chardev:gdb0 -device usb-kbd -icount shift=0; rm -f $@ $*.image.gdb) &
	sleep 5

%/barebox.image.qemu %/barebox.image.gdb: %/barebox.image %/barebox.dtb
	(QEMU_WITH_DTB=1 ./build/qemu/build/qemu-system-aarch64 -m 8196m -cpu max -machine virt -kernel $< -S -d unimp -device ramfb -monitor unix:$@,server,wait=off -chardev socket,path=$*/barebox.image.gdb,server=on,wait=on,id=gdb0 -gdb chardev:gdb0 -device usb-kbd -icount shift=0 -dtb $*/barebox.dtb; rm -f $@ $*/barebox.image.gdb) &
	sleep 5

%/u-boot.image.qemu: %/u-boot.image %/barebox.dtb
	(QEMU_WITH_DTB=1 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -d unimp -device ramfb -monitor unix:$@,server,wait=off -chardev socket,path=$*/u-boot.image.gdb,server=on,wait=on,id=gdb0 -gdb chardev:gdb0 -device usb-kbd -icount shift=0 -dtb $*/barebox.dtb; rm -f $@ $*/u-boot.image.gdb) &
	sleep 5
