
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	push   0xf0100000
  80003f:	68 80 10 80 00       	push   $0x801080
  800044:	e8 f2 00 00 00       	call   80013b <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 60 0b 00 00       	call   800bbe <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80009a:	6a 00                	push   $0x0
  80009c:	e8 dc 0a 00 00       	call   800b7d <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	53                   	push   %ebx
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b0:	8b 13                	mov    (%ebx),%edx
  8000b2:	8d 42 01             	lea    0x1(%edx),%eax
  8000b5:	89 03                	mov    %eax,(%ebx)
  8000b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000c3:	74 09                	je     8000ce <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cc:	c9                   	leave  
  8000cd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	68 ff 00 00 00       	push   $0xff
  8000d6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000d9:	50                   	push   %eax
  8000da:	e8 61 0a 00 00       	call   800b40 <sys_cputs>
		b->idx = 0;
  8000df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	eb db                	jmp    8000c5 <putch+0x1f>

008000ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000fa:	00 00 00 
	b.cnt = 0;
  8000fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800104:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800107:	ff 75 0c             	push   0xc(%ebp)
  80010a:	ff 75 08             	push   0x8(%ebp)
  80010d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800113:	50                   	push   %eax
  800114:	68 a6 00 80 00       	push   $0x8000a6
  800119:	e8 14 01 00 00       	call   800232 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80011e:	83 c4 08             	add    $0x8,%esp
  800121:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800127:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 0d 0a 00 00       	call   800b40 <sys_cputs>

	return b.cnt;
}
  800133:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800141:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800144:	50                   	push   %eax
  800145:	ff 75 08             	push   0x8(%ebp)
  800148:	e8 9d ff ff ff       	call   8000ea <vcprintf>
	va_end(ap);

	return cnt;
}
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	57                   	push   %edi
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
  800155:	83 ec 1c             	sub    $0x1c,%esp
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800162:	89 d1                	mov    %edx,%ecx
  800164:	89 c2                	mov    %eax,%edx
  800166:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800169:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80016c:	8b 45 10             	mov    0x10(%ebp),%eax
  80016f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800172:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800175:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80017c:	39 c2                	cmp    %eax,%edx
  80017e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800181:	72 3e                	jb     8001c1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 18             	push   0x18(%ebp)
  800189:	83 eb 01             	sub    $0x1,%ebx
  80018c:	53                   	push   %ebx
  80018d:	50                   	push   %eax
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 e4             	push   -0x1c(%ebp)
  800194:	ff 75 e0             	push   -0x20(%ebp)
  800197:	ff 75 dc             	push   -0x24(%ebp)
  80019a:	ff 75 d8             	push   -0x28(%ebp)
  80019d:	e8 9e 0c 00 00       	call   800e40 <__udivdi3>
  8001a2:	83 c4 18             	add    $0x18,%esp
  8001a5:	52                   	push   %edx
  8001a6:	50                   	push   %eax
  8001a7:	89 f2                	mov    %esi,%edx
  8001a9:	89 f8                	mov    %edi,%eax
  8001ab:	e8 9f ff ff ff       	call   80014f <printnum>
  8001b0:	83 c4 20             	add    $0x20,%esp
  8001b3:	eb 13                	jmp    8001c8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	56                   	push   %esi
  8001b9:	ff 75 18             	push   0x18(%ebp)
  8001bc:	ff d7                	call   *%edi
  8001be:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001c1:	83 eb 01             	sub    $0x1,%ebx
  8001c4:	85 db                	test   %ebx,%ebx
  8001c6:	7f ed                	jg     8001b5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	56                   	push   %esi
  8001cc:	83 ec 04             	sub    $0x4,%esp
  8001cf:	ff 75 e4             	push   -0x1c(%ebp)
  8001d2:	ff 75 e0             	push   -0x20(%ebp)
  8001d5:	ff 75 dc             	push   -0x24(%ebp)
  8001d8:	ff 75 d8             	push   -0x28(%ebp)
  8001db:	e8 80 0d 00 00       	call   800f60 <__umoddi3>
  8001e0:	83 c4 14             	add    $0x14,%esp
  8001e3:	0f be 80 b1 10 80 00 	movsbl 0x8010b1(%eax),%eax
  8001ea:	50                   	push   %eax
  8001eb:	ff d7                	call   *%edi
}
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f3:	5b                   	pop    %ebx
  8001f4:	5e                   	pop    %esi
  8001f5:	5f                   	pop    %edi
  8001f6:	5d                   	pop    %ebp
  8001f7:	c3                   	ret    

008001f8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8001fe:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800202:	8b 10                	mov    (%eax),%edx
  800204:	3b 50 04             	cmp    0x4(%eax),%edx
  800207:	73 0a                	jae    800213 <sprintputch+0x1b>
		*b->buf++ = ch;
  800209:	8d 4a 01             	lea    0x1(%edx),%ecx
  80020c:	89 08                	mov    %ecx,(%eax)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	88 02                	mov    %al,(%edx)
}
  800213:	5d                   	pop    %ebp
  800214:	c3                   	ret    

