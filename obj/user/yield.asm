
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 20 80 00       	mov    0x802004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 c0 10 80 00       	push   $0x8010c0
  800048:	e8 3a 01 00 00       	call   800187 <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 cf 0b 00 00       	call   800c29 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 e0 10 80 00       	push   $0x8010e0
  80006c:	e8 16 01 00 00       	call   800187 <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 20 80 00       	mov    0x802004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 0c 11 80 00       	push   $0x80110c
  80008d:	e8 f5 00 00 00       	call   800187 <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 60 0b 00 00       	call   800c0a <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e6:	6a 00                	push   $0x0
  8000e8:	e8 dc 0a 00 00       	call   800bc9 <sys_env_destroy>
}
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	53                   	push   %ebx
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fc:	8b 13                	mov    (%ebx),%edx
  8000fe:	8d 42 01             	lea    0x1(%edx),%eax
  800101:	89 03                	mov    %eax,(%ebx)
  800103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800106:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80010f:	74 09                	je     80011a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800111:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800118:	c9                   	leave  
  800119:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	68 ff 00 00 00       	push   $0xff
  800122:	8d 43 08             	lea    0x8(%ebx),%eax
  800125:	50                   	push   %eax
  800126:	e8 61 0a 00 00       	call   800b8c <sys_cputs>
		b->idx = 0;
  80012b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	eb db                	jmp    800111 <putch+0x1f>

00800136 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80013f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800146:	00 00 00 
	b.cnt = 0;
  800149:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800150:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800153:	ff 75 0c             	push   0xc(%ebp)
  800156:	ff 75 08             	push   0x8(%ebp)
  800159:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	68 f2 00 80 00       	push   $0x8000f2
  800165:	e8 14 01 00 00       	call   80027e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016a:	83 c4 08             	add    $0x8,%esp
  80016d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800173:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	e8 0d 0a 00 00       	call   800b8c <sys_cputs>

	return b.cnt;
}
  80017f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800190:	50                   	push   %eax
  800191:	ff 75 08             	push   0x8(%ebp)
  800194:	e8 9d ff ff ff       	call   800136 <vcprintf>
	va_end(ap);

	return cnt;
}
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	57                   	push   %edi
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 1c             	sub    $0x1c,%esp
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	89 d6                	mov    %edx,%esi
  8001a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	89 c2                	mov    %eax,%edx
  8001b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001c8:	39 c2                	cmp    %eax,%edx
  8001ca:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001cd:	72 3e                	jb     80020d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	ff 75 18             	push   0x18(%ebp)
  8001d5:	83 eb 01             	sub    $0x1,%ebx
  8001d8:	53                   	push   %ebx
  8001d9:	50                   	push   %eax
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 e4             	push   -0x1c(%ebp)
  8001e0:	ff 75 e0             	push   -0x20(%ebp)
  8001e3:	ff 75 dc             	push   -0x24(%ebp)
  8001e6:	ff 75 d8             	push   -0x28(%ebp)
  8001e9:	e8 92 0c 00 00       	call   800e80 <__udivdi3>
  8001ee:	83 c4 18             	add    $0x18,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	89 f2                	mov    %esi,%edx
  8001f5:	89 f8                	mov    %edi,%eax
  8001f7:	e8 9f ff ff ff       	call   80019b <printnum>
  8001fc:	83 c4 20             	add    $0x20,%esp
  8001ff:	eb 13                	jmp    800214 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	56                   	push   %esi
  800205:	ff 75 18             	push   0x18(%ebp)
  800208:	ff d7                	call   *%edi
  80020a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80020d:	83 eb 01             	sub    $0x1,%ebx
  800210:	85 db                	test   %ebx,%ebx
  800212:	7f ed                	jg     800201 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	56                   	push   %esi
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	ff 75 e4             	push   -0x1c(%ebp)
  80021e:	ff 75 e0             	push   -0x20(%ebp)
  800221:	ff 75 dc             	push   -0x24(%ebp)
  800224:	ff 75 d8             	push   -0x28(%ebp)
  800227:	e8 74 0d 00 00       	call   800fa0 <__umoddi3>
  80022c:	83 c4 14             	add    $0x14,%esp
  80022f:	0f be 80 35 11 80 00 	movsbl 0x801135(%eax),%eax
  800236:	50                   	push   %eax
  800237:	ff d7                	call   *%edi
}
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80024a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024e:	8b 10                	mov    (%eax),%edx
  800250:	3b 50 04             	cmp    0x4(%eax),%edx
  800253:	73 0a                	jae    80025f <sprintputch+0x1b>
		*b->buf++ = ch;
  800255:	8d 4a 01             	lea    0x1(%edx),%ecx
  800258:	89 08                	mov    %ecx,(%eax)
  80025a:	8b 45 08             	mov    0x8(%ebp),%eax
  80025d:	88 02                	mov    %al,(%edx)
}
  80025f:	5d                   	pop    %ebp
  800260:	c3                   	ret    

