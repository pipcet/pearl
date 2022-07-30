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

%.image.mpg: %.image %.image.gdb
	timeout 300 ./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -device ramfb &
	sleep 5
	vncsnapshot -fps 1 -count 200 :1  $*.image.jpg &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --batch --command=$*.image.gdb
	ffmpeg -i $*.image%05d.jpg -r 20 $@

%/barebox.image.mp4: %/barebox.image %/barebox.image.gdb3
	$(RM) -f $@ $*/barebox.image*.jpg $*/barebox.image*.jpg.ppm $*/barebox.image*.txt $*/barebox.image*.txt.pbm
	QEMU_WITH_DTB=1 timeout 60 ./build/qemu/build/qemu-system-aarch64 -m 8196m -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb -dtb $*/barebox.dtb -icount shift=0 &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --data-directory=$(PWD)/build/toolchain/binutils-gdb/source/gdb/data-directory --command=$*/barebox.image.gdb3 --batch
	(while true; do \
	    (echo "target remote localhost:1234"; \
	    echo "shell vncsnapshot -allowblank -quality 95 :0 $*/barebox.image.jpg"; \
	    echo "pipe i reg | head -37 | tee $*/barebox.image.txt 2>/dev/null"; \
	    echo "pipe x/32i \$$pc - 64 | head -37 | tee -a $*/barebox.image.txt 2>/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $*/barebox.image.txt 2>/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $*/barebox.image.txt 2>/dev/null"; \
	    echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb || break; \
	    sleep 1; \
	    (cat $*/barebox.image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $*/barebox.image.pbm || break; \
	    grep x27 $*/barebox.image.txt || break; \
	    jpegtopnm $*/barebox.image.jpg > $*/barebox.image.ppm || true; \
	    pnmpad -white -right 256 $*/barebox.image.ppm > $*/barebox.image.2.ppm; \
	    pnmpaste -replace $*/barebox.image.pbm 1024 0 $*/barebox.image.2.ppm > /dev/fd/3; \
        done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 1 -i pipe:0 $@

%/u-boot.image.mp4: %/u-boot.image %/u-boot.image.gdb3
	$(RM) -f $@ $*/u-boot.image*.jpg $*/u-boot.image*.jpg.ppm $*/u-boot.image*.txt $*/u-boot.image*.txt.pbm
	QEMU_WITH_DTB=1 timeout 60 ./build/qemu/build/qemu-system-aarch64 -m 8196m -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb -dtb $*/barebox.dtb -icount shift=0 &
	sleep 5
	./build/toolchain/binutils-gdb/source/gdb/gdb --data-directory=$(PWD)/build/toolchain/binutils-gdb/source/gdb/data-directory --command=$*/u-boot.image.gdb3 --batch
	(while true; do \
	    (echo "target remote localhost:1234"; \
	    echo "shell vncsnapshot -allowblank -quality 95 :0 $*/u-boot.image.jpg"; \
	    echo "pipe i reg | head -37 | tee $*/u-boot.image.txt 2>/dev/null"; \
	    echo "pipe x/32i \$$pc - 64 | head -37 | tee -a $*/u-boot.image.txt 2>/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $*/u-boot.image.txt 2>/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $*/u-boot.image.txt 2>/dev/null"; \
	    echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb || break; \
	    sleep 1; \
	    (cat $*/u-boot.image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $*/u-boot.image.pbm || break; \
	    grep x27 $*/u-boot.image.txt || break; \
	    jpegtopnm $*/u-boot.image.jpg > $*/u-boot.image.ppm || true; \
	    pnmpad -white -right 256 $*/u-boot.image.ppm > $*/u-boot.image.2.ppm; \
	    pnmpaste -replace $*/u-boot.image.pbm 1024 0 $*/u-boot.image.2.ppm > /dev/fd/3; \
        done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 1 -i pipe:0 $@

%.image.mp4: %.image %.image.gdb3
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

%.image.qemu: %.image
	(./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -d unimp -device ramfb -device qemu-xhci -monitor unix:$@,server -chardev socket,path=$*.image.gdb,server=on,wait=on,id=gdb0 -gdb chardev:gdb0; rm $@) &
	sleep 5

%.image{qemu2}: %.image
	./build/qemu/build/qemu-system-aarch64 -m 12g -cpu max -machine virt -kernel $< -S -s -d unimp -device ramfb -device qemu-xhci -monitor unix:$*.socket,server &
	sleep 5
	echo "info vnc" | socat - unix-connect:$*.socket > $*.vncinfo

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
