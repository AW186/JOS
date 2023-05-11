
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 9f 01 00 00       	call   8001d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 20 23 80 00       	push   $0x802320
  800041:	e8 bd 02 00 00       	call   800303 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 e9 1b 00 00       	call   801c3a <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5b                	js     8000b3 <umain+0x80>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 57 10 00 00       	call   8010b4 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 62                	js     8000c5 <umain+0x92>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	74 72                	je     8000d7 <umain+0xa4>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800065:	89 fb                	mov    %edi,%ebx
  800067:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006d:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800070:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800076:	8b 43 54             	mov    0x54(%ebx),%eax
  800079:	83 f8 02             	cmp    $0x2,%eax
  80007c:	0f 85 d1 00 00 00    	jne    800153 <umain+0x120>
		if (pipeisclosed(p[0]) != 0) {
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 75 e0             	push   -0x20(%ebp)
  800088:	e8 f7 1c 00 00       	call   801d84 <pipeisclosed>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	74 e2                	je     800076 <umain+0x43>
			cprintf("\nRACE: pipe appears closed\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 90 23 80 00       	push   $0x802390
  80009c:	e8 62 02 00 00       	call   800303 <cprintf>
			sys_env_destroy(r);
  8000a1:	89 3c 24             	mov    %edi,(%esp)
  8000a4:	e8 9c 0c 00 00       	call   800d45 <sys_env_destroy>
			exit();
  8000a9:	e8 68 01 00 00       	call   800216 <exit>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	eb c3                	jmp    800076 <umain+0x43>
		panic("pipe: %e", r);
  8000b3:	50                   	push   %eax
  8000b4:	68 6e 23 80 00       	push   $0x80236e
  8000b9:	6a 0d                	push   $0xd
  8000bb:	68 77 23 80 00       	push   $0x802377
  8000c0:	e8 63 01 00 00       	call   800228 <_panic>
		panic("fork: %e", r);
  8000c5:	50                   	push   %eax
  8000c6:	68 a5 27 80 00       	push   $0x8027a5
  8000cb:	6a 0f                	push   $0xf
  8000cd:	68 77 23 80 00       	push   $0x802377
  8000d2:	e8 51 01 00 00       	call   800228 <_panic>
		close(p[1]);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	ff 75 e4             	push   -0x1c(%ebp)
  8000dd:	e8 09 13 00 00       	call   8013eb <close>
  8000e2:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e5:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ec:	eb 31                	jmp    80011f <umain+0xec>
			dup(p[0], 10);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	6a 0a                	push   $0xa
  8000f3:	ff 75 e0             	push   -0x20(%ebp)
  8000f6:	e8 42 13 00 00       	call   80143d <dup>
			sys_yield();
  8000fb:	e8 a5 0c 00 00       	call   800da5 <sys_yield>
			close(10);
  800100:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800107:	e8 df 12 00 00       	call   8013eb <close>
			sys_yield();
  80010c:	e8 94 0c 00 00       	call   800da5 <sys_yield>
		for (i = 0; i < 200; i++) {
  800111:	83 c3 01             	add    $0x1,%ebx
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80011d:	74 2a                	je     800149 <umain+0x116>
			if (i % 10 == 0)
  80011f:	89 d8                	mov    %ebx,%eax
  800121:	f7 ee                	imul   %esi
  800123:	c1 fa 02             	sar    $0x2,%edx
  800126:	89 d8                	mov    %ebx,%eax
  800128:	c1 f8 1f             	sar    $0x1f,%eax
  80012b:	29 c2                	sub    %eax,%edx
  80012d:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800130:	01 c0                	add    %eax,%eax
  800132:	39 c3                	cmp    %eax,%ebx
  800134:	75 b8                	jne    8000ee <umain+0xbb>
				cprintf("%d.", i);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	53                   	push   %ebx
  80013a:	68 8c 23 80 00       	push   $0x80238c
  80013f:	e8 bf 01 00 00       	call   800303 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	eb a5                	jmp    8000ee <umain+0xbb>
		exit();
  800149:	e8 c8 00 00 00       	call   800216 <exit>
  80014e:	e9 12 ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 ac 23 80 00       	push   $0x8023ac
  80015b:	e8 a3 01 00 00       	call   800303 <cprintf>
	if (pipeisclosed(p[0]))
  800160:	83 c4 04             	add    $0x4,%esp
  800163:	ff 75 e0             	push   -0x20(%ebp)
  800166:	e8 19 1c 00 00       	call   801d84 <pipeisclosed>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	85 c0                	test   %eax,%eax
  800170:	75 38                	jne    8001aa <umain+0x177>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	ff 75 e0             	push   -0x20(%ebp)
  80017c:	e8 42 11 00 00       	call   8012c3 <fd_lookup>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 36                	js     8001be <umain+0x18b>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 dc             	push   -0x24(%ebp)
  80018e:	e8 c9 10 00 00       	call   80125c <fd2data>
	cprintf("race didn't happen\n");
  800193:	c7 04 24 da 23 80 00 	movl   $0x8023da,(%esp)
  80019a:	e8 64 01 00 00       	call   800303 <cprintf>
}
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 44 23 80 00       	push   $0x802344
  8001b2:	6a 40                	push   $0x40
  8001b4:	68 77 23 80 00       	push   $0x802377
  8001b9:	e8 6a 00 00 00       	call   800228 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001be:	50                   	push   %eax
  8001bf:	68 c2 23 80 00       	push   $0x8023c2
  8001c4:	6a 42                	push   $0x42
  8001c6:	68 77 23 80 00       	push   $0x802377
  8001cb:	e8 58 00 00 00       	call   800228 <_panic>

008001d0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001db:	e8 a6 0b 00 00       	call   800d86 <sys_getenvid>
  8001e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 07                	jle    8001fd <libmain+0x2d>
		binaryname = argv[0];
  8001f6:	8b 06                	mov    (%esi),%eax
  8001f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	56                   	push   %esi
  800201:	53                   	push   %ebx
  800202:	e8 2c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800207:	e8 0a 00 00 00       	call   800216 <exit>
}
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800212:	5b                   	pop    %ebx
  800213:	5e                   	pop    %esi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    

00800216 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80021c:	6a 00                	push   $0x0
  80021e:	e8 22 0b 00 00       	call   800d45 <sys_env_destroy>
}
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800230:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800236:	e8 4b 0b 00 00       	call   800d86 <sys_getenvid>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	ff 75 0c             	push   0xc(%ebp)
  800241:	ff 75 08             	push   0x8(%ebp)
  800244:	56                   	push   %esi
  800245:	50                   	push   %eax
  800246:	68 f8 23 80 00       	push   $0x8023f8
  80024b:	e8 b3 00 00 00       	call   800303 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800250:	83 c4 18             	add    $0x18,%esp
  800253:	53                   	push   %ebx
  800254:	ff 75 10             	push   0x10(%ebp)
  800257:	e8 56 00 00 00       	call   8002b2 <vcprintf>
	cprintf("\n");
  80025c:	c7 04 24 5b 29 80 00 	movl   $0x80295b,(%esp)
  800263:	e8 9b 00 00 00       	call   800303 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026b:	cc                   	int3   
  80026c:	eb fd                	jmp    80026b <_panic+0x43>

0080026e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	53                   	push   %ebx
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800278:	8b 13                	mov    (%ebx),%edx
  80027a:	8d 42 01             	lea    0x1(%edx),%eax
  80027d:	89 03                	mov    %eax,(%ebx)
  80027f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800282:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800286:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028b:	74 09                	je     800296 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80028d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800294:	c9                   	leave  
  800295:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	68 ff 00 00 00       	push   $0xff
  80029e:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a1:	50                   	push   %eax
  8002a2:	e8 61 0a 00 00       	call   800d08 <sys_cputs>
		b->idx = 0;
  8002a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	eb db                	jmp    80028d <putch+0x1f>

