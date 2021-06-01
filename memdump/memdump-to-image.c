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
#include "memdump-boot..h"
;

static
#include "memdump-image-header..h"
;

int main(int argc, char **argv)
{
  const size_t prelude_size = PRELUDE_SIZE;
  if (argc != 4) {
  error:
    fprintf(stderr, "usage: %s <memdump image> <base address> <pc>\n",
	    argv[0]);
    exit(1);
  }

  FILE *f = fopen(argv[1], "r");
  if (!f)
    goto error;

  u64 base = strtoll(argv[2], NULL, 0);
  u64 pc = strtoll(argv[3], NULL, 0);

  fseek(f, 0, SEEK_END);
  size_t memdump_size = ftell(f);
  fseek(f, 0, SEEK_SET);
  void *buf = malloc(prelude_size + memdump_size);
  if (!buf)
    goto error;

  memset(buf, 0, prelude_size + memdump_size);

  void *p = buf;
  memcpy(p, memdump_image_header, sizeof(image_header));
  *((unsigned long *)p + 2) = prelude_size + memdump_size;
  p += sizeof(image_header);
  //memcpy(p, disable_timers, sizeof(disable_timers));
  //p += sizeof(disable_timers);
  memcpy(p, memdump_boot, sizeof(memdump_boot));
  p += sizeof(memdump_boot);

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
