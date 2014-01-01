#include <string.h>
#include <types.h>

void *memchr(const void *s, int c, size_t n)
{
	const unsigned char *src = s;
	unsigned char ch = c;

	while ((*src++ != ch) && --n);

	return n ? (void*)src : NULL;
}

int memcmp(const char *s1, const char *s2, size_t n)
{
	while ((*s1++ == *s2++) && --n);
	return (*(unsigned char *)--s1 - *(unsigned char *)--s2);
}

void *memcpy(void *dest, const void *src, size_t n)
{
	const char *in = src;
	char *out = dest;
	int i;

	for (i = 0; i < n; i++)
		out[i] = in[i];

	return dest;
}

void *memmove(void *dest, const void *src, size_t n)
{
	const char *in = src;
	char *out = dest;
	int i;

	if (dest < src) {
		for (i = 0; i < n; i++) {
			out[i] = in[i];
		}
	} else if (dest > src) {
		for (i = (n - 1); i >= 0; i--) {
			out[i] = in[i];
		}
	}

	return dest;
}

void *memset(void *s, int c, size_t n)
{
	char *src = s;
	int i;

	for (i = 0; i < n; i++)
		src[i] = c;

	return s;
}

char *strchr(const char *s, int c)
{
	while ((*s++ != c) && *s);

	return (*--s == c) ? (void*)s : NULL;
}

int strcmp(const char *s1, const char *s2)
{
	while ((*s1++ == *s2++) && *s1);
	return (*(unsigned char *)--s1 - *(unsigned char *)--s2);
}

size_t strlen(const char *s)
{
	size_t i = 0;

	while (*s++)
		i++;

	return i;
}