build/memdump/macho-to-memdump: local/memdump/macho-to-memdump ; $(COPY)
build/memdump/memdump-to-image: local/memdump/memdump-to-image.c | build/memdump/
	$(WITH_CROSS_PATH) $(WITH_CROSS_CC) $(CROSS_CC) -static -Os -Ibuild/local/memdump -o $@ $<

build/memdump/memdump-to-image: build/local/memdump/boot..h
build/memdump/memdump-to-image: build/local/memdump/image..h

$(call pearl-static,build/memdump/memdump-to-image build/memdump/macho-to-memdump,$(BUILD)/memdump)
