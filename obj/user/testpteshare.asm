
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 30 80 00    	push   0x803000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 43 09 00 00       	call   80098c <strcpy>
	exit();
  800049:	e8 8c 01 00 00       	call   8001da <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 10 0d 00 00       	call   800d88 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 f0 0f 00 00       	call   801078 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 55 17 00 00       	call   8017f6 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 30 80 00    	push   0x803004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 89 09 00 00       	call   800a3d <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 20 29 80 00       	mov    $0x802920,%eax
  8000be:	ba 26 29 80 00       	mov    $0x802926,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 53 29 80 00       	push   $0x802953
  8000cc:	e8 f6 01 00 00       	call   8002c7 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 6e 29 80 00       	push   $0x80296e
  8000d8:	68 73 29 80 00       	push   $0x802973
  8000dd:	68 72 29 80 00       	push   $0x802972
  8000e2:	e8 6a 16 00 00       	call   801751 <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 fb 16 00 00       	call   8017f6 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 30 80 00    	push   0x803000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 2f 09 00 00       	call   800a3d <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 20 29 80 00       	mov    $0x802920,%eax
  800118:	ba 26 29 80 00       	mov    $0x802926,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 8a 29 80 00       	push   $0x80298a
  800126:	e8 9c 01 00 00       	call   8002c7 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 2c 29 80 00       	push   $0x80292c
  800144:	6a 13                	push   $0x13
  800146:	68 3f 29 80 00       	push   $0x80293f
  80014b:	e8 9c 00 00 00       	call   8001ec <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 85 2d 80 00       	push   $0x802d85
  800156:	6a 17                	push   $0x17
  800158:	68 3f 29 80 00       	push   $0x80293f
  80015d:	e8 8a 00 00 00       	call   8001ec <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 30 80 00    	push   0x803004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 17 08 00 00       	call   80098c <strcpy>
		exit();
  800175:	e8 60 00 00 00       	call   8001da <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 80 29 80 00       	push   $0x802980
  800188:	6a 21                	push   $0x21
  80018a:	68 3f 29 80 00       	push   $0x80293f
  80018f:	e8 58 00 00 00       	call   8001ec <_panic>

00800194 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80019f:	e8 a6 0b 00 00       	call   800d4a <sys_getenvid>
  8001a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b6:	85 db                	test   %ebx,%ebx
  8001b8:	7e 07                	jle    8001c1 <libmain+0x2d>
		binaryname = argv[0];
  8001ba:	8b 06                	mov    (%esi),%eax
  8001bc:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	e8 88 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cb:	e8 0a 00 00 00       	call   8001da <exit>
}
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5e                   	pop    %esi
  8001d8:	5d                   	pop    %ebp
  8001d9:	c3                   	ret    

008001da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001e0:	6a 00                	push   $0x0
  8001e2:	e8 22 0b 00 00       	call   800d09 <sys_env_destroy>
}
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001f1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f4:	8b 35 08 30 80 00    	mov    0x803008,%esi
  8001fa:	e8 4b 0b 00 00       	call   800d4a <sys_getenvid>
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	ff 75 0c             	push   0xc(%ebp)
  800205:	ff 75 08             	push   0x8(%ebp)
  800208:	56                   	push   %esi
  800209:	50                   	push   %eax
  80020a:	68 d0 29 80 00       	push   $0x8029d0
  80020f:	e8 b3 00 00 00       	call   8002c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800214:	83 c4 18             	add    $0x18,%esp
  800217:	53                   	push   %ebx
  800218:	ff 75 10             	push   0x10(%ebp)
  80021b:	e8 56 00 00 00       	call   800276 <vcprintf>
	cprintf("\n");
  800220:	c7 04 24 d7 2f 80 00 	movl   $0x802fd7,(%esp)
  800227:	e8 9b 00 00 00       	call   8002c7 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80022f:	cc                   	int3   
  800230:	eb fd                	jmp    80022f <_panic+0x43>

00800232 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	53                   	push   %ebx
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023c:	8b 13                	mov    (%ebx),%edx
  80023e:	8d 42 01             	lea    0x1(%edx),%eax
  800241:	89 03                	mov    %eax,(%ebx)
  800243:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800246:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80024a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024f:	74 09                	je     80025a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800251:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800258:	c9                   	leave  
  800259:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	68 ff 00 00 00       	push   $0xff
  800262:	8d 43 08             	lea    0x8(%ebx),%eax
  800265:	50                   	push   %eax
  800266:	e8 61 0a 00 00       	call   800ccc <sys_cputs>
		b->idx = 0;
  80026b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	eb db                	jmp    800251 <putch+0x1f>

