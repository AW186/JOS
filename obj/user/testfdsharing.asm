
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 60 23 80 00       	push   $0x802360
  800043:	e8 7a 19 00 00       	call   8019c2 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 11 16 00 00       	call   801671 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 00 42 80 00       	push   $0x804200
  80006d:	53                   	push   %ebx
  80006e:	e8 35 15 00 00       	call   8015a8 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 29 10 00 00       	call   8010ae <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 d5 15 00 00       	call   801671 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  8000a3:	e8 55 02 00 00       	call   8002fd <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 00 40 80 00       	push   $0x804000
  8000b5:	53                   	push   %ebx
  8000b6:	e8 ed 14 00 00       	call   8015a8 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 00 40 80 00       	push   $0x804000
  8000cf:	68 00 42 80 00       	push   $0x804200
  8000d4:	e8 f7 0a 00 00       	call   800bd0 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 92 23 80 00       	push   $0x802392
  8000ec:	e8 0c 02 00 00       	call   8002fd <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 75 15 00 00       	call   801671 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 e1 12 00 00       	call   8013e5 <close>
		exit();
  800104:	e8 07 01 00 00       	call   800210 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 9c 1c 00 00       	call   801db1 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 00 40 80 00       	push   $0x804000
  800122:	53                   	push   %ebx
  800123:	e8 80 14 00 00       	call   8015a8 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 ab 23 80 00       	push   $0x8023ab
  80013b:	e8 bd 01 00 00       	call   8002fd <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 9d 12 00 00       	call   8013e5 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 65 23 80 00       	push   $0x802365
  80015a:	6a 0c                	push   $0xc
  80015c:	68 73 23 80 00       	push   $0x802373
  800161:	e8 bc 00 00 00       	call   800222 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 88 23 80 00       	push   $0x802388
  80016c:	6a 0f                	push   $0xf
  80016e:	68 73 23 80 00       	push   $0x802373
  800173:	e8 aa 00 00 00       	call   800222 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 45 28 80 00       	push   $0x802845
  80017e:	6a 12                	push   $0x12
  800180:	68 73 23 80 00       	push   $0x802373
  800185:	e8 98 00 00 00       	call   800222 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 0c 24 80 00       	push   $0x80240c
  800194:	6a 17                	push   $0x17
  800196:	68 73 23 80 00       	push   $0x802373
  80019b:	e8 82 00 00 00       	call   800222 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 38 24 80 00       	push   $0x802438
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 73 23 80 00       	push   $0x802373
  8001af:	e8 6e 00 00 00       	call   800222 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 70 24 80 00       	push   $0x802470
  8001be:	6a 21                	push   $0x21
  8001c0:	68 73 23 80 00       	push   $0x802373
  8001c5:	e8 58 00 00 00       	call   800222 <_panic>

008001ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d5:	e8 a6 0b 00 00       	call   800d80 <sys_getenvid>
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e7:	a3 00 44 80 00       	mov    %eax,0x804400

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ec:	85 db                	test   %ebx,%ebx
  8001ee:	7e 07                	jle    8001f7 <libmain+0x2d>
		binaryname = argv[0];
  8001f0:	8b 06                	mov    (%esi),%eax
  8001f2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	e8 32 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800201:	e8 0a 00 00 00       	call   800210 <exit>
}
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5d                   	pop    %ebp
  80020f:	c3                   	ret    

00800210 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800216:	6a 00                	push   $0x0
  800218:	e8 22 0b 00 00       	call   800d3f <sys_env_destroy>
}
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800227:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800230:	e8 4b 0b 00 00       	call   800d80 <sys_getenvid>
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 0c             	push   0xc(%ebp)
  80023b:	ff 75 08             	push   0x8(%ebp)
  80023e:	56                   	push   %esi
  80023f:	50                   	push   %eax
  800240:	68 a0 24 80 00       	push   $0x8024a0
  800245:	e8 b3 00 00 00       	call   8002fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024a:	83 c4 18             	add    $0x18,%esp
  80024d:	53                   	push   %ebx
  80024e:	ff 75 10             	push   0x10(%ebp)
  800251:	e8 56 00 00 00       	call   8002ac <vcprintf>
	cprintf("\n");
  800256:	c7 04 24 0f 2a 80 00 	movl   $0x802a0f,(%esp)
  80025d:	e8 9b 00 00 00       	call   8002fd <cprintf>
  800262:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800265:	cc                   	int3   
  800266:	eb fd                	jmp    800265 <_panic+0x43>

00800268 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	53                   	push   %ebx
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800272:	8b 13                	mov    (%ebx),%edx
  800274:	8d 42 01             	lea    0x1(%edx),%eax
  800277:	89 03                	mov    %eax,(%ebx)
  800279:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800280:	3d ff 00 00 00       	cmp    $0xff,%eax
  800285:	74 09                	je     800290 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800287:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 ff 00 00 00       	push   $0xff
  800298:	8d 43 08             	lea    0x8(%ebx),%eax
  80029b:	50                   	push   %eax
  80029c:	e8 61 0a 00 00       	call   800d02 <sys_cputs>
		b->idx = 0;
  8002a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a7:	83 c4 10             	add    $0x10,%esp
  8002aa:	eb db                	jmp    800287 <putch+0x1f>

008002ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002bc:	00 00 00 
	b.cnt = 0;
  8002bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c9:	ff 75 0c             	push   0xc(%ebp)
  8002cc:	ff 75 08             	push   0x8(%ebp)
  8002cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d5:	50                   	push   %eax
  8002d6:	68 68 02 80 00       	push   $0x800268
  8002db:	e8 14 01 00 00       	call   8003f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e0:	83 c4 08             	add    $0x8,%esp
  8002e3:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8002e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ef:	50                   	push   %eax
  8002f0:	e8 0d 0a 00 00       	call   800d02 <sys_cputs>

	return b.cnt;
}
  8002f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800303:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800306:	50                   	push   %eax
  800307:	ff 75 08             	push   0x8(%ebp)
  80030a:	e8 9d ff ff ff       	call   8002ac <vcprintf>
	va_end(ap);

	return cnt;
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	57                   	push   %edi
  800315:	56                   	push   %esi
  800316:	53                   	push   %ebx
  800317:	83 ec 1c             	sub    $0x1c,%esp
  80031a:	89 c7                	mov    %eax,%edi
  80031c:	89 d6                	mov    %edx,%esi
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	8b 55 0c             	mov    0xc(%ebp),%edx
  800324:	89 d1                	mov    %edx,%ecx
  800326:	89 c2                	mov    %eax,%edx
  800328:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80032e:	8b 45 10             	mov    0x10(%ebp),%eax
  800331:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800334:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800337:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800343:	72 3e                	jb     800383 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	ff 75 18             	push   0x18(%ebp)
  80034b:	83 eb 01             	sub    $0x1,%ebx
  80034e:	53                   	push   %ebx
  80034f:	50                   	push   %eax
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	ff 75 e4             	push   -0x1c(%ebp)
  800356:	ff 75 e0             	push   -0x20(%ebp)
  800359:	ff 75 dc             	push   -0x24(%ebp)
  80035c:	ff 75 d8             	push   -0x28(%ebp)
  80035f:	e8 bc 1d 00 00       	call   802120 <__udivdi3>
  800364:	83 c4 18             	add    $0x18,%esp
  800367:	52                   	push   %edx
  800368:	50                   	push   %eax
  800369:	89 f2                	mov    %esi,%edx
  80036b:	89 f8                	mov    %edi,%eax
  80036d:	e8 9f ff ff ff       	call   800311 <printnum>
  800372:	83 c4 20             	add    $0x20,%esp
  800375:	eb 13                	jmp    80038a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	56                   	push   %esi
  80037b:	ff 75 18             	push   0x18(%ebp)
  80037e:	ff d7                	call   *%edi
  800380:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800383:	83 eb 01             	sub    $0x1,%ebx
  800386:	85 db                	test   %ebx,%ebx
  800388:	7f ed                	jg     800377 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	56                   	push   %esi
  80038e:	83 ec 04             	sub    $0x4,%esp
  800391:	ff 75 e4             	push   -0x1c(%ebp)
  800394:	ff 75 e0             	push   -0x20(%ebp)
  800397:	ff 75 dc             	push   -0x24(%ebp)
  80039a:	ff 75 d8             	push   -0x28(%ebp)
  80039d:	e8 9e 1e 00 00       	call   802240 <__umoddi3>
  8003a2:	83 c4 14             	add    $0x14,%esp
  8003a5:	0f be 80 c3 24 80 00 	movsbl 0x8024c3(%eax),%eax
  8003ac:	50                   	push   %eax
  8003ad:	ff d7                	call   *%edi
}
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b5:	5b                   	pop    %ebx
  8003b6:	5e                   	pop    %esi
  8003b7:	5f                   	pop    %edi
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c4:	8b 10                	mov    (%eax),%edx
  8003c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c9:	73 0a                	jae    8003d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ce:	89 08                	mov    %ecx,(%eax)
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	88 02                	mov    %al,(%edx)
}
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    

