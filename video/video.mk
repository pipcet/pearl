define video-gdb-bootargs
	(echo 0 set disassemble-next-line on; \
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
	 echo 500 shell echo sendkey k '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey x '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey c '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey space '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey minus '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey f '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey i '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey x '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey space '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey slash '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey b '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey o '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey o '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey t '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey slash '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey l '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey i '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey n '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey u '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey x '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey . '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey c '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey p '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey i '|' socat - unix-connect:$(2).qemu; \
	 echo 500 shell echo sendkey o '|' socat - unix-connect:$(2).qemu; \
	 echo $(or $(3),3600) echo done) > $$@
endef

define video-gdb-no-bootargs
	(echo 0 set disassemble-next-line on; \
	 echo 0 shell sleep 3; \
	 echo 0 target remote $(1); \
	 echo 0 disco; \
	 echo 0 target remote $(1); \
	 echo 100 shell echo sendkey h '|' socat - unix-connect:$(2).qemu; \
	 echo 100 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 100 shell echo sendkey l '|' socat - unix-connect:$(2).qemu; \
	 echo 100 shell echo sendkey p '|' socat - unix-connect:$(2).qemu; \
	 echo 100 shell echo sendkey ret '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey u '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey s '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey b '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey spc '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey t '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey r '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey e '|' socat - unix-connect:$(2).qemu; \
	 echo 200 shell echo sendkey ret '|' socat - unix-connect:$(2).qemu; \
	 echo $(or $(3),3600) echo done) > $$@
endef

define video-gdb-bootargs-x0
	(echo 0 set disassemble-next-line on; \
	 echo 0 shell sleep 3; \
	 echo 0 target remote $(1); \
	 echo 0 disco; \
	 echo 0 target remote $(1); \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 si; \
	 echo 0 p '$$$$x0 = 0x820000000'; \
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
	 echo 0 p '*(unsigned long *)0x8200002d8 = 0x200000000'; \
	 echo 3000 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 3000 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 3000 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 6500 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 6500 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 6500 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 6500 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey i '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey n '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey s '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey t '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey a '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey l '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey l '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey e '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey r '|' socat - unix-connect:$(2); \
	 echo 7000 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 8500 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 8600 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 8700 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 8900 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 9000 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 9100 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey down '|' socat - unix-connect:$(2); \
	 echo 9200 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 9300 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey r '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey e '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey b '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey o '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey o '|' socat - unix-connect:$(2); \
	 echo 9500 shell echo sendkey t '|' socat - unix-connect:$(2); \
	 echo 9600 shell echo sendkey ret '|' socat - unix-connect:$(2); \
	 echo $(or $(3),3600) echo done) > $$@
endef

define video-mp4
	$$(RM) -f $$@ $(1).fifo $(1).image*.txt $(1).image*.txt.pbm
	sleep 2
	rm -f $(1).fifo $(1).fifo1 $(1).fifo2
	mkfifo $(1).fifo
	mkfifo $(1).fifo1
	mkfifo $(1).fifo2
	(TICKS=0; cat $(2) | while read NEXT COMMAND; do \
	    while [ "$$$$TICKS" -lt "$$$$NEXT" ] && [ -p $(1).fifo2 ]; do \
		echo "shell cat $(1).fifo2"; \
		echo "shell echo \"screendump $(1).image.ppm\" | socat - unix-connect:$(3)"; \
		echo "pipe i reg | head -37 | tee $(1).image.txt >/dev/null"; \
		echo "pipe x/32i \$$$$pc - 64 | head -37 | tee -a $(1).image.txt >/dev/null"; \
		echo "pipe bt | head -37 | tee -a $(1).image.txt >/dev/null"; \
		echo "shell yes '' | head -100 | tee -a $(1).image.txt >/dev/null"; \
		echo "shell cat $(1).fifo1"; \
		echo "c"; \
		TICKS=$$$$(($$$$TICKS + 1)); \
	    done; \
	    echo "$$$$COMMAND"; \
	  done; \
	  echo "shell rm $(1).fifo1 $(1).fifo2"; \
	  echo "interrupt"; echo "shell sleep 1"; echo "k"; echo "q") | $(BUILD)/toolchain/install/bin/aarch64-linux-gnu-gdb &
	(while [ -p $(1).fifo1 ]; do \
	    timeout 30 sh -c 'echo > $(1).fifo2' || (rm $(1).fifo2; continue); \
	    timeout 30 sh -c 'echo > $(1).fifo1' || (rm $(1).fifo1; continue); \
	    (cat $(1).image.txt | pbmtext -builtin fixed | pnmpad -width 256 -height 1024 | pnmcut -width 256 -height 1024) > $(1).image.pbm || break; \
	    grep x27 $(1).image.txt || break; \
	    pnmpad -white -right 256 $(1).image.ppm > $(1).image.2.ppm; \
	    pnmpaste -replace $(1).image.pbm 1024 0 $(1).image.2.ppm 1>&3; \
	done) 3>&1 | ffmpeg -r 25 -i pipe:0 $$@
endef

include video/pearl-debian.mk
include video/pearl.mk
include video/barebox.mk
include video/u-boot.mk

$(BUILD)/video/%.mp4: $(BUILD)/video/%/video.mp4
	$(CP) --reflink=auto $< $@
