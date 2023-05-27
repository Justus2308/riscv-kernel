#include "kprint.h"

#include "debug.h"


static inline volatile unsigned char *uart_regadd(unsigned long reg) {
	return (volatile unsigned char *)(&__uart_base + reg);
}

static inline unsigned long uart_readreg(unsigned long reg) {
	return *(uart_regadd(reg));
}

static inline void uart_writereg(unsigned long reg, unsigned long val) {
	*(uart_regadd(reg)) = val;
}


void kprint(char *str) {
	/* check if reciever is ready */
	if (uart_readreg(LSR) & 0x11111001) {
		// handle error
	}

	char *tmp = str;
	if (tmp == 0) return;
	do {
		uart_putc(*tmp);
	} while (*tmp);
}
