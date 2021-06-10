#include <unistd.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  char *path;
  char *errorstr = NULL;
  if (argc < 2 || strcmp(argv[1], "--bootargs")) {
    asprintf(&path, "/sys/firmware/devicetree/base/reserved-memory/adt@800000000/reg");
  } else if (!strcmp(argv[1], "--macho-header")) {
    asprintf(&path, "/sys/firmware/devicetree/base/reserved-memory/base@800000000/reg");
  } else {
    asprintf(&path, "/sys/firmware/devicetree/base/reserved-memory/bootargs@800000000/reg");
  }
  int fd = open(path, O_RDONLY);
  uint64_t reg[2];
  if (fd < 0) {
    errorstr = "couldn't open path";
    goto error;
  }
  if (read(fd, reg, 16) != 16) {
    errorstr = "couldn't read reg";
    goto error;
  }
  reg[0] = __builtin_bswap64(reg[0]);
  reg[1] = __builtin_bswap64(reg[1]);
  close(fd);
  fd = open("/dev/mem", O_RDONLY);
  if (fd < 0) {
    errorstr = "couldn't open /dev/mem";
    goto error;
  }
  void *buf = mmap(NULL, reg[1], PROT_READ, MAP_SHARED, fd, reg[0]);
  if (buf == MAP_FAILED) {
    asprintf(&errorstr, "couldn't mmap %016lx-%016lx\n",
	     reg[0], reg[0] + reg[1]);
    goto error;
  }
  void *buf2 = malloc(reg[1]);
  if (buf2 == NULL) {
    errorstr = "couldn't malloc";
    goto error;
  }
  volatile unsigned *p = buf;
  volatile unsigned *p2 = buf2;
  volatile unsigned *p3 = buf2;
  for (unsigned long off = 0; off < reg[1]; off += 4) {
    *p2++ = *p++;
    if (p2 - p3 >= 0x4000)
      p3 += write(1, p3, (char *)p2 - (char *)p3)/sizeof(p3[0]);
  }
  p3 += write(1, p3, (char *)p2 - (char *)p3)/sizeof(p3[0]);
  return 0;

 error:
  if (errorstr)
    fprintf(stderr, "error: %s\n", errorstr);
  fprintf(stderr, "usage: %s [--bootargs]\n", argv[0]);
  return 1;
}
