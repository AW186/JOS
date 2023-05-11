
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 bf 12 00 00       	call   80130f <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4c                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5e                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 d7 11 00 00       	call   801241 <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 57                	jle    8000c8 <num+0x95>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	83 c0 01             	add    $0x1,%eax
  800082:	a3 00 40 80 00       	mov    %eax,0x804000
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	50                   	push   %eax
  80008b:	68 c0 20 80 00       	push   $0x8020c0
  800090:	e8 ef 17 00 00       	call   801884 <printf>
			bol = 0;
  800095:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009c:	00 00 00 
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	push   0xc(%ebp)
  8000ab:	68 c5 20 80 00       	push   $0x8020c5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 e0 20 80 00       	push   $0x8020e0
  8000b7:	e8 1d 01 00 00       	call   8001d9 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb 96                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	push   0xc(%ebp)
  8000d8:	68 eb 20 80 00       	push   $0x8020eb
  8000dd:	6a 18                	push   $0x18
  8000df:	68 e0 20 80 00       	push   $0x8020e0
  8000e4:	e8 f0 00 00 00       	call   8001d9 <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 00 	movl   $0x802100,0x803004
  8000f9:	21 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 0d                	je     80010f <umain+0x26>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 70 04             	lea    0x4(%eax),%esi
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	eb 3b                	jmp    80014a <umain+0x61>
		num(0, "<stdin>");
  80010f:	83 ec 08             	sub    $0x8,%esp
  800112:	68 04 21 80 00       	push   $0x802104
  800117:	6a 00                	push   $0x0
  800119:	e8 15 ff ff ff       	call   800033 <num>
  80011e:	83 c4 10             	add    $0x10,%esp
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  800121:	e8 a1 00 00 00       	call   8001c7 <exit>
}
  800126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5f                   	pop    %edi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    
				num(f, argv[i]);
  80012e:	83 ec 08             	sub    $0x8,%esp
  800131:	ff 36                	push   (%esi)
  800133:	50                   	push   %eax
  800134:	e8 fa fe ff ff       	call   800033 <num>
				close(f);
  800139:	89 1c 24             	mov    %ebx,(%esp)
  80013c:	e8 c4 0f 00 00       	call   801105 <close>
		for (i = 1; i < argc; i++) {
  800141:	83 c7 01             	add    $0x1,%edi
  800144:	83 c6 04             	add    $0x4,%esi
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	3b 7d 08             	cmp    0x8(%ebp),%edi
  80014d:	7d d2                	jge    800121 <umain+0x38>
			f = open(argv[i], O_RDONLY);
  80014f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800152:	83 ec 08             	sub    $0x8,%esp
  800155:	6a 00                	push   $0x0
  800157:	ff 36                	push   (%esi)
  800159:	e8 84 15 00 00       	call   8016e2 <open>
  80015e:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	85 c0                	test   %eax,%eax
  800165:	79 c7                	jns    80012e <umain+0x45>
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	push   (%eax)
  800170:	68 0c 21 80 00       	push   $0x80210c
  800175:	6a 27                	push   $0x27
  800177:	68 e0 20 80 00       	push   $0x8020e0
  80017c:	e8 58 00 00 00       	call   8001d9 <_panic>

00800181 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800189:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018c:	e8 a6 0b 00 00       	call   800d37 <sys_getenvid>
  800191:	25 ff 03 00 00       	and    $0x3ff,%eax
  800196:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800199:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80019e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a3:	85 db                	test   %ebx,%ebx
  8001a5:	7e 07                	jle    8001ae <libmain+0x2d>
		binaryname = argv[0];
  8001a7:	8b 06                	mov    (%esi),%eax
  8001a9:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	e8 31 ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001b8:	e8 0a 00 00 00       	call   8001c7 <exit>
}
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001cd:	6a 00                	push   $0x0
  8001cf:	e8 22 0b 00 00       	call   800cf6 <sys_env_destroy>
}
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001e7:	e8 4b 0b 00 00       	call   800d37 <sys_getenvid>
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 0c             	push   0xc(%ebp)
  8001f2:	ff 75 08             	push   0x8(%ebp)
  8001f5:	56                   	push   %esi
  8001f6:	50                   	push   %eax
  8001f7:	68 28 21 80 00       	push   $0x802128
  8001fc:	e8 b3 00 00 00       	call   8002b4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800201:	83 c4 18             	add    $0x18,%esp
  800204:	53                   	push   %ebx
  800205:	ff 75 10             	push   0x10(%ebp)
  800208:	e8 56 00 00 00       	call   800263 <vcprintf>
	cprintf("\n");
  80020d:	c7 04 24 64 25 80 00 	movl   $0x802564,(%esp)
  800214:	e8 9b 00 00 00       	call   8002b4 <cprintf>
  800219:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021c:	cc                   	int3   
  80021d:	eb fd                	jmp    80021c <_panic+0x43>

0080021f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	53                   	push   %ebx
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800229:	8b 13                	mov    (%ebx),%edx
  80022b:	8d 42 01             	lea    0x1(%edx),%eax
  80022e:	89 03                	mov    %eax,(%ebx)
  800230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800233:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800237:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023c:	74 09                	je     800247 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80023e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800245:	c9                   	leave  
  800246:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	68 ff 00 00 00       	push   $0xff
  80024f:	8d 43 08             	lea    0x8(%ebx),%eax
  800252:	50                   	push   %eax
  800253:	e8 61 0a 00 00       	call   800cb9 <sys_cputs>
		b->idx = 0;
  800258:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	eb db                	jmp    80023e <putch+0x1f>

00800263 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800273:	00 00 00 
	b.cnt = 0;
  800276:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800280:	ff 75 0c             	push   0xc(%ebp)
  800283:	ff 75 08             	push   0x8(%ebp)
  800286:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	68 1f 02 80 00       	push   $0x80021f
  800292:	e8 14 01 00 00       	call   8003ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800297:	83 c4 08             	add    $0x8,%esp
  80029a:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8002a0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a6:	50                   	push   %eax
  8002a7:	e8 0d 0a 00 00       	call   800cb9 <sys_cputs>

	return b.cnt;
}
  8002ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bd:	50                   	push   %eax
  8002be:	ff 75 08             	push   0x8(%ebp)
  8002c1:	e8 9d ff ff ff       	call   800263 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	57                   	push   %edi
  8002cc:	56                   	push   %esi
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 1c             	sub    $0x1c,%esp
  8002d1:	89 c7                	mov    %eax,%edi
  8002d3:	89 d6                	mov    %edx,%esi
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002db:	89 d1                	mov    %edx,%ecx
  8002dd:	89 c2                	mov    %eax,%edx
  8002df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002fa:	72 3e                	jb     80033a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	ff 75 18             	push   0x18(%ebp)
  800302:	83 eb 01             	sub    $0x1,%ebx
  800305:	53                   	push   %ebx
  800306:	50                   	push   %eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 e4             	push   -0x1c(%ebp)
  80030d:	ff 75 e0             	push   -0x20(%ebp)
  800310:	ff 75 dc             	push   -0x24(%ebp)
  800313:	ff 75 d8             	push   -0x28(%ebp)
  800316:	e8 55 1b 00 00       	call   801e70 <__udivdi3>
  80031b:	83 c4 18             	add    $0x18,%esp
  80031e:	52                   	push   %edx
  80031f:	50                   	push   %eax
  800320:	89 f2                	mov    %esi,%edx
  800322:	89 f8                	mov    %edi,%eax
  800324:	e8 9f ff ff ff       	call   8002c8 <printnum>
  800329:	83 c4 20             	add    $0x20,%esp
  80032c:	eb 13                	jmp    800341 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	56                   	push   %esi
  800332:	ff 75 18             	push   0x18(%ebp)
  800335:	ff d7                	call   *%edi
  800337:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80033a:	83 eb 01             	sub    $0x1,%ebx
  80033d:	85 db                	test   %ebx,%ebx
  80033f:	7f ed                	jg     80032e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	56                   	push   %esi
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	ff 75 e4             	push   -0x1c(%ebp)
  80034b:	ff 75 e0             	push   -0x20(%ebp)
  80034e:	ff 75 dc             	push   -0x24(%ebp)
  800351:	ff 75 d8             	push   -0x28(%ebp)
  800354:	e8 37 1c 00 00       	call   801f90 <__umoddi3>
  800359:	83 c4 14             	add    $0x14,%esp
  80035c:	0f be 80 4b 21 80 00 	movsbl 0x80214b(%eax),%eax
  800363:	50                   	push   %eax
  800364:	ff d7                	call   *%edi
}
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036c:	5b                   	pop    %ebx
  80036d:	5e                   	pop    %esi
  80036e:	5f                   	pop    %edi
  80036f:	5d                   	pop    %ebp
  800370:	c3                   	ret    

