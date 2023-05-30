#include "config.h"

###################
# setup C runtime #
###################

.option norvc # disable compressed instructions

.section .init, "ax"
.globl _start

_start:
	.cfi_startproc
	.cfi_undefined ra

	# reset m-mode status
	li t0, 0x1880
	csrw mstatus, t0

	# reset s-mode access
	# csrw satp, zero

	# setup interrupt vector
	la t0, __trap_handler
	csrw mtvec, t0

	# setup MIE, MIP
	csrw mip, zero
	li t0, 0x0080
	csrw mie, t0

	# setup global pointer
	.option push
	.option norelax

	la gp, __global_pointer

	.option pop

	# clear .bss
	la t0, __bss_start

	la t1, __bss_end

	# setup stack pointer
	la sp, __stack_top

	

bss_clear:
	STORE zero, (t0)
	add t0, t0, REGBYTES
	blt t0, t1, bss_clear

	# initialize registers to 0
	# x0 : hardwired zero
	li x1,	0
	li x2,	0
	li x3,	0
	li x4,	0
	li x5,	0
	li x6,	0
	li x7,	0
	li x8,	0
	li x9,	0
	li x10,	0 # a0 -> argc for main
	li x11,	0 # a1 -> argv for main
	li x12,	0
	li x13,	0
	li x14,	0
	li x15,	0
	li x16,	0
	li x17,	0
	li x18,	0
	li x19,	0
	li x20,	0
	li x21,	0
	li x22,	0
	li x23,	0
	li x24,	0
	li x25,	0
	li x26,	0
	li x27,	0
	li x28,	0
	li x29,	0
	li x30,	0
	li x31,	0

	# call kernel main
	jal kernel_main

	.cfi_endproc


######################
# setup trap handler #
######################

__trap_handler:
	csrrw sp, mscratch, sp

	addi sp, sp, -(REGBYTES*35)

	STORE x31, (REGBYTES*34)(sp)
	STORE x30, (REGBYTES*33)(sp)
	STORE x29, (REGBYTES*32)(sp)
	STORE x28, (REGBYTES*31)(sp)
	STORE x27, (REGBYTES*30)(sp)
	STORE x26, (REGBYTES*29)(sp)
	STORE x25, (REGBYTES*28)(sp)
	STORE x24, (REGBYTES*27)(sp)
	STORE x23, (REGBYTES*26)(sp)
	STORE x22, (REGBYTES*25)(sp)
	STORE x21, (REGBYTES*24)(sp)
	STORE x20, (REGBYTES*23)(sp)
	STORE x19, (REGBYTES*22)(sp)
	STORE x18, (REGBYTES*21)(sp)
	STORE x17, (REGBYTES*20)(sp)
	STORE x16, (REGBYTES*19)(sp)
	STORE x15, (REGBYTES*18)(sp)
	STORE x14, (REGBYTES*17)(sp)
	STORE x13, (REGBYTES*16)(sp) # a3
	STORE x12, (REGBYTES*15)(sp) # a2
	STORE x11, (REGBYTES*14)(sp) # a1
	STORE x10, (REGBYTES*13)(sp) # a0
	STORE x9,  (REGBYTES*12)(sp)
	STORE x8,  (REGBYTES*11)(sp)
	STORE x7,  (REGBYTES*10)(sp)
	STORE x6,  (REGBYTES* 9)(sp)
	STORE x5,  (REGBYTES* 8)(sp)
	STORE x4,  (REGBYTES* 7)(sp)
	STORE x3,  (REGBYTES* 6)(sp)
	STORE x2,  (REGBYTES* 5)(sp) # sp
	STORE x1,  (REGBYTES* 4)(sp) # ra

	csrr s0, mcause
	STORE s0,  (REGBYTES* 2)(sp)

	csrr s1, mstatus
	STORE s1,  (REGBYTES *1)(sp)

	csrr s2, mepc
	STORE s2,  (REGBYTES *0)(sp)

	# call interrupt handler
	mv a0, sp
	jal trap_handler
	mv sp, a0


	LOAD s0,  (REGBYTES* 0)(sp)
	csrw mepc, s0

	LOAD s0,  (REGBYTES* 1)(sp)
	csrw mstatus, s0

	LOAD x1,  (REGBYTES* 4)(sp)

	LOAD x3,  (REGBYTES* 6)(sp)
	LOAD x4,  (REGBYTES* 7)(sp)
	LOAD x5,  (REGBYTES* 8)(sp)
	LOAD x6,  (REGBYTES* 9)(sp)
	LOAD x7,  (REGBYTES*10)(sp)
	LOAD x8,  (REGBYTES*11)(sp)
	LOAD x9,  (REGBYTES*12)(sp)
	LOAD x10, (REGBYTES*13)(sp)
	LOAD x11, (REGBYTES*14)(sp)
	LOAD x12, (REGBYTES*15)(sp)
	LOAD x13, (REGBYTES*16)(sp)
	LOAD x14, (REGBYTES*17)(sp)
	LOAD x15, (REGBYTES*18)(sp)
	LOAD x16, (REGBYTES*19)(sp)
	LOAD x17, (REGBYTES*20)(sp)
	LOAD x18, (REGBYTES*21)(sp)
	LOAD x19, (REGBYTES*22)(sp)
	LOAD x20, (REGBYTES*23)(sp)
	LOAD x21, (REGBYTES*24)(sp)
	LOAD x22, (REGBYTES*25)(sp)
	LOAD x23, (REGBYTES*26)(sp)
	LOAD x24, (REGBYTES*27)(sp)
	LOAD x25, (REGBYTES*28)(sp)
	LOAD x26, (REGBYTES*29)(sp)
	LOAD x27, (REGBYTES*30)(sp)
	LOAD x28, (REGBYTES*31)(sp)
	LOAD x29, (REGBYTES*32)(sp)
	LOAD x30, (REGBYTES*33)(sp)
	LOAD x31, (REGBYTES*34)(sp)

	addi sp, sp, (REGBYTES*35)
	csrrw sp, mscratch, sp
	mret


.section .text.abort
.globl abort

abort:
	j abort
