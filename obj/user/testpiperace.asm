
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 bd 01 00 00       	call   8001ee <libmain>
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
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 40 23 80 00       	push   $0x802340
  800040:	e8 dc 02 00 00       	call   800321 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 18 1d 00 00       	call   801d68 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 59                	js     8000b0 <umain+0x7d>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 76 10 00 00       	call   8010d2 <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 60                	js     8000c2 <umain+0x8f>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	74 70                	je     8000d4 <umain+0xa1>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800064:	83 ec 08             	sub    $0x8,%esp
  800067:	56                   	push   %esi
  800068:	68 91 23 80 00       	push   $0x802391
  80006d:	e8 af 02 00 00       	call   800321 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	6b c6 7c             	imul   $0x7c,%esi,%eax
  80007e:	c1 f8 02             	sar    $0x2,%eax
  800081:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800087:	50                   	push   %eax
  800088:	68 9c 23 80 00       	push   $0x80239c
  80008d:	e8 8f 02 00 00       	call   800321 <cprintf>
	dup(p[0], 10);
  800092:	83 c4 08             	add    $0x8,%esp
  800095:	6a 0a                	push   $0xa
  800097:	ff 75 f0             	push   -0x10(%ebp)
  80009a:	e8 90 14 00 00       	call   80152f <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ab:	e9 92 00 00 00       	jmp    800142 <umain+0x10f>
		panic("pipe: %e", r);
  8000b0:	50                   	push   %eax
  8000b1:	68 59 23 80 00       	push   $0x802359
  8000b6:	6a 0d                	push   $0xd
  8000b8:	68 62 23 80 00       	push   $0x802362
  8000bd:	e8 84 01 00 00       	call   800246 <_panic>
		panic("fork: %e", r);
  8000c2:	50                   	push   %eax
  8000c3:	68 e5 27 80 00       	push   $0x8027e5
  8000c8:	6a 10                	push   $0x10
  8000ca:	68 62 23 80 00       	push   $0x802362
  8000cf:	e8 72 01 00 00       	call   800246 <_panic>
		close(p[1]);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f4             	push   -0xc(%ebp)
  8000da:	e8 fe 13 00 00       	call   8014dd <close>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000e7:	eb 0a                	jmp    8000f3 <umain+0xc0>
			sys_yield();
  8000e9:	e8 d5 0c 00 00       	call   800dc3 <sys_yield>
		for (i=0; i<max; i++) {
  8000ee:	83 eb 01             	sub    $0x1,%ebx
  8000f1:	74 29                	je     80011c <umain+0xe9>
			if(pipeisclosed(p[0])){
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	ff 75 f0             	push   -0x10(%ebp)
  8000f9:	e8 b4 1d 00 00       	call   801eb2 <pipeisclosed>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	85 c0                	test   %eax,%eax
  800103:	74 e4                	je     8000e9 <umain+0xb6>
				cprintf("RACE: pipe appears closed\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 76 23 80 00       	push   $0x802376
  80010d:	e8 0f 02 00 00       	call   800321 <cprintf>
				exit();
  800112:	e8 1d 01 00 00       	call   800234 <exit>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	eb cd                	jmp    8000e9 <umain+0xb6>
		ipc_recv(0,0,0);
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	6a 00                	push   $0x0
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	e8 40 11 00 00       	call   80126a <ipc_recv>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	e9 32 ff ff ff       	jmp    800064 <umain+0x31>
		dup(p[0], 10);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	6a 0a                	push   $0xa
  800137:	ff 75 f0             	push   -0x10(%ebp)
  80013a:	e8 f0 13 00 00       	call   80152f <dup>
  80013f:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800142:	8b 43 54             	mov    0x54(%ebx),%eax
  800145:	83 f8 02             	cmp    $0x2,%eax
  800148:	74 e8                	je     800132 <umain+0xff>

	cprintf("child done with loop\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 a7 23 80 00       	push   $0x8023a7
  800152:	e8 ca 01 00 00       	call   800321 <cprintf>
	if (pipeisclosed(p[0]))
  800157:	83 c4 04             	add    $0x4,%esp
  80015a:	ff 75 f0             	push   -0x10(%ebp)
  80015d:	e8 50 1d 00 00       	call   801eb2 <pipeisclosed>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	75 48                	jne    8001b1 <umain+0x17e>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80016f:	50                   	push   %eax
  800170:	ff 75 f0             	push   -0x10(%ebp)
  800173:	e8 3d 12 00 00       	call   8013b5 <fd_lookup>
  800178:	83 c4 10             	add    $0x10,%esp
  80017b:	85 c0                	test   %eax,%eax
  80017d:	78 46                	js     8001c5 <umain+0x192>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 ec             	push   -0x14(%ebp)
  800185:	e8 c4 11 00 00       	call   80134e <fd2data>
	if (pageref(va) != 3+1)
  80018a:	89 04 24             	mov    %eax,(%esp)
  80018d:	e8 cd 19 00 00       	call   801b5f <pageref>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	83 f8 04             	cmp    $0x4,%eax
  800198:	74 3d                	je     8001d7 <umain+0x1a4>
		cprintf("\nchild detected race\n");
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	68 d5 23 80 00       	push   $0x8023d5
  8001a2:	e8 7a 01 00 00       	call   800321 <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 00 24 80 00       	push   $0x802400
  8001b9:	6a 3a                	push   $0x3a
  8001bb:	68 62 23 80 00       	push   $0x802362
  8001c0:	e8 81 00 00 00       	call   800246 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c5:	50                   	push   %eax
  8001c6:	68 bd 23 80 00       	push   $0x8023bd
  8001cb:	6a 3c                	push   $0x3c
  8001cd:	68 62 23 80 00       	push   $0x802362
  8001d2:	e8 6f 00 00 00       	call   800246 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	68 c8 00 00 00       	push   $0xc8
  8001df:	68 eb 23 80 00       	push   $0x8023eb
  8001e4:	e8 38 01 00 00       	call   800321 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
}
  8001ec:	eb bc                	jmp    8001aa <umain+0x177>

008001ee <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001f9:	e8 a6 0b 00 00       	call   800da4 <sys_getenvid>
  8001fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  800203:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800206:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020b:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800210:	85 db                	test   %ebx,%ebx
  800212:	7e 07                	jle    80021b <libmain+0x2d>
		binaryname = argv[0];
  800214:	8b 06                	mov    (%esi),%eax
  800216:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	e8 0e fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800225:	e8 0a 00 00 00       	call   800234 <exit>
}
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800230:	5b                   	pop    %ebx
  800231:	5e                   	pop    %esi
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    

00800234 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80023a:	6a 00                	push   $0x0
  80023c:	e8 22 0b 00 00       	call   800d63 <sys_env_destroy>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	56                   	push   %esi
  80024a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80024e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800254:	e8 4b 0b 00 00       	call   800da4 <sys_getenvid>
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 0c             	push   0xc(%ebp)
  80025f:	ff 75 08             	push   0x8(%ebp)
  800262:	56                   	push   %esi
  800263:	50                   	push   %eax
  800264:	68 34 24 80 00       	push   $0x802434
  800269:	e8 b3 00 00 00       	call   800321 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026e:	83 c4 18             	add    $0x18,%esp
  800271:	53                   	push   %ebx
  800272:	ff 75 10             	push   0x10(%ebp)
  800275:	e8 56 00 00 00       	call   8002d0 <vcprintf>
	cprintf("\n");
  80027a:	c7 04 24 57 23 80 00 	movl   $0x802357,(%esp)
  800281:	e8 9b 00 00 00       	call   800321 <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800289:	cc                   	int3   
  80028a:	eb fd                	jmp    800289 <_panic+0x43>

0080028c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	53                   	push   %ebx
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800296:	8b 13                	mov    (%ebx),%edx
  800298:	8d 42 01             	lea    0x1(%edx),%eax
  80029b:	89 03                	mov    %eax,(%ebx)
  80029d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a9:	74 09                	je     8002b4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	68 ff 00 00 00       	push   $0xff
  8002bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bf:	50                   	push   %eax
  8002c0:	e8 61 0a 00 00       	call   800d26 <sys_cputs>
		b->idx = 0;
  8002c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb db                	jmp    8002ab <putch+0x1f>

008002d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e0:	00 00 00 
	b.cnt = 0;
  8002e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ed:	ff 75 0c             	push   0xc(%ebp)
  8002f0:	ff 75 08             	push   0x8(%ebp)
  8002f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	68 8c 02 80 00       	push   $0x80028c
  8002ff:	e8 14 01 00 00       	call   800418 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800304:	83 c4 08             	add    $0x8,%esp
  800307:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80030d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800313:	50                   	push   %eax
  800314:	e8 0d 0a 00 00       	call   800d26 <sys_cputs>

	return b.cnt;
}
  800319:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800327:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 08             	push   0x8(%ebp)
  80032e:	e8 9d ff ff ff       	call   8002d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 1c             	sub    $0x1c,%esp
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 d6                	mov    %edx,%esi
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	8b 55 0c             	mov    0xc(%ebp),%edx
  800348:	89 d1                	mov    %edx,%ecx
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800362:	39 c2                	cmp    %eax,%edx
  800364:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800367:	72 3e                	jb     8003a7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	ff 75 18             	push   0x18(%ebp)
  80036f:	83 eb 01             	sub    $0x1,%ebx
  800372:	53                   	push   %ebx
  800373:	50                   	push   %eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 e4             	push   -0x1c(%ebp)
  80037a:	ff 75 e0             	push   -0x20(%ebp)
  80037d:	ff 75 dc             	push   -0x24(%ebp)
  800380:	ff 75 d8             	push   -0x28(%ebp)
  800383:	e8 68 1d 00 00       	call   8020f0 <__udivdi3>
  800388:	83 c4 18             	add    $0x18,%esp
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	89 f2                	mov    %esi,%edx
  80038f:	89 f8                	mov    %edi,%eax
  800391:	e8 9f ff ff ff       	call   800335 <printnum>
  800396:	83 c4 20             	add    $0x20,%esp
  800399:	eb 13                	jmp    8003ae <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	ff 75 18             	push   0x18(%ebp)
  8003a2:	ff d7                	call   *%edi
  8003a4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003a7:	83 eb 01             	sub    $0x1,%ebx
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	7f ed                	jg     80039b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	56                   	push   %esi
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 e4             	push   -0x1c(%ebp)
  8003b8:	ff 75 e0             	push   -0x20(%ebp)
  8003bb:	ff 75 dc             	push   -0x24(%ebp)
  8003be:	ff 75 d8             	push   -0x28(%ebp)
  8003c1:	e8 4a 1e 00 00       	call   802210 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 57 24 80 00 	movsbl 0x802457(%eax),%eax
  8003d0:	50                   	push   %eax
  8003d1:	ff d7                	call   *%edi
}
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003e8:	8b 10                	mov    (%eax),%edx
  8003ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ed:	73 0a                	jae    8003f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f2:	89 08                	mov    %ecx,(%eax)
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	88 02                	mov    %al,(%edx)
}
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <printfmt>:
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800401:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800404:	50                   	push   %eax
  800405:	ff 75 10             	push   0x10(%ebp)
  800408:	ff 75 0c             	push   0xc(%ebp)
  80040b:	ff 75 08             	push   0x8(%ebp)
  80040e:	e8 05 00 00 00       	call   800418 <vprintfmt>
}
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <vprintfmt>:
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	57                   	push   %edi
  80041c:	56                   	push   %esi
  80041d:	53                   	push   %ebx
  80041e:	83 ec 3c             	sub    $0x3c,%esp
  800421:	8b 75 08             	mov    0x8(%ebp),%esi
  800424:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800427:	8b 7d 10             	mov    0x10(%ebp),%edi
  80042a:	eb 0a                	jmp    800436 <vprintfmt+0x1e>
			putch(ch, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	53                   	push   %ebx
  800430:	50                   	push   %eax
  800431:	ff d6                	call   *%esi
  800433:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800436:	83 c7 01             	add    $0x1,%edi
  800439:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80043d:	83 f8 25             	cmp    $0x25,%eax
  800440:	74 0c                	je     80044e <vprintfmt+0x36>
			if (ch == '\0')
  800442:	85 c0                	test   %eax,%eax
  800444:	75 e6                	jne    80042c <vprintfmt+0x14>
}
  800446:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800449:	5b                   	pop    %ebx
  80044a:	5e                   	pop    %esi
  80044b:	5f                   	pop    %edi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    
		padc = ' ';
  80044e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800452:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800459:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800460:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800467:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046c:	8d 47 01             	lea    0x1(%edi),%eax
  80046f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800472:	0f b6 17             	movzbl (%edi),%edx
  800475:	8d 42 dd             	lea    -0x23(%edx),%eax
  800478:	3c 55                	cmp    $0x55,%al
  80047a:	0f 87 a6 04 00 00    	ja     800926 <vprintfmt+0x50e>
  800480:	0f b6 c0             	movzbl %al,%eax
  800483:	ff 24 85 a0 25 80 00 	jmp    *0x8025a0(,%eax,4)
  80048a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80048d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800491:	eb d9                	jmp    80046c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800496:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80049a:	eb d0                	jmp    80046c <vprintfmt+0x54>
  80049c:	0f b6 d2             	movzbl %dl,%edx
  80049f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004b7:	83 f9 09             	cmp    $0x9,%ecx
  8004ba:	77 55                	ja     800511 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004bf:	eb e9                	jmp    8004aa <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	8d 40 04             	lea    0x4(%eax),%eax
  8004cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8004d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d9:	79 91                	jns    80046c <vprintfmt+0x54>
				width = precision, precision = -1;
  8004db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004e8:	eb 82                	jmp    80046c <vprintfmt+0x54>
  8004ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	0f 49 c2             	cmovns %edx,%eax
  8004f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004fd:	e9 6a ff ff ff       	jmp    80046c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800502:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800505:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80050c:	e9 5b ff ff ff       	jmp    80046c <vprintfmt+0x54>
  800511:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	eb bc                	jmp    8004d5 <vprintfmt+0xbd>
			lflag++;
  800519:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80051f:	e9 48 ff ff ff       	jmp    80046c <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 78 04             	lea    0x4(%eax),%edi
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	53                   	push   %ebx
  80052e:	ff 30                	push   (%eax)
  800530:	ff d6                	call   *%esi
			break;
  800532:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800535:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800538:	e9 88 03 00 00       	jmp    8008c5 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 78 04             	lea    0x4(%eax),%edi
  800543:	8b 10                	mov    (%eax),%edx
  800545:	89 d0                	mov    %edx,%eax
  800547:	f7 d8                	neg    %eax
  800549:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054c:	83 f8 0f             	cmp    $0xf,%eax
  80054f:	7f 23                	jg     800574 <vprintfmt+0x15c>
  800551:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  800558:	85 d2                	test   %edx,%edx
  80055a:	74 18                	je     800574 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80055c:	52                   	push   %edx
  80055d:	68 f1 28 80 00       	push   $0x8028f1
  800562:	53                   	push   %ebx
  800563:	56                   	push   %esi
  800564:	e8 92 fe ff ff       	call   8003fb <printfmt>
  800569:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056f:	e9 51 03 00 00       	jmp    8008c5 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800574:	50                   	push   %eax
  800575:	68 6f 24 80 00       	push   $0x80246f
  80057a:	53                   	push   %ebx
  80057b:	56                   	push   %esi
  80057c:	e8 7a fe ff ff       	call   8003fb <printfmt>
  800581:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800584:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800587:	e9 39 03 00 00       	jmp    8008c5 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	83 c0 04             	add    $0x4,%eax
  800592:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80059a:	85 d2                	test   %edx,%edx
  80059c:	b8 68 24 80 00       	mov    $0x802468,%eax
  8005a1:	0f 45 c2             	cmovne %edx,%eax
  8005a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ab:	7e 06                	jle    8005b3 <vprintfmt+0x19b>
  8005ad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005b1:	75 0d                	jne    8005c0 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b6:	89 c7                	mov    %eax,%edi
  8005b8:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005be:	eb 55                	jmp    800615 <vprintfmt+0x1fd>
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	ff 75 e0             	push   -0x20(%ebp)
  8005c6:	ff 75 cc             	push   -0x34(%ebp)
  8005c9:	e8 f5 03 00 00       	call   8009c3 <strnlen>
  8005ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d1:	29 c2                	sub    %eax,%edx
  8005d3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005db:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e2:	eb 0f                	jmp    8005f3 <vprintfmt+0x1db>
					putch(padc, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	ff 75 d4             	push   -0x2c(%ebp)
  8005eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	83 ef 01             	sub    $0x1,%edi
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	85 ff                	test   %edi,%edi
  8005f5:	7f ed                	jg     8005e4 <vprintfmt+0x1cc>
  8005f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005fa:	85 d2                	test   %edx,%edx
  8005fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800601:	0f 49 c2             	cmovns %edx,%eax
  800604:	29 c2                	sub    %eax,%edx
  800606:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800609:	eb a8                	jmp    8005b3 <vprintfmt+0x19b>
					putch(ch, putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	52                   	push   %edx
  800610:	ff d6                	call   *%esi
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800618:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061a:	83 c7 01             	add    $0x1,%edi
  80061d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800621:	0f be d0             	movsbl %al,%edx
  800624:	85 d2                	test   %edx,%edx
  800626:	74 4b                	je     800673 <vprintfmt+0x25b>
  800628:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80062c:	78 06                	js     800634 <vprintfmt+0x21c>
  80062e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800632:	78 1e                	js     800652 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800638:	74 d1                	je     80060b <vprintfmt+0x1f3>
  80063a:	0f be c0             	movsbl %al,%eax
  80063d:	83 e8 20             	sub    $0x20,%eax
  800640:	83 f8 5e             	cmp    $0x5e,%eax
  800643:	76 c6                	jbe    80060b <vprintfmt+0x1f3>
					putch('?', putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 3f                	push   $0x3f
  80064b:	ff d6                	call   *%esi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	eb c3                	jmp    800615 <vprintfmt+0x1fd>
  800652:	89 cf                	mov    %ecx,%edi
  800654:	eb 0e                	jmp    800664 <vprintfmt+0x24c>
				putch(' ', putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	53                   	push   %ebx
  80065a:	6a 20                	push   $0x20
  80065c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80065e:	83 ef 01             	sub    $0x1,%edi
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	85 ff                	test   %edi,%edi
  800666:	7f ee                	jg     800656 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800668:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	e9 52 02 00 00       	jmp    8008c5 <vprintfmt+0x4ad>
  800673:	89 cf                	mov    %ecx,%edi
  800675:	eb ed                	jmp    800664 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	83 c0 04             	add    $0x4,%eax
  80067d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800685:	85 d2                	test   %edx,%edx
  800687:	b8 68 24 80 00       	mov    $0x802468,%eax
  80068c:	0f 45 c2             	cmovne %edx,%eax
  80068f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800692:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800696:	7e 06                	jle    80069e <vprintfmt+0x286>
  800698:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80069c:	75 0d                	jne    8006ab <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a1:	89 c7                	mov    %eax,%edi
  8006a3:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006a9:	eb 55                	jmp    800700 <vprintfmt+0x2e8>
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 e0             	push   -0x20(%ebp)
  8006b1:	ff 75 cc             	push   -0x34(%ebp)
  8006b4:	e8 0a 03 00 00       	call   8009c3 <strnlen>
  8006b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006c6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cd:	eb 0f                	jmp    8006de <vprintfmt+0x2c6>
					putch(padc, putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	ff 75 d4             	push   -0x2c(%ebp)
  8006d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d8:	83 ef 01             	sub    $0x1,%edi
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	85 ff                	test   %edi,%edi
  8006e0:	7f ed                	jg     8006cf <vprintfmt+0x2b7>
  8006e2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e5:	85 d2                	test   %edx,%edx
  8006e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ec:	0f 49 c2             	cmovns %edx,%eax
  8006ef:	29 c2                	sub    %eax,%edx
  8006f1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006f4:	eb a8                	jmp    80069e <vprintfmt+0x286>
					putch(ch, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	52                   	push   %edx
  8006fb:	ff d6                	call   *%esi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800703:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800705:	83 c7 01             	add    $0x1,%edi
  800708:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070c:	0f be d0             	movsbl %al,%edx
  80070f:	3c 3a                	cmp    $0x3a,%al
  800711:	74 4b                	je     80075e <vprintfmt+0x346>
  800713:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800717:	78 06                	js     80071f <vprintfmt+0x307>
  800719:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80071d:	78 1e                	js     80073d <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80071f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800723:	74 d1                	je     8006f6 <vprintfmt+0x2de>
  800725:	0f be c0             	movsbl %al,%eax
  800728:	83 e8 20             	sub    $0x20,%eax
  80072b:	83 f8 5e             	cmp    $0x5e,%eax
  80072e:	76 c6                	jbe    8006f6 <vprintfmt+0x2de>
					putch('?', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 3f                	push   $0x3f
  800736:	ff d6                	call   *%esi
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	eb c3                	jmp    800700 <vprintfmt+0x2e8>
  80073d:	89 cf                	mov    %ecx,%edi
  80073f:	eb 0e                	jmp    80074f <vprintfmt+0x337>
				putch(' ', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	53                   	push   %ebx
  800745:	6a 20                	push   $0x20
  800747:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800749:	83 ef 01             	sub    $0x1,%edi
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	85 ff                	test   %edi,%edi
  800751:	7f ee                	jg     800741 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800753:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	e9 67 01 00 00       	jmp    8008c5 <vprintfmt+0x4ad>
  80075e:	89 cf                	mov    %ecx,%edi
  800760:	eb ed                	jmp    80074f <vprintfmt+0x337>
	if (lflag >= 2)
  800762:	83 f9 01             	cmp    $0x1,%ecx
  800765:	7f 1b                	jg     800782 <vprintfmt+0x36a>
	else if (lflag)
  800767:	85 c9                	test   %ecx,%ecx
  800769:	74 63                	je     8007ce <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800773:	99                   	cltd   
  800774:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
  800780:	eb 17                	jmp    800799 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 50 04             	mov    0x4(%eax),%edx
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80078d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 08             	lea    0x8(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800799:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80079f:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007a4:	85 c9                	test   %ecx,%ecx
  8007a6:	0f 89 ff 00 00 00    	jns    8008ab <vprintfmt+0x493>
				putch('-', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 2d                	push   $0x2d
  8007b2:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007b7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007ba:	f7 da                	neg    %edx
  8007bc:	83 d1 00             	adc    $0x0,%ecx
  8007bf:	f7 d9                	neg    %ecx
  8007c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007c9:	e9 dd 00 00 00       	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007d6:	99                   	cltd   
  8007d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb b4                	jmp    800799 <vprintfmt+0x381>
	if (lflag >= 2)
  8007e5:	83 f9 01             	cmp    $0x1,%ecx
  8007e8:	7f 1e                	jg     800808 <vprintfmt+0x3f0>
	else if (lflag)
  8007ea:	85 c9                	test   %ecx,%ecx
  8007ec:	74 32                	je     800820 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 10                	mov    (%eax),%edx
  8007f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fe:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800803:	e9 a3 00 00 00       	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80081b:	e9 8b 00 00 00       	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800830:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800835:	eb 74                	jmp    8008ab <vprintfmt+0x493>
	if (lflag >= 2)
  800837:	83 f9 01             	cmp    $0x1,%ecx
  80083a:	7f 1b                	jg     800857 <vprintfmt+0x43f>
	else if (lflag)
  80083c:	85 c9                	test   %ecx,%ecx
  80083e:	74 2c                	je     80086c <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 10                	mov    (%eax),%edx
  800845:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084a:	8d 40 04             	lea    0x4(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800850:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800855:	eb 54                	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8b 10                	mov    (%eax),%edx
  80085c:	8b 48 04             	mov    0x4(%eax),%ecx
  80085f:	8d 40 08             	lea    0x8(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800865:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80086a:	eb 3f                	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 10                	mov    (%eax),%edx
  800871:	b9 00 00 00 00       	mov    $0x0,%ecx
  800876:	8d 40 04             	lea    0x4(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800881:	eb 28                	jmp    8008ab <vprintfmt+0x493>
			putch('0', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	6a 30                	push   $0x30
  800889:	ff d6                	call   *%esi
			putch('x', putdat);
  80088b:	83 c4 08             	add    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	6a 78                	push   $0x78
  800891:	ff d6                	call   *%esi
			num = (unsigned long long)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 10                	mov    (%eax),%edx
  800898:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80089d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a6:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8008ab:	83 ec 0c             	sub    $0xc,%esp
  8008ae:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008b2:	50                   	push   %eax
  8008b3:	ff 75 d4             	push   -0x2c(%ebp)
  8008b6:	57                   	push   %edi
  8008b7:	51                   	push   %ecx
  8008b8:	52                   	push   %edx
  8008b9:	89 da                	mov    %ebx,%edx
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	e8 73 fa ff ff       	call   800335 <printnum>
			break;
  8008c2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c8:	e9 69 fb ff ff       	jmp    800436 <vprintfmt+0x1e>
	if (lflag >= 2)
  8008cd:	83 f9 01             	cmp    $0x1,%ecx
  8008d0:	7f 1b                	jg     8008ed <vprintfmt+0x4d5>
	else if (lflag)
  8008d2:	85 c9                	test   %ecx,%ecx
  8008d4:	74 2c                	je     800902 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8b 10                	mov    (%eax),%edx
  8008db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008e0:	8d 40 04             	lea    0x4(%eax),%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e6:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8008eb:	eb be                	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8b 10                	mov    (%eax),%edx
  8008f2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008f5:	8d 40 08             	lea    0x8(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008fb:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800900:	eb a9                	jmp    8008ab <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 10                	mov    (%eax),%edx
  800907:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800917:	eb 92                	jmp    8008ab <vprintfmt+0x493>
			putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	6a 25                	push   $0x25
  80091f:	ff d6                	call   *%esi
			break;
  800921:	83 c4 10             	add    $0x10,%esp
  800924:	eb 9f                	jmp    8008c5 <vprintfmt+0x4ad>
			putch('%', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	53                   	push   %ebx
  80092a:	6a 25                	push   $0x25
  80092c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 f8                	mov    %edi,%eax
  800933:	eb 03                	jmp    800938 <vprintfmt+0x520>
  800935:	83 e8 01             	sub    $0x1,%eax
  800938:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80093c:	75 f7                	jne    800935 <vprintfmt+0x51d>
  80093e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800941:	eb 82                	jmp    8008c5 <vprintfmt+0x4ad>

00800943 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800952:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800956:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800959:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800960:	85 c0                	test   %eax,%eax
  800962:	74 26                	je     80098a <vsnprintf+0x47>
  800964:	85 d2                	test   %edx,%edx
  800966:	7e 22                	jle    80098a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800968:	ff 75 14             	push   0x14(%ebp)
  80096b:	ff 75 10             	push   0x10(%ebp)
  80096e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800971:	50                   	push   %eax
  800972:	68 de 03 80 00       	push   $0x8003de
  800977:	e8 9c fa ff ff       	call   800418 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80097f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800985:	83 c4 10             	add    $0x10,%esp
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    
		return -E_INVAL;
  80098a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098f:	eb f7                	jmp    800988 <vsnprintf+0x45>

00800991 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099a:	50                   	push   %eax
  80099b:	ff 75 10             	push   0x10(%ebp)
  80099e:	ff 75 0c             	push   0xc(%ebp)
  8009a1:	ff 75 08             	push   0x8(%ebp)
  8009a4:	e8 9a ff ff ff       	call   800943 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b6:	eb 03                	jmp    8009bb <strlen+0x10>
		n++;
  8009b8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009bf:	75 f7                	jne    8009b8 <strlen+0xd>
	return n;
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	eb 03                	jmp    8009d6 <strnlen+0x13>
		n++;
  8009d3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d6:	39 d0                	cmp    %edx,%eax
  8009d8:	74 08                	je     8009e2 <strnlen+0x1f>
  8009da:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009de:	75 f3                	jne    8009d3 <strnlen+0x10>
  8009e0:	89 c2                	mov    %eax,%edx
	return n;
}
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009f9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	84 d2                	test   %dl,%dl
  800a01:	75 f2                	jne    8009f5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a03:	89 c8                	mov    %ecx,%eax
  800a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	53                   	push   %ebx
  800a0e:	83 ec 10             	sub    $0x10,%esp
  800a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a14:	53                   	push   %ebx
  800a15:	e8 91 ff ff ff       	call   8009ab <strlen>
  800a1a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a1d:	ff 75 0c             	push   0xc(%ebp)
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	50                   	push   %eax
  800a23:	e8 be ff ff ff       	call   8009e6 <strcpy>
	return dst;
}
  800a28:	89 d8                	mov    %ebx,%eax
  800a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	8b 75 08             	mov    0x8(%ebp),%esi
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	89 f3                	mov    %esi,%ebx
  800a3c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3f:	89 f0                	mov    %esi,%eax
  800a41:	eb 0f                	jmp    800a52 <strncpy+0x23>
		*dst++ = *src;
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	0f b6 0a             	movzbl (%edx),%ecx
  800a49:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4c:	80 f9 01             	cmp    $0x1,%cl
  800a4f:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800a52:	39 d8                	cmp    %ebx,%eax
  800a54:	75 ed                	jne    800a43 <strncpy+0x14>
	}
	return ret;
}
  800a56:	89 f0                	mov    %esi,%eax
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	8b 75 08             	mov    0x8(%ebp),%esi
  800a64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a67:	8b 55 10             	mov    0x10(%ebp),%edx
  800a6a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	74 21                	je     800a91 <strlcpy+0x35>
  800a70:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a74:	89 f2                	mov    %esi,%edx
  800a76:	eb 09                	jmp    800a81 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a78:	83 c1 01             	add    $0x1,%ecx
  800a7b:	83 c2 01             	add    $0x1,%edx
  800a7e:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a81:	39 c2                	cmp    %eax,%edx
  800a83:	74 09                	je     800a8e <strlcpy+0x32>
  800a85:	0f b6 19             	movzbl (%ecx),%ebx
  800a88:	84 db                	test   %bl,%bl
  800a8a:	75 ec                	jne    800a78 <strlcpy+0x1c>
  800a8c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a91:	29 f0                	sub    %esi,%eax
}
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa0:	eb 06                	jmp    800aa8 <strcmp+0x11>
		p++, q++;
  800aa2:	83 c1 01             	add    $0x1,%ecx
  800aa5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800aa8:	0f b6 01             	movzbl (%ecx),%eax
  800aab:	84 c0                	test   %al,%al
  800aad:	74 04                	je     800ab3 <strcmp+0x1c>
  800aaf:	3a 02                	cmp    (%edx),%al
  800ab1:	74 ef                	je     800aa2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab3:	0f b6 c0             	movzbl %al,%eax
  800ab6:	0f b6 12             	movzbl (%edx),%edx
  800ab9:	29 d0                	sub    %edx,%eax
}
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	53                   	push   %ebx
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac7:	89 c3                	mov    %eax,%ebx
  800ac9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800acc:	eb 06                	jmp    800ad4 <strncmp+0x17>
		n--, p++, q++;
  800ace:	83 c0 01             	add    $0x1,%eax
  800ad1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad4:	39 d8                	cmp    %ebx,%eax
  800ad6:	74 18                	je     800af0 <strncmp+0x33>
  800ad8:	0f b6 08             	movzbl (%eax),%ecx
  800adb:	84 c9                	test   %cl,%cl
  800add:	74 04                	je     800ae3 <strncmp+0x26>
  800adf:	3a 0a                	cmp    (%edx),%cl
  800ae1:	74 eb                	je     800ace <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae3:	0f b6 00             	movzbl (%eax),%eax
  800ae6:	0f b6 12             	movzbl (%edx),%edx
  800ae9:	29 d0                	sub    %edx,%eax
}
  800aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    
		return 0;
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
  800af5:	eb f4                	jmp    800aeb <strncmp+0x2e>

00800af7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b01:	eb 03                	jmp    800b06 <strchr+0xf>
  800b03:	83 c0 01             	add    $0x1,%eax
  800b06:	0f b6 10             	movzbl (%eax),%edx
  800b09:	84 d2                	test   %dl,%dl
  800b0b:	74 06                	je     800b13 <strchr+0x1c>
		if (*s == c)
  800b0d:	38 ca                	cmp    %cl,%dl
  800b0f:	75 f2                	jne    800b03 <strchr+0xc>
  800b11:	eb 05                	jmp    800b18 <strchr+0x21>
			return (char *) s;
	return 0;
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b24:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b27:	38 ca                	cmp    %cl,%dl
  800b29:	74 09                	je     800b34 <strfind+0x1a>
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	74 05                	je     800b34 <strfind+0x1a>
	for (; *s; s++)
  800b2f:	83 c0 01             	add    $0x1,%eax
  800b32:	eb f0                	jmp    800b24 <strfind+0xa>
			break;
	return (char *) s;
}
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b42:	85 c9                	test   %ecx,%ecx
  800b44:	74 2f                	je     800b75 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b46:	89 f8                	mov    %edi,%eax
  800b48:	09 c8                	or     %ecx,%eax
  800b4a:	a8 03                	test   $0x3,%al
  800b4c:	75 21                	jne    800b6f <memset+0x39>
		c &= 0xFF;
  800b4e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b52:	89 d0                	mov    %edx,%eax
  800b54:	c1 e0 08             	shl    $0x8,%eax
  800b57:	89 d3                	mov    %edx,%ebx
  800b59:	c1 e3 18             	shl    $0x18,%ebx
  800b5c:	89 d6                	mov    %edx,%esi
  800b5e:	c1 e6 10             	shl    $0x10,%esi
  800b61:	09 f3                	or     %esi,%ebx
  800b63:	09 da                	or     %ebx,%edx
  800b65:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b67:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b6a:	fc                   	cld    
  800b6b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b6d:	eb 06                	jmp    800b75 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	fc                   	cld    
  800b73:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b75:	89 f8                	mov    %edi,%eax
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8a:	39 c6                	cmp    %eax,%esi
  800b8c:	73 32                	jae    800bc0 <memmove+0x44>
  800b8e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b91:	39 c2                	cmp    %eax,%edx
  800b93:	76 2b                	jbe    800bc0 <memmove+0x44>
		s += n;
		d += n;
  800b95:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b98:	89 d6                	mov    %edx,%esi
  800b9a:	09 fe                	or     %edi,%esi
  800b9c:	09 ce                	or     %ecx,%esi
  800b9e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ba4:	75 0e                	jne    800bb4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba6:	83 ef 04             	sub    $0x4,%edi
  800ba9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800baf:	fd                   	std    
  800bb0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb2:	eb 09                	jmp    800bbd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bb4:	83 ef 01             	sub    $0x1,%edi
  800bb7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bba:	fd                   	std    
  800bbb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bbd:	fc                   	cld    
  800bbe:	eb 1a                	jmp    800bda <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc0:	89 f2                	mov    %esi,%edx
  800bc2:	09 c2                	or     %eax,%edx
  800bc4:	09 ca                	or     %ecx,%edx
  800bc6:	f6 c2 03             	test   $0x3,%dl
  800bc9:	75 0a                	jne    800bd5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bcb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	fc                   	cld    
  800bd1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd3:	eb 05                	jmp    800bda <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bd5:	89 c7                	mov    %eax,%edi
  800bd7:	fc                   	cld    
  800bd8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bda:	5e                   	pop    %esi
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be4:	ff 75 10             	push   0x10(%ebp)
  800be7:	ff 75 0c             	push   0xc(%ebp)
  800bea:	ff 75 08             	push   0x8(%ebp)
  800bed:	e8 8a ff ff ff       	call   800b7c <memmove>
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bff:	89 c6                	mov    %eax,%esi
  800c01:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c04:	eb 06                	jmp    800c0c <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c06:	83 c0 01             	add    $0x1,%eax
  800c09:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800c0c:	39 f0                	cmp    %esi,%eax
  800c0e:	74 14                	je     800c24 <memcmp+0x30>
		if (*s1 != *s2)
  800c10:	0f b6 08             	movzbl (%eax),%ecx
  800c13:	0f b6 1a             	movzbl (%edx),%ebx
  800c16:	38 d9                	cmp    %bl,%cl
  800c18:	74 ec                	je     800c06 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800c1a:	0f b6 c1             	movzbl %cl,%eax
  800c1d:	0f b6 db             	movzbl %bl,%ebx
  800c20:	29 d8                	sub    %ebx,%eax
  800c22:	eb 05                	jmp    800c29 <memcmp+0x35>
	}

	return 0;
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c36:	89 c2                	mov    %eax,%edx
  800c38:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c3b:	eb 03                	jmp    800c40 <memfind+0x13>
  800c3d:	83 c0 01             	add    $0x1,%eax
  800c40:	39 d0                	cmp    %edx,%eax
  800c42:	73 04                	jae    800c48 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c44:	38 08                	cmp    %cl,(%eax)
  800c46:	75 f5                	jne    800c3d <memfind+0x10>
			break;
	return (void *) s;
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c56:	eb 03                	jmp    800c5b <strtol+0x11>
		s++;
  800c58:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800c5b:	0f b6 02             	movzbl (%edx),%eax
  800c5e:	3c 20                	cmp    $0x20,%al
  800c60:	74 f6                	je     800c58 <strtol+0xe>
  800c62:	3c 09                	cmp    $0x9,%al
  800c64:	74 f2                	je     800c58 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c66:	3c 2b                	cmp    $0x2b,%al
  800c68:	74 2a                	je     800c94 <strtol+0x4a>
	int neg = 0;
  800c6a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c6f:	3c 2d                	cmp    $0x2d,%al
  800c71:	74 2b                	je     800c9e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c73:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c79:	75 0f                	jne    800c8a <strtol+0x40>
  800c7b:	80 3a 30             	cmpb   $0x30,(%edx)
  800c7e:	74 28                	je     800ca8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c80:	85 db                	test   %ebx,%ebx
  800c82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c87:	0f 44 d8             	cmove  %eax,%ebx
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c92:	eb 46                	jmp    800cda <strtol+0x90>
		s++;
  800c94:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c97:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9c:	eb d5                	jmp    800c73 <strtol+0x29>
		s++, neg = 1;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ca6:	eb cb                	jmp    800c73 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cac:	74 0e                	je     800cbc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cae:	85 db                	test   %ebx,%ebx
  800cb0:	75 d8                	jne    800c8a <strtol+0x40>
		s++, base = 8;
  800cb2:	83 c2 01             	add    $0x1,%edx
  800cb5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cba:	eb ce                	jmp    800c8a <strtol+0x40>
		s += 2, base = 16;
  800cbc:	83 c2 02             	add    $0x2,%edx
  800cbf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cc4:	eb c4                	jmp    800c8a <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800cc6:	0f be c0             	movsbl %al,%eax
  800cc9:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ccc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ccf:	7d 3a                	jge    800d0b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd1:	83 c2 01             	add    $0x1,%edx
  800cd4:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800cd8:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800cda:	0f b6 02             	movzbl (%edx),%eax
  800cdd:	8d 70 d0             	lea    -0x30(%eax),%esi
  800ce0:	89 f3                	mov    %esi,%ebx
  800ce2:	80 fb 09             	cmp    $0x9,%bl
  800ce5:	76 df                	jbe    800cc6 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800ce7:	8d 70 9f             	lea    -0x61(%eax),%esi
  800cea:	89 f3                	mov    %esi,%ebx
  800cec:	80 fb 19             	cmp    $0x19,%bl
  800cef:	77 08                	ja     800cf9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf1:	0f be c0             	movsbl %al,%eax
  800cf4:	83 e8 57             	sub    $0x57,%eax
  800cf7:	eb d3                	jmp    800ccc <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800cf9:	8d 70 bf             	lea    -0x41(%eax),%esi
  800cfc:	89 f3                	mov    %esi,%ebx
  800cfe:	80 fb 19             	cmp    $0x19,%bl
  800d01:	77 08                	ja     800d0b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d03:	0f be c0             	movsbl %al,%eax
  800d06:	83 e8 37             	sub    $0x37,%eax
  800d09:	eb c1                	jmp    800ccc <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0f:	74 05                	je     800d16 <strtol+0xcc>
		*endptr = (char *) s;
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d16:	89 c8                	mov    %ecx,%eax
  800d18:	f7 d8                	neg    %eax
  800d1a:	85 ff                	test   %edi,%edi
  800d1c:	0f 45 c8             	cmovne %eax,%ecx
}
  800d1f:	89 c8                	mov    %ecx,%eax
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	89 c3                	mov    %eax,%ebx
  800d39:	89 c7                	mov    %eax,%edi
  800d3b:	89 c6                	mov    %eax,%esi
  800d3d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	b8 03 00 00 00       	mov    $0x3,%eax
  800d79:	89 cb                	mov    %ecx,%ebx
  800d7b:	89 cf                	mov    %ecx,%edi
  800d7d:	89 ce                	mov    %ecx,%esi
  800d7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	7f 08                	jg     800d8d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	50                   	push   %eax
  800d91:	6a 03                	push   $0x3
  800d93:	68 5f 27 80 00       	push   $0x80275f
  800d98:	6a 23                	push   $0x23
  800d9a:	68 7c 27 80 00       	push   $0x80277c
  800d9f:	e8 a2 f4 ff ff       	call   800246 <_panic>

00800da4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 02 00 00 00       	mov    $0x2,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_yield>:

void
sys_yield(void)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dce:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd3:	89 d1                	mov    %edx,%ecx
  800dd5:	89 d3                	mov    %edx,%ebx
  800dd7:	89 d7                	mov    %edx,%edi
  800dd9:	89 d6                	mov    %edx,%esi
  800ddb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800deb:	be 00 00 00 00       	mov    $0x0,%esi
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	b8 04 00 00 00       	mov    $0x4,%eax
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	89 f7                	mov    %esi,%edi
  800e00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 04                	push   $0x4
  800e14:	68 5f 27 80 00       	push   $0x80275f
  800e19:	6a 23                	push   $0x23
  800e1b:	68 7c 27 80 00       	push   $0x80277c
  800e20:	e8 21 f4 ff ff       	call   800246 <_panic>

00800e25 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	b8 05 00 00 00       	mov    $0x5,%eax
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	7f 08                	jg     800e50 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	50                   	push   %eax
  800e54:	6a 05                	push   $0x5
  800e56:	68 5f 27 80 00       	push   $0x80275f
  800e5b:	6a 23                	push   $0x23
  800e5d:	68 7c 27 80 00       	push   $0x80277c
  800e62:	e8 df f3 ff ff       	call   800246 <_panic>

00800e67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 06 00 00 00       	mov    $0x6,%eax
  800e80:	89 df                	mov    %ebx,%edi
  800e82:	89 de                	mov    %ebx,%esi
  800e84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7f 08                	jg     800e92 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	83 ec 0c             	sub    $0xc,%esp
  800e95:	50                   	push   %eax
  800e96:	6a 06                	push   $0x6
  800e98:	68 5f 27 80 00       	push   $0x80275f
  800e9d:	6a 23                	push   $0x23
  800e9f:	68 7c 27 80 00       	push   $0x80277c
  800ea4:	e8 9d f3 ff ff       	call   800246 <_panic>

00800ea9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebd:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7f 08                	jg     800ed4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	50                   	push   %eax
  800ed8:	6a 08                	push   $0x8
  800eda:	68 5f 27 80 00       	push   $0x80275f
  800edf:	6a 23                	push   $0x23
  800ee1:	68 7c 27 80 00       	push   $0x80277c
  800ee6:	e8 5b f3 ff ff       	call   800246 <_panic>

00800eeb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 09 00 00 00       	mov    $0x9,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 09                	push   $0x9
  800f1c:	68 5f 27 80 00       	push   $0x80275f
  800f21:	6a 23                	push   $0x23
  800f23:	68 7c 27 80 00       	push   $0x80277c
  800f28:	e8 19 f3 ff ff       	call   800246 <_panic>

00800f2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0a                	push   $0xa
  800f5e:	68 5f 27 80 00       	push   $0x80275f
  800f63:	6a 23                	push   $0x23
  800f65:	68 7c 27 80 00       	push   $0x80277c
  800f6a:	e8 d7 f2 ff ff       	call   800246 <_panic>

00800f6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f80:	be 00 00 00 00       	mov    $0x0,%esi
  800f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa8:	89 cb                	mov    %ecx,%ebx
  800faa:	89 cf                	mov    %ecx,%edi
  800fac:	89 ce                	mov    %ecx,%esi
  800fae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7f 08                	jg     800fbc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	6a 0d                	push   $0xd
  800fc2:	68 5f 27 80 00       	push   $0x80275f
  800fc7:	6a 23                	push   $0x23
  800fc9:	68 7c 27 80 00       	push   $0x80277c
  800fce:	e8 73 f2 ff ff       	call   800246 <_panic>

00800fd3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fdd:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800fdf:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fe3:	0f 84 99 00 00 00    	je     801082 <pgfault+0xaf>
  800fe9:	89 d8                	mov    %ebx,%eax
  800feb:	c1 e8 16             	shr    $0x16,%eax
  800fee:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ff5:	a8 01                	test   $0x1,%al
  800ff7:	0f 84 85 00 00 00    	je     801082 <pgfault+0xaf>
  800ffd:	89 d8                	mov    %ebx,%eax
  800fff:	c1 e8 0c             	shr    $0xc,%eax
  801002:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801009:	f6 c6 08             	test   $0x8,%dh
  80100c:	74 74                	je     801082 <pgfault+0xaf>
  80100e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801015:	a8 01                	test   $0x1,%al
  801017:	74 69                	je     801082 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	6a 07                	push   $0x7
  80101e:	68 00 f0 7f 00       	push   $0x7ff000
  801023:	6a 00                	push   $0x0
  801025:	e8 b8 fd ff ff       	call   800de2 <sys_page_alloc>
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 65                	js     801096 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801031:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	68 00 10 00 00       	push   $0x1000
  80103f:	53                   	push   %ebx
  801040:	68 00 f0 7f 00       	push   $0x7ff000
  801045:	e8 94 fb ff ff       	call   800bde <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  80104a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801051:	53                   	push   %ebx
  801052:	6a 00                	push   $0x0
  801054:	68 00 f0 7f 00       	push   $0x7ff000
  801059:	6a 00                	push   $0x0
  80105b:	e8 c5 fd ff ff       	call   800e25 <sys_page_map>
  801060:	83 c4 20             	add    $0x20,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	78 43                	js     8010aa <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	68 00 f0 7f 00       	push   $0x7ff000
  80106f:	6a 00                	push   $0x0
  801071:	e8 f1 fd ff ff       	call   800e67 <sys_page_unmap>
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	85 c0                	test   %eax,%eax
  80107b:	78 41                	js     8010be <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  80107d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801080:	c9                   	leave  
  801081:	c3                   	ret    
		panic("invalid permision\n");
  801082:	83 ec 04             	sub    $0x4,%esp
  801085:	68 8a 27 80 00       	push   $0x80278a
  80108a:	6a 1f                	push   $0x1f
  80108c:	68 9d 27 80 00       	push   $0x80279d
  801091:	e8 b0 f1 ff ff       	call   800246 <_panic>
		panic("Unable to alloc page\n");
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	68 a8 27 80 00       	push   $0x8027a8
  80109e:	6a 28                	push   $0x28
  8010a0:	68 9d 27 80 00       	push   $0x80279d
  8010a5:	e8 9c f1 ff ff       	call   800246 <_panic>
		panic("Unable to map\n");
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	68 be 27 80 00       	push   $0x8027be
  8010b2:	6a 2b                	push   $0x2b
  8010b4:	68 9d 27 80 00       	push   $0x80279d
  8010b9:	e8 88 f1 ff ff       	call   800246 <_panic>
		panic("Unable to unmap\n");
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	68 cd 27 80 00       	push   $0x8027cd
  8010c6:	6a 2d                	push   $0x2d
  8010c8:	68 9d 27 80 00       	push   $0x80279d
  8010cd:	e8 74 f1 ff ff       	call   800246 <_panic>

008010d2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  8010db:	68 d3 0f 80 00       	push   $0x800fd3
  8010e0:	e8 74 0f 00 00       	call   802059 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010ea:	cd 30                	int    $0x30
  8010ec:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	78 23                	js     801118 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8010f5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  8010fa:	75 6d                	jne    801169 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010fc:	e8 a3 fc ff ff       	call   800da4 <sys_getenvid>
  801101:	25 ff 03 00 00       	and    $0x3ff,%eax
  801106:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80110e:	a3 00 40 80 00       	mov    %eax,0x804000
		return 0;
  801113:	e9 02 01 00 00       	jmp    80121a <fork+0x148>
		panic("sys_exofork: %e", envid);
  801118:	50                   	push   %eax
  801119:	68 de 27 80 00       	push   $0x8027de
  80111e:	6a 6d                	push   $0x6d
  801120:	68 9d 27 80 00       	push   $0x80279d
  801125:	e8 1c f1 ff ff       	call   800246 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80112a:	c1 e0 0c             	shl    $0xc,%eax
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801136:	52                   	push   %edx
  801137:	50                   	push   %eax
  801138:	56                   	push   %esi
  801139:	50                   	push   %eax
  80113a:	6a 00                	push   $0x0
  80113c:	e8 e4 fc ff ff       	call   800e25 <sys_page_map>
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	eb 15                	jmp    80115b <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  801146:	c1 e0 0c             	shl    $0xc,%eax
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	6a 05                	push   $0x5
  80114e:	50                   	push   %eax
  80114f:	56                   	push   %esi
  801150:	50                   	push   %eax
  801151:	6a 00                	push   $0x0
  801153:	e8 cd fc ff ff       	call   800e25 <sys_page_map>
  801158:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80115b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801161:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801167:	74 7a                	je     8011e3 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	c1 e8 16             	shr    $0x16,%eax
  80116e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801175:	a8 01                	test   $0x1,%al
  801177:	74 e2                	je     80115b <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801179:	89 d8                	mov    %ebx,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
  80117e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801185:	f6 c2 01             	test   $0x1,%dl
  801188:	74 d1                	je     80115b <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80118a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801191:	f6 c2 04             	test   $0x4,%dl
  801194:	74 c5                	je     80115b <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801196:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80119d:	f6 c6 04             	test   $0x4,%dh
  8011a0:	75 88                	jne    80112a <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  8011a2:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8011a8:	74 9c                	je     801146 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  8011aa:	c1 e0 0c             	shl    $0xc,%eax
  8011ad:	89 c7                	mov    %eax,%edi
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	68 05 08 00 00       	push   $0x805
  8011b7:	50                   	push   %eax
  8011b8:	56                   	push   %esi
  8011b9:	50                   	push   %eax
  8011ba:	6a 00                	push   $0x0
  8011bc:	e8 64 fc ff ff       	call   800e25 <sys_page_map>
  8011c1:	83 c4 20             	add    $0x20,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 93                	js     80115b <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	68 05 08 00 00       	push   $0x805
  8011d0:	57                   	push   %edi
  8011d1:	6a 00                	push   $0x0
  8011d3:	57                   	push   %edi
  8011d4:	6a 00                	push   $0x0
  8011d6:	e8 4a fc ff ff       	call   800e25 <sys_page_map>
  8011db:	83 c4 20             	add    $0x20,%esp
  8011de:	e9 78 ff ff ff       	jmp    80115b <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	6a 07                	push   $0x7
  8011e8:	68 00 f0 bf ee       	push   $0xeebff000
  8011ed:	56                   	push   %esi
  8011ee:	e8 ef fb ff ff       	call   800de2 <sys_page_alloc>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	78 2a                	js     801224 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	68 c8 20 80 00       	push   $0x8020c8
  801202:	56                   	push   %esi
  801203:	e8 25 fd ff ff       	call   800f2d <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801208:	83 c4 08             	add    $0x8,%esp
  80120b:	6a 02                	push   $0x2
  80120d:	56                   	push   %esi
  80120e:	e8 96 fc ff ff       	call   800ea9 <sys_env_set_status>
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	85 c0                	test   %eax,%eax
  801218:	78 21                	js     80123b <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80121a:	89 f0                	mov    %esi,%eax
  80121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
		panic("failed to alloc page");
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	68 ee 27 80 00       	push   $0x8027ee
  80122c:	68 82 00 00 00       	push   $0x82
  801231:	68 9d 27 80 00       	push   $0x80279d
  801236:	e8 0b f0 ff ff       	call   800246 <_panic>
		panic("sys_env_set_status: %e", r);
  80123b:	50                   	push   %eax
  80123c:	68 03 28 80 00       	push   $0x802803
  801241:	68 89 00 00 00       	push   $0x89
  801246:	68 9d 27 80 00       	push   $0x80279d
  80124b:	e8 f6 ef ff ff       	call   800246 <_panic>

00801250 <sfork>:

// Challenge!
int
sfork(void)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801256:	68 1a 28 80 00       	push   $0x80281a
  80125b:	68 92 00 00 00       	push   $0x92
  801260:	68 9d 27 80 00       	push   $0x80279d
  801265:	e8 dc ef ff ff       	call   800246 <_panic>

0080126a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
  80126f:	8b 75 08             	mov    0x8(%ebp),%esi
  801272:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	ff 75 0c             	push   0xc(%ebp)
  80127b:	e8 12 fd ff ff       	call   800f92 <sys_ipc_recv>
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 2b                	js     8012b2 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801287:	85 f6                	test   %esi,%esi
  801289:	74 0a                	je     801295 <ipc_recv+0x2b>
  80128b:	a1 00 40 80 00       	mov    0x804000,%eax
  801290:	8b 40 74             	mov    0x74(%eax),%eax
  801293:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801295:	85 db                	test   %ebx,%ebx
  801297:	74 0a                	je     8012a3 <ipc_recv+0x39>
  801299:	a1 00 40 80 00       	mov    0x804000,%eax
  80129e:	8b 40 78             	mov    0x78(%eax),%eax
  8012a1:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8012a3:	a1 00 40 80 00       	mov    0x804000,%eax
  8012a8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8012b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b7:	eb f2                	jmp    8012ab <ipc_recv+0x41>

008012b9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8012cb:	ff 75 14             	push   0x14(%ebp)
  8012ce:	53                   	push   %ebx
  8012cf:	56                   	push   %esi
  8012d0:	57                   	push   %edi
  8012d1:	e8 99 fc ff ff       	call   800f6f <sys_ipc_try_send>
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	79 20                	jns    8012fd <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8012dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012e0:	75 07                	jne    8012e9 <ipc_send+0x30>
		sys_yield();
  8012e2:	e8 dc fa ff ff       	call   800dc3 <sys_yield>
  8012e7:	eb e2                	jmp    8012cb <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	68 30 28 80 00       	push   $0x802830
  8012f1:	6a 2e                	push   $0x2e
  8012f3:	68 40 28 80 00       	push   $0x802840
  8012f8:	e8 49 ef ff ff       	call   800246 <_panic>
	}
}
  8012fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5f                   	pop    %edi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801310:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801313:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801319:	8b 52 50             	mov    0x50(%edx),%edx
  80131c:	39 ca                	cmp    %ecx,%edx
  80131e:	74 11                	je     801331 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801320:	83 c0 01             	add    $0x1,%eax
  801323:	3d 00 04 00 00       	cmp    $0x400,%eax
  801328:	75 e6                	jne    801310 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	eb 0b                	jmp    80133c <ipc_find_env+0x37>
			return envs[i].env_id;
  801331:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801334:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801339:	8b 40 48             	mov    0x48(%eax),%eax
}
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	05 00 00 00 30       	add    $0x30000000,%eax
  801349:	c1 e8 0c             	shr    $0xc,%eax
}
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    

0080134e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801359:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	c1 ea 16             	shr    $0x16,%edx
  801372:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801379:	f6 c2 01             	test   $0x1,%dl
  80137c:	74 29                	je     8013a7 <fd_alloc+0x42>
  80137e:	89 c2                	mov    %eax,%edx
  801380:	c1 ea 0c             	shr    $0xc,%edx
  801383:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138a:	f6 c2 01             	test   $0x1,%dl
  80138d:	74 18                	je     8013a7 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80138f:	05 00 10 00 00       	add    $0x1000,%eax
  801394:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801399:	75 d2                	jne    80136d <fd_alloc+0x8>
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8013a0:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8013a5:	eb 05                	jmp    8013ac <fd_alloc+0x47>
			return 0;
  8013a7:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8013ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8013af:	89 02                	mov    %eax,(%edx)
}
  8013b1:	89 c8                	mov    %ecx,%eax
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013bb:	83 f8 1f             	cmp    $0x1f,%eax
  8013be:	77 30                	ja     8013f0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013c0:	c1 e0 0c             	shl    $0xc,%eax
  8013c3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013ce:	f6 c2 01             	test   $0x1,%dl
  8013d1:	74 24                	je     8013f7 <fd_lookup+0x42>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 0c             	shr    $0xc,%edx
  8013d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	74 1a                	je     8013fe <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e7:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    
		return -E_INVAL;
  8013f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f5:	eb f7                	jmp    8013ee <fd_lookup+0x39>
		return -E_INVAL;
  8013f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fc:	eb f0                	jmp    8013ee <fd_lookup+0x39>
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb e9                	jmp    8013ee <fd_lookup+0x39>

00801405 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	53                   	push   %ebx
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	8b 55 08             	mov    0x8(%ebp),%edx
  80140f:	b8 c8 28 80 00       	mov    $0x8028c8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801414:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801419:	39 13                	cmp    %edx,(%ebx)
  80141b:	74 32                	je     80144f <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80141d:	83 c0 04             	add    $0x4,%eax
  801420:	8b 18                	mov    (%eax),%ebx
  801422:	85 db                	test   %ebx,%ebx
  801424:	75 f3                	jne    801419 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801426:	a1 00 40 80 00       	mov    0x804000,%eax
  80142b:	8b 40 48             	mov    0x48(%eax),%eax
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	52                   	push   %edx
  801432:	50                   	push   %eax
  801433:	68 4c 28 80 00       	push   $0x80284c
  801438:	e8 e4 ee ff ff       	call   800321 <cprintf>
	*dev = 0;
	return -E_INVAL;
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	89 1a                	mov    %ebx,(%edx)
}
  80144a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    
			return 0;
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	eb ef                	jmp    801445 <dev_lookup+0x40>

