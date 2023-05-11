
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 40 	movl   $0x802540,0x803000
  800045:	25 80 00 

	cprintf("icode startup\n");
  800048:	68 46 25 80 00       	push   $0x802546
  80004d:	e8 15 02 00 00       	call   800267 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 55 25 80 00 	movl   $0x802555,(%esp)
  800059:	e8 09 02 00 00       	call   800267 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 68 25 80 00       	push   $0x802568
  800068:	e8 28 16 00 00       	call   801695 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 91 25 80 00       	push   $0x802591
  80007e:	e8 e4 01 00 00       	call   800267 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 6e 25 80 00       	push   $0x80256e
  800094:	6a 0f                	push   $0xf
  800096:	68 84 25 80 00       	push   $0x802584
  80009b:	e8 ec 00 00 00       	call   80018c <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 c2 0b 00 00       	call   800c6c <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 38 11 00 00       	call   8011f4 <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 a4 25 80 00       	push   $0x8025a4
  8000cb:	e8 97 01 00 00       	call   800267 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 e0 0f 00 00       	call   8010b8 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 b8 25 80 00 	movl   $0x8025b8,(%esp)
  8000df:	e8 83 01 00 00       	call   800267 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 cc 25 80 00       	push   $0x8025cc
  8000f0:	68 d5 25 80 00       	push   $0x8025d5
  8000f5:	68 df 25 80 00       	push   $0x8025df
  8000fa:	68 de 25 80 00       	push   $0x8025de
  8000ff:	e8 77 1b 00 00       	call   801c7b <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 fb 25 80 00       	push   $0x8025fb
  800113:	e8 4f 01 00 00       	call   800267 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 e4 25 80 00       	push   $0x8025e4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 84 25 80 00       	push   $0x802584
  80012f:	e8 58 00 00 00       	call   80018c <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 a6 0b 00 00       	call   800cea <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800180:	6a 00                	push   $0x0
  800182:	e8 22 0b 00 00       	call   800ca9 <sys_env_destroy>
}
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800191:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800194:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019a:	e8 4b 0b 00 00       	call   800cea <sys_getenvid>
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	ff 75 0c             	push   0xc(%ebp)
  8001a5:	ff 75 08             	push   0x8(%ebp)
  8001a8:	56                   	push   %esi
  8001a9:	50                   	push   %eax
  8001aa:	68 18 26 80 00       	push   $0x802618
  8001af:	e8 b3 00 00 00       	call   800267 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b4:	83 c4 18             	add    $0x18,%esp
  8001b7:	53                   	push   %ebx
  8001b8:	ff 75 10             	push   0x10(%ebp)
  8001bb:	e8 56 00 00 00       	call   800216 <vcprintf>
	cprintf("\n");
  8001c0:	c7 04 24 ff 2a 80 00 	movl   $0x802aff,(%esp)
  8001c7:	e8 9b 00 00 00       	call   800267 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cf:	cc                   	int3   
  8001d0:	eb fd                	jmp    8001cf <_panic+0x43>

008001d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001dc:	8b 13                	mov    (%ebx),%edx
  8001de:	8d 42 01             	lea    0x1(%edx),%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
  8001e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ef:	74 09                	je     8001fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	68 ff 00 00 00       	push   $0xff
  800202:	8d 43 08             	lea    0x8(%ebx),%eax
  800205:	50                   	push   %eax
  800206:	e8 61 0a 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  80020b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb db                	jmp    8001f1 <putch+0x1f>

