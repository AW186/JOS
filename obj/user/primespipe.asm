
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 03 02 00 00       	call   800234 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 c1 15 00 00       	call   801612 <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 49                	jne    8000a2 <primeproc+0x6f>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	push   -0x20(%ebp)
  80005f:	68 c1 23 80 00       	push   $0x8023c1
  800064:	e8 fe 02 00 00       	call   800367 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 2d 1c 00 00       	call   801c9e <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 47                	js     8000c2 <primeproc+0x8f>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 98 10 00 00       	call   801118 <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 50                	js     8000d4 <primeproc+0xa1>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	75 60                	jne    8000e6 <primeproc+0xb3>
		close(fd);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	53                   	push   %ebx
  80008a:	e8 c0 13 00 00       	call   80144f <close>
		close(pfd[1]);
  80008f:	83 c4 04             	add    $0x4,%esp
  800092:	ff 75 dc             	push   -0x24(%ebp)
  800095:	e8 b5 13 00 00       	call   80144f <close>
		fd = pfd[0];
  80009a:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	eb a3                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	85 c0                	test   %eax,%eax
  8000a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ac:	0f 4e d0             	cmovle %eax,%edx
  8000af:	52                   	push   %edx
  8000b0:	50                   	push   %eax
  8000b1:	68 80 23 80 00       	push   $0x802380
  8000b6:	6a 15                	push   $0x15
  8000b8:	68 af 23 80 00       	push   $0x8023af
  8000bd:	e8 ca 01 00 00       	call   80028c <_panic>
		panic("pipe: %e", i);
  8000c2:	50                   	push   %eax
  8000c3:	68 c5 23 80 00       	push   $0x8023c5
  8000c8:	6a 1b                	push   $0x1b
  8000ca:	68 af 23 80 00       	push   $0x8023af
  8000cf:	e8 b8 01 00 00       	call   80028c <_panic>
		panic("fork: %e", id);
  8000d4:	50                   	push   %eax
  8000d5:	68 e5 27 80 00       	push   $0x8027e5
  8000da:	6a 1d                	push   $0x1d
  8000dc:	68 af 23 80 00       	push   $0x8023af
  8000e1:	e8 a6 01 00 00       	call   80028c <_panic>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	push   -0x28(%ebp)
  8000ec:	e8 5e 13 00 00       	call   80144f <close>
	wfd = pfd[1];
  8000f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f4:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f7:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	e8 0c 15 00 00       	call   801612 <readn>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	83 f8 04             	cmp    $0x4,%eax
  80010c:	75 42                	jne    800150 <primeproc+0x11d>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d e0             	idivl  -0x20(%ebp)
  800115:	85 d2                	test   %edx,%edx
  800117:	74 e1                	je     8000fa <primeproc+0xc7>
			if ((r=write(wfd, &i, 4)) != 4)
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	6a 04                	push   $0x4
  80011e:	56                   	push   %esi
  80011f:	57                   	push   %edi
  800120:	e8 34 15 00 00       	call   801659 <write>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	83 f8 04             	cmp    $0x4,%eax
  80012b:	74 cd                	je     8000fa <primeproc+0xc7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	85 c0                	test   %eax,%eax
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	0f 4e d0             	cmovle %eax,%edx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	ff 75 e0             	push   -0x20(%ebp)
  80013f:	68 ea 23 80 00       	push   $0x8023ea
  800144:	6a 2e                	push   $0x2e
  800146:	68 af 23 80 00       	push   $0x8023af
  80014b:	e8 3c 01 00 00       	call   80028c <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	push   -0x20(%ebp)
  800163:	68 ce 23 80 00       	push   $0x8023ce
  800168:	6a 2b                	push   $0x2b
  80016a:	68 af 23 80 00       	push   $0x8023af
  80016f:	e8 18 01 00 00       	call   80028c <_panic>

00800174 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017b:	c7 05 00 30 80 00 04 	movl   $0x802404,0x803000
  800182:	24 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 10 1b 00 00       	call   801c9e <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 7b 0f 00 00       	call   801118 <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	push   -0x10(%ebp)
  8001a9:	e8 a1 12 00 00       	call   80144f <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	push   -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 c5 23 80 00       	push   $0x8023c5
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 af 23 80 00       	push   $0x8023af
  8001c6:	e8 c1 00 00 00       	call   80028c <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 e5 27 80 00       	push   $0x8027e5
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 af 23 80 00       	push   $0x8023af
  8001d8:	e8 af 00 00 00       	call   80028c <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	push   -0x14(%ebp)
  8001e3:	e8 67 12 00 00       	call   80144f <close>
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	b8 02 00 00 00       	mov    $0x2,%eax

	// feed all the integers through
	for (i=2;; i++)
		if ((r=write(p[1], &i, 4)) != 4)
  8001f0:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f3:	eb 06                	jmp    8001fb <umain+0x87>
	for (i=2;; i++)
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	83 c0 01             	add    $0x1,%eax
  8001fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	6a 04                	push   $0x4
  800203:	53                   	push   %ebx
  800204:	ff 75 f0             	push   -0x10(%ebp)
  800207:	e8 4d 14 00 00       	call   801659 <write>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	83 f8 04             	cmp    $0x4,%eax
  800212:	74 e1                	je     8001f5 <umain+0x81>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	85 c0                	test   %eax,%eax
  800219:	ba 00 00 00 00       	mov    $0x0,%edx
  80021e:	0f 4e d0             	cmovle %eax,%edx
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	68 0f 24 80 00       	push   $0x80240f
  800228:	6a 4a                	push   $0x4a
  80022a:	68 af 23 80 00       	push   $0x8023af
  80022f:	e8 58 00 00 00       	call   80028c <_panic>

00800234 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80023c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80023f:	e8 a6 0b 00 00       	call   800dea <sys_getenvid>
  800244:	25 ff 03 00 00       	and    $0x3ff,%eax
  800249:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80024c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800251:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 07                	jle    800261 <libmain+0x2d>
		binaryname = argv[0];
  80025a:	8b 06                	mov    (%esi),%eax
  80025c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	e8 09 ff ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  80026b:	e8 0a 00 00 00       	call   80027a <exit>
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800280:	6a 00                	push   $0x0
  800282:	e8 22 0b 00 00       	call   800da9 <sys_env_destroy>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800291:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800294:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029a:	e8 4b 0b 00 00       	call   800dea <sys_getenvid>
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 0c             	push   0xc(%ebp)
  8002a5:	ff 75 08             	push   0x8(%ebp)
  8002a8:	56                   	push   %esi
  8002a9:	50                   	push   %eax
  8002aa:	68 34 24 80 00       	push   $0x802434
  8002af:	e8 b3 00 00 00       	call   800367 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b4:	83 c4 18             	add    $0x18,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	ff 75 10             	push   0x10(%ebp)
  8002bb:	e8 56 00 00 00       	call   800316 <vcprintf>
	cprintf("\n");
  8002c0:	c7 04 24 97 29 80 00 	movl   $0x802997,(%esp)
  8002c7:	e8 9b 00 00 00       	call   800367 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cf:	cc                   	int3   
  8002d0:	eb fd                	jmp    8002cf <_panic+0x43>

008002d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002dc:	8b 13                	mov    (%ebx),%edx
  8002de:	8d 42 01             	lea    0x1(%edx),%eax
  8002e1:	89 03                	mov    %eax,(%ebx)
  8002e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ef:	74 09                	je     8002fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	68 ff 00 00 00       	push   $0xff
  800302:	8d 43 08             	lea    0x8(%ebx),%eax
  800305:	50                   	push   %eax
  800306:	e8 61 0a 00 00       	call   800d6c <sys_cputs>
		b->idx = 0;
  80030b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	eb db                	jmp    8002f1 <putch+0x1f>

00800316 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	ff 75 0c             	push   0xc(%ebp)
  800336:	ff 75 08             	push   0x8(%ebp)
  800339:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033f:	50                   	push   %eax
  800340:	68 d2 02 80 00       	push   $0x8002d2
  800345:	e8 14 01 00 00       	call   80045e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034a:	83 c4 08             	add    $0x8,%esp
  80034d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800353:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	e8 0d 0a 00 00       	call   800d6c <sys_cputs>

	return b.cnt;
}
  80035f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 08             	push   0x8(%ebp)
  800374:	e8 9d ff ff ff       	call   800316 <vcprintf>
	va_end(ap);

	return cnt;
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 1c             	sub    $0x1c,%esp
  800384:	89 c7                	mov    %eax,%edi
  800386:	89 d6                	mov    %edx,%esi
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 d1                	mov    %edx,%ecx
  800390:	89 c2                	mov    %eax,%edx
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800395:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800398:	8b 45 10             	mov    0x10(%ebp),%eax
  80039b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80039e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003ad:	72 3e                	jb     8003ed <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003af:	83 ec 0c             	sub    $0xc,%esp
  8003b2:	ff 75 18             	push   0x18(%ebp)
  8003b5:	83 eb 01             	sub    $0x1,%ebx
  8003b8:	53                   	push   %ebx
  8003b9:	50                   	push   %eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	ff 75 e4             	push   -0x1c(%ebp)
  8003c0:	ff 75 e0             	push   -0x20(%ebp)
  8003c3:	ff 75 dc             	push   -0x24(%ebp)
  8003c6:	ff 75 d8             	push   -0x28(%ebp)
  8003c9:	e8 72 1d 00 00       	call   802140 <__udivdi3>
  8003ce:	83 c4 18             	add    $0x18,%esp
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	89 f2                	mov    %esi,%edx
  8003d5:	89 f8                	mov    %edi,%eax
  8003d7:	e8 9f ff ff ff       	call   80037b <printnum>
  8003dc:	83 c4 20             	add    $0x20,%esp
  8003df:	eb 13                	jmp    8003f4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	56                   	push   %esi
  8003e5:	ff 75 18             	push   0x18(%ebp)
  8003e8:	ff d7                	call   *%edi
  8003ea:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ed:	83 eb 01             	sub    $0x1,%ebx
  8003f0:	85 db                	test   %ebx,%ebx
  8003f2:	7f ed                	jg     8003e1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	56                   	push   %esi
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 e4             	push   -0x1c(%ebp)
  8003fe:	ff 75 e0             	push   -0x20(%ebp)
  800401:	ff 75 dc             	push   -0x24(%ebp)
  800404:	ff 75 d8             	push   -0x28(%ebp)
  800407:	e8 54 1e 00 00       	call   802260 <__umoddi3>
  80040c:	83 c4 14             	add    $0x14,%esp
  80040f:	0f be 80 57 24 80 00 	movsbl 0x802457(%eax),%eax
  800416:	50                   	push   %eax
  800417:	ff d7                	call   *%edi
}
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041f:	5b                   	pop    %ebx
  800420:	5e                   	pop    %esi
  800421:	5f                   	pop    %edi
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80042a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042e:	8b 10                	mov    (%eax),%edx
  800430:	3b 50 04             	cmp    0x4(%eax),%edx
  800433:	73 0a                	jae    80043f <sprintputch+0x1b>
		*b->buf++ = ch;
  800435:	8d 4a 01             	lea    0x1(%edx),%ecx
  800438:	89 08                	mov    %ecx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	88 02                	mov    %al,(%edx)
}
  80043f:	5d                   	pop    %ebp
  800440:	c3                   	ret    

