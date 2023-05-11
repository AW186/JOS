
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 00 40 80 00       	push   $0x804000
  800048:	56                   	push   %esi
  800049:	e8 9f 11 00 00       	call   8011ed <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 00 40 80 00       	push   $0x804000
  800060:	6a 01                	push   $0x1
  800062:	e8 54 12 00 00       	call   8012bb <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	push   0xc(%ebp)
  800075:	68 60 20 80 00       	push   $0x802060
  80007a:	6a 0d                	push   $0xd
  80007c:	68 7b 20 80 00       	push   $0x80207b
  800081:	e8 ff 00 00 00       	call   800185 <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	push   0xc(%ebp)
  800096:	68 86 20 80 00       	push   $0x802086
  80009b:	6a 0f                	push   $0xf
  80009d:	68 7b 20 80 00       	push   $0x80207b
  8000a2:	e8 de 00 00 00       	call   800185 <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 9b 	movl   $0x80209b,0x803000
  8000ba:	20 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	be 01 00 00 00       	mov    $0x1,%esi
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 9f 20 80 00       	push   $0x80209f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 b7             	push   (%edi,%esi,4)
  8000e9:	68 a7 20 80 00       	push   $0x8020a7
  8000ee:	e8 3d 17 00 00       	call   801830 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c6 01             	add    $0x1,%esi
  8000f9:	3b 75 08             	cmp    0x8(%ebp),%esi
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 b7             	push   (%edi,%esi,4)
  800106:	e8 83 15 00 00       	call   80168e <open>
  80010b:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 b7             	push   (%edi,%esi,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 1c 24             	mov    %ebx,(%esp)
  800123:	e8 89 0f 00 00       	call   8010b1 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800138:	e8 a6 0b 00 00       	call   800ce3 <sys_getenvid>
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800145:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014a:	a3 00 60 80 00       	mov    %eax,0x806000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014f:	85 db                	test   %ebx,%ebx
  800151:	7e 07                	jle    80015a <libmain+0x2d>
		binaryname = argv[0];
  800153:	8b 06                	mov    (%esi),%eax
  800155:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	e8 43 ff ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  800164:	e8 0a 00 00 00       	call   800173 <exit>
}
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800179:	6a 00                	push   $0x0
  80017b:	e8 22 0b 00 00       	call   800ca2 <sys_env_destroy>
}
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80018a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80018d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800193:	e8 4b 0b 00 00       	call   800ce3 <sys_getenvid>
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	ff 75 0c             	push   0xc(%ebp)
  80019e:	ff 75 08             	push   0x8(%ebp)
  8001a1:	56                   	push   %esi
  8001a2:	50                   	push   %eax
  8001a3:	68 c4 20 80 00       	push   $0x8020c4
  8001a8:	e8 b3 00 00 00       	call   800260 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ad:	83 c4 18             	add    $0x18,%esp
  8001b0:	53                   	push   %ebx
  8001b1:	ff 75 10             	push   0x10(%ebp)
  8001b4:	e8 56 00 00 00       	call   80020f <vcprintf>
	cprintf("\n");
  8001b9:	c7 04 24 04 25 80 00 	movl   $0x802504,(%esp)
  8001c0:	e8 9b 00 00 00       	call   800260 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c8:	cc                   	int3   
  8001c9:	eb fd                	jmp    8001c8 <_panic+0x43>

008001cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d5:	8b 13                	mov    (%ebx),%edx
  8001d7:	8d 42 01             	lea    0x1(%edx),%eax
  8001da:	89 03                	mov    %eax,(%ebx)
  8001dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001df:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e8:	74 09                	je     8001f3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ea:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	68 ff 00 00 00       	push   $0xff
  8001fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 61 0a 00 00       	call   800c65 <sys_cputs>
		b->idx = 0;
  800204:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	eb db                	jmp    8001ea <putch+0x1f>

0080020f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800218:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021f:	00 00 00 
	b.cnt = 0;
  800222:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800229:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022c:	ff 75 0c             	push   0xc(%ebp)
  80022f:	ff 75 08             	push   0x8(%ebp)
  800232:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800238:	50                   	push   %eax
  800239:	68 cb 01 80 00       	push   $0x8001cb
  80023e:	e8 14 01 00 00       	call   800357 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800243:	83 c4 08             	add    $0x8,%esp
  800246:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80024c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800252:	50                   	push   %eax
  800253:	e8 0d 0a 00 00       	call   800c65 <sys_cputs>

	return b.cnt;
}
  800258:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800266:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800269:	50                   	push   %eax
  80026a:	ff 75 08             	push   0x8(%ebp)
  80026d:	e8 9d ff ff ff       	call   80020f <vcprintf>
	va_end(ap);

	return cnt;
}
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 1c             	sub    $0x1c,%esp
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	89 d6                	mov    %edx,%esi
  800281:	8b 45 08             	mov    0x8(%ebp),%eax
  800284:	8b 55 0c             	mov    0xc(%ebp),%edx
  800287:	89 d1                	mov    %edx,%ecx
  800289:	89 c2                	mov    %eax,%edx
  80028b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800291:	8b 45 10             	mov    0x10(%ebp),%eax
  800294:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800297:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80029a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002a1:	39 c2                	cmp    %eax,%edx
  8002a3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002a6:	72 3e                	jb     8002e6 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 18             	push   0x18(%ebp)
  8002ae:	83 eb 01             	sub    $0x1,%ebx
  8002b1:	53                   	push   %ebx
  8002b2:	50                   	push   %eax
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	ff 75 e4             	push   -0x1c(%ebp)
  8002b9:	ff 75 e0             	push   -0x20(%ebp)
  8002bc:	ff 75 dc             	push   -0x24(%ebp)
  8002bf:	ff 75 d8             	push   -0x28(%ebp)
  8002c2:	e8 59 1b 00 00       	call   801e20 <__udivdi3>
  8002c7:	83 c4 18             	add    $0x18,%esp
  8002ca:	52                   	push   %edx
  8002cb:	50                   	push   %eax
  8002cc:	89 f2                	mov    %esi,%edx
  8002ce:	89 f8                	mov    %edi,%eax
  8002d0:	e8 9f ff ff ff       	call   800274 <printnum>
  8002d5:	83 c4 20             	add    $0x20,%esp
  8002d8:	eb 13                	jmp    8002ed <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	56                   	push   %esi
  8002de:	ff 75 18             	push   0x18(%ebp)
  8002e1:	ff d7                	call   *%edi
  8002e3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002e6:	83 eb 01             	sub    $0x1,%ebx
  8002e9:	85 db                	test   %ebx,%ebx
  8002eb:	7f ed                	jg     8002da <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	56                   	push   %esi
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	ff 75 e4             	push   -0x1c(%ebp)
  8002f7:	ff 75 e0             	push   -0x20(%ebp)
  8002fa:	ff 75 dc             	push   -0x24(%ebp)
  8002fd:	ff 75 d8             	push   -0x28(%ebp)
  800300:	e8 3b 1c 00 00       	call   801f40 <__umoddi3>
  800305:	83 c4 14             	add    $0x14,%esp
  800308:	0f be 80 e7 20 80 00 	movsbl 0x8020e7(%eax),%eax
  80030f:	50                   	push   %eax
  800310:	ff d7                	call   *%edi
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5f                   	pop    %edi
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800323:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800327:	8b 10                	mov    (%eax),%edx
  800329:	3b 50 04             	cmp    0x4(%eax),%edx
  80032c:	73 0a                	jae    800338 <sprintputch+0x1b>
		*b->buf++ = ch;
  80032e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800331:	89 08                	mov    %ecx,(%eax)
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	88 02                	mov    %al,(%edx)
}
  800338:	5d                   	pop    %ebp
  800339:	c3                   	ret    

