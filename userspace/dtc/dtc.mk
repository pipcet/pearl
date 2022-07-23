$(call done,userspace/dtc,install): $(call done,userspace/dtc,build)
	$(WITH_CROSS_PATH) $(MAKE) CC=aarch64-linux-gnu-gcc PREFIX="$(BUILD)/pearl/install" CFLAGS="$(CROSS_CFLAGS)" NO_PYTHON=1 -C $(BUILD)/userspace/dtc/build install
	@touch $@

$(call done,userspace/dtc,build): $(call done,userspace/dtc,configure)
	$(WITH_CROSS_PATH) $(MAKE) PKG_CONFIG=/bin/false CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/pearl/install" LDFLAGS="$(CROSS_CFLAGS)" NO_PYTHON=1 -C $(BUILD)/userspace/dtc/build
	@touch $@

$(call done,userspace/dtc,configure): $(call done,userspace/dtc,copy) $(call done,userspace/glibc,glibc/install)
	@touch $@

$(call done,userspace/dtc,copy): $(call done,userspace/dtc,checkout) | $(call done,userspace/dtc,) $(BUILD)/userspace/dtc/build/
	$(CP) -aus $(PWD)/userspace/dtc/dtc/* $(BUILD)/userspace/dtc/build/
	@touch $@

$(call done,userspace/dtc,checkout): | $(call done,userspace/dtc,)
	$(MAKE) userspace/dtc/dtc{checkout}
	@touch $@

userspace-modules += dtc

DTC ?= dtc

$(BUILD)/%.dtb.h: $(BUILD)/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

$(BUILD)/%.dts.dtb: $(BUILD)/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@

$(BUILD)/%.dtb.dts: $(BUILD)/%.dtb
	$(DTC) -Idtb -Odts $< > $@.tmp && mv $@.tmp $@
