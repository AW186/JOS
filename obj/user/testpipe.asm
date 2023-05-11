
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a1 02 00 00       	call   8002d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 60 	movl   $0x802460,0x803004
  800042:	24 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 ee 1c 00 00       	call   801d3c <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 56 11 00 00       	call   8011b6 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 00 40 80 00       	mov    0x804000,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	push   -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 85 24 80 00       	push   $0x802485
  800084:	e8 7c 03 00 00       	call   800405 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	push   -0x70(%ebp)
  80008f:	e8 59 14 00 00       	call   8014ed <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 00 40 80 00       	mov    0x804000,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	push   -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 a2 24 80 00       	push   $0x8024a2
  8000a8:	e8 58 03 00 00       	call   800405 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	push   -0x74(%ebp)
  8000b9:	e8 f2 15 00 00       	call   8016b0 <readn>
  8000be:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 88 cf 00 00 00    	js     80019a <umain+0x167>
			panic("read: %e", i);
		buf[i] = 0;
  8000cb:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 35 00 30 80 00    	push   0x803000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 99 0a 00 00       	call   800b7b <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 c8 24 80 00       	push   $0x8024c8
  8000f5:	e8 0b 03 00 00       	call   800405 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 16 02 00 00       	call   800318 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 ae 1d 00 00       	call   801eb9 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 30 80 00 1e 	movl   $0x80251e,0x803004
  800112:	25 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 1c 1c 00 00       	call   801d3c <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 84 10 00 00       	call   8011b6 <fork>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 88 35 01 00 00    	js     800271 <umain+0x23e>
		panic("fork: %e", i);

	if (pid == 0) {
  80013c:	0f 84 41 01 00 00    	je     800283 <umain+0x250>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 8c             	push   -0x74(%ebp)
  800148:	e8 a0 13 00 00       	call   8014ed <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	push   -0x70(%ebp)
  800153:	e8 95 13 00 00       	call   8014ed <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 59 1d 00 00       	call   801eb9 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  800167:	e8 99 02 00 00       	call   800405 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 6c 24 80 00       	push   $0x80246c
  80017c:	6a 0e                	push   $0xe
  80017e:	68 75 24 80 00       	push   $0x802475
  800183:	e8 a2 01 00 00       	call   80032a <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 65 29 80 00       	push   $0x802965
  80018e:	6a 11                	push   $0x11
  800190:	68 75 24 80 00       	push   $0x802475
  800195:	e8 90 01 00 00       	call   80032a <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 bf 24 80 00       	push   $0x8024bf
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 75 24 80 00       	push   $0x802475
  8001a7:	e8 7e 01 00 00       	call   80032a <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 e4 24 80 00       	push   $0x8024e4
  8001b9:	e8 47 02 00 00       	call   800405 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	push   -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 85 24 80 00       	push   $0x802485
  8001da:	e8 26 02 00 00       	call   800405 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	push   -0x74(%ebp)
  8001e5:	e8 03 13 00 00       	call   8014ed <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 00 40 80 00       	mov    0x804000,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	push   -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 f7 24 80 00       	push   $0x8024f7
  8001fe:	e8 02 02 00 00       	call   800405 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 30 80 00    	push   0x803000
  80020c:	e8 7e 08 00 00       	call   800a8f <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 30 80 00    	push   0x803000
  80021b:	ff 75 90             	push   -0x70(%ebp)
  80021e:	e8 d4 14 00 00       	call   8016f7 <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 30 80 00    	push   0x803000
  80022e:	e8 5c 08 00 00       	call   800a8f <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	push   -0x70(%ebp)
  800240:	e8 a8 12 00 00       	call   8014ed <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 14 25 80 00       	push   $0x802514
  800253:	6a 25                	push   $0x25
  800255:	68 75 24 80 00       	push   $0x802475
  80025a:	e8 cb 00 00 00       	call   80032a <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 6c 24 80 00       	push   $0x80246c
  800265:	6a 2c                	push   $0x2c
  800267:	68 75 24 80 00       	push   $0x802475
  80026c:	e8 b9 00 00 00       	call   80032a <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 65 29 80 00       	push   $0x802965
  800277:	6a 2f                	push   $0x2f
  800279:	68 75 24 80 00       	push   $0x802475
  80027e:	e8 a7 00 00 00       	call   80032a <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	push   -0x74(%ebp)
  800289:	e8 5f 12 00 00       	call   8014ed <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 2b 25 80 00       	push   $0x80252b
  800299:	e8 67 01 00 00       	call   800405 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 2d 25 80 00       	push   $0x80252d
  8002a8:	ff 75 90             	push   -0x70(%ebp)
  8002ab:	e8 47 14 00 00       	call   8016f7 <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 2f 25 80 00       	push   $0x80252f
  8002c0:	e8 40 01 00 00       	call   800405 <cprintf>
		exit();
  8002c5:	e8 4e 00 00 00       	call   800318 <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002dd:	e8 a6 0b 00 00       	call   800e88 <sys_getenvid>
  8002e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ef:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7e 07                	jle    8002ff <libmain+0x2d>
		binaryname = argv[0];
  8002f8:	8b 06                	mov    (%esi),%eax
  8002fa:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	e8 2a fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800309:	e8 0a 00 00 00       	call   800318 <exit>
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80031e:	6a 00                	push   $0x0
  800320:	e8 22 0b 00 00       	call   800e47 <sys_env_destroy>
}
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800332:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800338:	e8 4b 0b 00 00       	call   800e88 <sys_getenvid>
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 0c             	push   0xc(%ebp)
  800343:	ff 75 08             	push   0x8(%ebp)
  800346:	56                   	push   %esi
  800347:	50                   	push   %eax
  800348:	68 b0 25 80 00       	push   $0x8025b0
  80034d:	e8 b3 00 00 00       	call   800405 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800352:	83 c4 18             	add    $0x18,%esp
  800355:	53                   	push   %ebx
  800356:	ff 75 10             	push   0x10(%ebp)
  800359:	e8 56 00 00 00       	call   8003b4 <vcprintf>
	cprintf("\n");
  80035e:	c7 04 24 2f 2b 80 00 	movl   $0x802b2f,(%esp)
  800365:	e8 9b 00 00 00       	call   800405 <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036d:	cc                   	int3   
  80036e:	eb fd                	jmp    80036d <_panic+0x43>

00800370 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	53                   	push   %ebx
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037a:	8b 13                	mov    (%ebx),%edx
  80037c:	8d 42 01             	lea    0x1(%edx),%eax
  80037f:	89 03                	mov    %eax,(%ebx)
  800381:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800384:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800388:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038d:	74 09                	je     800398 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800396:	c9                   	leave  
  800397:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	68 ff 00 00 00       	push   $0xff
  8003a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 61 0a 00 00       	call   800e0a <sys_cputs>
		b->idx = 0;
  8003a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	eb db                	jmp    80038f <putch+0x1f>

008003b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c4:	00 00 00 
	b.cnt = 0;
  8003c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d1:	ff 75 0c             	push   0xc(%ebp)
  8003d4:	ff 75 08             	push   0x8(%ebp)
  8003d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	68 70 03 80 00       	push   $0x800370
  8003e3:	e8 14 01 00 00       	call   8004fc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e8:	83 c4 08             	add    $0x8,%esp
  8003eb:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8003f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f7:	50                   	push   %eax
  8003f8:	e8 0d 0a 00 00       	call   800e0a <sys_cputs>

	return b.cnt;
}
  8003fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800403:	c9                   	leave  
  800404:	c3                   	ret    

00800405 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040e:	50                   	push   %eax
  80040f:	ff 75 08             	push   0x8(%ebp)
  800412:	e8 9d ff ff ff       	call   8003b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	57                   	push   %edi
  80041d:	56                   	push   %esi
  80041e:	53                   	push   %ebx
  80041f:	83 ec 1c             	sub    $0x1c,%esp
  800422:	89 c7                	mov    %eax,%edi
  800424:	89 d6                	mov    %edx,%esi
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042c:	89 d1                	mov    %edx,%ecx
  80042e:	89 c2                	mov    %eax,%edx
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800436:	8b 45 10             	mov    0x10(%ebp),%eax
  800439:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800446:	39 c2                	cmp    %eax,%edx
  800448:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80044b:	72 3e                	jb     80048b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	ff 75 18             	push   0x18(%ebp)
  800453:	83 eb 01             	sub    $0x1,%ebx
  800456:	53                   	push   %ebx
  800457:	50                   	push   %eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 e4             	push   -0x1c(%ebp)
  80045e:	ff 75 e0             	push   -0x20(%ebp)
  800461:	ff 75 dc             	push   -0x24(%ebp)
  800464:	ff 75 d8             	push   -0x28(%ebp)
  800467:	e8 b4 1d 00 00       	call   802220 <__udivdi3>
  80046c:	83 c4 18             	add    $0x18,%esp
  80046f:	52                   	push   %edx
  800470:	50                   	push   %eax
  800471:	89 f2                	mov    %esi,%edx
  800473:	89 f8                	mov    %edi,%eax
  800475:	e8 9f ff ff ff       	call   800419 <printnum>
  80047a:	83 c4 20             	add    $0x20,%esp
  80047d:	eb 13                	jmp    800492 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	56                   	push   %esi
  800483:	ff 75 18             	push   0x18(%ebp)
  800486:	ff d7                	call   *%edi
  800488:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80048b:	83 eb 01             	sub    $0x1,%ebx
  80048e:	85 db                	test   %ebx,%ebx
  800490:	7f ed                	jg     80047f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	56                   	push   %esi
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	ff 75 e4             	push   -0x1c(%ebp)
  80049c:	ff 75 e0             	push   -0x20(%ebp)
  80049f:	ff 75 dc             	push   -0x24(%ebp)
  8004a2:	ff 75 d8             	push   -0x28(%ebp)
  8004a5:	e8 96 1e 00 00       	call   802340 <__umoddi3>
  8004aa:	83 c4 14             	add    $0x14,%esp
  8004ad:	0f be 80 d3 25 80 00 	movsbl 0x8025d3(%eax),%eax
  8004b4:	50                   	push   %eax
  8004b5:	ff d7                	call   *%edi
}
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bd:	5b                   	pop    %ebx
  8004be:	5e                   	pop    %esi
  8004bf:	5f                   	pop    %edi
  8004c0:	5d                   	pop    %ebp
  8004c1:	c3                   	ret    

008004c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004cc:	8b 10                	mov    (%eax),%edx
  8004ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d1:	73 0a                	jae    8004dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d6:	89 08                	mov    %ecx,(%eax)
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	88 02                	mov    %al,(%edx)
}
  8004dd:	5d                   	pop    %ebp
  8004de:	c3                   	ret    