0080033a <printfmt>:
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800340:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800343:	50                   	push   %eax
  800344:	ff 75 10             	push   0x10(%ebp)
  800347:	ff 75 0c             	push   0xc(%ebp)
  80034a:	ff 75 08             	push   0x8(%ebp)
  80034d:	e8 05 00 00 00       	call   800357 <vprintfmt>
}
  800352:	83 c4 10             	add    $0x10,%esp
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <vprintfmt>:
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	57                   	push   %edi
  80035b:	56                   	push   %esi
  80035c:	53                   	push   %ebx
  80035d:	83 ec 3c             	sub    $0x3c,%esp
  800360:	8b 75 08             	mov    0x8(%ebp),%esi
  800363:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800366:	8b 7d 10             	mov    0x10(%ebp),%edi
  800369:	eb 0a                	jmp    800375 <vprintfmt+0x1e>
			putch(ch, putdat);
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	53                   	push   %ebx
  80036f:	50                   	push   %eax
  800370:	ff d6                	call   *%esi
  800372:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800375:	83 c7 01             	add    $0x1,%edi
  800378:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80037c:	83 f8 25             	cmp    $0x25,%eax
  80037f:	74 0c                	je     80038d <vprintfmt+0x36>
			if (ch == '\0')
  800381:	85 c0                	test   %eax,%eax
  800383:	75 e6                	jne    80036b <vprintfmt+0x14>
}
  800385:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800388:	5b                   	pop    %ebx
  800389:	5e                   	pop    %esi
  80038a:	5f                   	pop    %edi
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    
		padc = ' ';
  80038d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800391:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800398:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80039f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003a6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8d 47 01             	lea    0x1(%edi),%eax
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b1:	0f b6 17             	movzbl (%edi),%edx
  8003b4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b7:	3c 55                	cmp    $0x55,%al
  8003b9:	0f 87 a6 04 00 00    	ja     800865 <vprintfmt+0x50e>
  8003bf:	0f b6 c0             	movzbl %al,%eax
  8003c2:	ff 24 85 20 22 80 00 	jmp    *0x802220(,%eax,4)
  8003c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8003cc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d0:	eb d9                	jmp    8003ab <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8003d5:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003d9:	eb d0                	jmp    8003ab <vprintfmt+0x54>
  8003db:	0f b6 d2             	movzbl %dl,%edx
  8003de:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8003e9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ec:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003f6:	83 f9 09             	cmp    $0x9,%ecx
  8003f9:	77 55                	ja     800450 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003fb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003fe:	eb e9                	jmp    8003e9 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 40 04             	lea    0x4(%eax),%eax
  80040e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800414:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800418:	79 91                	jns    8003ab <vprintfmt+0x54>
				width = precision, precision = -1;
  80041a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800420:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800427:	eb 82                	jmp    8003ab <vprintfmt+0x54>
  800429:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80042c:	85 d2                	test   %edx,%edx
  80042e:	b8 00 00 00 00       	mov    $0x0,%eax
  800433:	0f 49 c2             	cmovns %edx,%eax
  800436:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80043c:	e9 6a ff ff ff       	jmp    8003ab <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800444:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80044b:	e9 5b ff ff ff       	jmp    8003ab <vprintfmt+0x54>
  800450:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb bc                	jmp    800414 <vprintfmt+0xbd>
			lflag++;
  800458:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80045e:	e9 48 ff ff ff       	jmp    8003ab <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 78 04             	lea    0x4(%eax),%edi
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	53                   	push   %ebx
  80046d:	ff 30                	push   (%eax)
  80046f:	ff d6                	call   *%esi
			break;
  800471:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800477:	e9 88 03 00 00       	jmp    800804 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	8b 10                	mov    (%eax),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	f7 d8                	neg    %eax
  800488:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048b:	83 f8 0f             	cmp    $0xf,%eax
  80048e:	7f 23                	jg     8004b3 <vprintfmt+0x15c>
  800490:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	74 18                	je     8004b3 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80049b:	52                   	push   %edx
  80049c:	68 b1 24 80 00       	push   $0x8024b1
  8004a1:	53                   	push   %ebx
  8004a2:	56                   	push   %esi
  8004a3:	e8 92 fe ff ff       	call   80033a <printfmt>
  8004a8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ab:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ae:	e9 51 03 00 00       	jmp    800804 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8004b3:	50                   	push   %eax
  8004b4:	68 ff 20 80 00       	push   $0x8020ff
  8004b9:	53                   	push   %ebx
  8004ba:	56                   	push   %esi
  8004bb:	e8 7a fe ff ff       	call   80033a <printfmt>
  8004c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c6:	e9 39 03 00 00       	jmp    800804 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	83 c0 04             	add    $0x4,%eax
  8004d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004d9:	85 d2                	test   %edx,%edx
  8004db:	b8 f8 20 80 00       	mov    $0x8020f8,%eax
  8004e0:	0f 45 c2             	cmovne %edx,%eax
  8004e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ea:	7e 06                	jle    8004f2 <vprintfmt+0x19b>
  8004ec:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004f0:	75 0d                	jne    8004ff <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f5:	89 c7                	mov    %eax,%edi
  8004f7:	03 45 d4             	add    -0x2c(%ebp),%eax
  8004fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004fd:	eb 55                	jmp    800554 <vprintfmt+0x1fd>
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 e0             	push   -0x20(%ebp)
  800505:	ff 75 cc             	push   -0x34(%ebp)
  800508:	e8 f5 03 00 00       	call   800902 <strnlen>
  80050d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800510:	29 c2                	sub    %eax,%edx
  800512:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80051a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80051e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	eb 0f                	jmp    800532 <vprintfmt+0x1db>
					putch(padc, putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	53                   	push   %ebx
  800527:	ff 75 d4             	push   -0x2c(%ebp)
  80052a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80052c:	83 ef 01             	sub    $0x1,%edi
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	85 ff                	test   %edi,%edi
  800534:	7f ed                	jg     800523 <vprintfmt+0x1cc>
  800536:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800539:	85 d2                	test   %edx,%edx
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	0f 49 c2             	cmovns %edx,%eax
  800543:	29 c2                	sub    %eax,%edx
  800545:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800548:	eb a8                	jmp    8004f2 <vprintfmt+0x19b>
					putch(ch, putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	52                   	push   %edx
  80054f:	ff d6                	call   *%esi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800557:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800559:	83 c7 01             	add    $0x1,%edi
  80055c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800560:	0f be d0             	movsbl %al,%edx
  800563:	85 d2                	test   %edx,%edx
  800565:	74 4b                	je     8005b2 <vprintfmt+0x25b>
  800567:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056b:	78 06                	js     800573 <vprintfmt+0x21c>
  80056d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800571:	78 1e                	js     800591 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800573:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800577:	74 d1                	je     80054a <vprintfmt+0x1f3>
  800579:	0f be c0             	movsbl %al,%eax
  80057c:	83 e8 20             	sub    $0x20,%eax
  80057f:	83 f8 5e             	cmp    $0x5e,%eax
  800582:	76 c6                	jbe    80054a <vprintfmt+0x1f3>
					putch('?', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 3f                	push   $0x3f
  80058a:	ff d6                	call   *%esi
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	eb c3                	jmp    800554 <vprintfmt+0x1fd>
  800591:	89 cf                	mov    %ecx,%edi
  800593:	eb 0e                	jmp    8005a3 <vprintfmt+0x24c>
				putch(' ', putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	6a 20                	push   $0x20
  80059b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80059d:	83 ef 01             	sub    $0x1,%edi
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	85 ff                	test   %edi,%edi
  8005a5:	7f ee                	jg     800595 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	e9 52 02 00 00       	jmp    800804 <vprintfmt+0x4ad>
  8005b2:	89 cf                	mov    %ecx,%edi
  8005b4:	eb ed                	jmp    8005a3 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	83 c0 04             	add    $0x4,%eax
  8005bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005c4:	85 d2                	test   %edx,%edx
  8005c6:	b8 f8 20 80 00       	mov    $0x8020f8,%eax
  8005cb:	0f 45 c2             	cmovne %edx,%eax
  8005ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d5:	7e 06                	jle    8005dd <vprintfmt+0x286>
  8005d7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005db:	75 0d                	jne    8005ea <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e0:	89 c7                	mov    %eax,%edi
  8005e2:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005e8:	eb 55                	jmp    80063f <vprintfmt+0x2e8>
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 e0             	push   -0x20(%ebp)
  8005f0:	ff 75 cc             	push   -0x34(%ebp)
  8005f3:	e8 0a 03 00 00       	call   800902 <strnlen>
  8005f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800605:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800609:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80060c:	eb 0f                	jmp    80061d <vprintfmt+0x2c6>
					putch(padc, putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	ff 75 d4             	push   -0x2c(%ebp)
  800615:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800617:	83 ef 01             	sub    $0x1,%edi
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	85 ff                	test   %edi,%edi
  80061f:	7f ed                	jg     80060e <vprintfmt+0x2b7>
  800621:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800624:	85 d2                	test   %edx,%edx
  800626:	b8 00 00 00 00       	mov    $0x0,%eax
  80062b:	0f 49 c2             	cmovns %edx,%eax
  80062e:	29 c2                	sub    %eax,%edx
  800630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800633:	eb a8                	jmp    8005dd <vprintfmt+0x286>
					putch(ch, putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	52                   	push   %edx
  80063a:	ff d6                	call   *%esi
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800642:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800644:	83 c7 01             	add    $0x1,%edi
  800647:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80064b:	0f be d0             	movsbl %al,%edx
  80064e:	3c 3a                	cmp    $0x3a,%al
  800650:	74 4b                	je     80069d <vprintfmt+0x346>
  800652:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800656:	78 06                	js     80065e <vprintfmt+0x307>
  800658:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80065c:	78 1e                	js     80067c <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80065e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800662:	74 d1                	je     800635 <vprintfmt+0x2de>
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 e8 20             	sub    $0x20,%eax
  80066a:	83 f8 5e             	cmp    $0x5e,%eax
  80066d:	76 c6                	jbe    800635 <vprintfmt+0x2de>
					putch('?', putdat);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	53                   	push   %ebx
  800673:	6a 3f                	push   $0x3f
  800675:	ff d6                	call   *%esi
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	eb c3                	jmp    80063f <vprintfmt+0x2e8>
  80067c:	89 cf                	mov    %ecx,%edi
  80067e:	eb 0e                	jmp    80068e <vprintfmt+0x337>
				putch(' ', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 20                	push   $0x20
  800686:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800688:	83 ef 01             	sub    $0x1,%edi
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	85 ff                	test   %edi,%edi
  800690:	7f ee                	jg     800680 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800692:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	e9 67 01 00 00       	jmp    800804 <vprintfmt+0x4ad>
  80069d:	89 cf                	mov    %ecx,%edi
  80069f:	eb ed                	jmp    80068e <vprintfmt+0x337>
	if (lflag >= 2)
  8006a1:	83 f9 01             	cmp    $0x1,%ecx
  8006a4:	7f 1b                	jg     8006c1 <vprintfmt+0x36a>
	else if (lflag)
  8006a6:	85 c9                	test   %ecx,%ecx
  8006a8:	74 63                	je     80070d <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	99                   	cltd   
  8006b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	eb 17                	jmp    8006d8 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 40 08             	lea    0x8(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8006de:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006e3:	85 c9                	test   %ecx,%ecx
  8006e5:	0f 89 ff 00 00 00    	jns    8007ea <vprintfmt+0x493>
				putch('-', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 2d                	push   $0x2d
  8006f1:	ff d6                	call   *%esi
				num = -(long long) num;
  8006f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006f9:	f7 da                	neg    %edx
  8006fb:	83 d1 00             	adc    $0x0,%ecx
  8006fe:	f7 d9                	neg    %ecx
  800700:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800703:	bf 0a 00 00 00       	mov    $0xa,%edi
  800708:	e9 dd 00 00 00       	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, int);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800715:	99                   	cltd   
  800716:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
  800722:	eb b4                	jmp    8006d8 <vprintfmt+0x381>
	if (lflag >= 2)
  800724:	83 f9 01             	cmp    $0x1,%ecx
  800727:	7f 1e                	jg     800747 <vprintfmt+0x3f0>
	else if (lflag)
  800729:	85 c9                	test   %ecx,%ecx
  80072b:	74 32                	je     80075f <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800742:	e9 a3 00 00 00       	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 10                	mov    (%eax),%edx
  80074c:	8b 48 04             	mov    0x4(%eax),%ecx
  80074f:	8d 40 08             	lea    0x8(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800755:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80075a:	e9 8b 00 00 00       	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 10                	mov    (%eax),%edx
  800764:	b9 00 00 00 00       	mov    $0x0,%ecx
  800769:	8d 40 04             	lea    0x4(%eax),%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076f:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800774:	eb 74                	jmp    8007ea <vprintfmt+0x493>
	if (lflag >= 2)
  800776:	83 f9 01             	cmp    $0x1,%ecx
  800779:	7f 1b                	jg     800796 <vprintfmt+0x43f>
	else if (lflag)
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	74 2c                	je     8007ab <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 10                	mov    (%eax),%edx
  800784:	b9 00 00 00 00       	mov    $0x0,%ecx
  800789:	8d 40 04             	lea    0x4(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800794:	eb 54                	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	8b 48 04             	mov    0x4(%eax),%ecx
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a4:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8007a9:	eb 3f                	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 10                	mov    (%eax),%edx
  8007b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b5:	8d 40 04             	lea    0x4(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bb:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8007c0:	eb 28                	jmp    8007ea <vprintfmt+0x493>
			putch('0', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 30                	push   $0x30
  8007c8:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ca:	83 c4 08             	add    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 78                	push   $0x78
  8007d0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 10                	mov    (%eax),%edx
  8007d7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007dc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007df:	8d 40 04             	lea    0x4(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e5:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8007ea:	83 ec 0c             	sub    $0xc,%esp
  8007ed:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 d4             	push   -0x2c(%ebp)
  8007f5:	57                   	push   %edi
  8007f6:	51                   	push   %ecx
  8007f7:	52                   	push   %edx
  8007f8:	89 da                	mov    %ebx,%edx
  8007fa:	89 f0                	mov    %esi,%eax
  8007fc:	e8 73 fa ff ff       	call   800274 <printnum>
			break;
  800801:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800804:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800807:	e9 69 fb ff ff       	jmp    800375 <vprintfmt+0x1e>
	if (lflag >= 2)
  80080c:	83 f9 01             	cmp    $0x1,%ecx
  80080f:	7f 1b                	jg     80082c <vprintfmt+0x4d5>
	else if (lflag)
  800811:	85 c9                	test   %ecx,%ecx
  800813:	74 2c                	je     800841 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800825:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  80082a:	eb be                	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 10                	mov    (%eax),%edx
  800831:	8b 48 04             	mov    0x4(%eax),%ecx
  800834:	8d 40 08             	lea    0x8(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083a:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80083f:	eb a9                	jmp    8007ea <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 10                	mov    (%eax),%edx
  800846:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084b:	8d 40 04             	lea    0x4(%eax),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800851:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800856:	eb 92                	jmp    8007ea <vprintfmt+0x493>
			putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	6a 25                	push   $0x25
  80085e:	ff d6                	call   *%esi
			break;
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	eb 9f                	jmp    800804 <vprintfmt+0x4ad>
			putch('%', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 25                	push   $0x25
  80086b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 f8                	mov    %edi,%eax
  800872:	eb 03                	jmp    800877 <vprintfmt+0x520>
  800874:	83 e8 01             	sub    $0x1,%eax
  800877:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087b:	75 f7                	jne    800874 <vprintfmt+0x51d>
  80087d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800880:	eb 82                	jmp    800804 <vprintfmt+0x4ad>

00800882 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 18             	sub    $0x18,%esp
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800891:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800895:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 26                	je     8008c9 <vsnprintf+0x47>
  8008a3:	85 d2                	test   %edx,%edx
  8008a5:	7e 22                	jle    8008c9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a7:	ff 75 14             	push   0x14(%ebp)
  8008aa:	ff 75 10             	push   0x10(%ebp)
  8008ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b0:	50                   	push   %eax
  8008b1:	68 1d 03 80 00       	push   $0x80031d
  8008b6:	e8 9c fa ff ff       	call   800357 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    
		return -E_INVAL;
  8008c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ce:	eb f7                	jmp    8008c7 <vsnprintf+0x45>

008008d0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d9:	50                   	push   %eax
  8008da:	ff 75 10             	push   0x10(%ebp)
  8008dd:	ff 75 0c             	push   0xc(%ebp)
  8008e0:	ff 75 08             	push   0x8(%ebp)
  8008e3:	e8 9a ff ff ff       	call   800882 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f5:	eb 03                	jmp    8008fa <strlen+0x10>
		n++;
  8008f7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008fa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fe:	75 f7                	jne    8008f7 <strlen+0xd>
	return n;
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800908:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
  800910:	eb 03                	jmp    800915 <strnlen+0x13>
		n++;
  800912:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800915:	39 d0                	cmp    %edx,%eax
  800917:	74 08                	je     800921 <strnlen+0x1f>
  800919:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091d:	75 f3                	jne    800912 <strnlen+0x10>
  80091f:	89 c2                	mov    %eax,%edx
	return n;
}
  800921:	89 d0                	mov    %edx,%eax
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	53                   	push   %ebx
  800929:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80092f:	b8 00 00 00 00       	mov    $0x0,%eax
  800934:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800938:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	84 d2                	test   %dl,%dl
  800940:	75 f2                	jne    800934 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800942:	89 c8                	mov    %ecx,%eax
  800944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	53                   	push   %ebx
  80094d:	83 ec 10             	sub    $0x10,%esp
  800950:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800953:	53                   	push   %ebx
  800954:	e8 91 ff ff ff       	call   8008ea <strlen>
  800959:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80095c:	ff 75 0c             	push   0xc(%ebp)
  80095f:	01 d8                	add    %ebx,%eax
  800961:	50                   	push   %eax
  800962:	e8 be ff ff ff       	call   800925 <strcpy>
	return dst;
}
  800967:	89 d8                	mov    %ebx,%eax
  800969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 75 08             	mov    0x8(%ebp),%esi
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
  800979:	89 f3                	mov    %esi,%ebx
  80097b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097e:	89 f0                	mov    %esi,%eax
  800980:	eb 0f                	jmp    800991 <strncpy+0x23>
		*dst++ = *src;
  800982:	83 c0 01             	add    $0x1,%eax
  800985:	0f b6 0a             	movzbl (%edx),%ecx
  800988:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098b:	80 f9 01             	cmp    $0x1,%cl
  80098e:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800991:	39 d8                	cmp    %ebx,%eax
  800993:	75 ed                	jne    800982 <strncpy+0x14>
	}
	return ret;
}
  800995:	89 f0                	mov    %esi,%eax
  800997:	5b                   	pop    %ebx
  800998:	5e                   	pop    %esi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009a9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	74 21                	je     8009d0 <strlcpy+0x35>
  8009af:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009b3:	89 f2                	mov    %esi,%edx
  8009b5:	eb 09                	jmp    8009c0 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b7:	83 c1 01             	add    $0x1,%ecx
  8009ba:	83 c2 01             	add    $0x1,%edx
  8009bd:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	74 09                	je     8009cd <strlcpy+0x32>
  8009c4:	0f b6 19             	movzbl (%ecx),%ebx
  8009c7:	84 db                	test   %bl,%bl
  8009c9:	75 ec                	jne    8009b7 <strlcpy+0x1c>
  8009cb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d0:	29 f0                	sub    %esi,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009df:	eb 06                	jmp    8009e7 <strcmp+0x11>
		p++, q++;
  8009e1:	83 c1 01             	add    $0x1,%ecx
  8009e4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009e7:	0f b6 01             	movzbl (%ecx),%eax
  8009ea:	84 c0                	test   %al,%al
  8009ec:	74 04                	je     8009f2 <strcmp+0x1c>
  8009ee:	3a 02                	cmp    (%edx),%al
  8009f0:	74 ef                	je     8009e1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f2:	0f b6 c0             	movzbl %al,%eax
  8009f5:	0f b6 12             	movzbl (%edx),%edx
  8009f8:	29 d0                	sub    %edx,%eax
}
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	53                   	push   %ebx
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a06:	89 c3                	mov    %eax,%ebx
  800a08:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a0b:	eb 06                	jmp    800a13 <strncmp+0x17>
		n--, p++, q++;
  800a0d:	83 c0 01             	add    $0x1,%eax
  800a10:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a13:	39 d8                	cmp    %ebx,%eax
  800a15:	74 18                	je     800a2f <strncmp+0x33>
  800a17:	0f b6 08             	movzbl (%eax),%ecx
  800a1a:	84 c9                	test   %cl,%cl
  800a1c:	74 04                	je     800a22 <strncmp+0x26>
  800a1e:	3a 0a                	cmp    (%edx),%cl
  800a20:	74 eb                	je     800a0d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a22:	0f b6 00             	movzbl (%eax),%eax
  800a25:	0f b6 12             	movzbl (%edx),%edx
  800a28:	29 d0                	sub    %edx,%eax
}
  800a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    
		return 0;
  800a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a34:	eb f4                	jmp    800a2a <strncmp+0x2e>

00800a36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a40:	eb 03                	jmp    800a45 <strchr+0xf>
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	0f b6 10             	movzbl (%eax),%edx
  800a48:	84 d2                	test   %dl,%dl
  800a4a:	74 06                	je     800a52 <strchr+0x1c>
		if (*s == c)
  800a4c:	38 ca                	cmp    %cl,%dl
  800a4e:	75 f2                	jne    800a42 <strchr+0xc>
  800a50:	eb 05                	jmp    800a57 <strchr+0x21>
			return (char *) s;
	return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a63:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a66:	38 ca                	cmp    %cl,%dl
  800a68:	74 09                	je     800a73 <strfind+0x1a>
  800a6a:	84 d2                	test   %dl,%dl
  800a6c:	74 05                	je     800a73 <strfind+0x1a>
	for (; *s; s++)
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	eb f0                	jmp    800a63 <strfind+0xa>
			break;
	return (char *) s;
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	57                   	push   %edi
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a81:	85 c9                	test   %ecx,%ecx
  800a83:	74 2f                	je     800ab4 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a85:	89 f8                	mov    %edi,%eax
  800a87:	09 c8                	or     %ecx,%eax
  800a89:	a8 03                	test   $0x3,%al
  800a8b:	75 21                	jne    800aae <memset+0x39>
		c &= 0xFF;
  800a8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a91:	89 d0                	mov    %edx,%eax
  800a93:	c1 e0 08             	shl    $0x8,%eax
  800a96:	89 d3                	mov    %edx,%ebx
  800a98:	c1 e3 18             	shl    $0x18,%ebx
  800a9b:	89 d6                	mov    %edx,%esi
  800a9d:	c1 e6 10             	shl    $0x10,%esi
  800aa0:	09 f3                	or     %esi,%ebx
  800aa2:	09 da                	or     %ebx,%edx
  800aa4:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aa6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa9:	fc                   	cld    
  800aaa:	f3 ab                	rep stos %eax,%es:(%edi)
  800aac:	eb 06                	jmp    800ab4 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	fc                   	cld    
  800ab2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ab4:	89 f8                	mov    %edi,%eax
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5f                   	pop    %edi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	57                   	push   %edi
  800abf:	56                   	push   %esi
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac9:	39 c6                	cmp    %eax,%esi
  800acb:	73 32                	jae    800aff <memmove+0x44>
  800acd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad0:	39 c2                	cmp    %eax,%edx
  800ad2:	76 2b                	jbe    800aff <memmove+0x44>
		s += n;
		d += n;
  800ad4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad7:	89 d6                	mov    %edx,%esi
  800ad9:	09 fe                	or     %edi,%esi
  800adb:	09 ce                	or     %ecx,%esi
  800add:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae3:	75 0e                	jne    800af3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae5:	83 ef 04             	sub    $0x4,%edi
  800ae8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aee:	fd                   	std    
  800aef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af1:	eb 09                	jmp    800afc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af3:	83 ef 01             	sub    $0x1,%edi
  800af6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af9:	fd                   	std    
  800afa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afc:	fc                   	cld    
  800afd:	eb 1a                	jmp    800b19 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	89 f2                	mov    %esi,%edx
  800b01:	09 c2                	or     %eax,%edx
  800b03:	09 ca                	or     %ecx,%edx
  800b05:	f6 c2 03             	test   $0x3,%dl
  800b08:	75 0a                	jne    800b14 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b0d:	89 c7                	mov    %eax,%edi
  800b0f:	fc                   	cld    
  800b10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b12:	eb 05                	jmp    800b19 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b14:	89 c7                	mov    %eax,%edi
  800b16:	fc                   	cld    
  800b17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b23:	ff 75 10             	push   0x10(%ebp)
  800b26:	ff 75 0c             	push   0xc(%ebp)
  800b29:	ff 75 08             	push   0x8(%ebp)
  800b2c:	e8 8a ff ff ff       	call   800abb <memmove>
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3e:	89 c6                	mov    %eax,%esi
  800b40:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b43:	eb 06                	jmp    800b4b <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b45:	83 c0 01             	add    $0x1,%eax
  800b48:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b4b:	39 f0                	cmp    %esi,%eax
  800b4d:	74 14                	je     800b63 <memcmp+0x30>
		if (*s1 != *s2)
  800b4f:	0f b6 08             	movzbl (%eax),%ecx
  800b52:	0f b6 1a             	movzbl (%edx),%ebx
  800b55:	38 d9                	cmp    %bl,%cl
  800b57:	74 ec                	je     800b45 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b59:	0f b6 c1             	movzbl %cl,%eax
  800b5c:	0f b6 db             	movzbl %bl,%ebx
  800b5f:	29 d8                	sub    %ebx,%eax
  800b61:	eb 05                	jmp    800b68 <memcmp+0x35>
	}

	return 0;
  800b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	eb 03                	jmp    800b7f <memfind+0x13>
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	39 d0                	cmp    %edx,%eax
  800b81:	73 04                	jae    800b87 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b83:	38 08                	cmp    %cl,(%eax)
  800b85:	75 f5                	jne    800b7c <memfind+0x10>
			break;
	return (void *) s;
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b95:	eb 03                	jmp    800b9a <strtol+0x11>
		s++;
  800b97:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b9a:	0f b6 02             	movzbl (%edx),%eax
  800b9d:	3c 20                	cmp    $0x20,%al
  800b9f:	74 f6                	je     800b97 <strtol+0xe>
  800ba1:	3c 09                	cmp    $0x9,%al
  800ba3:	74 f2                	je     800b97 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba5:	3c 2b                	cmp    $0x2b,%al
  800ba7:	74 2a                	je     800bd3 <strtol+0x4a>
	int neg = 0;
  800ba9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bae:	3c 2d                	cmp    $0x2d,%al
  800bb0:	74 2b                	je     800bdd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb8:	75 0f                	jne    800bc9 <strtol+0x40>
  800bba:	80 3a 30             	cmpb   $0x30,(%edx)
  800bbd:	74 28                	je     800be7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbf:	85 db                	test   %ebx,%ebx
  800bc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc6:	0f 44 d8             	cmove  %eax,%ebx
  800bc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd1:	eb 46                	jmp    800c19 <strtol+0x90>
		s++;
  800bd3:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdb:	eb d5                	jmp    800bb2 <strtol+0x29>
		s++, neg = 1;
  800bdd:	83 c2 01             	add    $0x1,%edx
  800be0:	bf 01 00 00 00       	mov    $0x1,%edi
  800be5:	eb cb                	jmp    800bb2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be7:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800beb:	74 0e                	je     800bfb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	75 d8                	jne    800bc9 <strtol+0x40>
		s++, base = 8;
  800bf1:	83 c2 01             	add    $0x1,%edx
  800bf4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf9:	eb ce                	jmp    800bc9 <strtol+0x40>
		s += 2, base = 16;
  800bfb:	83 c2 02             	add    $0x2,%edx
  800bfe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c03:	eb c4                	jmp    800bc9 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c05:	0f be c0             	movsbl %al,%eax
  800c08:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c0e:	7d 3a                	jge    800c4a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c10:	83 c2 01             	add    $0x1,%edx
  800c13:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800c17:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800c19:	0f b6 02             	movzbl (%edx),%eax
  800c1c:	8d 70 d0             	lea    -0x30(%eax),%esi
  800c1f:	89 f3                	mov    %esi,%ebx
  800c21:	80 fb 09             	cmp    $0x9,%bl
  800c24:	76 df                	jbe    800c05 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c26:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c29:	89 f3                	mov    %esi,%ebx
  800c2b:	80 fb 19             	cmp    $0x19,%bl
  800c2e:	77 08                	ja     800c38 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c30:	0f be c0             	movsbl %al,%eax
  800c33:	83 e8 57             	sub    $0x57,%eax
  800c36:	eb d3                	jmp    800c0b <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c38:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c3b:	89 f3                	mov    %esi,%ebx
  800c3d:	80 fb 19             	cmp    $0x19,%bl
  800c40:	77 08                	ja     800c4a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c42:	0f be c0             	movsbl %al,%eax
  800c45:	83 e8 37             	sub    $0x37,%eax
  800c48:	eb c1                	jmp    800c0b <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4e:	74 05                	je     800c55 <strtol+0xcc>
		*endptr = (char *) s;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c55:	89 c8                	mov    %ecx,%eax
  800c57:	f7 d8                	neg    %eax
  800c59:	85 ff                	test   %edi,%edi
  800c5b:	0f 45 c8             	cmovne %eax,%ecx
}
  800c5e:	89 c8                	mov    %ecx,%eax
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c76:	89 c3                	mov    %eax,%ebx
  800c78:	89 c7                	mov    %eax,%edi
  800c7a:	89 c6                	mov    %eax,%esi
  800c7c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c93:	89 d1                	mov    %edx,%ecx
  800c95:	89 d3                	mov    %edx,%ebx
  800c97:	89 d7                	mov    %edx,%edi
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9d:	5b                   	pop    %ebx
  800c9e:	5e                   	pop    %esi
  800c9f:	5f                   	pop    %edi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb8:	89 cb                	mov    %ecx,%ebx
  800cba:	89 cf                	mov    %ecx,%edi
  800cbc:	89 ce                	mov    %ecx,%esi
  800cbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	7f 08                	jg     800ccc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccc:	83 ec 0c             	sub    $0xc,%esp
  800ccf:	50                   	push   %eax
  800cd0:	6a 03                	push   $0x3
  800cd2:	68 df 23 80 00       	push   $0x8023df
  800cd7:	6a 23                	push   $0x23
  800cd9:	68 fc 23 80 00       	push   $0x8023fc
  800cde:	e8 a2 f4 ff ff       	call   800185 <_panic>

00800ce3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_yield>:

void
sys_yield(void)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	89 d7                	mov    %edx,%edi
  800d18:	89 d6                	mov    %edx,%esi
  800d1a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2a:	be 00 00 00 00       	mov    $0x0,%esi
  800d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3d:	89 f7                	mov    %esi,%edi
  800d3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7f 08                	jg     800d4d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	83 ec 0c             	sub    $0xc,%esp
  800d50:	50                   	push   %eax
  800d51:	6a 04                	push   $0x4
  800d53:	68 df 23 80 00       	push   $0x8023df
  800d58:	6a 23                	push   $0x23
  800d5a:	68 fc 23 80 00       	push   $0x8023fc
  800d5f:	e8 21 f4 ff ff       	call   800185 <_panic>

00800d64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	b8 05 00 00 00       	mov    $0x5,%eax
  800d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 05                	push   $0x5
  800d95:	68 df 23 80 00       	push   $0x8023df
  800d9a:	6a 23                	push   $0x23
  800d9c:	68 fc 23 80 00       	push   $0x8023fc
  800da1:	e8 df f3 ff ff       	call   800185 <_panic>

00800da6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbf:	89 df                	mov    %ebx,%edi
  800dc1:	89 de                	mov    %ebx,%esi
  800dc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7f 08                	jg     800dd1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	50                   	push   %eax
  800dd5:	6a 06                	push   $0x6
  800dd7:	68 df 23 80 00       	push   $0x8023df
  800ddc:	6a 23                	push   $0x23
  800dde:	68 fc 23 80 00       	push   $0x8023fc
  800de3:	e8 9d f3 ff ff       	call   800185 <_panic>

00800de8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 08 00 00 00       	mov    $0x8,%eax
  800e01:	89 df                	mov    %ebx,%edi
  800e03:	89 de                	mov    %ebx,%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 08                	push   $0x8
  800e19:	68 df 23 80 00       	push   $0x8023df
  800e1e:	6a 23                	push   $0x23
  800e20:	68 fc 23 80 00       	push   $0x8023fc
  800e25:	e8 5b f3 ff ff       	call   800185 <_panic>

00800e2a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e43:	89 df                	mov    %ebx,%edi
  800e45:	89 de                	mov    %ebx,%esi
  800e47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7f 08                	jg     800e55 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	50                   	push   %eax
  800e59:	6a 09                	push   $0x9
  800e5b:	68 df 23 80 00       	push   $0x8023df
  800e60:	6a 23                	push   $0x23
  800e62:	68 fc 23 80 00       	push   $0x8023fc
  800e67:	e8 19 f3 ff ff       	call   800185 <_panic>

00800e6c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e85:	89 df                	mov    %ebx,%edi
  800e87:	89 de                	mov    %ebx,%esi
  800e89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7f 08                	jg     800e97 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	6a 0a                	push   $0xa
  800e9d:	68 df 23 80 00       	push   $0x8023df
  800ea2:	6a 23                	push   $0x23
  800ea4:	68 fc 23 80 00       	push   $0x8023fc
  800ea9:	e8 d7 f2 ff ff       	call   800185 <_panic>

00800eae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ebf:	be 00 00 00 00       	mov    $0x0,%esi
  800ec4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eca:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee7:	89 cb                	mov    %ecx,%ebx
  800ee9:	89 cf                	mov    %ecx,%edi
  800eeb:	89 ce                	mov    %ecx,%esi
  800eed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7f 08                	jg     800efb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	50                   	push   %eax
  800eff:	6a 0d                	push   $0xd
  800f01:	68 df 23 80 00       	push   $0x8023df
  800f06:	6a 23                	push   $0x23
  800f08:	68 fc 23 80 00       	push   $0x8023fc
  800f0d:	e8 73 f2 ff ff       	call   800185 <_panic>

00800f12 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	05 00 00 00 30       	add    $0x30000000,%eax
  800f1d:	c1 e8 0c             	shr    $0xc,%eax
}
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f32:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f41:	89 c2                	mov    %eax,%edx
  800f43:	c1 ea 16             	shr    $0x16,%edx
  800f46:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4d:	f6 c2 01             	test   $0x1,%dl
  800f50:	74 29                	je     800f7b <fd_alloc+0x42>
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	c1 ea 0c             	shr    $0xc,%edx
  800f57:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5e:	f6 c2 01             	test   $0x1,%dl
  800f61:	74 18                	je     800f7b <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  800f63:	05 00 10 00 00       	add    $0x1000,%eax
  800f68:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f6d:	75 d2                	jne    800f41 <fd_alloc+0x8>
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  800f74:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  800f79:	eb 05                	jmp    800f80 <fd_alloc+0x47>
			return 0;
  800f7b:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 02                	mov    %eax,(%edx)
}
  800f85:	89 c8                	mov    %ecx,%eax
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f8f:	83 f8 1f             	cmp    $0x1f,%eax
  800f92:	77 30                	ja     800fc4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f94:	c1 e0 0c             	shl    $0xc,%eax
  800f97:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f9c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fa2:	f6 c2 01             	test   $0x1,%dl
  800fa5:	74 24                	je     800fcb <fd_lookup+0x42>
  800fa7:	89 c2                	mov    %eax,%edx
  800fa9:	c1 ea 0c             	shr    $0xc,%edx
  800fac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb3:	f6 c2 01             	test   $0x1,%dl
  800fb6:	74 1a                	je     800fd2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbb:	89 02                	mov    %eax,(%edx)
	return 0;
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    
		return -E_INVAL;
  800fc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc9:	eb f7                	jmp    800fc2 <fd_lookup+0x39>
		return -E_INVAL;
  800fcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd0:	eb f0                	jmp    800fc2 <fd_lookup+0x39>
  800fd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd7:	eb e9                	jmp    800fc2 <fd_lookup+0x39>

00800fd9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	53                   	push   %ebx
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	b8 88 24 80 00       	mov    $0x802488,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  800fe8:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  800fed:	39 13                	cmp    %edx,(%ebx)
  800fef:	74 32                	je     801023 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	8b 18                	mov    (%eax),%ebx
  800ff6:	85 db                	test   %ebx,%ebx
  800ff8:	75 f3                	jne    800fed <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ffa:	a1 00 60 80 00       	mov    0x806000,%eax
  800fff:	8b 40 48             	mov    0x48(%eax),%eax
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	52                   	push   %edx
  801006:	50                   	push   %eax
  801007:	68 0c 24 80 00       	push   $0x80240c
  80100c:	e8 4f f2 ff ff       	call   800260 <cprintf>
	*dev = 0;
	return -E_INVAL;
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101c:	89 1a                	mov    %ebx,(%edx)
}
  80101e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801021:	c9                   	leave  
  801022:	c3                   	ret    
			return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
  801028:	eb ef                	jmp    801019 <dev_lookup+0x40>

0080102a <fd_close>:
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 24             	sub    $0x24,%esp
  801033:	8b 75 08             	mov    0x8(%ebp),%esi
  801036:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801039:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80103c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801043:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801046:	50                   	push   %eax
  801047:	e8 3d ff ff ff       	call   800f89 <fd_lookup>
  80104c:	89 c3                	mov    %eax,%ebx
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	85 c0                	test   %eax,%eax
  801053:	78 05                	js     80105a <fd_close+0x30>
	    || fd != fd2)
  801055:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801058:	74 16                	je     801070 <fd_close+0x46>
		return (must_exist ? r : 0);
  80105a:	89 f8                	mov    %edi,%eax
  80105c:	84 c0                	test   %al,%al
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
  801063:	0f 44 d8             	cmove  %eax,%ebx
}
  801066:	89 d8                	mov    %ebx,%eax
  801068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801070:	83 ec 08             	sub    $0x8,%esp
  801073:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801076:	50                   	push   %eax
  801077:	ff 36                	push   (%esi)
  801079:	e8 5b ff ff ff       	call   800fd9 <dev_lookup>
  80107e:	89 c3                	mov    %eax,%ebx
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	78 1a                	js     8010a1 <fd_close+0x77>
		if (dev->dev_close)
  801087:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80108a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80108d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801092:	85 c0                	test   %eax,%eax
  801094:	74 0b                	je     8010a1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	56                   	push   %esi
  80109a:	ff d0                	call   *%eax
  80109c:	89 c3                	mov    %eax,%ebx
  80109e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010a1:	83 ec 08             	sub    $0x8,%esp
  8010a4:	56                   	push   %esi
  8010a5:	6a 00                	push   $0x0
  8010a7:	e8 fa fc ff ff       	call   800da6 <sys_page_unmap>
	return r;
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	eb b5                	jmp    801066 <fd_close+0x3c>

008010b1 <close>:

int
close(int fdnum)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 08             	push   0x8(%ebp)
  8010be:	e8 c6 fe ff ff       	call   800f89 <fd_lookup>
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	79 02                	jns    8010cc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    
		return fd_close(fd, 1);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	6a 01                	push   $0x1
  8010d1:	ff 75 f4             	push   -0xc(%ebp)
  8010d4:	e8 51 ff ff ff       	call   80102a <fd_close>
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	eb ec                	jmp    8010ca <close+0x19>

008010de <close_all>:

void
close_all(void)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	53                   	push   %ebx
  8010ee:	e8 be ff ff ff       	call   8010b1 <close>
	for (i = 0; i < MAXFD; i++)
  8010f3:	83 c3 01             	add    $0x1,%ebx
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	83 fb 20             	cmp    $0x20,%ebx
  8010fc:	75 ec                	jne    8010ea <close_all+0xc>
}
  8010fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	57                   	push   %edi
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80110c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110f:	50                   	push   %eax
  801110:	ff 75 08             	push   0x8(%ebp)
  801113:	e8 71 fe ff ff       	call   800f89 <fd_lookup>
  801118:	89 c3                	mov    %eax,%ebx
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	78 7f                	js     8011a0 <dup+0x9d>
		return r;
	close(newfdnum);
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	ff 75 0c             	push   0xc(%ebp)
  801127:	e8 85 ff ff ff       	call   8010b1 <close>

	newfd = INDEX2FD(newfdnum);
  80112c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80112f:	c1 e6 0c             	shl    $0xc,%esi
  801132:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801138:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80113b:	89 3c 24             	mov    %edi,(%esp)
  80113e:	e8 df fd ff ff       	call   800f22 <fd2data>
  801143:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801145:	89 34 24             	mov    %esi,(%esp)
  801148:	e8 d5 fd ff ff       	call   800f22 <fd2data>
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801153:	89 d8                	mov    %ebx,%eax
  801155:	c1 e8 16             	shr    $0x16,%eax
  801158:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115f:	a8 01                	test   $0x1,%al
  801161:	74 11                	je     801174 <dup+0x71>
  801163:	89 d8                	mov    %ebx,%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
  801168:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116f:	f6 c2 01             	test   $0x1,%dl
  801172:	75 36                	jne    8011aa <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801174:	89 f8                	mov    %edi,%eax
  801176:	c1 e8 0c             	shr    $0xc,%eax
  801179:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	25 07 0e 00 00       	and    $0xe07,%eax
  801188:	50                   	push   %eax
  801189:	56                   	push   %esi
  80118a:	6a 00                	push   $0x0
  80118c:	57                   	push   %edi
  80118d:	6a 00                	push   $0x0
  80118f:	e8 d0 fb ff ff       	call   800d64 <sys_page_map>
  801194:	89 c3                	mov    %eax,%ebx
  801196:	83 c4 20             	add    $0x20,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	78 33                	js     8011d0 <dup+0xcd>
		goto err;

	return newfdnum;
  80119d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011a0:	89 d8                	mov    %ebx,%eax
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b9:	50                   	push   %eax
  8011ba:	ff 75 d4             	push   -0x2c(%ebp)
  8011bd:	6a 00                	push   $0x0
  8011bf:	53                   	push   %ebx
  8011c0:	6a 00                	push   $0x0
  8011c2:	e8 9d fb ff ff       	call   800d64 <sys_page_map>
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 20             	add    $0x20,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	79 a4                	jns    801174 <dup+0x71>
	sys_page_unmap(0, newfd);
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	56                   	push   %esi
  8011d4:	6a 00                	push   $0x0
  8011d6:	e8 cb fb ff ff       	call   800da6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011db:	83 c4 08             	add    $0x8,%esp
  8011de:	ff 75 d4             	push   -0x2c(%ebp)
  8011e1:	6a 00                	push   $0x0
  8011e3:	e8 be fb ff ff       	call   800da6 <sys_page_unmap>
	return r;
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	eb b3                	jmp    8011a0 <dup+0x9d>

008011ed <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	56                   	push   %esi
  8011f1:	53                   	push   %ebx
  8011f2:	83 ec 18             	sub    $0x18,%esp
  8011f5:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fb:	50                   	push   %eax
  8011fc:	56                   	push   %esi
  8011fd:	e8 87 fd ff ff       	call   800f89 <fd_lookup>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	78 3c                	js     801245 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801209:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	ff 33                	push   (%ebx)
  801215:	e8 bf fd ff ff       	call   800fd9 <dev_lookup>
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 24                	js     801245 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801221:	8b 43 08             	mov    0x8(%ebx),%eax
  801224:	83 e0 03             	and    $0x3,%eax
  801227:	83 f8 01             	cmp    $0x1,%eax
  80122a:	74 20                	je     80124c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	8b 40 08             	mov    0x8(%eax),%eax
  801232:	85 c0                	test   %eax,%eax
  801234:	74 37                	je     80126d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	ff 75 10             	push   0x10(%ebp)
  80123c:	ff 75 0c             	push   0xc(%ebp)
  80123f:	53                   	push   %ebx
  801240:	ff d0                	call   *%eax
  801242:	83 c4 10             	add    $0x10,%esp
}
  801245:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801248:	5b                   	pop    %ebx
  801249:	5e                   	pop    %esi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124c:	a1 00 60 80 00       	mov    0x806000,%eax
  801251:	8b 40 48             	mov    0x48(%eax),%eax
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	56                   	push   %esi
  801258:	50                   	push   %eax
  801259:	68 4d 24 80 00       	push   $0x80244d
  80125e:	e8 fd ef ff ff       	call   800260 <cprintf>
		return -E_INVAL;
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126b:	eb d8                	jmp    801245 <read+0x58>
		return -E_NOT_SUPP;
  80126d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801272:	eb d1                	jmp    801245 <read+0x58>