008002b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c2:	00 00 00 
	b.cnt = 0;
  8002c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cf:	ff 75 0c             	push   0xc(%ebp)
  8002d2:	ff 75 08             	push   0x8(%ebp)
  8002d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	68 6e 02 80 00       	push   $0x80026e
  8002e1:	e8 14 01 00 00       	call   8003fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e6:	83 c4 08             	add    $0x8,%esp
  8002e9:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8002ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f5:	50                   	push   %eax
  8002f6:	e8 0d 0a 00 00       	call   800d08 <sys_cputs>

	return b.cnt;
}
  8002fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800309:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 08             	push   0x8(%ebp)
  800310:	e8 9d ff ff ff       	call   8002b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	57                   	push   %edi
  80031b:	56                   	push   %esi
  80031c:	53                   	push   %ebx
  80031d:	83 ec 1c             	sub    $0x1c,%esp
  800320:	89 c7                	mov    %eax,%edi
  800322:	89 d6                	mov    %edx,%esi
  800324:	8b 45 08             	mov    0x8(%ebp),%eax
  800327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032a:	89 d1                	mov    %edx,%ecx
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800344:	39 c2                	cmp    %eax,%edx
  800346:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800349:	72 3e                	jb     800389 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 18             	push   0x18(%ebp)
  800351:	83 eb 01             	sub    $0x1,%ebx
  800354:	53                   	push   %ebx
  800355:	50                   	push   %eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	ff 75 e4             	push   -0x1c(%ebp)
  80035c:	ff 75 e0             	push   -0x20(%ebp)
  80035f:	ff 75 dc             	push   -0x24(%ebp)
  800362:	ff 75 d8             	push   -0x28(%ebp)
  800365:	e8 66 1d 00 00       	call   8020d0 <__udivdi3>
  80036a:	83 c4 18             	add    $0x18,%esp
  80036d:	52                   	push   %edx
  80036e:	50                   	push   %eax
  80036f:	89 f2                	mov    %esi,%edx
  800371:	89 f8                	mov    %edi,%eax
  800373:	e8 9f ff ff ff       	call   800317 <printnum>
  800378:	83 c4 20             	add    $0x20,%esp
  80037b:	eb 13                	jmp    800390 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	56                   	push   %esi
  800381:	ff 75 18             	push   0x18(%ebp)
  800384:	ff d7                	call   *%edi
  800386:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800389:	83 eb 01             	sub    $0x1,%ebx
  80038c:	85 db                	test   %ebx,%ebx
  80038e:	7f ed                	jg     80037d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	56                   	push   %esi
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	ff 75 e4             	push   -0x1c(%ebp)
  80039a:	ff 75 e0             	push   -0x20(%ebp)
  80039d:	ff 75 dc             	push   -0x24(%ebp)
  8003a0:	ff 75 d8             	push   -0x28(%ebp)
  8003a3:	e8 48 1e 00 00       	call   8021f0 <__umoddi3>
  8003a8:	83 c4 14             	add    $0x14,%esp
  8003ab:	0f be 80 1b 24 80 00 	movsbl 0x80241b(%eax),%eax
  8003b2:	50                   	push   %eax
  8003b3:	ff d7                	call   *%edi
}
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ca:	8b 10                	mov    (%eax),%edx
  8003cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cf:	73 0a                	jae    8003db <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d4:	89 08                	mov    %ecx,(%eax)
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	88 02                	mov    %al,(%edx)
}
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <printfmt>:
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e6:	50                   	push   %eax
  8003e7:	ff 75 10             	push   0x10(%ebp)
  8003ea:	ff 75 0c             	push   0xc(%ebp)
  8003ed:	ff 75 08             	push   0x8(%ebp)
  8003f0:	e8 05 00 00 00       	call   8003fa <vprintfmt>
}
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <vprintfmt>:
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	83 ec 3c             	sub    $0x3c,%esp
  800403:	8b 75 08             	mov    0x8(%ebp),%esi
  800406:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800409:	8b 7d 10             	mov    0x10(%ebp),%edi
  80040c:	eb 0a                	jmp    800418 <vprintfmt+0x1e>
			putch(ch, putdat);
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	53                   	push   %ebx
  800412:	50                   	push   %eax
  800413:	ff d6                	call   *%esi
  800415:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800418:	83 c7 01             	add    $0x1,%edi
  80041b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80041f:	83 f8 25             	cmp    $0x25,%eax
  800422:	74 0c                	je     800430 <vprintfmt+0x36>
			if (ch == '\0')
  800424:	85 c0                	test   %eax,%eax
  800426:	75 e6                	jne    80040e <vprintfmt+0x14>
}
  800428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042b:	5b                   	pop    %ebx
  80042c:	5e                   	pop    %esi
  80042d:	5f                   	pop    %edi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    
		padc = ' ';
  800430:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800434:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80043b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800442:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800449:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	8d 47 01             	lea    0x1(%edi),%eax
  800451:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800454:	0f b6 17             	movzbl (%edi),%edx
  800457:	8d 42 dd             	lea    -0x23(%edx),%eax
  80045a:	3c 55                	cmp    $0x55,%al
  80045c:	0f 87 a6 04 00 00    	ja     800908 <vprintfmt+0x50e>
  800462:	0f b6 c0             	movzbl %al,%eax
  800465:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  80046c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80046f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800473:	eb d9                	jmp    80044e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800475:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800478:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80047c:	eb d0                	jmp    80044e <vprintfmt+0x54>
  80047e:	0f b6 d2             	movzbl %dl,%edx
  800481:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800484:	b8 00 00 00 00       	mov    $0x0,%eax
  800489:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80048c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80048f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800493:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800496:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800499:	83 f9 09             	cmp    $0x9,%ecx
  80049c:	77 55                	ja     8004f3 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80049e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a1:	eb e9                	jmp    80048c <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8d 40 04             	lea    0x4(%eax),%eax
  8004b1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8004b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004bb:	79 91                	jns    80044e <vprintfmt+0x54>
				width = precision, precision = -1;
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004ca:	eb 82                	jmp    80044e <vprintfmt+0x54>
  8004cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cf:	85 d2                	test   %edx,%edx
  8004d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d6:	0f 49 c2             	cmovns %edx,%eax
  8004d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8004df:	e9 6a ff ff ff       	jmp    80044e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8004e7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004ee:	e9 5b ff ff ff       	jmp    80044e <vprintfmt+0x54>
  8004f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f9:	eb bc                	jmp    8004b7 <vprintfmt+0xbd>
			lflag++;
  8004fb:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800501:	e9 48 ff ff ff       	jmp    80044e <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 78 04             	lea    0x4(%eax),%edi
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	53                   	push   %ebx
  800510:	ff 30                	push   (%eax)
  800512:	ff d6                	call   *%esi
			break;
  800514:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800517:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80051a:	e9 88 03 00 00       	jmp    8008a7 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8d 78 04             	lea    0x4(%eax),%edi
  800525:	8b 10                	mov    (%eax),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	f7 d8                	neg    %eax
  80052b:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052e:	83 f8 0f             	cmp    $0xf,%eax
  800531:	7f 23                	jg     800556 <vprintfmt+0x15c>
  800533:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  80053a:	85 d2                	test   %edx,%edx
  80053c:	74 18                	je     800556 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80053e:	52                   	push   %edx
  80053f:	68 95 28 80 00       	push   $0x802895
  800544:	53                   	push   %ebx
  800545:	56                   	push   %esi
  800546:	e8 92 fe ff ff       	call   8003dd <printfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800551:	e9 51 03 00 00       	jmp    8008a7 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800556:	50                   	push   %eax
  800557:	68 33 24 80 00       	push   $0x802433
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 7a fe ff ff       	call   8003dd <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800569:	e9 39 03 00 00       	jmp    8008a7 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 c0 04             	add    $0x4,%eax
  800574:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80057c:	85 d2                	test   %edx,%edx
  80057e:	b8 2c 24 80 00       	mov    $0x80242c,%eax
  800583:	0f 45 c2             	cmovne %edx,%eax
  800586:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800589:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058d:	7e 06                	jle    800595 <vprintfmt+0x19b>
  80058f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800593:	75 0d                	jne    8005a2 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800595:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800598:	89 c7                	mov    %eax,%edi
  80059a:	03 45 d4             	add    -0x2c(%ebp),%eax
  80059d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005a0:	eb 55                	jmp    8005f7 <vprintfmt+0x1fd>
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	ff 75 e0             	push   -0x20(%ebp)
  8005a8:	ff 75 cc             	push   -0x34(%ebp)
  8005ab:	e8 f5 03 00 00       	call   8009a5 <strnlen>
  8005b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b3:	29 c2                	sub    %eax,%edx
  8005b5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005bd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c4:	eb 0f                	jmp    8005d5 <vprintfmt+0x1db>
					putch(padc, putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	ff 75 d4             	push   -0x2c(%ebp)
  8005cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cf:	83 ef 01             	sub    $0x1,%edi
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	85 ff                	test   %edi,%edi
  8005d7:	7f ed                	jg     8005c6 <vprintfmt+0x1cc>
  8005d9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005dc:	85 d2                	test   %edx,%edx
  8005de:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e3:	0f 49 c2             	cmovns %edx,%eax
  8005e6:	29 c2                	sub    %eax,%edx
  8005e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005eb:	eb a8                	jmp    800595 <vprintfmt+0x19b>
					putch(ch, putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	52                   	push   %edx
  8005f2:	ff d6                	call   *%esi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005fa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fc:	83 c7 01             	add    $0x1,%edi
  8005ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800603:	0f be d0             	movsbl %al,%edx
  800606:	85 d2                	test   %edx,%edx
  800608:	74 4b                	je     800655 <vprintfmt+0x25b>
  80060a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060e:	78 06                	js     800616 <vprintfmt+0x21c>
  800610:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800614:	78 1e                	js     800634 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800616:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061a:	74 d1                	je     8005ed <vprintfmt+0x1f3>
  80061c:	0f be c0             	movsbl %al,%eax
  80061f:	83 e8 20             	sub    $0x20,%eax
  800622:	83 f8 5e             	cmp    $0x5e,%eax
  800625:	76 c6                	jbe    8005ed <vprintfmt+0x1f3>
					putch('?', putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	53                   	push   %ebx
  80062b:	6a 3f                	push   $0x3f
  80062d:	ff d6                	call   *%esi
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	eb c3                	jmp    8005f7 <vprintfmt+0x1fd>
  800634:	89 cf                	mov    %ecx,%edi
  800636:	eb 0e                	jmp    800646 <vprintfmt+0x24c>
				putch(' ', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 20                	push   $0x20
  80063e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800640:	83 ef 01             	sub    $0x1,%edi
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	85 ff                	test   %edi,%edi
  800648:	7f ee                	jg     800638 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80064a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	e9 52 02 00 00       	jmp    8008a7 <vprintfmt+0x4ad>
  800655:	89 cf                	mov    %ecx,%edi
  800657:	eb ed                	jmp    800646 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	83 c0 04             	add    $0x4,%eax
  80065f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800667:	85 d2                	test   %edx,%edx
  800669:	b8 2c 24 80 00       	mov    $0x80242c,%eax
  80066e:	0f 45 c2             	cmovne %edx,%eax
  800671:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800674:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800678:	7e 06                	jle    800680 <vprintfmt+0x286>
  80067a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80067e:	75 0d                	jne    80068d <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800683:	89 c7                	mov    %eax,%edi
  800685:	03 45 d4             	add    -0x2c(%ebp),%eax
  800688:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80068b:	eb 55                	jmp    8006e2 <vprintfmt+0x2e8>
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 e0             	push   -0x20(%ebp)
  800693:	ff 75 cc             	push   -0x34(%ebp)
  800696:	e8 0a 03 00 00       	call   8009a5 <strnlen>
  80069b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069e:	29 c2                	sub    %eax,%edx
  8006a0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006a8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006af:	eb 0f                	jmp    8006c0 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	ff 75 d4             	push   -0x2c(%ebp)
  8006b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	83 ef 01             	sub    $0x1,%edi
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	85 ff                	test   %edi,%edi
  8006c2:	7f ed                	jg     8006b1 <vprintfmt+0x2b7>
  8006c4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006c7:	85 d2                	test   %edx,%edx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c2             	cmovns %edx,%eax
  8006d1:	29 c2                	sub    %eax,%edx
  8006d3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006d6:	eb a8                	jmp    800680 <vprintfmt+0x286>
					putch(ch, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	52                   	push   %edx
  8006dd:	ff d6                	call   *%esi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006e5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8006e7:	83 c7 01             	add    $0x1,%edi
  8006ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ee:	0f be d0             	movsbl %al,%edx
  8006f1:	3c 3a                	cmp    $0x3a,%al
  8006f3:	74 4b                	je     800740 <vprintfmt+0x346>
  8006f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f9:	78 06                	js     800701 <vprintfmt+0x307>
  8006fb:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8006ff:	78 1e                	js     80071f <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800701:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800705:	74 d1                	je     8006d8 <vprintfmt+0x2de>
  800707:	0f be c0             	movsbl %al,%eax
  80070a:	83 e8 20             	sub    $0x20,%eax
  80070d:	83 f8 5e             	cmp    $0x5e,%eax
  800710:	76 c6                	jbe    8006d8 <vprintfmt+0x2de>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 3f                	push   $0x3f
  800718:	ff d6                	call   *%esi
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb c3                	jmp    8006e2 <vprintfmt+0x2e8>
  80071f:	89 cf                	mov    %ecx,%edi
  800721:	eb 0e                	jmp    800731 <vprintfmt+0x337>
				putch(' ', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 20                	push   $0x20
  800729:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072b:	83 ef 01             	sub    $0x1,%edi
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	85 ff                	test   %edi,%edi
  800733:	7f ee                	jg     800723 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800735:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
  80073b:	e9 67 01 00 00       	jmp    8008a7 <vprintfmt+0x4ad>
  800740:	89 cf                	mov    %ecx,%edi
  800742:	eb ed                	jmp    800731 <vprintfmt+0x337>
	if (lflag >= 2)
  800744:	83 f9 01             	cmp    $0x1,%ecx
  800747:	7f 1b                	jg     800764 <vprintfmt+0x36a>
	else if (lflag)
  800749:	85 c9                	test   %ecx,%ecx
  80074b:	74 63                	je     8007b0 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800755:	99                   	cltd   
  800756:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	eb 17                	jmp    80077b <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80077b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800781:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800786:	85 c9                	test   %ecx,%ecx
  800788:	0f 89 ff 00 00 00    	jns    80088d <vprintfmt+0x493>
				putch('-', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 2d                	push   $0x2d
  800794:	ff d6                	call   *%esi
				num = -(long long) num;
  800796:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800799:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80079c:	f7 da                	neg    %edx
  80079e:	83 d1 00             	adc    $0x0,%ecx
  8007a1:	f7 d9                	neg    %ecx
  8007a3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007ab:	e9 dd 00 00 00       	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, int);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b8:	99                   	cltd   
  8007b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 04             	lea    0x4(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	eb b4                	jmp    80077b <vprintfmt+0x381>
	if (lflag >= 2)
  8007c7:	83 f9 01             	cmp    $0x1,%ecx
  8007ca:	7f 1e                	jg     8007ea <vprintfmt+0x3f0>
	else if (lflag)
  8007cc:	85 c9                	test   %ecx,%ecx
  8007ce:	74 32                	je     800802 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 10                	mov    (%eax),%edx
  8007d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e0:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8007e5:	e9 a3 00 00 00       	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 10                	mov    (%eax),%edx
  8007ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f8:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8007fd:	e9 8b 00 00 00       	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 10                	mov    (%eax),%edx
  800807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800812:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800817:	eb 74                	jmp    80088d <vprintfmt+0x493>
	if (lflag >= 2)
  800819:	83 f9 01             	cmp    $0x1,%ecx
  80081c:	7f 1b                	jg     800839 <vprintfmt+0x43f>
	else if (lflag)
  80081e:	85 c9                	test   %ecx,%ecx
  800820:	74 2c                	je     80084e <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 10                	mov    (%eax),%edx
  800827:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082c:	8d 40 04             	lea    0x4(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800832:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800837:	eb 54                	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 10                	mov    (%eax),%edx
  80083e:	8b 48 04             	mov    0x4(%eax),%ecx
  800841:	8d 40 08             	lea    0x8(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800847:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80084c:	eb 3f                	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 10                	mov    (%eax),%edx
  800853:	b9 00 00 00 00       	mov    $0x0,%ecx
  800858:	8d 40 04             	lea    0x4(%eax),%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085e:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800863:	eb 28                	jmp    80088d <vprintfmt+0x493>
			putch('0', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 30                	push   $0x30
  80086b:	ff d6                	call   *%esi
			putch('x', putdat);
  80086d:	83 c4 08             	add    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	6a 78                	push   $0x78
  800873:	ff d6                	call   *%esi
			num = (unsigned long long)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 10                	mov    (%eax),%edx
  80087a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80087f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800888:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80088d:	83 ec 0c             	sub    $0xc,%esp
  800890:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800894:	50                   	push   %eax
  800895:	ff 75 d4             	push   -0x2c(%ebp)
  800898:	57                   	push   %edi
  800899:	51                   	push   %ecx
  80089a:	52                   	push   %edx
  80089b:	89 da                	mov    %ebx,%edx
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	e8 73 fa ff ff       	call   800317 <printnum>
			break;
  8008a4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a7:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008aa:	e9 69 fb ff ff       	jmp    800418 <vprintfmt+0x1e>
	if (lflag >= 2)
  8008af:	83 f9 01             	cmp    $0x1,%ecx
  8008b2:	7f 1b                	jg     8008cf <vprintfmt+0x4d5>
	else if (lflag)
  8008b4:	85 c9                	test   %ecx,%ecx
  8008b6:	74 2c                	je     8008e4 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8b 10                	mov    (%eax),%edx
  8008bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c2:	8d 40 04             	lea    0x4(%eax),%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8008cd:	eb be                	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8b 10                	mov    (%eax),%edx
  8008d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d7:	8d 40 08             	lea    0x8(%eax),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008dd:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8008e2:	eb a9                	jmp    80088d <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	8b 10                	mov    (%eax),%edx
  8008e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ee:	8d 40 04             	lea    0x4(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f4:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8008f9:	eb 92                	jmp    80088d <vprintfmt+0x493>
			putch(ch, putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	6a 25                	push   $0x25
  800901:	ff d6                	call   *%esi
			break;
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	eb 9f                	jmp    8008a7 <vprintfmt+0x4ad>
			putch('%', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	6a 25                	push   $0x25
  80090e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	89 f8                	mov    %edi,%eax
  800915:	eb 03                	jmp    80091a <vprintfmt+0x520>
  800917:	83 e8 01             	sub    $0x1,%eax
  80091a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80091e:	75 f7                	jne    800917 <vprintfmt+0x51d>
  800920:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800923:	eb 82                	jmp    8008a7 <vprintfmt+0x4ad>

00800925 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 18             	sub    $0x18,%esp
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800931:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800934:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800938:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800942:	85 c0                	test   %eax,%eax
  800944:	74 26                	je     80096c <vsnprintf+0x47>
  800946:	85 d2                	test   %edx,%edx
  800948:	7e 22                	jle    80096c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094a:	ff 75 14             	push   0x14(%ebp)
  80094d:	ff 75 10             	push   0x10(%ebp)
  800950:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c0 03 80 00       	push   $0x8003c0
  800959:	e8 9c fa ff ff       	call   8003fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800961:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800967:	83 c4 10             	add    $0x10,%esp
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    
		return -E_INVAL;
  80096c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800971:	eb f7                	jmp    80096a <vsnprintf+0x45>

00800973 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800979:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80097c:	50                   	push   %eax
  80097d:	ff 75 10             	push   0x10(%ebp)
  800980:	ff 75 0c             	push   0xc(%ebp)
  800983:	ff 75 08             	push   0x8(%ebp)
  800986:	e8 9a ff ff ff       	call   800925 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
  800998:	eb 03                	jmp    80099d <strlen+0x10>
		n++;
  80099a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80099d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a1:	75 f7                	jne    80099a <strlen+0xd>
	return n;
}
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	eb 03                	jmp    8009b8 <strnlen+0x13>
		n++;
  8009b5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b8:	39 d0                	cmp    %edx,%eax
  8009ba:	74 08                	je     8009c4 <strnlen+0x1f>
  8009bc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009c0:	75 f3                	jne    8009b5 <strnlen+0x10>
  8009c2:	89 c2                	mov    %eax,%edx
	return n;
}
  8009c4:	89 d0                	mov    %edx,%eax
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	53                   	push   %ebx
  8009cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009db:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	75 f2                	jne    8009d7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e5:	89 c8                	mov    %ecx,%eax
  8009e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	53                   	push   %ebx
  8009f0:	83 ec 10             	sub    $0x10,%esp
  8009f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f6:	53                   	push   %ebx
  8009f7:	e8 91 ff ff ff       	call   80098d <strlen>
  8009fc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009ff:	ff 75 0c             	push   0xc(%ebp)
  800a02:	01 d8                	add    %ebx,%eax
  800a04:	50                   	push   %eax
  800a05:	e8 be ff ff ff       	call   8009c8 <strcpy>
	return dst;
}
  800a0a:	89 d8                	mov    %ebx,%eax
  800a0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	8b 75 08             	mov    0x8(%ebp),%esi
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 f3                	mov    %esi,%ebx
  800a1e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a21:	89 f0                	mov    %esi,%eax
  800a23:	eb 0f                	jmp    800a34 <strncpy+0x23>
		*dst++ = *src;
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	0f b6 0a             	movzbl (%edx),%ecx
  800a2b:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a2e:	80 f9 01             	cmp    $0x1,%cl
  800a31:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800a34:	39 d8                	cmp    %ebx,%eax
  800a36:	75 ed                	jne    800a25 <strncpy+0x14>
	}
	return ret;
}
  800a38:	89 f0                	mov    %esi,%eax
  800a3a:	5b                   	pop    %ebx
  800a3b:	5e                   	pop    %esi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	56                   	push   %esi
  800a42:	53                   	push   %ebx
  800a43:	8b 75 08             	mov    0x8(%ebp),%esi
  800a46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a49:	8b 55 10             	mov    0x10(%ebp),%edx
  800a4c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a4e:	85 d2                	test   %edx,%edx
  800a50:	74 21                	je     800a73 <strlcpy+0x35>
  800a52:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a56:	89 f2                	mov    %esi,%edx
  800a58:	eb 09                	jmp    800a63 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800a63:	39 c2                	cmp    %eax,%edx
  800a65:	74 09                	je     800a70 <strlcpy+0x32>
  800a67:	0f b6 19             	movzbl (%ecx),%ebx
  800a6a:	84 db                	test   %bl,%bl
  800a6c:	75 ec                	jne    800a5a <strlcpy+0x1c>
  800a6e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a73:	29 f0                	sub    %esi,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a82:	eb 06                	jmp    800a8a <strcmp+0x11>
		p++, q++;
  800a84:	83 c1 01             	add    $0x1,%ecx
  800a87:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a8a:	0f b6 01             	movzbl (%ecx),%eax
  800a8d:	84 c0                	test   %al,%al
  800a8f:	74 04                	je     800a95 <strcmp+0x1c>
  800a91:	3a 02                	cmp    (%edx),%al
  800a93:	74 ef                	je     800a84 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a95:	0f b6 c0             	movzbl %al,%eax
  800a98:	0f b6 12             	movzbl (%edx),%edx
  800a9b:	29 d0                	sub    %edx,%eax
}
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa9:	89 c3                	mov    %eax,%ebx
  800aab:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aae:	eb 06                	jmp    800ab6 <strncmp+0x17>
		n--, p++, q++;
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ab6:	39 d8                	cmp    %ebx,%eax
  800ab8:	74 18                	je     800ad2 <strncmp+0x33>
  800aba:	0f b6 08             	movzbl (%eax),%ecx
  800abd:	84 c9                	test   %cl,%cl
  800abf:	74 04                	je     800ac5 <strncmp+0x26>
  800ac1:	3a 0a                	cmp    (%edx),%cl
  800ac3:	74 eb                	je     800ab0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac5:	0f b6 00             	movzbl (%eax),%eax
  800ac8:	0f b6 12             	movzbl (%edx),%edx
  800acb:	29 d0                	sub    %edx,%eax
}
  800acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    
		return 0;
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	eb f4                	jmp    800acd <strncmp+0x2e>

00800ad9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae3:	eb 03                	jmp    800ae8 <strchr+0xf>
  800ae5:	83 c0 01             	add    $0x1,%eax
  800ae8:	0f b6 10             	movzbl (%eax),%edx
  800aeb:	84 d2                	test   %dl,%dl
  800aed:	74 06                	je     800af5 <strchr+0x1c>
		if (*s == c)
  800aef:	38 ca                	cmp    %cl,%dl
  800af1:	75 f2                	jne    800ae5 <strchr+0xc>
  800af3:	eb 05                	jmp    800afa <strchr+0x21>
			return (char *) s;
	return 0;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b06:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b09:	38 ca                	cmp    %cl,%dl
  800b0b:	74 09                	je     800b16 <strfind+0x1a>
  800b0d:	84 d2                	test   %dl,%dl
  800b0f:	74 05                	je     800b16 <strfind+0x1a>
	for (; *s; s++)
  800b11:	83 c0 01             	add    $0x1,%eax
  800b14:	eb f0                	jmp    800b06 <strfind+0xa>
			break;
	return (char *) s;
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b24:	85 c9                	test   %ecx,%ecx
  800b26:	74 2f                	je     800b57 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b28:	89 f8                	mov    %edi,%eax
  800b2a:	09 c8                	or     %ecx,%eax
  800b2c:	a8 03                	test   $0x3,%al
  800b2e:	75 21                	jne    800b51 <memset+0x39>
		c &= 0xFF;
  800b30:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	c1 e0 08             	shl    $0x8,%eax
  800b39:	89 d3                	mov    %edx,%ebx
  800b3b:	c1 e3 18             	shl    $0x18,%ebx
  800b3e:	89 d6                	mov    %edx,%esi
  800b40:	c1 e6 10             	shl    $0x10,%esi
  800b43:	09 f3                	or     %esi,%ebx
  800b45:	09 da                	or     %ebx,%edx
  800b47:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b49:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b4c:	fc                   	cld    
  800b4d:	f3 ab                	rep stos %eax,%es:(%edi)
  800b4f:	eb 06                	jmp    800b57 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	fc                   	cld    
  800b55:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b57:	89 f8                	mov    %edi,%eax
  800b59:	5b                   	pop    %ebx
  800b5a:	5e                   	pop    %esi
  800b5b:	5f                   	pop    %edi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	57                   	push   %edi
  800b62:	56                   	push   %esi
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b69:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b6c:	39 c6                	cmp    %eax,%esi
  800b6e:	73 32                	jae    800ba2 <memmove+0x44>
  800b70:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b73:	39 c2                	cmp    %eax,%edx
  800b75:	76 2b                	jbe    800ba2 <memmove+0x44>
		s += n;
		d += n;
  800b77:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	09 fe                	or     %edi,%esi
  800b7e:	09 ce                	or     %ecx,%esi
  800b80:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b86:	75 0e                	jne    800b96 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b88:	83 ef 04             	sub    $0x4,%edi
  800b8b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b8e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b91:	fd                   	std    
  800b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b94:	eb 09                	jmp    800b9f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b96:	83 ef 01             	sub    $0x1,%edi
  800b99:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b9c:	fd                   	std    
  800b9d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b9f:	fc                   	cld    
  800ba0:	eb 1a                	jmp    800bbc <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba2:	89 f2                	mov    %esi,%edx
  800ba4:	09 c2                	or     %eax,%edx
  800ba6:	09 ca                	or     %ecx,%edx
  800ba8:	f6 c2 03             	test   $0x3,%dl
  800bab:	75 0a                	jne    800bb7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bad:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bb0:	89 c7                	mov    %eax,%edi
  800bb2:	fc                   	cld    
  800bb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb5:	eb 05                	jmp    800bbc <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bb7:	89 c7                	mov    %eax,%edi
  800bb9:	fc                   	cld    
  800bba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bbc:	5e                   	pop    %esi
  800bbd:	5f                   	pop    %edi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc6:	ff 75 10             	push   0x10(%ebp)
  800bc9:	ff 75 0c             	push   0xc(%ebp)
  800bcc:	ff 75 08             	push   0x8(%ebp)
  800bcf:	e8 8a ff ff ff       	call   800b5e <memmove>
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be1:	89 c6                	mov    %eax,%esi
  800be3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be6:	eb 06                	jmp    800bee <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be8:	83 c0 01             	add    $0x1,%eax
  800beb:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800bee:	39 f0                	cmp    %esi,%eax
  800bf0:	74 14                	je     800c06 <memcmp+0x30>
		if (*s1 != *s2)
  800bf2:	0f b6 08             	movzbl (%eax),%ecx
  800bf5:	0f b6 1a             	movzbl (%edx),%ebx
  800bf8:	38 d9                	cmp    %bl,%cl
  800bfa:	74 ec                	je     800be8 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800bfc:	0f b6 c1             	movzbl %cl,%eax
  800bff:	0f b6 db             	movzbl %bl,%ebx
  800c02:	29 d8                	sub    %ebx,%eax
  800c04:	eb 05                	jmp    800c0b <memcmp+0x35>
	}

	return 0;
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c1d:	eb 03                	jmp    800c22 <memfind+0x13>
  800c1f:	83 c0 01             	add    $0x1,%eax
  800c22:	39 d0                	cmp    %edx,%eax
  800c24:	73 04                	jae    800c2a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c26:	38 08                	cmp    %cl,(%eax)
  800c28:	75 f5                	jne    800c1f <memfind+0x10>
			break;
	return (void *) s;
}
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	8b 55 08             	mov    0x8(%ebp),%edx
  800c35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c38:	eb 03                	jmp    800c3d <strtol+0x11>
		s++;
  800c3a:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800c3d:	0f b6 02             	movzbl (%edx),%eax
  800c40:	3c 20                	cmp    $0x20,%al
  800c42:	74 f6                	je     800c3a <strtol+0xe>
  800c44:	3c 09                	cmp    $0x9,%al
  800c46:	74 f2                	je     800c3a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c48:	3c 2b                	cmp    $0x2b,%al
  800c4a:	74 2a                	je     800c76 <strtol+0x4a>
	int neg = 0;
  800c4c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c51:	3c 2d                	cmp    $0x2d,%al
  800c53:	74 2b                	je     800c80 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c55:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c5b:	75 0f                	jne    800c6c <strtol+0x40>
  800c5d:	80 3a 30             	cmpb   $0x30,(%edx)
  800c60:	74 28                	je     800c8a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c62:	85 db                	test   %ebx,%ebx
  800c64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c69:	0f 44 d8             	cmove  %eax,%ebx
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c74:	eb 46                	jmp    800cbc <strtol+0x90>
		s++;
  800c76:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800c79:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7e:	eb d5                	jmp    800c55 <strtol+0x29>
		s++, neg = 1;
  800c80:	83 c2 01             	add    $0x1,%edx
  800c83:	bf 01 00 00 00       	mov    $0x1,%edi
  800c88:	eb cb                	jmp    800c55 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8a:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c8e:	74 0e                	je     800c9e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c90:	85 db                	test   %ebx,%ebx
  800c92:	75 d8                	jne    800c6c <strtol+0x40>
		s++, base = 8;
  800c94:	83 c2 01             	add    $0x1,%edx
  800c97:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9c:	eb ce                	jmp    800c6c <strtol+0x40>
		s += 2, base = 16;
  800c9e:	83 c2 02             	add    $0x2,%edx
  800ca1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca6:	eb c4                	jmp    800c6c <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca8:	0f be c0             	movsbl %al,%eax
  800cab:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cae:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb1:	7d 3a                	jge    800ced <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cb3:	83 c2 01             	add    $0x1,%edx
  800cb6:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800cba:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800cbc:	0f b6 02             	movzbl (%edx),%eax
  800cbf:	8d 70 d0             	lea    -0x30(%eax),%esi
  800cc2:	89 f3                	mov    %esi,%ebx
  800cc4:	80 fb 09             	cmp    $0x9,%bl
  800cc7:	76 df                	jbe    800ca8 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800cc9:	8d 70 9f             	lea    -0x61(%eax),%esi
  800ccc:	89 f3                	mov    %esi,%ebx
  800cce:	80 fb 19             	cmp    $0x19,%bl
  800cd1:	77 08                	ja     800cdb <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cd3:	0f be c0             	movsbl %al,%eax
  800cd6:	83 e8 57             	sub    $0x57,%eax
  800cd9:	eb d3                	jmp    800cae <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800cdb:	8d 70 bf             	lea    -0x41(%eax),%esi
  800cde:	89 f3                	mov    %esi,%ebx
  800ce0:	80 fb 19             	cmp    $0x19,%bl
  800ce3:	77 08                	ja     800ced <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ce5:	0f be c0             	movsbl %al,%eax
  800ce8:	83 e8 37             	sub    $0x37,%eax
  800ceb:	eb c1                	jmp    800cae <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf1:	74 05                	je     800cf8 <strtol+0xcc>
		*endptr = (char *) s;
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cf8:	89 c8                	mov    %ecx,%eax
  800cfa:	f7 d8                	neg    %eax
  800cfc:	85 ff                	test   %edi,%edi
  800cfe:	0f 45 c8             	cmovne %eax,%ecx
}
  800d01:	89 c8                	mov    %ecx,%eax
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	89 c6                	mov    %eax,%esi
  800d1f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d31:	b8 01 00 00 00       	mov    $0x1,%eax
  800d36:	89 d1                	mov    %edx,%ecx
  800d38:	89 d3                	mov    %edx,%ebx
  800d3a:	89 d7                	mov    %edx,%edi
  800d3c:	89 d6                	mov    %edx,%esi
  800d3e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	b8 03 00 00 00       	mov    $0x3,%eax
  800d5b:	89 cb                	mov    %ecx,%ebx
  800d5d:	89 cf                	mov    %ecx,%edi
  800d5f:	89 ce                	mov    %ecx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 03                	push   $0x3
  800d75:	68 1f 27 80 00       	push   $0x80271f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 3c 27 80 00       	push   $0x80273c
  800d81:	e8 a2 f4 ff ff       	call   800228 <_panic>

00800d86 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d91:	b8 02 00 00 00       	mov    $0x2,%eax
  800d96:	89 d1                	mov    %edx,%ecx
  800d98:	89 d3                	mov    %edx,%ebx
  800d9a:	89 d7                	mov    %edx,%edi
  800d9c:	89 d6                	mov    %edx,%esi
  800d9e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_yield>:

void
sys_yield(void)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dab:	ba 00 00 00 00       	mov    $0x0,%edx
  800db0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db5:	89 d1                	mov    %edx,%ecx
  800db7:	89 d3                	mov    %edx,%ebx
  800db9:	89 d7                	mov    %edx,%edi
  800dbb:	89 d6                	mov    %edx,%esi
  800dbd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5f                   	pop    %edi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	be 00 00 00 00       	mov    $0x0,%esi
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ddd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de0:	89 f7                	mov    %esi,%edi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 04                	push   $0x4
  800df6:	68 1f 27 80 00       	push   $0x80271f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 3c 27 80 00       	push   $0x80273c
  800e02:	e8 21 f4 ff ff       	call   800228 <_panic>

00800e07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	b8 05 00 00 00       	mov    $0x5,%eax
  800e1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e21:	8b 75 18             	mov    0x18(%ebp),%esi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 05                	push   $0x5
  800e38:	68 1f 27 80 00       	push   $0x80271f
  800e3d:	6a 23                	push   $0x23
  800e3f:	68 3c 27 80 00       	push   $0x80273c
  800e44:	e8 df f3 ff ff       	call   800228 <_panic>

00800e49 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e62:	89 df                	mov    %ebx,%edi
  800e64:	89 de                	mov    %ebx,%esi
  800e66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 06                	push   $0x6
  800e7a:	68 1f 27 80 00       	push   $0x80271f
  800e7f:	6a 23                	push   $0x23
  800e81:	68 3c 27 80 00       	push   $0x80273c
  800e86:	e8 9d f3 ff ff       	call   800228 <_panic>

00800e8b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 08                	push   $0x8
  800ebc:	68 1f 27 80 00       	push   $0x80271f
  800ec1:	6a 23                	push   $0x23
  800ec3:	68 3c 27 80 00       	push   $0x80273c
  800ec8:	e8 5b f3 ff ff       	call   800228 <_panic>

00800ecd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 09                	push   $0x9
  800efe:	68 1f 27 80 00       	push   $0x80271f
  800f03:	6a 23                	push   $0x23
  800f05:	68 3c 27 80 00       	push   $0x80273c
  800f0a:	e8 19 f3 ff ff       	call   800228 <_panic>

00800f0f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 0a                	push   $0xa
  800f40:	68 1f 27 80 00       	push   $0x80271f
  800f45:	6a 23                	push   $0x23
  800f47:	68 3c 27 80 00       	push   $0x80273c
  800f4c:	e8 d7 f2 ff ff       	call   800228 <_panic>

00800f51 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f62:	be 00 00 00 00       	mov    $0x0,%esi
  800f67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f6d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
  800f7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8a:	89 cb                	mov    %ecx,%ebx
  800f8c:	89 cf                	mov    %ecx,%edi
  800f8e:	89 ce                	mov    %ecx,%esi
  800f90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7f 08                	jg     800f9e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800fa2:	6a 0d                	push   $0xd
  800fa4:	68 1f 27 80 00       	push   $0x80271f
  800fa9:	6a 23                	push   $0x23
  800fab:	68 3c 27 80 00       	push   $0x80273c
  800fb0:	e8 73 f2 ff ff       	call   800228 <_panic>

00800fb5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fbf:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  800fc1:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fc5:	0f 84 99 00 00 00    	je     801064 <pgfault+0xaf>
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	c1 e8 16             	shr    $0x16,%eax
  800fd0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd7:	a8 01                	test   $0x1,%al
  800fd9:	0f 84 85 00 00 00    	je     801064 <pgfault+0xaf>
  800fdf:	89 d8                	mov    %ebx,%eax
  800fe1:	c1 e8 0c             	shr    $0xc,%eax
  800fe4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800feb:	f6 c6 08             	test   $0x8,%dh
  800fee:	74 74                	je     801064 <pgfault+0xaf>
  800ff0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff7:	a8 01                	test   $0x1,%al
  800ff9:	74 69                	je     801064 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	6a 07                	push   $0x7
  801000:	68 00 f0 7f 00       	push   $0x7ff000
  801005:	6a 00                	push   $0x0
  801007:	e8 b8 fd ff ff       	call   800dc4 <sys_page_alloc>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	78 65                	js     801078 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801013:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	68 00 10 00 00       	push   $0x1000
  801021:	53                   	push   %ebx
  801022:	68 00 f0 7f 00       	push   $0x7ff000
  801027:	e8 94 fb ff ff       	call   800bc0 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  80102c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801033:	53                   	push   %ebx
  801034:	6a 00                	push   $0x0
  801036:	68 00 f0 7f 00       	push   $0x7ff000
  80103b:	6a 00                	push   $0x0
  80103d:	e8 c5 fd ff ff       	call   800e07 <sys_page_map>
  801042:	83 c4 20             	add    $0x20,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	78 43                	js     80108c <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	68 00 f0 7f 00       	push   $0x7ff000
  801051:	6a 00                	push   $0x0
  801053:	e8 f1 fd ff ff       	call   800e49 <sys_page_unmap>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	85 c0                	test   %eax,%eax
  80105d:	78 41                	js     8010a0 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  80105f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801062:	c9                   	leave  
  801063:	c3                   	ret    
		panic("invalid permision\n");
  801064:	83 ec 04             	sub    $0x4,%esp
  801067:	68 4a 27 80 00       	push   $0x80274a
  80106c:	6a 1f                	push   $0x1f
  80106e:	68 5d 27 80 00       	push   $0x80275d
  801073:	e8 b0 f1 ff ff       	call   800228 <_panic>
		panic("Unable to alloc page\n");
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	68 68 27 80 00       	push   $0x802768
  801080:	6a 28                	push   $0x28
  801082:	68 5d 27 80 00       	push   $0x80275d
  801087:	e8 9c f1 ff ff       	call   800228 <_panic>
		panic("Unable to map\n");
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	68 7e 27 80 00       	push   $0x80277e
  801094:	6a 2b                	push   $0x2b
  801096:	68 5d 27 80 00       	push   $0x80275d
  80109b:	e8 88 f1 ff ff       	call   800228 <_panic>
		panic("Unable to unmap\n");
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	68 8d 27 80 00       	push   $0x80278d
  8010a8:	6a 2d                	push   $0x2d
  8010aa:	68 5d 27 80 00       	push   $0x80275d
  8010af:	e8 74 f1 ff ff       	call   800228 <_panic>

008010b4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	57                   	push   %edi
  8010b8:	56                   	push   %esi
  8010b9:	53                   	push   %ebx
  8010ba:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  8010bd:	68 b5 0f 80 00       	push   $0x800fb5
  8010c2:	e8 64 0e 00 00       	call   801f2b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010c7:	b8 07 00 00 00       	mov    $0x7,%eax
  8010cc:	cd 30                	int    $0x30
  8010ce:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	78 23                	js     8010fa <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8010d7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  8010dc:	75 6d                	jne    80114b <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010de:	e8 a3 fc ff ff       	call   800d86 <sys_getenvid>
  8010e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010f0:	a3 00 40 80 00       	mov    %eax,0x804000
		return 0;
  8010f5:	e9 02 01 00 00       	jmp    8011fc <fork+0x148>
		panic("sys_exofork: %e", envid);
  8010fa:	50                   	push   %eax
  8010fb:	68 9e 27 80 00       	push   $0x80279e
  801100:	6a 6d                	push   $0x6d
  801102:	68 5d 27 80 00       	push   $0x80275d
  801107:	e8 1c f1 ff ff       	call   800228 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80110c:	c1 e0 0c             	shl    $0xc,%eax
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801118:	52                   	push   %edx
  801119:	50                   	push   %eax
  80111a:	56                   	push   %esi
  80111b:	50                   	push   %eax
  80111c:	6a 00                	push   $0x0
  80111e:	e8 e4 fc ff ff       	call   800e07 <sys_page_map>
  801123:	83 c4 20             	add    $0x20,%esp
  801126:	eb 15                	jmp    80113d <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  801128:	c1 e0 0c             	shl    $0xc,%eax
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	6a 05                	push   $0x5
  801130:	50                   	push   %eax
  801131:	56                   	push   %esi
  801132:	50                   	push   %eax
  801133:	6a 00                	push   $0x0
  801135:	e8 cd fc ff ff       	call   800e07 <sys_page_map>
  80113a:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80113d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801143:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801149:	74 7a                	je     8011c5 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	c1 e8 16             	shr    $0x16,%eax
  801150:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801157:	a8 01                	test   $0x1,%al
  801159:	74 e2                	je     80113d <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	c1 e8 0c             	shr    $0xc,%eax
  801160:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801167:	f6 c2 01             	test   $0x1,%dl
  80116a:	74 d1                	je     80113d <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80116c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801173:	f6 c2 04             	test   $0x4,%dl
  801176:	74 c5                	je     80113d <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801178:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80117f:	f6 c6 04             	test   $0x4,%dh
  801182:	75 88                	jne    80110c <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801184:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80118a:	74 9c                	je     801128 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80118c:	c1 e0 0c             	shl    $0xc,%eax
  80118f:	89 c7                	mov    %eax,%edi
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	68 05 08 00 00       	push   $0x805
  801199:	50                   	push   %eax
  80119a:	56                   	push   %esi
  80119b:	50                   	push   %eax
  80119c:	6a 00                	push   $0x0
  80119e:	e8 64 fc ff ff       	call   800e07 <sys_page_map>
  8011a3:	83 c4 20             	add    $0x20,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 93                	js     80113d <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	68 05 08 00 00       	push   $0x805
  8011b2:	57                   	push   %edi
  8011b3:	6a 00                	push   $0x0
  8011b5:	57                   	push   %edi
  8011b6:	6a 00                	push   $0x0
  8011b8:	e8 4a fc ff ff       	call   800e07 <sys_page_map>
  8011bd:	83 c4 20             	add    $0x20,%esp
  8011c0:	e9 78 ff ff ff       	jmp    80113d <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	6a 07                	push   $0x7
  8011ca:	68 00 f0 bf ee       	push   $0xeebff000
  8011cf:	56                   	push   %esi
  8011d0:	e8 ef fb ff ff       	call   800dc4 <sys_page_alloc>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 2a                	js     801206 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	68 9a 1f 80 00       	push   $0x801f9a
  8011e4:	56                   	push   %esi
  8011e5:	e8 25 fd ff ff       	call   800f0f <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011ea:	83 c4 08             	add    $0x8,%esp
  8011ed:	6a 02                	push   $0x2
  8011ef:	56                   	push   %esi
  8011f0:	e8 96 fc ff ff       	call   800e8b <sys_env_set_status>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 21                	js     80121d <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011fc:	89 f0                	mov    %esi,%eax
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
		panic("failed to alloc page");
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 ae 27 80 00       	push   $0x8027ae
  80120e:	68 82 00 00 00       	push   $0x82
  801213:	68 5d 27 80 00       	push   $0x80275d
  801218:	e8 0b f0 ff ff       	call   800228 <_panic>
		panic("sys_env_set_status: %e", r);
  80121d:	50                   	push   %eax
  80121e:	68 c3 27 80 00       	push   $0x8027c3
  801223:	68 89 00 00 00       	push   $0x89
  801228:	68 5d 27 80 00       	push   $0x80275d
  80122d:	e8 f6 ef ff ff       	call   800228 <_panic>

00801232 <sfork>:

// Challenge!
int
sfork(void)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801238:	68 da 27 80 00       	push   $0x8027da
  80123d:	68 92 00 00 00       	push   $0x92
  801242:	68 5d 27 80 00       	push   $0x80275d
  801247:	e8 dc ef ff ff       	call   800228 <_panic>

0080124c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	05 00 00 00 30       	add    $0x30000000,%eax
  801257:	c1 e8 0c             	shr    $0xc,%eax
}
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801267:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80127b:	89 c2                	mov    %eax,%edx
  80127d:	c1 ea 16             	shr    $0x16,%edx
  801280:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801287:	f6 c2 01             	test   $0x1,%dl
  80128a:	74 29                	je     8012b5 <fd_alloc+0x42>
  80128c:	89 c2                	mov    %eax,%edx
  80128e:	c1 ea 0c             	shr    $0xc,%edx
  801291:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801298:	f6 c2 01             	test   $0x1,%dl
  80129b:	74 18                	je     8012b5 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80129d:	05 00 10 00 00       	add    $0x1000,%eax
  8012a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a7:	75 d2                	jne    80127b <fd_alloc+0x8>
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8012ae:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8012b3:	eb 05                	jmp    8012ba <fd_alloc+0x47>
			return 0;
  8012b5:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8012ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bd:	89 02                	mov    %eax,(%edx)
}
  8012bf:	89 c8                	mov    %ecx,%eax
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c9:	83 f8 1f             	cmp    $0x1f,%eax
  8012cc:	77 30                	ja     8012fe <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012ce:	c1 e0 0c             	shl    $0xc,%eax
  8012d1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012dc:	f6 c2 01             	test   $0x1,%dl
  8012df:	74 24                	je     801305 <fd_lookup+0x42>
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	c1 ea 0c             	shr    $0xc,%edx
  8012e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ed:	f6 c2 01             	test   $0x1,%dl
  8012f0:	74 1a                	je     80130c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    
		return -E_INVAL;
  8012fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801303:	eb f7                	jmp    8012fc <fd_lookup+0x39>
		return -E_INVAL;
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130a:	eb f0                	jmp    8012fc <fd_lookup+0x39>
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801311:	eb e9                	jmp    8012fc <fd_lookup+0x39>

00801313 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	53                   	push   %ebx
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	8b 55 08             	mov    0x8(%ebp),%edx
  80131d:	b8 6c 28 80 00       	mov    $0x80286c,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801322:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801327:	39 13                	cmp    %edx,(%ebx)
  801329:	74 32                	je     80135d <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80132b:	83 c0 04             	add    $0x4,%eax
  80132e:	8b 18                	mov    (%eax),%ebx
  801330:	85 db                	test   %ebx,%ebx
  801332:	75 f3                	jne    801327 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801334:	a1 00 40 80 00       	mov    0x804000,%eax
  801339:	8b 40 48             	mov    0x48(%eax),%eax
  80133c:	83 ec 04             	sub    $0x4,%esp
  80133f:	52                   	push   %edx
  801340:	50                   	push   %eax
  801341:	68 f0 27 80 00       	push   $0x8027f0
  801346:	e8 b8 ef ff ff       	call   800303 <cprintf>
	*dev = 0;
	return -E_INVAL;
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801353:	8b 55 0c             	mov    0xc(%ebp),%edx
  801356:	89 1a                	mov    %ebx,(%edx)
}
  801358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    
			return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	eb ef                	jmp    801353 <dev_lookup+0x40>

