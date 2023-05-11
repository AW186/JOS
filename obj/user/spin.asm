
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 20 14 80 00       	push   $0x801420
  80003f:	e8 5e 01 00 00       	call   8001a2 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 0a 0f 00 00       	call   800f53 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 98 14 80 00       	push   $0x801498
  800058:	e8 45 01 00 00       	call   8001a2 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 48 14 80 00       	push   $0x801448
  80006c:	e8 31 01 00 00       	call   8001a2 <cprintf>
	sys_yield();
  800071:	e8 ce 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  800076:	e8 c9 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  80007b:	e8 c4 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  800080:	e8 bf 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  800085:	e8 ba 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  80008a:	e8 b5 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  80008f:	e8 b0 0b 00 00       	call   800c44 <sys_yield>
	sys_yield();
  800094:	e8 ab 0b 00 00       	call   800c44 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 70 14 80 00 	movl   $0x801470,(%esp)
  8000a0:	e8 fd 00 00 00       	call   8001a2 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 37 0b 00 00       	call   800be4 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 60 0b 00 00       	call   800c25 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800101:	6a 00                	push   $0x0
  800103:	e8 dc 0a 00 00       	call   800be4 <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	53                   	push   %ebx
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800117:	8b 13                	mov    (%ebx),%edx
  800119:	8d 42 01             	lea    0x1(%edx),%eax
  80011c:	89 03                	mov    %eax,(%ebx)
  80011e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800121:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800125:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012a:	74 09                	je     800135 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800133:	c9                   	leave  
  800134:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 ff 00 00 00       	push   $0xff
  80013d:	8d 43 08             	lea    0x8(%ebx),%eax
  800140:	50                   	push   %eax
  800141:	e8 61 0a 00 00       	call   800ba7 <sys_cputs>
		b->idx = 0;
  800146:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	eb db                	jmp    80012c <putch+0x1f>

