packs += debootstrap

common-debootstrap = devdir.cpio kexec.tar
stages-debootstrap = stage2 linux

build/packs/debootstrap.cpiospec: build/packs/debootstrap/debootstrap.tar
build/packs/debootstrap.cpiospec: build/packs/debootstrap/blobs.tar

build/packs/debootstrap/debootstrap.tar: build/debootstrap/stage15.tar; $(COPY)
