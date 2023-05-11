
obj/user/forktree.debug:     file format elf32-i386


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

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 11 0c 00 00       	call   800c53 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 40 14 80 00       	push   $0x801440
  80004c:	e8 7f 01 00 00       	call   8001d0 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 d7 07 00 00       	call   80085a <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 51 14 80 00       	push   $0x801451
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 94 07 00 00       	call   800840 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 cd 0e 00 00       	call   800f81 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 50 14 80 00       	push   $0x801450
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

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
  8000ee:	e8 60 0b 00 00       	call   800c53 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 04 20 80 00       	mov    %eax,0x802004

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
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

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
  800131:	e8 dc 0a 00 00       	call   800c12 <sys_env_destroy>
}
  800136:	83 c4 10             	add    $0x10,%esp
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	53                   	push   %ebx
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800145:	8b 13                	mov    (%ebx),%edx
  800147:	8d 42 01             	lea    0x1(%edx),%eax
  80014a:	89 03                	mov    %eax,(%ebx)
  80014c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80014f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800153:	3d ff 00 00 00       	cmp    $0xff,%eax
  800158:	74 09                	je     800163 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800161:	c9                   	leave  
  800162:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	68 ff 00 00 00       	push   $0xff
  80016b:	8d 43 08             	lea    0x8(%ebx),%eax
  80016e:	50                   	push   %eax
  80016f:	e8 61 0a 00 00       	call   800bd5 <sys_cputs>
		b->idx = 0;
  800174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	eb db                	jmp    80015a <putch+0x1f>

0080017f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800188:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018f:	00 00 00 
	b.cnt = 0;
  800192:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800199:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019c:	ff 75 0c             	push   0xc(%ebp)
  80019f:	ff 75 08             	push   0x8(%ebp)
  8001a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	68 3b 01 80 00       	push   $0x80013b
  8001ae:	e8 14 01 00 00       	call   8002c7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b3:	83 c4 08             	add    $0x8,%esp
  8001b6:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8001bc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 0d 0a 00 00       	call   800bd5 <sys_cputs>

	return b.cnt;
}
  8001c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d9:	50                   	push   %eax
  8001da:	ff 75 08             	push   0x8(%ebp)
  8001dd:	e8 9d ff ff ff       	call   80017f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    

