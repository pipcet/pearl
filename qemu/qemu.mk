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

%/barebox.image.gdb3: %/barebox.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234) > $@

%/u-boot.image.gdb3: %/u-boot.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234) > $@

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
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000') > $@

%/pearl.image.gdb3: %/pearl.image
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$x1 = 0x900000000'; \
	 echo p '$$x2 = ($$x4 &~0x3fff)'; \
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
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000') > $@

%.image.mpg: %.image %.image.gdb
	timeout 300 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -device ramfb &
	sleep 5
	vncsnapshot -fps 1 -count 200 :0  $*.image.jpg &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --batch --command=$*.image.gdb
	ffmpeg -i $*.image%05d.jpg -r 20 $@

%.image.mp4.old: %.image %.image.gdb3
	$(RM) -f $@ $*.image*.jpg $*.image*.jpg.ppm $*.image*.txt $*.image*.txt.pbm
	timeout 600 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --data-directory=$(PWD)/build/toolchain/binutils-gdb/source/gdb/data-directory --command=$*.image.gdb3 --batch
	(while true; do \
	    (echo "target remote localhost:1234"; \
	    echo "shell vncsnapshot -allowblank -quality 95 :0 $*.image.jpg"; \
	    echo "pipe i reg | head -37 | tee $*.image.txt 2>/dev/null"; \
	    echo "pipe x/32i \$$pc - 64 | head -37 | tee -a $*.image.txt 2>/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $*.image.txt 2>/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $*.image.txt 2>/dev/null"; \
	    echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb || break; \
	    sleep 1; \
	    (cat $*.image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $*.image.pbm || break; \
	    grep x27 $*.image.txt || break; \
	    jpegtopnm $*.image.jpg > $*.image.ppm || true; \
	    pnmpad -white -right 256 $*.image.ppm > $*.image.2.ppm; \
	    pnmpaste -replace $*.image.pbm 1024 0 $*.image.2.ppm > /dev/fd/3; \
        done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 1 -i pipe:0 $@

%.image{gdb}: %.image
	./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb &

%/barebox.image{gdb}: %/barebox.image
	QEMU_WITH_DTB=1 $(BUILD)/qemu/build/qemu-system-aarch64 -m 8196m -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb -dtb $*/barebox.dtb -icount shift=0 &

%/u-boot.image{gdb}: %/u-boot.image
	QEMU_WITH_DTB=1 $(BUILD)/qemu/build/qemu-system-aarch64 -m 8196m -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb -dtb $*/barebox.dtb -icount shift=0 &

%.image.mp4: %.image{gdb} %.image.gdb3
	$(RM) -f $@ $*.fifo $*.image*.jpg $*.image*.jpg.ppm $*.image*.txt $*.image*.txt.pbm
	sleep 5
	mkfifo $*.fifo
	(cat $*.image.gdb3; for i in $$(seq 1 1000); do \
	    echo "shell vncsnapshot -quiet -allowblank -quality 95 :0 $*.image.jpg"; \
	    echo "pipe i reg | head -37 | tee $*.image.txt >/dev/null"; \
	    echo "pipe x/32i \$$pc - 64 | head -37 | tee -a $*.image.txt >/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $*.image.txt >/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $*.image.txt >/dev/null"; \
	    echo "shell cat $*.fifo"; \
	    echo "shell (sleep .25 && kill -INT \$$PPID) &"; \
	    echo "c"; \
	  done; \
	  echo "shell rm $*.fifo"; \
	  echo "k"; echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb >/dev/null 2>/dev/null &
	(while [ -p $*.fifo ]; do \
	    timeout 10 sh -c 'echo > $*.fifo'; \
	    (cat $*.image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $*.image.pbm || break; \
	    grep x27 $*.image.txt || break; \
	    jpegtopnm $*.image.jpg > $*.image.ppm || true; \
	    pnmpad -white -right 256 $*.image.ppm > $*.image.2.ppm; \
	    pnmpaste -replace $*.image.pbm 1024 0 $*.image.2.ppm > /dev/fd/3; \
	done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 10 -i pipe:0 $@
