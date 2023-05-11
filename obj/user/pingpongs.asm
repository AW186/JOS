
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 de 10 00 00       	call   80111f <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 e1 10 00 00       	call   801139 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 02 0c 00 00       	call   800c73 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	push   -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 70 15 80 00       	push   $0x801570
  800080:	e8 6b 01 00 00       	call   8001f0 <cprintf>
		if (val == 10)
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	push   -0x1c(%ebp)
  8000a3:	e8 e0 10 00 00       	call   801188 <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c2:	e8 ac 0b 00 00       	call   800c73 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 40 15 80 00       	push   $0x801540
  8000d1:	e8 1a 01 00 00       	call   8001f0 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 95 0b 00 00       	call   800c73 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 5a 15 80 00       	push   $0x80155a
  8000e8:	e8 03 01 00 00       	call   8001f0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	push   -0x1c(%ebp)
  8000f6:	e8 8d 10 00 00       	call   801188 <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 60 0b 00 00       	call   800c73 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80014f:	6a 00                	push   $0x0
  800151:	e8 dc 0a 00 00       	call   800c32 <sys_env_destroy>
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 61 0a 00 00       	call   800bf5 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	push   0xc(%ebp)
  8001bf:	ff 75 08             	push   0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 14 01 00 00       	call   8002e7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 0d 0a 00 00       	call   800bf5 <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	push   0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 d1                	mov    %edx,%ecx
  800219:	89 c2                	mov    %eax,%edx
  80021b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800221:	8b 45 10             	mov    0x10(%ebp),%eax
  800224:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800227:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800231:	39 c2                	cmp    %eax,%edx
  800233:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800236:	72 3e                	jb     800276 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	push   0x18(%ebp)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	53                   	push   %ebx
  800242:	50                   	push   %eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	ff 75 e4             	push   -0x1c(%ebp)
  800249:	ff 75 e0             	push   -0x20(%ebp)
  80024c:	ff 75 dc             	push   -0x24(%ebp)
  80024f:	ff 75 d8             	push   -0x28(%ebp)
  800252:	e8 99 10 00 00       	call   8012f0 <__udivdi3>
  800257:	83 c4 18             	add    $0x18,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	89 f2                	mov    %esi,%edx
  80025e:	89 f8                	mov    %edi,%eax
  800260:	e8 9f ff ff ff       	call   800204 <printnum>
  800265:	83 c4 20             	add    $0x20,%esp
  800268:	eb 13                	jmp    80027d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	ff 75 18             	push   0x18(%ebp)
  800271:	ff d7                	call   *%edi
  800273:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800276:	83 eb 01             	sub    $0x1,%ebx
  800279:	85 db                	test   %ebx,%ebx
  80027b:	7f ed                	jg     80026a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	56                   	push   %esi
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	ff 75 e4             	push   -0x1c(%ebp)
  800287:	ff 75 e0             	push   -0x20(%ebp)
  80028a:	ff 75 dc             	push   -0x24(%ebp)
  80028d:	ff 75 d8             	push   -0x28(%ebp)
  800290:	e8 7b 11 00 00       	call   801410 <__umoddi3>
  800295:	83 c4 14             	add    $0x14,%esp
  800298:	0f be 80 a0 15 80 00 	movsbl 0x8015a0(%eax),%eax
  80029f:	50                   	push   %eax
  8002a0:	ff d7                	call   *%edi
}
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a8:	5b                   	pop    %ebx
  8002a9:	5e                   	pop    %esi
  8002aa:	5f                   	pop    %edi
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    

008002ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b7:	8b 10                	mov    (%eax),%edx
  8002b9:	3b 50 04             	cmp    0x4(%eax),%edx
  8002bc:	73 0a                	jae    8002c8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c1:	89 08                	mov    %ecx,(%eax)
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	88 02                	mov    %al,(%edx)
}
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    

