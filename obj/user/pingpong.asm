
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 1d 0f 00 00       	call   800f5e <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 9e 10 00 00       	call   8010f6 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 ce 0b 00 00       	call   800c30 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 16 15 80 00       	push   $0x801516
  80006a:	e8 3e 01 00 00       	call   8001ad <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	push   -0x1c(%ebp)
  800082:	e8 be 10 00 00       	call   801145 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 92 0b 00 00       	call   800c30 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 00 15 80 00       	push   $0x801500
  8000a8:	e8 00 01 00 00       	call   8001ad <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	push   -0x1c(%ebp)
  8000b6:	e8 8a 10 00 00       	call   801145 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 60 0b 00 00       	call   800c30 <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80010c:	6a 00                	push   $0x0
  80010e:	e8 dc 0a 00 00       	call   800bef <sys_env_destroy>
}
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	53                   	push   %ebx
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800122:	8b 13                	mov    (%ebx),%edx
  800124:	8d 42 01             	lea    0x1(%edx),%eax
  800127:	89 03                	mov    %eax,(%ebx)
  800129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800130:	3d ff 00 00 00       	cmp    $0xff,%eax
  800135:	74 09                	je     800140 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 ff 00 00 00       	push   $0xff
  800148:	8d 43 08             	lea    0x8(%ebx),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 61 0a 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  800151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb db                	jmp    800137 <putch+0x1f>

0080015c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800165:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016c:	00 00 00 
	b.cnt = 0;
  80016f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800176:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800179:	ff 75 0c             	push   0xc(%ebp)
  80017c:	ff 75 08             	push   0x8(%ebp)
  80017f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	68 18 01 80 00       	push   $0x800118
  80018b:	e8 14 01 00 00       	call   8002a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800190:	83 c4 08             	add    $0x8,%esp
  800193:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800199:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 0d 0a 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  8001a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b6:	50                   	push   %eax
  8001b7:	ff 75 08             	push   0x8(%ebp)
  8001ba:	e8 9d ff ff ff       	call   80015c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 1c             	sub    $0x1c,%esp
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	89 d6                	mov    %edx,%esi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	89 d1                	mov    %edx,%ecx
  8001d6:	89 c2                	mov    %eax,%edx
  8001d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f3:	72 3e                	jb     800233 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	ff 75 18             	push   0x18(%ebp)
  8001fb:	83 eb 01             	sub    $0x1,%ebx
  8001fe:	53                   	push   %ebx
  8001ff:	50                   	push   %eax
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	ff 75 e4             	push   -0x1c(%ebp)
  800206:	ff 75 e0             	push   -0x20(%ebp)
  800209:	ff 75 dc             	push   -0x24(%ebp)
  80020c:	ff 75 d8             	push   -0x28(%ebp)
  80020f:	e8 9c 10 00 00       	call   8012b0 <__udivdi3>
  800214:	83 c4 18             	add    $0x18,%esp
  800217:	52                   	push   %edx
  800218:	50                   	push   %eax
  800219:	89 f2                	mov    %esi,%edx
  80021b:	89 f8                	mov    %edi,%eax
  80021d:	e8 9f ff ff ff       	call   8001c1 <printnum>
  800222:	83 c4 20             	add    $0x20,%esp
  800225:	eb 13                	jmp    80023a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	ff 75 18             	push   0x18(%ebp)
  80022e:	ff d7                	call   *%edi
  800230:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800233:	83 eb 01             	sub    $0x1,%ebx
  800236:	85 db                	test   %ebx,%ebx
  800238:	7f ed                	jg     800227 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	56                   	push   %esi
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	ff 75 e4             	push   -0x1c(%ebp)
  800244:	ff 75 e0             	push   -0x20(%ebp)
  800247:	ff 75 dc             	push   -0x24(%ebp)
  80024a:	ff 75 d8             	push   -0x28(%ebp)
  80024d:	e8 7e 11 00 00       	call   8013d0 <__umoddi3>
  800252:	83 c4 14             	add    $0x14,%esp
  800255:	0f be 80 33 15 80 00 	movsbl 0x801533(%eax),%eax
  80025c:	50                   	push   %eax
  80025d:	ff d7                	call   *%edi
}
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800265:	5b                   	pop    %ebx
  800266:	5e                   	pop    %esi
  800267:	5f                   	pop    %edi
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800270:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800274:	8b 10                	mov    (%eax),%edx
  800276:	3b 50 04             	cmp    0x4(%eax),%edx
  800279:	73 0a                	jae    800285 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027e:	89 08                	mov    %ecx,(%eax)
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	88 02                	mov    %al,(%edx)
}
  800285:	5d                   	pop    %ebp
  800286:	c3                   	ret    

