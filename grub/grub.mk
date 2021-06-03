submodule/grub/grub-core/lib/gnulib/stdlib.in.h:
	(cd submodule/grub; sh bootstrap)

build/grub/efi/Makefile:
	(cd build/grub/efi; $(PWD)/submodule/grub/configure --host=$(NATIVE_TRIPLE) --build=$(NATIVE_TRIPLE) --target=aarch64-linux-gnu --with-platform=efi --prefix=$(PWD)/build/prefix)

build/grub/efi/grub-mkimage: stamp/grub submodule/grub/grub-core/lib/gnulib/stdlib.in.h build/grub/efi/Makefile | build/grub/efi/
	$(MAKE) -C build/grub/efi
	$(MAKE) -C build/grub/efi install

build/grub/emu/grub-mkimage: stamp/grub submodule/grub/grub-core/lib/gnulib/stdlib.in.h | build/grub/emu/
	(cd build/grub/emu; $(PWD)/submodule/grub/configure --host=aarch64-linux-gnu --build=$(NATIVE_TRIPLE) --target=aarch64-linux-gnu --with-platform=emu --prefix=$(PWD)/build/prefix)
	$(MAKE) -C build/grub/emu
	$(MAKE) -C build/grub/emu install

build/grub/grub.efi: build/grub/efi/grub-mkimage | build/grub/
	$(PWD)/build/prefix/bin/grub-mkimage -Oarm64-efi -p / acpi adler32 affs afs afsplitter all_video archelp bfs bitmap bitmap_scale blocklist boot bswap_test btrfs bufio cat cbfs chain cmdline_cat_test cmp cmp_test configfile cpio_be cpio crc64 cryptodisk crypto ctz_test datehook date datetime diskfilter disk div div_test dm_nv echo efifwsetup efi_gop efinet elf eval exfat exfctest ext2 extcmd f2fs fat fdt file font fshelp functional_test gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool geli gettext gfxmenu gfxterm_background gfxterm_menu gfxterm gptsync gzio halt hashsum hello help hexdump hfs hfspluscomp hfsplus http iso9660 jfs jpeg json keystatus ldm linux loadenv loopback lsacpi lsefimmap lsefi lsefisystab lsmmap ls lssal luks2 luks lvm lzopio macbless macho mdraid09_be mdraid09 mdraid1x memdisk memrw minicmd minix2_be minix2 minix3_be minix3 minix_be minix mmap mpi msdospart mul_test net newc nilfs2 normal ntfscomp ntfs odc offsetio part_acorn part_amiga part_apple part_bsd part_dfly part_dvh part_gpt part_msdos part_plan part_sun part_sunpc parttool password password_pbkdf2 pbkdf2 pbkdf2_test pgp png priority_queue probe procfs progress raid5rec raid6rec read reboot regexp reiserfs romfs scsi search_fs_file search_fs_uuid search_label search serial setjmp setjmp_test sfs shift_test signature_test sleep sleep_test smbios squash4 strtoull_test syslinuxcfg tar terminal terminfo test_blockarg testload test testspeed tftp tga time tpm trig tr true udf ufs1_be ufs1 ufs2 video_colors video_fb videoinfo video videotest_checksum videotest xen_boot xfs xnu_uuid xnu_uuid_test xzio zfscrypt zfsinfo zfs zstd > $@
