
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 5c 0c 00 00       	call   800c99 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 7e 0f 00 00       	call   800fc7 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 5e 0c 00 00       	call   800cb8 <sys_yield>
		return;
  80005a:	eb 69                	jmp    8000c5 <umain+0x92>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	89 f0                	mov    %esi,%eax
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	eb 02                	jmp    80006f <umain+0x3c>
		asm volatile("pause");
  80006d:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006f:	8b 50 54             	mov    0x54(%eax),%edx
  800072:	85 d2                	test   %edx,%edx
  800074:	75 f7                	jne    80006d <umain+0x3a>
  800076:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007b:	e8 38 0c 00 00       	call   800cb8 <sys_yield>
  800080:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c0 01             	add    $0x1,%eax
  80008d:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800092:	83 ea 01             	sub    $0x1,%edx
  800095:	75 ee                	jne    800085 <umain+0x52>
	for (i = 0; i < 10; i++) {
  800097:	83 eb 01             	sub    $0x1,%ebx
  80009a:	75 df                	jne    80007b <umain+0x48>
	}

	if (counter != 10*10000)
  80009c:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a1:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a6:	75 24                	jne    8000cc <umain+0x99>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000a8:	a1 08 20 80 00       	mov    0x802008,%eax
  8000ad:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b0:	8b 40 48             	mov    0x48(%eax),%eax
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	52                   	push   %edx
  8000b7:	50                   	push   %eax
  8000b8:	68 7b 14 80 00       	push   $0x80147b
  8000bd:	e8 54 01 00 00       	call   800216 <cprintf>
  8000c2:	83 c4 10             	add    $0x10,%esp

}
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cc:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d1:	50                   	push   %eax
  8000d2:	68 40 14 80 00       	push   $0x801440
  8000d7:	6a 21                	push   $0x21
  8000d9:	68 68 14 80 00       	push   $0x801468
  8000de:	e8 58 00 00 00       	call   80013b <_panic>

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 a6 0b 00 00       	call   800c99 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 19 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80012f:	6a 00                	push   $0x0
  800131:	e8 22 0b 00 00       	call   800c58 <sys_env_destroy>
}
  800136:	83 c4 10             	add    $0x10,%esp
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	56                   	push   %esi
  80013f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800140:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800143:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800149:	e8 4b 0b 00 00       	call   800c99 <sys_getenvid>
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	ff 75 0c             	push   0xc(%ebp)
  800154:	ff 75 08             	push   0x8(%ebp)
  800157:	56                   	push   %esi
  800158:	50                   	push   %eax
  800159:	68 a4 14 80 00       	push   $0x8014a4
  80015e:	e8 b3 00 00 00       	call   800216 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800163:	83 c4 18             	add    $0x18,%esp
  800166:	53                   	push   %ebx
  800167:	ff 75 10             	push   0x10(%ebp)
  80016a:	e8 56 00 00 00       	call   8001c5 <vcprintf>
	cprintf("\n");
  80016f:	c7 04 24 97 14 80 00 	movl   $0x801497,(%esp)
  800176:	e8 9b 00 00 00       	call   800216 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017e:	cc                   	int3   
  80017f:	eb fd                	jmp    80017e <_panic+0x43>

00800181 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	53                   	push   %ebx
  800185:	83 ec 04             	sub    $0x4,%esp
  800188:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018b:	8b 13                	mov    (%ebx),%edx
  80018d:	8d 42 01             	lea    0x1(%edx),%eax
  800190:	89 03                	mov    %eax,(%ebx)
  800192:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800195:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800199:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019e:	74 09                	je     8001a9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	68 ff 00 00 00       	push   $0xff
  8001b1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b4:	50                   	push   %eax
  8001b5:	e8 61 0a 00 00       	call   800c1b <sys_cputs>
		b->idx = 0;
  8001ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	eb db                	jmp    8001a0 <putch+0x1f>