00801274 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	57                   	push   %edi
  801278:	56                   	push   %esi
  801279:	53                   	push   %ebx
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801280:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801283:	bb 00 00 00 00       	mov    $0x0,%ebx
  801288:	eb 02                	jmp    80128c <readn+0x18>
  80128a:	01 c3                	add    %eax,%ebx
  80128c:	39 f3                	cmp    %esi,%ebx
  80128e:	73 21                	jae    8012b1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	89 f0                	mov    %esi,%eax
  801295:	29 d8                	sub    %ebx,%eax
  801297:	50                   	push   %eax
  801298:	89 d8                	mov    %ebx,%eax
  80129a:	03 45 0c             	add    0xc(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	57                   	push   %edi
  80129f:	e8 49 ff ff ff       	call   8011ed <read>
		if (m < 0)
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	78 04                	js     8012af <readn+0x3b>
			return m;
		if (m == 0)
  8012ab:	75 dd                	jne    80128a <readn+0x16>
  8012ad:	eb 02                	jmp    8012b1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012af:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
  8012c0:	83 ec 18             	sub    $0x18,%esp
  8012c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	53                   	push   %ebx
  8012cb:	e8 b9 fc ff ff       	call   800f89 <fd_lookup>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 37                	js     80130e <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d7:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	50                   	push   %eax
  8012e1:	ff 36                	push   (%esi)
  8012e3:	e8 f1 fc ff ff       	call   800fd9 <dev_lookup>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 1f                	js     80130e <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ef:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8012f3:	74 20                	je     801315 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 37                	je     801336 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012ff:	83 ec 04             	sub    $0x4,%esp
  801302:	ff 75 10             	push   0x10(%ebp)
  801305:	ff 75 0c             	push   0xc(%ebp)
  801308:	56                   	push   %esi
  801309:	ff d0                	call   *%eax
  80130b:	83 c4 10             	add    $0x10,%esp
}
  80130e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801315:	a1 00 60 80 00       	mov    0x806000,%eax
  80131a:	8b 40 48             	mov    0x48(%eax),%eax
  80131d:	83 ec 04             	sub    $0x4,%esp
  801320:	53                   	push   %ebx
  801321:	50                   	push   %eax
  801322:	68 69 24 80 00       	push   $0x802469
  801327:	e8 34 ef ff ff       	call   800260 <cprintf>
		return -E_INVAL;
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801334:	eb d8                	jmp    80130e <write+0x53>
		return -E_NOT_SUPP;
  801336:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133b:	eb d1                	jmp    80130e <write+0x53>

