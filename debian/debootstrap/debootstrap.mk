$(BUILD)/debian/debootstrap/stage1.tar: | $(call done,debian/debootstrap,checkout) $(BUILD)/debian/debootstrap/
	sudo DEBOOTSTRAP_DIR=$(PWD)/debian/debootstrap/debootstrap ./debian/debootstrap/debootstrap/debootstrap --foreign --arch=arm64 --include=dash,wget,busybox,busybox-static,network-manager,openssh-client,net-tools,libpam-systemd,cryptsetup,lvm2,memtool,nvme-cli,watchdog,minicom,device-tree-compiler,file,gpm,ssh,usbutils,pciutils,wpasupplicant,ntpdate sid $(BUILD)/debian/debootstrap/stage1 http://deb.debian.org/debian
	(cd $(BUILD)/debian/debootstrap/stage1; sudo tar c .) > $@

$(BUILD)/debian/debootstrap/stage15.tar: $(BUILD)/debian/debootstrap/stage1.tar
	$(MKDIR) $(BUILD)/debian/debootstrap/stage15
	(cd $(BUILD)/debian/debootstrap/stage15; sudo tar x) < $<
	(cd $(BUILD)/debian/debootstrap/stage15/var/cache/apt/archives/; for a in *.deb; do sudo dpkg-deb -R $$a $$a.d; sudo dpkg-deb -b -Znone $$a.d; sudo mv $$a.d.deb $$a; sudo rm -rf $$a.d; done)
#	for a in $(BUILD)/debian/debootstrap/stage15/var/cache/apt/archives/*.deb; do sudo dpkg -x $$a $(BUILD)/debian/debootstrap/stage15; done
	(cd $(BUILD)/debian/debootstrap/stage15; sudo tar c .) > $@

$(BUILD)/debian/debootstrap/stage2.bash: | $(BUILD)/debian/debootstrap/
	(echo "#!bin/bash -x"; \
	 echo "mknod /dev/vdb b 254 16"; \
	 echo "mkdir /root2"; \
	 echo "cat /dev/vdb | uudecode"; \
	 echo "cd /root2"; \
	 echo "cat < /root1 | cpio -id"; \
	 echo "chroot /root2 debootstrap/debootstrap --second-stage"; \
	 echo "yes m1 | chroot /root2 passwd"; \
	 echo "rm -f /root2/var/cache/apt/archives/*.deb"; \
	 echo "rm -f /root2/var/lib/apt/lists/*Packages"; \
	 echo "rm -rf /root2/usr/share/locale/*"; \
	 echo "rm -rf /root2/usr/share/zoneinfo/*"; \
	 echo "rm -rf /root2/usr/share/doc/*"; \
	 echo "rm -rf /root2/usr/share/man/*"; \
	 echo "rm -rf /root2/var/lib/dpkg/info/*"; \
	 echo "rm -rf /root2/usr/lib/aarch64-linux-gnu/gconv/*"; \
	 echo "rm -f /root2/init"; \
	 echo "ln -sf bin/bash /root2/init"; \
	 echo "find . | cpio -H newc -o | uuencode root2 > /dev/vdb") > $@

$(BUILD)/debian/debootstrap/stage15.cpio: $(BUILD)/debian/debootstrap/stage15.tar
	$(MKDIR) $(BUILD)/debian/stage15.d
	(cd $(BUILD)/debian/stage15.d; sudo tar x) < $<
	sudo chown 'root:root' $(BUILD)/debian/stage15.d
	(cd $(BUILD)/debian/stage15.d; sudo find | sudo cpio -o -H newc) > $@

$(BUILD)/debian/root1.cpio.gz: | $(BUILD)/debian/
	wget -O $@ https://github.com/pipcet/debian-rootfs/releases/latest/download/root1.cpio.gz

$(BUILD)/debian/debootstrap/stage2.cpio: $(BUILD)/debian/debootstrap/stage2.bash $(BUILD)/debian/debootstrap/stage15.cpio $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz
	dd if=/dev/zero of=tmp bs=128M count=1
	(uuencode script < $(BUILD)/debian/debootstrap/stage2.bash) | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=2
	(uuencode root1 < $(BUILD)/debian/debootstrap/stage15.cpio) | dd conv=notrunc of=tmp2
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $@ < tmp2

$(BUILD)/debian/full-installer.cpio.gz: | $(BUILD)/debian/
	wget -O $@ https://github.com/pipcet/debian-installer/releases/latest/download/netboot-initrd.cpio.gz

$(BUILD)/debian/full-installer.cpio: $(BUILD)/debian/full-installer.cpio.gz
	gunzip < $< > $@

$(BUILD)/debian/installer.cpio: $(BUILD)/debian/full-installer.cpio
	sudo rm -rf $(BUILD)/debian/full-installer.d
	sudo $(MKDIR) $(BUILD)/debian/full-installer.d
	(cd $(BUILD)/debian/full-installer.d; sudo cpio -id) < $<
	sudo rm -rf $(BUILD)/debian/full-installer.d/boot
	sudo rm -rf $(BUILD)/debian/full-installer.d/lib/modules
	(cd $(BUILD)/debian/full-installer.d; sudo find | sudo cpio -H newc -o) > $@

