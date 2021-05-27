build/host/image-to-macho: macho-tools/image-to-macho.c | build/host/
	gcc -Os -Ibuild/macho-tools -o $@ $<

build/host/image-to-macho: build/macho-tools/perform-alignment..h
build/host/image-to-macho: build/macho-tools/x8r8g8b8..h
build/host/image-to-macho: build/macho-tools/enable-all-clocks..h
build/host/image-to-macho: build/macho-tools/save-boot-args..h
build/host/image-to-macho: build/macho-tools/restore-boot-args..h
build/host/image-to-macho: build/macho-tools/nop..h
