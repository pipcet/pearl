#include <sys/time.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include <poll.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

int main(void)
{
  int fd = open("/commfile", O_RDWR);
  if (fd < 0)
    return -1;
  lseek(fd, 1024 * 1024, SEEK_SET);
  write(fd, "m1lli is ready and waiting\n", strlen("m1lli is ready and waiting\n"));
  lseek(fd, 0, SEEK_SET);
  write(fd, "m1lli is ready and waiting\n", strlen("m1lli is ready and waiting\n"));
  while (true) {
    char buf[32];
    unsigned long long size;
    if (pread(fd, buf, 32, 0) != 32)
      return -1;
    if (sscanf(buf, "%lld", &size) != 1)
      continue;
    {
      FILE *f = fopen("/var/help/002-state", "w");
      if (f) {
	fprintf(f, "%ld-byte commfile being loaded\n", size - 32);
	fclose(f);
      }
    }
    if (pread(fd, buf, 32, size) != 32)
      return -1;
    if (strncmp(buf, "READY", 32) != 0)
      continue;
    char *data = malloc(size);
    if (!data)
      return -1;
    pread(fd, data, size - 32, 32);
    {
      FILE *f = fopen("/var/help/002-state", "w");
      if (f) {
	fprintf(f, "%ld-byte commfile being booted\n", size - 32);
	fclose(f);
      }
    }
    FILE *f = popen("tar xz", "w");
    fwrite(data, 1, size - 32, f);
    fclose(f);
    close(fd);
    system("/script");
    return 0;
  }
}
