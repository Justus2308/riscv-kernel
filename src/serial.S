#define RHR 0
#define THR 0
#define IER 1
#define FCR 2
#define ISR 2
#define LCR 3
#define LSR 5

.globl uart_init
.globl uart_putc
.globl uart_getc

.rodata
divisor_enable:		.byte 0b10000000
baud_rate:		.byte 0b00000011
word_length:		.byte 0b00000011
fifo_reset:		.byte 0b00000111
interrupt_enable:	.byte 0b00000011

uart_init:
	.cfi_startproc

	lui t0, %hi(__uart_base)
	addi t0, %lo(__uart_base)

	# disable interrupts
	sb zero, IER(t0)

	# enable divisor latch to set baud rate
	lb t1, divisor_enable
	sb t1, LCR(t0)

	# set baud rate to 38.4K
	lb t1, baud_rate
	sb t1, RHR(t0)

	# disable divisor latch ; set word length to 8 bits
	lb t1, word_length
	sb t1, LCR(t0)

	# reset and enable FIFO
	lb t1, fifo_reset
	sb t1, FCR(t0)

	# enable interrupts
	lb t1, interrupt_enable
	sb t1, IER(t0)

	.cfi_endproc


uart_putc: # char from a0
	.cfi_startproc

	addi sp, sp, -16
	sw fp, 12(sp)
	addi fp, sp, 16
	mv a5, a0
	# sb a5, -9(fp)

	lui t0, %hi(__uart_base)
	addi t0, %lo(__uart_base)

	sb a5, THR(t0)

	# TODO #

	.cfi_endproc


uart_getc:
	.cfi_startproc

	addi sp, sp, -8
	sw fp, 4(sp)
	addi fp, sp, 8

	# TODO #

	.cfi_endproc


.end
