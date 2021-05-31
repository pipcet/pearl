#include "snippet.h"

#include <stddef.h>
#include <stdint.h>
typedef unsigned long u64;
typedef unsigned u32;

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

#define FOR_EACH_COMMAND(command)					\
  for(command = (void *)(header + 1),					\
	last_command = ((void *)command) + header->cmdsize;		\
      command < last_command;						\
      command = ((void*)command) + command->size)

static inline void memmove(void *p, void *q, size_t len)
{
  unsigned __int128 *p128 = p;
  unsigned __int128 *q128 = q;

  len += 15;
  len /= 16;
  while (len--)
    *p128++ = *q128++;
}

static inline void memset(void *p, int c_ignored, size_t len)
{
  unsigned __int128 *p128 = p;

  len += 15;
  len /= 16;
  while (len--)
    *p128++ = 0;
}

void boot_macho(unsigned long, void *, void *)
  __attribute__((noreturn));

extern void macho_entry(unsigned long, unsigned long) __attribute__((noreturn));

void boot_macho(unsigned long bootargs, void *macho, void *base)
{
  u64 vmin = (u64)-1, vmax = 0;
  u64 fmin = (u64)-1, fmax = 0;
  u64 pc = 0;
  struct macho_header *header = (struct macho_header *)macho;
  struct macho_command *command, *last_command;
  FOR_EACH_COMMAND(command) {
    switch(command->type) {
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

      u64 faddr = command->u.segment_64.fileoff;
      u64 fsize = command->u.segment_64.filesize;

      if (fmin >= faddr)
	fmin = faddr;
      if (fmax <= faddr + fsize)
	fmax = faddr + fsize;
    }
    }
  }
  vmin -= fmin;
  fmin = 0;
  u64 vlen = vmax - vmin;
  u64 flen = fmax - fmin;
  void *safebase = base + vlen;
  if (safebase != macho) {
    memcpy(safebase, macho, flen);
    boot_macho(bootargs, safebase, base);
  }
  typeof (&macho_entry) actual_pc;
  actual_pc = (void *)pc - (void *)vmin + base;
  FOR_EACH_COMMAND(command) {
    switch (command->type) {
    case MACHO_COMMAND_SEGMENT_64: {
      u64 vmaddr = command->u.segment_64.vmaddr;
      u64 vmsize = command->u.segment_64.vmsize;
      u64 faddr = command->u.segment_64.fileoff;
      u64 fsize = command->u.segment_64.filesize;

      memset((void *)base + vmaddr - vmin, 0, vmsize);
      memcpy((void *)base + vmaddr - vmin, safebase + faddr, fsize);
    }
    }
  }

  asm volatile("isb");

  actual_pc(bootargs, bootargs);
}