00800287 <printfmt>:
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800290:	50                   	push   %eax
  800291:	ff 75 10             	push   0x10(%ebp)
  800294:	ff 75 0c             	push   0xc(%ebp)
  800297:	ff 75 08             	push   0x8(%ebp)
  80029a:	e8 05 00 00 00       	call   8002a4 <vprintfmt>
}
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <vprintfmt>:
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	57                   	push   %edi
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
  8002aa:	83 ec 3c             	sub    $0x3c,%esp
  8002ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b6:	eb 0a                	jmp    8002c2 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	53                   	push   %ebx
  8002bc:	50                   	push   %eax
  8002bd:	ff d6                	call   *%esi
  8002bf:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002c2:	83 c7 01             	add    $0x1,%edi
  8002c5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002c9:	83 f8 25             	cmp    $0x25,%eax
  8002cc:	74 0c                	je     8002da <vprintfmt+0x36>
			if (ch == '\0')
  8002ce:	85 c0                	test   %eax,%eax
  8002d0:	75 e6                	jne    8002b8 <vprintfmt+0x14>
}
  8002d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d5:	5b                   	pop    %ebx
  8002d6:	5e                   	pop    %esi
  8002d7:	5f                   	pop    %edi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    
		padc = ' ';
  8002da:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002de:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002e5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8002ec:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8002f3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f8:	8d 47 01             	lea    0x1(%edi),%eax
  8002fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002fe:	0f b6 17             	movzbl (%edi),%edx
  800301:	8d 42 dd             	lea    -0x23(%edx),%eax
  800304:	3c 55                	cmp    $0x55,%al
  800306:	0f 87 a6 04 00 00    	ja     8007b2 <vprintfmt+0x50e>
  80030c:	0f b6 c0             	movzbl %al,%eax
  80030f:	ff 24 85 80 16 80 00 	jmp    *0x801680(,%eax,4)
  800316:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800319:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80031d:	eb d9                	jmp    8002f8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800322:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800326:	eb d0                	jmp    8002f8 <vprintfmt+0x54>
  800328:	0f b6 d2             	movzbl %dl,%edx
  80032b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80032e:	b8 00 00 00 00       	mov    $0x0,%eax
  800333:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800336:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800339:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80033d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800340:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800343:	83 f9 09             	cmp    $0x9,%ecx
  800346:	77 55                	ja     80039d <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800348:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034b:	eb e9                	jmp    800336 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80034d:	8b 45 14             	mov    0x14(%ebp),%eax
  800350:	8b 00                	mov    (%eax),%eax
  800352:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800355:	8b 45 14             	mov    0x14(%ebp),%eax
  800358:	8d 40 04             	lea    0x4(%eax),%eax
  80035b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800361:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800365:	79 91                	jns    8002f8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80036d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800374:	eb 82                	jmp    8002f8 <vprintfmt+0x54>
  800376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800379:	85 d2                	test   %edx,%edx
  80037b:	b8 00 00 00 00       	mov    $0x0,%eax
  800380:	0f 49 c2             	cmovns %edx,%eax
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800386:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800389:	e9 6a ff ff ff       	jmp    8002f8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800391:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800398:	e9 5b ff ff ff       	jmp    8002f8 <vprintfmt+0x54>
  80039d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a3:	eb bc                	jmp    800361 <vprintfmt+0xbd>
			lflag++;
  8003a5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003ab:	e9 48 ff ff ff       	jmp    8002f8 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	53                   	push   %ebx
  8003ba:	ff 30                	push   (%eax)
  8003bc:	ff d6                	call   *%esi
			break;
  8003be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c4:	e9 88 03 00 00       	jmp    800751 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cc:	8d 78 04             	lea    0x4(%eax),%edi
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	f7 d8                	neg    %eax
  8003d5:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d8:	83 f8 0f             	cmp    $0xf,%eax
  8003db:	7f 23                	jg     800400 <vprintfmt+0x15c>
  8003dd:	8b 14 85 e0 17 80 00 	mov    0x8017e0(,%eax,4),%edx
  8003e4:	85 d2                	test   %edx,%edx
  8003e6:	74 18                	je     800400 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8003e8:	52                   	push   %edx
  8003e9:	68 54 15 80 00       	push   $0x801554
  8003ee:	53                   	push   %ebx
  8003ef:	56                   	push   %esi
  8003f0:	e8 92 fe ff ff       	call   800287 <printfmt>
  8003f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fb:	e9 51 03 00 00       	jmp    800751 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800400:	50                   	push   %eax
  800401:	68 4b 15 80 00       	push   $0x80154b
  800406:	53                   	push   %ebx
  800407:	56                   	push   %esi
  800408:	e8 7a fe ff ff       	call   800287 <printfmt>
  80040d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800410:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800413:	e9 39 03 00 00       	jmp    800751 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	83 c0 04             	add    $0x4,%eax
  80041e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800426:	85 d2                	test   %edx,%edx
  800428:	b8 44 15 80 00       	mov    $0x801544,%eax
  80042d:	0f 45 c2             	cmovne %edx,%eax
  800430:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800433:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800437:	7e 06                	jle    80043f <vprintfmt+0x19b>
  800439:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043d:	75 0d                	jne    80044c <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800442:	89 c7                	mov    %eax,%edi
  800444:	03 45 d4             	add    -0x2c(%ebp),%eax
  800447:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80044a:	eb 55                	jmp    8004a1 <vprintfmt+0x1fd>
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	ff 75 e0             	push   -0x20(%ebp)
  800452:	ff 75 cc             	push   -0x34(%ebp)
  800455:	e8 f5 03 00 00       	call   80084f <strnlen>
  80045a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80045d:	29 c2                	sub    %eax,%edx
  80045f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800467:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046e:	eb 0f                	jmp    80047f <vprintfmt+0x1db>
					putch(padc, putdat);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	ff 75 d4             	push   -0x2c(%ebp)
  800477:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800479:	83 ef 01             	sub    $0x1,%edi
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	85 ff                	test   %edi,%edi
  800481:	7f ed                	jg     800470 <vprintfmt+0x1cc>
  800483:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	b8 00 00 00 00       	mov    $0x0,%eax
  80048d:	0f 49 c2             	cmovns %edx,%eax
  800490:	29 c2                	sub    %eax,%edx
  800492:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800495:	eb a8                	jmp    80043f <vprintfmt+0x19b>
					putch(ch, putdat);
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	53                   	push   %ebx
  80049b:	52                   	push   %edx
  80049c:	ff d6                	call   *%esi
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004a4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a6:	83 c7 01             	add    $0x1,%edi
  8004a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ad:	0f be d0             	movsbl %al,%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 4b                	je     8004ff <vprintfmt+0x25b>
  8004b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b8:	78 06                	js     8004c0 <vprintfmt+0x21c>
  8004ba:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004be:	78 1e                	js     8004de <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c4:	74 d1                	je     800497 <vprintfmt+0x1f3>
  8004c6:	0f be c0             	movsbl %al,%eax
  8004c9:	83 e8 20             	sub    $0x20,%eax
  8004cc:	83 f8 5e             	cmp    $0x5e,%eax
  8004cf:	76 c6                	jbe    800497 <vprintfmt+0x1f3>
					putch('?', putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	6a 3f                	push   $0x3f
  8004d7:	ff d6                	call   *%esi
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	eb c3                	jmp    8004a1 <vprintfmt+0x1fd>
  8004de:	89 cf                	mov    %ecx,%edi
  8004e0:	eb 0e                	jmp    8004f0 <vprintfmt+0x24c>
				putch(' ', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 20                	push   $0x20
  8004e8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ea:	83 ef 01             	sub    $0x1,%edi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	85 ff                	test   %edi,%edi
  8004f2:	7f ee                	jg     8004e2 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fa:	e9 52 02 00 00       	jmp    800751 <vprintfmt+0x4ad>
  8004ff:	89 cf                	mov    %ecx,%edi
  800501:	eb ed                	jmp    8004f0 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	83 c0 04             	add    $0x4,%eax
  800509:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800511:	85 d2                	test   %edx,%edx
  800513:	b8 44 15 80 00       	mov    $0x801544,%eax
  800518:	0f 45 c2             	cmovne %edx,%eax
  80051b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800522:	7e 06                	jle    80052a <vprintfmt+0x286>
  800524:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800528:	75 0d                	jne    800537 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052d:	89 c7                	mov    %eax,%edi
  80052f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800532:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800535:	eb 55                	jmp    80058c <vprintfmt+0x2e8>
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 e0             	push   -0x20(%ebp)
  80053d:	ff 75 cc             	push   -0x34(%ebp)
  800540:	e8 0a 03 00 00       	call   80084f <strnlen>
  800545:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800548:	29 c2                	sub    %eax,%edx
  80054a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800552:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800556:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800559:	eb 0f                	jmp    80056a <vprintfmt+0x2c6>
					putch(padc, putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	ff 75 d4             	push   -0x2c(%ebp)
  800562:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800564:	83 ef 01             	sub    $0x1,%edi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	85 ff                	test   %edi,%edi
  80056c:	7f ed                	jg     80055b <vprintfmt+0x2b7>
  80056e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800571:	85 d2                	test   %edx,%edx
  800573:	b8 00 00 00 00       	mov    $0x0,%eax
  800578:	0f 49 c2             	cmovns %edx,%eax
  80057b:	29 c2                	sub    %eax,%edx
  80057d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800580:	eb a8                	jmp    80052a <vprintfmt+0x286>
					putch(ch, putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	53                   	push   %ebx
  800586:	52                   	push   %edx
  800587:	ff d6                	call   *%esi
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80058f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800591:	83 c7 01             	add    $0x1,%edi
  800594:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800598:	0f be d0             	movsbl %al,%edx
  80059b:	3c 3a                	cmp    $0x3a,%al
  80059d:	74 4b                	je     8005ea <vprintfmt+0x346>
  80059f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a3:	78 06                	js     8005ab <vprintfmt+0x307>
  8005a5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005a9:	78 1e                	js     8005c9 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005af:	74 d1                	je     800582 <vprintfmt+0x2de>
  8005b1:	0f be c0             	movsbl %al,%eax
  8005b4:	83 e8 20             	sub    $0x20,%eax
  8005b7:	83 f8 5e             	cmp    $0x5e,%eax
  8005ba:	76 c6                	jbe    800582 <vprintfmt+0x2de>
					putch('?', putdat);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	53                   	push   %ebx
  8005c0:	6a 3f                	push   $0x3f
  8005c2:	ff d6                	call   *%esi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	eb c3                	jmp    80058c <vprintfmt+0x2e8>
  8005c9:	89 cf                	mov    %ecx,%edi
  8005cb:	eb 0e                	jmp    8005db <vprintfmt+0x337>
				putch(' ', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 20                	push   $0x20
  8005d3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d5:	83 ef 01             	sub    $0x1,%edi
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	85 ff                	test   %edi,%edi
  8005dd:	7f ee                	jg     8005cd <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8005df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	e9 67 01 00 00       	jmp    800751 <vprintfmt+0x4ad>
  8005ea:	89 cf                	mov    %ecx,%edi
  8005ec:	eb ed                	jmp    8005db <vprintfmt+0x337>
	if (lflag >= 2)
  8005ee:	83 f9 01             	cmp    $0x1,%ecx
  8005f1:	7f 1b                	jg     80060e <vprintfmt+0x36a>
	else if (lflag)
  8005f3:	85 c9                	test   %ecx,%ecx
  8005f5:	74 63                	je     80065a <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ff:	99                   	cltd   
  800600:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb 17                	jmp    800625 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 50 04             	mov    0x4(%eax),%edx
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800619:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 08             	lea    0x8(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800628:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80062b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800630:	85 c9                	test   %ecx,%ecx
  800632:	0f 89 ff 00 00 00    	jns    800737 <vprintfmt+0x493>
				putch('-', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 2d                	push   $0x2d
  80063e:	ff d6                	call   *%esi
				num = -(long long) num;
  800640:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800643:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800646:	f7 da                	neg    %edx
  800648:	83 d1 00             	adc    $0x0,%ecx
  80064b:	f7 d9                	neg    %ecx
  80064d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800650:	bf 0a 00 00 00       	mov    $0xa,%edi
  800655:	e9 dd 00 00 00       	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800662:	99                   	cltd   
  800663:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 04             	lea    0x4(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	eb b4                	jmp    800625 <vprintfmt+0x381>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7f 1e                	jg     800694 <vprintfmt+0x3f0>
	else if (lflag)
  800676:	85 c9                	test   %ecx,%ecx
  800678:	74 32                	je     8006ac <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80068f:	e9 a3 00 00 00       	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	8b 48 04             	mov    0x4(%eax),%ecx
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a2:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006a7:	e9 8b 00 00 00       	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 10                	mov    (%eax),%edx
  8006b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bc:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006c1:	eb 74                	jmp    800737 <vprintfmt+0x493>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7f 1b                	jg     8006e3 <vprintfmt+0x43f>
	else if (lflag)
  8006c8:	85 c9                	test   %ecx,%ecx
  8006ca:	74 2c                	je     8006f8 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dc:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8006e1:	eb 54                	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006eb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f1:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8006f6:	eb 3f                	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800708:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80070d:	eb 28                	jmp    800737 <vprintfmt+0x493>
			putch('0', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	6a 30                	push   $0x30
  800715:	ff d6                	call   *%esi
			putch('x', putdat);
  800717:	83 c4 08             	add    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 78                	push   $0x78
  80071d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 10                	mov    (%eax),%edx
  800724:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800729:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80073e:	50                   	push   %eax
  80073f:	ff 75 d4             	push   -0x2c(%ebp)
  800742:	57                   	push   %edi
  800743:	51                   	push   %ecx
  800744:	52                   	push   %edx
  800745:	89 da                	mov    %ebx,%edx
  800747:	89 f0                	mov    %esi,%eax
  800749:	e8 73 fa ff ff       	call   8001c1 <printnum>
			break;
  80074e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800751:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800754:	e9 69 fb ff ff       	jmp    8002c2 <vprintfmt+0x1e>
	if (lflag >= 2)
  800759:	83 f9 01             	cmp    $0x1,%ecx
  80075c:	7f 1b                	jg     800779 <vprintfmt+0x4d5>
	else if (lflag)
  80075e:	85 c9                	test   %ecx,%ecx
  800760:	74 2c                	je     80078e <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800777:	eb be                	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 10                	mov    (%eax),%edx
  80077e:	8b 48 04             	mov    0x4(%eax),%ecx
  800781:	8d 40 08             	lea    0x8(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800787:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80078c:	eb a9                	jmp    800737 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 10                	mov    (%eax),%edx
  800793:	b9 00 00 00 00       	mov    $0x0,%ecx
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079e:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007a3:	eb 92                	jmp    800737 <vprintfmt+0x493>
			putch(ch, putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 25                	push   $0x25
  8007ab:	ff d6                	call   *%esi
			break;
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	eb 9f                	jmp    800751 <vprintfmt+0x4ad>
			putch('%', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 25                	push   $0x25
  8007b8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 f8                	mov    %edi,%eax
  8007bf:	eb 03                	jmp    8007c4 <vprintfmt+0x520>
  8007c1:	83 e8 01             	sub    $0x1,%eax
  8007c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c8:	75 f7                	jne    8007c1 <vprintfmt+0x51d>
  8007ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cd:	eb 82                	jmp    800751 <vprintfmt+0x4ad>

008007cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	83 ec 18             	sub    $0x18,%esp
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007de:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ec:	85 c0                	test   %eax,%eax
  8007ee:	74 26                	je     800816 <vsnprintf+0x47>
  8007f0:	85 d2                	test   %edx,%edx
  8007f2:	7e 22                	jle    800816 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f4:	ff 75 14             	push   0x14(%ebp)
  8007f7:	ff 75 10             	push   0x10(%ebp)
  8007fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fd:	50                   	push   %eax
  8007fe:	68 6a 02 80 00       	push   $0x80026a
  800803:	e8 9c fa ff ff       	call   8002a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800811:	83 c4 10             	add    $0x10,%esp
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    
		return -E_INVAL;
  800816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081b:	eb f7                	jmp    800814 <vsnprintf+0x45>

0080081d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800823:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800826:	50                   	push   %eax
  800827:	ff 75 10             	push   0x10(%ebp)
  80082a:	ff 75 0c             	push   0xc(%ebp)
  80082d:	ff 75 08             	push   0x8(%ebp)
  800830:	e8 9a ff ff ff       	call   8007cf <vsnprintf>
	va_end(ap);

	return rc;
}
  800835:	c9                   	leave  
  800836:	c3                   	ret    

00800837 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
  800842:	eb 03                	jmp    800847 <strlen+0x10>
		n++;
  800844:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800847:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084b:	75 f7                	jne    800844 <strlen+0xd>
	return n;
}
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	eb 03                	jmp    800862 <strnlen+0x13>
		n++;
  80085f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800862:	39 d0                	cmp    %edx,%eax
  800864:	74 08                	je     80086e <strnlen+0x1f>
  800866:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80086a:	75 f3                	jne    80085f <strnlen+0x10>
  80086c:	89 c2                	mov    %eax,%edx
	return n;
}
  80086e:	89 d0                	mov    %edx,%eax
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800879:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087c:	b8 00 00 00 00       	mov    $0x0,%eax
  800881:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800885:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800888:	83 c0 01             	add    $0x1,%eax
  80088b:	84 d2                	test   %dl,%dl
  80088d:	75 f2                	jne    800881 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80088f:	89 c8                	mov    %ecx,%eax
  800891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	53                   	push   %ebx
  80089a:	83 ec 10             	sub    $0x10,%esp
  80089d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a0:	53                   	push   %ebx
  8008a1:	e8 91 ff ff ff       	call   800837 <strlen>
  8008a6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008a9:	ff 75 0c             	push   0xc(%ebp)
  8008ac:	01 d8                	add    %ebx,%eax
  8008ae:	50                   	push   %eax
  8008af:	e8 be ff ff ff       	call   800872 <strcpy>
	return dst;
}
  8008b4:	89 d8                	mov    %ebx,%eax
  8008b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	89 f3                	mov    %esi,%ebx
  8008c8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008cb:	89 f0                	mov    %esi,%eax
  8008cd:	eb 0f                	jmp    8008de <strncpy+0x23>
		*dst++ = *src;
  8008cf:	83 c0 01             	add    $0x1,%eax
  8008d2:	0f b6 0a             	movzbl (%edx),%ecx
  8008d5:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d8:	80 f9 01             	cmp    $0x1,%cl
  8008db:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8008de:	39 d8                	cmp    %ebx,%eax
  8008e0:	75 ed                	jne    8008cf <strncpy+0x14>
	}
	return ret;
}
  8008e2:	89 f0                	mov    %esi,%eax
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f8:	85 d2                	test   %edx,%edx
  8008fa:	74 21                	je     80091d <strlcpy+0x35>
  8008fc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800900:	89 f2                	mov    %esi,%edx
  800902:	eb 09                	jmp    80090d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800904:	83 c1 01             	add    $0x1,%ecx
  800907:	83 c2 01             	add    $0x1,%edx
  80090a:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80090d:	39 c2                	cmp    %eax,%edx
  80090f:	74 09                	je     80091a <strlcpy+0x32>
  800911:	0f b6 19             	movzbl (%ecx),%ebx
  800914:	84 db                	test   %bl,%bl
  800916:	75 ec                	jne    800904 <strlcpy+0x1c>
  800918:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80091a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80091d:	29 f0                	sub    %esi,%eax
}
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092c:	eb 06                	jmp    800934 <strcmp+0x11>
		p++, q++;
  80092e:	83 c1 01             	add    $0x1,%ecx
  800931:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800934:	0f b6 01             	movzbl (%ecx),%eax
  800937:	84 c0                	test   %al,%al
  800939:	74 04                	je     80093f <strcmp+0x1c>
  80093b:	3a 02                	cmp    (%edx),%al
  80093d:	74 ef                	je     80092e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093f:	0f b6 c0             	movzbl %al,%eax
  800942:	0f b6 12             	movzbl (%edx),%edx
  800945:	29 d0                	sub    %edx,%eax
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	53                   	push   %ebx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 c3                	mov    %eax,%ebx
  800955:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800958:	eb 06                	jmp    800960 <strncmp+0x17>
		n--, p++, q++;
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800960:	39 d8                	cmp    %ebx,%eax
  800962:	74 18                	je     80097c <strncmp+0x33>
  800964:	0f b6 08             	movzbl (%eax),%ecx
  800967:	84 c9                	test   %cl,%cl
  800969:	74 04                	je     80096f <strncmp+0x26>
  80096b:	3a 0a                	cmp    (%edx),%cl
  80096d:	74 eb                	je     80095a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096f:	0f b6 00             	movzbl (%eax),%eax
  800972:	0f b6 12             	movzbl (%edx),%edx
  800975:	29 d0                	sub    %edx,%eax
}
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    
		return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	eb f4                	jmp    800977 <strncmp+0x2e>

00800983 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098d:	eb 03                	jmp    800992 <strchr+0xf>
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	0f b6 10             	movzbl (%eax),%edx
  800995:	84 d2                	test   %dl,%dl
  800997:	74 06                	je     80099f <strchr+0x1c>
		if (*s == c)
  800999:	38 ca                	cmp    %cl,%dl
  80099b:	75 f2                	jne    80098f <strchr+0xc>
  80099d:	eb 05                	jmp    8009a4 <strchr+0x21>
			return (char *) s;
	return 0;
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b3:	38 ca                	cmp    %cl,%dl
  8009b5:	74 09                	je     8009c0 <strfind+0x1a>
  8009b7:	84 d2                	test   %dl,%dl
  8009b9:	74 05                	je     8009c0 <strfind+0x1a>
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	eb f0                	jmp    8009b0 <strfind+0xa>
			break;
	return (char *) s;
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	57                   	push   %edi
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ce:	85 c9                	test   %ecx,%ecx
  8009d0:	74 2f                	je     800a01 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d2:	89 f8                	mov    %edi,%eax
  8009d4:	09 c8                	or     %ecx,%eax
  8009d6:	a8 03                	test   $0x3,%al
  8009d8:	75 21                	jne    8009fb <memset+0x39>
		c &= 0xFF;
  8009da:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	c1 e0 08             	shl    $0x8,%eax
  8009e3:	89 d3                	mov    %edx,%ebx
  8009e5:	c1 e3 18             	shl    $0x18,%ebx
  8009e8:	89 d6                	mov    %edx,%esi
  8009ea:	c1 e6 10             	shl    $0x10,%esi
  8009ed:	09 f3                	or     %esi,%ebx
  8009ef:	09 da                	or     %ebx,%edx
  8009f1:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f6:	fc                   	cld    
  8009f7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f9:	eb 06                	jmp    800a01 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fe:	fc                   	cld    
  8009ff:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a01:	89 f8                	mov    %edi,%eax
  800a03:	5b                   	pop    %ebx
  800a04:	5e                   	pop    %esi
  800a05:	5f                   	pop    %edi
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	57                   	push   %edi
  800a0c:	56                   	push   %esi
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a13:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a16:	39 c6                	cmp    %eax,%esi
  800a18:	73 32                	jae    800a4c <memmove+0x44>
  800a1a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a1d:	39 c2                	cmp    %eax,%edx
  800a1f:	76 2b                	jbe    800a4c <memmove+0x44>
		s += n;
		d += n;
  800a21:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	89 d6                	mov    %edx,%esi
  800a26:	09 fe                	or     %edi,%esi
  800a28:	09 ce                	or     %ecx,%esi
  800a2a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a30:	75 0e                	jne    800a40 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a32:	83 ef 04             	sub    $0x4,%edi
  800a35:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3b:	fd                   	std    
  800a3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3e:	eb 09                	jmp    800a49 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a40:	83 ef 01             	sub    $0x1,%edi
  800a43:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a46:	fd                   	std    
  800a47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a49:	fc                   	cld    
  800a4a:	eb 1a                	jmp    800a66 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4c:	89 f2                	mov    %esi,%edx
  800a4e:	09 c2                	or     %eax,%edx
  800a50:	09 ca                	or     %ecx,%edx
  800a52:	f6 c2 03             	test   $0x3,%dl
  800a55:	75 0a                	jne    800a61 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a57:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5a:	89 c7                	mov    %eax,%edi
  800a5c:	fc                   	cld    
  800a5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5f:	eb 05                	jmp    800a66 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a61:	89 c7                	mov    %eax,%edi
  800a63:	fc                   	cld    
  800a64:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a70:	ff 75 10             	push   0x10(%ebp)
  800a73:	ff 75 0c             	push   0xc(%ebp)
  800a76:	ff 75 08             	push   0x8(%ebp)
  800a79:	e8 8a ff ff ff       	call   800a08 <memmove>
}
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	56                   	push   %esi
  800a84:	53                   	push   %ebx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8b:	89 c6                	mov    %eax,%esi
  800a8d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a90:	eb 06                	jmp    800a98 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a92:	83 c0 01             	add    $0x1,%eax
  800a95:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a98:	39 f0                	cmp    %esi,%eax
  800a9a:	74 14                	je     800ab0 <memcmp+0x30>
		if (*s1 != *s2)
  800a9c:	0f b6 08             	movzbl (%eax),%ecx
  800a9f:	0f b6 1a             	movzbl (%edx),%ebx
  800aa2:	38 d9                	cmp    %bl,%cl
  800aa4:	74 ec                	je     800a92 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800aa6:	0f b6 c1             	movzbl %cl,%eax
  800aa9:	0f b6 db             	movzbl %bl,%ebx
  800aac:	29 d8                	sub    %ebx,%eax
  800aae:	eb 05                	jmp    800ab5 <memcmp+0x35>
	}

	return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5e                   	pop    %esi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac2:	89 c2                	mov    %eax,%edx
  800ac4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac7:	eb 03                	jmp    800acc <memfind+0x13>
  800ac9:	83 c0 01             	add    $0x1,%eax
  800acc:	39 d0                	cmp    %edx,%eax
  800ace:	73 04                	jae    800ad4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad0:	38 08                	cmp    %cl,(%eax)
  800ad2:	75 f5                	jne    800ac9 <memfind+0x10>
			break;
	return (void *) s;
}
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 55 08             	mov    0x8(%ebp),%edx
  800adf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae2:	eb 03                	jmp    800ae7 <strtol+0x11>
		s++;
  800ae4:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ae7:	0f b6 02             	movzbl (%edx),%eax
  800aea:	3c 20                	cmp    $0x20,%al
  800aec:	74 f6                	je     800ae4 <strtol+0xe>
  800aee:	3c 09                	cmp    $0x9,%al
  800af0:	74 f2                	je     800ae4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af2:	3c 2b                	cmp    $0x2b,%al
  800af4:	74 2a                	je     800b20 <strtol+0x4a>
	int neg = 0;
  800af6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afb:	3c 2d                	cmp    $0x2d,%al
  800afd:	74 2b                	je     800b2a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aff:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b05:	75 0f                	jne    800b16 <strtol+0x40>
  800b07:	80 3a 30             	cmpb   $0x30,(%edx)
  800b0a:	74 28                	je     800b34 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0c:	85 db                	test   %ebx,%ebx
  800b0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b13:	0f 44 d8             	cmove  %eax,%ebx
  800b16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b1e:	eb 46                	jmp    800b66 <strtol+0x90>
		s++;
  800b20:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b23:	bf 00 00 00 00       	mov    $0x0,%edi
  800b28:	eb d5                	jmp    800aff <strtol+0x29>
		s++, neg = 1;
  800b2a:	83 c2 01             	add    $0x1,%edx
  800b2d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b32:	eb cb                	jmp    800aff <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b34:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b38:	74 0e                	je     800b48 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	75 d8                	jne    800b16 <strtol+0x40>
		s++, base = 8;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b46:	eb ce                	jmp    800b16 <strtol+0x40>
		s += 2, base = 16;
  800b48:	83 c2 02             	add    $0x2,%edx
  800b4b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b50:	eb c4                	jmp    800b16 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b52:	0f be c0             	movsbl %al,%eax
  800b55:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b5b:	7d 3a                	jge    800b97 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b5d:	83 c2 01             	add    $0x1,%edx
  800b60:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b64:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b66:	0f b6 02             	movzbl (%edx),%eax
  800b69:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b6c:	89 f3                	mov    %esi,%ebx
  800b6e:	80 fb 09             	cmp    $0x9,%bl
  800b71:	76 df                	jbe    800b52 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b73:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b76:	89 f3                	mov    %esi,%ebx
  800b78:	80 fb 19             	cmp    $0x19,%bl
  800b7b:	77 08                	ja     800b85 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b7d:	0f be c0             	movsbl %al,%eax
  800b80:	83 e8 57             	sub    $0x57,%eax
  800b83:	eb d3                	jmp    800b58 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b85:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b88:	89 f3                	mov    %esi,%ebx
  800b8a:	80 fb 19             	cmp    $0x19,%bl
  800b8d:	77 08                	ja     800b97 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b8f:	0f be c0             	movsbl %al,%eax
  800b92:	83 e8 37             	sub    $0x37,%eax
  800b95:	eb c1                	jmp    800b58 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9b:	74 05                	je     800ba2 <strtol+0xcc>
		*endptr = (char *) s;
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ba2:	89 c8                	mov    %ecx,%eax
  800ba4:	f7 d8                	neg    %eax
  800ba6:	85 ff                	test   %edi,%edi
  800ba8:	0f 45 c8             	cmovne %eax,%ecx
}
  800bab:	89 c8                	mov    %ecx,%eax
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	89 c3                	mov    %eax,%ebx
  800bc5:	89 c7                	mov    %eax,%edi
  800bc7:	89 c6                	mov    %eax,%esi
  800bc9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 01 00 00 00       	mov    $0x1,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800c00:	b8 03 00 00 00       	mov    $0x3,%eax
  800c05:	89 cb                	mov    %ecx,%ebx
  800c07:	89 cf                	mov    %ecx,%edi
  800c09:	89 ce                	mov    %ecx,%esi
  800c0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	7f 08                	jg     800c19 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	50                   	push   %eax
  800c1d:	6a 03                	push   $0x3
  800c1f:	68 3f 18 80 00       	push   $0x80183f
  800c24:	6a 23                	push   $0x23
  800c26:	68 5c 18 80 00       	push   $0x80185c
  800c2b:	e8 9a 05 00 00       	call   8011ca <_panic>

