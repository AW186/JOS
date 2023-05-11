
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 d1 0b 00 00       	call   800c11 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 20 80 00 7c 	cmpl   $0xeec0007c,0x802004
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 b1 11 80 00       	push   $0x8011b1
  80005d:	e8 2c 01 00 00       	call   80018e <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 19 0e 00 00       	call   800e8f <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 b5 0d 00 00       	call   800e40 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	push   -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 a0 11 80 00       	push   $0x8011a0
  800097:	e8 f2 00 00 00       	call   80018e <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 60 0b 00 00       	call   800c11 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	e8 dc 0a 00 00       	call   800bd0 <sys_env_destroy>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	c9                   	leave  
  8000f8:	c3                   	ret    

008000f9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f9:	55                   	push   %ebp
  8000fa:	89 e5                	mov    %esp,%ebp
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800103:	8b 13                	mov    (%ebx),%edx
  800105:	8d 42 01             	lea    0x1(%edx),%eax
  800108:	89 03                	mov    %eax,(%ebx)
  80010a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800111:	3d ff 00 00 00       	cmp    $0xff,%eax
  800116:	74 09                	je     800121 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800118:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011f:	c9                   	leave  
  800120:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	68 ff 00 00 00       	push   $0xff
  800129:	8d 43 08             	lea    0x8(%ebx),%eax
  80012c:	50                   	push   %eax
  80012d:	e8 61 0a 00 00       	call   800b93 <sys_cputs>
		b->idx = 0;
  800132:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	eb db                	jmp    800118 <putch+0x1f>

0080013d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800146:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014d:	00 00 00 
	b.cnt = 0;
  800150:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800157:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015a:	ff 75 0c             	push   0xc(%ebp)
  80015d:	ff 75 08             	push   0x8(%ebp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	68 f9 00 80 00       	push   $0x8000f9
  80016c:	e8 14 01 00 00       	call   800285 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80017a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800180:	50                   	push   %eax
  800181:	e8 0d 0a 00 00       	call   800b93 <sys_cputs>

	return b.cnt;
}
  800186:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800194:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800197:	50                   	push   %eax
  800198:	ff 75 08             	push   0x8(%ebp)
  80019b:	e8 9d ff ff ff       	call   80013d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	57                   	push   %edi
  8001a6:	56                   	push   %esi
  8001a7:	53                   	push   %ebx
  8001a8:	83 ec 1c             	sub    $0x1c,%esp
  8001ab:	89 c7                	mov    %eax,%edi
  8001ad:	89 d6                	mov    %edx,%esi
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b5:	89 d1                	mov    %edx,%ecx
  8001b7:	89 c2                	mov    %eax,%edx
  8001b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001cf:	39 c2                	cmp    %eax,%edx
  8001d1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001d4:	72 3e                	jb     800214 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 18             	push   0x18(%ebp)
  8001dc:	83 eb 01             	sub    $0x1,%ebx
  8001df:	53                   	push   %ebx
  8001e0:	50                   	push   %eax
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 e4             	push   -0x1c(%ebp)
  8001e7:	ff 75 e0             	push   -0x20(%ebp)
  8001ea:	ff 75 dc             	push   -0x24(%ebp)
  8001ed:	ff 75 d8             	push   -0x28(%ebp)
  8001f0:	e8 6b 0d 00 00       	call   800f60 <__udivdi3>
  8001f5:	83 c4 18             	add    $0x18,%esp
  8001f8:	52                   	push   %edx
  8001f9:	50                   	push   %eax
  8001fa:	89 f2                	mov    %esi,%edx
  8001fc:	89 f8                	mov    %edi,%eax
  8001fe:	e8 9f ff ff ff       	call   8001a2 <printnum>
  800203:	83 c4 20             	add    $0x20,%esp
  800206:	eb 13                	jmp    80021b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	56                   	push   %esi
  80020c:	ff 75 18             	push   0x18(%ebp)
  80020f:	ff d7                	call   *%edi
  800211:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800214:	83 eb 01             	sub    $0x1,%ebx
  800217:	85 db                	test   %ebx,%ebx
  800219:	7f ed                	jg     800208 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 e4             	push   -0x1c(%ebp)
  800225:	ff 75 e0             	push   -0x20(%ebp)
  800228:	ff 75 dc             	push   -0x24(%ebp)
  80022b:	ff 75 d8             	push   -0x28(%ebp)
  80022e:	e8 4d 0e 00 00       	call   801080 <__umoddi3>
  800233:	83 c4 14             	add    $0x14,%esp
  800236:	0f be 80 d2 11 80 00 	movsbl 0x8011d2(%eax),%eax
  80023d:	50                   	push   %eax
  80023e:	ff d7                	call   *%edi
}
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5f                   	pop    %edi
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800251:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800255:	8b 10                	mov    (%eax),%edx
  800257:	3b 50 04             	cmp    0x4(%eax),%edx
  80025a:	73 0a                	jae    800266 <sprintputch+0x1b>
		*b->buf++ = ch;
  80025c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80025f:	89 08                	mov    %ecx,(%eax)
  800261:	8b 45 08             	mov    0x8(%ebp),%eax
  800264:	88 02                	mov    %al,(%edx)
}
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    

