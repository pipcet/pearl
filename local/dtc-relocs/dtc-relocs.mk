%.dts.h: %.dts local/dtc-relocs/dtc-relocs
	$(CC) -E -x assembler-with-cpp -nostdinc $< | local/dtc-relocs/dtc-relocs > $@
