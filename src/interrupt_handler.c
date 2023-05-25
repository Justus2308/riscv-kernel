#include "async_handler.h"
#include "sync_handler.h"

#include "debug.h"

#define MCAUSE_INT_MASK		0x80000000
#define MCAUSE_CODE_MASK	0x7FFFFFFF

#define MSTATUS				0x300
#define MEPC				0x341
#define MCAUSE				0x342



unsigned long read_csr(unsigned long mreg) {
	unsigned long val;
	asm volatile (
		"csrr %0, %1"
		: "=r" (val)
		: "r" (mreg)
	);
	return val;
}

void software_handler() {
	unsigned long mcause_v = read_csr(MCAUSE);

	if (mcause_v & MCAUSE_INT_MASK) {
		// Branch to interrupt handler here
		// Index into 32-bit array containing addresses of functions
		async_handler[(mcause_v & MCAUSE_CODE_MASK)]();
	} else {
		// Branch to exception handler
		sync_handler[(mcause_v & MCAUSE_CODE_MASK)]();
	}
}
