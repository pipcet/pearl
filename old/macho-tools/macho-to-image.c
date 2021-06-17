#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define PRELUDE_SIZE 256 * 1024

#define MACHO_COMMAND_UNIX_THREAD 0x05
#define MACHO_COMMAND_SEGMENT_64  0x19

typedef unsigned long long u64;
typedef unsigned int u32;

#ifndef KERNEL_SIZE
#define KERNEL_SIZE 32 * 1024 * 1024
#endif

#define NULL ((void *)0)

/* these strange includes are precompiled assembly snippets included
   as binary code in the (native) binaries. */

static
#include "macho-boot..h"
;

static
#include "image-header..h"
;

static
#include "disable-timers..h"
;

struct macho_header {
    u32 irrelevant[5];
    u32 cmdsize;
    u32 irrelevant2[2];
};

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
};

asm(".text\n\t");

int main(int argc, char **argv)
{
  const size_t prelude_size = PRELUDE_SIZE;
  if (argc != 3) {
  error:
    fprintf(stderr, "usage: %s <macho image> <Linux image>\n",
	    argv[0]);
    exit(1);
  }

  FILE *f = fopen(argv[1], "r");
  if (!f)
    goto error;

  fseek(f, 0, SEEK_END);
  size_t macho_size = ftell(f);
  fseek(f, 0, SEEK_SET);
  void *buf = malloc(prelude_size + macho_size);
  if (!buf)
    goto error;

  memset(buf, 0, prelude_size + macho_size);

  void *p = buf;
  memcpy(p, image_header, sizeof(image_header));
  *((unsigned long *)p + 2) = prelude_size + macho_size;
  p += sizeof(image_header);
  //memcpy(p, disable_timers, sizeof(disable_timers));
  //p += sizeof(disable_timers);
  memcpy(p, macho_boot, sizeof(macho_boot));
  p += sizeof(macho_boot);

  void *macho = buf + prelude_size;
  assert(p <= macho);

  fread(macho, macho_size, 1, f);
  fclose(f);
  f = fopen(argv[2], "w");
  if (!f)
    goto error;
  fwrite(buf, 1, prelude_size + macho_size, f);
  fclose(f);
  return 0;
}