00800215 <printfmt>:
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80021b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80021e:	50                   	push   %eax
  80021f:	ff 75 10             	push   0x10(%ebp)
  800222:	ff 75 0c             	push   0xc(%ebp)
  800225:	ff 75 08             	push   0x8(%ebp)
  800228:	e8 05 00 00 00       	call   800232 <vprintfmt>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <vprintfmt>:
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 3c             	sub    $0x3c,%esp
  80023b:	8b 75 08             	mov    0x8(%ebp),%esi
  80023e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800241:	8b 7d 10             	mov    0x10(%ebp),%edi
  800244:	eb 0a                	jmp    800250 <vprintfmt+0x1e>
			putch(ch, putdat);
  800246:	83 ec 08             	sub    $0x8,%esp
  800249:	53                   	push   %ebx
  80024a:	50                   	push   %eax
  80024b:	ff d6                	call   *%esi
  80024d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800250:	83 c7 01             	add    $0x1,%edi
  800253:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800257:	83 f8 25             	cmp    $0x25,%eax
  80025a:	74 0c                	je     800268 <vprintfmt+0x36>
			if (ch == '\0')
  80025c:	85 c0                	test   %eax,%eax
  80025e:	75 e6                	jne    800246 <vprintfmt+0x14>
}
  800260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800263:	5b                   	pop    %ebx
  800264:	5e                   	pop    %esi
  800265:	5f                   	pop    %edi
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    
		padc = ' ';
  800268:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80026c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800273:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80027a:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800281:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800286:	8d 47 01             	lea    0x1(%edi),%eax
  800289:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80028c:	0f b6 17             	movzbl (%edi),%edx
  80028f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800292:	3c 55                	cmp    $0x55,%al
  800294:	0f 87 a6 04 00 00    	ja     800740 <vprintfmt+0x50e>
  80029a:	0f b6 c0             	movzbl %al,%eax
  80029d:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  8002a4:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002a7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ab:	eb d9                	jmp    800286 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002ad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002b4:	eb d0                	jmp    800286 <vprintfmt+0x54>
  8002b6:	0f b6 d2             	movzbl %dl,%edx
  8002b9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8002c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002cb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ce:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d1:	83 f9 09             	cmp    $0x9,%ecx
  8002d4:	77 55                	ja     80032b <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002d6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d9:	eb e9                	jmp    8002c4 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002db:	8b 45 14             	mov    0x14(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e6:	8d 40 04             	lea    0x4(%eax),%eax
  8002e9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ec:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8002ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8002f3:	79 91                	jns    800286 <vprintfmt+0x54>
				width = precision, precision = -1;
  8002f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800302:	eb 82                	jmp    800286 <vprintfmt+0x54>
  800304:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800307:	85 d2                	test   %edx,%edx
  800309:	b8 00 00 00 00       	mov    $0x0,%eax
  80030e:	0f 49 c2             	cmovns %edx,%eax
  800311:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800314:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800317:	e9 6a ff ff ff       	jmp    800286 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80031c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80031f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800326:	e9 5b ff ff ff       	jmp    800286 <vprintfmt+0x54>
  80032b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80032e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800331:	eb bc                	jmp    8002ef <vprintfmt+0xbd>
			lflag++;
  800333:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800336:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800339:	e9 48 ff ff ff       	jmp    800286 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80033e:	8b 45 14             	mov    0x14(%ebp),%eax
  800341:	8d 78 04             	lea    0x4(%eax),%edi
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	53                   	push   %ebx
  800348:	ff 30                	push   (%eax)
  80034a:	ff d6                	call   *%esi
			break;
  80034c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800352:	e9 88 03 00 00       	jmp    8006df <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 78 04             	lea    0x4(%eax),%edi
  80035d:	8b 10                	mov    (%eax),%edx
  80035f:	89 d0                	mov    %edx,%eax
  800361:	f7 d8                	neg    %eax
  800363:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800366:	83 f8 0f             	cmp    $0xf,%eax
  800369:	7f 23                	jg     80038e <vprintfmt+0x15c>
  80036b:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  800372:	85 d2                	test   %edx,%edx
  800374:	74 18                	je     80038e <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800376:	52                   	push   %edx
  800377:	68 d2 10 80 00       	push   $0x8010d2
  80037c:	53                   	push   %ebx
  80037d:	56                   	push   %esi
  80037e:	e8 92 fe ff ff       	call   800215 <printfmt>
  800383:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800386:	89 7d 14             	mov    %edi,0x14(%ebp)
  800389:	e9 51 03 00 00       	jmp    8006df <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80038e:	50                   	push   %eax
  80038f:	68 c9 10 80 00       	push   $0x8010c9
  800394:	53                   	push   %ebx
  800395:	56                   	push   %esi
  800396:	e8 7a fe ff ff       	call   800215 <printfmt>
  80039b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a1:	e9 39 03 00 00       	jmp    8006df <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	83 c0 04             	add    $0x4,%eax
  8003ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	b8 c2 10 80 00       	mov    $0x8010c2,%eax
  8003bb:	0f 45 c2             	cmovne %edx,%eax
  8003be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003c5:	7e 06                	jle    8003cd <vprintfmt+0x19b>
  8003c7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003cb:	75 0d                	jne    8003da <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003d0:	89 c7                	mov    %eax,%edi
  8003d2:	03 45 d4             	add    -0x2c(%ebp),%eax
  8003d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003d8:	eb 55                	jmp    80042f <vprintfmt+0x1fd>
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 e0             	push   -0x20(%ebp)
  8003e0:	ff 75 cc             	push   -0x34(%ebp)
  8003e3:	e8 f5 03 00 00       	call   8007dd <strnlen>
  8003e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003eb:	29 c2                	sub    %eax,%edx
  8003ed:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8003f5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8003f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fc:	eb 0f                	jmp    80040d <vprintfmt+0x1db>
					putch(padc, putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	53                   	push   %ebx
  800402:	ff 75 d4             	push   -0x2c(%ebp)
  800405:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	83 ef 01             	sub    $0x1,%edi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 ff                	test   %edi,%edi
  80040f:	7f ed                	jg     8003fe <vprintfmt+0x1cc>
  800411:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800414:	85 d2                	test   %edx,%edx
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	0f 49 c2             	cmovns %edx,%eax
  80041e:	29 c2                	sub    %eax,%edx
  800420:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800423:	eb a8                	jmp    8003cd <vprintfmt+0x19b>
					putch(ch, putdat);
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	53                   	push   %ebx
  800429:	52                   	push   %edx
  80042a:	ff d6                	call   *%esi
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800432:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800434:	83 c7 01             	add    $0x1,%edi
  800437:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80043b:	0f be d0             	movsbl %al,%edx
  80043e:	85 d2                	test   %edx,%edx
  800440:	74 4b                	je     80048d <vprintfmt+0x25b>
  800442:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800446:	78 06                	js     80044e <vprintfmt+0x21c>
  800448:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80044c:	78 1e                	js     80046c <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80044e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800452:	74 d1                	je     800425 <vprintfmt+0x1f3>
  800454:	0f be c0             	movsbl %al,%eax
  800457:	83 e8 20             	sub    $0x20,%eax
  80045a:	83 f8 5e             	cmp    $0x5e,%eax
  80045d:	76 c6                	jbe    800425 <vprintfmt+0x1f3>
					putch('?', putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	6a 3f                	push   $0x3f
  800465:	ff d6                	call   *%esi
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	eb c3                	jmp    80042f <vprintfmt+0x1fd>
  80046c:	89 cf                	mov    %ecx,%edi
  80046e:	eb 0e                	jmp    80047e <vprintfmt+0x24c>
				putch(' ', putdat);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	6a 20                	push   $0x20
  800476:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800478:	83 ef 01             	sub    $0x1,%edi
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	85 ff                	test   %edi,%edi
  800480:	7f ee                	jg     800470 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800482:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800485:	89 45 14             	mov    %eax,0x14(%ebp)
  800488:	e9 52 02 00 00       	jmp    8006df <vprintfmt+0x4ad>
  80048d:	89 cf                	mov    %ecx,%edi
  80048f:	eb ed                	jmp    80047e <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049f:	85 d2                	test   %edx,%edx
  8004a1:	b8 c2 10 80 00       	mov    $0x8010c2,%eax
  8004a6:	0f 45 c2             	cmovne %edx,%eax
  8004a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b0:	7e 06                	jle    8004b8 <vprintfmt+0x286>
  8004b2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b6:	75 0d                	jne    8004c5 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bb:	89 c7                	mov    %eax,%edi
  8004bd:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004c3:	eb 55                	jmp    80051a <vprintfmt+0x2e8>
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 e0             	push   -0x20(%ebp)
  8004cb:	ff 75 cc             	push   -0x34(%ebp)
  8004ce:	e8 0a 03 00 00       	call   8007dd <strnlen>
  8004d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d6:	29 c2                	sub    %eax,%edx
  8004d8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004e0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	eb 0f                	jmp    8004f8 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	ff 75 d4             	push   -0x2c(%ebp)
  8004f0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	83 ef 01             	sub    $0x1,%edi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	7f ed                	jg     8004e9 <vprintfmt+0x2b7>
  8004fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	0f 49 c2             	cmovns %edx,%eax
  800509:	29 c2                	sub    %eax,%edx
  80050b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80050e:	eb a8                	jmp    8004b8 <vprintfmt+0x286>
					putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	52                   	push   %edx
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80051d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	3c 3a                	cmp    $0x3a,%al
  80052b:	74 4b                	je     800578 <vprintfmt+0x346>
  80052d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800531:	78 06                	js     800539 <vprintfmt+0x307>
  800533:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800537:	78 1e                	js     800557 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053d:	74 d1                	je     800510 <vprintfmt+0x2de>
  80053f:	0f be c0             	movsbl %al,%eax
  800542:	83 e8 20             	sub    $0x20,%eax
  800545:	83 f8 5e             	cmp    $0x5e,%eax
  800548:	76 c6                	jbe    800510 <vprintfmt+0x2de>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 3f                	push   $0x3f
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb c3                	jmp    80051a <vprintfmt+0x2e8>
  800557:	89 cf                	mov    %ecx,%edi
  800559:	eb 0e                	jmp    800569 <vprintfmt+0x337>
				putch(' ', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ee                	jg     80055b <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 67 01 00 00       	jmp    8006df <vprintfmt+0x4ad>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb ed                	jmp    800569 <vprintfmt+0x337>
	if (lflag >= 2)
  80057c:	83 f9 01             	cmp    $0x1,%ecx
  80057f:	7f 1b                	jg     80059c <vprintfmt+0x36a>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	74 63                	je     8005e8 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058d:	99                   	cltd   
  80058e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8005b9:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005be:	85 c9                	test   %ecx,%ecx
  8005c0:	0f 89 ff 00 00 00    	jns    8006c5 <vprintfmt+0x493>
				putch('-', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2d                	push   $0x2d
  8005cc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d4:	f7 da                	neg    %edx
  8005d6:	83 d1 00             	adc    $0x0,%ecx
  8005d9:	f7 d9                	neg    %ecx
  8005db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005de:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e3:	e9 dd 00 00 00       	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f0:	99                   	cltd   
  8005f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb b4                	jmp    8005b3 <vprintfmt+0x381>
	if (lflag >= 2)
  8005ff:	83 f9 01             	cmp    $0x1,%ecx
  800602:	7f 1e                	jg     800622 <vprintfmt+0x3f0>
	else if (lflag)
  800604:	85 c9                	test   %ecx,%ecx
  800606:	74 32                	je     80063a <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80061d:	e9 a3 00 00 00       	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800635:	e9 8b 00 00 00       	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80064f:	eb 74                	jmp    8006c5 <vprintfmt+0x493>
	if (lflag >= 2)
  800651:	83 f9 01             	cmp    $0x1,%ecx
  800654:	7f 1b                	jg     800671 <vprintfmt+0x43f>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	74 2c                	je     800686 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80066f:	eb 54                	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	8b 48 04             	mov    0x4(%eax),%ecx
  800679:	8d 40 08             	lea    0x8(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800684:	eb 3f                	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80069b:	eb 28                	jmp    8006c5 <vprintfmt+0x493>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 78                	push   $0x78
  8006ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006cc:	50                   	push   %eax
  8006cd:	ff 75 d4             	push   -0x2c(%ebp)
  8006d0:	57                   	push   %edi
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	89 da                	mov    %ebx,%edx
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	e8 73 fa ff ff       	call   80014f <printnum>
			break;
  8006dc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006df:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	e9 69 fb ff ff       	jmp    800250 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006e7:	83 f9 01             	cmp    $0x1,%ecx
  8006ea:	7f 1b                	jg     800707 <vprintfmt+0x4d5>
	else if (lflag)
  8006ec:	85 c9                	test   %ecx,%ecx
  8006ee:	74 2c                	je     80071c <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 10                	mov    (%eax),%edx
  8006f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fa:	8d 40 04             	lea    0x4(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800700:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800705:	eb be                	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	8b 48 04             	mov    0x4(%eax),%ecx
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80071a:	eb a9                	jmp    8006c5 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800731:	eb 92                	jmp    8006c5 <vprintfmt+0x493>
			putch(ch, putdat);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	53                   	push   %ebx
  800737:	6a 25                	push   $0x25
  800739:	ff d6                	call   *%esi
			break;
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	eb 9f                	jmp    8006df <vprintfmt+0x4ad>
			putch('%', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 25                	push   $0x25
  800746:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	89 f8                	mov    %edi,%eax
  80074d:	eb 03                	jmp    800752 <vprintfmt+0x520>
  80074f:	83 e8 01             	sub    $0x1,%eax
  800752:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800756:	75 f7                	jne    80074f <vprintfmt+0x51d>
  800758:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80075b:	eb 82                	jmp    8006df <vprintfmt+0x4ad>

0080075d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 18             	sub    $0x18,%esp
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800769:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80076c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800770:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077a:	85 c0                	test   %eax,%eax
  80077c:	74 26                	je     8007a4 <vsnprintf+0x47>
  80077e:	85 d2                	test   %edx,%edx
  800780:	7e 22                	jle    8007a4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800782:	ff 75 14             	push   0x14(%ebp)
  800785:	ff 75 10             	push   0x10(%ebp)
  800788:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078b:	50                   	push   %eax
  80078c:	68 f8 01 80 00       	push   $0x8001f8
  800791:	e8 9c fa ff ff       	call   800232 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800799:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079f:	83 c4 10             	add    $0x10,%esp
}
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    
		return -E_INVAL;
  8007a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a9:	eb f7                	jmp    8007a2 <vsnprintf+0x45>

008007ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b4:	50                   	push   %eax
  8007b5:	ff 75 10             	push   0x10(%ebp)
  8007b8:	ff 75 0c             	push   0xc(%ebp)
  8007bb:	ff 75 08             	push   0x8(%ebp)
  8007be:	e8 9a ff ff ff       	call   80075d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    

008007c5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d0:	eb 03                	jmp    8007d5 <strlen+0x10>
		n++;
  8007d2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007d5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d9:	75 f7                	jne    8007d2 <strlen+0xd>
	return n;
}
  8007db:	5d                   	pop    %ebp
  8007dc:	c3                   	ret    

008007dd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	eb 03                	jmp    8007f0 <strnlen+0x13>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f0:	39 d0                	cmp    %edx,%eax
  8007f2:	74 08                	je     8007fc <strnlen+0x1f>
  8007f4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f8:	75 f3                	jne    8007ed <strnlen+0x10>
  8007fa:	89 c2                	mov    %eax,%edx
	return n;
}
  8007fc:	89 d0                	mov    %edx,%eax
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800807:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080a:	b8 00 00 00 00       	mov    $0x0,%eax
  80080f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800813:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800816:	83 c0 01             	add    $0x1,%eax
  800819:	84 d2                	test   %dl,%dl
  80081b:	75 f2                	jne    80080f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80081d:	89 c8                	mov    %ecx,%eax
  80081f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800822:	c9                   	leave  
  800823:	c3                   	ret    

00800824 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	53                   	push   %ebx
  800828:	83 ec 10             	sub    $0x10,%esp
  80082b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80082e:	53                   	push   %ebx
  80082f:	e8 91 ff ff ff       	call   8007c5 <strlen>
  800834:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800837:	ff 75 0c             	push   0xc(%ebp)
  80083a:	01 d8                	add    %ebx,%eax
  80083c:	50                   	push   %eax
  80083d:	e8 be ff ff ff       	call   800800 <strcpy>
	return dst;
}
  800842:	89 d8                	mov    %ebx,%eax
  800844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800847:	c9                   	leave  
  800848:	c3                   	ret    

00800849 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	8b 75 08             	mov    0x8(%ebp),%esi
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
  800854:	89 f3                	mov    %esi,%ebx
  800856:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800859:	89 f0                	mov    %esi,%eax
  80085b:	eb 0f                	jmp    80086c <strncpy+0x23>
		*dst++ = *src;
  80085d:	83 c0 01             	add    $0x1,%eax
  800860:	0f b6 0a             	movzbl (%edx),%ecx
  800863:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800866:	80 f9 01             	cmp    $0x1,%cl
  800869:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80086c:	39 d8                	cmp    %ebx,%eax
  80086e:	75 ed                	jne    80085d <strncpy+0x14>
	}
	return ret;
}
  800870:	89 f0                	mov    %esi,%eax
  800872:	5b                   	pop    %ebx
  800873:	5e                   	pop    %esi
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800881:	8b 55 10             	mov    0x10(%ebp),%edx
  800884:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800886:	85 d2                	test   %edx,%edx
  800888:	74 21                	je     8008ab <strlcpy+0x35>
  80088a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80088e:	89 f2                	mov    %esi,%edx
  800890:	eb 09                	jmp    80089b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800892:	83 c1 01             	add    $0x1,%ecx
  800895:	83 c2 01             	add    $0x1,%edx
  800898:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80089b:	39 c2                	cmp    %eax,%edx
  80089d:	74 09                	je     8008a8 <strlcpy+0x32>
  80089f:	0f b6 19             	movzbl (%ecx),%ebx
  8008a2:	84 db                	test   %bl,%bl
  8008a4:	75 ec                	jne    800892 <strlcpy+0x1c>
  8008a6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ab:	29 f0                	sub    %esi,%eax
}
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ba:	eb 06                	jmp    8008c2 <strcmp+0x11>
		p++, q++;
  8008bc:	83 c1 01             	add    $0x1,%ecx
  8008bf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c2:	0f b6 01             	movzbl (%ecx),%eax
  8008c5:	84 c0                	test   %al,%al
  8008c7:	74 04                	je     8008cd <strcmp+0x1c>
  8008c9:	3a 02                	cmp    (%edx),%al
  8008cb:	74 ef                	je     8008bc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cd:	0f b6 c0             	movzbl %al,%eax
  8008d0:	0f b6 12             	movzbl (%edx),%edx
  8008d3:	29 d0                	sub    %edx,%eax
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	89 c3                	mov    %eax,%ebx
  8008e3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e6:	eb 06                	jmp    8008ee <strncmp+0x17>
		n--, p++, q++;
  8008e8:	83 c0 01             	add    $0x1,%eax
  8008eb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ee:	39 d8                	cmp    %ebx,%eax
  8008f0:	74 18                	je     80090a <strncmp+0x33>
  8008f2:	0f b6 08             	movzbl (%eax),%ecx
  8008f5:	84 c9                	test   %cl,%cl
  8008f7:	74 04                	je     8008fd <strncmp+0x26>
  8008f9:	3a 0a                	cmp    (%edx),%cl
  8008fb:	74 eb                	je     8008e8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fd:	0f b6 00             	movzbl (%eax),%eax
  800900:	0f b6 12             	movzbl (%edx),%edx
  800903:	29 d0                	sub    %edx,%eax
}
  800905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800908:	c9                   	leave  
  800909:	c3                   	ret    
		return 0;
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	eb f4                	jmp    800905 <strncmp+0x2e>

