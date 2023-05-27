#include "async_handler.h"

#include "debug.h"


const void (*async_handler[16])(void) = {
	
};

const char* async_info[16] = {
	/*  0 */	"Reserved",
	/*  1 */	"Supervisor software interrupt",
	/*  2 */	"Virtual supervisor software interrupt",
	/*  3 */	"Machine software interrupt",

	/*  4 */	"Reserved",
	/*  5 */	"Supervisor timer interrupt",
	/*  6 */	"Virtual supervisor timer interrupt",
	/*  7 */	"Machine timer interrupt",

	/*  8 */	"Reserved",
	/*  9 */	"Supervisor external interrupt",
	/* 10 */	"Virtual supervisor external interrupt",
	/* 11 */	"Machine external interrupt",
	/* 12 */	"Supervisor guest external interrupt",
	/* 13 */	"Reserved",
	/* 14 */	"Reserved",
	/* 15 */	"Reserved",
};

void __attribute__((interrupt)) trap_handle_contained(void) {
	
}
