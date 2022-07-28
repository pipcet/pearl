$(call done,qemu,build): $(call done,qemu,configure)
	$(MAKE) -C $(BUILD)/qemu
	$(TIMESTAMP)

$(call done,qemu,configure): $(call done,qemu,copy)
	(cd $(BUILD)/qemu; ./configure --target-list=aarch64-softmmu)
	$(TIMESTAMP)

$(call done,qemu,copy): $(call done,qemu,checkout) | $(BUILD)/qemu/
	$(COPY_SAUNA) $(PWD)/qemu/qemu/* $(BUILD)/qemu/
	$(TIMESTAMP)

$(call done,qemu,checkout): $(call done,qemu,)
	$(MAKE) qemu/qemu{checkout}
	$(TIMESTAMP)

%.image.gdb: %.image
	(echo file ./build/linux/pearl/build/vmlinux; \
	 echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo p '$$'x1 = 0x900000000; \
	 echo p '$$'x2 = 0x800000000; \
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
	 echo b machine_kexec; \
	 echo p '*'0x8008f0004 = 0xd503201f; \
	 echo command 1; \
	 echo k; \
	 echo q; \
	 echo end; \
	 echo c) > $@

%.image.gdb2: %.image
	(echo file ./build/linux/pearl/build/vmlinux; \
	 echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo p '$$'x1 = 0x900000000; \
	 echo p '$$'x2 = 0x800000000; \
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
	 echo b machine_kexec; \
	 echo p '*'0x8008f0004 = 0xd503201f; \
	 echo q) > $@

%.image.gdb3: %.image
	(echo file ./build/linux/pearl/build/vmlinux; \
	 echo set disassemble-next-line on; \
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

%.image.mpg: %.image %.image.gdb
	timeout 300 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -device ramfb &
	sleep 5
	vncsnapshot -fps 1 -count 200 :1  $*.image.jpg &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --batch --command=$*.image.gdb
	ffmpeg -i $*.image%05d.jpg -r 20 $@

%.image.mp4: %.image %.image.gdb3
	$(RM) -f $@ $*.image*.jpg $*.image*.jpg.ppm $*.image*.txt $*.image*.txt.pbm
	timeout 900 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -device ramfb &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --command=$*.image.gdb3 --batch
	for i in $$(seq 1 600); do \
	    sleep 1; \
	    (echo "target remote localhost:1234"; \
	    echo "shell vncsnapshot -allowblank :1 $*.image$$(printf %05d $$i).jpg"; \
	    echo "pipe i reg | head -37 | tee $*.image$$(printf %05d $$i).txt 2>/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $*.image$$(printf %05d $$i).txt 2>/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $*.image$$(printf %05d $$i).txt 2>/dev/null"; \
	    echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb || break; \
        done
	for a in $*.image*.txt; do (pbmtext -width 256 -builtin fixed | pamcut -height 1024) < $$a > $$a.pbm; rm $$a; done || true
	i=1; while [ -e $*.image$$(printf %05d $$i).jpg ]; do \
	    jpegtopnm $*.image$$(printf %05d $$i).jpg > $*.image$$(printf %05d $$i).jpg.ppm; done || true
	    pnmpad -white -right 256 $*.image$$(printf %05d $$i).jpg.ppm > $*.image$$(printf %05d $$i).ppm; \
	    pnmpaste -replace $*.image$$(printf %05d $$i).txt.pbm 1024 0 $*.image$$(printf %05d $$i).ppm | pnmtojpeg -quality=95 > $*.image$$(printf %05d $$i).jpg; \
	    rm $*.image$$(printf %05d $$i).txt.pbm $*.image$$(printf %05d $$i).jpg.ppm $*.image$$(printf %05d $$i).ppm; \
	    i=$$(($$i+1)); \
	done
	ffmpeg -r 1 -i $*.image%05d.jpg $@
