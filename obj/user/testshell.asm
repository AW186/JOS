
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 60 04 00 00       	call   800491 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 e9 18 00 00       	call   801938 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 df 18 00 00       	call   801938 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  800060:	e8 5f 05 00 00       	call   8005c4 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 0b 2b 80 00 	movl   $0x802b0b,(%esp)
  80006c:	e8 53 05 00 00       	call   8005c4 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 46 0f 00 00       	call   800fc9 <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 56 17 00 00       	call   8017e8 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 1a 2b 80 00       	push   $0x802b1a
  8000a1:	e8 1e 05 00 00       	call   8005c4 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 11 0f 00 00       	call   800fc9 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 21 17 00 00       	call   8017e8 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 15 2b 80 00       	push   $0x802b15
  8000d6:	e8 e9 04 00 00       	call   8005c4 <cprintf>
	exit();
  8000db:	e8 f7 03 00 00       	call   8004d7 <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 b1 15 00 00       	call   8016ac <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 a5 15 00 00       	call   8016ac <close>
	opencons();
  800107:	e8 33 03 00 00       	call   80043f <opencons>
	opencons();
  80010c:	e8 2e 03 00 00       	call   80043f <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 28 2b 80 00       	push   $0x802b28
  80011b:	e8 69 1b 00 00       	call   801c89 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 f3 00 00 00    	js     800220 <umain+0x135>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 a8 23 00 00       	call   8024e1 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 ee 00 00 00    	js     800232 <umain+0x147>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 c4 2a 80 00       	push   $0x802ac4
  80014f:	e8 70 04 00 00       	call   8005c4 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 1c 12 00 00       	call   801375 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 e0 00 00 00    	js     800244 <umain+0x159>
	if (r == 0) {
  800164:	75 7b                	jne    8001e1 <umain+0xf6>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 8d 15 00 00       	call   8016fe <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 82 15 00 00       	call   8016fe <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 28 15 00 00       	call   8016ac <close>
	cprintf("running sh -x < testshell.sh | cat\n");
  800184:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  80018b:	e8 34 04 00 00       	call   8005c4 <cprintf>
		close(wfd);
  800190:	89 34 24             	mov    %esi,(%esp)
  800193:	e8 14 15 00 00       	call   8016ac <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800198:	6a 00                	push   $0x0
  80019a:	68 65 2b 80 00       	push   $0x802b65
  80019f:	68 32 2b 80 00       	push   $0x802b32
  8001a4:	68 68 2b 80 00       	push   $0x802b68
  8001a9:	e8 c1 20 00 00       	call   80226f <spawnl>
  8001ae:	89 c7                	mov    %eax,%edi
  8001b0:	83 c4 20             	add    $0x20,%esp
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	0f 88 9b 00 00 00    	js     800256 <umain+0x16b>
		close(0);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	6a 00                	push   $0x0
  8001c0:	e8 e7 14 00 00       	call   8016ac <close>
		close(1);
  8001c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001cc:	e8 db 14 00 00       	call   8016ac <close>
		wait(r);
  8001d1:	89 3c 24             	mov    %edi,(%esp)
  8001d4:	e8 85 24 00 00       	call   80265e <wait>
		exit();
  8001d9:	e8 f9 02 00 00       	call   8004d7 <exit>
  8001de:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	53                   	push   %ebx
  8001e5:	e8 c2 14 00 00       	call   8016ac <close>
	close(wfd);
  8001ea:	89 34 24             	mov    %esi,(%esp)
  8001ed:	e8 ba 14 00 00       	call   8016ac <close>
	rfd = pfds[0];
  8001f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f8:	83 c4 08             	add    $0x8,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 76 2b 80 00       	push   $0x802b76
  800202:	e8 82 1a 00 00       	call   801c89 <open>
  800207:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	85 c0                	test   %eax,%eax
  80020f:	78 57                	js     800268 <umain+0x17d>
  800211:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  800216:	bf 00 00 00 00       	mov    $0x0,%edi
  80021b:	e9 9a 00 00 00       	jmp    8002ba <umain+0x1cf>
		panic("open testshell.sh: %e", rfd);
  800220:	50                   	push   %eax
  800221:	68 35 2b 80 00       	push   $0x802b35
  800226:	6a 13                	push   $0x13
  800228:	68 4b 2b 80 00       	push   $0x802b4b
  80022d:	e8 b7 02 00 00       	call   8004e9 <_panic>
		panic("pipe: %e", wfd);
  800232:	50                   	push   %eax
  800233:	68 5c 2b 80 00       	push   $0x802b5c
  800238:	6a 15                	push   $0x15
  80023a:	68 4b 2b 80 00       	push   $0x802b4b
  80023f:	e8 a5 02 00 00       	call   8004e9 <_panic>
		panic("fork: %e", r);
  800244:	50                   	push   %eax
  800245:	68 85 2f 80 00       	push   $0x802f85
  80024a:	6a 1a                	push   $0x1a
  80024c:	68 4b 2b 80 00       	push   $0x802b4b
  800251:	e8 93 02 00 00       	call   8004e9 <_panic>
			panic("spawn: %e", r);
  800256:	50                   	push   %eax
  800257:	68 6c 2b 80 00       	push   $0x802b6c
  80025c:	6a 24                	push   $0x24
  80025e:	68 4b 2b 80 00       	push   $0x802b4b
  800263:	e8 81 02 00 00       	call   8004e9 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800268:	50                   	push   %eax
  800269:	68 e8 2a 80 00       	push   $0x802ae8
  80026e:	6a 2f                	push   $0x2f
  800270:	68 4b 2b 80 00       	push   $0x802b4b
  800275:	e8 6f 02 00 00       	call   8004e9 <_panic>
			panic("reading testshell.out: %e", n1);
  80027a:	53                   	push   %ebx
  80027b:	68 84 2b 80 00       	push   $0x802b84
  800280:	6a 36                	push   $0x36
  800282:	68 4b 2b 80 00       	push   $0x802b4b
  800287:	e8 5d 02 00 00       	call   8004e9 <_panic>
			panic("reading testshell.key: %e", n2);
  80028c:	50                   	push   %eax
  80028d:	68 9e 2b 80 00       	push   $0x802b9e
  800292:	6a 38                	push   $0x38
  800294:	68 4b 2b 80 00       	push   $0x802b4b
  800299:	e8 4b 02 00 00       	call   8004e9 <_panic>
			wrong(rfd, kfd, nloff);
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	57                   	push   %edi
  8002a2:	ff 75 d4             	push   -0x2c(%ebp)
  8002a5:	ff 75 d0             	push   -0x30(%ebp)
  8002a8:	e8 86 fd ff ff       	call   800033 <wrong>
  8002ad:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002b0:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b4:	0f 44 fe             	cmove  %esi,%edi
  8002b7:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	6a 01                	push   $0x1
  8002bf:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002c2:	50                   	push   %eax
  8002c3:	ff 75 d0             	push   -0x30(%ebp)
  8002c6:	e8 1d 15 00 00       	call   8017e8 <read>
  8002cb:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002cd:	83 c4 0c             	add    $0xc,%esp
  8002d0:	6a 01                	push   $0x1
  8002d2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d5:	50                   	push   %eax
  8002d6:	ff 75 d4             	push   -0x2c(%ebp)
  8002d9:	e8 0a 15 00 00       	call   8017e8 <read>
		if (n1 < 0)
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	85 db                	test   %ebx,%ebx
  8002e3:	78 95                	js     80027a <umain+0x18f>
		if (n2 < 0)
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	78 a3                	js     80028c <umain+0x1a1>
		if (n1 == 0 && n2 == 0)
  8002e9:	89 da                	mov    %ebx,%edx
  8002eb:	09 c2                	or     %eax,%edx
  8002ed:	74 15                	je     800304 <umain+0x219>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002ef:	83 fb 01             	cmp    $0x1,%ebx
  8002f2:	75 aa                	jne    80029e <umain+0x1b3>
  8002f4:	83 f8 01             	cmp    $0x1,%eax
  8002f7:	75 a5                	jne    80029e <umain+0x1b3>
  8002f9:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002fd:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800300:	75 9c                	jne    80029e <umain+0x1b3>
  800302:	eb ac                	jmp    8002b0 <umain+0x1c5>
	cprintf("shell ran correctly\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 b8 2b 80 00       	push   $0x802bb8
  80030c:	e8 b3 02 00 00       	call   8005c4 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800311:	cc                   	int3   
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5f                   	pop    %edi
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	c3                   	ret    

00800323 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800329:	68 cd 2b 80 00       	push   $0x802bcd
  80032e:	ff 75 0c             	push   0xc(%ebp)
  800331:	e8 53 09 00 00       	call   800c89 <strcpy>
	return 0;
}
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    

0080033d <devcons_write>:
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800349:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80034e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800354:	eb 2e                	jmp    800384 <devcons_write+0x47>
		m = n - tot;
  800356:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800359:	29 f3                	sub    %esi,%ebx
  80035b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800360:	39 c3                	cmp    %eax,%ebx
  800362:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	53                   	push   %ebx
  800369:	89 f0                	mov    %esi,%eax
  80036b:	03 45 0c             	add    0xc(%ebp),%eax
  80036e:	50                   	push   %eax
  80036f:	57                   	push   %edi
  800370:	e8 aa 0a 00 00       	call   800e1f <memmove>
		sys_cputs(buf, m);
  800375:	83 c4 08             	add    $0x8,%esp
  800378:	53                   	push   %ebx
  800379:	57                   	push   %edi
  80037a:	e8 4a 0c 00 00       	call   800fc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80037f:	01 de                	add    %ebx,%esi
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	3b 75 10             	cmp    0x10(%ebp),%esi
  800387:	72 cd                	jb     800356 <devcons_write+0x19>
}
  800389:	89 f0                	mov    %esi,%eax
  80038b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038e:	5b                   	pop    %ebx
  80038f:	5e                   	pop    %esi
  800390:	5f                   	pop    %edi
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <devcons_read>:
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80039e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003a2:	75 07                	jne    8003ab <devcons_read+0x18>
  8003a4:	eb 1f                	jmp    8003c5 <devcons_read+0x32>
		sys_yield();
  8003a6:	e8 bb 0c 00 00       	call   801066 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003ab:	e8 37 0c 00 00       	call   800fe7 <sys_cgetc>
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	74 f2                	je     8003a6 <devcons_read+0x13>
	if (c < 0)
  8003b4:	78 0f                	js     8003c5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8003b6:	83 f8 04             	cmp    $0x4,%eax
  8003b9:	74 0c                	je     8003c7 <devcons_read+0x34>
	*(char*)vbuf = c;
  8003bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003be:	88 02                	mov    %al,(%edx)
	return 1;
  8003c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003c5:	c9                   	leave  
  8003c6:	c3                   	ret    
		return 0;
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	eb f7                	jmp    8003c5 <devcons_read+0x32>

008003ce <cputchar>:
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003da:	6a 01                	push   $0x1
  8003dc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003df:	50                   	push   %eax
  8003e0:	e8 e4 0b 00 00       	call   800fc9 <sys_cputs>
}
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

008003ea <getchar>:
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003f0:	6a 01                	push   $0x1
  8003f2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	6a 00                	push   $0x0
  8003f8:	e8 eb 13 00 00       	call   8017e8 <read>
	if (r < 0)
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	85 c0                	test   %eax,%eax
  800402:	78 06                	js     80040a <getchar+0x20>
	if (r < 1)
  800404:	74 06                	je     80040c <getchar+0x22>
	return c;
  800406:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    
		return -E_EOF;
  80040c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800411:	eb f7                	jmp    80040a <getchar+0x20>

00800413 <iscons>:
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800419:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80041c:	50                   	push   %eax
  80041d:	ff 75 08             	push   0x8(%ebp)
  800420:	e8 5f 11 00 00       	call   801584 <fd_lookup>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	85 c0                	test   %eax,%eax
  80042a:	78 11                	js     80043d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80042c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042f:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800435:	39 10                	cmp    %edx,(%eax)
  800437:	0f 94 c0             	sete   %al
  80043a:	0f b6 c0             	movzbl %al,%eax
}
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    

0080043f <opencons>:
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800445:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800448:	50                   	push   %eax
  800449:	e8 e6 10 00 00       	call   801534 <fd_alloc>
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	85 c0                	test   %eax,%eax
  800453:	78 3a                	js     80048f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 07 04 00 00       	push   $0x407
  80045d:	ff 75 f4             	push   -0xc(%ebp)
  800460:	6a 00                	push   $0x0
  800462:	e8 1e 0c 00 00       	call   801085 <sys_page_alloc>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	85 c0                	test   %eax,%eax
  80046c:	78 21                	js     80048f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800477:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	50                   	push   %eax
  800487:	e8 81 10 00 00       	call   80150d <fd2num>
  80048c:	83 c4 10             	add    $0x10,%esp
}
  80048f:	c9                   	leave  
  800490:	c3                   	ret    

00800491 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800491:	55                   	push   %ebp
  800492:	89 e5                	mov    %esp,%ebp
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800499:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80049c:	e8 a6 0b 00 00       	call   801047 <sys_getenvid>
  8004a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ae:	a3 00 50 80 00       	mov    %eax,0x805000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b3:	85 db                	test   %ebx,%ebx
  8004b5:	7e 07                	jle    8004be <libmain+0x2d>
		binaryname = argv[0];
  8004b7:	8b 06                	mov    (%esi),%eax
  8004b9:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
  8004c3:	e8 23 fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c8:	e8 0a 00 00 00       	call   8004d7 <exit>
}
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d3:	5b                   	pop    %ebx
  8004d4:	5e                   	pop    %esi
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8004dd:	6a 00                	push   $0x0
  8004df:	e8 22 0b 00 00       	call   801006 <sys_env_destroy>
}
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    

008004e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	56                   	push   %esi
  8004ed:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f1:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004f7:	e8 4b 0b 00 00       	call   801047 <sys_getenvid>
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	ff 75 0c             	push   0xc(%ebp)
  800502:	ff 75 08             	push   0x8(%ebp)
  800505:	56                   	push   %esi
  800506:	50                   	push   %eax
  800507:	68 e4 2b 80 00       	push   $0x802be4
  80050c:	e8 b3 00 00 00       	call   8005c4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800511:	83 c4 18             	add    $0x18,%esp
  800514:	53                   	push   %ebx
  800515:	ff 75 10             	push   0x10(%ebp)
  800518:	e8 56 00 00 00       	call   800573 <vcprintf>
	cprintf("\n");
  80051d:	c7 04 24 18 2b 80 00 	movl   $0x802b18,(%esp)
  800524:	e8 9b 00 00 00       	call   8005c4 <cprintf>
  800529:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80052c:	cc                   	int3   
  80052d:	eb fd                	jmp    80052c <_panic+0x43>

0080052f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	53                   	push   %ebx
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800539:	8b 13                	mov    (%ebx),%edx
  80053b:	8d 42 01             	lea    0x1(%edx),%eax
  80053e:	89 03                	mov    %eax,(%ebx)
  800540:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800543:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800547:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054c:	74 09                	je     800557 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80054e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800555:	c9                   	leave  
  800556:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	68 ff 00 00 00       	push   $0xff
  80055f:	8d 43 08             	lea    0x8(%ebx),%eax
  800562:	50                   	push   %eax
  800563:	e8 61 0a 00 00       	call   800fc9 <sys_cputs>
		b->idx = 0;
  800568:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	eb db                	jmp    80054e <putch+0x1f>

