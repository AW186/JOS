/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
.data;					\
	.long name;			\
.text;					\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
.data;					\
	.long name;			\
.text;					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps


/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
.data
	.globl vector

vector:
	TRAPHANDLER_NOEC(v0, 0)
	TRAPHANDLER_NOEC(v1, 1)
	TRAPHANDLER_NOEC(v2, 2)
	TRAPHANDLER_NOEC(v3, 3)
	TRAPHANDLER_NOEC(v4, 4)
	TRAPHANDLER_NOEC(v5, 5)
	TRAPHANDLER_NOEC(v6, 6)
	TRAPHANDLER_NOEC(v7, 7)
	TRAPHANDLER(v8, 8)
	TRAPHANDLER_NOEC(v9, 9)
	TRAPHANDLER(v10, 10)
	TRAPHANDLER(v11, 11)
	TRAPHANDLER(v12, 12)
	TRAPHANDLER(v13, 13)
	TRAPHANDLER(v14, 14)
	TRAPHANDLER_NOEC(v15, 15)
	TRAPHANDLER_NOEC(v16, 16)
	TRAPHANDLER(v17, 17)
	TRAPHANDLER_NOEC(v18, 18)
	TRAPHANDLER_NOEC(v19, 19)
	TRAPHANDLER_NOEC(v20, 20)
	TRAPHANDLER_NOEC(v21, 21)
	TRAPHANDLER_NOEC(v22, 22)
	TRAPHANDLER_NOEC(v23, 23)
	TRAPHANDLER_NOEC(v24, 24)
	TRAPHANDLER_NOEC(v25, 25)
	TRAPHANDLER_NOEC(v26, 26)
	TRAPHANDLER_NOEC(v27, 27)
	TRAPHANDLER_NOEC(v28, 28)
	TRAPHANDLER_NOEC(v29, 29)
	TRAPHANDLER_NOEC(v30, 30)
	TRAPHANDLER_NOEC(v31, 31)
	TRAPHANDLER_NOEC(v32, 32)
	TRAPHANDLER_NOEC(v33, 33)
	TRAPHANDLER_NOEC(v34, 34)
	TRAPHANDLER_NOEC(v35, 35)
	TRAPHANDLER_NOEC(v36, 36)
	TRAPHANDLER_NOEC(v37, 37)
	TRAPHANDLER_NOEC(v38, 38)
	TRAPHANDLER_NOEC(v39, 39)
	TRAPHANDLER_NOEC(v40, 40)
	TRAPHANDLER_NOEC(v41, 41)
	TRAPHANDLER_NOEC(v42, 42)
	TRAPHANDLER_NOEC(v43, 43)
	TRAPHANDLER_NOEC(v44, 44)
	TRAPHANDLER_NOEC(v45, 45)
	TRAPHANDLER_NOEC(v46, 46)
	TRAPHANDLER_NOEC(v47, 47)
	TRAPHANDLER_NOEC(v48, 48)

/*
 * Lab 3: Your code here for _alltraps
 */
.text
_alltraps:
	pushl %ds
	pushl %es
	pushal
	pushl $GD_KD
	popl %ds
	pushl $GD_KD
	popl %es
	pushl %esp
	call trap

