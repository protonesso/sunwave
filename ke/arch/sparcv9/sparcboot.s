/*	$sunwave: sparcboot.s,v 1.0 2020/07/06 00:00:00 protonesso Exp $	*/

.globl _esym
.data
	_esym:
		.word 0
		.globl romp
		.align 8
		.register %g2,	#scratch
		.register %g3,	#scratch
	romp:
		.xword 0

.text
.globl _start

/* inspired by OpenBSD */
_start:
	nop

	/* Saving rom entry point */
	mov	%o4, %g7
	set	romp, %g1
	stx	%o4, [%g1]

	/* 64-bit stack */
	btst	1, %sp
	set 	176, %g1
	bnz	1f
	set	2048-1, %g2
	andn	%sp, 0x0f, %sp
	add	%g1, %g2, %g1

1:
	sub	%sp, %g1, %g1
	save	%g1, %g0, %sp

	/*
	 * Set the psr into a known state:
	 * Set supervisor mode, interrupt level >= 13, traps enabled
	 */
	wrpr	%g0, 0, %pil
	wrpr	%g0, 0x004+0x002, %pstate

	clr	%g4

	/*
	 * Start GNU operating system
	 */
	call kmain
	nop
