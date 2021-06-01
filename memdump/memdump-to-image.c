#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define PRELUDE_SIZE 256 * 1024

typedef unsigned long long u64;
typedef unsigned int u32;

#define NULL ((void *)0)

/* these strange includes are precompiled assembly snippets included
   as binary code in the (native) binaries. */

static
#include "boot..h"
;

static
#include "image..h"
;

extern void macho_entry(void *) __attribute__((noreturn));

struct memdump_args {
  unsigned long header[10];
  void *current_base;
  void *bootargs;
  void *original_base;
  unsigned long length_of_header;
  unsigned long length_of_memdump;
  typeof(&macho_entry) entry;
};

int main(int argc, char **argv)
{
  const size_t prelude_size = PRELUDE_SIZE;
  if (argc != 6) {
  error:
    fprintf(stderr, "usage: %s <memdump image> <Linux image> <bootargs> <base address> <pc>\n",
	    argv[0]);
    exit(1);
  }

  FILE *f = fopen(argv[1], "r");
  if (!f)
    goto error;

  u64 bootargs = strtoll(argv[3], NULL, 0);
  u64 original_base = strtoll(argv[4], NULL, 0);
  u64 pc = strtoll(argv[5], NULL, 0);

  fseek(f, 0, SEEK_END);
  size_t memdump_size = ftell(f);
  fseek(f, 0, SEEK_SET);
  void *buf = malloc(prelude_size + memdump_size);
  if (!buf)
    goto error;

  memset(buf, 0, prelude_size + memdump_size);

  void *p = buf;
  memcpy(p, image, sizeof(image));
  *((unsigned long *)p + 2) = prelude_size + memdump_size;
  p += sizeof(image);
  //memcpy(p, disable_timers, sizeof(disable_timers));
  //p += sizeof(disable_timers);
  memcpy(p, boot, sizeof(boot));
  p += sizeof(boot);

  struct memdump_args *args = buf;
  args->bootargs = (void *)bootargs;
  args->original_base = (void *)original_base;
  args->length_of_header = prelude_size;
  args->length_of_memdump = memdump_size;
  args->entry = (void*)pc;

  void *memdump = buf + prelude_size;
  assert(p <= memdump);

  fread(memdump, memdump_size, 1, f);
  fclose(f);
  f = fopen(argv[2], "w");
  if (!f)
    goto error;
  fwrite(buf, 1, prelude_size + memdump_size, f);
  fclose(f);
  return 0;
}
