
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 80 11 80 00       	push   $0x801180
  800045:	e8 9e 01 00 00       	call   8001e8 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 4b 0c 00 00       	call   800ca9 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 cc 11 80 00       	push   $0x8011cc
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 e5 07 00 00       	call   800858 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 a0 11 80 00       	push   $0x8011a0
  800085:	6a 0f                	push   $0xf
  800087:	68 8a 11 80 00       	push   $0x80118a
  80008c:	e8 7c 00 00 00       	call   80010d <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 f9 0d 00 00       	call   800e9a <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 3d 0b 00 00       	call   800bed <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 a6 0b 00 00       	call   800c6b <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800101:	6a 00                	push   $0x0
  800103:	e8 22 0b 00 00       	call   800c2a <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800112:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800115:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80011b:	e8 4b 0b 00 00       	call   800c6b <sys_getenvid>
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	ff 75 0c             	push   0xc(%ebp)
  800126:	ff 75 08             	push   0x8(%ebp)
  800129:	56                   	push   %esi
  80012a:	50                   	push   %eax
  80012b:	68 f8 11 80 00       	push   $0x8011f8
  800130:	e8 b3 00 00 00       	call   8001e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800135:	83 c4 18             	add    $0x18,%esp
  800138:	53                   	push   %ebx
  800139:	ff 75 10             	push   0x10(%ebp)
  80013c:	e8 56 00 00 00       	call   800197 <vcprintf>
	cprintf("\n");
  800141:	c7 04 24 88 11 80 00 	movl   $0x801188,(%esp)
  800148:	e8 9b 00 00 00       	call   8001e8 <cprintf>
  80014d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800150:	cc                   	int3   
  800151:	eb fd                	jmp    800150 <_panic+0x43>

00800153 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	53                   	push   %ebx
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015d:	8b 13                	mov    (%ebx),%edx
  80015f:	8d 42 01             	lea    0x1(%edx),%eax
  800162:	89 03                	mov    %eax,(%ebx)
  800164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800167:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	74 09                	je     80017b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800172:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800179:	c9                   	leave  
  80017a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	68 ff 00 00 00       	push   $0xff
  800183:	8d 43 08             	lea    0x8(%ebx),%eax
  800186:	50                   	push   %eax
  800187:	e8 61 0a 00 00       	call   800bed <sys_cputs>
		b->idx = 0;
  80018c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	eb db                	jmp    800172 <putch+0x1f>

00800197 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a7:	00 00 00 
	b.cnt = 0;
  8001aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b4:	ff 75 0c             	push   0xc(%ebp)
  8001b7:	ff 75 08             	push   0x8(%ebp)
  8001ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	68 53 01 80 00       	push   $0x800153
  8001c6:	e8 14 01 00 00       	call   8002df <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cb:	83 c4 08             	add    $0x8,%esp
  8001ce:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001da:	50                   	push   %eax
  8001db:	e8 0d 0a 00 00       	call   800bed <sys_cputs>

	return b.cnt;
}
  8001e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f1:	50                   	push   %eax
  8001f2:	ff 75 08             	push   0x8(%ebp)
  8001f5:	e8 9d ff ff ff       	call   800197 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	57                   	push   %edi
  800200:	56                   	push   %esi
  800201:	53                   	push   %ebx
  800202:	83 ec 1c             	sub    $0x1c,%esp
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 d6                	mov    %edx,%esi
  800209:	8b 45 08             	mov    0x8(%ebp),%eax
  80020c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020f:	89 d1                	mov    %edx,%ecx
  800211:	89 c2                	mov    %eax,%edx
  800213:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800216:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800219:	8b 45 10             	mov    0x10(%ebp),%eax
  80021c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800222:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800229:	39 c2                	cmp    %eax,%edx
  80022b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80022e:	72 3e                	jb     80026e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	ff 75 18             	push   0x18(%ebp)
  800236:	83 eb 01             	sub    $0x1,%ebx
  800239:	53                   	push   %ebx
  80023a:	50                   	push   %eax
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	ff 75 e4             	push   -0x1c(%ebp)
  800241:	ff 75 e0             	push   -0x20(%ebp)
  800244:	ff 75 dc             	push   -0x24(%ebp)
  800247:	ff 75 d8             	push   -0x28(%ebp)
  80024a:	e8 e1 0c 00 00       	call   800f30 <__udivdi3>
  80024f:	83 c4 18             	add    $0x18,%esp
  800252:	52                   	push   %edx
  800253:	50                   	push   %eax
  800254:	89 f2                	mov    %esi,%edx
  800256:	89 f8                	mov    %edi,%eax
  800258:	e8 9f ff ff ff       	call   8001fc <printnum>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	eb 13                	jmp    800275 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	56                   	push   %esi
  800266:	ff 75 18             	push   0x18(%ebp)
  800269:	ff d7                	call   *%edi
  80026b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80026e:	83 eb 01             	sub    $0x1,%ebx
  800271:	85 db                	test   %ebx,%ebx
  800273:	7f ed                	jg     800262 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	56                   	push   %esi
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	ff 75 e4             	push   -0x1c(%ebp)
  80027f:	ff 75 e0             	push   -0x20(%ebp)
  800282:	ff 75 dc             	push   -0x24(%ebp)
  800285:	ff 75 d8             	push   -0x28(%ebp)
  800288:	e8 c3 0d 00 00       	call   801050 <__umoddi3>
  80028d:	83 c4 14             	add    $0x14,%esp
  800290:	0f be 80 1b 12 80 00 	movsbl 0x80121b(%eax),%eax
  800297:	50                   	push   %eax
  800298:	ff d7                	call   *%edi
}
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a0:	5b                   	pop    %ebx
  8002a1:	5e                   	pop    %esi
  8002a2:	5f                   	pop    %edi
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ab:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002af:	8b 10                	mov    (%eax),%edx
  8002b1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b4:	73 0a                	jae    8002c0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b9:	89 08                	mov    %ecx,(%eax)
  8002bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002be:	88 02                	mov    %al,(%edx)
}
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    

