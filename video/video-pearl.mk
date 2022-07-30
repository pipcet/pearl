$(eval $(BUILD)/video/video-pearl/script.gdb: | $(BUILD)/video/video-pearl/ ; $(call video-gdb-bootargs,$(BUILD)/linux/pearl.image.gdb))

$(eval $(BUILD)/video/video-pearl/video.mp4: $(BUILD)/linux/pearl.image.qemu $(BUILD)/video/video-pearl/script.gdb | $(BUILD)/video/video-pearl/ ; $(call video-mp4,$(BUILD)/video/video-pearl/data,$(BUILD)/video/video-pearl/script.gdb,$$<))