008003d7 <printfmt>:
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e0:	50                   	push   %eax
  8003e1:	ff 75 10             	push   0x10(%ebp)
  8003e4:	ff 75 0c             	push   0xc(%ebp)
  8003e7:	ff 75 08             	push   0x8(%ebp)
  8003ea:	e8 05 00 00 00       	call   8003f4 <vprintfmt>
}
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <vprintfmt>:
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 3c             	sub    $0x3c,%esp
  8003fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800403:	8b 7d 10             	mov    0x10(%ebp),%edi
  800406:	eb 0a                	jmp    800412 <vprintfmt+0x1e>
			putch(ch, putdat);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	53                   	push   %ebx
  80040c:	50                   	push   %eax
  80040d:	ff d6                	call   *%esi
  80040f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800412:	83 c7 01             	add    $0x1,%edi
  800415:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800419:	83 f8 25             	cmp    $0x25,%eax
  80041c:	74 0c                	je     80042a <vprintfmt+0x36>
			if (ch == '\0')
  80041e:	85 c0                	test   %eax,%eax
  800420:	75 e6                	jne    800408 <vprintfmt+0x14>
}
  800422:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800425:	5b                   	pop    %ebx
  800426:	5e                   	pop    %esi
  800427:	5f                   	pop    %edi
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    
		padc = ' ';
  80042a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80042e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80043c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800443:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800448:	8d 47 01             	lea    0x1(%edi),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	0f b6 17             	movzbl (%edi),%edx
  800451:	8d 42 dd             	lea    -0x23(%edx),%eax
  800454:	3c 55                	cmp    $0x55,%al
  800456:	0f 87 a6 04 00 00    	ja     800902 <vprintfmt+0x50e>
  80045c:	0f b6 c0             	movzbl %al,%eax
  80045f:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  800466:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800469:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80046d:	eb d9                	jmp    800448 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800472:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800476:	eb d0                	jmp    800448 <vprintfmt+0x54>
  800478:	0f b6 d2             	movzbl %dl,%edx
  80047b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800486:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800489:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80048d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800490:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800493:	83 f9 09             	cmp    $0x9,%ecx
  800496:	77 55                	ja     8004ed <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800498:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80049b:	eb e9                	jmp    800486 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a8:	8d 40 04             	lea    0x4(%eax),%eax
  8004ab:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8004b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b5:	79 91                	jns    800448 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004c4:	eb 82                	jmp    800448 <vprintfmt+0x54>
  8004c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c9:	85 d2                	test   %edx,%edx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c2             	cmovns %edx,%eax
  8004d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004d9:	e9 6a ff ff ff       	jmp    800448 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004de:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8004e1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e8:	e9 5b ff ff ff       	jmp    800448 <vprintfmt+0x54>
  8004ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	eb bc                	jmp    8004b1 <vprintfmt+0xbd>
			lflag++;
  8004f5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004fb:	e9 48 ff ff ff       	jmp    800448 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	8d 78 04             	lea    0x4(%eax),%edi
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	53                   	push   %ebx
  80050a:	ff 30                	push   (%eax)
  80050c:	ff d6                	call   *%esi
			break;
  80050e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800511:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800514:	e9 88 03 00 00       	jmp    8008a1 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 78 04             	lea    0x4(%eax),%edi
  80051f:	8b 10                	mov    (%eax),%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	f7 d8                	neg    %eax
  800525:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800528:	83 f8 0f             	cmp    $0xf,%eax
  80052b:	7f 23                	jg     800550 <vprintfmt+0x15c>
  80052d:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  800534:	85 d2                	test   %edx,%edx
  800536:	74 18                	je     800550 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800538:	52                   	push   %edx
  800539:	68 35 29 80 00       	push   $0x802935
  80053e:	53                   	push   %ebx
  80053f:	56                   	push   %esi
  800540:	e8 92 fe ff ff       	call   8003d7 <printfmt>
  800545:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800548:	89 7d 14             	mov    %edi,0x14(%ebp)
  80054b:	e9 51 03 00 00       	jmp    8008a1 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800550:	50                   	push   %eax
  800551:	68 db 24 80 00       	push   $0x8024db
  800556:	53                   	push   %ebx
  800557:	56                   	push   %esi
  800558:	e8 7a fe ff ff       	call   8003d7 <printfmt>
  80055d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800560:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800563:	e9 39 03 00 00       	jmp    8008a1 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800576:	85 d2                	test   %edx,%edx
  800578:	b8 d4 24 80 00       	mov    $0x8024d4,%eax
  80057d:	0f 45 c2             	cmovne %edx,%eax
  800580:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800583:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800587:	7e 06                	jle    80058f <vprintfmt+0x19b>
  800589:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80058d:	75 0d                	jne    80059c <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800592:	89 c7                	mov    %eax,%edi
  800594:	03 45 d4             	add    -0x2c(%ebp),%eax
  800597:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059a:	eb 55                	jmp    8005f1 <vprintfmt+0x1fd>
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	ff 75 e0             	push   -0x20(%ebp)
  8005a2:	ff 75 cc             	push   -0x34(%ebp)
  8005a5:	e8 f5 03 00 00       	call   80099f <strnlen>
  8005aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ad:	29 c2                	sub    %eax,%edx
  8005af:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005b7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005be:	eb 0f                	jmp    8005cf <vprintfmt+0x1db>
					putch(padc, putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	ff 75 d4             	push   -0x2c(%ebp)
  8005c7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c9:	83 ef 01             	sub    $0x1,%edi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	85 ff                	test   %edi,%edi
  8005d1:	7f ed                	jg     8005c0 <vprintfmt+0x1cc>
  8005d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005d6:	85 d2                	test   %edx,%edx
  8005d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005dd:	0f 49 c2             	cmovns %edx,%eax
  8005e0:	29 c2                	sub    %eax,%edx
  8005e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e5:	eb a8                	jmp    80058f <vprintfmt+0x19b>
					putch(ch, putdat);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	52                   	push   %edx
  8005ec:	ff d6                	call   *%esi
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005f4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f6:	83 c7 01             	add    $0x1,%edi
  8005f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fd:	0f be d0             	movsbl %al,%edx
  800600:	85 d2                	test   %edx,%edx
  800602:	74 4b                	je     80064f <vprintfmt+0x25b>
  800604:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800608:	78 06                	js     800610 <vprintfmt+0x21c>
  80060a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80060e:	78 1e                	js     80062e <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800610:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800614:	74 d1                	je     8005e7 <vprintfmt+0x1f3>
  800616:	0f be c0             	movsbl %al,%eax
  800619:	83 e8 20             	sub    $0x20,%eax
  80061c:	83 f8 5e             	cmp    $0x5e,%eax
  80061f:	76 c6                	jbe    8005e7 <vprintfmt+0x1f3>
					putch('?', putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	53                   	push   %ebx
  800625:	6a 3f                	push   $0x3f
  800627:	ff d6                	call   *%esi
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	eb c3                	jmp    8005f1 <vprintfmt+0x1fd>
  80062e:	89 cf                	mov    %ecx,%edi
  800630:	eb 0e                	jmp    800640 <vprintfmt+0x24c>
				putch(' ', putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	53                   	push   %ebx
  800636:	6a 20                	push   $0x20
  800638:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063a:	83 ef 01             	sub    $0x1,%edi
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	85 ff                	test   %edi,%edi
  800642:	7f ee                	jg     800632 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800644:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	e9 52 02 00 00       	jmp    8008a1 <vprintfmt+0x4ad>
  80064f:	89 cf                	mov    %ecx,%edi
  800651:	eb ed                	jmp    800640 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 c0 04             	add    $0x4,%eax
  800659:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800661:	85 d2                	test   %edx,%edx
  800663:	b8 d4 24 80 00       	mov    $0x8024d4,%eax
  800668:	0f 45 c2             	cmovne %edx,%eax
  80066b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80066e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800672:	7e 06                	jle    80067a <vprintfmt+0x286>
  800674:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800678:	75 0d                	jne    800687 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067d:	89 c7                	mov    %eax,%edi
  80067f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800682:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800685:	eb 55                	jmp    8006dc <vprintfmt+0x2e8>
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	ff 75 e0             	push   -0x20(%ebp)
  80068d:	ff 75 cc             	push   -0x34(%ebp)
  800690:	e8 0a 03 00 00       	call   80099f <strnlen>
  800695:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800698:	29 c2                	sub    %eax,%edx
  80069a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006a2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a9:	eb 0f                	jmp    8006ba <vprintfmt+0x2c6>
					putch(padc, putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	ff 75 d4             	push   -0x2c(%ebp)
  8006b2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	83 ef 01             	sub    $0x1,%edi
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	85 ff                	test   %edi,%edi
  8006bc:	7f ed                	jg     8006ab <vprintfmt+0x2b7>
  8006be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006c1:	85 d2                	test   %edx,%edx
  8006c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c8:	0f 49 c2             	cmovns %edx,%eax
  8006cb:	29 c2                	sub    %eax,%edx
  8006cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006d0:	eb a8                	jmp    80067a <vprintfmt+0x286>
					putch(ch, putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	52                   	push   %edx
  8006d7:	ff d6                	call   *%esi
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006df:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8006e1:	83 c7 01             	add    $0x1,%edi
  8006e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e8:	0f be d0             	movsbl %al,%edx
  8006eb:	3c 3a                	cmp    $0x3a,%al
  8006ed:	74 4b                	je     80073a <vprintfmt+0x346>
  8006ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f3:	78 06                	js     8006fb <vprintfmt+0x307>
  8006f5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8006f9:	78 1e                	js     800719 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ff:	74 d1                	je     8006d2 <vprintfmt+0x2de>
  800701:	0f be c0             	movsbl %al,%eax
  800704:	83 e8 20             	sub    $0x20,%eax
  800707:	83 f8 5e             	cmp    $0x5e,%eax
  80070a:	76 c6                	jbe    8006d2 <vprintfmt+0x2de>
					putch('?', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 3f                	push   $0x3f
  800712:	ff d6                	call   *%esi
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	eb c3                	jmp    8006dc <vprintfmt+0x2e8>
  800719:	89 cf                	mov    %ecx,%edi
  80071b:	eb 0e                	jmp    80072b <vprintfmt+0x337>
				putch(' ', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 20                	push   $0x20
  800723:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800725:	83 ef 01             	sub    $0x1,%edi
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	85 ff                	test   %edi,%edi
  80072d:	7f ee                	jg     80071d <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80072f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	e9 67 01 00 00       	jmp    8008a1 <vprintfmt+0x4ad>
  80073a:	89 cf                	mov    %ecx,%edi
  80073c:	eb ed                	jmp    80072b <vprintfmt+0x337>
	if (lflag >= 2)
  80073e:	83 f9 01             	cmp    $0x1,%ecx
  800741:	7f 1b                	jg     80075e <vprintfmt+0x36a>
	else if (lflag)
  800743:	85 c9                	test   %ecx,%ecx
  800745:	74 63                	je     8007aa <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80074f:	99                   	cltd   
  800750:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
  80075c:	eb 17                	jmp    800775 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 50 04             	mov    0x4(%eax),%edx
  800764:	8b 00                	mov    (%eax),%eax
  800766:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800769:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 08             	lea    0x8(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800775:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800778:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80077b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800780:	85 c9                	test   %ecx,%ecx
  800782:	0f 89 ff 00 00 00    	jns    800887 <vprintfmt+0x493>
				putch('-', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 2d                	push   $0x2d
  80078e:	ff d6                	call   *%esi
				num = -(long long) num;
  800790:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800793:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800796:	f7 da                	neg    %edx
  800798:	83 d1 00             	adc    $0x0,%ecx
  80079b:	f7 d9                	neg    %ecx
  80079d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007a5:	e9 dd 00 00 00       	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b2:	99                   	cltd   
  8007b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bf:	eb b4                	jmp    800775 <vprintfmt+0x381>
	if (lflag >= 2)
  8007c1:	83 f9 01             	cmp    $0x1,%ecx
  8007c4:	7f 1e                	jg     8007e4 <vprintfmt+0x3f0>
	else if (lflag)
  8007c6:	85 c9                	test   %ecx,%ecx
  8007c8:	74 32                	je     8007fc <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 10                	mov    (%eax),%edx
  8007cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007da:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8007df:	e9 a3 00 00 00       	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ec:	8d 40 08             	lea    0x8(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f2:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8007f7:	e9 8b 00 00 00       	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800811:	eb 74                	jmp    800887 <vprintfmt+0x493>
	if (lflag >= 2)
  800813:	83 f9 01             	cmp    $0x1,%ecx
  800816:	7f 1b                	jg     800833 <vprintfmt+0x43f>
	else if (lflag)
  800818:	85 c9                	test   %ecx,%ecx
  80081a:	74 2c                	je     800848 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	b9 00 00 00 00       	mov    $0x0,%ecx
  800826:	8d 40 04             	lea    0x4(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800831:	eb 54                	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	8b 48 04             	mov    0x4(%eax),%ecx
  80083b:	8d 40 08             	lea    0x8(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800841:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800846:	eb 3f                	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 10                	mov    (%eax),%edx
  80084d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800858:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80085d:	eb 28                	jmp    800887 <vprintfmt+0x493>
			putch('0', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 30                	push   $0x30
  800865:	ff d6                	call   *%esi
			putch('x', putdat);
  800867:	83 c4 08             	add    $0x8,%esp
  80086a:	53                   	push   %ebx
  80086b:	6a 78                	push   $0x78
  80086d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 10                	mov    (%eax),%edx
  800874:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800879:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80087c:	8d 40 04             	lea    0x4(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800882:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80088e:	50                   	push   %eax
  80088f:	ff 75 d4             	push   -0x2c(%ebp)
  800892:	57                   	push   %edi
  800893:	51                   	push   %ecx
  800894:	52                   	push   %edx
  800895:	89 da                	mov    %ebx,%edx
  800897:	89 f0                	mov    %esi,%eax
  800899:	e8 73 fa ff ff       	call   800311 <printnum>
			break;
  80089e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a1:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a4:	e9 69 fb ff ff       	jmp    800412 <vprintfmt+0x1e>
	if (lflag >= 2)
  8008a9:	83 f9 01             	cmp    $0x1,%ecx
  8008ac:	7f 1b                	jg     8008c9 <vprintfmt+0x4d5>
	else if (lflag)
  8008ae:	85 c9                	test   %ecx,%ecx
  8008b0:	74 2c                	je     8008de <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 10                	mov    (%eax),%edx
  8008b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c2:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8008c7:	eb be                	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 10                	mov    (%eax),%edx
  8008ce:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d1:	8d 40 08             	lea    0x8(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d7:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8008dc:	eb a9                	jmp    800887 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8b 10                	mov    (%eax),%edx
  8008e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008e8:	8d 40 04             	lea    0x4(%eax),%eax
  8008eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ee:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8008f3:	eb 92                	jmp    800887 <vprintfmt+0x493>
			putch(ch, putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	53                   	push   %ebx
  8008f9:	6a 25                	push   $0x25
  8008fb:	ff d6                	call   *%esi
			break;
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb 9f                	jmp    8008a1 <vprintfmt+0x4ad>
			putch('%', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	53                   	push   %ebx
  800906:	6a 25                	push   $0x25
  800908:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	89 f8                	mov    %edi,%eax
  80090f:	eb 03                	jmp    800914 <vprintfmt+0x520>
  800911:	83 e8 01             	sub    $0x1,%eax
  800914:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800918:	75 f7                	jne    800911 <vprintfmt+0x51d>
  80091a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80091d:	eb 82                	jmp    8008a1 <vprintfmt+0x4ad>

0080091f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800932:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800935:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093c:	85 c0                	test   %eax,%eax
  80093e:	74 26                	je     800966 <vsnprintf+0x47>
  800940:	85 d2                	test   %edx,%edx
  800942:	7e 22                	jle    800966 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800944:	ff 75 14             	push   0x14(%ebp)
  800947:	ff 75 10             	push   0x10(%ebp)
  80094a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094d:	50                   	push   %eax
  80094e:	68 ba 03 80 00       	push   $0x8003ba
  800953:	e8 9c fa ff ff       	call   8003f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800961:	83 c4 10             	add    $0x10,%esp
}
  800964:	c9                   	leave  
  800965:	c3                   	ret    
		return -E_INVAL;
  800966:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096b:	eb f7                	jmp    800964 <vsnprintf+0x45>

0080096d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800973:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800976:	50                   	push   %eax
  800977:	ff 75 10             	push   0x10(%ebp)
  80097a:	ff 75 0c             	push   0xc(%ebp)
  80097d:	ff 75 08             	push   0x8(%ebp)
  800980:	e8 9a ff ff ff       	call   80091f <vsnprintf>
	va_end(ap);

	return rc;
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098d:	b8 00 00 00 00       	mov    $0x0,%eax
  800992:	eb 03                	jmp    800997 <strlen+0x10>
		n++;
  800994:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800997:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80099b:	75 f7                	jne    800994 <strlen+0xd>
	return n;
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	eb 03                	jmp    8009b2 <strnlen+0x13>
		n++;
  8009af:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b2:	39 d0                	cmp    %edx,%eax
  8009b4:	74 08                	je     8009be <strnlen+0x1f>
  8009b6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009ba:	75 f3                	jne    8009af <strnlen+0x10>
  8009bc:	89 c2                	mov    %eax,%edx
	return n;
}
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009d5:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009d8:	83 c0 01             	add    $0x1,%eax
  8009db:	84 d2                	test   %dl,%dl
  8009dd:	75 f2                	jne    8009d1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009df:	89 c8                	mov    %ecx,%eax
  8009e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 10             	sub    $0x10,%esp
  8009ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f0:	53                   	push   %ebx
  8009f1:	e8 91 ff ff ff       	call   800987 <strlen>
  8009f6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f9:	ff 75 0c             	push   0xc(%ebp)
  8009fc:	01 d8                	add    %ebx,%eax
  8009fe:	50                   	push   %eax
  8009ff:	e8 be ff ff ff       	call   8009c2 <strcpy>
	return dst;
}
  800a04:	89 d8                	mov    %ebx,%eax
  800a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
  800a10:	8b 75 08             	mov    0x8(%ebp),%esi
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a16:	89 f3                	mov    %esi,%ebx
  800a18:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1b:	89 f0                	mov    %esi,%eax
  800a1d:	eb 0f                	jmp    800a2e <strncpy+0x23>
		*dst++ = *src;
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	0f b6 0a             	movzbl (%edx),%ecx
  800a25:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a28:	80 f9 01             	cmp    $0x1,%cl
  800a2b:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800a2e:	39 d8                	cmp    %ebx,%eax
  800a30:	75 ed                	jne    800a1f <strncpy+0x14>
	}
	return ret;
}
  800a32:	89 f0                	mov    %esi,%eax
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a43:	8b 55 10             	mov    0x10(%ebp),%edx
  800a46:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a48:	85 d2                	test   %edx,%edx
  800a4a:	74 21                	je     800a6d <strlcpy+0x35>
  800a4c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a50:	89 f2                	mov    %esi,%edx
  800a52:	eb 09                	jmp    800a5d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a54:	83 c1 01             	add    $0x1,%ecx
  800a57:	83 c2 01             	add    $0x1,%edx
  800a5a:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a5d:	39 c2                	cmp    %eax,%edx
  800a5f:	74 09                	je     800a6a <strlcpy+0x32>
  800a61:	0f b6 19             	movzbl (%ecx),%ebx
  800a64:	84 db                	test   %bl,%bl
  800a66:	75 ec                	jne    800a54 <strlcpy+0x1c>
  800a68:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a6a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6d:	29 f0                	sub    %esi,%eax
}
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7c:	eb 06                	jmp    800a84 <strcmp+0x11>
		p++, q++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
  800a81:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a84:	0f b6 01             	movzbl (%ecx),%eax
  800a87:	84 c0                	test   %al,%al
  800a89:	74 04                	je     800a8f <strcmp+0x1c>
  800a8b:	3a 02                	cmp    (%edx),%al
  800a8d:	74 ef                	je     800a7e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8f:	0f b6 c0             	movzbl %al,%eax
  800a92:	0f b6 12             	movzbl (%edx),%edx
  800a95:	29 d0                	sub    %edx,%eax
}
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	89 c3                	mov    %eax,%ebx
  800aa5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa8:	eb 06                	jmp    800ab0 <strncmp+0x17>
		n--, p++, q++;
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ab0:	39 d8                	cmp    %ebx,%eax
  800ab2:	74 18                	je     800acc <strncmp+0x33>
  800ab4:	0f b6 08             	movzbl (%eax),%ecx
  800ab7:	84 c9                	test   %cl,%cl
  800ab9:	74 04                	je     800abf <strncmp+0x26>
  800abb:	3a 0a                	cmp    (%edx),%cl
  800abd:	74 eb                	je     800aaa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abf:	0f b6 00             	movzbl (%eax),%eax
  800ac2:	0f b6 12             	movzbl (%edx),%edx
  800ac5:	29 d0                	sub    %edx,%eax
}
  800ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    
		return 0;
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	eb f4                	jmp    800ac7 <strncmp+0x2e>

00800ad3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800add:	eb 03                	jmp    800ae2 <strchr+0xf>
  800adf:	83 c0 01             	add    $0x1,%eax
  800ae2:	0f b6 10             	movzbl (%eax),%edx
  800ae5:	84 d2                	test   %dl,%dl
  800ae7:	74 06                	je     800aef <strchr+0x1c>
		if (*s == c)
  800ae9:	38 ca                	cmp    %cl,%dl
  800aeb:	75 f2                	jne    800adf <strchr+0xc>
  800aed:	eb 05                	jmp    800af4 <strchr+0x21>
			return (char *) s;
	return 0;
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b00:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b03:	38 ca                	cmp    %cl,%dl
  800b05:	74 09                	je     800b10 <strfind+0x1a>
  800b07:	84 d2                	test   %dl,%dl
  800b09:	74 05                	je     800b10 <strfind+0x1a>
	for (; *s; s++)
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	eb f0                	jmp    800b00 <strfind+0xa>
			break;
	return (char *) s;
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
  800b18:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b1e:	85 c9                	test   %ecx,%ecx
  800b20:	74 2f                	je     800b51 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b22:	89 f8                	mov    %edi,%eax
  800b24:	09 c8                	or     %ecx,%eax
  800b26:	a8 03                	test   $0x3,%al
  800b28:	75 21                	jne    800b4b <memset+0x39>
		c &= 0xFF;
  800b2a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b2e:	89 d0                	mov    %edx,%eax
  800b30:	c1 e0 08             	shl    $0x8,%eax
  800b33:	89 d3                	mov    %edx,%ebx
  800b35:	c1 e3 18             	shl    $0x18,%ebx
  800b38:	89 d6                	mov    %edx,%esi
  800b3a:	c1 e6 10             	shl    $0x10,%esi
  800b3d:	09 f3                	or     %esi,%ebx
  800b3f:	09 da                	or     %ebx,%edx
  800b41:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b43:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b46:	fc                   	cld    
  800b47:	f3 ab                	rep stos %eax,%es:(%edi)
  800b49:	eb 06                	jmp    800b51 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	fc                   	cld    
  800b4f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b51:	89 f8                	mov    %edi,%eax
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b66:	39 c6                	cmp    %eax,%esi
  800b68:	73 32                	jae    800b9c <memmove+0x44>
  800b6a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b6d:	39 c2                	cmp    %eax,%edx
  800b6f:	76 2b                	jbe    800b9c <memmove+0x44>
		s += n;
		d += n;
  800b71:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b74:	89 d6                	mov    %edx,%esi
  800b76:	09 fe                	or     %edi,%esi
  800b78:	09 ce                	or     %ecx,%esi
  800b7a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b80:	75 0e                	jne    800b90 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b82:	83 ef 04             	sub    $0x4,%edi
  800b85:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b8b:	fd                   	std    
  800b8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b8e:	eb 09                	jmp    800b99 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b90:	83 ef 01             	sub    $0x1,%edi
  800b93:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b96:	fd                   	std    
  800b97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b99:	fc                   	cld    
  800b9a:	eb 1a                	jmp    800bb6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9c:	89 f2                	mov    %esi,%edx
  800b9e:	09 c2                	or     %eax,%edx
  800ba0:	09 ca                	or     %ecx,%edx
  800ba2:	f6 c2 03             	test   $0x3,%dl
  800ba5:	75 0a                	jne    800bb1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800baa:	89 c7                	mov    %eax,%edi
  800bac:	fc                   	cld    
  800bad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800baf:	eb 05                	jmp    800bb6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bb1:	89 c7                	mov    %eax,%edi
  800bb3:	fc                   	cld    
  800bb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc0:	ff 75 10             	push   0x10(%ebp)
  800bc3:	ff 75 0c             	push   0xc(%ebp)
  800bc6:	ff 75 08             	push   0x8(%ebp)
  800bc9:	e8 8a ff ff ff       	call   800b58 <memmove>
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be0:	eb 06                	jmp    800be8 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be2:	83 c0 01             	add    $0x1,%eax
  800be5:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800be8:	39 f0                	cmp    %esi,%eax
  800bea:	74 14                	je     800c00 <memcmp+0x30>
		if (*s1 != *s2)
  800bec:	0f b6 08             	movzbl (%eax),%ecx
  800bef:	0f b6 1a             	movzbl (%edx),%ebx
  800bf2:	38 d9                	cmp    %bl,%cl
  800bf4:	74 ec                	je     800be2 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800bf6:	0f b6 c1             	movzbl %cl,%eax
  800bf9:	0f b6 db             	movzbl %bl,%ebx
  800bfc:	29 d8                	sub    %ebx,%eax
  800bfe:	eb 05                	jmp    800c05 <memcmp+0x35>
	}

	return 0;
  800c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c17:	eb 03                	jmp    800c1c <memfind+0x13>
  800c19:	83 c0 01             	add    $0x1,%eax
  800c1c:	39 d0                	cmp    %edx,%eax
  800c1e:	73 04                	jae    800c24 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c20:	38 08                	cmp    %cl,(%eax)
  800c22:	75 f5                	jne    800c19 <memfind+0x10>
			break;
	return (void *) s;
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c32:	eb 03                	jmp    800c37 <strtol+0x11>
		s++;
  800c34:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800c37:	0f b6 02             	movzbl (%edx),%eax
  800c3a:	3c 20                	cmp    $0x20,%al
  800c3c:	74 f6                	je     800c34 <strtol+0xe>
  800c3e:	3c 09                	cmp    $0x9,%al
  800c40:	74 f2                	je     800c34 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c42:	3c 2b                	cmp    $0x2b,%al
  800c44:	74 2a                	je     800c70 <strtol+0x4a>
	int neg = 0;
  800c46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4b:	3c 2d                	cmp    $0x2d,%al
  800c4d:	74 2b                	je     800c7a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c55:	75 0f                	jne    800c66 <strtol+0x40>
  800c57:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5a:	74 28                	je     800c84 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c5c:	85 db                	test   %ebx,%ebx
  800c5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c63:	0f 44 d8             	cmove  %eax,%ebx
  800c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c6e:	eb 46                	jmp    800cb6 <strtol+0x90>
		s++;
  800c70:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c73:	bf 00 00 00 00       	mov    $0x0,%edi
  800c78:	eb d5                	jmp    800c4f <strtol+0x29>
		s++, neg = 1;
  800c7a:	83 c2 01             	add    $0x1,%edx
  800c7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800c82:	eb cb                	jmp    800c4f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c84:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c88:	74 0e                	je     800c98 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c8a:	85 db                	test   %ebx,%ebx
  800c8c:	75 d8                	jne    800c66 <strtol+0x40>
		s++, base = 8;
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c96:	eb ce                	jmp    800c66 <strtol+0x40>
		s += 2, base = 16;
  800c98:	83 c2 02             	add    $0x2,%edx
  800c9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca0:	eb c4                	jmp    800c66 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca2:	0f be c0             	movsbl %al,%eax
  800ca5:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cab:	7d 3a                	jge    800ce7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cad:	83 c2 01             	add    $0x1,%edx
  800cb0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800cb4:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800cb6:	0f b6 02             	movzbl (%edx),%eax
  800cb9:	8d 70 d0             	lea    -0x30(%eax),%esi
  800cbc:	89 f3                	mov    %esi,%ebx
  800cbe:	80 fb 09             	cmp    $0x9,%bl
  800cc1:	76 df                	jbe    800ca2 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800cc3:	8d 70 9f             	lea    -0x61(%eax),%esi
  800cc6:	89 f3                	mov    %esi,%ebx
  800cc8:	80 fb 19             	cmp    $0x19,%bl
  800ccb:	77 08                	ja     800cd5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ccd:	0f be c0             	movsbl %al,%eax
  800cd0:	83 e8 57             	sub    $0x57,%eax
  800cd3:	eb d3                	jmp    800ca8 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800cd5:	8d 70 bf             	lea    -0x41(%eax),%esi
  800cd8:	89 f3                	mov    %esi,%ebx
  800cda:	80 fb 19             	cmp    $0x19,%bl
  800cdd:	77 08                	ja     800ce7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cdf:	0f be c0             	movsbl %al,%eax
  800ce2:	83 e8 37             	sub    $0x37,%eax
  800ce5:	eb c1                	jmp    800ca8 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ceb:	74 05                	je     800cf2 <strtol+0xcc>
		*endptr = (char *) s;
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cf2:	89 c8                	mov    %ecx,%eax
  800cf4:	f7 d8                	neg    %eax
  800cf6:	85 ff                	test   %edi,%edi
  800cf8:	0f 45 c8             	cmovne %eax,%ecx
}
  800cfb:	89 c8                	mov    %ecx,%eax
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	89 c3                	mov    %eax,%ebx
  800d15:	89 c7                	mov    %eax,%edi
  800d17:	89 c6                	mov    %eax,%esi
  800d19:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d26:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2b:	b8 01 00 00 00       	mov    $0x1,%eax
  800d30:	89 d1                	mov    %edx,%ecx
  800d32:	89 d3                	mov    %edx,%ebx
  800d34:	89 d7                	mov    %edx,%edi
  800d36:	89 d6                	mov    %edx,%esi
  800d38:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	b8 03 00 00 00       	mov    $0x3,%eax
  800d55:	89 cb                	mov    %ecx,%ebx
  800d57:	89 cf                	mov    %ecx,%edi
  800d59:	89 ce                	mov    %ecx,%esi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 03                	push   $0x3
  800d6f:	68 bf 27 80 00       	push   $0x8027bf
  800d74:	6a 23                	push   $0x23
  800d76:	68 dc 27 80 00       	push   $0x8027dc
  800d7b:	e8 a2 f4 ff ff       	call   800222 <_panic>

00800d80 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d86:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d90:	89 d1                	mov    %edx,%ecx
  800d92:	89 d3                	mov    %edx,%ebx
  800d94:	89 d7                	mov    %edx,%edi
  800d96:	89 d6                	mov    %edx,%esi
  800d98:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <sys_yield>:

void
sys_yield(void)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da5:	ba 00 00 00 00       	mov    $0x0,%edx
  800daa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800daf:	89 d1                	mov    %edx,%ecx
  800db1:	89 d3                	mov    %edx,%ebx
  800db3:	89 d7                	mov    %edx,%edi
  800db5:	89 d6                	mov    %edx,%esi
  800db7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
  800dc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc7:	be 00 00 00 00       	mov    $0x0,%esi
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dda:	89 f7                	mov    %esi,%edi
  800ddc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7f 08                	jg     800dea <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	50                   	push   %eax
  800dee:	6a 04                	push   $0x4
  800df0:	68 bf 27 80 00       	push   $0x8027bf
  800df5:	6a 23                	push   $0x23
  800df7:	68 dc 27 80 00       	push   $0x8027dc
  800dfc:	e8 21 f4 ff ff       	call   800222 <_panic>

00800e01 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 05 00 00 00       	mov    $0x5,%eax
  800e15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1b:	8b 75 18             	mov    0x18(%ebp),%esi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 05                	push   $0x5
  800e32:	68 bf 27 80 00       	push   $0x8027bf
  800e37:	6a 23                	push   $0x23
  800e39:	68 dc 27 80 00       	push   $0x8027dc
  800e3e:	e8 df f3 ff ff       	call   800222 <_panic>

00800e43 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e57:	b8 06 00 00 00       	mov    $0x6,%eax
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7f 08                	jg     800e6e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	50                   	push   %eax
  800e72:	6a 06                	push   $0x6
  800e74:	68 bf 27 80 00       	push   $0x8027bf
  800e79:	6a 23                	push   $0x23
  800e7b:	68 dc 27 80 00       	push   $0x8027dc
  800e80:	e8 9d f3 ff ff       	call   800222 <_panic>

00800e85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 08 00 00 00       	mov    $0x8,%eax
  800e9e:	89 df                	mov    %ebx,%edi
  800ea0:	89 de                	mov    %ebx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 08                	push   $0x8
  800eb6:	68 bf 27 80 00       	push   $0x8027bf
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 dc 27 80 00       	push   $0x8027dc
  800ec2:	e8 5b f3 ff ff       	call   800222 <_panic>

00800ec7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edb:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee0:	89 df                	mov    %ebx,%edi
  800ee2:	89 de                	mov    %ebx,%esi
  800ee4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 09                	push   $0x9
  800ef8:	68 bf 27 80 00       	push   $0x8027bf
  800efd:	6a 23                	push   $0x23
  800eff:	68 dc 27 80 00       	push   $0x8027dc
  800f04:	e8 19 f3 ff ff       	call   800222 <_panic>

00800f09 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 0a                	push   $0xa
  800f3a:	68 bf 27 80 00       	push   $0x8027bf
  800f3f:	6a 23                	push   $0x23
  800f41:	68 dc 27 80 00       	push   $0x8027dc
  800f46:	e8 d7 f2 ff ff       	call   800222 <_panic>

00800f4b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f67:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f77:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f84:	89 cb                	mov    %ecx,%ebx
  800f86:	89 cf                	mov    %ecx,%edi
  800f88:	89 ce                	mov    %ecx,%esi
  800f8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	7f 08                	jg     800f98 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	6a 0d                	push   $0xd
  800f9e:	68 bf 27 80 00       	push   $0x8027bf
  800fa3:	6a 23                	push   $0x23
  800fa5:	68 dc 27 80 00       	push   $0x8027dc
  800faa:	e8 73 f2 ff ff       	call   800222 <_panic>

00800faf <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fb9:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800fbb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fbf:	0f 84 99 00 00 00    	je     80105e <pgfault+0xaf>
  800fc5:	89 d8                	mov    %ebx,%eax
  800fc7:	c1 e8 16             	shr    $0x16,%eax
  800fca:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd1:	a8 01                	test   $0x1,%al
  800fd3:	0f 84 85 00 00 00    	je     80105e <pgfault+0xaf>
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	c1 e8 0c             	shr    $0xc,%eax
  800fde:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fe5:	f6 c6 08             	test   $0x8,%dh
  800fe8:	74 74                	je     80105e <pgfault+0xaf>
  800fea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff1:	a8 01                	test   $0x1,%al
  800ff3:	74 69                	je     80105e <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	6a 07                	push   $0x7
  800ffa:	68 00 f0 7f 00       	push   $0x7ff000
  800fff:	6a 00                	push   $0x0
  801001:	e8 b8 fd ff ff       	call   800dbe <sys_page_alloc>
  801006:	83 c4 10             	add    $0x10,%esp
  801009:	85 c0                	test   %eax,%eax
  80100b:	78 65                	js     801072 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80100d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	68 00 10 00 00       	push   $0x1000
  80101b:	53                   	push   %ebx
  80101c:	68 00 f0 7f 00       	push   $0x7ff000
  801021:	e8 94 fb ff ff       	call   800bba <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  801026:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80102d:	53                   	push   %ebx
  80102e:	6a 00                	push   $0x0
  801030:	68 00 f0 7f 00       	push   $0x7ff000
  801035:	6a 00                	push   $0x0
  801037:	e8 c5 fd ff ff       	call   800e01 <sys_page_map>
  80103c:	83 c4 20             	add    $0x20,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 43                	js     801086 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	68 00 f0 7f 00       	push   $0x7ff000
  80104b:	6a 00                	push   $0x0
  80104d:	e8 f1 fd ff ff       	call   800e43 <sys_page_unmap>
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	78 41                	js     80109a <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  801059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    
		panic("invalid permision\n");
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	68 ea 27 80 00       	push   $0x8027ea
  801066:	6a 1f                	push   $0x1f
  801068:	68 fd 27 80 00       	push   $0x8027fd
  80106d:	e8 b0 f1 ff ff       	call   800222 <_panic>
		panic("Unable to alloc page\n");
  801072:	83 ec 04             	sub    $0x4,%esp
  801075:	68 08 28 80 00       	push   $0x802808
  80107a:	6a 28                	push   $0x28
  80107c:	68 fd 27 80 00       	push   $0x8027fd
  801081:	e8 9c f1 ff ff       	call   800222 <_panic>
		panic("Unable to map\n");
  801086:	83 ec 04             	sub    $0x4,%esp
  801089:	68 1e 28 80 00       	push   $0x80281e
  80108e:	6a 2b                	push   $0x2b
  801090:	68 fd 27 80 00       	push   $0x8027fd
  801095:	e8 88 f1 ff ff       	call   800222 <_panic>
		panic("Unable to unmap\n");
  80109a:	83 ec 04             	sub    $0x4,%esp
  80109d:	68 2d 28 80 00       	push   $0x80282d
  8010a2:	6a 2d                	push   $0x2d
  8010a4:	68 fd 27 80 00       	push   $0x8027fd
  8010a9:	e8 74 f1 ff ff       	call   800222 <_panic>

008010ae <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
  8010b4:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  8010b7:	68 af 0f 80 00       	push   $0x800faf
  8010bc:	e8 b3 0e 00 00       	call   801f74 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010c1:	b8 07 00 00 00       	mov    $0x7,%eax
  8010c6:	cd 30                	int    $0x30
  8010c8:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	78 23                	js     8010f4 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8010d1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  8010d6:	75 6d                	jne    801145 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010d8:	e8 a3 fc ff ff       	call   800d80 <sys_getenvid>
  8010dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ea:	a3 00 44 80 00       	mov    %eax,0x804400
		return 0;
  8010ef:	e9 02 01 00 00       	jmp    8011f6 <fork+0x148>
		panic("sys_exofork: %e", envid);
  8010f4:	50                   	push   %eax
  8010f5:	68 3e 28 80 00       	push   $0x80283e
  8010fa:	6a 6d                	push   $0x6d
  8010fc:	68 fd 27 80 00       	push   $0x8027fd
  801101:	e8 1c f1 ff ff       	call   800222 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801106:	c1 e0 0c             	shl    $0xc,%eax
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801112:	52                   	push   %edx
  801113:	50                   	push   %eax
  801114:	56                   	push   %esi
  801115:	50                   	push   %eax
  801116:	6a 00                	push   $0x0
  801118:	e8 e4 fc ff ff       	call   800e01 <sys_page_map>
  80111d:	83 c4 20             	add    $0x20,%esp
  801120:	eb 15                	jmp    801137 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  801122:	c1 e0 0c             	shl    $0xc,%eax
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	6a 05                	push   $0x5
  80112a:	50                   	push   %eax
  80112b:	56                   	push   %esi
  80112c:	50                   	push   %eax
  80112d:	6a 00                	push   $0x0
  80112f:	e8 cd fc ff ff       	call   800e01 <sys_page_map>
  801134:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801137:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80113d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801143:	74 7a                	je     8011bf <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  801145:	89 d8                	mov    %ebx,%eax
  801147:	c1 e8 16             	shr    $0x16,%eax
  80114a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801151:	a8 01                	test   $0x1,%al
  801153:	74 e2                	je     801137 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801155:	89 d8                	mov    %ebx,%eax
  801157:	c1 e8 0c             	shr    $0xc,%eax
  80115a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801161:	f6 c2 01             	test   $0x1,%dl
  801164:	74 d1                	je     801137 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801166:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80116d:	f6 c2 04             	test   $0x4,%dl
  801170:	74 c5                	je     801137 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801172:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801179:	f6 c6 04             	test   $0x4,%dh
  80117c:	75 88                	jne    801106 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  80117e:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801184:	74 9c                	je     801122 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801186:	c1 e0 0c             	shl    $0xc,%eax
  801189:	89 c7                	mov    %eax,%edi
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	68 05 08 00 00       	push   $0x805
  801193:	50                   	push   %eax
  801194:	56                   	push   %esi
  801195:	50                   	push   %eax
  801196:	6a 00                	push   $0x0
  801198:	e8 64 fc ff ff       	call   800e01 <sys_page_map>
  80119d:	83 c4 20             	add    $0x20,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	78 93                	js     801137 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	68 05 08 00 00       	push   $0x805
  8011ac:	57                   	push   %edi
  8011ad:	6a 00                	push   $0x0
  8011af:	57                   	push   %edi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 4a fc ff ff       	call   800e01 <sys_page_map>
  8011b7:	83 c4 20             	add    $0x20,%esp
  8011ba:	e9 78 ff ff ff       	jmp    801137 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8011bf:	83 ec 04             	sub    $0x4,%esp
  8011c2:	6a 07                	push   $0x7
  8011c4:	68 00 f0 bf ee       	push   $0xeebff000
  8011c9:	56                   	push   %esi
  8011ca:	e8 ef fb ff ff       	call   800dbe <sys_page_alloc>
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	78 2a                	js     801200 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	68 e3 1f 80 00       	push   $0x801fe3
  8011de:	56                   	push   %esi
  8011df:	e8 25 fd ff ff       	call   800f09 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011e4:	83 c4 08             	add    $0x8,%esp
  8011e7:	6a 02                	push   $0x2
  8011e9:	56                   	push   %esi
  8011ea:	e8 96 fc ff ff       	call   800e85 <sys_env_set_status>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 21                	js     801217 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    
		panic("failed to alloc page");
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	68 4e 28 80 00       	push   $0x80284e
  801208:	68 82 00 00 00       	push   $0x82
  80120d:	68 fd 27 80 00       	push   $0x8027fd
  801212:	e8 0b f0 ff ff       	call   800222 <_panic>
		panic("sys_env_set_status: %e", r);
  801217:	50                   	push   %eax
  801218:	68 63 28 80 00       	push   $0x802863
  80121d:	68 89 00 00 00       	push   $0x89
  801222:	68 fd 27 80 00       	push   $0x8027fd
  801227:	e8 f6 ef ff ff       	call   800222 <_panic>

0080122c <sfork>:

// Challenge!
int
sfork(void)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801232:	68 7a 28 80 00       	push   $0x80287a
  801237:	68 92 00 00 00       	push   $0x92
  80123c:	68 fd 27 80 00       	push   $0x8027fd
  801241:	e8 dc ef ff ff       	call   800222 <_panic>

00801246 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	05 00 00 00 30       	add    $0x30000000,%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
}
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801261:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801266:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801275:	89 c2                	mov    %eax,%edx
  801277:	c1 ea 16             	shr    $0x16,%edx
  80127a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801281:	f6 c2 01             	test   $0x1,%dl
  801284:	74 29                	je     8012af <fd_alloc+0x42>
  801286:	89 c2                	mov    %eax,%edx
  801288:	c1 ea 0c             	shr    $0xc,%edx
  80128b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801292:	f6 c2 01             	test   $0x1,%dl
  801295:	74 18                	je     8012af <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801297:	05 00 10 00 00       	add    $0x1000,%eax
  80129c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a1:	75 d2                	jne    801275 <fd_alloc+0x8>
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8012a8:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8012ad:	eb 05                	jmp    8012b4 <fd_alloc+0x47>
			return 0;
  8012af:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	89 02                	mov    %eax,(%edx)
}
  8012b9:	89 c8                	mov    %ecx,%eax
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c3:	83 f8 1f             	cmp    $0x1f,%eax
  8012c6:	77 30                	ja     8012f8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012c8:	c1 e0 0c             	shl    $0xc,%eax
  8012cb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012d6:	f6 c2 01             	test   $0x1,%dl
  8012d9:	74 24                	je     8012ff <fd_lookup+0x42>
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	c1 ea 0c             	shr    $0xc,%edx
  8012e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e7:	f6 c2 01             	test   $0x1,%dl
  8012ea:	74 1a                	je     801306 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ef:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    
		return -E_INVAL;
  8012f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fd:	eb f7                	jmp    8012f6 <fd_lookup+0x39>
		return -E_INVAL;
  8012ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801304:	eb f0                	jmp    8012f6 <fd_lookup+0x39>
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb e9                	jmp    8012f6 <fd_lookup+0x39>

0080130d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	8b 55 08             	mov    0x8(%ebp),%edx
  801317:	b8 0c 29 80 00       	mov    $0x80290c,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  80131c:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801321:	39 13                	cmp    %edx,(%ebx)
  801323:	74 32                	je     801357 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  801325:	83 c0 04             	add    $0x4,%eax
  801328:	8b 18                	mov    (%eax),%ebx
  80132a:	85 db                	test   %ebx,%ebx
  80132c:	75 f3                	jne    801321 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80132e:	a1 00 44 80 00       	mov    0x804400,%eax
  801333:	8b 40 48             	mov    0x48(%eax),%eax
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	52                   	push   %edx
  80133a:	50                   	push   %eax
  80133b:	68 90 28 80 00       	push   $0x802890
  801340:	e8 b8 ef ff ff       	call   8002fd <cprintf>
	*dev = 0;
	return -E_INVAL;
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	89 1a                	mov    %ebx,(%edx)
}
  801352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801355:	c9                   	leave  
  801356:	c3                   	ret    
			return 0;
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
  80135c:	eb ef                	jmp    80134d <dev_lookup+0x40>

0080135e <fd_close>:
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 24             	sub    $0x24,%esp
  801367:	8b 75 08             	mov    0x8(%ebp),%esi
  80136a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801370:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801371:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801377:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137a:	50                   	push   %eax
  80137b:	e8 3d ff ff ff       	call   8012bd <fd_lookup>
  801380:	89 c3                	mov    %eax,%ebx
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 05                	js     80138e <fd_close+0x30>
	    || fd != fd2)
  801389:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80138c:	74 16                	je     8013a4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80138e:	89 f8                	mov    %edi,%eax
  801390:	84 c0                	test   %al,%al
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	0f 44 d8             	cmove  %eax,%ebx
}
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139f:	5b                   	pop    %ebx
  8013a0:	5e                   	pop    %esi
  8013a1:	5f                   	pop    %edi
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 36                	push   (%esi)
  8013ad:	e8 5b ff ff ff       	call   80130d <dev_lookup>
  8013b2:	89 c3                	mov    %eax,%ebx
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 1a                	js     8013d5 <fd_close+0x77>
		if (dev->dev_close)
  8013bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	74 0b                	je     8013d5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013ca:	83 ec 0c             	sub    $0xc,%esp
  8013cd:	56                   	push   %esi
  8013ce:	ff d0                	call   *%eax
  8013d0:	89 c3                	mov    %eax,%ebx
  8013d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	56                   	push   %esi
  8013d9:	6a 00                	push   $0x0
  8013db:	e8 63 fa ff ff       	call   800e43 <sys_page_unmap>
	return r;
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	eb b5                	jmp    80139a <fd_close+0x3c>

008013e5 <close>:

int
close(int fdnum)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 08             	push   0x8(%ebp)
  8013f2:	e8 c6 fe ff ff       	call   8012bd <fd_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	79 02                	jns    801400 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    
		return fd_close(fd, 1);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	6a 01                	push   $0x1
  801405:	ff 75 f4             	push   -0xc(%ebp)
  801408:	e8 51 ff ff ff       	call   80135e <fd_close>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	eb ec                	jmp    8013fe <close+0x19>

00801412 <close_all>:

void
close_all(void)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	53                   	push   %ebx
  801416:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801419:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	53                   	push   %ebx
  801422:	e8 be ff ff ff       	call   8013e5 <close>
	for (i = 0; i < MAXFD; i++)
  801427:	83 c3 01             	add    $0x1,%ebx
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	83 fb 20             	cmp    $0x20,%ebx
  801430:	75 ec                	jne    80141e <close_all+0xc>
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	57                   	push   %edi
  80143b:	56                   	push   %esi
  80143c:	53                   	push   %ebx
  80143d:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801440:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801443:	50                   	push   %eax
  801444:	ff 75 08             	push   0x8(%ebp)
  801447:	e8 71 fe ff ff       	call   8012bd <fd_lookup>
  80144c:	89 c3                	mov    %eax,%ebx
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 7f                	js     8014d4 <dup+0x9d>
		return r;
	close(newfdnum);
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	ff 75 0c             	push   0xc(%ebp)
  80145b:	e8 85 ff ff ff       	call   8013e5 <close>

	newfd = INDEX2FD(newfdnum);
  801460:	8b 75 0c             	mov    0xc(%ebp),%esi
  801463:	c1 e6 0c             	shl    $0xc,%esi
  801466:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80146c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80146f:	89 3c 24             	mov    %edi,(%esp)
  801472:	e8 df fd ff ff       	call   801256 <fd2data>
  801477:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801479:	89 34 24             	mov    %esi,(%esp)
  80147c:	e8 d5 fd ff ff       	call   801256 <fd2data>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801487:	89 d8                	mov    %ebx,%eax
  801489:	c1 e8 16             	shr    $0x16,%eax
  80148c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801493:	a8 01                	test   $0x1,%al
  801495:	74 11                	je     8014a8 <dup+0x71>
  801497:	89 d8                	mov    %ebx,%eax
  801499:	c1 e8 0c             	shr    $0xc,%eax
  80149c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a3:	f6 c2 01             	test   $0x1,%dl
  8014a6:	75 36                	jne    8014de <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014a8:	89 f8                	mov    %edi,%eax
  8014aa:	c1 e8 0c             	shr    $0xc,%eax
  8014ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b4:	83 ec 0c             	sub    $0xc,%esp
  8014b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8014bc:	50                   	push   %eax
  8014bd:	56                   	push   %esi
  8014be:	6a 00                	push   $0x0
  8014c0:	57                   	push   %edi
  8014c1:	6a 00                	push   $0x0
  8014c3:	e8 39 f9 ff ff       	call   800e01 <sys_page_map>
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	83 c4 20             	add    $0x20,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 33                	js     801504 <dup+0xcd>
		goto err;

	return newfdnum;
  8014d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014d4:	89 d8                	mov    %ebx,%eax
  8014d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ed:	50                   	push   %eax
  8014ee:	ff 75 d4             	push   -0x2c(%ebp)
  8014f1:	6a 00                	push   $0x0
  8014f3:	53                   	push   %ebx
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 06 f9 ff ff       	call   800e01 <sys_page_map>
  8014fb:	89 c3                	mov    %eax,%ebx
  8014fd:	83 c4 20             	add    $0x20,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	79 a4                	jns    8014a8 <dup+0x71>
	sys_page_unmap(0, newfd);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	56                   	push   %esi
  801508:	6a 00                	push   $0x0
  80150a:	e8 34 f9 ff ff       	call   800e43 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80150f:	83 c4 08             	add    $0x8,%esp
  801512:	ff 75 d4             	push   -0x2c(%ebp)
  801515:	6a 00                	push   $0x0
  801517:	e8 27 f9 ff ff       	call   800e43 <sys_page_unmap>
	return r;
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	eb b3                	jmp    8014d4 <dup+0x9d>

00801521 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	83 ec 18             	sub    $0x18,%esp
  801529:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	56                   	push   %esi
  801531:	e8 87 fd ff ff       	call   8012bd <fd_lookup>
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 3c                	js     801579 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	ff 33                	push   (%ebx)
  801549:	e8 bf fd ff ff       	call   80130d <dev_lookup>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 24                	js     801579 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801555:	8b 43 08             	mov    0x8(%ebx),%eax
  801558:	83 e0 03             	and    $0x3,%eax
  80155b:	83 f8 01             	cmp    $0x1,%eax
  80155e:	74 20                	je     801580 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 40 08             	mov    0x8(%eax),%eax
  801566:	85 c0                	test   %eax,%eax
  801568:	74 37                	je     8015a1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	ff 75 10             	push   0x10(%ebp)
  801570:	ff 75 0c             	push   0xc(%ebp)
  801573:	53                   	push   %ebx
  801574:	ff d0                	call   *%eax
  801576:	83 c4 10             	add    $0x10,%esp
}
  801579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801580:	a1 00 44 80 00       	mov    0x804400,%eax
  801585:	8b 40 48             	mov    0x48(%eax),%eax
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	56                   	push   %esi
  80158c:	50                   	push   %eax
  80158d:	68 d1 28 80 00       	push   $0x8028d1
  801592:	e8 66 ed ff ff       	call   8002fd <cprintf>
		return -E_INVAL;
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159f:	eb d8                	jmp    801579 <read+0x58>
		return -E_NOT_SUPP;
  8015a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a6:	eb d1                	jmp    801579 <read+0x58>

008015a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	57                   	push   %edi
  8015ac:	56                   	push   %esi
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015bc:	eb 02                	jmp    8015c0 <readn+0x18>
  8015be:	01 c3                	add    %eax,%ebx
  8015c0:	39 f3                	cmp    %esi,%ebx
  8015c2:	73 21                	jae    8015e5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	89 f0                	mov    %esi,%eax
  8015c9:	29 d8                	sub    %ebx,%eax
  8015cb:	50                   	push   %eax
  8015cc:	89 d8                	mov    %ebx,%eax
  8015ce:	03 45 0c             	add    0xc(%ebp),%eax
  8015d1:	50                   	push   %eax
  8015d2:	57                   	push   %edi
  8015d3:	e8 49 ff ff ff       	call   801521 <read>
		if (m < 0)
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 04                	js     8015e3 <readn+0x3b>
			return m;
		if (m == 0)
  8015df:	75 dd                	jne    8015be <readn+0x16>
  8015e1:	eb 02                	jmp    8015e5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015e3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015e5:	89 d8                	mov    %ebx,%eax
  8015e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5f                   	pop    %edi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	56                   	push   %esi
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 18             	sub    $0x18,%esp
  8015f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fd:	50                   	push   %eax
  8015fe:	53                   	push   %ebx
  8015ff:	e8 b9 fc ff ff       	call   8012bd <fd_lookup>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 37                	js     801642 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160b:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801614:	50                   	push   %eax
  801615:	ff 36                	push   (%esi)
  801617:	e8 f1 fc ff ff       	call   80130d <dev_lookup>
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 1f                	js     801642 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801623:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801627:	74 20                	je     801649 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	8b 40 0c             	mov    0xc(%eax),%eax
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 37                	je     80166a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	ff 75 10             	push   0x10(%ebp)
  801639:	ff 75 0c             	push   0xc(%ebp)
  80163c:	56                   	push   %esi
  80163d:	ff d0                	call   *%eax
  80163f:	83 c4 10             	add    $0x10,%esp
}
  801642:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801649:	a1 00 44 80 00       	mov    0x804400,%eax
  80164e:	8b 40 48             	mov    0x48(%eax),%eax
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	53                   	push   %ebx
  801655:	50                   	push   %eax
  801656:	68 ed 28 80 00       	push   $0x8028ed
  80165b:	e8 9d ec ff ff       	call   8002fd <cprintf>
		return -E_INVAL;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801668:	eb d8                	jmp    801642 <write+0x53>
		return -E_NOT_SUPP;
  80166a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166f:	eb d1                	jmp    801642 <write+0x53>

