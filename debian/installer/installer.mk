$(call done,debian/installer/debian-installer,checkout): debian/installer/debian-installer{checkout} | $(call done,debian/installer/debian-installer)
	$(TIMESTAMP)

$(call done,debian/installer/nobootloader,checkout): debian/installer/debian-nobootloader{checkout} | $(call done,debian/installer/debian-nobootloader)
	$(TIMESTAMP)

$(call done,debian/installer/partman-auto,checkout): debian/installer/debian-partman-auto{checkout} | $(call done,debian/installer/debian-partman-auto)
	$(TIMESTAMP)

$(call done,debian/installer/user-setup,checkout): debian/installer/debian-user-setup{checkout} | $(call done,debian/installer/debian-user-setup)
	$(TIMESTAMP)

$(call done,debian/installer/netcfg,checkout): debian/installer/debian-netcfg{checkout} | $(call done,debian/installer/debian-netcfg)
	$(TIMESTAMP)

$(call done,debian/installer/libdebian-installer,checkout): debian/installer/debian-libdebian-installer{checkout} | $(call done,debian/installer/debian-libdebian-installer)
	$(TIMESTAMP)

$(BUILD)/debian/installer/debian-installer.tar: $(call done,debian/installer/debian-installer,checkout)
	tar -C debian/installer -cf $@ debian-installer/

$(BUILD)/debian/installer/packages/nobootloader/script.bash: | $(BUILD)/debian/installer/packages/nobootloader/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep nobootloader"; \
	echo "apt-get install ca-certificates"; \
	echo "apt-get clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "(cd /root; uudecode -o archive.tar < /dev/vdb)"; \
	echo "mkdir /root/nobootloader; cd /root/nobootloader; tar xvf archive.tar"; \
	echo "cd /root/nobootloader/; ./debian/rules build"; \
	echo "cd /root/nobootloader/; ./debian/rules binary"; \
	echo "cd /root; tar cv *.udeb | uuencode packages.tar > /dev/vda") > $@

$(BUILD)/debian/installer/packages/partman-auto/script.bash: | $(BUILD)/debian/installer/packages/partman-auto/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep partman-auto"; \
	echo "apt-get install ca-certificates"; \
	echo "apt-get clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "(cd /root; uudecode -o archive.tar < /dev/vdb)"; \
	echo "mkdir /root/partman-auto; cd /root/partman-auto; tar xvf archive.tar"; \
	echo "cd /root/partman-auto/; ./debian/rules build"; \
	echo "cd /root/partman-auto/; ./debian/rules binary"; \
	echo "cd /root; tar cv *.udeb | uuencode packages.tar > /dev/vda") > $@

$(BUILD)/debian/installer/packages/user-setup/script.bash: | $(BUILD)/debian/installer/packages/user-setup/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep user-setup"; \
	echo "apt-get install ca-certificates"; \
	echo "apt-get clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "(cd /root; uudecode -o archive.tar < /dev/vdb)"; \
	echo "mkdir /root/user-setup; cd /root/user-setup; tar xvf archive.tar"; \
	echo "cd /root/user-setup/; ./debian/rules build"; \
	echo "cd /root/user-setup/; ./debian/rules binary"; \
	echo "cd /root; tar cv *.udeb | uuencode packages.tar > /dev/vda") > $@

$(BUILD)/debian/installer/packages/libdebian-installer/script.bash: | $(BUILD)/debian/installer/packages/libdebian-installer/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep libdebian-installer"; \
	echo "apt-get install ca-certificates"; \
	echo "apt-get clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "(cd /root; uudecode -o archive.tar < /dev/vdb)"; \
	echo "mkdir /root/libdebian-installer; cd /root/libdebian-installer; tar xvf archive.tar"; \
	echo "cd /root/libdebian-installer/; ./debian/rules build"; \
	echo "cd /root/libdebian-installer/; ./debian/rules binary"; \
	echo "cd /root; tar cv *.udeb | uuencode packages.tar > /dev/vda") > $@

$(BUILD)/debian/installer/packages/netcfg/script.bash: | $(BUILD)/debian/installer/packages/netcfg/
	(echo "#!/bin/bash -x"; \
	echo "ln -sf /usr/bin/true /usr/sbin/update-initramfs"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install man-db"; \
	echo "ln -sf /usr/bin/true /usr/bin/mandb"; \
	echo "apt-get -y install ca-certificates"; \
	echo "apt-get -y build-dep netcfg"; \
	echo "apt-get install ca-certificates"; \
	echo "apt-get clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "(cd /root; uudecode -o archive.tar < /dev/vdb)"; \
	echo "mkdir /root/netcfg; cd /root/netcfg; tar xvf archive.tar"; \
	echo "cd /root/netcfg/; ./debian/rules build"; \
	echo "cd /root/netcfg/; ./debian/rules binary"; \
	echo "cd /root; tar cv *.udeb | uuencode packages.tar > /dev/vda") > $@

