CROSS_COMPILE ?= aarch64-linux-gnu-
M1N1DEVICE ?= $(shell ls /dev/ttyACM* | tail -1)
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)

# INCLUDE_DEBOOTSTRAP = t
INCLUDE_MODULES = t

all:

%/:
	$(MKDIR) $@

clean:
	rm -rf build

stamp/%: | stamp/
	touch $@

# echo $((1024*1024)) | sudo tee /proc/sys/fs/inotify/max_user_watches
stampserver: g/stampserver/stampserver.pl | stamp/
	inotifywait -m -r . | perl g/stampserver/stampserver.pl