00801364 <fd_close>:
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	57                   	push   %edi
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	83 ec 24             	sub    $0x24,%esp
  80136d:	8b 75 08             	mov    0x8(%ebp),%esi
  801370:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801373:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801376:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801377:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80137d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801380:	50                   	push   %eax
  801381:	e8 3d ff ff ff       	call   8012c3 <fd_lookup>
  801386:	89 c3                	mov    %eax,%ebx
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	85 c0                	test   %eax,%eax
  80138d:	78 05                	js     801394 <fd_close+0x30>
	    || fd != fd2)
  80138f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801392:	74 16                	je     8013aa <fd_close+0x46>
		return (must_exist ? r : 0);
  801394:	89 f8                	mov    %edi,%eax
  801396:	84 c0                	test   %al,%al
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
  80139d:	0f 44 d8             	cmove  %eax,%ebx
}
  8013a0:	89 d8                	mov    %ebx,%eax
  8013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5f                   	pop    %edi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013b0:	50                   	push   %eax
  8013b1:	ff 36                	push   (%esi)
  8013b3:	e8 5b ff ff ff       	call   801313 <dev_lookup>
  8013b8:	89 c3                	mov    %eax,%ebx
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 1a                	js     8013db <fd_close+0x77>
		if (dev->dev_close)
  8013c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013c7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 0b                	je     8013db <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	56                   	push   %esi
  8013d4:	ff d0                	call   *%eax
  8013d6:	89 c3                	mov    %eax,%ebx
  8013d8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	56                   	push   %esi
  8013df:	6a 00                	push   $0x0
  8013e1:	e8 63 fa ff ff       	call   800e49 <sys_page_unmap>
	return r;
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	eb b5                	jmp    8013a0 <fd_close+0x3c>