00800216 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800226:	00 00 00 
	b.cnt = 0;
  800229:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800230:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800233:	ff 75 0c             	push   0xc(%ebp)
  800236:	ff 75 08             	push   0x8(%ebp)
  800239:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	68 d2 01 80 00       	push   $0x8001d2
  800245:	e8 14 01 00 00       	call   80035e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024a:	83 c4 08             	add    $0x8,%esp
  80024d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800253:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800259:	50                   	push   %eax
  80025a:	e8 0d 0a 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  80025f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800270:	50                   	push   %eax
  800271:	ff 75 08             	push   0x8(%ebp)
  800274:	e8 9d ff ff ff       	call   800216 <vcprintf>
	va_end(ap);

	return cnt;
}
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 1c             	sub    $0x1c,%esp
  800284:	89 c7                	mov    %eax,%edi
  800286:	89 d6                	mov    %edx,%esi
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 d1                	mov    %edx,%ecx
  800290:	89 c2                	mov    %eax,%edx
  800292:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800295:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800298:	8b 45 10             	mov    0x10(%ebp),%eax
  80029b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002a8:	39 c2                	cmp    %eax,%edx
  8002aa:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ad:	72 3e                	jb     8002ed <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	ff 75 18             	push   0x18(%ebp)
  8002b5:	83 eb 01             	sub    $0x1,%ebx
  8002b8:	53                   	push   %ebx
  8002b9:	50                   	push   %eax
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	ff 75 e4             	push   -0x1c(%ebp)
  8002c0:	ff 75 e0             	push   -0x20(%ebp)
  8002c3:	ff 75 dc             	push   -0x24(%ebp)
  8002c6:	ff 75 d8             	push   -0x28(%ebp)
  8002c9:	e8 22 20 00 00       	call   8022f0 <__udivdi3>
  8002ce:	83 c4 18             	add    $0x18,%esp
  8002d1:	52                   	push   %edx
  8002d2:	50                   	push   %eax
  8002d3:	89 f2                	mov    %esi,%edx
  8002d5:	89 f8                	mov    %edi,%eax
  8002d7:	e8 9f ff ff ff       	call   80027b <printnum>
  8002dc:	83 c4 20             	add    $0x20,%esp
  8002df:	eb 13                	jmp    8002f4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	56                   	push   %esi
  8002e5:	ff 75 18             	push   0x18(%ebp)
  8002e8:	ff d7                	call   *%edi
  8002ea:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ed:	83 eb 01             	sub    $0x1,%ebx
  8002f0:	85 db                	test   %ebx,%ebx
  8002f2:	7f ed                	jg     8002e1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	56                   	push   %esi
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	ff 75 e4             	push   -0x1c(%ebp)
  8002fe:	ff 75 e0             	push   -0x20(%ebp)
  800301:	ff 75 dc             	push   -0x24(%ebp)
  800304:	ff 75 d8             	push   -0x28(%ebp)
  800307:	e8 04 21 00 00       	call   802410 <__umoddi3>
  80030c:	83 c4 14             	add    $0x14,%esp
  80030f:	0f be 80 3b 26 80 00 	movsbl 0x80263b(%eax),%eax
  800316:	50                   	push   %eax
  800317:	ff d7                	call   *%edi
}
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031f:	5b                   	pop    %ebx
  800320:	5e                   	pop    %esi
  800321:	5f                   	pop    %edi
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80032a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	3b 50 04             	cmp    0x4(%eax),%edx
  800333:	73 0a                	jae    80033f <sprintputch+0x1b>
		*b->buf++ = ch;
  800335:	8d 4a 01             	lea    0x1(%edx),%ecx
  800338:	89 08                	mov    %ecx,(%eax)
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	88 02                	mov    %al,(%edx)
}
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <printfmt>:
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800347:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80034a:	50                   	push   %eax
  80034b:	ff 75 10             	push   0x10(%ebp)
  80034e:	ff 75 0c             	push   0xc(%ebp)
  800351:	ff 75 08             	push   0x8(%ebp)
  800354:	e8 05 00 00 00       	call   80035e <vprintfmt>
}
  800359:	83 c4 10             	add    $0x10,%esp
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <vprintfmt>:
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
  800364:	83 ec 3c             	sub    $0x3c,%esp
  800367:	8b 75 08             	mov    0x8(%ebp),%esi
  80036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80036d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800370:	eb 0a                	jmp    80037c <vprintfmt+0x1e>
			putch(ch, putdat);
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	53                   	push   %ebx
  800376:	50                   	push   %eax
  800377:	ff d6                	call   *%esi
  800379:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80037c:	83 c7 01             	add    $0x1,%edi
  80037f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800383:	83 f8 25             	cmp    $0x25,%eax
  800386:	74 0c                	je     800394 <vprintfmt+0x36>
			if (ch == '\0')
  800388:	85 c0                	test   %eax,%eax
  80038a:	75 e6                	jne    800372 <vprintfmt+0x14>
}
  80038c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038f:	5b                   	pop    %ebx
  800390:	5e                   	pop    %esi
  800391:	5f                   	pop    %edi
  800392:	5d                   	pop    %ebp
  800393:	c3                   	ret    
		padc = ' ';
  800394:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800398:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80039f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8003a6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003ad:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b2:	8d 47 01             	lea    0x1(%edi),%eax
  8003b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b8:	0f b6 17             	movzbl (%edi),%edx
  8003bb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003be:	3c 55                	cmp    $0x55,%al
  8003c0:	0f 87 a6 04 00 00    	ja     80086c <vprintfmt+0x50e>
  8003c6:	0f b6 c0             	movzbl %al,%eax
  8003c9:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  8003d0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8003d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d7:	eb d9                	jmp    8003b2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8003dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003e0:	eb d0                	jmp    8003b2 <vprintfmt+0x54>
  8003e2:	0f b6 d2             	movzbl %dl,%edx
  8003e5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8003f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003fa:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003fd:	83 f9 09             	cmp    $0x9,%ecx
  800400:	77 55                	ja     800457 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800402:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800405:	eb e9                	jmp    8003f0 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8d 40 04             	lea    0x4(%eax),%eax
  800415:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80041b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80041f:	79 91                	jns    8003b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800424:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800427:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80042e:	eb 82                	jmp    8003b2 <vprintfmt+0x54>
  800430:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
  80043a:	0f 49 c2             	cmovns %edx,%eax
  80043d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800443:	e9 6a ff ff ff       	jmp    8003b2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800448:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80044b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800452:	e9 5b ff ff ff       	jmp    8003b2 <vprintfmt+0x54>
  800457:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045d:	eb bc                	jmp    80041b <vprintfmt+0xbd>
			lflag++;
  80045f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800462:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800465:	e9 48 ff ff ff       	jmp    8003b2 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8d 78 04             	lea    0x4(%eax),%edi
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	ff 30                	push   (%eax)
  800476:	ff d6                	call   *%esi
			break;
  800478:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80047e:	e9 88 03 00 00       	jmp    80080b <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	8d 78 04             	lea    0x4(%eax),%edi
  800489:	8b 10                	mov    (%eax),%edx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	f7 d8                	neg    %eax
  80048f:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800492:	83 f8 0f             	cmp    $0xf,%eax
  800495:	7f 23                	jg     8004ba <vprintfmt+0x15c>
  800497:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  80049e:	85 d2                	test   %edx,%edx
  8004a0:	74 18                	je     8004ba <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8004a2:	52                   	push   %edx
  8004a3:	68 11 2a 80 00       	push   $0x802a11
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 92 fe ff ff       	call   800341 <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004b5:	e9 51 03 00 00       	jmp    80080b <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8004ba:	50                   	push   %eax
  8004bb:	68 53 26 80 00       	push   $0x802653
  8004c0:	53                   	push   %ebx
  8004c1:	56                   	push   %esi
  8004c2:	e8 7a fe ff ff       	call   800341 <printfmt>
  8004c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ca:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004cd:	e9 39 03 00 00       	jmp    80080b <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	83 c0 04             	add    $0x4,%eax
  8004d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004e0:	85 d2                	test   %edx,%edx
  8004e2:	b8 4c 26 80 00       	mov    $0x80264c,%eax
  8004e7:	0f 45 c2             	cmovne %edx,%eax
  8004ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f1:	7e 06                	jle    8004f9 <vprintfmt+0x19b>
  8004f3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004f7:	75 0d                	jne    800506 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004fc:	89 c7                	mov    %eax,%edi
  8004fe:	03 45 d4             	add    -0x2c(%ebp),%eax
  800501:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800504:	eb 55                	jmp    80055b <vprintfmt+0x1fd>
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 e0             	push   -0x20(%ebp)
  80050c:	ff 75 cc             	push   -0x34(%ebp)
  80050f:	e8 f5 03 00 00       	call   800909 <strnlen>
  800514:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800517:	29 c2                	sub    %eax,%edx
  800519:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800521:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800525:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800528:	eb 0f                	jmp    800539 <vprintfmt+0x1db>
					putch(padc, putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	53                   	push   %ebx
  80052e:	ff 75 d4             	push   -0x2c(%ebp)
  800531:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800533:	83 ef 01             	sub    $0x1,%edi
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	85 ff                	test   %edi,%edi
  80053b:	7f ed                	jg     80052a <vprintfmt+0x1cc>
  80053d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800540:	85 d2                	test   %edx,%edx
  800542:	b8 00 00 00 00       	mov    $0x0,%eax
  800547:	0f 49 c2             	cmovns %edx,%eax
  80054a:	29 c2                	sub    %eax,%edx
  80054c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80054f:	eb a8                	jmp    8004f9 <vprintfmt+0x19b>
					putch(ch, putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	53                   	push   %ebx
  800555:	52                   	push   %edx
  800556:	ff d6                	call   *%esi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80055e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800560:	83 c7 01             	add    $0x1,%edi
  800563:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800567:	0f be d0             	movsbl %al,%edx
  80056a:	85 d2                	test   %edx,%edx
  80056c:	74 4b                	je     8005b9 <vprintfmt+0x25b>
  80056e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800572:	78 06                	js     80057a <vprintfmt+0x21c>
  800574:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800578:	78 1e                	js     800598 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80057a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80057e:	74 d1                	je     800551 <vprintfmt+0x1f3>
  800580:	0f be c0             	movsbl %al,%eax
  800583:	83 e8 20             	sub    $0x20,%eax
  800586:	83 f8 5e             	cmp    $0x5e,%eax
  800589:	76 c6                	jbe    800551 <vprintfmt+0x1f3>
					putch('?', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	6a 3f                	push   $0x3f
  800591:	ff d6                	call   *%esi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	eb c3                	jmp    80055b <vprintfmt+0x1fd>
  800598:	89 cf                	mov    %ecx,%edi
  80059a:	eb 0e                	jmp    8005aa <vprintfmt+0x24c>
				putch(' ', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 20                	push   $0x20
  8005a2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a4:	83 ef 01             	sub    $0x1,%edi
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	85 ff                	test   %edi,%edi
  8005ac:	7f ee                	jg     80059c <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b4:	e9 52 02 00 00       	jmp    80080b <vprintfmt+0x4ad>
  8005b9:	89 cf                	mov    %ecx,%edi
  8005bb:	eb ed                	jmp    8005aa <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	83 c0 04             	add    $0x4,%eax
  8005c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	b8 4c 26 80 00       	mov    $0x80264c,%eax
  8005d2:	0f 45 c2             	cmovne %edx,%eax
  8005d5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005dc:	7e 06                	jle    8005e4 <vprintfmt+0x286>
  8005de:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005e2:	75 0d                	jne    8005f1 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e7:	89 c7                	mov    %eax,%edi
  8005e9:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005ef:	eb 55                	jmp    800646 <vprintfmt+0x2e8>
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 e0             	push   -0x20(%ebp)
  8005f7:	ff 75 cc             	push   -0x34(%ebp)
  8005fa:	e8 0a 03 00 00       	call   800909 <strnlen>
  8005ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800602:	29 c2                	sub    %eax,%edx
  800604:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80060c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800610:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	eb 0f                	jmp    800624 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	ff 75 d4             	push   -0x2c(%ebp)
  80061c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	83 ef 01             	sub    $0x1,%edi
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	85 ff                	test   %edi,%edi
  800626:	7f ed                	jg     800615 <vprintfmt+0x2b7>
  800628:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80062b:	85 d2                	test   %edx,%edx
  80062d:	b8 00 00 00 00       	mov    $0x0,%eax
  800632:	0f 49 c2             	cmovns %edx,%eax
  800635:	29 c2                	sub    %eax,%edx
  800637:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80063a:	eb a8                	jmp    8005e4 <vprintfmt+0x286>
					putch(ch, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	52                   	push   %edx
  800641:	ff d6                	call   *%esi
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800649:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80064b:	83 c7 01             	add    $0x1,%edi
  80064e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800652:	0f be d0             	movsbl %al,%edx
  800655:	3c 3a                	cmp    $0x3a,%al
  800657:	74 4b                	je     8006a4 <vprintfmt+0x346>
  800659:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065d:	78 06                	js     800665 <vprintfmt+0x307>
  80065f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800663:	78 1e                	js     800683 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800665:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800669:	74 d1                	je     80063c <vprintfmt+0x2de>
  80066b:	0f be c0             	movsbl %al,%eax
  80066e:	83 e8 20             	sub    $0x20,%eax
  800671:	83 f8 5e             	cmp    $0x5e,%eax
  800674:	76 c6                	jbe    80063c <vprintfmt+0x2de>
					putch('?', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 3f                	push   $0x3f
  80067c:	ff d6                	call   *%esi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	eb c3                	jmp    800646 <vprintfmt+0x2e8>
  800683:	89 cf                	mov    %ecx,%edi
  800685:	eb 0e                	jmp    800695 <vprintfmt+0x337>
				putch(' ', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	6a 20                	push   $0x20
  80068d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80068f:	83 ef 01             	sub    $0x1,%edi
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	85 ff                	test   %edi,%edi
  800697:	7f ee                	jg     800687 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	e9 67 01 00 00       	jmp    80080b <vprintfmt+0x4ad>
  8006a4:	89 cf                	mov    %ecx,%edi
  8006a6:	eb ed                	jmp    800695 <vprintfmt+0x337>
	if (lflag >= 2)
  8006a8:	83 f9 01             	cmp    $0x1,%ecx
  8006ab:	7f 1b                	jg     8006c8 <vprintfmt+0x36a>
	else if (lflag)
  8006ad:	85 c9                	test   %ecx,%ecx
  8006af:	74 63                	je     800714 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b9:	99                   	cltd   
  8006ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8d 40 04             	lea    0x4(%eax),%eax
  8006c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c6:	eb 17                	jmp    8006df <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 08             	lea    0x8(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8006e5:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006ea:	85 c9                	test   %ecx,%ecx
  8006ec:	0f 89 ff 00 00 00    	jns    8007f1 <vprintfmt+0x493>
				putch('-', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 2d                	push   $0x2d
  8006f8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800700:	f7 da                	neg    %edx
  800702:	83 d1 00             	adc    $0x0,%ecx
  800705:	f7 d9                	neg    %ecx
  800707:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80070a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80070f:	e9 dd 00 00 00       	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80071c:	99                   	cltd   
  80071d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 04             	lea    0x4(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
  800729:	eb b4                	jmp    8006df <vprintfmt+0x381>
	if (lflag >= 2)
  80072b:	83 f9 01             	cmp    $0x1,%ecx
  80072e:	7f 1e                	jg     80074e <vprintfmt+0x3f0>
	else if (lflag)
  800730:	85 c9                	test   %ecx,%ecx
  800732:	74 32                	je     800766 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800744:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800749:	e9 a3 00 00 00       	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 10                	mov    (%eax),%edx
  800753:	8b 48 04             	mov    0x4(%eax),%ecx
  800756:	8d 40 08             	lea    0x8(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800761:	e9 8b 00 00 00       	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 10                	mov    (%eax),%edx
  80076b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800776:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80077b:	eb 74                	jmp    8007f1 <vprintfmt+0x493>
	if (lflag >= 2)
  80077d:	83 f9 01             	cmp    $0x1,%ecx
  800780:	7f 1b                	jg     80079d <vprintfmt+0x43f>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	74 2c                	je     8007b2 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800796:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80079b:	eb 54                	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a5:	8d 40 08             	lea    0x8(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ab:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8007b0:	eb 3f                	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c2:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8007c7:	eb 28                	jmp    8007f1 <vprintfmt+0x493>
			putch('0', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	53                   	push   %ebx
  8007cd:	6a 30                	push   $0x30
  8007cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d1:	83 c4 08             	add    $0x8,%esp
  8007d4:	53                   	push   %ebx
  8007d5:	6a 78                	push   $0x78
  8007d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 10                	mov    (%eax),%edx
  8007de:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007e3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8007f1:	83 ec 0c             	sub    $0xc,%esp
  8007f4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007f8:	50                   	push   %eax
  8007f9:	ff 75 d4             	push   -0x2c(%ebp)
  8007fc:	57                   	push   %edi
  8007fd:	51                   	push   %ecx
  8007fe:	52                   	push   %edx
  8007ff:	89 da                	mov    %ebx,%edx
  800801:	89 f0                	mov    %esi,%eax
  800803:	e8 73 fa ff ff       	call   80027b <printnum>
			break;
  800808:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80080b:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080e:	e9 69 fb ff ff       	jmp    80037c <vprintfmt+0x1e>
	if (lflag >= 2)
  800813:	83 f9 01             	cmp    $0x1,%ecx
  800816:	7f 1b                	jg     800833 <vprintfmt+0x4d5>
	else if (lflag)
  800818:	85 c9                	test   %ecx,%ecx
  80081a:	74 2c                	je     800848 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	b9 00 00 00 00       	mov    $0x0,%ecx
  800826:	8d 40 04             	lea    0x4(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800831:	eb be                	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	8b 48 04             	mov    0x4(%eax),%ecx
  80083b:	8d 40 08             	lea    0x8(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800841:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800846:	eb a9                	jmp    8007f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 10                	mov    (%eax),%edx
  80084d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800858:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  80085d:	eb 92                	jmp    8007f1 <vprintfmt+0x493>
			putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 25                	push   $0x25
  800865:	ff d6                	call   *%esi
			break;
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	eb 9f                	jmp    80080b <vprintfmt+0x4ad>
			putch('%', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 25                	push   $0x25
  800872:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 f8                	mov    %edi,%eax
  800879:	eb 03                	jmp    80087e <vprintfmt+0x520>
  80087b:	83 e8 01             	sub    $0x1,%eax
  80087e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800882:	75 f7                	jne    80087b <vprintfmt+0x51d>
  800884:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800887:	eb 82                	jmp    80080b <vprintfmt+0x4ad>

00800889 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	83 ec 18             	sub    $0x18,%esp
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800895:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800898:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	74 26                	je     8008d0 <vsnprintf+0x47>
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	7e 22                	jle    8008d0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ae:	ff 75 14             	push   0x14(%ebp)
  8008b1:	ff 75 10             	push   0x10(%ebp)
  8008b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b7:	50                   	push   %eax
  8008b8:	68 24 03 80 00       	push   $0x800324
  8008bd:	e8 9c fa ff ff       	call   80035e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
}
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    
		return -E_INVAL;
  8008d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d5:	eb f7                	jmp    8008ce <vsnprintf+0x45>

008008d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e0:	50                   	push   %eax
  8008e1:	ff 75 10             	push   0x10(%ebp)
  8008e4:	ff 75 0c             	push   0xc(%ebp)
  8008e7:	ff 75 08             	push   0x8(%ebp)
  8008ea:	e8 9a ff ff ff       	call   800889 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fc:	eb 03                	jmp    800901 <strlen+0x10>
		n++;
  8008fe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800901:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800905:	75 f7                	jne    8008fe <strlen+0xd>
	return n;
}
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	eb 03                	jmp    80091c <strnlen+0x13>
		n++;
  800919:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091c:	39 d0                	cmp    %edx,%eax
  80091e:	74 08                	je     800928 <strnlen+0x1f>
  800920:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800924:	75 f3                	jne    800919 <strnlen+0x10>
  800926:	89 c2                	mov    %eax,%edx
	return n;
}
  800928:	89 d0                	mov    %edx,%eax
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800933:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
  80093b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80093f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800942:	83 c0 01             	add    $0x1,%eax
  800945:	84 d2                	test   %dl,%dl
  800947:	75 f2                	jne    80093b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800949:	89 c8                	mov    %ecx,%eax
  80094b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	53                   	push   %ebx
  800954:	83 ec 10             	sub    $0x10,%esp
  800957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095a:	53                   	push   %ebx
  80095b:	e8 91 ff ff ff       	call   8008f1 <strlen>
  800960:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800963:	ff 75 0c             	push   0xc(%ebp)
  800966:	01 d8                	add    %ebx,%eax
  800968:	50                   	push   %eax
  800969:	e8 be ff ff ff       	call   80092c <strcpy>
	return dst;
}
  80096e:	89 d8                	mov    %ebx,%eax
  800970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	56                   	push   %esi
  800979:	53                   	push   %ebx
  80097a:	8b 75 08             	mov    0x8(%ebp),%esi
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	89 f3                	mov    %esi,%ebx
  800982:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800985:	89 f0                	mov    %esi,%eax
  800987:	eb 0f                	jmp    800998 <strncpy+0x23>
		*dst++ = *src;
  800989:	83 c0 01             	add    $0x1,%eax
  80098c:	0f b6 0a             	movzbl (%edx),%ecx
  80098f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800992:	80 f9 01             	cmp    $0x1,%cl
  800995:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800998:	39 d8                	cmp    %ebx,%eax
  80099a:	75 ed                	jne    800989 <strncpy+0x14>
	}
	return ret;
}
  80099c:	89 f0                	mov    %esi,%eax
  80099e:	5b                   	pop    %ebx
  80099f:	5e                   	pop    %esi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	56                   	push   %esi
  8009a6:	53                   	push   %ebx
  8009a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b2:	85 d2                	test   %edx,%edx
  8009b4:	74 21                	je     8009d7 <strlcpy+0x35>
  8009b6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ba:	89 f2                	mov    %esi,%edx
  8009bc:	eb 09                	jmp    8009c7 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009be:	83 c1 01             	add    $0x1,%ecx
  8009c1:	83 c2 01             	add    $0x1,%edx
  8009c4:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8009c7:	39 c2                	cmp    %eax,%edx
  8009c9:	74 09                	je     8009d4 <strlcpy+0x32>
  8009cb:	0f b6 19             	movzbl (%ecx),%ebx
  8009ce:	84 db                	test   %bl,%bl
  8009d0:	75 ec                	jne    8009be <strlcpy+0x1c>
  8009d2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d7:	29 f0                	sub    %esi,%eax
}
  8009d9:	5b                   	pop    %ebx
  8009da:	5e                   	pop    %esi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e6:	eb 06                	jmp    8009ee <strcmp+0x11>
		p++, q++;
  8009e8:	83 c1 01             	add    $0x1,%ecx
  8009eb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009ee:	0f b6 01             	movzbl (%ecx),%eax
  8009f1:	84 c0                	test   %al,%al
  8009f3:	74 04                	je     8009f9 <strcmp+0x1c>
  8009f5:	3a 02                	cmp    (%edx),%al
  8009f7:	74 ef                	je     8009e8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f9:	0f b6 c0             	movzbl %al,%eax
  8009fc:	0f b6 12             	movzbl (%edx),%edx
  8009ff:	29 d0                	sub    %edx,%eax
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	53                   	push   %ebx
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	89 c3                	mov    %eax,%ebx
  800a0f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a12:	eb 06                	jmp    800a1a <strncmp+0x17>
		n--, p++, q++;
  800a14:	83 c0 01             	add    $0x1,%eax
  800a17:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a1a:	39 d8                	cmp    %ebx,%eax
  800a1c:	74 18                	je     800a36 <strncmp+0x33>
  800a1e:	0f b6 08             	movzbl (%eax),%ecx
  800a21:	84 c9                	test   %cl,%cl
  800a23:	74 04                	je     800a29 <strncmp+0x26>
  800a25:	3a 0a                	cmp    (%edx),%cl
  800a27:	74 eb                	je     800a14 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a29:	0f b6 00             	movzbl (%eax),%eax
  800a2c:	0f b6 12             	movzbl (%edx),%edx
  800a2f:	29 d0                	sub    %edx,%eax
}
  800a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    
		return 0;
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	eb f4                	jmp    800a31 <strncmp+0x2e>

00800a3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a47:	eb 03                	jmp    800a4c <strchr+0xf>
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	0f b6 10             	movzbl (%eax),%edx
  800a4f:	84 d2                	test   %dl,%dl
  800a51:	74 06                	je     800a59 <strchr+0x1c>
		if (*s == c)
  800a53:	38 ca                	cmp    %cl,%dl
  800a55:	75 f2                	jne    800a49 <strchr+0xc>
  800a57:	eb 05                	jmp    800a5e <strchr+0x21>
			return (char *) s;
	return 0;
  800a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6d:	38 ca                	cmp    %cl,%dl
  800a6f:	74 09                	je     800a7a <strfind+0x1a>
  800a71:	84 d2                	test   %dl,%dl
  800a73:	74 05                	je     800a7a <strfind+0x1a>
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f0                	jmp    800a6a <strfind+0xa>
			break;
	return (char *) s;
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a88:	85 c9                	test   %ecx,%ecx
  800a8a:	74 2f                	je     800abb <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8c:	89 f8                	mov    %edi,%eax
  800a8e:	09 c8                	or     %ecx,%eax
  800a90:	a8 03                	test   $0x3,%al
  800a92:	75 21                	jne    800ab5 <memset+0x39>
		c &= 0xFF;
  800a94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a98:	89 d0                	mov    %edx,%eax
  800a9a:	c1 e0 08             	shl    $0x8,%eax
  800a9d:	89 d3                	mov    %edx,%ebx
  800a9f:	c1 e3 18             	shl    $0x18,%ebx
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	c1 e6 10             	shl    $0x10,%esi
  800aa7:	09 f3                	or     %esi,%ebx
  800aa9:	09 da                	or     %ebx,%edx
  800aab:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab0:	fc                   	cld    
  800ab1:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab3:	eb 06                	jmp    800abb <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	fc                   	cld    
  800ab9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abb:	89 f8                	mov    %edi,%eax
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5f                   	pop    %edi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	57                   	push   %edi
  800ac6:	56                   	push   %esi
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad0:	39 c6                	cmp    %eax,%esi
  800ad2:	73 32                	jae    800b06 <memmove+0x44>
  800ad4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad7:	39 c2                	cmp    %eax,%edx
  800ad9:	76 2b                	jbe    800b06 <memmove+0x44>
		s += n;
		d += n;
  800adb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ade:	89 d6                	mov    %edx,%esi
  800ae0:	09 fe                	or     %edi,%esi
  800ae2:	09 ce                	or     %ecx,%esi
  800ae4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aea:	75 0e                	jne    800afa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aec:	83 ef 04             	sub    $0x4,%edi
  800aef:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af5:	fd                   	std    
  800af6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af8:	eb 09                	jmp    800b03 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afa:	83 ef 01             	sub    $0x1,%edi
  800afd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b00:	fd                   	std    
  800b01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b03:	fc                   	cld    
  800b04:	eb 1a                	jmp    800b20 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b06:	89 f2                	mov    %esi,%edx
  800b08:	09 c2                	or     %eax,%edx
  800b0a:	09 ca                	or     %ecx,%edx
  800b0c:	f6 c2 03             	test   $0x3,%dl
  800b0f:	75 0a                	jne    800b1b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b14:	89 c7                	mov    %eax,%edi
  800b16:	fc                   	cld    
  800b17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b19:	eb 05                	jmp    800b20 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1b:	89 c7                	mov    %eax,%edi
  800b1d:	fc                   	cld    
  800b1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2a:	ff 75 10             	push   0x10(%ebp)
  800b2d:	ff 75 0c             	push   0xc(%ebp)
  800b30:	ff 75 08             	push   0x8(%ebp)
  800b33:	e8 8a ff ff ff       	call   800ac2 <memmove>
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b45:	89 c6                	mov    %eax,%esi
  800b47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4a:	eb 06                	jmp    800b52 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b52:	39 f0                	cmp    %esi,%eax
  800b54:	74 14                	je     800b6a <memcmp+0x30>
		if (*s1 != *s2)
  800b56:	0f b6 08             	movzbl (%eax),%ecx
  800b59:	0f b6 1a             	movzbl (%edx),%ebx
  800b5c:	38 d9                	cmp    %bl,%cl
  800b5e:	74 ec                	je     800b4c <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b60:	0f b6 c1             	movzbl %cl,%eax
  800b63:	0f b6 db             	movzbl %bl,%ebx
  800b66:	29 d8                	sub    %ebx,%eax
  800b68:	eb 05                	jmp    800b6f <memcmp+0x35>
	}

	return 0;
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7c:	89 c2                	mov    %eax,%edx
  800b7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b81:	eb 03                	jmp    800b86 <memfind+0x13>
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	39 d0                	cmp    %edx,%eax
  800b88:	73 04                	jae    800b8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8a:	38 08                	cmp    %cl,(%eax)
  800b8c:	75 f5                	jne    800b83 <memfind+0x10>
			break;
	return (void *) s;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9c:	eb 03                	jmp    800ba1 <strtol+0x11>
		s++;
  800b9e:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ba1:	0f b6 02             	movzbl (%edx),%eax
  800ba4:	3c 20                	cmp    $0x20,%al
  800ba6:	74 f6                	je     800b9e <strtol+0xe>
  800ba8:	3c 09                	cmp    $0x9,%al
  800baa:	74 f2                	je     800b9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bac:	3c 2b                	cmp    $0x2b,%al
  800bae:	74 2a                	je     800bda <strtol+0x4a>
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb5:	3c 2d                	cmp    $0x2d,%al
  800bb7:	74 2b                	je     800be4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbf:	75 0f                	jne    800bd0 <strtol+0x40>
  800bc1:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc4:	74 28                	je     800bee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcd:	0f 44 d8             	cmove  %eax,%ebx
  800bd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd8:	eb 46                	jmp    800c20 <strtol+0x90>
		s++;
  800bda:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  800be2:	eb d5                	jmp    800bb9 <strtol+0x29>
		s++, neg = 1;
  800be4:	83 c2 01             	add    $0x1,%edx
  800be7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bec:	eb cb                	jmp    800bb9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bee:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bf2:	74 0e                	je     800c02 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf4:	85 db                	test   %ebx,%ebx
  800bf6:	75 d8                	jne    800bd0 <strtol+0x40>
		s++, base = 8;
  800bf8:	83 c2 01             	add    $0x1,%edx
  800bfb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c00:	eb ce                	jmp    800bd0 <strtol+0x40>
		s += 2, base = 16;
  800c02:	83 c2 02             	add    $0x2,%edx
  800c05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0a:	eb c4                	jmp    800bd0 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c0c:	0f be c0             	movsbl %al,%eax
  800c0f:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c15:	7d 3a                	jge    800c51 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800c1e:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800c20:	0f b6 02             	movzbl (%edx),%eax
  800c23:	8d 70 d0             	lea    -0x30(%eax),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 09             	cmp    $0x9,%bl
  800c2b:	76 df                	jbe    800c0c <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c2d:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c30:	89 f3                	mov    %esi,%ebx
  800c32:	80 fb 19             	cmp    $0x19,%bl
  800c35:	77 08                	ja     800c3f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c37:	0f be c0             	movsbl %al,%eax
  800c3a:	83 e8 57             	sub    $0x57,%eax
  800c3d:	eb d3                	jmp    800c12 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c3f:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c42:	89 f3                	mov    %esi,%ebx
  800c44:	80 fb 19             	cmp    $0x19,%bl
  800c47:	77 08                	ja     800c51 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c49:	0f be c0             	movsbl %al,%eax
  800c4c:	83 e8 37             	sub    $0x37,%eax
  800c4f:	eb c1                	jmp    800c12 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c55:	74 05                	je     800c5c <strtol+0xcc>
		*endptr = (char *) s;
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c5c:	89 c8                	mov    %ecx,%eax
  800c5e:	f7 d8                	neg    %eax
  800c60:	85 ff                	test   %edi,%edi
  800c62:	0f 45 c8             	cmovne %eax,%ecx
}
  800c65:	89 c8                	mov    %ecx,%eax
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7f 08                	jg     800cd3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	50                   	push   %eax
  800cd7:	6a 03                	push   $0x3
  800cd9:	68 3f 29 80 00       	push   $0x80293f
  800cde:	6a 23                	push   $0x23
  800ce0:	68 5c 29 80 00       	push   $0x80295c
  800ce5:	e8 a2 f4 ff ff       	call   80018c <_panic>

00800cea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfa:	89 d1                	mov    %edx,%ecx
  800cfc:	89 d3                	mov    %edx,%ebx
  800cfe:	89 d7                	mov    %edx,%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_yield>:

void
sys_yield(void)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d19:	89 d1                	mov    %edx,%ecx
  800d1b:	89 d3                	mov    %edx,%ebx
  800d1d:	89 d7                	mov    %edx,%edi
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	89 f7                	mov    %esi,%edi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 04                	push   $0x4
  800d5a:	68 3f 29 80 00       	push   $0x80293f
  800d5f:	6a 23                	push   $0x23
  800d61:	68 5c 29 80 00       	push   $0x80295c
  800d66:	e8 21 f4 ff ff       	call   80018c <_panic>

00800d6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d82:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d85:	8b 75 18             	mov    0x18(%ebp),%esi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 05                	push   $0x5
  800d9c:	68 3f 29 80 00       	push   $0x80293f
  800da1:	6a 23                	push   $0x23
  800da3:	68 5c 29 80 00       	push   $0x80295c
  800da8:	e8 df f3 ff ff       	call   80018c <_panic>

00800dad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 06                	push   $0x6
  800dde:	68 3f 29 80 00       	push   $0x80293f
  800de3:	6a 23                	push   $0x23
  800de5:	68 5c 29 80 00       	push   $0x80295c
  800dea:	e8 9d f3 ff ff       	call   80018c <_panic>

00800def <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 08 00 00 00       	mov    $0x8,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 08                	push   $0x8
  800e20:	68 3f 29 80 00       	push   $0x80293f
  800e25:	6a 23                	push   $0x23
  800e27:	68 5c 29 80 00       	push   $0x80295c
  800e2c:	e8 5b f3 ff ff       	call   80018c <_panic>

00800e31 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 09                	push   $0x9
  800e62:	68 3f 29 80 00       	push   $0x80293f
  800e67:	6a 23                	push   $0x23
  800e69:	68 5c 29 80 00       	push   $0x80295c
  800e6e:	e8 19 f3 ff ff       	call   80018c <_panic>

00800e73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8c:	89 df                	mov    %ebx,%edi
  800e8e:	89 de                	mov    %ebx,%esi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 0a                	push   $0xa
  800ea4:	68 3f 29 80 00       	push   $0x80293f
  800ea9:	6a 23                	push   $0x23
  800eab:	68 5c 29 80 00       	push   $0x80295c
  800eb0:	e8 d7 f2 ff ff       	call   80018c <_panic>

00800eb5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec6:	be 00 00 00 00       	mov    $0x0,%esi
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eee:	89 cb                	mov    %ecx,%ebx
  800ef0:	89 cf                	mov    %ecx,%edi
  800ef2:	89 ce                	mov    %ecx,%esi
  800ef4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7f 08                	jg     800f02 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	50                   	push   %eax
  800f06:	6a 0d                	push   $0xd
  800f08:	68 3f 29 80 00       	push   $0x80293f
  800f0d:	6a 23                	push   $0x23
  800f0f:	68 5c 29 80 00       	push   $0x80295c
  800f14:	e8 73 f2 ff ff       	call   80018c <_panic>

00800f19 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	05 00 00 00 30       	add    $0x30000000,%eax
  800f24:	c1 e8 0c             	shr    $0xc,%eax
}
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f39:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f48:	89 c2                	mov    %eax,%edx
  800f4a:	c1 ea 16             	shr    $0x16,%edx
  800f4d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f54:	f6 c2 01             	test   $0x1,%dl
  800f57:	74 29                	je     800f82 <fd_alloc+0x42>
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	c1 ea 0c             	shr    $0xc,%edx
  800f5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f65:	f6 c2 01             	test   $0x1,%dl
  800f68:	74 18                	je     800f82 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  800f6a:	05 00 10 00 00       	add    $0x1000,%eax
  800f6f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f74:	75 d2                	jne    800f48 <fd_alloc+0x8>
  800f76:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  800f7b:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  800f80:	eb 05                	jmp    800f87 <fd_alloc+0x47>
			return 0;
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	89 02                	mov    %eax,(%edx)
}
  800f8c:	89 c8                	mov    %ecx,%eax
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f96:	83 f8 1f             	cmp    $0x1f,%eax
  800f99:	77 30                	ja     800fcb <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f9b:	c1 e0 0c             	shl    $0xc,%eax
  800f9e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fa9:	f6 c2 01             	test   $0x1,%dl
  800fac:	74 24                	je     800fd2 <fd_lookup+0x42>
  800fae:	89 c2                	mov    %eax,%edx
  800fb0:	c1 ea 0c             	shr    $0xc,%edx
  800fb3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fba:	f6 c2 01             	test   $0x1,%dl
  800fbd:	74 1a                	je     800fd9 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc2:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		return -E_INVAL;
  800fcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd0:	eb f7                	jmp    800fc9 <fd_lookup+0x39>
		return -E_INVAL;
  800fd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd7:	eb f0                	jmp    800fc9 <fd_lookup+0x39>
  800fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fde:	eb e9                	jmp    800fc9 <fd_lookup+0x39>

00800fe0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 04             	sub    $0x4,%esp
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	b8 e8 29 80 00       	mov    $0x8029e8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  800fef:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  800ff4:	39 13                	cmp    %edx,(%ebx)
  800ff6:	74 32                	je     80102a <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  800ff8:	83 c0 04             	add    $0x4,%eax
  800ffb:	8b 18                	mov    (%eax),%ebx
  800ffd:	85 db                	test   %ebx,%ebx
  800fff:	75 f3                	jne    800ff4 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801001:	a1 00 40 80 00       	mov    0x804000,%eax
  801006:	8b 40 48             	mov    0x48(%eax),%eax
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	52                   	push   %edx
  80100d:	50                   	push   %eax
  80100e:	68 6c 29 80 00       	push   $0x80296c
  801013:	e8 4f f2 ff ff       	call   800267 <cprintf>
	*dev = 0;
	return -E_INVAL;
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	89 1a                	mov    %ebx,(%edx)
}
  801025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801028:	c9                   	leave  
  801029:	c3                   	ret    
			return 0;
  80102a:	b8 00 00 00 00       	mov    $0x0,%eax
  80102f:	eb ef                	jmp    801020 <dev_lookup+0x40>

00801031 <fd_close>:
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
  801037:	83 ec 24             	sub    $0x24,%esp
  80103a:	8b 75 08             	mov    0x8(%ebp),%esi
  80103d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801040:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801043:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801044:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80104a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80104d:	50                   	push   %eax
  80104e:	e8 3d ff ff ff       	call   800f90 <fd_lookup>
  801053:	89 c3                	mov    %eax,%ebx
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 05                	js     801061 <fd_close+0x30>
	    || fd != fd2)
  80105c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80105f:	74 16                	je     801077 <fd_close+0x46>
		return (must_exist ? r : 0);
  801061:	89 f8                	mov    %edi,%eax
  801063:	84 c0                	test   %al,%al
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	0f 44 d8             	cmove  %eax,%ebx
}
  80106d:	89 d8                	mov    %ebx,%eax
  80106f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80107d:	50                   	push   %eax
  80107e:	ff 36                	push   (%esi)
  801080:	e8 5b ff ff ff       	call   800fe0 <dev_lookup>
  801085:	89 c3                	mov    %eax,%ebx
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 1a                	js     8010a8 <fd_close+0x77>
		if (dev->dev_close)
  80108e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801091:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801094:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801099:	85 c0                	test   %eax,%eax
  80109b:	74 0b                	je     8010a8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	56                   	push   %esi
  8010a1:	ff d0                	call   *%eax
  8010a3:	89 c3                	mov    %eax,%ebx
  8010a5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	56                   	push   %esi
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 fa fc ff ff       	call   800dad <sys_page_unmap>
	return r;
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	eb b5                	jmp    80106d <fd_close+0x3c>

008010b8 <close>:

int
close(int fdnum)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c1:	50                   	push   %eax
  8010c2:	ff 75 08             	push   0x8(%ebp)
  8010c5:	e8 c6 fe ff ff       	call   800f90 <fd_lookup>
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	79 02                	jns    8010d3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    
		return fd_close(fd, 1);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	6a 01                	push   $0x1
  8010d8:	ff 75 f4             	push   -0xc(%ebp)
  8010db:	e8 51 ff ff ff       	call   801031 <fd_close>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	eb ec                	jmp    8010d1 <close+0x19>

008010e5 <close_all>:

void
close_all(void)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010f1:	83 ec 0c             	sub    $0xc,%esp
  8010f4:	53                   	push   %ebx
  8010f5:	e8 be ff ff ff       	call   8010b8 <close>
	for (i = 0; i < MAXFD; i++)
  8010fa:	83 c3 01             	add    $0x1,%ebx
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	83 fb 20             	cmp    $0x20,%ebx
  801103:	75 ec                	jne    8010f1 <close_all+0xc>
}
  801105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801113:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	ff 75 08             	push   0x8(%ebp)
  80111a:	e8 71 fe ff ff       	call   800f90 <fd_lookup>
  80111f:	89 c3                	mov    %eax,%ebx
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	85 c0                	test   %eax,%eax
  801126:	78 7f                	js     8011a7 <dup+0x9d>
		return r;
	close(newfdnum);
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	ff 75 0c             	push   0xc(%ebp)
  80112e:	e8 85 ff ff ff       	call   8010b8 <close>

	newfd = INDEX2FD(newfdnum);
  801133:	8b 75 0c             	mov    0xc(%ebp),%esi
  801136:	c1 e6 0c             	shl    $0xc,%esi
  801139:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801142:	89 3c 24             	mov    %edi,(%esp)
  801145:	e8 df fd ff ff       	call   800f29 <fd2data>
  80114a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80114c:	89 34 24             	mov    %esi,(%esp)
  80114f:	e8 d5 fd ff ff       	call   800f29 <fd2data>
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80115a:	89 d8                	mov    %ebx,%eax
  80115c:	c1 e8 16             	shr    $0x16,%eax
  80115f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801166:	a8 01                	test   $0x1,%al
  801168:	74 11                	je     80117b <dup+0x71>
  80116a:	89 d8                	mov    %ebx,%eax
  80116c:	c1 e8 0c             	shr    $0xc,%eax
  80116f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801176:	f6 c2 01             	test   $0x1,%dl
  801179:	75 36                	jne    8011b1 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80117b:	89 f8                	mov    %edi,%eax
  80117d:	c1 e8 0c             	shr    $0xc,%eax
  801180:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	25 07 0e 00 00       	and    $0xe07,%eax
  80118f:	50                   	push   %eax
  801190:	56                   	push   %esi
  801191:	6a 00                	push   $0x0
  801193:	57                   	push   %edi
  801194:	6a 00                	push   $0x0
  801196:	e8 d0 fb ff ff       	call   800d6b <sys_page_map>
  80119b:	89 c3                	mov    %eax,%ebx
  80119d:	83 c4 20             	add    $0x20,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	78 33                	js     8011d7 <dup+0xcd>
		goto err;

	return newfdnum;
  8011a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c0:	50                   	push   %eax
  8011c1:	ff 75 d4             	push   -0x2c(%ebp)
  8011c4:	6a 00                	push   $0x0
  8011c6:	53                   	push   %ebx
  8011c7:	6a 00                	push   $0x0
  8011c9:	e8 9d fb ff ff       	call   800d6b <sys_page_map>
  8011ce:	89 c3                	mov    %eax,%ebx
  8011d0:	83 c4 20             	add    $0x20,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	79 a4                	jns    80117b <dup+0x71>
	sys_page_unmap(0, newfd);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	56                   	push   %esi
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 cb fb ff ff       	call   800dad <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011e2:	83 c4 08             	add    $0x8,%esp
  8011e5:	ff 75 d4             	push   -0x2c(%ebp)
  8011e8:	6a 00                	push   $0x0
  8011ea:	e8 be fb ff ff       	call   800dad <sys_page_unmap>
	return r;
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	eb b3                	jmp    8011a7 <dup+0x9d>