00800c30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	57                   	push   %edi
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c36:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c40:	89 d1                	mov    %edx,%ecx
  800c42:	89 d3                	mov    %edx,%ebx
  800c44:	89 d7                	mov    %edx,%edi
  800c46:	89 d6                	mov    %edx,%esi
  800c48:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_yield>:

void
sys_yield(void)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	be 00 00 00 00       	mov    $0x0,%esi
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 04 00 00 00       	mov    $0x4,%eax
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8a:	89 f7                	mov    %esi,%edi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 04                	push   $0x4
  800ca0:	68 3f 18 80 00       	push   $0x80183f
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 5c 18 80 00       	push   $0x80185c
  800cac:	e8 19 05 00 00       	call   8011ca <_panic>

00800cb1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccb:	8b 75 18             	mov    0x18(%ebp),%esi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 05                	push   $0x5
  800ce2:	68 3f 18 80 00       	push   $0x80183f
  800ce7:	6a 23                	push   $0x23
  800ce9:	68 5c 18 80 00       	push   $0x80185c
  800cee:	e8 d7 04 00 00       	call   8011ca <_panic>

00800cf3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d07:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0c:	89 df                	mov    %ebx,%edi
  800d0e:	89 de                	mov    %ebx,%esi
  800d10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7f 08                	jg     800d1e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1e:	83 ec 0c             	sub    $0xc,%esp
  800d21:	50                   	push   %eax
  800d22:	6a 06                	push   $0x6
  800d24:	68 3f 18 80 00       	push   $0x80183f
  800d29:	6a 23                	push   $0x23
  800d2b:	68 5c 18 80 00       	push   $0x80185c
  800d30:	e8 95 04 00 00       	call   8011ca <_panic>

