define video-gdb-bootargs
	(echo 0 shell echo screendump $(2).ppm '|' socat - unix-connect:$(2).qemu; \
	 echo 0 set disassemble-next-line on; \
	 echo 0 shell sleep 3; \
	 echo 0 target remote $(1); \
	 echo 0 disco; \
	 echo 0 target remote $(1); \
	 echo 0 si; \
	 echo 0 p '$$$$'x0 = 0; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 p '$$$$x1 = 0x820000000'; \
	 echo 0 p '$$$$x2 = ($$$$x4 &~0x3fff)'; \
	 echo 0 p '*(unsigned long *)0x820000008 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x820000010 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x820000018 = 0x1d0000000'; \
	 echo 0 p '*(unsigned long *)0x820000020 = 0x830000000'; \
	 echo 0 p '*(unsigned long *)0x820000028 = 0xa00000000'; \
	 echo 0 p '*(unsigned long *)0x820000030 = 0'; \
	 echo 0 p '*(unsigned long *)0x820000038 = 4096'; \
	 echo 0 p '*(unsigned long *)0x820000040 = 1024'; \
	 echo 0 p '*(unsigned long *)0x820000048 = 1024'; \
	 echo 0 p '*(unsigned long *)0x820000050 = 32'; \
	 echo 0 p '*(unsigned long *)0x820000060 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x820000068 = 0'; \
	 echo 0 p '*(unsigned long *)0x8200002d8 = 0x200600000'; \
	 echo 500 shell echo sendkey down '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey down '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey down '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey ret '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey d '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey b '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey i '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey a '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey n '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey ret '|' socat - unix-connect:$(2).qemu; \
	 echo 1500 echo done) > $$@
endef

define video-gdb-bootargs-x0
	(echo 0 shell echo screendump $(1).image.ppm '|' socat - unix-connect:$$(3); \
	 echo 0 set disassemble-next-line on; \
	 echo 0 shell sleep 3; \
	 echo 0 target remote $(1); \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 p '$$$$x0 = 0x900000000'; \
	 echo 0 p '*(unsigned long *)0x900000008 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x900000010 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x900000018 = 0x200000000'; \
	 echo 0 p '*(unsigned long *)0x900000020 = 0x820000000'; \
	 echo 0 p '*(unsigned long *)0x900000028 = 0xa00000000'; \
	 echo 0 p '*(unsigned long *)0x900000030 = 0'; \
	 echo 0 p '*(unsigned long *)0x900000038 = 4096'; \
	 echo 0 p '*(unsigned long *)0x900000040 = 1024'; \
	 echo 0 p '*(unsigned long *)0x900000048 = 1024'; \
	 echo 0 p '*(unsigned long *)0x900000050 = 32'; \
	 echo 0 p '*(unsigned long *)0x900000060 = 0x800000000'; \
	 echo 0 p '*(unsigned long *)0x900000068 = 0'; \
	 echo 0 p '*(unsigned long *)0x9000002d8 = 0x200000000'; \
	 echo 1500 echo done) > $$@
endef

define video-mp4
	$$(RM) -f $$@ $(1).fifo $(1).image*.jpg $(1).image*.jpg.ppm $(1).image*.txt $(1).image*.txt.pbm
	sleep 5
	mkfifo $(1).fifo
	(TICKS=0; cat $(2) | while read NEXT COMMAND; do \
	    echo "$$$$NEXT $$$$TICKS $$$$COMMAND" > /dev/stderr; \
	    while [ "$$$$TICKS" -lt "$$$$NEXT" ]; do \
		echo "shell echo \"screendump $(1).image.ppm\" | socat - unix-connect:$(3)"; \
		echo "pipe i reg | head -37 | tee $(1).image.txt >/dev/null"; \
		echo "pipe x/32i \$$$$pc - 64 | head -37 | tee -a $(1).image.txt >/dev/null"; \
		echo "pipe bt | head -37 | tee -a $(1).image.txt >/dev/null"; \
		echo "shell yes '' | head -100 | tee -a $(1).image.txt >/dev/null"; \
		echo "shell cat $(1).fifo"; \
		echo "c"; \
		TICKS=$$$$(($$$$TICKS + 1)); \
	    done; \
	    echo "$$$$COMMAND"; \
	    echo "$$$$COMMAND" > /dev/stderr; \
	  done; \
	  echo "shell rm $(1).fifo"; \
	  echo "interrupt"; echo "shell sleep 1"; echo "k"; echo "q") | tee | ./build/toolchain/binutils-gdb/source/gdb/gdb &
	(while [ -p $(1).fifo ]; do \
	    timeout 10 sh -c 'echo > $(1).fifo' || continue; \
	    (cat $(1).image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $(1).image.pbm || break; \
	    grep x27 $(1).image.txt || break; \
	    pnmpad -white -right 256 $(1).image.ppm > $(1).image.2.ppm; \
	    pnmpaste -replace $(1).image.pbm 1024 0 $(1).image.2.ppm > /dev/fd/3; \
	done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 10 -i pipe:0 $$@
endef

include video/pearl-debian.mk
include video/pearl.mk
include video/barebox.mk
include video/u-boot.mk

$(BUILD)/video/%.mp4: $(BUILD)/video/%/video.mp4
	$(CP) --reflink=auto $< $@