00800276 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800286:	00 00 00 
	b.cnt = 0;
  800289:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800290:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800293:	ff 75 0c             	push   0xc(%ebp)
  800296:	ff 75 08             	push   0x8(%ebp)
  800299:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	68 32 02 80 00       	push   $0x800232
  8002a5:	e8 14 01 00 00       	call   8003be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002aa:	83 c4 08             	add    $0x8,%esp
  8002ad:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8002b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b9:	50                   	push   %eax
  8002ba:	e8 0d 0a 00 00       	call   800ccc <sys_cputs>

	return b.cnt;
}
  8002bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d0:	50                   	push   %eax
  8002d1:	ff 75 08             	push   0x8(%ebp)
  8002d4:	e8 9d ff ff ff       	call   800276 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	57                   	push   %edi
  8002df:	56                   	push   %esi
  8002e0:	53                   	push   %ebx
  8002e1:	83 ec 1c             	sub    $0x1c,%esp
  8002e4:	89 c7                	mov    %eax,%edi
  8002e6:	89 d6                	mov    %edx,%esi
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ee:	89 d1                	mov    %edx,%ecx
  8002f0:	89 c2                	mov    %eax,%edx
  8002f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800301:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800308:	39 c2                	cmp    %eax,%edx
  80030a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80030d:	72 3e                	jb     80034d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	ff 75 18             	push   0x18(%ebp)
  800315:	83 eb 01             	sub    $0x1,%ebx
  800318:	53                   	push   %ebx
  800319:	50                   	push   %eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 e4             	push   -0x1c(%ebp)
  800320:	ff 75 e0             	push   -0x20(%ebp)
  800323:	ff 75 dc             	push   -0x24(%ebp)
  800326:	ff 75 d8             	push   -0x28(%ebp)
  800329:	e8 a2 23 00 00       	call   8026d0 <__udivdi3>
  80032e:	83 c4 18             	add    $0x18,%esp
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	89 f2                	mov    %esi,%edx
  800335:	89 f8                	mov    %edi,%eax
  800337:	e8 9f ff ff ff       	call   8002db <printnum>
  80033c:	83 c4 20             	add    $0x20,%esp
  80033f:	eb 13                	jmp    800354 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	56                   	push   %esi
  800345:	ff 75 18             	push   0x18(%ebp)
  800348:	ff d7                	call   *%edi
  80034a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80034d:	83 eb 01             	sub    $0x1,%ebx
  800350:	85 db                	test   %ebx,%ebx
  800352:	7f ed                	jg     800341 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	56                   	push   %esi
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	ff 75 e4             	push   -0x1c(%ebp)
  80035e:	ff 75 e0             	push   -0x20(%ebp)
  800361:	ff 75 dc             	push   -0x24(%ebp)
  800364:	ff 75 d8             	push   -0x28(%ebp)
  800367:	e8 84 24 00 00       	call   8027f0 <__umoddi3>
  80036c:	83 c4 14             	add    $0x14,%esp
  80036f:	0f be 80 f3 29 80 00 	movsbl 0x8029f3(%eax),%eax
  800376:	50                   	push   %eax
  800377:	ff d7                	call   *%edi
}
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038e:	8b 10                	mov    (%eax),%edx
  800390:	3b 50 04             	cmp    0x4(%eax),%edx
  800393:	73 0a                	jae    80039f <sprintputch+0x1b>
		*b->buf++ = ch;
  800395:	8d 4a 01             	lea    0x1(%edx),%ecx
  800398:	89 08                	mov    %ecx,(%eax)
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	88 02                	mov    %al,(%edx)
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <printfmt>:
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003aa:	50                   	push   %eax
  8003ab:	ff 75 10             	push   0x10(%ebp)
  8003ae:	ff 75 0c             	push   0xc(%ebp)
  8003b1:	ff 75 08             	push   0x8(%ebp)
  8003b4:	e8 05 00 00 00       	call   8003be <vprintfmt>
}
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <vprintfmt>:
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 3c             	sub    $0x3c,%esp
  8003c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d0:	eb 0a                	jmp    8003dc <vprintfmt+0x1e>
			putch(ch, putdat);
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	53                   	push   %ebx
  8003d6:	50                   	push   %eax
  8003d7:	ff d6                	call   *%esi
  8003d9:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003dc:	83 c7 01             	add    $0x1,%edi
  8003df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003e3:	83 f8 25             	cmp    $0x25,%eax
  8003e6:	74 0c                	je     8003f4 <vprintfmt+0x36>
			if (ch == '\0')
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	75 e6                	jne    8003d2 <vprintfmt+0x14>
}
  8003ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ef:	5b                   	pop    %ebx
  8003f0:	5e                   	pop    %esi
  8003f1:	5f                   	pop    %edi
  8003f2:	5d                   	pop    %ebp
  8003f3:	c3                   	ret    
		padc = ' ';
  8003f4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003f8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800406:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80040d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800412:	8d 47 01             	lea    0x1(%edi),%eax
  800415:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800418:	0f b6 17             	movzbl (%edi),%edx
  80041b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041e:	3c 55                	cmp    $0x55,%al
  800420:	0f 87 a6 04 00 00    	ja     8008cc <vprintfmt+0x50e>
  800426:	0f b6 c0             	movzbl %al,%eax
  800429:	ff 24 85 40 2b 80 00 	jmp    *0x802b40(,%eax,4)
  800430:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800433:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800437:	eb d9                	jmp    800412 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80043c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800440:	eb d0                	jmp    800412 <vprintfmt+0x54>
  800442:	0f b6 d2             	movzbl %dl,%edx
  800445:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800448:	b8 00 00 00 00       	mov    $0x0,%eax
  80044d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800450:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800453:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800457:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80045d:	83 f9 09             	cmp    $0x9,%ecx
  800460:	77 55                	ja     8004b7 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800462:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800465:	eb e9                	jmp    800450 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046f:	8b 45 14             	mov    0x14(%ebp),%eax
  800472:	8d 40 04             	lea    0x4(%eax),%eax
  800475:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80047b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80047f:	79 91                	jns    800412 <vprintfmt+0x54>
				width = precision, precision = -1;
  800481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800484:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800487:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80048e:	eb 82                	jmp    800412 <vprintfmt+0x54>
  800490:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800493:	85 d2                	test   %edx,%edx
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	0f 49 c2             	cmovns %edx,%eax
  80049d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004a3:	e9 6a ff ff ff       	jmp    800412 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8004ab:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b2:	e9 5b ff ff ff       	jmp    800412 <vprintfmt+0x54>
  8004b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bd:	eb bc                	jmp    80047b <vprintfmt+0xbd>
			lflag++;
  8004bf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004c5:	e9 48 ff ff ff       	jmp    800412 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8d 78 04             	lea    0x4(%eax),%edi
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	53                   	push   %ebx
  8004d4:	ff 30                	push   (%eax)
  8004d6:	ff d6                	call   *%esi
			break;
  8004d8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004db:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004de:	e9 88 03 00 00       	jmp    80086b <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8d 78 04             	lea    0x4(%eax),%edi
  8004e9:	8b 10                	mov    (%eax),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	f7 d8                	neg    %eax
  8004ef:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f2:	83 f8 0f             	cmp    $0xf,%eax
  8004f5:	7f 23                	jg     80051a <vprintfmt+0x15c>
  8004f7:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  8004fe:	85 d2                	test   %edx,%edx
  800500:	74 18                	je     80051a <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800502:	52                   	push   %edx
  800503:	68 fc 2d 80 00       	push   $0x802dfc
  800508:	53                   	push   %ebx
  800509:	56                   	push   %esi
  80050a:	e8 92 fe ff ff       	call   8003a1 <printfmt>
  80050f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800512:	89 7d 14             	mov    %edi,0x14(%ebp)
  800515:	e9 51 03 00 00       	jmp    80086b <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80051a:	50                   	push   %eax
  80051b:	68 0b 2a 80 00       	push   $0x802a0b
  800520:	53                   	push   %ebx
  800521:	56                   	push   %esi
  800522:	e8 7a fe ff ff       	call   8003a1 <printfmt>
  800527:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052d:	e9 39 03 00 00       	jmp    80086b <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	83 c0 04             	add    $0x4,%eax
  800538:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800540:	85 d2                	test   %edx,%edx
  800542:	b8 04 2a 80 00       	mov    $0x802a04,%eax
  800547:	0f 45 c2             	cmovne %edx,%eax
  80054a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80054d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800551:	7e 06                	jle    800559 <vprintfmt+0x19b>
  800553:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800557:	75 0d                	jne    800566 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800559:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055c:	89 c7                	mov    %eax,%edi
  80055e:	03 45 d4             	add    -0x2c(%ebp),%eax
  800561:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800564:	eb 55                	jmp    8005bb <vprintfmt+0x1fd>
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 e0             	push   -0x20(%ebp)
  80056c:	ff 75 cc             	push   -0x34(%ebp)
  80056f:	e8 f5 03 00 00       	call   800969 <strnlen>
  800574:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800577:	29 c2                	sub    %eax,%edx
  800579:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800581:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800585:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800588:	eb 0f                	jmp    800599 <vprintfmt+0x1db>
					putch(padc, putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	53                   	push   %ebx
  80058e:	ff 75 d4             	push   -0x2c(%ebp)
  800591:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 ef 01             	sub    $0x1,%edi
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	85 ff                	test   %edi,%edi
  80059b:	7f ed                	jg     80058a <vprintfmt+0x1cc>
  80059d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005a0:	85 d2                	test   %edx,%edx
  8005a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a7:	0f 49 c2             	cmovns %edx,%eax
  8005aa:	29 c2                	sub    %eax,%edx
  8005ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005af:	eb a8                	jmp    800559 <vprintfmt+0x19b>
					putch(ch, putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	52                   	push   %edx
  8005b6:	ff d6                	call   *%esi
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005be:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c0:	83 c7 01             	add    $0x1,%edi
  8005c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c7:	0f be d0             	movsbl %al,%edx
  8005ca:	85 d2                	test   %edx,%edx
  8005cc:	74 4b                	je     800619 <vprintfmt+0x25b>
  8005ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d2:	78 06                	js     8005da <vprintfmt+0x21c>
  8005d4:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005d8:	78 1e                	js     8005f8 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8005da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005de:	74 d1                	je     8005b1 <vprintfmt+0x1f3>
  8005e0:	0f be c0             	movsbl %al,%eax
  8005e3:	83 e8 20             	sub    $0x20,%eax
  8005e6:	83 f8 5e             	cmp    $0x5e,%eax
  8005e9:	76 c6                	jbe    8005b1 <vprintfmt+0x1f3>
					putch('?', putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 3f                	push   $0x3f
  8005f1:	ff d6                	call   *%esi
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	eb c3                	jmp    8005bb <vprintfmt+0x1fd>
  8005f8:	89 cf                	mov    %ecx,%edi
  8005fa:	eb 0e                	jmp    80060a <vprintfmt+0x24c>
				putch(' ', putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 20                	push   $0x20
  800602:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800604:	83 ef 01             	sub    $0x1,%edi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	85 ff                	test   %edi,%edi
  80060c:	7f ee                	jg     8005fc <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	e9 52 02 00 00       	jmp    80086b <vprintfmt+0x4ad>
  800619:	89 cf                	mov    %ecx,%edi
  80061b:	eb ed                	jmp    80060a <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	83 c0 04             	add    $0x4,%eax
  800623:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80062b:	85 d2                	test   %edx,%edx
  80062d:	b8 04 2a 80 00       	mov    $0x802a04,%eax
  800632:	0f 45 c2             	cmovne %edx,%eax
  800635:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800638:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80063c:	7e 06                	jle    800644 <vprintfmt+0x286>
  80063e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800642:	75 0d                	jne    800651 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800644:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800647:	89 c7                	mov    %eax,%edi
  800649:	03 45 d4             	add    -0x2c(%ebp),%eax
  80064c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80064f:	eb 55                	jmp    8006a6 <vprintfmt+0x2e8>
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 e0             	push   -0x20(%ebp)
  800657:	ff 75 cc             	push   -0x34(%ebp)
  80065a:	e8 0a 03 00 00       	call   800969 <strnlen>
  80065f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800662:	29 c2                	sub    %eax,%edx
  800664:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80066c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800670:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	eb 0f                	jmp    800684 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	ff 75 d4             	push   -0x2c(%ebp)
  80067c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	83 ef 01             	sub    $0x1,%edi
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	85 ff                	test   %edi,%edi
  800686:	7f ed                	jg     800675 <vprintfmt+0x2b7>
  800688:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80068b:	85 d2                	test   %edx,%edx
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	0f 49 c2             	cmovns %edx,%eax
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80069a:	eb a8                	jmp    800644 <vprintfmt+0x286>
					putch(ch, putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	52                   	push   %edx
  8006a1:	ff d6                	call   *%esi
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006a9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8006ab:	83 c7 01             	add    $0x1,%edi
  8006ae:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b2:	0f be d0             	movsbl %al,%edx
  8006b5:	3c 3a                	cmp    $0x3a,%al
  8006b7:	74 4b                	je     800704 <vprintfmt+0x346>
  8006b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bd:	78 06                	js     8006c5 <vprintfmt+0x307>
  8006bf:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8006c3:	78 1e                	js     8006e3 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c9:	74 d1                	je     80069c <vprintfmt+0x2de>
  8006cb:	0f be c0             	movsbl %al,%eax
  8006ce:	83 e8 20             	sub    $0x20,%eax
  8006d1:	83 f8 5e             	cmp    $0x5e,%eax
  8006d4:	76 c6                	jbe    80069c <vprintfmt+0x2de>
					putch('?', putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	53                   	push   %ebx
  8006da:	6a 3f                	push   $0x3f
  8006dc:	ff d6                	call   *%esi
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	eb c3                	jmp    8006a6 <vprintfmt+0x2e8>
  8006e3:	89 cf                	mov    %ecx,%edi
  8006e5:	eb 0e                	jmp    8006f5 <vprintfmt+0x337>
				putch(' ', putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 20                	push   $0x20
  8006ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006ef:	83 ef 01             	sub    $0x1,%edi
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	85 ff                	test   %edi,%edi
  8006f7:	7f ee                	jg     8006e7 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8006f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ff:	e9 67 01 00 00       	jmp    80086b <vprintfmt+0x4ad>
  800704:	89 cf                	mov    %ecx,%edi
  800706:	eb ed                	jmp    8006f5 <vprintfmt+0x337>
	if (lflag >= 2)
  800708:	83 f9 01             	cmp    $0x1,%ecx
  80070b:	7f 1b                	jg     800728 <vprintfmt+0x36a>
	else if (lflag)
  80070d:	85 c9                	test   %ecx,%ecx
  80070f:	74 63                	je     800774 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800719:	99                   	cltd   
  80071a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
  800726:	eb 17                	jmp    80073f <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 50 04             	mov    0x4(%eax),%edx
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800733:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8d 40 08             	lea    0x8(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80073f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800742:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800745:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80074a:	85 c9                	test   %ecx,%ecx
  80074c:	0f 89 ff 00 00 00    	jns    800851 <vprintfmt+0x493>
				putch('-', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 2d                	push   $0x2d
  800758:	ff d6                	call   *%esi
				num = -(long long) num;
  80075a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800760:	f7 da                	neg    %edx
  800762:	83 d1 00             	adc    $0x0,%ecx
  800765:	f7 d9                	neg    %ecx
  800767:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80076f:	e9 dd 00 00 00       	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077c:	99                   	cltd   
  80077d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	eb b4                	jmp    80073f <vprintfmt+0x381>
	if (lflag >= 2)
  80078b:	83 f9 01             	cmp    $0x1,%ecx
  80078e:	7f 1e                	jg     8007ae <vprintfmt+0x3f0>
	else if (lflag)
  800790:	85 c9                	test   %ecx,%ecx
  800792:	74 32                	je     8007c6 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 10                	mov    (%eax),%edx
  800799:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079e:	8d 40 04             	lea    0x4(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a4:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8007a9:	e9 a3 00 00 00       	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 10                	mov    (%eax),%edx
  8007b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8007b6:	8d 40 08             	lea    0x8(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bc:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8007c1:	e9 8b 00 00 00       	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 10                	mov    (%eax),%edx
  8007cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d6:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8007db:	eb 74                	jmp    800851 <vprintfmt+0x493>
	if (lflag >= 2)
  8007dd:	83 f9 01             	cmp    $0x1,%ecx
  8007e0:	7f 1b                	jg     8007fd <vprintfmt+0x43f>
	else if (lflag)
  8007e2:	85 c9                	test   %ecx,%ecx
  8007e4:	74 2c                	je     800812 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8b 10                	mov    (%eax),%edx
  8007eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f0:	8d 40 04             	lea    0x4(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f6:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8007fb:	eb 54                	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 10                	mov    (%eax),%edx
  800802:	8b 48 04             	mov    0x4(%eax),%ecx
  800805:	8d 40 08             	lea    0x8(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800810:	eb 3f                	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 10                	mov    (%eax),%edx
  800817:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081c:	8d 40 04             	lea    0x4(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800822:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800827:	eb 28                	jmp    800851 <vprintfmt+0x493>
			putch('0', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	53                   	push   %ebx
  80082d:	6a 30                	push   $0x30
  80082f:	ff d6                	call   *%esi
			putch('x', putdat);
  800831:	83 c4 08             	add    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 78                	push   $0x78
  800837:	ff d6                	call   *%esi
			num = (unsigned long long)
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 10                	mov    (%eax),%edx
  80083e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800843:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800846:	8d 40 04             	lea    0x4(%eax),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084c:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800851:	83 ec 0c             	sub    $0xc,%esp
  800854:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800858:	50                   	push   %eax
  800859:	ff 75 d4             	push   -0x2c(%ebp)
  80085c:	57                   	push   %edi
  80085d:	51                   	push   %ecx
  80085e:	52                   	push   %edx
  80085f:	89 da                	mov    %ebx,%edx
  800861:	89 f0                	mov    %esi,%eax
  800863:	e8 73 fa ff ff       	call   8002db <printnum>
			break;
  800868:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80086b:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086e:	e9 69 fb ff ff       	jmp    8003dc <vprintfmt+0x1e>
	if (lflag >= 2)
  800873:	83 f9 01             	cmp    $0x1,%ecx
  800876:	7f 1b                	jg     800893 <vprintfmt+0x4d5>
	else if (lflag)
  800878:	85 c9                	test   %ecx,%ecx
  80087a:	74 2c                	je     8008a8 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	b9 00 00 00 00       	mov    $0x0,%ecx
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800891:	eb be                	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 10                	mov    (%eax),%edx
  800898:	8b 48 04             	mov    0x4(%eax),%ecx
  80089b:	8d 40 08             	lea    0x8(%eax),%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a1:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8008a6:	eb a9                	jmp    800851 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 10                	mov    (%eax),%edx
  8008ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b2:	8d 40 04             	lea    0x4(%eax),%eax
  8008b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8008bd:	eb 92                	jmp    800851 <vprintfmt+0x493>
			putch(ch, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	6a 25                	push   $0x25
  8008c5:	ff d6                	call   *%esi
			break;
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	eb 9f                	jmp    80086b <vprintfmt+0x4ad>
			putch('%', putdat);
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	53                   	push   %ebx
  8008d0:	6a 25                	push   $0x25
  8008d2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d4:	83 c4 10             	add    $0x10,%esp
  8008d7:	89 f8                	mov    %edi,%eax
  8008d9:	eb 03                	jmp    8008de <vprintfmt+0x520>
  8008db:	83 e8 01             	sub    $0x1,%eax
  8008de:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e2:	75 f7                	jne    8008db <vprintfmt+0x51d>
  8008e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e7:	eb 82                	jmp    80086b <vprintfmt+0x4ad>

008008e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 18             	sub    $0x18,%esp
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800906:	85 c0                	test   %eax,%eax
  800908:	74 26                	je     800930 <vsnprintf+0x47>
  80090a:	85 d2                	test   %edx,%edx
  80090c:	7e 22                	jle    800930 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090e:	ff 75 14             	push   0x14(%ebp)
  800911:	ff 75 10             	push   0x10(%ebp)
  800914:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800917:	50                   	push   %eax
  800918:	68 84 03 80 00       	push   $0x800384
  80091d:	e8 9c fa ff ff       	call   8003be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800925:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092b:	83 c4 10             	add    $0x10,%esp
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    
		return -E_INVAL;
  800930:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800935:	eb f7                	jmp    80092e <vsnprintf+0x45>

00800937 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800940:	50                   	push   %eax
  800941:	ff 75 10             	push   0x10(%ebp)
  800944:	ff 75 0c             	push   0xc(%ebp)
  800947:	ff 75 08             	push   0x8(%ebp)
  80094a:	e8 9a ff ff ff       	call   8008e9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
  80095c:	eb 03                	jmp    800961 <strlen+0x10>
		n++;
  80095e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800961:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800965:	75 f7                	jne    80095e <strlen+0xd>
	return n;
}
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
  800977:	eb 03                	jmp    80097c <strnlen+0x13>
		n++;
  800979:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	39 d0                	cmp    %edx,%eax
  80097e:	74 08                	je     800988 <strnlen+0x1f>
  800980:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800984:	75 f3                	jne    800979 <strnlen+0x10>
  800986:	89 c2                	mov    %eax,%edx
	return n;
}
  800988:	89 d0                	mov    %edx,%eax
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80099f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	84 d2                	test   %dl,%dl
  8009a7:	75 f2                	jne    80099b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a9:	89 c8                	mov    %ecx,%eax
  8009ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	53                   	push   %ebx
  8009b4:	83 ec 10             	sub    $0x10,%esp
  8009b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ba:	53                   	push   %ebx
  8009bb:	e8 91 ff ff ff       	call   800951 <strlen>
  8009c0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009c3:	ff 75 0c             	push   0xc(%ebp)
  8009c6:	01 d8                	add    %ebx,%eax
  8009c8:	50                   	push   %eax
  8009c9:	e8 be ff ff ff       	call   80098c <strcpy>
	return dst;
}
  8009ce:	89 d8                	mov    %ebx,%eax
  8009d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	56                   	push   %esi
  8009d9:	53                   	push   %ebx
  8009da:	8b 75 08             	mov    0x8(%ebp),%esi
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	89 f3                	mov    %esi,%ebx
  8009e2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e5:	89 f0                	mov    %esi,%eax
  8009e7:	eb 0f                	jmp    8009f8 <strncpy+0x23>
		*dst++ = *src;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	0f b6 0a             	movzbl (%edx),%ecx
  8009ef:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f2:	80 f9 01             	cmp    $0x1,%cl
  8009f5:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8009f8:	39 d8                	cmp    %ebx,%eax
  8009fa:	75 ed                	jne    8009e9 <strncpy+0x14>
	}
	return ret;
}
  8009fc:	89 f0                	mov    %esi,%eax
  8009fe:	5b                   	pop    %ebx
  8009ff:	5e                   	pop    %esi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 75 08             	mov    0x8(%ebp),%esi
  800a0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0d:	8b 55 10             	mov    0x10(%ebp),%edx
  800a10:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a12:	85 d2                	test   %edx,%edx
  800a14:	74 21                	je     800a37 <strlcpy+0x35>
  800a16:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a1a:	89 f2                	mov    %esi,%edx
  800a1c:	eb 09                	jmp    800a27 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a1e:	83 c1 01             	add    $0x1,%ecx
  800a21:	83 c2 01             	add    $0x1,%edx
  800a24:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	74 09                	je     800a34 <strlcpy+0x32>
  800a2b:	0f b6 19             	movzbl (%ecx),%ebx
  800a2e:	84 db                	test   %bl,%bl
  800a30:	75 ec                	jne    800a1e <strlcpy+0x1c>
  800a32:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a37:	29 f0                	sub    %esi,%eax
}
  800a39:	5b                   	pop    %ebx
  800a3a:	5e                   	pop    %esi
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a46:	eb 06                	jmp    800a4e <strcmp+0x11>
		p++, q++;
  800a48:	83 c1 01             	add    $0x1,%ecx
  800a4b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a4e:	0f b6 01             	movzbl (%ecx),%eax
  800a51:	84 c0                	test   %al,%al
  800a53:	74 04                	je     800a59 <strcmp+0x1c>
  800a55:	3a 02                	cmp    (%edx),%al
  800a57:	74 ef                	je     800a48 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a59:	0f b6 c0             	movzbl %al,%eax
  800a5c:	0f b6 12             	movzbl (%edx),%edx
  800a5f:	29 d0                	sub    %edx,%eax
}
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	53                   	push   %ebx
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 c3                	mov    %eax,%ebx
  800a6f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a72:	eb 06                	jmp    800a7a <strncmp+0x17>
		n--, p++, q++;
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a7a:	39 d8                	cmp    %ebx,%eax
  800a7c:	74 18                	je     800a96 <strncmp+0x33>
  800a7e:	0f b6 08             	movzbl (%eax),%ecx
  800a81:	84 c9                	test   %cl,%cl
  800a83:	74 04                	je     800a89 <strncmp+0x26>
  800a85:	3a 0a                	cmp    (%edx),%cl
  800a87:	74 eb                	je     800a74 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a89:	0f b6 00             	movzbl (%eax),%eax
  800a8c:	0f b6 12             	movzbl (%edx),%edx
  800a8f:	29 d0                	sub    %edx,%eax
}
  800a91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a94:	c9                   	leave  
  800a95:	c3                   	ret    
		return 0;
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	eb f4                	jmp    800a91 <strncmp+0x2e>

00800a9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa7:	eb 03                	jmp    800aac <strchr+0xf>
  800aa9:	83 c0 01             	add    $0x1,%eax
  800aac:	0f b6 10             	movzbl (%eax),%edx
  800aaf:	84 d2                	test   %dl,%dl
  800ab1:	74 06                	je     800ab9 <strchr+0x1c>
		if (*s == c)
  800ab3:	38 ca                	cmp    %cl,%dl
  800ab5:	75 f2                	jne    800aa9 <strchr+0xc>
  800ab7:	eb 05                	jmp    800abe <strchr+0x21>
			return (char *) s;
	return 0;
  800ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aca:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800acd:	38 ca                	cmp    %cl,%dl
  800acf:	74 09                	je     800ada <strfind+0x1a>
  800ad1:	84 d2                	test   %dl,%dl
  800ad3:	74 05                	je     800ada <strfind+0x1a>
	for (; *s; s++)
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	eb f0                	jmp    800aca <strfind+0xa>
			break;
	return (char *) s;
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	57                   	push   %edi
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae8:	85 c9                	test   %ecx,%ecx
  800aea:	74 2f                	je     800b1b <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aec:	89 f8                	mov    %edi,%eax
  800aee:	09 c8                	or     %ecx,%eax
  800af0:	a8 03                	test   $0x3,%al
  800af2:	75 21                	jne    800b15 <memset+0x39>
		c &= 0xFF;
  800af4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af8:	89 d0                	mov    %edx,%eax
  800afa:	c1 e0 08             	shl    $0x8,%eax
  800afd:	89 d3                	mov    %edx,%ebx
  800aff:	c1 e3 18             	shl    $0x18,%ebx
  800b02:	89 d6                	mov    %edx,%esi
  800b04:	c1 e6 10             	shl    $0x10,%esi
  800b07:	09 f3                	or     %esi,%ebx
  800b09:	09 da                	or     %ebx,%edx
  800b0b:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b0d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b10:	fc                   	cld    
  800b11:	f3 ab                	rep stos %eax,%es:(%edi)
  800b13:	eb 06                	jmp    800b1b <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	fc                   	cld    
  800b19:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1b:	89 f8                	mov    %edi,%eax
  800b1d:	5b                   	pop    %ebx
  800b1e:	5e                   	pop    %esi
  800b1f:	5f                   	pop    %edi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	57                   	push   %edi
  800b26:	56                   	push   %esi
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b30:	39 c6                	cmp    %eax,%esi
  800b32:	73 32                	jae    800b66 <memmove+0x44>
  800b34:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b37:	39 c2                	cmp    %eax,%edx
  800b39:	76 2b                	jbe    800b66 <memmove+0x44>
		s += n;
		d += n;
  800b3b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3e:	89 d6                	mov    %edx,%esi
  800b40:	09 fe                	or     %edi,%esi
  800b42:	09 ce                	or     %ecx,%esi
  800b44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b4a:	75 0e                	jne    800b5a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b4c:	83 ef 04             	sub    $0x4,%edi
  800b4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b55:	fd                   	std    
  800b56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b58:	eb 09                	jmp    800b63 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b5a:	83 ef 01             	sub    $0x1,%edi
  800b5d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b60:	fd                   	std    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b63:	fc                   	cld    
  800b64:	eb 1a                	jmp    800b80 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	89 f2                	mov    %esi,%edx
  800b68:	09 c2                	or     %eax,%edx
  800b6a:	09 ca                	or     %ecx,%edx
  800b6c:	f6 c2 03             	test   $0x3,%dl
  800b6f:	75 0a                	jne    800b7b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	fc                   	cld    
  800b77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b79:	eb 05                	jmp    800b80 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b7b:	89 c7                	mov    %eax,%edi
  800b7d:	fc                   	cld    
  800b7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b8a:	ff 75 10             	push   0x10(%ebp)
  800b8d:	ff 75 0c             	push   0xc(%ebp)
  800b90:	ff 75 08             	push   0x8(%ebp)
  800b93:	e8 8a ff ff ff       	call   800b22 <memmove>
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	89 c6                	mov    %eax,%esi
  800ba7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800baa:	eb 06                	jmp    800bb2 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bac:	83 c0 01             	add    $0x1,%eax
  800baf:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800bb2:	39 f0                	cmp    %esi,%eax
  800bb4:	74 14                	je     800bca <memcmp+0x30>
		if (*s1 != *s2)
  800bb6:	0f b6 08             	movzbl (%eax),%ecx
  800bb9:	0f b6 1a             	movzbl (%edx),%ebx
  800bbc:	38 d9                	cmp    %bl,%cl
  800bbe:	74 ec                	je     800bac <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800bc0:	0f b6 c1             	movzbl %cl,%eax
  800bc3:	0f b6 db             	movzbl %bl,%ebx
  800bc6:	29 d8                	sub    %ebx,%eax
  800bc8:	eb 05                	jmp    800bcf <memcmp+0x35>
	}

	return 0;
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bdc:	89 c2                	mov    %eax,%edx
  800bde:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be1:	eb 03                	jmp    800be6 <memfind+0x13>
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	39 d0                	cmp    %edx,%eax
  800be8:	73 04                	jae    800bee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bea:	38 08                	cmp    %cl,(%eax)
  800bec:	75 f5                	jne    800be3 <memfind+0x10>
			break;
	return (void *) s;
}
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfc:	eb 03                	jmp    800c01 <strtol+0x11>
		s++;
  800bfe:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800c01:	0f b6 02             	movzbl (%edx),%eax
  800c04:	3c 20                	cmp    $0x20,%al
  800c06:	74 f6                	je     800bfe <strtol+0xe>
  800c08:	3c 09                	cmp    $0x9,%al
  800c0a:	74 f2                	je     800bfe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c0c:	3c 2b                	cmp    $0x2b,%al
  800c0e:	74 2a                	je     800c3a <strtol+0x4a>
	int neg = 0;
  800c10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c15:	3c 2d                	cmp    $0x2d,%al
  800c17:	74 2b                	je     800c44 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c19:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1f:	75 0f                	jne    800c30 <strtol+0x40>
  800c21:	80 3a 30             	cmpb   $0x30,(%edx)
  800c24:	74 28                	je     800c4e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2d:	0f 44 d8             	cmove  %eax,%ebx
  800c30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c38:	eb 46                	jmp    800c80 <strtol+0x90>
		s++;
  800c3a:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c42:	eb d5                	jmp    800c19 <strtol+0x29>
		s++, neg = 1;
  800c44:	83 c2 01             	add    $0x1,%edx
  800c47:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4c:	eb cb                	jmp    800c19 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c52:	74 0e                	je     800c62 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	75 d8                	jne    800c30 <strtol+0x40>
		s++, base = 8;
  800c58:	83 c2 01             	add    $0x1,%edx
  800c5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c60:	eb ce                	jmp    800c30 <strtol+0x40>
		s += 2, base = 16;
  800c62:	83 c2 02             	add    $0x2,%edx
  800c65:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c6a:	eb c4                	jmp    800c30 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c6c:	0f be c0             	movsbl %al,%eax
  800c6f:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c72:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c75:	7d 3a                	jge    800cb1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c77:	83 c2 01             	add    $0x1,%edx
  800c7a:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800c7e:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800c80:	0f b6 02             	movzbl (%edx),%eax
  800c83:	8d 70 d0             	lea    -0x30(%eax),%esi
  800c86:	89 f3                	mov    %esi,%ebx
  800c88:	80 fb 09             	cmp    $0x9,%bl
  800c8b:	76 df                	jbe    800c6c <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c8d:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c90:	89 f3                	mov    %esi,%ebx
  800c92:	80 fb 19             	cmp    $0x19,%bl
  800c95:	77 08                	ja     800c9f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c97:	0f be c0             	movsbl %al,%eax
  800c9a:	83 e8 57             	sub    $0x57,%eax
  800c9d:	eb d3                	jmp    800c72 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c9f:	8d 70 bf             	lea    -0x41(%eax),%esi
  800ca2:	89 f3                	mov    %esi,%ebx
  800ca4:	80 fb 19             	cmp    $0x19,%bl
  800ca7:	77 08                	ja     800cb1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca9:	0f be c0             	movsbl %al,%eax
  800cac:	83 e8 37             	sub    $0x37,%eax
  800caf:	eb c1                	jmp    800c72 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb5:	74 05                	je     800cbc <strtol+0xcc>
		*endptr = (char *) s;
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cbc:	89 c8                	mov    %ecx,%eax
  800cbe:	f7 d8                	neg    %eax
  800cc0:	85 ff                	test   %edi,%edi
  800cc2:	0f 45 c8             	cmovne %eax,%ecx
}
  800cc5:	89 c8                	mov    %ecx,%eax
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	89 c3                	mov    %eax,%ebx
  800cdf:	89 c7                	mov    %eax,%edi
  800ce1:	89 c6                	mov    %eax,%esi
  800ce3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_cgetc>:

int
sys_cgetc(void)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cfa:	89 d1                	mov    %edx,%ecx
  800cfc:	89 d3                	mov    %edx,%ebx
  800cfe:	89 d7                	mov    %edx,%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
  800d0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1f:	89 cb                	mov    %ecx,%ebx
  800d21:	89 cf                	mov    %ecx,%edi
  800d23:	89 ce                	mov    %ecx,%esi
  800d25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7f 08                	jg     800d33 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	50                   	push   %eax
  800d37:	6a 03                	push   $0x3
  800d39:	68 ff 2c 80 00       	push   $0x802cff
  800d3e:	6a 23                	push   $0x23
  800d40:	68 1c 2d 80 00       	push   $0x802d1c
  800d45:	e8 a2 f4 ff ff       	call   8001ec <_panic>

00800d4a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_yield>:

void
sys_yield(void)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d79:	89 d1                	mov    %edx,%ecx
  800d7b:	89 d3                	mov    %edx,%ebx
  800d7d:	89 d7                	mov    %edx,%edi
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	be 00 00 00 00       	mov    $0x0,%esi
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 04 00 00 00       	mov    $0x4,%eax
  800da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da4:	89 f7                	mov    %esi,%edi
  800da6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7f 08                	jg     800db4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db4:	83 ec 0c             	sub    $0xc,%esp
  800db7:	50                   	push   %eax
  800db8:	6a 04                	push   $0x4
  800dba:	68 ff 2c 80 00       	push   $0x802cff
  800dbf:	6a 23                	push   $0x23
  800dc1:	68 1c 2d 80 00       	push   $0x802d1c
  800dc6:	e8 21 f4 ff ff       	call   8001ec <_panic>

00800dcb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dda:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de5:	8b 75 18             	mov    0x18(%ebp),%esi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 05                	push   $0x5
  800dfc:	68 ff 2c 80 00       	push   $0x802cff
  800e01:	6a 23                	push   $0x23
  800e03:	68 1c 2d 80 00       	push   $0x802d1c
  800e08:	e8 df f3 ff ff       	call   8001ec <_panic>

00800e0d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 06 00 00 00       	mov    $0x6,%eax
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 06                	push   $0x6
  800e3e:	68 ff 2c 80 00       	push   $0x802cff
  800e43:	6a 23                	push   $0x23
  800e45:	68 1c 2d 80 00       	push   $0x802d1c
  800e4a:	e8 9d f3 ff ff       	call   8001ec <_panic>

00800e4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 08 00 00 00       	mov    $0x8,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 08                	push   $0x8
  800e80:	68 ff 2c 80 00       	push   $0x802cff
  800e85:	6a 23                	push   $0x23
  800e87:	68 1c 2d 80 00       	push   $0x802d1c
  800e8c:	e8 5b f3 ff ff       	call   8001ec <_panic>

00800e91 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 09 00 00 00       	mov    $0x9,%eax
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7f 08                	jg     800ebc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	50                   	push   %eax
  800ec0:	6a 09                	push   $0x9
  800ec2:	68 ff 2c 80 00       	push   $0x802cff
  800ec7:	6a 23                	push   $0x23
  800ec9:	68 1c 2d 80 00       	push   $0x802d1c
  800ece:	e8 19 f3 ff ff       	call   8001ec <_panic>

00800ed3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	89 de                	mov    %ebx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 0a                	push   $0xa
  800f04:	68 ff 2c 80 00       	push   $0x802cff
  800f09:	6a 23                	push   $0x23
  800f0b:	68 1c 2d 80 00       	push   $0x802d1c
  800f10:	e8 d7 f2 ff ff       	call   8001ec <_panic>

00800f15 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f26:	be 00 00 00 00       	mov    $0x0,%esi
  800f2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f31:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4e:	89 cb                	mov    %ecx,%ebx
  800f50:	89 cf                	mov    %ecx,%edi
  800f52:	89 ce                	mov    %ecx,%esi
  800f54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7f 08                	jg     800f62 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	50                   	push   %eax
  800f66:	6a 0d                	push   $0xd
  800f68:	68 ff 2c 80 00       	push   $0x802cff
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 1c 2d 80 00       	push   $0x802d1c
  800f74:	e8 73 f2 ff ff       	call   8001ec <_panic>

00800f79 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f83:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800f85:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f89:	0f 84 99 00 00 00    	je     801028 <pgfault+0xaf>
  800f8f:	89 d8                	mov    %ebx,%eax
  800f91:	c1 e8 16             	shr    $0x16,%eax
  800f94:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f9b:	a8 01                	test   $0x1,%al
  800f9d:	0f 84 85 00 00 00    	je     801028 <pgfault+0xaf>
  800fa3:	89 d8                	mov    %ebx,%eax
  800fa5:	c1 e8 0c             	shr    $0xc,%eax
  800fa8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800faf:	f6 c6 08             	test   $0x8,%dh
  800fb2:	74 74                	je     801028 <pgfault+0xaf>
  800fb4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fbb:	a8 01                	test   $0x1,%al
  800fbd:	74 69                	je     801028 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	6a 07                	push   $0x7
  800fc4:	68 00 f0 7f 00       	push   $0x7ff000
  800fc9:	6a 00                	push   $0x0
  800fcb:	e8 b8 fd ff ff       	call   800d88 <sys_page_alloc>
  800fd0:	83 c4 10             	add    $0x10,%esp
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 65                	js     80103c <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800fd7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	68 00 10 00 00       	push   $0x1000
  800fe5:	53                   	push   %ebx
  800fe6:	68 00 f0 7f 00       	push   $0x7ff000
  800feb:	e8 94 fb ff ff       	call   800b84 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800ff0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ff7:	53                   	push   %ebx
  800ff8:	6a 00                	push   $0x0
  800ffa:	68 00 f0 7f 00       	push   $0x7ff000
  800fff:	6a 00                	push   $0x0
  801001:	e8 c5 fd ff ff       	call   800dcb <sys_page_map>
  801006:	83 c4 20             	add    $0x20,%esp
  801009:	85 c0                	test   %eax,%eax
  80100b:	78 43                	js     801050 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	68 00 f0 7f 00       	push   $0x7ff000
  801015:	6a 00                	push   $0x0
  801017:	e8 f1 fd ff ff       	call   800e0d <sys_page_unmap>
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 41                	js     801064 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  801023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801026:	c9                   	leave  
  801027:	c3                   	ret    
		panic("invalid permision\n");
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	68 2a 2d 80 00       	push   $0x802d2a
  801030:	6a 1f                	push   $0x1f
  801032:	68 3d 2d 80 00       	push   $0x802d3d
  801037:	e8 b0 f1 ff ff       	call   8001ec <_panic>
		panic("Unable to alloc page\n");
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	68 48 2d 80 00       	push   $0x802d48
  801044:	6a 28                	push   $0x28
  801046:	68 3d 2d 80 00       	push   $0x802d3d
  80104b:	e8 9c f1 ff ff       	call   8001ec <_panic>
		panic("Unable to map\n");
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	68 5e 2d 80 00       	push   $0x802d5e
  801058:	6a 2b                	push   $0x2b
  80105a:	68 3d 2d 80 00       	push   $0x802d3d
  80105f:	e8 88 f1 ff ff       	call   8001ec <_panic>
		panic("Unable to unmap\n");
  801064:	83 ec 04             	sub    $0x4,%esp
  801067:	68 6d 2d 80 00       	push   $0x802d6d
  80106c:	6a 2d                	push   $0x2d
  80106e:	68 3d 2d 80 00       	push   $0x802d3d
  801073:	e8 74 f1 ff ff       	call   8001ec <_panic>

00801078 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  801081:	68 79 0f 80 00       	push   $0x800f79
  801086:	e8 ba 07 00 00       	call   801845 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80108b:	b8 07 00 00 00       	mov    $0x7,%eax
  801090:	cd 30                	int    $0x30
  801092:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	78 23                	js     8010be <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80109b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  8010a0:	75 6d                	jne    80110f <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010a2:	e8 a3 fc ff ff       	call   800d4a <sys_getenvid>
  8010a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b4:	a3 00 40 80 00       	mov    %eax,0x804000
		return 0;
  8010b9:	e9 02 01 00 00       	jmp    8011c0 <fork+0x148>
		panic("sys_exofork: %e", envid);
  8010be:	50                   	push   %eax
  8010bf:	68 7e 2d 80 00       	push   $0x802d7e
  8010c4:	6a 6d                	push   $0x6d
  8010c6:	68 3d 2d 80 00       	push   $0x802d3d
  8010cb:	e8 1c f1 ff ff       	call   8001ec <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  8010d0:	c1 e0 0c             	shl    $0xc,%eax
  8010d3:	83 ec 0c             	sub    $0xc,%esp
  8010d6:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010dc:	52                   	push   %edx
  8010dd:	50                   	push   %eax
  8010de:	56                   	push   %esi
  8010df:	50                   	push   %eax
  8010e0:	6a 00                	push   $0x0
  8010e2:	e8 e4 fc ff ff       	call   800dcb <sys_page_map>
  8010e7:	83 c4 20             	add    $0x20,%esp
  8010ea:	eb 15                	jmp    801101 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  8010ec:	c1 e0 0c             	shl    $0xc,%eax
  8010ef:	83 ec 0c             	sub    $0xc,%esp
  8010f2:	6a 05                	push   $0x5
  8010f4:	50                   	push   %eax
  8010f5:	56                   	push   %esi
  8010f6:	50                   	push   %eax
  8010f7:	6a 00                	push   $0x0
  8010f9:	e8 cd fc ff ff       	call   800dcb <sys_page_map>
  8010fe:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801101:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801107:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80110d:	74 7a                	je     801189 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80110f:	89 d8                	mov    %ebx,%eax
  801111:	c1 e8 16             	shr    $0x16,%eax
  801114:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80111b:	a8 01                	test   $0x1,%al
  80111d:	74 e2                	je     801101 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80111f:	89 d8                	mov    %ebx,%eax
  801121:	c1 e8 0c             	shr    $0xc,%eax
  801124:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  80112b:	f6 c2 01             	test   $0x1,%dl
  80112e:	74 d1                	je     801101 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801130:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801137:	f6 c2 04             	test   $0x4,%dl
  80113a:	74 c5                	je     801101 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80113c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801143:	f6 c6 04             	test   $0x4,%dh
  801146:	75 88                	jne    8010d0 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801148:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80114e:	74 9c                	je     8010ec <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801150:	c1 e0 0c             	shl    $0xc,%eax
  801153:	89 c7                	mov    %eax,%edi
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	68 05 08 00 00       	push   $0x805
  80115d:	50                   	push   %eax
  80115e:	56                   	push   %esi
  80115f:	50                   	push   %eax
  801160:	6a 00                	push   $0x0
  801162:	e8 64 fc ff ff       	call   800dcb <sys_page_map>
  801167:	83 c4 20             	add    $0x20,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 93                	js     801101 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	68 05 08 00 00       	push   $0x805
  801176:	57                   	push   %edi
  801177:	6a 00                	push   $0x0
  801179:	57                   	push   %edi
  80117a:	6a 00                	push   $0x0
  80117c:	e8 4a fc ff ff       	call   800dcb <sys_page_map>
  801181:	83 c4 20             	add    $0x20,%esp
  801184:	e9 78 ff ff ff       	jmp    801101 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801189:	83 ec 04             	sub    $0x4,%esp
  80118c:	6a 07                	push   $0x7
  80118e:	68 00 f0 bf ee       	push   $0xeebff000
  801193:	56                   	push   %esi
  801194:	e8 ef fb ff ff       	call   800d88 <sys_page_alloc>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 2a                	js     8011ca <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	68 b4 18 80 00       	push   $0x8018b4
  8011a8:	56                   	push   %esi
  8011a9:	e8 25 fd ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011ae:	83 c4 08             	add    $0x8,%esp
  8011b1:	6a 02                	push   $0x2
  8011b3:	56                   	push   %esi
  8011b4:	e8 96 fc ff ff       	call   800e4f <sys_env_set_status>
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	78 21                	js     8011e1 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011c0:	89 f0                	mov    %esi,%eax
  8011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
		panic("failed to alloc page");
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	68 8e 2d 80 00       	push   $0x802d8e
  8011d2:	68 82 00 00 00       	push   $0x82
  8011d7:	68 3d 2d 80 00       	push   $0x802d3d
  8011dc:	e8 0b f0 ff ff       	call   8001ec <_panic>
		panic("sys_env_set_status: %e", r);
  8011e1:	50                   	push   %eax
  8011e2:	68 a3 2d 80 00       	push   $0x802da3
  8011e7:	68 89 00 00 00       	push   $0x89
  8011ec:	68 3d 2d 80 00       	push   $0x802d3d
  8011f1:	e8 f6 ef ff ff       	call   8001ec <_panic>

008011f6 <sfork>:

// Challenge!
int
sfork(void)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011fc:	68 ba 2d 80 00       	push   $0x802dba
  801201:	68 92 00 00 00       	push   $0x92
  801206:	68 3d 2d 80 00       	push   $0x802d3d
  80120b:	e8 dc ef ff ff       	call   8001ec <_panic>

00801210 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80121c:	6a 00                	push   $0x0
  80121e:	ff 75 08             	push   0x8(%ebp)
  801221:	e8 2e 0e 00 00       	call   802054 <open>
  801226:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	0f 88 d0 04 00 00    	js     801707 <spawn+0x4f7>
  801237:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	68 00 02 00 00       	push   $0x200
  801241:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801247:	50                   	push   %eax
  801248:	51                   	push   %ecx
  801249:	e8 ec 09 00 00       	call   801c3a <readn>
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	3d 00 02 00 00       	cmp    $0x200,%eax
  801256:	75 57                	jne    8012af <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  801258:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80125f:	45 4c 46 
  801262:	75 4b                	jne    8012af <spawn+0x9f>
  801264:	b8 07 00 00 00       	mov    $0x7,%eax
  801269:	cd 30                	int    $0x30
  80126b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801271:	85 c0                	test   %eax,%eax
  801273:	0f 88 82 04 00 00    	js     8016fb <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801279:	25 ff 03 00 00       	and    $0x3ff,%eax
  80127e:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801281:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801287:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80128d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801292:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801294:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80129a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8012a0:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8012a5:	be 00 00 00 00       	mov    $0x0,%esi
  8012aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  8012ad:	eb 4b                	jmp    8012fa <spawn+0xea>
		close(fd);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8012b8:	e8 ba 07 00 00       	call   801a77 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8012bd:	83 c4 0c             	add    $0xc,%esp
  8012c0:	68 7f 45 4c 46       	push   $0x464c457f
  8012c5:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  8012cb:	68 d0 2d 80 00       	push   $0x802dd0
  8012d0:	e8 f2 ef ff ff       	call   8002c7 <cprintf>
		return -E_NOT_EXEC;
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  8012df:	ff ff ff 
  8012e2:	e9 20 04 00 00       	jmp    801707 <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	50                   	push   %eax
  8012eb:	e8 61 f6 ff ff       	call   800951 <strlen>
  8012f0:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8012f4:	83 c3 01             	add    $0x1,%ebx
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801301:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801304:	85 c0                	test   %eax,%eax
  801306:	75 df                	jne    8012e7 <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801308:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80130e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801314:	b8 00 10 40 00       	mov    $0x401000,%eax
  801319:	29 f0                	sub    %esi,%eax
  80131b:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80131d:	89 c2                	mov    %eax,%edx
  80131f:	83 e2 fc             	and    $0xfffffffc,%edx
  801322:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801329:	29 c2                	sub    %eax,%edx
  80132b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801331:	8d 42 f8             	lea    -0x8(%edx),%eax
  801334:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801339:	0f 86 eb 03 00 00    	jbe    80172a <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	6a 07                	push   $0x7
  801344:	68 00 00 40 00       	push   $0x400000
  801349:	6a 00                	push   $0x0
  80134b:	e8 38 fa ff ff       	call   800d88 <sys_page_alloc>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	0f 88 d4 03 00 00    	js     80172f <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80135b:	be 00 00 00 00       	mov    $0x0,%esi
  801360:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801369:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  80136f:	7e 32                	jle    8013a3 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801371:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801377:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80137d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	ff 34 b3             	push   (%ebx,%esi,4)
  801386:	57                   	push   %edi
  801387:	e8 00 f6 ff ff       	call   80098c <strcpy>
		string_store += strlen(argv[i]) + 1;
  80138c:	83 c4 04             	add    $0x4,%esp
  80138f:	ff 34 b3             	push   (%ebx,%esi,4)
  801392:	e8 ba f5 ff ff       	call   800951 <strlen>
  801397:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80139b:	83 c6 01             	add    $0x1,%esi
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	eb c6                	jmp    801369 <spawn+0x159>
	}
	argv_store[argc] = 0;
  8013a3:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8013a9:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8013af:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8013b6:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8013bc:	0f 85 8c 00 00 00    	jne    80144e <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8013c2:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8013c8:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8013ce:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  8013d1:	89 f8                	mov    %edi,%eax
  8013d3:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  8013d9:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8013dc:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8013e1:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8013e7:	83 ec 0c             	sub    $0xc,%esp
  8013ea:	6a 07                	push   $0x7
  8013ec:	68 00 d0 bf ee       	push   $0xeebfd000
  8013f1:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8013f7:	68 00 00 40 00       	push   $0x400000
  8013fc:	6a 00                	push   $0x0
  8013fe:	e8 c8 f9 ff ff       	call   800dcb <sys_page_map>
  801403:	89 c3                	mov    %eax,%ebx
  801405:	83 c4 20             	add    $0x20,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	0f 88 27 03 00 00    	js     801737 <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801410:	83 ec 08             	sub    $0x8,%esp
  801413:	68 00 00 40 00       	push   $0x400000
  801418:	6a 00                	push   $0x0
  80141a:	e8 ee f9 ff ff       	call   800e0d <sys_page_unmap>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	0f 88 0b 03 00 00    	js     801737 <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80142c:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801432:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801439:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80143f:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801446:	00 00 00 
  801449:	e9 4e 01 00 00       	jmp    80159c <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80144e:	68 44 2e 80 00       	push   $0x802e44
  801453:	68 ea 2d 80 00       	push   $0x802dea
  801458:	68 f2 00 00 00       	push   $0xf2
  80145d:	68 ff 2d 80 00       	push   $0x802dff
  801462:	e8 85 ed ff ff       	call   8001ec <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	6a 07                	push   $0x7
  80146c:	68 00 00 40 00       	push   $0x400000
  801471:	6a 00                	push   $0x0
  801473:	e8 10 f9 ff ff       	call   800d88 <sys_page_alloc>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	0f 88 92 02 00 00    	js     801715 <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80148c:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801499:	e8 65 08 00 00       	call   801d03 <seek>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	0f 88 73 02 00 00    	js     80171c <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	89 f8                	mov    %edi,%eax
  8014ae:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  8014b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014b9:	39 d0                	cmp    %edx,%eax
  8014bb:	0f 47 c2             	cmova  %edx,%eax
  8014be:	50                   	push   %eax
  8014bf:	68 00 00 40 00       	push   $0x400000
  8014c4:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8014ca:	e8 6b 07 00 00       	call   801c3a <readn>
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	0f 88 49 02 00 00    	js     801723 <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8014da:	83 ec 0c             	sub    $0xc,%esp
  8014dd:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  8014e3:	56                   	push   %esi
  8014e4:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8014ea:	68 00 00 40 00       	push   $0x400000
  8014ef:	6a 00                	push   $0x0
  8014f1:	e8 d5 f8 ff ff       	call   800dcb <sys_page_map>
  8014f6:	83 c4 20             	add    $0x20,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 7c                	js     801579 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	68 00 00 40 00       	push   $0x400000
  801505:	6a 00                	push   $0x0
  801507:	e8 01 f9 ff ff       	call   800e0d <sys_page_unmap>
  80150c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80150f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801515:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80151b:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801521:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  801527:	76 65                	jbe    80158e <spawn+0x37e>
		if (i >= filesz) {
  801529:	39 df                	cmp    %ebx,%edi
  80152b:	0f 87 36 ff ff ff    	ja     801467 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  80153a:	56                   	push   %esi
  80153b:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801541:	e8 42 f8 ff ff       	call   800d88 <sys_page_alloc>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	79 c2                	jns    80150f <spawn+0x2ff>
  80154d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801558:	e8 ac f7 ff ff       	call   800d09 <sys_env_destroy>
	close(fd);
  80155d:	83 c4 04             	add    $0x4,%esp
  801560:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801566:	e8 0c 05 00 00       	call   801a77 <close>
	return r;
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801574:	e9 8e 01 00 00       	jmp    801707 <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  801579:	50                   	push   %eax
  80157a:	68 0b 2e 80 00       	push   $0x802e0b
  80157f:	68 25 01 00 00       	push   $0x125
  801584:	68 ff 2d 80 00       	push   $0x802dff
  801589:	e8 5e ec ff ff       	call   8001ec <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80158e:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801595:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  80159c:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8015a3:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8015a9:	7e 67                	jle    801612 <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  8015ab:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  8015b1:	83 39 01             	cmpl   $0x1,(%ecx)
  8015b4:	75 d8                	jne    80158e <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8015b6:	8b 41 18             	mov    0x18(%ecx),%eax
  8015b9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8015bf:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8015c2:	83 f8 01             	cmp    $0x1,%eax
  8015c5:	19 c0                	sbb    %eax,%eax
  8015c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8015ca:	83 c0 07             	add    $0x7,%eax
  8015cd:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8015d3:	8b 51 04             	mov    0x4(%ecx),%edx
  8015d6:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  8015dc:	8b 79 10             	mov    0x10(%ecx),%edi
  8015df:	8b 59 14             	mov    0x14(%ecx),%ebx
  8015e2:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8015e8:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  8015eb:	89 f0                	mov    %esi,%eax
  8015ed:	25 ff 0f 00 00       	and    $0xfff,%eax
  8015f2:	74 14                	je     801608 <spawn+0x3f8>
		va -= i;
  8015f4:	29 c6                	sub    %eax,%esi
		memsz += i;
  8015f6:	01 c3                	add    %eax,%ebx
  8015f8:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  8015fe:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801600:	29 c2                	sub    %eax,%edx
  801602:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801608:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160d:	e9 09 ff ff ff       	jmp    80151b <spawn+0x30b>
	close(fd);
  801612:	83 ec 0c             	sub    $0xc,%esp
  801615:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  80161b:	e8 57 04 00 00       	call   801a77 <close>
  801620:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801623:	bb 00 00 00 00       	mov    $0x0,%ebx
  801628:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80162e:	eb 2d                	jmp    80165d <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801630:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801637:	89 da                	mov    %ebx,%edx
  801639:	c1 e2 0c             	shl    $0xc,%edx
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	25 07 0e 00 00       	and    $0xe07,%eax
  801644:	50                   	push   %eax
  801645:	52                   	push   %edx
  801646:	56                   	push   %esi
  801647:	52                   	push   %edx
  801648:	6a 00                	push   $0x0
  80164a:	e8 7c f7 ff ff       	call   800dcb <sys_page_map>
  80164f:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801652:	83 c3 01             	add    $0x1,%ebx
  801655:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  80165b:	74 29                	je     801686 <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  80165d:	89 d8                	mov    %ebx,%eax
  80165f:	c1 f8 0a             	sar    $0xa,%eax
  801662:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	74 e5                	je     801652 <spawn+0x442>
  80166d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801674:	a8 01                	test   $0x1,%al
  801676:	74 da                	je     801652 <spawn+0x442>
  801678:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80167f:	f6 c4 04             	test   $0x4,%ah
  801682:	74 ce                	je     801652 <spawn+0x442>
  801684:	eb aa                	jmp    801630 <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801686:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80168d:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8016a0:	e8 ec f7 ff ff       	call   800e91 <sys_env_set_trapframe>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	78 25                	js     8016d1 <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8016ac:	83 ec 08             	sub    $0x8,%esp
  8016af:	6a 02                	push   $0x2
  8016b1:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8016b7:	e8 93 f7 ff ff       	call   800e4f <sys_env_set_status>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 23                	js     8016e6 <spawn+0x4d6>
	return child;
  8016c3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8016c9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8016cf:	eb 36                	jmp    801707 <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  8016d1:	50                   	push   %eax
  8016d2:	68 28 2e 80 00       	push   $0x802e28
  8016d7:	68 86 00 00 00       	push   $0x86
  8016dc:	68 ff 2d 80 00       	push   $0x802dff
  8016e1:	e8 06 eb ff ff       	call   8001ec <_panic>
		panic("sys_env_set_status: %e", r);
  8016e6:	50                   	push   %eax
  8016e7:	68 a3 2d 80 00       	push   $0x802da3
  8016ec:	68 89 00 00 00       	push   $0x89
  8016f1:	68 ff 2d 80 00       	push   $0x802dff
  8016f6:	e8 f1 ea ff ff       	call   8001ec <_panic>
		return r;
  8016fb:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801701:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  801707:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80170d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801710:	5b                   	pop    %ebx
  801711:	5e                   	pop    %esi
  801712:	5f                   	pop    %edi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    
  801715:	89 c7                	mov    %eax,%edi
  801717:	e9 33 fe ff ff       	jmp    80154f <spawn+0x33f>
  80171c:	89 c7                	mov    %eax,%edi
  80171e:	e9 2c fe ff ff       	jmp    80154f <spawn+0x33f>
  801723:	89 c7                	mov    %eax,%edi
  801725:	e9 25 fe ff ff       	jmp    80154f <spawn+0x33f>
		return -E_NO_MEM;
  80172a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  80172f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801735:	eb d0                	jmp    801707 <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	68 00 00 40 00       	push   $0x400000
  80173f:	6a 00                	push   $0x0
  801741:	e8 c7 f6 ff ff       	call   800e0d <sys_page_unmap>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80174f:	eb b6                	jmp    801707 <spawn+0x4f7>

00801751 <spawnl>:
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
	va_start(vl, arg0);
  801756:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80175e:	eb 05                	jmp    801765 <spawnl+0x14>
		argc++;
  801760:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801763:	89 ca                	mov    %ecx,%edx
  801765:	8d 4a 04             	lea    0x4(%edx),%ecx
  801768:	83 3a 00             	cmpl   $0x0,(%edx)
  80176b:	75 f3                	jne    801760 <spawnl+0xf>
	const char *argv[argc+2];
  80176d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801774:	89 d3                	mov    %edx,%ebx
  801776:	83 e3 f0             	and    $0xfffffff0,%ebx
  801779:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80177f:	89 e1                	mov    %esp,%ecx
  801781:	29 d1                	sub    %edx,%ecx
  801783:	39 cc                	cmp    %ecx,%esp
  801785:	74 10                	je     801797 <spawnl+0x46>
  801787:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80178d:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801794:	00 
  801795:	eb ec                	jmp    801783 <spawnl+0x32>
  801797:	89 da                	mov    %ebx,%edx
  801799:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80179f:	29 d4                	sub    %edx,%esp
  8017a1:	85 d2                	test   %edx,%edx
  8017a3:	74 05                	je     8017aa <spawnl+0x59>
  8017a5:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8017aa:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  8017ae:	89 da                	mov    %ebx,%edx
  8017b0:	c1 ea 02             	shr    $0x2,%edx
  8017b3:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  8017b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8017c0:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  8017c7:	00 
	va_start(vl, arg0);
  8017c8:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8017cb:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	eb 0b                	jmp    8017df <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  8017d4:	83 c0 01             	add    $0x1,%eax
  8017d7:	8b 31                	mov    (%ecx),%esi
  8017d9:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  8017dc:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8017df:	39 d0                	cmp    %edx,%eax
  8017e1:	75 f1                	jne    8017d4 <spawnl+0x83>
	return spawn(prog, argv);
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	53                   	push   %ebx
  8017e7:	ff 75 08             	push   0x8(%ebp)
  8017ea:	e8 21 fa ff ff       	call   801210 <spawn>
}
  8017ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	56                   	push   %esi
  8017fa:	53                   	push   %ebx
  8017fb:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8017fe:	85 f6                	test   %esi,%esi
  801800:	74 13                	je     801815 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801802:	89 f3                	mov    %esi,%ebx
  801804:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80180a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80180d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801813:	eb 1b                	jmp    801830 <wait+0x3a>
	assert(envid != 0);
  801815:	68 6a 2e 80 00       	push   $0x802e6a
  80181a:	68 ea 2d 80 00       	push   $0x802dea
  80181f:	6a 09                	push   $0x9
  801821:	68 75 2e 80 00       	push   $0x802e75
  801826:	e8 c1 e9 ff ff       	call   8001ec <_panic>
		sys_yield();
  80182b:	e8 39 f5 ff ff       	call   800d69 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801830:	8b 43 48             	mov    0x48(%ebx),%eax
  801833:	39 f0                	cmp    %esi,%eax
  801835:	75 07                	jne    80183e <wait+0x48>
  801837:	8b 43 54             	mov    0x54(%ebx),%eax
  80183a:	85 c0                	test   %eax,%eax
  80183c:	75 ed                	jne    80182b <wait+0x35>
}
  80183e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    

00801845 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80184b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801852:	74 20                	je     801874 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	a3 04 40 80 00       	mov    %eax,0x804004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	68 b4 18 80 00       	push   $0x8018b4
  801864:	6a 00                	push   $0x0
  801866:	e8 68 f6 ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 2e                	js     8018a0 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801872:	c9                   	leave  
  801873:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	6a 07                	push   $0x7
  801879:	68 00 f0 bf ee       	push   $0xeebff000
  80187e:	6a 00                	push   $0x0
  801880:	e8 03 f5 ff ff       	call   800d88 <sys_page_alloc>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	79 c8                	jns    801854 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 80 2e 80 00       	push   $0x802e80
  801894:	6a 21                	push   $0x21
  801896:	68 e3 2e 80 00       	push   $0x802ee3
  80189b:	e8 4c e9 ff ff       	call   8001ec <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 ac 2e 80 00       	push   $0x802eac
  8018a8:	6a 27                	push   $0x27
  8018aa:	68 e3 2e 80 00       	push   $0x802ee3
  8018af:	e8 38 e9 ff ff       	call   8001ec <_panic>

008018b4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8018b4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8018b5:	a1 04 40 80 00       	mov    0x804004,%eax
	call *%eax
  8018ba:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8018bc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8018bf:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8018c3:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8018c8:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8018cc:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8018ce:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8018d1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8018d2:	83 c4 04             	add    $0x4,%esp
	popfl
  8018d5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8018d6:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8018d7:	c3                   	ret    

008018d8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	05 00 00 00 30       	add    $0x30000000,%eax
  8018e3:	c1 e8 0c             	shr    $0xc,%eax
}
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8018f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801907:	89 c2                	mov    %eax,%edx
  801909:	c1 ea 16             	shr    $0x16,%edx
  80190c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801913:	f6 c2 01             	test   $0x1,%dl
  801916:	74 29                	je     801941 <fd_alloc+0x42>
  801918:	89 c2                	mov    %eax,%edx
  80191a:	c1 ea 0c             	shr    $0xc,%edx
  80191d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801924:	f6 c2 01             	test   $0x1,%dl
  801927:	74 18                	je     801941 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801929:	05 00 10 00 00       	add    $0x1000,%eax
  80192e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801933:	75 d2                	jne    801907 <fd_alloc+0x8>
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  80193a:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  80193f:	eb 05                	jmp    801946 <fd_alloc+0x47>
			return 0;
  801941:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  801946:	8b 55 08             	mov    0x8(%ebp),%edx
  801949:	89 02                	mov    %eax,(%edx)
}
  80194b:	89 c8                	mov    %ecx,%eax
  80194d:	5d                   	pop    %ebp
  80194e:	c3                   	ret    

0080194f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801955:	83 f8 1f             	cmp    $0x1f,%eax
  801958:	77 30                	ja     80198a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80195a:	c1 e0 0c             	shl    $0xc,%eax
  80195d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801962:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801968:	f6 c2 01             	test   $0x1,%dl
  80196b:	74 24                	je     801991 <fd_lookup+0x42>
  80196d:	89 c2                	mov    %eax,%edx
  80196f:	c1 ea 0c             	shr    $0xc,%edx
  801972:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801979:	f6 c2 01             	test   $0x1,%dl
  80197c:	74 1a                	je     801998 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	89 02                	mov    %eax,(%edx)
	return 0;
  801983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    
		return -E_INVAL;
  80198a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198f:	eb f7                	jmp    801988 <fd_lookup+0x39>
		return -E_INVAL;
  801991:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801996:	eb f0                	jmp    801988 <fd_lookup+0x39>
  801998:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199d:	eb e9                	jmp    801988 <fd_lookup+0x39>

0080199f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	53                   	push   %ebx
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a9:	b8 70 2f 80 00       	mov    $0x802f70,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  8019ae:	bb 0c 30 80 00       	mov    $0x80300c,%ebx
		if (devtab[i]->dev_id == dev_id) {
  8019b3:	39 13                	cmp    %edx,(%ebx)
  8019b5:	74 32                	je     8019e9 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  8019b7:	83 c0 04             	add    $0x4,%eax
  8019ba:	8b 18                	mov    (%eax),%ebx
  8019bc:	85 db                	test   %ebx,%ebx
  8019be:	75 f3                	jne    8019b3 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019c0:	a1 00 40 80 00       	mov    0x804000,%eax
  8019c5:	8b 40 48             	mov    0x48(%eax),%eax
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	52                   	push   %edx
  8019cc:	50                   	push   %eax
  8019cd:	68 f4 2e 80 00       	push   $0x802ef4
  8019d2:	e8 f0 e8 ff ff       	call   8002c7 <cprintf>
	*dev = 0;
	return -E_INVAL;
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	89 1a                	mov    %ebx,(%edx)
}
  8019e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    
			return 0;
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ee:	eb ef                	jmp    8019df <dev_lookup+0x40>

008019f0 <fd_close>:
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	57                   	push   %edi
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 24             	sub    $0x24,%esp
  8019f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8019fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a02:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a03:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a09:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a0c:	50                   	push   %eax
  801a0d:	e8 3d ff ff ff       	call   80194f <fd_lookup>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 05                	js     801a20 <fd_close+0x30>
	    || fd != fd2)
  801a1b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a1e:	74 16                	je     801a36 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a20:	89 f8                	mov    %edi,%eax
  801a22:	84 c0                	test   %al,%al
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	0f 44 d8             	cmove  %eax,%ebx
}
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5f                   	pop    %edi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a3c:	50                   	push   %eax
  801a3d:	ff 36                	push   (%esi)
  801a3f:	e8 5b ff ff ff       	call   80199f <dev_lookup>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 1a                	js     801a67 <fd_close+0x77>
		if (dev->dev_close)
  801a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a50:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801a53:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	74 0b                	je     801a67 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	56                   	push   %esi
  801a60:	ff d0                	call   *%eax
  801a62:	89 c3                	mov    %eax,%ebx
  801a64:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	56                   	push   %esi
  801a6b:	6a 00                	push   $0x0
  801a6d:	e8 9b f3 ff ff       	call   800e0d <sys_page_unmap>
	return r;
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	eb b5                	jmp    801a2c <fd_close+0x3c>

