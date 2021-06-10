images += pearl
linux-images += pearl

build/images/pearl/pearl.image: | build/images/pearl/
build/images/pearl/pearl.image: build/packs/pearl.cpio

build/images/pearl/pearl.image: build/images/pearl/pearl.dts.h

build/images/pearl/pearl.dts: images/pearl/pearl.dts ; $(COPY)