00800441 <printfmt>:
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800447:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80044a:	50                   	push   %eax
  80044b:	ff 75 10             	push   0x10(%ebp)
  80044e:	ff 75 0c             	push   0xc(%ebp)
  800451:	ff 75 08             	push   0x8(%ebp)
  800454:	e8 05 00 00 00       	call   80045e <vprintfmt>
}
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <vprintfmt>:
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	57                   	push   %edi
  800462:	56                   	push   %esi
  800463:	53                   	push   %ebx
  800464:	83 ec 3c             	sub    $0x3c,%esp
  800467:	8b 75 08             	mov    0x8(%ebp),%esi
  80046a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800470:	eb 0a                	jmp    80047c <vprintfmt+0x1e>
			putch(ch, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	53                   	push   %ebx
  800476:	50                   	push   %eax
  800477:	ff d6                	call   *%esi
  800479:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047c:	83 c7 01             	add    $0x1,%edi
  80047f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800483:	83 f8 25             	cmp    $0x25,%eax
  800486:	74 0c                	je     800494 <vprintfmt+0x36>
			if (ch == '\0')
  800488:	85 c0                	test   %eax,%eax
  80048a:	75 e6                	jne    800472 <vprintfmt+0x14>
}
  80048c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048f:	5b                   	pop    %ebx
  800490:	5e                   	pop    %esi
  800491:	5f                   	pop    %edi
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    
		padc = ' ';
  800494:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800498:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80049f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8004a6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8004ad:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b2:	8d 47 01             	lea    0x1(%edi),%eax
  8004b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b8:	0f b6 17             	movzbl (%edi),%edx
  8004bb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004be:	3c 55                	cmp    $0x55,%al
  8004c0:	0f 87 a6 04 00 00    	ja     80096c <vprintfmt+0x50e>
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	ff 24 85 a0 25 80 00 	jmp    *0x8025a0(,%eax,4)
  8004d0:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8004d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004d7:	eb d9                	jmp    8004b2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004d9:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8004dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004e0:	eb d0                	jmp    8004b2 <vprintfmt+0x54>
  8004e2:	0f b6 d2             	movzbl %dl,%edx
  8004e5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004fa:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004fd:	83 f9 09             	cmp    $0x9,%ecx
  800500:	77 55                	ja     800557 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800502:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800505:	eb e9                	jmp    8004f0 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 40 04             	lea    0x4(%eax),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800518:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80051b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051f:	79 91                	jns    8004b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800521:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800524:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800527:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80052e:	eb 82                	jmp    8004b2 <vprintfmt+0x54>
  800530:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800533:	85 d2                	test   %edx,%edx
  800535:	b8 00 00 00 00       	mov    $0x0,%eax
  80053a:	0f 49 c2             	cmovns %edx,%eax
  80053d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800540:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800543:	e9 6a ff ff ff       	jmp    8004b2 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800548:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80054b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800552:	e9 5b ff ff ff       	jmp    8004b2 <vprintfmt+0x54>
  800557:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055d:	eb bc                	jmp    80051b <vprintfmt+0xbd>
			lflag++;
  80055f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800565:	e9 48 ff ff ff       	jmp    8004b2 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8d 78 04             	lea    0x4(%eax),%edi
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	ff 30                	push   (%eax)
  800576:	ff d6                	call   *%esi
			break;
  800578:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80057b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80057e:	e9 88 03 00 00       	jmp    80090b <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8d 78 04             	lea    0x4(%eax),%edi
  800589:	8b 10                	mov    (%eax),%edx
  80058b:	89 d0                	mov    %edx,%eax
  80058d:	f7 d8                	neg    %eax
  80058f:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800592:	83 f8 0f             	cmp    $0xf,%eax
  800595:	7f 23                	jg     8005ba <vprintfmt+0x15c>
  800597:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  80059e:	85 d2                	test   %edx,%edx
  8005a0:	74 18                	je     8005ba <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8005a2:	52                   	push   %edx
  8005a3:	68 d5 28 80 00       	push   $0x8028d5
  8005a8:	53                   	push   %ebx
  8005a9:	56                   	push   %esi
  8005aa:	e8 92 fe ff ff       	call   800441 <printfmt>
  8005af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b5:	e9 51 03 00 00       	jmp    80090b <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8005ba:	50                   	push   %eax
  8005bb:	68 6f 24 80 00       	push   $0x80246f
  8005c0:	53                   	push   %ebx
  8005c1:	56                   	push   %esi
  8005c2:	e8 7a fe ff ff       	call   800441 <printfmt>
  8005c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ca:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005cd:	e9 39 03 00 00       	jmp    80090b <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 c0 04             	add    $0x4,%eax
  8005d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005e0:	85 d2                	test   %edx,%edx
  8005e2:	b8 68 24 80 00       	mov    $0x802468,%eax
  8005e7:	0f 45 c2             	cmovne %edx,%eax
  8005ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f1:	7e 06                	jle    8005f9 <vprintfmt+0x19b>
  8005f3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005f7:	75 0d                	jne    800606 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005fc:	89 c7                	mov    %eax,%edi
  8005fe:	03 45 d4             	add    -0x2c(%ebp),%eax
  800601:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800604:	eb 55                	jmp    80065b <vprintfmt+0x1fd>
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 e0             	push   -0x20(%ebp)
  80060c:	ff 75 cc             	push   -0x34(%ebp)
  80060f:	e8 f5 03 00 00       	call   800a09 <strnlen>
  800614:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800617:	29 c2                	sub    %eax,%edx
  800619:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800621:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800625:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	eb 0f                	jmp    800639 <vprintfmt+0x1db>
					putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	53                   	push   %ebx
  80062e:	ff 75 d4             	push   -0x2c(%ebp)
  800631:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800633:	83 ef 01             	sub    $0x1,%edi
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	85 ff                	test   %edi,%edi
  80063b:	7f ed                	jg     80062a <vprintfmt+0x1cc>
  80063d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800640:	85 d2                	test   %edx,%edx
  800642:	b8 00 00 00 00       	mov    $0x0,%eax
  800647:	0f 49 c2             	cmovns %edx,%eax
  80064a:	29 c2                	sub    %eax,%edx
  80064c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80064f:	eb a8                	jmp    8005f9 <vprintfmt+0x19b>
					putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	52                   	push   %edx
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80065e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800660:	83 c7 01             	add    $0x1,%edi
  800663:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800667:	0f be d0             	movsbl %al,%edx
  80066a:	85 d2                	test   %edx,%edx
  80066c:	74 4b                	je     8006b9 <vprintfmt+0x25b>
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	78 06                	js     80067a <vprintfmt+0x21c>
  800674:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800678:	78 1e                	js     800698 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80067a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80067e:	74 d1                	je     800651 <vprintfmt+0x1f3>
  800680:	0f be c0             	movsbl %al,%eax
  800683:	83 e8 20             	sub    $0x20,%eax
  800686:	83 f8 5e             	cmp    $0x5e,%eax
  800689:	76 c6                	jbe    800651 <vprintfmt+0x1f3>
					putch('?', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 3f                	push   $0x3f
  800691:	ff d6                	call   *%esi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	eb c3                	jmp    80065b <vprintfmt+0x1fd>
  800698:	89 cf                	mov    %ecx,%edi
  80069a:	eb 0e                	jmp    8006aa <vprintfmt+0x24c>
				putch(' ', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 20                	push   $0x20
  8006a2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a4:	83 ef 01             	sub    $0x1,%edi
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	85 ff                	test   %edi,%edi
  8006ac:	7f ee                	jg     80069c <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	e9 52 02 00 00       	jmp    80090b <vprintfmt+0x4ad>
  8006b9:	89 cf                	mov    %ecx,%edi
  8006bb:	eb ed                	jmp    8006aa <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	83 c0 04             	add    $0x4,%eax
  8006c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006cb:	85 d2                	test   %edx,%edx
  8006cd:	b8 68 24 80 00       	mov    $0x802468,%eax
  8006d2:	0f 45 c2             	cmovne %edx,%eax
  8006d5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006dc:	7e 06                	jle    8006e4 <vprintfmt+0x286>
  8006de:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006e2:	75 0d                	jne    8006f1 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006e7:	89 c7                	mov    %eax,%edi
  8006e9:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006ef:	eb 55                	jmp    800746 <vprintfmt+0x2e8>
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 e0             	push   -0x20(%ebp)
  8006f7:	ff 75 cc             	push   -0x34(%ebp)
  8006fa:	e8 0a 03 00 00       	call   800a09 <strnlen>
  8006ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800702:	29 c2                	sub    %eax,%edx
  800704:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80070c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800710:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800713:	eb 0f                	jmp    800724 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	ff 75 d4             	push   -0x2c(%ebp)
  80071c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80071e:	83 ef 01             	sub    $0x1,%edi
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	85 ff                	test   %edi,%edi
  800726:	7f ed                	jg     800715 <vprintfmt+0x2b7>
  800728:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80072b:	85 d2                	test   %edx,%edx
  80072d:	b8 00 00 00 00       	mov    $0x0,%eax
  800732:	0f 49 c2             	cmovns %edx,%eax
  800735:	29 c2                	sub    %eax,%edx
  800737:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80073a:	eb a8                	jmp    8006e4 <vprintfmt+0x286>
					putch(ch, putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	53                   	push   %ebx
  800740:	52                   	push   %edx
  800741:	ff d6                	call   *%esi
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800749:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80074b:	83 c7 01             	add    $0x1,%edi
  80074e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800752:	0f be d0             	movsbl %al,%edx
  800755:	3c 3a                	cmp    $0x3a,%al
  800757:	74 4b                	je     8007a4 <vprintfmt+0x346>
  800759:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075d:	78 06                	js     800765 <vprintfmt+0x307>
  80075f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800763:	78 1e                	js     800783 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800765:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800769:	74 d1                	je     80073c <vprintfmt+0x2de>
  80076b:	0f be c0             	movsbl %al,%eax
  80076e:	83 e8 20             	sub    $0x20,%eax
  800771:	83 f8 5e             	cmp    $0x5e,%eax
  800774:	76 c6                	jbe    80073c <vprintfmt+0x2de>
					putch('?', putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	53                   	push   %ebx
  80077a:	6a 3f                	push   $0x3f
  80077c:	ff d6                	call   *%esi
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb c3                	jmp    800746 <vprintfmt+0x2e8>
  800783:	89 cf                	mov    %ecx,%edi
  800785:	eb 0e                	jmp    800795 <vprintfmt+0x337>
				putch(' ', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	53                   	push   %ebx
  80078b:	6a 20                	push   $0x20
  80078d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80078f:	83 ef 01             	sub    $0x1,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	85 ff                	test   %edi,%edi
  800797:	7f ee                	jg     800787 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800799:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
  80079f:	e9 67 01 00 00       	jmp    80090b <vprintfmt+0x4ad>
  8007a4:	89 cf                	mov    %ecx,%edi
  8007a6:	eb ed                	jmp    800795 <vprintfmt+0x337>
	if (lflag >= 2)
  8007a8:	83 f9 01             	cmp    $0x1,%ecx
  8007ab:	7f 1b                	jg     8007c8 <vprintfmt+0x36a>
	else if (lflag)
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	74 63                	je     800814 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b9:	99                   	cltd   
  8007ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c6:	eb 17                	jmp    8007df <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8007e5:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007ea:	85 c9                	test   %ecx,%ecx
  8007ec:	0f 89 ff 00 00 00    	jns    8008f1 <vprintfmt+0x493>
				putch('-', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 2d                	push   $0x2d
  8007f8:	ff d6                	call   *%esi
				num = -(long long) num;
  8007fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800800:	f7 da                	neg    %edx
  800802:	83 d1 00             	adc    $0x0,%ecx
  800805:	f7 d9                	neg    %ecx
  800807:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80080a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80080f:	e9 dd 00 00 00       	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80081c:	99                   	cltd   
  80081d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8d 40 04             	lea    0x4(%eax),%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
  800829:	eb b4                	jmp    8007df <vprintfmt+0x381>
	if (lflag >= 2)
  80082b:	83 f9 01             	cmp    $0x1,%ecx
  80082e:	7f 1e                	jg     80084e <vprintfmt+0x3f0>
	else if (lflag)
  800830:	85 c9                	test   %ecx,%ecx
  800832:	74 32                	je     800866 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 10                	mov    (%eax),%edx
  800839:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800844:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800849:	e9 a3 00 00 00       	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 10                	mov    (%eax),%edx
  800853:	8b 48 04             	mov    0x4(%eax),%ecx
  800856:	8d 40 08             	lea    0x8(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800861:	e9 8b 00 00 00       	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 10                	mov    (%eax),%edx
  80086b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800870:	8d 40 04             	lea    0x4(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800876:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80087b:	eb 74                	jmp    8008f1 <vprintfmt+0x493>
	if (lflag >= 2)
  80087d:	83 f9 01             	cmp    $0x1,%ecx
  800880:	7f 1b                	jg     80089d <vprintfmt+0x43f>
	else if (lflag)
  800882:	85 c9                	test   %ecx,%ecx
  800884:	74 2c                	je     8008b2 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8b 10                	mov    (%eax),%edx
  80088b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800896:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80089b:	eb 54                	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8b 10                	mov    (%eax),%edx
  8008a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008a5:	8d 40 08             	lea    0x8(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ab:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8008b0:	eb 3f                	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 10                	mov    (%eax),%edx
  8008b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c2:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8008c7:	eb 28                	jmp    8008f1 <vprintfmt+0x493>
			putch('0', putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	53                   	push   %ebx
  8008cd:	6a 30                	push   $0x30
  8008cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8008d1:	83 c4 08             	add    $0x8,%esp
  8008d4:	53                   	push   %ebx
  8008d5:	6a 78                	push   $0x78
  8008d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 10                	mov    (%eax),%edx
  8008de:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008e3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008e6:	8d 40 04             	lea    0x4(%eax),%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ec:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8008f1:	83 ec 0c             	sub    $0xc,%esp
  8008f4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	ff 75 d4             	push   -0x2c(%ebp)
  8008fc:	57                   	push   %edi
  8008fd:	51                   	push   %ecx
  8008fe:	52                   	push   %edx
  8008ff:	89 da                	mov    %ebx,%edx
  800901:	89 f0                	mov    %esi,%eax
  800903:	e8 73 fa ff ff       	call   80037b <printnum>
			break;
  800908:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80090b:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090e:	e9 69 fb ff ff       	jmp    80047c <vprintfmt+0x1e>
	if (lflag >= 2)
  800913:	83 f9 01             	cmp    $0x1,%ecx
  800916:	7f 1b                	jg     800933 <vprintfmt+0x4d5>
	else if (lflag)
  800918:	85 c9                	test   %ecx,%ecx
  80091a:	74 2c                	je     800948 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8b 10                	mov    (%eax),%edx
  800921:	b9 00 00 00 00       	mov    $0x0,%ecx
  800926:	8d 40 04             	lea    0x4(%eax),%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092c:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800931:	eb be                	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 10                	mov    (%eax),%edx
  800938:	8b 48 04             	mov    0x4(%eax),%ecx
  80093b:	8d 40 08             	lea    0x8(%eax),%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800941:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800946:	eb a9                	jmp    8008f1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 10                	mov    (%eax),%edx
  80094d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800958:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  80095d:	eb 92                	jmp    8008f1 <vprintfmt+0x493>
			putch(ch, putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	6a 25                	push   $0x25
  800965:	ff d6                	call   *%esi
			break;
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	eb 9f                	jmp    80090b <vprintfmt+0x4ad>
			putch('%', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	6a 25                	push   $0x25
  800972:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	89 f8                	mov    %edi,%eax
  800979:	eb 03                	jmp    80097e <vprintfmt+0x520>
  80097b:	83 e8 01             	sub    $0x1,%eax
  80097e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800982:	75 f7                	jne    80097b <vprintfmt+0x51d>
  800984:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800987:	eb 82                	jmp    80090b <vprintfmt+0x4ad>

00800989 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 18             	sub    $0x18,%esp
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800995:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800998:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a6:	85 c0                	test   %eax,%eax
  8009a8:	74 26                	je     8009d0 <vsnprintf+0x47>
  8009aa:	85 d2                	test   %edx,%edx
  8009ac:	7e 22                	jle    8009d0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ae:	ff 75 14             	push   0x14(%ebp)
  8009b1:	ff 75 10             	push   0x10(%ebp)
  8009b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	68 24 04 80 00       	push   $0x800424
  8009bd:	e8 9c fa ff ff       	call   80045e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cb:	83 c4 10             	add    $0x10,%esp
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    
		return -E_INVAL;
  8009d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d5:	eb f7                	jmp    8009ce <vsnprintf+0x45>

008009d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	50                   	push   %eax
  8009e1:	ff 75 10             	push   0x10(%ebp)
  8009e4:	ff 75 0c             	push   0xc(%ebp)
  8009e7:	ff 75 08             	push   0x8(%ebp)
  8009ea:	e8 9a ff ff ff       	call   800989 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fc:	eb 03                	jmp    800a01 <strlen+0x10>
		n++;
  8009fe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a01:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a05:	75 f7                	jne    8009fe <strlen+0xd>
	return n;
}
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb 03                	jmp    800a1c <strnlen+0x13>
		n++;
  800a19:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	74 08                	je     800a28 <strnlen+0x1f>
  800a20:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a24:	75 f3                	jne    800a19 <strnlen+0x10>
  800a26:	89 c2                	mov    %eax,%edx
	return n;
}
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a3f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	84 d2                	test   %dl,%dl
  800a47:	75 f2                	jne    800a3b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a49:	89 c8                	mov    %ecx,%eax
  800a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	83 ec 10             	sub    $0x10,%esp
  800a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5a:	53                   	push   %ebx
  800a5b:	e8 91 ff ff ff       	call   8009f1 <strlen>
  800a60:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a63:	ff 75 0c             	push   0xc(%ebp)
  800a66:	01 d8                	add    %ebx,%eax
  800a68:	50                   	push   %eax
  800a69:	e8 be ff ff ff       	call   800a2c <strcpy>
	return dst;
}
  800a6e:	89 d8                	mov    %ebx,%eax
  800a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 f3                	mov    %esi,%ebx
  800a82:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a85:	89 f0                	mov    %esi,%eax
  800a87:	eb 0f                	jmp    800a98 <strncpy+0x23>
		*dst++ = *src;
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	0f b6 0a             	movzbl (%edx),%ecx
  800a8f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a92:	80 f9 01             	cmp    $0x1,%cl
  800a95:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800a98:	39 d8                	cmp    %ebx,%eax
  800a9a:	75 ed                	jne    800a89 <strncpy+0x14>
	}
	return ret;
}
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	5b                   	pop    %ebx
  800a9f:	5e                   	pop    %esi
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    

00800aa2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aad:	8b 55 10             	mov    0x10(%ebp),%edx
  800ab0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab2:	85 d2                	test   %edx,%edx
  800ab4:	74 21                	je     800ad7 <strlcpy+0x35>
  800ab6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aba:	89 f2                	mov    %esi,%edx
  800abc:	eb 09                	jmp    800ac7 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	83 c2 01             	add    $0x1,%edx
  800ac4:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800ac7:	39 c2                	cmp    %eax,%edx
  800ac9:	74 09                	je     800ad4 <strlcpy+0x32>
  800acb:	0f b6 19             	movzbl (%ecx),%ebx
  800ace:	84 db                	test   %bl,%bl
  800ad0:	75 ec                	jne    800abe <strlcpy+0x1c>
  800ad2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ad4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad7:	29 f0                	sub    %esi,%eax
}
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae6:	eb 06                	jmp    800aee <strcmp+0x11>
		p++, q++;
  800ae8:	83 c1 01             	add    $0x1,%ecx
  800aeb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800aee:	0f b6 01             	movzbl (%ecx),%eax
  800af1:	84 c0                	test   %al,%al
  800af3:	74 04                	je     800af9 <strcmp+0x1c>
  800af5:	3a 02                	cmp    (%edx),%al
  800af7:	74 ef                	je     800ae8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af9:	0f b6 c0             	movzbl %al,%eax
  800afc:	0f b6 12             	movzbl (%edx),%edx
  800aff:	29 d0                	sub    %edx,%eax
}
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0d:	89 c3                	mov    %eax,%ebx
  800b0f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b12:	eb 06                	jmp    800b1a <strncmp+0x17>
		n--, p++, q++;
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b1a:	39 d8                	cmp    %ebx,%eax
  800b1c:	74 18                	je     800b36 <strncmp+0x33>
  800b1e:	0f b6 08             	movzbl (%eax),%ecx
  800b21:	84 c9                	test   %cl,%cl
  800b23:	74 04                	je     800b29 <strncmp+0x26>
  800b25:	3a 0a                	cmp    (%edx),%cl
  800b27:	74 eb                	je     800b14 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b29:	0f b6 00             	movzbl (%eax),%eax
  800b2c:	0f b6 12             	movzbl (%edx),%edx
  800b2f:	29 d0                	sub    %edx,%eax
}
  800b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    
		return 0;
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	eb f4                	jmp    800b31 <strncmp+0x2e>

00800b3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b47:	eb 03                	jmp    800b4c <strchr+0xf>
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	0f b6 10             	movzbl (%eax),%edx
  800b4f:	84 d2                	test   %dl,%dl
  800b51:	74 06                	je     800b59 <strchr+0x1c>
		if (*s == c)
  800b53:	38 ca                	cmp    %cl,%dl
  800b55:	75 f2                	jne    800b49 <strchr+0xc>
  800b57:	eb 05                	jmp    800b5e <strchr+0x21>
			return (char *) s;
	return 0;
  800b59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b6d:	38 ca                	cmp    %cl,%dl
  800b6f:	74 09                	je     800b7a <strfind+0x1a>
  800b71:	84 d2                	test   %dl,%dl
  800b73:	74 05                	je     800b7a <strfind+0x1a>
	for (; *s; s++)
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	eb f0                	jmp    800b6a <strfind+0xa>
			break;
	return (char *) s;
}
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b88:	85 c9                	test   %ecx,%ecx
  800b8a:	74 2f                	je     800bbb <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8c:	89 f8                	mov    %edi,%eax
  800b8e:	09 c8                	or     %ecx,%eax
  800b90:	a8 03                	test   $0x3,%al
  800b92:	75 21                	jne    800bb5 <memset+0x39>
		c &= 0xFF;
  800b94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b98:	89 d0                	mov    %edx,%eax
  800b9a:	c1 e0 08             	shl    $0x8,%eax
  800b9d:	89 d3                	mov    %edx,%ebx
  800b9f:	c1 e3 18             	shl    $0x18,%ebx
  800ba2:	89 d6                	mov    %edx,%esi
  800ba4:	c1 e6 10             	shl    $0x10,%esi
  800ba7:	09 f3                	or     %esi,%ebx
  800ba9:	09 da                	or     %ebx,%edx
  800bab:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb0:	fc                   	cld    
  800bb1:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb3:	eb 06                	jmp    800bbb <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	fc                   	cld    
  800bb9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbb:	89 f8                	mov    %edi,%eax
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5f                   	pop    %edi
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	57                   	push   %edi
  800bc6:	56                   	push   %esi
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd0:	39 c6                	cmp    %eax,%esi
  800bd2:	73 32                	jae    800c06 <memmove+0x44>
  800bd4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	76 2b                	jbe    800c06 <memmove+0x44>
		s += n;
		d += n;
  800bdb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	09 fe                	or     %edi,%esi
  800be2:	09 ce                	or     %ecx,%esi
  800be4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bea:	75 0e                	jne    800bfa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bec:	83 ef 04             	sub    $0x4,%edi
  800bef:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf5:	fd                   	std    
  800bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf8:	eb 09                	jmp    800c03 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bfa:	83 ef 01             	sub    $0x1,%edi
  800bfd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c00:	fd                   	std    
  800c01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c03:	fc                   	cld    
  800c04:	eb 1a                	jmp    800c20 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c06:	89 f2                	mov    %esi,%edx
  800c08:	09 c2                	or     %eax,%edx
  800c0a:	09 ca                	or     %ecx,%edx
  800c0c:	f6 c2 03             	test   $0x3,%dl
  800c0f:	75 0a                	jne    800c1b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c14:	89 c7                	mov    %eax,%edi
  800c16:	fc                   	cld    
  800c17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c19:	eb 05                	jmp    800c20 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c1b:	89 c7                	mov    %eax,%edi
  800c1d:	fc                   	cld    
  800c1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c2a:	ff 75 10             	push   0x10(%ebp)
  800c2d:	ff 75 0c             	push   0xc(%ebp)
  800c30:	ff 75 08             	push   0x8(%ebp)
  800c33:	e8 8a ff ff ff       	call   800bc2 <memmove>
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	89 c6                	mov    %eax,%esi
  800c47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4a:	eb 06                	jmp    800c52 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4c:	83 c0 01             	add    $0x1,%eax
  800c4f:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800c52:	39 f0                	cmp    %esi,%eax
  800c54:	74 14                	je     800c6a <memcmp+0x30>
		if (*s1 != *s2)
  800c56:	0f b6 08             	movzbl (%eax),%ecx
  800c59:	0f b6 1a             	movzbl (%edx),%ebx
  800c5c:	38 d9                	cmp    %bl,%cl
  800c5e:	74 ec                	je     800c4c <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800c60:	0f b6 c1             	movzbl %cl,%eax
  800c63:	0f b6 db             	movzbl %bl,%ebx
  800c66:	29 d8                	sub    %ebx,%eax
  800c68:	eb 05                	jmp    800c6f <memcmp+0x35>
	}

	return 0;
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c7c:	89 c2                	mov    %eax,%edx
  800c7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c81:	eb 03                	jmp    800c86 <memfind+0x13>
  800c83:	83 c0 01             	add    $0x1,%eax
  800c86:	39 d0                	cmp    %edx,%eax
  800c88:	73 04                	jae    800c8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8a:	38 08                	cmp    %cl,(%eax)
  800c8c:	75 f5                	jne    800c83 <memfind+0x10>
			break;
	return (void *) s;
}
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9c:	eb 03                	jmp    800ca1 <strtol+0x11>
		s++;
  800c9e:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800ca1:	0f b6 02             	movzbl (%edx),%eax
  800ca4:	3c 20                	cmp    $0x20,%al
  800ca6:	74 f6                	je     800c9e <strtol+0xe>
  800ca8:	3c 09                	cmp    $0x9,%al
  800caa:	74 f2                	je     800c9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cac:	3c 2b                	cmp    $0x2b,%al
  800cae:	74 2a                	je     800cda <strtol+0x4a>
	int neg = 0;
  800cb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb5:	3c 2d                	cmp    $0x2d,%al
  800cb7:	74 2b                	je     800ce4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cbf:	75 0f                	jne    800cd0 <strtol+0x40>
  800cc1:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc4:	74 28                	je     800cee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc6:	85 db                	test   %ebx,%ebx
  800cc8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ccd:	0f 44 d8             	cmove  %eax,%ebx
  800cd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd8:	eb 46                	jmp    800d20 <strtol+0x90>
		s++;
  800cda:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800cdd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce2:	eb d5                	jmp    800cb9 <strtol+0x29>
		s++, neg = 1;
  800ce4:	83 c2 01             	add    $0x1,%edx
  800ce7:	bf 01 00 00 00       	mov    $0x1,%edi
  800cec:	eb cb                	jmp    800cb9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cee:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cf2:	74 0e                	je     800d02 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cf4:	85 db                	test   %ebx,%ebx
  800cf6:	75 d8                	jne    800cd0 <strtol+0x40>
		s++, base = 8;
  800cf8:	83 c2 01             	add    $0x1,%edx
  800cfb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d00:	eb ce                	jmp    800cd0 <strtol+0x40>
		s += 2, base = 16;
  800d02:	83 c2 02             	add    $0x2,%edx
  800d05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d0a:	eb c4                	jmp    800cd0 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d0c:	0f be c0             	movsbl %al,%eax
  800d0f:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d15:	7d 3a                	jge    800d51 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d17:	83 c2 01             	add    $0x1,%edx
  800d1a:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800d1e:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800d20:	0f b6 02             	movzbl (%edx),%eax
  800d23:	8d 70 d0             	lea    -0x30(%eax),%esi
  800d26:	89 f3                	mov    %esi,%ebx
  800d28:	80 fb 09             	cmp    $0x9,%bl
  800d2b:	76 df                	jbe    800d0c <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800d2d:	8d 70 9f             	lea    -0x61(%eax),%esi
  800d30:	89 f3                	mov    %esi,%ebx
  800d32:	80 fb 19             	cmp    $0x19,%bl
  800d35:	77 08                	ja     800d3f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d37:	0f be c0             	movsbl %al,%eax
  800d3a:	83 e8 57             	sub    $0x57,%eax
  800d3d:	eb d3                	jmp    800d12 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800d3f:	8d 70 bf             	lea    -0x41(%eax),%esi
  800d42:	89 f3                	mov    %esi,%ebx
  800d44:	80 fb 19             	cmp    $0x19,%bl
  800d47:	77 08                	ja     800d51 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d49:	0f be c0             	movsbl %al,%eax
  800d4c:	83 e8 37             	sub    $0x37,%eax
  800d4f:	eb c1                	jmp    800d12 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d55:	74 05                	je     800d5c <strtol+0xcc>
		*endptr = (char *) s;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d5c:	89 c8                	mov    %ecx,%eax
  800d5e:	f7 d8                	neg    %eax
  800d60:	85 ff                	test   %edi,%edi
  800d62:	0f 45 c8             	cmovne %eax,%ecx
}
  800d65:	89 c8                	mov    %ecx,%eax
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	57                   	push   %edi
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	89 c3                	mov    %eax,%ebx
  800d7f:	89 c7                	mov    %eax,%edi
  800d81:	89 c6                	mov    %eax,%esi
  800d83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d90:	ba 00 00 00 00       	mov    $0x0,%edx
  800d95:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9a:	89 d1                	mov    %edx,%ecx
  800d9c:	89 d3                	mov    %edx,%ebx
  800d9e:	89 d7                	mov    %edx,%edi
  800da0:	89 d6                	mov    %edx,%esi
  800da2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 03                	push   $0x3
  800dd9:	68 5f 27 80 00       	push   $0x80275f
  800dde:	6a 23                	push   $0x23
  800de0:	68 7c 27 80 00       	push   $0x80277c
  800de5:	e8 a2 f4 ff ff       	call   80028c <_panic>