00800911 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091b:	eb 03                	jmp    800920 <strchr+0xf>
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	0f b6 10             	movzbl (%eax),%edx
  800923:	84 d2                	test   %dl,%dl
  800925:	74 06                	je     80092d <strchr+0x1c>
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	75 f2                	jne    80091d <strchr+0xc>
  80092b:	eb 05                	jmp    800932 <strchr+0x21>
			return (char *) s;
	return 0;
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800941:	38 ca                	cmp    %cl,%dl
  800943:	74 09                	je     80094e <strfind+0x1a>
  800945:	84 d2                	test   %dl,%dl
  800947:	74 05                	je     80094e <strfind+0x1a>
	for (; *s; s++)
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	eb f0                	jmp    80093e <strfind+0xa>
			break;
	return (char *) s;
}
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	57                   	push   %edi
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 7d 08             	mov    0x8(%ebp),%edi
  800959:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095c:	85 c9                	test   %ecx,%ecx
  80095e:	74 2f                	je     80098f <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800960:	89 f8                	mov    %edi,%eax
  800962:	09 c8                	or     %ecx,%eax
  800964:	a8 03                	test   $0x3,%al
  800966:	75 21                	jne    800989 <memset+0x39>
		c &= 0xFF;
  800968:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80096c:	89 d0                	mov    %edx,%eax
  80096e:	c1 e0 08             	shl    $0x8,%eax
  800971:	89 d3                	mov    %edx,%ebx
  800973:	c1 e3 18             	shl    $0x18,%ebx
  800976:	89 d6                	mov    %edx,%esi
  800978:	c1 e6 10             	shl    $0x10,%esi
  80097b:	09 f3                	or     %esi,%ebx
  80097d:	09 da                	or     %ebx,%edx
  80097f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800981:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800984:	fc                   	cld    
  800985:	f3 ab                	rep stos %eax,%es:(%edi)
  800987:	eb 06                	jmp    80098f <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098c:	fc                   	cld    
  80098d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098f:	89 f8                	mov    %edi,%eax
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5f                   	pop    %edi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	57                   	push   %edi
  80099a:	56                   	push   %esi
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a4:	39 c6                	cmp    %eax,%esi
  8009a6:	73 32                	jae    8009da <memmove+0x44>
  8009a8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ab:	39 c2                	cmp    %eax,%edx
  8009ad:	76 2b                	jbe    8009da <memmove+0x44>
		s += n;
		d += n;
  8009af:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	89 d6                	mov    %edx,%esi
  8009b4:	09 fe                	or     %edi,%esi
  8009b6:	09 ce                	or     %ecx,%esi
  8009b8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009be:	75 0e                	jne    8009ce <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c0:	83 ef 04             	sub    $0x4,%edi
  8009c3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c9:	fd                   	std    
  8009ca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009cc:	eb 09                	jmp    8009d7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ce:	83 ef 01             	sub    $0x1,%edi
  8009d1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d4:	fd                   	std    
  8009d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d7:	fc                   	cld    
  8009d8:	eb 1a                	jmp    8009f4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009da:	89 f2                	mov    %esi,%edx
  8009dc:	09 c2                	or     %eax,%edx
  8009de:	09 ca                	or     %ecx,%edx
  8009e0:	f6 c2 03             	test   $0x3,%dl
  8009e3:	75 0a                	jne    8009ef <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e8:	89 c7                	mov    %eax,%edi
  8009ea:	fc                   	cld    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 05                	jmp    8009f4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009ef:	89 c7                	mov    %eax,%edi
  8009f1:	fc                   	cld    
  8009f2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f4:	5e                   	pop    %esi
  8009f5:	5f                   	pop    %edi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009fe:	ff 75 10             	push   0x10(%ebp)
  800a01:	ff 75 0c             	push   0xc(%ebp)
  800a04:	ff 75 08             	push   0x8(%ebp)
  800a07:	e8 8a ff ff ff       	call   800996 <memmove>
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	89 c6                	mov    %eax,%esi
  800a1b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1e:	eb 06                	jmp    800a26 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a26:	39 f0                	cmp    %esi,%eax
  800a28:	74 14                	je     800a3e <memcmp+0x30>
		if (*s1 != *s2)
  800a2a:	0f b6 08             	movzbl (%eax),%ecx
  800a2d:	0f b6 1a             	movzbl (%edx),%ebx
  800a30:	38 d9                	cmp    %bl,%cl
  800a32:	74 ec                	je     800a20 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a34:	0f b6 c1             	movzbl %cl,%eax
  800a37:	0f b6 db             	movzbl %bl,%ebx
  800a3a:	29 d8                	sub    %ebx,%eax
  800a3c:	eb 05                	jmp    800a43 <memcmp+0x35>
	}

	return 0;
  800a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a50:	89 c2                	mov    %eax,%edx
  800a52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a55:	eb 03                	jmp    800a5a <memfind+0x13>
  800a57:	83 c0 01             	add    $0x1,%eax
  800a5a:	39 d0                	cmp    %edx,%eax
  800a5c:	73 04                	jae    800a62 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5e:	38 08                	cmp    %cl,(%eax)
  800a60:	75 f5                	jne    800a57 <memfind+0x10>
			break;
	return (void *) s;
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a70:	eb 03                	jmp    800a75 <strtol+0x11>
		s++;
  800a72:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a75:	0f b6 02             	movzbl (%edx),%eax
  800a78:	3c 20                	cmp    $0x20,%al
  800a7a:	74 f6                	je     800a72 <strtol+0xe>
  800a7c:	3c 09                	cmp    $0x9,%al
  800a7e:	74 f2                	je     800a72 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a80:	3c 2b                	cmp    $0x2b,%al
  800a82:	74 2a                	je     800aae <strtol+0x4a>
	int neg = 0;
  800a84:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a89:	3c 2d                	cmp    $0x2d,%al
  800a8b:	74 2b                	je     800ab8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a93:	75 0f                	jne    800aa4 <strtol+0x40>
  800a95:	80 3a 30             	cmpb   $0x30,(%edx)
  800a98:	74 28                	je     800ac2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a9a:	85 db                	test   %ebx,%ebx
  800a9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa1:	0f 44 d8             	cmove  %eax,%ebx
  800aa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aa9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aac:	eb 46                	jmp    800af4 <strtol+0x90>
		s++;
  800aae:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab6:	eb d5                	jmp    800a8d <strtol+0x29>
		s++, neg = 1;
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac0:	eb cb                	jmp    800a8d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac2:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ac6:	74 0e                	je     800ad6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	75 d8                	jne    800aa4 <strtol+0x40>
		s++, base = 8;
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad4:	eb ce                	jmp    800aa4 <strtol+0x40>
		s += 2, base = 16;
  800ad6:	83 c2 02             	add    $0x2,%edx
  800ad9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ade:	eb c4                	jmp    800aa4 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ae0:	0f be c0             	movsbl %al,%eax
  800ae3:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ae9:	7d 3a                	jge    800b25 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800aeb:	83 c2 01             	add    $0x1,%edx
  800aee:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800af2:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800af4:	0f b6 02             	movzbl (%edx),%eax
  800af7:	8d 70 d0             	lea    -0x30(%eax),%esi
  800afa:	89 f3                	mov    %esi,%ebx
  800afc:	80 fb 09             	cmp    $0x9,%bl
  800aff:	76 df                	jbe    800ae0 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b01:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b04:	89 f3                	mov    %esi,%ebx
  800b06:	80 fb 19             	cmp    $0x19,%bl
  800b09:	77 08                	ja     800b13 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b0b:	0f be c0             	movsbl %al,%eax
  800b0e:	83 e8 57             	sub    $0x57,%eax
  800b11:	eb d3                	jmp    800ae6 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b13:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b16:	89 f3                	mov    %esi,%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b1d:	0f be c0             	movsbl %al,%eax
  800b20:	83 e8 37             	sub    $0x37,%eax
  800b23:	eb c1                	jmp    800ae6 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b29:	74 05                	je     800b30 <strtol+0xcc>
		*endptr = (char *) s;
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b30:	89 c8                	mov    %ecx,%eax
  800b32:	f7 d8                	neg    %eax
  800b34:	85 ff                	test   %edi,%edi
  800b36:	0f 45 c8             	cmovne %eax,%ecx
}
  800b39:	89 c8                	mov    %ecx,%eax
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5f                   	pop    %edi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	57                   	push   %edi
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b51:	89 c3                	mov    %eax,%ebx
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	89 c6                	mov    %eax,%esi
  800b57:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b59:	5b                   	pop    %ebx
  800b5a:	5e                   	pop    %esi
  800b5b:	5f                   	pop    %edi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	57                   	push   %edi
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b64:	ba 00 00 00 00       	mov    $0x0,%edx
  800b69:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6e:	89 d1                	mov    %edx,%ecx
  800b70:	89 d3                	mov    %edx,%ebx
  800b72:	89 d7                	mov    %edx,%edi
  800b74:	89 d6                	mov    %edx,%esi
  800b76:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5f                   	pop    %edi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b93:	89 cb                	mov    %ecx,%ebx
  800b95:	89 cf                	mov    %ecx,%edi
  800b97:	89 ce                	mov    %ecx,%esi
  800b99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b9b:	85 c0                	test   %eax,%eax
  800b9d:	7f 08                	jg     800ba7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	50                   	push   %eax
  800bab:	6a 03                	push   $0x3
  800bad:	68 bf 13 80 00       	push   $0x8013bf
  800bb2:	6a 23                	push   $0x23
  800bb4:	68 dc 13 80 00       	push   $0x8013dc
  800bb9:	e8 2f 02 00 00       	call   800ded <_panic>