008004df <printfmt>:
{
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e8:	50                   	push   %eax
  8004e9:	ff 75 10             	push   0x10(%ebp)
  8004ec:	ff 75 0c             	push   0xc(%ebp)
  8004ef:	ff 75 08             	push   0x8(%ebp)
  8004f2:	e8 05 00 00 00       	call   8004fc <vprintfmt>
}
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <vprintfmt>:
{
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	57                   	push   %edi
  800500:	56                   	push   %esi
  800501:	53                   	push   %ebx
  800502:	83 ec 3c             	sub    $0x3c,%esp
  800505:	8b 75 08             	mov    0x8(%ebp),%esi
  800508:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050e:	eb 0a                	jmp    80051a <vprintfmt+0x1e>
			putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	50                   	push   %eax
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051a:	83 c7 01             	add    $0x1,%edi
  80051d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800521:	83 f8 25             	cmp    $0x25,%eax
  800524:	74 0c                	je     800532 <vprintfmt+0x36>
			if (ch == '\0')
  800526:	85 c0                	test   %eax,%eax
  800528:	75 e6                	jne    800510 <vprintfmt+0x14>
}
  80052a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80052d:	5b                   	pop    %ebx
  80052e:	5e                   	pop    %esi
  80052f:	5f                   	pop    %edi
  800530:	5d                   	pop    %ebp
  800531:	c3                   	ret    
		padc = ' ';
  800532:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800536:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80053d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800544:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80054b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8d 47 01             	lea    0x1(%edi),%eax
  800553:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800556:	0f b6 17             	movzbl (%edi),%edx
  800559:	8d 42 dd             	lea    -0x23(%edx),%eax
  80055c:	3c 55                	cmp    $0x55,%al
  80055e:	0f 87 a6 04 00 00    	ja     800a0a <vprintfmt+0x50e>
  800564:	0f b6 c0             	movzbl %al,%eax
  800567:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  80056e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800571:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800575:	eb d9                	jmp    800550 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800577:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80057a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80057e:	eb d0                	jmp    800550 <vprintfmt+0x54>
  800580:	0f b6 d2             	movzbl %dl,%edx
  800583:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800586:	b8 00 00 00 00       	mov    $0x0,%eax
  80058b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80058e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800591:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800595:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800598:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80059b:	83 f9 09             	cmp    $0x9,%ecx
  80059e:	77 55                	ja     8005f5 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005a3:	eb e9                	jmp    80058e <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005bd:	79 91                	jns    800550 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005cc:	eb 82                	jmp    800550 <vprintfmt+0x54>
  8005ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d1:	85 d2                	test   %edx,%edx
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	0f 49 c2             	cmovns %edx,%eax
  8005db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005e1:	e9 6a ff ff ff       	jmp    800550 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8005e9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005f0:	e9 5b ff ff ff       	jmp    800550 <vprintfmt+0x54>
  8005f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005fb:	eb bc                	jmp    8005b9 <vprintfmt+0xbd>
			lflag++;
  8005fd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800600:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800603:	e9 48 ff ff ff       	jmp    800550 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 78 04             	lea    0x4(%eax),%edi
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	ff 30                	push   (%eax)
  800614:	ff d6                	call   *%esi
			break;
  800616:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800619:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80061c:	e9 88 03 00 00       	jmp    8009a9 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 78 04             	lea    0x4(%eax),%edi
  800627:	8b 10                	mov    (%eax),%edx
  800629:	89 d0                	mov    %edx,%eax
  80062b:	f7 d8                	neg    %eax
  80062d:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800630:	83 f8 0f             	cmp    $0xf,%eax
  800633:	7f 23                	jg     800658 <vprintfmt+0x15c>
  800635:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  80063c:	85 d2                	test   %edx,%edx
  80063e:	74 18                	je     800658 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800640:	52                   	push   %edx
  800641:	68 55 2a 80 00       	push   $0x802a55
  800646:	53                   	push   %ebx
  800647:	56                   	push   %esi
  800648:	e8 92 fe ff ff       	call   8004df <printfmt>
  80064d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800650:	89 7d 14             	mov    %edi,0x14(%ebp)
  800653:	e9 51 03 00 00       	jmp    8009a9 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800658:	50                   	push   %eax
  800659:	68 eb 25 80 00       	push   $0x8025eb
  80065e:	53                   	push   %ebx
  80065f:	56                   	push   %esi
  800660:	e8 7a fe ff ff       	call   8004df <printfmt>
  800665:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800668:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80066b:	e9 39 03 00 00       	jmp    8009a9 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	83 c0 04             	add    $0x4,%eax
  800676:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80067e:	85 d2                	test   %edx,%edx
  800680:	b8 e4 25 80 00       	mov    $0x8025e4,%eax
  800685:	0f 45 c2             	cmovne %edx,%eax
  800688:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80068b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80068f:	7e 06                	jle    800697 <vprintfmt+0x19b>
  800691:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800695:	75 0d                	jne    8006a4 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80069a:	89 c7                	mov    %eax,%edi
  80069c:	03 45 d4             	add    -0x2c(%ebp),%eax
  80069f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006a2:	eb 55                	jmp    8006f9 <vprintfmt+0x1fd>
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 e0             	push   -0x20(%ebp)
  8006aa:	ff 75 cc             	push   -0x34(%ebp)
  8006ad:	e8 f5 03 00 00       	call   800aa7 <strnlen>
  8006b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b5:	29 c2                	sub    %eax,%edx
  8006b7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006bf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c6:	eb 0f                	jmp    8006d7 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	ff 75 d4             	push   -0x2c(%ebp)
  8006cf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	83 ef 01             	sub    $0x1,%edi
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	85 ff                	test   %edi,%edi
  8006d9:	7f ed                	jg     8006c8 <vprintfmt+0x1cc>
  8006db:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006de:	85 d2                	test   %edx,%edx
  8006e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e5:	0f 49 c2             	cmovns %edx,%eax
  8006e8:	29 c2                	sub    %eax,%edx
  8006ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ed:	eb a8                	jmp    800697 <vprintfmt+0x19b>
					putch(ch, putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	52                   	push   %edx
  8006f4:	ff d6                	call   *%esi
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006fc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fe:	83 c7 01             	add    $0x1,%edi
  800701:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800705:	0f be d0             	movsbl %al,%edx
  800708:	85 d2                	test   %edx,%edx
  80070a:	74 4b                	je     800757 <vprintfmt+0x25b>
  80070c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800710:	78 06                	js     800718 <vprintfmt+0x21c>
  800712:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800716:	78 1e                	js     800736 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800718:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80071c:	74 d1                	je     8006ef <vprintfmt+0x1f3>
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 e8 20             	sub    $0x20,%eax
  800724:	83 f8 5e             	cmp    $0x5e,%eax
  800727:	76 c6                	jbe    8006ef <vprintfmt+0x1f3>
					putch('?', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 3f                	push   $0x3f
  80072f:	ff d6                	call   *%esi
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	eb c3                	jmp    8006f9 <vprintfmt+0x1fd>
  800736:	89 cf                	mov    %ecx,%edi
  800738:	eb 0e                	jmp    800748 <vprintfmt+0x24c>
				putch(' ', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 20                	push   $0x20
  800740:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800742:	83 ef 01             	sub    $0x1,%edi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	85 ff                	test   %edi,%edi
  80074a:	7f ee                	jg     80073a <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80074c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	e9 52 02 00 00       	jmp    8009a9 <vprintfmt+0x4ad>
  800757:	89 cf                	mov    %ecx,%edi
  800759:	eb ed                	jmp    800748 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	83 c0 04             	add    $0x4,%eax
  800761:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800769:	85 d2                	test   %edx,%edx
  80076b:	b8 e4 25 80 00       	mov    $0x8025e4,%eax
  800770:	0f 45 c2             	cmovne %edx,%eax
  800773:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800776:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80077a:	7e 06                	jle    800782 <vprintfmt+0x286>
  80077c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800780:	75 0d                	jne    80078f <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800785:	89 c7                	mov    %eax,%edi
  800787:	03 45 d4             	add    -0x2c(%ebp),%eax
  80078a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80078d:	eb 55                	jmp    8007e4 <vprintfmt+0x2e8>
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 e0             	push   -0x20(%ebp)
  800795:	ff 75 cc             	push   -0x34(%ebp)
  800798:	e8 0a 03 00 00       	call   800aa7 <strnlen>
  80079d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a0:	29 c2                	sub    %eax,%edx
  8007a2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007aa:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b1:	eb 0f                	jmp    8007c2 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	ff 75 d4             	push   -0x2c(%ebp)
  8007ba:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bc:	83 ef 01             	sub    $0x1,%edi
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	85 ff                	test   %edi,%edi
  8007c4:	7f ed                	jg     8007b3 <vprintfmt+0x2b7>
  8007c6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d0:	0f 49 c2             	cmovns %edx,%eax
  8007d3:	29 c2                	sub    %eax,%edx
  8007d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007d8:	eb a8                	jmp    800782 <vprintfmt+0x286>
					putch(ch, putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	53                   	push   %ebx
  8007de:	52                   	push   %edx
  8007df:	ff d6                	call   *%esi
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007e7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8007e9:	83 c7 01             	add    $0x1,%edi
  8007ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f0:	0f be d0             	movsbl %al,%edx
  8007f3:	3c 3a                	cmp    $0x3a,%al
  8007f5:	74 4b                	je     800842 <vprintfmt+0x346>
  8007f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007fb:	78 06                	js     800803 <vprintfmt+0x307>
  8007fd:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800801:	78 1e                	js     800821 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800803:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800807:	74 d1                	je     8007da <vprintfmt+0x2de>
  800809:	0f be c0             	movsbl %al,%eax
  80080c:	83 e8 20             	sub    $0x20,%eax
  80080f:	83 f8 5e             	cmp    $0x5e,%eax
  800812:	76 c6                	jbe    8007da <vprintfmt+0x2de>
					putch('?', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	53                   	push   %ebx
  800818:	6a 3f                	push   $0x3f
  80081a:	ff d6                	call   *%esi
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	eb c3                	jmp    8007e4 <vprintfmt+0x2e8>
  800821:	89 cf                	mov    %ecx,%edi
  800823:	eb 0e                	jmp    800833 <vprintfmt+0x337>
				putch(' ', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	6a 20                	push   $0x20
  80082b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80082d:	83 ef 01             	sub    $0x1,%edi
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	85 ff                	test   %edi,%edi
  800835:	7f ee                	jg     800825 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800837:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
  80083d:	e9 67 01 00 00       	jmp    8009a9 <vprintfmt+0x4ad>
  800842:	89 cf                	mov    %ecx,%edi
  800844:	eb ed                	jmp    800833 <vprintfmt+0x337>
	if (lflag >= 2)
  800846:	83 f9 01             	cmp    $0x1,%ecx
  800849:	7f 1b                	jg     800866 <vprintfmt+0x36a>
	else if (lflag)
  80084b:	85 c9                	test   %ecx,%ecx
  80084d:	74 63                	je     8008b2 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800857:	99                   	cltd   
  800858:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8d 40 04             	lea    0x4(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
  800864:	eb 17                	jmp    80087d <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800871:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 08             	lea    0x8(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80087d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800880:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800883:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800888:	85 c9                	test   %ecx,%ecx
  80088a:	0f 89 ff 00 00 00    	jns    80098f <vprintfmt+0x493>
				putch('-', putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	53                   	push   %ebx
  800894:	6a 2d                	push   $0x2d
  800896:	ff d6                	call   *%esi
				num = -(long long) num;
  800898:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80089e:	f7 da                	neg    %edx
  8008a0:	83 d1 00             	adc    $0x0,%ecx
  8008a3:	f7 d9                	neg    %ecx
  8008a5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008a8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ad:	e9 dd 00 00 00       	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ba:	99                   	cltd   
  8008bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8d 40 04             	lea    0x4(%eax),%eax
  8008c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c7:	eb b4                	jmp    80087d <vprintfmt+0x381>
	if (lflag >= 2)
  8008c9:	83 f9 01             	cmp    $0x1,%ecx
  8008cc:	7f 1e                	jg     8008ec <vprintfmt+0x3f0>
	else if (lflag)
  8008ce:	85 c9                	test   %ecx,%ecx
  8008d0:	74 32                	je     800904 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e2:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8008e7:	e9 a3 00 00 00       	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 10                	mov    (%eax),%edx
  8008f1:	8b 48 04             	mov    0x4(%eax),%ecx
  8008f4:	8d 40 08             	lea    0x8(%eax),%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fa:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8008ff:	e9 8b 00 00 00       	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 10                	mov    (%eax),%edx
  800909:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090e:	8d 40 04             	lea    0x4(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800914:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800919:	eb 74                	jmp    80098f <vprintfmt+0x493>
	if (lflag >= 2)
  80091b:	83 f9 01             	cmp    $0x1,%ecx
  80091e:	7f 1b                	jg     80093b <vprintfmt+0x43f>
	else if (lflag)
  800920:	85 c9                	test   %ecx,%ecx
  800922:	74 2c                	je     800950 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092e:	8d 40 04             	lea    0x4(%eax),%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800934:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800939:	eb 54                	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8b 10                	mov    (%eax),%edx
  800940:	8b 48 04             	mov    0x4(%eax),%ecx
  800943:	8d 40 08             	lea    0x8(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800949:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80094e:	eb 3f                	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 10                	mov    (%eax),%edx
  800955:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095a:	8d 40 04             	lea    0x4(%eax),%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800960:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800965:	eb 28                	jmp    80098f <vprintfmt+0x493>
			putch('0', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 30                	push   $0x30
  80096d:	ff d6                	call   *%esi
			putch('x', putdat);
  80096f:	83 c4 08             	add    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 78                	push   $0x78
  800975:	ff d6                	call   *%esi
			num = (unsigned long long)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8b 10                	mov    (%eax),%edx
  80097c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800981:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800984:	8d 40 04             	lea    0x4(%eax),%eax
  800987:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098a:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80098f:	83 ec 0c             	sub    $0xc,%esp
  800992:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800996:	50                   	push   %eax
  800997:	ff 75 d4             	push   -0x2c(%ebp)
  80099a:	57                   	push   %edi
  80099b:	51                   	push   %ecx
  80099c:	52                   	push   %edx
  80099d:	89 da                	mov    %ebx,%edx
  80099f:	89 f0                	mov    %esi,%eax
  8009a1:	e8 73 fa ff ff       	call   800419 <printnum>
			break;
  8009a6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009a9:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ac:	e9 69 fb ff ff       	jmp    80051a <vprintfmt+0x1e>
	if (lflag >= 2)
  8009b1:	83 f9 01             	cmp    $0x1,%ecx
  8009b4:	7f 1b                	jg     8009d1 <vprintfmt+0x4d5>
	else if (lflag)
  8009b6:	85 c9                	test   %ecx,%ecx
  8009b8:	74 2c                	je     8009e6 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8b 10                	mov    (%eax),%edx
  8009bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009c4:	8d 40 04             	lea    0x4(%eax),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ca:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009cf:	eb be                	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	8b 10                	mov    (%eax),%edx
  8009d6:	8b 48 04             	mov    0x4(%eax),%ecx
  8009d9:	8d 40 08             	lea    0x8(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009df:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009e4:	eb a9                	jmp    80098f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8b 10                	mov    (%eax),%edx
  8009eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f0:	8d 40 04             	lea    0x4(%eax),%eax
  8009f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f6:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8009fb:	eb 92                	jmp    80098f <vprintfmt+0x493>
			putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	6a 25                	push   $0x25
  800a03:	ff d6                	call   *%esi
			break;
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	eb 9f                	jmp    8009a9 <vprintfmt+0x4ad>
			putch('%', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	53                   	push   %ebx
  800a0e:	6a 25                	push   $0x25
  800a10:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 f8                	mov    %edi,%eax
  800a17:	eb 03                	jmp    800a1c <vprintfmt+0x520>
  800a19:	83 e8 01             	sub    $0x1,%eax
  800a1c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a20:	75 f7                	jne    800a19 <vprintfmt+0x51d>
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	eb 82                	jmp    8009a9 <vprintfmt+0x4ad>

00800a27 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a36:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a3a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a44:	85 c0                	test   %eax,%eax
  800a46:	74 26                	je     800a6e <vsnprintf+0x47>
  800a48:	85 d2                	test   %edx,%edx
  800a4a:	7e 22                	jle    800a6e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a4c:	ff 75 14             	push   0x14(%ebp)
  800a4f:	ff 75 10             	push   0x10(%ebp)
  800a52:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a55:	50                   	push   %eax
  800a56:	68 c2 04 80 00       	push   $0x8004c2
  800a5b:	e8 9c fa ff ff       	call   8004fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a63:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a69:	83 c4 10             	add    $0x10,%esp
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    
		return -E_INVAL;
  800a6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a73:	eb f7                	jmp    800a6c <vsnprintf+0x45>

00800a75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 10             	push   0x10(%ebp)
  800a82:	ff 75 0c             	push   0xc(%ebp)
  800a85:	ff 75 08             	push   0x8(%ebp)
  800a88:	e8 9a ff ff ff       	call   800a27 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	eb 03                	jmp    800a9f <strlen+0x10>
		n++;
  800a9c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a9f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa3:	75 f7                	jne    800a9c <strlen+0xd>
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb 03                	jmp    800aba <strnlen+0x13>
		n++;
  800ab7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aba:	39 d0                	cmp    %edx,%eax
  800abc:	74 08                	je     800ac6 <strnlen+0x1f>
  800abe:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ac2:	75 f3                	jne    800ab7 <strnlen+0x10>
  800ac4:	89 c2                	mov    %eax,%edx
	return n;
}
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	53                   	push   %ebx
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad9:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800add:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800ae0:	83 c0 01             	add    $0x1,%eax
  800ae3:	84 d2                	test   %dl,%dl
  800ae5:	75 f2                	jne    800ad9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ae7:	89 c8                	mov    %ecx,%eax
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	53                   	push   %ebx
  800af2:	83 ec 10             	sub    $0x10,%esp
  800af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800af8:	53                   	push   %ebx
  800af9:	e8 91 ff ff ff       	call   800a8f <strlen>
  800afe:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b01:	ff 75 0c             	push   0xc(%ebp)
  800b04:	01 d8                	add    %ebx,%eax
  800b06:	50                   	push   %eax
  800b07:	e8 be ff ff ff       	call   800aca <strcpy>
	return dst;
}
  800b0c:	89 d8                	mov    %ebx,%eax
  800b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
  800b18:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	89 f3                	mov    %esi,%ebx
  800b20:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b23:	89 f0                	mov    %esi,%eax
  800b25:	eb 0f                	jmp    800b36 <strncpy+0x23>
		*dst++ = *src;
  800b27:	83 c0 01             	add    $0x1,%eax
  800b2a:	0f b6 0a             	movzbl (%edx),%ecx
  800b2d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b30:	80 f9 01             	cmp    $0x1,%cl
  800b33:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b36:	39 d8                	cmp    %ebx,%eax
  800b38:	75 ed                	jne    800b27 <strncpy+0x14>
	}
	return ret;
}
  800b3a:	89 f0                	mov    %esi,%eax
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	8b 75 08             	mov    0x8(%ebp),%esi
  800b48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b4e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b50:	85 d2                	test   %edx,%edx
  800b52:	74 21                	je     800b75 <strlcpy+0x35>
  800b54:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b58:	89 f2                	mov    %esi,%edx
  800b5a:	eb 09                	jmp    800b65 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b5c:	83 c1 01             	add    $0x1,%ecx
  800b5f:	83 c2 01             	add    $0x1,%edx
  800b62:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b65:	39 c2                	cmp    %eax,%edx
  800b67:	74 09                	je     800b72 <strlcpy+0x32>
  800b69:	0f b6 19             	movzbl (%ecx),%ebx
  800b6c:	84 db                	test   %bl,%bl
  800b6e:	75 ec                	jne    800b5c <strlcpy+0x1c>
  800b70:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b72:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b75:	29 f0                	sub    %esi,%eax
}
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b84:	eb 06                	jmp    800b8c <strcmp+0x11>
		p++, q++;
  800b86:	83 c1 01             	add    $0x1,%ecx
  800b89:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b8c:	0f b6 01             	movzbl (%ecx),%eax
  800b8f:	84 c0                	test   %al,%al
  800b91:	74 04                	je     800b97 <strcmp+0x1c>
  800b93:	3a 02                	cmp    (%edx),%al
  800b95:	74 ef                	je     800b86 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b97:	0f b6 c0             	movzbl %al,%eax
  800b9a:	0f b6 12             	movzbl (%edx),%edx
  800b9d:	29 d0                	sub    %edx,%eax
}
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	53                   	push   %ebx
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bab:	89 c3                	mov    %eax,%ebx
  800bad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bb0:	eb 06                	jmp    800bb8 <strncmp+0x17>
		n--, p++, q++;
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bb8:	39 d8                	cmp    %ebx,%eax
  800bba:	74 18                	je     800bd4 <strncmp+0x33>
  800bbc:	0f b6 08             	movzbl (%eax),%ecx
  800bbf:	84 c9                	test   %cl,%cl
  800bc1:	74 04                	je     800bc7 <strncmp+0x26>
  800bc3:	3a 0a                	cmp    (%edx),%cl
  800bc5:	74 eb                	je     800bb2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc7:	0f b6 00             	movzbl (%eax),%eax
  800bca:	0f b6 12             	movzbl (%edx),%edx
  800bcd:	29 d0                	sub    %edx,%eax
}
  800bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    
		return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	eb f4                	jmp    800bcf <strncmp+0x2e>

00800bdb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be5:	eb 03                	jmp    800bea <strchr+0xf>
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	0f b6 10             	movzbl (%eax),%edx
  800bed:	84 d2                	test   %dl,%dl
  800bef:	74 06                	je     800bf7 <strchr+0x1c>
		if (*s == c)
  800bf1:	38 ca                	cmp    %cl,%dl
  800bf3:	75 f2                	jne    800be7 <strchr+0xc>
  800bf5:	eb 05                	jmp    800bfc <strchr+0x21>
			return (char *) s;
	return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c08:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c0b:	38 ca                	cmp    %cl,%dl
  800c0d:	74 09                	je     800c18 <strfind+0x1a>
  800c0f:	84 d2                	test   %dl,%dl
  800c11:	74 05                	je     800c18 <strfind+0x1a>
	for (; *s; s++)
  800c13:	83 c0 01             	add    $0x1,%eax
  800c16:	eb f0                	jmp    800c08 <strfind+0xa>
			break;
	return (char *) s;
}
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	57                   	push   %edi
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
  800c20:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c26:	85 c9                	test   %ecx,%ecx
  800c28:	74 2f                	je     800c59 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c2a:	89 f8                	mov    %edi,%eax
  800c2c:	09 c8                	or     %ecx,%eax
  800c2e:	a8 03                	test   $0x3,%al
  800c30:	75 21                	jne    800c53 <memset+0x39>
		c &= 0xFF;
  800c32:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c36:	89 d0                	mov    %edx,%eax
  800c38:	c1 e0 08             	shl    $0x8,%eax
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	c1 e3 18             	shl    $0x18,%ebx
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	c1 e6 10             	shl    $0x10,%esi
  800c45:	09 f3                	or     %esi,%ebx
  800c47:	09 da                	or     %ebx,%edx
  800c49:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c4b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c4e:	fc                   	cld    
  800c4f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c51:	eb 06                	jmp    800c59 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	fc                   	cld    
  800c57:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c59:	89 f8                	mov    %edi,%eax
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c6e:	39 c6                	cmp    %eax,%esi
  800c70:	73 32                	jae    800ca4 <memmove+0x44>
  800c72:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c75:	39 c2                	cmp    %eax,%edx
  800c77:	76 2b                	jbe    800ca4 <memmove+0x44>
		s += n;
		d += n;
  800c79:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7c:	89 d6                	mov    %edx,%esi
  800c7e:	09 fe                	or     %edi,%esi
  800c80:	09 ce                	or     %ecx,%esi
  800c82:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c88:	75 0e                	jne    800c98 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c8a:	83 ef 04             	sub    $0x4,%edi
  800c8d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c90:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c93:	fd                   	std    
  800c94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c96:	eb 09                	jmp    800ca1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c98:	83 ef 01             	sub    $0x1,%edi
  800c9b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c9e:	fd                   	std    
  800c9f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ca1:	fc                   	cld    
  800ca2:	eb 1a                	jmp    800cbe <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca4:	89 f2                	mov    %esi,%edx
  800ca6:	09 c2                	or     %eax,%edx
  800ca8:	09 ca                	or     %ecx,%edx
  800caa:	f6 c2 03             	test   $0x3,%dl
  800cad:	75 0a                	jne    800cb9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800caf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cb2:	89 c7                	mov    %eax,%edi
  800cb4:	fc                   	cld    
  800cb5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb7:	eb 05                	jmp    800cbe <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cb9:	89 c7                	mov    %eax,%edi
  800cbb:	fc                   	cld    
  800cbc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc8:	ff 75 10             	push   0x10(%ebp)
  800ccb:	ff 75 0c             	push   0xc(%ebp)
  800cce:	ff 75 08             	push   0x8(%ebp)
  800cd1:	e8 8a ff ff ff       	call   800c60 <memmove>
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	89 c6                	mov    %eax,%esi
  800ce5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce8:	eb 06                	jmp    800cf0 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cea:	83 c0 01             	add    $0x1,%eax
  800ced:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800cf0:	39 f0                	cmp    %esi,%eax
  800cf2:	74 14                	je     800d08 <memcmp+0x30>
		if (*s1 != *s2)
  800cf4:	0f b6 08             	movzbl (%eax),%ecx
  800cf7:	0f b6 1a             	movzbl (%edx),%ebx
  800cfa:	38 d9                	cmp    %bl,%cl
  800cfc:	74 ec                	je     800cea <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800cfe:	0f b6 c1             	movzbl %cl,%eax
  800d01:	0f b6 db             	movzbl %bl,%ebx
  800d04:	29 d8                	sub    %ebx,%eax
  800d06:	eb 05                	jmp    800d0d <memcmp+0x35>
	}

	return 0;
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d1a:	89 c2                	mov    %eax,%edx
  800d1c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d1f:	eb 03                	jmp    800d24 <memfind+0x13>
  800d21:	83 c0 01             	add    $0x1,%eax
  800d24:	39 d0                	cmp    %edx,%eax
  800d26:	73 04                	jae    800d2c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d28:	38 08                	cmp    %cl,(%eax)
  800d2a:	75 f5                	jne    800d21 <memfind+0x10>
			break;
	return (void *) s;
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3a:	eb 03                	jmp    800d3f <strtol+0x11>
		s++;
  800d3c:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d3f:	0f b6 02             	movzbl (%edx),%eax
  800d42:	3c 20                	cmp    $0x20,%al
  800d44:	74 f6                	je     800d3c <strtol+0xe>
  800d46:	3c 09                	cmp    $0x9,%al
  800d48:	74 f2                	je     800d3c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d4a:	3c 2b                	cmp    $0x2b,%al
  800d4c:	74 2a                	je     800d78 <strtol+0x4a>
	int neg = 0;
  800d4e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d53:	3c 2d                	cmp    $0x2d,%al
  800d55:	74 2b                	je     800d82 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d57:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d5d:	75 0f                	jne    800d6e <strtol+0x40>
  800d5f:	80 3a 30             	cmpb   $0x30,(%edx)
  800d62:	74 28                	je     800d8c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6b:	0f 44 d8             	cmove  %eax,%ebx
  800d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d73:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d76:	eb 46                	jmp    800dbe <strtol+0x90>
		s++;
  800d78:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d80:	eb d5                	jmp    800d57 <strtol+0x29>
		s++, neg = 1;
  800d82:	83 c2 01             	add    $0x1,%edx
  800d85:	bf 01 00 00 00       	mov    $0x1,%edi
  800d8a:	eb cb                	jmp    800d57 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8c:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d90:	74 0e                	je     800da0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	75 d8                	jne    800d6e <strtol+0x40>
		s++, base = 8;
  800d96:	83 c2 01             	add    $0x1,%edx
  800d99:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d9e:	eb ce                	jmp    800d6e <strtol+0x40>
		s += 2, base = 16;
  800da0:	83 c2 02             	add    $0x2,%edx
  800da3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800da8:	eb c4                	jmp    800d6e <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800daa:	0f be c0             	movsbl %al,%eax
  800dad:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800db0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800db3:	7d 3a                	jge    800def <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800db5:	83 c2 01             	add    $0x1,%edx
  800db8:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dbc:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dbe:	0f b6 02             	movzbl (%edx),%eax
  800dc1:	8d 70 d0             	lea    -0x30(%eax),%esi
  800dc4:	89 f3                	mov    %esi,%ebx
  800dc6:	80 fb 09             	cmp    $0x9,%bl
  800dc9:	76 df                	jbe    800daa <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800dcb:	8d 70 9f             	lea    -0x61(%eax),%esi
  800dce:	89 f3                	mov    %esi,%ebx
  800dd0:	80 fb 19             	cmp    $0x19,%bl
  800dd3:	77 08                	ja     800ddd <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dd5:	0f be c0             	movsbl %al,%eax
  800dd8:	83 e8 57             	sub    $0x57,%eax
  800ddb:	eb d3                	jmp    800db0 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800ddd:	8d 70 bf             	lea    -0x41(%eax),%esi
  800de0:	89 f3                	mov    %esi,%ebx
  800de2:	80 fb 19             	cmp    $0x19,%bl
  800de5:	77 08                	ja     800def <strtol+0xc1>
			dig = *s - 'A' + 10;
  800de7:	0f be c0             	movsbl %al,%eax
  800dea:	83 e8 37             	sub    $0x37,%eax
  800ded:	eb c1                	jmp    800db0 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	74 05                	je     800dfa <strtol+0xcc>
		*endptr = (char *) s;
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dfa:	89 c8                	mov    %ecx,%eax
  800dfc:	f7 d8                	neg    %eax
  800dfe:	85 ff                	test   %edi,%edi
  800e00:	0f 45 c8             	cmovne %eax,%ecx
}
  800e03:	89 c8                	mov    %ecx,%eax
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	89 c3                	mov    %eax,%ebx
  800e1d:	89 c7                	mov    %eax,%edi
  800e1f:	89 c6                	mov    %eax,%esi
  800e21:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e33:	b8 01 00 00 00       	mov    $0x1,%eax
  800e38:	89 d1                	mov    %edx,%ecx
  800e3a:	89 d3                	mov    %edx,%ebx
  800e3c:	89 d7                	mov    %edx,%edi
  800e3e:	89 d6                	mov    %edx,%esi
  800e40:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	b8 03 00 00 00       	mov    $0x3,%eax
  800e5d:	89 cb                	mov    %ecx,%ebx
  800e5f:	89 cf                	mov    %ecx,%edi
  800e61:	89 ce                	mov    %ecx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 03                	push   $0x3
  800e77:	68 df 28 80 00       	push   $0x8028df
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 fc 28 80 00       	push   $0x8028fc
  800e83:	e8 a2 f4 ff ff       	call   80032a <_panic>

00800e88 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e93:	b8 02 00 00 00       	mov    $0x2,%eax
  800e98:	89 d1                	mov    %edx,%ecx
  800e9a:	89 d3                	mov    %edx,%ebx
  800e9c:	89 d7                	mov    %edx,%edi
  800e9e:	89 d6                	mov    %edx,%esi
  800ea0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <sys_yield>:

void
sys_yield(void)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ead:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb7:	89 d1                	mov    %edx,%ecx
  800eb9:	89 d3                	mov    %edx,%ebx
  800ebb:	89 d7                	mov    %edx,%edi
  800ebd:	89 d6                	mov    %edx,%esi
  800ebf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecf:	be 00 00 00 00       	mov    $0x0,%esi
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 04 00 00 00       	mov    $0x4,%eax
  800edf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee2:	89 f7                	mov    %esi,%edi
  800ee4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 04                	push   $0x4
  800ef8:	68 df 28 80 00       	push   $0x8028df
  800efd:	6a 23                	push   $0x23
  800eff:	68 fc 28 80 00       	push   $0x8028fc
  800f04:	e8 21 f4 ff ff       	call   80032a <_panic>

00800f09 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f12:	8b 55 08             	mov    0x8(%ebp),%edx
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	b8 05 00 00 00       	mov    $0x5,%eax
  800f1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f20:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f23:	8b 75 18             	mov    0x18(%ebp),%esi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 05                	push   $0x5
  800f3a:	68 df 28 80 00       	push   $0x8028df
  800f3f:	6a 23                	push   $0x23
  800f41:	68 fc 28 80 00       	push   $0x8028fc
  800f46:	e8 df f3 ff ff       	call   80032a <_panic>

00800f4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 06 00 00 00       	mov    $0x6,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	7f 08                	jg     800f76 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	50                   	push   %eax
  800f7a:	6a 06                	push   $0x6
  800f7c:	68 df 28 80 00       	push   $0x8028df
  800f81:	6a 23                	push   $0x23
  800f83:	68 fc 28 80 00       	push   $0x8028fc
  800f88:	e8 9d f3 ff ff       	call   80032a <_panic>

00800f8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7f 08                	jg     800fb8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	50                   	push   %eax
  800fbc:	6a 08                	push   $0x8
  800fbe:	68 df 28 80 00       	push   $0x8028df
  800fc3:	6a 23                	push   $0x23
  800fc5:	68 fc 28 80 00       	push   $0x8028fc
  800fca:	e8 5b f3 ff ff       	call   80032a <_panic>

00800fcf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe8:	89 df                	mov    %ebx,%edi
  800fea:	89 de                	mov    %ebx,%esi
  800fec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	7f 08                	jg     800ffa <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	50                   	push   %eax
  800ffe:	6a 09                	push   $0x9
  801000:	68 df 28 80 00       	push   $0x8028df
  801005:	6a 23                	push   $0x23
  801007:	68 fc 28 80 00       	push   $0x8028fc
  80100c:	e8 19 f3 ff ff       	call   80032a <_panic>

00801011 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	b8 0a 00 00 00       	mov    $0xa,%eax
  80102a:	89 df                	mov    %ebx,%edi
  80102c:	89 de                	mov    %ebx,%esi
  80102e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801030:	85 c0                	test   %eax,%eax
  801032:	7f 08                	jg     80103c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	50                   	push   %eax
  801040:	6a 0a                	push   $0xa
  801042:	68 df 28 80 00       	push   $0x8028df
  801047:	6a 23                	push   $0x23
  801049:	68 fc 28 80 00       	push   $0x8028fc
  80104e:	e8 d7 f2 ff ff       	call   80032a <_panic>

00801053 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
	asm volatile("int %1\n"
  801059:	8b 55 08             	mov    0x8(%ebp),%edx
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801064:	be 00 00 00 00       	mov    $0x0,%esi
  801069:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80106f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108c:	89 cb                	mov    %ecx,%ebx
  80108e:	89 cf                	mov    %ecx,%edi
  801090:	89 ce                	mov    %ecx,%esi
  801092:	cd 30                	int    $0x30
	if(check && ret > 0)
  801094:	85 c0                	test   %eax,%eax
  801096:	7f 08                	jg     8010a0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a0:	83 ec 0c             	sub    $0xc,%esp
  8010a3:	50                   	push   %eax
  8010a4:	6a 0d                	push   $0xd
  8010a6:	68 df 28 80 00       	push   $0x8028df
  8010ab:	6a 23                	push   $0x23
  8010ad:	68 fc 28 80 00       	push   $0x8028fc
  8010b2:	e8 73 f2 ff ff       	call   80032a <_panic>

008010b7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010c1:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  8010c3:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010c7:	0f 84 99 00 00 00    	je     801166 <pgfault+0xaf>
  8010cd:	89 d8                	mov    %ebx,%eax
  8010cf:	c1 e8 16             	shr    $0x16,%eax
  8010d2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d9:	a8 01                	test   $0x1,%al
  8010db:	0f 84 85 00 00 00    	je     801166 <pgfault+0xaf>
  8010e1:	89 d8                	mov    %ebx,%eax
  8010e3:	c1 e8 0c             	shr    $0xc,%eax
  8010e6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ed:	f6 c6 08             	test   $0x8,%dh
  8010f0:	74 74                	je     801166 <pgfault+0xaf>
  8010f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f9:	a8 01                	test   $0x1,%al
  8010fb:	74 69                	je     801166 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	6a 07                	push   $0x7
  801102:	68 00 f0 7f 00       	push   $0x7ff000
  801107:	6a 00                	push   $0x0
  801109:	e8 b8 fd ff ff       	call   800ec6 <sys_page_alloc>
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	78 65                	js     80117a <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801115:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	68 00 10 00 00       	push   $0x1000
  801123:	53                   	push   %ebx
  801124:	68 00 f0 7f 00       	push   $0x7ff000
  801129:	e8 94 fb ff ff       	call   800cc2 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  80112e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801135:	53                   	push   %ebx
  801136:	6a 00                	push   $0x0
  801138:	68 00 f0 7f 00       	push   $0x7ff000
  80113d:	6a 00                	push   $0x0
  80113f:	e8 c5 fd ff ff       	call   800f09 <sys_page_map>
  801144:	83 c4 20             	add    $0x20,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	78 43                	js     80118e <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	68 00 f0 7f 00       	push   $0x7ff000
  801153:	6a 00                	push   $0x0
  801155:	e8 f1 fd ff ff       	call   800f4b <sys_page_unmap>
  80115a:	83 c4 10             	add    $0x10,%esp
  80115d:	85 c0                	test   %eax,%eax
  80115f:	78 41                	js     8011a2 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  801161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801164:	c9                   	leave  
  801165:	c3                   	ret    
		panic("invalid permision\n");
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	68 0a 29 80 00       	push   $0x80290a
  80116e:	6a 1f                	push   $0x1f
  801170:	68 1d 29 80 00       	push   $0x80291d
  801175:	e8 b0 f1 ff ff       	call   80032a <_panic>
		panic("Unable to alloc page\n");
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	68 28 29 80 00       	push   $0x802928
  801182:	6a 28                	push   $0x28
  801184:	68 1d 29 80 00       	push   $0x80291d
  801189:	e8 9c f1 ff ff       	call   80032a <_panic>
		panic("Unable to map\n");
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	68 3e 29 80 00       	push   $0x80293e
  801196:	6a 2b                	push   $0x2b
  801198:	68 1d 29 80 00       	push   $0x80291d
  80119d:	e8 88 f1 ff ff       	call   80032a <_panic>
		panic("Unable to unmap\n");
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	68 4d 29 80 00       	push   $0x80294d
  8011aa:	6a 2d                	push   $0x2d
  8011ac:	68 1d 29 80 00       	push   $0x80291d
  8011b1:	e8 74 f1 ff ff       	call   80032a <_panic>

008011b6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	57                   	push   %edi
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
  8011bc:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  8011bf:	68 b7 10 80 00       	push   $0x8010b7
  8011c4:	e8 b3 0e 00 00       	call   80207c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011c9:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ce:	cd 30                	int    $0x30
  8011d0:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 23                	js     8011fc <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8011d9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  8011de:	75 6d                	jne    80124d <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011e0:	e8 a3 fc ff ff       	call   800e88 <sys_getenvid>
  8011e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011f2:	a3 00 40 80 00       	mov    %eax,0x804000
		return 0;
  8011f7:	e9 02 01 00 00       	jmp    8012fe <fork+0x148>
		panic("sys_exofork: %e", envid);
  8011fc:	50                   	push   %eax
  8011fd:	68 5e 29 80 00       	push   $0x80295e
  801202:	6a 6d                	push   $0x6d
  801204:	68 1d 29 80 00       	push   $0x80291d
  801209:	e8 1c f1 ff ff       	call   80032a <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80120e:	c1 e0 0c             	shl    $0xc,%eax
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80121a:	52                   	push   %edx
  80121b:	50                   	push   %eax
  80121c:	56                   	push   %esi
  80121d:	50                   	push   %eax
  80121e:	6a 00                	push   $0x0
  801220:	e8 e4 fc ff ff       	call   800f09 <sys_page_map>
  801225:	83 c4 20             	add    $0x20,%esp
  801228:	eb 15                	jmp    80123f <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  80122a:	c1 e0 0c             	shl    $0xc,%eax
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	6a 05                	push   $0x5
  801232:	50                   	push   %eax
  801233:	56                   	push   %esi
  801234:	50                   	push   %eax
  801235:	6a 00                	push   $0x0
  801237:	e8 cd fc ff ff       	call   800f09 <sys_page_map>
  80123c:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80123f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801245:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80124b:	74 7a                	je     8012c7 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	c1 e8 16             	shr    $0x16,%eax
  801252:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801259:	a8 01                	test   $0x1,%al
  80125b:	74 e2                	je     80123f <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	c1 e8 0c             	shr    $0xc,%eax
  801262:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801269:	f6 c2 01             	test   $0x1,%dl
  80126c:	74 d1                	je     80123f <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80126e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801275:	f6 c2 04             	test   $0x4,%dl
  801278:	74 c5                	je     80123f <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80127a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801281:	f6 c6 04             	test   $0x4,%dh
  801284:	75 88                	jne    80120e <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801286:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80128c:	74 9c                	je     80122a <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80128e:	c1 e0 0c             	shl    $0xc,%eax
  801291:	89 c7                	mov    %eax,%edi
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	68 05 08 00 00       	push   $0x805
  80129b:	50                   	push   %eax
  80129c:	56                   	push   %esi
  80129d:	50                   	push   %eax
  80129e:	6a 00                	push   $0x0
  8012a0:	e8 64 fc ff ff       	call   800f09 <sys_page_map>
  8012a5:	83 c4 20             	add    $0x20,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 93                	js     80123f <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	68 05 08 00 00       	push   $0x805
  8012b4:	57                   	push   %edi
  8012b5:	6a 00                	push   $0x0
  8012b7:	57                   	push   %edi
  8012b8:	6a 00                	push   $0x0
  8012ba:	e8 4a fc ff ff       	call   800f09 <sys_page_map>
  8012bf:	83 c4 20             	add    $0x20,%esp
  8012c2:	e9 78 ff ff ff       	jmp    80123f <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	6a 07                	push   $0x7
  8012cc:	68 00 f0 bf ee       	push   $0xeebff000
  8012d1:	56                   	push   %esi
  8012d2:	e8 ef fb ff ff       	call   800ec6 <sys_page_alloc>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 2a                	js     801308 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	68 eb 20 80 00       	push   $0x8020eb
  8012e6:	56                   	push   %esi
  8012e7:	e8 25 fd ff ff       	call   801011 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012ec:	83 c4 08             	add    $0x8,%esp
  8012ef:	6a 02                	push   $0x2
  8012f1:	56                   	push   %esi
  8012f2:	e8 96 fc ff ff       	call   800f8d <sys_env_set_status>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 21                	js     80131f <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5f                   	pop    %edi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    
		panic("failed to alloc page");
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	68 6e 29 80 00       	push   $0x80296e
  801310:	68 82 00 00 00       	push   $0x82
  801315:	68 1d 29 80 00       	push   $0x80291d
  80131a:	e8 0b f0 ff ff       	call   80032a <_panic>
		panic("sys_env_set_status: %e", r);
  80131f:	50                   	push   %eax
  801320:	68 83 29 80 00       	push   $0x802983
  801325:	68 89 00 00 00       	push   $0x89
  80132a:	68 1d 29 80 00       	push   $0x80291d
  80132f:	e8 f6 ef ff ff       	call   80032a <_panic>

00801334 <sfork>:

// Challenge!
int
sfork(void)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80133a:	68 9a 29 80 00       	push   $0x80299a
  80133f:	68 92 00 00 00       	push   $0x92
  801344:	68 1d 29 80 00       	push   $0x80291d
  801349:	e8 dc ef ff ff       	call   80032a <_panic>

0080134e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	05 00 00 00 30       	add    $0x30000000,%eax
  801359:	c1 e8 0c             	shr    $0xc,%eax
}
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801369:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80137d:	89 c2                	mov    %eax,%edx
  80137f:	c1 ea 16             	shr    $0x16,%edx
  801382:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801389:	f6 c2 01             	test   $0x1,%dl
  80138c:	74 29                	je     8013b7 <fd_alloc+0x42>
  80138e:	89 c2                	mov    %eax,%edx
  801390:	c1 ea 0c             	shr    $0xc,%edx
  801393:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139a:	f6 c2 01             	test   $0x1,%dl
  80139d:	74 18                	je     8013b7 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80139f:	05 00 10 00 00       	add    $0x1000,%eax
  8013a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013a9:	75 d2                	jne    80137d <fd_alloc+0x8>
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8013b0:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8013b5:	eb 05                	jmp    8013bc <fd_alloc+0x47>
			return 0;
  8013b7:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	89 02                	mov    %eax,(%edx)
}
  8013c1:	89 c8                	mov    %ecx,%eax
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013cb:	83 f8 1f             	cmp    $0x1f,%eax
  8013ce:	77 30                	ja     801400 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013d0:	c1 e0 0c             	shl    $0xc,%eax
  8013d3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013d8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013de:	f6 c2 01             	test   $0x1,%dl
  8013e1:	74 24                	je     801407 <fd_lookup+0x42>
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	c1 ea 0c             	shr    $0xc,%edx
  8013e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ef:	f6 c2 01             	test   $0x1,%dl
  8013f2:	74 1a                	je     80140e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f7:	89 02                	mov    %eax,(%edx)
	return 0;
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    
		return -E_INVAL;
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801405:	eb f7                	jmp    8013fe <fd_lookup+0x39>
		return -E_INVAL;
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb f0                	jmp    8013fe <fd_lookup+0x39>
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801413:	eb e9                	jmp    8013fe <fd_lookup+0x39>

00801415 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	53                   	push   %ebx
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	8b 55 08             	mov    0x8(%ebp),%edx
  80141f:	b8 2c 2a 80 00       	mov    $0x802a2c,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801424:	bb 08 30 80 00       	mov    $0x803008,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801429:	39 13                	cmp    %edx,(%ebx)
  80142b:	74 32                	je     80145f <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80142d:	83 c0 04             	add    $0x4,%eax
  801430:	8b 18                	mov    (%eax),%ebx
  801432:	85 db                	test   %ebx,%ebx
  801434:	75 f3                	jne    801429 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801436:	a1 00 40 80 00       	mov    0x804000,%eax
  80143b:	8b 40 48             	mov    0x48(%eax),%eax
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	68 b0 29 80 00       	push   $0x8029b0
  801448:	e8 b8 ef ff ff       	call   800405 <cprintf>
	*dev = 0;
	return -E_INVAL;
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	89 1a                	mov    %ebx,(%edx)
}
  80145a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    
			return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
  801464:	eb ef                	jmp    801455 <dev_lookup+0x40>

00801466 <fd_close>:
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	57                   	push   %edi
  80146a:	56                   	push   %esi
  80146b:	53                   	push   %ebx
  80146c:	83 ec 24             	sub    $0x24,%esp
  80146f:	8b 75 08             	mov    0x8(%ebp),%esi
  801472:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801475:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801478:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801479:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80147f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801482:	50                   	push   %eax
  801483:	e8 3d ff ff ff       	call   8013c5 <fd_lookup>
  801488:	89 c3                	mov    %eax,%ebx
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 05                	js     801496 <fd_close+0x30>
	    || fd != fd2)
  801491:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801494:	74 16                	je     8014ac <fd_close+0x46>
		return (must_exist ? r : 0);
  801496:	89 f8                	mov    %edi,%eax
  801498:	84 c0                	test   %al,%al
  80149a:	b8 00 00 00 00       	mov    $0x0,%eax
  80149f:	0f 44 d8             	cmove  %eax,%ebx
}
  8014a2:	89 d8                	mov    %ebx,%eax
  8014a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5f                   	pop    %edi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	ff 36                	push   (%esi)
  8014b5:	e8 5b ff ff ff       	call   801415 <dev_lookup>
  8014ba:	89 c3                	mov    %eax,%ebx
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 1a                	js     8014dd <fd_close+0x77>
		if (dev->dev_close)
  8014c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014c9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	74 0b                	je     8014dd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	56                   	push   %esi
  8014d6:	ff d0                	call   *%eax
  8014d8:	89 c3                	mov    %eax,%ebx
  8014da:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	56                   	push   %esi
  8014e1:	6a 00                	push   $0x0
  8014e3:	e8 63 fa ff ff       	call   800f4b <sys_page_unmap>
	return r;
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	eb b5                	jmp    8014a2 <fd_close+0x3c>