008002c2 <printfmt>:
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 10             	push   0x10(%ebp)
  8002cf:	ff 75 0c             	push   0xc(%ebp)
  8002d2:	ff 75 08             	push   0x8(%ebp)
  8002d5:	e8 05 00 00 00       	call   8002df <vprintfmt>
}
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <vprintfmt>:
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	57                   	push   %edi
  8002e3:	56                   	push   %esi
  8002e4:	53                   	push   %ebx
  8002e5:	83 ec 3c             	sub    $0x3c,%esp
  8002e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f1:	eb 0a                	jmp    8002fd <vprintfmt+0x1e>
			putch(ch, putdat);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	53                   	push   %ebx
  8002f7:	50                   	push   %eax
  8002f8:	ff d6                	call   *%esi
  8002fa:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002fd:	83 c7 01             	add    $0x1,%edi
  800300:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800304:	83 f8 25             	cmp    $0x25,%eax
  800307:	74 0c                	je     800315 <vprintfmt+0x36>
			if (ch == '\0')
  800309:	85 c0                	test   %eax,%eax
  80030b:	75 e6                	jne    8002f3 <vprintfmt+0x14>
}
  80030d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800310:	5b                   	pop    %ebx
  800311:	5e                   	pop    %esi
  800312:	5f                   	pop    %edi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    
		padc = ' ';
  800315:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800319:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800320:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800327:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80032e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8d 47 01             	lea    0x1(%edi),%eax
  800336:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800339:	0f b6 17             	movzbl (%edi),%edx
  80033c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033f:	3c 55                	cmp    $0x55,%al
  800341:	0f 87 a6 04 00 00    	ja     8007ed <vprintfmt+0x50e>
  800347:	0f b6 c0             	movzbl %al,%eax
  80034a:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  800351:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800354:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800358:	eb d9                	jmp    800333 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80035d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800361:	eb d0                	jmp    800333 <vprintfmt+0x54>
  800363:	0f b6 d2             	movzbl %dl,%edx
  800366:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800369:	b8 00 00 00 00       	mov    $0x0,%eax
  80036e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800371:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800374:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800378:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80037b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037e:	83 f9 09             	cmp    $0x9,%ecx
  800381:	77 55                	ja     8003d8 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800383:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800386:	eb e9                	jmp    800371 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800388:	8b 45 14             	mov    0x14(%ebp),%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	8d 40 04             	lea    0x4(%eax),%eax
  800396:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80039c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003a0:	79 91                	jns    800333 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003a8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003af:	eb 82                	jmp    800333 <vprintfmt+0x54>
  8003b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003bb:	0f 49 c2             	cmovns %edx,%eax
  8003be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003c4:	e9 6a ff ff ff       	jmp    800333 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003cc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d3:	e9 5b ff ff ff       	jmp    800333 <vprintfmt+0x54>
  8003d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003de:	eb bc                	jmp    80039c <vprintfmt+0xbd>
			lflag++;
  8003e0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003e6:	e9 48 ff ff ff       	jmp    800333 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8d 78 04             	lea    0x4(%eax),%edi
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	53                   	push   %ebx
  8003f5:	ff 30                	push   (%eax)
  8003f7:	ff d6                	call   *%esi
			break;
  8003f9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003fc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ff:	e9 88 03 00 00       	jmp    80078c <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	8d 78 04             	lea    0x4(%eax),%edi
  80040a:	8b 10                	mov    (%eax),%edx
  80040c:	89 d0                	mov    %edx,%eax
  80040e:	f7 d8                	neg    %eax
  800410:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800413:	83 f8 0f             	cmp    $0xf,%eax
  800416:	7f 23                	jg     80043b <vprintfmt+0x15c>
  800418:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  80041f:	85 d2                	test   %edx,%edx
  800421:	74 18                	je     80043b <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800423:	52                   	push   %edx
  800424:	68 3c 12 80 00       	push   $0x80123c
  800429:	53                   	push   %ebx
  80042a:	56                   	push   %esi
  80042b:	e8 92 fe ff ff       	call   8002c2 <printfmt>
  800430:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800433:	89 7d 14             	mov    %edi,0x14(%ebp)
  800436:	e9 51 03 00 00       	jmp    80078c <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80043b:	50                   	push   %eax
  80043c:	68 33 12 80 00       	push   $0x801233
  800441:	53                   	push   %ebx
  800442:	56                   	push   %esi
  800443:	e8 7a fe ff ff       	call   8002c2 <printfmt>
  800448:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044e:	e9 39 03 00 00       	jmp    80078c <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	83 c0 04             	add    $0x4,%eax
  800459:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800461:	85 d2                	test   %edx,%edx
  800463:	b8 2c 12 80 00       	mov    $0x80122c,%eax
  800468:	0f 45 c2             	cmovne %edx,%eax
  80046b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80046e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800472:	7e 06                	jle    80047a <vprintfmt+0x19b>
  800474:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800478:	75 0d                	jne    800487 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80047d:	89 c7                	mov    %eax,%edi
  80047f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800482:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800485:	eb 55                	jmp    8004dc <vprintfmt+0x1fd>
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 e0             	push   -0x20(%ebp)
  80048d:	ff 75 cc             	push   -0x34(%ebp)
  800490:	e8 f5 03 00 00       	call   80088a <strnlen>
  800495:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800498:	29 c2                	sub    %eax,%edx
  80049a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004a2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	eb 0f                	jmp    8004ba <vprintfmt+0x1db>
					putch(padc, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	53                   	push   %ebx
  8004af:	ff 75 d4             	push   -0x2c(%ebp)
  8004b2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b4:	83 ef 01             	sub    $0x1,%edi
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	85 ff                	test   %edi,%edi
  8004bc:	7f ed                	jg     8004ab <vprintfmt+0x1cc>
  8004be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004c1:	85 d2                	test   %edx,%edx
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c8:	0f 49 c2             	cmovns %edx,%eax
  8004cb:	29 c2                	sub    %eax,%edx
  8004cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004d0:	eb a8                	jmp    80047a <vprintfmt+0x19b>
					putch(ch, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	52                   	push   %edx
  8004d7:	ff d6                	call   *%esi
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004df:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e1:	83 c7 01             	add    $0x1,%edi
  8004e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e8:	0f be d0             	movsbl %al,%edx
  8004eb:	85 d2                	test   %edx,%edx
  8004ed:	74 4b                	je     80053a <vprintfmt+0x25b>
  8004ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f3:	78 06                	js     8004fb <vprintfmt+0x21c>
  8004f5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004f9:	78 1e                	js     800519 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ff:	74 d1                	je     8004d2 <vprintfmt+0x1f3>
  800501:	0f be c0             	movsbl %al,%eax
  800504:	83 e8 20             	sub    $0x20,%eax
  800507:	83 f8 5e             	cmp    $0x5e,%eax
  80050a:	76 c6                	jbe    8004d2 <vprintfmt+0x1f3>
					putch('?', putdat);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	53                   	push   %ebx
  800510:	6a 3f                	push   $0x3f
  800512:	ff d6                	call   *%esi
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	eb c3                	jmp    8004dc <vprintfmt+0x1fd>
  800519:	89 cf                	mov    %ecx,%edi
  80051b:	eb 0e                	jmp    80052b <vprintfmt+0x24c>
				putch(' ', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 20                	push   $0x20
  800523:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800525:	83 ef 01             	sub    $0x1,%edi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	85 ff                	test   %edi,%edi
  80052d:	7f ee                	jg     80051d <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80052f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	e9 52 02 00 00       	jmp    80078c <vprintfmt+0x4ad>
  80053a:	89 cf                	mov    %ecx,%edi
  80053c:	eb ed                	jmp    80052b <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	83 c0 04             	add    $0x4,%eax
  800544:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80054c:	85 d2                	test   %edx,%edx
  80054e:	b8 2c 12 80 00       	mov    $0x80122c,%eax
  800553:	0f 45 c2             	cmovne %edx,%eax
  800556:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800559:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80055d:	7e 06                	jle    800565 <vprintfmt+0x286>
  80055f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800563:	75 0d                	jne    800572 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800565:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800568:	89 c7                	mov    %eax,%edi
  80056a:	03 45 d4             	add    -0x2c(%ebp),%eax
  80056d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800570:	eb 55                	jmp    8005c7 <vprintfmt+0x2e8>
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 e0             	push   -0x20(%ebp)
  800578:	ff 75 cc             	push   -0x34(%ebp)
  80057b:	e8 0a 03 00 00       	call   80088a <strnlen>
  800580:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800583:	29 c2                	sub    %eax,%edx
  800585:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80058d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800591:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800594:	eb 0f                	jmp    8005a5 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	53                   	push   %ebx
  80059a:	ff 75 d4             	push   -0x2c(%ebp)
  80059d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	83 ef 01             	sub    $0x1,%edi
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	85 ff                	test   %edi,%edi
  8005a7:	7f ed                	jg     800596 <vprintfmt+0x2b7>
  8005a9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005ac:	85 d2                	test   %edx,%edx
  8005ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b3:	0f 49 c2             	cmovns %edx,%eax
  8005b6:	29 c2                	sub    %eax,%edx
  8005b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005bb:	eb a8                	jmp    800565 <vprintfmt+0x286>
					putch(ch, putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	52                   	push   %edx
  8005c2:	ff d6                	call   *%esi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ca:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005cc:	83 c7 01             	add    $0x1,%edi
  8005cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d3:	0f be d0             	movsbl %al,%edx
  8005d6:	3c 3a                	cmp    $0x3a,%al
  8005d8:	74 4b                	je     800625 <vprintfmt+0x346>
  8005da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005de:	78 06                	js     8005e6 <vprintfmt+0x307>
  8005e0:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005e4:	78 1e                	js     800604 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ea:	74 d1                	je     8005bd <vprintfmt+0x2de>
  8005ec:	0f be c0             	movsbl %al,%eax
  8005ef:	83 e8 20             	sub    $0x20,%eax
  8005f2:	83 f8 5e             	cmp    $0x5e,%eax
  8005f5:	76 c6                	jbe    8005bd <vprintfmt+0x2de>
					putch('?', putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	6a 3f                	push   $0x3f
  8005fd:	ff d6                	call   *%esi
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	eb c3                	jmp    8005c7 <vprintfmt+0x2e8>
  800604:	89 cf                	mov    %ecx,%edi
  800606:	eb 0e                	jmp    800616 <vprintfmt+0x337>
				putch(' ', putdat);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	53                   	push   %ebx
  80060c:	6a 20                	push   $0x20
  80060e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800610:	83 ef 01             	sub    $0x1,%edi
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	85 ff                	test   %edi,%edi
  800618:	7f ee                	jg     800608 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80061a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	e9 67 01 00 00       	jmp    80078c <vprintfmt+0x4ad>
  800625:	89 cf                	mov    %ecx,%edi
  800627:	eb ed                	jmp    800616 <vprintfmt+0x337>
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <vprintfmt+0x36a>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 63                	je     800695 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063a:	99                   	cltd   
  80063b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb 17                	jmp    800660 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800654:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 08             	lea    0x8(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800660:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800663:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800666:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	0f 89 ff 00 00 00    	jns    800772 <vprintfmt+0x493>
				putch('-', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 2d                	push   $0x2d
  800679:	ff d6                	call   *%esi
				num = -(long long) num;
  80067b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800681:	f7 da                	neg    %edx
  800683:	83 d1 00             	adc    $0x0,%ecx
  800686:	f7 d9                	neg    %ecx
  800688:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800690:	e9 dd 00 00 00       	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80069d:	99                   	cltd   
  80069e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	eb b4                	jmp    800660 <vprintfmt+0x381>
	if (lflag >= 2)
  8006ac:	83 f9 01             	cmp    $0x1,%ecx
  8006af:	7f 1e                	jg     8006cf <vprintfmt+0x3f0>
	else if (lflag)
  8006b1:	85 c9                	test   %ecx,%ecx
  8006b3:	74 32                	je     8006e7 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006ca:	e9 a3 00 00 00       	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d7:	8d 40 08             	lea    0x8(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006dd:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006e2:	e9 8b 00 00 00       	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 10                	mov    (%eax),%edx
  8006ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f7:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006fc:	eb 74                	jmp    800772 <vprintfmt+0x493>
	if (lflag >= 2)
  8006fe:	83 f9 01             	cmp    $0x1,%ecx
  800701:	7f 1b                	jg     80071e <vprintfmt+0x43f>
	else if (lflag)
  800703:	85 c9                	test   %ecx,%ecx
  800705:	74 2c                	je     800733 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800717:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80071c:	eb 54                	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	8b 48 04             	mov    0x4(%eax),%ecx
  800726:	8d 40 08             	lea    0x8(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800731:	eb 3f                	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800743:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800748:	eb 28                	jmp    800772 <vprintfmt+0x493>
			putch('0', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 30                	push   $0x30
  800750:	ff d6                	call   *%esi
			putch('x', putdat);
  800752:	83 c4 08             	add    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 78                	push   $0x78
  800758:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800764:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800772:	83 ec 0c             	sub    $0xc,%esp
  800775:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800779:	50                   	push   %eax
  80077a:	ff 75 d4             	push   -0x2c(%ebp)
  80077d:	57                   	push   %edi
  80077e:	51                   	push   %ecx
  80077f:	52                   	push   %edx
  800780:	89 da                	mov    %ebx,%edx
  800782:	89 f0                	mov    %esi,%eax
  800784:	e8 73 fa ff ff       	call   8001fc <printnum>
			break;
  800789:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80078c:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078f:	e9 69 fb ff ff       	jmp    8002fd <vprintfmt+0x1e>
	if (lflag >= 2)
  800794:	83 f9 01             	cmp    $0x1,%ecx
  800797:	7f 1b                	jg     8007b4 <vprintfmt+0x4d5>
	else if (lflag)
  800799:	85 c9                	test   %ecx,%ecx
  80079b:	74 2c                	je     8007c9 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007b2:	eb be                	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 10                	mov    (%eax),%edx
  8007b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007bc:	8d 40 08             	lea    0x8(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007c7:	eb a9                	jmp    800772 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d3:	8d 40 04             	lea    0x4(%eax),%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d9:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007de:	eb 92                	jmp    800772 <vprintfmt+0x493>
			putch(ch, putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	6a 25                	push   $0x25
  8007e6:	ff d6                	call   *%esi
			break;
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb 9f                	jmp    80078c <vprintfmt+0x4ad>
			putch('%', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 25                	push   $0x25
  8007f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 f8                	mov    %edi,%eax
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x520>
  8007fc:	83 e8 01             	sub    $0x1,%eax
  8007ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x51d>
  800805:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800808:	eb 82                	jmp    80078c <vprintfmt+0x4ad>

0080080a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800816:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800819:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800820:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800827:	85 c0                	test   %eax,%eax
  800829:	74 26                	je     800851 <vsnprintf+0x47>
  80082b:	85 d2                	test   %edx,%edx
  80082d:	7e 22                	jle    800851 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082f:	ff 75 14             	push   0x14(%ebp)
  800832:	ff 75 10             	push   0x10(%ebp)
  800835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	68 a5 02 80 00       	push   $0x8002a5
  80083e:	e8 9c fa ff ff       	call   8002df <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800846:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084c:	83 c4 10             	add    $0x10,%esp
}
  80084f:	c9                   	leave  
  800850:	c3                   	ret    
		return -E_INVAL;
  800851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800856:	eb f7                	jmp    80084f <vsnprintf+0x45>

00800858 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800861:	50                   	push   %eax
  800862:	ff 75 10             	push   0x10(%ebp)
  800865:	ff 75 0c             	push   0xc(%ebp)
  800868:	ff 75 08             	push   0x8(%ebp)
  80086b:	e8 9a ff ff ff       	call   80080a <vsnprintf>
	va_end(ap);

	return rc;
}
  800870:	c9                   	leave  
  800871:	c3                   	ret    

00800872 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	eb 03                	jmp    800882 <strlen+0x10>
		n++;
  80087f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800882:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800886:	75 f7                	jne    80087f <strlen+0xd>
	return n;
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800893:	b8 00 00 00 00       	mov    $0x0,%eax
  800898:	eb 03                	jmp    80089d <strnlen+0x13>
		n++;
  80089a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089d:	39 d0                	cmp    %edx,%eax
  80089f:	74 08                	je     8008a9 <strnlen+0x1f>
  8008a1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a5:	75 f3                	jne    80089a <strnlen+0x10>
  8008a7:	89 c2                	mov    %eax,%edx
	return n;
}
  8008a9:	89 d0                	mov    %edx,%eax
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	53                   	push   %ebx
  8008b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bc:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008c0:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008c3:	83 c0 01             	add    $0x1,%eax
  8008c6:	84 d2                	test   %dl,%dl
  8008c8:	75 f2                	jne    8008bc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008ca:	89 c8                	mov    %ecx,%eax
  8008cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	53                   	push   %ebx
  8008d5:	83 ec 10             	sub    $0x10,%esp
  8008d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008db:	53                   	push   %ebx
  8008dc:	e8 91 ff ff ff       	call   800872 <strlen>
  8008e1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008e4:	ff 75 0c             	push   0xc(%ebp)
  8008e7:	01 d8                	add    %ebx,%eax
  8008e9:	50                   	push   %eax
  8008ea:	e8 be ff ff ff       	call   8008ad <strcpy>
	return dst;
}
  8008ef:	89 d8                	mov    %ebx,%eax
  8008f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    

008008f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800901:	89 f3                	mov    %esi,%ebx
  800903:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800906:	89 f0                	mov    %esi,%eax
  800908:	eb 0f                	jmp    800919 <strncpy+0x23>
		*dst++ = *src;
  80090a:	83 c0 01             	add    $0x1,%eax
  80090d:	0f b6 0a             	movzbl (%edx),%ecx
  800910:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800913:	80 f9 01             	cmp    $0x1,%cl
  800916:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800919:	39 d8                	cmp    %ebx,%eax
  80091b:	75 ed                	jne    80090a <strncpy+0x14>
	}
	return ret;
}
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 75 08             	mov    0x8(%ebp),%esi
  80092b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092e:	8b 55 10             	mov    0x10(%ebp),%edx
  800931:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800933:	85 d2                	test   %edx,%edx
  800935:	74 21                	je     800958 <strlcpy+0x35>
  800937:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80093b:	89 f2                	mov    %esi,%edx
  80093d:	eb 09                	jmp    800948 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80093f:	83 c1 01             	add    $0x1,%ecx
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	74 09                	je     800955 <strlcpy+0x32>
  80094c:	0f b6 19             	movzbl (%ecx),%ebx
  80094f:	84 db                	test   %bl,%bl
  800951:	75 ec                	jne    80093f <strlcpy+0x1c>
  800953:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800955:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800958:	29 f0                	sub    %esi,%eax
}
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800964:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800967:	eb 06                	jmp    80096f <strcmp+0x11>
		p++, q++;
  800969:	83 c1 01             	add    $0x1,%ecx
  80096c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80096f:	0f b6 01             	movzbl (%ecx),%eax
  800972:	84 c0                	test   %al,%al
  800974:	74 04                	je     80097a <strcmp+0x1c>
  800976:	3a 02                	cmp    (%edx),%al
  800978:	74 ef                	je     800969 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097a:	0f b6 c0             	movzbl %al,%eax
  80097d:	0f b6 12             	movzbl (%edx),%edx
  800980:	29 d0                	sub    %edx,%eax
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098e:	89 c3                	mov    %eax,%ebx
  800990:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800993:	eb 06                	jmp    80099b <strncmp+0x17>
		n--, p++, q++;
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80099b:	39 d8                	cmp    %ebx,%eax
  80099d:	74 18                	je     8009b7 <strncmp+0x33>
  80099f:	0f b6 08             	movzbl (%eax),%ecx
  8009a2:	84 c9                	test   %cl,%cl
  8009a4:	74 04                	je     8009aa <strncmp+0x26>
  8009a6:	3a 0a                	cmp    (%edx),%cl
  8009a8:	74 eb                	je     800995 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009aa:	0f b6 00             	movzbl (%eax),%eax
  8009ad:	0f b6 12             	movzbl (%edx),%edx
  8009b0:	29 d0                	sub    %edx,%eax
}
  8009b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    
		return 0;
  8009b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bc:	eb f4                	jmp    8009b2 <strncmp+0x2e>

008009be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c8:	eb 03                	jmp    8009cd <strchr+0xf>
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	0f b6 10             	movzbl (%eax),%edx
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	74 06                	je     8009da <strchr+0x1c>
		if (*s == c)
  8009d4:	38 ca                	cmp    %cl,%dl
  8009d6:	75 f2                	jne    8009ca <strchr+0xc>
  8009d8:	eb 05                	jmp    8009df <strchr+0x21>
			return (char *) s;
	return 0;
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009eb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ee:	38 ca                	cmp    %cl,%dl
  8009f0:	74 09                	je     8009fb <strfind+0x1a>
  8009f2:	84 d2                	test   %dl,%dl
  8009f4:	74 05                	je     8009fb <strfind+0x1a>
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	eb f0                	jmp    8009eb <strfind+0xa>
			break;
	return (char *) s;
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	57                   	push   %edi
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a09:	85 c9                	test   %ecx,%ecx
  800a0b:	74 2f                	je     800a3c <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	09 c8                	or     %ecx,%eax
  800a11:	a8 03                	test   $0x3,%al
  800a13:	75 21                	jne    800a36 <memset+0x39>
		c &= 0xFF;
  800a15:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	c1 e0 08             	shl    $0x8,%eax
  800a1e:	89 d3                	mov    %edx,%ebx
  800a20:	c1 e3 18             	shl    $0x18,%ebx
  800a23:	89 d6                	mov    %edx,%esi
  800a25:	c1 e6 10             	shl    $0x10,%esi
  800a28:	09 f3                	or     %esi,%ebx
  800a2a:	09 da                	or     %ebx,%edx
  800a2c:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a31:	fc                   	cld    
  800a32:	f3 ab                	rep stos %eax,%es:(%edi)
  800a34:	eb 06                	jmp    800a3c <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	fc                   	cld    
  800a3a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3c:	89 f8                	mov    %edi,%eax
  800a3e:	5b                   	pop    %ebx
  800a3f:	5e                   	pop    %esi
  800a40:	5f                   	pop    %edi
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	57                   	push   %edi
  800a47:	56                   	push   %esi
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a51:	39 c6                	cmp    %eax,%esi
  800a53:	73 32                	jae    800a87 <memmove+0x44>
  800a55:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a58:	39 c2                	cmp    %eax,%edx
  800a5a:	76 2b                	jbe    800a87 <memmove+0x44>
		s += n;
		d += n;
  800a5c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	89 d6                	mov    %edx,%esi
  800a61:	09 fe                	or     %edi,%esi
  800a63:	09 ce                	or     %ecx,%esi
  800a65:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6b:	75 0e                	jne    800a7b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a6d:	83 ef 04             	sub    $0x4,%edi
  800a70:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a76:	fd                   	std    
  800a77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a79:	eb 09                	jmp    800a84 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7b:	83 ef 01             	sub    $0x1,%edi
  800a7e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a81:	fd                   	std    
  800a82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a84:	fc                   	cld    
  800a85:	eb 1a                	jmp    800aa1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a87:	89 f2                	mov    %esi,%edx
  800a89:	09 c2                	or     %eax,%edx
  800a8b:	09 ca                	or     %ecx,%edx
  800a8d:	f6 c2 03             	test   $0x3,%dl
  800a90:	75 0a                	jne    800a9c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a92:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a95:	89 c7                	mov    %eax,%edi
  800a97:	fc                   	cld    
  800a98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9a:	eb 05                	jmp    800aa1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a9c:	89 c7                	mov    %eax,%edi
  800a9e:	fc                   	cld    
  800a9f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa1:	5e                   	pop    %esi
  800aa2:	5f                   	pop    %edi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aab:	ff 75 10             	push   0x10(%ebp)
  800aae:	ff 75 0c             	push   0xc(%ebp)
  800ab1:	ff 75 08             	push   0x8(%ebp)
  800ab4:	e8 8a ff ff ff       	call   800a43 <memmove>
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac6:	89 c6                	mov    %eax,%esi
  800ac8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acb:	eb 06                	jmp    800ad3 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800ad3:	39 f0                	cmp    %esi,%eax
  800ad5:	74 14                	je     800aeb <memcmp+0x30>
		if (*s1 != *s2)
  800ad7:	0f b6 08             	movzbl (%eax),%ecx
  800ada:	0f b6 1a             	movzbl (%edx),%ebx
  800add:	38 d9                	cmp    %bl,%cl
  800adf:	74 ec                	je     800acd <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800ae1:	0f b6 c1             	movzbl %cl,%eax
  800ae4:	0f b6 db             	movzbl %bl,%ebx
  800ae7:	29 d8                	sub    %ebx,%eax
  800ae9:	eb 05                	jmp    800af0 <memcmp+0x35>
	}

	return 0;
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800afd:	89 c2                	mov    %eax,%edx
  800aff:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b02:	eb 03                	jmp    800b07 <memfind+0x13>
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	39 d0                	cmp    %edx,%eax
  800b09:	73 04                	jae    800b0f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0b:	38 08                	cmp    %cl,(%eax)
  800b0d:	75 f5                	jne    800b04 <memfind+0x10>
			break;
	return (void *) s;
}
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	57                   	push   %edi
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1d:	eb 03                	jmp    800b22 <strtol+0x11>
		s++;
  800b1f:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b22:	0f b6 02             	movzbl (%edx),%eax
  800b25:	3c 20                	cmp    $0x20,%al
  800b27:	74 f6                	je     800b1f <strtol+0xe>
  800b29:	3c 09                	cmp    $0x9,%al
  800b2b:	74 f2                	je     800b1f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b2d:	3c 2b                	cmp    $0x2b,%al
  800b2f:	74 2a                	je     800b5b <strtol+0x4a>
	int neg = 0;
  800b31:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b36:	3c 2d                	cmp    $0x2d,%al
  800b38:	74 2b                	je     800b65 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b40:	75 0f                	jne    800b51 <strtol+0x40>
  800b42:	80 3a 30             	cmpb   $0x30,(%edx)
  800b45:	74 28                	je     800b6f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b47:	85 db                	test   %ebx,%ebx
  800b49:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b4e:	0f 44 d8             	cmove  %eax,%ebx
  800b51:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b56:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b59:	eb 46                	jmp    800ba1 <strtol+0x90>
		s++;
  800b5b:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b5e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b63:	eb d5                	jmp    800b3a <strtol+0x29>
		s++, neg = 1;
  800b65:	83 c2 01             	add    $0x1,%edx
  800b68:	bf 01 00 00 00       	mov    $0x1,%edi
  800b6d:	eb cb                	jmp    800b3a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b73:	74 0e                	je     800b83 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b75:	85 db                	test   %ebx,%ebx
  800b77:	75 d8                	jne    800b51 <strtol+0x40>
		s++, base = 8;
  800b79:	83 c2 01             	add    $0x1,%edx
  800b7c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b81:	eb ce                	jmp    800b51 <strtol+0x40>
		s += 2, base = 16;
  800b83:	83 c2 02             	add    $0x2,%edx
  800b86:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b8b:	eb c4                	jmp    800b51 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b8d:	0f be c0             	movsbl %al,%eax
  800b90:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b93:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b96:	7d 3a                	jge    800bd2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b98:	83 c2 01             	add    $0x1,%edx
  800b9b:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b9f:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800ba1:	0f b6 02             	movzbl (%edx),%eax
  800ba4:	8d 70 d0             	lea    -0x30(%eax),%esi
  800ba7:	89 f3                	mov    %esi,%ebx
  800ba9:	80 fb 09             	cmp    $0x9,%bl
  800bac:	76 df                	jbe    800b8d <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bae:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bb1:	89 f3                	mov    %esi,%ebx
  800bb3:	80 fb 19             	cmp    $0x19,%bl
  800bb6:	77 08                	ja     800bc0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb8:	0f be c0             	movsbl %al,%eax
  800bbb:	83 e8 57             	sub    $0x57,%eax
  800bbe:	eb d3                	jmp    800b93 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bc0:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bc3:	89 f3                	mov    %esi,%ebx
  800bc5:	80 fb 19             	cmp    $0x19,%bl
  800bc8:	77 08                	ja     800bd2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bca:	0f be c0             	movsbl %al,%eax
  800bcd:	83 e8 37             	sub    $0x37,%eax
  800bd0:	eb c1                	jmp    800b93 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd6:	74 05                	je     800bdd <strtol+0xcc>
		*endptr = (char *) s;
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800bdd:	89 c8                	mov    %ecx,%eax
  800bdf:	f7 d8                	neg    %eax
  800be1:	85 ff                	test   %edi,%edi
  800be3:	0f 45 c8             	cmovne %eax,%ecx
}
  800be6:	89 c8                	mov    %ecx,%eax
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfe:	89 c3                	mov    %eax,%ebx
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	89 c6                	mov    %eax,%esi
  800c04:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
  800c16:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1b:	89 d1                	mov    %edx,%ecx
  800c1d:	89 d3                	mov    %edx,%ebx
  800c1f:	89 d7                	mov    %edx,%edi
  800c21:	89 d6                	mov    %edx,%esi
  800c23:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c40:	89 cb                	mov    %ecx,%ebx
  800c42:	89 cf                	mov    %ecx,%edi
  800c44:	89 ce                	mov    %ecx,%esi
  800c46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	7f 08                	jg     800c54 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c54:	83 ec 0c             	sub    $0xc,%esp
  800c57:	50                   	push   %eax
  800c58:	6a 03                	push   $0x3
  800c5a:	68 1f 15 80 00       	push   $0x80151f
  800c5f:	6a 23                	push   $0x23
  800c61:	68 3c 15 80 00       	push   $0x80153c
  800c66:	e8 a2 f4 ff ff       	call   80010d <_panic>

00800c6b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7b:	89 d1                	mov    %edx,%ecx
  800c7d:	89 d3                	mov    %edx,%ebx
  800c7f:	89 d7                	mov    %edx,%edi
  800c81:	89 d6                	mov    %edx,%esi
  800c83:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_yield>:

void
sys_yield(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	be 00 00 00 00       	mov    $0x0,%esi
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbd:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc5:	89 f7                	mov    %esi,%edi
  800cc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 04                	push   $0x4
  800cdb:	68 1f 15 80 00       	push   $0x80151f
  800ce0:	6a 23                	push   $0x23
  800ce2:	68 3c 15 80 00       	push   $0x80153c
  800ce7:	e8 21 f4 ff ff       	call   80010d <_panic>

00800cec <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	b8 05 00 00 00       	mov    $0x5,%eax
  800d00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d03:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d06:	8b 75 18             	mov    0x18(%ebp),%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 05                	push   $0x5
  800d1d:	68 1f 15 80 00       	push   $0x80151f
  800d22:	6a 23                	push   $0x23
  800d24:	68 3c 15 80 00       	push   $0x80153c
  800d29:	e8 df f3 ff ff       	call   80010d <_panic>

00800d2e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 06 00 00 00       	mov    $0x6,%eax
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	89 de                	mov    %ebx,%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 06                	push   $0x6
  800d5f:	68 1f 15 80 00       	push   $0x80151f
  800d64:	6a 23                	push   $0x23
  800d66:	68 3c 15 80 00       	push   $0x80153c
  800d6b:	e8 9d f3 ff ff       	call   80010d <_panic>

00800d70 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 08                	push   $0x8
  800da1:	68 1f 15 80 00       	push   $0x80151f
  800da6:	6a 23                	push   $0x23
  800da8:	68 3c 15 80 00       	push   $0x80153c
  800dad:	e8 5b f3 ff ff       	call   80010d <_panic>

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 09                	push   $0x9
  800de3:	68 1f 15 80 00       	push   $0x80151f
  800de8:	6a 23                	push   $0x23
  800dea:	68 3c 15 80 00       	push   $0x80153c
  800def:	e8 19 f3 ff ff       	call   80010d <_panic>

00800df4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	89 de                	mov    %ebx,%esi
  800e11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7f 08                	jg     800e1f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	50                   	push   %eax
  800e23:	6a 0a                	push   $0xa
  800e25:	68 1f 15 80 00       	push   $0x80151f
  800e2a:	6a 23                	push   $0x23
  800e2c:	68 3c 15 80 00       	push   $0x80153c
  800e31:	e8 d7 f2 ff ff       	call   80010d <_panic>

00800e36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e47:	be 00 00 00 00       	mov    $0x0,%esi
  800e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e52:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7f 08                	jg     800e83 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	50                   	push   %eax
  800e87:	6a 0d                	push   $0xd
  800e89:	68 1f 15 80 00       	push   $0x80151f
  800e8e:	6a 23                	push   $0x23
  800e90:	68 3c 15 80 00       	push   $0x80153c
  800e95:	e8 73 f2 ff ff       	call   80010d <_panic>

00800e9a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ea0:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ea7:	74 20                	je     800ec9 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  800eb1:	83 ec 08             	sub    $0x8,%esp
  800eb4:	68 09 0f 80 00       	push   $0x800f09
  800eb9:	6a 00                	push   $0x0
  800ebb:	e8 34 ff ff ff       	call   800df4 <sys_env_set_pgfault_upcall>
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	78 2e                	js     800ef5 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	6a 07                	push   $0x7
  800ece:	68 00 f0 bf ee       	push   $0xeebff000
  800ed3:	6a 00                	push   $0x0
  800ed5:	e8 cf fd ff ff       	call   800ca9 <sys_page_alloc>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	79 c8                	jns    800ea9 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  800ee1:	83 ec 04             	sub    $0x4,%esp
  800ee4:	68 4c 15 80 00       	push   $0x80154c
  800ee9:	6a 21                	push   $0x21
  800eeb:	68 af 15 80 00       	push   $0x8015af
  800ef0:	e8 18 f2 ff ff       	call   80010d <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	68 78 15 80 00       	push   $0x801578
  800efd:	6a 27                	push   $0x27
  800eff:	68 af 15 80 00       	push   $0x8015af
  800f04:	e8 04 f2 ff ff       	call   80010d <_panic>

00800f09 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f09:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f0a:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800f0f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f11:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  800f14:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  800f18:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  800f1d:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  800f21:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  800f23:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800f26:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800f27:	83 c4 04             	add    $0x4,%esp
	popfl
  800f2a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f2b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f2c:	c3                   	ret    
  800f2d:	66 90                	xchg   %ax,%ax
  800f2f:	90                   	nop

00800f30 <__udivdi3>:
  800f30:	f3 0f 1e fb          	endbr32 
  800f34:	55                   	push   %ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 1c             	sub    $0x1c,%esp
  800f3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f43:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	75 19                	jne    800f68 <__udivdi3+0x38>
  800f4f:	39 f3                	cmp    %esi,%ebx
  800f51:	76 4d                	jbe    800fa0 <__udivdi3+0x70>
  800f53:	31 ff                	xor    %edi,%edi
  800f55:	89 e8                	mov    %ebp,%eax
  800f57:	89 f2                	mov    %esi,%edx
  800f59:	f7 f3                	div    %ebx
  800f5b:	89 fa                	mov    %edi,%edx
  800f5d:	83 c4 1c             	add    $0x1c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	39 f0                	cmp    %esi,%eax
  800f6a:	76 14                	jbe    800f80 <__udivdi3+0x50>
  800f6c:	31 ff                	xor    %edi,%edi
  800f6e:	31 c0                	xor    %eax,%eax
  800f70:	89 fa                	mov    %edi,%edx
  800f72:	83 c4 1c             	add    $0x1c,%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
  800f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f80:	0f bd f8             	bsr    %eax,%edi
  800f83:	83 f7 1f             	xor    $0x1f,%edi
  800f86:	75 48                	jne    800fd0 <__udivdi3+0xa0>
  800f88:	39 f0                	cmp    %esi,%eax
  800f8a:	72 06                	jb     800f92 <__udivdi3+0x62>
  800f8c:	31 c0                	xor    %eax,%eax
  800f8e:	39 eb                	cmp    %ebp,%ebx
  800f90:	77 de                	ja     800f70 <__udivdi3+0x40>
  800f92:	b8 01 00 00 00       	mov    $0x1,%eax
  800f97:	eb d7                	jmp    800f70 <__udivdi3+0x40>
  800f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa0:	89 d9                	mov    %ebx,%ecx
  800fa2:	85 db                	test   %ebx,%ebx
  800fa4:	75 0b                	jne    800fb1 <__udivdi3+0x81>
  800fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fab:	31 d2                	xor    %edx,%edx
  800fad:	f7 f3                	div    %ebx
  800faf:	89 c1                	mov    %eax,%ecx
  800fb1:	31 d2                	xor    %edx,%edx
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	f7 f1                	div    %ecx
  800fb7:	89 c6                	mov    %eax,%esi
  800fb9:	89 e8                	mov    %ebp,%eax
  800fbb:	89 f7                	mov    %esi,%edi
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 fa                	mov    %edi,%edx
  800fc1:	83 c4 1c             	add    $0x1c,%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
  800fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd0:	89 f9                	mov    %edi,%ecx
  800fd2:	ba 20 00 00 00       	mov    $0x20,%edx
  800fd7:	29 fa                	sub    %edi,%edx
  800fd9:	d3 e0                	shl    %cl,%eax
  800fdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fdf:	89 d1                	mov    %edx,%ecx
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	d3 e8                	shr    %cl,%eax
  800fe5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fe9:	09 c1                	or     %eax,%ecx
  800feb:	89 f0                	mov    %esi,%eax
  800fed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ff1:	89 f9                	mov    %edi,%ecx
  800ff3:	d3 e3                	shl    %cl,%ebx
  800ff5:	89 d1                	mov    %edx,%ecx
  800ff7:	d3 e8                	shr    %cl,%eax
  800ff9:	89 f9                	mov    %edi,%ecx
  800ffb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fff:	89 eb                	mov    %ebp,%ebx
  801001:	d3 e6                	shl    %cl,%esi
  801003:	89 d1                	mov    %edx,%ecx
  801005:	d3 eb                	shr    %cl,%ebx
  801007:	09 f3                	or     %esi,%ebx
  801009:	89 c6                	mov    %eax,%esi
  80100b:	89 f2                	mov    %esi,%edx
  80100d:	89 d8                	mov    %ebx,%eax
  80100f:	f7 74 24 08          	divl   0x8(%esp)
  801013:	89 d6                	mov    %edx,%esi
  801015:	89 c3                	mov    %eax,%ebx
  801017:	f7 64 24 0c          	mull   0xc(%esp)
  80101b:	39 d6                	cmp    %edx,%esi
  80101d:	72 19                	jb     801038 <__udivdi3+0x108>
  80101f:	89 f9                	mov    %edi,%ecx
  801021:	d3 e5                	shl    %cl,%ebp
  801023:	39 c5                	cmp    %eax,%ebp
  801025:	73 04                	jae    80102b <__udivdi3+0xfb>
  801027:	39 d6                	cmp    %edx,%esi
  801029:	74 0d                	je     801038 <__udivdi3+0x108>
  80102b:	89 d8                	mov    %ebx,%eax
  80102d:	31 ff                	xor    %edi,%edi
  80102f:	e9 3c ff ff ff       	jmp    800f70 <__udivdi3+0x40>
  801034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801038:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80103b:	31 ff                	xor    %edi,%edi
  80103d:	e9 2e ff ff ff       	jmp    800f70 <__udivdi3+0x40>
  801042:	66 90                	xchg   %ax,%ax
  801044:	66 90                	xchg   %ax,%ax
  801046:	66 90                	xchg   %ax,%ax
  801048:	66 90                	xchg   %ax,%ax
  80104a:	66 90                	xchg   %ax,%ax
  80104c:	66 90                	xchg   %ax,%ax
  80104e:	66 90                	xchg   %ax,%ax

00801050 <__umoddi3>:
  801050:	f3 0f 1e fb          	endbr32 
  801054:	55                   	push   %ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
  801058:	83 ec 1c             	sub    $0x1c,%esp
  80105b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80105f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801063:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801067:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80106b:	89 f0                	mov    %esi,%eax
  80106d:	89 da                	mov    %ebx,%edx
  80106f:	85 ff                	test   %edi,%edi
  801071:	75 15                	jne    801088 <__umoddi3+0x38>
  801073:	39 dd                	cmp    %ebx,%ebp
  801075:	76 39                	jbe    8010b0 <__umoddi3+0x60>
  801077:	f7 f5                	div    %ebp
  801079:	89 d0                	mov    %edx,%eax
  80107b:	31 d2                	xor    %edx,%edx
  80107d:	83 c4 1c             	add    $0x1c,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
  801085:	8d 76 00             	lea    0x0(%esi),%esi
  801088:	39 df                	cmp    %ebx,%edi
  80108a:	77 f1                	ja     80107d <__umoddi3+0x2d>
  80108c:	0f bd cf             	bsr    %edi,%ecx
  80108f:	83 f1 1f             	xor    $0x1f,%ecx
  801092:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801096:	75 40                	jne    8010d8 <__umoddi3+0x88>
  801098:	39 df                	cmp    %ebx,%edi
  80109a:	72 04                	jb     8010a0 <__umoddi3+0x50>
  80109c:	39 f5                	cmp    %esi,%ebp
  80109e:	77 dd                	ja     80107d <__umoddi3+0x2d>
  8010a0:	89 da                	mov    %ebx,%edx
  8010a2:	89 f0                	mov    %esi,%eax
  8010a4:	29 e8                	sub    %ebp,%eax
  8010a6:	19 fa                	sbb    %edi,%edx
  8010a8:	eb d3                	jmp    80107d <__umoddi3+0x2d>
  8010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010b0:	89 e9                	mov    %ebp,%ecx
  8010b2:	85 ed                	test   %ebp,%ebp
  8010b4:	75 0b                	jne    8010c1 <__umoddi3+0x71>
  8010b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010bb:	31 d2                	xor    %edx,%edx
  8010bd:	f7 f5                	div    %ebp
  8010bf:	89 c1                	mov    %eax,%ecx
  8010c1:	89 d8                	mov    %ebx,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f1                	div    %ecx
  8010c7:	89 f0                	mov    %esi,%eax
  8010c9:	f7 f1                	div    %ecx
  8010cb:	89 d0                	mov    %edx,%eax
  8010cd:	31 d2                	xor    %edx,%edx
  8010cf:	eb ac                	jmp    80107d <__umoddi3+0x2d>
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010dc:	ba 20 00 00 00       	mov    $0x20,%edx
  8010e1:	29 c2                	sub    %eax,%edx
  8010e3:	89 c1                	mov    %eax,%ecx
  8010e5:	89 e8                	mov    %ebp,%eax
  8010e7:	d3 e7                	shl    %cl,%edi
  8010e9:	89 d1                	mov    %edx,%ecx
  8010eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010ef:	d3 e8                	shr    %cl,%eax
  8010f1:	89 c1                	mov    %eax,%ecx
  8010f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010f7:	09 f9                	or     %edi,%ecx
  8010f9:	89 df                	mov    %ebx,%edi
  8010fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010ff:	89 c1                	mov    %eax,%ecx
  801101:	d3 e5                	shl    %cl,%ebp
  801103:	89 d1                	mov    %edx,%ecx
  801105:	d3 ef                	shr    %cl,%edi
  801107:	89 c1                	mov    %eax,%ecx
  801109:	89 f0                	mov    %esi,%eax
  80110b:	d3 e3                	shl    %cl,%ebx
  80110d:	89 d1                	mov    %edx,%ecx
  80110f:	89 fa                	mov    %edi,%edx
  801111:	d3 e8                	shr    %cl,%eax
  801113:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801118:	09 d8                	or     %ebx,%eax
  80111a:	f7 74 24 08          	divl   0x8(%esp)
  80111e:	89 d3                	mov    %edx,%ebx
  801120:	d3 e6                	shl    %cl,%esi
  801122:	f7 e5                	mul    %ebp
  801124:	89 c7                	mov    %eax,%edi
  801126:	89 d1                	mov    %edx,%ecx
  801128:	39 d3                	cmp    %edx,%ebx
  80112a:	72 06                	jb     801132 <__umoddi3+0xe2>
  80112c:	75 0e                	jne    80113c <__umoddi3+0xec>
  80112e:	39 c6                	cmp    %eax,%esi
  801130:	73 0a                	jae    80113c <__umoddi3+0xec>
  801132:	29 e8                	sub    %ebp,%eax
  801134:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801138:	89 d1                	mov    %edx,%ecx
  80113a:	89 c7                	mov    %eax,%edi
  80113c:	89 f5                	mov    %esi,%ebp
  80113e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801142:	29 fd                	sub    %edi,%ebp
  801144:	19 cb                	sbb    %ecx,%ebx
  801146:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	d3 e0                	shl    %cl,%eax
  80114f:	89 f1                	mov    %esi,%ecx
  801151:	d3 ed                	shr    %cl,%ebp
  801153:	d3 eb                	shr    %cl,%ebx
  801155:	09 e8                	or     %ebp,%eax
  801157:	89 da                	mov    %ebx,%edx
  801159:	83 c4 1c             	add    $0x1c,%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    