00800bbe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	b8 02 00 00 00       	mov    $0x2,%eax
  800bce:	89 d1                	mov    %edx,%ecx
  800bd0:	89 d3                	mov    %edx,%ebx
  800bd2:	89 d7                	mov    %edx,%edi
  800bd4:	89 d6                	mov    %edx,%esi
  800bd6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bd8:	5b                   	pop    %ebx
  800bd9:	5e                   	pop    %esi
  800bda:	5f                   	pop    %edi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <sys_yield>:

void
sys_yield(void)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bed:	89 d1                	mov    %edx,%ecx
  800bef:	89 d3                	mov    %edx,%ebx
  800bf1:	89 d7                	mov    %edx,%edi
  800bf3:	89 d6                	mov    %edx,%esi
  800bf5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf7:	5b                   	pop    %ebx
  800bf8:	5e                   	pop    %esi
  800bf9:	5f                   	pop    %edi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    

00800bfc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	57                   	push   %edi
  800c00:	56                   	push   %esi
  800c01:	53                   	push   %ebx
  800c02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c05:	be 00 00 00 00       	mov    $0x0,%esi
  800c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c10:	b8 04 00 00 00       	mov    $0x4,%eax
  800c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c18:	89 f7                	mov    %esi,%edi
  800c1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	7f 08                	jg     800c28 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	50                   	push   %eax
  800c2c:	6a 04                	push   $0x4
  800c2e:	68 bf 13 80 00       	push   $0x8013bf
  800c33:	6a 23                	push   $0x23
  800c35:	68 dc 13 80 00       	push   $0x8013dc
  800c3a:	e8 ae 01 00 00       	call   800ded <_panic>