00800573 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800583:	00 00 00 
	b.cnt = 0;
  800586:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800590:	ff 75 0c             	push   0xc(%ebp)
  800593:	ff 75 08             	push   0x8(%ebp)
  800596:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059c:	50                   	push   %eax
  80059d:	68 2f 05 80 00       	push   $0x80052f
  8005a2:	e8 14 01 00 00       	call   8006bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005a7:	83 c4 08             	add    $0x8,%esp
  8005aa:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8005b0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005b6:	50                   	push   %eax
  8005b7:	e8 0d 0a 00 00       	call   800fc9 <sys_cputs>

	return b.cnt;
}
  8005bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ca:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005cd:	50                   	push   %eax
  8005ce:	ff 75 08             	push   0x8(%ebp)
  8005d1:	e8 9d ff ff ff       	call   800573 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	57                   	push   %edi
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 1c             	sub    $0x1c,%esp
  8005e1:	89 c7                	mov    %eax,%edi
  8005e3:	89 d6                	mov    %edx,%esi
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 d1                	mov    %edx,%ecx
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800605:	39 c2                	cmp    %eax,%edx
  800607:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80060a:	72 3e                	jb     80064a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	83 ec 0c             	sub    $0xc,%esp
  80060f:	ff 75 18             	push   0x18(%ebp)
  800612:	83 eb 01             	sub    $0x1,%ebx
  800615:	53                   	push   %ebx
  800616:	50                   	push   %eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 e4             	push   -0x1c(%ebp)
  80061d:	ff 75 e0             	push   -0x20(%ebp)
  800620:	ff 75 dc             	push   -0x24(%ebp)
  800623:	ff 75 d8             	push   -0x28(%ebp)
  800626:	e8 25 22 00 00       	call   802850 <__udivdi3>
  80062b:	83 c4 18             	add    $0x18,%esp
  80062e:	52                   	push   %edx
  80062f:	50                   	push   %eax
  800630:	89 f2                	mov    %esi,%edx
  800632:	89 f8                	mov    %edi,%eax
  800634:	e8 9f ff ff ff       	call   8005d8 <printnum>
  800639:	83 c4 20             	add    $0x20,%esp
  80063c:	eb 13                	jmp    800651 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	56                   	push   %esi
  800642:	ff 75 18             	push   0x18(%ebp)
  800645:	ff d7                	call   *%edi
  800647:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80064a:	83 eb 01             	sub    $0x1,%ebx
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	7f ed                	jg     80063e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	56                   	push   %esi
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	ff 75 e4             	push   -0x1c(%ebp)
  80065b:	ff 75 e0             	push   -0x20(%ebp)
  80065e:	ff 75 dc             	push   -0x24(%ebp)
  800661:	ff 75 d8             	push   -0x28(%ebp)
  800664:	e8 07 23 00 00       	call   802970 <__umoddi3>
  800669:	83 c4 14             	add    $0x14,%esp
  80066c:	0f be 80 07 2c 80 00 	movsbl 0x802c07(%eax),%eax
  800673:	50                   	push   %eax
  800674:	ff d7                	call   *%edi
}
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5e                   	pop    %esi
  80067e:	5f                   	pop    %edi
  80067f:	5d                   	pop    %ebp
  800680:	c3                   	ret    