0080133d <seek>:

int
seek(int fdnum, off_t offset)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801343:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801346:	50                   	push   %eax
  801347:	ff 75 08             	push   0x8(%ebp)
  80134a:	e8 3a fc ff ff       	call   800f89 <fd_lookup>
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 0e                	js     801364 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801356:	8b 55 0c             	mov    0xc(%ebp),%edx
  801359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	56                   	push   %esi
  80136a:	53                   	push   %ebx
  80136b:	83 ec 18             	sub    $0x18,%esp
  80136e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801371:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	53                   	push   %ebx
  801376:	e8 0e fc ff ff       	call   800f89 <fd_lookup>
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 34                	js     8013b6 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801382:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801385:	83 ec 08             	sub    $0x8,%esp
  801388:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	ff 36                	push   (%esi)
  80138e:	e8 46 fc ff ff       	call   800fd9 <dev_lookup>
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	78 1c                	js     8013b6 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139a:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80139e:	74 1d                	je     8013bd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a3:	8b 40 18             	mov    0x18(%eax),%eax
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 34                	je     8013de <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	ff 75 0c             	push   0xc(%ebp)
  8013b0:	56                   	push   %esi
  8013b1:	ff d0                	call   *%eax
  8013b3:	83 c4 10             	add    $0x10,%esp
}
  8013b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013bd:	a1 00 60 80 00       	mov    0x806000,%eax
  8013c2:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	53                   	push   %ebx
  8013c9:	50                   	push   %eax
  8013ca:	68 2c 24 80 00       	push   $0x80242c
  8013cf:	e8 8c ee ff ff       	call   800260 <cprintf>
		return -E_INVAL;
  8013d4:	83 c4 10             	add    $0x10,%esp
  8013d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013dc:	eb d8                	jmp    8013b6 <ftruncate+0x50>
		return -E_NOT_SUPP;
  8013de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e3:	eb d1                	jmp    8013b6 <ftruncate+0x50>