008011f4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 18             	sub    $0x18,%esp
  8011fc:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	56                   	push   %esi
  801204:	e8 87 fd ff ff       	call   800f90 <fd_lookup>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 3c                	js     80124c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801210:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801219:	50                   	push   %eax
  80121a:	ff 33                	push   (%ebx)
  80121c:	e8 bf fd ff ff       	call   800fe0 <dev_lookup>
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	78 24                	js     80124c <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801228:	8b 43 08             	mov    0x8(%ebx),%eax
  80122b:	83 e0 03             	and    $0x3,%eax
  80122e:	83 f8 01             	cmp    $0x1,%eax
  801231:	74 20                	je     801253 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	8b 40 08             	mov    0x8(%eax),%eax
  801239:	85 c0                	test   %eax,%eax
  80123b:	74 37                	je     801274 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	ff 75 10             	push   0x10(%ebp)
  801243:	ff 75 0c             	push   0xc(%ebp)
  801246:	53                   	push   %ebx
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
}
  80124c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801253:	a1 00 40 80 00       	mov    0x804000,%eax
  801258:	8b 40 48             	mov    0x48(%eax),%eax
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	56                   	push   %esi
  80125f:	50                   	push   %eax
  801260:	68 ad 29 80 00       	push   $0x8029ad
  801265:	e8 fd ef ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801272:	eb d8                	jmp    80124c <read+0x58>
		return -E_NOT_SUPP;
  801274:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801279:	eb d1                	jmp    80124c <read+0x58>