00800371 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800377:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037b:	8b 10                	mov    (%eax),%edx
  80037d:	3b 50 04             	cmp    0x4(%eax),%edx
  800380:	73 0a                	jae    80038c <sprintputch+0x1b>
		*b->buf++ = ch;
  800382:	8d 4a 01             	lea    0x1(%edx),%ecx
  800385:	89 08                	mov    %ecx,(%eax)
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	88 02                	mov    %al,(%edx)
}
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <printfmt>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800394:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800397:	50                   	push   %eax
  800398:	ff 75 10             	push   0x10(%ebp)
  80039b:	ff 75 0c             	push   0xc(%ebp)
  80039e:	ff 75 08             	push   0x8(%ebp)
  8003a1:	e8 05 00 00 00       	call   8003ab <vprintfmt>
}
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <vprintfmt>:
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	57                   	push   %edi
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 3c             	sub    $0x3c,%esp
  8003b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ba:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003bd:	eb 0a                	jmp    8003c9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	53                   	push   %ebx
  8003c3:	50                   	push   %eax
  8003c4:	ff d6                	call   *%esi
  8003c6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c9:	83 c7 01             	add    $0x1,%edi
  8003cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003d0:	83 f8 25             	cmp    $0x25,%eax
  8003d3:	74 0c                	je     8003e1 <vprintfmt+0x36>
			if (ch == '\0')
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	75 e6                	jne    8003bf <vprintfmt+0x14>
}
  8003d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003dc:	5b                   	pop    %ebx
  8003dd:	5e                   	pop    %esi
  8003de:	5f                   	pop    %edi
  8003df:	5d                   	pop    %ebp
  8003e0:	c3                   	ret    
		padc = ' ';
  8003e1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003e5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8003f3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003fa:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8d 47 01             	lea    0x1(%edi),%eax
  800402:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800405:	0f b6 17             	movzbl (%edi),%edx
  800408:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040b:	3c 55                	cmp    $0x55,%al
  80040d:	0f 87 a6 04 00 00    	ja     8008b9 <vprintfmt+0x50e>
  800413:	0f b6 c0             	movzbl %al,%eax
  800416:	ff 24 85 80 22 80 00 	jmp    *0x802280(,%eax,4)
  80041d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800420:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800424:	eb d9                	jmp    8003ff <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800429:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80042d:	eb d0                	jmp    8003ff <vprintfmt+0x54>
  80042f:	0f b6 d2             	movzbl %dl,%edx
  800432:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
  80043a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80043d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800440:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800444:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800447:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044a:	83 f9 09             	cmp    $0x9,%ecx
  80044d:	77 55                	ja     8004a4 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80044f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800452:	eb e9                	jmp    80043d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	8d 40 04             	lea    0x4(%eax),%eax
  800462:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046c:	79 91                	jns    8003ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800474:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80047b:	eb 82                	jmp    8003ff <vprintfmt+0x54>
  80047d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	b8 00 00 00 00       	mov    $0x0,%eax
  800487:	0f 49 c2             	cmovns %edx,%eax
  80048a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800490:	e9 6a ff ff ff       	jmp    8003ff <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800495:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800498:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80049f:	e9 5b ff ff ff       	jmp    8003ff <vprintfmt+0x54>
  8004a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004aa:	eb bc                	jmp    800468 <vprintfmt+0xbd>
			lflag++;
  8004ac:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004b2:	e9 48 ff ff ff       	jmp    8003ff <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 78 04             	lea    0x4(%eax),%edi
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	53                   	push   %ebx
  8004c1:	ff 30                	push   (%eax)
  8004c3:	ff d6                	call   *%esi
			break;
  8004c5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004c8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004cb:	e9 88 03 00 00       	jmp    800858 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 78 04             	lea    0x4(%eax),%edi
  8004d6:	8b 10                	mov    (%eax),%edx
  8004d8:	89 d0                	mov    %edx,%eax
  8004da:	f7 d8                	neg    %eax
  8004dc:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004df:	83 f8 0f             	cmp    $0xf,%eax
  8004e2:	7f 23                	jg     800507 <vprintfmt+0x15c>
  8004e4:	8b 14 85 e0 23 80 00 	mov    0x8023e0(,%eax,4),%edx
  8004eb:	85 d2                	test   %edx,%edx
  8004ed:	74 18                	je     800507 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8004ef:	52                   	push   %edx
  8004f0:	68 11 25 80 00       	push   $0x802511
  8004f5:	53                   	push   %ebx
  8004f6:	56                   	push   %esi
  8004f7:	e8 92 fe ff ff       	call   80038e <printfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ff:	89 7d 14             	mov    %edi,0x14(%ebp)
  800502:	e9 51 03 00 00       	jmp    800858 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800507:	50                   	push   %eax
  800508:	68 63 21 80 00       	push   $0x802163
  80050d:	53                   	push   %ebx
  80050e:	56                   	push   %esi
  80050f:	e8 7a fe ff ff       	call   80038e <printfmt>
  800514:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800517:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051a:	e9 39 03 00 00       	jmp    800858 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	83 c0 04             	add    $0x4,%eax
  800525:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80052d:	85 d2                	test   %edx,%edx
  80052f:	b8 5c 21 80 00       	mov    $0x80215c,%eax
  800534:	0f 45 c2             	cmovne %edx,%eax
  800537:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80053a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80053e:	7e 06                	jle    800546 <vprintfmt+0x19b>
  800540:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800544:	75 0d                	jne    800553 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800546:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800549:	89 c7                	mov    %eax,%edi
  80054b:	03 45 d4             	add    -0x2c(%ebp),%eax
  80054e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800551:	eb 55                	jmp    8005a8 <vprintfmt+0x1fd>
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	ff 75 e0             	push   -0x20(%ebp)
  800559:	ff 75 cc             	push   -0x34(%ebp)
  80055c:	e8 f5 03 00 00       	call   800956 <strnlen>
  800561:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800564:	29 c2                	sub    %eax,%edx
  800566:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80056e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800572:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800575:	eb 0f                	jmp    800586 <vprintfmt+0x1db>
					putch(padc, putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	53                   	push   %ebx
  80057b:	ff 75 d4             	push   -0x2c(%ebp)
  80057e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800580:	83 ef 01             	sub    $0x1,%edi
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	85 ff                	test   %edi,%edi
  800588:	7f ed                	jg     800577 <vprintfmt+0x1cc>
  80058a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80058d:	85 d2                	test   %edx,%edx
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	0f 49 c2             	cmovns %edx,%eax
  800597:	29 c2                	sub    %eax,%edx
  800599:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80059c:	eb a8                	jmp    800546 <vprintfmt+0x19b>
					putch(ch, putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	52                   	push   %edx
  8005a3:	ff d6                	call   *%esi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ab:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ad:	83 c7 01             	add    $0x1,%edi
  8005b0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b4:	0f be d0             	movsbl %al,%edx
  8005b7:	85 d2                	test   %edx,%edx
  8005b9:	74 4b                	je     800606 <vprintfmt+0x25b>
  8005bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bf:	78 06                	js     8005c7 <vprintfmt+0x21c>
  8005c1:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005c5:	78 1e                	js     8005e5 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005cb:	74 d1                	je     80059e <vprintfmt+0x1f3>
  8005cd:	0f be c0             	movsbl %al,%eax
  8005d0:	83 e8 20             	sub    $0x20,%eax
  8005d3:	83 f8 5e             	cmp    $0x5e,%eax
  8005d6:	76 c6                	jbe    80059e <vprintfmt+0x1f3>
					putch('?', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 3f                	push   $0x3f
  8005de:	ff d6                	call   *%esi
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	eb c3                	jmp    8005a8 <vprintfmt+0x1fd>
  8005e5:	89 cf                	mov    %ecx,%edi
  8005e7:	eb 0e                	jmp    8005f7 <vprintfmt+0x24c>
				putch(' ', putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	53                   	push   %ebx
  8005ed:	6a 20                	push   $0x20
  8005ef:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005f1:	83 ef 01             	sub    $0x1,%edi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	85 ff                	test   %edi,%edi
  8005f9:	7f ee                	jg     8005e9 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800601:	e9 52 02 00 00       	jmp    800858 <vprintfmt+0x4ad>
  800606:	89 cf                	mov    %ecx,%edi
  800608:	eb ed                	jmp    8005f7 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800618:	85 d2                	test   %edx,%edx
  80061a:	b8 5c 21 80 00       	mov    $0x80215c,%eax
  80061f:	0f 45 c2             	cmovne %edx,%eax
  800622:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800625:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800629:	7e 06                	jle    800631 <vprintfmt+0x286>
  80062b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80062f:	75 0d                	jne    80063e <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800634:	89 c7                	mov    %eax,%edi
  800636:	03 45 d4             	add    -0x2c(%ebp),%eax
  800639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80063c:	eb 55                	jmp    800693 <vprintfmt+0x2e8>
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 e0             	push   -0x20(%ebp)
  800644:	ff 75 cc             	push   -0x34(%ebp)
  800647:	e8 0a 03 00 00       	call   800956 <strnlen>
  80064c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064f:	29 c2                	sub    %eax,%edx
  800651:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800659:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80065d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800660:	eb 0f                	jmp    800671 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	ff 75 d4             	push   -0x2c(%ebp)
  800669:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80066b:	83 ef 01             	sub    $0x1,%edi
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	85 ff                	test   %edi,%edi
  800673:	7f ed                	jg     800662 <vprintfmt+0x2b7>
  800675:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800678:	85 d2                	test   %edx,%edx
  80067a:	b8 00 00 00 00       	mov    $0x0,%eax
  80067f:	0f 49 c2             	cmovns %edx,%eax
  800682:	29 c2                	sub    %eax,%edx
  800684:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800687:	eb a8                	jmp    800631 <vprintfmt+0x286>
					putch(ch, putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	52                   	push   %edx
  80068e:	ff d6                	call   *%esi
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800696:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800698:	83 c7 01             	add    $0x1,%edi
  80069b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069f:	0f be d0             	movsbl %al,%edx
  8006a2:	3c 3a                	cmp    $0x3a,%al
  8006a4:	74 4b                	je     8006f1 <vprintfmt+0x346>
  8006a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006aa:	78 06                	js     8006b2 <vprintfmt+0x307>
  8006ac:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8006b0:	78 1e                	js     8006d0 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b6:	74 d1                	je     800689 <vprintfmt+0x2de>
  8006b8:	0f be c0             	movsbl %al,%eax
  8006bb:	83 e8 20             	sub    $0x20,%eax
  8006be:	83 f8 5e             	cmp    $0x5e,%eax
  8006c1:	76 c6                	jbe    800689 <vprintfmt+0x2de>
					putch('?', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 3f                	push   $0x3f
  8006c9:	ff d6                	call   *%esi
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	eb c3                	jmp    800693 <vprintfmt+0x2e8>
  8006d0:	89 cf                	mov    %ecx,%edi
  8006d2:	eb 0e                	jmp    8006e2 <vprintfmt+0x337>
				putch(' ', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 20                	push   $0x20
  8006da:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006dc:	83 ef 01             	sub    $0x1,%edi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	85 ff                	test   %edi,%edi
  8006e4:	7f ee                	jg     8006d4 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	e9 67 01 00 00       	jmp    800858 <vprintfmt+0x4ad>
  8006f1:	89 cf                	mov    %ecx,%edi
  8006f3:	eb ed                	jmp    8006e2 <vprintfmt+0x337>
	if (lflag >= 2)
  8006f5:	83 f9 01             	cmp    $0x1,%ecx
  8006f8:	7f 1b                	jg     800715 <vprintfmt+0x36a>
	else if (lflag)
  8006fa:	85 c9                	test   %ecx,%ecx
  8006fc:	74 63                	je     800761 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800706:	99                   	cltd   
  800707:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
  800713:	eb 17                	jmp    80072c <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 50 04             	mov    0x4(%eax),%edx
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800720:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 08             	lea    0x8(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80072c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800732:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800737:	85 c9                	test   %ecx,%ecx
  800739:	0f 89 ff 00 00 00    	jns    80083e <vprintfmt+0x493>
				putch('-', putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	53                   	push   %ebx
  800743:	6a 2d                	push   $0x2d
  800745:	ff d6                	call   *%esi
				num = -(long long) num;
  800747:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80074a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80074d:	f7 da                	neg    %edx
  80074f:	83 d1 00             	adc    $0x0,%ecx
  800752:	f7 d9                	neg    %ecx
  800754:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800757:	bf 0a 00 00 00       	mov    $0xa,%edi
  80075c:	e9 dd 00 00 00       	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800769:	99                   	cltd   
  80076a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
  800776:	eb b4                	jmp    80072c <vprintfmt+0x381>
	if (lflag >= 2)
  800778:	83 f9 01             	cmp    $0x1,%ecx
  80077b:	7f 1e                	jg     80079b <vprintfmt+0x3f0>
	else if (lflag)
  80077d:	85 c9                	test   %ecx,%ecx
  80077f:	74 32                	je     8007b3 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 10                	mov    (%eax),%edx
  800786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800791:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800796:	e9 a3 00 00 00       	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 10                	mov    (%eax),%edx
  8007a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a3:	8d 40 08             	lea    0x8(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a9:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8007ae:	e9 8b 00 00 00       	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 10                	mov    (%eax),%edx
  8007b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8007c8:	eb 74                	jmp    80083e <vprintfmt+0x493>
	if (lflag >= 2)
  8007ca:	83 f9 01             	cmp    $0x1,%ecx
  8007cd:	7f 1b                	jg     8007ea <vprintfmt+0x43f>
	else if (lflag)
  8007cf:	85 c9                	test   %ecx,%ecx
  8007d1:	74 2c                	je     8007ff <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 10                	mov    (%eax),%edx
  8007d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e3:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8007e8:	eb 54                	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 10                	mov    (%eax),%edx
  8007ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f8:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8007fd:	eb 3f                	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
  800809:	8d 40 04             	lea    0x4(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800814:	eb 28                	jmp    80083e <vprintfmt+0x493>
			putch('0', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 30                	push   $0x30
  80081c:	ff d6                	call   *%esi
			putch('x', putdat);
  80081e:	83 c4 08             	add    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 78                	push   $0x78
  800824:	ff d6                	call   *%esi
			num = (unsigned long long)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800830:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800839:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80083e:	83 ec 0c             	sub    $0xc,%esp
  800841:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	ff 75 d4             	push   -0x2c(%ebp)
  800849:	57                   	push   %edi
  80084a:	51                   	push   %ecx
  80084b:	52                   	push   %edx
  80084c:	89 da                	mov    %ebx,%edx
  80084e:	89 f0                	mov    %esi,%eax
  800850:	e8 73 fa ff ff       	call   8002c8 <printnum>
			break;
  800855:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085b:	e9 69 fb ff ff       	jmp    8003c9 <vprintfmt+0x1e>
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7f 1b                	jg     800880 <vprintfmt+0x4d5>
	else if (lflag)
  800865:	85 c9                	test   %ecx,%ecx
  800867:	74 2c                	je     800895 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8b 10                	mov    (%eax),%edx
  80086e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800873:	8d 40 04             	lea    0x4(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800879:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  80087e:	eb be                	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 10                	mov    (%eax),%edx
  800885:	8b 48 04             	mov    0x4(%eax),%ecx
  800888:	8d 40 08             	lea    0x8(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088e:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800893:	eb a9                	jmp    80083e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 10                	mov    (%eax),%edx
  80089a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a5:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8008aa:	eb 92                	jmp    80083e <vprintfmt+0x493>
			putch(ch, putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	53                   	push   %ebx
  8008b0:	6a 25                	push   $0x25
  8008b2:	ff d6                	call   *%esi
			break;
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	eb 9f                	jmp    800858 <vprintfmt+0x4ad>
			putch('%', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 25                	push   $0x25
  8008bf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	89 f8                	mov    %edi,%eax
  8008c6:	eb 03                	jmp    8008cb <vprintfmt+0x520>
  8008c8:	83 e8 01             	sub    $0x1,%eax
  8008cb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008cf:	75 f7                	jne    8008c8 <vprintfmt+0x51d>
  8008d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d4:	eb 82                	jmp    800858 <vprintfmt+0x4ad>

008008d6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	74 26                	je     80091d <vsnprintf+0x47>
  8008f7:	85 d2                	test   %edx,%edx
  8008f9:	7e 22                	jle    80091d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fb:	ff 75 14             	push   0x14(%ebp)
  8008fe:	ff 75 10             	push   0x10(%ebp)
  800901:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800904:	50                   	push   %eax
  800905:	68 71 03 80 00       	push   $0x800371
  80090a:	e8 9c fa ff ff       	call   8003ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80090f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800912:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800918:	83 c4 10             	add    $0x10,%esp
}
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    
		return -E_INVAL;
  80091d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800922:	eb f7                	jmp    80091b <vsnprintf+0x45>

00800924 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80092d:	50                   	push   %eax
  80092e:	ff 75 10             	push   0x10(%ebp)
  800931:	ff 75 0c             	push   0xc(%ebp)
  800934:	ff 75 08             	push   0x8(%ebp)
  800937:	e8 9a ff ff ff       	call   8008d6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	eb 03                	jmp    80094e <strlen+0x10>
		n++;
  80094b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80094e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800952:	75 f7                	jne    80094b <strlen+0xd>
	return n;
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	eb 03                	jmp    800969 <strnlen+0x13>
		n++;
  800966:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800969:	39 d0                	cmp    %edx,%eax
  80096b:	74 08                	je     800975 <strnlen+0x1f>
  80096d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800971:	75 f3                	jne    800966 <strnlen+0x10>
  800973:	89 c2                	mov    %eax,%edx
	return n;
}
  800975:	89 d0                	mov    %edx,%eax
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	53                   	push   %ebx
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
  800988:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80098c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	84 d2                	test   %dl,%dl
  800994:	75 f2                	jne    800988 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800996:	89 c8                	mov    %ecx,%eax
  800998:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	53                   	push   %ebx
  8009a1:	83 ec 10             	sub    $0x10,%esp
  8009a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a7:	53                   	push   %ebx
  8009a8:	e8 91 ff ff ff       	call   80093e <strlen>
  8009ad:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009b0:	ff 75 0c             	push   0xc(%ebp)
  8009b3:	01 d8                	add    %ebx,%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 be ff ff ff       	call   800979 <strcpy>
	return dst;
}
  8009bb:	89 d8                	mov    %ebx,%eax
  8009bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	56                   	push   %esi
  8009c6:	53                   	push   %ebx
  8009c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	89 f3                	mov    %esi,%ebx
  8009cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d2:	89 f0                	mov    %esi,%eax
  8009d4:	eb 0f                	jmp    8009e5 <strncpy+0x23>
		*dst++ = *src;
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	0f b6 0a             	movzbl (%edx),%ecx
  8009dc:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009df:	80 f9 01             	cmp    $0x1,%cl
  8009e2:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8009e5:	39 d8                	cmp    %ebx,%eax
  8009e7:	75 ed                	jne    8009d6 <strncpy+0x14>
	}
	return ret;
}
  8009e9:	89 f0                	mov    %esi,%eax
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fa:	8b 55 10             	mov    0x10(%ebp),%edx
  8009fd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ff:	85 d2                	test   %edx,%edx
  800a01:	74 21                	je     800a24 <strlcpy+0x35>
  800a03:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a07:	89 f2                	mov    %esi,%edx
  800a09:	eb 09                	jmp    800a14 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a0b:	83 c1 01             	add    $0x1,%ecx
  800a0e:	83 c2 01             	add    $0x1,%edx
  800a11:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a14:	39 c2                	cmp    %eax,%edx
  800a16:	74 09                	je     800a21 <strlcpy+0x32>
  800a18:	0f b6 19             	movzbl (%ecx),%ebx
  800a1b:	84 db                	test   %bl,%bl
  800a1d:	75 ec                	jne    800a0b <strlcpy+0x1c>
  800a1f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a24:	29 f0                	sub    %esi,%eax
}
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a33:	eb 06                	jmp    800a3b <strcmp+0x11>
		p++, q++;
  800a35:	83 c1 01             	add    $0x1,%ecx
  800a38:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a3b:	0f b6 01             	movzbl (%ecx),%eax
  800a3e:	84 c0                	test   %al,%al
  800a40:	74 04                	je     800a46 <strcmp+0x1c>
  800a42:	3a 02                	cmp    (%edx),%al
  800a44:	74 ef                	je     800a35 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a46:	0f b6 c0             	movzbl %al,%eax
  800a49:	0f b6 12             	movzbl (%edx),%edx
  800a4c:	29 d0                	sub    %edx,%eax
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	89 c3                	mov    %eax,%ebx
  800a5c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a5f:	eb 06                	jmp    800a67 <strncmp+0x17>
		n--, p++, q++;
  800a61:	83 c0 01             	add    $0x1,%eax
  800a64:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a67:	39 d8                	cmp    %ebx,%eax
  800a69:	74 18                	je     800a83 <strncmp+0x33>
  800a6b:	0f b6 08             	movzbl (%eax),%ecx
  800a6e:	84 c9                	test   %cl,%cl
  800a70:	74 04                	je     800a76 <strncmp+0x26>
  800a72:	3a 0a                	cmp    (%edx),%cl
  800a74:	74 eb                	je     800a61 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a76:	0f b6 00             	movzbl (%eax),%eax
  800a79:	0f b6 12             	movzbl (%edx),%edx
  800a7c:	29 d0                	sub    %edx,%eax
}
  800a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    
		return 0;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
  800a88:	eb f4                	jmp    800a7e <strncmp+0x2e>

00800a8a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a94:	eb 03                	jmp    800a99 <strchr+0xf>
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	0f b6 10             	movzbl (%eax),%edx
  800a9c:	84 d2                	test   %dl,%dl
  800a9e:	74 06                	je     800aa6 <strchr+0x1c>
		if (*s == c)
  800aa0:	38 ca                	cmp    %cl,%dl
  800aa2:	75 f2                	jne    800a96 <strchr+0xc>
  800aa4:	eb 05                	jmp    800aab <strchr+0x21>
			return (char *) s;
	return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aba:	38 ca                	cmp    %cl,%dl
  800abc:	74 09                	je     800ac7 <strfind+0x1a>
  800abe:	84 d2                	test   %dl,%dl
  800ac0:	74 05                	je     800ac7 <strfind+0x1a>
	for (; *s; s++)
  800ac2:	83 c0 01             	add    $0x1,%eax
  800ac5:	eb f0                	jmp    800ab7 <strfind+0xa>
			break;
	return (char *) s;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad5:	85 c9                	test   %ecx,%ecx
  800ad7:	74 2f                	je     800b08 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad9:	89 f8                	mov    %edi,%eax
  800adb:	09 c8                	or     %ecx,%eax
  800add:	a8 03                	test   $0x3,%al
  800adf:	75 21                	jne    800b02 <memset+0x39>
		c &= 0xFF;
  800ae1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae5:	89 d0                	mov    %edx,%eax
  800ae7:	c1 e0 08             	shl    $0x8,%eax
  800aea:	89 d3                	mov    %edx,%ebx
  800aec:	c1 e3 18             	shl    $0x18,%ebx
  800aef:	89 d6                	mov    %edx,%esi
  800af1:	c1 e6 10             	shl    $0x10,%esi
  800af4:	09 f3                	or     %esi,%ebx
  800af6:	09 da                	or     %ebx,%edx
  800af8:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800afa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800afd:	fc                   	cld    
  800afe:	f3 ab                	rep stos %eax,%es:(%edi)
  800b00:	eb 06                	jmp    800b08 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	fc                   	cld    
  800b06:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b08:	89 f8                	mov    %edi,%eax
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5f                   	pop    %edi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	57                   	push   %edi
  800b13:	56                   	push   %esi
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b1d:	39 c6                	cmp    %eax,%esi
  800b1f:	73 32                	jae    800b53 <memmove+0x44>
  800b21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b24:	39 c2                	cmp    %eax,%edx
  800b26:	76 2b                	jbe    800b53 <memmove+0x44>
		s += n;
		d += n;
  800b28:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2b:	89 d6                	mov    %edx,%esi
  800b2d:	09 fe                	or     %edi,%esi
  800b2f:	09 ce                	or     %ecx,%esi
  800b31:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b37:	75 0e                	jne    800b47 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b39:	83 ef 04             	sub    $0x4,%edi
  800b3c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b42:	fd                   	std    
  800b43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b45:	eb 09                	jmp    800b50 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b47:	83 ef 01             	sub    $0x1,%edi
  800b4a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b4d:	fd                   	std    
  800b4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b50:	fc                   	cld    
  800b51:	eb 1a                	jmp    800b6d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b53:	89 f2                	mov    %esi,%edx
  800b55:	09 c2                	or     %eax,%edx
  800b57:	09 ca                	or     %ecx,%edx
  800b59:	f6 c2 03             	test   $0x3,%dl
  800b5c:	75 0a                	jne    800b68 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b61:	89 c7                	mov    %eax,%edi
  800b63:	fc                   	cld    
  800b64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b66:	eb 05                	jmp    800b6d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b68:	89 c7                	mov    %eax,%edi
  800b6a:	fc                   	cld    
  800b6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b77:	ff 75 10             	push   0x10(%ebp)
  800b7a:	ff 75 0c             	push   0xc(%ebp)
  800b7d:	ff 75 08             	push   0x8(%ebp)
  800b80:	e8 8a ff ff ff       	call   800b0f <memmove>
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b92:	89 c6                	mov    %eax,%esi
  800b94:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b97:	eb 06                	jmp    800b9f <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b99:	83 c0 01             	add    $0x1,%eax
  800b9c:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b9f:	39 f0                	cmp    %esi,%eax
  800ba1:	74 14                	je     800bb7 <memcmp+0x30>
		if (*s1 != *s2)
  800ba3:	0f b6 08             	movzbl (%eax),%ecx
  800ba6:	0f b6 1a             	movzbl (%edx),%ebx
  800ba9:	38 d9                	cmp    %bl,%cl
  800bab:	74 ec                	je     800b99 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800bad:	0f b6 c1             	movzbl %cl,%eax
  800bb0:	0f b6 db             	movzbl %bl,%ebx
  800bb3:	29 d8                	sub    %ebx,%eax
  800bb5:	eb 05                	jmp    800bbc <memcmp+0x35>
	}

	return 0;
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc9:	89 c2                	mov    %eax,%edx
  800bcb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bce:	eb 03                	jmp    800bd3 <memfind+0x13>
  800bd0:	83 c0 01             	add    $0x1,%eax
  800bd3:	39 d0                	cmp    %edx,%eax
  800bd5:	73 04                	jae    800bdb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd7:	38 08                	cmp    %cl,(%eax)
  800bd9:	75 f5                	jne    800bd0 <memfind+0x10>
			break;
	return (void *) s;
}
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be9:	eb 03                	jmp    800bee <strtol+0x11>
		s++;
  800beb:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800bee:	0f b6 02             	movzbl (%edx),%eax
  800bf1:	3c 20                	cmp    $0x20,%al
  800bf3:	74 f6                	je     800beb <strtol+0xe>
  800bf5:	3c 09                	cmp    $0x9,%al
  800bf7:	74 f2                	je     800beb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bf9:	3c 2b                	cmp    $0x2b,%al
  800bfb:	74 2a                	je     800c27 <strtol+0x4a>
	int neg = 0;
  800bfd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c02:	3c 2d                	cmp    $0x2d,%al
  800c04:	74 2b                	je     800c31 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c06:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c0c:	75 0f                	jne    800c1d <strtol+0x40>
  800c0e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c11:	74 28                	je     800c3b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c13:	85 db                	test   %ebx,%ebx
  800c15:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1a:	0f 44 d8             	cmove  %eax,%ebx
  800c1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c22:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c25:	eb 46                	jmp    800c6d <strtol+0x90>
		s++;
  800c27:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c2a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2f:	eb d5                	jmp    800c06 <strtol+0x29>
		s++, neg = 1;
  800c31:	83 c2 01             	add    $0x1,%edx
  800c34:	bf 01 00 00 00       	mov    $0x1,%edi
  800c39:	eb cb                	jmp    800c06 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c3f:	74 0e                	je     800c4f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c41:	85 db                	test   %ebx,%ebx
  800c43:	75 d8                	jne    800c1d <strtol+0x40>
		s++, base = 8;
  800c45:	83 c2 01             	add    $0x1,%edx
  800c48:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c4d:	eb ce                	jmp    800c1d <strtol+0x40>
		s += 2, base = 16;
  800c4f:	83 c2 02             	add    $0x2,%edx
  800c52:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c57:	eb c4                	jmp    800c1d <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c59:	0f be c0             	movsbl %al,%eax
  800c5c:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c62:	7d 3a                	jge    800c9e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c64:	83 c2 01             	add    $0x1,%edx
  800c67:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800c6b:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800c6d:	0f b6 02             	movzbl (%edx),%eax
  800c70:	8d 70 d0             	lea    -0x30(%eax),%esi
  800c73:	89 f3                	mov    %esi,%ebx
  800c75:	80 fb 09             	cmp    $0x9,%bl
  800c78:	76 df                	jbe    800c59 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c7a:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c7d:	89 f3                	mov    %esi,%ebx
  800c7f:	80 fb 19             	cmp    $0x19,%bl
  800c82:	77 08                	ja     800c8c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c84:	0f be c0             	movsbl %al,%eax
  800c87:	83 e8 57             	sub    $0x57,%eax
  800c8a:	eb d3                	jmp    800c5f <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c8c:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c8f:	89 f3                	mov    %esi,%ebx
  800c91:	80 fb 19             	cmp    $0x19,%bl
  800c94:	77 08                	ja     800c9e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c96:	0f be c0             	movsbl %al,%eax
  800c99:	83 e8 37             	sub    $0x37,%eax
  800c9c:	eb c1                	jmp    800c5f <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca2:	74 05                	je     800ca9 <strtol+0xcc>
		*endptr = (char *) s;
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ca9:	89 c8                	mov    %ecx,%eax
  800cab:	f7 d8                	neg    %eax
  800cad:	85 ff                	test   %edi,%edi
  800caf:	0f 45 c8             	cmovne %eax,%ecx
}
  800cb2:	89 c8                	mov    %ecx,%eax
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cca:	89 c3                	mov    %eax,%ebx
  800ccc:	89 c7                	mov    %eax,%edi
  800cce:	89 c6                	mov    %eax,%esi
  800cd0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce7:	89 d1                	mov    %edx,%ecx
  800ce9:	89 d3                	mov    %edx,%ebx
  800ceb:	89 d7                	mov    %edx,%edi
  800ced:	89 d6                	mov    %edx,%esi
  800cef:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0c:	89 cb                	mov    %ecx,%ebx
  800d0e:	89 cf                	mov    %ecx,%edi
  800d10:	89 ce                	mov    %ecx,%esi
  800d12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d14:	85 c0                	test   %eax,%eax
  800d16:	7f 08                	jg     800d20 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	50                   	push   %eax
  800d24:	6a 03                	push   $0x3
  800d26:	68 3f 24 80 00       	push   $0x80243f
  800d2b:	6a 23                	push   $0x23
  800d2d:	68 5c 24 80 00       	push   $0x80245c
  800d32:	e8 a2 f4 ff ff       	call   8001d9 <_panic>

00800d37 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d42:	b8 02 00 00 00       	mov    $0x2,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_yield>:

void
sys_yield(void)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d66:	89 d1                	mov    %edx,%ecx
  800d68:	89 d3                	mov    %edx,%ebx
  800d6a:	89 d7                	mov    %edx,%edi
  800d6c:	89 d6                	mov    %edx,%esi
  800d6e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	be 00 00 00 00       	mov    $0x0,%esi
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d91:	89 f7                	mov    %esi,%edi
  800d93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d95:	85 c0                	test   %eax,%eax
  800d97:	7f 08                	jg     800da1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da1:	83 ec 0c             	sub    $0xc,%esp
  800da4:	50                   	push   %eax
  800da5:	6a 04                	push   $0x4
  800da7:	68 3f 24 80 00       	push   $0x80243f
  800dac:	6a 23                	push   $0x23
  800dae:	68 5c 24 80 00       	push   $0x80245c
  800db3:	e8 21 f4 ff ff       	call   8001d9 <_panic>

00800db8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd2:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7f 08                	jg     800de3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de3:	83 ec 0c             	sub    $0xc,%esp
  800de6:	50                   	push   %eax
  800de7:	6a 05                	push   $0x5
  800de9:	68 3f 24 80 00       	push   $0x80243f
  800dee:	6a 23                	push   $0x23
  800df0:	68 5c 24 80 00       	push   $0x80245c
  800df5:	e8 df f3 ff ff       	call   8001d9 <_panic>

00800dfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 06                	push   $0x6
  800e2b:	68 3f 24 80 00       	push   $0x80243f
  800e30:	6a 23                	push   $0x23
  800e32:	68 5c 24 80 00       	push   $0x80245c
  800e37:	e8 9d f3 ff ff       	call   8001d9 <_panic>

00800e3c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	b8 08 00 00 00       	mov    $0x8,%eax
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 08                	push   $0x8
  800e6d:	68 3f 24 80 00       	push   $0x80243f
  800e72:	6a 23                	push   $0x23
  800e74:	68 5c 24 80 00       	push   $0x80245c
  800e79:	e8 5b f3 ff ff       	call   8001d9 <_panic>

00800e7e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	b8 09 00 00 00       	mov    $0x9,%eax
  800e97:	89 df                	mov    %ebx,%edi
  800e99:	89 de                	mov    %ebx,%esi
  800e9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	7f 08                	jg     800ea9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	83 ec 0c             	sub    $0xc,%esp
  800eac:	50                   	push   %eax
  800ead:	6a 09                	push   $0x9
  800eaf:	68 3f 24 80 00       	push   $0x80243f
  800eb4:	6a 23                	push   $0x23
  800eb6:	68 5c 24 80 00       	push   $0x80245c
  800ebb:	e8 19 f3 ff ff       	call   8001d9 <_panic>

00800ec0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed9:	89 df                	mov    %ebx,%edi
  800edb:	89 de                	mov    %ebx,%esi
  800edd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7f 08                	jg     800eeb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	50                   	push   %eax
  800eef:	6a 0a                	push   $0xa
  800ef1:	68 3f 24 80 00       	push   $0x80243f
  800ef6:	6a 23                	push   $0x23
  800ef8:	68 5c 24 80 00       	push   $0x80245c
  800efd:	e8 d7 f2 ff ff       	call   8001d9 <_panic>

00800f02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f13:	be 00 00 00 00       	mov    $0x0,%esi
  800f18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3b:	89 cb                	mov    %ecx,%ebx
  800f3d:	89 cf                	mov    %ecx,%edi
  800f3f:	89 ce                	mov    %ecx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 0d                	push   $0xd
  800f55:	68 3f 24 80 00       	push   $0x80243f
  800f5a:	6a 23                	push   $0x23
  800f5c:	68 5c 24 80 00       	push   $0x80245c
  800f61:	e8 73 f2 ff ff       	call   8001d9 <_panic>

00800f66 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	05 00 00 00 30       	add    $0x30000000,%eax
  800f71:	c1 e8 0c             	shr    $0xc,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f86:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f95:	89 c2                	mov    %eax,%edx
  800f97:	c1 ea 16             	shr    $0x16,%edx
  800f9a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fa1:	f6 c2 01             	test   $0x1,%dl
  800fa4:	74 29                	je     800fcf <fd_alloc+0x42>
  800fa6:	89 c2                	mov    %eax,%edx
  800fa8:	c1 ea 0c             	shr    $0xc,%edx
  800fab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb2:	f6 c2 01             	test   $0x1,%dl
  800fb5:	74 18                	je     800fcf <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  800fb7:	05 00 10 00 00       	add    $0x1000,%eax
  800fbc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fc1:	75 d2                	jne    800f95 <fd_alloc+0x8>
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  800fc8:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  800fcd:	eb 05                	jmp    800fd4 <fd_alloc+0x47>
			return 0;
  800fcf:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	89 02                	mov    %eax,(%edx)
}
  800fd9:	89 c8                	mov    %ecx,%eax
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fe3:	83 f8 1f             	cmp    $0x1f,%eax
  800fe6:	77 30                	ja     801018 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fe8:	c1 e0 0c             	shl    $0xc,%eax
  800feb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ff0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ff6:	f6 c2 01             	test   $0x1,%dl
  800ff9:	74 24                	je     80101f <fd_lookup+0x42>
  800ffb:	89 c2                	mov    %eax,%edx
  800ffd:	c1 ea 0c             	shr    $0xc,%edx
  801000:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801007:	f6 c2 01             	test   $0x1,%dl
  80100a:	74 1a                	je     801026 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80100c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100f:	89 02                	mov    %eax,(%edx)
	return 0;
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    
		return -E_INVAL;
  801018:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80101d:	eb f7                	jmp    801016 <fd_lookup+0x39>
		return -E_INVAL;
  80101f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801024:	eb f0                	jmp    801016 <fd_lookup+0x39>
  801026:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102b:	eb e9                	jmp    801016 <fd_lookup+0x39>

0080102d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	53                   	push   %ebx
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	b8 e8 24 80 00       	mov    $0x8024e8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  80103c:	bb 08 30 80 00       	mov    $0x803008,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801041:	39 13                	cmp    %edx,(%ebx)
  801043:	74 32                	je     801077 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  801045:	83 c0 04             	add    $0x4,%eax
  801048:	8b 18                	mov    (%eax),%ebx
  80104a:	85 db                	test   %ebx,%ebx
  80104c:	75 f3                	jne    801041 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80104e:	a1 04 40 80 00       	mov    0x804004,%eax
  801053:	8b 40 48             	mov    0x48(%eax),%eax
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	52                   	push   %edx
  80105a:	50                   	push   %eax
  80105b:	68 6c 24 80 00       	push   $0x80246c
  801060:	e8 4f f2 ff ff       	call   8002b4 <cprintf>
	*dev = 0;
	return -E_INVAL;
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	89 1a                	mov    %ebx,(%edx)
}
  801072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801075:	c9                   	leave  
  801076:	c3                   	ret    
			return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	eb ef                	jmp    80106d <dev_lookup+0x40>

0080107e <fd_close>:
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 24             	sub    $0x24,%esp
  801087:	8b 75 08             	mov    0x8(%ebp),%esi
  80108a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80108d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801090:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801091:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801097:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80109a:	50                   	push   %eax
  80109b:	e8 3d ff ff ff       	call   800fdd <fd_lookup>
  8010a0:	89 c3                	mov    %eax,%ebx
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 05                	js     8010ae <fd_close+0x30>
	    || fd != fd2)
  8010a9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010ac:	74 16                	je     8010c4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010ae:	89 f8                	mov    %edi,%eax
  8010b0:	84 c0                	test   %al,%al
  8010b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b7:	0f 44 d8             	cmove  %eax,%ebx
}
  8010ba:	89 d8                	mov    %ebx,%eax
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010ca:	50                   	push   %eax
  8010cb:	ff 36                	push   (%esi)
  8010cd:	e8 5b ff ff ff       	call   80102d <dev_lookup>
  8010d2:	89 c3                	mov    %eax,%ebx
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	78 1a                	js     8010f5 <fd_close+0x77>
		if (dev->dev_close)
  8010db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010de:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	74 0b                	je     8010f5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	56                   	push   %esi
  8010ee:	ff d0                	call   *%eax
  8010f0:	89 c3                	mov    %eax,%ebx
  8010f2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010f5:	83 ec 08             	sub    $0x8,%esp
  8010f8:	56                   	push   %esi
  8010f9:	6a 00                	push   $0x0
  8010fb:	e8 fa fc ff ff       	call   800dfa <sys_page_unmap>
	return r;
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	eb b5                	jmp    8010ba <fd_close+0x3c>

00801105 <close>:

int
close(int fdnum)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80110e:	50                   	push   %eax
  80110f:	ff 75 08             	push   0x8(%ebp)
  801112:	e8 c6 fe ff ff       	call   800fdd <fd_lookup>
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	79 02                	jns    801120 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    
		return fd_close(fd, 1);
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	6a 01                	push   $0x1
  801125:	ff 75 f4             	push   -0xc(%ebp)
  801128:	e8 51 ff ff ff       	call   80107e <fd_close>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	eb ec                	jmp    80111e <close+0x19>

00801132 <close_all>:

void
close_all(void)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	53                   	push   %ebx
  801136:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801139:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	53                   	push   %ebx
  801142:	e8 be ff ff ff       	call   801105 <close>
	for (i = 0; i < MAXFD; i++)
  801147:	83 c3 01             	add    $0x1,%ebx
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	83 fb 20             	cmp    $0x20,%ebx
  801150:	75 ec                	jne    80113e <close_all+0xc>
}
  801152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	57                   	push   %edi
  80115b:	56                   	push   %esi
  80115c:	53                   	push   %ebx
  80115d:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801160:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	ff 75 08             	push   0x8(%ebp)
  801167:	e8 71 fe ff ff       	call   800fdd <fd_lookup>
  80116c:	89 c3                	mov    %eax,%ebx
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	78 7f                	js     8011f4 <dup+0x9d>
		return r;
	close(newfdnum);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 0c             	push   0xc(%ebp)
  80117b:	e8 85 ff ff ff       	call   801105 <close>

	newfd = INDEX2FD(newfdnum);
  801180:	8b 75 0c             	mov    0xc(%ebp),%esi
  801183:	c1 e6 0c             	shl    $0xc,%esi
  801186:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80118f:	89 3c 24             	mov    %edi,(%esp)
  801192:	e8 df fd ff ff       	call   800f76 <fd2data>
  801197:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801199:	89 34 24             	mov    %esi,(%esp)
  80119c:	e8 d5 fd ff ff       	call   800f76 <fd2data>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	c1 e8 16             	shr    $0x16,%eax
  8011ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b3:	a8 01                	test   $0x1,%al
  8011b5:	74 11                	je     8011c8 <dup+0x71>
  8011b7:	89 d8                	mov    %ebx,%eax
  8011b9:	c1 e8 0c             	shr    $0xc,%eax
  8011bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c3:	f6 c2 01             	test   $0x1,%dl
  8011c6:	75 36                	jne    8011fe <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c8:	89 f8                	mov    %edi,%eax
  8011ca:	c1 e8 0c             	shr    $0xc,%eax
  8011cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011dc:	50                   	push   %eax
  8011dd:	56                   	push   %esi
  8011de:	6a 00                	push   $0x0
  8011e0:	57                   	push   %edi
  8011e1:	6a 00                	push   $0x0
  8011e3:	e8 d0 fb ff ff       	call   800db8 <sys_page_map>
  8011e8:	89 c3                	mov    %eax,%ebx
  8011ea:	83 c4 20             	add    $0x20,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	78 33                	js     801224 <dup+0xcd>
		goto err;

	return newfdnum;
  8011f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f4:	89 d8                	mov    %ebx,%eax
  8011f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5e                   	pop    %esi
  8011fb:	5f                   	pop    %edi
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	25 07 0e 00 00       	and    $0xe07,%eax
  80120d:	50                   	push   %eax
  80120e:	ff 75 d4             	push   -0x2c(%ebp)
  801211:	6a 00                	push   $0x0
  801213:	53                   	push   %ebx
  801214:	6a 00                	push   $0x0
  801216:	e8 9d fb ff ff       	call   800db8 <sys_page_map>
  80121b:	89 c3                	mov    %eax,%ebx
  80121d:	83 c4 20             	add    $0x20,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	79 a4                	jns    8011c8 <dup+0x71>
	sys_page_unmap(0, newfd);
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	56                   	push   %esi
  801228:	6a 00                	push   $0x0
  80122a:	e8 cb fb ff ff       	call   800dfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  80122f:	83 c4 08             	add    $0x8,%esp
  801232:	ff 75 d4             	push   -0x2c(%ebp)
  801235:	6a 00                	push   $0x0
  801237:	e8 be fb ff ff       	call   800dfa <sys_page_unmap>
	return r;
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	eb b3                	jmp    8011f4 <dup+0x9d>

00801241 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	56                   	push   %esi
  801245:	53                   	push   %ebx
  801246:	83 ec 18             	sub    $0x18,%esp
  801249:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	56                   	push   %esi
  801251:	e8 87 fd ff ff       	call   800fdd <fd_lookup>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 3c                	js     801299 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801266:	50                   	push   %eax
  801267:	ff 33                	push   (%ebx)
  801269:	e8 bf fd ff ff       	call   80102d <dev_lookup>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	78 24                	js     801299 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801275:	8b 43 08             	mov    0x8(%ebx),%eax
  801278:	83 e0 03             	and    $0x3,%eax
  80127b:	83 f8 01             	cmp    $0x1,%eax
  80127e:	74 20                	je     8012a0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801283:	8b 40 08             	mov    0x8(%eax),%eax
  801286:	85 c0                	test   %eax,%eax
  801288:	74 37                	je     8012c1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	ff 75 10             	push   0x10(%ebp)
  801290:	ff 75 0c             	push   0xc(%ebp)
  801293:	53                   	push   %ebx
  801294:	ff d0                	call   *%eax
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a5:	8b 40 48             	mov    0x48(%eax),%eax
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	56                   	push   %esi
  8012ac:	50                   	push   %eax
  8012ad:	68 ad 24 80 00       	push   $0x8024ad
  8012b2:	e8 fd ef ff ff       	call   8002b4 <cprintf>
		return -E_INVAL;
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb d8                	jmp    801299 <read+0x58>
		return -E_NOT_SUPP;
  8012c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c6:	eb d1                	jmp    801299 <read+0x58>

008012c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	57                   	push   %edi
  8012cc:	56                   	push   %esi
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012dc:	eb 02                	jmp    8012e0 <readn+0x18>
  8012de:	01 c3                	add    %eax,%ebx
  8012e0:	39 f3                	cmp    %esi,%ebx
  8012e2:	73 21                	jae    801305 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	89 f0                	mov    %esi,%eax
  8012e9:	29 d8                	sub    %ebx,%eax
  8012eb:	50                   	push   %eax
  8012ec:	89 d8                	mov    %ebx,%eax
  8012ee:	03 45 0c             	add    0xc(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	57                   	push   %edi
  8012f3:	e8 49 ff ff ff       	call   801241 <read>
		if (m < 0)
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 04                	js     801303 <readn+0x3b>
			return m;
		if (m == 0)
  8012ff:	75 dd                	jne    8012de <readn+0x16>
  801301:	eb 02                	jmp    801305 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801303:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801305:	89 d8                	mov    %ebx,%eax
  801307:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5f                   	pop    %edi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	56                   	push   %esi
  801313:	53                   	push   %ebx
  801314:	83 ec 18             	sub    $0x18,%esp
  801317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	53                   	push   %ebx
  80131f:	e8 b9 fc ff ff       	call   800fdd <fd_lookup>
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 37                	js     801362 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132b:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80132e:	83 ec 08             	sub    $0x8,%esp
  801331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801334:	50                   	push   %eax
  801335:	ff 36                	push   (%esi)
  801337:	e8 f1 fc ff ff       	call   80102d <dev_lookup>
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 1f                	js     801362 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801343:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801347:	74 20                	je     801369 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	8b 40 0c             	mov    0xc(%eax),%eax
  80134f:	85 c0                	test   %eax,%eax
  801351:	74 37                	je     80138a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	ff 75 10             	push   0x10(%ebp)
  801359:	ff 75 0c             	push   0xc(%ebp)
  80135c:	56                   	push   %esi
  80135d:	ff d0                	call   *%eax
  80135f:	83 c4 10             	add    $0x10,%esp
}
  801362:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801369:	a1 04 40 80 00       	mov    0x804004,%eax
  80136e:	8b 40 48             	mov    0x48(%eax),%eax
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	53                   	push   %ebx
  801375:	50                   	push   %eax
  801376:	68 c9 24 80 00       	push   $0x8024c9
  80137b:	e8 34 ef ff ff       	call   8002b4 <cprintf>
		return -E_INVAL;
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801388:	eb d8                	jmp    801362 <write+0x53>
		return -E_NOT_SUPP;
  80138a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138f:	eb d1                	jmp    801362 <write+0x53>

00801391 <seek>:

int
seek(int fdnum, off_t offset)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801397:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 08             	push   0x8(%ebp)
  80139e:	e8 3a fc ff ff       	call   800fdd <fd_lookup>
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 0e                	js     8013b8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	56                   	push   %esi
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 18             	sub    $0x18,%esp
  8013c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	53                   	push   %ebx
  8013ca:	e8 0e fc ff ff       	call   800fdd <fd_lookup>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 34                	js     80140a <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d6:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 36                	push   (%esi)
  8013e2:	e8 46 fc ff ff       	call   80102d <dev_lookup>
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 1c                	js     80140a <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ee:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8013f2:	74 1d                	je     801411 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f7:	8b 40 18             	mov    0x18(%eax),%eax
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	74 34                	je     801432 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013fe:	83 ec 08             	sub    $0x8,%esp
  801401:	ff 75 0c             	push   0xc(%ebp)
  801404:	56                   	push   %esi
  801405:	ff d0                	call   *%eax
  801407:	83 c4 10             	add    $0x10,%esp
}
  80140a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80140d:	5b                   	pop    %ebx
  80140e:	5e                   	pop    %esi
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    
			thisenv->env_id, fdnum);
  801411:	a1 04 40 80 00       	mov    0x804004,%eax
  801416:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	53                   	push   %ebx
  80141d:	50                   	push   %eax
  80141e:	68 8c 24 80 00       	push   $0x80248c
  801423:	e8 8c ee ff ff       	call   8002b4 <cprintf>
		return -E_INVAL;
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801430:	eb d8                	jmp    80140a <ftruncate+0x50>
		return -E_NOT_SUPP;
  801432:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801437:	eb d1                	jmp    80140a <ftruncate+0x50>

