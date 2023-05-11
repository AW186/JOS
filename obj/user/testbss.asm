
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 20 11 80 00       	push   $0x801120
  80003e:	e8 cc 01 00 00       	call   80020f <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 68 11 80 00       	push   $0x801168
  800095:	e8 75 01 00 00       	call   80020f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 c7 11 80 00       	push   $0x8011c7
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 b8 11 80 00       	push   $0x8011b8
  8000b3:	e8 7c 00 00 00       	call   800134 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 9b 11 80 00       	push   $0x80119b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 b8 11 80 00       	push   $0x8011b8
  8000c5:	e8 6a 00 00 00       	call   800134 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 40 11 80 00       	push   $0x801140
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 b8 11 80 00       	push   $0x8011b8
  8000d7:	e8 58 00 00 00       	call   800134 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 a6 0b 00 00       	call   800c92 <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800128:	6a 00                	push   $0x0
  80012a:	e8 22 0b 00 00       	call   800c51 <sys_env_destroy>
}
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	c9                   	leave  
  800133:	c3                   	ret    

00800134 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800139:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80013c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800142:	e8 4b 0b 00 00       	call   800c92 <sys_getenvid>
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	ff 75 0c             	push   0xc(%ebp)
  80014d:	ff 75 08             	push   0x8(%ebp)
  800150:	56                   	push   %esi
  800151:	50                   	push   %eax
  800152:	68 e8 11 80 00       	push   $0x8011e8
  800157:	e8 b3 00 00 00       	call   80020f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015c:	83 c4 18             	add    $0x18,%esp
  80015f:	53                   	push   %ebx
  800160:	ff 75 10             	push   0x10(%ebp)
  800163:	e8 56 00 00 00       	call   8001be <vcprintf>
	cprintf("\n");
  800168:	c7 04 24 b6 11 80 00 	movl   $0x8011b6,(%esp)
  80016f:	e8 9b 00 00 00       	call   80020f <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800177:	cc                   	int3   
  800178:	eb fd                	jmp    800177 <_panic+0x43>

0080017a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	53                   	push   %ebx
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800184:	8b 13                	mov    (%ebx),%edx
  800186:	8d 42 01             	lea    0x1(%edx),%eax
  800189:	89 03                	mov    %eax,(%ebx)
  80018b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800192:	3d ff 00 00 00       	cmp    $0xff,%eax
  800197:	74 09                	je     8001a2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800199:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 ff 00 00 00       	push   $0xff
  8001aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ad:	50                   	push   %eax
  8001ae:	e8 61 0a 00 00       	call   800c14 <sys_cputs>
		b->idx = 0;
  8001b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b9:	83 c4 10             	add    $0x10,%esp
  8001bc:	eb db                	jmp    800199 <putch+0x1f>