008014ed <close>:

int
close(int fdnum)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 08             	push   0x8(%ebp)
  8014fa:	e8 c6 fe ff ff       	call   8013c5 <fd_lookup>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	79 02                	jns    801508 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    
		return fd_close(fd, 1);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	6a 01                	push   $0x1
  80150d:	ff 75 f4             	push   -0xc(%ebp)
  801510:	e8 51 ff ff ff       	call   801466 <fd_close>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	eb ec                	jmp    801506 <close+0x19>

0080151a <close_all>:

void
close_all(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801521:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	53                   	push   %ebx
  80152a:	e8 be ff ff ff       	call   8014ed <close>
	for (i = 0; i < MAXFD; i++)
  80152f:	83 c3 01             	add    $0x1,%ebx
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	83 fb 20             	cmp    $0x20,%ebx
  801538:	75 ec                	jne    801526 <close_all+0xc>
}
  80153a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	57                   	push   %edi
  801543:	56                   	push   %esi
  801544:	53                   	push   %ebx
  801545:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801548:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	ff 75 08             	push   0x8(%ebp)
  80154f:	e8 71 fe ff ff       	call   8013c5 <fd_lookup>
  801554:	89 c3                	mov    %eax,%ebx
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 7f                	js     8015dc <dup+0x9d>
		return r;
	close(newfdnum);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 0c             	push   0xc(%ebp)
  801563:	e8 85 ff ff ff       	call   8014ed <close>

	newfd = INDEX2FD(newfdnum);
  801568:	8b 75 0c             	mov    0xc(%ebp),%esi
  80156b:	c1 e6 0c             	shl    $0xc,%esi
  80156e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801577:	89 3c 24             	mov    %edi,(%esp)
  80157a:	e8 df fd ff ff       	call   80135e <fd2data>
  80157f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801581:	89 34 24             	mov    %esi,(%esp)
  801584:	e8 d5 fd ff ff       	call   80135e <fd2data>
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	c1 e8 16             	shr    $0x16,%eax
  801594:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80159b:	a8 01                	test   $0x1,%al
  80159d:	74 11                	je     8015b0 <dup+0x71>
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	c1 e8 0c             	shr    $0xc,%eax
  8015a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015ab:	f6 c2 01             	test   $0x1,%dl
  8015ae:	75 36                	jne    8015e6 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b0:	89 f8                	mov    %edi,%eax
  8015b2:	c1 e8 0c             	shr    $0xc,%eax
  8015b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c4:	50                   	push   %eax
  8015c5:	56                   	push   %esi
  8015c6:	6a 00                	push   $0x0
  8015c8:	57                   	push   %edi
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 39 f9 ff ff       	call   800f09 <sys_page_map>
  8015d0:	89 c3                	mov    %eax,%ebx
  8015d2:	83 c4 20             	add    $0x20,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 33                	js     80160c <dup+0xcd>
		goto err;

	return newfdnum;
  8015d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5f                   	pop    %edi
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f5:	50                   	push   %eax
  8015f6:	ff 75 d4             	push   -0x2c(%ebp)
  8015f9:	6a 00                	push   $0x0
  8015fb:	53                   	push   %ebx
  8015fc:	6a 00                	push   $0x0
  8015fe:	e8 06 f9 ff ff       	call   800f09 <sys_page_map>
  801603:	89 c3                	mov    %eax,%ebx
  801605:	83 c4 20             	add    $0x20,%esp
  801608:	85 c0                	test   %eax,%eax
  80160a:	79 a4                	jns    8015b0 <dup+0x71>
	sys_page_unmap(0, newfd);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	56                   	push   %esi
  801610:	6a 00                	push   $0x0
  801612:	e8 34 f9 ff ff       	call   800f4b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801617:	83 c4 08             	add    $0x8,%esp
  80161a:	ff 75 d4             	push   -0x2c(%ebp)
  80161d:	6a 00                	push   $0x0
  80161f:	e8 27 f9 ff ff       	call   800f4b <sys_page_unmap>
	return r;
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	eb b3                	jmp    8015dc <dup+0x9d>