00800681 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800687:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	3b 50 04             	cmp    0x4(%eax),%edx
  800690:	73 0a                	jae    80069c <sprintputch+0x1b>
		*b->buf++ = ch;
  800692:	8d 4a 01             	lea    0x1(%edx),%ecx
  800695:	89 08                	mov    %ecx,(%eax)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	88 02                	mov    %al,(%edx)
}
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <printfmt>:
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006a7:	50                   	push   %eax
  8006a8:	ff 75 10             	push   0x10(%ebp)
  8006ab:	ff 75 0c             	push   0xc(%ebp)
  8006ae:	ff 75 08             	push   0x8(%ebp)
  8006b1:	e8 05 00 00 00       	call   8006bb <vprintfmt>
}
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <vprintfmt>:
{
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	57                   	push   %edi
  8006bf:	56                   	push   %esi
  8006c0:	53                   	push   %ebx
  8006c1:	83 ec 3c             	sub    $0x3c,%esp
  8006c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006cd:	eb 0a                	jmp    8006d9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	50                   	push   %eax
  8006d4:	ff d6                	call   *%esi
  8006d6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d9:	83 c7 01             	add    $0x1,%edi
  8006dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e0:	83 f8 25             	cmp    $0x25,%eax
  8006e3:	74 0c                	je     8006f1 <vprintfmt+0x36>
			if (ch == '\0')
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	75 e6                	jne    8006cf <vprintfmt+0x14>
}
  8006e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ec:	5b                   	pop    %ebx
  8006ed:	5e                   	pop    %esi
  8006ee:	5f                   	pop    %edi
  8006ef:	5d                   	pop    %ebp
  8006f0:	c3                   	ret    
		padc = ' ';
  8006f1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8006f5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800703:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80070a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80070f:	8d 47 01             	lea    0x1(%edi),%eax
  800712:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800715:	0f b6 17             	movzbl (%edi),%edx
  800718:	8d 42 dd             	lea    -0x23(%edx),%eax
  80071b:	3c 55                	cmp    $0x55,%al
  80071d:	0f 87 a6 04 00 00    	ja     800bc9 <vprintfmt+0x50e>
  800723:	0f b6 c0             	movzbl %al,%eax
  800726:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  80072d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800730:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800734:	eb d9                	jmp    80070f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800736:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800739:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80073d:	eb d0                	jmp    80070f <vprintfmt+0x54>
  80073f:	0f b6 d2             	movzbl %dl,%edx
  800742:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800745:	b8 00 00 00 00       	mov    $0x0,%eax
  80074a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80074d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800750:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800754:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800757:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80075a:	83 f9 09             	cmp    $0x9,%ecx
  80075d:	77 55                	ja     8007b4 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80075f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800762:	eb e9                	jmp    80074d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800775:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800778:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80077c:	79 91                	jns    80070f <vprintfmt+0x54>
				width = precision, precision = -1;
  80077e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800781:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800784:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80078b:	eb 82                	jmp    80070f <vprintfmt+0x54>
  80078d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800790:	85 d2                	test   %edx,%edx
  800792:	b8 00 00 00 00       	mov    $0x0,%eax
  800797:	0f 49 c2             	cmovns %edx,%eax
  80079a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80079d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8007a0:	e9 6a ff ff ff       	jmp    80070f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8007a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8007a8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8007af:	e9 5b ff ff ff       	jmp    80070f <vprintfmt+0x54>
  8007b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ba:	eb bc                	jmp    800778 <vprintfmt+0xbd>
			lflag++;
  8007bc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8007c2:	e9 48 ff ff ff       	jmp    80070f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 78 04             	lea    0x4(%eax),%edi
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	ff 30                	push   (%eax)
  8007d3:	ff d6                	call   *%esi
			break;
  8007d5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007d8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007db:	e9 88 03 00 00       	jmp    800b68 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 78 04             	lea    0x4(%eax),%edi
  8007e6:	8b 10                	mov    (%eax),%edx
  8007e8:	89 d0                	mov    %edx,%eax
  8007ea:	f7 d8                	neg    %eax
  8007ec:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007ef:	83 f8 0f             	cmp    $0xf,%eax
  8007f2:	7f 23                	jg     800817 <vprintfmt+0x15c>
  8007f4:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  8007fb:	85 d2                	test   %edx,%edx
  8007fd:	74 18                	je     800817 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8007ff:	52                   	push   %edx
  800800:	68 75 30 80 00       	push   $0x803075
  800805:	53                   	push   %ebx
  800806:	56                   	push   %esi
  800807:	e8 92 fe ff ff       	call   80069e <printfmt>
  80080c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80080f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800812:	e9 51 03 00 00       	jmp    800b68 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800817:	50                   	push   %eax
  800818:	68 1f 2c 80 00       	push   $0x802c1f
  80081d:	53                   	push   %ebx
  80081e:	56                   	push   %esi
  80081f:	e8 7a fe ff ff       	call   80069e <printfmt>
  800824:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800827:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80082a:	e9 39 03 00 00       	jmp    800b68 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80083d:	85 d2                	test   %edx,%edx
  80083f:	b8 18 2c 80 00       	mov    $0x802c18,%eax
  800844:	0f 45 c2             	cmovne %edx,%eax
  800847:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80084a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80084e:	7e 06                	jle    800856 <vprintfmt+0x19b>
  800850:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800854:	75 0d                	jne    800863 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800856:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800859:	89 c7                	mov    %eax,%edi
  80085b:	03 45 d4             	add    -0x2c(%ebp),%eax
  80085e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800861:	eb 55                	jmp    8008b8 <vprintfmt+0x1fd>
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 e0             	push   -0x20(%ebp)
  800869:	ff 75 cc             	push   -0x34(%ebp)
  80086c:	e8 f5 03 00 00       	call   800c66 <strnlen>
  800871:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800874:	29 c2                	sub    %eax,%edx
  800876:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80087e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800885:	eb 0f                	jmp    800896 <vprintfmt+0x1db>
					putch(padc, putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	ff 75 d4             	push   -0x2c(%ebp)
  80088e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800890:	83 ef 01             	sub    $0x1,%edi
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	85 ff                	test   %edi,%edi
  800898:	7f ed                	jg     800887 <vprintfmt+0x1cc>
  80089a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80089d:	85 d2                	test   %edx,%edx
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f 49 c2             	cmovns %edx,%eax
  8008a7:	29 c2                	sub    %eax,%edx
  8008a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8008ac:	eb a8                	jmp    800856 <vprintfmt+0x19b>
					putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	52                   	push   %edx
  8008b3:	ff d6                	call   *%esi
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8008bb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bd:	83 c7 01             	add    $0x1,%edi
  8008c0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008c4:	0f be d0             	movsbl %al,%edx
  8008c7:	85 d2                	test   %edx,%edx
  8008c9:	74 4b                	je     800916 <vprintfmt+0x25b>
  8008cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008cf:	78 06                	js     8008d7 <vprintfmt+0x21c>
  8008d1:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8008d5:	78 1e                	js     8008f5 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008db:	74 d1                	je     8008ae <vprintfmt+0x1f3>
  8008dd:	0f be c0             	movsbl %al,%eax
  8008e0:	83 e8 20             	sub    $0x20,%eax
  8008e3:	83 f8 5e             	cmp    $0x5e,%eax
  8008e6:	76 c6                	jbe    8008ae <vprintfmt+0x1f3>
					putch('?', putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 3f                	push   $0x3f
  8008ee:	ff d6                	call   *%esi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb c3                	jmp    8008b8 <vprintfmt+0x1fd>
  8008f5:	89 cf                	mov    %ecx,%edi
  8008f7:	eb 0e                	jmp    800907 <vprintfmt+0x24c>
				putch(' ', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	6a 20                	push   $0x20
  8008ff:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800901:	83 ef 01             	sub    $0x1,%edi
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	85 ff                	test   %edi,%edi
  800909:	7f ee                	jg     8008f9 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80090b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	e9 52 02 00 00       	jmp    800b68 <vprintfmt+0x4ad>
  800916:	89 cf                	mov    %ecx,%edi
  800918:	eb ed                	jmp    800907 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800928:	85 d2                	test   %edx,%edx
  80092a:	b8 18 2c 80 00       	mov    $0x802c18,%eax
  80092f:	0f 45 c2             	cmovne %edx,%eax
  800932:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800935:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800939:	7e 06                	jle    800941 <vprintfmt+0x286>
  80093b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80093f:	75 0d                	jne    80094e <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800941:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800944:	89 c7                	mov    %eax,%edi
  800946:	03 45 d4             	add    -0x2c(%ebp),%eax
  800949:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80094c:	eb 55                	jmp    8009a3 <vprintfmt+0x2e8>
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 e0             	push   -0x20(%ebp)
  800954:	ff 75 cc             	push   -0x34(%ebp)
  800957:	e8 0a 03 00 00       	call   800c66 <strnlen>
  80095c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80095f:	29 c2                	sub    %eax,%edx
  800961:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800969:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80096d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800970:	eb 0f                	jmp    800981 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	53                   	push   %ebx
  800976:	ff 75 d4             	push   -0x2c(%ebp)
  800979:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80097b:	83 ef 01             	sub    $0x1,%edi
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	85 ff                	test   %edi,%edi
  800983:	7f ed                	jg     800972 <vprintfmt+0x2b7>
  800985:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800988:	85 d2                	test   %edx,%edx
  80098a:	b8 00 00 00 00       	mov    $0x0,%eax
  80098f:	0f 49 c2             	cmovns %edx,%eax
  800992:	29 c2                	sub    %eax,%edx
  800994:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800997:	eb a8                	jmp    800941 <vprintfmt+0x286>
					putch(ch, putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	53                   	push   %ebx
  80099d:	52                   	push   %edx
  80099e:	ff d6                	call   *%esi
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009a6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8009a8:	83 c7 01             	add    $0x1,%edi
  8009ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009af:	0f be d0             	movsbl %al,%edx
  8009b2:	3c 3a                	cmp    $0x3a,%al
  8009b4:	74 4b                	je     800a01 <vprintfmt+0x346>
  8009b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ba:	78 06                	js     8009c2 <vprintfmt+0x307>
  8009bc:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8009c0:	78 1e                	js     8009e0 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009c6:	74 d1                	je     800999 <vprintfmt+0x2de>
  8009c8:	0f be c0             	movsbl %al,%eax
  8009cb:	83 e8 20             	sub    $0x20,%eax
  8009ce:	83 f8 5e             	cmp    $0x5e,%eax
  8009d1:	76 c6                	jbe    800999 <vprintfmt+0x2de>
					putch('?', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	6a 3f                	push   $0x3f
  8009d9:	ff d6                	call   *%esi
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	eb c3                	jmp    8009a3 <vprintfmt+0x2e8>
  8009e0:	89 cf                	mov    %ecx,%edi
  8009e2:	eb 0e                	jmp    8009f2 <vprintfmt+0x337>
				putch(' ', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	53                   	push   %ebx
  8009e8:	6a 20                	push   $0x20
  8009ea:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009ec:	83 ef 01             	sub    $0x1,%edi
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	85 ff                	test   %edi,%edi
  8009f4:	7f ee                	jg     8009e4 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8009f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fc:	e9 67 01 00 00       	jmp    800b68 <vprintfmt+0x4ad>
  800a01:	89 cf                	mov    %ecx,%edi
  800a03:	eb ed                	jmp    8009f2 <vprintfmt+0x337>
	if (lflag >= 2)
  800a05:	83 f9 01             	cmp    $0x1,%ecx
  800a08:	7f 1b                	jg     800a25 <vprintfmt+0x36a>
	else if (lflag)
  800a0a:	85 c9                	test   %ecx,%ecx
  800a0c:	74 63                	je     800a71 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a16:	99                   	cltd   
  800a17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	8d 40 04             	lea    0x4(%eax),%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	eb 17                	jmp    800a3c <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 50 04             	mov    0x4(%eax),%edx
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a30:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	8d 40 08             	lea    0x8(%eax),%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a3f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800a42:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800a47:	85 c9                	test   %ecx,%ecx
  800a49:	0f 89 ff 00 00 00    	jns    800b4e <vprintfmt+0x493>
				putch('-', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 2d                	push   $0x2d
  800a55:	ff d6                	call   *%esi
				num = -(long long) num;
  800a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a5d:	f7 da                	neg    %edx
  800a5f:	83 d1 00             	adc    $0x0,%ecx
  800a62:	f7 d9                	neg    %ecx
  800a64:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a67:	bf 0a 00 00 00       	mov    $0xa,%edi
  800a6c:	e9 dd 00 00 00       	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, int);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a79:	99                   	cltd   
  800a7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8d 40 04             	lea    0x4(%eax),%eax
  800a83:	89 45 14             	mov    %eax,0x14(%ebp)
  800a86:	eb b4                	jmp    800a3c <vprintfmt+0x381>
	if (lflag >= 2)
  800a88:	83 f9 01             	cmp    $0x1,%ecx
  800a8b:	7f 1e                	jg     800aab <vprintfmt+0x3f0>
	else if (lflag)
  800a8d:	85 c9                	test   %ecx,%ecx
  800a8f:	74 32                	je     800ac3 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8b 10                	mov    (%eax),%edx
  800a96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a9b:	8d 40 04             	lea    0x4(%eax),%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aa1:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800aa6:	e9 a3 00 00 00       	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	8b 10                	mov    (%eax),%edx
  800ab0:	8b 48 04             	mov    0x4(%eax),%ecx
  800ab3:	8d 40 08             	lea    0x8(%eax),%eax
  800ab6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ab9:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800abe:	e9 8b 00 00 00       	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	8b 10                	mov    (%eax),%edx
  800ac8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800acd:	8d 40 04             	lea    0x4(%eax),%eax
  800ad0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ad3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800ad8:	eb 74                	jmp    800b4e <vprintfmt+0x493>
	if (lflag >= 2)
  800ada:	83 f9 01             	cmp    $0x1,%ecx
  800add:	7f 1b                	jg     800afa <vprintfmt+0x43f>
	else if (lflag)
  800adf:	85 c9                	test   %ecx,%ecx
  800ae1:	74 2c                	je     800b0f <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	8b 10                	mov    (%eax),%edx
  800ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aed:	8d 40 04             	lea    0x4(%eax),%eax
  800af0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800af3:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800af8:	eb 54                	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	8b 10                	mov    (%eax),%edx
  800aff:	8b 48 04             	mov    0x4(%eax),%ecx
  800b02:	8d 40 08             	lea    0x8(%eax),%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b08:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800b0d:	eb 3f                	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b19:	8d 40 04             	lea    0x4(%eax),%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b1f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800b24:	eb 28                	jmp    800b4e <vprintfmt+0x493>
			putch('0', putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	53                   	push   %ebx
  800b2a:	6a 30                	push   $0x30
  800b2c:	ff d6                	call   *%esi
			putch('x', putdat);
  800b2e:	83 c4 08             	add    $0x8,%esp
  800b31:	53                   	push   %ebx
  800b32:	6a 78                	push   $0x78
  800b34:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	8b 10                	mov    (%eax),%edx
  800b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b40:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b43:	8d 40 04             	lea    0x4(%eax),%eax
  800b46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b49:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800b55:	50                   	push   %eax
  800b56:	ff 75 d4             	push   -0x2c(%ebp)
  800b59:	57                   	push   %edi
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	89 da                	mov    %ebx,%edx
  800b5e:	89 f0                	mov    %esi,%eax
  800b60:	e8 73 fa ff ff       	call   8005d8 <printnum>
			break;
  800b65:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b68:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6b:	e9 69 fb ff ff       	jmp    8006d9 <vprintfmt+0x1e>
	if (lflag >= 2)
  800b70:	83 f9 01             	cmp    $0x1,%ecx
  800b73:	7f 1b                	jg     800b90 <vprintfmt+0x4d5>
	else if (lflag)
  800b75:	85 c9                	test   %ecx,%ecx
  800b77:	74 2c                	je     800ba5 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b83:	8d 40 04             	lea    0x4(%eax),%eax
  800b86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b89:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800b8e:	eb be                	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	8b 10                	mov    (%eax),%edx
  800b95:	8b 48 04             	mov    0x4(%eax),%ecx
  800b98:	8d 40 08             	lea    0x8(%eax),%eax
  800b9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b9e:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800ba3:	eb a9                	jmp    800b4e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800baf:	8d 40 04             	lea    0x4(%eax),%eax
  800bb2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bb5:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800bba:	eb 92                	jmp    800b4e <vprintfmt+0x493>
			putch(ch, putdat);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	53                   	push   %ebx
  800bc0:	6a 25                	push   $0x25
  800bc2:	ff d6                	call   *%esi
			break;
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	eb 9f                	jmp    800b68 <vprintfmt+0x4ad>
			putch('%', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	53                   	push   %ebx
  800bcd:	6a 25                	push   $0x25
  800bcf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd1:	83 c4 10             	add    $0x10,%esp
  800bd4:	89 f8                	mov    %edi,%eax
  800bd6:	eb 03                	jmp    800bdb <vprintfmt+0x520>
  800bd8:	83 e8 01             	sub    $0x1,%eax
  800bdb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bdf:	75 f7                	jne    800bd8 <vprintfmt+0x51d>
  800be1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800be4:	eb 82                	jmp    800b68 <vprintfmt+0x4ad>

00800be6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 18             	sub    $0x18,%esp
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bf9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	74 26                	je     800c2d <vsnprintf+0x47>
  800c07:	85 d2                	test   %edx,%edx
  800c09:	7e 22                	jle    800c2d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0b:	ff 75 14             	push   0x14(%ebp)
  800c0e:	ff 75 10             	push   0x10(%ebp)
  800c11:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 81 06 80 00       	push   $0x800681
  800c1a:	e8 9c fa ff ff       	call   8006bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c28:	83 c4 10             	add    $0x10,%esp
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    
		return -E_INVAL;
  800c2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c32:	eb f7                	jmp    800c2b <vsnprintf+0x45>

00800c34 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c3a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 10             	push   0x10(%ebp)
  800c41:	ff 75 0c             	push   0xc(%ebp)
  800c44:	ff 75 08             	push   0x8(%ebp)
  800c47:	e8 9a ff ff ff       	call   800be6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
  800c59:	eb 03                	jmp    800c5e <strlen+0x10>
		n++;
  800c5b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800c5e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c62:	75 f7                	jne    800c5b <strlen+0xd>
	return n;
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	eb 03                	jmp    800c79 <strnlen+0x13>
		n++;
  800c76:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c79:	39 d0                	cmp    %edx,%eax
  800c7b:	74 08                	je     800c85 <strnlen+0x1f>
  800c7d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c81:	75 f3                	jne    800c76 <strnlen+0x10>
  800c83:	89 c2                	mov    %eax,%edx
	return n;
}
  800c85:	89 d0                	mov    %edx,%eax
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	53                   	push   %ebx
  800c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
  800c98:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c9c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c9f:	83 c0 01             	add    $0x1,%eax
  800ca2:	84 d2                	test   %dl,%dl
  800ca4:	75 f2                	jne    800c98 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ca6:	89 c8                	mov    %ecx,%eax
  800ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 10             	sub    $0x10,%esp
  800cb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cb7:	53                   	push   %ebx
  800cb8:	e8 91 ff ff ff       	call   800c4e <strlen>
  800cbd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cc0:	ff 75 0c             	push   0xc(%ebp)
  800cc3:	01 d8                	add    %ebx,%eax
  800cc5:	50                   	push   %eax
  800cc6:	e8 be ff ff ff       	call   800c89 <strcpy>
	return dst;
}
  800ccb:	89 d8                	mov    %ebx,%eax
  800ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdd:	89 f3                	mov    %esi,%ebx
  800cdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce2:	89 f0                	mov    %esi,%eax
  800ce4:	eb 0f                	jmp    800cf5 <strncpy+0x23>
		*dst++ = *src;
  800ce6:	83 c0 01             	add    $0x1,%eax
  800ce9:	0f b6 0a             	movzbl (%edx),%ecx
  800cec:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cef:	80 f9 01             	cmp    $0x1,%cl
  800cf2:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800cf5:	39 d8                	cmp    %ebx,%eax
  800cf7:	75 ed                	jne    800ce6 <strncpy+0x14>
	}
	return ret;
}
  800cf9:	89 f0                	mov    %esi,%eax
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	8b 75 08             	mov    0x8(%ebp),%esi
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	8b 55 10             	mov    0x10(%ebp),%edx
  800d0d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d0f:	85 d2                	test   %edx,%edx
  800d11:	74 21                	je     800d34 <strlcpy+0x35>
  800d13:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d17:	89 f2                	mov    %esi,%edx
  800d19:	eb 09                	jmp    800d24 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	83 c2 01             	add    $0x1,%edx
  800d21:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	74 09                	je     800d31 <strlcpy+0x32>
  800d28:	0f b6 19             	movzbl (%ecx),%ebx
  800d2b:	84 db                	test   %bl,%bl
  800d2d:	75 ec                	jne    800d1b <strlcpy+0x1c>
  800d2f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d34:	29 f0                	sub    %esi,%eax
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d43:	eb 06                	jmp    800d4b <strcmp+0x11>
		p++, q++;
  800d45:	83 c1 01             	add    $0x1,%ecx
  800d48:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800d4b:	0f b6 01             	movzbl (%ecx),%eax
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 04                	je     800d56 <strcmp+0x1c>
  800d52:	3a 02                	cmp    (%edx),%al
  800d54:	74 ef                	je     800d45 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d56:	0f b6 c0             	movzbl %al,%eax
  800d59:	0f b6 12             	movzbl (%edx),%edx
  800d5c:	29 d0                	sub    %edx,%eax
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	53                   	push   %ebx
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6a:	89 c3                	mov    %eax,%ebx
  800d6c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d6f:	eb 06                	jmp    800d77 <strncmp+0x17>
		n--, p++, q++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d77:	39 d8                	cmp    %ebx,%eax
  800d79:	74 18                	je     800d93 <strncmp+0x33>
  800d7b:	0f b6 08             	movzbl (%eax),%ecx
  800d7e:	84 c9                	test   %cl,%cl
  800d80:	74 04                	je     800d86 <strncmp+0x26>
  800d82:	3a 0a                	cmp    (%edx),%cl
  800d84:	74 eb                	je     800d71 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d86:	0f b6 00             	movzbl (%eax),%eax
  800d89:	0f b6 12             	movzbl (%edx),%edx
  800d8c:	29 d0                	sub    %edx,%eax
}
  800d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    
		return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
  800d98:	eb f4                	jmp    800d8e <strncmp+0x2e>

00800d9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800da4:	eb 03                	jmp    800da9 <strchr+0xf>
  800da6:	83 c0 01             	add    $0x1,%eax
  800da9:	0f b6 10             	movzbl (%eax),%edx
  800dac:	84 d2                	test   %dl,%dl
  800dae:	74 06                	je     800db6 <strchr+0x1c>
		if (*s == c)
  800db0:	38 ca                	cmp    %cl,%dl
  800db2:	75 f2                	jne    800da6 <strchr+0xc>
  800db4:	eb 05                	jmp    800dbb <strchr+0x21>
			return (char *) s;
	return 0;
  800db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dc7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800dca:	38 ca                	cmp    %cl,%dl
  800dcc:	74 09                	je     800dd7 <strfind+0x1a>
  800dce:	84 d2                	test   %dl,%dl
  800dd0:	74 05                	je     800dd7 <strfind+0x1a>
	for (; *s; s++)
  800dd2:	83 c0 01             	add    $0x1,%eax
  800dd5:	eb f0                	jmp    800dc7 <strfind+0xa>
			break;
	return (char *) s;
}
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800de2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800de5:	85 c9                	test   %ecx,%ecx
  800de7:	74 2f                	je     800e18 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800de9:	89 f8                	mov    %edi,%eax
  800deb:	09 c8                	or     %ecx,%eax
  800ded:	a8 03                	test   $0x3,%al
  800def:	75 21                	jne    800e12 <memset+0x39>
		c &= 0xFF;
  800df1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800df5:	89 d0                	mov    %edx,%eax
  800df7:	c1 e0 08             	shl    $0x8,%eax
  800dfa:	89 d3                	mov    %edx,%ebx
  800dfc:	c1 e3 18             	shl    $0x18,%ebx
  800dff:	89 d6                	mov    %edx,%esi
  800e01:	c1 e6 10             	shl    $0x10,%esi
  800e04:	09 f3                	or     %esi,%ebx
  800e06:	09 da                	or     %ebx,%edx
  800e08:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e0d:	fc                   	cld    
  800e0e:	f3 ab                	rep stos %eax,%es:(%edi)
  800e10:	eb 06                	jmp    800e18 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	fc                   	cld    
  800e16:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e18:	89 f8                	mov    %edi,%eax
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2d:	39 c6                	cmp    %eax,%esi
  800e2f:	73 32                	jae    800e63 <memmove+0x44>
  800e31:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e34:	39 c2                	cmp    %eax,%edx
  800e36:	76 2b                	jbe    800e63 <memmove+0x44>
		s += n;
		d += n;
  800e38:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3b:	89 d6                	mov    %edx,%esi
  800e3d:	09 fe                	or     %edi,%esi
  800e3f:	09 ce                	or     %ecx,%esi
  800e41:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e47:	75 0e                	jne    800e57 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e49:	83 ef 04             	sub    $0x4,%edi
  800e4c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e52:	fd                   	std    
  800e53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e55:	eb 09                	jmp    800e60 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e57:	83 ef 01             	sub    $0x1,%edi
  800e5a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e5d:	fd                   	std    
  800e5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e60:	fc                   	cld    
  800e61:	eb 1a                	jmp    800e7d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e63:	89 f2                	mov    %esi,%edx
  800e65:	09 c2                	or     %eax,%edx
  800e67:	09 ca                	or     %ecx,%edx
  800e69:	f6 c2 03             	test   $0x3,%dl
  800e6c:	75 0a                	jne    800e78 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e6e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e71:	89 c7                	mov    %eax,%edi
  800e73:	fc                   	cld    
  800e74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e76:	eb 05                	jmp    800e7d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e78:	89 c7                	mov    %eax,%edi
  800e7a:	fc                   	cld    
  800e7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e87:	ff 75 10             	push   0x10(%ebp)
  800e8a:	ff 75 0c             	push   0xc(%ebp)
  800e8d:	ff 75 08             	push   0x8(%ebp)
  800e90:	e8 8a ff ff ff       	call   800e1f <memmove>
}
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	89 c6                	mov    %eax,%esi
  800ea4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ea7:	eb 06                	jmp    800eaf <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ea9:	83 c0 01             	add    $0x1,%eax
  800eac:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800eaf:	39 f0                	cmp    %esi,%eax
  800eb1:	74 14                	je     800ec7 <memcmp+0x30>
		if (*s1 != *s2)
  800eb3:	0f b6 08             	movzbl (%eax),%ecx
  800eb6:	0f b6 1a             	movzbl (%edx),%ebx
  800eb9:	38 d9                	cmp    %bl,%cl
  800ebb:	74 ec                	je     800ea9 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800ebd:	0f b6 c1             	movzbl %cl,%eax
  800ec0:	0f b6 db             	movzbl %bl,%ebx
  800ec3:	29 d8                	sub    %ebx,%eax
  800ec5:	eb 05                	jmp    800ecc <memcmp+0x35>
	}

	return 0;
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ede:	eb 03                	jmp    800ee3 <memfind+0x13>
  800ee0:	83 c0 01             	add    $0x1,%eax
  800ee3:	39 d0                	cmp    %edx,%eax
  800ee5:	73 04                	jae    800eeb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee7:	38 08                	cmp    %cl,(%eax)
  800ee9:	75 f5                	jne    800ee0 <memfind+0x10>
			break;
	return (void *) s;
}
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef9:	eb 03                	jmp    800efe <strtol+0x11>
		s++;
  800efb:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800efe:	0f b6 02             	movzbl (%edx),%eax
  800f01:	3c 20                	cmp    $0x20,%al
  800f03:	74 f6                	je     800efb <strtol+0xe>
  800f05:	3c 09                	cmp    $0x9,%al
  800f07:	74 f2                	je     800efb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f09:	3c 2b                	cmp    $0x2b,%al
  800f0b:	74 2a                	je     800f37 <strtol+0x4a>
	int neg = 0;
  800f0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f12:	3c 2d                	cmp    $0x2d,%al
  800f14:	74 2b                	je     800f41 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f1c:	75 0f                	jne    800f2d <strtol+0x40>
  800f1e:	80 3a 30             	cmpb   $0x30,(%edx)
  800f21:	74 28                	je     800f4b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f23:	85 db                	test   %ebx,%ebx
  800f25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2a:	0f 44 d8             	cmove  %eax,%ebx
  800f2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f35:	eb 46                	jmp    800f7d <strtol+0x90>
		s++;
  800f37:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800f3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800f3f:	eb d5                	jmp    800f16 <strtol+0x29>
		s++, neg = 1;
  800f41:	83 c2 01             	add    $0x1,%edx
  800f44:	bf 01 00 00 00       	mov    $0x1,%edi
  800f49:	eb cb                	jmp    800f16 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f4f:	74 0e                	je     800f5f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f51:	85 db                	test   %ebx,%ebx
  800f53:	75 d8                	jne    800f2d <strtol+0x40>
		s++, base = 8;
  800f55:	83 c2 01             	add    $0x1,%edx
  800f58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f5d:	eb ce                	jmp    800f2d <strtol+0x40>
		s += 2, base = 16;
  800f5f:	83 c2 02             	add    $0x2,%edx
  800f62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f67:	eb c4                	jmp    800f2d <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f69:	0f be c0             	movsbl %al,%eax
  800f6c:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f72:	7d 3a                	jge    800fae <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f74:	83 c2 01             	add    $0x1,%edx
  800f77:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800f7b:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800f7d:	0f b6 02             	movzbl (%edx),%eax
  800f80:	8d 70 d0             	lea    -0x30(%eax),%esi
  800f83:	89 f3                	mov    %esi,%ebx
  800f85:	80 fb 09             	cmp    $0x9,%bl
  800f88:	76 df                	jbe    800f69 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800f8a:	8d 70 9f             	lea    -0x61(%eax),%esi
  800f8d:	89 f3                	mov    %esi,%ebx
  800f8f:	80 fb 19             	cmp    $0x19,%bl
  800f92:	77 08                	ja     800f9c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f94:	0f be c0             	movsbl %al,%eax
  800f97:	83 e8 57             	sub    $0x57,%eax
  800f9a:	eb d3                	jmp    800f6f <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800f9c:	8d 70 bf             	lea    -0x41(%eax),%esi
  800f9f:	89 f3                	mov    %esi,%ebx
  800fa1:	80 fb 19             	cmp    $0x19,%bl
  800fa4:	77 08                	ja     800fae <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fa6:	0f be c0             	movsbl %al,%eax
  800fa9:	83 e8 37             	sub    $0x37,%eax
  800fac:	eb c1                	jmp    800f6f <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb2:	74 05                	je     800fb9 <strtol+0xcc>
		*endptr = (char *) s;
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fb9:	89 c8                	mov    %ecx,%eax
  800fbb:	f7 d8                	neg    %eax
  800fbd:	85 ff                	test   %edi,%edi
  800fbf:	0f 45 c8             	cmovne %eax,%ecx
}
  800fc2:	89 c8                	mov    %ecx,%eax
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	89 c7                	mov    %eax,%edi
  800fde:	89 c6                	mov    %eax,%esi
  800fe0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff7:	89 d1                	mov    %edx,%ecx
  800ff9:	89 d3                	mov    %edx,%ebx
  800ffb:	89 d7                	mov    %edx,%edi
  800ffd:	89 d6                	mov    %edx,%esi
  800fff:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	57                   	push   %edi
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
  80100c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	b8 03 00 00 00       	mov    $0x3,%eax
  80101c:	89 cb                	mov    %ecx,%ebx
  80101e:	89 cf                	mov    %ecx,%edi
  801020:	89 ce                	mov    %ecx,%esi
  801022:	cd 30                	int    $0x30
	if(check && ret > 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	7f 08                	jg     801030 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	50                   	push   %eax
  801034:	6a 03                	push   $0x3
  801036:	68 ff 2e 80 00       	push   $0x802eff
  80103b:	6a 23                	push   $0x23
  80103d:	68 1c 2f 80 00       	push   $0x802f1c
  801042:	e8 a2 f4 ff ff       	call   8004e9 <_panic>

00801047 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104d:	ba 00 00 00 00       	mov    $0x0,%edx
  801052:	b8 02 00 00 00       	mov    $0x2,%eax
  801057:	89 d1                	mov    %edx,%ecx
  801059:	89 d3                	mov    %edx,%ebx
  80105b:	89 d7                	mov    %edx,%edi
  80105d:	89 d6                	mov    %edx,%esi
  80105f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_yield>:

void
sys_yield(void)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	b8 0b 00 00 00       	mov    $0xb,%eax
  801076:	89 d1                	mov    %edx,%ecx
  801078:	89 d3                	mov    %edx,%ebx
  80107a:	89 d7                	mov    %edx,%edi
  80107c:	89 d6                	mov    %edx,%esi
  80107e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108e:	be 00 00 00 00       	mov    $0x0,%esi
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	b8 04 00 00 00       	mov    $0x4,%eax
  80109e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010a1:	89 f7                	mov    %esi,%edi
  8010a3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	7f 08                	jg     8010b1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b1:	83 ec 0c             	sub    $0xc,%esp
  8010b4:	50                   	push   %eax
  8010b5:	6a 04                	push   $0x4
  8010b7:	68 ff 2e 80 00       	push   $0x802eff
  8010bc:	6a 23                	push   $0x23
  8010be:	68 1c 2f 80 00       	push   $0x802f1c
  8010c3:	e8 21 f4 ff ff       	call   8004e9 <_panic>

008010c8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	57                   	push   %edi
  8010cc:	56                   	push   %esi
  8010cd:	53                   	push   %ebx
  8010ce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8010dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e2:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	7f 08                	jg     8010f3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	50                   	push   %eax
  8010f7:	6a 05                	push   $0x5
  8010f9:	68 ff 2e 80 00       	push   $0x802eff
  8010fe:	6a 23                	push   $0x23
  801100:	68 1c 2f 80 00       	push   $0x802f1c
  801105:	e8 df f3 ff ff       	call   8004e9 <_panic>

0080110a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801113:	bb 00 00 00 00       	mov    $0x0,%ebx
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111e:	b8 06 00 00 00       	mov    $0x6,%eax
  801123:	89 df                	mov    %ebx,%edi
  801125:	89 de                	mov    %ebx,%esi
  801127:	cd 30                	int    $0x30
	if(check && ret > 0)
  801129:	85 c0                	test   %eax,%eax
  80112b:	7f 08                	jg     801135 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80112d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	50                   	push   %eax
  801139:	6a 06                	push   $0x6
  80113b:	68 ff 2e 80 00       	push   $0x802eff
  801140:	6a 23                	push   $0x23
  801142:	68 1c 2f 80 00       	push   $0x802f1c
  801147:	e8 9d f3 ff ff       	call   8004e9 <_panic>

0080114c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801155:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115a:	8b 55 08             	mov    0x8(%ebp),%edx
  80115d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801160:	b8 08 00 00 00       	mov    $0x8,%eax
  801165:	89 df                	mov    %ebx,%edi
  801167:	89 de                	mov    %ebx,%esi
  801169:	cd 30                	int    $0x30
	if(check && ret > 0)
  80116b:	85 c0                	test   %eax,%eax
  80116d:	7f 08                	jg     801177 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80116f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801172:	5b                   	pop    %ebx
  801173:	5e                   	pop    %esi
  801174:	5f                   	pop    %edi
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801177:	83 ec 0c             	sub    $0xc,%esp
  80117a:	50                   	push   %eax
  80117b:	6a 08                	push   $0x8
  80117d:	68 ff 2e 80 00       	push   $0x802eff
  801182:	6a 23                	push   $0x23
  801184:	68 1c 2f 80 00       	push   $0x802f1c
  801189:	e8 5b f3 ff ff       	call   8004e9 <_panic>

0080118e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801197:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8011a7:	89 df                	mov    %ebx,%edi
  8011a9:	89 de                	mov    %ebx,%esi
  8011ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	7f 08                	jg     8011b9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	50                   	push   %eax
  8011bd:	6a 09                	push   $0x9
  8011bf:	68 ff 2e 80 00       	push   $0x802eff
  8011c4:	6a 23                	push   $0x23
  8011c6:	68 1c 2f 80 00       	push   $0x802f1c
  8011cb:	e8 19 f3 ff ff       	call   8004e9 <_panic>

008011d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011e9:	89 df                	mov    %ebx,%edi
  8011eb:	89 de                	mov    %ebx,%esi
  8011ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	7f 08                	jg     8011fb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	50                   	push   %eax
  8011ff:	6a 0a                	push   $0xa
  801201:	68 ff 2e 80 00       	push   $0x802eff
  801206:	6a 23                	push   $0x23
  801208:	68 1c 2f 80 00       	push   $0x802f1c
  80120d:	e8 d7 f2 ff ff       	call   8004e9 <_panic>

00801212 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	57                   	push   %edi
  801216:	56                   	push   %esi
  801217:	53                   	push   %ebx
	asm volatile("int %1\n"
  801218:	8b 55 08             	mov    0x8(%ebp),%edx
  80121b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801223:	be 00 00 00 00       	mov    $0x0,%esi
  801228:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80122b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80122e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	b8 0d 00 00 00       	mov    $0xd,%eax
  80124b:	89 cb                	mov    %ecx,%ebx
  80124d:	89 cf                	mov    %ecx,%edi
  80124f:	89 ce                	mov    %ecx,%esi
  801251:	cd 30                	int    $0x30
	if(check && ret > 0)
  801253:	85 c0                	test   %eax,%eax
  801255:	7f 08                	jg     80125f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125f:	83 ec 0c             	sub    $0xc,%esp
  801262:	50                   	push   %eax
  801263:	6a 0d                	push   $0xd
  801265:	68 ff 2e 80 00       	push   $0x802eff
  80126a:	6a 23                	push   $0x23
  80126c:	68 1c 2f 80 00       	push   $0x802f1c
  801271:	e8 73 f2 ff ff       	call   8004e9 <_panic>

00801276 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	53                   	push   %ebx
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801280:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  801282:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801286:	0f 84 99 00 00 00    	je     801325 <pgfault+0xaf>
  80128c:	89 d8                	mov    %ebx,%eax
  80128e:	c1 e8 16             	shr    $0x16,%eax
  801291:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801298:	a8 01                	test   $0x1,%al
  80129a:	0f 84 85 00 00 00    	je     801325 <pgfault+0xaf>
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	c1 e8 0c             	shr    $0xc,%eax
  8012a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ac:	f6 c6 08             	test   $0x8,%dh
  8012af:	74 74                	je     801325 <pgfault+0xaf>
  8012b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b8:	a8 01                	test   $0x1,%al
  8012ba:	74 69                	je     801325 <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	6a 07                	push   $0x7
  8012c1:	68 00 f0 7f 00       	push   $0x7ff000
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 b8 fd ff ff       	call   801085 <sys_page_alloc>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 65                	js     801339 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8012d4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	68 00 10 00 00       	push   $0x1000
  8012e2:	53                   	push   %ebx
  8012e3:	68 00 f0 7f 00       	push   $0x7ff000
  8012e8:	e8 94 fb ff ff       	call   800e81 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  8012ed:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012f4:	53                   	push   %ebx
  8012f5:	6a 00                	push   $0x0
  8012f7:	68 00 f0 7f 00       	push   $0x7ff000
  8012fc:	6a 00                	push   $0x0
  8012fe:	e8 c5 fd ff ff       	call   8010c8 <sys_page_map>
  801303:	83 c4 20             	add    $0x20,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 43                	js     80134d <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	68 00 f0 7f 00       	push   $0x7ff000
  801312:	6a 00                	push   $0x0
  801314:	e8 f1 fd ff ff       	call   80110a <sys_page_unmap>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 41                	js     801361 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  801320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801323:	c9                   	leave  
  801324:	c3                   	ret    
		panic("invalid permision\n");
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	68 2a 2f 80 00       	push   $0x802f2a
  80132d:	6a 1f                	push   $0x1f
  80132f:	68 3d 2f 80 00       	push   $0x802f3d
  801334:	e8 b0 f1 ff ff       	call   8004e9 <_panic>
		panic("Unable to alloc page\n");
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	68 48 2f 80 00       	push   $0x802f48
  801341:	6a 28                	push   $0x28
  801343:	68 3d 2f 80 00       	push   $0x802f3d
  801348:	e8 9c f1 ff ff       	call   8004e9 <_panic>
		panic("Unable to map\n");
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 5e 2f 80 00       	push   $0x802f5e
  801355:	6a 2b                	push   $0x2b
  801357:	68 3d 2f 80 00       	push   $0x802f3d
  80135c:	e8 88 f1 ff ff       	call   8004e9 <_panic>
		panic("Unable to unmap\n");
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	68 6d 2f 80 00       	push   $0x802f6d
  801369:	6a 2d                	push   $0x2d
  80136b:	68 3d 2f 80 00       	push   $0x802f3d
  801370:	e8 74 f1 ff ff       	call   8004e9 <_panic>

00801375 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	57                   	push   %edi
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  80137e:	68 76 12 80 00       	push   $0x801276
  801383:	e8 25 13 00 00       	call   8026ad <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801388:	b8 07 00 00 00       	mov    $0x7,%eax
  80138d:	cd 30                	int    $0x30
  80138f:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 23                	js     8013bb <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801398:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  80139d:	75 6d                	jne    80140c <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  80139f:	e8 a3 fc ff ff       	call   801047 <sys_getenvid>
  8013a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013b1:	a3 00 50 80 00       	mov    %eax,0x805000
		return 0;
  8013b6:	e9 02 01 00 00       	jmp    8014bd <fork+0x148>
		panic("sys_exofork: %e", envid);
  8013bb:	50                   	push   %eax
  8013bc:	68 7e 2f 80 00       	push   $0x802f7e
  8013c1:	6a 6d                	push   $0x6d
  8013c3:	68 3d 2f 80 00       	push   $0x802f3d
  8013c8:	e8 1c f1 ff ff       	call   8004e9 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  8013cd:	c1 e0 0c             	shl    $0xc,%eax
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013d9:	52                   	push   %edx
  8013da:	50                   	push   %eax
  8013db:	56                   	push   %esi
  8013dc:	50                   	push   %eax
  8013dd:	6a 00                	push   $0x0
  8013df:	e8 e4 fc ff ff       	call   8010c8 <sys_page_map>
  8013e4:	83 c4 20             	add    $0x20,%esp
  8013e7:	eb 15                	jmp    8013fe <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  8013e9:	c1 e0 0c             	shl    $0xc,%eax
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	6a 05                	push   $0x5
  8013f1:	50                   	push   %eax
  8013f2:	56                   	push   %esi
  8013f3:	50                   	push   %eax
  8013f4:	6a 00                	push   $0x0
  8013f6:	e8 cd fc ff ff       	call   8010c8 <sys_page_map>
  8013fb:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8013fe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801404:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80140a:	74 7a                	je     801486 <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  80140c:	89 d8                	mov    %ebx,%eax
  80140e:	c1 e8 16             	shr    $0x16,%eax
  801411:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801418:	a8 01                	test   $0x1,%al
  80141a:	74 e2                	je     8013fe <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  80141c:	89 d8                	mov    %ebx,%eax
  80141e:	c1 e8 0c             	shr    $0xc,%eax
  801421:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801428:	f6 c2 01             	test   $0x1,%dl
  80142b:	74 d1                	je     8013fe <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  80142d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801434:	f6 c2 04             	test   $0x4,%dl
  801437:	74 c5                	je     8013fe <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801439:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801440:	f6 c6 04             	test   $0x4,%dh
  801443:	75 88                	jne    8013cd <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801445:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80144b:	74 9c                	je     8013e9 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  80144d:	c1 e0 0c             	shl    $0xc,%eax
  801450:	89 c7                	mov    %eax,%edi
  801452:	83 ec 0c             	sub    $0xc,%esp
  801455:	68 05 08 00 00       	push   $0x805
  80145a:	50                   	push   %eax
  80145b:	56                   	push   %esi
  80145c:	50                   	push   %eax
  80145d:	6a 00                	push   $0x0
  80145f:	e8 64 fc ff ff       	call   8010c8 <sys_page_map>
  801464:	83 c4 20             	add    $0x20,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 93                	js     8013fe <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	68 05 08 00 00       	push   $0x805
  801473:	57                   	push   %edi
  801474:	6a 00                	push   $0x0
  801476:	57                   	push   %edi
  801477:	6a 00                	push   $0x0
  801479:	e8 4a fc ff ff       	call   8010c8 <sys_page_map>
  80147e:	83 c4 20             	add    $0x20,%esp
  801481:	e9 78 ff ff ff       	jmp    8013fe <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 07                	push   $0x7
  80148b:	68 00 f0 bf ee       	push   $0xeebff000
  801490:	56                   	push   %esi
  801491:	e8 ef fb ff ff       	call   801085 <sys_page_alloc>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 2a                	js     8014c7 <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	68 1c 27 80 00       	push   $0x80271c
  8014a5:	56                   	push   %esi
  8014a6:	e8 25 fd ff ff       	call   8011d0 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014ab:	83 c4 08             	add    $0x8,%esp
  8014ae:	6a 02                	push   $0x2
  8014b0:	56                   	push   %esi
  8014b1:	e8 96 fc ff ff       	call   80114c <sys_env_set_status>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 21                	js     8014de <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8014bd:	89 f0                	mov    %esi,%eax
  8014bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    
		panic("failed to alloc page");
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	68 8e 2f 80 00       	push   $0x802f8e
  8014cf:	68 82 00 00 00       	push   $0x82
  8014d4:	68 3d 2f 80 00       	push   $0x802f3d
  8014d9:	e8 0b f0 ff ff       	call   8004e9 <_panic>
		panic("sys_env_set_status: %e", r);
  8014de:	50                   	push   %eax
  8014df:	68 a3 2f 80 00       	push   $0x802fa3
  8014e4:	68 89 00 00 00       	push   $0x89
  8014e9:	68 3d 2f 80 00       	push   $0x802f3d
  8014ee:	e8 f6 ef ff ff       	call   8004e9 <_panic>

008014f3 <sfork>:

// Challenge!
int
sfork(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8014f9:	68 ba 2f 80 00       	push   $0x802fba
  8014fe:	68 92 00 00 00       	push   $0x92
  801503:	68 3d 2f 80 00       	push   $0x802f3d
  801508:	e8 dc ef ff ff       	call   8004e9 <_panic>

0080150d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	05 00 00 00 30       	add    $0x30000000,%eax
  801518:	c1 e8 0c             	shr    $0xc,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801528:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80153c:	89 c2                	mov    %eax,%edx
  80153e:	c1 ea 16             	shr    $0x16,%edx
  801541:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	74 29                	je     801576 <fd_alloc+0x42>
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	c1 ea 0c             	shr    $0xc,%edx
  801552:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801559:	f6 c2 01             	test   $0x1,%dl
  80155c:	74 18                	je     801576 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80155e:	05 00 10 00 00       	add    $0x1000,%eax
  801563:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801568:	75 d2                	jne    80153c <fd_alloc+0x8>
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  80156f:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801574:	eb 05                	jmp    80157b <fd_alloc+0x47>
			return 0;
  801576:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  80157b:	8b 55 08             	mov    0x8(%ebp),%edx
  80157e:	89 02                	mov    %eax,(%edx)
}
  801580:	89 c8                	mov    %ecx,%eax
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80158a:	83 f8 1f             	cmp    $0x1f,%eax
  80158d:	77 30                	ja     8015bf <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80158f:	c1 e0 0c             	shl    $0xc,%eax
  801592:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801597:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80159d:	f6 c2 01             	test   $0x1,%dl
  8015a0:	74 24                	je     8015c6 <fd_lookup+0x42>
  8015a2:	89 c2                	mov    %eax,%edx
  8015a4:	c1 ea 0c             	shr    $0xc,%edx
  8015a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ae:	f6 c2 01             	test   $0x1,%dl
  8015b1:	74 1a                	je     8015cd <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	89 02                	mov    %eax,(%edx)
	return 0;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    
		return -E_INVAL;
  8015bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c4:	eb f7                	jmp    8015bd <fd_lookup+0x39>
		return -E_INVAL;
  8015c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cb:	eb f0                	jmp    8015bd <fd_lookup+0x39>
  8015cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d2:	eb e9                	jmp    8015bd <fd_lookup+0x39>

008015d4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	53                   	push   %ebx
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 55 08             	mov    0x8(%ebp),%edx
  8015de:	b8 4c 30 80 00       	mov    $0x80304c,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  8015e3:	bb 20 40 80 00       	mov    $0x804020,%ebx
		if (devtab[i]->dev_id == dev_id) {
  8015e8:	39 13                	cmp    %edx,(%ebx)
  8015ea:	74 32                	je     80161e <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  8015ec:	83 c0 04             	add    $0x4,%eax
  8015ef:	8b 18                	mov    (%eax),%ebx
  8015f1:	85 db                	test   %ebx,%ebx
  8015f3:	75 f3                	jne    8015e8 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015f5:	a1 00 50 80 00       	mov    0x805000,%eax
  8015fa:	8b 40 48             	mov    0x48(%eax),%eax
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	52                   	push   %edx
  801601:	50                   	push   %eax
  801602:	68 d0 2f 80 00       	push   $0x802fd0
  801607:	e8 b8 ef ff ff       	call   8005c4 <cprintf>
	*dev = 0;
	return -E_INVAL;
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	89 1a                	mov    %ebx,(%edx)
}
  801619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    
			return 0;
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
  801623:	eb ef                	jmp    801614 <dev_lookup+0x40>

00801625 <fd_close>:
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	57                   	push   %edi
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	83 ec 24             	sub    $0x24,%esp
  80162e:	8b 75 08             	mov    0x8(%ebp),%esi
  801631:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801634:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801637:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801638:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80163e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801641:	50                   	push   %eax
  801642:	e8 3d ff ff ff       	call   801584 <fd_lookup>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 05                	js     801655 <fd_close+0x30>
	    || fd != fd2)
  801650:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801653:	74 16                	je     80166b <fd_close+0x46>
		return (must_exist ? r : 0);
  801655:	89 f8                	mov    %edi,%eax
  801657:	84 c0                	test   %al,%al
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
  80165e:	0f 44 d8             	cmove  %eax,%ebx
}
  801661:	89 d8                	mov    %ebx,%eax
  801663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	5f                   	pop    %edi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80166b:	83 ec 08             	sub    $0x8,%esp
  80166e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	ff 36                	push   (%esi)
  801674:	e8 5b ff ff ff       	call   8015d4 <dev_lookup>
  801679:	89 c3                	mov    %eax,%ebx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 1a                	js     80169c <fd_close+0x77>
		if (dev->dev_close)
  801682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801685:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801688:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80168d:	85 c0                	test   %eax,%eax
  80168f:	74 0b                	je     80169c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	56                   	push   %esi
  801695:	ff d0                	call   *%eax
  801697:	89 c3                	mov    %eax,%ebx
  801699:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80169c:	83 ec 08             	sub    $0x8,%esp
  80169f:	56                   	push   %esi
  8016a0:	6a 00                	push   $0x0
  8016a2:	e8 63 fa ff ff       	call   80110a <sys_page_unmap>
	return r;
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	eb b5                	jmp    801661 <fd_close+0x3c>

