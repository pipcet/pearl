kernels = linux stage2 pearl

SECTARGETS += $(call done,linux,linux/configure)
SECTARGETS += $(call done,linux,linux/build)
SECTARGETS += $(BUILD)/linux/pearl.cpio
SECTARGETS += $(BUILD)/linux/linux.image
SECTARGETS += $(BUILD)/linux/linux.modules
SECTARGETS += $(BUILD)/linux/stage2.image
SECTARGETS += $(BUILD)/linux/stage2.modules
SECTARGETS += $(BUILD)/linux/pearl.image
SECTARGETS += $(BUILD)/linux/pearl.modules

$(BUILD)/linux/%.config: linux/%.config ; $(COPY)

$(BUILD)/linux/debian.config: linux/pearl.config
	sed -e 's/pearl\.cpio/debian.cpio/g' < $< > $@

ifeq ($(filter pearl.image,$(ARTIFACTS)),)
$(BUILD)/linux/pearl.image: $(call done,linux,pearl/build) | $(BUILD)/linux/pearl.config
	$(CP) --reflink=auto $(BUILD)/linux/pearl/build/arch/arm64/boot/Image $@

$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/pearl.image: $(BUILD)/linux/pearl.cpio
else
$(BUILD)/linux/pearl.image: $(BUILD)/artifacts/pearl.image/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/pearl.image > $@
endif

