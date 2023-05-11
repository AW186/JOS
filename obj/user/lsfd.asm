
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 a0 21 80 00       	push   $0x8021a0
  80003e:	e8 bb 01 00 00       	call   8001fe <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	push   0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 44 0e 00 00       	call   800eb0 <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	be 00 00 00 00       	mov    $0x0,%esi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 58 0e 00 00       	call   800ee0 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 fe                	mov    %edi,%esi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	push   0x4(%eax)
  8000b5:	ff 75 dc             	push   -0x24(%ebp)
  8000b8:	ff 75 e0             	push   -0x20(%ebp)
  8000bb:	57                   	push   %edi
  8000bc:	53                   	push   %ebx
  8000bd:	68 b4 21 80 00       	push   $0x8021b4
  8000c2:	e8 37 01 00 00       	call   8001fe <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	57                   	push   %edi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 f6 13 00 00       	call   8014d2 <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 f6                	test   %esi,%esi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	push   0x4(%eax)
  8000f0:	ff 75 dc             	push   -0x24(%ebp)
  8000f3:	ff 75 e0             	push   -0x20(%ebp)
  8000f6:	57                   	push   %edi
  8000f7:	53                   	push   %ebx
  8000f8:	68 b4 21 80 00       	push   $0x8021b4
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 02 18 00 00       	call   801906 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 60 0b 00 00       	call   800c81 <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80015d:	6a 00                	push   $0x0
  80015f:	e8 dc 0a 00 00       	call   800c40 <sys_env_destroy>
}
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	53                   	push   %ebx
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800173:	8b 13                	mov    (%ebx),%edx
  800175:	8d 42 01             	lea    0x1(%edx),%eax
  800178:	89 03                	mov    %eax,(%ebx)
  80017a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800181:	3d ff 00 00 00       	cmp    $0xff,%eax
  800186:	74 09                	je     800191 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800188:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018f:	c9                   	leave  
  800190:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	68 ff 00 00 00       	push   $0xff
  800199:	8d 43 08             	lea    0x8(%ebx),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 61 0a 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  8001a2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	eb db                	jmp    800188 <putch+0x1f>

