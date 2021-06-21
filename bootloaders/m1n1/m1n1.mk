M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -2 | head -1)

$(BUILD)/m1n1.macho: $(BUILD)/m1n1/done/build
	$(CP) $(BUILD)/m1n1/build/build/m1n1.macho $@

$(BUILD)/m1n1/done/build: $(BUILD)/m1n1/done/copy
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/m1n1/build build/m1n1.macho
	@touch $@

$(BUILD)/m1n1/done/copy: $(BUILD)/m1n1/done/checkout | $(BUILD)/m1n1/done/ $(BUILD)/m1n1/build/
	$(CP) -aus $(PWD)/bootloaders/m1n1/m1n1/* $(BUILD)/m1n1/build/
	@touch $@

$(BUILD)/m1n1/done/checkout: | $(BUILD)/m1n1/done/
	$(MAKE) bootloaders/m1n1/m1n1{checkout}
	@touch $@

build/m1n1.macho: stamp/m1n1
	$(MAKE) -C submodule/m1n1
	$(CP) submodule/m1n1/build/m1n1.macho $@

%.macho{m1n1}: %.macho
	M1N1DEVICE=$(M1N1DEVICE) python3 ./submodule/m1n1/proxyclient/chainload.py $<

{m1n1}:
	M1N1DEVICE=$(M1N1DEVICE) python3 ./submodule/m1n1/proxyclient/shell.py
