#include "snippet.h"

#define UNALIGNED(image) (((image) & ((1 << 21)-1)) != 0)

START_SNIPPET {
  unsigned long pc;
  asm volatile("adr %0, ." : "=r" (pc));
  unsigned long page = (pc & ~16383);
  unsigned long image = page + 16384;
  unsigned long size = ((unsigned long *)image)[2];
  if (UNALIGNED(image)) {
    unsigned long newimage =
      (image + size + 16384 + ((1 << 21) - 1)) & ~((1L<<21)-1);
    __int128 *p = (void *)image + size;
    while (--p != (__int128 *)page) {
      p[(newimage - image)/16] = *p;
    }
    asm volatile("isb");
    asm volatile("br %0" : : "r" (newimage - image + pc));
    __builtin_unreachable();
  }
} END_SNIPPET
