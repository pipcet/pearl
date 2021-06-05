busybox/busybox{menuconfig}: busybox/busybox.config stamp/busybox | build/busybox/
	$(CP) $< build/busybox/.config
	$(MAKE) -C submodule/busybox O=$(PWD)/build/busybox menuconfig
	$(CP) build/busybox/.config $<

busybox/busybox{oldconfig}: busybox/busybox.config stamp/busybox | build/busybox/
	$(CP) $< build/busybox/.config
	$(MAKE) -C submodule/busybox O=$(PWD)/build/busybox oldconfig
	$(CP) build/busybox/.config $<

build/busybox/busybox: busybox/busybox.config stamp/busybox | build/busybox/
	$(CP) $< build/busybox/.config
	$(MAKE) -C submodule/busybox O=$(PWD)/build/busybox