00800c3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c59:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	7f 08                	jg     800c6a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	6a 05                	push   $0x5
  800c70:	68 bf 13 80 00       	push   $0x8013bf
  800c75:	6a 23                	push   $0x23
  800c77:	68 dc 13 80 00       	push   $0x8013dc
  800c7c:	e8 6c 01 00 00       	call   800ded <_panic>

00800c81 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c95:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9a:	89 df                	mov    %ebx,%edi
  800c9c:	89 de                	mov    %ebx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 06                	push   $0x6
  800cb2:	68 bf 13 80 00       	push   $0x8013bf
  800cb7:	6a 23                	push   $0x23
  800cb9:	68 dc 13 80 00       	push   $0x8013dc
  800cbe:	e8 2a 01 00 00       	call   800ded <_panic>

00800cc3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800cdc:	89 df                	mov    %ebx,%edi
  800cde:	89 de                	mov    %ebx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 08                	push   $0x8
  800cf4:	68 bf 13 80 00       	push   $0x8013bf
  800cf9:	6a 23                	push   $0x23
  800cfb:	68 dc 13 80 00       	push   $0x8013dc
  800d00:	e8 e8 00 00 00       	call   800ded <_panic>

00800d05 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
  800d0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	b8 09 00 00 00       	mov    $0x9,%eax
  800d1e:	89 df                	mov    %ebx,%edi
  800d20:	89 de                	mov    %ebx,%esi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 09                	push   $0x9
  800d36:	68 bf 13 80 00       	push   $0x8013bf
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 dc 13 80 00       	push   $0x8013dc
  800d42:	e8 a6 00 00 00       	call   800ded <_panic>

