#include <stdbool.h>


extern void *__malloc_ptr;
typedef unsigned long u64;
typedef unsigned int u32;
typedef unsigned long uint64_t;
typedef unsigned int uint32_t;

#define isb() __asm__ __volatile__ ("isb" : : : "memory")
#define dsb() __asm__ __volatile__ ("dsb sy" : : : "memory")

#define BIT(nr)			(1UL << (nr))

asm(" \
0:\n\
	nop\n\
	b primary_entry\n\
	.quad 0\n\
	.quad 256 * 1024 * 1024	// image size, to be fixed by code\n\
	.quad 0\n\
	.quad 0\n\
	.quad 0\n\
	.quad 0\n\
	.ascii \"ARMd\"\n\
	.long 0xe\n\
primary_entry:\n\
	adr x2, 0b\n\
	b __main\n\
");

static inline unsigned int current_el(void)
{
	unsigned int el;
	asm volatile("mrs %0, currentel" : "=r" (el) : : "cc");
	return el >> 2;
}

static inline unsigned int get_cr(void)
{
	unsigned int val;

	unsigned int el = current_el();
	if (el == 1)
		asm volatile("mrs %0, sctlr_el1" : "=r" (val) : : "cc");
	else if (el == 2)
		asm volatile("mrs %0, sctlr_el2" : "=r" (val) : : "cc");
	else
		asm volatile("mrs %0, sctlr_el3" : "=r" (val) : : "cc");
	return val;
}

static inline void set_cr(unsigned int val)
{
	unsigned int el;

	el = current_el();
	if (el == 1)
		asm volatile("msr sctlr_el1, %0" : : "r" (val) : "cc");
	else if (el == 2)
		asm volatile("msr sctlr_el2, %0" : : "r" (val) : "cc");
	else
		asm volatile("msr sctlr_el3, %0" : : "r" (val) : "cc");
	isb();
}

struct apple_bootargs {
	u64 header;
	u64 virt_base;
	u64 phys_base;
	u64 mem_size;
	u64 start_of_usable_memory;
	struct {
		u64 phys_base;
		u64 unknown;
		u64 stride;
		u64 width;
		u64 height;
		u64 depth;
	} framebuffer;
	u64 machine_type;
	u64 adt_virt_base;
	u32 adt_size;
	char cmdline[608];
	u64 bootflags;
	u64 mem_size_actual;
};

asm(" \
__stack:\n								\
	.rept 65536\n							\
	.quad 0\n							\
	.endr\n								\
	.align 5\n							\
__main: \n								\
	adr     x3, __main\n						\
	mov     sp, x3 \n						\
stp     x0, x1, [sp, #-16]!					\n	\
stp     x2, x3, [sp, #-16]!					\n	\
bl init_cpu\n							\n	\
ldp	x2, x3, [sp], #16					\n	\
ldp     x0, x1, [sp], #16					\n	\
mov x1, x0\n\
        bl	_premain \n						\
    ");

asm(".text\n\t.align 4\n\t__malloc_ptr: .quad 0");
asm("ZSTD_trace_decompress_begin: mov x0, #0\n\tret");
asm("ZSTD_trace_decompress_end: ret");

typedef unsigned long size_t;
extern size_t ZSTD_decompress(void* dst, size_t dstCapacity, const void* src, size_t srcSize);
extern void __main(struct apple_bootargs *, void *)
	__attribute__((noreturn, used));
extern void _main(unsigned long dummy, struct apple_bootargs *ba, void *)
	__attribute__((noreturn, used));
extern void __end(void);
extern void *malloc(unsigned long size);
extern void *memset(void *dst, int c, unsigned long count);
extern void *memcpy(void *dst, void *src, unsigned long count);

static void mmu_disable(void);
static void mmu_init(void *, uint64_t);
void *xmemalign(unsigned long size, unsigned long align);

#define PTE_TYPE_MASK           (3 << 0)
#define PTE_TYPE_TABLE          (3 << 0)
#define PTE_TYPE_PAGE           (3 << 0)
#define PTE_TYPE_BLOCK          (1 << 0)

#define PTE_BLOCK_MEMTYPE(x)    ((x) << 2)
#define PTE_BLOCK_OUTER_SHARE   (2 << 8)
#define PTE_BLOCK_INNER_SHARE   (3 << 8)
#define PTE_BLOCK_AF            (1 << 10)