008001ad <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bd:	00 00 00 
	b.cnt = 0;
  8001c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ca:	ff 75 0c             	push   0xc(%ebp)
  8001cd:	ff 75 08             	push   0x8(%ebp)
  8001d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 69 01 80 00       	push   $0x800169
  8001dc:	e8 14 01 00 00       	call   8002f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e1:	83 c4 08             	add    $0x8,%esp
  8001e4:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001ea:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	e8 0d 0a 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  8001f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800204:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800207:	50                   	push   %eax
  800208:	ff 75 08             	push   0x8(%ebp)
  80020b:	e8 9d ff ff ff       	call   8001ad <vcprintf>
	va_end(ap);

	return cnt;
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	83 ec 1c             	sub    $0x1c,%esp
  80021b:	89 c7                	mov    %eax,%edi
  80021d:	89 d6                	mov    %edx,%esi
  80021f:	8b 45 08             	mov    0x8(%ebp),%eax
  800222:	8b 55 0c             	mov    0xc(%ebp),%edx
  800225:	89 d1                	mov    %edx,%ecx
  800227:	89 c2                	mov    %eax,%edx
  800229:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80022f:	8b 45 10             	mov    0x10(%ebp),%eax
  800232:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800235:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800238:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80023f:	39 c2                	cmp    %eax,%edx
  800241:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800244:	72 3e                	jb     800284 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 18             	push   0x18(%ebp)
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	53                   	push   %ebx
  800250:	50                   	push   %eax
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	ff 75 e4             	push   -0x1c(%ebp)
  800257:	ff 75 e0             	push   -0x20(%ebp)
  80025a:	ff 75 dc             	push   -0x24(%ebp)
  80025d:	ff 75 d8             	push   -0x28(%ebp)
  800260:	e8 eb 1c 00 00       	call   801f50 <__udivdi3>
  800265:	83 c4 18             	add    $0x18,%esp
  800268:	52                   	push   %edx
  800269:	50                   	push   %eax
  80026a:	89 f2                	mov    %esi,%edx
  80026c:	89 f8                	mov    %edi,%eax
  80026e:	e8 9f ff ff ff       	call   800212 <printnum>
  800273:	83 c4 20             	add    $0x20,%esp
  800276:	eb 13                	jmp    80028b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	56                   	push   %esi
  80027c:	ff 75 18             	push   0x18(%ebp)
  80027f:	ff d7                	call   *%edi
  800281:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	85 db                	test   %ebx,%ebx
  800289:	7f ed                	jg     800278 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	56                   	push   %esi
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	ff 75 e4             	push   -0x1c(%ebp)
  800295:	ff 75 e0             	push   -0x20(%ebp)
  800298:	ff 75 dc             	push   -0x24(%ebp)
  80029b:	ff 75 d8             	push   -0x28(%ebp)
  80029e:	e8 cd 1d 00 00       	call   802070 <__umoddi3>
  8002a3:	83 c4 14             	add    $0x14,%esp
  8002a6:	0f be 80 e6 21 80 00 	movsbl 0x8021e6(%eax),%eax
  8002ad:	50                   	push   %eax
  8002ae:	ff d7                	call   *%edi
}
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ca:	73 0a                	jae    8002d6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 02                	mov    %al,(%edx)
}
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <printfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e1:	50                   	push   %eax
  8002e2:	ff 75 10             	push   0x10(%ebp)
  8002e5:	ff 75 0c             	push   0xc(%ebp)
  8002e8:	ff 75 08             	push   0x8(%ebp)
  8002eb:	e8 05 00 00 00       	call   8002f5 <vprintfmt>
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vprintfmt>:
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 3c             	sub    $0x3c,%esp
  8002fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	eb 0a                	jmp    800313 <vprintfmt+0x1e>
			putch(ch, putdat);
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	53                   	push   %ebx
  80030d:	50                   	push   %eax
  80030e:	ff d6                	call   *%esi
  800310:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800313:	83 c7 01             	add    $0x1,%edi
  800316:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80031a:	83 f8 25             	cmp    $0x25,%eax
  80031d:	74 0c                	je     80032b <vprintfmt+0x36>
			if (ch == '\0')
  80031f:	85 c0                	test   %eax,%eax
  800321:	75 e6                	jne    800309 <vprintfmt+0x14>
}
  800323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800326:	5b                   	pop    %ebx
  800327:	5e                   	pop    %esi
  800328:	5f                   	pop    %edi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    
		padc = ' ';
  80032b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800336:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80033d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800344:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8d 47 01             	lea    0x1(%edi),%eax
  80034c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80034f:	0f b6 17             	movzbl (%edi),%edx
  800352:	8d 42 dd             	lea    -0x23(%edx),%eax
  800355:	3c 55                	cmp    $0x55,%al
  800357:	0f 87 a6 04 00 00    	ja     800803 <vprintfmt+0x50e>
  80035d:	0f b6 c0             	movzbl %al,%eax
  800360:	ff 24 85 20 23 80 00 	jmp    *0x802320(,%eax,4)
  800367:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d9                	jmp    800349 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb d0                	jmp    800349 <vprintfmt+0x54>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003b6:	79 91                	jns    800349 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003c5:	eb 82                	jmp    800349 <vprintfmt+0x54>
  8003c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d1:	0f 49 c2             	cmovns %edx,%eax
  8003d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003da:	e9 6a ff ff ff       	jmp    800349 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e9:	e9 5b ff ff ff       	jmp    800349 <vprintfmt+0x54>
  8003ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0xbd>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003fc:	e9 48 ff ff ff       	jmp    800349 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	push   (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 88 03 00 00       	jmp    8007a2 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 10                	mov    (%eax),%edx
  800422:	89 d0                	mov    %edx,%eax
  800424:	f7 d8                	neg    %eax
  800426:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800429:	83 f8 0f             	cmp    $0xf,%eax
  80042c:	7f 23                	jg     800451 <vprintfmt+0x15c>
  80042e:	8b 14 85 80 24 80 00 	mov    0x802480(,%eax,4),%edx
  800435:	85 d2                	test   %edx,%edx
  800437:	74 18                	je     800451 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800439:	52                   	push   %edx
  80043a:	68 b1 25 80 00       	push   $0x8025b1
  80043f:	53                   	push   %ebx
  800440:	56                   	push   %esi
  800441:	e8 92 fe ff ff       	call   8002d8 <printfmt>
  800446:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800449:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044c:	e9 51 03 00 00       	jmp    8007a2 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800451:	50                   	push   %eax
  800452:	68 fe 21 80 00       	push   $0x8021fe
  800457:	53                   	push   %ebx
  800458:	56                   	push   %esi
  800459:	e8 7a fe ff ff       	call   8002d8 <printfmt>
  80045e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800461:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800464:	e9 39 03 00 00       	jmp    8007a2 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800469:	8b 45 14             	mov    0x14(%ebp),%eax
  80046c:	83 c0 04             	add    $0x4,%eax
  80046f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800477:	85 d2                	test   %edx,%edx
  800479:	b8 f7 21 80 00       	mov    $0x8021f7,%eax
  80047e:	0f 45 c2             	cmovne %edx,%eax
  800481:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800484:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800488:	7e 06                	jle    800490 <vprintfmt+0x19b>
  80048a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048e:	75 0d                	jne    80049d <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800490:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800493:	89 c7                	mov    %eax,%edi
  800495:	03 45 d4             	add    -0x2c(%ebp),%eax
  800498:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80049b:	eb 55                	jmp    8004f2 <vprintfmt+0x1fd>
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 e0             	push   -0x20(%ebp)
  8004a3:	ff 75 cc             	push   -0x34(%ebp)
  8004a6:	e8 f5 03 00 00       	call   8008a0 <strnlen>
  8004ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ae:	29 c2                	sub    %eax,%edx
  8004b0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	eb 0f                	jmp    8004d0 <vprintfmt+0x1db>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 d4             	push   -0x2c(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	85 ff                	test   %edi,%edi
  8004d2:	7f ed                	jg     8004c1 <vprintfmt+0x1cc>
  8004d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	0f 49 c2             	cmovns %edx,%eax
  8004e1:	29 c2                	sub    %eax,%edx
  8004e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e6:	eb a8                	jmp    800490 <vprintfmt+0x19b>
					putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	53                   	push   %ebx
  8004ec:	52                   	push   %edx
  8004ed:	ff d6                	call   *%esi
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004f5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f7:	83 c7 01             	add    $0x1,%edi
  8004fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fe:	0f be d0             	movsbl %al,%edx
  800501:	85 d2                	test   %edx,%edx
  800503:	74 4b                	je     800550 <vprintfmt+0x25b>
  800505:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800509:	78 06                	js     800511 <vprintfmt+0x21c>
  80050b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80050f:	78 1e                	js     80052f <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800511:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800515:	74 d1                	je     8004e8 <vprintfmt+0x1f3>
  800517:	0f be c0             	movsbl %al,%eax
  80051a:	83 e8 20             	sub    $0x20,%eax
  80051d:	83 f8 5e             	cmp    $0x5e,%eax
  800520:	76 c6                	jbe    8004e8 <vprintfmt+0x1f3>
					putch('?', putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	6a 3f                	push   $0x3f
  800528:	ff d6                	call   *%esi
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	eb c3                	jmp    8004f2 <vprintfmt+0x1fd>
  80052f:	89 cf                	mov    %ecx,%edi
  800531:	eb 0e                	jmp    800541 <vprintfmt+0x24c>
				putch(' ', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 20                	push   $0x20
  800539:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053b:	83 ef 01             	sub    $0x1,%edi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	85 ff                	test   %edi,%edi
  800543:	7f ee                	jg     800533 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800545:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
  80054b:	e9 52 02 00 00       	jmp    8007a2 <vprintfmt+0x4ad>
  800550:	89 cf                	mov    %ecx,%edi
  800552:	eb ed                	jmp    800541 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 c0 04             	add    $0x4,%eax
  80055a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800562:	85 d2                	test   %edx,%edx
  800564:	b8 f7 21 80 00       	mov    $0x8021f7,%eax
  800569:	0f 45 c2             	cmovne %edx,%eax
  80056c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80056f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800573:	7e 06                	jle    80057b <vprintfmt+0x286>
  800575:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800579:	75 0d                	jne    800588 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057e:	89 c7                	mov    %eax,%edi
  800580:	03 45 d4             	add    -0x2c(%ebp),%eax
  800583:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800586:	eb 55                	jmp    8005dd <vprintfmt+0x2e8>
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	ff 75 e0             	push   -0x20(%ebp)
  80058e:	ff 75 cc             	push   -0x34(%ebp)
  800591:	e8 0a 03 00 00       	call   8008a0 <strnlen>
  800596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800599:	29 c2                	sub    %eax,%edx
  80059b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005aa:	eb 0f                	jmp    8005bb <vprintfmt+0x2c6>
					putch(padc, putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	ff 75 d4             	push   -0x2c(%ebp)
  8005b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b5:	83 ef 01             	sub    $0x1,%edi
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	85 ff                	test   %edi,%edi
  8005bd:	7f ed                	jg     8005ac <vprintfmt+0x2b7>
  8005bf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005c2:	85 d2                	test   %edx,%edx
  8005c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c9:	0f 49 c2             	cmovns %edx,%eax
  8005cc:	29 c2                	sub    %eax,%edx
  8005ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d1:	eb a8                	jmp    80057b <vprintfmt+0x286>
					putch(ch, putdat);
  8005d3:	83 ec 08             	sub    $0x8,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	52                   	push   %edx
  8005d8:	ff d6                	call   *%esi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005e2:	83 c7 01             	add    $0x1,%edi
  8005e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005e9:	0f be d0             	movsbl %al,%edx
  8005ec:	3c 3a                	cmp    $0x3a,%al
  8005ee:	74 4b                	je     80063b <vprintfmt+0x346>
  8005f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f4:	78 06                	js     8005fc <vprintfmt+0x307>
  8005f6:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005fa:	78 1e                	js     80061a <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800600:	74 d1                	je     8005d3 <vprintfmt+0x2de>
  800602:	0f be c0             	movsbl %al,%eax
  800605:	83 e8 20             	sub    $0x20,%eax
  800608:	83 f8 5e             	cmp    $0x5e,%eax
  80060b:	76 c6                	jbe    8005d3 <vprintfmt+0x2de>
					putch('?', putdat);
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	53                   	push   %ebx
  800611:	6a 3f                	push   $0x3f
  800613:	ff d6                	call   *%esi
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	eb c3                	jmp    8005dd <vprintfmt+0x2e8>
  80061a:	89 cf                	mov    %ecx,%edi
  80061c:	eb 0e                	jmp    80062c <vprintfmt+0x337>
				putch(' ', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 20                	push   $0x20
  800624:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800626:	83 ef 01             	sub    $0x1,%edi
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	85 ff                	test   %edi,%edi
  80062e:	7f ee                	jg     80061e <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800630:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
  800636:	e9 67 01 00 00       	jmp    8007a2 <vprintfmt+0x4ad>
  80063b:	89 cf                	mov    %ecx,%edi
  80063d:	eb ed                	jmp    80062c <vprintfmt+0x337>
	if (lflag >= 2)
  80063f:	83 f9 01             	cmp    $0x1,%ecx
  800642:	7f 1b                	jg     80065f <vprintfmt+0x36a>
	else if (lflag)
  800644:	85 c9                	test   %ecx,%ecx
  800646:	74 63                	je     8006ab <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800650:	99                   	cltd   
  800651:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	eb 17                	jmp    800676 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 50 04             	mov    0x4(%eax),%edx
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800676:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800679:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80067c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800681:	85 c9                	test   %ecx,%ecx
  800683:	0f 89 ff 00 00 00    	jns    800788 <vprintfmt+0x493>
				putch('-', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	6a 2d                	push   $0x2d
  80068f:	ff d6                	call   *%esi
				num = -(long long) num;
  800691:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800694:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800697:	f7 da                	neg    %edx
  800699:	83 d1 00             	adc    $0x0,%ecx
  80069c:	f7 d9                	neg    %ecx
  80069e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a6:	e9 dd 00 00 00       	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b3:	99                   	cltd   
  8006b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	eb b4                	jmp    800676 <vprintfmt+0x381>
	if (lflag >= 2)
  8006c2:	83 f9 01             	cmp    $0x1,%ecx
  8006c5:	7f 1e                	jg     8006e5 <vprintfmt+0x3f0>
	else if (lflag)
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	74 32                	je     8006fd <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 10                	mov    (%eax),%edx
  8006d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006db:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006e0:	e9 a3 00 00 00       	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ed:	8d 40 08             	lea    0x8(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006f8:	e9 8b 00 00 00       	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800712:	eb 74                	jmp    800788 <vprintfmt+0x493>
	if (lflag >= 2)
  800714:	83 f9 01             	cmp    $0x1,%ecx
  800717:	7f 1b                	jg     800734 <vprintfmt+0x43f>
	else if (lflag)
  800719:	85 c9                	test   %ecx,%ecx
  80071b:	74 2c                	je     800749 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 10                	mov    (%eax),%edx
  800722:	b9 00 00 00 00       	mov    $0x0,%ecx
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800732:	eb 54                	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	8b 48 04             	mov    0x4(%eax),%ecx
  80073c:	8d 40 08             	lea    0x8(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800742:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800747:	eb 3f                	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 10                	mov    (%eax),%edx
  80074e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800759:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80075e:	eb 28                	jmp    800788 <vprintfmt+0x493>
			putch('0', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 30                	push   $0x30
  800766:	ff d6                	call   *%esi
			putch('x', putdat);
  800768:	83 c4 08             	add    $0x8,%esp
  80076b:	53                   	push   %ebx
  80076c:	6a 78                	push   $0x78
  80076e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 10                	mov    (%eax),%edx
  800775:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80077a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800783:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800788:	83 ec 0c             	sub    $0xc,%esp
  80078b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80078f:	50                   	push   %eax
  800790:	ff 75 d4             	push   -0x2c(%ebp)
  800793:	57                   	push   %edi
  800794:	51                   	push   %ecx
  800795:	52                   	push   %edx
  800796:	89 da                	mov    %ebx,%edx
  800798:	89 f0                	mov    %esi,%eax
  80079a:	e8 73 fa ff ff       	call   800212 <printnum>
			break;
  80079f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a5:	e9 69 fb ff ff       	jmp    800313 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007aa:	83 f9 01             	cmp    $0x1,%ecx
  8007ad:	7f 1b                	jg     8007ca <vprintfmt+0x4d5>
	else if (lflag)
  8007af:	85 c9                	test   %ecx,%ecx
  8007b1:	74 2c                	je     8007df <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 10                	mov    (%eax),%edx
  8007b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007c8:	eb be                	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 10                	mov    (%eax),%edx
  8007cf:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d2:	8d 40 08             	lea    0x8(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007dd:	eb a9                	jmp    800788 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 10                	mov    (%eax),%edx
  8007e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ef:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007f4:	eb 92                	jmp    800788 <vprintfmt+0x493>
			putch(ch, putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 25                	push   $0x25
  8007fc:	ff d6                	call   *%esi
			break;
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	eb 9f                	jmp    8007a2 <vprintfmt+0x4ad>
			putch('%', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	6a 25                	push   $0x25
  800809:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 f8                	mov    %edi,%eax
  800810:	eb 03                	jmp    800815 <vprintfmt+0x520>
  800812:	83 e8 01             	sub    $0x1,%eax
  800815:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800819:	75 f7                	jne    800812 <vprintfmt+0x51d>
  80081b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80081e:	eb 82                	jmp    8007a2 <vprintfmt+0x4ad>

00800820 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 18             	sub    $0x18,%esp
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800833:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083d:	85 c0                	test   %eax,%eax
  80083f:	74 26                	je     800867 <vsnprintf+0x47>
  800841:	85 d2                	test   %edx,%edx
  800843:	7e 22                	jle    800867 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800845:	ff 75 14             	push   0x14(%ebp)
  800848:	ff 75 10             	push   0x10(%ebp)
  80084b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084e:	50                   	push   %eax
  80084f:	68 bb 02 80 00       	push   $0x8002bb
  800854:	e8 9c fa ff ff       	call   8002f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800862:	83 c4 10             	add    $0x10,%esp
}
  800865:	c9                   	leave  
  800866:	c3                   	ret    
		return -E_INVAL;
  800867:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086c:	eb f7                	jmp    800865 <vsnprintf+0x45>

0080086e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800874:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800877:	50                   	push   %eax
  800878:	ff 75 10             	push   0x10(%ebp)
  80087b:	ff 75 0c             	push   0xc(%ebp)
  80087e:	ff 75 08             	push   0x8(%ebp)
  800881:	e8 9a ff ff ff       	call   800820 <vsnprintf>
	va_end(ap);

	return rc;
}
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	eb 03                	jmp    800898 <strlen+0x10>
		n++;
  800895:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800898:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80089c:	75 f7                	jne    800895 <strlen+0xd>
	return n;
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	eb 03                	jmp    8008b3 <strnlen+0x13>
		n++;
  8008b0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b3:	39 d0                	cmp    %edx,%eax
  8008b5:	74 08                	je     8008bf <strnlen+0x1f>
  8008b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008bb:	75 f3                	jne    8008b0 <strnlen+0x10>
  8008bd:	89 c2                	mov    %eax,%edx
	return n;
}
  8008bf:	89 d0                	mov    %edx,%eax
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	53                   	push   %ebx
  8008c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008d6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008d9:	83 c0 01             	add    $0x1,%eax
  8008dc:	84 d2                	test   %dl,%dl
  8008de:	75 f2                	jne    8008d2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008e0:	89 c8                	mov    %ecx,%eax
  8008e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 10             	sub    $0x10,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f1:	53                   	push   %ebx
  8008f2:	e8 91 ff ff ff       	call   800888 <strlen>
  8008f7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008fa:	ff 75 0c             	push   0xc(%ebp)
  8008fd:	01 d8                	add    %ebx,%eax
  8008ff:	50                   	push   %eax
  800900:	e8 be ff ff ff       	call   8008c3 <strcpy>
	return dst;
}
  800905:	89 d8                	mov    %ebx,%eax
  800907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	8b 75 08             	mov    0x8(%ebp),%esi
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 f3                	mov    %esi,%ebx
  800919:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091c:	89 f0                	mov    %esi,%eax
  80091e:	eb 0f                	jmp    80092f <strncpy+0x23>
		*dst++ = *src;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	0f b6 0a             	movzbl (%edx),%ecx
  800926:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800929:	80 f9 01             	cmp    $0x1,%cl
  80092c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80092f:	39 d8                	cmp    %ebx,%eax
  800931:	75 ed                	jne    800920 <strncpy+0x14>
	}
	return ret;
}
  800933:	89 f0                	mov    %esi,%eax
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	8b 75 08             	mov    0x8(%ebp),%esi
  800941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800944:	8b 55 10             	mov    0x10(%ebp),%edx
  800947:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800949:	85 d2                	test   %edx,%edx
  80094b:	74 21                	je     80096e <strlcpy+0x35>
  80094d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800951:	89 f2                	mov    %esi,%edx
  800953:	eb 09                	jmp    80095e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800955:	83 c1 01             	add    $0x1,%ecx
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 09                	je     80096b <strlcpy+0x32>
  800962:	0f b6 19             	movzbl (%ecx),%ebx
  800965:	84 db                	test   %bl,%bl
  800967:	75 ec                	jne    800955 <strlcpy+0x1c>
  800969:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80096e:	29 f0                	sub    %esi,%eax
}
  800970:	5b                   	pop    %ebx
  800971:	5e                   	pop    %esi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097d:	eb 06                	jmp    800985 <strcmp+0x11>
		p++, q++;
  80097f:	83 c1 01             	add    $0x1,%ecx
  800982:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800985:	0f b6 01             	movzbl (%ecx),%eax
  800988:	84 c0                	test   %al,%al
  80098a:	74 04                	je     800990 <strcmp+0x1c>
  80098c:	3a 02                	cmp    (%edx),%al
  80098e:	74 ef                	je     80097f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	0f b6 12             	movzbl (%edx),%edx
  800996:	29 d0                	sub    %edx,%eax
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	53                   	push   %ebx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a4:	89 c3                	mov    %eax,%ebx
  8009a6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009a9:	eb 06                	jmp    8009b1 <strncmp+0x17>
		n--, p++, q++;
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b1:	39 d8                	cmp    %ebx,%eax
  8009b3:	74 18                	je     8009cd <strncmp+0x33>
  8009b5:	0f b6 08             	movzbl (%eax),%ecx
  8009b8:	84 c9                	test   %cl,%cl
  8009ba:	74 04                	je     8009c0 <strncmp+0x26>
  8009bc:	3a 0a                	cmp    (%edx),%cl
  8009be:	74 eb                	je     8009ab <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c0:	0f b6 00             	movzbl (%eax),%eax
  8009c3:	0f b6 12             	movzbl (%edx),%edx
  8009c6:	29 d0                	sub    %edx,%eax
}
  8009c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    
		return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	eb f4                	jmp    8009c8 <strncmp+0x2e>

008009d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009de:	eb 03                	jmp    8009e3 <strchr+0xf>
  8009e0:	83 c0 01             	add    $0x1,%eax
  8009e3:	0f b6 10             	movzbl (%eax),%edx
  8009e6:	84 d2                	test   %dl,%dl
  8009e8:	74 06                	je     8009f0 <strchr+0x1c>
		if (*s == c)
  8009ea:	38 ca                	cmp    %cl,%dl
  8009ec:	75 f2                	jne    8009e0 <strchr+0xc>
  8009ee:	eb 05                	jmp    8009f5 <strchr+0x21>
			return (char *) s;
	return 0;
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a01:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a04:	38 ca                	cmp    %cl,%dl
  800a06:	74 09                	je     800a11 <strfind+0x1a>
  800a08:	84 d2                	test   %dl,%dl
  800a0a:	74 05                	je     800a11 <strfind+0x1a>
	for (; *s; s++)
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	eb f0                	jmp    800a01 <strfind+0xa>
			break;
	return (char *) s;
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	57                   	push   %edi
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a1f:	85 c9                	test   %ecx,%ecx
  800a21:	74 2f                	je     800a52 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a23:	89 f8                	mov    %edi,%eax
  800a25:	09 c8                	or     %ecx,%eax
  800a27:	a8 03                	test   $0x3,%al
  800a29:	75 21                	jne    800a4c <memset+0x39>
		c &= 0xFF;
  800a2b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	c1 e0 08             	shl    $0x8,%eax
  800a34:	89 d3                	mov    %edx,%ebx
  800a36:	c1 e3 18             	shl    $0x18,%ebx
  800a39:	89 d6                	mov    %edx,%esi
  800a3b:	c1 e6 10             	shl    $0x10,%esi
  800a3e:	09 f3                	or     %esi,%ebx
  800a40:	09 da                	or     %ebx,%edx
  800a42:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a44:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a47:	fc                   	cld    
  800a48:	f3 ab                	rep stos %eax,%es:(%edi)
  800a4a:	eb 06                	jmp    800a52 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	fc                   	cld    
  800a50:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a52:	89 f8                	mov    %edi,%eax
  800a54:	5b                   	pop    %ebx
  800a55:	5e                   	pop    %esi
  800a56:	5f                   	pop    %edi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	57                   	push   %edi
  800a5d:	56                   	push   %esi
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a67:	39 c6                	cmp    %eax,%esi
  800a69:	73 32                	jae    800a9d <memmove+0x44>
  800a6b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a6e:	39 c2                	cmp    %eax,%edx
  800a70:	76 2b                	jbe    800a9d <memmove+0x44>
		s += n;
		d += n;
  800a72:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a75:	89 d6                	mov    %edx,%esi
  800a77:	09 fe                	or     %edi,%esi
  800a79:	09 ce                	or     %ecx,%esi
  800a7b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a81:	75 0e                	jne    800a91 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a83:	83 ef 04             	sub    $0x4,%edi
  800a86:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a89:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a8c:	fd                   	std    
  800a8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8f:	eb 09                	jmp    800a9a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a91:	83 ef 01             	sub    $0x1,%edi
  800a94:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a97:	fd                   	std    
  800a98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a9a:	fc                   	cld    
  800a9b:	eb 1a                	jmp    800ab7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9d:	89 f2                	mov    %esi,%edx
  800a9f:	09 c2                	or     %eax,%edx
  800aa1:	09 ca                	or     %ecx,%edx
  800aa3:	f6 c2 03             	test   $0x3,%dl
  800aa6:	75 0a                	jne    800ab2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aab:	89 c7                	mov    %eax,%edi
  800aad:	fc                   	cld    
  800aae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab0:	eb 05                	jmp    800ab7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab2:	89 c7                	mov    %eax,%edi
  800ab4:	fc                   	cld    
  800ab5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab7:	5e                   	pop    %esi
  800ab8:	5f                   	pop    %edi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac1:	ff 75 10             	push   0x10(%ebp)
  800ac4:	ff 75 0c             	push   0xc(%ebp)
  800ac7:	ff 75 08             	push   0x8(%ebp)
  800aca:	e8 8a ff ff ff       	call   800a59 <memmove>
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 c6                	mov    %eax,%esi
  800ade:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae1:	eb 06                	jmp    800ae9 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800ae9:	39 f0                	cmp    %esi,%eax
  800aeb:	74 14                	je     800b01 <memcmp+0x30>
		if (*s1 != *s2)
  800aed:	0f b6 08             	movzbl (%eax),%ecx
  800af0:	0f b6 1a             	movzbl (%edx),%ebx
  800af3:	38 d9                	cmp    %bl,%cl
  800af5:	74 ec                	je     800ae3 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800af7:	0f b6 c1             	movzbl %cl,%eax
  800afa:	0f b6 db             	movzbl %bl,%ebx
  800afd:	29 d8                	sub    %ebx,%eax
  800aff:	eb 05                	jmp    800b06 <memcmp+0x35>
	}

	return 0;
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b13:	89 c2                	mov    %eax,%edx
  800b15:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b18:	eb 03                	jmp    800b1d <memfind+0x13>
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	39 d0                	cmp    %edx,%eax
  800b1f:	73 04                	jae    800b25 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b21:	38 08                	cmp    %cl,(%eax)
  800b23:	75 f5                	jne    800b1a <memfind+0x10>
			break;
	return (void *) s;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b33:	eb 03                	jmp    800b38 <strtol+0x11>
		s++;
  800b35:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b38:	0f b6 02             	movzbl (%edx),%eax
  800b3b:	3c 20                	cmp    $0x20,%al
  800b3d:	74 f6                	je     800b35 <strtol+0xe>
  800b3f:	3c 09                	cmp    $0x9,%al
  800b41:	74 f2                	je     800b35 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b43:	3c 2b                	cmp    $0x2b,%al
  800b45:	74 2a                	je     800b71 <strtol+0x4a>
	int neg = 0;
  800b47:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4c:	3c 2d                	cmp    $0x2d,%al
  800b4e:	74 2b                	je     800b7b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b50:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b56:	75 0f                	jne    800b67 <strtol+0x40>
  800b58:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5b:	74 28                	je     800b85 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b64:	0f 44 d8             	cmove  %eax,%ebx
  800b67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6f:	eb 46                	jmp    800bb7 <strtol+0x90>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b74:	bf 00 00 00 00       	mov    $0x0,%edi
  800b79:	eb d5                	jmp    800b50 <strtol+0x29>
		s++, neg = 1;
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b83:	eb cb                	jmp    800b50 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b85:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b89:	74 0e                	je     800b99 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	75 d8                	jne    800b67 <strtol+0x40>
		s++, base = 8;
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b97:	eb ce                	jmp    800b67 <strtol+0x40>
		s += 2, base = 16;
  800b99:	83 c2 02             	add    $0x2,%edx
  800b9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba1:	eb c4                	jmp    800b67 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba3:	0f be c0             	movsbl %al,%eax
  800ba6:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bac:	7d 3a                	jge    800be8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bb5:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bb7:	0f b6 02             	movzbl (%edx),%eax
  800bba:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bbd:	89 f3                	mov    %esi,%ebx
  800bbf:	80 fb 09             	cmp    $0x9,%bl
  800bc2:	76 df                	jbe    800ba3 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bc4:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bc7:	89 f3                	mov    %esi,%ebx
  800bc9:	80 fb 19             	cmp    $0x19,%bl
  800bcc:	77 08                	ja     800bd6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bce:	0f be c0             	movsbl %al,%eax
  800bd1:	83 e8 57             	sub    $0x57,%eax
  800bd4:	eb d3                	jmp    800ba9 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bd6:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bd9:	89 f3                	mov    %esi,%ebx
  800bdb:	80 fb 19             	cmp    $0x19,%bl
  800bde:	77 08                	ja     800be8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be0:	0f be c0             	movsbl %al,%eax
  800be3:	83 e8 37             	sub    $0x37,%eax
  800be6:	eb c1                	jmp    800ba9 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 05                	je     800bf3 <strtol+0xcc>
		*endptr = (char *) s;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800bf3:	89 c8                	mov    %ecx,%eax
  800bf5:	f7 d8                	neg    %eax
  800bf7:	85 ff                	test   %edi,%edi
  800bf9:	0f 45 c8             	cmovne %eax,%ecx
}
  800bfc:	89 c8                	mov    %ecx,%eax
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c09:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	89 c3                	mov    %eax,%ebx
  800c16:	89 c7                	mov    %eax,%edi
  800c18:	89 c6                	mov    %eax,%esi
  800c1a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1c:	5b                   	pop    %ebx
  800c1d:	5e                   	pop    %esi
  800c1e:	5f                   	pop    %edi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 01 00 00 00       	mov    $0x1,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c51:	b8 03 00 00 00       	mov    $0x3,%eax
  800c56:	89 cb                	mov    %ecx,%ebx
  800c58:	89 cf                	mov    %ecx,%edi
  800c5a:	89 ce                	mov    %ecx,%esi
  800c5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	7f 08                	jg     800c6a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c6e:	6a 03                	push   $0x3
  800c70:	68 df 24 80 00       	push   $0x8024df
  800c75:	6a 23                	push   $0x23
  800c77:	68 fc 24 80 00       	push   $0x8024fc
  800c7c:	e8 70 11 00 00       	call   801df1 <_panic>

00800c81 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c87:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c91:	89 d1                	mov    %edx,%ecx
  800c93:	89 d3                	mov    %edx,%ebx
  800c95:	89 d7                	mov    %edx,%edi
  800c97:	89 d6                	mov    %edx,%esi
  800c99:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9b:	5b                   	pop    %ebx
  800c9c:	5e                   	pop    %esi
  800c9d:	5f                   	pop    %edi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <sys_yield>:

void
sys_yield(void)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb0:	89 d1                	mov    %edx,%ecx
  800cb2:	89 d3                	mov    %edx,%ebx
  800cb4:	89 d7                	mov    %edx,%edi
  800cb6:	89 d6                	mov    %edx,%esi
  800cb8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cba:	5b                   	pop    %ebx
  800cbb:	5e                   	pop    %esi
  800cbc:	5f                   	pop    %edi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc8:	be 00 00 00 00       	mov    $0x0,%esi
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdb:	89 f7                	mov    %esi,%edi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 04                	push   $0x4
  800cf1:	68 df 24 80 00       	push   $0x8024df
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 fc 24 80 00       	push   $0x8024fc
  800cfd:	e8 ef 10 00 00       	call   801df1 <_panic>

00800d02 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 05 00 00 00       	mov    $0x5,%eax
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 05                	push   $0x5
  800d33:	68 df 24 80 00       	push   $0x8024df
  800d38:	6a 23                	push   $0x23
  800d3a:	68 fc 24 80 00       	push   $0x8024fc
  800d3f:	e8 ad 10 00 00       	call   801df1 <_panic>

00800d44 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5d:	89 df                	mov    %ebx,%edi
  800d5f:	89 de                	mov    %ebx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 06                	push   $0x6
  800d75:	68 df 24 80 00       	push   $0x8024df
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 fc 24 80 00       	push   $0x8024fc
  800d81:	e8 6b 10 00 00       	call   801df1 <_panic>

00800d86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d9f:	89 df                	mov    %ebx,%edi
  800da1:	89 de                	mov    %ebx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 08                	push   $0x8
  800db7:	68 df 24 80 00       	push   $0x8024df
  800dbc:	6a 23                	push   $0x23
  800dbe:	68 fc 24 80 00       	push   $0x8024fc
  800dc3:	e8 29 10 00 00       	call   801df1 <_panic>

00800dc8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 09 00 00 00       	mov    $0x9,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 09                	push   $0x9
  800df9:	68 df 24 80 00       	push   $0x8024df
  800dfe:	6a 23                	push   $0x23
  800e00:	68 fc 24 80 00       	push   $0x8024fc
  800e05:	e8 e7 0f 00 00       	call   801df1 <_panic>

00800e0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 0a                	push   $0xa
  800e3b:	68 df 24 80 00       	push   $0x8024df
  800e40:	6a 23                	push   $0x23
  800e42:	68 fc 24 80 00       	push   $0x8024fc
  800e47:	e8 a5 0f 00 00       	call   801df1 <_panic>

00800e4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e5d:	be 00 00 00 00       	mov    $0x0,%esi
  800e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e68:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e85:	89 cb                	mov    %ecx,%ebx
  800e87:	89 cf                	mov    %ecx,%edi
  800e89:	89 ce                	mov    %ecx,%esi
  800e8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	7f 08                	jg     800e99 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	50                   	push   %eax
  800e9d:	6a 0d                	push   $0xd
  800e9f:	68 df 24 80 00       	push   $0x8024df
  800ea4:	6a 23                	push   $0x23
  800ea6:	68 fc 24 80 00       	push   $0x8024fc
  800eab:	e8 41 0f 00 00       	call   801df1 <_panic>

00800eb0 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800ebc:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800ebe:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800ec1:	83 3a 01             	cmpl   $0x1,(%edx)
  800ec4:	7e 09                	jle    800ecf <argstart+0x1f>
  800ec6:	ba 2a 26 80 00       	mov    $0x80262a,%edx
  800ecb:	85 c9                	test   %ecx,%ecx
  800ecd:	75 05                	jne    800ed4 <argstart+0x24>
  800ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed4:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ed7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <argnext>:

int
argnext(struct Argstate *args)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800eea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ef1:	8b 43 08             	mov    0x8(%ebx),%eax
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	74 74                	je     800f6c <argnext+0x8c>
		return -1;

	if (!*args->curarg) {
  800ef8:	80 38 00             	cmpb   $0x0,(%eax)
  800efb:	75 48                	jne    800f45 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800efd:	8b 0b                	mov    (%ebx),%ecx
  800eff:	83 39 01             	cmpl   $0x1,(%ecx)
  800f02:	74 5a                	je     800f5e <argnext+0x7e>
		    || args->argv[1][0] != '-'
  800f04:	8b 53 04             	mov    0x4(%ebx),%edx
  800f07:	8b 42 04             	mov    0x4(%edx),%eax
  800f0a:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f0d:	75 4f                	jne    800f5e <argnext+0x7e>
		    || args->argv[1][1] == '\0')
  800f0f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f13:	74 49                	je     800f5e <argnext+0x7e>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f15:	83 c0 01             	add    $0x1,%eax
  800f18:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f1b:	83 ec 04             	sub    $0x4,%esp
  800f1e:	8b 01                	mov    (%ecx),%eax
  800f20:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800f27:	50                   	push   %eax
  800f28:	8d 42 08             	lea    0x8(%edx),%eax
  800f2b:	50                   	push   %eax
  800f2c:	83 c2 04             	add    $0x4,%edx
  800f2f:	52                   	push   %edx
  800f30:	e8 24 fb ff ff       	call   800a59 <memmove>
		(*args->argc)--;
  800f35:	8b 03                	mov    (%ebx),%eax
  800f37:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f3a:	8b 43 08             	mov    0x8(%ebx),%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f43:	74 13                	je     800f58 <argnext+0x78>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f45:	8b 43 08             	mov    0x8(%ebx),%eax
  800f48:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800f4b:	83 c0 01             	add    $0x1,%eax
  800f4e:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f51:	89 d0                	mov    %edx,%eax
  800f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f58:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f5c:	75 e7                	jne    800f45 <argnext+0x65>
	args->curarg = 0;
  800f5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f65:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f6a:	eb e5                	jmp    800f51 <argnext+0x71>
		return -1;
  800f6c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f71:	eb de                	jmp    800f51 <argnext+0x71>

00800f73 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	53                   	push   %ebx
  800f77:	83 ec 04             	sub    $0x4,%esp
  800f7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800f7d:	8b 43 08             	mov    0x8(%ebx),%eax
  800f80:	85 c0                	test   %eax,%eax
  800f82:	74 12                	je     800f96 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  800f84:	80 38 00             	cmpb   $0x0,(%eax)
  800f87:	74 12                	je     800f9b <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800f89:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f8c:	c7 43 08 2a 26 80 00 	movl   $0x80262a,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f93:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f9b:	8b 13                	mov    (%ebx),%edx
  800f9d:	83 3a 01             	cmpl   $0x1,(%edx)
  800fa0:	7f 10                	jg     800fb2 <argnextvalue+0x3f>
		args->argvalue = 0;
  800fa2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800fa9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800fb0:	eb e1                	jmp    800f93 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800fb2:	8b 43 04             	mov    0x4(%ebx),%eax
  800fb5:	8b 48 04             	mov    0x4(%eax),%ecx
  800fb8:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fbb:	83 ec 04             	sub    $0x4,%esp
  800fbe:	8b 12                	mov    (%edx),%edx
  800fc0:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800fc7:	52                   	push   %edx
  800fc8:	8d 50 08             	lea    0x8(%eax),%edx
  800fcb:	52                   	push   %edx
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	50                   	push   %eax
  800fd0:	e8 84 fa ff ff       	call   800a59 <memmove>
		(*args->argc)--;
  800fd5:	8b 03                	mov    (%ebx),%eax
  800fd7:	83 28 01             	subl   $0x1,(%eax)
  800fda:	83 c4 10             	add    $0x10,%esp
  800fdd:	eb b4                	jmp    800f93 <argnextvalue+0x20>

00800fdf <argvalue>:
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fe8:	8b 42 0c             	mov    0xc(%edx),%eax
  800feb:	85 c0                	test   %eax,%eax
  800fed:	74 02                	je     800ff1 <argvalue+0x12>
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800ff1:	83 ec 0c             	sub    $0xc,%esp
  800ff4:	52                   	push   %edx
  800ff5:	e8 79 ff ff ff       	call   800f73 <argnextvalue>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	eb f0                	jmp    800fef <argvalue+0x10>

00800fff <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	05 00 00 00 30       	add    $0x30000000,%eax
  80100a:	c1 e8 0c             	shr    $0xc,%eax
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80101a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80102e:	89 c2                	mov    %eax,%edx
  801030:	c1 ea 16             	shr    $0x16,%edx
  801033:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80103a:	f6 c2 01             	test   $0x1,%dl
  80103d:	74 29                	je     801068 <fd_alloc+0x42>
  80103f:	89 c2                	mov    %eax,%edx
  801041:	c1 ea 0c             	shr    $0xc,%edx
  801044:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104b:	f6 c2 01             	test   $0x1,%dl
  80104e:	74 18                	je     801068 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801050:	05 00 10 00 00       	add    $0x1000,%eax
  801055:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80105a:	75 d2                	jne    80102e <fd_alloc+0x8>
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  801061:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801066:	eb 05                	jmp    80106d <fd_alloc+0x47>
			return 0;
  801068:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	89 02                	mov    %eax,(%edx)
}
  801072:	89 c8                	mov    %ecx,%eax
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80107c:	83 f8 1f             	cmp    $0x1f,%eax
  80107f:	77 30                	ja     8010b1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801081:	c1 e0 0c             	shl    $0xc,%eax
  801084:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801089:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	74 24                	je     8010b8 <fd_lookup+0x42>
  801094:	89 c2                	mov    %eax,%edx
  801096:	c1 ea 0c             	shr    $0xc,%edx
  801099:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a0:	f6 c2 01             	test   $0x1,%dl
  8010a3:	74 1a                	je     8010bf <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
		return -E_INVAL;
  8010b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b6:	eb f7                	jmp    8010af <fd_lookup+0x39>
		return -E_INVAL;
  8010b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bd:	eb f0                	jmp    8010af <fd_lookup+0x39>
  8010bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c4:	eb e9                	jmp    8010af <fd_lookup+0x39>

008010c6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	b8 88 25 80 00       	mov    $0x802588,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  8010d5:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  8010da:	39 13                	cmp    %edx,(%ebx)
  8010dc:	74 32                	je     801110 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  8010de:	83 c0 04             	add    $0x4,%eax
  8010e1:	8b 18                	mov    (%eax),%ebx
  8010e3:	85 db                	test   %ebx,%ebx
  8010e5:	75 f3                	jne    8010da <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e7:	a1 00 40 80 00       	mov    0x804000,%eax
  8010ec:	8b 40 48             	mov    0x48(%eax),%eax
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	52                   	push   %edx
  8010f3:	50                   	push   %eax
  8010f4:	68 0c 25 80 00       	push   $0x80250c
  8010f9:	e8 00 f1 ff ff       	call   8001fe <cprintf>
	*dev = 0;
	return -E_INVAL;
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801106:	8b 55 0c             	mov    0xc(%ebp),%edx
  801109:	89 1a                	mov    %ebx,(%edx)
}
  80110b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    
			return 0;
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	eb ef                	jmp    801106 <dev_lookup+0x40>

00801117 <fd_close>:
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	83 ec 24             	sub    $0x24,%esp
  801120:	8b 75 08             	mov    0x8(%ebp),%esi
  801123:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801126:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801129:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801130:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801133:	50                   	push   %eax
  801134:	e8 3d ff ff ff       	call   801076 <fd_lookup>
  801139:	89 c3                	mov    %eax,%ebx
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 05                	js     801147 <fd_close+0x30>
	    || fd != fd2)
  801142:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801145:	74 16                	je     80115d <fd_close+0x46>
		return (must_exist ? r : 0);
  801147:	89 f8                	mov    %edi,%eax
  801149:	84 c0                	test   %al,%al
  80114b:	b8 00 00 00 00       	mov    $0x0,%eax
  801150:	0f 44 d8             	cmove  %eax,%ebx
}
  801153:	89 d8                	mov    %ebx,%eax
  801155:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80115d:	83 ec 08             	sub    $0x8,%esp
  801160:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	ff 36                	push   (%esi)
  801166:	e8 5b ff ff ff       	call   8010c6 <dev_lookup>
  80116b:	89 c3                	mov    %eax,%ebx
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	78 1a                	js     80118e <fd_close+0x77>
		if (dev->dev_close)
  801174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801177:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80117a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80117f:	85 c0                	test   %eax,%eax
  801181:	74 0b                	je     80118e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	56                   	push   %esi
  801187:	ff d0                	call   *%eax
  801189:	89 c3                	mov    %eax,%ebx
  80118b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	56                   	push   %esi
  801192:	6a 00                	push   $0x0
  801194:	e8 ab fb ff ff       	call   800d44 <sys_page_unmap>
	return r;
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	eb b5                	jmp    801153 <fd_close+0x3c>

