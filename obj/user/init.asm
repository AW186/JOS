
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 5d 03 00 00       	call   80038e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b9 00 00 00 00       	mov    $0x0,%ecx
	for (i = 0; i < n; i++)
  800043:	b8 00 00 00 00       	mov    $0x0,%eax
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 14 06          	movsbl (%esi,%eax,1),%edx
  80004e:	0f af d0             	imul   %eax,%edx
  800051:	31 d1                	xor    %edx,%ecx
	for (i = 0; i < n; i++)
  800053:	83 c0 01             	add    $0x1,%eax
  800056:	39 d8                	cmp    %ebx,%eax
  800058:	7c f0                	jl     80004a <sum+0x17>
	return tot;
}
  80005a:	89 c8                	mov    %ecx,%eax
  80005c:	5b                   	pop    %ebx
  80005d:	5e                   	pop    %esi
  80005e:	5d                   	pop    %ebp
  80005f:	c3                   	ret    

00800060 <umain>:

void
umain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	57                   	push   %edi
  800064:	56                   	push   %esi
  800065:	53                   	push   %ebx
  800066:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006f:	68 80 26 80 00       	push   $0x802680
  800074:	e8 48 04 00 00       	call   8004c1 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800079:	83 c4 08             	add    $0x8,%esp
  80007c:	68 70 17 00 00       	push   $0x1770
  800081:	68 00 30 80 00       	push   $0x803000
  800086:	e8 a8 ff ff ff       	call   800033 <sum>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800093:	74 64                	je     8000f9 <umain+0x99>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800095:	83 ec 04             	sub    $0x4,%esp
  800098:	68 9e 98 0f 00       	push   $0xf989e
  80009d:	50                   	push   %eax
  80009e:	68 48 27 80 00       	push   $0x802748
  8000a3:	e8 19 04 00 00       	call   8004c1 <cprintf>
  8000a8:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	68 70 17 00 00       	push   $0x1770
  8000b3:	68 00 50 80 00       	push   $0x805000
  8000b8:	e8 76 ff ff ff       	call   800033 <sum>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	85 c0                	test   %eax,%eax
  8000c2:	74 47                	je     80010b <umain+0xab>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	50                   	push   %eax
  8000c8:	68 84 27 80 00       	push   $0x802784
  8000cd:	e8 ef 03 00 00       	call   8004c1 <cprintf>
  8000d2:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	68 bc 26 80 00       	push   $0x8026bc
  8000dd:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e3:	50                   	push   %eax
  8000e4:	e8 c1 0a 00 00       	call   800baa <strcat>
	for (i = 0; i < argc; i++) {
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f1:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f7:	eb 52                	jmp    80014b <umain+0xeb>
		cprintf("init: data seems okay\n");
  8000f9:	83 ec 0c             	sub    $0xc,%esp
  8000fc:	68 8f 26 80 00       	push   $0x80268f
  800101:	e8 bb 03 00 00       	call   8004c1 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	eb a0                	jmp    8000ab <umain+0x4b>
		cprintf("init: bss seems okay\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 a6 26 80 00       	push   $0x8026a6
  800113:	e8 a9 03 00 00       	call   8004c1 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	eb b8                	jmp    8000d5 <umain+0x75>
		strcat(args, " '");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 c8 26 80 00       	push   $0x8026c8
  800125:	56                   	push   %esi
  800126:	e8 7f 0a 00 00       	call   800baa <strcat>
		strcat(args, argv[i]);
  80012b:	83 c4 08             	add    $0x8,%esp
  80012e:	ff 34 9f             	push   (%edi,%ebx,4)
  800131:	56                   	push   %esi
  800132:	e8 73 0a 00 00       	call   800baa <strcat>
		strcat(args, "'");
  800137:	83 c4 08             	add    $0x8,%esp
  80013a:	68 c9 26 80 00       	push   $0x8026c9
  80013f:	56                   	push   %esi
  800140:	e8 65 0a 00 00       	call   800baa <strcat>
	for (i = 0; i < argc; i++) {
  800145:	83 c3 01             	add    $0x1,%ebx
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80014e:	7c cd                	jl     80011d <umain+0xbd>
	}
	cprintf("%s\n", args);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800159:	50                   	push   %eax
  80015a:	68 cb 26 80 00       	push   $0x8026cb
  80015f:	e8 5d 03 00 00       	call   8004c1 <cprintf>

	cprintf("init: running sh\n");
  800164:	c7 04 24 cf 26 80 00 	movl   $0x8026cf,(%esp)
  80016b:	e8 51 03 00 00       	call   8004c1 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800170:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800177:	e8 96 11 00 00       	call   801312 <close>
	if ((r = opencons()) < 0)
  80017c:	e8 bb 01 00 00       	call   80033c <opencons>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 14                	js     80019c <umain+0x13c>
		panic("opencons: %e", r);
	if (r != 0)
  800188:	74 24                	je     8001ae <umain+0x14e>
		panic("first opencons used fd %d", r);
  80018a:	50                   	push   %eax
  80018b:	68 fa 26 80 00       	push   $0x8026fa
  800190:	6a 39                	push   $0x39
  800192:	68 ee 26 80 00       	push   $0x8026ee
  800197:	e8 4a 02 00 00       	call   8003e6 <_panic>
		panic("opencons: %e", r);
  80019c:	50                   	push   %eax
  80019d:	68 e1 26 80 00       	push   $0x8026e1
  8001a2:	6a 37                	push   $0x37
  8001a4:	68 ee 26 80 00       	push   $0x8026ee
  8001a9:	e8 38 02 00 00       	call   8003e6 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 01                	push   $0x1
  8001b3:	6a 00                	push   $0x0
  8001b5:	e8 aa 11 00 00       	call   801364 <dup>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	79 23                	jns    8001e4 <umain+0x184>
		panic("dup: %e", r);
  8001c1:	50                   	push   %eax
  8001c2:	68 14 27 80 00       	push   $0x802714
  8001c7:	6a 3b                	push   $0x3b
  8001c9:	68 ee 26 80 00       	push   $0x8026ee
  8001ce:	e8 13 02 00 00       	call   8003e6 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	50                   	push   %eax
  8001d7:	68 33 27 80 00       	push   $0x802733
  8001dc:	e8 e0 02 00 00       	call   8004c1 <cprintf>
			continue;
  8001e1:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 1c 27 80 00       	push   $0x80271c
  8001ec:	e8 d0 02 00 00       	call   8004c1 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f1:	83 c4 0c             	add    $0xc,%esp
  8001f4:	6a 00                	push   $0x0
  8001f6:	68 30 27 80 00       	push   $0x802730
  8001fb:	68 2f 27 80 00       	push   $0x80272f
  800200:	e8 d0 1c 00 00       	call   801ed5 <spawnl>
		if (r < 0) {
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	85 c0                	test   %eax,%eax
  80020a:	78 c7                	js     8001d3 <umain+0x173>
		}
		wait(r);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 af 20 00 00       	call   8022c4 <wait>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	eb ca                	jmp    8001e4 <umain+0x184>

0080021a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	c3                   	ret    

00800220 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800226:	68 b3 27 80 00       	push   $0x8027b3
  80022b:	ff 75 0c             	push   0xc(%ebp)
  80022e:	e8 53 09 00 00       	call   800b86 <strcpy>
	return 0;
}
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <devcons_write>:
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	57                   	push   %edi
  80023e:	56                   	push   %esi
  80023f:	53                   	push   %ebx
  800240:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800246:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80024b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800251:	eb 2e                	jmp    800281 <devcons_write+0x47>
		m = n - tot;
  800253:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800256:	29 f3                	sub    %esi,%ebx
  800258:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80025d:	39 c3                	cmp    %eax,%ebx
  80025f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	53                   	push   %ebx
  800266:	89 f0                	mov    %esi,%eax
  800268:	03 45 0c             	add    0xc(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	57                   	push   %edi
  80026d:	e8 aa 0a 00 00       	call   800d1c <memmove>
		sys_cputs(buf, m);
  800272:	83 c4 08             	add    $0x8,%esp
  800275:	53                   	push   %ebx
  800276:	57                   	push   %edi
  800277:	e8 4a 0c 00 00       	call   800ec6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80027c:	01 de                	add    %ebx,%esi
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	3b 75 10             	cmp    0x10(%ebp),%esi
  800284:	72 cd                	jb     800253 <devcons_write+0x19>
}
  800286:	89 f0                	mov    %esi,%eax
  800288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028b:	5b                   	pop    %ebx
  80028c:	5e                   	pop    %esi
  80028d:	5f                   	pop    %edi
  80028e:	5d                   	pop    %ebp
  80028f:	c3                   	ret    

00800290 <devcons_read>:
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80029b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80029f:	75 07                	jne    8002a8 <devcons_read+0x18>
  8002a1:	eb 1f                	jmp    8002c2 <devcons_read+0x32>
		sys_yield();
  8002a3:	e8 bb 0c 00 00       	call   800f63 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002a8:	e8 37 0c 00 00       	call   800ee4 <sys_cgetc>
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 f2                	je     8002a3 <devcons_read+0x13>
	if (c < 0)
  8002b1:	78 0f                	js     8002c2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8002b3:	83 f8 04             	cmp    $0x4,%eax
  8002b6:	74 0c                	je     8002c4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	88 02                	mov    %al,(%edx)
	return 1;
  8002bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    
		return 0;
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	eb f7                	jmp    8002c2 <devcons_read+0x32>

008002cb <cputchar>:
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002d7:	6a 01                	push   $0x1
  8002d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002dc:	50                   	push   %eax
  8002dd:	e8 e4 0b 00 00       	call   800ec6 <sys_cputs>
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <getchar>:
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002ed:	6a 01                	push   $0x1
  8002ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002f2:	50                   	push   %eax
  8002f3:	6a 00                	push   $0x0
  8002f5:	e8 54 11 00 00       	call   80144e <read>
	if (r < 0)
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	78 06                	js     800307 <getchar+0x20>
	if (r < 1)
  800301:	74 06                	je     800309 <getchar+0x22>
	return c;
  800303:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800307:	c9                   	leave  
  800308:	c3                   	ret    
		return -E_EOF;
  800309:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80030e:	eb f7                	jmp    800307 <getchar+0x20>

00800310 <iscons>:
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800316:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	ff 75 08             	push   0x8(%ebp)
  80031d:	e8 c8 0e 00 00       	call   8011ea <fd_lookup>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	85 c0                	test   %eax,%eax
  800327:	78 11                	js     80033a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80032c:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800332:	39 10                	cmp    %edx,(%eax)
  800334:	0f 94 c0             	sete   %al
  800337:	0f b6 c0             	movzbl %al,%eax
}
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <opencons>:
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800342:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	e8 4f 0e 00 00       	call   80119a <fd_alloc>
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	85 c0                	test   %eax,%eax
  800350:	78 3a                	js     80038c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	68 07 04 00 00       	push   $0x407
  80035a:	ff 75 f4             	push   -0xc(%ebp)
  80035d:	6a 00                	push   $0x0
  80035f:	e8 1e 0c 00 00       	call   800f82 <sys_page_alloc>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	85 c0                	test   %eax,%eax
  800369:	78 21                	js     80038c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80036b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036e:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800374:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	50                   	push   %eax
  800384:	e8 ea 0d 00 00       	call   801173 <fd2num>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	56                   	push   %esi
  800392:	53                   	push   %ebx
  800393:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800396:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800399:	e8 a6 0b 00 00       	call   800f44 <sys_getenvid>
  80039e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ab:	a3 70 67 80 00       	mov    %eax,0x806770

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b0:	85 db                	test   %ebx,%ebx
  8003b2:	7e 07                	jle    8003bb <libmain+0x2d>
		binaryname = argv[0];
  8003b4:	8b 06                	mov    (%esi),%eax
  8003b6:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	56                   	push   %esi
  8003bf:	53                   	push   %ebx
  8003c0:	e8 9b fc ff ff       	call   800060 <umain>

	// exit gracefully
	exit();
  8003c5:	e8 0a 00 00 00       	call   8003d4 <exit>
}
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003d0:	5b                   	pop    %ebx
  8003d1:	5e                   	pop    %esi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8003da:	6a 00                	push   $0x0
  8003dc:	e8 22 0b 00 00       	call   800f03 <sys_env_destroy>
}
  8003e1:	83 c4 10             	add    $0x10,%esp
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	56                   	push   %esi
  8003ea:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003eb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ee:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  8003f4:	e8 4b 0b 00 00       	call   800f44 <sys_getenvid>
  8003f9:	83 ec 0c             	sub    $0xc,%esp
  8003fc:	ff 75 0c             	push   0xc(%ebp)
  8003ff:	ff 75 08             	push   0x8(%ebp)
  800402:	56                   	push   %esi
  800403:	50                   	push   %eax
  800404:	68 cc 27 80 00       	push   $0x8027cc
  800409:	e8 b3 00 00 00       	call   8004c1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80040e:	83 c4 18             	add    $0x18,%esp
  800411:	53                   	push   %ebx
  800412:	ff 75 10             	push   0x10(%ebp)
  800415:	e8 56 00 00 00       	call   800470 <vcprintf>
	cprintf("\n");
  80041a:	c7 04 24 c9 2c 80 00 	movl   $0x802cc9,(%esp)
  800421:	e8 9b 00 00 00       	call   8004c1 <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800429:	cc                   	int3   
  80042a:	eb fd                	jmp    800429 <_panic+0x43>

0080042c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	53                   	push   %ebx
  800430:	83 ec 04             	sub    $0x4,%esp
  800433:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800436:	8b 13                	mov    (%ebx),%edx
  800438:	8d 42 01             	lea    0x1(%edx),%eax
  80043b:	89 03                	mov    %eax,(%ebx)
  80043d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800440:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800444:	3d ff 00 00 00       	cmp    $0xff,%eax
  800449:	74 09                	je     800454 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80044b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80044f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800452:	c9                   	leave  
  800453:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	68 ff 00 00 00       	push   $0xff
  80045c:	8d 43 08             	lea    0x8(%ebx),%eax
  80045f:	50                   	push   %eax
  800460:	e8 61 0a 00 00       	call   800ec6 <sys_cputs>
		b->idx = 0;
  800465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb db                	jmp    80044b <putch+0x1f>

