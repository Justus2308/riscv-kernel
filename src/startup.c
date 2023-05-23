#include <string.h> /* memset without stdlib? */

extern char __bss_src;
extern char __bss_start;
extern char __bss_end;

void _bss_init(void) {
	memset((void*)(uintptr_t)&__bss_src, 0, (&__bss_end - &__bss_start));
}