0080119e <close>:

int
close(int fdnum)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a7:	50                   	push   %eax
  8011a8:	ff 75 08             	push   0x8(%ebp)
  8011ab:	e8 c6 fe ff ff       	call   801076 <fd_lookup>
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	79 02                	jns    8011b9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    
		return fd_close(fd, 1);
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	6a 01                	push   $0x1
  8011be:	ff 75 f4             	push   -0xc(%ebp)
  8011c1:	e8 51 ff ff ff       	call   801117 <fd_close>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	eb ec                	jmp    8011b7 <close+0x19>

008011cb <close_all>:

void
close_all(void)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	53                   	push   %ebx
  8011db:	e8 be ff ff ff       	call   80119e <close>
	for (i = 0; i < MAXFD; i++)
  8011e0:	83 c3 01             	add    $0x1,%ebx
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	83 fb 20             	cmp    $0x20,%ebx
  8011e9:	75 ec                	jne    8011d7 <close_all+0xc>
}
  8011eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	57                   	push   %edi
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	ff 75 08             	push   0x8(%ebp)
  801200:	e8 71 fe ff ff       	call   801076 <fd_lookup>
  801205:	89 c3                	mov    %eax,%ebx
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 7f                	js     80128d <dup+0x9d>
		return r;
	close(newfdnum);
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	ff 75 0c             	push   0xc(%ebp)
  801214:	e8 85 ff ff ff       	call   80119e <close>

	newfd = INDEX2FD(newfdnum);
  801219:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121c:	c1 e6 0c             	shl    $0xc,%esi
  80121f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801225:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801228:	89 3c 24             	mov    %edi,(%esp)
  80122b:	e8 df fd ff ff       	call   80100f <fd2data>
  801230:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801232:	89 34 24             	mov    %esi,(%esp)
  801235:	e8 d5 fd ff ff       	call   80100f <fd2data>
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801240:	89 d8                	mov    %ebx,%eax
  801242:	c1 e8 16             	shr    $0x16,%eax
  801245:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124c:	a8 01                	test   $0x1,%al
  80124e:	74 11                	je     801261 <dup+0x71>
  801250:	89 d8                	mov    %ebx,%eax
  801252:	c1 e8 0c             	shr    $0xc,%eax
  801255:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	75 36                	jne    801297 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801261:	89 f8                	mov    %edi,%eax
  801263:	c1 e8 0c             	shr    $0xc,%eax
  801266:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80126d:	83 ec 0c             	sub    $0xc,%esp
  801270:	25 07 0e 00 00       	and    $0xe07,%eax
  801275:	50                   	push   %eax
  801276:	56                   	push   %esi
  801277:	6a 00                	push   $0x0
  801279:	57                   	push   %edi
  80127a:	6a 00                	push   $0x0
  80127c:	e8 81 fa ff ff       	call   800d02 <sys_page_map>
  801281:	89 c3                	mov    %eax,%ebx
  801283:	83 c4 20             	add    $0x20,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	78 33                	js     8012bd <dup+0xcd>
		goto err;

	return newfdnum;
  80128a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80128d:	89 d8                	mov    %ebx,%eax
  80128f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5f                   	pop    %edi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801297:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129e:	83 ec 0c             	sub    $0xc,%esp
  8012a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 d4             	push   -0x2c(%ebp)
  8012aa:	6a 00                	push   $0x0
  8012ac:	53                   	push   %ebx
  8012ad:	6a 00                	push   $0x0
  8012af:	e8 4e fa ff ff       	call   800d02 <sys_page_map>
  8012b4:	89 c3                	mov    %eax,%ebx
  8012b6:	83 c4 20             	add    $0x20,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	79 a4                	jns    801261 <dup+0x71>
	sys_page_unmap(0, newfd);
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	56                   	push   %esi
  8012c1:	6a 00                	push   $0x0
  8012c3:	e8 7c fa ff ff       	call   800d44 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012c8:	83 c4 08             	add    $0x8,%esp
  8012cb:	ff 75 d4             	push   -0x2c(%ebp)
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 6f fa ff ff       	call   800d44 <sys_page_unmap>
	return r;
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	eb b3                	jmp    80128d <dup+0x9d>

