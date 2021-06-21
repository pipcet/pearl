# XXX this currently makes all files executable

$(BUILD)/linux/pearl.cpio: $(BUILD)/initramfs/pearl.cpio ; $(COPY)
$(BUILD)/initramfs/%: local/initramfs/% ; $(COPY)
$(BUILD)/initramfs/pearl.cpiospec: build/userspace/done/install local/initramfs/pearl.cpiospec
	$(MKDIR) $(dir $@)
	@(cat $<; $(foreach file,$(patsubst $(BUILD)/initramfs/pearl/%,/%,$(wordlist 3,$(words $^),$^)),echo dir $(dir $(patsubst %/,%,$(file))) 755 0 0; echo file $(patsubst ./%,%,$(file)) $(BUILD)/initramfs/pearl/$(file) 755 0 0;) (cd $(BUILD)/pearl/install/; find -type f | while read file; do echo "dir "$$(dirname $$(dirname $$(dirname "$$file")))" 755 0 0";  echo "dir "$$(dirname $$(dirname "$$file"))" 755 0 0"; echo "dir "$$(dirname "$$file")" 755 0 0"; echo "file $$file $(BUILD)/pearl/install/$$file 755 0 0"; done); (cd $(BUILD)/pearl/install/; find -type l | while read file; do echo "dir "$$(dirname $$(dirname $$(dirname "$$file")))" 755 0 0";  echo "dir "$$(dirname $$(dirname "$$file"))" 755 0 0"; echo "dir "$$(dirname "$$file")" 755 0 0"; echo "slink $$file "$$(readlink "$(BUILD)/pearl/install/$$file")" 755 0 0"; done)) | LC_ALL=C sort | uniq > $@

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
