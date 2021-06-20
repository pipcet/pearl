%.dts.h: %.dts local/dtc-relocs/dtc-relocs
	gcc -E -x assembler-with-cpp -nostdinc $< | local/dtc-relocs/dtc-relocs > $@