008012da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	83 ec 18             	sub    $0x18,%esp
  8012e2:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e8:	50                   	push   %eax
  8012e9:	56                   	push   %esi
  8012ea:	e8 87 fd ff ff       	call   801076 <fd_lookup>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 3c                	js     801332 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f6:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  8012f9:	83 ec 08             	sub    $0x8,%esp
  8012fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	ff 33                	push   (%ebx)
  801302:	e8 bf fd ff ff       	call   8010c6 <dev_lookup>
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 24                	js     801332 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130e:	8b 43 08             	mov    0x8(%ebx),%eax
  801311:	83 e0 03             	and    $0x3,%eax
  801314:	83 f8 01             	cmp    $0x1,%eax
  801317:	74 20                	je     801339 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131c:	8b 40 08             	mov    0x8(%eax),%eax
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 37                	je     80135a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	ff 75 10             	push   0x10(%ebp)
  801329:	ff 75 0c             	push   0xc(%ebp)
  80132c:	53                   	push   %ebx
  80132d:	ff d0                	call   *%eax
  80132f:	83 c4 10             	add    $0x10,%esp
}
  801332:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801339:	a1 00 40 80 00       	mov    0x804000,%eax
  80133e:	8b 40 48             	mov    0x48(%eax),%eax
  801341:	83 ec 04             	sub    $0x4,%esp
  801344:	56                   	push   %esi
  801345:	50                   	push   %eax
  801346:	68 4d 25 80 00       	push   $0x80254d
  80134b:	e8 ae ee ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801358:	eb d8                	jmp    801332 <read+0x58>
		return -E_NOT_SUPP;
  80135a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135f:	eb d1                	jmp    801332 <read+0x58>

