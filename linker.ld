ENTRY(_Reset)
SECTIONS
{
	. = ALIGN(16);
	. = 0x40000000;
	.startup . : { build/boot.o(.text) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss COMMON) }
	. = . + 0x1000; /* 4kB of stack memory */
	stack_top = .;
}