008013e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
  8013ea:	83 ec 18             	sub    $0x18,%esp
  8013ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 08             	push   0x8(%ebp)
  8013f7:	e8 8d fb ff ff       	call   800f89 <fd_lookup>
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	78 49                	js     80144c <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801403:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	ff 36                	push   (%esi)
  80140f:	e8 c5 fb ff ff       	call   800fd9 <dev_lookup>
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	78 31                	js     80144c <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801422:	74 2f                	je     801453 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801424:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801427:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80142e:	00 00 00 
	stat->st_isdir = 0;
  801431:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801438:	00 00 00 
	stat->st_dev = dev;
  80143b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	53                   	push   %ebx
  801445:	56                   	push   %esi
  801446:	ff 50 14             	call   *0x14(%eax)
  801449:	83 c4 10             	add    $0x10,%esp
}
  80144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    
		return -E_NOT_SUPP;
  801453:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801458:	eb f2                	jmp    80144c <fstat+0x67>

0080145a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	56                   	push   %esi
  80145e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	6a 00                	push   $0x0
  801464:	ff 75 08             	push   0x8(%ebp)
  801467:	e8 22 02 00 00       	call   80168e <open>
  80146c:	89 c3                	mov    %eax,%ebx
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 1b                	js     801490 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	ff 75 0c             	push   0xc(%ebp)
  80147b:	50                   	push   %eax
  80147c:	e8 64 ff ff ff       	call   8013e5 <fstat>
  801481:	89 c6                	mov    %eax,%esi
	close(fd);
  801483:	89 1c 24             	mov    %ebx,(%esp)
  801486:	e8 26 fc ff ff       	call   8010b1 <close>
	return r;
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 f3                	mov    %esi,%ebx
}
  801490:	89 d8                	mov    %ebx,%eax
  801492:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    

00801499 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	89 c6                	mov    %eax,%esi
  8014a0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014a2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8014a9:	74 27                	je     8014d2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ab:	6a 07                	push   $0x7
  8014ad:	68 00 70 80 00       	push   $0x807000
  8014b2:	56                   	push   %esi
  8014b3:	ff 35 00 80 80 00    	push   0x808000
  8014b9:	e8 95 08 00 00       	call   801d53 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014be:	83 c4 0c             	add    $0xc,%esp
  8014c1:	6a 00                	push   $0x0
  8014c3:	53                   	push   %ebx
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 39 08 00 00       	call   801d04 <ipc_recv>
}
  8014cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ce:	5b                   	pop    %ebx
  8014cf:	5e                   	pop    %esi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	6a 01                	push   $0x1
  8014d7:	e8 c3 08 00 00       	call   801d9f <ipc_find_env>
  8014dc:	a3 00 80 80 00       	mov    %eax,0x808000
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	eb c5                	jmp    8014ab <fsipc+0x12>