$(BUILD)/debian/installer/packages/nobootloader.tar: $(call done,debian/installer/nobootloader,checkout) | $(BUILD)/debian/installer/packages/nobootloader/
	tar -C $(BUILD)/debian/installer/debian-nobootloader -cvf $@

$(BUILD)/debian/installer/packages/partman-auto.tar: $(call done,debian/installer/partman-auto,checkout) | $(BUILD)/debian/installer/packages/partman-auto/
	tar -C $(BUILD)/debian/installer/debian-partman-auto -cvf $@

$(BUILD)/debian/installer/packages/user-setup.tar: $(call done,debian/installer/user-setup,checkout) | $(BUILD)/debian/installer/packages/user-setup/
	tar -C $(BUILD)/debian/installer/debian-user-setup -cvf $@

$(BUILD)/debian/installer/packages/netcfg.tar: $(call done,debian/installer/netcfg,checkout) | $(BUILD)/debian/installer/packages/netcfg/
	tar -C $(BUILD)/debian/installer/debian-netcfg -cvf $@

$(BUILD)/debian/installer/packages/libdebian-installer.tar: $(call done,debian/installer/libdebian-installer,checkout) | $(BUILD)/debian/installer/packages/libdebian-installer/
	tar -C $(BUILD)/debian/installer/debian-libdebian-installer -cvf $@

$(BUILD)/debian/installer/packages/nobootloader.udeb: $(BUILD)/debian/installer/packages/nobootloader/script.bash $(BUILD)/debian/installer/packages/nobootloader.tar $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz builder/packages/sharutils{} builder/packages/qemu-system-aarch64{} | $(BUILD)/debian/installer/packages/nobootloader/
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/packages/nobootloader.tar | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $(BUILD)/debian/installer/packages/nobootloader.udeb.tar < tmp
	tar xvf $(BUILD)/debian/installer/packages/nobootloader.udeb.tar
	for a in *_*.udeb; do b=$$(echo "$$a" | sed -e 's/_.*\./\./g'); cp "$$a" "$$b"; done
	rm -f tmp

$(BUILD)/debian/installer/packages/partman-auto.udeb: $(BUILD)/debian/installer/packages/partman-auto/script.bash $(BUILD)/debian/installer/packages/partman-auto.tar $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz builder/packages/sharutils{} builder/packages/qemu-system-aarch64{} | $(BUILD)/debian/installer/packages/partman-auto/
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/packages/partman-auto.tar | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $(BUILD)/debian/installer/packages/partman-auto.udeb.tar < tmp
	tar xvf $(BUILD)/debian/installer/packages/partman-auto.udeb.tar
	for a in *_*.udeb; do b=$$(echo "$$a" | sed -e 's/_.*\./\./g'); cp "$$a" "$$b"; done
	rm -f tmp

$(BUILD)/debian/installer/packages/user-setup.udeb: $(BUILD)/debian/installer/packages/user-setup/script.bash $(BUILD)/debian/installer/packages/user-setup.tar $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz builder/packages/sharutils{} builder/packages/qemu-system-aarch64{} | $(BUILD)/debian/installer/packages/user-setup/
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/packages/user-setup.tar | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $(BUILD)/debian/installer/packages/user-setup.udeb.tar < tmp
	tar xvf $(BUILD)/debian/installer/packages/user-setup.udeb.tar
	for a in *_*.udeb; do b=$$(echo "$$a" | sed -e 's/_.*\./\./g'); cp "$$a" "$$b"; done
	rm -f tmp

$(BUILD)/debian/installer/packages/netcfg.udeb: $(BUILD)/debian/installer/packages/netcfg/script.bash $(BUILD)/debian/installer/packages/netcfg.tar $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz builder/packages/sharutils{} builder/packages/qemu-system-aarch64{} | $(BUILD)/debian/installer/packages/netcfg/
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/packages/netcfg.tar | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $(BUILD)/debian/installer/packages/netcfg.udeb.tar < tmp
	tar xvf $(BUILD)/debian/installer/packages/netcfg.udeb.tar
	for a in *_*.udeb; do b=$$(echo "$$a" | sed -e 's/_.*\./\./g'); cp "$$a" "$$b"; done
	rm -f tmp