00801456 <fd_close>:
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	57                   	push   %edi
  80145a:	56                   	push   %esi
  80145b:	53                   	push   %ebx
  80145c:	83 ec 24             	sub    $0x24,%esp
  80145f:	8b 75 08             	mov    0x8(%ebp),%esi
  801462:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801465:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801468:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801469:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80146f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801472:	50                   	push   %eax
  801473:	e8 3d ff ff ff       	call   8013b5 <fd_lookup>
  801478:	89 c3                	mov    %eax,%ebx
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 05                	js     801486 <fd_close+0x30>
	    || fd != fd2)
  801481:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801484:	74 16                	je     80149c <fd_close+0x46>
		return (must_exist ? r : 0);
  801486:	89 f8                	mov    %edi,%eax
  801488:	84 c0                	test   %al,%al
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	0f 44 d8             	cmove  %eax,%ebx
}
  801492:	89 d8                	mov    %ebx,%eax
  801494:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5f                   	pop    %edi
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	ff 36                	push   (%esi)
  8014a5:	e8 5b ff ff ff       	call   801405 <dev_lookup>
  8014aa:	89 c3                	mov    %eax,%ebx
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 1a                	js     8014cd <fd_close+0x77>
		if (dev->dev_close)
  8014b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	74 0b                	je     8014cd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	56                   	push   %esi
  8014c6:	ff d0                	call   *%eax
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	56                   	push   %esi
  8014d1:	6a 00                	push   $0x0
  8014d3:	e8 8f f9 ff ff       	call   800e67 <sys_page_unmap>
	return r;
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	eb b5                	jmp    801492 <fd_close+0x3c>