00800dea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df0:	ba 00 00 00 00       	mov    $0x0,%edx
  800df5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dfa:	89 d1                	mov    %edx,%ecx
  800dfc:	89 d3                	mov    %edx,%ebx
  800dfe:	89 d7                	mov    %edx,%edi
  800e00:	89 d6                	mov    %edx,%esi
  800e02:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_yield>:

void
sys_yield(void)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e14:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e19:	89 d1                	mov    %edx,%ecx
  800e1b:	89 d3                	mov    %edx,%ebx
  800e1d:	89 d7                	mov    %edx,%edi
  800e1f:	89 d6                	mov    %edx,%esi
  800e21:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	be 00 00 00 00       	mov    $0x0,%esi
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	89 f7                	mov    %esi,%edi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 04                	push   $0x4
  800e5a:	68 5f 27 80 00       	push   $0x80275f
  800e5f:	6a 23                	push   $0x23
  800e61:	68 7c 27 80 00       	push   $0x80277c
  800e66:	e8 21 f4 ff ff       	call   80028c <_panic>

00800e6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e82:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e85:	8b 75 18             	mov    0x18(%ebp),%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 05                	push   $0x5
  800e9c:	68 5f 27 80 00       	push   $0x80275f
  800ea1:	6a 23                	push   $0x23
  800ea3:	68 7c 27 80 00       	push   $0x80277c
  800ea8:	e8 df f3 ff ff       	call   80028c <_panic>