00800470 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800479:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800480:	00 00 00 
	b.cnt = 0;
  800483:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80048a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80048d:	ff 75 0c             	push   0xc(%ebp)
  800490:	ff 75 08             	push   0x8(%ebp)
  800493:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800499:	50                   	push   %eax
  80049a:	68 2c 04 80 00       	push   $0x80042c
  80049f:	e8 14 01 00 00       	call   8005b8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a4:	83 c4 08             	add    $0x8,%esp
  8004a7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8004ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	e8 0d 0a 00 00       	call   800ec6 <sys_cputs>

	return b.cnt;
}
  8004b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 08             	push   0x8(%ebp)
  8004ce:	e8 9d ff ff ff       	call   800470 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	57                   	push   %edi
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	83 ec 1c             	sub    $0x1c,%esp
  8004de:	89 c7                	mov    %eax,%edi
  8004e0:	89 d6                	mov    %edx,%esi
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e8:	89 d1                	mov    %edx,%ecx
  8004ea:	89 c2                	mov    %eax,%edx
  8004ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	39 c2                	cmp    %eax,%edx
  800504:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800507:	72 3e                	jb     800547 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	ff 75 18             	push   0x18(%ebp)
  80050f:	83 eb 01             	sub    $0x1,%ebx
  800512:	53                   	push   %ebx
  800513:	50                   	push   %eax
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	ff 75 e4             	push   -0x1c(%ebp)
  80051a:	ff 75 e0             	push   -0x20(%ebp)
  80051d:	ff 75 dc             	push   -0x24(%ebp)
  800520:	ff 75 d8             	push   -0x28(%ebp)
  800523:	e8 08 1f 00 00       	call   802430 <__udivdi3>
  800528:	83 c4 18             	add    $0x18,%esp
  80052b:	52                   	push   %edx
  80052c:	50                   	push   %eax
  80052d:	89 f2                	mov    %esi,%edx
  80052f:	89 f8                	mov    %edi,%eax
  800531:	e8 9f ff ff ff       	call   8004d5 <printnum>
  800536:	83 c4 20             	add    $0x20,%esp
  800539:	eb 13                	jmp    80054e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	56                   	push   %esi
  80053f:	ff 75 18             	push   0x18(%ebp)
  800542:	ff d7                	call   *%edi
  800544:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800547:	83 eb 01             	sub    $0x1,%ebx
  80054a:	85 db                	test   %ebx,%ebx
  80054c:	7f ed                	jg     80053b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	56                   	push   %esi
  800552:	83 ec 04             	sub    $0x4,%esp
  800555:	ff 75 e4             	push   -0x1c(%ebp)
  800558:	ff 75 e0             	push   -0x20(%ebp)
  80055b:	ff 75 dc             	push   -0x24(%ebp)
  80055e:	ff 75 d8             	push   -0x28(%ebp)
  800561:	e8 ea 1f 00 00       	call   802550 <__umoddi3>
  800566:	83 c4 14             	add    $0x14,%esp
  800569:	0f be 80 ef 27 80 00 	movsbl 0x8027ef(%eax),%eax
  800570:	50                   	push   %eax
  800571:	ff d7                	call   *%edi
}
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800579:	5b                   	pop    %ebx
  80057a:	5e                   	pop    %esi
  80057b:	5f                   	pop    %edi
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800584:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800588:	8b 10                	mov    (%eax),%edx
  80058a:	3b 50 04             	cmp    0x4(%eax),%edx
  80058d:	73 0a                	jae    800599 <sprintputch+0x1b>
		*b->buf++ = ch;
  80058f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800592:	89 08                	mov    %ecx,(%eax)
  800594:	8b 45 08             	mov    0x8(%ebp),%eax
  800597:	88 02                	mov    %al,(%edx)
}
  800599:	5d                   	pop    %ebp
  80059a:	c3                   	ret    

0080059b <printfmt>:
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005a1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 10             	push   0x10(%ebp)
  8005a8:	ff 75 0c             	push   0xc(%ebp)
  8005ab:	ff 75 08             	push   0x8(%ebp)
  8005ae:	e8 05 00 00 00       	call   8005b8 <vprintfmt>
}
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	c9                   	leave  
  8005b7:	c3                   	ret    