$(BUILD)/debian/installer/packages/libdebian-installer.udeb: $(BUILD)/debian/installer/packages/libdebian-installer/script.bash $(BUILD)/debian/installer/packages/libdebian-installer.tar $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz builder/packages/sharutils{} builder/packages/qemu-system-aarch64{} | $(BUILD)/debian/installer/packages/libdebian-installer/
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/packages/libdebian-installer.tar | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $(BUILD)/debian/installer/packages/libdebian-installer.udeb.tar < tmp
	tar xvf $(BUILD)/debian/installer/packages/libdebian-installer.udeb.tar
	for a in *_*.udeb; do b=$$(echo "$$a" | sed -e 's/_.*\./\./g'); cp "$$a" "$$b"; done
	rm -f tmp

$(BUILD)/debian/installer/packages.tar: $(patsubst %,$(BUILD)/debian/installer/packages/%.udeb,partman-auto user-setup netcfg nobootloader libdebian-installer)
	tar -C $(BUILD)/debian/installer/packages -cf $@ $(patsubst $(BUILD)/debian/installer/packages/%,%,$^)

$(BUILD)/debian/installer/sources.cpio: $(BUILD)/debian/installer/debian-installer.tar $(BUILD)/debian/installer/packages.tar
	(echo debian-installer.tar; echo packages.tar) | cpio -H newc -D $(BUILD)/debian/installer -o > $@

$(BUILD)/debian/installer/script.bash: $(BUILD)/debian/installer/sources.cpio | $(BUILD)/debian/installer/
	(echo "#!/bin/bash -x"; \
	echo "echo deb-src https://deb.debian.org/debian sid main >> /etc/apt/sources.list"; \
	echo "apt -y --fix-broken install"; \
	echo "apt-get -y update"; \
	echo "apt-get -y dist-upgrade"; \
	echo "apt-get -y install ca-certificates || true"; \
	echo "apt-get -y build-dep debian-installer netcfg libdebian-installer user-setup-udeb nobootloader preseed preseed-common network-preseed file-preseed initrd-preseed env-preseed user-setup-udeb"; \
	echo "apt-get -y install ca-certificates myrepos"; \
	echo "apt-get -y clean"; \
	echo "mknod /dev/vdb b 254 16"; \
	echo "cd /root; uudecode -o sources.cpio < /dev/vdb"; \
	echo "cd /root; cpio -id < sources.cpio"; \
	echo "cd /root; tar xf debian-installer.tar"; \
	echo "cd /root; tar xvf packages.tar"; \
	echo "cd /root/debian-installer; mr checkout"; \
	echo "cd /root; cp partman-auto.udeb debian-installer/packages"; \
	echo "cd /root; cp user-setup-udeb.udeb debian-installer/packages"; \
	echo "cd /root; cp netcfg-static.udeb debian-installer/packages"; \
	echo "cd /root; cp nobootloader.udeb debian-installer/packages"; \
	echo "cd /root; cp libdebian-installer4-udeb.udeb debian-installer/packages"; \
	echo "mkdir -p /root/debian-installer/installer/build/localudebs/"; \
	echo "cp /root/debian-installer/packages/*.udeb /root/debian-installer/installer/build/localudebs/"; \
	echo "rm -rf /root/debian-installer/packages"; \
	echo "cd /root/debian-installer/installer/build; make build_netboot-gtk"; \
	echo "uuencode 'netboot.tar.gz' < /root/debian-installer/installer/build/dest/netboot/gtk/netboot.tar.gz > /dev/vda") > $@

$(BUILD)/debian/installer/netboot.tar.gz: $(BUILD)/debian/installer/script.bash $(BUILD)/debian/installer/sources.cpio $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz | $(BUILD)/debian/installer/ $(patsubst %,builder/packages/%{},qemu-system-aarch64 sharutils)
	dd if=/dev/zero of=tmp bs=256M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	dd if=/dev/zero of=tmp2 bs=1G count=1
	uuencode /dev/stdout < $(BUILD)/debian/installer/sources.cpio | dd conv=notrunc of=tmp2
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -drive if=virtio,index=1,media=disk,driver=raw,file=tmp2 -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $@ < tmp
	rm -f tmp

$(BUILD)/debian/installer/netboot-initrd.cpio.gz: $(BUILD)/debian/installer/netboot.tar.gz
	sudo rm -rf $(BUILD)/debian/installer/netboot
	sudo $(MKDIR) $(BUILD)/debian/installer/netboot
	sudo tar -C $(BUILD)/debian/installer/netboot -xzvf $<
	cp $(BUILD)/debian/installer/netboot/debian-installer/arm64/initrd.gz $@
	sudo rm -rf $(BUILD)/debian/installer/netboot