00801361 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	57                   	push   %edi
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	eb 02                	jmp    801379 <readn+0x18>
  801377:	01 c3                	add    %eax,%ebx
  801379:	39 f3                	cmp    %esi,%ebx
  80137b:	73 21                	jae    80139e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	89 f0                	mov    %esi,%eax
  801382:	29 d8                	sub    %ebx,%eax
  801384:	50                   	push   %eax
  801385:	89 d8                	mov    %ebx,%eax
  801387:	03 45 0c             	add    0xc(%ebp),%eax
  80138a:	50                   	push   %eax
  80138b:	57                   	push   %edi
  80138c:	e8 49 ff ff ff       	call   8012da <read>
		if (m < 0)
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 04                	js     80139c <readn+0x3b>
			return m;
		if (m == 0)
  801398:	75 dd                	jne    801377 <readn+0x16>
  80139a:	eb 02                	jmp    80139e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80139e:	89 d8                	mov    %ebx,%eax
  8013a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5f                   	pop    %edi
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    

008013a8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	56                   	push   %esi
  8013ac:	53                   	push   %ebx
  8013ad:	83 ec 18             	sub    $0x18,%esp
  8013b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b6:	50                   	push   %eax
  8013b7:	53                   	push   %ebx
  8013b8:	e8 b9 fc ff ff       	call   801076 <fd_lookup>
  8013bd:	83 c4 10             	add    $0x10,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	78 37                	js     8013fb <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c4:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 36                	push   (%esi)
  8013d0:	e8 f1 fc ff ff       	call   8010c6 <dev_lookup>
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	78 1f                	js     8013fb <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013dc:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8013e0:	74 20                	je     801402 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	74 37                	je     801423 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	ff 75 10             	push   0x10(%ebp)
  8013f2:	ff 75 0c             	push   0xc(%ebp)
  8013f5:	56                   	push   %esi
  8013f6:	ff d0                	call   *%eax
  8013f8:	83 c4 10             	add    $0x10,%esp
}
  8013fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801402:	a1 00 40 80 00       	mov    0x804000,%eax
  801407:	8b 40 48             	mov    0x48(%eax),%eax
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	53                   	push   %ebx
  80140e:	50                   	push   %eax
  80140f:	68 69 25 80 00       	push   $0x802569
  801414:	e8 e5 ed ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801421:	eb d8                	jmp    8013fb <write+0x53>
		return -E_NOT_SUPP;
  801423:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801428:	eb d1                	jmp    8013fb <write+0x53>

0080142a <seek>:

int
seek(int fdnum, off_t offset)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801430:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801433:	50                   	push   %eax
  801434:	ff 75 08             	push   0x8(%ebp)
  801437:	e8 3a fc ff ff       	call   801076 <fd_lookup>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 0e                	js     801451 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801449:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	83 ec 18             	sub    $0x18,%esp
  80145b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	53                   	push   %ebx
  801463:	e8 0e fc ff ff       	call   801076 <fd_lookup>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 34                	js     8014a3 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146f:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 36                	push   (%esi)
  80147b:	e8 46 fc ff ff       	call   8010c6 <dev_lookup>
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	85 c0                	test   %eax,%eax
  801485:	78 1c                	js     8014a3 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801487:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80148b:	74 1d                	je     8014aa <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	8b 40 18             	mov    0x18(%eax),%eax
  801493:	85 c0                	test   %eax,%eax
  801495:	74 34                	je     8014cb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	ff 75 0c             	push   0xc(%ebp)
  80149d:	56                   	push   %esi
  80149e:	ff d0                	call   *%eax
  8014a0:	83 c4 10             	add    $0x10,%esp
}
  8014a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5e                   	pop    %esi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014aa:	a1 00 40 80 00       	mov    0x804000,%eax
  8014af:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	53                   	push   %ebx
  8014b6:	50                   	push   %eax
  8014b7:	68 2c 25 80 00       	push   $0x80252c
  8014bc:	e8 3d ed ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c9:	eb d8                	jmp    8014a3 <ftruncate+0x50>
		return -E_NOT_SUPP;
  8014cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d0:	eb d1                	jmp    8014a3 <ftruncate+0x50>

008014d2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 18             	sub    $0x18,%esp
  8014da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 08             	push   0x8(%ebp)
  8014e4:	e8 8d fb ff ff       	call   801076 <fd_lookup>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 49                	js     801539 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f0:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	ff 36                	push   (%esi)
  8014fc:	e8 c5 fb ff ff       	call   8010c6 <dev_lookup>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 31                	js     801539 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80150f:	74 2f                	je     801540 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801511:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801514:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80151b:	00 00 00 
	stat->st_isdir = 0;
  80151e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801525:	00 00 00 
	stat->st_dev = dev;
  801528:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	53                   	push   %ebx
  801532:	56                   	push   %esi
  801533:	ff 50 14             	call   *0x14(%eax)
  801536:	83 c4 10             	add    $0x10,%esp
}
  801539:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153c:	5b                   	pop    %ebx
  80153d:	5e                   	pop    %esi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    
		return -E_NOT_SUPP;
  801540:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801545:	eb f2                	jmp    801539 <fstat+0x67>

00801547 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	56                   	push   %esi
  80154b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	6a 00                	push   $0x0
  801551:	ff 75 08             	push   0x8(%ebp)
  801554:	e8 22 02 00 00       	call   80177b <open>
  801559:	89 c3                	mov    %eax,%ebx
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 1b                	js     80157d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	ff 75 0c             	push   0xc(%ebp)
  801568:	50                   	push   %eax
  801569:	e8 64 ff ff ff       	call   8014d2 <fstat>
  80156e:	89 c6                	mov    %eax,%esi
	close(fd);
  801570:	89 1c 24             	mov    %ebx,(%esp)
  801573:	e8 26 fc ff ff       	call   80119e <close>
	return r;
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	89 f3                	mov    %esi,%ebx
}
  80157d:	89 d8                	mov    %ebx,%eax
  80157f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	89 c6                	mov    %eax,%esi
  80158d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801596:	74 27                	je     8015bf <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801598:	6a 07                	push   $0x7
  80159a:	68 00 50 80 00       	push   $0x805000
  80159f:	56                   	push   %esi
  8015a0:	ff 35 00 60 80 00    	push   0x806000
  8015a6:	e8 db 08 00 00       	call   801e86 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ab:	83 c4 0c             	add    $0xc,%esp
  8015ae:	6a 00                	push   $0x0
  8015b0:	53                   	push   %ebx
  8015b1:	6a 00                	push   $0x0
  8015b3:	e8 7f 08 00 00       	call   801e37 <ipc_recv>
}
  8015b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015bf:	83 ec 0c             	sub    $0xc,%esp
  8015c2:	6a 01                	push   $0x1
  8015c4:	e8 09 09 00 00       	call   801ed2 <ipc_find_env>
  8015c9:	a3 00 60 80 00       	mov    %eax,0x806000
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	eb c5                	jmp    801598 <fsipc+0x12>

008015d3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f1:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f6:	e8 8b ff ff ff       	call   801586 <fsipc>
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <devfile_flush>:
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8b 40 0c             	mov    0xc(%eax),%eax
  801609:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80160e:	ba 00 00 00 00       	mov    $0x0,%edx
  801613:	b8 06 00 00 00       	mov    $0x6,%eax
  801618:	e8 69 ff ff ff       	call   801586 <fsipc>
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <devfile_stat>:
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	53                   	push   %ebx
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8b 40 0c             	mov    0xc(%eax),%eax
  80162f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	b8 05 00 00 00       	mov    $0x5,%eax
  80163e:	e8 43 ff ff ff       	call   801586 <fsipc>
  801643:	85 c0                	test   %eax,%eax
  801645:	78 2c                	js     801673 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	68 00 50 80 00       	push   $0x805000
  80164f:	53                   	push   %ebx
  801650:	e8 6e f2 ff ff       	call   8008c3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801655:	a1 80 50 80 00       	mov    0x805080,%eax
  80165a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801660:	a1 84 50 80 00       	mov    0x805084,%eax
  801665:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <devfile_write>:
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	53                   	push   %ebx
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8b 40 0c             	mov    0xc(%eax),%eax
  801688:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80168d:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801693:	53                   	push   %ebx
  801694:	ff 75 0c             	push   0xc(%ebp)
  801697:	68 08 50 80 00       	push   $0x805008
  80169c:	e8 1a f4 ff ff       	call   800abb <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ab:	e8 d6 fe ff ff       	call   801586 <fsipc>
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	78 0b                	js     8016c2 <devfile_write+0x4a>
	assert(r <= n);
  8016b7:	39 d8                	cmp    %ebx,%eax
  8016b9:	77 0c                	ja     8016c7 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016bb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c0:	7f 1e                	jg     8016e0 <devfile_write+0x68>
}
  8016c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    
	assert(r <= n);
  8016c7:	68 98 25 80 00       	push   $0x802598
  8016cc:	68 9f 25 80 00       	push   $0x80259f
  8016d1:	68 97 00 00 00       	push   $0x97
  8016d6:	68 b4 25 80 00       	push   $0x8025b4
  8016db:	e8 11 07 00 00       	call   801df1 <_panic>
	assert(r <= PGSIZE);
  8016e0:	68 bf 25 80 00       	push   $0x8025bf
  8016e5:	68 9f 25 80 00       	push   $0x80259f
  8016ea:	68 98 00 00 00       	push   $0x98
  8016ef:	68 b4 25 80 00       	push   $0x8025b4
  8016f4:	e8 f8 06 00 00       	call   801df1 <_panic>

