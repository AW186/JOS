
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	push   (%edx)
  800045:	68 40 11 80 00       	push   $0x801140
  80004a:	e8 1e 01 00 00       	call   80016d <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 9c 0b 00 00       	call   800bf0 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 53 0b 00 00       	call   800baf <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 ae 0d 00 00       	call   800e1f <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 60 0b 00 00       	call   800bf0 <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	e8 dc 0a 00 00       	call   800baf <sys_env_destroy>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	c9                   	leave  
  8000d7:	c3                   	ret    

008000d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 04             	sub    $0x4,%esp
  8000df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e2:	8b 13                	mov    (%ebx),%edx
  8000e4:	8d 42 01             	lea    0x1(%edx),%eax
  8000e7:	89 03                	mov    %eax,(%ebx)
  8000e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f5:	74 09                	je     800100 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000f7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fe:	c9                   	leave  
  8000ff:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	68 ff 00 00 00       	push   $0xff
  800108:	8d 43 08             	lea    0x8(%ebx),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 61 0a 00 00       	call   800b72 <sys_cputs>
		b->idx = 0;
  800111:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	eb db                	jmp    8000f7 <putch+0x1f>

0080011c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800125:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012c:	00 00 00 
	b.cnt = 0;
  80012f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800136:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800139:	ff 75 0c             	push   0xc(%ebp)
  80013c:	ff 75 08             	push   0x8(%ebp)
  80013f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	68 d8 00 80 00       	push   $0x8000d8
  80014b:	e8 14 01 00 00       	call   800264 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800150:	83 c4 08             	add    $0x8,%esp
  800153:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800159:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	e8 0d 0a 00 00       	call   800b72 <sys_cputs>

	return b.cnt;
}
  800165:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800173:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800176:	50                   	push   %eax
  800177:	ff 75 08             	push   0x8(%ebp)
  80017a:	e8 9d ff ff ff       	call   80011c <vcprintf>
	va_end(ap);

	return cnt;
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 1c             	sub    $0x1c,%esp
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	89 d6                	mov    %edx,%esi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	8b 55 0c             	mov    0xc(%ebp),%edx
  800194:	89 d1                	mov    %edx,%ecx
  800196:	89 c2                	mov    %eax,%edx
  800198:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019e:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ae:	39 c2                	cmp    %eax,%edx
  8001b0:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b3:	72 3e                	jb     8001f3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 18             	push   0x18(%ebp)
  8001bb:	83 eb 01             	sub    $0x1,%ebx
  8001be:	53                   	push   %ebx
  8001bf:	50                   	push   %eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	ff 75 e4             	push   -0x1c(%ebp)
  8001c6:	ff 75 e0             	push   -0x20(%ebp)
  8001c9:	ff 75 dc             	push   -0x24(%ebp)
  8001cc:	ff 75 d8             	push   -0x28(%ebp)
  8001cf:	e8 2c 0d 00 00       	call   800f00 <__udivdi3>
  8001d4:	83 c4 18             	add    $0x18,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	89 f2                	mov    %esi,%edx
  8001db:	89 f8                	mov    %edi,%eax
  8001dd:	e8 9f ff ff ff       	call   800181 <printnum>
  8001e2:	83 c4 20             	add    $0x20,%esp
  8001e5:	eb 13                	jmp    8001fa <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	56                   	push   %esi
  8001eb:	ff 75 18             	push   0x18(%ebp)
  8001ee:	ff d7                	call   *%edi
  8001f0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f3:	83 eb 01             	sub    $0x1,%ebx
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7f ed                	jg     8001e7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	ff 75 e4             	push   -0x1c(%ebp)
  800204:	ff 75 e0             	push   -0x20(%ebp)
  800207:	ff 75 dc             	push   -0x24(%ebp)
  80020a:	ff 75 d8             	push   -0x28(%ebp)
  80020d:	e8 0e 0e 00 00       	call   801020 <__umoddi3>
  800212:	83 c4 14             	add    $0x14,%esp
  800215:	0f be 80 66 11 80 00 	movsbl 0x801166(%eax),%eax
  80021c:	50                   	push   %eax
  80021d:	ff d7                	call   *%edi
}
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800230:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800234:	8b 10                	mov    (%eax),%edx
  800236:	3b 50 04             	cmp    0x4(%eax),%edx
  800239:	73 0a                	jae    800245 <sprintputch+0x1b>
		*b->buf++ = ch;
  80023b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80023e:	89 08                	mov    %ecx,(%eax)
  800240:	8b 45 08             	mov    0x8(%ebp),%eax
  800243:	88 02                	mov    %al,(%edx)
}
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    

