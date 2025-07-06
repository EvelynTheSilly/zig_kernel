ENTRY(_Reset)
SECTIONS
{
	. = ALIGN(16);
	. = 0x40000000;
	.startup . : { build/boot.o(.text) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss COMMON) }
    .vectors ALIGN(11): {
        KEEP(*(.vectors))
    }
	. = . + 0x100000; /* 4kB of stack memory */
	stack_top = .;
}