00801a77 <close>:

int
close(int fdnum)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a80:	50                   	push   %eax
  801a81:	ff 75 08             	push   0x8(%ebp)
  801a84:	e8 c6 fe ff ff       	call   80194f <fd_lookup>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	79 02                	jns    801a92 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    
		return fd_close(fd, 1);
  801a92:	83 ec 08             	sub    $0x8,%esp
  801a95:	6a 01                	push   $0x1
  801a97:	ff 75 f4             	push   -0xc(%ebp)
  801a9a:	e8 51 ff ff ff       	call   8019f0 <fd_close>
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	eb ec                	jmp    801a90 <close+0x19>

00801aa4 <close_all>:

void
close_all(void)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801aab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	53                   	push   %ebx
  801ab4:	e8 be ff ff ff       	call   801a77 <close>
	for (i = 0; i < MAXFD; i++)
  801ab9:	83 c3 01             	add    $0x1,%ebx
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	83 fb 20             	cmp    $0x20,%ebx
  801ac2:	75 ec                	jne    801ab0 <close_all+0xc>
}
  801ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	57                   	push   %edi
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ad2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ad5:	50                   	push   %eax
  801ad6:	ff 75 08             	push   0x8(%ebp)
  801ad9:	e8 71 fe ff ff       	call   80194f <fd_lookup>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 7f                	js     801b66 <dup+0x9d>
		return r;
	close(newfdnum);
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	ff 75 0c             	push   0xc(%ebp)
  801aed:	e8 85 ff ff ff       	call   801a77 <close>

	newfd = INDEX2FD(newfdnum);
  801af2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801af5:	c1 e6 0c             	shl    $0xc,%esi
  801af8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801afe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b01:	89 3c 24             	mov    %edi,(%esp)
  801b04:	e8 df fd ff ff       	call   8018e8 <fd2data>
  801b09:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b0b:	89 34 24             	mov    %esi,(%esp)
  801b0e:	e8 d5 fd ff ff       	call   8018e8 <fd2data>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	c1 e8 16             	shr    $0x16,%eax
  801b1e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b25:	a8 01                	test   $0x1,%al
  801b27:	74 11                	je     801b3a <dup+0x71>
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	c1 e8 0c             	shr    $0xc,%eax
  801b2e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b35:	f6 c2 01             	test   $0x1,%dl
  801b38:	75 36                	jne    801b70 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b3a:	89 f8                	mov    %edi,%eax
  801b3c:	c1 e8 0c             	shr    $0xc,%eax
  801b3f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	25 07 0e 00 00       	and    $0xe07,%eax
  801b4e:	50                   	push   %eax
  801b4f:	56                   	push   %esi
  801b50:	6a 00                	push   $0x0
  801b52:	57                   	push   %edi
  801b53:	6a 00                	push   $0x0
  801b55:	e8 71 f2 ff ff       	call   800dcb <sys_page_map>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 20             	add    $0x20,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 33                	js     801b96 <dup+0xcd>
		goto err;

	return newfdnum;
  801b63:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b77:	83 ec 0c             	sub    $0xc,%esp
  801b7a:	25 07 0e 00 00       	and    $0xe07,%eax
  801b7f:	50                   	push   %eax
  801b80:	ff 75 d4             	push   -0x2c(%ebp)
  801b83:	6a 00                	push   $0x0
  801b85:	53                   	push   %ebx
  801b86:	6a 00                	push   $0x0
  801b88:	e8 3e f2 ff ff       	call   800dcb <sys_page_map>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	83 c4 20             	add    $0x20,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	79 a4                	jns    801b3a <dup+0x71>
	sys_page_unmap(0, newfd);
  801b96:	83 ec 08             	sub    $0x8,%esp
  801b99:	56                   	push   %esi
  801b9a:	6a 00                	push   $0x0
  801b9c:	e8 6c f2 ff ff       	call   800e0d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ba1:	83 c4 08             	add    $0x8,%esp
  801ba4:	ff 75 d4             	push   -0x2c(%ebp)
  801ba7:	6a 00                	push   $0x0
  801ba9:	e8 5f f2 ff ff       	call   800e0d <sys_page_unmap>
	return r;
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	eb b3                	jmp    801b66 <dup+0x9d>