0080127b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	8b 7d 08             	mov    0x8(%ebp),%edi
  801287:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80128a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128f:	eb 02                	jmp    801293 <readn+0x18>
  801291:	01 c3                	add    %eax,%ebx
  801293:	39 f3                	cmp    %esi,%ebx
  801295:	73 21                	jae    8012b8 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	89 f0                	mov    %esi,%eax
  80129c:	29 d8                	sub    %ebx,%eax
  80129e:	50                   	push   %eax
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	03 45 0c             	add    0xc(%ebp),%eax
  8012a4:	50                   	push   %eax
  8012a5:	57                   	push   %edi
  8012a6:	e8 49 ff ff ff       	call   8011f4 <read>
		if (m < 0)
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 04                	js     8012b6 <readn+0x3b>
			return m;
		if (m == 0)
  8012b2:	75 dd                	jne    801291 <readn+0x16>
  8012b4:	eb 02                	jmp    8012b8 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b8:	89 d8                	mov    %ebx,%eax
  8012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	5f                   	pop    %edi
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 18             	sub    $0x18,%esp
  8012ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d0:	50                   	push   %eax
  8012d1:	53                   	push   %ebx
  8012d2:	e8 b9 fc ff ff       	call   800f90 <fd_lookup>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 37                	js     801315 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012de:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8012e1:	83 ec 08             	sub    $0x8,%esp
  8012e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 36                	push   (%esi)
  8012ea:	e8 f1 fc ff ff       	call   800fe0 <dev_lookup>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 1f                	js     801315 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f6:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8012fa:	74 20                	je     80131c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801302:	85 c0                	test   %eax,%eax
  801304:	74 37                	je     80133d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	ff 75 10             	push   0x10(%ebp)
  80130c:	ff 75 0c             	push   0xc(%ebp)
  80130f:	56                   	push   %esi
  801310:	ff d0                	call   *%eax
  801312:	83 c4 10             	add    $0x10,%esp
}
  801315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80131c:	a1 00 40 80 00       	mov    0x804000,%eax
  801321:	8b 40 48             	mov    0x48(%eax),%eax
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	53                   	push   %ebx
  801328:	50                   	push   %eax
  801329:	68 c9 29 80 00       	push   $0x8029c9
  80132e:	e8 34 ef ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133b:	eb d8                	jmp    801315 <write+0x53>
		return -E_NOT_SUPP;
  80133d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801342:	eb d1                	jmp    801315 <write+0x53>