008013eb <close>:

int
close(int fdnum)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 08             	push   0x8(%ebp)
  8013f8:	e8 c6 fe ff ff       	call   8012c3 <fd_lookup>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	79 02                	jns    801406 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    
		return fd_close(fd, 1);
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	6a 01                	push   $0x1
  80140b:	ff 75 f4             	push   -0xc(%ebp)
  80140e:	e8 51 ff ff ff       	call   801364 <fd_close>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	eb ec                	jmp    801404 <close+0x19>

00801418 <close_all>:

void
close_all(void)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80141f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801424:	83 ec 0c             	sub    $0xc,%esp
  801427:	53                   	push   %ebx
  801428:	e8 be ff ff ff       	call   8013eb <close>
	for (i = 0; i < MAXFD; i++)
  80142d:	83 c3 01             	add    $0x1,%ebx
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	83 fb 20             	cmp    $0x20,%ebx
  801436:	75 ec                	jne    801424 <close_all+0xc>
}
  801438:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	57                   	push   %edi
  801441:	56                   	push   %esi
  801442:	53                   	push   %ebx
  801443:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801446:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801449:	50                   	push   %eax
  80144a:	ff 75 08             	push   0x8(%ebp)
  80144d:	e8 71 fe ff ff       	call   8012c3 <fd_lookup>
  801452:	89 c3                	mov    %eax,%ebx
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 7f                	js     8014da <dup+0x9d>
		return r;
	close(newfdnum);
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	ff 75 0c             	push   0xc(%ebp)
  801461:	e8 85 ff ff ff       	call   8013eb <close>

	newfd = INDEX2FD(newfdnum);
  801466:	8b 75 0c             	mov    0xc(%ebp),%esi
  801469:	c1 e6 0c             	shl    $0xc,%esi
  80146c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801475:	89 3c 24             	mov    %edi,(%esp)
  801478:	e8 df fd ff ff       	call   80125c <fd2data>
  80147d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80147f:	89 34 24             	mov    %esi,(%esp)
  801482:	e8 d5 fd ff ff       	call   80125c <fd2data>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80148d:	89 d8                	mov    %ebx,%eax
  80148f:	c1 e8 16             	shr    $0x16,%eax
  801492:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801499:	a8 01                	test   $0x1,%al
  80149b:	74 11                	je     8014ae <dup+0x71>
  80149d:	89 d8                	mov    %ebx,%eax
  80149f:	c1 e8 0c             	shr    $0xc,%eax
  8014a2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a9:	f6 c2 01             	test   $0x1,%dl
  8014ac:	75 36                	jne    8014e4 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014ae:	89 f8                	mov    %edi,%eax
  8014b0:	c1 e8 0c             	shr    $0xc,%eax
  8014b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c2:	50                   	push   %eax
  8014c3:	56                   	push   %esi
  8014c4:	6a 00                	push   $0x0
  8014c6:	57                   	push   %edi
  8014c7:	6a 00                	push   $0x0
  8014c9:	e8 39 f9 ff ff       	call   800e07 <sys_page_map>
  8014ce:	89 c3                	mov    %eax,%ebx
  8014d0:	83 c4 20             	add    $0x20,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 33                	js     80150a <dup+0xcd>
		goto err;

	return newfdnum;
  8014d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014da:	89 d8                	mov    %ebx,%eax
  8014dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 d4             	push   -0x2c(%ebp)
  8014f7:	6a 00                	push   $0x0
  8014f9:	53                   	push   %ebx
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 06 f9 ff ff       	call   800e07 <sys_page_map>
  801501:	89 c3                	mov    %eax,%ebx
  801503:	83 c4 20             	add    $0x20,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	79 a4                	jns    8014ae <dup+0x71>
	sys_page_unmap(0, newfd);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	56                   	push   %esi
  80150e:	6a 00                	push   $0x0
  801510:	e8 34 f9 ff ff       	call   800e49 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801515:	83 c4 08             	add    $0x8,%esp
  801518:	ff 75 d4             	push   -0x2c(%ebp)
  80151b:	6a 00                	push   $0x0
  80151d:	e8 27 f9 ff ff       	call   800e49 <sys_page_unmap>
	return r;
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	eb b3                	jmp    8014da <dup+0x9d>