008002ca <printfmt>:
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 10             	push   0x10(%ebp)
  8002d7:	ff 75 0c             	push   0xc(%ebp)
  8002da:	ff 75 08             	push   0x8(%ebp)
  8002dd:	e8 05 00 00 00       	call   8002e7 <vprintfmt>
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <vprintfmt>:
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	83 ec 3c             	sub    $0x3c,%esp
  8002f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f9:	eb 0a                	jmp    800305 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	53                   	push   %ebx
  8002ff:	50                   	push   %eax
  800300:	ff d6                	call   *%esi
  800302:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800305:	83 c7 01             	add    $0x1,%edi
  800308:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80030c:	83 f8 25             	cmp    $0x25,%eax
  80030f:	74 0c                	je     80031d <vprintfmt+0x36>
			if (ch == '\0')
  800311:	85 c0                	test   %eax,%eax
  800313:	75 e6                	jne    8002fb <vprintfmt+0x14>
}
  800315:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5f                   	pop    %edi
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    
		padc = ' ';
  80031d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800321:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800328:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80032f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800336:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033b:	8d 47 01             	lea    0x1(%edi),%eax
  80033e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800341:	0f b6 17             	movzbl (%edi),%edx
  800344:	8d 42 dd             	lea    -0x23(%edx),%eax
  800347:	3c 55                	cmp    $0x55,%al
  800349:	0f 87 a6 04 00 00    	ja     8007f5 <vprintfmt+0x50e>
  80034f:	0f b6 c0             	movzbl %al,%eax
  800352:	ff 24 85 e0 16 80 00 	jmp    *0x8016e0(,%eax,4)
  800359:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80035c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800360:	eb d9                	jmp    80033b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800365:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800369:	eb d0                	jmp    80033b <vprintfmt+0x54>
  80036b:	0f b6 d2             	movzbl %dl,%edx
  80036e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800371:	b8 00 00 00 00       	mov    $0x0,%eax
  800376:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800379:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80037c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800380:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800383:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800386:	83 f9 09             	cmp    $0x9,%ecx
  800389:	77 55                	ja     8003e0 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80038b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038e:	eb e9                	jmp    800379 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 40 04             	lea    0x4(%eax),%eax
  80039e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003a8:	79 91                	jns    80033b <vprintfmt+0x54>
				width = precision, precision = -1;
  8003aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003b7:	eb 82                	jmp    80033b <vprintfmt+0x54>
  8003b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003bc:	85 d2                	test   %edx,%edx
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	0f 49 c2             	cmovns %edx,%eax
  8003c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003cc:	e9 6a ff ff ff       	jmp    80033b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003d4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003db:	e9 5b ff ff ff       	jmp    80033b <vprintfmt+0x54>
  8003e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e6:	eb bc                	jmp    8003a4 <vprintfmt+0xbd>
			lflag++;
  8003e8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003ee:	e9 48 ff ff ff       	jmp    80033b <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	53                   	push   %ebx
  8003fd:	ff 30                	push   (%eax)
  8003ff:	ff d6                	call   *%esi
			break;
  800401:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800407:	e9 88 03 00 00       	jmp    800794 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80040c:	8b 45 14             	mov    0x14(%ebp),%eax
  80040f:	8d 78 04             	lea    0x4(%eax),%edi
  800412:	8b 10                	mov    (%eax),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	f7 d8                	neg    %eax
  800418:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041b:	83 f8 0f             	cmp    $0xf,%eax
  80041e:	7f 23                	jg     800443 <vprintfmt+0x15c>
  800420:	8b 14 85 40 18 80 00 	mov    0x801840(,%eax,4),%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	74 18                	je     800443 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80042b:	52                   	push   %edx
  80042c:	68 c1 15 80 00       	push   $0x8015c1
  800431:	53                   	push   %ebx
  800432:	56                   	push   %esi
  800433:	e8 92 fe ff ff       	call   8002ca <printfmt>
  800438:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80043e:	e9 51 03 00 00       	jmp    800794 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800443:	50                   	push   %eax
  800444:	68 b8 15 80 00       	push   $0x8015b8
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 7a fe ff ff       	call   8002ca <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800456:	e9 39 03 00 00       	jmp    800794 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	83 c0 04             	add    $0x4,%eax
  800461:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800469:	85 d2                	test   %edx,%edx
  80046b:	b8 b1 15 80 00       	mov    $0x8015b1,%eax
  800470:	0f 45 c2             	cmovne %edx,%eax
  800473:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800476:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80047a:	7e 06                	jle    800482 <vprintfmt+0x19b>
  80047c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800480:	75 0d                	jne    80048f <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800482:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800485:	89 c7                	mov    %eax,%edi
  800487:	03 45 d4             	add    -0x2c(%ebp),%eax
  80048a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80048d:	eb 55                	jmp    8004e4 <vprintfmt+0x1fd>
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 e0             	push   -0x20(%ebp)
  800495:	ff 75 cc             	push   -0x34(%ebp)
  800498:	e8 f5 03 00 00       	call   800892 <strnlen>
  80049d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004a0:	29 c2                	sub    %eax,%edx
  8004a2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004aa:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	eb 0f                	jmp    8004c2 <vprintfmt+0x1db>
					putch(padc, putdat);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	53                   	push   %ebx
  8004b7:	ff 75 d4             	push   -0x2c(%ebp)
  8004ba:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bc:	83 ef 01             	sub    $0x1,%edi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	85 ff                	test   %edi,%edi
  8004c4:	7f ed                	jg     8004b3 <vprintfmt+0x1cc>
  8004c6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004c9:	85 d2                	test   %edx,%edx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c2             	cmovns %edx,%eax
  8004d3:	29 c2                	sub    %eax,%edx
  8004d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004d8:	eb a8                	jmp    800482 <vprintfmt+0x19b>
					putch(ch, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	52                   	push   %edx
  8004df:	ff d6                	call   *%esi
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004e7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e9:	83 c7 01             	add    $0x1,%edi
  8004ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f0:	0f be d0             	movsbl %al,%edx
  8004f3:	85 d2                	test   %edx,%edx
  8004f5:	74 4b                	je     800542 <vprintfmt+0x25b>
  8004f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fb:	78 06                	js     800503 <vprintfmt+0x21c>
  8004fd:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800501:	78 1e                	js     800521 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	74 d1                	je     8004da <vprintfmt+0x1f3>
  800509:	0f be c0             	movsbl %al,%eax
  80050c:	83 e8 20             	sub    $0x20,%eax
  80050f:	83 f8 5e             	cmp    $0x5e,%eax
  800512:	76 c6                	jbe    8004da <vprintfmt+0x1f3>
					putch('?', putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	53                   	push   %ebx
  800518:	6a 3f                	push   $0x3f
  80051a:	ff d6                	call   *%esi
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	eb c3                	jmp    8004e4 <vprintfmt+0x1fd>
  800521:	89 cf                	mov    %ecx,%edi
  800523:	eb 0e                	jmp    800533 <vprintfmt+0x24c>
				putch(' ', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	6a 20                	push   $0x20
  80052b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80052d:	83 ef 01             	sub    $0x1,%edi
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	85 ff                	test   %edi,%edi
  800535:	7f ee                	jg     800525 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800537:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053a:	89 45 14             	mov    %eax,0x14(%ebp)
  80053d:	e9 52 02 00 00       	jmp    800794 <vprintfmt+0x4ad>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb ed                	jmp    800533 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	83 c0 04             	add    $0x4,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800554:	85 d2                	test   %edx,%edx
  800556:	b8 b1 15 80 00       	mov    $0x8015b1,%eax
  80055b:	0f 45 c2             	cmovne %edx,%eax
  80055e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800561:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800565:	7e 06                	jle    80056d <vprintfmt+0x286>
  800567:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80056b:	75 0d                	jne    80057a <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800570:	89 c7                	mov    %eax,%edi
  800572:	03 45 d4             	add    -0x2c(%ebp),%eax
  800575:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800578:	eb 55                	jmp    8005cf <vprintfmt+0x2e8>
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 e0             	push   -0x20(%ebp)
  800580:	ff 75 cc             	push   -0x34(%ebp)
  800583:	e8 0a 03 00 00       	call   800892 <strnlen>
  800588:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80058b:	29 c2                	sub    %eax,%edx
  80058d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800595:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80059c:	eb 0f                	jmp    8005ad <vprintfmt+0x2c6>
					putch(padc, putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	ff 75 d4             	push   -0x2c(%ebp)
  8005a5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a7:	83 ef 01             	sub    $0x1,%edi
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	85 ff                	test   %edi,%edi
  8005af:	7f ed                	jg     80059e <vprintfmt+0x2b7>
  8005b1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005b4:	85 d2                	test   %edx,%edx
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 49 c2             	cmovns %edx,%eax
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c3:	eb a8                	jmp    80056d <vprintfmt+0x286>
					putch(ch, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	52                   	push   %edx
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005d2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005d4:	83 c7 01             	add    $0x1,%edi
  8005d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	3c 3a                	cmp    $0x3a,%al
  8005e0:	74 4b                	je     80062d <vprintfmt+0x346>
  8005e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e6:	78 06                	js     8005ee <vprintfmt+0x307>
  8005e8:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005ec:	78 1e                	js     80060c <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f2:	74 d1                	je     8005c5 <vprintfmt+0x2de>
  8005f4:	0f be c0             	movsbl %al,%eax
  8005f7:	83 e8 20             	sub    $0x20,%eax
  8005fa:	83 f8 5e             	cmp    $0x5e,%eax
  8005fd:	76 c6                	jbe    8005c5 <vprintfmt+0x2de>
					putch('?', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 3f                	push   $0x3f
  800605:	ff d6                	call   *%esi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	eb c3                	jmp    8005cf <vprintfmt+0x2e8>
  80060c:	89 cf                	mov    %ecx,%edi
  80060e:	eb 0e                	jmp    80061e <vprintfmt+0x337>
				putch(' ', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 20                	push   $0x20
  800616:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800618:	83 ef 01             	sub    $0x1,%edi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	85 ff                	test   %edi,%edi
  800620:	7f ee                	jg     800610 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	e9 67 01 00 00       	jmp    800794 <vprintfmt+0x4ad>
  80062d:	89 cf                	mov    %ecx,%edi
  80062f:	eb ed                	jmp    80061e <vprintfmt+0x337>
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1b                	jg     800651 <vprintfmt+0x36a>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 63                	je     80069d <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800642:	99                   	cltd   
  800643:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 17                	jmp    800668 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800668:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80066e:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800673:	85 c9                	test   %ecx,%ecx
  800675:	0f 89 ff 00 00 00    	jns    80077a <vprintfmt+0x493>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800686:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800689:	f7 da                	neg    %edx
  80068b:	83 d1 00             	adc    $0x0,%ecx
  80068e:	f7 d9                	neg    %ecx
  800690:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800693:	bf 0a 00 00 00       	mov    $0xa,%edi
  800698:	e9 dd 00 00 00       	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a5:	99                   	cltd   
  8006a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb b4                	jmp    800668 <vprintfmt+0x381>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7f 1e                	jg     8006d7 <vprintfmt+0x3f0>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	74 32                	je     8006ef <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cd:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006d2:	e9 a3 00 00 00       	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006df:	8d 40 08             	lea    0x8(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e5:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006ea:	e9 8b 00 00 00       	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800704:	eb 74                	jmp    80077a <vprintfmt+0x493>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x43f>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800724:	eb 54                	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800734:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800739:	eb 3f                	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800750:	eb 28                	jmp    80077a <vprintfmt+0x493>
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 30                	push   $0x30
  800758:	ff d6                	call   *%esi
			putch('x', putdat);
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 78                	push   $0x78
  800760:	ff d6                	call   *%esi
			num = (unsigned long long)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	ff 75 d4             	push   -0x2c(%ebp)
  800785:	57                   	push   %edi
  800786:	51                   	push   %ecx
  800787:	52                   	push   %edx
  800788:	89 da                	mov    %ebx,%edx
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	e8 73 fa ff ff       	call   800204 <printnum>
			break;
  800791:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	e9 69 fb ff ff       	jmp    800305 <vprintfmt+0x1e>
	if (lflag >= 2)
  80079c:	83 f9 01             	cmp    $0x1,%ecx
  80079f:	7f 1b                	jg     8007bc <vprintfmt+0x4d5>
	else if (lflag)
  8007a1:	85 c9                	test   %ecx,%ecx
  8007a3:	74 2c                	je     8007d1 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8b 10                	mov    (%eax),%edx
  8007aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007af:	8d 40 04             	lea    0x4(%eax),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b5:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007ba:	eb be                	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 10                	mov    (%eax),%edx
  8007c1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c4:	8d 40 08             	lea    0x8(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ca:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007cf:	eb a9                	jmp    80077a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 10                	mov    (%eax),%edx
  8007d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007db:	8d 40 04             	lea    0x4(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e1:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007e6:	eb 92                	jmp    80077a <vprintfmt+0x493>
			putch(ch, putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	53                   	push   %ebx
  8007ec:	6a 25                	push   $0x25
  8007ee:	ff d6                	call   *%esi
			break;
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	eb 9f                	jmp    800794 <vprintfmt+0x4ad>
			putch('%', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 25                	push   $0x25
  8007fb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 f8                	mov    %edi,%eax
  800802:	eb 03                	jmp    800807 <vprintfmt+0x520>
  800804:	83 e8 01             	sub    $0x1,%eax
  800807:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080b:	75 f7                	jne    800804 <vprintfmt+0x51d>
  80080d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800810:	eb 82                	jmp    800794 <vprintfmt+0x4ad>

00800812 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 18             	sub    $0x18,%esp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800821:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800825:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 26                	je     800859 <vsnprintf+0x47>
  800833:	85 d2                	test   %edx,%edx
  800835:	7e 22                	jle    800859 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	ff 75 14             	push   0x14(%ebp)
  80083a:	ff 75 10             	push   0x10(%ebp)
  80083d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800840:	50                   	push   %eax
  800841:	68 ad 02 80 00       	push   $0x8002ad
  800846:	e8 9c fa ff ff       	call   8002e7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800854:	83 c4 10             	add    $0x10,%esp
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    
		return -E_INVAL;
  800859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085e:	eb f7                	jmp    800857 <vsnprintf+0x45>

00800860 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800866:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800869:	50                   	push   %eax
  80086a:	ff 75 10             	push   0x10(%ebp)
  80086d:	ff 75 0c             	push   0xc(%ebp)
  800870:	ff 75 08             	push   0x8(%ebp)
  800873:	e8 9a ff ff ff       	call   800812 <vsnprintf>
	va_end(ap);

	return rc;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
  800885:	eb 03                	jmp    80088a <strlen+0x10>
		n++;
  800887:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80088a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80088e:	75 f7                	jne    800887 <strlen+0xd>
	return n;
}
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800898:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a0:	eb 03                	jmp    8008a5 <strnlen+0x13>
		n++;
  8008a2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a5:	39 d0                	cmp    %edx,%eax
  8008a7:	74 08                	je     8008b1 <strnlen+0x1f>
  8008a9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008ad:	75 f3                	jne    8008a2 <strnlen+0x10>
  8008af:	89 c2                	mov    %eax,%edx
	return n;
}
  8008b1:	89 d0                	mov    %edx,%eax
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008c8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008cb:	83 c0 01             	add    $0x1,%eax
  8008ce:	84 d2                	test   %dl,%dl
  8008d0:	75 f2                	jne    8008c4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d2:	89 c8                	mov    %ecx,%eax
  8008d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	83 ec 10             	sub    $0x10,%esp
  8008e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e3:	53                   	push   %ebx
  8008e4:	e8 91 ff ff ff       	call   80087a <strlen>
  8008e9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ec:	ff 75 0c             	push   0xc(%ebp)
  8008ef:	01 d8                	add    %ebx,%eax
  8008f1:	50                   	push   %eax
  8008f2:	e8 be ff ff ff       	call   8008b5 <strcpy>
	return dst;
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	8b 75 08             	mov    0x8(%ebp),%esi
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
  800909:	89 f3                	mov    %esi,%ebx
  80090b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090e:	89 f0                	mov    %esi,%eax
  800910:	eb 0f                	jmp    800921 <strncpy+0x23>
		*dst++ = *src;
  800912:	83 c0 01             	add    $0x1,%eax
  800915:	0f b6 0a             	movzbl (%edx),%ecx
  800918:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091b:	80 f9 01             	cmp    $0x1,%cl
  80091e:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800921:	39 d8                	cmp    %ebx,%eax
  800923:	75 ed                	jne    800912 <strncpy+0x14>
	}
	return ret;
}
  800925:	89 f0                	mov    %esi,%eax
  800927:	5b                   	pop    %ebx
  800928:	5e                   	pop    %esi
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
  800930:	8b 75 08             	mov    0x8(%ebp),%esi
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800936:	8b 55 10             	mov    0x10(%ebp),%edx
  800939:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093b:	85 d2                	test   %edx,%edx
  80093d:	74 21                	je     800960 <strlcpy+0x35>
  80093f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800943:	89 f2                	mov    %esi,%edx
  800945:	eb 09                	jmp    800950 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800947:	83 c1 01             	add    $0x1,%ecx
  80094a:	83 c2 01             	add    $0x1,%edx
  80094d:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800950:	39 c2                	cmp    %eax,%edx
  800952:	74 09                	je     80095d <strlcpy+0x32>
  800954:	0f b6 19             	movzbl (%ecx),%ebx
  800957:	84 db                	test   %bl,%bl
  800959:	75 ec                	jne    800947 <strlcpy+0x1c>
  80095b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80095d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800960:	29 f0                	sub    %esi,%eax
}
  800962:	5b                   	pop    %ebx
  800963:	5e                   	pop    %esi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096f:	eb 06                	jmp    800977 <strcmp+0x11>
		p++, q++;
  800971:	83 c1 01             	add    $0x1,%ecx
  800974:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800977:	0f b6 01             	movzbl (%ecx),%eax
  80097a:	84 c0                	test   %al,%al
  80097c:	74 04                	je     800982 <strcmp+0x1c>
  80097e:	3a 02                	cmp    (%edx),%al
  800980:	74 ef                	je     800971 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800982:	0f b6 c0             	movzbl %al,%eax
  800985:	0f b6 12             	movzbl (%edx),%edx
  800988:	29 d0                	sub    %edx,%eax
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	89 c3                	mov    %eax,%ebx
  800998:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099b:	eb 06                	jmp    8009a3 <strncmp+0x17>
		n--, p++, q++;
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a3:	39 d8                	cmp    %ebx,%eax
  8009a5:	74 18                	je     8009bf <strncmp+0x33>
  8009a7:	0f b6 08             	movzbl (%eax),%ecx
  8009aa:	84 c9                	test   %cl,%cl
  8009ac:	74 04                	je     8009b2 <strncmp+0x26>
  8009ae:	3a 0a                	cmp    (%edx),%cl
  8009b0:	74 eb                	je     80099d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b2:	0f b6 00             	movzbl (%eax),%eax
  8009b5:	0f b6 12             	movzbl (%edx),%edx
  8009b8:	29 d0                	sub    %edx,%eax
}
  8009ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    
		return 0;
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	eb f4                	jmp    8009ba <strncmp+0x2e>

008009c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d0:	eb 03                	jmp    8009d5 <strchr+0xf>
  8009d2:	83 c0 01             	add    $0x1,%eax
  8009d5:	0f b6 10             	movzbl (%eax),%edx
  8009d8:	84 d2                	test   %dl,%dl
  8009da:	74 06                	je     8009e2 <strchr+0x1c>
		if (*s == c)
  8009dc:	38 ca                	cmp    %cl,%dl
  8009de:	75 f2                	jne    8009d2 <strchr+0xc>
  8009e0:	eb 05                	jmp    8009e7 <strchr+0x21>
			return (char *) s;
	return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 09                	je     800a03 <strfind+0x1a>
  8009fa:	84 d2                	test   %dl,%dl
  8009fc:	74 05                	je     800a03 <strfind+0x1a>
	for (; *s; s++)
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f0                	jmp    8009f3 <strfind+0xa>
			break;
	return (char *) s;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	57                   	push   %edi
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a11:	85 c9                	test   %ecx,%ecx
  800a13:	74 2f                	je     800a44 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a15:	89 f8                	mov    %edi,%eax
  800a17:	09 c8                	or     %ecx,%eax
  800a19:	a8 03                	test   $0x3,%al
  800a1b:	75 21                	jne    800a3e <memset+0x39>
		c &= 0xFF;
  800a1d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	c1 e0 08             	shl    $0x8,%eax
  800a26:	89 d3                	mov    %edx,%ebx
  800a28:	c1 e3 18             	shl    $0x18,%ebx
  800a2b:	89 d6                	mov    %edx,%esi
  800a2d:	c1 e6 10             	shl    $0x10,%esi
  800a30:	09 f3                	or     %esi,%ebx
  800a32:	09 da                	or     %ebx,%edx
  800a34:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a36:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a39:	fc                   	cld    
  800a3a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3c:	eb 06                	jmp    800a44 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	fc                   	cld    
  800a42:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a44:	89 f8                	mov    %edi,%eax
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5f                   	pop    %edi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a59:	39 c6                	cmp    %eax,%esi
  800a5b:	73 32                	jae    800a8f <memmove+0x44>
  800a5d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a60:	39 c2                	cmp    %eax,%edx
  800a62:	76 2b                	jbe    800a8f <memmove+0x44>
		s += n;
		d += n;
  800a64:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a67:	89 d6                	mov    %edx,%esi
  800a69:	09 fe                	or     %edi,%esi
  800a6b:	09 ce                	or     %ecx,%esi
  800a6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a73:	75 0e                	jne    800a83 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a75:	83 ef 04             	sub    $0x4,%edi
  800a78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7e:	fd                   	std    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 09                	jmp    800a8c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a83:	83 ef 01             	sub    $0x1,%edi
  800a86:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a89:	fd                   	std    
  800a8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8c:	fc                   	cld    
  800a8d:	eb 1a                	jmp    800aa9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	89 f2                	mov    %esi,%edx
  800a91:	09 c2                	or     %eax,%edx
  800a93:	09 ca                	or     %ecx,%edx
  800a95:	f6 c2 03             	test   $0x3,%dl
  800a98:	75 0a                	jne    800aa4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	fc                   	cld    
  800aa0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa2:	eb 05                	jmp    800aa9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	fc                   	cld    
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa9:	5e                   	pop    %esi
  800aaa:	5f                   	pop    %edi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab3:	ff 75 10             	push   0x10(%ebp)
  800ab6:	ff 75 0c             	push   0xc(%ebp)
  800ab9:	ff 75 08             	push   0x8(%ebp)
  800abc:	e8 8a ff ff ff       	call   800a4b <memmove>
}
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	56                   	push   %esi
  800ac7:	53                   	push   %ebx
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ace:	89 c6                	mov    %eax,%esi
  800ad0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad3:	eb 06                	jmp    800adb <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800adb:	39 f0                	cmp    %esi,%eax
  800add:	74 14                	je     800af3 <memcmp+0x30>
		if (*s1 != *s2)
  800adf:	0f b6 08             	movzbl (%eax),%ecx
  800ae2:	0f b6 1a             	movzbl (%edx),%ebx
  800ae5:	38 d9                	cmp    %bl,%cl
  800ae7:	74 ec                	je     800ad5 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800ae9:	0f b6 c1             	movzbl %cl,%eax
  800aec:	0f b6 db             	movzbl %bl,%ebx
  800aef:	29 d8                	sub    %ebx,%eax
  800af1:	eb 05                	jmp    800af8 <memcmp+0x35>
	}

	return 0;
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0a:	eb 03                	jmp    800b0f <memfind+0x13>
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	39 d0                	cmp    %edx,%eax
  800b11:	73 04                	jae    800b17 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b13:	38 08                	cmp    %cl,(%eax)
  800b15:	75 f5                	jne    800b0c <memfind+0x10>
			break;
	return (void *) s;
}
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
  800b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b25:	eb 03                	jmp    800b2a <strtol+0x11>
		s++;
  800b27:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b2a:	0f b6 02             	movzbl (%edx),%eax
  800b2d:	3c 20                	cmp    $0x20,%al
  800b2f:	74 f6                	je     800b27 <strtol+0xe>
  800b31:	3c 09                	cmp    $0x9,%al
  800b33:	74 f2                	je     800b27 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b35:	3c 2b                	cmp    $0x2b,%al
  800b37:	74 2a                	je     800b63 <strtol+0x4a>
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b3e:	3c 2d                	cmp    $0x2d,%al
  800b40:	74 2b                	je     800b6d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b42:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b48:	75 0f                	jne    800b59 <strtol+0x40>
  800b4a:	80 3a 30             	cmpb   $0x30,(%edx)
  800b4d:	74 28                	je     800b77 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4f:	85 db                	test   %ebx,%ebx
  800b51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b56:	0f 44 d8             	cmove  %eax,%ebx
  800b59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b61:	eb 46                	jmp    800ba9 <strtol+0x90>
		s++;
  800b63:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b66:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6b:	eb d5                	jmp    800b42 <strtol+0x29>
		s++, neg = 1;
  800b6d:	83 c2 01             	add    $0x1,%edx
  800b70:	bf 01 00 00 00       	mov    $0x1,%edi
  800b75:	eb cb                	jmp    800b42 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b77:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b7b:	74 0e                	je     800b8b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b7d:	85 db                	test   %ebx,%ebx
  800b7f:	75 d8                	jne    800b59 <strtol+0x40>
		s++, base = 8;
  800b81:	83 c2 01             	add    $0x1,%edx
  800b84:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b89:	eb ce                	jmp    800b59 <strtol+0x40>
		s += 2, base = 16;
  800b8b:	83 c2 02             	add    $0x2,%edx
  800b8e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b93:	eb c4                	jmp    800b59 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b95:	0f be c0             	movsbl %al,%eax
  800b98:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b9e:	7d 3a                	jge    800bda <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800ba7:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800ba9:	0f b6 02             	movzbl (%edx),%eax
  800bac:	8d 70 d0             	lea    -0x30(%eax),%esi
  800baf:	89 f3                	mov    %esi,%ebx
  800bb1:	80 fb 09             	cmp    $0x9,%bl
  800bb4:	76 df                	jbe    800b95 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bb6:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bb9:	89 f3                	mov    %esi,%ebx
  800bbb:	80 fb 19             	cmp    $0x19,%bl
  800bbe:	77 08                	ja     800bc8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc0:	0f be c0             	movsbl %al,%eax
  800bc3:	83 e8 57             	sub    $0x57,%eax
  800bc6:	eb d3                	jmp    800b9b <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bc8:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bcb:	89 f3                	mov    %esi,%ebx
  800bcd:	80 fb 19             	cmp    $0x19,%bl
  800bd0:	77 08                	ja     800bda <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd2:	0f be c0             	movsbl %al,%eax
  800bd5:	83 e8 37             	sub    $0x37,%eax
  800bd8:	eb c1                	jmp    800b9b <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bde:	74 05                	je     800be5 <strtol+0xcc>
		*endptr = (char *) s;
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800be5:	89 c8                	mov    %ecx,%eax
  800be7:	f7 d8                	neg    %eax
  800be9:	85 ff                	test   %edi,%edi
  800beb:	0f 45 c8             	cmovne %eax,%ecx
}
  800bee:	89 c8                	mov    %ecx,%eax
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	89 c3                	mov    %eax,%ebx
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	89 c6                	mov    %eax,%esi
  800c0c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c23:	89 d1                	mov    %edx,%ecx
  800c25:	89 d3                	mov    %edx,%ebx
  800c27:	89 d7                	mov    %edx,%edi
  800c29:	89 d6                	mov    %edx,%esi
  800c2b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	89 cb                	mov    %ecx,%ebx
  800c4a:	89 cf                	mov    %ecx,%edi
  800c4c:	89 ce                	mov    %ecx,%esi
  800c4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c50:	85 c0                	test   %eax,%eax
  800c52:	7f 08                	jg     800c5c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	6a 03                	push   $0x3
  800c62:	68 9f 18 80 00       	push   $0x80189f
  800c67:	6a 23                	push   $0x23
  800c69:	68 bc 18 80 00       	push   $0x8018bc
  800c6e:	e8 9a 05 00 00       	call   80120d <_panic>

00800c73 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c79:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c83:	89 d1                	mov    %edx,%ecx
  800c85:	89 d3                	mov    %edx,%ebx
  800c87:	89 d7                	mov    %edx,%edi
  800c89:	89 d6                	mov    %edx,%esi
  800c8b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <sys_yield>:

void
sys_yield(void)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c98:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca2:	89 d1                	mov    %edx,%ecx
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	89 d7                	mov    %edx,%edi
  800ca8:	89 d6                	mov    %edx,%esi
  800caa:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	be 00 00 00 00       	mov    $0x0,%esi
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccd:	89 f7                	mov    %esi,%edi
  800ccf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7f 08                	jg     800cdd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800ce1:	6a 04                	push   $0x4
  800ce3:	68 9f 18 80 00       	push   $0x80189f
  800ce8:	6a 23                	push   $0x23
  800cea:	68 bc 18 80 00       	push   $0x8018bc
  800cef:	e8 19 05 00 00       	call   80120d <_panic>

00800cf4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d03:	b8 05 00 00 00       	mov    $0x5,%eax
  800d08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d23:	6a 05                	push   $0x5
  800d25:	68 9f 18 80 00       	push   $0x80189f
  800d2a:	6a 23                	push   $0x23
  800d2c:	68 bc 18 80 00       	push   $0x8018bc
  800d31:	e8 d7 04 00 00       	call   80120d <_panic>

00800d36 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d4a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	89 de                	mov    %ebx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d65:	6a 06                	push   $0x6
  800d67:	68 9f 18 80 00       	push   $0x80189f
  800d6c:	6a 23                	push   $0x23
  800d6e:	68 bc 18 80 00       	push   $0x8018bc
  800d73:	e8 95 04 00 00       	call   80120d <_panic>

00800d78 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800da7:	6a 08                	push   $0x8
  800da9:	68 9f 18 80 00       	push   $0x80189f
  800dae:	6a 23                	push   $0x23
  800db0:	68 bc 18 80 00       	push   $0x8018bc
  800db5:	e8 53 04 00 00       	call   80120d <_panic>

00800dba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800dce:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800de9:	6a 09                	push   $0x9
  800deb:	68 9f 18 80 00       	push   $0x80189f
  800df0:	6a 23                	push   $0x23
  800df2:	68 bc 18 80 00       	push   $0x8018bc
  800df7:	e8 11 04 00 00       	call   80120d <_panic>

00800dfc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 9f 18 80 00       	push   $0x80189f
  800e32:	6a 23                	push   $0x23
  800e34:	68 bc 18 80 00       	push   $0x8018bc
  800e39:	e8 cf 03 00 00       	call   80120d <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4f:	be 00 00 00 00       	mov    $0x0,%esi
  800e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e57:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e77:	89 cb                	mov    %ecx,%ebx
  800e79:	89 cf                	mov    %ecx,%edi
  800e7b:	89 ce                	mov    %ecx,%esi
  800e7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7f 08                	jg     800e8b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	83 ec 0c             	sub    $0xc,%esp
  800e8e:	50                   	push   %eax
  800e8f:	6a 0d                	push   $0xd
  800e91:	68 9f 18 80 00       	push   $0x80189f
  800e96:	6a 23                	push   $0x23
  800e98:	68 bc 18 80 00       	push   $0x8018bc
  800e9d:	e8 6b 03 00 00       	call   80120d <_panic>

00800ea2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 04             	sub    $0x4,%esp
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eac:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800eae:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800eb2:	0f 84 99 00 00 00    	je     800f51 <pgfault+0xaf>
  800eb8:	89 d8                	mov    %ebx,%eax
  800eba:	c1 e8 16             	shr    $0x16,%eax
  800ebd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ec4:	a8 01                	test   $0x1,%al
  800ec6:	0f 84 85 00 00 00    	je     800f51 <pgfault+0xaf>
  800ecc:	89 d8                	mov    %ebx,%eax
  800ece:	c1 e8 0c             	shr    $0xc,%eax
  800ed1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ed8:	f6 c6 08             	test   $0x8,%dh
  800edb:	74 74                	je     800f51 <pgfault+0xaf>
  800edd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ee4:	a8 01                	test   $0x1,%al
  800ee6:	74 69                	je     800f51 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800ee8:	83 ec 04             	sub    $0x4,%esp
  800eeb:	6a 07                	push   $0x7
  800eed:	68 00 f0 7f 00       	push   $0x7ff000
  800ef2:	6a 00                	push   $0x0
  800ef4:	e8 b8 fd ff ff       	call   800cb1 <sys_page_alloc>
  800ef9:	83 c4 10             	add    $0x10,%esp
  800efc:	85 c0                	test   %eax,%eax
  800efe:	78 65                	js     800f65 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f06:	83 ec 04             	sub    $0x4,%esp
  800f09:	68 00 10 00 00       	push   $0x1000
  800f0e:	53                   	push   %ebx
  800f0f:	68 00 f0 7f 00       	push   $0x7ff000
  800f14:	e8 94 fb ff ff       	call   800aad <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800f19:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f20:	53                   	push   %ebx
  800f21:	6a 00                	push   $0x0
  800f23:	68 00 f0 7f 00       	push   $0x7ff000
  800f28:	6a 00                	push   $0x0
  800f2a:	e8 c5 fd ff ff       	call   800cf4 <sys_page_map>
  800f2f:	83 c4 20             	add    $0x20,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 43                	js     800f79 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	68 00 f0 7f 00       	push   $0x7ff000
  800f3e:	6a 00                	push   $0x0
  800f40:	e8 f1 fd ff ff       	call   800d36 <sys_page_unmap>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	78 41                	js     800f8d <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    
		panic("invalid permision\n");
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	68 ca 18 80 00       	push   $0x8018ca
  800f59:	6a 1f                	push   $0x1f
  800f5b:	68 dd 18 80 00       	push   $0x8018dd
  800f60:	e8 a8 02 00 00       	call   80120d <_panic>
		panic("Unable to alloc page\n");
  800f65:	83 ec 04             	sub    $0x4,%esp
  800f68:	68 e8 18 80 00       	push   $0x8018e8
  800f6d:	6a 28                	push   $0x28
  800f6f:	68 dd 18 80 00       	push   $0x8018dd
  800f74:	e8 94 02 00 00       	call   80120d <_panic>
		panic("Unable to map\n");
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	68 fe 18 80 00       	push   $0x8018fe
  800f81:	6a 2b                	push   $0x2b
  800f83:	68 dd 18 80 00       	push   $0x8018dd
  800f88:	e8 80 02 00 00       	call   80120d <_panic>
		panic("Unable to unmap\n");
  800f8d:	83 ec 04             	sub    $0x4,%esp
  800f90:	68 0d 19 80 00       	push   $0x80190d
  800f95:	6a 2d                	push   $0x2d
  800f97:	68 dd 18 80 00       	push   $0x8018dd
  800f9c:	e8 6c 02 00 00       	call   80120d <_panic>

00800fa1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800faa:	68 a2 0e 80 00       	push   $0x800ea2
  800faf:	e8 9f 02 00 00       	call   801253 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fb4:	b8 07 00 00 00       	mov    $0x7,%eax
  800fb9:	cd 30                	int    $0x30
  800fbb:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	78 23                	js     800fe7 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fc4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  800fc9:	75 6d                	jne    801038 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fcb:	e8 a3 fc ff ff       	call   800c73 <sys_getenvid>
  800fd0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fd5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fd8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fdd:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  800fe2:	e9 02 01 00 00       	jmp    8010e9 <fork+0x148>
		panic("sys_exofork: %e", envid);
  800fe7:	50                   	push   %eax
  800fe8:	68 1e 19 80 00       	push   $0x80191e
  800fed:	6a 6d                	push   $0x6d
  800fef:	68 dd 18 80 00       	push   $0x8018dd
  800ff4:	e8 14 02 00 00       	call   80120d <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  800ff9:	c1 e0 0c             	shl    $0xc,%eax
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801005:	52                   	push   %edx
  801006:	50                   	push   %eax
  801007:	56                   	push   %esi
  801008:	50                   	push   %eax
  801009:	6a 00                	push   $0x0
  80100b:	e8 e4 fc ff ff       	call   800cf4 <sys_page_map>
  801010:	83 c4 20             	add    $0x20,%esp
  801013:	eb 15                	jmp    80102a <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  801015:	c1 e0 0c             	shl    $0xc,%eax
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	6a 05                	push   $0x5
  80101d:	50                   	push   %eax
  80101e:	56                   	push   %esi
  80101f:	50                   	push   %eax
  801020:	6a 00                	push   $0x0
  801022:	e8 cd fc ff ff       	call   800cf4 <sys_page_map>
  801027:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80102a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801030:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801036:	74 7a                	je     8010b2 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  801038:	89 d8                	mov    %ebx,%eax
  80103a:	c1 e8 16             	shr    $0x16,%eax
  80103d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801044:	a8 01                	test   $0x1,%al
  801046:	74 e2                	je     80102a <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801048:	89 d8                	mov    %ebx,%eax
  80104a:	c1 e8 0c             	shr    $0xc,%eax
  80104d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801054:	f6 c2 01             	test   $0x1,%dl
  801057:	74 d1                	je     80102a <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801059:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801060:	f6 c2 04             	test   $0x4,%dl
  801063:	74 c5                	je     80102a <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801065:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80106c:	f6 c6 04             	test   $0x4,%dh
  80106f:	75 88                	jne    800ff9 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801071:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801077:	74 9c                	je     801015 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801079:	c1 e0 0c             	shl    $0xc,%eax
  80107c:	89 c7                	mov    %eax,%edi
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	68 05 08 00 00       	push   $0x805
  801086:	50                   	push   %eax
  801087:	56                   	push   %esi
  801088:	50                   	push   %eax
  801089:	6a 00                	push   $0x0
  80108b:	e8 64 fc ff ff       	call   800cf4 <sys_page_map>
  801090:	83 c4 20             	add    $0x20,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 93                	js     80102a <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	68 05 08 00 00       	push   $0x805
  80109f:	57                   	push   %edi
  8010a0:	6a 00                	push   $0x0
  8010a2:	57                   	push   %edi
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 4a fc ff ff       	call   800cf4 <sys_page_map>
  8010aa:	83 c4 20             	add    $0x20,%esp
  8010ad:	e9 78 ff ff ff       	jmp    80102a <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	6a 07                	push   $0x7
  8010b7:	68 00 f0 bf ee       	push   $0xeebff000
  8010bc:	56                   	push   %esi
  8010bd:	e8 ef fb ff ff       	call   800cb1 <sys_page_alloc>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 2a                	js     8010f3 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	68 c2 12 80 00       	push   $0x8012c2
  8010d1:	56                   	push   %esi
  8010d2:	e8 25 fd ff ff       	call   800dfc <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010d7:	83 c4 08             	add    $0x8,%esp
  8010da:	6a 02                	push   $0x2
  8010dc:	56                   	push   %esi
  8010dd:	e8 96 fc ff ff       	call   800d78 <sys_env_set_status>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 21                	js     80110a <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010e9:	89 f0                	mov    %esi,%eax
  8010eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    
		panic("failed to alloc page");
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	68 2e 19 80 00       	push   $0x80192e
  8010fb:	68 82 00 00 00       	push   $0x82
  801100:	68 dd 18 80 00       	push   $0x8018dd
  801105:	e8 03 01 00 00       	call   80120d <_panic>
		panic("sys_env_set_status: %e", r);
  80110a:	50                   	push   %eax
  80110b:	68 43 19 80 00       	push   $0x801943
  801110:	68 89 00 00 00       	push   $0x89
  801115:	68 dd 18 80 00       	push   $0x8018dd
  80111a:	e8 ee 00 00 00       	call   80120d <_panic>

0080111f <sfork>:

// Challenge!
int
sfork(void)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801125:	68 5a 19 80 00       	push   $0x80195a
  80112a:	68 92 00 00 00       	push   $0x92
  80112f:	68 dd 18 80 00       	push   $0x8018dd
  801134:	e8 d4 00 00 00       	call   80120d <_panic>

00801139 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	56                   	push   %esi
  80113d:	53                   	push   %ebx
  80113e:	8b 75 08             	mov    0x8(%ebp),%esi
  801141:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	ff 75 0c             	push   0xc(%ebp)
  80114a:	e8 12 fd ff ff       	call   800e61 <sys_ipc_recv>
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	78 2b                	js     801181 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801156:	85 f6                	test   %esi,%esi
  801158:	74 0a                	je     801164 <ipc_recv+0x2b>
  80115a:	a1 08 20 80 00       	mov    0x802008,%eax
  80115f:	8b 40 74             	mov    0x74(%eax),%eax
  801162:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801164:	85 db                	test   %ebx,%ebx
  801166:	74 0a                	je     801172 <ipc_recv+0x39>
  801168:	a1 08 20 80 00       	mov    0x802008,%eax
  80116d:	8b 40 78             	mov    0x78(%eax),%eax
  801170:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801172:	a1 08 20 80 00       	mov    0x802008,%eax
  801177:	8b 40 70             	mov    0x70(%eax),%eax
}
  80117a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117d:	5b                   	pop    %ebx
  80117e:	5e                   	pop    %esi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801181:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801186:	eb f2                	jmp    80117a <ipc_recv+0x41>

00801188 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	8b 7d 08             	mov    0x8(%ebp),%edi
  801194:	8b 75 0c             	mov    0xc(%ebp),%esi
  801197:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80119a:	ff 75 14             	push   0x14(%ebp)
  80119d:	53                   	push   %ebx
  80119e:	56                   	push   %esi
  80119f:	57                   	push   %edi
  8011a0:	e8 99 fc ff ff       	call   800e3e <sys_ipc_try_send>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	79 20                	jns    8011cc <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8011ac:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011af:	75 07                	jne    8011b8 <ipc_send+0x30>
		sys_yield();
  8011b1:	e8 dc fa ff ff       	call   800c92 <sys_yield>
  8011b6:	eb e2                	jmp    80119a <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	68 70 19 80 00       	push   $0x801970
  8011c0:	6a 2e                	push   $0x2e
  8011c2:	68 80 19 80 00       	push   $0x801980
  8011c7:	e8 41 00 00 00       	call   80120d <_panic>
	}
}
  8011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5e                   	pop    %esi
  8011d1:	5f                   	pop    %edi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8011df:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8011e2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8011e8:	8b 52 50             	mov    0x50(%edx),%edx
  8011eb:	39 ca                	cmp    %ecx,%edx
  8011ed:	74 11                	je     801200 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8011ef:	83 c0 01             	add    $0x1,%eax
  8011f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011f7:	75 e6                	jne    8011df <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	eb 0b                	jmp    80120b <ipc_find_env+0x37>
			return envs[i].env_id;
  801200:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801203:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801208:	8b 40 48             	mov    0x48(%eax),%eax
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801212:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801215:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80121b:	e8 53 fa ff ff       	call   800c73 <sys_getenvid>
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	ff 75 0c             	push   0xc(%ebp)
  801226:	ff 75 08             	push   0x8(%ebp)
  801229:	56                   	push   %esi
  80122a:	50                   	push   %eax
  80122b:	68 8c 19 80 00       	push   $0x80198c
  801230:	e8 bb ef ff ff       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801235:	83 c4 18             	add    $0x18,%esp
  801238:	53                   	push   %ebx
  801239:	ff 75 10             	push   0x10(%ebp)
  80123c:	e8 5e ef ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  801241:	c7 04 24 7e 19 80 00 	movl   $0x80197e,(%esp)
  801248:	e8 a3 ef ff ff       	call   8001f0 <cprintf>
  80124d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801250:	cc                   	int3   
  801251:	eb fd                	jmp    801250 <_panic+0x43>

