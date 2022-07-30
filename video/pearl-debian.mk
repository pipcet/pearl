$(eval $(BUILD)/video/pearl-debian/script.gdb: | $(BUILD)/video/pearl-debian/ ; $(call video-gdb-bootargs-x0,$(BUILD)/pearl-debian-uncompressed.macho.zst.image.gdb))

$(eval $(BUILD)/video/pearl-debian/video.mp4: $(BUILD)/pearl-debian-uncompressed.macho.zst.image.qemu $(BUILD)/video/pearl-debian/script.gdb | $(BUILD)/video/pearl-debian/ ; $(call video-mp4,$(BUILD)/video/pearl-debian/data,$(BUILD)/video/pearl-debian/script.gdb,$$<,2000))