#define MT_DEVICE_nGnRnE	0
#define MT_DEVICE_nGnRE		1
#define MT_DEVICE_GRE		2
#define MT_NORMAL_NC		3
#define MT_NORMAL		4
#define MT_NORMAL_WT		5

#define MEMORY_ATTRIBUTES ((0x00 << (MT_DEVICE_nGnRnE * 8))	|	\
			   (0x04 << (MT_DEVICE_nGnRE * 8)) 	|	\
			   (0x0c << (MT_DEVICE_GRE * 8)) 	|	\
			   (0x44 << (MT_NORMAL_NC * 8))		|	\
			   (0xffUL << (MT_NORMAL * 8))		|	\
			   (0xbbUL << (MT_NORMAL_WT * 8)))

#define CACHED_MEM      (PTE_BLOCK_MEMTYPE(MT_NORMAL) | \
			 PTE_BLOCK_INNER_SHARE |	\
			 PTE_BLOCK_AF)

static void create_sections(uint64_t virt, uint64_t phys, uint64_t size,
			    uint64_t attr);

extern void main_with_stack(void *, void *, void *) __attribute__((noreturn));

asm("main_with_stack:\n\t"
    "b _main\n\t");
void _premain(struct apple_bootargs *ba, void *start, void *m)
{
	main_with_stack(ba, ba, ba->framebuffer.phys_base + ba->framebuffer.height * ba->framebuffer.stride);
}

void _main(unsigned long dummy, struct apple_bootargs *ba, void *start)
{
	void *start_of_mem = ba->start_of_usable_memory;
	void *end_of_mem = ba->phys_base + ba->mem_size;
	void **malloc_pptr;
	asm("adr %0,__malloc_ptr" : "=r" (malloc_pptr));
	unsigned char *begp = (void *)malloc_pptr;
	while (begp[0] != 0x28 || begp[1] != 0xb5 || begp[2] != 0x2f || begp[3] != 0xfd)
		begp++;
	void *end = start_of_mem;
	if (end < begp + PAYLOAD_SIZE)
		end = begp + PAYLOAD_SIZE;
	*malloc_pptr = end;

	void *dst = xmemalign(2 * 1024 * 1024 * 1024L, 2 * 1024 * 1024);
	mmu_init(0x800000000, 0x400000000);
	ZSTD_decompress(dst, 1024 * 1024 * 1024, begp, PAYLOAD_SIZE);
	void (*dstf)(struct apple_bootargs *ba) __attribute__((noreturn));
	dstf = dst + 0x2000;
	mmu_disable();
	dstf(ba);
}

void *memset(void *dst, int c, unsigned long count)
{
	unsigned char *d8 = dst;
	while (count--)
		*d8++ = c;
	return dst;
}

void *memcpy(void *dst, void *src, unsigned long count)
{
	unsigned char *d8 = dst;
	unsigned char *s8 = src;
	while (count--)
		*d8++ = *s8++;
	return dst;
}

#define BITS_PER_VA                48

/* Granule size of 4KB is being used */
#define PAGE_SIZE 	  	   4096LL
#define GRANULE_SIZE_SHIFT         12
#define GRANULE_SIZE               (1 << GRANULE_SIZE_SHIFT)
#define MAX_PTE_ENTRIES 512
#define XLAT_ADDR_MASK             ((1UL << BITS_PER_VA) - GRANULE_SIZE)

#define BITS_RESOLVED_PER_LVL   (GRANULE_SIZE_SHIFT - 3)
#define L0_ADDR_SHIFT           (GRANULE_SIZE_SHIFT + BITS_RESOLVED_PER_LVL * 3)
#define L1_ADDR_SHIFT           (GRANULE_SIZE_SHIFT + BITS_RESOLVED_PER_LVL * 2)
#define L2_ADDR_SHIFT           (GRANULE_SIZE_SHIFT + BITS_RESOLVED_PER_LVL * 1)
#define L3_ADDR_SHIFT           (GRANULE_SIZE_SHIFT + BITS_RESOLVED_PER_LVL * 0)

#define L0_ADDR_MASK     (((1UL << BITS_RESOLVED_PER_LVL) - 1) << L0_ADDR_SHIFT)
#define L1_ADDR_MASK     (((1UL << BITS_RESOLVED_PER_LVL) - 1) << L1_ADDR_SHIFT)
#define L2_ADDR_MASK     (((1UL << BITS_RESOLVED_PER_LVL) - 1) << L2_ADDR_SHIFT)
#define L3_ADDR_MASK     (((1UL << BITS_RESOLVED_PER_LVL) - 1) << L3_ADDR_SHIFT)