00801bb3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 18             	sub    $0x18,%esp
  801bbb:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc1:	50                   	push   %eax
  801bc2:	56                   	push   %esi
  801bc3:	e8 87 fd ff ff       	call   80194f <fd_lookup>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 3c                	js     801c0b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bcf:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd8:	50                   	push   %eax
  801bd9:	ff 33                	push   (%ebx)
  801bdb:	e8 bf fd ff ff       	call   80199f <dev_lookup>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 24                	js     801c0b <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801be7:	8b 43 08             	mov    0x8(%ebx),%eax
  801bea:	83 e0 03             	and    $0x3,%eax
  801bed:	83 f8 01             	cmp    $0x1,%eax
  801bf0:	74 20                	je     801c12 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf5:	8b 40 08             	mov    0x8(%eax),%eax
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	74 37                	je     801c33 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bfc:	83 ec 04             	sub    $0x4,%esp
  801bff:	ff 75 10             	push   0x10(%ebp)
  801c02:	ff 75 0c             	push   0xc(%ebp)
  801c05:	53                   	push   %ebx
  801c06:	ff d0                	call   *%eax
  801c08:	83 c4 10             	add    $0x10,%esp
}
  801c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5e                   	pop    %esi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c12:	a1 00 40 80 00       	mov    0x804000,%eax
  801c17:	8b 40 48             	mov    0x48(%eax),%eax
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	56                   	push   %esi
  801c1e:	50                   	push   %eax
  801c1f:	68 35 2f 80 00       	push   $0x802f35
  801c24:	e8 9e e6 ff ff       	call   8002c7 <cprintf>
		return -E_INVAL;
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c31:	eb d8                	jmp    801c0b <read+0x58>
		return -E_NOT_SUPP;
  801c33:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c38:	eb d1                	jmp    801c0b <read+0x58>