00800247 <printfmt>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80024d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800250:	50                   	push   %eax
  800251:	ff 75 10             	push   0x10(%ebp)
  800254:	ff 75 0c             	push   0xc(%ebp)
  800257:	ff 75 08             	push   0x8(%ebp)
  80025a:	e8 05 00 00 00       	call   800264 <vprintfmt>
}
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <vprintfmt>:
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 3c             	sub    $0x3c,%esp
  80026d:	8b 75 08             	mov    0x8(%ebp),%esi
  800270:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800273:	8b 7d 10             	mov    0x10(%ebp),%edi
  800276:	eb 0a                	jmp    800282 <vprintfmt+0x1e>
			putch(ch, putdat);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	53                   	push   %ebx
  80027c:	50                   	push   %eax
  80027d:	ff d6                	call   *%esi
  80027f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800282:	83 c7 01             	add    $0x1,%edi
  800285:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800289:	83 f8 25             	cmp    $0x25,%eax
  80028c:	74 0c                	je     80029a <vprintfmt+0x36>
			if (ch == '\0')
  80028e:	85 c0                	test   %eax,%eax
  800290:	75 e6                	jne    800278 <vprintfmt+0x14>
}
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    
		padc = ' ';
  80029a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002ac:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b8:	8d 47 01             	lea    0x1(%edi),%eax
  8002bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002be:	0f b6 17             	movzbl (%edi),%edx
  8002c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c4:	3c 55                	cmp    $0x55,%al
  8002c6:	0f 87 a6 04 00 00    	ja     800772 <vprintfmt+0x50e>
  8002cc:	0f b6 c0             	movzbl %al,%eax
  8002cf:	ff 24 85 a0 12 80 00 	jmp    *0x8012a0(,%eax,4)
  8002d6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002d9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002dd:	eb d9                	jmp    8002b8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002e2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002e6:	eb d0                	jmp    8002b8 <vprintfmt+0x54>
  8002e8:	0f b6 d2             	movzbl %dl,%edx
  8002eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8002f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800300:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800303:	83 f9 09             	cmp    $0x9,%ecx
  800306:	77 55                	ja     80035d <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800308:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030b:	eb e9                	jmp    8002f6 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80030d:	8b 45 14             	mov    0x14(%ebp),%eax
  800310:	8b 00                	mov    (%eax),%eax
  800312:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800315:	8b 45 14             	mov    0x14(%ebp),%eax
  800318:	8d 40 04             	lea    0x4(%eax),%eax
  80031b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800325:	79 91                	jns    8002b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80032d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800334:	eb 82                	jmp    8002b8 <vprintfmt+0x54>
  800336:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800339:	85 d2                	test   %edx,%edx
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	0f 49 c2             	cmovns %edx,%eax
  800343:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800349:	e9 6a ff ff ff       	jmp    8002b8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800351:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800358:	e9 5b ff ff ff       	jmp    8002b8 <vprintfmt+0x54>
  80035d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800363:	eb bc                	jmp    800321 <vprintfmt+0xbd>
			lflag++;
  800365:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80036b:	e9 48 ff ff ff       	jmp    8002b8 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	8d 78 04             	lea    0x4(%eax),%edi
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	53                   	push   %ebx
  80037a:	ff 30                	push   (%eax)
  80037c:	ff d6                	call   *%esi
			break;
  80037e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800381:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800384:	e9 88 03 00 00       	jmp    800711 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800389:	8b 45 14             	mov    0x14(%ebp),%eax
  80038c:	8d 78 04             	lea    0x4(%eax),%edi
  80038f:	8b 10                	mov    (%eax),%edx
  800391:	89 d0                	mov    %edx,%eax
  800393:	f7 d8                	neg    %eax
  800395:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800398:	83 f8 0f             	cmp    $0xf,%eax
  80039b:	7f 23                	jg     8003c0 <vprintfmt+0x15c>
  80039d:	8b 14 85 00 14 80 00 	mov    0x801400(,%eax,4),%edx
  8003a4:	85 d2                	test   %edx,%edx
  8003a6:	74 18                	je     8003c0 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003a8:	52                   	push   %edx
  8003a9:	68 87 11 80 00       	push   $0x801187
  8003ae:	53                   	push   %ebx
  8003af:	56                   	push   %esi
  8003b0:	e8 92 fe ff ff       	call   800247 <printfmt>
  8003b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003bb:	e9 51 03 00 00       	jmp    800711 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003c0:	50                   	push   %eax
  8003c1:	68 7e 11 80 00       	push   $0x80117e
  8003c6:	53                   	push   %ebx
  8003c7:	56                   	push   %esi
  8003c8:	e8 7a fe ff ff       	call   800247 <printfmt>
  8003cd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d3:	e9 39 03 00 00       	jmp    800711 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	83 c0 04             	add    $0x4,%eax
  8003de:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003e6:	85 d2                	test   %edx,%edx
  8003e8:	b8 77 11 80 00       	mov    $0x801177,%eax
  8003ed:	0f 45 c2             	cmovne %edx,%eax
  8003f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003f7:	7e 06                	jle    8003ff <vprintfmt+0x19b>
  8003f9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003fd:	75 0d                	jne    80040c <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800402:	89 c7                	mov    %eax,%edi
  800404:	03 45 d4             	add    -0x2c(%ebp),%eax
  800407:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80040a:	eb 55                	jmp    800461 <vprintfmt+0x1fd>
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	ff 75 e0             	push   -0x20(%ebp)
  800412:	ff 75 cc             	push   -0x34(%ebp)
  800415:	e8 f5 03 00 00       	call   80080f <strnlen>
  80041a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041d:	29 c2                	sub    %eax,%edx
  80041f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800427:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80042b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80042e:	eb 0f                	jmp    80043f <vprintfmt+0x1db>
					putch(padc, putdat);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	53                   	push   %ebx
  800434:	ff 75 d4             	push   -0x2c(%ebp)
  800437:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800439:	83 ef 01             	sub    $0x1,%edi
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	85 ff                	test   %edi,%edi
  800441:	7f ed                	jg     800430 <vprintfmt+0x1cc>
  800443:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800446:	85 d2                	test   %edx,%edx
  800448:	b8 00 00 00 00       	mov    $0x0,%eax
  80044d:	0f 49 c2             	cmovns %edx,%eax
  800450:	29 c2                	sub    %eax,%edx
  800452:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800455:	eb a8                	jmp    8003ff <vprintfmt+0x19b>
					putch(ch, putdat);
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	53                   	push   %ebx
  80045b:	52                   	push   %edx
  80045c:	ff d6                	call   *%esi
  80045e:	83 c4 10             	add    $0x10,%esp
  800461:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800464:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800466:	83 c7 01             	add    $0x1,%edi
  800469:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80046d:	0f be d0             	movsbl %al,%edx
  800470:	85 d2                	test   %edx,%edx
  800472:	74 4b                	je     8004bf <vprintfmt+0x25b>
  800474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800478:	78 06                	js     800480 <vprintfmt+0x21c>
  80047a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80047e:	78 1e                	js     80049e <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800480:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800484:	74 d1                	je     800457 <vprintfmt+0x1f3>
  800486:	0f be c0             	movsbl %al,%eax
  800489:	83 e8 20             	sub    $0x20,%eax
  80048c:	83 f8 5e             	cmp    $0x5e,%eax
  80048f:	76 c6                	jbe    800457 <vprintfmt+0x1f3>
					putch('?', putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	53                   	push   %ebx
  800495:	6a 3f                	push   $0x3f
  800497:	ff d6                	call   *%esi
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	eb c3                	jmp    800461 <vprintfmt+0x1fd>
  80049e:	89 cf                	mov    %ecx,%edi
  8004a0:	eb 0e                	jmp    8004b0 <vprintfmt+0x24c>
				putch(' ', putdat);
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	53                   	push   %ebx
  8004a6:	6a 20                	push   $0x20
  8004a8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004aa:	83 ef 01             	sub    $0x1,%edi
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	85 ff                	test   %edi,%edi
  8004b2:	7f ee                	jg     8004a2 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ba:	e9 52 02 00 00       	jmp    800711 <vprintfmt+0x4ad>
  8004bf:	89 cf                	mov    %ecx,%edi
  8004c1:	eb ed                	jmp    8004b0 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	83 c0 04             	add    $0x4,%eax
  8004c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004d1:	85 d2                	test   %edx,%edx
  8004d3:	b8 77 11 80 00       	mov    $0x801177,%eax
  8004d8:	0f 45 c2             	cmovne %edx,%eax
  8004db:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004e2:	7e 06                	jle    8004ea <vprintfmt+0x286>
  8004e4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004e8:	75 0d                	jne    8004f7 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ed:	89 c7                	mov    %eax,%edi
  8004ef:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004f5:	eb 55                	jmp    80054c <vprintfmt+0x2e8>
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 e0             	push   -0x20(%ebp)
  8004fd:	ff 75 cc             	push   -0x34(%ebp)
  800500:	e8 0a 03 00 00       	call   80080f <strnlen>
  800505:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800508:	29 c2                	sub    %eax,%edx
  80050a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800512:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800516:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800519:	eb 0f                	jmp    80052a <vprintfmt+0x2c6>
					putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 75 d4             	push   -0x2c(%ebp)
  800522:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	83 ef 01             	sub    $0x1,%edi
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 ff                	test   %edi,%edi
  80052c:	7f ed                	jg     80051b <vprintfmt+0x2b7>
  80052e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800531:	85 d2                	test   %edx,%edx
  800533:	b8 00 00 00 00       	mov    $0x0,%eax
  800538:	0f 49 c2             	cmovns %edx,%eax
  80053b:	29 c2                	sub    %eax,%edx
  80053d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800540:	eb a8                	jmp    8004ea <vprintfmt+0x286>
					putch(ch, putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	52                   	push   %edx
  800547:	ff d6                	call   *%esi
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800551:	83 c7 01             	add    $0x1,%edi
  800554:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800558:	0f be d0             	movsbl %al,%edx
  80055b:	3c 3a                	cmp    $0x3a,%al
  80055d:	74 4b                	je     8005aa <vprintfmt+0x346>
  80055f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800563:	78 06                	js     80056b <vprintfmt+0x307>
  800565:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800569:	78 1e                	js     800589 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80056b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056f:	74 d1                	je     800542 <vprintfmt+0x2de>
  800571:	0f be c0             	movsbl %al,%eax
  800574:	83 e8 20             	sub    $0x20,%eax
  800577:	83 f8 5e             	cmp    $0x5e,%eax
  80057a:	76 c6                	jbe    800542 <vprintfmt+0x2de>
					putch('?', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 3f                	push   $0x3f
  800582:	ff d6                	call   *%esi
  800584:	83 c4 10             	add    $0x10,%esp
  800587:	eb c3                	jmp    80054c <vprintfmt+0x2e8>
  800589:	89 cf                	mov    %ecx,%edi
  80058b:	eb 0e                	jmp    80059b <vprintfmt+0x337>
				putch(' ', putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	53                   	push   %ebx
  800591:	6a 20                	push   $0x20
  800593:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800595:	83 ef 01             	sub    $0x1,%edi
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	85 ff                	test   %edi,%edi
  80059d:	7f ee                	jg     80058d <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80059f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a5:	e9 67 01 00 00       	jmp    800711 <vprintfmt+0x4ad>
  8005aa:	89 cf                	mov    %ecx,%edi
  8005ac:	eb ed                	jmp    80059b <vprintfmt+0x337>
	if (lflag >= 2)
  8005ae:	83 f9 01             	cmp    $0x1,%ecx
  8005b1:	7f 1b                	jg     8005ce <vprintfmt+0x36a>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	74 63                	je     80061a <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bf:	99                   	cltd   
  8005c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cc:	eb 17                	jmp    8005e5 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 50 04             	mov    0x4(%eax),%edx
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 40 08             	lea    0x8(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8005eb:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005f0:	85 c9                	test   %ecx,%ecx
  8005f2:	0f 89 ff 00 00 00    	jns    8006f7 <vprintfmt+0x493>
				putch('-', putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	6a 2d                	push   $0x2d
  8005fe:	ff d6                	call   *%esi
				num = -(long long) num;
  800600:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800603:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800606:	f7 da                	neg    %edx
  800608:	83 d1 00             	adc    $0x0,%ecx
  80060b:	f7 d9                	neg    %ecx
  80060d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800610:	bf 0a 00 00 00       	mov    $0xa,%edi
  800615:	e9 dd 00 00 00       	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, int);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800622:	99                   	cltd   
  800623:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	eb b4                	jmp    8005e5 <vprintfmt+0x381>
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1e                	jg     800654 <vprintfmt+0x3f0>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 32                	je     80066c <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80064f:	e9 a3 00 00 00       	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	8b 48 04             	mov    0x4(%eax),%ecx
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800662:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800667:	e9 8b 00 00 00       	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	b9 00 00 00 00       	mov    $0x0,%ecx
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800681:	eb 74                	jmp    8006f7 <vprintfmt+0x493>
	if (lflag >= 2)
  800683:	83 f9 01             	cmp    $0x1,%ecx
  800686:	7f 1b                	jg     8006a3 <vprintfmt+0x43f>
	else if (lflag)
  800688:	85 c9                	test   %ecx,%ecx
  80068a:	74 2c                	je     8006b8 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 10                	mov    (%eax),%edx
  800691:	b9 00 00 00 00       	mov    $0x0,%ecx
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006a1:	eb 54                	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 10                	mov    (%eax),%edx
  8006a8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ab:	8d 40 08             	lea    0x8(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b1:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006b6:	eb 3f                	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 10                	mov    (%eax),%edx
  8006bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c8:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006cd:	eb 28                	jmp    8006f7 <vprintfmt+0x493>
			putch('0', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	6a 30                	push   $0x30
  8006d5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d7:	83 c4 08             	add    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	6a 78                	push   $0x78
  8006dd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 10                	mov    (%eax),%edx
  8006e4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ec:	8d 40 04             	lea    0x4(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f2:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8006f7:	83 ec 0c             	sub    $0xc,%esp
  8006fa:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	ff 75 d4             	push   -0x2c(%ebp)
  800702:	57                   	push   %edi
  800703:	51                   	push   %ecx
  800704:	52                   	push   %edx
  800705:	89 da                	mov    %ebx,%edx
  800707:	89 f0                	mov    %esi,%eax
  800709:	e8 73 fa ff ff       	call   800181 <printnum>
			break;
  80070e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800711:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800714:	e9 69 fb ff ff       	jmp    800282 <vprintfmt+0x1e>
	if (lflag >= 2)
  800719:	83 f9 01             	cmp    $0x1,%ecx
  80071c:	7f 1b                	jg     800739 <vprintfmt+0x4d5>
	else if (lflag)
  80071e:	85 c9                	test   %ecx,%ecx
  800720:	74 2c                	je     80074e <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 10                	mov    (%eax),%edx
  800727:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800737:	eb be                	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 10                	mov    (%eax),%edx
  80073e:	8b 48 04             	mov    0x4(%eax),%ecx
  800741:	8d 40 08             	lea    0x8(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800747:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80074c:	eb a9                	jmp    8006f7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 10                	mov    (%eax),%edx
  800753:	b9 00 00 00 00       	mov    $0x0,%ecx
  800758:	8d 40 04             	lea    0x4(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075e:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800763:	eb 92                	jmp    8006f7 <vprintfmt+0x493>
			putch(ch, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 25                	push   $0x25
  80076b:	ff d6                	call   *%esi
			break;
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	eb 9f                	jmp    800711 <vprintfmt+0x4ad>
			putch('%', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	53                   	push   %ebx
  800776:	6a 25                	push   $0x25
  800778:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	89 f8                	mov    %edi,%eax
  80077f:	eb 03                	jmp    800784 <vprintfmt+0x520>
  800781:	83 e8 01             	sub    $0x1,%eax
  800784:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800788:	75 f7                	jne    800781 <vprintfmt+0x51d>
  80078a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80078d:	eb 82                	jmp    800711 <vprintfmt+0x4ad>

0080078f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 26                	je     8007d6 <vsnprintf+0x47>
  8007b0:	85 d2                	test   %edx,%edx
  8007b2:	7e 22                	jle    8007d6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b4:	ff 75 14             	push   0x14(%ebp)
  8007b7:	ff 75 10             	push   0x10(%ebp)
  8007ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	68 2a 02 80 00       	push   $0x80022a
  8007c3:	e8 9c fa ff ff       	call   800264 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    
		return -E_INVAL;
  8007d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007db:	eb f7                	jmp    8007d4 <vsnprintf+0x45>

008007dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 10             	push   0x10(%ebp)
  8007ea:	ff 75 0c             	push   0xc(%ebp)
  8007ed:	ff 75 08             	push   0x8(%ebp)
  8007f0:	e8 9a ff ff ff       	call   80078f <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    

008007f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800802:	eb 03                	jmp    800807 <strlen+0x10>
		n++;
  800804:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800807:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80080b:	75 f7                	jne    800804 <strlen+0xd>
	return n;
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800815:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800818:	b8 00 00 00 00       	mov    $0x0,%eax
  80081d:	eb 03                	jmp    800822 <strnlen+0x13>
		n++;
  80081f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800822:	39 d0                	cmp    %edx,%eax
  800824:	74 08                	je     80082e <strnlen+0x1f>
  800826:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082a:	75 f3                	jne    80081f <strnlen+0x10>
  80082c:	89 c2                	mov    %eax,%edx
	return n;
}
  80082e:	89 d0                	mov    %edx,%eax
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	53                   	push   %ebx
  800836:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800839:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800845:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800848:	83 c0 01             	add    $0x1,%eax
  80084b:	84 d2                	test   %dl,%dl
  80084d:	75 f2                	jne    800841 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80084f:	89 c8                	mov    %ecx,%eax
  800851:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	53                   	push   %ebx
  80085a:	83 ec 10             	sub    $0x10,%esp
  80085d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800860:	53                   	push   %ebx
  800861:	e8 91 ff ff ff       	call   8007f7 <strlen>
  800866:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800869:	ff 75 0c             	push   0xc(%ebp)
  80086c:	01 d8                	add    %ebx,%eax
  80086e:	50                   	push   %eax
  80086f:	e8 be ff ff ff       	call   800832 <strcpy>
	return dst;
}
  800874:	89 d8                	mov    %ebx,%eax
  800876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800879:	c9                   	leave  
  80087a:	c3                   	ret    

0080087b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	89 f3                	mov    %esi,%ebx
  800888:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088b:	89 f0                	mov    %esi,%eax
  80088d:	eb 0f                	jmp    80089e <strncpy+0x23>
		*dst++ = *src;
  80088f:	83 c0 01             	add    $0x1,%eax
  800892:	0f b6 0a             	movzbl (%edx),%ecx
  800895:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800898:	80 f9 01             	cmp    $0x1,%cl
  80089b:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80089e:	39 d8                	cmp    %ebx,%eax
  8008a0:	75 ed                	jne    80088f <strncpy+0x14>
	}
	return ret;
}
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	5b                   	pop    %ebx
  8008a5:	5e                   	pop    %esi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	56                   	push   %esi
  8008ac:	53                   	push   %ebx
  8008ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8008b6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b8:	85 d2                	test   %edx,%edx
  8008ba:	74 21                	je     8008dd <strlcpy+0x35>
  8008bc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c0:	89 f2                	mov    %esi,%edx
  8008c2:	eb 09                	jmp    8008cd <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008c4:	83 c1 01             	add    $0x1,%ecx
  8008c7:	83 c2 01             	add    $0x1,%edx
  8008ca:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008cd:	39 c2                	cmp    %eax,%edx
  8008cf:	74 09                	je     8008da <strlcpy+0x32>
  8008d1:	0f b6 19             	movzbl (%ecx),%ebx
  8008d4:	84 db                	test   %bl,%bl
  8008d6:	75 ec                	jne    8008c4 <strlcpy+0x1c>
  8008d8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008dd:	29 f0                	sub    %esi,%eax
}
  8008df:	5b                   	pop    %ebx
  8008e0:	5e                   	pop    %esi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ec:	eb 06                	jmp    8008f4 <strcmp+0x11>
		p++, q++;
  8008ee:	83 c1 01             	add    $0x1,%ecx
  8008f1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008f4:	0f b6 01             	movzbl (%ecx),%eax
  8008f7:	84 c0                	test   %al,%al
  8008f9:	74 04                	je     8008ff <strcmp+0x1c>
  8008fb:	3a 02                	cmp    (%edx),%al
  8008fd:	74 ef                	je     8008ee <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ff:	0f b6 c0             	movzbl %al,%eax
  800902:	0f b6 12             	movzbl (%edx),%edx
  800905:	29 d0                	sub    %edx,%eax
}
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 55 0c             	mov    0xc(%ebp),%edx
  800913:	89 c3                	mov    %eax,%ebx
  800915:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800918:	eb 06                	jmp    800920 <strncmp+0x17>
		n--, p++, q++;
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800920:	39 d8                	cmp    %ebx,%eax
  800922:	74 18                	je     80093c <strncmp+0x33>
  800924:	0f b6 08             	movzbl (%eax),%ecx
  800927:	84 c9                	test   %cl,%cl
  800929:	74 04                	je     80092f <strncmp+0x26>
  80092b:	3a 0a                	cmp    (%edx),%cl
  80092d:	74 eb                	je     80091a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80092f:	0f b6 00             	movzbl (%eax),%eax
  800932:	0f b6 12             	movzbl (%edx),%edx
  800935:	29 d0                	sub    %edx,%eax
}
  800937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    
		return 0;
  80093c:	b8 00 00 00 00       	mov    $0x0,%eax
  800941:	eb f4                	jmp    800937 <strncmp+0x2e>

00800943 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094d:	eb 03                	jmp    800952 <strchr+0xf>
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	0f b6 10             	movzbl (%eax),%edx
  800955:	84 d2                	test   %dl,%dl
  800957:	74 06                	je     80095f <strchr+0x1c>
		if (*s == c)
  800959:	38 ca                	cmp    %cl,%dl
  80095b:	75 f2                	jne    80094f <strchr+0xc>
  80095d:	eb 05                	jmp    800964 <strchr+0x21>
			return (char *) s;
	return 0;
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800970:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800973:	38 ca                	cmp    %cl,%dl
  800975:	74 09                	je     800980 <strfind+0x1a>
  800977:	84 d2                	test   %dl,%dl
  800979:	74 05                	je     800980 <strfind+0x1a>
	for (; *s; s++)
  80097b:	83 c0 01             	add    $0x1,%eax
  80097e:	eb f0                	jmp    800970 <strfind+0xa>
			break;
	return (char *) s;
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	57                   	push   %edi
  800986:	56                   	push   %esi
  800987:	53                   	push   %ebx
  800988:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80098e:	85 c9                	test   %ecx,%ecx
  800990:	74 2f                	je     8009c1 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800992:	89 f8                	mov    %edi,%eax
  800994:	09 c8                	or     %ecx,%eax
  800996:	a8 03                	test   $0x3,%al
  800998:	75 21                	jne    8009bb <memset+0x39>
		c &= 0xFF;
  80099a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099e:	89 d0                	mov    %edx,%eax
  8009a0:	c1 e0 08             	shl    $0x8,%eax
  8009a3:	89 d3                	mov    %edx,%ebx
  8009a5:	c1 e3 18             	shl    $0x18,%ebx
  8009a8:	89 d6                	mov    %edx,%esi
  8009aa:	c1 e6 10             	shl    $0x10,%esi
  8009ad:	09 f3                	or     %esi,%ebx
  8009af:	09 da                	or     %ebx,%edx
  8009b1:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009b3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b6:	fc                   	cld    
  8009b7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b9:	eb 06                	jmp    8009c1 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	fc                   	cld    
  8009bf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c1:	89 f8                	mov    %edi,%eax
  8009c3:	5b                   	pop    %ebx
  8009c4:	5e                   	pop    %esi
  8009c5:	5f                   	pop    %edi
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	57                   	push   %edi
  8009cc:	56                   	push   %esi
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d6:	39 c6                	cmp    %eax,%esi
  8009d8:	73 32                	jae    800a0c <memmove+0x44>
  8009da:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	76 2b                	jbe    800a0c <memmove+0x44>
		s += n;
		d += n;
  8009e1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	89 d6                	mov    %edx,%esi
  8009e6:	09 fe                	or     %edi,%esi
  8009e8:	09 ce                	or     %ecx,%esi
  8009ea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f0:	75 0e                	jne    800a00 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f2:	83 ef 04             	sub    $0x4,%edi
  8009f5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009fb:	fd                   	std    
  8009fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fe:	eb 09                	jmp    800a09 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a00:	83 ef 01             	sub    $0x1,%edi
  800a03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a06:	fd                   	std    
  800a07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a09:	fc                   	cld    
  800a0a:	eb 1a                	jmp    800a26 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0c:	89 f2                	mov    %esi,%edx
  800a0e:	09 c2                	or     %eax,%edx
  800a10:	09 ca                	or     %ecx,%edx
  800a12:	f6 c2 03             	test   $0x3,%dl
  800a15:	75 0a                	jne    800a21 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a1a:	89 c7                	mov    %eax,%edi
  800a1c:	fc                   	cld    
  800a1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1f:	eb 05                	jmp    800a26 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a21:	89 c7                	mov    %eax,%edi
  800a23:	fc                   	cld    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a26:	5e                   	pop    %esi
  800a27:	5f                   	pop    %edi
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a30:	ff 75 10             	push   0x10(%ebp)
  800a33:	ff 75 0c             	push   0xc(%ebp)
  800a36:	ff 75 08             	push   0x8(%ebp)
  800a39:	e8 8a ff ff ff       	call   8009c8 <memmove>
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4b:	89 c6                	mov    %eax,%esi
  800a4d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a50:	eb 06                	jmp    800a58 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a52:	83 c0 01             	add    $0x1,%eax
  800a55:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a58:	39 f0                	cmp    %esi,%eax
  800a5a:	74 14                	je     800a70 <memcmp+0x30>
		if (*s1 != *s2)
  800a5c:	0f b6 08             	movzbl (%eax),%ecx
  800a5f:	0f b6 1a             	movzbl (%edx),%ebx
  800a62:	38 d9                	cmp    %bl,%cl
  800a64:	74 ec                	je     800a52 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a66:	0f b6 c1             	movzbl %cl,%eax
  800a69:	0f b6 db             	movzbl %bl,%ebx
  800a6c:	29 d8                	sub    %ebx,%eax
  800a6e:	eb 05                	jmp    800a75 <memcmp+0x35>
	}

	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a82:	89 c2                	mov    %eax,%edx
  800a84:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a87:	eb 03                	jmp    800a8c <memfind+0x13>
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	39 d0                	cmp    %edx,%eax
  800a8e:	73 04                	jae    800a94 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a90:	38 08                	cmp    %cl,(%eax)
  800a92:	75 f5                	jne    800a89 <memfind+0x10>
			break;
	return (void *) s;
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa2:	eb 03                	jmp    800aa7 <strtol+0x11>
		s++;
  800aa4:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800aa7:	0f b6 02             	movzbl (%edx),%eax
  800aaa:	3c 20                	cmp    $0x20,%al
  800aac:	74 f6                	je     800aa4 <strtol+0xe>
  800aae:	3c 09                	cmp    $0x9,%al
  800ab0:	74 f2                	je     800aa4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ab2:	3c 2b                	cmp    $0x2b,%al
  800ab4:	74 2a                	je     800ae0 <strtol+0x4a>
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abb:	3c 2d                	cmp    $0x2d,%al
  800abd:	74 2b                	je     800aea <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac5:	75 0f                	jne    800ad6 <strtol+0x40>
  800ac7:	80 3a 30             	cmpb   $0x30,(%edx)
  800aca:	74 28                	je     800af4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad3:	0f 44 d8             	cmove  %eax,%ebx
  800ad6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800adb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ade:	eb 46                	jmp    800b26 <strtol+0x90>
		s++;
  800ae0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae8:	eb d5                	jmp    800abf <strtol+0x29>
		s++, neg = 1;
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	bf 01 00 00 00       	mov    $0x1,%edi
  800af2:	eb cb                	jmp    800abf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800af8:	74 0e                	je     800b08 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	75 d8                	jne    800ad6 <strtol+0x40>
		s++, base = 8;
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b06:	eb ce                	jmp    800ad6 <strtol+0x40>
		s += 2, base = 16;
  800b08:	83 c2 02             	add    $0x2,%edx
  800b0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b10:	eb c4                	jmp    800ad6 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b12:	0f be c0             	movsbl %al,%eax
  800b15:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b1b:	7d 3a                	jge    800b57 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b1d:	83 c2 01             	add    $0x1,%edx
  800b20:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b24:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b26:	0f b6 02             	movzbl (%edx),%eax
  800b29:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 09             	cmp    $0x9,%bl
  800b31:	76 df                	jbe    800b12 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b33:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 08                	ja     800b45 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b3d:	0f be c0             	movsbl %al,%eax
  800b40:	83 e8 57             	sub    $0x57,%eax
  800b43:	eb d3                	jmp    800b18 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 08                	ja     800b57 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b4f:	0f be c0             	movsbl %al,%eax
  800b52:	83 e8 37             	sub    $0x37,%eax
  800b55:	eb c1                	jmp    800b18 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xcc>
		*endptr = (char *) s;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b62:	89 c8                	mov    %ecx,%eax
  800b64:	f7 d8                	neg    %eax
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c8             	cmovne %eax,%ecx
}
  800b6b:	89 c8                	mov    %ecx,%eax
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b83:	89 c3                	mov    %eax,%ebx
  800b85:	89 c7                	mov    %eax,%edi
  800b87:	89 c6                	mov    %eax,%esi
  800b89:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b96:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9b:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba0:	89 d1                	mov    %edx,%ecx
  800ba2:	89 d3                	mov    %edx,%ebx
  800ba4:	89 d7                	mov    %edx,%edi
  800ba6:	89 d6                	mov    %edx,%esi
  800ba8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc5:	89 cb                	mov    %ecx,%ebx
  800bc7:	89 cf                	mov    %ecx,%edi
  800bc9:	89 ce                	mov    %ecx,%esi
  800bcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcd:	85 c0                	test   %eax,%eax
  800bcf:	7f 08                	jg     800bd9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd9:	83 ec 0c             	sub    $0xc,%esp
  800bdc:	50                   	push   %eax
  800bdd:	6a 03                	push   $0x3
  800bdf:	68 5f 14 80 00       	push   $0x80145f
  800be4:	6a 23                	push   $0x23
  800be6:	68 7c 14 80 00       	push   $0x80147c
  800beb:	e8 c2 02 00 00       	call   800eb2 <_panic>

00800bf0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfb:	b8 02 00 00 00       	mov    $0x2,%eax
  800c00:	89 d1                	mov    %edx,%ecx
  800c02:	89 d3                	mov    %edx,%ebx
  800c04:	89 d7                	mov    %edx,%edi
  800c06:	89 d6                	mov    %edx,%esi
  800c08:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5f                   	pop    %edi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <sys_yield>:

void
sys_yield(void)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c1f:	89 d1                	mov    %edx,%ecx
  800c21:	89 d3                	mov    %edx,%ebx
  800c23:	89 d7                	mov    %edx,%edi
  800c25:	89 d6                	mov    %edx,%esi
  800c27:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c37:	be 00 00 00 00       	mov    $0x0,%esi
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	b8 04 00 00 00       	mov    $0x4,%eax
  800c47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4a:	89 f7                	mov    %esi,%edi
  800c4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	7f 08                	jg     800c5a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	50                   	push   %eax
  800c5e:	6a 04                	push   $0x4
  800c60:	68 5f 14 80 00       	push   $0x80145f
  800c65:	6a 23                	push   $0x23
  800c67:	68 7c 14 80 00       	push   $0x80147c
  800c6c:	e8 41 02 00 00       	call   800eb2 <_panic>

00800c71 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	b8 05 00 00 00       	mov    $0x5,%eax
  800c85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c8b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 05                	push   $0x5
  800ca2:	68 5f 14 80 00       	push   $0x80145f
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 7c 14 80 00       	push   $0x80147c
  800cae:	e8 ff 01 00 00       	call   800eb2 <_panic>

00800cb3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	b8 06 00 00 00       	mov    $0x6,%eax
  800ccc:	89 df                	mov    %ebx,%edi
  800cce:	89 de                	mov    %ebx,%esi
  800cd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	7f 08                	jg     800cde <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cde:	83 ec 0c             	sub    $0xc,%esp
  800ce1:	50                   	push   %eax
  800ce2:	6a 06                	push   $0x6
  800ce4:	68 5f 14 80 00       	push   $0x80145f
  800ce9:	6a 23                	push   $0x23
  800ceb:	68 7c 14 80 00       	push   $0x80147c
  800cf0:	e8 bd 01 00 00       	call   800eb2 <_panic>

00800cf5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0e:	89 df                	mov    %ebx,%edi
  800d10:	89 de                	mov    %ebx,%esi
  800d12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d14:	85 c0                	test   %eax,%eax
  800d16:	7f 08                	jg     800d20 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	50                   	push   %eax
  800d24:	6a 08                	push   $0x8
  800d26:	68 5f 14 80 00       	push   $0x80145f
  800d2b:	6a 23                	push   $0x23
  800d2d:	68 7c 14 80 00       	push   $0x80147c
  800d32:	e8 7b 01 00 00       	call   800eb2 <_panic>

00800d37 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d50:	89 df                	mov    %ebx,%edi
  800d52:	89 de                	mov    %ebx,%esi
  800d54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7f 08                	jg     800d62 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	50                   	push   %eax
  800d66:	6a 09                	push   $0x9
  800d68:	68 5f 14 80 00       	push   $0x80145f
  800d6d:	6a 23                	push   $0x23
  800d6f:	68 7c 14 80 00       	push   $0x80147c
  800d74:	e8 39 01 00 00       	call   800eb2 <_panic>

00800d79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d92:	89 df                	mov    %ebx,%edi
  800d94:	89 de                	mov    %ebx,%esi
  800d96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	7f 08                	jg     800da4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	50                   	push   %eax
  800da8:	6a 0a                	push   $0xa
  800daa:	68 5f 14 80 00       	push   $0x80145f
  800daf:	6a 23                	push   $0x23
  800db1:	68 7c 14 80 00       	push   $0x80147c
  800db6:	e8 f7 00 00 00       	call   800eb2 <_panic>

00800dbb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df4:	89 cb                	mov    %ecx,%ebx
  800df6:	89 cf                	mov    %ecx,%edi
  800df8:	89 ce                	mov    %ecx,%esi
  800dfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7f 08                	jg     800e08 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5f                   	pop    %edi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e08:	83 ec 0c             	sub    $0xc,%esp
  800e0b:	50                   	push   %eax
  800e0c:	6a 0d                	push   $0xd
  800e0e:	68 5f 14 80 00       	push   $0x80145f
  800e13:	6a 23                	push   $0x23
  800e15:	68 7c 14 80 00       	push   $0x80147c
  800e1a:	e8 93 00 00 00       	call   800eb2 <_panic>

00800e1f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e25:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800e2c:	74 20                	je     800e4e <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	68 8e 0e 80 00       	push   $0x800e8e
  800e3e:	6a 00                	push   $0x0
  800e40:	e8 34 ff ff ff       	call   800d79 <sys_env_set_pgfault_upcall>
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	78 2e                	js     800e7a <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	6a 07                	push   $0x7
  800e53:	68 00 f0 bf ee       	push   $0xeebff000
  800e58:	6a 00                	push   $0x0
  800e5a:	e8 cf fd ff ff       	call   800c2e <sys_page_alloc>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	85 c0                	test   %eax,%eax
  800e64:	79 c8                	jns    800e2e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  800e66:	83 ec 04             	sub    $0x4,%esp
  800e69:	68 8c 14 80 00       	push   $0x80148c
  800e6e:	6a 21                	push   $0x21
  800e70:	68 ef 14 80 00       	push   $0x8014ef
  800e75:	e8 38 00 00 00       	call   800eb2 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 b8 14 80 00       	push   $0x8014b8
  800e82:	6a 27                	push   $0x27
  800e84:	68 ef 14 80 00       	push   $0x8014ef
  800e89:	e8 24 00 00 00       	call   800eb2 <_panic>

00800e8e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e8e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e8f:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800e94:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e96:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  800e99:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  800e9d:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  800ea2:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  800ea6:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  800ea8:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800eab:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800eac:	83 c4 04             	add    $0x4,%esp
	popfl
  800eaf:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800eb0:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800eb1:	c3                   	ret    

00800eb2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800eb7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800eba:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ec0:	e8 2b fd ff ff       	call   800bf0 <sys_getenvid>
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	ff 75 0c             	push   0xc(%ebp)
  800ecb:	ff 75 08             	push   0x8(%ebp)
  800ece:	56                   	push   %esi
  800ecf:	50                   	push   %eax
  800ed0:	68 00 15 80 00       	push   $0x801500
  800ed5:	e8 93 f2 ff ff       	call   80016d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800eda:	83 c4 18             	add    $0x18,%esp
  800edd:	53                   	push   %ebx
  800ede:	ff 75 10             	push   0x10(%ebp)
  800ee1:	e8 36 f2 ff ff       	call   80011c <vcprintf>
	cprintf("\n");
  800ee6:	c7 04 24 5a 11 80 00 	movl   $0x80115a,(%esp)
  800eed:	e8 7b f2 ff ff       	call   80016d <cprintf>
  800ef2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ef5:	cc                   	int3   
  800ef6:	eb fd                	jmp    800ef5 <_panic+0x43>
  800ef8:	66 90                	xchg   %ax,%ax
  800efa:	66 90                	xchg   %ax,%ax
  800efc:	66 90                	xchg   %ax,%ax
  800efe:	66 90                	xchg   %ax,%ax

00800f00 <__udivdi3>:
  800f00:	f3 0f 1e fb          	endbr32 
  800f04:	55                   	push   %ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 1c             	sub    $0x1c,%esp
  800f0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f13:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	75 19                	jne    800f38 <__udivdi3+0x38>
  800f1f:	39 f3                	cmp    %esi,%ebx
  800f21:	76 4d                	jbe    800f70 <__udivdi3+0x70>
  800f23:	31 ff                	xor    %edi,%edi
  800f25:	89 e8                	mov    %ebp,%eax
  800f27:	89 f2                	mov    %esi,%edx
  800f29:	f7 f3                	div    %ebx
  800f2b:	89 fa                	mov    %edi,%edx
  800f2d:	83 c4 1c             	add    $0x1c,%esp
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    
  800f35:	8d 76 00             	lea    0x0(%esi),%esi
  800f38:	39 f0                	cmp    %esi,%eax
  800f3a:	76 14                	jbe    800f50 <__udivdi3+0x50>
  800f3c:	31 ff                	xor    %edi,%edi
  800f3e:	31 c0                	xor    %eax,%eax
  800f40:	89 fa                	mov    %edi,%edx
  800f42:	83 c4 1c             	add    $0x1c,%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    
  800f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f50:	0f bd f8             	bsr    %eax,%edi
  800f53:	83 f7 1f             	xor    $0x1f,%edi
  800f56:	75 48                	jne    800fa0 <__udivdi3+0xa0>
  800f58:	39 f0                	cmp    %esi,%eax
  800f5a:	72 06                	jb     800f62 <__udivdi3+0x62>
  800f5c:	31 c0                	xor    %eax,%eax
  800f5e:	39 eb                	cmp    %ebp,%ebx
  800f60:	77 de                	ja     800f40 <__udivdi3+0x40>
  800f62:	b8 01 00 00 00       	mov    $0x1,%eax
  800f67:	eb d7                	jmp    800f40 <__udivdi3+0x40>
  800f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f70:	89 d9                	mov    %ebx,%ecx
  800f72:	85 db                	test   %ebx,%ebx
  800f74:	75 0b                	jne    800f81 <__udivdi3+0x81>
  800f76:	b8 01 00 00 00       	mov    $0x1,%eax
  800f7b:	31 d2                	xor    %edx,%edx
  800f7d:	f7 f3                	div    %ebx
  800f7f:	89 c1                	mov    %eax,%ecx
  800f81:	31 d2                	xor    %edx,%edx
  800f83:	89 f0                	mov    %esi,%eax
  800f85:	f7 f1                	div    %ecx
  800f87:	89 c6                	mov    %eax,%esi
  800f89:	89 e8                	mov    %ebp,%eax
  800f8b:	89 f7                	mov    %esi,%edi
  800f8d:	f7 f1                	div    %ecx
  800f8f:	89 fa                	mov    %edi,%edx
  800f91:	83 c4 1c             	add    $0x1c,%esp
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    
  800f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa0:	89 f9                	mov    %edi,%ecx
  800fa2:	ba 20 00 00 00       	mov    $0x20,%edx
  800fa7:	29 fa                	sub    %edi,%edx
  800fa9:	d3 e0                	shl    %cl,%eax
  800fab:	89 44 24 08          	mov    %eax,0x8(%esp)
  800faf:	89 d1                	mov    %edx,%ecx
  800fb1:	89 d8                	mov    %ebx,%eax
  800fb3:	d3 e8                	shr    %cl,%eax
  800fb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fb9:	09 c1                	or     %eax,%ecx
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fc1:	89 f9                	mov    %edi,%ecx
  800fc3:	d3 e3                	shl    %cl,%ebx
  800fc5:	89 d1                	mov    %edx,%ecx
  800fc7:	d3 e8                	shr    %cl,%eax
  800fc9:	89 f9                	mov    %edi,%ecx
  800fcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fcf:	89 eb                	mov    %ebp,%ebx
  800fd1:	d3 e6                	shl    %cl,%esi
  800fd3:	89 d1                	mov    %edx,%ecx
  800fd5:	d3 eb                	shr    %cl,%ebx
  800fd7:	09 f3                	or     %esi,%ebx
  800fd9:	89 c6                	mov    %eax,%esi
  800fdb:	89 f2                	mov    %esi,%edx
  800fdd:	89 d8                	mov    %ebx,%eax
  800fdf:	f7 74 24 08          	divl   0x8(%esp)
  800fe3:	89 d6                	mov    %edx,%esi
  800fe5:	89 c3                	mov    %eax,%ebx
  800fe7:	f7 64 24 0c          	mull   0xc(%esp)
  800feb:	39 d6                	cmp    %edx,%esi
  800fed:	72 19                	jb     801008 <__udivdi3+0x108>
  800fef:	89 f9                	mov    %edi,%ecx
  800ff1:	d3 e5                	shl    %cl,%ebp
  800ff3:	39 c5                	cmp    %eax,%ebp
  800ff5:	73 04                	jae    800ffb <__udivdi3+0xfb>
  800ff7:	39 d6                	cmp    %edx,%esi
  800ff9:	74 0d                	je     801008 <__udivdi3+0x108>
  800ffb:	89 d8                	mov    %ebx,%eax
  800ffd:	31 ff                	xor    %edi,%edi
  800fff:	e9 3c ff ff ff       	jmp    800f40 <__udivdi3+0x40>
  801004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801008:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80100b:	31 ff                	xor    %edi,%edi
  80100d:	e9 2e ff ff ff       	jmp    800f40 <__udivdi3+0x40>
  801012:	66 90                	xchg   %ax,%ax
  801014:	66 90                	xchg   %ax,%ax
  801016:	66 90                	xchg   %ax,%ax
  801018:	66 90                	xchg   %ax,%ax
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <__umoddi3>:
  801020:	f3 0f 1e fb          	endbr32 
  801024:	55                   	push   %ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	83 ec 1c             	sub    $0x1c,%esp
  80102b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80102f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801033:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801037:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80103b:	89 f0                	mov    %esi,%eax
  80103d:	89 da                	mov    %ebx,%edx
  80103f:	85 ff                	test   %edi,%edi
  801041:	75 15                	jne    801058 <__umoddi3+0x38>
  801043:	39 dd                	cmp    %ebx,%ebp
  801045:	76 39                	jbe    801080 <__umoddi3+0x60>
  801047:	f7 f5                	div    %ebp
  801049:	89 d0                	mov    %edx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	83 c4 1c             	add    $0x1c,%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    
  801055:	8d 76 00             	lea    0x0(%esi),%esi
  801058:	39 df                	cmp    %ebx,%edi
  80105a:	77 f1                	ja     80104d <__umoddi3+0x2d>
  80105c:	0f bd cf             	bsr    %edi,%ecx
  80105f:	83 f1 1f             	xor    $0x1f,%ecx
  801062:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801066:	75 40                	jne    8010a8 <__umoddi3+0x88>
  801068:	39 df                	cmp    %ebx,%edi
  80106a:	72 04                	jb     801070 <__umoddi3+0x50>
  80106c:	39 f5                	cmp    %esi,%ebp
  80106e:	77 dd                	ja     80104d <__umoddi3+0x2d>
  801070:	89 da                	mov    %ebx,%edx
  801072:	89 f0                	mov    %esi,%eax
  801074:	29 e8                	sub    %ebp,%eax
  801076:	19 fa                	sbb    %edi,%edx
  801078:	eb d3                	jmp    80104d <__umoddi3+0x2d>
  80107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801080:	89 e9                	mov    %ebp,%ecx
  801082:	85 ed                	test   %ebp,%ebp
  801084:	75 0b                	jne    801091 <__umoddi3+0x71>
  801086:	b8 01 00 00 00       	mov    $0x1,%eax
  80108b:	31 d2                	xor    %edx,%edx
  80108d:	f7 f5                	div    %ebp
  80108f:	89 c1                	mov    %eax,%ecx
  801091:	89 d8                	mov    %ebx,%eax
  801093:	31 d2                	xor    %edx,%edx
  801095:	f7 f1                	div    %ecx
  801097:	89 f0                	mov    %esi,%eax
  801099:	f7 f1                	div    %ecx
  80109b:	89 d0                	mov    %edx,%eax
  80109d:	31 d2                	xor    %edx,%edx
  80109f:	eb ac                	jmp    80104d <__umoddi3+0x2d>
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010ac:	ba 20 00 00 00       	mov    $0x20,%edx
  8010b1:	29 c2                	sub    %eax,%edx
  8010b3:	89 c1                	mov    %eax,%ecx
  8010b5:	89 e8                	mov    %ebp,%eax
  8010b7:	d3 e7                	shl    %cl,%edi
  8010b9:	89 d1                	mov    %edx,%ecx
  8010bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010bf:	d3 e8                	shr    %cl,%eax
  8010c1:	89 c1                	mov    %eax,%ecx
  8010c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010c7:	09 f9                	or     %edi,%ecx
  8010c9:	89 df                	mov    %ebx,%edi
  8010cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010cf:	89 c1                	mov    %eax,%ecx
  8010d1:	d3 e5                	shl    %cl,%ebp
  8010d3:	89 d1                	mov    %edx,%ecx
  8010d5:	d3 ef                	shr    %cl,%edi
  8010d7:	89 c1                	mov    %eax,%ecx
  8010d9:	89 f0                	mov    %esi,%eax
  8010db:	d3 e3                	shl    %cl,%ebx
  8010dd:	89 d1                	mov    %edx,%ecx
  8010df:	89 fa                	mov    %edi,%edx
  8010e1:	d3 e8                	shr    %cl,%eax
  8010e3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010e8:	09 d8                	or     %ebx,%eax
  8010ea:	f7 74 24 08          	divl   0x8(%esp)
  8010ee:	89 d3                	mov    %edx,%ebx
  8010f0:	d3 e6                	shl    %cl,%esi
  8010f2:	f7 e5                	mul    %ebp
  8010f4:	89 c7                	mov    %eax,%edi
  8010f6:	89 d1                	mov    %edx,%ecx
  8010f8:	39 d3                	cmp    %edx,%ebx
  8010fa:	72 06                	jb     801102 <__umoddi3+0xe2>
  8010fc:	75 0e                	jne    80110c <__umoddi3+0xec>
  8010fe:	39 c6                	cmp    %eax,%esi
  801100:	73 0a                	jae    80110c <__umoddi3+0xec>
  801102:	29 e8                	sub    %ebp,%eax
  801104:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801108:	89 d1                	mov    %edx,%ecx
  80110a:	89 c7                	mov    %eax,%edi
  80110c:	89 f5                	mov    %esi,%ebp
  80110e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801112:	29 fd                	sub    %edi,%ebp
  801114:	19 cb                	sbb    %ecx,%ebx
  801116:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	d3 e0                	shl    %cl,%eax
  80111f:	89 f1                	mov    %esi,%ecx
  801121:	d3 ed                	shr    %cl,%ebp
  801123:	d3 eb                	shr    %cl,%ebx
  801125:	09 e8                	or     %ebp,%eax
  801127:	89 da                	mov    %ebx,%edx
  801129:	83 c4 1c             	add    $0x1c,%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
