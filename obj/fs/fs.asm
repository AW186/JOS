
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 83 1a 00 00       	call   801ab4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c3                	mov    %eax,%ebx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  80003f:	89 c1                	mov    %eax,%ecx
  800041:	83 e1 c0             	and    $0xffffffc0,%ecx
  800044:	80 f9 40             	cmp    $0x40,%cl
  800047:	75 f5                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800049:	ba 00 00 00 00       	mov    $0x0,%edx
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004e:	84 db                	test   %bl,%bl
  800050:	74 0a                	je     80005c <ide_wait_ready+0x29>
  800052:	a8 21                	test   $0x21,%al
  800054:	0f 95 c2             	setne  %dl
  800057:	0f b6 d2             	movzbl %dl,%edx
  80005a:	f7 da                	neg    %edx
}
  80005c:	89 d0                	mov    %edx,%eax
  80005e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800061:	c9                   	leave  
  800062:	c3                   	ret    

00800063 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	53                   	push   %ebx
  800067:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	e8 bf ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800074:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800079:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007e:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007f:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800084:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800089:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80008a:	a8 a1                	test   $0xa1,%al
  80008c:	74 0b                	je     800099 <ide_probe_disk1+0x36>
	     x++)
  80008e:	83 c1 01             	add    $0x1,%ecx
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800091:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800097:	75 f0                	jne    800089 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a3:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a4:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000aa:	0f 9e c3             	setle  %bl
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	0f b6 c3             	movzbl %bl,%eax
  8000b3:	50                   	push   %eax
  8000b4:	68 60 39 80 00       	push   $0x803960
  8000b9:	e8 29 1b 00 00       	call   801be7 <cprintf>
	return (x < 1000);
}
  8000be:	89 d8                	mov    %ebx,%eax
  8000c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ce:	83 f8 01             	cmp    $0x1,%eax
  8000d1:	77 07                	ja     8000da <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000d3:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d8:	c9                   	leave  
  8000d9:	c3                   	ret    
		panic("bad disk number");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 77 39 80 00       	push   $0x803977
  8000e2:	6a 3a                	push   $0x3a
  8000e4:	68 87 39 80 00       	push   $0x803987
  8000e9:	e8 1e 1a 00 00       	call   801b0c <_panic>

008000ee <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000fd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800100:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800106:	0f 87 87 00 00 00    	ja     800193 <ide_read+0xa5>

	ide_wait_ready(0);
  80010c:	b8 00 00 00 00       	mov    $0x0,%eax
  800111:	e8 1d ff ff ff       	call   800033 <ide_wait_ready>
  800116:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80011b:	89 f0                	mov    %esi,%eax
  80011d:	ee                   	out    %al,(%dx)
  80011e:	ba f3 01 00 00       	mov    $0x1f3,%edx
  800123:	89 f8                	mov    %edi,%eax
  800125:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800126:	89 f8                	mov    %edi,%eax
  800128:	c1 e8 08             	shr    $0x8,%eax
  80012b:	ba f4 01 00 00       	mov    $0x1f4,%edx
  800130:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800131:	89 f8                	mov    %edi,%eax
  800133:	c1 e8 10             	shr    $0x10,%eax
  800136:	ba f5 01 00 00       	mov    $0x1f5,%edx
  80013b:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80013c:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800143:	c1 e0 04             	shl    $0x4,%eax
  800146:	83 e0 10             	and    $0x10,%eax
  800149:	c1 ef 18             	shr    $0x18,%edi
  80014c:	83 e7 0f             	and    $0xf,%edi
  80014f:	09 f8                	or     %edi,%eax
  800151:	83 c8 e0             	or     $0xffffffe0,%eax
  800154:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800159:	ee                   	out    %al,(%dx)
  80015a:	b8 20 00 00 00       	mov    $0x20,%eax
  80015f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800164:	ee                   	out    %al,(%dx)
  800165:	c1 e6 09             	shl    $0x9,%esi
  800168:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  80016a:	39 f3                	cmp    %esi,%ebx
  80016c:	74 3b                	je     8001a9 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016e:	b8 01 00 00 00       	mov    $0x1,%eax
  800173:	e8 bb fe ff ff       	call   800033 <ide_wait_ready>
  800178:	85 c0                	test   %eax,%eax
  80017a:	78 32                	js     8001ae <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  80017c:	89 df                	mov    %ebx,%edi
  80017e:	b9 80 00 00 00       	mov    $0x80,%ecx
  800183:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800188:	fc                   	cld    
  800189:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  80018b:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800191:	eb d7                	jmp    80016a <ide_read+0x7c>
	assert(nsecs <= 256);
  800193:	68 90 39 80 00       	push   $0x803990
  800198:	68 9d 39 80 00       	push   $0x80399d
  80019d:	6a 44                	push   $0x44
  80019f:	68 87 39 80 00       	push   $0x803987
  8001a4:	e8 63 19 00 00       	call   801b0c <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5f                   	pop    %edi
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    

008001b6 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	57                   	push   %edi
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c5:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c8:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ce:	0f 87 87 00 00 00    	ja     80025b <ide_write+0xa5>

	ide_wait_ready(0);
  8001d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d9:	e8 55 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001de:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001e3:	89 f8                	mov    %edi,%eax
  8001e5:	ee                   	out    %al,(%dx)
  8001e6:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001eb:	89 f0                	mov    %esi,%eax
  8001ed:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ee:	89 f0                	mov    %esi,%eax
  8001f0:	c1 e8 08             	shr    $0x8,%eax
  8001f3:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f8:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f9:	89 f0                	mov    %esi,%eax
  8001fb:	c1 e8 10             	shr    $0x10,%eax
  8001fe:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800203:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800204:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80020b:	c1 e0 04             	shl    $0x4,%eax
  80020e:	83 e0 10             	and    $0x10,%eax
  800211:	c1 ee 18             	shr    $0x18,%esi
  800214:	83 e6 0f             	and    $0xf,%esi
  800217:	09 f0                	or     %esi,%eax
  800219:	83 c8 e0             	or     $0xffffffe0,%eax
  80021c:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800221:	ee                   	out    %al,(%dx)
  800222:	b8 30 00 00 00       	mov    $0x30,%eax
  800227:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80022c:	ee                   	out    %al,(%dx)
  80022d:	c1 e7 09             	shl    $0x9,%edi
  800230:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800232:	39 fb                	cmp    %edi,%ebx
  800234:	74 3b                	je     800271 <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800236:	b8 01 00 00 00       	mov    $0x1,%eax
  80023b:	e8 f3 fd ff ff       	call   800033 <ide_wait_ready>
  800240:	85 c0                	test   %eax,%eax
  800242:	78 32                	js     800276 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800244:	89 de                	mov    %ebx,%esi
  800246:	b9 80 00 00 00       	mov    $0x80,%ecx
  80024b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800250:	fc                   	cld    
  800251:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800253:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800259:	eb d7                	jmp    800232 <ide_write+0x7c>
	assert(nsecs <= 256);
  80025b:	68 90 39 80 00       	push   $0x803990
  800260:	68 9d 39 80 00       	push   $0x80399d
  800265:	6a 5d                	push   $0x5d
  800267:	68 87 39 80 00       	push   $0x803987
  80026c:	e8 9b 18 00 00       	call   801b0c <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800271:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    

0080027e <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80028a:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80028c:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800292:	89 c6                	mov    %eax,%esi
  800294:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800297:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80029c:	0f 87 98 00 00 00    	ja     80033a <bc_pgfault+0xbc>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002a2:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8002a7:	85 c0                	test   %eax,%eax
  8002a9:	74 09                	je     8002b4 <bc_pgfault+0x36>
  8002ab:	39 70 04             	cmp    %esi,0x4(%eax)
  8002ae:	0f 86 a1 00 00 00    	jbe    800355 <bc_pgfault+0xd7>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	if (sys_page_alloc(0, ROUNDDOWN((uint32_t)addr, PGSIZE), PTE_U | PTE_P | PTE_W) < 0)
  8002b4:	89 df                	mov    %ebx,%edi
  8002b6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	6a 07                	push   $0x7
  8002c1:	57                   	push   %edi
  8002c2:	6a 00                	push   $0x0
  8002c4:	e8 df 23 00 00       	call   8026a8 <sys_page_alloc>
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 88 93 00 00 00    	js     800367 <bc_pgfault+0xe9>
		panic("PGF: Page alloc error\n");
	if (ide_read(blockno*BLKSECTS, ROUNDDOWN(addr, PGSIZE), BLKSECTS) < 0)
  8002d4:	83 ec 04             	sub    $0x4,%esp
  8002d7:	6a 08                	push   $0x8
  8002d9:	57                   	push   %edi
  8002da:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002e1:	50                   	push   %eax
  8002e2:	e8 07 fe ff ff       	call   8000ee <ide_read>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	0f 88 89 00 00 00    	js     80037b <bc_pgfault+0xfd>
		panic("PGF: Disk read error");

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002f2:	89 d8                	mov    %ebx,%eax
  8002f4:	c1 e8 0c             	shr    $0xc,%eax
  8002f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	25 07 0e 00 00       	and    $0xe07,%eax
  800306:	50                   	push   %eax
  800307:	53                   	push   %ebx
  800308:	6a 00                	push   $0x0
  80030a:	53                   	push   %ebx
  80030b:	6a 00                	push   $0x0
  80030d:	e8 d9 23 00 00       	call   8026eb <sys_page_map>
  800312:	83 c4 20             	add    $0x20,%esp
  800315:	85 c0                	test   %eax,%eax
  800317:	78 76                	js     80038f <bc_pgfault+0x111>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800319:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  800320:	74 10                	je     800332 <bc_pgfault+0xb4>
  800322:	83 ec 0c             	sub    $0xc,%esp
  800325:	56                   	push   %esi
  800326:	e8 07 05 00 00       	call   800832 <block_is_free>
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	84 c0                	test   %al,%al
  800330:	75 6f                	jne    8003a1 <bc_pgfault+0x123>
		panic("reading free block %08x\n", blockno);
}
  800332:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800335:	5b                   	pop    %ebx
  800336:	5e                   	pop    %esi
  800337:	5f                   	pop    %edi
  800338:	5d                   	pop    %ebp
  800339:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	ff 72 04             	push   0x4(%edx)
  800340:	53                   	push   %ebx
  800341:	ff 72 28             	push   0x28(%edx)
  800344:	68 b4 39 80 00       	push   $0x8039b4
  800349:	6a 26                	push   $0x26
  80034b:	68 b0 3a 80 00       	push   $0x803ab0
  800350:	e8 b7 17 00 00       	call   801b0c <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800355:	56                   	push   %esi
  800356:	68 e4 39 80 00       	push   $0x8039e4
  80035b:	6a 2b                	push   $0x2b
  80035d:	68 b0 3a 80 00       	push   $0x803ab0
  800362:	e8 a5 17 00 00       	call   801b0c <_panic>
		panic("PGF: Page alloc error\n");
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 b8 3a 80 00       	push   $0x803ab8
  80036f:	6a 34                	push   $0x34
  800371:	68 b0 3a 80 00       	push   $0x803ab0
  800376:	e8 91 17 00 00       	call   801b0c <_panic>
		panic("PGF: Disk read error");
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 cf 3a 80 00       	push   $0x803acf
  800383:	6a 36                	push   $0x36
  800385:	68 b0 3a 80 00       	push   $0x803ab0
  80038a:	e8 7d 17 00 00       	call   801b0c <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  80038f:	50                   	push   %eax
  800390:	68 08 3a 80 00       	push   $0x803a08
  800395:	6a 3b                	push   $0x3b
  800397:	68 b0 3a 80 00       	push   $0x803ab0
  80039c:	e8 6b 17 00 00       	call   801b0c <_panic>
		panic("reading free block %08x\n", blockno);
  8003a1:	56                   	push   %esi
  8003a2:	68 e4 3a 80 00       	push   $0x803ae4
  8003a7:	6a 41                	push   $0x41
  8003a9:	68 b0 3a 80 00       	push   $0x803ab0
  8003ae:	e8 59 17 00 00       	call   801b0c <_panic>

008003b3 <diskaddr>:
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	74 19                	je     8003d9 <diskaddr+0x26>
  8003c0:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8003c6:	85 d2                	test   %edx,%edx
  8003c8:	74 05                	je     8003cf <diskaddr+0x1c>
  8003ca:	39 42 04             	cmp    %eax,0x4(%edx)
  8003cd:	76 0a                	jbe    8003d9 <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003cf:	05 00 00 01 00       	add    $0x10000,%eax
  8003d4:	c1 e0 0c             	shl    $0xc,%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003d9:	50                   	push   %eax
  8003da:	68 28 3a 80 00       	push   $0x803a28
  8003df:	6a 09                	push   $0x9
  8003e1:	68 b0 3a 80 00       	push   $0x803ab0
  8003e6:	e8 21 17 00 00       	call   801b0c <_panic>

008003eb <va_is_mapped>:
{
  8003eb:	55                   	push   %ebp
  8003ec:	89 e5                	mov    %esp,%ebp
  8003ee:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003f1:	89 d0                	mov    %edx,%eax
  8003f3:	c1 e8 16             	shr    $0x16,%eax
  8003f6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	f6 c1 01             	test   $0x1,%cl
  800405:	74 0d                	je     800414 <va_is_mapped+0x29>
  800407:	c1 ea 0c             	shr    $0xc,%edx
  80040a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800411:	83 e0 01             	and    $0x1,%eax
  800414:	83 e0 01             	and    $0x1,%eax
}
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <va_is_dirty>:
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	c1 e8 0c             	shr    $0xc,%eax
  800422:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800429:	c1 e8 06             	shr    $0x6,%eax
  80042c:	83 e0 01             	and    $0x1,%eax
}
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    

00800431 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	56                   	push   %esi
  800435:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	2d 00 00 00 10       	sub    $0x10000000,%eax
  80043e:	89 c6                	mov    %eax,%esi
  800440:	c1 ee 0c             	shr    $0xc,%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800443:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800448:	77 20                	ja     80046a <flush_block+0x39>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	void *va = (void *)(DISKMAP + blockno * BLKSIZE);
  80044a:	8d 9e 00 00 01 00    	lea    0x10000(%esi),%ebx
  800450:	c1 e3 0c             	shl    $0xc,%ebx
	if (!va_is_mapped(va) || !va_is_dirty(va)) return;
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	53                   	push   %ebx
  800457:	e8 8f ff ff ff       	call   8003eb <va_is_mapped>
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	84 c0                	test   %al,%al
  800461:	75 1b                	jne    80047e <flush_block+0x4d>
	if (ide_write(blockno * BLKSECTS, ROUNDDOWN(va, PGSIZE), BLKSECTS) < 0) 
		panic("Flush: Unable to write to disk\n");
	if (sys_page_map(0, va, 0, va, PTE_SYSCALL) < 0)
		panic("Flush: Failed to map the page\n");
}
  800463:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800466:	5b                   	pop    %ebx
  800467:	5e                   	pop    %esi
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80046a:	ff 75 08             	push   0x8(%ebp)
  80046d:	68 fd 3a 80 00       	push   $0x803afd
  800472:	6a 51                	push   $0x51
  800474:	68 b0 3a 80 00       	push   $0x803ab0
  800479:	e8 8e 16 00 00       	call   801b0c <_panic>
	if (!va_is_mapped(va) || !va_is_dirty(va)) return;
  80047e:	83 ec 0c             	sub    $0xc,%esp
  800481:	53                   	push   %ebx
  800482:	e8 92 ff ff ff       	call   800419 <va_is_dirty>
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	84 c0                	test   %al,%al
  80048c:	74 d5                	je     800463 <flush_block+0x32>
	if (ide_write(blockno * BLKSECTS, ROUNDDOWN(va, PGSIZE), BLKSECTS) < 0) 
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	6a 08                	push   $0x8
  800493:	53                   	push   %ebx
  800494:	c1 e6 03             	shl    $0x3,%esi
  800497:	56                   	push   %esi
  800498:	e8 19 fd ff ff       	call   8001b6 <ide_write>
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	78 2e                	js     8004d2 <flush_block+0xa1>
	if (sys_page_map(0, va, 0, va, PTE_SYSCALL) < 0)
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	68 07 0e 00 00       	push   $0xe07
  8004ac:	53                   	push   %ebx
  8004ad:	6a 00                	push   $0x0
  8004af:	53                   	push   %ebx
  8004b0:	6a 00                	push   $0x0
  8004b2:	e8 34 22 00 00       	call   8026eb <sys_page_map>
  8004b7:	83 c4 20             	add    $0x20,%esp
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	79 a5                	jns    800463 <flush_block+0x32>
		panic("Flush: Failed to map the page\n");
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	68 6c 3a 80 00       	push   $0x803a6c
  8004c6:	6a 59                	push   $0x59
  8004c8:	68 b0 3a 80 00       	push   $0x803ab0
  8004cd:	e8 3a 16 00 00       	call   801b0c <_panic>
		panic("Flush: Unable to write to disk\n");
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	68 4c 3a 80 00       	push   $0x803a4c
  8004da:	6a 57                	push   $0x57
  8004dc:	68 b0 3a 80 00       	push   $0x803ab0
  8004e1:	e8 26 16 00 00       	call   801b0c <_panic>

008004e6 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	53                   	push   %ebx
  8004ea:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004f0:	68 7e 02 80 00       	push   $0x80027e
  8004f5:	e8 9f 23 00 00       	call   802899 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800501:	e8 ad fe ff ff       	call   8003b3 <diskaddr>
  800506:	83 c4 0c             	add    $0xc,%esp
  800509:	68 08 01 00 00       	push   $0x108
  80050e:	50                   	push   %eax
  80050f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800515:	50                   	push   %eax
  800516:	e8 27 1f 00 00       	call   802442 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80051b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800522:	e8 8c fe ff ff       	call   8003b3 <diskaddr>
  800527:	83 c4 08             	add    $0x8,%esp
  80052a:	68 18 3b 80 00       	push   $0x803b18
  80052f:	50                   	push   %eax
  800530:	e8 77 1d 00 00       	call   8022ac <strcpy>
	flush_block(diskaddr(1));
  800535:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80053c:	e8 72 fe ff ff       	call   8003b3 <diskaddr>
  800541:	89 04 24             	mov    %eax,(%esp)
  800544:	e8 e8 fe ff ff       	call   800431 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800550:	e8 5e fe ff ff       	call   8003b3 <diskaddr>
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	e8 8e fe ff ff       	call   8003eb <va_is_mapped>
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	84 c0                	test   %al,%al
  800562:	0f 84 d1 01 00 00    	je     800739 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	6a 01                	push   $0x1
  80056d:	e8 41 fe ff ff       	call   8003b3 <diskaddr>
  800572:	89 04 24             	mov    %eax,(%esp)
  800575:	e8 9f fe ff ff       	call   800419 <va_is_dirty>
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	84 c0                	test   %al,%al
  80057f:	0f 85 ca 01 00 00    	jne    80074f <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800585:	83 ec 0c             	sub    $0xc,%esp
  800588:	6a 01                	push   $0x1
  80058a:	e8 24 fe ff ff       	call   8003b3 <diskaddr>
  80058f:	83 c4 08             	add    $0x8,%esp
  800592:	50                   	push   %eax
  800593:	6a 00                	push   $0x0
  800595:	e8 93 21 00 00       	call   80272d <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80059a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005a1:	e8 0d fe ff ff       	call   8003b3 <diskaddr>
  8005a6:	89 04 24             	mov    %eax,(%esp)
  8005a9:	e8 3d fe ff ff       	call   8003eb <va_is_mapped>
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	84 c0                	test   %al,%al
  8005b3:	0f 85 ac 01 00 00    	jne    800765 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005b9:	83 ec 0c             	sub    $0xc,%esp
  8005bc:	6a 01                	push   $0x1
  8005be:	e8 f0 fd ff ff       	call   8003b3 <diskaddr>
  8005c3:	83 c4 08             	add    $0x8,%esp
  8005c6:	68 18 3b 80 00       	push   $0x803b18
  8005cb:	50                   	push   %eax
  8005cc:	e8 8c 1d 00 00       	call   80235d <strcmp>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	85 c0                	test   %eax,%eax
  8005d6:	0f 85 9f 01 00 00    	jne    80077b <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005dc:	83 ec 0c             	sub    $0xc,%esp
  8005df:	6a 01                	push   $0x1
  8005e1:	e8 cd fd ff ff       	call   8003b3 <diskaddr>
  8005e6:	83 c4 0c             	add    $0xc,%esp
  8005e9:	68 08 01 00 00       	push   $0x108
  8005ee:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005f4:	53                   	push   %ebx
  8005f5:	50                   	push   %eax
  8005f6:	e8 47 1e 00 00       	call   802442 <memmove>
	flush_block(diskaddr(1));
  8005fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800602:	e8 ac fd ff ff       	call   8003b3 <diskaddr>
  800607:	89 04 24             	mov    %eax,(%esp)
  80060a:	e8 22 fe ff ff       	call   800431 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  80060f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800616:	e8 98 fd ff ff       	call   8003b3 <diskaddr>
  80061b:	83 c4 0c             	add    $0xc,%esp
  80061e:	68 08 01 00 00       	push   $0x108
  800623:	50                   	push   %eax
  800624:	53                   	push   %ebx
  800625:	e8 18 1e 00 00       	call   802442 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80062a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800631:	e8 7d fd ff ff       	call   8003b3 <diskaddr>
  800636:	83 c4 08             	add    $0x8,%esp
  800639:	68 18 3b 80 00       	push   $0x803b18
  80063e:	50                   	push   %eax
  80063f:	e8 68 1c 00 00       	call   8022ac <strcpy>
	flush_block(diskaddr(1) + 20);
  800644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80064b:	e8 63 fd ff ff       	call   8003b3 <diskaddr>
  800650:	83 c0 14             	add    $0x14,%eax
  800653:	89 04 24             	mov    %eax,(%esp)
  800656:	e8 d6 fd ff ff       	call   800431 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80065b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800662:	e8 4c fd ff ff       	call   8003b3 <diskaddr>
  800667:	89 04 24             	mov    %eax,(%esp)
  80066a:	e8 7c fd ff ff       	call   8003eb <va_is_mapped>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	84 c0                	test   %al,%al
  800674:	0f 84 17 01 00 00    	je     800791 <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	6a 01                	push   $0x1
  80067f:	e8 2f fd ff ff       	call   8003b3 <diskaddr>
  800684:	83 c4 08             	add    $0x8,%esp
  800687:	50                   	push   %eax
  800688:	6a 00                	push   $0x0
  80068a:	e8 9e 20 00 00       	call   80272d <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80068f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800696:	e8 18 fd ff ff       	call   8003b3 <diskaddr>
  80069b:	89 04 24             	mov    %eax,(%esp)
  80069e:	e8 48 fd ff ff       	call   8003eb <va_is_mapped>
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	84 c0                	test   %al,%al
  8006a8:	0f 85 fc 00 00 00    	jne    8007aa <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	6a 01                	push   $0x1
  8006b3:	e8 fb fc ff ff       	call   8003b3 <diskaddr>
  8006b8:	83 c4 08             	add    $0x8,%esp
  8006bb:	68 18 3b 80 00       	push   $0x803b18
  8006c0:	50                   	push   %eax
  8006c1:	e8 97 1c 00 00       	call   80235d <strcmp>
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	0f 85 f2 00 00 00    	jne    8007c3 <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	6a 01                	push   $0x1
  8006d6:	e8 d8 fc ff ff       	call   8003b3 <diskaddr>
  8006db:	83 c4 0c             	add    $0xc,%esp
  8006de:	68 08 01 00 00       	push   $0x108
  8006e3:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006e9:	52                   	push   %edx
  8006ea:	50                   	push   %eax
  8006eb:	e8 52 1d 00 00       	call   802442 <memmove>
	flush_block(diskaddr(1));
  8006f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006f7:	e8 b7 fc ff ff       	call   8003b3 <diskaddr>
  8006fc:	89 04 24             	mov    %eax,(%esp)
  8006ff:	e8 2d fd ff ff       	call   800431 <flush_block>
	cprintf("block cache is good\n");
  800704:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  80070b:	e8 d7 14 00 00       	call   801be7 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800710:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800717:	e8 97 fc ff ff       	call   8003b3 <diskaddr>
  80071c:	83 c4 0c             	add    $0xc,%esp
  80071f:	68 08 01 00 00       	push   $0x108
  800724:	50                   	push   %eax
  800725:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072b:	50                   	push   %eax
  80072c:	e8 11 1d 00 00       	call   802442 <memmove>
}
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800737:	c9                   	leave  
  800738:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800739:	68 3a 3b 80 00       	push   $0x803b3a
  80073e:	68 9d 39 80 00       	push   $0x80399d
  800743:	6a 69                	push   $0x69
  800745:	68 b0 3a 80 00       	push   $0x803ab0
  80074a:	e8 bd 13 00 00       	call   801b0c <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80074f:	68 1f 3b 80 00       	push   $0x803b1f
  800754:	68 9d 39 80 00       	push   $0x80399d
  800759:	6a 6a                	push   $0x6a
  80075b:	68 b0 3a 80 00       	push   $0x803ab0
  800760:	e8 a7 13 00 00       	call   801b0c <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800765:	68 39 3b 80 00       	push   $0x803b39
  80076a:	68 9d 39 80 00       	push   $0x80399d
  80076f:	6a 6e                	push   $0x6e
  800771:	68 b0 3a 80 00       	push   $0x803ab0
  800776:	e8 91 13 00 00       	call   801b0c <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80077b:	68 8c 3a 80 00       	push   $0x803a8c
  800780:	68 9d 39 80 00       	push   $0x80399d
  800785:	6a 71                	push   $0x71
  800787:	68 b0 3a 80 00       	push   $0x803ab0
  80078c:	e8 7b 13 00 00       	call   801b0c <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800791:	68 3a 3b 80 00       	push   $0x803b3a
  800796:	68 9d 39 80 00       	push   $0x80399d
  80079b:	68 82 00 00 00       	push   $0x82
  8007a0:	68 b0 3a 80 00       	push   $0x803ab0
  8007a5:	e8 62 13 00 00       	call   801b0c <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007aa:	68 39 3b 80 00       	push   $0x803b39
  8007af:	68 9d 39 80 00       	push   $0x80399d
  8007b4:	68 8a 00 00 00       	push   $0x8a
  8007b9:	68 b0 3a 80 00       	push   $0x803ab0
  8007be:	e8 49 13 00 00       	call   801b0c <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007c3:	68 8c 3a 80 00       	push   $0x803a8c
  8007c8:	68 9d 39 80 00       	push   $0x80399d
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 b0 3a 80 00       	push   $0x803ab0
  8007d7:	e8 30 13 00 00       	call   801b0c <_panic>

