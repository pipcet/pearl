$(BUILD)/video/video-pearl/script.gdb: | $(BUILD)/video/video-pearl/
	(echo set disassemble-next-line on; \
	 echo target remote localhost:1234; \
	 echo si; \
	 echo p '$$'x0 = 0; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo si; \
	 echo p '$$x1 = 0x900000000'; \
	 echo p '$$x2 = ($$x4 &~0x3fff)'; \
	 echo p '*(unsigned long *)0x900000008 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000010 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000018 = 0x200000000'; \
	 echo p '*(unsigned long *)0x900000020 = 0x820000000'; \
	 echo p '*(unsigned long *)0x900000028 = 0xa00000000'; \
	 echo p '*(unsigned long *)0x900000030 = 0'; \
	 echo p '*(unsigned long *)0x900000038 = 4096'; \
	 echo p '*(unsigned long *)0x900000040 = 1024'; \
	 echo p '*(unsigned long *)0x900000048 = 1024'; \
	 echo p '*(unsigned long *)0x900000050 = 32'; \
	 echo p '*(unsigned long *)0x900000060 = 0x800000000'; \
	 echo p '*(unsigned long *)0x900000068 = 0'; \
	 echo p '*(unsigned long *)0x9000002d8 = 0x200000000') > $@

$(eval $(BUILD)/video/video-pearl/video.mp4: $(BUILD)/linux/pearl.image{gdb} $(BUILD)/video/video-pearl/script.gdb | $(BUILD)/video/video-pearl/ ; $(call video-mp4,$(BUILD)/video/video-pearl/data,$(BUILD)/video/video-pearl/script.gdb))
