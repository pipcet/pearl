build/memdump/macho-to-memdump: memdump/macho-to-memdump ; $(COPY)
build/memdump/memdump-to-image: memdump/memdump-to-image.c | build/memdump/
	$(CROSS_COMPILE)gcc -static -Os -Ibuild/memdump -o $@ $<

build/memdump/memdump-to-image: build/memdump/boot..h
build/memdump/memdump-to-image: build/memdump/image..h
