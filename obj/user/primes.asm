
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 24 11 00 00       	call   801170 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 20 15 80 00       	push   $0x801520
  800060:	e8 c2 01 00 00       	call   800227 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 6e 0f 00 00       	call   800fd8 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 2e                	js     8000a1 <primeproc+0x6e>
		panic("fork: %e", id);
	if (id == 0)
  800073:	74 ca                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800075:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	6a 00                	push   $0x0
  80007d:	6a 00                	push   $0x0
  80007f:	56                   	push   %esi
  800080:	e8 eb 10 00 00       	call   801170 <ipc_recv>
  800085:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800087:	99                   	cltd   
  800088:	f7 fb                	idiv   %ebx
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	85 d2                	test   %edx,%edx
  80008f:	74 e7                	je     800078 <primeproc+0x45>
			ipc_send(id, i, 0, 0);
  800091:	6a 00                	push   $0x0
  800093:	6a 00                	push   $0x0
  800095:	51                   	push   %ecx
  800096:	57                   	push   %edi
  800097:	e8 23 11 00 00       	call   8011bf <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb d7                	jmp    800078 <primeproc+0x45>
		panic("fork: %e", id);
  8000a1:	50                   	push   %eax
  8000a2:	68 e5 18 80 00       	push   $0x8018e5
  8000a7:	6a 1a                	push   $0x1a
  8000a9:	68 2c 15 80 00       	push   $0x80152c
  8000ae:	e8 99 00 00 00       	call   80014c <_panic>

008000b3 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b3:	55                   	push   %ebp
  8000b4:	89 e5                	mov    %esp,%ebp
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000b8:	e8 1b 0f 00 00       	call   800fd8 <fork>
  8000bd:	89 c6                	mov    %eax,%esi
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	78 1a                	js     8000dd <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c3:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000c8:	74 25                	je     8000ef <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000ca:	6a 00                	push   $0x0
  8000cc:	6a 00                	push   $0x0
  8000ce:	53                   	push   %ebx
  8000cf:	56                   	push   %esi
  8000d0:	e8 ea 10 00 00       	call   8011bf <ipc_send>
	for (i = 2; ; i++)
  8000d5:	83 c3 01             	add    $0x1,%ebx
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	eb ed                	jmp    8000ca <umain+0x17>
		panic("fork: %e", id);
  8000dd:	50                   	push   %eax
  8000de:	68 e5 18 80 00       	push   $0x8018e5
  8000e3:	6a 2d                	push   $0x2d
  8000e5:	68 2c 15 80 00       	push   $0x80152c
  8000ea:	e8 5d 00 00 00       	call   80014c <_panic>
		primeproc();
  8000ef:	e8 3f ff ff ff       	call   800033 <primeproc>

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ff:	e8 a6 0b 00 00       	call   800caa <sys_getenvid>
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800111:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800116:	85 db                	test   %ebx,%ebx
  800118:	7e 07                	jle    800121 <libmain+0x2d>
		binaryname = argv[0];
  80011a:	8b 06                	mov    (%esi),%eax
  80011c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
  800126:	e8 88 ff ff ff       	call   8000b3 <umain>

	// exit gracefully
	exit();
  80012b:	e8 0a 00 00 00       	call   80013a <exit>
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5d                   	pop    %ebp
  800139:	c3                   	ret    

0080013a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800140:	6a 00                	push   $0x0
  800142:	e8 22 0b 00 00       	call   800c69 <sys_env_destroy>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800151:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800154:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80015a:	e8 4b 0b 00 00       	call   800caa <sys_getenvid>
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	ff 75 0c             	push   0xc(%ebp)
  800165:	ff 75 08             	push   0x8(%ebp)
  800168:	56                   	push   %esi
  800169:	50                   	push   %eax
  80016a:	68 44 15 80 00       	push   $0x801544
  80016f:	e8 b3 00 00 00       	call   800227 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800174:	83 c4 18             	add    $0x18,%esp
  800177:	53                   	push   %ebx
  800178:	ff 75 10             	push   0x10(%ebp)
  80017b:	e8 56 00 00 00       	call   8001d6 <vcprintf>
	cprintf("\n");
  800180:	c7 04 24 3e 19 80 00 	movl   $0x80193e,(%esp)
  800187:	e8 9b 00 00 00       	call   800227 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018f:	cc                   	int3   
  800190:	eb fd                	jmp    80018f <_panic+0x43>

00800192 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	53                   	push   %ebx
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019c:	8b 13                	mov    (%ebx),%edx
  80019e:	8d 42 01             	lea    0x1(%edx),%eax
  8001a1:	89 03                	mov    %eax,(%ebx)
  8001a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001af:	74 09                	je     8001ba <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ba:	83 ec 08             	sub    $0x8,%esp
  8001bd:	68 ff 00 00 00       	push   $0xff
  8001c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c5:	50                   	push   %eax
  8001c6:	e8 61 0a 00 00       	call   800c2c <sys_cputs>
		b->idx = 0;
  8001cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	eb db                	jmp    8001b1 <putch+0x1f>

