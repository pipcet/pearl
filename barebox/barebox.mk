build/barebox/images/barebox-dt-2nd.img: stamp/barebox | build/barebox/
	$(MAKE) -C submodule/barebox O=$(PWD)/build/barebox CROSS_COMPILE=$(CROSS_COMPILE) ARCH=arm64 oldconfig
	$(MAKE) -C submodule/barebox O=$(PWD)/build/barebox CROSS_COMPILE=$(CROSS_COMPILE) ARCH=arm64

build/barebox/barebox.dtb: build/barebox/barebox.bin

build/barebox.image.gz: build/barebox/barebox.bin
	gzip < $< > $@