00801629 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	56                   	push   %esi
  80162d:	53                   	push   %ebx
  80162e:	83 ec 18             	sub    $0x18,%esp
  801631:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801634:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	56                   	push   %esi
  801639:	e8 87 fd ff ff       	call   8013c5 <fd_lookup>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 3c                	js     801681 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801645:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164e:	50                   	push   %eax
  80164f:	ff 33                	push   (%ebx)
  801651:	e8 bf fd ff ff       	call   801415 <dev_lookup>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 24                	js     801681 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80165d:	8b 43 08             	mov    0x8(%ebx),%eax
  801660:	83 e0 03             	and    $0x3,%eax
  801663:	83 f8 01             	cmp    $0x1,%eax
  801666:	74 20                	je     801688 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166b:	8b 40 08             	mov    0x8(%eax),%eax
  80166e:	85 c0                	test   %eax,%eax
  801670:	74 37                	je     8016a9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	ff 75 10             	push   0x10(%ebp)
  801678:	ff 75 0c             	push   0xc(%ebp)
  80167b:	53                   	push   %ebx
  80167c:	ff d0                	call   *%eax
  80167e:	83 c4 10             	add    $0x10,%esp
}
  801681:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801688:	a1 00 40 80 00       	mov    0x804000,%eax
  80168d:	8b 40 48             	mov    0x48(%eax),%eax
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	56                   	push   %esi
  801694:	50                   	push   %eax
  801695:	68 f1 29 80 00       	push   $0x8029f1
  80169a:	e8 66 ed ff ff       	call   800405 <cprintf>
		return -E_INVAL;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a7:	eb d8                	jmp    801681 <read+0x58>
		return -E_NOT_SUPP;
  8016a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ae:	eb d1                	jmp    801681 <read+0x58>

