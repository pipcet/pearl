#include "snippet.h"

void boot_macho_init(unsigned long long *, unsigned long)
  __attribute__((section(".text")));
volatile register void *top_of_mem __asm__("x11");

START_SNIPPET {
} END_SNIPPET

#include <stddef.h>
#include <stdint.h>
typedef unsigned long u64;
typedef unsigned u32;

static inline void *memalign(size_t align, size_t size);
static inline void *memset(void *p, int c, size_t size);

#define NULL ((void *)0)

#define PRELUDE_SIZE 256 * 1024

#define MACHO_COMMAND_UNIX_THREAD 0x05
#define MACHO_COMMAND_SEGMENT_64  0x19
struct macho_header {
  u32 irrelevant[5];
  u32 cmdsize;
  u32 irrelevant2[2];
} __attribute__((packed));

struct macho_command {
  u32 type;
  u32 size;
  union {
    struct {
      u32 thread_type;
      u32 length;
      u64 regs[32];
      u64 pc;
      u64 regs2[1];
    } unix_thread;
    struct {
      char segname[16];
      u64 vmaddr;
      u64 vmsize;
      u64 fileoff;
      u64 filesize;
      u64 unused2[2];
    } segment_64;
  } u;
} __attribute__((packed));

void boot_macho_init(unsigned long long *arg, unsigned long original_base)
{
  original_base -= 0x2000;
  unsigned long ptr = *(long *)arg;
  unsigned long flags;
  top_of_mem = (void *)0xb00000000;
  void * volatile start = ((void *)arg) - 0x48 + 256 * 1024;
  struct macho_header *header = start;
  struct macho_command *command = ((void *)header) + 32;
  void *last_command = ((void *)command) + header->cmdsize;
  u64 pc = 0;
  u64 vmin = (u64)-1, vmax = 0;
  u64 vmtotalsize = 0;
  int count = 0;
  while ((void *)command < last_command) {
    switch (command->type) {
    case MACHO_COMMAND_UNIX_THREAD:
      pc = command->u.unix_thread.pc;
      break;
    case MACHO_COMMAND_SEGMENT_64: {
      u64 vmaddr = command->u.segment_64.vmaddr;
      u64 vmsize = command->u.segment_64.vmsize;

      if (vmin >= vmaddr)
	vmin = vmaddr;
      if (vmax <= vmaddr + vmsize)
	vmax = vmaddr + vmsize;
    }
    }
    command = ((void *)command) + command->size;
  }
  vmtotalsize = vmax - vmin;
  vmtotalsize = 0;
  vmtotalsize += 16384;
  vmtotalsize &= -16384L;
  memset(top_of_mem, (count^=0xff), 10240 * 1600);
  void *dest = memalign(1, vmtotalsize);
  dest = top_of_mem;
  for (size_t count = 0; count < vmtotalsize; count++)
    ((char*)dest)[count] = 0;
  void *virtpc = NULL;
  command = ((void *)header) + 32;
  while ((void *)command < last_command) {
    switch (command->type) {
    case MACHO_COMMAND_SEGMENT_64: {
      u64 vmaddr = command->u.segment_64.vmaddr;
      u64 vmsize = command->u.segment_64.vmsize;
      u64 fileoff = command->u.segment_64.fileoff;
      u64 filesize = command->u.segment_64.filesize;
      u64 pcoff = pc - vmaddr;

      for (size_t count = 0; count < vmsize; count++)
	///((char *)0xbdf438000)[(vmaddr - vmin + count) % (2560*1600*4)] =
	  ((char*)dest)[vmaddr - vmin + count] =
	  ((char *)start)[fileoff + count];
      if (pcoff < vmsize) {
	if (pcoff < filesize) {
	  virtpc = dest + vmaddr - vmin + pcoff;
	  //virtpc = start + fileoff + pcoff;
	}
      }
    }
    }
    command = ((void *)command) + command->size;
  }
  if (virtpc == NULL)
    return;
  asm volatile("isb");
  ((void (*)(unsigned long, unsigned long))virtpc)(ptr, original_base);
}

static inline void *memset(void *p, int c, size_t size)
{
  char *p2 = p;
  while (size--) *p2++ = c;
  return p;
}

static inline void *memalign(size_t align, size_t size)
{
  while (((size_t)top_of_mem) & (align - 1))
    top_of_mem += align - ((unsigned long)top_of_mem & (align - 1));

  void *ret = top_of_mem;
  top_of_mem += size;
  return ret;
}

unsigned int bswap(unsigned int x)
{
  return __builtin_bswap32(x);
}

unsigned long bswap64(unsigned long x)
{
  return __builtin_bswap64(x);
}

