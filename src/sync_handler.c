#include "sync_handler.h"


const void (*sync_handler[24])(void) = {

};

const char* sync_info[24] = {
	/*  0 */	"Instruction address misaligned",
	/*  1 */	"Instruction access fault",
	/*  2 */	"Illegal instruction",

	/*  3 */	"Breakpoint",

	/*  4 */	"Load address misaligned",
	/*  5 */	"Load access fault",

	/*  6 */	"Store/AMO address misaligned",
	/*  7 */	"Store/AMO access fault",

	/*  8 */	"Environment call from U-mode or VU-mode",
	/*  9 */	"Environment call from HS-mode",
	/* 10 */	"Environment call from VS-mode",
	/* 11 */	"Environment call from M-mode",

	/* 12 */	"Instruction page fault",
	/* 13 */	"Load page fault",

	/* 14 */	"Reserved",

	/* 15 */	"Store/AMO page fault",

	/* 16 */	"Reserved",
	/* 17 */	"Reserved",
	/* 18 */	"Reserved",
	/* 19 */	"Reserved",

	/* 20 */	"Instruction guest page fault",
	/* 21 */	"Load guest page fault",
	/* 22 */	"Virtual instruction",
	/* 23 */	"Store/AMO guest page fault",
};