00801671 <seek>:

int
seek(int fdnum, off_t offset)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801677:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	ff 75 08             	push   0x8(%ebp)
  80167e:	e8 3a fc ff ff       	call   8012bd <fd_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 0e                	js     801698 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
  80169f:	83 ec 18             	sub    $0x18,%esp
  8016a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a8:	50                   	push   %eax
  8016a9:	53                   	push   %ebx
  8016aa:	e8 0e fc ff ff       	call   8012bd <fd_lookup>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 34                	js     8016ea <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b6:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	ff 36                	push   (%esi)
  8016c2:	e8 46 fc ff ff       	call   80130d <dev_lookup>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	78 1c                	js     8016ea <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ce:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8016d2:	74 1d                	je     8016f1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d7:	8b 40 18             	mov    0x18(%eax),%eax
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	74 34                	je     801712 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	ff 75 0c             	push   0xc(%ebp)
  8016e4:	56                   	push   %esi
  8016e5:	ff d0                	call   *%eax
  8016e7:	83 c4 10             	add    $0x10,%esp
}
  8016ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016f1:	a1 00 44 80 00       	mov    0x804400,%eax
  8016f6:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	53                   	push   %ebx
  8016fd:	50                   	push   %eax
  8016fe:	68 b0 28 80 00       	push   $0x8028b0
  801703:	e8 f5 eb ff ff       	call   8002fd <cprintf>
		return -E_INVAL;
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801710:	eb d8                	jmp    8016ea <ftruncate+0x50>
		return -E_NOT_SUPP;
  801712:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801717:	eb d1                	jmp    8016ea <ftruncate+0x50>

