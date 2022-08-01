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

%/barebox.image.gdb3: %/barebox.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo q) > $@

%/u-boot.image.gdb3: %/u-boot.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo q) > $@

%.image.gdb3: %.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$'x0 = 0x900000000; \
	 echo p '*(unsigned long *)0x900000008 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000010 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000018 = 0x200000000'; \
	 echo p '*(unsigned long *)0x900000020 = 0x900000000'; \
	 echo p '*(unsigned long *)0x900000028 = 0xa00000000'; \
	 echo p '*(unsigned long *)0x900000030 = 0'; \
	 echo p '*(unsigned long *)0x900000038 = 4096'; \
	 echo p '*(unsigned long *)0x900000040 = 1024'; \
	 echo p '*(unsigned long *)0x900000048 = 1024'; \
	 echo p '*(unsigned long *)0x900000050 = 32'; \
	 echo p '*(unsigned long *)0x900000060 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000068 = 0'; \
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000'; \
	 echo q) > $@

%.image{gdb}: %.image
	./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb &

%.image.qemu: %.image
	(./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -d unimp -device ramfb -monitor unix:$@,server,wait=off -chardev socket,path=$*.image.gdb,server=on,wait=on,id=gdb0 -gdb chardev:gdb0 -device usb-kbd -icount shift=0; rm -f $@ $*.image.gdb) &
	sleep 5

%/barebox.image.qemu: %/barebox.image %/barebox.dtb
	QEMU_WITH_DTB=1 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -dtb $*/barebox.dtb -S -s -d unimp -device ramfb -device qemu-xhci -monitor unix:$*.socket,server &

%/u-boot.image.qemu: %/u-boot.image %/barebox.dtb
	QEMU_WITH_DTB=1 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -dtb $*/barebox.dtb -S -s -d unimp -device ramfb -device qemu-xhci -monitor unix:$*.socket,server &
