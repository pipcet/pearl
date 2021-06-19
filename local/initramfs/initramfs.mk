# XXX this currently makes all files executable

$(BUILD)/linux/pearl.cpio: $(BUILD)/initramfs/pearl.cpio ; $(COPY)
$(BUILD)/initramfs/%: local/initramfs/% ; $(COPY)
$(BUILD)/initramfs/pearl.cpiospec: local/initramfs/pearl.cpiospec
	$(MKDIR) $(dir $@)
	@(cat $<; $(foreach file,$(patsubst $(BUILD)/initramfs/pearl/%,/%,$(wordlist 2,$(words $^),$^)),echo dir $(dir $(patsubst %/,%,$(file))) 755 0 0; echo file $(patsubst ./%,%,$(file)) $(BUILD)/initramfs/pearl/$(file) 755 0 0;) (cd $(BUILD)/pearl/install/; find -type f | while read file; do echo "file $$file $(BUILD)/pearl/install/$$file 755 0 0"; done)) | sort | uniq > $@

$(BUILD)/initramfs/pearl.cpio: $(BUILD)/initramfs/pearl.cpiospec $(BUILD)/linux/done/checkout | $(BUILD)/initramfs/
	(cd $(BUILD)/linux/linux/build/; ./usr/gen_initramfs.sh -o $@ $<)

# $(BUILD)/initramfs/list.mk: $(BUILD)/userspace/done/install | $(BUILD)/initramfs/
# 	(cd $(BUILD)/pearl/install; find * -type f) | sed -e 's/:/\\\\:/g' | while read FILE; \
# 	do \
# 		echo "\$$(BUILD)/initramfs/pearl.cpio: \$$(BUILD)/userspace/install/$$FILE"; \
# 	done > $@

# -include $(BUILD)/initramfs/list.mk
