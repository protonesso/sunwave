/*	$sunwave: sparcboot.c,v 1.0 2020/07/06 00:00:00 protonesso Exp $	*/

#include <main.h>

asm(
	".section .text;"
	".align 16;"
	".global _start;"
	"_start:;"
	"	call 1f;"
	"	mov %o7, %l0;"
	"1:;"
	"	call kmain;"
	"	nop;"
	"2:;"
	"	call 2b;"
	"	nop"
);