008016b0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c4:	eb 02                	jmp    8016c8 <readn+0x18>
  8016c6:	01 c3                	add    %eax,%ebx
  8016c8:	39 f3                	cmp    %esi,%ebx
  8016ca:	73 21                	jae    8016ed <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	29 d8                	sub    %ebx,%eax
  8016d3:	50                   	push   %eax
  8016d4:	89 d8                	mov    %ebx,%eax
  8016d6:	03 45 0c             	add    0xc(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	57                   	push   %edi
  8016db:	e8 49 ff ff ff       	call   801629 <read>
		if (m < 0)
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 04                	js     8016eb <readn+0x3b>
			return m;
		if (m == 0)
  8016e7:	75 dd                	jne    8016c6 <readn+0x16>
  8016e9:	eb 02                	jmp    8016ed <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	56                   	push   %esi
  8016fb:	53                   	push   %ebx
  8016fc:	83 ec 18             	sub    $0x18,%esp
  8016ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801702:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801705:	50                   	push   %eax
  801706:	53                   	push   %ebx
  801707:	e8 b9 fc ff ff       	call   8013c5 <fd_lookup>
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 37                	js     80174a <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801713:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	ff 36                	push   (%esi)
  80171f:	e8 f1 fc ff ff       	call   801415 <dev_lookup>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	85 c0                	test   %eax,%eax
  801729:	78 1f                	js     80174a <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172b:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80172f:	74 20                	je     801751 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	8b 40 0c             	mov    0xc(%eax),%eax
  801737:	85 c0                	test   %eax,%eax
  801739:	74 37                	je     801772 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	ff 75 10             	push   0x10(%ebp)
  801741:	ff 75 0c             	push   0xc(%ebp)
  801744:	56                   	push   %esi
  801745:	ff d0                	call   *%eax
  801747:	83 c4 10             	add    $0x10,%esp
}
  80174a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5e                   	pop    %esi
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801751:	a1 00 40 80 00       	mov    0x804000,%eax
  801756:	8b 40 48             	mov    0x48(%eax),%eax
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	53                   	push   %ebx
  80175d:	50                   	push   %eax
  80175e:	68 0d 2a 80 00       	push   $0x802a0d
  801763:	e8 9d ec ff ff       	call   800405 <cprintf>
		return -E_INVAL;
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb d8                	jmp    80174a <write+0x53>
		return -E_NOT_SUPP;
  801772:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801777:	eb d1                	jmp    80174a <write+0x53>

