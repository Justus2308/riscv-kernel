#include "debug.h"

#define MCAUSE_INT_MASK		0x80000000
#define MCAUSE_CODE_MASK	0x7FFFFFFF


#define MSCRATCH			0x00000340
#define MEPC				0x00000341
#define MCAUSE				0x00000342
#define MTVAL				0x00000343
#define MIP					0x00000344
#define MTINST				0x0000034A
#define MTVAL2				0x0000034B


static int async_handler[] = {
	0
};

static int sync_handler[] = {
	0
};

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
		async_handler[(mcause_v & MCAUSE_CODE_MASK)];
	} else {
		// Branch to exception handler
		sync_handler[(mcause_v & MCAUSE_CODE_MASK)];
	}
}
