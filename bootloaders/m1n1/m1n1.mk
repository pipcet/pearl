M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -2 | head -1)

$(BUILD)/bootloaders/m1n1.macho: $(BUILD)/bootloaders/m1n1/done/build
	$(CP) $(BUILD)/bootloaders/m1n1/build/build/m1n1.macho $@

$(BUILD)/bootloaders/m1n1/done/install: $(BUILD)/bootloaders/m1n1/done/build
	$(TIMESTAMP)

$(BUILD)/bootloaders/m1n1/done/build: $(BUILD)/bootloaders/m1n1/done/copy $(BUILD)/gcc/done/gcc/install
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/bootloaders/m1n1/build build/bootloaders/m1n1.macho
	$(TIMESTAMP)

$(BUILD)/bootloaders/m1n1/done/copy: $(BUILD)/bootloaders/m1n1/done/checkout | $(BUILD)/bootloaders/m1n1/done/ $(BUILD)/bootloaders/m1n1/build/
	$(CP) -aus $(PWD)/bootloaders/bootloaders/m1n1/m1n1/* $(BUILD)/bootloaders/m1n1/build/
	$(TIMESTAMP)

$(BUILD)/bootloaders/m1n1/done/checkout: | $(BUILD)/bootloaders/m1n1/done/
	$(MAKE) bootloaders/bootloaders/m1n1/m1n1{checkout}
	$(TIMESTAMP)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/m1n1.macho
$(BUILD)/initramfs/pearl/boot/m1n1.macho: $(BUILD)/bootloaders/m1n1.macho ; $(COPY)

SECTARGETS += $(BUILD)/initramfs/pearl/boot/m1n1.macho
SECTARGETS += $(BUILD)/bootloaders/m1n1.macho
SECTARGETS += $(BUILD)/bootloaders/m1n1/done/build

$(call pearl-static,bootloaders/m1n1/pearl/bin/m1n1,bootloaders/m1n1/pearl)

%.macho{m1n1}: %.macho
	M1N1DEVICE=$(M1N1DEVICE) python3 ./bootloaders/m1n1/m1n1/proxyclient/tools/chainload.py $<

{m1n1}:
	(cd bootloaders/m1n1/m1n1/proxyclient; M1N1DEVICE=$(M1N1DEVICE) python3 -m m1n1.shell)

$(BUILD)/m1n1-chickens.S: $(BUILD)/bootloaders/m1n1/done/install
	cat bootloaders/m1n1/m1n1/src/chickens_blizzard.c bootloaders/m1n1/m1n1/src/chickens_avalanche.c bootloaders/m1n1/m1n1/src/chickens_firestorm.c bootloaders/m1n1/m1n1/src/chickens_icestorm.c bootloaders/m1n1/m1n1/src/chickens.c  | $(CROSS_COMPILE)gcc -I$(BUILD)/bootloaders/m1n1/build/src -x c -finline -finline-functions -finline-limit=1000000000 -O3 -S -o $@ -
