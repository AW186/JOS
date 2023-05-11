
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 80 24 80 00       	push   $0x802480
  800047:	e8 62 01 00 00       	call   8001ae <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 9e 24 80 00       	push   $0x80249e
  800056:	68 9e 24 80 00       	push   $0x80249e
  80005b:	e8 41 13 00 00       	call   8013a1 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 a6 24 80 00       	push   $0x8024a6
  80006f:	6a 09                	push   $0x9
  800071:	68 c0 24 80 00       	push   $0x8024c0
  800076:	e8 58 00 00 00       	call   8000d3 <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 a6 0b 00 00       	call   800c31 <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000c7:	6a 00                	push   $0x0
  8000c9:	e8 22 0b 00 00       	call   800bf0 <sys_env_destroy>
}
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	c9                   	leave  
  8000d2:	c3                   	ret    

008000d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000d8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000db:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e1:	e8 4b 0b 00 00       	call   800c31 <sys_getenvid>
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 0c             	push   0xc(%ebp)
  8000ec:	ff 75 08             	push   0x8(%ebp)
  8000ef:	56                   	push   %esi
  8000f0:	50                   	push   %eax
  8000f1:	68 e0 24 80 00       	push   $0x8024e0
  8000f6:	e8 b3 00 00 00       	call   8001ae <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8000fb:	83 c4 18             	add    $0x18,%esp
  8000fe:	53                   	push   %ebx
  8000ff:	ff 75 10             	push   0x10(%ebp)
  800102:	e8 56 00 00 00       	call   80015d <vcprintf>
	cprintf("\n");
  800107:	c7 04 24 bf 29 80 00 	movl   $0x8029bf,(%esp)
  80010e:	e8 9b 00 00 00       	call   8001ae <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800116:	cc                   	int3   
  800117:	eb fd                	jmp    800116 <_panic+0x43>

00800119 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	53                   	push   %ebx
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800123:	8b 13                	mov    (%ebx),%edx
  800125:	8d 42 01             	lea    0x1(%edx),%eax
  800128:	89 03                	mov    %eax,(%ebx)
  80012a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800131:	3d ff 00 00 00       	cmp    $0xff,%eax
  800136:	74 09                	je     800141 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800138:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013f:	c9                   	leave  
  800140:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	68 ff 00 00 00       	push   $0xff
  800149:	8d 43 08             	lea    0x8(%ebx),%eax
  80014c:	50                   	push   %eax
  80014d:	e8 61 0a 00 00       	call   800bb3 <sys_cputs>
		b->idx = 0;
  800152:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	eb db                	jmp    800138 <putch+0x1f>

0080015d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800166:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016d:	00 00 00 
	b.cnt = 0;
  800170:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800177:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017a:	ff 75 0c             	push   0xc(%ebp)
  80017d:	ff 75 08             	push   0x8(%ebp)
  800180:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800186:	50                   	push   %eax
  800187:	68 19 01 80 00       	push   $0x800119
  80018c:	e8 14 01 00 00       	call   8002a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800191:	83 c4 08             	add    $0x8,%esp
  800194:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80019a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 0d 0a 00 00       	call   800bb3 <sys_cputs>

	return b.cnt;
}
  8001a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b7:	50                   	push   %eax
  8001b8:	ff 75 08             	push   0x8(%ebp)
  8001bb:	e8 9d ff ff ff       	call   80015d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 1c             	sub    $0x1c,%esp
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	89 c2                	mov    %eax,%edx
  8001d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ef:	39 c2                	cmp    %eax,%edx
  8001f1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f4:	72 3e                	jb     800234 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 18             	push   0x18(%ebp)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	53                   	push   %ebx
  800200:	50                   	push   %eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	push   -0x1c(%ebp)
  800207:	ff 75 e0             	push   -0x20(%ebp)
  80020a:	ff 75 dc             	push   -0x24(%ebp)
  80020d:	ff 75 d8             	push   -0x28(%ebp)
  800210:	e8 2b 20 00 00       	call   802240 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9f ff ff ff       	call   8001c2 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	push   0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	push   -0x1c(%ebp)
  800245:	ff 75 e0             	push   -0x20(%ebp)
  800248:	ff 75 dc             	push   -0x24(%ebp)
  80024b:	ff 75 d8             	push   -0x28(%ebp)
  80024e:	e8 0d 21 00 00       	call   802360 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 03 25 80 00 	movsbl 0x802503(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800271:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800275:	8b 10                	mov    (%eax),%edx
  800277:	3b 50 04             	cmp    0x4(%eax),%edx
  80027a:	73 0a                	jae    800286 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027f:	89 08                	mov    %ecx,(%eax)
  800281:	8b 45 08             	mov    0x8(%ebp),%eax
  800284:	88 02                	mov    %al,(%edx)
}
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    

