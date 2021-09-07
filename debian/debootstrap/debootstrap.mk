$(BUILD)/debian/debootstrap/stage1.tar: | $(BUILD)/debian/debootstrap/
	sudo DEBOOTSTRAP_DIR=$(PWD)/debian/debootstrap/debootstrap ./debian/debootstrap/debootstrap/debootstrap --foreign --arch=arm64 --include=dash,wget,busybox,busybox-static,network-manager,openssh-client,net-tools,libpam-systemd,cryptsetup,lvm2,memtool,nvme-cli,watchdog,minicom,device-tree-compiler,file,gpm,ssh,usbutils,pciutils sid $(BUILD)/debian/debootstrap/stage1 http://deb.debian.org/debian
	(cd $(BUILD)/debian/debootstrap/stage1; sudo tar c .) > $@

$(BUILD)/debian/debootstrap/stage15.tar: $(BUILD)/debian/debootstrap/stage1.tar
	$(MKDIR) $(BUILD)/debian/debootstrap/stage15
	(cd $(BUILD)/debian/debootstrap/stage15; sudo tar x) < $<
	(cd $(BUILD)/debian/debootstrap/stage15/var/cache/apt/archives/; for a in *.deb; do sudo dpkg-deb -R $$a $$a.d; sudo dpkg-deb -b -Znone $$a.d; sudo mv $$a.d.deb $$a; sudo rm -rf $$a.d; done)
	for a in $(BUILD)/debian/debootstrap/stage15/var/cache/apt/archives/*.deb; do sudo dpkg -x $$a $(BUILD)/debian/debootstrap/stage15; done
	(cd $(BUILD)/debian/debootstrap/stage15; sudo tar c .) > $@

$(BUILD)/debian.cpio: $(BUILD)/debian/debootstrap/stage15.tar
	$(MKDIR) $(BUILD)/debian/cpio.d
	(cd $(BUILD)/debian/cpio.d; sudo tar x) < $<
	sudo ln -sf sbin/init $(BUILD)/debian/cpio.d/init
	(cd $(BUILD)/debian/cpio.d; sudo find | sudo cpio -o -H newc) > $@

$(BUILD)/debian.cpio.gz: $(BUILD)/debian.cpio
	gzip < $< > $@

$(BUILD)/debian.cpio.zst: $(BUILD)/debian.cpio
	zstd -22 --ultra --long --verbose < $< > $@

$(BUILD)/debian.cpio.xz: $(BUILD)/debian.cpio
	xz --compress < $< > $@

$(BUILD)/debian/di-debootstrap.cpio: | $(BUILD)/debian/
	sudo rm -rf $(BUILD)/debian/di-debootstrap
	sudo DEBOOTSTRAP_DIR=$(PWD)/debian/debootstrap/debootstrap ./debian/debootstrap/debootstrap/debootstrap --foreign --arch=arm64 --include=build-essential,git,linux-image-cloud-arm64,bash,kmod,dash,wget,busybox,busybox-static,net-tools,libpam-systemd,file,xsltproc,mtools,openssl,mokutil,libx11-data,libx11-6,sharutils,dpkg-dev sid $(BUILD)/debian/di-debootstrap http://deb.debian.org/debian
	sudo chmod a+r -R $(BUILD)/debian/di-debootstrap/root
	sudo chmod a+x $(BUILD)/debian/di-debootstrap/root
	(cd $(BUILD)/debian/di-debootstrap/root; sudo git clone https://github.com/pipcet/debian-installer)
	(cd $(BUILD)/debian/di-debootstrap/root/debian-installer; sudo mr checkout)
	sudo rm -f $(BUILD)/debian/di-debootstrap/init
	(echo '#!/bin/bash'; \
	echo "export PATH"; \
	echo "/debootstrap/debootstrap --second-stage"; \
	echo "/bin/busybox mount -t proc proc proc"; \
	echo "depmod -a"; \
	echo "modprobe virtio"; \
	echo "modprobe virtio_pci"; \
	echo "modprobe virtio_net"; \
	echo "dhclient -v eth0 &"; \
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
	echo "uuencode 'netboot.tar.gz' < /root/debian-installer/installer/build/dest/netboot/gtk/netboot.tar.gz"; \
	echo "while true; do echo foo; done") | sudo tee $(BUILD)/debian/di-debootstrap/init
	sudo chmod u+x $(BUILD)/debian/di-debootstrap/init
	(cd $(BUILD)/debian/di-debootstrap; sudo find . | sudo cpio -H newc -o) > $@

$(BUILD)/netboot.tar.gz.uuencoded: $(BUILD)/qemu-kernel $(BUILD)/debian/di-debootstrap.cpio
	qemu-system-aarch64 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd ./build/debian/di-debootstrap.cpio -nic user,model=virtio -monitor none -smp 8 -nographic | (while read A B; do echo "$$A $$B" >/dev/stderr; if [ x"$$A" = x"begin" ]; then break; fi; done; echo "$$A $$B"; while read A B; do echo "$$A $$B"; if [ x"$$A" = x"end" ]; then break; fi; done; exit 0) > $@

$(BUILD)/netboot.tar.gz: $(BUILD)/netboot.tar.gz.uuencoded
	uudecode -o $@ < $<

$(BUILD)/netboot-initrd.cpio.gz: $(BUILD)/netboot.tar.gz
	rm -rf $(BUILD)/netboot-tmp
	tar -C $(BUILD)/netboot-tmp -xzvf $<
	cp $(BUILD)/netboot-tmp/debian-installer/arm64/initrd.gz $@