#define PTE_ATTRINDX(t)		((t) << 2)
#define PTE_ATTRINDX_MASK	(7 << 2)

#define TCR_T0SZ(x)		((64 - (x)) << 0)
#define TCR_IRGN_WBWA		(1 << 8)
#define TCR_ORGN_WBWA		(1 << 10)
#define TCR_SHARED_OUTER	(2 << 12)
#define TCR_SHARED_INNER	(3 << 12)
#define TCR_TG0_4K		(0 << 14)
#define TCR_EPD1_DISABLE	(1 << 23)

#define TCR_EL1_RSVD		(1 << 31)
#define TCR_EL2_RSVD		(1 << 31 | 1 << 23)
#define TCR_EL3_RSVD		(1 << 31 | 1 << 23)

#define CR_M    (1 << 0)	/* MMU enable				*/
#define CR_C    (1 << 2)	/* Dcache enable			*/
#define CR_I    (1 << 12)	/* Icache enable			*/

static inline void tlb_invalidate(void)
{
	unsigned int el = current_el();

	dsb();

	if (el == 1)
		__asm__ __volatile__("tlbi vmalle1" : : : "memory");
	else if (el == 2)
		__asm__ __volatile__("tlbi alle2" : : : "memory");
	else if (el == 3)
		__asm__ __volatile__("tlbi alle3" : : : "memory");

	dsb();
	isb();
}

static inline void set_ttbr_tcr_mair(int el, uint64_t table, uint64_t tcr, uint64_t attr)
{
	dsb();
	if (el == 1) {
		asm volatile("msr ttbr0_el1, %0" : : "r" (table) : "memory");
		asm volatile("msr tcr_el1, %0" : : "r" (tcr) : "memory");
		asm volatile("msr mair_el1, %0" : : "r" (attr) : "memory");
	} else if (el == 2) {
		asm volatile("msr ttbr0_el2, %0" : : "r" (table) : "memory");
		asm volatile("msr tcr_el2, %0" : : "r" (tcr) : "memory");
		asm volatile("msr mair_el2, %0" : : "r" (attr) : "memory");
	} else if (el == 3) {
		asm volatile("msr ttbr0_el3, %0" : : "r" (table) : "memory");
		asm volatile("msr tcr_el3, %0" : : "r" (tcr) : "memory");
		asm volatile("msr mair_el3, %0" : : "r" (attr) : "memory");
	}
	isb();
}

static inline int level2shift(int level)
{
	/* Page is 12 bits wide, every level translates 9 bits */
	return (12 + 9 * (3 - level));
}

static inline uint64_t level2mask(int level)
{
	uint64_t mask = 0;
	if (level == 0)
		mask = L0_ADDR_MASK;
	else if (level == 1)
		mask = L1_ADDR_MASK;
	else if (level == 2)
		mask = L2_ADDR_MASK;
	else if (level == 3)
		mask = L3_ADDR_MASK;

	return mask;
}

static inline uint64_t calc_tcr(int el, int va_bits)
{
	u64 ips;
	u64 tcr;

	ips = 1;
	va_bits = 36;

	if (el == 1)
		tcr = (ips << 32) | TCR_EPD1_DISABLE;
	else if (el == 2)
		tcr = (ips << 16);
	else
		tcr = (ips << 16);

	/* PTWs cacheable, inner/outer WBWA and inner shareable */
	tcr |= TCR_TG0_4K | TCR_SHARED_INNER | TCR_ORGN_WBWA | TCR_IRGN_WBWA;
	tcr |= TCR_T0SZ(va_bits);
	tcr |= (1U << 31 | 1 << 23);

	return tcr;
}

static inline int pte_type(uint64_t *pte)
{
	return *pte & PTE_TYPE_MASK;
}

static inline uint64_t *get_level_table(uint64_t *pte)
{
	uint64_t *table = (uint64_t *)(*pte & XLAT_ADDR_MASK);

	return table;
}

static uint64_t *ttb;

#define HCR_EL2_E2H_BIT		34

static int effective_el(void)
{
	int el = current_el();

	if (el == 2) {
		u64 hcr_el2;

		/*
		 * If we are using the EL2&0 translation regime, the TCR_EL2
		 * looks like the EL1 version, even though we are in EL2.
		 */
		__asm__ ("mrs %0, HCR_EL2\n" : "=r" (hcr_el2));
		if (hcr_el2 & BIT(HCR_EL2_E2H_BIT))
			return 1;
	}

	return el;
}