00800288 <printfmt>:
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 10             	push   0x10(%ebp)
  800295:	ff 75 0c             	push   0xc(%ebp)
  800298:	ff 75 08             	push   0x8(%ebp)
  80029b:	e8 05 00 00 00       	call   8002a5 <vprintfmt>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <vprintfmt>:
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 3c             	sub    $0x3c,%esp
  8002ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b7:	eb 0a                	jmp    8002c3 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	53                   	push   %ebx
  8002bd:	50                   	push   %eax
  8002be:	ff d6                	call   *%esi
  8002c0:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002c3:	83 c7 01             	add    $0x1,%edi
  8002c6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002ca:	83 f8 25             	cmp    $0x25,%eax
  8002cd:	74 0c                	je     8002db <vprintfmt+0x36>
			if (ch == '\0')
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	75 e6                	jne    8002b9 <vprintfmt+0x14>
}
  8002d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d6:	5b                   	pop    %ebx
  8002d7:	5e                   	pop    %esi
  8002d8:	5f                   	pop    %edi
  8002d9:	5d                   	pop    %ebp
  8002da:	c3                   	ret    
		padc = ' ';
  8002db:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002ed:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f9:	8d 47 01             	lea    0x1(%edi),%eax
  8002fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ff:	0f b6 17             	movzbl (%edi),%edx
  800302:	8d 42 dd             	lea    -0x23(%edx),%eax
  800305:	3c 55                	cmp    $0x55,%al
  800307:	0f 87 a6 04 00 00    	ja     8007b3 <vprintfmt+0x50e>
  80030d:	0f b6 c0             	movzbl %al,%eax
  800310:	ff 24 85 40 26 80 00 	jmp    *0x802640(,%eax,4)
  800317:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80031a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80031e:	eb d9                	jmp    8002f9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800320:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800323:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800327:	eb d0                	jmp    8002f9 <vprintfmt+0x54>
  800329:	0f b6 d2             	movzbl %dl,%edx
  80032c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80032f:	b8 00 00 00 00       	mov    $0x0,%eax
  800334:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800337:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80033e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800341:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800344:	83 f9 09             	cmp    $0x9,%ecx
  800347:	77 55                	ja     80039e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800349:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034c:	eb e9                	jmp    800337 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	8d 40 04             	lea    0x4(%eax),%eax
  80035c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80035f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800362:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800366:	79 91                	jns    8002f9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80036e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800375:	eb 82                	jmp    8002f9 <vprintfmt+0x54>
  800377:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80037a:	85 d2                	test   %edx,%edx
  80037c:	b8 00 00 00 00       	mov    $0x0,%eax
  800381:	0f 49 c2             	cmovns %edx,%eax
  800384:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800387:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80038a:	e9 6a ff ff ff       	jmp    8002f9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800392:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800399:	e9 5b ff ff ff       	jmp    8002f9 <vprintfmt+0x54>
  80039e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a4:	eb bc                	jmp    800362 <vprintfmt+0xbd>
			lflag++;
  8003a6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003ac:	e9 48 ff ff ff       	jmp    8002f9 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 78 04             	lea    0x4(%eax),%edi
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	53                   	push   %ebx
  8003bb:	ff 30                	push   (%eax)
  8003bd:	ff d6                	call   *%esi
			break;
  8003bf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c5:	e9 88 03 00 00       	jmp    800752 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	8d 78 04             	lea    0x4(%eax),%edi
  8003d0:	8b 10                	mov    (%eax),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	f7 d8                	neg    %eax
  8003d6:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d9:	83 f8 0f             	cmp    $0xf,%eax
  8003dc:	7f 23                	jg     800401 <vprintfmt+0x15c>
  8003de:	8b 14 85 a0 27 80 00 	mov    0x8027a0(,%eax,4),%edx
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 18                	je     800401 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003e9:	52                   	push   %edx
  8003ea:	68 56 28 80 00       	push   $0x802856
  8003ef:	53                   	push   %ebx
  8003f0:	56                   	push   %esi
  8003f1:	e8 92 fe ff ff       	call   800288 <printfmt>
  8003f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fc:	e9 51 03 00 00       	jmp    800752 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800401:	50                   	push   %eax
  800402:	68 1b 25 80 00       	push   $0x80251b
  800407:	53                   	push   %ebx
  800408:	56                   	push   %esi
  800409:	e8 7a fe ff ff       	call   800288 <printfmt>
  80040e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800414:	e9 39 03 00 00       	jmp    800752 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	83 c0 04             	add    $0x4,%eax
  80041f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800427:	85 d2                	test   %edx,%edx
  800429:	b8 14 25 80 00       	mov    $0x802514,%eax
  80042e:	0f 45 c2             	cmovne %edx,%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800434:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800438:	7e 06                	jle    800440 <vprintfmt+0x19b>
  80043a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043e:	75 0d                	jne    80044d <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800440:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800443:	89 c7                	mov    %eax,%edi
  800445:	03 45 d4             	add    -0x2c(%ebp),%eax
  800448:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80044b:	eb 55                	jmp    8004a2 <vprintfmt+0x1fd>
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 e0             	push   -0x20(%ebp)
  800453:	ff 75 cc             	push   -0x34(%ebp)
  800456:	e8 f5 03 00 00       	call   800850 <strnlen>
  80045b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80045e:	29 c2                	sub    %eax,%edx
  800460:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800468:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	eb 0f                	jmp    800480 <vprintfmt+0x1db>
					putch(padc, putdat);
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	53                   	push   %ebx
  800475:	ff 75 d4             	push   -0x2c(%ebp)
  800478:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047a:	83 ef 01             	sub    $0x1,%edi
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	85 ff                	test   %edi,%edi
  800482:	7f ed                	jg     800471 <vprintfmt+0x1cc>
  800484:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c2             	cmovns %edx,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800496:	eb a8                	jmp    800440 <vprintfmt+0x19b>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	52                   	push   %edx
  80049d:	ff d6                	call   *%esi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a7:	83 c7 01             	add    $0x1,%edi
  8004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ae:	0f be d0             	movsbl %al,%edx
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	74 4b                	je     800500 <vprintfmt+0x25b>
  8004b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b9:	78 06                	js     8004c1 <vprintfmt+0x21c>
  8004bb:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004bf:	78 1e                	js     8004df <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c5:	74 d1                	je     800498 <vprintfmt+0x1f3>
  8004c7:	0f be c0             	movsbl %al,%eax
  8004ca:	83 e8 20             	sub    $0x20,%eax
  8004cd:	83 f8 5e             	cmp    $0x5e,%eax
  8004d0:	76 c6                	jbe    800498 <vprintfmt+0x1f3>
					putch('?', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	6a 3f                	push   $0x3f
  8004d8:	ff d6                	call   *%esi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	eb c3                	jmp    8004a2 <vprintfmt+0x1fd>
  8004df:	89 cf                	mov    %ecx,%edi
  8004e1:	eb 0e                	jmp    8004f1 <vprintfmt+0x24c>
				putch(' ', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004eb:	83 ef 01             	sub    $0x1,%edi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	7f ee                	jg     8004e3 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fb:	e9 52 02 00 00       	jmp    800752 <vprintfmt+0x4ad>
  800500:	89 cf                	mov    %ecx,%edi
  800502:	eb ed                	jmp    8004f1 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	83 c0 04             	add    $0x4,%eax
  80050a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800512:	85 d2                	test   %edx,%edx
  800514:	b8 14 25 80 00       	mov    $0x802514,%eax
  800519:	0f 45 c2             	cmovne %edx,%eax
  80051c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800523:	7e 06                	jle    80052b <vprintfmt+0x286>
  800525:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800529:	75 0d                	jne    800538 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052e:	89 c7                	mov    %eax,%edi
  800530:	03 45 d4             	add    -0x2c(%ebp),%eax
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800536:	eb 55                	jmp    80058d <vprintfmt+0x2e8>
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 e0             	push   -0x20(%ebp)
  80053e:	ff 75 cc             	push   -0x34(%ebp)
  800541:	e8 0a 03 00 00       	call   800850 <strnlen>
  800546:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800549:	29 c2                	sub    %eax,%edx
  80054b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800553:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800557:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055a:	eb 0f                	jmp    80056b <vprintfmt+0x2c6>
					putch(padc, putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	ff 75 d4             	push   -0x2c(%ebp)
  800563:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800565:	83 ef 01             	sub    $0x1,%edi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	85 ff                	test   %edi,%edi
  80056d:	7f ed                	jg     80055c <vprintfmt+0x2b7>
  80056f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800572:	85 d2                	test   %edx,%edx
  800574:	b8 00 00 00 00       	mov    $0x0,%eax
  800579:	0f 49 c2             	cmovns %edx,%eax
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800581:	eb a8                	jmp    80052b <vprintfmt+0x286>
					putch(ch, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	52                   	push   %edx
  800588:	ff d6                	call   *%esi
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800590:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800592:	83 c7 01             	add    $0x1,%edi
  800595:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800599:	0f be d0             	movsbl %al,%edx
  80059c:	3c 3a                	cmp    $0x3a,%al
  80059e:	74 4b                	je     8005eb <vprintfmt+0x346>
  8005a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a4:	78 06                	js     8005ac <vprintfmt+0x307>
  8005a6:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005aa:	78 1e                	js     8005ca <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b0:	74 d1                	je     800583 <vprintfmt+0x2de>
  8005b2:	0f be c0             	movsbl %al,%eax
  8005b5:	83 e8 20             	sub    $0x20,%eax
  8005b8:	83 f8 5e             	cmp    $0x5e,%eax
  8005bb:	76 c6                	jbe    800583 <vprintfmt+0x2de>
					putch('?', putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	6a 3f                	push   $0x3f
  8005c3:	ff d6                	call   *%esi
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	eb c3                	jmp    80058d <vprintfmt+0x2e8>
  8005ca:	89 cf                	mov    %ecx,%edi
  8005cc:	eb 0e                	jmp    8005dc <vprintfmt+0x337>
				putch(' ', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 20                	push   $0x20
  8005d4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d6:	83 ef 01             	sub    $0x1,%edi
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	85 ff                	test   %edi,%edi
  8005de:	7f ee                	jg     8005ce <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	e9 67 01 00 00       	jmp    800752 <vprintfmt+0x4ad>
  8005eb:	89 cf                	mov    %ecx,%edi
  8005ed:	eb ed                	jmp    8005dc <vprintfmt+0x337>
	if (lflag >= 2)
  8005ef:	83 f9 01             	cmp    $0x1,%ecx
  8005f2:	7f 1b                	jg     80060f <vprintfmt+0x36a>
	else if (lflag)
  8005f4:	85 c9                	test   %ecx,%ecx
  8005f6:	74 63                	je     80065b <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800600:	99                   	cltd   
  800601:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
  80060d:	eb 17                	jmp    800626 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 50 04             	mov    0x4(%eax),%edx
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 40 08             	lea    0x8(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800629:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80062c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800631:	85 c9                	test   %ecx,%ecx
  800633:	0f 89 ff 00 00 00    	jns    800738 <vprintfmt+0x493>
				putch('-', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 2d                	push   $0x2d
  80063f:	ff d6                	call   *%esi
				num = -(long long) num;
  800641:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800644:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800647:	f7 da                	neg    %edx
  800649:	83 d1 00             	adc    $0x0,%ecx
  80064c:	f7 d9                	neg    %ecx
  80064e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800651:	bf 0a 00 00 00       	mov    $0xa,%edi
  800656:	e9 dd 00 00 00       	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800663:	99                   	cltd   
  800664:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
  800670:	eb b4                	jmp    800626 <vprintfmt+0x381>
	if (lflag >= 2)
  800672:	83 f9 01             	cmp    $0x1,%ecx
  800675:	7f 1e                	jg     800695 <vprintfmt+0x3f0>
	else if (lflag)
  800677:	85 c9                	test   %ecx,%ecx
  800679:	74 32                	je     8006ad <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800690:	e9 a3 00 00 00       	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	8b 48 04             	mov    0x4(%eax),%ecx
  80069d:	8d 40 08             	lea    0x8(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006a8:	e9 8b 00 00 00       	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bd:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006c2:	eb 74                	jmp    800738 <vprintfmt+0x493>
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7f 1b                	jg     8006e4 <vprintfmt+0x43f>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 2c                	je     8006f9 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dd:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006e2:	eb 54                	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f2:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006f7:	eb 3f                	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800709:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80070e:	eb 28                	jmp    800738 <vprintfmt+0x493>
			putch('0', putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	6a 30                	push   $0x30
  800716:	ff d6                	call   *%esi
			putch('x', putdat);
  800718:	83 c4 08             	add    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 78                	push   $0x78
  80071e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 10                	mov    (%eax),%edx
  800725:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80072a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800733:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80073f:	50                   	push   %eax
  800740:	ff 75 d4             	push   -0x2c(%ebp)
  800743:	57                   	push   %edi
  800744:	51                   	push   %ecx
  800745:	52                   	push   %edx
  800746:	89 da                	mov    %ebx,%edx
  800748:	89 f0                	mov    %esi,%eax
  80074a:	e8 73 fa ff ff       	call   8001c2 <printnum>
			break;
  80074f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800755:	e9 69 fb ff ff       	jmp    8002c3 <vprintfmt+0x1e>
	if (lflag >= 2)
  80075a:	83 f9 01             	cmp    $0x1,%ecx
  80075d:	7f 1b                	jg     80077a <vprintfmt+0x4d5>
	else if (lflag)
  80075f:	85 c9                	test   %ecx,%ecx
  800761:	74 2c                	je     80078f <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 10                	mov    (%eax),%edx
  800768:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076d:	8d 40 04             	lea    0x4(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800773:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800778:	eb be                	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 10                	mov    (%eax),%edx
  80077f:	8b 48 04             	mov    0x4(%eax),%ecx
  800782:	8d 40 08             	lea    0x8(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800788:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80078d:	eb a9                	jmp    800738 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 10                	mov    (%eax),%edx
  800794:	b9 00 00 00 00       	mov    $0x0,%ecx
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007a4:	eb 92                	jmp    800738 <vprintfmt+0x493>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d6                	call   *%esi
			break;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	eb 9f                	jmp    800752 <vprintfmt+0x4ad>
			putch('%', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 25                	push   $0x25
  8007b9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 f8                	mov    %edi,%eax
  8007c0:	eb 03                	jmp    8007c5 <vprintfmt+0x520>
  8007c2:	83 e8 01             	sub    $0x1,%eax
  8007c5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c9:	75 f7                	jne    8007c2 <vprintfmt+0x51d>
  8007cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007ce:	eb 82                	jmp    800752 <vprintfmt+0x4ad>

008007d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	74 26                	je     800817 <vsnprintf+0x47>
  8007f1:	85 d2                	test   %edx,%edx
  8007f3:	7e 22                	jle    800817 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f5:	ff 75 14             	push   0x14(%ebp)
  8007f8:	ff 75 10             	push   0x10(%ebp)
  8007fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	68 6b 02 80 00       	push   $0x80026b
  800804:	e8 9c fa ff ff       	call   8002a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800812:	83 c4 10             	add    $0x10,%esp
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    
		return -E_INVAL;
  800817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081c:	eb f7                	jmp    800815 <vsnprintf+0x45>

0080081e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800827:	50                   	push   %eax
  800828:	ff 75 10             	push   0x10(%ebp)
  80082b:	ff 75 0c             	push   0xc(%ebp)
  80082e:	ff 75 08             	push   0x8(%ebp)
  800831:	e8 9a ff ff ff       	call   8007d0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	eb 03                	jmp    800848 <strlen+0x10>
		n++;
  800845:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800848:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084c:	75 f7                	jne    800845 <strlen+0xd>
	return n;
}
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800856:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	eb 03                	jmp    800863 <strnlen+0x13>
		n++;
  800860:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800863:	39 d0                	cmp    %edx,%eax
  800865:	74 08                	je     80086f <strnlen+0x1f>
  800867:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80086b:	75 f3                	jne    800860 <strnlen+0x10>
  80086d:	89 c2                	mov    %eax,%edx
	return n;
}
  80086f:	89 d0                	mov    %edx,%eax
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	53                   	push   %ebx
  800877:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800886:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	84 d2                	test   %dl,%dl
  80088e:	75 f2                	jne    800882 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800890:	89 c8                	mov    %ecx,%eax
  800892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800895:	c9                   	leave  
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 10             	sub    $0x10,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	53                   	push   %ebx
  8008a2:	e8 91 ff ff ff       	call   800838 <strlen>
  8008a7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008aa:	ff 75 0c             	push   0xc(%ebp)
  8008ad:	01 d8                	add    %ebx,%eax
  8008af:	50                   	push   %eax
  8008b0:	e8 be ff ff ff       	call   800873 <strcpy>
	return dst;
}
  8008b5:	89 d8                	mov    %ebx,%eax
  8008b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ba:	c9                   	leave  
  8008bb:	c3                   	ret    

008008bc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c7:	89 f3                	mov    %esi,%ebx
  8008c9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008cc:	89 f0                	mov    %esi,%eax
  8008ce:	eb 0f                	jmp    8008df <strncpy+0x23>
		*dst++ = *src;
  8008d0:	83 c0 01             	add    $0x1,%eax
  8008d3:	0f b6 0a             	movzbl (%edx),%ecx
  8008d6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d9:	80 f9 01             	cmp    $0x1,%cl
  8008dc:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8008df:	39 d8                	cmp    %ebx,%eax
  8008e1:	75 ed                	jne    8008d0 <strncpy+0x14>
	}
	return ret;
}
  8008e3:	89 f0                	mov    %esi,%eax
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	56                   	push   %esi
  8008ed:	53                   	push   %ebx
  8008ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f4:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f9:	85 d2                	test   %edx,%edx
  8008fb:	74 21                	je     80091e <strlcpy+0x35>
  8008fd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800901:	89 f2                	mov    %esi,%edx
  800903:	eb 09                	jmp    80090e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800905:	83 c1 01             	add    $0x1,%ecx
  800908:	83 c2 01             	add    $0x1,%edx
  80090b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80090e:	39 c2                	cmp    %eax,%edx
  800910:	74 09                	je     80091b <strlcpy+0x32>
  800912:	0f b6 19             	movzbl (%ecx),%ebx
  800915:	84 db                	test   %bl,%bl
  800917:	75 ec                	jne    800905 <strlcpy+0x1c>
  800919:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80091b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80091e:	29 f0                	sub    %esi,%eax
}
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strcmp+0x11>
		p++, q++;
  80092f:	83 c1 01             	add    $0x1,%ecx
  800932:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800935:	0f b6 01             	movzbl (%ecx),%eax
  800938:	84 c0                	test   %al,%al
  80093a:	74 04                	je     800940 <strcmp+0x1c>
  80093c:	3a 02                	cmp    (%edx),%al
  80093e:	74 ef                	je     80092f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800940:	0f b6 c0             	movzbl %al,%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	89 c3                	mov    %eax,%ebx
  800956:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800959:	eb 06                	jmp    800961 <strncmp+0x17>
		n--, p++, q++;
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800961:	39 d8                	cmp    %ebx,%eax
  800963:	74 18                	je     80097d <strncmp+0x33>
  800965:	0f b6 08             	movzbl (%eax),%ecx
  800968:	84 c9                	test   %cl,%cl
  80096a:	74 04                	je     800970 <strncmp+0x26>
  80096c:	3a 0a                	cmp    (%edx),%cl
  80096e:	74 eb                	je     80095b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 00             	movzbl (%eax),%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    
		return 0;
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	eb f4                	jmp    800978 <strncmp+0x2e>

00800984 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098e:	eb 03                	jmp    800993 <strchr+0xf>
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	0f b6 10             	movzbl (%eax),%edx
  800996:	84 d2                	test   %dl,%dl
  800998:	74 06                	je     8009a0 <strchr+0x1c>
		if (*s == c)
  80099a:	38 ca                	cmp    %cl,%dl
  80099c:	75 f2                	jne    800990 <strchr+0xc>
  80099e:	eb 05                	jmp    8009a5 <strchr+0x21>
			return (char *) s;
	return 0;
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b4:	38 ca                	cmp    %cl,%dl
  8009b6:	74 09                	je     8009c1 <strfind+0x1a>
  8009b8:	84 d2                	test   %dl,%dl
  8009ba:	74 05                	je     8009c1 <strfind+0x1a>
	for (; *s; s++)
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	eb f0                	jmp    8009b1 <strfind+0xa>
			break;
	return (char *) s;
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	57                   	push   %edi
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 2f                	je     800a02 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	09 c8                	or     %ecx,%eax
  8009d7:	a8 03                	test   $0x3,%al
  8009d9:	75 21                	jne    8009fc <memset+0x39>
		c &= 0xFF;
  8009db:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009df:	89 d0                	mov    %edx,%eax
  8009e1:	c1 e0 08             	shl    $0x8,%eax
  8009e4:	89 d3                	mov    %edx,%ebx
  8009e6:	c1 e3 18             	shl    $0x18,%ebx
  8009e9:	89 d6                	mov    %edx,%esi
  8009eb:	c1 e6 10             	shl    $0x10,%esi
  8009ee:	09 f3                	or     %esi,%ebx
  8009f0:	09 da                	or     %ebx,%edx
  8009f2:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f7:	fc                   	cld    
  8009f8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fa:	eb 06                	jmp    800a02 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	fc                   	cld    
  800a00:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a02:	89 f8                	mov    %edi,%eax
  800a04:	5b                   	pop    %ebx
  800a05:	5e                   	pop    %esi
  800a06:	5f                   	pop    %edi
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	57                   	push   %edi
  800a0d:	56                   	push   %esi
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a17:	39 c6                	cmp    %eax,%esi
  800a19:	73 32                	jae    800a4d <memmove+0x44>
  800a1b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	76 2b                	jbe    800a4d <memmove+0x44>
		s += n;
		d += n;
  800a22:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a25:	89 d6                	mov    %edx,%esi
  800a27:	09 fe                	or     %edi,%esi
  800a29:	09 ce                	or     %ecx,%esi
  800a2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a31:	75 0e                	jne    800a41 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a33:	83 ef 04             	sub    $0x4,%edi
  800a36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3c:	fd                   	std    
  800a3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3f:	eb 09                	jmp    800a4a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a41:	83 ef 01             	sub    $0x1,%edi
  800a44:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a47:	fd                   	std    
  800a48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4a:	fc                   	cld    
  800a4b:	eb 1a                	jmp    800a67 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4d:	89 f2                	mov    %esi,%edx
  800a4f:	09 c2                	or     %eax,%edx
  800a51:	09 ca                	or     %ecx,%edx
  800a53:	f6 c2 03             	test   $0x3,%dl
  800a56:	75 0a                	jne    800a62 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a58:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	fc                   	cld    
  800a5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a60:	eb 05                	jmp    800a67 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a62:	89 c7                	mov    %eax,%edi
  800a64:	fc                   	cld    
  800a65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a67:	5e                   	pop    %esi
  800a68:	5f                   	pop    %edi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a71:	ff 75 10             	push   0x10(%ebp)
  800a74:	ff 75 0c             	push   0xc(%ebp)
  800a77:	ff 75 08             	push   0x8(%ebp)
  800a7a:	e8 8a ff ff ff       	call   800a09 <memmove>
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	56                   	push   %esi
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c6                	mov    %eax,%esi
  800a8e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a91:	eb 06                	jmp    800a99 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a99:	39 f0                	cmp    %esi,%eax
  800a9b:	74 14                	je     800ab1 <memcmp+0x30>
		if (*s1 != *s2)
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	0f b6 1a             	movzbl (%edx),%ebx
  800aa3:	38 d9                	cmp    %bl,%cl
  800aa5:	74 ec                	je     800a93 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800aa7:	0f b6 c1             	movzbl %cl,%eax
  800aaa:	0f b6 db             	movzbl %bl,%ebx
  800aad:	29 d8                	sub    %ebx,%eax
  800aaf:	eb 05                	jmp    800ab6 <memcmp+0x35>
	}

	return 0;
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac3:	89 c2                	mov    %eax,%edx
  800ac5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac8:	eb 03                	jmp    800acd <memfind+0x13>
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	39 d0                	cmp    %edx,%eax
  800acf:	73 04                	jae    800ad5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad1:	38 08                	cmp    %cl,(%eax)
  800ad3:	75 f5                	jne    800aca <memfind+0x10>
			break;
	return (void *) s;
}
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae3:	eb 03                	jmp    800ae8 <strtol+0x11>
		s++;
  800ae5:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ae8:	0f b6 02             	movzbl (%edx),%eax
  800aeb:	3c 20                	cmp    $0x20,%al
  800aed:	74 f6                	je     800ae5 <strtol+0xe>
  800aef:	3c 09                	cmp    $0x9,%al
  800af1:	74 f2                	je     800ae5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af3:	3c 2b                	cmp    $0x2b,%al
  800af5:	74 2a                	je     800b21 <strtol+0x4a>
	int neg = 0;
  800af7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afc:	3c 2d                	cmp    $0x2d,%al
  800afe:	74 2b                	je     800b2b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b00:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b06:	75 0f                	jne    800b17 <strtol+0x40>
  800b08:	80 3a 30             	cmpb   $0x30,(%edx)
  800b0b:	74 28                	je     800b35 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0d:	85 db                	test   %ebx,%ebx
  800b0f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b14:	0f 44 d8             	cmove  %eax,%ebx
  800b17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b1f:	eb 46                	jmp    800b67 <strtol+0x90>
		s++;
  800b21:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b24:	bf 00 00 00 00       	mov    $0x0,%edi
  800b29:	eb d5                	jmp    800b00 <strtol+0x29>
		s++, neg = 1;
  800b2b:	83 c2 01             	add    $0x1,%edx
  800b2e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b33:	eb cb                	jmp    800b00 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b35:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b39:	74 0e                	je     800b49 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b3b:	85 db                	test   %ebx,%ebx
  800b3d:	75 d8                	jne    800b17 <strtol+0x40>
		s++, base = 8;
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b47:	eb ce                	jmp    800b17 <strtol+0x40>
		s += 2, base = 16;
  800b49:	83 c2 02             	add    $0x2,%edx
  800b4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b51:	eb c4                	jmp    800b17 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b53:	0f be c0             	movsbl %al,%eax
  800b56:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b59:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b5c:	7d 3a                	jge    800b98 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b65:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b67:	0f b6 02             	movzbl (%edx),%eax
  800b6a:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b6d:	89 f3                	mov    %esi,%ebx
  800b6f:	80 fb 09             	cmp    $0x9,%bl
  800b72:	76 df                	jbe    800b53 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b74:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b77:	89 f3                	mov    %esi,%ebx
  800b79:	80 fb 19             	cmp    $0x19,%bl
  800b7c:	77 08                	ja     800b86 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b7e:	0f be c0             	movsbl %al,%eax
  800b81:	83 e8 57             	sub    $0x57,%eax
  800b84:	eb d3                	jmp    800b59 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b86:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b89:	89 f3                	mov    %esi,%ebx
  800b8b:	80 fb 19             	cmp    $0x19,%bl
  800b8e:	77 08                	ja     800b98 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b90:	0f be c0             	movsbl %al,%eax
  800b93:	83 e8 37             	sub    $0x37,%eax
  800b96:	eb c1                	jmp    800b59 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	74 05                	je     800ba3 <strtol+0xcc>
		*endptr = (char *) s;
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ba3:	89 c8                	mov    %ecx,%eax
  800ba5:	f7 d8                	neg    %eax
  800ba7:	85 ff                	test   %edi,%edi
  800ba9:	0f 45 c8             	cmovne %eax,%ecx
}
  800bac:	89 c8                	mov    %ecx,%eax
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	89 c3                	mov    %eax,%ebx
  800bc6:	89 c7                	mov    %eax,%edi
  800bc8:	89 c6                	mov    %eax,%esi
  800bca:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  800be1:	89 d1                	mov    %edx,%ecx
  800be3:	89 d3                	mov    %edx,%ebx
  800be5:	89 d7                	mov    %edx,%edi
  800be7:	89 d6                	mov    %edx,%esi
  800be9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	89 cb                	mov    %ecx,%ebx
  800c08:	89 cf                	mov    %ecx,%edi
  800c0a:	89 ce                	mov    %ecx,%esi
  800c0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	7f 08                	jg     800c1a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1a:	83 ec 0c             	sub    $0xc,%esp
  800c1d:	50                   	push   %eax
  800c1e:	6a 03                	push   $0x3
  800c20:	68 ff 27 80 00       	push   $0x8027ff
  800c25:	6a 23                	push   $0x23
  800c27:	68 1c 28 80 00       	push   $0x80281c
  800c2c:	e8 a2 f4 ff ff       	call   8000d3 <_panic>

00800c31 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c41:	89 d1                	mov    %edx,%ecx
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	89 d7                	mov    %edx,%edi
  800c47:	89 d6                	mov    %edx,%esi
  800c49:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_yield>:

void
sys_yield(void)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c56:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c60:	89 d1                	mov    %edx,%ecx
  800c62:	89 d3                	mov    %edx,%ebx
  800c64:	89 d7                	mov    %edx,%edi
  800c66:	89 d6                	mov    %edx,%esi
  800c68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c78:	be 00 00 00 00       	mov    $0x0,%esi
  800c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c83:	b8 04 00 00 00       	mov    $0x4,%eax
  800c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8b:	89 f7                	mov    %esi,%edi
  800c8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	6a 04                	push   $0x4
  800ca1:	68 ff 27 80 00       	push   $0x8027ff
  800ca6:	6a 23                	push   $0x23
  800ca8:	68 1c 28 80 00       	push   $0x80281c
  800cad:	e8 21 f4 ff ff       	call   8000d3 <_panic>

00800cb2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
  800cb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccc:	8b 75 18             	mov    0x18(%ebp),%esi
  800ccf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7f 08                	jg     800cdd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	83 ec 0c             	sub    $0xc,%esp
  800ce0:	50                   	push   %eax
  800ce1:	6a 05                	push   $0x5
  800ce3:	68 ff 27 80 00       	push   $0x8027ff
  800ce8:	6a 23                	push   $0x23
  800cea:	68 1c 28 80 00       	push   $0x80281c
  800cef:	e8 df f3 ff ff       	call   8000d3 <_panic>

00800cf4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0d:	89 df                	mov    %ebx,%edi
  800d0f:	89 de                	mov    %ebx,%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 06                	push   $0x6
  800d25:	68 ff 27 80 00       	push   $0x8027ff
  800d2a:	6a 23                	push   $0x23
  800d2c:	68 1c 28 80 00       	push   $0x80281c
  800d31:	e8 9d f3 ff ff       	call   8000d3 <_panic>

00800d36 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	89 de                	mov    %ebx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d61:	83 ec 0c             	sub    $0xc,%esp
  800d64:	50                   	push   %eax
  800d65:	6a 08                	push   $0x8
  800d67:	68 ff 27 80 00       	push   $0x8027ff
  800d6c:	6a 23                	push   $0x23
  800d6e:	68 1c 28 80 00       	push   $0x80281c
  800d73:	e8 5b f3 ff ff       	call   8000d3 <_panic>

00800d78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 09 00 00 00       	mov    $0x9,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 09                	push   $0x9
  800da9:	68 ff 27 80 00       	push   $0x8027ff
  800dae:	6a 23                	push   $0x23
  800db0:	68 1c 28 80 00       	push   $0x80281c
  800db5:	e8 19 f3 ff ff       	call   8000d3 <_panic>

00800dba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dce:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 0a                	push   $0xa
  800deb:	68 ff 27 80 00       	push   $0x8027ff
  800df0:	6a 23                	push   $0x23
  800df2:	68 1c 28 80 00       	push   $0x80281c
  800df7:	e8 d7 f2 ff ff       	call   8000d3 <_panic>

00800dfc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e0d:	be 00 00 00 00       	mov    $0x0,%esi
  800e12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e18:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e35:	89 cb                	mov    %ecx,%ebx
  800e37:	89 cf                	mov    %ecx,%edi
  800e39:	89 ce                	mov    %ecx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 0d                	push   $0xd
  800e4f:	68 ff 27 80 00       	push   $0x8027ff
  800e54:	6a 23                	push   $0x23
  800e56:	68 1c 28 80 00       	push   $0x80281c
  800e5b:	e8 73 f2 ff ff       	call   8000d3 <_panic>

00800e60 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  800e6c:	6a 00                	push   $0x0
  800e6e:	ff 75 08             	push   0x8(%ebp)
  800e71:	e8 4c 0d 00 00       	call   801bc2 <open>
  800e76:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  800e7c:	83 c4 10             	add    $0x10,%esp
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	0f 88 d0 04 00 00    	js     801357 <spawn+0x4f7>
  800e87:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  800e89:	83 ec 04             	sub    $0x4,%esp
  800e8c:	68 00 02 00 00       	push   $0x200
  800e91:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	51                   	push   %ecx
  800e99:	e8 0a 09 00 00       	call   8017a8 <readn>
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ea6:	75 57                	jne    800eff <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  800ea8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  800eaf:	45 4c 46 
  800eb2:	75 4b                	jne    800eff <spawn+0x9f>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800eb4:	b8 07 00 00 00       	mov    $0x7,%eax
  800eb9:	cd 30                	int    $0x30
  800ebb:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	0f 88 82 04 00 00    	js     80134b <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  800ec9:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ece:	6b f0 7c             	imul   $0x7c,%eax,%esi
  800ed1:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  800ed7:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  800edd:	b9 11 00 00 00       	mov    $0x11,%ecx
  800ee2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  800ee4:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  800eea:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  800ef0:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  800ef5:	be 00 00 00 00       	mov    $0x0,%esi
  800efa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  800efd:	eb 4b                	jmp    800f4a <spawn+0xea>
		close(fd);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  800f08:	e8 d8 06 00 00       	call   8015e5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  800f0d:	83 c4 0c             	add    $0xc,%esp
  800f10:	68 7f 45 4c 46       	push   $0x464c457f
  800f15:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  800f1b:	68 2a 28 80 00       	push   $0x80282a
  800f20:	e8 89 f2 ff ff       	call   8001ae <cprintf>
		return -E_NOT_EXEC;
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  800f2f:	ff ff ff 
  800f32:	e9 20 04 00 00       	jmp    801357 <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	50                   	push   %eax
  800f3b:	e8 f8 f8 ff ff       	call   800838 <strlen>
  800f40:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  800f44:	83 c3 01             	add    $0x1,%ebx
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  800f51:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 df                	jne    800f37 <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  800f58:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  800f5e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  800f64:	b8 00 10 40 00       	mov    $0x401000,%eax
  800f69:	29 f0                	sub    %esi,%eax
  800f6b:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	83 e2 fc             	and    $0xfffffffc,%edx
  800f72:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  800f79:	29 c2                	sub    %eax,%edx
  800f7b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  800f81:	8d 42 f8             	lea    -0x8(%edx),%eax
  800f84:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  800f89:	0f 86 eb 03 00 00    	jbe    80137a <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	6a 07                	push   $0x7
  800f94:	68 00 00 40 00       	push   $0x400000
  800f99:	6a 00                	push   $0x0
  800f9b:	e8 cf fc ff ff       	call   800c6f <sys_page_alloc>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	0f 88 d4 03 00 00    	js     80137f <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  800fab:	be 00 00 00 00       	mov    $0x0,%esi
  800fb0:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  800fb6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800fb9:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  800fbf:	7e 32                	jle    800ff3 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  800fc1:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  800fc7:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  800fcd:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	ff 34 b3             	push   (%ebx,%esi,4)
  800fd6:	57                   	push   %edi
  800fd7:	e8 97 f8 ff ff       	call   800873 <strcpy>
		string_store += strlen(argv[i]) + 1;
  800fdc:	83 c4 04             	add    $0x4,%esp
  800fdf:	ff 34 b3             	push   (%ebx,%esi,4)
  800fe2:	e8 51 f8 ff ff       	call   800838 <strlen>
  800fe7:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  800feb:	83 c6 01             	add    $0x1,%esi
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	eb c6                	jmp    800fb9 <spawn+0x159>
	}
	argv_store[argc] = 0;
  800ff3:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  800ff9:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  800fff:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801006:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80100c:	0f 85 8c 00 00 00    	jne    80109e <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801012:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801018:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80101e:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801021:	89 f8                	mov    %edi,%eax
  801023:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801029:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80102c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801031:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	6a 07                	push   $0x7
  80103c:	68 00 d0 bf ee       	push   $0xeebfd000
  801041:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801047:	68 00 00 40 00       	push   $0x400000
  80104c:	6a 00                	push   $0x0
  80104e:	e8 5f fc ff ff       	call   800cb2 <sys_page_map>
  801053:	89 c3                	mov    %eax,%ebx
  801055:	83 c4 20             	add    $0x20,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	0f 88 27 03 00 00    	js     801387 <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	68 00 00 40 00       	push   $0x400000
  801068:	6a 00                	push   $0x0
  80106a:	e8 85 fc ff ff       	call   800cf4 <sys_page_unmap>
  80106f:	89 c3                	mov    %eax,%ebx
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	0f 88 0b 03 00 00    	js     801387 <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80107c:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801082:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801089:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80108f:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801096:	00 00 00 
  801099:	e9 4e 01 00 00       	jmp    8011ec <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80109e:	68 b4 28 80 00       	push   $0x8028b4
  8010a3:	68 44 28 80 00       	push   $0x802844
  8010a8:	68 f2 00 00 00       	push   $0xf2
  8010ad:	68 59 28 80 00       	push   $0x802859
  8010b2:	e8 1c f0 ff ff       	call   8000d3 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8010b7:	83 ec 04             	sub    $0x4,%esp
  8010ba:	6a 07                	push   $0x7
  8010bc:	68 00 00 40 00       	push   $0x400000
  8010c1:	6a 00                	push   $0x0
  8010c3:	e8 a7 fb ff ff       	call   800c6f <sys_page_alloc>
  8010c8:	83 c4 10             	add    $0x10,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	0f 88 92 02 00 00    	js     801365 <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8010dc:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8010e9:	e8 83 07 00 00       	call   801871 <seek>
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	0f 88 73 02 00 00    	js     80136c <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	89 f8                	mov    %edi,%eax
  8010fe:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  801104:	ba 00 10 00 00       	mov    $0x1000,%edx
  801109:	39 d0                	cmp    %edx,%eax
  80110b:	0f 47 c2             	cmova  %edx,%eax
  80110e:	50                   	push   %eax
  80110f:	68 00 00 40 00       	push   $0x400000
  801114:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  80111a:	e8 89 06 00 00       	call   8017a8 <readn>
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	85 c0                	test   %eax,%eax
  801124:	0f 88 49 02 00 00    	js     801373 <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80112a:	83 ec 0c             	sub    $0xc,%esp
  80112d:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  801133:	56                   	push   %esi
  801134:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  80113a:	68 00 00 40 00       	push   $0x400000
  80113f:	6a 00                	push   $0x0
  801141:	e8 6c fb ff ff       	call   800cb2 <sys_page_map>
  801146:	83 c4 20             	add    $0x20,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 7c                	js     8011c9 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	68 00 00 40 00       	push   $0x400000
  801155:	6a 00                	push   $0x0
  801157:	e8 98 fb ff ff       	call   800cf4 <sys_page_unmap>
  80115c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80115f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801165:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80116b:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801171:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  801177:	76 65                	jbe    8011de <spawn+0x37e>
		if (i >= filesz) {
  801179:	39 df                	cmp    %ebx,%edi
  80117b:	0f 87 36 ff ff ff    	ja     8010b7 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  80118a:	56                   	push   %esi
  80118b:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801191:	e8 d9 fa ff ff       	call   800c6f <sys_page_alloc>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	79 c2                	jns    80115f <spawn+0x2ff>
  80119d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8011a8:	e8 43 fa ff ff       	call   800bf0 <sys_env_destroy>
	close(fd);
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8011b6:	e8 2a 04 00 00       	call   8015e5 <close>
	return r;
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  8011c4:	e9 8e 01 00 00       	jmp    801357 <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  8011c9:	50                   	push   %eax
  8011ca:	68 65 28 80 00       	push   $0x802865
  8011cf:	68 25 01 00 00       	push   $0x125
  8011d4:	68 59 28 80 00       	push   $0x802859
  8011d9:	e8 f5 ee ff ff       	call   8000d3 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8011de:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8011e5:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  8011ec:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8011f3:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8011f9:	7e 67                	jle    801262 <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  8011fb:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801201:	83 39 01             	cmpl   $0x1,(%ecx)
  801204:	75 d8                	jne    8011de <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801206:	8b 41 18             	mov    0x18(%ecx),%eax
  801209:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80120f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801212:	83 f8 01             	cmp    $0x1,%eax
  801215:	19 c0                	sbb    %eax,%eax
  801217:	83 e0 fe             	and    $0xfffffffe,%eax
  80121a:	83 c0 07             	add    $0x7,%eax
  80121d:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801223:	8b 51 04             	mov    0x4(%ecx),%edx
  801226:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  80122c:	8b 79 10             	mov    0x10(%ecx),%edi
  80122f:	8b 59 14             	mov    0x14(%ecx),%ebx
  801232:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801238:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  80123b:	89 f0                	mov    %esi,%eax
  80123d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801242:	74 14                	je     801258 <spawn+0x3f8>
		va -= i;
  801244:	29 c6                	sub    %eax,%esi
		memsz += i;
  801246:	01 c3                	add    %eax,%ebx
  801248:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  80124e:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801250:	29 c2                	sub    %eax,%edx
  801252:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801258:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125d:	e9 09 ff ff ff       	jmp    80116b <spawn+0x30b>
	close(fd);
  801262:	83 ec 0c             	sub    $0xc,%esp
  801265:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  80126b:	e8 75 03 00 00       	call   8015e5 <close>
  801270:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801273:	bb 00 00 00 00       	mov    $0x0,%ebx
  801278:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80127e:	eb 2d                	jmp    8012ad <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801280:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801287:	89 da                	mov    %ebx,%edx
  801289:	c1 e2 0c             	shl    $0xc,%edx
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	25 07 0e 00 00       	and    $0xe07,%eax
  801294:	50                   	push   %eax
  801295:	52                   	push   %edx
  801296:	56                   	push   %esi
  801297:	52                   	push   %edx
  801298:	6a 00                	push   $0x0
  80129a:	e8 13 fa ff ff       	call   800cb2 <sys_page_map>
  80129f:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  8012a2:	83 c3 01             	add    $0x1,%ebx
  8012a5:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  8012ab:	74 29                	je     8012d6 <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  8012ad:	89 d8                	mov    %ebx,%eax
  8012af:	c1 f8 0a             	sar    $0xa,%eax
  8012b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	74 e5                	je     8012a2 <spawn+0x442>
  8012bd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c4:	a8 01                	test   $0x1,%al
  8012c6:	74 da                	je     8012a2 <spawn+0x442>
  8012c8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012cf:	f6 c4 04             	test   $0x4,%ah
  8012d2:	74 ce                	je     8012a2 <spawn+0x442>
  8012d4:	eb aa                	jmp    801280 <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8012d6:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8012dd:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8012f0:	e8 83 fa ff ff       	call   800d78 <sys_env_set_trapframe>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 25                	js     801321 <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	6a 02                	push   $0x2
  801301:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801307:	e8 2a fa ff ff       	call   800d36 <sys_env_set_status>
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	78 23                	js     801336 <spawn+0x4d6>
	return child;
  801313:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801319:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80131f:	eb 36                	jmp    801357 <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  801321:	50                   	push   %eax
  801322:	68 82 28 80 00       	push   $0x802882
  801327:	68 86 00 00 00       	push   $0x86
  80132c:	68 59 28 80 00       	push   $0x802859
  801331:	e8 9d ed ff ff       	call   8000d3 <_panic>
		panic("sys_env_set_status: %e", r);
  801336:	50                   	push   %eax
  801337:	68 9c 28 80 00       	push   $0x80289c
  80133c:	68 89 00 00 00       	push   $0x89
  801341:	68 59 28 80 00       	push   $0x802859
  801346:	e8 88 ed ff ff       	call   8000d3 <_panic>
		return r;
  80134b:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801351:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  801357:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801360:	5b                   	pop    %ebx
  801361:	5e                   	pop    %esi
  801362:	5f                   	pop    %edi
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    
  801365:	89 c7                	mov    %eax,%edi
  801367:	e9 33 fe ff ff       	jmp    80119f <spawn+0x33f>
  80136c:	89 c7                	mov    %eax,%edi
  80136e:	e9 2c fe ff ff       	jmp    80119f <spawn+0x33f>
  801373:	89 c7                	mov    %eax,%edi
  801375:	e9 25 fe ff ff       	jmp    80119f <spawn+0x33f>
		return -E_NO_MEM;
  80137a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  80137f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801385:	eb d0                	jmp    801357 <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	68 00 00 40 00       	push   $0x400000
  80138f:	6a 00                	push   $0x0
  801391:	e8 5e f9 ff ff       	call   800cf4 <sys_page_unmap>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80139f:	eb b6                	jmp    801357 <spawn+0x4f7>

008013a1 <spawnl>:
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
	va_start(vl, arg0);
  8013a6:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8013ae:	eb 05                	jmp    8013b5 <spawnl+0x14>
		argc++;
  8013b0:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8013b3:	89 ca                	mov    %ecx,%edx
  8013b5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013b8:	83 3a 00             	cmpl   $0x0,(%edx)
  8013bb:	75 f3                	jne    8013b0 <spawnl+0xf>
	const char *argv[argc+2];
  8013bd:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8013c4:	89 d3                	mov    %edx,%ebx
  8013c6:	83 e3 f0             	and    $0xfffffff0,%ebx
  8013c9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013cf:	89 e1                	mov    %esp,%ecx
  8013d1:	29 d1                	sub    %edx,%ecx
  8013d3:	39 cc                	cmp    %ecx,%esp
  8013d5:	74 10                	je     8013e7 <spawnl+0x46>
  8013d7:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8013dd:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8013e4:	00 
  8013e5:	eb ec                	jmp    8013d3 <spawnl+0x32>
  8013e7:	89 da                	mov    %ebx,%edx
  8013e9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8013ef:	29 d4                	sub    %edx,%esp
  8013f1:	85 d2                	test   %edx,%edx
  8013f3:	74 05                	je     8013fa <spawnl+0x59>
  8013f5:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8013fa:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  8013fe:	89 da                	mov    %ebx,%edx
  801400:	c1 ea 02             	shr    $0x2,%edx
  801403:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  801406:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801409:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801410:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  801417:	00 
	va_start(vl, arg0);
  801418:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80141b:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
  801422:	eb 0b                	jmp    80142f <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  801424:	83 c0 01             	add    $0x1,%eax
  801427:	8b 31                	mov    (%ecx),%esi
  801429:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  80142c:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80142f:	39 d0                	cmp    %edx,%eax
  801431:	75 f1                	jne    801424 <spawnl+0x83>
	return spawn(prog, argv);
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	53                   	push   %ebx
  801437:	ff 75 08             	push   0x8(%ebp)
  80143a:	e8 21 fa ff ff       	call   800e60 <spawn>
}
  80143f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	05 00 00 00 30       	add    $0x30000000,%eax
  801451:	c1 e8 0c             	shr    $0xc,%eax
}
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801461:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801466:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80146b:	5d                   	pop    %ebp
  80146c:	c3                   	ret    

0080146d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801475:	89 c2                	mov    %eax,%edx
  801477:	c1 ea 16             	shr    $0x16,%edx
  80147a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801481:	f6 c2 01             	test   $0x1,%dl
  801484:	74 29                	je     8014af <fd_alloc+0x42>
  801486:	89 c2                	mov    %eax,%edx
  801488:	c1 ea 0c             	shr    $0xc,%edx
  80148b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801492:	f6 c2 01             	test   $0x1,%dl
  801495:	74 18                	je     8014af <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801497:	05 00 10 00 00       	add    $0x1000,%eax
  80149c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014a1:	75 d2                	jne    801475 <fd_alloc+0x8>
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8014a8:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8014ad:	eb 05                	jmp    8014b4 <fd_alloc+0x47>
			return 0;
  8014af:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8014b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b7:	89 02                	mov    %eax,(%edx)
}
  8014b9:	89 c8                	mov    %ecx,%eax
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014c3:	83 f8 1f             	cmp    $0x1f,%eax
  8014c6:	77 30                	ja     8014f8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014c8:	c1 e0 0c             	shl    $0xc,%eax
  8014cb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014d0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014d6:	f6 c2 01             	test   $0x1,%dl
  8014d9:	74 24                	je     8014ff <fd_lookup+0x42>
  8014db:	89 c2                	mov    %eax,%edx
  8014dd:	c1 ea 0c             	shr    $0xc,%edx
  8014e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014e7:	f6 c2 01             	test   $0x1,%dl
  8014ea:	74 1a                	je     801506 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ef:	89 02                	mov    %eax,(%edx)
	return 0;
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    
		return -E_INVAL;
  8014f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fd:	eb f7                	jmp    8014f6 <fd_lookup+0x39>
		return -E_INVAL;
  8014ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801504:	eb f0                	jmp    8014f6 <fd_lookup+0x39>
  801506:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150b:	eb e9                	jmp    8014f6 <fd_lookup+0x39>

0080150d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	53                   	push   %ebx
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	8b 55 08             	mov    0x8(%ebp),%edx
  801517:	b8 58 29 80 00       	mov    $0x802958,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  80151c:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801521:	39 13                	cmp    %edx,(%ebx)
  801523:	74 32                	je     801557 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  801525:	83 c0 04             	add    $0x4,%eax
  801528:	8b 18                	mov    (%eax),%ebx
  80152a:	85 db                	test   %ebx,%ebx
  80152c:	75 f3                	jne    801521 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80152e:	a1 00 40 80 00       	mov    0x804000,%eax
  801533:	8b 40 48             	mov    0x48(%eax),%eax
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	68 dc 28 80 00       	push   $0x8028dc
  801540:	e8 69 ec ff ff       	call   8001ae <cprintf>
	*dev = 0;
	return -E_INVAL;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	89 1a                	mov    %ebx,(%edx)
}
  801552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801555:	c9                   	leave  
  801556:	c3                   	ret    
			return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
  80155c:	eb ef                	jmp    80154d <dev_lookup+0x40>

