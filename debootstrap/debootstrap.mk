build/debootstrap/stage1.tar: | build/debootstrap/
	sudo DEBOOTSTRAP_DIR=$(PWD)/build/debootstrap/stage1 ./debootstrap/debootstrap --foreign --arch=arm64 --include=dash,wget,busybox,busybox-static,network-manager,openssh-client,net-tools,libpam-systemd sid build/debootstrap http://deb.debian.org/debian
	(cd build/debootstrap/stage1; tar c) > $@

build/debootstrap/stage15.tar: build/debootstrap/stage1.tar
	$(MKDIR) build/debootstrap/stage15
	(cd build/debootstrap/stage15; tar x) < $<
	for a in build/debootstrap/var/cache/apt/archives/*.deb; do sudo dpkg -x $$a build/debootstrap/stage15; done
	(cd build/debootstrap/stage15; tar c) > $@