008016f9 <devfile_read>:
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	56                   	push   %esi
  8016fd:	53                   	push   %ebx
  8016fe:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8b 40 0c             	mov    0xc(%eax),%eax
  801707:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80170c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	b8 03 00 00 00       	mov    $0x3,%eax
  80171c:	e8 65 fe ff ff       	call   801586 <fsipc>
  801721:	89 c3                	mov    %eax,%ebx
  801723:	85 c0                	test   %eax,%eax
  801725:	78 1f                	js     801746 <devfile_read+0x4d>
	assert(r <= n);
  801727:	39 f0                	cmp    %esi,%eax
  801729:	77 24                	ja     80174f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80172b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801730:	7f 33                	jg     801765 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	50                   	push   %eax
  801736:	68 00 50 80 00       	push   $0x805000
  80173b:	ff 75 0c             	push   0xc(%ebp)
  80173e:	e8 16 f3 ff ff       	call   800a59 <memmove>
	return r;
  801743:	83 c4 10             	add    $0x10,%esp
}
  801746:	89 d8                	mov    %ebx,%eax
  801748:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    
	assert(r <= n);
  80174f:	68 98 25 80 00       	push   $0x802598
  801754:	68 9f 25 80 00       	push   $0x80259f
  801759:	6a 7c                	push   $0x7c
  80175b:	68 b4 25 80 00       	push   $0x8025b4
  801760:	e8 8c 06 00 00       	call   801df1 <_panic>
	assert(r <= PGSIZE);
  801765:	68 bf 25 80 00       	push   $0x8025bf
  80176a:	68 9f 25 80 00       	push   $0x80259f
  80176f:	6a 7d                	push   $0x7d
  801771:	68 b4 25 80 00       	push   $0x8025b4
  801776:	e8 76 06 00 00       	call   801df1 <_panic>

0080177b <open>:
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 1c             	sub    $0x1c,%esp
  801783:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801786:	56                   	push   %esi
  801787:	e8 fc f0 ff ff       	call   800888 <strlen>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801794:	7f 6c                	jg     801802 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179c:	50                   	push   %eax
  80179d:	e8 84 f8 ff ff       	call   801026 <fd_alloc>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 3c                	js     8017e7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	56                   	push   %esi
  8017af:	68 00 50 80 00       	push   $0x805000
  8017b4:	e8 0a f1 ff ff       	call   8008c3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c9:	e8 b8 fd ff ff       	call   801586 <fsipc>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 19                	js     8017f0 <open+0x75>
	return fd2num(fd);
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	ff 75 f4             	push   -0xc(%ebp)
  8017dd:	e8 1d f8 ff ff       	call   800fff <fd2num>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
}
  8017e7:	89 d8                	mov    %ebx,%eax
  8017e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ec:	5b                   	pop    %ebx
  8017ed:	5e                   	pop    %esi
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    
		fd_close(fd, 0);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 f4             	push   -0xc(%ebp)
  8017f8:	e8 1a f9 ff ff       	call   801117 <fd_close>
		return r;
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	eb e5                	jmp    8017e7 <open+0x6c>
		return -E_BAD_PATH;
  801802:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801807:	eb de                	jmp    8017e7 <open+0x6c>

00801809 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80180f:	ba 00 00 00 00       	mov    $0x0,%edx
  801814:	b8 08 00 00 00       	mov    $0x8,%eax
  801819:	e8 68 fd ff ff       	call   801586 <fsipc>
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801820:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801824:	7f 01                	jg     801827 <writebuf+0x7>
  801826:	c3                   	ret    
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801830:	ff 70 04             	push   0x4(%eax)
  801833:	8d 40 10             	lea    0x10(%eax),%eax
  801836:	50                   	push   %eax
  801837:	ff 33                	push   (%ebx)
  801839:	e8 6a fb ff ff       	call   8013a8 <write>
		if (result > 0)
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	7e 03                	jle    801848 <writebuf+0x28>
			b->result += result;
  801845:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801848:	39 43 04             	cmp    %eax,0x4(%ebx)
  80184b:	74 0d                	je     80185a <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80184d:	85 c0                	test   %eax,%eax
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	0f 4f c2             	cmovg  %edx,%eax
  801857:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80185a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <putch>:

static void
putch(int ch, void *thunk)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	53                   	push   %ebx
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801869:	8b 53 04             	mov    0x4(%ebx),%edx
  80186c:	8d 42 01             	lea    0x1(%edx),%eax
  80186f:	89 43 04             	mov    %eax,0x4(%ebx)
  801872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801875:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801879:	3d 00 01 00 00       	cmp    $0x100,%eax
  80187e:	74 05                	je     801885 <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  801880:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801883:	c9                   	leave  
  801884:	c3                   	ret    
		writebuf(b);
  801885:	89 d8                	mov    %ebx,%eax
  801887:	e8 94 ff ff ff       	call   801820 <writebuf>
		b->idx = 0;
  80188c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801893:	eb eb                	jmp    801880 <putch+0x21>

00801895 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018a7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018ae:	00 00 00 
	b.result = 0;
  8018b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018b8:	00 00 00 
	b.error = 1;
  8018bb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018c2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018c5:	ff 75 10             	push   0x10(%ebp)
  8018c8:	ff 75 0c             	push   0xc(%ebp)
  8018cb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	68 5f 18 80 00       	push   $0x80185f
  8018d7:	e8 19 ea ff ff       	call   8002f5 <vprintfmt>
	if (b.idx > 0)
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018e6:	7f 11                	jg     8018f9 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018e8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    
		writebuf(&b);
  8018f9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018ff:	e8 1c ff ff ff       	call   801820 <writebuf>
  801904:	eb e2                	jmp    8018e8 <vfprintf+0x53>

00801906 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80190c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80190f:	50                   	push   %eax
  801910:	ff 75 0c             	push   0xc(%ebp)
  801913:	ff 75 08             	push   0x8(%ebp)
  801916:	e8 7a ff ff ff       	call   801895 <vfprintf>
	va_end(ap);

	return cnt;
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <printf>:

int
printf(const char *fmt, ...)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801923:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801926:	50                   	push   %eax
  801927:	ff 75 08             	push   0x8(%ebp)
  80192a:	6a 01                	push   $0x1
  80192c:	e8 64 ff ff ff       	call   801895 <vfprintf>
	va_end(ap);

	return cnt;
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	ff 75 08             	push   0x8(%ebp)
  801941:	e8 c9 f6 ff ff       	call   80100f <fd2data>
  801946:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801948:	83 c4 08             	add    $0x8,%esp
  80194b:	68 cb 25 80 00       	push   $0x8025cb
  801950:	53                   	push   %ebx
  801951:	e8 6d ef ff ff       	call   8008c3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801956:	8b 46 04             	mov    0x4(%esi),%eax
  801959:	2b 06                	sub    (%esi),%eax
  80195b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801961:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801968:	00 00 00 
	stat->st_dev = &devpipe;
  80196b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801972:	30 80 00 
	return 0;
}
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    

00801981 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	53                   	push   %ebx
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80198b:	53                   	push   %ebx
  80198c:	6a 00                	push   $0x0
  80198e:	e8 b1 f3 ff ff       	call   800d44 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801993:	89 1c 24             	mov    %ebx,(%esp)
  801996:	e8 74 f6 ff ff       	call   80100f <fd2data>
  80199b:	83 c4 08             	add    $0x8,%esp
  80199e:	50                   	push   %eax
  80199f:	6a 00                	push   $0x0
  8019a1:	e8 9e f3 ff ff       	call   800d44 <sys_page_unmap>
}
  8019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <_pipeisclosed>:
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	57                   	push   %edi
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
  8019b1:	83 ec 1c             	sub    $0x1c,%esp
  8019b4:	89 c7                	mov    %eax,%edi
  8019b6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019b8:	a1 00 40 80 00       	mov    0x804000,%eax
  8019bd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	57                   	push   %edi
  8019c4:	e8 42 05 00 00       	call   801f0b <pageref>
  8019c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019cc:	89 34 24             	mov    %esi,(%esp)
  8019cf:	e8 37 05 00 00       	call   801f0b <pageref>
		nn = thisenv->env_runs;
  8019d4:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8019da:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	39 cb                	cmp    %ecx,%ebx
  8019e2:	74 1b                	je     8019ff <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019e7:	75 cf                	jne    8019b8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019e9:	8b 42 58             	mov    0x58(%edx),%eax
  8019ec:	6a 01                	push   $0x1
  8019ee:	50                   	push   %eax
  8019ef:	53                   	push   %ebx
  8019f0:	68 d2 25 80 00       	push   $0x8025d2
  8019f5:	e8 04 e8 ff ff       	call   8001fe <cprintf>
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	eb b9                	jmp    8019b8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a02:	0f 94 c0             	sete   %al
  801a05:	0f b6 c0             	movzbl %al,%eax
}
  801a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    

00801a10 <devpipe_write>:
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	57                   	push   %edi
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
  801a16:	83 ec 28             	sub    $0x28,%esp
  801a19:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a1c:	56                   	push   %esi
  801a1d:	e8 ed f5 ff ff       	call   80100f <fd2data>
  801a22:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	bf 00 00 00 00       	mov    $0x0,%edi
  801a2c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a2f:	75 09                	jne    801a3a <devpipe_write+0x2a>
	return i;
  801a31:	89 f8                	mov    %edi,%eax
  801a33:	eb 23                	jmp    801a58 <devpipe_write+0x48>
			sys_yield();
  801a35:	e8 66 f2 ff ff       	call   800ca0 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a3a:	8b 43 04             	mov    0x4(%ebx),%eax
  801a3d:	8b 0b                	mov    (%ebx),%ecx
  801a3f:	8d 51 20             	lea    0x20(%ecx),%edx
  801a42:	39 d0                	cmp    %edx,%eax
  801a44:	72 1a                	jb     801a60 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801a46:	89 da                	mov    %ebx,%edx
  801a48:	89 f0                	mov    %esi,%eax
  801a4a:	e8 5c ff ff ff       	call   8019ab <_pipeisclosed>
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	74 e2                	je     801a35 <devpipe_write+0x25>
				return 0;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5f                   	pop    %edi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a63:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a67:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a6a:	89 c2                	mov    %eax,%edx
  801a6c:	c1 fa 1f             	sar    $0x1f,%edx
  801a6f:	89 d1                	mov    %edx,%ecx
  801a71:	c1 e9 1b             	shr    $0x1b,%ecx
  801a74:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a77:	83 e2 1f             	and    $0x1f,%edx
  801a7a:	29 ca                	sub    %ecx,%edx
  801a7c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a80:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a84:	83 c0 01             	add    $0x1,%eax
  801a87:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a8a:	83 c7 01             	add    $0x1,%edi
  801a8d:	eb 9d                	jmp    801a2c <devpipe_write+0x1c>

00801a8f <devpipe_read>:
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	57                   	push   %edi
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	83 ec 18             	sub    $0x18,%esp
  801a98:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a9b:	57                   	push   %edi
  801a9c:	e8 6e f5 ff ff       	call   80100f <fd2data>
  801aa1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	be 00 00 00 00       	mov    $0x0,%esi
  801aab:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aae:	75 13                	jne    801ac3 <devpipe_read+0x34>
	return i;
  801ab0:	89 f0                	mov    %esi,%eax
  801ab2:	eb 02                	jmp    801ab6 <devpipe_read+0x27>
				return i;
  801ab4:	89 f0                	mov    %esi,%eax
}
  801ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5f                   	pop    %edi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    
			sys_yield();
  801abe:	e8 dd f1 ff ff       	call   800ca0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ac3:	8b 03                	mov    (%ebx),%eax
  801ac5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ac8:	75 18                	jne    801ae2 <devpipe_read+0x53>
			if (i > 0)
  801aca:	85 f6                	test   %esi,%esi
  801acc:	75 e6                	jne    801ab4 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801ace:	89 da                	mov    %ebx,%edx
  801ad0:	89 f8                	mov    %edi,%eax
  801ad2:	e8 d4 fe ff ff       	call   8019ab <_pipeisclosed>
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	74 e3                	je     801abe <devpipe_read+0x2f>
				return 0;
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae0:	eb d4                	jmp    801ab6 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ae2:	99                   	cltd   
  801ae3:	c1 ea 1b             	shr    $0x1b,%edx
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	83 e0 1f             	and    $0x1f,%eax
  801aeb:	29 d0                	sub    %edx,%eax
  801aed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801af2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801af8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801afb:	83 c6 01             	add    $0x1,%esi
  801afe:	eb ab                	jmp    801aab <devpipe_read+0x1c>

