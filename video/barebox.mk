$(eval $(BUILD)/video/barebox/script.gdb: | $(BUILD)/video/barebox/ ; $(call video-gdb-bootargs,$(BUILD)/bootloaders/barebox.image.gdb,$(BUILD)/bootloaders/barebox.image))

$(eval $(BUILD)/video/barebox/video.mp4: $(BUILD)/bootloaders/barebox.image.qemu $(BUILD)/video/barebox/script.gdb | $(BUILD)/video/barebox/ ; $(call video-mp4,$(BUILD)/video/barebox/data,$(BUILD)/video/barebox/script.gdb,$$<,1000))
