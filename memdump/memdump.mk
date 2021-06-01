build/host/macho-to-memdump: memdump/macho-to-memdump ; $(COPY)
build/memdump/memdump-to-image: memdump/memdump-to-image.c | build/memdump/
	gcc -Os -Ibuild/macho-tools -o $@ $<
