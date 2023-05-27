###################
# setup C runtime #
###################

.option norvc # disable compressed instructions

.globl main

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
	lui t0, %hi(isr_vector)
	add sp, sp, %lo(isr_vector)
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
	lui t0, %hi(__bss_start)
	add t0, t0, %lo(__bss_start)

	lui t1, %hi(__bss_end)
	add t1, t1, %lo(__bss_end)

	# setup stack pointer
	lui sp, %hi(__stack_top)
	add sp, sp, %lo(__stack_top)

	

bss_clear:
	sw zero, (t0)
	add t0, t0, 4
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

	addi sp, sp, -(4*35)

	sw x31,	(4*34)(sp)
	sw x30,	(4*33)(sp)
	sw x29,	(4*32)(sp)
	sw x28,	(4*31)(sp)
	sw x27,	(4*30)(sp)
	sw x26,	(4*29)(sp)
	sw x25,	(4*28)(sp)
	sw x24,	(4*27)(sp)
	sw x23,	(4*26)(sp)
	sw x22,	(4*25)(sp)
	sw x21,	(4*24)(sp)
	sw x20,	(4*23)(sp)
	sw x19,	(4*22)(sp)
	sw x18,	(4*21)(sp)
	sw x17,	(4*20)(sp)
	sw x16,	(4*19)(sp)
	sw x15,	(4*18)(sp)
	sw x14,	(4*17)(sp)
	sw x13,	(4*16)(sp) # a3
	sw x12,	(4*15)(sp) # a2
	sw x11,	(4*14)(sp) # a1
	sw x10,	(4*13)(sp) # a0
	sw x9,	(4*12)(sp)
	sw x8,	(4*11)(sp)
	sw x7,	(4*10)(sp)
	sw x6,	(4* 9)(sp)
	sw x5,	(4* 8)(sp)
	sw x4,	(4* 7)(sp)
	sw x3,	(4* 6)(sp)
	sw x2,	(4* 5)(sp) # sp
	sw x1,	(4* 4)(sp) # ra

	csrr s0, mcause
	sw s0,	(4* 2)(sp)

	csrr s1, mstatus
	sw s1,	(4 *1)(sp)

	csrr s2, mepc
	sw s2,	(4 *0)(sp)

	# call interrupt handler
	mv a0, sp
	jal trap_handler
	mv sp, a0


	lw s0,	(4* 0)(sp)
	csrw mepc, s0

	lw s0,	(4* 1)(sp)
	csrw mstatus, s0

	lw x1,	(4* 4)(sp)

	lw x3,	(4* 6)(sp)
	lw x4,	(4* 7)(sp)
	lw x5,	(4* 8)(sp)
	lw x6,	(4* 9)(sp)
	lw x7,	(4*10)(sp)
	lw x8,	(4*11)(sp)
	lw x9,	(4*12)(sp)
	lw x10, (4*13)(sp)
	lw x11, (4*14)(sp)
	lw x12, (4*15)(sp)
	lw x13, (4*16)(sp)
	lw x14, (4*17)(sp)
	lw x15, (4*18)(sp)
	lw x16, (4*19)(sp)
	lw x17, (4*20)(sp)
	lw x18, (4*21)(sp)
	lw x19, (4*22)(sp)
	lw x20, (4*23)(sp)
	lw x21, (4*24)(sp)
	lw x22, (4*25)(sp)
	lw x23, (4*26)(sp)
	lw x24, (4*27)(sp)
	lw x25, (4*28)(sp)
	lw x26, (4*29)(sp)
	lw x27, (4*30)(sp)
	lw x28, (4*31)(sp)
	lw x29, (4*32)(sp)
	lw x30, (4*33)(sp)
	lw x31, (4*34)(sp)

	addi sp, sp, (4*35)
	csrrw sp, mscratch, sp
	mret


.section .text.abort
.globl abort

abort:
	j abort