00800d47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d60:	89 df                	mov    %ebx,%edi
  800d62:	89 de                	mov    %ebx,%esi
  800d64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7f 08                	jg     800d72 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	83 ec 0c             	sub    $0xc,%esp
  800d75:	50                   	push   %eax
  800d76:	6a 0a                	push   $0xa
  800d78:	68 bf 13 80 00       	push   $0x8013bf
  800d7d:	6a 23                	push   $0x23
  800d7f:	68 dc 13 80 00       	push   $0x8013dc
  800d84:	e8 64 00 00 00       	call   800ded <_panic>

00800d89 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d9a:	be 00 00 00 00       	mov    $0x0,%esi
  800d9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dc2:	89 cb                	mov    %ecx,%ebx
  800dc4:	89 cf                	mov    %ecx,%edi
  800dc6:	89 ce                	mov    %ecx,%esi
  800dc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	7f 08                	jg     800dd6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	6a 0d                	push   $0xd
  800ddc:	68 bf 13 80 00       	push   $0x8013bf
  800de1:	6a 23                	push   $0x23
  800de3:	68 dc 13 80 00       	push   $0x8013dc
  800de8:	e8 00 00 00 00       	call   800ded <_panic>

00800ded <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800df2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800df5:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800dfb:	e8 be fd ff ff       	call   800bbe <sys_getenvid>
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	ff 75 0c             	push   0xc(%ebp)
  800e06:	ff 75 08             	push   0x8(%ebp)
  800e09:	56                   	push   %esi
  800e0a:	50                   	push   %eax
  800e0b:	68 ec 13 80 00       	push   $0x8013ec
  800e10:	e8 26 f3 ff ff       	call   80013b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e15:	83 c4 18             	add    $0x18,%esp
  800e18:	53                   	push   %ebx
  800e19:	ff 75 10             	push   0x10(%ebp)
  800e1c:	e8 c9 f2 ff ff       	call   8000ea <vcprintf>
	cprintf("\n");
  800e21:	c7 04 24 0f 14 80 00 	movl   $0x80140f,(%esp)
  800e28:	e8 0e f3 ff ff       	call   80013b <cprintf>
  800e2d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e30:	cc                   	int3   
  800e31:	eb fd                	jmp    800e30 <_panic+0x43>
  800e33:	66 90                	xchg   %ax,%ax
  800e35:	66 90                	xchg   %ax,%ax
  800e37:	66 90                	xchg   %ax,%ax
  800e39:	66 90                	xchg   %ax,%ax
  800e3b:	66 90                	xchg   %ax,%ax
  800e3d:	66 90                	xchg   %ax,%ax
  800e3f:	90                   	nop