0080155e <fd_close>:
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 24             	sub    $0x24,%esp
  801567:	8b 75 08             	mov    0x8(%ebp),%esi
  80156a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80156d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801570:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801571:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801577:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80157a:	50                   	push   %eax
  80157b:	e8 3d ff ff ff       	call   8014bd <fd_lookup>
  801580:	89 c3                	mov    %eax,%ebx
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	78 05                	js     80158e <fd_close+0x30>
	    || fd != fd2)
  801589:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80158c:	74 16                	je     8015a4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80158e:	89 f8                	mov    %edi,%eax
  801590:	84 c0                	test   %al,%al
  801592:	b8 00 00 00 00       	mov    $0x0,%eax
  801597:	0f 44 d8             	cmove  %eax,%ebx
}
  80159a:	89 d8                	mov    %ebx,%eax
  80159c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5f                   	pop    %edi
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 36                	push   (%esi)
  8015ad:	e8 5b ff ff ff       	call   80150d <dev_lookup>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 1a                	js     8015d5 <fd_close+0x77>
		if (dev->dev_close)
  8015bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	74 0b                	je     8015d5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015ca:	83 ec 0c             	sub    $0xc,%esp
  8015cd:	56                   	push   %esi
  8015ce:	ff d0                	call   *%eax
  8015d0:	89 c3                	mov    %eax,%ebx
  8015d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	56                   	push   %esi
  8015d9:	6a 00                	push   $0x0
  8015db:	e8 14 f7 ff ff       	call   800cf4 <sys_page_unmap>
	return r;
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	eb b5                	jmp    80159a <fd_close+0x3c>

