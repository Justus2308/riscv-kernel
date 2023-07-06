#pragma once

#define NULL (void*)0
#define true 1
#define false 0

extern unsigned long read_csr(unsigned long reg);

extern void *memset(void *mptr, int c, unsigned long len);