008016ac <close>:

int
close(int fdnum)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	ff 75 08             	push   0x8(%ebp)
  8016b9:	e8 c6 fe ff ff       	call   801584 <fd_lookup>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	79 02                	jns    8016c7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    
		return fd_close(fd, 1);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	6a 01                	push   $0x1
  8016cc:	ff 75 f4             	push   -0xc(%ebp)
  8016cf:	e8 51 ff ff ff       	call   801625 <fd_close>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	eb ec                	jmp    8016c5 <close+0x19>

008016d9 <close_all>:

void
close_all(void)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	53                   	push   %ebx
  8016e9:	e8 be ff ff ff       	call   8016ac <close>
	for (i = 0; i < MAXFD; i++)
  8016ee:	83 c3 01             	add    $0x1,%ebx
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	83 fb 20             	cmp    $0x20,%ebx
  8016f7:	75 ec                	jne    8016e5 <close_all+0xc>
}
  8016f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801707:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	push   0x8(%ebp)
  80170e:	e8 71 fe ff ff       	call   801584 <fd_lookup>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 7f                	js     80179b <dup+0x9d>
		return r;
	close(newfdnum);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 0c             	push   0xc(%ebp)
  801722:	e8 85 ff ff ff       	call   8016ac <close>

	newfd = INDEX2FD(newfdnum);
  801727:	8b 75 0c             	mov    0xc(%ebp),%esi
  80172a:	c1 e6 0c             	shl    $0xc,%esi
  80172d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801733:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801736:	89 3c 24             	mov    %edi,(%esp)
  801739:	e8 df fd ff ff       	call   80151d <fd2data>
  80173e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801740:	89 34 24             	mov    %esi,(%esp)
  801743:	e8 d5 fd ff ff       	call   80151d <fd2data>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80174e:	89 d8                	mov    %ebx,%eax
  801750:	c1 e8 16             	shr    $0x16,%eax
  801753:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80175a:	a8 01                	test   $0x1,%al
  80175c:	74 11                	je     80176f <dup+0x71>
  80175e:	89 d8                	mov    %ebx,%eax
  801760:	c1 e8 0c             	shr    $0xc,%eax
  801763:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80176a:	f6 c2 01             	test   $0x1,%dl
  80176d:	75 36                	jne    8017a5 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80176f:	89 f8                	mov    %edi,%eax
  801771:	c1 e8 0c             	shr    $0xc,%eax
  801774:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	25 07 0e 00 00       	and    $0xe07,%eax
  801783:	50                   	push   %eax
  801784:	56                   	push   %esi
  801785:	6a 00                	push   $0x0
  801787:	57                   	push   %edi
  801788:	6a 00                	push   $0x0
  80178a:	e8 39 f9 ff ff       	call   8010c8 <sys_page_map>
  80178f:	89 c3                	mov    %eax,%ebx
  801791:	83 c4 20             	add    $0x20,%esp
  801794:	85 c0                	test   %eax,%eax
  801796:	78 33                	js     8017cb <dup+0xcd>
		goto err;

	return newfdnum;
  801798:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80179b:	89 d8                	mov    %ebx,%eax
  80179d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5f                   	pop    %edi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	25 07 0e 00 00       	and    $0xe07,%eax
  8017b4:	50                   	push   %eax
  8017b5:	ff 75 d4             	push   -0x2c(%ebp)
  8017b8:	6a 00                	push   $0x0
  8017ba:	53                   	push   %ebx
  8017bb:	6a 00                	push   $0x0
  8017bd:	e8 06 f9 ff ff       	call   8010c8 <sys_page_map>
  8017c2:	89 c3                	mov    %eax,%ebx
  8017c4:	83 c4 20             	add    $0x20,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	79 a4                	jns    80176f <dup+0x71>
	sys_page_unmap(0, newfd);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	56                   	push   %esi
  8017cf:	6a 00                	push   $0x0
  8017d1:	e8 34 f9 ff ff       	call   80110a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017d6:	83 c4 08             	add    $0x8,%esp
  8017d9:	ff 75 d4             	push   -0x2c(%ebp)
  8017dc:	6a 00                	push   $0x0
  8017de:	e8 27 f9 ff ff       	call   80110a <sys_page_unmap>
	return r;
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	eb b3                	jmp    80179b <dup+0x9d>

