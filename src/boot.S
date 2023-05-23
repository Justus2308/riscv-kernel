.section .init, "ax"
.globl _start

_start:
	lui ra, %hi(_start_abs)
	jr %lo(_start_abs)(ra)

_start_abs:
	.cfi_startproc
	.cfi_undefined ra

	li x1, 0
	li x2, 0
	li x3, 0
	li x4, 0
	li x5, 0
	li x6, 0
	li x7, 0
	li x8, 0
	li x9, 0
	/* skip a0, a1 */
	li x12, 0
	li x13, 0
	li x14, 0
	li x15, 0
	li x16, 0
	li x17, 0
	li x18, 0
	li x19, 0
	li x20, 0
	li x21, 0
	li x22, 0
	li x23, 0
	li x24, 0
	li x25, 0
	li x26, 0
	li x27, 0
	li x28, 0
	li x29, 0
	li x30, 0
	li x31, 0

	.option push
	.option norelax

	la gp, __global_ptr$

	.option pop

	#ifdef SMODE
	mv t2, a0
	#else
	csrr t2, mhartid
	#endif

	lui t0, %hi(_max_hart_id)
	add t0, t0, %lo(_max_hart_id)
	bgtu t2, t0, abort

	/* stack */
	la sp, __stack_top
	lui t0, %hi(_hart_stack_size)
	add t0, t0, %lo(_hart_stack_size)



	.cfi_endproc


/* load boot trap vector */
	la t0, boot_trap_vector
	csrw mtvec, t0

.section .trap, "ax"
.align 2

boot_trap_vector:
	.cfi_startproc
	csrr t0, mcause
	csrr t1, mepc
	csrr t2, mtval
	j boot_trap_vector
	.cfi_endproc

.section .text.abort
.globl abort

abort:
	j abort