008007dc <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007e2:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8007e7:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007ed:	75 1b                	jne    80080a <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007ef:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007f6:	77 26                	ja     80081e <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	68 a7 3b 80 00       	push   $0x803ba7
  800800:	e8 e2 13 00 00       	call   801be7 <cprintf>
}
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	c9                   	leave  
  800809:	c3                   	ret    
		panic("bad file system magic number");
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 69 3b 80 00       	push   $0x803b69
  800812:	6a 12                	push   $0x12
  800814:	68 86 3b 80 00       	push   $0x803b86
  800819:	e8 ee 12 00 00       	call   801b0c <_panic>
		panic("file system is too large");
  80081e:	83 ec 04             	sub    $0x4,%esp
  800821:	68 8e 3b 80 00       	push   $0x803b8e
  800826:	6a 15                	push   $0x15
  800828:	68 86 3b 80 00       	push   $0x803b86
  80082d:	e8 da 12 00 00       	call   801b0c <_panic>

00800832 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	53                   	push   %ebx
  800836:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800839:	a1 04 a0 80 00       	mov    0x80a004,%eax
  80083e:	85 c0                	test   %eax,%eax
  800840:	74 29                	je     80086b <block_is_free+0x39>
		return 0;
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800847:	39 48 04             	cmp    %ecx,0x4(%eax)
  80084a:	76 18                	jbe    800864 <block_is_free+0x32>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80084c:	89 cb                	mov    %ecx,%ebx
  80084e:	c1 eb 05             	shr    $0x5,%ebx
  800851:	b8 01 00 00 00       	mov    $0x1,%eax
  800856:	d3 e0                	shl    %cl,%eax
  800858:	8b 15 00 a0 80 00    	mov    0x80a000,%edx
  80085e:	23 04 9a             	and    (%edx,%ebx,4),%eax
  800861:	0f 95 c2             	setne  %dl
		return 1;
	return 0;
}
  800864:	89 d0                	mov    %edx,%eax
  800866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800869:	c9                   	leave  
  80086a:	c3                   	ret    
		return 0;
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	eb f2                	jmp    800864 <block_is_free+0x32>

00800872 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  80087c:	85 c9                	test   %ecx,%ecx
  80087e:	74 1a                	je     80089a <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  800880:	89 cb                	mov    %ecx,%ebx
  800882:	c1 eb 05             	shr    $0x5,%ebx
  800885:	8b 15 00 a0 80 00    	mov    0x80a000,%edx
  80088b:	b8 01 00 00 00       	mov    $0x1,%eax
  800890:	d3 e0                	shl    %cl,%eax
  800892:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800898:	c9                   	leave  
  800899:	c3                   	ret    
		panic("attempt to free zero block");
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 bb 3b 80 00       	push   $0x803bbb
  8008a2:	6a 30                	push   $0x30
  8008a4:	68 86 3b 80 00       	push   $0x803b86
  8008a9:	e8 5e 12 00 00       	call   801b0c <_panic>

008008ae <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	57                   	push   %edi
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	for (int i = 0; i < super->s_nblocks; i++) {
  8008b4:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8008b9:	8b 58 04             	mov    0x4(%eax),%ebx
		if (!bitmap[i/32]) {
  8008bc:	8b 35 00 a0 80 00    	mov    0x80a000,%esi
	for (int i = 0; i < super->s_nblocks; i++) {
  8008c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c7:	eb 06                	jmp    8008cf <alloc_block+0x21>
			i += 31;
  8008c9:	83 c1 1f             	add    $0x1f,%ecx
	for (int i = 0; i < super->s_nblocks; i++) {
  8008cc:	83 c1 01             	add    $0x1,%ecx
  8008cf:	39 cb                	cmp    %ecx,%ebx
  8008d1:	76 25                	jbe    8008f8 <alloc_block+0x4a>
		if (!bitmap[i/32]) {
  8008d3:	8d 41 1f             	lea    0x1f(%ecx),%eax
  8008d6:	85 c9                	test   %ecx,%ecx
  8008d8:	0f 49 c1             	cmovns %ecx,%eax
  8008db:	c1 f8 05             	sar    $0x5,%eax
  8008de:	8d 14 86             	lea    (%esi,%eax,4),%edx
  8008e1:	8b 02                	mov    (%edx),%eax
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	74 e2                	je     8008c9 <alloc_block+0x1b>
			continue;
		}
		if (bitmap[i/32] & 1<<(i%32)) {
  8008e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8008ec:	d3 e7                	shl    %cl,%edi
  8008ee:	85 f8                	test   %edi,%eax
  8008f0:	74 da                	je     8008cc <alloc_block+0x1e>
			bitmap[i/32] -= 1<<(i%32);
  8008f2:	29 f8                	sub    %edi,%eax
  8008f4:	89 02                	mov    %eax,(%edx)
			return i;
  8008f6:	eb 05                	jmp    8008fd <alloc_block+0x4f>
		}
	}
	return -E_NO_DISK;
  8008f8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
}
  8008fd:	89 c8                	mov    %ecx,%eax
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5f                   	pop    %edi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	57                   	push   %edi
  800908:	56                   	push   %esi
  800909:	53                   	push   %ebx
  80090a:	83 ec 0c             	sub    $0xc,%esp
  80090d:	89 c6                	mov    %eax,%esi
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
       // LAB 5: Your code here.
	
	if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800912:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800918:	0f 87 9c 00 00 00    	ja     8009ba <file_block_walk+0xb6>
  80091e:	89 d3                	mov    %edx,%ebx
  800920:	89 cf                	mov    %ecx,%edi
	if (filebno < NDIRECT) {
  800922:	83 fa 09             	cmp    $0x9,%edx
  800925:	76 7a                	jbe    8009a1 <file_block_walk+0x9d>
		if (ppdiskbno) *ppdiskbno = &f->f_direct[filebno];
		return 0;
   	}
	if (!f->f_indirect) {
  800927:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  80092e:	75 44                	jne    800974 <file_block_walk+0x70>
		if (!alloc) return -E_NOT_FOUND;
  800930:	84 c0                	test   %al,%al
  800932:	0f 84 89 00 00 00    	je     8009c1 <file_block_walk+0xbd>
		f->f_indirect = alloc_block();
  800938:	e8 71 ff ff ff       	call   8008ae <alloc_block>
  80093d:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
		memset(BLK2VA(f->f_indirect), 0, BLKSIZE);
  800943:	83 ec 04             	sub    $0x4,%esp
  800946:	68 00 10 00 00       	push   $0x1000
  80094b:	6a 00                	push   $0x0
  80094d:	05 00 00 01 00       	add    $0x10000,%eax
  800952:	c1 e0 0c             	shl    $0xc,%eax
  800955:	50                   	push   %eax
  800956:	e8 a1 1a 00 00       	call   8023fc <memset>
		flush_block(BLK2VA(f->f_indirect));
  80095b:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800961:	05 00 00 01 00       	add    $0x10000,%eax
  800966:	c1 e0 0c             	shl    $0xc,%eax
  800969:	89 04 24             	mov    %eax,(%esp)
  80096c:	e8 c0 fa ff ff       	call   800431 <flush_block>
  800971:	83 c4 10             	add    $0x10,%esp
	}
	if (ppdiskbno) *ppdiskbno = (uint32_t **)((uint32_t)BLK2VA(f->f_indirect) + (filebno - NDIRECT) * 4);
	return 0;
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
	if (ppdiskbno) *ppdiskbno = (uint32_t **)((uint32_t)BLK2VA(f->f_indirect) + (filebno - NDIRECT) * 4);
  800979:	85 ff                	test   %edi,%edi
  80097b:	74 1c                	je     800999 <file_block_walk+0x95>
  80097d:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800983:	05 00 00 01 00       	add    $0x10000,%eax
  800988:	c1 e0 0a             	shl    $0xa,%eax
  80098b:	8d 44 03 f6          	lea    -0xa(%ebx,%eax,1),%eax
  80098f:	c1 e0 02             	shl    $0x2,%eax
  800992:	89 07                	mov    %eax,(%edi)
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099c:	5b                   	pop    %ebx
  80099d:	5e                   	pop    %esi
  80099e:	5f                   	pop    %edi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    
		return 0;
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ppdiskbno) *ppdiskbno = &f->f_direct[filebno];
  8009a6:	85 c9                	test   %ecx,%ecx
  8009a8:	74 ef                	je     800999 <file_block_walk+0x95>
  8009aa:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  8009b1:	89 01                	mov    %eax,(%ecx)
		return 0;
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b8:	eb df                	jmp    800999 <file_block_walk+0x95>
	if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  8009ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bf:	eb d8                	jmp    800999 <file_block_walk+0x95>
		if (!alloc) return -E_NOT_FOUND;
  8009c1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009c6:	eb d1                	jmp    800999 <file_block_walk+0x95>

008009c8 <check_bitmap>:
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009cd:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8009d2:	8b 70 04             	mov    0x4(%eax),%esi
  8009d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	c1 e0 0f             	shl    $0xf,%eax
  8009df:	39 c6                	cmp    %eax,%esi
  8009e1:	76 2e                	jbe    800a11 <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	8d 43 02             	lea    0x2(%ebx),%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 43 fe ff ff       	call   800832 <block_is_free>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	84 c0                	test   %al,%al
  8009f4:	75 05                	jne    8009fb <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009f6:	83 c3 01             	add    $0x1,%ebx
  8009f9:	eb df                	jmp    8009da <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  8009fb:	68 d6 3b 80 00       	push   $0x803bd6
  800a00:	68 9d 39 80 00       	push   $0x80399d
  800a05:	6a 5c                	push   $0x5c
  800a07:	68 86 3b 80 00       	push   $0x803b86
  800a0c:	e8 fb 10 00 00       	call   801b0c <_panic>
	assert(!block_is_free(0));
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	6a 00                	push   $0x0
  800a16:	e8 17 fe ff ff       	call   800832 <block_is_free>
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	84 c0                	test   %al,%al
  800a20:	75 28                	jne    800a4a <check_bitmap+0x82>
	assert(!block_is_free(1));
  800a22:	83 ec 0c             	sub    $0xc,%esp
  800a25:	6a 01                	push   $0x1
  800a27:	e8 06 fe ff ff       	call   800832 <block_is_free>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	84 c0                	test   %al,%al
  800a31:	75 2d                	jne    800a60 <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	68 0e 3c 80 00       	push   $0x803c0e
  800a3b:	e8 a7 11 00 00       	call   801be7 <cprintf>
}
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    
	assert(!block_is_free(0));
  800a4a:	68 ea 3b 80 00       	push   $0x803bea
  800a4f:	68 9d 39 80 00       	push   $0x80399d
  800a54:	6a 5f                	push   $0x5f
  800a56:	68 86 3b 80 00       	push   $0x803b86
  800a5b:	e8 ac 10 00 00       	call   801b0c <_panic>
	assert(!block_is_free(1));
  800a60:	68 fc 3b 80 00       	push   $0x803bfc
  800a65:	68 9d 39 80 00       	push   $0x80399d
  800a6a:	6a 60                	push   $0x60
  800a6c:	68 86 3b 80 00       	push   $0x803b86
  800a71:	e8 96 10 00 00       	call   801b0c <_panic>

00800a76 <fs_init>:
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a7c:	e8 e2 f5 ff ff       	call   800063 <ide_probe_disk1>
  800a81:	84 c0                	test   %al,%al
  800a83:	74 41                	je     800ac6 <fs_init+0x50>
		ide_set_disk(1);
  800a85:	83 ec 0c             	sub    $0xc,%esp
  800a88:	6a 01                	push   $0x1
  800a8a:	e8 36 f6 ff ff       	call   8000c5 <ide_set_disk>
  800a8f:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800a92:	e8 4f fa ff ff       	call   8004e6 <bc_init>
	super = diskaddr(1);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 01                	push   $0x1
  800a9c:	e8 12 f9 ff ff       	call   8003b3 <diskaddr>
  800aa1:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_super();
  800aa6:	e8 31 fd ff ff       	call   8007dc <check_super>
	bitmap = diskaddr(2);
  800aab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ab2:	e8 fc f8 ff ff       	call   8003b3 <diskaddr>
  800ab7:	a3 00 a0 80 00       	mov    %eax,0x80a000
	check_bitmap();
  800abc:	e8 07 ff ff ff       	call   8009c8 <check_bitmap>
}
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    
		ide_set_disk(0);
  800ac6:	83 ec 0c             	sub    $0xc,%esp
  800ac9:	6a 00                	push   $0x0
  800acb:	e8 f5 f5 ff ff       	call   8000c5 <ide_set_disk>
  800ad0:	83 c4 10             	add    $0x10,%esp
  800ad3:	eb bd                	jmp    800a92 <fs_init+0x1c>

00800ad5 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 14             	sub    $0x14,%esp
  800adc:	8b 55 0c             	mov    0xc(%ebp),%edx
       // LAB 5: Your code here.
	if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800adf:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800ae5:	77 6e                	ja     800b55 <file_get_block+0x80>
	int *blkno;
	file_block_walk(f, filebno, &blkno, 1);
  800ae7:	83 ec 0c             	sub    $0xc,%esp
  800aea:	6a 01                	push   $0x1
  800aec:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	e8 0d fe ff ff       	call   800904 <file_block_walk>
	if (*blkno == 0) {
  800af7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	83 3b 00             	cmpl   $0x0,(%ebx)
  800b00:	74 19                	je     800b1b <file_get_block+0x46>
		if ((*blkno = alloc_block()) < 0) return -E_NO_DISK;
		memset(BLK2VA(*blkno), 0, BLKSIZE);
		flush_block(BLK2VA(*blkno));
	} 
	*blk = BLK2VA(*blkno);
  800b02:	8b 03                	mov    (%ebx),%eax
  800b04:	05 00 00 01 00       	add    $0x10000,%eax
  800b09:	c1 e0 0c             	shl    $0xc,%eax
  800b0c:	8b 55 10             	mov    0x10(%ebp),%edx
  800b0f:	89 02                	mov    %eax,(%edx)
	return 0;
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    
		if ((*blkno = alloc_block()) < 0) return -E_NO_DISK;
  800b1b:	e8 8e fd ff ff       	call   8008ae <alloc_block>
  800b20:	89 03                	mov    %eax,(%ebx)
  800b22:	85 c0                	test   %eax,%eax
  800b24:	78 36                	js     800b5c <file_get_block+0x87>
		memset(BLK2VA(*blkno), 0, BLKSIZE);
  800b26:	83 ec 04             	sub    $0x4,%esp
  800b29:	68 00 10 00 00       	push   $0x1000
  800b2e:	6a 00                	push   $0x0
  800b30:	05 00 00 01 00       	add    $0x10000,%eax
  800b35:	c1 e0 0c             	shl    $0xc,%eax
  800b38:	50                   	push   %eax
  800b39:	e8 be 18 00 00       	call   8023fc <memset>
		flush_block(BLK2VA(*blkno));
  800b3e:	8b 03                	mov    (%ebx),%eax
  800b40:	05 00 00 01 00       	add    $0x10000,%eax
  800b45:	c1 e0 0c             	shl    $0xc,%eax
  800b48:	89 04 24             	mov    %eax,(%esp)
  800b4b:	e8 e1 f8 ff ff       	call   800431 <flush_block>
  800b50:	83 c4 10             	add    $0x10,%esp
  800b53:	eb ad                	jmp    800b02 <file_get_block+0x2d>
	if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800b55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b5a:	eb ba                	jmp    800b16 <file_get_block+0x41>
		if ((*blkno = alloc_block()) < 0) return -E_NO_DISK;
  800b5c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800b61:	eb b3                	jmp    800b16 <file_get_block+0x41>

00800b63 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b6f:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b75:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	while (*p == '/')
  800b7b:	eb 03                	jmp    800b80 <walk_path+0x1d>
		p++;
  800b7d:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b80:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b83:	74 f8                	je     800b7d <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b85:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  800b8b:	83 c1 08             	add    $0x8,%ecx
  800b8e:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b94:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b9b:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800ba1:	85 c9                	test   %ecx,%ecx
  800ba3:	74 06                	je     800bab <walk_path+0x48>
		*pdir = 0;
  800ba5:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800bab:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bb1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800bbc:	e9 c2 01 00 00       	jmp    800d83 <walk_path+0x220>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bc1:	83 c7 01             	add    $0x1,%edi
		while (*path != '/' && *path != '\0')
  800bc4:	0f b6 17             	movzbl (%edi),%edx
  800bc7:	80 fa 2f             	cmp    $0x2f,%dl
  800bca:	74 04                	je     800bd0 <walk_path+0x6d>
  800bcc:	84 d2                	test   %dl,%dl
  800bce:	75 f1                	jne    800bc1 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bd0:	89 fb                	mov    %edi,%ebx
  800bd2:	29 c3                	sub    %eax,%ebx
  800bd4:	83 fb 7f             	cmp    $0x7f,%ebx
  800bd7:	0f 8f 7e 01 00 00    	jg     800d5b <walk_path+0x1f8>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bdd:	83 ec 04             	sub    $0x4,%esp
  800be0:	53                   	push   %ebx
  800be1:	50                   	push   %eax
  800be2:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	e8 54 18 00 00       	call   802442 <memmove>
		name[path - p] = '\0';
  800bee:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bf5:	00 
	while (*p == '/')
  800bf6:	83 c4 10             	add    $0x10,%esp
  800bf9:	eb 03                	jmp    800bfe <walk_path+0x9b>
		p++;
  800bfb:	83 c7 01             	add    $0x1,%edi
	while (*p == '/')
  800bfe:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800c01:	74 f8                	je     800bfb <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c03:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c09:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c10:	0f 85 4c 01 00 00    	jne    800d62 <walk_path+0x1ff>
	assert((dir->f_size % BLKSIZE) == 0);
  800c16:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c1c:	89 c1                	mov    %eax,%ecx
  800c1e:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800c24:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800c2a:	0f 85 8e 00 00 00    	jne    800cbe <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800c30:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c36:	85 c0                	test   %eax,%eax
  800c38:	0f 48 c2             	cmovs  %edx,%eax
  800c3b:	c1 f8 0c             	sar    $0xc,%eax
  800c3e:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800c44:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800c4a:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c50:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c56:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c5c:	74 79                	je     800cd7 <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c67:	50                   	push   %eax
  800c68:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
  800c6e:	ff b5 4c ff ff ff    	push   -0xb4(%ebp)
  800c74:	e8 5c fe ff ff       	call   800ad5 <file_get_block>
  800c79:	83 c4 10             	add    $0x10,%esp
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	0f 88 a3 00 00 00    	js     800d27 <walk_path+0x1c4>
  800c84:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c8a:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800c90:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	e8 bd 16 00 00       	call   80235d <strcmp>
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	0f 84 be 00 00 00    	je     800d69 <walk_path+0x206>
		for (j = 0; j < BLKFILES; j++)
  800cab:	81 c3 00 01 00 00    	add    $0x100,%ebx
  800cb1:	39 df                	cmp    %ebx,%edi
  800cb3:	75 db                	jne    800c90 <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800cb5:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cbc:	eb 92                	jmp    800c50 <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800cbe:	68 1e 3c 80 00       	push   $0x803c1e
  800cc3:	68 9d 39 80 00       	push   $0x80399d
  800cc8:	68 cc 00 00 00       	push   $0xcc
  800ccd:	68 86 3b 80 00       	push   $0x803b86
  800cd2:	e8 35 0e 00 00       	call   801b0c <_panic>
  800cd7:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cdd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800ce2:	80 3f 00             	cmpb   $0x0,(%edi)
  800ce5:	75 6c                	jne    800d53 <walk_path+0x1f0>
				if (pdir)
  800ce7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ced:	85 c0                	test   %eax,%eax
  800cef:	74 08                	je     800cf9 <walk_path+0x196>
					*pdir = dir;
  800cf1:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cf7:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cfd:	74 15                	je     800d14 <walk_path+0x1b1>
					strcpy(lastelem, name);
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d08:	50                   	push   %eax
  800d09:	ff 75 08             	push   0x8(%ebp)
  800d0c:	e8 9b 15 00 00       	call   8022ac <strcpy>
  800d11:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d14:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d20:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d25:	eb 2c                	jmp    800d53 <walk_path+0x1f0>
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d27:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d2d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d30:	75 21                	jne    800d53 <walk_path+0x1f0>
  800d32:	eb a9                	jmp    800cdd <walk_path+0x17a>
		}
	}

	if (pdir)
  800d34:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	74 02                	je     800d40 <walk_path+0x1dd>
		*pdir = dir;
  800d3e:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d40:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d46:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d4c:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
			return -E_BAD_PATH;
  800d5b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d60:	eb f1                	jmp    800d53 <walk_path+0x1f0>
			return -E_NOT_FOUND;
  800d62:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d67:	eb ea                	jmp    800d53 <walk_path+0x1f0>
  800d69:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d6f:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d75:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800d7b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800d81:	89 f8                	mov    %edi,%eax
	while (*path != '\0') {
  800d83:	80 38 00             	cmpb   $0x0,(%eax)
  800d86:	74 ac                	je     800d34 <walk_path+0x1d1>
  800d88:	89 c7                	mov    %eax,%edi
  800d8a:	e9 35 fe ff ff       	jmp    800bc4 <walk_path+0x61>

00800d8f <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800d95:	6a 00                	push   $0x0
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	e8 bc fd ff ff       	call   800b63 <walk_path>
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 2c             	sub    $0x2c,%esp
  800db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800db5:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800dc6:	39 fa                	cmp    %edi,%edx
  800dc8:	7e 7a                	jle    800e44 <file_read+0x9b>

	count = MIN(count, f->f_size - offset);
  800dca:	29 fa                	sub    %edi,%edx
  800dcc:	39 ca                	cmp    %ecx,%edx
  800dce:	0f 46 ca             	cmovbe %edx,%ecx
  800dd1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800dd4:	89 fb                	mov    %edi,%ebx
  800dd6:	01 cf                	add    %ecx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	39 df                	cmp    %ebx,%edi
  800ddc:	76 63                	jbe    800e41 <file_read+0x98>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800dde:	83 ec 04             	sub    $0x4,%esp
  800de1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800de4:	50                   	push   %eax
  800de5:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800deb:	85 db                	test   %ebx,%ebx
  800ded:	0f 49 c3             	cmovns %ebx,%eax
  800df0:	c1 f8 0c             	sar    $0xc,%eax
  800df3:	50                   	push   %eax
  800df4:	ff 75 08             	push   0x8(%ebp)
  800df7:	e8 d9 fc ff ff       	call   800ad5 <file_get_block>
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	85 c0                	test   %eax,%eax
  800e01:	78 41                	js     800e44 <file_read+0x9b>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e03:	89 da                	mov    %ebx,%edx
  800e05:	c1 fa 1f             	sar    $0x1f,%edx
  800e08:	c1 ea 14             	shr    $0x14,%edx
  800e0b:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e0e:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e13:	29 d0                	sub    %edx,%eax
  800e15:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e1a:	29 c2                	sub    %eax,%edx
  800e1c:	89 f9                	mov    %edi,%ecx
  800e1e:	29 f1                	sub    %esi,%ecx
  800e20:	39 ca                	cmp    %ecx,%edx
  800e22:	89 ce                	mov    %ecx,%esi
  800e24:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	56                   	push   %esi
  800e2b:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e2e:	50                   	push   %eax
  800e2f:	ff 75 0c             	push   0xc(%ebp)
  800e32:	e8 0b 16 00 00       	call   802442 <memmove>
		pos += bn;
  800e37:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e39:	01 75 0c             	add    %esi,0xc(%ebp)
  800e3c:	83 c4 10             	add    $0x10,%esp
  800e3f:	eb 97                	jmp    800dd8 <file_read+0x2f>
	}

	return count;
  800e41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 2c             	sub    $0x2c,%esp
  800e55:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e58:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e61:	7f 1f                	jg     800e82 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	56                   	push   %esi
  800e70:	e8 bc f5 ff ff       	call   800431 <flush_block>
	return 0;
}
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e82:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800e88:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e8d:	0f 48 c2             	cmovs  %edx,%eax
  800e90:	c1 f8 0c             	sar    $0xc,%eax
  800e93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	05 fe 1f 00 00       	add    $0x1ffe,%eax
  800e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea1:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800ea7:	0f 49 c2             	cmovns %edx,%eax
  800eaa:	c1 f8 0c             	sar    $0xc,%eax
  800ead:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800eb0:	89 c3                	mov    %eax,%ebx
  800eb2:	eb 3c                	jmp    800ef0 <file_set_size+0xa4>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800eb4:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800eb8:	77 a9                	ja     800e63 <file_set_size+0x17>
  800eba:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	74 9f                	je     800e63 <file_set_size+0x17>
		free_block(f->f_indirect);
  800ec4:	83 ec 0c             	sub    $0xc,%esp
  800ec7:	50                   	push   %eax
  800ec8:	e8 a5 f9 ff ff       	call   800872 <free_block>
		f->f_indirect = 0;
  800ecd:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ed4:	00 00 00 
  800ed7:	83 c4 10             	add    $0x10,%esp
  800eda:	eb 87                	jmp    800e63 <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	50                   	push   %eax
  800ee0:	68 3b 3c 80 00       	push   $0x803c3b
  800ee5:	e8 fd 0c 00 00       	call   801be7 <cprintf>
  800eea:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800eed:	83 c3 01             	add    $0x1,%ebx
  800ef0:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800ef3:	76 bf                	jbe    800eb4 <file_set_size+0x68>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800ef5:	83 ec 0c             	sub    $0xc,%esp
  800ef8:	6a 00                	push   $0x0
  800efa:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800efd:	89 da                	mov    %ebx,%edx
  800eff:	89 f0                	mov    %esi,%eax
  800f01:	e8 fe f9 ff ff       	call   800904 <file_block_walk>
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	78 cf                	js     800edc <file_set_size+0x90>
	if (*ptr) {
  800f0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800f10:	8b 07                	mov    (%edi),%eax
  800f12:	85 c0                	test   %eax,%eax
  800f14:	74 d7                	je     800eed <file_set_size+0xa1>
		free_block(*ptr);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	e8 53 f9 ff ff       	call   800872 <free_block>
		*ptr = 0;
  800f1f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	eb c3                	jmp    800eed <file_set_size+0xa1>

00800f2a <file_write>:
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 1c             	sub    $0x1c,%esp
  800f33:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800f36:	89 df                	mov    %ebx,%edi
  800f38:	03 7d 10             	add    0x10(%ebp),%edi
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	3b b8 80 00 00 00    	cmp    0x80(%eax),%edi
  800f44:	77 69                	ja     800faf <file_write+0x85>
	for (pos = offset; pos < offset + count; ) {
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	39 df                	cmp    %ebx,%edi
  800f4a:	76 76                	jbe    800fc2 <file_write+0x98>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f52:	50                   	push   %eax
  800f53:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800f59:	85 db                	test   %ebx,%ebx
  800f5b:	0f 49 c3             	cmovns %ebx,%eax
  800f5e:	c1 f8 0c             	sar    $0xc,%eax
  800f61:	50                   	push   %eax
  800f62:	ff 75 08             	push   0x8(%ebp)
  800f65:	e8 6b fb ff ff       	call   800ad5 <file_get_block>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	78 54                	js     800fc5 <file_write+0x9b>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f71:	89 da                	mov    %ebx,%edx
  800f73:	c1 fa 1f             	sar    $0x1f,%edx
  800f76:	c1 ea 14             	shr    $0x14,%edx
  800f79:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f7c:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f81:	29 d0                	sub    %edx,%eax
  800f83:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f88:	29 c1                	sub    %eax,%ecx
  800f8a:	89 fa                	mov    %edi,%edx
  800f8c:	29 f2                	sub    %esi,%edx
  800f8e:	39 d1                	cmp    %edx,%ecx
  800f90:	89 d6                	mov    %edx,%esi
  800f92:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	56                   	push   %esi
  800f99:	ff 75 0c             	push   0xc(%ebp)
  800f9c:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	e8 9d 14 00 00       	call   802442 <memmove>
		pos += bn;
  800fa5:	01 f3                	add    %esi,%ebx
		buf += bn;
  800fa7:	01 75 0c             	add    %esi,0xc(%ebp)
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	eb 97                	jmp    800f46 <file_write+0x1c>
		if ((r = file_set_size(f, offset + count)) < 0)
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	57                   	push   %edi
  800fb3:	50                   	push   %eax
  800fb4:	e8 93 fe ff ff       	call   800e4c <file_set_size>
  800fb9:	83 c4 10             	add    $0x10,%esp
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	79 86                	jns    800f46 <file_write+0x1c>
  800fc0:	eb 03                	jmp    800fc5 <file_write+0x9b>
	return count;
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	83 ec 10             	sub    $0x10,%esp
  800fd5:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800fd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdd:	eb 03                	jmp    800fe2 <file_flush+0x15>
  800fdf:	83 c3 01             	add    $0x1,%ebx
  800fe2:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800fe8:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800fee:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800ff4:	0f 49 c2             	cmovns %edx,%eax
  800ff7:	c1 f8 0c             	sar    $0xc,%eax
  800ffa:	39 d8                	cmp    %ebx,%eax
  800ffc:	7e 3b                	jle    801039 <file_flush+0x6c>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	6a 00                	push   $0x0
  801003:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801006:	89 da                	mov    %ebx,%edx
  801008:	89 f0                	mov    %esi,%eax
  80100a:	e8 f5 f8 ff ff       	call   800904 <file_block_walk>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 c9                	js     800fdf <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801016:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801019:	85 c0                	test   %eax,%eax
  80101b:	74 c2                	je     800fdf <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  80101d:	8b 00                	mov    (%eax),%eax
  80101f:	85 c0                	test   %eax,%eax
  801021:	74 bc                	je     800fdf <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	50                   	push   %eax
  801027:	e8 87 f3 ff ff       	call   8003b3 <diskaddr>
  80102c:	89 04 24             	mov    %eax,(%esp)
  80102f:	e8 fd f3 ff ff       	call   800431 <flush_block>
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	eb a6                	jmp    800fdf <file_flush+0x12>
	}
	flush_block(f);
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	56                   	push   %esi
  80103d:	e8 ef f3 ff ff       	call   800431 <flush_block>
	if (f->f_indirect)
  801042:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801048:	83 c4 10             	add    $0x10,%esp
  80104b:	85 c0                	test   %eax,%eax
  80104d:	75 07                	jne    801056 <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
}
  80104f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	50                   	push   %eax
  80105a:	e8 54 f3 ff ff       	call   8003b3 <diskaddr>
  80105f:	89 04 24             	mov    %eax,(%esp)
  801062:	e8 ca f3 ff ff       	call   800431 <flush_block>
  801067:	83 c4 10             	add    $0x10,%esp
}
  80106a:	eb e3                	jmp    80104f <file_flush+0x82>