static bool set_table(uint64_t *pt, uint64_t *table_addr)
{
	uint64_t val;

	val = PTE_TYPE_TABLE | (uint64_t)table_addr;
	*pt = val;
	return true;
}

static uint64_t *create_table(void)
{
	uint64_t *new_table = xmemalign(PAGE_SIZE, PAGE_SIZE);

	memset(new_table, 0, GRANULE_SIZE);

	return new_table;
}

static void split_block(uint64_t *pte, int level)
{
	uint64_t old_pte = *pte;
	uint64_t *new_table;
	uint64_t i = 0;
	int levelshift;

	if ((*pte & PTE_TYPE_MASK) == PTE_TYPE_TABLE)
		return;

	/* level describes the parent level, we need the child ones */
	levelshift = level2shift(level + 1);

	new_table = create_table();

	for (i = 0; i < MAX_PTE_ENTRIES; i++) {
		new_table[i] = old_pte | (i << levelshift);

		/* Level 3 block PTEs have the table type */
		if ((level + 1) == 3)
			new_table[i] |= PTE_TYPE_TABLE;
	}

	set_table(pte, new_table);
}

#define IS_ALIGNED(x,y) (((x) & ((y)-1)) == 0)

static void create_sections(uint64_t virt, uint64_t phys, uint64_t size,
			    uint64_t attr)
{
	uint64_t *table;
	int level;

	attr &= ~PTE_TYPE_MASK;
	size += virt & (PAGE_SIZE - 1);
	virt &= -PAGE_SIZE;
	phys &= -PAGE_SIZE;
	size += PAGE_SIZE - 1;
	size &= -PAGE_SIZE;

	while (size) {
		table = ttb;
		for (level = 0; level < 4; level++) {
			uint64_t block_shift = level2shift(level);
			uint64_t idx = (virt & level2mask(level)) >> block_shift;
			uint64_t block_size = (1ULL << block_shift);

			uint64_t *pte = table + idx;

			if (level >= 2 && size >= block_size && IS_ALIGNED(virt, block_size)) {
				uint64_t type = (level == 3) ? PTE_TYPE_PAGE : PTE_TYPE_BLOCK;
				*pte = phys | attr | type;
				virt += block_size;
				phys += block_size;
				size -= block_size;
				break;
			} else {
				split_block(pte, level);
			}

			table = get_level_table(pte);
		}

	}

	tlb_invalidate();
}

static void mmu_enable(void)
{
	dsb();
	isb();
	set_cr(get_cr() | CR_M | CR_C | CR_I);
}

static void mmu_disable(void)
{
	unsigned int cr;

	cr = get_cr();
	cr &= ~(CR_M | CR_C | CR_I);

	set_cr(cr);
	tlb_invalidate();

	dsb();
	isb();
}

void mmu_init(void *start, uint64_t size)
{
	unsigned int el;

	ttb = xmemalign(PAGE_SIZE, PAGE_SIZE);
	el = effective_el();

	create_sections((uint64_t)start, (uint64_t)start, size, CACHED_MEM);
	set_ttbr_tcr_mair(current_el(), ((uint64_t *)ttb)[0]&0x0000000ffffff000,
			  calc_tcr(el, BITS_PER_VA), MEMORY_ATTRIBUTES);

	mmu_enable();
}

void *xmemalign(unsigned long size, unsigned long align)
{
	void **malloc_pptr;
	asm("adr %0,__malloc_ptr" : "=r" (malloc_pptr));
	*malloc_pptr += align - 1;
	*malloc_pptr = (void *)((unsigned long)*malloc_pptr & -align);
	void *ret = *malloc_pptr;
	*malloc_pptr += size;
	return ret;
}

void *malloc(unsigned long size)
{
	return xmemalign(size, 64);
}

void *calloc(unsigned long count, unsigned long size)
{
	return memset(malloc(size * count), 0, size * count);
}

void free(void *ptr)
{
}

void *memmove(void *dst, void *src, unsigned long count)
{
	void **malloc_pptr;
	asm("adr %0,__malloc_ptr" : "=r" (malloc_pptr));
	void *ret = memcpy(dst, memcpy(malloc(count), src, count), count);
	return ret;
}