00800ead <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 06                	push   $0x6
  800ede:	68 5f 27 80 00       	push   $0x80275f
  800ee3:	6a 23                	push   $0x23
  800ee5:	68 7c 27 80 00       	push   $0x80277c
  800eea:	e8 9d f3 ff ff       	call   80028c <_panic>

00800eef <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	b8 08 00 00 00       	mov    $0x8,%eax
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	89 de                	mov    %ebx,%esi
  800f0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	7f 08                	jg     800f1a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	50                   	push   %eax
  800f1e:	6a 08                	push   $0x8
  800f20:	68 5f 27 80 00       	push   $0x80275f
  800f25:	6a 23                	push   $0x23
  800f27:	68 7c 27 80 00       	push   $0x80277c
  800f2c:	e8 5b f3 ff ff       	call   80028c <_panic>

00800f31 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
  800f37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 09 00 00 00       	mov    $0x9,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7f 08                	jg     800f5c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	50                   	push   %eax
  800f60:	6a 09                	push   $0x9
  800f62:	68 5f 27 80 00       	push   $0x80275f
  800f67:	6a 23                	push   $0x23
  800f69:	68 7c 27 80 00       	push   $0x80277c
  800f6e:	e8 19 f3 ff ff       	call   80028c <_panic>

00800f73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7f 08                	jg     800f9e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	50                   	push   %eax
  800fa2:	6a 0a                	push   $0xa
  800fa4:	68 5f 27 80 00       	push   $0x80275f
  800fa9:	6a 23                	push   $0x23
  800fab:	68 7c 27 80 00       	push   $0x80277c
  800fb0:	e8 d7 f2 ff ff       	call   80028c <_panic>

00800fb5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc6:	be 00 00 00 00       	mov    $0x0,%esi
  800fcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fee:	89 cb                	mov    %ecx,%ebx
  800ff0:	89 cf                	mov    %ecx,%edi
  800ff2:	89 ce                	mov    %ecx,%esi
  800ff4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	7f 08                	jg     801002 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	50                   	push   %eax
  801006:	6a 0d                	push   $0xd
  801008:	68 5f 27 80 00       	push   $0x80275f
  80100d:	6a 23                	push   $0x23
  80100f:	68 7c 27 80 00       	push   $0x80277c
  801014:	e8 73 f2 ff ff       	call   80028c <_panic>

00801019 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	53                   	push   %ebx
  80101d:	83 ec 04             	sub    $0x4,%esp
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801023:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  801025:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801029:	0f 84 99 00 00 00    	je     8010c8 <pgfault+0xaf>
  80102f:	89 d8                	mov    %ebx,%eax
  801031:	c1 e8 16             	shr    $0x16,%eax
  801034:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80103b:	a8 01                	test   $0x1,%al
  80103d:	0f 84 85 00 00 00    	je     8010c8 <pgfault+0xaf>
  801043:	89 d8                	mov    %ebx,%eax
  801045:	c1 e8 0c             	shr    $0xc,%eax
  801048:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80104f:	f6 c6 08             	test   $0x8,%dh
  801052:	74 74                	je     8010c8 <pgfault+0xaf>
  801054:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80105b:	a8 01                	test   $0x1,%al
  80105d:	74 69                	je     8010c8 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	6a 07                	push   $0x7
  801064:	68 00 f0 7f 00       	push   $0x7ff000
  801069:	6a 00                	push   $0x0
  80106b:	e8 b8 fd ff ff       	call   800e28 <sys_page_alloc>
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 65                	js     8010dc <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801077:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	68 00 10 00 00       	push   $0x1000
  801085:	53                   	push   %ebx
  801086:	68 00 f0 7f 00       	push   $0x7ff000
  80108b:	e8 94 fb ff ff       	call   800c24 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  801090:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801097:	53                   	push   %ebx
  801098:	6a 00                	push   $0x0
  80109a:	68 00 f0 7f 00       	push   $0x7ff000
  80109f:	6a 00                	push   $0x0
  8010a1:	e8 c5 fd ff ff       	call   800e6b <sys_page_map>
  8010a6:	83 c4 20             	add    $0x20,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 43                	js     8010f0 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	68 00 f0 7f 00       	push   $0x7ff000
  8010b5:	6a 00                	push   $0x0
  8010b7:	e8 f1 fd ff ff       	call   800ead <sys_page_unmap>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	78 41                	js     801104 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  8010c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    
		panic("invalid permision\n");
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	68 8a 27 80 00       	push   $0x80278a
  8010d0:	6a 1f                	push   $0x1f
  8010d2:	68 9d 27 80 00       	push   $0x80279d
  8010d7:	e8 b0 f1 ff ff       	call   80028c <_panic>
		panic("Unable to alloc page\n");
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	68 a8 27 80 00       	push   $0x8027a8
  8010e4:	6a 28                	push   $0x28
  8010e6:	68 9d 27 80 00       	push   $0x80279d
  8010eb:	e8 9c f1 ff ff       	call   80028c <_panic>
		panic("Unable to map\n");
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 be 27 80 00       	push   $0x8027be
  8010f8:	6a 2b                	push   $0x2b
  8010fa:	68 9d 27 80 00       	push   $0x80279d
  8010ff:	e8 88 f1 ff ff       	call   80028c <_panic>
		panic("Unable to unmap\n");
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	68 cd 27 80 00       	push   $0x8027cd
  80110c:	6a 2d                	push   $0x2d
  80110e:	68 9d 27 80 00       	push   $0x80279d
  801113:	e8 74 f1 ff ff       	call   80028c <_panic>

00801118 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	57                   	push   %edi
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
  80111e:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  801121:	68 19 10 80 00       	push   $0x801019
  801126:	e8 64 0e 00 00       	call   801f8f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80112b:	b8 07 00 00 00       	mov    $0x7,%eax
  801130:	cd 30                	int    $0x30
  801132:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	85 c0                	test   %eax,%eax
  801139:	78 23                	js     80115e <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80113b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  801140:	75 6d                	jne    8011af <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  801142:	e8 a3 fc ff ff       	call   800dea <sys_getenvid>
  801147:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80114f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801154:	a3 00 40 80 00       	mov    %eax,0x804000
		return 0;
  801159:	e9 02 01 00 00       	jmp    801260 <fork+0x148>
		panic("sys_exofork: %e", envid);
  80115e:	50                   	push   %eax
  80115f:	68 de 27 80 00       	push   $0x8027de
  801164:	6a 6d                	push   $0x6d
  801166:	68 9d 27 80 00       	push   $0x80279d
  80116b:	e8 1c f1 ff ff       	call   80028c <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801170:	c1 e0 0c             	shl    $0xc,%eax
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80117c:	52                   	push   %edx
  80117d:	50                   	push   %eax
  80117e:	56                   	push   %esi
  80117f:	50                   	push   %eax
  801180:	6a 00                	push   $0x0
  801182:	e8 e4 fc ff ff       	call   800e6b <sys_page_map>
  801187:	83 c4 20             	add    $0x20,%esp
  80118a:	eb 15                	jmp    8011a1 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  80118c:	c1 e0 0c             	shl    $0xc,%eax
  80118f:	83 ec 0c             	sub    $0xc,%esp
  801192:	6a 05                	push   $0x5
  801194:	50                   	push   %eax
  801195:	56                   	push   %esi
  801196:	50                   	push   %eax
  801197:	6a 00                	push   $0x0
  801199:	e8 cd fc ff ff       	call   800e6b <sys_page_map>
  80119e:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8011a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011a7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011ad:	74 7a                	je     801229 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  8011af:	89 d8                	mov    %ebx,%eax
  8011b1:	c1 e8 16             	shr    $0x16,%eax
  8011b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  8011bb:	a8 01                	test   $0x1,%al
  8011bd:	74 e2                	je     8011a1 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  8011bf:	89 d8                	mov    %ebx,%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
  8011c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  8011cb:	f6 c2 01             	test   $0x1,%dl
  8011ce:	74 d1                	je     8011a1 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  8011d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  8011d7:	f6 c2 04             	test   $0x4,%dl
  8011da:	74 c5                	je     8011a1 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  8011dc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011e3:	f6 c6 04             	test   $0x4,%dh
  8011e6:	75 88                	jne    801170 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  8011e8:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8011ee:	74 9c                	je     80118c <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  8011f0:	c1 e0 0c             	shl    $0xc,%eax
  8011f3:	89 c7                	mov    %eax,%edi
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	68 05 08 00 00       	push   $0x805
  8011fd:	50                   	push   %eax
  8011fe:	56                   	push   %esi
  8011ff:	50                   	push   %eax
  801200:	6a 00                	push   $0x0
  801202:	e8 64 fc ff ff       	call   800e6b <sys_page_map>
  801207:	83 c4 20             	add    $0x20,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 93                	js     8011a1 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	68 05 08 00 00       	push   $0x805
  801216:	57                   	push   %edi
  801217:	6a 00                	push   $0x0
  801219:	57                   	push   %edi
  80121a:	6a 00                	push   $0x0
  80121c:	e8 4a fc ff ff       	call   800e6b <sys_page_map>
  801221:	83 c4 20             	add    $0x20,%esp
  801224:	e9 78 ff ff ff       	jmp    8011a1 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801229:	83 ec 04             	sub    $0x4,%esp
  80122c:	6a 07                	push   $0x7
  80122e:	68 00 f0 bf ee       	push   $0xeebff000
  801233:	56                   	push   %esi
  801234:	e8 ef fb ff ff       	call   800e28 <sys_page_alloc>
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	78 2a                	js     80126a <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801240:	83 ec 08             	sub    $0x8,%esp
  801243:	68 fe 1f 80 00       	push   $0x801ffe
  801248:	56                   	push   %esi
  801249:	e8 25 fd ff ff       	call   800f73 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80124e:	83 c4 08             	add    $0x8,%esp
  801251:	6a 02                	push   $0x2
  801253:	56                   	push   %esi
  801254:	e8 96 fc ff ff       	call   800eef <sys_env_set_status>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 21                	js     801281 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801260:	89 f0                	mov    %esi,%eax
  801262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    
		panic("failed to alloc page");
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	68 ee 27 80 00       	push   $0x8027ee
  801272:	68 82 00 00 00       	push   $0x82
  801277:	68 9d 27 80 00       	push   $0x80279d
  80127c:	e8 0b f0 ff ff       	call   80028c <_panic>
		panic("sys_env_set_status: %e", r);
  801281:	50                   	push   %eax
  801282:	68 03 28 80 00       	push   $0x802803
  801287:	68 89 00 00 00       	push   $0x89
  80128c:	68 9d 27 80 00       	push   $0x80279d
  801291:	e8 f6 ef ff ff       	call   80028c <_panic>

