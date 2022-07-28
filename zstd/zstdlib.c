extern void *memcpy(void *dst, void *src, unsigned long count) __attribute__((used));
void *memcpy(void *dst, void *src, unsigned long count)
{
	unsigned char *d8 = dst;
	unsigned char *s8 = src;
	while (count--)
		*d8++ = *s8++;
	return dst;
}