00800151 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800161:	00 00 00 
	b.cnt = 0;
  800164:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016e:	ff 75 0c             	push   0xc(%ebp)
  800171:	ff 75 08             	push   0x8(%ebp)
  800174:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	68 0d 01 80 00       	push   $0x80010d
  800180:	e8 14 01 00 00       	call   800299 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800185:	83 c4 08             	add    $0x8,%esp
  800188:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80018e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 0d 0a 00 00       	call   800ba7 <sys_cputs>

	return b.cnt;
}
  80019a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 08             	push   0x8(%ebp)
  8001af:	e8 9d ff ff ff       	call   800151 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	57                   	push   %edi
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 1c             	sub    $0x1c,%esp
  8001bf:	89 c7                	mov    %eax,%edi
  8001c1:	89 d6                	mov    %edx,%esi
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	89 c2                	mov    %eax,%edx
  8001cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e3:	39 c2                	cmp    %eax,%edx
  8001e5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001e8:	72 3e                	jb     800228 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	ff 75 18             	push   0x18(%ebp)
  8001f0:	83 eb 01             	sub    $0x1,%ebx
  8001f3:	53                   	push   %ebx
  8001f4:	50                   	push   %eax
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 e4             	push   -0x1c(%ebp)
  8001fb:	ff 75 e0             	push   -0x20(%ebp)
  8001fe:	ff 75 dc             	push   -0x24(%ebp)
  800201:	ff 75 d8             	push   -0x28(%ebp)
  800204:	e8 c7 0f 00 00       	call   8011d0 <__udivdi3>
  800209:	83 c4 18             	add    $0x18,%esp
  80020c:	52                   	push   %edx
  80020d:	50                   	push   %eax
  80020e:	89 f2                	mov    %esi,%edx
  800210:	89 f8                	mov    %edi,%eax
  800212:	e8 9f ff ff ff       	call   8001b6 <printnum>
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	eb 13                	jmp    80022f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	56                   	push   %esi
  800220:	ff 75 18             	push   0x18(%ebp)
  800223:	ff d7                	call   *%edi
  800225:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800228:	83 eb 01             	sub    $0x1,%ebx
  80022b:	85 db                	test   %ebx,%ebx
  80022d:	7f ed                	jg     80021c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	56                   	push   %esi
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	ff 75 e4             	push   -0x1c(%ebp)
  800239:	ff 75 e0             	push   -0x20(%ebp)
  80023c:	ff 75 dc             	push   -0x24(%ebp)
  80023f:	ff 75 d8             	push   -0x28(%ebp)
  800242:	e8 a9 10 00 00       	call   8012f0 <__umoddi3>
  800247:	83 c4 14             	add    $0x14,%esp
  80024a:	0f be 80 c0 14 80 00 	movsbl 0x8014c0(%eax),%eax
  800251:	50                   	push   %eax
  800252:	ff d7                	call   *%edi
}
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5f                   	pop    %edi
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800265:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800269:	8b 10                	mov    (%eax),%edx
  80026b:	3b 50 04             	cmp    0x4(%eax),%edx
  80026e:	73 0a                	jae    80027a <sprintputch+0x1b>
		*b->buf++ = ch;
  800270:	8d 4a 01             	lea    0x1(%edx),%ecx
  800273:	89 08                	mov    %ecx,(%eax)
  800275:	8b 45 08             	mov    0x8(%ebp),%eax
  800278:	88 02                	mov    %al,(%edx)
}
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <printfmt>:
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800282:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800285:	50                   	push   %eax
  800286:	ff 75 10             	push   0x10(%ebp)
  800289:	ff 75 0c             	push   0xc(%ebp)
  80028c:	ff 75 08             	push   0x8(%ebp)
  80028f:	e8 05 00 00 00       	call   800299 <vprintfmt>
}
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <vprintfmt>:
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 3c             	sub    $0x3c,%esp
  8002a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ab:	eb 0a                	jmp    8002b7 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	53                   	push   %ebx
  8002b1:	50                   	push   %eax
  8002b2:	ff d6                	call   *%esi
  8002b4:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002b7:	83 c7 01             	add    $0x1,%edi
  8002ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002be:	83 f8 25             	cmp    $0x25,%eax
  8002c1:	74 0c                	je     8002cf <vprintfmt+0x36>
			if (ch == '\0')
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	75 e6                	jne    8002ad <vprintfmt+0x14>
}
  8002c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    
		padc = ' ';
  8002cf:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002d3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002e1:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002e8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002ed:	8d 47 01             	lea    0x1(%edi),%eax
  8002f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f3:	0f b6 17             	movzbl (%edi),%edx
  8002f6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f9:	3c 55                	cmp    $0x55,%al
  8002fb:	0f 87 a6 04 00 00    	ja     8007a7 <vprintfmt+0x50e>
  800301:	0f b6 c0             	movzbl %al,%eax
  800304:	ff 24 85 00 16 80 00 	jmp    *0x801600(,%eax,4)
  80030b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80030e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800312:	eb d9                	jmp    8002ed <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800314:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800317:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80031b:	eb d0                	jmp    8002ed <vprintfmt+0x54>
  80031d:	0f b6 d2             	movzbl %dl,%edx
  800320:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
  800328:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80032b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800332:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800335:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800338:	83 f9 09             	cmp    $0x9,%ecx
  80033b:	77 55                	ja     800392 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80033d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800340:	eb e9                	jmp    80032b <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	8b 00                	mov    (%eax),%eax
  800347:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034a:	8b 45 14             	mov    0x14(%ebp),%eax
  80034d:	8d 40 04             	lea    0x4(%eax),%eax
  800350:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800356:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80035a:	79 91                	jns    8002ed <vprintfmt+0x54>
				width = precision, precision = -1;
  80035c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800362:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800369:	eb 82                	jmp    8002ed <vprintfmt+0x54>
  80036b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80036e:	85 d2                	test   %edx,%edx
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	0f 49 c2             	cmovns %edx,%eax
  800378:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80037e:	e9 6a ff ff ff       	jmp    8002ed <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800386:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80038d:	e9 5b ff ff ff       	jmp    8002ed <vprintfmt+0x54>
  800392:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800395:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800398:	eb bc                	jmp    800356 <vprintfmt+0xbd>
			lflag++;
  80039a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003a0:	e9 48 ff ff ff       	jmp    8002ed <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8d 78 04             	lea    0x4(%eax),%edi
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	53                   	push   %ebx
  8003af:	ff 30                	push   (%eax)
  8003b1:	ff d6                	call   *%esi
			break;
  8003b3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b9:	e9 88 03 00 00       	jmp    800746 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	8b 10                	mov    (%eax),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	f7 d8                	neg    %eax
  8003ca:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003cd:	83 f8 0f             	cmp    $0xf,%eax
  8003d0:	7f 23                	jg     8003f5 <vprintfmt+0x15c>
  8003d2:	8b 14 85 60 17 80 00 	mov    0x801760(,%eax,4),%edx
  8003d9:	85 d2                	test   %edx,%edx
  8003db:	74 18                	je     8003f5 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003dd:	52                   	push   %edx
  8003de:	68 e1 14 80 00       	push   $0x8014e1
  8003e3:	53                   	push   %ebx
  8003e4:	56                   	push   %esi
  8003e5:	e8 92 fe ff ff       	call   80027c <printfmt>
  8003ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f0:	e9 51 03 00 00       	jmp    800746 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003f5:	50                   	push   %eax
  8003f6:	68 d8 14 80 00       	push   $0x8014d8
  8003fb:	53                   	push   %ebx
  8003fc:	56                   	push   %esi
  8003fd:	e8 7a fe ff ff       	call   80027c <printfmt>
  800402:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800405:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800408:	e9 39 03 00 00       	jmp    800746 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80041b:	85 d2                	test   %edx,%edx
  80041d:	b8 d1 14 80 00       	mov    $0x8014d1,%eax
  800422:	0f 45 c2             	cmovne %edx,%eax
  800425:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800428:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80042c:	7e 06                	jle    800434 <vprintfmt+0x19b>
  80042e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800432:	75 0d                	jne    800441 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800434:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800437:	89 c7                	mov    %eax,%edi
  800439:	03 45 d4             	add    -0x2c(%ebp),%eax
  80043c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80043f:	eb 55                	jmp    800496 <vprintfmt+0x1fd>
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 e0             	push   -0x20(%ebp)
  800447:	ff 75 cc             	push   -0x34(%ebp)
  80044a:	e8 f5 03 00 00       	call   800844 <strnlen>
  80044f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800452:	29 c2                	sub    %eax,%edx
  800454:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800457:	83 c4 10             	add    $0x10,%esp
  80045a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80045c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800460:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800463:	eb 0f                	jmp    800474 <vprintfmt+0x1db>
					putch(padc, putdat);
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	53                   	push   %ebx
  800469:	ff 75 d4             	push   -0x2c(%ebp)
  80046c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80046e:	83 ef 01             	sub    $0x1,%edi
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	85 ff                	test   %edi,%edi
  800476:	7f ed                	jg     800465 <vprintfmt+0x1cc>
  800478:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80047b:	85 d2                	test   %edx,%edx
  80047d:	b8 00 00 00 00       	mov    $0x0,%eax
  800482:	0f 49 c2             	cmovns %edx,%eax
  800485:	29 c2                	sub    %eax,%edx
  800487:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80048a:	eb a8                	jmp    800434 <vprintfmt+0x19b>
					putch(ch, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	52                   	push   %edx
  800491:	ff d6                	call   *%esi
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800499:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049b:	83 c7 01             	add    $0x1,%edi
  80049e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a2:	0f be d0             	movsbl %al,%edx
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 4b                	je     8004f4 <vprintfmt+0x25b>
  8004a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ad:	78 06                	js     8004b5 <vprintfmt+0x21c>
  8004af:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004b3:	78 1e                	js     8004d3 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	74 d1                	je     80048c <vprintfmt+0x1f3>
  8004bb:	0f be c0             	movsbl %al,%eax
  8004be:	83 e8 20             	sub    $0x20,%eax
  8004c1:	83 f8 5e             	cmp    $0x5e,%eax
  8004c4:	76 c6                	jbe    80048c <vprintfmt+0x1f3>
					putch('?', putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	6a 3f                	push   $0x3f
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	eb c3                	jmp    800496 <vprintfmt+0x1fd>
  8004d3:	89 cf                	mov    %ecx,%edi
  8004d5:	eb 0e                	jmp    8004e5 <vprintfmt+0x24c>
				putch(' ', putdat);
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	53                   	push   %ebx
  8004db:	6a 20                	push   $0x20
  8004dd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 ff                	test   %edi,%edi
  8004e7:	7f ee                	jg     8004d7 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ef:	e9 52 02 00 00       	jmp    800746 <vprintfmt+0x4ad>
  8004f4:	89 cf                	mov    %ecx,%edi
  8004f6:	eb ed                	jmp    8004e5 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800506:	85 d2                	test   %edx,%edx
  800508:	b8 d1 14 80 00       	mov    $0x8014d1,%eax
  80050d:	0f 45 c2             	cmovne %edx,%eax
  800510:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800513:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800517:	7e 06                	jle    80051f <vprintfmt+0x286>
  800519:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80051d:	75 0d                	jne    80052c <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800522:	89 c7                	mov    %eax,%edi
  800524:	03 45 d4             	add    -0x2c(%ebp),%eax
  800527:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80052a:	eb 55                	jmp    800581 <vprintfmt+0x2e8>
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	ff 75 e0             	push   -0x20(%ebp)
  800532:	ff 75 cc             	push   -0x34(%ebp)
  800535:	e8 0a 03 00 00       	call   800844 <strnlen>
  80053a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80053d:	29 c2                	sub    %eax,%edx
  80053f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800547:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80054b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80054e:	eb 0f                	jmp    80055f <vprintfmt+0x2c6>
					putch(padc, putdat);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	53                   	push   %ebx
  800554:	ff 75 d4             	push   -0x2c(%ebp)
  800557:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800559:	83 ef 01             	sub    $0x1,%edi
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	85 ff                	test   %edi,%edi
  800561:	7f ed                	jg     800550 <vprintfmt+0x2b7>
  800563:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800566:	85 d2                	test   %edx,%edx
  800568:	b8 00 00 00 00       	mov    $0x0,%eax
  80056d:	0f 49 c2             	cmovns %edx,%eax
  800570:	29 c2                	sub    %eax,%edx
  800572:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800575:	eb a8                	jmp    80051f <vprintfmt+0x286>
					putch(ch, putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	53                   	push   %ebx
  80057b:	52                   	push   %edx
  80057c:	ff d6                	call   *%esi
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800584:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800586:	83 c7 01             	add    $0x1,%edi
  800589:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80058d:	0f be d0             	movsbl %al,%edx
  800590:	3c 3a                	cmp    $0x3a,%al
  800592:	74 4b                	je     8005df <vprintfmt+0x346>
  800594:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800598:	78 06                	js     8005a0 <vprintfmt+0x307>
  80059a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80059e:	78 1e                	js     8005be <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a4:	74 d1                	je     800577 <vprintfmt+0x2de>
  8005a6:	0f be c0             	movsbl %al,%eax
  8005a9:	83 e8 20             	sub    $0x20,%eax
  8005ac:	83 f8 5e             	cmp    $0x5e,%eax
  8005af:	76 c6                	jbe    800577 <vprintfmt+0x2de>
					putch('?', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 3f                	push   $0x3f
  8005b7:	ff d6                	call   *%esi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	eb c3                	jmp    800581 <vprintfmt+0x2e8>
  8005be:	89 cf                	mov    %ecx,%edi
  8005c0:	eb 0e                	jmp    8005d0 <vprintfmt+0x337>
				putch(' ', putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 20                	push   $0x20
  8005c8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005ca:	83 ef 01             	sub    $0x1,%edi
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	85 ff                	test   %edi,%edi
  8005d2:	7f ee                	jg     8005c2 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005da:	e9 67 01 00 00       	jmp    800746 <vprintfmt+0x4ad>
  8005df:	89 cf                	mov    %ecx,%edi
  8005e1:	eb ed                	jmp    8005d0 <vprintfmt+0x337>
	if (lflag >= 2)
  8005e3:	83 f9 01             	cmp    $0x1,%ecx
  8005e6:	7f 1b                	jg     800603 <vprintfmt+0x36a>
	else if (lflag)
  8005e8:	85 c9                	test   %ecx,%ecx
  8005ea:	74 63                	je     80064f <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f4:	99                   	cltd   
  8005f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 04             	lea    0x4(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800601:	eb 17                	jmp    80061a <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 50 04             	mov    0x4(%eax),%edx
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 40 08             	lea    0x8(%eax),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80061a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800620:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800625:	85 c9                	test   %ecx,%ecx
  800627:	0f 89 ff 00 00 00    	jns    80072c <vprintfmt+0x493>
				putch('-', putdat);
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	6a 2d                	push   $0x2d
  800633:	ff d6                	call   *%esi
				num = -(long long) num;
  800635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800638:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80063b:	f7 da                	neg    %edx
  80063d:	83 d1 00             	adc    $0x0,%ecx
  800640:	f7 d9                	neg    %ecx
  800642:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800645:	bf 0a 00 00 00       	mov    $0xa,%edi
  80064a:	e9 dd 00 00 00       	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800657:	99                   	cltd   
  800658:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	eb b4                	jmp    80061a <vprintfmt+0x381>
	if (lflag >= 2)
  800666:	83 f9 01             	cmp    $0x1,%ecx
  800669:	7f 1e                	jg     800689 <vprintfmt+0x3f0>
	else if (lflag)
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	74 32                	je     8006a1 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 10                	mov    (%eax),%edx
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067f:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800684:	e9 a3 00 00 00       	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
  80068e:	8b 48 04             	mov    0x4(%eax),%ecx
  800691:	8d 40 08             	lea    0x8(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800697:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80069c:	e9 8b 00 00 00       	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 10                	mov    (%eax),%edx
  8006a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b1:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006b6:	eb 74                	jmp    80072c <vprintfmt+0x493>
	if (lflag >= 2)
  8006b8:	83 f9 01             	cmp    $0x1,%ecx
  8006bb:	7f 1b                	jg     8006d8 <vprintfmt+0x43f>
	else if (lflag)
  8006bd:	85 c9                	test   %ecx,%ecx
  8006bf:	74 2c                	je     8006ed <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 10                	mov    (%eax),%edx
  8006c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d1:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006d6:	eb 54                	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 10                	mov    (%eax),%edx
  8006dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e0:	8d 40 08             	lea    0x8(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e6:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006eb:	eb 3f                	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 10                	mov    (%eax),%edx
  8006f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006fd:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800702:	eb 28                	jmp    80072c <vprintfmt+0x493>
			putch('0', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 30                	push   $0x30
  80070a:	ff d6                	call   *%esi
			putch('x', putdat);
  80070c:	83 c4 08             	add    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 78                	push   $0x78
  800712:	ff d6                	call   *%esi
			num = (unsigned long long)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 10                	mov    (%eax),%edx
  800719:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80071e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800727:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	ff 75 d4             	push   -0x2c(%ebp)
  800737:	57                   	push   %edi
  800738:	51                   	push   %ecx
  800739:	52                   	push   %edx
  80073a:	89 da                	mov    %ebx,%edx
  80073c:	89 f0                	mov    %esi,%eax
  80073e:	e8 73 fa ff ff       	call   8001b6 <printnum>
			break;
  800743:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800746:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800749:	e9 69 fb ff ff       	jmp    8002b7 <vprintfmt+0x1e>
	if (lflag >= 2)
  80074e:	83 f9 01             	cmp    $0x1,%ecx
  800751:	7f 1b                	jg     80076e <vprintfmt+0x4d5>
	else if (lflag)
  800753:	85 c9                	test   %ecx,%ecx
  800755:	74 2c                	je     800783 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 10                	mov    (%eax),%edx
  80075c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800767:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  80076c:	eb be                	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 10                	mov    (%eax),%edx
  800773:	8b 48 04             	mov    0x4(%eax),%ecx
  800776:	8d 40 08             	lea    0x8(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800781:	eb a9                	jmp    80072c <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 10                	mov    (%eax),%edx
  800788:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800793:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800798:	eb 92                	jmp    80072c <vprintfmt+0x493>
			putch(ch, putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 25                	push   $0x25
  8007a0:	ff d6                	call   *%esi
			break;
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	eb 9f                	jmp    800746 <vprintfmt+0x4ad>
			putch('%', putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 25                	push   $0x25
  8007ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	89 f8                	mov    %edi,%eax
  8007b4:	eb 03                	jmp    8007b9 <vprintfmt+0x520>
  8007b6:	83 e8 01             	sub    $0x1,%eax
  8007b9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007bd:	75 f7                	jne    8007b6 <vprintfmt+0x51d>
  8007bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007c2:	eb 82                	jmp    800746 <vprintfmt+0x4ad>

008007c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	83 ec 18             	sub    $0x18,%esp
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	74 26                	je     80080b <vsnprintf+0x47>
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	7e 22                	jle    80080b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e9:	ff 75 14             	push   0x14(%ebp)
  8007ec:	ff 75 10             	push   0x10(%ebp)
  8007ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f2:	50                   	push   %eax
  8007f3:	68 5f 02 80 00       	push   $0x80025f
  8007f8:	e8 9c fa ff ff       	call   800299 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800800:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800806:	83 c4 10             	add    $0x10,%esp
}
  800809:	c9                   	leave  
  80080a:	c3                   	ret    
		return -E_INVAL;
  80080b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800810:	eb f7                	jmp    800809 <vsnprintf+0x45>

00800812 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800818:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80081b:	50                   	push   %eax
  80081c:	ff 75 10             	push   0x10(%ebp)
  80081f:	ff 75 0c             	push   0xc(%ebp)
  800822:	ff 75 08             	push   0x8(%ebp)
  800825:	e8 9a ff ff ff       	call   8007c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800832:	b8 00 00 00 00       	mov    $0x0,%eax
  800837:	eb 03                	jmp    80083c <strlen+0x10>
		n++;
  800839:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80083c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800840:	75 f7                	jne    800839 <strlen+0xd>
	return n;
}
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084d:	b8 00 00 00 00       	mov    $0x0,%eax
  800852:	eb 03                	jmp    800857 <strnlen+0x13>
		n++;
  800854:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800857:	39 d0                	cmp    %edx,%eax
  800859:	74 08                	je     800863 <strnlen+0x1f>
  80085b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80085f:	75 f3                	jne    800854 <strnlen+0x10>
  800861:	89 c2                	mov    %eax,%edx
	return n;
}
  800863:	89 d0                	mov    %edx,%eax
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80087a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80087d:	83 c0 01             	add    $0x1,%eax
  800880:	84 d2                	test   %dl,%dl
  800882:	75 f2                	jne    800876 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800884:	89 c8                	mov    %ecx,%eax
  800886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800889:	c9                   	leave  
  80088a:	c3                   	ret    

0080088b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	83 ec 10             	sub    $0x10,%esp
  800892:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800895:	53                   	push   %ebx
  800896:	e8 91 ff ff ff       	call   80082c <strlen>
  80089b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80089e:	ff 75 0c             	push   0xc(%ebp)
  8008a1:	01 d8                	add    %ebx,%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 be ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008a9:	89 d8                	mov    %ebx,%eax
  8008ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	56                   	push   %esi
  8008b4:	53                   	push   %ebx
  8008b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	89 f3                	mov    %esi,%ebx
  8008bd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c0:	89 f0                	mov    %esi,%eax
  8008c2:	eb 0f                	jmp    8008d3 <strncpy+0x23>
		*dst++ = *src;
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	0f b6 0a             	movzbl (%edx),%ecx
  8008ca:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cd:	80 f9 01             	cmp    $0x1,%cl
  8008d0:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8008d3:	39 d8                	cmp    %ebx,%eax
  8008d5:	75 ed                	jne    8008c4 <strncpy+0x14>
	}
	return ret;
}
  8008d7:	89 f0                	mov    %esi,%eax
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e8:	8b 55 10             	mov    0x10(%ebp),%edx
  8008eb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ed:	85 d2                	test   %edx,%edx
  8008ef:	74 21                	je     800912 <strlcpy+0x35>
  8008f1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f5:	89 f2                	mov    %esi,%edx
  8008f7:	eb 09                	jmp    800902 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c1 01             	add    $0x1,%ecx
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800902:	39 c2                	cmp    %eax,%edx
  800904:	74 09                	je     80090f <strlcpy+0x32>
  800906:	0f b6 19             	movzbl (%ecx),%ebx
  800909:	84 db                	test   %bl,%bl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1c>
  80090d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800912:	29 f0                	sub    %esi,%eax
}
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800921:	eb 06                	jmp    800929 <strcmp+0x11>
		p++, q++;
  800923:	83 c1 01             	add    $0x1,%ecx
  800926:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	84 c0                	test   %al,%al
  80092e:	74 04                	je     800934 <strcmp+0x1c>
  800930:	3a 02                	cmp    (%edx),%al
  800932:	74 ef                	je     800923 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 c0             	movzbl %al,%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	53                   	push   %ebx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
  800948:	89 c3                	mov    %eax,%ebx
  80094a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80094d:	eb 06                	jmp    800955 <strncmp+0x17>
		n--, p++, q++;
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800955:	39 d8                	cmp    %ebx,%eax
  800957:	74 18                	je     800971 <strncmp+0x33>
  800959:	0f b6 08             	movzbl (%eax),%ecx
  80095c:	84 c9                	test   %cl,%cl
  80095e:	74 04                	je     800964 <strncmp+0x26>
  800960:	3a 0a                	cmp    (%edx),%cl
  800962:	74 eb                	je     80094f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800964:	0f b6 00             	movzbl (%eax),%eax
  800967:	0f b6 12             	movzbl (%edx),%edx
  80096a:	29 d0                	sub    %edx,%eax
}
  80096c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096f:	c9                   	leave  
  800970:	c3                   	ret    
		return 0;
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
  800976:	eb f4                	jmp    80096c <strncmp+0x2e>

00800978 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800982:	eb 03                	jmp    800987 <strchr+0xf>
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	0f b6 10             	movzbl (%eax),%edx
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 06                	je     800994 <strchr+0x1c>
		if (*s == c)
  80098e:	38 ca                	cmp    %cl,%dl
  800990:	75 f2                	jne    800984 <strchr+0xc>
  800992:	eb 05                	jmp    800999 <strchr+0x21>
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009a8:	38 ca                	cmp    %cl,%dl
  8009aa:	74 09                	je     8009b5 <strfind+0x1a>
  8009ac:	84 d2                	test   %dl,%dl
  8009ae:	74 05                	je     8009b5 <strfind+0x1a>
	for (; *s; s++)
  8009b0:	83 c0 01             	add    $0x1,%eax
  8009b3:	eb f0                	jmp    8009a5 <strfind+0xa>
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 2f                	je     8009f6 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	89 f8                	mov    %edi,%eax
  8009c9:	09 c8                	or     %ecx,%eax
  8009cb:	a8 03                	test   $0x3,%al
  8009cd:	75 21                	jne    8009f0 <memset+0x39>
		c &= 0xFF;
  8009cf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	c1 e0 08             	shl    $0x8,%eax
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 18             	shl    $0x18,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 10             	shl    $0x10,%esi
  8009e2:	09 f3                	or     %esi,%ebx
  8009e4:	09 da                	or     %ebx,%edx
  8009e6:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009e8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009eb:	fc                   	cld    
  8009ec:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ee:	eb 06                	jmp    8009f6 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	fc                   	cld    
  8009f4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009f6:	89 f8                	mov    %edi,%eax
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5f                   	pop    %edi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	57                   	push   %edi
  800a01:	56                   	push   %esi
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a0b:	39 c6                	cmp    %eax,%esi
  800a0d:	73 32                	jae    800a41 <memmove+0x44>
  800a0f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a12:	39 c2                	cmp    %eax,%edx
  800a14:	76 2b                	jbe    800a41 <memmove+0x44>
		s += n;
		d += n;
  800a16:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a19:	89 d6                	mov    %edx,%esi
  800a1b:	09 fe                	or     %edi,%esi
  800a1d:	09 ce                	or     %ecx,%esi
  800a1f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a25:	75 0e                	jne    800a35 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a27:	83 ef 04             	sub    $0x4,%edi
  800a2a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a30:	fd                   	std    
  800a31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a33:	eb 09                	jmp    800a3e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a35:	83 ef 01             	sub    $0x1,%edi
  800a38:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a3b:	fd                   	std    
  800a3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3e:	fc                   	cld    
  800a3f:	eb 1a                	jmp    800a5b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a41:	89 f2                	mov    %esi,%edx
  800a43:	09 c2                	or     %eax,%edx
  800a45:	09 ca                	or     %ecx,%edx
  800a47:	f6 c2 03             	test   $0x3,%dl
  800a4a:	75 0a                	jne    800a56 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4f:	89 c7                	mov    %eax,%edi
  800a51:	fc                   	cld    
  800a52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a54:	eb 05                	jmp    800a5b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a56:	89 c7                	mov    %eax,%edi
  800a58:	fc                   	cld    
  800a59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a5b:	5e                   	pop    %esi
  800a5c:	5f                   	pop    %edi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a65:	ff 75 10             	push   0x10(%ebp)
  800a68:	ff 75 0c             	push   0xc(%ebp)
  800a6b:	ff 75 08             	push   0x8(%ebp)
  800a6e:	e8 8a ff ff ff       	call   8009fd <memmove>
}
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 c6                	mov    %eax,%esi
  800a82:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a85:	eb 06                	jmp    800a8d <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a8d:	39 f0                	cmp    %esi,%eax
  800a8f:	74 14                	je     800aa5 <memcmp+0x30>
		if (*s1 != *s2)
  800a91:	0f b6 08             	movzbl (%eax),%ecx
  800a94:	0f b6 1a             	movzbl (%edx),%ebx
  800a97:	38 d9                	cmp    %bl,%cl
  800a99:	74 ec                	je     800a87 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a9b:	0f b6 c1             	movzbl %cl,%eax
  800a9e:	0f b6 db             	movzbl %bl,%ebx
  800aa1:	29 d8                	sub    %ebx,%eax
  800aa3:	eb 05                	jmp    800aaa <memcmp+0x35>
	}

	return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab7:	89 c2                	mov    %eax,%edx
  800ab9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800abc:	eb 03                	jmp    800ac1 <memfind+0x13>
  800abe:	83 c0 01             	add    $0x1,%eax
  800ac1:	39 d0                	cmp    %edx,%eax
  800ac3:	73 04                	jae    800ac9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac5:	38 08                	cmp    %cl,(%eax)
  800ac7:	75 f5                	jne    800abe <memfind+0x10>
			break;
	return (void *) s;
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	57                   	push   %edi
  800acf:	56                   	push   %esi
  800ad0:	53                   	push   %ebx
  800ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad7:	eb 03                	jmp    800adc <strtol+0x11>
		s++;
  800ad9:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800adc:	0f b6 02             	movzbl (%edx),%eax
  800adf:	3c 20                	cmp    $0x20,%al
  800ae1:	74 f6                	je     800ad9 <strtol+0xe>
  800ae3:	3c 09                	cmp    $0x9,%al
  800ae5:	74 f2                	je     800ad9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ae7:	3c 2b                	cmp    $0x2b,%al
  800ae9:	74 2a                	je     800b15 <strtol+0x4a>
	int neg = 0;
  800aeb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af0:	3c 2d                	cmp    $0x2d,%al
  800af2:	74 2b                	je     800b1f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800afa:	75 0f                	jne    800b0b <strtol+0x40>
  800afc:	80 3a 30             	cmpb   $0x30,(%edx)
  800aff:	74 28                	je     800b29 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b08:	0f 44 d8             	cmove  %eax,%ebx
  800b0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b13:	eb 46                	jmp    800b5b <strtol+0x90>
		s++;
  800b15:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b18:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1d:	eb d5                	jmp    800af4 <strtol+0x29>
		s++, neg = 1;
  800b1f:	83 c2 01             	add    $0x1,%edx
  800b22:	bf 01 00 00 00       	mov    $0x1,%edi
  800b27:	eb cb                	jmp    800af4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b29:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b2d:	74 0e                	je     800b3d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b2f:	85 db                	test   %ebx,%ebx
  800b31:	75 d8                	jne    800b0b <strtol+0x40>
		s++, base = 8;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b3b:	eb ce                	jmp    800b0b <strtol+0x40>
		s += 2, base = 16;
  800b3d:	83 c2 02             	add    $0x2,%edx
  800b40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b45:	eb c4                	jmp    800b0b <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b47:	0f be c0             	movsbl %al,%eax
  800b4a:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b50:	7d 3a                	jge    800b8c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b52:	83 c2 01             	add    $0x1,%edx
  800b55:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b59:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b5b:	0f b6 02             	movzbl (%edx),%eax
  800b5e:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b61:	89 f3                	mov    %esi,%ebx
  800b63:	80 fb 09             	cmp    $0x9,%bl
  800b66:	76 df                	jbe    800b47 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b68:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b6b:	89 f3                	mov    %esi,%ebx
  800b6d:	80 fb 19             	cmp    $0x19,%bl
  800b70:	77 08                	ja     800b7a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b72:	0f be c0             	movsbl %al,%eax
  800b75:	83 e8 57             	sub    $0x57,%eax
  800b78:	eb d3                	jmp    800b4d <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b7d:	89 f3                	mov    %esi,%ebx
  800b7f:	80 fb 19             	cmp    $0x19,%bl
  800b82:	77 08                	ja     800b8c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b84:	0f be c0             	movsbl %al,%eax
  800b87:	83 e8 37             	sub    $0x37,%eax
  800b8a:	eb c1                	jmp    800b4d <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b90:	74 05                	je     800b97 <strtol+0xcc>
		*endptr = (char *) s;
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b97:	89 c8                	mov    %ecx,%eax
  800b99:	f7 d8                	neg    %eax
  800b9b:	85 ff                	test   %edi,%edi
  800b9d:	0f 45 c8             	cmovne %eax,%ecx
}
  800ba0:	89 c8                	mov    %ecx,%eax
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb8:	89 c3                	mov    %eax,%ebx
  800bba:	89 c7                	mov    %eax,%edi
  800bbc:	89 c6                	mov    %eax,%esi
  800bbe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd5:	89 d1                	mov    %edx,%ecx
  800bd7:	89 d3                	mov    %edx,%ebx
  800bd9:	89 d7                	mov    %edx,%edi
  800bdb:	89 d6                	mov    %edx,%esi
  800bdd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfa:	89 cb                	mov    %ecx,%ebx
  800bfc:	89 cf                	mov    %ecx,%edi
  800bfe:	89 ce                	mov    %ecx,%esi
  800c00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c02:	85 c0                	test   %eax,%eax
  800c04:	7f 08                	jg     800c0e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0e:	83 ec 0c             	sub    $0xc,%esp
  800c11:	50                   	push   %eax
  800c12:	6a 03                	push   $0x3
  800c14:	68 bf 17 80 00       	push   $0x8017bf
  800c19:	6a 23                	push   $0x23
  800c1b:	68 dc 17 80 00       	push   $0x8017dc
  800c20:	e8 c6 04 00 00       	call   8010eb <_panic>

00800c25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 02 00 00 00       	mov    $0x2,%eax
  800c35:	89 d1                	mov    %edx,%ecx
  800c37:	89 d3                	mov    %edx,%ebx
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	89 d6                	mov    %edx,%esi
  800c3d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_yield>:

void
sys_yield(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6c:	be 00 00 00 00       	mov    $0x0,%esi
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c77:	b8 04 00 00 00       	mov    $0x4,%eax
  800c7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7f:	89 f7                	mov    %esi,%edi
  800c81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c83:	85 c0                	test   %eax,%eax
  800c85:	7f 08                	jg     800c8f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	50                   	push   %eax
  800c93:	6a 04                	push   $0x4
  800c95:	68 bf 17 80 00       	push   $0x8017bf
  800c9a:	6a 23                	push   $0x23
  800c9c:	68 dc 17 80 00       	push   $0x8017dc
  800ca1:	e8 45 04 00 00       	call   8010eb <_panic>

00800ca6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	b8 05 00 00 00       	mov    $0x5,%eax
  800cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc0:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 05                	push   $0x5
  800cd7:	68 bf 17 80 00       	push   $0x8017bf
  800cdc:	6a 23                	push   $0x23
  800cde:	68 dc 17 80 00       	push   $0x8017dc
  800ce3:	e8 03 04 00 00       	call   8010eb <_panic>

00800ce8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	b8 06 00 00 00       	mov    $0x6,%eax
  800d01:	89 df                	mov    %ebx,%edi
  800d03:	89 de                	mov    %ebx,%esi
  800d05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d07:	85 c0                	test   %eax,%eax
  800d09:	7f 08                	jg     800d13 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d13:	83 ec 0c             	sub    $0xc,%esp
  800d16:	50                   	push   %eax
  800d17:	6a 06                	push   $0x6
  800d19:	68 bf 17 80 00       	push   $0x8017bf
  800d1e:	6a 23                	push   $0x23
  800d20:	68 dc 17 80 00       	push   $0x8017dc
  800d25:	e8 c1 03 00 00       	call   8010eb <_panic>

00800d2a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 08                	push   $0x8
  800d5b:	68 bf 17 80 00       	push   $0x8017bf
  800d60:	6a 23                	push   $0x23
  800d62:	68 dc 17 80 00       	push   $0x8017dc
  800d67:	e8 7f 03 00 00       	call   8010eb <_panic>

00800d6c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	57                   	push   %edi
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
  800d72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d80:	b8 09 00 00 00       	mov    $0x9,%eax
  800d85:	89 df                	mov    %ebx,%edi
  800d87:	89 de                	mov    %ebx,%esi
  800d89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8b:	85 c0                	test   %eax,%eax
  800d8d:	7f 08                	jg     800d97 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	6a 09                	push   $0x9
  800d9d:	68 bf 17 80 00       	push   $0x8017bf
  800da2:	6a 23                	push   $0x23
  800da4:	68 dc 17 80 00       	push   $0x8017dc
  800da9:	e8 3d 03 00 00       	call   8010eb <_panic>

00800dae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc7:	89 df                	mov    %ebx,%edi
  800dc9:	89 de                	mov    %ebx,%esi
  800dcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	7f 08                	jg     800dd9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd9:	83 ec 0c             	sub    $0xc,%esp
  800ddc:	50                   	push   %eax
  800ddd:	6a 0a                	push   $0xa
  800ddf:	68 bf 17 80 00       	push   $0x8017bf
  800de4:	6a 23                	push   $0x23
  800de6:	68 dc 17 80 00       	push   $0x8017dc
  800deb:	e8 fb 02 00 00       	call   8010eb <_panic>

00800df0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e01:	be 00 00 00 00       	mov    $0x0,%esi
  800e06:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e09:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e0c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e29:	89 cb                	mov    %ecx,%ebx
  800e2b:	89 cf                	mov    %ecx,%edi
  800e2d:	89 ce                	mov    %ecx,%esi
  800e2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7f 08                	jg     800e3d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	50                   	push   %eax
  800e41:	6a 0d                	push   $0xd
  800e43:	68 bf 17 80 00       	push   $0x8017bf
  800e48:	6a 23                	push   $0x23
  800e4a:	68 dc 17 80 00       	push   $0x8017dc
  800e4f:	e8 97 02 00 00       	call   8010eb <_panic>

00800e54 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	53                   	push   %ebx
  800e58:	83 ec 04             	sub    $0x4,%esp
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e5e:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800e60:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e64:	0f 84 99 00 00 00    	je     800f03 <pgfault+0xaf>
  800e6a:	89 d8                	mov    %ebx,%eax
  800e6c:	c1 e8 16             	shr    $0x16,%eax
  800e6f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e76:	a8 01                	test   $0x1,%al
  800e78:	0f 84 85 00 00 00    	je     800f03 <pgfault+0xaf>
  800e7e:	89 d8                	mov    %ebx,%eax
  800e80:	c1 e8 0c             	shr    $0xc,%eax
  800e83:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e8a:	f6 c6 08             	test   $0x8,%dh
  800e8d:	74 74                	je     800f03 <pgfault+0xaf>
  800e8f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e96:	a8 01                	test   $0x1,%al
  800e98:	74 69                	je     800f03 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	6a 07                	push   $0x7
  800e9f:	68 00 f0 7f 00       	push   $0x7ff000
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 b8 fd ff ff       	call   800c63 <sys_page_alloc>
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 65                	js     800f17 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800eb2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	68 00 10 00 00       	push   $0x1000
  800ec0:	53                   	push   %ebx
  800ec1:	68 00 f0 7f 00       	push   $0x7ff000
  800ec6:	e8 94 fb ff ff       	call   800a5f <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800ecb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ed2:	53                   	push   %ebx
  800ed3:	6a 00                	push   $0x0
  800ed5:	68 00 f0 7f 00       	push   $0x7ff000
  800eda:	6a 00                	push   $0x0
  800edc:	e8 c5 fd ff ff       	call   800ca6 <sys_page_map>
  800ee1:	83 c4 20             	add    $0x20,%esp
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	78 43                	js     800f2b <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	68 00 f0 7f 00       	push   $0x7ff000
  800ef0:	6a 00                	push   $0x0
  800ef2:	e8 f1 fd ff ff       	call   800ce8 <sys_page_unmap>
  800ef7:	83 c4 10             	add    $0x10,%esp
  800efa:	85 c0                	test   %eax,%eax
  800efc:	78 41                	js     800f3f <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    
		panic("invalid permision\n");
  800f03:	83 ec 04             	sub    $0x4,%esp
  800f06:	68 ea 17 80 00       	push   $0x8017ea
  800f0b:	6a 1f                	push   $0x1f
  800f0d:	68 fd 17 80 00       	push   $0x8017fd
  800f12:	e8 d4 01 00 00       	call   8010eb <_panic>
		panic("Unable to alloc page\n");
  800f17:	83 ec 04             	sub    $0x4,%esp
  800f1a:	68 08 18 80 00       	push   $0x801808
  800f1f:	6a 28                	push   $0x28
  800f21:	68 fd 17 80 00       	push   $0x8017fd
  800f26:	e8 c0 01 00 00       	call   8010eb <_panic>
		panic("Unable to map\n");
  800f2b:	83 ec 04             	sub    $0x4,%esp
  800f2e:	68 1e 18 80 00       	push   $0x80181e
  800f33:	6a 2b                	push   $0x2b
  800f35:	68 fd 17 80 00       	push   $0x8017fd
  800f3a:	e8 ac 01 00 00       	call   8010eb <_panic>
		panic("Unable to unmap\n");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 2d 18 80 00       	push   $0x80182d
  800f47:	6a 2d                	push   $0x2d
  800f49:	68 fd 17 80 00       	push   $0x8017fd
  800f4e:	e8 98 01 00 00       	call   8010eb <_panic>

00800f53 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800f5c:	68 54 0e 80 00       	push   $0x800e54
  800f61:	e8 cb 01 00 00       	call   801131 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f66:	b8 07 00 00 00       	mov    $0x7,%eax
  800f6b:	cd 30                	int    $0x30
  800f6d:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800f6f:	83 c4 10             	add    $0x10,%esp
  800f72:	85 c0                	test   %eax,%eax
  800f74:	78 23                	js     800f99 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f76:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  800f7b:	75 6d                	jne    800fea <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f7d:	e8 a3 fc ff ff       	call   800c25 <sys_getenvid>
  800f82:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f87:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f8a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f8f:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f94:	e9 02 01 00 00       	jmp    80109b <fork+0x148>
		panic("sys_exofork: %e", envid);
  800f99:	50                   	push   %eax
  800f9a:	68 3e 18 80 00       	push   $0x80183e
  800f9f:	6a 6d                	push   $0x6d
  800fa1:	68 fd 17 80 00       	push   $0x8017fd
  800fa6:	e8 40 01 00 00       	call   8010eb <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  800fab:	c1 e0 0c             	shl    $0xc,%eax
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fb7:	52                   	push   %edx
  800fb8:	50                   	push   %eax
  800fb9:	56                   	push   %esi
  800fba:	50                   	push   %eax
  800fbb:	6a 00                	push   $0x0
  800fbd:	e8 e4 fc ff ff       	call   800ca6 <sys_page_map>
  800fc2:	83 c4 20             	add    $0x20,%esp
  800fc5:	eb 15                	jmp    800fdc <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  800fc7:	c1 e0 0c             	shl    $0xc,%eax
  800fca:	83 ec 0c             	sub    $0xc,%esp
  800fcd:	6a 05                	push   $0x5
  800fcf:	50                   	push   %eax
  800fd0:	56                   	push   %esi
  800fd1:	50                   	push   %eax
  800fd2:	6a 00                	push   $0x0
  800fd4:	e8 cd fc ff ff       	call   800ca6 <sys_page_map>
  800fd9:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fdc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fe2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fe8:	74 7a                	je     801064 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  800fea:	89 d8                	mov    %ebx,%eax
  800fec:	c1 e8 16             	shr    $0x16,%eax
  800fef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  800ff6:	a8 01                	test   $0x1,%al
  800ff8:	74 e2                	je     800fdc <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  800ffa:	89 d8                	mov    %ebx,%eax
  800ffc:	c1 e8 0c             	shr    $0xc,%eax
  800fff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801006:	f6 c2 01             	test   $0x1,%dl
  801009:	74 d1                	je     800fdc <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80100b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801012:	f6 c2 04             	test   $0x4,%dl
  801015:	74 c5                	je     800fdc <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801017:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80101e:	f6 c6 04             	test   $0x4,%dh
  801021:	75 88                	jne    800fab <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801023:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801029:	74 9c                	je     800fc7 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80102b:	c1 e0 0c             	shl    $0xc,%eax
  80102e:	89 c7                	mov    %eax,%edi
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	68 05 08 00 00       	push   $0x805
  801038:	50                   	push   %eax
  801039:	56                   	push   %esi
  80103a:	50                   	push   %eax
  80103b:	6a 00                	push   $0x0
  80103d:	e8 64 fc ff ff       	call   800ca6 <sys_page_map>
  801042:	83 c4 20             	add    $0x20,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	78 93                	js     800fdc <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	68 05 08 00 00       	push   $0x805
  801051:	57                   	push   %edi
  801052:	6a 00                	push   $0x0
  801054:	57                   	push   %edi
  801055:	6a 00                	push   $0x0
  801057:	e8 4a fc ff ff       	call   800ca6 <sys_page_map>
  80105c:	83 c4 20             	add    $0x20,%esp
  80105f:	e9 78 ff ff ff       	jmp    800fdc <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801064:	83 ec 04             	sub    $0x4,%esp
  801067:	6a 07                	push   $0x7
  801069:	68 00 f0 bf ee       	push   $0xeebff000
  80106e:	56                   	push   %esi
  80106f:	e8 ef fb ff ff       	call   800c63 <sys_page_alloc>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 2a                	js     8010a5 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	68 a0 11 80 00       	push   $0x8011a0
  801083:	56                   	push   %esi
  801084:	e8 25 fd ff ff       	call   800dae <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801089:	83 c4 08             	add    $0x8,%esp
  80108c:	6a 02                	push   $0x2
  80108e:	56                   	push   %esi
  80108f:	e8 96 fc ff ff       	call   800d2a <sys_env_set_status>
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	78 21                	js     8010bc <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80109b:	89 f0                	mov    %esi,%eax
  80109d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
		panic("failed to alloc page");
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	68 4e 18 80 00       	push   $0x80184e
  8010ad:	68 82 00 00 00       	push   $0x82
  8010b2:	68 fd 17 80 00       	push   $0x8017fd
  8010b7:	e8 2f 00 00 00       	call   8010eb <_panic>
		panic("sys_env_set_status: %e", r);
  8010bc:	50                   	push   %eax
  8010bd:	68 63 18 80 00       	push   $0x801863
  8010c2:	68 89 00 00 00       	push   $0x89
  8010c7:	68 fd 17 80 00       	push   $0x8017fd
  8010cc:	e8 1a 00 00 00       	call   8010eb <_panic>

008010d1 <sfork>:

// Challenge!
int
sfork(void)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010d7:	68 7a 18 80 00       	push   $0x80187a
  8010dc:	68 92 00 00 00       	push   $0x92
  8010e1:	68 fd 17 80 00       	push   $0x8017fd
  8010e6:	e8 00 00 00 00       	call   8010eb <_panic>

008010eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010f3:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8010f9:	e8 27 fb ff ff       	call   800c25 <sys_getenvid>
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	ff 75 0c             	push   0xc(%ebp)
  801104:	ff 75 08             	push   0x8(%ebp)
  801107:	56                   	push   %esi
  801108:	50                   	push   %eax
  801109:	68 90 18 80 00       	push   $0x801890
  80110e:	e8 8f f0 ff ff       	call   8001a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801113:	83 c4 18             	add    $0x18,%esp
  801116:	53                   	push   %ebx
  801117:	ff 75 10             	push   0x10(%ebp)
  80111a:	e8 32 f0 ff ff       	call   800151 <vcprintf>
	cprintf("\n");
  80111f:	c7 04 24 b4 14 80 00 	movl   $0x8014b4,(%esp)
  801126:	e8 77 f0 ff ff       	call   8001a2 <cprintf>
  80112b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80112e:	cc                   	int3   
  80112f:	eb fd                	jmp    80112e <_panic+0x43>

00801131 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801137:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80113e:	74 20                	je     801160 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	68 a0 11 80 00       	push   $0x8011a0
  801150:	6a 00                	push   $0x0
  801152:	e8 57 fc ff ff       	call   800dae <sys_env_set_pgfault_upcall>
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	78 2e                	js     80118c <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801160:	83 ec 04             	sub    $0x4,%esp
  801163:	6a 07                	push   $0x7
  801165:	68 00 f0 bf ee       	push   $0xeebff000
  80116a:	6a 00                	push   $0x0
  80116c:	e8 f2 fa ff ff       	call   800c63 <sys_page_alloc>
  801171:	83 c4 10             	add    $0x10,%esp
  801174:	85 c0                	test   %eax,%eax
  801176:	79 c8                	jns    801140 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	68 b4 18 80 00       	push   $0x8018b4
  801180:	6a 21                	push   $0x21
  801182:	68 17 19 80 00       	push   $0x801917
  801187:	e8 5f ff ff ff       	call   8010eb <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	68 e0 18 80 00       	push   $0x8018e0
  801194:	6a 27                	push   $0x27
  801196:	68 17 19 80 00       	push   $0x801917
  80119b:	e8 4b ff ff ff       	call   8010eb <_panic>

008011a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011a1:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8011a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011a8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8011ab:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8011af:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8011b4:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8011b8:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8011ba:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8011bd:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8011be:	83 c4 04             	add    $0x4,%esp
	popfl
  8011c1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011c2:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011c3:	c3                   	ret    
  8011c4:	66 90                	xchg   %ax,%ax
  8011c6:	66 90                	xchg   %ax,%ax
  8011c8:	66 90                	xchg   %ax,%ax
  8011ca:	66 90                	xchg   %ax,%ax
  8011cc:	66 90                	xchg   %ax,%ax
  8011ce:	66 90                	xchg   %ax,%ax

008011d0 <__udivdi3>:
  8011d0:	f3 0f 1e fb          	endbr32 
  8011d4:	55                   	push   %ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 1c             	sub    $0x1c,%esp
  8011db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8011df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8011e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	75 19                	jne    801208 <__udivdi3+0x38>
  8011ef:	39 f3                	cmp    %esi,%ebx
  8011f1:	76 4d                	jbe    801240 <__udivdi3+0x70>
  8011f3:	31 ff                	xor    %edi,%edi
  8011f5:	89 e8                	mov    %ebp,%eax
  8011f7:	89 f2                	mov    %esi,%edx
  8011f9:	f7 f3                	div    %ebx
  8011fb:	89 fa                	mov    %edi,%edx
  8011fd:	83 c4 1c             	add    $0x1c,%esp
  801200:	5b                   	pop    %ebx
  801201:	5e                   	pop    %esi
  801202:	5f                   	pop    %edi
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    
  801205:	8d 76 00             	lea    0x0(%esi),%esi
  801208:	39 f0                	cmp    %esi,%eax
  80120a:	76 14                	jbe    801220 <__udivdi3+0x50>
  80120c:	31 ff                	xor    %edi,%edi
  80120e:	31 c0                	xor    %eax,%eax
  801210:	89 fa                	mov    %edi,%edx
  801212:	83 c4 1c             	add    $0x1c,%esp
  801215:	5b                   	pop    %ebx
  801216:	5e                   	pop    %esi
  801217:	5f                   	pop    %edi
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    
  80121a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801220:	0f bd f8             	bsr    %eax,%edi
  801223:	83 f7 1f             	xor    $0x1f,%edi
  801226:	75 48                	jne    801270 <__udivdi3+0xa0>
  801228:	39 f0                	cmp    %esi,%eax
  80122a:	72 06                	jb     801232 <__udivdi3+0x62>
  80122c:	31 c0                	xor    %eax,%eax
  80122e:	39 eb                	cmp    %ebp,%ebx
  801230:	77 de                	ja     801210 <__udivdi3+0x40>
  801232:	b8 01 00 00 00       	mov    $0x1,%eax
  801237:	eb d7                	jmp    801210 <__udivdi3+0x40>
  801239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801240:	89 d9                	mov    %ebx,%ecx
  801242:	85 db                	test   %ebx,%ebx
  801244:	75 0b                	jne    801251 <__udivdi3+0x81>
  801246:	b8 01 00 00 00       	mov    $0x1,%eax
  80124b:	31 d2                	xor    %edx,%edx
  80124d:	f7 f3                	div    %ebx
  80124f:	89 c1                	mov    %eax,%ecx
  801251:	31 d2                	xor    %edx,%edx
  801253:	89 f0                	mov    %esi,%eax
  801255:	f7 f1                	div    %ecx
  801257:	89 c6                	mov    %eax,%esi
  801259:	89 e8                	mov    %ebp,%eax
  80125b:	89 f7                	mov    %esi,%edi
  80125d:	f7 f1                	div    %ecx
  80125f:	89 fa                	mov    %edi,%edx
  801261:	83 c4 1c             	add    $0x1c,%esp
  801264:	5b                   	pop    %ebx
  801265:	5e                   	pop    %esi
  801266:	5f                   	pop    %edi
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    
  801269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801270:	89 f9                	mov    %edi,%ecx
  801272:	ba 20 00 00 00       	mov    $0x20,%edx
  801277:	29 fa                	sub    %edi,%edx
  801279:	d3 e0                	shl    %cl,%eax
  80127b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80127f:	89 d1                	mov    %edx,%ecx
  801281:	89 d8                	mov    %ebx,%eax
  801283:	d3 e8                	shr    %cl,%eax
  801285:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801289:	09 c1                	or     %eax,%ecx
  80128b:	89 f0                	mov    %esi,%eax
  80128d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801291:	89 f9                	mov    %edi,%ecx
  801293:	d3 e3                	shl    %cl,%ebx
  801295:	89 d1                	mov    %edx,%ecx
  801297:	d3 e8                	shr    %cl,%eax
  801299:	89 f9                	mov    %edi,%ecx
  80129b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80129f:	89 eb                	mov    %ebp,%ebx
  8012a1:	d3 e6                	shl    %cl,%esi
  8012a3:	89 d1                	mov    %edx,%ecx
  8012a5:	d3 eb                	shr    %cl,%ebx
  8012a7:	09 f3                	or     %esi,%ebx
  8012a9:	89 c6                	mov    %eax,%esi
  8012ab:	89 f2                	mov    %esi,%edx
  8012ad:	89 d8                	mov    %ebx,%eax
  8012af:	f7 74 24 08          	divl   0x8(%esp)
  8012b3:	89 d6                	mov    %edx,%esi
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	f7 64 24 0c          	mull   0xc(%esp)
  8012bb:	39 d6                	cmp    %edx,%esi
  8012bd:	72 19                	jb     8012d8 <__udivdi3+0x108>
  8012bf:	89 f9                	mov    %edi,%ecx
  8012c1:	d3 e5                	shl    %cl,%ebp
  8012c3:	39 c5                	cmp    %eax,%ebp
  8012c5:	73 04                	jae    8012cb <__udivdi3+0xfb>
  8012c7:	39 d6                	cmp    %edx,%esi
  8012c9:	74 0d                	je     8012d8 <__udivdi3+0x108>
  8012cb:	89 d8                	mov    %ebx,%eax
  8012cd:	31 ff                	xor    %edi,%edi
  8012cf:	e9 3c ff ff ff       	jmp    801210 <__udivdi3+0x40>
  8012d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8012db:	31 ff                	xor    %edi,%edi
  8012dd:	e9 2e ff ff ff       	jmp    801210 <__udivdi3+0x40>
  8012e2:	66 90                	xchg   %ax,%ax
  8012e4:	66 90                	xchg   %ax,%ax
  8012e6:	66 90                	xchg   %ax,%ax
  8012e8:	66 90                	xchg   %ax,%ax
  8012ea:	66 90                	xchg   %ax,%ax
  8012ec:	66 90                	xchg   %ax,%ax
  8012ee:	66 90                	xchg   %ax,%ax

008012f0 <__umoddi3>:
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 1c             	sub    $0x1c,%esp
  8012fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801303:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801307:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80130b:	89 f0                	mov    %esi,%eax
  80130d:	89 da                	mov    %ebx,%edx
  80130f:	85 ff                	test   %edi,%edi
  801311:	75 15                	jne    801328 <__umoddi3+0x38>
  801313:	39 dd                	cmp    %ebx,%ebp
  801315:	76 39                	jbe    801350 <__umoddi3+0x60>
  801317:	f7 f5                	div    %ebp
  801319:	89 d0                	mov    %edx,%eax
  80131b:	31 d2                	xor    %edx,%edx
  80131d:	83 c4 1c             	add    $0x1c,%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    
  801325:	8d 76 00             	lea    0x0(%esi),%esi
  801328:	39 df                	cmp    %ebx,%edi
  80132a:	77 f1                	ja     80131d <__umoddi3+0x2d>
  80132c:	0f bd cf             	bsr    %edi,%ecx
  80132f:	83 f1 1f             	xor    $0x1f,%ecx
  801332:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801336:	75 40                	jne    801378 <__umoddi3+0x88>
  801338:	39 df                	cmp    %ebx,%edi
  80133a:	72 04                	jb     801340 <__umoddi3+0x50>
  80133c:	39 f5                	cmp    %esi,%ebp
  80133e:	77 dd                	ja     80131d <__umoddi3+0x2d>
  801340:	89 da                	mov    %ebx,%edx
  801342:	89 f0                	mov    %esi,%eax
  801344:	29 e8                	sub    %ebp,%eax
  801346:	19 fa                	sbb    %edi,%edx
  801348:	eb d3                	jmp    80131d <__umoddi3+0x2d>
  80134a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801350:	89 e9                	mov    %ebp,%ecx
  801352:	85 ed                	test   %ebp,%ebp
  801354:	75 0b                	jne    801361 <__umoddi3+0x71>
  801356:	b8 01 00 00 00       	mov    $0x1,%eax
  80135b:	31 d2                	xor    %edx,%edx
  80135d:	f7 f5                	div    %ebp
  80135f:	89 c1                	mov    %eax,%ecx
  801361:	89 d8                	mov    %ebx,%eax
  801363:	31 d2                	xor    %edx,%edx
  801365:	f7 f1                	div    %ecx
  801367:	89 f0                	mov    %esi,%eax
  801369:	f7 f1                	div    %ecx
  80136b:	89 d0                	mov    %edx,%eax
  80136d:	31 d2                	xor    %edx,%edx
  80136f:	eb ac                	jmp    80131d <__umoddi3+0x2d>
  801371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801378:	8b 44 24 04          	mov    0x4(%esp),%eax
  80137c:	ba 20 00 00 00       	mov    $0x20,%edx
  801381:	29 c2                	sub    %eax,%edx
  801383:	89 c1                	mov    %eax,%ecx
  801385:	89 e8                	mov    %ebp,%eax
  801387:	d3 e7                	shl    %cl,%edi
  801389:	89 d1                	mov    %edx,%ecx
  80138b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80138f:	d3 e8                	shr    %cl,%eax
  801391:	89 c1                	mov    %eax,%ecx
  801393:	8b 44 24 04          	mov    0x4(%esp),%eax
  801397:	09 f9                	or     %edi,%ecx
  801399:	89 df                	mov    %ebx,%edi
  80139b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80139f:	89 c1                	mov    %eax,%ecx
  8013a1:	d3 e5                	shl    %cl,%ebp
  8013a3:	89 d1                	mov    %edx,%ecx
  8013a5:	d3 ef                	shr    %cl,%edi
  8013a7:	89 c1                	mov    %eax,%ecx
  8013a9:	89 f0                	mov    %esi,%eax
  8013ab:	d3 e3                	shl    %cl,%ebx
  8013ad:	89 d1                	mov    %edx,%ecx
  8013af:	89 fa                	mov    %edi,%edx
  8013b1:	d3 e8                	shr    %cl,%eax
  8013b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013b8:	09 d8                	or     %ebx,%eax
  8013ba:	f7 74 24 08          	divl   0x8(%esp)
  8013be:	89 d3                	mov    %edx,%ebx
  8013c0:	d3 e6                	shl    %cl,%esi
  8013c2:	f7 e5                	mul    %ebp
  8013c4:	89 c7                	mov    %eax,%edi
  8013c6:	89 d1                	mov    %edx,%ecx
  8013c8:	39 d3                	cmp    %edx,%ebx
  8013ca:	72 06                	jb     8013d2 <__umoddi3+0xe2>
  8013cc:	75 0e                	jne    8013dc <__umoddi3+0xec>
  8013ce:	39 c6                	cmp    %eax,%esi
  8013d0:	73 0a                	jae    8013dc <__umoddi3+0xec>
  8013d2:	29 e8                	sub    %ebp,%eax
  8013d4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8013d8:	89 d1                	mov    %edx,%ecx
  8013da:	89 c7                	mov    %eax,%edi
  8013dc:	89 f5                	mov    %esi,%ebp
  8013de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013e2:	29 fd                	sub    %edi,%ebp
  8013e4:	19 cb                	sbb    %ecx,%ebx
  8013e6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	d3 e0                	shl    %cl,%eax
  8013ef:	89 f1                	mov    %esi,%ecx
  8013f1:	d3 ed                	shr    %cl,%ebp
  8013f3:	d3 eb                	shr    %cl,%ebx
  8013f5:	09 e8                	or     %ebp,%eax
  8013f7:	89 da                	mov    %ebx,%edx
  8013f9:	83 c4 1c             	add    $0x1c,%esp
  8013fc:	5b                   	pop    %ebx
  8013fd:	5e                   	pop    %esi
  8013fe:	5f                   	pop    %edi
  8013ff:	5d                   	pop    %ebp
  801400:	c3                   	ret    