008014dd <close>:

int
close(int fdnum)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e6:	50                   	push   %eax
  8014e7:	ff 75 08             	push   0x8(%ebp)
  8014ea:	e8 c6 fe ff ff       	call   8013b5 <fd_lookup>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	79 02                	jns    8014f8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
		return fd_close(fd, 1);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	6a 01                	push   $0x1
  8014fd:	ff 75 f4             	push   -0xc(%ebp)
  801500:	e8 51 ff ff ff       	call   801456 <fd_close>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	eb ec                	jmp    8014f6 <close+0x19>

0080150a <close_all>:

void
close_all(void)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801511:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	53                   	push   %ebx
  80151a:	e8 be ff ff ff       	call   8014dd <close>
	for (i = 0; i < MAXFD; i++)
  80151f:	83 c3 01             	add    $0x1,%ebx
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	83 fb 20             	cmp    $0x20,%ebx
  801528:	75 ec                	jne    801516 <close_all+0xc>
}
  80152a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	57                   	push   %edi
  801533:	56                   	push   %esi
  801534:	53                   	push   %ebx
  801535:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801538:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 08             	push   0x8(%ebp)
  80153f:	e8 71 fe ff ff       	call   8013b5 <fd_lookup>
  801544:	89 c3                	mov    %eax,%ebx
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 7f                	js     8015cc <dup+0x9d>
		return r;
	close(newfdnum);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	ff 75 0c             	push   0xc(%ebp)
  801553:	e8 85 ff ff ff       	call   8014dd <close>

	newfd = INDEX2FD(newfdnum);
  801558:	8b 75 0c             	mov    0xc(%ebp),%esi
  80155b:	c1 e6 0c             	shl    $0xc,%esi
  80155e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801567:	89 3c 24             	mov    %edi,(%esp)
  80156a:	e8 df fd ff ff       	call   80134e <fd2data>
  80156f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801571:	89 34 24             	mov    %esi,(%esp)
  801574:	e8 d5 fd ff ff       	call   80134e <fd2data>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80157f:	89 d8                	mov    %ebx,%eax
  801581:	c1 e8 16             	shr    $0x16,%eax
  801584:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80158b:	a8 01                	test   $0x1,%al
  80158d:	74 11                	je     8015a0 <dup+0x71>
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	c1 e8 0c             	shr    $0xc,%eax
  801594:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80159b:	f6 c2 01             	test   $0x1,%dl
  80159e:	75 36                	jne    8015d6 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a0:	89 f8                	mov    %edi,%eax
  8015a2:	c1 e8 0c             	shr    $0xc,%eax
  8015a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b4:	50                   	push   %eax
  8015b5:	56                   	push   %esi
  8015b6:	6a 00                	push   $0x0
  8015b8:	57                   	push   %edi
  8015b9:	6a 00                	push   $0x0
  8015bb:	e8 65 f8 ff ff       	call   800e25 <sys_page_map>
  8015c0:	89 c3                	mov    %eax,%ebx
  8015c2:	83 c4 20             	add    $0x20,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 33                	js     8015fc <dup+0xcd>
		goto err;

	return newfdnum;
  8015c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015cc:	89 d8                	mov    %ebx,%eax
  8015ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d1:	5b                   	pop    %ebx
  8015d2:	5e                   	pop    %esi
  8015d3:	5f                   	pop    %edi
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e5:	50                   	push   %eax
  8015e6:	ff 75 d4             	push   -0x2c(%ebp)
  8015e9:	6a 00                	push   $0x0
  8015eb:	53                   	push   %ebx
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 32 f8 ff ff       	call   800e25 <sys_page_map>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 20             	add    $0x20,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	79 a4                	jns    8015a0 <dup+0x71>
	sys_page_unmap(0, newfd);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	56                   	push   %esi
  801600:	6a 00                	push   $0x0
  801602:	e8 60 f8 ff ff       	call   800e67 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801607:	83 c4 08             	add    $0x8,%esp
  80160a:	ff 75 d4             	push   -0x2c(%ebp)
  80160d:	6a 00                	push   $0x0
  80160f:	e8 53 f8 ff ff       	call   800e67 <sys_page_unmap>
	return r;
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	eb b3                	jmp    8015cc <dup+0x9d>