00801439 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	83 ec 18             	sub    $0x18,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 75 08             	push   0x8(%ebp)
  80144b:	e8 8d fb ff ff       	call   800fdd <fd_lookup>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 49                	js     8014a0 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801457:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	ff 36                	push   (%esi)
  801463:	e8 c5 fb ff ff       	call   80102d <dev_lookup>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 31                	js     8014a0 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  80146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801472:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801476:	74 2f                	je     8014a7 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801478:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80147b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801482:	00 00 00 
	stat->st_isdir = 0;
  801485:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80148c:	00 00 00 
	stat->st_dev = dev;
  80148f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	53                   	push   %ebx
  801499:	56                   	push   %esi
  80149a:	ff 50 14             	call   *0x14(%eax)
  80149d:	83 c4 10             	add    $0x10,%esp
}
  8014a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a3:	5b                   	pop    %ebx
  8014a4:	5e                   	pop    %esi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    
		return -E_NOT_SUPP;
  8014a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ac:	eb f2                	jmp    8014a0 <fstat+0x67>

008014ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	6a 00                	push   $0x0
  8014b8:	ff 75 08             	push   0x8(%ebp)
  8014bb:	e8 22 02 00 00       	call   8016e2 <open>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 1b                	js     8014e4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	push   0xc(%ebp)
  8014cf:	50                   	push   %eax
  8014d0:	e8 64 ff ff ff       	call   801439 <fstat>
  8014d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	e8 26 fc ff ff       	call   801105 <close>
	return r;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	89 f3                	mov    %esi,%ebx
}
  8014e4:	89 d8                	mov    %ebx,%eax
  8014e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    