008005b8 <vprintfmt>:
{
  8005b8:	55                   	push   %ebp
  8005b9:	89 e5                	mov    %esp,%ebp
  8005bb:	57                   	push   %edi
  8005bc:	56                   	push   %esi
  8005bd:	53                   	push   %ebx
  8005be:	83 ec 3c             	sub    $0x3c,%esp
  8005c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ca:	eb 0a                	jmp    8005d6 <vprintfmt+0x1e>
			putch(ch, putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	53                   	push   %ebx
  8005d0:	50                   	push   %eax
  8005d1:	ff d6                	call   *%esi
  8005d3:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d6:	83 c7 01             	add    $0x1,%edi
  8005d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005dd:	83 f8 25             	cmp    $0x25,%eax
  8005e0:	74 0c                	je     8005ee <vprintfmt+0x36>
			if (ch == '\0')
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	75 e6                	jne    8005cc <vprintfmt+0x14>
}
  8005e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005e9:	5b                   	pop    %ebx
  8005ea:	5e                   	pop    %esi
  8005eb:	5f                   	pop    %edi
  8005ec:	5d                   	pop    %ebp
  8005ed:	c3                   	ret    
		padc = ' ';
  8005ee:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8005f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800600:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800607:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8d 47 01             	lea    0x1(%edi),%eax
  80060f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800612:	0f b6 17             	movzbl (%edi),%edx
  800615:	8d 42 dd             	lea    -0x23(%edx),%eax
  800618:	3c 55                	cmp    $0x55,%al
  80061a:	0f 87 a6 04 00 00    	ja     800ac6 <vprintfmt+0x50e>
  800620:	0f b6 c0             	movzbl %al,%eax
  800623:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  80062a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80062d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800631:	eb d9                	jmp    80060c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800633:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800636:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80063a:	eb d0                	jmp    80060c <vprintfmt+0x54>
  80063c:	0f b6 d2             	movzbl %dl,%edx
  80063f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800642:	b8 00 00 00 00       	mov    $0x0,%eax
  800647:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80064a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800651:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800654:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800657:	83 f9 09             	cmp    $0x9,%ecx
  80065a:	77 55                	ja     8006b1 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80065c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80065f:	eb e9                	jmp    80064a <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 40 04             	lea    0x4(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800672:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800675:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800679:	79 91                	jns    80060c <vprintfmt+0x54>
				width = precision, precision = -1;
  80067b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800681:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800688:	eb 82                	jmp    80060c <vprintfmt+0x54>
  80068a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	b8 00 00 00 00       	mov    $0x0,%eax
  800694:	0f 49 c2             	cmovns %edx,%eax
  800697:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80069d:	e9 6a ff ff ff       	jmp    80060c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8006a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8006a5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006ac:	e9 5b ff ff ff       	jmp    80060c <vprintfmt+0x54>
  8006b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b7:	eb bc                	jmp    800675 <vprintfmt+0xbd>
			lflag++;
  8006b9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8006bf:	e9 48 ff ff ff       	jmp    80060c <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 78 04             	lea    0x4(%eax),%edi
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	ff 30                	push   (%eax)
  8006d0:	ff d6                	call   *%esi
			break;
  8006d2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006d5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d8:	e9 88 03 00 00       	jmp    800a65 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 78 04             	lea    0x4(%eax),%edi
  8006e3:	8b 10                	mov    (%eax),%edx
  8006e5:	89 d0                	mov    %edx,%eax
  8006e7:	f7 d8                	neg    %eax
  8006e9:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ec:	83 f8 0f             	cmp    $0xf,%eax
  8006ef:	7f 23                	jg     800714 <vprintfmt+0x15c>
  8006f1:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  8006f8:	85 d2                	test   %edx,%edx
  8006fa:	74 18                	je     800714 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8006fc:	52                   	push   %edx
  8006fd:	68 d1 2b 80 00       	push   $0x802bd1
  800702:	53                   	push   %ebx
  800703:	56                   	push   %esi
  800704:	e8 92 fe ff ff       	call   80059b <printfmt>
  800709:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80070c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80070f:	e9 51 03 00 00       	jmp    800a65 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800714:	50                   	push   %eax
  800715:	68 07 28 80 00       	push   $0x802807
  80071a:	53                   	push   %ebx
  80071b:	56                   	push   %esi
  80071c:	e8 7a fe ff ff       	call   80059b <printfmt>
  800721:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800724:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800727:	e9 39 03 00 00       	jmp    800a65 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80073a:	85 d2                	test   %edx,%edx
  80073c:	b8 00 28 80 00       	mov    $0x802800,%eax
  800741:	0f 45 c2             	cmovne %edx,%eax
  800744:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800747:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80074b:	7e 06                	jle    800753 <vprintfmt+0x19b>
  80074d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800751:	75 0d                	jne    800760 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800753:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800756:	89 c7                	mov    %eax,%edi
  800758:	03 45 d4             	add    -0x2c(%ebp),%eax
  80075b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80075e:	eb 55                	jmp    8007b5 <vprintfmt+0x1fd>
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 e0             	push   -0x20(%ebp)
  800766:	ff 75 cc             	push   -0x34(%ebp)
  800769:	e8 f5 03 00 00       	call   800b63 <strnlen>
  80076e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800771:	29 c2                	sub    %eax,%edx
  800773:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80077b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80077f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800782:	eb 0f                	jmp    800793 <vprintfmt+0x1db>
					putch(padc, putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	ff 75 d4             	push   -0x2c(%ebp)
  80078b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80078d:	83 ef 01             	sub    $0x1,%edi
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	85 ff                	test   %edi,%edi
  800795:	7f ed                	jg     800784 <vprintfmt+0x1cc>
  800797:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80079a:	85 d2                	test   %edx,%edx
  80079c:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a1:	0f 49 c2             	cmovns %edx,%eax
  8007a4:	29 c2                	sub    %eax,%edx
  8007a6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007a9:	eb a8                	jmp    800753 <vprintfmt+0x19b>
					putch(ch, putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	52                   	push   %edx
  8007b0:	ff d6                	call   *%esi
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007b8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ba:	83 c7 01             	add    $0x1,%edi
  8007bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c1:	0f be d0             	movsbl %al,%edx
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	74 4b                	je     800813 <vprintfmt+0x25b>
  8007c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007cc:	78 06                	js     8007d4 <vprintfmt+0x21c>
  8007ce:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8007d2:	78 1e                	js     8007f2 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  8007d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007d8:	74 d1                	je     8007ab <vprintfmt+0x1f3>
  8007da:	0f be c0             	movsbl %al,%eax
  8007dd:	83 e8 20             	sub    $0x20,%eax
  8007e0:	83 f8 5e             	cmp    $0x5e,%eax
  8007e3:	76 c6                	jbe    8007ab <vprintfmt+0x1f3>
					putch('?', putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	6a 3f                	push   $0x3f
  8007eb:	ff d6                	call   *%esi
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	eb c3                	jmp    8007b5 <vprintfmt+0x1fd>
  8007f2:	89 cf                	mov    %ecx,%edi
  8007f4:	eb 0e                	jmp    800804 <vprintfmt+0x24c>
				putch(' ', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 20                	push   $0x20
  8007fc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007fe:	83 ef 01             	sub    $0x1,%edi
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	85 ff                	test   %edi,%edi
  800806:	7f ee                	jg     8007f6 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800808:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
  80080e:	e9 52 02 00 00       	jmp    800a65 <vprintfmt+0x4ad>
  800813:	89 cf                	mov    %ecx,%edi
  800815:	eb ed                	jmp    800804 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	83 c0 04             	add    $0x4,%eax
  80081d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800825:	85 d2                	test   %edx,%edx
  800827:	b8 00 28 80 00       	mov    $0x802800,%eax
  80082c:	0f 45 c2             	cmovne %edx,%eax
  80082f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800832:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800836:	7e 06                	jle    80083e <vprintfmt+0x286>
  800838:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80083c:	75 0d                	jne    80084b <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80083e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800841:	89 c7                	mov    %eax,%edi
  800843:	03 45 d4             	add    -0x2c(%ebp),%eax
  800846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800849:	eb 55                	jmp    8008a0 <vprintfmt+0x2e8>
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 e0             	push   -0x20(%ebp)
  800851:	ff 75 cc             	push   -0x34(%ebp)
  800854:	e8 0a 03 00 00       	call   800b63 <strnlen>
  800859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80085c:	29 c2                	sub    %eax,%edx
  80085e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800866:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80086a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80086d:	eb 0f                	jmp    80087e <vprintfmt+0x2c6>
					putch(padc, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	ff 75 d4             	push   -0x2c(%ebp)
  800876:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800878:	83 ef 01             	sub    $0x1,%edi
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	85 ff                	test   %edi,%edi
  800880:	7f ed                	jg     80086f <vprintfmt+0x2b7>
  800882:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800885:	85 d2                	test   %edx,%edx
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
  80088c:	0f 49 c2             	cmovns %edx,%eax
  80088f:	29 c2                	sub    %eax,%edx
  800891:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800894:	eb a8                	jmp    80083e <vprintfmt+0x286>
					putch(ch, putdat);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	53                   	push   %ebx
  80089a:	52                   	push   %edx
  80089b:	ff d6                	call   *%esi
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8008a3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8008a5:	83 c7 01             	add    $0x1,%edi
  8008a8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ac:	0f be d0             	movsbl %al,%edx
  8008af:	3c 3a                	cmp    $0x3a,%al
  8008b1:	74 4b                	je     8008fe <vprintfmt+0x346>
  8008b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b7:	78 06                	js     8008bf <vprintfmt+0x307>
  8008b9:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8008bd:	78 1e                	js     8008dd <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8008bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008c3:	74 d1                	je     800896 <vprintfmt+0x2de>
  8008c5:	0f be c0             	movsbl %al,%eax
  8008c8:	83 e8 20             	sub    $0x20,%eax
  8008cb:	83 f8 5e             	cmp    $0x5e,%eax
  8008ce:	76 c6                	jbe    800896 <vprintfmt+0x2de>
					putch('?', putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	53                   	push   %ebx
  8008d4:	6a 3f                	push   $0x3f
  8008d6:	ff d6                	call   *%esi
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	eb c3                	jmp    8008a0 <vprintfmt+0x2e8>
  8008dd:	89 cf                	mov    %ecx,%edi
  8008df:	eb 0e                	jmp    8008ef <vprintfmt+0x337>
				putch(' ', putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	6a 20                	push   $0x20
  8008e7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008e9:	83 ef 01             	sub    $0x1,%edi
  8008ec:	83 c4 10             	add    $0x10,%esp
  8008ef:	85 ff                	test   %edi,%edi
  8008f1:	7f ee                	jg     8008e1 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8008f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f9:	e9 67 01 00 00       	jmp    800a65 <vprintfmt+0x4ad>
  8008fe:	89 cf                	mov    %ecx,%edi
  800900:	eb ed                	jmp    8008ef <vprintfmt+0x337>
	if (lflag >= 2)
  800902:	83 f9 01             	cmp    $0x1,%ecx
  800905:	7f 1b                	jg     800922 <vprintfmt+0x36a>
	else if (lflag)
  800907:	85 c9                	test   %ecx,%ecx
  800909:	74 63                	je     80096e <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800913:	99                   	cltd   
  800914:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8d 40 04             	lea    0x4(%eax),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	eb 17                	jmp    800939 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 50 04             	mov    0x4(%eax),%edx
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80092d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 40 08             	lea    0x8(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800939:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80093c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80093f:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800944:	85 c9                	test   %ecx,%ecx
  800946:	0f 89 ff 00 00 00    	jns    800a4b <vprintfmt+0x493>
				putch('-', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 2d                	push   $0x2d
  800952:	ff d6                	call   *%esi
				num = -(long long) num;
  800954:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800957:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80095a:	f7 da                	neg    %edx
  80095c:	83 d1 00             	adc    $0x0,%ecx
  80095f:	f7 d9                	neg    %ecx
  800961:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800964:	bf 0a 00 00 00       	mov    $0xa,%edi
  800969:	e9 dd 00 00 00       	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, int);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800976:	99                   	cltd   
  800977:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	8d 40 04             	lea    0x4(%eax),%eax
  800980:	89 45 14             	mov    %eax,0x14(%ebp)
  800983:	eb b4                	jmp    800939 <vprintfmt+0x381>
	if (lflag >= 2)
  800985:	83 f9 01             	cmp    $0x1,%ecx
  800988:	7f 1e                	jg     8009a8 <vprintfmt+0x3f0>
	else if (lflag)
  80098a:	85 c9                	test   %ecx,%ecx
  80098c:	74 32                	je     8009c0 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8b 10                	mov    (%eax),%edx
  800993:	b9 00 00 00 00       	mov    $0x0,%ecx
  800998:	8d 40 04             	lea    0x4(%eax),%eax
  80099b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80099e:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8009a3:	e9 a3 00 00 00       	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8b 10                	mov    (%eax),%edx
  8009ad:	8b 48 04             	mov    0x4(%eax),%ecx
  8009b0:	8d 40 08             	lea    0x8(%eax),%eax
  8009b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009b6:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8009bb:	e9 8b 00 00 00       	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	8b 10                	mov    (%eax),%edx
  8009c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ca:	8d 40 04             	lea    0x4(%eax),%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d0:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8009d5:	eb 74                	jmp    800a4b <vprintfmt+0x493>
	if (lflag >= 2)
  8009d7:	83 f9 01             	cmp    $0x1,%ecx
  8009da:	7f 1b                	jg     8009f7 <vprintfmt+0x43f>
	else if (lflag)
  8009dc:	85 c9                	test   %ecx,%ecx
  8009de:	74 2c                	je     800a0c <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8b 10                	mov    (%eax),%edx
  8009e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ea:	8d 40 04             	lea    0x4(%eax),%eax
  8009ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8009f5:	eb 54                	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	8b 10                	mov    (%eax),%edx
  8009fc:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ff:	8d 40 08             	lea    0x8(%eax),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a05:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800a0a:	eb 3f                	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8b 10                	mov    (%eax),%edx
  800a11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800a21:	eb 28                	jmp    800a4b <vprintfmt+0x493>
			putch('0', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	53                   	push   %ebx
  800a27:	6a 30                	push   $0x30
  800a29:	ff d6                	call   *%esi
			putch('x', putdat);
  800a2b:	83 c4 08             	add    $0x8,%esp
  800a2e:	53                   	push   %ebx
  800a2f:	6a 78                	push   $0x78
  800a31:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	8b 10                	mov    (%eax),%edx
  800a38:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a3d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a40:	8d 40 04             	lea    0x4(%eax),%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a46:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800a4b:	83 ec 0c             	sub    $0xc,%esp
  800a4e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	ff 75 d4             	push   -0x2c(%ebp)
  800a56:	57                   	push   %edi
  800a57:	51                   	push   %ecx
  800a58:	52                   	push   %edx
  800a59:	89 da                	mov    %ebx,%edx
  800a5b:	89 f0                	mov    %esi,%eax
  800a5d:	e8 73 fa ff ff       	call   8004d5 <printnum>
			break;
  800a62:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a65:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a68:	e9 69 fb ff ff       	jmp    8005d6 <vprintfmt+0x1e>
	if (lflag >= 2)
  800a6d:	83 f9 01             	cmp    $0x1,%ecx
  800a70:	7f 1b                	jg     800a8d <vprintfmt+0x4d5>
	else if (lflag)
  800a72:	85 c9                	test   %ecx,%ecx
  800a74:	74 2c                	je     800aa2 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8b 10                	mov    (%eax),%edx
  800a7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a80:	8d 40 04             	lea    0x4(%eax),%eax
  800a83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a86:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800a8b:	eb be                	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	8b 10                	mov    (%eax),%edx
  800a92:	8b 48 04             	mov    0x4(%eax),%ecx
  800a95:	8d 40 08             	lea    0x8(%eax),%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a9b:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800aa0:	eb a9                	jmp    800a4b <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	8b 10                	mov    (%eax),%edx
  800aa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aac:	8d 40 04             	lea    0x4(%eax),%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab2:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800ab7:	eb 92                	jmp    800a4b <vprintfmt+0x493>
			putch(ch, putdat);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	53                   	push   %ebx
  800abd:	6a 25                	push   $0x25
  800abf:	ff d6                	call   *%esi
			break;
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	eb 9f                	jmp    800a65 <vprintfmt+0x4ad>
			putch('%', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	53                   	push   %ebx
  800aca:	6a 25                	push   $0x25
  800acc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	89 f8                	mov    %edi,%eax
  800ad3:	eb 03                	jmp    800ad8 <vprintfmt+0x520>
  800ad5:	83 e8 01             	sub    $0x1,%eax
  800ad8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800adc:	75 f7                	jne    800ad5 <vprintfmt+0x51d>
  800ade:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ae1:	eb 82                	jmp    800a65 <vprintfmt+0x4ad>

00800ae3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 18             	sub    $0x18,%esp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800af6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b00:	85 c0                	test   %eax,%eax
  800b02:	74 26                	je     800b2a <vsnprintf+0x47>
  800b04:	85 d2                	test   %edx,%edx
  800b06:	7e 22                	jle    800b2a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b08:	ff 75 14             	push   0x14(%ebp)
  800b0b:	ff 75 10             	push   0x10(%ebp)
  800b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b11:	50                   	push   %eax
  800b12:	68 7e 05 80 00       	push   $0x80057e
  800b17:	e8 9c fa ff ff       	call   8005b8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b25:	83 c4 10             	add    $0x10,%esp
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    
		return -E_INVAL;
  800b2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2f:	eb f7                	jmp    800b28 <vsnprintf+0x45>

00800b31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 10             	push   0x10(%ebp)
  800b3e:	ff 75 0c             	push   0xc(%ebp)
  800b41:	ff 75 08             	push   0x8(%ebp)
  800b44:	e8 9a ff ff ff       	call   800ae3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	eb 03                	jmp    800b5b <strlen+0x10>
		n++;
  800b58:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800b5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b5f:	75 f7                	jne    800b58 <strlen+0xd>
	return n;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	eb 03                	jmp    800b76 <strnlen+0x13>
		n++;
  800b73:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b76:	39 d0                	cmp    %edx,%eax
  800b78:	74 08                	je     800b82 <strnlen+0x1f>
  800b7a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b7e:	75 f3                	jne    800b73 <strnlen+0x10>
  800b80:	89 c2                	mov    %eax,%edx
	return n;
}
  800b82:	89 d0                	mov    %edx,%eax
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	53                   	push   %ebx
  800b8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b90:	b8 00 00 00 00       	mov    $0x0,%eax
  800b95:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b99:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	84 d2                	test   %dl,%dl
  800ba1:	75 f2                	jne    800b95 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba3:	89 c8                	mov    %ecx,%eax
  800ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strcat>:

char *
strcat(char *dst, const char *src)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	53                   	push   %ebx
  800bae:	83 ec 10             	sub    $0x10,%esp
  800bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb4:	53                   	push   %ebx
  800bb5:	e8 91 ff ff ff       	call   800b4b <strlen>
  800bba:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bbd:	ff 75 0c             	push   0xc(%ebp)
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	50                   	push   %eax
  800bc3:	e8 be ff ff ff       	call   800b86 <strcpy>
	return dst;
}
  800bc8:	89 d8                	mov    %ebx,%eax
  800bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	8b 75 08             	mov    0x8(%ebp),%esi
  800bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bda:	89 f3                	mov    %esi,%ebx
  800bdc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bdf:	89 f0                	mov    %esi,%eax
  800be1:	eb 0f                	jmp    800bf2 <strncpy+0x23>
		*dst++ = *src;
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	0f b6 0a             	movzbl (%edx),%ecx
  800be9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bec:	80 f9 01             	cmp    $0x1,%cl
  800bef:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800bf2:	39 d8                	cmp    %ebx,%eax
  800bf4:	75 ed                	jne    800be3 <strncpy+0x14>
	}
	return ret;
}
  800bf6:	89 f0                	mov    %esi,%eax
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    

00800bfc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	8b 75 08             	mov    0x8(%ebp),%esi
  800c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c07:	8b 55 10             	mov    0x10(%ebp),%edx
  800c0a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c0c:	85 d2                	test   %edx,%edx
  800c0e:	74 21                	je     800c31 <strlcpy+0x35>
  800c10:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c14:	89 f2                	mov    %esi,%edx
  800c16:	eb 09                	jmp    800c21 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	83 c2 01             	add    $0x1,%edx
  800c1e:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800c21:	39 c2                	cmp    %eax,%edx
  800c23:	74 09                	je     800c2e <strlcpy+0x32>
  800c25:	0f b6 19             	movzbl (%ecx),%ebx
  800c28:	84 db                	test   %bl,%bl
  800c2a:	75 ec                	jne    800c18 <strlcpy+0x1c>
  800c2c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c31:	29 f0                	sub    %esi,%eax
}
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c40:	eb 06                	jmp    800c48 <strcmp+0x11>
		p++, q++;
  800c42:	83 c1 01             	add    $0x1,%ecx
  800c45:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c48:	0f b6 01             	movzbl (%ecx),%eax
  800c4b:	84 c0                	test   %al,%al
  800c4d:	74 04                	je     800c53 <strcmp+0x1c>
  800c4f:	3a 02                	cmp    (%edx),%al
  800c51:	74 ef                	je     800c42 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c53:	0f b6 c0             	movzbl %al,%eax
  800c56:	0f b6 12             	movzbl (%edx),%edx
  800c59:	29 d0                	sub    %edx,%eax
}
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	53                   	push   %ebx
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c67:	89 c3                	mov    %eax,%ebx
  800c69:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c6c:	eb 06                	jmp    800c74 <strncmp+0x17>
		n--, p++, q++;
  800c6e:	83 c0 01             	add    $0x1,%eax
  800c71:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c74:	39 d8                	cmp    %ebx,%eax
  800c76:	74 18                	je     800c90 <strncmp+0x33>
  800c78:	0f b6 08             	movzbl (%eax),%ecx
  800c7b:	84 c9                	test   %cl,%cl
  800c7d:	74 04                	je     800c83 <strncmp+0x26>
  800c7f:	3a 0a                	cmp    (%edx),%cl
  800c81:	74 eb                	je     800c6e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c83:	0f b6 00             	movzbl (%eax),%eax
  800c86:	0f b6 12             	movzbl (%edx),%edx
  800c89:	29 d0                	sub    %edx,%eax
}
  800c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    
		return 0;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	eb f4                	jmp    800c8b <strncmp+0x2e>

00800c97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca1:	eb 03                	jmp    800ca6 <strchr+0xf>
  800ca3:	83 c0 01             	add    $0x1,%eax
  800ca6:	0f b6 10             	movzbl (%eax),%edx
  800ca9:	84 d2                	test   %dl,%dl
  800cab:	74 06                	je     800cb3 <strchr+0x1c>
		if (*s == c)
  800cad:	38 ca                	cmp    %cl,%dl
  800caf:	75 f2                	jne    800ca3 <strchr+0xc>
  800cb1:	eb 05                	jmp    800cb8 <strchr+0x21>
			return (char *) s;
	return 0;
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cc7:	38 ca                	cmp    %cl,%dl
  800cc9:	74 09                	je     800cd4 <strfind+0x1a>
  800ccb:	84 d2                	test   %dl,%dl
  800ccd:	74 05                	je     800cd4 <strfind+0x1a>
	for (; *s; s++)
  800ccf:	83 c0 01             	add    $0x1,%eax
  800cd2:	eb f0                	jmp    800cc4 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce2:	85 c9                	test   %ecx,%ecx
  800ce4:	74 2f                	je     800d15 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce6:	89 f8                	mov    %edi,%eax
  800ce8:	09 c8                	or     %ecx,%eax
  800cea:	a8 03                	test   $0x3,%al
  800cec:	75 21                	jne    800d0f <memset+0x39>
		c &= 0xFF;
  800cee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf2:	89 d0                	mov    %edx,%eax
  800cf4:	c1 e0 08             	shl    $0x8,%eax
  800cf7:	89 d3                	mov    %edx,%ebx
  800cf9:	c1 e3 18             	shl    $0x18,%ebx
  800cfc:	89 d6                	mov    %edx,%esi
  800cfe:	c1 e6 10             	shl    $0x10,%esi
  800d01:	09 f3                	or     %esi,%ebx
  800d03:	09 da                	or     %ebx,%edx
  800d05:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d07:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0a:	fc                   	cld    
  800d0b:	f3 ab                	rep stos %eax,%es:(%edi)
  800d0d:	eb 06                	jmp    800d15 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	fc                   	cld    
  800d13:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d15:	89 f8                	mov    %edi,%eax
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2a:	39 c6                	cmp    %eax,%esi
  800d2c:	73 32                	jae    800d60 <memmove+0x44>
  800d2e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	76 2b                	jbe    800d60 <memmove+0x44>
		s += n;
		d += n;
  800d35:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d38:	89 d6                	mov    %edx,%esi
  800d3a:	09 fe                	or     %edi,%esi
  800d3c:	09 ce                	or     %ecx,%esi
  800d3e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d44:	75 0e                	jne    800d54 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d46:	83 ef 04             	sub    $0x4,%edi
  800d49:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d4f:	fd                   	std    
  800d50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d52:	eb 09                	jmp    800d5d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d54:	83 ef 01             	sub    $0x1,%edi
  800d57:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d5a:	fd                   	std    
  800d5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d5d:	fc                   	cld    
  800d5e:	eb 1a                	jmp    800d7a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d60:	89 f2                	mov    %esi,%edx
  800d62:	09 c2                	or     %eax,%edx
  800d64:	09 ca                	or     %ecx,%edx
  800d66:	f6 c2 03             	test   $0x3,%dl
  800d69:	75 0a                	jne    800d75 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	fc                   	cld    
  800d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d73:	eb 05                	jmp    800d7a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d75:	89 c7                	mov    %eax,%edi
  800d77:	fc                   	cld    
  800d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d84:	ff 75 10             	push   0x10(%ebp)
  800d87:	ff 75 0c             	push   0xc(%ebp)
  800d8a:	ff 75 08             	push   0x8(%ebp)
  800d8d:	e8 8a ff ff ff       	call   800d1c <memmove>
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	89 c6                	mov    %eax,%esi
  800da1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da4:	eb 06                	jmp    800dac <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800da6:	83 c0 01             	add    $0x1,%eax
  800da9:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800dac:	39 f0                	cmp    %esi,%eax
  800dae:	74 14                	je     800dc4 <memcmp+0x30>
		if (*s1 != *s2)
  800db0:	0f b6 08             	movzbl (%eax),%ecx
  800db3:	0f b6 1a             	movzbl (%edx),%ebx
  800db6:	38 d9                	cmp    %bl,%cl
  800db8:	74 ec                	je     800da6 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800dba:	0f b6 c1             	movzbl %cl,%eax
  800dbd:	0f b6 db             	movzbl %bl,%ebx
  800dc0:	29 d8                	sub    %ebx,%eax
  800dc2:	eb 05                	jmp    800dc9 <memcmp+0x35>
	}

	return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dd6:	89 c2                	mov    %eax,%edx
  800dd8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ddb:	eb 03                	jmp    800de0 <memfind+0x13>
  800ddd:	83 c0 01             	add    $0x1,%eax
  800de0:	39 d0                	cmp    %edx,%eax
  800de2:	73 04                	jae    800de8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de4:	38 08                	cmp    %cl,(%eax)
  800de6:	75 f5                	jne    800ddd <memfind+0x10>
			break;
	return (void *) s;
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df6:	eb 03                	jmp    800dfb <strtol+0x11>
		s++;
  800df8:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800dfb:	0f b6 02             	movzbl (%edx),%eax
  800dfe:	3c 20                	cmp    $0x20,%al
  800e00:	74 f6                	je     800df8 <strtol+0xe>
  800e02:	3c 09                	cmp    $0x9,%al
  800e04:	74 f2                	je     800df8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e06:	3c 2b                	cmp    $0x2b,%al
  800e08:	74 2a                	je     800e34 <strtol+0x4a>
	int neg = 0;
  800e0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e0f:	3c 2d                	cmp    $0x2d,%al
  800e11:	74 2b                	je     800e3e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e13:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e19:	75 0f                	jne    800e2a <strtol+0x40>
  800e1b:	80 3a 30             	cmpb   $0x30,(%edx)
  800e1e:	74 28                	je     800e48 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e20:	85 db                	test   %ebx,%ebx
  800e22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e27:	0f 44 d8             	cmove  %eax,%ebx
  800e2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e32:	eb 46                	jmp    800e7a <strtol+0x90>
		s++;
  800e34:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800e37:	bf 00 00 00 00       	mov    $0x0,%edi
  800e3c:	eb d5                	jmp    800e13 <strtol+0x29>
		s++, neg = 1;
  800e3e:	83 c2 01             	add    $0x1,%edx
  800e41:	bf 01 00 00 00       	mov    $0x1,%edi
  800e46:	eb cb                	jmp    800e13 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e48:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e4c:	74 0e                	je     800e5c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e4e:	85 db                	test   %ebx,%ebx
  800e50:	75 d8                	jne    800e2a <strtol+0x40>
		s++, base = 8;
  800e52:	83 c2 01             	add    $0x1,%edx
  800e55:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e5a:	eb ce                	jmp    800e2a <strtol+0x40>
		s += 2, base = 16;
  800e5c:	83 c2 02             	add    $0x2,%edx
  800e5f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e64:	eb c4                	jmp    800e2a <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e66:	0f be c0             	movsbl %al,%eax
  800e69:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e6f:	7d 3a                	jge    800eab <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e71:	83 c2 01             	add    $0x1,%edx
  800e74:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800e78:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800e7a:	0f b6 02             	movzbl (%edx),%eax
  800e7d:	8d 70 d0             	lea    -0x30(%eax),%esi
  800e80:	89 f3                	mov    %esi,%ebx
  800e82:	80 fb 09             	cmp    $0x9,%bl
  800e85:	76 df                	jbe    800e66 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800e87:	8d 70 9f             	lea    -0x61(%eax),%esi
  800e8a:	89 f3                	mov    %esi,%ebx
  800e8c:	80 fb 19             	cmp    $0x19,%bl
  800e8f:	77 08                	ja     800e99 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e91:	0f be c0             	movsbl %al,%eax
  800e94:	83 e8 57             	sub    $0x57,%eax
  800e97:	eb d3                	jmp    800e6c <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e99:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e9c:	89 f3                	mov    %esi,%ebx
  800e9e:	80 fb 19             	cmp    $0x19,%bl
  800ea1:	77 08                	ja     800eab <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea3:	0f be c0             	movsbl %al,%eax
  800ea6:	83 e8 37             	sub    $0x37,%eax
  800ea9:	eb c1                	jmp    800e6c <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eaf:	74 05                	je     800eb6 <strtol+0xcc>
		*endptr = (char *) s;
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eb6:	89 c8                	mov    %ecx,%eax
  800eb8:	f7 d8                	neg    %eax
  800eba:	85 ff                	test   %edi,%edi
  800ebc:	0f 45 c8             	cmovne %eax,%ecx
}
  800ebf:	89 c8                	mov    %ecx,%eax
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed7:	89 c3                	mov    %eax,%ebx
  800ed9:	89 c7                	mov    %eax,%edi
  800edb:	89 c6                	mov    %eax,%esi
  800edd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eea:	ba 00 00 00 00       	mov    $0x0,%edx
  800eef:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef4:	89 d1                	mov    %edx,%ecx
  800ef6:	89 d3                	mov    %edx,%ebx
  800ef8:	89 d7                	mov    %edx,%edi
  800efa:	89 d6                	mov    %edx,%esi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	b8 03 00 00 00       	mov    $0x3,%eax
  800f19:	89 cb                	mov    %ecx,%ebx
  800f1b:	89 cf                	mov    %ecx,%edi
  800f1d:	89 ce                	mov    %ecx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 03                	push   $0x3
  800f33:	68 ff 2a 80 00       	push   $0x802aff
  800f38:	6a 23                	push   $0x23
  800f3a:	68 1c 2b 80 00       	push   $0x802b1c
  800f3f:	e8 a2 f4 ff ff       	call   8003e6 <_panic>

00800f44 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800f54:	89 d1                	mov    %edx,%ecx
  800f56:	89 d3                	mov    %edx,%ebx
  800f58:	89 d7                	mov    %edx,%edi
  800f5a:	89 d6                	mov    %edx,%esi
  800f5c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_yield>:

void
sys_yield(void)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f69:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f73:	89 d1                	mov    %edx,%ecx
  800f75:	89 d3                	mov    %edx,%ebx
  800f77:	89 d7                	mov    %edx,%edi
  800f79:	89 d6                	mov    %edx,%esi
  800f7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
  800f88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8b:	be 00 00 00 00       	mov    $0x0,%esi
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f96:	b8 04 00 00 00       	mov    $0x4,%eax
  800f9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9e:	89 f7                	mov    %esi,%edi
  800fa0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	7f 08                	jg     800fae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	50                   	push   %eax
  800fb2:	6a 04                	push   $0x4
  800fb4:	68 ff 2a 80 00       	push   $0x802aff
  800fb9:	6a 23                	push   $0x23
  800fbb:	68 1c 2b 80 00       	push   $0x802b1c
  800fc0:	e8 21 f4 ff ff       	call   8003e6 <_panic>

00800fc5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fdf:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7f 08                	jg     800ff0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	50                   	push   %eax
  800ff4:	6a 05                	push   $0x5
  800ff6:	68 ff 2a 80 00       	push   $0x802aff
  800ffb:	6a 23                	push   $0x23
  800ffd:	68 1c 2b 80 00       	push   $0x802b1c
  801002:	e8 df f3 ff ff       	call   8003e6 <_panic>

00801007 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801010:	bb 00 00 00 00       	mov    $0x0,%ebx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	b8 06 00 00 00       	mov    $0x6,%eax
  801020:	89 df                	mov    %ebx,%edi
  801022:	89 de                	mov    %ebx,%esi
  801024:	cd 30                	int    $0x30
	if(check && ret > 0)
  801026:	85 c0                	test   %eax,%eax
  801028:	7f 08                	jg     801032 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	50                   	push   %eax
  801036:	6a 06                	push   $0x6
  801038:	68 ff 2a 80 00       	push   $0x802aff
  80103d:	6a 23                	push   $0x23
  80103f:	68 1c 2b 80 00       	push   $0x802b1c
  801044:	e8 9d f3 ff ff       	call   8003e6 <_panic>

00801049 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105d:	b8 08 00 00 00       	mov    $0x8,%eax
  801062:	89 df                	mov    %ebx,%edi
  801064:	89 de                	mov    %ebx,%esi
  801066:	cd 30                	int    $0x30
	if(check && ret > 0)
  801068:	85 c0                	test   %eax,%eax
  80106a:	7f 08                	jg     801074 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106f:	5b                   	pop    %ebx
  801070:	5e                   	pop    %esi
  801071:	5f                   	pop    %edi
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	50                   	push   %eax
  801078:	6a 08                	push   $0x8
  80107a:	68 ff 2a 80 00       	push   $0x802aff
  80107f:	6a 23                	push   $0x23
  801081:	68 1c 2b 80 00       	push   $0x802b1c
  801086:	e8 5b f3 ff ff       	call   8003e6 <_panic>

0080108b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801094:	bb 00 00 00 00       	mov    $0x0,%ebx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a4:	89 df                	mov    %ebx,%edi
  8010a6:	89 de                	mov    %ebx,%esi
  8010a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	7f 08                	jg     8010b6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	50                   	push   %eax
  8010ba:	6a 09                	push   $0x9
  8010bc:	68 ff 2a 80 00       	push   $0x802aff
  8010c1:	6a 23                	push   $0x23
  8010c3:	68 1c 2b 80 00       	push   $0x802b1c
  8010c8:	e8 19 f3 ff ff       	call   8003e6 <_panic>

008010cd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
  8010d3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e6:	89 df                	mov    %ebx,%edi
  8010e8:	89 de                	mov    %ebx,%esi
  8010ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	7f 08                	jg     8010f8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5f                   	pop    %edi
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	50                   	push   %eax
  8010fc:	6a 0a                	push   $0xa
  8010fe:	68 ff 2a 80 00       	push   $0x802aff
  801103:	6a 23                	push   $0x23
  801105:	68 1c 2b 80 00       	push   $0x802b1c
  80110a:	e8 d7 f2 ff ff       	call   8003e6 <_panic>

0080110f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
	asm volatile("int %1\n"
  801115:	8b 55 08             	mov    0x8(%ebp),%edx
  801118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801120:	be 00 00 00 00       	mov    $0x0,%esi
  801125:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801128:	8b 7d 14             	mov    0x14(%ebp),%edi
  80112b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	b8 0d 00 00 00       	mov    $0xd,%eax
  801148:	89 cb                	mov    %ecx,%ebx
  80114a:	89 cf                	mov    %ecx,%edi
  80114c:	89 ce                	mov    %ecx,%esi
  80114e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801150:	85 c0                	test   %eax,%eax
  801152:	7f 08                	jg     80115c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	50                   	push   %eax
  801160:	6a 0d                	push   $0xd
  801162:	68 ff 2a 80 00       	push   $0x802aff
  801167:	6a 23                	push   $0x23
  801169:	68 1c 2b 80 00       	push   $0x802b1c
  80116e:	e8 73 f2 ff ff       	call   8003e6 <_panic>

00801173 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	05 00 00 00 30       	add    $0x30000000,%eax
  80117e:	c1 e8 0c             	shr    $0xc,%eax
}
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80118e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801193:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a2:	89 c2                	mov    %eax,%edx
  8011a4:	c1 ea 16             	shr    $0x16,%edx
  8011a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ae:	f6 c2 01             	test   $0x1,%dl
  8011b1:	74 29                	je     8011dc <fd_alloc+0x42>
  8011b3:	89 c2                	mov    %eax,%edx
  8011b5:	c1 ea 0c             	shr    $0xc,%edx
  8011b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011bf:	f6 c2 01             	test   $0x1,%dl
  8011c2:	74 18                	je     8011dc <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  8011c4:	05 00 10 00 00       	add    $0x1000,%eax
  8011c9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011ce:	75 d2                	jne    8011a2 <fd_alloc+0x8>
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8011d5:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8011da:	eb 05                	jmp    8011e1 <fd_alloc+0x47>
			return 0;
  8011dc:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	89 02                	mov    %eax,(%edx)
}
  8011e6:	89 c8                	mov    %ecx,%eax
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011f0:	83 f8 1f             	cmp    $0x1f,%eax
  8011f3:	77 30                	ja     801225 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011f5:	c1 e0 0c             	shl    $0xc,%eax
  8011f8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011fd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801203:	f6 c2 01             	test   $0x1,%dl
  801206:	74 24                	je     80122c <fd_lookup+0x42>
  801208:	89 c2                	mov    %eax,%edx
  80120a:	c1 ea 0c             	shr    $0xc,%edx
  80120d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801214:	f6 c2 01             	test   $0x1,%dl
  801217:	74 1a                	je     801233 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121c:	89 02                	mov    %eax,(%edx)
	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    
		return -E_INVAL;
  801225:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122a:	eb f7                	jmp    801223 <fd_lookup+0x39>
		return -E_INVAL;
  80122c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801231:	eb f0                	jmp    801223 <fd_lookup+0x39>
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb e9                	jmp    801223 <fd_lookup+0x39>

0080123a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	8b 55 08             	mov    0x8(%ebp),%edx
  801244:	b8 a8 2b 80 00       	mov    $0x802ba8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801249:	bb 90 47 80 00       	mov    $0x804790,%ebx
		if (devtab[i]->dev_id == dev_id) {
  80124e:	39 13                	cmp    %edx,(%ebx)
  801250:	74 32                	je     801284 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  801252:	83 c0 04             	add    $0x4,%eax
  801255:	8b 18                	mov    (%eax),%ebx
  801257:	85 db                	test   %ebx,%ebx
  801259:	75 f3                	jne    80124e <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80125b:	a1 70 67 80 00       	mov    0x806770,%eax
  801260:	8b 40 48             	mov    0x48(%eax),%eax
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	52                   	push   %edx
  801267:	50                   	push   %eax
  801268:	68 2c 2b 80 00       	push   $0x802b2c
  80126d:	e8 4f f2 ff ff       	call   8004c1 <cprintf>
	*dev = 0;
	return -E_INVAL;
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  80127a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127d:	89 1a                	mov    %ebx,(%edx)
}
  80127f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801282:	c9                   	leave  
  801283:	c3                   	ret    
			return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	eb ef                	jmp    80127a <dev_lookup+0x40>

0080128b <fd_close>:
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	83 ec 24             	sub    $0x24,%esp
  801294:	8b 75 08             	mov    0x8(%ebp),%esi
  801297:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80129a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80129d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012a4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a7:	50                   	push   %eax
  8012a8:	e8 3d ff ff ff       	call   8011ea <fd_lookup>
  8012ad:	89 c3                	mov    %eax,%ebx
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 05                	js     8012bb <fd_close+0x30>
	    || fd != fd2)
  8012b6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012b9:	74 16                	je     8012d1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012bb:	89 f8                	mov    %edi,%eax
  8012bd:	84 c0                	test   %al,%al
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c4:	0f 44 d8             	cmove  %eax,%ebx
}
  8012c7:	89 d8                	mov    %ebx,%eax
  8012c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cc:	5b                   	pop    %ebx
  8012cd:	5e                   	pop    %esi
  8012ce:	5f                   	pop    %edi
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 36                	push   (%esi)
  8012da:	e8 5b ff ff ff       	call   80123a <dev_lookup>
  8012df:	89 c3                	mov    %eax,%ebx
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 1a                	js     801302 <fd_close+0x77>
		if (dev->dev_close)
  8012e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	74 0b                	je     801302 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012f7:	83 ec 0c             	sub    $0xc,%esp
  8012fa:	56                   	push   %esi
  8012fb:	ff d0                	call   *%eax
  8012fd:	89 c3                	mov    %eax,%ebx
  8012ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	56                   	push   %esi
  801306:	6a 00                	push   $0x0
  801308:	e8 fa fc ff ff       	call   801007 <sys_page_unmap>
	return r;
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	eb b5                	jmp    8012c7 <fd_close+0x3c>