00801719 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	56                   	push   %esi
  80171d:	53                   	push   %ebx
  80171e:	83 ec 18             	sub    $0x18,%esp
  801721:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801724:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801727:	50                   	push   %eax
  801728:	ff 75 08             	push   0x8(%ebp)
  80172b:	e8 8d fb ff ff       	call   8012bd <fd_lookup>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	85 c0                	test   %eax,%eax
  801735:	78 49                	js     801780 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801737:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	ff 36                	push   (%esi)
  801743:	e8 c5 fb ff ff       	call   80130d <dev_lookup>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	85 c0                	test   %eax,%eax
  80174d:	78 31                	js     801780 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  80174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801752:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801756:	74 2f                	je     801787 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801758:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80175b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801762:	00 00 00 
	stat->st_isdir = 0;
  801765:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80176c:	00 00 00 
	stat->st_dev = dev;
  80176f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	53                   	push   %ebx
  801779:	56                   	push   %esi
  80177a:	ff 50 14             	call   *0x14(%eax)
  80177d:	83 c4 10             	add    $0x10,%esp
}
  801780:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    
		return -E_NOT_SUPP;
  801787:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178c:	eb f2                	jmp    801780 <fstat+0x67>

0080178e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	6a 00                	push   $0x0
  801798:	ff 75 08             	push   0x8(%ebp)
  80179b:	e8 22 02 00 00       	call   8019c2 <open>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 1b                	js     8017c4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 0c             	push   0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	e8 64 ff ff ff       	call   801719 <fstat>
  8017b5:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 26 fc ff ff       	call   8013e5 <close>
	return r;
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	89 f3                	mov    %esi,%ebx
}
  8017c4:	89 d8                	mov    %ebx,%eax
  8017c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	89 c6                	mov    %eax,%esi
  8017d4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8017dd:	74 27                	je     801806 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017df:	6a 07                	push   $0x7
  8017e1:	68 00 50 80 00       	push   $0x805000
  8017e6:	56                   	push   %esi
  8017e7:	ff 35 00 60 80 00    	push   0x806000
  8017ed:	e8 64 08 00 00       	call   802056 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017f2:	83 c4 0c             	add    $0xc,%esp
  8017f5:	6a 00                	push   $0x0
  8017f7:	53                   	push   %ebx
  8017f8:	6a 00                	push   $0x0
  8017fa:	e8 08 08 00 00       	call   802007 <ipc_recv>
}
  8017ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	6a 01                	push   $0x1
  80180b:	e8 92 08 00 00       	call   8020a2 <ipc_find_env>
  801810:	a3 00 60 80 00       	mov    %eax,0x806000
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	eb c5                	jmp    8017df <fsipc+0x12>

