
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 a0 10 80 00       	push   $0x8010a0
  800056:	e8 f2 00 00 00       	call   80014d <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 60 0b 00 00       	call   800bd0 <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000ac:	6a 00                	push   $0x0
  8000ae:	e8 dc 0a 00 00       	call   800b8f <sys_env_destroy>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 04             	sub    $0x4,%esp
  8000bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c2:	8b 13                	mov    (%ebx),%edx
  8000c4:	8d 42 01             	lea    0x1(%edx),%eax
  8000c7:	89 03                	mov    %eax,(%ebx)
  8000c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d5:	74 09                	je     8000e0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e0:	83 ec 08             	sub    $0x8,%esp
  8000e3:	68 ff 00 00 00       	push   $0xff
  8000e8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000eb:	50                   	push   %eax
  8000ec:	e8 61 0a 00 00       	call   800b52 <sys_cputs>
		b->idx = 0;
  8000f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	eb db                	jmp    8000d7 <putch+0x1f>

008000fc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800105:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010c:	00 00 00 
	b.cnt = 0;
  80010f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800116:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800119:	ff 75 0c             	push   0xc(%ebp)
  80011c:	ff 75 08             	push   0x8(%ebp)
  80011f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800125:	50                   	push   %eax
  800126:	68 b8 00 80 00       	push   $0x8000b8
  80012b:	e8 14 01 00 00       	call   800244 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800130:	83 c4 08             	add    $0x8,%esp
  800133:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800139:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013f:	50                   	push   %eax
  800140:	e8 0d 0a 00 00       	call   800b52 <sys_cputs>

	return b.cnt;
}
  800145:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800153:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800156:	50                   	push   %eax
  800157:	ff 75 08             	push   0x8(%ebp)
  80015a:	e8 9d ff ff ff       	call   8000fc <vcprintf>
	va_end(ap);

	return cnt;
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    

00800161 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	57                   	push   %edi
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
  800167:	83 ec 1c             	sub    $0x1c,%esp
  80016a:	89 c7                	mov    %eax,%edi
  80016c:	89 d6                	mov    %edx,%esi
  80016e:	8b 45 08             	mov    0x8(%ebp),%eax
  800171:	8b 55 0c             	mov    0xc(%ebp),%edx
  800174:	89 d1                	mov    %edx,%ecx
  800176:	89 c2                	mov    %eax,%edx
  800178:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80017e:	8b 45 10             	mov    0x10(%ebp),%eax
  800181:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800184:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800187:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80018e:	39 c2                	cmp    %eax,%edx
  800190:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800193:	72 3e                	jb     8001d3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	ff 75 18             	push   0x18(%ebp)
  80019b:	83 eb 01             	sub    $0x1,%ebx
  80019e:	53                   	push   %ebx
  80019f:	50                   	push   %eax
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 e4             	push   -0x1c(%ebp)
  8001a6:	ff 75 e0             	push   -0x20(%ebp)
  8001a9:	ff 75 dc             	push   -0x24(%ebp)
  8001ac:	ff 75 d8             	push   -0x28(%ebp)
  8001af:	e8 9c 0c 00 00       	call   800e50 <__udivdi3>
  8001b4:	83 c4 18             	add    $0x18,%esp
  8001b7:	52                   	push   %edx
  8001b8:	50                   	push   %eax
  8001b9:	89 f2                	mov    %esi,%edx
  8001bb:	89 f8                	mov    %edi,%eax
  8001bd:	e8 9f ff ff ff       	call   800161 <printnum>
  8001c2:	83 c4 20             	add    $0x20,%esp
  8001c5:	eb 13                	jmp    8001da <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	56                   	push   %esi
  8001cb:	ff 75 18             	push   0x18(%ebp)
  8001ce:	ff d7                	call   *%edi
  8001d0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001d3:	83 eb 01             	sub    $0x1,%ebx
  8001d6:	85 db                	test   %ebx,%ebx
  8001d8:	7f ed                	jg     8001c7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	56                   	push   %esi
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	ff 75 e4             	push   -0x1c(%ebp)
  8001e4:	ff 75 e0             	push   -0x20(%ebp)
  8001e7:	ff 75 dc             	push   -0x24(%ebp)
  8001ea:	ff 75 d8             	push   -0x28(%ebp)
  8001ed:	e8 7e 0d 00 00       	call   800f70 <__umoddi3>
  8001f2:	83 c4 14             	add    $0x14,%esp
  8001f5:	0f be 80 b8 10 80 00 	movsbl 0x8010b8(%eax),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff d7                	call   *%edi
}
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    

0080020a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800210:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800214:	8b 10                	mov    (%eax),%edx
  800216:	3b 50 04             	cmp    0x4(%eax),%edx
  800219:	73 0a                	jae    800225 <sprintputch+0x1b>
		*b->buf++ = ch;
  80021b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021e:	89 08                	mov    %ecx,(%eax)
  800220:	8b 45 08             	mov    0x8(%ebp),%eax
  800223:	88 02                	mov    %al,(%edx)
}
  800225:	5d                   	pop    %ebp
  800226:	c3                   	ret    

