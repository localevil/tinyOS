ENTRY(boot)
OUTPUT_FORMAT("elf32-i386")
SECTIONS {
	. = 0x7c00;
	.text :
	{
		*(.boot);
		*(.text);
	}
	.rodata :
	{
		*(.rodata);
	}
	.data :
	{
		*(.data);
	}
	.bss :
	{
		*(.bss);
	}
}