008014ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	89 c6                	mov    %eax,%esi
  8014f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014f6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8014fd:	74 27                	je     801526 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ff:	6a 07                	push   $0x7
  801501:	68 00 50 80 00       	push   $0x805000
  801506:	56                   	push   %esi
  801507:	ff 35 00 60 80 00    	push   0x806000
  80150d:	e8 95 08 00 00       	call   801da7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801512:	83 c4 0c             	add    $0xc,%esp
  801515:	6a 00                	push   $0x0
  801517:	53                   	push   %ebx
  801518:	6a 00                	push   $0x0
  80151a:	e8 39 08 00 00       	call   801d58 <ipc_recv>
}
  80151f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	6a 01                	push   $0x1
  80152b:	e8 c3 08 00 00       	call   801df3 <ipc_find_env>
  801530:	a3 00 60 80 00       	mov    %eax,0x806000
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	eb c5                	jmp    8014ff <fsipc+0x12>

0080153a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8b 40 0c             	mov    0xc(%eax),%eax
  801546:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801553:	ba 00 00 00 00       	mov    $0x0,%edx
  801558:	b8 02 00 00 00       	mov    $0x2,%eax
  80155d:	e8 8b ff ff ff       	call   8014ed <fsipc>
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <devfile_flush>:
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8b 40 0c             	mov    0xc(%eax),%eax
  801570:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 06 00 00 00       	mov    $0x6,%eax
  80157f:	e8 69 ff ff ff       	call   8014ed <fsipc>
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <devfile_stat>:
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8b 40 0c             	mov    0xc(%eax),%eax
  801596:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80159b:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8015a5:	e8 43 ff ff ff       	call   8014ed <fsipc>
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 2c                	js     8015da <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	68 00 50 80 00       	push   $0x805000
  8015b6:	53                   	push   %ebx
  8015b7:	e8 bd f3 ff ff       	call   800979 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015bc:	a1 80 50 80 00       	mov    0x805080,%eax
  8015c1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015c7:	a1 84 50 80 00       	mov    0x805084,%eax
  8015cc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <devfile_write>:
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 08             	sub    $0x8,%esp
  8015e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015f4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8015fa:	53                   	push   %ebx
  8015fb:	ff 75 0c             	push   0xc(%ebp)
  8015fe:	68 08 50 80 00       	push   $0x805008
  801603:	e8 69 f5 ff ff       	call   800b71 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	b8 04 00 00 00       	mov    $0x4,%eax
  801612:	e8 d6 fe ff ff       	call   8014ed <fsipc>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 0b                	js     801629 <devfile_write+0x4a>
	assert(r <= n);
  80161e:	39 d8                	cmp    %ebx,%eax
  801620:	77 0c                	ja     80162e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801622:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801627:	7f 1e                	jg     801647 <devfile_write+0x68>
}
  801629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    
	assert(r <= n);
  80162e:	68 f8 24 80 00       	push   $0x8024f8
  801633:	68 ff 24 80 00       	push   $0x8024ff
  801638:	68 97 00 00 00       	push   $0x97
  80163d:	68 14 25 80 00       	push   $0x802514
  801642:	e8 92 eb ff ff       	call   8001d9 <_panic>
	assert(r <= PGSIZE);
  801647:	68 1f 25 80 00       	push   $0x80251f
  80164c:	68 ff 24 80 00       	push   $0x8024ff
  801651:	68 98 00 00 00       	push   $0x98
  801656:	68 14 25 80 00       	push   $0x802514
  80165b:	e8 79 eb ff ff       	call   8001d9 <_panic>