ifeq ($(filter stage2.image.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/stage2.image: $(call done,linux,stage2/build) | $(BUILD)/linux/stage2.config
	$(CP) --reflink=auto $(BUILD)/linux/stage2/build/arch/arm64/boot/Image $@
else
$(BUILD)/linux/stage2.image: $(BUILD)/artifacts/stage2.image.zstd/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/stage2.image.zstd > $@
endif

ifeq ($(filter linux.image.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/linux.image: $(call done,linux,linux/build) | $(BUILD)/linux/linux.config
	$(CP) --reflink=auto $(BUILD)/linux/linux/build/arch/arm64/boot/Image $@
else
$(BUILD)/linux/linux.image: $(BUILD)/artifacts/linux.image.zstd/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/linux.image.zstd > $@
endif

$(BUILD)/linux/linux.image.d/sendfile: $(BUILD)/linux/linux.image | $(BUILD)/linux/linux.image.d/
	echo "#!/bin/sh" > $@
	echo "cp linux.dtb persist" >> $@
	echo "cp linux.dtb boot" >> $@
	echo "cp linux.modules persist" >> $@
	echo "cp linux.modules boot" >> $@
	echo "echo shell > persist/stage" >> $@
	echo "egrep -v persist < /file.list > /file.list.new" >> $@
	echo "mv /file.list.new /file.list" >> $@
	echo "echo final > /persist/stage" >> $@
	echo "echo root > /persist/substages" >> $@
	echo "find persist >> /file.list" >> $@
	echo "cat /file.list | cpio -H newc -o > /boot/linux.cpio" >> $@
	echo "dt dtb-to-dtp /boot/linux.dtb /boot/linux.dtp" >> $@
	echo "cat /boot/resmem.dtp >> /boot/linux.dtp" >> $@
	echo "cat /boot/bootargs.dtp >> /boot/linux.dtp" >> $@
	echo "cat /boot/tunables.dtp >> /boot/linux.dtp" >> $@
	echo "dt permallocs >> /boot/linux.dtp" >> $@
	echo "dt dtp-to-dtb /boot/linux.dtp /boot/linux.dtb" >> $@
	echo "/bin/kexec --mem-min=\`dt mem-min\` -fix linux.image --dtb=/boot/linux.dtb --ramdisk=/boot/linux.cpio --command-line=\"clk_ignore_unused\"" >> $@
	chmod u+x $@

$(BUILD)/linux/stage2.image.d/sendfile: $(BUILD)/linux/linux.image | $(BUILD)/linux/stage2.image.d/
	echo "#!/bin/sh" > $@
	echo "cp stage2.modules /boot" >> $@
	echo "cp stage2.modules /persist" >> $@
	echo "echo stage2 > persist/stage" >> $@
	echo "egrep -v persist < /file.list > /file.list.new" >> $@
	echo "mv /file.list.new /file.list" >> $@
	echo "find persist >> /file.list" >> $@
	echo "cat /file.list | cpio -H newc -o > /boot/linux.cpio" >> $@
	echo "/bin/kexec -fix stage2.image --dtb=/boot/stage2.dtb --ramdisk=/boot/linux.cpio --command-line=\"clk_ignore_unused\"" >> $@
	chmod u+x $@

$(BUILD)/linux/stage2.image.sendfile: $(BUILD)/linux/stage2.modules

$(BUILD)/linux/%.macho.d/sendfile: $(BUILD)/linux/%.macho | $(BUILD)/linux/%.macho.d/
	echo "#!/bin/sh" > $@
	echo "macho-to-memdump $*.macho" >> $@
	echo "kexec --mem-min=0x900000000 -fix image" >> $@
	chmod u+x $@

$(BUILD)/pearl-debian.macho.d/sendfile: $(BUILD)/pearl-debian.macho | $(BUILD)/pearl-debian.macho.d/
	echo "#!/bin/sh" > $@
	echo "macho-to-memdump pearl-debian.macho" >> $@
	echo "kexec --mem-min=0x900000000 -fix image" >> $@
	chmod u+x $@

$(BUILD)/linux/%.image.d/sendfile: $(BUILD)/linux/%.image | $(BUILD)/linux/%.image.d/
	echo "#!/bin/sh" > $@
	echo "kexec --mem-min=0x900000000 -fix $*.image --dtb=/sys/firmware/fdt" >> $@
	chmod u+x $@

ifeq ($(filter linux.dtbs.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/linux.dtb: | $(call done,linux,linux/build) $(BUILD)/linux/linux.config
	$(CP) $(BUILD)/linux/linux/build/arch/arm64/boot/dts/apple/t8103-j293.dtb $@

$(BUILD)/linux/linux-j313.dtb: | $(call done,linux,linux/build) $(BUILD)/linux/linux.config
	$(CP) $(BUILD)/linux/linux/build/arch/arm64/boot/dts/apple/t8103-j313.dtb $@

$(BUILD)/linux/linux-j293.dtb: | $(call done,linux,linux/build) $(BUILD)/linux/linux.config
	$(CP) $(BUILD)/linux/linux/build/arch/arm64/boot/dts/apple/t8103-j293.dtb $@

$(BUILD)/linux/linux-j274.dtb: | $(call done,linux,linux/build) $(BUILD)/linux/linux.config
	$(CP) $(BUILD)/linux/linux/build/arch/arm64/boot/dts/apple/t8103-j274.dtb $@

$(BUILD)/linux/linux.dtbs: $(BUILD)/linux/linux.dtb $(BUILD)/linux/linux-j313.dtb $(BUILD)/linux/linux-j293.dtb $(BUILD)/linux/linux-j274.dtb
	tar -C . -cvf $@ $(patsubst $(PWD)/%,%,$^)
else
$(BUILD)/linux/linux.dtb: $(BUILD)/artifacts/linux.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/linux-j313.dtb: $(BUILD)/artifacts/linux.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/linux-j293.dtb: $(BUILD)/artifacts/linux.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/linux-j274.dtb: $(BUILD)/artifacts/linux.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
endif

ifeq ($(filter stage2.dtbs.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/stage2.dtb: | $(call done,linux,stage2/build) $(BUILD)/linux/stage2.config
	$(CP) $(BUILD)/linux/stage2/build/arch/arm64/boot/dts/apple/t8103-j293.dtb $@

$(BUILD)/linux/stage2-j313.dtb: | $(call done,linux,stage2/build) $(BUILD)/linux/stage2.config
	$(CP) $(BUILD)/linux/stage2/build/arch/arm64/boot/dts/apple/t8103-j313.dtb $@

$(BUILD)/linux/stage2-j293.dtb: | $(call done,linux,stage2/build) $(BUILD)/linux/stage2.config
	$(CP) $(BUILD)/linux/stage2/build/arch/arm64/boot/dts/apple/t8103-j293.dtb $@

$(BUILD)/linux/stage2-j274.dtb: | $(call done,linux,stage2/build) $(BUILD)/linux/stage2.config
	$(CP) $(BUILD)/linux/stage2/build/arch/arm64/boot/dts/apple/t8103-j274.dtb $@
else
$(BUILD)/linux/stage2.dtb: $(BUILD)/artifacts/stage2.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/stage2-j313.dtb: $(BUILD)/artifacts/stage2.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/stage2-j293.dtb: $(BUILD)/artifacts/stage2.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
$(BUILD)/linux/stage2-j274.dtb: $(BUILD)/artifacts/stage2.dtbs.zstd/extract | $(BUILD)/linux/
	$(TIMESTAMP)
endif

$(BUILD)/linux/stage2.dtbs: $(BUILD)/linux/stage2.dtb $(BUILD)/linux/stage2-j313.dtb $(BUILD)/linux/stage2-j293.dtb $(BUILD)/linux/stage2-j274.dtb
	tar -C . -cvf $@ $(patsubst $(PWD)/%,%,$^)

$(call done,linux,pearl/build): $(BUILD)/linux/pearl.dts.h
$(call done,linux,pearl/build): $(BUILD)/linux/pearl.cpio

$(BUILD)/linux/debian.image: $(BUILD)/linux/pearl.dts.h
$(BUILD)/linux/debian.image: $(BUILD)/linux/debian.cpio

$(call done,linux,debian/build): $(BUILD)/linux/pearl.dts.h
$(call done,linux,debian/build): $(BUILD)/linux/debian.cpio

$(BUILD)/linux/pearl.dts: linux/pearl.dts ; $(COPY)

ifeq ($(filter pearl.modules.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/pearl.modules: $(call done,linux,pearl/configure)
	rm -rf $@.d
	$(MKDIR) $@.d
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/pearl/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/pearl/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) INSTALL_MOD_PATH=$@.d modules_install
	$(TAR) -C $@.d -c . -f $@
else
$(BUILD)/linux/pearl.modules: $(BUILD)/artifacts/pearl.modules.zstd/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/pearl.modules.zstd > $@
endif

ifeq ($(filter stage2.modules.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/stage2.modules: $(call done,linux,stage2/configure)
	rm -rf $@.d
	$(MKDIR) $@.d
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/stage2/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/stage2/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) INSTALL_MOD_PATH=$@.d modules_install
	$(TAR) -C $@.d -c . -f $@
else
$(BUILD)/linux/stage2.modules: $(BUILD)/artifacts/stage2.modules.zstd/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/stage2.modules.zstd > $@
endif

ifeq ($(filter linux.modules.zstd,$(ARTIFACTS)),)
$(BUILD)/linux/linux.modules: $(call done,linux,linux/configure)
	rm -rf $@.d
	$(MKDIR) $@.d
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/linux/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) modules
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/linux/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) INSTALL_MOD_PATH=$@.d modules_install
	$(TAR) -C $@.d -c . -f $@
else
$(BUILD)/linux/linux.modules: $(BUILD)/artifacts/linux.modules.zstd/down | $(BUILD)/linux/
	zstd -d < $(BUILD)/artifacts/down/linux.modules.zstd > $@
endif

$(call done,linux,%/build): $(call done,linux,%/configure)
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) Image
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) dtbs
	$(TIMESTAMP)

$(call done,linux,%/configure): $(call done,linux,%/copy) | $(call done,toolchain/gcc,gcc/install) $(BUILD)/linux/%.config builder/packages/qemu-user{} builder/packages/qemu-user-static{} builder/packages/binfmt-support{} builder/packages/autopoint{} builder/packages/gettext{} builder/packages/libtool-bin{}
	$(CP) $(BUILD)/linux/$*.config $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) olddefconfig
	$(TIMESTAMP)

linux/%{menuconfig}: $(call done,linux,%/copy) | $(call done,toolchain/gcc,gcc/install) linux/%.config
	$(CP) linux/$*.config $(BUILD)/linux/$*/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/$*/build ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(CP) $(BUILD)/linux/$*/build/.config $<

$(call done,linux,%/copy): | $(call done,linux,checkout) $(call done,linux,%/) $(BUILD)/linux/%/build/
	$(COPY_SAUNA) $(PWD)/linux/linux/* $(BUILD)/linux/$*/build/
	$(TIMESTAMP)

ifeq ($(filter toolchain.tar.zstd,$(ARTIFACTS)),)
$(call done,linux,headers/install): $(call done,linux,headers/copy) $(call done,pearl,install/mkdir)
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/linux/headers/source ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD)/linux/headers/o INSTALL_HDR_PATH=$(BUILD)/pearl/install headers_install
	$(TIMESTAMP)
else
$(call done,linux,headers/install): $(BUILD)/artifacts/toolchain.tar.zstd/extract | $(call done,linux,headers)/
	$(TIMESTAMP)
endif

$(call done,linux,headers/copy): | $(call done,linux,checkout) $(call done,linux,headers/) $(BUILD)/linux/headers/source/
	$(COPY_SAUNA) $(PWD)/linux/linux/* $(BUILD)/linux/headers/source/
	$(TIMESTAMP)

$(call done,linux,checkout): | $(call done,linux,)
	$(MAKE) linux/linux{checkout}
	$(TIMESTAMP)

{non-intermediate}: $(call done,linux,headers/copy) $(call done,linux,headers/configure)

$(BUILD)/linux.tar: $(call done,linux,stage2/build) $(call done,linux,linux/build) $(BUILD)/linux/stage2.image $(BUILD)/linux/stage2.modules $(BUILD)/linux/linux.image $(BUILD)/linux/linux.modules
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/linux/stage2.image $(BUILD)/linux/stage2.modules $(BUILD)/linux/linux.image $(BUILD)/linux/linux.modules)

$(BUILD)/pearl.tar: $(BUILD)/linux/pearl.image $(call done,linux,pearl/build)
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/linux/pearl.image)

SECTARGETS += $(call done,linux,stage2/build)
SECTARGETS += build/linux/stage2.image
SECTARGETS += build/linux/stage2.image.sendfile
SECTARGETS += build/linux/pearl.image.macho.sendfile