008001c5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d5:	00 00 00 
	b.cnt = 0;
  8001d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001df:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e2:	ff 75 0c             	push   0xc(%ebp)
  8001e5:	ff 75 08             	push   0x8(%ebp)
  8001e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	68 81 01 80 00       	push   $0x800181
  8001f4:	e8 14 01 00 00       	call   80030d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f9:	83 c4 08             	add    $0x8,%esp
  8001fc:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800202:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	e8 0d 0a 00 00       	call   800c1b <sys_cputs>

	return b.cnt;
}
  80020e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021f:	50                   	push   %eax
  800220:	ff 75 08             	push   0x8(%ebp)
  800223:	e8 9d ff ff ff       	call   8001c5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 1c             	sub    $0x1c,%esp
  800233:	89 c7                	mov    %eax,%edi
  800235:	89 d6                	mov    %edx,%esi
  800237:	8b 45 08             	mov    0x8(%ebp),%eax
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	89 d1                	mov    %edx,%ecx
  80023f:	89 c2                	mov    %eax,%edx
  800241:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800244:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800247:	8b 45 10             	mov    0x10(%ebp),%eax
  80024a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800250:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800257:	39 c2                	cmp    %eax,%edx
  800259:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80025c:	72 3e                	jb     80029c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 75 18             	push   0x18(%ebp)
  800264:	83 eb 01             	sub    $0x1,%ebx
  800267:	53                   	push   %ebx
  800268:	50                   	push   %eax
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	ff 75 e4             	push   -0x1c(%ebp)
  80026f:	ff 75 e0             	push   -0x20(%ebp)
  800272:	ff 75 dc             	push   -0x24(%ebp)
  800275:	ff 75 d8             	push   -0x28(%ebp)
  800278:	e8 83 0f 00 00       	call   801200 <__udivdi3>
  80027d:	83 c4 18             	add    $0x18,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	89 f2                	mov    %esi,%edx
  800284:	89 f8                	mov    %edi,%eax
  800286:	e8 9f ff ff ff       	call   80022a <printnum>
  80028b:	83 c4 20             	add    $0x20,%esp
  80028e:	eb 13                	jmp    8002a3 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	56                   	push   %esi
  800294:	ff 75 18             	push   0x18(%ebp)
  800297:	ff d7                	call   *%edi
  800299:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029c:	83 eb 01             	sub    $0x1,%ebx
  80029f:	85 db                	test   %ebx,%ebx
  8002a1:	7f ed                	jg     800290 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	56                   	push   %esi
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	ff 75 e4             	push   -0x1c(%ebp)
  8002ad:	ff 75 e0             	push   -0x20(%ebp)
  8002b0:	ff 75 dc             	push   -0x24(%ebp)
  8002b3:	ff 75 d8             	push   -0x28(%ebp)
  8002b6:	e8 65 10 00 00       	call   801320 <__umoddi3>
  8002bb:	83 c4 14             	add    $0x14,%esp
  8002be:	0f be 80 c7 14 80 00 	movsbl 0x8014c7(%eax),%eax
  8002c5:	50                   	push   %eax
  8002c6:	ff d7                	call   *%edi
}
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002dd:	8b 10                	mov    (%eax),%edx
  8002df:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e2:	73 0a                	jae    8002ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e7:	89 08                	mov    %ecx,(%eax)
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	88 02                	mov    %al,(%edx)
}
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <printfmt>:
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f9:	50                   	push   %eax
  8002fa:	ff 75 10             	push   0x10(%ebp)
  8002fd:	ff 75 0c             	push   0xc(%ebp)
  800300:	ff 75 08             	push   0x8(%ebp)
  800303:	e8 05 00 00 00       	call   80030d <vprintfmt>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <vprintfmt>:
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 3c             	sub    $0x3c,%esp
  800316:	8b 75 08             	mov    0x8(%ebp),%esi
  800319:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031f:	eb 0a                	jmp    80032b <vprintfmt+0x1e>
			putch(ch, putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	53                   	push   %ebx
  800325:	50                   	push   %eax
  800326:	ff d6                	call   *%esi
  800328:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80032b:	83 c7 01             	add    $0x1,%edi
  80032e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800332:	83 f8 25             	cmp    $0x25,%eax
  800335:	74 0c                	je     800343 <vprintfmt+0x36>
			if (ch == '\0')
  800337:	85 c0                	test   %eax,%eax
  800339:	75 e6                	jne    800321 <vprintfmt+0x14>
}
  80033b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033e:	5b                   	pop    %ebx
  80033f:	5e                   	pop    %esi
  800340:	5f                   	pop    %edi
  800341:	5d                   	pop    %ebp
  800342:	c3                   	ret    
		padc = ' ';
  800343:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800347:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800355:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8d 47 01             	lea    0x1(%edi),%eax
  800364:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800367:	0f b6 17             	movzbl (%edi),%edx
  80036a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036d:	3c 55                	cmp    $0x55,%al
  80036f:	0f 87 a6 04 00 00    	ja     80081b <vprintfmt+0x50e>
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	ff 24 85 00 16 80 00 	jmp    *0x801600(,%eax,4)
  80037f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800382:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800386:	eb d9                	jmp    800361 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80038b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80038f:	eb d0                	jmp    800361 <vprintfmt+0x54>
  800391:	0f b6 d2             	movzbl %dl,%edx
  800394:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800397:	b8 00 00 00 00       	mov    $0x0,%eax
  80039c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80039f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ac:	83 f9 09             	cmp    $0x9,%ecx
  8003af:	77 55                	ja     800406 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003b1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b4:	eb e9                	jmp    80039f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 40 04             	lea    0x4(%eax),%eax
  8003c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003ce:	79 91                	jns    800361 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003dd:	eb 82                	jmp    800361 <vprintfmt+0x54>
  8003df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003e2:	85 d2                	test   %edx,%edx
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e9:	0f 49 c2             	cmovns %edx,%eax
  8003ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003f2:	e9 6a ff ff ff       	jmp    800361 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003fa:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800401:	e9 5b ff ff ff       	jmp    800361 <vprintfmt+0x54>
  800406:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800409:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040c:	eb bc                	jmp    8003ca <vprintfmt+0xbd>
			lflag++;
  80040e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800414:	e9 48 ff ff ff       	jmp    800361 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 30                	push   (%eax)
  800425:	ff d6                	call   *%esi
			break;
  800427:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042d:	e9 88 03 00 00       	jmp    8007ba <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	8b 10                	mov    (%eax),%edx
  80043a:	89 d0                	mov    %edx,%eax
  80043c:	f7 d8                	neg    %eax
  80043e:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800441:	83 f8 0f             	cmp    $0xf,%eax
  800444:	7f 23                	jg     800469 <vprintfmt+0x15c>
  800446:	8b 14 85 60 17 80 00 	mov    0x801760(,%eax,4),%edx
  80044d:	85 d2                	test   %edx,%edx
  80044f:	74 18                	je     800469 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800451:	52                   	push   %edx
  800452:	68 e8 14 80 00       	push   $0x8014e8
  800457:	53                   	push   %ebx
  800458:	56                   	push   %esi
  800459:	e8 92 fe ff ff       	call   8002f0 <printfmt>
  80045e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800461:	89 7d 14             	mov    %edi,0x14(%ebp)
  800464:	e9 51 03 00 00       	jmp    8007ba <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800469:	50                   	push   %eax
  80046a:	68 df 14 80 00       	push   $0x8014df
  80046f:	53                   	push   %ebx
  800470:	56                   	push   %esi
  800471:	e8 7a fe ff ff       	call   8002f0 <printfmt>
  800476:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800479:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047c:	e9 39 03 00 00       	jmp    8007ba <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	83 c0 04             	add    $0x4,%eax
  800487:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80048f:	85 d2                	test   %edx,%edx
  800491:	b8 d8 14 80 00       	mov    $0x8014d8,%eax
  800496:	0f 45 c2             	cmovne %edx,%eax
  800499:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80049c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a0:	7e 06                	jle    8004a8 <vprintfmt+0x19b>
  8004a2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a6:	75 0d                	jne    8004b5 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ab:	89 c7                	mov    %eax,%edi
  8004ad:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004b3:	eb 55                	jmp    80050a <vprintfmt+0x1fd>
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 e0             	push   -0x20(%ebp)
  8004bb:	ff 75 cc             	push   -0x34(%ebp)
  8004be:	e8 f5 03 00 00       	call   8008b8 <strnlen>
  8004c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c6:	29 c2                	sub    %eax,%edx
  8004c8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	eb 0f                	jmp    8004e8 <vprintfmt+0x1db>
					putch(padc, putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	ff 75 d4             	push   -0x2c(%ebp)
  8004e0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e2:	83 ef 01             	sub    $0x1,%edi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	85 ff                	test   %edi,%edi
  8004ea:	7f ed                	jg     8004d9 <vprintfmt+0x1cc>
  8004ec:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	0f 49 c2             	cmovns %edx,%eax
  8004f9:	29 c2                	sub    %eax,%edx
  8004fb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004fe:	eb a8                	jmp    8004a8 <vprintfmt+0x19b>
					putch(ch, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	52                   	push   %edx
  800505:	ff d6                	call   *%esi
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80050d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	83 c7 01             	add    $0x1,%edi
  800512:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800516:	0f be d0             	movsbl %al,%edx
  800519:	85 d2                	test   %edx,%edx
  80051b:	74 4b                	je     800568 <vprintfmt+0x25b>
  80051d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800521:	78 06                	js     800529 <vprintfmt+0x21c>
  800523:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800527:	78 1e                	js     800547 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800529:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052d:	74 d1                	je     800500 <vprintfmt+0x1f3>
  80052f:	0f be c0             	movsbl %al,%eax
  800532:	83 e8 20             	sub    $0x20,%eax
  800535:	83 f8 5e             	cmp    $0x5e,%eax
  800538:	76 c6                	jbe    800500 <vprintfmt+0x1f3>
					putch('?', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 3f                	push   $0x3f
  800540:	ff d6                	call   *%esi
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb c3                	jmp    80050a <vprintfmt+0x1fd>
  800547:	89 cf                	mov    %ecx,%edi
  800549:	eb 0e                	jmp    800559 <vprintfmt+0x24c>
				putch(' ', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	6a 20                	push   $0x20
  800551:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800553:	83 ef 01             	sub    $0x1,%edi
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	85 ff                	test   %edi,%edi
  80055b:	7f ee                	jg     80054b <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80055d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	e9 52 02 00 00       	jmp    8007ba <vprintfmt+0x4ad>
  800568:	89 cf                	mov    %ecx,%edi
  80056a:	eb ed                	jmp    800559 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 c0 04             	add    $0x4,%eax
  800572:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80057a:	85 d2                	test   %edx,%edx
  80057c:	b8 d8 14 80 00       	mov    $0x8014d8,%eax
  800581:	0f 45 c2             	cmovne %edx,%eax
  800584:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800587:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058b:	7e 06                	jle    800593 <vprintfmt+0x286>
  80058d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800591:	75 0d                	jne    8005a0 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800596:	89 c7                	mov    %eax,%edi
  800598:	03 45 d4             	add    -0x2c(%ebp),%eax
  80059b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059e:	eb 55                	jmp    8005f5 <vprintfmt+0x2e8>
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	ff 75 e0             	push   -0x20(%ebp)
  8005a6:	ff 75 cc             	push   -0x34(%ebp)
  8005a9:	e8 0a 03 00 00       	call   8008b8 <strnlen>
  8005ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b1:	29 c2                	sub    %eax,%edx
  8005b3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005bb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c2:	eb 0f                	jmp    8005d3 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	ff 75 d4             	push   -0x2c(%ebp)
  8005cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	83 ef 01             	sub    $0x1,%edi
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	7f ed                	jg     8005c4 <vprintfmt+0x2b7>
  8005d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005da:	85 d2                	test   %edx,%edx
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	0f 49 c2             	cmovns %edx,%eax
  8005e4:	29 c2                	sub    %eax,%edx
  8005e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e9:	eb a8                	jmp    800593 <vprintfmt+0x286>
					putch(ch, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	52                   	push   %edx
  8005f0:	ff d6                	call   *%esi
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005f8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005fa:	83 c7 01             	add    $0x1,%edi
  8005fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800601:	0f be d0             	movsbl %al,%edx
  800604:	3c 3a                	cmp    $0x3a,%al
  800606:	74 4b                	je     800653 <vprintfmt+0x346>
  800608:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060c:	78 06                	js     800614 <vprintfmt+0x307>
  80060e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800612:	78 1e                	js     800632 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800614:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800618:	74 d1                	je     8005eb <vprintfmt+0x2de>
  80061a:	0f be c0             	movsbl %al,%eax
  80061d:	83 e8 20             	sub    $0x20,%eax
  800620:	83 f8 5e             	cmp    $0x5e,%eax
  800623:	76 c6                	jbe    8005eb <vprintfmt+0x2de>
					putch('?', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 3f                	push   $0x3f
  80062b:	ff d6                	call   *%esi
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb c3                	jmp    8005f5 <vprintfmt+0x2e8>
  800632:	89 cf                	mov    %ecx,%edi
  800634:	eb 0e                	jmp    800644 <vprintfmt+0x337>
				putch(' ', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 20                	push   $0x20
  80063c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063e:	83 ef 01             	sub    $0x1,%edi
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	85 ff                	test   %edi,%edi
  800646:	7f ee                	jg     800636 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800648:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	e9 67 01 00 00       	jmp    8007ba <vprintfmt+0x4ad>
  800653:	89 cf                	mov    %ecx,%edi
  800655:	eb ed                	jmp    800644 <vprintfmt+0x337>
	if (lflag >= 2)
  800657:	83 f9 01             	cmp    $0x1,%ecx
  80065a:	7f 1b                	jg     800677 <vprintfmt+0x36a>
	else if (lflag)
  80065c:	85 c9                	test   %ecx,%ecx
  80065e:	74 63                	je     8006c3 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800668:	99                   	cltd   
  800669:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 04             	lea    0x4(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	eb 17                	jmp    80068e <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 50 04             	mov    0x4(%eax),%edx
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800682:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800691:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800694:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	0f 89 ff 00 00 00    	jns    8007a0 <vprintfmt+0x493>
				putch('-', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 2d                	push   $0x2d
  8006a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006af:	f7 da                	neg    %edx
  8006b1:	83 d1 00             	adc    $0x0,%ecx
  8006b4:	f7 d9                	neg    %ecx
  8006b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006be:	e9 dd 00 00 00       	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cb:	99                   	cltd   
  8006cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 40 04             	lea    0x4(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d8:	eb b4                	jmp    80068e <vprintfmt+0x381>
	if (lflag >= 2)
  8006da:	83 f9 01             	cmp    $0x1,%ecx
  8006dd:	7f 1e                	jg     8006fd <vprintfmt+0x3f0>
	else if (lflag)
  8006df:	85 c9                	test   %ecx,%ecx
  8006e1:	74 32                	je     800715 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006f8:	e9 a3 00 00 00       	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	8b 48 04             	mov    0x4(%eax),%ecx
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800710:	e9 8b 00 00 00       	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 10                	mov    (%eax),%edx
  80071a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800725:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80072a:	eb 74                	jmp    8007a0 <vprintfmt+0x493>
	if (lflag >= 2)
  80072c:	83 f9 01             	cmp    $0x1,%ecx
  80072f:	7f 1b                	jg     80074c <vprintfmt+0x43f>
	else if (lflag)
  800731:	85 c9                	test   %ecx,%ecx
  800733:	74 2c                	je     800761 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 10                	mov    (%eax),%edx
  80073a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800745:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80074a:	eb 54                	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 10                	mov    (%eax),%edx
  800751:	8b 48 04             	mov    0x4(%eax),%ecx
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80075f:	eb 3f                	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 10                	mov    (%eax),%edx
  800766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800771:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800776:	eb 28                	jmp    8007a0 <vprintfmt+0x493>
			putch('0', putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	53                   	push   %ebx
  80077c:	6a 30                	push   $0x30
  80077e:	ff d6                	call   *%esi
			putch('x', putdat);
  800780:	83 c4 08             	add    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 78                	push   $0x78
  800786:	ff d6                	call   *%esi
			num = (unsigned long long)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 10                	mov    (%eax),%edx
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800792:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800795:	8d 40 04             	lea    0x4(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079b:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8007a0:	83 ec 0c             	sub    $0xc,%esp
  8007a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007a7:	50                   	push   %eax
  8007a8:	ff 75 d4             	push   -0x2c(%ebp)
  8007ab:	57                   	push   %edi
  8007ac:	51                   	push   %ecx
  8007ad:	52                   	push   %edx
  8007ae:	89 da                	mov    %ebx,%edx
  8007b0:	89 f0                	mov    %esi,%eax
  8007b2:	e8 73 fa ff ff       	call   80022a <printnum>
			break;
  8007b7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ba:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bd:	e9 69 fb ff ff       	jmp    80032b <vprintfmt+0x1e>
	if (lflag >= 2)
  8007c2:	83 f9 01             	cmp    $0x1,%ecx
  8007c5:	7f 1b                	jg     8007e2 <vprintfmt+0x4d5>
	else if (lflag)
  8007c7:	85 c9                	test   %ecx,%ecx
  8007c9:	74 2c                	je     8007f7 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 10                	mov    (%eax),%edx
  8007d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d5:	8d 40 04             	lea    0x4(%eax),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007db:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007e0:	eb be                	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 10                	mov    (%eax),%edx
  8007e7:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ea:	8d 40 08             	lea    0x8(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007f5:	eb a9                	jmp    8007a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800807:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  80080c:	eb 92                	jmp    8007a0 <vprintfmt+0x493>
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	6a 25                	push   $0x25
  800814:	ff d6                	call   *%esi
			break;
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	eb 9f                	jmp    8007ba <vprintfmt+0x4ad>
			putch('%', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 25                	push   $0x25
  800821:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 f8                	mov    %edi,%eax
  800828:	eb 03                	jmp    80082d <vprintfmt+0x520>
  80082a:	83 e8 01             	sub    $0x1,%eax
  80082d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800831:	75 f7                	jne    80082a <vprintfmt+0x51d>
  800833:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800836:	eb 82                	jmp    8007ba <vprintfmt+0x4ad>

00800838 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 18             	sub    $0x18,%esp
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800847:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80084b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800855:	85 c0                	test   %eax,%eax
  800857:	74 26                	je     80087f <vsnprintf+0x47>
  800859:	85 d2                	test   %edx,%edx
  80085b:	7e 22                	jle    80087f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085d:	ff 75 14             	push   0x14(%ebp)
  800860:	ff 75 10             	push   0x10(%ebp)
  800863:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800866:	50                   	push   %eax
  800867:	68 d3 02 80 00       	push   $0x8002d3
  80086c:	e8 9c fa ff ff       	call   80030d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800874:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	c9                   	leave  
  80087e:	c3                   	ret    
		return -E_INVAL;
  80087f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800884:	eb f7                	jmp    80087d <vsnprintf+0x45>

00800886 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088f:	50                   	push   %eax
  800890:	ff 75 10             	push   0x10(%ebp)
  800893:	ff 75 0c             	push   0xc(%ebp)
  800896:	ff 75 08             	push   0x8(%ebp)
  800899:	e8 9a ff ff ff       	call   800838 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 03                	jmp    8008cb <strnlen+0x13>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cb:	39 d0                	cmp    %edx,%eax
  8008cd:	74 08                	je     8008d7 <strnlen+0x1f>
  8008cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d3:	75 f3                	jne    8008c8 <strnlen+0x10>
  8008d5:	89 c2                	mov    %eax,%edx
	return n;
}
  8008d7:	89 d0                	mov    %edx,%eax
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ea:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008ee:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008f1:	83 c0 01             	add    $0x1,%eax
  8008f4:	84 d2                	test   %dl,%dl
  8008f6:	75 f2                	jne    8008ea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f8:	89 c8                	mov    %ecx,%eax
  8008fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fd:	c9                   	leave  
  8008fe:	c3                   	ret    

008008ff <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	53                   	push   %ebx
  800903:	83 ec 10             	sub    $0x10,%esp
  800906:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800909:	53                   	push   %ebx
  80090a:	e8 91 ff ff ff       	call   8008a0 <strlen>
  80090f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800912:	ff 75 0c             	push   0xc(%ebp)
  800915:	01 d8                	add    %ebx,%eax
  800917:	50                   	push   %eax
  800918:	e8 be ff ff ff       	call   8008db <strcpy>
	return dst;
}
  80091d:	89 d8                	mov    %ebx,%eax
  80091f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	56                   	push   %esi
  800928:	53                   	push   %ebx
  800929:	8b 75 08             	mov    0x8(%ebp),%esi
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	89 f3                	mov    %esi,%ebx
  800931:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800934:	89 f0                	mov    %esi,%eax
  800936:	eb 0f                	jmp    800947 <strncpy+0x23>
		*dst++ = *src;
  800938:	83 c0 01             	add    $0x1,%eax
  80093b:	0f b6 0a             	movzbl (%edx),%ecx
  80093e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800941:	80 f9 01             	cmp    $0x1,%cl
  800944:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800947:	39 d8                	cmp    %ebx,%eax
  800949:	75 ed                	jne    800938 <strncpy+0x14>
	}
	return ret;
}
  80094b:	89 f0                	mov    %esi,%eax
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 75 08             	mov    0x8(%ebp),%esi
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	8b 55 10             	mov    0x10(%ebp),%edx
  80095f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800961:	85 d2                	test   %edx,%edx
  800963:	74 21                	je     800986 <strlcpy+0x35>
  800965:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800969:	89 f2                	mov    %esi,%edx
  80096b:	eb 09                	jmp    800976 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80096d:	83 c1 01             	add    $0x1,%ecx
  800970:	83 c2 01             	add    $0x1,%edx
  800973:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 09                	je     800983 <strlcpy+0x32>
  80097a:	0f b6 19             	movzbl (%ecx),%ebx
  80097d:	84 db                	test   %bl,%bl
  80097f:	75 ec                	jne    80096d <strlcpy+0x1c>
  800981:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800983:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	eb 06                	jmp    80099d <strcmp+0x11>
		p++, q++;
  800997:	83 c1 01             	add    $0x1,%ecx
  80099a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 04                	je     8009a8 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	74 ef                	je     800997 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 18                	je     8009e5 <strncmp+0x33>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    
		return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb f4                	jmp    8009e0 <strncmp+0x2e>

008009ec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f6:	eb 03                	jmp    8009fb <strchr+0xf>
  8009f8:	83 c0 01             	add    $0x1,%eax
  8009fb:	0f b6 10             	movzbl (%eax),%edx
  8009fe:	84 d2                	test   %dl,%dl
  800a00:	74 06                	je     800a08 <strchr+0x1c>
		if (*s == c)
  800a02:	38 ca                	cmp    %cl,%dl
  800a04:	75 f2                	jne    8009f8 <strchr+0xc>
  800a06:	eb 05                	jmp    800a0d <strchr+0x21>
			return (char *) s;
	return 0;
  800a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	74 09                	je     800a29 <strfind+0x1a>
  800a20:	84 d2                	test   %dl,%dl
  800a22:	74 05                	je     800a29 <strfind+0x1a>
	for (; *s; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f0                	jmp    800a19 <strfind+0xa>
			break;
	return (char *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a37:	85 c9                	test   %ecx,%ecx
  800a39:	74 2f                	je     800a6a <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3b:	89 f8                	mov    %edi,%eax
  800a3d:	09 c8                	or     %ecx,%eax
  800a3f:	a8 03                	test   $0x3,%al
  800a41:	75 21                	jne    800a64 <memset+0x39>
		c &= 0xFF;
  800a43:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	c1 e0 08             	shl    $0x8,%eax
  800a4c:	89 d3                	mov    %edx,%ebx
  800a4e:	c1 e3 18             	shl    $0x18,%ebx
  800a51:	89 d6                	mov    %edx,%esi
  800a53:	c1 e6 10             	shl    $0x10,%esi
  800a56:	09 f3                	or     %esi,%ebx
  800a58:	09 da                	or     %ebx,%edx
  800a5a:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5f:	fc                   	cld    
  800a60:	f3 ab                	rep stos %eax,%es:(%edi)
  800a62:	eb 06                	jmp    800a6a <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	fc                   	cld    
  800a68:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6a:	89 f8                	mov    %edi,%eax
  800a6c:	5b                   	pop    %ebx
  800a6d:	5e                   	pop    %esi
  800a6e:	5f                   	pop    %edi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7f:	39 c6                	cmp    %eax,%esi
  800a81:	73 32                	jae    800ab5 <memmove+0x44>
  800a83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	76 2b                	jbe    800ab5 <memmove+0x44>
		s += n;
		d += n;
  800a8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8d:	89 d6                	mov    %edx,%esi
  800a8f:	09 fe                	or     %edi,%esi
  800a91:	09 ce                	or     %ecx,%esi
  800a93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a99:	75 0e                	jne    800aa9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9b:	83 ef 04             	sub    $0x4,%edi
  800a9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa4:	fd                   	std    
  800aa5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa7:	eb 09                	jmp    800ab2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa9:	83 ef 01             	sub    $0x1,%edi
  800aac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aaf:	fd                   	std    
  800ab0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab2:	fc                   	cld    
  800ab3:	eb 1a                	jmp    800acf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 f2                	mov    %esi,%edx
  800ab7:	09 c2                	or     %eax,%edx
  800ab9:	09 ca                	or     %ecx,%edx
  800abb:	f6 c2 03             	test   $0x3,%dl
  800abe:	75 0a                	jne    800aca <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac8:	eb 05                	jmp    800acf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aca:	89 c7                	mov    %eax,%edi
  800acc:	fc                   	cld    
  800acd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad9:	ff 75 10             	push   0x10(%ebp)
  800adc:	ff 75 0c             	push   0xc(%ebp)
  800adf:	ff 75 08             	push   0x8(%ebp)
  800ae2:	e8 8a ff ff ff       	call   800a71 <memmove>
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	89 c6                	mov    %eax,%esi
  800af6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af9:	eb 06                	jmp    800b01 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b01:	39 f0                	cmp    %esi,%eax
  800b03:	74 14                	je     800b19 <memcmp+0x30>
		if (*s1 != *s2)
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	0f b6 1a             	movzbl (%edx),%ebx
  800b0b:	38 d9                	cmp    %bl,%cl
  800b0d:	74 ec                	je     800afb <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b0f:	0f b6 c1             	movzbl %cl,%eax
  800b12:	0f b6 db             	movzbl %bl,%ebx
  800b15:	29 d8                	sub    %ebx,%eax
  800b17:	eb 05                	jmp    800b1e <memcmp+0x35>
	}

	return 0;
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2b:	89 c2                	mov    %eax,%edx
  800b2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b30:	eb 03                	jmp    800b35 <memfind+0x13>
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	39 d0                	cmp    %edx,%eax
  800b37:	73 04                	jae    800b3d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b39:	38 08                	cmp    %cl,(%eax)
  800b3b:	75 f5                	jne    800b32 <memfind+0x10>
			break;
	return (void *) s;
}
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	57                   	push   %edi
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	8b 55 08             	mov    0x8(%ebp),%edx
  800b48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4b:	eb 03                	jmp    800b50 <strtol+0x11>
		s++;
  800b4d:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b50:	0f b6 02             	movzbl (%edx),%eax
  800b53:	3c 20                	cmp    $0x20,%al
  800b55:	74 f6                	je     800b4d <strtol+0xe>
  800b57:	3c 09                	cmp    $0x9,%al
  800b59:	74 f2                	je     800b4d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5b:	3c 2b                	cmp    $0x2b,%al
  800b5d:	74 2a                	je     800b89 <strtol+0x4a>
	int neg = 0;
  800b5f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b64:	3c 2d                	cmp    $0x2d,%al
  800b66:	74 2b                	je     800b93 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b68:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b6e:	75 0f                	jne    800b7f <strtol+0x40>
  800b70:	80 3a 30             	cmpb   $0x30,(%edx)
  800b73:	74 28                	je     800b9d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b75:	85 db                	test   %ebx,%ebx
  800b77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7c:	0f 44 d8             	cmove  %eax,%ebx
  800b7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b84:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b87:	eb 46                	jmp    800bcf <strtol+0x90>
		s++;
  800b89:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b91:	eb d5                	jmp    800b68 <strtol+0x29>
		s++, neg = 1;
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9b:	eb cb                	jmp    800b68 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba1:	74 0e                	je     800bb1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	75 d8                	jne    800b7f <strtol+0x40>
		s++, base = 8;
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800baf:	eb ce                	jmp    800b7f <strtol+0x40>
		s += 2, base = 16;
  800bb1:	83 c2 02             	add    $0x2,%edx
  800bb4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb9:	eb c4                	jmp    800b7f <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bbb:	0f be c0             	movsbl %al,%eax
  800bbe:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bc4:	7d 3a                	jge    800c00 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bc6:	83 c2 01             	add    $0x1,%edx
  800bc9:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bcd:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bcf:	0f b6 02             	movzbl (%edx),%eax
  800bd2:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bd5:	89 f3                	mov    %esi,%ebx
  800bd7:	80 fb 09             	cmp    $0x9,%bl
  800bda:	76 df                	jbe    800bbb <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bdc:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 19             	cmp    $0x19,%bl
  800be4:	77 08                	ja     800bee <strtol+0xaf>
			dig = *s - 'a' + 10;
  800be6:	0f be c0             	movsbl %al,%eax
  800be9:	83 e8 57             	sub    $0x57,%eax
  800bec:	eb d3                	jmp    800bc1 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bee:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bf1:	89 f3                	mov    %esi,%ebx
  800bf3:	80 fb 19             	cmp    $0x19,%bl
  800bf6:	77 08                	ja     800c00 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf8:	0f be c0             	movsbl %al,%eax
  800bfb:	83 e8 37             	sub    $0x37,%eax
  800bfe:	eb c1                	jmp    800bc1 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c04:	74 05                	je     800c0b <strtol+0xcc>
		*endptr = (char *) s;
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c0b:	89 c8                	mov    %ecx,%eax
  800c0d:	f7 d8                	neg    %eax
  800c0f:	85 ff                	test   %edi,%edi
  800c11:	0f 45 c8             	cmovne %eax,%ecx
}
  800c14:	89 c8                	mov    %ecx,%eax
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2c:	89 c3                	mov    %eax,%ebx
  800c2e:	89 c7                	mov    %eax,%edi
  800c30:	89 c6                	mov    %eax,%esi
  800c32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5f                   	pop    %edi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 01 00 00 00       	mov    $0x1,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6e:	89 cb                	mov    %ecx,%ebx
  800c70:	89 cf                	mov    %ecx,%edi
  800c72:	89 ce                	mov    %ecx,%esi
  800c74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	7f 08                	jg     800c82 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	50                   	push   %eax
  800c86:	6a 03                	push   $0x3
  800c88:	68 bf 17 80 00       	push   $0x8017bf
  800c8d:	6a 23                	push   $0x23
  800c8f:	68 dc 17 80 00       	push   $0x8017dc
  800c94:	e8 a2 f4 ff ff       	call   80013b <_panic>

00800c99 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca9:	89 d1                	mov    %edx,%ecx
  800cab:	89 d3                	mov    %edx,%ebx
  800cad:	89 d7                	mov    %edx,%edi
  800caf:	89 d6                	mov    %edx,%esi
  800cb1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <sys_yield>:

void
sys_yield(void)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc8:	89 d1                	mov    %edx,%ecx
  800cca:	89 d3                	mov    %edx,%ebx
  800ccc:	89 d7                	mov    %edx,%edi
  800cce:	89 d6                	mov    %edx,%esi
  800cd0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	be 00 00 00 00       	mov    $0x0,%esi
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	89 f7                	mov    %esi,%edi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 04                	push   $0x4
  800d09:	68 bf 17 80 00       	push   $0x8017bf
  800d0e:	6a 23                	push   $0x23
  800d10:	68 dc 17 80 00       	push   $0x8017dc
  800d15:	e8 21 f4 ff ff       	call   80013b <_panic>

00800d1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d34:	8b 75 18             	mov    0x18(%ebp),%esi
  800d37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7f 08                	jg     800d45 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	50                   	push   %eax
  800d49:	6a 05                	push   $0x5
  800d4b:	68 bf 17 80 00       	push   $0x8017bf
  800d50:	6a 23                	push   $0x23
  800d52:	68 dc 17 80 00       	push   $0x8017dc
  800d57:	e8 df f3 ff ff       	call   80013b <_panic>

00800d5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	b8 06 00 00 00       	mov    $0x6,%eax
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	89 de                	mov    %ebx,%esi
  800d79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7f 08                	jg     800d87 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	83 ec 0c             	sub    $0xc,%esp
  800d8a:	50                   	push   %eax
  800d8b:	6a 06                	push   $0x6
  800d8d:	68 bf 17 80 00       	push   $0x8017bf
  800d92:	6a 23                	push   $0x23
  800d94:	68 dc 17 80 00       	push   $0x8017dc
  800d99:	e8 9d f3 ff ff       	call   80013b <_panic>

00800d9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db2:	b8 08 00 00 00       	mov    $0x8,%eax
  800db7:	89 df                	mov    %ebx,%edi
  800db9:	89 de                	mov    %ebx,%esi
  800dbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7f 08                	jg     800dc9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	50                   	push   %eax
  800dcd:	6a 08                	push   $0x8
  800dcf:	68 bf 17 80 00       	push   $0x8017bf
  800dd4:	6a 23                	push   $0x23
  800dd6:	68 dc 17 80 00       	push   $0x8017dc
  800ddb:	e8 5b f3 ff ff       	call   80013b <_panic>

00800de0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	b8 09 00 00 00       	mov    $0x9,%eax
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7f 08                	jg     800e0b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	50                   	push   %eax
  800e0f:	6a 09                	push   $0x9
  800e11:	68 bf 17 80 00       	push   $0x8017bf
  800e16:	6a 23                	push   $0x23
  800e18:	68 dc 17 80 00       	push   $0x8017dc
  800e1d:	e8 19 f3 ff ff       	call   80013b <_panic>

00800e22 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3b:	89 df                	mov    %ebx,%edi
  800e3d:	89 de                	mov    %ebx,%esi
  800e3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 0a                	push   $0xa
  800e53:	68 bf 17 80 00       	push   $0x8017bf
  800e58:	6a 23                	push   $0x23
  800e5a:	68 dc 17 80 00       	push   $0x8017dc
  800e5f:	e8 d7 f2 ff ff       	call   80013b <_panic>

00800e64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e75:	be 00 00 00 00       	mov    $0x0,%esi
  800e7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e80:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9d:	89 cb                	mov    %ecx,%ebx
  800e9f:	89 cf                	mov    %ecx,%edi
  800ea1:	89 ce                	mov    %ecx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 0d                	push   $0xd
  800eb7:	68 bf 17 80 00       	push   $0x8017bf
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 dc 17 80 00       	push   $0x8017dc
  800ec3:	e8 73 f2 ff ff       	call   80013b <_panic>

00800ec8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ed2:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800ed4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ed8:	0f 84 99 00 00 00    	je     800f77 <pgfault+0xaf>
  800ede:	89 d8                	mov    %ebx,%eax
  800ee0:	c1 e8 16             	shr    $0x16,%eax
  800ee3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800eea:	a8 01                	test   $0x1,%al
  800eec:	0f 84 85 00 00 00    	je     800f77 <pgfault+0xaf>
  800ef2:	89 d8                	mov    %ebx,%eax
  800ef4:	c1 e8 0c             	shr    $0xc,%eax
  800ef7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800efe:	f6 c6 08             	test   $0x8,%dh
  800f01:	74 74                	je     800f77 <pgfault+0xaf>
  800f03:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f0a:	a8 01                	test   $0x1,%al
  800f0c:	74 69                	je     800f77 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	6a 07                	push   $0x7
  800f13:	68 00 f0 7f 00       	push   $0x7ff000
  800f18:	6a 00                	push   $0x0
  800f1a:	e8 b8 fd ff ff       	call   800cd7 <sys_page_alloc>
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 65                	js     800f8b <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f2c:	83 ec 04             	sub    $0x4,%esp
  800f2f:	68 00 10 00 00       	push   $0x1000
  800f34:	53                   	push   %ebx
  800f35:	68 00 f0 7f 00       	push   $0x7ff000
  800f3a:	e8 94 fb ff ff       	call   800ad3 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800f3f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f46:	53                   	push   %ebx
  800f47:	6a 00                	push   $0x0
  800f49:	68 00 f0 7f 00       	push   $0x7ff000
  800f4e:	6a 00                	push   $0x0
  800f50:	e8 c5 fd ff ff       	call   800d1a <sys_page_map>
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 43                	js     800f9f <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	68 00 f0 7f 00       	push   $0x7ff000
  800f64:	6a 00                	push   $0x0
  800f66:	e8 f1 fd ff ff       	call   800d5c <sys_page_unmap>
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	78 41                	js     800fb3 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    
		panic("invalid permision\n");
  800f77:	83 ec 04             	sub    $0x4,%esp
  800f7a:	68 ea 17 80 00       	push   $0x8017ea
  800f7f:	6a 1f                	push   $0x1f
  800f81:	68 fd 17 80 00       	push   $0x8017fd
  800f86:	e8 b0 f1 ff ff       	call   80013b <_panic>
		panic("Unable to alloc page\n");
  800f8b:	83 ec 04             	sub    $0x4,%esp
  800f8e:	68 08 18 80 00       	push   $0x801808
  800f93:	6a 28                	push   $0x28
  800f95:	68 fd 17 80 00       	push   $0x8017fd
  800f9a:	e8 9c f1 ff ff       	call   80013b <_panic>
		panic("Unable to map\n");
  800f9f:	83 ec 04             	sub    $0x4,%esp
  800fa2:	68 1e 18 80 00       	push   $0x80181e
  800fa7:	6a 2b                	push   $0x2b
  800fa9:	68 fd 17 80 00       	push   $0x8017fd
  800fae:	e8 88 f1 ff ff       	call   80013b <_panic>
		panic("Unable to unmap\n");
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	68 2d 18 80 00       	push   $0x80182d
  800fbb:	6a 2d                	push   $0x2d
  800fbd:	68 fd 17 80 00       	push   $0x8017fd
  800fc2:	e8 74 f1 ff ff       	call   80013b <_panic>

00800fc7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800fd0:	68 c8 0e 80 00       	push   $0x800ec8
  800fd5:	e8 85 01 00 00       	call   80115f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fda:	b8 07 00 00 00       	mov    $0x7,%eax
  800fdf:	cd 30                	int    $0x30
  800fe1:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 23                	js     80100d <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fea:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  800fef:	75 6d                	jne    80105e <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ff1:	e8 a3 fc ff ff       	call   800c99 <sys_getenvid>
  800ff6:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ffb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ffe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801003:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801008:	e9 02 01 00 00       	jmp    80110f <fork+0x148>
		panic("sys_exofork: %e", envid);
  80100d:	50                   	push   %eax
  80100e:	68 3e 18 80 00       	push   $0x80183e
  801013:	6a 6d                	push   $0x6d
  801015:	68 fd 17 80 00       	push   $0x8017fd
  80101a:	e8 1c f1 ff ff       	call   80013b <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80101f:	c1 e0 0c             	shl    $0xc,%eax
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80102b:	52                   	push   %edx
  80102c:	50                   	push   %eax
  80102d:	56                   	push   %esi
  80102e:	50                   	push   %eax
  80102f:	6a 00                	push   $0x0
  801031:	e8 e4 fc ff ff       	call   800d1a <sys_page_map>
  801036:	83 c4 20             	add    $0x20,%esp
  801039:	eb 15                	jmp    801050 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  80103b:	c1 e0 0c             	shl    $0xc,%eax
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	6a 05                	push   $0x5
  801043:	50                   	push   %eax
  801044:	56                   	push   %esi
  801045:	50                   	push   %eax
  801046:	6a 00                	push   $0x0
  801048:	e8 cd fc ff ff       	call   800d1a <sys_page_map>
  80104d:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801050:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801056:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80105c:	74 7a                	je     8010d8 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80105e:	89 d8                	mov    %ebx,%eax
  801060:	c1 e8 16             	shr    $0x16,%eax
  801063:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80106a:	a8 01                	test   $0x1,%al
  80106c:	74 e2                	je     801050 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80106e:	89 d8                	mov    %ebx,%eax
  801070:	c1 e8 0c             	shr    $0xc,%eax
  801073:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  80107a:	f6 c2 01             	test   $0x1,%dl
  80107d:	74 d1                	je     801050 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80107f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801086:	f6 c2 04             	test   $0x4,%dl
  801089:	74 c5                	je     801050 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80108b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801092:	f6 c6 04             	test   $0x4,%dh
  801095:	75 88                	jne    80101f <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801097:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80109d:	74 9c                	je     80103b <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80109f:	c1 e0 0c             	shl    $0xc,%eax
  8010a2:	89 c7                	mov    %eax,%edi
  8010a4:	83 ec 0c             	sub    $0xc,%esp
  8010a7:	68 05 08 00 00       	push   $0x805
  8010ac:	50                   	push   %eax
  8010ad:	56                   	push   %esi
  8010ae:	50                   	push   %eax
  8010af:	6a 00                	push   $0x0
  8010b1:	e8 64 fc ff ff       	call   800d1a <sys_page_map>
  8010b6:	83 c4 20             	add    $0x20,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 93                	js     801050 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8010bd:	83 ec 0c             	sub    $0xc,%esp
  8010c0:	68 05 08 00 00       	push   $0x805
  8010c5:	57                   	push   %edi
  8010c6:	6a 00                	push   $0x0
  8010c8:	57                   	push   %edi
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 4a fc ff ff       	call   800d1a <sys_page_map>
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	e9 78 ff ff ff       	jmp    801050 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	6a 07                	push   $0x7
  8010dd:	68 00 f0 bf ee       	push   $0xeebff000
  8010e2:	56                   	push   %esi
  8010e3:	e8 ef fb ff ff       	call   800cd7 <sys_page_alloc>
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	78 2a                	js     801119 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	68 ce 11 80 00       	push   $0x8011ce
  8010f7:	56                   	push   %esi
  8010f8:	e8 25 fd ff ff       	call   800e22 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010fd:	83 c4 08             	add    $0x8,%esp
  801100:	6a 02                	push   $0x2
  801102:	56                   	push   %esi
  801103:	e8 96 fc ff ff       	call   800d9e <sys_env_set_status>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 21                	js     801130 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80110f:	89 f0                	mov    %esi,%eax
  801111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    
		panic("failed to alloc page");
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	68 4e 18 80 00       	push   $0x80184e
  801121:	68 82 00 00 00       	push   $0x82
  801126:	68 fd 17 80 00       	push   $0x8017fd
  80112b:	e8 0b f0 ff ff       	call   80013b <_panic>
		panic("sys_env_set_status: %e", r);
  801130:	50                   	push   %eax
  801131:	68 63 18 80 00       	push   $0x801863
  801136:	68 89 00 00 00       	push   $0x89
  80113b:	68 fd 17 80 00       	push   $0x8017fd
  801140:	e8 f6 ef ff ff       	call   80013b <_panic>

00801145 <sfork>:

// Challenge!
int
sfork(void)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80114b:	68 7a 18 80 00       	push   $0x80187a
  801150:	68 92 00 00 00       	push   $0x92
  801155:	68 fd 17 80 00       	push   $0x8017fd
  80115a:	e8 dc ef ff ff       	call   80013b <_panic>

0080115f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801165:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80116c:	74 20                	je     80118e <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	a3 0c 20 80 00       	mov    %eax,0x80200c
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	68 ce 11 80 00       	push   $0x8011ce
  80117e:	6a 00                	push   $0x0
  801180:	e8 9d fc ff ff       	call   800e22 <sys_env_set_pgfault_upcall>
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 2e                	js     8011ba <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	6a 07                	push   $0x7
  801193:	68 00 f0 bf ee       	push   $0xeebff000
  801198:	6a 00                	push   $0x0
  80119a:	e8 38 fb ff ff       	call   800cd7 <sys_page_alloc>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	79 c8                	jns    80116e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	68 90 18 80 00       	push   $0x801890
  8011ae:	6a 21                	push   $0x21
  8011b0:	68 f3 18 80 00       	push   $0x8018f3
  8011b5:	e8 81 ef ff ff       	call   80013b <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	68 bc 18 80 00       	push   $0x8018bc
  8011c2:	6a 27                	push   $0x27
  8011c4:	68 f3 18 80 00       	push   $0x8018f3
  8011c9:	e8 6d ef ff ff       	call   80013b <_panic>

008011ce <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011ce:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011cf:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8011d4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011d6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8011d9:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8011dd:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8011e2:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8011e6:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8011e8:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8011eb:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8011ec:	83 c4 04             	add    $0x4,%esp
	popfl
  8011ef:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011f0:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011f1:	c3                   	ret    
  8011f2:	66 90                	xchg   %ax,%ax
  8011f4:	66 90                	xchg   %ax,%ax
  8011f6:	66 90                	xchg   %ax,%ax
  8011f8:	66 90                	xchg   %ax,%ax
  8011fa:	66 90                	xchg   %ax,%ax
  8011fc:	66 90                	xchg   %ax,%ax
  8011fe:	66 90                	xchg   %ax,%ax

00801200 <__udivdi3>:
  801200:	f3 0f 1e fb          	endbr32 
  801204:	55                   	push   %ebp
  801205:	57                   	push   %edi
  801206:	56                   	push   %esi
  801207:	53                   	push   %ebx
  801208:	83 ec 1c             	sub    $0x1c,%esp
  80120b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80120f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801213:	8b 74 24 34          	mov    0x34(%esp),%esi
  801217:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80121b:	85 c0                	test   %eax,%eax
  80121d:	75 19                	jne    801238 <__udivdi3+0x38>
  80121f:	39 f3                	cmp    %esi,%ebx
  801221:	76 4d                	jbe    801270 <__udivdi3+0x70>
  801223:	31 ff                	xor    %edi,%edi
  801225:	89 e8                	mov    %ebp,%eax
  801227:	89 f2                	mov    %esi,%edx
  801229:	f7 f3                	div    %ebx
  80122b:	89 fa                	mov    %edi,%edx
  80122d:	83 c4 1c             	add    $0x1c,%esp
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    
  801235:	8d 76 00             	lea    0x0(%esi),%esi
  801238:	39 f0                	cmp    %esi,%eax
  80123a:	76 14                	jbe    801250 <__udivdi3+0x50>
  80123c:	31 ff                	xor    %edi,%edi
  80123e:	31 c0                	xor    %eax,%eax
  801240:	89 fa                	mov    %edi,%edx
  801242:	83 c4 1c             	add    $0x1c,%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    
  80124a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801250:	0f bd f8             	bsr    %eax,%edi
  801253:	83 f7 1f             	xor    $0x1f,%edi
  801256:	75 48                	jne    8012a0 <__udivdi3+0xa0>
  801258:	39 f0                	cmp    %esi,%eax
  80125a:	72 06                	jb     801262 <__udivdi3+0x62>
  80125c:	31 c0                	xor    %eax,%eax
  80125e:	39 eb                	cmp    %ebp,%ebx
  801260:	77 de                	ja     801240 <__udivdi3+0x40>
  801262:	b8 01 00 00 00       	mov    $0x1,%eax
  801267:	eb d7                	jmp    801240 <__udivdi3+0x40>
  801269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801270:	89 d9                	mov    %ebx,%ecx
  801272:	85 db                	test   %ebx,%ebx
  801274:	75 0b                	jne    801281 <__udivdi3+0x81>
  801276:	b8 01 00 00 00       	mov    $0x1,%eax
  80127b:	31 d2                	xor    %edx,%edx
  80127d:	f7 f3                	div    %ebx
  80127f:	89 c1                	mov    %eax,%ecx
  801281:	31 d2                	xor    %edx,%edx
  801283:	89 f0                	mov    %esi,%eax
  801285:	f7 f1                	div    %ecx
  801287:	89 c6                	mov    %eax,%esi
  801289:	89 e8                	mov    %ebp,%eax
  80128b:	89 f7                	mov    %esi,%edi
  80128d:	f7 f1                	div    %ecx
  80128f:	89 fa                	mov    %edi,%edx
  801291:	83 c4 1c             	add    $0x1c,%esp
  801294:	5b                   	pop    %ebx
  801295:	5e                   	pop    %esi
  801296:	5f                   	pop    %edi
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    
  801299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012a0:	89 f9                	mov    %edi,%ecx
  8012a2:	ba 20 00 00 00       	mov    $0x20,%edx
  8012a7:	29 fa                	sub    %edi,%edx
  8012a9:	d3 e0                	shl    %cl,%eax
  8012ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012af:	89 d1                	mov    %edx,%ecx
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	d3 e8                	shr    %cl,%eax
  8012b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8012b9:	09 c1                	or     %eax,%ecx
  8012bb:	89 f0                	mov    %esi,%eax
  8012bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012c1:	89 f9                	mov    %edi,%ecx
  8012c3:	d3 e3                	shl    %cl,%ebx
  8012c5:	89 d1                	mov    %edx,%ecx
  8012c7:	d3 e8                	shr    %cl,%eax
  8012c9:	89 f9                	mov    %edi,%ecx
  8012cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012cf:	89 eb                	mov    %ebp,%ebx
  8012d1:	d3 e6                	shl    %cl,%esi
  8012d3:	89 d1                	mov    %edx,%ecx
  8012d5:	d3 eb                	shr    %cl,%ebx
  8012d7:	09 f3                	or     %esi,%ebx
  8012d9:	89 c6                	mov    %eax,%esi
  8012db:	89 f2                	mov    %esi,%edx
  8012dd:	89 d8                	mov    %ebx,%eax
  8012df:	f7 74 24 08          	divl   0x8(%esp)
  8012e3:	89 d6                	mov    %edx,%esi
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	f7 64 24 0c          	mull   0xc(%esp)
  8012eb:	39 d6                	cmp    %edx,%esi
  8012ed:	72 19                	jb     801308 <__udivdi3+0x108>
  8012ef:	89 f9                	mov    %edi,%ecx
  8012f1:	d3 e5                	shl    %cl,%ebp
  8012f3:	39 c5                	cmp    %eax,%ebp
  8012f5:	73 04                	jae    8012fb <__udivdi3+0xfb>
  8012f7:	39 d6                	cmp    %edx,%esi
  8012f9:	74 0d                	je     801308 <__udivdi3+0x108>
  8012fb:	89 d8                	mov    %ebx,%eax
  8012fd:	31 ff                	xor    %edi,%edi
  8012ff:	e9 3c ff ff ff       	jmp    801240 <__udivdi3+0x40>
  801304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801308:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80130b:	31 ff                	xor    %edi,%edi
  80130d:	e9 2e ff ff ff       	jmp    801240 <__udivdi3+0x40>
  801312:	66 90                	xchg   %ax,%ax
  801314:	66 90                	xchg   %ax,%ax
  801316:	66 90                	xchg   %ax,%ax
  801318:	66 90                	xchg   %ax,%ax
  80131a:	66 90                	xchg   %ax,%ax
  80131c:	66 90                	xchg   %ax,%ax
  80131e:	66 90                	xchg   %ax,%ax

00801320 <__umoddi3>:
  801320:	f3 0f 1e fb          	endbr32 
  801324:	55                   	push   %ebp
  801325:	57                   	push   %edi
  801326:	56                   	push   %esi
  801327:	53                   	push   %ebx
  801328:	83 ec 1c             	sub    $0x1c,%esp
  80132b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80132f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801333:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801337:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80133b:	89 f0                	mov    %esi,%eax
  80133d:	89 da                	mov    %ebx,%edx
  80133f:	85 ff                	test   %edi,%edi
  801341:	75 15                	jne    801358 <__umoddi3+0x38>
  801343:	39 dd                	cmp    %ebx,%ebp
  801345:	76 39                	jbe    801380 <__umoddi3+0x60>
  801347:	f7 f5                	div    %ebp
  801349:	89 d0                	mov    %edx,%eax
  80134b:	31 d2                	xor    %edx,%edx
  80134d:	83 c4 1c             	add    $0x1c,%esp
  801350:	5b                   	pop    %ebx
  801351:	5e                   	pop    %esi
  801352:	5f                   	pop    %edi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    
  801355:	8d 76 00             	lea    0x0(%esi),%esi
  801358:	39 df                	cmp    %ebx,%edi
  80135a:	77 f1                	ja     80134d <__umoddi3+0x2d>
  80135c:	0f bd cf             	bsr    %edi,%ecx
  80135f:	83 f1 1f             	xor    $0x1f,%ecx
  801362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801366:	75 40                	jne    8013a8 <__umoddi3+0x88>
  801368:	39 df                	cmp    %ebx,%edi
  80136a:	72 04                	jb     801370 <__umoddi3+0x50>
  80136c:	39 f5                	cmp    %esi,%ebp
  80136e:	77 dd                	ja     80134d <__umoddi3+0x2d>
  801370:	89 da                	mov    %ebx,%edx
  801372:	89 f0                	mov    %esi,%eax
  801374:	29 e8                	sub    %ebp,%eax
  801376:	19 fa                	sbb    %edi,%edx
  801378:	eb d3                	jmp    80134d <__umoddi3+0x2d>
  80137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801380:	89 e9                	mov    %ebp,%ecx
  801382:	85 ed                	test   %ebp,%ebp
  801384:	75 0b                	jne    801391 <__umoddi3+0x71>
  801386:	b8 01 00 00 00       	mov    $0x1,%eax
  80138b:	31 d2                	xor    %edx,%edx
  80138d:	f7 f5                	div    %ebp
  80138f:	89 c1                	mov    %eax,%ecx
  801391:	89 d8                	mov    %ebx,%eax
  801393:	31 d2                	xor    %edx,%edx
  801395:	f7 f1                	div    %ecx
  801397:	89 f0                	mov    %esi,%eax
  801399:	f7 f1                	div    %ecx
  80139b:	89 d0                	mov    %edx,%eax
  80139d:	31 d2                	xor    %edx,%edx
  80139f:	eb ac                	jmp    80134d <__umoddi3+0x2d>
  8013a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013ac:	ba 20 00 00 00       	mov    $0x20,%edx
  8013b1:	29 c2                	sub    %eax,%edx
  8013b3:	89 c1                	mov    %eax,%ecx
  8013b5:	89 e8                	mov    %ebp,%eax
  8013b7:	d3 e7                	shl    %cl,%edi
  8013b9:	89 d1                	mov    %edx,%ecx
  8013bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013bf:	d3 e8                	shr    %cl,%eax
  8013c1:	89 c1                	mov    %eax,%ecx
  8013c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013c7:	09 f9                	or     %edi,%ecx
  8013c9:	89 df                	mov    %ebx,%edi
  8013cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013cf:	89 c1                	mov    %eax,%ecx
  8013d1:	d3 e5                	shl    %cl,%ebp
  8013d3:	89 d1                	mov    %edx,%ecx
  8013d5:	d3 ef                	shr    %cl,%edi
  8013d7:	89 c1                	mov    %eax,%ecx
  8013d9:	89 f0                	mov    %esi,%eax
  8013db:	d3 e3                	shl    %cl,%ebx
  8013dd:	89 d1                	mov    %edx,%ecx
  8013df:	89 fa                	mov    %edi,%edx
  8013e1:	d3 e8                	shr    %cl,%eax
  8013e3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013e8:	09 d8                	or     %ebx,%eax
  8013ea:	f7 74 24 08          	divl   0x8(%esp)
  8013ee:	89 d3                	mov    %edx,%ebx
  8013f0:	d3 e6                	shl    %cl,%esi
  8013f2:	f7 e5                	mul    %ebp
  8013f4:	89 c7                	mov    %eax,%edi
  8013f6:	89 d1                	mov    %edx,%ecx
  8013f8:	39 d3                	cmp    %edx,%ebx
  8013fa:	72 06                	jb     801402 <__umoddi3+0xe2>
  8013fc:	75 0e                	jne    80140c <__umoddi3+0xec>
  8013fe:	39 c6                	cmp    %eax,%esi
  801400:	73 0a                	jae    80140c <__umoddi3+0xec>
  801402:	29 e8                	sub    %ebp,%eax
  801404:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801408:	89 d1                	mov    %edx,%ecx
  80140a:	89 c7                	mov    %eax,%edi
  80140c:	89 f5                	mov    %esi,%ebp
  80140e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801412:	29 fd                	sub    %edi,%ebp
  801414:	19 cb                	sbb    %ecx,%ebx
  801416:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	d3 e0                	shl    %cl,%eax
  80141f:	89 f1                	mov    %esi,%ecx
  801421:	d3 ed                	shr    %cl,%ebp
  801423:	d3 eb                	shr    %cl,%ebx
  801425:	09 e8                	or     %ebp,%eax
  801427:	89 da                	mov    %ebx,%edx
  801429:	83 c4 1c             	add    $0x1c,%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5e                   	pop    %esi
  80142e:	5f                   	pop    %edi
  80142f:	5d                   	pop    %ebp
  801430:	c3                   	ret    
