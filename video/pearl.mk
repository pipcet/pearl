$(eval $(BUILD)/video/pearl/script.gdb: | $(BUILD)/video/pearl/ ; $(call video-gdb-bootargs,$(BUILD)/linux/pearl.image.gdb,$(BUILD)/linux/pearl.image))

$(eval $(BUILD)/video/pearl/video.mp4: $(BUILD)/linux/pearl.image.qemu $(BUILD)/video/pearl/script.gdb | $(BUILD)/video/pearl/ builder/packages/ffmpeg{} builder/packages/netpbm{} builder/packages/socat{} builder/sysctl/overcommit_memory{} ; $(call video-mp4,$(BUILD)/video/pearl/data,$(BUILD)/video/pearl/script.gdb,$$<,1000))