00801527 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
  80152c:	83 ec 18             	sub    $0x18,%esp
  80152f:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801532:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	56                   	push   %esi
  801537:	e8 87 fd ff ff       	call   8012c3 <fd_lookup>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 3c                	js     80157f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801543:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154c:	50                   	push   %eax
  80154d:	ff 33                	push   (%ebx)
  80154f:	e8 bf fd ff ff       	call   801313 <dev_lookup>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	78 24                	js     80157f <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80155b:	8b 43 08             	mov    0x8(%ebx),%eax
  80155e:	83 e0 03             	and    $0x3,%eax
  801561:	83 f8 01             	cmp    $0x1,%eax
  801564:	74 20                	je     801586 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	8b 40 08             	mov    0x8(%eax),%eax
  80156c:	85 c0                	test   %eax,%eax
  80156e:	74 37                	je     8015a7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	ff 75 10             	push   0x10(%ebp)
  801576:	ff 75 0c             	push   0xc(%ebp)
  801579:	53                   	push   %ebx
  80157a:	ff d0                	call   *%eax
  80157c:	83 c4 10             	add    $0x10,%esp
}
  80157f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801586:	a1 00 40 80 00       	mov    0x804000,%eax
  80158b:	8b 40 48             	mov    0x48(%eax),%eax
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	56                   	push   %esi
  801592:	50                   	push   %eax
  801593:	68 31 28 80 00       	push   $0x802831
  801598:	e8 66 ed ff ff       	call   800303 <cprintf>
		return -E_INVAL;
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a5:	eb d8                	jmp    80157f <read+0x58>
		return -E_NOT_SUPP;
  8015a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ac:	eb d1                	jmp    80157f <read+0x58>

008015ae <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	57                   	push   %edi
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c2:	eb 02                	jmp    8015c6 <readn+0x18>
  8015c4:	01 c3                	add    %eax,%ebx
  8015c6:	39 f3                	cmp    %esi,%ebx
  8015c8:	73 21                	jae    8015eb <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	89 f0                	mov    %esi,%eax
  8015cf:	29 d8                	sub    %ebx,%eax
  8015d1:	50                   	push   %eax
  8015d2:	89 d8                	mov    %ebx,%eax
  8015d4:	03 45 0c             	add    0xc(%ebp),%eax
  8015d7:	50                   	push   %eax
  8015d8:	57                   	push   %edi
  8015d9:	e8 49 ff ff ff       	call   801527 <read>
		if (m < 0)
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 04                	js     8015e9 <readn+0x3b>
			return m;
		if (m == 0)
  8015e5:	75 dd                	jne    8015c4 <readn+0x16>
  8015e7:	eb 02                	jmp    8015eb <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015e9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 18             	sub    $0x18,%esp
  8015fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801600:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801603:	50                   	push   %eax
  801604:	53                   	push   %ebx
  801605:	e8 b9 fc ff ff       	call   8012c3 <fd_lookup>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 37                	js     801648 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801611:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	ff 36                	push   (%esi)
  80161d:	e8 f1 fc ff ff       	call   801313 <dev_lookup>
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 1f                	js     801648 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801629:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80162d:	74 20                	je     80164f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	85 c0                	test   %eax,%eax
  801637:	74 37                	je     801670 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	ff 75 10             	push   0x10(%ebp)
  80163f:	ff 75 0c             	push   0xc(%ebp)
  801642:	56                   	push   %esi
  801643:	ff d0                	call   *%eax
  801645:	83 c4 10             	add    $0x10,%esp
}
  801648:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80164f:	a1 00 40 80 00       	mov    0x804000,%eax
  801654:	8b 40 48             	mov    0x48(%eax),%eax
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	53                   	push   %ebx
  80165b:	50                   	push   %eax
  80165c:	68 4d 28 80 00       	push   $0x80284d
  801661:	e8 9d ec ff ff       	call   800303 <cprintf>
		return -E_INVAL;
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166e:	eb d8                	jmp    801648 <write+0x53>
		return -E_NOT_SUPP;
  801670:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801675:	eb d1                	jmp    801648 <write+0x53>

