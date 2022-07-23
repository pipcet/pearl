kernels = linux stage2 stage3 pearl
models = j274 j293 j313
stages = root shell stage2 stage3

define stagerule
$(BUILD)/sendfile/linux-$(stage).sendfile: $(BUILD)/linux/linux.modules

$(BUILD)/sendfile/linux-$(stage).sendfile: $(BUILD)/linux/linux.image $(foreach model,$(models),$(BUILD)/linux/linux-$(model).dtb) $(BUILD)/sendfile/linux-$(stage).sendfile.d/sendfile
	$(CP) $$(filter-out $(BUILD)/sendfile/linux-$(stage).sendfile.d/sendfile,$$^) $$@.d
	$(CP) $(BUILD)/sendfile/linux-$(stage).sendfile.d/sendfile $$@.d/script
	tar -C $$@.d -c . | gzip -1 > $$@

$(BUILD)/sendfile/linux-$(stage).sendfile.d/sendfile: $(BUILD)/linux/linux.image | $(BUILD)/sendfile/linux-$(stage).sendfile.d/
	echo "#!/bin/sh" > $$@
	echo "cp linux-\`cat /persist/model\`.dtb linux.dtb" >> $$@
	echo "cp linux.dtb persist" >> $$@
	echo "cp linux.dtb boot" >> $$@
	echo "cp linux.modules persist" >> $$@
	echo "cp linux.modules boot" >> $$@
	echo "egrep -v persist < /file.list > /file.list.new" >> $$@
	echo "mv /file.list.new /file.list" >> $$@
	echo "echo final > /persist/stage" >> $$@
	echo "echo $(stage) > /persist/substages" >> $$@
	echo "(echo '#!/bin/sh'; echo 'gadget &'; echo exec /bin/sh -i) > /bin/init-final-shell" >> $$@
	echo "find persist >> /file.list" >> $$@
	echo "cat /file.list | cpio -H newc -o > /boot/linux.cpio" >> $$@
	echo "dt dtb-to-dtp /boot/linux.dtb /boot/linux.dtp" >> $$@
	echo "cat /boot/resmem.dtp >> /boot/linux.dtp" >> $$@
	echo "cat /boot/bootargs.dtp >> /boot/linux.dtp" >> $$@
	echo "cat /boot/tunables.dtp >> /boot/linux.dtp" >> $$@
	echo "dt permallocs >> /boot/linux.dtp" >> $$@
	echo "dt dtp-to-dtb /boot/linux.dtp /boot/linux.dtb" >> $$@
	$(if $(filter $(stage),stage2),,echo "/bin/kexec --mem-min=\`dt mem-min\` -fix linux.image --dtb=/boot/linux.dtb --ramdisk=/boot/linux.cpio --command-line=\"clk_ignore_unused\"" >> $$@)
	chmod u+x $$@


SECTARGETS += $(BUILD)/sendfile/linux-$(stage).sendfile
endef

$(eval $(foreach stage,$(stages),$(stagerule)))