00801253 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801259:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  801260:	74 20                	je     801282 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	a3 0c 20 80 00       	mov    %eax,0x80200c
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	68 c2 12 80 00       	push   $0x8012c2
  801272:	6a 00                	push   $0x0
  801274:	e8 83 fb ff ff       	call   800dfc <sys_env_set_pgfault_upcall>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 2e                	js     8012ae <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801280:	c9                   	leave  
  801281:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	6a 07                	push   $0x7
  801287:	68 00 f0 bf ee       	push   $0xeebff000
  80128c:	6a 00                	push   $0x0
  80128e:	e8 1e fa ff ff       	call   800cb1 <sys_page_alloc>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	79 c8                	jns    801262 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80129a:	83 ec 04             	sub    $0x4,%esp
  80129d:	68 b0 19 80 00       	push   $0x8019b0
  8012a2:	6a 21                	push   $0x21
  8012a4:	68 13 1a 80 00       	push   $0x801a13
  8012a9:	e8 5f ff ff ff       	call   80120d <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	68 dc 19 80 00       	push   $0x8019dc
  8012b6:	6a 27                	push   $0x27
  8012b8:	68 13 1a 80 00       	push   $0x801a13
  8012bd:	e8 4b ff ff ff       	call   80120d <_panic>

008012c2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012c2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012c3:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8012c8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8012ca:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8012cd:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8012d1:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8012d6:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8012da:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8012dc:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8012df:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8012e0:	83 c4 04             	add    $0x4,%esp
	popfl
  8012e3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8012e4:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8012e5:	c3                   	ret    
  8012e6:	66 90                	xchg   %ax,%ax
  8012e8:	66 90                	xchg   %ax,%ax
  8012ea:	66 90                	xchg   %ax,%ax
  8012ec:	66 90                	xchg   %ax,%ax
  8012ee:	66 90                	xchg   %ax,%ax

