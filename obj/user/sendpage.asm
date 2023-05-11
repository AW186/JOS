
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 73 01 00 00       	call   8001a4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 04 10 00 00       	call   801042 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 f1 0c 00 00       	call   800d52 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 20 80 00    	push   0x802004
  80006a:	e8 ac 08 00 00       	call   80091b <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 20 80 00    	push   0x802004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 c8 0a 00 00       	call   800b4e <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	push   -0xc(%ebp)
  800092:	e8 92 11 00 00       	call   801229 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 30 11 00 00       	call   8011da <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	push   -0xc(%ebp)
  8000b5:	68 e0 15 80 00       	push   $0x8015e0
  8000ba:	e8 d2 01 00 00       	call   800291 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 20 80 00    	push   0x802000
  8000c8:	e8 4e 08 00 00       	call   80091b <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 20 80 00    	push   0x802000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 4c 09 00 00       	call   800a2d <strncmp>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 84 a3 00 00 00    	je     80018f <umain+0x15c>
		cprintf("parent received correct message\n");
	return;
}
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	68 00 00 b0 00       	push   $0xb00000
  8000f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 d9 10 00 00       	call   8011da <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	push   -0xc(%ebp)
  80010c:	68 e0 15 80 00       	push   $0x8015e0
  800111:	e8 7b 01 00 00       	call   800291 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 20 80 00    	push   0x802004
  80011f:	e8 f7 07 00 00       	call   80091b <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 20 80 00    	push   0x802004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 f5 08 00 00       	call   800a2d <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 20 80 00    	push   0x802000
  800148:	e8 ce 07 00 00       	call   80091b <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 20 80 00    	push   0x802000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 ea 09 00 00       	call   800b4e <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	push   -0xc(%ebp)
  800170:	e8 b4 10 00 00       	call   801229 <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 f4 15 80 00       	push   $0x8015f4
  800185:	e8 07 01 00 00       	call   800291 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 14 16 80 00       	push   $0x801614
  800197:	e8 f5 00 00 00       	call   800291 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001af:	e8 60 0b 00 00       	call   800d14 <sys_getenvid>
  8001b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c1:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c6:	85 db                	test   %ebx,%ebx
  8001c8:	7e 07                	jle    8001d1 <libmain+0x2d>
		binaryname = argv[0];
  8001ca:	8b 06                	mov    (%esi),%eax
  8001cc:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	e8 58 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001db:	e8 0a 00 00 00       	call   8001ea <exit>
}
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001f0:	6a 00                	push   $0x0
  8001f2:	e8 dc 0a 00 00       	call   800cd3 <sys_env_destroy>
}
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	53                   	push   %ebx
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800206:	8b 13                	mov    (%ebx),%edx
  800208:	8d 42 01             	lea    0x1(%edx),%eax
  80020b:	89 03                	mov    %eax,(%ebx)
  80020d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800210:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800214:	3d ff 00 00 00       	cmp    $0xff,%eax
  800219:	74 09                	je     800224 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800222:	c9                   	leave  
  800223:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	68 ff 00 00 00       	push   $0xff
  80022c:	8d 43 08             	lea    0x8(%ebx),%eax
  80022f:	50                   	push   %eax
  800230:	e8 61 0a 00 00       	call   800c96 <sys_cputs>
		b->idx = 0;
  800235:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	eb db                	jmp    80021b <putch+0x1f>

00800240 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800249:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800250:	00 00 00 
	b.cnt = 0;
  800253:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025d:	ff 75 0c             	push   0xc(%ebp)
  800260:	ff 75 08             	push   0x8(%ebp)
  800263:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800269:	50                   	push   %eax
  80026a:	68 fc 01 80 00       	push   $0x8001fc
  80026f:	e8 14 01 00 00       	call   800388 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800274:	83 c4 08             	add    $0x8,%esp
  800277:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80027d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800283:	50                   	push   %eax
  800284:	e8 0d 0a 00 00       	call   800c96 <sys_cputs>

	return b.cnt;
}
  800289:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800297:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029a:	50                   	push   %eax
  80029b:	ff 75 08             	push   0x8(%ebp)
  80029e:	e8 9d ff ff ff       	call   800240 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 1c             	sub    $0x1c,%esp
  8002ae:	89 c7                	mov    %eax,%edi
  8002b0:	89 d6                	mov    %edx,%esi
  8002b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 d1                	mov    %edx,%ecx
  8002ba:	89 c2                	mov    %eax,%edx
  8002bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002d2:	39 c2                	cmp    %eax,%edx
  8002d4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d7:	72 3e                	jb     800317 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 18             	push   0x18(%ebp)
  8002df:	83 eb 01             	sub    $0x1,%ebx
  8002e2:	53                   	push   %ebx
  8002e3:	50                   	push   %eax
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	ff 75 e4             	push   -0x1c(%ebp)
  8002ea:	ff 75 e0             	push   -0x20(%ebp)
  8002ed:	ff 75 dc             	push   -0x24(%ebp)
  8002f0:	ff 75 d8             	push   -0x28(%ebp)
  8002f3:	e8 98 10 00 00       	call   801390 <__udivdi3>
  8002f8:	83 c4 18             	add    $0x18,%esp
  8002fb:	52                   	push   %edx
  8002fc:	50                   	push   %eax
  8002fd:	89 f2                	mov    %esi,%edx
  8002ff:	89 f8                	mov    %edi,%eax
  800301:	e8 9f ff ff ff       	call   8002a5 <printnum>
  800306:	83 c4 20             	add    $0x20,%esp
  800309:	eb 13                	jmp    80031e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	ff 75 18             	push   0x18(%ebp)
  800312:	ff d7                	call   *%edi
  800314:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800317:	83 eb 01             	sub    $0x1,%ebx
  80031a:	85 db                	test   %ebx,%ebx
  80031c:	7f ed                	jg     80030b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	56                   	push   %esi
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	ff 75 e4             	push   -0x1c(%ebp)
  800328:	ff 75 e0             	push   -0x20(%ebp)
  80032b:	ff 75 dc             	push   -0x24(%ebp)
  80032e:	ff 75 d8             	push   -0x28(%ebp)
  800331:	e8 7a 11 00 00       	call   8014b0 <__umoddi3>
  800336:	83 c4 14             	add    $0x14,%esp
  800339:	0f be 80 8c 16 80 00 	movsbl 0x80168c(%eax),%eax
  800340:	50                   	push   %eax
  800341:	ff d7                	call   *%edi
}
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800349:	5b                   	pop    %ebx
  80034a:	5e                   	pop    %esi
  80034b:	5f                   	pop    %edi
  80034c:	5d                   	pop    %ebp
  80034d:	c3                   	ret    

0080034e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800354:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800358:	8b 10                	mov    (%eax),%edx
  80035a:	3b 50 04             	cmp    0x4(%eax),%edx
  80035d:	73 0a                	jae    800369 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800362:	89 08                	mov    %ecx,(%eax)
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	88 02                	mov    %al,(%edx)
}
  800369:	5d                   	pop    %ebp
  80036a:	c3                   	ret    