00801619 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	83 ec 18             	sub    $0x18,%esp
  801621:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801624:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	56                   	push   %esi
  801629:	e8 87 fd ff ff       	call   8013b5 <fd_lookup>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 3c                	js     801671 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801635:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163e:	50                   	push   %eax
  80163f:	ff 33                	push   (%ebx)
  801641:	e8 bf fd ff ff       	call   801405 <dev_lookup>
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 24                	js     801671 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80164d:	8b 43 08             	mov    0x8(%ebx),%eax
  801650:	83 e0 03             	and    $0x3,%eax
  801653:	83 f8 01             	cmp    $0x1,%eax
  801656:	74 20                	je     801678 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165b:	8b 40 08             	mov    0x8(%eax),%eax
  80165e:	85 c0                	test   %eax,%eax
  801660:	74 37                	je     801699 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	ff 75 10             	push   0x10(%ebp)
  801668:	ff 75 0c             	push   0xc(%ebp)
  80166b:	53                   	push   %ebx
  80166c:	ff d0                	call   *%eax
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801674:	5b                   	pop    %ebx
  801675:	5e                   	pop    %esi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801678:	a1 00 40 80 00       	mov    0x804000,%eax
  80167d:	8b 40 48             	mov    0x48(%eax),%eax
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	56                   	push   %esi
  801684:	50                   	push   %eax
  801685:	68 8d 28 80 00       	push   $0x80288d
  80168a:	e8 92 ec ff ff       	call   800321 <cprintf>
		return -E_INVAL;
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801697:	eb d8                	jmp    801671 <read+0x58>
		return -E_NOT_SUPP;
  801699:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169e:	eb d1                	jmp    801671 <read+0x58>