00801660 <devfile_read>:
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8b 40 0c             	mov    0xc(%eax),%eax
  80166e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801673:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801679:	ba 00 00 00 00       	mov    $0x0,%edx
  80167e:	b8 03 00 00 00       	mov    $0x3,%eax
  801683:	e8 65 fe ff ff       	call   8014ed <fsipc>
  801688:	89 c3                	mov    %eax,%ebx
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 1f                	js     8016ad <devfile_read+0x4d>
	assert(r <= n);
  80168e:	39 f0                	cmp    %esi,%eax
  801690:	77 24                	ja     8016b6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801692:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801697:	7f 33                	jg     8016cc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	50                   	push   %eax
  80169d:	68 00 50 80 00       	push   $0x805000
  8016a2:	ff 75 0c             	push   0xc(%ebp)
  8016a5:	e8 65 f4 ff ff       	call   800b0f <memmove>
	return r;
  8016aa:	83 c4 10             	add    $0x10,%esp
}
  8016ad:	89 d8                	mov    %ebx,%eax
  8016af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b2:	5b                   	pop    %ebx
  8016b3:	5e                   	pop    %esi
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    
	assert(r <= n);
  8016b6:	68 f8 24 80 00       	push   $0x8024f8
  8016bb:	68 ff 24 80 00       	push   $0x8024ff
  8016c0:	6a 7c                	push   $0x7c
  8016c2:	68 14 25 80 00       	push   $0x802514
  8016c7:	e8 0d eb ff ff       	call   8001d9 <_panic>
	assert(r <= PGSIZE);
  8016cc:	68 1f 25 80 00       	push   $0x80251f
  8016d1:	68 ff 24 80 00       	push   $0x8024ff
  8016d6:	6a 7d                	push   $0x7d
  8016d8:	68 14 25 80 00       	push   $0x802514
  8016dd:	e8 f7 ea ff ff       	call   8001d9 <_panic>