00801312 <close>:

int
close(int fdnum)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801318:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	ff 75 08             	push   0x8(%ebp)
  80131f:	e8 c6 fe ff ff       	call   8011ea <fd_lookup>
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	79 02                	jns    80132d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    
		return fd_close(fd, 1);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	6a 01                	push   $0x1
  801332:	ff 75 f4             	push   -0xc(%ebp)
  801335:	e8 51 ff ff ff       	call   80128b <fd_close>
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb ec                	jmp    80132b <close+0x19>

0080133f <close_all>:

void
close_all(void)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	53                   	push   %ebx
  801343:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801346:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	53                   	push   %ebx
  80134f:	e8 be ff ff ff       	call   801312 <close>
	for (i = 0; i < MAXFD; i++)
  801354:	83 c3 01             	add    $0x1,%ebx
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	83 fb 20             	cmp    $0x20,%ebx
  80135d:	75 ec                	jne    80134b <close_all+0xc>
}
  80135f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	57                   	push   %edi
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80136d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801370:	50                   	push   %eax
  801371:	ff 75 08             	push   0x8(%ebp)
  801374:	e8 71 fe ff ff       	call   8011ea <fd_lookup>
  801379:	89 c3                	mov    %eax,%ebx
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 7f                	js     801401 <dup+0x9d>
		return r;
	close(newfdnum);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	ff 75 0c             	push   0xc(%ebp)
  801388:	e8 85 ff ff ff       	call   801312 <close>

	newfd = INDEX2FD(newfdnum);
  80138d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801390:	c1 e6 0c             	shl    $0xc,%esi
  801393:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80139c:	89 3c 24             	mov    %edi,(%esp)
  80139f:	e8 df fd ff ff       	call   801183 <fd2data>
  8013a4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013a6:	89 34 24             	mov    %esi,(%esp)
  8013a9:	e8 d5 fd ff ff       	call   801183 <fd2data>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	c1 e8 16             	shr    $0x16,%eax
  8013b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c0:	a8 01                	test   $0x1,%al
  8013c2:	74 11                	je     8013d5 <dup+0x71>
  8013c4:	89 d8                	mov    %ebx,%eax
  8013c6:	c1 e8 0c             	shr    $0xc,%eax
  8013c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d0:	f6 c2 01             	test   $0x1,%dl
  8013d3:	75 36                	jne    80140b <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013d5:	89 f8                	mov    %edi,%eax
  8013d7:	c1 e8 0c             	shr    $0xc,%eax
  8013da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e1:	83 ec 0c             	sub    $0xc,%esp
  8013e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e9:	50                   	push   %eax
  8013ea:	56                   	push   %esi
  8013eb:	6a 00                	push   $0x0
  8013ed:	57                   	push   %edi
  8013ee:	6a 00                	push   $0x0
  8013f0:	e8 d0 fb ff ff       	call   800fc5 <sys_page_map>
  8013f5:	89 c3                	mov    %eax,%ebx
  8013f7:	83 c4 20             	add    $0x20,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 33                	js     801431 <dup+0xcd>
		goto err;

	return newfdnum;
  8013fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801401:	89 d8                	mov    %ebx,%eax
  801403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801406:	5b                   	pop    %ebx
  801407:	5e                   	pop    %esi
  801408:	5f                   	pop    %edi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80140b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	25 07 0e 00 00       	and    $0xe07,%eax
  80141a:	50                   	push   %eax
  80141b:	ff 75 d4             	push   -0x2c(%ebp)
  80141e:	6a 00                	push   $0x0
  801420:	53                   	push   %ebx
  801421:	6a 00                	push   $0x0
  801423:	e8 9d fb ff ff       	call   800fc5 <sys_page_map>
  801428:	89 c3                	mov    %eax,%ebx
  80142a:	83 c4 20             	add    $0x20,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	79 a4                	jns    8013d5 <dup+0x71>
	sys_page_unmap(0, newfd);
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	56                   	push   %esi
  801435:	6a 00                	push   $0x0
  801437:	e8 cb fb ff ff       	call   801007 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80143c:	83 c4 08             	add    $0x8,%esp
  80143f:	ff 75 d4             	push   -0x2c(%ebp)
  801442:	6a 00                	push   $0x0
  801444:	e8 be fb ff ff       	call   801007 <sys_page_unmap>
	return r;
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	eb b3                	jmp    801401 <dup+0x9d>