008016a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	57                   	push   %edi
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 0c             	sub    $0xc,%esp
  8016a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b4:	eb 02                	jmp    8016b8 <readn+0x18>
  8016b6:	01 c3                	add    %eax,%ebx
  8016b8:	39 f3                	cmp    %esi,%ebx
  8016ba:	73 21                	jae    8016dd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	89 f0                	mov    %esi,%eax
  8016c1:	29 d8                	sub    %ebx,%eax
  8016c3:	50                   	push   %eax
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	03 45 0c             	add    0xc(%ebp),%eax
  8016c9:	50                   	push   %eax
  8016ca:	57                   	push   %edi
  8016cb:	e8 49 ff ff ff       	call   801619 <read>
		if (m < 0)
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 04                	js     8016db <readn+0x3b>
			return m;
		if (m == 0)
  8016d7:	75 dd                	jne    8016b6 <readn+0x16>
  8016d9:	eb 02                	jmp    8016dd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016db:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016dd:	89 d8                	mov    %ebx,%eax
  8016df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5e                   	pop    %esi
  8016e4:	5f                   	pop    %edi
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	56                   	push   %esi
  8016eb:	53                   	push   %ebx
  8016ec:	83 ec 18             	sub    $0x18,%esp
  8016ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f5:	50                   	push   %eax
  8016f6:	53                   	push   %ebx
  8016f7:	e8 b9 fc ff ff       	call   8013b5 <fd_lookup>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 37                	js     80173a <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801703:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170c:	50                   	push   %eax
  80170d:	ff 36                	push   (%esi)
  80170f:	e8 f1 fc ff ff       	call   801405 <dev_lookup>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 1f                	js     80173a <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171b:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80171f:	74 20                	je     801741 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	8b 40 0c             	mov    0xc(%eax),%eax
  801727:	85 c0                	test   %eax,%eax
  801729:	74 37                	je     801762 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	ff 75 10             	push   0x10(%ebp)
  801731:	ff 75 0c             	push   0xc(%ebp)
  801734:	56                   	push   %esi
  801735:	ff d0                	call   *%eax
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801741:	a1 00 40 80 00       	mov    0x804000,%eax
  801746:	8b 40 48             	mov    0x48(%eax),%eax
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	53                   	push   %ebx
  80174d:	50                   	push   %eax
  80174e:	68 a9 28 80 00       	push   $0x8028a9
  801753:	e8 c9 eb ff ff       	call   800321 <cprintf>
		return -E_INVAL;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801760:	eb d8                	jmp    80173a <write+0x53>
		return -E_NOT_SUPP;
  801762:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801767:	eb d1                	jmp    80173a <write+0x53>