00801677 <seek>:

int
seek(int fdnum, off_t offset)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801680:	50                   	push   %eax
  801681:	ff 75 08             	push   0x8(%ebp)
  801684:	e8 3a fc ff ff       	call   8012c3 <fd_lookup>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 0e                	js     80169e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 18             	sub    $0x18,%esp
  8016a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ae:	50                   	push   %eax
  8016af:	53                   	push   %ebx
  8016b0:	e8 0e fc ff ff       	call   8012c3 <fd_lookup>
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 34                	js     8016f0 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016bc:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	ff 36                	push   (%esi)
  8016c8:	e8 46 fc ff ff       	call   801313 <dev_lookup>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 1c                	js     8016f0 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d4:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8016d8:	74 1d                	je     8016f7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	8b 40 18             	mov    0x18(%eax),%eax
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	74 34                	je     801718 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	ff 75 0c             	push   0xc(%ebp)
  8016ea:	56                   	push   %esi
  8016eb:	ff d0                	call   *%eax
  8016ed:	83 c4 10             	add    $0x10,%esp
}
  8016f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016f7:	a1 00 40 80 00       	mov    0x804000,%eax
  8016fc:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	53                   	push   %ebx
  801703:	50                   	push   %eax
  801704:	68 10 28 80 00       	push   $0x802810
  801709:	e8 f5 eb ff ff       	call   800303 <cprintf>
		return -E_INVAL;
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801716:	eb d8                	jmp    8016f0 <ftruncate+0x50>
		return -E_NOT_SUPP;
  801718:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171d:	eb d1                	jmp    8016f0 <ftruncate+0x50>

0080171f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	56                   	push   %esi
  801723:	53                   	push   %ebx
  801724:	83 ec 18             	sub    $0x18,%esp
  801727:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80172d:	50                   	push   %eax
  80172e:	ff 75 08             	push   0x8(%ebp)
  801731:	e8 8d fb ff ff       	call   8012c3 <fd_lookup>
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 49                	js     801786 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173d:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	ff 36                	push   (%esi)
  801749:	e8 c5 fb ff ff       	call   801313 <dev_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	78 31                	js     801786 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80175c:	74 2f                	je     80178d <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80175e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801761:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801768:	00 00 00 
	stat->st_isdir = 0;
  80176b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801772:	00 00 00 
	stat->st_dev = dev;
  801775:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	53                   	push   %ebx
  80177f:	56                   	push   %esi
  801780:	ff 50 14             	call   *0x14(%eax)
  801783:	83 c4 10             	add    $0x10,%esp
}
  801786:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    
		return -E_NOT_SUPP;
  80178d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801792:	eb f2                	jmp    801786 <fstat+0x67>

00801794 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 08             	push   0x8(%ebp)
  8017a1:	e8 22 02 00 00       	call   8019c8 <open>
  8017a6:	89 c3                	mov    %eax,%ebx
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 1b                	js     8017ca <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	ff 75 0c             	push   0xc(%ebp)
  8017b5:	50                   	push   %eax
  8017b6:	e8 64 ff ff ff       	call   80171f <fstat>
  8017bb:	89 c6                	mov    %eax,%esi
	close(fd);
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 26 fc ff ff       	call   8013eb <close>
	return r;
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	89 f3                	mov    %esi,%ebx
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	89 c6                	mov    %eax,%esi
  8017da:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017dc:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8017e3:	74 27                	je     80180c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017e5:	6a 07                	push   $0x7
  8017e7:	68 00 50 80 00       	push   $0x805000
  8017ec:	56                   	push   %esi
  8017ed:	ff 35 00 60 80 00    	push   0x806000
  8017f3:	e8 15 08 00 00       	call   80200d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017f8:	83 c4 0c             	add    $0xc,%esp
  8017fb:	6a 00                	push   $0x0
  8017fd:	53                   	push   %ebx
  8017fe:	6a 00                	push   $0x0
  801800:	e8 b9 07 00 00       	call   801fbe <ipc_recv>
}
  801805:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	6a 01                	push   $0x1
  801811:	e8 43 08 00 00       	call   802059 <ipc_find_env>
  801816:	a3 00 60 80 00       	mov    %eax,0x806000
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	eb c5                	jmp    8017e5 <fsipc+0x12>

00801820 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8b 40 0c             	mov    0xc(%eax),%eax
  80182c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
  80183e:	b8 02 00 00 00       	mov    $0x2,%eax
  801843:	e8 8b ff ff ff       	call   8017d3 <fsipc>
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <devfile_flush>:
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8b 40 0c             	mov    0xc(%eax),%eax
  801856:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80185b:	ba 00 00 00 00       	mov    $0x0,%edx
  801860:	b8 06 00 00 00       	mov    $0x6,%eax
  801865:	e8 69 ff ff ff       	call   8017d3 <fsipc>
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <devfile_stat>:
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	8b 40 0c             	mov    0xc(%eax),%eax
  80187c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	b8 05 00 00 00       	mov    $0x5,%eax
  80188b:	e8 43 ff ff ff       	call   8017d3 <fsipc>
  801890:	85 c0                	test   %eax,%eax
  801892:	78 2c                	js     8018c0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	68 00 50 80 00       	push   $0x805000
  80189c:	53                   	push   %ebx
  80189d:	e8 26 f1 ff ff       	call   8009c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a2:	a1 80 50 80 00       	mov    0x805080,%eax
  8018a7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ad:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <devfile_write>:
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018da:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018e0:	53                   	push   %ebx
  8018e1:	ff 75 0c             	push   0xc(%ebp)
  8018e4:	68 08 50 80 00       	push   $0x805008
  8018e9:	e8 d2 f2 ff ff       	call   800bc0 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f8:	e8 d6 fe ff ff       	call   8017d3 <fsipc>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	78 0b                	js     80190f <devfile_write+0x4a>
	assert(r <= n);
  801904:	39 d8                	cmp    %ebx,%eax
  801906:	77 0c                	ja     801914 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801908:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80190d:	7f 1e                	jg     80192d <devfile_write+0x68>
}
  80190f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801912:	c9                   	leave  
  801913:	c3                   	ret    
	assert(r <= n);
  801914:	68 7c 28 80 00       	push   $0x80287c
  801919:	68 83 28 80 00       	push   $0x802883
  80191e:	68 97 00 00 00       	push   $0x97
  801923:	68 98 28 80 00       	push   $0x802898
  801928:	e8 fb e8 ff ff       	call   800228 <_panic>
	assert(r <= PGSIZE);
  80192d:	68 a3 28 80 00       	push   $0x8028a3
  801932:	68 83 28 80 00       	push   $0x802883
  801937:	68 98 00 00 00       	push   $0x98
  80193c:	68 98 28 80 00       	push   $0x802898
  801941:	e8 e2 e8 ff ff       	call   800228 <_panic>

00801946 <devfile_read>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8b 40 0c             	mov    0xc(%eax),%eax
  801954:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801959:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	b8 03 00 00 00       	mov    $0x3,%eax
  801969:	e8 65 fe ff ff       	call   8017d3 <fsipc>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	85 c0                	test   %eax,%eax
  801972:	78 1f                	js     801993 <devfile_read+0x4d>
	assert(r <= n);
  801974:	39 f0                	cmp    %esi,%eax
  801976:	77 24                	ja     80199c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801978:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80197d:	7f 33                	jg     8019b2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	50                   	push   %eax
  801983:	68 00 50 80 00       	push   $0x805000
  801988:	ff 75 0c             	push   0xc(%ebp)
  80198b:	e8 ce f1 ff ff       	call   800b5e <memmove>
	return r;
  801990:	83 c4 10             	add    $0x10,%esp
}
  801993:	89 d8                	mov    %ebx,%eax
  801995:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801998:	5b                   	pop    %ebx
  801999:	5e                   	pop    %esi
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    
	assert(r <= n);
  80199c:	68 7c 28 80 00       	push   $0x80287c
  8019a1:	68 83 28 80 00       	push   $0x802883
  8019a6:	6a 7c                	push   $0x7c
  8019a8:	68 98 28 80 00       	push   $0x802898
  8019ad:	e8 76 e8 ff ff       	call   800228 <_panic>
	assert(r <= PGSIZE);
  8019b2:	68 a3 28 80 00       	push   $0x8028a3
  8019b7:	68 83 28 80 00       	push   $0x802883
  8019bc:	6a 7d                	push   $0x7d
  8019be:	68 98 28 80 00       	push   $0x802898
  8019c3:	e8 60 e8 ff ff       	call   800228 <_panic>

008019c8 <open>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	56                   	push   %esi
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 1c             	sub    $0x1c,%esp
  8019d0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019d3:	56                   	push   %esi
  8019d4:	e8 b4 ef ff ff       	call   80098d <strlen>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019e1:	7f 6c                	jg     801a4f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e9:	50                   	push   %eax
  8019ea:	e8 84 f8 ff ff       	call   801273 <fd_alloc>
  8019ef:	89 c3                	mov    %eax,%ebx
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 3c                	js     801a34 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	56                   	push   %esi
  8019fc:	68 00 50 80 00       	push   $0x805000
  801a01:	e8 c2 ef ff ff       	call   8009c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a11:	b8 01 00 00 00       	mov    $0x1,%eax
  801a16:	e8 b8 fd ff ff       	call   8017d3 <fsipc>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 19                	js     801a3d <open+0x75>
	return fd2num(fd);
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	ff 75 f4             	push   -0xc(%ebp)
  801a2a:	e8 1d f8 ff ff       	call   80124c <fd2num>
  801a2f:	89 c3                	mov    %eax,%ebx
  801a31:	83 c4 10             	add    $0x10,%esp
}
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
		fd_close(fd, 0);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 f4             	push   -0xc(%ebp)
  801a45:	e8 1a f9 ff ff       	call   801364 <fd_close>
		return r;
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	eb e5                	jmp    801a34 <open+0x6c>
		return -E_BAD_PATH;
  801a4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a54:	eb de                	jmp    801a34 <open+0x6c>

00801a56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a61:	b8 08 00 00 00       	mov    $0x8,%eax
  801a66:	e8 68 fd ff ff       	call   8017d3 <fsipc>
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	ff 75 08             	push   0x8(%ebp)
  801a7b:	e8 dc f7 ff ff       	call   80125c <fd2data>
  801a80:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a82:	83 c4 08             	add    $0x8,%esp
  801a85:	68 af 28 80 00       	push   $0x8028af
  801a8a:	53                   	push   %ebx
  801a8b:	e8 38 ef ff ff       	call   8009c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a90:	8b 46 04             	mov    0x4(%esi),%eax
  801a93:	2b 06                	sub    (%esi),%eax
  801a95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aa2:	00 00 00 
	stat->st_dev = &devpipe;
  801aa5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aac:	30 80 00 
	return 0;
}
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5d                   	pop    %ebp
  801aba:	c3                   	ret    

00801abb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ac5:	53                   	push   %ebx
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 7c f3 ff ff       	call   800e49 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801acd:	89 1c 24             	mov    %ebx,(%esp)
  801ad0:	e8 87 f7 ff ff       	call   80125c <fd2data>
  801ad5:	83 c4 08             	add    $0x8,%esp
  801ad8:	50                   	push   %eax
  801ad9:	6a 00                	push   $0x0
  801adb:	e8 69 f3 ff ff       	call   800e49 <sys_page_unmap>
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <_pipeisclosed>:
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	57                   	push   %edi
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 1c             	sub    $0x1c,%esp
  801aee:	89 c7                	mov    %eax,%edi
  801af0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801af2:	a1 00 40 80 00       	mov    0x804000,%eax
  801af7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801afa:	83 ec 0c             	sub    $0xc,%esp
  801afd:	57                   	push   %edi
  801afe:	e8 8f 05 00 00       	call   802092 <pageref>
  801b03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b06:	89 34 24             	mov    %esi,(%esp)
  801b09:	e8 84 05 00 00       	call   802092 <pageref>
		nn = thisenv->env_runs;
  801b0e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801b14:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	39 cb                	cmp    %ecx,%ebx
  801b1c:	74 1b                	je     801b39 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b1e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b21:	75 cf                	jne    801af2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b23:	8b 42 58             	mov    0x58(%edx),%eax
  801b26:	6a 01                	push   $0x1
  801b28:	50                   	push   %eax
  801b29:	53                   	push   %ebx
  801b2a:	68 b6 28 80 00       	push   $0x8028b6
  801b2f:	e8 cf e7 ff ff       	call   800303 <cprintf>
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	eb b9                	jmp    801af2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b39:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b3c:	0f 94 c0             	sete   %al
  801b3f:	0f b6 c0             	movzbl %al,%eax
}
  801b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5f                   	pop    %edi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <devpipe_write>:
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	57                   	push   %edi
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 28             	sub    $0x28,%esp
  801b53:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b56:	56                   	push   %esi
  801b57:	e8 00 f7 ff ff       	call   80125c <fd2data>
  801b5c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	bf 00 00 00 00       	mov    $0x0,%edi
  801b66:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b69:	75 09                	jne    801b74 <devpipe_write+0x2a>
	return i;
  801b6b:	89 f8                	mov    %edi,%eax
  801b6d:	eb 23                	jmp    801b92 <devpipe_write+0x48>
			sys_yield();
  801b6f:	e8 31 f2 ff ff       	call   800da5 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b74:	8b 43 04             	mov    0x4(%ebx),%eax
  801b77:	8b 0b                	mov    (%ebx),%ecx
  801b79:	8d 51 20             	lea    0x20(%ecx),%edx
  801b7c:	39 d0                	cmp    %edx,%eax
  801b7e:	72 1a                	jb     801b9a <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801b80:	89 da                	mov    %ebx,%edx
  801b82:	89 f0                	mov    %esi,%eax
  801b84:	e8 5c ff ff ff       	call   801ae5 <_pipeisclosed>
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	74 e2                	je     801b6f <devpipe_write+0x25>
				return 0;
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5f                   	pop    %edi
  801b98:	5d                   	pop    %ebp
  801b99:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ba1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba4:	89 c2                	mov    %eax,%edx
  801ba6:	c1 fa 1f             	sar    $0x1f,%edx
  801ba9:	89 d1                	mov    %edx,%ecx
  801bab:	c1 e9 1b             	shr    $0x1b,%ecx
  801bae:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bb1:	83 e2 1f             	and    $0x1f,%edx
  801bb4:	29 ca                	sub    %ecx,%edx
  801bb6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bbe:	83 c0 01             	add    $0x1,%eax
  801bc1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc4:	83 c7 01             	add    $0x1,%edi
  801bc7:	eb 9d                	jmp    801b66 <devpipe_write+0x1c>