00801c3a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	57                   	push   %edi
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 0c             	sub    $0xc,%esp
  801c43:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c46:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c49:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c4e:	eb 02                	jmp    801c52 <readn+0x18>
  801c50:	01 c3                	add    %eax,%ebx
  801c52:	39 f3                	cmp    %esi,%ebx
  801c54:	73 21                	jae    801c77 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	89 f0                	mov    %esi,%eax
  801c5b:	29 d8                	sub    %ebx,%eax
  801c5d:	50                   	push   %eax
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	03 45 0c             	add    0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	57                   	push   %edi
  801c65:	e8 49 ff ff ff       	call   801bb3 <read>
		if (m < 0)
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 04                	js     801c75 <readn+0x3b>
			return m;
		if (m == 0)
  801c71:	75 dd                	jne    801c50 <readn+0x16>
  801c73:	eb 02                	jmp    801c77 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c75:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5f                   	pop    %edi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	56                   	push   %esi
  801c85:	53                   	push   %ebx
  801c86:	83 ec 18             	sub    $0x18,%esp
  801c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8f:	50                   	push   %eax
  801c90:	53                   	push   %ebx
  801c91:	e8 b9 fc ff ff       	call   80194f <fd_lookup>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 37                	js     801cd4 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9d:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca6:	50                   	push   %eax
  801ca7:	ff 36                	push   (%esi)
  801ca9:	e8 f1 fc ff ff       	call   80199f <dev_lookup>
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 1f                	js     801cd4 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cb5:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801cb9:	74 20                	je     801cdb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	74 37                	je     801cfc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	ff 75 10             	push   0x10(%ebp)
  801ccb:	ff 75 0c             	push   0xc(%ebp)
  801cce:	56                   	push   %esi
  801ccf:	ff d0                	call   *%eax
  801cd1:	83 c4 10             	add    $0x10,%esp
}
  801cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cdb:	a1 00 40 80 00       	mov    0x804000,%eax
  801ce0:	8b 40 48             	mov    0x48(%eax),%eax
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	53                   	push   %ebx
  801ce7:	50                   	push   %eax
  801ce8:	68 51 2f 80 00       	push   $0x802f51
  801ced:	e8 d5 e5 ff ff       	call   8002c7 <cprintf>
		return -E_INVAL;
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cfa:	eb d8                	jmp    801cd4 <write+0x53>
		return -E_NOT_SUPP;
  801cfc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d01:	eb d1                	jmp    801cd4 <write+0x53>