00801b00 <pipe>:
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0b:	50                   	push   %eax
  801b0c:	e8 15 f5 ff ff       	call   801026 <fd_alloc>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	0f 88 23 01 00 00    	js     801c41 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	68 07 04 00 00       	push   $0x407
  801b26:	ff 75 f4             	push   -0xc(%ebp)
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 8f f1 ff ff       	call   800cbf <sys_page_alloc>
  801b30:	89 c3                	mov    %eax,%ebx
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	0f 88 04 01 00 00    	js     801c41 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b3d:	83 ec 0c             	sub    $0xc,%esp
  801b40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b43:	50                   	push   %eax
  801b44:	e8 dd f4 ff ff       	call   801026 <fd_alloc>
  801b49:	89 c3                	mov    %eax,%ebx
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	0f 88 db 00 00 00    	js     801c31 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 07 04 00 00       	push   $0x407
  801b5e:	ff 75 f0             	push   -0x10(%ebp)
  801b61:	6a 00                	push   $0x0
  801b63:	e8 57 f1 ff ff       	call   800cbf <sys_page_alloc>
  801b68:	89 c3                	mov    %eax,%ebx
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	0f 88 bc 00 00 00    	js     801c31 <pipe+0x131>
	va = fd2data(fd0);
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	ff 75 f4             	push   -0xc(%ebp)
  801b7b:	e8 8f f4 ff ff       	call   80100f <fd2data>
  801b80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b82:	83 c4 0c             	add    $0xc,%esp
  801b85:	68 07 04 00 00       	push   $0x407
  801b8a:	50                   	push   %eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	e8 2d f1 ff ff       	call   800cbf <sys_page_alloc>
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	0f 88 82 00 00 00    	js     801c21 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b9f:	83 ec 0c             	sub    $0xc,%esp
  801ba2:	ff 75 f0             	push   -0x10(%ebp)
  801ba5:	e8 65 f4 ff ff       	call   80100f <fd2data>
  801baa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bb1:	50                   	push   %eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	56                   	push   %esi
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 46 f1 ff ff       	call   800d02 <sys_page_map>
  801bbc:	89 c3                	mov    %eax,%ebx
  801bbe:	83 c4 20             	add    $0x20,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	78 4e                	js     801c13 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801bc5:	a1 20 30 80 00       	mov    0x803020,%eax
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801bd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bdc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	ff 75 f4             	push   -0xc(%ebp)
  801bee:	e8 0c f4 ff ff       	call   800fff <fd2num>
  801bf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bf8:	83 c4 04             	add    $0x4,%esp
  801bfb:	ff 75 f0             	push   -0x10(%ebp)
  801bfe:	e8 fc f3 ff ff       	call   800fff <fd2num>
  801c03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c06:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c11:	eb 2e                	jmp    801c41 <pipe+0x141>
	sys_page_unmap(0, va);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	56                   	push   %esi
  801c17:	6a 00                	push   $0x0
  801c19:	e8 26 f1 ff ff       	call   800d44 <sys_page_unmap>
  801c1e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c21:	83 ec 08             	sub    $0x8,%esp
  801c24:	ff 75 f0             	push   -0x10(%ebp)
  801c27:	6a 00                	push   $0x0
  801c29:	e8 16 f1 ff ff       	call   800d44 <sys_page_unmap>
  801c2e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c31:	83 ec 08             	sub    $0x8,%esp
  801c34:	ff 75 f4             	push   -0xc(%ebp)
  801c37:	6a 00                	push   $0x0
  801c39:	e8 06 f1 ff ff       	call   800d44 <sys_page_unmap>
  801c3e:	83 c4 10             	add    $0x10,%esp
}
  801c41:	89 d8                	mov    %ebx,%eax
  801c43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <pipeisclosed>:
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c53:	50                   	push   %eax
  801c54:	ff 75 08             	push   0x8(%ebp)
  801c57:	e8 1a f4 ff ff       	call   801076 <fd_lookup>
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 18                	js     801c7b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c63:	83 ec 0c             	sub    $0xc,%esp
  801c66:	ff 75 f4             	push   -0xc(%ebp)
  801c69:	e8 a1 f3 ff ff       	call   80100f <fd2data>
  801c6e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	e8 33 fd ff ff       	call   8019ab <_pipeisclosed>
  801c78:	83 c4 10             	add    $0x10,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c82:	c3                   	ret    

00801c83 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c89:	68 ea 25 80 00       	push   $0x8025ea
  801c8e:	ff 75 0c             	push   0xc(%ebp)
  801c91:	e8 2d ec ff ff       	call   8008c3 <strcpy>
	return 0;
}
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <devcons_write>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	57                   	push   %edi
  801ca1:	56                   	push   %esi
  801ca2:	53                   	push   %ebx
  801ca3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ca9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801cae:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cb4:	eb 2e                	jmp    801ce4 <devcons_write+0x47>
		m = n - tot;
  801cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cb9:	29 f3                	sub    %esi,%ebx
  801cbb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801cc0:	39 c3                	cmp    %eax,%ebx
  801cc2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	53                   	push   %ebx
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	03 45 0c             	add    0xc(%ebp),%eax
  801cce:	50                   	push   %eax
  801ccf:	57                   	push   %edi
  801cd0:	e8 84 ed ff ff       	call   800a59 <memmove>
		sys_cputs(buf, m);
  801cd5:	83 c4 08             	add    $0x8,%esp
  801cd8:	53                   	push   %ebx
  801cd9:	57                   	push   %edi
  801cda:	e8 24 ef ff ff       	call   800c03 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cdf:	01 de                	add    %ebx,%esi
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce7:	72 cd                	jb     801cb6 <devcons_write+0x19>
}
  801ce9:	89 f0                	mov    %esi,%eax
  801ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5e                   	pop    %esi
  801cf0:	5f                   	pop    %edi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <devcons_read>:
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d02:	75 07                	jne    801d0b <devcons_read+0x18>
  801d04:	eb 1f                	jmp    801d25 <devcons_read+0x32>
		sys_yield();
  801d06:	e8 95 ef ff ff       	call   800ca0 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801d0b:	e8 11 ef ff ff       	call   800c21 <sys_cgetc>
  801d10:	85 c0                	test   %eax,%eax
  801d12:	74 f2                	je     801d06 <devcons_read+0x13>
	if (c < 0)
  801d14:	78 0f                	js     801d25 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801d16:	83 f8 04             	cmp    $0x4,%eax
  801d19:	74 0c                	je     801d27 <devcons_read+0x34>
	*(char*)vbuf = c;
  801d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1e:	88 02                	mov    %al,(%edx)
	return 1;
  801d20:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    
		return 0;
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2c:	eb f7                	jmp    801d25 <devcons_read+0x32>

00801d2e <cputchar>:
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d3a:	6a 01                	push   $0x1
  801d3c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d3f:	50                   	push   %eax
  801d40:	e8 be ee ff ff       	call   800c03 <sys_cputs>
}
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <getchar>:
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d50:	6a 01                	push   $0x1
  801d52:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d55:	50                   	push   %eax
  801d56:	6a 00                	push   $0x0
  801d58:	e8 7d f5 ff ff       	call   8012da <read>
	if (r < 0)
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 06                	js     801d6a <getchar+0x20>
	if (r < 1)
  801d64:	74 06                	je     801d6c <getchar+0x22>
	return c;
  801d66:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    
		return -E_EOF;
  801d6c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d71:	eb f7                	jmp    801d6a <getchar+0x20>

00801d73 <iscons>:
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7c:	50                   	push   %eax
  801d7d:	ff 75 08             	push   0x8(%ebp)
  801d80:	e8 f1 f2 ff ff       	call   801076 <fd_lookup>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 11                	js     801d9d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d95:	39 10                	cmp    %edx,(%eax)
  801d97:	0f 94 c0             	sete   %al
  801d9a:	0f b6 c0             	movzbl %al,%eax
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <opencons>:
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da8:	50                   	push   %eax
  801da9:	e8 78 f2 ff ff       	call   801026 <fd_alloc>
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	85 c0                	test   %eax,%eax
  801db3:	78 3a                	js     801def <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	68 07 04 00 00       	push   $0x407
  801dbd:	ff 75 f4             	push   -0xc(%ebp)
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 f8 ee ff ff       	call   800cbf <sys_page_alloc>
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 21                	js     801def <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dd7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	50                   	push   %eax
  801de7:	e8 13 f2 ff ff       	call   800fff <fd2num>
  801dec:	83 c4 10             	add    $0x10,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	56                   	push   %esi
  801df5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801df6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801df9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801dff:	e8 7d ee ff ff       	call   800c81 <sys_getenvid>
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	ff 75 0c             	push   0xc(%ebp)
  801e0a:	ff 75 08             	push   0x8(%ebp)
  801e0d:	56                   	push   %esi
  801e0e:	50                   	push   %eax
  801e0f:	68 f8 25 80 00       	push   $0x8025f8
  801e14:	e8 e5 e3 ff ff       	call   8001fe <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e19:	83 c4 18             	add    $0x18,%esp
  801e1c:	53                   	push   %ebx
  801e1d:	ff 75 10             	push   0x10(%ebp)
  801e20:	e8 88 e3 ff ff       	call   8001ad <vcprintf>
	cprintf("\n");
  801e25:	c7 04 24 29 26 80 00 	movl   $0x802629,(%esp)
  801e2c:	e8 cd e3 ff ff       	call   8001fe <cprintf>
  801e31:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e34:	cc                   	int3   
  801e35:	eb fd                	jmp    801e34 <_panic+0x43>

00801e37 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	56                   	push   %esi
  801e3b:	53                   	push   %ebx
  801e3c:	8b 75 08             	mov    0x8(%ebp),%esi
  801e3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	ff 75 0c             	push   0xc(%ebp)
  801e48:	e8 22 f0 ff ff       	call   800e6f <sys_ipc_recv>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 2b                	js     801e7f <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e54:	85 f6                	test   %esi,%esi
  801e56:	74 0a                	je     801e62 <ipc_recv+0x2b>
  801e58:	a1 00 40 80 00       	mov    0x804000,%eax
  801e5d:	8b 40 74             	mov    0x74(%eax),%eax
  801e60:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e62:	85 db                	test   %ebx,%ebx
  801e64:	74 0a                	je     801e70 <ipc_recv+0x39>
  801e66:	a1 00 40 80 00       	mov    0x804000,%eax
  801e6b:	8b 40 78             	mov    0x78(%eax),%eax
  801e6e:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801e70:	a1 00 40 80 00       	mov    0x804000,%eax
  801e75:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801e7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e84:	eb f2                	jmp    801e78 <ipc_recv+0x41>

00801e86 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	57                   	push   %edi
  801e8a:	56                   	push   %esi
  801e8b:	53                   	push   %ebx
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e92:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801e98:	ff 75 14             	push   0x14(%ebp)
  801e9b:	53                   	push   %ebx
  801e9c:	56                   	push   %esi
  801e9d:	57                   	push   %edi
  801e9e:	e8 a9 ef ff ff       	call   800e4c <sys_ipc_try_send>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	79 20                	jns    801eca <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801eaa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ead:	75 07                	jne    801eb6 <ipc_send+0x30>
		sys_yield();
  801eaf:	e8 ec ed ff ff       	call   800ca0 <sys_yield>
  801eb4:	eb e2                	jmp    801e98 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 1b 26 80 00       	push   $0x80261b
  801ebe:	6a 2e                	push   $0x2e
  801ec0:	68 2b 26 80 00       	push   $0x80262b
  801ec5:	e8 27 ff ff ff       	call   801df1 <_panic>
	}
}
  801eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecd:	5b                   	pop    %ebx
  801ece:	5e                   	pop    %esi
  801ecf:	5f                   	pop    %edi
  801ed0:	5d                   	pop    %ebp
  801ed1:	c3                   	ret    