008016e2 <open>:
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 1c             	sub    $0x1c,%esp
  8016ea:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ed:	56                   	push   %esi
  8016ee:	e8 4b f2 ff ff       	call   80093e <strlen>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016fb:	7f 6c                	jg     801769 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	e8 84 f8 ff ff       	call   800f8d <fd_alloc>
  801709:	89 c3                	mov    %eax,%ebx
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 3c                	js     80174e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	56                   	push   %esi
  801716:	68 00 50 80 00       	push   $0x805000
  80171b:	e8 59 f2 ff ff       	call   800979 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801720:	8b 45 0c             	mov    0xc(%ebp),%eax
  801723:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172b:	b8 01 00 00 00       	mov    $0x1,%eax
  801730:	e8 b8 fd ff ff       	call   8014ed <fsipc>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 19                	js     801757 <open+0x75>
	return fd2num(fd);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	ff 75 f4             	push   -0xc(%ebp)
  801744:	e8 1d f8 ff ff       	call   800f66 <fd2num>
  801749:	89 c3                	mov    %eax,%ebx
  80174b:	83 c4 10             	add    $0x10,%esp
}
  80174e:	89 d8                	mov    %ebx,%eax
  801750:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    
		fd_close(fd, 0);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	6a 00                	push   $0x0
  80175c:	ff 75 f4             	push   -0xc(%ebp)
  80175f:	e8 1a f9 ff ff       	call   80107e <fd_close>
		return r;
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	eb e5                	jmp    80174e <open+0x6c>
		return -E_BAD_PATH;
  801769:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80176e:	eb de                	jmp    80174e <open+0x6c>

00801770 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801776:	ba 00 00 00 00       	mov    $0x0,%edx
  80177b:	b8 08 00 00 00       	mov    $0x8,%eax
  801780:	e8 68 fd ff ff       	call   8014ed <fsipc>
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801787:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80178b:	7f 01                	jg     80178e <writebuf+0x7>
  80178d:	c3                   	ret    
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801797:	ff 70 04             	push   0x4(%eax)
  80179a:	8d 40 10             	lea    0x10(%eax),%eax
  80179d:	50                   	push   %eax
  80179e:	ff 33                	push   (%ebx)
  8017a0:	e8 6a fb ff ff       	call   80130f <write>
		if (result > 0)
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	7e 03                	jle    8017af <writebuf+0x28>
			b->result += result;
  8017ac:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017af:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017b2:	74 0d                	je     8017c1 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bb:	0f 4f c2             	cmovg  %edx,%eax
  8017be:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <putch>:

static void
putch(int ch, void *thunk)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017d0:	8b 53 04             	mov    0x4(%ebx),%edx
  8017d3:	8d 42 01             	lea    0x1(%edx),%eax
  8017d6:	89 43 04             	mov    %eax,0x4(%ebx)
  8017d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017dc:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017e0:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017e5:	74 05                	je     8017ec <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    
		writebuf(b);
  8017ec:	89 d8                	mov    %ebx,%eax
  8017ee:	e8 94 ff ff ff       	call   801787 <writebuf>
		b->idx = 0;
  8017f3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017fa:	eb eb                	jmp    8017e7 <putch+0x21>

008017fc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80180e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801815:	00 00 00 
	b.result = 0;
  801818:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80181f:	00 00 00 
	b.error = 1;
  801822:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801829:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80182c:	ff 75 10             	push   0x10(%ebp)
  80182f:	ff 75 0c             	push   0xc(%ebp)
  801832:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	68 c6 17 80 00       	push   $0x8017c6
  80183e:	e8 68 eb ff ff       	call   8003ab <vprintfmt>
	if (b.idx > 0)
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80184d:	7f 11                	jg     801860 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80184f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801855:	85 c0                	test   %eax,%eax
  801857:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    
		writebuf(&b);
  801860:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801866:	e8 1c ff ff ff       	call   801787 <writebuf>
  80186b:	eb e2                	jmp    80184f <vfprintf+0x53>

0080186d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801873:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801876:	50                   	push   %eax
  801877:	ff 75 0c             	push   0xc(%ebp)
  80187a:	ff 75 08             	push   0x8(%ebp)
  80187d:	e8 7a ff ff ff       	call   8017fc <vfprintf>
	va_end(ap);

	return cnt;
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <printf>:

int
printf(const char *fmt, ...)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80188a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80188d:	50                   	push   %eax
  80188e:	ff 75 08             	push   0x8(%ebp)
  801891:	6a 01                	push   $0x1
  801893:	e8 64 ff ff ff       	call   8017fc <vfprintf>
	va_end(ap);

	return cnt;
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	ff 75 08             	push   0x8(%ebp)
  8018a8:	e8 c9 f6 ff ff       	call   800f76 <fd2data>
  8018ad:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018af:	83 c4 08             	add    $0x8,%esp
  8018b2:	68 2b 25 80 00       	push   $0x80252b
  8018b7:	53                   	push   %ebx
  8018b8:	e8 bc f0 ff ff       	call   800979 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018bd:	8b 46 04             	mov    0x4(%esi),%eax
  8018c0:	2b 06                	sub    (%esi),%eax
  8018c2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018c8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018cf:	00 00 00 
	stat->st_dev = &devpipe;
  8018d2:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8018d9:	30 80 00 
	return 0;
}
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018f2:	53                   	push   %ebx
  8018f3:	6a 00                	push   $0x0
  8018f5:	e8 00 f5 ff ff       	call   800dfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018fa:	89 1c 24             	mov    %ebx,(%esp)
  8018fd:	e8 74 f6 ff ff       	call   800f76 <fd2data>
  801902:	83 c4 08             	add    $0x8,%esp
  801905:	50                   	push   %eax
  801906:	6a 00                	push   $0x0
  801908:	e8 ed f4 ff ff       	call   800dfa <sys_page_unmap>
}
  80190d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <_pipeisclosed>:
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	57                   	push   %edi
  801916:	56                   	push   %esi
  801917:	53                   	push   %ebx
  801918:	83 ec 1c             	sub    $0x1c,%esp
  80191b:	89 c7                	mov    %eax,%edi
  80191d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80191f:	a1 04 40 80 00       	mov    0x804004,%eax
  801924:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	57                   	push   %edi
  80192b:	e8 fc 04 00 00       	call   801e2c <pageref>
  801930:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801933:	89 34 24             	mov    %esi,(%esp)
  801936:	e8 f1 04 00 00       	call   801e2c <pageref>
		nn = thisenv->env_runs;
  80193b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801941:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	39 cb                	cmp    %ecx,%ebx
  801949:	74 1b                	je     801966 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80194b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80194e:	75 cf                	jne    80191f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801950:	8b 42 58             	mov    0x58(%edx),%eax
  801953:	6a 01                	push   $0x1
  801955:	50                   	push   %eax
  801956:	53                   	push   %ebx
  801957:	68 32 25 80 00       	push   $0x802532
  80195c:	e8 53 e9 ff ff       	call   8002b4 <cprintf>
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	eb b9                	jmp    80191f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801966:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801969:	0f 94 c0             	sete   %al
  80196c:	0f b6 c0             	movzbl %al,%eax
}
  80196f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5f                   	pop    %edi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <devpipe_write>:
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	57                   	push   %edi
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
  80197d:	83 ec 28             	sub    $0x28,%esp
  801980:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801983:	56                   	push   %esi
  801984:	e8 ed f5 ff ff       	call   800f76 <fd2data>
  801989:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	bf 00 00 00 00       	mov    $0x0,%edi
  801993:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801996:	75 09                	jne    8019a1 <devpipe_write+0x2a>
	return i;
  801998:	89 f8                	mov    %edi,%eax
  80199a:	eb 23                	jmp    8019bf <devpipe_write+0x48>
			sys_yield();
  80199c:	e8 b5 f3 ff ff       	call   800d56 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019a4:	8b 0b                	mov    (%ebx),%ecx
  8019a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8019a9:	39 d0                	cmp    %edx,%eax
  8019ab:	72 1a                	jb     8019c7 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  8019ad:	89 da                	mov    %ebx,%edx
  8019af:	89 f0                	mov    %esi,%eax
  8019b1:	e8 5c ff ff ff       	call   801912 <_pipeisclosed>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	74 e2                	je     80199c <devpipe_write+0x25>
				return 0;
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5f                   	pop    %edi
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	c1 fa 1f             	sar    $0x1f,%edx
  8019d6:	89 d1                	mov    %edx,%ecx
  8019d8:	c1 e9 1b             	shr    $0x1b,%ecx
  8019db:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019de:	83 e2 1f             	and    $0x1f,%edx
  8019e1:	29 ca                	sub    %ecx,%edx
  8019e3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019e7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019eb:	83 c0 01             	add    $0x1,%eax
  8019ee:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019f1:	83 c7 01             	add    $0x1,%edi
  8019f4:	eb 9d                	jmp    801993 <devpipe_write+0x1c>

