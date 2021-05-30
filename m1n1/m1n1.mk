M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -1)

build/m1n1.macho: stamp/m1n1
	$(MAKE) -C submodule/m1n1
	$(CP) submodule/m1n1/build/m1n1.macho $@

%.macho{m1n1}: %.macho
	M1N1DEVICE=$(M1N1DEVICE) python3 ./submodule/m1n1/proxyclient/chainload.py $<
