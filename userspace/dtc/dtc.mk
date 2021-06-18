$(BUILD)/dtc/done/install: $(BUILD)/dtc/done/build
	$(MAKE) CC=aarch64-linux-gnu-gcc PREFIX="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/dtc/build install
	@touch $@

$(BUILD)/dtc/done/build: $(BUILD)/dtc/done/configure
	$(MAKE) PKG_CONFIG=/bin/false CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" LDFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/dtc/build
	@touch $@

$(BUILD)/dtc/done/configure: $(BUILD)/dtc/done/copy
	@touch $@

$(BUILD)/dtc/done/copy: $(BUILD)/dtc/done/checkout | $(BUILD)/dtc/done/ $(BUILD)/dtc/build/
	cp -a userspace/dtc/dtc/* $(BUILD)/dtc/build/
	@touch $@

$(BUILD)/dtc/done/checkout: userspace/dtc/dtc{checkout} | $(BUILD)/dtc/done/
	@touch $@

DTC ?= dtc

build/%.dtb.h: build/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/%.dts.dtb: build/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@

build/%.dtb.dts: build/%.dtb
	$(DTC) -Idtb -Odts $< > $@.tmp && mv $@.tmp $@