00801769 <seek>:

int
seek(int fdnum, off_t offset)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	ff 75 08             	push   0x8(%ebp)
  801776:	e8 3a fc ff ff       	call   8013b5 <fd_lookup>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 0e                	js     801790 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801788:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
  801797:	83 ec 18             	sub    $0x18,%esp
  80179a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a0:	50                   	push   %eax
  8017a1:	53                   	push   %ebx
  8017a2:	e8 0e fc ff ff       	call   8013b5 <fd_lookup>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 34                	js     8017e2 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ae:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b7:	50                   	push   %eax
  8017b8:	ff 36                	push   (%esi)
  8017ba:	e8 46 fc ff ff       	call   801405 <dev_lookup>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 1c                	js     8017e2 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c6:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8017ca:	74 1d                	je     8017e9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	8b 40 18             	mov    0x18(%eax),%eax
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 34                	je     80180a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	ff 75 0c             	push   0xc(%ebp)
  8017dc:	56                   	push   %esi
  8017dd:	ff d0                	call   *%eax
  8017df:	83 c4 10             	add    $0x10,%esp
}
  8017e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8017ee:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	53                   	push   %ebx
  8017f5:	50                   	push   %eax
  8017f6:	68 6c 28 80 00       	push   $0x80286c
  8017fb:	e8 21 eb ff ff       	call   800321 <cprintf>
		return -E_INVAL;
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801808:	eb d8                	jmp    8017e2 <ftruncate+0x50>
		return -E_NOT_SUPP;
  80180a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180f:	eb d1                	jmp    8017e2 <ftruncate+0x50>

00801811 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	83 ec 18             	sub    $0x18,%esp
  801819:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181f:	50                   	push   %eax
  801820:	ff 75 08             	push   0x8(%ebp)
  801823:	e8 8d fb ff ff       	call   8013b5 <fd_lookup>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 49                	js     801878 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182f:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	ff 36                	push   (%esi)
  80183b:	e8 c5 fb ff ff       	call   801405 <dev_lookup>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 31                	js     801878 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80184e:	74 2f                	je     80187f <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801850:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801853:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80185a:	00 00 00 
	stat->st_isdir = 0;
  80185d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801864:	00 00 00 
	stat->st_dev = dev;
  801867:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	53                   	push   %ebx
  801871:	56                   	push   %esi
  801872:	ff 50 14             	call   *0x14(%eax)
  801875:	83 c4 10             	add    $0x10,%esp
}
  801878:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    
		return -E_NOT_SUPP;
  80187f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801884:	eb f2                	jmp    801878 <fstat+0x67>

00801886 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 08             	push   0x8(%ebp)
  801893:	e8 22 02 00 00       	call   801aba <open>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 1b                	js     8018bc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	ff 75 0c             	push   0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	e8 64 ff ff ff       	call   801811 <fstat>
  8018ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8018af:	89 1c 24             	mov    %ebx,(%esp)
  8018b2:	e8 26 fc ff ff       	call   8014dd <close>
	return r;
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 f3                	mov    %esi,%ebx
}
  8018bc:	89 d8                	mov    %ebx,%eax
  8018be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	56                   	push   %esi
  8018c9:	53                   	push   %ebx
  8018ca:	89 c6                	mov    %eax,%esi
  8018cc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ce:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8018d5:	74 27                	je     8018fe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d7:	6a 07                	push   $0x7
  8018d9:	68 00 50 80 00       	push   $0x805000
  8018de:	56                   	push   %esi
  8018df:	ff 35 00 60 80 00    	push   0x806000
  8018e5:	e8 cf f9 ff ff       	call   8012b9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ea:	83 c4 0c             	add    $0xc,%esp
  8018ed:	6a 00                	push   $0x0
  8018ef:	53                   	push   %ebx
  8018f0:	6a 00                	push   $0x0
  8018f2:	e8 73 f9 ff ff       	call   80126a <ipc_recv>
}
  8018f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018fe:	83 ec 0c             	sub    $0xc,%esp
  801901:	6a 01                	push   $0x1
  801903:	e8 fd f9 ff ff       	call   801305 <ipc_find_env>
  801908:	a3 00 60 80 00       	mov    %eax,0x806000
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	eb c5                	jmp    8018d7 <fsipc+0x12>

00801912 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8b 40 0c             	mov    0xc(%eax),%eax
  80191e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	b8 02 00 00 00       	mov    $0x2,%eax
  801935:	e8 8b ff ff ff       	call   8018c5 <fsipc>
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <devfile_flush>:
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8b 40 0c             	mov    0xc(%eax),%eax
  801948:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80194d:	ba 00 00 00 00       	mov    $0x0,%edx
  801952:	b8 06 00 00 00       	mov    $0x6,%eax
  801957:	e8 69 ff ff ff       	call   8018c5 <fsipc>
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <devfile_stat>:
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	53                   	push   %ebx
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8b 40 0c             	mov    0xc(%eax),%eax
  80196e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
  801978:	b8 05 00 00 00       	mov    $0x5,%eax
  80197d:	e8 43 ff ff ff       	call   8018c5 <fsipc>
  801982:	85 c0                	test   %eax,%eax
  801984:	78 2c                	js     8019b2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801986:	83 ec 08             	sub    $0x8,%esp
  801989:	68 00 50 80 00       	push   $0x805000
  80198e:	53                   	push   %ebx
  80198f:	e8 52 f0 ff ff       	call   8009e6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801994:	a1 80 50 80 00       	mov    0x805080,%eax
  801999:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80199f:	a1 84 50 80 00       	mov    0x805084,%eax
  8019a4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <devfile_write>:
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019cc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019d2:	53                   	push   %ebx
  8019d3:	ff 75 0c             	push   0xc(%ebp)
  8019d6:	68 08 50 80 00       	push   $0x805008
  8019db:	e8 fe f1 ff ff       	call   800bde <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e5:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ea:	e8 d6 fe ff ff       	call   8018c5 <fsipc>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 0b                	js     801a01 <devfile_write+0x4a>
	assert(r <= n);
  8019f6:	39 d8                	cmp    %ebx,%eax
  8019f8:	77 0c                	ja     801a06 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8019fa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ff:	7f 1e                	jg     801a1f <devfile_write+0x68>
}
  801a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    
	assert(r <= n);
  801a06:	68 d8 28 80 00       	push   $0x8028d8
  801a0b:	68 df 28 80 00       	push   $0x8028df
  801a10:	68 97 00 00 00       	push   $0x97
  801a15:	68 f4 28 80 00       	push   $0x8028f4
  801a1a:	e8 27 e8 ff ff       	call   800246 <_panic>
	assert(r <= PGSIZE);
  801a1f:	68 ff 28 80 00       	push   $0x8028ff
  801a24:	68 df 28 80 00       	push   $0x8028df
  801a29:	68 98 00 00 00       	push   $0x98
  801a2e:	68 f4 28 80 00       	push   $0x8028f4
  801a33:	e8 0e e8 ff ff       	call   800246 <_panic>

00801a38 <devfile_read>:
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8b 40 0c             	mov    0xc(%eax),%eax
  801a46:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a4b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	b8 03 00 00 00       	mov    $0x3,%eax
  801a5b:	e8 65 fe ff ff       	call   8018c5 <fsipc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 1f                	js     801a85 <devfile_read+0x4d>
	assert(r <= n);
  801a66:	39 f0                	cmp    %esi,%eax
  801a68:	77 24                	ja     801a8e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6f:	7f 33                	jg     801aa4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	50                   	push   %eax
  801a75:	68 00 50 80 00       	push   $0x805000
  801a7a:	ff 75 0c             	push   0xc(%ebp)
  801a7d:	e8 fa f0 ff ff       	call   800b7c <memmove>
	return r;
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
	assert(r <= n);
  801a8e:	68 d8 28 80 00       	push   $0x8028d8
  801a93:	68 df 28 80 00       	push   $0x8028df
  801a98:	6a 7c                	push   $0x7c
  801a9a:	68 f4 28 80 00       	push   $0x8028f4
  801a9f:	e8 a2 e7 ff ff       	call   800246 <_panic>
	assert(r <= PGSIZE);
  801aa4:	68 ff 28 80 00       	push   $0x8028ff
  801aa9:	68 df 28 80 00       	push   $0x8028df
  801aae:	6a 7d                	push   $0x7d
  801ab0:	68 f4 28 80 00       	push   $0x8028f4
  801ab5:	e8 8c e7 ff ff       	call   800246 <_panic>

00801aba <open>:
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 1c             	sub    $0x1c,%esp
  801ac2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ac5:	56                   	push   %esi
  801ac6:	e8 e0 ee ff ff       	call   8009ab <strlen>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad3:	7f 6c                	jg     801b41 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adb:	50                   	push   %eax
  801adc:	e8 84 f8 ff ff       	call   801365 <fd_alloc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 3c                	js     801b26 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	56                   	push   %esi
  801aee:	68 00 50 80 00       	push   $0x805000
  801af3:	e8 ee ee ff ff       	call   8009e6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	e8 b8 fd ff ff       	call   8018c5 <fsipc>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 19                	js     801b2f <open+0x75>
	return fd2num(fd);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	ff 75 f4             	push   -0xc(%ebp)
  801b1c:	e8 1d f8 ff ff       	call   80133e <fd2num>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    
		fd_close(fd, 0);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 f4             	push   -0xc(%ebp)
  801b37:	e8 1a f9 ff ff       	call   801456 <fd_close>
		return r;
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	eb e5                	jmp    801b26 <open+0x6c>
		return -E_BAD_PATH;
  801b41:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b46:	eb de                	jmp    801b26 <open+0x6c>

00801b48 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 08 00 00 00       	mov    $0x8,%eax
  801b58:	e8 68 fd ff ff       	call   8018c5 <fsipc>
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b65:	89 c2                	mov    %eax,%edx
  801b67:	c1 ea 16             	shr    $0x16,%edx
  801b6a:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b71:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b76:	f6 c1 01             	test   $0x1,%cl
  801b79:	74 1c                	je     801b97 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801b7b:	c1 e8 0c             	shr    $0xc,%eax
  801b7e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b85:	a8 01                	test   $0x1,%al
  801b87:	74 0e                	je     801b97 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b89:	c1 e8 0c             	shr    $0xc,%eax
  801b8c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b93:	ef 
  801b94:	0f b7 d2             	movzwl %dx,%edx
}
  801b97:	89 d0                	mov    %edx,%eax
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    