$(BUILD)/debian/installer: debian/injected/bin/installer
	$(CP) $< $@
	chmod u+x $@

$(BUILD)/debian.cpio: $(BUILD)/debian/debootstrap/stage2.cpio $(BUILD)/debian/installer.cpio $(BUILD)/debian/installer
	$(MKDIR) $(BUILD)/debian/cpio.d
	(cd $(BUILD)/debian/cpio.d; sudo cpio -id) < $<
	sudo cp $(BUILD)/debian/installer.cpio $(BUILD)/debian/cpio.d
	sudo cp $(BUILD)/debian/installer $(BUILD)/debian/cpio.d/bin
	sudo chown 'root:root' $(BUILD)/debian/cpio.d
	sudo ln -sf sbin/init $(BUILD)/debian/cpio.d/init
	(cd $(BUILD)/debian/cpio.d; sudo find | sudo cpio -o -H newc) > $@

$(BUILD)/debian.tar: $(BUILD)/debian.cpio
	tar -C . -cvf $@ $(patsubst $(PWD)/%,%,$<)

$(BUILD)/debian/di-debootstrap.cpio: | $(BUILD)/debian/
	sudo rm -rf $(BUILD)/debian/di-debootstrap
	sudo DEBOOTSTRAP_DIR=$(PWD)/debian/debootstrap/debootstrap ./debian/debootstrap/debootstrap/debootstrap --foreign --arch=arm64 --include=build-essential,git,linux-image-cloud-arm64,bash,kmod,dash,wget,busybox,busybox-static,net-tools,libpam-systemd,file,xsltproc,mtools,openssl,mokutil,libx11-data,libx11-6,sharutils,dpkg-dev,ntpdate sid $(BUILD)/debian/di-debootstrap http://deb.debian.org/debian
	sudo chmod a+r -R $(BUILD)/debian/di-debootstrap/root
	sudo chmod a+x $(BUILD)/debian/di-debootstrap/root
	(cd $(BUILD)/debian/di-debootstrap/root; sudo git clone $(or $(DIREPO),https://github.com/pipcet/debian-installer))
	(cd $(BUILD)/debian/di-debootstrap/root/debian-installer; sudo mr checkout)
	sudo rm -f $(BUILD)/debian/di-debootstrap/init
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
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y build-dep debian-installer anna"; \
	echo "apt-get -y clean"; \
	echo "(cd /root/debian-installer/packages/anna; ./debian/rules build)"; \
	echo "(cd /root/debian-installer/packages/anna; ./debian/rules binary)"; \
	echo "cp /root/debian-installer/packages/anna_*_arm64.udeb /root/debian-installer/installer/build/localudebs/"; \
	echo "rm -rf /root/debian-installer/packages"; \
	echo "(cd /root/debian-installer/installer/build; make build_netboot-gtk)"; \
	echo "uuencode 'netboot.tar.gz' < /root/debian-installer/installer/build/dest/netboot/gtk/netboot.tar.gz > /dev/vda"; \
	echo "sync"; \
	echo "poweroff -f") | sudo tee $(BUILD)/debian/di-debootstrap/init
	sudo chmod u+x $(BUILD)/debian/di-debootstrap/init
	(cd $(BUILD)/debian/di-debootstrap; sudo chown 'root:root' .; sudo find . | sudo cpio -H newc -o) > $@

$(BUILD)/netboot.tar.gz: $(BUILD)/qemu-kernel $(BUILD)/debian/di-debootstrap.cpio
	dd if=/dev/zero of=tmp bs=128M count=1
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd ./build/debian/di-debootstrap.cpio -nic user,model=virtio -monitor none -nographic
	uudecode -o $@ < tmp
	rm -f tmp

$(BUILD)/netboot-initrd.cpio.gz: $(BUILD)/netboot.tar.gz
	sudo rm -rf $(BUILD)/netboot-tmp
	sudo $(MKDIR) $(BUILD)/netboot-tmp
	sudo tar -C $(BUILD)/netboot-tmp -xzvf $<
	cp $(BUILD)/netboot-tmp/debian-installer/arm64/initrd.gz $@
	sudo rm -rf $(BUILD)/netboot-tmp

$(BUILD)/netboot-initrd-stripped.cpio.gz: $(BUILD)/netboot.tar.gz
	sudo rm -rf $(BUILD)/netboot-tmp
	sudo $(MKDIR) $(BUILD)/netboot-tmp
	sudo tar -C $(BUILD)/netboot-tmp -xzvf $<
	cp $(BUILD)/netboot-tmp/debian-installer/arm64/initrd.gz $@
	sudo rm -rf $(BUILD)/netboot-tmp

$(call done,debian/debootstrap,checkout): | $(call done,debian/debootstrap,)
	$(MAKE) debian/debootstrap/debootstrap{checkout}
	$(TIMESTAMP)
