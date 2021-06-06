images += pearl
linux-images += pearl

build/images/pearl/pearl.image: | build/images/pearl/
build/images/pearl/pearl.image: build/packs/pearl.cpio

build/images/pearl/pearl.image: build/images/pearl/pearl.dts.dtb.h

build/images/pearl/pearl.dts: images/pearl/pearl.dts ; $(COPY)