00800d35 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4e:	89 df                	mov    %ebx,%edi
  800d50:	89 de                	mov    %ebx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 08                	push   $0x8
  800d66:	68 3f 18 80 00       	push   $0x80183f
  800d6b:	6a 23                	push   $0x23
  800d6d:	68 5c 18 80 00       	push   $0x80185c
  800d72:	e8 53 04 00 00       	call   8011ca <_panic>

00800d77 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	89 de                	mov    %ebx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 09                	push   $0x9
  800da8:	68 3f 18 80 00       	push   $0x80183f
  800dad:	6a 23                	push   $0x23
  800daf:	68 5c 18 80 00       	push   $0x80185c
  800db4:	e8 11 04 00 00       	call   8011ca <_panic>

00800db9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 0a                	push   $0xa
  800dea:	68 3f 18 80 00       	push   $0x80183f
  800def:	6a 23                	push   $0x23
  800df1:	68 5c 18 80 00       	push   $0x80185c
  800df6:	e8 cf 03 00 00       	call   8011ca <_panic>

00800dfb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e07:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e0c:	be 00 00 00 00       	mov    $0x0,%esi
  800e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e17:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e34:	89 cb                	mov    %ecx,%ebx
  800e36:	89 cf                	mov    %ecx,%edi
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 0d                	push   $0xd
  800e4e:	68 3f 18 80 00       	push   $0x80183f
  800e53:	6a 23                	push   $0x23
  800e55:	68 5c 18 80 00       	push   $0x80185c
  800e5a:	e8 6b 03 00 00       	call   8011ca <_panic>

