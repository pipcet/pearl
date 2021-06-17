build/kexec/kexec: stamp/kexec | build/kexec/
	(cd submodule/kexec-tools; ./bootstrap)
	(cd submodule/kexec-tools; LDFLAGS=-static CC=aarch64-linux-gnu-gcc BUILD_CC=gcc ./configure --target=aarch64-linux-gnu --host=x86_64-pc-linux-gnu TARGET_CC=aarch64-linux-gnu-gcc LD=aarch64-linux-gnu-ld STRIP=aarch64-linux-gnu-strip)
	$(MAKE) -C submodule/kexec-tools
	$(CP) submodule/kexec-tools/build/sbin/kexec build/kexec/kexec