008017e8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	56                   	push   %esi
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 18             	sub    $0x18,%esp
  8017f0:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f6:	50                   	push   %eax
  8017f7:	56                   	push   %esi
  8017f8:	e8 87 fd ff ff       	call   801584 <fd_lookup>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 3c                	js     801840 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801804:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801807:	83 ec 08             	sub    $0x8,%esp
  80180a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	ff 33                	push   (%ebx)
  801810:	e8 bf fd ff ff       	call   8015d4 <dev_lookup>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 24                	js     801840 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80181c:	8b 43 08             	mov    0x8(%ebx),%eax
  80181f:	83 e0 03             	and    $0x3,%eax
  801822:	83 f8 01             	cmp    $0x1,%eax
  801825:	74 20                	je     801847 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182a:	8b 40 08             	mov    0x8(%eax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 37                	je     801868 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	ff 75 10             	push   0x10(%ebp)
  801837:	ff 75 0c             	push   0xc(%ebp)
  80183a:	53                   	push   %ebx
  80183b:	ff d0                	call   *%eax
  80183d:	83 c4 10             	add    $0x10,%esp
}
  801840:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801847:	a1 00 50 80 00       	mov    0x805000,%eax
  80184c:	8b 40 48             	mov    0x48(%eax),%eax
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	56                   	push   %esi
  801853:	50                   	push   %eax
  801854:	68 11 30 80 00       	push   $0x803011
  801859:	e8 66 ed ff ff       	call   8005c4 <cprintf>
		return -E_INVAL;
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801866:	eb d8                	jmp    801840 <read+0x58>
		return -E_NOT_SUPP;
  801868:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186d:	eb d1                	jmp    801840 <read+0x58>

0080186f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	57                   	push   %edi
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	8b 7d 08             	mov    0x8(%ebp),%edi
  80187b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80187e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801883:	eb 02                	jmp    801887 <readn+0x18>
  801885:	01 c3                	add    %eax,%ebx
  801887:	39 f3                	cmp    %esi,%ebx
  801889:	73 21                	jae    8018ac <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	89 f0                	mov    %esi,%eax
  801890:	29 d8                	sub    %ebx,%eax
  801892:	50                   	push   %eax
  801893:	89 d8                	mov    %ebx,%eax
  801895:	03 45 0c             	add    0xc(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	57                   	push   %edi
  80189a:	e8 49 ff ff ff       	call   8017e8 <read>
		if (m < 0)
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 04                	js     8018aa <readn+0x3b>
			return m;
		if (m == 0)
  8018a6:	75 dd                	jne    801885 <readn+0x16>
  8018a8:	eb 02                	jmp    8018ac <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018aa:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5f                   	pop    %edi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 18             	sub    $0x18,%esp
  8018be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c4:	50                   	push   %eax
  8018c5:	53                   	push   %ebx
  8018c6:	e8 b9 fc ff ff       	call   801584 <fd_lookup>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 37                	js     801909 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8018d5:	83 ec 08             	sub    $0x8,%esp
  8018d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018db:	50                   	push   %eax
  8018dc:	ff 36                	push   (%esi)
  8018de:	e8 f1 fc ff ff       	call   8015d4 <dev_lookup>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 1f                	js     801909 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ea:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8018ee:	74 20                	je     801910 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	74 37                	je     801931 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	ff 75 10             	push   0x10(%ebp)
  801900:	ff 75 0c             	push   0xc(%ebp)
  801903:	56                   	push   %esi
  801904:	ff d0                	call   *%eax
  801906:	83 c4 10             	add    $0x10,%esp
}
  801909:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801910:	a1 00 50 80 00       	mov    0x805000,%eax
  801915:	8b 40 48             	mov    0x48(%eax),%eax
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	53                   	push   %ebx
  80191c:	50                   	push   %eax
  80191d:	68 2d 30 80 00       	push   $0x80302d
  801922:	e8 9d ec ff ff       	call   8005c4 <cprintf>
		return -E_INVAL;
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80192f:	eb d8                	jmp    801909 <write+0x53>
		return -E_NOT_SUPP;
  801931:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801936:	eb d1                	jmp    801909 <write+0x53>

00801938 <seek>:

int
seek(int fdnum, off_t offset)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80193e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801941:	50                   	push   %eax
  801942:	ff 75 08             	push   0x8(%ebp)
  801945:	e8 3a fc ff ff       	call   801584 <fd_lookup>
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 0e                	js     80195f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801957:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	83 ec 18             	sub    $0x18,%esp
  801969:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80196c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80196f:	50                   	push   %eax
  801970:	53                   	push   %ebx
  801971:	e8 0e fc ff ff       	call   801584 <fd_lookup>
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 34                	js     8019b1 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80197d:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801986:	50                   	push   %eax
  801987:	ff 36                	push   (%esi)
  801989:	e8 46 fc ff ff       	call   8015d4 <dev_lookup>
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	85 c0                	test   %eax,%eax
  801993:	78 1c                	js     8019b1 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801995:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801999:	74 1d                	je     8019b8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	8b 40 18             	mov    0x18(%eax),%eax
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	74 34                	je     8019d9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	ff 75 0c             	push   0xc(%ebp)
  8019ab:	56                   	push   %esi
  8019ac:	ff d0                	call   *%eax
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019b8:	a1 00 50 80 00       	mov    0x805000,%eax
  8019bd:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	53                   	push   %ebx
  8019c4:	50                   	push   %eax
  8019c5:	68 f0 2f 80 00       	push   $0x802ff0
  8019ca:	e8 f5 eb ff ff       	call   8005c4 <cprintf>
		return -E_INVAL;
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d7:	eb d8                	jmp    8019b1 <ftruncate+0x50>
		return -E_NOT_SUPP;
  8019d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019de:	eb d1                	jmp    8019b1 <ftruncate+0x50>

008019e0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	56                   	push   %esi
  8019e4:	53                   	push   %ebx
  8019e5:	83 ec 18             	sub    $0x18,%esp
  8019e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ee:	50                   	push   %eax
  8019ef:	ff 75 08             	push   0x8(%ebp)
  8019f2:	e8 8d fb ff ff       	call   801584 <fd_lookup>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 49                	js     801a47 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019fe:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	ff 36                	push   (%esi)
  801a0a:	e8 c5 fb ff ff       	call   8015d4 <dev_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 31                	js     801a47 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a19:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a1d:	74 2f                	je     801a4e <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a22:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a29:	00 00 00 
	stat->st_isdir = 0;
  801a2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a33:	00 00 00 
	stat->st_dev = dev;
  801a36:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a3c:	83 ec 08             	sub    $0x8,%esp
  801a3f:	53                   	push   %ebx
  801a40:	56                   	push   %esi
  801a41:	ff 50 14             	call   *0x14(%eax)
  801a44:	83 c4 10             	add    $0x10,%esp
}
  801a47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    
		return -E_NOT_SUPP;
  801a4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a53:	eb f2                	jmp    801a47 <fstat+0x67>

00801a55 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	56                   	push   %esi
  801a59:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a5a:	83 ec 08             	sub    $0x8,%esp
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 08             	push   0x8(%ebp)
  801a62:	e8 22 02 00 00       	call   801c89 <open>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 1b                	js     801a8b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	ff 75 0c             	push   0xc(%ebp)
  801a76:	50                   	push   %eax
  801a77:	e8 64 ff ff ff       	call   8019e0 <fstat>
  801a7c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a7e:	89 1c 24             	mov    %ebx,(%esp)
  801a81:	e8 26 fc ff ff       	call   8016ac <close>
	return r;
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	89 f3                	mov    %esi,%ebx
}
  801a8b:	89 d8                	mov    %ebx,%eax
  801a8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a90:	5b                   	pop    %ebx
  801a91:	5e                   	pop    %esi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    

00801a94 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	89 c6                	mov    %eax,%esi
  801a9b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a9d:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  801aa4:	74 27                	je     801acd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801aa6:	6a 07                	push   $0x7
  801aa8:	68 00 60 80 00       	push   $0x806000
  801aad:	56                   	push   %esi
  801aae:	ff 35 00 70 80 00    	push   0x807000
  801ab4:	e8 d6 0c 00 00       	call   80278f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ab9:	83 c4 0c             	add    $0xc,%esp
  801abc:	6a 00                	push   $0x0
  801abe:	53                   	push   %ebx
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 7a 0c 00 00       	call   802740 <ipc_recv>
}
  801ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801acd:	83 ec 0c             	sub    $0xc,%esp
  801ad0:	6a 01                	push   $0x1
  801ad2:	e8 04 0d 00 00       	call   8027db <ipc_find_env>
  801ad7:	a3 00 70 80 00       	mov    %eax,0x807000
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	eb c5                	jmp    801aa6 <fsipc+0x12>

