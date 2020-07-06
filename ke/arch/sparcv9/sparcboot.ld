/*      $sunwave: sparcboot.ld,v 1.0 2020/07/06 00:00:00 protonesso Exp $     */

OUTPUT_FORMAT("elf64-sparc")
OUTPUT_ARCH(sparc:v9)
ENTRY(_start)
 
SECTIONS
{
	. = 0x3980;
	.main : 
	{
		*(.text*)
		*(.rodata*)
		*(.data*)
		*(.bss*)
	}
}