008001e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	57                   	push   %edi
  8001e8:	56                   	push   %esi
  8001e9:	53                   	push   %ebx
  8001ea:	83 ec 1c             	sub    $0x1c,%esp
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 d6                	mov    %edx,%esi
  8001f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f7:	89 d1                	mov    %edx,%ecx
  8001f9:	89 c2                	mov    %eax,%edx
  8001fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800201:	8b 45 10             	mov    0x10(%ebp),%eax
  800204:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800207:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800211:	39 c2                	cmp    %eax,%edx
  800213:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800216:	72 3e                	jb     800256 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	ff 75 18             	push   0x18(%ebp)
  80021e:	83 eb 01             	sub    $0x1,%ebx
  800221:	53                   	push   %ebx
  800222:	50                   	push   %eax
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	ff 75 e4             	push   -0x1c(%ebp)
  800229:	ff 75 e0             	push   -0x20(%ebp)
  80022c:	ff 75 dc             	push   -0x24(%ebp)
  80022f:	ff 75 d8             	push   -0x28(%ebp)
  800232:	e8 c9 0f 00 00       	call   801200 <__udivdi3>
  800237:	83 c4 18             	add    $0x18,%esp
  80023a:	52                   	push   %edx
  80023b:	50                   	push   %eax
  80023c:	89 f2                	mov    %esi,%edx
  80023e:	89 f8                	mov    %edi,%eax
  800240:	e8 9f ff ff ff       	call   8001e4 <printnum>
  800245:	83 c4 20             	add    $0x20,%esp
  800248:	eb 13                	jmp    80025d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	56                   	push   %esi
  80024e:	ff 75 18             	push   0x18(%ebp)
  800251:	ff d7                	call   *%edi
  800253:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	85 db                	test   %ebx,%ebx
  80025b:	7f ed                	jg     80024a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	56                   	push   %esi
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	ff 75 e4             	push   -0x1c(%ebp)
  800267:	ff 75 e0             	push   -0x20(%ebp)
  80026a:	ff 75 dc             	push   -0x24(%ebp)
  80026d:	ff 75 d8             	push   -0x28(%ebp)
  800270:	e8 ab 10 00 00       	call   801320 <__umoddi3>
  800275:	83 c4 14             	add    $0x14,%esp
  800278:	0f be 80 60 14 80 00 	movsbl 0x801460(%eax),%eax
  80027f:	50                   	push   %eax
  800280:	ff d7                	call   *%edi
}
  800282:	83 c4 10             	add    $0x10,%esp
  800285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800293:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800297:	8b 10                	mov    (%eax),%edx
  800299:	3b 50 04             	cmp    0x4(%eax),%edx
  80029c:	73 0a                	jae    8002a8 <sprintputch+0x1b>
		*b->buf++ = ch;
  80029e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a1:	89 08                	mov    %ecx,(%eax)
  8002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a6:	88 02                	mov    %al,(%edx)
}
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <printfmt>:
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b3:	50                   	push   %eax
  8002b4:	ff 75 10             	push   0x10(%ebp)
  8002b7:	ff 75 0c             	push   0xc(%ebp)
  8002ba:	ff 75 08             	push   0x8(%ebp)
  8002bd:	e8 05 00 00 00       	call   8002c7 <vprintfmt>
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <vprintfmt>:
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	57                   	push   %edi
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	83 ec 3c             	sub    $0x3c,%esp
  8002d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d9:	eb 0a                	jmp    8002e5 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	53                   	push   %ebx
  8002df:	50                   	push   %eax
  8002e0:	ff d6                	call   *%esi
  8002e2:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e5:	83 c7 01             	add    $0x1,%edi
  8002e8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002ec:	83 f8 25             	cmp    $0x25,%eax
  8002ef:	74 0c                	je     8002fd <vprintfmt+0x36>
			if (ch == '\0')
  8002f1:	85 c0                	test   %eax,%eax
  8002f3:	75 e6                	jne    8002db <vprintfmt+0x14>
}
  8002f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f8:	5b                   	pop    %ebx
  8002f9:	5e                   	pop    %esi
  8002fa:	5f                   	pop    %edi
  8002fb:	5d                   	pop    %ebp
  8002fc:	c3                   	ret    
		padc = ' ';
  8002fd:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800301:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800308:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80030f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031b:	8d 47 01             	lea    0x1(%edi),%eax
  80031e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800321:	0f b6 17             	movzbl (%edi),%edx
  800324:	8d 42 dd             	lea    -0x23(%edx),%eax
  800327:	3c 55                	cmp    $0x55,%al
  800329:	0f 87 a6 04 00 00    	ja     8007d5 <vprintfmt+0x50e>
  80032f:	0f b6 c0             	movzbl %al,%eax
  800332:	ff 24 85 a0 15 80 00 	jmp    *0x8015a0(,%eax,4)
  800339:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80033c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800340:	eb d9                	jmp    80031b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800345:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800349:	eb d0                	jmp    80031b <vprintfmt+0x54>
  80034b:	0f b6 d2             	movzbl %dl,%edx
  80034e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800351:	b8 00 00 00 00       	mov    $0x0,%eax
  800356:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800359:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80035c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800360:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800363:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800366:	83 f9 09             	cmp    $0x9,%ecx
  800369:	77 55                	ja     8003c0 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80036b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80036e:	eb e9                	jmp    800359 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 40 04             	lea    0x4(%eax),%eax
  80037e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800384:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800388:	79 91                	jns    80031b <vprintfmt+0x54>
				width = precision, precision = -1;
  80038a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800390:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800397:	eb 82                	jmp    80031b <vprintfmt+0x54>
  800399:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80039c:	85 d2                	test   %edx,%edx
  80039e:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a3:	0f 49 c2             	cmovns %edx,%eax
  8003a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003ac:	e9 6a ff ff ff       	jmp    80031b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8003b4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003bb:	e9 5b ff ff ff       	jmp    80031b <vprintfmt+0x54>
  8003c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	eb bc                	jmp    800384 <vprintfmt+0xbd>
			lflag++;
  8003c8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8003ce:	e9 48 ff ff ff       	jmp    80031b <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8d 78 04             	lea    0x4(%eax),%edi
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	53                   	push   %ebx
  8003dd:	ff 30                	push   (%eax)
  8003df:	ff d6                	call   *%esi
			break;
  8003e1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e7:	e9 88 03 00 00       	jmp    800774 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	8d 78 04             	lea    0x4(%eax),%edi
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	89 d0                	mov    %edx,%eax
  8003f6:	f7 d8                	neg    %eax
  8003f8:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fb:	83 f8 0f             	cmp    $0xf,%eax
  8003fe:	7f 23                	jg     800423 <vprintfmt+0x15c>
  800400:	8b 14 85 00 17 80 00 	mov    0x801700(,%eax,4),%edx
  800407:	85 d2                	test   %edx,%edx
  800409:	74 18                	je     800423 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80040b:	52                   	push   %edx
  80040c:	68 81 14 80 00       	push   $0x801481
  800411:	53                   	push   %ebx
  800412:	56                   	push   %esi
  800413:	e8 92 fe ff ff       	call   8002aa <printfmt>
  800418:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041e:	e9 51 03 00 00       	jmp    800774 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800423:	50                   	push   %eax
  800424:	68 78 14 80 00       	push   $0x801478
  800429:	53                   	push   %ebx
  80042a:	56                   	push   %esi
  80042b:	e8 7a fe ff ff       	call   8002aa <printfmt>
  800430:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800433:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800436:	e9 39 03 00 00       	jmp    800774 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	83 c0 04             	add    $0x4,%eax
  800441:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800449:	85 d2                	test   %edx,%edx
  80044b:	b8 71 14 80 00       	mov    $0x801471,%eax
  800450:	0f 45 c2             	cmovne %edx,%eax
  800453:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800456:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80045a:	7e 06                	jle    800462 <vprintfmt+0x19b>
  80045c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800460:	75 0d                	jne    80046f <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800462:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800465:	89 c7                	mov    %eax,%edi
  800467:	03 45 d4             	add    -0x2c(%ebp),%eax
  80046a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80046d:	eb 55                	jmp    8004c4 <vprintfmt+0x1fd>
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	ff 75 e0             	push   -0x20(%ebp)
  800475:	ff 75 cc             	push   -0x34(%ebp)
  800478:	e8 f5 03 00 00       	call   800872 <strnlen>
  80047d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80048a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	eb 0f                	jmp    8004a2 <vprintfmt+0x1db>
					putch(padc, putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	53                   	push   %ebx
  800497:	ff 75 d4             	push   -0x2c(%ebp)
  80049a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049c:	83 ef 01             	sub    $0x1,%edi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	85 ff                	test   %edi,%edi
  8004a4:	7f ed                	jg     800493 <vprintfmt+0x1cc>
  8004a6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b0:	0f 49 c2             	cmovns %edx,%eax
  8004b3:	29 c2                	sub    %eax,%edx
  8004b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004b8:	eb a8                	jmp    800462 <vprintfmt+0x19b>
					putch(ch, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	53                   	push   %ebx
  8004be:	52                   	push   %edx
  8004bf:	ff d6                	call   *%esi
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004c7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c9:	83 c7 01             	add    $0x1,%edi
  8004cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d0:	0f be d0             	movsbl %al,%edx
  8004d3:	85 d2                	test   %edx,%edx
  8004d5:	74 4b                	je     800522 <vprintfmt+0x25b>
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	78 06                	js     8004e3 <vprintfmt+0x21c>
  8004dd:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004e1:	78 1e                	js     800501 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e7:	74 d1                	je     8004ba <vprintfmt+0x1f3>
  8004e9:	0f be c0             	movsbl %al,%eax
  8004ec:	83 e8 20             	sub    $0x20,%eax
  8004ef:	83 f8 5e             	cmp    $0x5e,%eax
  8004f2:	76 c6                	jbe    8004ba <vprintfmt+0x1f3>
					putch('?', putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	6a 3f                	push   $0x3f
  8004fa:	ff d6                	call   *%esi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	eb c3                	jmp    8004c4 <vprintfmt+0x1fd>
  800501:	89 cf                	mov    %ecx,%edi
  800503:	eb 0e                	jmp    800513 <vprintfmt+0x24c>
				putch(' ', putdat);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	53                   	push   %ebx
  800509:	6a 20                	push   $0x20
  80050b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80050d:	83 ef 01             	sub    $0x1,%edi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	85 ff                	test   %edi,%edi
  800515:	7f ee                	jg     800505 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800517:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051a:	89 45 14             	mov    %eax,0x14(%ebp)
  80051d:	e9 52 02 00 00       	jmp    800774 <vprintfmt+0x4ad>
  800522:	89 cf                	mov    %ecx,%edi
  800524:	eb ed                	jmp    800513 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	83 c0 04             	add    $0x4,%eax
  80052c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800534:	85 d2                	test   %edx,%edx
  800536:	b8 71 14 80 00       	mov    $0x801471,%eax
  80053b:	0f 45 c2             	cmovne %edx,%eax
  80053e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800541:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800545:	7e 06                	jle    80054d <vprintfmt+0x286>
  800547:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80054b:	75 0d                	jne    80055a <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80054d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800550:	89 c7                	mov    %eax,%edi
  800552:	03 45 d4             	add    -0x2c(%ebp),%eax
  800555:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800558:	eb 55                	jmp    8005af <vprintfmt+0x2e8>
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 e0             	push   -0x20(%ebp)
  800560:	ff 75 cc             	push   -0x34(%ebp)
  800563:	e8 0a 03 00 00       	call   800872 <strnlen>
  800568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056b:	29 c2                	sub    %eax,%edx
  80056d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800575:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80057c:	eb 0f                	jmp    80058d <vprintfmt+0x2c6>
					putch(padc, putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	ff 75 d4             	push   -0x2c(%ebp)
  800585:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800587:	83 ef 01             	sub    $0x1,%edi
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	85 ff                	test   %edi,%edi
  80058f:	7f ed                	jg     80057e <vprintfmt+0x2b7>
  800591:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800594:	85 d2                	test   %edx,%edx
  800596:	b8 00 00 00 00       	mov    $0x0,%eax
  80059b:	0f 49 c2             	cmovns %edx,%eax
  80059e:	29 c2                	sub    %eax,%edx
  8005a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a3:	eb a8                	jmp    80054d <vprintfmt+0x286>
					putch(ch, putdat);
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	53                   	push   %ebx
  8005a9:	52                   	push   %edx
  8005aa:	ff d6                	call   *%esi
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005b2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8005b4:	83 c7 01             	add    $0x1,%edi
  8005b7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005bb:	0f be d0             	movsbl %al,%edx
  8005be:	3c 3a                	cmp    $0x3a,%al
  8005c0:	74 4b                	je     80060d <vprintfmt+0x346>
  8005c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c6:	78 06                	js     8005ce <vprintfmt+0x307>
  8005c8:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005cc:	78 1e                	js     8005ec <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d2:	74 d1                	je     8005a5 <vprintfmt+0x2de>
  8005d4:	0f be c0             	movsbl %al,%eax
  8005d7:	83 e8 20             	sub    $0x20,%eax
  8005da:	83 f8 5e             	cmp    $0x5e,%eax
  8005dd:	76 c6                	jbe    8005a5 <vprintfmt+0x2de>
					putch('?', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	6a 3f                	push   $0x3f
  8005e5:	ff d6                	call   *%esi
  8005e7:	83 c4 10             	add    $0x10,%esp
  8005ea:	eb c3                	jmp    8005af <vprintfmt+0x2e8>
  8005ec:	89 cf                	mov    %ecx,%edi
  8005ee:	eb 0e                	jmp    8005fe <vprintfmt+0x337>
				putch(' ', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 20                	push   $0x20
  8005f6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005f8:	83 ef 01             	sub    $0x1,%edi
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	85 ff                	test   %edi,%edi
  800600:	7f ee                	jg     8005f0 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800602:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
  800608:	e9 67 01 00 00       	jmp    800774 <vprintfmt+0x4ad>
  80060d:	89 cf                	mov    %ecx,%edi
  80060f:	eb ed                	jmp    8005fe <vprintfmt+0x337>
	if (lflag >= 2)
  800611:	83 f9 01             	cmp    $0x1,%ecx
  800614:	7f 1b                	jg     800631 <vprintfmt+0x36a>
	else if (lflag)
  800616:	85 c9                	test   %ecx,%ecx
  800618:	74 63                	je     80067d <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800622:	99                   	cltd   
  800623:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	eb 17                	jmp    800648 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 50 04             	mov    0x4(%eax),%edx
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 08             	lea    0x8(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80064b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80064e:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800653:	85 c9                	test   %ecx,%ecx
  800655:	0f 89 ff 00 00 00    	jns    80075a <vprintfmt+0x493>
				putch('-', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 2d                	push   $0x2d
  800661:	ff d6                	call   *%esi
				num = -(long long) num;
  800663:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800666:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800669:	f7 da                	neg    %edx
  80066b:	83 d1 00             	adc    $0x0,%ecx
  80066e:	f7 d9                	neg    %ecx
  800670:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800673:	bf 0a 00 00 00       	mov    $0xa,%edi
  800678:	e9 dd 00 00 00       	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800685:	99                   	cltd   
  800686:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	eb b4                	jmp    800648 <vprintfmt+0x381>
	if (lflag >= 2)
  800694:	83 f9 01             	cmp    $0x1,%ecx
  800697:	7f 1e                	jg     8006b7 <vprintfmt+0x3f0>
	else if (lflag)
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	74 32                	je     8006cf <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ad:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8006b2:	e9 a3 00 00 00       	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 10                	mov    (%eax),%edx
  8006bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bf:	8d 40 08             	lea    0x8(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8006ca:	e9 8b 00 00 00       	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006df:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8006e4:	eb 74                	jmp    80075a <vprintfmt+0x493>
	if (lflag >= 2)
  8006e6:	83 f9 01             	cmp    $0x1,%ecx
  8006e9:	7f 1b                	jg     800706 <vprintfmt+0x43f>
	else if (lflag)
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	74 2c                	je     80071b <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ff:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800704:	eb 54                	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	8b 48 04             	mov    0x4(%eax),%ecx
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800714:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800719:	eb 3f                	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 10                	mov    (%eax),%edx
  800720:	b9 00 00 00 00       	mov    $0x0,%ecx
  800725:	8d 40 04             	lea    0x4(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800730:	eb 28                	jmp    80075a <vprintfmt+0x493>
			putch('0', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	53                   	push   %ebx
  800736:	6a 30                	push   $0x30
  800738:	ff d6                	call   *%esi
			putch('x', putdat);
  80073a:	83 c4 08             	add    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 78                	push   $0x78
  800740:	ff d6                	call   *%esi
			num = (unsigned long long)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 10                	mov    (%eax),%edx
  800747:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80074c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800755:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800761:	50                   	push   %eax
  800762:	ff 75 d4             	push   -0x2c(%ebp)
  800765:	57                   	push   %edi
  800766:	51                   	push   %ecx
  800767:	52                   	push   %edx
  800768:	89 da                	mov    %ebx,%edx
  80076a:	89 f0                	mov    %esi,%eax
  80076c:	e8 73 fa ff ff       	call   8001e4 <printnum>
			break;
  800771:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800774:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800777:	e9 69 fb ff ff       	jmp    8002e5 <vprintfmt+0x1e>
	if (lflag >= 2)
  80077c:	83 f9 01             	cmp    $0x1,%ecx
  80077f:	7f 1b                	jg     80079c <vprintfmt+0x4d5>
	else if (lflag)
  800781:	85 c9                	test   %ecx,%ecx
  800783:	74 2c                	je     8007b1 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 10                	mov    (%eax),%edx
  80078a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  80079a:	eb be                	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 10                	mov    (%eax),%edx
  8007a1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a4:	8d 40 08             	lea    0x8(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007aa:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8007af:	eb a9                	jmp    80075a <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 10                	mov    (%eax),%edx
  8007b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8007c6:	eb 92                	jmp    80075a <vprintfmt+0x493>
			putch(ch, putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	6a 25                	push   $0x25
  8007ce:	ff d6                	call   *%esi
			break;
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 9f                	jmp    800774 <vprintfmt+0x4ad>
			putch('%', putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	6a 25                	push   $0x25
  8007db:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	89 f8                	mov    %edi,%eax
  8007e2:	eb 03                	jmp    8007e7 <vprintfmt+0x520>
  8007e4:	83 e8 01             	sub    $0x1,%eax
  8007e7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007eb:	75 f7                	jne    8007e4 <vprintfmt+0x51d>
  8007ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007f0:	eb 82                	jmp    800774 <vprintfmt+0x4ad>

008007f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 18             	sub    $0x18,%esp
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800801:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800805:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 26                	je     800839 <vsnprintf+0x47>
  800813:	85 d2                	test   %edx,%edx
  800815:	7e 22                	jle    800839 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800817:	ff 75 14             	push   0x14(%ebp)
  80081a:	ff 75 10             	push   0x10(%ebp)
  80081d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	68 8d 02 80 00       	push   $0x80028d
  800826:	e8 9c fa ff ff       	call   8002c7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800834:	83 c4 10             	add    $0x10,%esp
}
  800837:	c9                   	leave  
  800838:	c3                   	ret    
		return -E_INVAL;
  800839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083e:	eb f7                	jmp    800837 <vsnprintf+0x45>

00800840 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800846:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800849:	50                   	push   %eax
  80084a:	ff 75 10             	push   0x10(%ebp)
  80084d:	ff 75 0c             	push   0xc(%ebp)
  800850:	ff 75 08             	push   0x8(%ebp)
  800853:	e8 9a ff ff ff       	call   8007f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800860:	b8 00 00 00 00       	mov    $0x0,%eax
  800865:	eb 03                	jmp    80086a <strlen+0x10>
		n++;
  800867:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80086a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086e:	75 f7                	jne    800867 <strlen+0xd>
	return n;
}
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
  800880:	eb 03                	jmp    800885 <strnlen+0x13>
		n++;
  800882:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800885:	39 d0                	cmp    %edx,%eax
  800887:	74 08                	je     800891 <strnlen+0x1f>
  800889:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80088d:	75 f3                	jne    800882 <strnlen+0x10>
  80088f:	89 c2                	mov    %eax,%edx
	return n;
}
  800891:	89 d0                	mov    %edx,%eax
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	84 d2                	test   %dl,%dl
  8008b0:	75 f2                	jne    8008a4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008b2:	89 c8                	mov    %ecx,%eax
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	53                   	push   %ebx
  8008bd:	83 ec 10             	sub    $0x10,%esp
  8008c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c3:	53                   	push   %ebx
  8008c4:	e8 91 ff ff ff       	call   80085a <strlen>
  8008c9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008cc:	ff 75 0c             	push   0xc(%ebp)
  8008cf:	01 d8                	add    %ebx,%eax
  8008d1:	50                   	push   %eax
  8008d2:	e8 be ff ff ff       	call   800895 <strcpy>
	return dst;
}
  8008d7:	89 d8                	mov    %ebx,%eax
  8008d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    

008008de <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	56                   	push   %esi
  8008e2:	53                   	push   %ebx
  8008e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e9:	89 f3                	mov    %esi,%ebx
  8008eb:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ee:	89 f0                	mov    %esi,%eax
  8008f0:	eb 0f                	jmp    800901 <strncpy+0x23>
		*dst++ = *src;
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	0f b6 0a             	movzbl (%edx),%ecx
  8008f8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008fb:	80 f9 01             	cmp    $0x1,%cl
  8008fe:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800901:	39 d8                	cmp    %ebx,%eax
  800903:	75 ed                	jne    8008f2 <strncpy+0x14>
	}
	return ret;
}
  800905:	89 f0                	mov    %esi,%eax
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	56                   	push   %esi
  80090f:	53                   	push   %ebx
  800910:	8b 75 08             	mov    0x8(%ebp),%esi
  800913:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800916:	8b 55 10             	mov    0x10(%ebp),%edx
  800919:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80091b:	85 d2                	test   %edx,%edx
  80091d:	74 21                	je     800940 <strlcpy+0x35>
  80091f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800923:	89 f2                	mov    %esi,%edx
  800925:	eb 09                	jmp    800930 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
  80092d:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800930:	39 c2                	cmp    %eax,%edx
  800932:	74 09                	je     80093d <strlcpy+0x32>
  800934:	0f b6 19             	movzbl (%ecx),%ebx
  800937:	84 db                	test   %bl,%bl
  800939:	75 ec                	jne    800927 <strlcpy+0x1c>
  80093b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80093d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800940:	29 f0                	sub    %esi,%eax
}
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094f:	eb 06                	jmp    800957 <strcmp+0x11>
		p++, q++;
  800951:	83 c1 01             	add    $0x1,%ecx
  800954:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800957:	0f b6 01             	movzbl (%ecx),%eax
  80095a:	84 c0                	test   %al,%al
  80095c:	74 04                	je     800962 <strcmp+0x1c>
  80095e:	3a 02                	cmp    (%edx),%al
  800960:	74 ef                	je     800951 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800962:	0f b6 c0             	movzbl %al,%eax
  800965:	0f b6 12             	movzbl (%edx),%edx
  800968:	29 d0                	sub    %edx,%eax
}
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	89 c3                	mov    %eax,%ebx
  800978:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80097b:	eb 06                	jmp    800983 <strncmp+0x17>
		n--, p++, q++;
  80097d:	83 c0 01             	add    $0x1,%eax
  800980:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800983:	39 d8                	cmp    %ebx,%eax
  800985:	74 18                	je     80099f <strncmp+0x33>
  800987:	0f b6 08             	movzbl (%eax),%ecx
  80098a:	84 c9                	test   %cl,%cl
  80098c:	74 04                	je     800992 <strncmp+0x26>
  80098e:	3a 0a                	cmp    (%edx),%cl
  800990:	74 eb                	je     80097d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800992:	0f b6 00             	movzbl (%eax),%eax
  800995:	0f b6 12             	movzbl (%edx),%edx
  800998:	29 d0                	sub    %edx,%eax
}
  80099a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    
		return 0;
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a4:	eb f4                	jmp    80099a <strncmp+0x2e>

008009a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	eb 03                	jmp    8009b5 <strchr+0xf>
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	0f b6 10             	movzbl (%eax),%edx
  8009b8:	84 d2                	test   %dl,%dl
  8009ba:	74 06                	je     8009c2 <strchr+0x1c>
		if (*s == c)
  8009bc:	38 ca                	cmp    %cl,%dl
  8009be:	75 f2                	jne    8009b2 <strchr+0xc>
  8009c0:	eb 05                	jmp    8009c7 <strchr+0x21>
			return (char *) s;
	return 0;
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009d6:	38 ca                	cmp    %cl,%dl
  8009d8:	74 09                	je     8009e3 <strfind+0x1a>
  8009da:	84 d2                	test   %dl,%dl
  8009dc:	74 05                	je     8009e3 <strfind+0x1a>
	for (; *s; s++)
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	eb f0                	jmp    8009d3 <strfind+0xa>
			break;
	return (char *) s;
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	57                   	push   %edi
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f1:	85 c9                	test   %ecx,%ecx
  8009f3:	74 2f                	je     800a24 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f5:	89 f8                	mov    %edi,%eax
  8009f7:	09 c8                	or     %ecx,%eax
  8009f9:	a8 03                	test   $0x3,%al
  8009fb:	75 21                	jne    800a1e <memset+0x39>
		c &= 0xFF;
  8009fd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	c1 e0 08             	shl    $0x8,%eax
  800a06:	89 d3                	mov    %edx,%ebx
  800a08:	c1 e3 18             	shl    $0x18,%ebx
  800a0b:	89 d6                	mov    %edx,%esi
  800a0d:	c1 e6 10             	shl    $0x10,%esi
  800a10:	09 f3                	or     %esi,%ebx
  800a12:	09 da                	or     %ebx,%edx
  800a14:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a16:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a19:	fc                   	cld    
  800a1a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a1c:	eb 06                	jmp    800a24 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	fc                   	cld    
  800a22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a24:	89 f8                	mov    %edi,%eax
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5f                   	pop    %edi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a39:	39 c6                	cmp    %eax,%esi
  800a3b:	73 32                	jae    800a6f <memmove+0x44>
  800a3d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	76 2b                	jbe    800a6f <memmove+0x44>
		s += n;
		d += n;
  800a44:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a47:	89 d6                	mov    %edx,%esi
  800a49:	09 fe                	or     %edi,%esi
  800a4b:	09 ce                	or     %ecx,%esi
  800a4d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a53:	75 0e                	jne    800a63 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a55:	83 ef 04             	sub    $0x4,%edi
  800a58:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a5e:	fd                   	std    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 09                	jmp    800a6c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a63:	83 ef 01             	sub    $0x1,%edi
  800a66:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a69:	fd                   	std    
  800a6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6c:	fc                   	cld    
  800a6d:	eb 1a                	jmp    800a89 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6f:	89 f2                	mov    %esi,%edx
  800a71:	09 c2                	or     %eax,%edx
  800a73:	09 ca                	or     %ecx,%edx
  800a75:	f6 c2 03             	test   $0x3,%dl
  800a78:	75 0a                	jne    800a84 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a7d:	89 c7                	mov    %eax,%edi
  800a7f:	fc                   	cld    
  800a80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a82:	eb 05                	jmp    800a89 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a84:	89 c7                	mov    %eax,%edi
  800a86:	fc                   	cld    
  800a87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a89:	5e                   	pop    %esi
  800a8a:	5f                   	pop    %edi
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a93:	ff 75 10             	push   0x10(%ebp)
  800a96:	ff 75 0c             	push   0xc(%ebp)
  800a99:	ff 75 08             	push   0x8(%ebp)
  800a9c:	e8 8a ff ff ff       	call   800a2b <memmove>
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aae:	89 c6                	mov    %eax,%esi
  800ab0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab3:	eb 06                	jmp    800abb <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800abb:	39 f0                	cmp    %esi,%eax
  800abd:	74 14                	je     800ad3 <memcmp+0x30>
		if (*s1 != *s2)
  800abf:	0f b6 08             	movzbl (%eax),%ecx
  800ac2:	0f b6 1a             	movzbl (%edx),%ebx
  800ac5:	38 d9                	cmp    %bl,%cl
  800ac7:	74 ec                	je     800ab5 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800ac9:	0f b6 c1             	movzbl %cl,%eax
  800acc:	0f b6 db             	movzbl %bl,%ebx
  800acf:	29 d8                	sub    %ebx,%eax
  800ad1:	eb 05                	jmp    800ad8 <memcmp+0x35>
	}

	return 0;
  800ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aea:	eb 03                	jmp    800aef <memfind+0x13>
  800aec:	83 c0 01             	add    $0x1,%eax
  800aef:	39 d0                	cmp    %edx,%eax
  800af1:	73 04                	jae    800af7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af3:	38 08                	cmp    %cl,(%eax)
  800af5:	75 f5                	jne    800aec <memfind+0x10>
			break;
	return (void *) s;
}
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b05:	eb 03                	jmp    800b0a <strtol+0x11>
		s++;
  800b07:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b0a:	0f b6 02             	movzbl (%edx),%eax
  800b0d:	3c 20                	cmp    $0x20,%al
  800b0f:	74 f6                	je     800b07 <strtol+0xe>
  800b11:	3c 09                	cmp    $0x9,%al
  800b13:	74 f2                	je     800b07 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b15:	3c 2b                	cmp    $0x2b,%al
  800b17:	74 2a                	je     800b43 <strtol+0x4a>
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b1e:	3c 2d                	cmp    $0x2d,%al
  800b20:	74 2b                	je     800b4d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b28:	75 0f                	jne    800b39 <strtol+0x40>
  800b2a:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2d:	74 28                	je     800b57 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2f:	85 db                	test   %ebx,%ebx
  800b31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b36:	0f 44 d8             	cmove  %eax,%ebx
  800b39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b41:	eb 46                	jmp    800b89 <strtol+0x90>
		s++;
  800b43:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b46:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4b:	eb d5                	jmp    800b22 <strtol+0x29>
		s++, neg = 1;
  800b4d:	83 c2 01             	add    $0x1,%edx
  800b50:	bf 01 00 00 00       	mov    $0x1,%edi
  800b55:	eb cb                	jmp    800b22 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b57:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b5b:	74 0e                	je     800b6b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	75 d8                	jne    800b39 <strtol+0x40>
		s++, base = 8;
  800b61:	83 c2 01             	add    $0x1,%edx
  800b64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b69:	eb ce                	jmp    800b39 <strtol+0x40>
		s += 2, base = 16;
  800b6b:	83 c2 02             	add    $0x2,%edx
  800b6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b73:	eb c4                	jmp    800b39 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b75:	0f be c0             	movsbl %al,%eax
  800b78:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b7e:	7d 3a                	jge    800bba <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b80:	83 c2 01             	add    $0x1,%edx
  800b83:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b87:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b89:	0f b6 02             	movzbl (%edx),%eax
  800b8c:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 09             	cmp    $0x9,%bl
  800b94:	76 df                	jbe    800b75 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b96:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b99:	89 f3                	mov    %esi,%ebx
  800b9b:	80 fb 19             	cmp    $0x19,%bl
  800b9e:	77 08                	ja     800ba8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ba0:	0f be c0             	movsbl %al,%eax
  800ba3:	83 e8 57             	sub    $0x57,%eax
  800ba6:	eb d3                	jmp    800b7b <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800ba8:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bab:	89 f3                	mov    %esi,%ebx
  800bad:	80 fb 19             	cmp    $0x19,%bl
  800bb0:	77 08                	ja     800bba <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bb2:	0f be c0             	movsbl %al,%eax
  800bb5:	83 e8 37             	sub    $0x37,%eax
  800bb8:	eb c1                	jmp    800b7b <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbe:	74 05                	je     800bc5 <strtol+0xcc>
		*endptr = (char *) s;
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800bc5:	89 c8                	mov    %ecx,%eax
  800bc7:	f7 d8                	neg    %eax
  800bc9:	85 ff                	test   %edi,%edi
  800bcb:	0f 45 c8             	cmovne %eax,%ecx
}
  800bce:	89 c8                	mov    %ecx,%eax
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	8b 55 08             	mov    0x8(%ebp),%edx
  800be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be6:	89 c3                	mov    %eax,%ebx
  800be8:	89 c7                	mov    %eax,%edi
  800bea:	89 c6                	mov    %eax,%esi
  800bec:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  800c03:	89 d1                	mov    %edx,%ecx
  800c05:	89 d3                	mov    %edx,%ebx
  800c07:	89 d7                	mov    %edx,%edi
  800c09:	89 d6                	mov    %edx,%esi
  800c0b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	89 cb                	mov    %ecx,%ebx
  800c2a:	89 cf                	mov    %ecx,%edi
  800c2c:	89 ce                	mov    %ecx,%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 03                	push   $0x3
  800c42:	68 5f 17 80 00       	push   $0x80175f
  800c47:	6a 23                	push   $0x23
  800c49:	68 7c 17 80 00       	push   $0x80177c
  800c4e:	e8 c6 04 00 00       	call   801119 <_panic>

00800c53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c63:	89 d1                	mov    %edx,%ecx
  800c65:	89 d3                	mov    %edx,%ebx
  800c67:	89 d7                	mov    %edx,%edi
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <sys_yield>:

void
sys_yield(void)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c82:	89 d1                	mov    %edx,%ecx
  800c84:	89 d3                	mov    %edx,%ebx
  800c86:	89 d7                	mov    %edx,%edi
  800c88:	89 d6                	mov    %edx,%esi
  800c8a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9a:	be 00 00 00 00       	mov    $0x0,%esi
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	b8 04 00 00 00       	mov    $0x4,%eax
  800caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cad:	89 f7                	mov    %esi,%edi
  800caf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7f 08                	jg     800cbd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	83 ec 0c             	sub    $0xc,%esp
  800cc0:	50                   	push   %eax
  800cc1:	6a 04                	push   $0x4
  800cc3:	68 5f 17 80 00       	push   $0x80175f
  800cc8:	6a 23                	push   $0x23
  800cca:	68 7c 17 80 00       	push   $0x80177c
  800ccf:	e8 45 04 00 00       	call   801119 <_panic>

00800cd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ceb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cee:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 05                	push   $0x5
  800d05:	68 5f 17 80 00       	push   $0x80175f
  800d0a:	6a 23                	push   $0x23
  800d0c:	68 7c 17 80 00       	push   $0x80177c
  800d11:	e8 03 04 00 00       	call   801119 <_panic>

00800d16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2f:	89 df                	mov    %ebx,%edi
  800d31:	89 de                	mov    %ebx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 06                	push   $0x6
  800d47:	68 5f 17 80 00       	push   $0x80175f
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 7c 17 80 00       	push   $0x80177c
  800d53:	e8 c1 03 00 00       	call   801119 <_panic>

00800d58 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 08                	push   $0x8
  800d89:	68 5f 17 80 00       	push   $0x80175f
  800d8e:	6a 23                	push   $0x23
  800d90:	68 7c 17 80 00       	push   $0x80177c
  800d95:	e8 7f 03 00 00       	call   801119 <_panic>

00800d9a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 09 00 00 00       	mov    $0x9,%eax
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 09                	push   $0x9
  800dcb:	68 5f 17 80 00       	push   $0x80175f
  800dd0:	6a 23                	push   $0x23
  800dd2:	68 7c 17 80 00       	push   $0x80177c
  800dd7:	e8 3d 03 00 00       	call   801119 <_panic>

00800ddc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 0a                	push   $0xa
  800e0d:	68 5f 17 80 00       	push   $0x80175f
  800e12:	6a 23                	push   $0x23
  800e14:	68 7c 17 80 00       	push   $0x80177c
  800e19:	e8 fb 02 00 00       	call   801119 <_panic>

00800e1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e2f:	be 00 00 00 00       	mov    $0x0,%esi
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e37:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e57:	89 cb                	mov    %ecx,%ebx
  800e59:	89 cf                	mov    %ecx,%edi
  800e5b:	89 ce                	mov    %ecx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 0d                	push   $0xd
  800e71:	68 5f 17 80 00       	push   $0x80175f
  800e76:	6a 23                	push   $0x23
  800e78:	68 7c 17 80 00       	push   $0x80177c
  800e7d:	e8 97 02 00 00       	call   801119 <_panic>

00800e82 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e8c:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800e8e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e92:	0f 84 99 00 00 00    	je     800f31 <pgfault+0xaf>
  800e98:	89 d8                	mov    %ebx,%eax
  800e9a:	c1 e8 16             	shr    $0x16,%eax
  800e9d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ea4:	a8 01                	test   $0x1,%al
  800ea6:	0f 84 85 00 00 00    	je     800f31 <pgfault+0xaf>
  800eac:	89 d8                	mov    %ebx,%eax
  800eae:	c1 e8 0c             	shr    $0xc,%eax
  800eb1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800eb8:	f6 c6 08             	test   $0x8,%dh
  800ebb:	74 74                	je     800f31 <pgfault+0xaf>
  800ebd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ec4:	a8 01                	test   $0x1,%al
  800ec6:	74 69                	je     800f31 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	6a 07                	push   $0x7
  800ecd:	68 00 f0 7f 00       	push   $0x7ff000
  800ed2:	6a 00                	push   $0x0
  800ed4:	e8 b8 fd ff ff       	call   800c91 <sys_page_alloc>
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	85 c0                	test   %eax,%eax
  800ede:	78 65                	js     800f45 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ee0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ee6:	83 ec 04             	sub    $0x4,%esp
  800ee9:	68 00 10 00 00       	push   $0x1000
  800eee:	53                   	push   %ebx
  800eef:	68 00 f0 7f 00       	push   $0x7ff000
  800ef4:	e8 94 fb ff ff       	call   800a8d <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  800ef9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f00:	53                   	push   %ebx
  800f01:	6a 00                	push   $0x0
  800f03:	68 00 f0 7f 00       	push   $0x7ff000
  800f08:	6a 00                	push   $0x0
  800f0a:	e8 c5 fd ff ff       	call   800cd4 <sys_page_map>
  800f0f:	83 c4 20             	add    $0x20,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 43                	js     800f59 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	68 00 f0 7f 00       	push   $0x7ff000
  800f1e:	6a 00                	push   $0x0
  800f20:	e8 f1 fd ff ff       	call   800d16 <sys_page_unmap>
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	78 41                	js     800f6d <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  800f2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    
		panic("invalid permision\n");
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	68 8a 17 80 00       	push   $0x80178a
  800f39:	6a 1f                	push   $0x1f
  800f3b:	68 9d 17 80 00       	push   $0x80179d
  800f40:	e8 d4 01 00 00       	call   801119 <_panic>
		panic("Unable to alloc page\n");
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	68 a8 17 80 00       	push   $0x8017a8
  800f4d:	6a 28                	push   $0x28
  800f4f:	68 9d 17 80 00       	push   $0x80179d
  800f54:	e8 c0 01 00 00       	call   801119 <_panic>
		panic("Unable to map\n");
  800f59:	83 ec 04             	sub    $0x4,%esp
  800f5c:	68 be 17 80 00       	push   $0x8017be
  800f61:	6a 2b                	push   $0x2b
  800f63:	68 9d 17 80 00       	push   $0x80179d
  800f68:	e8 ac 01 00 00       	call   801119 <_panic>
		panic("Unable to unmap\n");
  800f6d:	83 ec 04             	sub    $0x4,%esp
  800f70:	68 cd 17 80 00       	push   $0x8017cd
  800f75:	6a 2d                	push   $0x2d
  800f77:	68 9d 17 80 00       	push   $0x80179d
  800f7c:	e8 98 01 00 00       	call   801119 <_panic>

00800f81 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  800f8a:	68 82 0e 80 00       	push   $0x800e82
  800f8f:	e8 cb 01 00 00       	call   80115f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f94:	b8 07 00 00 00       	mov    $0x7,%eax
  800f99:	cd 30                	int    $0x30
  800f9b:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 23                	js     800fc7 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fa4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  800fa9:	75 6d                	jne    801018 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fab:	e8 a3 fc ff ff       	call   800c53 <sys_getenvid>
  800fb0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fb5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fb8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fbd:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800fc2:	e9 02 01 00 00       	jmp    8010c9 <fork+0x148>
		panic("sys_exofork: %e", envid);
  800fc7:	50                   	push   %eax
  800fc8:	68 de 17 80 00       	push   $0x8017de
  800fcd:	6a 6d                	push   $0x6d
  800fcf:	68 9d 17 80 00       	push   $0x80179d
  800fd4:	e8 40 01 00 00       	call   801119 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  800fd9:	c1 e0 0c             	shl    $0xc,%eax
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fe5:	52                   	push   %edx
  800fe6:	50                   	push   %eax
  800fe7:	56                   	push   %esi
  800fe8:	50                   	push   %eax
  800fe9:	6a 00                	push   $0x0
  800feb:	e8 e4 fc ff ff       	call   800cd4 <sys_page_map>
  800ff0:	83 c4 20             	add    $0x20,%esp
  800ff3:	eb 15                	jmp    80100a <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  800ff5:	c1 e0 0c             	shl    $0xc,%eax
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	6a 05                	push   $0x5
  800ffd:	50                   	push   %eax
  800ffe:	56                   	push   %esi
  800fff:	50                   	push   %eax
  801000:	6a 00                	push   $0x0
  801002:	e8 cd fc ff ff       	call   800cd4 <sys_page_map>
  801007:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80100a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801010:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801016:	74 7a                	je     801092 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  801018:	89 d8                	mov    %ebx,%eax
  80101a:	c1 e8 16             	shr    $0x16,%eax
  80101d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801024:	a8 01                	test   $0x1,%al
  801026:	74 e2                	je     80100a <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801028:	89 d8                	mov    %ebx,%eax
  80102a:	c1 e8 0c             	shr    $0xc,%eax
  80102d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801034:	f6 c2 01             	test   $0x1,%dl
  801037:	74 d1                	je     80100a <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801039:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801040:	f6 c2 04             	test   $0x4,%dl
  801043:	74 c5                	je     80100a <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801045:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80104c:	f6 c6 04             	test   $0x4,%dh
  80104f:	75 88                	jne    800fd9 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801051:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801057:	74 9c                	je     800ff5 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801059:	c1 e0 0c             	shl    $0xc,%eax
  80105c:	89 c7                	mov    %eax,%edi
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	68 05 08 00 00       	push   $0x805
  801066:	50                   	push   %eax
  801067:	56                   	push   %esi
  801068:	50                   	push   %eax
  801069:	6a 00                	push   $0x0
  80106b:	e8 64 fc ff ff       	call   800cd4 <sys_page_map>
  801070:	83 c4 20             	add    $0x20,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 93                	js     80100a <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	68 05 08 00 00       	push   $0x805
  80107f:	57                   	push   %edi
  801080:	6a 00                	push   $0x0
  801082:	57                   	push   %edi
  801083:	6a 00                	push   $0x0
  801085:	e8 4a fc ff ff       	call   800cd4 <sys_page_map>
  80108a:	83 c4 20             	add    $0x20,%esp
  80108d:	e9 78 ff ff ff       	jmp    80100a <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	6a 07                	push   $0x7
  801097:	68 00 f0 bf ee       	push   $0xeebff000
  80109c:	56                   	push   %esi
  80109d:	e8 ef fb ff ff       	call   800c91 <sys_page_alloc>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 2a                	js     8010d3 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	68 ce 11 80 00       	push   $0x8011ce
  8010b1:	56                   	push   %esi
  8010b2:	e8 25 fd ff ff       	call   800ddc <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010b7:	83 c4 08             	add    $0x8,%esp
  8010ba:	6a 02                	push   $0x2
  8010bc:	56                   	push   %esi
  8010bd:	e8 96 fc ff ff       	call   800d58 <sys_env_set_status>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 21                	js     8010ea <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010c9:	89 f0                	mov    %esi,%eax
  8010cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ce:	5b                   	pop    %ebx
  8010cf:	5e                   	pop    %esi
  8010d0:	5f                   	pop    %edi
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    
		panic("failed to alloc page");
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	68 ee 17 80 00       	push   $0x8017ee
  8010db:	68 82 00 00 00       	push   $0x82
  8010e0:	68 9d 17 80 00       	push   $0x80179d
  8010e5:	e8 2f 00 00 00       	call   801119 <_panic>
		panic("sys_env_set_status: %e", r);
  8010ea:	50                   	push   %eax
  8010eb:	68 03 18 80 00       	push   $0x801803
  8010f0:	68 89 00 00 00       	push   $0x89
  8010f5:	68 9d 17 80 00       	push   $0x80179d
  8010fa:	e8 1a 00 00 00       	call   801119 <_panic>

008010ff <sfork>:

// Challenge!
int
sfork(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801105:	68 1a 18 80 00       	push   $0x80181a
  80110a:	68 92 00 00 00       	push   $0x92
  80110f:	68 9d 17 80 00       	push   $0x80179d
  801114:	e8 00 00 00 00       	call   801119 <_panic>

00801119 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80111e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801121:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801127:	e8 27 fb ff ff       	call   800c53 <sys_getenvid>
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	ff 75 0c             	push   0xc(%ebp)
  801132:	ff 75 08             	push   0x8(%ebp)
  801135:	56                   	push   %esi
  801136:	50                   	push   %eax
  801137:	68 30 18 80 00       	push   $0x801830
  80113c:	e8 8f f0 ff ff       	call   8001d0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801141:	83 c4 18             	add    $0x18,%esp
  801144:	53                   	push   %ebx
  801145:	ff 75 10             	push   0x10(%ebp)
  801148:	e8 32 f0 ff ff       	call   80017f <vcprintf>
	cprintf("\n");
  80114d:	c7 04 24 4f 14 80 00 	movl   $0x80144f,(%esp)
  801154:	e8 77 f0 ff ff       	call   8001d0 <cprintf>
  801159:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80115c:	cc                   	int3   
  80115d:	eb fd                	jmp    80115c <_panic+0x43>

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
  801165:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80116c:	74 20                	je     80118e <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	68 ce 11 80 00       	push   $0x8011ce
  80117e:	6a 00                	push   $0x0
  801180:	e8 57 fc ff ff       	call   800ddc <sys_env_set_pgfault_upcall>
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
  80119a:	e8 f2 fa ff ff       	call   800c91 <sys_page_alloc>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	79 c8                	jns    80116e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	68 54 18 80 00       	push   $0x801854
  8011ae:	6a 21                	push   $0x21
  8011b0:	68 b7 18 80 00       	push   $0x8018b7
  8011b5:	e8 5f ff ff ff       	call   801119 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	68 80 18 80 00       	push   $0x801880
  8011c2:	6a 27                	push   $0x27
  8011c4:	68 b7 18 80 00       	push   $0x8018b7
  8011c9:	e8 4b ff ff ff       	call   801119 <_panic>

008011ce <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011ce:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011cf:	a1 08 20 80 00       	mov    0x802008,%eax
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