00800e40 <__udivdi3>:
  800e40:	f3 0f 1e fb          	endbr32 
  800e44:	55                   	push   %ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 1c             	sub    $0x1c,%esp
  800e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e53:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	75 19                	jne    800e78 <__udivdi3+0x38>
  800e5f:	39 f3                	cmp    %esi,%ebx
  800e61:	76 4d                	jbe    800eb0 <__udivdi3+0x70>
  800e63:	31 ff                	xor    %edi,%edi
  800e65:	89 e8                	mov    %ebp,%eax
  800e67:	89 f2                	mov    %esi,%edx
  800e69:	f7 f3                	div    %ebx
  800e6b:	89 fa                	mov    %edi,%edx
  800e6d:	83 c4 1c             	add    $0x1c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
  800e75:	8d 76 00             	lea    0x0(%esi),%esi
  800e78:	39 f0                	cmp    %esi,%eax
  800e7a:	76 14                	jbe    800e90 <__udivdi3+0x50>
  800e7c:	31 ff                	xor    %edi,%edi
  800e7e:	31 c0                	xor    %eax,%eax
  800e80:	89 fa                	mov    %edi,%edx
  800e82:	83 c4 1c             	add    $0x1c,%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
  800e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e90:	0f bd f8             	bsr    %eax,%edi
  800e93:	83 f7 1f             	xor    $0x1f,%edi
  800e96:	75 48                	jne    800ee0 <__udivdi3+0xa0>
  800e98:	39 f0                	cmp    %esi,%eax
  800e9a:	72 06                	jb     800ea2 <__udivdi3+0x62>
  800e9c:	31 c0                	xor    %eax,%eax
  800e9e:	39 eb                	cmp    %ebp,%ebx
  800ea0:	77 de                	ja     800e80 <__udivdi3+0x40>
  800ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea7:	eb d7                	jmp    800e80 <__udivdi3+0x40>
  800ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800eb0:	89 d9                	mov    %ebx,%ecx
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	75 0b                	jne    800ec1 <__udivdi3+0x81>
  800eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ebb:	31 d2                	xor    %edx,%edx
  800ebd:	f7 f3                	div    %ebx
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	31 d2                	xor    %edx,%edx
  800ec3:	89 f0                	mov    %esi,%eax
  800ec5:	f7 f1                	div    %ecx
  800ec7:	89 c6                	mov    %eax,%esi
  800ec9:	89 e8                	mov    %ebp,%eax
  800ecb:	89 f7                	mov    %esi,%edi
  800ecd:	f7 f1                	div    %ecx
  800ecf:	89 fa                	mov    %edi,%edx
  800ed1:	83 c4 1c             	add    $0x1c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
  800ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ee0:	89 f9                	mov    %edi,%ecx
  800ee2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ee7:	29 fa                	sub    %edi,%edx
  800ee9:	d3 e0                	shl    %cl,%eax
  800eeb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eef:	89 d1                	mov    %edx,%ecx
  800ef1:	89 d8                	mov    %ebx,%eax
  800ef3:	d3 e8                	shr    %cl,%eax
  800ef5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ef9:	09 c1                	or     %eax,%ecx
  800efb:	89 f0                	mov    %esi,%eax
  800efd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f01:	89 f9                	mov    %edi,%ecx
  800f03:	d3 e3                	shl    %cl,%ebx
  800f05:	89 d1                	mov    %edx,%ecx
  800f07:	d3 e8                	shr    %cl,%eax
  800f09:	89 f9                	mov    %edi,%ecx
  800f0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f0f:	89 eb                	mov    %ebp,%ebx
  800f11:	d3 e6                	shl    %cl,%esi
  800f13:	89 d1                	mov    %edx,%ecx
  800f15:	d3 eb                	shr    %cl,%ebx
  800f17:	09 f3                	or     %esi,%ebx
  800f19:	89 c6                	mov    %eax,%esi
  800f1b:	89 f2                	mov    %esi,%edx
  800f1d:	89 d8                	mov    %ebx,%eax
  800f1f:	f7 74 24 08          	divl   0x8(%esp)
  800f23:	89 d6                	mov    %edx,%esi
  800f25:	89 c3                	mov    %eax,%ebx
  800f27:	f7 64 24 0c          	mull   0xc(%esp)
  800f2b:	39 d6                	cmp    %edx,%esi
  800f2d:	72 19                	jb     800f48 <__udivdi3+0x108>
  800f2f:	89 f9                	mov    %edi,%ecx
  800f31:	d3 e5                	shl    %cl,%ebp
  800f33:	39 c5                	cmp    %eax,%ebp
  800f35:	73 04                	jae    800f3b <__udivdi3+0xfb>
  800f37:	39 d6                	cmp    %edx,%esi
  800f39:	74 0d                	je     800f48 <__udivdi3+0x108>
  800f3b:	89 d8                	mov    %ebx,%eax
  800f3d:	31 ff                	xor    %edi,%edi
  800f3f:	e9 3c ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f4b:	31 ff                	xor    %edi,%edi
  800f4d:	e9 2e ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f52:	66 90                	xchg   %ax,%ax
  800f54:	66 90                	xchg   %ax,%ax
  800f56:	66 90                	xchg   %ax,%ax
  800f58:	66 90                	xchg   %ax,%ax
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__umoddi3>:
  800f60:	f3 0f 1e fb          	endbr32 
  800f64:	55                   	push   %ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 1c             	sub    $0x1c,%esp
  800f6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f73:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f77:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f7b:	89 f0                	mov    %esi,%eax
  800f7d:	89 da                	mov    %ebx,%edx
  800f7f:	85 ff                	test   %edi,%edi
  800f81:	75 15                	jne    800f98 <__umoddi3+0x38>
  800f83:	39 dd                	cmp    %ebx,%ebp
  800f85:	76 39                	jbe    800fc0 <__umoddi3+0x60>
  800f87:	f7 f5                	div    %ebp
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	83 c4 1c             	add    $0x1c,%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	39 df                	cmp    %ebx,%edi
  800f9a:	77 f1                	ja     800f8d <__umoddi3+0x2d>
  800f9c:	0f bd cf             	bsr    %edi,%ecx
  800f9f:	83 f1 1f             	xor    $0x1f,%ecx
  800fa2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fa6:	75 40                	jne    800fe8 <__umoddi3+0x88>
  800fa8:	39 df                	cmp    %ebx,%edi
  800faa:	72 04                	jb     800fb0 <__umoddi3+0x50>
  800fac:	39 f5                	cmp    %esi,%ebp
  800fae:	77 dd                	ja     800f8d <__umoddi3+0x2d>
  800fb0:	89 da                	mov    %ebx,%edx
  800fb2:	89 f0                	mov    %esi,%eax
  800fb4:	29 e8                	sub    %ebp,%eax
  800fb6:	19 fa                	sbb    %edi,%edx
  800fb8:	eb d3                	jmp    800f8d <__umoddi3+0x2d>
  800fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fc0:	89 e9                	mov    %ebp,%ecx
  800fc2:	85 ed                	test   %ebp,%ebp
  800fc4:	75 0b                	jne    800fd1 <__umoddi3+0x71>
  800fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	f7 f5                	div    %ebp
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 d8                	mov    %ebx,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f1                	div    %ecx
  800fd7:	89 f0                	mov    %esi,%eax
  800fd9:	f7 f1                	div    %ecx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	31 d2                	xor    %edx,%edx
  800fdf:	eb ac                	jmp    800f8d <__umoddi3+0x2d>
  800fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fe8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fec:	ba 20 00 00 00       	mov    $0x20,%edx
  800ff1:	29 c2                	sub    %eax,%edx
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	89 e8                	mov    %ebp,%eax
  800ff7:	d3 e7                	shl    %cl,%edi
  800ff9:	89 d1                	mov    %edx,%ecx
  800ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fff:	d3 e8                	shr    %cl,%eax
  801001:	89 c1                	mov    %eax,%ecx
  801003:	8b 44 24 04          	mov    0x4(%esp),%eax
  801007:	09 f9                	or     %edi,%ecx
  801009:	89 df                	mov    %ebx,%edi
  80100b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80100f:	89 c1                	mov    %eax,%ecx
  801011:	d3 e5                	shl    %cl,%ebp
  801013:	89 d1                	mov    %edx,%ecx
  801015:	d3 ef                	shr    %cl,%edi
  801017:	89 c1                	mov    %eax,%ecx
  801019:	89 f0                	mov    %esi,%eax
  80101b:	d3 e3                	shl    %cl,%ebx
  80101d:	89 d1                	mov    %edx,%ecx
  80101f:	89 fa                	mov    %edi,%edx
  801021:	d3 e8                	shr    %cl,%eax
  801023:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801028:	09 d8                	or     %ebx,%eax
  80102a:	f7 74 24 08          	divl   0x8(%esp)
  80102e:	89 d3                	mov    %edx,%ebx
  801030:	d3 e6                	shl    %cl,%esi
  801032:	f7 e5                	mul    %ebp
  801034:	89 c7                	mov    %eax,%edi
  801036:	89 d1                	mov    %edx,%ecx
  801038:	39 d3                	cmp    %edx,%ebx
  80103a:	72 06                	jb     801042 <__umoddi3+0xe2>
  80103c:	75 0e                	jne    80104c <__umoddi3+0xec>
  80103e:	39 c6                	cmp    %eax,%esi
  801040:	73 0a                	jae    80104c <__umoddi3+0xec>
  801042:	29 e8                	sub    %ebp,%eax
  801044:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801048:	89 d1                	mov    %edx,%ecx
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	89 f5                	mov    %esi,%ebp
  80104e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801052:	29 fd                	sub    %edi,%ebp
  801054:	19 cb                	sbb    %ecx,%ebx
  801056:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	d3 e0                	shl    %cl,%eax
  80105f:	89 f1                	mov    %esi,%ecx
  801061:	d3 ed                	shr    %cl,%ebp
  801063:	d3 eb                	shr    %cl,%ebx
  801065:	09 e8                	or     %ebp,%eax
  801067:	89 da                	mov    %ebx,%edx
  801069:	83 c4 1c             	add    $0x1c,%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
