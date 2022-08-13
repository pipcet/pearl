$(BUILD)/debian/installer/debian-installer.tar:
	$(RM) -rf $(BUILD)/debian/installer/debian-installer
	$(MKDIR) $(BUILD)/debian/installer/debian-installer
	(cd $(BUILD)/debian/installer/debian-installer; git clone https://github.com/pipcet/debian-installer)
	tar -C $(BUILD)/debian/installer -cf $@ debian-installer/

$(BUILD)/debian/installer/packages/%.udeb: | $(BUILD)/debian/installer/packages/
	wget -O $@ https://github.com/pipcet/debian-$*/releases/latest/download/$*.udeb

$(BUILD)/debian/installer/packages.tar: $(patsubst %,$(BUILD)/debian/installer/packages/%.udeb,partman-auto user-setup-udeb netcfg-static nobootloader libdebian-installer4-udeb)
	tar -C $(BUILD)/debian/installer/packages -cf $@ $(patsubst $(BUILD)/debian/installer/packages/%,%,$^)

$(BUILD)/debian/installer/sources.cpio: $(BUILD)/debian/installer/debian-installer.tar $(BUILD)/debian/installer/packages.tar
	echo $(patsubst $(BUILD)/debian/installer/%,%,$^) | cpio -H newc -D $(BUILD)/debian/installer -o > $@

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
	echo "cd /root; git clone https://github.com/pipcet/debian-installer"; \
	echo "cd /root/debian-installer; mr checkout"; \
	echo "(cd /root/debian-installer/packages; wget https://github.com/pipcet/debian-partman-auto/releases/latest/download/partman-auto.udeb) || exit 1"; \
	echo "(cd /root/debian-installer/packages; wget https://github.com/pipcet/debian-user-setup/releases/latest/download/user-setup-udeb.udeb) || exit 1"; \
	echo "(cd /root/debian-installer/packages; wget https://github.com/pipcet/debian-netcfg/releases/latest/download/netcfg-static.udeb) || exit 1"; \
	echo "(cd /root/debian-installer/packages; wget https://github.com/pipcet/debian-nobootloader/releases/latest/download/nobootloader.udeb) || exit 1"; \
	echo "(cd /root/debian-installer/packages; wget https://github.com/pipcet/debian-libdebian-installer/releases/latest/download/libdebian-installer4-udeb.udeb) || exit 1"; \
	echo "mkdir -p /root/debian-installer/installer/build/localudebs/"; \
	echo "cp /root/debian-installer/packages/*.udeb /root/debian-installer/installer/build/localudebs/"; \
	echo "rm -rf /root/debian-installer/packages"; \
	echo "cd /root/debian-installer/installer/build; make build_netboot-gtk"; \
	echo "uuencode 'netboot.tar.gz' < /root/debian-installer/installer/build/dest/netboot/gtk/netboot.tar.gz > /dev/vda") > $@

$(BUILD)/debian/installer/netboot.tar.gz: $(BUILD)/debian/installer/script.bash $(BUILD)/qemu-kernel $(BUILD)/debian/debian-rootfs/root2.cpio.gz | $(BUILD)/debian/installer/ $(patsubst %,builder/packages/%{},qemu-system-aarch64 sharutils)
	dd if=/dev/zero of=tmp bs=128M count=1
	uuencode /dev/stdout < $< | dd conv=notrunc of=tmp
	qemu-system-aarch64 -drive if=virtio,index=0,media=disk,driver=raw,file=tmp -machine virt -cpu max -kernel $(BUILD)/qemu-kernel -m 7g -serial stdio -initrd $(BUILD)/debian/debian-rootfs/root2.cpio.gz -nic user,model=virtio -monitor none -nographic
	uudecode -o $@ < tmp
	rm -f tmp

$(BUILD)/debian/installer/netboot-initrd.cpio.gz: $(BUILD)/debian/installer/netboot.tar.gz
	sudo rm -rf $(BUILD)/debian/installer/netboot
	sudo $(MKDIR) $(BUILD)/debian/installer/netboot
	sudo tar -C $(BUILD)/debian/installer/netboot -xzvf $<
	cp $(BUILD)/debian/installer/netbooot/debian-installer/arm64/initrd.gz $@
	sudo rm -rf $(BUILD)/debian/installer/netboot
