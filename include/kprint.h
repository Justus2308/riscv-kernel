#pragma once

extern volatile unsigned long __uart_base;

extern void uart_init(void);
extern void uart_putc(char c);
extern char uart_getc(void);

extern void kprint(char *str);