00801d03 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	ff 75 08             	push   0x8(%ebp)
  801d10:	e8 3a fc ff ff       	call   80194f <fd_lookup>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 0e                	js     801d2a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 18             	sub    $0x18,%esp
  801d34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3a:	50                   	push   %eax
  801d3b:	53                   	push   %ebx
  801d3c:	e8 0e fc ff ff       	call   80194f <fd_lookup>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 34                	js     801d7c <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d48:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801d4b:	83 ec 08             	sub    $0x8,%esp
  801d4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d51:	50                   	push   %eax
  801d52:	ff 36                	push   (%esi)
  801d54:	e8 46 fc ff ff       	call   80199f <dev_lookup>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 1c                	js     801d7c <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d60:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801d64:	74 1d                	je     801d83 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 40 18             	mov    0x18(%eax),%eax
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	74 34                	je     801da4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	ff 75 0c             	push   0xc(%ebp)
  801d76:	56                   	push   %esi
  801d77:	ff d0                	call   *%eax
  801d79:	83 c4 10             	add    $0x10,%esp
}
  801d7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d83:	a1 00 40 80 00       	mov    0x804000,%eax
  801d88:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	53                   	push   %ebx
  801d8f:	50                   	push   %eax
  801d90:	68 14 2f 80 00       	push   $0x802f14
  801d95:	e8 2d e5 ff ff       	call   8002c7 <cprintf>
		return -E_INVAL;
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da2:	eb d8                	jmp    801d7c <ftruncate+0x50>
		return -E_NOT_SUPP;
  801da4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801da9:	eb d1                	jmp    801d7c <ftruncate+0x50>

00801dab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 18             	sub    $0x18,%esp
  801db3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db9:	50                   	push   %eax
  801dba:	ff 75 08             	push   0x8(%ebp)
  801dbd:	e8 8d fb ff ff       	call   80194f <fd_lookup>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	78 49                	js     801e12 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dc9:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd2:	50                   	push   %eax
  801dd3:	ff 36                	push   (%esi)
  801dd5:	e8 c5 fb ff ff       	call   80199f <dev_lookup>
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 31                	js     801e12 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801de8:	74 2f                	je     801e19 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801dea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ded:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801df4:	00 00 00 
	stat->st_isdir = 0;
  801df7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfe:	00 00 00 
	stat->st_dev = dev;
  801e01:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	53                   	push   %ebx
  801e0b:	56                   	push   %esi
  801e0c:	ff 50 14             	call   *0x14(%eax)
  801e0f:	83 c4 10             	add    $0x10,%esp
}
  801e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
		return -E_NOT_SUPP;
  801e19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e1e:	eb f2                	jmp    801e12 <fstat+0x67>

00801e20 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	6a 00                	push   $0x0
  801e2a:	ff 75 08             	push   0x8(%ebp)
  801e2d:	e8 22 02 00 00       	call   802054 <open>
  801e32:	89 c3                	mov    %eax,%ebx
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 1b                	js     801e56 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	ff 75 0c             	push   0xc(%ebp)
  801e41:	50                   	push   %eax
  801e42:	e8 64 ff ff ff       	call   801dab <fstat>
  801e47:	89 c6                	mov    %eax,%esi
	close(fd);
  801e49:	89 1c 24             	mov    %ebx,(%esp)
  801e4c:	e8 26 fc ff ff       	call   801a77 <close>
	return r;
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	89 f3                	mov    %esi,%ebx
}
  801e56:	89 d8                	mov    %ebx,%eax
  801e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	89 c6                	mov    %eax,%esi
  801e66:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e68:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e6f:	74 27                	je     801e98 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e71:	6a 07                	push   $0x7
  801e73:	68 00 50 80 00       	push   $0x805000
  801e78:	56                   	push   %esi
  801e79:	ff 35 00 60 80 00    	push   0x806000
  801e7f:	e8 82 07 00 00       	call   802606 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e84:	83 c4 0c             	add    $0xc,%esp
  801e87:	6a 00                	push   $0x0
  801e89:	53                   	push   %ebx
  801e8a:	6a 00                	push   $0x0
  801e8c:	e8 26 07 00 00       	call   8025b7 <ipc_recv>
}
  801e91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	6a 01                	push   $0x1
  801e9d:	e8 b0 07 00 00       	call   802652 <ipc_find_env>
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	eb c5                	jmp    801e71 <fsipc+0x12>

00801eac <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eca:	b8 02 00 00 00       	mov    $0x2,%eax
  801ecf:	e8 8b ff ff ff       	call   801e5f <fsipc>
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <devfile_flush>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eec:	b8 06 00 00 00       	mov    $0x6,%eax
  801ef1:	e8 69 ff ff ff       	call   801e5f <fsipc>
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <devfile_stat>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	53                   	push   %ebx
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f12:	b8 05 00 00 00       	mov    $0x5,%eax
  801f17:	e8 43 ff ff ff       	call   801e5f <fsipc>
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 2c                	js     801f4c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f20:	83 ec 08             	sub    $0x8,%esp
  801f23:	68 00 50 80 00       	push   $0x805000
  801f28:	53                   	push   %ebx
  801f29:	e8 5e ea ff ff       	call   80098c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f2e:	a1 80 50 80 00       	mov    0x805080,%eax
  801f33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f39:	a1 84 50 80 00       	mov    0x805084,%eax
  801f3e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <devfile_write>:
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801f66:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f6c:	53                   	push   %ebx
  801f6d:	ff 75 0c             	push   0xc(%ebp)
  801f70:	68 08 50 80 00       	push   $0x805008
  801f75:	e8 0a ec ff ff       	call   800b84 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7f:	b8 04 00 00 00       	mov    $0x4,%eax
  801f84:	e8 d6 fe ff ff       	call   801e5f <fsipc>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 0b                	js     801f9b <devfile_write+0x4a>
	assert(r <= n);
  801f90:	39 d8                	cmp    %ebx,%eax
  801f92:	77 0c                	ja     801fa0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f99:	7f 1e                	jg     801fb9 <devfile_write+0x68>
}
  801f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    
	assert(r <= n);
  801fa0:	68 80 2f 80 00       	push   $0x802f80
  801fa5:	68 ea 2d 80 00       	push   $0x802dea
  801faa:	68 97 00 00 00       	push   $0x97
  801faf:	68 87 2f 80 00       	push   $0x802f87
  801fb4:	e8 33 e2 ff ff       	call   8001ec <_panic>
	assert(r <= PGSIZE);
  801fb9:	68 92 2f 80 00       	push   $0x802f92
  801fbe:	68 ea 2d 80 00       	push   $0x802dea
  801fc3:	68 98 00 00 00       	push   $0x98
  801fc8:	68 87 2f 80 00       	push   $0x802f87
  801fcd:	e8 1a e2 ff ff       	call   8001ec <_panic>

00801fd2 <devfile_read>:
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801fe5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff5:	e8 65 fe ff ff       	call   801e5f <fsipc>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 1f                	js     80201f <devfile_read+0x4d>
	assert(r <= n);
  802000:	39 f0                	cmp    %esi,%eax
  802002:	77 24                	ja     802028 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802004:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802009:	7f 33                	jg     80203e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	50                   	push   %eax
  80200f:	68 00 50 80 00       	push   $0x805000
  802014:	ff 75 0c             	push   0xc(%ebp)
  802017:	e8 06 eb ff ff       	call   800b22 <memmove>
	return r;
  80201c:	83 c4 10             	add    $0x10,%esp
}
  80201f:	89 d8                	mov    %ebx,%eax
  802021:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802024:	5b                   	pop    %ebx
  802025:	5e                   	pop    %esi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    
	assert(r <= n);
  802028:	68 80 2f 80 00       	push   $0x802f80
  80202d:	68 ea 2d 80 00       	push   $0x802dea
  802032:	6a 7c                	push   $0x7c
  802034:	68 87 2f 80 00       	push   $0x802f87
  802039:	e8 ae e1 ff ff       	call   8001ec <_panic>
	assert(r <= PGSIZE);
  80203e:	68 92 2f 80 00       	push   $0x802f92
  802043:	68 ea 2d 80 00       	push   $0x802dea
  802048:	6a 7d                	push   $0x7d
  80204a:	68 87 2f 80 00       	push   $0x802f87
  80204f:	e8 98 e1 ff ff       	call   8001ec <_panic>

00802054 <open>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 1c             	sub    $0x1c,%esp
  80205c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80205f:	56                   	push   %esi
  802060:	e8 ec e8 ff ff       	call   800951 <strlen>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80206d:	7f 6c                	jg     8020db <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	e8 84 f8 ff ff       	call   8018ff <fd_alloc>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	78 3c                	js     8020c0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802084:	83 ec 08             	sub    $0x8,%esp
  802087:	56                   	push   %esi
  802088:	68 00 50 80 00       	push   $0x805000
  80208d:	e8 fa e8 ff ff       	call   80098c <strcpy>
	fsipcbuf.open.req_omode = mode;
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a2:	e8 b8 fd ff ff       	call   801e5f <fsipc>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 19                	js     8020c9 <open+0x75>
	return fd2num(fd);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	ff 75 f4             	push   -0xc(%ebp)
  8020b6:	e8 1d f8 ff ff       	call   8018d8 <fd2num>
  8020bb:	89 c3                	mov    %eax,%ebx
  8020bd:	83 c4 10             	add    $0x10,%esp
}
  8020c0:	89 d8                	mov    %ebx,%eax
  8020c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c5:	5b                   	pop    %ebx
  8020c6:	5e                   	pop    %esi
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    
		fd_close(fd, 0);
  8020c9:	83 ec 08             	sub    $0x8,%esp
  8020cc:	6a 00                	push   $0x0
  8020ce:	ff 75 f4             	push   -0xc(%ebp)
  8020d1:	e8 1a f9 ff ff       	call   8019f0 <fd_close>
		return r;
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	eb e5                	jmp    8020c0 <open+0x6c>
		return -E_BAD_PATH;
  8020db:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8020e0:	eb de                	jmp    8020c0 <open+0x6c>

008020e2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8020f2:	e8 68 fd ff ff       	call   801e5f <fsipc>
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	56                   	push   %esi
  8020fd:	53                   	push   %ebx
  8020fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	ff 75 08             	push   0x8(%ebp)
  802107:	e8 dc f7 ff ff       	call   8018e8 <fd2data>
  80210c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80210e:	83 c4 08             	add    $0x8,%esp
  802111:	68 9e 2f 80 00       	push   $0x802f9e
  802116:	53                   	push   %ebx
  802117:	e8 70 e8 ff ff       	call   80098c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80211c:	8b 46 04             	mov    0x4(%esi),%eax
  80211f:	2b 06                	sub    (%esi),%eax
  802121:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802127:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80212e:	00 00 00 
	stat->st_dev = &devpipe;
  802131:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  802138:	30 80 00 
	return 0;
}
  80213b:	b8 00 00 00 00       	mov    $0x0,%eax
  802140:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5d                   	pop    %ebp
  802146:	c3                   	ret    