008015e5 <close>:

int
close(int fdnum)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ee:	50                   	push   %eax
  8015ef:	ff 75 08             	push   0x8(%ebp)
  8015f2:	e8 c6 fe ff ff       	call   8014bd <fd_lookup>
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	79 02                	jns    801600 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
		return fd_close(fd, 1);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	6a 01                	push   $0x1
  801605:	ff 75 f4             	push   -0xc(%ebp)
  801608:	e8 51 ff ff ff       	call   80155e <fd_close>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	eb ec                	jmp    8015fe <close+0x19>

00801612 <close_all>:

void
close_all(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801619:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	53                   	push   %ebx
  801622:	e8 be ff ff ff       	call   8015e5 <close>
	for (i = 0; i < MAXFD; i++)
  801627:	83 c3 01             	add    $0x1,%ebx
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	83 fb 20             	cmp    $0x20,%ebx
  801630:	75 ec                	jne    80161e <close_all+0xc>
}
  801632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	57                   	push   %edi
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
  80163d:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801643:	50                   	push   %eax
  801644:	ff 75 08             	push   0x8(%ebp)
  801647:	e8 71 fe ff ff       	call   8014bd <fd_lookup>
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 7f                	js     8016d4 <dup+0x9d>
		return r;
	close(newfdnum);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	ff 75 0c             	push   0xc(%ebp)
  80165b:	e8 85 ff ff ff       	call   8015e5 <close>

	newfd = INDEX2FD(newfdnum);
  801660:	8b 75 0c             	mov    0xc(%ebp),%esi
  801663:	c1 e6 0c             	shl    $0xc,%esi
  801666:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80166c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80166f:	89 3c 24             	mov    %edi,(%esp)
  801672:	e8 df fd ff ff       	call   801456 <fd2data>
  801677:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801679:	89 34 24             	mov    %esi,(%esp)
  80167c:	e8 d5 fd ff ff       	call   801456 <fd2data>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801687:	89 d8                	mov    %ebx,%eax
  801689:	c1 e8 16             	shr    $0x16,%eax
  80168c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801693:	a8 01                	test   $0x1,%al
  801695:	74 11                	je     8016a8 <dup+0x71>
  801697:	89 d8                	mov    %ebx,%eax
  801699:	c1 e8 0c             	shr    $0xc,%eax
  80169c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016a3:	f6 c2 01             	test   $0x1,%dl
  8016a6:	75 36                	jne    8016de <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016a8:	89 f8                	mov    %edi,%eax
  8016aa:	c1 e8 0c             	shr    $0xc,%eax
  8016ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8016bc:	50                   	push   %eax
  8016bd:	56                   	push   %esi
  8016be:	6a 00                	push   $0x0
  8016c0:	57                   	push   %edi
  8016c1:	6a 00                	push   $0x0
  8016c3:	e8 ea f5 ff ff       	call   800cb2 <sys_page_map>
  8016c8:	89 c3                	mov    %eax,%ebx
  8016ca:	83 c4 20             	add    $0x20,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 33                	js     801704 <dup+0xcd>
		goto err;

	return newfdnum;
  8016d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016d4:	89 d8                	mov    %ebx,%eax
  8016d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5e                   	pop    %esi
  8016db:	5f                   	pop    %edi
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 d4             	push   -0x2c(%ebp)
  8016f1:	6a 00                	push   $0x0
  8016f3:	53                   	push   %ebx
  8016f4:	6a 00                	push   $0x0
  8016f6:	e8 b7 f5 ff ff       	call   800cb2 <sys_page_map>
  8016fb:	89 c3                	mov    %eax,%ebx
  8016fd:	83 c4 20             	add    $0x20,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	79 a4                	jns    8016a8 <dup+0x71>
	sys_page_unmap(0, newfd);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	56                   	push   %esi
  801708:	6a 00                	push   $0x0
  80170a:	e8 e5 f5 ff ff       	call   800cf4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80170f:	83 c4 08             	add    $0x8,%esp
  801712:	ff 75 d4             	push   -0x2c(%ebp)
  801715:	6a 00                	push   $0x0
  801717:	e8 d8 f5 ff ff       	call   800cf4 <sys_page_unmap>
	return r;
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	eb b3                	jmp    8016d4 <dup+0x9d>