008001d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e6:	00 00 00 
	b.cnt = 0;
  8001e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f3:	ff 75 0c             	push   0xc(%ebp)
  8001f6:	ff 75 08             	push   0x8(%ebp)
  8001f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	68 92 01 80 00       	push   $0x800192
  800205:	e8 14 01 00 00       	call   80031e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020a:	83 c4 08             	add    $0x8,%esp
  80020d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800213:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800219:	50                   	push   %eax
  80021a:	e8 0d 0a 00 00       	call   800c2c <sys_cputs>

	return b.cnt;
}
  80021f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800230:	50                   	push   %eax
  800231:	ff 75 08             	push   0x8(%ebp)
  800234:	e8 9d ff ff ff       	call   8001d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	57                   	push   %edi
  80023f:	56                   	push   %esi
  800240:	53                   	push   %ebx
  800241:	83 ec 1c             	sub    $0x1c,%esp
  800244:	89 c7                	mov    %eax,%edi
  800246:	89 d6                	mov    %edx,%esi
  800248:	8b 45 08             	mov    0x8(%ebp),%eax
  80024b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024e:	89 d1                	mov    %edx,%ecx
  800250:	89 c2                	mov    %eax,%edx
  800252:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800255:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800258:	8b 45 10             	mov    0x10(%ebp),%eax
  80025b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800261:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800268:	39 c2                	cmp    %eax,%edx
  80026a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026d:	72 3e                	jb     8002ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 18             	push   0x18(%ebp)
  800275:	83 eb 01             	sub    $0x1,%ebx
  800278:	53                   	push   %ebx
  800279:	50                   	push   %eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 75 e4             	push   -0x1c(%ebp)
  800280:	ff 75 e0             	push   -0x20(%ebp)
  800283:	ff 75 dc             	push   -0x24(%ebp)
  800286:	ff 75 d8             	push   -0x28(%ebp)
  800289:	e8 52 10 00 00       	call   8012e0 <__udivdi3>
  80028e:	83 c4 18             	add    $0x18,%esp
  800291:	52                   	push   %edx
  800292:	50                   	push   %eax
  800293:	89 f2                	mov    %esi,%edx
  800295:	89 f8                	mov    %edi,%eax
  800297:	e8 9f ff ff ff       	call   80023b <printnum>
  80029c:	83 c4 20             	add    $0x20,%esp
  80029f:	eb 13                	jmp    8002b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	56                   	push   %esi
  8002a5:	ff 75 18             	push   0x18(%ebp)
  8002a8:	ff d7                	call   *%edi
  8002aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ad:	83 eb 01             	sub    $0x1,%ebx
  8002b0:	85 db                	test   %ebx,%ebx
  8002b2:	7f ed                	jg     8002a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	56                   	push   %esi
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	ff 75 e4             	push   -0x1c(%ebp)
  8002be:	ff 75 e0             	push   -0x20(%ebp)
  8002c1:	ff 75 dc             	push   -0x24(%ebp)
  8002c4:	ff 75 d8             	push   -0x28(%ebp)
  8002c7:	e8 34 11 00 00       	call   801400 <__umoddi3>
  8002cc:	83 c4 14             	add    $0x14,%esp
  8002cf:	0f be 80 67 15 80 00 	movsbl 0x801567(%eax),%eax
  8002d6:	50                   	push   %eax
  8002d7:	ff d7                	call   *%edi
}
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002df:	5b                   	pop    %ebx
  8002e0:	5e                   	pop    %esi
  8002e1:	5f                   	pop    %edi
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f3:	73 0a                	jae    8002ff <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f8:	89 08                	mov    %ecx,(%eax)
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	88 02                	mov    %al,(%edx)
}
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <printfmt>:
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800307:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030a:	50                   	push   %eax
  80030b:	ff 75 10             	push   0x10(%ebp)
  80030e:	ff 75 0c             	push   0xc(%ebp)
  800311:	ff 75 08             	push   0x8(%ebp)
  800314:	e8 05 00 00 00       	call   80031e <vprintfmt>
}
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vprintfmt>:
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	57                   	push   %edi
  800322:	56                   	push   %esi
  800323:	53                   	push   %ebx
  800324:	83 ec 3c             	sub    $0x3c,%esp
  800327:	8b 75 08             	mov    0x8(%ebp),%esi
  80032a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800330:	eb 0a                	jmp    80033c <vprintfmt+0x1e>
			putch(ch, putdat);
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	53                   	push   %ebx
  800336:	50                   	push   %eax
  800337:	ff d6                	call   *%esi
  800339:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80033c:	83 c7 01             	add    $0x1,%edi
  80033f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800343:	83 f8 25             	cmp    $0x25,%eax
  800346:	74 0c                	je     800354 <vprintfmt+0x36>
			if (ch == '\0')
  800348:	85 c0                	test   %eax,%eax
  80034a:	75 e6                	jne    800332 <vprintfmt+0x14>
}
  80034c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034f:	5b                   	pop    %ebx
  800350:	5e                   	pop    %esi
  800351:	5f                   	pop    %edi
  800352:	5d                   	pop    %ebp
  800353:	c3                   	ret    
		padc = ' ';
  800354:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800358:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80035f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800366:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800378:	0f b6 17             	movzbl (%edi),%edx
  80037b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037e:	3c 55                	cmp    $0x55,%al
  800380:	0f 87 a6 04 00 00    	ja     80082c <vprintfmt+0x50e>
  800386:	0f b6 c0             	movzbl %al,%eax
  800389:	ff 24 85 a0 16 80 00 	jmp    *0x8016a0(,%eax,4)
  800390:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800393:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800397:	eb d9                	jmp    800372 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80039c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003a0:	eb d0                	jmp    800372 <vprintfmt+0x54>
  8003a2:	0f b6 d2             	movzbl %dl,%edx
  8003a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8003b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ba:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003bd:	83 f9 09             	cmp    $0x9,%ecx
  8003c0:	77 55                	ja     800417 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003c2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c5:	eb e9                	jmp    8003b0 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8d 40 04             	lea    0x4(%eax),%eax
  8003d5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003df:	79 91                	jns    800372 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003ee:	eb 82                	jmp    800372 <vprintfmt+0x54>
  8003f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003f3:	85 d2                	test   %edx,%edx
  8003f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fa:	0f 49 c2             	cmovns %edx,%eax
  8003fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800400:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800403:	e9 6a ff ff ff       	jmp    800372 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800408:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80040b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800412:	e9 5b ff ff ff       	jmp    800372 <vprintfmt+0x54>
  800417:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041d:	eb bc                	jmp    8003db <vprintfmt+0xbd>
			lflag++;
  80041f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800425:	e9 48 ff ff ff       	jmp    800372 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8d 78 04             	lea    0x4(%eax),%edi
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	53                   	push   %ebx
  800434:	ff 30                	push   (%eax)
  800436:	ff d6                	call   *%esi
			break;
  800438:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043e:	e9 88 03 00 00       	jmp    8007cb <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 78 04             	lea    0x4(%eax),%edi
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	f7 d8                	neg    %eax
  80044f:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800452:	83 f8 0f             	cmp    $0xf,%eax
  800455:	7f 23                	jg     80047a <vprintfmt+0x15c>
  800457:	8b 14 85 00 18 80 00 	mov    0x801800(,%eax,4),%edx
  80045e:	85 d2                	test   %edx,%edx
  800460:	74 18                	je     80047a <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800462:	52                   	push   %edx
  800463:	68 88 15 80 00       	push   $0x801588
  800468:	53                   	push   %ebx
  800469:	56                   	push   %esi
  80046a:	e8 92 fe ff ff       	call   800301 <printfmt>
  80046f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800472:	89 7d 14             	mov    %edi,0x14(%ebp)
  800475:	e9 51 03 00 00       	jmp    8007cb <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80047a:	50                   	push   %eax
  80047b:	68 7f 15 80 00       	push   $0x80157f
  800480:	53                   	push   %ebx
  800481:	56                   	push   %esi
  800482:	e8 7a fe ff ff       	call   800301 <printfmt>
  800487:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048d:	e9 39 03 00 00       	jmp    8007cb <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	83 c0 04             	add    $0x4,%eax
  800498:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004a0:	85 d2                	test   %edx,%edx
  8004a2:	b8 78 15 80 00       	mov    $0x801578,%eax
  8004a7:	0f 45 c2             	cmovne %edx,%eax
  8004aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b1:	7e 06                	jle    8004b9 <vprintfmt+0x19b>
  8004b3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b7:	75 0d                	jne    8004c6 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bc:	89 c7                	mov    %eax,%edi
  8004be:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004c4:	eb 55                	jmp    80051b <vprintfmt+0x1fd>
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	ff 75 e0             	push   -0x20(%ebp)
  8004cc:	ff 75 cc             	push   -0x34(%ebp)
  8004cf:	e8 f5 03 00 00       	call   8008c9 <strnlen>
  8004d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d7:	29 c2                	sub    %eax,%edx
  8004d9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004e1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	eb 0f                	jmp    8004f9 <vprintfmt+0x1db>
					putch(padc, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	ff 75 d4             	push   -0x2c(%ebp)
  8004f1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	83 ef 01             	sub    $0x1,%edi
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	85 ff                	test   %edi,%edi
  8004fb:	7f ed                	jg     8004ea <vprintfmt+0x1cc>
  8004fd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800500:	85 d2                	test   %edx,%edx
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	0f 49 c2             	cmovns %edx,%eax
  80050a:	29 c2                	sub    %eax,%edx
  80050c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80050f:	eb a8                	jmp    8004b9 <vprintfmt+0x19b>
					putch(ch, putdat);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	53                   	push   %ebx
  800515:	52                   	push   %edx
  800516:	ff d6                	call   *%esi
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80051e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800520:	83 c7 01             	add    $0x1,%edi
  800523:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800527:	0f be d0             	movsbl %al,%edx
  80052a:	85 d2                	test   %edx,%edx
  80052c:	74 4b                	je     800579 <vprintfmt+0x25b>
  80052e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800532:	78 06                	js     80053a <vprintfmt+0x21c>
  800534:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800538:	78 1e                	js     800558 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80053a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053e:	74 d1                	je     800511 <vprintfmt+0x1f3>
  800540:	0f be c0             	movsbl %al,%eax
  800543:	83 e8 20             	sub    $0x20,%eax
  800546:	83 f8 5e             	cmp    $0x5e,%eax
  800549:	76 c6                	jbe    800511 <vprintfmt+0x1f3>
					putch('?', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	6a 3f                	push   $0x3f
  800551:	ff d6                	call   *%esi
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	eb c3                	jmp    80051b <vprintfmt+0x1fd>
  800558:	89 cf                	mov    %ecx,%edi
  80055a:	eb 0e                	jmp    80056a <vprintfmt+0x24c>
				putch(' ', putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	6a 20                	push   $0x20
  800562:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800564:	83 ef 01             	sub    $0x1,%edi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	85 ff                	test   %edi,%edi
  80056c:	7f ee                	jg     80055c <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
  800574:	e9 52 02 00 00       	jmp    8007cb <vprintfmt+0x4ad>
  800579:	89 cf                	mov    %ecx,%edi
  80057b:	eb ed                	jmp    80056a <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	83 c0 04             	add    $0x4,%eax
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80058b:	85 d2                	test   %edx,%edx
  80058d:	b8 78 15 80 00       	mov    $0x801578,%eax
  800592:	0f 45 c2             	cmovne %edx,%eax
  800595:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800598:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80059c:	7e 06                	jle    8005a4 <vprintfmt+0x286>
  80059e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005a2:	75 0d                	jne    8005b1 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a7:	89 c7                	mov    %eax,%edi
  8005a9:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005af:	eb 55                	jmp    800606 <vprintfmt+0x2e8>
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 e0             	push   -0x20(%ebp)
  8005b7:	ff 75 cc             	push   -0x34(%ebp)
  8005ba:	e8 0a 03 00 00       	call   8008c9 <strnlen>
  8005bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c2:	29 c2                	sub    %eax,%edx
  8005c4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005cc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d3:	eb 0f                	jmp    8005e4 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	ff 75 d4             	push   -0x2c(%ebp)
  8005dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005de:	83 ef 01             	sub    $0x1,%edi
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	85 ff                	test   %edi,%edi
  8005e6:	7f ed                	jg     8005d5 <vprintfmt+0x2b7>
  8005e8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005eb:	85 d2                	test   %edx,%edx
  8005ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f2:	0f 49 c2             	cmovns %edx,%eax
  8005f5:	29 c2                	sub    %eax,%edx
  8005f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005fa:	eb a8                	jmp    8005a4 <vprintfmt+0x286>
					putch(ch, putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	52                   	push   %edx
  800601:	ff d6                	call   *%esi
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800609:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80060b:	83 c7 01             	add    $0x1,%edi
  80060e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800612:	0f be d0             	movsbl %al,%edx
  800615:	3c 3a                	cmp    $0x3a,%al
  800617:	74 4b                	je     800664 <vprintfmt+0x346>
  800619:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80061d:	78 06                	js     800625 <vprintfmt+0x307>
  80061f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800623:	78 1e                	js     800643 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800625:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800629:	74 d1                	je     8005fc <vprintfmt+0x2de>
  80062b:	0f be c0             	movsbl %al,%eax
  80062e:	83 e8 20             	sub    $0x20,%eax
  800631:	83 f8 5e             	cmp    $0x5e,%eax
  800634:	76 c6                	jbe    8005fc <vprintfmt+0x2de>
					putch('?', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 3f                	push   $0x3f
  80063c:	ff d6                	call   *%esi
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	eb c3                	jmp    800606 <vprintfmt+0x2e8>
  800643:	89 cf                	mov    %ecx,%edi
  800645:	eb 0e                	jmp    800655 <vprintfmt+0x337>
				putch(' ', putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	6a 20                	push   $0x20
  80064d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064f:	83 ef 01             	sub    $0x1,%edi
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	85 ff                	test   %edi,%edi
  800657:	7f ee                	jg     800647 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800659:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
  80065f:	e9 67 01 00 00       	jmp    8007cb <vprintfmt+0x4ad>
  800664:	89 cf                	mov    %ecx,%edi
  800666:	eb ed                	jmp    800655 <vprintfmt+0x337>
	if (lflag >= 2)
  800668:	83 f9 01             	cmp    $0x1,%ecx
  80066b:	7f 1b                	jg     800688 <vprintfmt+0x36a>
	else if (lflag)
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	74 63                	je     8006d4 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800679:	99                   	cltd   
  80067a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 40 04             	lea    0x4(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
  800686:	eb 17                	jmp    80069f <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 50 04             	mov    0x4(%eax),%edx
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800693:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 08             	lea    0x8(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8006a5:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006aa:	85 c9                	test   %ecx,%ecx
  8006ac:	0f 89 ff 00 00 00    	jns    8007b1 <vprintfmt+0x493>
				putch('-', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 2d                	push   $0x2d
  8006b8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006c0:	f7 da                	neg    %edx
  8006c2:	83 d1 00             	adc    $0x0,%ecx
  8006c5:	f7 d9                	neg    %ecx
  8006c7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ca:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006cf:	e9 dd 00 00 00       	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006dc:	99                   	cltd   
  8006dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e9:	eb b4                	jmp    80069f <vprintfmt+0x381>
	if (lflag >= 2)
  8006eb:	83 f9 01             	cmp    $0x1,%ecx
  8006ee:	7f 1e                	jg     80070e <vprintfmt+0x3f0>
	else if (lflag)
  8006f0:	85 c9                	test   %ecx,%ecx
  8006f2:	74 32                	je     800726 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 10                	mov    (%eax),%edx
  8006f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800709:	e9 a3 00 00 00       	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 10                	mov    (%eax),%edx
  800713:	8b 48 04             	mov    0x4(%eax),%ecx
  800716:	8d 40 08             	lea    0x8(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800721:	e9 8b 00 00 00       	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800736:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80073b:	eb 74                	jmp    8007b1 <vprintfmt+0x493>
	if (lflag >= 2)
  80073d:	83 f9 01             	cmp    $0x1,%ecx
  800740:	7f 1b                	jg     80075d <vprintfmt+0x43f>
	else if (lflag)
  800742:	85 c9                	test   %ecx,%ecx
  800744:	74 2c                	je     800772 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800756:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80075b:	eb 54                	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	8b 48 04             	mov    0x4(%eax),%ecx
  800765:	8d 40 08             	lea    0x8(%eax),%eax
  800768:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800770:	eb 3f                	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 10                	mov    (%eax),%edx
  800777:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077c:	8d 40 04             	lea    0x4(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800782:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800787:	eb 28                	jmp    8007b1 <vprintfmt+0x493>
			putch('0', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 30                	push   $0x30
  80078f:	ff d6                	call   *%esi
			putch('x', putdat);
  800791:	83 c4 08             	add    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	6a 78                	push   $0x78
  800797:	ff d6                	call   *%esi
			num = (unsigned long long)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 10                	mov    (%eax),%edx
  80079e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ac:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8007b1:	83 ec 0c             	sub    $0xc,%esp
  8007b4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 d4             	push   -0x2c(%ebp)
  8007bc:	57                   	push   %edi
  8007bd:	51                   	push   %ecx
  8007be:	52                   	push   %edx
  8007bf:	89 da                	mov    %ebx,%edx
  8007c1:	89 f0                	mov    %esi,%eax
  8007c3:	e8 73 fa ff ff       	call   80023b <printnum>
			break;
  8007c8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ce:	e9 69 fb ff ff       	jmp    80033c <vprintfmt+0x1e>
	if (lflag >= 2)
  8007d3:	83 f9 01             	cmp    $0x1,%ecx
  8007d6:	7f 1b                	jg     8007f3 <vprintfmt+0x4d5>
	else if (lflag)
  8007d8:	85 c9                	test   %ecx,%ecx
  8007da:	74 2c                	je     800808 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 10                	mov    (%eax),%edx
  8007e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007f1:	eb be                	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 10                	mov    (%eax),%edx
  8007f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007fb:	8d 40 08             	lea    0x8(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800801:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800806:	eb a9                	jmp    8007b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800818:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  80081d:	eb 92                	jmp    8007b1 <vprintfmt+0x493>
			putch(ch, putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	53                   	push   %ebx
  800823:	6a 25                	push   $0x25
  800825:	ff d6                	call   *%esi
			break;
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	eb 9f                	jmp    8007cb <vprintfmt+0x4ad>
			putch('%', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 25                	push   $0x25
  800832:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	89 f8                	mov    %edi,%eax
  800839:	eb 03                	jmp    80083e <vprintfmt+0x520>
  80083b:	83 e8 01             	sub    $0x1,%eax
  80083e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800842:	75 f7                	jne    80083b <vprintfmt+0x51d>
  800844:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800847:	eb 82                	jmp    8007cb <vprintfmt+0x4ad>

00800849 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	83 ec 18             	sub    $0x18,%esp
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800855:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800858:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800866:	85 c0                	test   %eax,%eax
  800868:	74 26                	je     800890 <vsnprintf+0x47>
  80086a:	85 d2                	test   %edx,%edx
  80086c:	7e 22                	jle    800890 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086e:	ff 75 14             	push   0x14(%ebp)
  800871:	ff 75 10             	push   0x10(%ebp)
  800874:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800877:	50                   	push   %eax
  800878:	68 e4 02 80 00       	push   $0x8002e4
  80087d:	e8 9c fa ff ff       	call   80031e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800885:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088b:	83 c4 10             	add    $0x10,%esp
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    
		return -E_INVAL;
  800890:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800895:	eb f7                	jmp    80088e <vsnprintf+0x45>

00800897 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a0:	50                   	push   %eax
  8008a1:	ff 75 10             	push   0x10(%ebp)
  8008a4:	ff 75 0c             	push   0xc(%ebp)
  8008a7:	ff 75 08             	push   0x8(%ebp)
  8008aa:	e8 9a ff ff ff       	call   800849 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bc:	eb 03                	jmp    8008c1 <strlen+0x10>
		n++;
  8008be:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c5:	75 f7                	jne    8008be <strlen+0xd>
	return n;
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb 03                	jmp    8008dc <strnlen+0x13>
		n++;
  8008d9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	39 d0                	cmp    %edx,%eax
  8008de:	74 08                	je     8008e8 <strnlen+0x1f>
  8008e0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e4:	75 f3                	jne    8008d9 <strnlen+0x10>
  8008e6:	89 c2                	mov    %eax,%edx
	return n;
}
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	53                   	push   %ebx
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800902:	83 c0 01             	add    $0x1,%eax
  800905:	84 d2                	test   %dl,%dl
  800907:	75 f2                	jne    8008fb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800909:	89 c8                	mov    %ecx,%eax
  80090b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	83 ec 10             	sub    $0x10,%esp
  800917:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80091a:	53                   	push   %ebx
  80091b:	e8 91 ff ff ff       	call   8008b1 <strlen>
  800920:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800923:	ff 75 0c             	push   0xc(%ebp)
  800926:	01 d8                	add    %ebx,%eax
  800928:	50                   	push   %eax
  800929:	e8 be ff ff ff       	call   8008ec <strcpy>
	return dst;
}
  80092e:	89 d8                	mov    %ebx,%eax
  800930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 75 08             	mov    0x8(%ebp),%esi
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 f3                	mov    %esi,%ebx
  800942:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	89 f0                	mov    %esi,%eax
  800947:	eb 0f                	jmp    800958 <strncpy+0x23>
		*dst++ = *src;
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	0f b6 0a             	movzbl (%edx),%ecx
  80094f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800952:	80 f9 01             	cmp    $0x1,%cl
  800955:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800958:	39 d8                	cmp    %ebx,%eax
  80095a:	75 ed                	jne    800949 <strncpy+0x14>
	}
	return ret;
}
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	8b 75 08             	mov    0x8(%ebp),%esi
  80096a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096d:	8b 55 10             	mov    0x10(%ebp),%edx
  800970:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800972:	85 d2                	test   %edx,%edx
  800974:	74 21                	je     800997 <strlcpy+0x35>
  800976:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097a:	89 f2                	mov    %esi,%edx
  80097c:	eb 09                	jmp    800987 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800987:	39 c2                	cmp    %eax,%edx
  800989:	74 09                	je     800994 <strlcpy+0x32>
  80098b:	0f b6 19             	movzbl (%ecx),%ebx
  80098e:	84 db                	test   %bl,%bl
  800990:	75 ec                	jne    80097e <strlcpy+0x1c>
  800992:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800994:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800997:	29 f0                	sub    %esi,%eax
}
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a6:	eb 06                	jmp    8009ae <strcmp+0x11>
		p++, q++;
  8009a8:	83 c1 01             	add    $0x1,%ecx
  8009ab:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 04                	je     8009b9 <strcmp+0x1c>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	74 ef                	je     8009a8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b9:	0f b6 c0             	movzbl %al,%eax
  8009bc:	0f b6 12             	movzbl (%edx),%edx
  8009bf:	29 d0                	sub    %edx,%eax
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	89 c3                	mov    %eax,%ebx
  8009cf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d2:	eb 06                	jmp    8009da <strncmp+0x17>
		n--, p++, q++;
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009da:	39 d8                	cmp    %ebx,%eax
  8009dc:	74 18                	je     8009f6 <strncmp+0x33>
  8009de:	0f b6 08             	movzbl (%eax),%ecx
  8009e1:	84 c9                	test   %cl,%cl
  8009e3:	74 04                	je     8009e9 <strncmp+0x26>
  8009e5:	3a 0a                	cmp    (%edx),%cl
  8009e7:	74 eb                	je     8009d4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e9:	0f b6 00             	movzbl (%eax),%eax
  8009ec:	0f b6 12             	movzbl (%edx),%edx
  8009ef:	29 d0                	sub    %edx,%eax
}
  8009f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    
		return 0;
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb f4                	jmp    8009f1 <strncmp+0x2e>

008009fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a07:	eb 03                	jmp    800a0c <strchr+0xf>
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	0f b6 10             	movzbl (%eax),%edx
  800a0f:	84 d2                	test   %dl,%dl
  800a11:	74 06                	je     800a19 <strchr+0x1c>
		if (*s == c)
  800a13:	38 ca                	cmp    %cl,%dl
  800a15:	75 f2                	jne    800a09 <strchr+0xc>
  800a17:	eb 05                	jmp    800a1e <strchr+0x21>
			return (char *) s;
	return 0;
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a2d:	38 ca                	cmp    %cl,%dl
  800a2f:	74 09                	je     800a3a <strfind+0x1a>
  800a31:	84 d2                	test   %dl,%dl
  800a33:	74 05                	je     800a3a <strfind+0x1a>
	for (; *s; s++)
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	eb f0                	jmp    800a2a <strfind+0xa>
			break;
	return (char *) s;
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	57                   	push   %edi
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a48:	85 c9                	test   %ecx,%ecx
  800a4a:	74 2f                	je     800a7b <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4c:	89 f8                	mov    %edi,%eax
  800a4e:	09 c8                	or     %ecx,%eax
  800a50:	a8 03                	test   $0x3,%al
  800a52:	75 21                	jne    800a75 <memset+0x39>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d0                	mov    %edx,%eax
  800a5a:	c1 e0 08             	shl    $0x8,%eax
  800a5d:	89 d3                	mov    %edx,%ebx
  800a5f:	c1 e3 18             	shl    $0x18,%ebx
  800a62:	89 d6                	mov    %edx,%esi
  800a64:	c1 e6 10             	shl    $0x10,%esi
  800a67:	09 f3                	or     %esi,%ebx
  800a69:	09 da                	or     %ebx,%edx
  800a6b:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a70:	fc                   	cld    
  800a71:	f3 ab                	rep stos %eax,%es:(%edi)
  800a73:	eb 06                	jmp    800a7b <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	fc                   	cld    
  800a79:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7b:	89 f8                	mov    %edi,%eax
  800a7d:	5b                   	pop    %ebx
  800a7e:	5e                   	pop    %esi
  800a7f:	5f                   	pop    %edi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	57                   	push   %edi
  800a86:	56                   	push   %esi
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a90:	39 c6                	cmp    %eax,%esi
  800a92:	73 32                	jae    800ac6 <memmove+0x44>
  800a94:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a97:	39 c2                	cmp    %eax,%edx
  800a99:	76 2b                	jbe    800ac6 <memmove+0x44>
		s += n;
		d += n;
  800a9b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9e:	89 d6                	mov    %edx,%esi
  800aa0:	09 fe                	or     %edi,%esi
  800aa2:	09 ce                	or     %ecx,%esi
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 0e                	jne    800aba <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aac:	83 ef 04             	sub    $0x4,%edi
  800aaf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab8:	eb 09                	jmp    800ac3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aba:	83 ef 01             	sub    $0x1,%edi
  800abd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac0:	fd                   	std    
  800ac1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac3:	fc                   	cld    
  800ac4:	eb 1a                	jmp    800ae0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac6:	89 f2                	mov    %esi,%edx
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	09 ca                	or     %ecx,%edx
  800acc:	f6 c2 03             	test   $0x3,%dl
  800acf:	75 0a                	jne    800adb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad4:	89 c7                	mov    %eax,%edi
  800ad6:	fc                   	cld    
  800ad7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad9:	eb 05                	jmp    800ae0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800adb:	89 c7                	mov    %eax,%edi
  800add:	fc                   	cld    
  800ade:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aea:	ff 75 10             	push   0x10(%ebp)
  800aed:	ff 75 0c             	push   0xc(%ebp)
  800af0:	ff 75 08             	push   0x8(%ebp)
  800af3:	e8 8a ff ff ff       	call   800a82 <memmove>
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 c6                	mov    %eax,%esi
  800b07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0a:	eb 06                	jmp    800b12 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b12:	39 f0                	cmp    %esi,%eax
  800b14:	74 14                	je     800b2a <memcmp+0x30>
		if (*s1 != *s2)
  800b16:	0f b6 08             	movzbl (%eax),%ecx
  800b19:	0f b6 1a             	movzbl (%edx),%ebx
  800b1c:	38 d9                	cmp    %bl,%cl
  800b1e:	74 ec                	je     800b0c <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b20:	0f b6 c1             	movzbl %cl,%eax
  800b23:	0f b6 db             	movzbl %bl,%ebx
  800b26:	29 d8                	sub    %ebx,%eax
  800b28:	eb 05                	jmp    800b2f <memcmp+0x35>
	}

	return 0;
  800b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b41:	eb 03                	jmp    800b46 <memfind+0x13>
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	39 d0                	cmp    %edx,%eax
  800b48:	73 04                	jae    800b4e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4a:	38 08                	cmp    %cl,(%eax)
  800b4c:	75 f5                	jne    800b43 <memfind+0x10>
			break;
	return (void *) s;
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 55 08             	mov    0x8(%ebp),%edx
  800b59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5c:	eb 03                	jmp    800b61 <strtol+0x11>
		s++;
  800b5e:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b61:	0f b6 02             	movzbl (%edx),%eax
  800b64:	3c 20                	cmp    $0x20,%al
  800b66:	74 f6                	je     800b5e <strtol+0xe>
  800b68:	3c 09                	cmp    $0x9,%al
  800b6a:	74 f2                	je     800b5e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b6c:	3c 2b                	cmp    $0x2b,%al
  800b6e:	74 2a                	je     800b9a <strtol+0x4a>
	int neg = 0;
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b75:	3c 2d                	cmp    $0x2d,%al
  800b77:	74 2b                	je     800ba4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7f:	75 0f                	jne    800b90 <strtol+0x40>
  800b81:	80 3a 30             	cmpb   $0x30,(%edx)
  800b84:	74 28                	je     800bae <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b86:	85 db                	test   %ebx,%ebx
  800b88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8d:	0f 44 d8             	cmove  %eax,%ebx
  800b90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b98:	eb 46                	jmp    800be0 <strtol+0x90>
		s++;
  800b9a:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba2:	eb d5                	jmp    800b79 <strtol+0x29>
		s++, neg = 1;
  800ba4:	83 c2 01             	add    $0x1,%edx
  800ba7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bac:	eb cb                	jmp    800b79 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bae:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb2:	74 0e                	je     800bc2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb4:	85 db                	test   %ebx,%ebx
  800bb6:	75 d8                	jne    800b90 <strtol+0x40>
		s++, base = 8;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc0:	eb ce                	jmp    800b90 <strtol+0x40>
		s += 2, base = 16;
  800bc2:	83 c2 02             	add    $0x2,%edx
  800bc5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bca:	eb c4                	jmp    800b90 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bcc:	0f be c0             	movsbl %al,%eax
  800bcf:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bd5:	7d 3a                	jge    800c11 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd7:	83 c2 01             	add    $0x1,%edx
  800bda:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bde:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800be0:	0f b6 02             	movzbl (%edx),%eax
  800be3:	8d 70 d0             	lea    -0x30(%eax),%esi
  800be6:	89 f3                	mov    %esi,%ebx
  800be8:	80 fb 09             	cmp    $0x9,%bl
  800beb:	76 df                	jbe    800bcc <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bed:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bf0:	89 f3                	mov    %esi,%ebx
  800bf2:	80 fb 19             	cmp    $0x19,%bl
  800bf5:	77 08                	ja     800bff <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf7:	0f be c0             	movsbl %al,%eax
  800bfa:	83 e8 57             	sub    $0x57,%eax
  800bfd:	eb d3                	jmp    800bd2 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bff:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c02:	89 f3                	mov    %esi,%ebx
  800c04:	80 fb 19             	cmp    $0x19,%bl
  800c07:	77 08                	ja     800c11 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c09:	0f be c0             	movsbl %al,%eax
  800c0c:	83 e8 37             	sub    $0x37,%eax
  800c0f:	eb c1                	jmp    800bd2 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c15:	74 05                	je     800c1c <strtol+0xcc>
		*endptr = (char *) s;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c1c:	89 c8                	mov    %ecx,%eax
  800c1e:	f7 d8                	neg    %eax
  800c20:	85 ff                	test   %edi,%edi
  800c22:	0f 45 c8             	cmovne %eax,%ecx
}
  800c25:	89 c8                	mov    %ecx,%eax
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	89 c3                	mov    %eax,%ebx
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	89 c6                	mov    %eax,%esi
  800c43:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5a:	89 d1                	mov    %edx,%ecx
  800c5c:	89 d3                	mov    %edx,%ebx
  800c5e:	89 d7                	mov    %edx,%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7f:	89 cb                	mov    %ecx,%ebx
  800c81:	89 cf                	mov    %ecx,%edi
  800c83:	89 ce                	mov    %ecx,%esi
  800c85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7f 08                	jg     800c93 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	50                   	push   %eax
  800c97:	6a 03                	push   $0x3
  800c99:	68 5f 18 80 00       	push   $0x80185f
  800c9e:	6a 23                	push   $0x23
  800ca0:	68 7c 18 80 00       	push   $0x80187c
  800ca5:	e8 a2 f4 ff ff       	call   80014c <_panic>

00800caa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cba:	89 d1                	mov    %edx,%ecx
  800cbc:	89 d3                	mov    %edx,%ebx
  800cbe:	89 d7                	mov    %edx,%edi
  800cc0:	89 d6                	mov    %edx,%esi
  800cc2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_yield>:

void
sys_yield(void)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd9:	89 d1                	mov    %edx,%ecx
  800cdb:	89 d3                	mov    %edx,%ebx
  800cdd:	89 d7                	mov    %edx,%edi
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	be 00 00 00 00       	mov    $0x0,%esi
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	b8 04 00 00 00       	mov    $0x4,%eax
  800d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d04:	89 f7                	mov    %esi,%edi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 04                	push   $0x4
  800d1a:	68 5f 18 80 00       	push   $0x80185f
  800d1f:	6a 23                	push   $0x23
  800d21:	68 7c 18 80 00       	push   $0x80187c
  800d26:	e8 21 f4 ff ff       	call   80014c <_panic>

00800d2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
  800d31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d45:	8b 75 18             	mov    0x18(%ebp),%esi
  800d48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7f 08                	jg     800d56 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	50                   	push   %eax
  800d5a:	6a 05                	push   $0x5
  800d5c:	68 5f 18 80 00       	push   $0x80185f
  800d61:	6a 23                	push   $0x23
  800d63:	68 7c 18 80 00       	push   $0x80187c
  800d68:	e8 df f3 ff ff       	call   80014c <_panic>

00800d6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 06 00 00 00       	mov    $0x6,%eax
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 06                	push   $0x6
  800d9e:	68 5f 18 80 00       	push   $0x80185f
  800da3:	6a 23                	push   $0x23
  800da5:	68 7c 18 80 00       	push   $0x80187c
  800daa:	e8 9d f3 ff ff       	call   80014c <_panic>

00800daf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7f 08                	jg     800dda <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	83 ec 0c             	sub    $0xc,%esp
  800ddd:	50                   	push   %eax
  800dde:	6a 08                	push   $0x8
  800de0:	68 5f 18 80 00       	push   $0x80185f
  800de5:	6a 23                	push   $0x23
  800de7:	68 7c 18 80 00       	push   $0x80187c
  800dec:	e8 5b f3 ff ff       	call   80014c <_panic>

00800df1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0a:	89 df                	mov    %ebx,%edi
  800e0c:	89 de                	mov    %ebx,%esi
  800e0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	7f 08                	jg     800e1c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	6a 09                	push   $0x9
  800e22:	68 5f 18 80 00       	push   $0x80185f
  800e27:	6a 23                	push   $0x23
  800e29:	68 7c 18 80 00       	push   $0x80187c
  800e2e:	e8 19 f3 ff ff       	call   80014c <_panic>

00800e33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 0a                	push   $0xa
  800e64:	68 5f 18 80 00       	push   $0x80185f
  800e69:	6a 23                	push   $0x23
  800e6b:	68 7c 18 80 00       	push   $0x80187c
  800e70:	e8 d7 f2 ff ff       	call   80014c <_panic>

00800e75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	be 00 00 00 00       	mov    $0x0,%esi
  800e8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e91:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eae:	89 cb                	mov    %ecx,%ebx
  800eb0:	89 cf                	mov    %ecx,%edi
  800eb2:	89 ce                	mov    %ecx,%esi
  800eb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	7f 08                	jg     800ec2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	83 ec 0c             	sub    $0xc,%esp
  800ec5:	50                   	push   %eax
  800ec6:	6a 0d                	push   $0xd
  800ec8:	68 5f 18 80 00       	push   $0x80185f
  800ecd:	6a 23                	push   $0x23
  800ecf:	68 7c 18 80 00       	push   $0x80187c
  800ed4:	e8 73 f2 ff ff       	call   80014c <_panic>

00800ed9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	53                   	push   %ebx
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ee3:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800ee5:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ee9:	0f 84 99 00 00 00    	je     800f88 <pgfault+0xaf>
  800eef:	89 d8                	mov    %ebx,%eax
  800ef1:	c1 e8 16             	shr    $0x16,%eax
  800ef4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800efb:	a8 01                	test   $0x1,%al
  800efd:	0f 84 85 00 00 00    	je     800f88 <pgfault+0xaf>
  800f03:	89 d8                	mov    %ebx,%eax
  800f05:	c1 e8 0c             	shr    $0xc,%eax
  800f08:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f0f:	f6 c6 08             	test   $0x8,%dh
  800f12:	74 74                	je     800f88 <pgfault+0xaf>
  800f14:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f1b:	a8 01                	test   $0x1,%al
  800f1d:	74 69                	je     800f88 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800f1f:	83 ec 04             	sub    $0x4,%esp
  800f22:	6a 07                	push   $0x7
  800f24:	68 00 f0 7f 00       	push   $0x7ff000
  800f29:	6a 00                	push   $0x0
  800f2b:	e8 b8 fd ff ff       	call   800ce8 <sys_page_alloc>
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	85 c0                	test   %eax,%eax
  800f35:	78 65                	js     800f9c <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f37:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f3d:	83 ec 04             	sub    $0x4,%esp
  800f40:	68 00 10 00 00       	push   $0x1000
  800f45:	53                   	push   %ebx
  800f46:	68 00 f0 7f 00       	push   $0x7ff000
  800f4b:	e8 94 fb ff ff       	call   800ae4 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800f50:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f57:	53                   	push   %ebx
  800f58:	6a 00                	push   $0x0
  800f5a:	68 00 f0 7f 00       	push   $0x7ff000
  800f5f:	6a 00                	push   $0x0
  800f61:	e8 c5 fd ff ff       	call   800d2b <sys_page_map>
  800f66:	83 c4 20             	add    $0x20,%esp
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	78 43                	js     800fb0 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	68 00 f0 7f 00       	push   $0x7ff000
  800f75:	6a 00                	push   $0x0
  800f77:	e8 f1 fd ff ff       	call   800d6d <sys_page_unmap>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	78 41                	js     800fc4 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    
		panic("invalid permision\n");
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	68 8a 18 80 00       	push   $0x80188a
  800f90:	6a 1f                	push   $0x1f
  800f92:	68 9d 18 80 00       	push   $0x80189d
  800f97:	e8 b0 f1 ff ff       	call   80014c <_panic>
		panic("Unable to alloc page\n");
  800f9c:	83 ec 04             	sub    $0x4,%esp
  800f9f:	68 a8 18 80 00       	push   $0x8018a8
  800fa4:	6a 28                	push   $0x28
  800fa6:	68 9d 18 80 00       	push   $0x80189d
  800fab:	e8 9c f1 ff ff       	call   80014c <_panic>
		panic("Unable to map\n");
  800fb0:	83 ec 04             	sub    $0x4,%esp
  800fb3:	68 be 18 80 00       	push   $0x8018be
  800fb8:	6a 2b                	push   $0x2b
  800fba:	68 9d 18 80 00       	push   $0x80189d
  800fbf:	e8 88 f1 ff ff       	call   80014c <_panic>
		panic("Unable to unmap\n");
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	68 cd 18 80 00       	push   $0x8018cd
  800fcc:	6a 2d                	push   $0x2d
  800fce:	68 9d 18 80 00       	push   $0x80189d
  800fd3:	e8 74 f1 ff ff       	call   80014c <_panic>

00800fd8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800fe1:	68 d9 0e 80 00       	push   $0x800ed9
  800fe6:	e8 59 02 00 00       	call   801244 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800feb:	b8 07 00 00 00       	mov    $0x7,%eax
  800ff0:	cd 30                	int    $0x30
  800ff2:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 23                	js     80101e <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800ffb:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  801000:	75 6d                	jne    80106f <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  801002:	e8 a3 fc ff ff       	call   800caa <sys_getenvid>
  801007:	25 ff 03 00 00       	and    $0x3ff,%eax
  80100c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80100f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801014:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801019:	e9 02 01 00 00       	jmp    801120 <fork+0x148>
		panic("sys_exofork: %e", envid);
  80101e:	50                   	push   %eax
  80101f:	68 de 18 80 00       	push   $0x8018de
  801024:	6a 6d                	push   $0x6d
  801026:	68 9d 18 80 00       	push   $0x80189d
  80102b:	e8 1c f1 ff ff       	call   80014c <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801030:	c1 e0 0c             	shl    $0xc,%eax
  801033:	83 ec 0c             	sub    $0xc,%esp
  801036:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80103c:	52                   	push   %edx
  80103d:	50                   	push   %eax
  80103e:	56                   	push   %esi
  80103f:	50                   	push   %eax
  801040:	6a 00                	push   $0x0
  801042:	e8 e4 fc ff ff       	call   800d2b <sys_page_map>
  801047:	83 c4 20             	add    $0x20,%esp
  80104a:	eb 15                	jmp    801061 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  80104c:	c1 e0 0c             	shl    $0xc,%eax
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	6a 05                	push   $0x5
  801054:	50                   	push   %eax
  801055:	56                   	push   %esi
  801056:	50                   	push   %eax
  801057:	6a 00                	push   $0x0
  801059:	e8 cd fc ff ff       	call   800d2b <sys_page_map>
  80105e:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801061:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801067:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80106d:	74 7a                	je     8010e9 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80106f:	89 d8                	mov    %ebx,%eax
  801071:	c1 e8 16             	shr    $0x16,%eax
  801074:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80107b:	a8 01                	test   $0x1,%al
  80107d:	74 e2                	je     801061 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80107f:	89 d8                	mov    %ebx,%eax
  801081:	c1 e8 0c             	shr    $0xc,%eax
  801084:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  80108b:	f6 c2 01             	test   $0x1,%dl
  80108e:	74 d1                	je     801061 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801090:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801097:	f6 c2 04             	test   $0x4,%dl
  80109a:	74 c5                	je     801061 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80109c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a3:	f6 c6 04             	test   $0x4,%dh
  8010a6:	75 88                	jne    801030 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  8010a8:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8010ae:	74 9c                	je     80104c <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  8010b0:	c1 e0 0c             	shl    $0xc,%eax
  8010b3:	89 c7                	mov    %eax,%edi
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	68 05 08 00 00       	push   $0x805
  8010bd:	50                   	push   %eax
  8010be:	56                   	push   %esi
  8010bf:	50                   	push   %eax
  8010c0:	6a 00                	push   $0x0
  8010c2:	e8 64 fc ff ff       	call   800d2b <sys_page_map>
  8010c7:	83 c4 20             	add    $0x20,%esp
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	78 93                	js     801061 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8010ce:	83 ec 0c             	sub    $0xc,%esp
  8010d1:	68 05 08 00 00       	push   $0x805
  8010d6:	57                   	push   %edi
  8010d7:	6a 00                	push   $0x0
  8010d9:	57                   	push   %edi
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 4a fc ff ff       	call   800d2b <sys_page_map>
  8010e1:	83 c4 20             	add    $0x20,%esp
  8010e4:	e9 78 ff ff ff       	jmp    801061 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	6a 07                	push   $0x7
  8010ee:	68 00 f0 bf ee       	push   $0xeebff000
  8010f3:	56                   	push   %esi
  8010f4:	e8 ef fb ff ff       	call   800ce8 <sys_page_alloc>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	78 2a                	js     80112a <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	68 b3 12 80 00       	push   $0x8012b3
  801108:	56                   	push   %esi
  801109:	e8 25 fd ff ff       	call   800e33 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80110e:	83 c4 08             	add    $0x8,%esp
  801111:	6a 02                	push   $0x2
  801113:	56                   	push   %esi
  801114:	e8 96 fc ff ff       	call   800daf <sys_env_set_status>
  801119:	83 c4 10             	add    $0x10,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 21                	js     801141 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801120:	89 f0                	mov    %esi,%eax
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
		panic("failed to alloc page");
  80112a:	83 ec 04             	sub    $0x4,%esp
  80112d:	68 ee 18 80 00       	push   $0x8018ee
  801132:	68 82 00 00 00       	push   $0x82
  801137:	68 9d 18 80 00       	push   $0x80189d
  80113c:	e8 0b f0 ff ff       	call   80014c <_panic>
		panic("sys_env_set_status: %e", r);
  801141:	50                   	push   %eax
  801142:	68 03 19 80 00       	push   $0x801903
  801147:	68 89 00 00 00       	push   $0x89
  80114c:	68 9d 18 80 00       	push   $0x80189d
  801151:	e8 f6 ef ff ff       	call   80014c <_panic>

00801156 <sfork>:

// Challenge!
int
sfork(void)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80115c:	68 1a 19 80 00       	push   $0x80191a
  801161:	68 92 00 00 00       	push   $0x92
  801166:	68 9d 18 80 00       	push   $0x80189d
  80116b:	e8 dc ef ff ff       	call   80014c <_panic>

00801170 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	8b 75 08             	mov    0x8(%ebp),%esi
  801178:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	ff 75 0c             	push   0xc(%ebp)
  801181:	e8 12 fd ff ff       	call   800e98 <sys_ipc_recv>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	78 2b                	js     8011b8 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80118d:	85 f6                	test   %esi,%esi
  80118f:	74 0a                	je     80119b <ipc_recv+0x2b>
  801191:	a1 04 20 80 00       	mov    0x802004,%eax
  801196:	8b 40 74             	mov    0x74(%eax),%eax
  801199:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80119b:	85 db                	test   %ebx,%ebx
  80119d:	74 0a                	je     8011a9 <ipc_recv+0x39>
  80119f:	a1 04 20 80 00       	mov    0x802004,%eax
  8011a4:	8b 40 78             	mov    0x78(%eax),%eax
  8011a7:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8011a9:	a1 04 20 80 00       	mov    0x802004,%eax
  8011ae:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8011b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011bd:	eb f2                	jmp    8011b1 <ipc_recv+0x41>

008011bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8011d1:	ff 75 14             	push   0x14(%ebp)
  8011d4:	53                   	push   %ebx
  8011d5:	56                   	push   %esi
  8011d6:	57                   	push   %edi
  8011d7:	e8 99 fc ff ff       	call   800e75 <sys_ipc_try_send>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	79 20                	jns    801203 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8011e3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011e6:	75 07                	jne    8011ef <ipc_send+0x30>
		sys_yield();
  8011e8:	e8 dc fa ff ff       	call   800cc9 <sys_yield>
  8011ed:	eb e2                	jmp    8011d1 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	68 30 19 80 00       	push   $0x801930
  8011f7:	6a 2e                	push   $0x2e
  8011f9:	68 40 19 80 00       	push   $0x801940
  8011fe:	e8 49 ef ff ff       	call   80014c <_panic>
	}
}
  801203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801211:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801216:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801219:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80121f:	8b 52 50             	mov    0x50(%edx),%edx
  801222:	39 ca                	cmp    %ecx,%edx
  801224:	74 11                	je     801237 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801226:	83 c0 01             	add    $0x1,%eax
  801229:	3d 00 04 00 00       	cmp    $0x400,%eax
  80122e:	75 e6                	jne    801216 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
  801235:	eb 0b                	jmp    801242 <ipc_find_env+0x37>
			return envs[i].env_id;
  801237:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80123a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80123f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    

00801244 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80124a:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801251:	74 20                	je     801273 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	68 b3 12 80 00       	push   $0x8012b3
  801263:	6a 00                	push   $0x0
  801265:	e8 c9 fb ff ff       	call   800e33 <sys_env_set_pgfault_upcall>
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 2e                	js     80129f <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801271:	c9                   	leave  
  801272:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	6a 07                	push   $0x7
  801278:	68 00 f0 bf ee       	push   $0xeebff000
  80127d:	6a 00                	push   $0x0
  80127f:	e8 64 fa ff ff       	call   800ce8 <sys_page_alloc>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	79 c8                	jns    801253 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	68 4c 19 80 00       	push   $0x80194c
  801293:	6a 21                	push   $0x21
  801295:	68 af 19 80 00       	push   $0x8019af
  80129a:	e8 ad ee ff ff       	call   80014c <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80129f:	83 ec 04             	sub    $0x4,%esp
  8012a2:	68 78 19 80 00       	push   $0x801978
  8012a7:	6a 27                	push   $0x27
  8012a9:	68 af 19 80 00       	push   $0x8019af
  8012ae:	e8 99 ee ff ff       	call   80014c <_panic>

008012b3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012b3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012b4:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8012b9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8012bb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8012be:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8012c2:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8012c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8012cb:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8012cd:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8012d0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8012d1:	83 c4 04             	add    $0x4,%esp
	popfl
  8012d4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8012d5:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8012d6:	c3                   	ret    
  8012d7:	66 90                	xchg   %ax,%ax
  8012d9:	66 90                	xchg   %ax,%ax
  8012db:	66 90                	xchg   %ax,%ax
  8012dd:	66 90                	xchg   %ax,%ax
  8012df:	90                   	nop

008012e0 <__udivdi3>:
  8012e0:	f3 0f 1e fb          	endbr32 
  8012e4:	55                   	push   %ebp
  8012e5:	57                   	push   %edi
  8012e6:	56                   	push   %esi
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 1c             	sub    $0x1c,%esp
  8012eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8012ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8012f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8012f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	75 19                	jne    801318 <__udivdi3+0x38>
  8012ff:	39 f3                	cmp    %esi,%ebx
  801301:	76 4d                	jbe    801350 <__udivdi3+0x70>
  801303:	31 ff                	xor    %edi,%edi
  801305:	89 e8                	mov    %ebp,%eax
  801307:	89 f2                	mov    %esi,%edx
  801309:	f7 f3                	div    %ebx
  80130b:	89 fa                	mov    %edi,%edx
  80130d:	83 c4 1c             	add    $0x1c,%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
  801315:	8d 76 00             	lea    0x0(%esi),%esi
  801318:	39 f0                	cmp    %esi,%eax
  80131a:	76 14                	jbe    801330 <__udivdi3+0x50>
  80131c:	31 ff                	xor    %edi,%edi
  80131e:	31 c0                	xor    %eax,%eax
  801320:	89 fa                	mov    %edi,%edx
  801322:	83 c4 1c             	add    $0x1c,%esp
  801325:	5b                   	pop    %ebx
  801326:	5e                   	pop    %esi
  801327:	5f                   	pop    %edi
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    
  80132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801330:	0f bd f8             	bsr    %eax,%edi
  801333:	83 f7 1f             	xor    $0x1f,%edi
  801336:	75 48                	jne    801380 <__udivdi3+0xa0>
  801338:	39 f0                	cmp    %esi,%eax
  80133a:	72 06                	jb     801342 <__udivdi3+0x62>
  80133c:	31 c0                	xor    %eax,%eax
  80133e:	39 eb                	cmp    %ebp,%ebx
  801340:	77 de                	ja     801320 <__udivdi3+0x40>
  801342:	b8 01 00 00 00       	mov    $0x1,%eax
  801347:	eb d7                	jmp    801320 <__udivdi3+0x40>
  801349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801350:	89 d9                	mov    %ebx,%ecx
  801352:	85 db                	test   %ebx,%ebx
  801354:	75 0b                	jne    801361 <__udivdi3+0x81>
  801356:	b8 01 00 00 00       	mov    $0x1,%eax
  80135b:	31 d2                	xor    %edx,%edx
  80135d:	f7 f3                	div    %ebx
  80135f:	89 c1                	mov    %eax,%ecx
  801361:	31 d2                	xor    %edx,%edx
  801363:	89 f0                	mov    %esi,%eax
  801365:	f7 f1                	div    %ecx
  801367:	89 c6                	mov    %eax,%esi
  801369:	89 e8                	mov    %ebp,%eax
  80136b:	89 f7                	mov    %esi,%edi
  80136d:	f7 f1                	div    %ecx
  80136f:	89 fa                	mov    %edi,%edx
  801371:	83 c4 1c             	add    $0x1c,%esp
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5f                   	pop    %edi
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    
  801379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801380:	89 f9                	mov    %edi,%ecx
  801382:	ba 20 00 00 00       	mov    $0x20,%edx
  801387:	29 fa                	sub    %edi,%edx
  801389:	d3 e0                	shl    %cl,%eax
  80138b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80138f:	89 d1                	mov    %edx,%ecx
  801391:	89 d8                	mov    %ebx,%eax
  801393:	d3 e8                	shr    %cl,%eax
  801395:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801399:	09 c1                	or     %eax,%ecx
  80139b:	89 f0                	mov    %esi,%eax
  80139d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a1:	89 f9                	mov    %edi,%ecx
  8013a3:	d3 e3                	shl    %cl,%ebx
  8013a5:	89 d1                	mov    %edx,%ecx
  8013a7:	d3 e8                	shr    %cl,%eax
  8013a9:	89 f9                	mov    %edi,%ecx
  8013ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013af:	89 eb                	mov    %ebp,%ebx
  8013b1:	d3 e6                	shl    %cl,%esi
  8013b3:	89 d1                	mov    %edx,%ecx
  8013b5:	d3 eb                	shr    %cl,%ebx
  8013b7:	09 f3                	or     %esi,%ebx
  8013b9:	89 c6                	mov    %eax,%esi
  8013bb:	89 f2                	mov    %esi,%edx
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	f7 74 24 08          	divl   0x8(%esp)
  8013c3:	89 d6                	mov    %edx,%esi
  8013c5:	89 c3                	mov    %eax,%ebx
  8013c7:	f7 64 24 0c          	mull   0xc(%esp)
  8013cb:	39 d6                	cmp    %edx,%esi
  8013cd:	72 19                	jb     8013e8 <__udivdi3+0x108>
  8013cf:	89 f9                	mov    %edi,%ecx
  8013d1:	d3 e5                	shl    %cl,%ebp
  8013d3:	39 c5                	cmp    %eax,%ebp
  8013d5:	73 04                	jae    8013db <__udivdi3+0xfb>
  8013d7:	39 d6                	cmp    %edx,%esi
  8013d9:	74 0d                	je     8013e8 <__udivdi3+0x108>
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	31 ff                	xor    %edi,%edi
  8013df:	e9 3c ff ff ff       	jmp    801320 <__udivdi3+0x40>
  8013e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013eb:	31 ff                	xor    %edi,%edi
  8013ed:	e9 2e ff ff ff       	jmp    801320 <__udivdi3+0x40>
  8013f2:	66 90                	xchg   %ax,%ax
  8013f4:	66 90                	xchg   %ax,%ax
  8013f6:	66 90                	xchg   %ax,%ax
  8013f8:	66 90                	xchg   %ax,%ax
  8013fa:	66 90                	xchg   %ax,%ax
  8013fc:	66 90                	xchg   %ax,%ax
  8013fe:	66 90                	xchg   %ax,%ax

00801400 <__umoddi3>:
  801400:	f3 0f 1e fb          	endbr32 
  801404:	55                   	push   %ebp
  801405:	57                   	push   %edi
  801406:	56                   	push   %esi
  801407:	53                   	push   %ebx
  801408:	83 ec 1c             	sub    $0x1c,%esp
  80140b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80140f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801413:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801417:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80141b:	89 f0                	mov    %esi,%eax
  80141d:	89 da                	mov    %ebx,%edx
  80141f:	85 ff                	test   %edi,%edi
  801421:	75 15                	jne    801438 <__umoddi3+0x38>
  801423:	39 dd                	cmp    %ebx,%ebp
  801425:	76 39                	jbe    801460 <__umoddi3+0x60>
  801427:	f7 f5                	div    %ebp
  801429:	89 d0                	mov    %edx,%eax
  80142b:	31 d2                	xor    %edx,%edx
  80142d:	83 c4 1c             	add    $0x1c,%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
  801435:	8d 76 00             	lea    0x0(%esi),%esi
  801438:	39 df                	cmp    %ebx,%edi
  80143a:	77 f1                	ja     80142d <__umoddi3+0x2d>
  80143c:	0f bd cf             	bsr    %edi,%ecx
  80143f:	83 f1 1f             	xor    $0x1f,%ecx
  801442:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801446:	75 40                	jne    801488 <__umoddi3+0x88>
  801448:	39 df                	cmp    %ebx,%edi
  80144a:	72 04                	jb     801450 <__umoddi3+0x50>
  80144c:	39 f5                	cmp    %esi,%ebp
  80144e:	77 dd                	ja     80142d <__umoddi3+0x2d>
  801450:	89 da                	mov    %ebx,%edx
  801452:	89 f0                	mov    %esi,%eax
  801454:	29 e8                	sub    %ebp,%eax
  801456:	19 fa                	sbb    %edi,%edx
  801458:	eb d3                	jmp    80142d <__umoddi3+0x2d>
  80145a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801460:	89 e9                	mov    %ebp,%ecx
  801462:	85 ed                	test   %ebp,%ebp
  801464:	75 0b                	jne    801471 <__umoddi3+0x71>
  801466:	b8 01 00 00 00       	mov    $0x1,%eax
  80146b:	31 d2                	xor    %edx,%edx
  80146d:	f7 f5                	div    %ebp
  80146f:	89 c1                	mov    %eax,%ecx
  801471:	89 d8                	mov    %ebx,%eax
  801473:	31 d2                	xor    %edx,%edx
  801475:	f7 f1                	div    %ecx
  801477:	89 f0                	mov    %esi,%eax
  801479:	f7 f1                	div    %ecx
  80147b:	89 d0                	mov    %edx,%eax
  80147d:	31 d2                	xor    %edx,%edx
  80147f:	eb ac                	jmp    80142d <__umoddi3+0x2d>
  801481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801488:	8b 44 24 04          	mov    0x4(%esp),%eax
  80148c:	ba 20 00 00 00       	mov    $0x20,%edx
  801491:	29 c2                	sub    %eax,%edx
  801493:	89 c1                	mov    %eax,%ecx
  801495:	89 e8                	mov    %ebp,%eax
  801497:	d3 e7                	shl    %cl,%edi
  801499:	89 d1                	mov    %edx,%ecx
  80149b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80149f:	d3 e8                	shr    %cl,%eax
  8014a1:	89 c1                	mov    %eax,%ecx
  8014a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8014a7:	09 f9                	or     %edi,%ecx
  8014a9:	89 df                	mov    %ebx,%edi
  8014ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014af:	89 c1                	mov    %eax,%ecx
  8014b1:	d3 e5                	shl    %cl,%ebp
  8014b3:	89 d1                	mov    %edx,%ecx
  8014b5:	d3 ef                	shr    %cl,%edi
  8014b7:	89 c1                	mov    %eax,%ecx
  8014b9:	89 f0                	mov    %esi,%eax
  8014bb:	d3 e3                	shl    %cl,%ebx
  8014bd:	89 d1                	mov    %edx,%ecx
  8014bf:	89 fa                	mov    %edi,%edx
  8014c1:	d3 e8                	shr    %cl,%eax
  8014c3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8014c8:	09 d8                	or     %ebx,%eax
  8014ca:	f7 74 24 08          	divl   0x8(%esp)
  8014ce:	89 d3                	mov    %edx,%ebx
  8014d0:	d3 e6                	shl    %cl,%esi
  8014d2:	f7 e5                	mul    %ebp
  8014d4:	89 c7                	mov    %eax,%edi
  8014d6:	89 d1                	mov    %edx,%ecx
  8014d8:	39 d3                	cmp    %edx,%ebx
  8014da:	72 06                	jb     8014e2 <__umoddi3+0xe2>
  8014dc:	75 0e                	jne    8014ec <__umoddi3+0xec>
  8014de:	39 c6                	cmp    %eax,%esi
  8014e0:	73 0a                	jae    8014ec <__umoddi3+0xec>
  8014e2:	29 e8                	sub    %ebp,%eax
  8014e4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8014e8:	89 d1                	mov    %edx,%ecx
  8014ea:	89 c7                	mov    %eax,%edi
  8014ec:	89 f5                	mov    %esi,%ebp
  8014ee:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014f2:	29 fd                	sub    %edi,%ebp
  8014f4:	19 cb                	sbb    %ecx,%ebx
  8014f6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8014fb:	89 d8                	mov    %ebx,%eax
  8014fd:	d3 e0                	shl    %cl,%eax
  8014ff:	89 f1                	mov    %esi,%ecx
  801501:	d3 ed                	shr    %cl,%ebp
  801503:	d3 eb                	shr    %cl,%ebx
  801505:	09 e8                	or     %ebp,%eax
  801507:	89 da                	mov    %ebx,%edx
  801509:	83 c4 1c             	add    $0x1c,%esp
  80150c:	5b                   	pop    %ebx
  80150d:	5e                   	pop    %esi
  80150e:	5f                   	pop    %edi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    