008012f0 <__udivdi3>:
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 1c             	sub    $0x1c,%esp
  8012fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8012ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801303:	8b 74 24 34          	mov    0x34(%esp),%esi
  801307:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80130b:	85 c0                	test   %eax,%eax
  80130d:	75 19                	jne    801328 <__udivdi3+0x38>
  80130f:	39 f3                	cmp    %esi,%ebx
  801311:	76 4d                	jbe    801360 <__udivdi3+0x70>
  801313:	31 ff                	xor    %edi,%edi
  801315:	89 e8                	mov    %ebp,%eax
  801317:	89 f2                	mov    %esi,%edx
  801319:	f7 f3                	div    %ebx
  80131b:	89 fa                	mov    %edi,%edx
  80131d:	83 c4 1c             	add    $0x1c,%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    
  801325:	8d 76 00             	lea    0x0(%esi),%esi
  801328:	39 f0                	cmp    %esi,%eax
  80132a:	76 14                	jbe    801340 <__udivdi3+0x50>
  80132c:	31 ff                	xor    %edi,%edi
  80132e:	31 c0                	xor    %eax,%eax
  801330:	89 fa                	mov    %edi,%edx
  801332:	83 c4 1c             	add    $0x1c,%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    
  80133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801340:	0f bd f8             	bsr    %eax,%edi
  801343:	83 f7 1f             	xor    $0x1f,%edi
  801346:	75 48                	jne    801390 <__udivdi3+0xa0>
  801348:	39 f0                	cmp    %esi,%eax
  80134a:	72 06                	jb     801352 <__udivdi3+0x62>
  80134c:	31 c0                	xor    %eax,%eax
  80134e:	39 eb                	cmp    %ebp,%ebx
  801350:	77 de                	ja     801330 <__udivdi3+0x40>
  801352:	b8 01 00 00 00       	mov    $0x1,%eax
  801357:	eb d7                	jmp    801330 <__udivdi3+0x40>
  801359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801360:	89 d9                	mov    %ebx,%ecx
  801362:	85 db                	test   %ebx,%ebx
  801364:	75 0b                	jne    801371 <__udivdi3+0x81>
  801366:	b8 01 00 00 00       	mov    $0x1,%eax
  80136b:	31 d2                	xor    %edx,%edx
  80136d:	f7 f3                	div    %ebx
  80136f:	89 c1                	mov    %eax,%ecx
  801371:	31 d2                	xor    %edx,%edx
  801373:	89 f0                	mov    %esi,%eax
  801375:	f7 f1                	div    %ecx
  801377:	89 c6                	mov    %eax,%esi
  801379:	89 e8                	mov    %ebp,%eax
  80137b:	89 f7                	mov    %esi,%edi
  80137d:	f7 f1                	div    %ecx
  80137f:	89 fa                	mov    %edi,%edx
  801381:	83 c4 1c             	add    $0x1c,%esp
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    
  801389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801390:	89 f9                	mov    %edi,%ecx
  801392:	ba 20 00 00 00       	mov    $0x20,%edx
  801397:	29 fa                	sub    %edi,%edx
  801399:	d3 e0                	shl    %cl,%eax
  80139b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80139f:	89 d1                	mov    %edx,%ecx
  8013a1:	89 d8                	mov    %ebx,%eax
  8013a3:	d3 e8                	shr    %cl,%eax
  8013a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8013a9:	09 c1                	or     %eax,%ecx
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b1:	89 f9                	mov    %edi,%ecx
  8013b3:	d3 e3                	shl    %cl,%ebx
  8013b5:	89 d1                	mov    %edx,%ecx
  8013b7:	d3 e8                	shr    %cl,%eax
  8013b9:	89 f9                	mov    %edi,%ecx
  8013bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013bf:	89 eb                	mov    %ebp,%ebx
  8013c1:	d3 e6                	shl    %cl,%esi
  8013c3:	89 d1                	mov    %edx,%ecx
  8013c5:	d3 eb                	shr    %cl,%ebx
  8013c7:	09 f3                	or     %esi,%ebx
  8013c9:	89 c6                	mov    %eax,%esi
  8013cb:	89 f2                	mov    %esi,%edx
  8013cd:	89 d8                	mov    %ebx,%eax
  8013cf:	f7 74 24 08          	divl   0x8(%esp)
  8013d3:	89 d6                	mov    %edx,%esi
  8013d5:	89 c3                	mov    %eax,%ebx
  8013d7:	f7 64 24 0c          	mull   0xc(%esp)
  8013db:	39 d6                	cmp    %edx,%esi
  8013dd:	72 19                	jb     8013f8 <__udivdi3+0x108>
  8013df:	89 f9                	mov    %edi,%ecx
  8013e1:	d3 e5                	shl    %cl,%ebp
  8013e3:	39 c5                	cmp    %eax,%ebp
  8013e5:	73 04                	jae    8013eb <__udivdi3+0xfb>
  8013e7:	39 d6                	cmp    %edx,%esi
  8013e9:	74 0d                	je     8013f8 <__udivdi3+0x108>
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	31 ff                	xor    %edi,%edi
  8013ef:	e9 3c ff ff ff       	jmp    801330 <__udivdi3+0x40>
  8013f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013fb:	31 ff                	xor    %edi,%edi
  8013fd:	e9 2e ff ff ff       	jmp    801330 <__udivdi3+0x40>
  801402:	66 90                	xchg   %ax,%ax
  801404:	66 90                	xchg   %ax,%ax
  801406:	66 90                	xchg   %ax,%ax
  801408:	66 90                	xchg   %ax,%ax
  80140a:	66 90                	xchg   %ax,%ax
  80140c:	66 90                	xchg   %ax,%ax
  80140e:	66 90                	xchg   %ax,%ax