00801ed2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801edd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ee0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ee6:	8b 52 50             	mov    0x50(%edx),%edx
  801ee9:	39 ca                	cmp    %ecx,%edx
  801eeb:	74 11                	je     801efe <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801eed:	83 c0 01             	add    $0x1,%eax
  801ef0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ef5:	75 e6                	jne    801edd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	eb 0b                	jmp    801f09 <ipc_find_env+0x37>
			return envs[i].env_id;
  801efe:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f01:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f06:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    

00801f0b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f11:	89 c2                	mov    %eax,%edx
  801f13:	c1 ea 16             	shr    $0x16,%edx
  801f16:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801f22:	f6 c1 01             	test   $0x1,%cl
  801f25:	74 1c                	je     801f43 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801f27:	c1 e8 0c             	shr    $0xc,%eax
  801f2a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801f31:	a8 01                	test   $0x1,%al
  801f33:	74 0e                	je     801f43 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f35:	c1 e8 0c             	shr    $0xc,%eax
  801f38:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801f3f:	ef 
  801f40:	0f b7 d2             	movzwl %dx,%edx
}
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	5d                   	pop    %ebp
  801f46:	c3                   	ret    
  801f47:	66 90                	xchg   %ax,%ax
  801f49:	66 90                	xchg   %ax,%ax
  801f4b:	66 90                	xchg   %ax,%ax
  801f4d:	66 90                	xchg   %ax,%ax
  801f4f:	90                   	nop

00801f50 <__udivdi3>:
  801f50:	f3 0f 1e fb          	endbr32 
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	75 19                	jne    801f88 <__udivdi3+0x38>
  801f6f:	39 f3                	cmp    %esi,%ebx
  801f71:	76 4d                	jbe    801fc0 <__udivdi3+0x70>
  801f73:	31 ff                	xor    %edi,%edi
  801f75:	89 e8                	mov    %ebp,%eax
  801f77:	89 f2                	mov    %esi,%edx
  801f79:	f7 f3                	div    %ebx
  801f7b:	89 fa                	mov    %edi,%edx
  801f7d:	83 c4 1c             	add    $0x1c,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
  801f85:	8d 76 00             	lea    0x0(%esi),%esi
  801f88:	39 f0                	cmp    %esi,%eax
  801f8a:	76 14                	jbe    801fa0 <__udivdi3+0x50>
  801f8c:	31 ff                	xor    %edi,%edi
  801f8e:	31 c0                	xor    %eax,%eax
  801f90:	89 fa                	mov    %edi,%edx
  801f92:	83 c4 1c             	add    $0x1c,%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    
  801f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fa0:	0f bd f8             	bsr    %eax,%edi
  801fa3:	83 f7 1f             	xor    $0x1f,%edi
  801fa6:	75 48                	jne    801ff0 <__udivdi3+0xa0>
  801fa8:	39 f0                	cmp    %esi,%eax
  801faa:	72 06                	jb     801fb2 <__udivdi3+0x62>
  801fac:	31 c0                	xor    %eax,%eax
  801fae:	39 eb                	cmp    %ebp,%ebx
  801fb0:	77 de                	ja     801f90 <__udivdi3+0x40>
  801fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb7:	eb d7                	jmp    801f90 <__udivdi3+0x40>
  801fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fc0:	89 d9                	mov    %ebx,%ecx
  801fc2:	85 db                	test   %ebx,%ebx
  801fc4:	75 0b                	jne    801fd1 <__udivdi3+0x81>
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	f7 f3                	div    %ebx
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	31 d2                	xor    %edx,%edx
  801fd3:	89 f0                	mov    %esi,%eax
  801fd5:	f7 f1                	div    %ecx
  801fd7:	89 c6                	mov    %eax,%esi
  801fd9:	89 e8                	mov    %ebp,%eax
  801fdb:	89 f7                	mov    %esi,%edi
  801fdd:	f7 f1                	div    %ecx
  801fdf:	89 fa                	mov    %edi,%edx
  801fe1:	83 c4 1c             	add    $0x1c,%esp
  801fe4:	5b                   	pop    %ebx
  801fe5:	5e                   	pop    %esi
  801fe6:	5f                   	pop    %edi
  801fe7:	5d                   	pop    %ebp
  801fe8:	c3                   	ret    
  801fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ff0:	89 f9                	mov    %edi,%ecx
  801ff2:	ba 20 00 00 00       	mov    $0x20,%edx
  801ff7:	29 fa                	sub    %edi,%edx
  801ff9:	d3 e0                	shl    %cl,%eax
  801ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fff:	89 d1                	mov    %edx,%ecx
  802001:	89 d8                	mov    %ebx,%eax
  802003:	d3 e8                	shr    %cl,%eax
  802005:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802009:	09 c1                	or     %eax,%ecx
  80200b:	89 f0                	mov    %esi,%eax
  80200d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802011:	89 f9                	mov    %edi,%ecx
  802013:	d3 e3                	shl    %cl,%ebx
  802015:	89 d1                	mov    %edx,%ecx
  802017:	d3 e8                	shr    %cl,%eax
  802019:	89 f9                	mov    %edi,%ecx
  80201b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80201f:	89 eb                	mov    %ebp,%ebx
  802021:	d3 e6                	shl    %cl,%esi
  802023:	89 d1                	mov    %edx,%ecx
  802025:	d3 eb                	shr    %cl,%ebx
  802027:	09 f3                	or     %esi,%ebx
  802029:	89 c6                	mov    %eax,%esi
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	89 d8                	mov    %ebx,%eax
  80202f:	f7 74 24 08          	divl   0x8(%esp)
  802033:	89 d6                	mov    %edx,%esi
  802035:	89 c3                	mov    %eax,%ebx
  802037:	f7 64 24 0c          	mull   0xc(%esp)
  80203b:	39 d6                	cmp    %edx,%esi
  80203d:	72 19                	jb     802058 <__udivdi3+0x108>
  80203f:	89 f9                	mov    %edi,%ecx
  802041:	d3 e5                	shl    %cl,%ebp
  802043:	39 c5                	cmp    %eax,%ebp
  802045:	73 04                	jae    80204b <__udivdi3+0xfb>
  802047:	39 d6                	cmp    %edx,%esi
  802049:	74 0d                	je     802058 <__udivdi3+0x108>
  80204b:	89 d8                	mov    %ebx,%eax
  80204d:	31 ff                	xor    %edi,%edi
  80204f:	e9 3c ff ff ff       	jmp    801f90 <__udivdi3+0x40>
  802054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802058:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80205b:	31 ff                	xor    %edi,%edi
  80205d:	e9 2e ff ff ff       	jmp    801f90 <__udivdi3+0x40>
  802062:	66 90                	xchg   %ax,%ax
  802064:	66 90                	xchg   %ax,%ax
  802066:	66 90                	xchg   %ax,%ax
  802068:	66 90                	xchg   %ax,%ax
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <__umoddi3>:
  802070:	f3 0f 1e fb          	endbr32 
  802074:	55                   	push   %ebp
  802075:	57                   	push   %edi
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	83 ec 1c             	sub    $0x1c,%esp
  80207b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80207f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802083:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802087:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80208b:	89 f0                	mov    %esi,%eax
  80208d:	89 da                	mov    %ebx,%edx
  80208f:	85 ff                	test   %edi,%edi
  802091:	75 15                	jne    8020a8 <__umoddi3+0x38>
  802093:	39 dd                	cmp    %ebx,%ebp
  802095:	76 39                	jbe    8020d0 <__umoddi3+0x60>
  802097:	f7 f5                	div    %ebp
  802099:	89 d0                	mov    %edx,%eax
  80209b:	31 d2                	xor    %edx,%edx
  80209d:	83 c4 1c             	add    $0x1c,%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5f                   	pop    %edi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	39 df                	cmp    %ebx,%edi
  8020aa:	77 f1                	ja     80209d <__umoddi3+0x2d>
  8020ac:	0f bd cf             	bsr    %edi,%ecx
  8020af:	83 f1 1f             	xor    $0x1f,%ecx
  8020b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020b6:	75 40                	jne    8020f8 <__umoddi3+0x88>
  8020b8:	39 df                	cmp    %ebx,%edi
  8020ba:	72 04                	jb     8020c0 <__umoddi3+0x50>
  8020bc:	39 f5                	cmp    %esi,%ebp
  8020be:	77 dd                	ja     80209d <__umoddi3+0x2d>
  8020c0:	89 da                	mov    %ebx,%edx
  8020c2:	89 f0                	mov    %esi,%eax
  8020c4:	29 e8                	sub    %ebp,%eax
  8020c6:	19 fa                	sbb    %edi,%edx
  8020c8:	eb d3                	jmp    80209d <__umoddi3+0x2d>
  8020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020d0:	89 e9                	mov    %ebp,%ecx
  8020d2:	85 ed                	test   %ebp,%ebp
  8020d4:	75 0b                	jne    8020e1 <__umoddi3+0x71>
  8020d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020db:	31 d2                	xor    %edx,%edx
  8020dd:	f7 f5                	div    %ebp
  8020df:	89 c1                	mov    %eax,%ecx
  8020e1:	89 d8                	mov    %ebx,%eax
  8020e3:	31 d2                	xor    %edx,%edx
  8020e5:	f7 f1                	div    %ecx
  8020e7:	89 f0                	mov    %esi,%eax
  8020e9:	f7 f1                	div    %ecx
  8020eb:	89 d0                	mov    %edx,%eax
  8020ed:	31 d2                	xor    %edx,%edx
  8020ef:	eb ac                	jmp    80209d <__umoddi3+0x2d>
  8020f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020fc:	ba 20 00 00 00       	mov    $0x20,%edx
  802101:	29 c2                	sub    %eax,%edx
  802103:	89 c1                	mov    %eax,%ecx
  802105:	89 e8                	mov    %ebp,%eax
  802107:	d3 e7                	shl    %cl,%edi
  802109:	89 d1                	mov    %edx,%ecx
  80210b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80210f:	d3 e8                	shr    %cl,%eax
  802111:	89 c1                	mov    %eax,%ecx
  802113:	8b 44 24 04          	mov    0x4(%esp),%eax
  802117:	09 f9                	or     %edi,%ecx
  802119:	89 df                	mov    %ebx,%edi
  80211b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	d3 e5                	shl    %cl,%ebp
  802123:	89 d1                	mov    %edx,%ecx
  802125:	d3 ef                	shr    %cl,%edi
  802127:	89 c1                	mov    %eax,%ecx
  802129:	89 f0                	mov    %esi,%eax
  80212b:	d3 e3                	shl    %cl,%ebx
  80212d:	89 d1                	mov    %edx,%ecx
  80212f:	89 fa                	mov    %edi,%edx
  802131:	d3 e8                	shr    %cl,%eax
  802133:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802138:	09 d8                	or     %ebx,%eax
  80213a:	f7 74 24 08          	divl   0x8(%esp)
  80213e:	89 d3                	mov    %edx,%ebx
  802140:	d3 e6                	shl    %cl,%esi
  802142:	f7 e5                	mul    %ebp
  802144:	89 c7                	mov    %eax,%edi
  802146:	89 d1                	mov    %edx,%ecx
  802148:	39 d3                	cmp    %edx,%ebx
  80214a:	72 06                	jb     802152 <__umoddi3+0xe2>
  80214c:	75 0e                	jne    80215c <__umoddi3+0xec>
  80214e:	39 c6                	cmp    %eax,%esi
  802150:	73 0a                	jae    80215c <__umoddi3+0xec>
  802152:	29 e8                	sub    %ebp,%eax
  802154:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802158:	89 d1                	mov    %edx,%ecx
  80215a:	89 c7                	mov    %eax,%edi
  80215c:	89 f5                	mov    %esi,%ebp
  80215e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802162:	29 fd                	sub    %edi,%ebp
  802164:	19 cb                	sbb    %ecx,%ebx
  802166:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80216b:	89 d8                	mov    %ebx,%eax
  80216d:	d3 e0                	shl    %cl,%eax
  80216f:	89 f1                	mov    %esi,%ecx
  802171:	d3 ed                	shr    %cl,%ebp
  802173:	d3 eb                	shr    %cl,%ebx
  802175:	09 e8                	or     %ebp,%eax
  802177:	89 da                	mov    %ebx,%edx
  802179:	83 c4 1c             	add    $0x1c,%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    