008019f6 <devpipe_read>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	57                   	push   %edi
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 18             	sub    $0x18,%esp
  8019ff:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a02:	57                   	push   %edi
  801a03:	e8 6e f5 ff ff       	call   800f76 <fd2data>
  801a08:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	be 00 00 00 00       	mov    $0x0,%esi
  801a12:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a15:	75 13                	jne    801a2a <devpipe_read+0x34>
	return i;
  801a17:	89 f0                	mov    %esi,%eax
  801a19:	eb 02                	jmp    801a1d <devpipe_read+0x27>
				return i;
  801a1b:	89 f0                	mov    %esi,%eax
}
  801a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5f                   	pop    %edi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    
			sys_yield();
  801a25:	e8 2c f3 ff ff       	call   800d56 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a2a:	8b 03                	mov    (%ebx),%eax
  801a2c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a2f:	75 18                	jne    801a49 <devpipe_read+0x53>
			if (i > 0)
  801a31:	85 f6                	test   %esi,%esi
  801a33:	75 e6                	jne    801a1b <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801a35:	89 da                	mov    %ebx,%edx
  801a37:	89 f8                	mov    %edi,%eax
  801a39:	e8 d4 fe ff ff       	call   801912 <_pipeisclosed>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	74 e3                	je     801a25 <devpipe_read+0x2f>
				return 0;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
  801a47:	eb d4                	jmp    801a1d <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a49:	99                   	cltd   
  801a4a:	c1 ea 1b             	shr    $0x1b,%edx
  801a4d:	01 d0                	add    %edx,%eax
  801a4f:	83 e0 1f             	and    $0x1f,%eax
  801a52:	29 d0                	sub    %edx,%eax
  801a54:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a5c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a5f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a62:	83 c6 01             	add    $0x1,%esi
  801a65:	eb ab                	jmp    801a12 <devpipe_read+0x1c>

00801a67 <pipe>:
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a72:	50                   	push   %eax
  801a73:	e8 15 f5 ff ff       	call   800f8d <fd_alloc>
  801a78:	89 c3                	mov    %eax,%ebx
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	0f 88 23 01 00 00    	js     801ba8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	68 07 04 00 00       	push   $0x407
  801a8d:	ff 75 f4             	push   -0xc(%ebp)
  801a90:	6a 00                	push   $0x0
  801a92:	e8 de f2 ff ff       	call   800d75 <sys_page_alloc>
  801a97:	89 c3                	mov    %eax,%ebx
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	0f 88 04 01 00 00    	js     801ba8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801aa4:	83 ec 0c             	sub    $0xc,%esp
  801aa7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aaa:	50                   	push   %eax
  801aab:	e8 dd f4 ff ff       	call   800f8d <fd_alloc>
  801ab0:	89 c3                	mov    %eax,%ebx
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	0f 88 db 00 00 00    	js     801b98 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	68 07 04 00 00       	push   $0x407
  801ac5:	ff 75 f0             	push   -0x10(%ebp)
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 a6 f2 ff ff       	call   800d75 <sys_page_alloc>
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	0f 88 bc 00 00 00    	js     801b98 <pipe+0x131>
	va = fd2data(fd0);
  801adc:	83 ec 0c             	sub    $0xc,%esp
  801adf:	ff 75 f4             	push   -0xc(%ebp)
  801ae2:	e8 8f f4 ff ff       	call   800f76 <fd2data>
  801ae7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae9:	83 c4 0c             	add    $0xc,%esp
  801aec:	68 07 04 00 00       	push   $0x407
  801af1:	50                   	push   %eax
  801af2:	6a 00                	push   $0x0
  801af4:	e8 7c f2 ff ff       	call   800d75 <sys_page_alloc>
  801af9:	89 c3                	mov    %eax,%ebx
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	85 c0                	test   %eax,%eax
  801b00:	0f 88 82 00 00 00    	js     801b88 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	ff 75 f0             	push   -0x10(%ebp)
  801b0c:	e8 65 f4 ff ff       	call   800f76 <fd2data>
  801b11:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b18:	50                   	push   %eax
  801b19:	6a 00                	push   $0x0
  801b1b:	56                   	push   %esi
  801b1c:	6a 00                	push   $0x0
  801b1e:	e8 95 f2 ff ff       	call   800db8 <sys_page_map>
  801b23:	89 c3                	mov    %eax,%ebx
  801b25:	83 c4 20             	add    $0x20,%esp
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 4e                	js     801b7a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801b2c:	a1 24 30 80 00       	mov    0x803024,%eax
  801b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b34:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b39:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b43:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	ff 75 f4             	push   -0xc(%ebp)
  801b55:	e8 0c f4 ff ff       	call   800f66 <fd2num>
  801b5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b5f:	83 c4 04             	add    $0x4,%esp
  801b62:	ff 75 f0             	push   -0x10(%ebp)
  801b65:	e8 fc f3 ff ff       	call   800f66 <fd2num>
  801b6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b78:	eb 2e                	jmp    801ba8 <pipe+0x141>
	sys_page_unmap(0, va);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	56                   	push   %esi
  801b7e:	6a 00                	push   $0x0
  801b80:	e8 75 f2 ff ff       	call   800dfa <sys_page_unmap>
  801b85:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b88:	83 ec 08             	sub    $0x8,%esp
  801b8b:	ff 75 f0             	push   -0x10(%ebp)
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 65 f2 ff ff       	call   800dfa <sys_page_unmap>
  801b95:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	ff 75 f4             	push   -0xc(%ebp)
  801b9e:	6a 00                	push   $0x0
  801ba0:	e8 55 f2 ff ff       	call   800dfa <sys_page_unmap>
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <pipeisclosed>:
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bba:	50                   	push   %eax
  801bbb:	ff 75 08             	push   0x8(%ebp)
  801bbe:	e8 1a f4 ff ff       	call   800fdd <fd_lookup>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 18                	js     801be2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 f4             	push   -0xc(%ebp)
  801bd0:	e8 a1 f3 ff ff       	call   800f76 <fd2data>
  801bd5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	e8 33 fd ff ff       	call   801912 <_pipeisclosed>
  801bdf:	83 c4 10             	add    $0x10,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
  801be9:	c3                   	ret    

00801bea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bf0:	68 4a 25 80 00       	push   $0x80254a
  801bf5:	ff 75 0c             	push   0xc(%ebp)
  801bf8:	e8 7c ed ff ff       	call   800979 <strcpy>
	return 0;
}
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <devcons_write>:
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	57                   	push   %edi
  801c08:	56                   	push   %esi
  801c09:	53                   	push   %ebx
  801c0a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c10:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c15:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c1b:	eb 2e                	jmp    801c4b <devcons_write+0x47>
		m = n - tot;
  801c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c20:	29 f3                	sub    %esi,%ebx
  801c22:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c27:	39 c3                	cmp    %eax,%ebx
  801c29:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	53                   	push   %ebx
  801c30:	89 f0                	mov    %esi,%eax
  801c32:	03 45 0c             	add    0xc(%ebp),%eax
  801c35:	50                   	push   %eax
  801c36:	57                   	push   %edi
  801c37:	e8 d3 ee ff ff       	call   800b0f <memmove>
		sys_cputs(buf, m);
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	53                   	push   %ebx
  801c40:	57                   	push   %edi
  801c41:	e8 73 f0 ff ff       	call   800cb9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c46:	01 de                	add    %ebx,%esi
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c4e:	72 cd                	jb     801c1d <devcons_write+0x19>
}
  801c50:	89 f0                	mov    %esi,%eax
  801c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <devcons_read>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c69:	75 07                	jne    801c72 <devcons_read+0x18>
  801c6b:	eb 1f                	jmp    801c8c <devcons_read+0x32>
		sys_yield();
  801c6d:	e8 e4 f0 ff ff       	call   800d56 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c72:	e8 60 f0 ff ff       	call   800cd7 <sys_cgetc>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	74 f2                	je     801c6d <devcons_read+0x13>
	if (c < 0)
  801c7b:	78 0f                	js     801c8c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801c7d:	83 f8 04             	cmp    $0x4,%eax
  801c80:	74 0c                	je     801c8e <devcons_read+0x34>
	*(char*)vbuf = c;
  801c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c85:	88 02                	mov    %al,(%edx)
	return 1;
  801c87:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    
		return 0;
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c93:	eb f7                	jmp    801c8c <devcons_read+0x32>

00801c95 <cputchar>:
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ca1:	6a 01                	push   $0x1
  801ca3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ca6:	50                   	push   %eax
  801ca7:	e8 0d f0 ff ff       	call   800cb9 <sys_cputs>
}
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <getchar>:
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cb7:	6a 01                	push   $0x1
  801cb9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cbc:	50                   	push   %eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	e8 7d f5 ff ff       	call   801241 <read>
	if (r < 0)
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	78 06                	js     801cd1 <getchar+0x20>
	if (r < 1)
  801ccb:	74 06                	je     801cd3 <getchar+0x22>
	return c;
  801ccd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    
		return -E_EOF;
  801cd3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801cd8:	eb f7                	jmp    801cd1 <getchar+0x20>

00801cda <iscons>:
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce3:	50                   	push   %eax
  801ce4:	ff 75 08             	push   0x8(%ebp)
  801ce7:	e8 f1 f2 ff ff       	call   800fdd <fd_lookup>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 11                	js     801d04 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf6:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801cfc:	39 10                	cmp    %edx,(%eax)
  801cfe:	0f 94 c0             	sete   %al
  801d01:	0f b6 c0             	movzbl %al,%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <opencons>:
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0f:	50                   	push   %eax
  801d10:	e8 78 f2 ff ff       	call   800f8d <fd_alloc>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 3a                	js     801d56 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d1c:	83 ec 04             	sub    $0x4,%esp
  801d1f:	68 07 04 00 00       	push   $0x407
  801d24:	ff 75 f4             	push   -0xc(%ebp)
  801d27:	6a 00                	push   $0x0
  801d29:	e8 47 f0 ff ff       	call   800d75 <sys_page_alloc>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 21                	js     801d56 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d3e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	50                   	push   %eax
  801d4e:	e8 13 f2 ff ff       	call   800f66 <fd2num>
  801d53:	83 c4 10             	add    $0x10,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	8b 75 08             	mov    0x8(%ebp),%esi
  801d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	ff 75 0c             	push   0xc(%ebp)
  801d69:	e8 b7 f1 ff ff       	call   800f25 <sys_ipc_recv>
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 2b                	js     801da0 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d75:	85 f6                	test   %esi,%esi
  801d77:	74 0a                	je     801d83 <ipc_recv+0x2b>
  801d79:	a1 04 40 80 00       	mov    0x804004,%eax
  801d7e:	8b 40 74             	mov    0x74(%eax),%eax
  801d81:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d83:	85 db                	test   %ebx,%ebx
  801d85:	74 0a                	je     801d91 <ipc_recv+0x39>
  801d87:	a1 04 40 80 00       	mov    0x804004,%eax
  801d8c:	8b 40 78             	mov    0x78(%eax),%eax
  801d8f:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801d91:	a1 04 40 80 00       	mov    0x804004,%eax
  801d96:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801da0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da5:	eb f2                	jmp    801d99 <ipc_recv+0x41>

00801da7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	57                   	push   %edi
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801db3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801db6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801db9:	ff 75 14             	push   0x14(%ebp)
  801dbc:	53                   	push   %ebx
  801dbd:	56                   	push   %esi
  801dbe:	57                   	push   %edi
  801dbf:	e8 3e f1 ff ff       	call   800f02 <sys_ipc_try_send>
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	79 20                	jns    801deb <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801dcb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dce:	75 07                	jne    801dd7 <ipc_send+0x30>
		sys_yield();
  801dd0:	e8 81 ef ff ff       	call   800d56 <sys_yield>
  801dd5:	eb e2                	jmp    801db9 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	68 56 25 80 00       	push   $0x802556
  801ddf:	6a 2e                	push   $0x2e
  801de1:	68 66 25 80 00       	push   $0x802566
  801de6:	e8 ee e3 ff ff       	call   8001d9 <_panic>
	}
}
  801deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dfe:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e01:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e07:	8b 52 50             	mov    0x50(%edx),%edx
  801e0a:	39 ca                	cmp    %ecx,%edx
  801e0c:	74 11                	je     801e1f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801e0e:	83 c0 01             	add    $0x1,%eax
  801e11:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e16:	75 e6                	jne    801dfe <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1d:	eb 0b                	jmp    801e2a <ipc_find_env+0x37>
			return envs[i].env_id;
  801e1f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e27:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    