0080106c <file_create>:
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
  801072:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801078:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801085:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	e8 d0 fa ff ff       	call   800b63 <walk_path>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	0f 84 b9 00 00 00    	je     801157 <file_create+0xeb>
	if (r != -E_NOT_FOUND || dir == 0)
  80109e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8010a1:	0f 85 de 00 00 00    	jne    801185 <file_create+0x119>
  8010a7:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
  8010ad:	85 ff                	test   %edi,%edi
  8010af:	0f 84 d0 00 00 00    	je     801185 <file_create+0x119>
	assert((dir->f_size % BLKSIZE) == 0);
  8010b5:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
  8010bb:	89 c6                	mov    %eax,%esi
  8010bd:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  8010c3:	75 4f                	jne    801114 <file_create+0xa8>
	nblock = dir->f_size / BLKSIZE;
  8010c5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	0f 48 c2             	cmovs  %edx,%eax
  8010d0:	c1 f8 0c             	sar    $0xc,%eax
  8010d3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < nblock; i++) {
  8010d5:	39 f3                	cmp    %esi,%ebx
  8010d7:	74 54                	je     80112d <file_create+0xc1>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	56                   	push   %esi
  8010e4:	57                   	push   %edi
  8010e5:	e8 eb f9 ff ff       	call   800ad5 <file_get_block>
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	0f 88 90 00 00 00    	js     801185 <file_create+0x119>
  8010f5:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8010fb:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  801101:	80 38 00             	cmpb   $0x0,(%eax)
  801104:	74 58                	je     80115e <file_create+0xf2>
		for (j = 0; j < BLKFILES; j++)
  801106:	05 00 01 00 00       	add    $0x100,%eax
  80110b:	39 d0                	cmp    %edx,%eax
  80110d:	75 f2                	jne    801101 <file_create+0x95>
	for (i = 0; i < nblock; i++) {
  80110f:	83 c6 01             	add    $0x1,%esi
  801112:	eb c1                	jmp    8010d5 <file_create+0x69>
	assert((dir->f_size % BLKSIZE) == 0);
  801114:	68 1e 3c 80 00       	push   $0x803c1e
  801119:	68 9d 39 80 00       	push   $0x80399d
  80111e:	68 e5 00 00 00       	push   $0xe5
  801123:	68 86 3b 80 00       	push   $0x803b86
  801128:	e8 df 09 00 00       	call   801b0c <_panic>
	dir->f_size += BLKSIZE;
  80112d:	81 87 80 00 00 00 00 	addl   $0x1000,0x80(%edi)
  801134:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801140:	50                   	push   %eax
  801141:	56                   	push   %esi
  801142:	57                   	push   %edi
  801143:	e8 8d f9 ff ff       	call   800ad5 <file_get_block>
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	78 36                	js     801185 <file_create+0x119>
	f = (struct File*) blk;
  80114f:	8b 9d 5c ff ff ff    	mov    -0xa4(%ebp),%ebx
	return 0;
  801155:	eb 09                	jmp    801160 <file_create+0xf4>
		return -E_FILE_EXISTS;
  801157:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80115c:	eb 27                	jmp    801185 <file_create+0x119>
  80115e:	89 c3                	mov    %eax,%ebx
	strcpy(f->f_name, name);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	53                   	push   %ebx
  80116b:	e8 3c 11 00 00       	call   8022ac <strcpy>
	*pf = f;
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	89 18                	mov    %ebx,(%eax)
	file_flush(dir);
  801175:	89 3c 24             	mov    %edi,(%esp)
  801178:	e8 50 fe ff ff       	call   800fcd <file_flush>
	return 0;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	53                   	push   %ebx
  801191:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801194:	bb 01 00 00 00       	mov    $0x1,%ebx
  801199:	eb 17                	jmp    8011b2 <fs_sync+0x25>
		flush_block(diskaddr(i));
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	53                   	push   %ebx
  80119f:	e8 0f f2 ff ff       	call   8003b3 <diskaddr>
  8011a4:	89 04 24             	mov    %eax,(%esp)
  8011a7:	e8 85 f2 ff ff       	call   800431 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011ac:	83 c3 01             	add    $0x1,%ebx
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8011b7:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011ba:	77 df                	ja     80119b <fs_sync+0xe>
}
  8011bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8011c7:	e8 c1 ff ff ff       	call   80118d <fs_sync>
	return 0;
}
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <serve_init>:
{
  8011d3:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  8011d8:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  8011e2:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8011e4:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8011e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011ed:	83 c0 01             	add    $0x1,%eax
  8011f0:	83 c2 10             	add    $0x10,%edx
  8011f3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011f8:	75 e8                	jne    8011e2 <serve_init+0xf>
}
  8011fa:	c3                   	ret    

008011fb <openfile_alloc>:
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80120c:	89 de                	mov    %ebx,%esi
  80120e:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	ff b6 6c 50 80 00    	push   0x80506c(%esi)
  80121a:	e8 7b 1a 00 00       	call   802c9a <pageref>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	74 17                	je     80123d <openfile_alloc+0x42>
  801226:	83 f8 01             	cmp    $0x1,%eax
  801229:	74 30                	je     80125b <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  80122b:	83 c3 01             	add    $0x1,%ebx
  80122e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801234:	75 d6                	jne    80120c <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  801236:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80123b:	eb 4f                	jmp    80128c <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	6a 07                	push   $0x7
  801242:	89 d8                	mov    %ebx,%eax
  801244:	c1 e0 04             	shl    $0x4,%eax
  801247:	ff b0 6c 50 80 00    	push   0x80506c(%eax)
  80124d:	6a 00                	push   $0x0
  80124f:	e8 54 14 00 00       	call   8026a8 <sys_page_alloc>
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 31                	js     80128c <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  80125b:	c1 e3 04             	shl    $0x4,%ebx
  80125e:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801265:	04 00 00 
			*o = &opentab[i];
  801268:	81 c6 60 50 80 00    	add    $0x805060,%esi
  80126e:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	68 00 10 00 00       	push   $0x1000
  801278:	6a 00                	push   $0x0
  80127a:	ff b3 6c 50 80 00    	push   0x80506c(%ebx)
  801280:	e8 77 11 00 00       	call   8023fc <memset>
			return (*o)->o_fileid;
  801285:	8b 07                	mov    (%edi),%eax
  801287:	8b 00                	mov    (%eax),%eax
  801289:	83 c4 10             	add    $0x10,%esp
}
  80128c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128f:	5b                   	pop    %ebx
  801290:	5e                   	pop    %esi
  801291:	5f                   	pop    %edi
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <openfile_lookup>:
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	57                   	push   %edi
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
  80129a:	83 ec 18             	sub    $0x18,%esp
  80129d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012a0:	89 fb                	mov    %edi,%ebx
  8012a2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012a8:	89 de                	mov    %ebx,%esi
  8012aa:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012ad:	ff b6 6c 50 80 00    	push   0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012b3:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012b9:	e8 dc 19 00 00       	call   802c9a <pageref>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 f8 01             	cmp    $0x1,%eax
  8012c4:	7e 1d                	jle    8012e3 <openfile_lookup+0x4f>
  8012c6:	c1 e3 04             	shl    $0x4,%ebx
  8012c9:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  8012cf:	75 19                	jne    8012ea <openfile_lookup+0x56>
	*po = o;
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	89 30                	mov    %esi,(%eax)
	return 0;
  8012d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5f                   	pop    %edi
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    
		return -E_INVAL;
  8012e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e8:	eb f1                	jmp    8012db <openfile_lookup+0x47>
  8012ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ef:	eb ea                	jmp    8012db <openfile_lookup+0x47>

008012f1 <serve_set_size>:
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	53                   	push   %ebx
  8012f5:	83 ec 18             	sub    $0x18,%esp
  8012f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8012fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fe:	50                   	push   %eax
  8012ff:	ff 33                	push   (%ebx)
  801301:	ff 75 08             	push   0x8(%ebp)
  801304:	e8 8b ff ff ff       	call   801294 <openfile_lookup>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 14                	js     801324 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	ff 73 04             	push   0x4(%ebx)
  801316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801319:	ff 70 04             	push   0x4(%eax)
  80131c:	e8 2b fb ff ff       	call   800e4c <file_set_size>
  801321:	83 c4 10             	add    $0x10,%esp
}
  801324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <serve_read>:
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	83 ec 14             	sub    $0x14,%esp
  801331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((err = openfile_lookup(envid, req->req_fileid, &o)) < 0) return err;
  801334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	ff 33                	push   (%ebx)
  80133a:	ff 75 08             	push   0x8(%ebp)
  80133d:	e8 52 ff ff ff       	call   801294 <openfile_lookup>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 2d                	js     801376 <serve_read+0x4d>
	if ((err = file_read(o->o_file, ret->ret_buf, count, o->o_fd->fd_offset)) < 0) return err;
  801349:	8b 75 f4             	mov    -0xc(%ebp),%esi
  80134c:	8b 46 0c             	mov    0xc(%esi),%eax
  80134f:	ff 70 04             	push   0x4(%eax)
	int count = req->req_n < PGSIZE ? req->req_n : PGSIZE;
  801352:	8b 43 04             	mov    0x4(%ebx),%eax
  801355:	ba 00 10 00 00       	mov    $0x1000,%edx
  80135a:	39 d0                	cmp    %edx,%eax
  80135c:	0f 47 c2             	cmova  %edx,%eax
	if ((err = file_read(o->o_file, ret->ret_buf, count, o->o_fd->fd_offset)) < 0) return err;
  80135f:	50                   	push   %eax
  801360:	53                   	push   %ebx
  801361:	ff 76 04             	push   0x4(%esi)
  801364:	e8 40 fa ff ff       	call   800da9 <file_read>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	78 06                	js     801376 <serve_read+0x4d>
	o->o_fd->fd_offset += err;
  801370:	8b 56 0c             	mov    0xc(%esi),%edx
  801373:	01 42 04             	add    %eax,0x4(%edx)
}
  801376:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <serve_write>:
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 14             	sub    $0x14,%esp
  801385:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((err = openfile_lookup(envid, req->req_fileid, &o)) < 0) return err;
  801388:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	ff 33                	push   (%ebx)
  80138e:	ff 75 08             	push   0x8(%ebp)
  801391:	e8 fe fe ff ff       	call   801294 <openfile_lookup>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 30                	js     8013cd <serve_write+0x50>
	if ((err = file_write(o->o_file, req->req_buf, count, o->o_fd->fd_offset)) < 0) return err;
  80139d:	8b 75 f4             	mov    -0xc(%ebp),%esi
  8013a0:	8b 46 0c             	mov    0xc(%esi),%eax
  8013a3:	ff 70 04             	push   0x4(%eax)
	int count = req->req_n < PGSIZE ? req->req_n : PGSIZE;
  8013a6:	8b 43 04             	mov    0x4(%ebx),%eax
  8013a9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013ae:	39 d0                	cmp    %edx,%eax
  8013b0:	0f 47 c2             	cmova  %edx,%eax
	if ((err = file_write(o->o_file, req->req_buf, count, o->o_fd->fd_offset)) < 0) return err;
  8013b3:	50                   	push   %eax
  8013b4:	83 c3 08             	add    $0x8,%ebx
  8013b7:	53                   	push   %ebx
  8013b8:	ff 76 04             	push   0x4(%esi)
  8013bb:	e8 6a fb ff ff       	call   800f2a <file_write>
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 06                	js     8013cd <serve_write+0x50>
	o->o_fd->fd_offset += err;
  8013c7:	8b 56 0c             	mov    0xc(%esi),%edx
  8013ca:	01 42 04             	add    %eax,0x4(%edx)
}
  8013cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d0:	5b                   	pop    %ebx
  8013d1:	5e                   	pop    %esi
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <serve_stat>:
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 14             	sub    $0x14,%esp
  8013dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	ff 33                	push   (%ebx)
  8013e5:	ff 75 08             	push   0x8(%ebp)
  8013e8:	e8 a7 fe ff ff       	call   801294 <openfile_lookup>
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	78 3c                	js     801430 <serve_stat+0x5c>
	strcpy(ret->ret_name, o->o_file->f_name);
  8013f4:	8b 75 f4             	mov    -0xc(%ebp),%esi
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	ff 76 04             	push   0x4(%esi)
  8013fd:	53                   	push   %ebx
  8013fe:	e8 a9 0e 00 00       	call   8022ac <strcpy>
	ret->ret_size = o->o_file->f_size;
  801403:	8b 46 04             	mov    0x4(%esi),%eax
  801406:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  80140c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801412:	8b 46 04             	mov    0x4(%esi),%eax
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80141f:	0f 94 c0             	sete   %al
  801422:	0f b6 c0             	movzbl %al,%eax
  801425:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801430:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <serve_flush>:
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80143d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	ff 30                	push   (%eax)
  801446:	ff 75 08             	push   0x8(%ebp)
  801449:	e8 46 fe ff ff       	call   801294 <openfile_lookup>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 16                	js     80146b <serve_flush+0x34>
	file_flush(o->o_file);
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	ff 70 04             	push   0x4(%eax)
  80145e:	e8 6a fb ff ff       	call   800fcd <file_flush>
	return 0;
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <serve_open>:
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801477:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  80147a:	68 00 04 00 00       	push   $0x400
  80147f:	53                   	push   %ebx
  801480:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	e8 b6 0f 00 00       	call   802442 <memmove>
	path[MAXPATHLEN-1] = 0;
  80148c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  801490:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801496:	89 04 24             	mov    %eax,(%esp)
  801499:	e8 5d fd ff ff       	call   8011fb <openfile_alloc>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	0f 88 ea 00 00 00    	js     801593 <serve_open+0x126>
	if (req->req_omode & O_CREAT) {
  8014a9:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014b0:	74 33                	je     8014e5 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	e8 a4 fb ff ff       	call   80106c <file_create>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	79 37                	jns    801506 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014cf:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8014d6:	0f 85 b7 00 00 00    	jne    801593 <serve_open+0x126>
  8014dc:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8014df:	0f 85 ae 00 00 00    	jne    801593 <serve_open+0x126>
		if ((r = file_open(path, &f)) < 0) {
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	e8 94 f8 ff ff       	call   800d8f <file_open>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	0f 88 8d 00 00 00    	js     801593 <serve_open+0x126>
	if (req->req_omode & O_TRUNC) {
  801506:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  80150d:	74 17                	je     801526 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	6a 00                	push   $0x0
  801514:	ff b5 f4 fb ff ff    	push   -0x40c(%ebp)
  80151a:	e8 2d f9 ff ff       	call   800e4c <file_set_size>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 6d                	js     801593 <serve_open+0x126>
	if ((r = file_open(path, &f)) < 0) {
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801536:	50                   	push   %eax
  801537:	e8 53 f8 ff ff       	call   800d8f <file_open>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 50                	js     801593 <serve_open+0x126>
	o->o_file = f;
  801543:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801549:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80154f:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801552:	8b 50 0c             	mov    0xc(%eax),%edx
  801555:	8b 08                	mov    (%eax),%ecx
  801557:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80155a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80155d:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801563:	83 e2 03             	and    $0x3,%edx
  801566:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801569:	8b 50 0c             	mov    0xc(%eax),%edx
  80156c:	8b 0d 64 90 80 00    	mov    0x809064,%ecx
  801572:	89 0a                	mov    %ecx,(%edx)
	o->o_mode = req->req_omode;
  801574:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80157a:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  80157d:	8b 50 0c             	mov    0xc(%eax),%edx
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015a0:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015a3:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015a6:	eb 13                	jmp    8015bb <serve+0x23>
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	ff 75 f4             	push   -0xc(%ebp)
  8015ae:	68 58 3c 80 00       	push   $0x803c58
  8015b3:	e8 2f 06 00 00       	call   801be7 <cprintf>
				whom);
			continue; // just leave it hanging...
  8015b8:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8015bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	53                   	push   %ebx
  8015c6:	ff 35 44 50 80 00    	push   0x805044
  8015cc:	56                   	push   %esi
  8015cd:	e8 5a 13 00 00       	call   80292c <ipc_recv>
		if (!(perm & PTE_P)) {
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8015d9:	74 cd                	je     8015a8 <serve+0x10>
		}

		pg = NULL;
  8015db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8015e2:	83 f8 01             	cmp    $0x1,%eax
  8015e5:	74 23                	je     80160a <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8015e7:	83 f8 08             	cmp    $0x8,%eax
  8015ea:	77 36                	ja     801622 <serve+0x8a>
  8015ec:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8015f3:	85 d2                	test   %edx,%edx
  8015f5:	74 2b                	je     801622 <serve+0x8a>
			r = handlers[req](whom, fsreq);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 35 44 50 80 00    	push   0x805044
  801600:	ff 75 f4             	push   -0xc(%ebp)
  801603:	ff d2                	call   *%edx
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	eb 31                	jmp    80163b <serve+0xa3>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80160a:	53                   	push   %ebx
  80160b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	ff 35 44 50 80 00    	push   0x805044
  801615:	ff 75 f4             	push   -0xc(%ebp)
  801618:	e8 50 fe ff ff       	call   80146d <serve_open>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	eb 19                	jmp    80163b <serve+0xa3>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	ff 75 f4             	push   -0xc(%ebp)
  801628:	50                   	push   %eax
  801629:	68 88 3c 80 00       	push   $0x803c88
  80162e:	e8 b4 05 00 00       	call   801be7 <cprintf>
  801633:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801636:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80163b:	ff 75 f0             	push   -0x10(%ebp)
  80163e:	ff 75 ec             	push   -0x14(%ebp)
  801641:	50                   	push   %eax
  801642:	ff 75 f4             	push   -0xc(%ebp)
  801645:	e8 31 13 00 00       	call   80297b <ipc_send>
		sys_page_unmap(0, fsreq);
  80164a:	83 c4 08             	add    $0x8,%esp
  80164d:	ff 35 44 50 80 00    	push   0x805044
  801653:	6a 00                	push   $0x0
  801655:	e8 d3 10 00 00       	call   80272d <sys_page_unmap>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	e9 59 ff ff ff       	jmp    8015bb <serve+0x23>

00801662 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801668:	c7 05 60 90 80 00 ab 	movl   $0x803cab,0x809060
  80166f:	3c 80 00 
	cprintf("FS is running\n");
  801672:	68 ae 3c 80 00       	push   $0x803cae
  801677:	e8 6b 05 00 00       	call   801be7 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80167c:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801681:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801686:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801688:	c7 04 24 bd 3c 80 00 	movl   $0x803cbd,(%esp)
  80168f:	e8 53 05 00 00       	call   801be7 <cprintf>

	serve_init();
  801694:	e8 3a fb ff ff       	call   8011d3 <serve_init>
	fs_init();
  801699:	e8 d8 f3 ff ff       	call   800a76 <fs_init>
        fs_test();
  80169e:	e8 05 00 00 00       	call   8016a8 <fs_test>
	serve();
  8016a3:	e8 f0 fe ff ff       	call   801598 <serve>

008016a8 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016ae:	6a 07                	push   $0x7
  8016b0:	68 00 10 00 00       	push   $0x1000
  8016b5:	6a 00                	push   $0x0
  8016b7:	e8 ec 0f 00 00       	call   8026a8 <sys_page_alloc>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	0f 88 59 02 00 00    	js     801920 <fs_test+0x278>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	68 00 10 00 00       	push   $0x1000
  8016cf:	ff 35 00 a0 80 00    	push   0x80a000
  8016d5:	68 00 10 00 00       	push   $0x1000
  8016da:	e8 63 0d 00 00       	call   802442 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8016df:	e8 ca f1 ff ff       	call   8008ae <alloc_block>
  8016e4:	89 c1                	mov    %eax,%ecx
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	0f 88 41 02 00 00    	js     801932 <fs_test+0x28a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8016f1:	8d 40 1f             	lea    0x1f(%eax),%eax
  8016f4:	0f 49 c1             	cmovns %ecx,%eax
  8016f7:	c1 f8 05             	sar    $0x5,%eax
  8016fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8016ff:	d3 e2                	shl    %cl,%edx
  801701:	89 d1                	mov    %edx,%ecx
  801703:	23 0c 85 00 10 00 00 	and    0x1000(,%eax,4),%ecx
  80170a:	0f 84 34 02 00 00    	je     801944 <fs_test+0x29c>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801710:	8b 0d 00 a0 80 00    	mov    0x80a000,%ecx
  801716:	23 14 81             	and    (%ecx,%eax,4),%edx
  801719:	0f 85 3b 02 00 00    	jne    80195a <fs_test+0x2b2>
	cprintf("alloc_block is good\n");
  80171f:	83 ec 0c             	sub    $0xc,%esp
  801722:	68 14 3d 80 00       	push   $0x803d14
  801727:	e8 bb 04 00 00       	call   801be7 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80172c:	83 c4 08             	add    $0x8,%esp
  80172f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	68 29 3d 80 00       	push   $0x803d29
  801738:	e8 52 f6 ff ff       	call   800d8f <file_open>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801743:	74 08                	je     80174d <fs_test+0xa5>
  801745:	85 c0                	test   %eax,%eax
  801747:	0f 88 23 02 00 00    	js     801970 <fs_test+0x2c8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  80174d:	85 c0                	test   %eax,%eax
  80174f:	0f 84 2d 02 00 00    	je     801982 <fs_test+0x2da>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175b:	50                   	push   %eax
  80175c:	68 4d 3d 80 00       	push   $0x803d4d
  801761:	e8 29 f6 ff ff       	call   800d8f <file_open>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	0f 88 25 02 00 00    	js     801996 <fs_test+0x2ee>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	68 6d 3d 80 00       	push   $0x803d6d
  801779:	e8 69 04 00 00       	call   801be7 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80177e:	83 c4 0c             	add    $0xc,%esp
  801781:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801784:	50                   	push   %eax
  801785:	6a 00                	push   $0x0
  801787:	ff 75 f4             	push   -0xc(%ebp)
  80178a:	e8 46 f3 ff ff       	call   800ad5 <file_get_block>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	0f 88 0e 02 00 00    	js     8019a8 <fs_test+0x300>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80179a:	83 ec 08             	sub    $0x8,%esp
  80179d:	68 b4 3e 80 00       	push   $0x803eb4
  8017a2:	ff 75 f0             	push   -0x10(%ebp)
  8017a5:	e8 b3 0b 00 00       	call   80235d <strcmp>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	0f 85 05 02 00 00    	jne    8019ba <fs_test+0x312>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	68 93 3d 80 00       	push   $0x803d93
  8017bd:	e8 25 04 00 00       	call   801be7 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	0f b6 10             	movzbl (%eax),%edx
  8017c8:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cd:	c1 e8 0c             	shr    $0xc,%eax
  8017d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	a8 40                	test   $0x40,%al
  8017dc:	0f 84 ec 01 00 00    	je     8019ce <fs_test+0x326>
	file_flush(f);
  8017e2:	83 ec 0c             	sub    $0xc,%esp
  8017e5:	ff 75 f4             	push   -0xc(%ebp)
  8017e8:	e8 e0 f7 ff ff       	call   800fcd <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f0:	c1 e8 0c             	shr    $0xc,%eax
  8017f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	a8 40                	test   $0x40,%al
  8017ff:	0f 85 df 01 00 00    	jne    8019e4 <fs_test+0x33c>
	cprintf("file_flush is good\n");
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	68 c7 3d 80 00       	push   $0x803dc7
  80180d:	e8 d5 03 00 00       	call   801be7 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801812:	83 c4 08             	add    $0x8,%esp
  801815:	6a 00                	push   $0x0
  801817:	ff 75 f4             	push   -0xc(%ebp)
  80181a:	e8 2d f6 ff ff       	call   800e4c <file_set_size>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	0f 88 d0 01 00 00    	js     8019fa <fs_test+0x352>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801834:	0f 85 d2 01 00 00    	jne    801a0c <fs_test+0x364>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80183a:	c1 e8 0c             	shr    $0xc,%eax
  80183d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801844:	a8 40                	test   $0x40,%al
  801846:	0f 85 d6 01 00 00    	jne    801a22 <fs_test+0x37a>
	cprintf("file_truncate is good\n");
  80184c:	83 ec 0c             	sub    $0xc,%esp
  80184f:	68 1b 3e 80 00       	push   $0x803e1b
  801854:	e8 8e 03 00 00       	call   801be7 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801859:	c7 04 24 b4 3e 80 00 	movl   $0x803eb4,(%esp)
  801860:	e8 0c 0a 00 00       	call   802271 <strlen>
  801865:	83 c4 08             	add    $0x8,%esp
  801868:	50                   	push   %eax
  801869:	ff 75 f4             	push   -0xc(%ebp)
  80186c:	e8 db f5 ff ff       	call   800e4c <file_set_size>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	0f 88 bc 01 00 00    	js     801a38 <fs_test+0x390>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187f:	89 c2                	mov    %eax,%edx
  801881:	c1 ea 0c             	shr    $0xc,%edx
  801884:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80188b:	f6 c2 40             	test   $0x40,%dl
  80188e:	0f 85 b6 01 00 00    	jne    801a4a <fs_test+0x3a2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80189a:	52                   	push   %edx
  80189b:	6a 00                	push   $0x0
  80189d:	50                   	push   %eax
  80189e:	e8 32 f2 ff ff       	call   800ad5 <file_get_block>
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	0f 88 b2 01 00 00    	js     801a60 <fs_test+0x3b8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	68 b4 3e 80 00       	push   $0x803eb4
  8018b6:	ff 75 f0             	push   -0x10(%ebp)
  8018b9:	e8 ee 09 00 00       	call   8022ac <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	c1 e8 0c             	shr    $0xc,%eax
  8018c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	a8 40                	test   $0x40,%al
  8018d0:	0f 84 9c 01 00 00    	je     801a72 <fs_test+0x3ca>
	file_flush(f);
  8018d6:	83 ec 0c             	sub    $0xc,%esp
  8018d9:	ff 75 f4             	push   -0xc(%ebp)
  8018dc:	e8 ec f6 ff ff       	call   800fcd <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	c1 e8 0c             	shr    $0xc,%eax
  8018e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	a8 40                	test   $0x40,%al
  8018f3:	0f 85 8f 01 00 00    	jne    801a88 <fs_test+0x3e0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	c1 e8 0c             	shr    $0xc,%eax
  8018ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801906:	a8 40                	test   $0x40,%al
  801908:	0f 85 90 01 00 00    	jne    801a9e <fs_test+0x3f6>
	cprintf("file rewrite is good\n");
  80190e:	83 ec 0c             	sub    $0xc,%esp
  801911:	68 5b 3e 80 00       	push   $0x803e5b
  801916:	e8 cc 02 00 00       	call   801be7 <cprintf>
}
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801920:	50                   	push   %eax
  801921:	68 cc 3c 80 00       	push   $0x803ccc
  801926:	6a 12                	push   $0x12
  801928:	68 df 3c 80 00       	push   $0x803cdf
  80192d:	e8 da 01 00 00       	call   801b0c <_panic>
		panic("alloc_block: %e", r);
  801932:	50                   	push   %eax
  801933:	68 e9 3c 80 00       	push   $0x803ce9
  801938:	6a 17                	push   $0x17
  80193a:	68 df 3c 80 00       	push   $0x803cdf
  80193f:	e8 c8 01 00 00       	call   801b0c <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801944:	68 f9 3c 80 00       	push   $0x803cf9
  801949:	68 9d 39 80 00       	push   $0x80399d
  80194e:	6a 19                	push   $0x19
  801950:	68 df 3c 80 00       	push   $0x803cdf
  801955:	e8 b2 01 00 00       	call   801b0c <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80195a:	68 74 3e 80 00       	push   $0x803e74
  80195f:	68 9d 39 80 00       	push   $0x80399d
  801964:	6a 1b                	push   $0x1b
  801966:	68 df 3c 80 00       	push   $0x803cdf
  80196b:	e8 9c 01 00 00       	call   801b0c <_panic>
		panic("file_open /not-found: %e", r);
  801970:	50                   	push   %eax
  801971:	68 34 3d 80 00       	push   $0x803d34
  801976:	6a 1f                	push   $0x1f
  801978:	68 df 3c 80 00       	push   $0x803cdf
  80197d:	e8 8a 01 00 00       	call   801b0c <_panic>
		panic("file_open /not-found succeeded!");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 94 3e 80 00       	push   $0x803e94
  80198a:	6a 21                	push   $0x21
  80198c:	68 df 3c 80 00       	push   $0x803cdf
  801991:	e8 76 01 00 00       	call   801b0c <_panic>
		panic("file_open /newmotd: %e", r);
  801996:	50                   	push   %eax
  801997:	68 56 3d 80 00       	push   $0x803d56
  80199c:	6a 23                	push   $0x23
  80199e:	68 df 3c 80 00       	push   $0x803cdf
  8019a3:	e8 64 01 00 00       	call   801b0c <_panic>
		panic("file_get_block: %e", r);
  8019a8:	50                   	push   %eax
  8019a9:	68 80 3d 80 00       	push   $0x803d80
  8019ae:	6a 27                	push   $0x27
  8019b0:	68 df 3c 80 00       	push   $0x803cdf
  8019b5:	e8 52 01 00 00       	call   801b0c <_panic>
		panic("file_get_block returned wrong data");
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	68 dc 3e 80 00       	push   $0x803edc
  8019c2:	6a 29                	push   $0x29
  8019c4:	68 df 3c 80 00       	push   $0x803cdf
  8019c9:	e8 3e 01 00 00       	call   801b0c <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8019ce:	68 ac 3d 80 00       	push   $0x803dac
  8019d3:	68 9d 39 80 00       	push   $0x80399d
  8019d8:	6a 2d                	push   $0x2d
  8019da:	68 df 3c 80 00       	push   $0x803cdf
  8019df:	e8 28 01 00 00       	call   801b0c <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019e4:	68 ab 3d 80 00       	push   $0x803dab
  8019e9:	68 9d 39 80 00       	push   $0x80399d
  8019ee:	6a 2f                	push   $0x2f
  8019f0:	68 df 3c 80 00       	push   $0x803cdf
  8019f5:	e8 12 01 00 00       	call   801b0c <_panic>
		panic("file_set_size: %e", r);
  8019fa:	50                   	push   %eax
  8019fb:	68 db 3d 80 00       	push   $0x803ddb
  801a00:	6a 33                	push   $0x33
  801a02:	68 df 3c 80 00       	push   $0x803cdf
  801a07:	e8 00 01 00 00       	call   801b0c <_panic>
	assert(f->f_direct[0] == 0);
  801a0c:	68 ed 3d 80 00       	push   $0x803ded
  801a11:	68 9d 39 80 00       	push   $0x80399d
  801a16:	6a 34                	push   $0x34
  801a18:	68 df 3c 80 00       	push   $0x803cdf
  801a1d:	e8 ea 00 00 00       	call   801b0c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a22:	68 01 3e 80 00       	push   $0x803e01
  801a27:	68 9d 39 80 00       	push   $0x80399d
  801a2c:	6a 35                	push   $0x35
  801a2e:	68 df 3c 80 00       	push   $0x803cdf
  801a33:	e8 d4 00 00 00       	call   801b0c <_panic>
		panic("file_set_size 2: %e", r);
  801a38:	50                   	push   %eax
  801a39:	68 32 3e 80 00       	push   $0x803e32
  801a3e:	6a 39                	push   $0x39
  801a40:	68 df 3c 80 00       	push   $0x803cdf
  801a45:	e8 c2 00 00 00       	call   801b0c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a4a:	68 01 3e 80 00       	push   $0x803e01
  801a4f:	68 9d 39 80 00       	push   $0x80399d
  801a54:	6a 3a                	push   $0x3a
  801a56:	68 df 3c 80 00       	push   $0x803cdf
  801a5b:	e8 ac 00 00 00       	call   801b0c <_panic>
		panic("file_get_block 2: %e", r);
  801a60:	50                   	push   %eax
  801a61:	68 46 3e 80 00       	push   $0x803e46
  801a66:	6a 3c                	push   $0x3c
  801a68:	68 df 3c 80 00       	push   $0x803cdf
  801a6d:	e8 9a 00 00 00       	call   801b0c <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a72:	68 ac 3d 80 00       	push   $0x803dac
  801a77:	68 9d 39 80 00       	push   $0x80399d
  801a7c:	6a 3e                	push   $0x3e
  801a7e:	68 df 3c 80 00       	push   $0x803cdf
  801a83:	e8 84 00 00 00       	call   801b0c <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a88:	68 ab 3d 80 00       	push   $0x803dab
  801a8d:	68 9d 39 80 00       	push   $0x80399d
  801a92:	6a 40                	push   $0x40
  801a94:	68 df 3c 80 00       	push   $0x803cdf
  801a99:	e8 6e 00 00 00       	call   801b0c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a9e:	68 01 3e 80 00       	push   $0x803e01
  801aa3:	68 9d 39 80 00       	push   $0x80399d
  801aa8:	6a 41                	push   $0x41
  801aaa:	68 df 3c 80 00       	push   $0x803cdf
  801aaf:	e8 58 00 00 00       	call   801b0c <_panic>

00801ab4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	56                   	push   %esi
  801ab8:	53                   	push   %ebx
  801ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801abc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801abf:	e8 a6 0b 00 00       	call   80266a <sys_getenvid>
  801ac4:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ac9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801acc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ad1:	a3 08 a0 80 00       	mov    %eax,0x80a008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801ad6:	85 db                	test   %ebx,%ebx
  801ad8:	7e 07                	jle    801ae1 <libmain+0x2d>
		binaryname = argv[0];
  801ada:	8b 06                	mov    (%esi),%eax
  801adc:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	e8 77 fb ff ff       	call   801662 <umain>

	// exit gracefully
	exit();
  801aeb:	e8 0a 00 00 00       	call   801afa <exit>
}
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  801b00:	6a 00                	push   $0x0
  801b02:	e8 22 0b 00 00       	call   802629 <sys_env_destroy>
}
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	56                   	push   %esi
  801b10:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b11:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b14:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b1a:	e8 4b 0b 00 00       	call   80266a <sys_getenvid>
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	ff 75 0c             	push   0xc(%ebp)
  801b25:	ff 75 08             	push   0x8(%ebp)
  801b28:	56                   	push   %esi
  801b29:	50                   	push   %eax
  801b2a:	68 0c 3f 80 00       	push   $0x803f0c
  801b2f:	e8 b3 00 00 00       	call   801be7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b34:	83 c4 18             	add    $0x18,%esp
  801b37:	53                   	push   %ebx
  801b38:	ff 75 10             	push   0x10(%ebp)
  801b3b:	e8 56 00 00 00       	call   801b96 <vcprintf>
	cprintf("\n");
  801b40:	c7 04 24 1d 3b 80 00 	movl   $0x803b1d,(%esp)
  801b47:	e8 9b 00 00 00       	call   801be7 <cprintf>
  801b4c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b4f:	cc                   	int3   
  801b50:	eb fd                	jmp    801b4f <_panic+0x43>

