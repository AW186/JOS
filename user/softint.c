// buggy program - causes an illegal software interrupt

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $13");	// GP, not page fault
}

