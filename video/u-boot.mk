$(eval $(BUILD)/video/u-boot/script.gdb: | $(BUILD)/video/u-boot/ ; $(call video-gdb-no-bootargs,$(BUILD)/bootloaders/u-boot.image.gdb,$(BUILD)/bootloaders/u-boot.image))

$(eval $(BUILD)/video/u-boot/video.mp4: $(BUILD)/bootloaders/u-boot.image.qemu $(BUILD)/video/u-boot/script.gdb | $(BUILD)/video/u-boot/ ; $(call video-mp4,$(BUILD)/video/u-boot/data,$(BUILD)/video/u-boot/script.gdb,$$<,1000))

$(BUILD)/video/u-boot/video.mp4: $(call done,bootloaders/barebox,build)
$(BUILD)/video/u-boot/video.mp4: $(call done,bootloaders/u-boot,build)
