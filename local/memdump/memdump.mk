build/memdump/bin/macho-to-memdump: local/memdump/macho-to-memdump | build/memdump/bin/ ; $(COPY)
build/memdump/bin/memdump-to-image: local/memdump/memdump-to-image.c | build/memdump/bin/
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(CROSS_CC) -static -Os -Ibuild/local/memdump -o $@ $<

build/memdump/bin/memdump-to-image: build/local/memdump/boot..h
build/memdump/bin/memdump-to-image: build/local/memdump/image..h

$(call pearl-static,build/memdump/bin/memdump-to-image build/memdump/bin/macho-to-memdump,build/memdump)
