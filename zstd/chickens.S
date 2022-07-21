	.globl init_cpu
init_cpu:
	.LFB42:
	mov	x0, 0
#APP
// 244 "<stdin>" 1
	msr	OSLAR_EL1, x0
// 0 "" 2
// 334 "/home/pip/pearl/build/m1n1/build/src/utils.h" 1
	mrs	x0, MPIDR_EL1
// 0 "" 2
#NO_APP
	tbnz	x0, 16, .L15
#APP
// 248 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_1
// 0 "" 2
#NO_APP
	mov	x1, 2048
	movk	x1, 0x1000, lsl 32
	orr	x0, x0, x1
#APP
// 248 "<stdin>" 1
	msr	s3_0_c15_c4_1, x0
// 0 "" 2
// 252 "<stdin>" 1
	mrs	x1, MIDR_EL1
// 0 "" 2
#NO_APP
	ubfx	x2, x1, 20, 4
	ubfx	x0, x1, 4, 12
	bfi	w1, w2, 4, 28
	cmp	x0, 40
	beq	.L17
.L33:
	cmp	w0, 40
	bgt	.L18
	cmp	w0, 36
	beq	.L17
	ble	.L31
	cmp	w0, 37
	bne	.L23
#APP
// 71 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 35184372088832
#APP
// 71 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 74 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	and	x0, x0, -18014398509481985
#APP
// 74 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 76 "<stdin>" 1
	mrs	x0, s3_0_c15_c3_0
// 0 "" 2
#NO_APP
	and	x0, x0, 9223372036854775807
	and	x0, x0, -17592186044417
#APP
// 76 "<stdin>" 1
	msr	s3_0_c15_c3_0, x0
// 0 "" 2
// 79 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 3298534883328
#APP
// 79 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 82 "<stdin>" 1
	mrs	x0, s3_0_c15_c5_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 2305843009213693952
#APP
// 82 "<stdin>" 1
	msr	s3_0_c15_c5_0, x0
// 0 "" 2
// 84 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 67108864
#APP
// 84 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 86 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 576460752303423488
#APP
// 86 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
// 90 "<stdin>" 1
	mrs	x0, s3_0_c15_c14_0
// 0 "" 2
#NO_APP
	and	x0, x0, -245761
	orr	x0, x0, 65536
#APP
// 90 "<stdin>" 1
	msr	s3_0_c15_c14_0, x0
// 0 "" 2
// 95 "<stdin>" 1
	mrs	x0, s3_0_c15_c15_2
// 0 "" 2
#NO_APP
	mov	x2, 7566047373982433280
	orr	x0, x0, x2
#APP
// 95 "<stdin>" 1
	msr	s3_0_c15_c15_2, x0
// 0 "" 2
// 105 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	mov	x2, 268435456
	movk	x2, 0x10, lsl 32
	orr	x0, x0, x2
#APP
// 105 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 107 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	mov	x2, 1114112
	orr	x0, x0, x2
#APP
// 107 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 110 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 50331648
#APP
// 110 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 113 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	mov	x2, 536870912
	movk	x2, 0x1, lsl 48
	orr	x0, x0, x2
#APP
// 113 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 115 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 16384
#APP
// 115 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
// 117 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_3
// 0 "" 2
#NO_APP
	and	x0, x0, -524289
#APP
// 117 "<stdin>" 1
	msr	s3_0_c15_c1_3, x0
// 0 "" 2
// 145 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 36028797018963968
#APP
// 145 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 146 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 32768
#APP
// 146 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
#NO_APP
	cmp	w1, 15
	bls	.L23
#APP
// 149 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	mov	x1, 1441151880758558720
	orr	x0, x0, x1
#APP
// 149 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 151 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	mov	x1, 9570149208162304
	orr	x0, x0, x1
#APP
// 151 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
#NO_APP
.L30:
#APP
// 154 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 562949953421312
#APP
// 154 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
#NO_APP
.L23:
#APP
// 301 "<stdin>" 1
	mrs	x0, MPIDR_EL1
// 0 "" 2
#NO_APP
	and	x0, x0, 255
#APP
// 304 "<stdin>" 1
	msr	s3_4_c15_c5_0, x0
// 0 "" 2
#NO_APP
	mov	x0, 256
#APP
// 305 "<stdin>" 1
	msr	s3_4_c15_c1_4, x0
// 0 "" 2
#NO_APP
	mov	x0, 0
