define video-mp4
	$$(RM) -f $$@ $(1).fifo $(1).image*.jpg $(1).image*.jpg.ppm $(1).image*.txt $(1).image*.txt.pbm
	sleep 5
	mkfifo $(1).fifo
	(cat $(2); for i in $$$$(seq 1 1000); do \
	    echo "shell vncsnapshot -quiet -allowblank -quality 95 :0 $(1).image.jpg"; \
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
	    jpegtopnm $(1).image.jpg > $(1).image.ppm || true; \
	    pnmpad -white -right 256 $(1).image.ppm > $(1).image.2.ppm; \
	    pnmpaste -replace $(1).image.pbm 1024 0 $(1).image.2.ppm > /dev/fd/3; \
	done) 3>&1 1>/dev/null 2>/dev/null | ffmpeg -r 10 -i pipe:0 $$@
endef

include video/video-pearl.mk