00801721 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	56                   	push   %esi
  801725:	53                   	push   %ebx
  801726:	83 ec 18             	sub    $0x18,%esp
  801729:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80172f:	50                   	push   %eax
  801730:	56                   	push   %esi
  801731:	e8 87 fd ff ff       	call   8014bd <fd_lookup>
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 3c                	js     801779 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	ff 33                	push   (%ebx)
  801749:	e8 bf fd ff ff       	call   80150d <dev_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	78 24                	js     801779 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801755:	8b 43 08             	mov    0x8(%ebx),%eax
  801758:	83 e0 03             	and    $0x3,%eax
  80175b:	83 f8 01             	cmp    $0x1,%eax
  80175e:	74 20                	je     801780 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801763:	8b 40 08             	mov    0x8(%eax),%eax
  801766:	85 c0                	test   %eax,%eax
  801768:	74 37                	je     8017a1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	ff 75 10             	push   0x10(%ebp)
  801770:	ff 75 0c             	push   0xc(%ebp)
  801773:	53                   	push   %ebx
  801774:	ff d0                	call   *%eax
  801776:	83 c4 10             	add    $0x10,%esp
}
  801779:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801780:	a1 00 40 80 00       	mov    0x804000,%eax
  801785:	8b 40 48             	mov    0x48(%eax),%eax
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	56                   	push   %esi
  80178c:	50                   	push   %eax
  80178d:	68 1d 29 80 00       	push   $0x80291d
  801792:	e8 17 ea ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179f:	eb d8                	jmp    801779 <read+0x58>
		return -E_NOT_SUPP;
  8017a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a6:	eb d1                	jmp    801779 <read+0x58>

008017a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	57                   	push   %edi
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bc:	eb 02                	jmp    8017c0 <readn+0x18>
  8017be:	01 c3                	add    %eax,%ebx
  8017c0:	39 f3                	cmp    %esi,%ebx
  8017c2:	73 21                	jae    8017e5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	89 f0                	mov    %esi,%eax
  8017c9:	29 d8                	sub    %ebx,%eax
  8017cb:	50                   	push   %eax
  8017cc:	89 d8                	mov    %ebx,%eax
  8017ce:	03 45 0c             	add    0xc(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	57                   	push   %edi
  8017d3:	e8 49 ff ff ff       	call   801721 <read>
		if (m < 0)
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 04                	js     8017e3 <readn+0x3b>
			return m;
		if (m == 0)
  8017df:	75 dd                	jne    8017be <readn+0x16>
  8017e1:	eb 02                	jmp    8017e5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017e5:	89 d8                	mov    %ebx,%eax
  8017e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5f                   	pop    %edi
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	56                   	push   %esi
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 18             	sub    $0x18,%esp
  8017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fd:	50                   	push   %eax
  8017fe:	53                   	push   %ebx
  8017ff:	e8 b9 fc ff ff       	call   8014bd <fd_lookup>
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 37                	js     801842 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180b:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	ff 36                	push   (%esi)
  801817:	e8 f1 fc ff ff       	call   80150d <dev_lookup>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 1f                	js     801842 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801823:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801827:	74 20                	je     801849 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182c:	8b 40 0c             	mov    0xc(%eax),%eax
  80182f:	85 c0                	test   %eax,%eax
  801831:	74 37                	je     80186a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	ff 75 10             	push   0x10(%ebp)
  801839:	ff 75 0c             	push   0xc(%ebp)
  80183c:	56                   	push   %esi
  80183d:	ff d0                	call   *%eax
  80183f:	83 c4 10             	add    $0x10,%esp
}
  801842:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801849:	a1 00 40 80 00       	mov    0x804000,%eax
  80184e:	8b 40 48             	mov    0x48(%eax),%eax
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	53                   	push   %ebx
  801855:	50                   	push   %eax
  801856:	68 39 29 80 00       	push   $0x802939
  80185b:	e8 4e e9 ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801868:	eb d8                	jmp    801842 <write+0x53>
		return -E_NOT_SUPP;
  80186a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186f:	eb d1                	jmp    801842 <write+0x53>

