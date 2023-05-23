ENTRY(_enter)

MEMORY {
	/* flash */
	rom (rx)	: ORIGIN = 0x20000000,	LENGTH = 32M; /* only uses one of two chips */
	/* memory */
	ram (rw!x)	: ORIGIN = 0x80000000,	LENGTH = 128M;
	/* system control area */
	ctrl (rw!x)	: ORIGIN = 0xF0000000,	LENGTH = 256M;
}

SECTIONS { /* alignment for riscv32 */
	.init : {
		KEEP (*(.init.enter));
	} >rom
	.text : ALIGN(4) {
		*(.text); *(.text.*);
	} >rom

	.bss (NOLOAD) : ALIGN(4) {
		*(.bss); *(.bss.*);
	} >ram

	.data : ALIGN(4) {
		*(.data); *(.data.*);
		PROVIDE(__global_pointer$ = . + 2M);
	} >ram AT>rom

	.rodata : ALIGN(4) {
		*(.rodata); *(.rodata.*);
	} >rom
}

SECTIONS {
	/*PROVIDE(__executable_start = TODO);*/
	PROVIDE(__stack_top = ORIGIN(ram) + LENGTH(ram));

	PROVIDE(__bss_src) = LOADADDR(.bss));
	PROVIDE(__bss_start = ADDR(.bss));
	PROVIDE(__bss_end = ADDR(.bss) + SIZEOF(.bss));
}