00800e5f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	53                   	push   %ebx
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e69:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800e6b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e6f:	0f 84 99 00 00 00    	je     800f0e <pgfault+0xaf>
  800e75:	89 d8                	mov    %ebx,%eax
  800e77:	c1 e8 16             	shr    $0x16,%eax
  800e7a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e81:	a8 01                	test   $0x1,%al
  800e83:	0f 84 85 00 00 00    	je     800f0e <pgfault+0xaf>
  800e89:	89 d8                	mov    %ebx,%eax
  800e8b:	c1 e8 0c             	shr    $0xc,%eax
  800e8e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e95:	f6 c6 08             	test   $0x8,%dh
  800e98:	74 74                	je     800f0e <pgfault+0xaf>
  800e9a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ea1:	a8 01                	test   $0x1,%al
  800ea3:	74 69                	je     800f0e <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	6a 07                	push   $0x7
  800eaa:	68 00 f0 7f 00       	push   $0x7ff000
  800eaf:	6a 00                	push   $0x0
  800eb1:	e8 b8 fd ff ff       	call   800c6e <sys_page_alloc>
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	78 65                	js     800f22 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ebd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ec3:	83 ec 04             	sub    $0x4,%esp
  800ec6:	68 00 10 00 00       	push   $0x1000
  800ecb:	53                   	push   %ebx
  800ecc:	68 00 f0 7f 00       	push   $0x7ff000
  800ed1:	e8 94 fb ff ff       	call   800a6a <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800ed6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800edd:	53                   	push   %ebx
  800ede:	6a 00                	push   $0x0
  800ee0:	68 00 f0 7f 00       	push   $0x7ff000
  800ee5:	6a 00                	push   $0x0
  800ee7:	e8 c5 fd ff ff       	call   800cb1 <sys_page_map>
  800eec:	83 c4 20             	add    $0x20,%esp
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	78 43                	js     800f36 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	68 00 f0 7f 00       	push   $0x7ff000
  800efb:	6a 00                	push   $0x0
  800efd:	e8 f1 fd ff ff       	call   800cf3 <sys_page_unmap>
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	85 c0                	test   %eax,%eax
  800f07:	78 41                	js     800f4a <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800f09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    
		panic("invalid permision\n");
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	68 6a 18 80 00       	push   $0x80186a
  800f16:	6a 1f                	push   $0x1f
  800f18:	68 7d 18 80 00       	push   $0x80187d
  800f1d:	e8 a8 02 00 00       	call   8011ca <_panic>
		panic("Unable to alloc page\n");
  800f22:	83 ec 04             	sub    $0x4,%esp
  800f25:	68 88 18 80 00       	push   $0x801888
  800f2a:	6a 28                	push   $0x28
  800f2c:	68 7d 18 80 00       	push   $0x80187d
  800f31:	e8 94 02 00 00       	call   8011ca <_panic>
		panic("Unable to map\n");
  800f36:	83 ec 04             	sub    $0x4,%esp
  800f39:	68 9e 18 80 00       	push   $0x80189e
  800f3e:	6a 2b                	push   $0x2b
  800f40:	68 7d 18 80 00       	push   $0x80187d
  800f45:	e8 80 02 00 00       	call   8011ca <_panic>
		panic("Unable to unmap\n");
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	68 ad 18 80 00       	push   $0x8018ad
  800f52:	6a 2d                	push   $0x2d
  800f54:	68 7d 18 80 00       	push   $0x80187d
  800f59:	e8 6c 02 00 00       	call   8011ca <_panic>

