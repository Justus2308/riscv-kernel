#pragma once

#define RHR 0
#define THR 0
#define IER 1
#define FCR 2
#define ISR 2
#define LCR 3
#define LSR 5

extern volatile unsigned long __uart_base;

extern void uart_init(void);
extern void uart_putc(char c);
extern char uart_getc(void);

extern void kprint(char *str);