00801779 <seek>:

int
seek(int fdnum, off_t offset)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	ff 75 08             	push   0x8(%ebp)
  801786:	e8 3a fc ff ff       	call   8013c5 <fd_lookup>
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 0e                	js     8017a0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801798:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	56                   	push   %esi
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 18             	sub    $0x18,%esp
  8017aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b0:	50                   	push   %eax
  8017b1:	53                   	push   %ebx
  8017b2:	e8 0e fc ff ff       	call   8013c5 <fd_lookup>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 34                	js     8017f2 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017be:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c7:	50                   	push   %eax
  8017c8:	ff 36                	push   (%esi)
  8017ca:	e8 46 fc ff ff       	call   801415 <dev_lookup>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 1c                	js     8017f2 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d6:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8017da:	74 1d                	je     8017f9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017df:	8b 40 18             	mov    0x18(%eax),%eax
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	74 34                	je     80181a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	ff 75 0c             	push   0xc(%ebp)
  8017ec:	56                   	push   %esi
  8017ed:	ff d0                	call   *%eax
  8017ef:	83 c4 10             	add    $0x10,%esp
}
  8017f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5e                   	pop    %esi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017f9:	a1 00 40 80 00       	mov    0x804000,%eax
  8017fe:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	53                   	push   %ebx
  801805:	50                   	push   %eax
  801806:	68 d0 29 80 00       	push   $0x8029d0
  80180b:	e8 f5 eb ff ff       	call   800405 <cprintf>
		return -E_INVAL;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801818:	eb d8                	jmp    8017f2 <ftruncate+0x50>
		return -E_NOT_SUPP;
  80181a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181f:	eb d1                	jmp    8017f2 <ftruncate+0x50>

00801821 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	83 ec 18             	sub    $0x18,%esp
  801829:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	ff 75 08             	push   0x8(%ebp)
  801833:	e8 8d fb ff ff       	call   8013c5 <fd_lookup>
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 49                	js     801888 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183f:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801848:	50                   	push   %eax
  801849:	ff 36                	push   (%esi)
  80184b:	e8 c5 fb ff ff       	call   801415 <dev_lookup>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	78 31                	js     801888 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80185e:	74 2f                	je     80188f <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801860:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801863:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80186a:	00 00 00 
	stat->st_isdir = 0;
  80186d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801874:	00 00 00 
	stat->st_dev = dev;
  801877:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	53                   	push   %ebx
  801881:	56                   	push   %esi
  801882:	ff 50 14             	call   *0x14(%eax)
  801885:	83 c4 10             	add    $0x10,%esp
}
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    
		return -E_NOT_SUPP;
  80188f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801894:	eb f2                	jmp    801888 <fstat+0x67>

00801896 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 08             	push   0x8(%ebp)
  8018a3:	e8 22 02 00 00       	call   801aca <open>
  8018a8:	89 c3                	mov    %eax,%ebx
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 1b                	js     8018cc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018b1:	83 ec 08             	sub    $0x8,%esp
  8018b4:	ff 75 0c             	push   0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	e8 64 ff ff ff       	call   801821 <fstat>
  8018bd:	89 c6                	mov    %eax,%esi
	close(fd);
  8018bf:	89 1c 24             	mov    %ebx,(%esp)
  8018c2:	e8 26 fc ff ff       	call   8014ed <close>
	return r;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	89 f3                	mov    %esi,%ebx
}
  8018cc:	89 d8                	mov    %ebx,%eax
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	89 c6                	mov    %eax,%esi
  8018dc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018de:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8018e5:	74 27                	je     80190e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e7:	6a 07                	push   $0x7
  8018e9:	68 00 50 80 00       	push   $0x805000
  8018ee:	56                   	push   %esi
  8018ef:	ff 35 00 60 80 00    	push   0x806000
  8018f5:	e8 64 08 00 00       	call   80215e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018fa:	83 c4 0c             	add    $0xc,%esp
  8018fd:	6a 00                	push   $0x0
  8018ff:	53                   	push   %ebx
  801900:	6a 00                	push   $0x0
  801902:	e8 08 08 00 00       	call   80210f <ipc_recv>
}
  801907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80190e:	83 ec 0c             	sub    $0xc,%esp
  801911:	6a 01                	push   $0x1
  801913:	e8 92 08 00 00       	call   8021aa <ipc_find_env>
  801918:	a3 00 60 80 00       	mov    %eax,0x806000
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	eb c5                	jmp    8018e7 <fsipc+0x12>

00801922 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8b 40 0c             	mov    0xc(%eax),%eax
  80192e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80193b:	ba 00 00 00 00       	mov    $0x0,%edx
  801940:	b8 02 00 00 00       	mov    $0x2,%eax
  801945:	e8 8b ff ff ff       	call   8018d5 <fsipc>
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <devfile_flush>:
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	8b 40 0c             	mov    0xc(%eax),%eax
  801958:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80195d:	ba 00 00 00 00       	mov    $0x0,%edx
  801962:	b8 06 00 00 00       	mov    $0x6,%eax
  801967:	e8 69 ff ff ff       	call   8018d5 <fsipc>
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <devfile_stat>:
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	53                   	push   %ebx
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8b 40 0c             	mov    0xc(%eax),%eax
  80197e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801983:	ba 00 00 00 00       	mov    $0x0,%edx
  801988:	b8 05 00 00 00       	mov    $0x5,%eax
  80198d:	e8 43 ff ff ff       	call   8018d5 <fsipc>
  801992:	85 c0                	test   %eax,%eax
  801994:	78 2c                	js     8019c2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	68 00 50 80 00       	push   $0x805000
  80199e:	53                   	push   %ebx
  80199f:	e8 26 f1 ff ff       	call   800aca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a4:	a1 80 50 80 00       	mov    0x805080,%eax
  8019a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019af:	a1 84 50 80 00       	mov    0x805084,%eax
  8019b4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <devfile_write>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019dc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019e2:	53                   	push   %ebx
  8019e3:	ff 75 0c             	push   0xc(%ebp)
  8019e6:	68 08 50 80 00       	push   $0x805008
  8019eb:	e8 d2 f2 ff ff       	call   800cc2 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 04 00 00 00       	mov    $0x4,%eax
  8019fa:	e8 d6 fe ff ff       	call   8018d5 <fsipc>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 0b                	js     801a11 <devfile_write+0x4a>
	assert(r <= n);
  801a06:	39 d8                	cmp    %ebx,%eax
  801a08:	77 0c                	ja     801a16 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a0f:	7f 1e                	jg     801a2f <devfile_write+0x68>
}
  801a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    
	assert(r <= n);
  801a16:	68 3c 2a 80 00       	push   $0x802a3c
  801a1b:	68 43 2a 80 00       	push   $0x802a43
  801a20:	68 97 00 00 00       	push   $0x97
  801a25:	68 58 2a 80 00       	push   $0x802a58
  801a2a:	e8 fb e8 ff ff       	call   80032a <_panic>
	assert(r <= PGSIZE);
  801a2f:	68 63 2a 80 00       	push   $0x802a63
  801a34:	68 43 2a 80 00       	push   $0x802a43
  801a39:	68 98 00 00 00       	push   $0x98
  801a3e:	68 58 2a 80 00       	push   $0x802a58
  801a43:	e8 e2 e8 ff ff       	call   80032a <_panic>

00801a48 <devfile_read>:
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8b 40 0c             	mov    0xc(%eax),%eax
  801a56:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6b:	e8 65 fe ff ff       	call   8018d5 <fsipc>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 1f                	js     801a95 <devfile_read+0x4d>
	assert(r <= n);
  801a76:	39 f0                	cmp    %esi,%eax
  801a78:	77 24                	ja     801a9e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a7a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7f:	7f 33                	jg     801ab4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	50                   	push   %eax
  801a85:	68 00 50 80 00       	push   $0x805000
  801a8a:	ff 75 0c             	push   0xc(%ebp)
  801a8d:	e8 ce f1 ff ff       	call   800c60 <memmove>
	return r;
  801a92:	83 c4 10             	add    $0x10,%esp
}
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    
	assert(r <= n);
  801a9e:	68 3c 2a 80 00       	push   $0x802a3c
  801aa3:	68 43 2a 80 00       	push   $0x802a43
  801aa8:	6a 7c                	push   $0x7c
  801aaa:	68 58 2a 80 00       	push   $0x802a58
  801aaf:	e8 76 e8 ff ff       	call   80032a <_panic>
	assert(r <= PGSIZE);
  801ab4:	68 63 2a 80 00       	push   $0x802a63
  801ab9:	68 43 2a 80 00       	push   $0x802a43
  801abe:	6a 7d                	push   $0x7d
  801ac0:	68 58 2a 80 00       	push   $0x802a58
  801ac5:	e8 60 e8 ff ff       	call   80032a <_panic>

00801aca <open>:
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	83 ec 1c             	sub    $0x1c,%esp
  801ad2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ad5:	56                   	push   %esi
  801ad6:	e8 b4 ef ff ff       	call   800a8f <strlen>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae3:	7f 6c                	jg     801b51 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ae5:	83 ec 0c             	sub    $0xc,%esp
  801ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aeb:	50                   	push   %eax
  801aec:	e8 84 f8 ff ff       	call   801375 <fd_alloc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 3c                	js     801b36 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	56                   	push   %esi
  801afe:	68 00 50 80 00       	push   $0x805000
  801b03:	e8 c2 ef ff ff       	call   800aca <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b13:	b8 01 00 00 00       	mov    $0x1,%eax
  801b18:	e8 b8 fd ff ff       	call   8018d5 <fsipc>
  801b1d:	89 c3                	mov    %eax,%ebx
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 19                	js     801b3f <open+0x75>
	return fd2num(fd);
  801b26:	83 ec 0c             	sub    $0xc,%esp
  801b29:	ff 75 f4             	push   -0xc(%ebp)
  801b2c:	e8 1d f8 ff ff       	call   80134e <fd2num>
  801b31:	89 c3                	mov    %eax,%ebx
  801b33:	83 c4 10             	add    $0x10,%esp
}
  801b36:	89 d8                	mov    %ebx,%eax
  801b38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    
		fd_close(fd, 0);
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	6a 00                	push   $0x0
  801b44:	ff 75 f4             	push   -0xc(%ebp)
  801b47:	e8 1a f9 ff ff       	call   801466 <fd_close>
		return r;
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	eb e5                	jmp    801b36 <open+0x6c>
		return -E_BAD_PATH;
  801b51:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b56:	eb de                	jmp    801b36 <open+0x6c>

