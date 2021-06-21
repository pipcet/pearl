include userspace/IPC-Run/IPC-Run.mk
include userspace/busybox/busybox.mk
include userspace/cryptsetup/cryptsetup.mk
include userspace/dtc/dtc.mk
include userspace/emacs/emacs.mk
include userspace/glibc/glibc.mk
include userspace/json-c/json-c.mk
include userspace/kexec-tools/kexec-tools.mk
include userspace/libaio/libaio.mk
include userspace/libnl/libnl.mk
include userspace/lvm2/lvm2.mk
include userspace/memtool/memtool.mk
include userspace/ncurses/ncurses.mk
include userspace/nvme-cli/nvme-cli.mk
include userspace/openssl/openssl.mk
include userspace/perl/perl.mk
include userspace/popt/popt.mk
include userspace/screen/screen.mk
include userspace/slurp/slurp.mk
include userspace/util-linux/util-linux.mk
include userspace/wpa/wpa.mk

$(BUILD)/userspace/done/%: $(foreach module,$(userspace-modules),$(BUILD)/$(module)/done/%) | $(BUILD)/userspace/done/
	@touch $@

$(BUILD)/userspace.tar: $(BUILD)/userspace/done/install
	tar -C . -cf $@ $(patsubst $(PWD)/%,%,$(BUILD)/pearl/install $(BUILD)/pearl/toolchain $(wildcard $(BUILD)/*/done))
