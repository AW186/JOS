
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 20 12 f0       	mov    $0xf0122000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 61 00 00 00       	call   f010009f <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f0100047:	83 3d 00 b0 1e f0 00 	cmpl   $0x0,0xf01eb000
f010004e:	74 0f                	je     f010005f <_panic+0x1f>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100050:	83 ec 0c             	sub    $0xc,%esp
f0100053:	6a 00                	push   $0x0
f0100055:	e8 87 08 00 00       	call   f01008e1 <monitor>
f010005a:	83 c4 10             	add    $0x10,%esp
f010005d:	eb f1                	jmp    f0100050 <_panic+0x10>
	panicstr = fmt;
f010005f:	8b 45 10             	mov    0x10(%ebp),%eax
f0100062:	a3 00 b0 1e f0       	mov    %eax,0xf01eb000
	asm volatile("cli; cld");
f0100067:	fa                   	cli    
f0100068:	fc                   	cld    
	va_start(ap, fmt);
f0100069:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006c:	e8 37 59 00 00       	call   f01059a8 <cpunum>
f0100071:	ff 75 0c             	push   0xc(%ebp)
f0100074:	ff 75 08             	push   0x8(%ebp)
f0100077:	50                   	push   %eax
f0100078:	68 e0 5f 10 f0       	push   $0xf0105fe0
f010007d:	e8 8b 37 00 00       	call   f010380d <cprintf>
	vcprintf(fmt, ap);
f0100082:	83 c4 08             	add    $0x8,%esp
f0100085:	53                   	push   %ebx
f0100086:	ff 75 10             	push   0x10(%ebp)
f0100089:	e8 59 37 00 00       	call   f01037e7 <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 89 71 10 f0 	movl   $0xf0107189,(%esp)
f0100095:	e8 73 37 00 00       	call   f010380d <cprintf>
f010009a:	83 c4 10             	add    $0x10,%esp
f010009d:	eb b1                	jmp    f0100050 <_panic+0x10>

f010009f <i386_init>:
{
f010009f:	55                   	push   %ebp
f01000a0:	89 e5                	mov    %esp,%ebp
f01000a2:	53                   	push   %ebx
f01000a3:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a6:	e8 92 05 00 00       	call   f010063d <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000ab:	83 ec 08             	sub    $0x8,%esp
f01000ae:	68 ac 1a 00 00       	push   $0x1aac
f01000b3:	68 4c 60 10 f0       	push   $0xf010604c
f01000b8:	e8 50 37 00 00       	call   f010380d <cprintf>
	mem_init();
f01000bd:	e8 d5 11 00 00       	call   f0101297 <mem_init>
	env_init();
f01000c2:	e8 cd 2f 00 00       	call   f0103094 <env_init>
	trap_init();
f01000c7:	e8 29 38 00 00       	call   f01038f5 <trap_init>
	mp_init();
f01000cc:	e8 f1 55 00 00       	call   f01056c2 <mp_init>
	lapic_init();
f01000d1:	e8 e8 58 00 00       	call   f01059be <lapic_init>
	pic_init();
f01000d6:	e8 53 36 00 00       	call   f010372e <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000db:	c7 04 24 80 44 12 f0 	movl   $0xf0124480,(%esp)
f01000e2:	e8 31 5b 00 00       	call   f0105c18 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000e7:	83 c4 10             	add    $0x10,%esp
f01000ea:	83 3d 60 b2 1e f0 07 	cmpl   $0x7,0xf01eb260
f01000f1:	76 27                	jbe    f010011a <i386_init+0x7b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f3:	83 ec 04             	sub    $0x4,%esp
f01000f6:	b8 1e 56 10 f0       	mov    $0xf010561e,%eax
f01000fb:	2d a4 55 10 f0       	sub    $0xf01055a4,%eax
f0100100:	50                   	push   %eax
f0100101:	68 a4 55 10 f0       	push   $0xf01055a4
f0100106:	68 00 70 00 f0       	push   $0xf0007000
f010010b:	e8 ea 52 00 00       	call   f01053fa <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100110:	83 c4 10             	add    $0x10,%esp
f0100113:	bb 20 c0 22 f0       	mov    $0xf022c020,%ebx
f0100118:	eb 19                	jmp    f0100133 <i386_init+0x94>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010011a:	68 00 70 00 00       	push   $0x7000
f010011f:	68 04 60 10 f0       	push   $0xf0106004
f0100124:	6a 53                	push   $0x53
f0100126:	68 67 60 10 f0       	push   $0xf0106067
f010012b:	e8 10 ff ff ff       	call   f0100040 <_panic>
f0100130:	83 c3 74             	add    $0x74,%ebx
f0100133:	6b 05 00 c0 22 f0 74 	imul   $0x74,0xf022c000,%eax
f010013a:	05 20 c0 22 f0       	add    $0xf022c020,%eax
f010013f:	39 c3                	cmp    %eax,%ebx
f0100141:	73 4d                	jae    f0100190 <i386_init+0xf1>
		if (c == cpus + cpunum())  // We've started already.
f0100143:	e8 60 58 00 00       	call   f01059a8 <cpunum>
f0100148:	6b c0 74             	imul   $0x74,%eax,%eax
f010014b:	05 20 c0 22 f0       	add    $0xf022c020,%eax
f0100150:	39 c3                	cmp    %eax,%ebx
f0100152:	74 dc                	je     f0100130 <i386_init+0x91>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100154:	89 d8                	mov    %ebx,%eax
f0100156:	2d 20 c0 22 f0       	sub    $0xf022c020,%eax
f010015b:	c1 f8 02             	sar    $0x2,%eax
f010015e:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100164:	c1 e0 0f             	shl    $0xf,%eax
f0100167:	8d 80 00 40 1f f0    	lea    -0xfe0c000(%eax),%eax
f010016d:	a3 04 b0 1e f0       	mov    %eax,0xf01eb004
		lapic_startap(c->cpu_id, PADDR(code));
f0100172:	83 ec 08             	sub    $0x8,%esp
f0100175:	68 00 70 00 00       	push   $0x7000
f010017a:	0f b6 03             	movzbl (%ebx),%eax
f010017d:	50                   	push   %eax
f010017e:	e8 8d 59 00 00       	call   f0105b10 <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f0100183:	83 c4 10             	add    $0x10,%esp
f0100186:	8b 43 04             	mov    0x4(%ebx),%eax
f0100189:	83 f8 01             	cmp    $0x1,%eax
f010018c:	75 f8                	jne    f0100186 <i386_init+0xe7>
f010018e:	eb a0                	jmp    f0100130 <i386_init+0x91>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100190:	83 ec 08             	sub    $0x8,%esp
f0100193:	6a 01                	push   $0x1
f0100195:	68 84 8a 1a f0       	push   $0xf01a8a84
f010019a:	e8 b9 30 00 00       	call   f0103258 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010019f:	83 c4 08             	add    $0x8,%esp
f01001a2:	6a 00                	push   $0x0
f01001a4:	68 a0 a7 1d f0       	push   $0xf01da7a0
f01001a9:	e8 aa 30 00 00       	call   f0103258 <env_create>
	kbd_intr();
f01001ae:	e8 36 04 00 00       	call   f01005e9 <kbd_intr>
	sched_yield();
f01001b3:	e8 8d 3f 00 00       	call   f0104145 <sched_yield>

f01001b8 <mp_main>:
{
f01001b8:	55                   	push   %ebp
f01001b9:	89 e5                	mov    %esp,%ebp
f01001bb:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001be:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001c3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001c8:	76 52                	jbe    f010021c <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f01001ca:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001cf:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001d2:	e8 d1 57 00 00       	call   f01059a8 <cpunum>
f01001d7:	83 ec 08             	sub    $0x8,%esp
f01001da:	50                   	push   %eax
f01001db:	68 73 60 10 f0       	push   $0xf0106073
f01001e0:	e8 28 36 00 00       	call   f010380d <cprintf>
	lapic_init();
f01001e5:	e8 d4 57 00 00       	call   f01059be <lapic_init>
	env_init_percpu();
f01001ea:	e8 79 2e 00 00       	call   f0103068 <env_init_percpu>
	trap_init_percpu();
f01001ef:	e8 2d 36 00 00       	call   f0103821 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001f4:	e8 af 57 00 00       	call   f01059a8 <cpunum>
f01001f9:	6b d0 74             	imul   $0x74,%eax,%edx
f01001fc:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01001ff:	b8 01 00 00 00       	mov    $0x1,%eax
f0100204:	f0 87 82 20 c0 22 f0 	lock xchg %eax,-0xfdd3fe0(%edx)
f010020b:	c7 04 24 80 44 12 f0 	movl   $0xf0124480,(%esp)
f0100212:	e8 01 5a 00 00       	call   f0105c18 <spin_lock>
	sched_yield();
f0100217:	e8 29 3f 00 00       	call   f0104145 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010021c:	50                   	push   %eax
f010021d:	68 28 60 10 f0       	push   $0xf0106028
f0100222:	6a 6a                	push   $0x6a
f0100224:	68 67 60 10 f0       	push   $0xf0106067
f0100229:	e8 12 fe ff ff       	call   f0100040 <_panic>

f010022e <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010022e:	55                   	push   %ebp
f010022f:	89 e5                	mov    %esp,%ebp
f0100231:	53                   	push   %ebx
f0100232:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100235:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100238:	ff 75 0c             	push   0xc(%ebp)
f010023b:	ff 75 08             	push   0x8(%ebp)
f010023e:	68 89 60 10 f0       	push   $0xf0106089
f0100243:	e8 c5 35 00 00       	call   f010380d <cprintf>
	vcprintf(fmt, ap);
f0100248:	83 c4 08             	add    $0x8,%esp
f010024b:	53                   	push   %ebx
f010024c:	ff 75 10             	push   0x10(%ebp)
f010024f:	e8 93 35 00 00       	call   f01037e7 <vcprintf>
	cprintf("\n");
f0100254:	c7 04 24 89 71 10 f0 	movl   $0xf0107189,(%esp)
f010025b:	e8 ad 35 00 00       	call   f010380d <cprintf>
	va_end(ap);
}
f0100260:	83 c4 10             	add    $0x10,%esp
f0100263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100266:	c9                   	leave  
f0100267:	c3                   	ret    

f0100268 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100268:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010026d:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010026e:	a8 01                	test   $0x1,%al
f0100270:	74 0a                	je     f010027c <serial_proc_data+0x14>
f0100272:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100277:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100278:	0f b6 c0             	movzbl %al,%eax
f010027b:	c3                   	ret    
		return -1;
f010027c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100281:	c3                   	ret    

f0100282 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100282:	55                   	push   %ebp
f0100283:	89 e5                	mov    %esp,%ebp
f0100285:	53                   	push   %ebx
f0100286:	83 ec 04             	sub    $0x4,%esp
f0100289:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010028b:	eb 23                	jmp    f01002b0 <cons_intr+0x2e>
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f010028d:	8b 0d 44 b2 1e f0    	mov    0xf01eb244,%ecx
f0100293:	8d 51 01             	lea    0x1(%ecx),%edx
f0100296:	88 81 40 b0 1e f0    	mov    %al,-0xfe14fc0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f010029c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002a2:	b8 00 00 00 00       	mov    $0x0,%eax
f01002a7:	0f 44 d0             	cmove  %eax,%edx
f01002aa:	89 15 44 b2 1e f0    	mov    %edx,0xf01eb244
	while ((c = (*proc)()) != -1) {
f01002b0:	ff d3                	call   *%ebx
f01002b2:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002b5:	74 06                	je     f01002bd <cons_intr+0x3b>
		if (c == 0)
f01002b7:	85 c0                	test   %eax,%eax
f01002b9:	75 d2                	jne    f010028d <cons_intr+0xb>
f01002bb:	eb f3                	jmp    f01002b0 <cons_intr+0x2e>
	}
}
f01002bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002c0:	c9                   	leave  
f01002c1:	c3                   	ret    

f01002c2 <kbd_proc_data>:
{
f01002c2:	55                   	push   %ebp
f01002c3:	89 e5                	mov    %esp,%ebp
f01002c5:	53                   	push   %ebx
f01002c6:	83 ec 04             	sub    $0x4,%esp
f01002c9:	ba 64 00 00 00       	mov    $0x64,%edx
f01002ce:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002cf:	a8 01                	test   $0x1,%al
f01002d1:	0f 84 ee 00 00 00    	je     f01003c5 <kbd_proc_data+0x103>
	if (stat & KBS_TERR)
f01002d7:	a8 20                	test   $0x20,%al
f01002d9:	0f 85 ed 00 00 00    	jne    f01003cc <kbd_proc_data+0x10a>
f01002df:	ba 60 00 00 00       	mov    $0x60,%edx
f01002e4:	ec                   	in     (%dx),%al
f01002e5:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002e7:	3c e0                	cmp    $0xe0,%al
f01002e9:	74 61                	je     f010034c <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01002eb:	84 c0                	test   %al,%al
f01002ed:	78 70                	js     f010035f <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01002ef:	8b 0d 20 b0 1e f0    	mov    0xf01eb020,%ecx
f01002f5:	f6 c1 40             	test   $0x40,%cl
f01002f8:	74 0e                	je     f0100308 <kbd_proc_data+0x46>
		data |= 0x80;
f01002fa:	83 c8 80             	or     $0xffffff80,%eax
f01002fd:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002ff:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100302:	89 0d 20 b0 1e f0    	mov    %ecx,0xf01eb020
	shift |= shiftcode[data];
f0100308:	0f b6 d2             	movzbl %dl,%edx
f010030b:	0f b6 82 00 62 10 f0 	movzbl -0xfef9e00(%edx),%eax
f0100312:	0b 05 20 b0 1e f0    	or     0xf01eb020,%eax
	shift ^= togglecode[data];
f0100318:	0f b6 8a 00 61 10 f0 	movzbl -0xfef9f00(%edx),%ecx
f010031f:	31 c8                	xor    %ecx,%eax
f0100321:	a3 20 b0 1e f0       	mov    %eax,0xf01eb020
	c = charcode[shift & (CTL | SHIFT)][data];
f0100326:	89 c1                	mov    %eax,%ecx
f0100328:	83 e1 03             	and    $0x3,%ecx
f010032b:	8b 0c 8d e0 60 10 f0 	mov    -0xfef9f20(,%ecx,4),%ecx
f0100332:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100336:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100339:	a8 08                	test   $0x8,%al
f010033b:	74 5d                	je     f010039a <kbd_proc_data+0xd8>
		if ('a' <= c && c <= 'z')
f010033d:	89 da                	mov    %ebx,%edx
f010033f:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100342:	83 f9 19             	cmp    $0x19,%ecx
f0100345:	77 47                	ja     f010038e <kbd_proc_data+0xcc>
			c += 'A' - 'a';
f0100347:	83 eb 20             	sub    $0x20,%ebx
f010034a:	eb 0c                	jmp    f0100358 <kbd_proc_data+0x96>
		shift |= E0ESC;
f010034c:	83 0d 20 b0 1e f0 40 	orl    $0x40,0xf01eb020
		return 0;
f0100353:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100358:	89 d8                	mov    %ebx,%eax
f010035a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010035d:	c9                   	leave  
f010035e:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010035f:	8b 0d 20 b0 1e f0    	mov    0xf01eb020,%ecx
f0100365:	83 e0 7f             	and    $0x7f,%eax
f0100368:	f6 c1 40             	test   $0x40,%cl
f010036b:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010036e:	0f b6 d2             	movzbl %dl,%edx
f0100371:	0f b6 82 00 62 10 f0 	movzbl -0xfef9e00(%edx),%eax
f0100378:	83 c8 40             	or     $0x40,%eax
f010037b:	0f b6 c0             	movzbl %al,%eax
f010037e:	f7 d0                	not    %eax
f0100380:	21 c8                	and    %ecx,%eax
f0100382:	a3 20 b0 1e f0       	mov    %eax,0xf01eb020
		return 0;
f0100387:	bb 00 00 00 00       	mov    $0x0,%ebx
f010038c:	eb ca                	jmp    f0100358 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f010038e:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100391:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100394:	83 fa 1a             	cmp    $0x1a,%edx
f0100397:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010039a:	f7 d0                	not    %eax
f010039c:	a8 06                	test   $0x6,%al
f010039e:	75 b8                	jne    f0100358 <kbd_proc_data+0x96>
f01003a0:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003a6:	75 b0                	jne    f0100358 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f01003a8:	83 ec 0c             	sub    $0xc,%esp
f01003ab:	68 a3 60 10 f0       	push   $0xf01060a3
f01003b0:	e8 58 34 00 00       	call   f010380d <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003b5:	b8 03 00 00 00       	mov    $0x3,%eax
f01003ba:	ba 92 00 00 00       	mov    $0x92,%edx
f01003bf:	ee                   	out    %al,(%dx)
}
f01003c0:	83 c4 10             	add    $0x10,%esp
f01003c3:	eb 93                	jmp    f0100358 <kbd_proc_data+0x96>
		return -1;
f01003c5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003ca:	eb 8c                	jmp    f0100358 <kbd_proc_data+0x96>
		return -1;
f01003cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003d1:	eb 85                	jmp    f0100358 <kbd_proc_data+0x96>

f01003d3 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003d3:	55                   	push   %ebp
f01003d4:	89 e5                	mov    %esp,%ebp
f01003d6:	57                   	push   %edi
f01003d7:	56                   	push   %esi
f01003d8:	53                   	push   %ebx
f01003d9:	83 ec 1c             	sub    $0x1c,%esp
f01003dc:	89 c7                	mov    %eax,%edi
	for (i = 0;
f01003de:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003e3:	be fd 03 00 00       	mov    $0x3fd,%esi
f01003e8:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003ed:	89 f2                	mov    %esi,%edx
f01003ef:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003f0:	a8 20                	test   $0x20,%al
f01003f2:	75 13                	jne    f0100407 <cons_putc+0x34>
f01003f4:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01003fa:	7f 0b                	jg     f0100407 <cons_putc+0x34>
f01003fc:	89 ca                	mov    %ecx,%edx
f01003fe:	ec                   	in     (%dx),%al
f01003ff:	ec                   	in     (%dx),%al
f0100400:	ec                   	in     (%dx),%al
f0100401:	ec                   	in     (%dx),%al
	     i++)
f0100402:	83 c3 01             	add    $0x1,%ebx
f0100405:	eb e6                	jmp    f01003ed <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f0100407:	89 f8                	mov    %edi,%eax
f0100409:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010040c:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100411:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100412:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100417:	be 79 03 00 00       	mov    $0x379,%esi
f010041c:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100421:	89 f2                	mov    %esi,%edx
f0100423:	ec                   	in     (%dx),%al
f0100424:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010042a:	7f 0f                	jg     f010043b <cons_putc+0x68>
f010042c:	84 c0                	test   %al,%al
f010042e:	78 0b                	js     f010043b <cons_putc+0x68>
f0100430:	89 ca                	mov    %ecx,%edx
f0100432:	ec                   	in     (%dx),%al
f0100433:	ec                   	in     (%dx),%al
f0100434:	ec                   	in     (%dx),%al
f0100435:	ec                   	in     (%dx),%al
f0100436:	83 c3 01             	add    $0x1,%ebx
f0100439:	eb e6                	jmp    f0100421 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010043b:	ba 78 03 00 00       	mov    $0x378,%edx
f0100440:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100444:	ee                   	out    %al,(%dx)
f0100445:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010044a:	b8 0d 00 00 00       	mov    $0xd,%eax
f010044f:	ee                   	out    %al,(%dx)
f0100450:	b8 08 00 00 00       	mov    $0x8,%eax
f0100455:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f0100456:	89 f8                	mov    %edi,%eax
f0100458:	80 cc 07             	or     $0x7,%ah
f010045b:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100461:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f0100464:	89 f8                	mov    %edi,%eax
f0100466:	0f b6 c0             	movzbl %al,%eax
f0100469:	89 fb                	mov    %edi,%ebx
f010046b:	80 fb 0a             	cmp    $0xa,%bl
f010046e:	0f 84 e1 00 00 00    	je     f0100555 <cons_putc+0x182>
f0100474:	83 f8 0a             	cmp    $0xa,%eax
f0100477:	7f 46                	jg     f01004bf <cons_putc+0xec>
f0100479:	83 f8 08             	cmp    $0x8,%eax
f010047c:	0f 84 a7 00 00 00    	je     f0100529 <cons_putc+0x156>
f0100482:	83 f8 09             	cmp    $0x9,%eax
f0100485:	0f 85 d7 00 00 00    	jne    f0100562 <cons_putc+0x18f>
		cons_putc(' ');
f010048b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100490:	e8 3e ff ff ff       	call   f01003d3 <cons_putc>
		cons_putc(' ');
f0100495:	b8 20 00 00 00       	mov    $0x20,%eax
f010049a:	e8 34 ff ff ff       	call   f01003d3 <cons_putc>
		cons_putc(' ');
f010049f:	b8 20 00 00 00       	mov    $0x20,%eax
f01004a4:	e8 2a ff ff ff       	call   f01003d3 <cons_putc>
		cons_putc(' ');
f01004a9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ae:	e8 20 ff ff ff       	call   f01003d3 <cons_putc>
		cons_putc(' ');
f01004b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b8:	e8 16 ff ff ff       	call   f01003d3 <cons_putc>
		break;
f01004bd:	eb 25                	jmp    f01004e4 <cons_putc+0x111>
	switch (c & 0xff) {
f01004bf:	83 f8 0d             	cmp    $0xd,%eax
f01004c2:	0f 85 9a 00 00 00    	jne    f0100562 <cons_putc+0x18f>
		crt_pos -= (crt_pos % CRT_COLS);
f01004c8:	0f b7 05 48 b2 1e f0 	movzwl 0xf01eb248,%eax
f01004cf:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004d5:	c1 e8 16             	shr    $0x16,%eax
f01004d8:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004db:	c1 e0 04             	shl    $0x4,%eax
f01004de:	66 a3 48 b2 1e f0    	mov    %ax,0xf01eb248
	if (crt_pos >= CRT_SIZE) {
f01004e4:	66 81 3d 48 b2 1e f0 	cmpw   $0x7cf,0xf01eb248
f01004eb:	cf 07 
f01004ed:	0f 87 92 00 00 00    	ja     f0100585 <cons_putc+0x1b2>
	outb(addr_6845, 14);
f01004f3:	8b 0d 50 b2 1e f0    	mov    0xf01eb250,%ecx
f01004f9:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004fe:	89 ca                	mov    %ecx,%edx
f0100500:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100501:	0f b7 1d 48 b2 1e f0 	movzwl 0xf01eb248,%ebx
f0100508:	8d 71 01             	lea    0x1(%ecx),%esi
f010050b:	89 d8                	mov    %ebx,%eax
f010050d:	66 c1 e8 08          	shr    $0x8,%ax
f0100511:	89 f2                	mov    %esi,%edx
f0100513:	ee                   	out    %al,(%dx)
f0100514:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100519:	89 ca                	mov    %ecx,%edx
f010051b:	ee                   	out    %al,(%dx)
f010051c:	89 d8                	mov    %ebx,%eax
f010051e:	89 f2                	mov    %esi,%edx
f0100520:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100521:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100524:	5b                   	pop    %ebx
f0100525:	5e                   	pop    %esi
f0100526:	5f                   	pop    %edi
f0100527:	5d                   	pop    %ebp
f0100528:	c3                   	ret    
		if (crt_pos > 0) {
f0100529:	0f b7 05 48 b2 1e f0 	movzwl 0xf01eb248,%eax
f0100530:	66 85 c0             	test   %ax,%ax
f0100533:	74 be                	je     f01004f3 <cons_putc+0x120>
			crt_pos--;
f0100535:	83 e8 01             	sub    $0x1,%eax
f0100538:	66 a3 48 b2 1e f0    	mov    %ax,0xf01eb248
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010053e:	0f b7 c0             	movzwl %ax,%eax
f0100541:	66 81 e7 00 ff       	and    $0xff00,%di
f0100546:	83 cf 20             	or     $0x20,%edi
f0100549:	8b 15 4c b2 1e f0    	mov    0xf01eb24c,%edx
f010054f:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100553:	eb 8f                	jmp    f01004e4 <cons_putc+0x111>
		crt_pos += CRT_COLS;
f0100555:	66 83 05 48 b2 1e f0 	addw   $0x50,0xf01eb248
f010055c:	50 
f010055d:	e9 66 ff ff ff       	jmp    f01004c8 <cons_putc+0xf5>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100562:	0f b7 05 48 b2 1e f0 	movzwl 0xf01eb248,%eax
f0100569:	8d 50 01             	lea    0x1(%eax),%edx
f010056c:	66 89 15 48 b2 1e f0 	mov    %dx,0xf01eb248
f0100573:	0f b7 c0             	movzwl %ax,%eax
f0100576:	8b 15 4c b2 1e f0    	mov    0xf01eb24c,%edx
f010057c:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f0100580:	e9 5f ff ff ff       	jmp    f01004e4 <cons_putc+0x111>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100585:	a1 4c b2 1e f0       	mov    0xf01eb24c,%eax
f010058a:	83 ec 04             	sub    $0x4,%esp
f010058d:	68 00 0f 00 00       	push   $0xf00
f0100592:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100598:	52                   	push   %edx
f0100599:	50                   	push   %eax
f010059a:	e8 5b 4e 00 00       	call   f01053fa <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010059f:	8b 15 4c b2 1e f0    	mov    0xf01eb24c,%edx
f01005a5:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005ab:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005b1:	83 c4 10             	add    $0x10,%esp
f01005b4:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005b9:	83 c0 02             	add    $0x2,%eax
f01005bc:	39 d0                	cmp    %edx,%eax
f01005be:	75 f4                	jne    f01005b4 <cons_putc+0x1e1>
		crt_pos -= CRT_COLS;
f01005c0:	66 83 2d 48 b2 1e f0 	subw   $0x50,0xf01eb248
f01005c7:	50 
f01005c8:	e9 26 ff ff ff       	jmp    f01004f3 <cons_putc+0x120>

f01005cd <serial_intr>:
	if (serial_exists)
f01005cd:	80 3d 54 b2 1e f0 00 	cmpb   $0x0,0xf01eb254
f01005d4:	75 01                	jne    f01005d7 <serial_intr+0xa>
f01005d6:	c3                   	ret    
{
f01005d7:	55                   	push   %ebp
f01005d8:	89 e5                	mov    %esp,%ebp
f01005da:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005dd:	b8 68 02 10 f0       	mov    $0xf0100268,%eax
f01005e2:	e8 9b fc ff ff       	call   f0100282 <cons_intr>
}
f01005e7:	c9                   	leave  
f01005e8:	c3                   	ret    

f01005e9 <kbd_intr>:
{
f01005e9:	55                   	push   %ebp
f01005ea:	89 e5                	mov    %esp,%ebp
f01005ec:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005ef:	b8 c2 02 10 f0       	mov    $0xf01002c2,%eax
f01005f4:	e8 89 fc ff ff       	call   f0100282 <cons_intr>
}
f01005f9:	c9                   	leave  
f01005fa:	c3                   	ret    

f01005fb <cons_getc>:
{
f01005fb:	55                   	push   %ebp
f01005fc:	89 e5                	mov    %esp,%ebp
f01005fe:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100601:	e8 c7 ff ff ff       	call   f01005cd <serial_intr>
	kbd_intr();
f0100606:	e8 de ff ff ff       	call   f01005e9 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010060b:	a1 40 b2 1e f0       	mov    0xf01eb240,%eax
	return 0;
f0100610:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100615:	3b 05 44 b2 1e f0    	cmp    0xf01eb244,%eax
f010061b:	74 1c                	je     f0100639 <cons_getc+0x3e>
		c = cons.buf[cons.rpos++];
f010061d:	8d 48 01             	lea    0x1(%eax),%ecx
f0100620:	0f b6 90 40 b0 1e f0 	movzbl -0xfe14fc0(%eax),%edx
			cons.rpos = 0;
f0100627:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f010062c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100631:	0f 45 c1             	cmovne %ecx,%eax
f0100634:	a3 40 b2 1e f0       	mov    %eax,0xf01eb240
}
f0100639:	89 d0                	mov    %edx,%eax
f010063b:	c9                   	leave  
f010063c:	c3                   	ret    

f010063d <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010063d:	55                   	push   %ebp
f010063e:	89 e5                	mov    %esp,%ebp
f0100640:	57                   	push   %edi
f0100641:	56                   	push   %esi
f0100642:	53                   	push   %ebx
f0100643:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100646:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010064d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100654:	5a a5 
	if (*cp != 0xA55A) {
f0100656:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010065d:	bb b4 03 00 00       	mov    $0x3b4,%ebx
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100662:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	if (*cp != 0xA55A) {
f0100667:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010066b:	0f 84 cd 00 00 00    	je     f010073e <cons_init+0x101>
		addr_6845 = MONO_BASE;
f0100671:	89 1d 50 b2 1e f0    	mov    %ebx,0xf01eb250
f0100677:	b8 0e 00 00 00       	mov    $0xe,%eax
f010067c:	89 da                	mov    %ebx,%edx
f010067e:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010067f:	8d 7b 01             	lea    0x1(%ebx),%edi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100682:	89 fa                	mov    %edi,%edx
f0100684:	ec                   	in     (%dx),%al
f0100685:	0f b6 c8             	movzbl %al,%ecx
f0100688:	c1 e1 08             	shl    $0x8,%ecx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010068b:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100690:	89 da                	mov    %ebx,%edx
f0100692:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100693:	89 fa                	mov    %edi,%edx
f0100695:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100696:	89 35 4c b2 1e f0    	mov    %esi,0xf01eb24c
	pos |= inb(addr_6845 + 1);
f010069c:	0f b6 c0             	movzbl %al,%eax
f010069f:	09 c8                	or     %ecx,%eax
	crt_pos = pos;
f01006a1:	66 a3 48 b2 1e f0    	mov    %ax,0xf01eb248
	kbd_intr();
f01006a7:	e8 3d ff ff ff       	call   f01005e9 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006ac:	83 ec 0c             	sub    $0xc,%esp
f01006af:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01006b6:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006bb:	50                   	push   %eax
f01006bc:	e8 ea 2f 00 00       	call   f01036ab <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006c1:	b9 00 00 00 00       	mov    $0x0,%ecx
f01006c6:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f01006cb:	89 c8                	mov    %ecx,%eax
f01006cd:	89 da                	mov    %ebx,%edx
f01006cf:	ee                   	out    %al,(%dx)
f01006d0:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006d5:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006da:	89 fa                	mov    %edi,%edx
f01006dc:	ee                   	out    %al,(%dx)
f01006dd:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006e2:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006e7:	ee                   	out    %al,(%dx)
f01006e8:	be f9 03 00 00       	mov    $0x3f9,%esi
f01006ed:	89 c8                	mov    %ecx,%eax
f01006ef:	89 f2                	mov    %esi,%edx
f01006f1:	ee                   	out    %al,(%dx)
f01006f2:	b8 03 00 00 00       	mov    $0x3,%eax
f01006f7:	89 fa                	mov    %edi,%edx
f01006f9:	ee                   	out    %al,(%dx)
f01006fa:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01006ff:	89 c8                	mov    %ecx,%eax
f0100701:	ee                   	out    %al,(%dx)
f0100702:	b8 01 00 00 00       	mov    $0x1,%eax
f0100707:	89 f2                	mov    %esi,%edx
f0100709:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010070a:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010070f:	ec                   	in     (%dx),%al
f0100710:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100712:	83 c4 10             	add    $0x10,%esp
f0100715:	3c ff                	cmp    $0xff,%al
f0100717:	0f 95 05 54 b2 1e f0 	setne  0xf01eb254
f010071e:	89 da                	mov    %ebx,%edx
f0100720:	ec                   	in     (%dx),%al
f0100721:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100726:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100727:	80 f9 ff             	cmp    $0xff,%cl
f010072a:	75 28                	jne    f0100754 <cons_init+0x117>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010072c:	83 ec 0c             	sub    $0xc,%esp
f010072f:	68 af 60 10 f0       	push   $0xf01060af
f0100734:	e8 d4 30 00 00       	call   f010380d <cprintf>
f0100739:	83 c4 10             	add    $0x10,%esp
}
f010073c:	eb 37                	jmp    f0100775 <cons_init+0x138>
		*cp = was;
f010073e:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f0100745:	bb d4 03 00 00       	mov    $0x3d4,%ebx
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010074a:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010074f:	e9 1d ff ff ff       	jmp    f0100671 <cons_init+0x34>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100754:	83 ec 0c             	sub    $0xc,%esp
f0100757:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f010075e:	25 ef ff 00 00       	and    $0xffef,%eax
f0100763:	50                   	push   %eax
f0100764:	e8 42 2f 00 00       	call   f01036ab <irq_setmask_8259A>
	if (!serial_exists)
f0100769:	83 c4 10             	add    $0x10,%esp
f010076c:	80 3d 54 b2 1e f0 00 	cmpb   $0x0,0xf01eb254
f0100773:	74 b7                	je     f010072c <cons_init+0xef>
}
f0100775:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100778:	5b                   	pop    %ebx
f0100779:	5e                   	pop    %esi
f010077a:	5f                   	pop    %edi
f010077b:	5d                   	pop    %ebp
f010077c:	c3                   	ret    

f010077d <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010077d:	55                   	push   %ebp
f010077e:	89 e5                	mov    %esp,%ebp
f0100780:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100783:	8b 45 08             	mov    0x8(%ebp),%eax
f0100786:	e8 48 fc ff ff       	call   f01003d3 <cons_putc>
}
f010078b:	c9                   	leave  
f010078c:	c3                   	ret    

f010078d <getchar>:

int
getchar(void)
{
f010078d:	55                   	push   %ebp
f010078e:	89 e5                	mov    %esp,%ebp
f0100790:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100793:	e8 63 fe ff ff       	call   f01005fb <cons_getc>
f0100798:	85 c0                	test   %eax,%eax
f010079a:	74 f7                	je     f0100793 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010079c:	c9                   	leave  
f010079d:	c3                   	ret    

f010079e <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f010079e:	b8 01 00 00 00       	mov    $0x1,%eax
f01007a3:	c3                   	ret    

f01007a4 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007a4:	55                   	push   %ebp
f01007a5:	89 e5                	mov    %esp,%ebp
f01007a7:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007aa:	68 00 63 10 f0       	push   $0xf0106300
f01007af:	68 1e 63 10 f0       	push   $0xf010631e
f01007b4:	68 23 63 10 f0       	push   $0xf0106323
f01007b9:	e8 4f 30 00 00       	call   f010380d <cprintf>
f01007be:	83 c4 0c             	add    $0xc,%esp
f01007c1:	68 c8 63 10 f0       	push   $0xf01063c8
f01007c6:	68 2c 63 10 f0       	push   $0xf010632c
f01007cb:	68 23 63 10 f0       	push   $0xf0106323
f01007d0:	e8 38 30 00 00       	call   f010380d <cprintf>
	return 0;
}
f01007d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01007da:	c9                   	leave  
f01007db:	c3                   	ret    

f01007dc <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007dc:	55                   	push   %ebp
f01007dd:	89 e5                	mov    %esp,%ebp
f01007df:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007e2:	68 35 63 10 f0       	push   $0xf0106335
f01007e7:	e8 21 30 00 00       	call   f010380d <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01007ec:	83 c4 08             	add    $0x8,%esp
f01007ef:	68 0c 00 10 00       	push   $0x10000c
f01007f4:	68 f0 63 10 f0       	push   $0xf01063f0
f01007f9:	e8 0f 30 00 00       	call   f010380d <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007fe:	83 c4 0c             	add    $0xc,%esp
f0100801:	68 0c 00 10 00       	push   $0x10000c
f0100806:	68 0c 00 10 f0       	push   $0xf010000c
f010080b:	68 18 64 10 f0       	push   $0xf0106418
f0100810:	e8 f8 2f 00 00       	call   f010380d <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100815:	83 c4 0c             	add    $0xc,%esp
f0100818:	68 d1 5f 10 00       	push   $0x105fd1
f010081d:	68 d1 5f 10 f0       	push   $0xf0105fd1
f0100822:	68 3c 64 10 f0       	push   $0xf010643c
f0100827:	e8 e1 2f 00 00       	call   f010380d <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010082c:	83 c4 0c             	add    $0xc,%esp
f010082f:	68 00 b0 1e 00       	push   $0x1eb000
f0100834:	68 00 b0 1e f0       	push   $0xf01eb000
f0100839:	68 60 64 10 f0       	push   $0xf0106460
f010083e:	e8 ca 2f 00 00       	call   f010380d <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100843:	83 c4 0c             	add    $0xc,%esp
f0100846:	68 c8 c3 22 00       	push   $0x22c3c8
f010084b:	68 c8 c3 22 f0       	push   $0xf022c3c8
f0100850:	68 84 64 10 f0       	push   $0xf0106484
f0100855:	e8 b3 2f 00 00       	call   f010380d <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010085a:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010085d:	b8 c8 c3 22 f0       	mov    $0xf022c3c8,%eax
f0100862:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100867:	c1 f8 0a             	sar    $0xa,%eax
f010086a:	50                   	push   %eax
f010086b:	68 a8 64 10 f0       	push   $0xf01064a8
f0100870:	e8 98 2f 00 00       	call   f010380d <cprintf>
	return 0;
}
f0100875:	b8 00 00 00 00       	mov    $0x0,%eax
f010087a:	c9                   	leave  
f010087b:	c3                   	ret    

f010087c <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010087c:	55                   	push   %ebp
f010087d:	89 e5                	mov    %esp,%ebp
f010087f:	56                   	push   %esi
f0100880:	53                   	push   %ebx
f0100881:	83 ec 2c             	sub    $0x2c,%esp
	// Your code here.	
	cprintf("Stack backtrace:\n");
f0100884:	68 4e 63 10 f0       	push   $0xf010634e
f0100889:	e8 7f 2f 00 00       	call   f010380d <cprintf>
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010088e:	89 eb                	mov    %ebp,%ebx
	uint32_t ebp = read_ebp();
	struct Eipdebuginfo info;
	while (ebp) {
f0100890:	83 c4 10             	add    $0x10,%esp
		uint32_t *myArg = (uint32_t *)ebp;
		cprintf(" ebp %08x eip %08x args %08x\n", 
			ebp, myArg[1], myArg[2]);
		debuginfo_eip(myArg[1], &info);
f0100893:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while (ebp) {
f0100896:	eb 39                	jmp    f01008d1 <mon_backtrace+0x55>
		cprintf(" ebp %08x eip %08x args %08x\n", 
f0100898:	ff 73 08             	push   0x8(%ebx)
f010089b:	ff 73 04             	push   0x4(%ebx)
f010089e:	53                   	push   %ebx
f010089f:	68 60 63 10 f0       	push   $0xf0106360
f01008a4:	e8 64 2f 00 00       	call   f010380d <cprintf>
		debuginfo_eip(myArg[1], &info);
f01008a9:	83 c4 08             	add    $0x8,%esp
f01008ac:	56                   	push   %esi
f01008ad:	ff 73 04             	push   0x4(%ebx)
f01008b0:	e8 f0 3f 00 00       	call   f01048a5 <debuginfo_eip>
		cprintf("%s:%d: %S+%d\n", info.eip_file, info.eip_line, info.eip_fn_name, info.eip_line);
f01008b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01008b8:	89 04 24             	mov    %eax,(%esp)
f01008bb:	ff 75 e8             	push   -0x18(%ebp)
f01008be:	50                   	push   %eax
f01008bf:	ff 75 e0             	push   -0x20(%ebp)
f01008c2:	68 7e 63 10 f0       	push   $0xf010637e
f01008c7:	e8 41 2f 00 00       	call   f010380d <cprintf>
		ebp = *(uint32_t *)ebp;
f01008cc:	8b 1b                	mov    (%ebx),%ebx
f01008ce:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f01008d1:	85 db                	test   %ebx,%ebx
f01008d3:	75 c3                	jne    f0100898 <mon_backtrace+0x1c>
	}

	return 0;
}
f01008d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01008da:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01008dd:	5b                   	pop    %ebx
f01008de:	5e                   	pop    %esi
f01008df:	5d                   	pop    %ebp
f01008e0:	c3                   	ret    

f01008e1 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008e1:	55                   	push   %ebp
f01008e2:	89 e5                	mov    %esp,%ebp
f01008e4:	57                   	push   %edi
f01008e5:	56                   	push   %esi
f01008e6:	53                   	push   %ebx
f01008e7:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008ea:	68 d4 64 10 f0       	push   $0xf01064d4
f01008ef:	e8 19 2f 00 00       	call   f010380d <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008f4:	c7 04 24 f8 64 10 f0 	movl   $0xf01064f8,(%esp)
f01008fb:	e8 0d 2f 00 00       	call   f010380d <cprintf>

	if (tf != NULL)
f0100900:	83 c4 10             	add    $0x10,%esp
f0100903:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100907:	74 57                	je     f0100960 <monitor+0x7f>
		print_trapframe(tf);
f0100909:	83 ec 0c             	sub    $0xc,%esp
f010090c:	ff 75 08             	push   0x8(%ebp)
f010090f:	e8 d9 30 00 00       	call   f01039ed <print_trapframe>
f0100914:	83 c4 10             	add    $0x10,%esp
f0100917:	eb 47                	jmp    f0100960 <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f0100919:	83 ec 08             	sub    $0x8,%esp
f010091c:	0f be c0             	movsbl %al,%eax
f010091f:	50                   	push   %eax
f0100920:	68 90 63 10 f0       	push   $0xf0106390
f0100925:	e8 4b 4a 00 00       	call   f0105375 <strchr>
f010092a:	83 c4 10             	add    $0x10,%esp
f010092d:	85 c0                	test   %eax,%eax
f010092f:	74 0a                	je     f010093b <monitor+0x5a>
			*buf++ = 0;
f0100931:	c6 03 00             	movb   $0x0,(%ebx)
f0100934:	89 f7                	mov    %esi,%edi
f0100936:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100939:	eb 6b                	jmp    f01009a6 <monitor+0xc5>
		if (*buf == 0)
f010093b:	80 3b 00             	cmpb   $0x0,(%ebx)
f010093e:	74 73                	je     f01009b3 <monitor+0xd2>
		if (argc == MAXARGS-1) {
f0100940:	83 fe 0f             	cmp    $0xf,%esi
f0100943:	74 09                	je     f010094e <monitor+0x6d>
		argv[argc++] = buf;
f0100945:	8d 7e 01             	lea    0x1(%esi),%edi
f0100948:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f010094c:	eb 39                	jmp    f0100987 <monitor+0xa6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010094e:	83 ec 08             	sub    $0x8,%esp
f0100951:	6a 10                	push   $0x10
f0100953:	68 95 63 10 f0       	push   $0xf0106395
f0100958:	e8 b0 2e 00 00       	call   f010380d <cprintf>
			return 0;
f010095d:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100960:	83 ec 0c             	sub    $0xc,%esp
f0100963:	68 8c 63 10 f0       	push   $0xf010638c
f0100968:	e8 ce 47 00 00       	call   f010513b <readline>
f010096d:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f010096f:	83 c4 10             	add    $0x10,%esp
f0100972:	85 c0                	test   %eax,%eax
f0100974:	74 ea                	je     f0100960 <monitor+0x7f>
	argv[argc] = 0;
f0100976:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010097d:	be 00 00 00 00       	mov    $0x0,%esi
f0100982:	eb 24                	jmp    f01009a8 <monitor+0xc7>
			buf++;
f0100984:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100987:	0f b6 03             	movzbl (%ebx),%eax
f010098a:	84 c0                	test   %al,%al
f010098c:	74 18                	je     f01009a6 <monitor+0xc5>
f010098e:	83 ec 08             	sub    $0x8,%esp
f0100991:	0f be c0             	movsbl %al,%eax
f0100994:	50                   	push   %eax
f0100995:	68 90 63 10 f0       	push   $0xf0106390
f010099a:	e8 d6 49 00 00       	call   f0105375 <strchr>
f010099f:	83 c4 10             	add    $0x10,%esp
f01009a2:	85 c0                	test   %eax,%eax
f01009a4:	74 de                	je     f0100984 <monitor+0xa3>
			*buf++ = 0;
f01009a6:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009a8:	0f b6 03             	movzbl (%ebx),%eax
f01009ab:	84 c0                	test   %al,%al
f01009ad:	0f 85 66 ff ff ff    	jne    f0100919 <monitor+0x38>
	argv[argc] = 0;
f01009b3:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009ba:	00 
	if (argc == 0)
f01009bb:	85 f6                	test   %esi,%esi
f01009bd:	74 a1                	je     f0100960 <monitor+0x7f>
		if (strcmp(argv[0], commands[i].name) == 0)
f01009bf:	83 ec 08             	sub    $0x8,%esp
f01009c2:	68 1e 63 10 f0       	push   $0xf010631e
f01009c7:	ff 75 a8             	push   -0x58(%ebp)
f01009ca:	e8 46 49 00 00       	call   f0105315 <strcmp>
f01009cf:	83 c4 10             	add    $0x10,%esp
f01009d2:	85 c0                	test   %eax,%eax
f01009d4:	74 34                	je     f0100a0a <monitor+0x129>
f01009d6:	83 ec 08             	sub    $0x8,%esp
f01009d9:	68 2c 63 10 f0       	push   $0xf010632c
f01009de:	ff 75 a8             	push   -0x58(%ebp)
f01009e1:	e8 2f 49 00 00       	call   f0105315 <strcmp>
f01009e6:	83 c4 10             	add    $0x10,%esp
f01009e9:	85 c0                	test   %eax,%eax
f01009eb:	74 18                	je     f0100a05 <monitor+0x124>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009ed:	83 ec 08             	sub    $0x8,%esp
f01009f0:	ff 75 a8             	push   -0x58(%ebp)
f01009f3:	68 b2 63 10 f0       	push   $0xf01063b2
f01009f8:	e8 10 2e 00 00       	call   f010380d <cprintf>
	return 0;
f01009fd:	83 c4 10             	add    $0x10,%esp
f0100a00:	e9 5b ff ff ff       	jmp    f0100960 <monitor+0x7f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a05:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f0100a0a:	83 ec 04             	sub    $0x4,%esp
f0100a0d:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100a10:	ff 75 08             	push   0x8(%ebp)
f0100a13:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a16:	52                   	push   %edx
f0100a17:	56                   	push   %esi
f0100a18:	ff 14 85 28 65 10 f0 	call   *-0xfef9ad8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a1f:	83 c4 10             	add    $0x10,%esp
f0100a22:	85 c0                	test   %eax,%eax
f0100a24:	0f 89 36 ff ff ff    	jns    f0100960 <monitor+0x7f>
				break;
	}
}
f0100a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a2d:	5b                   	pop    %ebx
f0100a2e:	5e                   	pop    %esi
f0100a2f:	5f                   	pop    %edi
f0100a30:	5d                   	pop    %ebp
f0100a31:	c3                   	ret    

f0100a32 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100a32:	83 3d 64 b2 1e f0 00 	cmpl   $0x0,0xf01eb264
f0100a39:	74 1a                	je     f0100a55 <boot_alloc+0x23>
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.

	result = nextfree;
f0100a3b:	8b 15 64 b2 1e f0    	mov    0xf01eb264,%edx
	nextfree = ROUNDUP(nextfree+n, PGSIZE);
f0100a41:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100a48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a4d:	a3 64 b2 1e f0       	mov    %eax,0xf01eb264

	return result;
}
f0100a52:	89 d0                	mov    %edx,%eax
f0100a54:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100a55:	ba c7 d3 22 f0       	mov    $0xf022d3c7,%edx
f0100a5a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a60:	89 15 64 b2 1e f0    	mov    %edx,0xf01eb264
f0100a66:	eb d3                	jmp    f0100a3b <boot_alloc+0x9>

f0100a68 <nvram_read>:
{
f0100a68:	55                   	push   %ebp
f0100a69:	89 e5                	mov    %esp,%ebp
f0100a6b:	56                   	push   %esi
f0100a6c:	53                   	push   %ebx
f0100a6d:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a6f:	83 ec 0c             	sub    $0xc,%esp
f0100a72:	50                   	push   %eax
f0100a73:	e8 05 2c 00 00       	call   f010367d <mc146818_read>
f0100a78:	89 c6                	mov    %eax,%esi
f0100a7a:	83 c3 01             	add    $0x1,%ebx
f0100a7d:	89 1c 24             	mov    %ebx,(%esp)
f0100a80:	e8 f8 2b 00 00       	call   f010367d <mc146818_read>
f0100a85:	c1 e0 08             	shl    $0x8,%eax
f0100a88:	09 f0                	or     %esi,%eax
}
f0100a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a8d:	5b                   	pop    %ebx
f0100a8e:	5e                   	pop    %esi
f0100a8f:	5d                   	pop    %ebp
f0100a90:	c3                   	ret    

f0100a91 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100a91:	89 d1                	mov    %edx,%ecx
f0100a93:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100a96:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100a99:	a8 01                	test   $0x1,%al
f0100a9b:	74 51                	je     f0100aee <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100a9d:	89 c1                	mov    %eax,%ecx
f0100a9f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100aa5:	c1 e8 0c             	shr    $0xc,%eax
f0100aa8:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0100aae:	73 23                	jae    f0100ad3 <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100ab0:	c1 ea 0c             	shr    $0xc,%edx
f0100ab3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ab9:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100ac0:	89 d0                	mov    %edx,%eax
f0100ac2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ac7:	f6 c2 01             	test   $0x1,%dl
f0100aca:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100acf:	0f 44 c2             	cmove  %edx,%eax
f0100ad2:	c3                   	ret    
{
f0100ad3:	55                   	push   %ebp
f0100ad4:	89 e5                	mov    %esp,%ebp
f0100ad6:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ad9:	51                   	push   %ecx
f0100ada:	68 04 60 10 f0       	push   $0xf0106004
f0100adf:	68 66 03 00 00       	push   $0x366
f0100ae4:	68 81 6e 10 f0       	push   $0xf0106e81
f0100ae9:	e8 52 f5 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100aee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100af3:	c3                   	ret    

f0100af4 <check_page_free_list>:
{
f0100af4:	55                   	push   %ebp
f0100af5:	89 e5                	mov    %esp,%ebp
f0100af7:	57                   	push   %edi
f0100af8:	56                   	push   %esi
f0100af9:	53                   	push   %ebx
f0100afa:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100afd:	84 c0                	test   %al,%al
f0100aff:	0f 85 77 02 00 00    	jne    f0100d7c <check_page_free_list+0x288>
	if (!page_free_list)
f0100b05:	83 3d 6c b2 1e f0 00 	cmpl   $0x0,0xf01eb26c
f0100b0c:	74 0a                	je     f0100b18 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b0e:	be 00 04 00 00       	mov    $0x400,%esi
f0100b13:	e9 bf 02 00 00       	jmp    f0100dd7 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100b18:	83 ec 04             	sub    $0x4,%esp
f0100b1b:	68 38 65 10 f0       	push   $0xf0106538
f0100b20:	68 99 02 00 00       	push   $0x299
f0100b25:	68 81 6e 10 f0       	push   $0xf0106e81
f0100b2a:	e8 11 f5 ff ff       	call   f0100040 <_panic>
f0100b2f:	50                   	push   %eax
f0100b30:	68 04 60 10 f0       	push   $0xf0106004
f0100b35:	6a 58                	push   $0x58
f0100b37:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0100b3c:	e8 ff f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b41:	8b 1b                	mov    (%ebx),%ebx
f0100b43:	85 db                	test   %ebx,%ebx
f0100b45:	74 41                	je     f0100b88 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b47:	89 d8                	mov    %ebx,%eax
f0100b49:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0100b4f:	c1 f8 03             	sar    $0x3,%eax
f0100b52:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100b55:	89 c2                	mov    %eax,%edx
f0100b57:	c1 ea 16             	shr    $0x16,%edx
f0100b5a:	39 f2                	cmp    %esi,%edx
f0100b5c:	73 e3                	jae    f0100b41 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100b5e:	89 c2                	mov    %eax,%edx
f0100b60:	c1 ea 0c             	shr    $0xc,%edx
f0100b63:	3b 15 60 b2 1e f0    	cmp    0xf01eb260,%edx
f0100b69:	73 c4                	jae    f0100b2f <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100b6b:	83 ec 04             	sub    $0x4,%esp
f0100b6e:	68 80 00 00 00       	push   $0x80
f0100b73:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100b78:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100b7d:	50                   	push   %eax
f0100b7e:	e8 31 48 00 00       	call   f01053b4 <memset>
f0100b83:	83 c4 10             	add    $0x10,%esp
f0100b86:	eb b9                	jmp    f0100b41 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100b88:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b8d:	e8 a0 fe ff ff       	call   f0100a32 <boot_alloc>
f0100b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100b95:	8b 15 6c b2 1e f0    	mov    0xf01eb26c,%edx
		assert(pp >= pages);
f0100b9b:	8b 0d 58 b2 1e f0    	mov    0xf01eb258,%ecx
		assert(pp < pages + npages);
f0100ba1:	a1 60 b2 1e f0       	mov    0xf01eb260,%eax
f0100ba6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100ba9:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100bac:	bf 00 00 00 00       	mov    $0x0,%edi
f0100bb1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bb4:	e9 f9 00 00 00       	jmp    f0100cb2 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100bb9:	68 9b 6e 10 f0       	push   $0xf0106e9b
f0100bbe:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100bc3:	68 b3 02 00 00       	push   $0x2b3
f0100bc8:	68 81 6e 10 f0       	push   $0xf0106e81
f0100bcd:	e8 6e f4 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100bd2:	68 bc 6e 10 f0       	push   $0xf0106ebc
f0100bd7:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100bdc:	68 b4 02 00 00       	push   $0x2b4
f0100be1:	68 81 6e 10 f0       	push   $0xf0106e81
f0100be6:	e8 55 f4 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100beb:	68 5c 65 10 f0       	push   $0xf010655c
f0100bf0:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100bf5:	68 b5 02 00 00       	push   $0x2b5
f0100bfa:	68 81 6e 10 f0       	push   $0xf0106e81
f0100bff:	e8 3c f4 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100c04:	68 d0 6e 10 f0       	push   $0xf0106ed0
f0100c09:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100c0e:	68 b8 02 00 00       	push   $0x2b8
f0100c13:	68 81 6e 10 f0       	push   $0xf0106e81
f0100c18:	e8 23 f4 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100c1d:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c22:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100c27:	68 b9 02 00 00       	push   $0x2b9
f0100c2c:	68 81 6e 10 f0       	push   $0xf0106e81
f0100c31:	e8 0a f4 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c36:	68 90 65 10 f0       	push   $0xf0106590
f0100c3b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100c40:	68 ba 02 00 00       	push   $0x2ba
f0100c45:	68 81 6e 10 f0       	push   $0xf0106e81
f0100c4a:	e8 f1 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100c4f:	68 fa 6e 10 f0       	push   $0xf0106efa
f0100c54:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100c59:	68 bb 02 00 00       	push   $0x2bb
f0100c5e:	68 81 6e 10 f0       	push   $0xf0106e81
f0100c63:	e8 d8 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100c68:	89 c3                	mov    %eax,%ebx
f0100c6a:	c1 eb 0c             	shr    $0xc,%ebx
f0100c6d:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100c70:	76 0f                	jbe    f0100c81 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100c72:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100c77:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100c7a:	77 17                	ja     f0100c93 <check_page_free_list+0x19f>
			++nfree_extmem;
f0100c7c:	83 c7 01             	add    $0x1,%edi
f0100c7f:	eb 2f                	jmp    f0100cb0 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c81:	50                   	push   %eax
f0100c82:	68 04 60 10 f0       	push   $0xf0106004
f0100c87:	6a 58                	push   $0x58
f0100c89:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0100c8e:	e8 ad f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100c93:	68 b4 65 10 f0       	push   $0xf01065b4
f0100c98:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100c9d:	68 bc 02 00 00       	push   $0x2bc
f0100ca2:	68 81 6e 10 f0       	push   $0xf0106e81
f0100ca7:	e8 94 f3 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100cac:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100cb0:	8b 12                	mov    (%edx),%edx
f0100cb2:	85 d2                	test   %edx,%edx
f0100cb4:	74 74                	je     f0100d2a <check_page_free_list+0x236>
		assert(pp >= pages);
f0100cb6:	39 d1                	cmp    %edx,%ecx
f0100cb8:	0f 87 fb fe ff ff    	ja     f0100bb9 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100cbe:	39 d6                	cmp    %edx,%esi
f0100cc0:	0f 86 0c ff ff ff    	jbe    f0100bd2 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100cc6:	89 d0                	mov    %edx,%eax
f0100cc8:	29 c8                	sub    %ecx,%eax
f0100cca:	a8 07                	test   $0x7,%al
f0100ccc:	0f 85 19 ff ff ff    	jne    f0100beb <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100cd2:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100cd5:	c1 e0 0c             	shl    $0xc,%eax
f0100cd8:	0f 84 26 ff ff ff    	je     f0100c04 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cde:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100ce3:	0f 84 34 ff ff ff    	je     f0100c1d <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ce9:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100cee:	0f 84 42 ff ff ff    	je     f0100c36 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100cf4:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100cf9:	0f 84 50 ff ff ff    	je     f0100c4f <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100cff:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d04:	0f 87 5e ff ff ff    	ja     f0100c68 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d0a:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d0f:	75 9b                	jne    f0100cac <check_page_free_list+0x1b8>
f0100d11:	68 14 6f 10 f0       	push   $0xf0106f14
f0100d16:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100d1b:	68 be 02 00 00       	push   $0x2be
f0100d20:	68 81 6e 10 f0       	push   $0xf0106e81
f0100d25:	e8 16 f3 ff ff       	call   f0100040 <_panic>
	assert(nfree_basemem > 0);
f0100d2a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100d2d:	85 db                	test   %ebx,%ebx
f0100d2f:	7e 19                	jle    f0100d4a <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100d31:	85 ff                	test   %edi,%edi
f0100d33:	7e 2e                	jle    f0100d63 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100d35:	83 ec 0c             	sub    $0xc,%esp
f0100d38:	68 fc 65 10 f0       	push   $0xf01065fc
f0100d3d:	e8 cb 2a 00 00       	call   f010380d <cprintf>
}
f0100d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d45:	5b                   	pop    %ebx
f0100d46:	5e                   	pop    %esi
f0100d47:	5f                   	pop    %edi
f0100d48:	5d                   	pop    %ebp
f0100d49:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100d4a:	68 31 6f 10 f0       	push   $0xf0106f31
f0100d4f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100d54:	68 c6 02 00 00       	push   $0x2c6
f0100d59:	68 81 6e 10 f0       	push   $0xf0106e81
f0100d5e:	e8 dd f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100d63:	68 43 6f 10 f0       	push   $0xf0106f43
f0100d68:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0100d6d:	68 c7 02 00 00       	push   $0x2c7
f0100d72:	68 81 6e 10 f0       	push   $0xf0106e81
f0100d77:	e8 c4 f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100d7c:	a1 6c b2 1e f0       	mov    0xf01eb26c,%eax
f0100d81:	85 c0                	test   %eax,%eax
f0100d83:	0f 84 8f fd ff ff    	je     f0100b18 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100d89:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100d8c:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100d8f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100d92:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100d95:	89 c2                	mov    %eax,%edx
f0100d97:	2b 15 58 b2 1e f0    	sub    0xf01eb258,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100d9d:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100da3:	0f 95 c2             	setne  %dl
f0100da6:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100da9:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100dad:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100daf:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100db3:	8b 00                	mov    (%eax),%eax
f0100db5:	85 c0                	test   %eax,%eax
f0100db7:	75 dc                	jne    f0100d95 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100dbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100dc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100dc8:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100dca:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100dcd:	a3 6c b2 1e f0       	mov    %eax,0xf01eb26c
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100dd2:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100dd7:	8b 1d 6c b2 1e f0    	mov    0xf01eb26c,%ebx
f0100ddd:	e9 61 fd ff ff       	jmp    f0100b43 <check_page_free_list+0x4f>

f0100de2 <page_init>:
{
f0100de2:	55                   	push   %ebp
f0100de3:	89 e5                	mov    %esp,%ebp
f0100de5:	57                   	push   %edi
f0100de6:	56                   	push   %esi
f0100de7:	53                   	push   %ebx
f0100de8:	83 ec 0c             	sub    $0xc,%esp
	pages[0].pp_ref = 1;
f0100deb:	a1 58 b2 1e f0       	mov    0xf01eb258,%eax
f0100df0:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
    pages[0].pp_link = NULL;
f0100df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    size_t kernel_end_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100dfc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e01:	e8 2c fc ff ff       	call   f0100a32 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100e06:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e0b:	76 21                	jbe    f0100e2e <page_init+0x4c>
	return (physaddr_t)kva - KERNBASE;
f0100e0d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100e13:	c1 ea 0c             	shr    $0xc,%edx
        if ((i >= npages_basemem && i < kernel_end_page) || (i == MPENTRY_PADDR / PGSIZE)) {
f0100e16:	8b 35 70 b2 1e f0    	mov    0xf01eb270,%esi
f0100e1c:	8b 1d 6c b2 1e f0    	mov    0xf01eb26c,%ebx
    for (i = 1; i < npages; i++) {
f0100e22:	bf 00 00 00 00       	mov    $0x0,%edi
f0100e27:	b8 01 00 00 00       	mov    $0x1,%eax
f0100e2c:	eb 2d                	jmp    f0100e5b <page_init+0x79>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100e2e:	50                   	push   %eax
f0100e2f:	68 28 60 10 f0       	push   $0xf0106028
f0100e34:	68 3b 01 00 00       	push   $0x13b
f0100e39:	68 81 6e 10 f0       	push   $0xf0106e81
f0100e3e:	e8 fd f1 ff ff       	call   f0100040 <_panic>
            pages[i].pp_ref = 1;
f0100e43:	8b 0d 58 b2 1e f0    	mov    0xf01eb258,%ecx
f0100e49:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
f0100e4c:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
            pages[i].pp_link = NULL;
f0100e52:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    for (i = 1; i < npages; i++) {
f0100e58:	83 c0 01             	add    $0x1,%eax
f0100e5b:	39 05 60 b2 1e f0    	cmp    %eax,0xf01eb260
f0100e61:	76 33                	jbe    f0100e96 <page_init+0xb4>
        if ((i >= npages_basemem && i < kernel_end_page) || (i == MPENTRY_PADDR / PGSIZE)) {
f0100e63:	39 d0                	cmp    %edx,%eax
f0100e65:	73 04                	jae    f0100e6b <page_init+0x89>
f0100e67:	39 c6                	cmp    %eax,%esi
f0100e69:	76 d8                	jbe    f0100e43 <page_init+0x61>
f0100e6b:	83 f8 07             	cmp    $0x7,%eax
f0100e6e:	74 d3                	je     f0100e43 <page_init+0x61>
f0100e70:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
            pages[i].pp_ref = 0;
f0100e77:	89 cf                	mov    %ecx,%edi
f0100e79:	03 3d 58 b2 1e f0    	add    0xf01eb258,%edi
f0100e7f:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
            pages[i].pp_link = page_free_list;
f0100e85:	89 1f                	mov    %ebx,(%edi)
            page_free_list = &pages[i];
f0100e87:	89 cb                	mov    %ecx,%ebx
f0100e89:	03 1d 58 b2 1e f0    	add    0xf01eb258,%ebx
f0100e8f:	bf 01 00 00 00       	mov    $0x1,%edi
f0100e94:	eb c2                	jmp    f0100e58 <page_init+0x76>
f0100e96:	89 f8                	mov    %edi,%eax
f0100e98:	84 c0                	test   %al,%al
f0100e9a:	74 06                	je     f0100ea2 <page_init+0xc0>
f0100e9c:	89 1d 6c b2 1e f0    	mov    %ebx,0xf01eb26c
}
f0100ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ea5:	5b                   	pop    %ebx
f0100ea6:	5e                   	pop    %esi
f0100ea7:	5f                   	pop    %edi
f0100ea8:	5d                   	pop    %ebp
f0100ea9:	c3                   	ret    

f0100eaa <page_alloc>:
{
f0100eaa:	55                   	push   %ebp
f0100eab:	89 e5                	mov    %esp,%ebp
f0100ead:	53                   	push   %ebx
f0100eae:	83 ec 04             	sub    $0x4,%esp
	if (!page_free_list) return NULL;
f0100eb1:	8b 1d 6c b2 1e f0    	mov    0xf01eb26c,%ebx
f0100eb7:	85 db                	test   %ebx,%ebx
f0100eb9:	74 13                	je     f0100ece <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f0100ebb:	8b 03                	mov    (%ebx),%eax
f0100ebd:	a3 6c b2 1e f0       	mov    %eax,0xf01eb26c
	res->pp_link = NULL;
f0100ec2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if (alloc_flags & ALLOC_ZERO) {
f0100ec8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100ecc:	75 07                	jne    f0100ed5 <page_alloc+0x2b>
}
f0100ece:	89 d8                	mov    %ebx,%eax
f0100ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ed3:	c9                   	leave  
f0100ed4:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100ed5:	89 d8                	mov    %ebx,%eax
f0100ed7:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0100edd:	c1 f8 03             	sar    $0x3,%eax
f0100ee0:	89 c2                	mov    %eax,%edx
f0100ee2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0100ee5:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0100eea:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0100ef0:	73 1b                	jae    f0100f0d <page_alloc+0x63>
		memset(page2kva(res), 0, PGSIZE);
f0100ef2:	83 ec 04             	sub    $0x4,%esp
f0100ef5:	68 00 10 00 00       	push   $0x1000
f0100efa:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100efc:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100f02:	52                   	push   %edx
f0100f03:	e8 ac 44 00 00       	call   f01053b4 <memset>
f0100f08:	83 c4 10             	add    $0x10,%esp
f0100f0b:	eb c1                	jmp    f0100ece <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f0d:	52                   	push   %edx
f0100f0e:	68 04 60 10 f0       	push   $0xf0106004
f0100f13:	6a 58                	push   $0x58
f0100f15:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0100f1a:	e8 21 f1 ff ff       	call   f0100040 <_panic>

f0100f1f <page_free>:
{
f0100f1f:	55                   	push   %ebp
f0100f20:	89 e5                	mov    %esp,%ebp
f0100f22:	83 ec 08             	sub    $0x8,%esp
f0100f25:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_ref) panic("page can't be freed due to reference");
f0100f28:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100f2d:	75 0f                	jne    f0100f3e <page_free+0x1f>
	pp->pp_link = page_free_list;
f0100f2f:	8b 15 6c b2 1e f0    	mov    0xf01eb26c,%edx
f0100f35:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0100f37:	a3 6c b2 1e f0       	mov    %eax,0xf01eb26c
}
f0100f3c:	c9                   	leave  
f0100f3d:	c3                   	ret    
	if (pp->pp_ref) panic("page can't be freed due to reference");
f0100f3e:	83 ec 04             	sub    $0x4,%esp
f0100f41:	68 20 66 10 f0       	push   $0xf0106620
f0100f46:	68 6d 01 00 00       	push   $0x16d
f0100f4b:	68 81 6e 10 f0       	push   $0xf0106e81
f0100f50:	e8 eb f0 ff ff       	call   f0100040 <_panic>

f0100f55 <page_decref>:
{
f0100f55:	55                   	push   %ebp
f0100f56:	89 e5                	mov    %esp,%ebp
f0100f58:	83 ec 08             	sub    $0x8,%esp
f0100f5b:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0100f5e:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0100f62:	83 e8 01             	sub    $0x1,%eax
f0100f65:	66 89 42 04          	mov    %ax,0x4(%edx)
f0100f69:	66 85 c0             	test   %ax,%ax
f0100f6c:	74 02                	je     f0100f70 <page_decref+0x1b>
}
f0100f6e:	c9                   	leave  
f0100f6f:	c3                   	ret    
		page_free(pp);
f0100f70:	83 ec 0c             	sub    $0xc,%esp
f0100f73:	52                   	push   %edx
f0100f74:	e8 a6 ff ff ff       	call   f0100f1f <page_free>
f0100f79:	83 c4 10             	add    $0x10,%esp
}
f0100f7c:	eb f0                	jmp    f0100f6e <page_decref+0x19>

f0100f7e <pgdir_walk>:
{
f0100f7e:	55                   	push   %ebp
f0100f7f:	89 e5                	mov    %esp,%ebp
f0100f81:	56                   	push   %esi
f0100f82:	53                   	push   %ebx
f0100f83:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t pgdir_entry = pgdir[PDX(va)];
f0100f86:	89 f3                	mov    %esi,%ebx
f0100f88:	c1 eb 16             	shr    $0x16,%ebx
f0100f8b:	c1 e3 02             	shl    $0x2,%ebx
f0100f8e:	03 5d 08             	add    0x8(%ebp),%ebx
f0100f91:	8b 03                	mov    (%ebx),%eax
	if (pgdir_entry & PTE_P) {
f0100f93:	a8 01                	test   $0x1,%al
f0100f95:	75 56                	jne    f0100fed <pgdir_walk+0x6f>
	} else if (create) {
f0100f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0100f9b:	0f 84 9b 00 00 00    	je     f010103c <pgdir_walk+0xbe>
		struct PageInfo *page = page_alloc(ALLOC_ZERO);
f0100fa1:	83 ec 0c             	sub    $0xc,%esp
f0100fa4:	6a 01                	push   $0x1
f0100fa6:	e8 ff fe ff ff       	call   f0100eaa <page_alloc>
		if (!page) return NULL; //error
f0100fab:	83 c4 10             	add    $0x10,%esp
f0100fae:	85 c0                	test   %eax,%eax
f0100fb0:	0f 84 8b 00 00 00    	je     f0101041 <pgdir_walk+0xc3>
		page->pp_ref++;
f0100fb6:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0100fbb:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0100fc1:	c1 f8 03             	sar    $0x3,%eax
f0100fc4:	c1 e0 0c             	shl    $0xc,%eax
		pgdir_entry = page2pa(page) | PTE_P | PTE_W | PTE_U;
f0100fc7:	89 c2                	mov    %eax,%edx
f0100fc9:	83 ca 07             	or     $0x7,%edx
f0100fcc:	89 13                	mov    %edx,(%ebx)
	if (PGNUM(pa) >= npages)
f0100fce:	89 c2                	mov    %eax,%edx
f0100fd0:	c1 ea 0c             	shr    $0xc,%edx
f0100fd3:	3b 15 60 b2 1e f0    	cmp    0xf01eb260,%edx
f0100fd9:	73 4c                	jae    f0101027 <pgdir_walk+0xa9>
		return pt+PTX(va);
f0100fdb:	c1 ee 0a             	shr    $0xa,%esi
f0100fde:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0100fe4:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0100feb:	eb 54                	jmp    f0101041 <pgdir_walk+0xc3>
		pte_t *pt = KADDR(PTE_ADDR(pgdir_entry));
f0100fed:	89 c2                	mov    %eax,%edx
f0100fef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100ff5:	c1 e8 0c             	shr    $0xc,%eax
f0100ff8:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0100ffe:	73 12                	jae    f0101012 <pgdir_walk+0x94>
		return pt+PTX(va);
f0101000:	c1 ee 0a             	shr    $0xa,%esi
f0101003:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101009:	8d 84 32 00 00 00 f0 	lea    -0x10000000(%edx,%esi,1),%eax
f0101010:	eb 2f                	jmp    f0101041 <pgdir_walk+0xc3>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101012:	52                   	push   %edx
f0101013:	68 04 60 10 f0       	push   $0xf0106004
f0101018:	68 9a 01 00 00       	push   $0x19a
f010101d:	68 81 6e 10 f0       	push   $0xf0106e81
f0101022:	e8 19 f0 ff ff       	call   f0100040 <_panic>
f0101027:	50                   	push   %eax
f0101028:	68 04 60 10 f0       	push   $0xf0106004
f010102d:	68 a3 01 00 00       	push   $0x1a3
f0101032:	68 81 6e 10 f0       	push   $0xf0106e81
f0101037:	e8 04 f0 ff ff       	call   f0100040 <_panic>
	return NULL;
f010103c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101041:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101044:	5b                   	pop    %ebx
f0101045:	5e                   	pop    %esi
f0101046:	5d                   	pop    %ebp
f0101047:	c3                   	ret    

f0101048 <boot_map_region>:
{
f0101048:	55                   	push   %ebp
f0101049:	89 e5                	mov    %esp,%ebp
f010104b:	57                   	push   %edi
f010104c:	56                   	push   %esi
f010104d:	53                   	push   %ebx
f010104e:	83 ec 1c             	sub    $0x1c,%esp
f0101051:	89 c7                	mov    %eax,%edi
f0101053:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101056:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	for (int offset = 0; offset < size; offset+=PGSIZE) {
f0101059:	be 00 00 00 00       	mov    $0x0,%esi
f010105e:	89 f3                	mov    %esi,%ebx
f0101060:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f0101063:	76 48                	jbe    f01010ad <boot_map_region+0x65>
		pte_t *pte = pgdir_walk(pgdir, (void *)(va+offset), 1);
f0101065:	83 ec 04             	sub    $0x4,%esp
f0101068:	6a 01                	push   $0x1
f010106a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010106d:	01 f0                	add    %esi,%eax
f010106f:	50                   	push   %eax
f0101070:	57                   	push   %edi
f0101071:	e8 08 ff ff ff       	call   f0100f7e <pgdir_walk>
		if (!pte) panic("page alloc failed\n");
f0101076:	83 c4 10             	add    $0x10,%esp
f0101079:	85 c0                	test   %eax,%eax
f010107b:	74 19                	je     f0101096 <boot_map_region+0x4e>
		*pte = (((pa+offset) >> 12) << 12) | PTE_P | perm;
f010107d:	03 5d 08             	add    0x8(%ebp),%ebx
f0101080:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101086:	0b 5d 0c             	or     0xc(%ebp),%ebx
f0101089:	83 cb 01             	or     $0x1,%ebx
f010108c:	89 18                	mov    %ebx,(%eax)
	for (int offset = 0; offset < size; offset+=PGSIZE) {
f010108e:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0101094:	eb c8                	jmp    f010105e <boot_map_region+0x16>
		if (!pte) panic("page alloc failed\n");
f0101096:	83 ec 04             	sub    $0x4,%esp
f0101099:	68 54 6f 10 f0       	push   $0xf0106f54
f010109e:	68 b9 01 00 00       	push   $0x1b9
f01010a3:	68 81 6e 10 f0       	push   $0xf0106e81
f01010a8:	e8 93 ef ff ff       	call   f0100040 <_panic>
}
f01010ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01010b0:	5b                   	pop    %ebx
f01010b1:	5e                   	pop    %esi
f01010b2:	5f                   	pop    %edi
f01010b3:	5d                   	pop    %ebp
f01010b4:	c3                   	ret    

f01010b5 <page_lookup>:
{
f01010b5:	55                   	push   %ebp
f01010b6:	89 e5                	mov    %esp,%ebp
f01010b8:	53                   	push   %ebx
f01010b9:	83 ec 08             	sub    $0x8,%esp
f01010bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 0);
f01010bf:	6a 00                	push   $0x0
f01010c1:	ff 75 0c             	push   0xc(%ebp)
f01010c4:	ff 75 08             	push   0x8(%ebp)
f01010c7:	e8 b2 fe ff ff       	call   f0100f7e <pgdir_walk>
	if (pte_store) *pte_store = pte;
f01010cc:	83 c4 10             	add    $0x10,%esp
f01010cf:	85 db                	test   %ebx,%ebx
f01010d1:	74 02                	je     f01010d5 <page_lookup+0x20>
f01010d3:	89 03                	mov    %eax,(%ebx)
	if (pte && (*pte & PTE_P)) return pa2page(PTE_ADDR(*pte));
f01010d5:	85 c0                	test   %eax,%eax
f01010d7:	74 0c                	je     f01010e5 <page_lookup+0x30>
f01010d9:	8b 10                	mov    (%eax),%edx
	return NULL;
f01010db:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pte && (*pte & PTE_P)) return pa2page(PTE_ADDR(*pte));
f01010e0:	f6 c2 01             	test   $0x1,%dl
f01010e3:	75 05                	jne    f01010ea <page_lookup+0x35>
}
f01010e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01010e8:	c9                   	leave  
f01010e9:	c3                   	ret    
f01010ea:	c1 ea 0c             	shr    $0xc,%edx
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01010ed:	39 15 60 b2 1e f0    	cmp    %edx,0xf01eb260
f01010f3:	76 0a                	jbe    f01010ff <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01010f5:	a1 58 b2 1e f0       	mov    0xf01eb258,%eax
f01010fa:	8d 04 d0             	lea    (%eax,%edx,8),%eax
	if (pte && (*pte & PTE_P)) return pa2page(PTE_ADDR(*pte));
f01010fd:	eb e6                	jmp    f01010e5 <page_lookup+0x30>
		panic("pa2page called with invalid pa");
f01010ff:	83 ec 04             	sub    $0x4,%esp
f0101102:	68 48 66 10 f0       	push   $0xf0106648
f0101107:	6a 51                	push   $0x51
f0101109:	68 8d 6e 10 f0       	push   $0xf0106e8d
f010110e:	e8 2d ef ff ff       	call   f0100040 <_panic>

f0101113 <tlb_invalidate>:
{
f0101113:	55                   	push   %ebp
f0101114:	89 e5                	mov    %esp,%ebp
f0101116:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101119:	e8 8a 48 00 00       	call   f01059a8 <cpunum>
f010111e:	6b c0 74             	imul   $0x74,%eax,%eax
f0101121:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f0101128:	74 16                	je     f0101140 <tlb_invalidate+0x2d>
f010112a:	e8 79 48 00 00       	call   f01059a8 <cpunum>
f010112f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101132:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0101138:	8b 55 08             	mov    0x8(%ebp),%edx
f010113b:	39 50 60             	cmp    %edx,0x60(%eax)
f010113e:	75 06                	jne    f0101146 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101140:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101143:	0f 01 38             	invlpg (%eax)
}
f0101146:	c9                   	leave  
f0101147:	c3                   	ret    

f0101148 <page_remove>:
{
f0101148:	55                   	push   %ebp
f0101149:	89 e5                	mov    %esp,%ebp
f010114b:	56                   	push   %esi
f010114c:	53                   	push   %ebx
f010114d:	83 ec 14             	sub    $0x14,%esp
f0101150:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101153:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *pp = page_lookup(pgdir, va, &ptep);
f0101156:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101159:	50                   	push   %eax
f010115a:	56                   	push   %esi
f010115b:	53                   	push   %ebx
f010115c:	e8 54 ff ff ff       	call   f01010b5 <page_lookup>
	if(!pp || !(*ptep & PTE_P)) return;
f0101161:	83 c4 10             	add    $0x10,%esp
f0101164:	85 c0                	test   %eax,%eax
f0101166:	74 2e                	je     f0101196 <page_remove+0x4e>
f0101168:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010116b:	f6 02 01             	testb  $0x1,(%edx)
f010116e:	74 26                	je     f0101196 <page_remove+0x4e>
	if (--pp->pp_ref == 0) page_free(pp);
f0101170:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f0101174:	8d 51 ff             	lea    -0x1(%ecx),%edx
f0101177:	66 89 50 04          	mov    %dx,0x4(%eax)
f010117b:	66 85 d2             	test   %dx,%dx
f010117e:	74 1d                	je     f010119d <page_remove+0x55>
	tlb_invalidate(pgdir, va);
f0101180:	83 ec 08             	sub    $0x8,%esp
f0101183:	56                   	push   %esi
f0101184:	53                   	push   %ebx
f0101185:	e8 89 ff ff ff       	call   f0101113 <tlb_invalidate>
	*ptep = 0;
f010118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010118d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101193:	83 c4 10             	add    $0x10,%esp
}
f0101196:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101199:	5b                   	pop    %ebx
f010119a:	5e                   	pop    %esi
f010119b:	5d                   	pop    %ebp
f010119c:	c3                   	ret    
	if (--pp->pp_ref == 0) page_free(pp);
f010119d:	83 ec 0c             	sub    $0xc,%esp
f01011a0:	50                   	push   %eax
f01011a1:	e8 79 fd ff ff       	call   f0100f1f <page_free>
f01011a6:	83 c4 10             	add    $0x10,%esp
f01011a9:	eb d5                	jmp    f0101180 <page_remove+0x38>

f01011ab <page_insert>:
{
f01011ab:	55                   	push   %ebp
f01011ac:	89 e5                	mov    %esp,%ebp
f01011ae:	57                   	push   %edi
f01011af:	56                   	push   %esi
f01011b0:	53                   	push   %ebx
f01011b1:	83 ec 10             	sub    $0x10,%esp
f01011b4:	8b 7d 08             	mov    0x8(%ebp),%edi
f01011b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 1);
f01011ba:	6a 01                	push   $0x1
f01011bc:	ff 75 10             	push   0x10(%ebp)
f01011bf:	57                   	push   %edi
f01011c0:	e8 b9 fd ff ff       	call   f0100f7e <pgdir_walk>
	if (pte == NULL) return -E_NO_MEM;
f01011c5:	83 c4 10             	add    $0x10,%esp
f01011c8:	85 c0                	test   %eax,%eax
f01011ca:	74 4a                	je     f0101216 <page_insert+0x6b>
f01011cc:	89 c6                	mov    %eax,%esi
	pp->pp_ref++;
f01011ce:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if (*pte) page_remove(pgdir, va);
f01011d3:	83 38 00             	cmpl   $0x0,(%eax)
f01011d6:	75 2d                	jne    f0101205 <page_insert+0x5a>
	return (pp - pages) << PGSHIFT;
f01011d8:	2b 1d 58 b2 1e f0    	sub    0xf01eb258,%ebx
f01011de:	c1 fb 03             	sar    $0x3,%ebx
f01011e1:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f01011e4:	0b 5d 14             	or     0x14(%ebp),%ebx
f01011e7:	83 cb 01             	or     $0x1,%ebx
f01011ea:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f01011ec:	8b 45 10             	mov    0x10(%ebp),%eax
f01011ef:	c1 e8 16             	shr    $0x16,%eax
f01011f2:	8b 55 14             	mov    0x14(%ebp),%edx
f01011f5:	09 14 87             	or     %edx,(%edi,%eax,4)
	return 0;
f01011f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01011fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101200:	5b                   	pop    %ebx
f0101201:	5e                   	pop    %esi
f0101202:	5f                   	pop    %edi
f0101203:	5d                   	pop    %ebp
f0101204:	c3                   	ret    
	if (*pte) page_remove(pgdir, va);
f0101205:	83 ec 08             	sub    $0x8,%esp
f0101208:	ff 75 10             	push   0x10(%ebp)
f010120b:	57                   	push   %edi
f010120c:	e8 37 ff ff ff       	call   f0101148 <page_remove>
f0101211:	83 c4 10             	add    $0x10,%esp
f0101214:	eb c2                	jmp    f01011d8 <page_insert+0x2d>
	if (pte == NULL) return -E_NO_MEM;
f0101216:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010121b:	eb e0                	jmp    f01011fd <page_insert+0x52>

f010121d <mmio_map_region>:
{
f010121d:	55                   	push   %ebp
f010121e:	89 e5                	mov    %esp,%ebp
f0101220:	57                   	push   %edi
f0101221:	56                   	push   %esi
f0101222:	53                   	push   %ebx
f0101223:	83 ec 0c             	sub    $0xc,%esp
f0101226:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t start = ROUNDDOWN(((uint32_t)pa), PGSIZE);
f0101229:	89 c3                	mov    %eax,%ebx
f010122b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = ROUNDUP(((uint32_t)pa + size), PGSIZE);
f0101231:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101234:	8d b4 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%esi
f010123b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	uint32_t roundedSize = end-start;
f0101241:	89 f7                	mov    %esi,%edi
f0101243:	29 df                	sub    %ebx,%edi
	if (base + roundedSize >= MMIOLIM) panic("memio limit reached\n");
f0101245:	8b 15 00 43 12 f0    	mov    0xf0124300,%edx
f010124b:	8d 04 3a             	lea    (%edx,%edi,1),%eax
f010124e:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101253:	77 2b                	ja     f0101280 <mmio_map_region+0x63>
	boot_map_region(kern_pgdir, base, roundedSize, start, PTE_PCD|PTE_PWT|PTE_W);
f0101255:	83 ec 08             	sub    $0x8,%esp
f0101258:	6a 1a                	push   $0x1a
f010125a:	53                   	push   %ebx
f010125b:	89 f9                	mov    %edi,%ecx
f010125d:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0101262:	e8 e1 fd ff ff       	call   f0101048 <boot_map_region>
	base = base + roundedSize;
f0101267:	03 3d 00 43 12 f0    	add    0xf0124300,%edi
f010126d:	89 3d 00 43 12 f0    	mov    %edi,0xf0124300
	return (void *)(base-roundedSize);
f0101273:	29 f3                	sub    %esi,%ebx
f0101275:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
}
f0101278:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010127b:	5b                   	pop    %ebx
f010127c:	5e                   	pop    %esi
f010127d:	5f                   	pop    %edi
f010127e:	5d                   	pop    %ebp
f010127f:	c3                   	ret    
	if (base + roundedSize >= MMIOLIM) panic("memio limit reached\n");
f0101280:	83 ec 04             	sub    $0x4,%esp
f0101283:	68 67 6f 10 f0       	push   $0xf0106f67
f0101288:	68 42 02 00 00       	push   $0x242
f010128d:	68 81 6e 10 f0       	push   $0xf0106e81
f0101292:	e8 a9 ed ff ff       	call   f0100040 <_panic>

f0101297 <mem_init>:
{
f0101297:	55                   	push   %ebp
f0101298:	89 e5                	mov    %esp,%ebp
f010129a:	57                   	push   %edi
f010129b:	56                   	push   %esi
f010129c:	53                   	push   %ebx
f010129d:	83 ec 4c             	sub    $0x4c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01012a0:	b8 15 00 00 00       	mov    $0x15,%eax
f01012a5:	e8 be f7 ff ff       	call   f0100a68 <nvram_read>
f01012aa:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01012ac:	b8 17 00 00 00       	mov    $0x17,%eax
f01012b1:	e8 b2 f7 ff ff       	call   f0100a68 <nvram_read>
f01012b6:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01012b8:	b8 34 00 00 00       	mov    $0x34,%eax
f01012bd:	e8 a6 f7 ff ff       	call   f0100a68 <nvram_read>
	if (ext16mem)
f01012c2:	c1 e0 06             	shl    $0x6,%eax
f01012c5:	0f 84 d7 00 00 00    	je     f01013a2 <mem_init+0x10b>
		totalmem = 16 * 1024 + ext16mem;
f01012cb:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01012d0:	89 c2                	mov    %eax,%edx
f01012d2:	c1 ea 02             	shr    $0x2,%edx
f01012d5:	89 15 60 b2 1e f0    	mov    %edx,0xf01eb260
	npages_basemem = basemem / (PGSIZE / 1024);
f01012db:	89 da                	mov    %ebx,%edx
f01012dd:	c1 ea 02             	shr    $0x2,%edx
f01012e0:	89 15 70 b2 1e f0    	mov    %edx,0xf01eb270
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01012e6:	89 c2                	mov    %eax,%edx
f01012e8:	29 da                	sub    %ebx,%edx
f01012ea:	52                   	push   %edx
f01012eb:	53                   	push   %ebx
f01012ec:	50                   	push   %eax
f01012ed:	68 68 66 10 f0       	push   $0xf0106668
f01012f2:	e8 16 25 00 00       	call   f010380d <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01012f7:	b8 00 10 00 00       	mov    $0x1000,%eax
f01012fc:	e8 31 f7 ff ff       	call   f0100a32 <boot_alloc>
f0101301:	a3 5c b2 1e f0       	mov    %eax,0xf01eb25c
	memset(kern_pgdir, 0, PGSIZE);
f0101306:	83 c4 0c             	add    $0xc,%esp
f0101309:	68 00 10 00 00       	push   $0x1000
f010130e:	6a 00                	push   $0x0
f0101310:	50                   	push   %eax
f0101311:	e8 9e 40 00 00       	call   f01053b4 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101316:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f010131b:	83 c4 10             	add    $0x10,%esp
f010131e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101323:	0f 86 89 00 00 00    	jbe    f01013b2 <mem_init+0x11b>
	return (physaddr_t)kva - KERNBASE;
f0101329:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010132f:	83 ca 05             	or     $0x5,%edx
f0101332:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	size_t arr_size = npages * sizeof(struct PageInfo);
f0101338:	a1 60 b2 1e f0       	mov    0xf01eb260,%eax
f010133d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
	pages = boot_alloc(arr_size);
f0101344:	89 d8                	mov    %ebx,%eax
f0101346:	e8 e7 f6 ff ff       	call   f0100a32 <boot_alloc>
f010134b:	a3 58 b2 1e f0       	mov    %eax,0xf01eb258
	memset(pages, 0, arr_size);
f0101350:	83 ec 04             	sub    $0x4,%esp
f0101353:	53                   	push   %ebx
f0101354:	6a 00                	push   $0x0
f0101356:	50                   	push   %eax
f0101357:	e8 58 40 00 00       	call   f01053b4 <memset>
	envs = boot_alloc(NENV * sizeof(struct Env));
f010135c:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101361:	e8 cc f6 ff ff       	call   f0100a32 <boot_alloc>
f0101366:	a3 74 b2 1e f0       	mov    %eax,0xf01eb274
	memset(envs, 0, NENV * sizeof(struct Env));
f010136b:	83 c4 0c             	add    $0xc,%esp
f010136e:	68 00 f0 01 00       	push   $0x1f000
f0101373:	6a 00                	push   $0x0
f0101375:	50                   	push   %eax
f0101376:	e8 39 40 00 00       	call   f01053b4 <memset>
	page_init();
f010137b:	e8 62 fa ff ff       	call   f0100de2 <page_init>
	check_page_free_list(1);
f0101380:	b8 01 00 00 00       	mov    $0x1,%eax
f0101385:	e8 6a f7 ff ff       	call   f0100af4 <check_page_free_list>
	if (!pages)
f010138a:	83 c4 10             	add    $0x10,%esp
f010138d:	83 3d 58 b2 1e f0 00 	cmpl   $0x0,0xf01eb258
f0101394:	74 31                	je     f01013c7 <mem_init+0x130>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101396:	a1 6c b2 1e f0       	mov    0xf01eb26c,%eax
f010139b:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013a0:	eb 41                	jmp    f01013e3 <mem_init+0x14c>
		totalmem = 1 * 1024 + extmem;
f01013a2:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01013a8:	85 f6                	test   %esi,%esi
f01013aa:	0f 44 c3             	cmove  %ebx,%eax
f01013ad:	e9 1e ff ff ff       	jmp    f01012d0 <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01013b2:	50                   	push   %eax
f01013b3:	68 28 60 10 f0       	push   $0xf0106028
f01013b8:	68 94 00 00 00       	push   $0x94
f01013bd:	68 81 6e 10 f0       	push   $0xf0106e81
f01013c2:	e8 79 ec ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f01013c7:	83 ec 04             	sub    $0x4,%esp
f01013ca:	68 7c 6f 10 f0       	push   $0xf0106f7c
f01013cf:	68 da 02 00 00       	push   $0x2da
f01013d4:	68 81 6e 10 f0       	push   $0xf0106e81
f01013d9:	e8 62 ec ff ff       	call   f0100040 <_panic>
		++nfree;
f01013de:	83 c3 01             	add    $0x1,%ebx
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01013e1:	8b 00                	mov    (%eax),%eax
f01013e3:	85 c0                	test   %eax,%eax
f01013e5:	75 f7                	jne    f01013de <mem_init+0x147>
	assert((pp0 = page_alloc(0)));
f01013e7:	83 ec 0c             	sub    $0xc,%esp
f01013ea:	6a 00                	push   $0x0
f01013ec:	e8 b9 fa ff ff       	call   f0100eaa <page_alloc>
f01013f1:	89 c7                	mov    %eax,%edi
f01013f3:	83 c4 10             	add    $0x10,%esp
f01013f6:	85 c0                	test   %eax,%eax
f01013f8:	0f 84 1f 02 00 00    	je     f010161d <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f01013fe:	83 ec 0c             	sub    $0xc,%esp
f0101401:	6a 00                	push   $0x0
f0101403:	e8 a2 fa ff ff       	call   f0100eaa <page_alloc>
f0101408:	89 c6                	mov    %eax,%esi
f010140a:	83 c4 10             	add    $0x10,%esp
f010140d:	85 c0                	test   %eax,%eax
f010140f:	0f 84 21 02 00 00    	je     f0101636 <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f0101415:	83 ec 0c             	sub    $0xc,%esp
f0101418:	6a 00                	push   $0x0
f010141a:	e8 8b fa ff ff       	call   f0100eaa <page_alloc>
f010141f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101422:	83 c4 10             	add    $0x10,%esp
f0101425:	85 c0                	test   %eax,%eax
f0101427:	0f 84 22 02 00 00    	je     f010164f <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f010142d:	39 f7                	cmp    %esi,%edi
f010142f:	0f 84 33 02 00 00    	je     f0101668 <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101435:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101438:	39 c7                	cmp    %eax,%edi
f010143a:	0f 84 41 02 00 00    	je     f0101681 <mem_init+0x3ea>
f0101440:	39 c6                	cmp    %eax,%esi
f0101442:	0f 84 39 02 00 00    	je     f0101681 <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f0101448:	8b 0d 58 b2 1e f0    	mov    0xf01eb258,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f010144e:	8b 15 60 b2 1e f0    	mov    0xf01eb260,%edx
f0101454:	c1 e2 0c             	shl    $0xc,%edx
f0101457:	89 f8                	mov    %edi,%eax
f0101459:	29 c8                	sub    %ecx,%eax
f010145b:	c1 f8 03             	sar    $0x3,%eax
f010145e:	c1 e0 0c             	shl    $0xc,%eax
f0101461:	39 d0                	cmp    %edx,%eax
f0101463:	0f 83 31 02 00 00    	jae    f010169a <mem_init+0x403>
f0101469:	89 f0                	mov    %esi,%eax
f010146b:	29 c8                	sub    %ecx,%eax
f010146d:	c1 f8 03             	sar    $0x3,%eax
f0101470:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101473:	39 c2                	cmp    %eax,%edx
f0101475:	0f 86 38 02 00 00    	jbe    f01016b3 <mem_init+0x41c>
f010147b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010147e:	29 c8                	sub    %ecx,%eax
f0101480:	c1 f8 03             	sar    $0x3,%eax
f0101483:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101486:	39 c2                	cmp    %eax,%edx
f0101488:	0f 86 3e 02 00 00    	jbe    f01016cc <mem_init+0x435>
	fl = page_free_list;
f010148e:	a1 6c b2 1e f0       	mov    0xf01eb26c,%eax
f0101493:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101496:	c7 05 6c b2 1e f0 00 	movl   $0x0,0xf01eb26c
f010149d:	00 00 00 
	assert(!page_alloc(0));
f01014a0:	83 ec 0c             	sub    $0xc,%esp
f01014a3:	6a 00                	push   $0x0
f01014a5:	e8 00 fa ff ff       	call   f0100eaa <page_alloc>
f01014aa:	83 c4 10             	add    $0x10,%esp
f01014ad:	85 c0                	test   %eax,%eax
f01014af:	0f 85 30 02 00 00    	jne    f01016e5 <mem_init+0x44e>
	page_free(pp0);
f01014b5:	83 ec 0c             	sub    $0xc,%esp
f01014b8:	57                   	push   %edi
f01014b9:	e8 61 fa ff ff       	call   f0100f1f <page_free>
	page_free(pp1);
f01014be:	89 34 24             	mov    %esi,(%esp)
f01014c1:	e8 59 fa ff ff       	call   f0100f1f <page_free>
	page_free(pp2);
f01014c6:	83 c4 04             	add    $0x4,%esp
f01014c9:	ff 75 d4             	push   -0x2c(%ebp)
f01014cc:	e8 4e fa ff ff       	call   f0100f1f <page_free>
	assert((pp0 = page_alloc(0)));
f01014d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01014d8:	e8 cd f9 ff ff       	call   f0100eaa <page_alloc>
f01014dd:	89 c6                	mov    %eax,%esi
f01014df:	83 c4 10             	add    $0x10,%esp
f01014e2:	85 c0                	test   %eax,%eax
f01014e4:	0f 84 14 02 00 00    	je     f01016fe <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f01014ea:	83 ec 0c             	sub    $0xc,%esp
f01014ed:	6a 00                	push   $0x0
f01014ef:	e8 b6 f9 ff ff       	call   f0100eaa <page_alloc>
f01014f4:	89 c7                	mov    %eax,%edi
f01014f6:	83 c4 10             	add    $0x10,%esp
f01014f9:	85 c0                	test   %eax,%eax
f01014fb:	0f 84 16 02 00 00    	je     f0101717 <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f0101501:	83 ec 0c             	sub    $0xc,%esp
f0101504:	6a 00                	push   $0x0
f0101506:	e8 9f f9 ff ff       	call   f0100eaa <page_alloc>
f010150b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010150e:	83 c4 10             	add    $0x10,%esp
f0101511:	85 c0                	test   %eax,%eax
f0101513:	0f 84 17 02 00 00    	je     f0101730 <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f0101519:	39 fe                	cmp    %edi,%esi
f010151b:	0f 84 28 02 00 00    	je     f0101749 <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101524:	39 c7                	cmp    %eax,%edi
f0101526:	0f 84 36 02 00 00    	je     f0101762 <mem_init+0x4cb>
f010152c:	39 c6                	cmp    %eax,%esi
f010152e:	0f 84 2e 02 00 00    	je     f0101762 <mem_init+0x4cb>
	assert(!page_alloc(0));
f0101534:	83 ec 0c             	sub    $0xc,%esp
f0101537:	6a 00                	push   $0x0
f0101539:	e8 6c f9 ff ff       	call   f0100eaa <page_alloc>
f010153e:	83 c4 10             	add    $0x10,%esp
f0101541:	85 c0                	test   %eax,%eax
f0101543:	0f 85 32 02 00 00    	jne    f010177b <mem_init+0x4e4>
f0101549:	89 f0                	mov    %esi,%eax
f010154b:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101551:	c1 f8 03             	sar    $0x3,%eax
f0101554:	89 c2                	mov    %eax,%edx
f0101556:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101559:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010155e:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0101564:	0f 83 2a 02 00 00    	jae    f0101794 <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f010156a:	83 ec 04             	sub    $0x4,%esp
f010156d:	68 00 10 00 00       	push   $0x1000
f0101572:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101574:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010157a:	52                   	push   %edx
f010157b:	e8 34 3e 00 00       	call   f01053b4 <memset>
	page_free(pp0);
f0101580:	89 34 24             	mov    %esi,(%esp)
f0101583:	e8 97 f9 ff ff       	call   f0100f1f <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010158f:	e8 16 f9 ff ff       	call   f0100eaa <page_alloc>
f0101594:	83 c4 10             	add    $0x10,%esp
f0101597:	85 c0                	test   %eax,%eax
f0101599:	0f 84 07 02 00 00    	je     f01017a6 <mem_init+0x50f>
	assert(pp && pp0 == pp);
f010159f:	39 c6                	cmp    %eax,%esi
f01015a1:	0f 85 18 02 00 00    	jne    f01017bf <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f01015a7:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f01015ad:	c1 f8 03             	sar    $0x3,%eax
f01015b0:	89 c2                	mov    %eax,%edx
f01015b2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01015b5:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01015ba:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f01015c0:	0f 83 12 02 00 00    	jae    f01017d8 <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f01015c6:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01015cc:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01015d2:	80 38 00             	cmpb   $0x0,(%eax)
f01015d5:	0f 85 0f 02 00 00    	jne    f01017ea <mem_init+0x553>
	for (i = 0; i < PGSIZE; i++)
f01015db:	83 c0 01             	add    $0x1,%eax
f01015de:	39 d0                	cmp    %edx,%eax
f01015e0:	75 f0                	jne    f01015d2 <mem_init+0x33b>
	page_free_list = fl;
f01015e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01015e5:	a3 6c b2 1e f0       	mov    %eax,0xf01eb26c
	page_free(pp0);
f01015ea:	83 ec 0c             	sub    $0xc,%esp
f01015ed:	56                   	push   %esi
f01015ee:	e8 2c f9 ff ff       	call   f0100f1f <page_free>
	page_free(pp1);
f01015f3:	89 3c 24             	mov    %edi,(%esp)
f01015f6:	e8 24 f9 ff ff       	call   f0100f1f <page_free>
	page_free(pp2);
f01015fb:	83 c4 04             	add    $0x4,%esp
f01015fe:	ff 75 d4             	push   -0x2c(%ebp)
f0101601:	e8 19 f9 ff ff       	call   f0100f1f <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101606:	a1 6c b2 1e f0       	mov    0xf01eb26c,%eax
f010160b:	83 c4 10             	add    $0x10,%esp
f010160e:	85 c0                	test   %eax,%eax
f0101610:	0f 84 ed 01 00 00    	je     f0101803 <mem_init+0x56c>
		--nfree;
f0101616:	83 eb 01             	sub    $0x1,%ebx
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101619:	8b 00                	mov    (%eax),%eax
f010161b:	eb f1                	jmp    f010160e <mem_init+0x377>
	assert((pp0 = page_alloc(0)));
f010161d:	68 97 6f 10 f0       	push   $0xf0106f97
f0101622:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101627:	68 e2 02 00 00       	push   $0x2e2
f010162c:	68 81 6e 10 f0       	push   $0xf0106e81
f0101631:	e8 0a ea ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101636:	68 ad 6f 10 f0       	push   $0xf0106fad
f010163b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101640:	68 e3 02 00 00       	push   $0x2e3
f0101645:	68 81 6e 10 f0       	push   $0xf0106e81
f010164a:	e8 f1 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010164f:	68 c3 6f 10 f0       	push   $0xf0106fc3
f0101654:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101659:	68 e4 02 00 00       	push   $0x2e4
f010165e:	68 81 6e 10 f0       	push   $0xf0106e81
f0101663:	e8 d8 e9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101668:	68 d9 6f 10 f0       	push   $0xf0106fd9
f010166d:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101672:	68 e7 02 00 00       	push   $0x2e7
f0101677:	68 81 6e 10 f0       	push   $0xf0106e81
f010167c:	e8 bf e9 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101681:	68 a4 66 10 f0       	push   $0xf01066a4
f0101686:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010168b:	68 e8 02 00 00       	push   $0x2e8
f0101690:	68 81 6e 10 f0       	push   $0xf0106e81
f0101695:	e8 a6 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f010169a:	68 eb 6f 10 f0       	push   $0xf0106feb
f010169f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01016a4:	68 e9 02 00 00       	push   $0x2e9
f01016a9:	68 81 6e 10 f0       	push   $0xf0106e81
f01016ae:	e8 8d e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01016b3:	68 08 70 10 f0       	push   $0xf0107008
f01016b8:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01016bd:	68 ea 02 00 00       	push   $0x2ea
f01016c2:	68 81 6e 10 f0       	push   $0xf0106e81
f01016c7:	e8 74 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f01016cc:	68 25 70 10 f0       	push   $0xf0107025
f01016d1:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01016d6:	68 eb 02 00 00       	push   $0x2eb
f01016db:	68 81 6e 10 f0       	push   $0xf0106e81
f01016e0:	e8 5b e9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01016e5:	68 42 70 10 f0       	push   $0xf0107042
f01016ea:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01016ef:	68 f2 02 00 00       	push   $0x2f2
f01016f4:	68 81 6e 10 f0       	push   $0xf0106e81
f01016f9:	e8 42 e9 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01016fe:	68 97 6f 10 f0       	push   $0xf0106f97
f0101703:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101708:	68 f9 02 00 00       	push   $0x2f9
f010170d:	68 81 6e 10 f0       	push   $0xf0106e81
f0101712:	e8 29 e9 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101717:	68 ad 6f 10 f0       	push   $0xf0106fad
f010171c:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101721:	68 fa 02 00 00       	push   $0x2fa
f0101726:	68 81 6e 10 f0       	push   $0xf0106e81
f010172b:	e8 10 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101730:	68 c3 6f 10 f0       	push   $0xf0106fc3
f0101735:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010173a:	68 fb 02 00 00       	push   $0x2fb
f010173f:	68 81 6e 10 f0       	push   $0xf0106e81
f0101744:	e8 f7 e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101749:	68 d9 6f 10 f0       	push   $0xf0106fd9
f010174e:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101753:	68 fd 02 00 00       	push   $0x2fd
f0101758:	68 81 6e 10 f0       	push   $0xf0106e81
f010175d:	e8 de e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101762:	68 a4 66 10 f0       	push   $0xf01066a4
f0101767:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010176c:	68 fe 02 00 00       	push   $0x2fe
f0101771:	68 81 6e 10 f0       	push   $0xf0106e81
f0101776:	e8 c5 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010177b:	68 42 70 10 f0       	push   $0xf0107042
f0101780:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0101785:	68 ff 02 00 00       	push   $0x2ff
f010178a:	68 81 6e 10 f0       	push   $0xf0106e81
f010178f:	e8 ac e8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101794:	52                   	push   %edx
f0101795:	68 04 60 10 f0       	push   $0xf0106004
f010179a:	6a 58                	push   $0x58
f010179c:	68 8d 6e 10 f0       	push   $0xf0106e8d
f01017a1:	e8 9a e8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01017a6:	68 51 70 10 f0       	push   $0xf0107051
f01017ab:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01017b0:	68 04 03 00 00       	push   $0x304
f01017b5:	68 81 6e 10 f0       	push   $0xf0106e81
f01017ba:	e8 81 e8 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f01017bf:	68 6f 70 10 f0       	push   $0xf010706f
f01017c4:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01017c9:	68 05 03 00 00       	push   $0x305
f01017ce:	68 81 6e 10 f0       	push   $0xf0106e81
f01017d3:	e8 68 e8 ff ff       	call   f0100040 <_panic>
f01017d8:	52                   	push   %edx
f01017d9:	68 04 60 10 f0       	push   $0xf0106004
f01017de:	6a 58                	push   $0x58
f01017e0:	68 8d 6e 10 f0       	push   $0xf0106e8d
f01017e5:	e8 56 e8 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f01017ea:	68 7f 70 10 f0       	push   $0xf010707f
f01017ef:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01017f4:	68 08 03 00 00       	push   $0x308
f01017f9:	68 81 6e 10 f0       	push   $0xf0106e81
f01017fe:	e8 3d e8 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f0101803:	85 db                	test   %ebx,%ebx
f0101805:	0f 85 31 09 00 00    	jne    f010213c <mem_init+0xea5>
	cprintf("check_page_alloc() succeeded!\n");
f010180b:	83 ec 0c             	sub    $0xc,%esp
f010180e:	68 c4 66 10 f0       	push   $0xf01066c4
f0101813:	e8 f5 1f 00 00       	call   f010380d <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010181f:	e8 86 f6 ff ff       	call   f0100eaa <page_alloc>
f0101824:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101827:	83 c4 10             	add    $0x10,%esp
f010182a:	85 c0                	test   %eax,%eax
f010182c:	0f 84 23 09 00 00    	je     f0102155 <mem_init+0xebe>
	assert((pp1 = page_alloc(0)));
f0101832:	83 ec 0c             	sub    $0xc,%esp
f0101835:	6a 00                	push   $0x0
f0101837:	e8 6e f6 ff ff       	call   f0100eaa <page_alloc>
f010183c:	89 c3                	mov    %eax,%ebx
f010183e:	83 c4 10             	add    $0x10,%esp
f0101841:	85 c0                	test   %eax,%eax
f0101843:	0f 84 25 09 00 00    	je     f010216e <mem_init+0xed7>
	assert((pp2 = page_alloc(0)));
f0101849:	83 ec 0c             	sub    $0xc,%esp
f010184c:	6a 00                	push   $0x0
f010184e:	e8 57 f6 ff ff       	call   f0100eaa <page_alloc>
f0101853:	89 c6                	mov    %eax,%esi
f0101855:	83 c4 10             	add    $0x10,%esp
f0101858:	85 c0                	test   %eax,%eax
f010185a:	0f 84 27 09 00 00    	je     f0102187 <mem_init+0xef0>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101860:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101863:	0f 84 37 09 00 00    	je     f01021a0 <mem_init+0xf09>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101869:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f010186c:	0f 84 47 09 00 00    	je     f01021b9 <mem_init+0xf22>
f0101872:	39 c3                	cmp    %eax,%ebx
f0101874:	0f 84 3f 09 00 00    	je     f01021b9 <mem_init+0xf22>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f010187a:	a1 6c b2 1e f0       	mov    0xf01eb26c,%eax
f010187f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101882:	c7 05 6c b2 1e f0 00 	movl   $0x0,0xf01eb26c
f0101889:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010188c:	83 ec 0c             	sub    $0xc,%esp
f010188f:	6a 00                	push   $0x0
f0101891:	e8 14 f6 ff ff       	call   f0100eaa <page_alloc>
f0101896:	83 c4 10             	add    $0x10,%esp
f0101899:	85 c0                	test   %eax,%eax
f010189b:	0f 85 31 09 00 00    	jne    f01021d2 <mem_init+0xf3b>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01018a1:	83 ec 04             	sub    $0x4,%esp
f01018a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01018a7:	50                   	push   %eax
f01018a8:	6a 00                	push   $0x0
f01018aa:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f01018b0:	e8 00 f8 ff ff       	call   f01010b5 <page_lookup>
f01018b5:	83 c4 10             	add    $0x10,%esp
f01018b8:	85 c0                	test   %eax,%eax
f01018ba:	0f 85 2b 09 00 00    	jne    f01021eb <mem_init+0xf54>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01018c0:	6a 02                	push   $0x2
f01018c2:	6a 00                	push   $0x0
f01018c4:	53                   	push   %ebx
f01018c5:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f01018cb:	e8 db f8 ff ff       	call   f01011ab <page_insert>
f01018d0:	83 c4 10             	add    $0x10,%esp
f01018d3:	85 c0                	test   %eax,%eax
f01018d5:	0f 89 29 09 00 00    	jns    f0102204 <mem_init+0xf6d>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01018db:	83 ec 0c             	sub    $0xc,%esp
f01018de:	ff 75 d4             	push   -0x2c(%ebp)
f01018e1:	e8 39 f6 ff ff       	call   f0100f1f <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01018e6:	6a 02                	push   $0x2
f01018e8:	6a 00                	push   $0x0
f01018ea:	53                   	push   %ebx
f01018eb:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f01018f1:	e8 b5 f8 ff ff       	call   f01011ab <page_insert>
f01018f6:	83 c4 20             	add    $0x20,%esp
f01018f9:	85 c0                	test   %eax,%eax
f01018fb:	0f 85 1c 09 00 00    	jne    f010221d <mem_init+0xf86>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101901:	8b 3d 5c b2 1e f0    	mov    0xf01eb25c,%edi
	return (pp - pages) << PGSHIFT;
f0101907:	8b 0d 58 b2 1e f0    	mov    0xf01eb258,%ecx
f010190d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101910:	8b 17                	mov    (%edi),%edx
f0101912:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010191b:	29 c8                	sub    %ecx,%eax
f010191d:	c1 f8 03             	sar    $0x3,%eax
f0101920:	c1 e0 0c             	shl    $0xc,%eax
f0101923:	39 c2                	cmp    %eax,%edx
f0101925:	0f 85 0b 09 00 00    	jne    f0102236 <mem_init+0xf9f>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010192b:	ba 00 00 00 00       	mov    $0x0,%edx
f0101930:	89 f8                	mov    %edi,%eax
f0101932:	e8 5a f1 ff ff       	call   f0100a91 <check_va2pa>
f0101937:	89 c2                	mov    %eax,%edx
f0101939:	89 d8                	mov    %ebx,%eax
f010193b:	2b 45 d0             	sub    -0x30(%ebp),%eax
f010193e:	c1 f8 03             	sar    $0x3,%eax
f0101941:	c1 e0 0c             	shl    $0xc,%eax
f0101944:	39 c2                	cmp    %eax,%edx
f0101946:	0f 85 03 09 00 00    	jne    f010224f <mem_init+0xfb8>
	assert(pp1->pp_ref == 1);
f010194c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101951:	0f 85 11 09 00 00    	jne    f0102268 <mem_init+0xfd1>
	assert(pp0->pp_ref == 1);
f0101957:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010195a:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010195f:	0f 85 1c 09 00 00    	jne    f0102281 <mem_init+0xfea>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101965:	6a 02                	push   $0x2
f0101967:	68 00 10 00 00       	push   $0x1000
f010196c:	56                   	push   %esi
f010196d:	57                   	push   %edi
f010196e:	e8 38 f8 ff ff       	call   f01011ab <page_insert>
f0101973:	83 c4 10             	add    $0x10,%esp
f0101976:	85 c0                	test   %eax,%eax
f0101978:	0f 85 1c 09 00 00    	jne    f010229a <mem_init+0x1003>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010197e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101983:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0101988:	e8 04 f1 ff ff       	call   f0100a91 <check_va2pa>
f010198d:	89 c2                	mov    %eax,%edx
f010198f:	89 f0                	mov    %esi,%eax
f0101991:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101997:	c1 f8 03             	sar    $0x3,%eax
f010199a:	c1 e0 0c             	shl    $0xc,%eax
f010199d:	39 c2                	cmp    %eax,%edx
f010199f:	0f 85 0e 09 00 00    	jne    f01022b3 <mem_init+0x101c>
	assert(pp2->pp_ref == 1);
f01019a5:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01019aa:	0f 85 1c 09 00 00    	jne    f01022cc <mem_init+0x1035>

	// should be no free memory
	assert(!page_alloc(0));
f01019b0:	83 ec 0c             	sub    $0xc,%esp
f01019b3:	6a 00                	push   $0x0
f01019b5:	e8 f0 f4 ff ff       	call   f0100eaa <page_alloc>
f01019ba:	83 c4 10             	add    $0x10,%esp
f01019bd:	85 c0                	test   %eax,%eax
f01019bf:	0f 85 20 09 00 00    	jne    f01022e5 <mem_init+0x104e>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01019c5:	6a 02                	push   $0x2
f01019c7:	68 00 10 00 00       	push   $0x1000
f01019cc:	56                   	push   %esi
f01019cd:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f01019d3:	e8 d3 f7 ff ff       	call   f01011ab <page_insert>
f01019d8:	83 c4 10             	add    $0x10,%esp
f01019db:	85 c0                	test   %eax,%eax
f01019dd:	0f 85 1b 09 00 00    	jne    f01022fe <mem_init+0x1067>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01019e3:	ba 00 10 00 00       	mov    $0x1000,%edx
f01019e8:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f01019ed:	e8 9f f0 ff ff       	call   f0100a91 <check_va2pa>
f01019f2:	89 c2                	mov    %eax,%edx
f01019f4:	89 f0                	mov    %esi,%eax
f01019f6:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f01019fc:	c1 f8 03             	sar    $0x3,%eax
f01019ff:	c1 e0 0c             	shl    $0xc,%eax
f0101a02:	39 c2                	cmp    %eax,%edx
f0101a04:	0f 85 0d 09 00 00    	jne    f0102317 <mem_init+0x1080>
	assert(pp2->pp_ref == 1);
f0101a0a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101a0f:	0f 85 1b 09 00 00    	jne    f0102330 <mem_init+0x1099>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101a15:	83 ec 0c             	sub    $0xc,%esp
f0101a18:	6a 00                	push   $0x0
f0101a1a:	e8 8b f4 ff ff       	call   f0100eaa <page_alloc>
f0101a1f:	83 c4 10             	add    $0x10,%esp
f0101a22:	85 c0                	test   %eax,%eax
f0101a24:	0f 85 1f 09 00 00    	jne    f0102349 <mem_init+0x10b2>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101a2a:	8b 15 5c b2 1e f0    	mov    0xf01eb25c,%edx
f0101a30:	8b 02                	mov    (%edx),%eax
f0101a32:	89 c7                	mov    %eax,%edi
f0101a34:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if (PGNUM(pa) >= npages)
f0101a3a:	c1 e8 0c             	shr    $0xc,%eax
f0101a3d:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0101a43:	0f 83 19 09 00 00    	jae    f0102362 <mem_init+0x10cb>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101a49:	83 ec 04             	sub    $0x4,%esp
f0101a4c:	6a 00                	push   $0x0
f0101a4e:	68 00 10 00 00       	push   $0x1000
f0101a53:	52                   	push   %edx
f0101a54:	e8 25 f5 ff ff       	call   f0100f7e <pgdir_walk>
f0101a59:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0101a5f:	83 c4 10             	add    $0x10,%esp
f0101a62:	39 f8                	cmp    %edi,%eax
f0101a64:	0f 85 0d 09 00 00    	jne    f0102377 <mem_init+0x10e0>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101a6a:	6a 06                	push   $0x6
f0101a6c:	68 00 10 00 00       	push   $0x1000
f0101a71:	56                   	push   %esi
f0101a72:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101a78:	e8 2e f7 ff ff       	call   f01011ab <page_insert>
f0101a7d:	83 c4 10             	add    $0x10,%esp
f0101a80:	85 c0                	test   %eax,%eax
f0101a82:	0f 85 08 09 00 00    	jne    f0102390 <mem_init+0x10f9>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a88:	8b 3d 5c b2 1e f0    	mov    0xf01eb25c,%edi
f0101a8e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a93:	89 f8                	mov    %edi,%eax
f0101a95:	e8 f7 ef ff ff       	call   f0100a91 <check_va2pa>
f0101a9a:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101a9c:	89 f0                	mov    %esi,%eax
f0101a9e:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101aa4:	c1 f8 03             	sar    $0x3,%eax
f0101aa7:	c1 e0 0c             	shl    $0xc,%eax
f0101aaa:	39 c2                	cmp    %eax,%edx
f0101aac:	0f 85 f7 08 00 00    	jne    f01023a9 <mem_init+0x1112>
	assert(pp2->pp_ref == 1);
f0101ab2:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101ab7:	0f 85 05 09 00 00    	jne    f01023c2 <mem_init+0x112b>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101abd:	83 ec 04             	sub    $0x4,%esp
f0101ac0:	6a 00                	push   $0x0
f0101ac2:	68 00 10 00 00       	push   $0x1000
f0101ac7:	57                   	push   %edi
f0101ac8:	e8 b1 f4 ff ff       	call   f0100f7e <pgdir_walk>
f0101acd:	83 c4 10             	add    $0x10,%esp
f0101ad0:	f6 00 04             	testb  $0x4,(%eax)
f0101ad3:	0f 84 02 09 00 00    	je     f01023db <mem_init+0x1144>
	assert(kern_pgdir[0] & PTE_U);
f0101ad9:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0101ade:	f6 00 04             	testb  $0x4,(%eax)
f0101ae1:	0f 84 0d 09 00 00    	je     f01023f4 <mem_init+0x115d>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ae7:	6a 02                	push   $0x2
f0101ae9:	68 00 10 00 00       	push   $0x1000
f0101aee:	56                   	push   %esi
f0101aef:	50                   	push   %eax
f0101af0:	e8 b6 f6 ff ff       	call   f01011ab <page_insert>
f0101af5:	83 c4 10             	add    $0x10,%esp
f0101af8:	85 c0                	test   %eax,%eax
f0101afa:	0f 85 0d 09 00 00    	jne    f010240d <mem_init+0x1176>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101b00:	83 ec 04             	sub    $0x4,%esp
f0101b03:	6a 00                	push   $0x0
f0101b05:	68 00 10 00 00       	push   $0x1000
f0101b0a:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101b10:	e8 69 f4 ff ff       	call   f0100f7e <pgdir_walk>
f0101b15:	83 c4 10             	add    $0x10,%esp
f0101b18:	f6 00 02             	testb  $0x2,(%eax)
f0101b1b:	0f 84 05 09 00 00    	je     f0102426 <mem_init+0x118f>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101b21:	83 ec 04             	sub    $0x4,%esp
f0101b24:	6a 00                	push   $0x0
f0101b26:	68 00 10 00 00       	push   $0x1000
f0101b2b:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101b31:	e8 48 f4 ff ff       	call   f0100f7e <pgdir_walk>
f0101b36:	83 c4 10             	add    $0x10,%esp
f0101b39:	f6 00 04             	testb  $0x4,(%eax)
f0101b3c:	0f 85 fd 08 00 00    	jne    f010243f <mem_init+0x11a8>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101b42:	6a 02                	push   $0x2
f0101b44:	68 00 00 40 00       	push   $0x400000
f0101b49:	ff 75 d4             	push   -0x2c(%ebp)
f0101b4c:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101b52:	e8 54 f6 ff ff       	call   f01011ab <page_insert>
f0101b57:	83 c4 10             	add    $0x10,%esp
f0101b5a:	85 c0                	test   %eax,%eax
f0101b5c:	0f 89 f6 08 00 00    	jns    f0102458 <mem_init+0x11c1>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101b62:	6a 02                	push   $0x2
f0101b64:	68 00 10 00 00       	push   $0x1000
f0101b69:	53                   	push   %ebx
f0101b6a:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101b70:	e8 36 f6 ff ff       	call   f01011ab <page_insert>
f0101b75:	83 c4 10             	add    $0x10,%esp
f0101b78:	85 c0                	test   %eax,%eax
f0101b7a:	0f 85 f1 08 00 00    	jne    f0102471 <mem_init+0x11da>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101b80:	83 ec 04             	sub    $0x4,%esp
f0101b83:	6a 00                	push   $0x0
f0101b85:	68 00 10 00 00       	push   $0x1000
f0101b8a:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101b90:	e8 e9 f3 ff ff       	call   f0100f7e <pgdir_walk>
f0101b95:	83 c4 10             	add    $0x10,%esp
f0101b98:	f6 00 04             	testb  $0x4,(%eax)
f0101b9b:	0f 85 e9 08 00 00    	jne    f010248a <mem_init+0x11f3>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101ba1:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0101ba6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101ba9:	ba 00 00 00 00       	mov    $0x0,%edx
f0101bae:	e8 de ee ff ff       	call   f0100a91 <check_va2pa>
f0101bb3:	89 df                	mov    %ebx,%edi
f0101bb5:	2b 3d 58 b2 1e f0    	sub    0xf01eb258,%edi
f0101bbb:	c1 ff 03             	sar    $0x3,%edi
f0101bbe:	c1 e7 0c             	shl    $0xc,%edi
f0101bc1:	39 f8                	cmp    %edi,%eax
f0101bc3:	0f 85 da 08 00 00    	jne    f01024a3 <mem_init+0x120c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101bc9:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101bce:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101bd1:	e8 bb ee ff ff       	call   f0100a91 <check_va2pa>
f0101bd6:	39 c7                	cmp    %eax,%edi
f0101bd8:	0f 85 de 08 00 00    	jne    f01024bc <mem_init+0x1225>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101bde:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101be3:	0f 85 ec 08 00 00    	jne    f01024d5 <mem_init+0x123e>
	assert(pp2->pp_ref == 0);
f0101be9:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101bee:	0f 85 fa 08 00 00    	jne    f01024ee <mem_init+0x1257>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101bf4:	83 ec 0c             	sub    $0xc,%esp
f0101bf7:	6a 00                	push   $0x0
f0101bf9:	e8 ac f2 ff ff       	call   f0100eaa <page_alloc>
f0101bfe:	83 c4 10             	add    $0x10,%esp
f0101c01:	85 c0                	test   %eax,%eax
f0101c03:	0f 84 fe 08 00 00    	je     f0102507 <mem_init+0x1270>
f0101c09:	39 c6                	cmp    %eax,%esi
f0101c0b:	0f 85 f6 08 00 00    	jne    f0102507 <mem_init+0x1270>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101c11:	83 ec 08             	sub    $0x8,%esp
f0101c14:	6a 00                	push   $0x0
f0101c16:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101c1c:	e8 27 f5 ff ff       	call   f0101148 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101c21:	8b 3d 5c b2 1e f0    	mov    0xf01eb25c,%edi
f0101c27:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c2c:	89 f8                	mov    %edi,%eax
f0101c2e:	e8 5e ee ff ff       	call   f0100a91 <check_va2pa>
f0101c33:	83 c4 10             	add    $0x10,%esp
f0101c36:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101c39:	0f 85 e1 08 00 00    	jne    f0102520 <mem_init+0x1289>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c3f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c44:	89 f8                	mov    %edi,%eax
f0101c46:	e8 46 ee ff ff       	call   f0100a91 <check_va2pa>
f0101c4b:	89 c2                	mov    %eax,%edx
f0101c4d:	89 d8                	mov    %ebx,%eax
f0101c4f:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101c55:	c1 f8 03             	sar    $0x3,%eax
f0101c58:	c1 e0 0c             	shl    $0xc,%eax
f0101c5b:	39 c2                	cmp    %eax,%edx
f0101c5d:	0f 85 d6 08 00 00    	jne    f0102539 <mem_init+0x12a2>
	assert(pp1->pp_ref == 1);
f0101c63:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c68:	0f 85 e4 08 00 00    	jne    f0102552 <mem_init+0x12bb>
	assert(pp2->pp_ref == 0);
f0101c6e:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101c73:	0f 85 f2 08 00 00    	jne    f010256b <mem_init+0x12d4>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101c79:	6a 00                	push   $0x0
f0101c7b:	68 00 10 00 00       	push   $0x1000
f0101c80:	53                   	push   %ebx
f0101c81:	57                   	push   %edi
f0101c82:	e8 24 f5 ff ff       	call   f01011ab <page_insert>
f0101c87:	83 c4 10             	add    $0x10,%esp
f0101c8a:	85 c0                	test   %eax,%eax
f0101c8c:	0f 85 f2 08 00 00    	jne    f0102584 <mem_init+0x12ed>
	assert(pp1->pp_ref);
f0101c92:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101c97:	0f 84 00 09 00 00    	je     f010259d <mem_init+0x1306>
	assert(pp1->pp_link == NULL);
f0101c9d:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101ca0:	0f 85 10 09 00 00    	jne    f01025b6 <mem_init+0x131f>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101ca6:	83 ec 08             	sub    $0x8,%esp
f0101ca9:	68 00 10 00 00       	push   $0x1000
f0101cae:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101cb4:	e8 8f f4 ff ff       	call   f0101148 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101cb9:	8b 3d 5c b2 1e f0    	mov    0xf01eb25c,%edi
f0101cbf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101cc4:	89 f8                	mov    %edi,%eax
f0101cc6:	e8 c6 ed ff ff       	call   f0100a91 <check_va2pa>
f0101ccb:	83 c4 10             	add    $0x10,%esp
f0101cce:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101cd1:	0f 85 f8 08 00 00    	jne    f01025cf <mem_init+0x1338>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101cd7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101cdc:	89 f8                	mov    %edi,%eax
f0101cde:	e8 ae ed ff ff       	call   f0100a91 <check_va2pa>
f0101ce3:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ce6:	0f 85 fc 08 00 00    	jne    f01025e8 <mem_init+0x1351>
	assert(pp1->pp_ref == 0);
f0101cec:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101cf1:	0f 85 0a 09 00 00    	jne    f0102601 <mem_init+0x136a>
	assert(pp2->pp_ref == 0);
f0101cf7:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101cfc:	0f 85 18 09 00 00    	jne    f010261a <mem_init+0x1383>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101d02:	83 ec 0c             	sub    $0xc,%esp
f0101d05:	6a 00                	push   $0x0
f0101d07:	e8 9e f1 ff ff       	call   f0100eaa <page_alloc>
f0101d0c:	83 c4 10             	add    $0x10,%esp
f0101d0f:	39 c3                	cmp    %eax,%ebx
f0101d11:	0f 85 1c 09 00 00    	jne    f0102633 <mem_init+0x139c>
f0101d17:	85 c0                	test   %eax,%eax
f0101d19:	0f 84 14 09 00 00    	je     f0102633 <mem_init+0x139c>

	// should be no free memory
	assert(!page_alloc(0));
f0101d1f:	83 ec 0c             	sub    $0xc,%esp
f0101d22:	6a 00                	push   $0x0
f0101d24:	e8 81 f1 ff ff       	call   f0100eaa <page_alloc>
f0101d29:	83 c4 10             	add    $0x10,%esp
f0101d2c:	85 c0                	test   %eax,%eax
f0101d2e:	0f 85 18 09 00 00    	jne    f010264c <mem_init+0x13b5>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d34:	8b 0d 5c b2 1e f0    	mov    0xf01eb25c,%ecx
f0101d3a:	8b 11                	mov    (%ecx),%edx
f0101d3c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d45:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101d4b:	c1 f8 03             	sar    $0x3,%eax
f0101d4e:	c1 e0 0c             	shl    $0xc,%eax
f0101d51:	39 c2                	cmp    %eax,%edx
f0101d53:	0f 85 0c 09 00 00    	jne    f0102665 <mem_init+0x13ce>
	kern_pgdir[0] = 0;
f0101d59:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101d5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d62:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101d67:	0f 85 11 09 00 00    	jne    f010267e <mem_init+0x13e7>
	pp0->pp_ref = 0;
f0101d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d70:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101d76:	83 ec 0c             	sub    $0xc,%esp
f0101d79:	50                   	push   %eax
f0101d7a:	e8 a0 f1 ff ff       	call   f0100f1f <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101d7f:	83 c4 0c             	add    $0xc,%esp
f0101d82:	6a 01                	push   $0x1
f0101d84:	68 00 10 40 00       	push   $0x401000
f0101d89:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101d8f:	e8 ea f1 ff ff       	call   f0100f7e <pgdir_walk>
f0101d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101d97:	8b 0d 5c b2 1e f0    	mov    0xf01eb25c,%ecx
f0101d9d:	8b 41 04             	mov    0x4(%ecx),%eax
f0101da0:	89 c7                	mov    %eax,%edi
f0101da2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if (PGNUM(pa) >= npages)
f0101da8:	8b 15 60 b2 1e f0    	mov    0xf01eb260,%edx
f0101dae:	c1 e8 0c             	shr    $0xc,%eax
f0101db1:	83 c4 10             	add    $0x10,%esp
f0101db4:	39 d0                	cmp    %edx,%eax
f0101db6:	0f 83 db 08 00 00    	jae    f0102697 <mem_init+0x1400>
	assert(ptep == ptep1 + PTX(va));
f0101dbc:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0101dc2:	39 7d d0             	cmp    %edi,-0x30(%ebp)
f0101dc5:	0f 85 e1 08 00 00    	jne    f01026ac <mem_init+0x1415>
	kern_pgdir[PDX(va)] = 0;
f0101dcb:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dd5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101ddb:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101de1:	c1 f8 03             	sar    $0x3,%eax
f0101de4:	89 c1                	mov    %eax,%ecx
f0101de6:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0101de9:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101dee:	39 c2                	cmp    %eax,%edx
f0101df0:	0f 86 cf 08 00 00    	jbe    f01026c5 <mem_init+0x142e>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101df6:	83 ec 04             	sub    $0x4,%esp
f0101df9:	68 00 10 00 00       	push   $0x1000
f0101dfe:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101e03:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0101e09:	51                   	push   %ecx
f0101e0a:	e8 a5 35 00 00       	call   f01053b4 <memset>
	page_free(pp0);
f0101e0f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101e12:	89 3c 24             	mov    %edi,(%esp)
f0101e15:	e8 05 f1 ff ff       	call   f0100f1f <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101e1a:	83 c4 0c             	add    $0xc,%esp
f0101e1d:	6a 01                	push   $0x1
f0101e1f:	6a 00                	push   $0x0
f0101e21:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101e27:	e8 52 f1 ff ff       	call   f0100f7e <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101e2c:	89 f8                	mov    %edi,%eax
f0101e2e:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0101e34:	c1 f8 03             	sar    $0x3,%eax
f0101e37:	89 c2                	mov    %eax,%edx
f0101e39:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101e3c:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101e41:	83 c4 10             	add    $0x10,%esp
f0101e44:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0101e4a:	0f 83 87 08 00 00    	jae    f01026d7 <mem_init+0x1440>
	return (void *)(pa + KERNBASE);
f0101e50:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101e56:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101e5c:	f6 00 01             	testb  $0x1,(%eax)
f0101e5f:	0f 85 84 08 00 00    	jne    f01026e9 <mem_init+0x1452>
	for(i=0; i<NPTENTRIES; i++)
f0101e65:	83 c0 04             	add    $0x4,%eax
f0101e68:	39 d0                	cmp    %edx,%eax
f0101e6a:	75 f0                	jne    f0101e5c <mem_init+0xbc5>
	kern_pgdir[0] = 0;
f0101e6c:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0101e71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101e77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e7a:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101e80:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101e83:	89 0d 6c b2 1e f0    	mov    %ecx,0xf01eb26c

	// free the pages we took
	page_free(pp0);
f0101e89:	83 ec 0c             	sub    $0xc,%esp
f0101e8c:	50                   	push   %eax
f0101e8d:	e8 8d f0 ff ff       	call   f0100f1f <page_free>
	page_free(pp1);
f0101e92:	89 1c 24             	mov    %ebx,(%esp)
f0101e95:	e8 85 f0 ff ff       	call   f0100f1f <page_free>
	page_free(pp2);
f0101e9a:	89 34 24             	mov    %esi,(%esp)
f0101e9d:	e8 7d f0 ff ff       	call   f0100f1f <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0101ea2:	83 c4 08             	add    $0x8,%esp
f0101ea5:	68 01 10 00 00       	push   $0x1001
f0101eaa:	6a 00                	push   $0x0
f0101eac:	e8 6c f3 ff ff       	call   f010121d <mmio_map_region>
f0101eb1:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0101eb3:	83 c4 08             	add    $0x8,%esp
f0101eb6:	68 00 10 00 00       	push   $0x1000
f0101ebb:	6a 00                	push   $0x0
f0101ebd:	e8 5b f3 ff ff       	call   f010121d <mmio_map_region>
f0101ec2:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0101ec4:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0101eca:	83 c4 10             	add    $0x10,%esp
f0101ecd:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101ed3:	0f 86 29 08 00 00    	jbe    f0102702 <mem_init+0x146b>
f0101ed9:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101ede:	0f 87 1e 08 00 00    	ja     f0102702 <mem_init+0x146b>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0101ee4:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0101eea:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0101ef0:	0f 87 25 08 00 00    	ja     f010271b <mem_init+0x1484>
f0101ef6:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0101efc:	0f 86 19 08 00 00    	jbe    f010271b <mem_init+0x1484>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0101f02:	89 da                	mov    %ebx,%edx
f0101f04:	09 f2                	or     %esi,%edx
f0101f06:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101f0c:	0f 85 22 08 00 00    	jne    f0102734 <mem_init+0x149d>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0101f12:	39 c6                	cmp    %eax,%esi
f0101f14:	0f 82 33 08 00 00    	jb     f010274d <mem_init+0x14b6>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0101f1a:	8b 3d 5c b2 1e f0    	mov    0xf01eb25c,%edi
f0101f20:	89 da                	mov    %ebx,%edx
f0101f22:	89 f8                	mov    %edi,%eax
f0101f24:	e8 68 eb ff ff       	call   f0100a91 <check_va2pa>
f0101f29:	85 c0                	test   %eax,%eax
f0101f2b:	0f 85 35 08 00 00    	jne    f0102766 <mem_init+0x14cf>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0101f31:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0101f37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f3a:	89 c2                	mov    %eax,%edx
f0101f3c:	89 f8                	mov    %edi,%eax
f0101f3e:	e8 4e eb ff ff       	call   f0100a91 <check_va2pa>
f0101f43:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0101f48:	0f 85 31 08 00 00    	jne    f010277f <mem_init+0x14e8>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0101f4e:	89 f2                	mov    %esi,%edx
f0101f50:	89 f8                	mov    %edi,%eax
f0101f52:	e8 3a eb ff ff       	call   f0100a91 <check_va2pa>
f0101f57:	85 c0                	test   %eax,%eax
f0101f59:	0f 85 39 08 00 00    	jne    f0102798 <mem_init+0x1501>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0101f5f:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0101f65:	89 f8                	mov    %edi,%eax
f0101f67:	e8 25 eb ff ff       	call   f0100a91 <check_va2pa>
f0101f6c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f6f:	0f 85 3c 08 00 00    	jne    f01027b1 <mem_init+0x151a>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0101f75:	83 ec 04             	sub    $0x4,%esp
f0101f78:	6a 00                	push   $0x0
f0101f7a:	53                   	push   %ebx
f0101f7b:	57                   	push   %edi
f0101f7c:	e8 fd ef ff ff       	call   f0100f7e <pgdir_walk>
f0101f81:	83 c4 10             	add    $0x10,%esp
f0101f84:	f6 00 1a             	testb  $0x1a,(%eax)
f0101f87:	0f 84 3d 08 00 00    	je     f01027ca <mem_init+0x1533>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0101f8d:	83 ec 04             	sub    $0x4,%esp
f0101f90:	6a 00                	push   $0x0
f0101f92:	53                   	push   %ebx
f0101f93:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101f99:	e8 e0 ef ff ff       	call   f0100f7e <pgdir_walk>
f0101f9e:	8b 00                	mov    (%eax),%eax
f0101fa0:	83 c4 10             	add    $0x10,%esp
f0101fa3:	83 e0 04             	and    $0x4,%eax
f0101fa6:	89 c7                	mov    %eax,%edi
f0101fa8:	0f 85 35 08 00 00    	jne    f01027e3 <mem_init+0x154c>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0101fae:	83 ec 04             	sub    $0x4,%esp
f0101fb1:	6a 00                	push   $0x0
f0101fb3:	53                   	push   %ebx
f0101fb4:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101fba:	e8 bf ef ff ff       	call   f0100f7e <pgdir_walk>
f0101fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0101fc5:	83 c4 0c             	add    $0xc,%esp
f0101fc8:	6a 00                	push   $0x0
f0101fca:	ff 75 d4             	push   -0x2c(%ebp)
f0101fcd:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101fd3:	e8 a6 ef ff ff       	call   f0100f7e <pgdir_walk>
f0101fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0101fde:	83 c4 0c             	add    $0xc,%esp
f0101fe1:	6a 00                	push   $0x0
f0101fe3:	56                   	push   %esi
f0101fe4:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0101fea:	e8 8f ef ff ff       	call   f0100f7e <pgdir_walk>
f0101fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0101ff5:	c7 04 24 72 71 10 f0 	movl   $0xf0107172,(%esp)
f0101ffc:	e8 0c 18 00 00       	call   f010380d <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102001:	a1 58 b2 1e f0       	mov    0xf01eb258,%eax
	if ((uint32_t)kva < KERNBASE)
f0102006:	83 c4 10             	add    $0x10,%esp
f0102009:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010200e:	0f 86 e8 07 00 00    	jbe    f01027fc <mem_init+0x1565>
f0102014:	83 ec 08             	sub    $0x8,%esp
f0102017:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102019:	05 00 00 00 10       	add    $0x10000000,%eax
f010201e:	50                   	push   %eax
f010201f:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102024:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102029:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f010202e:	e8 15 f0 ff ff       	call   f0101048 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102033:	a1 74 b2 1e f0       	mov    0xf01eb274,%eax
	if ((uint32_t)kva < KERNBASE)
f0102038:	83 c4 10             	add    $0x10,%esp
f010203b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102040:	0f 86 cb 07 00 00    	jbe    f0102811 <mem_init+0x157a>
f0102046:	83 ec 08             	sub    $0x8,%esp
f0102049:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010204b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102050:	50                   	push   %eax
f0102051:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102056:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f010205b:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0102060:	e8 e3 ef ff ff       	call   f0101048 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102065:	83 c4 10             	add    $0x10,%esp
f0102068:	b8 00 a0 11 f0       	mov    $0xf011a000,%eax
f010206d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102072:	0f 86 ae 07 00 00    	jbe    f0102826 <mem_init+0x158f>
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102078:	83 ec 08             	sub    $0x8,%esp
f010207b:	6a 02                	push   $0x2
f010207d:	68 00 a0 11 00       	push   $0x11a000
f0102082:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102087:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010208c:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f0102091:	e8 b2 ef ff ff       	call   f0101048 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, -KERNBASE, 0, PTE_W);
f0102096:	83 c4 08             	add    $0x8,%esp
f0102099:	6a 02                	push   $0x2
f010209b:	6a 00                	push   $0x0
f010209d:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01020a2:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01020a7:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f01020ac:	e8 97 ef ff ff       	call   f0101048 <boot_map_region>
f01020b1:	c7 45 d0 00 c0 1e f0 	movl   $0xf01ec000,-0x30(%ebp)
f01020b8:	83 c4 10             	add    $0x10,%esp
f01020bb:	bb 00 c0 1e f0       	mov    $0xf01ec000,%ebx
f01020c0:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01020c5:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01020cb:	0f 86 6a 07 00 00    	jbe    f010283b <mem_init+0x15a4>
		boot_map_region(kern_pgdir, kstacktop_i - KSTKSIZE, KSTKSIZE, PADDR(percpu_kstacks[i]), PTE_P | PTE_W);
f01020d1:	83 ec 08             	sub    $0x8,%esp
f01020d4:	6a 03                	push   $0x3
f01020d6:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01020dc:	50                   	push   %eax
f01020dd:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01020e2:	89 f2                	mov    %esi,%edx
f01020e4:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f01020e9:	e8 5a ef ff ff       	call   f0101048 <boot_map_region>
	for (int i = 0; i < NCPU; i++) {
f01020ee:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01020f4:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f01020fa:	83 c4 10             	add    $0x10,%esp
f01020fd:	81 fb 00 c0 22 f0    	cmp    $0xf022c000,%ebx
f0102103:	75 c0                	jne    f01020c5 <mem_init+0xe2e>
	pgdir = kern_pgdir;
f0102105:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
f010210a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010210d:	a1 60 b2 1e f0       	mov    0xf01eb260,%eax
f0102112:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102115:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010211c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102121:	8b 35 58 b2 1e f0    	mov    0xf01eb258,%esi
	return (physaddr_t)kva - KERNBASE;
f0102127:	8d 8e 00 00 00 10    	lea    0x10000000(%esi),%ecx
f010212d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102130:	89 fb                	mov    %edi,%ebx
f0102132:	89 7d c8             	mov    %edi,-0x38(%ebp)
f0102135:	89 c7                	mov    %eax,%edi
f0102137:	e9 2f 07 00 00       	jmp    f010286b <mem_init+0x15d4>
	assert(nfree == 0);
f010213c:	68 89 70 10 f0       	push   $0xf0107089
f0102141:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102146:	68 15 03 00 00       	push   $0x315
f010214b:	68 81 6e 10 f0       	push   $0xf0106e81
f0102150:	e8 eb de ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102155:	68 97 6f 10 f0       	push   $0xf0106f97
f010215a:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010215f:	68 7b 03 00 00       	push   $0x37b
f0102164:	68 81 6e 10 f0       	push   $0xf0106e81
f0102169:	e8 d2 de ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010216e:	68 ad 6f 10 f0       	push   $0xf0106fad
f0102173:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102178:	68 7c 03 00 00       	push   $0x37c
f010217d:	68 81 6e 10 f0       	push   $0xf0106e81
f0102182:	e8 b9 de ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102187:	68 c3 6f 10 f0       	push   $0xf0106fc3
f010218c:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102191:	68 7d 03 00 00       	push   $0x37d
f0102196:	68 81 6e 10 f0       	push   $0xf0106e81
f010219b:	e8 a0 de ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01021a0:	68 d9 6f 10 f0       	push   $0xf0106fd9
f01021a5:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01021aa:	68 80 03 00 00       	push   $0x380
f01021af:	68 81 6e 10 f0       	push   $0xf0106e81
f01021b4:	e8 87 de ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01021b9:	68 a4 66 10 f0       	push   $0xf01066a4
f01021be:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01021c3:	68 81 03 00 00       	push   $0x381
f01021c8:	68 81 6e 10 f0       	push   $0xf0106e81
f01021cd:	e8 6e de ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01021d2:	68 42 70 10 f0       	push   $0xf0107042
f01021d7:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01021dc:	68 88 03 00 00       	push   $0x388
f01021e1:	68 81 6e 10 f0       	push   $0xf0106e81
f01021e6:	e8 55 de ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01021eb:	68 e4 66 10 f0       	push   $0xf01066e4
f01021f0:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01021f5:	68 8b 03 00 00       	push   $0x38b
f01021fa:	68 81 6e 10 f0       	push   $0xf0106e81
f01021ff:	e8 3c de ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102204:	68 1c 67 10 f0       	push   $0xf010671c
f0102209:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010220e:	68 8e 03 00 00       	push   $0x38e
f0102213:	68 81 6e 10 f0       	push   $0xf0106e81
f0102218:	e8 23 de ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010221d:	68 4c 67 10 f0       	push   $0xf010674c
f0102222:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102227:	68 92 03 00 00       	push   $0x392
f010222c:	68 81 6e 10 f0       	push   $0xf0106e81
f0102231:	e8 0a de ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102236:	68 7c 67 10 f0       	push   $0xf010677c
f010223b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102240:	68 93 03 00 00       	push   $0x393
f0102245:	68 81 6e 10 f0       	push   $0xf0106e81
f010224a:	e8 f1 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010224f:	68 a4 67 10 f0       	push   $0xf01067a4
f0102254:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102259:	68 94 03 00 00       	push   $0x394
f010225e:	68 81 6e 10 f0       	push   $0xf0106e81
f0102263:	e8 d8 dd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102268:	68 94 70 10 f0       	push   $0xf0107094
f010226d:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102272:	68 95 03 00 00       	push   $0x395
f0102277:	68 81 6e 10 f0       	push   $0xf0106e81
f010227c:	e8 bf dd ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102281:	68 a5 70 10 f0       	push   $0xf01070a5
f0102286:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010228b:	68 96 03 00 00       	push   $0x396
f0102290:	68 81 6e 10 f0       	push   $0xf0106e81
f0102295:	e8 a6 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010229a:	68 d4 67 10 f0       	push   $0xf01067d4
f010229f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01022a4:	68 99 03 00 00       	push   $0x399
f01022a9:	68 81 6e 10 f0       	push   $0xf0106e81
f01022ae:	e8 8d dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01022b3:	68 10 68 10 f0       	push   $0xf0106810
f01022b8:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01022bd:	68 9a 03 00 00       	push   $0x39a
f01022c2:	68 81 6e 10 f0       	push   $0xf0106e81
f01022c7:	e8 74 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01022cc:	68 b6 70 10 f0       	push   $0xf01070b6
f01022d1:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01022d6:	68 9b 03 00 00       	push   $0x39b
f01022db:	68 81 6e 10 f0       	push   $0xf0106e81
f01022e0:	e8 5b dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01022e5:	68 42 70 10 f0       	push   $0xf0107042
f01022ea:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01022ef:	68 9e 03 00 00       	push   $0x39e
f01022f4:	68 81 6e 10 f0       	push   $0xf0106e81
f01022f9:	e8 42 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01022fe:	68 d4 67 10 f0       	push   $0xf01067d4
f0102303:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102308:	68 a1 03 00 00       	push   $0x3a1
f010230d:	68 81 6e 10 f0       	push   $0xf0106e81
f0102312:	e8 29 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102317:	68 10 68 10 f0       	push   $0xf0106810
f010231c:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102321:	68 a2 03 00 00       	push   $0x3a2
f0102326:	68 81 6e 10 f0       	push   $0xf0106e81
f010232b:	e8 10 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102330:	68 b6 70 10 f0       	push   $0xf01070b6
f0102335:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010233a:	68 a3 03 00 00       	push   $0x3a3
f010233f:	68 81 6e 10 f0       	push   $0xf0106e81
f0102344:	e8 f7 dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102349:	68 42 70 10 f0       	push   $0xf0107042
f010234e:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102353:	68 a7 03 00 00       	push   $0x3a7
f0102358:	68 81 6e 10 f0       	push   $0xf0106e81
f010235d:	e8 de dc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102362:	57                   	push   %edi
f0102363:	68 04 60 10 f0       	push   $0xf0106004
f0102368:	68 aa 03 00 00       	push   $0x3aa
f010236d:	68 81 6e 10 f0       	push   $0xf0106e81
f0102372:	e8 c9 dc ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102377:	68 40 68 10 f0       	push   $0xf0106840
f010237c:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102381:	68 ab 03 00 00       	push   $0x3ab
f0102386:	68 81 6e 10 f0       	push   $0xf0106e81
f010238b:	e8 b0 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102390:	68 80 68 10 f0       	push   $0xf0106880
f0102395:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010239a:	68 ae 03 00 00       	push   $0x3ae
f010239f:	68 81 6e 10 f0       	push   $0xf0106e81
f01023a4:	e8 97 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01023a9:	68 10 68 10 f0       	push   $0xf0106810
f01023ae:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01023b3:	68 af 03 00 00       	push   $0x3af
f01023b8:	68 81 6e 10 f0       	push   $0xf0106e81
f01023bd:	e8 7e dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01023c2:	68 b6 70 10 f0       	push   $0xf01070b6
f01023c7:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01023cc:	68 b0 03 00 00       	push   $0x3b0
f01023d1:	68 81 6e 10 f0       	push   $0xf0106e81
f01023d6:	e8 65 dc ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01023db:	68 c0 68 10 f0       	push   $0xf01068c0
f01023e0:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01023e5:	68 b1 03 00 00       	push   $0x3b1
f01023ea:	68 81 6e 10 f0       	push   $0xf0106e81
f01023ef:	e8 4c dc ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01023f4:	68 c7 70 10 f0       	push   $0xf01070c7
f01023f9:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01023fe:	68 b2 03 00 00       	push   $0x3b2
f0102403:	68 81 6e 10 f0       	push   $0xf0106e81
f0102408:	e8 33 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010240d:	68 d4 67 10 f0       	push   $0xf01067d4
f0102412:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102417:	68 b5 03 00 00       	push   $0x3b5
f010241c:	68 81 6e 10 f0       	push   $0xf0106e81
f0102421:	e8 1a dc ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102426:	68 f4 68 10 f0       	push   $0xf01068f4
f010242b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102430:	68 b6 03 00 00       	push   $0x3b6
f0102435:	68 81 6e 10 f0       	push   $0xf0106e81
f010243a:	e8 01 dc ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010243f:	68 28 69 10 f0       	push   $0xf0106928
f0102444:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102449:	68 b7 03 00 00       	push   $0x3b7
f010244e:	68 81 6e 10 f0       	push   $0xf0106e81
f0102453:	e8 e8 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102458:	68 60 69 10 f0       	push   $0xf0106960
f010245d:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102462:	68 ba 03 00 00       	push   $0x3ba
f0102467:	68 81 6e 10 f0       	push   $0xf0106e81
f010246c:	e8 cf db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102471:	68 98 69 10 f0       	push   $0xf0106998
f0102476:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010247b:	68 bd 03 00 00       	push   $0x3bd
f0102480:	68 81 6e 10 f0       	push   $0xf0106e81
f0102485:	e8 b6 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010248a:	68 28 69 10 f0       	push   $0xf0106928
f010248f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102494:	68 be 03 00 00       	push   $0x3be
f0102499:	68 81 6e 10 f0       	push   $0xf0106e81
f010249e:	e8 9d db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01024a3:	68 d4 69 10 f0       	push   $0xf01069d4
f01024a8:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01024ad:	68 c1 03 00 00       	push   $0x3c1
f01024b2:	68 81 6e 10 f0       	push   $0xf0106e81
f01024b7:	e8 84 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01024bc:	68 00 6a 10 f0       	push   $0xf0106a00
f01024c1:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01024c6:	68 c2 03 00 00       	push   $0x3c2
f01024cb:	68 81 6e 10 f0       	push   $0xf0106e81
f01024d0:	e8 6b db ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f01024d5:	68 dd 70 10 f0       	push   $0xf01070dd
f01024da:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01024df:	68 c4 03 00 00       	push   $0x3c4
f01024e4:	68 81 6e 10 f0       	push   $0xf0106e81
f01024e9:	e8 52 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01024ee:	68 ee 70 10 f0       	push   $0xf01070ee
f01024f3:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01024f8:	68 c5 03 00 00       	push   $0x3c5
f01024fd:	68 81 6e 10 f0       	push   $0xf0106e81
f0102502:	e8 39 db ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102507:	68 30 6a 10 f0       	push   $0xf0106a30
f010250c:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102511:	68 c8 03 00 00       	push   $0x3c8
f0102516:	68 81 6e 10 f0       	push   $0xf0106e81
f010251b:	e8 20 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102520:	68 54 6a 10 f0       	push   $0xf0106a54
f0102525:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010252a:	68 cc 03 00 00       	push   $0x3cc
f010252f:	68 81 6e 10 f0       	push   $0xf0106e81
f0102534:	e8 07 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102539:	68 00 6a 10 f0       	push   $0xf0106a00
f010253e:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102543:	68 cd 03 00 00       	push   $0x3cd
f0102548:	68 81 6e 10 f0       	push   $0xf0106e81
f010254d:	e8 ee da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102552:	68 94 70 10 f0       	push   $0xf0107094
f0102557:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010255c:	68 ce 03 00 00       	push   $0x3ce
f0102561:	68 81 6e 10 f0       	push   $0xf0106e81
f0102566:	e8 d5 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010256b:	68 ee 70 10 f0       	push   $0xf01070ee
f0102570:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102575:	68 cf 03 00 00       	push   $0x3cf
f010257a:	68 81 6e 10 f0       	push   $0xf0106e81
f010257f:	e8 bc da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102584:	68 78 6a 10 f0       	push   $0xf0106a78
f0102589:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010258e:	68 d2 03 00 00       	push   $0x3d2
f0102593:	68 81 6e 10 f0       	push   $0xf0106e81
f0102598:	e8 a3 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f010259d:	68 ff 70 10 f0       	push   $0xf01070ff
f01025a2:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01025a7:	68 d3 03 00 00       	push   $0x3d3
f01025ac:	68 81 6e 10 f0       	push   $0xf0106e81
f01025b1:	e8 8a da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f01025b6:	68 0b 71 10 f0       	push   $0xf010710b
f01025bb:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01025c0:	68 d4 03 00 00       	push   $0x3d4
f01025c5:	68 81 6e 10 f0       	push   $0xf0106e81
f01025ca:	e8 71 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01025cf:	68 54 6a 10 f0       	push   $0xf0106a54
f01025d4:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01025d9:	68 d8 03 00 00       	push   $0x3d8
f01025de:	68 81 6e 10 f0       	push   $0xf0106e81
f01025e3:	e8 58 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01025e8:	68 b0 6a 10 f0       	push   $0xf0106ab0
f01025ed:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01025f2:	68 d9 03 00 00       	push   $0x3d9
f01025f7:	68 81 6e 10 f0       	push   $0xf0106e81
f01025fc:	e8 3f da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102601:	68 20 71 10 f0       	push   $0xf0107120
f0102606:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010260b:	68 da 03 00 00       	push   $0x3da
f0102610:	68 81 6e 10 f0       	push   $0xf0106e81
f0102615:	e8 26 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010261a:	68 ee 70 10 f0       	push   $0xf01070ee
f010261f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102624:	68 db 03 00 00       	push   $0x3db
f0102629:	68 81 6e 10 f0       	push   $0xf0106e81
f010262e:	e8 0d da ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102633:	68 d8 6a 10 f0       	push   $0xf0106ad8
f0102638:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010263d:	68 de 03 00 00       	push   $0x3de
f0102642:	68 81 6e 10 f0       	push   $0xf0106e81
f0102647:	e8 f4 d9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010264c:	68 42 70 10 f0       	push   $0xf0107042
f0102651:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102656:	68 e1 03 00 00       	push   $0x3e1
f010265b:	68 81 6e 10 f0       	push   $0xf0106e81
f0102660:	e8 db d9 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102665:	68 7c 67 10 f0       	push   $0xf010677c
f010266a:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010266f:	68 e4 03 00 00       	push   $0x3e4
f0102674:	68 81 6e 10 f0       	push   $0xf0106e81
f0102679:	e8 c2 d9 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010267e:	68 a5 70 10 f0       	push   $0xf01070a5
f0102683:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102688:	68 e6 03 00 00       	push   $0x3e6
f010268d:	68 81 6e 10 f0       	push   $0xf0106e81
f0102692:	e8 a9 d9 ff ff       	call   f0100040 <_panic>
f0102697:	57                   	push   %edi
f0102698:	68 04 60 10 f0       	push   $0xf0106004
f010269d:	68 ed 03 00 00       	push   $0x3ed
f01026a2:	68 81 6e 10 f0       	push   $0xf0106e81
f01026a7:	e8 94 d9 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f01026ac:	68 31 71 10 f0       	push   $0xf0107131
f01026b1:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01026b6:	68 ee 03 00 00       	push   $0x3ee
f01026bb:	68 81 6e 10 f0       	push   $0xf0106e81
f01026c0:	e8 7b d9 ff ff       	call   f0100040 <_panic>
f01026c5:	51                   	push   %ecx
f01026c6:	68 04 60 10 f0       	push   $0xf0106004
f01026cb:	6a 58                	push   $0x58
f01026cd:	68 8d 6e 10 f0       	push   $0xf0106e8d
f01026d2:	e8 69 d9 ff ff       	call   f0100040 <_panic>
f01026d7:	52                   	push   %edx
f01026d8:	68 04 60 10 f0       	push   $0xf0106004
f01026dd:	6a 58                	push   $0x58
f01026df:	68 8d 6e 10 f0       	push   $0xf0106e8d
f01026e4:	e8 57 d9 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01026e9:	68 49 71 10 f0       	push   $0xf0107149
f01026ee:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01026f3:	68 f8 03 00 00       	push   $0x3f8
f01026f8:	68 81 6e 10 f0       	push   $0xf0106e81
f01026fd:	e8 3e d9 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102702:	68 fc 6a 10 f0       	push   $0xf0106afc
f0102707:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010270c:	68 08 04 00 00       	push   $0x408
f0102711:	68 81 6e 10 f0       	push   $0xf0106e81
f0102716:	e8 25 d9 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010271b:	68 24 6b 10 f0       	push   $0xf0106b24
f0102720:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102725:	68 09 04 00 00       	push   $0x409
f010272a:	68 81 6e 10 f0       	push   $0xf0106e81
f010272f:	e8 0c d9 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102734:	68 4c 6b 10 f0       	push   $0xf0106b4c
f0102739:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010273e:	68 0b 04 00 00       	push   $0x40b
f0102743:	68 81 6e 10 f0       	push   $0xf0106e81
f0102748:	e8 f3 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f010274d:	68 60 71 10 f0       	push   $0xf0107160
f0102752:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102757:	68 0d 04 00 00       	push   $0x40d
f010275c:	68 81 6e 10 f0       	push   $0xf0106e81
f0102761:	e8 da d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102766:	68 74 6b 10 f0       	push   $0xf0106b74
f010276b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102770:	68 0f 04 00 00       	push   $0x40f
f0102775:	68 81 6e 10 f0       	push   $0xf0106e81
f010277a:	e8 c1 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010277f:	68 98 6b 10 f0       	push   $0xf0106b98
f0102784:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102789:	68 10 04 00 00       	push   $0x410
f010278e:	68 81 6e 10 f0       	push   $0xf0106e81
f0102793:	e8 a8 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102798:	68 c8 6b 10 f0       	push   $0xf0106bc8
f010279d:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01027a2:	68 11 04 00 00       	push   $0x411
f01027a7:	68 81 6e 10 f0       	push   $0xf0106e81
f01027ac:	e8 8f d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01027b1:	68 ec 6b 10 f0       	push   $0xf0106bec
f01027b6:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01027bb:	68 12 04 00 00       	push   $0x412
f01027c0:	68 81 6e 10 f0       	push   $0xf0106e81
f01027c5:	e8 76 d8 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01027ca:	68 18 6c 10 f0       	push   $0xf0106c18
f01027cf:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01027d4:	68 14 04 00 00       	push   $0x414
f01027d9:	68 81 6e 10 f0       	push   $0xf0106e81
f01027de:	e8 5d d8 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01027e3:	68 5c 6c 10 f0       	push   $0xf0106c5c
f01027e8:	68 a7 6e 10 f0       	push   $0xf0106ea7
f01027ed:	68 15 04 00 00       	push   $0x415
f01027f2:	68 81 6e 10 f0       	push   $0xf0106e81
f01027f7:	e8 44 d8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01027fc:	50                   	push   %eax
f01027fd:	68 28 60 10 f0       	push   $0xf0106028
f0102802:	68 bc 00 00 00       	push   $0xbc
f0102807:	68 81 6e 10 f0       	push   $0xf0106e81
f010280c:	e8 2f d8 ff ff       	call   f0100040 <_panic>
f0102811:	50                   	push   %eax
f0102812:	68 28 60 10 f0       	push   $0xf0106028
f0102817:	68 c4 00 00 00       	push   $0xc4
f010281c:	68 81 6e 10 f0       	push   $0xf0106e81
f0102821:	e8 1a d8 ff ff       	call   f0100040 <_panic>
f0102826:	50                   	push   %eax
f0102827:	68 28 60 10 f0       	push   $0xf0106028
f010282c:	68 d0 00 00 00       	push   $0xd0
f0102831:	68 81 6e 10 f0       	push   $0xf0106e81
f0102836:	e8 05 d8 ff ff       	call   f0100040 <_panic>
f010283b:	53                   	push   %ebx
f010283c:	68 28 60 10 f0       	push   $0xf0106028
f0102841:	68 0f 01 00 00       	push   $0x10f
f0102846:	68 81 6e 10 f0       	push   $0xf0106e81
f010284b:	e8 f0 d7 ff ff       	call   f0100040 <_panic>
f0102850:	56                   	push   %esi
f0102851:	68 28 60 10 f0       	push   $0xf0106028
f0102856:	68 2d 03 00 00       	push   $0x32d
f010285b:	68 81 6e 10 f0       	push   $0xf0106e81
f0102860:	e8 db d7 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102865:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010286b:	39 df                	cmp    %ebx,%edi
f010286d:	76 39                	jbe    f01028a8 <mem_init+0x1611>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010286f:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102878:	e8 14 e2 ff ff       	call   f0100a91 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010287d:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f0102883:	76 cb                	jbe    f0102850 <mem_init+0x15b9>
f0102885:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102888:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f010288b:	39 d0                	cmp    %edx,%eax
f010288d:	74 d6                	je     f0102865 <mem_init+0x15ce>
f010288f:	68 90 6c 10 f0       	push   $0xf0106c90
f0102894:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102899:	68 2d 03 00 00       	push   $0x32d
f010289e:	68 81 6e 10 f0       	push   $0xf0106e81
f01028a3:	e8 98 d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01028a8:	8b 35 74 b2 1e f0    	mov    0xf01eb274,%esi
f01028ae:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f01028b3:	8d 86 00 00 40 21    	lea    0x21400000(%esi),%eax
f01028b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01028bc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01028bf:	89 da                	mov    %ebx,%edx
f01028c1:	89 f8                	mov    %edi,%eax
f01028c3:	e8 c9 e1 ff ff       	call   f0100a91 <check_va2pa>
f01028c8:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f01028ce:	76 46                	jbe    f0102916 <mem_init+0x167f>
f01028d0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01028d3:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f01028d6:	39 d0                	cmp    %edx,%eax
f01028d8:	75 51                	jne    f010292b <mem_init+0x1694>
	for (i = 0; i < n; i += PGSIZE)
f01028da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01028e0:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f01028e6:	75 d7                	jne    f01028bf <mem_init+0x1628>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01028e8:	8b 7d c8             	mov    -0x38(%ebp),%edi
f01028eb:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f01028ee:	c1 e6 0c             	shl    $0xc,%esi
f01028f1:	89 fb                	mov    %edi,%ebx
f01028f3:	89 7d cc             	mov    %edi,-0x34(%ebp)
f01028f6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01028f9:	39 f3                	cmp    %esi,%ebx
f01028fb:	73 60                	jae    f010295d <mem_init+0x16c6>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01028fd:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102903:	89 f8                	mov    %edi,%eax
f0102905:	e8 87 e1 ff ff       	call   f0100a91 <check_va2pa>
f010290a:	39 c3                	cmp    %eax,%ebx
f010290c:	75 36                	jne    f0102944 <mem_init+0x16ad>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010290e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102914:	eb e3                	jmp    f01028f9 <mem_init+0x1662>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102916:	56                   	push   %esi
f0102917:	68 28 60 10 f0       	push   $0xf0106028
f010291c:	68 32 03 00 00       	push   $0x332
f0102921:	68 81 6e 10 f0       	push   $0xf0106e81
f0102926:	e8 15 d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010292b:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0102930:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102935:	68 32 03 00 00       	push   $0x332
f010293a:	68 81 6e 10 f0       	push   $0xf0106e81
f010293f:	e8 fc d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102944:	68 f8 6c 10 f0       	push   $0xf0106cf8
f0102949:	68 a7 6e 10 f0       	push   $0xf0106ea7
f010294e:	68 36 03 00 00       	push   $0x336
f0102953:	68 81 6e 10 f0       	push   $0xf0106e81
f0102958:	e8 e3 d6 ff ff       	call   f0100040 <_panic>
f010295d:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0102960:	c7 45 c0 00 c0 1f 00 	movl   $0x1fc000,-0x40(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102967:	c7 45 c4 00 00 00 f0 	movl   $0xf0000000,-0x3c(%ebp)
f010296e:	c7 45 c8 00 80 ff ef 	movl   $0xefff8000,-0x38(%ebp)
f0102975:	89 7d b4             	mov    %edi,-0x4c(%ebp)
f0102978:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010297b:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f010297e:	8d b3 00 80 ff ff    	lea    -0x8000(%ebx),%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102984:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102987:	89 45 b8             	mov    %eax,-0x48(%ebp)
f010298a:	8b 45 c0             	mov    -0x40(%ebp),%eax
f010298d:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102992:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102995:	89 75 bc             	mov    %esi,-0x44(%ebp)
f0102998:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f010299b:	89 da                	mov    %ebx,%edx
f010299d:	89 f8                	mov    %edi,%eax
f010299f:	e8 ed e0 ff ff       	call   f0100a91 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01029a4:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01029ab:	76 67                	jbe    f0102a14 <mem_init+0x177d>
f01029ad:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01029b0:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f01029b3:	39 d0                	cmp    %edx,%eax
f01029b5:	75 74                	jne    f0102a2b <mem_init+0x1794>
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01029b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029bd:	39 f3                	cmp    %esi,%ebx
f01029bf:	75 da                	jne    f010299b <mem_init+0x1704>
f01029c1:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01029c4:	8b 5d c8             	mov    -0x38(%ebp),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f01029c7:	89 f2                	mov    %esi,%edx
f01029c9:	89 f8                	mov    %edi,%eax
f01029cb:	e8 c1 e0 ff ff       	call   f0100a91 <check_va2pa>
f01029d0:	83 f8 ff             	cmp    $0xffffffff,%eax
f01029d3:	75 6f                	jne    f0102a44 <mem_init+0x17ad>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f01029d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01029db:	39 de                	cmp    %ebx,%esi
f01029dd:	75 e8                	jne    f01029c7 <mem_init+0x1730>
	for (n = 0; n < NCPU; n++) {
f01029df:	89 d8                	mov    %ebx,%eax
f01029e1:	2d 00 00 01 00       	sub    $0x10000,%eax
f01029e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01029e9:	81 6d c4 00 00 01 00 	subl   $0x10000,-0x3c(%ebp)
f01029f0:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f01029f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01029fa:	81 45 c0 00 80 01 00 	addl   $0x18000,-0x40(%ebp)
f0102a01:	3d 00 c0 22 f0       	cmp    $0xf022c000,%eax
f0102a06:	0f 85 6f ff ff ff    	jne    f010297b <mem_init+0x16e4>
f0102a0c:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0102a0f:	e9 84 00 00 00       	jmp    f0102a98 <mem_init+0x1801>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a14:	ff 75 b8             	push   -0x48(%ebp)
f0102a17:	68 28 60 10 f0       	push   $0xf0106028
f0102a1c:	68 3e 03 00 00       	push   $0x33e
f0102a21:	68 81 6e 10 f0       	push   $0xf0106e81
f0102a26:	e8 15 d6 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102a2b:	68 20 6d 10 f0       	push   $0xf0106d20
f0102a30:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102a35:	68 3d 03 00 00       	push   $0x33d
f0102a3a:	68 81 6e 10 f0       	push   $0xf0106e81
f0102a3f:	e8 fc d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102a44:	68 68 6d 10 f0       	push   $0xf0106d68
f0102a49:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102a4e:	68 40 03 00 00       	push   $0x340
f0102a53:	68 81 6e 10 f0       	push   $0xf0106e81
f0102a58:	e8 e3 d5 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102a5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a60:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102a64:	75 4e                	jne    f0102ab4 <mem_init+0x181d>
f0102a66:	68 8b 71 10 f0       	push   $0xf010718b
f0102a6b:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102a70:	68 4b 03 00 00       	push   $0x34b
f0102a75:	68 81 6e 10 f0       	push   $0xf0106e81
f0102a7a:	e8 c1 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102a7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a82:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102a85:	a8 01                	test   $0x1,%al
f0102a87:	74 30                	je     f0102ab9 <mem_init+0x1822>
				assert(pgdir[i] & PTE_W);
f0102a89:	a8 02                	test   $0x2,%al
f0102a8b:	74 45                	je     f0102ad2 <mem_init+0x183b>
	for (i = 0; i < NPDENTRIES; i++) {
f0102a8d:	83 c7 01             	add    $0x1,%edi
f0102a90:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102a96:	74 6c                	je     f0102b04 <mem_init+0x186d>
		switch (i) {
f0102a98:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102a9e:	83 f8 04             	cmp    $0x4,%eax
f0102aa1:	76 ba                	jbe    f0102a5d <mem_init+0x17c6>
			if (i >= PDX(KERNBASE)) {
f0102aa3:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102aa9:	77 d4                	ja     f0102a7f <mem_init+0x17e8>
				assert(pgdir[i] == 0);
f0102aab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102aae:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102ab2:	75 37                	jne    f0102aeb <mem_init+0x1854>
	for (i = 0; i < NPDENTRIES; i++) {
f0102ab4:	83 c7 01             	add    $0x1,%edi
f0102ab7:	eb df                	jmp    f0102a98 <mem_init+0x1801>
				assert(pgdir[i] & PTE_P);
f0102ab9:	68 8b 71 10 f0       	push   $0xf010718b
f0102abe:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102ac3:	68 4f 03 00 00       	push   $0x34f
f0102ac8:	68 81 6e 10 f0       	push   $0xf0106e81
f0102acd:	e8 6e d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102ad2:	68 9c 71 10 f0       	push   $0xf010719c
f0102ad7:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102adc:	68 50 03 00 00       	push   $0x350
f0102ae1:	68 81 6e 10 f0       	push   $0xf0106e81
f0102ae6:	e8 55 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102aeb:	68 ad 71 10 f0       	push   $0xf01071ad
f0102af0:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102af5:	68 52 03 00 00       	push   $0x352
f0102afa:	68 81 6e 10 f0       	push   $0xf0106e81
f0102aff:	e8 3c d5 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b04:	83 ec 0c             	sub    $0xc,%esp
f0102b07:	68 8c 6d 10 f0       	push   $0xf0106d8c
f0102b0c:	e8 fc 0c 00 00       	call   f010380d <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102b11:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102b16:	83 c4 10             	add    $0x10,%esp
f0102b19:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102b1e:	0f 86 03 02 00 00    	jbe    f0102d27 <mem_init+0x1a90>
	return (physaddr_t)kva - KERNBASE;
f0102b24:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102b29:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102b2c:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b31:	e8 be df ff ff       	call   f0100af4 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102b36:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102b39:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b3c:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102b41:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102b44:	83 ec 0c             	sub    $0xc,%esp
f0102b47:	6a 00                	push   $0x0
f0102b49:	e8 5c e3 ff ff       	call   f0100eaa <page_alloc>
f0102b4e:	89 c3                	mov    %eax,%ebx
f0102b50:	83 c4 10             	add    $0x10,%esp
f0102b53:	85 c0                	test   %eax,%eax
f0102b55:	0f 84 e1 01 00 00    	je     f0102d3c <mem_init+0x1aa5>
	assert((pp1 = page_alloc(0)));
f0102b5b:	83 ec 0c             	sub    $0xc,%esp
f0102b5e:	6a 00                	push   $0x0
f0102b60:	e8 45 e3 ff ff       	call   f0100eaa <page_alloc>
f0102b65:	89 c7                	mov    %eax,%edi
f0102b67:	83 c4 10             	add    $0x10,%esp
f0102b6a:	85 c0                	test   %eax,%eax
f0102b6c:	0f 84 e3 01 00 00    	je     f0102d55 <mem_init+0x1abe>
	assert((pp2 = page_alloc(0)));
f0102b72:	83 ec 0c             	sub    $0xc,%esp
f0102b75:	6a 00                	push   $0x0
f0102b77:	e8 2e e3 ff ff       	call   f0100eaa <page_alloc>
f0102b7c:	89 c6                	mov    %eax,%esi
f0102b7e:	83 c4 10             	add    $0x10,%esp
f0102b81:	85 c0                	test   %eax,%eax
f0102b83:	0f 84 e5 01 00 00    	je     f0102d6e <mem_init+0x1ad7>
	page_free(pp0);
f0102b89:	83 ec 0c             	sub    $0xc,%esp
f0102b8c:	53                   	push   %ebx
f0102b8d:	e8 8d e3 ff ff       	call   f0100f1f <page_free>
	return (pp - pages) << PGSHIFT;
f0102b92:	89 f8                	mov    %edi,%eax
f0102b94:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0102b9a:	c1 f8 03             	sar    $0x3,%eax
f0102b9d:	89 c2                	mov    %eax,%edx
f0102b9f:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102ba2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102ba7:	83 c4 10             	add    $0x10,%esp
f0102baa:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0102bb0:	0f 83 d1 01 00 00    	jae    f0102d87 <mem_init+0x1af0>
	memset(page2kva(pp1), 1, PGSIZE);
f0102bb6:	83 ec 04             	sub    $0x4,%esp
f0102bb9:	68 00 10 00 00       	push   $0x1000
f0102bbe:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102bc0:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102bc6:	52                   	push   %edx
f0102bc7:	e8 e8 27 00 00       	call   f01053b4 <memset>
	return (pp - pages) << PGSHIFT;
f0102bcc:	89 f0                	mov    %esi,%eax
f0102bce:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0102bd4:	c1 f8 03             	sar    $0x3,%eax
f0102bd7:	89 c2                	mov    %eax,%edx
f0102bd9:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102bdc:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102be1:	83 c4 10             	add    $0x10,%esp
f0102be4:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0102bea:	0f 83 a9 01 00 00    	jae    f0102d99 <mem_init+0x1b02>
	memset(page2kva(pp2), 2, PGSIZE);
f0102bf0:	83 ec 04             	sub    $0x4,%esp
f0102bf3:	68 00 10 00 00       	push   $0x1000
f0102bf8:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102bfa:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102c00:	52                   	push   %edx
f0102c01:	e8 ae 27 00 00       	call   f01053b4 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102c06:	6a 02                	push   $0x2
f0102c08:	68 00 10 00 00       	push   $0x1000
f0102c0d:	57                   	push   %edi
f0102c0e:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0102c14:	e8 92 e5 ff ff       	call   f01011ab <page_insert>
	assert(pp1->pp_ref == 1);
f0102c19:	83 c4 20             	add    $0x20,%esp
f0102c1c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102c21:	0f 85 84 01 00 00    	jne    f0102dab <mem_init+0x1b14>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102c27:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102c2e:	01 01 01 
f0102c31:	0f 85 8d 01 00 00    	jne    f0102dc4 <mem_init+0x1b2d>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102c37:	6a 02                	push   $0x2
f0102c39:	68 00 10 00 00       	push   $0x1000
f0102c3e:	56                   	push   %esi
f0102c3f:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0102c45:	e8 61 e5 ff ff       	call   f01011ab <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102c4a:	83 c4 10             	add    $0x10,%esp
f0102c4d:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102c54:	02 02 02 
f0102c57:	0f 85 80 01 00 00    	jne    f0102ddd <mem_init+0x1b46>
	assert(pp2->pp_ref == 1);
f0102c5d:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102c62:	0f 85 8e 01 00 00    	jne    f0102df6 <mem_init+0x1b5f>
	assert(pp1->pp_ref == 0);
f0102c68:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102c6d:	0f 85 9c 01 00 00    	jne    f0102e0f <mem_init+0x1b78>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102c73:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102c7a:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102c7d:	89 f0                	mov    %esi,%eax
f0102c7f:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0102c85:	c1 f8 03             	sar    $0x3,%eax
f0102c88:	89 c2                	mov    %eax,%edx
f0102c8a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c8d:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c92:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0102c98:	0f 83 8a 01 00 00    	jae    f0102e28 <mem_init+0x1b91>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102c9e:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102ca5:	03 03 03 
f0102ca8:	0f 85 8c 01 00 00    	jne    f0102e3a <mem_init+0x1ba3>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102cae:	83 ec 08             	sub    $0x8,%esp
f0102cb1:	68 00 10 00 00       	push   $0x1000
f0102cb6:	ff 35 5c b2 1e f0    	push   0xf01eb25c
f0102cbc:	e8 87 e4 ff ff       	call   f0101148 <page_remove>
	assert(pp2->pp_ref == 0);
f0102cc1:	83 c4 10             	add    $0x10,%esp
f0102cc4:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102cc9:	0f 85 84 01 00 00    	jne    f0102e53 <mem_init+0x1bbc>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ccf:	8b 0d 5c b2 1e f0    	mov    0xf01eb25c,%ecx
f0102cd5:	8b 11                	mov    (%ecx),%edx
f0102cd7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102cdd:	89 d8                	mov    %ebx,%eax
f0102cdf:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f0102ce5:	c1 f8 03             	sar    $0x3,%eax
f0102ce8:	c1 e0 0c             	shl    $0xc,%eax
f0102ceb:	39 c2                	cmp    %eax,%edx
f0102ced:	0f 85 79 01 00 00    	jne    f0102e6c <mem_init+0x1bd5>
	kern_pgdir[0] = 0;
f0102cf3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102cf9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102cfe:	0f 85 81 01 00 00    	jne    f0102e85 <mem_init+0x1bee>
	pp0->pp_ref = 0;
f0102d04:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0102d0a:	83 ec 0c             	sub    $0xc,%esp
f0102d0d:	53                   	push   %ebx
f0102d0e:	e8 0c e2 ff ff       	call   f0100f1f <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102d13:	c7 04 24 20 6e 10 f0 	movl   $0xf0106e20,(%esp)
f0102d1a:	e8 ee 0a 00 00       	call   f010380d <cprintf>
}
f0102d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d22:	5b                   	pop    %ebx
f0102d23:	5e                   	pop    %esi
f0102d24:	5f                   	pop    %edi
f0102d25:	5d                   	pop    %ebp
f0102d26:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d27:	50                   	push   %eax
f0102d28:	68 28 60 10 f0       	push   $0xf0106028
f0102d2d:	68 e8 00 00 00       	push   $0xe8
f0102d32:	68 81 6e 10 f0       	push   $0xf0106e81
f0102d37:	e8 04 d3 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102d3c:	68 97 6f 10 f0       	push   $0xf0106f97
f0102d41:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102d46:	68 2a 04 00 00       	push   $0x42a
f0102d4b:	68 81 6e 10 f0       	push   $0xf0106e81
f0102d50:	e8 eb d2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102d55:	68 ad 6f 10 f0       	push   $0xf0106fad
f0102d5a:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102d5f:	68 2b 04 00 00       	push   $0x42b
f0102d64:	68 81 6e 10 f0       	push   $0xf0106e81
f0102d69:	e8 d2 d2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102d6e:	68 c3 6f 10 f0       	push   $0xf0106fc3
f0102d73:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102d78:	68 2c 04 00 00       	push   $0x42c
f0102d7d:	68 81 6e 10 f0       	push   $0xf0106e81
f0102d82:	e8 b9 d2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102d87:	52                   	push   %edx
f0102d88:	68 04 60 10 f0       	push   $0xf0106004
f0102d8d:	6a 58                	push   $0x58
f0102d8f:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0102d94:	e8 a7 d2 ff ff       	call   f0100040 <_panic>
f0102d99:	52                   	push   %edx
f0102d9a:	68 04 60 10 f0       	push   $0xf0106004
f0102d9f:	6a 58                	push   $0x58
f0102da1:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0102da6:	e8 95 d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102dab:	68 94 70 10 f0       	push   $0xf0107094
f0102db0:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102db5:	68 31 04 00 00       	push   $0x431
f0102dba:	68 81 6e 10 f0       	push   $0xf0106e81
f0102dbf:	e8 7c d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102dc4:	68 ac 6d 10 f0       	push   $0xf0106dac
f0102dc9:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102dce:	68 32 04 00 00       	push   $0x432
f0102dd3:	68 81 6e 10 f0       	push   $0xf0106e81
f0102dd8:	e8 63 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102ddd:	68 d0 6d 10 f0       	push   $0xf0106dd0
f0102de2:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102de7:	68 34 04 00 00       	push   $0x434
f0102dec:	68 81 6e 10 f0       	push   $0xf0106e81
f0102df1:	e8 4a d2 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102df6:	68 b6 70 10 f0       	push   $0xf01070b6
f0102dfb:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e00:	68 35 04 00 00       	push   $0x435
f0102e05:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e0a:	e8 31 d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102e0f:	68 20 71 10 f0       	push   $0xf0107120
f0102e14:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e19:	68 36 04 00 00       	push   $0x436
f0102e1e:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e23:	e8 18 d2 ff ff       	call   f0100040 <_panic>
f0102e28:	52                   	push   %edx
f0102e29:	68 04 60 10 f0       	push   $0xf0106004
f0102e2e:	6a 58                	push   $0x58
f0102e30:	68 8d 6e 10 f0       	push   $0xf0106e8d
f0102e35:	e8 06 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e3a:	68 f4 6d 10 f0       	push   $0xf0106df4
f0102e3f:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e44:	68 38 04 00 00       	push   $0x438
f0102e49:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e4e:	e8 ed d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102e53:	68 ee 70 10 f0       	push   $0xf01070ee
f0102e58:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e5d:	68 3a 04 00 00       	push   $0x43a
f0102e62:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e67:	e8 d4 d1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e6c:	68 7c 67 10 f0       	push   $0xf010677c
f0102e71:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e76:	68 3d 04 00 00       	push   $0x43d
f0102e7b:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e80:	e8 bb d1 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102e85:	68 a5 70 10 f0       	push   $0xf01070a5
f0102e8a:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0102e8f:	68 3f 04 00 00       	push   $0x43f
f0102e94:	68 81 6e 10 f0       	push   $0xf0106e81
f0102e99:	e8 a2 d1 ff ff       	call   f0100040 <_panic>

f0102e9e <user_mem_check>:
{
f0102e9e:	55                   	push   %ebp
f0102e9f:	89 e5                	mov    %esp,%ebp
f0102ea1:	57                   	push   %edi
f0102ea2:	56                   	push   %esi
f0102ea3:	53                   	push   %ebx
f0102ea4:	83 ec 0c             	sub    $0xc,%esp
	uint32_t end = ((uint32_t)va+len) / PGSIZE;
f0102ea7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0102eaa:	03 7d 10             	add    0x10(%ebp),%edi
f0102ead:	c1 ef 0c             	shr    $0xc,%edi
	uint32_t start = ((uint32_t)va) / PGSIZE;
f0102eb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102eb3:	c1 eb 0c             	shr    $0xc,%ebx
	for (int i = start; i <= end; i++) {
f0102eb6:	39 df                	cmp    %ebx,%edi
f0102eb8:	72 53                	jb     f0102f0d <user_mem_check+0x6f>
f0102eba:	89 de                	mov    %ebx,%esi
f0102ebc:	c1 e6 0c             	shl    $0xc,%esi
		pte_t *pte = pgdir_walk(env->env_pgdir, (void *)(i * PGSIZE), 0);
f0102ebf:	83 ec 04             	sub    $0x4,%esp
f0102ec2:	6a 00                	push   $0x0
f0102ec4:	56                   	push   %esi
f0102ec5:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ec8:	ff 70 60             	push   0x60(%eax)
f0102ecb:	e8 ae e0 ff ff       	call   f0100f7e <pgdir_walk>
		if (((i * PGSIZE) < ULIM) && (pte != NULL) && ((*pte | (PTE_P | perm)) == *pte)) continue;
f0102ed0:	83 c4 10             	add    $0x10,%esp
f0102ed3:	85 c0                	test   %eax,%eax
f0102ed5:	74 1b                	je     f0102ef2 <user_mem_check+0x54>
f0102ed7:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102edd:	77 13                	ja     f0102ef2 <user_mem_check+0x54>
f0102edf:	8b 10                	mov    (%eax),%edx
f0102ee1:	89 d0                	mov    %edx,%eax
f0102ee3:	0b 45 14             	or     0x14(%ebp),%eax
f0102ee6:	83 c8 01             	or     $0x1,%eax
f0102ee9:	39 c2                	cmp    %eax,%edx
f0102eeb:	75 05                	jne    f0102ef2 <user_mem_check+0x54>
	for (int i = start; i <= end; i++) {
f0102eed:	83 c3 01             	add    $0x1,%ebx
f0102ef0:	eb c4                	jmp    f0102eb6 <user_mem_check+0x18>
		user_mem_check_addr = PGSIZE * i < (uint32_t)va ? (uint32_t)va : PGSIZE * i;
f0102ef2:	39 75 0c             	cmp    %esi,0xc(%ebp)
f0102ef5:	89 f0                	mov    %esi,%eax
f0102ef7:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0102efb:	a3 68 b2 1e f0       	mov    %eax,0xf01eb268
		return -E_FAULT;
f0102f00:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f08:	5b                   	pop    %ebx
f0102f09:	5e                   	pop    %esi
f0102f0a:	5f                   	pop    %edi
f0102f0b:	5d                   	pop    %ebp
f0102f0c:	c3                   	ret    
	return 0;
f0102f0d:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f12:	eb f1                	jmp    f0102f05 <user_mem_check+0x67>

f0102f14 <user_mem_assert>:
{
f0102f14:	55                   	push   %ebp
f0102f15:	89 e5                	mov    %esp,%ebp
f0102f17:	53                   	push   %ebx
f0102f18:	83 ec 04             	sub    $0x4,%esp
f0102f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102f1e:	8b 45 14             	mov    0x14(%ebp),%eax
f0102f21:	83 c8 04             	or     $0x4,%eax
f0102f24:	50                   	push   %eax
f0102f25:	ff 75 10             	push   0x10(%ebp)
f0102f28:	ff 75 0c             	push   0xc(%ebp)
f0102f2b:	53                   	push   %ebx
f0102f2c:	e8 6d ff ff ff       	call   f0102e9e <user_mem_check>
f0102f31:	83 c4 10             	add    $0x10,%esp
f0102f34:	85 c0                	test   %eax,%eax
f0102f36:	78 05                	js     f0102f3d <user_mem_assert+0x29>
}
f0102f38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102f3b:	c9                   	leave  
f0102f3c:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102f3d:	83 ec 04             	sub    $0x4,%esp
f0102f40:	ff 35 68 b2 1e f0    	push   0xf01eb268
f0102f46:	ff 73 48             	push   0x48(%ebx)
f0102f49:	68 4c 6e 10 f0       	push   $0xf0106e4c
f0102f4e:	e8 ba 08 00 00       	call   f010380d <cprintf>
		env_destroy(env);	// may not return
f0102f53:	89 1c 24             	mov    %ebx,(%esp)
f0102f56:	e8 d6 05 00 00       	call   f0103531 <env_destroy>
f0102f5b:	83 c4 10             	add    $0x10,%esp
}
f0102f5e:	eb d8                	jmp    f0102f38 <user_mem_assert+0x24>

f0102f60 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102f60:	55                   	push   %ebp
f0102f61:	89 e5                	mov    %esp,%ebp
f0102f63:	57                   	push   %edi
f0102f64:	56                   	push   %esi
f0102f65:	53                   	push   %ebx
f0102f66:	83 ec 0c             	sub    $0xc,%esp
f0102f69:	89 c7                	mov    %eax,%edi
f0102f6b:	89 d3                	mov    %edx,%ebx
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	uint32_t vstart = ROUNDDOWN((uint32_t)va, PGSIZE);
	uint32_t vend = ROUNDUP((uint32_t)va+len, PGSIZE);
f0102f6d:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0102f74:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	uint32_t vstart = ROUNDDOWN((uint32_t)va, PGSIZE);
f0102f7a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (int i = vstart; i < vend; i += PGSIZE) {
f0102f80:	39 f3                	cmp    %esi,%ebx
f0102f82:	73 43                	jae    f0102fc7 <region_alloc+0x67>
		struct PageInfo *pg = page_alloc(ALLOC_ZERO);
f0102f84:	83 ec 0c             	sub    $0xc,%esp
f0102f87:	6a 01                	push   $0x1
f0102f89:	e8 1c df ff ff       	call   f0100eaa <page_alloc>
		if (!pg || page_insert(e->env_pgdir, pg, (void *)i, PTE_W | PTE_U)) 
f0102f8e:	83 c4 10             	add    $0x10,%esp
f0102f91:	85 c0                	test   %eax,%eax
f0102f93:	74 1b                	je     f0102fb0 <region_alloc+0x50>
f0102f95:	6a 06                	push   $0x6
f0102f97:	53                   	push   %ebx
f0102f98:	50                   	push   %eax
f0102f99:	ff 77 60             	push   0x60(%edi)
f0102f9c:	e8 0a e2 ff ff       	call   f01011ab <page_insert>
f0102fa1:	83 c4 10             	add    $0x10,%esp
f0102fa4:	85 c0                	test   %eax,%eax
f0102fa6:	75 08                	jne    f0102fb0 <region_alloc+0x50>
	for (int i = vstart; i < vend; i += PGSIZE) {
f0102fa8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102fae:	eb d0                	jmp    f0102f80 <region_alloc+0x20>
			panic("failed to alloc region for user\n");
f0102fb0:	83 ec 04             	sub    $0x4,%esp
f0102fb3:	68 bc 71 10 f0       	push   $0xf01071bc
f0102fb8:	68 29 01 00 00       	push   $0x129
f0102fbd:	68 dd 71 10 f0       	push   $0xf01071dd
f0102fc2:	e8 79 d0 ff ff       	call   f0100040 <_panic>
	}
}
f0102fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102fca:	5b                   	pop    %ebx
f0102fcb:	5e                   	pop    %esi
f0102fcc:	5f                   	pop    %edi
f0102fcd:	5d                   	pop    %ebp
f0102fce:	c3                   	ret    

f0102fcf <envid2env>:
{
f0102fcf:	55                   	push   %ebp
f0102fd0:	89 e5                	mov    %esp,%ebp
f0102fd2:	56                   	push   %esi
f0102fd3:	53                   	push   %ebx
f0102fd4:	8b 75 08             	mov    0x8(%ebp),%esi
f0102fd7:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0102fda:	85 f6                	test   %esi,%esi
f0102fdc:	74 2e                	je     f010300c <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f0102fde:	89 f3                	mov    %esi,%ebx
f0102fe0:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0102fe6:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0102fe9:	03 1d 74 b2 1e f0    	add    0xf01eb274,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0102fef:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0102ff3:	74 5b                	je     f0103050 <envid2env+0x81>
f0102ff5:	39 73 48             	cmp    %esi,0x48(%ebx)
f0102ff8:	75 62                	jne    f010305c <envid2env+0x8d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0102ffa:	84 c0                	test   %al,%al
f0102ffc:	75 20                	jne    f010301e <envid2env+0x4f>
	return 0;
f0102ffe:	b8 00 00 00 00       	mov    $0x0,%eax
		*env_store = curenv;
f0103003:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103006:	89 1a                	mov    %ebx,(%edx)
}
f0103008:	5b                   	pop    %ebx
f0103009:	5e                   	pop    %esi
f010300a:	5d                   	pop    %ebp
f010300b:	c3                   	ret    
		*env_store = curenv;
f010300c:	e8 97 29 00 00       	call   f01059a8 <cpunum>
f0103011:	6b c0 74             	imul   $0x74,%eax,%eax
f0103014:	8b 98 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%ebx
		return 0;
f010301a:	89 f0                	mov    %esi,%eax
f010301c:	eb e5                	jmp    f0103003 <envid2env+0x34>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010301e:	e8 85 29 00 00       	call   f01059a8 <cpunum>
f0103023:	6b c0 74             	imul   $0x74,%eax,%eax
f0103026:	39 98 28 c0 22 f0    	cmp    %ebx,-0xfdd3fd8(%eax)
f010302c:	74 d0                	je     f0102ffe <envid2env+0x2f>
f010302e:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103031:	e8 72 29 00 00       	call   f01059a8 <cpunum>
f0103036:	6b c0 74             	imul   $0x74,%eax,%eax
f0103039:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f010303f:	3b 70 48             	cmp    0x48(%eax),%esi
f0103042:	74 ba                	je     f0102ffe <envid2env+0x2f>
f0103044:	bb 00 00 00 00       	mov    $0x0,%ebx
		return -E_BAD_ENV;
f0103049:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010304e:	eb b3                	jmp    f0103003 <envid2env+0x34>
f0103050:	bb 00 00 00 00       	mov    $0x0,%ebx
		return -E_BAD_ENV;
f0103055:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010305a:	eb a7                	jmp    f0103003 <envid2env+0x34>
f010305c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103061:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103066:	eb 9b                	jmp    f0103003 <envid2env+0x34>

f0103068 <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f0103068:	b8 20 43 12 f0       	mov    $0xf0124320,%eax
f010306d:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103070:	b8 23 00 00 00       	mov    $0x23,%eax
f0103075:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103077:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103079:	b8 10 00 00 00       	mov    $0x10,%eax
f010307e:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103080:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103082:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103084:	ea 8b 30 10 f0 08 00 	ljmp   $0x8,$0xf010308b
	asm volatile("lldt %0" : : "r" (sel));
f010308b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103090:	0f 00 d0             	lldt   %ax
}
f0103093:	c3                   	ret    

f0103094 <env_init>:
{
f0103094:	55                   	push   %ebp
f0103095:	89 e5                	mov    %esp,%ebp
f0103097:	53                   	push   %ebx
f0103098:	83 ec 04             	sub    $0x4,%esp
		envs[i].env_link = env_free_list;
f010309b:	8b 1d 74 b2 1e f0    	mov    0xf01eb274,%ebx
f01030a1:	8d 83 84 ef 01 00    	lea    0x1ef84(%ebx),%eax
f01030a7:	ba 00 00 00 00       	mov    $0x0,%edx
f01030ac:	89 d1                	mov    %edx,%ecx
f01030ae:	89 c2                	mov    %eax,%edx
f01030b0:	89 48 44             	mov    %ecx,0x44(%eax)
		envs[i].env_id = 0;
f01030b3:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_status = ENV_FREE;
f01030ba:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	for (int i = NENV-1; i >= 0; i--) {
f01030c1:	83 e8 7c             	sub    $0x7c,%eax
f01030c4:	39 da                	cmp    %ebx,%edx
f01030c6:	75 e4                	jne    f01030ac <env_init+0x18>
f01030c8:	89 1d 78 b2 1e f0    	mov    %ebx,0xf01eb278
	env_init_percpu();
f01030ce:	e8 95 ff ff ff       	call   f0103068 <env_init_percpu>
}
f01030d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01030d6:	c9                   	leave  
f01030d7:	c3                   	ret    

f01030d8 <env_alloc>:
{
f01030d8:	55                   	push   %ebp
f01030d9:	89 e5                	mov    %esp,%ebp
f01030db:	57                   	push   %edi
f01030dc:	56                   	push   %esi
f01030dd:	53                   	push   %ebx
f01030de:	83 ec 0c             	sub    $0xc,%esp
	if (!(e = env_free_list))
f01030e1:	8b 1d 78 b2 1e f0    	mov    0xf01eb278,%ebx
f01030e7:	85 db                	test   %ebx,%ebx
f01030e9:	0f 84 5b 01 00 00    	je     f010324a <env_alloc+0x172>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01030ef:	83 ec 0c             	sub    $0xc,%esp
f01030f2:	6a 01                	push   $0x1
f01030f4:	e8 b1 dd ff ff       	call   f0100eaa <page_alloc>
f01030f9:	83 c4 10             	add    $0x10,%esp
f01030fc:	85 c0                	test   %eax,%eax
f01030fe:	0f 84 4d 01 00 00    	je     f0103251 <env_alloc+0x179>
	p->pp_ref++;
f0103104:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103109:	2b 05 58 b2 1e f0    	sub    0xf01eb258,%eax
f010310f:	c1 f8 03             	sar    $0x3,%eax
f0103112:	89 c2                	mov    %eax,%edx
f0103114:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103117:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010311c:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0103122:	73 1a                	jae    f010313e <env_alloc+0x66>
	return (void *)(pa + KERNBASE);
f0103124:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010312a:	89 53 60             	mov    %edx,0x60(%ebx)
	e->env_pgdir = page2kva(p);
f010312d:	ba 00 00 00 00       	mov    $0x0,%edx
	for (int i = 0; i < 1024; i++) {
f0103132:	b8 00 00 00 00       	mov    $0x0,%eax
		e->env_pgdir[i] = i < (UTOP/PTSIZE) ? 0 : kern_pgdir[i];
f0103137:	be 00 00 00 00       	mov    $0x0,%esi
f010313c:	eb 25                	jmp    f0103163 <env_alloc+0x8b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010313e:	52                   	push   %edx
f010313f:	68 04 60 10 f0       	push   $0xf0106004
f0103144:	6a 58                	push   $0x58
f0103146:	68 8d 6e 10 f0       	push   $0xf0106e8d
f010314b:	e8 f0 ce ff ff       	call   f0100040 <_panic>
f0103150:	8b 7b 60             	mov    0x60(%ebx),%edi
f0103153:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
	for (int i = 0; i < 1024; i++) {
f0103156:	83 c0 01             	add    $0x1,%eax
f0103159:	83 c2 04             	add    $0x4,%edx
f010315c:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103161:	74 14                	je     f0103177 <env_alloc+0x9f>
		e->env_pgdir[i] = i < (UTOP/PTSIZE) ? 0 : kern_pgdir[i];
f0103163:	89 f1                	mov    %esi,%ecx
f0103165:	3d ba 03 00 00       	cmp    $0x3ba,%eax
f010316a:	76 e4                	jbe    f0103150 <env_alloc+0x78>
f010316c:	8b 0d 5c b2 1e f0    	mov    0xf01eb25c,%ecx
f0103172:	8b 0c 11             	mov    (%ecx,%edx,1),%ecx
f0103175:	eb d9                	jmp    f0103150 <env_alloc+0x78>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103177:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010317a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010317f:	0f 86 b0 00 00 00    	jbe    f0103235 <env_alloc+0x15d>
	return (physaddr_t)kva - KERNBASE;
f0103185:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010318b:	83 ca 05             	or     $0x5,%edx
f010318e:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103194:	8b 43 48             	mov    0x48(%ebx),%eax
f0103197:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f010319c:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f01031a1:	ba 00 10 00 00       	mov    $0x1000,%edx
f01031a6:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01031a9:	89 da                	mov    %ebx,%edx
f01031ab:	2b 15 74 b2 1e f0    	sub    0xf01eb274,%edx
f01031b1:	c1 fa 02             	sar    $0x2,%edx
f01031b4:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01031ba:	09 d0                	or     %edx,%eax
f01031bc:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01031bf:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031c2:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01031c5:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01031cc:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01031d3:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01031da:	83 ec 04             	sub    $0x4,%esp
f01031dd:	6a 44                	push   $0x44
f01031df:	6a 00                	push   $0x0
f01031e1:	53                   	push   %ebx
f01031e2:	e8 cd 21 00 00       	call   f01053b4 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01031e7:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01031ed:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01031f3:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01031f9:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103200:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags = e->env_tf.tf_eflags | FL_IF;
f0103206:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010320d:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103214:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103218:	8b 43 44             	mov    0x44(%ebx),%eax
f010321b:	a3 78 b2 1e f0       	mov    %eax,0xf01eb278
	*newenv_store = e;
f0103220:	8b 45 08             	mov    0x8(%ebp),%eax
f0103223:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103225:	83 c4 10             	add    $0x10,%esp
f0103228:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010322d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103230:	5b                   	pop    %ebx
f0103231:	5e                   	pop    %esi
f0103232:	5f                   	pop    %edi
f0103233:	5d                   	pop    %ebp
f0103234:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103235:	50                   	push   %eax
f0103236:	68 28 60 10 f0       	push   $0xf0106028
f010323b:	68 c6 00 00 00       	push   $0xc6
f0103240:	68 dd 71 10 f0       	push   $0xf01071dd
f0103245:	e8 f6 cd ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f010324a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f010324f:	eb dc                	jmp    f010322d <env_alloc+0x155>
		return -E_NO_MEM;
f0103251:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103256:	eb d5                	jmp    f010322d <env_alloc+0x155>

f0103258 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103258:	55                   	push   %ebp
f0103259:	89 e5                	mov    %esp,%ebp
f010325b:	57                   	push   %edi
f010325c:	56                   	push   %esi
f010325d:	53                   	push   %ebx
f010325e:	83 ec 34             	sub    $0x34,%esp
f0103261:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *e;
	env_alloc(&e, 0);
f0103264:	6a 00                	push   $0x0
f0103266:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103269:	50                   	push   %eax
f010326a:	e8 69 fe ff ff       	call   f01030d8 <env_alloc>
	if (!e) return;
f010326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103272:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103275:	83 c4 10             	add    $0x10,%esp
f0103278:	85 c0                	test   %eax,%eax
f010327a:	0f 84 ea 00 00 00    	je     f010336a <env_create+0x112>
	e->env_type = type;
f0103280:	89 58 50             	mov    %ebx,0x50(%eax)
	if(type == ENV_TYPE_FS)
f0103283:	83 fb 01             	cmp    $0x1,%ebx
f0103286:	74 50                	je     f01032d8 <env_create+0x80>
		e->env_tf.tf_eflags |= FL_IOPL_3;
	else e->env_tf.tf_eflags &= (-1-FL_IOPL_3);
f0103288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010328b:	8b 40 38             	mov    0x38(%eax),%eax
f010328e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103291:	80 e4 cf             	and    $0xcf,%ah
f0103294:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103297:	89 43 38             	mov    %eax,0x38(%ebx)
	region_alloc(e, (void *)(USTACKTOP-PGSIZE), PGSIZE);
f010329a:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010329f:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01032a4:	89 d8                	mov    %ebx,%eax
f01032a6:	e8 b5 fc ff ff       	call   f0102f60 <region_alloc>
	start = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
f01032ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01032ae:	89 c6                	mov    %eax,%esi
f01032b0:	03 70 1c             	add    0x1c(%eax),%esi
	eph = start + elf->e_phnum;
f01032b3:	0f b7 78 2c          	movzwl 0x2c(%eax),%edi
f01032b7:	c1 e7 05             	shl    $0x5,%edi
f01032ba:	01 f7                	add    %esi,%edi
	lcr3(PADDR((void *)e->env_pgdir));
f01032bc:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01032bf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032c4:	76 1d                	jbe    f01032e3 <env_create+0x8b>
	return (physaddr_t)kva - KERNBASE;
f01032c6:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01032cb:	0f 22 d8             	mov    %eax,%cr3
	for (ph = start; ph < eph; ph++) {
f01032ce:	89 f3                	mov    %esi,%ebx
f01032d0:	89 75 d0             	mov    %esi,-0x30(%ebp)
f01032d3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01032d6:	eb 43                	jmp    f010331b <env_create+0xc3>
		e->env_tf.tf_eflags |= FL_IOPL_3;
f01032d8:	8b 40 38             	mov    0x38(%eax),%eax
f01032db:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01032de:	80 cc 30             	or     $0x30,%ah
f01032e1:	eb b1                	jmp    f0103294 <env_create+0x3c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032e3:	50                   	push   %eax
f01032e4:	68 28 60 10 f0       	push   $0xf0106028
f01032e9:	68 6e 01 00 00       	push   $0x16e
f01032ee:	68 dd 71 10 f0       	push   $0xf01071dd
f01032f3:	e8 48 cd ff ff       	call   f0100040 <_panic>
		region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01032f8:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01032fb:	8b 53 08             	mov    0x8(%ebx),%edx
f01032fe:	89 f0                	mov    %esi,%eax
f0103300:	e8 5b fc ff ff       	call   f0102f60 <region_alloc>
		memset((void *)ph->p_va, 0, ph->p_memsz);
f0103305:	83 ec 04             	sub    $0x4,%esp
f0103308:	ff 73 14             	push   0x14(%ebx)
f010330b:	6a 00                	push   $0x0
f010330d:	ff 73 08             	push   0x8(%ebx)
f0103310:	e8 9f 20 00 00       	call   f01053b4 <memset>
	for (ph = start; ph < eph; ph++) {
f0103315:	83 c3 20             	add    $0x20,%ebx
f0103318:	83 c4 10             	add    $0x10,%esp
f010331b:	39 df                	cmp    %ebx,%edi
f010331d:	77 d9                	ja     f01032f8 <env_create+0xa0>
f010331f:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0103322:	eb 03                	jmp    f0103327 <env_create+0xcf>
	for (ph = start; ph < eph; ph++) {
f0103324:	83 c6 20             	add    $0x20,%esi
f0103327:	39 f7                	cmp    %esi,%edi
f0103329:	76 1f                	jbe    f010334a <env_create+0xf2>
		if (ph->p_type == ELF_PROG_LOAD) memcpy((void *)ph->p_va, binary+ph->p_offset, ph->p_filesz);
f010332b:	83 3e 01             	cmpl   $0x1,(%esi)
f010332e:	75 f4                	jne    f0103324 <env_create+0xcc>
f0103330:	83 ec 04             	sub    $0x4,%esp
f0103333:	ff 76 10             	push   0x10(%esi)
f0103336:	8b 45 08             	mov    0x8(%ebp),%eax
f0103339:	03 46 04             	add    0x4(%esi),%eax
f010333c:	50                   	push   %eax
f010333d:	ff 76 08             	push   0x8(%esi)
f0103340:	e8 17 21 00 00       	call   f010545c <memcpy>
f0103345:	83 c4 10             	add    $0x10,%esp
f0103348:	eb da                	jmp    f0103324 <env_create+0xcc>
	lcr3(PADDR(kern_pgdir));
f010334a:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f010334f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103354:	76 1c                	jbe    f0103372 <env_create+0x11a>
	return (physaddr_t)kva - KERNBASE;
f0103356:	05 00 00 00 10       	add    $0x10000000,%eax
f010335b:	0f 22 d8             	mov    %eax,%cr3
	e->env_tf.tf_eip = elf->e_entry;	
f010335e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103361:	8b 40 18             	mov    0x18(%eax),%eax
f0103364:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103367:	89 42 30             	mov    %eax,0x30(%edx)
	load_icode(e, binary);
}
f010336a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010336d:	5b                   	pop    %ebx
f010336e:	5e                   	pop    %esi
f010336f:	5f                   	pop    %edi
f0103370:	5d                   	pop    %ebp
f0103371:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103372:	50                   	push   %eax
f0103373:	68 28 60 10 f0       	push   $0xf0106028
f0103378:	68 76 01 00 00       	push   $0x176
f010337d:	68 dd 71 10 f0       	push   $0xf01071dd
f0103382:	e8 b9 cc ff ff       	call   f0100040 <_panic>

f0103387 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103387:	55                   	push   %ebp
f0103388:	89 e5                	mov    %esp,%ebp
f010338a:	57                   	push   %edi
f010338b:	56                   	push   %esi
f010338c:	53                   	push   %ebx
f010338d:	83 ec 1c             	sub    $0x1c,%esp
f0103390:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103393:	e8 10 26 00 00       	call   f01059a8 <cpunum>
f0103398:	6b c0 74             	imul   $0x74,%eax,%eax
f010339b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01033a2:	39 b8 28 c0 22 f0    	cmp    %edi,-0xfdd3fd8(%eax)
f01033a8:	0f 85 b3 00 00 00    	jne    f0103461 <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f01033ae:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f01033b3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033b8:	76 14                	jbe    f01033ce <env_free+0x47>
	return (physaddr_t)kva - KERNBASE;
f01033ba:	05 00 00 00 10       	add    $0x10000000,%eax
f01033bf:	0f 22 d8             	mov    %eax,%cr3
}
f01033c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01033c9:	e9 93 00 00 00       	jmp    f0103461 <env_free+0xda>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033ce:	50                   	push   %eax
f01033cf:	68 28 60 10 f0       	push   $0xf0106028
f01033d4:	68 a0 01 00 00       	push   $0x1a0
f01033d9:	68 dd 71 10 f0       	push   $0xf01071dd
f01033de:	e8 5d cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033e3:	56                   	push   %esi
f01033e4:	68 04 60 10 f0       	push   $0xf0106004
f01033e9:	68 af 01 00 00       	push   $0x1af
f01033ee:	68 dd 71 10 f0       	push   $0xf01071dd
f01033f3:	e8 48 cc ff ff       	call   f0100040 <_panic>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01033f8:	83 c6 04             	add    $0x4,%esi
f01033fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103401:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
f0103407:	74 1b                	je     f0103424 <env_free+0x9d>
			if (pt[pteno] & PTE_P)
f0103409:	f6 06 01             	testb  $0x1,(%esi)
f010340c:	74 ea                	je     f01033f8 <env_free+0x71>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010340e:	83 ec 08             	sub    $0x8,%esp
f0103411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103414:	09 d8                	or     %ebx,%eax
f0103416:	50                   	push   %eax
f0103417:	ff 77 60             	push   0x60(%edi)
f010341a:	e8 29 dd ff ff       	call   f0101148 <page_remove>
f010341f:	83 c4 10             	add    $0x10,%esp
f0103422:	eb d4                	jmp    f01033f8 <env_free+0x71>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103424:	8b 47 60             	mov    0x60(%edi),%eax
f0103427:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010342a:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103431:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103434:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f010343a:	73 65                	jae    f01034a1 <env_free+0x11a>
		page_decref(pa2page(pa));
f010343c:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010343f:	a1 58 b2 1e f0       	mov    0xf01eb258,%eax
f0103444:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103447:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f010344a:	50                   	push   %eax
f010344b:	e8 05 db ff ff       	call   f0100f55 <page_decref>
f0103450:	83 c4 10             	add    $0x10,%esp
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103453:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103457:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010345a:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010345f:	74 54                	je     f01034b5 <env_free+0x12e>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103461:	8b 47 60             	mov    0x60(%edi),%eax
f0103464:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103467:	8b 04 08             	mov    (%eax,%ecx,1),%eax
f010346a:	a8 01                	test   $0x1,%al
f010346c:	74 e5                	je     f0103453 <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010346e:	89 c6                	mov    %eax,%esi
f0103470:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103476:	c1 e8 0c             	shr    $0xc,%eax
f0103479:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010347c:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f0103482:	0f 83 5b ff ff ff    	jae    f01033e3 <env_free+0x5c>
	return (void *)(pa + KERNBASE);
f0103488:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f010348e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103491:	c1 e0 14             	shl    $0x14,%eax
f0103494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103497:	bb 00 00 00 00       	mov    $0x0,%ebx
f010349c:	e9 68 ff ff ff       	jmp    f0103409 <env_free+0x82>
		panic("pa2page called with invalid pa");
f01034a1:	83 ec 04             	sub    $0x4,%esp
f01034a4:	68 48 66 10 f0       	push   $0xf0106648
f01034a9:	6a 51                	push   $0x51
f01034ab:	68 8d 6e 10 f0       	push   $0xf0106e8d
f01034b0:	e8 8b cb ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01034b5:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01034b8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034bd:	76 49                	jbe    f0103508 <env_free+0x181>
	e->env_pgdir = 0;
f01034bf:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01034c6:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01034cb:	c1 e8 0c             	shr    $0xc,%eax
f01034ce:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f01034d4:	73 47                	jae    f010351d <env_free+0x196>
	page_decref(pa2page(pa));
f01034d6:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01034d9:	8b 15 58 b2 1e f0    	mov    0xf01eb258,%edx
f01034df:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01034e2:	50                   	push   %eax
f01034e3:	e8 6d da ff ff       	call   f0100f55 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01034e8:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01034ef:	a1 78 b2 1e f0       	mov    0xf01eb278,%eax
f01034f4:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01034f7:	89 3d 78 b2 1e f0    	mov    %edi,0xf01eb278
}
f01034fd:	83 c4 10             	add    $0x10,%esp
f0103500:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103503:	5b                   	pop    %ebx
f0103504:	5e                   	pop    %esi
f0103505:	5f                   	pop    %edi
f0103506:	5d                   	pop    %ebp
f0103507:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103508:	50                   	push   %eax
f0103509:	68 28 60 10 f0       	push   $0xf0106028
f010350e:	68 bd 01 00 00       	push   $0x1bd
f0103513:	68 dd 71 10 f0       	push   $0xf01071dd
f0103518:	e8 23 cb ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f010351d:	83 ec 04             	sub    $0x4,%esp
f0103520:	68 48 66 10 f0       	push   $0xf0106648
f0103525:	6a 51                	push   $0x51
f0103527:	68 8d 6e 10 f0       	push   $0xf0106e8d
f010352c:	e8 0f cb ff ff       	call   f0100040 <_panic>

f0103531 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103531:	55                   	push   %ebp
f0103532:	89 e5                	mov    %esp,%ebp
f0103534:	53                   	push   %ebx
f0103535:	83 ec 04             	sub    $0x4,%esp
f0103538:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010353b:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010353f:	74 21                	je     f0103562 <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103541:	83 ec 0c             	sub    $0xc,%esp
f0103544:	53                   	push   %ebx
f0103545:	e8 3d fe ff ff       	call   f0103387 <env_free>

	if (curenv == e) {
f010354a:	e8 59 24 00 00       	call   f01059a8 <cpunum>
f010354f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103552:	83 c4 10             	add    $0x10,%esp
f0103555:	39 98 28 c0 22 f0    	cmp    %ebx,-0xfdd3fd8(%eax)
f010355b:	74 1e                	je     f010357b <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f010355d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103560:	c9                   	leave  
f0103561:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103562:	e8 41 24 00 00       	call   f01059a8 <cpunum>
f0103567:	6b c0 74             	imul   $0x74,%eax,%eax
f010356a:	39 98 28 c0 22 f0    	cmp    %ebx,-0xfdd3fd8(%eax)
f0103570:	74 cf                	je     f0103541 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103572:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103579:	eb e2                	jmp    f010355d <env_destroy+0x2c>
		curenv = NULL;
f010357b:	e8 28 24 00 00       	call   f01059a8 <cpunum>
f0103580:	6b c0 74             	imul   $0x74,%eax,%eax
f0103583:	c7 80 28 c0 22 f0 00 	movl   $0x0,-0xfdd3fd8(%eax)
f010358a:	00 00 00 
		sched_yield();
f010358d:	e8 b3 0b 00 00       	call   f0104145 <sched_yield>

f0103592 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103592:	55                   	push   %ebp
f0103593:	89 e5                	mov    %esp,%ebp
f0103595:	53                   	push   %ebx
f0103596:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103599:	e8 0a 24 00 00       	call   f01059a8 <cpunum>
f010359e:	6b c0 74             	imul   $0x74,%eax,%eax
f01035a1:	8b 98 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%ebx
f01035a7:	e8 fc 23 00 00       	call   f01059a8 <cpunum>
f01035ac:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01035af:	8b 65 08             	mov    0x8(%ebp),%esp
f01035b2:	61                   	popa   
f01035b3:	07                   	pop    %es
f01035b4:	1f                   	pop    %ds
f01035b5:	83 c4 08             	add    $0x8,%esp
f01035b8:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01035b9:	83 ec 04             	sub    $0x4,%esp
f01035bc:	68 e8 71 10 f0       	push   $0xf01071e8
f01035c1:	68 f4 01 00 00       	push   $0x1f4
f01035c6:	68 dd 71 10 f0       	push   $0xf01071dd
f01035cb:	e8 70 ca ff ff       	call   f0100040 <_panic>

f01035d0 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01035d0:	55                   	push   %ebp
f01035d1:	89 e5                	mov    %esp,%ebp
f01035d3:	53                   	push   %ebx
f01035d4:	83 ec 04             	sub    $0x4,%esp
f01035d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.

	if (e != curenv) {
f01035da:	e8 c9 23 00 00       	call   f01059a8 <cpunum>
f01035df:	6b c0 74             	imul   $0x74,%eax,%eax
f01035e2:	39 98 28 c0 22 f0    	cmp    %ebx,-0xfdd3fd8(%eax)
f01035e8:	74 50                	je     f010363a <env_run+0x6a>
		if (curenv && curenv->env_status == ENV_RUNNING) curenv->env_status = ENV_RUNNABLE;
f01035ea:	e8 b9 23 00 00       	call   f01059a8 <cpunum>
f01035ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01035f2:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f01035f9:	74 14                	je     f010360f <env_run+0x3f>
f01035fb:	e8 a8 23 00 00       	call   f01059a8 <cpunum>
f0103600:	6b c0 74             	imul   $0x74,%eax,%eax
f0103603:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103609:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010360d:	74 42                	je     f0103651 <env_run+0x81>
		curenv = e;
f010360f:	e8 94 23 00 00       	call   f01059a8 <cpunum>
f0103614:	6b c0 74             	imul   $0x74,%eax,%eax
f0103617:	89 98 28 c0 22 f0    	mov    %ebx,-0xfdd3fd8(%eax)
		e->env_status = ENV_RUNNING;
f010361d:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
		e->env_runs++;
f0103624:	83 43 58 01          	addl   $0x1,0x58(%ebx)
		lcr3(PADDR((void *)e->env_pgdir));
f0103628:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010362b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103630:	76 36                	jbe    f0103668 <env_run+0x98>
	return (physaddr_t)kva - KERNBASE;
f0103632:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103637:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010363a:	83 ec 0c             	sub    $0xc,%esp
f010363d:	68 80 44 12 f0       	push   $0xf0124480
f0103642:	e8 6b 26 00 00       	call   f0105cb2 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103647:	f3 90                	pause  
	}
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0103649:	89 1c 24             	mov    %ebx,(%esp)
f010364c:	e8 41 ff ff ff       	call   f0103592 <env_pop_tf>
		if (curenv && curenv->env_status == ENV_RUNNING) curenv->env_status = ENV_RUNNABLE;
f0103651:	e8 52 23 00 00       	call   f01059a8 <cpunum>
f0103656:	6b c0 74             	imul   $0x74,%eax,%eax
f0103659:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f010365f:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103666:	eb a7                	jmp    f010360f <env_run+0x3f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103668:	50                   	push   %eax
f0103669:	68 28 60 10 f0       	push   $0xf0106028
f010366e:	68 18 02 00 00       	push   $0x218
f0103673:	68 dd 71 10 f0       	push   $0xf01071dd
f0103678:	e8 c3 c9 ff ff       	call   f0100040 <_panic>

f010367d <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010367d:	55                   	push   %ebp
f010367e:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103680:	8b 45 08             	mov    0x8(%ebp),%eax
f0103683:	ba 70 00 00 00       	mov    $0x70,%edx
f0103688:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103689:	ba 71 00 00 00       	mov    $0x71,%edx
f010368e:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010368f:	0f b6 c0             	movzbl %al,%eax
}
f0103692:	5d                   	pop    %ebp
f0103693:	c3                   	ret    

f0103694 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103694:	55                   	push   %ebp
f0103695:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103697:	8b 45 08             	mov    0x8(%ebp),%eax
f010369a:	ba 70 00 00 00       	mov    $0x70,%edx
f010369f:	ee                   	out    %al,(%dx)
f01036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036a3:	ba 71 00 00 00       	mov    $0x71,%edx
f01036a8:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01036a9:	5d                   	pop    %ebp
f01036aa:	c3                   	ret    

f01036ab <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01036ab:	55                   	push   %ebp
f01036ac:	89 e5                	mov    %esp,%ebp
f01036ae:	56                   	push   %esi
f01036af:	53                   	push   %ebx
f01036b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	irq_mask_8259A = mask;
f01036b3:	66 89 0d a8 43 12 f0 	mov    %cx,0xf01243a8
	if (!didinit)
f01036ba:	80 3d 7c b2 1e f0 00 	cmpb   $0x0,0xf01eb27c
f01036c1:	75 07                	jne    f01036ca <irq_setmask_8259A+0x1f>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01036c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01036c6:	5b                   	pop    %ebx
f01036c7:	5e                   	pop    %esi
f01036c8:	5d                   	pop    %ebp
f01036c9:	c3                   	ret    
f01036ca:	89 ce                	mov    %ecx,%esi
f01036cc:	ba 21 00 00 00       	mov    $0x21,%edx
f01036d1:	89 c8                	mov    %ecx,%eax
f01036d3:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01036d4:	89 c8                	mov    %ecx,%eax
f01036d6:	66 c1 e8 08          	shr    $0x8,%ax
f01036da:	ba a1 00 00 00       	mov    $0xa1,%edx
f01036df:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01036e0:	83 ec 0c             	sub    $0xc,%esp
f01036e3:	68 f4 71 10 f0       	push   $0xf01071f4
f01036e8:	e8 20 01 00 00       	call   f010380d <cprintf>
f01036ed:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01036f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01036f5:	0f b7 f6             	movzwl %si,%esi
f01036f8:	f7 d6                	not    %esi
f01036fa:	eb 08                	jmp    f0103704 <irq_setmask_8259A+0x59>
	for (i = 0; i < 16; i++)
f01036fc:	83 c3 01             	add    $0x1,%ebx
f01036ff:	83 fb 10             	cmp    $0x10,%ebx
f0103702:	74 18                	je     f010371c <irq_setmask_8259A+0x71>
		if (~mask & (1<<i))
f0103704:	0f a3 de             	bt     %ebx,%esi
f0103707:	73 f3                	jae    f01036fc <irq_setmask_8259A+0x51>
			cprintf(" %d", i);
f0103709:	83 ec 08             	sub    $0x8,%esp
f010370c:	53                   	push   %ebx
f010370d:	68 87 77 10 f0       	push   $0xf0107787
f0103712:	e8 f6 00 00 00       	call   f010380d <cprintf>
f0103717:	83 c4 10             	add    $0x10,%esp
f010371a:	eb e0                	jmp    f01036fc <irq_setmask_8259A+0x51>
	cprintf("\n");
f010371c:	83 ec 0c             	sub    $0xc,%esp
f010371f:	68 89 71 10 f0       	push   $0xf0107189
f0103724:	e8 e4 00 00 00       	call   f010380d <cprintf>
f0103729:	83 c4 10             	add    $0x10,%esp
f010372c:	eb 95                	jmp    f01036c3 <irq_setmask_8259A+0x18>

f010372e <pic_init>:
{
f010372e:	55                   	push   %ebp
f010372f:	89 e5                	mov    %esp,%ebp
f0103731:	57                   	push   %edi
f0103732:	56                   	push   %esi
f0103733:	53                   	push   %ebx
f0103734:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103737:	c6 05 7c b2 1e f0 01 	movb   $0x1,0xf01eb27c
f010373e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103743:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103748:	89 da                	mov    %ebx,%edx
f010374a:	ee                   	out    %al,(%dx)
f010374b:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103750:	89 ca                	mov    %ecx,%edx
f0103752:	ee                   	out    %al,(%dx)
f0103753:	bf 11 00 00 00       	mov    $0x11,%edi
f0103758:	be 20 00 00 00       	mov    $0x20,%esi
f010375d:	89 f8                	mov    %edi,%eax
f010375f:	89 f2                	mov    %esi,%edx
f0103761:	ee                   	out    %al,(%dx)
f0103762:	b8 20 00 00 00       	mov    $0x20,%eax
f0103767:	89 da                	mov    %ebx,%edx
f0103769:	ee                   	out    %al,(%dx)
f010376a:	b8 04 00 00 00       	mov    $0x4,%eax
f010376f:	ee                   	out    %al,(%dx)
f0103770:	b8 03 00 00 00       	mov    $0x3,%eax
f0103775:	ee                   	out    %al,(%dx)
f0103776:	bb a0 00 00 00       	mov    $0xa0,%ebx
f010377b:	89 f8                	mov    %edi,%eax
f010377d:	89 da                	mov    %ebx,%edx
f010377f:	ee                   	out    %al,(%dx)
f0103780:	b8 28 00 00 00       	mov    $0x28,%eax
f0103785:	89 ca                	mov    %ecx,%edx
f0103787:	ee                   	out    %al,(%dx)
f0103788:	b8 02 00 00 00       	mov    $0x2,%eax
f010378d:	ee                   	out    %al,(%dx)
f010378e:	b8 01 00 00 00       	mov    $0x1,%eax
f0103793:	ee                   	out    %al,(%dx)
f0103794:	bf 68 00 00 00       	mov    $0x68,%edi
f0103799:	89 f8                	mov    %edi,%eax
f010379b:	89 f2                	mov    %esi,%edx
f010379d:	ee                   	out    %al,(%dx)
f010379e:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01037a3:	89 c8                	mov    %ecx,%eax
f01037a5:	ee                   	out    %al,(%dx)
f01037a6:	89 f8                	mov    %edi,%eax
f01037a8:	89 da                	mov    %ebx,%edx
f01037aa:	ee                   	out    %al,(%dx)
f01037ab:	89 c8                	mov    %ecx,%eax
f01037ad:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01037ae:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01037b5:	66 83 f8 ff          	cmp    $0xffff,%ax
f01037b9:	75 08                	jne    f01037c3 <pic_init+0x95>
}
f01037bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01037be:	5b                   	pop    %ebx
f01037bf:	5e                   	pop    %esi
f01037c0:	5f                   	pop    %edi
f01037c1:	5d                   	pop    %ebp
f01037c2:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01037c3:	83 ec 0c             	sub    $0xc,%esp
f01037c6:	0f b7 c0             	movzwl %ax,%eax
f01037c9:	50                   	push   %eax
f01037ca:	e8 dc fe ff ff       	call   f01036ab <irq_setmask_8259A>
f01037cf:	83 c4 10             	add    $0x10,%esp
}
f01037d2:	eb e7                	jmp    f01037bb <pic_init+0x8d>

f01037d4 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01037d4:	55                   	push   %ebp
f01037d5:	89 e5                	mov    %esp,%ebp
f01037d7:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01037da:	ff 75 08             	push   0x8(%ebp)
f01037dd:	e8 9b cf ff ff       	call   f010077d <cputchar>
	*cnt++;
}
f01037e2:	83 c4 10             	add    $0x10,%esp
f01037e5:	c9                   	leave  
f01037e6:	c3                   	ret    

f01037e7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01037e7:	55                   	push   %ebp
f01037e8:	89 e5                	mov    %esp,%ebp
f01037ea:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01037ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01037f4:	ff 75 0c             	push   0xc(%ebp)
f01037f7:	ff 75 08             	push   0x8(%ebp)
f01037fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01037fd:	50                   	push   %eax
f01037fe:	68 d4 37 10 f0       	push   $0xf01037d4
f0103803:	e8 a0 13 00 00       	call   f0104ba8 <vprintfmt>
	return cnt;
}
f0103808:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010380b:	c9                   	leave  
f010380c:	c3                   	ret    

f010380d <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010380d:	55                   	push   %ebp
f010380e:	89 e5                	mov    %esp,%ebp
f0103810:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103813:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103816:	50                   	push   %eax
f0103817:	ff 75 08             	push   0x8(%ebp)
f010381a:	e8 c8 ff ff ff       	call   f01037e7 <vcprintf>
	va_end(ap);

	return cnt;
}
f010381f:	c9                   	leave  
f0103820:	c3                   	ret    

f0103821 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103821:	55                   	push   %ebp
f0103822:	89 e5                	mov    %esp,%ebp
f0103824:	57                   	push   %edi
f0103825:	56                   	push   %esi
f0103826:	53                   	push   %ebx
f0103827:	83 ec 0c             	sub    $0xc,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = thiscpu->cpu_id;
f010382a:	e8 79 21 00 00       	call   f01059a8 <cpunum>
f010382f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103832:	0f b6 98 20 c0 22 f0 	movzbl -0xfdd3fe0(%eax),%ebx
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[i] + KSTKSIZE);
f0103839:	e8 6a 21 00 00       	call   f01059a8 <cpunum>
f010383e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103841:	0f b6 db             	movzbl %bl,%ebx
f0103844:	89 da                	mov    %ebx,%edx
f0103846:	c1 e2 0f             	shl    $0xf,%edx
f0103849:	8d 92 00 40 1f f0    	lea    -0xfe0c000(%edx),%edx
f010384f:	89 90 30 c0 22 f0    	mov    %edx,-0xfdd3fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103855:	e8 4e 21 00 00       	call   f01059a8 <cpunum>
f010385a:	6b c0 74             	imul   $0x74,%eax,%eax
f010385d:	66 c7 80 34 c0 22 f0 	movw   $0x10,-0xfdd3fcc(%eax)
f0103864:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103866:	e8 3d 21 00 00       	call   f01059a8 <cpunum>
f010386b:	6b c0 74             	imul   $0x74,%eax,%eax
f010386e:	66 c7 80 92 c0 22 f0 	movw   $0x68,-0xfdd3f6e(%eax)
f0103875:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103877:	83 c3 05             	add    $0x5,%ebx
f010387a:	e8 29 21 00 00       	call   f01059a8 <cpunum>
f010387f:	89 c7                	mov    %eax,%edi
f0103881:	e8 22 21 00 00       	call   f01059a8 <cpunum>
f0103886:	89 c6                	mov    %eax,%esi
f0103888:	e8 1b 21 00 00       	call   f01059a8 <cpunum>
f010388d:	66 c7 04 dd 40 43 12 	movw   $0x67,-0xfedbcc0(,%ebx,8)
f0103894:	f0 67 00 
f0103897:	6b ff 74             	imul   $0x74,%edi,%edi
f010389a:	81 c7 2c c0 22 f0    	add    $0xf022c02c,%edi
f01038a0:	66 89 3c dd 42 43 12 	mov    %di,-0xfedbcbe(,%ebx,8)
f01038a7:	f0 
f01038a8:	6b d6 74             	imul   $0x74,%esi,%edx
f01038ab:	81 c2 2c c0 22 f0    	add    $0xf022c02c,%edx
f01038b1:	c1 ea 10             	shr    $0x10,%edx
f01038b4:	88 14 dd 44 43 12 f0 	mov    %dl,-0xfedbcbc(,%ebx,8)
f01038bb:	c6 04 dd 46 43 12 f0 	movb   $0x40,-0xfedbcba(,%ebx,8)
f01038c2:	40 
f01038c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01038c6:	05 2c c0 22 f0       	add    $0xf022c02c,%eax
f01038cb:	c1 e8 18             	shr    $0x18,%eax
f01038ce:	88 04 dd 47 43 12 f0 	mov    %al,-0xfedbcb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f01038d5:	c6 04 dd 45 43 12 f0 	movb   $0x89,-0xfedbcbb(,%ebx,8)
f01038dc:	89 
	asm volatile("ltr %0" : : "r" (sel));
f01038dd:	b8 28 00 00 00       	mov    $0x28,%eax
f01038e2:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f01038e5:	b8 ac 43 12 f0       	mov    $0xf01243ac,%eax
f01038ea:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
f01038ed:	83 c4 0c             	add    $0xc,%esp
f01038f0:	5b                   	pop    %ebx
f01038f1:	5e                   	pop    %esi
f01038f2:	5f                   	pop    %edi
f01038f3:	5d                   	pop    %ebp
f01038f4:	c3                   	ret    

f01038f5 <trap_init>:
{
f01038f5:	55                   	push   %ebp
f01038f6:	89 e5                	mov    %esp,%ebp
f01038f8:	53                   	push   %ebx
f01038f9:	83 ec 04             	sub    $0x4,%esp
	for (int i = 0; i <= T_SYSCALL; i++) {
f01038fc:	ba 00 00 00 00       	mov    $0x0,%edx
		SETGATE(idt[i], 0, GD_KT, vector[i], (
f0103901:	8b 0c 95 b2 43 12 f0 	mov    -0xfedbc4e(,%edx,4),%ecx
f0103908:	66 89 0c d5 80 b2 1e 	mov    %cx,-0xfe14d80(,%edx,8)
f010390f:	f0 
f0103910:	66 c7 04 d5 82 b2 1e 	movw   $0x8,-0xfe14d7e(,%edx,8)
f0103917:	f0 08 00 
f010391a:	c6 04 d5 84 b2 1e f0 	movb   $0x0,-0xfe14d7c(,%edx,8)
f0103921:	00 
f0103922:	83 fa 03             	cmp    $0x3,%edx
f0103925:	0f 94 c0             	sete   %al
f0103928:	83 fa 30             	cmp    $0x30,%edx
f010392b:	0f 94 c3             	sete   %bl
f010392e:	09 d8                	or     %ebx,%eax
f0103930:	f7 d8                	neg    %eax
f0103932:	83 e0 03             	and    $0x3,%eax
f0103935:	c1 e0 05             	shl    $0x5,%eax
f0103938:	83 c8 8e             	or     $0xffffff8e,%eax
f010393b:	88 04 d5 85 b2 1e f0 	mov    %al,-0xfe14d7b(,%edx,8)
f0103942:	c1 e9 10             	shr    $0x10,%ecx
f0103945:	66 89 0c d5 86 b2 1e 	mov    %cx,-0xfe14d7a(,%edx,8)
f010394c:	f0 
	for (int i = 0; i <= T_SYSCALL; i++) {
f010394d:	83 c2 01             	add    $0x1,%edx
f0103950:	83 fa 31             	cmp    $0x31,%edx
f0103953:	75 ac                	jne    f0103901 <trap_init+0xc>
	trap_init_percpu();
f0103955:	e8 c7 fe ff ff       	call   f0103821 <trap_init_percpu>
}
f010395a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010395d:	c9                   	leave  
f010395e:	c3                   	ret    

f010395f <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010395f:	55                   	push   %ebp
f0103960:	89 e5                	mov    %esp,%ebp
f0103962:	53                   	push   %ebx
f0103963:	83 ec 0c             	sub    $0xc,%esp
f0103966:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103969:	ff 33                	push   (%ebx)
f010396b:	68 08 72 10 f0       	push   $0xf0107208
f0103970:	e8 98 fe ff ff       	call   f010380d <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103975:	83 c4 08             	add    $0x8,%esp
f0103978:	ff 73 04             	push   0x4(%ebx)
f010397b:	68 17 72 10 f0       	push   $0xf0107217
f0103980:	e8 88 fe ff ff       	call   f010380d <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103985:	83 c4 08             	add    $0x8,%esp
f0103988:	ff 73 08             	push   0x8(%ebx)
f010398b:	68 26 72 10 f0       	push   $0xf0107226
f0103990:	e8 78 fe ff ff       	call   f010380d <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103995:	83 c4 08             	add    $0x8,%esp
f0103998:	ff 73 0c             	push   0xc(%ebx)
f010399b:	68 35 72 10 f0       	push   $0xf0107235
f01039a0:	e8 68 fe ff ff       	call   f010380d <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01039a5:	83 c4 08             	add    $0x8,%esp
f01039a8:	ff 73 10             	push   0x10(%ebx)
f01039ab:	68 44 72 10 f0       	push   $0xf0107244
f01039b0:	e8 58 fe ff ff       	call   f010380d <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01039b5:	83 c4 08             	add    $0x8,%esp
f01039b8:	ff 73 14             	push   0x14(%ebx)
f01039bb:	68 53 72 10 f0       	push   $0xf0107253
f01039c0:	e8 48 fe ff ff       	call   f010380d <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01039c5:	83 c4 08             	add    $0x8,%esp
f01039c8:	ff 73 18             	push   0x18(%ebx)
f01039cb:	68 62 72 10 f0       	push   $0xf0107262
f01039d0:	e8 38 fe ff ff       	call   f010380d <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01039d5:	83 c4 08             	add    $0x8,%esp
f01039d8:	ff 73 1c             	push   0x1c(%ebx)
f01039db:	68 71 72 10 f0       	push   $0xf0107271
f01039e0:	e8 28 fe ff ff       	call   f010380d <cprintf>
}
f01039e5:	83 c4 10             	add    $0x10,%esp
f01039e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01039eb:	c9                   	leave  
f01039ec:	c3                   	ret    

f01039ed <print_trapframe>:
{
f01039ed:	55                   	push   %ebp
f01039ee:	89 e5                	mov    %esp,%ebp
f01039f0:	56                   	push   %esi
f01039f1:	53                   	push   %ebx
f01039f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01039f5:	e8 ae 1f 00 00       	call   f01059a8 <cpunum>
f01039fa:	83 ec 04             	sub    $0x4,%esp
f01039fd:	50                   	push   %eax
f01039fe:	53                   	push   %ebx
f01039ff:	68 d5 72 10 f0       	push   $0xf01072d5
f0103a04:	e8 04 fe ff ff       	call   f010380d <cprintf>
	print_regs(&tf->tf_regs);
f0103a09:	89 1c 24             	mov    %ebx,(%esp)
f0103a0c:	e8 4e ff ff ff       	call   f010395f <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103a11:	83 c4 08             	add    $0x8,%esp
f0103a14:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103a18:	50                   	push   %eax
f0103a19:	68 f3 72 10 f0       	push   $0xf01072f3
f0103a1e:	e8 ea fd ff ff       	call   f010380d <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103a23:	83 c4 08             	add    $0x8,%esp
f0103a26:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103a2a:	50                   	push   %eax
f0103a2b:	68 06 73 10 f0       	push   $0xf0107306
f0103a30:	e8 d8 fd ff ff       	call   f010380d <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103a35:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0103a38:	83 c4 10             	add    $0x10,%esp
f0103a3b:	83 f8 13             	cmp    $0x13,%eax
f0103a3e:	0f 86 da 00 00 00    	jbe    f0103b1e <print_trapframe+0x131>
		return "System call";
f0103a44:	ba 80 72 10 f0       	mov    $0xf0107280,%edx
	if (trapno == T_SYSCALL)
f0103a49:	83 f8 30             	cmp    $0x30,%eax
f0103a4c:	74 13                	je     f0103a61 <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0103a4e:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0103a51:	83 fa 0f             	cmp    $0xf,%edx
f0103a54:	ba 8c 72 10 f0       	mov    $0xf010728c,%edx
f0103a59:	b9 9b 72 10 f0       	mov    $0xf010729b,%ecx
f0103a5e:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103a61:	83 ec 04             	sub    $0x4,%esp
f0103a64:	52                   	push   %edx
f0103a65:	50                   	push   %eax
f0103a66:	68 19 73 10 f0       	push   $0xf0107319
f0103a6b:	e8 9d fd ff ff       	call   f010380d <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103a70:	83 c4 10             	add    $0x10,%esp
f0103a73:	39 1d 80 ba 1e f0    	cmp    %ebx,0xf01eba80
f0103a79:	0f 84 ab 00 00 00    	je     f0103b2a <print_trapframe+0x13d>
	cprintf("  err  0x%08x", tf->tf_err);
f0103a7f:	83 ec 08             	sub    $0x8,%esp
f0103a82:	ff 73 2c             	push   0x2c(%ebx)
f0103a85:	68 3a 73 10 f0       	push   $0xf010733a
f0103a8a:	e8 7e fd ff ff       	call   f010380d <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103a8f:	83 c4 10             	add    $0x10,%esp
f0103a92:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103a96:	0f 85 b1 00 00 00    	jne    f0103b4d <print_trapframe+0x160>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103a9c:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103a9f:	a8 01                	test   $0x1,%al
f0103aa1:	b9 ae 72 10 f0       	mov    $0xf01072ae,%ecx
f0103aa6:	ba b9 72 10 f0       	mov    $0xf01072b9,%edx
f0103aab:	0f 44 ca             	cmove  %edx,%ecx
f0103aae:	a8 02                	test   $0x2,%al
f0103ab0:	ba c5 72 10 f0       	mov    $0xf01072c5,%edx
f0103ab5:	be cb 72 10 f0       	mov    $0xf01072cb,%esi
f0103aba:	0f 44 d6             	cmove  %esi,%edx
f0103abd:	a8 04                	test   $0x4,%al
f0103abf:	b8 d0 72 10 f0       	mov    $0xf01072d0,%eax
f0103ac4:	be 18 74 10 f0       	mov    $0xf0107418,%esi
f0103ac9:	0f 44 c6             	cmove  %esi,%eax
f0103acc:	51                   	push   %ecx
f0103acd:	52                   	push   %edx
f0103ace:	50                   	push   %eax
f0103acf:	68 48 73 10 f0       	push   $0xf0107348
f0103ad4:	e8 34 fd ff ff       	call   f010380d <cprintf>
f0103ad9:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103adc:	83 ec 08             	sub    $0x8,%esp
f0103adf:	ff 73 30             	push   0x30(%ebx)
f0103ae2:	68 57 73 10 f0       	push   $0xf0107357
f0103ae7:	e8 21 fd ff ff       	call   f010380d <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103aec:	83 c4 08             	add    $0x8,%esp
f0103aef:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103af3:	50                   	push   %eax
f0103af4:	68 66 73 10 f0       	push   $0xf0107366
f0103af9:	e8 0f fd ff ff       	call   f010380d <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103afe:	83 c4 08             	add    $0x8,%esp
f0103b01:	ff 73 38             	push   0x38(%ebx)
f0103b04:	68 79 73 10 f0       	push   $0xf0107379
f0103b09:	e8 ff fc ff ff       	call   f010380d <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103b0e:	83 c4 10             	add    $0x10,%esp
f0103b11:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103b15:	75 4b                	jne    f0103b62 <print_trapframe+0x175>
}
f0103b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103b1a:	5b                   	pop    %ebx
f0103b1b:	5e                   	pop    %esi
f0103b1c:	5d                   	pop    %ebp
f0103b1d:	c3                   	ret    
		return excnames[trapno];
f0103b1e:	8b 14 85 60 76 10 f0 	mov    -0xfef89a0(,%eax,4),%edx
f0103b25:	e9 37 ff ff ff       	jmp    f0103a61 <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103b2a:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103b2e:	0f 85 4b ff ff ff    	jne    f0103a7f <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103b34:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0103b37:	83 ec 08             	sub    $0x8,%esp
f0103b3a:	50                   	push   %eax
f0103b3b:	68 2b 73 10 f0       	push   $0xf010732b
f0103b40:	e8 c8 fc ff ff       	call   f010380d <cprintf>
f0103b45:	83 c4 10             	add    $0x10,%esp
f0103b48:	e9 32 ff ff ff       	jmp    f0103a7f <print_trapframe+0x92>
		cprintf("\n");
f0103b4d:	83 ec 0c             	sub    $0xc,%esp
f0103b50:	68 89 71 10 f0       	push   $0xf0107189
f0103b55:	e8 b3 fc ff ff       	call   f010380d <cprintf>
f0103b5a:	83 c4 10             	add    $0x10,%esp
f0103b5d:	e9 7a ff ff ff       	jmp    f0103adc <print_trapframe+0xef>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103b62:	83 ec 08             	sub    $0x8,%esp
f0103b65:	ff 73 3c             	push   0x3c(%ebx)
f0103b68:	68 88 73 10 f0       	push   $0xf0107388
f0103b6d:	e8 9b fc ff ff       	call   f010380d <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103b72:	83 c4 08             	add    $0x8,%esp
f0103b75:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103b79:	50                   	push   %eax
f0103b7a:	68 97 73 10 f0       	push   $0xf0107397
f0103b7f:	e8 89 fc ff ff       	call   f010380d <cprintf>
f0103b84:	83 c4 10             	add    $0x10,%esp
}
f0103b87:	eb 8e                	jmp    f0103b17 <print_trapframe+0x12a>

f0103b89 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103b89:	55                   	push   %ebp
f0103b8a:	89 e5                	mov    %esp,%ebp
f0103b8c:	57                   	push   %edi
f0103b8d:	56                   	push   %esi
f0103b8e:	53                   	push   %ebx
f0103b8f:	83 ec 0c             	sub    $0xc,%esp
f0103b92:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103b95:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if (!(tf->tf_cs & 3)) panic("Kernel Page Fault\n");
f0103b98:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103b9c:	74 5d                	je     f0103bfb <page_fault_handler+0x72>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if(curenv->env_pgfault_upcall)
f0103b9e:	e8 05 1e 00 00       	call   f01059a8 <cpunum>
f0103ba3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ba6:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103bac:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103bb0:	75 60                	jne    f0103c12 <page_fault_handler+0x89>
		curenv->env_tf.tf_esp = utf_addr;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103bb2:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0103bb5:	e8 ee 1d 00 00       	call   f01059a8 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103bba:	57                   	push   %edi
f0103bbb:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f0103bbc:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103bbf:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103bc5:	ff 70 48             	push   0x48(%eax)
f0103bc8:	68 64 75 10 f0       	push   $0xf0107564
f0103bcd:	e8 3b fc ff ff       	call   f010380d <cprintf>
	print_trapframe(tf);
f0103bd2:	89 1c 24             	mov    %ebx,(%esp)
f0103bd5:	e8 13 fe ff ff       	call   f01039ed <print_trapframe>
	env_destroy(curenv);
f0103bda:	e8 c9 1d 00 00       	call   f01059a8 <cpunum>
f0103bdf:	83 c4 04             	add    $0x4,%esp
f0103be2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103be5:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103beb:	e8 41 f9 ff ff       	call   f0103531 <env_destroy>
}
f0103bf0:	83 c4 10             	add    $0x10,%esp
f0103bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103bf6:	5b                   	pop    %ebx
f0103bf7:	5e                   	pop    %esi
f0103bf8:	5f                   	pop    %edi
f0103bf9:	5d                   	pop    %ebp
f0103bfa:	c3                   	ret    
	if (!(tf->tf_cs & 3)) panic("Kernel Page Fault\n");
f0103bfb:	83 ec 04             	sub    $0x4,%esp
f0103bfe:	68 aa 73 10 f0       	push   $0xf01073aa
f0103c03:	68 32 01 00 00       	push   $0x132
f0103c08:	68 bd 73 10 f0       	push   $0xf01073bd
f0103c0d:	e8 2e c4 ff ff       	call   f0100040 <_panic>
		if(UXSTACKTOP-PGSIZE <= tf->tf_esp && tf->tf_esp <= UXSTACKTOP-1)
f0103c12:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103c15:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf_addr = UXSTACKTOP - sizeof(struct UTrapframe);
f0103c1b:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if(UXSTACKTOP-PGSIZE <= tf->tf_esp && tf->tf_esp <= UXSTACKTOP-1)
f0103c20:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0103c26:	77 05                	ja     f0103c2d <page_fault_handler+0xa4>
			utf_addr = tf->tf_esp - sizeof(struct UTrapframe) - 4;
f0103c28:	83 e8 38             	sub    $0x38,%eax
f0103c2b:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf_addr, 1, PTE_W); //check if curenv can write to it.
f0103c2d:	e8 76 1d 00 00       	call   f01059a8 <cpunum>
f0103c32:	6a 02                	push   $0x2
f0103c34:	6a 01                	push   $0x1
f0103c36:	57                   	push   %edi
f0103c37:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c3a:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103c40:	e8 cf f2 ff ff       	call   f0102f14 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0103c45:	89 fa                	mov    %edi,%edx
f0103c47:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0103c49:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0103c4c:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0103c4f:	8d 7f 08             	lea    0x8(%edi),%edi
f0103c52:	b9 08 00 00 00       	mov    $0x8,%ecx
f0103c57:	89 de                	mov    %ebx,%esi
f0103c59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0103c5b:	8b 43 30             	mov    0x30(%ebx),%eax
f0103c5e:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0103c61:	8b 43 38             	mov    0x38(%ebx),%eax
f0103c64:	89 d7                	mov    %edx,%edi
f0103c66:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0103c69:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103c6c:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0103c6f:	e8 34 1d 00 00       	call   f01059a8 <cpunum>
f0103c74:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c77:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103c7d:	8b 58 64             	mov    0x64(%eax),%ebx
f0103c80:	e8 23 1d 00 00       	call   f01059a8 <cpunum>
f0103c85:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c88:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103c8e:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = utf_addr;
f0103c91:	e8 12 1d 00 00       	call   f01059a8 <cpunum>
f0103c96:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c99:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103c9f:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0103ca2:	e8 01 1d 00 00       	call   f01059a8 <cpunum>
f0103ca7:	83 c4 04             	add    $0x4,%esp
f0103caa:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cad:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103cb3:	e8 18 f9 ff ff       	call   f01035d0 <env_run>

f0103cb8 <trap>:
{
f0103cb8:	55                   	push   %ebp
f0103cb9:	89 e5                	mov    %esp,%ebp
f0103cbb:	57                   	push   %edi
f0103cbc:	56                   	push   %esi
f0103cbd:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0103cc0:	fc                   	cld    
	if (panicstr)
f0103cc1:	83 3d 00 b0 1e f0 00 	cmpl   $0x0,0xf01eb000
f0103cc8:	74 01                	je     f0103ccb <trap+0x13>
		asm volatile("hlt");
f0103cca:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0103ccb:	e8 d8 1c 00 00       	call   f01059a8 <cpunum>
f0103cd0:	6b d0 74             	imul   $0x74,%eax,%edx
f0103cd3:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0103cd6:	b8 01 00 00 00       	mov    $0x1,%eax
f0103cdb:	f0 87 82 20 c0 22 f0 	lock xchg %eax,-0xfdd3fe0(%edx)
f0103ce2:	83 f8 02             	cmp    $0x2,%eax
f0103ce5:	74 30                	je     f0103d17 <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0103ce7:	9c                   	pushf  
f0103ce8:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0103ce9:	f6 c4 02             	test   $0x2,%ah
f0103cec:	75 3b                	jne    f0103d29 <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0103cee:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103cf2:	83 e0 03             	and    $0x3,%eax
f0103cf5:	66 83 f8 03          	cmp    $0x3,%ax
f0103cf9:	74 47                	je     f0103d42 <trap+0x8a>
	last_tf = tf;
f0103cfb:	89 35 80 ba 1e f0    	mov    %esi,0xf01eba80
	switch (tf->tf_trapno) {
f0103d01:	8b 56 28             	mov    0x28(%esi),%edx
f0103d04:	8d 42 fd             	lea    -0x3(%edx),%eax
f0103d07:	83 f8 2d             	cmp    $0x2d,%eax
f0103d0a:	0f 87 58 01 00 00    	ja     f0103e68 <trap+0x1b0>
f0103d10:	ff 24 85 a0 75 10 f0 	jmp    *-0xfef8a60(,%eax,4)
	spin_lock(&kernel_lock);
f0103d17:	83 ec 0c             	sub    $0xc,%esp
f0103d1a:	68 80 44 12 f0       	push   $0xf0124480
f0103d1f:	e8 f4 1e 00 00       	call   f0105c18 <spin_lock>
}
f0103d24:	83 c4 10             	add    $0x10,%esp
f0103d27:	eb be                	jmp    f0103ce7 <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f0103d29:	68 c9 73 10 f0       	push   $0xf01073c9
f0103d2e:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0103d33:	68 fd 00 00 00       	push   $0xfd
f0103d38:	68 bd 73 10 f0       	push   $0xf01073bd
f0103d3d:	e8 fe c2 ff ff       	call   f0100040 <_panic>
		assert(curenv);
f0103d42:	e8 61 1c 00 00       	call   f01059a8 <cpunum>
f0103d47:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d4a:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f0103d51:	74 4e                	je     f0103da1 <trap+0xe9>
	spin_lock(&kernel_lock);
f0103d53:	83 ec 0c             	sub    $0xc,%esp
f0103d56:	68 80 44 12 f0       	push   $0xf0124480
f0103d5b:	e8 b8 1e 00 00       	call   f0105c18 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f0103d60:	e8 43 1c 00 00       	call   f01059a8 <cpunum>
f0103d65:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d68:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103d6e:	83 c4 10             	add    $0x10,%esp
f0103d71:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103d75:	74 43                	je     f0103dba <trap+0x102>
		curenv->env_tf = *tf;
f0103d77:	e8 2c 1c 00 00       	call   f01059a8 <cpunum>
f0103d7c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d7f:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103d85:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103d8a:	89 c7                	mov    %eax,%edi
f0103d8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0103d8e:	e8 15 1c 00 00       	call   f01059a8 <cpunum>
f0103d93:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d96:	8b b0 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%esi
f0103d9c:	e9 5a ff ff ff       	jmp    f0103cfb <trap+0x43>
		assert(curenv);
f0103da1:	68 e2 73 10 f0       	push   $0xf01073e2
f0103da6:	68 a7 6e 10 f0       	push   $0xf0106ea7
f0103dab:	68 04 01 00 00       	push   $0x104
f0103db0:	68 bd 73 10 f0       	push   $0xf01073bd
f0103db5:	e8 86 c2 ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f0103dba:	e8 e9 1b 00 00       	call   f01059a8 <cpunum>
f0103dbf:	83 ec 0c             	sub    $0xc,%esp
f0103dc2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dc5:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103dcb:	e8 b7 f5 ff ff       	call   f0103387 <env_free>
			curenv = NULL;
f0103dd0:	e8 d3 1b 00 00       	call   f01059a8 <cpunum>
f0103dd5:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dd8:	c7 80 28 c0 22 f0 00 	movl   $0x0,-0xfdd3fd8(%eax)
f0103ddf:	00 00 00 
			sched_yield();
f0103de2:	e8 5e 03 00 00       	call   f0104145 <sched_yield>
		page_fault_handler(tf);
f0103de7:	83 ec 0c             	sub    $0xc,%esp
f0103dea:	56                   	push   %esi
f0103deb:	e8 99 fd ff ff       	call   f0103b89 <page_fault_handler>
		return;
f0103df0:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0103df3:	e8 b0 1b 00 00       	call   f01059a8 <cpunum>
f0103df8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dfb:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f0103e02:	74 18                	je     f0103e1c <trap+0x164>
f0103e04:	e8 9f 1b 00 00       	call   f01059a8 <cpunum>
f0103e09:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e0c:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0103e12:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103e16:	0f 84 b6 00 00 00    	je     f0103ed2 <trap+0x21a>
		sched_yield();
f0103e1c:	e8 24 03 00 00       	call   f0104145 <sched_yield>
		monitor(tf);
f0103e21:	83 ec 0c             	sub    $0xc,%esp
f0103e24:	56                   	push   %esi
f0103e25:	e8 b7 ca ff ff       	call   f01008e1 <monitor>
		return;
f0103e2a:	83 c4 10             	add    $0x10,%esp
f0103e2d:	eb c4                	jmp    f0103df3 <trap+0x13b>
		tf->tf_regs.reg_eax = syscall(
f0103e2f:	83 ec 08             	sub    $0x8,%esp
f0103e32:	ff 76 04             	push   0x4(%esi)
f0103e35:	ff 36                	push   (%esi)
f0103e37:	ff 76 10             	push   0x10(%esi)
f0103e3a:	ff 76 18             	push   0x18(%esi)
f0103e3d:	ff 76 14             	push   0x14(%esi)
f0103e40:	ff 76 1c             	push   0x1c(%esi)
f0103e43:	e8 af 03 00 00       	call   f01041f7 <syscall>
f0103e48:	89 46 1c             	mov    %eax,0x1c(%esi)
		return;
f0103e4b:	83 c4 20             	add    $0x20,%esp
f0103e4e:	eb a3                	jmp    f0103df3 <trap+0x13b>
		lapic_eoi();
f0103e50:	e8 9a 1c 00 00       	call   f0105aef <lapic_eoi>
		sched_yield();
f0103e55:	e8 eb 02 00 00       	call   f0104145 <sched_yield>
		kbd_intr();
f0103e5a:	e8 8a c7 ff ff       	call   f01005e9 <kbd_intr>
		return;
f0103e5f:	eb 92                	jmp    f0103df3 <trap+0x13b>
		serial_intr();
f0103e61:	e8 67 c7 ff ff       	call   f01005cd <serial_intr>
		return;
f0103e66:	eb 8b                	jmp    f0103df3 <trap+0x13b>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0103e68:	83 fa 27             	cmp    $0x27,%edx
f0103e6b:	74 31                	je     f0103e9e <trap+0x1e6>
	print_trapframe(tf);
f0103e6d:	83 ec 0c             	sub    $0xc,%esp
f0103e70:	56                   	push   %esi
f0103e71:	e8 77 fb ff ff       	call   f01039ed <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0103e76:	83 c4 10             	add    $0x10,%esp
f0103e79:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0103e7e:	74 3b                	je     f0103ebb <trap+0x203>
		env_destroy(curenv);
f0103e80:	e8 23 1b 00 00       	call   f01059a8 <cpunum>
f0103e85:	83 ec 0c             	sub    $0xc,%esp
f0103e88:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e8b:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103e91:	e8 9b f6 ff ff       	call   f0103531 <env_destroy>
		return;
f0103e96:	83 c4 10             	add    $0x10,%esp
f0103e99:	e9 55 ff ff ff       	jmp    f0103df3 <trap+0x13b>
		cprintf("Spurious interrupt on irq 7\n");
f0103e9e:	83 ec 0c             	sub    $0xc,%esp
f0103ea1:	68 e9 73 10 f0       	push   $0xf01073e9
f0103ea6:	e8 62 f9 ff ff       	call   f010380d <cprintf>
		print_trapframe(tf);
f0103eab:	89 34 24             	mov    %esi,(%esp)
f0103eae:	e8 3a fb ff ff       	call   f01039ed <print_trapframe>
		return;
f0103eb3:	83 c4 10             	add    $0x10,%esp
f0103eb6:	e9 38 ff ff ff       	jmp    f0103df3 <trap+0x13b>
		panic("unhandled trap in kernel");
f0103ebb:	83 ec 04             	sub    $0x4,%esp
f0103ebe:	68 06 74 10 f0       	push   $0xf0107406
f0103ec3:	68 e3 00 00 00       	push   $0xe3
f0103ec8:	68 bd 73 10 f0       	push   $0xf01073bd
f0103ecd:	e8 6e c1 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0103ed2:	e8 d1 1a 00 00       	call   f01059a8 <cpunum>
f0103ed7:	83 ec 0c             	sub    $0xc,%esp
f0103eda:	6b c0 74             	imul   $0x74,%eax,%eax
f0103edd:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0103ee3:	e8 e8 f6 ff ff       	call   f01035d0 <env_run>

f0103ee8 <v0>:
 */
.data
	.globl vector

vector:
	TRAPHANDLER_NOEC(v0, 0)
f0103ee8:	6a 00                	push   $0x0
f0103eea:	6a 00                	push   $0x0
f0103eec:	e9 7b 01 00 00       	jmp    f010406c <_alltraps>
f0103ef1:	90                   	nop

f0103ef2 <v1>:
	TRAPHANDLER_NOEC(v1, 1)
f0103ef2:	6a 00                	push   $0x0
f0103ef4:	6a 01                	push   $0x1
f0103ef6:	e9 71 01 00 00       	jmp    f010406c <_alltraps>
f0103efb:	90                   	nop

f0103efc <v2>:
	TRAPHANDLER_NOEC(v2, 2)
f0103efc:	6a 00                	push   $0x0
f0103efe:	6a 02                	push   $0x2
f0103f00:	e9 67 01 00 00       	jmp    f010406c <_alltraps>
f0103f05:	90                   	nop

f0103f06 <v3>:
	TRAPHANDLER_NOEC(v3, 3)
f0103f06:	6a 00                	push   $0x0
f0103f08:	6a 03                	push   $0x3
f0103f0a:	e9 5d 01 00 00       	jmp    f010406c <_alltraps>
f0103f0f:	90                   	nop

f0103f10 <v4>:
	TRAPHANDLER_NOEC(v4, 4)
f0103f10:	6a 00                	push   $0x0
f0103f12:	6a 04                	push   $0x4
f0103f14:	e9 53 01 00 00       	jmp    f010406c <_alltraps>
f0103f19:	90                   	nop

f0103f1a <v5>:
	TRAPHANDLER_NOEC(v5, 5)
f0103f1a:	6a 00                	push   $0x0
f0103f1c:	6a 05                	push   $0x5
f0103f1e:	e9 49 01 00 00       	jmp    f010406c <_alltraps>
f0103f23:	90                   	nop

f0103f24 <v6>:
	TRAPHANDLER_NOEC(v6, 6)
f0103f24:	6a 00                	push   $0x0
f0103f26:	6a 06                	push   $0x6
f0103f28:	e9 3f 01 00 00       	jmp    f010406c <_alltraps>
f0103f2d:	90                   	nop

f0103f2e <v7>:
	TRAPHANDLER_NOEC(v7, 7)
f0103f2e:	6a 00                	push   $0x0
f0103f30:	6a 07                	push   $0x7
f0103f32:	e9 35 01 00 00       	jmp    f010406c <_alltraps>
f0103f37:	90                   	nop

f0103f38 <v8>:
	TRAPHANDLER(v8, 8)
f0103f38:	6a 08                	push   $0x8
f0103f3a:	e9 2d 01 00 00       	jmp    f010406c <_alltraps>
f0103f3f:	90                   	nop

f0103f40 <v9>:
	TRAPHANDLER_NOEC(v9, 9)
f0103f40:	6a 00                	push   $0x0
f0103f42:	6a 09                	push   $0x9
f0103f44:	e9 23 01 00 00       	jmp    f010406c <_alltraps>
f0103f49:	90                   	nop

f0103f4a <v10>:
	TRAPHANDLER(v10, 10)
f0103f4a:	6a 0a                	push   $0xa
f0103f4c:	e9 1b 01 00 00       	jmp    f010406c <_alltraps>
f0103f51:	90                   	nop

f0103f52 <v11>:
	TRAPHANDLER(v11, 11)
f0103f52:	6a 0b                	push   $0xb
f0103f54:	e9 13 01 00 00       	jmp    f010406c <_alltraps>
f0103f59:	90                   	nop

f0103f5a <v12>:
	TRAPHANDLER(v12, 12)
f0103f5a:	6a 0c                	push   $0xc
f0103f5c:	e9 0b 01 00 00       	jmp    f010406c <_alltraps>
f0103f61:	90                   	nop

f0103f62 <v13>:
	TRAPHANDLER(v13, 13)
f0103f62:	6a 0d                	push   $0xd
f0103f64:	e9 03 01 00 00       	jmp    f010406c <_alltraps>
f0103f69:	90                   	nop

f0103f6a <v14>:
	TRAPHANDLER(v14, 14)
f0103f6a:	6a 0e                	push   $0xe
f0103f6c:	e9 fb 00 00 00       	jmp    f010406c <_alltraps>
f0103f71:	90                   	nop

f0103f72 <v15>:
	TRAPHANDLER_NOEC(v15, 15)
f0103f72:	6a 00                	push   $0x0
f0103f74:	6a 0f                	push   $0xf
f0103f76:	e9 f1 00 00 00       	jmp    f010406c <_alltraps>
f0103f7b:	90                   	nop

f0103f7c <v16>:
	TRAPHANDLER_NOEC(v16, 16)
f0103f7c:	6a 00                	push   $0x0
f0103f7e:	6a 10                	push   $0x10
f0103f80:	e9 e7 00 00 00       	jmp    f010406c <_alltraps>
f0103f85:	90                   	nop

f0103f86 <v17>:
	TRAPHANDLER(v17, 17)
f0103f86:	6a 11                	push   $0x11
f0103f88:	e9 df 00 00 00       	jmp    f010406c <_alltraps>
f0103f8d:	90                   	nop

f0103f8e <v18>:
	TRAPHANDLER_NOEC(v18, 18)
f0103f8e:	6a 00                	push   $0x0
f0103f90:	6a 12                	push   $0x12
f0103f92:	e9 d5 00 00 00       	jmp    f010406c <_alltraps>
f0103f97:	90                   	nop

f0103f98 <v19>:
	TRAPHANDLER_NOEC(v19, 19)
f0103f98:	6a 00                	push   $0x0
f0103f9a:	6a 13                	push   $0x13
f0103f9c:	e9 cb 00 00 00       	jmp    f010406c <_alltraps>
f0103fa1:	90                   	nop

f0103fa2 <v20>:
	TRAPHANDLER_NOEC(v20, 20)
f0103fa2:	6a 00                	push   $0x0
f0103fa4:	6a 14                	push   $0x14
f0103fa6:	e9 c1 00 00 00       	jmp    f010406c <_alltraps>
f0103fab:	90                   	nop

f0103fac <v21>:
	TRAPHANDLER_NOEC(v21, 21)
f0103fac:	6a 00                	push   $0x0
f0103fae:	6a 15                	push   $0x15
f0103fb0:	e9 b7 00 00 00       	jmp    f010406c <_alltraps>
f0103fb5:	90                   	nop

f0103fb6 <v22>:
	TRAPHANDLER_NOEC(v22, 22)
f0103fb6:	6a 00                	push   $0x0
f0103fb8:	6a 16                	push   $0x16
f0103fba:	e9 ad 00 00 00       	jmp    f010406c <_alltraps>
f0103fbf:	90                   	nop

f0103fc0 <v23>:
	TRAPHANDLER_NOEC(v23, 23)
f0103fc0:	6a 00                	push   $0x0
f0103fc2:	6a 17                	push   $0x17
f0103fc4:	e9 a3 00 00 00       	jmp    f010406c <_alltraps>
f0103fc9:	90                   	nop

f0103fca <v24>:
	TRAPHANDLER_NOEC(v24, 24)
f0103fca:	6a 00                	push   $0x0
f0103fcc:	6a 18                	push   $0x18
f0103fce:	e9 99 00 00 00       	jmp    f010406c <_alltraps>
f0103fd3:	90                   	nop

f0103fd4 <v25>:
	TRAPHANDLER_NOEC(v25, 25)
f0103fd4:	6a 00                	push   $0x0
f0103fd6:	6a 19                	push   $0x19
f0103fd8:	e9 8f 00 00 00       	jmp    f010406c <_alltraps>
f0103fdd:	90                   	nop

f0103fde <v26>:
	TRAPHANDLER_NOEC(v26, 26)
f0103fde:	6a 00                	push   $0x0
f0103fe0:	6a 1a                	push   $0x1a
f0103fe2:	e9 85 00 00 00       	jmp    f010406c <_alltraps>
f0103fe7:	90                   	nop

f0103fe8 <v27>:
	TRAPHANDLER_NOEC(v27, 27)
f0103fe8:	6a 00                	push   $0x0
f0103fea:	6a 1b                	push   $0x1b
f0103fec:	eb 7e                	jmp    f010406c <_alltraps>

f0103fee <v28>:
	TRAPHANDLER_NOEC(v28, 28)
f0103fee:	6a 00                	push   $0x0
f0103ff0:	6a 1c                	push   $0x1c
f0103ff2:	eb 78                	jmp    f010406c <_alltraps>

f0103ff4 <v29>:
	TRAPHANDLER_NOEC(v29, 29)
f0103ff4:	6a 00                	push   $0x0
f0103ff6:	6a 1d                	push   $0x1d
f0103ff8:	eb 72                	jmp    f010406c <_alltraps>

f0103ffa <v30>:
	TRAPHANDLER_NOEC(v30, 30)
f0103ffa:	6a 00                	push   $0x0
f0103ffc:	6a 1e                	push   $0x1e
f0103ffe:	eb 6c                	jmp    f010406c <_alltraps>

f0104000 <v31>:
	TRAPHANDLER_NOEC(v31, 31)
f0104000:	6a 00                	push   $0x0
f0104002:	6a 1f                	push   $0x1f
f0104004:	eb 66                	jmp    f010406c <_alltraps>

f0104006 <v32>:
	TRAPHANDLER_NOEC(v32, 32)
f0104006:	6a 00                	push   $0x0
f0104008:	6a 20                	push   $0x20
f010400a:	eb 60                	jmp    f010406c <_alltraps>

f010400c <v33>:
	TRAPHANDLER_NOEC(v33, 33)
f010400c:	6a 00                	push   $0x0
f010400e:	6a 21                	push   $0x21
f0104010:	eb 5a                	jmp    f010406c <_alltraps>

f0104012 <v34>:
	TRAPHANDLER_NOEC(v34, 34)
f0104012:	6a 00                	push   $0x0
f0104014:	6a 22                	push   $0x22
f0104016:	eb 54                	jmp    f010406c <_alltraps>

f0104018 <v35>:
	TRAPHANDLER_NOEC(v35, 35)
f0104018:	6a 00                	push   $0x0
f010401a:	6a 23                	push   $0x23
f010401c:	eb 4e                	jmp    f010406c <_alltraps>

f010401e <v36>:
	TRAPHANDLER_NOEC(v36, 36)
f010401e:	6a 00                	push   $0x0
f0104020:	6a 24                	push   $0x24
f0104022:	eb 48                	jmp    f010406c <_alltraps>

f0104024 <v37>:
	TRAPHANDLER_NOEC(v37, 37)
f0104024:	6a 00                	push   $0x0
f0104026:	6a 25                	push   $0x25
f0104028:	eb 42                	jmp    f010406c <_alltraps>

f010402a <v38>:
	TRAPHANDLER_NOEC(v38, 38)
f010402a:	6a 00                	push   $0x0
f010402c:	6a 26                	push   $0x26
f010402e:	eb 3c                	jmp    f010406c <_alltraps>

f0104030 <v39>:
	TRAPHANDLER_NOEC(v39, 39)
f0104030:	6a 00                	push   $0x0
f0104032:	6a 27                	push   $0x27
f0104034:	eb 36                	jmp    f010406c <_alltraps>

f0104036 <v40>:
	TRAPHANDLER_NOEC(v40, 40)
f0104036:	6a 00                	push   $0x0
f0104038:	6a 28                	push   $0x28
f010403a:	eb 30                	jmp    f010406c <_alltraps>

f010403c <v41>:
	TRAPHANDLER_NOEC(v41, 41)
f010403c:	6a 00                	push   $0x0
f010403e:	6a 29                	push   $0x29
f0104040:	eb 2a                	jmp    f010406c <_alltraps>

f0104042 <v42>:
	TRAPHANDLER_NOEC(v42, 42)
f0104042:	6a 00                	push   $0x0
f0104044:	6a 2a                	push   $0x2a
f0104046:	eb 24                	jmp    f010406c <_alltraps>

f0104048 <v43>:
	TRAPHANDLER_NOEC(v43, 43)
f0104048:	6a 00                	push   $0x0
f010404a:	6a 2b                	push   $0x2b
f010404c:	eb 1e                	jmp    f010406c <_alltraps>

f010404e <v44>:
	TRAPHANDLER_NOEC(v44, 44)
f010404e:	6a 00                	push   $0x0
f0104050:	6a 2c                	push   $0x2c
f0104052:	eb 18                	jmp    f010406c <_alltraps>

f0104054 <v45>:
	TRAPHANDLER_NOEC(v45, 45)
f0104054:	6a 00                	push   $0x0
f0104056:	6a 2d                	push   $0x2d
f0104058:	eb 12                	jmp    f010406c <_alltraps>

f010405a <v46>:
	TRAPHANDLER_NOEC(v46, 46)
f010405a:	6a 00                	push   $0x0
f010405c:	6a 2e                	push   $0x2e
f010405e:	eb 0c                	jmp    f010406c <_alltraps>

f0104060 <v47>:
	TRAPHANDLER_NOEC(v47, 47)
f0104060:	6a 00                	push   $0x0
f0104062:	6a 2f                	push   $0x2f
f0104064:	eb 06                	jmp    f010406c <_alltraps>

f0104066 <v48>:
	TRAPHANDLER_NOEC(v48, 48)
f0104066:	6a 00                	push   $0x0
f0104068:	6a 30                	push   $0x30
f010406a:	eb 00                	jmp    f010406c <_alltraps>

f010406c <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
.text
_alltraps:
	pushl %ds
f010406c:	1e                   	push   %ds
	pushl %es
f010406d:	06                   	push   %es
	pushal
f010406e:	60                   	pusha  
	pushl $GD_KD
f010406f:	6a 10                	push   $0x10
	popl %ds
f0104071:	1f                   	pop    %ds
	pushl $GD_KD
f0104072:	6a 10                	push   $0x10
	popl %es
f0104074:	07                   	pop    %es
	pushl %esp
f0104075:	54                   	push   %esp
	call trap
f0104076:	e8 3d fc ff ff       	call   f0103cb8 <trap>

f010407b <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f010407b:	55                   	push   %ebp
f010407c:	89 e5                	mov    %esp,%ebp
f010407e:	83 ec 08             	sub    $0x8,%esp
f0104081:	a1 74 b2 1e f0       	mov    0xf01eb274,%eax
f0104086:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104089:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f010408e:	8b 02                	mov    (%edx),%eax
f0104090:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104093:	83 f8 02             	cmp    $0x2,%eax
f0104096:	76 2d                	jbe    f01040c5 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f0104098:	83 c1 01             	add    $0x1,%ecx
f010409b:	83 c2 7c             	add    $0x7c,%edx
f010409e:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01040a4:	75 e8                	jne    f010408e <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01040a6:	83 ec 0c             	sub    $0xc,%esp
f01040a9:	68 b0 76 10 f0       	push   $0xf01076b0
f01040ae:	e8 5a f7 ff ff       	call   f010380d <cprintf>
f01040b3:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01040b6:	83 ec 0c             	sub    $0xc,%esp
f01040b9:	6a 00                	push   $0x0
f01040bb:	e8 21 c8 ff ff       	call   f01008e1 <monitor>
f01040c0:	83 c4 10             	add    $0x10,%esp
f01040c3:	eb f1                	jmp    f01040b6 <sched_halt+0x3b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01040c5:	e8 de 18 00 00       	call   f01059a8 <cpunum>
f01040ca:	6b c0 74             	imul   $0x74,%eax,%eax
f01040cd:	c7 80 28 c0 22 f0 00 	movl   $0x0,-0xfdd3fd8(%eax)
f01040d4:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01040d7:	a1 5c b2 1e f0       	mov    0xf01eb25c,%eax
	if ((uint32_t)kva < KERNBASE)
f01040dc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01040e1:	76 50                	jbe    f0104133 <sched_halt+0xb8>
	return (physaddr_t)kva - KERNBASE;
f01040e3:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01040e8:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01040eb:	e8 b8 18 00 00       	call   f01059a8 <cpunum>
f01040f0:	6b d0 74             	imul   $0x74,%eax,%edx
f01040f3:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01040f6:	b8 02 00 00 00       	mov    $0x2,%eax
f01040fb:	f0 87 82 20 c0 22 f0 	lock xchg %eax,-0xfdd3fe0(%edx)
	spin_unlock(&kernel_lock);
f0104102:	83 ec 0c             	sub    $0xc,%esp
f0104105:	68 80 44 12 f0       	push   $0xf0124480
f010410a:	e8 a3 1b 00 00       	call   f0105cb2 <spin_unlock>
	asm volatile("pause");
f010410f:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104111:	e8 92 18 00 00       	call   f01059a8 <cpunum>
f0104116:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104119:	8b 80 30 c0 22 f0    	mov    -0xfdd3fd0(%eax),%eax
f010411f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104124:	89 c4                	mov    %eax,%esp
f0104126:	6a 00                	push   $0x0
f0104128:	6a 00                	push   $0x0
f010412a:	fb                   	sti    
f010412b:	f4                   	hlt    
f010412c:	eb fd                	jmp    f010412b <sched_halt+0xb0>
}
f010412e:	83 c4 10             	add    $0x10,%esp
f0104131:	c9                   	leave  
f0104132:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104133:	50                   	push   %eax
f0104134:	68 28 60 10 f0       	push   $0xf0106028
f0104139:	6a 45                	push   $0x45
f010413b:	68 d9 76 10 f0       	push   $0xf01076d9
f0104140:	e8 fb be ff ff       	call   f0100040 <_panic>

f0104145 <sched_yield>:
{
f0104145:	55                   	push   %ebp
f0104146:	89 e5                	mov    %esp,%ebp
f0104148:	56                   	push   %esi
f0104149:	53                   	push   %ebx
	int index = curenv ? ENVX(curenv->env_id) : 0;
f010414a:	e8 59 18 00 00       	call   f01059a8 <cpunum>
f010414f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104152:	ba 00 00 00 00       	mov    $0x0,%edx
f0104157:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f010415e:	74 17                	je     f0104177 <sched_yield+0x32>
f0104160:	e8 43 18 00 00       	call   f01059a8 <cpunum>
f0104165:	6b c0 74             	imul   $0x74,%eax,%eax
f0104168:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f010416e:	8b 50 48             	mov    0x48(%eax),%edx
f0104171:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
		if (envs[i % NENV].env_status == ENV_RUNNABLE) {
f0104177:	8b 0d 74 b2 1e f0    	mov    0xf01eb274,%ecx
f010417d:	8d 9a 00 04 00 00    	lea    0x400(%edx),%ebx
f0104183:	89 d6                	mov    %edx,%esi
f0104185:	c1 fe 1f             	sar    $0x1f,%esi
f0104188:	c1 ee 16             	shr    $0x16,%esi
f010418b:	8d 04 32             	lea    (%edx,%esi,1),%eax
f010418e:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104193:	29 f0                	sub    %esi,%eax
f0104195:	6b c0 7c             	imul   $0x7c,%eax,%eax
f0104198:	01 c8                	add    %ecx,%eax
f010419a:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010419e:	74 38                	je     f01041d8 <sched_yield+0x93>
	for (int i = index; i < index + NENV; i++) {
f01041a0:	83 c2 01             	add    $0x1,%edx
f01041a3:	39 da                	cmp    %ebx,%edx
f01041a5:	75 dc                	jne    f0104183 <sched_yield+0x3e>
	if (curenv && curenv->env_status == ENV_RUNNING) env_run(curenv);
f01041a7:	e8 fc 17 00 00       	call   f01059a8 <cpunum>
f01041ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01041af:	83 b8 28 c0 22 f0 00 	cmpl   $0x0,-0xfdd3fd8(%eax)
f01041b6:	74 14                	je     f01041cc <sched_yield+0x87>
f01041b8:	e8 eb 17 00 00       	call   f01059a8 <cpunum>
f01041bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01041c0:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f01041c6:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01041ca:	74 15                	je     f01041e1 <sched_yield+0x9c>
	sched_halt();
f01041cc:	e8 aa fe ff ff       	call   f010407b <sched_halt>
}
f01041d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01041d4:	5b                   	pop    %ebx
f01041d5:	5e                   	pop    %esi
f01041d6:	5d                   	pop    %ebp
f01041d7:	c3                   	ret    
			env_run(&envs[i % NENV]);
f01041d8:	83 ec 0c             	sub    $0xc,%esp
f01041db:	50                   	push   %eax
f01041dc:	e8 ef f3 ff ff       	call   f01035d0 <env_run>
	if (curenv && curenv->env_status == ENV_RUNNING) env_run(curenv);
f01041e1:	e8 c2 17 00 00       	call   f01059a8 <cpunum>
f01041e6:	83 ec 0c             	sub    $0xc,%esp
f01041e9:	6b c0 74             	imul   $0x74,%eax,%eax
f01041ec:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f01041f2:	e8 d9 f3 ff ff       	call   f01035d0 <env_run>

f01041f7 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01041f7:	55                   	push   %ebp
f01041f8:	89 e5                	mov    %esp,%ebp
f01041fa:	57                   	push   %edi
f01041fb:	56                   	push   %esi
f01041fc:	53                   	push   %ebx
f01041fd:	83 ec 1c             	sub    $0x1c,%esp
f0104200:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {
f0104203:	83 f8 0d             	cmp    $0xd,%eax
f0104206:	0f 87 9a 05 00 00    	ja     f01047a6 <syscall+0x5af>
f010420c:	ff 24 85 28 77 10 f0 	jmp    *-0xfef88d8(,%eax,4)
	if(curenv->env_tf.tf_cs & 3)
f0104213:	e8 90 17 00 00       	call   f01059a8 <cpunum>
f0104218:	6b c0 74             	imul   $0x74,%eax,%eax
f010421b:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0104221:	f6 40 34 03          	testb  $0x3,0x34(%eax)
f0104225:	75 25                	jne    f010424c <syscall+0x55>
	cprintf("%.*s", len, s);
f0104227:	83 ec 04             	sub    $0x4,%esp
f010422a:	ff 75 0c             	push   0xc(%ebp)
f010422d:	ff 75 10             	push   0x10(%ebp)
f0104230:	68 e6 76 10 f0       	push   $0xf01076e6
f0104235:	e8 d3 f5 ff ff       	call   f010380d <cprintf>
}
f010423a:	83 c4 10             	add    $0x10,%esp
	case SYS_cputs:
		sys_cputs((const char *)a1, a2);
		return 0;
f010423d:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
	case NSYSCALLS:
	default:
		return -E_INVAL;
	}
}
f0104242:	89 d8                	mov    %ebx,%eax
f0104244:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104247:	5b                   	pop    %ebx
f0104248:	5e                   	pop    %esi
f0104249:	5f                   	pop    %edi
f010424a:	5d                   	pop    %ebp
f010424b:	c3                   	ret    
		user_mem_assert(curenv, s, len, 0);
f010424c:	e8 57 17 00 00       	call   f01059a8 <cpunum>
f0104251:	6a 00                	push   $0x0
f0104253:	ff 75 10             	push   0x10(%ebp)
f0104256:	ff 75 0c             	push   0xc(%ebp)
f0104259:	6b c0 74             	imul   $0x74,%eax,%eax
f010425c:	ff b0 28 c0 22 f0    	push   -0xfdd3fd8(%eax)
f0104262:	e8 ad ec ff ff       	call   f0102f14 <user_mem_assert>
f0104267:	83 c4 10             	add    $0x10,%esp
f010426a:	eb bb                	jmp    f0104227 <syscall+0x30>
	return cons_getc();
f010426c:	e8 8a c3 ff ff       	call   f01005fb <cons_getc>
f0104271:	89 c3                	mov    %eax,%ebx
		return sys_cgetc();
f0104273:	eb cd                	jmp    f0104242 <syscall+0x4b>
	return curenv->env_id;
f0104275:	e8 2e 17 00 00       	call   f01059a8 <cpunum>
f010427a:	6b c0 74             	imul   $0x74,%eax,%eax
f010427d:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0104283:	8b 58 48             	mov    0x48(%eax),%ebx
		return sys_getenvid();
f0104286:	eb ba                	jmp    f0104242 <syscall+0x4b>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104288:	83 ec 04             	sub    $0x4,%esp
f010428b:	6a 01                	push   $0x1
f010428d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104290:	50                   	push   %eax
f0104291:	ff 75 0c             	push   0xc(%ebp)
f0104294:	e8 36 ed ff ff       	call   f0102fcf <envid2env>
f0104299:	89 c3                	mov    %eax,%ebx
f010429b:	83 c4 10             	add    $0x10,%esp
f010429e:	85 c0                	test   %eax,%eax
f01042a0:	78 a0                	js     f0104242 <syscall+0x4b>
	env_destroy(e);
f01042a2:	83 ec 0c             	sub    $0xc,%esp
f01042a5:	ff 75 e4             	push   -0x1c(%ebp)
f01042a8:	e8 84 f2 ff ff       	call   f0103531 <env_destroy>
	return 0;
f01042ad:	83 c4 10             	add    $0x10,%esp
f01042b0:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_destroy(a1);
f01042b5:	eb 8b                	jmp    f0104242 <syscall+0x4b>
	sched_yield();
f01042b7:	e8 89 fe ff ff       	call   f0104145 <sched_yield>
	if ((err = env_alloc(&e, curenv->env_id)) < 0) return err;
f01042bc:	e8 e7 16 00 00       	call   f01059a8 <cpunum>
f01042c1:	83 ec 08             	sub    $0x8,%esp
f01042c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01042c7:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f01042cd:	ff 70 48             	push   0x48(%eax)
f01042d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01042d3:	50                   	push   %eax
f01042d4:	e8 ff ed ff ff       	call   f01030d8 <env_alloc>
f01042d9:	89 c3                	mov    %eax,%ebx
f01042db:	83 c4 10             	add    $0x10,%esp
f01042de:	85 c0                	test   %eax,%eax
f01042e0:	0f 88 5c ff ff ff    	js     f0104242 <syscall+0x4b>
	e->env_status = ENV_NOT_RUNNABLE;
f01042e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01042e9:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01042f0:	e8 b3 16 00 00       	call   f01059a8 <cpunum>
f01042f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01042f8:	8b b0 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%esi
f01042fe:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104306:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f0104308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010430b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f0104312:	8b 58 48             	mov    0x48(%eax),%ebx
		return sys_exofork();
f0104315:	e9 28 ff ff ff       	jmp    f0104242 <syscall+0x4b>
	if ((uint32_t)va >= UTOP || (((uint32_t)va & 0xFFF) != 0) || 
f010431a:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104321:	77 79                	ja     f010439c <syscall+0x1a5>
f0104323:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010432a:	75 7a                	jne    f01043a6 <syscall+0x1af>
f010432c:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f0104333:	75 7b                	jne    f01043b0 <syscall+0x1b9>
	if ((err = envid2env(envid, &env, 1)) < 0) return err;
f0104335:	83 ec 04             	sub    $0x4,%esp
f0104338:	6a 01                	push   $0x1
f010433a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010433d:	50                   	push   %eax
f010433e:	ff 75 0c             	push   0xc(%ebp)
f0104341:	e8 89 ec ff ff       	call   f0102fcf <envid2env>
f0104346:	89 c3                	mov    %eax,%ebx
f0104348:	83 c4 10             	add    $0x10,%esp
f010434b:	85 c0                	test   %eax,%eax
f010434d:	0f 88 ef fe ff ff    	js     f0104242 <syscall+0x4b>
	if ((pp = page_alloc(ALLOC_ZERO)) == NULL) return -E_NO_MEM;
f0104353:	83 ec 0c             	sub    $0xc,%esp
f0104356:	6a 01                	push   $0x1
f0104358:	e8 4d cb ff ff       	call   f0100eaa <page_alloc>
f010435d:	89 c6                	mov    %eax,%esi
f010435f:	83 c4 10             	add    $0x10,%esp
f0104362:	85 c0                	test   %eax,%eax
f0104364:	74 54                	je     f01043ba <syscall+0x1c3>
	if((err = page_insert(env->env_pgdir, pp, va, perm)) < 0)
f0104366:	ff 75 14             	push   0x14(%ebp)
f0104369:	ff 75 10             	push   0x10(%ebp)
f010436c:	50                   	push   %eax
f010436d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104370:	ff 70 60             	push   0x60(%eax)
f0104373:	e8 33 ce ff ff       	call   f01011ab <page_insert>
f0104378:	89 c3                	mov    %eax,%ebx
f010437a:	83 c4 10             	add    $0x10,%esp
f010437d:	85 c0                	test   %eax,%eax
f010437f:	78 0a                	js     f010438b <syscall+0x194>
	return 0;
f0104381:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_page_alloc(a1, (void *)a2, a3);
f0104386:	e9 b7 fe ff ff       	jmp    f0104242 <syscall+0x4b>
		page_free(pp);
f010438b:	83 ec 0c             	sub    $0xc,%esp
f010438e:	56                   	push   %esi
f010438f:	e8 8b cb ff ff       	call   f0100f1f <page_free>
		return err;
f0104394:	83 c4 10             	add    $0x10,%esp
f0104397:	e9 a6 fe ff ff       	jmp    f0104242 <syscall+0x4b>
		(perm | PTE_SYSCALL) != PTE_SYSCALL) return -E_INVAL;
f010439c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01043a1:	e9 9c fe ff ff       	jmp    f0104242 <syscall+0x4b>
f01043a6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01043ab:	e9 92 fe ff ff       	jmp    f0104242 <syscall+0x4b>
f01043b0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01043b5:	e9 88 fe ff ff       	jmp    f0104242 <syscall+0x4b>
	if ((pp = page_alloc(ALLOC_ZERO)) == NULL) return -E_NO_MEM;
f01043ba:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01043bf:	e9 7e fe ff ff       	jmp    f0104242 <syscall+0x4b>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;
f01043c4:	8b 45 10             	mov    0x10(%ebp),%eax
f01043c7:	83 e8 02             	sub    $0x2,%eax
f01043ca:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01043cf:	75 31                	jne    f0104402 <syscall+0x20b>
	if ((err = envid2env(envid, &e, 1)) < 0) return err;
f01043d1:	83 ec 04             	sub    $0x4,%esp
f01043d4:	6a 01                	push   $0x1
f01043d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01043d9:	50                   	push   %eax
f01043da:	ff 75 0c             	push   0xc(%ebp)
f01043dd:	e8 ed eb ff ff       	call   f0102fcf <envid2env>
f01043e2:	89 c3                	mov    %eax,%ebx
f01043e4:	83 c4 10             	add    $0x10,%esp
f01043e7:	85 c0                	test   %eax,%eax
f01043e9:	0f 88 53 fe ff ff    	js     f0104242 <syscall+0x4b>
	e->env_status = status;
f01043ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01043f2:	8b 7d 10             	mov    0x10(%ebp),%edi
f01043f5:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f01043f8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01043fd:	e9 40 fe ff ff       	jmp    f0104242 <syscall+0x4b>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;
f0104402:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_env_set_status(a1, a2);
f0104407:	e9 36 fe ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1) < 0) return -E_BAD_ENV;
f010440c:	83 ec 04             	sub    $0x4,%esp
f010440f:	6a 01                	push   $0x1
f0104411:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104414:	50                   	push   %eax
f0104415:	ff 75 0c             	push   0xc(%ebp)
f0104418:	e8 b2 eb ff ff       	call   f0102fcf <envid2env>
f010441d:	83 c4 10             	add    $0x10,%esp
f0104420:	85 c0                	test   %eax,%eax
f0104422:	0f 88 98 00 00 00    	js     f01044c0 <syscall+0x2c9>
f0104428:	83 ec 04             	sub    $0x4,%esp
f010442b:	6a 01                	push   $0x1
f010442d:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104430:	50                   	push   %eax
f0104431:	ff 75 14             	push   0x14(%ebp)
f0104434:	e8 96 eb ff ff       	call   f0102fcf <envid2env>
f0104439:	83 c4 10             	add    $0x10,%esp
f010443c:	85 c0                	test   %eax,%eax
f010443e:	0f 88 86 00 00 00    	js     f01044ca <syscall+0x2d3>
	if ((uint32_t)srcva >= UTOP || (uint32_t)srcva & 0xFFF ||
f0104444:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010444b:	0f 87 83 00 00 00    	ja     f01044d4 <syscall+0x2dd>
f0104451:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104458:	0f 87 80 00 00 00    	ja     f01044de <syscall+0x2e7>
		(uint32_t)dstva >= UTOP || (uint32_t)dstva & 0xFFF) return -E_INVAL;
f010445e:	8b 45 10             	mov    0x10(%ebp),%eax
f0104461:	0b 45 18             	or     0x18(%ebp),%eax
f0104464:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104469:	75 7d                	jne    f01044e8 <syscall+0x2f1>
	if ((perm | PTE_SYSCALL) != PTE_SYSCALL) return -E_INVAL;
f010446b:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f0104472:	75 7e                	jne    f01044f2 <syscall+0x2fb>
	struct PageInfo *pp = page_lookup(src->env_pgdir, srcva, &pte);
f0104474:	83 ec 04             	sub    $0x4,%esp
f0104477:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010447a:	50                   	push   %eax
f010447b:	ff 75 10             	push   0x10(%ebp)
f010447e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104481:	ff 70 60             	push   0x60(%eax)
f0104484:	e8 2c cc ff ff       	call   f01010b5 <page_lookup>
	if (!pp || ((perm & PTE_W) && !((*pte) & PTE_W))) return -E_INVAL;
f0104489:	83 c4 10             	add    $0x10,%esp
f010448c:	85 c0                	test   %eax,%eax
f010448e:	74 6c                	je     f01044fc <syscall+0x305>
f0104490:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104494:	74 08                	je     f010449e <syscall+0x2a7>
f0104496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104499:	f6 02 02             	testb  $0x2,(%edx)
f010449c:	74 68                	je     f0104506 <syscall+0x30f>
	if (page_insert(dst->env_pgdir, pp, dstva, perm) < 0) return -E_NO_MEM;
f010449e:	ff 75 1c             	push   0x1c(%ebp)
f01044a1:	ff 75 18             	push   0x18(%ebp)
f01044a4:	50                   	push   %eax
f01044a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01044a8:	ff 70 60             	push   0x60(%eax)
f01044ab:	e8 fb cc ff ff       	call   f01011ab <page_insert>
f01044b0:	83 c4 10             	add    $0x10,%esp
f01044b3:	c1 f8 1f             	sar    $0x1f,%eax
f01044b6:	89 c3                	mov    %eax,%ebx
f01044b8:	83 e3 fc             	and    $0xfffffffc,%ebx
f01044bb:	e9 82 fd ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1) < 0) return -E_BAD_ENV;
f01044c0:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01044c5:	e9 78 fd ff ff       	jmp    f0104242 <syscall+0x4b>
f01044ca:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01044cf:	e9 6e fd ff ff       	jmp    f0104242 <syscall+0x4b>
		(uint32_t)dstva >= UTOP || (uint32_t)dstva & 0xFFF) return -E_INVAL;
f01044d4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01044d9:	e9 64 fd ff ff       	jmp    f0104242 <syscall+0x4b>
f01044de:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01044e3:	e9 5a fd ff ff       	jmp    f0104242 <syscall+0x4b>
f01044e8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01044ed:	e9 50 fd ff ff       	jmp    f0104242 <syscall+0x4b>
	if ((perm | PTE_SYSCALL) != PTE_SYSCALL) return -E_INVAL;
f01044f2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01044f7:	e9 46 fd ff ff       	jmp    f0104242 <syscall+0x4b>
	if (!pp || ((perm & PTE_W) && !((*pte) & PTE_W))) return -E_INVAL;
f01044fc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104501:	e9 3c fd ff ff       	jmp    f0104242 <syscall+0x4b>
f0104506:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010450b:	e9 32 fd ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0104510:	83 ec 04             	sub    $0x4,%esp
f0104513:	6a 01                	push   $0x1
f0104515:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104518:	50                   	push   %eax
f0104519:	ff 75 0c             	push   0xc(%ebp)
f010451c:	e8 ae ea ff ff       	call   f0102fcf <envid2env>
f0104521:	83 c4 10             	add    $0x10,%esp
f0104524:	85 c0                	test   %eax,%eax
f0104526:	78 27                	js     f010454f <syscall+0x358>
	if ((uint32_t)va >= UTOP) return -E_INVAL;
f0104528:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010452f:	77 28                	ja     f0104559 <syscall+0x362>
	page_remove(env->env_pgdir, va);
f0104531:	83 ec 08             	sub    $0x8,%esp
f0104534:	ff 75 10             	push   0x10(%ebp)
f0104537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010453a:	ff 70 60             	push   0x60(%eax)
f010453d:	e8 06 cc ff ff       	call   f0101148 <page_remove>
	return 0;
f0104542:	83 c4 10             	add    $0x10,%esp
f0104545:	bb 00 00 00 00       	mov    $0x0,%ebx
f010454a:	e9 f3 fc ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f010454f:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104554:	e9 e9 fc ff ff       	jmp    f0104242 <syscall+0x4b>
	if ((uint32_t)va >= UTOP) return -E_INVAL;
f0104559:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_page_unmap(a1, (void *)a2);
f010455e:	e9 df fc ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0104563:	83 ec 04             	sub    $0x4,%esp
f0104566:	6a 01                	push   $0x1
f0104568:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010456b:	50                   	push   %eax
f010456c:	ff 75 0c             	push   0xc(%ebp)
f010456f:	e8 5b ea ff ff       	call   f0102fcf <envid2env>
f0104574:	83 c4 10             	add    $0x10,%esp
f0104577:	85 c0                	test   %eax,%eax
f0104579:	78 13                	js     f010458e <syscall+0x397>
	env->env_pgfault_upcall = func;
f010457b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010457e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104581:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0104584:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104589:	e9 b4 fc ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f010458e:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0104593:	e9 aa fc ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 0) < 0) return -E_BAD_ENV;
f0104598:	83 ec 04             	sub    $0x4,%esp
f010459b:	6a 00                	push   $0x0
f010459d:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01045a0:	50                   	push   %eax
f01045a1:	ff 75 0c             	push   0xc(%ebp)
f01045a4:	e8 26 ea ff ff       	call   f0102fcf <envid2env>
f01045a9:	83 c4 10             	add    $0x10,%esp
f01045ac:	85 c0                	test   %eax,%eax
f01045ae:	0f 88 f5 00 00 00    	js     f01046a9 <syscall+0x4b2>
	if (!env->env_ipc_recving) return -E_IPC_NOT_RECV;
f01045b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01045b7:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01045bb:	0f 84 f2 00 00 00    	je     f01046b3 <syscall+0x4bc>
	if (srcva && env->env_ipc_dstva && (uint32_t)srcva < UTOP && (uint32_t)env->env_ipc_dstva < UTOP) {
f01045c1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
f01045c5:	74 18                	je     f01045df <syscall+0x3e8>
f01045c7:	8b 50 6c             	mov    0x6c(%eax),%edx
f01045ca:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01045d1:	77 0c                	ja     f01045df <syscall+0x3e8>
f01045d3:	85 d2                	test   %edx,%edx
f01045d5:	74 08                	je     f01045df <syscall+0x3e8>
f01045d7:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f01045dd:	76 3c                	jbe    f010461b <syscall+0x424>
	} else env->env_ipc_perm = 0;
f01045df:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	env->env_ipc_recving = 0;
f01045e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01045e9:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	env->env_ipc_from = curenv->env_id;
f01045ed:	e8 b6 13 00 00       	call   f01059a8 <cpunum>
f01045f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01045f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01045f8:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f01045fe:	8b 40 48             	mov    0x48(%eax),%eax
f0104601:	89 42 74             	mov    %eax,0x74(%edx)
	env->env_ipc_value = value;
f0104604:	8b 45 10             	mov    0x10(%ebp),%eax
f0104607:	89 42 70             	mov    %eax,0x70(%edx)
	env->env_status = ENV_RUNNABLE;
f010460a:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	return 0;
f0104611:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104616:	e9 27 fc ff ff       	jmp    f0104242 <syscall+0x4b>
		struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
f010461b:	e8 88 13 00 00       	call   f01059a8 <cpunum>
f0104620:	83 ec 04             	sub    $0x4,%esp
f0104623:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104626:	52                   	push   %edx
f0104627:	ff 75 14             	push   0x14(%ebp)
f010462a:	6b c0 74             	imul   $0x74,%eax,%eax
f010462d:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0104633:	ff 70 60             	push   0x60(%eax)
f0104636:	e8 7a ca ff ff       	call   f01010b5 <page_lookup>
		if ((uint32_t)srcva & 0xFFF || 
f010463b:	83 c4 10             	add    $0x10,%esp
			return -E_INVAL;
f010463e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if ((uint32_t)srcva & 0xFFF || 
f0104643:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f010464a:	0f 85 f2 fb ff ff    	jne    f0104242 <syscall+0x4b>
			(perm | PTE_SYSCALL) != PTE_SYSCALL ||
f0104650:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0104657:	75 46                	jne    f010469f <syscall+0x4a8>
f0104659:	85 c0                	test   %eax,%eax
f010465b:	74 42                	je     f010469f <syscall+0x4a8>
			!pp || ((perm & PTE_W) && !(*pte & PTE_W)))
f010465d:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104661:	74 0c                	je     f010466f <syscall+0x478>
f0104663:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104666:	f6 02 02             	testb  $0x2,(%edx)
f0104669:	0f 84 d3 fb ff ff    	je     f0104242 <syscall+0x4b>
		if (page_insert(env->env_pgdir, pp, env->env_ipc_dstva, perm) < 0) return -E_NO_MEM;
f010466f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104672:	ff 75 18             	push   0x18(%ebp)
f0104675:	ff 72 6c             	push   0x6c(%edx)
f0104678:	50                   	push   %eax
f0104679:	ff 72 60             	push   0x60(%edx)
f010467c:	e8 2a cb ff ff       	call   f01011ab <page_insert>
f0104681:	83 c4 10             	add    $0x10,%esp
f0104684:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104689:	85 c0                	test   %eax,%eax
f010468b:	0f 88 b1 fb ff ff    	js     f0104242 <syscall+0x4b>
		env->env_ipc_perm = perm;
f0104691:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104694:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104697:	89 78 78             	mov    %edi,0x78(%eax)
	if (srcva && env->env_ipc_dstva && (uint32_t)srcva < UTOP && (uint32_t)env->env_ipc_dstva < UTOP) {
f010469a:	e9 47 ff ff ff       	jmp    f01045e6 <syscall+0x3ef>
			return -E_INVAL;
f010469f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046a4:	e9 99 fb ff ff       	jmp    f0104242 <syscall+0x4b>
	if (envid2env(envid, &env, 0) < 0) return -E_BAD_ENV;
f01046a9:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01046ae:	e9 8f fb ff ff       	jmp    f0104242 <syscall+0x4b>
	if (!env->env_ipc_recving) return -E_IPC_NOT_RECV;
f01046b3:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
		return sys_ipc_try_send(a1, a2, (void *)a3, a4);
f01046b8:	e9 85 fb ff ff       	jmp    f0104242 <syscall+0x4b>
	if (((uintptr_t)dstva) < UTOP && (uint32_t)dstva & 0xFFF) return -E_INVAL;
f01046bd:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01046c4:	77 13                	ja     f01046d9 <syscall+0x4e2>
f01046c6:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01046cd:	74 0a                	je     f01046d9 <syscall+0x4e2>
		return sys_ipc_recv((void *)a1);
f01046cf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046d4:	e9 69 fb ff ff       	jmp    f0104242 <syscall+0x4b>
	curenv->env_ipc_recving = 1;
f01046d9:	e8 ca 12 00 00       	call   f01059a8 <cpunum>
f01046de:	6b c0 74             	imul   $0x74,%eax,%eax
f01046e1:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f01046e7:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01046eb:	e8 b8 12 00 00       	call   f01059a8 <cpunum>
f01046f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01046f3:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f01046f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01046fc:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f01046ff:	e8 a4 12 00 00       	call   f01059a8 <cpunum>
f0104704:	6b c0 74             	imul   $0x74,%eax,%eax
f0104707:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f010470d:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f0104714:	e8 8f 12 00 00       	call   f01059a8 <cpunum>
f0104719:	6b c0 74             	imul   $0x74,%eax,%eax
f010471c:	8b 80 28 c0 22 f0    	mov    -0xfdd3fd8(%eax),%eax
f0104722:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	sched_yield();
f0104729:	e8 17 fa ff ff       	call   f0104145 <sched_yield>
	if ((r = envid2env(envid, &e, 1)) < 0)
f010472e:	83 ec 04             	sub    $0x4,%esp
f0104731:	6a 01                	push   $0x1
f0104733:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104736:	50                   	push   %eax
f0104737:	ff 75 0c             	push   0xc(%ebp)
f010473a:	e8 90 e8 ff ff       	call   f0102fcf <envid2env>
f010473f:	89 c3                	mov    %eax,%ebx
f0104741:	83 c4 10             	add    $0x10,%esp
f0104744:	85 c0                	test   %eax,%eax
f0104746:	0f 88 f6 fa ff ff    	js     f0104242 <syscall+0x4b>
	if (tf == NULL)
f010474c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0104750:	74 3d                	je     f010478f <syscall+0x598>
	user_mem_assert(e, tf, sizeof(struct Trapframe), PTE_U);
f0104752:	6a 04                	push   $0x4
f0104754:	6a 44                	push   $0x44
f0104756:	ff 75 10             	push   0x10(%ebp)
f0104759:	ff 75 e4             	push   -0x1c(%ebp)
f010475c:	e8 b3 e7 ff ff       	call   f0102f14 <user_mem_assert>
	e->env_tf = *tf;
f0104761:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104766:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104769:	8b 75 10             	mov    0x10(%ebp),%esi
f010476c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f010476e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104771:	66 83 4a 34 03       	orw    $0x3,0x34(%edx)
	e->env_tf.tf_eflags &= (-1-FL_IOPL_3);
f0104776:	8b 42 38             	mov    0x38(%edx),%eax
f0104779:	80 e4 cf             	and    $0xcf,%ah
f010477c:	80 cc 02             	or     $0x2,%ah
f010477f:	89 42 38             	mov    %eax,0x38(%edx)
	return 0;
f0104782:	83 c4 10             	add    $0x10,%esp
f0104785:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f010478a:	e9 b3 fa ff ff       	jmp    f0104242 <syscall+0x4b>
		panic("sys_env_set_trapframe: invalid Trapframe\n");
f010478f:	83 ec 04             	sub    $0x4,%esp
f0104792:	68 fc 76 10 f0       	push   $0xf01076fc
f0104797:	68 8b 00 00 00       	push   $0x8b
f010479c:	68 eb 76 10 f0       	push   $0xf01076eb
f01047a1:	e8 9a b8 ff ff       	call   f0100040 <_panic>
	switch (syscallno) {
f01047a6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047ab:	e9 92 fa ff ff       	jmp    f0104242 <syscall+0x4b>

f01047b0 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01047b0:	55                   	push   %ebp
f01047b1:	89 e5                	mov    %esp,%ebp
f01047b3:	57                   	push   %edi
f01047b4:	56                   	push   %esi
f01047b5:	53                   	push   %ebx
f01047b6:	83 ec 14             	sub    $0x14,%esp
f01047b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01047bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01047bf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01047c2:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01047c5:	8b 1a                	mov    (%edx),%ebx
f01047c7:	8b 01                	mov    (%ecx),%eax
f01047c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01047cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01047d3:	eb 2f                	jmp    f0104804 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f01047d5:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f01047d8:	39 c3                	cmp    %eax,%ebx
f01047da:	7f 4e                	jg     f010482a <stab_binsearch+0x7a>
f01047dc:	0f b6 0a             	movzbl (%edx),%ecx
f01047df:	83 ea 0c             	sub    $0xc,%edx
f01047e2:	39 f1                	cmp    %esi,%ecx
f01047e4:	75 ef                	jne    f01047d5 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01047e6:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01047e9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01047ec:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01047f0:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01047f3:	73 3a                	jae    f010482f <stab_binsearch+0x7f>
			*region_left = m;
f01047f5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01047f8:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01047fa:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01047fd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104804:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104807:	7f 53                	jg     f010485c <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104809:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010480c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f010480f:	89 d0                	mov    %edx,%eax
f0104811:	c1 e8 1f             	shr    $0x1f,%eax
f0104814:	01 d0                	add    %edx,%eax
f0104816:	89 c7                	mov    %eax,%edi
f0104818:	d1 ff                	sar    %edi
f010481a:	83 e0 fe             	and    $0xfffffffe,%eax
f010481d:	01 f8                	add    %edi,%eax
f010481f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104822:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104826:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104828:	eb ae                	jmp    f01047d8 <stab_binsearch+0x28>
			l = true_m + 1;
f010482a:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f010482d:	eb d5                	jmp    f0104804 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f010482f:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104832:	76 14                	jbe    f0104848 <stab_binsearch+0x98>
			*region_right = m - 1;
f0104834:	83 e8 01             	sub    $0x1,%eax
f0104837:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010483a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010483d:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f010483f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104846:	eb bc                	jmp    f0104804 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104848:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010484b:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f010484d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104851:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104853:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010485a:	eb a8                	jmp    f0104804 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f010485c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104860:	75 15                	jne    f0104877 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104865:	8b 00                	mov    (%eax),%eax
f0104867:	83 e8 01             	sub    $0x1,%eax
f010486a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010486d:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f010486f:	83 c4 14             	add    $0x14,%esp
f0104872:	5b                   	pop    %ebx
f0104873:	5e                   	pop    %esi
f0104874:	5f                   	pop    %edi
f0104875:	5d                   	pop    %ebp
f0104876:	c3                   	ret    
		for (l = *region_right;
f0104877:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010487a:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010487c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010487f:	8b 0f                	mov    (%edi),%ecx
f0104881:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104884:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104887:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f010488b:	39 c1                	cmp    %eax,%ecx
f010488d:	7d 0f                	jge    f010489e <stab_binsearch+0xee>
f010488f:	0f b6 1a             	movzbl (%edx),%ebx
f0104892:	83 ea 0c             	sub    $0xc,%edx
f0104895:	39 f3                	cmp    %esi,%ebx
f0104897:	74 05                	je     f010489e <stab_binsearch+0xee>
		     l--)
f0104899:	83 e8 01             	sub    $0x1,%eax
f010489c:	eb ed                	jmp    f010488b <stab_binsearch+0xdb>
		*region_left = l;
f010489e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01048a1:	89 07                	mov    %eax,(%edi)
}
f01048a3:	eb ca                	jmp    f010486f <stab_binsearch+0xbf>

f01048a5 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01048a5:	55                   	push   %ebp
f01048a6:	89 e5                	mov    %esp,%ebp
f01048a8:	57                   	push   %edi
f01048a9:	56                   	push   %esi
f01048aa:	53                   	push   %ebx
f01048ab:	83 ec 4c             	sub    $0x4c,%esp
f01048ae:	8b 7d 08             	mov    0x8(%ebp),%edi
f01048b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01048b4:	c7 03 60 77 10 f0    	movl   $0xf0107760,(%ebx)
	info->eip_line = 0;
f01048ba:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f01048c1:	c7 43 08 60 77 10 f0 	movl   $0xf0107760,0x8(%ebx)
	info->eip_fn_namelen = 9;
f01048c8:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f01048cf:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f01048d2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01048d9:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01048df:	0f 87 23 01 00 00    	ja     f0104a08 <debuginfo_eip+0x163>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		stabs = usd->stabs;
f01048e5:	a1 00 00 20 00       	mov    0x200000,%eax
f01048ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stab_end = usd->stab_end;
f01048ed:	a1 04 00 20 00       	mov    0x200004,%eax
		stabstr = usd->stabstr;
f01048f2:	8b 35 08 00 20 00    	mov    0x200008,%esi
f01048f8:	89 75 bc             	mov    %esi,-0x44(%ebp)
		stabstr_end = usd->stabstr_end;
f01048fb:	8b 35 0c 00 20 00    	mov    0x20000c,%esi
f0104901:	89 75 c0             	mov    %esi,-0x40(%ebp)
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104904:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0104907:	39 4d bc             	cmp    %ecx,-0x44(%ebp)
f010490a:	0f 83 8c 01 00 00    	jae    f0104a9c <debuginfo_eip+0x1f7>
f0104910:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104914:	0f 85 89 01 00 00    	jne    f0104aa3 <debuginfo_eip+0x1fe>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f010491a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104921:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104924:	29 f0                	sub    %esi,%eax
f0104926:	c1 f8 02             	sar    $0x2,%eax
f0104929:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010492f:	83 e8 01             	sub    $0x1,%eax
f0104932:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104935:	57                   	push   %edi
f0104936:	6a 64                	push   $0x64
f0104938:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010493b:	89 c1                	mov    %eax,%ecx
f010493d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104940:	89 f0                	mov    %esi,%eax
f0104942:	e8 69 fe ff ff       	call   f01047b0 <stab_binsearch>
	if (lfile == 0)
f0104947:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010494a:	83 c4 08             	add    $0x8,%esp
f010494d:	85 f6                	test   %esi,%esi
f010494f:	0f 84 55 01 00 00    	je     f0104aaa <debuginfo_eip+0x205>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104955:	89 75 dc             	mov    %esi,-0x24(%ebp)
	rfun = rfile;
f0104958:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010495b:	89 55 b8             	mov    %edx,-0x48(%ebp)
f010495e:	89 55 d8             	mov    %edx,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104961:	57                   	push   %edi
f0104962:	6a 24                	push   $0x24
f0104964:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104967:	89 d1                	mov    %edx,%ecx
f0104969:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010496c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010496f:	e8 3c fe ff ff       	call   f01047b0 <stab_binsearch>

	if (lfun <= rfun) {
f0104974:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104977:	89 55 b4             	mov    %edx,-0x4c(%ebp)
f010497a:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010497d:	89 c1                	mov    %eax,%ecx
f010497f:	89 45 b0             	mov    %eax,-0x50(%ebp)
f0104982:	83 c4 08             	add    $0x8,%esp
f0104985:	89 f0                	mov    %esi,%eax
f0104987:	39 ca                	cmp    %ecx,%edx
f0104989:	7f 2c                	jg     f01049b7 <debuginfo_eip+0x112>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010498b:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010498e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0104991:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f0104994:	8b 02                	mov    (%edx),%eax
f0104996:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0104999:	2b 4d bc             	sub    -0x44(%ebp),%ecx
f010499c:	39 c8                	cmp    %ecx,%eax
f010499e:	73 06                	jae    f01049a6 <debuginfo_eip+0x101>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01049a0:	03 45 bc             	add    -0x44(%ebp),%eax
f01049a3:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01049a6:	8b 42 08             	mov    0x8(%edx),%eax
f01049a9:	89 43 10             	mov    %eax,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01049ac:	29 c7                	sub    %eax,%edi
f01049ae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
f01049b1:	8b 4d b0             	mov    -0x50(%ebp),%ecx
f01049b4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f01049b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01049ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01049bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01049c0:	83 ec 08             	sub    $0x8,%esp
f01049c3:	6a 3a                	push   $0x3a
f01049c5:	ff 73 08             	push   0x8(%ebx)
f01049c8:	e8 cb 09 00 00       	call   f0105398 <strfind>
f01049cd:	2b 43 08             	sub    0x8(%ebx),%eax
f01049d0:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01049d3:	83 c4 08             	add    $0x8,%esp
f01049d6:	57                   	push   %edi
f01049d7:	6a 44                	push   $0x44
f01049d9:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01049dc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01049df:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f01049e2:	89 f8                	mov    %edi,%eax
f01049e4:	e8 c7 fd ff ff       	call   f01047b0 <stab_binsearch>
	if (lline <= rline) info->eip_line = rline;
f01049e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01049ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01049ef:	83 c4 10             	add    $0x10,%esp
f01049f2:	39 d0                	cmp    %edx,%eax
f01049f4:	0f 8f b7 00 00 00    	jg     f0104ab1 <debuginfo_eip+0x20c>
f01049fa:	89 53 04             	mov    %edx,0x4(%ebx)
f01049fd:	89 c2                	mov    %eax,%edx
f01049ff:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104a02:	8d 44 87 04          	lea    0x4(%edi,%eax,4),%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104a06:	eb 25                	jmp    f0104a2d <debuginfo_eip+0x188>
		stabstr_end = __STABSTR_END__;
f0104a08:	c7 45 c0 16 9d 11 f0 	movl   $0xf0119d16,-0x40(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104a0f:	c7 45 bc 91 33 11 f0 	movl   $0xf0113391,-0x44(%ebp)
		stab_end = __STAB_END__;
f0104a16:	b8 90 33 11 f0       	mov    $0xf0113390,%eax
		stabs = __STAB_BEGIN__;
f0104a1b:	c7 45 c4 f0 7c 10 f0 	movl   $0xf0107cf0,-0x3c(%ebp)
f0104a22:	e9 dd fe ff ff       	jmp    f0104904 <debuginfo_eip+0x5f>
f0104a27:	83 ea 01             	sub    $0x1,%edx
f0104a2a:	83 e8 0c             	sub    $0xc,%eax
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104a2d:	39 d6                	cmp    %edx,%esi
f0104a2f:	7f 2e                	jg     f0104a5f <debuginfo_eip+0x1ba>
	       && stabs[lline].n_type != N_SOL
f0104a31:	0f b6 08             	movzbl (%eax),%ecx
f0104a34:	80 f9 84             	cmp    $0x84,%cl
f0104a37:	74 0b                	je     f0104a44 <debuginfo_eip+0x19f>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104a39:	80 f9 64             	cmp    $0x64,%cl
f0104a3c:	75 e9                	jne    f0104a27 <debuginfo_eip+0x182>
f0104a3e:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0104a42:	74 e3                	je     f0104a27 <debuginfo_eip+0x182>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104a44:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104a47:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104a4a:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104a4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104a50:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104a53:	29 f0                	sub    %esi,%eax
f0104a55:	39 c2                	cmp    %eax,%edx
f0104a57:	73 06                	jae    f0104a5f <debuginfo_eip+0x1ba>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104a59:	89 f0                	mov    %esi,%eax
f0104a5b:	01 d0                	add    %edx,%eax
f0104a5d:	89 03                	mov    %eax,(%ebx)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104a5f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0104a64:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0104a67:	8b 75 b0             	mov    -0x50(%ebp),%esi
f0104a6a:	39 f7                	cmp    %esi,%edi
f0104a6c:	7d 4f                	jge    f0104abd <debuginfo_eip+0x218>
		for (lline = lfun + 1;
f0104a6e:	83 c7 01             	add    $0x1,%edi
f0104a71:	89 f8                	mov    %edi,%eax
f0104a73:	8d 14 7f             	lea    (%edi,%edi,2),%edx
f0104a76:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104a79:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104a7d:	eb 04                	jmp    f0104a83 <debuginfo_eip+0x1de>
			info->eip_fn_narg++;
f0104a7f:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104a83:	39 c6                	cmp    %eax,%esi
f0104a85:	7e 31                	jle    f0104ab8 <debuginfo_eip+0x213>
f0104a87:	0f b6 0a             	movzbl (%edx),%ecx
f0104a8a:	83 c0 01             	add    $0x1,%eax
f0104a8d:	83 c2 0c             	add    $0xc,%edx
f0104a90:	80 f9 a0             	cmp    $0xa0,%cl
f0104a93:	74 ea                	je     f0104a7f <debuginfo_eip+0x1da>
	return 0;
f0104a95:	b8 00 00 00 00       	mov    $0x0,%eax
f0104a9a:	eb 21                	jmp    f0104abd <debuginfo_eip+0x218>
		return -1;
f0104a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104aa1:	eb 1a                	jmp    f0104abd <debuginfo_eip+0x218>
f0104aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104aa8:	eb 13                	jmp    f0104abd <debuginfo_eip+0x218>
		return -1;
f0104aaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104aaf:	eb 0c                	jmp    f0104abd <debuginfo_eip+0x218>
	else return -1;
f0104ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104ab6:	eb 05                	jmp    f0104abd <debuginfo_eip+0x218>
	return 0;
f0104ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104ac0:	5b                   	pop    %ebx
f0104ac1:	5e                   	pop    %esi
f0104ac2:	5f                   	pop    %edi
f0104ac3:	5d                   	pop    %ebp
f0104ac4:	c3                   	ret    

f0104ac5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104ac5:	55                   	push   %ebp
f0104ac6:	89 e5                	mov    %esp,%ebp
f0104ac8:	57                   	push   %edi
f0104ac9:	56                   	push   %esi
f0104aca:	53                   	push   %ebx
f0104acb:	83 ec 1c             	sub    $0x1c,%esp
f0104ace:	89 c7                	mov    %eax,%edi
f0104ad0:	89 d6                	mov    %edx,%esi
f0104ad2:	8b 45 08             	mov    0x8(%ebp),%eax
f0104ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104ad8:	89 d1                	mov    %edx,%ecx
f0104ada:	89 c2                	mov    %eax,%edx
f0104adc:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104adf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104ae2:	8b 45 10             	mov    0x10(%ebp),%eax
f0104ae5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104aeb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0104af2:	39 c2                	cmp    %eax,%edx
f0104af4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0104af7:	72 3e                	jb     f0104b37 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104af9:	83 ec 0c             	sub    $0xc,%esp
f0104afc:	ff 75 18             	push   0x18(%ebp)
f0104aff:	83 eb 01             	sub    $0x1,%ebx
f0104b02:	53                   	push   %ebx
f0104b03:	50                   	push   %eax
f0104b04:	83 ec 08             	sub    $0x8,%esp
f0104b07:	ff 75 e4             	push   -0x1c(%ebp)
f0104b0a:	ff 75 e0             	push   -0x20(%ebp)
f0104b0d:	ff 75 dc             	push   -0x24(%ebp)
f0104b10:	ff 75 d8             	push   -0x28(%ebp)
f0104b13:	e8 88 12 00 00       	call   f0105da0 <__udivdi3>
f0104b18:	83 c4 18             	add    $0x18,%esp
f0104b1b:	52                   	push   %edx
f0104b1c:	50                   	push   %eax
f0104b1d:	89 f2                	mov    %esi,%edx
f0104b1f:	89 f8                	mov    %edi,%eax
f0104b21:	e8 9f ff ff ff       	call   f0104ac5 <printnum>
f0104b26:	83 c4 20             	add    $0x20,%esp
f0104b29:	eb 13                	jmp    f0104b3e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104b2b:	83 ec 08             	sub    $0x8,%esp
f0104b2e:	56                   	push   %esi
f0104b2f:	ff 75 18             	push   0x18(%ebp)
f0104b32:	ff d7                	call   *%edi
f0104b34:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104b37:	83 eb 01             	sub    $0x1,%ebx
f0104b3a:	85 db                	test   %ebx,%ebx
f0104b3c:	7f ed                	jg     f0104b2b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104b3e:	83 ec 08             	sub    $0x8,%esp
f0104b41:	56                   	push   %esi
f0104b42:	83 ec 04             	sub    $0x4,%esp
f0104b45:	ff 75 e4             	push   -0x1c(%ebp)
f0104b48:	ff 75 e0             	push   -0x20(%ebp)
f0104b4b:	ff 75 dc             	push   -0x24(%ebp)
f0104b4e:	ff 75 d8             	push   -0x28(%ebp)
f0104b51:	e8 6a 13 00 00       	call   f0105ec0 <__umoddi3>
f0104b56:	83 c4 14             	add    $0x14,%esp
f0104b59:	0f be 80 6a 77 10 f0 	movsbl -0xfef8896(%eax),%eax
f0104b60:	50                   	push   %eax
f0104b61:	ff d7                	call   *%edi
}
f0104b63:	83 c4 10             	add    $0x10,%esp
f0104b66:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104b69:	5b                   	pop    %ebx
f0104b6a:	5e                   	pop    %esi
f0104b6b:	5f                   	pop    %edi
f0104b6c:	5d                   	pop    %ebp
f0104b6d:	c3                   	ret    

f0104b6e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104b6e:	55                   	push   %ebp
f0104b6f:	89 e5                	mov    %esp,%ebp
f0104b71:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104b74:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104b78:	8b 10                	mov    (%eax),%edx
f0104b7a:	3b 50 04             	cmp    0x4(%eax),%edx
f0104b7d:	73 0a                	jae    f0104b89 <sprintputch+0x1b>
		*b->buf++ = ch;
f0104b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104b82:	89 08                	mov    %ecx,(%eax)
f0104b84:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b87:	88 02                	mov    %al,(%edx)
}
f0104b89:	5d                   	pop    %ebp
f0104b8a:	c3                   	ret    

f0104b8b <printfmt>:
{
f0104b8b:	55                   	push   %ebp
f0104b8c:	89 e5                	mov    %esp,%ebp
f0104b8e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104b91:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104b94:	50                   	push   %eax
f0104b95:	ff 75 10             	push   0x10(%ebp)
f0104b98:	ff 75 0c             	push   0xc(%ebp)
f0104b9b:	ff 75 08             	push   0x8(%ebp)
f0104b9e:	e8 05 00 00 00       	call   f0104ba8 <vprintfmt>
}
f0104ba3:	83 c4 10             	add    $0x10,%esp
f0104ba6:	c9                   	leave  
f0104ba7:	c3                   	ret    

f0104ba8 <vprintfmt>:
{
f0104ba8:	55                   	push   %ebp
f0104ba9:	89 e5                	mov    %esp,%ebp
f0104bab:	57                   	push   %edi
f0104bac:	56                   	push   %esi
f0104bad:	53                   	push   %ebx
f0104bae:	83 ec 3c             	sub    $0x3c,%esp
f0104bb1:	8b 75 08             	mov    0x8(%ebp),%esi
f0104bb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104bb7:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104bba:	eb 0a                	jmp    f0104bc6 <vprintfmt+0x1e>
			putch(ch, putdat);
f0104bbc:	83 ec 08             	sub    $0x8,%esp
f0104bbf:	53                   	push   %ebx
f0104bc0:	50                   	push   %eax
f0104bc1:	ff d6                	call   *%esi
f0104bc3:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104bc6:	83 c7 01             	add    $0x1,%edi
f0104bc9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104bcd:	83 f8 25             	cmp    $0x25,%eax
f0104bd0:	74 0c                	je     f0104bde <vprintfmt+0x36>
			if (ch == '\0')
f0104bd2:	85 c0                	test   %eax,%eax
f0104bd4:	75 e6                	jne    f0104bbc <vprintfmt+0x14>
}
f0104bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104bd9:	5b                   	pop    %ebx
f0104bda:	5e                   	pop    %esi
f0104bdb:	5f                   	pop    %edi
f0104bdc:	5d                   	pop    %ebp
f0104bdd:	c3                   	ret    
		padc = ' ';
f0104bde:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0104be2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104be9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
f0104bf0:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f0104bf7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104bfc:	8d 47 01             	lea    0x1(%edi),%eax
f0104bff:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0104c02:	0f b6 17             	movzbl (%edi),%edx
f0104c05:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104c08:	3c 55                	cmp    $0x55,%al
f0104c0a:	0f 87 a6 04 00 00    	ja     f01050b6 <vprintfmt+0x50e>
f0104c10:	0f b6 c0             	movzbl %al,%eax
f0104c13:	ff 24 85 a0 78 10 f0 	jmp    *-0xfef8760(,%eax,4)
f0104c1a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
f0104c1d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0104c21:	eb d9                	jmp    f0104bfc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
f0104c23:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0104c26:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f0104c2a:	eb d0                	jmp    f0104bfc <vprintfmt+0x54>
f0104c2c:	0f b6 d2             	movzbl %dl,%edx
f0104c2f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104c32:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c37:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
f0104c3a:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104c3d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104c41:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104c44:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104c47:	83 f9 09             	cmp    $0x9,%ecx
f0104c4a:	77 55                	ja     f0104ca1 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
f0104c4c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104c4f:	eb e9                	jmp    f0104c3a <vprintfmt+0x92>
			precision = va_arg(ap, int);
f0104c51:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c54:	8b 00                	mov    (%eax),%eax
f0104c56:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104c59:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c5c:	8d 40 04             	lea    0x4(%eax),%eax
f0104c5f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104c62:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
f0104c65:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104c69:	79 91                	jns    f0104bfc <vprintfmt+0x54>
				width = precision, precision = -1;
f0104c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104c71:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f0104c78:	eb 82                	jmp    f0104bfc <vprintfmt+0x54>
f0104c7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104c7d:	85 d2                	test   %edx,%edx
f0104c7f:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c84:	0f 49 c2             	cmovns %edx,%eax
f0104c87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104c8a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
f0104c8d:	e9 6a ff ff ff       	jmp    f0104bfc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
f0104c92:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
f0104c95:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0104c9c:	e9 5b ff ff ff       	jmp    f0104bfc <vprintfmt+0x54>
f0104ca1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104ca7:	eb bc                	jmp    f0104c65 <vprintfmt+0xbd>
			lflag++;
f0104ca9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104cac:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
f0104caf:	e9 48 ff ff ff       	jmp    f0104bfc <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
f0104cb4:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cb7:	8d 78 04             	lea    0x4(%eax),%edi
f0104cba:	83 ec 08             	sub    $0x8,%esp
f0104cbd:	53                   	push   %ebx
f0104cbe:	ff 30                	push   (%eax)
f0104cc0:	ff d6                	call   *%esi
			break;
f0104cc2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104cc5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0104cc8:	e9 88 03 00 00       	jmp    f0105055 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
f0104ccd:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cd0:	8d 78 04             	lea    0x4(%eax),%edi
f0104cd3:	8b 10                	mov    (%eax),%edx
f0104cd5:	89 d0                	mov    %edx,%eax
f0104cd7:	f7 d8                	neg    %eax
f0104cd9:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104cdc:	83 f8 0f             	cmp    $0xf,%eax
f0104cdf:	7f 23                	jg     f0104d04 <vprintfmt+0x15c>
f0104ce1:	8b 14 85 00 7a 10 f0 	mov    -0xfef8600(,%eax,4),%edx
f0104ce8:	85 d2                	test   %edx,%edx
f0104cea:	74 18                	je     f0104d04 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
f0104cec:	52                   	push   %edx
f0104ced:	68 b9 6e 10 f0       	push   $0xf0106eb9
f0104cf2:	53                   	push   %ebx
f0104cf3:	56                   	push   %esi
f0104cf4:	e8 92 fe ff ff       	call   f0104b8b <printfmt>
f0104cf9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104cfc:	89 7d 14             	mov    %edi,0x14(%ebp)
f0104cff:	e9 51 03 00 00       	jmp    f0105055 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
f0104d04:	50                   	push   %eax
f0104d05:	68 82 77 10 f0       	push   $0xf0107782
f0104d0a:	53                   	push   %ebx
f0104d0b:	56                   	push   %esi
f0104d0c:	e8 7a fe ff ff       	call   f0104b8b <printfmt>
f0104d11:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104d14:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104d17:	e9 39 03 00 00       	jmp    f0105055 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
f0104d1c:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d1f:	83 c0 04             	add    $0x4,%eax
f0104d22:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0104d25:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d28:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0104d2a:	85 d2                	test   %edx,%edx
f0104d2c:	b8 7b 77 10 f0       	mov    $0xf010777b,%eax
f0104d31:	0f 45 c2             	cmovne %edx,%eax
f0104d34:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f0104d37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104d3b:	7e 06                	jle    f0104d43 <vprintfmt+0x19b>
f0104d3d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f0104d41:	75 0d                	jne    f0104d50 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104d43:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0104d46:	89 c7                	mov    %eax,%edi
f0104d48:	03 45 d4             	add    -0x2c(%ebp),%eax
f0104d4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104d4e:	eb 55                	jmp    f0104da5 <vprintfmt+0x1fd>
f0104d50:	83 ec 08             	sub    $0x8,%esp
f0104d53:	ff 75 e0             	push   -0x20(%ebp)
f0104d56:	ff 75 cc             	push   -0x34(%ebp)
f0104d59:	e8 e3 04 00 00       	call   f0105241 <strnlen>
f0104d5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104d61:	29 c2                	sub    %eax,%edx
f0104d63:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0104d66:	83 c4 10             	add    $0x10,%esp
f0104d69:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f0104d6b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0104d6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0104d72:	eb 0f                	jmp    f0104d83 <vprintfmt+0x1db>
					putch(padc, putdat);
f0104d74:	83 ec 08             	sub    $0x8,%esp
f0104d77:	53                   	push   %ebx
f0104d78:	ff 75 d4             	push   -0x2c(%ebp)
f0104d7b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104d7d:	83 ef 01             	sub    $0x1,%edi
f0104d80:	83 c4 10             	add    $0x10,%esp
f0104d83:	85 ff                	test   %edi,%edi
f0104d85:	7f ed                	jg     f0104d74 <vprintfmt+0x1cc>
f0104d87:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104d8a:	85 d2                	test   %edx,%edx
f0104d8c:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d91:	0f 49 c2             	cmovns %edx,%eax
f0104d94:	29 c2                	sub    %eax,%edx
f0104d96:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104d99:	eb a8                	jmp    f0104d43 <vprintfmt+0x19b>
					putch(ch, putdat);
f0104d9b:	83 ec 08             	sub    $0x8,%esp
f0104d9e:	53                   	push   %ebx
f0104d9f:	52                   	push   %edx
f0104da0:	ff d6                	call   *%esi
f0104da2:	83 c4 10             	add    $0x10,%esp
f0104da5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104da8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104daa:	83 c7 01             	add    $0x1,%edi
f0104dad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104db1:	0f be d0             	movsbl %al,%edx
f0104db4:	85 d2                	test   %edx,%edx
f0104db6:	74 4b                	je     f0104e03 <vprintfmt+0x25b>
f0104db8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104dbc:	78 06                	js     f0104dc4 <vprintfmt+0x21c>
f0104dbe:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0104dc2:	78 1e                	js     f0104de2 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
f0104dc4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0104dc8:	74 d1                	je     f0104d9b <vprintfmt+0x1f3>
f0104dca:	0f be c0             	movsbl %al,%eax
f0104dcd:	83 e8 20             	sub    $0x20,%eax
f0104dd0:	83 f8 5e             	cmp    $0x5e,%eax
f0104dd3:	76 c6                	jbe    f0104d9b <vprintfmt+0x1f3>
					putch('?', putdat);
f0104dd5:	83 ec 08             	sub    $0x8,%esp
f0104dd8:	53                   	push   %ebx
f0104dd9:	6a 3f                	push   $0x3f
f0104ddb:	ff d6                	call   *%esi
f0104ddd:	83 c4 10             	add    $0x10,%esp
f0104de0:	eb c3                	jmp    f0104da5 <vprintfmt+0x1fd>
f0104de2:	89 cf                	mov    %ecx,%edi
f0104de4:	eb 0e                	jmp    f0104df4 <vprintfmt+0x24c>
				putch(' ', putdat);
f0104de6:	83 ec 08             	sub    $0x8,%esp
f0104de9:	53                   	push   %ebx
f0104dea:	6a 20                	push   $0x20
f0104dec:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0104dee:	83 ef 01             	sub    $0x1,%edi
f0104df1:	83 c4 10             	add    $0x10,%esp
f0104df4:	85 ff                	test   %edi,%edi
f0104df6:	7f ee                	jg     f0104de6 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
f0104df8:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0104dfb:	89 45 14             	mov    %eax,0x14(%ebp)
f0104dfe:	e9 52 02 00 00       	jmp    f0105055 <vprintfmt+0x4ad>
f0104e03:	89 cf                	mov    %ecx,%edi
f0104e05:	eb ed                	jmp    f0104df4 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
f0104e07:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e0a:	83 c0 04             	add    $0x4,%eax
f0104e0d:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0104e10:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e13:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0104e15:	85 d2                	test   %edx,%edx
f0104e17:	b8 7b 77 10 f0       	mov    $0xf010777b,%eax
f0104e1c:	0f 45 c2             	cmovne %edx,%eax
f0104e1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f0104e22:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104e26:	7e 06                	jle    f0104e2e <vprintfmt+0x286>
f0104e28:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f0104e2c:	75 0d                	jne    f0104e3b <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104e2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0104e31:	89 c7                	mov    %eax,%edi
f0104e33:	03 45 d4             	add    -0x2c(%ebp),%eax
f0104e36:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104e39:	eb 55                	jmp    f0104e90 <vprintfmt+0x2e8>
f0104e3b:	83 ec 08             	sub    $0x8,%esp
f0104e3e:	ff 75 e0             	push   -0x20(%ebp)
f0104e41:	ff 75 cc             	push   -0x34(%ebp)
f0104e44:	e8 f8 03 00 00       	call   f0105241 <strnlen>
f0104e49:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104e4c:	29 c2                	sub    %eax,%edx
f0104e4e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0104e51:	83 c4 10             	add    $0x10,%esp
f0104e54:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f0104e56:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0104e5a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0104e5d:	eb 0f                	jmp    f0104e6e <vprintfmt+0x2c6>
					putch(padc, putdat);
f0104e5f:	83 ec 08             	sub    $0x8,%esp
f0104e62:	53                   	push   %ebx
f0104e63:	ff 75 d4             	push   -0x2c(%ebp)
f0104e66:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104e68:	83 ef 01             	sub    $0x1,%edi
f0104e6b:	83 c4 10             	add    $0x10,%esp
f0104e6e:	85 ff                	test   %edi,%edi
f0104e70:	7f ed                	jg     f0104e5f <vprintfmt+0x2b7>
f0104e72:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104e75:	85 d2                	test   %edx,%edx
f0104e77:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e7c:	0f 49 c2             	cmovns %edx,%eax
f0104e7f:	29 c2                	sub    %eax,%edx
f0104e81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104e84:	eb a8                	jmp    f0104e2e <vprintfmt+0x286>
					putch(ch, putdat);
f0104e86:	83 ec 08             	sub    $0x8,%esp
f0104e89:	53                   	push   %ebx
f0104e8a:	52                   	push   %edx
f0104e8b:	ff d6                	call   *%esi
f0104e8d:	83 c4 10             	add    $0x10,%esp
f0104e90:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104e93:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
f0104e95:	83 c7 01             	add    $0x1,%edi
f0104e98:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104e9c:	0f be d0             	movsbl %al,%edx
f0104e9f:	3c 3a                	cmp    $0x3a,%al
f0104ea1:	74 4b                	je     f0104eee <vprintfmt+0x346>
f0104ea3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104ea7:	78 06                	js     f0104eaf <vprintfmt+0x307>
f0104ea9:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0104ead:	78 1e                	js     f0104ecd <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
f0104eaf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0104eb3:	74 d1                	je     f0104e86 <vprintfmt+0x2de>
f0104eb5:	0f be c0             	movsbl %al,%eax
f0104eb8:	83 e8 20             	sub    $0x20,%eax
f0104ebb:	83 f8 5e             	cmp    $0x5e,%eax
f0104ebe:	76 c6                	jbe    f0104e86 <vprintfmt+0x2de>
					putch('?', putdat);
f0104ec0:	83 ec 08             	sub    $0x8,%esp
f0104ec3:	53                   	push   %ebx
f0104ec4:	6a 3f                	push   $0x3f
f0104ec6:	ff d6                	call   *%esi
f0104ec8:	83 c4 10             	add    $0x10,%esp
f0104ecb:	eb c3                	jmp    f0104e90 <vprintfmt+0x2e8>
f0104ecd:	89 cf                	mov    %ecx,%edi
f0104ecf:	eb 0e                	jmp    f0104edf <vprintfmt+0x337>
				putch(' ', putdat);
f0104ed1:	83 ec 08             	sub    $0x8,%esp
f0104ed4:	53                   	push   %ebx
f0104ed5:	6a 20                	push   $0x20
f0104ed7:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0104ed9:	83 ef 01             	sub    $0x1,%edi
f0104edc:	83 c4 10             	add    $0x10,%esp
f0104edf:	85 ff                	test   %edi,%edi
f0104ee1:	7f ee                	jg     f0104ed1 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
f0104ee3:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0104ee6:	89 45 14             	mov    %eax,0x14(%ebp)
f0104ee9:	e9 67 01 00 00       	jmp    f0105055 <vprintfmt+0x4ad>
f0104eee:	89 cf                	mov    %ecx,%edi
f0104ef0:	eb ed                	jmp    f0104edf <vprintfmt+0x337>
	if (lflag >= 2)
f0104ef2:	83 f9 01             	cmp    $0x1,%ecx
f0104ef5:	7f 1b                	jg     f0104f12 <vprintfmt+0x36a>
	else if (lflag)
f0104ef7:	85 c9                	test   %ecx,%ecx
f0104ef9:	74 63                	je     f0104f5e <vprintfmt+0x3b6>
		return va_arg(*ap, long);
f0104efb:	8b 45 14             	mov    0x14(%ebp),%eax
f0104efe:	8b 00                	mov    (%eax),%eax
f0104f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f03:	99                   	cltd   
f0104f04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f07:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f0a:	8d 40 04             	lea    0x4(%eax),%eax
f0104f0d:	89 45 14             	mov    %eax,0x14(%ebp)
f0104f10:	eb 17                	jmp    f0104f29 <vprintfmt+0x381>
		return va_arg(*ap, long long);
f0104f12:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f15:	8b 50 04             	mov    0x4(%eax),%edx
f0104f18:	8b 00                	mov    (%eax),%eax
f0104f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f20:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f23:	8d 40 08             	lea    0x8(%eax),%eax
f0104f26:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0104f29:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104f2c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
f0104f2f:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
f0104f34:	85 c9                	test   %ecx,%ecx
f0104f36:	0f 89 ff 00 00 00    	jns    f010503b <vprintfmt+0x493>
				putch('-', putdat);
f0104f3c:	83 ec 08             	sub    $0x8,%esp
f0104f3f:	53                   	push   %ebx
f0104f40:	6a 2d                	push   $0x2d
f0104f42:	ff d6                	call   *%esi
				num = -(long long) num;
f0104f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104f47:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0104f4a:	f7 da                	neg    %edx
f0104f4c:	83 d1 00             	adc    $0x0,%ecx
f0104f4f:	f7 d9                	neg    %ecx
f0104f51:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0104f54:	bf 0a 00 00 00       	mov    $0xa,%edi
f0104f59:	e9 dd 00 00 00       	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, int);
f0104f5e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f61:	8b 00                	mov    (%eax),%eax
f0104f63:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f66:	99                   	cltd   
f0104f67:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f6a:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f6d:	8d 40 04             	lea    0x4(%eax),%eax
f0104f70:	89 45 14             	mov    %eax,0x14(%ebp)
f0104f73:	eb b4                	jmp    f0104f29 <vprintfmt+0x381>
	if (lflag >= 2)
f0104f75:	83 f9 01             	cmp    $0x1,%ecx
f0104f78:	7f 1e                	jg     f0104f98 <vprintfmt+0x3f0>
	else if (lflag)
f0104f7a:	85 c9                	test   %ecx,%ecx
f0104f7c:	74 32                	je     f0104fb0 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
f0104f7e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f81:	8b 10                	mov    (%eax),%edx
f0104f83:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104f88:	8d 40 04             	lea    0x4(%eax),%eax
f0104f8b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104f8e:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
f0104f93:	e9 a3 00 00 00       	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
f0104f98:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f9b:	8b 10                	mov    (%eax),%edx
f0104f9d:	8b 48 04             	mov    0x4(%eax),%ecx
f0104fa0:	8d 40 08             	lea    0x8(%eax),%eax
f0104fa3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104fa6:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
f0104fab:	e9 8b 00 00 00       	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
f0104fb0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fb3:	8b 10                	mov    (%eax),%edx
f0104fb5:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104fba:	8d 40 04             	lea    0x4(%eax),%eax
f0104fbd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104fc0:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
f0104fc5:	eb 74                	jmp    f010503b <vprintfmt+0x493>
	if (lflag >= 2)
f0104fc7:	83 f9 01             	cmp    $0x1,%ecx
f0104fca:	7f 1b                	jg     f0104fe7 <vprintfmt+0x43f>
	else if (lflag)
f0104fcc:	85 c9                	test   %ecx,%ecx
f0104fce:	74 2c                	je     f0104ffc <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
f0104fd0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fd3:	8b 10                	mov    (%eax),%edx
f0104fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104fda:	8d 40 04             	lea    0x4(%eax),%eax
f0104fdd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104fe0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
f0104fe5:	eb 54                	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
f0104fe7:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fea:	8b 10                	mov    (%eax),%edx
f0104fec:	8b 48 04             	mov    0x4(%eax),%ecx
f0104fef:	8d 40 08             	lea    0x8(%eax),%eax
f0104ff2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104ff5:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
f0104ffa:	eb 3f                	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
f0104ffc:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fff:	8b 10                	mov    (%eax),%edx
f0105001:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105006:	8d 40 04             	lea    0x4(%eax),%eax
f0105009:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010500c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
f0105011:	eb 28                	jmp    f010503b <vprintfmt+0x493>
			putch('0', putdat);
f0105013:	83 ec 08             	sub    $0x8,%esp
f0105016:	53                   	push   %ebx
f0105017:	6a 30                	push   $0x30
f0105019:	ff d6                	call   *%esi
			putch('x', putdat);
f010501b:	83 c4 08             	add    $0x8,%esp
f010501e:	53                   	push   %ebx
f010501f:	6a 78                	push   $0x78
f0105021:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105023:	8b 45 14             	mov    0x14(%ebp),%eax
f0105026:	8b 10                	mov    (%eax),%edx
f0105028:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010502d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105030:	8d 40 04             	lea    0x4(%eax),%eax
f0105033:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105036:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
f010503b:	83 ec 0c             	sub    $0xc,%esp
f010503e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0105042:	50                   	push   %eax
f0105043:	ff 75 d4             	push   -0x2c(%ebp)
f0105046:	57                   	push   %edi
f0105047:	51                   	push   %ecx
f0105048:	52                   	push   %edx
f0105049:	89 da                	mov    %ebx,%edx
f010504b:	89 f0                	mov    %esi,%eax
f010504d:	e8 73 fa ff ff       	call   f0104ac5 <printnum>
			break;
f0105052:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0105055:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105058:	e9 69 fb ff ff       	jmp    f0104bc6 <vprintfmt+0x1e>
	if (lflag >= 2)
f010505d:	83 f9 01             	cmp    $0x1,%ecx
f0105060:	7f 1b                	jg     f010507d <vprintfmt+0x4d5>
	else if (lflag)
f0105062:	85 c9                	test   %ecx,%ecx
f0105064:	74 2c                	je     f0105092 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
f0105066:	8b 45 14             	mov    0x14(%ebp),%eax
f0105069:	8b 10                	mov    (%eax),%edx
f010506b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105070:	8d 40 04             	lea    0x4(%eax),%eax
f0105073:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105076:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
f010507b:	eb be                	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
f010507d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105080:	8b 10                	mov    (%eax),%edx
f0105082:	8b 48 04             	mov    0x4(%eax),%ecx
f0105085:	8d 40 08             	lea    0x8(%eax),%eax
f0105088:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010508b:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
f0105090:	eb a9                	jmp    f010503b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
f0105092:	8b 45 14             	mov    0x14(%ebp),%eax
f0105095:	8b 10                	mov    (%eax),%edx
f0105097:	b9 00 00 00 00       	mov    $0x0,%ecx
f010509c:	8d 40 04             	lea    0x4(%eax),%eax
f010509f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01050a2:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
f01050a7:	eb 92                	jmp    f010503b <vprintfmt+0x493>
			putch(ch, putdat);
f01050a9:	83 ec 08             	sub    $0x8,%esp
f01050ac:	53                   	push   %ebx
f01050ad:	6a 25                	push   $0x25
f01050af:	ff d6                	call   *%esi
			break;
f01050b1:	83 c4 10             	add    $0x10,%esp
f01050b4:	eb 9f                	jmp    f0105055 <vprintfmt+0x4ad>
			putch('%', putdat);
f01050b6:	83 ec 08             	sub    $0x8,%esp
f01050b9:	53                   	push   %ebx
f01050ba:	6a 25                	push   $0x25
f01050bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01050be:	83 c4 10             	add    $0x10,%esp
f01050c1:	89 f8                	mov    %edi,%eax
f01050c3:	eb 03                	jmp    f01050c8 <vprintfmt+0x520>
f01050c5:	83 e8 01             	sub    $0x1,%eax
f01050c8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01050cc:	75 f7                	jne    f01050c5 <vprintfmt+0x51d>
f01050ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01050d1:	eb 82                	jmp    f0105055 <vprintfmt+0x4ad>

f01050d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01050d3:	55                   	push   %ebp
f01050d4:	89 e5                	mov    %esp,%ebp
f01050d6:	83 ec 18             	sub    $0x18,%esp
f01050d9:	8b 45 08             	mov    0x8(%ebp),%eax
f01050dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01050df:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01050e2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01050e6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01050e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01050f0:	85 c0                	test   %eax,%eax
f01050f2:	74 26                	je     f010511a <vsnprintf+0x47>
f01050f4:	85 d2                	test   %edx,%edx
f01050f6:	7e 22                	jle    f010511a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01050f8:	ff 75 14             	push   0x14(%ebp)
f01050fb:	ff 75 10             	push   0x10(%ebp)
f01050fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105101:	50                   	push   %eax
f0105102:	68 6e 4b 10 f0       	push   $0xf0104b6e
f0105107:	e8 9c fa ff ff       	call   f0104ba8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010510c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010510f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105112:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105115:	83 c4 10             	add    $0x10,%esp
}
f0105118:	c9                   	leave  
f0105119:	c3                   	ret    
		return -E_INVAL;
f010511a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010511f:	eb f7                	jmp    f0105118 <vsnprintf+0x45>

f0105121 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105121:	55                   	push   %ebp
f0105122:	89 e5                	mov    %esp,%ebp
f0105124:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105127:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010512a:	50                   	push   %eax
f010512b:	ff 75 10             	push   0x10(%ebp)
f010512e:	ff 75 0c             	push   0xc(%ebp)
f0105131:	ff 75 08             	push   0x8(%ebp)
f0105134:	e8 9a ff ff ff       	call   f01050d3 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105139:	c9                   	leave  
f010513a:	c3                   	ret    

f010513b <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010513b:	55                   	push   %ebp
f010513c:	89 e5                	mov    %esp,%ebp
f010513e:	57                   	push   %edi
f010513f:	56                   	push   %esi
f0105140:	53                   	push   %ebx
f0105141:	83 ec 0c             	sub    $0xc,%esp
f0105144:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105147:	85 c0                	test   %eax,%eax
f0105149:	74 11                	je     f010515c <readline+0x21>
		cprintf("%s", prompt);
f010514b:	83 ec 08             	sub    $0x8,%esp
f010514e:	50                   	push   %eax
f010514f:	68 b9 6e 10 f0       	push   $0xf0106eb9
f0105154:	e8 b4 e6 ff ff       	call   f010380d <cprintf>
f0105159:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010515c:	83 ec 0c             	sub    $0xc,%esp
f010515f:	6a 00                	push   $0x0
f0105161:	e8 38 b6 ff ff       	call   f010079e <iscons>
f0105166:	89 c7                	mov    %eax,%edi
f0105168:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010516b:	be 00 00 00 00       	mov    $0x0,%esi
f0105170:	eb 4b                	jmp    f01051bd <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105172:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0105177:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010517a:	75 08                	jne    f0105184 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010517c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010517f:	5b                   	pop    %ebx
f0105180:	5e                   	pop    %esi
f0105181:	5f                   	pop    %edi
f0105182:	5d                   	pop    %ebp
f0105183:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105184:	83 ec 08             	sub    $0x8,%esp
f0105187:	53                   	push   %ebx
f0105188:	68 5f 7a 10 f0       	push   $0xf0107a5f
f010518d:	e8 7b e6 ff ff       	call   f010380d <cprintf>
f0105192:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105195:	b8 00 00 00 00       	mov    $0x0,%eax
f010519a:	eb e0                	jmp    f010517c <readline+0x41>
			if (echoing)
f010519c:	85 ff                	test   %edi,%edi
f010519e:	75 05                	jne    f01051a5 <readline+0x6a>
			i--;
f01051a0:	83 ee 01             	sub    $0x1,%esi
f01051a3:	eb 18                	jmp    f01051bd <readline+0x82>
				cputchar('\b');
f01051a5:	83 ec 0c             	sub    $0xc,%esp
f01051a8:	6a 08                	push   $0x8
f01051aa:	e8 ce b5 ff ff       	call   f010077d <cputchar>
f01051af:	83 c4 10             	add    $0x10,%esp
f01051b2:	eb ec                	jmp    f01051a0 <readline+0x65>
			buf[i++] = c;
f01051b4:	88 9e a0 ba 1e f0    	mov    %bl,-0xfe14560(%esi)
f01051ba:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01051bd:	e8 cb b5 ff ff       	call   f010078d <getchar>
f01051c2:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01051c4:	85 c0                	test   %eax,%eax
f01051c6:	78 aa                	js     f0105172 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01051c8:	83 f8 08             	cmp    $0x8,%eax
f01051cb:	0f 94 c0             	sete   %al
f01051ce:	83 fb 7f             	cmp    $0x7f,%ebx
f01051d1:	0f 94 c2             	sete   %dl
f01051d4:	08 d0                	or     %dl,%al
f01051d6:	74 04                	je     f01051dc <readline+0xa1>
f01051d8:	85 f6                	test   %esi,%esi
f01051da:	7f c0                	jg     f010519c <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01051dc:	83 fb 1f             	cmp    $0x1f,%ebx
f01051df:	7e 1a                	jle    f01051fb <readline+0xc0>
f01051e1:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01051e7:	7f 12                	jg     f01051fb <readline+0xc0>
			if (echoing)
f01051e9:	85 ff                	test   %edi,%edi
f01051eb:	74 c7                	je     f01051b4 <readline+0x79>
				cputchar(c);
f01051ed:	83 ec 0c             	sub    $0xc,%esp
f01051f0:	53                   	push   %ebx
f01051f1:	e8 87 b5 ff ff       	call   f010077d <cputchar>
f01051f6:	83 c4 10             	add    $0x10,%esp
f01051f9:	eb b9                	jmp    f01051b4 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01051fb:	83 fb 0a             	cmp    $0xa,%ebx
f01051fe:	74 05                	je     f0105205 <readline+0xca>
f0105200:	83 fb 0d             	cmp    $0xd,%ebx
f0105203:	75 b8                	jne    f01051bd <readline+0x82>
			if (echoing)
f0105205:	85 ff                	test   %edi,%edi
f0105207:	75 11                	jne    f010521a <readline+0xdf>
			buf[i] = 0;
f0105209:	c6 86 a0 ba 1e f0 00 	movb   $0x0,-0xfe14560(%esi)
			return buf;
f0105210:	b8 a0 ba 1e f0       	mov    $0xf01ebaa0,%eax
f0105215:	e9 62 ff ff ff       	jmp    f010517c <readline+0x41>
				cputchar('\n');
f010521a:	83 ec 0c             	sub    $0xc,%esp
f010521d:	6a 0a                	push   $0xa
f010521f:	e8 59 b5 ff ff       	call   f010077d <cputchar>
f0105224:	83 c4 10             	add    $0x10,%esp
f0105227:	eb e0                	jmp    f0105209 <readline+0xce>

f0105229 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105229:	55                   	push   %ebp
f010522a:	89 e5                	mov    %esp,%ebp
f010522c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010522f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105234:	eb 03                	jmp    f0105239 <strlen+0x10>
		n++;
f0105236:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0105239:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010523d:	75 f7                	jne    f0105236 <strlen+0xd>
	return n;
}
f010523f:	5d                   	pop    %ebp
f0105240:	c3                   	ret    

f0105241 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105241:	55                   	push   %ebp
f0105242:	89 e5                	mov    %esp,%ebp
f0105244:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105247:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010524a:	b8 00 00 00 00       	mov    $0x0,%eax
f010524f:	eb 03                	jmp    f0105254 <strnlen+0x13>
		n++;
f0105251:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105254:	39 d0                	cmp    %edx,%eax
f0105256:	74 08                	je     f0105260 <strnlen+0x1f>
f0105258:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010525c:	75 f3                	jne    f0105251 <strnlen+0x10>
f010525e:	89 c2                	mov    %eax,%edx
	return n;
}
f0105260:	89 d0                	mov    %edx,%eax
f0105262:	5d                   	pop    %ebp
f0105263:	c3                   	ret    

f0105264 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105264:	55                   	push   %ebp
f0105265:	89 e5                	mov    %esp,%ebp
f0105267:	53                   	push   %ebx
f0105268:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010526b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010526e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105273:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105277:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010527a:	83 c0 01             	add    $0x1,%eax
f010527d:	84 d2                	test   %dl,%dl
f010527f:	75 f2                	jne    f0105273 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0105281:	89 c8                	mov    %ecx,%eax
f0105283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105286:	c9                   	leave  
f0105287:	c3                   	ret    

f0105288 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105288:	55                   	push   %ebp
f0105289:	89 e5                	mov    %esp,%ebp
f010528b:	53                   	push   %ebx
f010528c:	83 ec 10             	sub    $0x10,%esp
f010528f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105292:	53                   	push   %ebx
f0105293:	e8 91 ff ff ff       	call   f0105229 <strlen>
f0105298:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f010529b:	ff 75 0c             	push   0xc(%ebp)
f010529e:	01 d8                	add    %ebx,%eax
f01052a0:	50                   	push   %eax
f01052a1:	e8 be ff ff ff       	call   f0105264 <strcpy>
	return dst;
}
f01052a6:	89 d8                	mov    %ebx,%eax
f01052a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01052ab:	c9                   	leave  
f01052ac:	c3                   	ret    

f01052ad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01052ad:	55                   	push   %ebp
f01052ae:	89 e5                	mov    %esp,%ebp
f01052b0:	56                   	push   %esi
f01052b1:	53                   	push   %ebx
f01052b2:	8b 75 08             	mov    0x8(%ebp),%esi
f01052b5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01052b8:	89 f3                	mov    %esi,%ebx
f01052ba:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01052bd:	89 f0                	mov    %esi,%eax
f01052bf:	eb 0f                	jmp    f01052d0 <strncpy+0x23>
		*dst++ = *src;
f01052c1:	83 c0 01             	add    $0x1,%eax
f01052c4:	0f b6 0a             	movzbl (%edx),%ecx
f01052c7:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01052ca:	80 f9 01             	cmp    $0x1,%cl
f01052cd:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
f01052d0:	39 d8                	cmp    %ebx,%eax
f01052d2:	75 ed                	jne    f01052c1 <strncpy+0x14>
	}
	return ret;
}
f01052d4:	89 f0                	mov    %esi,%eax
f01052d6:	5b                   	pop    %ebx
f01052d7:	5e                   	pop    %esi
f01052d8:	5d                   	pop    %ebp
f01052d9:	c3                   	ret    

f01052da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01052da:	55                   	push   %ebp
f01052db:	89 e5                	mov    %esp,%ebp
f01052dd:	56                   	push   %esi
f01052de:	53                   	push   %ebx
f01052df:	8b 75 08             	mov    0x8(%ebp),%esi
f01052e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01052e5:	8b 55 10             	mov    0x10(%ebp),%edx
f01052e8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01052ea:	85 d2                	test   %edx,%edx
f01052ec:	74 21                	je     f010530f <strlcpy+0x35>
f01052ee:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01052f2:	89 f2                	mov    %esi,%edx
f01052f4:	eb 09                	jmp    f01052ff <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01052f6:	83 c1 01             	add    $0x1,%ecx
f01052f9:	83 c2 01             	add    $0x1,%edx
f01052fc:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
f01052ff:	39 c2                	cmp    %eax,%edx
f0105301:	74 09                	je     f010530c <strlcpy+0x32>
f0105303:	0f b6 19             	movzbl (%ecx),%ebx
f0105306:	84 db                	test   %bl,%bl
f0105308:	75 ec                	jne    f01052f6 <strlcpy+0x1c>
f010530a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f010530c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010530f:	29 f0                	sub    %esi,%eax
}
f0105311:	5b                   	pop    %ebx
f0105312:	5e                   	pop    %esi
f0105313:	5d                   	pop    %ebp
f0105314:	c3                   	ret    

f0105315 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105315:	55                   	push   %ebp
f0105316:	89 e5                	mov    %esp,%ebp
f0105318:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010531b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010531e:	eb 06                	jmp    f0105326 <strcmp+0x11>
		p++, q++;
f0105320:	83 c1 01             	add    $0x1,%ecx
f0105323:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0105326:	0f b6 01             	movzbl (%ecx),%eax
f0105329:	84 c0                	test   %al,%al
f010532b:	74 04                	je     f0105331 <strcmp+0x1c>
f010532d:	3a 02                	cmp    (%edx),%al
f010532f:	74 ef                	je     f0105320 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105331:	0f b6 c0             	movzbl %al,%eax
f0105334:	0f b6 12             	movzbl (%edx),%edx
f0105337:	29 d0                	sub    %edx,%eax
}
f0105339:	5d                   	pop    %ebp
f010533a:	c3                   	ret    

f010533b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010533b:	55                   	push   %ebp
f010533c:	89 e5                	mov    %esp,%ebp
f010533e:	53                   	push   %ebx
f010533f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105342:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105345:	89 c3                	mov    %eax,%ebx
f0105347:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010534a:	eb 06                	jmp    f0105352 <strncmp+0x17>
		n--, p++, q++;
f010534c:	83 c0 01             	add    $0x1,%eax
f010534f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105352:	39 d8                	cmp    %ebx,%eax
f0105354:	74 18                	je     f010536e <strncmp+0x33>
f0105356:	0f b6 08             	movzbl (%eax),%ecx
f0105359:	84 c9                	test   %cl,%cl
f010535b:	74 04                	je     f0105361 <strncmp+0x26>
f010535d:	3a 0a                	cmp    (%edx),%cl
f010535f:	74 eb                	je     f010534c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105361:	0f b6 00             	movzbl (%eax),%eax
f0105364:	0f b6 12             	movzbl (%edx),%edx
f0105367:	29 d0                	sub    %edx,%eax
}
f0105369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010536c:	c9                   	leave  
f010536d:	c3                   	ret    
		return 0;
f010536e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105373:	eb f4                	jmp    f0105369 <strncmp+0x2e>

f0105375 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105375:	55                   	push   %ebp
f0105376:	89 e5                	mov    %esp,%ebp
f0105378:	8b 45 08             	mov    0x8(%ebp),%eax
f010537b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010537f:	eb 03                	jmp    f0105384 <strchr+0xf>
f0105381:	83 c0 01             	add    $0x1,%eax
f0105384:	0f b6 10             	movzbl (%eax),%edx
f0105387:	84 d2                	test   %dl,%dl
f0105389:	74 06                	je     f0105391 <strchr+0x1c>
		if (*s == c)
f010538b:	38 ca                	cmp    %cl,%dl
f010538d:	75 f2                	jne    f0105381 <strchr+0xc>
f010538f:	eb 05                	jmp    f0105396 <strchr+0x21>
			return (char *) s;
	return 0;
f0105391:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105396:	5d                   	pop    %ebp
f0105397:	c3                   	ret    

f0105398 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105398:	55                   	push   %ebp
f0105399:	89 e5                	mov    %esp,%ebp
f010539b:	8b 45 08             	mov    0x8(%ebp),%eax
f010539e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01053a2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01053a5:	38 ca                	cmp    %cl,%dl
f01053a7:	74 09                	je     f01053b2 <strfind+0x1a>
f01053a9:	84 d2                	test   %dl,%dl
f01053ab:	74 05                	je     f01053b2 <strfind+0x1a>
	for (; *s; s++)
f01053ad:	83 c0 01             	add    $0x1,%eax
f01053b0:	eb f0                	jmp    f01053a2 <strfind+0xa>
			break;
	return (char *) s;
}
f01053b2:	5d                   	pop    %ebp
f01053b3:	c3                   	ret    

f01053b4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01053b4:	55                   	push   %ebp
f01053b5:	89 e5                	mov    %esp,%ebp
f01053b7:	57                   	push   %edi
f01053b8:	56                   	push   %esi
f01053b9:	53                   	push   %ebx
f01053ba:	8b 7d 08             	mov    0x8(%ebp),%edi
f01053bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01053c0:	85 c9                	test   %ecx,%ecx
f01053c2:	74 2f                	je     f01053f3 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01053c4:	89 f8                	mov    %edi,%eax
f01053c6:	09 c8                	or     %ecx,%eax
f01053c8:	a8 03                	test   $0x3,%al
f01053ca:	75 21                	jne    f01053ed <memset+0x39>
		c &= 0xFF;
f01053cc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01053d0:	89 d0                	mov    %edx,%eax
f01053d2:	c1 e0 08             	shl    $0x8,%eax
f01053d5:	89 d3                	mov    %edx,%ebx
f01053d7:	c1 e3 18             	shl    $0x18,%ebx
f01053da:	89 d6                	mov    %edx,%esi
f01053dc:	c1 e6 10             	shl    $0x10,%esi
f01053df:	09 f3                	or     %esi,%ebx
f01053e1:	09 da                	or     %ebx,%edx
f01053e3:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01053e5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01053e8:	fc                   	cld    
f01053e9:	f3 ab                	rep stos %eax,%es:(%edi)
f01053eb:	eb 06                	jmp    f01053f3 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01053ed:	8b 45 0c             	mov    0xc(%ebp),%eax
f01053f0:	fc                   	cld    
f01053f1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01053f3:	89 f8                	mov    %edi,%eax
f01053f5:	5b                   	pop    %ebx
f01053f6:	5e                   	pop    %esi
f01053f7:	5f                   	pop    %edi
f01053f8:	5d                   	pop    %ebp
f01053f9:	c3                   	ret    

f01053fa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01053fa:	55                   	push   %ebp
f01053fb:	89 e5                	mov    %esp,%ebp
f01053fd:	57                   	push   %edi
f01053fe:	56                   	push   %esi
f01053ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0105402:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105405:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105408:	39 c6                	cmp    %eax,%esi
f010540a:	73 32                	jae    f010543e <memmove+0x44>
f010540c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010540f:	39 c2                	cmp    %eax,%edx
f0105411:	76 2b                	jbe    f010543e <memmove+0x44>
		s += n;
		d += n;
f0105413:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105416:	89 d6                	mov    %edx,%esi
f0105418:	09 fe                	or     %edi,%esi
f010541a:	09 ce                	or     %ecx,%esi
f010541c:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105422:	75 0e                	jne    f0105432 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105424:	83 ef 04             	sub    $0x4,%edi
f0105427:	8d 72 fc             	lea    -0x4(%edx),%esi
f010542a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010542d:	fd                   	std    
f010542e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105430:	eb 09                	jmp    f010543b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105432:	83 ef 01             	sub    $0x1,%edi
f0105435:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105438:	fd                   	std    
f0105439:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010543b:	fc                   	cld    
f010543c:	eb 1a                	jmp    f0105458 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010543e:	89 f2                	mov    %esi,%edx
f0105440:	09 c2                	or     %eax,%edx
f0105442:	09 ca                	or     %ecx,%edx
f0105444:	f6 c2 03             	test   $0x3,%dl
f0105447:	75 0a                	jne    f0105453 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105449:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010544c:	89 c7                	mov    %eax,%edi
f010544e:	fc                   	cld    
f010544f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105451:	eb 05                	jmp    f0105458 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0105453:	89 c7                	mov    %eax,%edi
f0105455:	fc                   	cld    
f0105456:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105458:	5e                   	pop    %esi
f0105459:	5f                   	pop    %edi
f010545a:	5d                   	pop    %ebp
f010545b:	c3                   	ret    

f010545c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010545c:	55                   	push   %ebp
f010545d:	89 e5                	mov    %esp,%ebp
f010545f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105462:	ff 75 10             	push   0x10(%ebp)
f0105465:	ff 75 0c             	push   0xc(%ebp)
f0105468:	ff 75 08             	push   0x8(%ebp)
f010546b:	e8 8a ff ff ff       	call   f01053fa <memmove>
}
f0105470:	c9                   	leave  
f0105471:	c3                   	ret    

f0105472 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105472:	55                   	push   %ebp
f0105473:	89 e5                	mov    %esp,%ebp
f0105475:	56                   	push   %esi
f0105476:	53                   	push   %ebx
f0105477:	8b 45 08             	mov    0x8(%ebp),%eax
f010547a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010547d:	89 c6                	mov    %eax,%esi
f010547f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105482:	eb 06                	jmp    f010548a <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105484:	83 c0 01             	add    $0x1,%eax
f0105487:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
f010548a:	39 f0                	cmp    %esi,%eax
f010548c:	74 14                	je     f01054a2 <memcmp+0x30>
		if (*s1 != *s2)
f010548e:	0f b6 08             	movzbl (%eax),%ecx
f0105491:	0f b6 1a             	movzbl (%edx),%ebx
f0105494:	38 d9                	cmp    %bl,%cl
f0105496:	74 ec                	je     f0105484 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
f0105498:	0f b6 c1             	movzbl %cl,%eax
f010549b:	0f b6 db             	movzbl %bl,%ebx
f010549e:	29 d8                	sub    %ebx,%eax
f01054a0:	eb 05                	jmp    f01054a7 <memcmp+0x35>
	}

	return 0;
f01054a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01054a7:	5b                   	pop    %ebx
f01054a8:	5e                   	pop    %esi
f01054a9:	5d                   	pop    %ebp
f01054aa:	c3                   	ret    

f01054ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01054ab:	55                   	push   %ebp
f01054ac:	89 e5                	mov    %esp,%ebp
f01054ae:	8b 45 08             	mov    0x8(%ebp),%eax
f01054b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01054b4:	89 c2                	mov    %eax,%edx
f01054b6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01054b9:	eb 03                	jmp    f01054be <memfind+0x13>
f01054bb:	83 c0 01             	add    $0x1,%eax
f01054be:	39 d0                	cmp    %edx,%eax
f01054c0:	73 04                	jae    f01054c6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01054c2:	38 08                	cmp    %cl,(%eax)
f01054c4:	75 f5                	jne    f01054bb <memfind+0x10>
			break;
	return (void *) s;
}
f01054c6:	5d                   	pop    %ebp
f01054c7:	c3                   	ret    

f01054c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01054c8:	55                   	push   %ebp
f01054c9:	89 e5                	mov    %esp,%ebp
f01054cb:	57                   	push   %edi
f01054cc:	56                   	push   %esi
f01054cd:	53                   	push   %ebx
f01054ce:	8b 55 08             	mov    0x8(%ebp),%edx
f01054d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01054d4:	eb 03                	jmp    f01054d9 <strtol+0x11>
		s++;
f01054d6:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
f01054d9:	0f b6 02             	movzbl (%edx),%eax
f01054dc:	3c 20                	cmp    $0x20,%al
f01054de:	74 f6                	je     f01054d6 <strtol+0xe>
f01054e0:	3c 09                	cmp    $0x9,%al
f01054e2:	74 f2                	je     f01054d6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01054e4:	3c 2b                	cmp    $0x2b,%al
f01054e6:	74 2a                	je     f0105512 <strtol+0x4a>
	int neg = 0;
f01054e8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01054ed:	3c 2d                	cmp    $0x2d,%al
f01054ef:	74 2b                	je     f010551c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01054f1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01054f7:	75 0f                	jne    f0105508 <strtol+0x40>
f01054f9:	80 3a 30             	cmpb   $0x30,(%edx)
f01054fc:	74 28                	je     f0105526 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01054fe:	85 db                	test   %ebx,%ebx
f0105500:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105505:	0f 44 d8             	cmove  %eax,%ebx
f0105508:	b9 00 00 00 00       	mov    $0x0,%ecx
f010550d:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105510:	eb 46                	jmp    f0105558 <strtol+0x90>
		s++;
f0105512:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
f0105515:	bf 00 00 00 00       	mov    $0x0,%edi
f010551a:	eb d5                	jmp    f01054f1 <strtol+0x29>
		s++, neg = 1;
f010551c:	83 c2 01             	add    $0x1,%edx
f010551f:	bf 01 00 00 00       	mov    $0x1,%edi
f0105524:	eb cb                	jmp    f01054f1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105526:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f010552a:	74 0e                	je     f010553a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010552c:	85 db                	test   %ebx,%ebx
f010552e:	75 d8                	jne    f0105508 <strtol+0x40>
		s++, base = 8;
f0105530:	83 c2 01             	add    $0x1,%edx
f0105533:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105538:	eb ce                	jmp    f0105508 <strtol+0x40>
		s += 2, base = 16;
f010553a:	83 c2 02             	add    $0x2,%edx
f010553d:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105542:	eb c4                	jmp    f0105508 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105544:	0f be c0             	movsbl %al,%eax
f0105547:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010554a:	3b 45 10             	cmp    0x10(%ebp),%eax
f010554d:	7d 3a                	jge    f0105589 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010554f:	83 c2 01             	add    $0x1,%edx
f0105552:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0105556:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
f0105558:	0f b6 02             	movzbl (%edx),%eax
f010555b:	8d 70 d0             	lea    -0x30(%eax),%esi
f010555e:	89 f3                	mov    %esi,%ebx
f0105560:	80 fb 09             	cmp    $0x9,%bl
f0105563:	76 df                	jbe    f0105544 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
f0105565:	8d 70 9f             	lea    -0x61(%eax),%esi
f0105568:	89 f3                	mov    %esi,%ebx
f010556a:	80 fb 19             	cmp    $0x19,%bl
f010556d:	77 08                	ja     f0105577 <strtol+0xaf>
			dig = *s - 'a' + 10;
f010556f:	0f be c0             	movsbl %al,%eax
f0105572:	83 e8 57             	sub    $0x57,%eax
f0105575:	eb d3                	jmp    f010554a <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
f0105577:	8d 70 bf             	lea    -0x41(%eax),%esi
f010557a:	89 f3                	mov    %esi,%ebx
f010557c:	80 fb 19             	cmp    $0x19,%bl
f010557f:	77 08                	ja     f0105589 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0105581:	0f be c0             	movsbl %al,%eax
f0105584:	83 e8 37             	sub    $0x37,%eax
f0105587:	eb c1                	jmp    f010554a <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105589:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010558d:	74 05                	je     f0105594 <strtol+0xcc>
		*endptr = (char *) s;
f010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105592:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f0105594:	89 c8                	mov    %ecx,%eax
f0105596:	f7 d8                	neg    %eax
f0105598:	85 ff                	test   %edi,%edi
f010559a:	0f 45 c8             	cmovne %eax,%ecx
}
f010559d:	89 c8                	mov    %ecx,%eax
f010559f:	5b                   	pop    %ebx
f01055a0:	5e                   	pop    %esi
f01055a1:	5f                   	pop    %edi
f01055a2:	5d                   	pop    %ebp
f01055a3:	c3                   	ret    

f01055a4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01055a4:	fa                   	cli    

	xorw    %ax, %ax
f01055a5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01055a7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01055a9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01055ab:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01055ad:	0f 01 16             	lgdtl  (%esi)
f01055b0:	74 70                	je     f0105622 <mpsearch1+0x3>
	movl    %cr0, %eax
f01055b2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01055b5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01055b9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01055bc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01055c2:	08 00                	or     %al,(%eax)

f01055c4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01055c4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01055c8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01055ca:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01055cc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01055ce:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01055d2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01055d4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01055d6:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl    %eax, %cr3
f01055db:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01055de:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01055e1:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01055e6:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01055e9:	8b 25 04 b0 1e f0    	mov    0xf01eb004,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01055ef:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01055f4:	b8 b8 01 10 f0       	mov    $0xf01001b8,%eax
	call    *%eax
f01055f9:	ff d0                	call   *%eax

f01055fb <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01055fb:	eb fe                	jmp    f01055fb <spin>
f01055fd:	8d 76 00             	lea    0x0(%esi),%esi

f0105600 <gdt>:
	...
f0105608:	ff                   	(bad)  
f0105609:	ff 00                	incl   (%eax)
f010560b:	00 00                	add    %al,(%eax)
f010560d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105614:	00                   	.byte 0x0
f0105615:	92                   	xchg   %eax,%edx
f0105616:	cf                   	iret   
	...

f0105618 <gdtdesc>:
f0105618:	17                   	pop    %ss
f0105619:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f010561e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f010561e:	90                   	nop

f010561f <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f010561f:	55                   	push   %ebp
f0105620:	89 e5                	mov    %esp,%ebp
f0105622:	57                   	push   %edi
f0105623:	56                   	push   %esi
f0105624:	53                   	push   %ebx
f0105625:	83 ec 1c             	sub    $0x1c,%esp
f0105628:	89 c6                	mov    %eax,%esi
	if (PGNUM(pa) >= npages)
f010562a:	8b 0d 60 b2 1e f0    	mov    0xf01eb260,%ecx
f0105630:	c1 e8 0c             	shr    $0xc,%eax
f0105633:	39 c8                	cmp    %ecx,%eax
f0105635:	73 22                	jae    f0105659 <mpsearch1+0x3a>
	return (void *)(pa + KERNBASE);
f0105637:	8d be 00 00 00 f0    	lea    -0x10000000(%esi),%edi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f010563d:	8d 04 32             	lea    (%edx,%esi,1),%eax
	if (PGNUM(pa) >= npages)
f0105640:	89 c2                	mov    %eax,%edx
f0105642:	c1 ea 0c             	shr    $0xc,%edx
f0105645:	39 ca                	cmp    %ecx,%edx
f0105647:	73 22                	jae    f010566b <mpsearch1+0x4c>
	return (void *)(pa + KERNBASE);
f0105649:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010564e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105651:	81 ee f0 ff ff 0f    	sub    $0xffffff0,%esi

	for (; mp < end; mp++)
f0105657:	eb 2a                	jmp    f0105683 <mpsearch1+0x64>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105659:	56                   	push   %esi
f010565a:	68 04 60 10 f0       	push   $0xf0106004
f010565f:	6a 57                	push   $0x57
f0105661:	68 fd 7b 10 f0       	push   $0xf0107bfd
f0105666:	e8 d5 a9 ff ff       	call   f0100040 <_panic>
f010566b:	50                   	push   %eax
f010566c:	68 04 60 10 f0       	push   $0xf0106004
f0105671:	6a 57                	push   $0x57
f0105673:	68 fd 7b 10 f0       	push   $0xf0107bfd
f0105678:	e8 c3 a9 ff ff       	call   f0100040 <_panic>
f010567d:	83 c7 10             	add    $0x10,%edi
f0105680:	83 c6 10             	add    $0x10,%esi
f0105683:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f0105686:	73 2b                	jae    f01056b3 <mpsearch1+0x94>
f0105688:	89 fb                	mov    %edi,%ebx
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010568a:	83 ec 04             	sub    $0x4,%esp
f010568d:	6a 04                	push   $0x4
f010568f:	68 0d 7c 10 f0       	push   $0xf0107c0d
f0105694:	57                   	push   %edi
f0105695:	e8 d8 fd ff ff       	call   f0105472 <memcmp>
f010569a:	83 c4 10             	add    $0x10,%esp
f010569d:	85 c0                	test   %eax,%eax
f010569f:	75 dc                	jne    f010567d <mpsearch1+0x5e>
		sum += ((uint8_t *)addr)[i];
f01056a1:	0f b6 13             	movzbl (%ebx),%edx
f01056a4:	01 d0                	add    %edx,%eax
	for (i = 0; i < len; i++)
f01056a6:	83 c3 01             	add    $0x1,%ebx
f01056a9:	39 f3                	cmp    %esi,%ebx
f01056ab:	75 f4                	jne    f01056a1 <mpsearch1+0x82>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01056ad:	84 c0                	test   %al,%al
f01056af:	75 cc                	jne    f010567d <mpsearch1+0x5e>
f01056b1:	eb 05                	jmp    f01056b8 <mpsearch1+0x99>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01056b3:	bf 00 00 00 00       	mov    $0x0,%edi
}
f01056b8:	89 f8                	mov    %edi,%eax
f01056ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01056bd:	5b                   	pop    %ebx
f01056be:	5e                   	pop    %esi
f01056bf:	5f                   	pop    %edi
f01056c0:	5d                   	pop    %ebp
f01056c1:	c3                   	ret    

f01056c2 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01056c2:	55                   	push   %ebp
f01056c3:	89 e5                	mov    %esp,%ebp
f01056c5:	57                   	push   %edi
f01056c6:	56                   	push   %esi
f01056c7:	53                   	push   %ebx
f01056c8:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01056cb:	c7 05 08 c0 22 f0 20 	movl   $0xf022c020,0xf022c008
f01056d2:	c0 22 f0 
	if (PGNUM(pa) >= npages)
f01056d5:	83 3d 60 b2 1e f0 00 	cmpl   $0x0,0xf01eb260
f01056dc:	0f 84 86 00 00 00    	je     f0105768 <mp_init+0xa6>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01056e2:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01056e9:	85 c0                	test   %eax,%eax
f01056eb:	0f 84 8d 00 00 00    	je     f010577e <mp_init+0xbc>
		p <<= 4;	// Translate from segment to PA
f01056f1:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01056f4:	ba 00 04 00 00       	mov    $0x400,%edx
f01056f9:	e8 21 ff ff ff       	call   f010561f <mpsearch1>
f01056fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105701:	85 c0                	test   %eax,%eax
f0105703:	75 1a                	jne    f010571f <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0105705:	ba 00 00 01 00       	mov    $0x10000,%edx
f010570a:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f010570f:	e8 0b ff ff ff       	call   f010561f <mpsearch1>
f0105714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105717:	85 c0                	test   %eax,%eax
f0105719:	0f 84 20 02 00 00    	je     f010593f <mp_init+0x27d>
	if (mp->physaddr == 0 || mp->type != 0) {
f010571f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105722:	8b 58 04             	mov    0x4(%eax),%ebx
f0105725:	85 db                	test   %ebx,%ebx
f0105727:	74 7a                	je     f01057a3 <mp_init+0xe1>
f0105729:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f010572d:	75 74                	jne    f01057a3 <mp_init+0xe1>
f010572f:	89 d8                	mov    %ebx,%eax
f0105731:	c1 e8 0c             	shr    $0xc,%eax
f0105734:	3b 05 60 b2 1e f0    	cmp    0xf01eb260,%eax
f010573a:	73 7c                	jae    f01057b8 <mp_init+0xf6>
	return (void *)(pa + KERNBASE);
f010573c:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105742:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105744:	83 ec 04             	sub    $0x4,%esp
f0105747:	6a 04                	push   $0x4
f0105749:	68 12 7c 10 f0       	push   $0xf0107c12
f010574e:	53                   	push   %ebx
f010574f:	e8 1e fd ff ff       	call   f0105472 <memcmp>
f0105754:	83 c4 10             	add    $0x10,%esp
f0105757:	85 c0                	test   %eax,%eax
f0105759:	75 72                	jne    f01057cd <mp_init+0x10b>
f010575b:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f010575f:	01 df                	add    %ebx,%edi
	sum = 0;
f0105761:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105763:	e9 82 00 00 00       	jmp    f01057ea <mp_init+0x128>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105768:	68 00 04 00 00       	push   $0x400
f010576d:	68 04 60 10 f0       	push   $0xf0106004
f0105772:	6a 6f                	push   $0x6f
f0105774:	68 fd 7b 10 f0       	push   $0xf0107bfd
f0105779:	e8 c2 a8 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010577e:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105785:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105788:	2d 00 04 00 00       	sub    $0x400,%eax
f010578d:	ba 00 04 00 00       	mov    $0x400,%edx
f0105792:	e8 88 fe ff ff       	call   f010561f <mpsearch1>
f0105797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010579a:	85 c0                	test   %eax,%eax
f010579c:	75 81                	jne    f010571f <mp_init+0x5d>
f010579e:	e9 62 ff ff ff       	jmp    f0105705 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01057a3:	83 ec 0c             	sub    $0xc,%esp
f01057a6:	68 70 7a 10 f0       	push   $0xf0107a70
f01057ab:	e8 5d e0 ff ff       	call   f010380d <cprintf>
		return NULL;
f01057b0:	83 c4 10             	add    $0x10,%esp
f01057b3:	e9 87 01 00 00       	jmp    f010593f <mp_init+0x27d>
f01057b8:	53                   	push   %ebx
f01057b9:	68 04 60 10 f0       	push   $0xf0106004
f01057be:	68 90 00 00 00       	push   $0x90
f01057c3:	68 fd 7b 10 f0       	push   $0xf0107bfd
f01057c8:	e8 73 a8 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01057cd:	83 ec 0c             	sub    $0xc,%esp
f01057d0:	68 a0 7a 10 f0       	push   $0xf0107aa0
f01057d5:	e8 33 e0 ff ff       	call   f010380d <cprintf>
		return NULL;
f01057da:	83 c4 10             	add    $0x10,%esp
f01057dd:	e9 5d 01 00 00       	jmp    f010593f <mp_init+0x27d>
		sum += ((uint8_t *)addr)[i];
f01057e2:	0f b6 0b             	movzbl (%ebx),%ecx
f01057e5:	01 ca                	add    %ecx,%edx
f01057e7:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f01057ea:	39 fb                	cmp    %edi,%ebx
f01057ec:	75 f4                	jne    f01057e2 <mp_init+0x120>
	if (sum(conf, conf->length) != 0) {
f01057ee:	84 d2                	test   %dl,%dl
f01057f0:	75 16                	jne    f0105808 <mp_init+0x146>
	if (conf->version != 1 && conf->version != 4) {
f01057f2:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f01057f6:	80 fa 01             	cmp    $0x1,%dl
f01057f9:	74 05                	je     f0105800 <mp_init+0x13e>
f01057fb:	80 fa 04             	cmp    $0x4,%dl
f01057fe:	75 1d                	jne    f010581d <mp_init+0x15b>
f0105800:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105804:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0105806:	eb 36                	jmp    f010583e <mp_init+0x17c>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105808:	83 ec 0c             	sub    $0xc,%esp
f010580b:	68 d4 7a 10 f0       	push   $0xf0107ad4
f0105810:	e8 f8 df ff ff       	call   f010380d <cprintf>
		return NULL;
f0105815:	83 c4 10             	add    $0x10,%esp
f0105818:	e9 22 01 00 00       	jmp    f010593f <mp_init+0x27d>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f010581d:	83 ec 08             	sub    $0x8,%esp
f0105820:	0f b6 d2             	movzbl %dl,%edx
f0105823:	52                   	push   %edx
f0105824:	68 f8 7a 10 f0       	push   $0xf0107af8
f0105829:	e8 df df ff ff       	call   f010380d <cprintf>
		return NULL;
f010582e:	83 c4 10             	add    $0x10,%esp
f0105831:	e9 09 01 00 00       	jmp    f010593f <mp_init+0x27d>
		sum += ((uint8_t *)addr)[i];
f0105836:	0f b6 13             	movzbl (%ebx),%edx
f0105839:	01 d0                	add    %edx,%eax
f010583b:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f010583e:	39 d9                	cmp    %ebx,%ecx
f0105840:	75 f4                	jne    f0105836 <mp_init+0x174>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105842:	02 46 2a             	add    0x2a(%esi),%al
f0105845:	75 1c                	jne    f0105863 <mp_init+0x1a1>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0105847:	c7 05 04 c0 22 f0 01 	movl   $0x1,0xf022c004
f010584e:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105851:	8b 46 24             	mov    0x24(%esi),%eax
f0105854:	a3 c4 c3 22 f0       	mov    %eax,0xf022c3c4

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105859:	8d 7e 2c             	lea    0x2c(%esi),%edi
f010585c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105861:	eb 4d                	jmp    f01058b0 <mp_init+0x1ee>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105863:	83 ec 0c             	sub    $0xc,%esp
f0105866:	68 18 7b 10 f0       	push   $0xf0107b18
f010586b:	e8 9d df ff ff       	call   f010380d <cprintf>
		return NULL;
f0105870:	83 c4 10             	add    $0x10,%esp
f0105873:	e9 c7 00 00 00       	jmp    f010593f <mp_init+0x27d>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105878:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f010587c:	74 11                	je     f010588f <mp_init+0x1cd>
				bootcpu = &cpus[ncpu];
f010587e:	6b 05 00 c0 22 f0 74 	imul   $0x74,0xf022c000,%eax
f0105885:	05 20 c0 22 f0       	add    $0xf022c020,%eax
f010588a:	a3 08 c0 22 f0       	mov    %eax,0xf022c008
			if (ncpu < NCPU) {
f010588f:	a1 00 c0 22 f0       	mov    0xf022c000,%eax
f0105894:	83 f8 07             	cmp    $0x7,%eax
f0105897:	7f 33                	jg     f01058cc <mp_init+0x20a>
				cpus[ncpu].cpu_id = ncpu;
f0105899:	6b d0 74             	imul   $0x74,%eax,%edx
f010589c:	88 82 20 c0 22 f0    	mov    %al,-0xfdd3fe0(%edx)
				ncpu++;
f01058a2:	83 c0 01             	add    $0x1,%eax
f01058a5:	a3 00 c0 22 f0       	mov    %eax,0xf022c000
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01058aa:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01058ad:	83 c3 01             	add    $0x1,%ebx
f01058b0:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01058b4:	39 d8                	cmp    %ebx,%eax
f01058b6:	76 4f                	jbe    f0105907 <mp_init+0x245>
		switch (*p) {
f01058b8:	0f b6 07             	movzbl (%edi),%eax
f01058bb:	84 c0                	test   %al,%al
f01058bd:	74 b9                	je     f0105878 <mp_init+0x1b6>
f01058bf:	8d 50 ff             	lea    -0x1(%eax),%edx
f01058c2:	80 fa 03             	cmp    $0x3,%dl
f01058c5:	77 1c                	ja     f01058e3 <mp_init+0x221>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01058c7:	83 c7 08             	add    $0x8,%edi
			continue;
f01058ca:	eb e1                	jmp    f01058ad <mp_init+0x1eb>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01058cc:	83 ec 08             	sub    $0x8,%esp
f01058cf:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01058d3:	50                   	push   %eax
f01058d4:	68 48 7b 10 f0       	push   $0xf0107b48
f01058d9:	e8 2f df ff ff       	call   f010380d <cprintf>
f01058de:	83 c4 10             	add    $0x10,%esp
f01058e1:	eb c7                	jmp    f01058aa <mp_init+0x1e8>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f01058e3:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f01058e6:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f01058e9:	50                   	push   %eax
f01058ea:	68 70 7b 10 f0       	push   $0xf0107b70
f01058ef:	e8 19 df ff ff       	call   f010380d <cprintf>
			ismp = 0;
f01058f4:	c7 05 04 c0 22 f0 00 	movl   $0x0,0xf022c004
f01058fb:	00 00 00 
			i = conf->entry;
f01058fe:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105902:	83 c4 10             	add    $0x10,%esp
f0105905:	eb a6                	jmp    f01058ad <mp_init+0x1eb>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105907:	a1 08 c0 22 f0       	mov    0xf022c008,%eax
f010590c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105913:	83 3d 04 c0 22 f0 00 	cmpl   $0x0,0xf022c004
f010591a:	74 2b                	je     f0105947 <mp_init+0x285>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010591c:	83 ec 04             	sub    $0x4,%esp
f010591f:	ff 35 00 c0 22 f0    	push   0xf022c000
f0105925:	0f b6 00             	movzbl (%eax),%eax
f0105928:	50                   	push   %eax
f0105929:	68 17 7c 10 f0       	push   $0xf0107c17
f010592e:	e8 da de ff ff       	call   f010380d <cprintf>

	if (mp->imcrp) {
f0105933:	83 c4 10             	add    $0x10,%esp
f0105936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105939:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f010593d:	75 2e                	jne    f010596d <mp_init+0x2ab>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f010593f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105942:	5b                   	pop    %ebx
f0105943:	5e                   	pop    %esi
f0105944:	5f                   	pop    %edi
f0105945:	5d                   	pop    %ebp
f0105946:	c3                   	ret    
		ncpu = 1;
f0105947:	c7 05 00 c0 22 f0 01 	movl   $0x1,0xf022c000
f010594e:	00 00 00 
		lapicaddr = 0;
f0105951:	c7 05 c4 c3 22 f0 00 	movl   $0x0,0xf022c3c4
f0105958:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f010595b:	83 ec 0c             	sub    $0xc,%esp
f010595e:	68 90 7b 10 f0       	push   $0xf0107b90
f0105963:	e8 a5 de ff ff       	call   f010380d <cprintf>
		return;
f0105968:	83 c4 10             	add    $0x10,%esp
f010596b:	eb d2                	jmp    f010593f <mp_init+0x27d>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f010596d:	83 ec 0c             	sub    $0xc,%esp
f0105970:	68 bc 7b 10 f0       	push   $0xf0107bbc
f0105975:	e8 93 de ff ff       	call   f010380d <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010597a:	b8 70 00 00 00       	mov    $0x70,%eax
f010597f:	ba 22 00 00 00       	mov    $0x22,%edx
f0105984:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105985:	ba 23 00 00 00       	mov    $0x23,%edx
f010598a:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f010598b:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010598e:	ee                   	out    %al,(%dx)
}
f010598f:	83 c4 10             	add    $0x10,%esp
f0105992:	eb ab                	jmp    f010593f <mp_init+0x27d>

f0105994 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105994:	8b 0d c0 c3 22 f0    	mov    0xf022c3c0,%ecx
f010599a:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f010599d:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f010599f:	a1 c0 c3 22 f0       	mov    0xf022c3c0,%eax
f01059a4:	8b 40 20             	mov    0x20(%eax),%eax
}
f01059a7:	c3                   	ret    

f01059a8 <cpunum>:
}

int
cpunum(void)
{
	if (lapic)
f01059a8:	8b 15 c0 c3 22 f0    	mov    0xf022c3c0,%edx
		return lapic[ID] >> 24;
	return 0;
f01059ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f01059b3:	85 d2                	test   %edx,%edx
f01059b5:	74 06                	je     f01059bd <cpunum+0x15>
		return lapic[ID] >> 24;
f01059b7:	8b 42 20             	mov    0x20(%edx),%eax
f01059ba:	c1 e8 18             	shr    $0x18,%eax
}
f01059bd:	c3                   	ret    

f01059be <lapic_init>:
	if (!lapicaddr)
f01059be:	a1 c4 c3 22 f0       	mov    0xf022c3c4,%eax
f01059c3:	85 c0                	test   %eax,%eax
f01059c5:	75 01                	jne    f01059c8 <lapic_init+0xa>
f01059c7:	c3                   	ret    
{
f01059c8:	55                   	push   %ebp
f01059c9:	89 e5                	mov    %esp,%ebp
f01059cb:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f01059ce:	68 00 10 00 00       	push   $0x1000
f01059d3:	50                   	push   %eax
f01059d4:	e8 44 b8 ff ff       	call   f010121d <mmio_map_region>
f01059d9:	a3 c0 c3 22 f0       	mov    %eax,0xf022c3c0
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01059de:	ba 27 01 00 00       	mov    $0x127,%edx
f01059e3:	b8 3c 00 00 00       	mov    $0x3c,%eax
f01059e8:	e8 a7 ff ff ff       	call   f0105994 <lapicw>
	lapicw(TDCR, X1);
f01059ed:	ba 0b 00 00 00       	mov    $0xb,%edx
f01059f2:	b8 f8 00 00 00       	mov    $0xf8,%eax
f01059f7:	e8 98 ff ff ff       	call   f0105994 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01059fc:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105a01:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105a06:	e8 89 ff ff ff       	call   f0105994 <lapicw>
	lapicw(TICR, 10000000); 
f0105a0b:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105a10:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105a15:	e8 7a ff ff ff       	call   f0105994 <lapicw>
	if (thiscpu != bootcpu)
f0105a1a:	e8 89 ff ff ff       	call   f01059a8 <cpunum>
f0105a1f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a22:	05 20 c0 22 f0       	add    $0xf022c020,%eax
f0105a27:	83 c4 10             	add    $0x10,%esp
f0105a2a:	39 05 08 c0 22 f0    	cmp    %eax,0xf022c008
f0105a30:	74 0f                	je     f0105a41 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0105a32:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105a37:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105a3c:	e8 53 ff ff ff       	call   f0105994 <lapicw>
	lapicw(LINT1, MASKED);
f0105a41:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105a46:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105a4b:	e8 44 ff ff ff       	call   f0105994 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105a50:	a1 c0 c3 22 f0       	mov    0xf022c3c0,%eax
f0105a55:	8b 40 30             	mov    0x30(%eax),%eax
f0105a58:	c1 e8 10             	shr    $0x10,%eax
f0105a5b:	a8 fc                	test   $0xfc,%al
f0105a5d:	75 7c                	jne    f0105adb <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105a5f:	ba 33 00 00 00       	mov    $0x33,%edx
f0105a64:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105a69:	e8 26 ff ff ff       	call   f0105994 <lapicw>
	lapicw(ESR, 0);
f0105a6e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105a73:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105a78:	e8 17 ff ff ff       	call   f0105994 <lapicw>
	lapicw(ESR, 0);
f0105a7d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105a82:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105a87:	e8 08 ff ff ff       	call   f0105994 <lapicw>
	lapicw(EOI, 0);
f0105a8c:	ba 00 00 00 00       	mov    $0x0,%edx
f0105a91:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105a96:	e8 f9 fe ff ff       	call   f0105994 <lapicw>
	lapicw(ICRHI, 0);
f0105a9b:	ba 00 00 00 00       	mov    $0x0,%edx
f0105aa0:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105aa5:	e8 ea fe ff ff       	call   f0105994 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105aaa:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105aaf:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ab4:	e8 db fe ff ff       	call   f0105994 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105ab9:	8b 15 c0 c3 22 f0    	mov    0xf022c3c0,%edx
f0105abf:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105ac5:	f6 c4 10             	test   $0x10,%ah
f0105ac8:	75 f5                	jne    f0105abf <lapic_init+0x101>
	lapicw(TPR, 0);
f0105aca:	ba 00 00 00 00       	mov    $0x0,%edx
f0105acf:	b8 20 00 00 00       	mov    $0x20,%eax
f0105ad4:	e8 bb fe ff ff       	call   f0105994 <lapicw>
}
f0105ad9:	c9                   	leave  
f0105ada:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105adb:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ae0:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105ae5:	e8 aa fe ff ff       	call   f0105994 <lapicw>
f0105aea:	e9 70 ff ff ff       	jmp    f0105a5f <lapic_init+0xa1>

f0105aef <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105aef:	83 3d c0 c3 22 f0 00 	cmpl   $0x0,0xf022c3c0
f0105af6:	74 17                	je     f0105b0f <lapic_eoi+0x20>
{
f0105af8:	55                   	push   %ebp
f0105af9:	89 e5                	mov    %esp,%ebp
f0105afb:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0105afe:	ba 00 00 00 00       	mov    $0x0,%edx
f0105b03:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105b08:	e8 87 fe ff ff       	call   f0105994 <lapicw>
}
f0105b0d:	c9                   	leave  
f0105b0e:	c3                   	ret    
f0105b0f:	c3                   	ret    

f0105b10 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105b10:	55                   	push   %ebp
f0105b11:	89 e5                	mov    %esp,%ebp
f0105b13:	56                   	push   %esi
f0105b14:	53                   	push   %ebx
f0105b15:	8b 75 08             	mov    0x8(%ebp),%esi
f0105b18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105b1b:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105b20:	ba 70 00 00 00       	mov    $0x70,%edx
f0105b25:	ee                   	out    %al,(%dx)
f0105b26:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105b2b:	ba 71 00 00 00       	mov    $0x71,%edx
f0105b30:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105b31:	83 3d 60 b2 1e f0 00 	cmpl   $0x0,0xf01eb260
f0105b38:	74 7e                	je     f0105bb8 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105b3a:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105b41:	00 00 
	wrv[1] = addr >> 4;
f0105b43:	89 d8                	mov    %ebx,%eax
f0105b45:	c1 e8 04             	shr    $0x4,%eax
f0105b48:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105b4e:	c1 e6 18             	shl    $0x18,%esi
f0105b51:	89 f2                	mov    %esi,%edx
f0105b53:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105b58:	e8 37 fe ff ff       	call   f0105994 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105b5d:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105b62:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105b67:	e8 28 fe ff ff       	call   f0105994 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105b6c:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105b71:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105b76:	e8 19 fe ff ff       	call   f0105994 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105b7b:	c1 eb 0c             	shr    $0xc,%ebx
f0105b7e:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0105b81:	89 f2                	mov    %esi,%edx
f0105b83:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105b88:	e8 07 fe ff ff       	call   f0105994 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105b8d:	89 da                	mov    %ebx,%edx
f0105b8f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105b94:	e8 fb fd ff ff       	call   f0105994 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0105b99:	89 f2                	mov    %esi,%edx
f0105b9b:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ba0:	e8 ef fd ff ff       	call   f0105994 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105ba5:	89 da                	mov    %ebx,%edx
f0105ba7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105bac:	e8 e3 fd ff ff       	call   f0105994 <lapicw>
		microdelay(200);
	}
}
f0105bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105bb4:	5b                   	pop    %ebx
f0105bb5:	5e                   	pop    %esi
f0105bb6:	5d                   	pop    %ebp
f0105bb7:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105bb8:	68 67 04 00 00       	push   $0x467
f0105bbd:	68 04 60 10 f0       	push   $0xf0106004
f0105bc2:	68 98 00 00 00       	push   $0x98
f0105bc7:	68 34 7c 10 f0       	push   $0xf0107c34
f0105bcc:	e8 6f a4 ff ff       	call   f0100040 <_panic>

f0105bd1 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0105bd1:	55                   	push   %ebp
f0105bd2:	89 e5                	mov    %esp,%ebp
f0105bd4:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0105bd7:	8b 55 08             	mov    0x8(%ebp),%edx
f0105bda:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0105be0:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105be5:	e8 aa fd ff ff       	call   f0105994 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0105bea:	8b 15 c0 c3 22 f0    	mov    0xf022c3c0,%edx
f0105bf0:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105bf6:	f6 c4 10             	test   $0x10,%ah
f0105bf9:	75 f5                	jne    f0105bf0 <lapic_ipi+0x1f>
		;
}
f0105bfb:	c9                   	leave  
f0105bfc:	c3                   	ret    

f0105bfd <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105bfd:	55                   	push   %ebp
f0105bfe:	89 e5                	mov    %esp,%ebp
f0105c00:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0105c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105c09:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c0c:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105c0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0105c16:	5d                   	pop    %ebp
f0105c17:	c3                   	ret    

f0105c18 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0105c18:	55                   	push   %ebp
f0105c19:	89 e5                	mov    %esp,%ebp
f0105c1b:	56                   	push   %esi
f0105c1c:	53                   	push   %ebx
f0105c1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0105c20:	83 3b 00             	cmpl   $0x0,(%ebx)
f0105c23:	75 07                	jne    f0105c2c <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0105c25:	ba 01 00 00 00       	mov    $0x1,%edx
f0105c2a:	eb 34                	jmp    f0105c60 <spin_lock+0x48>
f0105c2c:	8b 73 08             	mov    0x8(%ebx),%esi
f0105c2f:	e8 74 fd ff ff       	call   f01059a8 <cpunum>
f0105c34:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c37:	05 20 c0 22 f0       	add    $0xf022c020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105c3c:	39 c6                	cmp    %eax,%esi
f0105c3e:	75 e5                	jne    f0105c25 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105c40:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0105c43:	e8 60 fd ff ff       	call   f01059a8 <cpunum>
f0105c48:	83 ec 0c             	sub    $0xc,%esp
f0105c4b:	53                   	push   %ebx
f0105c4c:	50                   	push   %eax
f0105c4d:	68 44 7c 10 f0       	push   $0xf0107c44
f0105c52:	6a 41                	push   $0x41
f0105c54:	68 a6 7c 10 f0       	push   $0xf0107ca6
f0105c59:	e8 e2 a3 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105c5e:	f3 90                	pause  
f0105c60:	89 d0                	mov    %edx,%eax
f0105c62:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0105c65:	85 c0                	test   %eax,%eax
f0105c67:	75 f5                	jne    f0105c5e <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105c69:	e8 3a fd ff ff       	call   f01059a8 <cpunum>
f0105c6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c71:	05 20 c0 22 f0       	add    $0xf022c020,%eax
f0105c76:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105c79:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0105c7b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0105c80:	83 f8 09             	cmp    $0x9,%eax
f0105c83:	7f 21                	jg     f0105ca6 <spin_lock+0x8e>
f0105c85:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0105c8b:	76 19                	jbe    f0105ca6 <spin_lock+0x8e>
		pcs[i] = ebp[1];          // saved %eip
f0105c8d:	8b 4a 04             	mov    0x4(%edx),%ecx
f0105c90:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0105c94:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0105c96:	83 c0 01             	add    $0x1,%eax
f0105c99:	eb e5                	jmp    f0105c80 <spin_lock+0x68>
		pcs[i] = 0;
f0105c9b:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0105ca2:	00 
	for (; i < 10; i++)
f0105ca3:	83 c0 01             	add    $0x1,%eax
f0105ca6:	83 f8 09             	cmp    $0x9,%eax
f0105ca9:	7e f0                	jle    f0105c9b <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0105cab:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105cae:	5b                   	pop    %ebx
f0105caf:	5e                   	pop    %esi
f0105cb0:	5d                   	pop    %ebp
f0105cb1:	c3                   	ret    

f0105cb2 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0105cb2:	55                   	push   %ebp
f0105cb3:	89 e5                	mov    %esp,%ebp
f0105cb5:	57                   	push   %edi
f0105cb6:	56                   	push   %esi
f0105cb7:	53                   	push   %ebx
f0105cb8:	83 ec 4c             	sub    $0x4c,%esp
f0105cbb:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0105cbe:	83 3e 00             	cmpl   $0x0,(%esi)
f0105cc1:	75 35                	jne    f0105cf8 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0105cc3:	83 ec 04             	sub    $0x4,%esp
f0105cc6:	6a 28                	push   $0x28
f0105cc8:	8d 46 0c             	lea    0xc(%esi),%eax
f0105ccb:	50                   	push   %eax
f0105ccc:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0105ccf:	53                   	push   %ebx
f0105cd0:	e8 25 f7 ff ff       	call   f01053fa <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0105cd5:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0105cd8:	0f b6 38             	movzbl (%eax),%edi
f0105cdb:	8b 76 04             	mov    0x4(%esi),%esi
f0105cde:	e8 c5 fc ff ff       	call   f01059a8 <cpunum>
f0105ce3:	57                   	push   %edi
f0105ce4:	56                   	push   %esi
f0105ce5:	50                   	push   %eax
f0105ce6:	68 70 7c 10 f0       	push   $0xf0107c70
f0105ceb:	e8 1d db ff ff       	call   f010380d <cprintf>
f0105cf0:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105cf3:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0105cf6:	eb 4e                	jmp    f0105d46 <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0105cf8:	8b 5e 08             	mov    0x8(%esi),%ebx
f0105cfb:	e8 a8 fc ff ff       	call   f01059a8 <cpunum>
f0105d00:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d03:	05 20 c0 22 f0       	add    $0xf022c020,%eax
	if (!holding(lk)) {
f0105d08:	39 c3                	cmp    %eax,%ebx
f0105d0a:	75 b7                	jne    f0105cc3 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0105d0c:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0105d13:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0105d1a:	b8 00 00 00 00       	mov    $0x0,%eax
f0105d1f:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0105d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d25:	5b                   	pop    %ebx
f0105d26:	5e                   	pop    %esi
f0105d27:	5f                   	pop    %edi
f0105d28:	5d                   	pop    %ebp
f0105d29:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0105d2a:	83 ec 08             	sub    $0x8,%esp
f0105d2d:	ff 36                	push   (%esi)
f0105d2f:	68 cd 7c 10 f0       	push   $0xf0107ccd
f0105d34:	e8 d4 da ff ff       	call   f010380d <cprintf>
f0105d39:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
f0105d3c:	83 c3 04             	add    $0x4,%ebx
f0105d3f:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105d42:	39 c3                	cmp    %eax,%ebx
f0105d44:	74 40                	je     f0105d86 <spin_unlock+0xd4>
f0105d46:	89 de                	mov    %ebx,%esi
f0105d48:	8b 03                	mov    (%ebx),%eax
f0105d4a:	85 c0                	test   %eax,%eax
f0105d4c:	74 38                	je     f0105d86 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105d4e:	83 ec 08             	sub    $0x8,%esp
f0105d51:	57                   	push   %edi
f0105d52:	50                   	push   %eax
f0105d53:	e8 4d eb ff ff       	call   f01048a5 <debuginfo_eip>
f0105d58:	83 c4 10             	add    $0x10,%esp
f0105d5b:	85 c0                	test   %eax,%eax
f0105d5d:	78 cb                	js     f0105d2a <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0105d5f:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0105d61:	83 ec 04             	sub    $0x4,%esp
f0105d64:	89 c2                	mov    %eax,%edx
f0105d66:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0105d69:	52                   	push   %edx
f0105d6a:	ff 75 b0             	push   -0x50(%ebp)
f0105d6d:	ff 75 b4             	push   -0x4c(%ebp)
f0105d70:	ff 75 ac             	push   -0x54(%ebp)
f0105d73:	ff 75 a8             	push   -0x58(%ebp)
f0105d76:	50                   	push   %eax
f0105d77:	68 b6 7c 10 f0       	push   $0xf0107cb6
f0105d7c:	e8 8c da ff ff       	call   f010380d <cprintf>
f0105d81:	83 c4 20             	add    $0x20,%esp
f0105d84:	eb b6                	jmp    f0105d3c <spin_unlock+0x8a>
		panic("spin_unlock");
f0105d86:	83 ec 04             	sub    $0x4,%esp
f0105d89:	68 d5 7c 10 f0       	push   $0xf0107cd5
f0105d8e:	6a 67                	push   $0x67
f0105d90:	68 a6 7c 10 f0       	push   $0xf0107ca6
f0105d95:	e8 a6 a2 ff ff       	call   f0100040 <_panic>
f0105d9a:	66 90                	xchg   %ax,%ax
f0105d9c:	66 90                	xchg   %ax,%ax
f0105d9e:	66 90                	xchg   %ax,%ax

f0105da0 <__udivdi3>:
f0105da0:	f3 0f 1e fb          	endbr32 
f0105da4:	55                   	push   %ebp
f0105da5:	57                   	push   %edi
f0105da6:	56                   	push   %esi
f0105da7:	53                   	push   %ebx
f0105da8:	83 ec 1c             	sub    $0x1c,%esp
f0105dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0105daf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0105db3:	8b 74 24 34          	mov    0x34(%esp),%esi
f0105db7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0105dbb:	85 c0                	test   %eax,%eax
f0105dbd:	75 19                	jne    f0105dd8 <__udivdi3+0x38>
f0105dbf:	39 f3                	cmp    %esi,%ebx
f0105dc1:	76 4d                	jbe    f0105e10 <__udivdi3+0x70>
f0105dc3:	31 ff                	xor    %edi,%edi
f0105dc5:	89 e8                	mov    %ebp,%eax
f0105dc7:	89 f2                	mov    %esi,%edx
f0105dc9:	f7 f3                	div    %ebx
f0105dcb:	89 fa                	mov    %edi,%edx
f0105dcd:	83 c4 1c             	add    $0x1c,%esp
f0105dd0:	5b                   	pop    %ebx
f0105dd1:	5e                   	pop    %esi
f0105dd2:	5f                   	pop    %edi
f0105dd3:	5d                   	pop    %ebp
f0105dd4:	c3                   	ret    
f0105dd5:	8d 76 00             	lea    0x0(%esi),%esi
f0105dd8:	39 f0                	cmp    %esi,%eax
f0105dda:	76 14                	jbe    f0105df0 <__udivdi3+0x50>
f0105ddc:	31 ff                	xor    %edi,%edi
f0105dde:	31 c0                	xor    %eax,%eax
f0105de0:	89 fa                	mov    %edi,%edx
f0105de2:	83 c4 1c             	add    $0x1c,%esp
f0105de5:	5b                   	pop    %ebx
f0105de6:	5e                   	pop    %esi
f0105de7:	5f                   	pop    %edi
f0105de8:	5d                   	pop    %ebp
f0105de9:	c3                   	ret    
f0105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105df0:	0f bd f8             	bsr    %eax,%edi
f0105df3:	83 f7 1f             	xor    $0x1f,%edi
f0105df6:	75 48                	jne    f0105e40 <__udivdi3+0xa0>
f0105df8:	39 f0                	cmp    %esi,%eax
f0105dfa:	72 06                	jb     f0105e02 <__udivdi3+0x62>
f0105dfc:	31 c0                	xor    %eax,%eax
f0105dfe:	39 eb                	cmp    %ebp,%ebx
f0105e00:	77 de                	ja     f0105de0 <__udivdi3+0x40>
f0105e02:	b8 01 00 00 00       	mov    $0x1,%eax
f0105e07:	eb d7                	jmp    f0105de0 <__udivdi3+0x40>
f0105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105e10:	89 d9                	mov    %ebx,%ecx
f0105e12:	85 db                	test   %ebx,%ebx
f0105e14:	75 0b                	jne    f0105e21 <__udivdi3+0x81>
f0105e16:	b8 01 00 00 00       	mov    $0x1,%eax
f0105e1b:	31 d2                	xor    %edx,%edx
f0105e1d:	f7 f3                	div    %ebx
f0105e1f:	89 c1                	mov    %eax,%ecx
f0105e21:	31 d2                	xor    %edx,%edx
f0105e23:	89 f0                	mov    %esi,%eax
f0105e25:	f7 f1                	div    %ecx
f0105e27:	89 c6                	mov    %eax,%esi
f0105e29:	89 e8                	mov    %ebp,%eax
f0105e2b:	89 f7                	mov    %esi,%edi
f0105e2d:	f7 f1                	div    %ecx
f0105e2f:	89 fa                	mov    %edi,%edx
f0105e31:	83 c4 1c             	add    $0x1c,%esp
f0105e34:	5b                   	pop    %ebx
f0105e35:	5e                   	pop    %esi
f0105e36:	5f                   	pop    %edi
f0105e37:	5d                   	pop    %ebp
f0105e38:	c3                   	ret    
f0105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105e40:	89 f9                	mov    %edi,%ecx
f0105e42:	ba 20 00 00 00       	mov    $0x20,%edx
f0105e47:	29 fa                	sub    %edi,%edx
f0105e49:	d3 e0                	shl    %cl,%eax
f0105e4b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105e4f:	89 d1                	mov    %edx,%ecx
f0105e51:	89 d8                	mov    %ebx,%eax
f0105e53:	d3 e8                	shr    %cl,%eax
f0105e55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105e59:	09 c1                	or     %eax,%ecx
f0105e5b:	89 f0                	mov    %esi,%eax
f0105e5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105e61:	89 f9                	mov    %edi,%ecx
f0105e63:	d3 e3                	shl    %cl,%ebx
f0105e65:	89 d1                	mov    %edx,%ecx
f0105e67:	d3 e8                	shr    %cl,%eax
f0105e69:	89 f9                	mov    %edi,%ecx
f0105e6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105e6f:	89 eb                	mov    %ebp,%ebx
f0105e71:	d3 e6                	shl    %cl,%esi
f0105e73:	89 d1                	mov    %edx,%ecx
f0105e75:	d3 eb                	shr    %cl,%ebx
f0105e77:	09 f3                	or     %esi,%ebx
f0105e79:	89 c6                	mov    %eax,%esi
f0105e7b:	89 f2                	mov    %esi,%edx
f0105e7d:	89 d8                	mov    %ebx,%eax
f0105e7f:	f7 74 24 08          	divl   0x8(%esp)
f0105e83:	89 d6                	mov    %edx,%esi
f0105e85:	89 c3                	mov    %eax,%ebx
f0105e87:	f7 64 24 0c          	mull   0xc(%esp)
f0105e8b:	39 d6                	cmp    %edx,%esi
f0105e8d:	72 19                	jb     f0105ea8 <__udivdi3+0x108>
f0105e8f:	89 f9                	mov    %edi,%ecx
f0105e91:	d3 e5                	shl    %cl,%ebp
f0105e93:	39 c5                	cmp    %eax,%ebp
f0105e95:	73 04                	jae    f0105e9b <__udivdi3+0xfb>
f0105e97:	39 d6                	cmp    %edx,%esi
f0105e99:	74 0d                	je     f0105ea8 <__udivdi3+0x108>
f0105e9b:	89 d8                	mov    %ebx,%eax
f0105e9d:	31 ff                	xor    %edi,%edi
f0105e9f:	e9 3c ff ff ff       	jmp    f0105de0 <__udivdi3+0x40>
f0105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105ea8:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0105eab:	31 ff                	xor    %edi,%edi
f0105ead:	e9 2e ff ff ff       	jmp    f0105de0 <__udivdi3+0x40>
f0105eb2:	66 90                	xchg   %ax,%ax
f0105eb4:	66 90                	xchg   %ax,%ax
f0105eb6:	66 90                	xchg   %ax,%ax
f0105eb8:	66 90                	xchg   %ax,%ax
f0105eba:	66 90                	xchg   %ax,%ax
f0105ebc:	66 90                	xchg   %ax,%ax
f0105ebe:	66 90                	xchg   %ax,%ax

f0105ec0 <__umoddi3>:
f0105ec0:	f3 0f 1e fb          	endbr32 
f0105ec4:	55                   	push   %ebp
f0105ec5:	57                   	push   %edi
f0105ec6:	56                   	push   %esi
f0105ec7:	53                   	push   %ebx
f0105ec8:	83 ec 1c             	sub    $0x1c,%esp
f0105ecb:	8b 74 24 30          	mov    0x30(%esp),%esi
f0105ecf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0105ed3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
f0105ed7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
f0105edb:	89 f0                	mov    %esi,%eax
f0105edd:	89 da                	mov    %ebx,%edx
f0105edf:	85 ff                	test   %edi,%edi
f0105ee1:	75 15                	jne    f0105ef8 <__umoddi3+0x38>
f0105ee3:	39 dd                	cmp    %ebx,%ebp
f0105ee5:	76 39                	jbe    f0105f20 <__umoddi3+0x60>
f0105ee7:	f7 f5                	div    %ebp
f0105ee9:	89 d0                	mov    %edx,%eax
f0105eeb:	31 d2                	xor    %edx,%edx
f0105eed:	83 c4 1c             	add    $0x1c,%esp
f0105ef0:	5b                   	pop    %ebx
f0105ef1:	5e                   	pop    %esi
f0105ef2:	5f                   	pop    %edi
f0105ef3:	5d                   	pop    %ebp
f0105ef4:	c3                   	ret    
f0105ef5:	8d 76 00             	lea    0x0(%esi),%esi
f0105ef8:	39 df                	cmp    %ebx,%edi
f0105efa:	77 f1                	ja     f0105eed <__umoddi3+0x2d>
f0105efc:	0f bd cf             	bsr    %edi,%ecx
f0105eff:	83 f1 1f             	xor    $0x1f,%ecx
f0105f02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105f06:	75 40                	jne    f0105f48 <__umoddi3+0x88>
f0105f08:	39 df                	cmp    %ebx,%edi
f0105f0a:	72 04                	jb     f0105f10 <__umoddi3+0x50>
f0105f0c:	39 f5                	cmp    %esi,%ebp
f0105f0e:	77 dd                	ja     f0105eed <__umoddi3+0x2d>
f0105f10:	89 da                	mov    %ebx,%edx
f0105f12:	89 f0                	mov    %esi,%eax
f0105f14:	29 e8                	sub    %ebp,%eax
f0105f16:	19 fa                	sbb    %edi,%edx
f0105f18:	eb d3                	jmp    f0105eed <__umoddi3+0x2d>
f0105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105f20:	89 e9                	mov    %ebp,%ecx
f0105f22:	85 ed                	test   %ebp,%ebp
f0105f24:	75 0b                	jne    f0105f31 <__umoddi3+0x71>
f0105f26:	b8 01 00 00 00       	mov    $0x1,%eax
f0105f2b:	31 d2                	xor    %edx,%edx
f0105f2d:	f7 f5                	div    %ebp
f0105f2f:	89 c1                	mov    %eax,%ecx
f0105f31:	89 d8                	mov    %ebx,%eax
f0105f33:	31 d2                	xor    %edx,%edx
f0105f35:	f7 f1                	div    %ecx
f0105f37:	89 f0                	mov    %esi,%eax
f0105f39:	f7 f1                	div    %ecx
f0105f3b:	89 d0                	mov    %edx,%eax
f0105f3d:	31 d2                	xor    %edx,%edx
f0105f3f:	eb ac                	jmp    f0105eed <__umoddi3+0x2d>
f0105f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105f48:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105f4c:	ba 20 00 00 00       	mov    $0x20,%edx
f0105f51:	29 c2                	sub    %eax,%edx
f0105f53:	89 c1                	mov    %eax,%ecx
f0105f55:	89 e8                	mov    %ebp,%eax
f0105f57:	d3 e7                	shl    %cl,%edi
f0105f59:	89 d1                	mov    %edx,%ecx
f0105f5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105f5f:	d3 e8                	shr    %cl,%eax
f0105f61:	89 c1                	mov    %eax,%ecx
f0105f63:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105f67:	09 f9                	or     %edi,%ecx
f0105f69:	89 df                	mov    %ebx,%edi
f0105f6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105f6f:	89 c1                	mov    %eax,%ecx
f0105f71:	d3 e5                	shl    %cl,%ebp
f0105f73:	89 d1                	mov    %edx,%ecx
f0105f75:	d3 ef                	shr    %cl,%edi
f0105f77:	89 c1                	mov    %eax,%ecx
f0105f79:	89 f0                	mov    %esi,%eax
f0105f7b:	d3 e3                	shl    %cl,%ebx
f0105f7d:	89 d1                	mov    %edx,%ecx
f0105f7f:	89 fa                	mov    %edi,%edx
f0105f81:	d3 e8                	shr    %cl,%eax
f0105f83:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0105f88:	09 d8                	or     %ebx,%eax
f0105f8a:	f7 74 24 08          	divl   0x8(%esp)
f0105f8e:	89 d3                	mov    %edx,%ebx
f0105f90:	d3 e6                	shl    %cl,%esi
f0105f92:	f7 e5                	mul    %ebp
f0105f94:	89 c7                	mov    %eax,%edi
f0105f96:	89 d1                	mov    %edx,%ecx
f0105f98:	39 d3                	cmp    %edx,%ebx
f0105f9a:	72 06                	jb     f0105fa2 <__umoddi3+0xe2>
f0105f9c:	75 0e                	jne    f0105fac <__umoddi3+0xec>
f0105f9e:	39 c6                	cmp    %eax,%esi
f0105fa0:	73 0a                	jae    f0105fac <__umoddi3+0xec>
f0105fa2:	29 e8                	sub    %ebp,%eax
f0105fa4:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0105fa8:	89 d1                	mov    %edx,%ecx
f0105faa:	89 c7                	mov    %eax,%edi
f0105fac:	89 f5                	mov    %esi,%ebp
f0105fae:	8b 74 24 04          	mov    0x4(%esp),%esi
f0105fb2:	29 fd                	sub    %edi,%ebp
f0105fb4:	19 cb                	sbb    %ecx,%ebx
f0105fb6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0105fbb:	89 d8                	mov    %ebx,%eax
f0105fbd:	d3 e0                	shl    %cl,%eax
f0105fbf:	89 f1                	mov    %esi,%ecx
f0105fc1:	d3 ed                	shr    %cl,%ebp
f0105fc3:	d3 eb                	shr    %cl,%ebx
f0105fc5:	09 e8                	or     %ebp,%eax
f0105fc7:	89 da                	mov    %ebx,%edx
f0105fc9:	83 c4 1c             	add    $0x1c,%esp
f0105fcc:	5b                   	pop    %ebx
f0105fcd:	5e                   	pop    %esi
f0105fce:	5f                   	pop    %edi
f0105fcf:	5d                   	pop    %ebp
f0105fd0:	c3                   	ret    