#APP
// 308 "<stdin>" 1
	msr	s3_4_c15_c10_4, x0
// 0 "" 2
// 310 "<stdin>" 1
	isb
// 0 "" 2
// 313 "<stdin>" 1
	mrs	x0, s3_5_c15_c5_0
// 0 "" 2
#NO_APP
	and	x0, x0, -66060289
	orr	x0, x0, 33554432
#APP
// 313 "<stdin>" 1
	msr	s3_5_c15_c5_0, x0
// 0 "" 2
// 318 "<stdin>" 1
	mrs	x0, s3_5_c15_c4_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 12
#APP
// 318 "<stdin>" 1
	msr	s3_5_c15_c4_0, x0
// 0 "" 2
#NO_APP
	mov	x0, 0
	ret
	.p2align 2,,3
.L31:
	cmp	w0, 34
	beq	.L17
	cmp	w0, 35
	bne	.L23
#APP
// 71 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 35184372088832
#APP
// 71 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 74 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	and	x0, x0, -18014398509481985
#APP
// 74 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 76 "<stdin>" 1
	mrs	x0, s3_0_c15_c3_0
// 0 "" 2
#NO_APP
	and	x0, x0, 9223372036854775807
	and	x0, x0, -17592186044417
#APP
// 76 "<stdin>" 1
	msr	s3_0_c15_c3_0, x0
// 0 "" 2
// 79 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 3298534883328
#APP
// 79 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 82 "<stdin>" 1
	mrs	x0, s3_0_c15_c5_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 2305843009213693952
#APP
// 82 "<stdin>" 1
	msr	s3_0_c15_c5_0, x0
// 0 "" 2
// 84 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 67108864
#APP
// 84 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 86 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 576460752303423488
#APP
// 86 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
// 90 "<stdin>" 1
	mrs	x0, s3_0_c15_c14_0
// 0 "" 2
#NO_APP
	and	x0, x0, -245761
	orr	x0, x0, 65536
#APP
// 90 "<stdin>" 1
	msr	s3_0_c15_c14_0, x0
// 0 "" 2
// 95 "<stdin>" 1
	mrs	x0, s3_0_c15_c15_2
// 0 "" 2
#NO_APP
	mov	x2, 7566047373982433280
	orr	x0, x0, x2
#APP
// 95 "<stdin>" 1
	msr	s3_0_c15_c15_2, x0
// 0 "" 2
// 105 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	mov	x2, 268435456
	movk	x2, 0x10, lsl 32
	orr	x0, x0, x2
#APP
// 105 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 107 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	mov	x2, 1114112
	orr	x0, x0, x2
#APP
// 107 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 110 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 50331648
#APP
// 110 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 113 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	mov	x2, 536870912
	movk	x2, 0x1, lsl 48
	orr	x0, x0, x2
#APP
// 113 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 115 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 16384
#APP
// 115 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
// 117 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_3
// 0 "" 2
#NO_APP
	and	x0, x0, -524289
#APP
// 117 "<stdin>" 1
	msr	s3_0_c15_c1_3, x0
// 0 "" 2
// 124 "<stdin>" 1
	mrs	x0, s3_0_c15_c6_0
// 0 "" 2
#NO_APP
	and	x0, x0, -993
#APP
// 124 "<stdin>" 1
	msr	s3_0_c15_c6_0, x0
// 0 "" 2
#NO_APP
	cmp	w1, 15
	bls	.L23
#APP
// 127 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	mov	x2, 9570149208162304
	orr	x0, x0, x2
#APP
// 127 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 130 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 36028797018963968
#APP
// 130 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 131 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 32768
#APP
// 131 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
#NO_APP
	cmp	w1, 17
	bne	.L28
#APP
// 135 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	mov	x1, 1441151880758558720
	orr	x0, x0, x1
#APP
// 135 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
#NO_APP
	b	.L30
	.p2align 2,,3
.L18:
	cmp	w0, 50
	beq	.L25
	cmp	w0, 51
	bne	.L32
#APP
// 27 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	and	x0, x0, -13194139533313
	orr	x0, x0, 4398046511104
#APP
// 27 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 28 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 12582912
#APP
// 28 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 30 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	mov	x1, 67239936
	orr	x0, x0, x1
#APP
// 30 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 34 "<stdin>" 1
	mrs	x0, s3_0_c15_c14_0
