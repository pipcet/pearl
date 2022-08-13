%.gz: %
	gzip < $< > $@

$(BUILD)/debian/debian-rootfs/root0.cpio: | $(BUILD)/debian/debian-rootfs/ $(call done,debian/debootstrap,checkout)
	sudo rm -rf $(BUILD)/debian/debian-rootfs/di-debootstrap
	sudo DEBOOTSTRAP_DIR=$(PWD)/debian/debootstrap/debootstrap ./debian/debootstrap/debootstrap/debootstrap --foreign --arch=arm64 --include=build-essential,git,linux-image-cloud-arm64,bash,kmod,dash,wget,busybox,busybox-static,net-tools,libpam-systemd,file,xsltproc,mtools,openssl,mokutil,libx11-data,libx11-6,sharutils,dpkg-dev sid $(BUILD)/debian/debian-rootfs/di-debootstrap http://deb.debian.org/debian
	sudo chmod a+r -R $(BUILD)/debian/debian-rootfs/di-debootstrap/root
	sudo chmod a+x $(BUILD)/debian/debian-rootfs/di-debootstrap/root
	sudo rm -f $(BUILD)/debian/debian-rootfs/di-debootstrap/init
	(echo '#!/bin/bash -x'; \
	echo "export PATH"; \
	echo "/debootstrap/debootstrap --second-stage"; \
	echo "/bin/busybox mount -t proc proc proc"; \
	echo "depmod -a"; \
	echo "modprobe virtio"; \
	echo "modprobe virtio_pci"; \
	echo "modprobe virtio_net"; \
	echo "modprobe virtio_blk"; \
	echo "modprobe virtio_scsi"; \
	echo "modprobe sd_mod"; \
	echo "mknod /dev/vda b 254 0"; \
	echo "dhclient -v eth0"; \
	echo "mv /init2 /init"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y build-dep debian-installer anna busybox"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y clean"; \
	echo "find / -xdev | cpio -H newc -o | uuencode 'root1.cpio' > /dev/vda"; \
	echo "sync"; \
	echo "poweroff -f") | sudo tee $(BUILD)/debian/debian-rootfs/di-debootstrap/init
	(echo '#!/bin/bash -x'; \
	echo "export PATH"; \
	echo "/bin/busybox mount -t proc proc proc"; \
	echo "modprobe virtio"; \
	echo "modprobe virtio_pci"; \
	echo "modprobe virtio_net"; \
	echo "modprobe virtio_blk"; \
	echo "modprobe virtio_scsi"; \
	echo "modprobe sd_mod"; \
	echo "mknod /dev/vda b 254 0"; \
	echo "dhclient -v eth0"; \
	echo "uudecode -o /script < /dev/vda"; \
	echo "bash -x /script"; \
	echo "sync"; \
	echo "poweroff -f") | sudo tee $(BUILD)/debian/debian-rootfs/di-debootstrap/init2
	sudo chmod u+x $(BUILD)/debian/debian-rootfs/di-debootstrap/init $(BUILD)/debian/debian-rootfs/di-debootstrap/init2
	(cd $(BUILD)/debian/debian-rootfs/di-debootstrap; sudo chown root.root .; sudo find . | sudo cpio -H newc -o) > $@

$(BUILD)/debian/debian-rootfs/root1.cpio: $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root0.cpio | $(BUILD)/
	dd if=/dev/zero of=tmp bs=1G count=2
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root0.cpio -nic user,model=virtio -monitor none -smp 8 -nographic
	uudecode -o $@ < tmp
	rm -f tmp

$(BUILD)/debian/debian-rootfs/root2-script.bash: | $(BUILD)/debian/debian-rootfs/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep debian-installer partman-auto busybox udpkg"; \
	echo "apt-get -y clean"; \
	echo "cd /; find / -xdev | cpio -H newc -o | uuencode root2.cpio > /dev/vda") > $@

ifeq ($(filter rootfs,$(RELEASED_ARTIFACTS)),)
$(BUILD)/debian/debian-rootfs/root2.cpio: $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root1.cpio.gz $(BUILD)/debian/debian-rootfs/root2-script.bash | $(BUILD)/
	dd if=/dev/zero of=tmp bs=1G count=2
	uuencode script.bash < $(BUILD)/debian/debian-rootfs/root2-script.bash | dd of=tmp conv=notrunc
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root1.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $@ < tmp
	rm -f tmp
else
$(BUILD)/debian/debian-rootfs/root2.cpio: $(BUILD)/released/pipcet/debian-rootfs/root1.cpio.gz{}
	gunzip < $(BUILD)/released/pipcet/debian-rootfs/root1.cpio.gz > $@
endif
