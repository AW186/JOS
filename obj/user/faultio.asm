
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 ae 10 80 00       	push   $0x8010ae
  800053:	e8 04 01 00 00       	call   80015c <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 a0 10 80 00       	push   $0x8010a0
  800065:	e8 f2 00 00 00       	call   80015c <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 60 0b 00 00       	call   800bdf <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000bb:	6a 00                	push   $0x0
  8000bd:	e8 dc 0a 00 00       	call   800b9e <sys_env_destroy>
}
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	c9                   	leave  
  8000c6:	c3                   	ret    

008000c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	53                   	push   %ebx
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d1:	8b 13                	mov    (%ebx),%edx
  8000d3:	8d 42 01             	lea    0x1(%edx),%eax
  8000d6:	89 03                	mov    %eax,(%ebx)
  8000d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e4:	74 09                	je     8000ef <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 ff 00 00 00       	push   $0xff
  8000f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fa:	50                   	push   %eax
  8000fb:	e8 61 0a 00 00       	call   800b61 <sys_cputs>
		b->idx = 0;
  800100:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	eb db                	jmp    8000e6 <putch+0x1f>

0080010b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011b:	00 00 00 
	b.cnt = 0;
  80011e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800125:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800128:	ff 75 0c             	push   0xc(%ebp)
  80012b:	ff 75 08             	push   0x8(%ebp)
  80012e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800134:	50                   	push   %eax
  800135:	68 c7 00 80 00       	push   $0x8000c7
  80013a:	e8 14 01 00 00       	call   800253 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013f:	83 c4 08             	add    $0x8,%esp
  800142:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800148:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014e:	50                   	push   %eax
  80014f:	e8 0d 0a 00 00       	call   800b61 <sys_cputs>

	return b.cnt;
}
  800154:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800162:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800165:	50                   	push   %eax
  800166:	ff 75 08             	push   0x8(%ebp)
  800169:	e8 9d ff ff ff       	call   80010b <vcprintf>
	va_end(ap);

	return cnt;
}
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 1c             	sub    $0x1c,%esp
  800179:	89 c7                	mov    %eax,%edi
  80017b:	89 d6                	mov    %edx,%esi
  80017d:	8b 45 08             	mov    0x8(%ebp),%eax
  800180:	8b 55 0c             	mov    0xc(%ebp),%edx
  800183:	89 d1                	mov    %edx,%ecx
  800185:	89 c2                	mov    %eax,%edx
  800187:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80018d:	8b 45 10             	mov    0x10(%ebp),%eax
  800190:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800193:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800196:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80019d:	39 c2                	cmp    %eax,%edx
  80019f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001a2:	72 3e                	jb     8001e2 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 18             	push   0x18(%ebp)
  8001aa:	83 eb 01             	sub    $0x1,%ebx
  8001ad:	53                   	push   %ebx
  8001ae:	50                   	push   %eax
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	ff 75 e4             	push   -0x1c(%ebp)
  8001b5:	ff 75 e0             	push   -0x20(%ebp)
  8001b8:	ff 75 dc             	push   -0x24(%ebp)
  8001bb:	ff 75 d8             	push   -0x28(%ebp)
  8001be:	e8 9d 0c 00 00       	call   800e60 <__udivdi3>
  8001c3:	83 c4 18             	add    $0x18,%esp
  8001c6:	52                   	push   %edx
  8001c7:	50                   	push   %eax
  8001c8:	89 f2                	mov    %esi,%edx
  8001ca:	89 f8                	mov    %edi,%eax
  8001cc:	e8 9f ff ff ff       	call   800170 <printnum>
  8001d1:	83 c4 20             	add    $0x20,%esp
  8001d4:	eb 13                	jmp    8001e9 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	56                   	push   %esi
  8001da:	ff 75 18             	push   0x18(%ebp)
  8001dd:	ff d7                	call   *%edi
  8001df:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e2:	83 eb 01             	sub    $0x1,%ebx
  8001e5:	85 db                	test   %ebx,%ebx
  8001e7:	7f ed                	jg     8001d6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	56                   	push   %esi
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	ff 75 e4             	push   -0x1c(%ebp)
  8001f3:	ff 75 e0             	push   -0x20(%ebp)
  8001f6:	ff 75 dc             	push   -0x24(%ebp)
  8001f9:	ff 75 d8             	push   -0x28(%ebp)
  8001fc:	e8 7f 0d 00 00       	call   800f80 <__umoddi3>
  800201:	83 c4 14             	add    $0x14,%esp
  800204:	0f be 80 d2 10 80 00 	movsbl 0x8010d2(%eax),%eax
  80020b:	50                   	push   %eax
  80020c:	ff d7                	call   *%edi
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800223:	8b 10                	mov    (%eax),%edx
  800225:	3b 50 04             	cmp    0x4(%eax),%edx
  800228:	73 0a                	jae    800234 <sprintputch+0x1b>
		*b->buf++ = ch;
  80022a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022d:	89 08                	mov    %ecx,(%eax)
  80022f:	8b 45 08             	mov    0x8(%ebp),%eax
  800232:	88 02                	mov    %al,(%edx)
}
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <printfmt>:
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023f:	50                   	push   %eax
  800240:	ff 75 10             	push   0x10(%ebp)
  800243:	ff 75 0c             	push   0xc(%ebp)
  800246:	ff 75 08             	push   0x8(%ebp)
  800249:	e8 05 00 00 00       	call   800253 <vprintfmt>
}
  80024e:	83 c4 10             	add    $0x10,%esp
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <vprintfmt>:
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	57                   	push   %edi
  800257:	56                   	push   %esi
  800258:	53                   	push   %ebx
  800259:	83 ec 3c             	sub    $0x3c,%esp
  80025c:	8b 75 08             	mov    0x8(%ebp),%esi
  80025f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800262:	8b 7d 10             	mov    0x10(%ebp),%edi
  800265:	eb 0a                	jmp    800271 <vprintfmt+0x1e>
			putch(ch, putdat);
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	53                   	push   %ebx
  80026b:	50                   	push   %eax
  80026c:	ff d6                	call   *%esi
  80026e:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800271:	83 c7 01             	add    $0x1,%edi
  800274:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800278:	83 f8 25             	cmp    $0x25,%eax
  80027b:	74 0c                	je     800289 <vprintfmt+0x36>
			if (ch == '\0')
  80027d:	85 c0                	test   %eax,%eax
  80027f:	75 e6                	jne    800267 <vprintfmt+0x14>
}
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
		padc = ' ';
  800289:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80028d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800294:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80029b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a7:	8d 47 01             	lea    0x1(%edi),%eax
  8002aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ad:	0f b6 17             	movzbl (%edi),%edx
  8002b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b3:	3c 55                	cmp    $0x55,%al
  8002b5:	0f 87 a6 04 00 00    	ja     800761 <vprintfmt+0x50e>
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  8002c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002c8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002cc:	eb d9                	jmp    8002a7 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002ce:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002d1:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d5:	eb d0                	jmp    8002a7 <vprintfmt+0x54>
  8002d7:	0f b6 d2             	movzbl %dl,%edx
  8002da:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8002e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ef:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f2:	83 f9 09             	cmp    $0x9,%ecx
  8002f5:	77 55                	ja     80034c <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fa:	eb e9                	jmp    8002e5 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800304:	8b 45 14             	mov    0x14(%ebp),%eax
  800307:	8d 40 04             	lea    0x4(%eax),%eax
  80030a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800310:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800314:	79 91                	jns    8002a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800316:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800319:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80031c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800323:	eb 82                	jmp    8002a7 <vprintfmt+0x54>
  800325:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800328:	85 d2                	test   %edx,%edx
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	0f 49 c2             	cmovns %edx,%eax
  800332:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800338:	e9 6a ff ff ff       	jmp    8002a7 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800340:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800347:	e9 5b ff ff ff       	jmp    8002a7 <vprintfmt+0x54>
  80034c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80034f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800352:	eb bc                	jmp    800310 <vprintfmt+0xbd>
			lflag++;
  800354:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80035a:	e9 48 ff ff ff       	jmp    8002a7 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 78 04             	lea    0x4(%eax),%edi
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	53                   	push   %ebx
  800369:	ff 30                	push   (%eax)
  80036b:	ff d6                	call   *%esi
			break;
  80036d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800370:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800373:	e9 88 03 00 00       	jmp    800700 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 78 04             	lea    0x4(%eax),%edi
  80037e:	8b 10                	mov    (%eax),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	f7 d8                	neg    %eax
  800384:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800387:	83 f8 0f             	cmp    $0xf,%eax
  80038a:	7f 23                	jg     8003af <vprintfmt+0x15c>
  80038c:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800393:	85 d2                	test   %edx,%edx
  800395:	74 18                	je     8003af <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800397:	52                   	push   %edx
  800398:	68 f3 10 80 00       	push   $0x8010f3
  80039d:	53                   	push   %ebx
  80039e:	56                   	push   %esi
  80039f:	e8 92 fe ff ff       	call   800236 <printfmt>
  8003a4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003aa:	e9 51 03 00 00       	jmp    800700 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003af:	50                   	push   %eax
  8003b0:	68 ea 10 80 00       	push   $0x8010ea
  8003b5:	53                   	push   %ebx
  8003b6:	56                   	push   %esi
  8003b7:	e8 7a fe ff ff       	call   800236 <printfmt>
  8003bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c2:	e9 39 03 00 00       	jmp    800700 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	83 c0 04             	add    $0x4,%eax
  8003cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	b8 e3 10 80 00       	mov    $0x8010e3,%eax
  8003dc:	0f 45 c2             	cmovne %edx,%eax
  8003df:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003e6:	7e 06                	jle    8003ee <vprintfmt+0x19b>
  8003e8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003ec:	75 0d                	jne    8003fb <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003f1:	89 c7                	mov    %eax,%edi
  8003f3:	03 45 d4             	add    -0x2c(%ebp),%eax
  8003f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003f9:	eb 55                	jmp    800450 <vprintfmt+0x1fd>
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 e0             	push   -0x20(%ebp)
  800401:	ff 75 cc             	push   -0x34(%ebp)
  800404:	e8 f5 03 00 00       	call   8007fe <strnlen>
  800409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80040c:	29 c2                	sub    %eax,%edx
  80040e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800411:	83 c4 10             	add    $0x10,%esp
  800414:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800416:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80041a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80041d:	eb 0f                	jmp    80042e <vprintfmt+0x1db>
					putch(padc, putdat);
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 75 d4             	push   -0x2c(%ebp)
  800426:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800428:	83 ef 01             	sub    $0x1,%edi
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	85 ff                	test   %edi,%edi
  800430:	7f ed                	jg     80041f <vprintfmt+0x1cc>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	85 d2                	test   %edx,%edx
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  80043c:	0f 49 c2             	cmovns %edx,%eax
  80043f:	29 c2                	sub    %eax,%edx
  800441:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800444:	eb a8                	jmp    8003ee <vprintfmt+0x19b>
					putch(ch, putdat);
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	53                   	push   %ebx
  80044a:	52                   	push   %edx
  80044b:	ff d6                	call   *%esi
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800453:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800455:	83 c7 01             	add    $0x1,%edi
  800458:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80045c:	0f be d0             	movsbl %al,%edx
  80045f:	85 d2                	test   %edx,%edx
  800461:	74 4b                	je     8004ae <vprintfmt+0x25b>
  800463:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800467:	78 06                	js     80046f <vprintfmt+0x21c>
  800469:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80046d:	78 1e                	js     80048d <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80046f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800473:	74 d1                	je     800446 <vprintfmt+0x1f3>
  800475:	0f be c0             	movsbl %al,%eax
  800478:	83 e8 20             	sub    $0x20,%eax
  80047b:	83 f8 5e             	cmp    $0x5e,%eax
  80047e:	76 c6                	jbe    800446 <vprintfmt+0x1f3>
					putch('?', putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	6a 3f                	push   $0x3f
  800486:	ff d6                	call   *%esi
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	eb c3                	jmp    800450 <vprintfmt+0x1fd>
  80048d:	89 cf                	mov    %ecx,%edi
  80048f:	eb 0e                	jmp    80049f <vprintfmt+0x24c>
				putch(' ', putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	53                   	push   %ebx
  800495:	6a 20                	push   $0x20
  800497:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800499:	83 ef 01             	sub    $0x1,%edi
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	85 ff                	test   %edi,%edi
  8004a1:	7f ee                	jg     800491 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a9:	e9 52 02 00 00       	jmp    800700 <vprintfmt+0x4ad>
  8004ae:	89 cf                	mov    %ecx,%edi
  8004b0:	eb ed                	jmp    80049f <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	83 c0 04             	add    $0x4,%eax
  8004b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004c0:	85 d2                	test   %edx,%edx
  8004c2:	b8 e3 10 80 00       	mov    $0x8010e3,%eax
  8004c7:	0f 45 c2             	cmovne %edx,%eax
  8004ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d1:	7e 06                	jle    8004d9 <vprintfmt+0x286>
  8004d3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004d7:	75 0d                	jne    8004e6 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004dc:	89 c7                	mov    %eax,%edi
  8004de:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004e4:	eb 55                	jmp    80053b <vprintfmt+0x2e8>
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 e0             	push   -0x20(%ebp)
  8004ec:	ff 75 cc             	push   -0x34(%ebp)
  8004ef:	e8 0a 03 00 00       	call   8007fe <strnlen>
  8004f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004f7:	29 c2                	sub    %eax,%edx
  8004f9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800501:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800505:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800508:	eb 0f                	jmp    800519 <vprintfmt+0x2c6>
					putch(padc, putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	53                   	push   %ebx
  80050e:	ff 75 d4             	push   -0x2c(%ebp)
  800511:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	83 ef 01             	sub    $0x1,%edi
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	85 ff                	test   %edi,%edi
  80051b:	7f ed                	jg     80050a <vprintfmt+0x2b7>
  80051d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800520:	85 d2                	test   %edx,%edx
  800522:	b8 00 00 00 00       	mov    $0x0,%eax
  800527:	0f 49 c2             	cmovns %edx,%eax
  80052a:	29 c2                	sub    %eax,%edx
  80052c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80052f:	eb a8                	jmp    8004d9 <vprintfmt+0x286>
					putch(ch, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	52                   	push   %edx
  800536:	ff d6                	call   *%esi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800540:	83 c7 01             	add    $0x1,%edi
  800543:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800547:	0f be d0             	movsbl %al,%edx
  80054a:	3c 3a                	cmp    $0x3a,%al
  80054c:	74 4b                	je     800599 <vprintfmt+0x346>
  80054e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800552:	78 06                	js     80055a <vprintfmt+0x307>
  800554:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800558:	78 1e                	js     800578 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80055a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80055e:	74 d1                	je     800531 <vprintfmt+0x2de>
  800560:	0f be c0             	movsbl %al,%eax
  800563:	83 e8 20             	sub    $0x20,%eax
  800566:	83 f8 5e             	cmp    $0x5e,%eax
  800569:	76 c6                	jbe    800531 <vprintfmt+0x2de>
					putch('?', putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	53                   	push   %ebx
  80056f:	6a 3f                	push   $0x3f
  800571:	ff d6                	call   *%esi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	eb c3                	jmp    80053b <vprintfmt+0x2e8>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb 0e                	jmp    80058a <vprintfmt+0x337>
				putch(' ', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 20                	push   $0x20
  800582:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800584:	83 ef 01             	sub    $0x1,%edi
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	85 ff                	test   %edi,%edi
  80058c:	7f ee                	jg     80057c <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80058e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
  800594:	e9 67 01 00 00       	jmp    800700 <vprintfmt+0x4ad>
  800599:	89 cf                	mov    %ecx,%edi
  80059b:	eb ed                	jmp    80058a <vprintfmt+0x337>
	if (lflag >= 2)
  80059d:	83 f9 01             	cmp    $0x1,%ecx
  8005a0:	7f 1b                	jg     8005bd <vprintfmt+0x36a>
	else if (lflag)
  8005a2:	85 c9                	test   %ecx,%ecx
  8005a4:	74 63                	je     800609 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ae:	99                   	cltd   
  8005af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb 17                	jmp    8005d4 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 50 04             	mov    0x4(%eax),%edx
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 40 08             	lea    0x8(%eax),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8005da:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005df:	85 c9                	test   %ecx,%ecx
  8005e1:	0f 89 ff 00 00 00    	jns    8006e6 <vprintfmt+0x493>
				putch('-', putdat);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 2d                	push   $0x2d
  8005ed:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005f5:	f7 da                	neg    %edx
  8005f7:	83 d1 00             	adc    $0x0,%ecx
  8005fa:	f7 d9                	neg    %ecx
  8005fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ff:	bf 0a 00 00 00       	mov    $0xa,%edi
  800604:	e9 dd 00 00 00       	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800611:	99                   	cltd   
  800612:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
  80061e:	eb b4                	jmp    8005d4 <vprintfmt+0x381>
	if (lflag >= 2)
  800620:	83 f9 01             	cmp    $0x1,%ecx
  800623:	7f 1e                	jg     800643 <vprintfmt+0x3f0>
	else if (lflag)
  800625:	85 c9                	test   %ecx,%ecx
  800627:	74 32                	je     80065b <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 10                	mov    (%eax),%edx
  80062e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800633:	8d 40 04             	lea    0x4(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800639:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80063e:	e9 a3 00 00 00       	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 10                	mov    (%eax),%edx
  800648:	8b 48 04             	mov    0x4(%eax),%ecx
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800651:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800656:	e9 8b 00 00 00       	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 10                	mov    (%eax),%edx
  800660:	b9 00 00 00 00       	mov    $0x0,%ecx
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800670:	eb 74                	jmp    8006e6 <vprintfmt+0x493>
	if (lflag >= 2)
  800672:	83 f9 01             	cmp    $0x1,%ecx
  800675:	7f 1b                	jg     800692 <vprintfmt+0x43f>
	else if (lflag)
  800677:	85 c9                	test   %ecx,%ecx
  800679:	74 2c                	je     8006a7 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800690:	eb 54                	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	8b 48 04             	mov    0x4(%eax),%ecx
  80069a:	8d 40 08             	lea    0x8(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006a5:	eb 3f                	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b7:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006bc:	eb 28                	jmp    8006e6 <vprintfmt+0x493>
			putch('0', putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	53                   	push   %ebx
  8006c2:	6a 30                	push   $0x30
  8006c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c6:	83 c4 08             	add    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	6a 78                	push   $0x78
  8006cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e1:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ed:	50                   	push   %eax
  8006ee:	ff 75 d4             	push   -0x2c(%ebp)
  8006f1:	57                   	push   %edi
  8006f2:	51                   	push   %ecx
  8006f3:	52                   	push   %edx
  8006f4:	89 da                	mov    %ebx,%edx
  8006f6:	89 f0                	mov    %esi,%eax
  8006f8:	e8 73 fa ff ff       	call   800170 <printnum>
			break;
  8006fd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800700:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	e9 69 fb ff ff       	jmp    800271 <vprintfmt+0x1e>
	if (lflag >= 2)
  800708:	83 f9 01             	cmp    $0x1,%ecx
  80070b:	7f 1b                	jg     800728 <vprintfmt+0x4d5>
	else if (lflag)
  80070d:	85 c9                	test   %ecx,%ecx
  80070f:	74 2c                	je     80073d <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800726:	eb be                	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 10                	mov    (%eax),%edx
  80072d:	8b 48 04             	mov    0x4(%eax),%ecx
  800730:	8d 40 08             	lea    0x8(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80073b:	eb a9                	jmp    8006e6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074d:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800752:	eb 92                	jmp    8006e6 <vprintfmt+0x493>
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	6a 25                	push   $0x25
  80075a:	ff d6                	call   *%esi
			break;
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	eb 9f                	jmp    800700 <vprintfmt+0x4ad>
			putch('%', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 25                	push   $0x25
  800767:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 f8                	mov    %edi,%eax
  80076e:	eb 03                	jmp    800773 <vprintfmt+0x520>
  800770:	83 e8 01             	sub    $0x1,%eax
  800773:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800777:	75 f7                	jne    800770 <vprintfmt+0x51d>
  800779:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80077c:	eb 82                	jmp    800700 <vprintfmt+0x4ad>

0080077e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800791:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079b:	85 c0                	test   %eax,%eax
  80079d:	74 26                	je     8007c5 <vsnprintf+0x47>
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	7e 22                	jle    8007c5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a3:	ff 75 14             	push   0x14(%ebp)
  8007a6:	ff 75 10             	push   0x10(%ebp)
  8007a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ac:	50                   	push   %eax
  8007ad:	68 19 02 80 00       	push   $0x800219
  8007b2:	e8 9c fa ff ff       	call   800253 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    
		return -E_INVAL;
  8007c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ca:	eb f7                	jmp    8007c3 <vsnprintf+0x45>

008007cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 10             	push   0x10(%ebp)
  8007d9:	ff 75 0c             	push   0xc(%ebp)
  8007dc:	ff 75 08             	push   0x8(%ebp)
  8007df:	e8 9a ff ff ff       	call   80077e <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f1:	eb 03                	jmp    8007f6 <strlen+0x10>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fa:	75 f7                	jne    8007f3 <strlen+0xd>
	return n;
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800804:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	eb 03                	jmp    800811 <strnlen+0x13>
		n++;
  80080e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	39 d0                	cmp    %edx,%eax
  800813:	74 08                	je     80081d <strnlen+0x1f>
  800815:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800819:	75 f3                	jne    80080e <strnlen+0x10>
  80081b:	89 c2                	mov    %eax,%edx
	return n;
}
  80081d:	89 d0                	mov    %edx,%eax
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
  800830:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800834:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800837:	83 c0 01             	add    $0x1,%eax
  80083a:	84 d2                	test   %dl,%dl
  80083c:	75 f2                	jne    800830 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80083e:	89 c8                	mov    %ecx,%eax
  800840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	83 ec 10             	sub    $0x10,%esp
  80084c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084f:	53                   	push   %ebx
  800850:	e8 91 ff ff ff       	call   8007e6 <strlen>
  800855:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800858:	ff 75 0c             	push   0xc(%ebp)
  80085b:	01 d8                	add    %ebx,%eax
  80085d:	50                   	push   %eax
  80085e:	e8 be ff ff ff       	call   800821 <strcpy>
	return dst;
}
  800863:	89 d8                	mov    %ebx,%eax
  800865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 75 08             	mov    0x8(%ebp),%esi
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	89 f3                	mov    %esi,%ebx
  800877:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80087a:	89 f0                	mov    %esi,%eax
  80087c:	eb 0f                	jmp    80088d <strncpy+0x23>
		*dst++ = *src;
  80087e:	83 c0 01             	add    $0x1,%eax
  800881:	0f b6 0a             	movzbl (%edx),%ecx
  800884:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800887:	80 f9 01             	cmp    $0x1,%cl
  80088a:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80088d:	39 d8                	cmp    %ebx,%eax
  80088f:	75 ed                	jne    80087e <strncpy+0x14>
	}
	return ret;
}
  800891:	89 f0                	mov    %esi,%eax
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	56                   	push   %esi
  80089b:	53                   	push   %ebx
  80089c:	8b 75 08             	mov    0x8(%ebp),%esi
  80089f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a2:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a7:	85 d2                	test   %edx,%edx
  8008a9:	74 21                	je     8008cc <strlcpy+0x35>
  8008ab:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008af:	89 f2                	mov    %esi,%edx
  8008b1:	eb 09                	jmp    8008bc <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b3:	83 c1 01             	add    $0x1,%ecx
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 09                	je     8008c9 <strlcpy+0x32>
  8008c0:	0f b6 19             	movzbl (%ecx),%ebx
  8008c3:	84 db                	test   %bl,%bl
  8008c5:	75 ec                	jne    8008b3 <strlcpy+0x1c>
  8008c7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008c9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cc:	29 f0                	sub    %esi,%eax
}
  8008ce:	5b                   	pop    %ebx
  8008cf:	5e                   	pop    %esi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008db:	eb 06                	jmp    8008e3 <strcmp+0x11>
		p++, q++;
  8008dd:	83 c1 01             	add    $0x1,%ecx
  8008e0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008e3:	0f b6 01             	movzbl (%ecx),%eax
  8008e6:	84 c0                	test   %al,%al
  8008e8:	74 04                	je     8008ee <strcmp+0x1c>
  8008ea:	3a 02                	cmp    (%edx),%al
  8008ec:	74 ef                	je     8008dd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ee:	0f b6 c0             	movzbl %al,%eax
  8008f1:	0f b6 12             	movzbl (%edx),%edx
  8008f4:	29 d0                	sub    %edx,%eax
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	53                   	push   %ebx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800902:	89 c3                	mov    %eax,%ebx
  800904:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800907:	eb 06                	jmp    80090f <strncmp+0x17>
		n--, p++, q++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80090f:	39 d8                	cmp    %ebx,%eax
  800911:	74 18                	je     80092b <strncmp+0x33>
  800913:	0f b6 08             	movzbl (%eax),%ecx
  800916:	84 c9                	test   %cl,%cl
  800918:	74 04                	je     80091e <strncmp+0x26>
  80091a:	3a 0a                	cmp    (%edx),%cl
  80091c:	74 eb                	je     800909 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091e:	0f b6 00             	movzbl (%eax),%eax
  800921:	0f b6 12             	movzbl (%edx),%edx
  800924:	29 d0                	sub    %edx,%eax
}
  800926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800929:	c9                   	leave  
  80092a:	c3                   	ret    
		return 0;
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
  800930:	eb f4                	jmp    800926 <strncmp+0x2e>

00800932 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093c:	eb 03                	jmp    800941 <strchr+0xf>
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	0f b6 10             	movzbl (%eax),%edx
  800944:	84 d2                	test   %dl,%dl
  800946:	74 06                	je     80094e <strchr+0x1c>
		if (*s == c)
  800948:	38 ca                	cmp    %cl,%dl
  80094a:	75 f2                	jne    80093e <strchr+0xc>
  80094c:	eb 05                	jmp    800953 <strchr+0x21>
			return (char *) s;
	return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800962:	38 ca                	cmp    %cl,%dl
  800964:	74 09                	je     80096f <strfind+0x1a>
  800966:	84 d2                	test   %dl,%dl
  800968:	74 05                	je     80096f <strfind+0x1a>
	for (; *s; s++)
  80096a:	83 c0 01             	add    $0x1,%eax
  80096d:	eb f0                	jmp    80095f <strfind+0xa>
			break;
	return (char *) s;
}
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	57                   	push   %edi
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 7d 08             	mov    0x8(%ebp),%edi
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80097d:	85 c9                	test   %ecx,%ecx
  80097f:	74 2f                	je     8009b0 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800981:	89 f8                	mov    %edi,%eax
  800983:	09 c8                	or     %ecx,%eax
  800985:	a8 03                	test   $0x3,%al
  800987:	75 21                	jne    8009aa <memset+0x39>
		c &= 0xFF;
  800989:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	c1 e0 08             	shl    $0x8,%eax
  800992:	89 d3                	mov    %edx,%ebx
  800994:	c1 e3 18             	shl    $0x18,%ebx
  800997:	89 d6                	mov    %edx,%esi
  800999:	c1 e6 10             	shl    $0x10,%esi
  80099c:	09 f3                	or     %esi,%ebx
  80099e:	09 da                	or     %ebx,%edx
  8009a0:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a5:	fc                   	cld    
  8009a6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a8:	eb 06                	jmp    8009b0 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ad:	fc                   	cld    
  8009ae:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b0:	89 f8                	mov    %edi,%eax
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c5:	39 c6                	cmp    %eax,%esi
  8009c7:	73 32                	jae    8009fb <memmove+0x44>
  8009c9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	76 2b                	jbe    8009fb <memmove+0x44>
		s += n;
		d += n;
  8009d0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d3:	89 d6                	mov    %edx,%esi
  8009d5:	09 fe                	or     %edi,%esi
  8009d7:	09 ce                	or     %ecx,%esi
  8009d9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009df:	75 0e                	jne    8009ef <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e1:	83 ef 04             	sub    $0x4,%edi
  8009e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 09                	jmp    8009f8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ef:	83 ef 01             	sub    $0x1,%edi
  8009f2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f8:	fc                   	cld    
  8009f9:	eb 1a                	jmp    800a15 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fb:	89 f2                	mov    %esi,%edx
  8009fd:	09 c2                	or     %eax,%edx
  8009ff:	09 ca                	or     %ecx,%edx
  800a01:	f6 c2 03             	test   $0x3,%dl
  800a04:	75 0a                	jne    800a10 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a09:	89 c7                	mov    %eax,%edi
  800a0b:	fc                   	cld    
  800a0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0e:	eb 05                	jmp    800a15 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a10:	89 c7                	mov    %eax,%edi
  800a12:	fc                   	cld    
  800a13:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a15:	5e                   	pop    %esi
  800a16:	5f                   	pop    %edi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a1f:	ff 75 10             	push   0x10(%ebp)
  800a22:	ff 75 0c             	push   0xc(%ebp)
  800a25:	ff 75 08             	push   0x8(%ebp)
  800a28:	e8 8a ff ff ff       	call   8009b7 <memmove>
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	89 c6                	mov    %eax,%esi
  800a3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3f:	eb 06                	jmp    800a47 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a41:	83 c0 01             	add    $0x1,%eax
  800a44:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a47:	39 f0                	cmp    %esi,%eax
  800a49:	74 14                	je     800a5f <memcmp+0x30>
		if (*s1 != *s2)
  800a4b:	0f b6 08             	movzbl (%eax),%ecx
  800a4e:	0f b6 1a             	movzbl (%edx),%ebx
  800a51:	38 d9                	cmp    %bl,%cl
  800a53:	74 ec                	je     800a41 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a55:	0f b6 c1             	movzbl %cl,%eax
  800a58:	0f b6 db             	movzbl %bl,%ebx
  800a5b:	29 d8                	sub    %ebx,%eax
  800a5d:	eb 05                	jmp    800a64 <memcmp+0x35>
	}

	return 0;
  800a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a64:	5b                   	pop    %ebx
  800a65:	5e                   	pop    %esi
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    

00800a68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a71:	89 c2                	mov    %eax,%edx
  800a73:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a76:	eb 03                	jmp    800a7b <memfind+0x13>
  800a78:	83 c0 01             	add    $0x1,%eax
  800a7b:	39 d0                	cmp    %edx,%eax
  800a7d:	73 04                	jae    800a83 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7f:	38 08                	cmp    %cl,(%eax)
  800a81:	75 f5                	jne    800a78 <memfind+0x10>
			break;
	return (void *) s;
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a91:	eb 03                	jmp    800a96 <strtol+0x11>
		s++;
  800a93:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a96:	0f b6 02             	movzbl (%edx),%eax
  800a99:	3c 20                	cmp    $0x20,%al
  800a9b:	74 f6                	je     800a93 <strtol+0xe>
  800a9d:	3c 09                	cmp    $0x9,%al
  800a9f:	74 f2                	je     800a93 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa1:	3c 2b                	cmp    $0x2b,%al
  800aa3:	74 2a                	je     800acf <strtol+0x4a>
	int neg = 0;
  800aa5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aaa:	3c 2d                	cmp    $0x2d,%al
  800aac:	74 2b                	je     800ad9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aae:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab4:	75 0f                	jne    800ac5 <strtol+0x40>
  800ab6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ab9:	74 28                	je     800ae3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac2:	0f 44 d8             	cmove  %eax,%ebx
  800ac5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aca:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800acd:	eb 46                	jmp    800b15 <strtol+0x90>
		s++;
  800acf:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad7:	eb d5                	jmp    800aae <strtol+0x29>
		s++, neg = 1;
  800ad9:	83 c2 01             	add    $0x1,%edx
  800adc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae1:	eb cb                	jmp    800aae <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ae7:	74 0e                	je     800af7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	75 d8                	jne    800ac5 <strtol+0x40>
		s++, base = 8;
  800aed:	83 c2 01             	add    $0x1,%edx
  800af0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af5:	eb ce                	jmp    800ac5 <strtol+0x40>
		s += 2, base = 16;
  800af7:	83 c2 02             	add    $0x2,%edx
  800afa:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aff:	eb c4                	jmp    800ac5 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b01:	0f be c0             	movsbl %al,%eax
  800b04:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b0a:	7d 3a                	jge    800b46 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b13:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b15:	0f b6 02             	movzbl (%edx),%eax
  800b18:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b1b:	89 f3                	mov    %esi,%ebx
  800b1d:	80 fb 09             	cmp    $0x9,%bl
  800b20:	76 df                	jbe    800b01 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b22:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b25:	89 f3                	mov    %esi,%ebx
  800b27:	80 fb 19             	cmp    $0x19,%bl
  800b2a:	77 08                	ja     800b34 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b2c:	0f be c0             	movsbl %al,%eax
  800b2f:	83 e8 57             	sub    $0x57,%eax
  800b32:	eb d3                	jmp    800b07 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b34:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b37:	89 f3                	mov    %esi,%ebx
  800b39:	80 fb 19             	cmp    $0x19,%bl
  800b3c:	77 08                	ja     800b46 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b3e:	0f be c0             	movsbl %al,%eax
  800b41:	83 e8 37             	sub    $0x37,%eax
  800b44:	eb c1                	jmp    800b07 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 05                	je     800b51 <strtol+0xcc>
		*endptr = (char *) s;
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b51:	89 c8                	mov    %ecx,%eax
  800b53:	f7 d8                	neg    %eax
  800b55:	85 ff                	test   %edi,%edi
  800b57:	0f 45 c8             	cmovne %eax,%ecx
}
  800b5a:	89 c8                	mov    %ecx,%eax
  800b5c:	5b                   	pop    %ebx
  800b5d:	5e                   	pop    %esi
  800b5e:	5f                   	pop    %edi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b72:	89 c3                	mov    %eax,%ebx
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	89 c6                	mov    %eax,%esi
  800b78:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b8f:	89 d1                	mov    %edx,%ecx
  800b91:	89 d3                	mov    %edx,%ebx
  800b93:	89 d7                	mov    %edx,%edi
  800b95:	89 d6                	mov    %edx,%esi
  800b97:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	89 cb                	mov    %ecx,%ebx
  800bb6:	89 cf                	mov    %ecx,%edi
  800bb8:	89 ce                	mov    %ecx,%esi
  800bba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	7f 08                	jg     800bc8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc8:	83 ec 0c             	sub    $0xc,%esp
  800bcb:	50                   	push   %eax
  800bcc:	6a 03                	push   $0x3
  800bce:	68 df 13 80 00       	push   $0x8013df
  800bd3:	6a 23                	push   $0x23
  800bd5:	68 fc 13 80 00       	push   $0x8013fc
  800bda:	e8 2f 02 00 00       	call   800e0e <_panic>

00800bdf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	57                   	push   %edi
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bea:	b8 02 00 00 00       	mov    $0x2,%eax
  800bef:	89 d1                	mov    %edx,%ecx
  800bf1:	89 d3                	mov    %edx,%ebx
  800bf3:	89 d7                	mov    %edx,%edi
  800bf5:	89 d6                	mov    %edx,%esi
  800bf7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf9:	5b                   	pop    %ebx
  800bfa:	5e                   	pop    %esi
  800bfb:	5f                   	pop    %edi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <sys_yield>:

void
sys_yield(void)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c26:	be 00 00 00 00       	mov    $0x0,%esi
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c31:	b8 04 00 00 00       	mov    $0x4,%eax
  800c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c39:	89 f7                	mov    %esi,%edi
  800c3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	7f 08                	jg     800c49 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c49:	83 ec 0c             	sub    $0xc,%esp
  800c4c:	50                   	push   %eax
  800c4d:	6a 04                	push   $0x4
  800c4f:	68 df 13 80 00       	push   $0x8013df
  800c54:	6a 23                	push   $0x23
  800c56:	68 fc 13 80 00       	push   $0x8013fc
  800c5b:	e8 ae 01 00 00       	call   800e0e <_panic>

00800c60 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 05                	push   $0x5
  800c91:	68 df 13 80 00       	push   $0x8013df
  800c96:	6a 23                	push   $0x23
  800c98:	68 fc 13 80 00       	push   $0x8013fc
  800c9d:	e8 6c 01 00 00       	call   800e0e <_panic>

00800ca2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbb:	89 df                	mov    %ebx,%edi
  800cbd:	89 de                	mov    %ebx,%esi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 06                	push   $0x6
  800cd3:	68 df 13 80 00       	push   $0x8013df
  800cd8:	6a 23                	push   $0x23
  800cda:	68 fc 13 80 00       	push   $0x8013fc
  800cdf:	e8 2a 01 00 00       	call   800e0e <_panic>

00800ce4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 08                	push   $0x8
  800d15:	68 df 13 80 00       	push   $0x8013df
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 fc 13 80 00       	push   $0x8013fc
  800d21:	e8 e8 00 00 00       	call   800e0e <_panic>

00800d26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d3f:	89 df                	mov    %ebx,%edi
  800d41:	89 de                	mov    %ebx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 09                	push   $0x9
  800d57:	68 df 13 80 00       	push   $0x8013df
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 fc 13 80 00       	push   $0x8013fc
  800d63:	e8 a6 00 00 00       	call   800e0e <_panic>

00800d68 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 0a                	push   $0xa
  800d99:	68 df 13 80 00       	push   $0x8013df
  800d9e:	6a 23                	push   $0x23
  800da0:	68 fc 13 80 00       	push   $0x8013fc
  800da5:	e8 64 00 00 00       	call   800e0e <_panic>

00800daa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbb:	be 00 00 00 00       	mov    $0x0,%esi
  800dc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de3:	89 cb                	mov    %ecx,%ebx
  800de5:	89 cf                	mov    %ecx,%edi
  800de7:	89 ce                	mov    %ecx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 0d                	push   $0xd
  800dfd:	68 df 13 80 00       	push   $0x8013df
  800e02:	6a 23                	push   $0x23
  800e04:	68 fc 13 80 00       	push   $0x8013fc
  800e09:	e8 00 00 00 00       	call   800e0e <_panic>

00800e0e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e13:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e16:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e1c:	e8 be fd ff ff       	call   800bdf <sys_getenvid>
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	ff 75 0c             	push   0xc(%ebp)
  800e27:	ff 75 08             	push   0x8(%ebp)
  800e2a:	56                   	push   %esi
  800e2b:	50                   	push   %eax
  800e2c:	68 0c 14 80 00       	push   $0x80140c
  800e31:	e8 26 f3 ff ff       	call   80015c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e36:	83 c4 18             	add    $0x18,%esp
  800e39:	53                   	push   %ebx
  800e3a:	ff 75 10             	push   0x10(%ebp)
  800e3d:	e8 c9 f2 ff ff       	call   80010b <vcprintf>
	cprintf("\n");
  800e42:	c7 04 24 ac 10 80 00 	movl   $0x8010ac,(%esp)
  800e49:	e8 0e f3 ff ff       	call   80015c <cprintf>
  800e4e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e51:	cc                   	int3   
  800e52:	eb fd                	jmp    800e51 <_panic+0x43>
  800e54:	66 90                	xchg   %ax,%ax
  800e56:	66 90                	xchg   %ax,%ax
  800e58:	66 90                	xchg   %ax,%ax
  800e5a:	66 90                	xchg   %ax,%ax
  800e5c:	66 90                	xchg   %ax,%ax
  800e5e:	66 90                	xchg   %ax,%ax

00800e60 <__udivdi3>:
  800e60:	f3 0f 1e fb          	endbr32 
  800e64:	55                   	push   %ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
  800e68:	83 ec 1c             	sub    $0x1c,%esp
  800e6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e73:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	75 19                	jne    800e98 <__udivdi3+0x38>
  800e7f:	39 f3                	cmp    %esi,%ebx
  800e81:	76 4d                	jbe    800ed0 <__udivdi3+0x70>
  800e83:	31 ff                	xor    %edi,%edi
  800e85:	89 e8                	mov    %ebp,%eax
  800e87:	89 f2                	mov    %esi,%edx
  800e89:	f7 f3                	div    %ebx
  800e8b:	89 fa                	mov    %edi,%edx
  800e8d:	83 c4 1c             	add    $0x1c,%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
  800e95:	8d 76 00             	lea    0x0(%esi),%esi
  800e98:	39 f0                	cmp    %esi,%eax
  800e9a:	76 14                	jbe    800eb0 <__udivdi3+0x50>
  800e9c:	31 ff                	xor    %edi,%edi
  800e9e:	31 c0                	xor    %eax,%eax
  800ea0:	89 fa                	mov    %edi,%edx
  800ea2:	83 c4 1c             	add    $0x1c,%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
  800eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800eb0:	0f bd f8             	bsr    %eax,%edi
  800eb3:	83 f7 1f             	xor    $0x1f,%edi
  800eb6:	75 48                	jne    800f00 <__udivdi3+0xa0>
  800eb8:	39 f0                	cmp    %esi,%eax
  800eba:	72 06                	jb     800ec2 <__udivdi3+0x62>
  800ebc:	31 c0                	xor    %eax,%eax
  800ebe:	39 eb                	cmp    %ebp,%ebx
  800ec0:	77 de                	ja     800ea0 <__udivdi3+0x40>
  800ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec7:	eb d7                	jmp    800ea0 <__udivdi3+0x40>
  800ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ed0:	89 d9                	mov    %ebx,%ecx
  800ed2:	85 db                	test   %ebx,%ebx
  800ed4:	75 0b                	jne    800ee1 <__udivdi3+0x81>
  800ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  800edb:	31 d2                	xor    %edx,%edx
  800edd:	f7 f3                	div    %ebx
  800edf:	89 c1                	mov    %eax,%ecx
  800ee1:	31 d2                	xor    %edx,%edx
  800ee3:	89 f0                	mov    %esi,%eax
  800ee5:	f7 f1                	div    %ecx
  800ee7:	89 c6                	mov    %eax,%esi
  800ee9:	89 e8                	mov    %ebp,%eax
  800eeb:	89 f7                	mov    %esi,%edi
  800eed:	f7 f1                	div    %ecx
  800eef:	89 fa                	mov    %edi,%edx
  800ef1:	83 c4 1c             	add    $0x1c,%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    
  800ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f00:	89 f9                	mov    %edi,%ecx
  800f02:	ba 20 00 00 00       	mov    $0x20,%edx
  800f07:	29 fa                	sub    %edi,%edx
  800f09:	d3 e0                	shl    %cl,%eax
  800f0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 d8                	mov    %ebx,%eax
  800f13:	d3 e8                	shr    %cl,%eax
  800f15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f19:	09 c1                	or     %eax,%ecx
  800f1b:	89 f0                	mov    %esi,%eax
  800f1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f21:	89 f9                	mov    %edi,%ecx
  800f23:	d3 e3                	shl    %cl,%ebx
  800f25:	89 d1                	mov    %edx,%ecx
  800f27:	d3 e8                	shr    %cl,%eax
  800f29:	89 f9                	mov    %edi,%ecx
  800f2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f2f:	89 eb                	mov    %ebp,%ebx
  800f31:	d3 e6                	shl    %cl,%esi
  800f33:	89 d1                	mov    %edx,%ecx
  800f35:	d3 eb                	shr    %cl,%ebx
  800f37:	09 f3                	or     %esi,%ebx
  800f39:	89 c6                	mov    %eax,%esi
  800f3b:	89 f2                	mov    %esi,%edx
  800f3d:	89 d8                	mov    %ebx,%eax
  800f3f:	f7 74 24 08          	divl   0x8(%esp)
  800f43:	89 d6                	mov    %edx,%esi
  800f45:	89 c3                	mov    %eax,%ebx
  800f47:	f7 64 24 0c          	mull   0xc(%esp)
  800f4b:	39 d6                	cmp    %edx,%esi
  800f4d:	72 19                	jb     800f68 <__udivdi3+0x108>
  800f4f:	89 f9                	mov    %edi,%ecx
  800f51:	d3 e5                	shl    %cl,%ebp
  800f53:	39 c5                	cmp    %eax,%ebp
  800f55:	73 04                	jae    800f5b <__udivdi3+0xfb>
  800f57:	39 d6                	cmp    %edx,%esi
  800f59:	74 0d                	je     800f68 <__udivdi3+0x108>
  800f5b:	89 d8                	mov    %ebx,%eax
  800f5d:	31 ff                	xor    %edi,%edi
  800f5f:	e9 3c ff ff ff       	jmp    800ea0 <__udivdi3+0x40>
  800f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f6b:	31 ff                	xor    %edi,%edi
  800f6d:	e9 2e ff ff ff       	jmp    800ea0 <__udivdi3+0x40>
  800f72:	66 90                	xchg   %ax,%ax
  800f74:	66 90                	xchg   %ax,%ax
  800f76:	66 90                	xchg   %ax,%ax
  800f78:	66 90                	xchg   %ax,%ax
  800f7a:	66 90                	xchg   %ax,%ax
  800f7c:	66 90                	xchg   %ax,%ax
  800f7e:	66 90                	xchg   %ax,%ax

00800f80 <__umoddi3>:
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
  800f88:	83 ec 1c             	sub    $0x1c,%esp
  800f8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f93:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f97:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f9b:	89 f0                	mov    %esi,%eax
  800f9d:	89 da                	mov    %ebx,%edx
  800f9f:	85 ff                	test   %edi,%edi
  800fa1:	75 15                	jne    800fb8 <__umoddi3+0x38>
  800fa3:	39 dd                	cmp    %ebx,%ebp
  800fa5:	76 39                	jbe    800fe0 <__umoddi3+0x60>
  800fa7:	f7 f5                	div    %ebp
  800fa9:	89 d0                	mov    %edx,%eax
  800fab:	31 d2                	xor    %edx,%edx
  800fad:	83 c4 1c             	add    $0x1c,%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    
  800fb5:	8d 76 00             	lea    0x0(%esi),%esi
  800fb8:	39 df                	cmp    %ebx,%edi
  800fba:	77 f1                	ja     800fad <__umoddi3+0x2d>
  800fbc:	0f bd cf             	bsr    %edi,%ecx
  800fbf:	83 f1 1f             	xor    $0x1f,%ecx
  800fc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fc6:	75 40                	jne    801008 <__umoddi3+0x88>
  800fc8:	39 df                	cmp    %ebx,%edi
  800fca:	72 04                	jb     800fd0 <__umoddi3+0x50>
  800fcc:	39 f5                	cmp    %esi,%ebp
  800fce:	77 dd                	ja     800fad <__umoddi3+0x2d>
  800fd0:	89 da                	mov    %ebx,%edx
  800fd2:	89 f0                	mov    %esi,%eax
  800fd4:	29 e8                	sub    %ebp,%eax
  800fd6:	19 fa                	sbb    %edi,%edx
  800fd8:	eb d3                	jmp    800fad <__umoddi3+0x2d>
  800fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fe0:	89 e9                	mov    %ebp,%ecx
  800fe2:	85 ed                	test   %ebp,%ebp
  800fe4:	75 0b                	jne    800ff1 <__umoddi3+0x71>
  800fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  800feb:	31 d2                	xor    %edx,%edx
  800fed:	f7 f5                	div    %ebp
  800fef:	89 c1                	mov    %eax,%ecx
  800ff1:	89 d8                	mov    %ebx,%eax
  800ff3:	31 d2                	xor    %edx,%edx
  800ff5:	f7 f1                	div    %ecx
  800ff7:	89 f0                	mov    %esi,%eax
  800ff9:	f7 f1                	div    %ecx
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	31 d2                	xor    %edx,%edx
  800fff:	eb ac                	jmp    800fad <__umoddi3+0x2d>
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	8b 44 24 04          	mov    0x4(%esp),%eax
  80100c:	ba 20 00 00 00       	mov    $0x20,%edx
  801011:	29 c2                	sub    %eax,%edx
  801013:	89 c1                	mov    %eax,%ecx
  801015:	89 e8                	mov    %ebp,%eax
  801017:	d3 e7                	shl    %cl,%edi
  801019:	89 d1                	mov    %edx,%ecx
  80101b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80101f:	d3 e8                	shr    %cl,%eax
  801021:	89 c1                	mov    %eax,%ecx
  801023:	8b 44 24 04          	mov    0x4(%esp),%eax
  801027:	09 f9                	or     %edi,%ecx
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80102f:	89 c1                	mov    %eax,%ecx
  801031:	d3 e5                	shl    %cl,%ebp
  801033:	89 d1                	mov    %edx,%ecx
  801035:	d3 ef                	shr    %cl,%edi
  801037:	89 c1                	mov    %eax,%ecx
  801039:	89 f0                	mov    %esi,%eax
  80103b:	d3 e3                	shl    %cl,%ebx
  80103d:	89 d1                	mov    %edx,%ecx
  80103f:	89 fa                	mov    %edi,%edx
  801041:	d3 e8                	shr    %cl,%eax
  801043:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801048:	09 d8                	or     %ebx,%eax
  80104a:	f7 74 24 08          	divl   0x8(%esp)
  80104e:	89 d3                	mov    %edx,%ebx
  801050:	d3 e6                	shl    %cl,%esi
  801052:	f7 e5                	mul    %ebp
  801054:	89 c7                	mov    %eax,%edi
  801056:	89 d1                	mov    %edx,%ecx
  801058:	39 d3                	cmp    %edx,%ebx
  80105a:	72 06                	jb     801062 <__umoddi3+0xe2>
  80105c:	75 0e                	jne    80106c <__umoddi3+0xec>
  80105e:	39 c6                	cmp    %eax,%esi
  801060:	73 0a                	jae    80106c <__umoddi3+0xec>
  801062:	29 e8                	sub    %ebp,%eax
  801064:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801068:	89 d1                	mov    %edx,%ecx
  80106a:	89 c7                	mov    %eax,%edi
  80106c:	89 f5                	mov    %esi,%ebp
  80106e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801072:	29 fd                	sub    %edi,%ebp
  801074:	19 cb                	sbb    %ecx,%ebx
  801076:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80107b:	89 d8                	mov    %ebx,%eax
  80107d:	d3 e0                	shl    %cl,%eax
  80107f:	89 f1                	mov    %esi,%ecx
  801081:	d3 ed                	shr    %cl,%ebp
  801083:	d3 eb                	shr    %cl,%ebx
  801085:	09 e8                	or     %ebp,%eax
  801087:	89 da                	mov    %ebx,%edx
  801089:	83 c4 1c             	add    $0x1c,%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    
