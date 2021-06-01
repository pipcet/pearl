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
	.align 3
current_base:
	.ascii "currbase"
bootargs:
	.ascii "bootargs"
original_base:
	.ascii "origbase"
length_of_header:
	.ascii "headrlen"
length_of_memdump:
	.ascii "mdumplen"
entry:
	.ascii "physpcst"

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
	adr x0, bootargs
