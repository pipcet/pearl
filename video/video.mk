define video-gdb-bootargs
	(echo set disassemble-next-line on; \
	 echo target remote $(1); \
	 echo si; \
	 echo p '$$$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$$$x1 = 0x900000000'; \
	 echo p '$$$$x2 = ($$$$x4 &~0x3fff)'; \
	 echo p '*(unsigned long *)0x900000008 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000010 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000018 = 0x200000000'; \
	 echo p '*(unsigned long *)0x900000020 = 0x820000000'; \
	 echo p '*(unsigned long *)0x900000028 = 0xa00000000'; \
	 echo p '*(unsigned long *)0x900000030 = 0'; \
	 echo p '*(unsigned long *)0x900000038 = 4096'; \
	 echo p '*(unsigned long *)0x900000040 = 1024'; \
	 echo p '*(unsigned long *)0x900000048 = 1024'; \
	 echo p '*(unsigned long *)0x900000050 = 32'; \
	 echo p '*(unsigned long *)0x900000060 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000068 = 0'; \
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000') > $$@
endef

define video-gdb-bootargs-x0
	(echo set disassemble-next-line on; \
	 echo target remote $(1); \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$$$x0 = 0x900000000'; \
	 echo p '*(unsigned long *)0x900000008 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000010 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000018 = 0x200000000'; \
	 echo p '*(unsigned long *)0x900000020 = 0x820000000'; \
	 echo p '*(unsigned long *)0x900000028 = 0xa00000000'; \
	 echo p '*(unsigned long *)0x900000030 = 0'; \
	 echo p '*(unsigned long *)0x900000038 = 4096'; \
	 echo p '*(unsigned long *)0x900000040 = 1024'; \
	 echo p '*(unsigned long *)0x900000048 = 1024'; \
	 echo p '*(unsigned long *)0x900000050 = 32'; \
	 echo p '*(unsigned long *)0x900000060 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000068 = 0'; \
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000') > $$@
endef

define video-mp4
	$$(RM) -f $$@ $(1).fifo $(1).image*.jpg $(1).image*.jpg.ppm $(1).image*.txt $(1).image*.txt.pbm
	sleep 5
	mkfifo $(1).fifo
	(echo "shell echo \"screendump $(1).image.ppm\" | socat - unix-connect:$(3)"; \
         cat $(2); \
	 for i in $$$$(seq 1 1000); do \
	    echo "shell echo \"screendump $(1).image.ppm\" | socat - unix-connect:$(3)"; \
	    echo "pipe i reg | head -37 | tee $(1).image.txt >/dev/null"; \
	    echo "pipe x/32i \$$$$pc - 64 | head -37 | tee -a $(1).image.txt >/dev/null"; \
	    echo "pipe bt | head -37 | tee -a $(1).image.txt >/dev/null"; \
	    echo "shell yes '' | head -100 | tee -a $(1).image.txt >/dev/null"; \
	    echo "shell cat $(1).fifo"; \
	    echo "shell (sleep .25 && kill -INT \$$$$PPID) &"; \
	    echo "c"; \
	  done; \
	  echo "shell rm $(1).fifo"; \
	  echo "k"; echo "q") | ./build/toolchain/binutils-gdb/source/gdb/gdb >/dev/null 2>/dev/null &
	(while [ -p $(1).fifo ]; do \
	    timeout 10 sh -c 'echo > $(1).fifo'; \
	    (cat $(1).image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $(1).image.pbm || break; \
	    grep x27 $(1).image.txt || break; \
	    pnmpad -white -right 256 $(1).image.ppm > $(1).image.2.ppm; \
	    pnmpaste -replace $(1).image.pbm 1024 0 $(1).image.2.ppm > /dev/fd/3; \
	done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 10 -i pipe:0 $$@
endef

include video/video-pearl.mk
