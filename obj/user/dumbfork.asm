
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 9a 01 00 00       	call   8001cb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 75 0d 00 00       	call   800dbf <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 9e 0d 00 00       	call   800e02 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 db 0a 00 00       	call   800b59 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 b7 0d 00 00       	call   800e44 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 00 12 80 00       	push   $0x801200
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 13 12 80 00       	push   $0x801213
  8000a8:	e8 76 01 00 00       	call   800223 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 23 12 80 00       	push   $0x801223
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 13 12 80 00       	push   $0x801213
  8000ba:	e8 64 01 00 00       	call   800223 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 34 12 80 00       	push   $0x801234
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 13 12 80 00       	push   $0x801213
  8000cc:	e8 52 01 00 00       	call   800223 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 14             	sub    $0x14,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d8:	b8 07 00 00 00       	mov    $0x7,%eax
  8000dd:	cd 30                	int    $0x30
  8000df:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e1:	85 c0                	test   %eax,%eax
  8000e3:	78 20                	js     800105 <dumbfork+0x34>
  8000e5:	ba 00 00 80 00       	mov    $0x800000,%edx
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000ea:	75 41                	jne    80012d <dumbfork+0x5c>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8000ec:	e8 90 0c 00 00       	call   800d81 <sys_getenvid>
  8000f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fe:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800103:	eb 57                	jmp    80015c <dumbfork+0x8b>
		panic("sys_exofork: %e", envid);
  800105:	50                   	push   %eax
  800106:	68 47 12 80 00       	push   $0x801247
  80010b:	6a 37                	push   $0x37
  80010d:	68 13 12 80 00       	push   $0x801213
  800112:	e8 0c 01 00 00       	call   800223 <_panic>

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
		duppage(envid, addr);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	52                   	push   %edx
  80011b:	53                   	push   %ebx
  80011c:	e8 12 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800124:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800130:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  800136:	72 df                	jb     800117 <dumbfork+0x46>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80013e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800143:	50                   	push   %eax
  800144:	53                   	push   %ebx
  800145:	e8 e9 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80014a:	83 c4 08             	add    $0x8,%esp
  80014d:	6a 02                	push   $0x2
  80014f:	53                   	push   %ebx
  800150:	e8 31 0d 00 00       	call   800e86 <sys_env_set_status>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	85 c0                	test   %eax,%eax
  80015a:	78 07                	js     800163 <dumbfork+0x92>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80015c:	89 d8                	mov    %ebx,%eax
  80015e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800161:	c9                   	leave  
  800162:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  800163:	50                   	push   %eax
  800164:	68 57 12 80 00       	push   $0x801257
  800169:	6a 4c                	push   $0x4c
  80016b:	68 13 12 80 00       	push   $0x801213
  800170:	e8 ae 00 00 00       	call   800223 <_panic>

00800175 <umain>:
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	57                   	push   %edi
  800179:	56                   	push   %esi
  80017a:	53                   	push   %ebx
  80017b:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  80017e:	e8 4e ff ff ff       	call   8000d1 <dumbfork>
  800183:	89 c6                	mov    %eax,%esi
  800185:	85 c0                	test   %eax,%eax
  800187:	bf 6e 12 80 00       	mov    $0x80126e,%edi
  80018c:	b8 75 12 80 00       	mov    $0x801275,%eax
  800191:	0f 44 f8             	cmove  %eax,%edi
	for (i = 0; i < (who ? 10 : 20); i++) {
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	eb 1f                	jmp    8001ba <umain+0x45>
  80019b:	83 fb 13             	cmp    $0x13,%ebx
  80019e:	7f 23                	jg     8001c3 <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	57                   	push   %edi
  8001a4:	53                   	push   %ebx
  8001a5:	68 7b 12 80 00       	push   $0x80127b
  8001aa:	e8 4f 01 00 00       	call   8002fe <cprintf>
		sys_yield();
  8001af:	e8 ec 0b 00 00       	call   800da0 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001b4:	83 c3 01             	add    $0x1,%ebx
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	85 f6                	test   %esi,%esi
  8001bc:	74 dd                	je     80019b <umain+0x26>
  8001be:	83 fb 09             	cmp    $0x9,%ebx
  8001c1:	7e dd                	jle    8001a0 <umain+0x2b>
}
  8001c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c6:	5b                   	pop    %ebx
  8001c7:	5e                   	pop    %esi
  8001c8:	5f                   	pop    %edi
  8001c9:	5d                   	pop    %ebp
  8001ca:	c3                   	ret    

008001cb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d6:	e8 a6 0b 00 00       	call   800d81 <sys_getenvid>
  8001db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e8:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ed:	85 db                	test   %ebx,%ebx
  8001ef:	7e 07                	jle    8001f8 <libmain+0x2d>
		binaryname = argv[0];
  8001f1:	8b 06                	mov    (%esi),%eax
  8001f3:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	56                   	push   %esi
  8001fc:	53                   	push   %ebx
  8001fd:	e8 73 ff ff ff       	call   800175 <umain>

	// exit gracefully
	exit();
  800202:	e8 0a 00 00 00       	call   800211 <exit>
}
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    

00800211 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800217:	6a 00                	push   $0x0
  800219:	e8 22 0b 00 00       	call   800d40 <sys_env_destroy>
}
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800228:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800231:	e8 4b 0b 00 00       	call   800d81 <sys_getenvid>
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	ff 75 0c             	push   0xc(%ebp)
  80023c:	ff 75 08             	push   0x8(%ebp)
  80023f:	56                   	push   %esi
  800240:	50                   	push   %eax
  800241:	68 98 12 80 00       	push   $0x801298
  800246:	e8 b3 00 00 00       	call   8002fe <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024b:	83 c4 18             	add    $0x18,%esp
  80024e:	53                   	push   %ebx
  80024f:	ff 75 10             	push   0x10(%ebp)
  800252:	e8 56 00 00 00       	call   8002ad <vcprintf>
	cprintf("\n");
  800257:	c7 04 24 8b 12 80 00 	movl   $0x80128b,(%esp)
  80025e:	e8 9b 00 00 00       	call   8002fe <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800266:	cc                   	int3   
  800267:	eb fd                	jmp    800266 <_panic+0x43>

00800269 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	53                   	push   %ebx
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800273:	8b 13                	mov    (%ebx),%edx
  800275:	8d 42 01             	lea    0x1(%edx),%eax
  800278:	89 03                	mov    %eax,(%ebx)
  80027a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800281:	3d ff 00 00 00       	cmp    $0xff,%eax
  800286:	74 09                	je     800291 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800288:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028f:	c9                   	leave  
  800290:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	68 ff 00 00 00       	push   $0xff
  800299:	8d 43 08             	lea    0x8(%ebx),%eax
  80029c:	50                   	push   %eax
  80029d:	e8 61 0a 00 00       	call   800d03 <sys_cputs>
		b->idx = 0;
  8002a2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	eb db                	jmp    800288 <putch+0x1f>