00801871 <seek>:

int
seek(int fdnum, off_t offset)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187a:	50                   	push   %eax
  80187b:	ff 75 08             	push   0x8(%ebp)
  80187e:	e8 3a fc ff ff       	call   8014bd <fd_lookup>
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	85 c0                	test   %eax,%eax
  801888:	78 0e                	js     801898 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801890:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 18             	sub    $0x18,%esp
  8018a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a8:	50                   	push   %eax
  8018a9:	53                   	push   %ebx
  8018aa:	e8 0e fc ff ff       	call   8014bd <fd_lookup>
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 34                	js     8018ea <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b6:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bf:	50                   	push   %eax
  8018c0:	ff 36                	push   (%esi)
  8018c2:	e8 46 fc ff ff       	call   80150d <dev_lookup>
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 1c                	js     8018ea <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ce:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8018d2:	74 1d                	je     8018f1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	8b 40 18             	mov    0x18(%eax),%eax
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	74 34                	je     801912 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	ff 75 0c             	push   0xc(%ebp)
  8018e4:	56                   	push   %esi
  8018e5:	ff d0                	call   *%eax
  8018e7:	83 c4 10             	add    $0x10,%esp
}
  8018ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018f1:	a1 00 40 80 00       	mov    0x804000,%eax
  8018f6:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	53                   	push   %ebx
  8018fd:	50                   	push   %eax
  8018fe:	68 fc 28 80 00       	push   $0x8028fc
  801903:	e8 a6 e8 ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801910:	eb d8                	jmp    8018ea <ftruncate+0x50>
		return -E_NOT_SUPP;
  801912:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801917:	eb d1                	jmp    8018ea <ftruncate+0x50>

00801919 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	83 ec 18             	sub    $0x18,%esp
  801921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801924:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801927:	50                   	push   %eax
  801928:	ff 75 08             	push   0x8(%ebp)
  80192b:	e8 8d fb ff ff       	call   8014bd <fd_lookup>
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	78 49                	js     801980 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801937:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801940:	50                   	push   %eax
  801941:	ff 36                	push   (%esi)
  801943:	e8 c5 fb ff ff       	call   80150d <dev_lookup>
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 31                	js     801980 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  80194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801952:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801956:	74 2f                	je     801987 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801958:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80195b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801962:	00 00 00 
	stat->st_isdir = 0;
  801965:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80196c:	00 00 00 
	stat->st_dev = dev;
  80196f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	53                   	push   %ebx
  801979:	56                   	push   %esi
  80197a:	ff 50 14             	call   *0x14(%eax)
  80197d:	83 c4 10             	add    $0x10,%esp
}
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    
		return -E_NOT_SUPP;
  801987:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198c:	eb f2                	jmp    801980 <fstat+0x67>

0080198e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	6a 00                	push   $0x0
  801998:	ff 75 08             	push   0x8(%ebp)
  80199b:	e8 22 02 00 00       	call   801bc2 <open>
  8019a0:	89 c3                	mov    %eax,%ebx
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 1b                	js     8019c4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	ff 75 0c             	push   0xc(%ebp)
  8019af:	50                   	push   %eax
  8019b0:	e8 64 ff ff ff       	call   801919 <fstat>
  8019b5:	89 c6                	mov    %eax,%esi
	close(fd);
  8019b7:	89 1c 24             	mov    %ebx,(%esp)
  8019ba:	e8 26 fc ff ff       	call   8015e5 <close>
	return r;
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	89 f3                	mov    %esi,%ebx
}
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5e                   	pop    %esi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	56                   	push   %esi
  8019d1:	53                   	push   %ebx
  8019d2:	89 c6                	mov    %eax,%esi
  8019d4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019d6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8019dd:	74 27                	je     801a06 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019df:	6a 07                	push   $0x7
  8019e1:	68 00 50 80 00       	push   $0x805000
  8019e6:	56                   	push   %esi
  8019e7:	ff 35 00 60 80 00    	push   0x806000
  8019ed:	e8 82 07 00 00       	call   802174 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019f2:	83 c4 0c             	add    $0xc,%esp
  8019f5:	6a 00                	push   $0x0
  8019f7:	53                   	push   %ebx
  8019f8:	6a 00                	push   $0x0
  8019fa:	e8 26 07 00 00       	call   802125 <ipc_recv>
}
  8019ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	6a 01                	push   $0x1
  801a0b:	e8 b0 07 00 00       	call   8021c0 <ipc_find_env>
  801a10:	a3 00 60 80 00       	mov    %eax,0x806000
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	eb c5                	jmp    8019df <fsipc+0x12>

00801a1a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8b 40 0c             	mov    0xc(%eax),%eax
  801a26:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a33:	ba 00 00 00 00       	mov    $0x0,%edx
  801a38:	b8 02 00 00 00       	mov    $0x2,%eax
  801a3d:	e8 8b ff ff ff       	call   8019cd <fsipc>
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <devfile_flush>:
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a50:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a55:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5a:	b8 06 00 00 00       	mov    $0x6,%eax
  801a5f:	e8 69 ff ff ff       	call   8019cd <fsipc>
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <devfile_stat>:
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8b 40 0c             	mov    0xc(%eax),%eax
  801a76:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	b8 05 00 00 00       	mov    $0x5,%eax
  801a85:	e8 43 ff ff ff       	call   8019cd <fsipc>
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 2c                	js     801aba <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	68 00 50 80 00       	push   $0x805000
  801a96:	53                   	push   %ebx
  801a97:	e8 d7 ed ff ff       	call   800873 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a9c:	a1 80 50 80 00       	mov    0x805080,%eax
  801aa1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aa7:	a1 84 50 80 00       	mov    0x805084,%eax
  801aac:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <devfile_write>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 40 0c             	mov    0xc(%eax),%eax
  801acf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801ad4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ada:	53                   	push   %ebx
  801adb:	ff 75 0c             	push   0xc(%ebp)
  801ade:	68 08 50 80 00       	push   $0x805008
  801ae3:	e8 83 ef ff ff       	call   800a6b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aed:	b8 04 00 00 00       	mov    $0x4,%eax
  801af2:	e8 d6 fe ff ff       	call   8019cd <fsipc>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 0b                	js     801b09 <devfile_write+0x4a>
	assert(r <= n);
  801afe:	39 d8                	cmp    %ebx,%eax
  801b00:	77 0c                	ja     801b0e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b02:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b07:	7f 1e                	jg     801b27 <devfile_write+0x68>
}
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    
	assert(r <= n);
  801b0e:	68 68 29 80 00       	push   $0x802968
  801b13:	68 44 28 80 00       	push   $0x802844
  801b18:	68 97 00 00 00       	push   $0x97
  801b1d:	68 6f 29 80 00       	push   $0x80296f
  801b22:	e8 ac e5 ff ff       	call   8000d3 <_panic>
	assert(r <= PGSIZE);
  801b27:	68 7a 29 80 00       	push   $0x80297a
  801b2c:	68 44 28 80 00       	push   $0x802844
  801b31:	68 98 00 00 00       	push   $0x98
  801b36:	68 6f 29 80 00       	push   $0x80296f
  801b3b:	e8 93 e5 ff ff       	call   8000d3 <_panic>

00801b40 <devfile_read>:
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b53:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5e:	b8 03 00 00 00       	mov    $0x3,%eax
  801b63:	e8 65 fe ff ff       	call   8019cd <fsipc>
  801b68:	89 c3                	mov    %eax,%ebx
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 1f                	js     801b8d <devfile_read+0x4d>
	assert(r <= n);
  801b6e:	39 f0                	cmp    %esi,%eax
  801b70:	77 24                	ja     801b96 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b72:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b77:	7f 33                	jg     801bac <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b79:	83 ec 04             	sub    $0x4,%esp
  801b7c:	50                   	push   %eax
  801b7d:	68 00 50 80 00       	push   $0x805000
  801b82:	ff 75 0c             	push   0xc(%ebp)
  801b85:	e8 7f ee ff ff       	call   800a09 <memmove>
	return r;
  801b8a:	83 c4 10             	add    $0x10,%esp
}
  801b8d:	89 d8                	mov    %ebx,%eax
  801b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
	assert(r <= n);
  801b96:	68 68 29 80 00       	push   $0x802968
  801b9b:	68 44 28 80 00       	push   $0x802844
  801ba0:	6a 7c                	push   $0x7c
  801ba2:	68 6f 29 80 00       	push   $0x80296f
  801ba7:	e8 27 e5 ff ff       	call   8000d3 <_panic>
	assert(r <= PGSIZE);
  801bac:	68 7a 29 80 00       	push   $0x80297a
  801bb1:	68 44 28 80 00       	push   $0x802844
  801bb6:	6a 7d                	push   $0x7d
  801bb8:	68 6f 29 80 00       	push   $0x80296f
  801bbd:	e8 11 e5 ff ff       	call   8000d3 <_panic>

00801bc2 <open>:
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 1c             	sub    $0x1c,%esp
  801bca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bcd:	56                   	push   %esi
  801bce:	e8 65 ec ff ff       	call   800838 <strlen>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bdb:	7f 6c                	jg     801c49 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	e8 84 f8 ff ff       	call   80146d <fd_alloc>
  801be9:	89 c3                	mov    %eax,%ebx
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 3c                	js     801c2e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bf2:	83 ec 08             	sub    $0x8,%esp
  801bf5:	56                   	push   %esi
  801bf6:	68 00 50 80 00       	push   $0x805000
  801bfb:	e8 73 ec ff ff       	call   800873 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c10:	e8 b8 fd ff ff       	call   8019cd <fsipc>
  801c15:	89 c3                	mov    %eax,%ebx
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 19                	js     801c37 <open+0x75>
	return fd2num(fd);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	ff 75 f4             	push   -0xc(%ebp)
  801c24:	e8 1d f8 ff ff       	call   801446 <fd2num>
  801c29:	89 c3                	mov    %eax,%ebx
  801c2b:	83 c4 10             	add    $0x10,%esp
}
  801c2e:	89 d8                	mov    %ebx,%eax
  801c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    
		fd_close(fd, 0);
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 f4             	push   -0xc(%ebp)
  801c3f:	e8 1a f9 ff ff       	call   80155e <fd_close>
		return r;
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	eb e5                	jmp    801c2e <open+0x6c>
		return -E_BAD_PATH;
  801c49:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c4e:	eb de                	jmp    801c2e <open+0x6c>

00801c50 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c56:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c60:	e8 68 fd ff ff       	call   8019cd <fsipc>
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	ff 75 08             	push   0x8(%ebp)
  801c75:	e8 dc f7 ff ff       	call   801456 <fd2data>
  801c7a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c7c:	83 c4 08             	add    $0x8,%esp
  801c7f:	68 86 29 80 00       	push   $0x802986
  801c84:	53                   	push   %ebx
  801c85:	e8 e9 eb ff ff       	call   800873 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c8a:	8b 46 04             	mov    0x4(%esi),%eax
  801c8d:	2b 06                	sub    (%esi),%eax
  801c8f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c95:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9c:	00 00 00 
	stat->st_dev = &devpipe;
  801c9f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ca6:	30 80 00 
	return 0;
}
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb1:	5b                   	pop    %ebx
  801cb2:	5e                   	pop    %esi
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	53                   	push   %ebx
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cbf:	53                   	push   %ebx
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 2d f0 ff ff       	call   800cf4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cc7:	89 1c 24             	mov    %ebx,(%esp)
  801cca:	e8 87 f7 ff ff       	call   801456 <fd2data>
  801ccf:	83 c4 08             	add    $0x8,%esp
  801cd2:	50                   	push   %eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	e8 1a f0 ff ff       	call   800cf4 <sys_page_unmap>
}
  801cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <_pipeisclosed>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	57                   	push   %edi
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 1c             	sub    $0x1c,%esp
  801ce8:	89 c7                	mov    %eax,%edi
  801cea:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cec:	a1 00 40 80 00       	mov    0x804000,%eax
  801cf1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	57                   	push   %edi
  801cf8:	e8 fc 04 00 00       	call   8021f9 <pageref>
  801cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d00:	89 34 24             	mov    %esi,(%esp)
  801d03:	e8 f1 04 00 00       	call   8021f9 <pageref>
		nn = thisenv->env_runs;
  801d08:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801d0e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	39 cb                	cmp    %ecx,%ebx
  801d16:	74 1b                	je     801d33 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d18:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1b:	75 cf                	jne    801cec <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d1d:	8b 42 58             	mov    0x58(%edx),%eax
  801d20:	6a 01                	push   $0x1
  801d22:	50                   	push   %eax
  801d23:	53                   	push   %ebx
  801d24:	68 8d 29 80 00       	push   $0x80298d
  801d29:	e8 80 e4 ff ff       	call   8001ae <cprintf>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	eb b9                	jmp    801cec <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d33:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d36:	0f 94 c0             	sete   %al
  801d39:	0f b6 c0             	movzbl %al,%eax
}
  801d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5f                   	pop    %edi
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    

