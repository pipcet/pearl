barebox/barebox{menuconfig}: barebox/barebox.config stamp/barebox | build/barebox/
	$(CP) $< build/barebox/.config
	$(MAKE) -C submodule/barebox O=$(PWD)/build/barebox ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) build/barebox/.config $<

barebox/barebox{oldconfig}: barebox/barebox.config stamp/barebox | build/barebox/
	$(CP) $< build/barebox/.config
	$(MAKE) -C submodule/barebox O=$(PWD)/build/barebox oldconfig ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE)
	$(CP) build/barebox/.config $<

build/barebox/images/barebox-dt-2nd.img: barebox/barebox.config stamp/barebox | build/barebox/
	$(CP) $< build/barebox/.config
	$(MAKE) -C submodule/barebox O=$(PWD)/build/barebox CROSS_COMPILE=$(CROSS_COMPILE) ARCH=arm64

build/barebox/barebox.dtb: build/barebox/barebox.bin

build/barebox.image.gz: build/barebox/barebox.bin
	gzip < $< > $@
