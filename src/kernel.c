#include "kprint.h"

#include "debug.h"


void __attribute__((noreturn)) kernel_main(void) {
	uart_init();

	kprint("kernel booted successfully\n");
	while (1) { ;; }
}