00801d44 <devpipe_write>:
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	57                   	push   %edi
  801d48:	56                   	push   %esi
  801d49:	53                   	push   %ebx
  801d4a:	83 ec 28             	sub    $0x28,%esp
  801d4d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d50:	56                   	push   %esi
  801d51:	e8 00 f7 ff ff       	call   801456 <fd2data>
  801d56:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d60:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d63:	75 09                	jne    801d6e <devpipe_write+0x2a>
	return i;
  801d65:	89 f8                	mov    %edi,%eax
  801d67:	eb 23                	jmp    801d8c <devpipe_write+0x48>
			sys_yield();
  801d69:	e8 e2 ee ff ff       	call   800c50 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d6e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d71:	8b 0b                	mov    (%ebx),%ecx
  801d73:	8d 51 20             	lea    0x20(%ecx),%edx
  801d76:	39 d0                	cmp    %edx,%eax
  801d78:	72 1a                	jb     801d94 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801d7a:	89 da                	mov    %ebx,%edx
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	e8 5c ff ff ff       	call   801cdf <_pipeisclosed>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	74 e2                	je     801d69 <devpipe_write+0x25>
				return 0;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d97:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d9b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d9e:	89 c2                	mov    %eax,%edx
  801da0:	c1 fa 1f             	sar    $0x1f,%edx
  801da3:	89 d1                	mov    %edx,%ecx
  801da5:	c1 e9 1b             	shr    $0x1b,%ecx
  801da8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dab:	83 e2 1f             	and    $0x1f,%edx
  801dae:	29 ca                	sub    %ecx,%edx
  801db0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801db4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801db8:	83 c0 01             	add    $0x1,%eax
  801dbb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dbe:	83 c7 01             	add    $0x1,%edi
  801dc1:	eb 9d                	jmp    801d60 <devpipe_write+0x1c>

00801dc3 <devpipe_read>:
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	57                   	push   %edi
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 18             	sub    $0x18,%esp
  801dcc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dcf:	57                   	push   %edi
  801dd0:	e8 81 f6 ff ff       	call   801456 <fd2data>
  801dd5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	be 00 00 00 00       	mov    $0x0,%esi
  801ddf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801de2:	75 13                	jne    801df7 <devpipe_read+0x34>
	return i;
  801de4:	89 f0                	mov    %esi,%eax
  801de6:	eb 02                	jmp    801dea <devpipe_read+0x27>
				return i;
  801de8:	89 f0                	mov    %esi,%eax
}
  801dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5f                   	pop    %edi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    
			sys_yield();
  801df2:	e8 59 ee ff ff       	call   800c50 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801df7:	8b 03                	mov    (%ebx),%eax
  801df9:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dfc:	75 18                	jne    801e16 <devpipe_read+0x53>
			if (i > 0)
  801dfe:	85 f6                	test   %esi,%esi
  801e00:	75 e6                	jne    801de8 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801e02:	89 da                	mov    %ebx,%edx
  801e04:	89 f8                	mov    %edi,%eax
  801e06:	e8 d4 fe ff ff       	call   801cdf <_pipeisclosed>
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	74 e3                	je     801df2 <devpipe_read+0x2f>
				return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	eb d4                	jmp    801dea <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e16:	99                   	cltd   
  801e17:	c1 ea 1b             	shr    $0x1b,%edx
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	83 e0 1f             	and    $0x1f,%eax
  801e1f:	29 d0                	sub    %edx,%eax
  801e21:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e29:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e2c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e2f:	83 c6 01             	add    $0x1,%esi
  801e32:	eb ab                	jmp    801ddf <devpipe_read+0x1c>

00801e34 <pipe>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	e8 28 f6 ff ff       	call   80146d <fd_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	0f 88 23 01 00 00    	js     801f75 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	68 07 04 00 00       	push   $0x407
  801e5a:	ff 75 f4             	push   -0xc(%ebp)
  801e5d:	6a 00                	push   $0x0
  801e5f:	e8 0b ee ff ff       	call   800c6f <sys_page_alloc>
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	0f 88 04 01 00 00    	js     801f75 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e77:	50                   	push   %eax
  801e78:	e8 f0 f5 ff ff       	call   80146d <fd_alloc>
  801e7d:	89 c3                	mov    %eax,%ebx
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	0f 88 db 00 00 00    	js     801f65 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8a:	83 ec 04             	sub    $0x4,%esp
  801e8d:	68 07 04 00 00       	push   $0x407
  801e92:	ff 75 f0             	push   -0x10(%ebp)
  801e95:	6a 00                	push   $0x0
  801e97:	e8 d3 ed ff ff       	call   800c6f <sys_page_alloc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	0f 88 bc 00 00 00    	js     801f65 <pipe+0x131>
	va = fd2data(fd0);
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	ff 75 f4             	push   -0xc(%ebp)
  801eaf:	e8 a2 f5 ff ff       	call   801456 <fd2data>
  801eb4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb6:	83 c4 0c             	add    $0xc,%esp
  801eb9:	68 07 04 00 00       	push   $0x407
  801ebe:	50                   	push   %eax
  801ebf:	6a 00                	push   $0x0
  801ec1:	e8 a9 ed ff ff       	call   800c6f <sys_page_alloc>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	0f 88 82 00 00 00    	js     801f55 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	ff 75 f0             	push   -0x10(%ebp)
  801ed9:	e8 78 f5 ff ff       	call   801456 <fd2data>
  801ede:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ee5:	50                   	push   %eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	56                   	push   %esi
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 c2 ed ff ff       	call   800cb2 <sys_page_map>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 20             	add    $0x20,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	78 4e                	js     801f47 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ef9:	a1 20 30 80 00       	mov    0x803020,%eax
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f10:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	ff 75 f4             	push   -0xc(%ebp)
  801f22:	e8 1f f5 ff ff       	call   801446 <fd2num>
  801f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f2c:	83 c4 04             	add    $0x4,%esp
  801f2f:	ff 75 f0             	push   -0x10(%ebp)
  801f32:	e8 0f f5 ff ff       	call   801446 <fd2num>
  801f37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f45:	eb 2e                	jmp    801f75 <pipe+0x141>
	sys_page_unmap(0, va);
  801f47:	83 ec 08             	sub    $0x8,%esp
  801f4a:	56                   	push   %esi
  801f4b:	6a 00                	push   $0x0
  801f4d:	e8 a2 ed ff ff       	call   800cf4 <sys_page_unmap>
  801f52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	ff 75 f0             	push   -0x10(%ebp)
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 92 ed ff ff       	call   800cf4 <sys_page_unmap>
  801f62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f65:	83 ec 08             	sub    $0x8,%esp
  801f68:	ff 75 f4             	push   -0xc(%ebp)
  801f6b:	6a 00                	push   $0x0
  801f6d:	e8 82 ed ff ff       	call   800cf4 <sys_page_unmap>
  801f72:	83 c4 10             	add    $0x10,%esp
}
  801f75:	89 d8                	mov    %ebx,%eax
  801f77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <pipeisclosed>:
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f87:	50                   	push   %eax
  801f88:	ff 75 08             	push   0x8(%ebp)
  801f8b:	e8 2d f5 ff ff       	call   8014bd <fd_lookup>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 18                	js     801faf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	ff 75 f4             	push   -0xc(%ebp)
  801f9d:	e8 b4 f4 ff ff       	call   801456 <fd2data>
  801fa2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	e8 33 fd ff ff       	call   801cdf <_pipeisclosed>
  801fac:	83 c4 10             	add    $0x10,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	c3                   	ret    

00801fb7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fbd:	68 a5 29 80 00       	push   $0x8029a5
  801fc2:	ff 75 0c             	push   0xc(%ebp)
  801fc5:	e8 a9 e8 ff ff       	call   800873 <strcpy>
	return 0;
}
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <devcons_write>:
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	57                   	push   %edi
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fdd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe8:	eb 2e                	jmp    802018 <devcons_write+0x47>
		m = n - tot;
  801fea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fed:	29 f3                	sub    %esi,%ebx
  801fef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ff4:	39 c3                	cmp    %eax,%ebx
  801ff6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	53                   	push   %ebx
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	03 45 0c             	add    0xc(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	57                   	push   %edi
  802004:	e8 00 ea ff ff       	call   800a09 <memmove>
		sys_cputs(buf, m);
  802009:	83 c4 08             	add    $0x8,%esp
  80200c:	53                   	push   %ebx
  80200d:	57                   	push   %edi
  80200e:	e8 a0 eb ff ff       	call   800bb3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802013:	01 de                	add    %ebx,%esi
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	3b 75 10             	cmp    0x10(%ebp),%esi
  80201b:	72 cd                	jb     801fea <devcons_write+0x19>
}
  80201d:	89 f0                	mov    %esi,%eax
  80201f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802022:	5b                   	pop    %ebx
  802023:	5e                   	pop    %esi
  802024:	5f                   	pop    %edi
  802025:	5d                   	pop    %ebp
  802026:	c3                   	ret    

00802027 <devcons_read>:
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802032:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802036:	75 07                	jne    80203f <devcons_read+0x18>
  802038:	eb 1f                	jmp    802059 <devcons_read+0x32>
		sys_yield();
  80203a:	e8 11 ec ff ff       	call   800c50 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80203f:	e8 8d eb ff ff       	call   800bd1 <sys_cgetc>
  802044:	85 c0                	test   %eax,%eax
  802046:	74 f2                	je     80203a <devcons_read+0x13>
	if (c < 0)
  802048:	78 0f                	js     802059 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80204a:	83 f8 04             	cmp    $0x4,%eax
  80204d:	74 0c                	je     80205b <devcons_read+0x34>
	*(char*)vbuf = c;
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	88 02                	mov    %al,(%edx)
	return 1;
  802054:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    
		return 0;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	eb f7                	jmp    802059 <devcons_read+0x32>

00802062 <cputchar>:
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80206e:	6a 01                	push   $0x1
  802070:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	e8 3a eb ff ff       	call   800bb3 <sys_cputs>
}
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <getchar>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802084:	6a 01                	push   $0x1
  802086:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	6a 00                	push   $0x0
  80208c:	e8 90 f6 ff ff       	call   801721 <read>
	if (r < 0)
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	85 c0                	test   %eax,%eax
  802096:	78 06                	js     80209e <getchar+0x20>
	if (r < 1)
  802098:	74 06                	je     8020a0 <getchar+0x22>
	return c;
  80209a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    
		return -E_EOF;
  8020a0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020a5:	eb f7                	jmp    80209e <getchar+0x20>

008020a7 <iscons>:
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b0:	50                   	push   %eax
  8020b1:	ff 75 08             	push   0x8(%ebp)
  8020b4:	e8 04 f4 ff ff       	call   8014bd <fd_lookup>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 11                	js     8020d1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c9:	39 10                	cmp    %edx,(%eax)
  8020cb:	0f 94 c0             	sete   %al
  8020ce:	0f b6 c0             	movzbl %al,%eax
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <opencons>:
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 8b f3 ff ff       	call   80146d <fd_alloc>
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 3a                	js     802123 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 07 04 00 00       	push   $0x407
  8020f1:	ff 75 f4             	push   -0xc(%ebp)
  8020f4:	6a 00                	push   $0x0
  8020f6:	e8 74 eb ff ff       	call   800c6f <sys_page_alloc>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 21                	js     802123 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80210b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	50                   	push   %eax
  80211b:	e8 26 f3 ff ff       	call   801446 <fd2num>
  802120:	83 c4 10             	add    $0x10,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	56                   	push   %esi
  802129:	53                   	push   %ebx
  80212a:	8b 75 08             	mov    0x8(%ebp),%esi
  80212d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	ff 75 0c             	push   0xc(%ebp)
  802136:	e8 e4 ec ff ff       	call   800e1f <sys_ipc_recv>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 2b                	js     80216d <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802142:	85 f6                	test   %esi,%esi
  802144:	74 0a                	je     802150 <ipc_recv+0x2b>
  802146:	a1 00 40 80 00       	mov    0x804000,%eax
  80214b:	8b 40 74             	mov    0x74(%eax),%eax
  80214e:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802150:	85 db                	test   %ebx,%ebx
  802152:	74 0a                	je     80215e <ipc_recv+0x39>
  802154:	a1 00 40 80 00       	mov    0x804000,%eax
  802159:	8b 40 78             	mov    0x78(%eax),%eax
  80215c:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80215e:	a1 00 40 80 00       	mov    0x804000,%eax
  802163:	8b 40 70             	mov    0x70(%eax),%eax
}
  802166:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802169:	5b                   	pop    %ebx
  80216a:	5e                   	pop    %esi
  80216b:	5d                   	pop    %ebp
  80216c:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80216d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802172:	eb f2                	jmp    802166 <ipc_recv+0x41>