0080144e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
  801453:	83 ec 18             	sub    $0x18,%esp
  801456:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801459:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145c:	50                   	push   %eax
  80145d:	56                   	push   %esi
  80145e:	e8 87 fd ff ff       	call   8011ea <fd_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 3c                	js     8014a6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	ff 33                	push   (%ebx)
  801476:	e8 bf fd ff ff       	call   80123a <dev_lookup>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 24                	js     8014a6 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801482:	8b 43 08             	mov    0x8(%ebx),%eax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	83 f8 01             	cmp    $0x1,%eax
  80148b:	74 20                	je     8014ad <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	8b 40 08             	mov    0x8(%eax),%eax
  801493:	85 c0                	test   %eax,%eax
  801495:	74 37                	je     8014ce <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	ff 75 10             	push   0x10(%ebp)
  80149d:	ff 75 0c             	push   0xc(%ebp)
  8014a0:	53                   	push   %ebx
  8014a1:	ff d0                	call   *%eax
  8014a3:	83 c4 10             	add    $0x10,%esp
}
  8014a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ad:	a1 70 67 80 00       	mov    0x806770,%eax
  8014b2:	8b 40 48             	mov    0x48(%eax),%eax
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	56                   	push   %esi
  8014b9:	50                   	push   %eax
  8014ba:	68 6d 2b 80 00       	push   $0x802b6d
  8014bf:	e8 fd ef ff ff       	call   8004c1 <cprintf>
		return -E_INVAL;
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014cc:	eb d8                	jmp    8014a6 <read+0x58>
		return -E_NOT_SUPP;
  8014ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d3:	eb d1                	jmp    8014a6 <read+0x58>

008014d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	57                   	push   %edi
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e9:	eb 02                	jmp    8014ed <readn+0x18>
  8014eb:	01 c3                	add    %eax,%ebx
  8014ed:	39 f3                	cmp    %esi,%ebx
  8014ef:	73 21                	jae    801512 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	89 f0                	mov    %esi,%eax
  8014f6:	29 d8                	sub    %ebx,%eax
  8014f8:	50                   	push   %eax
  8014f9:	89 d8                	mov    %ebx,%eax
  8014fb:	03 45 0c             	add    0xc(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	57                   	push   %edi
  801500:	e8 49 ff ff ff       	call   80144e <read>
		if (m < 0)
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 04                	js     801510 <readn+0x3b>
			return m;
		if (m == 0)
  80150c:	75 dd                	jne    8014eb <readn+0x16>
  80150e:	eb 02                	jmp    801512 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801510:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801512:	89 d8                	mov    %ebx,%eax
  801514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801517:	5b                   	pop    %ebx
  801518:	5e                   	pop    %esi
  801519:	5f                   	pop    %edi
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    

0080151c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	56                   	push   %esi
  801520:	53                   	push   %ebx
  801521:	83 ec 18             	sub    $0x18,%esp
  801524:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801527:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	53                   	push   %ebx
  80152c:	e8 b9 fc ff ff       	call   8011ea <fd_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 37                	js     80156f <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	ff 36                	push   (%esi)
  801544:	e8 f1 fc ff ff       	call   80123a <dev_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 1f                	js     80156f <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801550:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801554:	74 20                	je     801576 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	8b 40 0c             	mov    0xc(%eax),%eax
  80155c:	85 c0                	test   %eax,%eax
  80155e:	74 37                	je     801597 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	ff 75 10             	push   0x10(%ebp)
  801566:	ff 75 0c             	push   0xc(%ebp)
  801569:	56                   	push   %esi
  80156a:	ff d0                	call   *%eax
  80156c:	83 c4 10             	add    $0x10,%esp
}
  80156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801576:	a1 70 67 80 00       	mov    0x806770,%eax
  80157b:	8b 40 48             	mov    0x48(%eax),%eax
  80157e:	83 ec 04             	sub    $0x4,%esp
  801581:	53                   	push   %ebx
  801582:	50                   	push   %eax
  801583:	68 89 2b 80 00       	push   $0x802b89
  801588:	e8 34 ef ff ff       	call   8004c1 <cprintf>
		return -E_INVAL;
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801595:	eb d8                	jmp    80156f <write+0x53>
		return -E_NOT_SUPP;
  801597:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159c:	eb d1                	jmp    80156f <write+0x53>

0080159e <seek>:

int
seek(int fdnum, off_t offset)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 08             	push   0x8(%ebp)
  8015ab:	e8 3a fc ff ff       	call   8011ea <fd_lookup>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 0e                	js     8015c5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	56                   	push   %esi
  8015cb:	53                   	push   %ebx
  8015cc:	83 ec 18             	sub    $0x18,%esp
  8015cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d5:	50                   	push   %eax
  8015d6:	53                   	push   %ebx
  8015d7:	e8 0e fc ff ff       	call   8011ea <fd_lookup>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 34                	js     801617 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ec:	50                   	push   %eax
  8015ed:	ff 36                	push   (%esi)
  8015ef:	e8 46 fc ff ff       	call   80123a <dev_lookup>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	78 1c                	js     801617 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015fb:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8015ff:	74 1d                	je     80161e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801604:	8b 40 18             	mov    0x18(%eax),%eax
  801607:	85 c0                	test   %eax,%eax
  801609:	74 34                	je     80163f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 0c             	push   0xc(%ebp)
  801611:	56                   	push   %esi
  801612:	ff d0                	call   *%eax
  801614:	83 c4 10             	add    $0x10,%esp
}
  801617:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80161e:	a1 70 67 80 00       	mov    0x806770,%eax
  801623:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	53                   	push   %ebx
  80162a:	50                   	push   %eax
  80162b:	68 4c 2b 80 00       	push   $0x802b4c
  801630:	e8 8c ee ff ff       	call   8004c1 <cprintf>
		return -E_INVAL;
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163d:	eb d8                	jmp    801617 <ftruncate+0x50>
		return -E_NOT_SUPP;
  80163f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801644:	eb d1                	jmp    801617 <ftruncate+0x50>

00801646 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	83 ec 18             	sub    $0x18,%esp
  80164e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801651:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801654:	50                   	push   %eax
  801655:	ff 75 08             	push   0x8(%ebp)
  801658:	e8 8d fb ff ff       	call   8011ea <fd_lookup>
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	85 c0                	test   %eax,%eax
  801662:	78 49                	js     8016ad <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801664:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166d:	50                   	push   %eax
  80166e:	ff 36                	push   (%esi)
  801670:	e8 c5 fb ff ff       	call   80123a <dev_lookup>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 31                	js     8016ad <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  80167c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801683:	74 2f                	je     8016b4 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801685:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801688:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80168f:	00 00 00 
	stat->st_isdir = 0;
  801692:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801699:	00 00 00 
	stat->st_dev = dev;
  80169c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	53                   	push   %ebx
  8016a6:	56                   	push   %esi
  8016a7:	ff 50 14             	call   *0x14(%eax)
  8016aa:	83 c4 10             	add    $0x10,%esp
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b9:	eb f2                	jmp    8016ad <fstat+0x67>

008016bb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	6a 00                	push   $0x0
  8016c5:	ff 75 08             	push   0x8(%ebp)
  8016c8:	e8 22 02 00 00       	call   8018ef <open>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 1b                	js     8016f1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	ff 75 0c             	push   0xc(%ebp)
  8016dc:	50                   	push   %eax
  8016dd:	e8 64 ff ff ff       	call   801646 <fstat>
  8016e2:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e4:	89 1c 24             	mov    %ebx,(%esp)
  8016e7:	e8 26 fc ff ff       	call   801312 <close>
	return r;
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	89 f3                	mov    %esi,%ebx
}
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	89 c6                	mov    %eax,%esi
  801701:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801703:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80170a:	74 27                	je     801733 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80170c:	6a 07                	push   $0x7
  80170e:	68 00 70 80 00       	push   $0x807000
  801713:	56                   	push   %esi
  801714:	ff 35 00 80 80 00    	push   0x808000
  80171a:	e8 43 0c 00 00       	call   802362 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80171f:	83 c4 0c             	add    $0xc,%esp
  801722:	6a 00                	push   $0x0
  801724:	53                   	push   %ebx
  801725:	6a 00                	push   $0x0
  801727:	e8 e7 0b 00 00       	call   802313 <ipc_recv>
}
  80172c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	6a 01                	push   $0x1
  801738:	e8 71 0c 00 00       	call   8023ae <ipc_find_env>
  80173d:	a3 00 80 80 00       	mov    %eax,0x808000
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	eb c5                	jmp    80170c <fsipc+0x12>

00801747 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8b 40 0c             	mov    0xc(%eax),%eax
  801753:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175b:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	b8 02 00 00 00       	mov    $0x2,%eax
  80176a:	e8 8b ff ff ff       	call   8016fa <fsipc>
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <devfile_flush>:
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8b 40 0c             	mov    0xc(%eax),%eax
  80177d:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801782:	ba 00 00 00 00       	mov    $0x0,%edx
  801787:	b8 06 00 00 00       	mov    $0x6,%eax
  80178c:	e8 69 ff ff ff       	call   8016fa <fsipc>
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <devfile_stat>:
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	53                   	push   %ebx
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a3:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ad:	b8 05 00 00 00       	mov    $0x5,%eax
  8017b2:	e8 43 ff ff ff       	call   8016fa <fsipc>
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 2c                	js     8017e7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	68 00 70 80 00       	push   $0x807000
  8017c3:	53                   	push   %ebx
  8017c4:	e8 bd f3 ff ff       	call   800b86 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017c9:	a1 80 70 80 00       	mov    0x807080,%eax
  8017ce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017d4:	a1 84 70 80 00       	mov    0x807084,%eax
  8017d9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <devfile_write>:
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  801801:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801807:	53                   	push   %ebx
  801808:	ff 75 0c             	push   0xc(%ebp)
  80180b:	68 08 70 80 00       	push   $0x807008
  801810:	e8 69 f5 ff ff       	call   800d7e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	b8 04 00 00 00       	mov    $0x4,%eax
  80181f:	e8 d6 fe ff ff       	call   8016fa <fsipc>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 0b                	js     801836 <devfile_write+0x4a>
	assert(r <= n);
  80182b:	39 d8                	cmp    %ebx,%eax
  80182d:	77 0c                	ja     80183b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80182f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801834:	7f 1e                	jg     801854 <devfile_write+0x68>
}
  801836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801839:	c9                   	leave  
  80183a:	c3                   	ret    
	assert(r <= n);
  80183b:	68 b8 2b 80 00       	push   $0x802bb8
  801840:	68 bf 2b 80 00       	push   $0x802bbf
  801845:	68 97 00 00 00       	push   $0x97
  80184a:	68 d4 2b 80 00       	push   $0x802bd4
  80184f:	e8 92 eb ff ff       	call   8003e6 <_panic>
	assert(r <= PGSIZE);
  801854:	68 df 2b 80 00       	push   $0x802bdf
  801859:	68 bf 2b 80 00       	push   $0x802bbf
  80185e:	68 98 00 00 00       	push   $0x98
  801863:	68 d4 2b 80 00       	push   $0x802bd4
  801868:	e8 79 eb ff ff       	call   8003e6 <_panic>