00801ae1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	8b 40 0c             	mov    0xc(%eax),%eax
  801aed:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801afa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aff:	b8 02 00 00 00       	mov    $0x2,%eax
  801b04:	e8 8b ff ff ff       	call   801a94 <fsipc>
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <devfile_flush>:
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	8b 40 0c             	mov    0xc(%eax),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b21:	b8 06 00 00 00       	mov    $0x6,%eax
  801b26:	e8 69 ff ff ff       	call   801a94 <fsipc>
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <devfile_stat>:
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	53                   	push   %ebx
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b42:	ba 00 00 00 00       	mov    $0x0,%edx
  801b47:	b8 05 00 00 00       	mov    $0x5,%eax
  801b4c:	e8 43 ff ff ff       	call   801a94 <fsipc>
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 2c                	js     801b81 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	68 00 60 80 00       	push   $0x806000
  801b5d:	53                   	push   %ebx
  801b5e:	e8 26 f1 ff ff       	call   800c89 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b63:	a1 80 60 80 00       	mov    0x806080,%eax
  801b68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b6e:	a1 84 60 80 00       	mov    0x806084,%eax
  801b73:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <devfile_write>:
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	53                   	push   %ebx
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	8b 40 0c             	mov    0xc(%eax),%eax
  801b96:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b9b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ba1:	53                   	push   %ebx
  801ba2:	ff 75 0c             	push   0xc(%ebp)
  801ba5:	68 08 60 80 00       	push   $0x806008
  801baa:	e8 d2 f2 ff ff       	call   800e81 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801baf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb4:	b8 04 00 00 00       	mov    $0x4,%eax
  801bb9:	e8 d6 fe ff ff       	call   801a94 <fsipc>
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	78 0b                	js     801bd0 <devfile_write+0x4a>
	assert(r <= n);
  801bc5:	39 d8                	cmp    %ebx,%eax
  801bc7:	77 0c                	ja     801bd5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bc9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bce:	7f 1e                	jg     801bee <devfile_write+0x68>
}
  801bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    
	assert(r <= n);
  801bd5:	68 5c 30 80 00       	push   $0x80305c
  801bda:	68 63 30 80 00       	push   $0x803063
  801bdf:	68 97 00 00 00       	push   $0x97
  801be4:	68 78 30 80 00       	push   $0x803078
  801be9:	e8 fb e8 ff ff       	call   8004e9 <_panic>
	assert(r <= PGSIZE);
  801bee:	68 83 30 80 00       	push   $0x803083
  801bf3:	68 63 30 80 00       	push   $0x803063
  801bf8:	68 98 00 00 00       	push   $0x98
  801bfd:	68 78 30 80 00       	push   $0x803078
  801c02:	e8 e2 e8 ff ff       	call   8004e9 <_panic>

00801c07 <devfile_read>:
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 40 0c             	mov    0xc(%eax),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c1a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c20:	ba 00 00 00 00       	mov    $0x0,%edx
  801c25:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2a:	e8 65 fe ff ff       	call   801a94 <fsipc>
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 1f                	js     801c54 <devfile_read+0x4d>
	assert(r <= n);
  801c35:	39 f0                	cmp    %esi,%eax
  801c37:	77 24                	ja     801c5d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c3e:	7f 33                	jg     801c73 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	50                   	push   %eax
  801c44:	68 00 60 80 00       	push   $0x806000
  801c49:	ff 75 0c             	push   0xc(%ebp)
  801c4c:	e8 ce f1 ff ff       	call   800e1f <memmove>
	return r;
  801c51:	83 c4 10             	add    $0x10,%esp
}
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
	assert(r <= n);
  801c5d:	68 5c 30 80 00       	push   $0x80305c
  801c62:	68 63 30 80 00       	push   $0x803063
  801c67:	6a 7c                	push   $0x7c
  801c69:	68 78 30 80 00       	push   $0x803078
  801c6e:	e8 76 e8 ff ff       	call   8004e9 <_panic>
	assert(r <= PGSIZE);
  801c73:	68 83 30 80 00       	push   $0x803083
  801c78:	68 63 30 80 00       	push   $0x803063
  801c7d:	6a 7d                	push   $0x7d
  801c7f:	68 78 30 80 00       	push   $0x803078
  801c84:	e8 60 e8 ff ff       	call   8004e9 <_panic>

00801c89 <open>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 1c             	sub    $0x1c,%esp
  801c91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c94:	56                   	push   %esi
  801c95:	e8 b4 ef ff ff       	call   800c4e <strlen>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca2:	7f 6c                	jg     801d10 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801caa:	50                   	push   %eax
  801cab:	e8 84 f8 ff ff       	call   801534 <fd_alloc>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 3c                	js     801cf5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	56                   	push   %esi
  801cbd:	68 00 60 80 00       	push   $0x806000
  801cc2:	e8 c2 ef ff ff       	call   800c89 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	e8 b8 fd ff ff       	call   801a94 <fsipc>
  801cdc:	89 c3                	mov    %eax,%ebx
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 19                	js     801cfe <open+0x75>
	return fd2num(fd);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	ff 75 f4             	push   -0xc(%ebp)
  801ceb:	e8 1d f8 ff ff       	call   80150d <fd2num>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	83 c4 10             	add    $0x10,%esp
}
  801cf5:	89 d8                	mov    %ebx,%eax
  801cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    
		fd_close(fd, 0);
  801cfe:	83 ec 08             	sub    $0x8,%esp
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 f4             	push   -0xc(%ebp)
  801d06:	e8 1a f9 ff ff       	call   801625 <fd_close>
		return r;
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	eb e5                	jmp    801cf5 <open+0x6c>
		return -E_BAD_PATH;
  801d10:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d15:	eb de                	jmp    801cf5 <open+0x6c>

00801d17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d22:	b8 08 00 00 00       	mov    $0x8,%eax
  801d27:	e8 68 fd ff ff       	call   801a94 <fsipc>
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	57                   	push   %edi
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d3a:	6a 00                	push   $0x0
  801d3c:	ff 75 08             	push   0x8(%ebp)
  801d3f:	e8 45 ff ff ff       	call   801c89 <open>
  801d44:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	0f 88 d0 04 00 00    	js     802225 <spawn+0x4f7>
  801d55:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 00 02 00 00       	push   $0x200
  801d5f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d65:	50                   	push   %eax
  801d66:	51                   	push   %ecx
  801d67:	e8 03 fb ff ff       	call   80186f <readn>
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d74:	75 57                	jne    801dcd <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  801d76:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801d7d:	45 4c 46 
  801d80:	75 4b                	jne    801dcd <spawn+0x9f>
  801d82:	b8 07 00 00 00       	mov    $0x7,%eax
  801d87:	cd 30                	int    $0x30
  801d89:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	0f 88 82 04 00 00    	js     802219 <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d97:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d9c:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801d9f:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801da5:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801dab:	b9 11 00 00 00       	mov    $0x11,%ecx
  801db0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801db2:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801db8:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801dc3:	be 00 00 00 00       	mov    $0x0,%esi
  801dc8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801dcb:	eb 4b                	jmp    801e18 <spawn+0xea>
		close(fd);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801dd6:	e8 d1 f8 ff ff       	call   8016ac <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ddb:	83 c4 0c             	add    $0xc,%esp
  801dde:	68 7f 45 4c 46       	push   $0x464c457f
  801de3:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  801de9:	68 8f 30 80 00       	push   $0x80308f
  801dee:	e8 d1 e7 ff ff       	call   8005c4 <cprintf>
		return -E_NOT_EXEC;
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801dfd:	ff ff ff 
  801e00:	e9 20 04 00 00       	jmp    802225 <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	50                   	push   %eax
  801e09:	e8 40 ee ff ff       	call   800c4e <strlen>
  801e0e:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801e12:	83 c3 01             	add    $0x1,%ebx
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801e1f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	75 df                	jne    801e05 <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e26:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801e2c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e32:	b8 00 10 40 00       	mov    $0x401000,%eax
  801e37:	29 f0                	sub    %esi,%eax
  801e39:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e3b:	89 c2                	mov    %eax,%edx
  801e3d:	83 e2 fc             	and    $0xfffffffc,%edx
  801e40:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801e47:	29 c2                	sub    %eax,%edx
  801e49:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e4f:	8d 42 f8             	lea    -0x8(%edx),%eax
  801e52:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e57:	0f 86 eb 03 00 00    	jbe    802248 <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	6a 07                	push   $0x7
  801e62:	68 00 00 40 00       	push   $0x400000
  801e67:	6a 00                	push   $0x0
  801e69:	e8 17 f2 ff ff       	call   801085 <sys_page_alloc>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	85 c0                	test   %eax,%eax
  801e73:	0f 88 d4 03 00 00    	js     80224d <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e79:	be 00 00 00 00       	mov    $0x0,%esi
  801e7e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e87:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801e8d:	7e 32                	jle    801ec1 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801e8f:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e95:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e9b:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801e9e:	83 ec 08             	sub    $0x8,%esp
  801ea1:	ff 34 b3             	push   (%ebx,%esi,4)
  801ea4:	57                   	push   %edi
  801ea5:	e8 df ed ff ff       	call   800c89 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801eaa:	83 c4 04             	add    $0x4,%esp
  801ead:	ff 34 b3             	push   (%ebx,%esi,4)
  801eb0:	e8 99 ed ff ff       	call   800c4e <strlen>
  801eb5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801eb9:	83 c6 01             	add    $0x1,%esi
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	eb c6                	jmp    801e87 <spawn+0x159>
	}
	argv_store[argc] = 0;
  801ec1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ec7:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ecd:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ed4:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801eda:	0f 85 8c 00 00 00    	jne    801f6c <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ee0:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801ee6:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801eec:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801eef:	89 f8                	mov    %edi,%eax
  801ef1:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801ef7:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801efa:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801eff:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	6a 07                	push   $0x7
  801f0a:	68 00 d0 bf ee       	push   $0xeebfd000
  801f0f:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801f15:	68 00 00 40 00       	push   $0x400000
  801f1a:	6a 00                	push   $0x0
  801f1c:	e8 a7 f1 ff ff       	call   8010c8 <sys_page_map>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	83 c4 20             	add    $0x20,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	0f 88 27 03 00 00    	js     802255 <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f2e:	83 ec 08             	sub    $0x8,%esp
  801f31:	68 00 00 40 00       	push   $0x400000
  801f36:	6a 00                	push   $0x0
  801f38:	e8 cd f1 ff ff       	call   80110a <sys_page_unmap>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	0f 88 0b 03 00 00    	js     802255 <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f4a:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f50:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801f57:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f5d:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801f64:	00 00 00 
  801f67:	e9 4e 01 00 00       	jmp    8020ba <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f6c:	68 ec 30 80 00       	push   $0x8030ec
  801f71:	68 63 30 80 00       	push   $0x803063
  801f76:	68 f2 00 00 00       	push   $0xf2
  801f7b:	68 a9 30 80 00       	push   $0x8030a9
  801f80:	e8 64 e5 ff ff       	call   8004e9 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	6a 07                	push   $0x7
  801f8a:	68 00 00 40 00       	push   $0x400000
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 ef f0 ff ff       	call   801085 <sys_page_alloc>
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	0f 88 92 02 00 00    	js     802233 <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801fa1:	83 ec 08             	sub    $0x8,%esp
  801fa4:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801faa:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  801fb0:	50                   	push   %eax
  801fb1:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801fb7:	e8 7c f9 ff ff       	call   801938 <seek>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	0f 88 73 02 00 00    	js     80223a <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	89 f8                	mov    %edi,%eax
  801fcc:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  801fd2:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fd7:	39 d0                	cmp    %edx,%eax
  801fd9:	0f 47 c2             	cmova  %edx,%eax
  801fdc:	50                   	push   %eax
  801fdd:	68 00 00 40 00       	push   $0x400000
  801fe2:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801fe8:	e8 82 f8 ff ff       	call   80186f <readn>
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	0f 88 49 02 00 00    	js     802241 <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  802001:	56                   	push   %esi
  802002:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802008:	68 00 00 40 00       	push   $0x400000
  80200d:	6a 00                	push   $0x0
  80200f:	e8 b4 f0 ff ff       	call   8010c8 <sys_page_map>
  802014:	83 c4 20             	add    $0x20,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 7c                	js     802097 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80201b:	83 ec 08             	sub    $0x8,%esp
  80201e:	68 00 00 40 00       	push   $0x400000
  802023:	6a 00                	push   $0x0
  802025:	e8 e0 f0 ff ff       	call   80110a <sys_page_unmap>
  80202a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80202d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802033:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802039:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80203f:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  802045:	76 65                	jbe    8020ac <spawn+0x37e>
		if (i >= filesz) {
  802047:	39 df                	cmp    %ebx,%edi
  802049:	0f 87 36 ff ff ff    	ja     801f85 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  802058:	56                   	push   %esi
  802059:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  80205f:	e8 21 f0 ff ff       	call   801085 <sys_page_alloc>
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	79 c2                	jns    80202d <spawn+0x2ff>
  80206b:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802076:	e8 8b ef ff ff       	call   801006 <sys_env_destroy>
	close(fd);
  80207b:	83 c4 04             	add    $0x4,%esp
  80207e:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  802084:	e8 23 f6 ff ff       	call   8016ac <close>
	return r;
  802089:	83 c4 10             	add    $0x10,%esp
  80208c:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  802092:	e9 8e 01 00 00       	jmp    802225 <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  802097:	50                   	push   %eax
  802098:	68 b5 30 80 00       	push   $0x8030b5
  80209d:	68 25 01 00 00       	push   $0x125
  8020a2:	68 a9 30 80 00       	push   $0x8030a9
  8020a7:	e8 3d e4 ff ff       	call   8004e9 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020ac:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8020b3:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  8020ba:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8020c1:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8020c7:	7e 67                	jle    802130 <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  8020c9:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  8020cf:	83 39 01             	cmpl   $0x1,(%ecx)
  8020d2:	75 d8                	jne    8020ac <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8020d4:	8b 41 18             	mov    0x18(%ecx),%eax
  8020d7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8020dd:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8020e0:	83 f8 01             	cmp    $0x1,%eax
  8020e3:	19 c0                	sbb    %eax,%eax
  8020e5:	83 e0 fe             	and    $0xfffffffe,%eax
  8020e8:	83 c0 07             	add    $0x7,%eax
  8020eb:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8020f1:	8b 51 04             	mov    0x4(%ecx),%edx
  8020f4:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  8020fa:	8b 79 10             	mov    0x10(%ecx),%edi
  8020fd:	8b 59 14             	mov    0x14(%ecx),%ebx
  802100:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802106:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  802109:	89 f0                	mov    %esi,%eax
  80210b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802110:	74 14                	je     802126 <spawn+0x3f8>
		va -= i;
  802112:	29 c6                	sub    %eax,%esi
		memsz += i;
  802114:	01 c3                	add    %eax,%ebx
  802116:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  80211c:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  80211e:	29 c2                	sub    %eax,%edx
  802120:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802126:	bb 00 00 00 00       	mov    $0x0,%ebx
  80212b:	e9 09 ff ff ff       	jmp    802039 <spawn+0x30b>
	close(fd);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  802139:	e8 6e f5 ff ff       	call   8016ac <close>
  80213e:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  802141:	bb 00 00 00 00       	mov    $0x0,%ebx
  802146:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80214c:	eb 2d                	jmp    80217b <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  80214e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802155:	89 da                	mov    %ebx,%edx
  802157:	c1 e2 0c             	shl    $0xc,%edx
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	25 07 0e 00 00       	and    $0xe07,%eax
  802162:	50                   	push   %eax
  802163:	52                   	push   %edx
  802164:	56                   	push   %esi
  802165:	52                   	push   %edx
  802166:	6a 00                	push   $0x0
  802168:	e8 5b ef ff ff       	call   8010c8 <sys_page_map>
  80216d:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  802170:	83 c3 01             	add    $0x1,%ebx
  802173:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  802179:	74 29                	je     8021a4 <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  80217b:	89 d8                	mov    %ebx,%eax
  80217d:	c1 f8 0a             	sar    $0xa,%eax
  802180:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802187:	85 c0                	test   %eax,%eax
  802189:	74 e5                	je     802170 <spawn+0x442>
  80218b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802192:	a8 01                	test   $0x1,%al
  802194:	74 da                	je     802170 <spawn+0x442>
  802196:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80219d:	f6 c4 04             	test   $0x4,%ah
  8021a0:	74 ce                	je     802170 <spawn+0x442>
  8021a2:	eb aa                	jmp    80214e <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8021a4:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8021ab:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8021ae:	83 ec 08             	sub    $0x8,%esp
  8021b1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8021b7:	50                   	push   %eax
  8021b8:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8021be:	e8 cb ef ff ff       	call   80118e <sys_env_set_trapframe>
  8021c3:	83 c4 10             	add    $0x10,%esp
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	78 25                	js     8021ef <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8021ca:	83 ec 08             	sub    $0x8,%esp
  8021cd:	6a 02                	push   $0x2
  8021cf:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8021d5:	e8 72 ef ff ff       	call   80114c <sys_env_set_status>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 23                	js     802204 <spawn+0x4d6>
	return child;
  8021e1:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021e7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8021ed:	eb 36                	jmp    802225 <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  8021ef:	50                   	push   %eax
  8021f0:	68 d2 30 80 00       	push   $0x8030d2
  8021f5:	68 86 00 00 00       	push   $0x86
  8021fa:	68 a9 30 80 00       	push   $0x8030a9
  8021ff:	e8 e5 e2 ff ff       	call   8004e9 <_panic>
		panic("sys_env_set_status: %e", r);
  802204:	50                   	push   %eax
  802205:	68 a3 2f 80 00       	push   $0x802fa3
  80220a:	68 89 00 00 00       	push   $0x89
  80220f:	68 a9 30 80 00       	push   $0x8030a9
  802214:	e8 d0 e2 ff ff       	call   8004e9 <_panic>
		return r;
  802219:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80221f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  802225:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80222b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5f                   	pop    %edi
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    
  802233:	89 c7                	mov    %eax,%edi
  802235:	e9 33 fe ff ff       	jmp    80206d <spawn+0x33f>
  80223a:	89 c7                	mov    %eax,%edi
  80223c:	e9 2c fe ff ff       	jmp    80206d <spawn+0x33f>
  802241:	89 c7                	mov    %eax,%edi
  802243:	e9 25 fe ff ff       	jmp    80206d <spawn+0x33f>
		return -E_NO_MEM;
  802248:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  80224d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802253:	eb d0                	jmp    802225 <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  802255:	83 ec 08             	sub    $0x8,%esp
  802258:	68 00 00 40 00       	push   $0x400000
  80225d:	6a 00                	push   $0x0
  80225f:	e8 a6 ee ff ff       	call   80110a <sys_page_unmap>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80226d:	eb b6                	jmp    802225 <spawn+0x4f7>

0080226f <spawnl>:
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	56                   	push   %esi
  802273:	53                   	push   %ebx
	va_start(vl, arg0);
  802274:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80227c:	eb 05                	jmp    802283 <spawnl+0x14>
		argc++;
  80227e:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802281:	89 ca                	mov    %ecx,%edx
  802283:	8d 4a 04             	lea    0x4(%edx),%ecx
  802286:	83 3a 00             	cmpl   $0x0,(%edx)
  802289:	75 f3                	jne    80227e <spawnl+0xf>
	const char *argv[argc+2];
  80228b:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802292:	89 d3                	mov    %edx,%ebx
  802294:	83 e3 f0             	and    $0xfffffff0,%ebx
  802297:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80229d:	89 e1                	mov    %esp,%ecx
  80229f:	29 d1                	sub    %edx,%ecx
  8022a1:	39 cc                	cmp    %ecx,%esp
  8022a3:	74 10                	je     8022b5 <spawnl+0x46>
  8022a5:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8022ab:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8022b2:	00 
  8022b3:	eb ec                	jmp    8022a1 <spawnl+0x32>
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8022bd:	29 d4                	sub    %edx,%esp
  8022bf:	85 d2                	test   %edx,%edx
  8022c1:	74 05                	je     8022c8 <spawnl+0x59>
  8022c3:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8022c8:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  8022cc:	89 da                	mov    %ebx,%edx
  8022ce:	c1 ea 02             	shr    $0x2,%edx
  8022d1:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  8022d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022d7:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8022de:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  8022e5:	00 
	va_start(vl, arg0);
  8022e6:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8022e9:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	eb 0b                	jmp    8022fd <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  8022f2:	83 c0 01             	add    $0x1,%eax
  8022f5:	8b 31                	mov    (%ecx),%esi
  8022f7:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  8022fa:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8022fd:	39 d0                	cmp    %edx,%eax
  8022ff:	75 f1                	jne    8022f2 <spawnl+0x83>
	return spawn(prog, argv);
  802301:	83 ec 08             	sub    $0x8,%esp
  802304:	53                   	push   %ebx
  802305:	ff 75 08             	push   0x8(%ebp)
  802308:	e8 21 fa ff ff       	call   801d2e <spawn>
}
  80230d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	56                   	push   %esi
  802318:	53                   	push   %ebx
  802319:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	ff 75 08             	push   0x8(%ebp)
  802322:	e8 f6 f1 ff ff       	call   80151d <fd2data>
  802327:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802329:	83 c4 08             	add    $0x8,%esp
  80232c:	68 12 31 80 00       	push   $0x803112
  802331:	53                   	push   %ebx
  802332:	e8 52 e9 ff ff       	call   800c89 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802337:	8b 46 04             	mov    0x4(%esi),%eax
  80233a:	2b 06                	sub    (%esi),%eax
  80233c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802342:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802349:	00 00 00 
	stat->st_dev = &devpipe;
  80234c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802353:	40 80 00 
	return 0;
}
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
  80235b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5d                   	pop    %ebp
  802361:	c3                   	ret    