008002ad <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002bd:	00 00 00 
	b.cnt = 0;
  8002c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ca:	ff 75 0c             	push   0xc(%ebp)
  8002cd:	ff 75 08             	push   0x8(%ebp)
  8002d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d6:	50                   	push   %eax
  8002d7:	68 69 02 80 00       	push   $0x800269
  8002dc:	e8 14 01 00 00       	call   8003f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e1:	83 c4 08             	add    $0x8,%esp
  8002e4:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8002ea:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f0:	50                   	push   %eax
  8002f1:	e8 0d 0a 00 00       	call   800d03 <sys_cputs>

	return b.cnt;
}
  8002f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800304:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800307:	50                   	push   %eax
  800308:	ff 75 08             	push   0x8(%ebp)
  80030b:	e8 9d ff ff ff       	call   8002ad <vcprintf>
	va_end(ap);

	return cnt;
}
  800310:	c9                   	leave  
  800311:	c3                   	ret    

00800312 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 1c             	sub    $0x1c,%esp
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	89 d6                	mov    %edx,%esi
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	8b 55 0c             	mov    0xc(%ebp),%edx
  800325:	89 d1                	mov    %edx,%ecx
  800327:	89 c2                	mov    %eax,%edx
  800329:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800335:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800344:	72 3e                	jb     800384 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	ff 75 18             	push   0x18(%ebp)
  80034c:	83 eb 01             	sub    $0x1,%ebx
  80034f:	53                   	push   %ebx
  800350:	50                   	push   %eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	ff 75 e4             	push   -0x1c(%ebp)
  800357:	ff 75 e0             	push   -0x20(%ebp)
  80035a:	ff 75 dc             	push   -0x24(%ebp)
  80035d:	ff 75 d8             	push   -0x28(%ebp)
  800360:	e8 4b 0c 00 00       	call   800fb0 <__udivdi3>
  800365:	83 c4 18             	add    $0x18,%esp
  800368:	52                   	push   %edx
  800369:	50                   	push   %eax
  80036a:	89 f2                	mov    %esi,%edx
  80036c:	89 f8                	mov    %edi,%eax
  80036e:	e8 9f ff ff ff       	call   800312 <printnum>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	eb 13                	jmp    80038b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	56                   	push   %esi
  80037c:	ff 75 18             	push   0x18(%ebp)
  80037f:	ff d7                	call   *%edi
  800381:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800384:	83 eb 01             	sub    $0x1,%ebx
  800387:	85 db                	test   %ebx,%ebx
  800389:	7f ed                	jg     800378 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	56                   	push   %esi
  80038f:	83 ec 04             	sub    $0x4,%esp
  800392:	ff 75 e4             	push   -0x1c(%ebp)
  800395:	ff 75 e0             	push   -0x20(%ebp)
  800398:	ff 75 dc             	push   -0x24(%ebp)
  80039b:	ff 75 d8             	push   -0x28(%ebp)
  80039e:	e8 2d 0d 00 00       	call   8010d0 <__umoddi3>
  8003a3:	83 c4 14             	add    $0x14,%esp
  8003a6:	0f be 80 bb 12 80 00 	movsbl 0x8012bb(%eax),%eax
  8003ad:	50                   	push   %eax
  8003ae:	ff d7                	call   *%edi
}
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b6:	5b                   	pop    %ebx
  8003b7:	5e                   	pop    %esi
  8003b8:	5f                   	pop    %edi
  8003b9:	5d                   	pop    %ebp
  8003ba:	c3                   	ret    

008003bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c5:	8b 10                	mov    (%eax),%edx
  8003c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ca:	73 0a                	jae    8003d6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cf:	89 08                	mov    %ecx,(%eax)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	88 02                	mov    %al,(%edx)
}
  8003d6:	5d                   	pop    %ebp
  8003d7:	c3                   	ret    