00800f5e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800f67:	68 5f 0e 80 00       	push   $0x800e5f
  800f6c:	e8 9f 02 00 00       	call   801210 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f71:	b8 07 00 00 00       	mov    $0x7,%eax
  800f76:	cd 30                	int    $0x30
  800f78:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	78 23                	js     800fa4 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f81:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  800f86:	75 6d                	jne    800ff5 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f88:	e8 a3 fc ff ff       	call   800c30 <sys_getenvid>
  800f8d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f92:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f95:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f9a:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f9f:	e9 02 01 00 00       	jmp    8010a6 <fork+0x148>
		panic("sys_exofork: %e", envid);
  800fa4:	50                   	push   %eax
  800fa5:	68 be 18 80 00       	push   $0x8018be
  800faa:	6a 6d                	push   $0x6d
  800fac:	68 7d 18 80 00       	push   $0x80187d
  800fb1:	e8 14 02 00 00       	call   8011ca <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  800fb6:	c1 e0 0c             	shl    $0xc,%eax
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fc2:	52                   	push   %edx
  800fc3:	50                   	push   %eax
  800fc4:	56                   	push   %esi
  800fc5:	50                   	push   %eax
  800fc6:	6a 00                	push   $0x0
  800fc8:	e8 e4 fc ff ff       	call   800cb1 <sys_page_map>
  800fcd:	83 c4 20             	add    $0x20,%esp
  800fd0:	eb 15                	jmp    800fe7 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  800fd2:	c1 e0 0c             	shl    $0xc,%eax
  800fd5:	83 ec 0c             	sub    $0xc,%esp
  800fd8:	6a 05                	push   $0x5
  800fda:	50                   	push   %eax
  800fdb:	56                   	push   %esi
  800fdc:	50                   	push   %eax
  800fdd:	6a 00                	push   $0x0
  800fdf:	e8 cd fc ff ff       	call   800cb1 <sys_page_map>
  800fe4:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fe7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fed:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800ff3:	74 7a                	je     80106f <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  800ff5:	89 d8                	mov    %ebx,%eax
  800ff7:	c1 e8 16             	shr    $0x16,%eax
  800ffa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801001:	a8 01                	test   $0x1,%al
  801003:	74 e2                	je     800fe7 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801005:	89 d8                	mov    %ebx,%eax
  801007:	c1 e8 0c             	shr    $0xc,%eax
  80100a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801011:	f6 c2 01             	test   $0x1,%dl
  801014:	74 d1                	je     800fe7 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801016:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80101d:	f6 c2 04             	test   $0x4,%dl
  801020:	74 c5                	je     800fe7 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801022:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801029:	f6 c6 04             	test   $0x4,%dh
  80102c:	75 88                	jne    800fb6 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  80102e:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801034:	74 9c                	je     800fd2 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801036:	c1 e0 0c             	shl    $0xc,%eax
  801039:	89 c7                	mov    %eax,%edi
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	68 05 08 00 00       	push   $0x805
  801043:	50                   	push   %eax
  801044:	56                   	push   %esi
  801045:	50                   	push   %eax
  801046:	6a 00                	push   $0x0
  801048:	e8 64 fc ff ff       	call   800cb1 <sys_page_map>
  80104d:	83 c4 20             	add    $0x20,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	78 93                	js     800fe7 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	68 05 08 00 00       	push   $0x805
  80105c:	57                   	push   %edi
  80105d:	6a 00                	push   $0x0
  80105f:	57                   	push   %edi
  801060:	6a 00                	push   $0x0
  801062:	e8 4a fc ff ff       	call   800cb1 <sys_page_map>
  801067:	83 c4 20             	add    $0x20,%esp
  80106a:	e9 78 ff ff ff       	jmp    800fe7 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	6a 07                	push   $0x7
  801074:	68 00 f0 bf ee       	push   $0xeebff000
  801079:	56                   	push   %esi
  80107a:	e8 ef fb ff ff       	call   800c6e <sys_page_alloc>
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	78 2a                	js     8010b0 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	68 7f 12 80 00       	push   $0x80127f
  80108e:	56                   	push   %esi
  80108f:	e8 25 fd ff ff       	call   800db9 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801094:	83 c4 08             	add    $0x8,%esp
  801097:	6a 02                	push   $0x2
  801099:	56                   	push   %esi
  80109a:	e8 96 fc ff ff       	call   800d35 <sys_env_set_status>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 21                	js     8010c7 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010a6:	89 f0                	mov    %esi,%eax
  8010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		panic("failed to alloc page");
  8010b0:	83 ec 04             	sub    $0x4,%esp
  8010b3:	68 ce 18 80 00       	push   $0x8018ce
  8010b8:	68 82 00 00 00       	push   $0x82
  8010bd:	68 7d 18 80 00       	push   $0x80187d
  8010c2:	e8 03 01 00 00       	call   8011ca <_panic>
		panic("sys_env_set_status: %e", r);
  8010c7:	50                   	push   %eax
  8010c8:	68 e3 18 80 00       	push   $0x8018e3
  8010cd:	68 89 00 00 00       	push   $0x89
  8010d2:	68 7d 18 80 00       	push   $0x80187d
  8010d7:	e8 ee 00 00 00       	call   8011ca <_panic>

008010dc <sfork>:

// Challenge!
int
sfork(void)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010e2:	68 fa 18 80 00       	push   $0x8018fa
  8010e7:	68 92 00 00 00       	push   $0x92
  8010ec:	68 7d 18 80 00       	push   $0x80187d
  8010f1:	e8 d4 00 00 00       	call   8011ca <_panic>

008010f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8010fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	ff 75 0c             	push   0xc(%ebp)
  801107:	e8 12 fd ff ff       	call   800e1e <sys_ipc_recv>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 2b                	js     80113e <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801113:	85 f6                	test   %esi,%esi
  801115:	74 0a                	je     801121 <ipc_recv+0x2b>
  801117:	a1 04 20 80 00       	mov    0x802004,%eax
  80111c:	8b 40 74             	mov    0x74(%eax),%eax
  80111f:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801121:	85 db                	test   %ebx,%ebx
  801123:	74 0a                	je     80112f <ipc_recv+0x39>
  801125:	a1 04 20 80 00       	mov    0x802004,%eax
  80112a:	8b 40 78             	mov    0x78(%eax),%eax
  80112d:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80112f:	a1 04 20 80 00       	mov    0x802004,%eax
  801134:	8b 40 70             	mov    0x70(%eax),%eax
}
  801137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801143:	eb f2                	jmp    801137 <ipc_recv+0x41>