00800261 <printfmt>:
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800267:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80026a:	50                   	push   %eax
  80026b:	ff 75 10             	push   0x10(%ebp)
  80026e:	ff 75 0c             	push   0xc(%ebp)
  800271:	ff 75 08             	push   0x8(%ebp)
  800274:	e8 05 00 00 00       	call   80027e <vprintfmt>
}
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <vprintfmt>:
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 3c             	sub    $0x3c,%esp
  800287:	8b 75 08             	mov    0x8(%ebp),%esi
  80028a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800290:	eb 0a                	jmp    80029c <vprintfmt+0x1e>
			putch(ch, putdat);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	53                   	push   %ebx
  800296:	50                   	push   %eax
  800297:	ff d6                	call   *%esi
  800299:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80029c:	83 c7 01             	add    $0x1,%edi
  80029f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002a3:	83 f8 25             	cmp    $0x25,%eax
  8002a6:	74 0c                	je     8002b4 <vprintfmt+0x36>
			if (ch == '\0')
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	75 e6                	jne    800292 <vprintfmt+0x14>
}
  8002ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002af:	5b                   	pop    %ebx
  8002b0:	5e                   	pop    %esi
  8002b1:	5f                   	pop    %edi
  8002b2:	5d                   	pop    %ebp
  8002b3:	c3                   	ret    
		padc = ' ';
  8002b4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002c6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002cd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d2:	8d 47 01             	lea    0x1(%edi),%eax
  8002d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002d8:	0f b6 17             	movzbl (%edi),%edx
  8002db:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002de:	3c 55                	cmp    $0x55,%al
  8002e0:	0f 87 a6 04 00 00    	ja     80078c <vprintfmt+0x50e>
  8002e6:	0f b6 c0             	movzbl %al,%eax
  8002e9:	ff 24 85 80 12 80 00 	jmp    *0x801280(,%eax,4)
  8002f0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002f3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002f7:	eb d9                	jmp    8002d2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002f9:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002fc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800300:	eb d0                	jmp    8002d2 <vprintfmt+0x54>
  800302:	0f b6 d2             	movzbl %dl,%edx
  800305:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800310:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800313:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800317:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80031a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80031d:	83 f9 09             	cmp    $0x9,%ecx
  800320:	77 55                	ja     800377 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800322:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800325:	eb e9                	jmp    800310 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032f:	8b 45 14             	mov    0x14(%ebp),%eax
  800332:	8d 40 04             	lea    0x4(%eax),%eax
  800335:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80033b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80033f:	79 91                	jns    8002d2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800344:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800347:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80034e:	eb 82                	jmp    8002d2 <vprintfmt+0x54>
  800350:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800353:	85 d2                	test   %edx,%edx
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	0f 49 c2             	cmovns %edx,%eax
  80035d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800363:	e9 6a ff ff ff       	jmp    8002d2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80036b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800372:	e9 5b ff ff ff       	jmp    8002d2 <vprintfmt+0x54>
  800377:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80037a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037d:	eb bc                	jmp    80033b <vprintfmt+0xbd>
			lflag++;
  80037f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800385:	e9 48 ff ff ff       	jmp    8002d2 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80038a:	8b 45 14             	mov    0x14(%ebp),%eax
  80038d:	8d 78 04             	lea    0x4(%eax),%edi
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	53                   	push   %ebx
  800394:	ff 30                	push   (%eax)
  800396:	ff d6                	call   *%esi
			break;
  800398:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80039b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80039e:	e9 88 03 00 00       	jmp    80072b <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a6:	8d 78 04             	lea    0x4(%eax),%edi
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	f7 d8                	neg    %eax
  8003af:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b2:	83 f8 0f             	cmp    $0xf,%eax
  8003b5:	7f 23                	jg     8003da <vprintfmt+0x15c>
  8003b7:	8b 14 85 e0 13 80 00 	mov    0x8013e0(,%eax,4),%edx
  8003be:	85 d2                	test   %edx,%edx
  8003c0:	74 18                	je     8003da <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003c2:	52                   	push   %edx
  8003c3:	68 56 11 80 00       	push   $0x801156
  8003c8:	53                   	push   %ebx
  8003c9:	56                   	push   %esi
  8003ca:	e8 92 fe ff ff       	call   800261 <printfmt>
  8003cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d5:	e9 51 03 00 00       	jmp    80072b <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003da:	50                   	push   %eax
  8003db:	68 4d 11 80 00       	push   $0x80114d
  8003e0:	53                   	push   %ebx
  8003e1:	56                   	push   %esi
  8003e2:	e8 7a fe ff ff       	call   800261 <printfmt>
  8003e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ea:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ed:	e9 39 03 00 00       	jmp    80072b <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	83 c0 04             	add    $0x4,%eax
  8003f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800400:	85 d2                	test   %edx,%edx
  800402:	b8 46 11 80 00       	mov    $0x801146,%eax
  800407:	0f 45 c2             	cmovne %edx,%eax
  80040a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80040d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800411:	7e 06                	jle    800419 <vprintfmt+0x19b>
  800413:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800417:	75 0d                	jne    800426 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800419:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80041c:	89 c7                	mov    %eax,%edi
  80041e:	03 45 d4             	add    -0x2c(%ebp),%eax
  800421:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800424:	eb 55                	jmp    80047b <vprintfmt+0x1fd>
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	ff 75 e0             	push   -0x20(%ebp)
  80042c:	ff 75 cc             	push   -0x34(%ebp)
  80042f:	e8 f5 03 00 00       	call   800829 <strnlen>
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	29 c2                	sub    %eax,%edx
  800439:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800441:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800445:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800448:	eb 0f                	jmp    800459 <vprintfmt+0x1db>
					putch(padc, putdat);
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	53                   	push   %ebx
  80044e:	ff 75 d4             	push   -0x2c(%ebp)
  800451:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	83 ef 01             	sub    $0x1,%edi
  800456:	83 c4 10             	add    $0x10,%esp
  800459:	85 ff                	test   %edi,%edi
  80045b:	7f ed                	jg     80044a <vprintfmt+0x1cc>
  80045d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800460:	85 d2                	test   %edx,%edx
  800462:	b8 00 00 00 00       	mov    $0x0,%eax
  800467:	0f 49 c2             	cmovns %edx,%eax
  80046a:	29 c2                	sub    %eax,%edx
  80046c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80046f:	eb a8                	jmp    800419 <vprintfmt+0x19b>
					putch(ch, putdat);
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	53                   	push   %ebx
  800475:	52                   	push   %edx
  800476:	ff d6                	call   *%esi
  800478:	83 c4 10             	add    $0x10,%esp
  80047b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80047e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800480:	83 c7 01             	add    $0x1,%edi
  800483:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800487:	0f be d0             	movsbl %al,%edx
  80048a:	85 d2                	test   %edx,%edx
  80048c:	74 4b                	je     8004d9 <vprintfmt+0x25b>
  80048e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800492:	78 06                	js     80049a <vprintfmt+0x21c>
  800494:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800498:	78 1e                	js     8004b8 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80049a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049e:	74 d1                	je     800471 <vprintfmt+0x1f3>
  8004a0:	0f be c0             	movsbl %al,%eax
  8004a3:	83 e8 20             	sub    $0x20,%eax
  8004a6:	83 f8 5e             	cmp    $0x5e,%eax
  8004a9:	76 c6                	jbe    800471 <vprintfmt+0x1f3>
					putch('?', putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	53                   	push   %ebx
  8004af:	6a 3f                	push   $0x3f
  8004b1:	ff d6                	call   *%esi
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	eb c3                	jmp    80047b <vprintfmt+0x1fd>
  8004b8:	89 cf                	mov    %ecx,%edi
  8004ba:	eb 0e                	jmp    8004ca <vprintfmt+0x24c>
				putch(' ', putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	53                   	push   %ebx
  8004c0:	6a 20                	push   $0x20
  8004c2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c4:	83 ef 01             	sub    $0x1,%edi
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	85 ff                	test   %edi,%edi
  8004cc:	7f ee                	jg     8004bc <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d4:	e9 52 02 00 00       	jmp    80072b <vprintfmt+0x4ad>
  8004d9:	89 cf                	mov    %ecx,%edi
  8004db:	eb ed                	jmp    8004ca <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	83 c0 04             	add    $0x4,%eax
  8004e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004eb:	85 d2                	test   %edx,%edx
  8004ed:	b8 46 11 80 00       	mov    $0x801146,%eax
  8004f2:	0f 45 c2             	cmovne %edx,%eax
  8004f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fc:	7e 06                	jle    800504 <vprintfmt+0x286>
  8004fe:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800502:	75 0d                	jne    800511 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800507:	89 c7                	mov    %eax,%edi
  800509:	03 45 d4             	add    -0x2c(%ebp),%eax
  80050c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80050f:	eb 55                	jmp    800566 <vprintfmt+0x2e8>
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	ff 75 e0             	push   -0x20(%ebp)
  800517:	ff 75 cc             	push   -0x34(%ebp)
  80051a:	e8 0a 03 00 00       	call   800829 <strnlen>
  80051f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800522:	29 c2                	sub    %eax,%edx
  800524:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80052c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800530:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800533:	eb 0f                	jmp    800544 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	ff 75 d4             	push   -0x2c(%ebp)
  80053c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053e:	83 ef 01             	sub    $0x1,%edi
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	85 ff                	test   %edi,%edi
  800546:	7f ed                	jg     800535 <vprintfmt+0x2b7>
  800548:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80054b:	85 d2                	test   %edx,%edx
  80054d:	b8 00 00 00 00       	mov    $0x0,%eax
  800552:	0f 49 c2             	cmovns %edx,%eax
  800555:	29 c2                	sub    %eax,%edx
  800557:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80055a:	eb a8                	jmp    800504 <vprintfmt+0x286>
					putch(ch, putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	52                   	push   %edx
  800561:	ff d6                	call   *%esi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800569:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80056b:	83 c7 01             	add    $0x1,%edi
  80056e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800572:	0f be d0             	movsbl %al,%edx
  800575:	3c 3a                	cmp    $0x3a,%al
  800577:	74 4b                	je     8005c4 <vprintfmt+0x346>
  800579:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057d:	78 06                	js     800585 <vprintfmt+0x307>
  80057f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800583:	78 1e                	js     8005a3 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800589:	74 d1                	je     80055c <vprintfmt+0x2de>
  80058b:	0f be c0             	movsbl %al,%eax
  80058e:	83 e8 20             	sub    $0x20,%eax
  800591:	83 f8 5e             	cmp    $0x5e,%eax
  800594:	76 c6                	jbe    80055c <vprintfmt+0x2de>
					putch('?', putdat);
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	53                   	push   %ebx
  80059a:	6a 3f                	push   $0x3f
  80059c:	ff d6                	call   *%esi
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	eb c3                	jmp    800566 <vprintfmt+0x2e8>
  8005a3:	89 cf                	mov    %ecx,%edi
  8005a5:	eb 0e                	jmp    8005b5 <vprintfmt+0x337>
				putch(' ', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 20                	push   $0x20
  8005ad:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005af:	83 ef 01             	sub    $0x1,%edi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	85 ff                	test   %edi,%edi
  8005b7:	7f ee                	jg     8005a7 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	e9 67 01 00 00       	jmp    80072b <vprintfmt+0x4ad>
  8005c4:	89 cf                	mov    %ecx,%edi
  8005c6:	eb ed                	jmp    8005b5 <vprintfmt+0x337>
	if (lflag >= 2)
  8005c8:	83 f9 01             	cmp    $0x1,%ecx
  8005cb:	7f 1b                	jg     8005e8 <vprintfmt+0x36a>
	else if (lflag)
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	74 63                	je     800634 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d9:	99                   	cltd   
  8005da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb 17                	jmp    8005ff <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 50 04             	mov    0x4(%eax),%edx
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8d 40 08             	lea    0x8(%eax),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800602:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800605:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80060a:	85 c9                	test   %ecx,%ecx
  80060c:	0f 89 ff 00 00 00    	jns    800711 <vprintfmt+0x493>
				putch('-', putdat);
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 2d                	push   $0x2d
  800618:	ff d6                	call   *%esi
				num = -(long long) num;
  80061a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800620:	f7 da                	neg    %edx
  800622:	83 d1 00             	adc    $0x0,%ecx
  800625:	f7 d9                	neg    %ecx
  800627:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80062f:	e9 dd 00 00 00       	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063c:	99                   	cltd   
  80063d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 40 04             	lea    0x4(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
  800649:	eb b4                	jmp    8005ff <vprintfmt+0x381>
	if (lflag >= 2)
  80064b:	83 f9 01             	cmp    $0x1,%ecx
  80064e:	7f 1e                	jg     80066e <vprintfmt+0x3f0>
	else if (lflag)
  800650:	85 c9                	test   %ecx,%ecx
  800652:	74 32                	je     800686 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800664:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800669:	e9 a3 00 00 00       	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	8b 48 04             	mov    0x4(%eax),%ecx
  800676:	8d 40 08             	lea    0x8(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800681:	e9 8b 00 00 00       	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800696:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80069b:	eb 74                	jmp    800711 <vprintfmt+0x493>
	if (lflag >= 2)
  80069d:	83 f9 01             	cmp    $0x1,%ecx
  8006a0:	7f 1b                	jg     8006bd <vprintfmt+0x43f>
	else if (lflag)
  8006a2:	85 c9                	test   %ecx,%ecx
  8006a4:	74 2c                	je     8006d2 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b6:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006bb:	eb 54                	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c5:	8d 40 08             	lea    0x8(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006d0:	eb 3f                	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e2:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006e7:	eb 28                	jmp    800711 <vprintfmt+0x493>
			putch('0', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 30                	push   $0x30
  8006ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f1:	83 c4 08             	add    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	6a 78                	push   $0x78
  8006f7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800703:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070c:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800718:	50                   	push   %eax
  800719:	ff 75 d4             	push   -0x2c(%ebp)
  80071c:	57                   	push   %edi
  80071d:	51                   	push   %ecx
  80071e:	52                   	push   %edx
  80071f:	89 da                	mov    %ebx,%edx
  800721:	89 f0                	mov    %esi,%eax
  800723:	e8 73 fa ff ff       	call   80019b <printnum>
			break;
  800728:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	e9 69 fb ff ff       	jmp    80029c <vprintfmt+0x1e>
	if (lflag >= 2)
  800733:	83 f9 01             	cmp    $0x1,%ecx
  800736:	7f 1b                	jg     800753 <vprintfmt+0x4d5>
	else if (lflag)
  800738:	85 c9                	test   %ecx,%ecx
  80073a:	74 2c                	je     800768 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 10                	mov    (%eax),%edx
  800741:	b9 00 00 00 00       	mov    $0x0,%ecx
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800751:	eb be                	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 10                	mov    (%eax),%edx
  800758:	8b 48 04             	mov    0x4(%eax),%ecx
  80075b:	8d 40 08             	lea    0x8(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800761:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800766:	eb a9                	jmp    800711 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800778:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  80077d:	eb 92                	jmp    800711 <vprintfmt+0x493>
			putch(ch, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	6a 25                	push   $0x25
  800785:	ff d6                	call   *%esi
			break;
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	eb 9f                	jmp    80072b <vprintfmt+0x4ad>
			putch('%', putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	6a 25                	push   $0x25
  800792:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	89 f8                	mov    %edi,%eax
  800799:	eb 03                	jmp    80079e <vprintfmt+0x520>
  80079b:	83 e8 01             	sub    $0x1,%eax
  80079e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a2:	75 f7                	jne    80079b <vprintfmt+0x51d>
  8007a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007a7:	eb 82                	jmp    80072b <vprintfmt+0x4ad>

008007a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 18             	sub    $0x18,%esp
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	74 26                	je     8007f0 <vsnprintf+0x47>
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	7e 22                	jle    8007f0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ce:	ff 75 14             	push   0x14(%ebp)
  8007d1:	ff 75 10             	push   0x10(%ebp)
  8007d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	68 44 02 80 00       	push   $0x800244
  8007dd:	e8 9c fa ff ff       	call   80027e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    
		return -E_INVAL;
  8007f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f5:	eb f7                	jmp    8007ee <vsnprintf+0x45>

008007f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800800:	50                   	push   %eax
  800801:	ff 75 10             	push   0x10(%ebp)
  800804:	ff 75 0c             	push   0xc(%ebp)
  800807:	ff 75 08             	push   0x8(%ebp)
  80080a:	e8 9a ff ff ff       	call   8007a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80080f:	c9                   	leave  
  800810:	c3                   	ret    

00800811 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800817:	b8 00 00 00 00       	mov    $0x0,%eax
  80081c:	eb 03                	jmp    800821 <strlen+0x10>
		n++;
  80081e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800821:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800825:	75 f7                	jne    80081e <strlen+0xd>
	return n;
}
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800832:	b8 00 00 00 00       	mov    $0x0,%eax
  800837:	eb 03                	jmp    80083c <strnlen+0x13>
		n++;
  800839:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083c:	39 d0                	cmp    %edx,%eax
  80083e:	74 08                	je     800848 <strnlen+0x1f>
  800840:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800844:	75 f3                	jne    800839 <strnlen+0x10>
  800846:	89 c2                	mov    %eax,%edx
	return n;
}
  800848:	89 d0                	mov    %edx,%eax
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	53                   	push   %ebx
  800850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800853:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80085f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800862:	83 c0 01             	add    $0x1,%eax
  800865:	84 d2                	test   %dl,%dl
  800867:	75 f2                	jne    80085b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800869:	89 c8                	mov    %ecx,%eax
  80086b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086e:	c9                   	leave  
  80086f:	c3                   	ret    

00800870 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 10             	sub    $0x10,%esp
  800877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80087a:	53                   	push   %ebx
  80087b:	e8 91 ff ff ff       	call   800811 <strlen>
  800880:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800883:	ff 75 0c             	push   0xc(%ebp)
  800886:	01 d8                	add    %ebx,%eax
  800888:	50                   	push   %eax
  800889:	e8 be ff ff ff       	call   80084c <strcpy>
	return dst;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	8b 75 08             	mov    0x8(%ebp),%esi
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a0:	89 f3                	mov    %esi,%ebx
  8008a2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a5:	89 f0                	mov    %esi,%eax
  8008a7:	eb 0f                	jmp    8008b8 <strncpy+0x23>
		*dst++ = *src;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	0f b6 0a             	movzbl (%edx),%ecx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 f9 01             	cmp    $0x1,%cl
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	75 ed                	jne    8008a9 <strncpy+0x14>
	}
	return ret;
}
  8008bc:	89 f0                	mov    %esi,%eax
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d2:	85 d2                	test   %edx,%edx
  8008d4:	74 21                	je     8008f7 <strlcpy+0x35>
  8008d6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008da:	89 f2                	mov    %esi,%edx
  8008dc:	eb 09                	jmp    8008e7 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008de:	83 c1 01             	add    $0x1,%ecx
  8008e1:	83 c2 01             	add    $0x1,%edx
  8008e4:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	74 09                	je     8008f4 <strlcpy+0x32>
  8008eb:	0f b6 19             	movzbl (%ecx),%ebx
  8008ee:	84 db                	test   %bl,%bl
  8008f0:	75 ec                	jne    8008de <strlcpy+0x1c>
  8008f2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008f4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f7:	29 f0                	sub    %esi,%eax
}
  8008f9:	5b                   	pop    %ebx
  8008fa:	5e                   	pop    %esi
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800903:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800906:	eb 06                	jmp    80090e <strcmp+0x11>
		p++, q++;
  800908:	83 c1 01             	add    $0x1,%ecx
  80090b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80090e:	0f b6 01             	movzbl (%ecx),%eax
  800911:	84 c0                	test   %al,%al
  800913:	74 04                	je     800919 <strcmp+0x1c>
  800915:	3a 02                	cmp    (%edx),%al
  800917:	74 ef                	je     800908 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800919:	0f b6 c0             	movzbl %al,%eax
  80091c:	0f b6 12             	movzbl (%edx),%edx
  80091f:	29 d0                	sub    %edx,%eax
}
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	53                   	push   %ebx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092d:	89 c3                	mov    %eax,%ebx
  80092f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800932:	eb 06                	jmp    80093a <strncmp+0x17>
		n--, p++, q++;
  800934:	83 c0 01             	add    $0x1,%eax
  800937:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093a:	39 d8                	cmp    %ebx,%eax
  80093c:	74 18                	je     800956 <strncmp+0x33>
  80093e:	0f b6 08             	movzbl (%eax),%ecx
  800941:	84 c9                	test   %cl,%cl
  800943:	74 04                	je     800949 <strncmp+0x26>
  800945:	3a 0a                	cmp    (%edx),%cl
  800947:	74 eb                	je     800934 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800949:	0f b6 00             	movzbl (%eax),%eax
  80094c:	0f b6 12             	movzbl (%edx),%edx
  80094f:	29 d0                	sub    %edx,%eax
}
  800951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800954:	c9                   	leave  
  800955:	c3                   	ret    
		return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb f4                	jmp    800951 <strncmp+0x2e>

0080095d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800967:	eb 03                	jmp    80096c <strchr+0xf>
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	0f b6 10             	movzbl (%eax),%edx
  80096f:	84 d2                	test   %dl,%dl
  800971:	74 06                	je     800979 <strchr+0x1c>
		if (*s == c)
  800973:	38 ca                	cmp    %cl,%dl
  800975:	75 f2                	jne    800969 <strchr+0xc>
  800977:	eb 05                	jmp    80097e <strchr+0x21>
			return (char *) s;
	return 0;
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80098d:	38 ca                	cmp    %cl,%dl
  80098f:	74 09                	je     80099a <strfind+0x1a>
  800991:	84 d2                	test   %dl,%dl
  800993:	74 05                	je     80099a <strfind+0x1a>
	for (; *s; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f0                	jmp    80098a <strfind+0xa>
			break;
	return (char *) s;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a8:	85 c9                	test   %ecx,%ecx
  8009aa:	74 2f                	je     8009db <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ac:	89 f8                	mov    %edi,%eax
  8009ae:	09 c8                	or     %ecx,%eax
  8009b0:	a8 03                	test   $0x3,%al
  8009b2:	75 21                	jne    8009d5 <memset+0x39>
		c &= 0xFF;
  8009b4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	c1 e0 08             	shl    $0x8,%eax
  8009bd:	89 d3                	mov    %edx,%ebx
  8009bf:	c1 e3 18             	shl    $0x18,%ebx
  8009c2:	89 d6                	mov    %edx,%esi
  8009c4:	c1 e6 10             	shl    $0x10,%esi
  8009c7:	09 f3                	or     %esi,%ebx
  8009c9:	09 da                	or     %ebx,%edx
  8009cb:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009cd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d0:	fc                   	cld    
  8009d1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d3:	eb 06                	jmp    8009db <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d8:	fc                   	cld    
  8009d9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009db:	89 f8                	mov    %edi,%eax
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5f                   	pop    %edi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f0:	39 c6                	cmp    %eax,%esi
  8009f2:	73 32                	jae    800a26 <memmove+0x44>
  8009f4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f7:	39 c2                	cmp    %eax,%edx
  8009f9:	76 2b                	jbe    800a26 <memmove+0x44>
		s += n;
		d += n;
  8009fb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	89 d6                	mov    %edx,%esi
  800a00:	09 fe                	or     %edi,%esi
  800a02:	09 ce                	or     %ecx,%esi
  800a04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0a:	75 0e                	jne    800a1a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0c:	83 ef 04             	sub    $0x4,%edi
  800a0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a15:	fd                   	std    
  800a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a18:	eb 09                	jmp    800a23 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1a:	83 ef 01             	sub    $0x1,%edi
  800a1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a20:	fd                   	std    
  800a21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a23:	fc                   	cld    
  800a24:	eb 1a                	jmp    800a40 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a26:	89 f2                	mov    %esi,%edx
  800a28:	09 c2                	or     %eax,%edx
  800a2a:	09 ca                	or     %ecx,%edx
  800a2c:	f6 c2 03             	test   $0x3,%dl
  800a2f:	75 0a                	jne    800a3b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a34:	89 c7                	mov    %eax,%edi
  800a36:	fc                   	cld    
  800a37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a39:	eb 05                	jmp    800a40 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a3b:	89 c7                	mov    %eax,%edi
  800a3d:	fc                   	cld    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a4a:	ff 75 10             	push   0x10(%ebp)
  800a4d:	ff 75 0c             	push   0xc(%ebp)
  800a50:	ff 75 08             	push   0x8(%ebp)
  800a53:	e8 8a ff ff ff       	call   8009e2 <memmove>
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	56                   	push   %esi
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	89 c6                	mov    %eax,%esi
  800a67:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6a:	eb 06                	jmp    800a72 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6c:	83 c0 01             	add    $0x1,%eax
  800a6f:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	74 14                	je     800a8a <memcmp+0x30>
		if (*s1 != *s2)
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	38 d9                	cmp    %bl,%cl
  800a7e:	74 ec                	je     800a6c <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a80:	0f b6 c1             	movzbl %cl,%eax
  800a83:	0f b6 db             	movzbl %bl,%ebx
  800a86:	29 d8                	sub    %ebx,%eax
  800a88:	eb 05                	jmp    800a8f <memcmp+0x35>
	}

	return 0;
  800a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9c:	89 c2                	mov    %eax,%edx
  800a9e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa1:	eb 03                	jmp    800aa6 <memfind+0x13>
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	39 d0                	cmp    %edx,%eax
  800aa8:	73 04                	jae    800aae <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aaa:	38 08                	cmp    %cl,(%eax)
  800aac:	75 f5                	jne    800aa3 <memfind+0x10>
			break;
	return (void *) s;
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	57                   	push   %edi
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abc:	eb 03                	jmp    800ac1 <strtol+0x11>
		s++;
  800abe:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ac1:	0f b6 02             	movzbl (%edx),%eax
  800ac4:	3c 20                	cmp    $0x20,%al
  800ac6:	74 f6                	je     800abe <strtol+0xe>
  800ac8:	3c 09                	cmp    $0x9,%al
  800aca:	74 f2                	je     800abe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800acc:	3c 2b                	cmp    $0x2b,%al
  800ace:	74 2a                	je     800afa <strtol+0x4a>
	int neg = 0;
  800ad0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad5:	3c 2d                	cmp    $0x2d,%al
  800ad7:	74 2b                	je     800b04 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800adf:	75 0f                	jne    800af0 <strtol+0x40>
  800ae1:	80 3a 30             	cmpb   $0x30,(%edx)
  800ae4:	74 28                	je     800b0e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae6:	85 db                	test   %ebx,%ebx
  800ae8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aed:	0f 44 d8             	cmove  %eax,%ebx
  800af0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af8:	eb 46                	jmp    800b40 <strtol+0x90>
		s++;
  800afa:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800afd:	bf 00 00 00 00       	mov    $0x0,%edi
  800b02:	eb d5                	jmp    800ad9 <strtol+0x29>
		s++, neg = 1;
  800b04:	83 c2 01             	add    $0x1,%edx
  800b07:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0c:	eb cb                	jmp    800ad9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b12:	74 0e                	je     800b22 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b14:	85 db                	test   %ebx,%ebx
  800b16:	75 d8                	jne    800af0 <strtol+0x40>
		s++, base = 8;
  800b18:	83 c2 01             	add    $0x1,%edx
  800b1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b20:	eb ce                	jmp    800af0 <strtol+0x40>
		s += 2, base = 16;
  800b22:	83 c2 02             	add    $0x2,%edx
  800b25:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b2a:	eb c4                	jmp    800af0 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b2c:	0f be c0             	movsbl %al,%eax
  800b2f:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b32:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b35:	7d 3a                	jge    800b71 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b3e:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b40:	0f b6 02             	movzbl (%edx),%eax
  800b43:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b46:	89 f3                	mov    %esi,%ebx
  800b48:	80 fb 09             	cmp    $0x9,%bl
  800b4b:	76 df                	jbe    800b2c <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b4d:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b50:	89 f3                	mov    %esi,%ebx
  800b52:	80 fb 19             	cmp    $0x19,%bl
  800b55:	77 08                	ja     800b5f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b57:	0f be c0             	movsbl %al,%eax
  800b5a:	83 e8 57             	sub    $0x57,%eax
  800b5d:	eb d3                	jmp    800b32 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b5f:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b62:	89 f3                	mov    %esi,%ebx
  800b64:	80 fb 19             	cmp    $0x19,%bl
  800b67:	77 08                	ja     800b71 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b69:	0f be c0             	movsbl %al,%eax
  800b6c:	83 e8 37             	sub    $0x37,%eax
  800b6f:	eb c1                	jmp    800b32 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b75:	74 05                	je     800b7c <strtol+0xcc>
		*endptr = (char *) s;
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b7c:	89 c8                	mov    %ecx,%eax
  800b7e:	f7 d8                	neg    %eax
  800b80:	85 ff                	test   %edi,%edi
  800b82:	0f 45 c8             	cmovne %eax,%ecx
}
  800b85:	89 c8                	mov    %ecx,%eax
  800b87:	5b                   	pop    %ebx
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c3                	mov    %eax,%ebx
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cgetc>:

int
sys_cgetc(void)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	57                   	push   %edi
  800bae:	56                   	push   %esi
  800baf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	89 d3                	mov    %edx,%ebx
  800bbe:	89 d7                	mov    %edx,%edi
  800bc0:	89 d6                	mov    %edx,%esi
  800bc2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bda:	b8 03 00 00 00       	mov    $0x3,%eax
  800bdf:	89 cb                	mov    %ecx,%ebx
  800be1:	89 cf                	mov    %ecx,%edi
  800be3:	89 ce                	mov    %ecx,%esi
  800be5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be7:	85 c0                	test   %eax,%eax
  800be9:	7f 08                	jg     800bf3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	50                   	push   %eax
  800bf7:	6a 03                	push   $0x3
  800bf9:	68 3f 14 80 00       	push   $0x80143f
  800bfe:	6a 23                	push   $0x23
  800c00:	68 5c 14 80 00       	push   $0x80145c
  800c05:	e8 2f 02 00 00       	call   800e39 <_panic>

00800c0a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	57                   	push   %edi
  800c0e:	56                   	push   %esi
  800c0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
  800c15:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1a:	89 d1                	mov    %edx,%ecx
  800c1c:	89 d3                	mov    %edx,%ebx
  800c1e:	89 d7                	mov    %edx,%edi
  800c20:	89 d6                	mov    %edx,%esi
  800c22:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <sys_yield>:

void
sys_yield(void)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c39:	89 d1                	mov    %edx,%ecx
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	89 d7                	mov    %edx,%edi
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
  800c4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c51:	be 00 00 00 00       	mov    $0x0,%esi
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c64:	89 f7                	mov    %esi,%edi
  800c66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	50                   	push   %eax
  800c78:	6a 04                	push   $0x4
  800c7a:	68 3f 14 80 00       	push   $0x80143f
  800c7f:	6a 23                	push   $0x23
  800c81:	68 5c 14 80 00       	push   $0x80145c
  800c86:	e8 ae 01 00 00       	call   800e39 <_panic>

00800c8b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 05                	push   $0x5
  800cbc:	68 3f 14 80 00       	push   $0x80143f
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 5c 14 80 00       	push   $0x80145c
  800cc8:	e8 6c 01 00 00       	call   800e39 <_panic>

00800ccd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 06                	push   $0x6
  800cfe:	68 3f 14 80 00       	push   $0x80143f
  800d03:	6a 23                	push   $0x23
  800d05:	68 5c 14 80 00       	push   $0x80145c
  800d0a:	e8 2a 01 00 00       	call   800e39 <_panic>

00800d0f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	b8 08 00 00 00       	mov    $0x8,%eax
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 08                	push   $0x8
  800d40:	68 3f 14 80 00       	push   $0x80143f
  800d45:	6a 23                	push   $0x23
  800d47:	68 5c 14 80 00       	push   $0x80145c
  800d4c:	e8 e8 00 00 00       	call   800e39 <_panic>

00800d51 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6a:	89 df                	mov    %ebx,%edi
  800d6c:	89 de                	mov    %ebx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 09                	push   $0x9
  800d82:	68 3f 14 80 00       	push   $0x80143f
  800d87:	6a 23                	push   $0x23
  800d89:	68 5c 14 80 00       	push   $0x80145c
  800d8e:	e8 a6 00 00 00       	call   800e39 <_panic>

00800d93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 0a                	push   $0xa
  800dc4:	68 3f 14 80 00       	push   $0x80143f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 5c 14 80 00       	push   $0x80145c
  800dd0:	e8 64 00 00 00       	call   800e39 <_panic>

00800dd5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	be 00 00 00 00       	mov    $0x0,%esi
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0e:	89 cb                	mov    %ecx,%ebx
  800e10:	89 cf                	mov    %ecx,%edi
  800e12:	89 ce                	mov    %ecx,%esi
  800e14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	7f 08                	jg     800e22 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	50                   	push   %eax
  800e26:	6a 0d                	push   $0xd
  800e28:	68 3f 14 80 00       	push   $0x80143f
  800e2d:	6a 23                	push   $0x23
  800e2f:	68 5c 14 80 00       	push   $0x80145c
  800e34:	e8 00 00 00 00       	call   800e39 <_panic>

00800e39 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e3e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e41:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e47:	e8 be fd ff ff       	call   800c0a <sys_getenvid>
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	ff 75 0c             	push   0xc(%ebp)
  800e52:	ff 75 08             	push   0x8(%ebp)
  800e55:	56                   	push   %esi
  800e56:	50                   	push   %eax
  800e57:	68 6c 14 80 00       	push   $0x80146c
  800e5c:	e8 26 f3 ff ff       	call   800187 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e61:	83 c4 18             	add    $0x18,%esp
  800e64:	53                   	push   %ebx
  800e65:	ff 75 10             	push   0x10(%ebp)
  800e68:	e8 c9 f2 ff ff       	call   800136 <vcprintf>
	cprintf("\n");
  800e6d:	c7 04 24 8f 14 80 00 	movl   $0x80148f,(%esp)
  800e74:	e8 0e f3 ff ff       	call   800187 <cprintf>
  800e79:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e7c:	cc                   	int3   
  800e7d:	eb fd                	jmp    800e7c <_panic+0x43>
  800e7f:	90                   	nop

00800e80 <__udivdi3>:
  800e80:	f3 0f 1e fb          	endbr32 
  800e84:	55                   	push   %ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
  800e88:	83 ec 1c             	sub    $0x1c,%esp
  800e8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e8f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e93:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e97:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 19                	jne    800eb8 <__udivdi3+0x38>
  800e9f:	39 f3                	cmp    %esi,%ebx
  800ea1:	76 4d                	jbe    800ef0 <__udivdi3+0x70>
  800ea3:	31 ff                	xor    %edi,%edi
  800ea5:	89 e8                	mov    %ebp,%eax
  800ea7:	89 f2                	mov    %esi,%edx
  800ea9:	f7 f3                	div    %ebx
  800eab:	89 fa                	mov    %edi,%edx
  800ead:	83 c4 1c             	add    $0x1c,%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
  800eb5:	8d 76 00             	lea    0x0(%esi),%esi
  800eb8:	39 f0                	cmp    %esi,%eax
  800eba:	76 14                	jbe    800ed0 <__udivdi3+0x50>
  800ebc:	31 ff                	xor    %edi,%edi
  800ebe:	31 c0                	xor    %eax,%eax
  800ec0:	89 fa                	mov    %edi,%edx
  800ec2:	83 c4 1c             	add    $0x1c,%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
  800eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ed0:	0f bd f8             	bsr    %eax,%edi
  800ed3:	83 f7 1f             	xor    $0x1f,%edi
  800ed6:	75 48                	jne    800f20 <__udivdi3+0xa0>
  800ed8:	39 f0                	cmp    %esi,%eax
  800eda:	72 06                	jb     800ee2 <__udivdi3+0x62>
  800edc:	31 c0                	xor    %eax,%eax
  800ede:	39 eb                	cmp    %ebp,%ebx
  800ee0:	77 de                	ja     800ec0 <__udivdi3+0x40>
  800ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee7:	eb d7                	jmp    800ec0 <__udivdi3+0x40>
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 d9                	mov    %ebx,%ecx
  800ef2:	85 db                	test   %ebx,%ebx
  800ef4:	75 0b                	jne    800f01 <__udivdi3+0x81>
  800ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	f7 f3                	div    %ebx
  800eff:	89 c1                	mov    %eax,%ecx
  800f01:	31 d2                	xor    %edx,%edx
  800f03:	89 f0                	mov    %esi,%eax
  800f05:	f7 f1                	div    %ecx
  800f07:	89 c6                	mov    %eax,%esi
  800f09:	89 e8                	mov    %ebp,%eax
  800f0b:	89 f7                	mov    %esi,%edi
  800f0d:	f7 f1                	div    %ecx
  800f0f:	89 fa                	mov    %edi,%edx
  800f11:	83 c4 1c             	add    $0x1c,%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	89 f9                	mov    %edi,%ecx
  800f22:	ba 20 00 00 00       	mov    $0x20,%edx
  800f27:	29 fa                	sub    %edi,%edx
  800f29:	d3 e0                	shl    %cl,%eax
  800f2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f2f:	89 d1                	mov    %edx,%ecx
  800f31:	89 d8                	mov    %ebx,%eax
  800f33:	d3 e8                	shr    %cl,%eax
  800f35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f39:	09 c1                	or     %eax,%ecx
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f41:	89 f9                	mov    %edi,%ecx
  800f43:	d3 e3                	shl    %cl,%ebx
  800f45:	89 d1                	mov    %edx,%ecx
  800f47:	d3 e8                	shr    %cl,%eax
  800f49:	89 f9                	mov    %edi,%ecx
  800f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f4f:	89 eb                	mov    %ebp,%ebx
  800f51:	d3 e6                	shl    %cl,%esi
  800f53:	89 d1                	mov    %edx,%ecx
  800f55:	d3 eb                	shr    %cl,%ebx
  800f57:	09 f3                	or     %esi,%ebx
  800f59:	89 c6                	mov    %eax,%esi
  800f5b:	89 f2                	mov    %esi,%edx
  800f5d:	89 d8                	mov    %ebx,%eax
  800f5f:	f7 74 24 08          	divl   0x8(%esp)
  800f63:	89 d6                	mov    %edx,%esi
  800f65:	89 c3                	mov    %eax,%ebx
  800f67:	f7 64 24 0c          	mull   0xc(%esp)
  800f6b:	39 d6                	cmp    %edx,%esi
  800f6d:	72 19                	jb     800f88 <__udivdi3+0x108>
  800f6f:	89 f9                	mov    %edi,%ecx
  800f71:	d3 e5                	shl    %cl,%ebp
  800f73:	39 c5                	cmp    %eax,%ebp
  800f75:	73 04                	jae    800f7b <__udivdi3+0xfb>
  800f77:	39 d6                	cmp    %edx,%esi
  800f79:	74 0d                	je     800f88 <__udivdi3+0x108>
  800f7b:	89 d8                	mov    %ebx,%eax
  800f7d:	31 ff                	xor    %edi,%edi
  800f7f:	e9 3c ff ff ff       	jmp    800ec0 <__udivdi3+0x40>
  800f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f8b:	31 ff                	xor    %edi,%edi
  800f8d:	e9 2e ff ff ff       	jmp    800ec0 <__udivdi3+0x40>
  800f92:	66 90                	xchg   %ax,%ax
  800f94:	66 90                	xchg   %ax,%ax
  800f96:	66 90                	xchg   %ax,%ax
  800f98:	66 90                	xchg   %ax,%ax
  800f9a:	66 90                	xchg   %ax,%ax
  800f9c:	66 90                	xchg   %ax,%ax
  800f9e:	66 90                	xchg   %ax,%ax

00800fa0 <__umoddi3>:
  800fa0:	f3 0f 1e fb          	endbr32 
  800fa4:	55                   	push   %ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 1c             	sub    $0x1c,%esp
  800fab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800faf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800fb3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800fb7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	89 da                	mov    %ebx,%edx
  800fbf:	85 ff                	test   %edi,%edi
  800fc1:	75 15                	jne    800fd8 <__umoddi3+0x38>
  800fc3:	39 dd                	cmp    %ebx,%ebp
  800fc5:	76 39                	jbe    801000 <__umoddi3+0x60>
  800fc7:	f7 f5                	div    %ebp
  800fc9:	89 d0                	mov    %edx,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	83 c4 1c             	add    $0x1c,%esp
  800fd0:	5b                   	pop    %ebx
  800fd1:	5e                   	pop    %esi
  800fd2:	5f                   	pop    %edi
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    
  800fd5:	8d 76 00             	lea    0x0(%esi),%esi
  800fd8:	39 df                	cmp    %ebx,%edi
  800fda:	77 f1                	ja     800fcd <__umoddi3+0x2d>
  800fdc:	0f bd cf             	bsr    %edi,%ecx
  800fdf:	83 f1 1f             	xor    $0x1f,%ecx
  800fe2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fe6:	75 40                	jne    801028 <__umoddi3+0x88>
  800fe8:	39 df                	cmp    %ebx,%edi
  800fea:	72 04                	jb     800ff0 <__umoddi3+0x50>
  800fec:	39 f5                	cmp    %esi,%ebp
  800fee:	77 dd                	ja     800fcd <__umoddi3+0x2d>
  800ff0:	89 da                	mov    %ebx,%edx
  800ff2:	89 f0                	mov    %esi,%eax
  800ff4:	29 e8                	sub    %ebp,%eax
  800ff6:	19 fa                	sbb    %edi,%edx
  800ff8:	eb d3                	jmp    800fcd <__umoddi3+0x2d>
  800ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801000:	89 e9                	mov    %ebp,%ecx
  801002:	85 ed                	test   %ebp,%ebp
  801004:	75 0b                	jne    801011 <__umoddi3+0x71>
  801006:	b8 01 00 00 00       	mov    $0x1,%eax
  80100b:	31 d2                	xor    %edx,%edx
  80100d:	f7 f5                	div    %ebp
  80100f:	89 c1                	mov    %eax,%ecx
  801011:	89 d8                	mov    %ebx,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f1                	div    %ecx
  801017:	89 f0                	mov    %esi,%eax
  801019:	f7 f1                	div    %ecx
  80101b:	89 d0                	mov    %edx,%eax
  80101d:	31 d2                	xor    %edx,%edx
  80101f:	eb ac                	jmp    800fcd <__umoddi3+0x2d>
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	8b 44 24 04          	mov    0x4(%esp),%eax
  80102c:	ba 20 00 00 00       	mov    $0x20,%edx
  801031:	29 c2                	sub    %eax,%edx
  801033:	89 c1                	mov    %eax,%ecx
  801035:	89 e8                	mov    %ebp,%eax
  801037:	d3 e7                	shl    %cl,%edi
  801039:	89 d1                	mov    %edx,%ecx
  80103b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80103f:	d3 e8                	shr    %cl,%eax
  801041:	89 c1                	mov    %eax,%ecx
  801043:	8b 44 24 04          	mov    0x4(%esp),%eax
  801047:	09 f9                	or     %edi,%ecx
  801049:	89 df                	mov    %ebx,%edi
  80104b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80104f:	89 c1                	mov    %eax,%ecx
  801051:	d3 e5                	shl    %cl,%ebp
  801053:	89 d1                	mov    %edx,%ecx
  801055:	d3 ef                	shr    %cl,%edi
  801057:	89 c1                	mov    %eax,%ecx
  801059:	89 f0                	mov    %esi,%eax
  80105b:	d3 e3                	shl    %cl,%ebx
  80105d:	89 d1                	mov    %edx,%ecx
  80105f:	89 fa                	mov    %edi,%edx
  801061:	d3 e8                	shr    %cl,%eax
  801063:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801068:	09 d8                	or     %ebx,%eax
  80106a:	f7 74 24 08          	divl   0x8(%esp)
  80106e:	89 d3                	mov    %edx,%ebx
  801070:	d3 e6                	shl    %cl,%esi
  801072:	f7 e5                	mul    %ebp
  801074:	89 c7                	mov    %eax,%edi
  801076:	89 d1                	mov    %edx,%ecx
  801078:	39 d3                	cmp    %edx,%ebx
  80107a:	72 06                	jb     801082 <__umoddi3+0xe2>
  80107c:	75 0e                	jne    80108c <__umoddi3+0xec>
  80107e:	39 c6                	cmp    %eax,%esi
  801080:	73 0a                	jae    80108c <__umoddi3+0xec>
  801082:	29 e8                	sub    %ebp,%eax
  801084:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801088:	89 d1                	mov    %edx,%ecx
  80108a:	89 c7                	mov    %eax,%edi
  80108c:	89 f5                	mov    %esi,%ebp
  80108e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801092:	29 fd                	sub    %edi,%ebp
  801094:	19 cb                	sbb    %ecx,%ebx
  801096:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	d3 e0                	shl    %cl,%eax
  80109f:	89 f1                	mov    %esi,%ecx
  8010a1:	d3 ed                	shr    %cl,%ebp
  8010a3:	d3 eb                	shr    %cl,%ebx
  8010a5:	09 e8                	or     %ebp,%eax
  8010a7:	89 da                	mov    %ebx,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