00802362 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	53                   	push   %ebx
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80236c:	53                   	push   %ebx
  80236d:	6a 00                	push   $0x0
  80236f:	e8 96 ed ff ff       	call   80110a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802374:	89 1c 24             	mov    %ebx,(%esp)
  802377:	e8 a1 f1 ff ff       	call   80151d <fd2data>
  80237c:	83 c4 08             	add    $0x8,%esp
  80237f:	50                   	push   %eax
  802380:	6a 00                	push   $0x0
  802382:	e8 83 ed ff ff       	call   80110a <sys_page_unmap>
}
  802387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <_pipeisclosed>:
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	57                   	push   %edi
  802390:	56                   	push   %esi
  802391:	53                   	push   %ebx
  802392:	83 ec 1c             	sub    $0x1c,%esp
  802395:	89 c7                	mov    %eax,%edi
  802397:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802399:	a1 00 50 80 00       	mov    0x805000,%eax
  80239e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	57                   	push   %edi
  8023a5:	e8 6a 04 00 00       	call   802814 <pageref>
  8023aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023ad:	89 34 24             	mov    %esi,(%esp)
  8023b0:	e8 5f 04 00 00       	call   802814 <pageref>
		nn = thisenv->env_runs;
  8023b5:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8023bb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	39 cb                	cmp    %ecx,%ebx
  8023c3:	74 1b                	je     8023e0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023c8:	75 cf                	jne    802399 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023ca:	8b 42 58             	mov    0x58(%edx),%eax
  8023cd:	6a 01                	push   $0x1
  8023cf:	50                   	push   %eax
  8023d0:	53                   	push   %ebx
  8023d1:	68 19 31 80 00       	push   $0x803119
  8023d6:	e8 e9 e1 ff ff       	call   8005c4 <cprintf>
  8023db:	83 c4 10             	add    $0x10,%esp
  8023de:	eb b9                	jmp    802399 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023e0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023e3:	0f 94 c0             	sete   %al
  8023e6:	0f b6 c0             	movzbl %al,%eax
}
  8023e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    

008023f1 <devpipe_write>:
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	57                   	push   %edi
  8023f5:	56                   	push   %esi
  8023f6:	53                   	push   %ebx
  8023f7:	83 ec 28             	sub    $0x28,%esp
  8023fa:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023fd:	56                   	push   %esi
  8023fe:	e8 1a f1 ff ff       	call   80151d <fd2data>
  802403:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	bf 00 00 00 00       	mov    $0x0,%edi
  80240d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802410:	75 09                	jne    80241b <devpipe_write+0x2a>
	return i;
  802412:	89 f8                	mov    %edi,%eax
  802414:	eb 23                	jmp    802439 <devpipe_write+0x48>
			sys_yield();
  802416:	e8 4b ec ff ff       	call   801066 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80241b:	8b 43 04             	mov    0x4(%ebx),%eax
  80241e:	8b 0b                	mov    (%ebx),%ecx
  802420:	8d 51 20             	lea    0x20(%ecx),%edx
  802423:	39 d0                	cmp    %edx,%eax
  802425:	72 1a                	jb     802441 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  802427:	89 da                	mov    %ebx,%edx
  802429:	89 f0                	mov    %esi,%eax
  80242b:	e8 5c ff ff ff       	call   80238c <_pipeisclosed>
  802430:	85 c0                	test   %eax,%eax
  802432:	74 e2                	je     802416 <devpipe_write+0x25>
				return 0;
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802439:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802441:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802444:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802448:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80244b:	89 c2                	mov    %eax,%edx
  80244d:	c1 fa 1f             	sar    $0x1f,%edx
  802450:	89 d1                	mov    %edx,%ecx
  802452:	c1 e9 1b             	shr    $0x1b,%ecx
  802455:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802458:	83 e2 1f             	and    $0x1f,%edx
  80245b:	29 ca                	sub    %ecx,%edx
  80245d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802461:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802465:	83 c0 01             	add    $0x1,%eax
  802468:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80246b:	83 c7 01             	add    $0x1,%edi
  80246e:	eb 9d                	jmp    80240d <devpipe_write+0x1c>

00802470 <devpipe_read>:
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	57                   	push   %edi
  802474:	56                   	push   %esi
  802475:	53                   	push   %ebx
  802476:	83 ec 18             	sub    $0x18,%esp
  802479:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80247c:	57                   	push   %edi
  80247d:	e8 9b f0 ff ff       	call   80151d <fd2data>
  802482:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802484:	83 c4 10             	add    $0x10,%esp
  802487:	be 00 00 00 00       	mov    $0x0,%esi
  80248c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80248f:	75 13                	jne    8024a4 <devpipe_read+0x34>
	return i;
  802491:	89 f0                	mov    %esi,%eax
  802493:	eb 02                	jmp    802497 <devpipe_read+0x27>
				return i;
  802495:	89 f0                	mov    %esi,%eax
}
  802497:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249a:	5b                   	pop    %ebx
  80249b:	5e                   	pop    %esi
  80249c:	5f                   	pop    %edi
  80249d:	5d                   	pop    %ebp
  80249e:	c3                   	ret    
			sys_yield();
  80249f:	e8 c2 eb ff ff       	call   801066 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024a4:	8b 03                	mov    (%ebx),%eax
  8024a6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024a9:	75 18                	jne    8024c3 <devpipe_read+0x53>
			if (i > 0)
  8024ab:	85 f6                	test   %esi,%esi
  8024ad:	75 e6                	jne    802495 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  8024af:	89 da                	mov    %ebx,%edx
  8024b1:	89 f8                	mov    %edi,%eax
  8024b3:	e8 d4 fe ff ff       	call   80238c <_pipeisclosed>
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 e3                	je     80249f <devpipe_read+0x2f>
				return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	eb d4                	jmp    802497 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c3:	99                   	cltd   
  8024c4:	c1 ea 1b             	shr    $0x1b,%edx
  8024c7:	01 d0                	add    %edx,%eax
  8024c9:	83 e0 1f             	and    $0x1f,%eax
  8024cc:	29 d0                	sub    %edx,%eax
  8024ce:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024d9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024dc:	83 c6 01             	add    $0x1,%esi
  8024df:	eb ab                	jmp    80248c <devpipe_read+0x1c>

008024e1 <pipe>:
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	56                   	push   %esi
  8024e5:	53                   	push   %ebx
  8024e6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ec:	50                   	push   %eax
  8024ed:	e8 42 f0 ff ff       	call   801534 <fd_alloc>
  8024f2:	89 c3                	mov    %eax,%ebx
  8024f4:	83 c4 10             	add    $0x10,%esp
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	0f 88 23 01 00 00    	js     802622 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ff:	83 ec 04             	sub    $0x4,%esp
  802502:	68 07 04 00 00       	push   $0x407
  802507:	ff 75 f4             	push   -0xc(%ebp)
  80250a:	6a 00                	push   $0x0
  80250c:	e8 74 eb ff ff       	call   801085 <sys_page_alloc>
  802511:	89 c3                	mov    %eax,%ebx
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	85 c0                	test   %eax,%eax
  802518:	0f 88 04 01 00 00    	js     802622 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80251e:	83 ec 0c             	sub    $0xc,%esp
  802521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802524:	50                   	push   %eax
  802525:	e8 0a f0 ff ff       	call   801534 <fd_alloc>
  80252a:	89 c3                	mov    %eax,%ebx
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	85 c0                	test   %eax,%eax
  802531:	0f 88 db 00 00 00    	js     802612 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 07 04 00 00       	push   $0x407
  80253f:	ff 75 f0             	push   -0x10(%ebp)
  802542:	6a 00                	push   $0x0
  802544:	e8 3c eb ff ff       	call   801085 <sys_page_alloc>
  802549:	89 c3                	mov    %eax,%ebx
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	0f 88 bc 00 00 00    	js     802612 <pipe+0x131>
	va = fd2data(fd0);
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	ff 75 f4             	push   -0xc(%ebp)
  80255c:	e8 bc ef ff ff       	call   80151d <fd2data>
  802561:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802563:	83 c4 0c             	add    $0xc,%esp
  802566:	68 07 04 00 00       	push   $0x407
  80256b:	50                   	push   %eax
  80256c:	6a 00                	push   $0x0
  80256e:	e8 12 eb ff ff       	call   801085 <sys_page_alloc>
  802573:	89 c3                	mov    %eax,%ebx
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	85 c0                	test   %eax,%eax
  80257a:	0f 88 82 00 00 00    	js     802602 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802580:	83 ec 0c             	sub    $0xc,%esp
  802583:	ff 75 f0             	push   -0x10(%ebp)
  802586:	e8 92 ef ff ff       	call   80151d <fd2data>
  80258b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802592:	50                   	push   %eax
  802593:	6a 00                	push   $0x0
  802595:	56                   	push   %esi
  802596:	6a 00                	push   $0x0
  802598:	e8 2b eb ff ff       	call   8010c8 <sys_page_map>
  80259d:	89 c3                	mov    %eax,%ebx
  80259f:	83 c4 20             	add    $0x20,%esp
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	78 4e                	js     8025f4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025a6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025bd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	ff 75 f4             	push   -0xc(%ebp)
  8025cf:	e8 39 ef ff ff       	call   80150d <fd2num>
  8025d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025d7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025d9:	83 c4 04             	add    $0x4,%esp
  8025dc:	ff 75 f0             	push   -0x10(%ebp)
  8025df:	e8 29 ef ff ff       	call   80150d <fd2num>
  8025e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025ea:	83 c4 10             	add    $0x10,%esp
  8025ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025f2:	eb 2e                	jmp    802622 <pipe+0x141>
	sys_page_unmap(0, va);
  8025f4:	83 ec 08             	sub    $0x8,%esp
  8025f7:	56                   	push   %esi
  8025f8:	6a 00                	push   $0x0
  8025fa:	e8 0b eb ff ff       	call   80110a <sys_page_unmap>
  8025ff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802602:	83 ec 08             	sub    $0x8,%esp
  802605:	ff 75 f0             	push   -0x10(%ebp)
  802608:	6a 00                	push   $0x0
  80260a:	e8 fb ea ff ff       	call   80110a <sys_page_unmap>
  80260f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802612:	83 ec 08             	sub    $0x8,%esp
  802615:	ff 75 f4             	push   -0xc(%ebp)
  802618:	6a 00                	push   $0x0
  80261a:	e8 eb ea ff ff       	call   80110a <sys_page_unmap>
  80261f:	83 c4 10             	add    $0x10,%esp
}
  802622:	89 d8                	mov    %ebx,%eax
  802624:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    

0080262b <pipeisclosed>:
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802631:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802634:	50                   	push   %eax
  802635:	ff 75 08             	push   0x8(%ebp)
  802638:	e8 47 ef ff ff       	call   801584 <fd_lookup>
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	85 c0                	test   %eax,%eax
  802642:	78 18                	js     80265c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802644:	83 ec 0c             	sub    $0xc,%esp
  802647:	ff 75 f4             	push   -0xc(%ebp)
  80264a:	e8 ce ee ff ff       	call   80151d <fd2data>
  80264f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	e8 33 fd ff ff       	call   80238c <_pipeisclosed>
  802659:	83 c4 10             	add    $0x10,%esp
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	56                   	push   %esi
  802662:	53                   	push   %ebx
  802663:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802666:	85 f6                	test   %esi,%esi
  802668:	74 13                	je     80267d <wait+0x1f>
	e = &envs[ENVX(envid)];
  80266a:	89 f3                	mov    %esi,%ebx
  80266c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802672:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802675:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80267b:	eb 1b                	jmp    802698 <wait+0x3a>
	assert(envid != 0);
  80267d:	68 31 31 80 00       	push   $0x803131
  802682:	68 63 30 80 00       	push   $0x803063
  802687:	6a 09                	push   $0x9
  802689:	68 3c 31 80 00       	push   $0x80313c
  80268e:	e8 56 de ff ff       	call   8004e9 <_panic>
		sys_yield();
  802693:	e8 ce e9 ff ff       	call   801066 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802698:	8b 43 48             	mov    0x48(%ebx),%eax
  80269b:	39 f0                	cmp    %esi,%eax
  80269d:	75 07                	jne    8026a6 <wait+0x48>
  80269f:	8b 43 54             	mov    0x54(%ebx),%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 ed                	jne    802693 <wait+0x35>
}
  8026a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a9:	5b                   	pop    %ebx
  8026aa:	5e                   	pop    %esi
  8026ab:	5d                   	pop    %ebp
  8026ac:	c3                   	ret    

