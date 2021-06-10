#include <unistd.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  char buf[8192];
  read(0, buf, 8192);
  char *p = buf + 8191;
  while (p[-1])
    p--;
  printf("%s\n", p);
  return 0;
}