0080181a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 40 0c             	mov    0xc(%eax),%eax
  801826:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	b8 02 00 00 00       	mov    $0x2,%eax
  80183d:	e8 8b ff ff ff       	call   8017cd <fsipc>
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <devfile_flush>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8b 40 0c             	mov    0xc(%eax),%eax
  801850:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	b8 06 00 00 00       	mov    $0x6,%eax
  80185f:	e8 69 ff ff ff       	call   8017cd <fsipc>
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <devfile_stat>:
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8b 40 0c             	mov    0xc(%eax),%eax
  801876:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	b8 05 00 00 00       	mov    $0x5,%eax
  801885:	e8 43 ff ff ff       	call   8017cd <fsipc>
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 2c                	js     8018ba <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	68 00 50 80 00       	push   $0x805000
  801896:	53                   	push   %ebx
  801897:	e8 26 f1 ff ff       	call   8009c2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80189c:	a1 80 50 80 00       	mov    0x805080,%eax
  8018a1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018a7:	a1 84 50 80 00       	mov    0x805084,%eax
  8018ac:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <devfile_write>:
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018d4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018da:	53                   	push   %ebx
  8018db:	ff 75 0c             	push   0xc(%ebp)
  8018de:	68 08 50 80 00       	push   $0x805008
  8018e3:	e8 d2 f2 ff ff       	call   800bba <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f2:	e8 d6 fe ff ff       	call   8017cd <fsipc>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 0b                	js     801909 <devfile_write+0x4a>
	assert(r <= n);
  8018fe:	39 d8                	cmp    %ebx,%eax
  801900:	77 0c                	ja     80190e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801902:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801907:	7f 1e                	jg     801927 <devfile_write+0x68>
}
  801909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    
	assert(r <= n);
  80190e:	68 1c 29 80 00       	push   $0x80291c
  801913:	68 23 29 80 00       	push   $0x802923
  801918:	68 97 00 00 00       	push   $0x97
  80191d:	68 38 29 80 00       	push   $0x802938
  801922:	e8 fb e8 ff ff       	call   800222 <_panic>
	assert(r <= PGSIZE);
  801927:	68 43 29 80 00       	push   $0x802943
  80192c:	68 23 29 80 00       	push   $0x802923
  801931:	68 98 00 00 00       	push   $0x98
  801936:	68 38 29 80 00       	push   $0x802938
  80193b:	e8 e2 e8 ff ff       	call   800222 <_panic>