0080186d <devfile_read>:
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	8b 40 0c             	mov    0xc(%eax),%eax
  80187b:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801880:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 03 00 00 00       	mov    $0x3,%eax
  801890:	e8 65 fe ff ff       	call   8016fa <fsipc>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	85 c0                	test   %eax,%eax
  801899:	78 1f                	js     8018ba <devfile_read+0x4d>
	assert(r <= n);
  80189b:	39 f0                	cmp    %esi,%eax
  80189d:	77 24                	ja     8018c3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80189f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a4:	7f 33                	jg     8018d9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	50                   	push   %eax
  8018aa:	68 00 70 80 00       	push   $0x807000
  8018af:	ff 75 0c             	push   0xc(%ebp)
  8018b2:	e8 65 f4 ff ff       	call   800d1c <memmove>
	return r;
  8018b7:	83 c4 10             	add    $0x10,%esp
}
  8018ba:	89 d8                	mov    %ebx,%eax
  8018bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    
	assert(r <= n);
  8018c3:	68 b8 2b 80 00       	push   $0x802bb8
  8018c8:	68 bf 2b 80 00       	push   $0x802bbf
  8018cd:	6a 7c                	push   $0x7c
  8018cf:	68 d4 2b 80 00       	push   $0x802bd4
  8018d4:	e8 0d eb ff ff       	call   8003e6 <_panic>
	assert(r <= PGSIZE);
  8018d9:	68 df 2b 80 00       	push   $0x802bdf
  8018de:	68 bf 2b 80 00       	push   $0x802bbf
  8018e3:	6a 7d                	push   $0x7d
  8018e5:	68 d4 2b 80 00       	push   $0x802bd4
  8018ea:	e8 f7 ea ff ff       	call   8003e6 <_panic>

008018ef <open>:
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 1c             	sub    $0x1c,%esp
  8018f7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018fa:	56                   	push   %esi
  8018fb:	e8 4b f2 ff ff       	call   800b4b <strlen>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801908:	7f 6c                	jg     801976 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80190a:	83 ec 0c             	sub    $0xc,%esp
  80190d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801910:	50                   	push   %eax
  801911:	e8 84 f8 ff ff       	call   80119a <fd_alloc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 3c                	js     80195b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	56                   	push   %esi
  801923:	68 00 70 80 00       	push   $0x807000
  801928:	e8 59 f2 ff ff       	call   800b86 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	b8 01 00 00 00       	mov    $0x1,%eax
  80193d:	e8 b8 fd ff ff       	call   8016fa <fsipc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 19                	js     801964 <open+0x75>
	return fd2num(fd);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 f4             	push   -0xc(%ebp)
  801951:	e8 1d f8 ff ff       	call   801173 <fd2num>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	83 c4 10             	add    $0x10,%esp
}
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801960:	5b                   	pop    %ebx
  801961:	5e                   	pop    %esi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    
		fd_close(fd, 0);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	6a 00                	push   $0x0
  801969:	ff 75 f4             	push   -0xc(%ebp)
  80196c:	e8 1a f9 ff ff       	call   80128b <fd_close>
		return r;
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb e5                	jmp    80195b <open+0x6c>
		return -E_BAD_PATH;
  801976:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80197b:	eb de                	jmp    80195b <open+0x6c>

0080197d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801983:	ba 00 00 00 00       	mov    $0x0,%edx
  801988:	b8 08 00 00 00       	mov    $0x8,%eax
  80198d:	e8 68 fd ff ff       	call   8016fa <fsipc>
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	57                   	push   %edi
  801998:	56                   	push   %esi
  801999:	53                   	push   %ebx
  80199a:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 08             	push   0x8(%ebp)
  8019a5:	e8 45 ff ff ff       	call   8018ef <open>
  8019aa:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	0f 88 d0 04 00 00    	js     801e8b <spawn+0x4f7>
  8019bb:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 00 02 00 00       	push   $0x200
  8019c5:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	51                   	push   %ecx
  8019cd:	e8 03 fb ff ff       	call   8014d5 <readn>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019da:	75 57                	jne    801a33 <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  8019dc:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8019e3:	45 4c 46 
  8019e6:	75 4b                	jne    801a33 <spawn+0x9f>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019e8:	b8 07 00 00 00       	mov    $0x7,%eax
  8019ed:	cd 30                	int    $0x30
  8019ef:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	0f 88 82 04 00 00    	js     801e7f <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a02:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801a05:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a0b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a11:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a18:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a1e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a24:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a29:	be 00 00 00 00       	mov    $0x0,%esi
  801a2e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801a31:	eb 4b                	jmp    801a7e <spawn+0xea>
		close(fd);
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801a3c:	e8 d1 f8 ff ff       	call   801312 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a41:	83 c4 0c             	add    $0xc,%esp
  801a44:	68 7f 45 4c 46       	push   $0x464c457f
  801a49:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  801a4f:	68 eb 2b 80 00       	push   $0x802beb
  801a54:	e8 68 ea ff ff       	call   8004c1 <cprintf>
		return -E_NOT_EXEC;
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801a63:	ff ff ff 
  801a66:	e9 20 04 00 00       	jmp    801e8b <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 d7 f0 ff ff       	call   800b4b <strlen>
  801a74:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a78:	83 c3 01             	add    $0x1,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a85:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	75 df                	jne    801a6b <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a8c:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a92:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a98:	b8 00 10 40 00       	mov    $0x401000,%eax
  801a9d:	29 f0                	sub    %esi,%eax
  801a9f:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801aa1:	89 c2                	mov    %eax,%edx
  801aa3:	83 e2 fc             	and    $0xfffffffc,%edx
  801aa6:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801aad:	29 c2                	sub    %eax,%edx
  801aaf:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ab5:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ab8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801abd:	0f 86 eb 03 00 00    	jbe    801eae <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	6a 07                	push   $0x7
  801ac8:	68 00 00 40 00       	push   $0x400000
  801acd:	6a 00                	push   $0x0
  801acf:	e8 ae f4 ff ff       	call   800f82 <sys_page_alloc>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	0f 88 d4 03 00 00    	js     801eb3 <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801adf:	be 00 00 00 00       	mov    $0x0,%esi
  801ae4:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801aed:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801af3:	7e 32                	jle    801b27 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801af5:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801afb:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b01:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	ff 34 b3             	push   (%ebx,%esi,4)
  801b0a:	57                   	push   %edi
  801b0b:	e8 76 f0 ff ff       	call   800b86 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b10:	83 c4 04             	add    $0x4,%esp
  801b13:	ff 34 b3             	push   (%ebx,%esi,4)
  801b16:	e8 30 f0 ff ff       	call   800b4b <strlen>
  801b1b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b1f:	83 c6 01             	add    $0x1,%esi
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	eb c6                	jmp    801aed <spawn+0x159>
	}
	argv_store[argc] = 0;
  801b27:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b2d:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b33:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b3a:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b40:	0f 85 8c 00 00 00    	jne    801bd2 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b46:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801b4c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b52:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801b55:	89 f8                	mov    %edi,%eax
  801b57:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801b5d:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b60:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b65:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	6a 07                	push   $0x7
  801b70:	68 00 d0 bf ee       	push   $0xeebfd000
  801b75:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801b7b:	68 00 00 40 00       	push   $0x400000
  801b80:	6a 00                	push   $0x0
  801b82:	e8 3e f4 ff ff       	call   800fc5 <sys_page_map>
  801b87:	89 c3                	mov    %eax,%ebx
  801b89:	83 c4 20             	add    $0x20,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	0f 88 27 03 00 00    	js     801ebb <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b94:	83 ec 08             	sub    $0x8,%esp
  801b97:	68 00 00 40 00       	push   $0x400000
  801b9c:	6a 00                	push   $0x0
  801b9e:	e8 64 f4 ff ff       	call   801007 <sys_page_unmap>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 88 0b 03 00 00    	js     801ebb <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bb0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bb6:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801bbd:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801bc3:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801bca:	00 00 00 
  801bcd:	e9 4e 01 00 00       	jmp    801d20 <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bd2:	68 60 2c 80 00       	push   $0x802c60
  801bd7:	68 bf 2b 80 00       	push   $0x802bbf
  801bdc:	68 f2 00 00 00       	push   $0xf2
  801be1:	68 05 2c 80 00       	push   $0x802c05
  801be6:	e8 fb e7 ff ff       	call   8003e6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	6a 07                	push   $0x7
  801bf0:	68 00 00 40 00       	push   $0x400000
  801bf5:	6a 00                	push   $0x0
  801bf7:	e8 86 f3 ff ff       	call   800f82 <sys_page_alloc>
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	0f 88 92 02 00 00    	js     801e99 <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c07:	83 ec 08             	sub    $0x8,%esp
  801c0a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c10:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  801c16:	50                   	push   %eax
  801c17:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801c1d:	e8 7c f9 ff ff       	call   80159e <seek>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	0f 88 73 02 00 00    	js     801ea0 <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	89 f8                	mov    %edi,%eax
  801c32:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  801c38:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c3d:	39 d0                	cmp    %edx,%eax
  801c3f:	0f 47 c2             	cmova  %edx,%eax
  801c42:	50                   	push   %eax
  801c43:	68 00 00 40 00       	push   $0x400000
  801c48:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801c4e:	e8 82 f8 ff ff       	call   8014d5 <readn>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	0f 88 49 02 00 00    	js     801ea7 <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c5e:	83 ec 0c             	sub    $0xc,%esp
  801c61:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  801c67:	56                   	push   %esi
  801c68:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801c6e:	68 00 00 40 00       	push   $0x400000
  801c73:	6a 00                	push   $0x0
  801c75:	e8 4b f3 ff ff       	call   800fc5 <sys_page_map>
  801c7a:	83 c4 20             	add    $0x20,%esp
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 7c                	js     801cfd <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c81:	83 ec 08             	sub    $0x8,%esp
  801c84:	68 00 00 40 00       	push   $0x400000
  801c89:	6a 00                	push   $0x0
  801c8b:	e8 77 f3 ff ff       	call   801007 <sys_page_unmap>
  801c90:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c99:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801c9f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801ca5:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  801cab:	76 65                	jbe    801d12 <spawn+0x37e>
		if (i >= filesz) {
  801cad:	39 df                	cmp    %ebx,%edi
  801caf:	0f 87 36 ff ff ff    	ja     801beb <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  801cbe:	56                   	push   %esi
  801cbf:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801cc5:	e8 b8 f2 ff ff       	call   800f82 <sys_page_alloc>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	79 c2                	jns    801c93 <spawn+0x2ff>
  801cd1:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801cdc:	e8 22 f2 ff ff       	call   800f03 <sys_env_destroy>
	close(fd);
  801ce1:	83 c4 04             	add    $0x4,%esp
  801ce4:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801cea:	e8 23 f6 ff ff       	call   801312 <close>
	return r;
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801cf8:	e9 8e 01 00 00       	jmp    801e8b <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  801cfd:	50                   	push   %eax
  801cfe:	68 11 2c 80 00       	push   $0x802c11
  801d03:	68 25 01 00 00       	push   $0x125
  801d08:	68 05 2c 80 00       	push   $0x802c05
  801d0d:	e8 d4 e6 ff ff       	call   8003e6 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d12:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801d19:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801d20:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d27:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801d2d:	7e 67                	jle    801d96 <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  801d2f:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801d35:	83 39 01             	cmpl   $0x1,(%ecx)
  801d38:	75 d8                	jne    801d12 <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d3a:	8b 41 18             	mov    0x18(%ecx),%eax
  801d3d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801d43:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d46:	83 f8 01             	cmp    $0x1,%eax
  801d49:	19 c0                	sbb    %eax,%eax
  801d4b:	83 e0 fe             	and    $0xfffffffe,%eax
  801d4e:	83 c0 07             	add    $0x7,%eax
  801d51:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d57:	8b 51 04             	mov    0x4(%ecx),%edx
  801d5a:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801d60:	8b 79 10             	mov    0x10(%ecx),%edi
  801d63:	8b 59 14             	mov    0x14(%ecx),%ebx
  801d66:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801d6c:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  801d6f:	89 f0                	mov    %esi,%eax
  801d71:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d76:	74 14                	je     801d8c <spawn+0x3f8>
		va -= i;
  801d78:	29 c6                	sub    %eax,%esi
		memsz += i;
  801d7a:	01 c3                	add    %eax,%ebx
  801d7c:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  801d82:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801d84:	29 c2                	sub    %eax,%edx
  801d86:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d91:	e9 09 ff ff ff       	jmp    801c9f <spawn+0x30b>
	close(fd);
  801d96:	83 ec 0c             	sub    $0xc,%esp
  801d99:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  801d9f:	e8 6e f5 ff ff       	call   801312 <close>
  801da4:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dac:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801db2:	eb 2d                	jmp    801de1 <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801db4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801dbb:	89 da                	mov    %ebx,%edx
  801dbd:	c1 e2 0c             	shl    $0xc,%edx
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	25 07 0e 00 00       	and    $0xe07,%eax
  801dc8:	50                   	push   %eax
  801dc9:	52                   	push   %edx
  801dca:	56                   	push   %esi
  801dcb:	52                   	push   %edx
  801dcc:	6a 00                	push   $0x0
  801dce:	e8 f2 f1 ff ff       	call   800fc5 <sys_page_map>
  801dd3:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  801dd6:	83 c3 01             	add    $0x1,%ebx
  801dd9:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  801ddf:	74 29                	je     801e0a <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  801de1:	89 d8                	mov    %ebx,%eax
  801de3:	c1 f8 0a             	sar    $0xa,%eax
  801de6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	74 e5                	je     801dd6 <spawn+0x442>
  801df1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801df8:	a8 01                	test   $0x1,%al
  801dfa:	74 da                	je     801dd6 <spawn+0x442>
  801dfc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801e03:	f6 c4 04             	test   $0x4,%ah
  801e06:	74 ce                	je     801dd6 <spawn+0x442>
  801e08:	eb aa                	jmp    801db4 <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e0a:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e11:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e14:	83 ec 08             	sub    $0x8,%esp
  801e17:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e1d:	50                   	push   %eax
  801e1e:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801e24:	e8 62 f2 ff ff       	call   80108b <sys_env_set_trapframe>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 25                	js     801e55 <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	6a 02                	push   $0x2
  801e35:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  801e3b:	e8 09 f2 ff ff       	call   801049 <sys_env_set_status>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 23                	js     801e6a <spawn+0x4d6>
	return child;
  801e47:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e4d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801e53:	eb 36                	jmp    801e8b <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  801e55:	50                   	push   %eax
  801e56:	68 2e 2c 80 00       	push   $0x802c2e
  801e5b:	68 86 00 00 00       	push   $0x86
  801e60:	68 05 2c 80 00       	push   $0x802c05
  801e65:	e8 7c e5 ff ff       	call   8003e6 <_panic>
		panic("sys_env_set_status: %e", r);
  801e6a:	50                   	push   %eax
  801e6b:	68 48 2c 80 00       	push   $0x802c48
  801e70:	68 89 00 00 00       	push   $0x89
  801e75:	68 05 2c 80 00       	push   $0x802c05
  801e7a:	e8 67 e5 ff ff       	call   8003e6 <_panic>
		return r;
  801e7f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e85:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  801e8b:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	e9 33 fe ff ff       	jmp    801cd3 <spawn+0x33f>
  801ea0:	89 c7                	mov    %eax,%edi
  801ea2:	e9 2c fe ff ff       	jmp    801cd3 <spawn+0x33f>
  801ea7:	89 c7                	mov    %eax,%edi
  801ea9:	e9 25 fe ff ff       	jmp    801cd3 <spawn+0x33f>
		return -E_NO_MEM;
  801eae:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801eb3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801eb9:	eb d0                	jmp    801e8b <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	68 00 00 40 00       	push   $0x400000
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 3d f1 ff ff       	call   801007 <sys_page_unmap>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801ed3:	eb b6                	jmp    801e8b <spawn+0x4f7>

00801ed5 <spawnl>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	56                   	push   %esi
  801ed9:	53                   	push   %ebx
	va_start(vl, arg0);
  801eda:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ee2:	eb 05                	jmp    801ee9 <spawnl+0x14>
		argc++;
  801ee4:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801ee7:	89 ca                	mov    %ecx,%edx
  801ee9:	8d 4a 04             	lea    0x4(%edx),%ecx
  801eec:	83 3a 00             	cmpl   $0x0,(%edx)
  801eef:	75 f3                	jne    801ee4 <spawnl+0xf>
	const char *argv[argc+2];
  801ef1:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801ef8:	89 d3                	mov    %edx,%ebx
  801efa:	83 e3 f0             	and    $0xfffffff0,%ebx
  801efd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f03:	89 e1                	mov    %esp,%ecx
  801f05:	29 d1                	sub    %edx,%ecx
  801f07:	39 cc                	cmp    %ecx,%esp
  801f09:	74 10                	je     801f1b <spawnl+0x46>
  801f0b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801f11:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801f18:	00 
  801f19:	eb ec                	jmp    801f07 <spawnl+0x32>
  801f1b:	89 da                	mov    %ebx,%edx
  801f1d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f23:	29 d4                	sub    %edx,%esp
  801f25:	85 d2                	test   %edx,%edx
  801f27:	74 05                	je     801f2e <spawnl+0x59>
  801f29:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801f2e:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  801f32:	89 da                	mov    %ebx,%edx
  801f34:	c1 ea 02             	shr    $0x2,%edx
  801f37:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  801f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f3d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f44:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  801f4b:	00 
	va_start(vl, arg0);
  801f4c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f4f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	eb 0b                	jmp    801f63 <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  801f58:	83 c0 01             	add    $0x1,%eax
  801f5b:	8b 31                	mov    (%ecx),%esi
  801f5d:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  801f60:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f63:	39 d0                	cmp    %edx,%eax
  801f65:	75 f1                	jne    801f58 <spawnl+0x83>
	return spawn(prog, argv);
  801f67:	83 ec 08             	sub    $0x8,%esp
  801f6a:	53                   	push   %ebx
  801f6b:	ff 75 08             	push   0x8(%ebp)
  801f6e:	e8 21 fa ff ff       	call   801994 <spawn>
}
  801f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f76:	5b                   	pop    %ebx
  801f77:	5e                   	pop    %esi
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    