008014e6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f2:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801504:	b8 02 00 00 00       	mov    $0x2,%eax
  801509:	e8 8b ff ff ff       	call   801499 <fsipc>
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <devfile_flush>:
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8b 40 0c             	mov    0xc(%eax),%eax
  80151c:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	b8 06 00 00 00       	mov    $0x6,%eax
  80152b:	e8 69 ff ff ff       	call   801499 <fsipc>
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <devfile_stat>:
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8b 40 0c             	mov    0xc(%eax),%eax
  801542:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801547:	ba 00 00 00 00       	mov    $0x0,%edx
  80154c:	b8 05 00 00 00       	mov    $0x5,%eax
  801551:	e8 43 ff ff ff       	call   801499 <fsipc>
  801556:	85 c0                	test   %eax,%eax
  801558:	78 2c                	js     801586 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	68 00 70 80 00       	push   $0x807000
  801562:	53                   	push   %ebx
  801563:	e8 bd f3 ff ff       	call   800925 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801568:	a1 80 70 80 00       	mov    0x807080,%eax
  80156d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801573:	a1 84 70 80 00       	mov    0x807084,%eax
  801578:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <devfile_write>:
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	53                   	push   %ebx
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8b 40 0c             	mov    0xc(%eax),%eax
  80159b:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8015a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8015a6:	53                   	push   %ebx
  8015a7:	ff 75 0c             	push   0xc(%ebp)
  8015aa:	68 08 70 80 00       	push   $0x807008
  8015af:	e8 69 f5 ff ff       	call   800b1d <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b9:	b8 04 00 00 00       	mov    $0x4,%eax
  8015be:	e8 d6 fe ff ff       	call   801499 <fsipc>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 0b                	js     8015d5 <devfile_write+0x4a>
	assert(r <= n);
  8015ca:	39 d8                	cmp    %ebx,%eax
  8015cc:	77 0c                	ja     8015da <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8015ce:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015d3:	7f 1e                	jg     8015f3 <devfile_write+0x68>
}
  8015d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    
	assert(r <= n);
  8015da:	68 98 24 80 00       	push   $0x802498
  8015df:	68 9f 24 80 00       	push   $0x80249f
  8015e4:	68 97 00 00 00       	push   $0x97
  8015e9:	68 b4 24 80 00       	push   $0x8024b4
  8015ee:	e8 92 eb ff ff       	call   800185 <_panic>
	assert(r <= PGSIZE);
  8015f3:	68 bf 24 80 00       	push   $0x8024bf
  8015f8:	68 9f 24 80 00       	push   $0x80249f
  8015fd:	68 98 00 00 00       	push   $0x98
  801602:	68 b4 24 80 00       	push   $0x8024b4
  801607:	e8 79 eb ff ff       	call   800185 <_panic>

0080160c <devfile_read>:
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	56                   	push   %esi
  801610:	53                   	push   %ebx
  801611:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	8b 40 0c             	mov    0xc(%eax),%eax
  80161a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80161f:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	b8 03 00 00 00       	mov    $0x3,%eax
  80162f:	e8 65 fe ff ff       	call   801499 <fsipc>
  801634:	89 c3                	mov    %eax,%ebx
  801636:	85 c0                	test   %eax,%eax
  801638:	78 1f                	js     801659 <devfile_read+0x4d>
	assert(r <= n);
  80163a:	39 f0                	cmp    %esi,%eax
  80163c:	77 24                	ja     801662 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80163e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801643:	7f 33                	jg     801678 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	50                   	push   %eax
  801649:	68 00 70 80 00       	push   $0x807000
  80164e:	ff 75 0c             	push   0xc(%ebp)
  801651:	e8 65 f4 ff ff       	call   800abb <memmove>
	return r;
  801656:	83 c4 10             	add    $0x10,%esp
}
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165e:	5b                   	pop    %ebx
  80165f:	5e                   	pop    %esi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    
	assert(r <= n);
  801662:	68 98 24 80 00       	push   $0x802498
  801667:	68 9f 24 80 00       	push   $0x80249f
  80166c:	6a 7c                	push   $0x7c
  80166e:	68 b4 24 80 00       	push   $0x8024b4
  801673:	e8 0d eb ff ff       	call   800185 <_panic>
	assert(r <= PGSIZE);
  801678:	68 bf 24 80 00       	push   $0x8024bf
  80167d:	68 9f 24 80 00       	push   $0x80249f
  801682:	6a 7d                	push   $0x7d
  801684:	68 b4 24 80 00       	push   $0x8024b4
  801689:	e8 f7 ea ff ff       	call   800185 <_panic>

0080168e <open>:
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
  801693:	83 ec 1c             	sub    $0x1c,%esp
  801696:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801699:	56                   	push   %esi
  80169a:	e8 4b f2 ff ff       	call   8008ea <strlen>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016a7:	7f 6c                	jg     801715 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016af:	50                   	push   %eax
  8016b0:	e8 84 f8 ff ff       	call   800f39 <fd_alloc>
  8016b5:	89 c3                	mov    %eax,%ebx
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 3c                	js     8016fa <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	56                   	push   %esi
  8016c2:	68 00 70 80 00       	push   $0x807000
  8016c7:	e8 59 f2 ff ff       	call   800925 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cf:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016dc:	e8 b8 fd ff ff       	call   801499 <fsipc>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 19                	js     801703 <open+0x75>
	return fd2num(fd);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	ff 75 f4             	push   -0xc(%ebp)
  8016f0:	e8 1d f8 ff ff       	call   800f12 <fd2num>
  8016f5:	89 c3                	mov    %eax,%ebx
  8016f7:	83 c4 10             	add    $0x10,%esp
}
  8016fa:	89 d8                	mov    %ebx,%eax
  8016fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    
		fd_close(fd, 0);
  801703:	83 ec 08             	sub    $0x8,%esp
  801706:	6a 00                	push   $0x0
  801708:	ff 75 f4             	push   -0xc(%ebp)
  80170b:	e8 1a f9 ff ff       	call   80102a <fd_close>
		return r;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	eb e5                	jmp    8016fa <open+0x6c>
		return -E_BAD_PATH;
  801715:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80171a:	eb de                	jmp    8016fa <open+0x6c>

0080171c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 08 00 00 00       	mov    $0x8,%eax
  80172c:	e8 68 fd ff ff       	call   801499 <fsipc>
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801733:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801737:	7f 01                	jg     80173a <writebuf+0x7>
  801739:	c3                   	ret    
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801743:	ff 70 04             	push   0x4(%eax)
  801746:	8d 40 10             	lea    0x10(%eax),%eax
  801749:	50                   	push   %eax
  80174a:	ff 33                	push   (%ebx)
  80174c:	e8 6a fb ff ff       	call   8012bb <write>
		if (result > 0)
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	7e 03                	jle    80175b <writebuf+0x28>
			b->result += result;
  801758:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80175b:	39 43 04             	cmp    %eax,0x4(%ebx)
  80175e:	74 0d                	je     80176d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801760:	85 c0                	test   %eax,%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	0f 4f c2             	cmovg  %edx,%eax
  80176a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80176d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <putch>:

static void
putch(int ch, void *thunk)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	53                   	push   %ebx
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80177c:	8b 53 04             	mov    0x4(%ebx),%edx
  80177f:	8d 42 01             	lea    0x1(%edx),%eax
  801782:	89 43 04             	mov    %eax,0x4(%ebx)
  801785:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801788:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80178c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801791:	74 05                	je     801798 <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  801793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801796:	c9                   	leave  
  801797:	c3                   	ret    
		writebuf(b);
  801798:	89 d8                	mov    %ebx,%eax
  80179a:	e8 94 ff ff ff       	call   801733 <writebuf>
		b->idx = 0;
  80179f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017a6:	eb eb                	jmp    801793 <putch+0x21>

008017a8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017ba:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017c1:	00 00 00 
	b.result = 0;
  8017c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017cb:	00 00 00 
	b.error = 1;
  8017ce:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017d5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017d8:	ff 75 10             	push   0x10(%ebp)
  8017db:	ff 75 0c             	push   0xc(%ebp)
  8017de:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017e4:	50                   	push   %eax
  8017e5:	68 72 17 80 00       	push   $0x801772
  8017ea:	e8 68 eb ff ff       	call   800357 <vprintfmt>
	if (b.idx > 0)
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8017f9:	7f 11                	jg     80180c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8017fb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801801:	85 c0                	test   %eax,%eax
  801803:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    
		writebuf(&b);
  80180c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801812:	e8 1c ff ff ff       	call   801733 <writebuf>
  801817:	eb e2                	jmp    8017fb <vfprintf+0x53>

00801819 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80181f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801822:	50                   	push   %eax
  801823:	ff 75 0c             	push   0xc(%ebp)
  801826:	ff 75 08             	push   0x8(%ebp)
  801829:	e8 7a ff ff ff       	call   8017a8 <vfprintf>
	va_end(ap);

	return cnt;
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <printf>:

int
printf(const char *fmt, ...)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801836:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801839:	50                   	push   %eax
  80183a:	ff 75 08             	push   0x8(%ebp)
  80183d:	6a 01                	push   $0x1
  80183f:	e8 64 ff ff ff       	call   8017a8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	ff 75 08             	push   0x8(%ebp)
  801854:	e8 c9 f6 ff ff       	call   800f22 <fd2data>
  801859:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80185b:	83 c4 08             	add    $0x8,%esp
  80185e:	68 cb 24 80 00       	push   $0x8024cb
  801863:	53                   	push   %ebx
  801864:	e8 bc f0 ff ff       	call   800925 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801869:	8b 46 04             	mov    0x4(%esi),%eax
  80186c:	2b 06                	sub    (%esi),%eax
  80186e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801874:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80187b:	00 00 00 
	stat->st_dev = &devpipe;
  80187e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801885:	30 80 00 
	return 0;
}
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
  80188d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801890:	5b                   	pop    %ebx
  801891:	5e                   	pop    %esi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80189e:	53                   	push   %ebx
  80189f:	6a 00                	push   $0x0
  8018a1:	e8 00 f5 ff ff       	call   800da6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018a6:	89 1c 24             	mov    %ebx,(%esp)
  8018a9:	e8 74 f6 ff ff       	call   800f22 <fd2data>
  8018ae:	83 c4 08             	add    $0x8,%esp
  8018b1:	50                   	push   %eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	e8 ed f4 ff ff       	call   800da6 <sys_page_unmap>
}
  8018b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <_pipeisclosed>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	57                   	push   %edi
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 1c             	sub    $0x1c,%esp
  8018c7:	89 c7                	mov    %eax,%edi
  8018c9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018cb:	a1 00 60 80 00       	mov    0x806000,%eax
  8018d0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	57                   	push   %edi
  8018d7:	e8 fc 04 00 00       	call   801dd8 <pageref>
  8018dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018df:	89 34 24             	mov    %esi,(%esp)
  8018e2:	e8 f1 04 00 00       	call   801dd8 <pageref>
		nn = thisenv->env_runs;
  8018e7:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8018ed:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	39 cb                	cmp    %ecx,%ebx
  8018f5:	74 1b                	je     801912 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018f7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018fa:	75 cf                	jne    8018cb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018fc:	8b 42 58             	mov    0x58(%edx),%eax
  8018ff:	6a 01                	push   $0x1
  801901:	50                   	push   %eax
  801902:	53                   	push   %ebx
  801903:	68 d2 24 80 00       	push   $0x8024d2
  801908:	e8 53 e9 ff ff       	call   800260 <cprintf>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	eb b9                	jmp    8018cb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801912:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801915:	0f 94 c0             	sete   %al
  801918:	0f b6 c0             	movzbl %al,%eax
}
  80191b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5f                   	pop    %edi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <devpipe_write>:
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	57                   	push   %edi
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 28             	sub    $0x28,%esp
  80192c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80192f:	56                   	push   %esi
  801930:	e8 ed f5 ff ff       	call   800f22 <fd2data>
  801935:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	bf 00 00 00 00       	mov    $0x0,%edi
  80193f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801942:	75 09                	jne    80194d <devpipe_write+0x2a>
	return i;
  801944:	89 f8                	mov    %edi,%eax
  801946:	eb 23                	jmp    80196b <devpipe_write+0x48>
			sys_yield();
  801948:	e8 b5 f3 ff ff       	call   800d02 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80194d:	8b 43 04             	mov    0x4(%ebx),%eax
  801950:	8b 0b                	mov    (%ebx),%ecx
  801952:	8d 51 20             	lea    0x20(%ecx),%edx
  801955:	39 d0                	cmp    %edx,%eax
  801957:	72 1a                	jb     801973 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801959:	89 da                	mov    %ebx,%edx
  80195b:	89 f0                	mov    %esi,%eax
  80195d:	e8 5c ff ff ff       	call   8018be <_pipeisclosed>
  801962:	85 c0                	test   %eax,%eax
  801964:	74 e2                	je     801948 <devpipe_write+0x25>
				return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5f                   	pop    %edi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801976:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80197a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80197d:	89 c2                	mov    %eax,%edx
  80197f:	c1 fa 1f             	sar    $0x1f,%edx
  801982:	89 d1                	mov    %edx,%ecx
  801984:	c1 e9 1b             	shr    $0x1b,%ecx
  801987:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80198a:	83 e2 1f             	and    $0x1f,%edx
  80198d:	29 ca                	sub    %ecx,%edx
  80198f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801993:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801997:	83 c0 01             	add    $0x1,%eax
  80199a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80199d:	83 c7 01             	add    $0x1,%edi
  8019a0:	eb 9d                	jmp    80193f <devpipe_write+0x1c>