00802174 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	57                   	push   %edi
  802178:	56                   	push   %esi
  802179:	53                   	push   %ebx
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802180:	8b 75 0c             	mov    0xc(%ebp),%esi
  802183:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802186:	ff 75 14             	push   0x14(%ebp)
  802189:	53                   	push   %ebx
  80218a:	56                   	push   %esi
  80218b:	57                   	push   %edi
  80218c:	e8 6b ec ff ff       	call   800dfc <sys_ipc_try_send>
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	85 c0                	test   %eax,%eax
  802196:	79 20                	jns    8021b8 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802198:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80219b:	75 07                	jne    8021a4 <ipc_send+0x30>
		sys_yield();
  80219d:	e8 ae ea ff ff       	call   800c50 <sys_yield>
  8021a2:	eb e2                	jmp    802186 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	68 b1 29 80 00       	push   $0x8029b1
  8021ac:	6a 2e                	push   $0x2e
  8021ae:	68 c1 29 80 00       	push   $0x8029c1
  8021b3:	e8 1b df ff ff       	call   8000d3 <_panic>
	}
}
  8021b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    

008021c0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021cb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ce:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021d4:	8b 52 50             	mov    0x50(%edx),%edx
  8021d7:	39 ca                	cmp    %ecx,%edx
  8021d9:	74 11                	je     8021ec <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021db:	83 c0 01             	add    $0x1,%eax
  8021de:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021e3:	75 e6                	jne    8021cb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	eb 0b                	jmp    8021f7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8021ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021f4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    

008021f9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	c1 ea 16             	shr    $0x16,%edx
  802204:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80220b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802210:	f6 c1 01             	test   $0x1,%cl
  802213:	74 1c                	je     802231 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802215:	c1 e8 0c             	shr    $0xc,%eax
  802218:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80221f:	a8 01                	test   $0x1,%al
  802221:	74 0e                	je     802231 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802223:	c1 e8 0c             	shr    $0xc,%eax
  802226:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80222d:	ef 
  80222e:	0f b7 d2             	movzwl %dx,%edx
}
  802231:	89 d0                	mov    %edx,%eax
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	66 90                	xchg   %ax,%ax
  802237:	66 90                	xchg   %ax,%ax
  802239:	66 90                	xchg   %ax,%ax
  80223b:	66 90                	xchg   %ax,%ax
  80223d:	66 90                	xchg   %ax,%ax
  80223f:	90                   	nop

00802240 <__udivdi3>:
  802240:	f3 0f 1e fb          	endbr32 
  802244:	55                   	push   %ebp
  802245:	57                   	push   %edi
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	83 ec 1c             	sub    $0x1c,%esp
  80224b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80224f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802253:	8b 74 24 34          	mov    0x34(%esp),%esi
  802257:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80225b:	85 c0                	test   %eax,%eax
  80225d:	75 19                	jne    802278 <__udivdi3+0x38>
  80225f:	39 f3                	cmp    %esi,%ebx
  802261:	76 4d                	jbe    8022b0 <__udivdi3+0x70>
  802263:	31 ff                	xor    %edi,%edi
  802265:	89 e8                	mov    %ebp,%eax
  802267:	89 f2                	mov    %esi,%edx
  802269:	f7 f3                	div    %ebx
  80226b:	89 fa                	mov    %edi,%edx
  80226d:	83 c4 1c             	add    $0x1c,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	39 f0                	cmp    %esi,%eax
  80227a:	76 14                	jbe    802290 <__udivdi3+0x50>
  80227c:	31 ff                	xor    %edi,%edi
  80227e:	31 c0                	xor    %eax,%eax
  802280:	89 fa                	mov    %edi,%edx
  802282:	83 c4 1c             	add    $0x1c,%esp
  802285:	5b                   	pop    %ebx
  802286:	5e                   	pop    %esi
  802287:	5f                   	pop    %edi
  802288:	5d                   	pop    %ebp
  802289:	c3                   	ret    
  80228a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802290:	0f bd f8             	bsr    %eax,%edi
  802293:	83 f7 1f             	xor    $0x1f,%edi
  802296:	75 48                	jne    8022e0 <__udivdi3+0xa0>
  802298:	39 f0                	cmp    %esi,%eax
  80229a:	72 06                	jb     8022a2 <__udivdi3+0x62>
  80229c:	31 c0                	xor    %eax,%eax
  80229e:	39 eb                	cmp    %ebp,%ebx
  8022a0:	77 de                	ja     802280 <__udivdi3+0x40>
  8022a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a7:	eb d7                	jmp    802280 <__udivdi3+0x40>
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 d9                	mov    %ebx,%ecx
  8022b2:	85 db                	test   %ebx,%ebx
  8022b4:	75 0b                	jne    8022c1 <__udivdi3+0x81>
  8022b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	f7 f3                	div    %ebx
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	31 d2                	xor    %edx,%edx
  8022c3:	89 f0                	mov    %esi,%eax
  8022c5:	f7 f1                	div    %ecx
  8022c7:	89 c6                	mov    %eax,%esi
  8022c9:	89 e8                	mov    %ebp,%eax
  8022cb:	89 f7                	mov    %esi,%edi
  8022cd:	f7 f1                	div    %ecx
  8022cf:	89 fa                	mov    %edi,%edx
  8022d1:	83 c4 1c             	add    $0x1c,%esp
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5f                   	pop    %edi
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    
  8022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e0:	89 f9                	mov    %edi,%ecx
  8022e2:	ba 20 00 00 00       	mov    $0x20,%edx
  8022e7:	29 fa                	sub    %edi,%edx
  8022e9:	d3 e0                	shl    %cl,%eax
  8022eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ef:	89 d1                	mov    %edx,%ecx
  8022f1:	89 d8                	mov    %ebx,%eax
  8022f3:	d3 e8                	shr    %cl,%eax
  8022f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022f9:	09 c1                	or     %eax,%ecx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802301:	89 f9                	mov    %edi,%ecx
  802303:	d3 e3                	shl    %cl,%ebx
  802305:	89 d1                	mov    %edx,%ecx
  802307:	d3 e8                	shr    %cl,%eax
  802309:	89 f9                	mov    %edi,%ecx
  80230b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80230f:	89 eb                	mov    %ebp,%ebx
  802311:	d3 e6                	shl    %cl,%esi
  802313:	89 d1                	mov    %edx,%ecx
  802315:	d3 eb                	shr    %cl,%ebx
  802317:	09 f3                	or     %esi,%ebx
  802319:	89 c6                	mov    %eax,%esi
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	89 d8                	mov    %ebx,%eax
  80231f:	f7 74 24 08          	divl   0x8(%esp)
  802323:	89 d6                	mov    %edx,%esi
  802325:	89 c3                	mov    %eax,%ebx
  802327:	f7 64 24 0c          	mull   0xc(%esp)
  80232b:	39 d6                	cmp    %edx,%esi
  80232d:	72 19                	jb     802348 <__udivdi3+0x108>
  80232f:	89 f9                	mov    %edi,%ecx
  802331:	d3 e5                	shl    %cl,%ebp
  802333:	39 c5                	cmp    %eax,%ebp
  802335:	73 04                	jae    80233b <__udivdi3+0xfb>
  802337:	39 d6                	cmp    %edx,%esi
  802339:	74 0d                	je     802348 <__udivdi3+0x108>
  80233b:	89 d8                	mov    %ebx,%eax
  80233d:	31 ff                	xor    %edi,%edi
  80233f:	e9 3c ff ff ff       	jmp    802280 <__udivdi3+0x40>
  802344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802348:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80234b:	31 ff                	xor    %edi,%edi
  80234d:	e9 2e ff ff ff       	jmp    802280 <__udivdi3+0x40>
  802352:	66 90                	xchg   %ax,%ax
  802354:	66 90                	xchg   %ax,%ax
  802356:	66 90                	xchg   %ax,%ax
  802358:	66 90                	xchg   %ax,%ax
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	66 90                	xchg   %ax,%ax
  80235e:	66 90                	xchg   %ax,%ax

00802360 <__umoddi3>:
  802360:	f3 0f 1e fb          	endbr32 
  802364:	55                   	push   %ebp
  802365:	57                   	push   %edi
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 1c             	sub    $0x1c,%esp
  80236b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80236f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802373:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802377:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	89 da                	mov    %ebx,%edx
  80237f:	85 ff                	test   %edi,%edi
  802381:	75 15                	jne    802398 <__umoddi3+0x38>
  802383:	39 dd                	cmp    %ebx,%ebp
  802385:	76 39                	jbe    8023c0 <__umoddi3+0x60>
  802387:	f7 f5                	div    %ebp
  802389:	89 d0                	mov    %edx,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	83 c4 1c             	add    $0x1c,%esp
  802390:	5b                   	pop    %ebx
  802391:	5e                   	pop    %esi
  802392:	5f                   	pop    %edi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	39 df                	cmp    %ebx,%edi
  80239a:	77 f1                	ja     80238d <__umoddi3+0x2d>
  80239c:	0f bd cf             	bsr    %edi,%ecx
  80239f:	83 f1 1f             	xor    $0x1f,%ecx
  8023a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023a6:	75 40                	jne    8023e8 <__umoddi3+0x88>
  8023a8:	39 df                	cmp    %ebx,%edi
  8023aa:	72 04                	jb     8023b0 <__umoddi3+0x50>
  8023ac:	39 f5                	cmp    %esi,%ebp
  8023ae:	77 dd                	ja     80238d <__umoddi3+0x2d>
  8023b0:	89 da                	mov    %ebx,%edx
  8023b2:	89 f0                	mov    %esi,%eax
  8023b4:	29 e8                	sub    %ebp,%eax
  8023b6:	19 fa                	sbb    %edi,%edx
  8023b8:	eb d3                	jmp    80238d <__umoddi3+0x2d>
  8023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023c0:	89 e9                	mov    %ebp,%ecx
  8023c2:	85 ed                	test   %ebp,%ebp
  8023c4:	75 0b                	jne    8023d1 <__umoddi3+0x71>
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f5                	div    %ebp
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 d8                	mov    %ebx,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f1                	div    %ecx
  8023d7:	89 f0                	mov    %esi,%eax
  8023d9:	f7 f1                	div    %ecx
  8023db:	89 d0                	mov    %edx,%eax
  8023dd:	31 d2                	xor    %edx,%edx
  8023df:	eb ac                	jmp    80238d <__umoddi3+0x2d>
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ec:	ba 20 00 00 00       	mov    $0x20,%edx
  8023f1:	29 c2                	sub    %eax,%edx
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	89 e8                	mov    %ebp,%eax
  8023f7:	d3 e7                	shl    %cl,%edi
  8023f9:	89 d1                	mov    %edx,%ecx
  8023fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023ff:	d3 e8                	shr    %cl,%eax
  802401:	89 c1                	mov    %eax,%ecx
  802403:	8b 44 24 04          	mov    0x4(%esp),%eax
  802407:	09 f9                	or     %edi,%ecx
  802409:	89 df                	mov    %ebx,%edi
  80240b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	d3 e5                	shl    %cl,%ebp
  802413:	89 d1                	mov    %edx,%ecx
  802415:	d3 ef                	shr    %cl,%edi
  802417:	89 c1                	mov    %eax,%ecx
  802419:	89 f0                	mov    %esi,%eax
  80241b:	d3 e3                	shl    %cl,%ebx
  80241d:	89 d1                	mov    %edx,%ecx
  80241f:	89 fa                	mov    %edi,%edx
  802421:	d3 e8                	shr    %cl,%eax
  802423:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802428:	09 d8                	or     %ebx,%eax
  80242a:	f7 74 24 08          	divl   0x8(%esp)
  80242e:	89 d3                	mov    %edx,%ebx
  802430:	d3 e6                	shl    %cl,%esi
  802432:	f7 e5                	mul    %ebp
  802434:	89 c7                	mov    %eax,%edi
  802436:	89 d1                	mov    %edx,%ecx
  802438:	39 d3                	cmp    %edx,%ebx
  80243a:	72 06                	jb     802442 <__umoddi3+0xe2>
  80243c:	75 0e                	jne    80244c <__umoddi3+0xec>
  80243e:	39 c6                	cmp    %eax,%esi
  802440:	73 0a                	jae    80244c <__umoddi3+0xec>
  802442:	29 e8                	sub    %ebp,%eax
  802444:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802448:	89 d1                	mov    %edx,%ecx
  80244a:	89 c7                	mov    %eax,%edi
  80244c:	89 f5                	mov    %esi,%ebp
  80244e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802452:	29 fd                	sub    %edi,%ebp
  802454:	19 cb                	sbb    %ecx,%ebx
  802456:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80245b:	89 d8                	mov    %ebx,%eax
  80245d:	d3 e0                	shl    %cl,%eax
  80245f:	89 f1                	mov    %esi,%ecx
  802461:	d3 ed                	shr    %cl,%ebp
  802463:	d3 eb                	shr    %cl,%ebx
  802465:	09 e8                	or     %ebp,%eax
  802467:	89 da                	mov    %ebx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