00801bc9 <devpipe_read>:
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 18             	sub    $0x18,%esp
  801bd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bd5:	57                   	push   %edi
  801bd6:	e8 81 f6 ff ff       	call   80125c <fd2data>
  801bdb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	be 00 00 00 00       	mov    $0x0,%esi
  801be5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801be8:	75 13                	jne    801bfd <devpipe_read+0x34>
	return i;
  801bea:	89 f0                	mov    %esi,%eax
  801bec:	eb 02                	jmp    801bf0 <devpipe_read+0x27>
				return i;
  801bee:	89 f0                	mov    %esi,%eax
}
  801bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
			sys_yield();
  801bf8:	e8 a8 f1 ff ff       	call   800da5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801bfd:	8b 03                	mov    (%ebx),%eax
  801bff:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c02:	75 18                	jne    801c1c <devpipe_read+0x53>
			if (i > 0)
  801c04:	85 f6                	test   %esi,%esi
  801c06:	75 e6                	jne    801bee <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801c08:	89 da                	mov    %ebx,%edx
  801c0a:	89 f8                	mov    %edi,%eax
  801c0c:	e8 d4 fe ff ff       	call   801ae5 <_pipeisclosed>
  801c11:	85 c0                	test   %eax,%eax
  801c13:	74 e3                	je     801bf8 <devpipe_read+0x2f>
				return 0;
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1a:	eb d4                	jmp    801bf0 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c1c:	99                   	cltd   
  801c1d:	c1 ea 1b             	shr    $0x1b,%edx
  801c20:	01 d0                	add    %edx,%eax
  801c22:	83 e0 1f             	and    $0x1f,%eax
  801c25:	29 d0                	sub    %edx,%eax
  801c27:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c2f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c32:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c35:	83 c6 01             	add    $0x1,%esi
  801c38:	eb ab                	jmp    801be5 <devpipe_read+0x1c>

00801c3a <pipe>:
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	56                   	push   %esi
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c45:	50                   	push   %eax
  801c46:	e8 28 f6 ff ff       	call   801273 <fd_alloc>
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	85 c0                	test   %eax,%eax
  801c52:	0f 88 23 01 00 00    	js     801d7b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	68 07 04 00 00       	push   $0x407
  801c60:	ff 75 f4             	push   -0xc(%ebp)
  801c63:	6a 00                	push   $0x0
  801c65:	e8 5a f1 ff ff       	call   800dc4 <sys_page_alloc>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	0f 88 04 01 00 00    	js     801d7b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801c77:	83 ec 0c             	sub    $0xc,%esp
  801c7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c7d:	50                   	push   %eax
  801c7e:	e8 f0 f5 ff ff       	call   801273 <fd_alloc>
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	0f 88 db 00 00 00    	js     801d6b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	68 07 04 00 00       	push   $0x407
  801c98:	ff 75 f0             	push   -0x10(%ebp)
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 22 f1 ff ff       	call   800dc4 <sys_page_alloc>
  801ca2:	89 c3                	mov    %eax,%ebx
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	0f 88 bc 00 00 00    	js     801d6b <pipe+0x131>
	va = fd2data(fd0);
  801caf:	83 ec 0c             	sub    $0xc,%esp
  801cb2:	ff 75 f4             	push   -0xc(%ebp)
  801cb5:	e8 a2 f5 ff ff       	call   80125c <fd2data>
  801cba:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cbc:	83 c4 0c             	add    $0xc,%esp
  801cbf:	68 07 04 00 00       	push   $0x407
  801cc4:	50                   	push   %eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	e8 f8 f0 ff ff       	call   800dc4 <sys_page_alloc>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	0f 88 82 00 00 00    	js     801d5b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff 75 f0             	push   -0x10(%ebp)
  801cdf:	e8 78 f5 ff ff       	call   80125c <fd2data>
  801ce4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ceb:	50                   	push   %eax
  801cec:	6a 00                	push   $0x0
  801cee:	56                   	push   %esi
  801cef:	6a 00                	push   $0x0
  801cf1:	e8 11 f1 ff ff       	call   800e07 <sys_page_map>
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	83 c4 20             	add    $0x20,%esp
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 4e                	js     801d4d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801cff:	a1 20 30 80 00       	mov    0x803020,%eax
  801d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d07:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d16:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 f4             	push   -0xc(%ebp)
  801d28:	e8 1f f5 ff ff       	call   80124c <fd2num>
  801d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d30:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d32:	83 c4 04             	add    $0x4,%esp
  801d35:	ff 75 f0             	push   -0x10(%ebp)
  801d38:	e8 0f f5 ff ff       	call   80124c <fd2num>
  801d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d40:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d4b:	eb 2e                	jmp    801d7b <pipe+0x141>
	sys_page_unmap(0, va);
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	56                   	push   %esi
  801d51:	6a 00                	push   $0x0
  801d53:	e8 f1 f0 ff ff       	call   800e49 <sys_page_unmap>
  801d58:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	ff 75 f0             	push   -0x10(%ebp)
  801d61:	6a 00                	push   $0x0
  801d63:	e8 e1 f0 ff ff       	call   800e49 <sys_page_unmap>
  801d68:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d6b:	83 ec 08             	sub    $0x8,%esp
  801d6e:	ff 75 f4             	push   -0xc(%ebp)
  801d71:	6a 00                	push   $0x0
  801d73:	e8 d1 f0 ff ff       	call   800e49 <sys_page_unmap>
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	89 d8                	mov    %ebx,%eax
  801d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <pipeisclosed>:
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8d:	50                   	push   %eax
  801d8e:	ff 75 08             	push   0x8(%ebp)
  801d91:	e8 2d f5 ff ff       	call   8012c3 <fd_lookup>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 18                	js     801db5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 f4             	push   -0xc(%ebp)
  801da3:	e8 b4 f4 ff ff       	call   80125c <fd2data>
  801da8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	e8 33 fd ff ff       	call   801ae5 <_pipeisclosed>
  801db2:	83 c4 10             	add    $0x10,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	c3                   	ret    

00801dbd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dc3:	68 ce 28 80 00       	push   $0x8028ce
  801dc8:	ff 75 0c             	push   0xc(%ebp)
  801dcb:	e8 f8 eb ff ff       	call   8009c8 <strcpy>
	return 0;
}
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <devcons_write>:
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	57                   	push   %edi
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801de3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801de8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801dee:	eb 2e                	jmp    801e1e <devcons_write+0x47>
		m = n - tot;
  801df0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801df3:	29 f3                	sub    %esi,%ebx
  801df5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801dfa:	39 c3                	cmp    %eax,%ebx
  801dfc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801dff:	83 ec 04             	sub    $0x4,%esp
  801e02:	53                   	push   %ebx
  801e03:	89 f0                	mov    %esi,%eax
  801e05:	03 45 0c             	add    0xc(%ebp),%eax
  801e08:	50                   	push   %eax
  801e09:	57                   	push   %edi
  801e0a:	e8 4f ed ff ff       	call   800b5e <memmove>
		sys_cputs(buf, m);
  801e0f:	83 c4 08             	add    $0x8,%esp
  801e12:	53                   	push   %ebx
  801e13:	57                   	push   %edi
  801e14:	e8 ef ee ff ff       	call   800d08 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e19:	01 de                	add    %ebx,%esi
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e21:	72 cd                	jb     801df0 <devcons_write+0x19>
}
  801e23:	89 f0                	mov    %esi,%eax
  801e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e28:	5b                   	pop    %ebx
  801e29:	5e                   	pop    %esi
  801e2a:	5f                   	pop    %edi
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    

00801e2d <devcons_read>:
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3c:	75 07                	jne    801e45 <devcons_read+0x18>
  801e3e:	eb 1f                	jmp    801e5f <devcons_read+0x32>
		sys_yield();
  801e40:	e8 60 ef ff ff       	call   800da5 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e45:	e8 dc ee ff ff       	call   800d26 <sys_cgetc>
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	74 f2                	je     801e40 <devcons_read+0x13>
	if (c < 0)
  801e4e:	78 0f                	js     801e5f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801e50:	83 f8 04             	cmp    $0x4,%eax
  801e53:	74 0c                	je     801e61 <devcons_read+0x34>
	*(char*)vbuf = c;
  801e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e58:	88 02                	mov    %al,(%edx)
	return 1;
  801e5a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    
		return 0;
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
  801e66:	eb f7                	jmp    801e5f <devcons_read+0x32>

00801e68 <cputchar>:
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e74:	6a 01                	push   $0x1
  801e76:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e79:	50                   	push   %eax
  801e7a:	e8 89 ee ff ff       	call   800d08 <sys_cputs>
}
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <getchar>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e8a:	6a 01                	push   $0x1
  801e8c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8f:	50                   	push   %eax
  801e90:	6a 00                	push   $0x0
  801e92:	e8 90 f6 ff ff       	call   801527 <read>
	if (r < 0)
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	78 06                	js     801ea4 <getchar+0x20>
	if (r < 1)
  801e9e:	74 06                	je     801ea6 <getchar+0x22>
	return c;
  801ea0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    
		return -E_EOF;
  801ea6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801eab:	eb f7                	jmp    801ea4 <getchar+0x20>

00801ead <iscons>:
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb6:	50                   	push   %eax
  801eb7:	ff 75 08             	push   0x8(%ebp)
  801eba:	e8 04 f4 ff ff       	call   8012c3 <fd_lookup>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 11                	js     801ed7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ecf:	39 10                	cmp    %edx,(%eax)
  801ed1:	0f 94 c0             	sete   %al
  801ed4:	0f b6 c0             	movzbl %al,%eax
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <opencons>:
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801edf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee2:	50                   	push   %eax
  801ee3:	e8 8b f3 ff ff       	call   801273 <fd_alloc>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	78 3a                	js     801f29 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 07 04 00 00       	push   $0x407
  801ef7:	ff 75 f4             	push   -0xc(%ebp)
  801efa:	6a 00                	push   $0x0
  801efc:	e8 c3 ee ff ff       	call   800dc4 <sys_page_alloc>
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	85 c0                	test   %eax,%eax
  801f06:	78 21                	js     801f29 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f11:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	50                   	push   %eax
  801f21:	e8 26 f3 ff ff       	call   80124c <fd2num>
  801f26:	83 c4 10             	add    $0x10,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f31:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801f38:	74 20                	je     801f5a <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	a3 04 60 80 00       	mov    %eax,0x806004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	68 9a 1f 80 00       	push   $0x801f9a
  801f4a:	6a 00                	push   $0x0
  801f4c:	e8 be ef ff ff       	call   800f0f <sys_env_set_pgfault_upcall>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 2e                	js     801f86 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	6a 07                	push   $0x7
  801f5f:	68 00 f0 bf ee       	push   $0xeebff000
  801f64:	6a 00                	push   $0x0
  801f66:	e8 59 ee ff ff       	call   800dc4 <sys_page_alloc>
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	79 c8                	jns    801f3a <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	68 dc 28 80 00       	push   $0x8028dc
  801f7a:	6a 21                	push   $0x21
  801f7c:	68 3f 29 80 00       	push   $0x80293f
  801f81:	e8 a2 e2 ff ff       	call   800228 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 08 29 80 00       	push   $0x802908
  801f8e:	6a 27                	push   $0x27
  801f90:	68 3f 29 80 00       	push   $0x80293f
  801f95:	e8 8e e2 ff ff       	call   800228 <_panic>

00801f9a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f9a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f9b:	a1 04 60 80 00       	mov    0x806004,%eax
	call *%eax
  801fa0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801fa2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  801fa5:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  801fa9:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  801fae:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  801fb2:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  801fb4:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801fb7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  801fb8:	83 c4 04             	add    $0x4,%esp
	popfl
  801fbb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801fbc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801fbd:	c3                   	ret    