00801b52 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801b5c:	8b 13                	mov    (%ebx),%edx
  801b5e:	8d 42 01             	lea    0x1(%edx),%eax
  801b61:	89 03                	mov    %eax,(%ebx)
  801b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b66:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801b6a:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b6f:	74 09                	je     801b7a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801b71:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	68 ff 00 00 00       	push   $0xff
  801b82:	8d 43 08             	lea    0x8(%ebx),%eax
  801b85:	50                   	push   %eax
  801b86:	e8 61 0a 00 00       	call   8025ec <sys_cputs>
		b->idx = 0;
  801b8b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	eb db                	jmp    801b71 <putch+0x1f>

00801b96 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b9f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ba6:	00 00 00 
	b.cnt = 0;
  801ba9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bb0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801bb3:	ff 75 0c             	push   0xc(%ebp)
  801bb6:	ff 75 08             	push   0x8(%ebp)
  801bb9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bbf:	50                   	push   %eax
  801bc0:	68 52 1b 80 00       	push   $0x801b52
  801bc5:	e8 14 01 00 00       	call   801cde <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801bca:	83 c4 08             	add    $0x8,%esp
  801bcd:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  801bd3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801bd9:	50                   	push   %eax
  801bda:	e8 0d 0a 00 00       	call   8025ec <sys_cputs>

	return b.cnt;
}
  801bdf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bed:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 08             	push   0x8(%ebp)
  801bf4:	e8 9d ff ff ff       	call   801b96 <vcprintf>
	va_end(ap);

	return cnt;
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	57                   	push   %edi
  801bff:	56                   	push   %esi
  801c00:	53                   	push   %ebx
  801c01:	83 ec 1c             	sub    $0x1c,%esp
  801c04:	89 c7                	mov    %eax,%edi
  801c06:	89 d6                	mov    %edx,%esi
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	89 d1                	mov    %edx,%ecx
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c15:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801c18:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801c28:	39 c2                	cmp    %eax,%edx
  801c2a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801c2d:	72 3e                	jb     801c6d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c2f:	83 ec 0c             	sub    $0xc,%esp
  801c32:	ff 75 18             	push   0x18(%ebp)
  801c35:	83 eb 01             	sub    $0x1,%ebx
  801c38:	53                   	push   %ebx
  801c39:	50                   	push   %eax
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	ff 75 e4             	push   -0x1c(%ebp)
  801c40:	ff 75 e0             	push   -0x20(%ebp)
  801c43:	ff 75 dc             	push   -0x24(%ebp)
  801c46:	ff 75 d8             	push   -0x28(%ebp)
  801c49:	e8 d2 1a 00 00       	call   803720 <__udivdi3>
  801c4e:	83 c4 18             	add    $0x18,%esp
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	89 f2                	mov    %esi,%edx
  801c55:	89 f8                	mov    %edi,%eax
  801c57:	e8 9f ff ff ff       	call   801bfb <printnum>
  801c5c:	83 c4 20             	add    $0x20,%esp
  801c5f:	eb 13                	jmp    801c74 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c61:	83 ec 08             	sub    $0x8,%esp
  801c64:	56                   	push   %esi
  801c65:	ff 75 18             	push   0x18(%ebp)
  801c68:	ff d7                	call   *%edi
  801c6a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801c6d:	83 eb 01             	sub    $0x1,%ebx
  801c70:	85 db                	test   %ebx,%ebx
  801c72:	7f ed                	jg     801c61 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c74:	83 ec 08             	sub    $0x8,%esp
  801c77:	56                   	push   %esi
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	ff 75 e4             	push   -0x1c(%ebp)
  801c7e:	ff 75 e0             	push   -0x20(%ebp)
  801c81:	ff 75 dc             	push   -0x24(%ebp)
  801c84:	ff 75 d8             	push   -0x28(%ebp)
  801c87:	e8 b4 1b 00 00       	call   803840 <__umoddi3>
  801c8c:	83 c4 14             	add    $0x14,%esp
  801c8f:	0f be 80 2f 3f 80 00 	movsbl 0x803f2f(%eax),%eax
  801c96:	50                   	push   %eax
  801c97:	ff d7                	call   *%edi
}
  801c99:	83 c4 10             	add    $0x10,%esp
  801c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801caa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801cae:	8b 10                	mov    (%eax),%edx
  801cb0:	3b 50 04             	cmp    0x4(%eax),%edx
  801cb3:	73 0a                	jae    801cbf <sprintputch+0x1b>
		*b->buf++ = ch;
  801cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cb8:	89 08                	mov    %ecx,(%eax)
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	88 02                	mov    %al,(%edx)
}
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <printfmt>:
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801cc7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801cca:	50                   	push   %eax
  801ccb:	ff 75 10             	push   0x10(%ebp)
  801cce:	ff 75 0c             	push   0xc(%ebp)
  801cd1:	ff 75 08             	push   0x8(%ebp)
  801cd4:	e8 05 00 00 00       	call   801cde <vprintfmt>
}
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <vprintfmt>:
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 3c             	sub    $0x3c,%esp
  801ce7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ced:	8b 7d 10             	mov    0x10(%ebp),%edi
  801cf0:	eb 0a                	jmp    801cfc <vprintfmt+0x1e>
			putch(ch, putdat);
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	53                   	push   %ebx
  801cf6:	50                   	push   %eax
  801cf7:	ff d6                	call   *%esi
  801cf9:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cfc:	83 c7 01             	add    $0x1,%edi
  801cff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801d03:	83 f8 25             	cmp    $0x25,%eax
  801d06:	74 0c                	je     801d14 <vprintfmt+0x36>
			if (ch == '\0')
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	75 e6                	jne    801cf2 <vprintfmt+0x14>
}
  801d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
		padc = ' ';
  801d14:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801d18:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801d1f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  801d26:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  801d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d32:	8d 47 01             	lea    0x1(%edi),%eax
  801d35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d38:	0f b6 17             	movzbl (%edi),%edx
  801d3b:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d3e:	3c 55                	cmp    $0x55,%al
  801d40:	0f 87 a6 04 00 00    	ja     8021ec <vprintfmt+0x50e>
  801d46:	0f b6 c0             	movzbl %al,%eax
  801d49:	ff 24 85 80 40 80 00 	jmp    *0x804080(,%eax,4)
  801d50:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  801d53:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801d57:	eb d9                	jmp    801d32 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801d59:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d5c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801d60:	eb d0                	jmp    801d32 <vprintfmt+0x54>
  801d62:	0f b6 d2             	movzbl %dl,%edx
  801d65:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d70:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801d73:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801d77:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801d7a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801d7d:	83 f9 09             	cmp    $0x9,%ecx
  801d80:	77 55                	ja     801dd7 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801d82:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801d85:	eb e9                	jmp    801d70 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801d87:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8a:	8b 00                	mov    (%eax),%eax
  801d8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d92:	8d 40 04             	lea    0x4(%eax),%eax
  801d95:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801d98:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  801d9b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801d9f:	79 91                	jns    801d32 <vprintfmt+0x54>
				width = precision, precision = -1;
  801da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801da7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801dae:	eb 82                	jmp    801d32 <vprintfmt+0x54>
  801db0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801db3:	85 d2                	test   %edx,%edx
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	0f 49 c2             	cmovns %edx,%eax
  801dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dc0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  801dc3:	e9 6a ff ff ff       	jmp    801d32 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801dc8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  801dcb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801dd2:	e9 5b ff ff ff       	jmp    801d32 <vprintfmt+0x54>
  801dd7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801dda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ddd:	eb bc                	jmp    801d9b <vprintfmt+0xbd>
			lflag++;
  801ddf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801de2:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  801de5:	e9 48 ff ff ff       	jmp    801d32 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  801dea:	8b 45 14             	mov    0x14(%ebp),%eax
  801ded:	8d 78 04             	lea    0x4(%eax),%edi
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	53                   	push   %ebx
  801df4:	ff 30                	push   (%eax)
  801df6:	ff d6                	call   *%esi
			break;
  801df8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801dfb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801dfe:	e9 88 03 00 00       	jmp    80218b <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  801e03:	8b 45 14             	mov    0x14(%ebp),%eax
  801e06:	8d 78 04             	lea    0x4(%eax),%edi
  801e09:	8b 10                	mov    (%eax),%edx
  801e0b:	89 d0                	mov    %edx,%eax
  801e0d:	f7 d8                	neg    %eax
  801e0f:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e12:	83 f8 0f             	cmp    $0xf,%eax
  801e15:	7f 23                	jg     801e3a <vprintfmt+0x15c>
  801e17:	8b 14 85 e0 41 80 00 	mov    0x8041e0(,%eax,4),%edx
  801e1e:	85 d2                	test   %edx,%edx
  801e20:	74 18                	je     801e3a <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  801e22:	52                   	push   %edx
  801e23:	68 af 39 80 00       	push   $0x8039af
  801e28:	53                   	push   %ebx
  801e29:	56                   	push   %esi
  801e2a:	e8 92 fe ff ff       	call   801cc1 <printfmt>
  801e2f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e32:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e35:	e9 51 03 00 00       	jmp    80218b <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  801e3a:	50                   	push   %eax
  801e3b:	68 47 3f 80 00       	push   $0x803f47
  801e40:	53                   	push   %ebx
  801e41:	56                   	push   %esi
  801e42:	e8 7a fe ff ff       	call   801cc1 <printfmt>
  801e47:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e4a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e4d:	e9 39 03 00 00       	jmp    80218b <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  801e52:	8b 45 14             	mov    0x14(%ebp),%eax
  801e55:	83 c0 04             	add    $0x4,%eax
  801e58:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801e5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801e60:	85 d2                	test   %edx,%edx
  801e62:	b8 40 3f 80 00       	mov    $0x803f40,%eax
  801e67:	0f 45 c2             	cmovne %edx,%eax
  801e6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801e6d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e71:	7e 06                	jle    801e79 <vprintfmt+0x19b>
  801e73:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801e77:	75 0d                	jne    801e86 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e7c:	89 c7                	mov    %eax,%edi
  801e7e:	03 45 d4             	add    -0x2c(%ebp),%eax
  801e81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801e84:	eb 55                	jmp    801edb <vprintfmt+0x1fd>
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	ff 75 e0             	push   -0x20(%ebp)
  801e8c:	ff 75 cc             	push   -0x34(%ebp)
  801e8f:	e8 f5 03 00 00       	call   802289 <strnlen>
  801e94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e97:	29 c2                	sub    %eax,%edx
  801e99:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801ea1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801ea5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801ea8:	eb 0f                	jmp    801eb9 <vprintfmt+0x1db>
					putch(padc, putdat);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	53                   	push   %ebx
  801eae:	ff 75 d4             	push   -0x2c(%ebp)
  801eb1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801eb3:	83 ef 01             	sub    $0x1,%edi
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	85 ff                	test   %edi,%edi
  801ebb:	7f ed                	jg     801eaa <vprintfmt+0x1cc>
  801ebd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801ec0:	85 d2                	test   %edx,%edx
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	0f 49 c2             	cmovns %edx,%eax
  801eca:	29 c2                	sub    %eax,%edx
  801ecc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  801ecf:	eb a8                	jmp    801e79 <vprintfmt+0x19b>
					putch(ch, putdat);
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	53                   	push   %ebx
  801ed5:	52                   	push   %edx
  801ed6:	ff d6                	call   *%esi
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801ede:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ee0:	83 c7 01             	add    $0x1,%edi
  801ee3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ee7:	0f be d0             	movsbl %al,%edx
  801eea:	85 d2                	test   %edx,%edx
  801eec:	74 4b                	je     801f39 <vprintfmt+0x25b>
  801eee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ef2:	78 06                	js     801efa <vprintfmt+0x21c>
  801ef4:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  801ef8:	78 1e                	js     801f18 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  801efa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801efe:	74 d1                	je     801ed1 <vprintfmt+0x1f3>
  801f00:	0f be c0             	movsbl %al,%eax
  801f03:	83 e8 20             	sub    $0x20,%eax
  801f06:	83 f8 5e             	cmp    $0x5e,%eax
  801f09:	76 c6                	jbe    801ed1 <vprintfmt+0x1f3>
					putch('?', putdat);
  801f0b:	83 ec 08             	sub    $0x8,%esp
  801f0e:	53                   	push   %ebx
  801f0f:	6a 3f                	push   $0x3f
  801f11:	ff d6                	call   *%esi
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	eb c3                	jmp    801edb <vprintfmt+0x1fd>
  801f18:	89 cf                	mov    %ecx,%edi
  801f1a:	eb 0e                	jmp    801f2a <vprintfmt+0x24c>
				putch(' ', putdat);
  801f1c:	83 ec 08             	sub    $0x8,%esp
  801f1f:	53                   	push   %ebx
  801f20:	6a 20                	push   $0x20
  801f22:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f24:	83 ef 01             	sub    $0x1,%edi
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 ff                	test   %edi,%edi
  801f2c:	7f ee                	jg     801f1c <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  801f2e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f31:	89 45 14             	mov    %eax,0x14(%ebp)
  801f34:	e9 52 02 00 00       	jmp    80218b <vprintfmt+0x4ad>
  801f39:	89 cf                	mov    %ecx,%edi
  801f3b:	eb ed                	jmp    801f2a <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  801f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f40:	83 c0 04             	add    $0x4,%eax
  801f43:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f46:	8b 45 14             	mov    0x14(%ebp),%eax
  801f49:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801f4b:	85 d2                	test   %edx,%edx
  801f4d:	b8 40 3f 80 00       	mov    $0x803f40,%eax
  801f52:	0f 45 c2             	cmovne %edx,%eax
  801f55:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801f58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f5c:	7e 06                	jle    801f64 <vprintfmt+0x286>
  801f5e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801f62:	75 0d                	jne    801f71 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f67:	89 c7                	mov    %eax,%edi
  801f69:	03 45 d4             	add    -0x2c(%ebp),%eax
  801f6c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801f6f:	eb 55                	jmp    801fc6 <vprintfmt+0x2e8>
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	ff 75 e0             	push   -0x20(%ebp)
  801f77:	ff 75 cc             	push   -0x34(%ebp)
  801f7a:	e8 0a 03 00 00       	call   802289 <strnlen>
  801f7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f82:	29 c2                	sub    %eax,%edx
  801f84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801f8c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f93:	eb 0f                	jmp    801fa4 <vprintfmt+0x2c6>
					putch(padc, putdat);
  801f95:	83 ec 08             	sub    $0x8,%esp
  801f98:	53                   	push   %ebx
  801f99:	ff 75 d4             	push   -0x2c(%ebp)
  801f9c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801f9e:	83 ef 01             	sub    $0x1,%edi
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	85 ff                	test   %edi,%edi
  801fa6:	7f ed                	jg     801f95 <vprintfmt+0x2b7>
  801fa8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801fab:	85 d2                	test   %edx,%edx
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	0f 49 c2             	cmovns %edx,%eax
  801fb5:	29 c2                	sub    %eax,%edx
  801fb7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  801fba:	eb a8                	jmp    801f64 <vprintfmt+0x286>
					putch(ch, putdat);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	53                   	push   %ebx
  801fc0:	52                   	push   %edx
  801fc1:	ff d6                	call   *%esi
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801fc9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  801fcb:	83 c7 01             	add    $0x1,%edi
  801fce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fd2:	0f be d0             	movsbl %al,%edx
  801fd5:	3c 3a                	cmp    $0x3a,%al
  801fd7:	74 4b                	je     802024 <vprintfmt+0x346>
  801fd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fdd:	78 06                	js     801fe5 <vprintfmt+0x307>
  801fdf:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  801fe3:	78 1e                	js     802003 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  801fe5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fe9:	74 d1                	je     801fbc <vprintfmt+0x2de>
  801feb:	0f be c0             	movsbl %al,%eax
  801fee:	83 e8 20             	sub    $0x20,%eax
  801ff1:	83 f8 5e             	cmp    $0x5e,%eax
  801ff4:	76 c6                	jbe    801fbc <vprintfmt+0x2de>
					putch('?', putdat);
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	53                   	push   %ebx
  801ffa:	6a 3f                	push   $0x3f
  801ffc:	ff d6                	call   *%esi
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	eb c3                	jmp    801fc6 <vprintfmt+0x2e8>
  802003:	89 cf                	mov    %ecx,%edi
  802005:	eb 0e                	jmp    802015 <vprintfmt+0x337>
				putch(' ', putdat);
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	53                   	push   %ebx
  80200b:	6a 20                	push   $0x20
  80200d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80200f:	83 ef 01             	sub    $0x1,%edi
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 ff                	test   %edi,%edi
  802017:	7f ee                	jg     802007 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  802019:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80201c:	89 45 14             	mov    %eax,0x14(%ebp)
  80201f:	e9 67 01 00 00       	jmp    80218b <vprintfmt+0x4ad>
  802024:	89 cf                	mov    %ecx,%edi
  802026:	eb ed                	jmp    802015 <vprintfmt+0x337>
	if (lflag >= 2)
  802028:	83 f9 01             	cmp    $0x1,%ecx
  80202b:	7f 1b                	jg     802048 <vprintfmt+0x36a>
	else if (lflag)
  80202d:	85 c9                	test   %ecx,%ecx
  80202f:	74 63                	je     802094 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  802031:	8b 45 14             	mov    0x14(%ebp),%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802039:	99                   	cltd   
  80203a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80203d:	8b 45 14             	mov    0x14(%ebp),%eax
  802040:	8d 40 04             	lea    0x4(%eax),%eax
  802043:	89 45 14             	mov    %eax,0x14(%ebp)
  802046:	eb 17                	jmp    80205f <vprintfmt+0x381>
		return va_arg(*ap, long long);
  802048:	8b 45 14             	mov    0x14(%ebp),%eax
  80204b:	8b 50 04             	mov    0x4(%eax),%edx
  80204e:	8b 00                	mov    (%eax),%eax
  802050:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802053:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802056:	8b 45 14             	mov    0x14(%ebp),%eax
  802059:	8d 40 08             	lea    0x8(%eax),%eax
  80205c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80205f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802062:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  802065:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80206a:	85 c9                	test   %ecx,%ecx
  80206c:	0f 89 ff 00 00 00    	jns    802171 <vprintfmt+0x493>
				putch('-', putdat);
  802072:	83 ec 08             	sub    $0x8,%esp
  802075:	53                   	push   %ebx
  802076:	6a 2d                	push   $0x2d
  802078:	ff d6                	call   *%esi
				num = -(long long) num;
  80207a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802080:	f7 da                	neg    %edx
  802082:	83 d1 00             	adc    $0x0,%ecx
  802085:	f7 d9                	neg    %ecx
  802087:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80208a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80208f:	e9 dd 00 00 00       	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, int);
  802094:	8b 45 14             	mov    0x14(%ebp),%eax
  802097:	8b 00                	mov    (%eax),%eax
  802099:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80209c:	99                   	cltd   
  80209d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8020a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a3:	8d 40 04             	lea    0x4(%eax),%eax
  8020a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8020a9:	eb b4                	jmp    80205f <vprintfmt+0x381>
	if (lflag >= 2)
  8020ab:	83 f9 01             	cmp    $0x1,%ecx
  8020ae:	7f 1e                	jg     8020ce <vprintfmt+0x3f0>
	else if (lflag)
  8020b0:	85 c9                	test   %ecx,%ecx
  8020b2:	74 32                	je     8020e6 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8020b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b7:	8b 10                	mov    (%eax),%edx
  8020b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020be:	8d 40 04             	lea    0x4(%eax),%eax
  8020c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020c4:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8020c9:	e9 a3 00 00 00       	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8020ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d1:	8b 10                	mov    (%eax),%edx
  8020d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8020d6:	8d 40 08             	lea    0x8(%eax),%eax
  8020d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020dc:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8020e1:	e9 8b 00 00 00       	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8020e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e9:	8b 10                	mov    (%eax),%edx
  8020eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f0:	8d 40 04             	lea    0x4(%eax),%eax
  8020f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020f6:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8020fb:	eb 74                	jmp    802171 <vprintfmt+0x493>
	if (lflag >= 2)
  8020fd:	83 f9 01             	cmp    $0x1,%ecx
  802100:	7f 1b                	jg     80211d <vprintfmt+0x43f>
	else if (lflag)
  802102:	85 c9                	test   %ecx,%ecx
  802104:	74 2c                	je     802132 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  802106:	8b 45 14             	mov    0x14(%ebp),%eax
  802109:	8b 10                	mov    (%eax),%edx
  80210b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802110:	8d 40 04             	lea    0x4(%eax),%eax
  802113:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802116:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80211b:	eb 54                	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80211d:	8b 45 14             	mov    0x14(%ebp),%eax
  802120:	8b 10                	mov    (%eax),%edx
  802122:	8b 48 04             	mov    0x4(%eax),%ecx
  802125:	8d 40 08             	lea    0x8(%eax),%eax
  802128:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80212b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  802130:	eb 3f                	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  802132:	8b 45 14             	mov    0x14(%ebp),%eax
  802135:	8b 10                	mov    (%eax),%edx
  802137:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213c:	8d 40 04             	lea    0x4(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802142:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  802147:	eb 28                	jmp    802171 <vprintfmt+0x493>
			putch('0', putdat);
  802149:	83 ec 08             	sub    $0x8,%esp
  80214c:	53                   	push   %ebx
  80214d:	6a 30                	push   $0x30
  80214f:	ff d6                	call   *%esi
			putch('x', putdat);
  802151:	83 c4 08             	add    $0x8,%esp
  802154:	53                   	push   %ebx
  802155:	6a 78                	push   $0x78
  802157:	ff d6                	call   *%esi
			num = (unsigned long long)
  802159:	8b 45 14             	mov    0x14(%ebp),%eax
  80215c:	8b 10                	mov    (%eax),%edx
  80215e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  802163:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  802166:	8d 40 04             	lea    0x4(%eax),%eax
  802169:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80216c:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  802178:	50                   	push   %eax
  802179:	ff 75 d4             	push   -0x2c(%ebp)
  80217c:	57                   	push   %edi
  80217d:	51                   	push   %ecx
  80217e:	52                   	push   %edx
  80217f:	89 da                	mov    %ebx,%edx
  802181:	89 f0                	mov    %esi,%eax
  802183:	e8 73 fa ff ff       	call   801bfb <printnum>
			break;
  802188:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80218b:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80218e:	e9 69 fb ff ff       	jmp    801cfc <vprintfmt+0x1e>
	if (lflag >= 2)
  802193:	83 f9 01             	cmp    $0x1,%ecx
  802196:	7f 1b                	jg     8021b3 <vprintfmt+0x4d5>
	else if (lflag)
  802198:	85 c9                	test   %ecx,%ecx
  80219a:	74 2c                	je     8021c8 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80219c:	8b 45 14             	mov    0x14(%ebp),%eax
  80219f:	8b 10                	mov    (%eax),%edx
  8021a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a6:	8d 40 04             	lea    0x4(%eax),%eax
  8021a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021ac:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8021b1:	eb be                	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8021b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b6:	8b 10                	mov    (%eax),%edx
  8021b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8021bb:	8d 40 08             	lea    0x8(%eax),%eax
  8021be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c1:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8021c6:	eb a9                	jmp    802171 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8021c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cb:	8b 10                	mov    (%eax),%edx
  8021cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021d2:	8d 40 04             	lea    0x4(%eax),%eax
  8021d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021d8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8021dd:	eb 92                	jmp    802171 <vprintfmt+0x493>
			putch(ch, putdat);
  8021df:	83 ec 08             	sub    $0x8,%esp
  8021e2:	53                   	push   %ebx
  8021e3:	6a 25                	push   $0x25
  8021e5:	ff d6                	call   *%esi
			break;
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	eb 9f                	jmp    80218b <vprintfmt+0x4ad>
			putch('%', putdat);
  8021ec:	83 ec 08             	sub    $0x8,%esp
  8021ef:	53                   	push   %ebx
  8021f0:	6a 25                	push   $0x25
  8021f2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	89 f8                	mov    %edi,%eax
  8021f9:	eb 03                	jmp    8021fe <vprintfmt+0x520>
  8021fb:	83 e8 01             	sub    $0x1,%eax
  8021fe:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802202:	75 f7                	jne    8021fb <vprintfmt+0x51d>
  802204:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802207:	eb 82                	jmp    80218b <vprintfmt+0x4ad>

00802209 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 18             	sub    $0x18,%esp
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802215:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802218:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80221c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80221f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802226:	85 c0                	test   %eax,%eax
  802228:	74 26                	je     802250 <vsnprintf+0x47>
  80222a:	85 d2                	test   %edx,%edx
  80222c:	7e 22                	jle    802250 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80222e:	ff 75 14             	push   0x14(%ebp)
  802231:	ff 75 10             	push   0x10(%ebp)
  802234:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802237:	50                   	push   %eax
  802238:	68 a4 1c 80 00       	push   $0x801ca4
  80223d:	e8 9c fa ff ff       	call   801cde <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	83 c4 10             	add    $0x10,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    
		return -E_INVAL;
  802250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802255:	eb f7                	jmp    80224e <vsnprintf+0x45>

00802257 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80225d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802260:	50                   	push   %eax
  802261:	ff 75 10             	push   0x10(%ebp)
  802264:	ff 75 0c             	push   0xc(%ebp)
  802267:	ff 75 08             	push   0x8(%ebp)
  80226a:	e8 9a ff ff ff       	call   802209 <vsnprintf>
	va_end(ap);

	return rc;
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	eb 03                	jmp    802281 <strlen+0x10>
		n++;
  80227e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  802281:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802285:	75 f7                	jne    80227e <strlen+0xd>
	return n;
}
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
  802297:	eb 03                	jmp    80229c <strnlen+0x13>
		n++;
  802299:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80229c:	39 d0                	cmp    %edx,%eax
  80229e:	74 08                	je     8022a8 <strnlen+0x1f>
  8022a0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022a4:	75 f3                	jne    802299 <strnlen+0x10>
  8022a6:	89 c2                	mov    %eax,%edx
	return n;
}
  8022a8:	89 d0                	mov    %edx,%eax
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    