00801940 <devfile_read>:
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8b 40 0c             	mov    0xc(%eax),%eax
  80194e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801953:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	b8 03 00 00 00       	mov    $0x3,%eax
  801963:	e8 65 fe ff ff       	call   8017cd <fsipc>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 1f                	js     80198d <devfile_read+0x4d>
	assert(r <= n);
  80196e:	39 f0                	cmp    %esi,%eax
  801970:	77 24                	ja     801996 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801972:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801977:	7f 33                	jg     8019ac <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	50                   	push   %eax
  80197d:	68 00 50 80 00       	push   $0x805000
  801982:	ff 75 0c             	push   0xc(%ebp)
  801985:	e8 ce f1 ff ff       	call   800b58 <memmove>
	return r;
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	89 d8                	mov    %ebx,%eax
  80198f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    
	assert(r <= n);
  801996:	68 1c 29 80 00       	push   $0x80291c
  80199b:	68 23 29 80 00       	push   $0x802923
  8019a0:	6a 7c                	push   $0x7c
  8019a2:	68 38 29 80 00       	push   $0x802938
  8019a7:	e8 76 e8 ff ff       	call   800222 <_panic>
	assert(r <= PGSIZE);
  8019ac:	68 43 29 80 00       	push   $0x802943
  8019b1:	68 23 29 80 00       	push   $0x802923
  8019b6:	6a 7d                	push   $0x7d
  8019b8:	68 38 29 80 00       	push   $0x802938
  8019bd:	e8 60 e8 ff ff       	call   800222 <_panic>

008019c2 <open>:
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 1c             	sub    $0x1c,%esp
  8019ca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019cd:	56                   	push   %esi
  8019ce:	e8 b4 ef ff ff       	call   800987 <strlen>
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019db:	7f 6c                	jg     801a49 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	e8 84 f8 ff ff       	call   80126d <fd_alloc>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 3c                	js     801a2e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	56                   	push   %esi
  8019f6:	68 00 50 80 00       	push   $0x805000
  8019fb:	e8 c2 ef ff ff       	call   8009c2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a03:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a10:	e8 b8 fd ff ff       	call   8017cd <fsipc>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 19                	js     801a37 <open+0x75>
	return fd2num(fd);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 f4             	push   -0xc(%ebp)
  801a24:	e8 1d f8 ff ff       	call   801246 <fd2num>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	89 d8                	mov    %ebx,%eax
  801a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    
		fd_close(fd, 0);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 f4             	push   -0xc(%ebp)
  801a3f:	e8 1a f9 ff ff       	call   80135e <fd_close>
		return r;
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	eb e5                	jmp    801a2e <open+0x6c>
		return -E_BAD_PATH;
  801a49:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a4e:	eb de                	jmp    801a2e <open+0x6c>

00801a50 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a60:	e8 68 fd ff ff       	call   8017cd <fsipc>
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	ff 75 08             	push   0x8(%ebp)
  801a75:	e8 dc f7 ff ff       	call   801256 <fd2data>
  801a7a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a7c:	83 c4 08             	add    $0x8,%esp
  801a7f:	68 4f 29 80 00       	push   $0x80294f
  801a84:	53                   	push   %ebx
  801a85:	e8 38 ef ff ff       	call   8009c2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a8a:	8b 46 04             	mov    0x4(%esi),%eax
  801a8d:	2b 06                	sub    (%esi),%eax
  801a8f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a95:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9c:	00 00 00 
	stat->st_dev = &devpipe;
  801a9f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aa6:	30 80 00 
	return 0;
}
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801abf:	53                   	push   %ebx
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 7c f3 ff ff       	call   800e43 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ac7:	89 1c 24             	mov    %ebx,(%esp)
  801aca:	e8 87 f7 ff ff       	call   801256 <fd2data>
  801acf:	83 c4 08             	add    $0x8,%esp
  801ad2:	50                   	push   %eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	e8 69 f3 ff ff       	call   800e43 <sys_page_unmap>
}
  801ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <_pipeisclosed>:
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	57                   	push   %edi
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 1c             	sub    $0x1c,%esp
  801ae8:	89 c7                	mov    %eax,%edi
  801aea:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801aec:	a1 00 44 80 00       	mov    0x804400,%eax
  801af1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	57                   	push   %edi
  801af8:	e8 de 05 00 00       	call   8020db <pageref>
  801afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b00:	89 34 24             	mov    %esi,(%esp)
  801b03:	e8 d3 05 00 00       	call   8020db <pageref>
		nn = thisenv->env_runs;
  801b08:	8b 15 00 44 80 00    	mov    0x804400,%edx
  801b0e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	39 cb                	cmp    %ecx,%ebx
  801b16:	74 1b                	je     801b33 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b18:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b1b:	75 cf                	jne    801aec <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b1d:	8b 42 58             	mov    0x58(%edx),%eax
  801b20:	6a 01                	push   $0x1
  801b22:	50                   	push   %eax
  801b23:	53                   	push   %ebx
  801b24:	68 56 29 80 00       	push   $0x802956
  801b29:	e8 cf e7 ff ff       	call   8002fd <cprintf>
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	eb b9                	jmp    801aec <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b33:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b36:	0f 94 c0             	sete   %al
  801b39:	0f b6 c0             	movzbl %al,%eax
}
  801b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <devpipe_write>:
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 28             	sub    $0x28,%esp
  801b4d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b50:	56                   	push   %esi
  801b51:	e8 00 f7 ff ff       	call   801256 <fd2data>
  801b56:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b60:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b63:	75 09                	jne    801b6e <devpipe_write+0x2a>
	return i;
  801b65:	89 f8                	mov    %edi,%eax
  801b67:	eb 23                	jmp    801b8c <devpipe_write+0x48>
			sys_yield();
  801b69:	e8 31 f2 ff ff       	call   800d9f <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b6e:	8b 43 04             	mov    0x4(%ebx),%eax
  801b71:	8b 0b                	mov    (%ebx),%ecx
  801b73:	8d 51 20             	lea    0x20(%ecx),%edx
  801b76:	39 d0                	cmp    %edx,%eax
  801b78:	72 1a                	jb     801b94 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801b7a:	89 da                	mov    %ebx,%edx
  801b7c:	89 f0                	mov    %esi,%eax
  801b7e:	e8 5c ff ff ff       	call   801adf <_pipeisclosed>
  801b83:	85 c0                	test   %eax,%eax
  801b85:	74 e2                	je     801b69 <devpipe_write+0x25>
				return 0;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b97:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b9b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b9e:	89 c2                	mov    %eax,%edx
  801ba0:	c1 fa 1f             	sar    $0x1f,%edx
  801ba3:	89 d1                	mov    %edx,%ecx
  801ba5:	c1 e9 1b             	shr    $0x1b,%ecx
  801ba8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bab:	83 e2 1f             	and    $0x1f,%edx
  801bae:	29 ca                	sub    %ecx,%edx
  801bb0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bb4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bb8:	83 c0 01             	add    $0x1,%eax
  801bbb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bbe:	83 c7 01             	add    $0x1,%edi
  801bc1:	eb 9d                	jmp    801b60 <devpipe_write+0x1c>

