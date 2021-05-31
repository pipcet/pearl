0:
	nop
	b primary_entry
	.quad 0
	.quad 256 * 1024 * 1024	// image size, to be fixed by code
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.ascii "ARMd"
	.long 0xe
primary_entry:
	isb
	b 1f
bootargs:
	.quad 0 // bootargs argument, to be fixed by code
original_base:
	.quad 0 // original base address, to be fixed by code
length_of_header:
	.quad 256*1024 // length of header, to be fixed by code
1:
2:
	adr x1, stack
	sub x1, x1, #16
	mov sp, x1
	bl 1f
	.p2align 12
	.rept 0x1000
	.byte 0
	.endr
stack:
1:
	ldr x0, bootargs
	ldr x1, length_of_header
	adr x2, 0b
	add x1, x1, x2
	ldr x2, original_base