00800227 <printfmt>:
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80022d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800230:	50                   	push   %eax
  800231:	ff 75 10             	push   0x10(%ebp)
  800234:	ff 75 0c             	push   0xc(%ebp)
  800237:	ff 75 08             	push   0x8(%ebp)
  80023a:	e8 05 00 00 00       	call   800244 <vprintfmt>
}
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <vprintfmt>:
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	57                   	push   %edi
  800248:	56                   	push   %esi
  800249:	53                   	push   %ebx
  80024a:	83 ec 3c             	sub    $0x3c,%esp
  80024d:	8b 75 08             	mov    0x8(%ebp),%esi
  800250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800253:	8b 7d 10             	mov    0x10(%ebp),%edi
  800256:	eb 0a                	jmp    800262 <vprintfmt+0x1e>
			putch(ch, putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	53                   	push   %ebx
  80025c:	50                   	push   %eax
  80025d:	ff d6                	call   *%esi
  80025f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800262:	83 c7 01             	add    $0x1,%edi
  800265:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800269:	83 f8 25             	cmp    $0x25,%eax
  80026c:	74 0c                	je     80027a <vprintfmt+0x36>
			if (ch == '\0')
  80026e:	85 c0                	test   %eax,%eax
  800270:	75 e6                	jne    800258 <vprintfmt+0x14>
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    
		padc = ' ';
  80027a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80027e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800285:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80028c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800293:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800298:	8d 47 01             	lea    0x1(%edi),%eax
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80029e:	0f b6 17             	movzbl (%edi),%edx
  8002a1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a4:	3c 55                	cmp    $0x55,%al
  8002a6:	0f 87 a6 04 00 00    	ja     800752 <vprintfmt+0x50e>
  8002ac:	0f b6 c0             	movzbl %al,%eax
  8002af:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  8002b6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002b9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002bd:	eb d9                	jmp    800298 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8002c2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002c6:	eb d0                	jmp    800298 <vprintfmt+0x54>
  8002c8:	0f b6 d2             	movzbl %dl,%edx
  8002cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8002d6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002dd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002e0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e3:	83 f9 09             	cmp    $0x9,%ecx
  8002e6:	77 55                	ja     80033d <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002e8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002eb:	eb e9                	jmp    8002d6 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f0:	8b 00                	mov    (%eax),%eax
  8002f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f8:	8d 40 04             	lea    0x4(%eax),%eax
  8002fb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fe:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800301:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800305:	79 91                	jns    800298 <vprintfmt+0x54>
				width = precision, precision = -1;
  800307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80030d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800314:	eb 82                	jmp    800298 <vprintfmt+0x54>
  800316:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800319:	85 d2                	test   %edx,%edx
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
  800320:	0f 49 c2             	cmovns %edx,%eax
  800323:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800329:	e9 6a ff ff ff       	jmp    800298 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800331:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800338:	e9 5b ff ff ff       	jmp    800298 <vprintfmt+0x54>
  80033d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800340:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800343:	eb bc                	jmp    800301 <vprintfmt+0xbd>
			lflag++;
  800345:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80034b:	e9 48 ff ff ff       	jmp    800298 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8d 78 04             	lea    0x4(%eax),%edi
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	53                   	push   %ebx
  80035a:	ff 30                	push   (%eax)
  80035c:	ff d6                	call   *%esi
			break;
  80035e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800361:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800364:	e9 88 03 00 00       	jmp    8006f1 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	8d 78 04             	lea    0x4(%eax),%edi
  80036f:	8b 10                	mov    (%eax),%edx
  800371:	89 d0                	mov    %edx,%eax
  800373:	f7 d8                	neg    %eax
  800375:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800378:	83 f8 0f             	cmp    $0xf,%eax
  80037b:	7f 23                	jg     8003a0 <vprintfmt+0x15c>
  80037d:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  800384:	85 d2                	test   %edx,%edx
  800386:	74 18                	je     8003a0 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800388:	52                   	push   %edx
  800389:	68 d9 10 80 00       	push   $0x8010d9
  80038e:	53                   	push   %ebx
  80038f:	56                   	push   %esi
  800390:	e8 92 fe ff ff       	call   800227 <printfmt>
  800395:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800398:	89 7d 14             	mov    %edi,0x14(%ebp)
  80039b:	e9 51 03 00 00       	jmp    8006f1 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003a0:	50                   	push   %eax
  8003a1:	68 d0 10 80 00       	push   $0x8010d0
  8003a6:	53                   	push   %ebx
  8003a7:	56                   	push   %esi
  8003a8:	e8 7a fe ff ff       	call   800227 <printfmt>
  8003ad:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003b3:	e9 39 03 00 00       	jmp    8006f1 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	83 c0 04             	add    $0x4,%eax
  8003be:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003c6:	85 d2                	test   %edx,%edx
  8003c8:	b8 c9 10 80 00       	mov    $0x8010c9,%eax
  8003cd:	0f 45 c2             	cmovne %edx,%eax
  8003d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003d7:	7e 06                	jle    8003df <vprintfmt+0x19b>
  8003d9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003dd:	75 0d                	jne    8003ec <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e2:	89 c7                	mov    %eax,%edi
  8003e4:	03 45 d4             	add    -0x2c(%ebp),%eax
  8003e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003ea:	eb 55                	jmp    800441 <vprintfmt+0x1fd>
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	ff 75 e0             	push   -0x20(%ebp)
  8003f2:	ff 75 cc             	push   -0x34(%ebp)
  8003f5:	e8 f5 03 00 00       	call   8007ef <strnlen>
  8003fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003fd:	29 c2                	sub    %eax,%edx
  8003ff:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800407:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80040b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80040e:	eb 0f                	jmp    80041f <vprintfmt+0x1db>
					putch(padc, putdat);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	53                   	push   %ebx
  800414:	ff 75 d4             	push   -0x2c(%ebp)
  800417:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800419:	83 ef 01             	sub    $0x1,%edi
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	85 ff                	test   %edi,%edi
  800421:	7f ed                	jg     800410 <vprintfmt+0x1cc>
  800423:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800426:	85 d2                	test   %edx,%edx
  800428:	b8 00 00 00 00       	mov    $0x0,%eax
  80042d:	0f 49 c2             	cmovns %edx,%eax
  800430:	29 c2                	sub    %eax,%edx
  800432:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800435:	eb a8                	jmp    8003df <vprintfmt+0x19b>
					putch(ch, putdat);
  800437:	83 ec 08             	sub    $0x8,%esp
  80043a:	53                   	push   %ebx
  80043b:	52                   	push   %edx
  80043c:	ff d6                	call   *%esi
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800444:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800446:	83 c7 01             	add    $0x1,%edi
  800449:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80044d:	0f be d0             	movsbl %al,%edx
  800450:	85 d2                	test   %edx,%edx
  800452:	74 4b                	je     80049f <vprintfmt+0x25b>
  800454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800458:	78 06                	js     800460 <vprintfmt+0x21c>
  80045a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80045e:	78 1e                	js     80047e <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800460:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800464:	74 d1                	je     800437 <vprintfmt+0x1f3>
  800466:	0f be c0             	movsbl %al,%eax
  800469:	83 e8 20             	sub    $0x20,%eax
  80046c:	83 f8 5e             	cmp    $0x5e,%eax
  80046f:	76 c6                	jbe    800437 <vprintfmt+0x1f3>
					putch('?', putdat);
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	53                   	push   %ebx
  800475:	6a 3f                	push   $0x3f
  800477:	ff d6                	call   *%esi
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	eb c3                	jmp    800441 <vprintfmt+0x1fd>
  80047e:	89 cf                	mov    %ecx,%edi
  800480:	eb 0e                	jmp    800490 <vprintfmt+0x24c>
				putch(' ', putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	6a 20                	push   $0x20
  800488:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80048a:	83 ef 01             	sub    $0x1,%edi
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	85 ff                	test   %edi,%edi
  800492:	7f ee                	jg     800482 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800494:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800497:	89 45 14             	mov    %eax,0x14(%ebp)
  80049a:	e9 52 02 00 00       	jmp    8006f1 <vprintfmt+0x4ad>
  80049f:	89 cf                	mov    %ecx,%edi
  8004a1:	eb ed                	jmp    800490 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	83 c0 04             	add    $0x4,%eax
  8004a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	b8 c9 10 80 00       	mov    $0x8010c9,%eax
  8004b8:	0f 45 c2             	cmovne %edx,%eax
  8004bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c2:	7e 06                	jle    8004ca <vprintfmt+0x286>
  8004c4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c8:	75 0d                	jne    8004d7 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004cd:	89 c7                	mov    %eax,%edi
  8004cf:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004d5:	eb 55                	jmp    80052c <vprintfmt+0x2e8>
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	ff 75 e0             	push   -0x20(%ebp)
  8004dd:	ff 75 cc             	push   -0x34(%ebp)
  8004e0:	e8 0a 03 00 00       	call   8007ef <strnlen>
  8004e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e8:	29 c2                	sub    %eax,%edx
  8004ea:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	eb 0f                	jmp    80050a <vprintfmt+0x2c6>
					putch(padc, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	ff 75 d4             	push   -0x2c(%ebp)
  800502:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	83 ef 01             	sub    $0x1,%edi
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	85 ff                	test   %edi,%edi
  80050c:	7f ed                	jg     8004fb <vprintfmt+0x2b7>
  80050e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	0f 49 c2             	cmovns %edx,%eax
  80051b:	29 c2                	sub    %eax,%edx
  80051d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800520:	eb a8                	jmp    8004ca <vprintfmt+0x286>
					putch(ch, putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	52                   	push   %edx
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80052f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800531:	83 c7 01             	add    $0x1,%edi
  800534:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800538:	0f be d0             	movsbl %al,%edx
  80053b:	3c 3a                	cmp    $0x3a,%al
  80053d:	74 4b                	je     80058a <vprintfmt+0x346>
  80053f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800543:	78 06                	js     80054b <vprintfmt+0x307>
  800545:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800549:	78 1e                	js     800569 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80054b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054f:	74 d1                	je     800522 <vprintfmt+0x2de>
  800551:	0f be c0             	movsbl %al,%eax
  800554:	83 e8 20             	sub    $0x20,%eax
  800557:	83 f8 5e             	cmp    $0x5e,%eax
  80055a:	76 c6                	jbe    800522 <vprintfmt+0x2de>
					putch('?', putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	6a 3f                	push   $0x3f
  800562:	ff d6                	call   *%esi
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	eb c3                	jmp    80052c <vprintfmt+0x2e8>
  800569:	89 cf                	mov    %ecx,%edi
  80056b:	eb 0e                	jmp    80057b <vprintfmt+0x337>
				putch(' ', putdat);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	53                   	push   %ebx
  800571:	6a 20                	push   $0x20
  800573:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800575:	83 ef 01             	sub    $0x1,%edi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	85 ff                	test   %edi,%edi
  80057d:	7f ee                	jg     80056d <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80057f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	e9 67 01 00 00       	jmp    8006f1 <vprintfmt+0x4ad>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb ed                	jmp    80057b <vprintfmt+0x337>
	if (lflag >= 2)
  80058e:	83 f9 01             	cmp    $0x1,%ecx
  800591:	7f 1b                	jg     8005ae <vprintfmt+0x36a>
	else if (lflag)
  800593:	85 c9                	test   %ecx,%ecx
  800595:	74 63                	je     8005fa <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059f:	99                   	cltd   
  8005a0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	eb 17                	jmp    8005c5 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 50 04             	mov    0x4(%eax),%edx
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 40 08             	lea    0x8(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8005cb:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005d0:	85 c9                	test   %ecx,%ecx
  8005d2:	0f 89 ff 00 00 00    	jns    8006d7 <vprintfmt+0x493>
				putch('-', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 2d                	push   $0x2d
  8005de:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005e6:	f7 da                	neg    %edx
  8005e8:	83 d1 00             	adc    $0x0,%ecx
  8005eb:	f7 d9                	neg    %ecx
  8005ed:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f5:	e9 dd 00 00 00       	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800602:	99                   	cltd   
  800603:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
  80060f:	eb b4                	jmp    8005c5 <vprintfmt+0x381>
	if (lflag >= 2)
  800611:	83 f9 01             	cmp    $0x1,%ecx
  800614:	7f 1e                	jg     800634 <vprintfmt+0x3f0>
	else if (lflag)
  800616:	85 c9                	test   %ecx,%ecx
  800618:	74 32                	je     80064c <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80062f:	e9 a3 00 00 00       	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 10                	mov    (%eax),%edx
  800639:	8b 48 04             	mov    0x4(%eax),%ecx
  80063c:	8d 40 08             	lea    0x8(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800642:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800647:	e9 8b 00 00 00       	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 10                	mov    (%eax),%edx
  800651:	b9 00 00 00 00       	mov    $0x0,%ecx
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800661:	eb 74                	jmp    8006d7 <vprintfmt+0x493>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7f 1b                	jg     800683 <vprintfmt+0x43f>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	74 2c                	je     800698 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	b9 00 00 00 00       	mov    $0x0,%ecx
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800681:	eb 54                	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 48 04             	mov    0x4(%eax),%ecx
  80068b:	8d 40 08             	lea    0x8(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800691:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800696:	eb 3f                	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a8:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006ad:	eb 28                	jmp    8006d7 <vprintfmt+0x493>
			putch('0', putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 30                	push   $0x30
  8006b5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 78                	push   $0x78
  8006bd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 10                	mov    (%eax),%edx
  8006c4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d2:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006de:	50                   	push   %eax
  8006df:	ff 75 d4             	push   -0x2c(%ebp)
  8006e2:	57                   	push   %edi
  8006e3:	51                   	push   %ecx
  8006e4:	52                   	push   %edx
  8006e5:	89 da                	mov    %ebx,%edx
  8006e7:	89 f0                	mov    %esi,%eax
  8006e9:	e8 73 fa ff ff       	call   800161 <printnum>
			break;
  8006ee:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f4:	e9 69 fb ff ff       	jmp    800262 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006f9:	83 f9 01             	cmp    $0x1,%ecx
  8006fc:	7f 1b                	jg     800719 <vprintfmt+0x4d5>
	else if (lflag)
  8006fe:	85 c9                	test   %ecx,%ecx
  800700:	74 2c                	je     80072e <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 10                	mov    (%eax),%edx
  800707:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070c:	8d 40 04             	lea    0x4(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800712:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800717:	eb be                	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 10                	mov    (%eax),%edx
  80071e:	8b 48 04             	mov    0x4(%eax),%ecx
  800721:	8d 40 08             	lea    0x8(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800727:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80072c:	eb a9                	jmp    8006d7 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073e:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800743:	eb 92                	jmp    8006d7 <vprintfmt+0x493>
			putch(ch, putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	6a 25                	push   $0x25
  80074b:	ff d6                	call   *%esi
			break;
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	eb 9f                	jmp    8006f1 <vprintfmt+0x4ad>
			putch('%', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 25                	push   $0x25
  800758:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	89 f8                	mov    %edi,%eax
  80075f:	eb 03                	jmp    800764 <vprintfmt+0x520>
  800761:	83 e8 01             	sub    $0x1,%eax
  800764:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800768:	75 f7                	jne    800761 <vprintfmt+0x51d>
  80076a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80076d:	eb 82                	jmp    8006f1 <vprintfmt+0x4ad>

0080076f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800782:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078c:	85 c0                	test   %eax,%eax
  80078e:	74 26                	je     8007b6 <vsnprintf+0x47>
  800790:	85 d2                	test   %edx,%edx
  800792:	7e 22                	jle    8007b6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800794:	ff 75 14             	push   0x14(%ebp)
  800797:	ff 75 10             	push   0x10(%ebp)
  80079a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	68 0a 02 80 00       	push   $0x80020a
  8007a3:	e8 9c fa ff ff       	call   800244 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
}
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    
		return -E_INVAL;
  8007b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bb:	eb f7                	jmp    8007b4 <vsnprintf+0x45>

008007bd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c6:	50                   	push   %eax
  8007c7:	ff 75 10             	push   0x10(%ebp)
  8007ca:	ff 75 0c             	push   0xc(%ebp)
  8007cd:	ff 75 08             	push   0x8(%ebp)
  8007d0:	e8 9a ff ff ff       	call   80076f <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	eb 03                	jmp    8007e7 <strlen+0x10>
		n++;
  8007e4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007eb:	75 f7                	jne    8007e4 <strlen+0xd>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	eb 03                	jmp    800802 <strnlen+0x13>
		n++;
  8007ff:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800802:	39 d0                	cmp    %edx,%eax
  800804:	74 08                	je     80080e <strnlen+0x1f>
  800806:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080a:	75 f3                	jne    8007ff <strnlen+0x10>
  80080c:	89 c2                	mov    %eax,%edx
	return n;
}
  80080e:	89 d0                	mov    %edx,%eax
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800819:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800825:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800828:	83 c0 01             	add    $0x1,%eax
  80082b:	84 d2                	test   %dl,%dl
  80082d:	75 f2                	jne    800821 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80082f:	89 c8                	mov    %ecx,%eax
  800831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	53                   	push   %ebx
  80083a:	83 ec 10             	sub    $0x10,%esp
  80083d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800840:	53                   	push   %ebx
  800841:	e8 91 ff ff ff       	call   8007d7 <strlen>
  800846:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800849:	ff 75 0c             	push   0xc(%ebp)
  80084c:	01 d8                	add    %ebx,%eax
  80084e:	50                   	push   %eax
  80084f:	e8 be ff ff ff       	call   800812 <strcpy>
	return dst;
}
  800854:	89 d8                	mov    %ebx,%eax
  800856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	56                   	push   %esi
  80085f:	53                   	push   %ebx
  800860:	8b 75 08             	mov    0x8(%ebp),%esi
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
  800866:	89 f3                	mov    %esi,%ebx
  800868:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80086b:	89 f0                	mov    %esi,%eax
  80086d:	eb 0f                	jmp    80087e <strncpy+0x23>
		*dst++ = *src;
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	0f b6 0a             	movzbl (%edx),%ecx
  800875:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800878:	80 f9 01             	cmp    $0x1,%cl
  80087b:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	75 ed                	jne    80086f <strncpy+0x14>
	}
	return ret;
}
  800882:	89 f0                	mov    %esi,%eax
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800893:	8b 55 10             	mov    0x10(%ebp),%edx
  800896:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800898:	85 d2                	test   %edx,%edx
  80089a:	74 21                	je     8008bd <strlcpy+0x35>
  80089c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008a0:	89 f2                	mov    %esi,%edx
  8008a2:	eb 09                	jmp    8008ad <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a4:	83 c1 01             	add    $0x1,%ecx
  8008a7:	83 c2 01             	add    $0x1,%edx
  8008aa:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	74 09                	je     8008ba <strlcpy+0x32>
  8008b1:	0f b6 19             	movzbl (%ecx),%ebx
  8008b4:	84 db                	test   %bl,%bl
  8008b6:	75 ec                	jne    8008a4 <strlcpy+0x1c>
  8008b8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008bd:	29 f0                	sub    %esi,%eax
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cc:	eb 06                	jmp    8008d4 <strcmp+0x11>
		p++, q++;
  8008ce:	83 c1 01             	add    $0x1,%ecx
  8008d1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d4:	0f b6 01             	movzbl (%ecx),%eax
  8008d7:	84 c0                	test   %al,%al
  8008d9:	74 04                	je     8008df <strcmp+0x1c>
  8008db:	3a 02                	cmp    (%edx),%al
  8008dd:	74 ef                	je     8008ce <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	0f b6 12             	movzbl (%edx),%edx
  8008e5:	29 d0                	sub    %edx,%eax
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 c3                	mov    %eax,%ebx
  8008f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f8:	eb 06                	jmp    800900 <strncmp+0x17>
		n--, p++, q++;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800900:	39 d8                	cmp    %ebx,%eax
  800902:	74 18                	je     80091c <strncmp+0x33>
  800904:	0f b6 08             	movzbl (%eax),%ecx
  800907:	84 c9                	test   %cl,%cl
  800909:	74 04                	je     80090f <strncmp+0x26>
  80090b:	3a 0a                	cmp    (%edx),%cl
  80090d:	74 eb                	je     8008fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090f:	0f b6 00             	movzbl (%eax),%eax
  800912:	0f b6 12             	movzbl (%edx),%edx
  800915:	29 d0                	sub    %edx,%eax
}
  800917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb f4                	jmp    800917 <strncmp+0x2e>

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092d:	eb 03                	jmp    800932 <strchr+0xf>
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	0f b6 10             	movzbl (%eax),%edx
  800935:	84 d2                	test   %dl,%dl
  800937:	74 06                	je     80093f <strchr+0x1c>
		if (*s == c)
  800939:	38 ca                	cmp    %cl,%dl
  80093b:	75 f2                	jne    80092f <strchr+0xc>
  80093d:	eb 05                	jmp    800944 <strchr+0x21>
			return (char *) s;
	return 0;
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800950:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800953:	38 ca                	cmp    %cl,%dl
  800955:	74 09                	je     800960 <strfind+0x1a>
  800957:	84 d2                	test   %dl,%dl
  800959:	74 05                	je     800960 <strfind+0x1a>
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	eb f0                	jmp    800950 <strfind+0xa>
			break;
	return (char *) s;
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	57                   	push   %edi
  800966:	56                   	push   %esi
  800967:	53                   	push   %ebx
  800968:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096e:	85 c9                	test   %ecx,%ecx
  800970:	74 2f                	je     8009a1 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800972:	89 f8                	mov    %edi,%eax
  800974:	09 c8                	or     %ecx,%eax
  800976:	a8 03                	test   $0x3,%al
  800978:	75 21                	jne    80099b <memset+0x39>
		c &= 0xFF;
  80097a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097e:	89 d0                	mov    %edx,%eax
  800980:	c1 e0 08             	shl    $0x8,%eax
  800983:	89 d3                	mov    %edx,%ebx
  800985:	c1 e3 18             	shl    $0x18,%ebx
  800988:	89 d6                	mov    %edx,%esi
  80098a:	c1 e6 10             	shl    $0x10,%esi
  80098d:	09 f3                	or     %esi,%ebx
  80098f:	09 da                	or     %ebx,%edx
  800991:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800993:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800996:	fc                   	cld    
  800997:	f3 ab                	rep stos %eax,%es:(%edi)
  800999:	eb 06                	jmp    8009a1 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099e:	fc                   	cld    
  80099f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a1:	89 f8                	mov    %edi,%eax
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5f                   	pop    %edi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	57                   	push   %edi
  8009ac:	56                   	push   %esi
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b6:	39 c6                	cmp    %eax,%esi
  8009b8:	73 32                	jae    8009ec <memmove+0x44>
  8009ba:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009bd:	39 c2                	cmp    %eax,%edx
  8009bf:	76 2b                	jbe    8009ec <memmove+0x44>
		s += n;
		d += n;
  8009c1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c4:	89 d6                	mov    %edx,%esi
  8009c6:	09 fe                	or     %edi,%esi
  8009c8:	09 ce                	or     %ecx,%esi
  8009ca:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d0:	75 0e                	jne    8009e0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d2:	83 ef 04             	sub    $0x4,%edi
  8009d5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009db:	fd                   	std    
  8009dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009de:	eb 09                	jmp    8009e9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e0:	83 ef 01             	sub    $0x1,%edi
  8009e3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e6:	fd                   	std    
  8009e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e9:	fc                   	cld    
  8009ea:	eb 1a                	jmp    800a06 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 f2                	mov    %esi,%edx
  8009ee:	09 c2                	or     %eax,%edx
  8009f0:	09 ca                	or     %ecx,%edx
  8009f2:	f6 c2 03             	test   $0x3,%dl
  8009f5:	75 0a                	jne    800a01 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fa:	89 c7                	mov    %eax,%edi
  8009fc:	fc                   	cld    
  8009fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ff:	eb 05                	jmp    800a06 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a01:	89 c7                	mov    %eax,%edi
  800a03:	fc                   	cld    
  800a04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a06:	5e                   	pop    %esi
  800a07:	5f                   	pop    %edi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a10:	ff 75 10             	push   0x10(%ebp)
  800a13:	ff 75 0c             	push   0xc(%ebp)
  800a16:	ff 75 08             	push   0x8(%ebp)
  800a19:	e8 8a ff ff ff       	call   8009a8 <memmove>
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c6                	mov    %eax,%esi
  800a2d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a30:	eb 06                	jmp    800a38 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a38:	39 f0                	cmp    %esi,%eax
  800a3a:	74 14                	je     800a50 <memcmp+0x30>
		if (*s1 != *s2)
  800a3c:	0f b6 08             	movzbl (%eax),%ecx
  800a3f:	0f b6 1a             	movzbl (%edx),%ebx
  800a42:	38 d9                	cmp    %bl,%cl
  800a44:	74 ec                	je     800a32 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a46:	0f b6 c1             	movzbl %cl,%eax
  800a49:	0f b6 db             	movzbl %bl,%ebx
  800a4c:	29 d8                	sub    %ebx,%eax
  800a4e:	eb 05                	jmp    800a55 <memcmp+0x35>
	}

	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a62:	89 c2                	mov    %eax,%edx
  800a64:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a67:	eb 03                	jmp    800a6c <memfind+0x13>
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	39 d0                	cmp    %edx,%eax
  800a6e:	73 04                	jae    800a74 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a70:	38 08                	cmp    %cl,(%eax)
  800a72:	75 f5                	jne    800a69 <memfind+0x10>
			break;
	return (void *) s;
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a82:	eb 03                	jmp    800a87 <strtol+0x11>
		s++;
  800a84:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a87:	0f b6 02             	movzbl (%edx),%eax
  800a8a:	3c 20                	cmp    $0x20,%al
  800a8c:	74 f6                	je     800a84 <strtol+0xe>
  800a8e:	3c 09                	cmp    $0x9,%al
  800a90:	74 f2                	je     800a84 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a92:	3c 2b                	cmp    $0x2b,%al
  800a94:	74 2a                	je     800ac0 <strtol+0x4a>
	int neg = 0;
  800a96:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a9b:	3c 2d                	cmp    $0x2d,%al
  800a9d:	74 2b                	je     800aca <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa5:	75 0f                	jne    800ab6 <strtol+0x40>
  800aa7:	80 3a 30             	cmpb   $0x30,(%edx)
  800aaa:	74 28                	je     800ad4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aac:	85 db                	test   %ebx,%ebx
  800aae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab3:	0f 44 d8             	cmove  %eax,%ebx
  800ab6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abe:	eb 46                	jmp    800b06 <strtol+0x90>
		s++;
  800ac0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ac3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac8:	eb d5                	jmp    800a9f <strtol+0x29>
		s++, neg = 1;
  800aca:	83 c2 01             	add    $0x1,%edx
  800acd:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad2:	eb cb                	jmp    800a9f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad4:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ad8:	74 0e                	je     800ae8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ada:	85 db                	test   %ebx,%ebx
  800adc:	75 d8                	jne    800ab6 <strtol+0x40>
		s++, base = 8;
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae6:	eb ce                	jmp    800ab6 <strtol+0x40>
		s += 2, base = 16;
  800ae8:	83 c2 02             	add    $0x2,%edx
  800aeb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af0:	eb c4                	jmp    800ab6 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800af2:	0f be c0             	movsbl %al,%eax
  800af5:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800afb:	7d 3a                	jge    800b37 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800afd:	83 c2 01             	add    $0x1,%edx
  800b00:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b04:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b06:	0f b6 02             	movzbl (%edx),%eax
  800b09:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b0c:	89 f3                	mov    %esi,%ebx
  800b0e:	80 fb 09             	cmp    $0x9,%bl
  800b11:	76 df                	jbe    800af2 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b13:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b16:	89 f3                	mov    %esi,%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b1d:	0f be c0             	movsbl %al,%eax
  800b20:	83 e8 57             	sub    $0x57,%eax
  800b23:	eb d3                	jmp    800af8 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b25:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b28:	89 f3                	mov    %esi,%ebx
  800b2a:	80 fb 19             	cmp    $0x19,%bl
  800b2d:	77 08                	ja     800b37 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b2f:	0f be c0             	movsbl %al,%eax
  800b32:	83 e8 37             	sub    $0x37,%eax
  800b35:	eb c1                	jmp    800af8 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3b:	74 05                	je     800b42 <strtol+0xcc>
		*endptr = (char *) s;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b42:	89 c8                	mov    %ecx,%eax
  800b44:	f7 d8                	neg    %eax
  800b46:	85 ff                	test   %edi,%edi
  800b48:	0f 45 c8             	cmovne %eax,%ecx
}
  800b4b:	89 c8                	mov    %ecx,%eax
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b63:	89 c3                	mov    %eax,%ebx
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	89 c6                	mov    %eax,%esi
  800b69:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba5:	89 cb                	mov    %ecx,%ebx
  800ba7:	89 cf                	mov    %ecx,%edi
  800ba9:	89 ce                	mov    %ecx,%esi
  800bab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bad:	85 c0                	test   %eax,%eax
  800baf:	7f 08                	jg     800bb9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5f                   	pop    %edi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb9:	83 ec 0c             	sub    $0xc,%esp
  800bbc:	50                   	push   %eax
  800bbd:	6a 03                	push   $0x3
  800bbf:	68 bf 13 80 00       	push   $0x8013bf
  800bc4:	6a 23                	push   $0x23
  800bc6:	68 dc 13 80 00       	push   $0x8013dc
  800bcb:	e8 2f 02 00 00       	call   800dff <_panic>

00800bd0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 02 00 00 00       	mov    $0x2,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_yield>:

void
sys_yield(void)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bff:	89 d1                	mov    %edx,%ecx
  800c01:	89 d3                	mov    %edx,%ebx
  800c03:	89 d7                	mov    %edx,%edi
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	be 00 00 00 00       	mov    $0x0,%esi
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 04 00 00 00       	mov    $0x4,%eax
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2a:	89 f7                	mov    %esi,%edi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 04                	push   $0x4
  800c40:	68 bf 13 80 00       	push   $0x8013bf
  800c45:	6a 23                	push   $0x23
  800c47:	68 dc 13 80 00       	push   $0x8013dc
  800c4c:	e8 ae 01 00 00       	call   800dff <_panic>

00800c51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	57                   	push   %edi
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
  800c57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	b8 05 00 00 00       	mov    $0x5,%eax
  800c65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c70:	85 c0                	test   %eax,%eax
  800c72:	7f 08                	jg     800c7c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5f                   	pop    %edi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7c:	83 ec 0c             	sub    $0xc,%esp
  800c7f:	50                   	push   %eax
  800c80:	6a 05                	push   $0x5
  800c82:	68 bf 13 80 00       	push   $0x8013bf
  800c87:	6a 23                	push   $0x23
  800c89:	68 dc 13 80 00       	push   $0x8013dc
  800c8e:	e8 6c 01 00 00       	call   800dff <_panic>

00800c93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca7:	b8 06 00 00 00       	mov    $0x6,%eax
  800cac:	89 df                	mov    %ebx,%edi
  800cae:	89 de                	mov    %ebx,%esi
  800cb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7f 08                	jg     800cbe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	50                   	push   %eax
  800cc2:	6a 06                	push   $0x6
  800cc4:	68 bf 13 80 00       	push   $0x8013bf
  800cc9:	6a 23                	push   $0x23
  800ccb:	68 dc 13 80 00       	push   $0x8013dc
  800cd0:	e8 2a 01 00 00       	call   800dff <_panic>

00800cd5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cee:	89 df                	mov    %ebx,%edi
  800cf0:	89 de                	mov    %ebx,%esi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 08                	push   $0x8
  800d06:	68 bf 13 80 00       	push   $0x8013bf
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 dc 13 80 00       	push   $0x8013dc
  800d12:	e8 e8 00 00 00       	call   800dff <_panic>

00800d17 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	89 de                	mov    %ebx,%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 09                	push   $0x9
  800d48:	68 bf 13 80 00       	push   $0x8013bf
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 dc 13 80 00       	push   $0x8013dc
  800d54:	e8 a6 00 00 00       	call   800dff <_panic>

00800d59 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 0a                	push   $0xa
  800d8a:	68 bf 13 80 00       	push   $0x8013bf
  800d8f:	6a 23                	push   $0x23
  800d91:	68 dc 13 80 00       	push   $0x8013dc
  800d96:	e8 64 00 00 00       	call   800dff <_panic>

00800d9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
  800dc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd4:	89 cb                	mov    %ecx,%ebx
  800dd6:	89 cf                	mov    %ecx,%edi
  800dd8:	89 ce                	mov    %ecx,%esi
  800dda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7f 08                	jg     800de8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de8:	83 ec 0c             	sub    $0xc,%esp
  800deb:	50                   	push   %eax
  800dec:	6a 0d                	push   $0xd
  800dee:	68 bf 13 80 00       	push   $0x8013bf
  800df3:	6a 23                	push   $0x23
  800df5:	68 dc 13 80 00       	push   $0x8013dc
  800dfa:	e8 00 00 00 00       	call   800dff <_panic>

00800dff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e04:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e07:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e0d:	e8 be fd ff ff       	call   800bd0 <sys_getenvid>
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	ff 75 0c             	push   0xc(%ebp)
  800e18:	ff 75 08             	push   0x8(%ebp)
  800e1b:	56                   	push   %esi
  800e1c:	50                   	push   %eax
  800e1d:	68 ec 13 80 00       	push   $0x8013ec
  800e22:	e8 26 f3 ff ff       	call   80014d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e27:	83 c4 18             	add    $0x18,%esp
  800e2a:	53                   	push   %ebx
  800e2b:	ff 75 10             	push   0x10(%ebp)
  800e2e:	e8 c9 f2 ff ff       	call   8000fc <vcprintf>
	cprintf("\n");
  800e33:	c7 04 24 ac 10 80 00 	movl   $0x8010ac,(%esp)
  800e3a:	e8 0e f3 ff ff       	call   80014d <cprintf>
  800e3f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e42:	cc                   	int3   
  800e43:	eb fd                	jmp    800e42 <_panic+0x43>
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