00801b58 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	b8 08 00 00 00       	mov    $0x8,%eax
  801b68:	e8 68 fd ff ff       	call   8018d5 <fsipc>
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b77:	83 ec 0c             	sub    $0xc,%esp
  801b7a:	ff 75 08             	push   0x8(%ebp)
  801b7d:	e8 dc f7 ff ff       	call   80135e <fd2data>
  801b82:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b84:	83 c4 08             	add    $0x8,%esp
  801b87:	68 6f 2a 80 00       	push   $0x802a6f
  801b8c:	53                   	push   %ebx
  801b8d:	e8 38 ef ff ff       	call   800aca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b92:	8b 46 04             	mov    0x4(%esi),%eax
  801b95:	2b 06                	sub    (%esi),%eax
  801b97:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b9d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba4:	00 00 00 
	stat->st_dev = &devpipe;
  801ba7:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801bae:	30 80 00 
	return 0;
}
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb9:	5b                   	pop    %ebx
  801bba:	5e                   	pop    %esi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bc7:	53                   	push   %ebx
  801bc8:	6a 00                	push   $0x0
  801bca:	e8 7c f3 ff ff       	call   800f4b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bcf:	89 1c 24             	mov    %ebx,(%esp)
  801bd2:	e8 87 f7 ff ff       	call   80135e <fd2data>
  801bd7:	83 c4 08             	add    $0x8,%esp
  801bda:	50                   	push   %eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	e8 69 f3 ff ff       	call   800f4b <sys_page_unmap>
}
  801be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <_pipeisclosed>:
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	57                   	push   %edi
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 1c             	sub    $0x1c,%esp
  801bf0:	89 c7                	mov    %eax,%edi
  801bf2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf4:	a1 00 40 80 00       	mov    0x804000,%eax
  801bf9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bfc:	83 ec 0c             	sub    $0xc,%esp
  801bff:	57                   	push   %edi
  801c00:	e8 de 05 00 00       	call   8021e3 <pageref>
  801c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c08:	89 34 24             	mov    %esi,(%esp)
  801c0b:	e8 d3 05 00 00       	call   8021e3 <pageref>
		nn = thisenv->env_runs;
  801c10:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801c16:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	39 cb                	cmp    %ecx,%ebx
  801c1e:	74 1b                	je     801c3b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c23:	75 cf                	jne    801bf4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c25:	8b 42 58             	mov    0x58(%edx),%eax
  801c28:	6a 01                	push   $0x1
  801c2a:	50                   	push   %eax
  801c2b:	53                   	push   %ebx
  801c2c:	68 76 2a 80 00       	push   $0x802a76
  801c31:	e8 cf e7 ff ff       	call   800405 <cprintf>
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	eb b9                	jmp    801bf4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c3e:	0f 94 c0             	sete   %al
  801c41:	0f b6 c0             	movzbl %al,%eax
}
  801c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <devpipe_write>:
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	57                   	push   %edi
  801c50:	56                   	push   %esi
  801c51:	53                   	push   %ebx
  801c52:	83 ec 28             	sub    $0x28,%esp
  801c55:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c58:	56                   	push   %esi
  801c59:	e8 00 f7 ff ff       	call   80135e <fd2data>
  801c5e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	bf 00 00 00 00       	mov    $0x0,%edi
  801c68:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c6b:	75 09                	jne    801c76 <devpipe_write+0x2a>
	return i;
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	eb 23                	jmp    801c94 <devpipe_write+0x48>
			sys_yield();
  801c71:	e8 31 f2 ff ff       	call   800ea7 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c76:	8b 43 04             	mov    0x4(%ebx),%eax
  801c79:	8b 0b                	mov    (%ebx),%ecx
  801c7b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c7e:	39 d0                	cmp    %edx,%eax
  801c80:	72 1a                	jb     801c9c <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801c82:	89 da                	mov    %ebx,%edx
  801c84:	89 f0                	mov    %esi,%eax
  801c86:	e8 5c ff ff ff       	call   801be7 <_pipeisclosed>
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	74 e2                	je     801c71 <devpipe_write+0x25>
				return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ca3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	c1 fa 1f             	sar    $0x1f,%edx
  801cab:	89 d1                	mov    %edx,%ecx
  801cad:	c1 e9 1b             	shr    $0x1b,%ecx
  801cb0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cb3:	83 e2 1f             	and    $0x1f,%edx
  801cb6:	29 ca                	sub    %ecx,%edx
  801cb8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cbc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cc0:	83 c0 01             	add    $0x1,%eax
  801cc3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cc6:	83 c7 01             	add    $0x1,%edi
  801cc9:	eb 9d                	jmp    801c68 <devpipe_write+0x1c>

00801ccb <devpipe_read>:
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	57                   	push   %edi
  801ccf:	56                   	push   %esi
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 18             	sub    $0x18,%esp
  801cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cd7:	57                   	push   %edi
  801cd8:	e8 81 f6 ff ff       	call   80135e <fd2data>
  801cdd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	be 00 00 00 00       	mov    $0x0,%esi
  801ce7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cea:	75 13                	jne    801cff <devpipe_read+0x34>
	return i;
  801cec:	89 f0                	mov    %esi,%eax
  801cee:	eb 02                	jmp    801cf2 <devpipe_read+0x27>
				return i;
  801cf0:	89 f0                	mov    %esi,%eax
}
  801cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
			sys_yield();
  801cfa:	e8 a8 f1 ff ff       	call   800ea7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cff:	8b 03                	mov    (%ebx),%eax
  801d01:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d04:	75 18                	jne    801d1e <devpipe_read+0x53>
			if (i > 0)
  801d06:	85 f6                	test   %esi,%esi
  801d08:	75 e6                	jne    801cf0 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801d0a:	89 da                	mov    %ebx,%edx
  801d0c:	89 f8                	mov    %edi,%eax
  801d0e:	e8 d4 fe ff ff       	call   801be7 <_pipeisclosed>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	74 e3                	je     801cfa <devpipe_read+0x2f>
				return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1c:	eb d4                	jmp    801cf2 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d1e:	99                   	cltd   
  801d1f:	c1 ea 1b             	shr    $0x1b,%edx
  801d22:	01 d0                	add    %edx,%eax
  801d24:	83 e0 1f             	and    $0x1f,%eax
  801d27:	29 d0                	sub    %edx,%eax
  801d29:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d31:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d34:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d37:	83 c6 01             	add    $0x1,%esi
  801d3a:	eb ab                	jmp    801ce7 <devpipe_read+0x1c>

00801d3c <pipe>:
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	56                   	push   %esi
  801d40:	53                   	push   %ebx
  801d41:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d47:	50                   	push   %eax
  801d48:	e8 28 f6 ff ff       	call   801375 <fd_alloc>
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	85 c0                	test   %eax,%eax
  801d54:	0f 88 23 01 00 00    	js     801e7d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	68 07 04 00 00       	push   $0x407
  801d62:	ff 75 f4             	push   -0xc(%ebp)
  801d65:	6a 00                	push   $0x0
  801d67:	e8 5a f1 ff ff       	call   800ec6 <sys_page_alloc>
  801d6c:	89 c3                	mov    %eax,%ebx
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	0f 88 04 01 00 00    	js     801e7d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7f:	50                   	push   %eax
  801d80:	e8 f0 f5 ff ff       	call   801375 <fd_alloc>
  801d85:	89 c3                	mov    %eax,%ebx
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	0f 88 db 00 00 00    	js     801e6d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d92:	83 ec 04             	sub    $0x4,%esp
  801d95:	68 07 04 00 00       	push   $0x407
  801d9a:	ff 75 f0             	push   -0x10(%ebp)
  801d9d:	6a 00                	push   $0x0
  801d9f:	e8 22 f1 ff ff       	call   800ec6 <sys_page_alloc>
  801da4:	89 c3                	mov    %eax,%ebx
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	85 c0                	test   %eax,%eax
  801dab:	0f 88 bc 00 00 00    	js     801e6d <pipe+0x131>
	va = fd2data(fd0);
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	ff 75 f4             	push   -0xc(%ebp)
  801db7:	e8 a2 f5 ff ff       	call   80135e <fd2data>
  801dbc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbe:	83 c4 0c             	add    $0xc,%esp
  801dc1:	68 07 04 00 00       	push   $0x407
  801dc6:	50                   	push   %eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	e8 f8 f0 ff ff       	call   800ec6 <sys_page_alloc>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	0f 88 82 00 00 00    	js     801e5d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ddb:	83 ec 0c             	sub    $0xc,%esp
  801dde:	ff 75 f0             	push   -0x10(%ebp)
  801de1:	e8 78 f5 ff ff       	call   80135e <fd2data>
  801de6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ded:	50                   	push   %eax
  801dee:	6a 00                	push   $0x0
  801df0:	56                   	push   %esi
  801df1:	6a 00                	push   $0x0
  801df3:	e8 11 f1 ff ff       	call   800f09 <sys_page_map>
  801df8:	89 c3                	mov    %eax,%ebx
  801dfa:	83 c4 20             	add    $0x20,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 4e                	js     801e4f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e01:	a1 24 30 80 00       	mov    0x803024,%eax
  801e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e09:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e18:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	ff 75 f4             	push   -0xc(%ebp)
  801e2a:	e8 1f f5 ff ff       	call   80134e <fd2num>
  801e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e32:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e34:	83 c4 04             	add    $0x4,%esp
  801e37:	ff 75 f0             	push   -0x10(%ebp)
  801e3a:	e8 0f f5 ff ff       	call   80134e <fd2num>
  801e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e42:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e4d:	eb 2e                	jmp    801e7d <pipe+0x141>
	sys_page_unmap(0, va);
  801e4f:	83 ec 08             	sub    $0x8,%esp
  801e52:	56                   	push   %esi
  801e53:	6a 00                	push   $0x0
  801e55:	e8 f1 f0 ff ff       	call   800f4b <sys_page_unmap>
  801e5a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e5d:	83 ec 08             	sub    $0x8,%esp
  801e60:	ff 75 f0             	push   -0x10(%ebp)
  801e63:	6a 00                	push   $0x0
  801e65:	e8 e1 f0 ff ff       	call   800f4b <sys_page_unmap>
  801e6a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	ff 75 f4             	push   -0xc(%ebp)
  801e73:	6a 00                	push   $0x0
  801e75:	e8 d1 f0 ff ff       	call   800f4b <sys_page_unmap>
  801e7a:	83 c4 10             	add    $0x10,%esp
}
  801e7d:	89 d8                	mov    %ebx,%eax
  801e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5e                   	pop    %esi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <pipeisclosed>:
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8f:	50                   	push   %eax
  801e90:	ff 75 08             	push   0x8(%ebp)
  801e93:	e8 2d f5 ff ff       	call   8013c5 <fd_lookup>
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	78 18                	js     801eb7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 f4             	push   -0xc(%ebp)
  801ea5:	e8 b4 f4 ff ff       	call   80135e <fd2data>
  801eaa:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	e8 33 fd ff ff       	call   801be7 <_pipeisclosed>
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	56                   	push   %esi
  801ebd:	53                   	push   %ebx
  801ebe:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801ec1:	85 f6                	test   %esi,%esi
  801ec3:	74 13                	je     801ed8 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801ec5:	89 f3                	mov    %esi,%ebx
  801ec7:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801ecd:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801ed0:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801ed6:	eb 1b                	jmp    801ef3 <wait+0x3a>
	assert(envid != 0);
  801ed8:	68 8e 2a 80 00       	push   $0x802a8e
  801edd:	68 43 2a 80 00       	push   $0x802a43
  801ee2:	6a 09                	push   $0x9
  801ee4:	68 99 2a 80 00       	push   $0x802a99
  801ee9:	e8 3c e4 ff ff       	call   80032a <_panic>
		sys_yield();
  801eee:	e8 b4 ef ff ff       	call   800ea7 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801ef3:	8b 43 48             	mov    0x48(%ebx),%eax
  801ef6:	39 f0                	cmp    %esi,%eax
  801ef8:	75 07                	jne    801f01 <wait+0x48>
  801efa:	8b 43 54             	mov    0x54(%ebx),%eax
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 ed                	jne    801eee <wait+0x35>
}
  801f01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	c3                   	ret    

00801f0e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f14:	68 a4 2a 80 00       	push   $0x802aa4
  801f19:	ff 75 0c             	push   0xc(%ebp)
  801f1c:	e8 a9 eb ff ff       	call   800aca <strcpy>
	return 0;
}
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <devcons_write>:
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	57                   	push   %edi
  801f2c:	56                   	push   %esi
  801f2d:	53                   	push   %ebx
  801f2e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f34:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f39:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f3f:	eb 2e                	jmp    801f6f <devcons_write+0x47>
		m = n - tot;
  801f41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f44:	29 f3                	sub    %esi,%ebx
  801f46:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f4b:	39 c3                	cmp    %eax,%ebx
  801f4d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	53                   	push   %ebx
  801f54:	89 f0                	mov    %esi,%eax
  801f56:	03 45 0c             	add    0xc(%ebp),%eax
  801f59:	50                   	push   %eax
  801f5a:	57                   	push   %edi
  801f5b:	e8 00 ed ff ff       	call   800c60 <memmove>
		sys_cputs(buf, m);
  801f60:	83 c4 08             	add    $0x8,%esp
  801f63:	53                   	push   %ebx
  801f64:	57                   	push   %edi
  801f65:	e8 a0 ee ff ff       	call   800e0a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f6a:	01 de                	add    %ebx,%esi
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f72:	72 cd                	jb     801f41 <devcons_write+0x19>
}
  801f74:	89 f0                	mov    %esi,%eax
  801f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f79:	5b                   	pop    %ebx
  801f7a:	5e                   	pop    %esi
  801f7b:	5f                   	pop    %edi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <devcons_read>:
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8d:	75 07                	jne    801f96 <devcons_read+0x18>
  801f8f:	eb 1f                	jmp    801fb0 <devcons_read+0x32>
		sys_yield();
  801f91:	e8 11 ef ff ff       	call   800ea7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f96:	e8 8d ee ff ff       	call   800e28 <sys_cgetc>
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	74 f2                	je     801f91 <devcons_read+0x13>
	if (c < 0)
  801f9f:	78 0f                	js     801fb0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fa1:	83 f8 04             	cmp    $0x4,%eax
  801fa4:	74 0c                	je     801fb2 <devcons_read+0x34>
	*(char*)vbuf = c;
  801fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa9:	88 02                	mov    %al,(%edx)
	return 1;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    
		return 0;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb7:	eb f7                	jmp    801fb0 <devcons_read+0x32>