008019a2 <devpipe_read>:
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 18             	sub    $0x18,%esp
  8019ab:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019ae:	57                   	push   %edi
  8019af:	e8 6e f5 ff ff       	call   800f22 <fd2data>
  8019b4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	be 00 00 00 00       	mov    $0x0,%esi
  8019be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019c1:	75 13                	jne    8019d6 <devpipe_read+0x34>
	return i;
  8019c3:	89 f0                	mov    %esi,%eax
  8019c5:	eb 02                	jmp    8019c9 <devpipe_read+0x27>
				return i;
  8019c7:	89 f0                	mov    %esi,%eax
}
  8019c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
			sys_yield();
  8019d1:	e8 2c f3 ff ff       	call   800d02 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8019d6:	8b 03                	mov    (%ebx),%eax
  8019d8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019db:	75 18                	jne    8019f5 <devpipe_read+0x53>
			if (i > 0)
  8019dd:	85 f6                	test   %esi,%esi
  8019df:	75 e6                	jne    8019c7 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  8019e1:	89 da                	mov    %ebx,%edx
  8019e3:	89 f8                	mov    %edi,%eax
  8019e5:	e8 d4 fe ff ff       	call   8018be <_pipeisclosed>
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	74 e3                	je     8019d1 <devpipe_read+0x2f>
				return 0;
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	eb d4                	jmp    8019c9 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019f5:	99                   	cltd   
  8019f6:	c1 ea 1b             	shr    $0x1b,%edx
  8019f9:	01 d0                	add    %edx,%eax
  8019fb:	83 e0 1f             	and    $0x1f,%eax
  8019fe:	29 d0                	sub    %edx,%eax
  801a00:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a08:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a0b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a0e:	83 c6 01             	add    $0x1,%esi
  801a11:	eb ab                	jmp    8019be <devpipe_read+0x1c>

00801a13 <pipe>:
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	e8 15 f5 ff ff       	call   800f39 <fd_alloc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	0f 88 23 01 00 00    	js     801b54 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 07 04 00 00       	push   $0x407
  801a39:	ff 75 f4             	push   -0xc(%ebp)
  801a3c:	6a 00                	push   $0x0
  801a3e:	e8 de f2 ff ff       	call   800d21 <sys_page_alloc>
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	0f 88 04 01 00 00    	js     801b54 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a56:	50                   	push   %eax
  801a57:	e8 dd f4 ff ff       	call   800f39 <fd_alloc>
  801a5c:	89 c3                	mov    %eax,%ebx
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	0f 88 db 00 00 00    	js     801b44 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 07 04 00 00       	push   $0x407
  801a71:	ff 75 f0             	push   -0x10(%ebp)
  801a74:	6a 00                	push   $0x0
  801a76:	e8 a6 f2 ff ff       	call   800d21 <sys_page_alloc>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	0f 88 bc 00 00 00    	js     801b44 <pipe+0x131>
	va = fd2data(fd0);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 f4             	push   -0xc(%ebp)
  801a8e:	e8 8f f4 ff ff       	call   800f22 <fd2data>
  801a93:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a95:	83 c4 0c             	add    $0xc,%esp
  801a98:	68 07 04 00 00       	push   $0x407
  801a9d:	50                   	push   %eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	e8 7c f2 ff ff       	call   800d21 <sys_page_alloc>
  801aa5:	89 c3                	mov    %eax,%ebx
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	0f 88 82 00 00 00    	js     801b34 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	ff 75 f0             	push   -0x10(%ebp)
  801ab8:	e8 65 f4 ff ff       	call   800f22 <fd2data>
  801abd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ac4:	50                   	push   %eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	56                   	push   %esi
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 95 f2 ff ff       	call   800d64 <sys_page_map>
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	83 c4 20             	add    $0x20,%esp
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 4e                	js     801b26 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ad8:	a1 20 30 80 00       	mov    0x803020,%eax
  801add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801aec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aef:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	ff 75 f4             	push   -0xc(%ebp)
  801b01:	e8 0c f4 ff ff       	call   800f12 <fd2num>
  801b06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b09:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b0b:	83 c4 04             	add    $0x4,%esp
  801b0e:	ff 75 f0             	push   -0x10(%ebp)
  801b11:	e8 fc f3 ff ff       	call   800f12 <fd2num>
  801b16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b19:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b24:	eb 2e                	jmp    801b54 <pipe+0x141>
	sys_page_unmap(0, va);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	56                   	push   %esi
  801b2a:	6a 00                	push   $0x0
  801b2c:	e8 75 f2 ff ff       	call   800da6 <sys_page_unmap>
  801b31:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b34:	83 ec 08             	sub    $0x8,%esp
  801b37:	ff 75 f0             	push   -0x10(%ebp)
  801b3a:	6a 00                	push   $0x0
  801b3c:	e8 65 f2 ff ff       	call   800da6 <sys_page_unmap>
  801b41:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b44:	83 ec 08             	sub    $0x8,%esp
  801b47:	ff 75 f4             	push   -0xc(%ebp)
  801b4a:	6a 00                	push   $0x0
  801b4c:	e8 55 f2 ff ff       	call   800da6 <sys_page_unmap>
  801b51:	83 c4 10             	add    $0x10,%esp
}
  801b54:	89 d8                	mov    %ebx,%eax
  801b56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5e                   	pop    %esi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <pipeisclosed>:
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b66:	50                   	push   %eax
  801b67:	ff 75 08             	push   0x8(%ebp)
  801b6a:	e8 1a f4 ff ff       	call   800f89 <fd_lookup>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 18                	js     801b8e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 f4             	push   -0xc(%ebp)
  801b7c:	e8 a1 f3 ff ff       	call   800f22 <fd2data>
  801b81:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	e8 33 fd ff ff       	call   8018be <_pipeisclosed>
  801b8b:	83 c4 10             	add    $0x10,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	c3                   	ret    

00801b96 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b9c:	68 ea 24 80 00       	push   $0x8024ea
  801ba1:	ff 75 0c             	push   0xc(%ebp)
  801ba4:	e8 7c ed ff ff       	call   800925 <strcpy>
	return 0;
}
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <devcons_write>:
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	57                   	push   %edi
  801bb4:	56                   	push   %esi
  801bb5:	53                   	push   %ebx
  801bb6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bbc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801bc1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801bc7:	eb 2e                	jmp    801bf7 <devcons_write+0x47>
		m = n - tot;
  801bc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bcc:	29 f3                	sub    %esi,%ebx
  801bce:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801bd3:	39 c3                	cmp    %eax,%ebx
  801bd5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	53                   	push   %ebx
  801bdc:	89 f0                	mov    %esi,%eax
  801bde:	03 45 0c             	add    0xc(%ebp),%eax
  801be1:	50                   	push   %eax
  801be2:	57                   	push   %edi
  801be3:	e8 d3 ee ff ff       	call   800abb <memmove>
		sys_cputs(buf, m);
  801be8:	83 c4 08             	add    $0x8,%esp
  801beb:	53                   	push   %ebx
  801bec:	57                   	push   %edi
  801bed:	e8 73 f0 ff ff       	call   800c65 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bf2:	01 de                	add    %ebx,%esi
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfa:	72 cd                	jb     801bc9 <devcons_write+0x19>
}
  801bfc:	89 f0                	mov    %esi,%eax
  801bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5e                   	pop    %esi
  801c03:	5f                   	pop    %edi
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <devcons_read>:
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c15:	75 07                	jne    801c1e <devcons_read+0x18>
  801c17:	eb 1f                	jmp    801c38 <devcons_read+0x32>
		sys_yield();
  801c19:	e8 e4 f0 ff ff       	call   800d02 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c1e:	e8 60 f0 ff ff       	call   800c83 <sys_cgetc>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	74 f2                	je     801c19 <devcons_read+0x13>
	if (c < 0)
  801c27:	78 0f                	js     801c38 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801c29:	83 f8 04             	cmp    $0x4,%eax
  801c2c:	74 0c                	je     801c3a <devcons_read+0x34>
	*(char*)vbuf = c;
  801c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c31:	88 02                	mov    %al,(%edx)
	return 1;
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    
		return 0;
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3f:	eb f7                	jmp    801c38 <devcons_read+0x32>

00801c41 <cputchar>:
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c4d:	6a 01                	push   $0x1
  801c4f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c52:	50                   	push   %eax
  801c53:	e8 0d f0 ff ff       	call   800c65 <sys_cputs>
}
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <getchar>:
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c63:	6a 01                	push   $0x1
  801c65:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c68:	50                   	push   %eax
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 7d f5 ff ff       	call   8011ed <read>
	if (r < 0)
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	85 c0                	test   %eax,%eax
  801c75:	78 06                	js     801c7d <getchar+0x20>
	if (r < 1)
  801c77:	74 06                	je     801c7f <getchar+0x22>
	return c;
  801c79:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    
		return -E_EOF;
  801c7f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c84:	eb f7                	jmp    801c7d <getchar+0x20>

00801c86 <iscons>:
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8f:	50                   	push   %eax
  801c90:	ff 75 08             	push   0x8(%ebp)
  801c93:	e8 f1 f2 ff ff       	call   800f89 <fd_lookup>
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 11                	js     801cb0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ca8:	39 10                	cmp    %edx,(%eax)
  801caa:	0f 94 c0             	sete   %al
  801cad:	0f b6 c0             	movzbl %al,%eax
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <opencons>:
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cbb:	50                   	push   %eax
  801cbc:	e8 78 f2 ff ff       	call   800f39 <fd_alloc>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 3a                	js     801d02 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 07 04 00 00       	push   $0x407
  801cd0:	ff 75 f4             	push   -0xc(%ebp)
  801cd3:	6a 00                	push   $0x0
  801cd5:	e8 47 f0 ff ff       	call   800d21 <sys_page_alloc>
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	78 21                	js     801d02 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	50                   	push   %eax
  801cfa:	e8 13 f2 ff ff       	call   800f12 <fd2num>
  801cff:	83 c4 10             	add    $0x10,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	8b 75 08             	mov    0x8(%ebp),%esi
  801d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 0c             	push   0xc(%ebp)
  801d15:	e8 b7 f1 ff ff       	call   800ed1 <sys_ipc_recv>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 2b                	js     801d4c <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d21:	85 f6                	test   %esi,%esi
  801d23:	74 0a                	je     801d2f <ipc_recv+0x2b>
  801d25:	a1 00 60 80 00       	mov    0x806000,%eax
  801d2a:	8b 40 74             	mov    0x74(%eax),%eax
  801d2d:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d2f:	85 db                	test   %ebx,%ebx
  801d31:	74 0a                	je     801d3d <ipc_recv+0x39>
  801d33:	a1 00 60 80 00       	mov    0x806000,%eax
  801d38:	8b 40 78             	mov    0x78(%eax),%eax
  801d3b:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801d3d:	a1 00 60 80 00       	mov    0x806000,%eax
  801d42:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801d4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d51:	eb f2                	jmp    801d45 <ipc_recv+0x41>

00801d53 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	57                   	push   %edi
  801d57:	56                   	push   %esi
  801d58:	53                   	push   %ebx
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801d65:	ff 75 14             	push   0x14(%ebp)
  801d68:	53                   	push   %ebx
  801d69:	56                   	push   %esi
  801d6a:	57                   	push   %edi
  801d6b:	e8 3e f1 ff ff       	call   800eae <sys_ipc_try_send>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	79 20                	jns    801d97 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801d77:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d7a:	75 07                	jne    801d83 <ipc_send+0x30>
		sys_yield();
  801d7c:	e8 81 ef ff ff       	call   800d02 <sys_yield>
  801d81:	eb e2                	jmp    801d65 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801d83:	83 ec 04             	sub    $0x4,%esp
  801d86:	68 f6 24 80 00       	push   $0x8024f6
  801d8b:	6a 2e                	push   $0x2e
  801d8d:	68 06 25 80 00       	push   $0x802506
  801d92:	e8 ee e3 ff ff       	call   800185 <_panic>
	}
}
  801d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801daa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801db3:	8b 52 50             	mov    0x50(%edx),%edx
  801db6:	39 ca                	cmp    %ecx,%edx
  801db8:	74 11                	je     801dcb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801dba:	83 c0 01             	add    $0x1,%eax
  801dbd:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dc2:	75 e6                	jne    801daa <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc9:	eb 0b                	jmp    801dd6 <ipc_find_env+0x37>
			return envs[i].env_id;
  801dcb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801dce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dd3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    