008001be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ce:	00 00 00 
	b.cnt = 0;
  8001d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001db:	ff 75 0c             	push   0xc(%ebp)
  8001de:	ff 75 08             	push   0x8(%ebp)
  8001e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	68 7a 01 80 00       	push   $0x80017a
  8001ed:	e8 14 01 00 00       	call   800306 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f2:	83 c4 08             	add    $0x8,%esp
  8001f5:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800201:	50                   	push   %eax
  800202:	e8 0d 0a 00 00       	call   800c14 <sys_cputs>

	return b.cnt;
}
  800207:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800215:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800218:	50                   	push   %eax
  800219:	ff 75 08             	push   0x8(%ebp)
  80021c:	e8 9d ff ff ff       	call   8001be <vcprintf>
	va_end(ap);

	return cnt;
}
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	57                   	push   %edi
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	83 ec 1c             	sub    $0x1c,%esp
  80022c:	89 c7                	mov    %eax,%edi
  80022e:	89 d6                	mov    %edx,%esi
  800230:	8b 45 08             	mov    0x8(%ebp),%eax
  800233:	8b 55 0c             	mov    0xc(%ebp),%edx
  800236:	89 d1                	mov    %edx,%ecx
  800238:	89 c2                	mov    %eax,%edx
  80023a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800240:	8b 45 10             	mov    0x10(%ebp),%eax
  800243:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800246:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800249:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800250:	39 c2                	cmp    %eax,%edx
  800252:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800255:	72 3e                	jb     800295 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 18             	push   0x18(%ebp)
  80025d:	83 eb 01             	sub    $0x1,%ebx
  800260:	53                   	push   %ebx
  800261:	50                   	push   %eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	ff 75 e4             	push   -0x1c(%ebp)
  800268:	ff 75 e0             	push   -0x20(%ebp)
  80026b:	ff 75 dc             	push   -0x24(%ebp)
  80026e:	ff 75 d8             	push   -0x28(%ebp)
  800271:	e8 5a 0c 00 00       	call   800ed0 <__udivdi3>
  800276:	83 c4 18             	add    $0x18,%esp
  800279:	52                   	push   %edx
  80027a:	50                   	push   %eax
  80027b:	89 f2                	mov    %esi,%edx
  80027d:	89 f8                	mov    %edi,%eax
  80027f:	e8 9f ff ff ff       	call   800223 <printnum>
  800284:	83 c4 20             	add    $0x20,%esp
  800287:	eb 13                	jmp    80029c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	56                   	push   %esi
  80028d:	ff 75 18             	push   0x18(%ebp)
  800290:	ff d7                	call   *%edi
  800292:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800295:	83 eb 01             	sub    $0x1,%ebx
  800298:	85 db                	test   %ebx,%ebx
  80029a:	7f ed                	jg     800289 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	56                   	push   %esi
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	ff 75 e4             	push   -0x1c(%ebp)
  8002a6:	ff 75 e0             	push   -0x20(%ebp)
  8002a9:	ff 75 dc             	push   -0x24(%ebp)
  8002ac:	ff 75 d8             	push   -0x28(%ebp)
  8002af:	e8 3c 0d 00 00       	call   800ff0 <__umoddi3>
  8002b4:	83 c4 14             	add    $0x14,%esp
  8002b7:	0f be 80 0b 12 80 00 	movsbl 0x80120b(%eax),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff d7                	call   *%edi
}
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d6:	8b 10                	mov    (%eax),%edx
  8002d8:	3b 50 04             	cmp    0x4(%eax),%edx
  8002db:	73 0a                	jae    8002e7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e0:	89 08                	mov    %ecx,(%eax)
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	88 02                	mov    %al,(%edx)
}
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <printfmt>:
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ef:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f2:	50                   	push   %eax
  8002f3:	ff 75 10             	push   0x10(%ebp)
  8002f6:	ff 75 0c             	push   0xc(%ebp)
  8002f9:	ff 75 08             	push   0x8(%ebp)
  8002fc:	e8 05 00 00 00       	call   800306 <vprintfmt>
}
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <vprintfmt>:
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 3c             	sub    $0x3c,%esp
  80030f:	8b 75 08             	mov    0x8(%ebp),%esi
  800312:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800315:	8b 7d 10             	mov    0x10(%ebp),%edi
  800318:	eb 0a                	jmp    800324 <vprintfmt+0x1e>
			putch(ch, putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	53                   	push   %ebx
  80031e:	50                   	push   %eax
  80031f:	ff d6                	call   *%esi
  800321:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800324:	83 c7 01             	add    $0x1,%edi
  800327:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80032b:	83 f8 25             	cmp    $0x25,%eax
  80032e:	74 0c                	je     80033c <vprintfmt+0x36>
			if (ch == '\0')
  800330:	85 c0                	test   %eax,%eax
  800332:	75 e6                	jne    80031a <vprintfmt+0x14>
}
  800334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    
		padc = ' ';
  80033c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800340:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800347:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80034e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800355:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 47 01             	lea    0x1(%edi),%eax
  80035d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800360:	0f b6 17             	movzbl (%edi),%edx
  800363:	8d 42 dd             	lea    -0x23(%edx),%eax
  800366:	3c 55                	cmp    $0x55,%al
  800368:	0f 87 a6 04 00 00    	ja     800814 <vprintfmt+0x50e>
  80036e:	0f b6 c0             	movzbl %al,%eax
  800371:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  800378:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80037b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80037f:	eb d9                	jmp    80035a <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800384:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800388:	eb d0                	jmp    80035a <vprintfmt+0x54>
  80038a:	0f b6 d2             	movzbl %dl,%edx
  80038d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800390:	b8 00 00 00 00       	mov    $0x0,%eax
  800395:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800398:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a5:	83 f9 09             	cmp    $0x9,%ecx
  8003a8:	77 55                	ja     8003ff <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ad:	eb e9                	jmp    800398 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8d 40 04             	lea    0x4(%eax),%eax
  8003bd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003c7:	79 91                	jns    80035a <vprintfmt+0x54>
				width = precision, precision = -1;
  8003c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003d6:	eb 82                	jmp    80035a <vprintfmt+0x54>
  8003d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003db:	85 d2                	test   %edx,%edx
  8003dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e2:	0f 49 c2             	cmovns %edx,%eax
  8003e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003eb:	e9 6a ff ff ff       	jmp    80035a <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003f3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003fa:	e9 5b ff ff ff       	jmp    80035a <vprintfmt+0x54>
  8003ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800405:	eb bc                	jmp    8003c3 <vprintfmt+0xbd>
			lflag++;
  800407:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80040d:	e9 48 ff ff ff       	jmp    80035a <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 78 04             	lea    0x4(%eax),%edi
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	53                   	push   %ebx
  80041c:	ff 30                	push   (%eax)
  80041e:	ff d6                	call   *%esi
			break;
  800420:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800423:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800426:	e9 88 03 00 00       	jmp    8007b3 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	8b 10                	mov    (%eax),%edx
  800433:	89 d0                	mov    %edx,%eax
  800435:	f7 d8                	neg    %eax
  800437:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043a:	83 f8 0f             	cmp    $0xf,%eax
  80043d:	7f 23                	jg     800462 <vprintfmt+0x15c>
  80043f:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  800446:	85 d2                	test   %edx,%edx
  800448:	74 18                	je     800462 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80044a:	52                   	push   %edx
  80044b:	68 2c 12 80 00       	push   $0x80122c
  800450:	53                   	push   %ebx
  800451:	56                   	push   %esi
  800452:	e8 92 fe ff ff       	call   8002e9 <printfmt>
  800457:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045d:	e9 51 03 00 00       	jmp    8007b3 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800462:	50                   	push   %eax
  800463:	68 23 12 80 00       	push   $0x801223
  800468:	53                   	push   %ebx
  800469:	56                   	push   %esi
  80046a:	e8 7a fe ff ff       	call   8002e9 <printfmt>
  80046f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800472:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800475:	e9 39 03 00 00       	jmp    8007b3 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80047a:	8b 45 14             	mov    0x14(%ebp),%eax
  80047d:	83 c0 04             	add    $0x4,%eax
  800480:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800488:	85 d2                	test   %edx,%edx
  80048a:	b8 1c 12 80 00       	mov    $0x80121c,%eax
  80048f:	0f 45 c2             	cmovne %edx,%eax
  800492:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800495:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800499:	7e 06                	jle    8004a1 <vprintfmt+0x19b>
  80049b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80049f:	75 0d                	jne    8004ae <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a4:	89 c7                	mov    %eax,%edi
  8004a6:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004ac:	eb 55                	jmp    800503 <vprintfmt+0x1fd>
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 e0             	push   -0x20(%ebp)
  8004b4:	ff 75 cc             	push   -0x34(%ebp)
  8004b7:	e8 f5 03 00 00       	call   8008b1 <strnlen>
  8004bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004bf:	29 c2                	sub    %eax,%edx
  8004c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d0:	eb 0f                	jmp    8004e1 <vprintfmt+0x1db>
					putch(padc, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	ff 75 d4             	push   -0x2c(%ebp)
  8004d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004db:	83 ef 01             	sub    $0x1,%edi
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 ff                	test   %edi,%edi
  8004e3:	7f ed                	jg     8004d2 <vprintfmt+0x1cc>
  8004e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e8:	85 d2                	test   %edx,%edx
  8004ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ef:	0f 49 c2             	cmovns %edx,%eax
  8004f2:	29 c2                	sub    %eax,%edx
  8004f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004f7:	eb a8                	jmp    8004a1 <vprintfmt+0x19b>
					putch(ch, putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	52                   	push   %edx
  8004fe:	ff d6                	call   *%esi
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800506:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800508:	83 c7 01             	add    $0x1,%edi
  80050b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050f:	0f be d0             	movsbl %al,%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 4b                	je     800561 <vprintfmt+0x25b>
  800516:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051a:	78 06                	js     800522 <vprintfmt+0x21c>
  80051c:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800520:	78 1e                	js     800540 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800522:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800526:	74 d1                	je     8004f9 <vprintfmt+0x1f3>
  800528:	0f be c0             	movsbl %al,%eax
  80052b:	83 e8 20             	sub    $0x20,%eax
  80052e:	83 f8 5e             	cmp    $0x5e,%eax
  800531:	76 c6                	jbe    8004f9 <vprintfmt+0x1f3>
					putch('?', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 3f                	push   $0x3f
  800539:	ff d6                	call   *%esi
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	eb c3                	jmp    800503 <vprintfmt+0x1fd>
  800540:	89 cf                	mov    %ecx,%edi
  800542:	eb 0e                	jmp    800552 <vprintfmt+0x24c>
				putch(' ', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	53                   	push   %ebx
  800548:	6a 20                	push   $0x20
  80054a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054c:	83 ef 01             	sub    $0x1,%edi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	85 ff                	test   %edi,%edi
  800554:	7f ee                	jg     800544 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800556:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800559:	89 45 14             	mov    %eax,0x14(%ebp)
  80055c:	e9 52 02 00 00       	jmp    8007b3 <vprintfmt+0x4ad>
  800561:	89 cf                	mov    %ecx,%edi
  800563:	eb ed                	jmp    800552 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	83 c0 04             	add    $0x4,%eax
  80056b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800573:	85 d2                	test   %edx,%edx
  800575:	b8 1c 12 80 00       	mov    $0x80121c,%eax
  80057a:	0f 45 c2             	cmovne %edx,%eax
  80057d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800580:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800584:	7e 06                	jle    80058c <vprintfmt+0x286>
  800586:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80058a:	75 0d                	jne    800599 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80058f:	89 c7                	mov    %eax,%edi
  800591:	03 45 d4             	add    -0x2c(%ebp),%eax
  800594:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800597:	eb 55                	jmp    8005ee <vprintfmt+0x2e8>
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	ff 75 e0             	push   -0x20(%ebp)
  80059f:	ff 75 cc             	push   -0x34(%ebp)
  8005a2:	e8 0a 03 00 00       	call   8008b1 <strnlen>
  8005a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005aa:	29 c2                	sub    %eax,%edx
  8005ac:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005b4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	eb 0f                	jmp    8005cc <vprintfmt+0x2c6>
					putch(padc, putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	ff 75 d4             	push   -0x2c(%ebp)
  8005c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	83 ef 01             	sub    $0x1,%edi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	85 ff                	test   %edi,%edi
  8005ce:	7f ed                	jg     8005bd <vprintfmt+0x2b7>
  8005d0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005d3:	85 d2                	test   %edx,%edx
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	0f 49 c2             	cmovns %edx,%eax
  8005dd:	29 c2                	sub    %eax,%edx
  8005df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e2:	eb a8                	jmp    80058c <vprintfmt+0x286>
					putch(ch, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	52                   	push   %edx
  8005e9:	ff d6                	call   *%esi
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005f3:	83 c7 01             	add    $0x1,%edi
  8005f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fa:	0f be d0             	movsbl %al,%edx
  8005fd:	3c 3a                	cmp    $0x3a,%al
  8005ff:	74 4b                	je     80064c <vprintfmt+0x346>
  800601:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800605:	78 06                	js     80060d <vprintfmt+0x307>
  800607:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80060b:	78 1e                	js     80062b <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80060d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800611:	74 d1                	je     8005e4 <vprintfmt+0x2de>
  800613:	0f be c0             	movsbl %al,%eax
  800616:	83 e8 20             	sub    $0x20,%eax
  800619:	83 f8 5e             	cmp    $0x5e,%eax
  80061c:	76 c6                	jbe    8005e4 <vprintfmt+0x2de>
					putch('?', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 3f                	push   $0x3f
  800624:	ff d6                	call   *%esi
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	eb c3                	jmp    8005ee <vprintfmt+0x2e8>
  80062b:	89 cf                	mov    %ecx,%edi
  80062d:	eb 0e                	jmp    80063d <vprintfmt+0x337>
				putch(' ', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	6a 20                	push   $0x20
  800635:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800637:	83 ef 01             	sub    $0x1,%edi
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	85 ff                	test   %edi,%edi
  80063f:	7f ee                	jg     80062f <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800641:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	e9 67 01 00 00       	jmp    8007b3 <vprintfmt+0x4ad>
  80064c:	89 cf                	mov    %ecx,%edi
  80064e:	eb ed                	jmp    80063d <vprintfmt+0x337>
	if (lflag >= 2)
  800650:	83 f9 01             	cmp    $0x1,%ecx
  800653:	7f 1b                	jg     800670 <vprintfmt+0x36a>
	else if (lflag)
  800655:	85 c9                	test   %ecx,%ecx
  800657:	74 63                	je     8006bc <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800661:	99                   	cltd   
  800662:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	eb 17                	jmp    800687 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 50 04             	mov    0x4(%eax),%edx
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80067b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800687:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80068d:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800692:	85 c9                	test   %ecx,%ecx
  800694:	0f 89 ff 00 00 00    	jns    800799 <vprintfmt+0x493>
				putch('-', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 2d                	push   $0x2d
  8006a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006a8:	f7 da                	neg    %edx
  8006aa:	83 d1 00             	adc    $0x0,%ecx
  8006ad:	f7 d9                	neg    %ecx
  8006af:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006b7:	e9 dd 00 00 00       	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c4:	99                   	cltd   
  8006c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d1:	eb b4                	jmp    800687 <vprintfmt+0x381>
	if (lflag >= 2)
  8006d3:	83 f9 01             	cmp    $0x1,%ecx
  8006d6:	7f 1e                	jg     8006f6 <vprintfmt+0x3f0>
	else if (lflag)
  8006d8:	85 c9                	test   %ecx,%ecx
  8006da:	74 32                	je     80070e <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ec:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006f1:	e9 a3 00 00 00       	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800709:	e9 8b 00 00 00       	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 10                	mov    (%eax),%edx
  800713:	b9 00 00 00 00       	mov    $0x0,%ecx
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071e:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800723:	eb 74                	jmp    800799 <vprintfmt+0x493>
	if (lflag >= 2)
  800725:	83 f9 01             	cmp    $0x1,%ecx
  800728:	7f 1b                	jg     800745 <vprintfmt+0x43f>
	else if (lflag)
  80072a:	85 c9                	test   %ecx,%ecx
  80072c:	74 2c                	je     80075a <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073e:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800743:	eb 54                	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	8b 48 04             	mov    0x4(%eax),%ecx
  80074d:	8d 40 08             	lea    0x8(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800753:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800758:	eb 3f                	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076a:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80076f:	eb 28                	jmp    800799 <vprintfmt+0x493>
			putch('0', putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	6a 30                	push   $0x30
  800777:	ff d6                	call   *%esi
			putch('x', putdat);
  800779:	83 c4 08             	add    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 78                	push   $0x78
  80077f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 10                	mov    (%eax),%edx
  800786:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80078b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800794:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800799:	83 ec 0c             	sub    $0xc,%esp
  80079c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007a0:	50                   	push   %eax
  8007a1:	ff 75 d4             	push   -0x2c(%ebp)
  8007a4:	57                   	push   %edi
  8007a5:	51                   	push   %ecx
  8007a6:	52                   	push   %edx
  8007a7:	89 da                	mov    %ebx,%edx
  8007a9:	89 f0                	mov    %esi,%eax
  8007ab:	e8 73 fa ff ff       	call   800223 <printnum>
			break;
  8007b0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b3:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b6:	e9 69 fb ff ff       	jmp    800324 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007bb:	83 f9 01             	cmp    $0x1,%ecx
  8007be:	7f 1b                	jg     8007db <vprintfmt+0x4d5>
	else if (lflag)
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	74 2c                	je     8007f0 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007d9:	eb be                	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007ee:	eb a9                	jmp    800799 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800805:	eb 92                	jmp    800799 <vprintfmt+0x493>
			putch(ch, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	6a 25                	push   $0x25
  80080d:	ff d6                	call   *%esi
			break;
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	eb 9f                	jmp    8007b3 <vprintfmt+0x4ad>
			putch('%', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	53                   	push   %ebx
  800818:	6a 25                	push   $0x25
  80081a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	89 f8                	mov    %edi,%eax
  800821:	eb 03                	jmp    800826 <vprintfmt+0x520>
  800823:	83 e8 01             	sub    $0x1,%eax
  800826:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082a:	75 f7                	jne    800823 <vprintfmt+0x51d>
  80082c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80082f:	eb 82                	jmp    8007b3 <vprintfmt+0x4ad>

00800831 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 18             	sub    $0x18,%esp
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800840:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800844:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800847:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084e:	85 c0                	test   %eax,%eax
  800850:	74 26                	je     800878 <vsnprintf+0x47>
  800852:	85 d2                	test   %edx,%edx
  800854:	7e 22                	jle    800878 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800856:	ff 75 14             	push   0x14(%ebp)
  800859:	ff 75 10             	push   0x10(%ebp)
  80085c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	68 cc 02 80 00       	push   $0x8002cc
  800865:	e8 9c fa ff ff       	call   800306 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800873:	83 c4 10             	add    $0x10,%esp
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    
		return -E_INVAL;
  800878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087d:	eb f7                	jmp    800876 <vsnprintf+0x45>

0080087f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800885:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800888:	50                   	push   %eax
  800889:	ff 75 10             	push   0x10(%ebp)
  80088c:	ff 75 0c             	push   0xc(%ebp)
  80088f:	ff 75 08             	push   0x8(%ebp)
  800892:	e8 9a ff ff ff       	call   800831 <vsnprintf>
	va_end(ap);

	return rc;
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	eb 03                	jmp    8008a9 <strlen+0x10>
		n++;
  8008a6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008a9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ad:	75 f7                	jne    8008a6 <strlen+0xd>
	return n;
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bf:	eb 03                	jmp    8008c4 <strnlen+0x13>
		n++;
  8008c1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c4:	39 d0                	cmp    %edx,%eax
  8008c6:	74 08                	je     8008d0 <strnlen+0x1f>
  8008c8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008cc:	75 f3                	jne    8008c1 <strnlen+0x10>
  8008ce:	89 c2                	mov    %eax,%edx
	return n;
}
  8008d0:	89 d0                	mov    %edx,%eax
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	53                   	push   %ebx
  8008d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008e7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	84 d2                	test   %dl,%dl
  8008ef:	75 f2                	jne    8008e3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f1:	89 c8                	mov    %ecx,%eax
  8008f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	53                   	push   %ebx
  8008fc:	83 ec 10             	sub    $0x10,%esp
  8008ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800902:	53                   	push   %ebx
  800903:	e8 91 ff ff ff       	call   800899 <strlen>
  800908:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80090b:	ff 75 0c             	push   0xc(%ebp)
  80090e:	01 d8                	add    %ebx,%eax
  800910:	50                   	push   %eax
  800911:	e8 be ff ff ff       	call   8008d4 <strcpy>
	return dst;
}
  800916:	89 d8                	mov    %ebx,%eax
  800918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	56                   	push   %esi
  800921:	53                   	push   %ebx
  800922:	8b 75 08             	mov    0x8(%ebp),%esi
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
  800928:	89 f3                	mov    %esi,%ebx
  80092a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	eb 0f                	jmp    800940 <strncpy+0x23>
		*dst++ = *src;
  800931:	83 c0 01             	add    $0x1,%eax
  800934:	0f b6 0a             	movzbl (%edx),%ecx
  800937:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093a:	80 f9 01             	cmp    $0x1,%cl
  80093d:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800940:	39 d8                	cmp    %ebx,%eax
  800942:	75 ed                	jne    800931 <strncpy+0x14>
	}
	return ret;
}
  800944:	89 f0                	mov    %esi,%eax
  800946:	5b                   	pop    %ebx
  800947:	5e                   	pop    %esi
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	56                   	push   %esi
  80094e:	53                   	push   %ebx
  80094f:	8b 75 08             	mov    0x8(%ebp),%esi
  800952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800955:	8b 55 10             	mov    0x10(%ebp),%edx
  800958:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80095a:	85 d2                	test   %edx,%edx
  80095c:	74 21                	je     80097f <strlcpy+0x35>
  80095e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800962:	89 f2                	mov    %esi,%edx
  800964:	eb 09                	jmp    80096f <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80096f:	39 c2                	cmp    %eax,%edx
  800971:	74 09                	je     80097c <strlcpy+0x32>
  800973:	0f b6 19             	movzbl (%ecx),%ebx
  800976:	84 db                	test   %bl,%bl
  800978:	75 ec                	jne    800966 <strlcpy+0x1c>
  80097a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80097c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097f:	29 f0                	sub    %esi,%eax
}
  800981:	5b                   	pop    %ebx
  800982:	5e                   	pop    %esi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098e:	eb 06                	jmp    800996 <strcmp+0x11>
		p++, q++;
  800990:	83 c1 01             	add    $0x1,%ecx
  800993:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800996:	0f b6 01             	movzbl (%ecx),%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 04                	je     8009a1 <strcmp+0x1c>
  80099d:	3a 02                	cmp    (%edx),%al
  80099f:	74 ef                	je     800990 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	0f b6 12             	movzbl (%edx),%edx
  8009a7:	29 d0                	sub    %edx,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	89 c3                	mov    %eax,%ebx
  8009b7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ba:	eb 06                	jmp    8009c2 <strncmp+0x17>
		n--, p++, q++;
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009c2:	39 d8                	cmp    %ebx,%eax
  8009c4:	74 18                	je     8009de <strncmp+0x33>
  8009c6:	0f b6 08             	movzbl (%eax),%ecx
  8009c9:	84 c9                	test   %cl,%cl
  8009cb:	74 04                	je     8009d1 <strncmp+0x26>
  8009cd:	3a 0a                	cmp    (%edx),%cl
  8009cf:	74 eb                	je     8009bc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d1:	0f b6 00             	movzbl (%eax),%eax
  8009d4:	0f b6 12             	movzbl (%edx),%edx
  8009d7:	29 d0                	sub    %edx,%eax
}
  8009d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    
		return 0;
  8009de:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e3:	eb f4                	jmp    8009d9 <strncmp+0x2e>

008009e5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ef:	eb 03                	jmp    8009f4 <strchr+0xf>
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	0f b6 10             	movzbl (%eax),%edx
  8009f7:	84 d2                	test   %dl,%dl
  8009f9:	74 06                	je     800a01 <strchr+0x1c>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	75 f2                	jne    8009f1 <strchr+0xc>
  8009ff:	eb 05                	jmp    800a06 <strchr+0x21>
			return (char *) s;
	return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a12:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a15:	38 ca                	cmp    %cl,%dl
  800a17:	74 09                	je     800a22 <strfind+0x1a>
  800a19:	84 d2                	test   %dl,%dl
  800a1b:	74 05                	je     800a22 <strfind+0x1a>
	for (; *s; s++)
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	eb f0                	jmp    800a12 <strfind+0xa>
			break;
	return (char *) s;
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	57                   	push   %edi
  800a28:	56                   	push   %esi
  800a29:	53                   	push   %ebx
  800a2a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a30:	85 c9                	test   %ecx,%ecx
  800a32:	74 2f                	je     800a63 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a34:	89 f8                	mov    %edi,%eax
  800a36:	09 c8                	or     %ecx,%eax
  800a38:	a8 03                	test   $0x3,%al
  800a3a:	75 21                	jne    800a5d <memset+0x39>
		c &= 0xFF;
  800a3c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a40:	89 d0                	mov    %edx,%eax
  800a42:	c1 e0 08             	shl    $0x8,%eax
  800a45:	89 d3                	mov    %edx,%ebx
  800a47:	c1 e3 18             	shl    $0x18,%ebx
  800a4a:	89 d6                	mov    %edx,%esi
  800a4c:	c1 e6 10             	shl    $0x10,%esi
  800a4f:	09 f3                	or     %esi,%ebx
  800a51:	09 da                	or     %ebx,%edx
  800a53:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a55:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a58:	fc                   	cld    
  800a59:	f3 ab                	rep stos %eax,%es:(%edi)
  800a5b:	eb 06                	jmp    800a63 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	fc                   	cld    
  800a61:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a63:	89 f8                	mov    %edi,%eax
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	57                   	push   %edi
  800a6e:	56                   	push   %esi
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a78:	39 c6                	cmp    %eax,%esi
  800a7a:	73 32                	jae    800aae <memmove+0x44>
  800a7c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a7f:	39 c2                	cmp    %eax,%edx
  800a81:	76 2b                	jbe    800aae <memmove+0x44>
		s += n;
		d += n;
  800a83:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a86:	89 d6                	mov    %edx,%esi
  800a88:	09 fe                	or     %edi,%esi
  800a8a:	09 ce                	or     %ecx,%esi
  800a8c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a92:	75 0e                	jne    800aa2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a94:	83 ef 04             	sub    $0x4,%edi
  800a97:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a9d:	fd                   	std    
  800a9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa0:	eb 09                	jmp    800aab <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa2:	83 ef 01             	sub    $0x1,%edi
  800aa5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa8:	fd                   	std    
  800aa9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aab:	fc                   	cld    
  800aac:	eb 1a                	jmp    800ac8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aae:	89 f2                	mov    %esi,%edx
  800ab0:	09 c2                	or     %eax,%edx
  800ab2:	09 ca                	or     %ecx,%edx
  800ab4:	f6 c2 03             	test   $0x3,%dl
  800ab7:	75 0a                	jne    800ac3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	fc                   	cld    
  800abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac1:	eb 05                	jmp    800ac8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad2:	ff 75 10             	push   0x10(%ebp)
  800ad5:	ff 75 0c             	push   0xc(%ebp)
  800ad8:	ff 75 08             	push   0x8(%ebp)
  800adb:	e8 8a ff ff ff       	call   800a6a <memmove>
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	89 c6                	mov    %eax,%esi
  800aef:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af2:	eb 06                	jmp    800afa <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af4:	83 c0 01             	add    $0x1,%eax
  800af7:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800afa:	39 f0                	cmp    %esi,%eax
  800afc:	74 14                	je     800b12 <memcmp+0x30>
		if (*s1 != *s2)
  800afe:	0f b6 08             	movzbl (%eax),%ecx
  800b01:	0f b6 1a             	movzbl (%edx),%ebx
  800b04:	38 d9                	cmp    %bl,%cl
  800b06:	74 ec                	je     800af4 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b08:	0f b6 c1             	movzbl %cl,%eax
  800b0b:	0f b6 db             	movzbl %bl,%ebx
  800b0e:	29 d8                	sub    %ebx,%eax
  800b10:	eb 05                	jmp    800b17 <memcmp+0x35>
	}

	return 0;
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b24:	89 c2                	mov    %eax,%edx
  800b26:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b29:	eb 03                	jmp    800b2e <memfind+0x13>
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	39 d0                	cmp    %edx,%eax
  800b30:	73 04                	jae    800b36 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b32:	38 08                	cmp    %cl,(%eax)
  800b34:	75 f5                	jne    800b2b <memfind+0x10>
			break;
	return (void *) s;
}
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b44:	eb 03                	jmp    800b49 <strtol+0x11>
		s++;
  800b46:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b49:	0f b6 02             	movzbl (%edx),%eax
  800b4c:	3c 20                	cmp    $0x20,%al
  800b4e:	74 f6                	je     800b46 <strtol+0xe>
  800b50:	3c 09                	cmp    $0x9,%al
  800b52:	74 f2                	je     800b46 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b54:	3c 2b                	cmp    $0x2b,%al
  800b56:	74 2a                	je     800b82 <strtol+0x4a>
	int neg = 0;
  800b58:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b5d:	3c 2d                	cmp    $0x2d,%al
  800b5f:	74 2b                	je     800b8c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b61:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b67:	75 0f                	jne    800b78 <strtol+0x40>
  800b69:	80 3a 30             	cmpb   $0x30,(%edx)
  800b6c:	74 28                	je     800b96 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b6e:	85 db                	test   %ebx,%ebx
  800b70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b75:	0f 44 d8             	cmove  %eax,%ebx
  800b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b80:	eb 46                	jmp    800bc8 <strtol+0x90>
		s++;
  800b82:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b85:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8a:	eb d5                	jmp    800b61 <strtol+0x29>
		s++, neg = 1;
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b94:	eb cb                	jmp    800b61 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b96:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b9a:	74 0e                	je     800baa <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	75 d8                	jne    800b78 <strtol+0x40>
		s++, base = 8;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba8:	eb ce                	jmp    800b78 <strtol+0x40>
		s += 2, base = 16;
  800baa:	83 c2 02             	add    $0x2,%edx
  800bad:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb2:	eb c4                	jmp    800b78 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bb4:	0f be c0             	movsbl %al,%eax
  800bb7:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bba:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbd:	7d 3a                	jge    800bf9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bbf:	83 c2 01             	add    $0x1,%edx
  800bc2:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bc6:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bc8:	0f b6 02             	movzbl (%edx),%eax
  800bcb:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bce:	89 f3                	mov    %esi,%ebx
  800bd0:	80 fb 09             	cmp    $0x9,%bl
  800bd3:	76 df                	jbe    800bb4 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bd5:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bd8:	89 f3                	mov    %esi,%ebx
  800bda:	80 fb 19             	cmp    $0x19,%bl
  800bdd:	77 08                	ja     800be7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdf:	0f be c0             	movsbl %al,%eax
  800be2:	83 e8 57             	sub    $0x57,%eax
  800be5:	eb d3                	jmp    800bba <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800be7:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bea:	89 f3                	mov    %esi,%ebx
  800bec:	80 fb 19             	cmp    $0x19,%bl
  800bef:	77 08                	ja     800bf9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf1:	0f be c0             	movsbl %al,%eax
  800bf4:	83 e8 37             	sub    $0x37,%eax
  800bf7:	eb c1                	jmp    800bba <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfd:	74 05                	je     800c04 <strtol+0xcc>
		*endptr = (char *) s;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c04:	89 c8                	mov    %ecx,%eax
  800c06:	f7 d8                	neg    %eax
  800c08:	85 ff                	test   %edi,%edi
  800c0a:	0f 45 c8             	cmovne %eax,%ecx
}
  800c0d:	89 c8                	mov    %ecx,%eax
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c25:	89 c3                	mov    %eax,%ebx
  800c27:	89 c7                	mov    %eax,%edi
  800c29:	89 c6                	mov    %eax,%esi
  800c2b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c38:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c42:	89 d1                	mov    %edx,%ecx
  800c44:	89 d3                	mov    %edx,%ebx
  800c46:	89 d7                	mov    %edx,%edi
  800c48:	89 d6                	mov    %edx,%esi
  800c4a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4c:	5b                   	pop    %ebx
  800c4d:	5e                   	pop    %esi
  800c4e:	5f                   	pop    %edi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	57                   	push   %edi
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
  800c57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c62:	b8 03 00 00 00       	mov    $0x3,%eax
  800c67:	89 cb                	mov    %ecx,%ebx
  800c69:	89 cf                	mov    %ecx,%edi
  800c6b:	89 ce                	mov    %ecx,%esi
  800c6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	7f 08                	jg     800c7b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7b:	83 ec 0c             	sub    $0xc,%esp
  800c7e:	50                   	push   %eax
  800c7f:	6a 03                	push   $0x3
  800c81:	68 1f 15 80 00       	push   $0x80151f
  800c86:	6a 23                	push   $0x23
  800c88:	68 3c 15 80 00       	push   $0x80153c
  800c8d:	e8 a2 f4 ff ff       	call   800134 <_panic>

00800c92 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c98:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9d:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca2:	89 d1                	mov    %edx,%ecx
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	89 d7                	mov    %edx,%edi
  800ca8:	89 d6                	mov    %edx,%esi
  800caa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <sys_yield>:

void
sys_yield(void)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc1:	89 d1                	mov    %edx,%ecx
  800cc3:	89 d3                	mov    %edx,%ebx
  800cc5:	89 d7                	mov    %edx,%edi
  800cc7:	89 d6                	mov    %edx,%esi
  800cc9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd9:	be 00 00 00 00       	mov    $0x0,%esi
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cec:	89 f7                	mov    %esi,%edi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 04                	push   $0x4
  800d02:	68 1f 15 80 00       	push   $0x80151f
  800d07:	6a 23                	push   $0x23
  800d09:	68 3c 15 80 00       	push   $0x80153c
  800d0e:	e8 21 f4 ff ff       	call   800134 <_panic>

00800d13 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	b8 05 00 00 00       	mov    $0x5,%eax
  800d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 05                	push   $0x5
  800d44:	68 1f 15 80 00       	push   $0x80151f
  800d49:	6a 23                	push   $0x23
  800d4b:	68 3c 15 80 00       	push   $0x80153c
  800d50:	e8 df f3 ff ff       	call   800134 <_panic>

00800d55 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6e:	89 df                	mov    %ebx,%edi
  800d70:	89 de                	mov    %ebx,%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 06                	push   $0x6
  800d86:	68 1f 15 80 00       	push   $0x80151f
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 3c 15 80 00       	push   $0x80153c
  800d92:	e8 9d f3 ff ff       	call   800134 <_panic>

00800d97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 08 00 00 00       	mov    $0x8,%eax
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	89 de                	mov    %ebx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 08                	push   $0x8
  800dc8:	68 1f 15 80 00       	push   $0x80151f
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 3c 15 80 00       	push   $0x80153c
  800dd4:	e8 5b f3 ff ff       	call   800134 <_panic>

00800dd9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	b8 09 00 00 00       	mov    $0x9,%eax
  800df2:	89 df                	mov    %ebx,%edi
  800df4:	89 de                	mov    %ebx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 09                	push   $0x9
  800e0a:	68 1f 15 80 00       	push   $0x80151f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 3c 15 80 00       	push   $0x80153c
  800e16:	e8 19 f3 ff ff       	call   800134 <_panic>

00800e1b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	50                   	push   %eax
  800e4a:	6a 0a                	push   $0xa
  800e4c:	68 1f 15 80 00       	push   $0x80151f
  800e51:	6a 23                	push   $0x23
  800e53:	68 3c 15 80 00       	push   $0x80153c
  800e58:	e8 d7 f2 ff ff       	call   800134 <_panic>

00800e5d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e6e:	be 00 00 00 00       	mov    $0x0,%esi
  800e73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e76:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e79:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e89:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e96:	89 cb                	mov    %ecx,%ebx
  800e98:	89 cf                	mov    %ecx,%edi
  800e9a:	89 ce                	mov    %ecx,%esi
  800e9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 0d                	push   $0xd
  800eb0:	68 1f 15 80 00       	push   $0x80151f
  800eb5:	6a 23                	push   $0x23
  800eb7:	68 3c 15 80 00       	push   $0x80153c
  800ebc:	e8 73 f2 ff ff       	call   800134 <_panic>
  800ec1:	66 90                	xchg   %ax,%ax
  800ec3:	66 90                	xchg   %ax,%ax
  800ec5:	66 90                	xchg   %ax,%ax
  800ec7:	66 90                	xchg   %ax,%ax
  800ec9:	66 90                	xchg   %ax,%ax
  800ecb:	66 90                	xchg   %ax,%ax
  800ecd:	66 90                	xchg   %ax,%ax
  800ecf:	90                   	nop

00800ed0 <__udivdi3>:
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 1c             	sub    $0x1c,%esp
  800edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800edf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ee3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 19                	jne    800f08 <__udivdi3+0x38>
  800eef:	39 f3                	cmp    %esi,%ebx
  800ef1:	76 4d                	jbe    800f40 <__udivdi3+0x70>
  800ef3:	31 ff                	xor    %edi,%edi
  800ef5:	89 e8                	mov    %ebp,%eax
  800ef7:	89 f2                	mov    %esi,%edx
  800ef9:	f7 f3                	div    %ebx
  800efb:	89 fa                	mov    %edi,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	39 f0                	cmp    %esi,%eax
  800f0a:	76 14                	jbe    800f20 <__udivdi3+0x50>
  800f0c:	31 ff                	xor    %edi,%edi
  800f0e:	31 c0                	xor    %eax,%eax
  800f10:	89 fa                	mov    %edi,%edx
  800f12:	83 c4 1c             	add    $0x1c,%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
  800f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f20:	0f bd f8             	bsr    %eax,%edi
  800f23:	83 f7 1f             	xor    $0x1f,%edi
  800f26:	75 48                	jne    800f70 <__udivdi3+0xa0>
  800f28:	39 f0                	cmp    %esi,%eax
  800f2a:	72 06                	jb     800f32 <__udivdi3+0x62>
  800f2c:	31 c0                	xor    %eax,%eax
  800f2e:	39 eb                	cmp    %ebp,%ebx
  800f30:	77 de                	ja     800f10 <__udivdi3+0x40>
  800f32:	b8 01 00 00 00       	mov    $0x1,%eax
  800f37:	eb d7                	jmp    800f10 <__udivdi3+0x40>
  800f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f40:	89 d9                	mov    %ebx,%ecx
  800f42:	85 db                	test   %ebx,%ebx
  800f44:	75 0b                	jne    800f51 <__udivdi3+0x81>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f3                	div    %ebx
  800f4f:	89 c1                	mov    %eax,%ecx
  800f51:	31 d2                	xor    %edx,%edx
  800f53:	89 f0                	mov    %esi,%eax
  800f55:	f7 f1                	div    %ecx
  800f57:	89 c6                	mov    %eax,%esi
  800f59:	89 e8                	mov    %ebp,%eax
  800f5b:	89 f7                	mov    %esi,%edi
  800f5d:	f7 f1                	div    %ecx
  800f5f:	89 fa                	mov    %edi,%edx
  800f61:	83 c4 1c             	add    $0x1c,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
  800f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	ba 20 00 00 00       	mov    $0x20,%edx
  800f77:	29 fa                	sub    %edi,%edx
  800f79:	d3 e0                	shl    %cl,%eax
  800f7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f7f:	89 d1                	mov    %edx,%ecx
  800f81:	89 d8                	mov    %ebx,%eax
  800f83:	d3 e8                	shr    %cl,%eax
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 c1                	or     %eax,%ecx
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 d1                	mov    %edx,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 f3                	or     %esi,%ebx
  800fa9:	89 c6                	mov    %eax,%esi
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 d8                	mov    %ebx,%eax
  800faf:	f7 74 24 08          	divl   0x8(%esp)
  800fb3:	89 d6                	mov    %edx,%esi
  800fb5:	89 c3                	mov    %eax,%ebx
  800fb7:	f7 64 24 0c          	mull   0xc(%esp)
  800fbb:	39 d6                	cmp    %edx,%esi
  800fbd:	72 19                	jb     800fd8 <__udivdi3+0x108>
  800fbf:	89 f9                	mov    %edi,%ecx
  800fc1:	d3 e5                	shl    %cl,%ebp
  800fc3:	39 c5                	cmp    %eax,%ebp
  800fc5:	73 04                	jae    800fcb <__udivdi3+0xfb>
  800fc7:	39 d6                	cmp    %edx,%esi
  800fc9:	74 0d                	je     800fd8 <__udivdi3+0x108>
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	31 ff                	xor    %edi,%edi
  800fcf:	e9 3c ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fdb:	31 ff                	xor    %edi,%edi
  800fdd:	e9 2e ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fe2:	66 90                	xchg   %ax,%ax
  800fe4:	66 90                	xchg   %ax,%ax
  800fe6:	66 90                	xchg   %ax,%ax
  800fe8:	66 90                	xchg   %ax,%ax
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <__umoddi3>:
  800ff0:	f3 0f 1e fb          	endbr32 
  800ff4:	55                   	push   %ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 1c             	sub    $0x1c,%esp
  800ffb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801003:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801007:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	89 da                	mov    %ebx,%edx
  80100f:	85 ff                	test   %edi,%edi
  801011:	75 15                	jne    801028 <__umoddi3+0x38>
  801013:	39 dd                	cmp    %ebx,%ebp
  801015:	76 39                	jbe    801050 <__umoddi3+0x60>
  801017:	f7 f5                	div    %ebp
  801019:	89 d0                	mov    %edx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	83 c4 1c             	add    $0x1c,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
  801025:	8d 76 00             	lea    0x0(%esi),%esi
  801028:	39 df                	cmp    %ebx,%edi
  80102a:	77 f1                	ja     80101d <__umoddi3+0x2d>
  80102c:	0f bd cf             	bsr    %edi,%ecx
  80102f:	83 f1 1f             	xor    $0x1f,%ecx
  801032:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801036:	75 40                	jne    801078 <__umoddi3+0x88>
  801038:	39 df                	cmp    %ebx,%edi
  80103a:	72 04                	jb     801040 <__umoddi3+0x50>
  80103c:	39 f5                	cmp    %esi,%ebp
  80103e:	77 dd                	ja     80101d <__umoddi3+0x2d>
  801040:	89 da                	mov    %ebx,%edx
  801042:	89 f0                	mov    %esi,%eax
  801044:	29 e8                	sub    %ebp,%eax
  801046:	19 fa                	sbb    %edi,%edx
  801048:	eb d3                	jmp    80101d <__umoddi3+0x2d>
  80104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801050:	89 e9                	mov    %ebp,%ecx
  801052:	85 ed                	test   %ebp,%ebp
  801054:	75 0b                	jne    801061 <__umoddi3+0x71>
  801056:	b8 01 00 00 00       	mov    $0x1,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	f7 f5                	div    %ebp
  80105f:	89 c1                	mov    %eax,%ecx
  801061:	89 d8                	mov    %ebx,%eax
  801063:	31 d2                	xor    %edx,%edx
  801065:	f7 f1                	div    %ecx
  801067:	89 f0                	mov    %esi,%eax
  801069:	f7 f1                	div    %ecx
  80106b:	89 d0                	mov    %edx,%eax
  80106d:	31 d2                	xor    %edx,%edx
  80106f:	eb ac                	jmp    80101d <__umoddi3+0x2d>
  801071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801078:	8b 44 24 04          	mov    0x4(%esp),%eax
  80107c:	ba 20 00 00 00       	mov    $0x20,%edx
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 c1                	mov    %eax,%ecx
  801085:	89 e8                	mov    %ebp,%eax
  801087:	d3 e7                	shl    %cl,%edi
  801089:	89 d1                	mov    %edx,%ecx
  80108b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80108f:	d3 e8                	shr    %cl,%eax
  801091:	89 c1                	mov    %eax,%ecx
  801093:	8b 44 24 04          	mov    0x4(%esp),%eax
  801097:	09 f9                	or     %edi,%ecx
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80109f:	89 c1                	mov    %eax,%ecx
  8010a1:	d3 e5                	shl    %cl,%ebp
  8010a3:	89 d1                	mov    %edx,%ecx
  8010a5:	d3 ef                	shr    %cl,%edi
  8010a7:	89 c1                	mov    %eax,%ecx
  8010a9:	89 f0                	mov    %esi,%eax
  8010ab:	d3 e3                	shl    %cl,%ebx
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	89 fa                	mov    %edi,%edx
  8010b1:	d3 e8                	shr    %cl,%eax
  8010b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010b8:	09 d8                	or     %ebx,%eax
  8010ba:	f7 74 24 08          	divl   0x8(%esp)
  8010be:	89 d3                	mov    %edx,%ebx
  8010c0:	d3 e6                	shl    %cl,%esi
  8010c2:	f7 e5                	mul    %ebp
  8010c4:	89 c7                	mov    %eax,%edi
  8010c6:	89 d1                	mov    %edx,%ecx
  8010c8:	39 d3                	cmp    %edx,%ebx
  8010ca:	72 06                	jb     8010d2 <__umoddi3+0xe2>
  8010cc:	75 0e                	jne    8010dc <__umoddi3+0xec>
  8010ce:	39 c6                	cmp    %eax,%esi
  8010d0:	73 0a                	jae    8010dc <__umoddi3+0xec>
  8010d2:	29 e8                	sub    %ebp,%eax
  8010d4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010d8:	89 d1                	mov    %edx,%ecx
  8010da:	89 c7                	mov    %eax,%edi
  8010dc:	89 f5                	mov    %esi,%ebp
  8010de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010e2:	29 fd                	sub    %edi,%ebp
  8010e4:	19 cb                	sbb    %ecx,%ebx
  8010e6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	d3 e0                	shl    %cl,%eax
  8010ef:	89 f1                	mov    %esi,%ecx
  8010f1:	d3 ed                	shr    %cl,%ebp
  8010f3:	d3 eb                	shr    %cl,%ebx
  8010f5:	09 e8                	or     %ebp,%eax
  8010f7:	89 da                	mov    %ebx,%edx
  8010f9:	83 c4 1c             	add    $0x1c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
