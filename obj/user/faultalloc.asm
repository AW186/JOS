
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
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
  800040:	68 a0 11 80 00       	push   $0x8011a0
  800045:	e8 b3 01 00 00       	call   8001fd <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 60 0c 00 00       	call   800cbe <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 ec 11 80 00       	push   $0x8011ec
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 fa 07 00 00       	call   80086d <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 c0 11 80 00       	push   $0x8011c0
  800085:	6a 0e                	push   $0xe
  800087:	68 aa 11 80 00       	push   $0x8011aa
  80008c:	e8 91 00 00 00       	call   800122 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 0e 0e 00 00       	call   800eaf <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 bc 11 80 00       	push   $0x8011bc
  8000ae:	e8 4a 01 00 00       	call   8001fd <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 bc 11 80 00       	push   $0x8011bc
  8000c0:	e8 38 01 00 00       	call   8001fd <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 a6 0b 00 00       	call   800c80 <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800116:	6a 00                	push   $0x0
  800118:	e8 22 0b 00 00       	call   800c3f <sys_env_destroy>
}
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	56                   	push   %esi
  800126:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800127:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800130:	e8 4b 0b 00 00       	call   800c80 <sys_getenvid>
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	ff 75 0c             	push   0xc(%ebp)
  80013b:	ff 75 08             	push   0x8(%ebp)
  80013e:	56                   	push   %esi
  80013f:	50                   	push   %eax
  800140:	68 18 12 80 00       	push   $0x801218
  800145:	e8 b3 00 00 00       	call   8001fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80014a:	83 c4 18             	add    $0x18,%esp
  80014d:	53                   	push   %ebx
  80014e:	ff 75 10             	push   0x10(%ebp)
  800151:	e8 56 00 00 00       	call   8001ac <vcprintf>
	cprintf("\n");
  800156:	c7 04 24 be 11 80 00 	movl   $0x8011be,(%esp)
  80015d:	e8 9b 00 00 00       	call   8001fd <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800165:	cc                   	int3   
  800166:	eb fd                	jmp    800165 <_panic+0x43>

00800168 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	53                   	push   %ebx
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800172:	8b 13                	mov    (%ebx),%edx
  800174:	8d 42 01             	lea    0x1(%edx),%eax
  800177:	89 03                	mov    %eax,(%ebx)
  800179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	74 09                	je     800190 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800187:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	68 ff 00 00 00       	push   $0xff
  800198:	8d 43 08             	lea    0x8(%ebx),%eax
  80019b:	50                   	push   %eax
  80019c:	e8 61 0a 00 00       	call   800c02 <sys_cputs>
		b->idx = 0;
  8001a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a7:	83 c4 10             	add    $0x10,%esp
  8001aa:	eb db                	jmp    800187 <putch+0x1f>