00801dd8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dde:	89 c2                	mov    %eax,%edx
  801de0:	c1 ea 16             	shr    $0x16,%edx
  801de3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801def:	f6 c1 01             	test   $0x1,%cl
  801df2:	74 1c                	je     801e10 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801df4:	c1 e8 0c             	shr    $0xc,%eax
  801df7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801dfe:	a8 01                	test   $0x1,%al
  801e00:	74 0e                	je     801e10 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e02:	c1 e8 0c             	shr    $0xc,%eax
  801e05:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801e0c:	ef 
  801e0d:	0f b7 d2             	movzwl %dx,%edx
}
  801e10:	89 d0                	mov    %edx,%eax
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    
  801e14:	66 90                	xchg   %ax,%ax
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	66 90                	xchg   %ax,%ax
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	66 90                	xchg   %ax,%ax
  801e1e:	66 90                	xchg   %ax,%ax

00801e20 <__udivdi3>:
  801e20:	f3 0f 1e fb          	endbr32 
  801e24:	55                   	push   %ebp
  801e25:	57                   	push   %edi
  801e26:	56                   	push   %esi
  801e27:	53                   	push   %ebx
  801e28:	83 ec 1c             	sub    $0x1c,%esp
  801e2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e2f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e37:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	75 19                	jne    801e58 <__udivdi3+0x38>
  801e3f:	39 f3                	cmp    %esi,%ebx
  801e41:	76 4d                	jbe    801e90 <__udivdi3+0x70>
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	89 e8                	mov    %ebp,%eax
  801e47:	89 f2                	mov    %esi,%edx
  801e49:	f7 f3                	div    %ebx
  801e4b:	89 fa                	mov    %edi,%edx
  801e4d:	83 c4 1c             	add    $0x1c,%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5f                   	pop    %edi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    
  801e55:	8d 76 00             	lea    0x0(%esi),%esi
  801e58:	39 f0                	cmp    %esi,%eax
  801e5a:	76 14                	jbe    801e70 <__udivdi3+0x50>
  801e5c:	31 ff                	xor    %edi,%edi
  801e5e:	31 c0                	xor    %eax,%eax
  801e60:	89 fa                	mov    %edi,%edx
  801e62:	83 c4 1c             	add    $0x1c,%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5f                   	pop    %edi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    
  801e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e70:	0f bd f8             	bsr    %eax,%edi
  801e73:	83 f7 1f             	xor    $0x1f,%edi
  801e76:	75 48                	jne    801ec0 <__udivdi3+0xa0>
  801e78:	39 f0                	cmp    %esi,%eax
  801e7a:	72 06                	jb     801e82 <__udivdi3+0x62>
  801e7c:	31 c0                	xor    %eax,%eax
  801e7e:	39 eb                	cmp    %ebp,%ebx
  801e80:	77 de                	ja     801e60 <__udivdi3+0x40>
  801e82:	b8 01 00 00 00       	mov    $0x1,%eax
  801e87:	eb d7                	jmp    801e60 <__udivdi3+0x40>
  801e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e90:	89 d9                	mov    %ebx,%ecx
  801e92:	85 db                	test   %ebx,%ebx
  801e94:	75 0b                	jne    801ea1 <__udivdi3+0x81>
  801e96:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9b:	31 d2                	xor    %edx,%edx
  801e9d:	f7 f3                	div    %ebx
  801e9f:	89 c1                	mov    %eax,%ecx
  801ea1:	31 d2                	xor    %edx,%edx
  801ea3:	89 f0                	mov    %esi,%eax
  801ea5:	f7 f1                	div    %ecx
  801ea7:	89 c6                	mov    %eax,%esi
  801ea9:	89 e8                	mov    %ebp,%eax
  801eab:	89 f7                	mov    %esi,%edi
  801ead:	f7 f1                	div    %ecx
  801eaf:	89 fa                	mov    %edi,%edx
  801eb1:	83 c4 1c             	add    $0x1c,%esp
  801eb4:	5b                   	pop    %ebx
  801eb5:	5e                   	pop    %esi
  801eb6:	5f                   	pop    %edi
  801eb7:	5d                   	pop    %ebp
  801eb8:	c3                   	ret    
  801eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ec0:	89 f9                	mov    %edi,%ecx
  801ec2:	ba 20 00 00 00       	mov    $0x20,%edx
  801ec7:	29 fa                	sub    %edi,%edx
  801ec9:	d3 e0                	shl    %cl,%eax
  801ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ecf:	89 d1                	mov    %edx,%ecx
  801ed1:	89 d8                	mov    %ebx,%eax
  801ed3:	d3 e8                	shr    %cl,%eax
  801ed5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ed9:	09 c1                	or     %eax,%ecx
  801edb:	89 f0                	mov    %esi,%eax
  801edd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ee1:	89 f9                	mov    %edi,%ecx
  801ee3:	d3 e3                	shl    %cl,%ebx
  801ee5:	89 d1                	mov    %edx,%ecx
  801ee7:	d3 e8                	shr    %cl,%eax
  801ee9:	89 f9                	mov    %edi,%ecx
  801eeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801eef:	89 eb                	mov    %ebp,%ebx
  801ef1:	d3 e6                	shl    %cl,%esi
  801ef3:	89 d1                	mov    %edx,%ecx
  801ef5:	d3 eb                	shr    %cl,%ebx
  801ef7:	09 f3                	or     %esi,%ebx
  801ef9:	89 c6                	mov    %eax,%esi
  801efb:	89 f2                	mov    %esi,%edx
  801efd:	89 d8                	mov    %ebx,%eax
  801eff:	f7 74 24 08          	divl   0x8(%esp)
  801f03:	89 d6                	mov    %edx,%esi
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	f7 64 24 0c          	mull   0xc(%esp)
  801f0b:	39 d6                	cmp    %edx,%esi
  801f0d:	72 19                	jb     801f28 <__udivdi3+0x108>
  801f0f:	89 f9                	mov    %edi,%ecx
  801f11:	d3 e5                	shl    %cl,%ebp
  801f13:	39 c5                	cmp    %eax,%ebp
  801f15:	73 04                	jae    801f1b <__udivdi3+0xfb>
  801f17:	39 d6                	cmp    %edx,%esi
  801f19:	74 0d                	je     801f28 <__udivdi3+0x108>
  801f1b:	89 d8                	mov    %ebx,%eax
  801f1d:	31 ff                	xor    %edi,%edi
  801f1f:	e9 3c ff ff ff       	jmp    801e60 <__udivdi3+0x40>
  801f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f2b:	31 ff                	xor    %edi,%edi
  801f2d:	e9 2e ff ff ff       	jmp    801e60 <__udivdi3+0x40>
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	66 90                	xchg   %ax,%ax
  801f36:	66 90                	xchg   %ax,%ax
  801f38:	66 90                	xchg   %ax,%ax
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	66 90                	xchg   %ax,%ax
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <__umoddi3>:
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 1c             	sub    $0x1c,%esp
  801f4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f53:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801f57:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  801f5b:	89 f0                	mov    %esi,%eax
  801f5d:	89 da                	mov    %ebx,%edx
  801f5f:	85 ff                	test   %edi,%edi
  801f61:	75 15                	jne    801f78 <__umoddi3+0x38>
  801f63:	39 dd                	cmp    %ebx,%ebp
  801f65:	76 39                	jbe    801fa0 <__umoddi3+0x60>
  801f67:	f7 f5                	div    %ebp
  801f69:	89 d0                	mov    %edx,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	39 df                	cmp    %ebx,%edi
  801f7a:	77 f1                	ja     801f6d <__umoddi3+0x2d>
  801f7c:	0f bd cf             	bsr    %edi,%ecx
  801f7f:	83 f1 1f             	xor    $0x1f,%ecx
  801f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f86:	75 40                	jne    801fc8 <__umoddi3+0x88>
  801f88:	39 df                	cmp    %ebx,%edi
  801f8a:	72 04                	jb     801f90 <__umoddi3+0x50>
  801f8c:	39 f5                	cmp    %esi,%ebp
  801f8e:	77 dd                	ja     801f6d <__umoddi3+0x2d>
  801f90:	89 da                	mov    %ebx,%edx
  801f92:	89 f0                	mov    %esi,%eax
  801f94:	29 e8                	sub    %ebp,%eax
  801f96:	19 fa                	sbb    %edi,%edx
  801f98:	eb d3                	jmp    801f6d <__umoddi3+0x2d>
  801f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fa0:	89 e9                	mov    %ebp,%ecx
  801fa2:	85 ed                	test   %ebp,%ebp
  801fa4:	75 0b                	jne    801fb1 <__umoddi3+0x71>
  801fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fab:	31 d2                	xor    %edx,%edx
  801fad:	f7 f5                	div    %ebp
  801faf:	89 c1                	mov    %eax,%ecx
  801fb1:	89 d8                	mov    %ebx,%eax
  801fb3:	31 d2                	xor    %edx,%edx
  801fb5:	f7 f1                	div    %ecx
  801fb7:	89 f0                	mov    %esi,%eax
  801fb9:	f7 f1                	div    %ecx
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	31 d2                	xor    %edx,%edx
  801fbf:	eb ac                	jmp    801f6d <__umoddi3+0x2d>
  801fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fc8:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fcc:	ba 20 00 00 00       	mov    $0x20,%edx
  801fd1:	29 c2                	sub    %eax,%edx
  801fd3:	89 c1                	mov    %eax,%ecx
  801fd5:	89 e8                	mov    %ebp,%eax
  801fd7:	d3 e7                	shl    %cl,%edi
  801fd9:	89 d1                	mov    %edx,%ecx
  801fdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fdf:	d3 e8                	shr    %cl,%eax
  801fe1:	89 c1                	mov    %eax,%ecx
  801fe3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fe7:	09 f9                	or     %edi,%ecx
  801fe9:	89 df                	mov    %ebx,%edi
  801feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fef:	89 c1                	mov    %eax,%ecx
  801ff1:	d3 e5                	shl    %cl,%ebp
  801ff3:	89 d1                	mov    %edx,%ecx
  801ff5:	d3 ef                	shr    %cl,%edi
  801ff7:	89 c1                	mov    %eax,%ecx
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	d3 e3                	shl    %cl,%ebx
  801ffd:	89 d1                	mov    %edx,%ecx
  801fff:	89 fa                	mov    %edi,%edx
  802001:	d3 e8                	shr    %cl,%eax
  802003:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802008:	09 d8                	or     %ebx,%eax
  80200a:	f7 74 24 08          	divl   0x8(%esp)
  80200e:	89 d3                	mov    %edx,%ebx
  802010:	d3 e6                	shl    %cl,%esi
  802012:	f7 e5                	mul    %ebp
  802014:	89 c7                	mov    %eax,%edi
  802016:	89 d1                	mov    %edx,%ecx
  802018:	39 d3                	cmp    %edx,%ebx
  80201a:	72 06                	jb     802022 <__umoddi3+0xe2>
  80201c:	75 0e                	jne    80202c <__umoddi3+0xec>
  80201e:	39 c6                	cmp    %eax,%esi
  802020:	73 0a                	jae    80202c <__umoddi3+0xec>
  802022:	29 e8                	sub    %ebp,%eax
  802024:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802028:	89 d1                	mov    %edx,%ecx
  80202a:	89 c7                	mov    %eax,%edi
  80202c:	89 f5                	mov    %esi,%ebp
  80202e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802032:	29 fd                	sub    %edi,%ebp
  802034:	19 cb                	sbb    %ecx,%ebx
  802036:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	d3 e0                	shl    %cl,%eax
  80203f:	89 f1                	mov    %esi,%ecx
  802041:	d3 ed                	shr    %cl,%ebp
  802043:	d3 eb                	shr    %cl,%ebx
  802045:	09 e8                	or     %ebp,%eax
  802047:	89 da                	mov    %ebx,%edx
  802049:	83 c4 1c             	add    $0x1c,%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    
