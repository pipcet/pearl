%.dts.h: %.dts local/dtc-relocs/dtc-relocs | builder/packages/libipc-run-perl{} builder/packages/libfile-slurp-perl{}
	gcc -E -x assembler-with-cpp -nostdinc $< | local/dtc-relocs/dtc-relocs > $@