00801296 <sfork>:

// Challenge!
int
sfork(void)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80129c:	68 1a 28 80 00       	push   $0x80281a
  8012a1:	68 92 00 00 00       	push   $0x92
  8012a6:	68 9d 27 80 00       	push   $0x80279d
  8012ab:	e8 dc ef ff ff       	call   80028c <_panic>

008012b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012df:	89 c2                	mov    %eax,%edx
  8012e1:	c1 ea 16             	shr    $0x16,%edx
  8012e4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012eb:	f6 c2 01             	test   $0x1,%dl
  8012ee:	74 29                	je     801319 <fd_alloc+0x42>
  8012f0:	89 c2                	mov    %eax,%edx
  8012f2:	c1 ea 0c             	shr    $0xc,%edx
  8012f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012fc:	f6 c2 01             	test   $0x1,%dl
  8012ff:	74 18                	je     801319 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801301:	05 00 10 00 00       	add    $0x1000,%eax
  801306:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80130b:	75 d2                	jne    8012df <fd_alloc+0x8>
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  801312:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801317:	eb 05                	jmp    80131e <fd_alloc+0x47>
			return 0;
  801319:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  80131e:	8b 55 08             	mov    0x8(%ebp),%edx
  801321:	89 02                	mov    %eax,(%edx)
}
  801323:	89 c8                	mov    %ecx,%eax
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80132d:	83 f8 1f             	cmp    $0x1f,%eax
  801330:	77 30                	ja     801362 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801332:	c1 e0 0c             	shl    $0xc,%eax
  801335:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80133a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801340:	f6 c2 01             	test   $0x1,%dl
  801343:	74 24                	je     801369 <fd_lookup+0x42>
  801345:	89 c2                	mov    %eax,%edx
  801347:	c1 ea 0c             	shr    $0xc,%edx
  80134a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801351:	f6 c2 01             	test   $0x1,%dl
  801354:	74 1a                	je     801370 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801356:	8b 55 0c             	mov    0xc(%ebp),%edx
  801359:	89 02                	mov    %eax,(%edx)
	return 0;
  80135b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
		return -E_INVAL;
  801362:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801367:	eb f7                	jmp    801360 <fd_lookup+0x39>
		return -E_INVAL;
  801369:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136e:	eb f0                	jmp    801360 <fd_lookup+0x39>
  801370:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801375:	eb e9                	jmp    801360 <fd_lookup+0x39>

00801377 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	53                   	push   %ebx
  80137b:	83 ec 04             	sub    $0x4,%esp
  80137e:	8b 55 08             	mov    0x8(%ebp),%edx
  801381:	b8 ac 28 80 00       	mov    $0x8028ac,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801386:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  80138b:	39 13                	cmp    %edx,(%ebx)
  80138d:	74 32                	je     8013c1 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80138f:	83 c0 04             	add    $0x4,%eax
  801392:	8b 18                	mov    (%eax),%ebx
  801394:	85 db                	test   %ebx,%ebx
  801396:	75 f3                	jne    80138b <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801398:	a1 00 40 80 00       	mov    0x804000,%eax
  80139d:	8b 40 48             	mov    0x48(%eax),%eax
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	52                   	push   %edx
  8013a4:	50                   	push   %eax
  8013a5:	68 30 28 80 00       	push   $0x802830
  8013aa:	e8 b8 ef ff ff       	call   800367 <cprintf>
	*dev = 0;
	return -E_INVAL;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  8013b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ba:	89 1a                	mov    %ebx,(%edx)
}
  8013bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    
			return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c6:	eb ef                	jmp    8013b7 <dev_lookup+0x40>

008013c8 <fd_close>:
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	57                   	push   %edi
  8013cc:	56                   	push   %esi
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 24             	sub    $0x24,%esp
  8013d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e4:	50                   	push   %eax
  8013e5:	e8 3d ff ff ff       	call   801327 <fd_lookup>
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 05                	js     8013f8 <fd_close+0x30>
	    || fd != fd2)
  8013f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013f6:	74 16                	je     80140e <fd_close+0x46>
		return (must_exist ? r : 0);
  8013f8:	89 f8                	mov    %edi,%eax
  8013fa:	84 c0                	test   %al,%al
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801401:	0f 44 d8             	cmove  %eax,%ebx
}
  801404:	89 d8                	mov    %ebx,%eax
  801406:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801409:	5b                   	pop    %ebx
  80140a:	5e                   	pop    %esi
  80140b:	5f                   	pop    %edi
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801414:	50                   	push   %eax
  801415:	ff 36                	push   (%esi)
  801417:	e8 5b ff ff ff       	call   801377 <dev_lookup>
  80141c:	89 c3                	mov    %eax,%ebx
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 1a                	js     80143f <fd_close+0x77>
		if (dev->dev_close)
  801425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801428:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80142b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801430:	85 c0                	test   %eax,%eax
  801432:	74 0b                	je     80143f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	56                   	push   %esi
  801438:	ff d0                	call   *%eax
  80143a:	89 c3                	mov    %eax,%ebx
  80143c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	56                   	push   %esi
  801443:	6a 00                	push   $0x0
  801445:	e8 63 fa ff ff       	call   800ead <sys_page_unmap>
	return r;
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	eb b5                	jmp    801404 <fd_close+0x3c>

0080144f <close>:

int
close(int fdnum)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	ff 75 08             	push   0x8(%ebp)
  80145c:	e8 c6 fe ff ff       	call   801327 <fd_lookup>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	79 02                	jns    80146a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    
		return fd_close(fd, 1);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	6a 01                	push   $0x1
  80146f:	ff 75 f4             	push   -0xc(%ebp)
  801472:	e8 51 ff ff ff       	call   8013c8 <fd_close>
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	eb ec                	jmp    801468 <close+0x19>

0080147c <close_all>:

void
close_all(void)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	53                   	push   %ebx
  801480:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801483:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	53                   	push   %ebx
  80148c:	e8 be ff ff ff       	call   80144f <close>
	for (i = 0; i < MAXFD; i++)
  801491:	83 c3 01             	add    $0x1,%ebx
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	83 fb 20             	cmp    $0x20,%ebx
  80149a:	75 ec                	jne    801488 <close_all+0xc>
}
  80149c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	57                   	push   %edi
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	ff 75 08             	push   0x8(%ebp)
  8014b1:	e8 71 fe ff ff       	call   801327 <fd_lookup>
  8014b6:	89 c3                	mov    %eax,%ebx
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 7f                	js     80153e <dup+0x9d>
		return r;
	close(newfdnum);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	ff 75 0c             	push   0xc(%ebp)
  8014c5:	e8 85 ff ff ff       	call   80144f <close>

	newfd = INDEX2FD(newfdnum);
  8014ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014cd:	c1 e6 0c             	shl    $0xc,%esi
  8014d0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014d9:	89 3c 24             	mov    %edi,(%esp)
  8014dc:	e8 df fd ff ff       	call   8012c0 <fd2data>
  8014e1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014e3:	89 34 24             	mov    %esi,(%esp)
  8014e6:	e8 d5 fd ff ff       	call   8012c0 <fd2data>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014f1:	89 d8                	mov    %ebx,%eax
  8014f3:	c1 e8 16             	shr    $0x16,%eax
  8014f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fd:	a8 01                	test   $0x1,%al
  8014ff:	74 11                	je     801512 <dup+0x71>
  801501:	89 d8                	mov    %ebx,%eax
  801503:	c1 e8 0c             	shr    $0xc,%eax
  801506:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80150d:	f6 c2 01             	test   $0x1,%dl
  801510:	75 36                	jne    801548 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801512:	89 f8                	mov    %edi,%eax
  801514:	c1 e8 0c             	shr    $0xc,%eax
  801517:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	25 07 0e 00 00       	and    $0xe07,%eax
  801526:	50                   	push   %eax
  801527:	56                   	push   %esi
  801528:	6a 00                	push   $0x0
  80152a:	57                   	push   %edi
  80152b:	6a 00                	push   $0x0
  80152d:	e8 39 f9 ff ff       	call   800e6b <sys_page_map>
  801532:	89 c3                	mov    %eax,%ebx
  801534:	83 c4 20             	add    $0x20,%esp
  801537:	85 c0                	test   %eax,%eax
  801539:	78 33                	js     80156e <dup+0xcd>
		goto err;

	return newfdnum;
  80153b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80153e:	89 d8                	mov    %ebx,%eax
  801540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5f                   	pop    %edi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801548:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	25 07 0e 00 00       	and    $0xe07,%eax
  801557:	50                   	push   %eax
  801558:	ff 75 d4             	push   -0x2c(%ebp)
  80155b:	6a 00                	push   $0x0
  80155d:	53                   	push   %ebx
  80155e:	6a 00                	push   $0x0
  801560:	e8 06 f9 ff ff       	call   800e6b <sys_page_map>
  801565:	89 c3                	mov    %eax,%ebx
  801567:	83 c4 20             	add    $0x20,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	79 a4                	jns    801512 <dup+0x71>
	sys_page_unmap(0, newfd);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	56                   	push   %esi
  801572:	6a 00                	push   $0x0
  801574:	e8 34 f9 ff ff       	call   800ead <sys_page_unmap>
	sys_page_unmap(0, nva);
  801579:	83 c4 08             	add    $0x8,%esp
  80157c:	ff 75 d4             	push   -0x2c(%ebp)
  80157f:	6a 00                	push   $0x0
  801581:	e8 27 f9 ff ff       	call   800ead <sys_page_unmap>
	return r;
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	eb b3                	jmp    80153e <dup+0x9d>

0080158b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
  801590:	83 ec 18             	sub    $0x18,%esp
  801593:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801596:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	56                   	push   %esi
  80159b:	e8 87 fd ff ff       	call   801327 <fd_lookup>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 3c                	js     8015e3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	ff 33                	push   (%ebx)
  8015b3:	e8 bf fd ff ff       	call   801377 <dev_lookup>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 24                	js     8015e3 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015bf:	8b 43 08             	mov    0x8(%ebx),%eax
  8015c2:	83 e0 03             	and    $0x3,%eax
  8015c5:	83 f8 01             	cmp    $0x1,%eax
  8015c8:	74 20                	je     8015ea <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cd:	8b 40 08             	mov    0x8(%eax),%eax
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	74 37                	je     80160b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	ff 75 10             	push   0x10(%ebp)
  8015da:	ff 75 0c             	push   0xc(%ebp)
  8015dd:	53                   	push   %ebx
  8015de:	ff d0                	call   *%eax
  8015e0:	83 c4 10             	add    $0x10,%esp
}
  8015e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ea:	a1 00 40 80 00       	mov    0x804000,%eax
  8015ef:	8b 40 48             	mov    0x48(%eax),%eax
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	56                   	push   %esi
  8015f6:	50                   	push   %eax
  8015f7:	68 71 28 80 00       	push   $0x802871
  8015fc:	e8 66 ed ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801609:	eb d8                	jmp    8015e3 <read+0x58>
		return -E_NOT_SUPP;
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801610:	eb d1                	jmp    8015e3 <read+0x58>

00801612 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801621:	bb 00 00 00 00       	mov    $0x0,%ebx
  801626:	eb 02                	jmp    80162a <readn+0x18>
  801628:	01 c3                	add    %eax,%ebx
  80162a:	39 f3                	cmp    %esi,%ebx
  80162c:	73 21                	jae    80164f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	89 f0                	mov    %esi,%eax
  801633:	29 d8                	sub    %ebx,%eax
  801635:	50                   	push   %eax
  801636:	89 d8                	mov    %ebx,%eax
  801638:	03 45 0c             	add    0xc(%ebp),%eax
  80163b:	50                   	push   %eax
  80163c:	57                   	push   %edi
  80163d:	e8 49 ff ff ff       	call   80158b <read>
		if (m < 0)
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 04                	js     80164d <readn+0x3b>
			return m;
		if (m == 0)
  801649:	75 dd                	jne    801628 <readn+0x16>
  80164b:	eb 02                	jmp    80164f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 18             	sub    $0x18,%esp
  801661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	53                   	push   %ebx
  801669:	e8 b9 fc ff ff       	call   801327 <fd_lookup>
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	78 37                	js     8016ac <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801675:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	ff 36                	push   (%esi)
  801681:	e8 f1 fc ff ff       	call   801377 <dev_lookup>
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 1f                	js     8016ac <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168d:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801691:	74 20                	je     8016b3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	8b 40 0c             	mov    0xc(%eax),%eax
  801699:	85 c0                	test   %eax,%eax
  80169b:	74 37                	je     8016d4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	ff 75 10             	push   0x10(%ebp)
  8016a3:	ff 75 0c             	push   0xc(%ebp)
  8016a6:	56                   	push   %esi
  8016a7:	ff d0                	call   *%eax
  8016a9:	83 c4 10             	add    $0x10,%esp
}
  8016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5e                   	pop    %esi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b3:	a1 00 40 80 00       	mov    0x804000,%eax
  8016b8:	8b 40 48             	mov    0x48(%eax),%eax
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	53                   	push   %ebx
  8016bf:	50                   	push   %eax
  8016c0:	68 8d 28 80 00       	push   $0x80288d
  8016c5:	e8 9d ec ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d2:	eb d8                	jmp    8016ac <write+0x53>
		return -E_NOT_SUPP;
  8016d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d9:	eb d1                	jmp    8016ac <write+0x53>