00801b9b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ba3:	83 ec 0c             	sub    $0xc,%esp
  801ba6:	ff 75 08             	push   0x8(%ebp)
  801ba9:	e8 a0 f7 ff ff       	call   80134e <fd2data>
  801bae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bb0:	83 c4 08             	add    $0x8,%esp
  801bb3:	68 0b 29 80 00       	push   $0x80290b
  801bb8:	53                   	push   %ebx
  801bb9:	e8 28 ee ff ff       	call   8009e6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bbe:	8b 46 04             	mov    0x4(%esi),%eax
  801bc1:	2b 06                	sub    (%esi),%eax
  801bc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bc9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd0:	00 00 00 
	stat->st_dev = &devpipe;
  801bd3:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bda:	30 80 00 
	return 0;
}
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	53                   	push   %ebx
  801bed:	83 ec 0c             	sub    $0xc,%esp
  801bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bf3:	53                   	push   %ebx
  801bf4:	6a 00                	push   $0x0
  801bf6:	e8 6c f2 ff ff       	call   800e67 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bfb:	89 1c 24             	mov    %ebx,(%esp)
  801bfe:	e8 4b f7 ff ff       	call   80134e <fd2data>
  801c03:	83 c4 08             	add    $0x8,%esp
  801c06:	50                   	push   %eax
  801c07:	6a 00                	push   $0x0
  801c09:	e8 59 f2 ff ff       	call   800e67 <sys_page_unmap>
}
  801c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <_pipeisclosed>:
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	57                   	push   %edi
  801c17:	56                   	push   %esi
  801c18:	53                   	push   %ebx
  801c19:	83 ec 1c             	sub    $0x1c,%esp
  801c1c:	89 c7                	mov    %eax,%edi
  801c1e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c20:	a1 00 40 80 00       	mov    0x804000,%eax
  801c25:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	57                   	push   %edi
  801c2c:	e8 2e ff ff ff       	call   801b5f <pageref>
  801c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c34:	89 34 24             	mov    %esi,(%esp)
  801c37:	e8 23 ff ff ff       	call   801b5f <pageref>
		nn = thisenv->env_runs;
  801c3c:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801c42:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	39 cb                	cmp    %ecx,%ebx
  801c4a:	74 1b                	je     801c67 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c4f:	75 cf                	jne    801c20 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c51:	8b 42 58             	mov    0x58(%edx),%eax
  801c54:	6a 01                	push   $0x1
  801c56:	50                   	push   %eax
  801c57:	53                   	push   %ebx
  801c58:	68 12 29 80 00       	push   $0x802912
  801c5d:	e8 bf e6 ff ff       	call   800321 <cprintf>
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	eb b9                	jmp    801c20 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c67:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c6a:	0f 94 c0             	sete   %al
  801c6d:	0f b6 c0             	movzbl %al,%eax
}
  801c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    

00801c78 <devpipe_write>:
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	57                   	push   %edi
  801c7c:	56                   	push   %esi
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 28             	sub    $0x28,%esp
  801c81:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c84:	56                   	push   %esi
  801c85:	e8 c4 f6 ff ff       	call   80134e <fd2data>
  801c8a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c94:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c97:	75 09                	jne    801ca2 <devpipe_write+0x2a>
	return i;
  801c99:	89 f8                	mov    %edi,%eax
  801c9b:	eb 23                	jmp    801cc0 <devpipe_write+0x48>
			sys_yield();
  801c9d:	e8 21 f1 ff ff       	call   800dc3 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ca2:	8b 43 04             	mov    0x4(%ebx),%eax
  801ca5:	8b 0b                	mov    (%ebx),%ecx
  801ca7:	8d 51 20             	lea    0x20(%ecx),%edx
  801caa:	39 d0                	cmp    %edx,%eax
  801cac:	72 1a                	jb     801cc8 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801cae:	89 da                	mov    %ebx,%edx
  801cb0:	89 f0                	mov    %esi,%eax
  801cb2:	e8 5c ff ff ff       	call   801c13 <_pipeisclosed>
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	74 e2                	je     801c9d <devpipe_write+0x25>
				return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ccb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ccf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cd2:	89 c2                	mov    %eax,%edx
  801cd4:	c1 fa 1f             	sar    $0x1f,%edx
  801cd7:	89 d1                	mov    %edx,%ecx
  801cd9:	c1 e9 1b             	shr    $0x1b,%ecx
  801cdc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cdf:	83 e2 1f             	and    $0x1f,%edx
  801ce2:	29 ca                	sub    %ecx,%edx
  801ce4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ce8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cec:	83 c0 01             	add    $0x1,%eax
  801cef:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cf2:	83 c7 01             	add    $0x1,%edi
  801cf5:	eb 9d                	jmp    801c94 <devpipe_write+0x1c>

00801cf7 <devpipe_read>:
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	57                   	push   %edi
  801cfb:	56                   	push   %esi
  801cfc:	53                   	push   %ebx
  801cfd:	83 ec 18             	sub    $0x18,%esp
  801d00:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d03:	57                   	push   %edi
  801d04:	e8 45 f6 ff ff       	call   80134e <fd2data>
  801d09:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	be 00 00 00 00       	mov    $0x0,%esi
  801d13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d16:	75 13                	jne    801d2b <devpipe_read+0x34>
	return i;
  801d18:	89 f0                	mov    %esi,%eax
  801d1a:	eb 02                	jmp    801d1e <devpipe_read+0x27>
				return i;
  801d1c:	89 f0                	mov    %esi,%eax
}
  801d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
			sys_yield();
  801d26:	e8 98 f0 ff ff       	call   800dc3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d2b:	8b 03                	mov    (%ebx),%eax
  801d2d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d30:	75 18                	jne    801d4a <devpipe_read+0x53>
			if (i > 0)
  801d32:	85 f6                	test   %esi,%esi
  801d34:	75 e6                	jne    801d1c <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801d36:	89 da                	mov    %ebx,%edx
  801d38:	89 f8                	mov    %edi,%eax
  801d3a:	e8 d4 fe ff ff       	call   801c13 <_pipeisclosed>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	74 e3                	je     801d26 <devpipe_read+0x2f>
				return 0;
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	eb d4                	jmp    801d1e <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d4a:	99                   	cltd   
  801d4b:	c1 ea 1b             	shr    $0x1b,%edx
  801d4e:	01 d0                	add    %edx,%eax
  801d50:	83 e0 1f             	and    $0x1f,%eax
  801d53:	29 d0                	sub    %edx,%eax
  801d55:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d5d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d60:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d63:	83 c6 01             	add    $0x1,%esi
  801d66:	eb ab                	jmp    801d13 <devpipe_read+0x1c>

00801d68 <pipe>:
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d73:	50                   	push   %eax
  801d74:	e8 ec f5 ff ff       	call   801365 <fd_alloc>
  801d79:	89 c3                	mov    %eax,%ebx
  801d7b:	83 c4 10             	add    $0x10,%esp
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	0f 88 23 01 00 00    	js     801ea9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	68 07 04 00 00       	push   $0x407
  801d8e:	ff 75 f4             	push   -0xc(%ebp)
  801d91:	6a 00                	push   $0x0
  801d93:	e8 4a f0 ff ff       	call   800de2 <sys_page_alloc>
  801d98:	89 c3                	mov    %eax,%ebx
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	0f 88 04 01 00 00    	js     801ea9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dab:	50                   	push   %eax
  801dac:	e8 b4 f5 ff ff       	call   801365 <fd_alloc>
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	85 c0                	test   %eax,%eax
  801db8:	0f 88 db 00 00 00    	js     801e99 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 07 04 00 00       	push   $0x407
  801dc6:	ff 75 f0             	push   -0x10(%ebp)
  801dc9:	6a 00                	push   $0x0
  801dcb:	e8 12 f0 ff ff       	call   800de2 <sys_page_alloc>
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	0f 88 bc 00 00 00    	js     801e99 <pipe+0x131>
	va = fd2data(fd0);
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	ff 75 f4             	push   -0xc(%ebp)
  801de3:	e8 66 f5 ff ff       	call   80134e <fd2data>
  801de8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dea:	83 c4 0c             	add    $0xc,%esp
  801ded:	68 07 04 00 00       	push   $0x407
  801df2:	50                   	push   %eax
  801df3:	6a 00                	push   $0x0
  801df5:	e8 e8 ef ff ff       	call   800de2 <sys_page_alloc>
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	0f 88 82 00 00 00    	js     801e89 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	ff 75 f0             	push   -0x10(%ebp)
  801e0d:	e8 3c f5 ff ff       	call   80134e <fd2data>
  801e12:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e19:	50                   	push   %eax
  801e1a:	6a 00                	push   $0x0
  801e1c:	56                   	push   %esi
  801e1d:	6a 00                	push   $0x0
  801e1f:	e8 01 f0 ff ff       	call   800e25 <sys_page_map>
  801e24:	89 c3                	mov    %eax,%ebx
  801e26:	83 c4 20             	add    $0x20,%esp
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 4e                	js     801e7b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e35:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e44:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e49:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	ff 75 f4             	push   -0xc(%ebp)
  801e56:	e8 e3 f4 ff ff       	call   80133e <fd2num>
  801e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e60:	83 c4 04             	add    $0x4,%esp
  801e63:	ff 75 f0             	push   -0x10(%ebp)
  801e66:	e8 d3 f4 ff ff       	call   80133e <fd2num>
  801e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e6e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e79:	eb 2e                	jmp    801ea9 <pipe+0x141>
	sys_page_unmap(0, va);
  801e7b:	83 ec 08             	sub    $0x8,%esp
  801e7e:	56                   	push   %esi
  801e7f:	6a 00                	push   $0x0
  801e81:	e8 e1 ef ff ff       	call   800e67 <sys_page_unmap>
  801e86:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e89:	83 ec 08             	sub    $0x8,%esp
  801e8c:	ff 75 f0             	push   -0x10(%ebp)
  801e8f:	6a 00                	push   $0x0
  801e91:	e8 d1 ef ff ff       	call   800e67 <sys_page_unmap>
  801e96:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e99:	83 ec 08             	sub    $0x8,%esp
  801e9c:	ff 75 f4             	push   -0xc(%ebp)
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 c1 ef ff ff       	call   800e67 <sys_page_unmap>
  801ea6:	83 c4 10             	add    $0x10,%esp
}
  801ea9:	89 d8                	mov    %ebx,%eax
  801eab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5e                   	pop    %esi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <pipeisclosed>:
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebb:	50                   	push   %eax
  801ebc:	ff 75 08             	push   0x8(%ebp)
  801ebf:	e8 f1 f4 ff ff       	call   8013b5 <fd_lookup>
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 18                	js     801ee3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	ff 75 f4             	push   -0xc(%ebp)
  801ed1:	e8 78 f4 ff ff       	call   80134e <fd2data>
  801ed6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	e8 33 fd ff ff       	call   801c13 <_pipeisclosed>
  801ee0:	83 c4 10             	add    $0x10,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	c3                   	ret    

00801eeb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ef1:	68 2a 29 80 00       	push   $0x80292a
  801ef6:	ff 75 0c             	push   0xc(%ebp)
  801ef9:	e8 e8 ea ff ff       	call   8009e6 <strcpy>
	return 0;
}
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <devcons_write>:
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	57                   	push   %edi
  801f09:	56                   	push   %esi
  801f0a:	53                   	push   %ebx
  801f0b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f11:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f16:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f1c:	eb 2e                	jmp    801f4c <devcons_write+0x47>
		m = n - tot;
  801f1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f21:	29 f3                	sub    %esi,%ebx
  801f23:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f28:	39 c3                	cmp    %eax,%ebx
  801f2a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	53                   	push   %ebx
  801f31:	89 f0                	mov    %esi,%eax
  801f33:	03 45 0c             	add    0xc(%ebp),%eax
  801f36:	50                   	push   %eax
  801f37:	57                   	push   %edi
  801f38:	e8 3f ec ff ff       	call   800b7c <memmove>
		sys_cputs(buf, m);
  801f3d:	83 c4 08             	add    $0x8,%esp
  801f40:	53                   	push   %ebx
  801f41:	57                   	push   %edi
  801f42:	e8 df ed ff ff       	call   800d26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f47:	01 de                	add    %ebx,%esi
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f4f:	72 cd                	jb     801f1e <devcons_write+0x19>
}
  801f51:	89 f0                	mov    %esi,%eax
  801f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5f                   	pop    %edi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <devcons_read>:
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 08             	sub    $0x8,%esp
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f6a:	75 07                	jne    801f73 <devcons_read+0x18>
  801f6c:	eb 1f                	jmp    801f8d <devcons_read+0x32>
		sys_yield();
  801f6e:	e8 50 ee ff ff       	call   800dc3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f73:	e8 cc ed ff ff       	call   800d44 <sys_cgetc>
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	74 f2                	je     801f6e <devcons_read+0x13>
	if (c < 0)
  801f7c:	78 0f                	js     801f8d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f7e:	83 f8 04             	cmp    $0x4,%eax
  801f81:	74 0c                	je     801f8f <devcons_read+0x34>
	*(char*)vbuf = c;
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	88 02                	mov    %al,(%edx)
	return 1;
  801f88:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    
		return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	eb f7                	jmp    801f8d <devcons_read+0x32>

00801f96 <cputchar>:
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fa2:	6a 01                	push   $0x1
  801fa4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa7:	50                   	push   %eax
  801fa8:	e8 79 ed ff ff       	call   800d26 <sys_cputs>
}
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <getchar>:
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fb8:	6a 01                	push   $0x1
  801fba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fbd:	50                   	push   %eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 54 f6 ff ff       	call   801619 <read>
	if (r < 0)
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 06                	js     801fd2 <getchar+0x20>
	if (r < 1)
  801fcc:	74 06                	je     801fd4 <getchar+0x22>
	return c;
  801fce:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    
		return -E_EOF;
  801fd4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fd9:	eb f7                	jmp    801fd2 <getchar+0x20>