// 0 "" 2
#NO_APP
	mov	x1, 17416
	and	x0, x0, 1152921504606584832
	movk	x1, 0x1000, lsl 16
	and	x0, x0, -18014398442373121
	movk	x1, 0x1111, lsl 32
	movk	x1, 0x11, lsl 48
	orr	x0, x0, x1
#APP
// 34 "<stdin>" 1
	msr	s3_0_c15_c14_0, x0
// 0 "" 2
// 44 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_3
// 0 "" 2
#NO_APP
	and	x0, x0, -256
	mov	x1, 26
	and	x0, x0, -17523466567681
	movk	x1, 0x1f0, lsl 32
	orr	x0, x0, x1
#APP
// 44 "<stdin>" 1
	msr	s3_0_c15_c0_3, x0
// 0 "" 2
// 45 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_4
// 0 "" 2
#NO_APP
	and	x0, x0, -65281
	orr	x0, x0, 7936
#APP
// 45 "<stdin>" 1
	msr	s3_0_c15_c0_4, x0
// 0 "" 2
// 52 "<stdin>" 1
	mrs	x0, s3_0_c15_c3_0
// 0 "" 2
#NO_APP
	and	x0, x0, -9079256848778919937
	orr	x0, x0, 8646911284551352320
#APP
// 52 "<stdin>" 1
	msr	s3_0_c15_c3_0, x0
// 0 "" 2
// 53 "<stdin>" 1
	mrs	x0, s3_0_c15_c3_0
// 0 "" 2
#NO_APP
	orr	x0, x0, -9223372036854775808
#APP
// 53 "<stdin>" 1
	msr	s3_0_c15_c3_0, x0
// 0 "" 2
// 54 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	mov	x1, 671088640
	orr	x0, x0, x1
#APP
// 54 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
// 55 "<stdin>" 1
	mrs	x0, s3_0_c15_c15_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 4096
#APP
// 55 "<stdin>" 1
	msr	s3_0_c15_c15_2, x0
// 0 "" 2
#NO_APP
	b	.L23
.L32:
	cmp	w0, 41
	bne	.L23
#APP
// 71 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 35184372088832
#APP
// 71 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 74 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	and	x0, x0, -18014398509481985
#APP
// 74 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 76 "<stdin>" 1
	mrs	x0, s3_0_c15_c3_0
// 0 "" 2
#NO_APP
	and	x0, x0, 9223372036854775807
	and	x0, x0, -17592186044417
#APP
// 76 "<stdin>" 1
	msr	s3_0_c15_c3_0, x0
// 0 "" 2
// 79 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 3298534883328
#APP
// 79 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 82 "<stdin>" 1
	mrs	x0, s3_0_c15_c5_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 2305843009213693952
#APP
// 82 "<stdin>" 1
	msr	s3_0_c15_c5_0, x0
// 0 "" 2
// 84 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 67108864
#APP
// 84 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 86 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 576460752303423488
#APP
// 86 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
// 90 "<stdin>" 1
	mrs	x0, s3_0_c15_c14_0
// 0 "" 2
#NO_APP
	and	x0, x0, -245761
	orr	x0, x0, 65536
#APP
// 90 "<stdin>" 1
	msr	s3_0_c15_c14_0, x0
// 0 "" 2
// 95 "<stdin>" 1
	mrs	x0, s3_0_c15_c15_2
// 0 "" 2
#NO_APP
	mov	x2, 7566047373982433280
	orr	x0, x0, x2
#APP
// 95 "<stdin>" 1
	msr	s3_0_c15_c15_2, x0
// 0 "" 2
// 105 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_0
// 0 "" 2
#NO_APP
	mov	x2, 268435456
	movk	x2, 0x10, lsl 32
	orr	x0, x0, x2
#APP
// 105 "<stdin>" 1
	msr	s3_0_c15_c0_0, x0
// 0 "" 2
// 107 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	mov	x2, 1114112
	orr	x0, x0, x2
#APP
// 107 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 110 "<stdin>" 1
	mrs	x0, s3_0_c15_c7_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 50331648
#APP
// 110 "<stdin>" 1
	msr	s3_0_c15_c7_0, x0
// 0 "" 2
// 113 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	mov	x2, 536870912
	movk	x2, 0x1, lsl 48
	orr	x0, x0, x2
#APP
// 113 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 115 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 16384
#APP
// 115 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
// 117 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_3
// 0 "" 2
#NO_APP
	and	x0, x0, -524289
#APP
// 117 "<stdin>" 1
	msr	s3_0_c15_c1_3, x0