00801410 <__umoddi3>:
  801410:	f3 0f 1e fb          	endbr32 
  801414:	55                   	push   %ebp
  801415:	57                   	push   %edi
  801416:	56                   	push   %esi
  801417:	53                   	push   %ebx
  801418:	83 ec 1c             	sub    $0x1c,%esp
  80141b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80141f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801423:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801427:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	89 da                	mov    %ebx,%edx
  80142f:	85 ff                	test   %edi,%edi
  801431:	75 15                	jne    801448 <__umoddi3+0x38>
  801433:	39 dd                	cmp    %ebx,%ebp
  801435:	76 39                	jbe    801470 <__umoddi3+0x60>
  801437:	f7 f5                	div    %ebp
  801439:	89 d0                	mov    %edx,%eax
  80143b:	31 d2                	xor    %edx,%edx
  80143d:	83 c4 1c             	add    $0x1c,%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    
  801445:	8d 76 00             	lea    0x0(%esi),%esi
  801448:	39 df                	cmp    %ebx,%edi
  80144a:	77 f1                	ja     80143d <__umoddi3+0x2d>
  80144c:	0f bd cf             	bsr    %edi,%ecx
  80144f:	83 f1 1f             	xor    $0x1f,%ecx
  801452:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801456:	75 40                	jne    801498 <__umoddi3+0x88>
  801458:	39 df                	cmp    %ebx,%edi
  80145a:	72 04                	jb     801460 <__umoddi3+0x50>
  80145c:	39 f5                	cmp    %esi,%ebp
  80145e:	77 dd                	ja     80143d <__umoddi3+0x2d>
  801460:	89 da                	mov    %ebx,%edx
  801462:	89 f0                	mov    %esi,%eax
  801464:	29 e8                	sub    %ebp,%eax
  801466:	19 fa                	sbb    %edi,%edx
  801468:	eb d3                	jmp    80143d <__umoddi3+0x2d>
  80146a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801470:	89 e9                	mov    %ebp,%ecx
  801472:	85 ed                	test   %ebp,%ebp
  801474:	75 0b                	jne    801481 <__umoddi3+0x71>
  801476:	b8 01 00 00 00       	mov    $0x1,%eax
  80147b:	31 d2                	xor    %edx,%edx
  80147d:	f7 f5                	div    %ebp
  80147f:	89 c1                	mov    %eax,%ecx
  801481:	89 d8                	mov    %ebx,%eax
  801483:	31 d2                	xor    %edx,%edx
  801485:	f7 f1                	div    %ecx
  801487:	89 f0                	mov    %esi,%eax
  801489:	f7 f1                	div    %ecx
  80148b:	89 d0                	mov    %edx,%eax
  80148d:	31 d2                	xor    %edx,%edx
  80148f:	eb ac                	jmp    80143d <__umoddi3+0x2d>
  801491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801498:	8b 44 24 04          	mov    0x4(%esp),%eax
  80149c:	ba 20 00 00 00       	mov    $0x20,%edx
  8014a1:	29 c2                	sub    %eax,%edx
  8014a3:	89 c1                	mov    %eax,%ecx
  8014a5:	89 e8                	mov    %ebp,%eax
  8014a7:	d3 e7                	shl    %cl,%edi
  8014a9:	89 d1                	mov    %edx,%ecx
  8014ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014af:	d3 e8                	shr    %cl,%eax
  8014b1:	89 c1                	mov    %eax,%ecx
  8014b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8014b7:	09 f9                	or     %edi,%ecx
  8014b9:	89 df                	mov    %ebx,%edi
  8014bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014bf:	89 c1                	mov    %eax,%ecx
  8014c1:	d3 e5                	shl    %cl,%ebp
  8014c3:	89 d1                	mov    %edx,%ecx
  8014c5:	d3 ef                	shr    %cl,%edi
  8014c7:	89 c1                	mov    %eax,%ecx
  8014c9:	89 f0                	mov    %esi,%eax
  8014cb:	d3 e3                	shl    %cl,%ebx
  8014cd:	89 d1                	mov    %edx,%ecx
  8014cf:	89 fa                	mov    %edi,%edx
  8014d1:	d3 e8                	shr    %cl,%eax
  8014d3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8014d8:	09 d8                	or     %ebx,%eax
  8014da:	f7 74 24 08          	divl   0x8(%esp)
  8014de:	89 d3                	mov    %edx,%ebx
  8014e0:	d3 e6                	shl    %cl,%esi
  8014e2:	f7 e5                	mul    %ebp
  8014e4:	89 c7                	mov    %eax,%edi
  8014e6:	89 d1                	mov    %edx,%ecx
  8014e8:	39 d3                	cmp    %edx,%ebx
  8014ea:	72 06                	jb     8014f2 <__umoddi3+0xe2>
  8014ec:	75 0e                	jne    8014fc <__umoddi3+0xec>
  8014ee:	39 c6                	cmp    %eax,%esi
  8014f0:	73 0a                	jae    8014fc <__umoddi3+0xec>
  8014f2:	29 e8                	sub    %ebp,%eax
  8014f4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8014f8:	89 d1                	mov    %edx,%ecx
  8014fa:	89 c7                	mov    %eax,%edi
  8014fc:	89 f5                	mov    %esi,%ebp
  8014fe:	8b 74 24 04          	mov    0x4(%esp),%esi
  801502:	29 fd                	sub    %edi,%ebp
  801504:	19 cb                	sbb    %ecx,%ebx
  801506:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80150b:	89 d8                	mov    %ebx,%eax
  80150d:	d3 e0                	shl    %cl,%eax
  80150f:	89 f1                	mov    %esi,%ecx
  801511:	d3 ed                	shr    %cl,%ebp
  801513:	d3 eb                	shr    %cl,%ebx
  801515:	09 e8                	or     %ebp,%eax
  801517:	89 da                	mov    %ebx,%edx
  801519:	83 c4 1c             	add    $0x1c,%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5f                   	pop    %edi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    