00802147 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	53                   	push   %ebx
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802151:	53                   	push   %ebx
  802152:	6a 00                	push   $0x0
  802154:	e8 b4 ec ff ff       	call   800e0d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802159:	89 1c 24             	mov    %ebx,(%esp)
  80215c:	e8 87 f7 ff ff       	call   8018e8 <fd2data>
  802161:	83 c4 08             	add    $0x8,%esp
  802164:	50                   	push   %eax
  802165:	6a 00                	push   $0x0
  802167:	e8 a1 ec ff ff       	call   800e0d <sys_page_unmap>
}
  80216c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <_pipeisclosed>:
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	57                   	push   %edi
  802175:	56                   	push   %esi
  802176:	53                   	push   %ebx
  802177:	83 ec 1c             	sub    $0x1c,%esp
  80217a:	89 c7                	mov    %eax,%edi
  80217c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80217e:	a1 00 40 80 00       	mov    0x804000,%eax
  802183:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	57                   	push   %edi
  80218a:	e8 fc 04 00 00       	call   80268b <pageref>
  80218f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802192:	89 34 24             	mov    %esi,(%esp)
  802195:	e8 f1 04 00 00       	call   80268b <pageref>
		nn = thisenv->env_runs;
  80219a:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8021a0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	39 cb                	cmp    %ecx,%ebx
  8021a8:	74 1b                	je     8021c5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021aa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ad:	75 cf                	jne    80217e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021af:	8b 42 58             	mov    0x58(%edx),%eax
  8021b2:	6a 01                	push   $0x1
  8021b4:	50                   	push   %eax
  8021b5:	53                   	push   %ebx
  8021b6:	68 a5 2f 80 00       	push   $0x802fa5
  8021bb:	e8 07 e1 ff ff       	call   8002c7 <cprintf>
  8021c0:	83 c4 10             	add    $0x10,%esp
  8021c3:	eb b9                	jmp    80217e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021c8:	0f 94 c0             	sete   %al
  8021cb:	0f b6 c0             	movzbl %al,%eax
}
  8021ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <devpipe_write>:
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	57                   	push   %edi
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	83 ec 28             	sub    $0x28,%esp
  8021df:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021e2:	56                   	push   %esi
  8021e3:	e8 00 f7 ff ff       	call   8018e8 <fd2data>
  8021e8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021ea:	83 c4 10             	add    $0x10,%esp
  8021ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021f5:	75 09                	jne    802200 <devpipe_write+0x2a>
	return i;
  8021f7:	89 f8                	mov    %edi,%eax
  8021f9:	eb 23                	jmp    80221e <devpipe_write+0x48>
			sys_yield();
  8021fb:	e8 69 eb ff ff       	call   800d69 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802200:	8b 43 04             	mov    0x4(%ebx),%eax
  802203:	8b 0b                	mov    (%ebx),%ecx
  802205:	8d 51 20             	lea    0x20(%ecx),%edx
  802208:	39 d0                	cmp    %edx,%eax
  80220a:	72 1a                	jb     802226 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  80220c:	89 da                	mov    %ebx,%edx
  80220e:	89 f0                	mov    %esi,%eax
  802210:	e8 5c ff ff ff       	call   802171 <_pipeisclosed>
  802215:	85 c0                	test   %eax,%eax
  802217:	74 e2                	je     8021fb <devpipe_write+0x25>
				return 0;
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802229:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80222d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802230:	89 c2                	mov    %eax,%edx
  802232:	c1 fa 1f             	sar    $0x1f,%edx
  802235:	89 d1                	mov    %edx,%ecx
  802237:	c1 e9 1b             	shr    $0x1b,%ecx
  80223a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80223d:	83 e2 1f             	and    $0x1f,%edx
  802240:	29 ca                	sub    %ecx,%edx
  802242:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802246:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80224a:	83 c0 01             	add    $0x1,%eax
  80224d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802250:	83 c7 01             	add    $0x1,%edi
  802253:	eb 9d                	jmp    8021f2 <devpipe_write+0x1c>

00802255 <devpipe_read>:
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	57                   	push   %edi
  802259:	56                   	push   %esi
  80225a:	53                   	push   %ebx
  80225b:	83 ec 18             	sub    $0x18,%esp
  80225e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802261:	57                   	push   %edi
  802262:	e8 81 f6 ff ff       	call   8018e8 <fd2data>
  802267:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	be 00 00 00 00       	mov    $0x0,%esi
  802271:	3b 75 10             	cmp    0x10(%ebp),%esi
  802274:	75 13                	jne    802289 <devpipe_read+0x34>
	return i;
  802276:	89 f0                	mov    %esi,%eax
  802278:	eb 02                	jmp    80227c <devpipe_read+0x27>
				return i;
  80227a:	89 f0                	mov    %esi,%eax
}
  80227c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
			sys_yield();
  802284:	e8 e0 ea ff ff       	call   800d69 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802289:	8b 03                	mov    (%ebx),%eax
  80228b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80228e:	75 18                	jne    8022a8 <devpipe_read+0x53>
			if (i > 0)
  802290:	85 f6                	test   %esi,%esi
  802292:	75 e6                	jne    80227a <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  802294:	89 da                	mov    %ebx,%edx
  802296:	89 f8                	mov    %edi,%eax
  802298:	e8 d4 fe ff ff       	call   802171 <_pipeisclosed>
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 e3                	je     802284 <devpipe_read+0x2f>
				return 0;
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a6:	eb d4                	jmp    80227c <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022a8:	99                   	cltd   
  8022a9:	c1 ea 1b             	shr    $0x1b,%edx
  8022ac:	01 d0                	add    %edx,%eax
  8022ae:	83 e0 1f             	and    $0x1f,%eax
  8022b1:	29 d0                	sub    %edx,%eax
  8022b3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022bb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022be:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022c1:	83 c6 01             	add    $0x1,%esi
  8022c4:	eb ab                	jmp    802271 <devpipe_read+0x1c>

008022c6 <pipe>:
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d1:	50                   	push   %eax
  8022d2:	e8 28 f6 ff ff       	call   8018ff <fd_alloc>
  8022d7:	89 c3                	mov    %eax,%ebx
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	0f 88 23 01 00 00    	js     802407 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 07 04 00 00       	push   $0x407
  8022ec:	ff 75 f4             	push   -0xc(%ebp)
  8022ef:	6a 00                	push   $0x0
  8022f1:	e8 92 ea ff ff       	call   800d88 <sys_page_alloc>
  8022f6:	89 c3                	mov    %eax,%ebx
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	0f 88 04 01 00 00    	js     802407 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802309:	50                   	push   %eax
  80230a:	e8 f0 f5 ff ff       	call   8018ff <fd_alloc>
  80230f:	89 c3                	mov    %eax,%ebx
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	85 c0                	test   %eax,%eax
  802316:	0f 88 db 00 00 00    	js     8023f7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 07 04 00 00       	push   $0x407
  802324:	ff 75 f0             	push   -0x10(%ebp)
  802327:	6a 00                	push   $0x0
  802329:	e8 5a ea ff ff       	call   800d88 <sys_page_alloc>
  80232e:	89 c3                	mov    %eax,%ebx
  802330:	83 c4 10             	add    $0x10,%esp
  802333:	85 c0                	test   %eax,%eax
  802335:	0f 88 bc 00 00 00    	js     8023f7 <pipe+0x131>
	va = fd2data(fd0);
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	ff 75 f4             	push   -0xc(%ebp)
  802341:	e8 a2 f5 ff ff       	call   8018e8 <fd2data>
  802346:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802348:	83 c4 0c             	add    $0xc,%esp
  80234b:	68 07 04 00 00       	push   $0x407
  802350:	50                   	push   %eax
  802351:	6a 00                	push   $0x0
  802353:	e8 30 ea ff ff       	call   800d88 <sys_page_alloc>
  802358:	89 c3                	mov    %eax,%ebx
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	85 c0                	test   %eax,%eax
  80235f:	0f 88 82 00 00 00    	js     8023e7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	ff 75 f0             	push   -0x10(%ebp)
  80236b:	e8 78 f5 ff ff       	call   8018e8 <fd2data>
  802370:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802377:	50                   	push   %eax
  802378:	6a 00                	push   $0x0
  80237a:	56                   	push   %esi
  80237b:	6a 00                	push   $0x0
  80237d:	e8 49 ea ff ff       	call   800dcb <sys_page_map>
  802382:	89 c3                	mov    %eax,%ebx
  802384:	83 c4 20             	add    $0x20,%esp
  802387:	85 c0                	test   %eax,%eax
  802389:	78 4e                	js     8023d9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80238b:	a1 28 30 80 00       	mov    0x803028,%eax
  802390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802393:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802398:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80239f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023ae:	83 ec 0c             	sub    $0xc,%esp
  8023b1:	ff 75 f4             	push   -0xc(%ebp)
  8023b4:	e8 1f f5 ff ff       	call   8018d8 <fd2num>
  8023b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023be:	83 c4 04             	add    $0x4,%esp
  8023c1:	ff 75 f0             	push   -0x10(%ebp)
  8023c4:	e8 0f f5 ff ff       	call   8018d8 <fd2num>
  8023c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023d7:	eb 2e                	jmp    802407 <pipe+0x141>
	sys_page_unmap(0, va);
  8023d9:	83 ec 08             	sub    $0x8,%esp
  8023dc:	56                   	push   %esi
  8023dd:	6a 00                	push   $0x0
  8023df:	e8 29 ea ff ff       	call   800e0d <sys_page_unmap>
  8023e4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023e7:	83 ec 08             	sub    $0x8,%esp
  8023ea:	ff 75 f0             	push   -0x10(%ebp)
  8023ed:	6a 00                	push   $0x0
  8023ef:	e8 19 ea ff ff       	call   800e0d <sys_page_unmap>
  8023f4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023f7:	83 ec 08             	sub    $0x8,%esp
  8023fa:	ff 75 f4             	push   -0xc(%ebp)
  8023fd:	6a 00                	push   $0x0
  8023ff:	e8 09 ea ff ff       	call   800e0d <sys_page_unmap>
  802404:	83 c4 10             	add    $0x10,%esp
}
  802407:	89 d8                	mov    %ebx,%eax
  802409:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <pipeisclosed>:
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802416:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802419:	50                   	push   %eax
  80241a:	ff 75 08             	push   0x8(%ebp)
  80241d:	e8 2d f5 ff ff       	call   80194f <fd_lookup>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	85 c0                	test   %eax,%eax
  802427:	78 18                	js     802441 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	ff 75 f4             	push   -0xc(%ebp)
  80242f:	e8 b4 f4 ff ff       	call   8018e8 <fd2data>
  802434:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	e8 33 fd ff ff       	call   802171 <_pipeisclosed>
  80243e:	83 c4 10             	add    $0x10,%esp
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	c3                   	ret    

00802449 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80244f:	68 bd 2f 80 00       	push   $0x802fbd
  802454:	ff 75 0c             	push   0xc(%ebp)
  802457:	e8 30 e5 ff ff       	call   80098c <strcpy>
	return 0;
}
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <devcons_write>:
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	57                   	push   %edi
  802467:	56                   	push   %esi
  802468:	53                   	push   %ebx
  802469:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80246f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802474:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80247a:	eb 2e                	jmp    8024aa <devcons_write+0x47>
		m = n - tot;
  80247c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80247f:	29 f3                	sub    %esi,%ebx
  802481:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802486:	39 c3                	cmp    %eax,%ebx
  802488:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	53                   	push   %ebx
  80248f:	89 f0                	mov    %esi,%eax
  802491:	03 45 0c             	add    0xc(%ebp),%eax
  802494:	50                   	push   %eax
  802495:	57                   	push   %edi
  802496:	e8 87 e6 ff ff       	call   800b22 <memmove>
		sys_cputs(buf, m);
  80249b:	83 c4 08             	add    $0x8,%esp
  80249e:	53                   	push   %ebx
  80249f:	57                   	push   %edi
  8024a0:	e8 27 e8 ff ff       	call   800ccc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024a5:	01 de                	add    %ebx,%esi
  8024a7:	83 c4 10             	add    $0x10,%esp
  8024aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024ad:	72 cd                	jb     80247c <devcons_write+0x19>
}
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5f                   	pop    %edi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    

008024b9 <devcons_read>:
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 08             	sub    $0x8,%esp
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024c8:	75 07                	jne    8024d1 <devcons_read+0x18>
  8024ca:	eb 1f                	jmp    8024eb <devcons_read+0x32>
		sys_yield();
  8024cc:	e8 98 e8 ff ff       	call   800d69 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024d1:	e8 14 e8 ff ff       	call   800cea <sys_cgetc>
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 f2                	je     8024cc <devcons_read+0x13>
	if (c < 0)
  8024da:	78 0f                	js     8024eb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8024dc:	83 f8 04             	cmp    $0x4,%eax
  8024df:	74 0c                	je     8024ed <devcons_read+0x34>
	*(char*)vbuf = c;
  8024e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e4:	88 02                	mov    %al,(%edx)
	return 1;
  8024e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    
		return 0;
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f2:	eb f7                	jmp    8024eb <devcons_read+0x32>

008024f4 <cputchar>:
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802500:	6a 01                	push   $0x1
  802502:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802505:	50                   	push   %eax
  802506:	e8 c1 e7 ff ff       	call   800ccc <sys_cputs>
}
  80250b:	83 c4 10             	add    $0x10,%esp
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <getchar>:
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802516:	6a 01                	push   $0x1
  802518:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80251b:	50                   	push   %eax
  80251c:	6a 00                	push   $0x0
  80251e:	e8 90 f6 ff ff       	call   801bb3 <read>
	if (r < 0)
  802523:	83 c4 10             	add    $0x10,%esp
  802526:	85 c0                	test   %eax,%eax
  802528:	78 06                	js     802530 <getchar+0x20>
	if (r < 1)
  80252a:	74 06                	je     802532 <getchar+0x22>
	return c;
  80252c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    
		return -E_EOF;
  802532:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802537:	eb f7                	jmp    802530 <getchar+0x20>

00802539 <iscons>:
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80253f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802542:	50                   	push   %eax
  802543:	ff 75 08             	push   0x8(%ebp)
  802546:	e8 04 f4 ff ff       	call   80194f <fd_lookup>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 11                	js     802563 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 15 44 30 80 00    	mov    0x803044,%edx
  80255b:	39 10                	cmp    %edx,(%eax)
  80255d:	0f 94 c0             	sete   %al
  802560:	0f b6 c0             	movzbl %al,%eax
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <opencons>:
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80256b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256e:	50                   	push   %eax
  80256f:	e8 8b f3 ff ff       	call   8018ff <fd_alloc>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	85 c0                	test   %eax,%eax
  802579:	78 3a                	js     8025b5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 07 04 00 00       	push   $0x407
  802583:	ff 75 f4             	push   -0xc(%ebp)
  802586:	6a 00                	push   $0x0
  802588:	e8 fb e7 ff ff       	call   800d88 <sys_page_alloc>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	85 c0                	test   %eax,%eax
  802592:	78 21                	js     8025b5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 15 44 30 80 00    	mov    0x803044,%edx
  80259d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	50                   	push   %eax
  8025ad:	e8 26 f3 ff ff       	call   8018d8 <fd2num>
  8025b2:	83 c4 10             	add    $0x10,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	56                   	push   %esi
  8025bb:	53                   	push   %ebx
  8025bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8025bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	ff 75 0c             	push   0xc(%ebp)
  8025c8:	e8 6b e9 ff ff       	call   800f38 <sys_ipc_recv>
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	78 2b                	js     8025ff <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8025d4:	85 f6                	test   %esi,%esi
  8025d6:	74 0a                	je     8025e2 <ipc_recv+0x2b>
  8025d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8025dd:	8b 40 74             	mov    0x74(%eax),%eax
  8025e0:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8025e2:	85 db                	test   %ebx,%ebx
  8025e4:	74 0a                	je     8025f0 <ipc_recv+0x39>
  8025e6:	a1 00 40 80 00       	mov    0x804000,%eax
  8025eb:	8b 40 78             	mov    0x78(%eax),%eax
  8025ee:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8025f0:	a1 00 40 80 00       	mov    0x804000,%eax
  8025f5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8025f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025fb:	5b                   	pop    %ebx
  8025fc:	5e                   	pop    %esi
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8025ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802604:	eb f2                	jmp    8025f8 <ipc_recv+0x41>

