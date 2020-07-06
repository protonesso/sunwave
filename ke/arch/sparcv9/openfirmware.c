/*	$sunwave: openfirmware.c,v 1.0 2020/07/06 00:00:00 protonesso Exp $	*/

#include <openfirmware.h>
#include <stdarg.h>

void (*prom_cif_handler)(long long *);
void (*prom_cif_h32)(long *);
void *prom_cif_stack;

static long long p1275_args[23];

void prom_halt(void) {
	prom_cmd ("exit", 0);
}

int prom_cmd(char *service, unsigned fmt, ...) {
	va_list list;
	int i;
	int args = fmt & 0xf;

	fmt >>= 8;

	/* This means we have a P1275 PROM on a 32-bit machine. There
	 * better not be any 64-bit arguments. */
	if (prom_cif_handler == 0) {
		long *p1275_args32 = (long *)p1275_args;

		if (fmt)
			prom_halt();

		p1275_args32[0] = (long)service;
		p1275_args32[1] = args;
		p1275_args32[2] = 1;
		va_start (list, fmt);
		for (i = 0; i < args; i++)
			p1275_args32[i + 3] = (long) va_arg (list, char *);
		va_end (list);
		(*prom_cif_h32)(p1275_args32);
		return p1275_args32[3 + args];
	}

	p1275_args[0] = (unsigned long long)(unsigned long)service;
	p1275_args[1] = args;
	p1275_args[2] = 1;
	va_start (list, fmt);
	for (i = 0; i < args; i++, fmt >>= 1) {
		if (fmt & 0x1)
			p1275_args[i + 3] = va_arg (list, unsigned long long);
		else
			p1275_args[i + 3] = (unsigned long long)(unsigned long) va_arg (list, char *);
	}
	va_end (list);
	__asm__ __volatile__ ("\t"
		"mov	%1, %%g1\n\t"
		"mov	%2, %%g2\n\t"
		"save	%0, -0xc0, %%sp\n\t"
		"rdpr	%%pstate, %%l1\n\t"
		"andn	%%l1, 8, %%l1\n\t"
		"wrpr	%%l1, 0, %%pstate\n\t"
		"call	%%g1\n\t"
		" mov	%%g2, %%o0\n\t"
		"wrpr	%%l1, 8, %%pstate\n\t"
		"restore\n"
	: : "r" (prom_cif_stack), "r" (prom_cif_handler), "r" (p1275_args) :
	"o0", "o1", "o2", "o3", "o4", "o5", "o7", "g1", "g2", "g3", "g4",
	"g5", "g6", "g7");
	return (int) p1275_args [3 + args];
}