00801f7a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	56                   	push   %esi
  801f7e:	53                   	push   %ebx
  801f7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	ff 75 08             	push   0x8(%ebp)
  801f88:	e8 f6 f1 ff ff       	call   801183 <fd2data>
  801f8d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f8f:	83 c4 08             	add    $0x8,%esp
  801f92:	68 86 2c 80 00       	push   $0x802c86
  801f97:	53                   	push   %ebx
  801f98:	e8 e9 eb ff ff       	call   800b86 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f9d:	8b 46 04             	mov    0x4(%esi),%eax
  801fa0:	2b 06                	sub    (%esi),%eax
  801fa2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fa8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801faf:	00 00 00 
	stat->st_dev = &devpipe;
  801fb2:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801fb9:	47 80 00 
	return 0;
}
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fd2:	53                   	push   %ebx
  801fd3:	6a 00                	push   $0x0
  801fd5:	e8 2d f0 ff ff       	call   801007 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fda:	89 1c 24             	mov    %ebx,(%esp)
  801fdd:	e8 a1 f1 ff ff       	call   801183 <fd2data>
  801fe2:	83 c4 08             	add    $0x8,%esp
  801fe5:	50                   	push   %eax
  801fe6:	6a 00                	push   $0x0
  801fe8:	e8 1a f0 ff ff       	call   801007 <sys_page_unmap>
}
  801fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <_pipeisclosed>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 1c             	sub    $0x1c,%esp
  801ffb:	89 c7                	mov    %eax,%edi
  801ffd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fff:	a1 70 67 80 00       	mov    0x806770,%eax
  802004:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	57                   	push   %edi
  80200b:	e8 d7 03 00 00       	call   8023e7 <pageref>
  802010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802013:	89 34 24             	mov    %esi,(%esp)
  802016:	e8 cc 03 00 00       	call   8023e7 <pageref>
		nn = thisenv->env_runs;
  80201b:	8b 15 70 67 80 00    	mov    0x806770,%edx
  802021:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	39 cb                	cmp    %ecx,%ebx
  802029:	74 1b                	je     802046 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80202b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80202e:	75 cf                	jne    801fff <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802030:	8b 42 58             	mov    0x58(%edx),%eax
  802033:	6a 01                	push   $0x1
  802035:	50                   	push   %eax
  802036:	53                   	push   %ebx
  802037:	68 8d 2c 80 00       	push   $0x802c8d
  80203c:	e8 80 e4 ff ff       	call   8004c1 <cprintf>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	eb b9                	jmp    801fff <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802046:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802049:	0f 94 c0             	sete   %al
  80204c:	0f b6 c0             	movzbl %al,%eax
}
  80204f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802052:	5b                   	pop    %ebx
  802053:	5e                   	pop    %esi
  802054:	5f                   	pop    %edi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <devpipe_write>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	57                   	push   %edi
  80205b:	56                   	push   %esi
  80205c:	53                   	push   %ebx
  80205d:	83 ec 28             	sub    $0x28,%esp
  802060:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802063:	56                   	push   %esi
  802064:	e8 1a f1 ff ff       	call   801183 <fd2data>
  802069:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	bf 00 00 00 00       	mov    $0x0,%edi
  802073:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802076:	75 09                	jne    802081 <devpipe_write+0x2a>
	return i;
  802078:	89 f8                	mov    %edi,%eax
  80207a:	eb 23                	jmp    80209f <devpipe_write+0x48>
			sys_yield();
  80207c:	e8 e2 ee ff ff       	call   800f63 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802081:	8b 43 04             	mov    0x4(%ebx),%eax
  802084:	8b 0b                	mov    (%ebx),%ecx
  802086:	8d 51 20             	lea    0x20(%ecx),%edx
  802089:	39 d0                	cmp    %edx,%eax
  80208b:	72 1a                	jb     8020a7 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  80208d:	89 da                	mov    %ebx,%edx
  80208f:	89 f0                	mov    %esi,%eax
  802091:	e8 5c ff ff ff       	call   801ff2 <_pipeisclosed>
  802096:	85 c0                	test   %eax,%eax
  802098:	74 e2                	je     80207c <devpipe_write+0x25>
				return 0;
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5f                   	pop    %edi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020b1:	89 c2                	mov    %eax,%edx
  8020b3:	c1 fa 1f             	sar    $0x1f,%edx
  8020b6:	89 d1                	mov    %edx,%ecx
  8020b8:	c1 e9 1b             	shr    $0x1b,%ecx
  8020bb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020be:	83 e2 1f             	and    $0x1f,%edx
  8020c1:	29 ca                	sub    %ecx,%edx
  8020c3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020cb:	83 c0 01             	add    $0x1,%eax
  8020ce:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020d1:	83 c7 01             	add    $0x1,%edi
  8020d4:	eb 9d                	jmp    802073 <devpipe_write+0x1c>

008020d6 <devpipe_read>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 18             	sub    $0x18,%esp
  8020df:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020e2:	57                   	push   %edi
  8020e3:	e8 9b f0 ff ff       	call   801183 <fd2data>
  8020e8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	be 00 00 00 00       	mov    $0x0,%esi
  8020f2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f5:	75 13                	jne    80210a <devpipe_read+0x34>
	return i;
  8020f7:	89 f0                	mov    %esi,%eax
  8020f9:	eb 02                	jmp    8020fd <devpipe_read+0x27>
				return i;
  8020fb:	89 f0                	mov    %esi,%eax
}
  8020fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802100:	5b                   	pop    %ebx
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
			sys_yield();
  802105:	e8 59 ee ff ff       	call   800f63 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80210a:	8b 03                	mov    (%ebx),%eax
  80210c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80210f:	75 18                	jne    802129 <devpipe_read+0x53>
			if (i > 0)
  802111:	85 f6                	test   %esi,%esi
  802113:	75 e6                	jne    8020fb <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  802115:	89 da                	mov    %ebx,%edx
  802117:	89 f8                	mov    %edi,%eax
  802119:	e8 d4 fe ff ff       	call   801ff2 <_pipeisclosed>
  80211e:	85 c0                	test   %eax,%eax
  802120:	74 e3                	je     802105 <devpipe_read+0x2f>
				return 0;
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	eb d4                	jmp    8020fd <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802129:	99                   	cltd   
  80212a:	c1 ea 1b             	shr    $0x1b,%edx
  80212d:	01 d0                	add    %edx,%eax
  80212f:	83 e0 1f             	and    $0x1f,%eax
  802132:	29 d0                	sub    %edx,%eax
  802134:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80213c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80213f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802142:	83 c6 01             	add    $0x1,%esi
  802145:	eb ab                	jmp    8020f2 <devpipe_read+0x1c>

00802147 <pipe>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80214f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802152:	50                   	push   %eax
  802153:	e8 42 f0 ff ff       	call   80119a <fd_alloc>
  802158:	89 c3                	mov    %eax,%ebx
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	85 c0                	test   %eax,%eax
  80215f:	0f 88 23 01 00 00    	js     802288 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 07 04 00 00       	push   $0x407
  80216d:	ff 75 f4             	push   -0xc(%ebp)
  802170:	6a 00                	push   $0x0
  802172:	e8 0b ee ff ff       	call   800f82 <sys_page_alloc>
  802177:	89 c3                	mov    %eax,%ebx
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 88 04 01 00 00    	js     802288 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80218a:	50                   	push   %eax
  80218b:	e8 0a f0 ff ff       	call   80119a <fd_alloc>
  802190:	89 c3                	mov    %eax,%ebx
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	85 c0                	test   %eax,%eax
  802197:	0f 88 db 00 00 00    	js     802278 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 07 04 00 00       	push   $0x407
  8021a5:	ff 75 f0             	push   -0x10(%ebp)
  8021a8:	6a 00                	push   $0x0
  8021aa:	e8 d3 ed ff ff       	call   800f82 <sys_page_alloc>
  8021af:	89 c3                	mov    %eax,%ebx
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	0f 88 bc 00 00 00    	js     802278 <pipe+0x131>
	va = fd2data(fd0);
  8021bc:	83 ec 0c             	sub    $0xc,%esp
  8021bf:	ff 75 f4             	push   -0xc(%ebp)
  8021c2:	e8 bc ef ff ff       	call   801183 <fd2data>
  8021c7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c9:	83 c4 0c             	add    $0xc,%esp
  8021cc:	68 07 04 00 00       	push   $0x407
  8021d1:	50                   	push   %eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	e8 a9 ed ff ff       	call   800f82 <sys_page_alloc>
  8021d9:	89 c3                	mov    %eax,%ebx
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	0f 88 82 00 00 00    	js     802268 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	ff 75 f0             	push   -0x10(%ebp)
  8021ec:	e8 92 ef ff ff       	call   801183 <fd2data>
  8021f1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021f8:	50                   	push   %eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	56                   	push   %esi
  8021fc:	6a 00                	push   $0x0
  8021fe:	e8 c2 ed ff ff       	call   800fc5 <sys_page_map>
  802203:	89 c3                	mov    %eax,%ebx
  802205:	83 c4 20             	add    $0x20,%esp
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 4e                	js     80225a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80220c:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  802211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802214:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802216:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802219:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802223:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802228:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	ff 75 f4             	push   -0xc(%ebp)
  802235:	e8 39 ef ff ff       	call   801173 <fd2num>
  80223a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80223f:	83 c4 04             	add    $0x4,%esp
  802242:	ff 75 f0             	push   -0x10(%ebp)
  802245:	e8 29 ef ff ff       	call   801173 <fd2num>
  80224a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80224d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	bb 00 00 00 00       	mov    $0x0,%ebx
  802258:	eb 2e                	jmp    802288 <pipe+0x141>
	sys_page_unmap(0, va);
  80225a:	83 ec 08             	sub    $0x8,%esp
  80225d:	56                   	push   %esi
  80225e:	6a 00                	push   $0x0
  802260:	e8 a2 ed ff ff       	call   801007 <sys_page_unmap>
  802265:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802268:	83 ec 08             	sub    $0x8,%esp
  80226b:	ff 75 f0             	push   -0x10(%ebp)
  80226e:	6a 00                	push   $0x0
  802270:	e8 92 ed ff ff       	call   801007 <sys_page_unmap>
  802275:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802278:	83 ec 08             	sub    $0x8,%esp
  80227b:	ff 75 f4             	push   -0xc(%ebp)
  80227e:	6a 00                	push   $0x0
  802280:	e8 82 ed ff ff       	call   801007 <sys_page_unmap>
  802285:	83 c4 10             	add    $0x10,%esp
}
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228d:	5b                   	pop    %ebx
  80228e:	5e                   	pop    %esi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    