008022ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	53                   	push   %ebx
  8022b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8022bf:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8022c2:	83 c0 01             	add    $0x1,%eax
  8022c5:	84 d2                	test   %dl,%dl
  8022c7:	75 f2                	jne    8022bb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8022c9:	89 c8                	mov    %ecx,%eax
  8022cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 10             	sub    $0x10,%esp
  8022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8022da:	53                   	push   %ebx
  8022db:	e8 91 ff ff ff       	call   802271 <strlen>
  8022e0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8022e3:	ff 75 0c             	push   0xc(%ebp)
  8022e6:	01 d8                	add    %ebx,%eax
  8022e8:	50                   	push   %eax
  8022e9:	e8 be ff ff ff       	call   8022ac <strcpy>
	return dst;
}
  8022ee:	89 d8                	mov    %ebx,%eax
  8022f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	56                   	push   %esi
  8022f9:	53                   	push   %ebx
  8022fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8022fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802300:	89 f3                	mov    %esi,%ebx
  802302:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802305:	89 f0                	mov    %esi,%eax
  802307:	eb 0f                	jmp    802318 <strncpy+0x23>
		*dst++ = *src;
  802309:	83 c0 01             	add    $0x1,%eax
  80230c:	0f b6 0a             	movzbl (%edx),%ecx
  80230f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802312:	80 f9 01             	cmp    $0x1,%cl
  802315:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  802318:	39 d8                	cmp    %ebx,%eax
  80231a:	75 ed                	jne    802309 <strncpy+0x14>
	}
	return ret;
}
  80231c:	89 f0                	mov    %esi,%eax
  80231e:	5b                   	pop    %ebx
  80231f:	5e                   	pop    %esi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	56                   	push   %esi
  802326:	53                   	push   %ebx
  802327:	8b 75 08             	mov    0x8(%ebp),%esi
  80232a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80232d:	8b 55 10             	mov    0x10(%ebp),%edx
  802330:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802332:	85 d2                	test   %edx,%edx
  802334:	74 21                	je     802357 <strlcpy+0x35>
  802336:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80233a:	89 f2                	mov    %esi,%edx
  80233c:	eb 09                	jmp    802347 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80233e:	83 c1 01             	add    $0x1,%ecx
  802341:	83 c2 01             	add    $0x1,%edx
  802344:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  802347:	39 c2                	cmp    %eax,%edx
  802349:	74 09                	je     802354 <strlcpy+0x32>
  80234b:	0f b6 19             	movzbl (%ecx),%ebx
  80234e:	84 db                	test   %bl,%bl
  802350:	75 ec                	jne    80233e <strlcpy+0x1c>
  802352:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802354:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802357:	29 f0                	sub    %esi,%eax
}
  802359:	5b                   	pop    %ebx
  80235a:	5e                   	pop    %esi
  80235b:	5d                   	pop    %ebp
  80235c:	c3                   	ret    

0080235d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802363:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802366:	eb 06                	jmp    80236e <strcmp+0x11>
		p++, q++;
  802368:	83 c1 01             	add    $0x1,%ecx
  80236b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80236e:	0f b6 01             	movzbl (%ecx),%eax
  802371:	84 c0                	test   %al,%al
  802373:	74 04                	je     802379 <strcmp+0x1c>
  802375:	3a 02                	cmp    (%edx),%al
  802377:	74 ef                	je     802368 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802379:	0f b6 c0             	movzbl %al,%eax
  80237c:	0f b6 12             	movzbl (%edx),%edx
  80237f:	29 d0                	sub    %edx,%eax
}
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    

00802383 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	53                   	push   %ebx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	89 c3                	mov    %eax,%ebx
  80238f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802392:	eb 06                	jmp    80239a <strncmp+0x17>
		n--, p++, q++;
  802394:	83 c0 01             	add    $0x1,%eax
  802397:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80239a:	39 d8                	cmp    %ebx,%eax
  80239c:	74 18                	je     8023b6 <strncmp+0x33>
  80239e:	0f b6 08             	movzbl (%eax),%ecx
  8023a1:	84 c9                	test   %cl,%cl
  8023a3:	74 04                	je     8023a9 <strncmp+0x26>
  8023a5:	3a 0a                	cmp    (%edx),%cl
  8023a7:	74 eb                	je     802394 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023a9:	0f b6 00             	movzbl (%eax),%eax
  8023ac:	0f b6 12             	movzbl (%edx),%edx
  8023af:	29 d0                	sub    %edx,%eax
}
  8023b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    
		return 0;
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	eb f4                	jmp    8023b1 <strncmp+0x2e>

008023bd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8023c7:	eb 03                	jmp    8023cc <strchr+0xf>
  8023c9:	83 c0 01             	add    $0x1,%eax
  8023cc:	0f b6 10             	movzbl (%eax),%edx
  8023cf:	84 d2                	test   %dl,%dl
  8023d1:	74 06                	je     8023d9 <strchr+0x1c>
		if (*s == c)
  8023d3:	38 ca                	cmp    %cl,%dl
  8023d5:	75 f2                	jne    8023c9 <strchr+0xc>
  8023d7:	eb 05                	jmp    8023de <strchr+0x21>
			return (char *) s;
	return 0;
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023de:	5d                   	pop    %ebp
  8023df:	c3                   	ret    

008023e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8023ea:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8023ed:	38 ca                	cmp    %cl,%dl
  8023ef:	74 09                	je     8023fa <strfind+0x1a>
  8023f1:	84 d2                	test   %dl,%dl
  8023f3:	74 05                	je     8023fa <strfind+0x1a>
	for (; *s; s++)
  8023f5:	83 c0 01             	add    $0x1,%eax
  8023f8:	eb f0                	jmp    8023ea <strfind+0xa>
			break;
	return (char *) s;
}
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    

008023fc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	57                   	push   %edi
  802400:	56                   	push   %esi
  802401:	53                   	push   %ebx
  802402:	8b 7d 08             	mov    0x8(%ebp),%edi
  802405:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802408:	85 c9                	test   %ecx,%ecx
  80240a:	74 2f                	je     80243b <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80240c:	89 f8                	mov    %edi,%eax
  80240e:	09 c8                	or     %ecx,%eax
  802410:	a8 03                	test   $0x3,%al
  802412:	75 21                	jne    802435 <memset+0x39>
		c &= 0xFF;
  802414:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802418:	89 d0                	mov    %edx,%eax
  80241a:	c1 e0 08             	shl    $0x8,%eax
  80241d:	89 d3                	mov    %edx,%ebx
  80241f:	c1 e3 18             	shl    $0x18,%ebx
  802422:	89 d6                	mov    %edx,%esi
  802424:	c1 e6 10             	shl    $0x10,%esi
  802427:	09 f3                	or     %esi,%ebx
  802429:	09 da                	or     %ebx,%edx
  80242b:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80242d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  802430:	fc                   	cld    
  802431:	f3 ab                	rep stos %eax,%es:(%edi)
  802433:	eb 06                	jmp    80243b <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802435:	8b 45 0c             	mov    0xc(%ebp),%eax
  802438:	fc                   	cld    
  802439:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80243b:	89 f8                	mov    %edi,%eax
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5f                   	pop    %edi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	57                   	push   %edi
  802446:	56                   	push   %esi
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80244d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802450:	39 c6                	cmp    %eax,%esi
  802452:	73 32                	jae    802486 <memmove+0x44>
  802454:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802457:	39 c2                	cmp    %eax,%edx
  802459:	76 2b                	jbe    802486 <memmove+0x44>
		s += n;
		d += n;
  80245b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80245e:	89 d6                	mov    %edx,%esi
  802460:	09 fe                	or     %edi,%esi
  802462:	09 ce                	or     %ecx,%esi
  802464:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80246a:	75 0e                	jne    80247a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80246c:	83 ef 04             	sub    $0x4,%edi
  80246f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802472:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802475:	fd                   	std    
  802476:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802478:	eb 09                	jmp    802483 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80247a:	83 ef 01             	sub    $0x1,%edi
  80247d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802480:	fd                   	std    
  802481:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802483:	fc                   	cld    
  802484:	eb 1a                	jmp    8024a0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802486:	89 f2                	mov    %esi,%edx
  802488:	09 c2                	or     %eax,%edx
  80248a:	09 ca                	or     %ecx,%edx
  80248c:	f6 c2 03             	test   $0x3,%dl
  80248f:	75 0a                	jne    80249b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802491:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802494:	89 c7                	mov    %eax,%edi
  802496:	fc                   	cld    
  802497:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802499:	eb 05                	jmp    8024a0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80249b:	89 c7                	mov    %eax,%edi
  80249d:	fc                   	cld    
  80249e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8024a0:	5e                   	pop    %esi
  8024a1:	5f                   	pop    %edi
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    

008024a4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8024aa:	ff 75 10             	push   0x10(%ebp)
  8024ad:	ff 75 0c             	push   0xc(%ebp)
  8024b0:	ff 75 08             	push   0x8(%ebp)
  8024b3:	e8 8a ff ff ff       	call   802442 <memmove>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	56                   	push   %esi
  8024be:	53                   	push   %ebx
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8024ca:	eb 06                	jmp    8024d2 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8024cc:	83 c0 01             	add    $0x1,%eax
  8024cf:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  8024d2:	39 f0                	cmp    %esi,%eax
  8024d4:	74 14                	je     8024ea <memcmp+0x30>
		if (*s1 != *s2)
  8024d6:	0f b6 08             	movzbl (%eax),%ecx
  8024d9:	0f b6 1a             	movzbl (%edx),%ebx
  8024dc:	38 d9                	cmp    %bl,%cl
  8024de:	74 ec                	je     8024cc <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  8024e0:	0f b6 c1             	movzbl %cl,%eax
  8024e3:	0f b6 db             	movzbl %bl,%ebx
  8024e6:	29 d8                	sub    %ebx,%eax
  8024e8:	eb 05                	jmp    8024ef <memcmp+0x35>
	}

	return 0;
  8024ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    

008024f3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802501:	eb 03                	jmp    802506 <memfind+0x13>
  802503:	83 c0 01             	add    $0x1,%eax
  802506:	39 d0                	cmp    %edx,%eax
  802508:	73 04                	jae    80250e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80250a:	38 08                	cmp    %cl,(%eax)
  80250c:	75 f5                	jne    802503 <memfind+0x10>
			break;
	return (void *) s;
}
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	57                   	push   %edi
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	8b 55 08             	mov    0x8(%ebp),%edx
  802519:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80251c:	eb 03                	jmp    802521 <strtol+0x11>
		s++;
  80251e:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  802521:	0f b6 02             	movzbl (%edx),%eax
  802524:	3c 20                	cmp    $0x20,%al
  802526:	74 f6                	je     80251e <strtol+0xe>
  802528:	3c 09                	cmp    $0x9,%al
  80252a:	74 f2                	je     80251e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80252c:	3c 2b                	cmp    $0x2b,%al
  80252e:	74 2a                	je     80255a <strtol+0x4a>
	int neg = 0;
  802530:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802535:	3c 2d                	cmp    $0x2d,%al
  802537:	74 2b                	je     802564 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802539:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80253f:	75 0f                	jne    802550 <strtol+0x40>
  802541:	80 3a 30             	cmpb   $0x30,(%edx)
  802544:	74 28                	je     80256e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802546:	85 db                	test   %ebx,%ebx
  802548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80254d:	0f 44 d8             	cmove  %eax,%ebx
  802550:	b9 00 00 00 00       	mov    $0x0,%ecx
  802555:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802558:	eb 46                	jmp    8025a0 <strtol+0x90>
		s++;
  80255a:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  80255d:	bf 00 00 00 00       	mov    $0x0,%edi
  802562:	eb d5                	jmp    802539 <strtol+0x29>
		s++, neg = 1;
  802564:	83 c2 01             	add    $0x1,%edx
  802567:	bf 01 00 00 00       	mov    $0x1,%edi
  80256c:	eb cb                	jmp    802539 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80256e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802572:	74 0e                	je     802582 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  802574:	85 db                	test   %ebx,%ebx
  802576:	75 d8                	jne    802550 <strtol+0x40>
		s++, base = 8;
  802578:	83 c2 01             	add    $0x1,%edx
  80257b:	bb 08 00 00 00       	mov    $0x8,%ebx
  802580:	eb ce                	jmp    802550 <strtol+0x40>
		s += 2, base = 16;
  802582:	83 c2 02             	add    $0x2,%edx
  802585:	bb 10 00 00 00       	mov    $0x10,%ebx
  80258a:	eb c4                	jmp    802550 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80258c:	0f be c0             	movsbl %al,%eax
  80258f:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802592:	3b 45 10             	cmp    0x10(%ebp),%eax
  802595:	7d 3a                	jge    8025d1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  802597:	83 c2 01             	add    $0x1,%edx
  80259a:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  80259e:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  8025a0:	0f b6 02             	movzbl (%edx),%eax
  8025a3:	8d 70 d0             	lea    -0x30(%eax),%esi
  8025a6:	89 f3                	mov    %esi,%ebx
  8025a8:	80 fb 09             	cmp    $0x9,%bl
  8025ab:	76 df                	jbe    80258c <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  8025ad:	8d 70 9f             	lea    -0x61(%eax),%esi
  8025b0:	89 f3                	mov    %esi,%ebx
  8025b2:	80 fb 19             	cmp    $0x19,%bl
  8025b5:	77 08                	ja     8025bf <strtol+0xaf>
			dig = *s - 'a' + 10;
  8025b7:	0f be c0             	movsbl %al,%eax
  8025ba:	83 e8 57             	sub    $0x57,%eax
  8025bd:	eb d3                	jmp    802592 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  8025bf:	8d 70 bf             	lea    -0x41(%eax),%esi
  8025c2:	89 f3                	mov    %esi,%ebx
  8025c4:	80 fb 19             	cmp    $0x19,%bl
  8025c7:	77 08                	ja     8025d1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8025c9:	0f be c0             	movsbl %al,%eax
  8025cc:	83 e8 37             	sub    $0x37,%eax
  8025cf:	eb c1                	jmp    802592 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  8025d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025d5:	74 05                	je     8025dc <strtol+0xcc>
		*endptr = (char *) s;
  8025d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8025dc:	89 c8                	mov    %ecx,%eax
  8025de:	f7 d8                	neg    %eax
  8025e0:	85 ff                	test   %edi,%edi
  8025e2:	0f 45 c8             	cmovne %eax,%ecx
}
  8025e5:	89 c8                	mov    %ecx,%eax
  8025e7:	5b                   	pop    %ebx
  8025e8:	5e                   	pop    %esi
  8025e9:	5f                   	pop    %edi
  8025ea:	5d                   	pop    %ebp
  8025eb:	c3                   	ret    

008025ec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	57                   	push   %edi
  8025f0:	56                   	push   %esi
  8025f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025fd:	89 c3                	mov    %eax,%ebx
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	89 c6                	mov    %eax,%esi
  802603:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802605:	5b                   	pop    %ebx
  802606:	5e                   	pop    %esi
  802607:	5f                   	pop    %edi
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    

0080260a <sys_cgetc>:

int
sys_cgetc(void)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	57                   	push   %edi
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
	asm volatile("int %1\n"
  802610:	ba 00 00 00 00       	mov    $0x0,%edx
  802615:	b8 01 00 00 00       	mov    $0x1,%eax
  80261a:	89 d1                	mov    %edx,%ecx
  80261c:	89 d3                	mov    %edx,%ebx
  80261e:	89 d7                	mov    %edx,%edi
  802620:	89 d6                	mov    %edx,%esi
  802622:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802624:	5b                   	pop    %ebx
  802625:	5e                   	pop    %esi
  802626:	5f                   	pop    %edi
  802627:	5d                   	pop    %ebp
  802628:	c3                   	ret    

00802629 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	57                   	push   %edi
  80262d:	56                   	push   %esi
  80262e:	53                   	push   %ebx
  80262f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802632:	b9 00 00 00 00       	mov    $0x0,%ecx
  802637:	8b 55 08             	mov    0x8(%ebp),%edx
  80263a:	b8 03 00 00 00       	mov    $0x3,%eax
  80263f:	89 cb                	mov    %ecx,%ebx
  802641:	89 cf                	mov    %ecx,%edi
  802643:	89 ce                	mov    %ecx,%esi
  802645:	cd 30                	int    $0x30
	if(check && ret > 0)
  802647:	85 c0                	test   %eax,%eax
  802649:	7f 08                	jg     802653 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80264b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80264e:	5b                   	pop    %ebx
  80264f:	5e                   	pop    %esi
  802650:	5f                   	pop    %edi
  802651:	5d                   	pop    %ebp
  802652:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	50                   	push   %eax
  802657:	6a 03                	push   $0x3
  802659:	68 3f 42 80 00       	push   $0x80423f
  80265e:	6a 23                	push   $0x23
  802660:	68 5c 42 80 00       	push   $0x80425c
  802665:	e8 a2 f4 ff ff       	call   801b0c <_panic>

0080266a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	57                   	push   %edi
  80266e:	56                   	push   %esi
  80266f:	53                   	push   %ebx
	asm volatile("int %1\n"
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
  802675:	b8 02 00 00 00       	mov    $0x2,%eax
  80267a:	89 d1                	mov    %edx,%ecx
  80267c:	89 d3                	mov    %edx,%ebx
  80267e:	89 d7                	mov    %edx,%edi
  802680:	89 d6                	mov    %edx,%esi
  802682:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802684:	5b                   	pop    %ebx
  802685:	5e                   	pop    %esi
  802686:	5f                   	pop    %edi
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    

00802689 <sys_yield>:

void
sys_yield(void)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	57                   	push   %edi
  80268d:	56                   	push   %esi
  80268e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80268f:	ba 00 00 00 00       	mov    $0x0,%edx
  802694:	b8 0b 00 00 00       	mov    $0xb,%eax
  802699:	89 d1                	mov    %edx,%ecx
  80269b:	89 d3                	mov    %edx,%ebx
  80269d:	89 d7                	mov    %edx,%edi
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8026a3:	5b                   	pop    %ebx
  8026a4:	5e                   	pop    %esi
  8026a5:	5f                   	pop    %edi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    

008026a8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	57                   	push   %edi
  8026ac:	56                   	push   %esi
  8026ad:	53                   	push   %ebx
  8026ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026b1:	be 00 00 00 00       	mov    $0x0,%esi
  8026b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026bc:	b8 04 00 00 00       	mov    $0x4,%eax
  8026c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026c4:	89 f7                	mov    %esi,%edi
  8026c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	7f 08                	jg     8026d4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8026cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026cf:	5b                   	pop    %ebx
  8026d0:	5e                   	pop    %esi
  8026d1:	5f                   	pop    %edi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	50                   	push   %eax
  8026d8:	6a 04                	push   $0x4
  8026da:	68 3f 42 80 00       	push   $0x80423f
  8026df:	6a 23                	push   $0x23
  8026e1:	68 5c 42 80 00       	push   $0x80425c
  8026e6:	e8 21 f4 ff ff       	call   801b0c <_panic>

008026eb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	57                   	push   %edi
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8026ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802702:	8b 7d 14             	mov    0x14(%ebp),%edi
  802705:	8b 75 18             	mov    0x18(%ebp),%esi
  802708:	cd 30                	int    $0x30
	if(check && ret > 0)
  80270a:	85 c0                	test   %eax,%eax
  80270c:	7f 08                	jg     802716 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80270e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802716:	83 ec 0c             	sub    $0xc,%esp
  802719:	50                   	push   %eax
  80271a:	6a 05                	push   $0x5
  80271c:	68 3f 42 80 00       	push   $0x80423f
  802721:	6a 23                	push   $0x23
  802723:	68 5c 42 80 00       	push   $0x80425c
  802728:	e8 df f3 ff ff       	call   801b0c <_panic>

0080272d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	57                   	push   %edi
  802731:	56                   	push   %esi
  802732:	53                   	push   %ebx
  802733:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802736:	bb 00 00 00 00       	mov    $0x0,%ebx
  80273b:	8b 55 08             	mov    0x8(%ebp),%edx
  80273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802741:	b8 06 00 00 00       	mov    $0x6,%eax
  802746:	89 df                	mov    %ebx,%edi
  802748:	89 de                	mov    %ebx,%esi
  80274a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80274c:	85 c0                	test   %eax,%eax
  80274e:	7f 08                	jg     802758 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802753:	5b                   	pop    %ebx
  802754:	5e                   	pop    %esi
  802755:	5f                   	pop    %edi
  802756:	5d                   	pop    %ebp
  802757:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	50                   	push   %eax
  80275c:	6a 06                	push   $0x6
  80275e:	68 3f 42 80 00       	push   $0x80423f
  802763:	6a 23                	push   $0x23
  802765:	68 5c 42 80 00       	push   $0x80425c
  80276a:	e8 9d f3 ff ff       	call   801b0c <_panic>

0080276f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	57                   	push   %edi
  802773:	56                   	push   %esi
  802774:	53                   	push   %ebx
  802775:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802778:	bb 00 00 00 00       	mov    $0x0,%ebx
  80277d:	8b 55 08             	mov    0x8(%ebp),%edx
  802780:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802783:	b8 08 00 00 00       	mov    $0x8,%eax
  802788:	89 df                	mov    %ebx,%edi
  80278a:	89 de                	mov    %ebx,%esi
  80278c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80278e:	85 c0                	test   %eax,%eax
  802790:	7f 08                	jg     80279a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802792:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5f                   	pop    %edi
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80279a:	83 ec 0c             	sub    $0xc,%esp
  80279d:	50                   	push   %eax
  80279e:	6a 08                	push   $0x8
  8027a0:	68 3f 42 80 00       	push   $0x80423f
  8027a5:	6a 23                	push   $0x23
  8027a7:	68 5c 42 80 00       	push   $0x80425c
  8027ac:	e8 5b f3 ff ff       	call   801b0c <_panic>

008027b1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	57                   	push   %edi
  8027b5:	56                   	push   %esi
  8027b6:	53                   	push   %ebx
  8027b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c5:	b8 09 00 00 00       	mov    $0x9,%eax
  8027ca:	89 df                	mov    %ebx,%edi
  8027cc:	89 de                	mov    %ebx,%esi
  8027ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	7f 08                	jg     8027dc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8027d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027d7:	5b                   	pop    %ebx
  8027d8:	5e                   	pop    %esi
  8027d9:	5f                   	pop    %edi
  8027da:	5d                   	pop    %ebp
  8027db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	50                   	push   %eax
  8027e0:	6a 09                	push   $0x9
  8027e2:	68 3f 42 80 00       	push   $0x80423f
  8027e7:	6a 23                	push   $0x23
  8027e9:	68 5c 42 80 00       	push   $0x80425c
  8027ee:	e8 19 f3 ff ff       	call   801b0c <_panic>

008027f3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	57                   	push   %edi
  8027f7:	56                   	push   %esi
  8027f8:	53                   	push   %ebx
  8027f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802801:	8b 55 08             	mov    0x8(%ebp),%edx
  802804:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802807:	b8 0a 00 00 00       	mov    $0xa,%eax
  80280c:	89 df                	mov    %ebx,%edi
  80280e:	89 de                	mov    %ebx,%esi
  802810:	cd 30                	int    $0x30
	if(check && ret > 0)
  802812:	85 c0                	test   %eax,%eax
  802814:	7f 08                	jg     80281e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802819:	5b                   	pop    %ebx
  80281a:	5e                   	pop    %esi
  80281b:	5f                   	pop    %edi
  80281c:	5d                   	pop    %ebp
  80281d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80281e:	83 ec 0c             	sub    $0xc,%esp
  802821:	50                   	push   %eax
  802822:	6a 0a                	push   $0xa
  802824:	68 3f 42 80 00       	push   $0x80423f
  802829:	6a 23                	push   $0x23
  80282b:	68 5c 42 80 00       	push   $0x80425c
  802830:	e8 d7 f2 ff ff       	call   801b0c <_panic>

00802835 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	57                   	push   %edi
  802839:	56                   	push   %esi
  80283a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80283b:	8b 55 08             	mov    0x8(%ebp),%edx
  80283e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802841:	b8 0c 00 00 00       	mov    $0xc,%eax
  802846:	be 00 00 00 00       	mov    $0x0,%esi
  80284b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80284e:	8b 7d 14             	mov    0x14(%ebp),%edi
  802851:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802853:	5b                   	pop    %ebx
  802854:	5e                   	pop    %esi
  802855:	5f                   	pop    %edi
  802856:	5d                   	pop    %ebp
  802857:	c3                   	ret    

00802858 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	57                   	push   %edi
  80285c:	56                   	push   %esi
  80285d:	53                   	push   %ebx
  80285e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802861:	b9 00 00 00 00       	mov    $0x0,%ecx
  802866:	8b 55 08             	mov    0x8(%ebp),%edx
  802869:	b8 0d 00 00 00       	mov    $0xd,%eax
  80286e:	89 cb                	mov    %ecx,%ebx
  802870:	89 cf                	mov    %ecx,%edi
  802872:	89 ce                	mov    %ecx,%esi
  802874:	cd 30                	int    $0x30
	if(check && ret > 0)
  802876:	85 c0                	test   %eax,%eax
  802878:	7f 08                	jg     802882 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80287a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80287d:	5b                   	pop    %ebx
  80287e:	5e                   	pop    %esi
  80287f:	5f                   	pop    %edi
  802880:	5d                   	pop    %ebp
  802881:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	50                   	push   %eax
  802886:	6a 0d                	push   $0xd
  802888:	68 3f 42 80 00       	push   $0x80423f
  80288d:	6a 23                	push   $0x23
  80288f:	68 5c 42 80 00       	push   $0x80425c
  802894:	e8 73 f2 ff ff       	call   801b0c <_panic>

00802899 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
  80289c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80289f:	83 3d 0c a0 80 00 00 	cmpl   $0x0,0x80a00c
  8028a6:	74 20                	je     8028c8 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8028b0:	83 ec 08             	sub    $0x8,%esp
  8028b3:	68 08 29 80 00       	push   $0x802908
  8028b8:	6a 00                	push   $0x0
  8028ba:	e8 34 ff ff ff       	call   8027f3 <sys_env_set_pgfault_upcall>
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	78 2e                	js     8028f4 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	6a 07                	push   $0x7
  8028cd:	68 00 f0 bf ee       	push   $0xeebff000
  8028d2:	6a 00                	push   $0x0
  8028d4:	e8 cf fd ff ff       	call   8026a8 <sys_page_alloc>
  8028d9:	83 c4 10             	add    $0x10,%esp
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	79 c8                	jns    8028a8 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 6c 42 80 00       	push   $0x80426c
  8028e8:	6a 21                	push   $0x21
  8028ea:	68 cf 42 80 00       	push   $0x8042cf
  8028ef:	e8 18 f2 ff ff       	call   801b0c <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 98 42 80 00       	push   $0x804298
  8028fc:	6a 27                	push   $0x27
  8028fe:	68 cf 42 80 00       	push   $0x8042cf
  802903:	e8 04 f2 ff ff       	call   801b0c <_panic>

00802908 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802908:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802909:	a1 0c a0 80 00       	mov    0x80a00c,%eax
	call *%eax
  80290e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802910:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  802913:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  802917:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  80291c:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  802920:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  802922:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802925:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802926:	83 c4 04             	add    $0x4,%esp
	popfl
  802929:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80292a:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80292b:	c3                   	ret    

0080292c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	56                   	push   %esi
  802930:	53                   	push   %ebx
  802931:	8b 75 08             	mov    0x8(%ebp),%esi
  802934:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	ff 75 0c             	push   0xc(%ebp)
  80293d:	e8 16 ff ff ff       	call   802858 <sys_ipc_recv>
  802942:	83 c4 10             	add    $0x10,%esp
  802945:	85 c0                	test   %eax,%eax
  802947:	78 2b                	js     802974 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802949:	85 f6                	test   %esi,%esi
  80294b:	74 0a                	je     802957 <ipc_recv+0x2b>
  80294d:	a1 08 a0 80 00       	mov    0x80a008,%eax
  802952:	8b 40 74             	mov    0x74(%eax),%eax
  802955:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802957:	85 db                	test   %ebx,%ebx
  802959:	74 0a                	je     802965 <ipc_recv+0x39>
  80295b:	a1 08 a0 80 00       	mov    0x80a008,%eax
  802960:	8b 40 78             	mov    0x78(%eax),%eax
  802963:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802965:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80296a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80296d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802970:	5b                   	pop    %ebx
  802971:	5e                   	pop    %esi
  802972:	5d                   	pop    %ebp
  802973:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802974:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802979:	eb f2                	jmp    80296d <ipc_recv+0x41>

0080297b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	57                   	push   %edi
  80297f:	56                   	push   %esi
  802980:	53                   	push   %ebx
  802981:	83 ec 0c             	sub    $0xc,%esp
  802984:	8b 7d 08             	mov    0x8(%ebp),%edi
  802987:	8b 75 0c             	mov    0xc(%ebp),%esi
  80298a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80298d:	ff 75 14             	push   0x14(%ebp)
  802990:	53                   	push   %ebx
  802991:	56                   	push   %esi
  802992:	57                   	push   %edi
  802993:	e8 9d fe ff ff       	call   802835 <sys_ipc_try_send>
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	85 c0                	test   %eax,%eax
  80299d:	79 20                	jns    8029bf <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80299f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029a2:	75 07                	jne    8029ab <ipc_send+0x30>
		sys_yield();
  8029a4:	e8 e0 fc ff ff       	call   802689 <sys_yield>
  8029a9:	eb e2                	jmp    80298d <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 dd 42 80 00       	push   $0x8042dd
  8029b3:	6a 2e                	push   $0x2e
  8029b5:	68 ed 42 80 00       	push   $0x8042ed
  8029ba:	e8 4d f1 ff ff       	call   801b0c <_panic>
	}
}
  8029bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029c2:	5b                   	pop    %ebx
  8029c3:	5e                   	pop    %esi
  8029c4:	5f                   	pop    %edi
  8029c5:	5d                   	pop    %ebp
  8029c6:	c3                   	ret    

008029c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029d2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029d5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029db:	8b 52 50             	mov    0x50(%edx),%edx
  8029de:	39 ca                	cmp    %ecx,%edx
  8029e0:	74 11                	je     8029f3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8029e2:	83 c0 01             	add    $0x1,%eax
  8029e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029ea:	75 e6                	jne    8029d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	eb 0b                	jmp    8029fe <ipc_find_env+0x37>
			return envs[i].env_id;
  8029f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029fe:	5d                   	pop    %ebp
  8029ff:	c3                   	ret    

00802a00 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	56                   	push   %esi
  802a04:	53                   	push   %ebx
  802a05:	89 c6                	mov    %eax,%esi
  802a07:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802a09:	83 3d 00 c0 80 00 00 	cmpl   $0x0,0x80c000
  802a10:	74 27                	je     802a39 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a12:	6a 07                	push   $0x7
  802a14:	68 00 b0 80 00       	push   $0x80b000
  802a19:	56                   	push   %esi
  802a1a:	ff 35 00 c0 80 00    	push   0x80c000
  802a20:	e8 56 ff ff ff       	call   80297b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802a25:	83 c4 0c             	add    $0xc,%esp
  802a28:	6a 00                	push   $0x0
  802a2a:	53                   	push   %ebx
  802a2b:	6a 00                	push   $0x0
  802a2d:	e8 fa fe ff ff       	call   80292c <ipc_recv>
}
  802a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a35:	5b                   	pop    %ebx
  802a36:	5e                   	pop    %esi
  802a37:	5d                   	pop    %ebp
  802a38:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a39:	83 ec 0c             	sub    $0xc,%esp
  802a3c:	6a 01                	push   $0x1
  802a3e:	e8 84 ff ff ff       	call   8029c7 <ipc_find_env>
  802a43:	a3 00 c0 80 00       	mov    %eax,0x80c000
  802a48:	83 c4 10             	add    $0x10,%esp
  802a4b:	eb c5                	jmp    802a12 <fsipc+0x12>

00802a4d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
  802a50:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8b 40 0c             	mov    0xc(%eax),%eax
  802a59:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a61:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a66:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6b:	b8 02 00 00 00       	mov    $0x2,%eax
  802a70:	e8 8b ff ff ff       	call   802a00 <fsipc>
}
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <devfile_flush>:
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
  802a7a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802a88:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8d:	b8 06 00 00 00       	mov    $0x6,%eax
  802a92:	e8 69 ff ff ff       	call   802a00 <fsipc>
}
  802a97:	c9                   	leave  
  802a98:	c3                   	ret    

00802a99 <devfile_stat>:
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	53                   	push   %ebx
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802aae:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab3:	b8 05 00 00 00       	mov    $0x5,%eax
  802ab8:	e8 43 ff ff ff       	call   802a00 <fsipc>
  802abd:	85 c0                	test   %eax,%eax
  802abf:	78 2c                	js     802aed <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ac1:	83 ec 08             	sub    $0x8,%esp
  802ac4:	68 00 b0 80 00       	push   $0x80b000
  802ac9:	53                   	push   %ebx
  802aca:	e8 dd f7 ff ff       	call   8022ac <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802acf:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802ad4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ada:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802adf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802ae5:	83 c4 10             	add    $0x10,%esp
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

00802af2 <devfile_write>:
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
  802af5:	53                   	push   %ebx
  802af6:	83 ec 08             	sub    $0x8,%esp
  802af9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  802b07:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802b0d:	53                   	push   %ebx
  802b0e:	ff 75 0c             	push   0xc(%ebp)
  802b11:	68 08 b0 80 00       	push   $0x80b008
  802b16:	e8 89 f9 ff ff       	call   8024a4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b20:	b8 04 00 00 00       	mov    $0x4,%eax
  802b25:	e8 d6 fe ff ff       	call   802a00 <fsipc>
  802b2a:	83 c4 10             	add    $0x10,%esp
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	78 0b                	js     802b3c <devfile_write+0x4a>
	assert(r <= n);
  802b31:	39 d8                	cmp    %ebx,%eax
  802b33:	77 0c                	ja     802b41 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802b35:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802b3a:	7f 1e                	jg     802b5a <devfile_write+0x68>
}
  802b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b3f:	c9                   	leave  
  802b40:	c3                   	ret    
	assert(r <= n);
  802b41:	68 f7 42 80 00       	push   $0x8042f7
  802b46:	68 9d 39 80 00       	push   $0x80399d
  802b4b:	68 97 00 00 00       	push   $0x97
  802b50:	68 fe 42 80 00       	push   $0x8042fe
  802b55:	e8 b2 ef ff ff       	call   801b0c <_panic>
	assert(r <= PGSIZE);
  802b5a:	68 09 43 80 00       	push   $0x804309
  802b5f:	68 9d 39 80 00       	push   $0x80399d
  802b64:	68 98 00 00 00       	push   $0x98
  802b69:	68 fe 42 80 00       	push   $0x8042fe
  802b6e:	e8 99 ef ff ff       	call   801b0c <_panic>

00802b73 <devfile_read>:
{
  802b73:	55                   	push   %ebp
  802b74:	89 e5                	mov    %esp,%ebp
  802b76:	56                   	push   %esi
  802b77:	53                   	push   %ebx
  802b78:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b81:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  802b86:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b91:	b8 03 00 00 00       	mov    $0x3,%eax
  802b96:	e8 65 fe ff ff       	call   802a00 <fsipc>
  802b9b:	89 c3                	mov    %eax,%ebx
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	78 1f                	js     802bc0 <devfile_read+0x4d>
	assert(r <= n);
  802ba1:	39 f0                	cmp    %esi,%eax
  802ba3:	77 24                	ja     802bc9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802ba5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802baa:	7f 33                	jg     802bdf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	50                   	push   %eax
  802bb0:	68 00 b0 80 00       	push   $0x80b000
  802bb5:	ff 75 0c             	push   0xc(%ebp)
  802bb8:	e8 85 f8 ff ff       	call   802442 <memmove>
	return r;
  802bbd:	83 c4 10             	add    $0x10,%esp
}
  802bc0:	89 d8                	mov    %ebx,%eax
  802bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bc5:	5b                   	pop    %ebx
  802bc6:	5e                   	pop    %esi
  802bc7:	5d                   	pop    %ebp
  802bc8:	c3                   	ret    
	assert(r <= n);
  802bc9:	68 f7 42 80 00       	push   $0x8042f7
  802bce:	68 9d 39 80 00       	push   $0x80399d
  802bd3:	6a 7c                	push   $0x7c
  802bd5:	68 fe 42 80 00       	push   $0x8042fe
  802bda:	e8 2d ef ff ff       	call   801b0c <_panic>
	assert(r <= PGSIZE);
  802bdf:	68 09 43 80 00       	push   $0x804309
  802be4:	68 9d 39 80 00       	push   $0x80399d
  802be9:	6a 7d                	push   $0x7d
  802beb:	68 fe 42 80 00       	push   $0x8042fe
  802bf0:	e8 17 ef ff ff       	call   801b0c <_panic>

00802bf5 <open>:
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
  802bf8:	56                   	push   %esi
  802bf9:	53                   	push   %ebx
  802bfa:	83 ec 1c             	sub    $0x1c,%esp
  802bfd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802c00:	56                   	push   %esi
  802c01:	e8 6b f6 ff ff       	call   802271 <strlen>
  802c06:	83 c4 10             	add    $0x10,%esp
  802c09:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c0e:	7f 6c                	jg     802c7c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c16:	50                   	push   %eax
  802c17:	e8 e1 00 00 00       	call   802cfd <fd_alloc>
  802c1c:	89 c3                	mov    %eax,%ebx
  802c1e:	83 c4 10             	add    $0x10,%esp
  802c21:	85 c0                	test   %eax,%eax
  802c23:	78 3c                	js     802c61 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802c25:	83 ec 08             	sub    $0x8,%esp
  802c28:	56                   	push   %esi
  802c29:	68 00 b0 80 00       	push   $0x80b000
  802c2e:	e8 79 f6 ff ff       	call   8022ac <strcpy>
	fsipcbuf.open.req_omode = mode;
  802c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c36:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	e8 b8 fd ff ff       	call   802a00 <fsipc>
  802c48:	89 c3                	mov    %eax,%ebx
  802c4a:	83 c4 10             	add    $0x10,%esp
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	78 19                	js     802c6a <open+0x75>
	return fd2num(fd);
  802c51:	83 ec 0c             	sub    $0xc,%esp
  802c54:	ff 75 f4             	push   -0xc(%ebp)
  802c57:	e8 7a 00 00 00       	call   802cd6 <fd2num>
  802c5c:	89 c3                	mov    %eax,%ebx
  802c5e:	83 c4 10             	add    $0x10,%esp
}
  802c61:	89 d8                	mov    %ebx,%eax
  802c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c66:	5b                   	pop    %ebx
  802c67:	5e                   	pop    %esi
  802c68:	5d                   	pop    %ebp
  802c69:	c3                   	ret    
		fd_close(fd, 0);
  802c6a:	83 ec 08             	sub    $0x8,%esp
  802c6d:	6a 00                	push   $0x0
  802c6f:	ff 75 f4             	push   -0xc(%ebp)
  802c72:	e8 77 01 00 00       	call   802dee <fd_close>
		return r;
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	eb e5                	jmp    802c61 <open+0x6c>
		return -E_BAD_PATH;
  802c7c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802c81:	eb de                	jmp    802c61 <open+0x6c>

00802c83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802c83:	55                   	push   %ebp
  802c84:	89 e5                	mov    %esp,%ebp
  802c86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c89:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  802c93:	e8 68 fd ff ff       	call   802a00 <fsipc>
}
  802c98:	c9                   	leave  
  802c99:	c3                   	ret    

00802c9a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c9a:	55                   	push   %ebp
  802c9b:	89 e5                	mov    %esp,%ebp
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ca0:	89 c2                	mov    %eax,%edx
  802ca2:	c1 ea 16             	shr    $0x16,%edx
  802ca5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802cac:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802cb1:	f6 c1 01             	test   $0x1,%cl
  802cb4:	74 1c                	je     802cd2 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802cb6:	c1 e8 0c             	shr    $0xc,%eax
  802cb9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802cc0:	a8 01                	test   $0x1,%al
  802cc2:	74 0e                	je     802cd2 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802cc4:	c1 e8 0c             	shr    $0xc,%eax
  802cc7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802cce:	ef 
  802ccf:	0f b7 d2             	movzwl %dx,%edx
}
  802cd2:	89 d0                	mov    %edx,%eax
  802cd4:	5d                   	pop    %ebp
  802cd5:	c3                   	ret    

00802cd6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	05 00 00 00 30       	add    $0x30000000,%eax
  802ce1:	c1 e8 0c             	shr    $0xc,%eax
}
  802ce4:	5d                   	pop    %ebp
  802ce5:	c3                   	ret    

00802ce6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802cf6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802cfb:	5d                   	pop    %ebp
  802cfc:	c3                   	ret    

00802cfd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
  802d00:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802d05:	89 c2                	mov    %eax,%edx
  802d07:	c1 ea 16             	shr    $0x16,%edx
  802d0a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802d11:	f6 c2 01             	test   $0x1,%dl
  802d14:	74 29                	je     802d3f <fd_alloc+0x42>
  802d16:	89 c2                	mov    %eax,%edx
  802d18:	c1 ea 0c             	shr    $0xc,%edx
  802d1b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802d22:	f6 c2 01             	test   $0x1,%dl
  802d25:	74 18                	je     802d3f <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  802d27:	05 00 10 00 00       	add    $0x1000,%eax
  802d2c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802d31:	75 d2                	jne    802d05 <fd_alloc+0x8>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  802d38:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  802d3d:	eb 05                	jmp    802d44 <fd_alloc+0x47>
			return 0;
  802d3f:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  802d44:	8b 55 08             	mov    0x8(%ebp),%edx
  802d47:	89 02                	mov    %eax,(%edx)
}
  802d49:	89 c8                	mov    %ecx,%eax
  802d4b:	5d                   	pop    %ebp
  802d4c:	c3                   	ret    

00802d4d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802d53:	83 f8 1f             	cmp    $0x1f,%eax
  802d56:	77 30                	ja     802d88 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802d58:	c1 e0 0c             	shl    $0xc,%eax
  802d5b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802d60:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802d66:	f6 c2 01             	test   $0x1,%dl
  802d69:	74 24                	je     802d8f <fd_lookup+0x42>
  802d6b:	89 c2                	mov    %eax,%edx
  802d6d:	c1 ea 0c             	shr    $0xc,%edx
  802d70:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802d77:	f6 c2 01             	test   $0x1,%dl
  802d7a:	74 1a                	je     802d96 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7f:	89 02                	mov    %eax,(%edx)
	return 0;
  802d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d86:	5d                   	pop    %ebp
  802d87:	c3                   	ret    
		return -E_INVAL;
  802d88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d8d:	eb f7                	jmp    802d86 <fd_lookup+0x39>
		return -E_INVAL;
  802d8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d94:	eb f0                	jmp    802d86 <fd_lookup+0x39>
  802d96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d9b:	eb e9                	jmp    802d86 <fd_lookup+0x39>