00801e2c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	c1 ea 16             	shr    $0x16,%edx
  801e37:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801e43:	f6 c1 01             	test   $0x1,%cl
  801e46:	74 1c                	je     801e64 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801e48:	c1 e8 0c             	shr    $0xc,%eax
  801e4b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e52:	a8 01                	test   $0x1,%al
  801e54:	74 0e                	je     801e64 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e56:	c1 e8 0c             	shr    $0xc,%eax
  801e59:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801e60:	ef 
  801e61:	0f b7 d2             	movzwl %dx,%edx
}
  801e64:	89 d0                	mov    %edx,%eax
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	66 90                	xchg   %ax,%ax
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	66 90                	xchg   %ax,%ax
  801e6e:	66 90                	xchg   %ax,%ax

00801e70 <__udivdi3>:
  801e70:	f3 0f 1e fb          	endbr32 
  801e74:	55                   	push   %ebp
  801e75:	57                   	push   %edi
  801e76:	56                   	push   %esi
  801e77:	53                   	push   %ebx
  801e78:	83 ec 1c             	sub    $0x1c,%esp
  801e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e7f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e87:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	75 19                	jne    801ea8 <__udivdi3+0x38>
  801e8f:	39 f3                	cmp    %esi,%ebx
  801e91:	76 4d                	jbe    801ee0 <__udivdi3+0x70>
  801e93:	31 ff                	xor    %edi,%edi
  801e95:	89 e8                	mov    %ebp,%eax
  801e97:	89 f2                	mov    %esi,%edx
  801e99:	f7 f3                	div    %ebx
  801e9b:	89 fa                	mov    %edi,%edx
  801e9d:	83 c4 1c             	add    $0x1c,%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    
  801ea5:	8d 76 00             	lea    0x0(%esi),%esi
  801ea8:	39 f0                	cmp    %esi,%eax
  801eaa:	76 14                	jbe    801ec0 <__udivdi3+0x50>
  801eac:	31 ff                	xor    %edi,%edi
  801eae:	31 c0                	xor    %eax,%eax
  801eb0:	89 fa                	mov    %edi,%edx
  801eb2:	83 c4 1c             	add    $0x1c,%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5e                   	pop    %esi
  801eb7:	5f                   	pop    %edi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    
  801eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ec0:	0f bd f8             	bsr    %eax,%edi
  801ec3:	83 f7 1f             	xor    $0x1f,%edi
  801ec6:	75 48                	jne    801f10 <__udivdi3+0xa0>
  801ec8:	39 f0                	cmp    %esi,%eax
  801eca:	72 06                	jb     801ed2 <__udivdi3+0x62>
  801ecc:	31 c0                	xor    %eax,%eax
  801ece:	39 eb                	cmp    %ebp,%ebx
  801ed0:	77 de                	ja     801eb0 <__udivdi3+0x40>
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	eb d7                	jmp    801eb0 <__udivdi3+0x40>
  801ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee0:	89 d9                	mov    %ebx,%ecx
  801ee2:	85 db                	test   %ebx,%ebx
  801ee4:	75 0b                	jne    801ef1 <__udivdi3+0x81>
  801ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eeb:	31 d2                	xor    %edx,%edx
  801eed:	f7 f3                	div    %ebx
  801eef:	89 c1                	mov    %eax,%ecx
  801ef1:	31 d2                	xor    %edx,%edx
  801ef3:	89 f0                	mov    %esi,%eax
  801ef5:	f7 f1                	div    %ecx
  801ef7:	89 c6                	mov    %eax,%esi
  801ef9:	89 e8                	mov    %ebp,%eax
  801efb:	89 f7                	mov    %esi,%edi
  801efd:	f7 f1                	div    %ecx
  801eff:	89 fa                	mov    %edi,%edx
  801f01:	83 c4 1c             	add    $0x1c,%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5f                   	pop    %edi
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    
  801f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f10:	89 f9                	mov    %edi,%ecx
  801f12:	ba 20 00 00 00       	mov    $0x20,%edx
  801f17:	29 fa                	sub    %edi,%edx
  801f19:	d3 e0                	shl    %cl,%eax
  801f1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1f:	89 d1                	mov    %edx,%ecx
  801f21:	89 d8                	mov    %ebx,%eax
  801f23:	d3 e8                	shr    %cl,%eax
  801f25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f29:	09 c1                	or     %eax,%ecx
  801f2b:	89 f0                	mov    %esi,%eax
  801f2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f31:	89 f9                	mov    %edi,%ecx
  801f33:	d3 e3                	shl    %cl,%ebx
  801f35:	89 d1                	mov    %edx,%ecx
  801f37:	d3 e8                	shr    %cl,%eax
  801f39:	89 f9                	mov    %edi,%ecx
  801f3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f3f:	89 eb                	mov    %ebp,%ebx
  801f41:	d3 e6                	shl    %cl,%esi
  801f43:	89 d1                	mov    %edx,%ecx
  801f45:	d3 eb                	shr    %cl,%ebx
  801f47:	09 f3                	or     %esi,%ebx
  801f49:	89 c6                	mov    %eax,%esi
  801f4b:	89 f2                	mov    %esi,%edx
  801f4d:	89 d8                	mov    %ebx,%eax
  801f4f:	f7 74 24 08          	divl   0x8(%esp)
  801f53:	89 d6                	mov    %edx,%esi
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	f7 64 24 0c          	mull   0xc(%esp)
  801f5b:	39 d6                	cmp    %edx,%esi
  801f5d:	72 19                	jb     801f78 <__udivdi3+0x108>
  801f5f:	89 f9                	mov    %edi,%ecx
  801f61:	d3 e5                	shl    %cl,%ebp
  801f63:	39 c5                	cmp    %eax,%ebp
  801f65:	73 04                	jae    801f6b <__udivdi3+0xfb>
  801f67:	39 d6                	cmp    %edx,%esi
  801f69:	74 0d                	je     801f78 <__udivdi3+0x108>
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	31 ff                	xor    %edi,%edi
  801f6f:	e9 3c ff ff ff       	jmp    801eb0 <__udivdi3+0x40>
  801f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f7b:	31 ff                	xor    %edi,%edi
  801f7d:	e9 2e ff ff ff       	jmp    801eb0 <__udivdi3+0x40>
  801f82:	66 90                	xchg   %ax,%ax
  801f84:	66 90                	xchg   %ax,%ax
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	66 90                	xchg   %ax,%ax
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	66 90                	xchg   %ax,%ax
  801f8e:	66 90                	xchg   %ax,%ax

00801f90 <__umoddi3>:
  801f90:	f3 0f 1e fb          	endbr32 
  801f94:	55                   	push   %ebp
  801f95:	57                   	push   %edi
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
  801f98:	83 ec 1c             	sub    $0x1c,%esp
  801f9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801fa3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801fa7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  801fab:	89 f0                	mov    %esi,%eax
  801fad:	89 da                	mov    %ebx,%edx
  801faf:	85 ff                	test   %edi,%edi
  801fb1:	75 15                	jne    801fc8 <__umoddi3+0x38>
  801fb3:	39 dd                	cmp    %ebx,%ebp
  801fb5:	76 39                	jbe    801ff0 <__umoddi3+0x60>
  801fb7:	f7 f5                	div    %ebp
  801fb9:	89 d0                	mov    %edx,%eax
  801fbb:	31 d2                	xor    %edx,%edx
  801fbd:	83 c4 1c             	add    $0x1c,%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5f                   	pop    %edi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    
  801fc5:	8d 76 00             	lea    0x0(%esi),%esi
  801fc8:	39 df                	cmp    %ebx,%edi
  801fca:	77 f1                	ja     801fbd <__umoddi3+0x2d>
  801fcc:	0f bd cf             	bsr    %edi,%ecx
  801fcf:	83 f1 1f             	xor    $0x1f,%ecx
  801fd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd6:	75 40                	jne    802018 <__umoddi3+0x88>
  801fd8:	39 df                	cmp    %ebx,%edi
  801fda:	72 04                	jb     801fe0 <__umoddi3+0x50>
  801fdc:	39 f5                	cmp    %esi,%ebp
  801fde:	77 dd                	ja     801fbd <__umoddi3+0x2d>
  801fe0:	89 da                	mov    %ebx,%edx
  801fe2:	89 f0                	mov    %esi,%eax
  801fe4:	29 e8                	sub    %ebp,%eax
  801fe6:	19 fa                	sbb    %edi,%edx
  801fe8:	eb d3                	jmp    801fbd <__umoddi3+0x2d>
  801fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ff0:	89 e9                	mov    %ebp,%ecx
  801ff2:	85 ed                	test   %ebp,%ebp
  801ff4:	75 0b                	jne    802001 <__umoddi3+0x71>
  801ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	f7 f5                	div    %ebp
  801fff:	89 c1                	mov    %eax,%ecx
  802001:	89 d8                	mov    %ebx,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	f7 f1                	div    %ecx
  802007:	89 f0                	mov    %esi,%eax
  802009:	f7 f1                	div    %ecx
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	31 d2                	xor    %edx,%edx
  80200f:	eb ac                	jmp    801fbd <__umoddi3+0x2d>
  802011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802018:	8b 44 24 04          	mov    0x4(%esp),%eax
  80201c:	ba 20 00 00 00       	mov    $0x20,%edx
  802021:	29 c2                	sub    %eax,%edx
  802023:	89 c1                	mov    %eax,%ecx
  802025:	89 e8                	mov    %ebp,%eax
  802027:	d3 e7                	shl    %cl,%edi
  802029:	89 d1                	mov    %edx,%ecx
  80202b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80202f:	d3 e8                	shr    %cl,%eax
  802031:	89 c1                	mov    %eax,%ecx
  802033:	8b 44 24 04          	mov    0x4(%esp),%eax
  802037:	09 f9                	or     %edi,%ecx
  802039:	89 df                	mov    %ebx,%edi
  80203b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80203f:	89 c1                	mov    %eax,%ecx
  802041:	d3 e5                	shl    %cl,%ebp
  802043:	89 d1                	mov    %edx,%ecx
  802045:	d3 ef                	shr    %cl,%edi
  802047:	89 c1                	mov    %eax,%ecx
  802049:	89 f0                	mov    %esi,%eax
  80204b:	d3 e3                	shl    %cl,%ebx
  80204d:	89 d1                	mov    %edx,%ecx
  80204f:	89 fa                	mov    %edi,%edx
  802051:	d3 e8                	shr    %cl,%eax
  802053:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802058:	09 d8                	or     %ebx,%eax
  80205a:	f7 74 24 08          	divl   0x8(%esp)
  80205e:	89 d3                	mov    %edx,%ebx
  802060:	d3 e6                	shl    %cl,%esi
  802062:	f7 e5                	mul    %ebp
  802064:	89 c7                	mov    %eax,%edi
  802066:	89 d1                	mov    %edx,%ecx
  802068:	39 d3                	cmp    %edx,%ebx
  80206a:	72 06                	jb     802072 <__umoddi3+0xe2>
  80206c:	75 0e                	jne    80207c <__umoddi3+0xec>
  80206e:	39 c6                	cmp    %eax,%esi
  802070:	73 0a                	jae    80207c <__umoddi3+0xec>
  802072:	29 e8                	sub    %ebp,%eax
  802074:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802078:	89 d1                	mov    %edx,%ecx
  80207a:	89 c7                	mov    %eax,%edi
  80207c:	89 f5                	mov    %esi,%ebp
  80207e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802082:	29 fd                	sub    %edi,%ebp
  802084:	19 cb                	sbb    %ecx,%ebx
  802086:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80208b:	89 d8                	mov    %ebx,%eax
  80208d:	d3 e0                	shl    %cl,%eax
  80208f:	89 f1                	mov    %esi,%ecx
  802091:	d3 ed                	shr    %cl,%ebp
  802093:	d3 eb                	shr    %cl,%ebx
  802095:	09 e8                	or     %ebp,%eax
  802097:	89 da                	mov    %ebx,%edx
  802099:	83 c4 1c             	add    $0x1c,%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5f                   	pop    %edi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