00801344 <seek>:

int
seek(int fdnum, off_t offset)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134d:	50                   	push   %eax
  80134e:	ff 75 08             	push   0x8(%ebp)
  801351:	e8 3a fc ff ff       	call   800f90 <fd_lookup>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 0e                	js     80136b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80135d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 18             	sub    $0x18,%esp
  801375:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801378:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137b:	50                   	push   %eax
  80137c:	53                   	push   %ebx
  80137d:	e8 0e fc ff ff       	call   800f90 <fd_lookup>
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 34                	js     8013bd <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801389:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	ff 36                	push   (%esi)
  801395:	e8 46 fc ff ff       	call   800fe0 <dev_lookup>
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 1c                	js     8013bd <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a1:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8013a5:	74 1d                	je     8013c4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013aa:	8b 40 18             	mov    0x18(%eax),%eax
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	74 34                	je     8013e5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	ff 75 0c             	push   0xc(%ebp)
  8013b7:	56                   	push   %esi
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
}
  8013bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013c4:	a1 00 40 80 00       	mov    0x804000,%eax
  8013c9:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	53                   	push   %ebx
  8013d0:	50                   	push   %eax
  8013d1:	68 8c 29 80 00       	push   $0x80298c
  8013d6:	e8 8c ee ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e3:	eb d8                	jmp    8013bd <ftruncate+0x50>
		return -E_NOT_SUPP;
  8013e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ea:	eb d1                	jmp    8013bd <ftruncate+0x50>

008013ec <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	56                   	push   %esi
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 18             	sub    $0x18,%esp
  8013f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	ff 75 08             	push   0x8(%ebp)
  8013fe:	e8 8d fb ff ff       	call   800f90 <fd_lookup>
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	78 49                	js     801453 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	ff 36                	push   (%esi)
  801416:	e8 c5 fb ff ff       	call   800fe0 <dev_lookup>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 31                	js     801453 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801425:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801429:	74 2f                	je     80145a <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80142b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80142e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801435:	00 00 00 
	stat->st_isdir = 0;
  801438:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80143f:	00 00 00 
	stat->st_dev = dev;
  801442:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	53                   	push   %ebx
  80144c:	56                   	push   %esi
  80144d:	ff 50 14             	call   *0x14(%eax)
  801450:	83 c4 10             	add    $0x10,%esp
}
  801453:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801456:	5b                   	pop    %ebx
  801457:	5e                   	pop    %esi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    
		return -E_NOT_SUPP;
  80145a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145f:	eb f2                	jmp    801453 <fstat+0x67>

00801461 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	6a 00                	push   $0x0
  80146b:	ff 75 08             	push   0x8(%ebp)
  80146e:	e8 22 02 00 00       	call   801695 <open>
  801473:	89 c3                	mov    %eax,%ebx
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 1b                	js     801497 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 0c             	push   0xc(%ebp)
  801482:	50                   	push   %eax
  801483:	e8 64 ff ff ff       	call   8013ec <fstat>
  801488:	89 c6                	mov    %eax,%esi
	close(fd);
  80148a:	89 1c 24             	mov    %ebx,(%esp)
  80148d:	e8 26 fc ff ff       	call   8010b8 <close>
	return r;
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	89 f3                	mov    %esi,%ebx
}
  801497:	89 d8                	mov    %ebx,%eax
  801499:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149c:	5b                   	pop    %ebx
  80149d:	5e                   	pop    %esi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    

008014a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	89 c6                	mov    %eax,%esi
  8014a7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014a9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8014b0:	74 27                	je     8014d9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014b2:	6a 07                	push   $0x7
  8014b4:	68 00 50 80 00       	push   $0x805000
  8014b9:	56                   	push   %esi
  8014ba:	ff 35 00 60 80 00    	push   0x806000
  8014c0:	e8 68 0d 00 00       	call   80222d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014c5:	83 c4 0c             	add    $0xc,%esp
  8014c8:	6a 00                	push   $0x0
  8014ca:	53                   	push   %ebx
  8014cb:	6a 00                	push   $0x0
  8014cd:	e8 0c 0d 00 00       	call   8021de <ipc_recv>
}
  8014d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d5:	5b                   	pop    %ebx
  8014d6:	5e                   	pop    %esi
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	6a 01                	push   $0x1
  8014de:	e8 96 0d 00 00       	call   802279 <ipc_find_env>
  8014e3:	a3 00 60 80 00       	mov    %eax,0x806000
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	eb c5                	jmp    8014b2 <fsipc+0x12>

008014ed <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801506:	ba 00 00 00 00       	mov    $0x0,%edx
  80150b:	b8 02 00 00 00       	mov    $0x2,%eax
  801510:	e8 8b ff ff ff       	call   8014a0 <fsipc>
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <devfile_flush>:
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8b 40 0c             	mov    0xc(%eax),%eax
  801523:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801528:	ba 00 00 00 00       	mov    $0x0,%edx
  80152d:	b8 06 00 00 00       	mov    $0x6,%eax
  801532:	e8 69 ff ff ff       	call   8014a0 <fsipc>
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <devfile_stat>:
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	53                   	push   %ebx
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8b 40 0c             	mov    0xc(%eax),%eax
  801549:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80154e:	ba 00 00 00 00       	mov    $0x0,%edx
  801553:	b8 05 00 00 00       	mov    $0x5,%eax
  801558:	e8 43 ff ff ff       	call   8014a0 <fsipc>
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 2c                	js     80158d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	68 00 50 80 00       	push   $0x805000
  801569:	53                   	push   %ebx
  80156a:	e8 bd f3 ff ff       	call   80092c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80156f:	a1 80 50 80 00       	mov    0x805080,%eax
  801574:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80157a:	a1 84 50 80 00       	mov    0x805084,%eax
  80157f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <devfile_write>:
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	53                   	push   %ebx
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015a7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8015ad:	53                   	push   %ebx
  8015ae:	ff 75 0c             	push   0xc(%ebp)
  8015b1:	68 08 50 80 00       	push   $0x805008
  8015b6:	e8 69 f5 ff ff       	call   800b24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8015c5:	e8 d6 fe ff ff       	call   8014a0 <fsipc>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 0b                	js     8015dc <devfile_write+0x4a>
	assert(r <= n);
  8015d1:	39 d8                	cmp    %ebx,%eax
  8015d3:	77 0c                	ja     8015e1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8015d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015da:	7f 1e                	jg     8015fa <devfile_write+0x68>
}
  8015dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    
	assert(r <= n);
  8015e1:	68 f8 29 80 00       	push   $0x8029f8
  8015e6:	68 ff 29 80 00       	push   $0x8029ff
  8015eb:	68 97 00 00 00       	push   $0x97
  8015f0:	68 14 2a 80 00       	push   $0x802a14
  8015f5:	e8 92 eb ff ff       	call   80018c <_panic>
	assert(r <= PGSIZE);
  8015fa:	68 1f 2a 80 00       	push   $0x802a1f
  8015ff:	68 ff 29 80 00       	push   $0x8029ff
  801604:	68 98 00 00 00       	push   $0x98
  801609:	68 14 2a 80 00       	push   $0x802a14
  80160e:	e8 79 eb ff ff       	call   80018c <_panic>

00801613 <devfile_read>:
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 40 0c             	mov    0xc(%eax),%eax
  801621:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801626:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80162c:	ba 00 00 00 00       	mov    $0x0,%edx
  801631:	b8 03 00 00 00       	mov    $0x3,%eax
  801636:	e8 65 fe ff ff       	call   8014a0 <fsipc>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 1f                	js     801660 <devfile_read+0x4d>
	assert(r <= n);
  801641:	39 f0                	cmp    %esi,%eax
  801643:	77 24                	ja     801669 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801645:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80164a:	7f 33                	jg     80167f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	50                   	push   %eax
  801650:	68 00 50 80 00       	push   $0x805000
  801655:	ff 75 0c             	push   0xc(%ebp)
  801658:	e8 65 f4 ff ff       	call   800ac2 <memmove>
	return r;
  80165d:	83 c4 10             	add    $0x10,%esp
}
  801660:	89 d8                	mov    %ebx,%eax
  801662:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
	assert(r <= n);
  801669:	68 f8 29 80 00       	push   $0x8029f8
  80166e:	68 ff 29 80 00       	push   $0x8029ff
  801673:	6a 7c                	push   $0x7c
  801675:	68 14 2a 80 00       	push   $0x802a14
  80167a:	e8 0d eb ff ff       	call   80018c <_panic>
	assert(r <= PGSIZE);
  80167f:	68 1f 2a 80 00       	push   $0x802a1f
  801684:	68 ff 29 80 00       	push   $0x8029ff
  801689:	6a 7d                	push   $0x7d
  80168b:	68 14 2a 80 00       	push   $0x802a14
  801690:	e8 f7 ea ff ff       	call   80018c <_panic>

00801695 <open>:
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	83 ec 1c             	sub    $0x1c,%esp
  80169d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016a0:	56                   	push   %esi
  8016a1:	e8 4b f2 ff ff       	call   8008f1 <strlen>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016ae:	7f 6c                	jg     80171c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b6:	50                   	push   %eax
  8016b7:	e8 84 f8 ff ff       	call   800f40 <fd_alloc>
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 3c                	js     801701 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016c5:	83 ec 08             	sub    $0x8,%esp
  8016c8:	56                   	push   %esi
  8016c9:	68 00 50 80 00       	push   $0x805000
  8016ce:	e8 59 f2 ff ff       	call   80092c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016de:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e3:	e8 b8 fd ff ff       	call   8014a0 <fsipc>
  8016e8:	89 c3                	mov    %eax,%ebx
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 19                	js     80170a <open+0x75>
	return fd2num(fd);
  8016f1:	83 ec 0c             	sub    $0xc,%esp
  8016f4:	ff 75 f4             	push   -0xc(%ebp)
  8016f7:	e8 1d f8 ff ff       	call   800f19 <fd2num>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    
		fd_close(fd, 0);
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 f4             	push   -0xc(%ebp)
  801712:	e8 1a f9 ff ff       	call   801031 <fd_close>
		return r;
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	eb e5                	jmp    801701 <open+0x6c>
		return -E_BAD_PATH;
  80171c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801721:	eb de                	jmp    801701 <open+0x6c>