00802d9d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d9d:	55                   	push   %ebp
  802d9e:	89 e5                	mov    %esp,%ebp
  802da0:	53                   	push   %ebx
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	8b 55 08             	mov    0x8(%ebp),%edx
  802da7:	b8 94 43 80 00       	mov    $0x804394,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  802dac:	bb 64 90 80 00       	mov    $0x809064,%ebx
		if (devtab[i]->dev_id == dev_id) {
  802db1:	39 13                	cmp    %edx,(%ebx)
  802db3:	74 32                	je     802de7 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  802db5:	83 c0 04             	add    $0x4,%eax
  802db8:	8b 18                	mov    (%eax),%ebx
  802dba:	85 db                	test   %ebx,%ebx
  802dbc:	75 f3                	jne    802db1 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802dbe:	a1 08 a0 80 00       	mov    0x80a008,%eax
  802dc3:	8b 40 48             	mov    0x48(%eax),%eax
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	52                   	push   %edx
  802dca:	50                   	push   %eax
  802dcb:	68 18 43 80 00       	push   $0x804318
  802dd0:	e8 12 ee ff ff       	call   801be7 <cprintf>
	*dev = 0;
	return -E_INVAL;
  802dd5:	83 c4 10             	add    $0x10,%esp
  802dd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  802ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de0:	89 1a                	mov    %ebx,(%edx)
}
  802de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802de5:	c9                   	leave  
  802de6:	c3                   	ret    
			return 0;
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dec:	eb ef                	jmp    802ddd <dev_lookup+0x40>

00802dee <fd_close>:
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
  802df1:	57                   	push   %edi
  802df2:	56                   	push   %esi
  802df3:	53                   	push   %ebx
  802df4:	83 ec 24             	sub    $0x24,%esp
  802df7:	8b 75 08             	mov    0x8(%ebp),%esi
  802dfa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802dfd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802e00:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e01:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802e07:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802e0a:	50                   	push   %eax
  802e0b:	e8 3d ff ff ff       	call   802d4d <fd_lookup>
  802e10:	89 c3                	mov    %eax,%ebx
  802e12:	83 c4 10             	add    $0x10,%esp
  802e15:	85 c0                	test   %eax,%eax
  802e17:	78 05                	js     802e1e <fd_close+0x30>
	    || fd != fd2)
  802e19:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802e1c:	74 16                	je     802e34 <fd_close+0x46>
		return (must_exist ? r : 0);
  802e1e:	89 f8                	mov    %edi,%eax
  802e20:	84 c0                	test   %al,%al
  802e22:	b8 00 00 00 00       	mov    $0x0,%eax
  802e27:	0f 44 d8             	cmove  %eax,%ebx
}
  802e2a:	89 d8                	mov    %ebx,%eax
  802e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e2f:	5b                   	pop    %ebx
  802e30:	5e                   	pop    %esi
  802e31:	5f                   	pop    %edi
  802e32:	5d                   	pop    %ebp
  802e33:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802e34:	83 ec 08             	sub    $0x8,%esp
  802e37:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e3a:	50                   	push   %eax
  802e3b:	ff 36                	push   (%esi)
  802e3d:	e8 5b ff ff ff       	call   802d9d <dev_lookup>
  802e42:	89 c3                	mov    %eax,%ebx
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	85 c0                	test   %eax,%eax
  802e49:	78 1a                	js     802e65 <fd_close+0x77>
		if (dev->dev_close)
  802e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802e51:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 0b                	je     802e65 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802e5a:	83 ec 0c             	sub    $0xc,%esp
  802e5d:	56                   	push   %esi
  802e5e:	ff d0                	call   *%eax
  802e60:	89 c3                	mov    %eax,%ebx
  802e62:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802e65:	83 ec 08             	sub    $0x8,%esp
  802e68:	56                   	push   %esi
  802e69:	6a 00                	push   $0x0
  802e6b:	e8 bd f8 ff ff       	call   80272d <sys_page_unmap>
	return r;
  802e70:	83 c4 10             	add    $0x10,%esp
  802e73:	eb b5                	jmp    802e2a <fd_close+0x3c>

00802e75 <close>:

int
close(int fdnum)
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
  802e78:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e7e:	50                   	push   %eax
  802e7f:	ff 75 08             	push   0x8(%ebp)
  802e82:	e8 c6 fe ff ff       	call   802d4d <fd_lookup>
  802e87:	83 c4 10             	add    $0x10,%esp
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	79 02                	jns    802e90 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    
		return fd_close(fd, 1);
  802e90:	83 ec 08             	sub    $0x8,%esp
  802e93:	6a 01                	push   $0x1
  802e95:	ff 75 f4             	push   -0xc(%ebp)
  802e98:	e8 51 ff ff ff       	call   802dee <fd_close>
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	eb ec                	jmp    802e8e <close+0x19>

00802ea2 <close_all>:

void
close_all(void)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	53                   	push   %ebx
  802ea6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802eae:	83 ec 0c             	sub    $0xc,%esp
  802eb1:	53                   	push   %ebx
  802eb2:	e8 be ff ff ff       	call   802e75 <close>
	for (i = 0; i < MAXFD; i++)
  802eb7:	83 c3 01             	add    $0x1,%ebx
  802eba:	83 c4 10             	add    $0x10,%esp
  802ebd:	83 fb 20             	cmp    $0x20,%ebx
  802ec0:	75 ec                	jne    802eae <close_all+0xc>
}
  802ec2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ec5:	c9                   	leave  
  802ec6:	c3                   	ret    

00802ec7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802ec7:	55                   	push   %ebp
  802ec8:	89 e5                	mov    %esp,%ebp
  802eca:	57                   	push   %edi
  802ecb:	56                   	push   %esi
  802ecc:	53                   	push   %ebx
  802ecd:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ed0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ed3:	50                   	push   %eax
  802ed4:	ff 75 08             	push   0x8(%ebp)
  802ed7:	e8 71 fe ff ff       	call   802d4d <fd_lookup>
  802edc:	89 c3                	mov    %eax,%ebx
  802ede:	83 c4 10             	add    $0x10,%esp
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	78 7f                	js     802f64 <dup+0x9d>
		return r;
	close(newfdnum);
  802ee5:	83 ec 0c             	sub    $0xc,%esp
  802ee8:	ff 75 0c             	push   0xc(%ebp)
  802eeb:	e8 85 ff ff ff       	call   802e75 <close>

	newfd = INDEX2FD(newfdnum);
  802ef0:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ef3:	c1 e6 0c             	shl    $0xc,%esi
  802ef6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802efc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  802eff:	89 3c 24             	mov    %edi,(%esp)
  802f02:	e8 df fd ff ff       	call   802ce6 <fd2data>
  802f07:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802f09:	89 34 24             	mov    %esi,(%esp)
  802f0c:	e8 d5 fd ff ff       	call   802ce6 <fd2data>
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802f17:	89 d8                	mov    %ebx,%eax
  802f19:	c1 e8 16             	shr    $0x16,%eax
  802f1c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f23:	a8 01                	test   $0x1,%al
  802f25:	74 11                	je     802f38 <dup+0x71>
  802f27:	89 d8                	mov    %ebx,%eax
  802f29:	c1 e8 0c             	shr    $0xc,%eax
  802f2c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802f33:	f6 c2 01             	test   $0x1,%dl
  802f36:	75 36                	jne    802f6e <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f38:	89 f8                	mov    %edi,%eax
  802f3a:	c1 e8 0c             	shr    $0xc,%eax
  802f3d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802f44:	83 ec 0c             	sub    $0xc,%esp
  802f47:	25 07 0e 00 00       	and    $0xe07,%eax
  802f4c:	50                   	push   %eax
  802f4d:	56                   	push   %esi
  802f4e:	6a 00                	push   $0x0
  802f50:	57                   	push   %edi
  802f51:	6a 00                	push   $0x0
  802f53:	e8 93 f7 ff ff       	call   8026eb <sys_page_map>
  802f58:	89 c3                	mov    %eax,%ebx
  802f5a:	83 c4 20             	add    $0x20,%esp
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	78 33                	js     802f94 <dup+0xcd>
		goto err;

	return newfdnum;
  802f61:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802f64:	89 d8                	mov    %ebx,%eax
  802f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f69:	5b                   	pop    %ebx
  802f6a:	5e                   	pop    %esi
  802f6b:	5f                   	pop    %edi
  802f6c:	5d                   	pop    %ebp
  802f6d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f6e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802f75:	83 ec 0c             	sub    $0xc,%esp
  802f78:	25 07 0e 00 00       	and    $0xe07,%eax
  802f7d:	50                   	push   %eax
  802f7e:	ff 75 d4             	push   -0x2c(%ebp)
  802f81:	6a 00                	push   $0x0
  802f83:	53                   	push   %ebx
  802f84:	6a 00                	push   $0x0
  802f86:	e8 60 f7 ff ff       	call   8026eb <sys_page_map>
  802f8b:	89 c3                	mov    %eax,%ebx
  802f8d:	83 c4 20             	add    $0x20,%esp
  802f90:	85 c0                	test   %eax,%eax
  802f92:	79 a4                	jns    802f38 <dup+0x71>
	sys_page_unmap(0, newfd);
  802f94:	83 ec 08             	sub    $0x8,%esp
  802f97:	56                   	push   %esi
  802f98:	6a 00                	push   $0x0
  802f9a:	e8 8e f7 ff ff       	call   80272d <sys_page_unmap>
	sys_page_unmap(0, nva);
  802f9f:	83 c4 08             	add    $0x8,%esp
  802fa2:	ff 75 d4             	push   -0x2c(%ebp)
  802fa5:	6a 00                	push   $0x0
  802fa7:	e8 81 f7 ff ff       	call   80272d <sys_page_unmap>
	return r;
  802fac:	83 c4 10             	add    $0x10,%esp
  802faf:	eb b3                	jmp    802f64 <dup+0x9d>

00802fb1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802fb1:	55                   	push   %ebp
  802fb2:	89 e5                	mov    %esp,%ebp
  802fb4:	56                   	push   %esi
  802fb5:	53                   	push   %ebx
  802fb6:	83 ec 18             	sub    $0x18,%esp
  802fb9:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802fbf:	50                   	push   %eax
  802fc0:	56                   	push   %esi
  802fc1:	e8 87 fd ff ff       	call   802d4d <fd_lookup>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	78 3c                	js     803009 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fcd:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  802fd0:	83 ec 08             	sub    $0x8,%esp
  802fd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fd6:	50                   	push   %eax
  802fd7:	ff 33                	push   (%ebx)
  802fd9:	e8 bf fd ff ff       	call   802d9d <dev_lookup>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	78 24                	js     803009 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802fe5:	8b 43 08             	mov    0x8(%ebx),%eax
  802fe8:	83 e0 03             	and    $0x3,%eax
  802feb:	83 f8 01             	cmp    $0x1,%eax
  802fee:	74 20                	je     803010 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 37                	je     803031 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	ff 75 10             	push   0x10(%ebp)
  803000:	ff 75 0c             	push   0xc(%ebp)
  803003:	53                   	push   %ebx
  803004:	ff d0                	call   *%eax
  803006:	83 c4 10             	add    $0x10,%esp
}
  803009:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300c:	5b                   	pop    %ebx
  80300d:	5e                   	pop    %esi
  80300e:	5d                   	pop    %ebp
  80300f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803010:	a1 08 a0 80 00       	mov    0x80a008,%eax
  803015:	8b 40 48             	mov    0x48(%eax),%eax
  803018:	83 ec 04             	sub    $0x4,%esp
  80301b:	56                   	push   %esi
  80301c:	50                   	push   %eax
  80301d:	68 59 43 80 00       	push   $0x804359
  803022:	e8 c0 eb ff ff       	call   801be7 <cprintf>
		return -E_INVAL;
  803027:	83 c4 10             	add    $0x10,%esp
  80302a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80302f:	eb d8                	jmp    803009 <read+0x58>
		return -E_NOT_SUPP;
  803031:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803036:	eb d1                	jmp    803009 <read+0x58>

00803038 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803038:	55                   	push   %ebp
  803039:	89 e5                	mov    %esp,%ebp
  80303b:	57                   	push   %edi
  80303c:	56                   	push   %esi
  80303d:	53                   	push   %ebx
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	8b 7d 08             	mov    0x8(%ebp),%edi
  803044:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803047:	bb 00 00 00 00       	mov    $0x0,%ebx
  80304c:	eb 02                	jmp    803050 <readn+0x18>
  80304e:	01 c3                	add    %eax,%ebx
  803050:	39 f3                	cmp    %esi,%ebx
  803052:	73 21                	jae    803075 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	89 f0                	mov    %esi,%eax
  803059:	29 d8                	sub    %ebx,%eax
  80305b:	50                   	push   %eax
  80305c:	89 d8                	mov    %ebx,%eax
  80305e:	03 45 0c             	add    0xc(%ebp),%eax
  803061:	50                   	push   %eax
  803062:	57                   	push   %edi
  803063:	e8 49 ff ff ff       	call   802fb1 <read>
		if (m < 0)
  803068:	83 c4 10             	add    $0x10,%esp
  80306b:	85 c0                	test   %eax,%eax
  80306d:	78 04                	js     803073 <readn+0x3b>
			return m;
		if (m == 0)
  80306f:	75 dd                	jne    80304e <readn+0x16>
  803071:	eb 02                	jmp    803075 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803073:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  803075:	89 d8                	mov    %ebx,%eax
  803077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80307a:	5b                   	pop    %ebx
  80307b:	5e                   	pop    %esi
  80307c:	5f                   	pop    %edi
  80307d:	5d                   	pop    %ebp
  80307e:	c3                   	ret    

0080307f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
  803082:	56                   	push   %esi
  803083:	53                   	push   %ebx
  803084:	83 ec 18             	sub    $0x18,%esp
  803087:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80308a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80308d:	50                   	push   %eax
  80308e:	53                   	push   %ebx
  80308f:	e8 b9 fc ff ff       	call   802d4d <fd_lookup>
  803094:	83 c4 10             	add    $0x10,%esp
  803097:	85 c0                	test   %eax,%eax
  803099:	78 37                	js     8030d2 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80309b:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80309e:	83 ec 08             	sub    $0x8,%esp
  8030a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030a4:	50                   	push   %eax
  8030a5:	ff 36                	push   (%esi)
  8030a7:	e8 f1 fc ff ff       	call   802d9d <dev_lookup>
  8030ac:	83 c4 10             	add    $0x10,%esp
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	78 1f                	js     8030d2 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030b3:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8030b7:	74 20                	je     8030d9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 37                	je     8030fa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8030c3:	83 ec 04             	sub    $0x4,%esp
  8030c6:	ff 75 10             	push   0x10(%ebp)
  8030c9:	ff 75 0c             	push   0xc(%ebp)
  8030cc:	56                   	push   %esi
  8030cd:	ff d0                	call   *%eax
  8030cf:	83 c4 10             	add    $0x10,%esp
}
  8030d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030d5:	5b                   	pop    %ebx
  8030d6:	5e                   	pop    %esi
  8030d7:	5d                   	pop    %ebp
  8030d8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030d9:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8030de:	8b 40 48             	mov    0x48(%eax),%eax
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	53                   	push   %ebx
  8030e5:	50                   	push   %eax
  8030e6:	68 75 43 80 00       	push   $0x804375
  8030eb:	e8 f7 ea ff ff       	call   801be7 <cprintf>
		return -E_INVAL;
  8030f0:	83 c4 10             	add    $0x10,%esp
  8030f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030f8:	eb d8                	jmp    8030d2 <write+0x53>
		return -E_NOT_SUPP;
  8030fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030ff:	eb d1                	jmp    8030d2 <write+0x53>

00803101 <seek>:

int
seek(int fdnum, off_t offset)
{
  803101:	55                   	push   %ebp
  803102:	89 e5                	mov    %esp,%ebp
  803104:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803107:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80310a:	50                   	push   %eax
  80310b:	ff 75 08             	push   0x8(%ebp)
  80310e:	e8 3a fc ff ff       	call   802d4d <fd_lookup>
  803113:	83 c4 10             	add    $0x10,%esp
  803116:	85 c0                	test   %eax,%eax
  803118:	78 0e                	js     803128 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80311a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803128:	c9                   	leave  
  803129:	c3                   	ret    

0080312a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
  80312d:	56                   	push   %esi
  80312e:	53                   	push   %ebx
  80312f:	83 ec 18             	sub    $0x18,%esp
  803132:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803135:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803138:	50                   	push   %eax
  803139:	53                   	push   %ebx
  80313a:	e8 0e fc ff ff       	call   802d4d <fd_lookup>
  80313f:	83 c4 10             	add    $0x10,%esp
  803142:	85 c0                	test   %eax,%eax
  803144:	78 34                	js     80317a <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803146:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803149:	83 ec 08             	sub    $0x8,%esp
  80314c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80314f:	50                   	push   %eax
  803150:	ff 36                	push   (%esi)
  803152:	e8 46 fc ff ff       	call   802d9d <dev_lookup>
  803157:	83 c4 10             	add    $0x10,%esp
  80315a:	85 c0                	test   %eax,%eax
  80315c:	78 1c                	js     80317a <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80315e:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  803162:	74 1d                	je     803181 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 40 18             	mov    0x18(%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 34                	je     8031a2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80316e:	83 ec 08             	sub    $0x8,%esp
  803171:	ff 75 0c             	push   0xc(%ebp)
  803174:	56                   	push   %esi
  803175:	ff d0                	call   *%eax
  803177:	83 c4 10             	add    $0x10,%esp
}
  80317a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80317d:	5b                   	pop    %ebx
  80317e:	5e                   	pop    %esi
  80317f:	5d                   	pop    %ebp
  803180:	c3                   	ret    
			thisenv->env_id, fdnum);
  803181:	a1 08 a0 80 00       	mov    0x80a008,%eax
  803186:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	53                   	push   %ebx
  80318d:	50                   	push   %eax
  80318e:	68 38 43 80 00       	push   $0x804338
  803193:	e8 4f ea ff ff       	call   801be7 <cprintf>
		return -E_INVAL;
  803198:	83 c4 10             	add    $0x10,%esp
  80319b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031a0:	eb d8                	jmp    80317a <ftruncate+0x50>
		return -E_NOT_SUPP;
  8031a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031a7:	eb d1                	jmp    80317a <ftruncate+0x50>

008031a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
  8031ac:	56                   	push   %esi
  8031ad:	53                   	push   %ebx
  8031ae:	83 ec 18             	sub    $0x18,%esp
  8031b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031b7:	50                   	push   %eax
  8031b8:	ff 75 08             	push   0x8(%ebp)
  8031bb:	e8 8d fb ff ff       	call   802d4d <fd_lookup>
  8031c0:	83 c4 10             	add    $0x10,%esp
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	78 49                	js     803210 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031c7:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8031ca:	83 ec 08             	sub    $0x8,%esp
  8031cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031d0:	50                   	push   %eax
  8031d1:	ff 36                	push   (%esi)
  8031d3:	e8 c5 fb ff ff       	call   802d9d <dev_lookup>
  8031d8:	83 c4 10             	add    $0x10,%esp
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	78 31                	js     803210 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8031e6:	74 2f                	je     803217 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8031e8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8031eb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8031f2:	00 00 00 
	stat->st_isdir = 0;
  8031f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8031fc:	00 00 00 
	stat->st_dev = dev;
  8031ff:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803205:	83 ec 08             	sub    $0x8,%esp
  803208:	53                   	push   %ebx
  803209:	56                   	push   %esi
  80320a:	ff 50 14             	call   *0x14(%eax)
  80320d:	83 c4 10             	add    $0x10,%esp
}
  803210:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803213:	5b                   	pop    %ebx
  803214:	5e                   	pop    %esi
  803215:	5d                   	pop    %ebp
  803216:	c3                   	ret    
		return -E_NOT_SUPP;
  803217:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80321c:	eb f2                	jmp    803210 <fstat+0x67>

0080321e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
  803221:	56                   	push   %esi
  803222:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803223:	83 ec 08             	sub    $0x8,%esp
  803226:	6a 00                	push   $0x0
  803228:	ff 75 08             	push   0x8(%ebp)
  80322b:	e8 c5 f9 ff ff       	call   802bf5 <open>
  803230:	89 c3                	mov    %eax,%ebx
  803232:	83 c4 10             	add    $0x10,%esp
  803235:	85 c0                	test   %eax,%eax
  803237:	78 1b                	js     803254 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  803239:	83 ec 08             	sub    $0x8,%esp
  80323c:	ff 75 0c             	push   0xc(%ebp)
  80323f:	50                   	push   %eax
  803240:	e8 64 ff ff ff       	call   8031a9 <fstat>
  803245:	89 c6                	mov    %eax,%esi
	close(fd);
  803247:	89 1c 24             	mov    %ebx,(%esp)
  80324a:	e8 26 fc ff ff       	call   802e75 <close>
	return r;
  80324f:	83 c4 10             	add    $0x10,%esp
  803252:	89 f3                	mov    %esi,%ebx
}
  803254:	89 d8                	mov    %ebx,%eax
  803256:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803259:	5b                   	pop    %ebx
  80325a:	5e                   	pop    %esi
  80325b:	5d                   	pop    %ebp
  80325c:	c3                   	ret    

0080325d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80325d:	55                   	push   %ebp
  80325e:	89 e5                	mov    %esp,%ebp
  803260:	56                   	push   %esi
  803261:	53                   	push   %ebx
  803262:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803265:	83 ec 0c             	sub    $0xc,%esp
  803268:	ff 75 08             	push   0x8(%ebp)
  80326b:	e8 76 fa ff ff       	call   802ce6 <fd2data>
  803270:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803272:	83 c4 08             	add    $0x8,%esp
  803275:	68 a4 43 80 00       	push   $0x8043a4
  80327a:	53                   	push   %ebx
  80327b:	e8 2c f0 ff ff       	call   8022ac <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803280:	8b 46 04             	mov    0x4(%esi),%eax
  803283:	2b 06                	sub    (%esi),%eax
  803285:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80328b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803292:	00 00 00 
	stat->st_dev = &devpipe;
  803295:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  80329c:	90 80 00 
	return 0;
}
  80329f:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032a7:	5b                   	pop    %ebx
  8032a8:	5e                   	pop    %esi
  8032a9:	5d                   	pop    %ebp
  8032aa:	c3                   	ret    

008032ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
  8032ae:	53                   	push   %ebx
  8032af:	83 ec 0c             	sub    $0xc,%esp
  8032b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8032b5:	53                   	push   %ebx
  8032b6:	6a 00                	push   $0x0
  8032b8:	e8 70 f4 ff ff       	call   80272d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8032bd:	89 1c 24             	mov    %ebx,(%esp)
  8032c0:	e8 21 fa ff ff       	call   802ce6 <fd2data>
  8032c5:	83 c4 08             	add    $0x8,%esp
  8032c8:	50                   	push   %eax
  8032c9:	6a 00                	push   $0x0
  8032cb:	e8 5d f4 ff ff       	call   80272d <sys_page_unmap>
}
  8032d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <_pipeisclosed>:
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	57                   	push   %edi
  8032d9:	56                   	push   %esi
  8032da:	53                   	push   %ebx
  8032db:	83 ec 1c             	sub    $0x1c,%esp
  8032de:	89 c7                	mov    %eax,%edi
  8032e0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8032e2:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8032e7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8032ea:	83 ec 0c             	sub    $0xc,%esp
  8032ed:	57                   	push   %edi
  8032ee:	e8 a7 f9 ff ff       	call   802c9a <pageref>
  8032f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8032f6:	89 34 24             	mov    %esi,(%esp)
  8032f9:	e8 9c f9 ff ff       	call   802c9a <pageref>
		nn = thisenv->env_runs;
  8032fe:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  803304:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803307:	83 c4 10             	add    $0x10,%esp
  80330a:	39 cb                	cmp    %ecx,%ebx
  80330c:	74 1b                	je     803329 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80330e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803311:	75 cf                	jne    8032e2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803313:	8b 42 58             	mov    0x58(%edx),%eax
  803316:	6a 01                	push   $0x1
  803318:	50                   	push   %eax
  803319:	53                   	push   %ebx
  80331a:	68 ab 43 80 00       	push   $0x8043ab
  80331f:	e8 c3 e8 ff ff       	call   801be7 <cprintf>
  803324:	83 c4 10             	add    $0x10,%esp
  803327:	eb b9                	jmp    8032e2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803329:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80332c:	0f 94 c0             	sete   %al
  80332f:	0f b6 c0             	movzbl %al,%eax
}
  803332:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803335:	5b                   	pop    %ebx
  803336:	5e                   	pop    %esi
  803337:	5f                   	pop    %edi
  803338:	5d                   	pop    %ebp
  803339:	c3                   	ret    