008003d8 <printfmt>:
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e1:	50                   	push   %eax
  8003e2:	ff 75 10             	push   0x10(%ebp)
  8003e5:	ff 75 0c             	push   0xc(%ebp)
  8003e8:	ff 75 08             	push   0x8(%ebp)
  8003eb:	e8 05 00 00 00       	call   8003f5 <vprintfmt>
}
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <vprintfmt>:
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	57                   	push   %edi
  8003f9:	56                   	push   %esi
  8003fa:	53                   	push   %ebx
  8003fb:	83 ec 3c             	sub    $0x3c,%esp
  8003fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800404:	8b 7d 10             	mov    0x10(%ebp),%edi
  800407:	eb 0a                	jmp    800413 <vprintfmt+0x1e>
			putch(ch, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	53                   	push   %ebx
  80040d:	50                   	push   %eax
  80040e:	ff d6                	call   *%esi
  800410:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800413:	83 c7 01             	add    $0x1,%edi
  800416:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80041a:	83 f8 25             	cmp    $0x25,%eax
  80041d:	74 0c                	je     80042b <vprintfmt+0x36>
			if (ch == '\0')
  80041f:	85 c0                	test   %eax,%eax
  800421:	75 e6                	jne    800409 <vprintfmt+0x14>
}
  800423:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800426:	5b                   	pop    %ebx
  800427:	5e                   	pop    %esi
  800428:	5f                   	pop    %edi
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    
		padc = ' ';
  80042b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80042f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800436:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80043d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800444:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800449:	8d 47 01             	lea    0x1(%edi),%eax
  80044c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044f:	0f b6 17             	movzbl (%edi),%edx
  800452:	8d 42 dd             	lea    -0x23(%edx),%eax
  800455:	3c 55                	cmp    $0x55,%al
  800457:	0f 87 a6 04 00 00    	ja     800903 <vprintfmt+0x50e>
  80045d:	0f b6 c0             	movzbl %al,%eax
  800460:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800467:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80046a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80046e:	eb d9                	jmp    800449 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800473:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800477:	eb d0                	jmp    800449 <vprintfmt+0x54>
  800479:	0f b6 d2             	movzbl %dl,%edx
  80047c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80047f:	b8 00 00 00 00       	mov    $0x0,%eax
  800484:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800487:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80048a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80048e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800491:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800494:	83 f9 09             	cmp    $0x9,%ecx
  800497:	77 55                	ja     8004ee <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800499:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80049c:	eb e9                	jmp    800487 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8d 40 04             	lea    0x4(%eax),%eax
  8004ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8004b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b6:	79 91                	jns    800449 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004c5:	eb 82                	jmp    800449 <vprintfmt+0x54>
  8004c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ca:	85 d2                	test   %edx,%edx
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 49 c2             	cmovns %edx,%eax
  8004d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004da:	e9 6a ff ff ff       	jmp    800449 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004df:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8004e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e9:	e9 5b ff ff ff       	jmp    800449 <vprintfmt+0x54>
  8004ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	eb bc                	jmp    8004b2 <vprintfmt+0xbd>
			lflag++;
  8004f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004fc:	e9 48 ff ff ff       	jmp    800449 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 78 04             	lea    0x4(%eax),%edi
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	53                   	push   %ebx
  80050b:	ff 30                	push   (%eax)
  80050d:	ff d6                	call   *%esi
			break;
  80050f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800512:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800515:	e9 88 03 00 00       	jmp    8008a2 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 78 04             	lea    0x4(%eax),%edi
  800520:	8b 10                	mov    (%eax),%edx
  800522:	89 d0                	mov    %edx,%eax
  800524:	f7 d8                	neg    %eax
  800526:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800529:	83 f8 0f             	cmp    $0xf,%eax
  80052c:	7f 23                	jg     800551 <vprintfmt+0x15c>
  80052e:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  800535:	85 d2                	test   %edx,%edx
  800537:	74 18                	je     800551 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800539:	52                   	push   %edx
  80053a:	68 dc 12 80 00       	push   $0x8012dc
  80053f:	53                   	push   %ebx
  800540:	56                   	push   %esi
  800541:	e8 92 fe ff ff       	call   8003d8 <printfmt>
  800546:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800549:	89 7d 14             	mov    %edi,0x14(%ebp)
  80054c:	e9 51 03 00 00       	jmp    8008a2 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800551:	50                   	push   %eax
  800552:	68 d3 12 80 00       	push   $0x8012d3
  800557:	53                   	push   %ebx
  800558:	56                   	push   %esi
  800559:	e8 7a fe ff ff       	call   8003d8 <printfmt>
  80055e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800561:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800564:	e9 39 03 00 00       	jmp    8008a2 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800577:	85 d2                	test   %edx,%edx
  800579:	b8 cc 12 80 00       	mov    $0x8012cc,%eax
  80057e:	0f 45 c2             	cmovne %edx,%eax
  800581:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800584:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800588:	7e 06                	jle    800590 <vprintfmt+0x19b>
  80058a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80058e:	75 0d                	jne    80059d <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800590:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800593:	89 c7                	mov    %eax,%edi
  800595:	03 45 d4             	add    -0x2c(%ebp),%eax
  800598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059b:	eb 55                	jmp    8005f2 <vprintfmt+0x1fd>
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	ff 75 e0             	push   -0x20(%ebp)
  8005a3:	ff 75 cc             	push   -0x34(%ebp)
  8005a6:	e8 f5 03 00 00       	call   8009a0 <strnlen>
  8005ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ae:	29 c2                	sub    %eax,%edx
  8005b0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005b8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bf:	eb 0f                	jmp    8005d0 <vprintfmt+0x1db>
					putch(padc, putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	ff 75 d4             	push   -0x2c(%ebp)
  8005c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ca:	83 ef 01             	sub    $0x1,%edi
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	85 ff                	test   %edi,%edi
  8005d2:	7f ed                	jg     8005c1 <vprintfmt+0x1cc>
  8005d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005d7:	85 d2                	test   %edx,%edx
  8005d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005de:	0f 49 c2             	cmovns %edx,%eax
  8005e1:	29 c2                	sub    %eax,%edx
  8005e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e6:	eb a8                	jmp    800590 <vprintfmt+0x19b>
					putch(ch, putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	52                   	push   %edx
  8005ed:	ff d6                	call   *%esi
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005f5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f7:	83 c7 01             	add    $0x1,%edi
  8005fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fe:	0f be d0             	movsbl %al,%edx
  800601:	85 d2                	test   %edx,%edx
  800603:	74 4b                	je     800650 <vprintfmt+0x25b>
  800605:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800609:	78 06                	js     800611 <vprintfmt+0x21c>
  80060b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80060f:	78 1e                	js     80062f <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800611:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800615:	74 d1                	je     8005e8 <vprintfmt+0x1f3>
  800617:	0f be c0             	movsbl %al,%eax
  80061a:	83 e8 20             	sub    $0x20,%eax
  80061d:	83 f8 5e             	cmp    $0x5e,%eax
  800620:	76 c6                	jbe    8005e8 <vprintfmt+0x1f3>
					putch('?', putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	53                   	push   %ebx
  800626:	6a 3f                	push   $0x3f
  800628:	ff d6                	call   *%esi
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	eb c3                	jmp    8005f2 <vprintfmt+0x1fd>
  80062f:	89 cf                	mov    %ecx,%edi
  800631:	eb 0e                	jmp    800641 <vprintfmt+0x24c>
				putch(' ', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	6a 20                	push   $0x20
  800639:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063b:	83 ef 01             	sub    $0x1,%edi
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	85 ff                	test   %edi,%edi
  800643:	7f ee                	jg     800633 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800645:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	e9 52 02 00 00       	jmp    8008a2 <vprintfmt+0x4ad>
  800650:	89 cf                	mov    %ecx,%edi
  800652:	eb ed                	jmp    800641 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 c0 04             	add    $0x4,%eax
  80065a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800662:	85 d2                	test   %edx,%edx
  800664:	b8 cc 12 80 00       	mov    $0x8012cc,%eax
  800669:	0f 45 c2             	cmovne %edx,%eax
  80066c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80066f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800673:	7e 06                	jle    80067b <vprintfmt+0x286>
  800675:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800679:	75 0d                	jne    800688 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067e:	89 c7                	mov    %eax,%edi
  800680:	03 45 d4             	add    -0x2c(%ebp),%eax
  800683:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800686:	eb 55                	jmp    8006dd <vprintfmt+0x2e8>
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 e0             	push   -0x20(%ebp)
  80068e:	ff 75 cc             	push   -0x34(%ebp)
  800691:	e8 0a 03 00 00       	call   8009a0 <strnlen>
  800696:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800699:	29 c2                	sub    %eax,%edx
  80069b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006aa:	eb 0f                	jmp    8006bb <vprintfmt+0x2c6>
					putch(padc, putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	ff 75 d4             	push   -0x2c(%ebp)
  8006b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ed                	jg     8006ac <vprintfmt+0x2b7>
  8006bf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006c2:	85 d2                	test   %edx,%edx
  8006c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c9:	0f 49 c2             	cmovns %edx,%eax
  8006cc:	29 c2                	sub    %eax,%edx
  8006ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006d1:	eb a8                	jmp    80067b <vprintfmt+0x286>
					putch(ch, putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	52                   	push   %edx
  8006d8:	ff d6                	call   *%esi
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006e0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8006e2:	83 c7 01             	add    $0x1,%edi
  8006e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e9:	0f be d0             	movsbl %al,%edx
  8006ec:	3c 3a                	cmp    $0x3a,%al
  8006ee:	74 4b                	je     80073b <vprintfmt+0x346>
  8006f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f4:	78 06                	js     8006fc <vprintfmt+0x307>
  8006f6:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8006fa:	78 1e                	js     80071a <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800700:	74 d1                	je     8006d3 <vprintfmt+0x2de>
  800702:	0f be c0             	movsbl %al,%eax
  800705:	83 e8 20             	sub    $0x20,%eax
  800708:	83 f8 5e             	cmp    $0x5e,%eax
  80070b:	76 c6                	jbe    8006d3 <vprintfmt+0x2de>
					putch('?', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 3f                	push   $0x3f
  800713:	ff d6                	call   *%esi
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	eb c3                	jmp    8006dd <vprintfmt+0x2e8>
  80071a:	89 cf                	mov    %ecx,%edi
  80071c:	eb 0e                	jmp    80072c <vprintfmt+0x337>
				putch(' ', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 20                	push   $0x20
  800724:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800726:	83 ef 01             	sub    $0x1,%edi
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	85 ff                	test   %edi,%edi
  80072e:	7f ee                	jg     80071e <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800730:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
  800736:	e9 67 01 00 00       	jmp    8008a2 <vprintfmt+0x4ad>
  80073b:	89 cf                	mov    %ecx,%edi
  80073d:	eb ed                	jmp    80072c <vprintfmt+0x337>
	if (lflag >= 2)
  80073f:	83 f9 01             	cmp    $0x1,%ecx
  800742:	7f 1b                	jg     80075f <vprintfmt+0x36a>
	else if (lflag)
  800744:	85 c9                	test   %ecx,%ecx
  800746:	74 63                	je     8007ab <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800750:	99                   	cltd   
  800751:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8d 40 04             	lea    0x4(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
  80075d:	eb 17                	jmp    800776 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800776:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800779:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80077c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800781:	85 c9                	test   %ecx,%ecx
  800783:	0f 89 ff 00 00 00    	jns    800888 <vprintfmt+0x493>
				putch('-', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 2d                	push   $0x2d
  80078f:	ff d6                	call   *%esi
				num = -(long long) num;
  800791:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800794:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800797:	f7 da                	neg    %edx
  800799:	83 d1 00             	adc    $0x0,%ecx
  80079c:	f7 d9                	neg    %ecx
  80079e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007a6:	e9 dd 00 00 00       	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b3:	99                   	cltd   
  8007b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c0:	eb b4                	jmp    800776 <vprintfmt+0x381>
	if (lflag >= 2)
  8007c2:	83 f9 01             	cmp    $0x1,%ecx
  8007c5:	7f 1e                	jg     8007e5 <vprintfmt+0x3f0>
	else if (lflag)
  8007c7:	85 c9                	test   %ecx,%ecx
  8007c9:	74 32                	je     8007fd <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 10                	mov    (%eax),%edx
  8007d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d5:	8d 40 04             	lea    0x4(%eax),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007db:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8007e0:	e9 a3 00 00 00       	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 10                	mov    (%eax),%edx
  8007ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ed:	8d 40 08             	lea    0x8(%eax),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8007f8:	e9 8b 00 00 00       	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 10                	mov    (%eax),%edx
  800802:	b9 00 00 00 00       	mov    $0x0,%ecx
  800807:	8d 40 04             	lea    0x4(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800812:	eb 74                	jmp    800888 <vprintfmt+0x493>
	if (lflag >= 2)
  800814:	83 f9 01             	cmp    $0x1,%ecx
  800817:	7f 1b                	jg     800834 <vprintfmt+0x43f>
	else if (lflag)
  800819:	85 c9                	test   %ecx,%ecx
  80081b:	74 2c                	je     800849 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 10                	mov    (%eax),%edx
  800822:	b9 00 00 00 00       	mov    $0x0,%ecx
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800832:	eb 54                	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 10                	mov    (%eax),%edx
  800839:	8b 48 04             	mov    0x4(%eax),%ecx
  80083c:	8d 40 08             	lea    0x8(%eax),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800842:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800847:	eb 3f                	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 10                	mov    (%eax),%edx
  80084e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800859:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80085e:	eb 28                	jmp    800888 <vprintfmt+0x493>
			putch('0', putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	6a 30                	push   $0x30
  800866:	ff d6                	call   *%esi
			putch('x', putdat);
  800868:	83 c4 08             	add    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 78                	push   $0x78
  80086e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 10                	mov    (%eax),%edx
  800875:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80087a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800883:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800888:	83 ec 0c             	sub    $0xc,%esp
  80088b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80088f:	50                   	push   %eax
  800890:	ff 75 d4             	push   -0x2c(%ebp)
  800893:	57                   	push   %edi
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	89 da                	mov    %ebx,%edx
  800898:	89 f0                	mov    %esi,%eax
  80089a:	e8 73 fa ff ff       	call   800312 <printnum>
			break;
  80089f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a5:	e9 69 fb ff ff       	jmp    800413 <vprintfmt+0x1e>
	if (lflag >= 2)
  8008aa:	83 f9 01             	cmp    $0x1,%ecx
  8008ad:	7f 1b                	jg     8008ca <vprintfmt+0x4d5>
	else if (lflag)
  8008af:	85 c9                	test   %ecx,%ecx
  8008b1:	74 2c                	je     8008df <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 10                	mov    (%eax),%edx
  8008b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008bd:	8d 40 04             	lea    0x4(%eax),%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8008c8:	eb be                	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 10                	mov    (%eax),%edx
  8008cf:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d2:	8d 40 08             	lea    0x8(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8008dd:	eb a9                	jmp    800888 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8b 10                	mov    (%eax),%edx
  8008e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ef:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8008f4:	eb 92                	jmp    800888 <vprintfmt+0x493>
			putch(ch, putdat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	53                   	push   %ebx
  8008fa:	6a 25                	push   $0x25
  8008fc:	ff d6                	call   *%esi
			break;
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	eb 9f                	jmp    8008a2 <vprintfmt+0x4ad>
			putch('%', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	53                   	push   %ebx
  800907:	6a 25                	push   $0x25
  800909:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	89 f8                	mov    %edi,%eax
  800910:	eb 03                	jmp    800915 <vprintfmt+0x520>
  800912:	83 e8 01             	sub    $0x1,%eax
  800915:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800919:	75 f7                	jne    800912 <vprintfmt+0x51d>
  80091b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80091e:	eb 82                	jmp    8008a2 <vprintfmt+0x4ad>

00800920 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 18             	sub    $0x18,%esp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800933:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093d:	85 c0                	test   %eax,%eax
  80093f:	74 26                	je     800967 <vsnprintf+0x47>
  800941:	85 d2                	test   %edx,%edx
  800943:	7e 22                	jle    800967 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800945:	ff 75 14             	push   0x14(%ebp)
  800948:	ff 75 10             	push   0x10(%ebp)
  80094b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	68 bb 03 80 00       	push   $0x8003bb
  800954:	e8 9c fa ff ff       	call   8003f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800962:	83 c4 10             	add    $0x10,%esp
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    
		return -E_INVAL;
  800967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096c:	eb f7                	jmp    800965 <vsnprintf+0x45>

0080096e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800974:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800977:	50                   	push   %eax
  800978:	ff 75 10             	push   0x10(%ebp)
  80097b:	ff 75 0c             	push   0xc(%ebp)
  80097e:	ff 75 08             	push   0x8(%ebp)
  800981:	e8 9a ff ff ff       	call   800920 <vsnprintf>
	va_end(ap);

	return rc;
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	eb 03                	jmp    800998 <strlen+0x10>
		n++;
  800995:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800998:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80099c:	75 f7                	jne    800995 <strlen+0xd>
	return n;
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ae:	eb 03                	jmp    8009b3 <strnlen+0x13>
		n++;
  8009b0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b3:	39 d0                	cmp    %edx,%eax
  8009b5:	74 08                	je     8009bf <strnlen+0x1f>
  8009b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009bb:	75 f3                	jne    8009b0 <strnlen+0x10>
  8009bd:	89 c2                	mov    %eax,%edx
	return n;
}
  8009bf:	89 d0                	mov    %edx,%eax
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	53                   	push   %ebx
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009d6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	84 d2                	test   %dl,%dl
  8009de:	75 f2                	jne    8009d2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e0:	89 c8                	mov    %ecx,%eax
  8009e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	53                   	push   %ebx
  8009eb:	83 ec 10             	sub    $0x10,%esp
  8009ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f1:	53                   	push   %ebx
  8009f2:	e8 91 ff ff ff       	call   800988 <strlen>
  8009f7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009fa:	ff 75 0c             	push   0xc(%ebp)
  8009fd:	01 d8                	add    %ebx,%eax
  8009ff:	50                   	push   %eax
  800a00:	e8 be ff ff ff       	call   8009c3 <strcpy>
	return dst;
}
  800a05:	89 d8                	mov    %ebx,%eax
  800a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 75 08             	mov    0x8(%ebp),%esi
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a17:	89 f3                	mov    %esi,%ebx
  800a19:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1c:	89 f0                	mov    %esi,%eax
  800a1e:	eb 0f                	jmp    800a2f <strncpy+0x23>
		*dst++ = *src;
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	0f b6 0a             	movzbl (%edx),%ecx
  800a26:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a29:	80 f9 01             	cmp    $0x1,%cl
  800a2c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800a2f:	39 d8                	cmp    %ebx,%eax
  800a31:	75 ed                	jne    800a20 <strncpy+0x14>
	}
	return ret;
}
  800a33:	89 f0                	mov    %esi,%eax
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a44:	8b 55 10             	mov    0x10(%ebp),%edx
  800a47:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	74 21                	je     800a6e <strlcpy+0x35>
  800a4d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a51:	89 f2                	mov    %esi,%edx
  800a53:	eb 09                	jmp    800a5e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a55:	83 c1 01             	add    $0x1,%ecx
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a5e:	39 c2                	cmp    %eax,%edx
  800a60:	74 09                	je     800a6b <strlcpy+0x32>
  800a62:	0f b6 19             	movzbl (%ecx),%ebx
  800a65:	84 db                	test   %bl,%bl
  800a67:	75 ec                	jne    800a55 <strlcpy+0x1c>
  800a69:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6e:	29 f0                	sub    %esi,%eax
}
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7d:	eb 06                	jmp    800a85 <strcmp+0x11>
		p++, q++;
  800a7f:	83 c1 01             	add    $0x1,%ecx
  800a82:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a85:	0f b6 01             	movzbl (%ecx),%eax
  800a88:	84 c0                	test   %al,%al
  800a8a:	74 04                	je     800a90 <strcmp+0x1c>
  800a8c:	3a 02                	cmp    (%edx),%al
  800a8e:	74 ef                	je     800a7f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a90:	0f b6 c0             	movzbl %al,%eax
  800a93:	0f b6 12             	movzbl (%edx),%edx
  800a96:	29 d0                	sub    %edx,%eax
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	53                   	push   %ebx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	89 c3                	mov    %eax,%ebx
  800aa6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa9:	eb 06                	jmp    800ab1 <strncmp+0x17>
		n--, p++, q++;
  800aab:	83 c0 01             	add    $0x1,%eax
  800aae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ab1:	39 d8                	cmp    %ebx,%eax
  800ab3:	74 18                	je     800acd <strncmp+0x33>
  800ab5:	0f b6 08             	movzbl (%eax),%ecx
  800ab8:	84 c9                	test   %cl,%cl
  800aba:	74 04                	je     800ac0 <strncmp+0x26>
  800abc:	3a 0a                	cmp    (%edx),%cl
  800abe:	74 eb                	je     800aab <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac0:	0f b6 00             	movzbl (%eax),%eax
  800ac3:	0f b6 12             	movzbl (%edx),%edx
  800ac6:	29 d0                	sub    %edx,%eax
}
  800ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    
		return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad2:	eb f4                	jmp    800ac8 <strncmp+0x2e>

00800ad4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ade:	eb 03                	jmp    800ae3 <strchr+0xf>
  800ae0:	83 c0 01             	add    $0x1,%eax
  800ae3:	0f b6 10             	movzbl (%eax),%edx
  800ae6:	84 d2                	test   %dl,%dl
  800ae8:	74 06                	je     800af0 <strchr+0x1c>
		if (*s == c)
  800aea:	38 ca                	cmp    %cl,%dl
  800aec:	75 f2                	jne    800ae0 <strchr+0xc>
  800aee:	eb 05                	jmp    800af5 <strchr+0x21>
			return (char *) s;
	return 0;
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b01:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b04:	38 ca                	cmp    %cl,%dl
  800b06:	74 09                	je     800b11 <strfind+0x1a>
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	74 05                	je     800b11 <strfind+0x1a>
	for (; *s; s++)
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	eb f0                	jmp    800b01 <strfind+0xa>
			break;
	return (char *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b1f:	85 c9                	test   %ecx,%ecx
  800b21:	74 2f                	je     800b52 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b23:	89 f8                	mov    %edi,%eax
  800b25:	09 c8                	or     %ecx,%eax
  800b27:	a8 03                	test   $0x3,%al
  800b29:	75 21                	jne    800b4c <memset+0x39>
		c &= 0xFF;
  800b2b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b2f:	89 d0                	mov    %edx,%eax
  800b31:	c1 e0 08             	shl    $0x8,%eax
  800b34:	89 d3                	mov    %edx,%ebx
  800b36:	c1 e3 18             	shl    $0x18,%ebx
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	c1 e6 10             	shl    $0x10,%esi
  800b3e:	09 f3                	or     %esi,%ebx
  800b40:	09 da                	or     %ebx,%edx
  800b42:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b44:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b47:	fc                   	cld    
  800b48:	f3 ab                	rep stos %eax,%es:(%edi)
  800b4a:	eb 06                	jmp    800b52 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	fc                   	cld    
  800b50:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b52:	89 f8                	mov    %edi,%eax
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5f                   	pop    %edi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	57                   	push   %edi
  800b5d:	56                   	push   %esi
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b67:	39 c6                	cmp    %eax,%esi
  800b69:	73 32                	jae    800b9d <memmove+0x44>
  800b6b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	76 2b                	jbe    800b9d <memmove+0x44>
		s += n;
		d += n;
  800b72:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b75:	89 d6                	mov    %edx,%esi
  800b77:	09 fe                	or     %edi,%esi
  800b79:	09 ce                	or     %ecx,%esi
  800b7b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b81:	75 0e                	jne    800b91 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b83:	83 ef 04             	sub    $0x4,%edi
  800b86:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b89:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b8c:	fd                   	std    
  800b8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b8f:	eb 09                	jmp    800b9a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b91:	83 ef 01             	sub    $0x1,%edi
  800b94:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b97:	fd                   	std    
  800b98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b9a:	fc                   	cld    
  800b9b:	eb 1a                	jmp    800bb7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9d:	89 f2                	mov    %esi,%edx
  800b9f:	09 c2                	or     %eax,%edx
  800ba1:	09 ca                	or     %ecx,%edx
  800ba3:	f6 c2 03             	test   $0x3,%dl
  800ba6:	75 0a                	jne    800bb2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bab:	89 c7                	mov    %eax,%edi
  800bad:	fc                   	cld    
  800bae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb0:	eb 05                	jmp    800bb7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bb2:	89 c7                	mov    %eax,%edi
  800bb4:	fc                   	cld    
  800bb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc1:	ff 75 10             	push   0x10(%ebp)
  800bc4:	ff 75 0c             	push   0xc(%ebp)
  800bc7:	ff 75 08             	push   0x8(%ebp)
  800bca:	e8 8a ff ff ff       	call   800b59 <memmove>
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	89 c6                	mov    %eax,%esi
  800bde:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be1:	eb 06                	jmp    800be9 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800be9:	39 f0                	cmp    %esi,%eax
  800beb:	74 14                	je     800c01 <memcmp+0x30>
		if (*s1 != *s2)
  800bed:	0f b6 08             	movzbl (%eax),%ecx
  800bf0:	0f b6 1a             	movzbl (%edx),%ebx
  800bf3:	38 d9                	cmp    %bl,%cl
  800bf5:	74 ec                	je     800be3 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800bf7:	0f b6 c1             	movzbl %cl,%eax
  800bfa:	0f b6 db             	movzbl %bl,%ebx
  800bfd:	29 d8                	sub    %ebx,%eax
  800bff:	eb 05                	jmp    800c06 <memcmp+0x35>
	}

	return 0;
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c13:	89 c2                	mov    %eax,%edx
  800c15:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c18:	eb 03                	jmp    800c1d <memfind+0x13>
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	39 d0                	cmp    %edx,%eax
  800c1f:	73 04                	jae    800c25 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c21:	38 08                	cmp    %cl,(%eax)
  800c23:	75 f5                	jne    800c1a <memfind+0x10>
			break;
	return (void *) s;
}
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c33:	eb 03                	jmp    800c38 <strtol+0x11>
		s++;
  800c35:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800c38:	0f b6 02             	movzbl (%edx),%eax
  800c3b:	3c 20                	cmp    $0x20,%al
  800c3d:	74 f6                	je     800c35 <strtol+0xe>
  800c3f:	3c 09                	cmp    $0x9,%al
  800c41:	74 f2                	je     800c35 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c43:	3c 2b                	cmp    $0x2b,%al
  800c45:	74 2a                	je     800c71 <strtol+0x4a>
	int neg = 0;
  800c47:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4c:	3c 2d                	cmp    $0x2d,%al
  800c4e:	74 2b                	je     800c7b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c50:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c56:	75 0f                	jne    800c67 <strtol+0x40>
  800c58:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5b:	74 28                	je     800c85 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c5d:	85 db                	test   %ebx,%ebx
  800c5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c64:	0f 44 d8             	cmove  %eax,%ebx
  800c67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c6f:	eb 46                	jmp    800cb7 <strtol+0x90>
		s++;
  800c71:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c74:	bf 00 00 00 00       	mov    $0x0,%edi
  800c79:	eb d5                	jmp    800c50 <strtol+0x29>
		s++, neg = 1;
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c83:	eb cb                	jmp    800c50 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c85:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c89:	74 0e                	je     800c99 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c8b:	85 db                	test   %ebx,%ebx
  800c8d:	75 d8                	jne    800c67 <strtol+0x40>
		s++, base = 8;
  800c8f:	83 c2 01             	add    $0x1,%edx
  800c92:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c97:	eb ce                	jmp    800c67 <strtol+0x40>
		s += 2, base = 16;
  800c99:	83 c2 02             	add    $0x2,%edx
  800c9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca1:	eb c4                	jmp    800c67 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cac:	7d 3a                	jge    800ce8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cae:	83 c2 01             	add    $0x1,%edx
  800cb1:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800cb5:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800cb7:	0f b6 02             	movzbl (%edx),%eax
  800cba:	8d 70 d0             	lea    -0x30(%eax),%esi
  800cbd:	89 f3                	mov    %esi,%ebx
  800cbf:	80 fb 09             	cmp    $0x9,%bl
  800cc2:	76 df                	jbe    800ca3 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800cc4:	8d 70 9f             	lea    -0x61(%eax),%esi
  800cc7:	89 f3                	mov    %esi,%ebx
  800cc9:	80 fb 19             	cmp    $0x19,%bl
  800ccc:	77 08                	ja     800cd6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cce:	0f be c0             	movsbl %al,%eax
  800cd1:	83 e8 57             	sub    $0x57,%eax
  800cd4:	eb d3                	jmp    800ca9 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800cd6:	8d 70 bf             	lea    -0x41(%eax),%esi
  800cd9:	89 f3                	mov    %esi,%ebx
  800cdb:	80 fb 19             	cmp    $0x19,%bl
  800cde:	77 08                	ja     800ce8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ce0:	0f be c0             	movsbl %al,%eax
  800ce3:	83 e8 37             	sub    $0x37,%eax
  800ce6:	eb c1                	jmp    800ca9 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cec:	74 05                	je     800cf3 <strtol+0xcc>
		*endptr = (char *) s;
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cf3:	89 c8                	mov    %ecx,%eax
  800cf5:	f7 d8                	neg    %eax
  800cf7:	85 ff                	test   %edi,%edi
  800cf9:	0f 45 c8             	cmovne %eax,%ecx
}
  800cfc:	89 c8                	mov    %ecx,%eax
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	89 c3                	mov    %eax,%ebx
  800d16:	89 c7                	mov    %eax,%edi
  800d18:	89 c6                	mov    %eax,%esi
  800d1a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d27:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d31:	89 d1                	mov    %edx,%ecx
  800d33:	89 d3                	mov    %edx,%ebx
  800d35:	89 d7                	mov    %edx,%edi
  800d37:	89 d6                	mov    %edx,%esi
  800d39:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	b8 03 00 00 00       	mov    $0x3,%eax
  800d56:	89 cb                	mov    %ecx,%ebx
  800d58:	89 cf                	mov    %ecx,%edi
  800d5a:	89 ce                	mov    %ecx,%esi
  800d5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	7f 08                	jg     800d6a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	83 ec 0c             	sub    $0xc,%esp
  800d6d:	50                   	push   %eax
  800d6e:	6a 03                	push   $0x3
  800d70:	68 bf 15 80 00       	push   $0x8015bf
  800d75:	6a 23                	push   $0x23
  800d77:	68 dc 15 80 00       	push   $0x8015dc
  800d7c:	e8 a2 f4 ff ff       	call   800223 <_panic>

00800d81 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d87:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8c:	b8 02 00 00 00       	mov    $0x2,%eax
  800d91:	89 d1                	mov    %edx,%ecx
  800d93:	89 d3                	mov    %edx,%ebx
  800d95:	89 d7                	mov    %edx,%edi
  800d97:	89 d6                	mov    %edx,%esi
  800d99:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_yield>:

void
sys_yield(void)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db0:	89 d1                	mov    %edx,%ecx
  800db2:	89 d3                	mov    %edx,%ebx
  800db4:	89 d7                	mov    %edx,%edi
  800db6:	89 d6                	mov    %edx,%esi
  800db8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc8:	be 00 00 00 00       	mov    $0x0,%esi
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddb:	89 f7                	mov    %esi,%edi
  800ddd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7f 08                	jg     800deb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	83 ec 0c             	sub    $0xc,%esp
  800dee:	50                   	push   %eax
  800def:	6a 04                	push   $0x4
  800df1:	68 bf 15 80 00       	push   $0x8015bf
  800df6:	6a 23                	push   $0x23
  800df8:	68 dc 15 80 00       	push   $0x8015dc
  800dfd:	e8 21 f4 ff ff       	call   800223 <_panic>

00800e02 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	b8 05 00 00 00       	mov    $0x5,%eax
  800e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e19:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	7f 08                	jg     800e2d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	50                   	push   %eax
  800e31:	6a 05                	push   $0x5
  800e33:	68 bf 15 80 00       	push   $0x8015bf
  800e38:	6a 23                	push   $0x23
  800e3a:	68 dc 15 80 00       	push   $0x8015dc
  800e3f:	e8 df f3 ff ff       	call   800223 <_panic>

00800e44 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
  800e4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 06 00 00 00       	mov    $0x6,%eax
  800e5d:	89 df                	mov    %ebx,%edi
  800e5f:	89 de                	mov    %ebx,%esi
  800e61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e63:	85 c0                	test   %eax,%eax
  800e65:	7f 08                	jg     800e6f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	50                   	push   %eax
  800e73:	6a 06                	push   $0x6
  800e75:	68 bf 15 80 00       	push   $0x8015bf
  800e7a:	6a 23                	push   $0x23
  800e7c:	68 dc 15 80 00       	push   $0x8015dc
  800e81:	e8 9d f3 ff ff       	call   800223 <_panic>

00800e86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 08                	push   $0x8
  800eb7:	68 bf 15 80 00       	push   $0x8015bf
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 dc 15 80 00       	push   $0x8015dc
  800ec3:	e8 5b f3 ff ff       	call   800223 <_panic>

00800ec8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
  800ece:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee1:	89 df                	mov    %ebx,%edi
  800ee3:	89 de                	mov    %ebx,%esi
  800ee5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7f 08                	jg     800ef3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	6a 09                	push   $0x9
  800ef9:	68 bf 15 80 00       	push   $0x8015bf
  800efe:	6a 23                	push   $0x23
  800f00:	68 dc 15 80 00       	push   $0x8015dc
  800f05:	e8 19 f3 ff ff       	call   800223 <_panic>

00800f0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7f 08                	jg     800f35 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	83 ec 0c             	sub    $0xc,%esp
  800f38:	50                   	push   %eax
  800f39:	6a 0a                	push   $0xa
  800f3b:	68 bf 15 80 00       	push   $0x8015bf
  800f40:	6a 23                	push   $0x23
  800f42:	68 dc 15 80 00       	push   $0x8015dc
  800f47:	e8 d7 f2 ff ff       	call   800223 <_panic>

00800f4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f5d:	be 00 00 00 00       	mov    $0x0,%esi
  800f62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f68:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f85:	89 cb                	mov    %ecx,%ebx
  800f87:	89 cf                	mov    %ecx,%edi
  800f89:	89 ce                	mov    %ecx,%esi
  800f8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	7f 08                	jg     800f99 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f99:	83 ec 0c             	sub    $0xc,%esp
  800f9c:	50                   	push   %eax
  800f9d:	6a 0d                	push   $0xd
  800f9f:	68 bf 15 80 00       	push   $0x8015bf
  800fa4:	6a 23                	push   $0x23
  800fa6:	68 dc 15 80 00       	push   $0x8015dc
  800fab:	e8 73 f2 ff ff       	call   800223 <_panic>

00800fb0 <__udivdi3>:
  800fb0:	f3 0f 1e fb          	endbr32 
  800fb4:	55                   	push   %ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 1c             	sub    $0x1c,%esp
  800fbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	75 19                	jne    800fe8 <__udivdi3+0x38>
  800fcf:	39 f3                	cmp    %esi,%ebx
  800fd1:	76 4d                	jbe    801020 <__udivdi3+0x70>
  800fd3:	31 ff                	xor    %edi,%edi
  800fd5:	89 e8                	mov    %ebp,%eax
  800fd7:	89 f2                	mov    %esi,%edx
  800fd9:	f7 f3                	div    %ebx
  800fdb:	89 fa                	mov    %edi,%edx
  800fdd:	83 c4 1c             	add    $0x1c,%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
  800fe5:	8d 76 00             	lea    0x0(%esi),%esi
  800fe8:	39 f0                	cmp    %esi,%eax
  800fea:	76 14                	jbe    801000 <__udivdi3+0x50>
  800fec:	31 ff                	xor    %edi,%edi
  800fee:	31 c0                	xor    %eax,%eax
  800ff0:	89 fa                	mov    %edi,%edx
  800ff2:	83 c4 1c             	add    $0x1c,%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
  800ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801000:	0f bd f8             	bsr    %eax,%edi
  801003:	83 f7 1f             	xor    $0x1f,%edi
  801006:	75 48                	jne    801050 <__udivdi3+0xa0>
  801008:	39 f0                	cmp    %esi,%eax
  80100a:	72 06                	jb     801012 <__udivdi3+0x62>
  80100c:	31 c0                	xor    %eax,%eax
  80100e:	39 eb                	cmp    %ebp,%ebx
  801010:	77 de                	ja     800ff0 <__udivdi3+0x40>
  801012:	b8 01 00 00 00       	mov    $0x1,%eax
  801017:	eb d7                	jmp    800ff0 <__udivdi3+0x40>
  801019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801020:	89 d9                	mov    %ebx,%ecx
  801022:	85 db                	test   %ebx,%ebx
  801024:	75 0b                	jne    801031 <__udivdi3+0x81>
  801026:	b8 01 00 00 00       	mov    $0x1,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f3                	div    %ebx
  80102f:	89 c1                	mov    %eax,%ecx
  801031:	31 d2                	xor    %edx,%edx
  801033:	89 f0                	mov    %esi,%eax
  801035:	f7 f1                	div    %ecx
  801037:	89 c6                	mov    %eax,%esi
  801039:	89 e8                	mov    %ebp,%eax
  80103b:	89 f7                	mov    %esi,%edi
  80103d:	f7 f1                	div    %ecx
  80103f:	89 fa                	mov    %edi,%edx
  801041:	83 c4 1c             	add    $0x1c,%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
  801049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801050:	89 f9                	mov    %edi,%ecx
  801052:	ba 20 00 00 00       	mov    $0x20,%edx
  801057:	29 fa                	sub    %edi,%edx
  801059:	d3 e0                	shl    %cl,%eax
  80105b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80105f:	89 d1                	mov    %edx,%ecx
  801061:	89 d8                	mov    %ebx,%eax
  801063:	d3 e8                	shr    %cl,%eax
  801065:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801069:	09 c1                	or     %eax,%ecx
  80106b:	89 f0                	mov    %esi,%eax
  80106d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801071:	89 f9                	mov    %edi,%ecx
  801073:	d3 e3                	shl    %cl,%ebx
  801075:	89 d1                	mov    %edx,%ecx
  801077:	d3 e8                	shr    %cl,%eax
  801079:	89 f9                	mov    %edi,%ecx
  80107b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80107f:	89 eb                	mov    %ebp,%ebx
  801081:	d3 e6                	shl    %cl,%esi
  801083:	89 d1                	mov    %edx,%ecx
  801085:	d3 eb                	shr    %cl,%ebx
  801087:	09 f3                	or     %esi,%ebx
  801089:	89 c6                	mov    %eax,%esi
  80108b:	89 f2                	mov    %esi,%edx
  80108d:	89 d8                	mov    %ebx,%eax
  80108f:	f7 74 24 08          	divl   0x8(%esp)
  801093:	89 d6                	mov    %edx,%esi
  801095:	89 c3                	mov    %eax,%ebx
  801097:	f7 64 24 0c          	mull   0xc(%esp)
  80109b:	39 d6                	cmp    %edx,%esi
  80109d:	72 19                	jb     8010b8 <__udivdi3+0x108>
  80109f:	89 f9                	mov    %edi,%ecx
  8010a1:	d3 e5                	shl    %cl,%ebp
  8010a3:	39 c5                	cmp    %eax,%ebp
  8010a5:	73 04                	jae    8010ab <__udivdi3+0xfb>
  8010a7:	39 d6                	cmp    %edx,%esi
  8010a9:	74 0d                	je     8010b8 <__udivdi3+0x108>
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	31 ff                	xor    %edi,%edi
  8010af:	e9 3c ff ff ff       	jmp    800ff0 <__udivdi3+0x40>
  8010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010bb:	31 ff                	xor    %edi,%edi
  8010bd:	e9 2e ff ff ff       	jmp    800ff0 <__udivdi3+0x40>
  8010c2:	66 90                	xchg   %ax,%ax
  8010c4:	66 90                	xchg   %ax,%ax
  8010c6:	66 90                	xchg   %ax,%ax
  8010c8:	66 90                	xchg   %ax,%ax
  8010ca:	66 90                	xchg   %ax,%ax
  8010cc:	66 90                	xchg   %ax,%ax
  8010ce:	66 90                	xchg   %ax,%ax

008010d0 <__umoddi3>:
  8010d0:	f3 0f 1e fb          	endbr32 
  8010d4:	55                   	push   %ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 1c             	sub    $0x1c,%esp
  8010db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010e3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8010e7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  8010eb:	89 f0                	mov    %esi,%eax
  8010ed:	89 da                	mov    %ebx,%edx
  8010ef:	85 ff                	test   %edi,%edi
  8010f1:	75 15                	jne    801108 <__umoddi3+0x38>
  8010f3:	39 dd                	cmp    %ebx,%ebp
  8010f5:	76 39                	jbe    801130 <__umoddi3+0x60>
  8010f7:	f7 f5                	div    %ebp
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	31 d2                	xor    %edx,%edx
  8010fd:	83 c4 1c             	add    $0x1c,%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
  801105:	8d 76 00             	lea    0x0(%esi),%esi
  801108:	39 df                	cmp    %ebx,%edi
  80110a:	77 f1                	ja     8010fd <__umoddi3+0x2d>
  80110c:	0f bd cf             	bsr    %edi,%ecx
  80110f:	83 f1 1f             	xor    $0x1f,%ecx
  801112:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801116:	75 40                	jne    801158 <__umoddi3+0x88>
  801118:	39 df                	cmp    %ebx,%edi
  80111a:	72 04                	jb     801120 <__umoddi3+0x50>
  80111c:	39 f5                	cmp    %esi,%ebp
  80111e:	77 dd                	ja     8010fd <__umoddi3+0x2d>
  801120:	89 da                	mov    %ebx,%edx
  801122:	89 f0                	mov    %esi,%eax
  801124:	29 e8                	sub    %ebp,%eax
  801126:	19 fa                	sbb    %edi,%edx
  801128:	eb d3                	jmp    8010fd <__umoddi3+0x2d>
  80112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801130:	89 e9                	mov    %ebp,%ecx
  801132:	85 ed                	test   %ebp,%ebp
  801134:	75 0b                	jne    801141 <__umoddi3+0x71>
  801136:	b8 01 00 00 00       	mov    $0x1,%eax
  80113b:	31 d2                	xor    %edx,%edx
  80113d:	f7 f5                	div    %ebp
  80113f:	89 c1                	mov    %eax,%ecx
  801141:	89 d8                	mov    %ebx,%eax
  801143:	31 d2                	xor    %edx,%edx
  801145:	f7 f1                	div    %ecx
  801147:	89 f0                	mov    %esi,%eax
  801149:	f7 f1                	div    %ecx
  80114b:	89 d0                	mov    %edx,%eax
  80114d:	31 d2                	xor    %edx,%edx
  80114f:	eb ac                	jmp    8010fd <__umoddi3+0x2d>
  801151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801158:	8b 44 24 04          	mov    0x4(%esp),%eax
  80115c:	ba 20 00 00 00       	mov    $0x20,%edx
  801161:	29 c2                	sub    %eax,%edx
  801163:	89 c1                	mov    %eax,%ecx
  801165:	89 e8                	mov    %ebp,%eax
  801167:	d3 e7                	shl    %cl,%edi
  801169:	89 d1                	mov    %edx,%ecx
  80116b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80116f:	d3 e8                	shr    %cl,%eax
  801171:	89 c1                	mov    %eax,%ecx
  801173:	8b 44 24 04          	mov    0x4(%esp),%eax
  801177:	09 f9                	or     %edi,%ecx
  801179:	89 df                	mov    %ebx,%edi
  80117b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	d3 e5                	shl    %cl,%ebp
  801183:	89 d1                	mov    %edx,%ecx
  801185:	d3 ef                	shr    %cl,%edi
  801187:	89 c1                	mov    %eax,%ecx
  801189:	89 f0                	mov    %esi,%eax
  80118b:	d3 e3                	shl    %cl,%ebx
  80118d:	89 d1                	mov    %edx,%ecx
  80118f:	89 fa                	mov    %edi,%edx
  801191:	d3 e8                	shr    %cl,%eax
  801193:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801198:	09 d8                	or     %ebx,%eax
  80119a:	f7 74 24 08          	divl   0x8(%esp)
  80119e:	89 d3                	mov    %edx,%ebx
  8011a0:	d3 e6                	shl    %cl,%esi
  8011a2:	f7 e5                	mul    %ebp
  8011a4:	89 c7                	mov    %eax,%edi
  8011a6:	89 d1                	mov    %edx,%ecx
  8011a8:	39 d3                	cmp    %edx,%ebx
  8011aa:	72 06                	jb     8011b2 <__umoddi3+0xe2>
  8011ac:	75 0e                	jne    8011bc <__umoddi3+0xec>
  8011ae:	39 c6                	cmp    %eax,%esi
  8011b0:	73 0a                	jae    8011bc <__umoddi3+0xec>
  8011b2:	29 e8                	sub    %ebp,%eax
  8011b4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011b8:	89 d1                	mov    %edx,%ecx
  8011ba:	89 c7                	mov    %eax,%edi
  8011bc:	89 f5                	mov    %esi,%ebp
  8011be:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c2:	29 fd                	sub    %edi,%ebp
  8011c4:	19 cb                	sbb    %ecx,%ebx
  8011c6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	d3 e0                	shl    %cl,%eax
  8011cf:	89 f1                	mov    %esi,%ecx
  8011d1:	d3 ed                	shr    %cl,%ebp
  8011d3:	d3 eb                	shr    %cl,%ebx
  8011d5:	09 e8                	or     %ebp,%eax
  8011d7:	89 da                	mov    %ebx,%edx
  8011d9:	83 c4 1c             	add    $0x1c,%esp
  8011dc:	5b                   	pop    %ebx
  8011dd:	5e                   	pop    %esi
  8011de:	5f                   	pop    %edi
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    
