build/debootstrap/stage1.tar: | build/debootstrap/
	sudo DEBOOTSTRAP_DIR=$(PWD)/submodule/debootstrap ./submodule/debootstrap/debootstrap --foreign --arch=arm64 --include=dash,wget,busybox,busybox-static,network-manager,openssh-client,net-tools,libpam-systemd,cryptsetup,lvm2 sid build/debootstrap/stage1 http://deb.debian.org/debian
	(cd build/debootstrap/stage1; sudo tar c .) > $@

build/debootstrap/stage15.tar: build/debootstrap/stage1.tar
	$(MKDIR) build/debootstrap/stage15
	(cd build/debootstrap/stage15; sudo tar x) < $<
	(cd build/debootstrap/stage15/var/cache/apt/archives/; for a in *.deb; do sudo dpkg-deb -R $$a $$a.d; sudo dpkg-deb -b -Znone $$a.d; sudo mv $$a.d.deb $$a; sudo rm -rf $$a.d; done)
	for a in build/debootstrap/stage15/var/cache/apt/archives/*.deb; do sudo dpkg -x $$a build/debootstrap/stage15; done
	(cd build/debootstrap/stage15; sudo tar c .) > $@
