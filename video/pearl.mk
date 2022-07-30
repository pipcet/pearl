$(eval $(BUILD)/video/pearl/script.gdb: | $(BUILD)/video/pearl/ ; $(call video-gdb-bootargs,$(BUILD)/linux/pearl.image.gdb))

$(eval $(BUILD)/video/pearl/video.mp4: $(BUILD)/linux/pearl.image.qemu $(BUILD)/video/pearl/script.gdb | $(BUILD)/video/pearl/ ; $(call video-mp4,$(BUILD)/video/pearl/data,$(BUILD)/video/pearl/script.gdb,$$<,1000))