0080036b <printfmt>:
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800371:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800374:	50                   	push   %eax
  800375:	ff 75 10             	push   0x10(%ebp)
  800378:	ff 75 0c             	push   0xc(%ebp)
  80037b:	ff 75 08             	push   0x8(%ebp)
  80037e:	e8 05 00 00 00       	call   800388 <vprintfmt>
}
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <vprintfmt>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	57                   	push   %edi
  80038c:	56                   	push   %esi
  80038d:	53                   	push   %ebx
  80038e:	83 ec 3c             	sub    $0x3c,%esp
  800391:	8b 75 08             	mov    0x8(%ebp),%esi
  800394:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800397:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039a:	eb 0a                	jmp    8003a6 <vprintfmt+0x1e>
			putch(ch, putdat);
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	53                   	push   %ebx
  8003a0:	50                   	push   %eax
  8003a1:	ff d6                	call   *%esi
  8003a3:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a6:	83 c7 01             	add    $0x1,%edi
  8003a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003ad:	83 f8 25             	cmp    $0x25,%eax
  8003b0:	74 0c                	je     8003be <vprintfmt+0x36>
			if (ch == '\0')
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	75 e6                	jne    80039c <vprintfmt+0x14>
}
  8003b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5f                   	pop    %edi
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    
		padc = ' ';
  8003be:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8003d0:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8d 47 01             	lea    0x1(%edi),%eax
  8003df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e2:	0f b6 17             	movzbl (%edi),%edx
  8003e5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e8:	3c 55                	cmp    $0x55,%al
  8003ea:	0f 87 a6 04 00 00    	ja     800896 <vprintfmt+0x50e>
  8003f0:	0f b6 c0             	movzbl %al,%eax
  8003f3:	ff 24 85 e0 17 80 00 	jmp    *0x8017e0(,%eax,4)
  8003fa:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8003fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800401:	eb d9                	jmp    8003dc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800406:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80040a:	eb d0                	jmp    8003dc <vprintfmt+0x54>
  80040c:	0f b6 d2             	movzbl %dl,%edx
  80040f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
  800417:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80041a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800421:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800424:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800427:	83 f9 09             	cmp    $0x9,%ecx
  80042a:	77 55                	ja     800481 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80042c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042f:	eb e9                	jmp    80041a <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	8d 40 04             	lea    0x4(%eax),%eax
  80043f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800445:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800449:	79 91                	jns    8003dc <vprintfmt+0x54>
				width = precision, precision = -1;
  80044b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800458:	eb 82                	jmp    8003dc <vprintfmt+0x54>
  80045a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	0f 49 c2             	cmovns %edx,%eax
  800467:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80046d:	e9 6a ff ff ff       	jmp    8003dc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800472:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800475:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80047c:	e9 5b ff ff ff       	jmp    8003dc <vprintfmt+0x54>
  800481:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800484:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800487:	eb bc                	jmp    800445 <vprintfmt+0xbd>
			lflag++;
  800489:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80048f:	e9 48 ff ff ff       	jmp    8003dc <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 78 04             	lea    0x4(%eax),%edi
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	53                   	push   %ebx
  80049e:	ff 30                	push   (%eax)
  8004a0:	ff d6                	call   *%esi
			break;
  8004a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004a8:	e9 88 03 00 00       	jmp    800835 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8d 78 04             	lea    0x4(%eax),%edi
  8004b3:	8b 10                	mov    (%eax),%edx
  8004b5:	89 d0                	mov    %edx,%eax
  8004b7:	f7 d8                	neg    %eax
  8004b9:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004bc:	83 f8 0f             	cmp    $0xf,%eax
  8004bf:	7f 23                	jg     8004e4 <vprintfmt+0x15c>
  8004c1:	8b 14 85 40 19 80 00 	mov    0x801940(,%eax,4),%edx
  8004c8:	85 d2                	test   %edx,%edx
  8004ca:	74 18                	je     8004e4 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8004cc:	52                   	push   %edx
  8004cd:	68 ad 16 80 00       	push   $0x8016ad
  8004d2:	53                   	push   %ebx
  8004d3:	56                   	push   %esi
  8004d4:	e8 92 fe ff ff       	call   80036b <printfmt>
  8004d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004df:	e9 51 03 00 00       	jmp    800835 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8004e4:	50                   	push   %eax
  8004e5:	68 a4 16 80 00       	push   $0x8016a4
  8004ea:	53                   	push   %ebx
  8004eb:	56                   	push   %esi
  8004ec:	e8 7a fe ff ff       	call   80036b <printfmt>
  8004f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004f7:	e9 39 03 00 00       	jmp    800835 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 c0 04             	add    $0x4,%eax
  800502:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80050a:	85 d2                	test   %edx,%edx
  80050c:	b8 9d 16 80 00       	mov    $0x80169d,%eax
  800511:	0f 45 c2             	cmovne %edx,%eax
  800514:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800517:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051b:	7e 06                	jle    800523 <vprintfmt+0x19b>
  80051d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800521:	75 0d                	jne    800530 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800526:	89 c7                	mov    %eax,%edi
  800528:	03 45 d4             	add    -0x2c(%ebp),%eax
  80052b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80052e:	eb 55                	jmp    800585 <vprintfmt+0x1fd>
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	ff 75 e0             	push   -0x20(%ebp)
  800536:	ff 75 cc             	push   -0x34(%ebp)
  800539:	e8 f5 03 00 00       	call   800933 <strnlen>
  80053e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800541:	29 c2                	sub    %eax,%edx
  800543:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80054b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80054f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800552:	eb 0f                	jmp    800563 <vprintfmt+0x1db>
					putch(padc, putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	ff 75 d4             	push   -0x2c(%ebp)
  80055b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055d:	83 ef 01             	sub    $0x1,%edi
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	85 ff                	test   %edi,%edi
  800565:	7f ed                	jg     800554 <vprintfmt+0x1cc>
  800567:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80056a:	85 d2                	test   %edx,%edx
  80056c:	b8 00 00 00 00       	mov    $0x0,%eax
  800571:	0f 49 c2             	cmovns %edx,%eax
  800574:	29 c2                	sub    %eax,%edx
  800576:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800579:	eb a8                	jmp    800523 <vprintfmt+0x19b>
					putch(ch, putdat);
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	53                   	push   %ebx
  80057f:	52                   	push   %edx
  800580:	ff d6                	call   *%esi
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800588:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058a:	83 c7 01             	add    $0x1,%edi
  80058d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800591:	0f be d0             	movsbl %al,%edx
  800594:	85 d2                	test   %edx,%edx
  800596:	74 4b                	je     8005e3 <vprintfmt+0x25b>
  800598:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059c:	78 06                	js     8005a4 <vprintfmt+0x21c>
  80059e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005a2:	78 1e                	js     8005c2 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a8:	74 d1                	je     80057b <vprintfmt+0x1f3>
  8005aa:	0f be c0             	movsbl %al,%eax
  8005ad:	83 e8 20             	sub    $0x20,%eax
  8005b0:	83 f8 5e             	cmp    $0x5e,%eax
  8005b3:	76 c6                	jbe    80057b <vprintfmt+0x1f3>
					putch('?', putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	53                   	push   %ebx
  8005b9:	6a 3f                	push   $0x3f
  8005bb:	ff d6                	call   *%esi
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	eb c3                	jmp    800585 <vprintfmt+0x1fd>
  8005c2:	89 cf                	mov    %ecx,%edi
  8005c4:	eb 0e                	jmp    8005d4 <vprintfmt+0x24c>
				putch(' ', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 20                	push   $0x20
  8005cc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005ce:	83 ef 01             	sub    $0x1,%edi
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7f ee                	jg     8005c6 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	e9 52 02 00 00       	jmp    800835 <vprintfmt+0x4ad>
  8005e3:	89 cf                	mov    %ecx,%edi
  8005e5:	eb ed                	jmp    8005d4 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005f5:	85 d2                	test   %edx,%edx
  8005f7:	b8 9d 16 80 00       	mov    $0x80169d,%eax
  8005fc:	0f 45 c2             	cmovne %edx,%eax
  8005ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800602:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800606:	7e 06                	jle    80060e <vprintfmt+0x286>
  800608:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80060c:	75 0d                	jne    80061b <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800611:	89 c7                	mov    %eax,%edi
  800613:	03 45 d4             	add    -0x2c(%ebp),%eax
  800616:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800619:	eb 55                	jmp    800670 <vprintfmt+0x2e8>
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 e0             	push   -0x20(%ebp)
  800621:	ff 75 cc             	push   -0x34(%ebp)
  800624:	e8 0a 03 00 00       	call   800933 <strnlen>
  800629:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062c:	29 c2                	sub    %eax,%edx
  80062e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800636:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80063a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	eb 0f                	jmp    80064e <vprintfmt+0x2c6>
					putch(padc, putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	53                   	push   %ebx
  800643:	ff 75 d4             	push   -0x2c(%ebp)
  800646:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	83 ef 01             	sub    $0x1,%edi
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	85 ff                	test   %edi,%edi
  800650:	7f ed                	jg     80063f <vprintfmt+0x2b7>
  800652:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800655:	85 d2                	test   %edx,%edx
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
  80065c:	0f 49 c2             	cmovns %edx,%eax
  80065f:	29 c2                	sub    %eax,%edx
  800661:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800664:	eb a8                	jmp    80060e <vprintfmt+0x286>
					putch(ch, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	52                   	push   %edx
  80066b:	ff d6                	call   *%esi
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800673:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800675:	83 c7 01             	add    $0x1,%edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	0f be d0             	movsbl %al,%edx
  80067f:	3c 3a                	cmp    $0x3a,%al
  800681:	74 4b                	je     8006ce <vprintfmt+0x346>
  800683:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800687:	78 06                	js     80068f <vprintfmt+0x307>
  800689:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80068d:	78 1e                	js     8006ad <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80068f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800693:	74 d1                	je     800666 <vprintfmt+0x2de>
  800695:	0f be c0             	movsbl %al,%eax
  800698:	83 e8 20             	sub    $0x20,%eax
  80069b:	83 f8 5e             	cmp    $0x5e,%eax
  80069e:	76 c6                	jbe    800666 <vprintfmt+0x2de>
					putch('?', putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 3f                	push   $0x3f
  8006a6:	ff d6                	call   *%esi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	eb c3                	jmp    800670 <vprintfmt+0x2e8>
  8006ad:	89 cf                	mov    %ecx,%edi
  8006af:	eb 0e                	jmp    8006bf <vprintfmt+0x337>
				putch(' ', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 20                	push   $0x20
  8006b7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b9:	83 ef 01             	sub    $0x1,%edi
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	85 ff                	test   %edi,%edi
  8006c1:	7f ee                	jg     8006b1 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c9:	e9 67 01 00 00       	jmp    800835 <vprintfmt+0x4ad>
  8006ce:	89 cf                	mov    %ecx,%edi
  8006d0:	eb ed                	jmp    8006bf <vprintfmt+0x337>
	if (lflag >= 2)
  8006d2:	83 f9 01             	cmp    $0x1,%ecx
  8006d5:	7f 1b                	jg     8006f2 <vprintfmt+0x36a>
	else if (lflag)
  8006d7:	85 c9                	test   %ecx,%ecx
  8006d9:	74 63                	je     80073e <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e3:	99                   	cltd   
  8006e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb 17                	jmp    800709 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800709:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80070f:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800714:	85 c9                	test   %ecx,%ecx
  800716:	0f 89 ff 00 00 00    	jns    80081b <vprintfmt+0x493>
				putch('-', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 2d                	push   $0x2d
  800722:	ff d6                	call   *%esi
				num = -(long long) num;
  800724:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800727:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80072a:	f7 da                	neg    %edx
  80072c:	83 d1 00             	adc    $0x0,%ecx
  80072f:	f7 d9                	neg    %ecx
  800731:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800734:	bf 0a 00 00 00       	mov    $0xa,%edi
  800739:	e9 dd 00 00 00       	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, int);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800746:	99                   	cltd   
  800747:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
  800753:	eb b4                	jmp    800709 <vprintfmt+0x381>
	if (lflag >= 2)
  800755:	83 f9 01             	cmp    $0x1,%ecx
  800758:	7f 1e                	jg     800778 <vprintfmt+0x3f0>
	else if (lflag)
  80075a:	85 c9                	test   %ecx,%ecx
  80075c:	74 32                	je     800790 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 10                	mov    (%eax),%edx
  800763:	b9 00 00 00 00       	mov    $0x0,%ecx
  800768:	8d 40 04             	lea    0x4(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076e:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800773:	e9 a3 00 00 00       	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 10                	mov    (%eax),%edx
  80077d:	8b 48 04             	mov    0x4(%eax),%ecx
  800780:	8d 40 08             	lea    0x8(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800786:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80078b:	e9 8b 00 00 00       	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 10                	mov    (%eax),%edx
  800795:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a0:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8007a5:	eb 74                	jmp    80081b <vprintfmt+0x493>
	if (lflag >= 2)
  8007a7:	83 f9 01             	cmp    $0x1,%ecx
  8007aa:	7f 1b                	jg     8007c7 <vprintfmt+0x43f>
	else if (lflag)
  8007ac:	85 c9                	test   %ecx,%ecx
  8007ae:	74 2c                	je     8007dc <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 10                	mov    (%eax),%edx
  8007b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8007c5:	eb 54                	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 10                	mov    (%eax),%edx
  8007cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cf:	8d 40 08             	lea    0x8(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d5:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8007da:	eb 3f                	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 10                	mov    (%eax),%edx
  8007e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ec:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8007f1:	eb 28                	jmp    80081b <vprintfmt+0x493>
			putch('0', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	6a 30                	push   $0x30
  8007f9:	ff d6                	call   *%esi
			putch('x', putdat);
  8007fb:	83 c4 08             	add    $0x8,%esp
  8007fe:	53                   	push   %ebx
  8007ff:	6a 78                	push   $0x78
  800801:	ff d6                	call   *%esi
			num = (unsigned long long)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 10                	mov    (%eax),%edx
  800808:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80080d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800822:	50                   	push   %eax
  800823:	ff 75 d4             	push   -0x2c(%ebp)
  800826:	57                   	push   %edi
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	89 da                	mov    %ebx,%edx
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	e8 73 fa ff ff       	call   8002a5 <printnum>
			break;
  800832:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800835:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800838:	e9 69 fb ff ff       	jmp    8003a6 <vprintfmt+0x1e>
	if (lflag >= 2)
  80083d:	83 f9 01             	cmp    $0x1,%ecx
  800840:	7f 1b                	jg     80085d <vprintfmt+0x4d5>
	else if (lflag)
  800842:	85 c9                	test   %ecx,%ecx
  800844:	74 2c                	je     800872 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  80085b:	eb be                	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 10                	mov    (%eax),%edx
  800862:	8b 48 04             	mov    0x4(%eax),%ecx
  800865:	8d 40 08             	lea    0x8(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086b:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800870:	eb a9                	jmp    80081b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8b 10                	mov    (%eax),%edx
  800877:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087c:	8d 40 04             	lea    0x4(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800882:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800887:	eb 92                	jmp    80081b <vprintfmt+0x493>
			putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	6a 25                	push   $0x25
  80088f:	ff d6                	call   *%esi
			break;
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	eb 9f                	jmp    800835 <vprintfmt+0x4ad>
			putch('%', putdat);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	53                   	push   %ebx
  80089a:	6a 25                	push   $0x25
  80089c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	89 f8                	mov    %edi,%eax
  8008a3:	eb 03                	jmp    8008a8 <vprintfmt+0x520>
  8008a5:	83 e8 01             	sub    $0x1,%eax
  8008a8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008ac:	75 f7                	jne    8008a5 <vprintfmt+0x51d>
  8008ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b1:	eb 82                	jmp    800835 <vprintfmt+0x4ad>

008008b3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 18             	sub    $0x18,%esp
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	74 26                	je     8008fa <vsnprintf+0x47>
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	7e 22                	jle    8008fa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d8:	ff 75 14             	push   0x14(%ebp)
  8008db:	ff 75 10             	push   0x10(%ebp)
  8008de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e1:	50                   	push   %eax
  8008e2:	68 4e 03 80 00       	push   $0x80034e
  8008e7:	e8 9c fa ff ff       	call   800388 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    
		return -E_INVAL;
  8008fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ff:	eb f7                	jmp    8008f8 <vsnprintf+0x45>

00800901 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800907:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090a:	50                   	push   %eax
  80090b:	ff 75 10             	push   0x10(%ebp)
  80090e:	ff 75 0c             	push   0xc(%ebp)
  800911:	ff 75 08             	push   0x8(%ebp)
  800914:	e8 9a ff ff ff       	call   8008b3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	eb 03                	jmp    80092b <strlen+0x10>
		n++;
  800928:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80092b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092f:	75 f7                	jne    800928 <strlen+0xd>
	return n;
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093c:	b8 00 00 00 00       	mov    $0x0,%eax
  800941:	eb 03                	jmp    800946 <strnlen+0x13>
		n++;
  800943:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800946:	39 d0                	cmp    %edx,%eax
  800948:	74 08                	je     800952 <strnlen+0x1f>
  80094a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80094e:	75 f3                	jne    800943 <strnlen+0x10>
  800950:	89 c2                	mov    %eax,%edx
	return n;
}
  800952:	89 d0                	mov    %edx,%eax
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	53                   	push   %ebx
  80095a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800969:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80096c:	83 c0 01             	add    $0x1,%eax
  80096f:	84 d2                	test   %dl,%dl
  800971:	75 f2                	jne    800965 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800973:	89 c8                	mov    %ecx,%eax
  800975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	83 ec 10             	sub    $0x10,%esp
  800981:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800984:	53                   	push   %ebx
  800985:	e8 91 ff ff ff       	call   80091b <strlen>
  80098a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80098d:	ff 75 0c             	push   0xc(%ebp)
  800990:	01 d8                	add    %ebx,%eax
  800992:	50                   	push   %eax
  800993:	e8 be ff ff ff       	call   800956 <strcpy>
	return dst;
}
  800998:	89 d8                	mov    %ebx,%eax
  80099a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	56                   	push   %esi
  8009a3:	53                   	push   %ebx
  8009a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	89 f3                	mov    %esi,%ebx
  8009ac:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009af:	89 f0                	mov    %esi,%eax
  8009b1:	eb 0f                	jmp    8009c2 <strncpy+0x23>
		*dst++ = *src;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	0f b6 0a             	movzbl (%edx),%ecx
  8009b9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bc:	80 f9 01             	cmp    $0x1,%cl
  8009bf:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8009c2:	39 d8                	cmp    %ebx,%eax
  8009c4:	75 ed                	jne    8009b3 <strncpy+0x14>
	}
	return ret;
}
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	5b                   	pop    %ebx
  8009c9:	5e                   	pop    %esi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	56                   	push   %esi
  8009d0:	53                   	push   %ebx
  8009d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d7:	8b 55 10             	mov    0x10(%ebp),%edx
  8009da:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	74 21                	je     800a01 <strlcpy+0x35>
  8009e0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e4:	89 f2                	mov    %esi,%edx
  8009e6:	eb 09                	jmp    8009f1 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009e8:	83 c1 01             	add    $0x1,%ecx
  8009eb:	83 c2 01             	add    $0x1,%edx
  8009ee:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8009f1:	39 c2                	cmp    %eax,%edx
  8009f3:	74 09                	je     8009fe <strlcpy+0x32>
  8009f5:	0f b6 19             	movzbl (%ecx),%ebx
  8009f8:	84 db                	test   %bl,%bl
  8009fa:	75 ec                	jne    8009e8 <strlcpy+0x1c>
  8009fc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a01:	29 f0                	sub    %esi,%eax
}
  800a03:	5b                   	pop    %ebx
  800a04:	5e                   	pop    %esi
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a10:	eb 06                	jmp    800a18 <strcmp+0x11>
		p++, q++;
  800a12:	83 c1 01             	add    $0x1,%ecx
  800a15:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a18:	0f b6 01             	movzbl (%ecx),%eax
  800a1b:	84 c0                	test   %al,%al
  800a1d:	74 04                	je     800a23 <strcmp+0x1c>
  800a1f:	3a 02                	cmp    (%edx),%al
  800a21:	74 ef                	je     800a12 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a23:	0f b6 c0             	movzbl %al,%eax
  800a26:	0f b6 12             	movzbl (%edx),%edx
  800a29:	29 d0                	sub    %edx,%eax
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	53                   	push   %ebx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a37:	89 c3                	mov    %eax,%ebx
  800a39:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a3c:	eb 06                	jmp    800a44 <strncmp+0x17>
		n--, p++, q++;
  800a3e:	83 c0 01             	add    $0x1,%eax
  800a41:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a44:	39 d8                	cmp    %ebx,%eax
  800a46:	74 18                	je     800a60 <strncmp+0x33>
  800a48:	0f b6 08             	movzbl (%eax),%ecx
  800a4b:	84 c9                	test   %cl,%cl
  800a4d:	74 04                	je     800a53 <strncmp+0x26>
  800a4f:	3a 0a                	cmp    (%edx),%cl
  800a51:	74 eb                	je     800a3e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a53:	0f b6 00             	movzbl (%eax),%eax
  800a56:	0f b6 12             	movzbl (%edx),%edx
  800a59:	29 d0                	sub    %edx,%eax
}
  800a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a5e:	c9                   	leave  
  800a5f:	c3                   	ret    
		return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	eb f4                	jmp    800a5b <strncmp+0x2e>

00800a67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a71:	eb 03                	jmp    800a76 <strchr+0xf>
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	0f b6 10             	movzbl (%eax),%edx
  800a79:	84 d2                	test   %dl,%dl
  800a7b:	74 06                	je     800a83 <strchr+0x1c>
		if (*s == c)
  800a7d:	38 ca                	cmp    %cl,%dl
  800a7f:	75 f2                	jne    800a73 <strchr+0xc>
  800a81:	eb 05                	jmp    800a88 <strchr+0x21>
			return (char *) s;
	return 0;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a94:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a97:	38 ca                	cmp    %cl,%dl
  800a99:	74 09                	je     800aa4 <strfind+0x1a>
  800a9b:	84 d2                	test   %dl,%dl
  800a9d:	74 05                	je     800aa4 <strfind+0x1a>
	for (; *s; s++)
  800a9f:	83 c0 01             	add    $0x1,%eax
  800aa2:	eb f0                	jmp    800a94 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab2:	85 c9                	test   %ecx,%ecx
  800ab4:	74 2f                	je     800ae5 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab6:	89 f8                	mov    %edi,%eax
  800ab8:	09 c8                	or     %ecx,%eax
  800aba:	a8 03                	test   $0x3,%al
  800abc:	75 21                	jne    800adf <memset+0x39>
		c &= 0xFF;
  800abe:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	c1 e0 08             	shl    $0x8,%eax
  800ac7:	89 d3                	mov    %edx,%ebx
  800ac9:	c1 e3 18             	shl    $0x18,%ebx
  800acc:	89 d6                	mov    %edx,%esi
  800ace:	c1 e6 10             	shl    $0x10,%esi
  800ad1:	09 f3                	or     %esi,%ebx
  800ad3:	09 da                	or     %ebx,%edx
  800ad5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ada:	fc                   	cld    
  800adb:	f3 ab                	rep stos %eax,%es:(%edi)
  800add:	eb 06                	jmp    800ae5 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	fc                   	cld    
  800ae3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae5:	89 f8                	mov    %edi,%eax
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afa:	39 c6                	cmp    %eax,%esi
  800afc:	73 32                	jae    800b30 <memmove+0x44>
  800afe:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b01:	39 c2                	cmp    %eax,%edx
  800b03:	76 2b                	jbe    800b30 <memmove+0x44>
		s += n;
		d += n;
  800b05:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	09 fe                	or     %edi,%esi
  800b0c:	09 ce                	or     %ecx,%esi
  800b0e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b14:	75 0e                	jne    800b24 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b16:	83 ef 04             	sub    $0x4,%edi
  800b19:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1f:	fd                   	std    
  800b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b22:	eb 09                	jmp    800b2d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b24:	83 ef 01             	sub    $0x1,%edi
  800b27:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2a:	fd                   	std    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b2d:	fc                   	cld    
  800b2e:	eb 1a                	jmp    800b4a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	89 f2                	mov    %esi,%edx
  800b32:	09 c2                	or     %eax,%edx
  800b34:	09 ca                	or     %ecx,%edx
  800b36:	f6 c2 03             	test   $0x3,%dl
  800b39:	75 0a                	jne    800b45 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b3e:	89 c7                	mov    %eax,%edi
  800b40:	fc                   	cld    
  800b41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b43:	eb 05                	jmp    800b4a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b45:	89 c7                	mov    %eax,%edi
  800b47:	fc                   	cld    
  800b48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b54:	ff 75 10             	push   0x10(%ebp)
  800b57:	ff 75 0c             	push   0xc(%ebp)
  800b5a:	ff 75 08             	push   0x8(%ebp)
  800b5d:	e8 8a ff ff ff       	call   800aec <memmove>
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6f:	89 c6                	mov    %eax,%esi
  800b71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b74:	eb 06                	jmp    800b7c <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b7c:	39 f0                	cmp    %esi,%eax
  800b7e:	74 14                	je     800b94 <memcmp+0x30>
		if (*s1 != *s2)
  800b80:	0f b6 08             	movzbl (%eax),%ecx
  800b83:	0f b6 1a             	movzbl (%edx),%ebx
  800b86:	38 d9                	cmp    %bl,%cl
  800b88:	74 ec                	je     800b76 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b8a:	0f b6 c1             	movzbl %cl,%eax
  800b8d:	0f b6 db             	movzbl %bl,%ebx
  800b90:	29 d8                	sub    %ebx,%eax
  800b92:	eb 05                	jmp    800b99 <memcmp+0x35>
	}

	return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba6:	89 c2                	mov    %eax,%edx
  800ba8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bab:	eb 03                	jmp    800bb0 <memfind+0x13>
  800bad:	83 c0 01             	add    $0x1,%eax
  800bb0:	39 d0                	cmp    %edx,%eax
  800bb2:	73 04                	jae    800bb8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb4:	38 08                	cmp    %cl,(%eax)
  800bb6:	75 f5                	jne    800bad <memfind+0x10>
			break;
	return (void *) s;
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
  800bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc6:	eb 03                	jmp    800bcb <strtol+0x11>
		s++;
  800bc8:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800bcb:	0f b6 02             	movzbl (%edx),%eax
  800bce:	3c 20                	cmp    $0x20,%al
  800bd0:	74 f6                	je     800bc8 <strtol+0xe>
  800bd2:	3c 09                	cmp    $0x9,%al
  800bd4:	74 f2                	je     800bc8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd6:	3c 2b                	cmp    $0x2b,%al
  800bd8:	74 2a                	je     800c04 <strtol+0x4a>
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bdf:	3c 2d                	cmp    $0x2d,%al
  800be1:	74 2b                	je     800c0e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be9:	75 0f                	jne    800bfa <strtol+0x40>
  800beb:	80 3a 30             	cmpb   $0x30,(%edx)
  800bee:	74 28                	je     800c18 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf7:	0f 44 d8             	cmove  %eax,%ebx
  800bfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bff:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c02:	eb 46                	jmp    800c4a <strtol+0x90>
		s++;
  800c04:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c07:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0c:	eb d5                	jmp    800be3 <strtol+0x29>
		s++, neg = 1;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	bf 01 00 00 00       	mov    $0x1,%edi
  800c16:	eb cb                	jmp    800be3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c18:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c1c:	74 0e                	je     800c2c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c1e:	85 db                	test   %ebx,%ebx
  800c20:	75 d8                	jne    800bfa <strtol+0x40>
		s++, base = 8;
  800c22:	83 c2 01             	add    $0x1,%edx
  800c25:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2a:	eb ce                	jmp    800bfa <strtol+0x40>
		s += 2, base = 16;
  800c2c:	83 c2 02             	add    $0x2,%edx
  800c2f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c34:	eb c4                	jmp    800bfa <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c36:	0f be c0             	movsbl %al,%eax
  800c39:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c3f:	7d 3a                	jge    800c7b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c41:	83 c2 01             	add    $0x1,%edx
  800c44:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800c48:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800c4a:	0f b6 02             	movzbl (%edx),%eax
  800c4d:	8d 70 d0             	lea    -0x30(%eax),%esi
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	80 fb 09             	cmp    $0x9,%bl
  800c55:	76 df                	jbe    800c36 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c57:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c5a:	89 f3                	mov    %esi,%ebx
  800c5c:	80 fb 19             	cmp    $0x19,%bl
  800c5f:	77 08                	ja     800c69 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c61:	0f be c0             	movsbl %al,%eax
  800c64:	83 e8 57             	sub    $0x57,%eax
  800c67:	eb d3                	jmp    800c3c <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c69:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c6c:	89 f3                	mov    %esi,%ebx
  800c6e:	80 fb 19             	cmp    $0x19,%bl
  800c71:	77 08                	ja     800c7b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c73:	0f be c0             	movsbl %al,%eax
  800c76:	83 e8 37             	sub    $0x37,%eax
  800c79:	eb c1                	jmp    800c3c <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7f:	74 05                	je     800c86 <strtol+0xcc>
		*endptr = (char *) s;
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c86:	89 c8                	mov    %ecx,%eax
  800c88:	f7 d8                	neg    %eax
  800c8a:	85 ff                	test   %edi,%edi
  800c8c:	0f 45 c8             	cmovne %eax,%ecx
}
  800c8f:	89 c8                	mov    %ecx,%eax
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca7:	89 c3                	mov    %eax,%ebx
  800ca9:	89 c7                	mov    %eax,%edi
  800cab:	89 c6                	mov    %eax,%esi
  800cad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce9:	89 cb                	mov    %ecx,%ebx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	89 ce                	mov    %ecx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 03                	push   $0x3
  800d03:	68 9f 19 80 00       	push   $0x80199f
  800d08:	6a 23                	push   $0x23
  800d0a:	68 bc 19 80 00       	push   $0x8019bc
  800d0f:	e8 9a 05 00 00       	call   8012ae <_panic>

00800d14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 02 00 00 00       	mov    $0x2,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_yield>:

void
sys_yield(void)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d43:	89 d1                	mov    %edx,%ecx
  800d45:	89 d3                	mov    %edx,%ebx
  800d47:	89 d7                	mov    %edx,%edi
  800d49:	89 d6                	mov    %edx,%esi
  800d4b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	be 00 00 00 00       	mov    $0x0,%esi
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6e:	89 f7                	mov    %esi,%edi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	50                   	push   %eax
  800d82:	6a 04                	push   $0x4
  800d84:	68 9f 19 80 00       	push   $0x80199f
  800d89:	6a 23                	push   $0x23
  800d8b:	68 bc 19 80 00       	push   $0x8019bc
  800d90:	e8 19 05 00 00       	call   8012ae <_panic>

00800d95 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 05 00 00 00       	mov    $0x5,%eax
  800da9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800daf:	8b 75 18             	mov    0x18(%ebp),%esi
  800db2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7f 08                	jg     800dc0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	50                   	push   %eax
  800dc4:	6a 05                	push   $0x5
  800dc6:	68 9f 19 80 00       	push   $0x80199f
  800dcb:	6a 23                	push   $0x23
  800dcd:	68 bc 19 80 00       	push   $0x8019bc
  800dd2:	e8 d7 04 00 00       	call   8012ae <_panic>

00800dd7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	b8 06 00 00 00       	mov    $0x6,%eax
  800df0:	89 df                	mov    %ebx,%edi
  800df2:	89 de                	mov    %ebx,%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 06                	push   $0x6
  800e08:	68 9f 19 80 00       	push   $0x80199f
  800e0d:	6a 23                	push   $0x23
  800e0f:	68 bc 19 80 00       	push   $0x8019bc
  800e14:	e8 95 04 00 00       	call   8012ae <_panic>

00800e19 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	89 de                	mov    %ebx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 08                	push   $0x8
  800e4a:	68 9f 19 80 00       	push   $0x80199f
  800e4f:	6a 23                	push   $0x23
  800e51:	68 bc 19 80 00       	push   $0x8019bc
  800e56:	e8 53 04 00 00       	call   8012ae <_panic>

00800e5b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e74:	89 df                	mov    %ebx,%edi
  800e76:	89 de                	mov    %ebx,%esi
  800e78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	7f 08                	jg     800e86 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 09                	push   $0x9
  800e8c:	68 9f 19 80 00       	push   $0x80199f
  800e91:	6a 23                	push   $0x23
  800e93:	68 bc 19 80 00       	push   $0x8019bc
  800e98:	e8 11 04 00 00       	call   8012ae <_panic>

00800e9d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7f 08                	jg     800ec8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 0a                	push   $0xa
  800ece:	68 9f 19 80 00       	push   $0x80199f
  800ed3:	6a 23                	push   $0x23
  800ed5:	68 bc 19 80 00       	push   $0x8019bc
  800eda:	e8 cf 03 00 00       	call   8012ae <_panic>

00800edf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef0:	be 00 00 00 00       	mov    $0x0,%esi
  800ef5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f18:	89 cb                	mov    %ecx,%ebx
  800f1a:	89 cf                	mov    %ecx,%edi
  800f1c:	89 ce                	mov    %ecx,%esi
  800f1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7f 08                	jg     800f2c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	50                   	push   %eax
  800f30:	6a 0d                	push   $0xd
  800f32:	68 9f 19 80 00       	push   $0x80199f
  800f37:	6a 23                	push   $0x23
  800f39:	68 bc 19 80 00       	push   $0x8019bc
  800f3e:	e8 6b 03 00 00       	call   8012ae <_panic>

00800f43 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	53                   	push   %ebx
  800f47:	83 ec 04             	sub    $0x4,%esp
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f4d:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800f4f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f53:	0f 84 99 00 00 00    	je     800ff2 <pgfault+0xaf>
  800f59:	89 d8                	mov    %ebx,%eax
  800f5b:	c1 e8 16             	shr    $0x16,%eax
  800f5e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f65:	a8 01                	test   $0x1,%al
  800f67:	0f 84 85 00 00 00    	je     800ff2 <pgfault+0xaf>
  800f6d:	89 d8                	mov    %ebx,%eax
  800f6f:	c1 e8 0c             	shr    $0xc,%eax
  800f72:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f79:	f6 c6 08             	test   $0x8,%dh
  800f7c:	74 74                	je     800ff2 <pgfault+0xaf>
  800f7e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f85:	a8 01                	test   $0x1,%al
  800f87:	74 69                	je     800ff2 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	6a 07                	push   $0x7
  800f8e:	68 00 f0 7f 00       	push   $0x7ff000
  800f93:	6a 00                	push   $0x0
  800f95:	e8 b8 fd ff ff       	call   800d52 <sys_page_alloc>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 65                	js     801006 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800fa1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800fa7:	83 ec 04             	sub    $0x4,%esp
  800faa:	68 00 10 00 00       	push   $0x1000
  800faf:	53                   	push   %ebx
  800fb0:	68 00 f0 7f 00       	push   $0x7ff000
  800fb5:	e8 94 fb ff ff       	call   800b4e <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800fba:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fc1:	53                   	push   %ebx
  800fc2:	6a 00                	push   $0x0
  800fc4:	68 00 f0 7f 00       	push   $0x7ff000
  800fc9:	6a 00                	push   $0x0
  800fcb:	e8 c5 fd ff ff       	call   800d95 <sys_page_map>
  800fd0:	83 c4 20             	add    $0x20,%esp
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 43                	js     80101a <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	68 00 f0 7f 00       	push   $0x7ff000
  800fdf:	6a 00                	push   $0x0
  800fe1:	e8 f1 fd ff ff       	call   800dd7 <sys_page_unmap>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	78 41                	js     80102e <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    
		panic("invalid permision\n");
  800ff2:	83 ec 04             	sub    $0x4,%esp
  800ff5:	68 ca 19 80 00       	push   $0x8019ca
  800ffa:	6a 1f                	push   $0x1f
  800ffc:	68 dd 19 80 00       	push   $0x8019dd
  801001:	e8 a8 02 00 00       	call   8012ae <_panic>
		panic("Unable to alloc page\n");
  801006:	83 ec 04             	sub    $0x4,%esp
  801009:	68 e8 19 80 00       	push   $0x8019e8
  80100e:	6a 28                	push   $0x28
  801010:	68 dd 19 80 00       	push   $0x8019dd
  801015:	e8 94 02 00 00       	call   8012ae <_panic>
		panic("Unable to map\n");
  80101a:	83 ec 04             	sub    $0x4,%esp
  80101d:	68 fe 19 80 00       	push   $0x8019fe
  801022:	6a 2b                	push   $0x2b
  801024:	68 dd 19 80 00       	push   $0x8019dd
  801029:	e8 80 02 00 00       	call   8012ae <_panic>
		panic("Unable to unmap\n");
  80102e:	83 ec 04             	sub    $0x4,%esp
  801031:	68 0d 1a 80 00       	push   $0x801a0d
  801036:	6a 2d                	push   $0x2d
  801038:	68 dd 19 80 00       	push   $0x8019dd
  80103d:	e8 6c 02 00 00       	call   8012ae <_panic>

00801042 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  80104b:	68 43 0f 80 00       	push   $0x800f43
  801050:	e8 9f 02 00 00       	call   8012f4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801055:	b8 07 00 00 00       	mov    $0x7,%eax
  80105a:	cd 30                	int    $0x30
  80105c:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	78 23                	js     801088 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801065:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  80106a:	75 6d                	jne    8010d9 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  80106c:	e8 a3 fc ff ff       	call   800d14 <sys_getenvid>
  801071:	25 ff 03 00 00       	and    $0x3ff,%eax
  801076:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80107e:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  801083:	e9 02 01 00 00       	jmp    80118a <fork+0x148>
		panic("sys_exofork: %e", envid);
  801088:	50                   	push   %eax
  801089:	68 1e 1a 80 00       	push   $0x801a1e
  80108e:	6a 6d                	push   $0x6d
  801090:	68 dd 19 80 00       	push   $0x8019dd
  801095:	e8 14 02 00 00       	call   8012ae <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80109a:	c1 e0 0c             	shl    $0xc,%eax
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010a6:	52                   	push   %edx
  8010a7:	50                   	push   %eax
  8010a8:	56                   	push   %esi
  8010a9:	50                   	push   %eax
  8010aa:	6a 00                	push   $0x0
  8010ac:	e8 e4 fc ff ff       	call   800d95 <sys_page_map>
  8010b1:	83 c4 20             	add    $0x20,%esp
  8010b4:	eb 15                	jmp    8010cb <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  8010b6:	c1 e0 0c             	shl    $0xc,%eax
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	6a 05                	push   $0x5
  8010be:	50                   	push   %eax
  8010bf:	56                   	push   %esi
  8010c0:	50                   	push   %eax
  8010c1:	6a 00                	push   $0x0
  8010c3:	e8 cd fc ff ff       	call   800d95 <sys_page_map>
  8010c8:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8010cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010d1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010d7:	74 7a                	je     801153 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  8010d9:	89 d8                	mov    %ebx,%eax
  8010db:	c1 e8 16             	shr    $0x16,%eax
  8010de:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  8010e5:	a8 01                	test   $0x1,%al
  8010e7:	74 e2                	je     8010cb <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	c1 e8 0c             	shr    $0xc,%eax
  8010ee:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  8010f5:	f6 c2 01             	test   $0x1,%dl
  8010f8:	74 d1                	je     8010cb <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  8010fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801101:	f6 c2 04             	test   $0x4,%dl
  801104:	74 c5                	je     8010cb <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801106:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80110d:	f6 c6 04             	test   $0x4,%dh
  801110:	75 88                	jne    80109a <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801112:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801118:	74 9c                	je     8010b6 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80111a:	c1 e0 0c             	shl    $0xc,%eax
  80111d:	89 c7                	mov    %eax,%edi
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	68 05 08 00 00       	push   $0x805
  801127:	50                   	push   %eax
  801128:	56                   	push   %esi
  801129:	50                   	push   %eax
  80112a:	6a 00                	push   $0x0
  80112c:	e8 64 fc ff ff       	call   800d95 <sys_page_map>
  801131:	83 c4 20             	add    $0x20,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	78 93                	js     8010cb <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	68 05 08 00 00       	push   $0x805
  801140:	57                   	push   %edi
  801141:	6a 00                	push   $0x0
  801143:	57                   	push   %edi
  801144:	6a 00                	push   $0x0
  801146:	e8 4a fc ff ff       	call   800d95 <sys_page_map>
  80114b:	83 c4 20             	add    $0x20,%esp
  80114e:	e9 78 ff ff ff       	jmp    8010cb <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801153:	83 ec 04             	sub    $0x4,%esp
  801156:	6a 07                	push   $0x7
  801158:	68 00 f0 bf ee       	push   $0xeebff000
  80115d:	56                   	push   %esi
  80115e:	e8 ef fb ff ff       	call   800d52 <sys_page_alloc>
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	78 2a                	js     801194 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	68 63 13 80 00       	push   $0x801363
  801172:	56                   	push   %esi
  801173:	e8 25 fd ff ff       	call   800e9d <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801178:	83 c4 08             	add    $0x8,%esp
  80117b:	6a 02                	push   $0x2
  80117d:	56                   	push   %esi
  80117e:	e8 96 fc ff ff       	call   800e19 <sys_env_set_status>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	78 21                	js     8011ab <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80118a:	89 f0                	mov    %esi,%eax
  80118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118f:	5b                   	pop    %ebx
  801190:	5e                   	pop    %esi
  801191:	5f                   	pop    %edi
  801192:	5d                   	pop    %ebp
  801193:	c3                   	ret    
		panic("failed to alloc page");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 2e 1a 80 00       	push   $0x801a2e
  80119c:	68 82 00 00 00       	push   $0x82
  8011a1:	68 dd 19 80 00       	push   $0x8019dd
  8011a6:	e8 03 01 00 00       	call   8012ae <_panic>
		panic("sys_env_set_status: %e", r);
  8011ab:	50                   	push   %eax
  8011ac:	68 43 1a 80 00       	push   $0x801a43
  8011b1:	68 89 00 00 00       	push   $0x89
  8011b6:	68 dd 19 80 00       	push   $0x8019dd
  8011bb:	e8 ee 00 00 00       	call   8012ae <_panic>

008011c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011c6:	68 5a 1a 80 00       	push   $0x801a5a
  8011cb:	68 92 00 00 00       	push   $0x92
  8011d0:	68 dd 19 80 00       	push   $0x8019dd
  8011d5:	e8 d4 00 00 00       	call   8012ae <_panic>

008011da <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	8b 75 08             	mov    0x8(%ebp),%esi
  8011e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	ff 75 0c             	push   0xc(%ebp)
  8011eb:	e8 12 fd ff ff       	call   800f02 <sys_ipc_recv>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	78 2b                	js     801222 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8011f7:	85 f6                	test   %esi,%esi
  8011f9:	74 0a                	je     801205 <ipc_recv+0x2b>
  8011fb:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801200:	8b 40 74             	mov    0x74(%eax),%eax
  801203:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801205:	85 db                	test   %ebx,%ebx
  801207:	74 0a                	je     801213 <ipc_recv+0x39>
  801209:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80120e:	8b 40 78             	mov    0x78(%eax),%eax
  801211:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801213:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801218:	8b 40 70             	mov    0x70(%eax),%eax
}
  80121b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121e:	5b                   	pop    %ebx
  80121f:	5e                   	pop    %esi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801222:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801227:	eb f2                	jmp    80121b <ipc_recv+0x41>

00801229 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 0c             	sub    $0xc,%esp
  801232:	8b 7d 08             	mov    0x8(%ebp),%edi
  801235:	8b 75 0c             	mov    0xc(%ebp),%esi
  801238:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80123b:	ff 75 14             	push   0x14(%ebp)
  80123e:	53                   	push   %ebx
  80123f:	56                   	push   %esi
  801240:	57                   	push   %edi
  801241:	e8 99 fc ff ff       	call   800edf <sys_ipc_try_send>
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	79 20                	jns    80126d <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80124d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801250:	75 07                	jne    801259 <ipc_send+0x30>
		sys_yield();
  801252:	e8 dc fa ff ff       	call   800d33 <sys_yield>
  801257:	eb e2                	jmp    80123b <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	68 70 1a 80 00       	push   $0x801a70
  801261:	6a 2e                	push   $0x2e
  801263:	68 80 1a 80 00       	push   $0x801a80
  801268:	e8 41 00 00 00       	call   8012ae <_panic>
	}
}
  80126d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801270:	5b                   	pop    %ebx
  801271:	5e                   	pop    %esi
  801272:	5f                   	pop    %edi
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80127b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801280:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801283:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801289:	8b 52 50             	mov    0x50(%edx),%edx
  80128c:	39 ca                	cmp    %ecx,%edx
  80128e:	74 11                	je     8012a1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801290:	83 c0 01             	add    $0x1,%eax
  801293:	3d 00 04 00 00       	cmp    $0x400,%eax
  801298:	75 e6                	jne    801280 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
  80129f:	eb 0b                	jmp    8012ac <ipc_find_env+0x37>
			return envs[i].env_id;
  8012a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012a9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	56                   	push   %esi
  8012b2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8012b3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012b6:	8b 35 08 20 80 00    	mov    0x802008,%esi
  8012bc:	e8 53 fa ff ff       	call   800d14 <sys_getenvid>
  8012c1:	83 ec 0c             	sub    $0xc,%esp
  8012c4:	ff 75 0c             	push   0xc(%ebp)
  8012c7:	ff 75 08             	push   0x8(%ebp)
  8012ca:	56                   	push   %esi
  8012cb:	50                   	push   %eax
  8012cc:	68 8c 1a 80 00       	push   $0x801a8c
  8012d1:	e8 bb ef ff ff       	call   800291 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012d6:	83 c4 18             	add    $0x18,%esp
  8012d9:	53                   	push   %ebx
  8012da:	ff 75 10             	push   0x10(%ebp)
  8012dd:	e8 5e ef ff ff       	call   800240 <vcprintf>
	cprintf("\n");
  8012e2:	c7 04 24 7e 1a 80 00 	movl   $0x801a7e,(%esp)
  8012e9:	e8 a3 ef ff ff       	call   800291 <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012f1:	cc                   	int3   
  8012f2:	eb fd                	jmp    8012f1 <_panic+0x43>

008012f4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8012fa:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  801301:	74 20                	je     801323 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	a3 10 20 80 00       	mov    %eax,0x802010
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	68 63 13 80 00       	push   $0x801363
  801313:	6a 00                	push   $0x0
  801315:	e8 83 fb ff ff       	call   800e9d <sys_env_set_pgfault_upcall>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 2e                	js     80134f <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801321:	c9                   	leave  
  801322:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	6a 07                	push   $0x7
  801328:	68 00 f0 bf ee       	push   $0xeebff000
  80132d:	6a 00                	push   $0x0
  80132f:	e8 1e fa ff ff       	call   800d52 <sys_page_alloc>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	79 c8                	jns    801303 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	68 b0 1a 80 00       	push   $0x801ab0
  801343:	6a 21                	push   $0x21
  801345:	68 13 1b 80 00       	push   $0x801b13
  80134a:	e8 5f ff ff ff       	call   8012ae <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	68 dc 1a 80 00       	push   $0x801adc
  801357:	6a 27                	push   $0x27
  801359:	68 13 1b 80 00       	push   $0x801b13
  80135e:	e8 4b ff ff ff       	call   8012ae <_panic>

00801363 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801363:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801364:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  801369:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80136b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  80136e:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  801372:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  801377:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  80137b:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  80137d:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801380:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  801381:	83 c4 04             	add    $0x4,%esp
	popfl
  801384:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801385:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801386:	c3                   	ret    
  801387:	66 90                	xchg   %ax,%ax
  801389:	66 90                	xchg   %ax,%ax
  80138b:	66 90                	xchg   %ax,%ax
  80138d:	66 90                	xchg   %ax,%ax
  80138f:	90                   	nop

00801390 <__udivdi3>:
  801390:	f3 0f 1e fb          	endbr32 
  801394:	55                   	push   %ebp
  801395:	57                   	push   %edi
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
  801398:	83 ec 1c             	sub    $0x1c,%esp
  80139b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80139f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8013a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8013a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 19                	jne    8013c8 <__udivdi3+0x38>
  8013af:	39 f3                	cmp    %esi,%ebx
  8013b1:	76 4d                	jbe    801400 <__udivdi3+0x70>
  8013b3:	31 ff                	xor    %edi,%edi
  8013b5:	89 e8                	mov    %ebp,%eax
  8013b7:	89 f2                	mov    %esi,%edx
  8013b9:	f7 f3                	div    %ebx
  8013bb:	89 fa                	mov    %edi,%edx
  8013bd:	83 c4 1c             	add    $0x1c,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    
  8013c5:	8d 76 00             	lea    0x0(%esi),%esi
  8013c8:	39 f0                	cmp    %esi,%eax
  8013ca:	76 14                	jbe    8013e0 <__udivdi3+0x50>
  8013cc:	31 ff                	xor    %edi,%edi
  8013ce:	31 c0                	xor    %eax,%eax
  8013d0:	89 fa                	mov    %edi,%edx
  8013d2:	83 c4 1c             	add    $0x1c,%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    
  8013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013e0:	0f bd f8             	bsr    %eax,%edi
  8013e3:	83 f7 1f             	xor    $0x1f,%edi
  8013e6:	75 48                	jne    801430 <__udivdi3+0xa0>
  8013e8:	39 f0                	cmp    %esi,%eax
  8013ea:	72 06                	jb     8013f2 <__udivdi3+0x62>
  8013ec:	31 c0                	xor    %eax,%eax
  8013ee:	39 eb                	cmp    %ebp,%ebx
  8013f0:	77 de                	ja     8013d0 <__udivdi3+0x40>
  8013f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f7:	eb d7                	jmp    8013d0 <__udivdi3+0x40>
  8013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801400:	89 d9                	mov    %ebx,%ecx
  801402:	85 db                	test   %ebx,%ebx
  801404:	75 0b                	jne    801411 <__udivdi3+0x81>
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
  80140b:	31 d2                	xor    %edx,%edx
  80140d:	f7 f3                	div    %ebx
  80140f:	89 c1                	mov    %eax,%ecx
  801411:	31 d2                	xor    %edx,%edx
  801413:	89 f0                	mov    %esi,%eax
  801415:	f7 f1                	div    %ecx
  801417:	89 c6                	mov    %eax,%esi
  801419:	89 e8                	mov    %ebp,%eax
  80141b:	89 f7                	mov    %esi,%edi
  80141d:	f7 f1                	div    %ecx
  80141f:	89 fa                	mov    %edi,%edx
  801421:	83 c4 1c             	add    $0x1c,%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
  801429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801430:	89 f9                	mov    %edi,%ecx
  801432:	ba 20 00 00 00       	mov    $0x20,%edx
  801437:	29 fa                	sub    %edi,%edx
  801439:	d3 e0                	shl    %cl,%eax
  80143b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80143f:	89 d1                	mov    %edx,%ecx
  801441:	89 d8                	mov    %ebx,%eax
  801443:	d3 e8                	shr    %cl,%eax
  801445:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801449:	09 c1                	or     %eax,%ecx
  80144b:	89 f0                	mov    %esi,%eax
  80144d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801451:	89 f9                	mov    %edi,%ecx
  801453:	d3 e3                	shl    %cl,%ebx
  801455:	89 d1                	mov    %edx,%ecx
  801457:	d3 e8                	shr    %cl,%eax
  801459:	89 f9                	mov    %edi,%ecx
  80145b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80145f:	89 eb                	mov    %ebp,%ebx
  801461:	d3 e6                	shl    %cl,%esi
  801463:	89 d1                	mov    %edx,%ecx
  801465:	d3 eb                	shr    %cl,%ebx
  801467:	09 f3                	or     %esi,%ebx
  801469:	89 c6                	mov    %eax,%esi
  80146b:	89 f2                	mov    %esi,%edx
  80146d:	89 d8                	mov    %ebx,%eax
  80146f:	f7 74 24 08          	divl   0x8(%esp)
  801473:	89 d6                	mov    %edx,%esi
  801475:	89 c3                	mov    %eax,%ebx
  801477:	f7 64 24 0c          	mull   0xc(%esp)
  80147b:	39 d6                	cmp    %edx,%esi
  80147d:	72 19                	jb     801498 <__udivdi3+0x108>
  80147f:	89 f9                	mov    %edi,%ecx
  801481:	d3 e5                	shl    %cl,%ebp
  801483:	39 c5                	cmp    %eax,%ebp
  801485:	73 04                	jae    80148b <__udivdi3+0xfb>
  801487:	39 d6                	cmp    %edx,%esi
  801489:	74 0d                	je     801498 <__udivdi3+0x108>
  80148b:	89 d8                	mov    %ebx,%eax
  80148d:	31 ff                	xor    %edi,%edi
  80148f:	e9 3c ff ff ff       	jmp    8013d0 <__udivdi3+0x40>
  801494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801498:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80149b:	31 ff                	xor    %edi,%edi
  80149d:	e9 2e ff ff ff       	jmp    8013d0 <__udivdi3+0x40>
  8014a2:	66 90                	xchg   %ax,%ax
  8014a4:	66 90                	xchg   %ax,%ax
  8014a6:	66 90                	xchg   %ax,%ax
  8014a8:	66 90                	xchg   %ax,%ax
  8014aa:	66 90                	xchg   %ax,%ax
  8014ac:	66 90                	xchg   %ax,%ax
  8014ae:	66 90                	xchg   %ax,%ax

008014b0 <__umoddi3>:
  8014b0:	f3 0f 1e fb          	endbr32 
  8014b4:	55                   	push   %ebp
  8014b5:	57                   	push   %edi
  8014b6:	56                   	push   %esi
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 1c             	sub    $0x1c,%esp
  8014bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8014bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8014c3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8014c7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  8014cb:	89 f0                	mov    %esi,%eax
  8014cd:	89 da                	mov    %ebx,%edx
  8014cf:	85 ff                	test   %edi,%edi
  8014d1:	75 15                	jne    8014e8 <__umoddi3+0x38>
  8014d3:	39 dd                	cmp    %ebx,%ebp
  8014d5:	76 39                	jbe    801510 <__umoddi3+0x60>
  8014d7:	f7 f5                	div    %ebp
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	31 d2                	xor    %edx,%edx
  8014dd:	83 c4 1c             	add    $0x1c,%esp
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    
  8014e5:	8d 76 00             	lea    0x0(%esi),%esi
  8014e8:	39 df                	cmp    %ebx,%edi
  8014ea:	77 f1                	ja     8014dd <__umoddi3+0x2d>
  8014ec:	0f bd cf             	bsr    %edi,%ecx
  8014ef:	83 f1 1f             	xor    $0x1f,%ecx
  8014f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014f6:	75 40                	jne    801538 <__umoddi3+0x88>
  8014f8:	39 df                	cmp    %ebx,%edi
  8014fa:	72 04                	jb     801500 <__umoddi3+0x50>
  8014fc:	39 f5                	cmp    %esi,%ebp
  8014fe:	77 dd                	ja     8014dd <__umoddi3+0x2d>
  801500:	89 da                	mov    %ebx,%edx
  801502:	89 f0                	mov    %esi,%eax
  801504:	29 e8                	sub    %ebp,%eax
  801506:	19 fa                	sbb    %edi,%edx
  801508:	eb d3                	jmp    8014dd <__umoddi3+0x2d>
  80150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801510:	89 e9                	mov    %ebp,%ecx
  801512:	85 ed                	test   %ebp,%ebp
  801514:	75 0b                	jne    801521 <__umoddi3+0x71>
  801516:	b8 01 00 00 00       	mov    $0x1,%eax
  80151b:	31 d2                	xor    %edx,%edx
  80151d:	f7 f5                	div    %ebp
  80151f:	89 c1                	mov    %eax,%ecx
  801521:	89 d8                	mov    %ebx,%eax
  801523:	31 d2                	xor    %edx,%edx
  801525:	f7 f1                	div    %ecx
  801527:	89 f0                	mov    %esi,%eax
  801529:	f7 f1                	div    %ecx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	31 d2                	xor    %edx,%edx
  80152f:	eb ac                	jmp    8014dd <__umoddi3+0x2d>
  801531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801538:	8b 44 24 04          	mov    0x4(%esp),%eax
  80153c:	ba 20 00 00 00       	mov    $0x20,%edx
  801541:	29 c2                	sub    %eax,%edx
  801543:	89 c1                	mov    %eax,%ecx
  801545:	89 e8                	mov    %ebp,%eax
  801547:	d3 e7                	shl    %cl,%edi
  801549:	89 d1                	mov    %edx,%ecx
  80154b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80154f:	d3 e8                	shr    %cl,%eax
  801551:	89 c1                	mov    %eax,%ecx
  801553:	8b 44 24 04          	mov    0x4(%esp),%eax
  801557:	09 f9                	or     %edi,%ecx
  801559:	89 df                	mov    %ebx,%edi
  80155b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80155f:	89 c1                	mov    %eax,%ecx
  801561:	d3 e5                	shl    %cl,%ebp
  801563:	89 d1                	mov    %edx,%ecx
  801565:	d3 ef                	shr    %cl,%edi
  801567:	89 c1                	mov    %eax,%ecx
  801569:	89 f0                	mov    %esi,%eax
  80156b:	d3 e3                	shl    %cl,%ebx
  80156d:	89 d1                	mov    %edx,%ecx
  80156f:	89 fa                	mov    %edi,%edx
  801571:	d3 e8                	shr    %cl,%eax
  801573:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801578:	09 d8                	or     %ebx,%eax
  80157a:	f7 74 24 08          	divl   0x8(%esp)
  80157e:	89 d3                	mov    %edx,%ebx
  801580:	d3 e6                	shl    %cl,%esi
  801582:	f7 e5                	mul    %ebp
  801584:	89 c7                	mov    %eax,%edi
  801586:	89 d1                	mov    %edx,%ecx
  801588:	39 d3                	cmp    %edx,%ebx
  80158a:	72 06                	jb     801592 <__umoddi3+0xe2>
  80158c:	75 0e                	jne    80159c <__umoddi3+0xec>
  80158e:	39 c6                	cmp    %eax,%esi
  801590:	73 0a                	jae    80159c <__umoddi3+0xec>
  801592:	29 e8                	sub    %ebp,%eax
  801594:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801598:	89 d1                	mov    %edx,%ecx
  80159a:	89 c7                	mov    %eax,%edi
  80159c:	89 f5                	mov    %esi,%ebp
  80159e:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015a2:	29 fd                	sub    %edi,%ebp
  8015a4:	19 cb                	sbb    %ecx,%ebx
  8015a6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8015ab:	89 d8                	mov    %ebx,%eax
  8015ad:	d3 e0                	shl    %cl,%eax
  8015af:	89 f1                	mov    %esi,%ecx
  8015b1:	d3 ed                	shr    %cl,%ebp
  8015b3:	d3 eb                	shr    %cl,%ebx
  8015b5:	09 e8                	or     %ebp,%eax
  8015b7:	89 da                	mov    %ebx,%edx
  8015b9:	83 c4 1c             	add    $0x1c,%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    