00802606 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802612:	8b 75 0c             	mov    0xc(%ebp),%esi
  802615:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802618:	ff 75 14             	push   0x14(%ebp)
  80261b:	53                   	push   %ebx
  80261c:	56                   	push   %esi
  80261d:	57                   	push   %edi
  80261e:	e8 f2 e8 ff ff       	call   800f15 <sys_ipc_try_send>
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	85 c0                	test   %eax,%eax
  802628:	79 20                	jns    80264a <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80262a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80262d:	75 07                	jne    802636 <ipc_send+0x30>
		sys_yield();
  80262f:	e8 35 e7 ff ff       	call   800d69 <sys_yield>
  802634:	eb e2                	jmp    802618 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 c9 2f 80 00       	push   $0x802fc9
  80263e:	6a 2e                	push   $0x2e
  802640:	68 d9 2f 80 00       	push   $0x802fd9
  802645:	e8 a2 db ff ff       	call   8001ec <_panic>
	}
}
  80264a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5f                   	pop    %edi
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    

00802652 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80265d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802660:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802666:	8b 52 50             	mov    0x50(%edx),%edx
  802669:	39 ca                	cmp    %ecx,%edx
  80266b:	74 11                	je     80267e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80266d:	83 c0 01             	add    $0x1,%eax
  802670:	3d 00 04 00 00       	cmp    $0x400,%eax
  802675:	75 e6                	jne    80265d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	eb 0b                	jmp    802689 <ipc_find_env+0x37>
			return envs[i].env_id;
  80267e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802681:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802686:	8b 40 48             	mov    0x48(%eax),%eax
}
  802689:	5d                   	pop    %ebp
  80268a:	c3                   	ret    

0080268b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802691:	89 c2                	mov    %eax,%edx
  802693:	c1 ea 16             	shr    $0x16,%edx
  802696:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80269d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026a2:	f6 c1 01             	test   $0x1,%cl
  8026a5:	74 1c                	je     8026c3 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8026a7:	c1 e8 0c             	shr    $0xc,%eax
  8026aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026b1:	a8 01                	test   $0x1,%al
  8026b3:	74 0e                	je     8026c3 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026b5:	c1 e8 0c             	shr    $0xc,%eax
  8026b8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8026bf:	ef 
  8026c0:	0f b7 d2             	movzwl %dx,%edx
}
  8026c3:	89 d0                	mov    %edx,%eax
  8026c5:	5d                   	pop    %ebp
  8026c6:	c3                   	ret    
  8026c7:	66 90                	xchg   %ax,%ax
  8026c9:	66 90                	xchg   %ax,%ax
  8026cb:	66 90                	xchg   %ax,%ax
  8026cd:	66 90                	xchg   %ax,%ax
  8026cf:	90                   	nop

008026d0 <__udivdi3>:
  8026d0:	f3 0f 1e fb          	endbr32 
  8026d4:	55                   	push   %ebp
  8026d5:	57                   	push   %edi
  8026d6:	56                   	push   %esi
  8026d7:	53                   	push   %ebx
  8026d8:	83 ec 1c             	sub    $0x1c,%esp
  8026db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	75 19                	jne    802708 <__udivdi3+0x38>
  8026ef:	39 f3                	cmp    %esi,%ebx
  8026f1:	76 4d                	jbe    802740 <__udivdi3+0x70>
  8026f3:	31 ff                	xor    %edi,%edi
  8026f5:	89 e8                	mov    %ebp,%eax
  8026f7:	89 f2                	mov    %esi,%edx
  8026f9:	f7 f3                	div    %ebx
  8026fb:	89 fa                	mov    %edi,%edx
  8026fd:	83 c4 1c             	add    $0x1c,%esp
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    
  802705:	8d 76 00             	lea    0x0(%esi),%esi
  802708:	39 f0                	cmp    %esi,%eax
  80270a:	76 14                	jbe    802720 <__udivdi3+0x50>
  80270c:	31 ff                	xor    %edi,%edi
  80270e:	31 c0                	xor    %eax,%eax
  802710:	89 fa                	mov    %edi,%edx
  802712:	83 c4 1c             	add    $0x1c,%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5f                   	pop    %edi
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    
  80271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802720:	0f bd f8             	bsr    %eax,%edi
  802723:	83 f7 1f             	xor    $0x1f,%edi
  802726:	75 48                	jne    802770 <__udivdi3+0xa0>
  802728:	39 f0                	cmp    %esi,%eax
  80272a:	72 06                	jb     802732 <__udivdi3+0x62>
  80272c:	31 c0                	xor    %eax,%eax
  80272e:	39 eb                	cmp    %ebp,%ebx
  802730:	77 de                	ja     802710 <__udivdi3+0x40>
  802732:	b8 01 00 00 00       	mov    $0x1,%eax
  802737:	eb d7                	jmp    802710 <__udivdi3+0x40>
  802739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802740:	89 d9                	mov    %ebx,%ecx
  802742:	85 db                	test   %ebx,%ebx
  802744:	75 0b                	jne    802751 <__udivdi3+0x81>
  802746:	b8 01 00 00 00       	mov    $0x1,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f3                	div    %ebx
  80274f:	89 c1                	mov    %eax,%ecx
  802751:	31 d2                	xor    %edx,%edx
  802753:	89 f0                	mov    %esi,%eax
  802755:	f7 f1                	div    %ecx
  802757:	89 c6                	mov    %eax,%esi
  802759:	89 e8                	mov    %ebp,%eax
  80275b:	89 f7                	mov    %esi,%edi
  80275d:	f7 f1                	div    %ecx
  80275f:	89 fa                	mov    %edi,%edx
  802761:	83 c4 1c             	add    $0x1c,%esp
  802764:	5b                   	pop    %ebx
  802765:	5e                   	pop    %esi
  802766:	5f                   	pop    %edi
  802767:	5d                   	pop    %ebp
  802768:	c3                   	ret    
  802769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802770:	89 f9                	mov    %edi,%ecx
  802772:	ba 20 00 00 00       	mov    $0x20,%edx
  802777:	29 fa                	sub    %edi,%edx
  802779:	d3 e0                	shl    %cl,%eax
  80277b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80277f:	89 d1                	mov    %edx,%ecx
  802781:	89 d8                	mov    %ebx,%eax
  802783:	d3 e8                	shr    %cl,%eax
  802785:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802789:	09 c1                	or     %eax,%ecx
  80278b:	89 f0                	mov    %esi,%eax
  80278d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802791:	89 f9                	mov    %edi,%ecx
  802793:	d3 e3                	shl    %cl,%ebx
  802795:	89 d1                	mov    %edx,%ecx
  802797:	d3 e8                	shr    %cl,%eax
  802799:	89 f9                	mov    %edi,%ecx
  80279b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80279f:	89 eb                	mov    %ebp,%ebx
  8027a1:	d3 e6                	shl    %cl,%esi
  8027a3:	89 d1                	mov    %edx,%ecx
  8027a5:	d3 eb                	shr    %cl,%ebx
  8027a7:	09 f3                	or     %esi,%ebx
  8027a9:	89 c6                	mov    %eax,%esi
  8027ab:	89 f2                	mov    %esi,%edx
  8027ad:	89 d8                	mov    %ebx,%eax
  8027af:	f7 74 24 08          	divl   0x8(%esp)
  8027b3:	89 d6                	mov    %edx,%esi
  8027b5:	89 c3                	mov    %eax,%ebx
  8027b7:	f7 64 24 0c          	mull   0xc(%esp)
  8027bb:	39 d6                	cmp    %edx,%esi
  8027bd:	72 19                	jb     8027d8 <__udivdi3+0x108>
  8027bf:	89 f9                	mov    %edi,%ecx
  8027c1:	d3 e5                	shl    %cl,%ebp
  8027c3:	39 c5                	cmp    %eax,%ebp
  8027c5:	73 04                	jae    8027cb <__udivdi3+0xfb>
  8027c7:	39 d6                	cmp    %edx,%esi
  8027c9:	74 0d                	je     8027d8 <__udivdi3+0x108>
  8027cb:	89 d8                	mov    %ebx,%eax
  8027cd:	31 ff                	xor    %edi,%edi
  8027cf:	e9 3c ff ff ff       	jmp    802710 <__udivdi3+0x40>
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027db:	31 ff                	xor    %edi,%edi
  8027dd:	e9 2e ff ff ff       	jmp    802710 <__udivdi3+0x40>
  8027e2:	66 90                	xchg   %ax,%ax
  8027e4:	66 90                	xchg   %ax,%ax
  8027e6:	66 90                	xchg   %ax,%ax
  8027e8:	66 90                	xchg   %ax,%ax
  8027ea:	66 90                	xchg   %ax,%ax
  8027ec:	66 90                	xchg   %ax,%ax
  8027ee:	66 90                	xchg   %ax,%ax

008027f0 <__umoddi3>:
  8027f0:	f3 0f 1e fb          	endbr32 
  8027f4:	55                   	push   %ebp
  8027f5:	57                   	push   %edi
  8027f6:	56                   	push   %esi
  8027f7:	53                   	push   %ebx
  8027f8:	83 ec 1c             	sub    $0x1c,%esp
  8027fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802803:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802807:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80280b:	89 f0                	mov    %esi,%eax
  80280d:	89 da                	mov    %ebx,%edx
  80280f:	85 ff                	test   %edi,%edi
  802811:	75 15                	jne    802828 <__umoddi3+0x38>
  802813:	39 dd                	cmp    %ebx,%ebp
  802815:	76 39                	jbe    802850 <__umoddi3+0x60>
  802817:	f7 f5                	div    %ebp
  802819:	89 d0                	mov    %edx,%eax
  80281b:	31 d2                	xor    %edx,%edx
  80281d:	83 c4 1c             	add    $0x1c,%esp
  802820:	5b                   	pop    %ebx
  802821:	5e                   	pop    %esi
  802822:	5f                   	pop    %edi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    
  802825:	8d 76 00             	lea    0x0(%esi),%esi
  802828:	39 df                	cmp    %ebx,%edi
  80282a:	77 f1                	ja     80281d <__umoddi3+0x2d>
  80282c:	0f bd cf             	bsr    %edi,%ecx
  80282f:	83 f1 1f             	xor    $0x1f,%ecx
  802832:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802836:	75 40                	jne    802878 <__umoddi3+0x88>
  802838:	39 df                	cmp    %ebx,%edi
  80283a:	72 04                	jb     802840 <__umoddi3+0x50>
  80283c:	39 f5                	cmp    %esi,%ebp
  80283e:	77 dd                	ja     80281d <__umoddi3+0x2d>
  802840:	89 da                	mov    %ebx,%edx
  802842:	89 f0                	mov    %esi,%eax
  802844:	29 e8                	sub    %ebp,%eax
  802846:	19 fa                	sbb    %edi,%edx
  802848:	eb d3                	jmp    80281d <__umoddi3+0x2d>
  80284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802850:	89 e9                	mov    %ebp,%ecx
  802852:	85 ed                	test   %ebp,%ebp
  802854:	75 0b                	jne    802861 <__umoddi3+0x71>
  802856:	b8 01 00 00 00       	mov    $0x1,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	f7 f5                	div    %ebp
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	89 d8                	mov    %ebx,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f1                	div    %ecx
  802867:	89 f0                	mov    %esi,%eax
  802869:	f7 f1                	div    %ecx
  80286b:	89 d0                	mov    %edx,%eax
  80286d:	31 d2                	xor    %edx,%edx
  80286f:	eb ac                	jmp    80281d <__umoddi3+0x2d>
  802871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802878:	8b 44 24 04          	mov    0x4(%esp),%eax
  80287c:	ba 20 00 00 00       	mov    $0x20,%edx
  802881:	29 c2                	sub    %eax,%edx
  802883:	89 c1                	mov    %eax,%ecx
  802885:	89 e8                	mov    %ebp,%eax
  802887:	d3 e7                	shl    %cl,%edi
  802889:	89 d1                	mov    %edx,%ecx
  80288b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80288f:	d3 e8                	shr    %cl,%eax
  802891:	89 c1                	mov    %eax,%ecx
  802893:	8b 44 24 04          	mov    0x4(%esp),%eax
  802897:	09 f9                	or     %edi,%ecx
  802899:	89 df                	mov    %ebx,%edi
  80289b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80289f:	89 c1                	mov    %eax,%ecx
  8028a1:	d3 e5                	shl    %cl,%ebp
  8028a3:	89 d1                	mov    %edx,%ecx
  8028a5:	d3 ef                	shr    %cl,%edi
  8028a7:	89 c1                	mov    %eax,%ecx
  8028a9:	89 f0                	mov    %esi,%eax
  8028ab:	d3 e3                	shl    %cl,%ebx
  8028ad:	89 d1                	mov    %edx,%ecx
  8028af:	89 fa                	mov    %edi,%edx
  8028b1:	d3 e8                	shr    %cl,%eax
  8028b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028b8:	09 d8                	or     %ebx,%eax
  8028ba:	f7 74 24 08          	divl   0x8(%esp)
  8028be:	89 d3                	mov    %edx,%ebx
  8028c0:	d3 e6                	shl    %cl,%esi
  8028c2:	f7 e5                	mul    %ebp
  8028c4:	89 c7                	mov    %eax,%edi
  8028c6:	89 d1                	mov    %edx,%ecx
  8028c8:	39 d3                	cmp    %edx,%ebx
  8028ca:	72 06                	jb     8028d2 <__umoddi3+0xe2>
  8028cc:	75 0e                	jne    8028dc <__umoddi3+0xec>
  8028ce:	39 c6                	cmp    %eax,%esi
  8028d0:	73 0a                	jae    8028dc <__umoddi3+0xec>
  8028d2:	29 e8                	sub    %ebp,%eax
  8028d4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8028d8:	89 d1                	mov    %edx,%ecx
  8028da:	89 c7                	mov    %eax,%edi
  8028dc:	89 f5                	mov    %esi,%ebp
  8028de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8028e2:	29 fd                	sub    %edi,%ebp
  8028e4:	19 cb                	sbb    %ecx,%ebx
  8028e6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8028eb:	89 d8                	mov    %ebx,%eax
  8028ed:	d3 e0                	shl    %cl,%eax
  8028ef:	89 f1                	mov    %esi,%ecx
  8028f1:	d3 ed                	shr    %cl,%ebp
  8028f3:	d3 eb                	shr    %cl,%ebx
  8028f5:	09 e8                	or     %ebp,%eax
  8028f7:	89 da                	mov    %ebx,%edx
  8028f9:	83 c4 1c             	add    $0x1c,%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5f                   	pop    %edi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