00801723 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801729:	ba 00 00 00 00       	mov    $0x0,%edx
  80172e:	b8 08 00 00 00       	mov    $0x8,%eax
  801733:	e8 68 fd ff ff       	call   8014a0 <fsipc>
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801746:	6a 00                	push   $0x0
  801748:	ff 75 08             	push   0x8(%ebp)
  80174b:	e8 45 ff ff ff       	call   801695 <open>
  801750:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	0f 88 d0 04 00 00    	js     801c31 <spawn+0x4f7>
  801761:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	68 00 02 00 00       	push   $0x200
  80176b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801771:	50                   	push   %eax
  801772:	51                   	push   %ecx
  801773:	e8 03 fb ff ff       	call   80127b <readn>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	3d 00 02 00 00       	cmp    $0x200,%eax
  801780:	75 57                	jne    8017d9 <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  801782:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801789:	45 4c 46 
  80178c:	75 4b                	jne    8017d9 <spawn+0x9f>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80178e:	b8 07 00 00 00       	mov    $0x7,%eax
  801793:	cd 30                	int    $0x30
  801795:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	0f 88 82 04 00 00    	js     801c25 <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017a8:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8017ab:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017b1:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017b7:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017be:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017c4:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8017ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8017cf:	be 00 00 00 00       	mov    $0x0,%esi
  8017d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  8017d7:	eb 4b                	jmp    801824 <spawn+0xea>
		close(fd);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8017e2:	e8 d1 f8 ff ff       	call   8010b8 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8017e7:	83 c4 0c             	add    $0xc,%esp
  8017ea:	68 7f 45 4c 46       	push   $0x464c457f
  8017ef:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  8017f5:	68 2b 2a 80 00       	push   $0x802a2b
  8017fa:	e8 68 ea ff ff       	call   800267 <cprintf>
		return -E_NOT_EXEC;
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801809:	ff ff ff 
  80180c:	e9 20 04 00 00       	jmp    801c31 <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	50                   	push   %eax
  801815:	e8 d7 f0 ff ff       	call   8008f1 <strlen>
  80181a:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80181e:	83 c3 01             	add    $0x1,%ebx
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80182b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80182e:	85 c0                	test   %eax,%eax
  801830:	75 df                	jne    801811 <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801832:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801838:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80183e:	b8 00 10 40 00       	mov    $0x401000,%eax
  801843:	29 f0                	sub    %esi,%eax
  801845:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801847:	89 c2                	mov    %eax,%edx
  801849:	83 e2 fc             	and    $0xfffffffc,%edx
  80184c:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801853:	29 c2                	sub    %eax,%edx
  801855:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80185b:	8d 42 f8             	lea    -0x8(%edx),%eax
  80185e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801863:	0f 86 eb 03 00 00    	jbe    801c54 <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	6a 07                	push   $0x7
  80186e:	68 00 00 40 00       	push   $0x400000
  801873:	6a 00                	push   $0x0
  801875:	e8 ae f4 ff ff       	call   800d28 <sys_page_alloc>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	0f 88 d4 03 00 00    	js     801c59 <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801885:	be 00 00 00 00       	mov    $0x0,%esi
  80188a:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801890:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801893:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801899:	7e 32                	jle    8018cd <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  80189b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8018a1:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8018a7:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	ff 34 b3             	push   (%ebx,%esi,4)
  8018b0:	57                   	push   %edi
  8018b1:	e8 76 f0 ff ff       	call   80092c <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018b6:	83 c4 04             	add    $0x4,%esp
  8018b9:	ff 34 b3             	push   (%ebx,%esi,4)
  8018bc:	e8 30 f0 ff ff       	call   8008f1 <strlen>
  8018c1:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8018c5:	83 c6 01             	add    $0x1,%esi
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	eb c6                	jmp    801893 <spawn+0x159>
	}
	argv_store[argc] = 0;
  8018cd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8018d3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8018d9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018e0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8018e6:	0f 85 8c 00 00 00    	jne    801978 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8018ec:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8018f2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8018f8:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  8018fb:	89 f8                	mov    %edi,%eax
  8018fd:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801903:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801906:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80190b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	6a 07                	push   $0x7
  801916:	68 00 d0 bf ee       	push   $0xeebfd000
  80191b:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801921:	68 00 00 40 00       	push   $0x400000
  801926:	6a 00                	push   $0x0
  801928:	e8 3e f4 ff ff       	call   800d6b <sys_page_map>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	83 c4 20             	add    $0x20,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	0f 88 27 03 00 00    	js     801c61 <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	68 00 00 40 00       	push   $0x400000
  801942:	6a 00                	push   $0x0
  801944:	e8 64 f4 ff ff       	call   800dad <sys_page_unmap>
  801949:	89 c3                	mov    %eax,%ebx
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	0f 88 0b 03 00 00    	js     801c61 <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801956:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80195c:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801963:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801969:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801970:	00 00 00 
  801973:	e9 4e 01 00 00       	jmp    801ac6 <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801978:	68 a0 2a 80 00       	push   $0x802aa0
  80197d:	68 ff 29 80 00       	push   $0x8029ff
  801982:	68 f2 00 00 00       	push   $0xf2
  801987:	68 45 2a 80 00       	push   $0x802a45
  80198c:	e8 fb e7 ff ff       	call   80018c <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	6a 07                	push   $0x7
  801996:	68 00 00 40 00       	push   $0x400000
  80199b:	6a 00                	push   $0x0
  80199d:	e8 86 f3 ff ff       	call   800d28 <sys_page_alloc>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	0f 88 92 02 00 00    	js     801c3f <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019ad:	83 ec 08             	sub    $0x8,%esp
  8019b0:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019b6:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  8019bc:	50                   	push   %eax
  8019bd:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8019c3:	e8 7c f9 ff ff       	call   801344 <seek>
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	0f 88 73 02 00 00    	js     801c46 <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	89 f8                	mov    %edi,%eax
  8019d8:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  8019de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019e3:	39 d0                	cmp    %edx,%eax
  8019e5:	0f 47 c2             	cmova  %edx,%eax
  8019e8:	50                   	push   %eax
  8019e9:	68 00 00 40 00       	push   $0x400000
  8019ee:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8019f4:	e8 82 f8 ff ff       	call   80127b <readn>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	0f 88 49 02 00 00    	js     801c4d <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a04:	83 ec 0c             	sub    $0xc,%esp
  801a07:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  801a0d:	56                   	push   %esi
  801a0e:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801a14:	68 00 00 40 00       	push   $0x400000
  801a19:	6a 00                	push   $0x0
  801a1b:	e8 4b f3 ff ff       	call   800d6b <sys_page_map>
  801a20:	83 c4 20             	add    $0x20,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 7c                	js     801aa3 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	68 00 00 40 00       	push   $0x400000
  801a2f:	6a 00                	push   $0x0
  801a31:	e8 77 f3 ff ff       	call   800dad <sys_page_unmap>
  801a36:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a3f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801a45:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801a4b:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  801a51:	76 65                	jbe    801ab8 <spawn+0x37e>
		if (i >= filesz) {
  801a53:	39 df                	cmp    %ebx,%edi
  801a55:	0f 87 36 ff ff ff    	ja     801991 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  801a64:	56                   	push   %esi
  801a65:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801a6b:	e8 b8 f2 ff ff       	call   800d28 <sys_page_alloc>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	79 c2                	jns    801a39 <spawn+0x2ff>
  801a77:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801a82:	e8 22 f2 ff ff       	call   800ca9 <sys_env_destroy>
	close(fd);
  801a87:	83 c4 04             	add    $0x4,%esp
  801a8a:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801a90:	e8 23 f6 ff ff       	call   8010b8 <close>
	return r;
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801a9e:	e9 8e 01 00 00       	jmp    801c31 <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  801aa3:	50                   	push   %eax
  801aa4:	68 51 2a 80 00       	push   $0x802a51
  801aa9:	68 25 01 00 00       	push   $0x125
  801aae:	68 45 2a 80 00       	push   $0x802a45
  801ab3:	e8 d4 e6 ff ff       	call   80018c <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ab8:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801abf:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801ac6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801acd:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801ad3:	7e 67                	jle    801b3c <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  801ad5:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801adb:	83 39 01             	cmpl   $0x1,(%ecx)
  801ade:	75 d8                	jne    801ab8 <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ae0:	8b 41 18             	mov    0x18(%ecx),%eax
  801ae3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ae9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801aec:	83 f8 01             	cmp    $0x1,%eax
  801aef:	19 c0                	sbb    %eax,%eax
  801af1:	83 e0 fe             	and    $0xfffffffe,%eax
  801af4:	83 c0 07             	add    $0x7,%eax
  801af7:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801afd:	8b 51 04             	mov    0x4(%ecx),%edx
  801b00:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801b06:	8b 79 10             	mov    0x10(%ecx),%edi
  801b09:	8b 59 14             	mov    0x14(%ecx),%ebx
  801b0c:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b12:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  801b15:	89 f0                	mov    %esi,%eax
  801b17:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b1c:	74 14                	je     801b32 <spawn+0x3f8>
		va -= i;
  801b1e:	29 c6                	sub    %eax,%esi
		memsz += i;
  801b20:	01 c3                	add    %eax,%ebx
  801b22:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  801b28:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801b2a:	29 c2                	sub    %eax,%edx
  801b2c:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b32:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b37:	e9 09 ff ff ff       	jmp    801a45 <spawn+0x30b>
	close(fd);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801b45:	e8 6e f5 ff ff       	call   8010b8 <close>
  801b4a:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b52:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801b58:	eb 2d                	jmp    801b87 <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801b5a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b61:	89 da                	mov    %ebx,%edx
  801b63:	c1 e2 0c             	shl    $0xc,%edx
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	25 07 0e 00 00       	and    $0xe07,%eax
  801b6e:	50                   	push   %eax
  801b6f:	52                   	push   %edx
  801b70:	56                   	push   %esi
  801b71:	52                   	push   %edx
  801b72:	6a 00                	push   $0x0
  801b74:	e8 f2 f1 ff ff       	call   800d6b <sys_page_map>
  801b79:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801b7c:	83 c3 01             	add    $0x1,%ebx
  801b7f:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  801b85:	74 29                	je     801bb0 <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  801b87:	89 d8                	mov    %ebx,%eax
  801b89:	c1 f8 0a             	sar    $0xa,%eax
  801b8c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b93:	85 c0                	test   %eax,%eax
  801b95:	74 e5                	je     801b7c <spawn+0x442>
  801b97:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b9e:	a8 01                	test   $0x1,%al
  801ba0:	74 da                	je     801b7c <spawn+0x442>
  801ba2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801ba9:	f6 c4 04             	test   $0x4,%ah
  801bac:	74 ce                	je     801b7c <spawn+0x442>
  801bae:	eb aa                	jmp    801b5a <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801bb0:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801bb7:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801bba:	83 ec 08             	sub    $0x8,%esp
  801bbd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801bc3:	50                   	push   %eax
  801bc4:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801bca:	e8 62 f2 ff ff       	call   800e31 <sys_env_set_trapframe>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 25                	js     801bfb <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	6a 02                	push   $0x2
  801bdb:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801be1:	e8 09 f2 ff ff       	call   800def <sys_env_set_status>
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	85 c0                	test   %eax,%eax
  801beb:	78 23                	js     801c10 <spawn+0x4d6>
	return child;
  801bed:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801bf3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801bf9:	eb 36                	jmp    801c31 <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  801bfb:	50                   	push   %eax
  801bfc:	68 6e 2a 80 00       	push   $0x802a6e
  801c01:	68 86 00 00 00       	push   $0x86
  801c06:	68 45 2a 80 00       	push   $0x802a45
  801c0b:	e8 7c e5 ff ff       	call   80018c <_panic>
		panic("sys_env_set_status: %e", r);
  801c10:	50                   	push   %eax
  801c11:	68 88 2a 80 00       	push   $0x802a88
  801c16:	68 89 00 00 00       	push   $0x89
  801c1b:	68 45 2a 80 00       	push   $0x802a45
  801c20:	e8 67 e5 ff ff       	call   80018c <_panic>
		return r;
  801c25:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c2b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  801c31:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5f                   	pop    %edi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    
  801c3f:	89 c7                	mov    %eax,%edi
  801c41:	e9 33 fe ff ff       	jmp    801a79 <spawn+0x33f>
  801c46:	89 c7                	mov    %eax,%edi
  801c48:	e9 2c fe ff ff       	jmp    801a79 <spawn+0x33f>
  801c4d:	89 c7                	mov    %eax,%edi
  801c4f:	e9 25 fe ff ff       	jmp    801a79 <spawn+0x33f>
		return -E_NO_MEM;
  801c54:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801c59:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801c5f:	eb d0                	jmp    801c31 <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  801c61:	83 ec 08             	sub    $0x8,%esp
  801c64:	68 00 00 40 00       	push   $0x400000
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 3d f1 ff ff       	call   800dad <sys_page_unmap>
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c79:	eb b6                	jmp    801c31 <spawn+0x4f7>

00801c7b <spawnl>:
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
	va_start(vl, arg0);
  801c80:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c88:	eb 05                	jmp    801c8f <spawnl+0x14>
		argc++;
  801c8a:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801c8d:	89 ca                	mov    %ecx,%edx
  801c8f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c92:	83 3a 00             	cmpl   $0x0,(%edx)
  801c95:	75 f3                	jne    801c8a <spawnl+0xf>
	const char *argv[argc+2];
  801c97:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801c9e:	89 d3                	mov    %edx,%ebx
  801ca0:	83 e3 f0             	and    $0xfffffff0,%ebx
  801ca3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801ca9:	89 e1                	mov    %esp,%ecx
  801cab:	29 d1                	sub    %edx,%ecx
  801cad:	39 cc                	cmp    %ecx,%esp
  801caf:	74 10                	je     801cc1 <spawnl+0x46>
  801cb1:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801cb7:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801cbe:	00 
  801cbf:	eb ec                	jmp    801cad <spawnl+0x32>
  801cc1:	89 da                	mov    %ebx,%edx
  801cc3:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801cc9:	29 d4                	sub    %edx,%esp
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	74 05                	je     801cd4 <spawnl+0x59>
  801ccf:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801cd4:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  801cd8:	89 da                	mov    %ebx,%edx
  801cda:	c1 ea 02             	shr    $0x2,%edx
  801cdd:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  801ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce3:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801cea:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  801cf1:	00 
	va_start(vl, arg0);
  801cf2:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801cf5:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 0b                	jmp    801d09 <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  801cfe:	83 c0 01             	add    $0x1,%eax
  801d01:	8b 31                	mov    (%ecx),%esi
  801d03:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  801d06:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d09:	39 d0                	cmp    %edx,%eax
  801d0b:	75 f1                	jne    801cfe <spawnl+0x83>
	return spawn(prog, argv);
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	53                   	push   %ebx
  801d11:	ff 75 08             	push   0x8(%ebp)
  801d14:	e8 21 fa ff ff       	call   80173a <spawn>
}
  801d19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d28:	83 ec 0c             	sub    $0xc,%esp
  801d2b:	ff 75 08             	push   0x8(%ebp)
  801d2e:	e8 f6 f1 ff ff       	call   800f29 <fd2data>
  801d33:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d35:	83 c4 08             	add    $0x8,%esp
  801d38:	68 c6 2a 80 00       	push   $0x802ac6
  801d3d:	53                   	push   %ebx
  801d3e:	e8 e9 eb ff ff       	call   80092c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d43:	8b 46 04             	mov    0x4(%esi),%eax
  801d46:	2b 06                	sub    (%esi),%eax
  801d48:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d4e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d55:	00 00 00 
	stat->st_dev = &devpipe;
  801d58:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d5f:	30 80 00 
	return 0;
}
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
  801d67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6a:	5b                   	pop    %ebx
  801d6b:	5e                   	pop    %esi
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	53                   	push   %ebx
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d78:	53                   	push   %ebx
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 2d f0 ff ff       	call   800dad <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d80:	89 1c 24             	mov    %ebx,(%esp)
  801d83:	e8 a1 f1 ff ff       	call   800f29 <fd2data>
  801d88:	83 c4 08             	add    $0x8,%esp
  801d8b:	50                   	push   %eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	e8 1a f0 ff ff       	call   800dad <sys_page_unmap>
}
  801d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <_pipeisclosed>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	57                   	push   %edi
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 1c             	sub    $0x1c,%esp
  801da1:	89 c7                	mov    %eax,%edi
  801da3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801da5:	a1 00 40 80 00       	mov    0x804000,%eax
  801daa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	57                   	push   %edi
  801db1:	e8 fc 04 00 00       	call   8022b2 <pageref>
  801db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801db9:	89 34 24             	mov    %esi,(%esp)
  801dbc:	e8 f1 04 00 00       	call   8022b2 <pageref>
		nn = thisenv->env_runs;
  801dc1:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801dc7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	39 cb                	cmp    %ecx,%ebx
  801dcf:	74 1b                	je     801dec <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dd1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dd4:	75 cf                	jne    801da5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dd6:	8b 42 58             	mov    0x58(%edx),%eax
  801dd9:	6a 01                	push   $0x1
  801ddb:	50                   	push   %eax
  801ddc:	53                   	push   %ebx
  801ddd:	68 cd 2a 80 00       	push   $0x802acd
  801de2:	e8 80 e4 ff ff       	call   800267 <cprintf>
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	eb b9                	jmp    801da5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801def:	0f 94 c0             	sete   %al
  801df2:	0f b6 c0             	movzbl %al,%eax
}
  801df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    

