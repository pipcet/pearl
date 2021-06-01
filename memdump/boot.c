#include "snippet.h"

#include <stddef.h>
#include <stdint.h>
typedef unsigned long u64;
typedef unsigned u32;

extern void macho_entry(void *) __attribute__((noreturn));

struct memdump_args {
  void *current_base;
  void *bootargs;
  void *original_base;
  unsigned long length_of_header;
  unsigned long length_of_memdump;
  typeof(&macho_entry) entry;
};

static inline void memmove(void *p, void *q, size_t len)
{
  unsigned __int128 *p128 = p;
  unsigned __int128 *q128 = q;

  len += 15;
  len /= 16;
  while (len--)
    *p128++ = *q128++;
}

#if 0
static inline void memset(void *p, int c_ignored, size_t len)
{
  unsigned __int128 *p128 = p;

  len += 15;
  len /= 16;
  while (len--)
    *p128++ = 0;
}
#endif

void boot_memdump(struct memdump_args *args)
  __attribute__((noreturn));

void boot_memdump(struct memdump_args *args)
{
  memmove(args->original_base, args->current_base + args->length_of_header,
	  args->length_of_memdump);

  args->entry(args->bootargs);
}
