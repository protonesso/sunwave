/*	$sunwave: openfirmware.h,v 1.0 2020/07/06 00:00:00 protonesso Exp $	*/

#ifndef OPENFIRMWARE_H
#define OPENFIRMWARE_H

int prom_cmd(char *service, unsigned fmt, ...);
void prom_halt(void);

#endif
