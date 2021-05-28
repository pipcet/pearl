M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -1)

%.macho{m1n1}: %.macho
	M1N1DEVICE=$(M1N1DEVICE) python3 ./submodule/m1n1/proxyclient/chainload.py --sepfw $<