00801bc3 <devpipe_read>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	57                   	push   %edi
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 18             	sub    $0x18,%esp
  801bcc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bcf:	57                   	push   %edi
  801bd0:	e8 81 f6 ff ff       	call   801256 <fd2data>
  801bd5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	be 00 00 00 00       	mov    $0x0,%esi
  801bdf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801be2:	75 13                	jne    801bf7 <devpipe_read+0x34>
	return i;
  801be4:	89 f0                	mov    %esi,%eax
  801be6:	eb 02                	jmp    801bea <devpipe_read+0x27>
				return i;
  801be8:	89 f0                	mov    %esi,%eax
}
  801bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5e                   	pop    %esi
  801bef:	5f                   	pop    %edi
  801bf0:	5d                   	pop    %ebp
  801bf1:	c3                   	ret    
			sys_yield();
  801bf2:	e8 a8 f1 ff ff       	call   800d9f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801bf7:	8b 03                	mov    (%ebx),%eax
  801bf9:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bfc:	75 18                	jne    801c16 <devpipe_read+0x53>
			if (i > 0)
  801bfe:	85 f6                	test   %esi,%esi
  801c00:	75 e6                	jne    801be8 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801c02:	89 da                	mov    %ebx,%edx
  801c04:	89 f8                	mov    %edi,%eax
  801c06:	e8 d4 fe ff ff       	call   801adf <_pipeisclosed>
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	74 e3                	je     801bf2 <devpipe_read+0x2f>
				return 0;
  801c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c14:	eb d4                	jmp    801bea <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c16:	99                   	cltd   
  801c17:	c1 ea 1b             	shr    $0x1b,%edx
  801c1a:	01 d0                	add    %edx,%eax
  801c1c:	83 e0 1f             	and    $0x1f,%eax
  801c1f:	29 d0                	sub    %edx,%eax
  801c21:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c29:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c2c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c2f:	83 c6 01             	add    $0x1,%esi
  801c32:	eb ab                	jmp    801bdf <devpipe_read+0x1c>

00801c34 <pipe>:
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	56                   	push   %esi
  801c38:	53                   	push   %ebx
  801c39:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3f:	50                   	push   %eax
  801c40:	e8 28 f6 ff ff       	call   80126d <fd_alloc>
  801c45:	89 c3                	mov    %eax,%ebx
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	0f 88 23 01 00 00    	js     801d75 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	68 07 04 00 00       	push   $0x407
  801c5a:	ff 75 f4             	push   -0xc(%ebp)
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 5a f1 ff ff       	call   800dbe <sys_page_alloc>
  801c64:	89 c3                	mov    %eax,%ebx
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	0f 88 04 01 00 00    	js     801d75 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c77:	50                   	push   %eax
  801c78:	e8 f0 f5 ff ff       	call   80126d <fd_alloc>
  801c7d:	89 c3                	mov    %eax,%ebx
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	0f 88 db 00 00 00    	js     801d65 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 07 04 00 00       	push   $0x407
  801c92:	ff 75 f0             	push   -0x10(%ebp)
  801c95:	6a 00                	push   $0x0
  801c97:	e8 22 f1 ff ff       	call   800dbe <sys_page_alloc>
  801c9c:	89 c3                	mov    %eax,%ebx
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	0f 88 bc 00 00 00    	js     801d65 <pipe+0x131>
	va = fd2data(fd0);
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	ff 75 f4             	push   -0xc(%ebp)
  801caf:	e8 a2 f5 ff ff       	call   801256 <fd2data>
  801cb4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb6:	83 c4 0c             	add    $0xc,%esp
  801cb9:	68 07 04 00 00       	push   $0x407
  801cbe:	50                   	push   %eax
  801cbf:	6a 00                	push   $0x0
  801cc1:	e8 f8 f0 ff ff       	call   800dbe <sys_page_alloc>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	0f 88 82 00 00 00    	js     801d55 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	ff 75 f0             	push   -0x10(%ebp)
  801cd9:	e8 78 f5 ff ff       	call   801256 <fd2data>
  801cde:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ce5:	50                   	push   %eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	56                   	push   %esi
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 11 f1 ff ff       	call   800e01 <sys_page_map>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	83 c4 20             	add    $0x20,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 4e                	js     801d47 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801cf9:	a1 20 30 80 00       	mov    0x803020,%eax
  801cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d01:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d06:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d10:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d1c:	83 ec 0c             	sub    $0xc,%esp
  801d1f:	ff 75 f4             	push   -0xc(%ebp)
  801d22:	e8 1f f5 ff ff       	call   801246 <fd2num>
  801d27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d2c:	83 c4 04             	add    $0x4,%esp
  801d2f:	ff 75 f0             	push   -0x10(%ebp)
  801d32:	e8 0f f5 ff ff       	call   801246 <fd2num>
  801d37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d45:	eb 2e                	jmp    801d75 <pipe+0x141>
	sys_page_unmap(0, va);
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	56                   	push   %esi
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 f1 f0 ff ff       	call   800e43 <sys_page_unmap>
  801d52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	ff 75 f0             	push   -0x10(%ebp)
  801d5b:	6a 00                	push   $0x0
  801d5d:	e8 e1 f0 ff ff       	call   800e43 <sys_page_unmap>
  801d62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	ff 75 f4             	push   -0xc(%ebp)
  801d6b:	6a 00                	push   $0x0
  801d6d:	e8 d1 f0 ff ff       	call   800e43 <sys_page_unmap>
  801d72:	83 c4 10             	add    $0x10,%esp
}
  801d75:	89 d8                	mov    %ebx,%eax
  801d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5d                   	pop    %ebp
  801d7d:	c3                   	ret    

00801d7e <pipeisclosed>:
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d87:	50                   	push   %eax
  801d88:	ff 75 08             	push   0x8(%ebp)
  801d8b:	e8 2d f5 ff ff       	call   8012bd <fd_lookup>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 18                	js     801daf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	ff 75 f4             	push   -0xc(%ebp)
  801d9d:	e8 b4 f4 ff ff       	call   801256 <fd2data>
  801da2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	e8 33 fd ff ff       	call   801adf <_pipeisclosed>
  801dac:	83 c4 10             	add    $0x10,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801db9:	85 f6                	test   %esi,%esi
  801dbb:	74 13                	je     801dd0 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801dbd:	89 f3                	mov    %esi,%ebx
  801dbf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801dc5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801dc8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801dce:	eb 1b                	jmp    801deb <wait+0x3a>
	assert(envid != 0);
  801dd0:	68 6e 29 80 00       	push   $0x80296e
  801dd5:	68 23 29 80 00       	push   $0x802923
  801dda:	6a 09                	push   $0x9
  801ddc:	68 79 29 80 00       	push   $0x802979
  801de1:	e8 3c e4 ff ff       	call   800222 <_panic>
		sys_yield();
  801de6:	e8 b4 ef ff ff       	call   800d9f <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801deb:	8b 43 48             	mov    0x48(%ebx),%eax
  801dee:	39 f0                	cmp    %esi,%eax
  801df0:	75 07                	jne    801df9 <wait+0x48>
  801df2:	8b 43 54             	mov    0x54(%ebx),%eax
  801df5:	85 c0                	test   %eax,%eax
  801df7:	75 ed                	jne    801de6 <wait+0x35>
}
  801df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
  801e05:	c3                   	ret    

00801e06 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e0c:	68 84 29 80 00       	push   $0x802984
  801e11:	ff 75 0c             	push   0xc(%ebp)
  801e14:	e8 a9 eb ff ff       	call   8009c2 <strcpy>
	return 0;
}
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <devcons_write>:
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	57                   	push   %edi
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e2c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e31:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e37:	eb 2e                	jmp    801e67 <devcons_write+0x47>
		m = n - tot;
  801e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e3c:	29 f3                	sub    %esi,%ebx
  801e3e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e43:	39 c3                	cmp    %eax,%ebx
  801e45:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	53                   	push   %ebx
  801e4c:	89 f0                	mov    %esi,%eax
  801e4e:	03 45 0c             	add    0xc(%ebp),%eax
  801e51:	50                   	push   %eax
  801e52:	57                   	push   %edi
  801e53:	e8 00 ed ff ff       	call   800b58 <memmove>
		sys_cputs(buf, m);
  801e58:	83 c4 08             	add    $0x8,%esp
  801e5b:	53                   	push   %ebx
  801e5c:	57                   	push   %edi
  801e5d:	e8 a0 ee ff ff       	call   800d02 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e62:	01 de                	add    %ebx,%esi
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6a:	72 cd                	jb     801e39 <devcons_write+0x19>
}
  801e6c:	89 f0                	mov    %esi,%eax
  801e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <devcons_read>:
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 08             	sub    $0x8,%esp
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e85:	75 07                	jne    801e8e <devcons_read+0x18>
  801e87:	eb 1f                	jmp    801ea8 <devcons_read+0x32>
		sys_yield();
  801e89:	e8 11 ef ff ff       	call   800d9f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e8e:	e8 8d ee ff ff       	call   800d20 <sys_cgetc>
  801e93:	85 c0                	test   %eax,%eax
  801e95:	74 f2                	je     801e89 <devcons_read+0x13>
	if (c < 0)
  801e97:	78 0f                	js     801ea8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801e99:	83 f8 04             	cmp    $0x4,%eax
  801e9c:	74 0c                	je     801eaa <devcons_read+0x34>
	*(char*)vbuf = c;
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	88 02                	mov    %al,(%edx)
	return 1;
  801ea3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    
		return 0;
  801eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaf:	eb f7                	jmp    801ea8 <devcons_read+0x32>

00801eb1 <cputchar>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ebd:	6a 01                	push   $0x1
  801ebf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec2:	50                   	push   %eax
  801ec3:	e8 3a ee ff ff       	call   800d02 <sys_cputs>
}
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <getchar>:
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ed3:	6a 01                	push   $0x1
  801ed5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ed8:	50                   	push   %eax
  801ed9:	6a 00                	push   $0x0
  801edb:	e8 41 f6 ff ff       	call   801521 <read>
	if (r < 0)
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 06                	js     801eed <getchar+0x20>
	if (r < 1)
  801ee7:	74 06                	je     801eef <getchar+0x22>
	return c;
  801ee9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    
		return -E_EOF;
  801eef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef4:	eb f7                	jmp    801eed <getchar+0x20>

00801ef6 <iscons>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	ff 75 08             	push   0x8(%ebp)
  801f03:	e8 b5 f3 ff ff       	call   8012bd <fd_lookup>
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	78 11                	js     801f20 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f18:	39 10                	cmp    %edx,(%eax)
  801f1a:	0f 94 c0             	sete   %al
  801f1d:	0f b6 c0             	movzbl %al,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <opencons>:
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2b:	50                   	push   %eax
  801f2c:	e8 3c f3 ff ff       	call   80126d <fd_alloc>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	78 3a                	js     801f72 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	68 07 04 00 00       	push   $0x407
  801f40:	ff 75 f4             	push   -0xc(%ebp)
  801f43:	6a 00                	push   $0x0
  801f45:	e8 74 ee ff ff       	call   800dbe <sys_page_alloc>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 21                	js     801f72 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f5a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	50                   	push   %eax
  801f6a:	e8 d7 f2 ff ff       	call   801246 <fd2num>
  801f6f:	83 c4 10             	add    $0x10,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f7a:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801f81:	74 20                	je     801fa3 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	a3 04 60 80 00       	mov    %eax,0x806004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	68 e3 1f 80 00       	push   $0x801fe3
  801f93:	6a 00                	push   $0x0
  801f95:	e8 6f ef ff ff       	call   800f09 <sys_env_set_pgfault_upcall>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 2e                	js     801fcf <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	6a 07                	push   $0x7
  801fa8:	68 00 f0 bf ee       	push   $0xeebff000
  801fad:	6a 00                	push   $0x0
  801faf:	e8 0a ee ff ff       	call   800dbe <sys_page_alloc>
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	79 c8                	jns    801f83 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 90 29 80 00       	push   $0x802990
  801fc3:	6a 21                	push   $0x21
  801fc5:	68 f3 29 80 00       	push   $0x8029f3
  801fca:	e8 53 e2 ff ff       	call   800222 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 bc 29 80 00       	push   $0x8029bc
  801fd7:	6a 27                	push   $0x27
  801fd9:	68 f3 29 80 00       	push   $0x8029f3
  801fde:	e8 3f e2 ff ff       	call   800222 <_panic>

00801fe3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801fe3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fe4:	a1 04 60 80 00       	mov    0x806004,%eax
	call *%eax
  801fe9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801feb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  801fee:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  801ff2:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  801ff7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  801ffb:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  801ffd:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802000:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802001:	83 c4 04             	add    $0x4,%esp
	popfl
  802004:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802005:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802006:	c3                   	ret    

00802007 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	8b 75 08             	mov    0x8(%ebp),%esi
  80200f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	ff 75 0c             	push   0xc(%ebp)
  802018:	e8 51 ef ff ff       	call   800f6e <sys_ipc_recv>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	85 c0                	test   %eax,%eax
  802022:	78 2b                	js     80204f <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802024:	85 f6                	test   %esi,%esi
  802026:	74 0a                	je     802032 <ipc_recv+0x2b>
  802028:	a1 00 44 80 00       	mov    0x804400,%eax
  80202d:	8b 40 74             	mov    0x74(%eax),%eax
  802030:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802032:	85 db                	test   %ebx,%ebx
  802034:	74 0a                	je     802040 <ipc_recv+0x39>
  802036:	a1 00 44 80 00       	mov    0x804400,%eax
  80203b:	8b 40 78             	mov    0x78(%eax),%eax
  80203e:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802040:	a1 00 44 80 00       	mov    0x804400,%eax
  802045:	8b 40 70             	mov    0x70(%eax),%eax
}
  802048:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80204f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802054:	eb f2                	jmp    802048 <ipc_recv+0x41>

