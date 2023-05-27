ENTRY(_start)

. = 0x80000000

SECTIONS {
	.text : ALIGN(4K) {
		*(.init*);
		*(.text*);
	}
	.bss (NOLOAD) : ALIGN(4K) { /* does NOLOAD affext sp/gp provides? */
		PROVIDE(__bss_start = .);
		*(.bss*);
		. += 4096;
		PROVIDE(__stack_top = .);
		. += 4096;
		PROVIDE(__global_pointer = .);
		PROVIDE(__bss_end = .);
	}
	.rodata : ALIGN(4K) {
		*(.rodata*);
	}
	.data : ALIGN(4K) {
		*(.data*);
	}
}

PROVIDE(__uart_base = 0x10000000)