00801145 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801151:	8b 75 0c             	mov    0xc(%ebp),%esi
  801154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801157:	ff 75 14             	push   0x14(%ebp)
  80115a:	53                   	push   %ebx
  80115b:	56                   	push   %esi
  80115c:	57                   	push   %edi
  80115d:	e8 99 fc ff ff       	call   800dfb <sys_ipc_try_send>
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	79 20                	jns    801189 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801169:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80116c:	75 07                	jne    801175 <ipc_send+0x30>
		sys_yield();
  80116e:	e8 dc fa ff ff       	call   800c4f <sys_yield>
  801173:	eb e2                	jmp    801157 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801175:	83 ec 04             	sub    $0x4,%esp
  801178:	68 10 19 80 00       	push   $0x801910
  80117d:	6a 2e                	push   $0x2e
  80117f:	68 20 19 80 00       	push   $0x801920
  801184:	e8 41 00 00 00       	call   8011ca <_panic>
	}
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80119c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80119f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8011a5:	8b 52 50             	mov    0x50(%edx),%edx
  8011a8:	39 ca                	cmp    %ecx,%edx
  8011aa:	74 11                	je     8011bd <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8011ac:	83 c0 01             	add    $0x1,%eax
  8011af:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011b4:	75 e6                	jne    80119c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	eb 0b                	jmp    8011c8 <ipc_find_env+0x37>
			return envs[i].env_id;
  8011bd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8011cf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011d2:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8011d8:	e8 53 fa ff ff       	call   800c30 <sys_getenvid>
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 0c             	push   0xc(%ebp)
  8011e3:	ff 75 08             	push   0x8(%ebp)
  8011e6:	56                   	push   %esi
  8011e7:	50                   	push   %eax
  8011e8:	68 2c 19 80 00       	push   $0x80192c
  8011ed:	e8 bb ef ff ff       	call   8001ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011f2:	83 c4 18             	add    $0x18,%esp
  8011f5:	53                   	push   %ebx
  8011f6:	ff 75 10             	push   0x10(%ebp)
  8011f9:	e8 5e ef ff ff       	call   80015c <vcprintf>
	cprintf("\n");
  8011fe:	c7 04 24 1e 19 80 00 	movl   $0x80191e,(%esp)
  801205:	e8 a3 ef ff ff       	call   8001ad <cprintf>
  80120a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80120d:	cc                   	int3   
  80120e:	eb fd                	jmp    80120d <_panic+0x43>

00801210 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801216:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80121d:	74 20                	je     80123f <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	68 7f 12 80 00       	push   $0x80127f
  80122f:	6a 00                	push   $0x0
  801231:	e8 83 fb ff ff       	call   800db9 <sys_env_set_pgfault_upcall>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 2e                	js     80126b <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	6a 07                	push   $0x7
  801244:	68 00 f0 bf ee       	push   $0xeebff000
  801249:	6a 00                	push   $0x0
  80124b:	e8 1e fa ff ff       	call   800c6e <sys_page_alloc>
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	79 c8                	jns    80121f <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 50 19 80 00       	push   $0x801950
  80125f:	6a 21                	push   $0x21
  801261:	68 b3 19 80 00       	push   $0x8019b3
  801266:	e8 5f ff ff ff       	call   8011ca <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 7c 19 80 00       	push   $0x80197c
  801273:	6a 27                	push   $0x27
  801275:	68 b3 19 80 00       	push   $0x8019b3
  80127a:	e8 4b ff ff ff       	call   8011ca <_panic>

0080127f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80127f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801280:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801285:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801287:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  80128a:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  80128e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  801293:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  801297:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  801299:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80129c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80129d:	83 c4 04             	add    $0x4,%esp
	popfl
  8012a0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8012a1:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8012a2:	c3                   	ret    
  8012a3:	66 90                	xchg   %ax,%ax
  8012a5:	66 90                	xchg   %ax,%ax
  8012a7:	66 90                	xchg   %ax,%ax
  8012a9:	66 90                	xchg   %ax,%ax
  8012ab:	66 90                	xchg   %ax,%ax
  8012ad:	66 90                	xchg   %ax,%ax
  8012af:	90                   	nop

008012b0 <__udivdi3>:
  8012b0:	f3 0f 1e fb          	endbr32 
  8012b4:	55                   	push   %ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 1c             	sub    $0x1c,%esp
  8012bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8012bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8012c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8012c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	75 19                	jne    8012e8 <__udivdi3+0x38>
  8012cf:	39 f3                	cmp    %esi,%ebx
  8012d1:	76 4d                	jbe    801320 <__udivdi3+0x70>
  8012d3:	31 ff                	xor    %edi,%edi
  8012d5:	89 e8                	mov    %ebp,%eax
  8012d7:	89 f2                	mov    %esi,%edx
  8012d9:	f7 f3                	div    %ebx
  8012db:	89 fa                	mov    %edi,%edx
  8012dd:	83 c4 1c             	add    $0x1c,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    
  8012e5:	8d 76 00             	lea    0x0(%esi),%esi
  8012e8:	39 f0                	cmp    %esi,%eax
  8012ea:	76 14                	jbe    801300 <__udivdi3+0x50>
  8012ec:	31 ff                	xor    %edi,%edi
  8012ee:	31 c0                	xor    %eax,%eax
  8012f0:	89 fa                	mov    %edi,%edx
  8012f2:	83 c4 1c             	add    $0x1c,%esp
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    
  8012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801300:	0f bd f8             	bsr    %eax,%edi
  801303:	83 f7 1f             	xor    $0x1f,%edi
  801306:	75 48                	jne    801350 <__udivdi3+0xa0>
  801308:	39 f0                	cmp    %esi,%eax
  80130a:	72 06                	jb     801312 <__udivdi3+0x62>
  80130c:	31 c0                	xor    %eax,%eax
  80130e:	39 eb                	cmp    %ebp,%ebx
  801310:	77 de                	ja     8012f0 <__udivdi3+0x40>
  801312:	b8 01 00 00 00       	mov    $0x1,%eax
  801317:	eb d7                	jmp    8012f0 <__udivdi3+0x40>
  801319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801320:	89 d9                	mov    %ebx,%ecx
  801322:	85 db                	test   %ebx,%ebx
  801324:	75 0b                	jne    801331 <__udivdi3+0x81>
  801326:	b8 01 00 00 00       	mov    $0x1,%eax
  80132b:	31 d2                	xor    %edx,%edx
  80132d:	f7 f3                	div    %ebx
  80132f:	89 c1                	mov    %eax,%ecx
  801331:	31 d2                	xor    %edx,%edx
  801333:	89 f0                	mov    %esi,%eax
  801335:	f7 f1                	div    %ecx
  801337:	89 c6                	mov    %eax,%esi
  801339:	89 e8                	mov    %ebp,%eax
  80133b:	89 f7                	mov    %esi,%edi
  80133d:	f7 f1                	div    %ecx
  80133f:	89 fa                	mov    %edi,%edx
  801341:	83 c4 1c             	add    $0x1c,%esp
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5f                   	pop    %edi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    
  801349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801350:	89 f9                	mov    %edi,%ecx
  801352:	ba 20 00 00 00       	mov    $0x20,%edx
  801357:	29 fa                	sub    %edi,%edx
  801359:	d3 e0                	shl    %cl,%eax
  80135b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80135f:	89 d1                	mov    %edx,%ecx
  801361:	89 d8                	mov    %ebx,%eax
  801363:	d3 e8                	shr    %cl,%eax
  801365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801369:	09 c1                	or     %eax,%ecx
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801371:	89 f9                	mov    %edi,%ecx
  801373:	d3 e3                	shl    %cl,%ebx
  801375:	89 d1                	mov    %edx,%ecx
  801377:	d3 e8                	shr    %cl,%eax
  801379:	89 f9                	mov    %edi,%ecx
  80137b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80137f:	89 eb                	mov    %ebp,%ebx
  801381:	d3 e6                	shl    %cl,%esi
  801383:	89 d1                	mov    %edx,%ecx
  801385:	d3 eb                	shr    %cl,%ebx
  801387:	09 f3                	or     %esi,%ebx
  801389:	89 c6                	mov    %eax,%esi
  80138b:	89 f2                	mov    %esi,%edx
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	f7 74 24 08          	divl   0x8(%esp)
  801393:	89 d6                	mov    %edx,%esi
  801395:	89 c3                	mov    %eax,%ebx
  801397:	f7 64 24 0c          	mull   0xc(%esp)
  80139b:	39 d6                	cmp    %edx,%esi
  80139d:	72 19                	jb     8013b8 <__udivdi3+0x108>
  80139f:	89 f9                	mov    %edi,%ecx
  8013a1:	d3 e5                	shl    %cl,%ebp
  8013a3:	39 c5                	cmp    %eax,%ebp
  8013a5:	73 04                	jae    8013ab <__udivdi3+0xfb>
  8013a7:	39 d6                	cmp    %edx,%esi
  8013a9:	74 0d                	je     8013b8 <__udivdi3+0x108>
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	31 ff                	xor    %edi,%edi
  8013af:	e9 3c ff ff ff       	jmp    8012f0 <__udivdi3+0x40>
  8013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013bb:	31 ff                	xor    %edi,%edi
  8013bd:	e9 2e ff ff ff       	jmp    8012f0 <__udivdi3+0x40>
  8013c2:	66 90                	xchg   %ax,%ax
  8013c4:	66 90                	xchg   %ax,%ax
  8013c6:	66 90                	xchg   %ax,%ax
  8013c8:	66 90                	xchg   %ax,%ax
  8013ca:	66 90                	xchg   %ax,%ax
  8013cc:	66 90                	xchg   %ax,%ax
  8013ce:	66 90                	xchg   %ax,%ax