00802291 <pipeisclosed>:
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802297:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229a:	50                   	push   %eax
  80229b:	ff 75 08             	push   0x8(%ebp)
  80229e:	e8 47 ef ff ff       	call   8011ea <fd_lookup>
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 18                	js     8022c2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	ff 75 f4             	push   -0xc(%ebp)
  8022b0:	e8 ce ee ff ff       	call   801183 <fd2data>
  8022b5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	e8 33 fd ff ff       	call   801ff2 <_pipeisclosed>
  8022bf:	83 c4 10             	add    $0x10,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	56                   	push   %esi
  8022c8:	53                   	push   %ebx
  8022c9:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8022cc:	85 f6                	test   %esi,%esi
  8022ce:	74 13                	je     8022e3 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8022d0:	89 f3                	mov    %esi,%ebx
  8022d2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8022d8:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8022db:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8022e1:	eb 1b                	jmp    8022fe <wait+0x3a>
	assert(envid != 0);
  8022e3:	68 a5 2c 80 00       	push   $0x802ca5
  8022e8:	68 bf 2b 80 00       	push   $0x802bbf
  8022ed:	6a 09                	push   $0x9
  8022ef:	68 b0 2c 80 00       	push   $0x802cb0
  8022f4:	e8 ed e0 ff ff       	call   8003e6 <_panic>
		sys_yield();
  8022f9:	e8 65 ec ff ff       	call   800f63 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8022fe:	8b 43 48             	mov    0x48(%ebx),%eax
  802301:	39 f0                	cmp    %esi,%eax
  802303:	75 07                	jne    80230c <wait+0x48>
  802305:	8b 43 54             	mov    0x54(%ebx),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	75 ed                	jne    8022f9 <wait+0x35>
}
  80230c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	8b 75 08             	mov    0x8(%ebp),%esi
  80231b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80231e:	83 ec 0c             	sub    $0xc,%esp
  802321:	ff 75 0c             	push   0xc(%ebp)
  802324:	e8 09 ee ff ff       	call   801132 <sys_ipc_recv>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 2b                	js     80235b <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802330:	85 f6                	test   %esi,%esi
  802332:	74 0a                	je     80233e <ipc_recv+0x2b>
  802334:	a1 70 67 80 00       	mov    0x806770,%eax
  802339:	8b 40 74             	mov    0x74(%eax),%eax
  80233c:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80233e:	85 db                	test   %ebx,%ebx
  802340:	74 0a                	je     80234c <ipc_recv+0x39>
  802342:	a1 70 67 80 00       	mov    0x806770,%eax
  802347:	8b 40 78             	mov    0x78(%eax),%eax
  80234a:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80234c:	a1 70 67 80 00       	mov    0x806770,%eax
  802351:	8b 40 70             	mov    0x70(%eax),%eax
}
  802354:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  80235b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802360:	eb f2                	jmp    802354 <ipc_recv+0x41>

00802362 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	57                   	push   %edi
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80236e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802371:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802374:	ff 75 14             	push   0x14(%ebp)
  802377:	53                   	push   %ebx
  802378:	56                   	push   %esi
  802379:	57                   	push   %edi
  80237a:	e8 90 ed ff ff       	call   80110f <sys_ipc_try_send>
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	85 c0                	test   %eax,%eax
  802384:	79 20                	jns    8023a6 <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802386:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802389:	75 07                	jne    802392 <ipc_send+0x30>
		sys_yield();
  80238b:	e8 d3 eb ff ff       	call   800f63 <sys_yield>
  802390:	eb e2                	jmp    802374 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	68 bb 2c 80 00       	push   $0x802cbb
  80239a:	6a 2e                	push   $0x2e
  80239c:	68 cb 2c 80 00       	push   $0x802ccb
  8023a1:	e8 40 e0 ff ff       	call   8003e6 <_panic>
	}
}
  8023a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a9:	5b                   	pop    %ebx
  8023aa:	5e                   	pop    %esi
  8023ab:	5f                   	pop    %edi
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    

008023ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023b9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023bc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023c2:	8b 52 50             	mov    0x50(%edx),%edx
  8023c5:	39 ca                	cmp    %ecx,%edx
  8023c7:	74 11                	je     8023da <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8023c9:	83 c0 01             	add    $0x1,%eax
  8023cc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023d1:	75 e6                	jne    8023b9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	eb 0b                	jmp    8023e5 <ipc_find_env+0x37>
			return envs[i].env_id;
  8023da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023e2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	c1 ea 16             	shr    $0x16,%edx
  8023f2:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8023f9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8023fe:	f6 c1 01             	test   $0x1,%cl
  802401:	74 1c                	je     80241f <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802403:	c1 e8 0c             	shr    $0xc,%eax
  802406:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80240d:	a8 01                	test   $0x1,%al
  80240f:	74 0e                	je     80241f <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802411:	c1 e8 0c             	shr    $0xc,%eax
  802414:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80241b:	ef 
  80241c:	0f b7 d2             	movzwl %dx,%edx
}
  80241f:	89 d0                	mov    %edx,%eax
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    
  802423:	66 90                	xchg   %ax,%ax
  802425:	66 90                	xchg   %ax,%ax
  802427:	66 90                	xchg   %ax,%ax
  802429:	66 90                	xchg   %ax,%ax
  80242b:	66 90                	xchg   %ax,%ax
  80242d:	66 90                	xchg   %ax,%ax
  80242f:	90                   	nop

00802430 <__udivdi3>:
  802430:	f3 0f 1e fb          	endbr32 
  802434:	55                   	push   %ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	83 ec 1c             	sub    $0x1c,%esp
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802443:	8b 74 24 34          	mov    0x34(%esp),%esi
  802447:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80244b:	85 c0                	test   %eax,%eax
  80244d:	75 19                	jne    802468 <__udivdi3+0x38>
  80244f:	39 f3                	cmp    %esi,%ebx
  802451:	76 4d                	jbe    8024a0 <__udivdi3+0x70>
  802453:	31 ff                	xor    %edi,%edi
  802455:	89 e8                	mov    %ebp,%eax
  802457:	89 f2                	mov    %esi,%edx
  802459:	f7 f3                	div    %ebx
  80245b:	89 fa                	mov    %edi,%edx
  80245d:	83 c4 1c             	add    $0x1c,%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	39 f0                	cmp    %esi,%eax
  80246a:	76 14                	jbe    802480 <__udivdi3+0x50>
  80246c:	31 ff                	xor    %edi,%edi
  80246e:	31 c0                	xor    %eax,%eax
  802470:	89 fa                	mov    %edi,%edx
  802472:	83 c4 1c             	add    $0x1c,%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
  80247a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802480:	0f bd f8             	bsr    %eax,%edi
  802483:	83 f7 1f             	xor    $0x1f,%edi
  802486:	75 48                	jne    8024d0 <__udivdi3+0xa0>
  802488:	39 f0                	cmp    %esi,%eax
  80248a:	72 06                	jb     802492 <__udivdi3+0x62>
  80248c:	31 c0                	xor    %eax,%eax
  80248e:	39 eb                	cmp    %ebp,%ebx
  802490:	77 de                	ja     802470 <__udivdi3+0x40>
  802492:	b8 01 00 00 00       	mov    $0x1,%eax
  802497:	eb d7                	jmp    802470 <__udivdi3+0x40>
  802499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a0:	89 d9                	mov    %ebx,%ecx
  8024a2:	85 db                	test   %ebx,%ebx
  8024a4:	75 0b                	jne    8024b1 <__udivdi3+0x81>
  8024a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f3                	div    %ebx
  8024af:	89 c1                	mov    %eax,%ecx
  8024b1:	31 d2                	xor    %edx,%edx
  8024b3:	89 f0                	mov    %esi,%eax
  8024b5:	f7 f1                	div    %ecx
  8024b7:	89 c6                	mov    %eax,%esi
  8024b9:	89 e8                	mov    %ebp,%eax
  8024bb:	89 f7                	mov    %esi,%edi
  8024bd:	f7 f1                	div    %ecx
  8024bf:	89 fa                	mov    %edi,%edx
  8024c1:	83 c4 1c             	add    $0x1c,%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5f                   	pop    %edi
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    
  8024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024d0:	89 f9                	mov    %edi,%ecx
  8024d2:	ba 20 00 00 00       	mov    $0x20,%edx
  8024d7:	29 fa                	sub    %edi,%edx
  8024d9:	d3 e0                	shl    %cl,%eax
  8024db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024df:	89 d1                	mov    %edx,%ecx
  8024e1:	89 d8                	mov    %ebx,%eax
  8024e3:	d3 e8                	shr    %cl,%eax
  8024e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 f0                	mov    %esi,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 f9                	mov    %edi,%ecx
  8024f3:	d3 e3                	shl    %cl,%ebx
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 f9                	mov    %edi,%ecx
  8024fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ff:	89 eb                	mov    %ebp,%ebx
  802501:	d3 e6                	shl    %cl,%esi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	d3 eb                	shr    %cl,%ebx
  802507:	09 f3                	or     %esi,%ebx
  802509:	89 c6                	mov    %eax,%esi
  80250b:	89 f2                	mov    %esi,%edx
  80250d:	89 d8                	mov    %ebx,%eax
  80250f:	f7 74 24 08          	divl   0x8(%esp)
  802513:	89 d6                	mov    %edx,%esi
  802515:	89 c3                	mov    %eax,%ebx
  802517:	f7 64 24 0c          	mull   0xc(%esp)
  80251b:	39 d6                	cmp    %edx,%esi
  80251d:	72 19                	jb     802538 <__udivdi3+0x108>
  80251f:	89 f9                	mov    %edi,%ecx
  802521:	d3 e5                	shl    %cl,%ebp
  802523:	39 c5                	cmp    %eax,%ebp
  802525:	73 04                	jae    80252b <__udivdi3+0xfb>
  802527:	39 d6                	cmp    %edx,%esi
  802529:	74 0d                	je     802538 <__udivdi3+0x108>
  80252b:	89 d8                	mov    %ebx,%eax
  80252d:	31 ff                	xor    %edi,%edi
  80252f:	e9 3c ff ff ff       	jmp    802470 <__udivdi3+0x40>
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80253b:	31 ff                	xor    %edi,%edi
  80253d:	e9 2e ff ff ff       	jmp    802470 <__udivdi3+0x40>
  802542:	66 90                	xchg   %ax,%ax
  802544:	66 90                	xchg   %ax,%ax
  802546:	66 90                	xchg   %ax,%ax
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	f3 0f 1e fb          	endbr32 
  802554:	55                   	push   %ebp
  802555:	57                   	push   %edi
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 1c             	sub    $0x1c,%esp
  80255b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80255f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802563:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802567:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	89 da                	mov    %ebx,%edx
  80256f:	85 ff                	test   %edi,%edi
  802571:	75 15                	jne    802588 <__umoddi3+0x38>
  802573:	39 dd                	cmp    %ebx,%ebp
  802575:	76 39                	jbe    8025b0 <__umoddi3+0x60>
  802577:	f7 f5                	div    %ebp
  802579:	89 d0                	mov    %edx,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	83 c4 1c             	add    $0x1c,%esp
  802580:	5b                   	pop    %ebx
  802581:	5e                   	pop    %esi
  802582:	5f                   	pop    %edi
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	39 df                	cmp    %ebx,%edi
  80258a:	77 f1                	ja     80257d <__umoddi3+0x2d>
  80258c:	0f bd cf             	bsr    %edi,%ecx
  80258f:	83 f1 1f             	xor    $0x1f,%ecx
  802592:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802596:	75 40                	jne    8025d8 <__umoddi3+0x88>
  802598:	39 df                	cmp    %ebx,%edi
  80259a:	72 04                	jb     8025a0 <__umoddi3+0x50>
  80259c:	39 f5                	cmp    %esi,%ebp
  80259e:	77 dd                	ja     80257d <__umoddi3+0x2d>
  8025a0:	89 da                	mov    %ebx,%edx
  8025a2:	89 f0                	mov    %esi,%eax
  8025a4:	29 e8                	sub    %ebp,%eax
  8025a6:	19 fa                	sbb    %edi,%edx
  8025a8:	eb d3                	jmp    80257d <__umoddi3+0x2d>
  8025aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b0:	89 e9                	mov    %ebp,%ecx
  8025b2:	85 ed                	test   %ebp,%ebp
  8025b4:	75 0b                	jne    8025c1 <__umoddi3+0x71>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f5                	div    %ebp
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	89 d8                	mov    %ebx,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f1                	div    %ecx
  8025c7:	89 f0                	mov    %esi,%eax
  8025c9:	f7 f1                	div    %ecx
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	31 d2                	xor    %edx,%edx
  8025cf:	eb ac                	jmp    80257d <__umoddi3+0x2d>
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025dc:	ba 20 00 00 00       	mov    $0x20,%edx
  8025e1:	29 c2                	sub    %eax,%edx
  8025e3:	89 c1                	mov    %eax,%ecx
  8025e5:	89 e8                	mov    %ebp,%eax
  8025e7:	d3 e7                	shl    %cl,%edi
  8025e9:	89 d1                	mov    %edx,%ecx
  8025eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8025ef:	d3 e8                	shr    %cl,%eax
  8025f1:	89 c1                	mov    %eax,%ecx
  8025f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f7:	09 f9                	or     %edi,%ecx
  8025f9:	89 df                	mov    %ebx,%edi
  8025fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ff:	89 c1                	mov    %eax,%ecx
  802601:	d3 e5                	shl    %cl,%ebp
  802603:	89 d1                	mov    %edx,%ecx
  802605:	d3 ef                	shr    %cl,%edi
  802607:	89 c1                	mov    %eax,%ecx
  802609:	89 f0                	mov    %esi,%eax
  80260b:	d3 e3                	shl    %cl,%ebx
  80260d:	89 d1                	mov    %edx,%ecx
  80260f:	89 fa                	mov    %edi,%edx
  802611:	d3 e8                	shr    %cl,%eax
  802613:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802618:	09 d8                	or     %ebx,%eax
  80261a:	f7 74 24 08          	divl   0x8(%esp)
  80261e:	89 d3                	mov    %edx,%ebx
  802620:	d3 e6                	shl    %cl,%esi
  802622:	f7 e5                	mul    %ebp
  802624:	89 c7                	mov    %eax,%edi
  802626:	89 d1                	mov    %edx,%ecx
  802628:	39 d3                	cmp    %edx,%ebx
  80262a:	72 06                	jb     802632 <__umoddi3+0xe2>
  80262c:	75 0e                	jne    80263c <__umoddi3+0xec>
  80262e:	39 c6                	cmp    %eax,%esi
  802630:	73 0a                	jae    80263c <__umoddi3+0xec>
  802632:	29 e8                	sub    %ebp,%eax
  802634:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802638:	89 d1                	mov    %edx,%ecx
  80263a:	89 c7                	mov    %eax,%edi
  80263c:	89 f5                	mov    %esi,%ebp
  80263e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802642:	29 fd                	sub    %edi,%ebp
  802644:	19 cb                	sbb    %ecx,%ebx
  802646:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80264b:	89 d8                	mov    %ebx,%eax
  80264d:	d3 e0                	shl    %cl,%eax
  80264f:	89 f1                	mov    %esi,%ecx
  802651:	d3 ed                	shr    %cl,%ebp
  802653:	d3 eb                	shr    %cl,%ebx
  802655:	09 e8                	or     %ebp,%eax
  802657:	89 da                	mov    %ebx,%edx
  802659:	83 c4 1c             	add    $0x1c,%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    
