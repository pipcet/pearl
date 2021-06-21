$(BUILD)/dtc/done/install: $(BUILD)/dtc/done/build
	$(WITH_CROSS_PATH) $(MAKE) CC=aarch64-linux-gnu-gcc PREFIX="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)" NO_PYTHON=1 -C $(BUILD)/dtc/build install
	@touch $@

$(BUILD)/dtc/done/build: $(BUILD)/dtc/done/configure
	$(WITH_CROSS_PATH) $(MAKE) PKG_CONFIG=/bin/false CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" LDFLAGS="$(CROSS_CFLAGS)" NO_PYTHON=1 -C $(BUILD)/dtc/build
	@touch $@

$(BUILD)/dtc/done/configure: $(BUILD)/dtc/done/copy $(BUILD)/glibc/done/glibc/install
	@touch $@

$(BUILD)/dtc/done/copy: $(BUILD)/dtc/done/checkout | $(BUILD)/dtc/done/ $(BUILD)/dtc/build/
	$(CP) -aus userspace/dtc/dtc/* $(BUILD)/dtc/build/
	@touch $@

$(BUILD)/dtc/done/checkout: userspace/dtc/dtc{checkout} | $(BUILD)/dtc/done/
	@touch $@

userspace-modules += dtc

DTC ?= dtc

build/%.dtb.h: build/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/%.dts.dtb: build/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@

build/%.dtb.dts: build/%.dtb
	$(DTC) -Idtb -Odts $< > $@.tmp && mv $@.tmp $@