00801dfd <devpipe_write>:
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	57                   	push   %edi
  801e01:	56                   	push   %esi
  801e02:	53                   	push   %ebx
  801e03:	83 ec 28             	sub    $0x28,%esp
  801e06:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e09:	56                   	push   %esi
  801e0a:	e8 1a f1 ff ff       	call   800f29 <fd2data>
  801e0f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	bf 00 00 00 00       	mov    $0x0,%edi
  801e19:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e1c:	75 09                	jne    801e27 <devpipe_write+0x2a>
	return i;
  801e1e:	89 f8                	mov    %edi,%eax
  801e20:	eb 23                	jmp    801e45 <devpipe_write+0x48>
			sys_yield();
  801e22:	e8 e2 ee ff ff       	call   800d09 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e27:	8b 43 04             	mov    0x4(%ebx),%eax
  801e2a:	8b 0b                	mov    (%ebx),%ecx
  801e2c:	8d 51 20             	lea    0x20(%ecx),%edx
  801e2f:	39 d0                	cmp    %edx,%eax
  801e31:	72 1a                	jb     801e4d <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801e33:	89 da                	mov    %ebx,%edx
  801e35:	89 f0                	mov    %esi,%eax
  801e37:	e8 5c ff ff ff       	call   801d98 <_pipeisclosed>
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 e2                	je     801e22 <devpipe_write+0x25>
				return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5f                   	pop    %edi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e50:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e54:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e57:	89 c2                	mov    %eax,%edx
  801e59:	c1 fa 1f             	sar    $0x1f,%edx
  801e5c:	89 d1                	mov    %edx,%ecx
  801e5e:	c1 e9 1b             	shr    $0x1b,%ecx
  801e61:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e64:	83 e2 1f             	and    $0x1f,%edx
  801e67:	29 ca                	sub    %ecx,%edx
  801e69:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e6d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e71:	83 c0 01             	add    $0x1,%eax
  801e74:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e77:	83 c7 01             	add    $0x1,%edi
  801e7a:	eb 9d                	jmp    801e19 <devpipe_write+0x1c>

00801e7c <devpipe_read>:
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	57                   	push   %edi
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	83 ec 18             	sub    $0x18,%esp
  801e85:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e88:	57                   	push   %edi
  801e89:	e8 9b f0 ff ff       	call   800f29 <fd2data>
  801e8e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	be 00 00 00 00       	mov    $0x0,%esi
  801e98:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e9b:	75 13                	jne    801eb0 <devpipe_read+0x34>
	return i;
  801e9d:	89 f0                	mov    %esi,%eax
  801e9f:	eb 02                	jmp    801ea3 <devpipe_read+0x27>
				return i;
  801ea1:	89 f0                	mov    %esi,%eax
}
  801ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5f                   	pop    %edi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    
			sys_yield();
  801eab:	e8 59 ee ff ff       	call   800d09 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eb0:	8b 03                	mov    (%ebx),%eax
  801eb2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eb5:	75 18                	jne    801ecf <devpipe_read+0x53>
			if (i > 0)
  801eb7:	85 f6                	test   %esi,%esi
  801eb9:	75 e6                	jne    801ea1 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801ebb:	89 da                	mov    %ebx,%edx
  801ebd:	89 f8                	mov    %edi,%eax
  801ebf:	e8 d4 fe ff ff       	call   801d98 <_pipeisclosed>
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	74 e3                	je     801eab <devpipe_read+0x2f>
				return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	eb d4                	jmp    801ea3 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ecf:	99                   	cltd   
  801ed0:	c1 ea 1b             	shr    $0x1b,%edx
  801ed3:	01 d0                	add    %edx,%eax
  801ed5:	83 e0 1f             	and    $0x1f,%eax
  801ed8:	29 d0                	sub    %edx,%eax
  801eda:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ee5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ee8:	83 c6 01             	add    $0x1,%esi
  801eeb:	eb ab                	jmp    801e98 <devpipe_read+0x1c>

00801eed <pipe>:
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	e8 42 f0 ff ff       	call   800f40 <fd_alloc>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	85 c0                	test   %eax,%eax
  801f05:	0f 88 23 01 00 00    	js     80202e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	68 07 04 00 00       	push   $0x407
  801f13:	ff 75 f4             	push   -0xc(%ebp)
  801f16:	6a 00                	push   $0x0
  801f18:	e8 0b ee ff ff       	call   800d28 <sys_page_alloc>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	85 c0                	test   %eax,%eax
  801f24:	0f 88 04 01 00 00    	js     80202e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	e8 0a f0 ff ff       	call   800f40 <fd_alloc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	0f 88 db 00 00 00    	js     80201e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 07 04 00 00       	push   $0x407
  801f4b:	ff 75 f0             	push   -0x10(%ebp)
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 d3 ed ff ff       	call   800d28 <sys_page_alloc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	0f 88 bc 00 00 00    	js     80201e <pipe+0x131>
	va = fd2data(fd0);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 f4             	push   -0xc(%ebp)
  801f68:	e8 bc ef ff ff       	call   800f29 <fd2data>
  801f6d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6f:	83 c4 0c             	add    $0xc,%esp
  801f72:	68 07 04 00 00       	push   $0x407
  801f77:	50                   	push   %eax
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 a9 ed ff ff       	call   800d28 <sys_page_alloc>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	0f 88 82 00 00 00    	js     80200e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	ff 75 f0             	push   -0x10(%ebp)
  801f92:	e8 92 ef ff ff       	call   800f29 <fd2data>
  801f97:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f9e:	50                   	push   %eax
  801f9f:	6a 00                	push   $0x0
  801fa1:	56                   	push   %esi
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 c2 ed ff ff       	call   800d6b <sys_page_map>
  801fa9:	89 c3                	mov    %eax,%ebx
  801fab:	83 c4 20             	add    $0x20,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 4e                	js     802000 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fb2:	a1 20 30 80 00       	mov    0x803020,%eax
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 f4             	push   -0xc(%ebp)
  801fdb:	e8 39 ef ff ff       	call   800f19 <fd2num>
  801fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fe3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fe5:	83 c4 04             	add    $0x4,%esp
  801fe8:	ff 75 f0             	push   -0x10(%ebp)
  801feb:	e8 29 ef ff ff       	call   800f19 <fd2num>
  801ff0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ffe:	eb 2e                	jmp    80202e <pipe+0x141>
	sys_page_unmap(0, va);
  802000:	83 ec 08             	sub    $0x8,%esp
  802003:	56                   	push   %esi
  802004:	6a 00                	push   $0x0
  802006:	e8 a2 ed ff ff       	call   800dad <sys_page_unmap>
  80200b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 f0             	push   -0x10(%ebp)
  802014:	6a 00                	push   $0x0
  802016:	e8 92 ed ff ff       	call   800dad <sys_page_unmap>
  80201b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	ff 75 f4             	push   -0xc(%ebp)
  802024:	6a 00                	push   $0x0
  802026:	e8 82 ed ff ff       	call   800dad <sys_page_unmap>
  80202b:	83 c4 10             	add    $0x10,%esp
}
  80202e:	89 d8                	mov    %ebx,%eax
  802030:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    

00802037 <pipeisclosed>:
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80203d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802040:	50                   	push   %eax
  802041:	ff 75 08             	push   0x8(%ebp)
  802044:	e8 47 ef ff ff       	call   800f90 <fd_lookup>
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 18                	js     802068 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	ff 75 f4             	push   -0xc(%ebp)
  802056:	e8 ce ee ff ff       	call   800f29 <fd2data>
  80205b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	e8 33 fd ff ff       	call   801d98 <_pipeisclosed>
  802065:	83 c4 10             	add    $0x10,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	c3                   	ret    

00802070 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802076:	68 e5 2a 80 00       	push   $0x802ae5
  80207b:	ff 75 0c             	push   0xc(%ebp)
  80207e:	e8 a9 e8 ff ff       	call   80092c <strcpy>
	return 0;
}
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <devcons_write>:
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	57                   	push   %edi
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802096:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80209b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020a1:	eb 2e                	jmp    8020d1 <devcons_write+0x47>
		m = n - tot;
  8020a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020a6:	29 f3                	sub    %esi,%ebx
  8020a8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ad:	39 c3                	cmp    %eax,%ebx
  8020af:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	53                   	push   %ebx
  8020b6:	89 f0                	mov    %esi,%eax
  8020b8:	03 45 0c             	add    0xc(%ebp),%eax
  8020bb:	50                   	push   %eax
  8020bc:	57                   	push   %edi
  8020bd:	e8 00 ea ff ff       	call   800ac2 <memmove>
		sys_cputs(buf, m);
  8020c2:	83 c4 08             	add    $0x8,%esp
  8020c5:	53                   	push   %ebx
  8020c6:	57                   	push   %edi
  8020c7:	e8 a0 eb ff ff       	call   800c6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020cc:	01 de                	add    %ebx,%esi
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020d4:	72 cd                	jb     8020a3 <devcons_write+0x19>
}
  8020d6:	89 f0                	mov    %esi,%eax
  8020d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5e                   	pop    %esi
  8020dd:	5f                   	pop    %edi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <devcons_read>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ef:	75 07                	jne    8020f8 <devcons_read+0x18>
  8020f1:	eb 1f                	jmp    802112 <devcons_read+0x32>
		sys_yield();
  8020f3:	e8 11 ec ff ff       	call   800d09 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020f8:	e8 8d eb ff ff       	call   800c8a <sys_cgetc>
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	74 f2                	je     8020f3 <devcons_read+0x13>
	if (c < 0)
  802101:	78 0f                	js     802112 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802103:	83 f8 04             	cmp    $0x4,%eax
  802106:	74 0c                	je     802114 <devcons_read+0x34>
	*(char*)vbuf = c;
  802108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210b:	88 02                	mov    %al,(%edx)
	return 1;
  80210d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    
		return 0;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	eb f7                	jmp    802112 <devcons_read+0x32>

0080211b <cputchar>:
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802127:	6a 01                	push   $0x1
  802129:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80212c:	50                   	push   %eax
  80212d:	e8 3a eb ff ff       	call   800c6c <sys_cputs>
}
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <getchar>:
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80213d:	6a 01                	push   $0x1
  80213f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802142:	50                   	push   %eax
  802143:	6a 00                	push   $0x0
  802145:	e8 aa f0 ff ff       	call   8011f4 <read>
	if (r < 0)
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 06                	js     802157 <getchar+0x20>
	if (r < 1)
  802151:	74 06                	je     802159 <getchar+0x22>
	return c;
  802153:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    
		return -E_EOF;
  802159:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80215e:	eb f7                	jmp    802157 <getchar+0x20>