008026ad <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026b3:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  8026ba:	74 20                	je     8026dc <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	a3 04 70 80 00       	mov    %eax,0x807004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8026c4:	83 ec 08             	sub    $0x8,%esp
  8026c7:	68 1c 27 80 00       	push   $0x80271c
  8026cc:	6a 00                	push   $0x0
  8026ce:	e8 fd ea ff ff       	call   8011d0 <sys_env_set_pgfault_upcall>
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	78 2e                	js     802708 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8026dc:	83 ec 04             	sub    $0x4,%esp
  8026df:	6a 07                	push   $0x7
  8026e1:	68 00 f0 bf ee       	push   $0xeebff000
  8026e6:	6a 00                	push   $0x0
  8026e8:	e8 98 e9 ff ff       	call   801085 <sys_page_alloc>
  8026ed:	83 c4 10             	add    $0x10,%esp
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	79 c8                	jns    8026bc <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 48 31 80 00       	push   $0x803148
  8026fc:	6a 21                	push   $0x21
  8026fe:	68 ab 31 80 00       	push   $0x8031ab
  802703:	e8 e1 dd ff ff       	call   8004e9 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 74 31 80 00       	push   $0x803174
  802710:	6a 27                	push   $0x27
  802712:	68 ab 31 80 00       	push   $0x8031ab
  802717:	e8 cd dd ff ff       	call   8004e9 <_panic>

0080271c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80271c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80271d:	a1 04 70 80 00       	mov    0x807004,%eax
	call *%eax
  802722:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802724:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  802727:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  80272b:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  802730:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  802734:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  802736:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802739:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80273a:	83 c4 04             	add    $0x4,%esp
	popfl
  80273d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80273e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80273f:	c3                   	ret    

00802740 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	56                   	push   %esi
  802744:	53                   	push   %ebx
  802745:	8b 75 08             	mov    0x8(%ebp),%esi
  802748:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80274b:	83 ec 0c             	sub    $0xc,%esp
  80274e:	ff 75 0c             	push   0xc(%ebp)
  802751:	e8 df ea ff ff       	call   801235 <sys_ipc_recv>
  802756:	83 c4 10             	add    $0x10,%esp
  802759:	85 c0                	test   %eax,%eax
  80275b:	78 2b                	js     802788 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80275d:	85 f6                	test   %esi,%esi
  80275f:	74 0a                	je     80276b <ipc_recv+0x2b>
  802761:	a1 00 50 80 00       	mov    0x805000,%eax
  802766:	8b 40 74             	mov    0x74(%eax),%eax
  802769:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80276b:	85 db                	test   %ebx,%ebx
  80276d:	74 0a                	je     802779 <ipc_recv+0x39>
  80276f:	a1 00 50 80 00       	mov    0x805000,%eax
  802774:	8b 40 78             	mov    0x78(%eax),%eax
  802777:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802779:	a1 00 50 80 00       	mov    0x805000,%eax
  80277e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802781:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802784:	5b                   	pop    %ebx
  802785:	5e                   	pop    %esi
  802786:	5d                   	pop    %ebp
  802787:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80278d:	eb f2                	jmp    802781 <ipc_recv+0x41>

0080278f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	57                   	push   %edi
  802793:	56                   	push   %esi
  802794:	53                   	push   %ebx
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	8b 7d 08             	mov    0x8(%ebp),%edi
  80279b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80279e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8027a1:	ff 75 14             	push   0x14(%ebp)
  8027a4:	53                   	push   %ebx
  8027a5:	56                   	push   %esi
  8027a6:	57                   	push   %edi
  8027a7:	e8 66 ea ff ff       	call   801212 <sys_ipc_try_send>
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	79 20                	jns    8027d3 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8027b3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027b6:	75 07                	jne    8027bf <ipc_send+0x30>
		sys_yield();
  8027b8:	e8 a9 e8 ff ff       	call   801066 <sys_yield>
  8027bd:	eb e2                	jmp    8027a1 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 b9 31 80 00       	push   $0x8031b9
  8027c7:	6a 2e                	push   $0x2e
  8027c9:	68 c9 31 80 00       	push   $0x8031c9
  8027ce:	e8 16 dd ff ff       	call   8004e9 <_panic>
	}
}
  8027d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027d6:	5b                   	pop    %ebx
  8027d7:	5e                   	pop    %esi
  8027d8:	5f                   	pop    %edi
  8027d9:	5d                   	pop    %ebp
  8027da:	c3                   	ret    

008027db <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027e6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027e9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027ef:	8b 52 50             	mov    0x50(%edx),%edx
  8027f2:	39 ca                	cmp    %ecx,%edx
  8027f4:	74 11                	je     802807 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8027f6:	83 c0 01             	add    $0x1,%eax
  8027f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027fe:	75 e6                	jne    8027e6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802800:	b8 00 00 00 00       	mov    $0x0,%eax
  802805:	eb 0b                	jmp    802812 <ipc_find_env+0x37>
			return envs[i].env_id;
  802807:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80280a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80280f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    

00802814 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80281a:	89 c2                	mov    %eax,%edx
  80281c:	c1 ea 16             	shr    $0x16,%edx
  80281f:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802826:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80282b:	f6 c1 01             	test   $0x1,%cl
  80282e:	74 1c                	je     80284c <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802830:	c1 e8 0c             	shr    $0xc,%eax
  802833:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80283a:	a8 01                	test   $0x1,%al
  80283c:	74 0e                	je     80284c <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80283e:	c1 e8 0c             	shr    $0xc,%eax
  802841:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802848:	ef 
  802849:	0f b7 d2             	movzwl %dx,%edx
}
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	5d                   	pop    %ebp
  80284f:	c3                   	ret    

00802850 <__udivdi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80285f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802863:	8b 74 24 34          	mov    0x34(%esp),%esi
  802867:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 19                	jne    802888 <__udivdi3+0x38>
  80286f:	39 f3                	cmp    %esi,%ebx
  802871:	76 4d                	jbe    8028c0 <__udivdi3+0x70>
  802873:	31 ff                	xor    %edi,%edi
  802875:	89 e8                	mov    %ebp,%eax
  802877:	89 f2                	mov    %esi,%edx
  802879:	f7 f3                	div    %ebx
  80287b:	89 fa                	mov    %edi,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	39 f0                	cmp    %esi,%eax
  80288a:	76 14                	jbe    8028a0 <__udivdi3+0x50>
  80288c:	31 ff                	xor    %edi,%edi
  80288e:	31 c0                	xor    %eax,%eax
  802890:	89 fa                	mov    %edi,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028a0:	0f bd f8             	bsr    %eax,%edi
  8028a3:	83 f7 1f             	xor    $0x1f,%edi
  8028a6:	75 48                	jne    8028f0 <__udivdi3+0xa0>
  8028a8:	39 f0                	cmp    %esi,%eax
  8028aa:	72 06                	jb     8028b2 <__udivdi3+0x62>
  8028ac:	31 c0                	xor    %eax,%eax
  8028ae:	39 eb                	cmp    %ebp,%ebx
  8028b0:	77 de                	ja     802890 <__udivdi3+0x40>
  8028b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b7:	eb d7                	jmp    802890 <__udivdi3+0x40>
  8028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c0:	89 d9                	mov    %ebx,%ecx
  8028c2:	85 db                	test   %ebx,%ebx
  8028c4:	75 0b                	jne    8028d1 <__udivdi3+0x81>
  8028c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	f7 f3                	div    %ebx
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	31 d2                	xor    %edx,%edx
  8028d3:	89 f0                	mov    %esi,%eax
  8028d5:	f7 f1                	div    %ecx
  8028d7:	89 c6                	mov    %eax,%esi
  8028d9:	89 e8                	mov    %ebp,%eax
  8028db:	89 f7                	mov    %esi,%edi
  8028dd:	f7 f1                	div    %ecx
  8028df:	89 fa                	mov    %edi,%edx
  8028e1:	83 c4 1c             	add    $0x1c,%esp
  8028e4:	5b                   	pop    %ebx
  8028e5:	5e                   	pop    %esi
  8028e6:	5f                   	pop    %edi
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    
  8028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f0:	89 f9                	mov    %edi,%ecx
  8028f2:	ba 20 00 00 00       	mov    $0x20,%edx
  8028f7:	29 fa                	sub    %edi,%edx
  8028f9:	d3 e0                	shl    %cl,%eax
  8028fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ff:	89 d1                	mov    %edx,%ecx
  802901:	89 d8                	mov    %ebx,%eax
  802903:	d3 e8                	shr    %cl,%eax
  802905:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802909:	09 c1                	or     %eax,%ecx
  80290b:	89 f0                	mov    %esi,%eax
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 f9                	mov    %edi,%ecx
  802913:	d3 e3                	shl    %cl,%ebx
  802915:	89 d1                	mov    %edx,%ecx
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 f9                	mov    %edi,%ecx
  80291b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80291f:	89 eb                	mov    %ebp,%ebx
  802921:	d3 e6                	shl    %cl,%esi
  802923:	89 d1                	mov    %edx,%ecx
  802925:	d3 eb                	shr    %cl,%ebx
  802927:	09 f3                	or     %esi,%ebx
  802929:	89 c6                	mov    %eax,%esi
  80292b:	89 f2                	mov    %esi,%edx
  80292d:	89 d8                	mov    %ebx,%eax
  80292f:	f7 74 24 08          	divl   0x8(%esp)
  802933:	89 d6                	mov    %edx,%esi
  802935:	89 c3                	mov    %eax,%ebx
  802937:	f7 64 24 0c          	mull   0xc(%esp)
  80293b:	39 d6                	cmp    %edx,%esi
  80293d:	72 19                	jb     802958 <__udivdi3+0x108>
  80293f:	89 f9                	mov    %edi,%ecx
  802941:	d3 e5                	shl    %cl,%ebp
  802943:	39 c5                	cmp    %eax,%ebp
  802945:	73 04                	jae    80294b <__udivdi3+0xfb>
  802947:	39 d6                	cmp    %edx,%esi
  802949:	74 0d                	je     802958 <__udivdi3+0x108>
  80294b:	89 d8                	mov    %ebx,%eax
  80294d:	31 ff                	xor    %edi,%edi
  80294f:	e9 3c ff ff ff       	jmp    802890 <__udivdi3+0x40>
  802954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802958:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80295b:	31 ff                	xor    %edi,%edi
  80295d:	e9 2e ff ff ff       	jmp    802890 <__udivdi3+0x40>
  802962:	66 90                	xchg   %ax,%ax
  802964:	66 90                	xchg   %ax,%ax
  802966:	66 90                	xchg   %ax,%ax
  802968:	66 90                	xchg   %ax,%ax
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	66 90                	xchg   %ax,%ax
  80296e:	66 90                	xchg   %ax,%ax

00802970 <__umoddi3>:
  802970:	f3 0f 1e fb          	endbr32 
  802974:	55                   	push   %ebp
  802975:	57                   	push   %edi
  802976:	56                   	push   %esi
  802977:	53                   	push   %ebx
  802978:	83 ec 1c             	sub    $0x1c,%esp
  80297b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80297f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802983:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802987:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80298b:	89 f0                	mov    %esi,%eax
  80298d:	89 da                	mov    %ebx,%edx
  80298f:	85 ff                	test   %edi,%edi
  802991:	75 15                	jne    8029a8 <__umoddi3+0x38>
  802993:	39 dd                	cmp    %ebx,%ebp
  802995:	76 39                	jbe    8029d0 <__umoddi3+0x60>
  802997:	f7 f5                	div    %ebp
  802999:	89 d0                	mov    %edx,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	83 c4 1c             	add    $0x1c,%esp
  8029a0:	5b                   	pop    %ebx
  8029a1:	5e                   	pop    %esi
  8029a2:	5f                   	pop    %edi
  8029a3:	5d                   	pop    %ebp
  8029a4:	c3                   	ret    
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	39 df                	cmp    %ebx,%edi
  8029aa:	77 f1                	ja     80299d <__umoddi3+0x2d>
  8029ac:	0f bd cf             	bsr    %edi,%ecx
  8029af:	83 f1 1f             	xor    $0x1f,%ecx
  8029b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029b6:	75 40                	jne    8029f8 <__umoddi3+0x88>
  8029b8:	39 df                	cmp    %ebx,%edi
  8029ba:	72 04                	jb     8029c0 <__umoddi3+0x50>
  8029bc:	39 f5                	cmp    %esi,%ebp
  8029be:	77 dd                	ja     80299d <__umoddi3+0x2d>
  8029c0:	89 da                	mov    %ebx,%edx
  8029c2:	89 f0                	mov    %esi,%eax
  8029c4:	29 e8                	sub    %ebp,%eax
  8029c6:	19 fa                	sbb    %edi,%edx
  8029c8:	eb d3                	jmp    80299d <__umoddi3+0x2d>
  8029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029d0:	89 e9                	mov    %ebp,%ecx
  8029d2:	85 ed                	test   %ebp,%ebp
  8029d4:	75 0b                	jne    8029e1 <__umoddi3+0x71>
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	f7 f5                	div    %ebp
  8029df:	89 c1                	mov    %eax,%ecx
  8029e1:	89 d8                	mov    %ebx,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f1                	div    %ecx
  8029e7:	89 f0                	mov    %esi,%eax
  8029e9:	f7 f1                	div    %ecx
  8029eb:	89 d0                	mov    %edx,%eax
  8029ed:	31 d2                	xor    %edx,%edx
  8029ef:	eb ac                	jmp    80299d <__umoddi3+0x2d>
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029fc:	ba 20 00 00 00       	mov    $0x20,%edx
  802a01:	29 c2                	sub    %eax,%edx
  802a03:	89 c1                	mov    %eax,%ecx
  802a05:	89 e8                	mov    %ebp,%eax
  802a07:	d3 e7                	shl    %cl,%edi
  802a09:	89 d1                	mov    %edx,%ecx
  802a0b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a0f:	d3 e8                	shr    %cl,%eax
  802a11:	89 c1                	mov    %eax,%ecx
  802a13:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a17:	09 f9                	or     %edi,%ecx
  802a19:	89 df                	mov    %ebx,%edi
  802a1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	d3 e5                	shl    %cl,%ebp
  802a23:	89 d1                	mov    %edx,%ecx
  802a25:	d3 ef                	shr    %cl,%edi
  802a27:	89 c1                	mov    %eax,%ecx
  802a29:	89 f0                	mov    %esi,%eax
  802a2b:	d3 e3                	shl    %cl,%ebx
  802a2d:	89 d1                	mov    %edx,%ecx
  802a2f:	89 fa                	mov    %edi,%edx
  802a31:	d3 e8                	shr    %cl,%eax
  802a33:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a38:	09 d8                	or     %ebx,%eax
  802a3a:	f7 74 24 08          	divl   0x8(%esp)
  802a3e:	89 d3                	mov    %edx,%ebx
  802a40:	d3 e6                	shl    %cl,%esi
  802a42:	f7 e5                	mul    %ebp
  802a44:	89 c7                	mov    %eax,%edi
  802a46:	89 d1                	mov    %edx,%ecx
  802a48:	39 d3                	cmp    %edx,%ebx
  802a4a:	72 06                	jb     802a52 <__umoddi3+0xe2>
  802a4c:	75 0e                	jne    802a5c <__umoddi3+0xec>
  802a4e:	39 c6                	cmp    %eax,%esi
  802a50:	73 0a                	jae    802a5c <__umoddi3+0xec>
  802a52:	29 e8                	sub    %ebp,%eax
  802a54:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a58:	89 d1                	mov    %edx,%ecx
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	89 f5                	mov    %esi,%ebp
  802a5e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a62:	29 fd                	sub    %edi,%ebp
  802a64:	19 cb                	sbb    %ecx,%ebx
  802a66:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802a6b:	89 d8                	mov    %ebx,%eax
  802a6d:	d3 e0                	shl    %cl,%eax
  802a6f:	89 f1                	mov    %esi,%ecx
  802a71:	d3 ed                	shr    %cl,%ebp
  802a73:	d3 eb                	shr    %cl,%ebx
  802a75:	09 e8                	or     %ebp,%eax
  802a77:	89 da                	mov    %ebx,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