00801fb9 <cputchar>:
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fc5:	6a 01                	push   $0x1
  801fc7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fca:	50                   	push   %eax
  801fcb:	e8 3a ee ff ff       	call   800e0a <sys_cputs>
}
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <getchar>:
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fdb:	6a 01                	push   $0x1
  801fdd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fe0:	50                   	push   %eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	e8 41 f6 ff ff       	call   801629 <read>
	if (r < 0)
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 06                	js     801ff5 <getchar+0x20>
	if (r < 1)
  801fef:	74 06                	je     801ff7 <getchar+0x22>
	return c;
  801ff1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    
		return -E_EOF;
  801ff7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ffc:	eb f7                	jmp    801ff5 <getchar+0x20>

00801ffe <iscons>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802004:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802007:	50                   	push   %eax
  802008:	ff 75 08             	push   0x8(%ebp)
  80200b:	e8 b5 f3 ff ff       	call   8013c5 <fd_lookup>
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	85 c0                	test   %eax,%eax
  802015:	78 11                	js     802028 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802020:	39 10                	cmp    %edx,(%eax)
  802022:	0f 94 c0             	sete   %al
  802025:	0f b6 c0             	movzbl %al,%eax
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <opencons>:
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802030:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802033:	50                   	push   %eax
  802034:	e8 3c f3 ff ff       	call   801375 <fd_alloc>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	78 3a                	js     80207a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	68 07 04 00 00       	push   $0x407
  802048:	ff 75 f4             	push   -0xc(%ebp)
  80204b:	6a 00                	push   $0x0
  80204d:	e8 74 ee ff ff       	call   800ec6 <sys_page_alloc>
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 21                	js     80207a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802062:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	50                   	push   %eax
  802072:	e8 d7 f2 ff ff       	call   80134e <fd2num>
  802077:	83 c4 10             	add    $0x10,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802082:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802089:	74 20                	je     8020ab <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	a3 04 60 80 00       	mov    %eax,0x806004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	68 eb 20 80 00       	push   $0x8020eb
  80209b:	6a 00                	push   $0x0
  80209d:	e8 6f ef ff ff       	call   801011 <sys_env_set_pgfault_upcall>
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 2e                	js     8020d7 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	6a 07                	push   $0x7
  8020b0:	68 00 f0 bf ee       	push   $0xeebff000
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 0a ee ff ff       	call   800ec6 <sys_page_alloc>
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	79 c8                	jns    80208b <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 b0 2a 80 00       	push   $0x802ab0
  8020cb:	6a 21                	push   $0x21
  8020cd:	68 13 2b 80 00       	push   $0x802b13
  8020d2:	e8 53 e2 ff ff       	call   80032a <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 dc 2a 80 00       	push   $0x802adc
  8020df:	6a 27                	push   $0x27
  8020e1:	68 13 2b 80 00       	push   $0x802b13
  8020e6:	e8 3f e2 ff ff       	call   80032a <_panic>

008020eb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020eb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020ec:	a1 04 60 80 00       	mov    0x806004,%eax
	call *%eax
  8020f1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020f3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  8020f6:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  8020fa:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  8020ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  802103:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  802105:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802108:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802109:	83 c4 04             	add    $0x4,%esp
	popfl
  80210c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80210d:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80210e:	c3                   	ret    

0080210f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	8b 75 08             	mov    0x8(%ebp),%esi
  802117:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	ff 75 0c             	push   0xc(%ebp)
  802120:	e8 51 ef ff ff       	call   801076 <sys_ipc_recv>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 2b                	js     802157 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80212c:	85 f6                	test   %esi,%esi
  80212e:	74 0a                	je     80213a <ipc_recv+0x2b>
  802130:	a1 00 40 80 00       	mov    0x804000,%eax
  802135:	8b 40 74             	mov    0x74(%eax),%eax
  802138:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80213a:	85 db                	test   %ebx,%ebx
  80213c:	74 0a                	je     802148 <ipc_recv+0x39>
  80213e:	a1 00 40 80 00       	mov    0x804000,%eax
  802143:	8b 40 78             	mov    0x78(%eax),%eax
  802146:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802148:	a1 00 40 80 00       	mov    0x804000,%eax
  80214d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5d                   	pop    %ebp
  802156:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80215c:	eb f2                	jmp    802150 <ipc_recv+0x41>

0080215e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	8b 7d 08             	mov    0x8(%ebp),%edi
  80216a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80216d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802170:	ff 75 14             	push   0x14(%ebp)
  802173:	53                   	push   %ebx
  802174:	56                   	push   %esi
  802175:	57                   	push   %edi
  802176:	e8 d8 ee ff ff       	call   801053 <sys_ipc_try_send>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	85 c0                	test   %eax,%eax
  802180:	79 20                	jns    8021a2 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802182:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802185:	75 07                	jne    80218e <ipc_send+0x30>
		sys_yield();
  802187:	e8 1b ed ff ff       	call   800ea7 <sys_yield>
  80218c:	eb e2                	jmp    802170 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 21 2b 80 00       	push   $0x802b21
  802196:	6a 2e                	push   $0x2e
  802198:	68 31 2b 80 00       	push   $0x802b31
  80219d:	e8 88 e1 ff ff       	call   80032a <_panic>
	}
}
  8021a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5f                   	pop    %edi
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    

008021aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021b5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021b8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021be:	8b 52 50             	mov    0x50(%edx),%edx
  8021c1:	39 ca                	cmp    %ecx,%edx
  8021c3:	74 11                	je     8021d6 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021c5:	83 c0 01             	add    $0x1,%eax
  8021c8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021cd:	75 e6                	jne    8021b5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	eb 0b                	jmp    8021e1 <ipc_find_env+0x37>
			return envs[i].env_id;
  8021d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021de:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e9:	89 c2                	mov    %eax,%edx
  8021eb:	c1 ea 16             	shr    $0x16,%edx
  8021ee:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021f5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021fa:	f6 c1 01             	test   $0x1,%cl
  8021fd:	74 1c                	je     80221b <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8021ff:	c1 e8 0c             	shr    $0xc,%eax
  802202:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802209:	a8 01                	test   $0x1,%al
  80220b:	74 0e                	je     80221b <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80220d:	c1 e8 0c             	shr    $0xc,%eax
  802210:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802217:	ef 
  802218:	0f b7 d2             	movzwl %dx,%edx
}
  80221b:	89 d0                	mov    %edx,%eax
  80221d:	5d                   	pop    %ebp
  80221e:	c3                   	ret    
  80221f:	90                   	nop

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 c0                	test   %eax,%eax
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f0                	cmp    %esi,%eax
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd f8             	bsr    %eax,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f0                	cmp    %esi,%eax
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	ba 20 00 00 00       	mov    $0x20,%edx
  8022c7:	29 fa                	sub    %edi,%edx
  8022c9:	d3 e0                	shl    %cl,%eax
  8022cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022cf:	89 d1                	mov    %edx,%ecx
  8022d1:	89 d8                	mov    %ebx,%eax
  8022d3:	d3 e8                	shr    %cl,%eax
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 c1                	or     %eax,%ecx
  8022db:	89 f0                	mov    %esi,%eax
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	d3 e8                	shr    %cl,%eax
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 d1                	mov    %edx,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 f3                	or     %esi,%ebx
  8022f9:	89 c6                	mov    %eax,%esi
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	89 d8                	mov    %ebx,%eax
  8022ff:	f7 74 24 08          	divl   0x8(%esp)
  802303:	89 d6                	mov    %edx,%esi
  802305:	89 c3                	mov    %eax,%ebx
  802307:	f7 64 24 0c          	mull   0xc(%esp)
  80230b:	39 d6                	cmp    %edx,%esi
  80230d:	72 19                	jb     802328 <__udivdi3+0x108>
  80230f:	89 f9                	mov    %edi,%ecx
  802311:	d3 e5                	shl    %cl,%ebp
  802313:	39 c5                	cmp    %eax,%ebp
  802315:	73 04                	jae    80231b <__udivdi3+0xfb>
  802317:	39 d6                	cmp    %edx,%esi
  802319:	74 0d                	je     802328 <__udivdi3+0x108>
  80231b:	89 d8                	mov    %ebx,%eax
  80231d:	31 ff                	xor    %edi,%edi
  80231f:	e9 3c ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802328:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80232b:	31 ff                	xor    %edi,%edi
  80232d:	e9 2e ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802332:	66 90                	xchg   %ax,%ax
  802334:	66 90                	xchg   %ax,%ax
  802336:	66 90                	xchg   %ax,%ax
  802338:	66 90                	xchg   %ax,%ax
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <__umoddi3>:
  802340:	f3 0f 1e fb          	endbr32 
  802344:	55                   	push   %ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	83 ec 1c             	sub    $0x1c,%esp
  80234b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80234f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802353:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802357:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	89 da                	mov    %ebx,%edx
  80235f:	85 ff                	test   %edi,%edi
  802361:	75 15                	jne    802378 <__umoddi3+0x38>
  802363:	39 dd                	cmp    %ebx,%ebp
  802365:	76 39                	jbe    8023a0 <__umoddi3+0x60>
  802367:	f7 f5                	div    %ebp
  802369:	89 d0                	mov    %edx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	39 df                	cmp    %ebx,%edi
  80237a:	77 f1                	ja     80236d <__umoddi3+0x2d>
  80237c:	0f bd cf             	bsr    %edi,%ecx
  80237f:	83 f1 1f             	xor    $0x1f,%ecx
  802382:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802386:	75 40                	jne    8023c8 <__umoddi3+0x88>
  802388:	39 df                	cmp    %ebx,%edi
  80238a:	72 04                	jb     802390 <__umoddi3+0x50>
  80238c:	39 f5                	cmp    %esi,%ebp
  80238e:	77 dd                	ja     80236d <__umoddi3+0x2d>
  802390:	89 da                	mov    %ebx,%edx
  802392:	89 f0                	mov    %esi,%eax
  802394:	29 e8                	sub    %ebp,%eax
  802396:	19 fa                	sbb    %edi,%edx
  802398:	eb d3                	jmp    80236d <__umoddi3+0x2d>
  80239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023a0:	89 e9                	mov    %ebp,%ecx
  8023a2:	85 ed                	test   %ebp,%ebp
  8023a4:	75 0b                	jne    8023b1 <__umoddi3+0x71>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f5                	div    %ebp
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f1                	div    %ecx
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	f7 f1                	div    %ecx
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	31 d2                	xor    %edx,%edx
  8023bf:	eb ac                	jmp    80236d <__umoddi3+0x2d>
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023cc:	ba 20 00 00 00       	mov    $0x20,%edx
  8023d1:	29 c2                	sub    %eax,%edx
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	89 e8                	mov    %ebp,%eax
  8023d7:	d3 e7                	shl    %cl,%edi
  8023d9:	89 d1                	mov    %edx,%ecx
  8023db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023df:	d3 e8                	shr    %cl,%eax
  8023e1:	89 c1                	mov    %eax,%ecx
  8023e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023e7:	09 f9                	or     %edi,%ecx
  8023e9:	89 df                	mov    %ebx,%edi
  8023eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	d3 e5                	shl    %cl,%ebp
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	d3 ef                	shr    %cl,%edi
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	d3 e3                	shl    %cl,%ebx
  8023fd:	89 d1                	mov    %edx,%ecx
  8023ff:	89 fa                	mov    %edi,%edx
  802401:	d3 e8                	shr    %cl,%eax
  802403:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802408:	09 d8                	or     %ebx,%eax
  80240a:	f7 74 24 08          	divl   0x8(%esp)
  80240e:	89 d3                	mov    %edx,%ebx
  802410:	d3 e6                	shl    %cl,%esi
  802412:	f7 e5                	mul    %ebp
  802414:	89 c7                	mov    %eax,%edi
  802416:	89 d1                	mov    %edx,%ecx
  802418:	39 d3                	cmp    %edx,%ebx
  80241a:	72 06                	jb     802422 <__umoddi3+0xe2>
  80241c:	75 0e                	jne    80242c <__umoddi3+0xec>
  80241e:	39 c6                	cmp    %eax,%esi
  802420:	73 0a                	jae    80242c <__umoddi3+0xec>
  802422:	29 e8                	sub    %ebp,%eax
  802424:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802428:	89 d1                	mov    %edx,%ecx
  80242a:	89 c7                	mov    %eax,%edi
  80242c:	89 f5                	mov    %esi,%ebp
  80242e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802432:	29 fd                	sub    %edi,%ebp
  802434:	19 cb                	sbb    %ecx,%ebx
  802436:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80243b:	89 d8                	mov    %ebx,%eax
  80243d:	d3 e0                	shl    %cl,%eax
  80243f:	89 f1                	mov    %esi,%ecx
  802441:	d3 ed                	shr    %cl,%ebp
  802443:	d3 eb                	shr    %cl,%ebx
  802445:	09 e8                	or     %ebp,%eax
  802447:	89 da                	mov    %ebx,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