0080333a <devpipe_write>:
{
  80333a:	55                   	push   %ebp
  80333b:	89 e5                	mov    %esp,%ebp
  80333d:	57                   	push   %edi
  80333e:	56                   	push   %esi
  80333f:	53                   	push   %ebx
  803340:	83 ec 28             	sub    $0x28,%esp
  803343:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803346:	56                   	push   %esi
  803347:	e8 9a f9 ff ff       	call   802ce6 <fd2data>
  80334c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80334e:	83 c4 10             	add    $0x10,%esp
  803351:	bf 00 00 00 00       	mov    $0x0,%edi
  803356:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803359:	75 09                	jne    803364 <devpipe_write+0x2a>
	return i;
  80335b:	89 f8                	mov    %edi,%eax
  80335d:	eb 23                	jmp    803382 <devpipe_write+0x48>
			sys_yield();
  80335f:	e8 25 f3 ff ff       	call   802689 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803364:	8b 43 04             	mov    0x4(%ebx),%eax
  803367:	8b 0b                	mov    (%ebx),%ecx
  803369:	8d 51 20             	lea    0x20(%ecx),%edx
  80336c:	39 d0                	cmp    %edx,%eax
  80336e:	72 1a                	jb     80338a <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  803370:	89 da                	mov    %ebx,%edx
  803372:	89 f0                	mov    %esi,%eax
  803374:	e8 5c ff ff ff       	call   8032d5 <_pipeisclosed>
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 e2                	je     80335f <devpipe_write+0x25>
				return 0;
  80337d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803385:	5b                   	pop    %ebx
  803386:	5e                   	pop    %esi
  803387:	5f                   	pop    %edi
  803388:	5d                   	pop    %ebp
  803389:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80338a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80338d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803391:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803394:	89 c2                	mov    %eax,%edx
  803396:	c1 fa 1f             	sar    $0x1f,%edx
  803399:	89 d1                	mov    %edx,%ecx
  80339b:	c1 e9 1b             	shr    $0x1b,%ecx
  80339e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8033a1:	83 e2 1f             	and    $0x1f,%edx
  8033a4:	29 ca                	sub    %ecx,%edx
  8033a6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8033aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8033ae:	83 c0 01             	add    $0x1,%eax
  8033b1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8033b4:	83 c7 01             	add    $0x1,%edi
  8033b7:	eb 9d                	jmp    803356 <devpipe_write+0x1c>

008033b9 <devpipe_read>:
{
  8033b9:	55                   	push   %ebp
  8033ba:	89 e5                	mov    %esp,%ebp
  8033bc:	57                   	push   %edi
  8033bd:	56                   	push   %esi
  8033be:	53                   	push   %ebx
  8033bf:	83 ec 18             	sub    $0x18,%esp
  8033c2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8033c5:	57                   	push   %edi
  8033c6:	e8 1b f9 ff ff       	call   802ce6 <fd2data>
  8033cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8033cd:	83 c4 10             	add    $0x10,%esp
  8033d0:	be 00 00 00 00       	mov    $0x0,%esi
  8033d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8033d8:	75 13                	jne    8033ed <devpipe_read+0x34>
	return i;
  8033da:	89 f0                	mov    %esi,%eax
  8033dc:	eb 02                	jmp    8033e0 <devpipe_read+0x27>
				return i;
  8033de:	89 f0                	mov    %esi,%eax
}
  8033e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
			sys_yield();
  8033e8:	e8 9c f2 ff ff       	call   802689 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8033ed:	8b 03                	mov    (%ebx),%eax
  8033ef:	3b 43 04             	cmp    0x4(%ebx),%eax
  8033f2:	75 18                	jne    80340c <devpipe_read+0x53>
			if (i > 0)
  8033f4:	85 f6                	test   %esi,%esi
  8033f6:	75 e6                	jne    8033de <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  8033f8:	89 da                	mov    %ebx,%edx
  8033fa:	89 f8                	mov    %edi,%eax
  8033fc:	e8 d4 fe ff ff       	call   8032d5 <_pipeisclosed>
  803401:	85 c0                	test   %eax,%eax
  803403:	74 e3                	je     8033e8 <devpipe_read+0x2f>
				return 0;
  803405:	b8 00 00 00 00       	mov    $0x0,%eax
  80340a:	eb d4                	jmp    8033e0 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80340c:	99                   	cltd   
  80340d:	c1 ea 1b             	shr    $0x1b,%edx
  803410:	01 d0                	add    %edx,%eax
  803412:	83 e0 1f             	and    $0x1f,%eax
  803415:	29 d0                	sub    %edx,%eax
  803417:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80341c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80341f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803422:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803425:	83 c6 01             	add    $0x1,%esi
  803428:	eb ab                	jmp    8033d5 <devpipe_read+0x1c>

0080342a <pipe>:
{
  80342a:	55                   	push   %ebp
  80342b:	89 e5                	mov    %esp,%ebp
  80342d:	56                   	push   %esi
  80342e:	53                   	push   %ebx
  80342f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803432:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803435:	50                   	push   %eax
  803436:	e8 c2 f8 ff ff       	call   802cfd <fd_alloc>
  80343b:	89 c3                	mov    %eax,%ebx
  80343d:	83 c4 10             	add    $0x10,%esp
  803440:	85 c0                	test   %eax,%eax
  803442:	0f 88 23 01 00 00    	js     80356b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 07 04 00 00       	push   $0x407
  803450:	ff 75 f4             	push   -0xc(%ebp)
  803453:	6a 00                	push   $0x0
  803455:	e8 4e f2 ff ff       	call   8026a8 <sys_page_alloc>
  80345a:	89 c3                	mov    %eax,%ebx
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	85 c0                	test   %eax,%eax
  803461:	0f 88 04 01 00 00    	js     80356b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80346d:	50                   	push   %eax
  80346e:	e8 8a f8 ff ff       	call   802cfd <fd_alloc>
  803473:	89 c3                	mov    %eax,%ebx
  803475:	83 c4 10             	add    $0x10,%esp
  803478:	85 c0                	test   %eax,%eax
  80347a:	0f 88 db 00 00 00    	js     80355b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 07 04 00 00       	push   $0x407
  803488:	ff 75 f0             	push   -0x10(%ebp)
  80348b:	6a 00                	push   $0x0
  80348d:	e8 16 f2 ff ff       	call   8026a8 <sys_page_alloc>
  803492:	89 c3                	mov    %eax,%ebx
  803494:	83 c4 10             	add    $0x10,%esp
  803497:	85 c0                	test   %eax,%eax
  803499:	0f 88 bc 00 00 00    	js     80355b <pipe+0x131>
	va = fd2data(fd0);
  80349f:	83 ec 0c             	sub    $0xc,%esp
  8034a2:	ff 75 f4             	push   -0xc(%ebp)
  8034a5:	e8 3c f8 ff ff       	call   802ce6 <fd2data>
  8034aa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034ac:	83 c4 0c             	add    $0xc,%esp
  8034af:	68 07 04 00 00       	push   $0x407
  8034b4:	50                   	push   %eax
  8034b5:	6a 00                	push   $0x0
  8034b7:	e8 ec f1 ff ff       	call   8026a8 <sys_page_alloc>
  8034bc:	89 c3                	mov    %eax,%ebx
  8034be:	83 c4 10             	add    $0x10,%esp
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	0f 88 82 00 00 00    	js     80354b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034c9:	83 ec 0c             	sub    $0xc,%esp
  8034cc:	ff 75 f0             	push   -0x10(%ebp)
  8034cf:	e8 12 f8 ff ff       	call   802ce6 <fd2data>
  8034d4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8034db:	50                   	push   %eax
  8034dc:	6a 00                	push   $0x0
  8034de:	56                   	push   %esi
  8034df:	6a 00                	push   $0x0
  8034e1:	e8 05 f2 ff ff       	call   8026eb <sys_page_map>
  8034e6:	89 c3                	mov    %eax,%ebx
  8034e8:	83 c4 20             	add    $0x20,%esp
  8034eb:	85 c0                	test   %eax,%eax
  8034ed:	78 4e                	js     80353d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8034ef:	a1 80 90 80 00       	mov    0x809080,%eax
  8034f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803506:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803512:	83 ec 0c             	sub    $0xc,%esp
  803515:	ff 75 f4             	push   -0xc(%ebp)
  803518:	e8 b9 f7 ff ff       	call   802cd6 <fd2num>
  80351d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803520:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803522:	83 c4 04             	add    $0x4,%esp
  803525:	ff 75 f0             	push   -0x10(%ebp)
  803528:	e8 a9 f7 ff ff       	call   802cd6 <fd2num>
  80352d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803530:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803533:	83 c4 10             	add    $0x10,%esp
  803536:	bb 00 00 00 00       	mov    $0x0,%ebx
  80353b:	eb 2e                	jmp    80356b <pipe+0x141>
	sys_page_unmap(0, va);
  80353d:	83 ec 08             	sub    $0x8,%esp
  803540:	56                   	push   %esi
  803541:	6a 00                	push   $0x0
  803543:	e8 e5 f1 ff ff       	call   80272d <sys_page_unmap>
  803548:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80354b:	83 ec 08             	sub    $0x8,%esp
  80354e:	ff 75 f0             	push   -0x10(%ebp)
  803551:	6a 00                	push   $0x0
  803553:	e8 d5 f1 ff ff       	call   80272d <sys_page_unmap>
  803558:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80355b:	83 ec 08             	sub    $0x8,%esp
  80355e:	ff 75 f4             	push   -0xc(%ebp)
  803561:	6a 00                	push   $0x0
  803563:	e8 c5 f1 ff ff       	call   80272d <sys_page_unmap>
  803568:	83 c4 10             	add    $0x10,%esp
}
  80356b:	89 d8                	mov    %ebx,%eax
  80356d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803570:	5b                   	pop    %ebx
  803571:	5e                   	pop    %esi
  803572:	5d                   	pop    %ebp
  803573:	c3                   	ret    

00803574 <pipeisclosed>:
{
  803574:	55                   	push   %ebp
  803575:	89 e5                	mov    %esp,%ebp
  803577:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80357a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80357d:	50                   	push   %eax
  80357e:	ff 75 08             	push   0x8(%ebp)
  803581:	e8 c7 f7 ff ff       	call   802d4d <fd_lookup>
  803586:	83 c4 10             	add    $0x10,%esp
  803589:	85 c0                	test   %eax,%eax
  80358b:	78 18                	js     8035a5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80358d:	83 ec 0c             	sub    $0xc,%esp
  803590:	ff 75 f4             	push   -0xc(%ebp)
  803593:	e8 4e f7 ff ff       	call   802ce6 <fd2data>
  803598:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	e8 33 fd ff ff       	call   8032d5 <_pipeisclosed>
  8035a2:	83 c4 10             	add    $0x10,%esp
}
  8035a5:	c9                   	leave  
  8035a6:	c3                   	ret    

008035a7 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8035a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ac:	c3                   	ret    

008035ad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8035ad:	55                   	push   %ebp
  8035ae:	89 e5                	mov    %esp,%ebp
  8035b0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8035b3:	68 c3 43 80 00       	push   $0x8043c3
  8035b8:	ff 75 0c             	push   0xc(%ebp)
  8035bb:	e8 ec ec ff ff       	call   8022ac <strcpy>
	return 0;
}
  8035c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c5:	c9                   	leave  
  8035c6:	c3                   	ret    

008035c7 <devcons_write>:
{
  8035c7:	55                   	push   %ebp
  8035c8:	89 e5                	mov    %esp,%ebp
  8035ca:	57                   	push   %edi
  8035cb:	56                   	push   %esi
  8035cc:	53                   	push   %ebx
  8035cd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8035d3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8035d8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8035de:	eb 2e                	jmp    80360e <devcons_write+0x47>
		m = n - tot;
  8035e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8035e3:	29 f3                	sub    %esi,%ebx
  8035e5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8035ea:	39 c3                	cmp    %eax,%ebx
  8035ec:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8035ef:	83 ec 04             	sub    $0x4,%esp
  8035f2:	53                   	push   %ebx
  8035f3:	89 f0                	mov    %esi,%eax
  8035f5:	03 45 0c             	add    0xc(%ebp),%eax
  8035f8:	50                   	push   %eax
  8035f9:	57                   	push   %edi
  8035fa:	e8 43 ee ff ff       	call   802442 <memmove>
		sys_cputs(buf, m);
  8035ff:	83 c4 08             	add    $0x8,%esp
  803602:	53                   	push   %ebx
  803603:	57                   	push   %edi
  803604:	e8 e3 ef ff ff       	call   8025ec <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803609:	01 de                	add    %ebx,%esi
  80360b:	83 c4 10             	add    $0x10,%esp
  80360e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803611:	72 cd                	jb     8035e0 <devcons_write+0x19>
}
  803613:	89 f0                	mov    %esi,%eax
  803615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803618:	5b                   	pop    %ebx
  803619:	5e                   	pop    %esi
  80361a:	5f                   	pop    %edi
  80361b:	5d                   	pop    %ebp
  80361c:	c3                   	ret    

0080361d <devcons_read>:
{
  80361d:	55                   	push   %ebp
  80361e:	89 e5                	mov    %esp,%ebp
  803620:	83 ec 08             	sub    $0x8,%esp
  803623:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803628:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80362c:	75 07                	jne    803635 <devcons_read+0x18>
  80362e:	eb 1f                	jmp    80364f <devcons_read+0x32>
		sys_yield();
  803630:	e8 54 f0 ff ff       	call   802689 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  803635:	e8 d0 ef ff ff       	call   80260a <sys_cgetc>
  80363a:	85 c0                	test   %eax,%eax
  80363c:	74 f2                	je     803630 <devcons_read+0x13>
	if (c < 0)
  80363e:	78 0f                	js     80364f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803640:	83 f8 04             	cmp    $0x4,%eax
  803643:	74 0c                	je     803651 <devcons_read+0x34>
	*(char*)vbuf = c;
  803645:	8b 55 0c             	mov    0xc(%ebp),%edx
  803648:	88 02                	mov    %al,(%edx)
	return 1;
  80364a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80364f:	c9                   	leave  
  803650:	c3                   	ret    
		return 0;
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	eb f7                	jmp    80364f <devcons_read+0x32>

00803658 <cputchar>:
{
  803658:	55                   	push   %ebp
  803659:	89 e5                	mov    %esp,%ebp
  80365b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803664:	6a 01                	push   $0x1
  803666:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803669:	50                   	push   %eax
  80366a:	e8 7d ef ff ff       	call   8025ec <sys_cputs>
}
  80366f:	83 c4 10             	add    $0x10,%esp
  803672:	c9                   	leave  
  803673:	c3                   	ret    

00803674 <getchar>:
{
  803674:	55                   	push   %ebp
  803675:	89 e5                	mov    %esp,%ebp
  803677:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80367a:	6a 01                	push   $0x1
  80367c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80367f:	50                   	push   %eax
  803680:	6a 00                	push   $0x0
  803682:	e8 2a f9 ff ff       	call   802fb1 <read>
	if (r < 0)
  803687:	83 c4 10             	add    $0x10,%esp
  80368a:	85 c0                	test   %eax,%eax
  80368c:	78 06                	js     803694 <getchar+0x20>
	if (r < 1)
  80368e:	74 06                	je     803696 <getchar+0x22>
	return c;
  803690:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803694:	c9                   	leave  
  803695:	c3                   	ret    
		return -E_EOF;
  803696:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80369b:	eb f7                	jmp    803694 <getchar+0x20>

0080369d <iscons>:
{
  80369d:	55                   	push   %ebp
  80369e:	89 e5                	mov    %esp,%ebp
  8036a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036a6:	50                   	push   %eax
  8036a7:	ff 75 08             	push   0x8(%ebp)
  8036aa:	e8 9e f6 ff ff       	call   802d4d <fd_lookup>
  8036af:	83 c4 10             	add    $0x10,%esp
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	78 11                	js     8036c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b9:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8036bf:	39 10                	cmp    %edx,(%eax)
  8036c1:	0f 94 c0             	sete   %al
  8036c4:	0f b6 c0             	movzbl %al,%eax
}
  8036c7:	c9                   	leave  
  8036c8:	c3                   	ret    

008036c9 <opencons>:
{
  8036c9:	55                   	push   %ebp
  8036ca:	89 e5                	mov    %esp,%ebp
  8036cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8036cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036d2:	50                   	push   %eax
  8036d3:	e8 25 f6 ff ff       	call   802cfd <fd_alloc>
  8036d8:	83 c4 10             	add    $0x10,%esp
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	78 3a                	js     803719 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8036df:	83 ec 04             	sub    $0x4,%esp
  8036e2:	68 07 04 00 00       	push   $0x407
  8036e7:	ff 75 f4             	push   -0xc(%ebp)
  8036ea:	6a 00                	push   $0x0
  8036ec:	e8 b7 ef ff ff       	call   8026a8 <sys_page_alloc>
  8036f1:	83 c4 10             	add    $0x10,%esp
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	78 21                	js     803719 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803701:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80370d:	83 ec 0c             	sub    $0xc,%esp
  803710:	50                   	push   %eax
  803711:	e8 c0 f5 ff ff       	call   802cd6 <fd2num>
  803716:	83 c4 10             	add    $0x10,%esp
}
  803719:	c9                   	leave  
  80371a:	c3                   	ret    
  80371b:	66 90                	xchg   %ax,%ax
  80371d:	66 90                	xchg   %ax,%ax
  80371f:	90                   	nop

00803720 <__udivdi3>:
  803720:	f3 0f 1e fb          	endbr32 
  803724:	55                   	push   %ebp
  803725:	57                   	push   %edi
  803726:	56                   	push   %esi
  803727:	53                   	push   %ebx
  803728:	83 ec 1c             	sub    $0x1c,%esp
  80372b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80372f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803733:	8b 74 24 34          	mov    0x34(%esp),%esi
  803737:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80373b:	85 c0                	test   %eax,%eax
  80373d:	75 19                	jne    803758 <__udivdi3+0x38>
  80373f:	39 f3                	cmp    %esi,%ebx
  803741:	76 4d                	jbe    803790 <__udivdi3+0x70>
  803743:	31 ff                	xor    %edi,%edi
  803745:	89 e8                	mov    %ebp,%eax
  803747:	89 f2                	mov    %esi,%edx
  803749:	f7 f3                	div    %ebx
  80374b:	89 fa                	mov    %edi,%edx
  80374d:	83 c4 1c             	add    $0x1c,%esp
  803750:	5b                   	pop    %ebx
  803751:	5e                   	pop    %esi
  803752:	5f                   	pop    %edi
  803753:	5d                   	pop    %ebp
  803754:	c3                   	ret    
  803755:	8d 76 00             	lea    0x0(%esi),%esi
  803758:	39 f0                	cmp    %esi,%eax
  80375a:	76 14                	jbe    803770 <__udivdi3+0x50>
  80375c:	31 ff                	xor    %edi,%edi
  80375e:	31 c0                	xor    %eax,%eax
  803760:	89 fa                	mov    %edi,%edx
  803762:	83 c4 1c             	add    $0x1c,%esp
  803765:	5b                   	pop    %ebx
  803766:	5e                   	pop    %esi
  803767:	5f                   	pop    %edi
  803768:	5d                   	pop    %ebp
  803769:	c3                   	ret    
  80376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803770:	0f bd f8             	bsr    %eax,%edi
  803773:	83 f7 1f             	xor    $0x1f,%edi
  803776:	75 48                	jne    8037c0 <__udivdi3+0xa0>
  803778:	39 f0                	cmp    %esi,%eax
  80377a:	72 06                	jb     803782 <__udivdi3+0x62>
  80377c:	31 c0                	xor    %eax,%eax
  80377e:	39 eb                	cmp    %ebp,%ebx
  803780:	77 de                	ja     803760 <__udivdi3+0x40>
  803782:	b8 01 00 00 00       	mov    $0x1,%eax
  803787:	eb d7                	jmp    803760 <__udivdi3+0x40>
  803789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803790:	89 d9                	mov    %ebx,%ecx
  803792:	85 db                	test   %ebx,%ebx
  803794:	75 0b                	jne    8037a1 <__udivdi3+0x81>
  803796:	b8 01 00 00 00       	mov    $0x1,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f3                	div    %ebx
  80379f:	89 c1                	mov    %eax,%ecx
  8037a1:	31 d2                	xor    %edx,%edx
  8037a3:	89 f0                	mov    %esi,%eax
  8037a5:	f7 f1                	div    %ecx
  8037a7:	89 c6                	mov    %eax,%esi
  8037a9:	89 e8                	mov    %ebp,%eax
  8037ab:	89 f7                	mov    %esi,%edi
  8037ad:	f7 f1                	div    %ecx
  8037af:	89 fa                	mov    %edi,%edx
  8037b1:	83 c4 1c             	add    $0x1c,%esp
  8037b4:	5b                   	pop    %ebx
  8037b5:	5e                   	pop    %esi
  8037b6:	5f                   	pop    %edi
  8037b7:	5d                   	pop    %ebp
  8037b8:	c3                   	ret    
  8037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8037c0:	89 f9                	mov    %edi,%ecx
  8037c2:	ba 20 00 00 00       	mov    $0x20,%edx
  8037c7:	29 fa                	sub    %edi,%edx
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037cf:	89 d1                	mov    %edx,%ecx
  8037d1:	89 d8                	mov    %ebx,%eax
  8037d3:	d3 e8                	shr    %cl,%eax
  8037d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8037d9:	09 c1                	or     %eax,%ecx
  8037db:	89 f0                	mov    %esi,%eax
  8037dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037e1:	89 f9                	mov    %edi,%ecx
  8037e3:	d3 e3                	shl    %cl,%ebx
  8037e5:	89 d1                	mov    %edx,%ecx
  8037e7:	d3 e8                	shr    %cl,%eax
  8037e9:	89 f9                	mov    %edi,%ecx
  8037eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8037ef:	89 eb                	mov    %ebp,%ebx
  8037f1:	d3 e6                	shl    %cl,%esi
  8037f3:	89 d1                	mov    %edx,%ecx
  8037f5:	d3 eb                	shr    %cl,%ebx
  8037f7:	09 f3                	or     %esi,%ebx
  8037f9:	89 c6                	mov    %eax,%esi
  8037fb:	89 f2                	mov    %esi,%edx
  8037fd:	89 d8                	mov    %ebx,%eax
  8037ff:	f7 74 24 08          	divl   0x8(%esp)
  803803:	89 d6                	mov    %edx,%esi
  803805:	89 c3                	mov    %eax,%ebx
  803807:	f7 64 24 0c          	mull   0xc(%esp)
  80380b:	39 d6                	cmp    %edx,%esi
  80380d:	72 19                	jb     803828 <__udivdi3+0x108>
  80380f:	89 f9                	mov    %edi,%ecx
  803811:	d3 e5                	shl    %cl,%ebp
  803813:	39 c5                	cmp    %eax,%ebp
  803815:	73 04                	jae    80381b <__udivdi3+0xfb>
  803817:	39 d6                	cmp    %edx,%esi
  803819:	74 0d                	je     803828 <__udivdi3+0x108>
  80381b:	89 d8                	mov    %ebx,%eax
  80381d:	31 ff                	xor    %edi,%edi
  80381f:	e9 3c ff ff ff       	jmp    803760 <__udivdi3+0x40>
  803824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803828:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80382b:	31 ff                	xor    %edi,%edi
  80382d:	e9 2e ff ff ff       	jmp    803760 <__udivdi3+0x40>
  803832:	66 90                	xchg   %ax,%ax
  803834:	66 90                	xchg   %ax,%ax
  803836:	66 90                	xchg   %ax,%ax
  803838:	66 90                	xchg   %ax,%ax
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	66 90                	xchg   %ax,%ax
  80383e:	66 90                	xchg   %ax,%ax

00803840 <__umoddi3>:
  803840:	f3 0f 1e fb          	endbr32 
  803844:	55                   	push   %ebp
  803845:	57                   	push   %edi
  803846:	56                   	push   %esi
  803847:	53                   	push   %ebx
  803848:	83 ec 1c             	sub    $0x1c,%esp
  80384b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80384f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803853:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  803857:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80385b:	89 f0                	mov    %esi,%eax
  80385d:	89 da                	mov    %ebx,%edx
  80385f:	85 ff                	test   %edi,%edi
  803861:	75 15                	jne    803878 <__umoddi3+0x38>
  803863:	39 dd                	cmp    %ebx,%ebp
  803865:	76 39                	jbe    8038a0 <__umoddi3+0x60>
  803867:	f7 f5                	div    %ebp
  803869:	89 d0                	mov    %edx,%eax
  80386b:	31 d2                	xor    %edx,%edx
  80386d:	83 c4 1c             	add    $0x1c,%esp
  803870:	5b                   	pop    %ebx
  803871:	5e                   	pop    %esi
  803872:	5f                   	pop    %edi
  803873:	5d                   	pop    %ebp
  803874:	c3                   	ret    
  803875:	8d 76 00             	lea    0x0(%esi),%esi
  803878:	39 df                	cmp    %ebx,%edi
  80387a:	77 f1                	ja     80386d <__umoddi3+0x2d>
  80387c:	0f bd cf             	bsr    %edi,%ecx
  80387f:	83 f1 1f             	xor    $0x1f,%ecx
  803882:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803886:	75 40                	jne    8038c8 <__umoddi3+0x88>
  803888:	39 df                	cmp    %ebx,%edi
  80388a:	72 04                	jb     803890 <__umoddi3+0x50>
  80388c:	39 f5                	cmp    %esi,%ebp
  80388e:	77 dd                	ja     80386d <__umoddi3+0x2d>
  803890:	89 da                	mov    %ebx,%edx
  803892:	89 f0                	mov    %esi,%eax
  803894:	29 e8                	sub    %ebp,%eax
  803896:	19 fa                	sbb    %edi,%edx
  803898:	eb d3                	jmp    80386d <__umoddi3+0x2d>
  80389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8038a0:	89 e9                	mov    %ebp,%ecx
  8038a2:	85 ed                	test   %ebp,%ebp
  8038a4:	75 0b                	jne    8038b1 <__umoddi3+0x71>
  8038a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ab:	31 d2                	xor    %edx,%edx
  8038ad:	f7 f5                	div    %ebp
  8038af:	89 c1                	mov    %eax,%ecx
  8038b1:	89 d8                	mov    %ebx,%eax
  8038b3:	31 d2                	xor    %edx,%edx
  8038b5:	f7 f1                	div    %ecx
  8038b7:	89 f0                	mov    %esi,%eax
  8038b9:	f7 f1                	div    %ecx
  8038bb:	89 d0                	mov    %edx,%eax
  8038bd:	31 d2                	xor    %edx,%edx
  8038bf:	eb ac                	jmp    80386d <__umoddi3+0x2d>
  8038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038cc:	ba 20 00 00 00       	mov    $0x20,%edx
  8038d1:	29 c2                	sub    %eax,%edx
  8038d3:	89 c1                	mov    %eax,%ecx
  8038d5:	89 e8                	mov    %ebp,%eax
  8038d7:	d3 e7                	shl    %cl,%edi
  8038d9:	89 d1                	mov    %edx,%ecx
  8038db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8038df:	d3 e8                	shr    %cl,%eax
  8038e1:	89 c1                	mov    %eax,%ecx
  8038e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038e7:	09 f9                	or     %edi,%ecx
  8038e9:	89 df                	mov    %ebx,%edi
  8038eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ef:	89 c1                	mov    %eax,%ecx
  8038f1:	d3 e5                	shl    %cl,%ebp
  8038f3:	89 d1                	mov    %edx,%ecx
  8038f5:	d3 ef                	shr    %cl,%edi
  8038f7:	89 c1                	mov    %eax,%ecx
  8038f9:	89 f0                	mov    %esi,%eax
  8038fb:	d3 e3                	shl    %cl,%ebx
  8038fd:	89 d1                	mov    %edx,%ecx
  8038ff:	89 fa                	mov    %edi,%edx
  803901:	d3 e8                	shr    %cl,%eax
  803903:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803908:	09 d8                	or     %ebx,%eax
  80390a:	f7 74 24 08          	divl   0x8(%esp)
  80390e:	89 d3                	mov    %edx,%ebx
  803910:	d3 e6                	shl    %cl,%esi
  803912:	f7 e5                	mul    %ebp
  803914:	89 c7                	mov    %eax,%edi
  803916:	89 d1                	mov    %edx,%ecx
  803918:	39 d3                	cmp    %edx,%ebx
  80391a:	72 06                	jb     803922 <__umoddi3+0xe2>
  80391c:	75 0e                	jne    80392c <__umoddi3+0xec>
  80391e:	39 c6                	cmp    %eax,%esi
  803920:	73 0a                	jae    80392c <__umoddi3+0xec>
  803922:	29 e8                	sub    %ebp,%eax
  803924:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803928:	89 d1                	mov    %edx,%ecx
  80392a:	89 c7                	mov    %eax,%edi
  80392c:	89 f5                	mov    %esi,%ebp
  80392e:	8b 74 24 04          	mov    0x4(%esp),%esi
  803932:	29 fd                	sub    %edi,%ebp
  803934:	19 cb                	sbb    %ecx,%ebx
  803936:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80393b:	89 d8                	mov    %ebx,%eax
  80393d:	d3 e0                	shl    %cl,%eax
  80393f:	89 f1                	mov    %esi,%ecx
  803941:	d3 ed                	shr    %cl,%ebp
  803943:	d3 eb                	shr    %cl,%ebx
  803945:	09 e8                	or     %ebp,%eax
  803947:	89 da                	mov    %ebx,%edx
  803949:	83 c4 1c             	add    $0x1c,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5f                   	pop    %edi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
