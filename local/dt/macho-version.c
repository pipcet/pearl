#include <unistd.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  char buf[8193];
  if (read(0, buf, 8192) != 8192)
    return 1;
  if (buf[0] != 0xcf ||
      buf[1] != 0xfa ||
      buf[2] != 0xed ||
      buf[3] != 0xfe)
    return 2;
  buf[8192] = 0;
  char *p = buf + 8191;
  while (p[-1])
    p--;
  printf("%s\n", p);
  return 0;
}