00800268 <printfmt>:
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80026e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800271:	50                   	push   %eax
  800272:	ff 75 10             	push   0x10(%ebp)
  800275:	ff 75 0c             	push   0xc(%ebp)
  800278:	ff 75 08             	push   0x8(%ebp)
  80027b:	e8 05 00 00 00       	call   800285 <vprintfmt>
}
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <vprintfmt>:
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	57                   	push   %edi
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	83 ec 3c             	sub    $0x3c,%esp
  80028e:	8b 75 08             	mov    0x8(%ebp),%esi
  800291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800294:	8b 7d 10             	mov    0x10(%ebp),%edi
  800297:	eb 0a                	jmp    8002a3 <vprintfmt+0x1e>
			putch(ch, putdat);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	53                   	push   %ebx
  80029d:	50                   	push   %eax
  80029e:	ff d6                	call   *%esi
  8002a0:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002a3:	83 c7 01             	add    $0x1,%edi
  8002a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002aa:	83 f8 25             	cmp    $0x25,%eax
  8002ad:	74 0c                	je     8002bb <vprintfmt+0x36>
			if (ch == '\0')
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	75 e6                	jne    800299 <vprintfmt+0x14>
}
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    
		padc = ' ';
  8002bb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002bf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002cd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002d4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d9:	8d 47 01             	lea    0x1(%edi),%eax
  8002dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002df:	0f b6 17             	movzbl (%edi),%edx
  8002e2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e5:	3c 55                	cmp    $0x55,%al
  8002e7:	0f 87 a6 04 00 00    	ja     800793 <vprintfmt+0x50e>
  8002ed:	0f b6 c0             	movzbl %al,%eax
  8002f0:	ff 24 85 20 13 80 00 	jmp    *0x801320(,%eax,4)
  8002f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8002fa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002fe:	eb d9                	jmp    8002d9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800300:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800303:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800307:	eb d0                	jmp    8002d9 <vprintfmt+0x54>
  800309:	0f b6 d2             	movzbl %dl,%edx
  80030c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80030f:	b8 00 00 00 00       	mov    $0x0,%eax
  800314:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800317:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80031e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	83 f9 09             	cmp    $0x9,%ecx
  800327:	77 55                	ja     80037e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800329:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032c:	eb e9                	jmp    800317 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80032e:	8b 45 14             	mov    0x14(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800336:	8b 45 14             	mov    0x14(%ebp),%eax
  800339:	8d 40 04             	lea    0x4(%eax),%eax
  80033c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800342:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800346:	79 91                	jns    8002d9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800355:	eb 82                	jmp    8002d9 <vprintfmt+0x54>
  800357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80035a:	85 d2                	test   %edx,%edx
  80035c:	b8 00 00 00 00       	mov    $0x0,%eax
  800361:	0f 49 c2             	cmovns %edx,%eax
  800364:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80036a:	e9 6a ff ff ff       	jmp    8002d9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800372:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800379:	e9 5b ff ff ff       	jmp    8002d9 <vprintfmt+0x54>
  80037e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800384:	eb bc                	jmp    800342 <vprintfmt+0xbd>
			lflag++;
  800386:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80038c:	e9 48 ff ff ff       	jmp    8002d9 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8d 78 04             	lea    0x4(%eax),%edi
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	53                   	push   %ebx
  80039b:	ff 30                	push   (%eax)
  80039d:	ff d6                	call   *%esi
			break;
  80039f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a5:	e9 88 03 00 00       	jmp    800732 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8d 78 04             	lea    0x4(%eax),%edi
  8003b0:	8b 10                	mov    (%eax),%edx
  8003b2:	89 d0                	mov    %edx,%eax
  8003b4:	f7 d8                	neg    %eax
  8003b6:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b9:	83 f8 0f             	cmp    $0xf,%eax
  8003bc:	7f 23                	jg     8003e1 <vprintfmt+0x15c>
  8003be:	8b 14 85 80 14 80 00 	mov    0x801480(,%eax,4),%edx
  8003c5:	85 d2                	test   %edx,%edx
  8003c7:	74 18                	je     8003e1 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003c9:	52                   	push   %edx
  8003ca:	68 f3 11 80 00       	push   $0x8011f3
  8003cf:	53                   	push   %ebx
  8003d0:	56                   	push   %esi
  8003d1:	e8 92 fe ff ff       	call   800268 <printfmt>
  8003d6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dc:	e9 51 03 00 00       	jmp    800732 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8003e1:	50                   	push   %eax
  8003e2:	68 ea 11 80 00       	push   $0x8011ea
  8003e7:	53                   	push   %ebx
  8003e8:	56                   	push   %esi
  8003e9:	e8 7a fe ff ff       	call   800268 <printfmt>
  8003ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f4:	e9 39 03 00 00       	jmp    800732 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	83 c0 04             	add    $0x4,%eax
  8003ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800407:	85 d2                	test   %edx,%edx
  800409:	b8 e3 11 80 00       	mov    $0x8011e3,%eax
  80040e:	0f 45 c2             	cmovne %edx,%eax
  800411:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800414:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800418:	7e 06                	jle    800420 <vprintfmt+0x19b>
  80041a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80041e:	75 0d                	jne    80042d <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800420:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800423:	89 c7                	mov    %eax,%edi
  800425:	03 45 d4             	add    -0x2c(%ebp),%eax
  800428:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80042b:	eb 55                	jmp    800482 <vprintfmt+0x1fd>
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	ff 75 e0             	push   -0x20(%ebp)
  800433:	ff 75 cc             	push   -0x34(%ebp)
  800436:	e8 f5 03 00 00       	call   800830 <strnlen>
  80043b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80043e:	29 c2                	sub    %eax,%edx
  800440:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800448:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80044c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80044f:	eb 0f                	jmp    800460 <vprintfmt+0x1db>
					putch(padc, putdat);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	53                   	push   %ebx
  800455:	ff 75 d4             	push   -0x2c(%ebp)
  800458:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045a:	83 ef 01             	sub    $0x1,%edi
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	85 ff                	test   %edi,%edi
  800462:	7f ed                	jg     800451 <vprintfmt+0x1cc>
  800464:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800467:	85 d2                	test   %edx,%edx
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	0f 49 c2             	cmovns %edx,%eax
  800471:	29 c2                	sub    %eax,%edx
  800473:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800476:	eb a8                	jmp    800420 <vprintfmt+0x19b>
					putch(ch, putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	53                   	push   %ebx
  80047c:	52                   	push   %edx
  80047d:	ff d6                	call   *%esi
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800485:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800487:	83 c7 01             	add    $0x1,%edi
  80048a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80048e:	0f be d0             	movsbl %al,%edx
  800491:	85 d2                	test   %edx,%edx
  800493:	74 4b                	je     8004e0 <vprintfmt+0x25b>
  800495:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800499:	78 06                	js     8004a1 <vprintfmt+0x21c>
  80049b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80049f:	78 1e                	js     8004bf <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a5:	74 d1                	je     800478 <vprintfmt+0x1f3>
  8004a7:	0f be c0             	movsbl %al,%eax
  8004aa:	83 e8 20             	sub    $0x20,%eax
  8004ad:	83 f8 5e             	cmp    $0x5e,%eax
  8004b0:	76 c6                	jbe    800478 <vprintfmt+0x1f3>
					putch('?', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 3f                	push   $0x3f
  8004b8:	ff d6                	call   *%esi
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	eb c3                	jmp    800482 <vprintfmt+0x1fd>
  8004bf:	89 cf                	mov    %ecx,%edi
  8004c1:	eb 0e                	jmp    8004d1 <vprintfmt+0x24c>
				putch(' ', putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	53                   	push   %ebx
  8004c7:	6a 20                	push   $0x20
  8004c9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cb:	83 ef 01             	sub    $0x1,%edi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	85 ff                	test   %edi,%edi
  8004d3:	7f ee                	jg     8004c3 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004db:	e9 52 02 00 00       	jmp    800732 <vprintfmt+0x4ad>
  8004e0:	89 cf                	mov    %ecx,%edi
  8004e2:	eb ed                	jmp    8004d1 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	83 c0 04             	add    $0x4,%eax
  8004ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004f2:	85 d2                	test   %edx,%edx
  8004f4:	b8 e3 11 80 00       	mov    $0x8011e3,%eax
  8004f9:	0f 45 c2             	cmovne %edx,%eax
  8004fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800503:	7e 06                	jle    80050b <vprintfmt+0x286>
  800505:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800509:	75 0d                	jne    800518 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050e:	89 c7                	mov    %eax,%edi
  800510:	03 45 d4             	add    -0x2c(%ebp),%eax
  800513:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800516:	eb 55                	jmp    80056d <vprintfmt+0x2e8>
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 e0             	push   -0x20(%ebp)
  80051e:	ff 75 cc             	push   -0x34(%ebp)
  800521:	e8 0a 03 00 00       	call   800830 <strnlen>
  800526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800529:	29 c2                	sub    %eax,%edx
  80052b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800533:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800537:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80053a:	eb 0f                	jmp    80054b <vprintfmt+0x2c6>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 75 d4             	push   -0x2c(%ebp)
  800543:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	85 ff                	test   %edi,%edi
  80054d:	7f ed                	jg     80053c <vprintfmt+0x2b7>
  80054f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	b8 00 00 00 00       	mov    $0x0,%eax
  800559:	0f 49 c2             	cmovns %edx,%eax
  80055c:	29 c2                	sub    %eax,%edx
  80055e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800561:	eb a8                	jmp    80050b <vprintfmt+0x286>
					putch(ch, putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	52                   	push   %edx
  800568:	ff d6                	call   *%esi
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800570:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800572:	83 c7 01             	add    $0x1,%edi
  800575:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800579:	0f be d0             	movsbl %al,%edx
  80057c:	3c 3a                	cmp    $0x3a,%al
  80057e:	74 4b                	je     8005cb <vprintfmt+0x346>
  800580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800584:	78 06                	js     80058c <vprintfmt+0x307>
  800586:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80058a:	78 1e                	js     8005aa <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80058c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800590:	74 d1                	je     800563 <vprintfmt+0x2de>
  800592:	0f be c0             	movsbl %al,%eax
  800595:	83 e8 20             	sub    $0x20,%eax
  800598:	83 f8 5e             	cmp    $0x5e,%eax
  80059b:	76 c6                	jbe    800563 <vprintfmt+0x2de>
					putch('?', putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 3f                	push   $0x3f
  8005a3:	ff d6                	call   *%esi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	eb c3                	jmp    80056d <vprintfmt+0x2e8>
  8005aa:	89 cf                	mov    %ecx,%edi
  8005ac:	eb 0e                	jmp    8005bc <vprintfmt+0x337>
				putch(' ', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 20                	push   $0x20
  8005b4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	85 ff                	test   %edi,%edi
  8005be:	7f ee                	jg     8005ae <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c6:	e9 67 01 00 00       	jmp    800732 <vprintfmt+0x4ad>
  8005cb:	89 cf                	mov    %ecx,%edi
  8005cd:	eb ed                	jmp    8005bc <vprintfmt+0x337>
	if (lflag >= 2)
  8005cf:	83 f9 01             	cmp    $0x1,%ecx
  8005d2:	7f 1b                	jg     8005ef <vprintfmt+0x36a>
	else if (lflag)
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	74 63                	je     80063b <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e0:	99                   	cltd   
  8005e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ed:	eb 17                	jmp    800606 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 50 04             	mov    0x4(%eax),%edx
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800606:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800609:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80060c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800611:	85 c9                	test   %ecx,%ecx
  800613:	0f 89 ff 00 00 00    	jns    800718 <vprintfmt+0x493>
				putch('-', putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 2d                	push   $0x2d
  80061f:	ff d6                	call   *%esi
				num = -(long long) num;
  800621:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800624:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800627:	f7 da                	neg    %edx
  800629:	83 d1 00             	adc    $0x0,%ecx
  80062c:	f7 d9                	neg    %ecx
  80062e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800631:	bf 0a 00 00 00       	mov    $0xa,%edi
  800636:	e9 dd 00 00 00       	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	99                   	cltd   
  800644:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	eb b4                	jmp    800606 <vprintfmt+0x381>
	if (lflag >= 2)
  800652:	83 f9 01             	cmp    $0x1,%ecx
  800655:	7f 1e                	jg     800675 <vprintfmt+0x3f0>
	else if (lflag)
  800657:	85 c9                	test   %ecx,%ecx
  800659:	74 32                	je     80068d <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 10                	mov    (%eax),%edx
  800660:	b9 00 00 00 00       	mov    $0x0,%ecx
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800670:	e9 a3 00 00 00       	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 10                	mov    (%eax),%edx
  80067a:	8b 48 04             	mov    0x4(%eax),%ecx
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800683:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800688:	e9 8b 00 00 00       	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 10                	mov    (%eax),%edx
  800692:	b9 00 00 00 00       	mov    $0x0,%ecx
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006a2:	eb 74                	jmp    800718 <vprintfmt+0x493>
	if (lflag >= 2)
  8006a4:	83 f9 01             	cmp    $0x1,%ecx
  8006a7:	7f 1b                	jg     8006c4 <vprintfmt+0x43f>
	else if (lflag)
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	74 2c                	je     8006d9 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bd:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006c2:	eb 54                	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006cc:	8d 40 08             	lea    0x8(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d2:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006d7:	eb 3f                	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 10                	mov    (%eax),%edx
  8006de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e9:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8006ee:	eb 28                	jmp    800718 <vprintfmt+0x493>
			putch('0', putdat);
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	53                   	push   %ebx
  8006f4:	6a 30                	push   $0x30
  8006f6:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f8:	83 c4 08             	add    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 78                	push   $0x78
  8006fe:	ff d6                	call   *%esi
			num = (unsigned long long)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 10                	mov    (%eax),%edx
  800705:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80070a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800713:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	ff 75 d4             	push   -0x2c(%ebp)
  800723:	57                   	push   %edi
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	89 da                	mov    %ebx,%edx
  800728:	89 f0                	mov    %esi,%eax
  80072a:	e8 73 fa ff ff       	call   8001a2 <printnum>
			break;
  80072f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800732:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	e9 69 fb ff ff       	jmp    8002a3 <vprintfmt+0x1e>
	if (lflag >= 2)
  80073a:	83 f9 01             	cmp    $0x1,%ecx
  80073d:	7f 1b                	jg     80075a <vprintfmt+0x4d5>
	else if (lflag)
  80073f:	85 c9                	test   %ecx,%ecx
  800741:	74 2c                	je     80076f <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 10                	mov    (%eax),%edx
  800748:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800753:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800758:	eb be                	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 48 04             	mov    0x4(%eax),%ecx
  800762:	8d 40 08             	lea    0x8(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800768:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80076d:	eb a9                	jmp    800718 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 10                	mov    (%eax),%edx
  800774:	b9 00 00 00 00       	mov    $0x0,%ecx
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800784:	eb 92                	jmp    800718 <vprintfmt+0x493>
			putch(ch, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 25                	push   $0x25
  80078c:	ff d6                	call   *%esi
			break;
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	eb 9f                	jmp    800732 <vprintfmt+0x4ad>
			putch('%', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 25                	push   $0x25
  800799:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 f8                	mov    %edi,%eax
  8007a0:	eb 03                	jmp    8007a5 <vprintfmt+0x520>
  8007a2:	83 e8 01             	sub    $0x1,%eax
  8007a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a9:	75 f7                	jne    8007a2 <vprintfmt+0x51d>
  8007ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007ae:	eb 82                	jmp    800732 <vprintfmt+0x4ad>

008007b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cd:	85 c0                	test   %eax,%eax
  8007cf:	74 26                	je     8007f7 <vsnprintf+0x47>
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	7e 22                	jle    8007f7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d5:	ff 75 14             	push   0x14(%ebp)
  8007d8:	ff 75 10             	push   0x10(%ebp)
  8007db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	68 4b 02 80 00       	push   $0x80024b
  8007e4:	e8 9c fa ff ff       	call   800285 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f2:	83 c4 10             	add    $0x10,%esp
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    
		return -E_INVAL;
  8007f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fc:	eb f7                	jmp    8007f5 <vsnprintf+0x45>

008007fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800804:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800807:	50                   	push   %eax
  800808:	ff 75 10             	push   0x10(%ebp)
  80080b:	ff 75 0c             	push   0xc(%ebp)
  80080e:	ff 75 08             	push   0x8(%ebp)
  800811:	e8 9a ff ff ff       	call   8007b0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	eb 03                	jmp    800828 <strlen+0x10>
		n++;
  800825:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800828:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082c:	75 f7                	jne    800825 <strlen+0xd>
	return n;
}
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800836:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	eb 03                	jmp    800843 <strnlen+0x13>
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800843:	39 d0                	cmp    %edx,%eax
  800845:	74 08                	je     80084f <strnlen+0x1f>
  800847:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084b:	75 f3                	jne    800840 <strnlen+0x10>
  80084d:	89 c2                	mov    %eax,%edx
	return n;
}
  80084f:	89 d0                	mov    %edx,%eax
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	53                   	push   %ebx
  800857:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
  800862:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800866:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800869:	83 c0 01             	add    $0x1,%eax
  80086c:	84 d2                	test   %dl,%dl
  80086e:	75 f2                	jne    800862 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800870:	89 c8                	mov    %ecx,%eax
  800872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	83 ec 10             	sub    $0x10,%esp
  80087e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800881:	53                   	push   %ebx
  800882:	e8 91 ff ff ff       	call   800818 <strlen>
  800887:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80088a:	ff 75 0c             	push   0xc(%ebp)
  80088d:	01 d8                	add    %ebx,%eax
  80088f:	50                   	push   %eax
  800890:	e8 be ff ff ff       	call   800853 <strcpy>
	return dst;
}
  800895:	89 d8                	mov    %ebx,%eax
  800897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	56                   	push   %esi
  8008a0:	53                   	push   %ebx
  8008a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a7:	89 f3                	mov    %esi,%ebx
  8008a9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ac:	89 f0                	mov    %esi,%eax
  8008ae:	eb 0f                	jmp    8008bf <strncpy+0x23>
		*dst++ = *src;
  8008b0:	83 c0 01             	add    $0x1,%eax
  8008b3:	0f b6 0a             	movzbl (%edx),%ecx
  8008b6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b9:	80 f9 01             	cmp    $0x1,%cl
  8008bc:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8008bf:	39 d8                	cmp    %ebx,%eax
  8008c1:	75 ed                	jne    8008b0 <strncpy+0x14>
	}
	return ret;
}
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
  8008ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d4:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d9:	85 d2                	test   %edx,%edx
  8008db:	74 21                	je     8008fe <strlcpy+0x35>
  8008dd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008e1:	89 f2                	mov    %esi,%edx
  8008e3:	eb 09                	jmp    8008ee <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e5:	83 c1 01             	add    $0x1,%ecx
  8008e8:	83 c2 01             	add    $0x1,%edx
  8008eb:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008ee:	39 c2                	cmp    %eax,%edx
  8008f0:	74 09                	je     8008fb <strlcpy+0x32>
  8008f2:	0f b6 19             	movzbl (%ecx),%ebx
  8008f5:	84 db                	test   %bl,%bl
  8008f7:	75 ec                	jne    8008e5 <strlcpy+0x1c>
  8008f9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008fb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008fe:	29 f0                	sub    %esi,%eax
}
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090d:	eb 06                	jmp    800915 <strcmp+0x11>
		p++, q++;
  80090f:	83 c1 01             	add    $0x1,%ecx
  800912:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800915:	0f b6 01             	movzbl (%ecx),%eax
  800918:	84 c0                	test   %al,%al
  80091a:	74 04                	je     800920 <strcmp+0x1c>
  80091c:	3a 02                	cmp    (%edx),%al
  80091e:	74 ef                	je     80090f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800920:	0f b6 c0             	movzbl %al,%eax
  800923:	0f b6 12             	movzbl (%edx),%edx
  800926:	29 d0                	sub    %edx,%eax
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	53                   	push   %ebx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	89 c3                	mov    %eax,%ebx
  800936:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800939:	eb 06                	jmp    800941 <strncmp+0x17>
		n--, p++, q++;
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800941:	39 d8                	cmp    %ebx,%eax
  800943:	74 18                	je     80095d <strncmp+0x33>
  800945:	0f b6 08             	movzbl (%eax),%ecx
  800948:	84 c9                	test   %cl,%cl
  80094a:	74 04                	je     800950 <strncmp+0x26>
  80094c:	3a 0a                	cmp    (%edx),%cl
  80094e:	74 eb                	je     80093b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800950:	0f b6 00             	movzbl (%eax),%eax
  800953:	0f b6 12             	movzbl (%edx),%edx
  800956:	29 d0                	sub    %edx,%eax
}
  800958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    
		return 0;
  80095d:	b8 00 00 00 00       	mov    $0x0,%eax
  800962:	eb f4                	jmp    800958 <strncmp+0x2e>

00800964 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096e:	eb 03                	jmp    800973 <strchr+0xf>
  800970:	83 c0 01             	add    $0x1,%eax
  800973:	0f b6 10             	movzbl (%eax),%edx
  800976:	84 d2                	test   %dl,%dl
  800978:	74 06                	je     800980 <strchr+0x1c>
		if (*s == c)
  80097a:	38 ca                	cmp    %cl,%dl
  80097c:	75 f2                	jne    800970 <strchr+0xc>
  80097e:	eb 05                	jmp    800985 <strchr+0x21>
			return (char *) s;
	return 0;
  800980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800991:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	74 09                	je     8009a1 <strfind+0x1a>
  800998:	84 d2                	test   %dl,%dl
  80099a:	74 05                	je     8009a1 <strfind+0x1a>
	for (; *s; s++)
  80099c:	83 c0 01             	add    $0x1,%eax
  80099f:	eb f0                	jmp    800991 <strfind+0xa>
			break;
	return (char *) s;
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	57                   	push   %edi
  8009a7:	56                   	push   %esi
  8009a8:	53                   	push   %ebx
  8009a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009af:	85 c9                	test   %ecx,%ecx
  8009b1:	74 2f                	je     8009e2 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b3:	89 f8                	mov    %edi,%eax
  8009b5:	09 c8                	or     %ecx,%eax
  8009b7:	a8 03                	test   $0x3,%al
  8009b9:	75 21                	jne    8009dc <memset+0x39>
		c &= 0xFF;
  8009bb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bf:	89 d0                	mov    %edx,%eax
  8009c1:	c1 e0 08             	shl    $0x8,%eax
  8009c4:	89 d3                	mov    %edx,%ebx
  8009c6:	c1 e3 18             	shl    $0x18,%ebx
  8009c9:	89 d6                	mov    %edx,%esi
  8009cb:	c1 e6 10             	shl    $0x10,%esi
  8009ce:	09 f3                	or     %esi,%ebx
  8009d0:	09 da                	or     %ebx,%edx
  8009d2:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d7:	fc                   	cld    
  8009d8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009da:	eb 06                	jmp    8009e2 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	fc                   	cld    
  8009e0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e2:	89 f8                	mov    %edi,%eax
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5f                   	pop    %edi
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	57                   	push   %edi
  8009ed:	56                   	push   %esi
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f7:	39 c6                	cmp    %eax,%esi
  8009f9:	73 32                	jae    800a2d <memmove+0x44>
  8009fb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fe:	39 c2                	cmp    %eax,%edx
  800a00:	76 2b                	jbe    800a2d <memmove+0x44>
		s += n;
		d += n;
  800a02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a05:	89 d6                	mov    %edx,%esi
  800a07:	09 fe                	or     %edi,%esi
  800a09:	09 ce                	or     %ecx,%esi
  800a0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a11:	75 0e                	jne    800a21 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a13:	83 ef 04             	sub    $0x4,%edi
  800a16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1c:	fd                   	std    
  800a1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1f:	eb 09                	jmp    800a2a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a21:	83 ef 01             	sub    $0x1,%edi
  800a24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a27:	fd                   	std    
  800a28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2a:	fc                   	cld    
  800a2b:	eb 1a                	jmp    800a47 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2d:	89 f2                	mov    %esi,%edx
  800a2f:	09 c2                	or     %eax,%edx
  800a31:	09 ca                	or     %ecx,%edx
  800a33:	f6 c2 03             	test   $0x3,%dl
  800a36:	75 0a                	jne    800a42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3b:	89 c7                	mov    %eax,%edi
  800a3d:	fc                   	cld    
  800a3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a40:	eb 05                	jmp    800a47 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a42:	89 c7                	mov    %eax,%edi
  800a44:	fc                   	cld    
  800a45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a47:	5e                   	pop    %esi
  800a48:	5f                   	pop    %edi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a51:	ff 75 10             	push   0x10(%ebp)
  800a54:	ff 75 0c             	push   0xc(%ebp)
  800a57:	ff 75 08             	push   0x8(%ebp)
  800a5a:	e8 8a ff ff ff       	call   8009e9 <memmove>
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6c:	89 c6                	mov    %eax,%esi
  800a6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a71:	eb 06                	jmp    800a79 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a79:	39 f0                	cmp    %esi,%eax
  800a7b:	74 14                	je     800a91 <memcmp+0x30>
		if (*s1 != *s2)
  800a7d:	0f b6 08             	movzbl (%eax),%ecx
  800a80:	0f b6 1a             	movzbl (%edx),%ebx
  800a83:	38 d9                	cmp    %bl,%cl
  800a85:	74 ec                	je     800a73 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a87:	0f b6 c1             	movzbl %cl,%eax
  800a8a:	0f b6 db             	movzbl %bl,%ebx
  800a8d:	29 d8                	sub    %ebx,%eax
  800a8f:	eb 05                	jmp    800a96 <memcmp+0x35>
	}

	return 0;
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a96:	5b                   	pop    %ebx
  800a97:	5e                   	pop    %esi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa8:	eb 03                	jmp    800aad <memfind+0x13>
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	73 04                	jae    800ab5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab1:	38 08                	cmp    %cl,(%eax)
  800ab3:	75 f5                	jne    800aaa <memfind+0x10>
			break;
	return (void *) s;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac3:	eb 03                	jmp    800ac8 <strtol+0x11>
		s++;
  800ac5:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ac8:	0f b6 02             	movzbl (%edx),%eax
  800acb:	3c 20                	cmp    $0x20,%al
  800acd:	74 f6                	je     800ac5 <strtol+0xe>
  800acf:	3c 09                	cmp    $0x9,%al
  800ad1:	74 f2                	je     800ac5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad3:	3c 2b                	cmp    $0x2b,%al
  800ad5:	74 2a                	je     800b01 <strtol+0x4a>
	int neg = 0;
  800ad7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800adc:	3c 2d                	cmp    $0x2d,%al
  800ade:	74 2b                	je     800b0b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae6:	75 0f                	jne    800af7 <strtol+0x40>
  800ae8:	80 3a 30             	cmpb   $0x30,(%edx)
  800aeb:	74 28                	je     800b15 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aed:	85 db                	test   %ebx,%ebx
  800aef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af4:	0f 44 d8             	cmove  %eax,%ebx
  800af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aff:	eb 46                	jmp    800b47 <strtol+0x90>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b04:	bf 00 00 00 00       	mov    $0x0,%edi
  800b09:	eb d5                	jmp    800ae0 <strtol+0x29>
		s++, neg = 1;
  800b0b:	83 c2 01             	add    $0x1,%edx
  800b0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b13:	eb cb                	jmp    800ae0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b15:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b19:	74 0e                	je     800b29 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b1b:	85 db                	test   %ebx,%ebx
  800b1d:	75 d8                	jne    800af7 <strtol+0x40>
		s++, base = 8;
  800b1f:	83 c2 01             	add    $0x1,%edx
  800b22:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b27:	eb ce                	jmp    800af7 <strtol+0x40>
		s += 2, base = 16;
  800b29:	83 c2 02             	add    $0x2,%edx
  800b2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b31:	eb c4                	jmp    800af7 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b33:	0f be c0             	movsbl %al,%eax
  800b36:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b39:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b3c:	7d 3a                	jge    800b78 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b45:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b47:	0f b6 02             	movzbl (%edx),%eax
  800b4a:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b4d:	89 f3                	mov    %esi,%ebx
  800b4f:	80 fb 09             	cmp    $0x9,%bl
  800b52:	76 df                	jbe    800b33 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b54:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 19             	cmp    $0x19,%bl
  800b5c:	77 08                	ja     800b66 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b5e:	0f be c0             	movsbl %al,%eax
  800b61:	83 e8 57             	sub    $0x57,%eax
  800b64:	eb d3                	jmp    800b39 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b66:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 19             	cmp    $0x19,%bl
  800b6e:	77 08                	ja     800b78 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b70:	0f be c0             	movsbl %al,%eax
  800b73:	83 e8 37             	sub    $0x37,%eax
  800b76:	eb c1                	jmp    800b39 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7c:	74 05                	je     800b83 <strtol+0xcc>
		*endptr = (char *) s;
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b83:	89 c8                	mov    %ecx,%eax
  800b85:	f7 d8                	neg    %eax
  800b87:	85 ff                	test   %edi,%edi
  800b89:	0f 45 c8             	cmovne %eax,%ecx
}
  800b8c:	89 c8                	mov    %ecx,%eax
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba4:	89 c3                	mov    %eax,%ebx
  800ba6:	89 c7                	mov    %eax,%edi
  800ba8:	89 c6                	mov    %eax,%esi
  800baa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	57                   	push   %edi
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc1:	89 d1                	mov    %edx,%ecx
  800bc3:	89 d3                	mov    %edx,%ebx
  800bc5:	89 d7                	mov    %edx,%edi
  800bc7:	89 d6                	mov    %edx,%esi
  800bc9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bde:	8b 55 08             	mov    0x8(%ebp),%edx
  800be1:	b8 03 00 00 00       	mov    $0x3,%eax
  800be6:	89 cb                	mov    %ecx,%ebx
  800be8:	89 cf                	mov    %ecx,%edi
  800bea:	89 ce                	mov    %ecx,%esi
  800bec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bee:	85 c0                	test   %eax,%eax
  800bf0:	7f 08                	jg     800bfa <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfa:	83 ec 0c             	sub    $0xc,%esp
  800bfd:	50                   	push   %eax
  800bfe:	6a 03                	push   $0x3
  800c00:	68 df 14 80 00       	push   $0x8014df
  800c05:	6a 23                	push   $0x23
  800c07:	68 fc 14 80 00       	push   $0x8014fc
  800c0c:	e8 03 03 00 00       	call   800f14 <_panic>

00800c11 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	57                   	push   %edi
  800c15:	56                   	push   %esi
  800c16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c21:	89 d1                	mov    %edx,%ecx
  800c23:	89 d3                	mov    %edx,%ebx
  800c25:	89 d7                	mov    %edx,%edi
  800c27:	89 d6                	mov    %edx,%esi
  800c29:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <sys_yield>:

void
sys_yield(void)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	57                   	push   %edi
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c36:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c40:	89 d1                	mov    %edx,%ecx
  800c42:	89 d3                	mov    %edx,%ebx
  800c44:	89 d7                	mov    %edx,%edi
  800c46:	89 d6                	mov    %edx,%esi
  800c48:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c58:	be 00 00 00 00       	mov    $0x0,%esi
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c63:	b8 04 00 00 00       	mov    $0x4,%eax
  800c68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6b:	89 f7                	mov    %esi,%edi
  800c6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	7f 08                	jg     800c7b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c7f:	6a 04                	push   $0x4
  800c81:	68 df 14 80 00       	push   $0x8014df
  800c86:	6a 23                	push   $0x23
  800c88:	68 fc 14 80 00       	push   $0x8014fc
  800c8d:	e8 82 02 00 00       	call   800f14 <_panic>

00800c92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cac:	8b 75 18             	mov    0x18(%ebp),%esi
  800caf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7f 08                	jg     800cbd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	83 ec 0c             	sub    $0xc,%esp
  800cc0:	50                   	push   %eax
  800cc1:	6a 05                	push   $0x5
  800cc3:	68 df 14 80 00       	push   $0x8014df
  800cc8:	6a 23                	push   $0x23
  800cca:	68 fc 14 80 00       	push   $0x8014fc
  800ccf:	e8 40 02 00 00       	call   800f14 <_panic>

00800cd4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ced:	89 df                	mov    %ebx,%edi
  800cef:	89 de                	mov    %ebx,%esi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 06                	push   $0x6
  800d05:	68 df 14 80 00       	push   $0x8014df
  800d0a:	6a 23                	push   $0x23
  800d0c:	68 fc 14 80 00       	push   $0x8014fc
  800d11:	e8 fe 01 00 00       	call   800f14 <_panic>

00800d16 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d2f:	89 df                	mov    %ebx,%edi
  800d31:	89 de                	mov    %ebx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 08                	push   $0x8
  800d47:	68 df 14 80 00       	push   $0x8014df
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 fc 14 80 00       	push   $0x8014fc
  800d53:	e8 bc 01 00 00       	call   800f14 <_panic>

00800d58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 09 00 00 00       	mov    $0x9,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 09                	push   $0x9
  800d89:	68 df 14 80 00       	push   $0x8014df
  800d8e:	6a 23                	push   $0x23
  800d90:	68 fc 14 80 00       	push   $0x8014fc
  800d95:	e8 7a 01 00 00       	call   800f14 <_panic>

00800d9a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 0a                	push   $0xa
  800dcb:	68 df 14 80 00       	push   $0x8014df
  800dd0:	6a 23                	push   $0x23
  800dd2:	68 fc 14 80 00       	push   $0x8014fc
  800dd7:	e8 38 01 00 00       	call   800f14 <_panic>

00800ddc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ded:	be 00 00 00 00       	mov    $0x0,%esi
  800df2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e15:	89 cb                	mov    %ecx,%ebx
  800e17:	89 cf                	mov    %ecx,%edi
  800e19:	89 ce                	mov    %ecx,%esi
  800e1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	7f 08                	jg     800e29 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	50                   	push   %eax
  800e2d:	6a 0d                	push   $0xd
  800e2f:	68 df 14 80 00       	push   $0x8014df
  800e34:	6a 23                	push   $0x23
  800e36:	68 fc 14 80 00       	push   $0x8014fc
  800e3b:	e8 d4 00 00 00       	call   800f14 <_panic>

00800e40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	8b 75 08             	mov    0x8(%ebp),%esi
  800e48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	ff 75 0c             	push   0xc(%ebp)
  800e51:	e8 a9 ff ff ff       	call   800dff <sys_ipc_recv>
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	78 2b                	js     800e88 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  800e5d:	85 f6                	test   %esi,%esi
  800e5f:	74 0a                	je     800e6b <ipc_recv+0x2b>
  800e61:	a1 04 20 80 00       	mov    0x802004,%eax
  800e66:	8b 40 74             	mov    0x74(%eax),%eax
  800e69:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  800e6b:	85 db                	test   %ebx,%ebx
  800e6d:	74 0a                	je     800e79 <ipc_recv+0x39>
  800e6f:	a1 04 20 80 00       	mov    0x802004,%eax
  800e74:	8b 40 78             	mov    0x78(%eax),%eax
  800e77:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  800e79:	a1 04 20 80 00       	mov    0x802004,%eax
  800e7e:	8b 40 70             	mov    0x70(%eax),%eax
}
  800e81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  800e88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8d:	eb f2                	jmp    800e81 <ipc_recv+0x41>

00800e8f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  800ea1:	ff 75 14             	push   0x14(%ebp)
  800ea4:	53                   	push   %ebx
  800ea5:	56                   	push   %esi
  800ea6:	57                   	push   %edi
  800ea7:	e8 30 ff ff ff       	call   800ddc <sys_ipc_try_send>
  800eac:	83 c4 10             	add    $0x10,%esp
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	79 20                	jns    800ed3 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  800eb3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800eb6:	75 07                	jne    800ebf <ipc_send+0x30>
		sys_yield();
  800eb8:	e8 73 fd ff ff       	call   800c30 <sys_yield>
  800ebd:	eb e2                	jmp    800ea1 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	68 0a 15 80 00       	push   $0x80150a
  800ec7:	6a 2e                	push   $0x2e
  800ec9:	68 1a 15 80 00       	push   $0x80151a
  800ece:	e8 41 00 00 00       	call   800f14 <_panic>
	}
}
  800ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800ee6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800ee9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800eef:	8b 52 50             	mov    0x50(%edx),%edx
  800ef2:	39 ca                	cmp    %ecx,%edx
  800ef4:	74 11                	je     800f07 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800ef6:	83 c0 01             	add    $0x1,%eax
  800ef9:	3d 00 04 00 00       	cmp    $0x400,%eax
  800efe:	75 e6                	jne    800ee6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	eb 0b                	jmp    800f12 <ipc_find_env+0x37>
			return envs[i].env_id;
  800f07:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f0a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f0f:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f19:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f1c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f22:	e8 ea fc ff ff       	call   800c11 <sys_getenvid>
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	ff 75 0c             	push   0xc(%ebp)
  800f2d:	ff 75 08             	push   0x8(%ebp)
  800f30:	56                   	push   %esi
  800f31:	50                   	push   %eax
  800f32:	68 24 15 80 00       	push   $0x801524
  800f37:	e8 52 f2 ff ff       	call   80018e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f3c:	83 c4 18             	add    $0x18,%esp
  800f3f:	53                   	push   %ebx
  800f40:	ff 75 10             	push   0x10(%ebp)
  800f43:	e8 f5 f1 ff ff       	call   80013d <vcprintf>
	cprintf("\n");
  800f48:	c7 04 24 18 15 80 00 	movl   $0x801518,(%esp)
  800f4f:	e8 3a f2 ff ff       	call   80018e <cprintf>
  800f54:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f57:	cc                   	int3   
  800f58:	eb fd                	jmp    800f57 <_panic+0x43>
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__udivdi3>:
  800f60:	f3 0f 1e fb          	endbr32 
  800f64:	55                   	push   %ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 1c             	sub    $0x1c,%esp
  800f6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f73:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 19                	jne    800f98 <__udivdi3+0x38>
  800f7f:	39 f3                	cmp    %esi,%ebx
  800f81:	76 4d                	jbe    800fd0 <__udivdi3+0x70>
  800f83:	31 ff                	xor    %edi,%edi
  800f85:	89 e8                	mov    %ebp,%eax
  800f87:	89 f2                	mov    %esi,%edx
  800f89:	f7 f3                	div    %ebx
  800f8b:	89 fa                	mov    %edi,%edx
  800f8d:	83 c4 1c             	add    $0x1c,%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	39 f0                	cmp    %esi,%eax
  800f9a:	76 14                	jbe    800fb0 <__udivdi3+0x50>
  800f9c:	31 ff                	xor    %edi,%edi
  800f9e:	31 c0                	xor    %eax,%eax
  800fa0:	89 fa                	mov    %edi,%edx
  800fa2:	83 c4 1c             	add    $0x1c,%esp
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    
  800faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fb0:	0f bd f8             	bsr    %eax,%edi
  800fb3:	83 f7 1f             	xor    $0x1f,%edi
  800fb6:	75 48                	jne    801000 <__udivdi3+0xa0>
  800fb8:	39 f0                	cmp    %esi,%eax
  800fba:	72 06                	jb     800fc2 <__udivdi3+0x62>
  800fbc:	31 c0                	xor    %eax,%eax
  800fbe:	39 eb                	cmp    %ebp,%ebx
  800fc0:	77 de                	ja     800fa0 <__udivdi3+0x40>
  800fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc7:	eb d7                	jmp    800fa0 <__udivdi3+0x40>
  800fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd0:	89 d9                	mov    %ebx,%ecx
  800fd2:	85 db                	test   %ebx,%ebx
  800fd4:	75 0b                	jne    800fe1 <__udivdi3+0x81>
  800fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f3                	div    %ebx
  800fdf:	89 c1                	mov    %eax,%ecx
  800fe1:	31 d2                	xor    %edx,%edx
  800fe3:	89 f0                	mov    %esi,%eax
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 c6                	mov    %eax,%esi
  800fe9:	89 e8                	mov    %ebp,%eax
  800feb:	89 f7                	mov    %esi,%edi
  800fed:	f7 f1                	div    %ecx
  800fef:	89 fa                	mov    %edi,%edx
  800ff1:	83 c4 1c             	add    $0x1c,%esp
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    
  800ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801000:	89 f9                	mov    %edi,%ecx
  801002:	ba 20 00 00 00       	mov    $0x20,%edx
  801007:	29 fa                	sub    %edi,%edx
  801009:	d3 e0                	shl    %cl,%eax
  80100b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80100f:	89 d1                	mov    %edx,%ecx
  801011:	89 d8                	mov    %ebx,%eax
  801013:	d3 e8                	shr    %cl,%eax
  801015:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801019:	09 c1                	or     %eax,%ecx
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801021:	89 f9                	mov    %edi,%ecx
  801023:	d3 e3                	shl    %cl,%ebx
  801025:	89 d1                	mov    %edx,%ecx
  801027:	d3 e8                	shr    %cl,%eax
  801029:	89 f9                	mov    %edi,%ecx
  80102b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80102f:	89 eb                	mov    %ebp,%ebx
  801031:	d3 e6                	shl    %cl,%esi
  801033:	89 d1                	mov    %edx,%ecx
  801035:	d3 eb                	shr    %cl,%ebx
  801037:	09 f3                	or     %esi,%ebx
  801039:	89 c6                	mov    %eax,%esi
  80103b:	89 f2                	mov    %esi,%edx
  80103d:	89 d8                	mov    %ebx,%eax
  80103f:	f7 74 24 08          	divl   0x8(%esp)
  801043:	89 d6                	mov    %edx,%esi
  801045:	89 c3                	mov    %eax,%ebx
  801047:	f7 64 24 0c          	mull   0xc(%esp)
  80104b:	39 d6                	cmp    %edx,%esi
  80104d:	72 19                	jb     801068 <__udivdi3+0x108>
  80104f:	89 f9                	mov    %edi,%ecx
  801051:	d3 e5                	shl    %cl,%ebp
  801053:	39 c5                	cmp    %eax,%ebp
  801055:	73 04                	jae    80105b <__udivdi3+0xfb>
  801057:	39 d6                	cmp    %edx,%esi
  801059:	74 0d                	je     801068 <__udivdi3+0x108>
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	31 ff                	xor    %edi,%edi
  80105f:	e9 3c ff ff ff       	jmp    800fa0 <__udivdi3+0x40>
  801064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801068:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80106b:	31 ff                	xor    %edi,%edi
  80106d:	e9 2e ff ff ff       	jmp    800fa0 <__udivdi3+0x40>
  801072:	66 90                	xchg   %ax,%ax
  801074:	66 90                	xchg   %ax,%ax
  801076:	66 90                	xchg   %ax,%ax
  801078:	66 90                	xchg   %ax,%ax
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	f3 0f 1e fb          	endbr32 
  801084:	55                   	push   %ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 1c             	sub    $0x1c,%esp
  80108b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80108f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801093:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801097:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80109b:	89 f0                	mov    %esi,%eax
  80109d:	89 da                	mov    %ebx,%edx
  80109f:	85 ff                	test   %edi,%edi
  8010a1:	75 15                	jne    8010b8 <__umoddi3+0x38>
  8010a3:	39 dd                	cmp    %ebx,%ebp
  8010a5:	76 39                	jbe    8010e0 <__umoddi3+0x60>
  8010a7:	f7 f5                	div    %ebp
  8010a9:	89 d0                	mov    %edx,%eax
  8010ab:	31 d2                	xor    %edx,%edx
  8010ad:	83 c4 1c             	add    $0x1c,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
  8010b5:	8d 76 00             	lea    0x0(%esi),%esi
  8010b8:	39 df                	cmp    %ebx,%edi
  8010ba:	77 f1                	ja     8010ad <__umoddi3+0x2d>
  8010bc:	0f bd cf             	bsr    %edi,%ecx
  8010bf:	83 f1 1f             	xor    $0x1f,%ecx
  8010c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010c6:	75 40                	jne    801108 <__umoddi3+0x88>
  8010c8:	39 df                	cmp    %ebx,%edi
  8010ca:	72 04                	jb     8010d0 <__umoddi3+0x50>
  8010cc:	39 f5                	cmp    %esi,%ebp
  8010ce:	77 dd                	ja     8010ad <__umoddi3+0x2d>
  8010d0:	89 da                	mov    %ebx,%edx
  8010d2:	89 f0                	mov    %esi,%eax
  8010d4:	29 e8                	sub    %ebp,%eax
  8010d6:	19 fa                	sbb    %edi,%edx
  8010d8:	eb d3                	jmp    8010ad <__umoddi3+0x2d>
  8010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010e0:	89 e9                	mov    %ebp,%ecx
  8010e2:	85 ed                	test   %ebp,%ebp
  8010e4:	75 0b                	jne    8010f1 <__umoddi3+0x71>
  8010e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f5                	div    %ebp
  8010ef:	89 c1                	mov    %eax,%ecx
  8010f1:	89 d8                	mov    %ebx,%eax
  8010f3:	31 d2                	xor    %edx,%edx
  8010f5:	f7 f1                	div    %ecx
  8010f7:	89 f0                	mov    %esi,%eax
  8010f9:	f7 f1                	div    %ecx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	31 d2                	xor    %edx,%edx
  8010ff:	eb ac                	jmp    8010ad <__umoddi3+0x2d>
  801101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801108:	8b 44 24 04          	mov    0x4(%esp),%eax
  80110c:	ba 20 00 00 00       	mov    $0x20,%edx
  801111:	29 c2                	sub    %eax,%edx
  801113:	89 c1                	mov    %eax,%ecx
  801115:	89 e8                	mov    %ebp,%eax
  801117:	d3 e7                	shl    %cl,%edi
  801119:	89 d1                	mov    %edx,%ecx
  80111b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80111f:	d3 e8                	shr    %cl,%eax
  801121:	89 c1                	mov    %eax,%ecx
  801123:	8b 44 24 04          	mov    0x4(%esp),%eax
  801127:	09 f9                	or     %edi,%ecx
  801129:	89 df                	mov    %ebx,%edi
  80112b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80112f:	89 c1                	mov    %eax,%ecx
  801131:	d3 e5                	shl    %cl,%ebp
  801133:	89 d1                	mov    %edx,%ecx
  801135:	d3 ef                	shr    %cl,%edi
  801137:	89 c1                	mov    %eax,%ecx
  801139:	89 f0                	mov    %esi,%eax
  80113b:	d3 e3                	shl    %cl,%ebx
  80113d:	89 d1                	mov    %edx,%ecx
  80113f:	89 fa                	mov    %edi,%edx
  801141:	d3 e8                	shr    %cl,%eax
  801143:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801148:	09 d8                	or     %ebx,%eax
  80114a:	f7 74 24 08          	divl   0x8(%esp)
  80114e:	89 d3                	mov    %edx,%ebx
  801150:	d3 e6                	shl    %cl,%esi
  801152:	f7 e5                	mul    %ebp
  801154:	89 c7                	mov    %eax,%edi
  801156:	89 d1                	mov    %edx,%ecx
  801158:	39 d3                	cmp    %edx,%ebx
  80115a:	72 06                	jb     801162 <__umoddi3+0xe2>
  80115c:	75 0e                	jne    80116c <__umoddi3+0xec>
  80115e:	39 c6                	cmp    %eax,%esi
  801160:	73 0a                	jae    80116c <__umoddi3+0xec>
  801162:	29 e8                	sub    %ebp,%eax
  801164:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801168:	89 d1                	mov    %edx,%ecx
  80116a:	89 c7                	mov    %eax,%edi
  80116c:	89 f5                	mov    %esi,%ebp
  80116e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801172:	29 fd                	sub    %edi,%ebp
  801174:	19 cb                	sbb    %ecx,%ebx
  801176:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80117b:	89 d8                	mov    %ebx,%eax
  80117d:	d3 e0                	shl    %cl,%eax
  80117f:	89 f1                	mov    %esi,%ecx
  801181:	d3 ed                	shr    %cl,%ebp
  801183:	d3 eb                	shr    %cl,%ebx
  801185:	09 e8                	or     %ebp,%eax
  801187:	89 da                	mov    %ebx,%edx
  801189:	83 c4 1c             	add    $0x1c,%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