00801fdb <iscons>:
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe4:	50                   	push   %eax
  801fe5:	ff 75 08             	push   0x8(%ebp)
  801fe8:	e8 c8 f3 ff ff       	call   8013b5 <fd_lookup>
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 11                	js     802005 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ffd:	39 10                	cmp    %edx,(%eax)
  801fff:	0f 94 c0             	sete   %al
  802002:	0f b6 c0             	movzbl %al,%eax
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <opencons>:
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80200d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802010:	50                   	push   %eax
  802011:	e8 4f f3 ff ff       	call   801365 <fd_alloc>
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	85 c0                	test   %eax,%eax
  80201b:	78 3a                	js     802057 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	68 07 04 00 00       	push   $0x407
  802025:	ff 75 f4             	push   -0xc(%ebp)
  802028:	6a 00                	push   $0x0
  80202a:	e8 b3 ed ff ff       	call   800de2 <sys_page_alloc>
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	78 21                	js     802057 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	50                   	push   %eax
  80204f:	e8 ea f2 ff ff       	call   80133e <fd2num>
  802054:	83 c4 10             	add    $0x10,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80205f:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802066:	74 20                	je     802088 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	a3 04 60 80 00       	mov    %eax,0x806004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802070:	83 ec 08             	sub    $0x8,%esp
  802073:	68 c8 20 80 00       	push   $0x8020c8
  802078:	6a 00                	push   $0x0
  80207a:	e8 ae ee ff ff       	call   800f2d <sys_env_set_pgfault_upcall>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 2e                	js     8020b4 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802086:	c9                   	leave  
  802087:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	6a 07                	push   $0x7
  80208d:	68 00 f0 bf ee       	push   $0xeebff000
  802092:	6a 00                	push   $0x0
  802094:	e8 49 ed ff ff       	call   800de2 <sys_page_alloc>
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	79 c8                	jns    802068 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 38 29 80 00       	push   $0x802938
  8020a8:	6a 21                	push   $0x21
  8020aa:	68 9b 29 80 00       	push   $0x80299b
  8020af:	e8 92 e1 ff ff       	call   800246 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8020b4:	83 ec 04             	sub    $0x4,%esp
  8020b7:	68 64 29 80 00       	push   $0x802964
  8020bc:	6a 27                	push   $0x27
  8020be:	68 9b 29 80 00       	push   $0x80299b
  8020c3:	e8 7e e1 ff ff       	call   800246 <_panic>

008020c8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020c8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020c9:	a1 04 60 80 00       	mov    0x806004,%eax
	call *%eax
  8020ce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020d0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8020d3:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8020d7:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8020dc:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  8020e0:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  8020e2:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020e5:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8020e6:	83 c4 04             	add    $0x4,%esp
	popfl
  8020e9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020ea:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8020eb:	c3                   	ret    
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <__udivdi3>:
  8020f0:	f3 0f 1e fb          	endbr32 
  8020f4:	55                   	push   %ebp
  8020f5:	57                   	push   %edi
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
  8020f8:	83 ec 1c             	sub    $0x1c,%esp
  8020fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802103:	8b 74 24 34          	mov    0x34(%esp),%esi
  802107:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80210b:	85 c0                	test   %eax,%eax
  80210d:	75 19                	jne    802128 <__udivdi3+0x38>
  80210f:	39 f3                	cmp    %esi,%ebx
  802111:	76 4d                	jbe    802160 <__udivdi3+0x70>
  802113:	31 ff                	xor    %edi,%edi
  802115:	89 e8                	mov    %ebp,%eax
  802117:	89 f2                	mov    %esi,%edx
  802119:	f7 f3                	div    %ebx
  80211b:	89 fa                	mov    %edi,%edx
  80211d:	83 c4 1c             	add    $0x1c,%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5f                   	pop    %edi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
  802125:	8d 76 00             	lea    0x0(%esi),%esi
  802128:	39 f0                	cmp    %esi,%eax
  80212a:	76 14                	jbe    802140 <__udivdi3+0x50>
  80212c:	31 ff                	xor    %edi,%edi
  80212e:	31 c0                	xor    %eax,%eax
  802130:	89 fa                	mov    %edi,%edx
  802132:	83 c4 1c             	add    $0x1c,%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    
  80213a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802140:	0f bd f8             	bsr    %eax,%edi
  802143:	83 f7 1f             	xor    $0x1f,%edi
  802146:	75 48                	jne    802190 <__udivdi3+0xa0>
  802148:	39 f0                	cmp    %esi,%eax
  80214a:	72 06                	jb     802152 <__udivdi3+0x62>
  80214c:	31 c0                	xor    %eax,%eax
  80214e:	39 eb                	cmp    %ebp,%ebx
  802150:	77 de                	ja     802130 <__udivdi3+0x40>
  802152:	b8 01 00 00 00       	mov    $0x1,%eax
  802157:	eb d7                	jmp    802130 <__udivdi3+0x40>
  802159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802160:	89 d9                	mov    %ebx,%ecx
  802162:	85 db                	test   %ebx,%ebx
  802164:	75 0b                	jne    802171 <__udivdi3+0x81>
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f3                	div    %ebx
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	31 d2                	xor    %edx,%edx
  802173:	89 f0                	mov    %esi,%eax
  802175:	f7 f1                	div    %ecx
  802177:	89 c6                	mov    %eax,%esi
  802179:	89 e8                	mov    %ebp,%eax
  80217b:	89 f7                	mov    %esi,%edi
  80217d:	f7 f1                	div    %ecx
  80217f:	89 fa                	mov    %edi,%edx
  802181:	83 c4 1c             	add    $0x1c,%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5f                   	pop    %edi
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 f9                	mov    %edi,%ecx
  802192:	ba 20 00 00 00       	mov    $0x20,%edx
  802197:	29 fa                	sub    %edi,%edx
  802199:	d3 e0                	shl    %cl,%eax
  80219b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219f:	89 d1                	mov    %edx,%ecx
  8021a1:	89 d8                	mov    %ebx,%eax
  8021a3:	d3 e8                	shr    %cl,%eax
  8021a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021a9:	09 c1                	or     %eax,%ecx
  8021ab:	89 f0                	mov    %esi,%eax
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f9                	mov    %edi,%ecx
  8021b3:	d3 e3                	shl    %cl,%ebx
  8021b5:	89 d1                	mov    %edx,%ecx
  8021b7:	d3 e8                	shr    %cl,%eax
  8021b9:	89 f9                	mov    %edi,%ecx
  8021bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021bf:	89 eb                	mov    %ebp,%ebx
  8021c1:	d3 e6                	shl    %cl,%esi
  8021c3:	89 d1                	mov    %edx,%ecx
  8021c5:	d3 eb                	shr    %cl,%ebx
  8021c7:	09 f3                	or     %esi,%ebx
  8021c9:	89 c6                	mov    %eax,%esi
  8021cb:	89 f2                	mov    %esi,%edx
  8021cd:	89 d8                	mov    %ebx,%eax
  8021cf:	f7 74 24 08          	divl   0x8(%esp)
  8021d3:	89 d6                	mov    %edx,%esi
  8021d5:	89 c3                	mov    %eax,%ebx
  8021d7:	f7 64 24 0c          	mull   0xc(%esp)
  8021db:	39 d6                	cmp    %edx,%esi
  8021dd:	72 19                	jb     8021f8 <__udivdi3+0x108>
  8021df:	89 f9                	mov    %edi,%ecx
  8021e1:	d3 e5                	shl    %cl,%ebp
  8021e3:	39 c5                	cmp    %eax,%ebp
  8021e5:	73 04                	jae    8021eb <__udivdi3+0xfb>
  8021e7:	39 d6                	cmp    %edx,%esi
  8021e9:	74 0d                	je     8021f8 <__udivdi3+0x108>
  8021eb:	89 d8                	mov    %ebx,%eax
  8021ed:	31 ff                	xor    %edi,%edi
  8021ef:	e9 3c ff ff ff       	jmp    802130 <__udivdi3+0x40>
  8021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021fb:	31 ff                	xor    %edi,%edi
  8021fd:	e9 2e ff ff ff       	jmp    802130 <__udivdi3+0x40>
  802202:	66 90                	xchg   %ax,%ax
  802204:	66 90                	xchg   %ax,%ax
  802206:	66 90                	xchg   %ax,%ax
  802208:	66 90                	xchg   %ax,%ax
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__umoddi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80221f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802223:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802227:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80222b:	89 f0                	mov    %esi,%eax
  80222d:	89 da                	mov    %ebx,%edx
  80222f:	85 ff                	test   %edi,%edi
  802231:	75 15                	jne    802248 <__umoddi3+0x38>
  802233:	39 dd                	cmp    %ebx,%ebp
  802235:	76 39                	jbe    802270 <__umoddi3+0x60>
  802237:	f7 f5                	div    %ebp
  802239:	89 d0                	mov    %edx,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 df                	cmp    %ebx,%edi
  80224a:	77 f1                	ja     80223d <__umoddi3+0x2d>
  80224c:	0f bd cf             	bsr    %edi,%ecx
  80224f:	83 f1 1f             	xor    $0x1f,%ecx
  802252:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802256:	75 40                	jne    802298 <__umoddi3+0x88>
  802258:	39 df                	cmp    %ebx,%edi
  80225a:	72 04                	jb     802260 <__umoddi3+0x50>
  80225c:	39 f5                	cmp    %esi,%ebp
  80225e:	77 dd                	ja     80223d <__umoddi3+0x2d>
  802260:	89 da                	mov    %ebx,%edx
  802262:	89 f0                	mov    %esi,%eax
  802264:	29 e8                	sub    %ebp,%eax
  802266:	19 fa                	sbb    %edi,%edx
  802268:	eb d3                	jmp    80223d <__umoddi3+0x2d>
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	89 e9                	mov    %ebp,%ecx
  802272:	85 ed                	test   %ebp,%ebp
  802274:	75 0b                	jne    802281 <__umoddi3+0x71>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f5                	div    %ebp
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	89 d8                	mov    %ebx,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f1                	div    %ecx
  802287:	89 f0                	mov    %esi,%eax
  802289:	f7 f1                	div    %ecx
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	31 d2                	xor    %edx,%edx
  80228f:	eb ac                	jmp    80223d <__umoddi3+0x2d>
  802291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802298:	8b 44 24 04          	mov    0x4(%esp),%eax
  80229c:	ba 20 00 00 00       	mov    $0x20,%edx
  8022a1:	29 c2                	sub    %eax,%edx
  8022a3:	89 c1                	mov    %eax,%ecx
  8022a5:	89 e8                	mov    %ebp,%eax
  8022a7:	d3 e7                	shl    %cl,%edi
  8022a9:	89 d1                	mov    %edx,%ecx
  8022ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022af:	d3 e8                	shr    %cl,%eax
  8022b1:	89 c1                	mov    %eax,%ecx
  8022b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022b7:	09 f9                	or     %edi,%ecx
  8022b9:	89 df                	mov    %ebx,%edi
  8022bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	d3 e5                	shl    %cl,%ebp
  8022c3:	89 d1                	mov    %edx,%ecx
  8022c5:	d3 ef                	shr    %cl,%edi
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	89 f0                	mov    %esi,%eax
  8022cb:	d3 e3                	shl    %cl,%ebx
  8022cd:	89 d1                	mov    %edx,%ecx
  8022cf:	89 fa                	mov    %edi,%edx
  8022d1:	d3 e8                	shr    %cl,%eax
  8022d3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022d8:	09 d8                	or     %ebx,%eax
  8022da:	f7 74 24 08          	divl   0x8(%esp)
  8022de:	89 d3                	mov    %edx,%ebx
  8022e0:	d3 e6                	shl    %cl,%esi
  8022e2:	f7 e5                	mul    %ebp
  8022e4:	89 c7                	mov    %eax,%edi
  8022e6:	89 d1                	mov    %edx,%ecx
  8022e8:	39 d3                	cmp    %edx,%ebx
  8022ea:	72 06                	jb     8022f2 <__umoddi3+0xe2>
  8022ec:	75 0e                	jne    8022fc <__umoddi3+0xec>
  8022ee:	39 c6                	cmp    %eax,%esi
  8022f0:	73 0a                	jae    8022fc <__umoddi3+0xec>
  8022f2:	29 e8                	sub    %ebp,%eax
  8022f4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022f8:	89 d1                	mov    %edx,%ecx
  8022fa:	89 c7                	mov    %eax,%edi
  8022fc:	89 f5                	mov    %esi,%ebp
  8022fe:	8b 74 24 04          	mov    0x4(%esp),%esi
  802302:	29 fd                	sub    %edi,%ebp
  802304:	19 cb                	sbb    %ecx,%ebx
  802306:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80230b:	89 d8                	mov    %ebx,%eax
  80230d:	d3 e0                	shl    %cl,%eax
  80230f:	89 f1                	mov    %esi,%ecx
  802311:	d3 ed                	shr    %cl,%ebp
  802313:	d3 eb                	shr    %cl,%ebx
  802315:	09 e8                	or     %ebp,%eax
  802317:	89 da                	mov    %ebx,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