008013d0 <__umoddi3>:
  8013d0:	f3 0f 1e fb          	endbr32 
  8013d4:	55                   	push   %ebp
  8013d5:	57                   	push   %edi
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 1c             	sub    $0x1c,%esp
  8013db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8013df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8013e3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8013e7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  8013eb:	89 f0                	mov    %esi,%eax
  8013ed:	89 da                	mov    %ebx,%edx
  8013ef:	85 ff                	test   %edi,%edi
  8013f1:	75 15                	jne    801408 <__umoddi3+0x38>
  8013f3:	39 dd                	cmp    %ebx,%ebp
  8013f5:	76 39                	jbe    801430 <__umoddi3+0x60>
  8013f7:	f7 f5                	div    %ebp
  8013f9:	89 d0                	mov    %edx,%eax
  8013fb:	31 d2                	xor    %edx,%edx
  8013fd:	83 c4 1c             	add    $0x1c,%esp
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    
  801405:	8d 76 00             	lea    0x0(%esi),%esi
  801408:	39 df                	cmp    %ebx,%edi
  80140a:	77 f1                	ja     8013fd <__umoddi3+0x2d>
  80140c:	0f bd cf             	bsr    %edi,%ecx
  80140f:	83 f1 1f             	xor    $0x1f,%ecx
  801412:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801416:	75 40                	jne    801458 <__umoddi3+0x88>
  801418:	39 df                	cmp    %ebx,%edi
  80141a:	72 04                	jb     801420 <__umoddi3+0x50>
  80141c:	39 f5                	cmp    %esi,%ebp
  80141e:	77 dd                	ja     8013fd <__umoddi3+0x2d>
  801420:	89 da                	mov    %ebx,%edx
  801422:	89 f0                	mov    %esi,%eax
  801424:	29 e8                	sub    %ebp,%eax
  801426:	19 fa                	sbb    %edi,%edx
  801428:	eb d3                	jmp    8013fd <__umoddi3+0x2d>
  80142a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801430:	89 e9                	mov    %ebp,%ecx
  801432:	85 ed                	test   %ebp,%ebp
  801434:	75 0b                	jne    801441 <__umoddi3+0x71>
  801436:	b8 01 00 00 00       	mov    $0x1,%eax
  80143b:	31 d2                	xor    %edx,%edx
  80143d:	f7 f5                	div    %ebp
  80143f:	89 c1                	mov    %eax,%ecx
  801441:	89 d8                	mov    %ebx,%eax
  801443:	31 d2                	xor    %edx,%edx
  801445:	f7 f1                	div    %ecx
  801447:	89 f0                	mov    %esi,%eax
  801449:	f7 f1                	div    %ecx
  80144b:	89 d0                	mov    %edx,%eax
  80144d:	31 d2                	xor    %edx,%edx
  80144f:	eb ac                	jmp    8013fd <__umoddi3+0x2d>
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	8b 44 24 04          	mov    0x4(%esp),%eax
  80145c:	ba 20 00 00 00       	mov    $0x20,%edx
  801461:	29 c2                	sub    %eax,%edx
  801463:	89 c1                	mov    %eax,%ecx
  801465:	89 e8                	mov    %ebp,%eax
  801467:	d3 e7                	shl    %cl,%edi
  801469:	89 d1                	mov    %edx,%ecx
  80146b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80146f:	d3 e8                	shr    %cl,%eax
  801471:	89 c1                	mov    %eax,%ecx
  801473:	8b 44 24 04          	mov    0x4(%esp),%eax
  801477:	09 f9                	or     %edi,%ecx
  801479:	89 df                	mov    %ebx,%edi
  80147b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80147f:	89 c1                	mov    %eax,%ecx
  801481:	d3 e5                	shl    %cl,%ebp
  801483:	89 d1                	mov    %edx,%ecx
  801485:	d3 ef                	shr    %cl,%edi
  801487:	89 c1                	mov    %eax,%ecx
  801489:	89 f0                	mov    %esi,%eax
  80148b:	d3 e3                	shl    %cl,%ebx
  80148d:	89 d1                	mov    %edx,%ecx
  80148f:	89 fa                	mov    %edi,%edx
  801491:	d3 e8                	shr    %cl,%eax
  801493:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801498:	09 d8                	or     %ebx,%eax
  80149a:	f7 74 24 08          	divl   0x8(%esp)
  80149e:	89 d3                	mov    %edx,%ebx
  8014a0:	d3 e6                	shl    %cl,%esi
  8014a2:	f7 e5                	mul    %ebp
  8014a4:	89 c7                	mov    %eax,%edi
  8014a6:	89 d1                	mov    %edx,%ecx
  8014a8:	39 d3                	cmp    %edx,%ebx
  8014aa:	72 06                	jb     8014b2 <__umoddi3+0xe2>
  8014ac:	75 0e                	jne    8014bc <__umoddi3+0xec>
  8014ae:	39 c6                	cmp    %eax,%esi
  8014b0:	73 0a                	jae    8014bc <__umoddi3+0xec>
  8014b2:	29 e8                	sub    %ebp,%eax
  8014b4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8014b8:	89 d1                	mov    %edx,%ecx
  8014ba:	89 c7                	mov    %eax,%edi
  8014bc:	89 f5                	mov    %esi,%ebp
  8014be:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014c2:	29 fd                	sub    %edi,%ebp
  8014c4:	19 cb                	sbb    %ecx,%ebx
  8014c6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8014cb:	89 d8                	mov    %ebx,%eax
  8014cd:	d3 e0                	shl    %cl,%eax
  8014cf:	89 f1                	mov    %esi,%ecx
  8014d1:	d3 ed                	shr    %cl,%ebp
  8014d3:	d3 eb                	shr    %cl,%ebx
  8014d5:	09 e8                	or     %ebp,%eax
  8014d7:	89 da                	mov    %ebx,%edx
  8014d9:	83 c4 1c             	add    $0x1c,%esp
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5f                   	pop    %edi
  8014df:	5d                   	pop    %ebp
  8014e0:	c3                   	ret    
