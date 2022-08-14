$(eval $(BUILD)/video/pearl-debian/script.gdb: | $(BUILD)/video/pearl-debian/ ; $(call video-gdb-bootargs-x0,$(BUILD)/pearl-debian.image.gdb,$(BUILD)/pearl-debian.image.qemu,10000))

$(eval $(BUILD)/video/pearl-debian/video.mp4: $(BUILD)/pearl-debian.image.qemu $(BUILD)/video/pearl-debian/script.gdb | $(BUILD)/video/pearl-debian/ $(call done,toolchain/binutils-gdb,install) builder/packages/ffmpeg{} builder/packages/netpbm{} builder/packages/socat{} builder/sysctl/overcommit_memory{} ; $(call video-mp4,$(BUILD)/video/pearl-debian/data,$(BUILD)/video/pearl-debian/script.gdb,$$<,2000))
