# XXX this currently makes all files executable

$(BUILD)/linux/pearl.cpio: $(BUILD)/initramfs/pearl.cpio ; $(COPY)
$(BUILD)/initramfs/%: local/initramfs/% ; $(COPY)
$(BUILD)/initramfs/pearl.cpiospec: build/userspace/done/install local/initramfs/pearl.cpiospec
	$(MKDIR) $(dir $@)
	@(cat $<; (ls $(wordlist 3,$(words $^),$^); find $(BUILD)/pearl/install/ -type f -o -type l) | LC_ALL=C perl local/initramfs/build-cpiospec.pl $(BUILD)/pearl/install $(BUILD)/initramfs/pearl) > $@

$(BUILD)/initramfs/pearl.cpio: $(BUILD)/initramfs/pearl.cpiospec $(BUILD)/linux/done/checkout | $(BUILD)/initramfs/
	(cd $(BUILD)/linux/linux/build/; ./usr/gen_initramfs.sh -o $@ $<)

$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2.image
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/stage2.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.image
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.dtb
$(BUILD)/initramfs/pearl.cpiospec: $(BUILD)/initramfs/pearl/boot/linux.modules

$(BUILD)/initramfs/pearl/boot/stage2.image: $(BUILD)/linux/stage2.image ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.image: $(BUILD)/linux/linux.image ; $(COPY)

$(BUILD)/initramfs/pearl/boot/stage2.dtb: $(BUILD)/linux/stage2.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.dtb: $(BUILD)/linux/linux.dtb ; $(COPY)
$(BUILD)/initramfs/pearl/boot/linux.modules: $(BUILD)/linux/linux.modules ; $(COPY)

# $(BUILD)/initramfs/list.mk: $(BUILD)/userspace/done/install | $(BUILD)/initramfs/
# 	(cd $(BUILD)/pearl/install; find * -type f) | sed -e 's/:/\\\\:/g' | while read FILE; \
# 	do \
# 		echo "\$$(BUILD)/initramfs/pearl.cpio: \$$(BUILD)/userspace/install/$$FILE"; \
# 	done > $@

# -include $(BUILD)/initramfs/list.mk
