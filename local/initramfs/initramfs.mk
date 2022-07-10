# XXX this currently makes all files executable

$(BUILD)/linux/pearl.cpio: $(BUILD)/initramfs/pearl.cpio ; $(COPY)
$(BUILD)/linux/debian.cpio: $(BUILD)/initramfs/debian.cpio ; $(COPY)
$(BUILD)/initramfs/%: local/initramfs/% ; $(COPY)
$(BUILD)/initramfs/pearl.cpiospec: local/initramfs/pearl.cpiospec $(BUILD)/userspace/done/install local/initramfs/build-cpiospec.pl
	$(MKDIR) $(dir $@)
	@(cat $<; (ls $(wordlist 4,$(words $^),$^); find $(BUILD)/pearl/install/ -type f -o -type l) | LC_ALL=C perl local/initramfs/build-cpiospec.pl $(BUILD)/pearl/install $(BUILD)/initramfs/pearl) > $@

$(BUILD)/initramfs/%.cpio: $(BUILD)/initramfs/%.cpiospec $(BUILD)/linux/done/checkout | $(BUILD)/initramfs/
	(cd $(BUILD)/linux/linux/build/; ./usr/gen_initramfs.sh -o $@ $<)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2.image
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2.modules
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2-j313.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2-j293.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2-j274.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.image
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux-j313.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux-j293.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux-j274.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.modules

$(BUILD)/initramfs/pearl/boot/stage2.image: $(BUILD)/linux/stage2.image ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.image: $(BUILD)/linux/linux.image ; $(COPY)

$(BUILD)/initramfs/pearl/boot/stage2.dtb: $(BUILD)/linux/stage2.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/stage2.modules: $(BUILD)/linux/stage2.modules ; $(COPY)
$(BUILD)/initramfs/pearl/boot/stage2-j313.dtb: $(BUILD)/linux/stage2-j313.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/stage2-j293.dtb: $(BUILD)/linux/stage2-j293.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/stage2-j274.dtb: $(BUILD)/linux/stage2-j274.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.dtb: $(BUILD)/linux/linux.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux-j313.dtb: $(BUILD)/linux/linux-j313.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux-j293.dtb: $(BUILD)/linux/linux-j293.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux-j274.dtb: $(BUILD)/linux/linux-j274.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.modules: $(BUILD)/linux/linux.modules ; $(COPY)

$(BUILD)/initramfs/debian.cpiospec: $(BUILD)/initramfs/pearl.cpiospec $(BUILD)/debian/debootstrap/stage15.tar
	cat $< > $@
	echo "dir /debian 755 0 0" >> $@
	echo "file /debian/debian.tar $(BUILD)/debian/debootstrap/stage15.tar 644 0 0" >> $@

# $(BUILD)/initramfs/list.mk: $(BUILD)/userspace/done/install | $(BUILD)/initramfs/
# 	(cd $(BUILD)/pearl/install; find * -type f) | sed -e 's/:/\\\\:/g' | while read FILE; \
# 	do \
# 		echo "\$$(BUILD)/initramfs/pearl.cpio: \$$(BUILD)/userspace/install/$$FILE"; \
# 	done > $@

# -include $(BUILD)/initramfs/list.mk

SECTARGETS += $(BUILD)/linux/pearl.cpio
SECTARGETS += $(BUILD)/initramfs/pearl.cpio
SECTARGETS += $(BUILD)/initramfs/pearl.cpiospec
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2.image
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2.modules
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2-j313.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2-j293.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/stage2-j274.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux.image
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux-j313.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux-j293.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux-j274.dtb
SECTARGETS += $(BUILD)/initramfs/pearl/boot/linux.modules