008001ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bc:	00 00 00 
	b.cnt = 0;
  8001bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c9:	ff 75 0c             	push   0xc(%ebp)
  8001cc:	ff 75 08             	push   0x8(%ebp)
  8001cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d5:	50                   	push   %eax
  8001d6:	68 68 01 80 00       	push   $0x800168
  8001db:	e8 14 01 00 00       	call   8002f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e0:	83 c4 08             	add    $0x8,%esp
  8001e3:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 0d 0a 00 00       	call   800c02 <sys_cputs>

	return b.cnt;
}
  8001f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800203:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800206:	50                   	push   %eax
  800207:	ff 75 08             	push   0x8(%ebp)
  80020a:	e8 9d ff ff ff       	call   8001ac <vcprintf>
	va_end(ap);

	return cnt;
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	57                   	push   %edi
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
  800217:	83 ec 1c             	sub    $0x1c,%esp
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	89 d6                	mov    %edx,%esi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	8b 55 0c             	mov    0xc(%ebp),%edx
  800224:	89 d1                	mov    %edx,%ecx
  800226:	89 c2                	mov    %eax,%edx
  800228:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80022e:	8b 45 10             	mov    0x10(%ebp),%eax
  800231:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800234:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800237:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80023e:	39 c2                	cmp    %eax,%edx
  800240:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800243:	72 3e                	jb     800283 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 18             	push   0x18(%ebp)
  80024b:	83 eb 01             	sub    $0x1,%ebx
  80024e:	53                   	push   %ebx
  80024f:	50                   	push   %eax
  800250:	83 ec 08             	sub    $0x8,%esp
  800253:	ff 75 e4             	push   -0x1c(%ebp)
  800256:	ff 75 e0             	push   -0x20(%ebp)
  800259:	ff 75 dc             	push   -0x24(%ebp)
  80025c:	ff 75 d8             	push   -0x28(%ebp)
  80025f:	e8 ec 0c 00 00       	call   800f50 <__udivdi3>
  800264:	83 c4 18             	add    $0x18,%esp
  800267:	52                   	push   %edx
  800268:	50                   	push   %eax
  800269:	89 f2                	mov    %esi,%edx
  80026b:	89 f8                	mov    %edi,%eax
  80026d:	e8 9f ff ff ff       	call   800211 <printnum>
  800272:	83 c4 20             	add    $0x20,%esp
  800275:	eb 13                	jmp    80028a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	56                   	push   %esi
  80027b:	ff 75 18             	push   0x18(%ebp)
  80027e:	ff d7                	call   *%edi
  800280:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800283:	83 eb 01             	sub    $0x1,%ebx
  800286:	85 db                	test   %ebx,%ebx
  800288:	7f ed                	jg     800277 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 e4             	push   -0x1c(%ebp)
  800294:	ff 75 e0             	push   -0x20(%ebp)
  800297:	ff 75 dc             	push   -0x24(%ebp)
  80029a:	ff 75 d8             	push   -0x28(%ebp)
  80029d:	e8 ce 0d 00 00       	call   801070 <__umoddi3>
  8002a2:	83 c4 14             	add    $0x14,%esp
  8002a5:	0f be 80 3b 12 80 00 	movsbl 0x80123b(%eax),%eax
  8002ac:	50                   	push   %eax
  8002ad:	ff d7                	call   *%edi
}
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c4:	8b 10                	mov    (%eax),%edx
  8002c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c9:	73 0a                	jae    8002d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	88 02                	mov    %al,(%edx)
}
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <printfmt>:
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e0:	50                   	push   %eax
  8002e1:	ff 75 10             	push   0x10(%ebp)
  8002e4:	ff 75 0c             	push   0xc(%ebp)
  8002e7:	ff 75 08             	push   0x8(%ebp)
  8002ea:	e8 05 00 00 00       	call   8002f4 <vprintfmt>
}
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <vprintfmt>:
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 3c             	sub    $0x3c,%esp
  8002fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800303:	8b 7d 10             	mov    0x10(%ebp),%edi
  800306:	eb 0a                	jmp    800312 <vprintfmt+0x1e>
			putch(ch, putdat);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	53                   	push   %ebx
  80030c:	50                   	push   %eax
  80030d:	ff d6                	call   *%esi
  80030f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800312:	83 c7 01             	add    $0x1,%edi
  800315:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800319:	83 f8 25             	cmp    $0x25,%eax
  80031c:	74 0c                	je     80032a <vprintfmt+0x36>
			if (ch == '\0')
  80031e:	85 c0                	test   %eax,%eax
  800320:	75 e6                	jne    800308 <vprintfmt+0x14>
}
  800322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800325:	5b                   	pop    %ebx
  800326:	5e                   	pop    %esi
  800327:	5f                   	pop    %edi
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800335:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80033c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 a6 04 00 00    	ja     800802 <vprintfmt+0x50e>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800366:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800369:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036d:	eb d9                	jmp    800348 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800372:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800376:	eb d0                	jmp    800348 <vprintfmt+0x54>
  800378:	0f b6 d2             	movzbl %dl,%edx
  80037b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800386:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800389:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800390:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800393:	83 f9 09             	cmp    $0x9,%ecx
  800396:	77 55                	ja     8003ed <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800398:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039b:	eb e9                	jmp    800386 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8d 40 04             	lea    0x4(%eax),%eax
  8003ab:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8003b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8003b5:	79 91                	jns    800348 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003c4:	eb 82                	jmp    800348 <vprintfmt+0x54>
  8003c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	0f 49 c2             	cmovns %edx,%eax
  8003d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003d9:	e9 6a ff ff ff       	jmp    800348 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003e1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e8:	e9 5b ff ff ff       	jmp    800348 <vprintfmt+0x54>
  8003ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f3:	eb bc                	jmp    8003b1 <vprintfmt+0xbd>
			lflag++;
  8003f5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003fb:	e9 48 ff ff ff       	jmp    800348 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 78 04             	lea    0x4(%eax),%edi
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	53                   	push   %ebx
  80040a:	ff 30                	push   (%eax)
  80040c:	ff d6                	call   *%esi
			break;
  80040e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800414:	e9 88 03 00 00       	jmp    8007a1 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	8b 10                	mov    (%eax),%edx
  800421:	89 d0                	mov    %edx,%eax
  800423:	f7 d8                	neg    %eax
  800425:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800428:	83 f8 0f             	cmp    $0xf,%eax
  80042b:	7f 23                	jg     800450 <vprintfmt+0x15c>
  80042d:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800434:	85 d2                	test   %edx,%edx
  800436:	74 18                	je     800450 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800438:	52                   	push   %edx
  800439:	68 5c 12 80 00       	push   $0x80125c
  80043e:	53                   	push   %ebx
  80043f:	56                   	push   %esi
  800440:	e8 92 fe ff ff       	call   8002d7 <printfmt>
  800445:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800448:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044b:	e9 51 03 00 00       	jmp    8007a1 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800450:	50                   	push   %eax
  800451:	68 53 12 80 00       	push   $0x801253
  800456:	53                   	push   %ebx
  800457:	56                   	push   %esi
  800458:	e8 7a fe ff ff       	call   8002d7 <printfmt>
  80045d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800460:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800463:	e9 39 03 00 00       	jmp    8007a1 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	83 c0 04             	add    $0x4,%eax
  80046e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800476:	85 d2                	test   %edx,%edx
  800478:	b8 4c 12 80 00       	mov    $0x80124c,%eax
  80047d:	0f 45 c2             	cmovne %edx,%eax
  800480:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800483:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800487:	7e 06                	jle    80048f <vprintfmt+0x19b>
  800489:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048d:	75 0d                	jne    80049c <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800492:	89 c7                	mov    %eax,%edi
  800494:	03 45 d4             	add    -0x2c(%ebp),%eax
  800497:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80049a:	eb 55                	jmp    8004f1 <vprintfmt+0x1fd>
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 e0             	push   -0x20(%ebp)
  8004a2:	ff 75 cc             	push   -0x34(%ebp)
  8004a5:	e8 f5 03 00 00       	call   80089f <strnlen>
  8004aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ad:	29 c2                	sub    %eax,%edx
  8004af:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004be:	eb 0f                	jmp    8004cf <vprintfmt+0x1db>
					putch(padc, putdat);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	53                   	push   %ebx
  8004c4:	ff 75 d4             	push   -0x2c(%ebp)
  8004c7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c9:	83 ef 01             	sub    $0x1,%edi
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	85 ff                	test   %edi,%edi
  8004d1:	7f ed                	jg     8004c0 <vprintfmt+0x1cc>
  8004d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d6:	85 d2                	test   %edx,%edx
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	0f 49 c2             	cmovns %edx,%eax
  8004e0:	29 c2                	sub    %eax,%edx
  8004e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e5:	eb a8                	jmp    80048f <vprintfmt+0x19b>
					putch(ch, putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	52                   	push   %edx
  8004ec:	ff d6                	call   *%esi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004f4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f6:	83 c7 01             	add    $0x1,%edi
  8004f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fd:	0f be d0             	movsbl %al,%edx
  800500:	85 d2                	test   %edx,%edx
  800502:	74 4b                	je     80054f <vprintfmt+0x25b>
  800504:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800508:	78 06                	js     800510 <vprintfmt+0x21c>
  80050a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80050e:	78 1e                	js     80052e <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	74 d1                	je     8004e7 <vprintfmt+0x1f3>
  800516:	0f be c0             	movsbl %al,%eax
  800519:	83 e8 20             	sub    $0x20,%eax
  80051c:	83 f8 5e             	cmp    $0x5e,%eax
  80051f:	76 c6                	jbe    8004e7 <vprintfmt+0x1f3>
					putch('?', putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	53                   	push   %ebx
  800525:	6a 3f                	push   $0x3f
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb c3                	jmp    8004f1 <vprintfmt+0x1fd>
  80052e:	89 cf                	mov    %ecx,%edi
  800530:	eb 0e                	jmp    800540 <vprintfmt+0x24c>
				putch(' ', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 20                	push   $0x20
  800538:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053a:	83 ef 01             	sub    $0x1,%edi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	85 ff                	test   %edi,%edi
  800542:	7f ee                	jg     800532 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	e9 52 02 00 00       	jmp    8007a1 <vprintfmt+0x4ad>
  80054f:	89 cf                	mov    %ecx,%edi
  800551:	eb ed                	jmp    800540 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	83 c0 04             	add    $0x4,%eax
  800559:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800561:	85 d2                	test   %edx,%edx
  800563:	b8 4c 12 80 00       	mov    $0x80124c,%eax
  800568:	0f 45 c2             	cmovne %edx,%eax
  80056b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80056e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800572:	7e 06                	jle    80057a <vprintfmt+0x286>
  800574:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800578:	75 0d                	jne    800587 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057d:	89 c7                	mov    %eax,%edi
  80057f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800582:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800585:	eb 55                	jmp    8005dc <vprintfmt+0x2e8>
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 e0             	push   -0x20(%ebp)
  80058d:	ff 75 cc             	push   -0x34(%ebp)
  800590:	e8 0a 03 00 00       	call   80089f <strnlen>
  800595:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800598:	29 c2                	sub    %eax,%edx
  80059a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005a2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	eb 0f                	jmp    8005ba <vprintfmt+0x2c6>
					putch(padc, putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	53                   	push   %ebx
  8005af:	ff 75 d4             	push   -0x2c(%ebp)
  8005b2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ed                	jg     8005ab <vprintfmt+0x2b7>
  8005be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005c1:	85 d2                	test   %edx,%edx
  8005c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c8:	0f 49 c2             	cmovns %edx,%eax
  8005cb:	29 c2                	sub    %eax,%edx
  8005cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d0:	eb a8                	jmp    80057a <vprintfmt+0x286>
					putch(ch, putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	52                   	push   %edx
  8005d7:	ff d6                	call   *%esi
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005df:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005e1:	83 c7 01             	add    $0x1,%edi
  8005e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005e8:	0f be d0             	movsbl %al,%edx
  8005eb:	3c 3a                	cmp    $0x3a,%al
  8005ed:	74 4b                	je     80063a <vprintfmt+0x346>
  8005ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f3:	78 06                	js     8005fb <vprintfmt+0x307>
  8005f5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005f9:	78 1e                	js     800619 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ff:	74 d1                	je     8005d2 <vprintfmt+0x2de>
  800601:	0f be c0             	movsbl %al,%eax
  800604:	83 e8 20             	sub    $0x20,%eax
  800607:	83 f8 5e             	cmp    $0x5e,%eax
  80060a:	76 c6                	jbe    8005d2 <vprintfmt+0x2de>
					putch('?', putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	53                   	push   %ebx
  800610:	6a 3f                	push   $0x3f
  800612:	ff d6                	call   *%esi
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	eb c3                	jmp    8005dc <vprintfmt+0x2e8>
  800619:	89 cf                	mov    %ecx,%edi
  80061b:	eb 0e                	jmp    80062b <vprintfmt+0x337>
				putch(' ', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	53                   	push   %ebx
  800621:	6a 20                	push   $0x20
  800623:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	85 ff                	test   %edi,%edi
  80062d:	7f ee                	jg     80061d <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80062f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
  800635:	e9 67 01 00 00       	jmp    8007a1 <vprintfmt+0x4ad>
  80063a:	89 cf                	mov    %ecx,%edi
  80063c:	eb ed                	jmp    80062b <vprintfmt+0x337>
	if (lflag >= 2)
  80063e:	83 f9 01             	cmp    $0x1,%ecx
  800641:	7f 1b                	jg     80065e <vprintfmt+0x36a>
	else if (lflag)
  800643:	85 c9                	test   %ecx,%ecx
  800645:	74 63                	je     8006aa <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064f:	99                   	cltd   
  800650:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	eb 17                	jmp    800675 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 50 04             	mov    0x4(%eax),%edx
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800669:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 08             	lea    0x8(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800675:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800678:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80067b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800680:	85 c9                	test   %ecx,%ecx
  800682:	0f 89 ff 00 00 00    	jns    800787 <vprintfmt+0x493>
				putch('-', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 2d                	push   $0x2d
  80068e:	ff d6                	call   *%esi
				num = -(long long) num;
  800690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800693:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800696:	f7 da                	neg    %edx
  800698:	83 d1 00             	adc    $0x0,%ecx
  80069b:	f7 d9                	neg    %ecx
  80069d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a5:	e9 dd 00 00 00       	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	99                   	cltd   
  8006b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	eb b4                	jmp    800675 <vprintfmt+0x381>
	if (lflag >= 2)
  8006c1:	83 f9 01             	cmp    $0x1,%ecx
  8006c4:	7f 1e                	jg     8006e4 <vprintfmt+0x3f0>
	else if (lflag)
  8006c6:	85 c9                	test   %ecx,%ecx
  8006c8:	74 32                	je     8006fc <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 10                	mov    (%eax),%edx
  8006cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006da:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006df:	e9 a3 00 00 00       	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f2:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006f7:	e9 8b 00 00 00       	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	b9 00 00 00 00       	mov    $0x0,%ecx
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800711:	eb 74                	jmp    800787 <vprintfmt+0x493>
	if (lflag >= 2)
  800713:	83 f9 01             	cmp    $0x1,%ecx
  800716:	7f 1b                	jg     800733 <vprintfmt+0x43f>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	74 2c                	je     800748 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800731:	eb 54                	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	8b 48 04             	mov    0x4(%eax),%ecx
  80073b:	8d 40 08             	lea    0x8(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800741:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800746:	eb 3f                	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 10                	mov    (%eax),%edx
  80074d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800758:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80075d:	eb 28                	jmp    800787 <vprintfmt+0x493>
			putch('0', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	53                   	push   %ebx
  800763:	6a 30                	push   $0x30
  800765:	ff d6                	call   *%esi
			putch('x', putdat);
  800767:	83 c4 08             	add    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	6a 78                	push   $0x78
  80076d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 10                	mov    (%eax),%edx
  800774:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800779:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077c:	8d 40 04             	lea    0x4(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800782:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800787:	83 ec 0c             	sub    $0xc,%esp
  80078a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	ff 75 d4             	push   -0x2c(%ebp)
  800792:	57                   	push   %edi
  800793:	51                   	push   %ecx
  800794:	52                   	push   %edx
  800795:	89 da                	mov    %ebx,%edx
  800797:	89 f0                	mov    %esi,%eax
  800799:	e8 73 fa ff ff       	call   800211 <printnum>
			break;
  80079e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a1:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a4:	e9 69 fb ff ff       	jmp    800312 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007a9:	83 f9 01             	cmp    $0x1,%ecx
  8007ac:	7f 1b                	jg     8007c9 <vprintfmt+0x4d5>
	else if (lflag)
  8007ae:	85 c9                	test   %ecx,%ecx
  8007b0:	74 2c                	je     8007de <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8007c7:	eb be                	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d1:	8d 40 08             	lea    0x8(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007dc:	eb a9                	jmp    800787 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 10                	mov    (%eax),%edx
  8007e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007f3:	eb 92                	jmp    800787 <vprintfmt+0x493>
			putch(ch, putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 25                	push   $0x25
  8007fb:	ff d6                	call   *%esi
			break;
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	eb 9f                	jmp    8007a1 <vprintfmt+0x4ad>
			putch('%', putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	6a 25                	push   $0x25
  800808:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 f8                	mov    %edi,%eax
  80080f:	eb 03                	jmp    800814 <vprintfmt+0x520>
  800811:	83 e8 01             	sub    $0x1,%eax
  800814:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800818:	75 f7                	jne    800811 <vprintfmt+0x51d>
  80081a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80081d:	eb 82                	jmp    8007a1 <vprintfmt+0x4ad>

0080081f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	83 ec 18             	sub    $0x18,%esp
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800832:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083c:	85 c0                	test   %eax,%eax
  80083e:	74 26                	je     800866 <vsnprintf+0x47>
  800840:	85 d2                	test   %edx,%edx
  800842:	7e 22                	jle    800866 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800844:	ff 75 14             	push   0x14(%ebp)
  800847:	ff 75 10             	push   0x10(%ebp)
  80084a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	68 ba 02 80 00       	push   $0x8002ba
  800853:	e8 9c fa ff ff       	call   8002f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800861:	83 c4 10             	add    $0x10,%esp
}
  800864:	c9                   	leave  
  800865:	c3                   	ret    
		return -E_INVAL;
  800866:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086b:	eb f7                	jmp    800864 <vsnprintf+0x45>

0080086d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800873:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800876:	50                   	push   %eax
  800877:	ff 75 10             	push   0x10(%ebp)
  80087a:	ff 75 0c             	push   0xc(%ebp)
  80087d:	ff 75 08             	push   0x8(%ebp)
  800880:	e8 9a ff ff ff       	call   80081f <vsnprintf>
	va_end(ap);

	return rc;
}
  800885:	c9                   	leave  
  800886:	c3                   	ret    

00800887 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088d:	b8 00 00 00 00       	mov    $0x0,%eax
  800892:	eb 03                	jmp    800897 <strlen+0x10>
		n++;
  800894:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800897:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80089b:	75 f7                	jne    800894 <strlen+0xd>
	return n;
}
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	eb 03                	jmp    8008b2 <strnlen+0x13>
		n++;
  8008af:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b2:	39 d0                	cmp    %edx,%eax
  8008b4:	74 08                	je     8008be <strnlen+0x1f>
  8008b6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008ba:	75 f3                	jne    8008af <strnlen+0x10>
  8008bc:	89 c2                	mov    %eax,%edx
	return n;
}
  8008be:	89 d0                	mov    %edx,%eax
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	53                   	push   %ebx
  8008c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d1:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008d5:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008d8:	83 c0 01             	add    $0x1,%eax
  8008db:	84 d2                	test   %dl,%dl
  8008dd:	75 f2                	jne    8008d1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008df:	89 c8                	mov    %ecx,%eax
  8008e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e4:	c9                   	leave  
  8008e5:	c3                   	ret    

008008e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	53                   	push   %ebx
  8008ea:	83 ec 10             	sub    $0x10,%esp
  8008ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f0:	53                   	push   %ebx
  8008f1:	e8 91 ff ff ff       	call   800887 <strlen>
  8008f6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f9:	ff 75 0c             	push   0xc(%ebp)
  8008fc:	01 d8                	add    %ebx,%eax
  8008fe:	50                   	push   %eax
  8008ff:	e8 be ff ff ff       	call   8008c2 <strcpy>
	return dst;
}
  800904:	89 d8                	mov    %ebx,%eax
  800906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	56                   	push   %esi
  80090f:	53                   	push   %ebx
  800910:	8b 75 08             	mov    0x8(%ebp),%esi
  800913:	8b 55 0c             	mov    0xc(%ebp),%edx
  800916:	89 f3                	mov    %esi,%ebx
  800918:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091b:	89 f0                	mov    %esi,%eax
  80091d:	eb 0f                	jmp    80092e <strncpy+0x23>
		*dst++ = *src;
  80091f:	83 c0 01             	add    $0x1,%eax
  800922:	0f b6 0a             	movzbl (%edx),%ecx
  800925:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800928:	80 f9 01             	cmp    $0x1,%cl
  80092b:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80092e:	39 d8                	cmp    %ebx,%eax
  800930:	75 ed                	jne    80091f <strncpy+0x14>
	}
	return ret;
}
  800932:	89 f0                	mov    %esi,%eax
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	8b 75 08             	mov    0x8(%ebp),%esi
  800940:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800943:	8b 55 10             	mov    0x10(%ebp),%edx
  800946:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800948:	85 d2                	test   %edx,%edx
  80094a:	74 21                	je     80096d <strlcpy+0x35>
  80094c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800950:	89 f2                	mov    %esi,%edx
  800952:	eb 09                	jmp    80095d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800954:	83 c1 01             	add    $0x1,%ecx
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	74 09                	je     80096a <strlcpy+0x32>
  800961:	0f b6 19             	movzbl (%ecx),%ebx
  800964:	84 db                	test   %bl,%bl
  800966:	75 ec                	jne    800954 <strlcpy+0x1c>
  800968:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80096d:	29 f0                	sub    %esi,%eax
}
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097c:	eb 06                	jmp    800984 <strcmp+0x11>
		p++, q++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800984:	0f b6 01             	movzbl (%ecx),%eax
  800987:	84 c0                	test   %al,%al
  800989:	74 04                	je     80098f <strcmp+0x1c>
  80098b:	3a 02                	cmp    (%edx),%al
  80098d:	74 ef                	je     80097e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098f:	0f b6 c0             	movzbl %al,%eax
  800992:	0f b6 12             	movzbl (%edx),%edx
  800995:	29 d0                	sub    %edx,%eax
}
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a3:	89 c3                	mov    %eax,%ebx
  8009a5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009a8:	eb 06                	jmp    8009b0 <strncmp+0x17>
		n--, p++, q++;
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b0:	39 d8                	cmp    %ebx,%eax
  8009b2:	74 18                	je     8009cc <strncmp+0x33>
  8009b4:	0f b6 08             	movzbl (%eax),%ecx
  8009b7:	84 c9                	test   %cl,%cl
  8009b9:	74 04                	je     8009bf <strncmp+0x26>
  8009bb:	3a 0a                	cmp    (%edx),%cl
  8009bd:	74 eb                	je     8009aa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bf:	0f b6 00             	movzbl (%eax),%eax
  8009c2:	0f b6 12             	movzbl (%edx),%edx
  8009c5:	29 d0                	sub    %edx,%eax
}
  8009c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    
		return 0;
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	eb f4                	jmp    8009c7 <strncmp+0x2e>

008009d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009dd:	eb 03                	jmp    8009e2 <strchr+0xf>
  8009df:	83 c0 01             	add    $0x1,%eax
  8009e2:	0f b6 10             	movzbl (%eax),%edx
  8009e5:	84 d2                	test   %dl,%dl
  8009e7:	74 06                	je     8009ef <strchr+0x1c>
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	75 f2                	jne    8009df <strchr+0xc>
  8009ed:	eb 05                	jmp    8009f4 <strchr+0x21>
			return (char *) s;
	return 0;
  8009ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a00:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a03:	38 ca                	cmp    %cl,%dl
  800a05:	74 09                	je     800a10 <strfind+0x1a>
  800a07:	84 d2                	test   %dl,%dl
  800a09:	74 05                	je     800a10 <strfind+0x1a>
	for (; *s; s++)
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	eb f0                	jmp    800a00 <strfind+0xa>
			break;
	return (char *) s;
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	57                   	push   %edi
  800a16:	56                   	push   %esi
  800a17:	53                   	push   %ebx
  800a18:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a1e:	85 c9                	test   %ecx,%ecx
  800a20:	74 2f                	je     800a51 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a22:	89 f8                	mov    %edi,%eax
  800a24:	09 c8                	or     %ecx,%eax
  800a26:	a8 03                	test   $0x3,%al
  800a28:	75 21                	jne    800a4b <memset+0x39>
		c &= 0xFF;
  800a2a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	89 d3                	mov    %edx,%ebx
  800a35:	c1 e3 18             	shl    $0x18,%ebx
  800a38:	89 d6                	mov    %edx,%esi
  800a3a:	c1 e6 10             	shl    $0x10,%esi
  800a3d:	09 f3                	or     %esi,%ebx
  800a3f:	09 da                	or     %ebx,%edx
  800a41:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a43:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a46:	fc                   	cld    
  800a47:	f3 ab                	rep stos %eax,%es:(%edi)
  800a49:	eb 06                	jmp    800a51 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	fc                   	cld    
  800a4f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a51:	89 f8                	mov    %edi,%eax
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5f                   	pop    %edi
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	57                   	push   %edi
  800a5c:	56                   	push   %esi
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a66:	39 c6                	cmp    %eax,%esi
  800a68:	73 32                	jae    800a9c <memmove+0x44>
  800a6a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a6d:	39 c2                	cmp    %eax,%edx
  800a6f:	76 2b                	jbe    800a9c <memmove+0x44>
		s += n;
		d += n;
  800a71:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a74:	89 d6                	mov    %edx,%esi
  800a76:	09 fe                	or     %edi,%esi
  800a78:	09 ce                	or     %ecx,%esi
  800a7a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a80:	75 0e                	jne    800a90 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a82:	83 ef 04             	sub    $0x4,%edi
  800a85:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a8b:	fd                   	std    
  800a8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8e:	eb 09                	jmp    800a99 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a90:	83 ef 01             	sub    $0x1,%edi
  800a93:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a96:	fd                   	std    
  800a97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a99:	fc                   	cld    
  800a9a:	eb 1a                	jmp    800ab6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9c:	89 f2                	mov    %esi,%edx
  800a9e:	09 c2                	or     %eax,%edx
  800aa0:	09 ca                	or     %ecx,%edx
  800aa2:	f6 c2 03             	test   $0x3,%dl
  800aa5:	75 0a                	jne    800ab1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	fc                   	cld    
  800aad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aaf:	eb 05                	jmp    800ab6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab1:	89 c7                	mov    %eax,%edi
  800ab3:	fc                   	cld    
  800ab4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab6:	5e                   	pop    %esi
  800ab7:	5f                   	pop    %edi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac0:	ff 75 10             	push   0x10(%ebp)
  800ac3:	ff 75 0c             	push   0xc(%ebp)
  800ac6:	ff 75 08             	push   0x8(%ebp)
  800ac9:	e8 8a ff ff ff       	call   800a58 <memmove>
}
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	89 c6                	mov    %eax,%esi
  800add:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae0:	eb 06                	jmp    800ae8 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800ae8:	39 f0                	cmp    %esi,%eax
  800aea:	74 14                	je     800b00 <memcmp+0x30>
		if (*s1 != *s2)
  800aec:	0f b6 08             	movzbl (%eax),%ecx
  800aef:	0f b6 1a             	movzbl (%edx),%ebx
  800af2:	38 d9                	cmp    %bl,%cl
  800af4:	74 ec                	je     800ae2 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800af6:	0f b6 c1             	movzbl %cl,%eax
  800af9:	0f b6 db             	movzbl %bl,%ebx
  800afc:	29 d8                	sub    %ebx,%eax
  800afe:	eb 05                	jmp    800b05 <memcmp+0x35>
	}

	return 0;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b12:	89 c2                	mov    %eax,%edx
  800b14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b17:	eb 03                	jmp    800b1c <memfind+0x13>
  800b19:	83 c0 01             	add    $0x1,%eax
  800b1c:	39 d0                	cmp    %edx,%eax
  800b1e:	73 04                	jae    800b24 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b20:	38 08                	cmp    %cl,(%eax)
  800b22:	75 f5                	jne    800b19 <memfind+0x10>
			break;
	return (void *) s;
}
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
  800b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b32:	eb 03                	jmp    800b37 <strtol+0x11>
		s++;
  800b34:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b37:	0f b6 02             	movzbl (%edx),%eax
  800b3a:	3c 20                	cmp    $0x20,%al
  800b3c:	74 f6                	je     800b34 <strtol+0xe>
  800b3e:	3c 09                	cmp    $0x9,%al
  800b40:	74 f2                	je     800b34 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b42:	3c 2b                	cmp    $0x2b,%al
  800b44:	74 2a                	je     800b70 <strtol+0x4a>
	int neg = 0;
  800b46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4b:	3c 2d                	cmp    $0x2d,%al
  800b4d:	74 2b                	je     800b7a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b55:	75 0f                	jne    800b66 <strtol+0x40>
  800b57:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5a:	74 28                	je     800b84 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b63:	0f 44 d8             	cmove  %eax,%ebx
  800b66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6e:	eb 46                	jmp    800bb6 <strtol+0x90>
		s++;
  800b70:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b73:	bf 00 00 00 00       	mov    $0x0,%edi
  800b78:	eb d5                	jmp    800b4f <strtol+0x29>
		s++, neg = 1;
  800b7a:	83 c2 01             	add    $0x1,%edx
  800b7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b82:	eb cb                	jmp    800b4f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b84:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b88:	74 0e                	je     800b98 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	75 d8                	jne    800b66 <strtol+0x40>
		s++, base = 8;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b96:	eb ce                	jmp    800b66 <strtol+0x40>
		s += 2, base = 16;
  800b98:	83 c2 02             	add    $0x2,%edx
  800b9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba0:	eb c4                	jmp    800b66 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba2:	0f be c0             	movsbl %al,%eax
  800ba5:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bab:	7d 3a                	jge    800be7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bad:	83 c2 01             	add    $0x1,%edx
  800bb0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bb4:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bb6:	0f b6 02             	movzbl (%edx),%eax
  800bb9:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 09             	cmp    $0x9,%bl
  800bc1:	76 df                	jbe    800ba2 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bc3:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bc6:	89 f3                	mov    %esi,%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 08                	ja     800bd5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bcd:	0f be c0             	movsbl %al,%eax
  800bd0:	83 e8 57             	sub    $0x57,%eax
  800bd3:	eb d3                	jmp    800ba8 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bd5:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bd8:	89 f3                	mov    %esi,%ebx
  800bda:	80 fb 19             	cmp    $0x19,%bl
  800bdd:	77 08                	ja     800be7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bdf:	0f be c0             	movsbl %al,%eax
  800be2:	83 e8 37             	sub    $0x37,%eax
  800be5:	eb c1                	jmp    800ba8 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 05                	je     800bf2 <strtol+0xcc>
		*endptr = (char *) s;
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800bf2:	89 c8                	mov    %ecx,%eax
  800bf4:	f7 d8                	neg    %eax
  800bf6:	85 ff                	test   %edi,%edi
  800bf8:	0f 45 c8             	cmovne %eax,%ecx
}
  800bfb:	89 c8                	mov    %ecx,%eax
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	57                   	push   %edi
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c08:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	89 c3                	mov    %eax,%ebx
  800c15:	89 c7                	mov    %eax,%edi
  800c17:	89 c6                	mov    %eax,%esi
  800c19:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c26:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c30:	89 d1                	mov    %edx,%ecx
  800c32:	89 d3                	mov    %edx,%ebx
  800c34:	89 d7                	mov    %edx,%edi
  800c36:	89 d6                	mov    %edx,%esi
  800c38:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5f                   	pop    %edi
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c50:	b8 03 00 00 00       	mov    $0x3,%eax
  800c55:	89 cb                	mov    %ecx,%ebx
  800c57:	89 cf                	mov    %ecx,%edi
  800c59:	89 ce                	mov    %ecx,%esi
  800c5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	7f 08                	jg     800c69 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	50                   	push   %eax
  800c6d:	6a 03                	push   $0x3
  800c6f:	68 3f 15 80 00       	push   $0x80153f
  800c74:	6a 23                	push   $0x23
  800c76:	68 5c 15 80 00       	push   $0x80155c
  800c7b:	e8 a2 f4 ff ff       	call   800122 <_panic>

00800c80 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c86:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c90:	89 d1                	mov    %edx,%ecx
  800c92:	89 d3                	mov    %edx,%ebx
  800c94:	89 d7                	mov    %edx,%edi
  800c96:	89 d6                	mov    %edx,%esi
  800c98:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_yield>:

void
sys_yield(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	57                   	push   %edi
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  800caa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800caf:	89 d1                	mov    %edx,%ecx
  800cb1:	89 d3                	mov    %edx,%ebx
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	89 d6                	mov    %edx,%esi
  800cb7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	be 00 00 00 00       	mov    $0x0,%esi
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cda:	89 f7                	mov    %esi,%edi
  800cdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	7f 08                	jg     800cea <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	50                   	push   %eax
  800cee:	6a 04                	push   $0x4
  800cf0:	68 3f 15 80 00       	push   $0x80153f
  800cf5:	6a 23                	push   $0x23
  800cf7:	68 5c 15 80 00       	push   $0x80155c
  800cfc:	e8 21 f4 ff ff       	call   800122 <_panic>

00800d01 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	b8 05 00 00 00       	mov    $0x5,%eax
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 05                	push   $0x5
  800d32:	68 3f 15 80 00       	push   $0x80153f
  800d37:	6a 23                	push   $0x23
  800d39:	68 5c 15 80 00       	push   $0x80155c
  800d3e:	e8 df f3 ff ff       	call   800122 <_panic>

00800d43 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5c:	89 df                	mov    %ebx,%edi
  800d5e:	89 de                	mov    %ebx,%esi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 06                	push   $0x6
  800d74:	68 3f 15 80 00       	push   $0x80153f
  800d79:	6a 23                	push   $0x23
  800d7b:	68 5c 15 80 00       	push   $0x80155c
  800d80:	e8 9d f3 ff ff       	call   800122 <_panic>

00800d85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 08 00 00 00       	mov    $0x8,%eax
  800d9e:	89 df                	mov    %ebx,%edi
  800da0:	89 de                	mov    %ebx,%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 08                	push   $0x8
  800db6:	68 3f 15 80 00       	push   $0x80153f
  800dbb:	6a 23                	push   $0x23
  800dbd:	68 5c 15 80 00       	push   $0x80155c
  800dc2:	e8 5b f3 ff ff       	call   800122 <_panic>

00800dc7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	b8 09 00 00 00       	mov    $0x9,%eax
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 09                	push   $0x9
  800df8:	68 3f 15 80 00       	push   $0x80153f
  800dfd:	6a 23                	push   $0x23
  800dff:	68 5c 15 80 00       	push   $0x80155c
  800e04:	e8 19 f3 ff ff       	call   800122 <_panic>

00800e09 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e22:	89 df                	mov    %ebx,%edi
  800e24:	89 de                	mov    %ebx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 0a                	push   $0xa
  800e3a:	68 3f 15 80 00       	push   $0x80153f
  800e3f:	6a 23                	push   $0x23
  800e41:	68 5c 15 80 00       	push   $0x80155c
  800e46:	e8 d7 f2 ff ff       	call   800122 <_panic>

00800e4b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e57:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e5c:	be 00 00 00 00       	mov    $0x0,%esi
  800e61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e67:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	57                   	push   %edi
  800e72:	56                   	push   %esi
  800e73:	53                   	push   %ebx
  800e74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e77:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e84:	89 cb                	mov    %ecx,%ebx
  800e86:	89 cf                	mov    %ecx,%edi
  800e88:	89 ce                	mov    %ecx,%esi
  800e8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7f 08                	jg     800e98 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	50                   	push   %eax
  800e9c:	6a 0d                	push   $0xd
  800e9e:	68 3f 15 80 00       	push   $0x80153f
  800ea3:	6a 23                	push   $0x23
  800ea5:	68 5c 15 80 00       	push   $0x80155c
  800eaa:	e8 73 f2 ff ff       	call   800122 <_panic>

00800eaf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800eb5:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ebc:	74 20                	je     800ede <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	68 1e 0f 80 00       	push   $0x800f1e
  800ece:	6a 00                	push   $0x0
  800ed0:	e8 34 ff ff ff       	call   800e09 <sys_env_set_pgfault_upcall>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	78 2e                	js     800f0a <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  800ede:	83 ec 04             	sub    $0x4,%esp
  800ee1:	6a 07                	push   $0x7
  800ee3:	68 00 f0 bf ee       	push   $0xeebff000
  800ee8:	6a 00                	push   $0x0
  800eea:	e8 cf fd ff ff       	call   800cbe <sys_page_alloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	79 c8                	jns    800ebe <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  800ef6:	83 ec 04             	sub    $0x4,%esp
  800ef9:	68 6c 15 80 00       	push   $0x80156c
  800efe:	6a 21                	push   $0x21
  800f00:	68 cf 15 80 00       	push   $0x8015cf
  800f05:	e8 18 f2 ff ff       	call   800122 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800f0a:	83 ec 04             	sub    $0x4,%esp
  800f0d:	68 98 15 80 00       	push   $0x801598
  800f12:	6a 27                	push   $0x27
  800f14:	68 cf 15 80 00       	push   $0x8015cf
  800f19:	e8 04 f2 ff ff       	call   800122 <_panic>

00800f1e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f1e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f1f:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800f24:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f26:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  800f29:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  800f2d:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  800f32:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  800f36:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  800f38:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800f3b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800f3c:	83 c4 04             	add    $0x4,%esp
	popfl
  800f3f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f40:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f41:	c3                   	ret    
  800f42:	66 90                	xchg   %ax,%ax
  800f44:	66 90                	xchg   %ax,%ax
  800f46:	66 90                	xchg   %ax,%ax
  800f48:	66 90                	xchg   %ax,%ax
  800f4a:	66 90                	xchg   %ax,%ax
  800f4c:	66 90                	xchg   %ax,%ax
  800f4e:	66 90                	xchg   %ax,%ax

00800f50 <__udivdi3>:
  800f50:	f3 0f 1e fb          	endbr32 
  800f54:	55                   	push   %ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 1c             	sub    $0x1c,%esp
  800f5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f63:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	75 19                	jne    800f88 <__udivdi3+0x38>
  800f6f:	39 f3                	cmp    %esi,%ebx
  800f71:	76 4d                	jbe    800fc0 <__udivdi3+0x70>
  800f73:	31 ff                	xor    %edi,%edi
  800f75:	89 e8                	mov    %ebp,%eax
  800f77:	89 f2                	mov    %esi,%edx
  800f79:	f7 f3                	div    %ebx
  800f7b:	89 fa                	mov    %edi,%edx
  800f7d:	83 c4 1c             	add    $0x1c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	8d 76 00             	lea    0x0(%esi),%esi
  800f88:	39 f0                	cmp    %esi,%eax
  800f8a:	76 14                	jbe    800fa0 <__udivdi3+0x50>
  800f8c:	31 ff                	xor    %edi,%edi
  800f8e:	31 c0                	xor    %eax,%eax
  800f90:	89 fa                	mov    %edi,%edx
  800f92:	83 c4 1c             	add    $0x1c,%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
  800f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fa0:	0f bd f8             	bsr    %eax,%edi
  800fa3:	83 f7 1f             	xor    $0x1f,%edi
  800fa6:	75 48                	jne    800ff0 <__udivdi3+0xa0>
  800fa8:	39 f0                	cmp    %esi,%eax
  800faa:	72 06                	jb     800fb2 <__udivdi3+0x62>
  800fac:	31 c0                	xor    %eax,%eax
  800fae:	39 eb                	cmp    %ebp,%ebx
  800fb0:	77 de                	ja     800f90 <__udivdi3+0x40>
  800fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb7:	eb d7                	jmp    800f90 <__udivdi3+0x40>
  800fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc0:	89 d9                	mov    %ebx,%ecx
  800fc2:	85 db                	test   %ebx,%ebx
  800fc4:	75 0b                	jne    800fd1 <__udivdi3+0x81>
  800fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	f7 f3                	div    %ebx
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	31 d2                	xor    %edx,%edx
  800fd3:	89 f0                	mov    %esi,%eax
  800fd5:	f7 f1                	div    %ecx
  800fd7:	89 c6                	mov    %eax,%esi
  800fd9:	89 e8                	mov    %ebp,%eax
  800fdb:	89 f7                	mov    %esi,%edi
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 fa                	mov    %edi,%edx
  800fe1:	83 c4 1c             	add    $0x1c,%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    
  800fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff0:	89 f9                	mov    %edi,%ecx
  800ff2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ff7:	29 fa                	sub    %edi,%edx
  800ff9:	d3 e0                	shl    %cl,%eax
  800ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fff:	89 d1                	mov    %edx,%ecx
  801001:	89 d8                	mov    %ebx,%eax
  801003:	d3 e8                	shr    %cl,%eax
  801005:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801009:	09 c1                	or     %eax,%ecx
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801011:	89 f9                	mov    %edi,%ecx
  801013:	d3 e3                	shl    %cl,%ebx
  801015:	89 d1                	mov    %edx,%ecx
  801017:	d3 e8                	shr    %cl,%eax
  801019:	89 f9                	mov    %edi,%ecx
  80101b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80101f:	89 eb                	mov    %ebp,%ebx
  801021:	d3 e6                	shl    %cl,%esi
  801023:	89 d1                	mov    %edx,%ecx
  801025:	d3 eb                	shr    %cl,%ebx
  801027:	09 f3                	or     %esi,%ebx
  801029:	89 c6                	mov    %eax,%esi
  80102b:	89 f2                	mov    %esi,%edx
  80102d:	89 d8                	mov    %ebx,%eax
  80102f:	f7 74 24 08          	divl   0x8(%esp)
  801033:	89 d6                	mov    %edx,%esi
  801035:	89 c3                	mov    %eax,%ebx
  801037:	f7 64 24 0c          	mull   0xc(%esp)
  80103b:	39 d6                	cmp    %edx,%esi
  80103d:	72 19                	jb     801058 <__udivdi3+0x108>
  80103f:	89 f9                	mov    %edi,%ecx
  801041:	d3 e5                	shl    %cl,%ebp
  801043:	39 c5                	cmp    %eax,%ebp
  801045:	73 04                	jae    80104b <__udivdi3+0xfb>
  801047:	39 d6                	cmp    %edx,%esi
  801049:	74 0d                	je     801058 <__udivdi3+0x108>
  80104b:	89 d8                	mov    %ebx,%eax
  80104d:	31 ff                	xor    %edi,%edi
  80104f:	e9 3c ff ff ff       	jmp    800f90 <__udivdi3+0x40>
  801054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801058:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80105b:	31 ff                	xor    %edi,%edi
  80105d:	e9 2e ff ff ff       	jmp    800f90 <__udivdi3+0x40>
  801062:	66 90                	xchg   %ax,%ax
  801064:	66 90                	xchg   %ax,%ax
  801066:	66 90                	xchg   %ax,%ax
  801068:	66 90                	xchg   %ax,%ax
  80106a:	66 90                	xchg   %ax,%ax
  80106c:	66 90                	xchg   %ax,%ax
  80106e:	66 90                	xchg   %ax,%ax

00801070 <__umoddi3>:
  801070:	f3 0f 1e fb          	endbr32 
  801074:	55                   	push   %ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 1c             	sub    $0x1c,%esp
  80107b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80107f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801083:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801087:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80108b:	89 f0                	mov    %esi,%eax
  80108d:	89 da                	mov    %ebx,%edx
  80108f:	85 ff                	test   %edi,%edi
  801091:	75 15                	jne    8010a8 <__umoddi3+0x38>
  801093:	39 dd                	cmp    %ebx,%ebp
  801095:	76 39                	jbe    8010d0 <__umoddi3+0x60>
  801097:	f7 f5                	div    %ebp
  801099:	89 d0                	mov    %edx,%eax
  80109b:	31 d2                	xor    %edx,%edx
  80109d:	83 c4 1c             	add    $0x1c,%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
  8010a5:	8d 76 00             	lea    0x0(%esi),%esi
  8010a8:	39 df                	cmp    %ebx,%edi
  8010aa:	77 f1                	ja     80109d <__umoddi3+0x2d>
  8010ac:	0f bd cf             	bsr    %edi,%ecx
  8010af:	83 f1 1f             	xor    $0x1f,%ecx
  8010b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010b6:	75 40                	jne    8010f8 <__umoddi3+0x88>
  8010b8:	39 df                	cmp    %ebx,%edi
  8010ba:	72 04                	jb     8010c0 <__umoddi3+0x50>
  8010bc:	39 f5                	cmp    %esi,%ebp
  8010be:	77 dd                	ja     80109d <__umoddi3+0x2d>
  8010c0:	89 da                	mov    %ebx,%edx
  8010c2:	89 f0                	mov    %esi,%eax
  8010c4:	29 e8                	sub    %ebp,%eax
  8010c6:	19 fa                	sbb    %edi,%edx
  8010c8:	eb d3                	jmp    80109d <__umoddi3+0x2d>
  8010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010d0:	89 e9                	mov    %ebp,%ecx
  8010d2:	85 ed                	test   %ebp,%ebp
  8010d4:	75 0b                	jne    8010e1 <__umoddi3+0x71>
  8010d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010db:	31 d2                	xor    %edx,%edx
  8010dd:	f7 f5                	div    %ebp
  8010df:	89 c1                	mov    %eax,%ecx
  8010e1:	89 d8                	mov    %ebx,%eax
  8010e3:	31 d2                	xor    %edx,%edx
  8010e5:	f7 f1                	div    %ecx
  8010e7:	89 f0                	mov    %esi,%eax
  8010e9:	f7 f1                	div    %ecx
  8010eb:	89 d0                	mov    %edx,%eax
  8010ed:	31 d2                	xor    %edx,%edx
  8010ef:	eb ac                	jmp    80109d <__umoddi3+0x2d>
  8010f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010fc:	ba 20 00 00 00       	mov    $0x20,%edx
  801101:	29 c2                	sub    %eax,%edx
  801103:	89 c1                	mov    %eax,%ecx
  801105:	89 e8                	mov    %ebp,%eax
  801107:	d3 e7                	shl    %cl,%edi
  801109:	89 d1                	mov    %edx,%ecx
  80110b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80110f:	d3 e8                	shr    %cl,%eax
  801111:	89 c1                	mov    %eax,%ecx
  801113:	8b 44 24 04          	mov    0x4(%esp),%eax
  801117:	09 f9                	or     %edi,%ecx
  801119:	89 df                	mov    %ebx,%edi
  80111b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80111f:	89 c1                	mov    %eax,%ecx
  801121:	d3 e5                	shl    %cl,%ebp
  801123:	89 d1                	mov    %edx,%ecx
  801125:	d3 ef                	shr    %cl,%edi
  801127:	89 c1                	mov    %eax,%ecx
  801129:	89 f0                	mov    %esi,%eax
  80112b:	d3 e3                	shl    %cl,%ebx
  80112d:	89 d1                	mov    %edx,%ecx
  80112f:	89 fa                	mov    %edi,%edx
  801131:	d3 e8                	shr    %cl,%eax
  801133:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801138:	09 d8                	or     %ebx,%eax
  80113a:	f7 74 24 08          	divl   0x8(%esp)
  80113e:	89 d3                	mov    %edx,%ebx
  801140:	d3 e6                	shl    %cl,%esi
  801142:	f7 e5                	mul    %ebp
  801144:	89 c7                	mov    %eax,%edi
  801146:	89 d1                	mov    %edx,%ecx
  801148:	39 d3                	cmp    %edx,%ebx
  80114a:	72 06                	jb     801152 <__umoddi3+0xe2>
  80114c:	75 0e                	jne    80115c <__umoddi3+0xec>
  80114e:	39 c6                	cmp    %eax,%esi
  801150:	73 0a                	jae    80115c <__umoddi3+0xec>
  801152:	29 e8                	sub    %ebp,%eax
  801154:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801158:	89 d1                	mov    %edx,%ecx
  80115a:	89 c7                	mov    %eax,%edi
  80115c:	89 f5                	mov    %esi,%ebp
  80115e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801162:	29 fd                	sub    %edi,%ebp
  801164:	19 cb                	sbb    %ecx,%ebx
  801166:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80116b:	89 d8                	mov    %ebx,%eax
  80116d:	d3 e0                	shl    %cl,%eax
  80116f:	89 f1                	mov    %esi,%ecx
  801171:	d3 ed                	shr    %cl,%ebp
  801173:	d3 eb                	shr    %cl,%ebx
  801175:	09 e8                	or     %ebp,%eax
  801177:	89 da                	mov    %ebx,%edx
  801179:	83 c4 1c             	add    $0x1c,%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5f                   	pop    %edi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    