00801fbe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	56                   	push   %esi
  801fc2:	53                   	push   %ebx
  801fc3:	8b 75 08             	mov    0x8(%ebp),%esi
  801fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	ff 75 0c             	push   0xc(%ebp)
  801fcf:	e8 a0 ef ff ff       	call   800f74 <sys_ipc_recv>
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	78 2b                	js     802006 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801fdb:	85 f6                	test   %esi,%esi
  801fdd:	74 0a                	je     801fe9 <ipc_recv+0x2b>
  801fdf:	a1 00 40 80 00       	mov    0x804000,%eax
  801fe4:	8b 40 74             	mov    0x74(%eax),%eax
  801fe7:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801fe9:	85 db                	test   %ebx,%ebx
  801feb:	74 0a                	je     801ff7 <ipc_recv+0x39>
  801fed:	a1 00 40 80 00       	mov    0x804000,%eax
  801ff2:	8b 40 78             	mov    0x78(%eax),%eax
  801ff5:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801ff7:	a1 00 40 80 00       	mov    0x804000,%eax
  801ffc:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802002:	5b                   	pop    %ebx
  802003:	5e                   	pop    %esi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802006:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200b:	eb f2                	jmp    801fff <ipc_recv+0x41>

0080200d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	57                   	push   %edi
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	8b 7d 08             	mov    0x8(%ebp),%edi
  802019:	8b 75 0c             	mov    0xc(%ebp),%esi
  80201c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80201f:	ff 75 14             	push   0x14(%ebp)
  802022:	53                   	push   %ebx
  802023:	56                   	push   %esi
  802024:	57                   	push   %edi
  802025:	e8 27 ef ff ff       	call   800f51 <sys_ipc_try_send>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	79 20                	jns    802051 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802031:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802034:	75 07                	jne    80203d <ipc_send+0x30>
		sys_yield();
  802036:	e8 6a ed ff ff       	call   800da5 <sys_yield>
  80203b:	eb e2                	jmp    80201f <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80203d:	83 ec 04             	sub    $0x4,%esp
  802040:	68 4d 29 80 00       	push   $0x80294d
  802045:	6a 2e                	push   $0x2e
  802047:	68 5d 29 80 00       	push   $0x80295d
  80204c:	e8 d7 e1 ff ff       	call   800228 <_panic>
	}
}
  802051:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802054:	5b                   	pop    %ebx
  802055:	5e                   	pop    %esi
  802056:	5f                   	pop    %edi
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    

00802059 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802064:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802067:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80206d:	8b 52 50             	mov    0x50(%edx),%edx
  802070:	39 ca                	cmp    %ecx,%edx
  802072:	74 11                	je     802085 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802074:	83 c0 01             	add    $0x1,%eax
  802077:	3d 00 04 00 00       	cmp    $0x400,%eax
  80207c:	75 e6                	jne    802064 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	eb 0b                	jmp    802090 <ipc_find_env+0x37>
			return envs[i].env_id;
  802085:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802088:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80208d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    

00802092 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802098:	89 c2                	mov    %eax,%edx
  80209a:	c1 ea 16             	shr    $0x16,%edx
  80209d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020a4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a9:	f6 c1 01             	test   $0x1,%cl
  8020ac:	74 1c                	je     8020ca <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8020ae:	c1 e8 0c             	shr    $0xc,%eax
  8020b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020b8:	a8 01                	test   $0x1,%al
  8020ba:	74 0e                	je     8020ca <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020bc:	c1 e8 0c             	shr    $0xc,%eax
  8020bf:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020c6:	ef 
  8020c7:	0f b7 d2             	movzwl %dx,%edx
}
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    
  8020ce:	66 90                	xchg   %ax,%ax

008020d0 <__udivdi3>:
  8020d0:	f3 0f 1e fb          	endbr32 
  8020d4:	55                   	push   %ebp
  8020d5:	57                   	push   %edi
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	83 ec 1c             	sub    $0x1c,%esp
  8020db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	75 19                	jne    802108 <__udivdi3+0x38>
  8020ef:	39 f3                	cmp    %esi,%ebx
  8020f1:	76 4d                	jbe    802140 <__udivdi3+0x70>
  8020f3:	31 ff                	xor    %edi,%edi
  8020f5:	89 e8                	mov    %ebp,%eax
  8020f7:	89 f2                	mov    %esi,%edx
  8020f9:	f7 f3                	div    %ebx
  8020fb:	89 fa                	mov    %edi,%edx
  8020fd:	83 c4 1c             	add    $0x1c,%esp
  802100:	5b                   	pop    %ebx
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
  802105:	8d 76 00             	lea    0x0(%esi),%esi
  802108:	39 f0                	cmp    %esi,%eax
  80210a:	76 14                	jbe    802120 <__udivdi3+0x50>
  80210c:	31 ff                	xor    %edi,%edi
  80210e:	31 c0                	xor    %eax,%eax
  802110:	89 fa                	mov    %edi,%edx
  802112:	83 c4 1c             	add    $0x1c,%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5f                   	pop    %edi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    
  80211a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802120:	0f bd f8             	bsr    %eax,%edi
  802123:	83 f7 1f             	xor    $0x1f,%edi
  802126:	75 48                	jne    802170 <__udivdi3+0xa0>
  802128:	39 f0                	cmp    %esi,%eax
  80212a:	72 06                	jb     802132 <__udivdi3+0x62>
  80212c:	31 c0                	xor    %eax,%eax
  80212e:	39 eb                	cmp    %ebp,%ebx
  802130:	77 de                	ja     802110 <__udivdi3+0x40>
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
  802137:	eb d7                	jmp    802110 <__udivdi3+0x40>
  802139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 d9                	mov    %ebx,%ecx
  802142:	85 db                	test   %ebx,%ebx
  802144:	75 0b                	jne    802151 <__udivdi3+0x81>
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	f7 f3                	div    %ebx
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	31 d2                	xor    %edx,%edx
  802153:	89 f0                	mov    %esi,%eax
  802155:	f7 f1                	div    %ecx
  802157:	89 c6                	mov    %eax,%esi
  802159:	89 e8                	mov    %ebp,%eax
  80215b:	89 f7                	mov    %esi,%edi
  80215d:	f7 f1                	div    %ecx
  80215f:	89 fa                	mov    %edi,%edx
  802161:	83 c4 1c             	add    $0x1c,%esp
  802164:	5b                   	pop    %ebx
  802165:	5e                   	pop    %esi
  802166:	5f                   	pop    %edi
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 f9                	mov    %edi,%ecx
  802172:	ba 20 00 00 00       	mov    $0x20,%edx
  802177:	29 fa                	sub    %edi,%edx
  802179:	d3 e0                	shl    %cl,%eax
  80217b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80217f:	89 d1                	mov    %edx,%ecx
  802181:	89 d8                	mov    %ebx,%eax
  802183:	d3 e8                	shr    %cl,%eax
  802185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802189:	09 c1                	or     %eax,%ecx
  80218b:	89 f0                	mov    %esi,%eax
  80218d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802191:	89 f9                	mov    %edi,%ecx
  802193:	d3 e3                	shl    %cl,%ebx
  802195:	89 d1                	mov    %edx,%ecx
  802197:	d3 e8                	shr    %cl,%eax
  802199:	89 f9                	mov    %edi,%ecx
  80219b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80219f:	89 eb                	mov    %ebp,%ebx
  8021a1:	d3 e6                	shl    %cl,%esi
  8021a3:	89 d1                	mov    %edx,%ecx
  8021a5:	d3 eb                	shr    %cl,%ebx
  8021a7:	09 f3                	or     %esi,%ebx
  8021a9:	89 c6                	mov    %eax,%esi
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	89 d8                	mov    %ebx,%eax
  8021af:	f7 74 24 08          	divl   0x8(%esp)
  8021b3:	89 d6                	mov    %edx,%esi
  8021b5:	89 c3                	mov    %eax,%ebx
  8021b7:	f7 64 24 0c          	mull   0xc(%esp)
  8021bb:	39 d6                	cmp    %edx,%esi
  8021bd:	72 19                	jb     8021d8 <__udivdi3+0x108>
  8021bf:	89 f9                	mov    %edi,%ecx
  8021c1:	d3 e5                	shl    %cl,%ebp
  8021c3:	39 c5                	cmp    %eax,%ebp
  8021c5:	73 04                	jae    8021cb <__udivdi3+0xfb>
  8021c7:	39 d6                	cmp    %edx,%esi
  8021c9:	74 0d                	je     8021d8 <__udivdi3+0x108>
  8021cb:	89 d8                	mov    %ebx,%eax
  8021cd:	31 ff                	xor    %edi,%edi
  8021cf:	e9 3c ff ff ff       	jmp    802110 <__udivdi3+0x40>
  8021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021db:	31 ff                	xor    %edi,%edi
  8021dd:	e9 2e ff ff ff       	jmp    802110 <__udivdi3+0x40>
  8021e2:	66 90                	xchg   %ax,%ax
  8021e4:	66 90                	xchg   %ax,%ax
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	66 90                	xchg   %ax,%ax
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	f3 0f 1e fb          	endbr32 
  8021f4:	55                   	push   %ebp
  8021f5:	57                   	push   %edi
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802203:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802207:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80220b:	89 f0                	mov    %esi,%eax
  80220d:	89 da                	mov    %ebx,%edx
  80220f:	85 ff                	test   %edi,%edi
  802211:	75 15                	jne    802228 <__umoddi3+0x38>
  802213:	39 dd                	cmp    %ebx,%ebp
  802215:	76 39                	jbe    802250 <__umoddi3+0x60>
  802217:	f7 f5                	div    %ebp
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 df                	cmp    %ebx,%edi
  80222a:	77 f1                	ja     80221d <__umoddi3+0x2d>
  80222c:	0f bd cf             	bsr    %edi,%ecx
  80222f:	83 f1 1f             	xor    $0x1f,%ecx
  802232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802236:	75 40                	jne    802278 <__umoddi3+0x88>
  802238:	39 df                	cmp    %ebx,%edi
  80223a:	72 04                	jb     802240 <__umoddi3+0x50>
  80223c:	39 f5                	cmp    %esi,%ebp
  80223e:	77 dd                	ja     80221d <__umoddi3+0x2d>
  802240:	89 da                	mov    %ebx,%edx
  802242:	89 f0                	mov    %esi,%eax
  802244:	29 e8                	sub    %ebp,%eax
  802246:	19 fa                	sbb    %edi,%edx
  802248:	eb d3                	jmp    80221d <__umoddi3+0x2d>
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	89 e9                	mov    %ebp,%ecx
  802252:	85 ed                	test   %ebp,%ebp
  802254:	75 0b                	jne    802261 <__umoddi3+0x71>
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f5                	div    %ebp
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 d8                	mov    %ebx,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f1                	div    %ecx
  802267:	89 f0                	mov    %esi,%eax
  802269:	f7 f1                	div    %ecx
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	31 d2                	xor    %edx,%edx
  80226f:	eb ac                	jmp    80221d <__umoddi3+0x2d>
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	8b 44 24 04          	mov    0x4(%esp),%eax
  80227c:	ba 20 00 00 00       	mov    $0x20,%edx
  802281:	29 c2                	sub    %eax,%edx
  802283:	89 c1                	mov    %eax,%ecx
  802285:	89 e8                	mov    %ebp,%eax
  802287:	d3 e7                	shl    %cl,%edi
  802289:	89 d1                	mov    %edx,%ecx
  80228b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80228f:	d3 e8                	shr    %cl,%eax
  802291:	89 c1                	mov    %eax,%ecx
  802293:	8b 44 24 04          	mov    0x4(%esp),%eax
  802297:	09 f9                	or     %edi,%ecx
  802299:	89 df                	mov    %ebx,%edi
  80229b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	d3 e5                	shl    %cl,%ebp
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	d3 ef                	shr    %cl,%edi
  8022a7:	89 c1                	mov    %eax,%ecx
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	d3 e3                	shl    %cl,%ebx
  8022ad:	89 d1                	mov    %edx,%ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	d3 e8                	shr    %cl,%eax
  8022b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022b8:	09 d8                	or     %ebx,%eax
  8022ba:	f7 74 24 08          	divl   0x8(%esp)
  8022be:	89 d3                	mov    %edx,%ebx
  8022c0:	d3 e6                	shl    %cl,%esi
  8022c2:	f7 e5                	mul    %ebp
  8022c4:	89 c7                	mov    %eax,%edi
  8022c6:	89 d1                	mov    %edx,%ecx
  8022c8:	39 d3                	cmp    %edx,%ebx
  8022ca:	72 06                	jb     8022d2 <__umoddi3+0xe2>
  8022cc:	75 0e                	jne    8022dc <__umoddi3+0xec>
  8022ce:	39 c6                	cmp    %eax,%esi
  8022d0:	73 0a                	jae    8022dc <__umoddi3+0xec>
  8022d2:	29 e8                	sub    %ebp,%eax
  8022d4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d8:	89 d1                	mov    %edx,%ecx
  8022da:	89 c7                	mov    %eax,%edi
  8022dc:	89 f5                	mov    %esi,%ebp
  8022de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8022e2:	29 fd                	sub    %edi,%ebp
  8022e4:	19 cb                	sbb    %ecx,%ebx
  8022e6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022eb:	89 d8                	mov    %ebx,%eax
  8022ed:	d3 e0                	shl    %cl,%eax
  8022ef:	89 f1                	mov    %esi,%ecx
  8022f1:	d3 ed                	shr    %cl,%ebp
  8022f3:	d3 eb                	shr    %cl,%ebx
  8022f5:	09 e8                	or     %ebp,%eax
  8022f7:	89 da                	mov    %ebx,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
