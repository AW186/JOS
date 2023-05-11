
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 a0 10 80 00       	push   $0x8010a0
  80003e:	e8 08 01 00 00       	call   80014b <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 20 80 00       	mov    0x802004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 ae 10 80 00       	push   $0x8010ae
  800054:	e8 f2 00 00 00       	call   80014b <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 60 0b 00 00       	call   800bce <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000aa:	6a 00                	push   $0x0
  8000ac:	e8 dc 0a 00 00       	call   800b8d <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	53                   	push   %ebx
  8000ba:	83 ec 04             	sub    $0x4,%esp
  8000bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c0:	8b 13                	mov    (%ebx),%edx
  8000c2:	8d 42 01             	lea    0x1(%edx),%eax
  8000c5:	89 03                	mov    %eax,(%ebx)
  8000c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d3:	74 09                	je     8000de <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 ff 00 00 00       	push   $0xff
  8000e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e9:	50                   	push   %eax
  8000ea:	e8 61 0a 00 00       	call   800b50 <sys_cputs>
		b->idx = 0;
  8000ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	eb db                	jmp    8000d5 <putch+0x1f>

008000fa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800103:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010a:	00 00 00 
	b.cnt = 0;
  80010d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800114:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800117:	ff 75 0c             	push   0xc(%ebp)
  80011a:	ff 75 08             	push   0x8(%ebp)
  80011d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800123:	50                   	push   %eax
  800124:	68 b6 00 80 00       	push   $0x8000b6
  800129:	e8 14 01 00 00       	call   800242 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012e:	83 c4 08             	add    $0x8,%esp
  800131:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800137:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 0d 0a 00 00       	call   800b50 <sys_cputs>

	return b.cnt;
}
  800143:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800151:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800154:	50                   	push   %eax
  800155:	ff 75 08             	push   0x8(%ebp)
  800158:	e8 9d ff ff ff       	call   8000fa <vcprintf>
	va_end(ap);

	return cnt;
}
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
  800165:	83 ec 1c             	sub    $0x1c,%esp
  800168:	89 c7                	mov    %eax,%edi
  80016a:	89 d6                	mov    %edx,%esi
  80016c:	8b 45 08             	mov    0x8(%ebp),%eax
  80016f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800172:	89 d1                	mov    %edx,%ecx
  800174:	89 c2                	mov    %eax,%edx
  800176:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800179:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80017c:	8b 45 10             	mov    0x10(%ebp),%eax
  80017f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800182:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800185:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800191:	72 3e                	jb     8001d1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	ff 75 18             	push   0x18(%ebp)
  800199:	83 eb 01             	sub    $0x1,%ebx
  80019c:	53                   	push   %ebx
  80019d:	50                   	push   %eax
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 e4             	push   -0x1c(%ebp)
  8001a4:	ff 75 e0             	push   -0x20(%ebp)
  8001a7:	ff 75 dc             	push   -0x24(%ebp)
  8001aa:	ff 75 d8             	push   -0x28(%ebp)
  8001ad:	e8 9e 0c 00 00       	call   800e50 <__udivdi3>
  8001b2:	83 c4 18             	add    $0x18,%esp
  8001b5:	52                   	push   %edx
  8001b6:	50                   	push   %eax
  8001b7:	89 f2                	mov    %esi,%edx
  8001b9:	89 f8                	mov    %edi,%eax
  8001bb:	e8 9f ff ff ff       	call   80015f <printnum>
  8001c0:	83 c4 20             	add    $0x20,%esp
  8001c3:	eb 13                	jmp    8001d8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	56                   	push   %esi
  8001c9:	ff 75 18             	push   0x18(%ebp)
  8001cc:	ff d7                	call   *%edi
  8001ce:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001d1:	83 eb 01             	sub    $0x1,%ebx
  8001d4:	85 db                	test   %ebx,%ebx
  8001d6:	7f ed                	jg     8001c5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	56                   	push   %esi
  8001dc:	83 ec 04             	sub    $0x4,%esp
  8001df:	ff 75 e4             	push   -0x1c(%ebp)
  8001e2:	ff 75 e0             	push   -0x20(%ebp)
  8001e5:	ff 75 dc             	push   -0x24(%ebp)
  8001e8:	ff 75 d8             	push   -0x28(%ebp)
  8001eb:	e8 80 0d 00 00       	call   800f70 <__umoddi3>
  8001f0:	83 c4 14             	add    $0x14,%esp
  8001f3:	0f be 80 cf 10 80 00 	movsbl 0x8010cf(%eax),%eax
  8001fa:	50                   	push   %eax
  8001fb:	ff d7                	call   *%edi
}
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800212:	8b 10                	mov    (%eax),%edx
  800214:	3b 50 04             	cmp    0x4(%eax),%edx
  800217:	73 0a                	jae    800223 <sprintputch+0x1b>
		*b->buf++ = ch;
  800219:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021c:	89 08                	mov    %ecx,(%eax)
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	88 02                	mov    %al,(%edx)
}
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <printfmt>:
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80022b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 10             	push   0x10(%ebp)
  800232:	ff 75 0c             	push   0xc(%ebp)
  800235:	ff 75 08             	push   0x8(%ebp)
  800238:	e8 05 00 00 00       	call   800242 <vprintfmt>
}
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <vprintfmt>:
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	57                   	push   %edi
  800246:	56                   	push   %esi
  800247:	53                   	push   %ebx
  800248:	83 ec 3c             	sub    $0x3c,%esp
  80024b:	8b 75 08             	mov    0x8(%ebp),%esi
  80024e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800251:	8b 7d 10             	mov    0x10(%ebp),%edi
  800254:	eb 0a                	jmp    800260 <vprintfmt+0x1e>
			putch(ch, putdat);
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	53                   	push   %ebx
  80025a:	50                   	push   %eax
  80025b:	ff d6                	call   *%esi
  80025d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800260:	83 c7 01             	add    $0x1,%edi
  800263:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800267:	83 f8 25             	cmp    $0x25,%eax
  80026a:	74 0c                	je     800278 <vprintfmt+0x36>
			if (ch == '\0')
  80026c:	85 c0                	test   %eax,%eax
  80026e:	75 e6                	jne    800256 <vprintfmt+0x14>
}
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		padc = ' ';
  800278:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80027c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800283:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80028a:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800291:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800296:	8d 47 01             	lea    0x1(%edi),%eax
  800299:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80029c:	0f b6 17             	movzbl (%edi),%edx
  80029f:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a2:	3c 55                	cmp    $0x55,%al
  8002a4:	0f 87 a6 04 00 00    	ja     800750 <vprintfmt+0x50e>
  8002aa:	0f b6 c0             	movzbl %al,%eax
  8002ad:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  8002b4:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002b7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002bb:	eb d9                	jmp    800296 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002bd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002c0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002c4:	eb d0                	jmp    800296 <vprintfmt+0x54>
  8002c6:	0f b6 d2             	movzbl %dl,%edx
  8002c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8002d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002db:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002de:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e1:	83 f9 09             	cmp    $0x9,%ecx
  8002e4:	77 55                	ja     80033b <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002e6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e9:	eb e9                	jmp    8002d4 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f6:	8d 40 04             	lea    0x4(%eax),%eax
  8002f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8002ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800303:	79 91                	jns    800296 <vprintfmt+0x54>
				width = precision, precision = -1;
  800305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800308:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80030b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800312:	eb 82                	jmp    800296 <vprintfmt+0x54>
  800314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800317:	85 d2                	test   %edx,%edx
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
  80031e:	0f 49 c2             	cmovns %edx,%eax
  800321:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800324:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800327:	e9 6a ff ff ff       	jmp    800296 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80032c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80032f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800336:	e9 5b ff ff ff       	jmp    800296 <vprintfmt+0x54>
  80033b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80033e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800341:	eb bc                	jmp    8002ff <vprintfmt+0xbd>
			lflag++;
  800343:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800349:	e9 48 ff ff ff       	jmp    800296 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8d 78 04             	lea    0x4(%eax),%edi
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	53                   	push   %ebx
  800358:	ff 30                	push   (%eax)
  80035a:	ff d6                	call   *%esi
			break;
  80035c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800362:	e9 88 03 00 00       	jmp    8006ef <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 78 04             	lea    0x4(%eax),%edi
  80036d:	8b 10                	mov    (%eax),%edx
  80036f:	89 d0                	mov    %edx,%eax
  800371:	f7 d8                	neg    %eax
  800373:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800376:	83 f8 0f             	cmp    $0xf,%eax
  800379:	7f 23                	jg     80039e <vprintfmt+0x15c>
  80037b:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800382:	85 d2                	test   %edx,%edx
  800384:	74 18                	je     80039e <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800386:	52                   	push   %edx
  800387:	68 f0 10 80 00       	push   $0x8010f0
  80038c:	53                   	push   %ebx
  80038d:	56                   	push   %esi
  80038e:	e8 92 fe ff ff       	call   800225 <printfmt>
  800393:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800396:	89 7d 14             	mov    %edi,0x14(%ebp)
  800399:	e9 51 03 00 00       	jmp    8006ef <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80039e:	50                   	push   %eax
  80039f:	68 e7 10 80 00       	push   $0x8010e7
  8003a4:	53                   	push   %ebx
  8003a5:	56                   	push   %esi
  8003a6:	e8 7a fe ff ff       	call   800225 <printfmt>
  8003ab:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ae:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003b1:	e9 39 03 00 00       	jmp    8006ef <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	83 c0 04             	add    $0x4,%eax
  8003bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003c4:	85 d2                	test   %edx,%edx
  8003c6:	b8 e0 10 80 00       	mov    $0x8010e0,%eax
  8003cb:	0f 45 c2             	cmovne %edx,%eax
  8003ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003d5:	7e 06                	jle    8003dd <vprintfmt+0x19b>
  8003d7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003db:	75 0d                	jne    8003ea <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e0:	89 c7                	mov    %eax,%edi
  8003e2:	03 45 d4             	add    -0x2c(%ebp),%eax
  8003e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003e8:	eb 55                	jmp    80043f <vprintfmt+0x1fd>
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 e0             	push   -0x20(%ebp)
  8003f0:	ff 75 cc             	push   -0x34(%ebp)
  8003f3:	e8 f5 03 00 00       	call   8007ed <strnlen>
  8003f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003fb:	29 c2                	sub    %eax,%edx
  8003fd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800405:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800409:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80040c:	eb 0f                	jmp    80041d <vprintfmt+0x1db>
					putch(padc, putdat);
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	53                   	push   %ebx
  800412:	ff 75 d4             	push   -0x2c(%ebp)
  800415:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800417:	83 ef 01             	sub    $0x1,%edi
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 ff                	test   %edi,%edi
  80041f:	7f ed                	jg     80040e <vprintfmt+0x1cc>
  800421:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800424:	85 d2                	test   %edx,%edx
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	0f 49 c2             	cmovns %edx,%eax
  80042e:	29 c2                	sub    %eax,%edx
  800430:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800433:	eb a8                	jmp    8003dd <vprintfmt+0x19b>
					putch(ch, putdat);
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	53                   	push   %ebx
  800439:	52                   	push   %edx
  80043a:	ff d6                	call   *%esi
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800442:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800444:	83 c7 01             	add    $0x1,%edi
  800447:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80044b:	0f be d0             	movsbl %al,%edx
  80044e:	85 d2                	test   %edx,%edx
  800450:	74 4b                	je     80049d <vprintfmt+0x25b>
  800452:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800456:	78 06                	js     80045e <vprintfmt+0x21c>
  800458:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80045c:	78 1e                	js     80047c <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80045e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800462:	74 d1                	je     800435 <vprintfmt+0x1f3>
  800464:	0f be c0             	movsbl %al,%eax
  800467:	83 e8 20             	sub    $0x20,%eax
  80046a:	83 f8 5e             	cmp    $0x5e,%eax
  80046d:	76 c6                	jbe    800435 <vprintfmt+0x1f3>
					putch('?', putdat);
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	53                   	push   %ebx
  800473:	6a 3f                	push   $0x3f
  800475:	ff d6                	call   *%esi
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	eb c3                	jmp    80043f <vprintfmt+0x1fd>
  80047c:	89 cf                	mov    %ecx,%edi
  80047e:	eb 0e                	jmp    80048e <vprintfmt+0x24c>
				putch(' ', putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	6a 20                	push   $0x20
  800486:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ee                	jg     800480 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 52 02 00 00       	jmp    8006ef <vprintfmt+0x4ad>
  80049d:	89 cf                	mov    %ecx,%edi
  80049f:	eb ed                	jmp    80048e <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a4:	83 c0 04             	add    $0x4,%eax
  8004a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004af:	85 d2                	test   %edx,%edx
  8004b1:	b8 e0 10 80 00       	mov    $0x8010e0,%eax
  8004b6:	0f 45 c2             	cmovne %edx,%eax
  8004b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c0:	7e 06                	jle    8004c8 <vprintfmt+0x286>
  8004c2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c6:	75 0d                	jne    8004d5 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004cb:	89 c7                	mov    %eax,%edi
  8004cd:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004d3:	eb 55                	jmp    80052a <vprintfmt+0x2e8>
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 e0             	push   -0x20(%ebp)
  8004db:	ff 75 cc             	push   -0x34(%ebp)
  8004de:	e8 0a 03 00 00       	call   8007ed <strnlen>
  8004e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e6:	29 c2                	sub    %eax,%edx
  8004e8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f7:	eb 0f                	jmp    800508 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	ff 75 d4             	push   -0x2c(%ebp)
  800500:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800502:	83 ef 01             	sub    $0x1,%edi
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	85 ff                	test   %edi,%edi
  80050a:	7f ed                	jg     8004f9 <vprintfmt+0x2b7>
  80050c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80050f:	85 d2                	test   %edx,%edx
  800511:	b8 00 00 00 00       	mov    $0x0,%eax
  800516:	0f 49 c2             	cmovns %edx,%eax
  800519:	29 c2                	sub    %eax,%edx
  80051b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80051e:	eb a8                	jmp    8004c8 <vprintfmt+0x286>
					putch(ch, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	52                   	push   %edx
  800525:	ff d6                	call   *%esi
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80052d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80052f:	83 c7 01             	add    $0x1,%edi
  800532:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800536:	0f be d0             	movsbl %al,%edx
  800539:	3c 3a                	cmp    $0x3a,%al
  80053b:	74 4b                	je     800588 <vprintfmt+0x346>
  80053d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800541:	78 06                	js     800549 <vprintfmt+0x307>
  800543:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800547:	78 1e                	js     800567 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800549:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054d:	74 d1                	je     800520 <vprintfmt+0x2de>
  80054f:	0f be c0             	movsbl %al,%eax
  800552:	83 e8 20             	sub    $0x20,%eax
  800555:	83 f8 5e             	cmp    $0x5e,%eax
  800558:	76 c6                	jbe    800520 <vprintfmt+0x2de>
					putch('?', putdat);
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	53                   	push   %ebx
  80055e:	6a 3f                	push   $0x3f
  800560:	ff d6                	call   *%esi
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	eb c3                	jmp    80052a <vprintfmt+0x2e8>
  800567:	89 cf                	mov    %ecx,%edi
  800569:	eb 0e                	jmp    800579 <vprintfmt+0x337>
				putch(' ', putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	53                   	push   %ebx
  80056f:	6a 20                	push   $0x20
  800571:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800573:	83 ef 01             	sub    $0x1,%edi
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	85 ff                	test   %edi,%edi
  80057b:	7f ee                	jg     80056b <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80057d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
  800583:	e9 67 01 00 00       	jmp    8006ef <vprintfmt+0x4ad>
  800588:	89 cf                	mov    %ecx,%edi
  80058a:	eb ed                	jmp    800579 <vprintfmt+0x337>
	if (lflag >= 2)
  80058c:	83 f9 01             	cmp    $0x1,%ecx
  80058f:	7f 1b                	jg     8005ac <vprintfmt+0x36a>
	else if (lflag)
  800591:	85 c9                	test   %ecx,%ecx
  800593:	74 63                	je     8005f8 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059d:	99                   	cltd   
  80059e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005aa:	eb 17                	jmp    8005c3 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 50 04             	mov    0x4(%eax),%edx
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8005c9:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	0f 89 ff 00 00 00    	jns    8006d5 <vprintfmt+0x493>
				putch('-', putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 2d                	push   $0x2d
  8005dc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005e4:	f7 da                	neg    %edx
  8005e6:	83 d1 00             	adc    $0x0,%ecx
  8005e9:	f7 d9                	neg    %ecx
  8005eb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ee:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f3:	e9 dd 00 00 00       	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800600:	99                   	cltd   
  800601:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
  80060d:	eb b4                	jmp    8005c3 <vprintfmt+0x381>
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7f 1e                	jg     800632 <vprintfmt+0x3f0>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	74 32                	je     80064a <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80062d:	e9 a3 00 00 00       	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	8b 48 04             	mov    0x4(%eax),%ecx
  80063a:	8d 40 08             	lea    0x8(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800640:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800645:	e9 8b 00 00 00       	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 10                	mov    (%eax),%edx
  80064f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800654:	8d 40 04             	lea    0x4(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80065f:	eb 74                	jmp    8006d5 <vprintfmt+0x493>
	if (lflag >= 2)
  800661:	83 f9 01             	cmp    $0x1,%ecx
  800664:	7f 1b                	jg     800681 <vprintfmt+0x43f>
	else if (lflag)
  800666:	85 c9                	test   %ecx,%ecx
  800668:	74 2c                	je     800696 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 10                	mov    (%eax),%edx
  80066f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067a:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80067f:	eb 54                	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 10                	mov    (%eax),%edx
  800686:	8b 48 04             	mov    0x4(%eax),%ecx
  800689:	8d 40 08             	lea    0x8(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800694:	eb 3f                	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a6:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006ab:	eb 28                	jmp    8006d5 <vprintfmt+0x493>
			putch('0', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 30                	push   $0x30
  8006b3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b5:	83 c4 08             	add    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	6a 78                	push   $0x78
  8006bb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d0:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006dc:	50                   	push   %eax
  8006dd:	ff 75 d4             	push   -0x2c(%ebp)
  8006e0:	57                   	push   %edi
  8006e1:	51                   	push   %ecx
  8006e2:	52                   	push   %edx
  8006e3:	89 da                	mov    %ebx,%edx
  8006e5:	89 f0                	mov    %esi,%eax
  8006e7:	e8 73 fa ff ff       	call   80015f <printnum>
			break;
  8006ec:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ef:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f2:	e9 69 fb ff ff       	jmp    800260 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7f 1b                	jg     800717 <vprintfmt+0x4d5>
	else if (lflag)
  8006fc:	85 c9                	test   %ecx,%ecx
  8006fe:	74 2c                	je     80072c <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 10                	mov    (%eax),%edx
  800705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070a:	8d 40 04             	lea    0x4(%eax),%eax
  80070d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800710:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800715:	eb be                	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 10                	mov    (%eax),%edx
  80071c:	8b 48 04             	mov    0x4(%eax),%ecx
  80071f:	8d 40 08             	lea    0x8(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80072a:	eb a9                	jmp    8006d5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800741:	eb 92                	jmp    8006d5 <vprintfmt+0x493>
			putch(ch, putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	53                   	push   %ebx
  800747:	6a 25                	push   $0x25
  800749:	ff d6                	call   *%esi
			break;
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	eb 9f                	jmp    8006ef <vprintfmt+0x4ad>
			putch('%', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 25                	push   $0x25
  800756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	eb 03                	jmp    800762 <vprintfmt+0x520>
  80075f:	83 e8 01             	sub    $0x1,%eax
  800762:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800766:	75 f7                	jne    80075f <vprintfmt+0x51d>
  800768:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80076b:	eb 82                	jmp    8006ef <vprintfmt+0x4ad>

0080076d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800779:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800780:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078a:	85 c0                	test   %eax,%eax
  80078c:	74 26                	je     8007b4 <vsnprintf+0x47>
  80078e:	85 d2                	test   %edx,%edx
  800790:	7e 22                	jle    8007b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800792:	ff 75 14             	push   0x14(%ebp)
  800795:	ff 75 10             	push   0x10(%ebp)
  800798:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	68 08 02 80 00       	push   $0x800208
  8007a1:	e8 9c fa ff ff       	call   800242 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007af:	83 c4 10             	add    $0x10,%esp
}
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    
		return -E_INVAL;
  8007b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b9:	eb f7                	jmp    8007b2 <vsnprintf+0x45>

008007bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 10             	push   0x10(%ebp)
  8007c8:	ff 75 0c             	push   0xc(%ebp)
  8007cb:	ff 75 08             	push   0x8(%ebp)
  8007ce:	e8 9a ff ff ff       	call   80076d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007db:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e0:	eb 03                	jmp    8007e5 <strlen+0x10>
		n++;
  8007e2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e9:	75 f7                	jne    8007e2 <strlen+0xd>
	return n;
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	eb 03                	jmp    800800 <strnlen+0x13>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800800:	39 d0                	cmp    %edx,%eax
  800802:	74 08                	je     80080c <strnlen+0x1f>
  800804:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800808:	75 f3                	jne    8007fd <strnlen+0x10>
  80080a:	89 c2                	mov    %eax,%edx
	return n;
}
  80080c:	89 d0                	mov    %edx,%eax
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	53                   	push   %ebx
  800814:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800817:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081a:	b8 00 00 00 00       	mov    $0x0,%eax
  80081f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800823:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800826:	83 c0 01             	add    $0x1,%eax
  800829:	84 d2                	test   %dl,%dl
  80082b:	75 f2                	jne    80081f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80082d:	89 c8                	mov    %ecx,%eax
  80082f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	53                   	push   %ebx
  800838:	83 ec 10             	sub    $0x10,%esp
  80083b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80083e:	53                   	push   %ebx
  80083f:	e8 91 ff ff ff       	call   8007d5 <strlen>
  800844:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800847:	ff 75 0c             	push   0xc(%ebp)
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	50                   	push   %eax
  80084d:	e8 be ff ff ff       	call   800810 <strcpy>
	return dst;
}
  800852:	89 d8                	mov    %ebx,%eax
  800854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800857:	c9                   	leave  
  800858:	c3                   	ret    

00800859 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	56                   	push   %esi
  80085d:	53                   	push   %ebx
  80085e:	8b 75 08             	mov    0x8(%ebp),%esi
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
  800864:	89 f3                	mov    %esi,%ebx
  800866:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800869:	89 f0                	mov    %esi,%eax
  80086b:	eb 0f                	jmp    80087c <strncpy+0x23>
		*dst++ = *src;
  80086d:	83 c0 01             	add    $0x1,%eax
  800870:	0f b6 0a             	movzbl (%edx),%ecx
  800873:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800876:	80 f9 01             	cmp    $0x1,%cl
  800879:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80087c:	39 d8                	cmp    %ebx,%eax
  80087e:	75 ed                	jne    80086d <strncpy+0x14>
	}
	return ret;
}
  800880:	89 f0                	mov    %esi,%eax
  800882:	5b                   	pop    %ebx
  800883:	5e                   	pop    %esi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	56                   	push   %esi
  80088a:	53                   	push   %ebx
  80088b:	8b 75 08             	mov    0x8(%ebp),%esi
  80088e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800891:	8b 55 10             	mov    0x10(%ebp),%edx
  800894:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800896:	85 d2                	test   %edx,%edx
  800898:	74 21                	je     8008bb <strlcpy+0x35>
  80089a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80089e:	89 f2                	mov    %esi,%edx
  8008a0:	eb 09                	jmp    8008ab <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a2:	83 c1 01             	add    $0x1,%ecx
  8008a5:	83 c2 01             	add    $0x1,%edx
  8008a8:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008ab:	39 c2                	cmp    %eax,%edx
  8008ad:	74 09                	je     8008b8 <strlcpy+0x32>
  8008af:	0f b6 19             	movzbl (%ecx),%ebx
  8008b2:	84 db                	test   %bl,%bl
  8008b4:	75 ec                	jne    8008a2 <strlcpy+0x1c>
  8008b6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008bb:	29 f0                	sub    %esi,%eax
}
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ca:	eb 06                	jmp    8008d2 <strcmp+0x11>
		p++, q++;
  8008cc:	83 c1 01             	add    $0x1,%ecx
  8008cf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d2:	0f b6 01             	movzbl (%ecx),%eax
  8008d5:	84 c0                	test   %al,%al
  8008d7:	74 04                	je     8008dd <strcmp+0x1c>
  8008d9:	3a 02                	cmp    (%edx),%al
  8008db:	74 ef                	je     8008cc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dd:	0f b6 c0             	movzbl %al,%eax
  8008e0:	0f b6 12             	movzbl (%edx),%edx
  8008e3:	29 d0                	sub    %edx,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f1:	89 c3                	mov    %eax,%ebx
  8008f3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f6:	eb 06                	jmp    8008fe <strncmp+0x17>
		n--, p++, q++;
  8008f8:	83 c0 01             	add    $0x1,%eax
  8008fb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008fe:	39 d8                	cmp    %ebx,%eax
  800900:	74 18                	je     80091a <strncmp+0x33>
  800902:	0f b6 08             	movzbl (%eax),%ecx
  800905:	84 c9                	test   %cl,%cl
  800907:	74 04                	je     80090d <strncmp+0x26>
  800909:	3a 0a                	cmp    (%edx),%cl
  80090b:	74 eb                	je     8008f8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090d:	0f b6 00             	movzbl (%eax),%eax
  800910:	0f b6 12             	movzbl (%edx),%edx
  800913:	29 d0                	sub    %edx,%eax
}
  800915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800918:	c9                   	leave  
  800919:	c3                   	ret    
		return 0;
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	eb f4                	jmp    800915 <strncmp+0x2e>

00800921 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	eb 03                	jmp    800930 <strchr+0xf>
  80092d:	83 c0 01             	add    $0x1,%eax
  800930:	0f b6 10             	movzbl (%eax),%edx
  800933:	84 d2                	test   %dl,%dl
  800935:	74 06                	je     80093d <strchr+0x1c>
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	75 f2                	jne    80092d <strchr+0xc>
  80093b:	eb 05                	jmp    800942 <strchr+0x21>
			return (char *) s;
	return 0;
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800951:	38 ca                	cmp    %cl,%dl
  800953:	74 09                	je     80095e <strfind+0x1a>
  800955:	84 d2                	test   %dl,%dl
  800957:	74 05                	je     80095e <strfind+0x1a>
	for (; *s; s++)
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	eb f0                	jmp    80094e <strfind+0xa>
			break;
	return (char *) s;
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	57                   	push   %edi
  800964:	56                   	push   %esi
  800965:	53                   	push   %ebx
  800966:	8b 7d 08             	mov    0x8(%ebp),%edi
  800969:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096c:	85 c9                	test   %ecx,%ecx
  80096e:	74 2f                	je     80099f <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800970:	89 f8                	mov    %edi,%eax
  800972:	09 c8                	or     %ecx,%eax
  800974:	a8 03                	test   $0x3,%al
  800976:	75 21                	jne    800999 <memset+0x39>
		c &= 0xFF;
  800978:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	c1 e0 08             	shl    $0x8,%eax
  800981:	89 d3                	mov    %edx,%ebx
  800983:	c1 e3 18             	shl    $0x18,%ebx
  800986:	89 d6                	mov    %edx,%esi
  800988:	c1 e6 10             	shl    $0x10,%esi
  80098b:	09 f3                	or     %esi,%ebx
  80098d:	09 da                	or     %ebx,%edx
  80098f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800991:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800994:	fc                   	cld    
  800995:	f3 ab                	rep stos %eax,%es:(%edi)
  800997:	eb 06                	jmp    80099f <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	fc                   	cld    
  80099d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099f:	89 f8                	mov    %edi,%eax
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5f                   	pop    %edi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	57                   	push   %edi
  8009aa:	56                   	push   %esi
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b4:	39 c6                	cmp    %eax,%esi
  8009b6:	73 32                	jae    8009ea <memmove+0x44>
  8009b8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009bb:	39 c2                	cmp    %eax,%edx
  8009bd:	76 2b                	jbe    8009ea <memmove+0x44>
		s += n;
		d += n;
  8009bf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c2:	89 d6                	mov    %edx,%esi
  8009c4:	09 fe                	or     %edi,%esi
  8009c6:	09 ce                	or     %ecx,%esi
  8009c8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ce:	75 0e                	jne    8009de <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d0:	83 ef 04             	sub    $0x4,%edi
  8009d3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009d9:	fd                   	std    
  8009da:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009dc:	eb 09                	jmp    8009e7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009de:	83 ef 01             	sub    $0x1,%edi
  8009e1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e4:	fd                   	std    
  8009e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e7:	fc                   	cld    
  8009e8:	eb 1a                	jmp    800a04 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ea:	89 f2                	mov    %esi,%edx
  8009ec:	09 c2                	or     %eax,%edx
  8009ee:	09 ca                	or     %ecx,%edx
  8009f0:	f6 c2 03             	test   $0x3,%dl
  8009f3:	75 0a                	jne    8009ff <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009f8:	89 c7                	mov    %eax,%edi
  8009fa:	fc                   	cld    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 05                	jmp    800a04 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009ff:	89 c7                	mov    %eax,%edi
  800a01:	fc                   	cld    
  800a02:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a04:	5e                   	pop    %esi
  800a05:	5f                   	pop    %edi
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a0e:	ff 75 10             	push   0x10(%ebp)
  800a11:	ff 75 0c             	push   0xc(%ebp)
  800a14:	ff 75 08             	push   0x8(%ebp)
  800a17:	e8 8a ff ff ff       	call   8009a6 <memmove>
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a29:	89 c6                	mov    %eax,%esi
  800a2b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2e:	eb 06                	jmp    800a36 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a36:	39 f0                	cmp    %esi,%eax
  800a38:	74 14                	je     800a4e <memcmp+0x30>
		if (*s1 != *s2)
  800a3a:	0f b6 08             	movzbl (%eax),%ecx
  800a3d:	0f b6 1a             	movzbl (%edx),%ebx
  800a40:	38 d9                	cmp    %bl,%cl
  800a42:	74 ec                	je     800a30 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a44:	0f b6 c1             	movzbl %cl,%eax
  800a47:	0f b6 db             	movzbl %bl,%ebx
  800a4a:	29 d8                	sub    %ebx,%eax
  800a4c:	eb 05                	jmp    800a53 <memcmp+0x35>
	}

	return 0;
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a60:	89 c2                	mov    %eax,%edx
  800a62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a65:	eb 03                	jmp    800a6a <memfind+0x13>
  800a67:	83 c0 01             	add    $0x1,%eax
  800a6a:	39 d0                	cmp    %edx,%eax
  800a6c:	73 04                	jae    800a72 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a6e:	38 08                	cmp    %cl,(%eax)
  800a70:	75 f5                	jne    800a67 <memfind+0x10>
			break;
	return (void *) s;
}
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a80:	eb 03                	jmp    800a85 <strtol+0x11>
		s++;
  800a82:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a85:	0f b6 02             	movzbl (%edx),%eax
  800a88:	3c 20                	cmp    $0x20,%al
  800a8a:	74 f6                	je     800a82 <strtol+0xe>
  800a8c:	3c 09                	cmp    $0x9,%al
  800a8e:	74 f2                	je     800a82 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a90:	3c 2b                	cmp    $0x2b,%al
  800a92:	74 2a                	je     800abe <strtol+0x4a>
	int neg = 0;
  800a94:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a99:	3c 2d                	cmp    $0x2d,%al
  800a9b:	74 2b                	je     800ac8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa3:	75 0f                	jne    800ab4 <strtol+0x40>
  800aa5:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa8:	74 28                	je     800ad2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab1:	0f 44 d8             	cmove  %eax,%ebx
  800ab4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abc:	eb 46                	jmp    800b04 <strtol+0x90>
		s++;
  800abe:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac6:	eb d5                	jmp    800a9d <strtol+0x29>
		s++, neg = 1;
  800ac8:	83 c2 01             	add    $0x1,%edx
  800acb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad0:	eb cb                	jmp    800a9d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad2:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ad6:	74 0e                	je     800ae6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ad8:	85 db                	test   %ebx,%ebx
  800ada:	75 d8                	jne    800ab4 <strtol+0x40>
		s++, base = 8;
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae4:	eb ce                	jmp    800ab4 <strtol+0x40>
		s += 2, base = 16;
  800ae6:	83 c2 02             	add    $0x2,%edx
  800ae9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aee:	eb c4                	jmp    800ab4 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800af0:	0f be c0             	movsbl %al,%eax
  800af3:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800af9:	7d 3a                	jge    800b35 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800afb:	83 c2 01             	add    $0x1,%edx
  800afe:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b02:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b04:	0f b6 02             	movzbl (%edx),%eax
  800b07:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b0a:	89 f3                	mov    %esi,%ebx
  800b0c:	80 fb 09             	cmp    $0x9,%bl
  800b0f:	76 df                	jbe    800af0 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b11:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b14:	89 f3                	mov    %esi,%ebx
  800b16:	80 fb 19             	cmp    $0x19,%bl
  800b19:	77 08                	ja     800b23 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b1b:	0f be c0             	movsbl %al,%eax
  800b1e:	83 e8 57             	sub    $0x57,%eax
  800b21:	eb d3                	jmp    800af6 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b23:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b26:	89 f3                	mov    %esi,%ebx
  800b28:	80 fb 19             	cmp    $0x19,%bl
  800b2b:	77 08                	ja     800b35 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b2d:	0f be c0             	movsbl %al,%eax
  800b30:	83 e8 37             	sub    $0x37,%eax
  800b33:	eb c1                	jmp    800af6 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 05                	je     800b40 <strtol+0xcc>
		*endptr = (char *) s;
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b40:	89 c8                	mov    %ecx,%eax
  800b42:	f7 d8                	neg    %eax
  800b44:	85 ff                	test   %edi,%edi
  800b46:	0f 45 c8             	cmovne %eax,%ecx
}
  800b49:	89 c8                	mov    %ecx,%eax
  800b4b:	5b                   	pop    %ebx
  800b4c:	5e                   	pop    %esi
  800b4d:	5f                   	pop    %edi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b61:	89 c3                	mov    %eax,%ebx
  800b63:	89 c7                	mov    %eax,%edi
  800b65:	89 c6                	mov    %eax,%esi
  800b67:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b69:	5b                   	pop    %ebx
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7e:	89 d1                	mov    %edx,%ecx
  800b80:	89 d3                	mov    %edx,%ebx
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	89 d6                	mov    %edx,%esi
  800b86:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	89 cb                	mov    %ecx,%ebx
  800ba5:	89 cf                	mov    %ecx,%edi
  800ba7:	89 ce                	mov    %ecx,%esi
  800ba9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bab:	85 c0                	test   %eax,%eax
  800bad:	7f 08                	jg     800bb7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5f                   	pop    %edi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb7:	83 ec 0c             	sub    $0xc,%esp
  800bba:	50                   	push   %eax
  800bbb:	6a 03                	push   $0x3
  800bbd:	68 df 13 80 00       	push   $0x8013df
  800bc2:	6a 23                	push   $0x23
  800bc4:	68 fc 13 80 00       	push   $0x8013fc
  800bc9:	e8 2f 02 00 00       	call   800dfd <_panic>

00800bce <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd9:	b8 02 00 00 00       	mov    $0x2,%eax
  800bde:	89 d1                	mov    %edx,%ecx
  800be0:	89 d3                	mov    %edx,%ebx
  800be2:	89 d7                	mov    %edx,%edi
  800be4:	89 d6                	mov    %edx,%esi
  800be6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <sys_yield>:

void
sys_yield(void)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfd:	89 d1                	mov    %edx,%ecx
  800bff:	89 d3                	mov    %edx,%ebx
  800c01:	89 d7                	mov    %edx,%edi
  800c03:	89 d6                	mov    %edx,%esi
  800c05:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c15:	be 00 00 00 00       	mov    $0x0,%esi
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c20:	b8 04 00 00 00       	mov    $0x4,%eax
  800c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c28:	89 f7                	mov    %esi,%edi
  800c2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2c:	85 c0                	test   %eax,%eax
  800c2e:	7f 08                	jg     800c38 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	50                   	push   %eax
  800c3c:	6a 04                	push   $0x4
  800c3e:	68 df 13 80 00       	push   $0x8013df
  800c43:	6a 23                	push   $0x23
  800c45:	68 fc 13 80 00       	push   $0x8013fc
  800c4a:	e8 ae 01 00 00       	call   800dfd <_panic>

00800c4f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c66:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c69:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	7f 08                	jg     800c7a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7a:	83 ec 0c             	sub    $0xc,%esp
  800c7d:	50                   	push   %eax
  800c7e:	6a 05                	push   $0x5
  800c80:	68 df 13 80 00       	push   $0x8013df
  800c85:	6a 23                	push   $0x23
  800c87:	68 fc 13 80 00       	push   $0x8013fc
  800c8c:	e8 6c 01 00 00       	call   800dfd <_panic>

00800c91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	b8 06 00 00 00       	mov    $0x6,%eax
  800caa:	89 df                	mov    %ebx,%edi
  800cac:	89 de                	mov    %ebx,%esi
  800cae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	7f 08                	jg     800cbc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbc:	83 ec 0c             	sub    $0xc,%esp
  800cbf:	50                   	push   %eax
  800cc0:	6a 06                	push   $0x6
  800cc2:	68 df 13 80 00       	push   $0x8013df
  800cc7:	6a 23                	push   $0x23
  800cc9:	68 fc 13 80 00       	push   $0x8013fc
  800cce:	e8 2a 01 00 00       	call   800dfd <_panic>

00800cd3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	b8 08 00 00 00       	mov    $0x8,%eax
  800cec:	89 df                	mov    %ebx,%edi
  800cee:	89 de                	mov    %ebx,%esi
  800cf0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	7f 08                	jg     800cfe <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfe:	83 ec 0c             	sub    $0xc,%esp
  800d01:	50                   	push   %eax
  800d02:	6a 08                	push   $0x8
  800d04:	68 df 13 80 00       	push   $0x8013df
  800d09:	6a 23                	push   $0x23
  800d0b:	68 fc 13 80 00       	push   $0x8013fc
  800d10:	e8 e8 00 00 00       	call   800dfd <_panic>

00800d15 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2e:	89 df                	mov    %ebx,%edi
  800d30:	89 de                	mov    %ebx,%esi
  800d32:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d34:	85 c0                	test   %eax,%eax
  800d36:	7f 08                	jg     800d40 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d40:	83 ec 0c             	sub    $0xc,%esp
  800d43:	50                   	push   %eax
  800d44:	6a 09                	push   $0x9
  800d46:	68 df 13 80 00       	push   $0x8013df
  800d4b:	6a 23                	push   $0x23
  800d4d:	68 fc 13 80 00       	push   $0x8013fc
  800d52:	e8 a6 00 00 00       	call   800dfd <_panic>

00800d57 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d70:	89 df                	mov    %ebx,%edi
  800d72:	89 de                	mov    %ebx,%esi
  800d74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7f 08                	jg     800d82 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5f                   	pop    %edi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	50                   	push   %eax
  800d86:	6a 0a                	push   $0xa
  800d88:	68 df 13 80 00       	push   $0x8013df
  800d8d:	6a 23                	push   $0x23
  800d8f:	68 fc 13 80 00       	push   $0x8013fc
  800d94:	e8 64 00 00 00       	call   800dfd <_panic>

00800d99 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800daa:	be 00 00 00 00       	mov    $0x0,%esi
  800daf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd2:	89 cb                	mov    %ecx,%ebx
  800dd4:	89 cf                	mov    %ecx,%edi
  800dd6:	89 ce                	mov    %ecx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 0d                	push   $0xd
  800dec:	68 df 13 80 00       	push   $0x8013df
  800df1:	6a 23                	push   $0x23
  800df3:	68 fc 13 80 00       	push   $0x8013fc
  800df8:	e8 00 00 00 00       	call   800dfd <_panic>

00800dfd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e02:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e05:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e0b:	e8 be fd ff ff       	call   800bce <sys_getenvid>
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	ff 75 0c             	push   0xc(%ebp)
  800e16:	ff 75 08             	push   0x8(%ebp)
  800e19:	56                   	push   %esi
  800e1a:	50                   	push   %eax
  800e1b:	68 0c 14 80 00       	push   $0x80140c
  800e20:	e8 26 f3 ff ff       	call   80014b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e25:	83 c4 18             	add    $0x18,%esp
  800e28:	53                   	push   %ebx
  800e29:	ff 75 10             	push   0x10(%ebp)
  800e2c:	e8 c9 f2 ff ff       	call   8000fa <vcprintf>
	cprintf("\n");
  800e31:	c7 04 24 ac 10 80 00 	movl   $0x8010ac,(%esp)
  800e38:	e8 0e f3 ff ff       	call   80014b <cprintf>
  800e3d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e40:	cc                   	int3   
  800e41:	eb fd                	jmp    800e40 <_panic+0x43>
  800e43:	66 90                	xchg   %ax,%ax
  800e45:	66 90                	xchg   %ax,%ax
  800e47:	66 90                	xchg   %ax,%ax
  800e49:	66 90                	xchg   %ax,%ax
  800e4b:	66 90                	xchg   %ax,%ax
  800e4d:	66 90                	xchg   %ax,%ax
  800e4f:	90                   	nop

00800e50 <__udivdi3>:
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 1c             	sub    $0x1c,%esp
  800e5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e63:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 19                	jne    800e88 <__udivdi3+0x38>
  800e6f:	39 f3                	cmp    %esi,%ebx
  800e71:	76 4d                	jbe    800ec0 <__udivdi3+0x70>
  800e73:	31 ff                	xor    %edi,%edi
  800e75:	89 e8                	mov    %ebp,%eax
  800e77:	89 f2                	mov    %esi,%edx
  800e79:	f7 f3                	div    %ebx
  800e7b:	89 fa                	mov    %edi,%edx
  800e7d:	83 c4 1c             	add    $0x1c,%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
  800e85:	8d 76 00             	lea    0x0(%esi),%esi
  800e88:	39 f0                	cmp    %esi,%eax
  800e8a:	76 14                	jbe    800ea0 <__udivdi3+0x50>
  800e8c:	31 ff                	xor    %edi,%edi
  800e8e:	31 c0                	xor    %eax,%eax
  800e90:	89 fa                	mov    %edi,%edx
  800e92:	83 c4 1c             	add    $0x1c,%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    
  800e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ea0:	0f bd f8             	bsr    %eax,%edi
  800ea3:	83 f7 1f             	xor    $0x1f,%edi
  800ea6:	75 48                	jne    800ef0 <__udivdi3+0xa0>
  800ea8:	39 f0                	cmp    %esi,%eax
  800eaa:	72 06                	jb     800eb2 <__udivdi3+0x62>
  800eac:	31 c0                	xor    %eax,%eax
  800eae:	39 eb                	cmp    %ebp,%ebx
  800eb0:	77 de                	ja     800e90 <__udivdi3+0x40>
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	eb d7                	jmp    800e90 <__udivdi3+0x40>
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 d9                	mov    %ebx,%ecx
  800ec2:	85 db                	test   %ebx,%ebx
  800ec4:	75 0b                	jne    800ed1 <__udivdi3+0x81>
  800ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	f7 f3                	div    %ebx
  800ecf:	89 c1                	mov    %eax,%ecx
  800ed1:	31 d2                	xor    %edx,%edx
  800ed3:	89 f0                	mov    %esi,%eax
  800ed5:	f7 f1                	div    %ecx
  800ed7:	89 c6                	mov    %eax,%esi
  800ed9:	89 e8                	mov    %ebp,%eax
  800edb:	89 f7                	mov    %esi,%edi
  800edd:	f7 f1                	div    %ecx
  800edf:	89 fa                	mov    %edi,%edx
  800ee1:	83 c4 1c             	add    $0x1c,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 f9                	mov    %edi,%ecx
  800ef2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ef7:	29 fa                	sub    %edi,%edx
  800ef9:	d3 e0                	shl    %cl,%eax
  800efb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 d8                	mov    %ebx,%eax
  800f03:	d3 e8                	shr    %cl,%eax
  800f05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f09:	09 c1                	or     %eax,%ecx
  800f0b:	89 f0                	mov    %esi,%eax
  800f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f11:	89 f9                	mov    %edi,%ecx
  800f13:	d3 e3                	shl    %cl,%ebx
  800f15:	89 d1                	mov    %edx,%ecx
  800f17:	d3 e8                	shr    %cl,%eax
  800f19:	89 f9                	mov    %edi,%ecx
  800f1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f1f:	89 eb                	mov    %ebp,%ebx
  800f21:	d3 e6                	shl    %cl,%esi
  800f23:	89 d1                	mov    %edx,%ecx
  800f25:	d3 eb                	shr    %cl,%ebx
  800f27:	09 f3                	or     %esi,%ebx
  800f29:	89 c6                	mov    %eax,%esi
  800f2b:	89 f2                	mov    %esi,%edx
  800f2d:	89 d8                	mov    %ebx,%eax
  800f2f:	f7 74 24 08          	divl   0x8(%esp)
  800f33:	89 d6                	mov    %edx,%esi
  800f35:	89 c3                	mov    %eax,%ebx
  800f37:	f7 64 24 0c          	mull   0xc(%esp)
  800f3b:	39 d6                	cmp    %edx,%esi
  800f3d:	72 19                	jb     800f58 <__udivdi3+0x108>
  800f3f:	89 f9                	mov    %edi,%ecx
  800f41:	d3 e5                	shl    %cl,%ebp
  800f43:	39 c5                	cmp    %eax,%ebp
  800f45:	73 04                	jae    800f4b <__udivdi3+0xfb>
  800f47:	39 d6                	cmp    %edx,%esi
  800f49:	74 0d                	je     800f58 <__udivdi3+0x108>
  800f4b:	89 d8                	mov    %ebx,%eax
  800f4d:	31 ff                	xor    %edi,%edi
  800f4f:	e9 3c ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f5b:	31 ff                	xor    %edi,%edi
  800f5d:	e9 2e ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f62:	66 90                	xchg   %ax,%ax
  800f64:	66 90                	xchg   %ax,%ax
  800f66:	66 90                	xchg   %ax,%ax
  800f68:	66 90                	xchg   %ax,%ax
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__umoddi3>:
  800f70:	f3 0f 1e fb          	endbr32 
  800f74:	55                   	push   %ebp
  800f75:	57                   	push   %edi
  800f76:	56                   	push   %esi
  800f77:	53                   	push   %ebx
  800f78:	83 ec 1c             	sub    $0x1c,%esp
  800f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f83:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f87:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	89 da                	mov    %ebx,%edx
  800f8f:	85 ff                	test   %edi,%edi
  800f91:	75 15                	jne    800fa8 <__umoddi3+0x38>
  800f93:	39 dd                	cmp    %ebx,%ebp
  800f95:	76 39                	jbe    800fd0 <__umoddi3+0x60>
  800f97:	f7 f5                	div    %ebp
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	83 c4 1c             	add    $0x1c,%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	39 df                	cmp    %ebx,%edi
  800faa:	77 f1                	ja     800f9d <__umoddi3+0x2d>
  800fac:	0f bd cf             	bsr    %edi,%ecx
  800faf:	83 f1 1f             	xor    $0x1f,%ecx
  800fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fb6:	75 40                	jne    800ff8 <__umoddi3+0x88>
  800fb8:	39 df                	cmp    %ebx,%edi
  800fba:	72 04                	jb     800fc0 <__umoddi3+0x50>
  800fbc:	39 f5                	cmp    %esi,%ebp
  800fbe:	77 dd                	ja     800f9d <__umoddi3+0x2d>
  800fc0:	89 da                	mov    %ebx,%edx
  800fc2:	89 f0                	mov    %esi,%eax
  800fc4:	29 e8                	sub    %ebp,%eax
  800fc6:	19 fa                	sbb    %edi,%edx
  800fc8:	eb d3                	jmp    800f9d <__umoddi3+0x2d>
  800fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fd0:	89 e9                	mov    %ebp,%ecx
  800fd2:	85 ed                	test   %ebp,%ebp
  800fd4:	75 0b                	jne    800fe1 <__umoddi3+0x71>
  800fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f5                	div    %ebp
  800fdf:	89 c1                	mov    %eax,%ecx
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	31 d2                	xor    %edx,%edx
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 f0                	mov    %esi,%eax
  800fe9:	f7 f1                	div    %ecx
  800feb:	89 d0                	mov    %edx,%eax
  800fed:	31 d2                	xor    %edx,%edx
  800fef:	eb ac                	jmp    800f9d <__umoddi3+0x2d>
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ffc:	ba 20 00 00 00       	mov    $0x20,%edx
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 c1                	mov    %eax,%ecx
  801005:	89 e8                	mov    %ebp,%eax
  801007:	d3 e7                	shl    %cl,%edi
  801009:	89 d1                	mov    %edx,%ecx
  80100b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80100f:	d3 e8                	shr    %cl,%eax
  801011:	89 c1                	mov    %eax,%ecx
  801013:	8b 44 24 04          	mov    0x4(%esp),%eax
  801017:	09 f9                	or     %edi,%ecx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	d3 e5                	shl    %cl,%ebp
  801023:	89 d1                	mov    %edx,%ecx
  801025:	d3 ef                	shr    %cl,%edi
  801027:	89 c1                	mov    %eax,%ecx
  801029:	89 f0                	mov    %esi,%eax
  80102b:	d3 e3                	shl    %cl,%ebx
  80102d:	89 d1                	mov    %edx,%ecx
  80102f:	89 fa                	mov    %edi,%edx
  801031:	d3 e8                	shr    %cl,%eax
  801033:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801038:	09 d8                	or     %ebx,%eax
  80103a:	f7 74 24 08          	divl   0x8(%esp)
  80103e:	89 d3                	mov    %edx,%ebx
  801040:	d3 e6                	shl    %cl,%esi
  801042:	f7 e5                	mul    %ebp
  801044:	89 c7                	mov    %eax,%edi
  801046:	89 d1                	mov    %edx,%ecx
  801048:	39 d3                	cmp    %edx,%ebx
  80104a:	72 06                	jb     801052 <__umoddi3+0xe2>
  80104c:	75 0e                	jne    80105c <__umoddi3+0xec>
  80104e:	39 c6                	cmp    %eax,%esi
  801050:	73 0a                	jae    80105c <__umoddi3+0xec>
  801052:	29 e8                	sub    %ebp,%eax
  801054:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	89 c7                	mov    %eax,%edi
  80105c:	89 f5                	mov    %esi,%ebp
  80105e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801062:	29 fd                	sub    %edi,%ebp
  801064:	19 cb                	sbb    %ecx,%ebx
  801066:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80106b:	89 d8                	mov    %ebx,%eax
  80106d:	d3 e0                	shl    %cl,%eax
  80106f:	89 f1                	mov    %esi,%ecx
  801071:	d3 ed                	shr    %cl,%ebp
  801073:	d3 eb                	shr    %cl,%ebx
  801075:	09 e8                	or     %ebp,%eax
  801077:	89 da                	mov    %ebx,%edx
  801079:	83 c4 1c             	add    $0x1c,%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