008016db <seek>:

int
seek(int fdnum, off_t offset)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	ff 75 08             	push   0x8(%ebp)
  8016e8:	e8 3a fc ff ff       	call   801327 <fd_lookup>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 0e                	js     801702 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	56                   	push   %esi
  801708:	53                   	push   %ebx
  801709:	83 ec 18             	sub    $0x18,%esp
  80170c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801712:	50                   	push   %eax
  801713:	53                   	push   %ebx
  801714:	e8 0e fc ff ff       	call   801327 <fd_lookup>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 34                	js     801754 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801720:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801729:	50                   	push   %eax
  80172a:	ff 36                	push   (%esi)
  80172c:	e8 46 fc ff ff       	call   801377 <dev_lookup>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	78 1c                	js     801754 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801738:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80173c:	74 1d                	je     80175b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	8b 40 18             	mov    0x18(%eax),%eax
  801744:	85 c0                	test   %eax,%eax
  801746:	74 34                	je     80177c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	ff 75 0c             	push   0xc(%ebp)
  80174e:	56                   	push   %esi
  80174f:	ff d0                	call   *%eax
  801751:	83 c4 10             	add    $0x10,%esp
}
  801754:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801757:	5b                   	pop    %ebx
  801758:	5e                   	pop    %esi
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80175b:	a1 00 40 80 00       	mov    0x804000,%eax
  801760:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	53                   	push   %ebx
  801767:	50                   	push   %eax
  801768:	68 50 28 80 00       	push   $0x802850
  80176d:	e8 f5 eb ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177a:	eb d8                	jmp    801754 <ftruncate+0x50>
		return -E_NOT_SUPP;
  80177c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801781:	eb d1                	jmp    801754 <ftruncate+0x50>

00801783 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 18             	sub    $0x18,%esp
  80178b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	ff 75 08             	push   0x8(%ebp)
  801795:	e8 8d fb ff ff       	call   801327 <fd_lookup>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 49                	js     8017ea <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a1:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017aa:	50                   	push   %eax
  8017ab:	ff 36                	push   (%esi)
  8017ad:	e8 c5 fb ff ff       	call   801377 <dev_lookup>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 31                	js     8017ea <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017c0:	74 2f                	je     8017f1 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017cc:	00 00 00 
	stat->st_isdir = 0;
  8017cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d6:	00 00 00 
	stat->st_dev = dev;
  8017d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	53                   	push   %ebx
  8017e3:	56                   	push   %esi
  8017e4:	ff 50 14             	call   *0x14(%eax)
  8017e7:	83 c4 10             	add    $0x10,%esp
}
  8017ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8017f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f6:	eb f2                	jmp    8017ea <fstat+0x67>

008017f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	6a 00                	push   $0x0
  801802:	ff 75 08             	push   0x8(%ebp)
  801805:	e8 22 02 00 00       	call   801a2c <open>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 1b                	js     80182e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	ff 75 0c             	push   0xc(%ebp)
  801819:	50                   	push   %eax
  80181a:	e8 64 ff ff ff       	call   801783 <fstat>
  80181f:	89 c6                	mov    %eax,%esi
	close(fd);
  801821:	89 1c 24             	mov    %ebx,(%esp)
  801824:	e8 26 fc ff ff       	call   80144f <close>
	return r;
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	89 f3                	mov    %esi,%ebx
}
  80182e:	89 d8                	mov    %ebx,%eax
  801830:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	89 c6                	mov    %eax,%esi
  80183e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801840:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801847:	74 27                	je     801870 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801849:	6a 07                	push   $0x7
  80184b:	68 00 50 80 00       	push   $0x805000
  801850:	56                   	push   %esi
  801851:	ff 35 00 60 80 00    	push   0x806000
  801857:	e8 15 08 00 00       	call   802071 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80185c:	83 c4 0c             	add    $0xc,%esp
  80185f:	6a 00                	push   $0x0
  801861:	53                   	push   %ebx
  801862:	6a 00                	push   $0x0
  801864:	e8 b9 07 00 00       	call   802022 <ipc_recv>
}
  801869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	6a 01                	push   $0x1
  801875:	e8 43 08 00 00       	call   8020bd <ipc_find_env>
  80187a:	a3 00 60 80 00       	mov    %eax,0x806000
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	eb c5                	jmp    801849 <fsipc+0x12>

00801884 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8b 40 0c             	mov    0xc(%eax),%eax
  801890:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801895:	8b 45 0c             	mov    0xc(%ebp),%eax
  801898:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8018a7:	e8 8b ff ff ff       	call   801837 <fsipc>
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <devfile_flush>:
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ba:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c4:	b8 06 00 00 00       	mov    $0x6,%eax
  8018c9:	e8 69 ff ff ff       	call   801837 <fsipc>
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <devfile_stat>:
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8018ef:	e8 43 ff ff ff       	call   801837 <fsipc>
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 2c                	js     801924 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	68 00 50 80 00       	push   $0x805000
  801900:	53                   	push   %ebx
  801901:	e8 26 f1 ff ff       	call   800a2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801906:	a1 80 50 80 00       	mov    0x805080,%eax
  80190b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801911:	a1 84 50 80 00       	mov    0x805084,%eax
  801916:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <devfile_write>:
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	53                   	push   %ebx
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	8b 40 0c             	mov    0xc(%eax),%eax
  801939:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80193e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801944:	53                   	push   %ebx
  801945:	ff 75 0c             	push   0xc(%ebp)
  801948:	68 08 50 80 00       	push   $0x805008
  80194d:	e8 d2 f2 ff ff       	call   800c24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	b8 04 00 00 00       	mov    $0x4,%eax
  80195c:	e8 d6 fe ff ff       	call   801837 <fsipc>
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 0b                	js     801973 <devfile_write+0x4a>
	assert(r <= n);
  801968:	39 d8                	cmp    %ebx,%eax
  80196a:	77 0c                	ja     801978 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80196c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801971:	7f 1e                	jg     801991 <devfile_write+0x68>
}
  801973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801976:	c9                   	leave  
  801977:	c3                   	ret    
	assert(r <= n);
  801978:	68 bc 28 80 00       	push   $0x8028bc
  80197d:	68 c3 28 80 00       	push   $0x8028c3
  801982:	68 97 00 00 00       	push   $0x97
  801987:	68 d8 28 80 00       	push   $0x8028d8
  80198c:	e8 fb e8 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801991:	68 e3 28 80 00       	push   $0x8028e3
  801996:	68 c3 28 80 00       	push   $0x8028c3
  80199b:	68 98 00 00 00       	push   $0x98
  8019a0:	68 d8 28 80 00       	push   $0x8028d8
  8019a5:	e8 e2 e8 ff ff       	call   80028c <_panic>

008019aa <devfile_read>:
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019bd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	b8 03 00 00 00       	mov    $0x3,%eax
  8019cd:	e8 65 fe ff ff       	call   801837 <fsipc>
  8019d2:	89 c3                	mov    %eax,%ebx
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 1f                	js     8019f7 <devfile_read+0x4d>
	assert(r <= n);
  8019d8:	39 f0                	cmp    %esi,%eax
  8019da:	77 24                	ja     801a00 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019dc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019e1:	7f 33                	jg     801a16 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	50                   	push   %eax
  8019e7:	68 00 50 80 00       	push   $0x805000
  8019ec:	ff 75 0c             	push   0xc(%ebp)
  8019ef:	e8 ce f1 ff ff       	call   800bc2 <memmove>
	return r;
  8019f4:	83 c4 10             	add    $0x10,%esp
}
  8019f7:	89 d8                	mov    %ebx,%eax
  8019f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fc:	5b                   	pop    %ebx
  8019fd:	5e                   	pop    %esi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
	assert(r <= n);
  801a00:	68 bc 28 80 00       	push   $0x8028bc
  801a05:	68 c3 28 80 00       	push   $0x8028c3
  801a0a:	6a 7c                	push   $0x7c
  801a0c:	68 d8 28 80 00       	push   $0x8028d8
  801a11:	e8 76 e8 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801a16:	68 e3 28 80 00       	push   $0x8028e3
  801a1b:	68 c3 28 80 00       	push   $0x8028c3
  801a20:	6a 7d                	push   $0x7d
  801a22:	68 d8 28 80 00       	push   $0x8028d8
  801a27:	e8 60 e8 ff ff       	call   80028c <_panic>

00801a2c <open>:
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
  801a31:	83 ec 1c             	sub    $0x1c,%esp
  801a34:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a37:	56                   	push   %esi
  801a38:	e8 b4 ef ff ff       	call   8009f1 <strlen>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a45:	7f 6c                	jg     801ab3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4d:	50                   	push   %eax
  801a4e:	e8 84 f8 ff ff       	call   8012d7 <fd_alloc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	78 3c                	js     801a98 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	56                   	push   %esi
  801a60:	68 00 50 80 00       	push   $0x805000
  801a65:	e8 c2 ef ff ff       	call   800a2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a75:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7a:	e8 b8 fd ff ff       	call   801837 <fsipc>
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 19                	js     801aa1 <open+0x75>
	return fd2num(fd);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 f4             	push   -0xc(%ebp)
  801a8e:	e8 1d f8 ff ff       	call   8012b0 <fd2num>
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
		fd_close(fd, 0);
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 f4             	push   -0xc(%ebp)
  801aa9:	e8 1a f9 ff ff       	call   8013c8 <fd_close>
		return r;
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	eb e5                	jmp    801a98 <open+0x6c>
		return -E_BAD_PATH;
  801ab3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ab8:	eb de                	jmp    801a98 <open+0x6c>

00801aba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac5:	b8 08 00 00 00       	mov    $0x8,%eax
  801aca:	e8 68 fd ff ff       	call   801837 <fsipc>
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	56                   	push   %esi
  801ad5:	53                   	push   %ebx
  801ad6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	ff 75 08             	push   0x8(%ebp)
  801adf:	e8 dc f7 ff ff       	call   8012c0 <fd2data>
  801ae4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ae6:	83 c4 08             	add    $0x8,%esp
  801ae9:	68 ef 28 80 00       	push   $0x8028ef
  801aee:	53                   	push   %ebx
  801aef:	e8 38 ef ff ff       	call   800a2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801af4:	8b 46 04             	mov    0x4(%esi),%eax
  801af7:	2b 06                	sub    (%esi),%eax
  801af9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b06:	00 00 00 
	stat->st_dev = &devpipe;
  801b09:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b10:	30 80 00 
	return 0;
}
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
  801b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 0c             	sub    $0xc,%esp
  801b26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b29:	53                   	push   %ebx
  801b2a:	6a 00                	push   $0x0
  801b2c:	e8 7c f3 ff ff       	call   800ead <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b31:	89 1c 24             	mov    %ebx,(%esp)
  801b34:	e8 87 f7 ff ff       	call   8012c0 <fd2data>
  801b39:	83 c4 08             	add    $0x8,%esp
  801b3c:	50                   	push   %eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 69 f3 ff ff       	call   800ead <sys_page_unmap>
}
  801b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <_pipeisclosed>:
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	57                   	push   %edi
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	83 ec 1c             	sub    $0x1c,%esp
  801b52:	89 c7                	mov    %eax,%edi
  801b54:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b56:	a1 00 40 80 00       	mov    0x804000,%eax
  801b5b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b5e:	83 ec 0c             	sub    $0xc,%esp
  801b61:	57                   	push   %edi
  801b62:	e8 8f 05 00 00       	call   8020f6 <pageref>
  801b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b6a:	89 34 24             	mov    %esi,(%esp)
  801b6d:	e8 84 05 00 00       	call   8020f6 <pageref>
		nn = thisenv->env_runs;
  801b72:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801b78:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	39 cb                	cmp    %ecx,%ebx
  801b80:	74 1b                	je     801b9d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b82:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b85:	75 cf                	jne    801b56 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b87:	8b 42 58             	mov    0x58(%edx),%eax
  801b8a:	6a 01                	push   $0x1
  801b8c:	50                   	push   %eax
  801b8d:	53                   	push   %ebx
  801b8e:	68 f6 28 80 00       	push   $0x8028f6
  801b93:	e8 cf e7 ff ff       	call   800367 <cprintf>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	eb b9                	jmp    801b56 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b9d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba0:	0f 94 c0             	sete   %al
  801ba3:	0f b6 c0             	movzbl %al,%eax
}
  801ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5f                   	pop    %edi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <devpipe_write>:
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	57                   	push   %edi
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 28             	sub    $0x28,%esp
  801bb7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bba:	56                   	push   %esi
  801bbb:	e8 00 f7 ff ff       	call   8012c0 <fd2data>
  801bc0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bca:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bcd:	75 09                	jne    801bd8 <devpipe_write+0x2a>
	return i;
  801bcf:	89 f8                	mov    %edi,%eax
  801bd1:	eb 23                	jmp    801bf6 <devpipe_write+0x48>
			sys_yield();
  801bd3:	e8 31 f2 ff ff       	call   800e09 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bd8:	8b 43 04             	mov    0x4(%ebx),%eax
  801bdb:	8b 0b                	mov    (%ebx),%ecx
  801bdd:	8d 51 20             	lea    0x20(%ecx),%edx
  801be0:	39 d0                	cmp    %edx,%eax
  801be2:	72 1a                	jb     801bfe <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801be4:	89 da                	mov    %ebx,%edx
  801be6:	89 f0                	mov    %esi,%eax
  801be8:	e8 5c ff ff ff       	call   801b49 <_pipeisclosed>
  801bed:	85 c0                	test   %eax,%eax
  801bef:	74 e2                	je     801bd3 <devpipe_write+0x25>
				return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5f                   	pop    %edi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c01:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c05:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c08:	89 c2                	mov    %eax,%edx
  801c0a:	c1 fa 1f             	sar    $0x1f,%edx
  801c0d:	89 d1                	mov    %edx,%ecx
  801c0f:	c1 e9 1b             	shr    $0x1b,%ecx
  801c12:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c15:	83 e2 1f             	and    $0x1f,%edx
  801c18:	29 ca                	sub    %ecx,%edx
  801c1a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c1e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c22:	83 c0 01             	add    $0x1,%eax
  801c25:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c28:	83 c7 01             	add    $0x1,%edi
  801c2b:	eb 9d                	jmp    801bca <devpipe_write+0x1c>