// 0 "" 2
// 162 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 288230376151711744
#APP
// 162 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 164 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	mov	x2, 9570149208162304
	orr	x0, x0, x2
#APP
// 164 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 167 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 36028797018963968
#APP
// 167 "<stdin>" 1
	msr	s3_0_c15_c9_0, x0
// 0 "" 2
// 169 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 32768
#APP
// 169 "<stdin>" 1
	msr	s3_0_c15_c11_0, x0
// 0 "" 2
#NO_APP
	cmp	w1, 15
	bls	.L23
#APP
// 172 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 1152921504606846976
#APP
// 172 "<stdin>" 1
	msr	s3_0_c15_c1_0, x0
// 0 "" 2
// 174 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 562949953421312
#APP
// 174 "<stdin>" 1
	msr	s3_0_c15_c11_2, x0
// 0 "" 2
#NO_APP
	b	.L23
	.p2align 2,,3
.L15:
#APP
// 250 "<stdin>" 1
	mrs	x0, s3_0_c15_c4_0
// 0 "" 2
#NO_APP
	mov	x1, 2048
	movk	x1, 0x1000, lsl 32
	orr	x0, x0, x1
#APP
// 250 "<stdin>" 1
	msr	s3_0_c15_c4_0, x0
// 0 "" 2
// 252 "<stdin>" 1
	mrs	x1, MIDR_EL1
// 0 "" 2
#NO_APP
	ubfx	x2, x1, 20, 4
	ubfx	x0, x1, 4, 12
	bfi	w1, w2, 4, 28
	cmp	x0, 40
	bne	.L33
	.p2align 3,,7
.L17:
#APP
// 185 "<stdin>" 1
	mrs	x0, s3_0_c15_c5_0
// 0 "" 2
#NO_APP
	orr	x0, x0, 2305843009213693952
#APP
// 185 "<stdin>" 1
	msr	s3_0_c15_c5_0, x0
// 0 "" 2
// 187 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_1
// 0 "" 2
#NO_APP
	and	x0, x0, -33
#APP
// 187 "<stdin>" 1
	msr	s3_0_c15_c9_1, x0
// 0 "" 2
// 191 "<stdin>" 1
	mrs	x0, s3_0_c15_c10_1
// 0 "" 2
#NO_APP
	mov	x1, 4294967296
	movk	x1, 0x2, lsl 48
	orr	x0, x0, x1
#APP
// 191 "<stdin>" 1
	msr	s3_0_c15_c10_1, x0
// 0 "" 2
// 194 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_2
// 0 "" 2
#NO_APP
	and	x0, x0, -257
#APP
// 194 "<stdin>" 1
	msr	s3_0_c15_c1_2, x0
// 0 "" 2
// 201 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 98304
#APP
// 201 "<stdin>" 1
	msr	s3_0_c15_c1_2, x0
// 0 "" 2
// 204 "<stdin>" 1
	mrs	x0, s3_0_c15_c1_2
// 0 "" 2
#NO_APP
	orr	x0, x0, 6291456
#APP
// 204 "<stdin>" 1
	msr	s3_0_c15_c1_2, x0
// 0 "" 2
#NO_APP
	b	.L23
	.p2align 2,,3
.L25:
#APP
// 8 "<stdin>" 1
	mrs	x0, s3_0_c15_c0_1
// 0 "" 2
#NO_APP
	orr	x0, x0, 4294967296
#APP
// 8 "<stdin>" 1
	msr	s3_0_c15_c0_1, x0
// 0 "" 2
// 15 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_1
// 0 "" 2
#NO_APP
	and	x0, x0, -4033
	orr	x0, x0, 3840
#APP
// 15 "<stdin>" 1
	msr	s3_0_c15_c9_1, x0
// 0 "" 2
// 16 "<stdin>" 1
	mrs	x0, s3_0_c15_c9_1
// 0 "" 2
#NO_APP
	orr	x0, x0, 32
#APP
// 16 "<stdin>" 1
	msr	s3_0_c15_c9_1, x0
// 0 "" 2
// 17 "<stdin>" 1
	mrs	x0, s3_0_c15_c11_3
// 0 "" 2
#NO_APP
	orr	x0, x0, 17179869184
#APP
// 17 "<stdin>" 1
	msr	s3_0_c15_c11_3, x0
// 0 "" 2
#NO_APP
	b	.L23
	.p2align 2,,3
.L28:
	cmp	w1, 16
	bhi	.L30
	b	.L23
.LFE42:
