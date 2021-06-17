$(BUILD)/done/glibc/glibc/copy: | $(BUILD)/glibc/glibc/source/ $(BUILD)/done/glibc/glibc
	$(CP) -a userspace/glibc/glibc/* $(BUILD)/glibc/glibc/source/
	@touch $@