00801c2d <devpipe_read>:
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	57                   	push   %edi
  801c31:	56                   	push   %esi
  801c32:	53                   	push   %ebx
  801c33:	83 ec 18             	sub    $0x18,%esp
  801c36:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c39:	57                   	push   %edi
  801c3a:	e8 81 f6 ff ff       	call   8012c0 <fd2data>
  801c3f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	be 00 00 00 00       	mov    $0x0,%esi
  801c49:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c4c:	75 13                	jne    801c61 <devpipe_read+0x34>
	return i;
  801c4e:	89 f0                	mov    %esi,%eax
  801c50:	eb 02                	jmp    801c54 <devpipe_read+0x27>
				return i;
  801c52:	89 f0                	mov    %esi,%eax
}
  801c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
			sys_yield();
  801c5c:	e8 a8 f1 ff ff       	call   800e09 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c61:	8b 03                	mov    (%ebx),%eax
  801c63:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c66:	75 18                	jne    801c80 <devpipe_read+0x53>
			if (i > 0)
  801c68:	85 f6                	test   %esi,%esi
  801c6a:	75 e6                	jne    801c52 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801c6c:	89 da                	mov    %ebx,%edx
  801c6e:	89 f8                	mov    %edi,%eax
  801c70:	e8 d4 fe ff ff       	call   801b49 <_pipeisclosed>
  801c75:	85 c0                	test   %eax,%eax
  801c77:	74 e3                	je     801c5c <devpipe_read+0x2f>
				return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb d4                	jmp    801c54 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c80:	99                   	cltd   
  801c81:	c1 ea 1b             	shr    $0x1b,%edx
  801c84:	01 d0                	add    %edx,%eax
  801c86:	83 e0 1f             	and    $0x1f,%eax
  801c89:	29 d0                	sub    %edx,%eax
  801c8b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c93:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c96:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c99:	83 c6 01             	add    $0x1,%esi
  801c9c:	eb ab                	jmp    801c49 <devpipe_read+0x1c>

00801c9e <pipe>:
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	56                   	push   %esi
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca9:	50                   	push   %eax
  801caa:	e8 28 f6 ff ff       	call   8012d7 <fd_alloc>
  801caf:	89 c3                	mov    %eax,%ebx
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	0f 88 23 01 00 00    	js     801ddf <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 07 04 00 00       	push   $0x407
  801cc4:	ff 75 f4             	push   -0xc(%ebp)
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 5a f1 ff ff       	call   800e28 <sys_page_alloc>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	0f 88 04 01 00 00    	js     801ddf <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce1:	50                   	push   %eax
  801ce2:	e8 f0 f5 ff ff       	call   8012d7 <fd_alloc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	0f 88 db 00 00 00    	js     801dcf <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	68 07 04 00 00       	push   $0x407
  801cfc:	ff 75 f0             	push   -0x10(%ebp)
  801cff:	6a 00                	push   $0x0
  801d01:	e8 22 f1 ff ff       	call   800e28 <sys_page_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	0f 88 bc 00 00 00    	js     801dcf <pipe+0x131>
	va = fd2data(fd0);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 75 f4             	push   -0xc(%ebp)
  801d19:	e8 a2 f5 ff ff       	call   8012c0 <fd2data>
  801d1e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d20:	83 c4 0c             	add    $0xc,%esp
  801d23:	68 07 04 00 00       	push   $0x407
  801d28:	50                   	push   %eax
  801d29:	6a 00                	push   $0x0
  801d2b:	e8 f8 f0 ff ff       	call   800e28 <sys_page_alloc>
  801d30:	89 c3                	mov    %eax,%ebx
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	85 c0                	test   %eax,%eax
  801d37:	0f 88 82 00 00 00    	js     801dbf <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	ff 75 f0             	push   -0x10(%ebp)
  801d43:	e8 78 f5 ff ff       	call   8012c0 <fd2data>
  801d48:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d4f:	50                   	push   %eax
  801d50:	6a 00                	push   $0x0
  801d52:	56                   	push   %esi
  801d53:	6a 00                	push   $0x0
  801d55:	e8 11 f1 ff ff       	call   800e6b <sys_page_map>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	83 c4 20             	add    $0x20,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 4e                	js     801db1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d63:	a1 20 30 80 00       	mov    0x803020,%eax
  801d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d70:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d86:	83 ec 0c             	sub    $0xc,%esp
  801d89:	ff 75 f4             	push   -0xc(%ebp)
  801d8c:	e8 1f f5 ff ff       	call   8012b0 <fd2num>
  801d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d94:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d96:	83 c4 04             	add    $0x4,%esp
  801d99:	ff 75 f0             	push   -0x10(%ebp)
  801d9c:	e8 0f f5 ff ff       	call   8012b0 <fd2num>
  801da1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801daf:	eb 2e                	jmp    801ddf <pipe+0x141>
	sys_page_unmap(0, va);
  801db1:	83 ec 08             	sub    $0x8,%esp
  801db4:	56                   	push   %esi
  801db5:	6a 00                	push   $0x0
  801db7:	e8 f1 f0 ff ff       	call   800ead <sys_page_unmap>
  801dbc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	ff 75 f0             	push   -0x10(%ebp)
  801dc5:	6a 00                	push   $0x0
  801dc7:	e8 e1 f0 ff ff       	call   800ead <sys_page_unmap>
  801dcc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dcf:	83 ec 08             	sub    $0x8,%esp
  801dd2:	ff 75 f4             	push   -0xc(%ebp)
  801dd5:	6a 00                	push   $0x0
  801dd7:	e8 d1 f0 ff ff       	call   800ead <sys_page_unmap>
  801ddc:	83 c4 10             	add    $0x10,%esp
}
  801ddf:	89 d8                	mov    %ebx,%eax
  801de1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    

00801de8 <pipeisclosed>:
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df1:	50                   	push   %eax
  801df2:	ff 75 08             	push   0x8(%ebp)
  801df5:	e8 2d f5 ff ff       	call   801327 <fd_lookup>
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 18                	js     801e19 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	ff 75 f4             	push   -0xc(%ebp)
  801e07:	e8 b4 f4 ff ff       	call   8012c0 <fd2data>
  801e0c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	e8 33 fd ff ff       	call   801b49 <_pipeisclosed>
  801e16:	83 c4 10             	add    $0x10,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	c3                   	ret    

00801e21 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e27:	68 09 29 80 00       	push   $0x802909
  801e2c:	ff 75 0c             	push   0xc(%ebp)
  801e2f:	e8 f8 eb ff ff       	call   800a2c <strcpy>
	return 0;
}
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devcons_write>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	53                   	push   %ebx
  801e41:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e47:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e4c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e52:	eb 2e                	jmp    801e82 <devcons_write+0x47>
		m = n - tot;
  801e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e57:	29 f3                	sub    %esi,%ebx
  801e59:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e5e:	39 c3                	cmp    %eax,%ebx
  801e60:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	53                   	push   %ebx
  801e67:	89 f0                	mov    %esi,%eax
  801e69:	03 45 0c             	add    0xc(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	57                   	push   %edi
  801e6e:	e8 4f ed ff ff       	call   800bc2 <memmove>
		sys_cputs(buf, m);
  801e73:	83 c4 08             	add    $0x8,%esp
  801e76:	53                   	push   %ebx
  801e77:	57                   	push   %edi
  801e78:	e8 ef ee ff ff       	call   800d6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e7d:	01 de                	add    %ebx,%esi
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e85:	72 cd                	jb     801e54 <devcons_write+0x19>
}
  801e87:	89 f0                	mov    %esi,%eax
  801e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5f                   	pop    %edi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <devcons_read>:
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 08             	sub    $0x8,%esp
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea0:	75 07                	jne    801ea9 <devcons_read+0x18>
  801ea2:	eb 1f                	jmp    801ec3 <devcons_read+0x32>
		sys_yield();
  801ea4:	e8 60 ef ff ff       	call   800e09 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ea9:	e8 dc ee ff ff       	call   800d8a <sys_cgetc>
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	74 f2                	je     801ea4 <devcons_read+0x13>
	if (c < 0)
  801eb2:	78 0f                	js     801ec3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801eb4:	83 f8 04             	cmp    $0x4,%eax
  801eb7:	74 0c                	je     801ec5 <devcons_read+0x34>
	*(char*)vbuf = c;
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	88 02                	mov    %al,(%edx)
	return 1;
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    
		return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb f7                	jmp    801ec3 <devcons_read+0x32>

00801ecc <cputchar>:
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ed8:	6a 01                	push   $0x1
  801eda:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801edd:	50                   	push   %eax
  801ede:	e8 89 ee ff ff       	call   800d6c <sys_cputs>
}
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <getchar>:
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801eee:	6a 01                	push   $0x1
  801ef0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ef3:	50                   	push   %eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	e8 90 f6 ff ff       	call   80158b <read>
	if (r < 0)
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 06                	js     801f08 <getchar+0x20>
	if (r < 1)
  801f02:	74 06                	je     801f0a <getchar+0x22>
	return c;
  801f04:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    
		return -E_EOF;
  801f0a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f0f:	eb f7                	jmp    801f08 <getchar+0x20>

00801f11 <iscons>:
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1a:	50                   	push   %eax
  801f1b:	ff 75 08             	push   0x8(%ebp)
  801f1e:	e8 04 f4 ff ff       	call   801327 <fd_lookup>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 11                	js     801f3b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f33:	39 10                	cmp    %edx,(%eax)
  801f35:	0f 94 c0             	sete   %al
  801f38:	0f b6 c0             	movzbl %al,%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <opencons>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f46:	50                   	push   %eax
  801f47:	e8 8b f3 ff ff       	call   8012d7 <fd_alloc>
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	78 3a                	js     801f8d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f53:	83 ec 04             	sub    $0x4,%esp
  801f56:	68 07 04 00 00       	push   $0x407
  801f5b:	ff 75 f4             	push   -0xc(%ebp)
  801f5e:	6a 00                	push   $0x0
  801f60:	e8 c3 ee ff ff       	call   800e28 <sys_page_alloc>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 21                	js     801f8d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f75:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	50                   	push   %eax
  801f85:	e8 26 f3 ff ff       	call   8012b0 <fd2num>
  801f8a:	83 c4 10             	add    $0x10,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f95:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801f9c:	74 20                	je     801fbe <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	a3 04 60 80 00       	mov    %eax,0x806004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	68 fe 1f 80 00       	push   $0x801ffe
  801fae:	6a 00                	push   $0x0
  801fb0:	e8 be ef ff ff       	call   800f73 <sys_env_set_pgfault_upcall>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 2e                	js     801fea <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	6a 07                	push   $0x7
  801fc3:	68 00 f0 bf ee       	push   $0xeebff000
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 59 ee ff ff       	call   800e28 <sys_page_alloc>
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	79 c8                	jns    801f9e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 18 29 80 00       	push   $0x802918
  801fde:	6a 21                	push   $0x21
  801fe0:	68 7b 29 80 00       	push   $0x80297b
  801fe5:	e8 a2 e2 ff ff       	call   80028c <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	68 44 29 80 00       	push   $0x802944
  801ff2:	6a 27                	push   $0x27
  801ff4:	68 7b 29 80 00       	push   $0x80297b
  801ff9:	e8 8e e2 ff ff       	call   80028c <_panic>

00801ffe <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801ffe:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fff:	a1 04 60 80 00       	mov    0x806004,%eax
	call *%eax
  802004:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802006:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  802009:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  80200d:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  802012:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  802016:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  802018:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80201b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80201c:	83 c4 04             	add    $0x4,%esp
	popfl
  80201f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802020:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802021:	c3                   	ret    

00802022 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	56                   	push   %esi
  802026:	53                   	push   %ebx
  802027:	8b 75 08             	mov    0x8(%ebp),%esi
  80202a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff 75 0c             	push   0xc(%ebp)
  802033:	e8 a0 ef ff ff       	call   800fd8 <sys_ipc_recv>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 2b                	js     80206a <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80203f:	85 f6                	test   %esi,%esi
  802041:	74 0a                	je     80204d <ipc_recv+0x2b>
  802043:	a1 00 40 80 00       	mov    0x804000,%eax
  802048:	8b 40 74             	mov    0x74(%eax),%eax
  80204b:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80204d:	85 db                	test   %ebx,%ebx
  80204f:	74 0a                	je     80205b <ipc_recv+0x39>
  802051:	a1 00 40 80 00       	mov    0x804000,%eax
  802056:	8b 40 78             	mov    0x78(%eax),%eax
  802059:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80205b:	a1 00 40 80 00       	mov    0x804000,%eax
  802060:	8b 40 70             	mov    0x70(%eax),%eax
}
  802063:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802066:	5b                   	pop    %ebx
  802067:	5e                   	pop    %esi
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80206a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80206f:	eb f2                	jmp    802063 <ipc_recv+0x41>