00802056 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	57                   	push   %edi
  80205a:	56                   	push   %esi
  80205b:	53                   	push   %ebx
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802062:	8b 75 0c             	mov    0xc(%ebp),%esi
  802065:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802068:	ff 75 14             	push   0x14(%ebp)
  80206b:	53                   	push   %ebx
  80206c:	56                   	push   %esi
  80206d:	57                   	push   %edi
  80206e:	e8 d8 ee ff ff       	call   800f4b <sys_ipc_try_send>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	79 20                	jns    80209a <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80207a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80207d:	75 07                	jne    802086 <ipc_send+0x30>
		sys_yield();
  80207f:	e8 1b ed ff ff       	call   800d9f <sys_yield>
  802084:	eb e2                	jmp    802068 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 01 2a 80 00       	push   $0x802a01
  80208e:	6a 2e                	push   $0x2e
  802090:	68 11 2a 80 00       	push   $0x802a11
  802095:	e8 88 e1 ff ff       	call   800222 <_panic>
	}
}
  80209a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80209d:	5b                   	pop    %ebx
  80209e:	5e                   	pop    %esi
  80209f:	5f                   	pop    %edi
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    

008020a2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020ad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020b6:	8b 52 50             	mov    0x50(%edx),%edx
  8020b9:	39 ca                	cmp    %ecx,%edx
  8020bb:	74 11                	je     8020ce <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020bd:	83 c0 01             	add    $0x1,%eax
  8020c0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020c5:	75 e6                	jne    8020ad <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cc:	eb 0b                	jmp    8020d9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020e1:	89 c2                	mov    %eax,%edx
  8020e3:	c1 ea 16             	shr    $0x16,%edx
  8020e6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020ed:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020f2:	f6 c1 01             	test   $0x1,%cl
  8020f5:	74 1c                	je     802113 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8020f7:	c1 e8 0c             	shr    $0xc,%eax
  8020fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802101:	a8 01                	test   $0x1,%al
  802103:	74 0e                	je     802113 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802105:	c1 e8 0c             	shr    $0xc,%eax
  802108:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80210f:	ef 
  802110:	0f b7 d2             	movzwl %dx,%edx
}
  802113:	89 d0                	mov    %edx,%eax
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    
  802117:	66 90                	xchg   %ax,%ax
  802119:	66 90                	xchg   %ax,%ax
  80211b:	66 90                	xchg   %ax,%ax
  80211d:	66 90                	xchg   %ax,%ax
  80211f:	90                   	nop

00802120 <__udivdi3>:
  802120:	f3 0f 1e fb          	endbr32 
  802124:	55                   	push   %ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80212f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802133:	8b 74 24 34          	mov    0x34(%esp),%esi
  802137:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80213b:	85 c0                	test   %eax,%eax
  80213d:	75 19                	jne    802158 <__udivdi3+0x38>
  80213f:	39 f3                	cmp    %esi,%ebx
  802141:	76 4d                	jbe    802190 <__udivdi3+0x70>
  802143:	31 ff                	xor    %edi,%edi
  802145:	89 e8                	mov    %ebp,%eax
  802147:	89 f2                	mov    %esi,%edx
  802149:	f7 f3                	div    %ebx
  80214b:	89 fa                	mov    %edi,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	39 f0                	cmp    %esi,%eax
  80215a:	76 14                	jbe    802170 <__udivdi3+0x50>
  80215c:	31 ff                	xor    %edi,%edi
  80215e:	31 c0                	xor    %eax,%eax
  802160:	89 fa                	mov    %edi,%edx
  802162:	83 c4 1c             	add    $0x1c,%esp
  802165:	5b                   	pop    %ebx
  802166:	5e                   	pop    %esi
  802167:	5f                   	pop    %edi
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    
  80216a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802170:	0f bd f8             	bsr    %eax,%edi
  802173:	83 f7 1f             	xor    $0x1f,%edi
  802176:	75 48                	jne    8021c0 <__udivdi3+0xa0>
  802178:	39 f0                	cmp    %esi,%eax
  80217a:	72 06                	jb     802182 <__udivdi3+0x62>
  80217c:	31 c0                	xor    %eax,%eax
  80217e:	39 eb                	cmp    %ebp,%ebx
  802180:	77 de                	ja     802160 <__udivdi3+0x40>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	eb d7                	jmp    802160 <__udivdi3+0x40>
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 d9                	mov    %ebx,%ecx
  802192:	85 db                	test   %ebx,%ebx
  802194:	75 0b                	jne    8021a1 <__udivdi3+0x81>
  802196:	b8 01 00 00 00       	mov    $0x1,%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	f7 f3                	div    %ebx
  80219f:	89 c1                	mov    %eax,%ecx
  8021a1:	31 d2                	xor    %edx,%edx
  8021a3:	89 f0                	mov    %esi,%eax
  8021a5:	f7 f1                	div    %ecx
  8021a7:	89 c6                	mov    %eax,%esi
  8021a9:	89 e8                	mov    %ebp,%eax
  8021ab:	89 f7                	mov    %esi,%edi
  8021ad:	f7 f1                	div    %ecx
  8021af:	89 fa                	mov    %edi,%edx
  8021b1:	83 c4 1c             	add    $0x1c,%esp
  8021b4:	5b                   	pop    %ebx
  8021b5:	5e                   	pop    %esi
  8021b6:	5f                   	pop    %edi
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    
  8021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	89 f9                	mov    %edi,%ecx
  8021c2:	ba 20 00 00 00       	mov    $0x20,%edx
  8021c7:	29 fa                	sub    %edi,%edx
  8021c9:	d3 e0                	shl    %cl,%eax
  8021cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021cf:	89 d1                	mov    %edx,%ecx
  8021d1:	89 d8                	mov    %ebx,%eax
  8021d3:	d3 e8                	shr    %cl,%eax
  8021d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d9:	09 c1                	or     %eax,%ecx
  8021db:	89 f0                	mov    %esi,%eax
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 f9                	mov    %edi,%ecx
  8021e3:	d3 e3                	shl    %cl,%ebx
  8021e5:	89 d1                	mov    %edx,%ecx
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	89 f9                	mov    %edi,%ecx
  8021eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ef:	89 eb                	mov    %ebp,%ebx
  8021f1:	d3 e6                	shl    %cl,%esi
  8021f3:	89 d1                	mov    %edx,%ecx
  8021f5:	d3 eb                	shr    %cl,%ebx
  8021f7:	09 f3                	or     %esi,%ebx
  8021f9:	89 c6                	mov    %eax,%esi
  8021fb:	89 f2                	mov    %esi,%edx
  8021fd:	89 d8                	mov    %ebx,%eax
  8021ff:	f7 74 24 08          	divl   0x8(%esp)
  802203:	89 d6                	mov    %edx,%esi
  802205:	89 c3                	mov    %eax,%ebx
  802207:	f7 64 24 0c          	mull   0xc(%esp)
  80220b:	39 d6                	cmp    %edx,%esi
  80220d:	72 19                	jb     802228 <__udivdi3+0x108>
  80220f:	89 f9                	mov    %edi,%ecx
  802211:	d3 e5                	shl    %cl,%ebp
  802213:	39 c5                	cmp    %eax,%ebp
  802215:	73 04                	jae    80221b <__udivdi3+0xfb>
  802217:	39 d6                	cmp    %edx,%esi
  802219:	74 0d                	je     802228 <__udivdi3+0x108>
  80221b:	89 d8                	mov    %ebx,%eax
  80221d:	31 ff                	xor    %edi,%edi
  80221f:	e9 3c ff ff ff       	jmp    802160 <__udivdi3+0x40>
  802224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802228:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80222b:	31 ff                	xor    %edi,%edi
  80222d:	e9 2e ff ff ff       	jmp    802160 <__udivdi3+0x40>
  802232:	66 90                	xchg   %ax,%ax
  802234:	66 90                	xchg   %ax,%ax
  802236:	66 90                	xchg   %ax,%ax
  802238:	66 90                	xchg   %ax,%ax
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <__umoddi3>:
  802240:	f3 0f 1e fb          	endbr32 
  802244:	55                   	push   %ebp
  802245:	57                   	push   %edi
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	83 ec 1c             	sub    $0x1c,%esp
  80224b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80224f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802253:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802257:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80225b:	89 f0                	mov    %esi,%eax
  80225d:	89 da                	mov    %ebx,%edx
  80225f:	85 ff                	test   %edi,%edi
  802261:	75 15                	jne    802278 <__umoddi3+0x38>
  802263:	39 dd                	cmp    %ebx,%ebp
  802265:	76 39                	jbe    8022a0 <__umoddi3+0x60>
  802267:	f7 f5                	div    %ebp
  802269:	89 d0                	mov    %edx,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	83 c4 1c             	add    $0x1c,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	39 df                	cmp    %ebx,%edi
  80227a:	77 f1                	ja     80226d <__umoddi3+0x2d>
  80227c:	0f bd cf             	bsr    %edi,%ecx
  80227f:	83 f1 1f             	xor    $0x1f,%ecx
  802282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802286:	75 40                	jne    8022c8 <__umoddi3+0x88>
  802288:	39 df                	cmp    %ebx,%edi
  80228a:	72 04                	jb     802290 <__umoddi3+0x50>
  80228c:	39 f5                	cmp    %esi,%ebp
  80228e:	77 dd                	ja     80226d <__umoddi3+0x2d>
  802290:	89 da                	mov    %ebx,%edx
  802292:	89 f0                	mov    %esi,%eax
  802294:	29 e8                	sub    %ebp,%eax
  802296:	19 fa                	sbb    %edi,%edx
  802298:	eb d3                	jmp    80226d <__umoddi3+0x2d>
  80229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022a0:	89 e9                	mov    %ebp,%ecx
  8022a2:	85 ed                	test   %ebp,%ebp
  8022a4:	75 0b                	jne    8022b1 <__umoddi3+0x71>
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f5                	div    %ebp
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	89 d8                	mov    %ebx,%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	f7 f1                	div    %ecx
  8022b7:	89 f0                	mov    %esi,%eax
  8022b9:	f7 f1                	div    %ecx
  8022bb:	89 d0                	mov    %edx,%eax
  8022bd:	31 d2                	xor    %edx,%edx
  8022bf:	eb ac                	jmp    80226d <__umoddi3+0x2d>
  8022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022cc:	ba 20 00 00 00       	mov    $0x20,%edx
  8022d1:	29 c2                	sub    %eax,%edx
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	89 e8                	mov    %ebp,%eax
  8022d7:	d3 e7                	shl    %cl,%edi
  8022d9:	89 d1                	mov    %edx,%ecx
  8022db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022df:	d3 e8                	shr    %cl,%eax
  8022e1:	89 c1                	mov    %eax,%ecx
  8022e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022e7:	09 f9                	or     %edi,%ecx
  8022e9:	89 df                	mov    %ebx,%edi
  8022eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022ef:	89 c1                	mov    %eax,%ecx
  8022f1:	d3 e5                	shl    %cl,%ebp
  8022f3:	89 d1                	mov    %edx,%ecx
  8022f5:	d3 ef                	shr    %cl,%edi
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	d3 e3                	shl    %cl,%ebx
  8022fd:	89 d1                	mov    %edx,%ecx
  8022ff:	89 fa                	mov    %edi,%edx
  802301:	d3 e8                	shr    %cl,%eax
  802303:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802308:	09 d8                	or     %ebx,%eax
  80230a:	f7 74 24 08          	divl   0x8(%esp)
  80230e:	89 d3                	mov    %edx,%ebx
  802310:	d3 e6                	shl    %cl,%esi
  802312:	f7 e5                	mul    %ebp
  802314:	89 c7                	mov    %eax,%edi
  802316:	89 d1                	mov    %edx,%ecx
  802318:	39 d3                	cmp    %edx,%ebx
  80231a:	72 06                	jb     802322 <__umoddi3+0xe2>
  80231c:	75 0e                	jne    80232c <__umoddi3+0xec>
  80231e:	39 c6                	cmp    %eax,%esi
  802320:	73 0a                	jae    80232c <__umoddi3+0xec>
  802322:	29 e8                	sub    %ebp,%eax
  802324:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802328:	89 d1                	mov    %edx,%ecx
  80232a:	89 c7                	mov    %eax,%edi
  80232c:	89 f5                	mov    %esi,%ebp
  80232e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802332:	29 fd                	sub    %edi,%ebp
  802334:	19 cb                	sbb    %ecx,%ebx
  802336:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80233b:	89 d8                	mov    %ebx,%eax
  80233d:	d3 e0                	shl    %cl,%eax
  80233f:	89 f1                	mov    %esi,%ecx
  802341:	d3 ed                	shr    %cl,%ebp
  802343:	d3 eb                	shr    %cl,%ebx
  802345:	09 e8                	or     %ebp,%eax
  802347:	89 da                	mov    %ebx,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
