build/debootstrap/stage1.tar: | build/debootstrap/
	sudo DEBOOTSTRAP_DIR=$(PWD)/submodule/debootstrap ./submodule/debootstrap/debootstrap --foreign --arch=arm64 --include=dash,wget,busybox,busybox-static,network-manager,openssh-client,net-tools,libpam-systemd sid build/debootstrap/stage1 http://deb.debian.org/debian
	(cd build/debootstrap/stage1; sudo tar c .) > $@

build/debootstrap/stage15.tar: build/debootstrap/stage1.tar
	$(MKDIR) build/debootstrap/stage15
	(cd build/debootstrap/stage15; sudo tar x) < $<
	for a in build/debootstrap/stage15/var/cache/apt/archives/*.deb; do sudo dpkg -x $$a build/debootstrap/stage15; done
	(cd build/debootstrap/stage15; sudo tar c .) > $@