00802071 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	57                   	push   %edi
  802075:	56                   	push   %esi
  802076:	53                   	push   %ebx
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80207d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802080:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802083:	ff 75 14             	push   0x14(%ebp)
  802086:	53                   	push   %ebx
  802087:	56                   	push   %esi
  802088:	57                   	push   %edi
  802089:	e8 27 ef ff ff       	call   800fb5 <sys_ipc_try_send>
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	85 c0                	test   %eax,%eax
  802093:	79 20                	jns    8020b5 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802095:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802098:	75 07                	jne    8020a1 <ipc_send+0x30>
		sys_yield();
  80209a:	e8 6a ed ff ff       	call   800e09 <sys_yield>
  80209f:	eb e2                	jmp    802083 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 89 29 80 00       	push   $0x802989
  8020a9:	6a 2e                	push   $0x2e
  8020ab:	68 99 29 80 00       	push   $0x802999
  8020b0:	e8 d7 e1 ff ff       	call   80028c <_panic>
	}
}
  8020b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b8:	5b                   	pop    %ebx
  8020b9:	5e                   	pop    %esi
  8020ba:	5f                   	pop    %edi
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    

008020bd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020c8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020cb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020d1:	8b 52 50             	mov    0x50(%edx),%edx
  8020d4:	39 ca                	cmp    %ecx,%edx
  8020d6:	74 11                	je     8020e9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020d8:	83 c0 01             	add    $0x1,%eax
  8020db:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020e0:	75 e6                	jne    8020c8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	eb 0b                	jmp    8020f4 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020f1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    

008020f6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020fc:	89 c2                	mov    %eax,%edx
  8020fe:	c1 ea 16             	shr    $0x16,%edx
  802101:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802108:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80210d:	f6 c1 01             	test   $0x1,%cl
  802110:	74 1c                	je     80212e <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802112:	c1 e8 0c             	shr    $0xc,%eax
  802115:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80211c:	a8 01                	test   $0x1,%al
  80211e:	74 0e                	je     80212e <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802120:	c1 e8 0c             	shr    $0xc,%eax
  802123:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80212a:	ef 
  80212b:	0f b7 d2             	movzwl %dx,%edx
}
  80212e:	89 d0                	mov    %edx,%eax
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    
  802132:	66 90                	xchg   %ax,%ax
  802134:	66 90                	xchg   %ax,%ax
  802136:	66 90                	xchg   %ax,%ax
  802138:	66 90                	xchg   %ax,%ax
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <__udivdi3>:
  802140:	f3 0f 1e fb          	endbr32 
  802144:	55                   	push   %ebp
  802145:	57                   	push   %edi
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	83 ec 1c             	sub    $0x1c,%esp
  80214b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80214f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802153:	8b 74 24 34          	mov    0x34(%esp),%esi
  802157:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80215b:	85 c0                	test   %eax,%eax
  80215d:	75 19                	jne    802178 <__udivdi3+0x38>
  80215f:	39 f3                	cmp    %esi,%ebx
  802161:	76 4d                	jbe    8021b0 <__udivdi3+0x70>
  802163:	31 ff                	xor    %edi,%edi
  802165:	89 e8                	mov    %ebp,%eax
  802167:	89 f2                	mov    %esi,%edx
  802169:	f7 f3                	div    %ebx
  80216b:	89 fa                	mov    %edi,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	39 f0                	cmp    %esi,%eax
  80217a:	76 14                	jbe    802190 <__udivdi3+0x50>
  80217c:	31 ff                	xor    %edi,%edi
  80217e:	31 c0                	xor    %eax,%eax
  802180:	89 fa                	mov    %edi,%edx
  802182:	83 c4 1c             	add    $0x1c,%esp
  802185:	5b                   	pop    %ebx
  802186:	5e                   	pop    %esi
  802187:	5f                   	pop    %edi
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    
  80218a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802190:	0f bd f8             	bsr    %eax,%edi
  802193:	83 f7 1f             	xor    $0x1f,%edi
  802196:	75 48                	jne    8021e0 <__udivdi3+0xa0>
  802198:	39 f0                	cmp    %esi,%eax
  80219a:	72 06                	jb     8021a2 <__udivdi3+0x62>
  80219c:	31 c0                	xor    %eax,%eax
  80219e:	39 eb                	cmp    %ebp,%ebx
  8021a0:	77 de                	ja     802180 <__udivdi3+0x40>
  8021a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a7:	eb d7                	jmp    802180 <__udivdi3+0x40>
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	89 d9                	mov    %ebx,%ecx
  8021b2:	85 db                	test   %ebx,%ebx
  8021b4:	75 0b                	jne    8021c1 <__udivdi3+0x81>
  8021b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bb:	31 d2                	xor    %edx,%edx
  8021bd:	f7 f3                	div    %ebx
  8021bf:	89 c1                	mov    %eax,%ecx
  8021c1:	31 d2                	xor    %edx,%edx
  8021c3:	89 f0                	mov    %esi,%eax
  8021c5:	f7 f1                	div    %ecx
  8021c7:	89 c6                	mov    %eax,%esi
  8021c9:	89 e8                	mov    %ebp,%eax
  8021cb:	89 f7                	mov    %esi,%edi
  8021cd:	f7 f1                	div    %ecx
  8021cf:	89 fa                	mov    %edi,%edx
  8021d1:	83 c4 1c             	add    $0x1c,%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5f                   	pop    %edi
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 f9                	mov    %edi,%ecx
  8021e2:	ba 20 00 00 00       	mov    $0x20,%edx
  8021e7:	29 fa                	sub    %edi,%edx
  8021e9:	d3 e0                	shl    %cl,%eax
  8021eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ef:	89 d1                	mov    %edx,%ecx
  8021f1:	89 d8                	mov    %ebx,%eax
  8021f3:	d3 e8                	shr    %cl,%eax
  8021f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021f9:	09 c1                	or     %eax,%ecx
  8021fb:	89 f0                	mov    %esi,%eax
  8021fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802201:	89 f9                	mov    %edi,%ecx
  802203:	d3 e3                	shl    %cl,%ebx
  802205:	89 d1                	mov    %edx,%ecx
  802207:	d3 e8                	shr    %cl,%eax
  802209:	89 f9                	mov    %edi,%ecx
  80220b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80220f:	89 eb                	mov    %ebp,%ebx
  802211:	d3 e6                	shl    %cl,%esi
  802213:	89 d1                	mov    %edx,%ecx
  802215:	d3 eb                	shr    %cl,%ebx
  802217:	09 f3                	or     %esi,%ebx
  802219:	89 c6                	mov    %eax,%esi
  80221b:	89 f2                	mov    %esi,%edx
  80221d:	89 d8                	mov    %ebx,%eax
  80221f:	f7 74 24 08          	divl   0x8(%esp)
  802223:	89 d6                	mov    %edx,%esi
  802225:	89 c3                	mov    %eax,%ebx
  802227:	f7 64 24 0c          	mull   0xc(%esp)
  80222b:	39 d6                	cmp    %edx,%esi
  80222d:	72 19                	jb     802248 <__udivdi3+0x108>
  80222f:	89 f9                	mov    %edi,%ecx
  802231:	d3 e5                	shl    %cl,%ebp
  802233:	39 c5                	cmp    %eax,%ebp
  802235:	73 04                	jae    80223b <__udivdi3+0xfb>
  802237:	39 d6                	cmp    %edx,%esi
  802239:	74 0d                	je     802248 <__udivdi3+0x108>
  80223b:	89 d8                	mov    %ebx,%eax
  80223d:	31 ff                	xor    %edi,%edi
  80223f:	e9 3c ff ff ff       	jmp    802180 <__udivdi3+0x40>
  802244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802248:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80224b:	31 ff                	xor    %edi,%edi
  80224d:	e9 2e ff ff ff       	jmp    802180 <__udivdi3+0x40>
  802252:	66 90                	xchg   %ax,%ax
  802254:	66 90                	xchg   %ax,%ax
  802256:	66 90                	xchg   %ax,%ax
  802258:	66 90                	xchg   %ax,%ax
  80225a:	66 90                	xchg   %ax,%ax
  80225c:	66 90                	xchg   %ax,%ax
  80225e:	66 90                	xchg   %ax,%ax

00802260 <__umoddi3>:
  802260:	f3 0f 1e fb          	endbr32 
  802264:	55                   	push   %ebp
  802265:	57                   	push   %edi
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	83 ec 1c             	sub    $0x1c,%esp
  80226b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80226f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802273:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802277:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80227b:	89 f0                	mov    %esi,%eax
  80227d:	89 da                	mov    %ebx,%edx
  80227f:	85 ff                	test   %edi,%edi
  802281:	75 15                	jne    802298 <__umoddi3+0x38>
  802283:	39 dd                	cmp    %ebx,%ebp
  802285:	76 39                	jbe    8022c0 <__umoddi3+0x60>
  802287:	f7 f5                	div    %ebp
  802289:	89 d0                	mov    %edx,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	83 c4 1c             	add    $0x1c,%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	39 df                	cmp    %ebx,%edi
  80229a:	77 f1                	ja     80228d <__umoddi3+0x2d>
  80229c:	0f bd cf             	bsr    %edi,%ecx
  80229f:	83 f1 1f             	xor    $0x1f,%ecx
  8022a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022a6:	75 40                	jne    8022e8 <__umoddi3+0x88>
  8022a8:	39 df                	cmp    %ebx,%edi
  8022aa:	72 04                	jb     8022b0 <__umoddi3+0x50>
  8022ac:	39 f5                	cmp    %esi,%ebp
  8022ae:	77 dd                	ja     80228d <__umoddi3+0x2d>
  8022b0:	89 da                	mov    %ebx,%edx
  8022b2:	89 f0                	mov    %esi,%eax
  8022b4:	29 e8                	sub    %ebp,%eax
  8022b6:	19 fa                	sbb    %edi,%edx
  8022b8:	eb d3                	jmp    80228d <__umoddi3+0x2d>
  8022ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c0:	89 e9                	mov    %ebp,%ecx
  8022c2:	85 ed                	test   %ebp,%ebp
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0x71>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f5                	div    %ebp
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 d8                	mov    %ebx,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f1                	div    %ecx
  8022d7:	89 f0                	mov    %esi,%eax
  8022d9:	f7 f1                	div    %ecx
  8022db:	89 d0                	mov    %edx,%eax
  8022dd:	31 d2                	xor    %edx,%edx
  8022df:	eb ac                	jmp    80228d <__umoddi3+0x2d>
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ec:	ba 20 00 00 00       	mov    $0x20,%edx
  8022f1:	29 c2                	sub    %eax,%edx
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	89 e8                	mov    %ebp,%eax
  8022f7:	d3 e7                	shl    %cl,%edi
  8022f9:	89 d1                	mov    %edx,%ecx
  8022fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022ff:	d3 e8                	shr    %cl,%eax
  802301:	89 c1                	mov    %eax,%ecx
  802303:	8b 44 24 04          	mov    0x4(%esp),%eax
  802307:	09 f9                	or     %edi,%ecx
  802309:	89 df                	mov    %ebx,%edi
  80230b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80230f:	89 c1                	mov    %eax,%ecx
  802311:	d3 e5                	shl    %cl,%ebp
  802313:	89 d1                	mov    %edx,%ecx
  802315:	d3 ef                	shr    %cl,%edi
  802317:	89 c1                	mov    %eax,%ecx
  802319:	89 f0                	mov    %esi,%eax
  80231b:	d3 e3                	shl    %cl,%ebx
  80231d:	89 d1                	mov    %edx,%ecx
  80231f:	89 fa                	mov    %edi,%edx
  802321:	d3 e8                	shr    %cl,%eax
  802323:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802328:	09 d8                	or     %ebx,%eax
  80232a:	f7 74 24 08          	divl   0x8(%esp)
  80232e:	89 d3                	mov    %edx,%ebx
  802330:	d3 e6                	shl    %cl,%esi
  802332:	f7 e5                	mul    %ebp
  802334:	89 c7                	mov    %eax,%edi
  802336:	89 d1                	mov    %edx,%ecx
  802338:	39 d3                	cmp    %edx,%ebx
  80233a:	72 06                	jb     802342 <__umoddi3+0xe2>
  80233c:	75 0e                	jne    80234c <__umoddi3+0xec>
  80233e:	39 c6                	cmp    %eax,%esi
  802340:	73 0a                	jae    80234c <__umoddi3+0xec>
  802342:	29 e8                	sub    %ebp,%eax
  802344:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802348:	89 d1                	mov    %edx,%ecx
  80234a:	89 c7                	mov    %eax,%edi
  80234c:	89 f5                	mov    %esi,%ebp
  80234e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802352:	29 fd                	sub    %edi,%ebp
  802354:	19 cb                	sbb    %ecx,%ebx
  802356:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	d3 e0                	shl    %cl,%eax
  80235f:	89 f1                	mov    %esi,%ecx
  802361:	d3 ed                	shr    %cl,%ebp
  802363:	d3 eb                	shr    %cl,%ebx
  802365:	09 e8                	or     %ebp,%eax
  802367:	89 da                	mov    %ebx,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