00802160 <iscons>:
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802166:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802169:	50                   	push   %eax
  80216a:	ff 75 08             	push   0x8(%ebp)
  80216d:	e8 1e ee ff ff       	call   800f90 <fd_lookup>
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	78 11                	js     80218a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802182:	39 10                	cmp    %edx,(%eax)
  802184:	0f 94 c0             	sete   %al
  802187:	0f b6 c0             	movzbl %al,%eax
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <opencons>:
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802195:	50                   	push   %eax
  802196:	e8 a5 ed ff ff       	call   800f40 <fd_alloc>
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 3a                	js     8021dc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 07 04 00 00       	push   $0x407
  8021aa:	ff 75 f4             	push   -0xc(%ebp)
  8021ad:	6a 00                	push   $0x0
  8021af:	e8 74 eb ff ff       	call   800d28 <sys_page_alloc>
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	78 21                	js     8021dc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021c4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	50                   	push   %eax
  8021d4:	e8 40 ed ff ff       	call   800f19 <fd2num>
  8021d9:	83 c4 10             	add    $0x10,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff 75 0c             	push   0xc(%ebp)
  8021ef:	e8 e4 ec ff ff       	call   800ed8 <sys_ipc_recv>
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 2b                	js     802226 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8021fb:	85 f6                	test   %esi,%esi
  8021fd:	74 0a                	je     802209 <ipc_recv+0x2b>
  8021ff:	a1 00 40 80 00       	mov    0x804000,%eax
  802204:	8b 40 74             	mov    0x74(%eax),%eax
  802207:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802209:	85 db                	test   %ebx,%ebx
  80220b:	74 0a                	je     802217 <ipc_recv+0x39>
  80220d:	a1 00 40 80 00       	mov    0x804000,%eax
  802212:	8b 40 78             	mov    0x78(%eax),%eax
  802215:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802217:	a1 00 40 80 00       	mov    0x804000,%eax
  80221c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80221f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802222:	5b                   	pop    %ebx
  802223:	5e                   	pop    %esi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80222b:	eb f2                	jmp    80221f <ipc_recv+0x41>

0080222d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	57                   	push   %edi
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	83 ec 0c             	sub    $0xc,%esp
  802236:	8b 7d 08             	mov    0x8(%ebp),%edi
  802239:	8b 75 0c             	mov    0xc(%ebp),%esi
  80223c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80223f:	ff 75 14             	push   0x14(%ebp)
  802242:	53                   	push   %ebx
  802243:	56                   	push   %esi
  802244:	57                   	push   %edi
  802245:	e8 6b ec ff ff       	call   800eb5 <sys_ipc_try_send>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	79 20                	jns    802271 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802251:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802254:	75 07                	jne    80225d <ipc_send+0x30>
		sys_yield();
  802256:	e8 ae ea ff ff       	call   800d09 <sys_yield>
  80225b:	eb e2                	jmp    80223f <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 f1 2a 80 00       	push   $0x802af1
  802265:	6a 2e                	push   $0x2e
  802267:	68 01 2b 80 00       	push   $0x802b01
  80226c:	e8 1b df ff ff       	call   80018c <_panic>
	}
}
  802271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5f                   	pop    %edi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802284:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802287:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80228d:	8b 52 50             	mov    0x50(%edx),%edx
  802290:	39 ca                	cmp    %ecx,%edx
  802292:	74 11                	je     8022a5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802294:	83 c0 01             	add    $0x1,%eax
  802297:	3d 00 04 00 00       	cmp    $0x400,%eax
  80229c:	75 e6                	jne    802284 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	eb 0b                	jmp    8022b0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8022a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ad:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b0:	5d                   	pop    %ebp
  8022b1:	c3                   	ret    

008022b2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	c1 ea 16             	shr    $0x16,%edx
  8022bd:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022c4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c9:	f6 c1 01             	test   $0x1,%cl
  8022cc:	74 1c                	je     8022ea <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8022ce:	c1 e8 0c             	shr    $0xc,%eax
  8022d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022d8:	a8 01                	test   $0x1,%al
  8022da:	74 0e                	je     8022ea <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022dc:	c1 e8 0c             	shr    $0xc,%eax
  8022df:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022e6:	ef 
  8022e7:	0f b7 d2             	movzwl %dx,%edx
}
  8022ea:	89 d0                	mov    %edx,%eax
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__udivdi3>:
  8022f0:	f3 0f 1e fb          	endbr32 
  8022f4:	55                   	push   %ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802303:	8b 74 24 34          	mov    0x34(%esp),%esi
  802307:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80230b:	85 c0                	test   %eax,%eax
  80230d:	75 19                	jne    802328 <__udivdi3+0x38>
  80230f:	39 f3                	cmp    %esi,%ebx
  802311:	76 4d                	jbe    802360 <__udivdi3+0x70>
  802313:	31 ff                	xor    %edi,%edi
  802315:	89 e8                	mov    %ebp,%eax
  802317:	89 f2                	mov    %esi,%edx
  802319:	f7 f3                	div    %ebx
  80231b:	89 fa                	mov    %edi,%edx
  80231d:	83 c4 1c             	add    $0x1c,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	39 f0                	cmp    %esi,%eax
  80232a:	76 14                	jbe    802340 <__udivdi3+0x50>
  80232c:	31 ff                	xor    %edi,%edi
  80232e:	31 c0                	xor    %eax,%eax
  802330:	89 fa                	mov    %edi,%edx
  802332:	83 c4 1c             	add    $0x1c,%esp
  802335:	5b                   	pop    %ebx
  802336:	5e                   	pop    %esi
  802337:	5f                   	pop    %edi
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    
  80233a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802340:	0f bd f8             	bsr    %eax,%edi
  802343:	83 f7 1f             	xor    $0x1f,%edi
  802346:	75 48                	jne    802390 <__udivdi3+0xa0>
  802348:	39 f0                	cmp    %esi,%eax
  80234a:	72 06                	jb     802352 <__udivdi3+0x62>
  80234c:	31 c0                	xor    %eax,%eax
  80234e:	39 eb                	cmp    %ebp,%ebx
  802350:	77 de                	ja     802330 <__udivdi3+0x40>
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	eb d7                	jmp    802330 <__udivdi3+0x40>
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	89 d9                	mov    %ebx,%ecx
  802362:	85 db                	test   %ebx,%ebx
  802364:	75 0b                	jne    802371 <__udivdi3+0x81>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f3                	div    %ebx
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	31 d2                	xor    %edx,%edx
  802373:	89 f0                	mov    %esi,%eax
  802375:	f7 f1                	div    %ecx
  802377:	89 c6                	mov    %eax,%esi
  802379:	89 e8                	mov    %ebp,%eax
  80237b:	89 f7                	mov    %esi,%edi
  80237d:	f7 f1                	div    %ecx
  80237f:	89 fa                	mov    %edi,%edx
  802381:	83 c4 1c             	add    $0x1c,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5f                   	pop    %edi
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	ba 20 00 00 00       	mov    $0x20,%edx
  802397:	29 fa                	sub    %edi,%edx
  802399:	d3 e0                	shl    %cl,%eax
  80239b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80239f:	89 d1                	mov    %edx,%ecx
  8023a1:	89 d8                	mov    %ebx,%eax
  8023a3:	d3 e8                	shr    %cl,%eax
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 c1                	or     %eax,%ecx
  8023ab:	89 f0                	mov    %esi,%eax
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 d1                	mov    %edx,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 f3                	or     %esi,%ebx
  8023c9:	89 c6                	mov    %eax,%esi
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 d8                	mov    %ebx,%eax
  8023cf:	f7 74 24 08          	divl   0x8(%esp)
  8023d3:	89 d6                	mov    %edx,%esi
  8023d5:	89 c3                	mov    %eax,%ebx
  8023d7:	f7 64 24 0c          	mull   0xc(%esp)
  8023db:	39 d6                	cmp    %edx,%esi
  8023dd:	72 19                	jb     8023f8 <__udivdi3+0x108>
  8023df:	89 f9                	mov    %edi,%ecx
  8023e1:	d3 e5                	shl    %cl,%ebp
  8023e3:	39 c5                	cmp    %eax,%ebp
  8023e5:	73 04                	jae    8023eb <__udivdi3+0xfb>
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	74 0d                	je     8023f8 <__udivdi3+0x108>
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	31 ff                	xor    %edi,%edi
  8023ef:	e9 3c ff ff ff       	jmp    802330 <__udivdi3+0x40>
  8023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023fb:	31 ff                	xor    %edi,%edi
  8023fd:	e9 2e ff ff ff       	jmp    802330 <__udivdi3+0x40>
  802402:	66 90                	xchg   %ax,%ax
  802404:	66 90                	xchg   %ax,%ax
  802406:	66 90                	xchg   %ax,%ax
  802408:	66 90                	xchg   %ax,%ax
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	f3 0f 1e fb          	endbr32 
  802414:	55                   	push   %ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	83 ec 1c             	sub    $0x1c,%esp
  80241b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80241f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802423:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802427:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	89 da                	mov    %ebx,%edx
  80242f:	85 ff                	test   %edi,%edi
  802431:	75 15                	jne    802448 <__umoddi3+0x38>
  802433:	39 dd                	cmp    %ebx,%ebp
  802435:	76 39                	jbe    802470 <__umoddi3+0x60>
  802437:	f7 f5                	div    %ebp
  802439:	89 d0                	mov    %edx,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	39 df                	cmp    %ebx,%edi
  80244a:	77 f1                	ja     80243d <__umoddi3+0x2d>
  80244c:	0f bd cf             	bsr    %edi,%ecx
  80244f:	83 f1 1f             	xor    $0x1f,%ecx
  802452:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802456:	75 40                	jne    802498 <__umoddi3+0x88>
  802458:	39 df                	cmp    %ebx,%edi
  80245a:	72 04                	jb     802460 <__umoddi3+0x50>
  80245c:	39 f5                	cmp    %esi,%ebp
  80245e:	77 dd                	ja     80243d <__umoddi3+0x2d>
  802460:	89 da                	mov    %ebx,%edx
  802462:	89 f0                	mov    %esi,%eax
  802464:	29 e8                	sub    %ebp,%eax
  802466:	19 fa                	sbb    %edi,%edx
  802468:	eb d3                	jmp    80243d <__umoddi3+0x2d>
  80246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802470:	89 e9                	mov    %ebp,%ecx
  802472:	85 ed                	test   %ebp,%ebp
  802474:	75 0b                	jne    802481 <__umoddi3+0x71>
  802476:	b8 01 00 00 00       	mov    $0x1,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f5                	div    %ebp
  80247f:	89 c1                	mov    %eax,%ecx
  802481:	89 d8                	mov    %ebx,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f1                	div    %ecx
  802487:	89 f0                	mov    %esi,%eax
  802489:	f7 f1                	div    %ecx
  80248b:	89 d0                	mov    %edx,%eax
  80248d:	31 d2                	xor    %edx,%edx
  80248f:	eb ac                	jmp    80243d <__umoddi3+0x2d>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	8b 44 24 04          	mov    0x4(%esp),%eax
  80249c:	ba 20 00 00 00       	mov    $0x20,%edx
  8024a1:	29 c2                	sub    %eax,%edx
  8024a3:	89 c1                	mov    %eax,%ecx
  8024a5:	89 e8                	mov    %ebp,%eax
  8024a7:	d3 e7                	shl    %cl,%edi
  8024a9:	89 d1                	mov    %edx,%ecx
  8024ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024af:	d3 e8                	shr    %cl,%eax
  8024b1:	89 c1                	mov    %eax,%ecx
  8024b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024b7:	09 f9                	or     %edi,%ecx
  8024b9:	89 df                	mov    %ebx,%edi
  8024bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024bf:	89 c1                	mov    %eax,%ecx
  8024c1:	d3 e5                	shl    %cl,%ebp
  8024c3:	89 d1                	mov    %edx,%ecx
  8024c5:	d3 ef                	shr    %cl,%edi
  8024c7:	89 c1                	mov    %eax,%ecx
  8024c9:	89 f0                	mov    %esi,%eax
  8024cb:	d3 e3                	shl    %cl,%ebx
  8024cd:	89 d1                	mov    %edx,%ecx
  8024cf:	89 fa                	mov    %edi,%edx
  8024d1:	d3 e8                	shr    %cl,%eax
  8024d3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024d8:	09 d8                	or     %ebx,%eax
  8024da:	f7 74 24 08          	divl   0x8(%esp)
  8024de:	89 d3                	mov    %edx,%ebx
  8024e0:	d3 e6                	shl    %cl,%esi
  8024e2:	f7 e5                	mul    %ebp
  8024e4:	89 c7                	mov    %eax,%edi
  8024e6:	89 d1                	mov    %edx,%ecx
  8024e8:	39 d3                	cmp    %edx,%ebx
  8024ea:	72 06                	jb     8024f2 <__umoddi3+0xe2>
  8024ec:	75 0e                	jne    8024fc <__umoddi3+0xec>
  8024ee:	39 c6                	cmp    %eax,%esi
  8024f0:	73 0a                	jae    8024fc <__umoddi3+0xec>
  8024f2:	29 e8                	sub    %ebp,%eax
  8024f4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024f8:	89 d1                	mov    %edx,%ecx
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	89 f5                	mov    %esi,%ebp
  8024fe:	8b 74 24 04          	mov    0x4(%esp),%esi
  802502:	29 fd                	sub    %edi,%ebp
  802504:	19 cb                	sbb    %ecx,%ebx
  802506:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	d3 e0                	shl    %cl,%eax
  80250f:	89 f1                	mov    %esi,%ecx
  802511:	d3 ed                	shr    %cl,%ebp
  802513:	d3 eb                	shr    %cl,%ebx
  802515:	09 e8                	or     %ebp,%eax
  802517:	89 da                	mov    %ebx,%edx
  802519:	83 c4 1c             	add    $0x1c,%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5f                   	pop    %edi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
