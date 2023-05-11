
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 28 02 00 00       	call   800259 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 da 0e 00 00       	call   800f1e <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 7a 12 00 00       	call   8012cd <close>
	if ((r = opencons()) < 0)
  800053:	e8 af 01 00 00       	call   800207 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 14                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 1c 21 80 00       	push   $0x80211c
  800067:	6a 11                	push   $0x11
  800069:	68 0d 21 80 00       	push   $0x80210d
  80006e:	e8 3e 02 00 00       	call   8002b1 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 00 21 80 00       	push   $0x802100
  800079:	6a 0f                	push   $0xf
  80007b:	68 0d 21 80 00       	push   $0x80210d
  800080:	e8 2c 02 00 00       	call   8002b1 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 8e 12 00 00       	call   80131f <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 25                	jns    8000bd <umain+0x8a>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 36 21 80 00       	push   $0x802136
  80009e:	6a 13                	push   $0x13
  8000a0:	68 0d 21 80 00       	push   $0x80210d
  8000a5:	e8 07 02 00 00       	call   8002b1 <_panic>
	for(;;){
		char *buf;

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	50                   	push   %eax
  8000ae:	68 4c 21 80 00       	push   $0x80214c
  8000b3:	6a 01                	push   $0x1
  8000b5:	e8 7b 19 00 00       	call   801a35 <fprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 3e 21 80 00       	push   $0x80213e
  8000c5:	e8 4c 09 00 00       	call   800a16 <readline>
		if (buf != NULL)
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	75 d9                	jne    8000aa <umain+0x77>
		else
			fprintf(1, "(end of file received)\n");
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	68 50 21 80 00       	push   $0x802150
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 55 19 00 00       	call   801a35 <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d8                	jmp    8000bd <umain+0x8a>

008000e5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	c3                   	ret    

008000eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f1:	68 68 21 80 00       	push   $0x802168
  8000f6:	ff 75 0c             	push   0xc(%ebp)
  8000f9:	e8 43 0a 00 00       	call   800b41 <strcpy>
	return 0;
}
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <devcons_write>:
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800111:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80011c:	eb 2e                	jmp    80014c <devcons_write+0x47>
		m = n - tot;
  80011e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800121:	29 f3                	sub    %esi,%ebx
  800123:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800128:	39 c3                	cmp    %eax,%ebx
  80012a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80012d:	83 ec 04             	sub    $0x4,%esp
  800130:	53                   	push   %ebx
  800131:	89 f0                	mov    %esi,%eax
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	50                   	push   %eax
  800137:	57                   	push   %edi
  800138:	e8 9a 0b 00 00       	call   800cd7 <memmove>
		sys_cputs(buf, m);
  80013d:	83 c4 08             	add    $0x8,%esp
  800140:	53                   	push   %ebx
  800141:	57                   	push   %edi
  800142:	e8 3a 0d 00 00       	call   800e81 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800147:	01 de                	add    %ebx,%esi
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80014f:	72 cd                	jb     80011e <devcons_write+0x19>
}
  800151:	89 f0                	mov    %esi,%eax
  800153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5f                   	pop    %edi
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <devcons_read>:
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800166:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016a:	75 07                	jne    800173 <devcons_read+0x18>
  80016c:	eb 1f                	jmp    80018d <devcons_read+0x32>
		sys_yield();
  80016e:	e8 ab 0d 00 00       	call   800f1e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800173:	e8 27 0d 00 00       	call   800e9f <sys_cgetc>
  800178:	85 c0                	test   %eax,%eax
  80017a:	74 f2                	je     80016e <devcons_read+0x13>
	if (c < 0)
  80017c:	78 0f                	js     80018d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80017e:	83 f8 04             	cmp    $0x4,%eax
  800181:	74 0c                	je     80018f <devcons_read+0x34>
	*(char*)vbuf = c;
  800183:	8b 55 0c             	mov    0xc(%ebp),%edx
  800186:	88 02                	mov    %al,(%edx)
	return 1;
  800188:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    
		return 0;
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	eb f7                	jmp    80018d <devcons_read+0x32>

00800196 <cputchar>:
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80019c:	8b 45 08             	mov    0x8(%ebp),%eax
  80019f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001a2:	6a 01                	push   $0x1
  8001a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 d4 0c 00 00       	call   800e81 <sys_cputs>
}
  8001ad:	83 c4 10             	add    $0x10,%esp
  8001b0:	c9                   	leave  
  8001b1:	c3                   	ret    

008001b2 <getchar>:
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001b8:	6a 01                	push   $0x1
  8001ba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001bd:	50                   	push   %eax
  8001be:	6a 00                	push   $0x0
  8001c0:	e8 44 12 00 00       	call   801409 <read>
	if (r < 0)
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	78 06                	js     8001d2 <getchar+0x20>
	if (r < 1)
  8001cc:	74 06                	je     8001d4 <getchar+0x22>
	return c;
  8001ce:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    
		return -E_EOF;
  8001d4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001d9:	eb f7                	jmp    8001d2 <getchar+0x20>

008001db <iscons>:
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	ff 75 08             	push   0x8(%ebp)
  8001e8:	e8 b8 0f 00 00       	call   8011a5 <fd_lookup>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	78 11                	js     800205 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f7:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8001fd:	39 10                	cmp    %edx,(%eax)
  8001ff:	0f 94 c0             	sete   %al
  800202:	0f b6 c0             	movzbl %al,%eax
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <opencons>:
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80020d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 3f 0f 00 00       	call   801155 <fd_alloc>
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	85 c0                	test   %eax,%eax
  80021b:	78 3a                	js     800257 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	68 07 04 00 00       	push   $0x407
  800225:	ff 75 f4             	push   -0xc(%ebp)
  800228:	6a 00                	push   $0x0
  80022a:	e8 0e 0d 00 00       	call   800f3d <sys_page_alloc>
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	85 c0                	test   %eax,%eax
  800234:	78 21                	js     800257 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800239:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80023f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800244:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	50                   	push   %eax
  80024f:	e8 da 0e 00 00       	call   80112e <fd2num>
  800254:	83 c4 10             	add    $0x10,%esp
}
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	56                   	push   %esi
  80025d:	53                   	push   %ebx
  80025e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800261:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800264:	e8 96 0c 00 00       	call   800eff <sys_getenvid>
  800269:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800271:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800276:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027b:	85 db                	test   %ebx,%ebx
  80027d:	7e 07                	jle    800286 <libmain+0x2d>
		binaryname = argv[0];
  80027f:	8b 06                	mov    (%esi),%eax
  800281:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	e8 a3 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800290:	e8 0a 00 00 00       	call   80029f <exit>
}
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80029b:	5b                   	pop    %ebx
  80029c:	5e                   	pop    %esi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8002a5:	6a 00                	push   $0x0
  8002a7:	e8 12 0c 00 00       	call   800ebe <sys_env_destroy>
}
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002b6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b9:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002bf:	e8 3b 0c 00 00       	call   800eff <sys_getenvid>
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	ff 75 0c             	push   0xc(%ebp)
  8002ca:	ff 75 08             	push   0x8(%ebp)
  8002cd:	56                   	push   %esi
  8002ce:	50                   	push   %eax
  8002cf:	68 80 21 80 00       	push   $0x802180
  8002d4:	e8 b3 00 00 00       	call   80038c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d9:	83 c4 18             	add    $0x18,%esp
  8002dc:	53                   	push   %ebx
  8002dd:	ff 75 10             	push   0x10(%ebp)
  8002e0:	e8 56 00 00 00       	call   80033b <vcprintf>
	cprintf("\n");
  8002e5:	c7 04 24 66 21 80 00 	movl   $0x802166,(%esp)
  8002ec:	e8 9b 00 00 00       	call   80038c <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002f4:	cc                   	int3   
  8002f5:	eb fd                	jmp    8002f4 <_panic+0x43>

008002f7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800301:	8b 13                	mov    (%ebx),%edx
  800303:	8d 42 01             	lea    0x1(%edx),%eax
  800306:	89 03                	mov    %eax,(%ebx)
  800308:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80030b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80030f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800314:	74 09                	je     80031f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800316:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	68 ff 00 00 00       	push   $0xff
  800327:	8d 43 08             	lea    0x8(%ebx),%eax
  80032a:	50                   	push   %eax
  80032b:	e8 51 0b 00 00       	call   800e81 <sys_cputs>
		b->idx = 0;
  800330:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	eb db                	jmp    800316 <putch+0x1f>

0080033b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800344:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80034b:	00 00 00 
	b.cnt = 0;
  80034e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800355:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800358:	ff 75 0c             	push   0xc(%ebp)
  80035b:	ff 75 08             	push   0x8(%ebp)
  80035e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800364:	50                   	push   %eax
  800365:	68 f7 02 80 00       	push   $0x8002f7
  80036a:	e8 14 01 00 00       	call   800483 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036f:	83 c4 08             	add    $0x8,%esp
  800372:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800378:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	e8 fd 0a 00 00       	call   800e81 <sys_cputs>

	return b.cnt;
}
  800384:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 08             	push   0x8(%ebp)
  800399:	e8 9d ff ff ff       	call   80033b <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 1c             	sub    $0x1c,%esp
  8003a9:	89 c7                	mov    %eax,%edi
  8003ab:	89 d6                	mov    %edx,%esi
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	89 d1                	mov    %edx,%ecx
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003d2:	72 3e                	jb     800412 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	ff 75 18             	push   0x18(%ebp)
  8003da:	83 eb 01             	sub    $0x1,%ebx
  8003dd:	53                   	push   %ebx
  8003de:	50                   	push   %eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 e4             	push   -0x1c(%ebp)
  8003e5:	ff 75 e0             	push   -0x20(%ebp)
  8003e8:	ff 75 dc             	push   -0x24(%ebp)
  8003eb:	ff 75 d8             	push   -0x28(%ebp)
  8003ee:	e8 cd 1a 00 00       	call   801ec0 <__udivdi3>
  8003f3:	83 c4 18             	add    $0x18,%esp
  8003f6:	52                   	push   %edx
  8003f7:	50                   	push   %eax
  8003f8:	89 f2                	mov    %esi,%edx
  8003fa:	89 f8                	mov    %edi,%eax
  8003fc:	e8 9f ff ff ff       	call   8003a0 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 13                	jmp    800419 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	56                   	push   %esi
  80040a:	ff 75 18             	push   0x18(%ebp)
  80040d:	ff d7                	call   *%edi
  80040f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800412:	83 eb 01             	sub    $0x1,%ebx
  800415:	85 db                	test   %ebx,%ebx
  800417:	7f ed                	jg     800406 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	56                   	push   %esi
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	ff 75 e4             	push   -0x1c(%ebp)
  800423:	ff 75 e0             	push   -0x20(%ebp)
  800426:	ff 75 dc             	push   -0x24(%ebp)
  800429:	ff 75 d8             	push   -0x28(%ebp)
  80042c:	e8 af 1b 00 00       	call   801fe0 <__umoddi3>
  800431:	83 c4 14             	add    $0x14,%esp
  800434:	0f be 80 a3 21 80 00 	movsbl 0x8021a3(%eax),%eax
  80043b:	50                   	push   %eax
  80043c:	ff d7                	call   *%edi
}
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80044f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800453:	8b 10                	mov    (%eax),%edx
  800455:	3b 50 04             	cmp    0x4(%eax),%edx
  800458:	73 0a                	jae    800464 <sprintputch+0x1b>
		*b->buf++ = ch;
  80045a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80045d:	89 08                	mov    %ecx,(%eax)
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	88 02                	mov    %al,(%edx)
}
  800464:	5d                   	pop    %ebp
  800465:	c3                   	ret    

00800466 <printfmt>:
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80046c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80046f:	50                   	push   %eax
  800470:	ff 75 10             	push   0x10(%ebp)
  800473:	ff 75 0c             	push   0xc(%ebp)
  800476:	ff 75 08             	push   0x8(%ebp)
  800479:	e8 05 00 00 00       	call   800483 <vprintfmt>
}
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <vprintfmt>:
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	57                   	push   %edi
  800487:	56                   	push   %esi
  800488:	53                   	push   %ebx
  800489:	83 ec 3c             	sub    $0x3c,%esp
  80048c:	8b 75 08             	mov    0x8(%ebp),%esi
  80048f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800492:	8b 7d 10             	mov    0x10(%ebp),%edi
  800495:	eb 0a                	jmp    8004a1 <vprintfmt+0x1e>
			putch(ch, putdat);
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	53                   	push   %ebx
  80049b:	50                   	push   %eax
  80049c:	ff d6                	call   *%esi
  80049e:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a1:	83 c7 01             	add    $0x1,%edi
  8004a4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a8:	83 f8 25             	cmp    $0x25,%eax
  8004ab:	74 0c                	je     8004b9 <vprintfmt+0x36>
			if (ch == '\0')
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	75 e6                	jne    800497 <vprintfmt+0x14>
}
  8004b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b4:	5b                   	pop    %ebx
  8004b5:	5e                   	pop    %esi
  8004b6:	5f                   	pop    %edi
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    
		padc = ' ';
  8004b9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004bd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8004cb:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8d 47 01             	lea    0x1(%edi),%eax
  8004da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004dd:	0f b6 17             	movzbl (%edi),%edx
  8004e0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004e3:	3c 55                	cmp    $0x55,%al
  8004e5:	0f 87 a6 04 00 00    	ja     800991 <vprintfmt+0x50e>
  8004eb:	0f b6 c0             	movzbl %al,%eax
  8004ee:	ff 24 85 e0 22 80 00 	jmp    *0x8022e0(,%eax,4)
  8004f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8004f8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004fc:	eb d9                	jmp    8004d7 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800501:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800505:	eb d0                	jmp    8004d7 <vprintfmt+0x54>
  800507:	0f b6 d2             	movzbl %dl,%edx
  80050a:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800515:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800518:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80051c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80051f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800522:	83 f9 09             	cmp    $0x9,%ecx
  800525:	77 55                	ja     80057c <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800527:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80052a:	eb e9                	jmp    800515 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 40 04             	lea    0x4(%eax),%eax
  80053a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800540:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800544:	79 91                	jns    8004d7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800549:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80054c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800553:	eb 82                	jmp    8004d7 <vprintfmt+0x54>
  800555:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800558:	85 d2                	test   %edx,%edx
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	0f 49 c2             	cmovns %edx,%eax
  800562:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800568:	e9 6a ff ff ff       	jmp    8004d7 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800570:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800577:	e9 5b ff ff ff       	jmp    8004d7 <vprintfmt+0x54>
  80057c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800582:	eb bc                	jmp    800540 <vprintfmt+0xbd>
			lflag++;
  800584:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80058a:	e9 48 ff ff ff       	jmp    8004d7 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 78 04             	lea    0x4(%eax),%edi
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	ff 30                	push   (%eax)
  80059b:	ff d6                	call   *%esi
			break;
  80059d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005a0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005a3:	e9 88 03 00 00       	jmp    800930 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 78 04             	lea    0x4(%eax),%edi
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	f7 d8                	neg    %eax
  8005b4:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005b7:	83 f8 0f             	cmp    $0xf,%eax
  8005ba:	7f 23                	jg     8005df <vprintfmt+0x15c>
  8005bc:	8b 14 85 40 24 80 00 	mov    0x802440(,%eax,4),%edx
  8005c3:	85 d2                	test   %edx,%edx
  8005c5:	74 18                	je     8005df <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8005c7:	52                   	push   %edx
  8005c8:	68 81 25 80 00       	push   $0x802581
  8005cd:	53                   	push   %ebx
  8005ce:	56                   	push   %esi
  8005cf:	e8 92 fe ff ff       	call   800466 <printfmt>
  8005d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005d7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005da:	e9 51 03 00 00       	jmp    800930 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8005df:	50                   	push   %eax
  8005e0:	68 bb 21 80 00       	push   $0x8021bb
  8005e5:	53                   	push   %ebx
  8005e6:	56                   	push   %esi
  8005e7:	e8 7a fe ff ff       	call   800466 <printfmt>
  8005ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ef:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005f2:	e9 39 03 00 00       	jmp    800930 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	83 c0 04             	add    $0x4,%eax
  8005fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800605:	85 d2                	test   %edx,%edx
  800607:	b8 b4 21 80 00       	mov    $0x8021b4,%eax
  80060c:	0f 45 c2             	cmovne %edx,%eax
  80060f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800616:	7e 06                	jle    80061e <vprintfmt+0x19b>
  800618:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80061c:	75 0d                	jne    80062b <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800621:	89 c7                	mov    %eax,%edi
  800623:	03 45 d4             	add    -0x2c(%ebp),%eax
  800626:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800629:	eb 55                	jmp    800680 <vprintfmt+0x1fd>
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 e0             	push   -0x20(%ebp)
  800631:	ff 75 cc             	push   -0x34(%ebp)
  800634:	e8 e5 04 00 00       	call   800b1e <strnlen>
  800639:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80063c:	29 c2                	sub    %eax,%edx
  80063e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800646:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80064a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	eb 0f                	jmp    80065e <vprintfmt+0x1db>
					putch(padc, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	ff 75 d4             	push   -0x2c(%ebp)
  800656:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800658:	83 ef 01             	sub    $0x1,%edi
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	85 ff                	test   %edi,%edi
  800660:	7f ed                	jg     80064f <vprintfmt+0x1cc>
  800662:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800665:	85 d2                	test   %edx,%edx
  800667:	b8 00 00 00 00       	mov    $0x0,%eax
  80066c:	0f 49 c2             	cmovns %edx,%eax
  80066f:	29 c2                	sub    %eax,%edx
  800671:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800674:	eb a8                	jmp    80061e <vprintfmt+0x19b>
					putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	52                   	push   %edx
  80067b:	ff d6                	call   *%esi
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800683:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800685:	83 c7 01             	add    $0x1,%edi
  800688:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068c:	0f be d0             	movsbl %al,%edx
  80068f:	85 d2                	test   %edx,%edx
  800691:	74 4b                	je     8006de <vprintfmt+0x25b>
  800693:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800697:	78 06                	js     80069f <vprintfmt+0x21c>
  800699:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80069d:	78 1e                	js     8006bd <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80069f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a3:	74 d1                	je     800676 <vprintfmt+0x1f3>
  8006a5:	0f be c0             	movsbl %al,%eax
  8006a8:	83 e8 20             	sub    $0x20,%eax
  8006ab:	83 f8 5e             	cmp    $0x5e,%eax
  8006ae:	76 c6                	jbe    800676 <vprintfmt+0x1f3>
					putch('?', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 3f                	push   $0x3f
  8006b6:	ff d6                	call   *%esi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	eb c3                	jmp    800680 <vprintfmt+0x1fd>
  8006bd:	89 cf                	mov    %ecx,%edi
  8006bf:	eb 0e                	jmp    8006cf <vprintfmt+0x24c>
				putch(' ', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 20                	push   $0x20
  8006c7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006c9:	83 ef 01             	sub    $0x1,%edi
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	85 ff                	test   %edi,%edi
  8006d1:	7f ee                	jg     8006c1 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  8006d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d9:	e9 52 02 00 00       	jmp    800930 <vprintfmt+0x4ad>
  8006de:	89 cf                	mov    %ecx,%edi
  8006e0:	eb ed                	jmp    8006cf <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006f0:	85 d2                	test   %edx,%edx
  8006f2:	b8 b4 21 80 00       	mov    $0x8021b4,%eax
  8006f7:	0f 45 c2             	cmovne %edx,%eax
  8006fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800701:	7e 06                	jle    800709 <vprintfmt+0x286>
  800703:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800707:	75 0d                	jne    800716 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800709:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80070c:	89 c7                	mov    %eax,%edi
  80070e:	03 45 d4             	add    -0x2c(%ebp),%eax
  800711:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800714:	eb 55                	jmp    80076b <vprintfmt+0x2e8>
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 e0             	push   -0x20(%ebp)
  80071c:	ff 75 cc             	push   -0x34(%ebp)
  80071f:	e8 fa 03 00 00       	call   800b1e <strnlen>
  800724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800727:	29 c2                	sub    %eax,%edx
  800729:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800731:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800735:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	eb 0f                	jmp    800749 <vprintfmt+0x2c6>
					putch(padc, putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	ff 75 d4             	push   -0x2c(%ebp)
  800741:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800743:	83 ef 01             	sub    $0x1,%edi
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 ff                	test   %edi,%edi
  80074b:	7f ed                	jg     80073a <vprintfmt+0x2b7>
  80074d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800750:	85 d2                	test   %edx,%edx
  800752:	b8 00 00 00 00       	mov    $0x0,%eax
  800757:	0f 49 c2             	cmovns %edx,%eax
  80075a:	29 c2                	sub    %eax,%edx
  80075c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80075f:	eb a8                	jmp    800709 <vprintfmt+0x286>
					putch(ch, putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	52                   	push   %edx
  800766:	ff d6                	call   *%esi
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80076e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800770:	83 c7 01             	add    $0x1,%edi
  800773:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800777:	0f be d0             	movsbl %al,%edx
  80077a:	3c 3a                	cmp    $0x3a,%al
  80077c:	74 4b                	je     8007c9 <vprintfmt+0x346>
  80077e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800782:	78 06                	js     80078a <vprintfmt+0x307>
  800784:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800788:	78 1e                	js     8007a8 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80078a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80078e:	74 d1                	je     800761 <vprintfmt+0x2de>
  800790:	0f be c0             	movsbl %al,%eax
  800793:	83 e8 20             	sub    $0x20,%eax
  800796:	83 f8 5e             	cmp    $0x5e,%eax
  800799:	76 c6                	jbe    800761 <vprintfmt+0x2de>
					putch('?', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	6a 3f                	push   $0x3f
  8007a1:	ff d6                	call   *%esi
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	eb c3                	jmp    80076b <vprintfmt+0x2e8>
  8007a8:	89 cf                	mov    %ecx,%edi
  8007aa:	eb 0e                	jmp    8007ba <vprintfmt+0x337>
				putch(' ', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 20                	push   $0x20
  8007b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007b4:	83 ef 01             	sub    $0x1,%edi
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	85 ff                	test   %edi,%edi
  8007bc:	7f ee                	jg     8007ac <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  8007be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c4:	e9 67 01 00 00       	jmp    800930 <vprintfmt+0x4ad>
  8007c9:	89 cf                	mov    %ecx,%edi
  8007cb:	eb ed                	jmp    8007ba <vprintfmt+0x337>
	if (lflag >= 2)
  8007cd:	83 f9 01             	cmp    $0x1,%ecx
  8007d0:	7f 1b                	jg     8007ed <vprintfmt+0x36a>
	else if (lflag)
  8007d2:	85 c9                	test   %ecx,%ecx
  8007d4:	74 63                	je     800839 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007de:	99                   	cltd   
  8007df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007eb:	eb 17                	jmp    800804 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 08             	lea    0x8(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800804:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800807:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80080a:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80080f:	85 c9                	test   %ecx,%ecx
  800811:	0f 89 ff 00 00 00    	jns    800916 <vprintfmt+0x493>
				putch('-', putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	6a 2d                	push   $0x2d
  80081d:	ff d6                	call   *%esi
				num = -(long long) num;
  80081f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800822:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800825:	f7 da                	neg    %edx
  800827:	83 d1 00             	adc    $0x0,%ecx
  80082a:	f7 d9                	neg    %ecx
  80082c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80082f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800834:	e9 dd 00 00 00       	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800841:	99                   	cltd   
  800842:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	eb b4                	jmp    800804 <vprintfmt+0x381>
	if (lflag >= 2)
  800850:	83 f9 01             	cmp    $0x1,%ecx
  800853:	7f 1e                	jg     800873 <vprintfmt+0x3f0>
	else if (lflag)
  800855:	85 c9                	test   %ecx,%ecx
  800857:	74 32                	je     80088b <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 10                	mov    (%eax),%edx
  80085e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800863:	8d 40 04             	lea    0x4(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800869:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80086e:	e9 a3 00 00 00       	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 10                	mov    (%eax),%edx
  800878:	8b 48 04             	mov    0x4(%eax),%ecx
  80087b:	8d 40 08             	lea    0x8(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800881:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800886:	e9 8b 00 00 00       	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	8b 10                	mov    (%eax),%edx
  800890:	b9 00 00 00 00       	mov    $0x0,%ecx
  800895:	8d 40 04             	lea    0x4(%eax),%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80089b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  8008a0:	eb 74                	jmp    800916 <vprintfmt+0x493>
	if (lflag >= 2)
  8008a2:	83 f9 01             	cmp    $0x1,%ecx
  8008a5:	7f 1b                	jg     8008c2 <vprintfmt+0x43f>
	else if (lflag)
  8008a7:	85 c9                	test   %ecx,%ecx
  8008a9:	74 2c                	je     8008d7 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8b 10                	mov    (%eax),%edx
  8008b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008bb:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  8008c0:	eb 54                	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 10                	mov    (%eax),%edx
  8008c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8008ca:	8d 40 08             	lea    0x8(%eax),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008d0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8008d5:	eb 3f                	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8b 10                	mov    (%eax),%edx
  8008dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008e1:	8d 40 04             	lea    0x4(%eax),%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e7:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8008ec:	eb 28                	jmp    800916 <vprintfmt+0x493>
			putch('0', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	53                   	push   %ebx
  8008f2:	6a 30                	push   $0x30
  8008f4:	ff d6                	call   *%esi
			putch('x', putdat);
  8008f6:	83 c4 08             	add    $0x8,%esp
  8008f9:	53                   	push   %ebx
  8008fa:	6a 78                	push   $0x78
  8008fc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 10                	mov    (%eax),%edx
  800903:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800908:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80090b:	8d 40 04             	lea    0x4(%eax),%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800911:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800916:	83 ec 0c             	sub    $0xc,%esp
  800919:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80091d:	50                   	push   %eax
  80091e:	ff 75 d4             	push   -0x2c(%ebp)
  800921:	57                   	push   %edi
  800922:	51                   	push   %ecx
  800923:	52                   	push   %edx
  800924:	89 da                	mov    %ebx,%edx
  800926:	89 f0                	mov    %esi,%eax
  800928:	e8 73 fa ff ff       	call   8003a0 <printnum>
			break;
  80092d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800930:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	e9 69 fb ff ff       	jmp    8004a1 <vprintfmt+0x1e>
	if (lflag >= 2)
  800938:	83 f9 01             	cmp    $0x1,%ecx
  80093b:	7f 1b                	jg     800958 <vprintfmt+0x4d5>
	else if (lflag)
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	74 2c                	je     80096d <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8b 10                	mov    (%eax),%edx
  800946:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800951:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800956:	eb be                	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 48 04             	mov    0x4(%eax),%ecx
  800960:	8d 40 08             	lea    0x8(%eax),%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800966:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80096b:	eb a9                	jmp    800916 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8b 10                	mov    (%eax),%edx
  800972:	b9 00 00 00 00       	mov    $0x0,%ecx
  800977:	8d 40 04             	lea    0x4(%eax),%eax
  80097a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097d:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800982:	eb 92                	jmp    800916 <vprintfmt+0x493>
			putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 25                	push   $0x25
  80098a:	ff d6                	call   *%esi
			break;
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	eb 9f                	jmp    800930 <vprintfmt+0x4ad>
			putch('%', putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	53                   	push   %ebx
  800995:	6a 25                	push   $0x25
  800997:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800999:	83 c4 10             	add    $0x10,%esp
  80099c:	89 f8                	mov    %edi,%eax
  80099e:	eb 03                	jmp    8009a3 <vprintfmt+0x520>
  8009a0:	83 e8 01             	sub    $0x1,%eax
  8009a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a7:	75 f7                	jne    8009a0 <vprintfmt+0x51d>
  8009a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009ac:	eb 82                	jmp    800930 <vprintfmt+0x4ad>

008009ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 18             	sub    $0x18,%esp
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	74 26                	je     8009f5 <vsnprintf+0x47>
  8009cf:	85 d2                	test   %edx,%edx
  8009d1:	7e 22                	jle    8009f5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d3:	ff 75 14             	push   0x14(%ebp)
  8009d6:	ff 75 10             	push   0x10(%ebp)
  8009d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	68 49 04 80 00       	push   $0x800449
  8009e2:	e8 9c fa ff ff       	call   800483 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    
		return -E_INVAL;
  8009f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fa:	eb f7                	jmp    8009f3 <vsnprintf+0x45>

008009fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a02:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a05:	50                   	push   %eax
  800a06:	ff 75 10             	push   0x10(%ebp)
  800a09:	ff 75 0c             	push   0xc(%ebp)
  800a0c:	ff 75 08             	push   0x8(%ebp)
  800a0f:	e8 9a ff ff ff       	call   8009ae <vsnprintf>
	va_end(ap);

	return rc;
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	57                   	push   %edi
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	83 ec 0c             	sub    $0xc,%esp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a22:	85 c0                	test   %eax,%eax
  800a24:	74 13                	je     800a39 <readline+0x23>
		fprintf(1, "%s", prompt);
  800a26:	83 ec 04             	sub    $0x4,%esp
  800a29:	50                   	push   %eax
  800a2a:	68 81 25 80 00       	push   $0x802581
  800a2f:	6a 01                	push   $0x1
  800a31:	e8 ff 0f 00 00       	call   801a35 <fprintf>
  800a36:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800a39:	83 ec 0c             	sub    $0xc,%esp
  800a3c:	6a 00                	push   $0x0
  800a3e:	e8 98 f7 ff ff       	call   8001db <iscons>
  800a43:	89 c7                	mov    %eax,%edi
  800a45:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800a48:	be 00 00 00 00       	mov    $0x0,%esi
  800a4d:	eb 4b                	jmp    800a9a <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800a54:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a57:	75 08                	jne    800a61 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a5c:	5b                   	pop    %ebx
  800a5d:	5e                   	pop    %esi
  800a5e:	5f                   	pop    %edi
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	53                   	push   %ebx
  800a65:	68 9f 24 80 00       	push   $0x80249f
  800a6a:	e8 1d f9 ff ff       	call   80038c <cprintf>
  800a6f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	eb e0                	jmp    800a59 <readline+0x43>
			if (echoing)
  800a79:	85 ff                	test   %edi,%edi
  800a7b:	75 05                	jne    800a82 <readline+0x6c>
			i--;
  800a7d:	83 ee 01             	sub    $0x1,%esi
  800a80:	eb 18                	jmp    800a9a <readline+0x84>
				cputchar('\b');
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 08                	push   $0x8
  800a87:	e8 0a f7 ff ff       	call   800196 <cputchar>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb ec                	jmp    800a7d <readline+0x67>
			buf[i++] = c;
  800a91:	88 9e 20 40 80 00    	mov    %bl,0x804020(%esi)
  800a97:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800a9a:	e8 13 f7 ff ff       	call   8001b2 <getchar>
  800a9f:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800aa1:	85 c0                	test   %eax,%eax
  800aa3:	78 aa                	js     800a4f <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800aa5:	83 f8 08             	cmp    $0x8,%eax
  800aa8:	0f 94 c0             	sete   %al
  800aab:	83 fb 7f             	cmp    $0x7f,%ebx
  800aae:	0f 94 c2             	sete   %dl
  800ab1:	08 d0                	or     %dl,%al
  800ab3:	74 04                	je     800ab9 <readline+0xa3>
  800ab5:	85 f6                	test   %esi,%esi
  800ab7:	7f c0                	jg     800a79 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ab9:	83 fb 1f             	cmp    $0x1f,%ebx
  800abc:	7e 1a                	jle    800ad8 <readline+0xc2>
  800abe:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800ac4:	7f 12                	jg     800ad8 <readline+0xc2>
			if (echoing)
  800ac6:	85 ff                	test   %edi,%edi
  800ac8:	74 c7                	je     800a91 <readline+0x7b>
				cputchar(c);
  800aca:	83 ec 0c             	sub    $0xc,%esp
  800acd:	53                   	push   %ebx
  800ace:	e8 c3 f6 ff ff       	call   800196 <cputchar>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	eb b9                	jmp    800a91 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800ad8:	83 fb 0a             	cmp    $0xa,%ebx
  800adb:	74 05                	je     800ae2 <readline+0xcc>
  800add:	83 fb 0d             	cmp    $0xd,%ebx
  800ae0:	75 b8                	jne    800a9a <readline+0x84>
			if (echoing)
  800ae2:	85 ff                	test   %edi,%edi
  800ae4:	75 11                	jne    800af7 <readline+0xe1>
			buf[i] = 0;
  800ae6:	c6 86 20 40 80 00 00 	movb   $0x0,0x804020(%esi)
			return buf;
  800aed:	b8 20 40 80 00       	mov    $0x804020,%eax
  800af2:	e9 62 ff ff ff       	jmp    800a59 <readline+0x43>
				cputchar('\n');
  800af7:	83 ec 0c             	sub    $0xc,%esp
  800afa:	6a 0a                	push   $0xa
  800afc:	e8 95 f6 ff ff       	call   800196 <cputchar>
  800b01:	83 c4 10             	add    $0x10,%esp
  800b04:	eb e0                	jmp    800ae6 <readline+0xd0>

00800b06 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	eb 03                	jmp    800b16 <strlen+0x10>
		n++;
  800b13:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800b16:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b1a:	75 f7                	jne    800b13 <strlen+0xd>
	return n;
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	eb 03                	jmp    800b31 <strnlen+0x13>
		n++;
  800b2e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b31:	39 d0                	cmp    %edx,%eax
  800b33:	74 08                	je     800b3d <strnlen+0x1f>
  800b35:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b39:	75 f3                	jne    800b2e <strnlen+0x10>
  800b3b:	89 c2                	mov    %eax,%edx
	return n;
}
  800b3d:	89 d0                	mov    %edx,%eax
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	53                   	push   %ebx
  800b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b54:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	84 d2                	test   %dl,%dl
  800b5c:	75 f2                	jne    800b50 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b5e:	89 c8                	mov    %ecx,%eax
  800b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	83 ec 10             	sub    $0x10,%esp
  800b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b6f:	53                   	push   %ebx
  800b70:	e8 91 ff ff ff       	call   800b06 <strlen>
  800b75:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b78:	ff 75 0c             	push   0xc(%ebp)
  800b7b:	01 d8                	add    %ebx,%eax
  800b7d:	50                   	push   %eax
  800b7e:	e8 be ff ff ff       	call   800b41 <strcpy>
	return dst;
}
  800b83:	89 d8                	mov    %ebx,%eax
  800b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	8b 75 08             	mov    0x8(%ebp),%esi
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b95:	89 f3                	mov    %esi,%ebx
  800b97:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9a:	89 f0                	mov    %esi,%eax
  800b9c:	eb 0f                	jmp    800bad <strncpy+0x23>
		*dst++ = *src;
  800b9e:	83 c0 01             	add    $0x1,%eax
  800ba1:	0f b6 0a             	movzbl (%edx),%ecx
  800ba4:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ba7:	80 f9 01             	cmp    $0x1,%cl
  800baa:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800bad:	39 d8                	cmp    %ebx,%eax
  800baf:	75 ed                	jne    800b9e <strncpy+0x14>
	}
	return ret;
}
  800bb1:	89 f0                	mov    %esi,%eax
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
  800bbc:	8b 75 08             	mov    0x8(%ebp),%esi
  800bbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc2:	8b 55 10             	mov    0x10(%ebp),%edx
  800bc5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bc7:	85 d2                	test   %edx,%edx
  800bc9:	74 21                	je     800bec <strlcpy+0x35>
  800bcb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bcf:	89 f2                	mov    %esi,%edx
  800bd1:	eb 09                	jmp    800bdc <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bd3:	83 c1 01             	add    $0x1,%ecx
  800bd6:	83 c2 01             	add    $0x1,%edx
  800bd9:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800bdc:	39 c2                	cmp    %eax,%edx
  800bde:	74 09                	je     800be9 <strlcpy+0x32>
  800be0:	0f b6 19             	movzbl (%ecx),%ebx
  800be3:	84 db                	test   %bl,%bl
  800be5:	75 ec                	jne    800bd3 <strlcpy+0x1c>
  800be7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800be9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bec:	29 f0                	sub    %esi,%eax
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bfb:	eb 06                	jmp    800c03 <strcmp+0x11>
		p++, q++;
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c03:	0f b6 01             	movzbl (%ecx),%eax
  800c06:	84 c0                	test   %al,%al
  800c08:	74 04                	je     800c0e <strcmp+0x1c>
  800c0a:	3a 02                	cmp    (%edx),%al
  800c0c:	74 ef                	je     800bfd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0e:	0f b6 c0             	movzbl %al,%eax
  800c11:	0f b6 12             	movzbl (%edx),%edx
  800c14:	29 d0                	sub    %edx,%eax
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	53                   	push   %ebx
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	89 c3                	mov    %eax,%ebx
  800c24:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c27:	eb 06                	jmp    800c2f <strncmp+0x17>
		n--, p++, q++;
  800c29:	83 c0 01             	add    $0x1,%eax
  800c2c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c2f:	39 d8                	cmp    %ebx,%eax
  800c31:	74 18                	je     800c4b <strncmp+0x33>
  800c33:	0f b6 08             	movzbl (%eax),%ecx
  800c36:	84 c9                	test   %cl,%cl
  800c38:	74 04                	je     800c3e <strncmp+0x26>
  800c3a:	3a 0a                	cmp    (%edx),%cl
  800c3c:	74 eb                	je     800c29 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3e:	0f b6 00             	movzbl (%eax),%eax
  800c41:	0f b6 12             	movzbl (%edx),%edx
  800c44:	29 d0                	sub    %edx,%eax
}
  800c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    
		return 0;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	eb f4                	jmp    800c46 <strncmp+0x2e>

00800c52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c5c:	eb 03                	jmp    800c61 <strchr+0xf>
  800c5e:	83 c0 01             	add    $0x1,%eax
  800c61:	0f b6 10             	movzbl (%eax),%edx
  800c64:	84 d2                	test   %dl,%dl
  800c66:	74 06                	je     800c6e <strchr+0x1c>
		if (*s == c)
  800c68:	38 ca                	cmp    %cl,%dl
  800c6a:	75 f2                	jne    800c5e <strchr+0xc>
  800c6c:	eb 05                	jmp    800c73 <strchr+0x21>
			return (char *) s;
	return 0;
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c82:	38 ca                	cmp    %cl,%dl
  800c84:	74 09                	je     800c8f <strfind+0x1a>
  800c86:	84 d2                	test   %dl,%dl
  800c88:	74 05                	je     800c8f <strfind+0x1a>
	for (; *s; s++)
  800c8a:	83 c0 01             	add    $0x1,%eax
  800c8d:	eb f0                	jmp    800c7f <strfind+0xa>
			break;
	return (char *) s;
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c9d:	85 c9                	test   %ecx,%ecx
  800c9f:	74 2f                	je     800cd0 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ca1:	89 f8                	mov    %edi,%eax
  800ca3:	09 c8                	or     %ecx,%eax
  800ca5:	a8 03                	test   $0x3,%al
  800ca7:	75 21                	jne    800cca <memset+0x39>
		c &= 0xFF;
  800ca9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cad:	89 d0                	mov    %edx,%eax
  800caf:	c1 e0 08             	shl    $0x8,%eax
  800cb2:	89 d3                	mov    %edx,%ebx
  800cb4:	c1 e3 18             	shl    $0x18,%ebx
  800cb7:	89 d6                	mov    %edx,%esi
  800cb9:	c1 e6 10             	shl    $0x10,%esi
  800cbc:	09 f3                	or     %esi,%ebx
  800cbe:	09 da                	or     %ebx,%edx
  800cc0:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cc2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cc5:	fc                   	cld    
  800cc6:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc8:	eb 06                	jmp    800cd0 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	fc                   	cld    
  800cce:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cd0:	89 f8                	mov    %edi,%eax
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce5:	39 c6                	cmp    %eax,%esi
  800ce7:	73 32                	jae    800d1b <memmove+0x44>
  800ce9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cec:	39 c2                	cmp    %eax,%edx
  800cee:	76 2b                	jbe    800d1b <memmove+0x44>
		s += n;
		d += n;
  800cf0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf3:	89 d6                	mov    %edx,%esi
  800cf5:	09 fe                	or     %edi,%esi
  800cf7:	09 ce                	or     %ecx,%esi
  800cf9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cff:	75 0e                	jne    800d0f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d01:	83 ef 04             	sub    $0x4,%edi
  800d04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d0a:	fd                   	std    
  800d0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d0d:	eb 09                	jmp    800d18 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0f:	83 ef 01             	sub    $0x1,%edi
  800d12:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d15:	fd                   	std    
  800d16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d18:	fc                   	cld    
  800d19:	eb 1a                	jmp    800d35 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d1b:	89 f2                	mov    %esi,%edx
  800d1d:	09 c2                	or     %eax,%edx
  800d1f:	09 ca                	or     %ecx,%edx
  800d21:	f6 c2 03             	test   $0x3,%dl
  800d24:	75 0a                	jne    800d30 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d29:	89 c7                	mov    %eax,%edi
  800d2b:	fc                   	cld    
  800d2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2e:	eb 05                	jmp    800d35 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d30:	89 c7                	mov    %eax,%edi
  800d32:	fc                   	cld    
  800d33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3f:	ff 75 10             	push   0x10(%ebp)
  800d42:	ff 75 0c             	push   0xc(%ebp)
  800d45:	ff 75 08             	push   0x8(%ebp)
  800d48:	e8 8a ff ff ff       	call   800cd7 <memmove>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5a:	89 c6                	mov    %eax,%esi
  800d5c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d5f:	eb 06                	jmp    800d67 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d61:	83 c0 01             	add    $0x1,%eax
  800d64:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d67:	39 f0                	cmp    %esi,%eax
  800d69:	74 14                	je     800d7f <memcmp+0x30>
		if (*s1 != *s2)
  800d6b:	0f b6 08             	movzbl (%eax),%ecx
  800d6e:	0f b6 1a             	movzbl (%edx),%ebx
  800d71:	38 d9                	cmp    %bl,%cl
  800d73:	74 ec                	je     800d61 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d75:	0f b6 c1             	movzbl %cl,%eax
  800d78:	0f b6 db             	movzbl %bl,%ebx
  800d7b:	29 d8                	sub    %ebx,%eax
  800d7d:	eb 05                	jmp    800d84 <memcmp+0x35>
	}

	return 0;
  800d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d91:	89 c2                	mov    %eax,%edx
  800d93:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d96:	eb 03                	jmp    800d9b <memfind+0x13>
  800d98:	83 c0 01             	add    $0x1,%eax
  800d9b:	39 d0                	cmp    %edx,%eax
  800d9d:	73 04                	jae    800da3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d9f:	38 08                	cmp    %cl,(%eax)
  800da1:	75 f5                	jne    800d98 <memfind+0x10>
			break;
	return (void *) s;
}
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db1:	eb 03                	jmp    800db6 <strtol+0x11>
		s++;
  800db3:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800db6:	0f b6 02             	movzbl (%edx),%eax
  800db9:	3c 20                	cmp    $0x20,%al
  800dbb:	74 f6                	je     800db3 <strtol+0xe>
  800dbd:	3c 09                	cmp    $0x9,%al
  800dbf:	74 f2                	je     800db3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dc1:	3c 2b                	cmp    $0x2b,%al
  800dc3:	74 2a                	je     800def <strtol+0x4a>
	int neg = 0;
  800dc5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dca:	3c 2d                	cmp    $0x2d,%al
  800dcc:	74 2b                	je     800df9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dce:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dd4:	75 0f                	jne    800de5 <strtol+0x40>
  800dd6:	80 3a 30             	cmpb   $0x30,(%edx)
  800dd9:	74 28                	je     800e03 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ddb:	85 db                	test   %ebx,%ebx
  800ddd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de2:	0f 44 d8             	cmove  %eax,%ebx
  800de5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dea:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ded:	eb 46                	jmp    800e35 <strtol+0x90>
		s++;
  800def:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800df2:	bf 00 00 00 00       	mov    $0x0,%edi
  800df7:	eb d5                	jmp    800dce <strtol+0x29>
		s++, neg = 1;
  800df9:	83 c2 01             	add    $0x1,%edx
  800dfc:	bf 01 00 00 00       	mov    $0x1,%edi
  800e01:	eb cb                	jmp    800dce <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e03:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e07:	74 0e                	je     800e17 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e09:	85 db                	test   %ebx,%ebx
  800e0b:	75 d8                	jne    800de5 <strtol+0x40>
		s++, base = 8;
  800e0d:	83 c2 01             	add    $0x1,%edx
  800e10:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e15:	eb ce                	jmp    800de5 <strtol+0x40>
		s += 2, base = 16;
  800e17:	83 c2 02             	add    $0x2,%edx
  800e1a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e1f:	eb c4                	jmp    800de5 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e21:	0f be c0             	movsbl %al,%eax
  800e24:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e27:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2a:	7d 3a                	jge    800e66 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e2c:	83 c2 01             	add    $0x1,%edx
  800e2f:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800e33:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800e35:	0f b6 02             	movzbl (%edx),%eax
  800e38:	8d 70 d0             	lea    -0x30(%eax),%esi
  800e3b:	89 f3                	mov    %esi,%ebx
  800e3d:	80 fb 09             	cmp    $0x9,%bl
  800e40:	76 df                	jbe    800e21 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800e42:	8d 70 9f             	lea    -0x61(%eax),%esi
  800e45:	89 f3                	mov    %esi,%ebx
  800e47:	80 fb 19             	cmp    $0x19,%bl
  800e4a:	77 08                	ja     800e54 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e4c:	0f be c0             	movsbl %al,%eax
  800e4f:	83 e8 57             	sub    $0x57,%eax
  800e52:	eb d3                	jmp    800e27 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e54:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e57:	89 f3                	mov    %esi,%ebx
  800e59:	80 fb 19             	cmp    $0x19,%bl
  800e5c:	77 08                	ja     800e66 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e5e:	0f be c0             	movsbl %al,%eax
  800e61:	83 e8 37             	sub    $0x37,%eax
  800e64:	eb c1                	jmp    800e27 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6a:	74 05                	je     800e71 <strtol+0xcc>
		*endptr = (char *) s;
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e71:	89 c8                	mov    %ecx,%eax
  800e73:	f7 d8                	neg    %eax
  800e75:	85 ff                	test   %edi,%edi
  800e77:	0f 45 c8             	cmovne %eax,%ecx
}
  800e7a:	89 c8                	mov    %ecx,%eax
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	89 c3                	mov    %eax,%ebx
  800e94:	89 c7                	mov    %eax,%edi
  800e96:	89 c6                	mov    %eax,%esi
  800e98:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  800eaf:	89 d1                	mov    %edx,%ecx
  800eb1:	89 d3                	mov    %edx,%ebx
  800eb3:	89 d7                	mov    %edx,%edi
  800eb5:	89 d6                	mov    %edx,%esi
  800eb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	b8 03 00 00 00       	mov    $0x3,%eax
  800ed4:	89 cb                	mov    %ecx,%ebx
  800ed6:	89 cf                	mov    %ecx,%edi
  800ed8:	89 ce                	mov    %ecx,%esi
  800eda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7f 08                	jg     800ee8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee8:	83 ec 0c             	sub    $0xc,%esp
  800eeb:	50                   	push   %eax
  800eec:	6a 03                	push   $0x3
  800eee:	68 af 24 80 00       	push   $0x8024af
  800ef3:	6a 23                	push   $0x23
  800ef5:	68 cc 24 80 00       	push   $0x8024cc
  800efa:	e8 b2 f3 ff ff       	call   8002b1 <_panic>

00800eff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f05:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0a:	b8 02 00 00 00       	mov    $0x2,%eax
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 d3                	mov    %edx,%ebx
  800f13:	89 d7                	mov    %edx,%edi
  800f15:	89 d6                	mov    %edx,%esi
  800f17:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <sys_yield>:

void
sys_yield(void)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
  800f29:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f2e:	89 d1                	mov    %edx,%ecx
  800f30:	89 d3                	mov    %edx,%ebx
  800f32:	89 d7                	mov    %edx,%edi
  800f34:	89 d6                	mov    %edx,%esi
  800f36:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f46:	be 00 00 00 00       	mov    $0x0,%esi
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	b8 04 00 00 00       	mov    $0x4,%eax
  800f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f59:	89 f7                	mov    %esi,%edi
  800f5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7f 08                	jg     800f69 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 04                	push   $0x4
  800f6f:	68 af 24 80 00       	push   $0x8024af
  800f74:	6a 23                	push   $0x23
  800f76:	68 cc 24 80 00       	push   $0x8024cc
  800f7b:	e8 31 f3 ff ff       	call   8002b1 <_panic>

00800f80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	57                   	push   %edi
  800f84:	56                   	push   %esi
  800f85:	53                   	push   %ebx
  800f86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9a:	8b 75 18             	mov    0x18(%ebp),%esi
  800f9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	7f 08                	jg     800fab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fab:	83 ec 0c             	sub    $0xc,%esp
  800fae:	50                   	push   %eax
  800faf:	6a 05                	push   $0x5
  800fb1:	68 af 24 80 00       	push   $0x8024af
  800fb6:	6a 23                	push   $0x23
  800fb8:	68 cc 24 80 00       	push   $0x8024cc
  800fbd:	e8 ef f2 ff ff       	call   8002b1 <_panic>

00800fc2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800fdb:	89 df                	mov    %ebx,%edi
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7f 08                	jg     800fed <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	50                   	push   %eax
  800ff1:	6a 06                	push   $0x6
  800ff3:	68 af 24 80 00       	push   $0x8024af
  800ff8:	6a 23                	push   $0x23
  800ffa:	68 cc 24 80 00       	push   $0x8024cc
  800fff:	e8 ad f2 ff ff       	call   8002b1 <_panic>

00801004 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
  80100a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801018:	b8 08 00 00 00       	mov    $0x8,%eax
  80101d:	89 df                	mov    %ebx,%edi
  80101f:	89 de                	mov    %ebx,%esi
  801021:	cd 30                	int    $0x30
	if(check && ret > 0)
  801023:	85 c0                	test   %eax,%eax
  801025:	7f 08                	jg     80102f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801027:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	50                   	push   %eax
  801033:	6a 08                	push   $0x8
  801035:	68 af 24 80 00       	push   $0x8024af
  80103a:	6a 23                	push   $0x23
  80103c:	68 cc 24 80 00       	push   $0x8024cc
  801041:	e8 6b f2 ff ff       	call   8002b1 <_panic>

00801046 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 09 00 00 00       	mov    $0x9,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 09                	push   $0x9
  801077:	68 af 24 80 00       	push   $0x8024af
  80107c:	6a 23                	push   $0x23
  80107e:	68 cc 24 80 00       	push   $0x8024cc
  801083:	e8 29 f2 ff ff       	call   8002b1 <_panic>

00801088 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	57                   	push   %edi
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
  80108e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801091:	bb 00 00 00 00       	mov    $0x0,%ebx
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a1:	89 df                	mov    %ebx,%edi
  8010a3:	89 de                	mov    %ebx,%esi
  8010a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	7f 08                	jg     8010b3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	50                   	push   %eax
  8010b7:	6a 0a                	push   $0xa
  8010b9:	68 af 24 80 00       	push   $0x8024af
  8010be:	6a 23                	push   $0x23
  8010c0:	68 cc 24 80 00       	push   $0x8024cc
  8010c5:	e8 e7 f1 ff ff       	call   8002b1 <_panic>

008010ca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010db:	be 00 00 00 00       	mov    $0x0,%esi
  8010e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	b8 0d 00 00 00       	mov    $0xd,%eax
  801103:	89 cb                	mov    %ecx,%ebx
  801105:	89 cf                	mov    %ecx,%edi
  801107:	89 ce                	mov    %ecx,%esi
  801109:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7f 08                	jg     801117 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	50                   	push   %eax
  80111b:	6a 0d                	push   $0xd
  80111d:	68 af 24 80 00       	push   $0x8024af
  801122:	6a 23                	push   $0x23
  801124:	68 cc 24 80 00       	push   $0x8024cc
  801129:	e8 83 f1 ff ff       	call   8002b1 <_panic>

0080112e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	05 00 00 00 30       	add    $0x30000000,%eax
  801139:	c1 e8 0c             	shr    $0xc,%eax
}
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801149:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80114e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	c1 ea 16             	shr    $0x16,%edx
  801162:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801169:	f6 c2 01             	test   $0x1,%dl
  80116c:	74 29                	je     801197 <fd_alloc+0x42>
  80116e:	89 c2                	mov    %eax,%edx
  801170:	c1 ea 0c             	shr    $0xc,%edx
  801173:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 18                	je     801197 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80117f:	05 00 10 00 00       	add    $0x1000,%eax
  801184:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801189:	75 d2                	jne    80115d <fd_alloc+0x8>
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  801190:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801195:	eb 05                	jmp    80119c <fd_alloc+0x47>
			return 0;
  801197:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	89 02                	mov    %eax,(%edx)
}
  8011a1:	89 c8                	mov    %ecx,%eax
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ab:	83 f8 1f             	cmp    $0x1f,%eax
  8011ae:	77 30                	ja     8011e0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b0:	c1 e0 0c             	shl    $0xc,%eax
  8011b3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011be:	f6 c2 01             	test   $0x1,%dl
  8011c1:	74 24                	je     8011e7 <fd_lookup+0x42>
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	c1 ea 0c             	shr    $0xc,%edx
  8011c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cf:	f6 c2 01             	test   $0x1,%dl
  8011d2:	74 1a                	je     8011ee <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d7:	89 02                	mov    %eax,(%edx)
	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    
		return -E_INVAL;
  8011e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e5:	eb f7                	jmp    8011de <fd_lookup+0x39>
		return -E_INVAL;
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb f0                	jmp    8011de <fd_lookup+0x39>
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb e9                	jmp    8011de <fd_lookup+0x39>

008011f5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ff:	b8 58 25 80 00       	mov    $0x802558,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801204:	bb 20 30 80 00       	mov    $0x803020,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801209:	39 13                	cmp    %edx,(%ebx)
  80120b:	74 32                	je     80123f <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80120d:	83 c0 04             	add    $0x4,%eax
  801210:	8b 18                	mov    (%eax),%ebx
  801212:	85 db                	test   %ebx,%ebx
  801214:	75 f3                	jne    801209 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801216:	a1 00 40 80 00       	mov    0x804000,%eax
  80121b:	8b 40 48             	mov    0x48(%eax),%eax
  80121e:	83 ec 04             	sub    $0x4,%esp
  801221:	52                   	push   %edx
  801222:	50                   	push   %eax
  801223:	68 dc 24 80 00       	push   $0x8024dc
  801228:	e8 5f f1 ff ff       	call   80038c <cprintf>
	*dev = 0;
	return -E_INVAL;
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801235:	8b 55 0c             	mov    0xc(%ebp),%edx
  801238:	89 1a                	mov    %ebx,(%edx)
}
  80123a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    
			return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb ef                	jmp    801235 <dev_lookup+0x40>

00801246 <fd_close>:
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	57                   	push   %edi
  80124a:	56                   	push   %esi
  80124b:	53                   	push   %ebx
  80124c:	83 ec 24             	sub    $0x24,%esp
  80124f:	8b 75 08             	mov    0x8(%ebp),%esi
  801252:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801255:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801258:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801259:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80125f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801262:	50                   	push   %eax
  801263:	e8 3d ff ff ff       	call   8011a5 <fd_lookup>
  801268:	89 c3                	mov    %eax,%ebx
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 05                	js     801276 <fd_close+0x30>
	    || fd != fd2)
  801271:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801274:	74 16                	je     80128c <fd_close+0x46>
		return (must_exist ? r : 0);
  801276:	89 f8                	mov    %edi,%eax
  801278:	84 c0                	test   %al,%al
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
  80127f:	0f 44 d8             	cmove  %eax,%ebx
}
  801282:	89 d8                	mov    %ebx,%eax
  801284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801292:	50                   	push   %eax
  801293:	ff 36                	push   (%esi)
  801295:	e8 5b ff ff ff       	call   8011f5 <dev_lookup>
  80129a:	89 c3                	mov    %eax,%ebx
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 1a                	js     8012bd <fd_close+0x77>
		if (dev->dev_close)
  8012a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	74 0b                	je     8012bd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	56                   	push   %esi
  8012b6:	ff d0                	call   *%eax
  8012b8:	89 c3                	mov    %eax,%ebx
  8012ba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	56                   	push   %esi
  8012c1:	6a 00                	push   $0x0
  8012c3:	e8 fa fc ff ff       	call   800fc2 <sys_page_unmap>
	return r;
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	eb b5                	jmp    801282 <fd_close+0x3c>

008012cd <close>:

int
close(int fdnum)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d6:	50                   	push   %eax
  8012d7:	ff 75 08             	push   0x8(%ebp)
  8012da:	e8 c6 fe ff ff       	call   8011a5 <fd_lookup>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	79 02                	jns    8012e8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    
		return fd_close(fd, 1);
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	6a 01                	push   $0x1
  8012ed:	ff 75 f4             	push   -0xc(%ebp)
  8012f0:	e8 51 ff ff ff       	call   801246 <fd_close>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	eb ec                	jmp    8012e6 <close+0x19>

008012fa <close_all>:

void
close_all(void)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801301:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	53                   	push   %ebx
  80130a:	e8 be ff ff ff       	call   8012cd <close>
	for (i = 0; i < MAXFD; i++)
  80130f:	83 c3 01             	add    $0x1,%ebx
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	83 fb 20             	cmp    $0x20,%ebx
  801318:	75 ec                	jne    801306 <close_all+0xc>
}
  80131a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801328:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	ff 75 08             	push   0x8(%ebp)
  80132f:	e8 71 fe ff ff       	call   8011a5 <fd_lookup>
  801334:	89 c3                	mov    %eax,%ebx
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 7f                	js     8013bc <dup+0x9d>
		return r;
	close(newfdnum);
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	ff 75 0c             	push   0xc(%ebp)
  801343:	e8 85 ff ff ff       	call   8012cd <close>

	newfd = INDEX2FD(newfdnum);
  801348:	8b 75 0c             	mov    0xc(%ebp),%esi
  80134b:	c1 e6 0c             	shl    $0xc,%esi
  80134e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801357:	89 3c 24             	mov    %edi,(%esp)
  80135a:	e8 df fd ff ff       	call   80113e <fd2data>
  80135f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801361:	89 34 24             	mov    %esi,(%esp)
  801364:	e8 d5 fd ff ff       	call   80113e <fd2data>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80136f:	89 d8                	mov    %ebx,%eax
  801371:	c1 e8 16             	shr    $0x16,%eax
  801374:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137b:	a8 01                	test   $0x1,%al
  80137d:	74 11                	je     801390 <dup+0x71>
  80137f:	89 d8                	mov    %ebx,%eax
  801381:	c1 e8 0c             	shr    $0xc,%eax
  801384:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	75 36                	jne    8013c6 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801390:	89 f8                	mov    %edi,%eax
  801392:	c1 e8 0c             	shr    $0xc,%eax
  801395:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a4:	50                   	push   %eax
  8013a5:	56                   	push   %esi
  8013a6:	6a 00                	push   $0x0
  8013a8:	57                   	push   %edi
  8013a9:	6a 00                	push   $0x0
  8013ab:	e8 d0 fb ff ff       	call   800f80 <sys_page_map>
  8013b0:	89 c3                	mov    %eax,%ebx
  8013b2:	83 c4 20             	add    $0x20,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 33                	js     8013ec <dup+0xcd>
		goto err;

	return newfdnum;
  8013b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013bc:	89 d8                	mov    %ebx,%eax
  8013be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013cd:	83 ec 0c             	sub    $0xc,%esp
  8013d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d5:	50                   	push   %eax
  8013d6:	ff 75 d4             	push   -0x2c(%ebp)
  8013d9:	6a 00                	push   $0x0
  8013db:	53                   	push   %ebx
  8013dc:	6a 00                	push   $0x0
  8013de:	e8 9d fb ff ff       	call   800f80 <sys_page_map>
  8013e3:	89 c3                	mov    %eax,%ebx
  8013e5:	83 c4 20             	add    $0x20,%esp
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	79 a4                	jns    801390 <dup+0x71>
	sys_page_unmap(0, newfd);
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	56                   	push   %esi
  8013f0:	6a 00                	push   $0x0
  8013f2:	e8 cb fb ff ff       	call   800fc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	ff 75 d4             	push   -0x2c(%ebp)
  8013fd:	6a 00                	push   $0x0
  8013ff:	e8 be fb ff ff       	call   800fc2 <sys_page_unmap>
	return r;
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	eb b3                	jmp    8013bc <dup+0x9d>

00801409 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	83 ec 18             	sub    $0x18,%esp
  801411:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801414:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	56                   	push   %esi
  801419:	e8 87 fd ff ff       	call   8011a5 <fd_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 3c                	js     801461 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801425:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	ff 33                	push   (%ebx)
  801431:	e8 bf fd ff ff       	call   8011f5 <dev_lookup>
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	85 c0                	test   %eax,%eax
  80143b:	78 24                	js     801461 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80143d:	8b 43 08             	mov    0x8(%ebx),%eax
  801440:	83 e0 03             	and    $0x3,%eax
  801443:	83 f8 01             	cmp    $0x1,%eax
  801446:	74 20                	je     801468 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	8b 40 08             	mov    0x8(%eax),%eax
  80144e:	85 c0                	test   %eax,%eax
  801450:	74 37                	je     801489 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	ff 75 10             	push   0x10(%ebp)
  801458:	ff 75 0c             	push   0xc(%ebp)
  80145b:	53                   	push   %ebx
  80145c:	ff d0                	call   *%eax
  80145e:	83 c4 10             	add    $0x10,%esp
}
  801461:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801464:	5b                   	pop    %ebx
  801465:	5e                   	pop    %esi
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801468:	a1 00 40 80 00       	mov    0x804000,%eax
  80146d:	8b 40 48             	mov    0x48(%eax),%eax
  801470:	83 ec 04             	sub    $0x4,%esp
  801473:	56                   	push   %esi
  801474:	50                   	push   %eax
  801475:	68 1d 25 80 00       	push   $0x80251d
  80147a:	e8 0d ef ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801487:	eb d8                	jmp    801461 <read+0x58>
		return -E_NOT_SUPP;
  801489:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148e:	eb d1                	jmp    801461 <read+0x58>

00801490 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	57                   	push   %edi
  801494:	56                   	push   %esi
  801495:	53                   	push   %ebx
  801496:	83 ec 0c             	sub    $0xc,%esp
  801499:	8b 7d 08             	mov    0x8(%ebp),%edi
  80149c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80149f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a4:	eb 02                	jmp    8014a8 <readn+0x18>
  8014a6:	01 c3                	add    %eax,%ebx
  8014a8:	39 f3                	cmp    %esi,%ebx
  8014aa:	73 21                	jae    8014cd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	89 f0                	mov    %esi,%eax
  8014b1:	29 d8                	sub    %ebx,%eax
  8014b3:	50                   	push   %eax
  8014b4:	89 d8                	mov    %ebx,%eax
  8014b6:	03 45 0c             	add    0xc(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	57                   	push   %edi
  8014bb:	e8 49 ff ff ff       	call   801409 <read>
		if (m < 0)
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 04                	js     8014cb <readn+0x3b>
			return m;
		if (m == 0)
  8014c7:	75 dd                	jne    8014a6 <readn+0x16>
  8014c9:	eb 02                	jmp    8014cd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014cb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014cd:	89 d8                	mov    %ebx,%eax
  8014cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5f                   	pop    %edi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	56                   	push   %esi
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 18             	sub    $0x18,%esp
  8014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	53                   	push   %ebx
  8014e7:	e8 b9 fc ff ff       	call   8011a5 <fd_lookup>
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 37                	js     80152a <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 36                	push   (%esi)
  8014ff:	e8 f1 fc ff ff       	call   8011f5 <dev_lookup>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	78 1f                	js     80152a <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150b:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80150f:	74 20                	je     801531 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	8b 40 0c             	mov    0xc(%eax),%eax
  801517:	85 c0                	test   %eax,%eax
  801519:	74 37                	je     801552 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	ff 75 10             	push   0x10(%ebp)
  801521:	ff 75 0c             	push   0xc(%ebp)
  801524:	56                   	push   %esi
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
}
  80152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801531:	a1 00 40 80 00       	mov    0x804000,%eax
  801536:	8b 40 48             	mov    0x48(%eax),%eax
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	53                   	push   %ebx
  80153d:	50                   	push   %eax
  80153e:	68 39 25 80 00       	push   $0x802539
  801543:	e8 44 ee ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801550:	eb d8                	jmp    80152a <write+0x53>
		return -E_NOT_SUPP;
  801552:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801557:	eb d1                	jmp    80152a <write+0x53>

00801559 <seek>:

int
seek(int fdnum, off_t offset)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801562:	50                   	push   %eax
  801563:	ff 75 08             	push   0x8(%ebp)
  801566:	e8 3a fc ff ff       	call   8011a5 <fd_lookup>
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 0e                	js     801580 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801572:	8b 55 0c             	mov    0xc(%ebp),%edx
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	83 ec 18             	sub    $0x18,%esp
  80158a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	53                   	push   %ebx
  801592:	e8 0e fc ff ff       	call   8011a5 <fd_lookup>
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 34                	js     8015d2 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159e:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 36                	push   (%esi)
  8015aa:	e8 46 fc ff ff       	call   8011f5 <dev_lookup>
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 1c                	js     8015d2 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b6:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8015ba:	74 1d                	je     8015d9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	8b 40 18             	mov    0x18(%eax),%eax
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	74 34                	je     8015fa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	ff 75 0c             	push   0xc(%ebp)
  8015cc:	56                   	push   %esi
  8015cd:	ff d0                	call   *%eax
  8015cf:	83 c4 10             	add    $0x10,%esp
}
  8015d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015d9:	a1 00 40 80 00       	mov    0x804000,%eax
  8015de:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	53                   	push   %ebx
  8015e5:	50                   	push   %eax
  8015e6:	68 fc 24 80 00       	push   $0x8024fc
  8015eb:	e8 9c ed ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f8:	eb d8                	jmp    8015d2 <ftruncate+0x50>
		return -E_NOT_SUPP;
  8015fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ff:	eb d1                	jmp    8015d2 <ftruncate+0x50>

00801601 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
  801606:	83 ec 18             	sub    $0x18,%esp
  801609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160f:	50                   	push   %eax
  801610:	ff 75 08             	push   0x8(%ebp)
  801613:	e8 8d fb ff ff       	call   8011a5 <fd_lookup>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 49                	js     801668 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161f:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	ff 36                	push   (%esi)
  80162b:	e8 c5 fb ff ff       	call   8011f5 <dev_lookup>
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	85 c0                	test   %eax,%eax
  801635:	78 31                	js     801668 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80163e:	74 2f                	je     80166f <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801640:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801643:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80164a:	00 00 00 
	stat->st_isdir = 0;
  80164d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801654:	00 00 00 
	stat->st_dev = dev;
  801657:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	53                   	push   %ebx
  801661:	56                   	push   %esi
  801662:	ff 50 14             	call   *0x14(%eax)
  801665:	83 c4 10             	add    $0x10,%esp
}
  801668:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    
		return -E_NOT_SUPP;
  80166f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801674:	eb f2                	jmp    801668 <fstat+0x67>

00801676 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	6a 00                	push   $0x0
  801680:	ff 75 08             	push   0x8(%ebp)
  801683:	e8 22 02 00 00       	call   8018aa <open>
  801688:	89 c3                	mov    %eax,%ebx
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 1b                	js     8016ac <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	ff 75 0c             	push   0xc(%ebp)
  801697:	50                   	push   %eax
  801698:	e8 64 ff ff ff       	call   801601 <fstat>
  80169d:	89 c6                	mov    %eax,%esi
	close(fd);
  80169f:	89 1c 24             	mov    %ebx,(%esp)
  8016a2:	e8 26 fc ff ff       	call   8012cd <close>
	return r;
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 f3                	mov    %esi,%ebx
}
  8016ac:	89 d8                	mov    %ebx,%eax
  8016ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	89 c6                	mov    %eax,%esi
  8016bc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016be:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8016c5:	74 27                	je     8016ee <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c7:	6a 07                	push   $0x7
  8016c9:	68 00 50 80 00       	push   $0x805000
  8016ce:	56                   	push   %esi
  8016cf:	ff 35 00 60 80 00    	push   0x806000
  8016d5:	e8 21 07 00 00       	call   801dfb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016da:	83 c4 0c             	add    $0xc,%esp
  8016dd:	6a 00                	push   $0x0
  8016df:	53                   	push   %ebx
  8016e0:	6a 00                	push   $0x0
  8016e2:	e8 c5 06 00 00       	call   801dac <ipc_recv>
}
  8016e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ea:	5b                   	pop    %ebx
  8016eb:	5e                   	pop    %esi
  8016ec:	5d                   	pop    %ebp
  8016ed:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016ee:	83 ec 0c             	sub    $0xc,%esp
  8016f1:	6a 01                	push   $0x1
  8016f3:	e8 4f 07 00 00       	call   801e47 <ipc_find_env>
  8016f8:	a3 00 60 80 00       	mov    %eax,0x806000
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	eb c5                	jmp    8016c7 <fsipc+0x12>

00801702 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8b 40 0c             	mov    0xc(%eax),%eax
  80170e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801713:	8b 45 0c             	mov    0xc(%ebp),%eax
  801716:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80171b:	ba 00 00 00 00       	mov    $0x0,%edx
  801720:	b8 02 00 00 00       	mov    $0x2,%eax
  801725:	e8 8b ff ff ff       	call   8016b5 <fsipc>
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <devfile_flush>:
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8b 40 0c             	mov    0xc(%eax),%eax
  801738:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80173d:	ba 00 00 00 00       	mov    $0x0,%edx
  801742:	b8 06 00 00 00       	mov    $0x6,%eax
  801747:	e8 69 ff ff ff       	call   8016b5 <fsipc>
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <devfile_stat>:
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	53                   	push   %ebx
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8b 40 0c             	mov    0xc(%eax),%eax
  80175e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801763:	ba 00 00 00 00       	mov    $0x0,%edx
  801768:	b8 05 00 00 00       	mov    $0x5,%eax
  80176d:	e8 43 ff ff ff       	call   8016b5 <fsipc>
  801772:	85 c0                	test   %eax,%eax
  801774:	78 2c                	js     8017a2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	68 00 50 80 00       	push   $0x805000
  80177e:	53                   	push   %ebx
  80177f:	e8 bd f3 ff ff       	call   800b41 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801784:	a1 80 50 80 00       	mov    0x805080,%eax
  801789:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80178f:	a1 84 50 80 00       	mov    0x805084,%eax
  801794:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <devfile_write>:
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017bc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017c2:	53                   	push   %ebx
  8017c3:	ff 75 0c             	push   0xc(%ebp)
  8017c6:	68 08 50 80 00       	push   $0x805008
  8017cb:	e8 69 f5 ff ff       	call   800d39 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8017da:	e8 d6 fe ff ff       	call   8016b5 <fsipc>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 0b                	js     8017f1 <devfile_write+0x4a>
	assert(r <= n);
  8017e6:	39 d8                	cmp    %ebx,%eax
  8017e8:	77 0c                	ja     8017f6 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ef:	7f 1e                	jg     80180f <devfile_write+0x68>
}
  8017f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    
	assert(r <= n);
  8017f6:	68 68 25 80 00       	push   $0x802568
  8017fb:	68 6f 25 80 00       	push   $0x80256f
  801800:	68 97 00 00 00       	push   $0x97
  801805:	68 84 25 80 00       	push   $0x802584
  80180a:	e8 a2 ea ff ff       	call   8002b1 <_panic>
	assert(r <= PGSIZE);
  80180f:	68 8f 25 80 00       	push   $0x80258f
  801814:	68 6f 25 80 00       	push   $0x80256f
  801819:	68 98 00 00 00       	push   $0x98
  80181e:	68 84 25 80 00       	push   $0x802584
  801823:	e8 89 ea ff ff       	call   8002b1 <_panic>

00801828 <devfile_read>:
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	56                   	push   %esi
  80182c:	53                   	push   %ebx
  80182d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8b 40 0c             	mov    0xc(%eax),%eax
  801836:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80183b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 03 00 00 00       	mov    $0x3,%eax
  80184b:	e8 65 fe ff ff       	call   8016b5 <fsipc>
  801850:	89 c3                	mov    %eax,%ebx
  801852:	85 c0                	test   %eax,%eax
  801854:	78 1f                	js     801875 <devfile_read+0x4d>
	assert(r <= n);
  801856:	39 f0                	cmp    %esi,%eax
  801858:	77 24                	ja     80187e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80185a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80185f:	7f 33                	jg     801894 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	50                   	push   %eax
  801865:	68 00 50 80 00       	push   $0x805000
  80186a:	ff 75 0c             	push   0xc(%ebp)
  80186d:	e8 65 f4 ff ff       	call   800cd7 <memmove>
	return r;
  801872:	83 c4 10             	add    $0x10,%esp
}
  801875:	89 d8                	mov    %ebx,%eax
  801877:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    
	assert(r <= n);
  80187e:	68 68 25 80 00       	push   $0x802568
  801883:	68 6f 25 80 00       	push   $0x80256f
  801888:	6a 7c                	push   $0x7c
  80188a:	68 84 25 80 00       	push   $0x802584
  80188f:	e8 1d ea ff ff       	call   8002b1 <_panic>
	assert(r <= PGSIZE);
  801894:	68 8f 25 80 00       	push   $0x80258f
  801899:	68 6f 25 80 00       	push   $0x80256f
  80189e:	6a 7d                	push   $0x7d
  8018a0:	68 84 25 80 00       	push   $0x802584
  8018a5:	e8 07 ea ff ff       	call   8002b1 <_panic>

008018aa <open>:
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	83 ec 1c             	sub    $0x1c,%esp
  8018b2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018b5:	56                   	push   %esi
  8018b6:	e8 4b f2 ff ff       	call   800b06 <strlen>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c3:	7f 6c                	jg     801931 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	e8 84 f8 ff ff       	call   801155 <fd_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 3c                	js     801916 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	56                   	push   %esi
  8018de:	68 00 50 80 00       	push   $0x805000
  8018e3:	e8 59 f2 ff ff       	call   800b41 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f8:	e8 b8 fd ff ff       	call   8016b5 <fsipc>
  8018fd:	89 c3                	mov    %eax,%ebx
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	78 19                	js     80191f <open+0x75>
	return fd2num(fd);
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	ff 75 f4             	push   -0xc(%ebp)
  80190c:	e8 1d f8 ff ff       	call   80112e <fd2num>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
}
  801916:	89 d8                	mov    %ebx,%eax
  801918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5d                   	pop    %ebp
  80191e:	c3                   	ret    
		fd_close(fd, 0);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	6a 00                	push   $0x0
  801924:	ff 75 f4             	push   -0xc(%ebp)
  801927:	e8 1a f9 ff ff       	call   801246 <fd_close>
		return r;
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	eb e5                	jmp    801916 <open+0x6c>
		return -E_BAD_PATH;
  801931:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801936:	eb de                	jmp    801916 <open+0x6c>

00801938 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	b8 08 00 00 00       	mov    $0x8,%eax
  801948:	e8 68 fd ff ff       	call   8016b5 <fsipc>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80194f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801953:	7f 01                	jg     801956 <writebuf+0x7>
  801955:	c3                   	ret    
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	53                   	push   %ebx
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80195f:	ff 70 04             	push   0x4(%eax)
  801962:	8d 40 10             	lea    0x10(%eax),%eax
  801965:	50                   	push   %eax
  801966:	ff 33                	push   (%ebx)
  801968:	e8 6a fb ff ff       	call   8014d7 <write>
		if (result > 0)
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	7e 03                	jle    801977 <writebuf+0x28>
			b->result += result;
  801974:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801977:	39 43 04             	cmp    %eax,0x4(%ebx)
  80197a:	74 0d                	je     801989 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80197c:	85 c0                	test   %eax,%eax
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	0f 4f c2             	cmovg  %edx,%eax
  801986:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <putch>:

static void
putch(int ch, void *thunk)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	53                   	push   %ebx
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801998:	8b 53 04             	mov    0x4(%ebx),%edx
  80199b:	8d 42 01             	lea    0x1(%edx),%eax
  80199e:	89 43 04             	mov    %eax,0x4(%ebx)
  8019a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a4:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019a8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019ad:	74 05                	je     8019b4 <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  8019af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    
		writebuf(b);
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	e8 94 ff ff ff       	call   80194f <writebuf>
		b->idx = 0;
  8019bb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019c2:	eb eb                	jmp    8019af <putch+0x21>

008019c4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019d6:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019dd:	00 00 00 
	b.result = 0;
  8019e0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019e7:	00 00 00 
	b.error = 1;
  8019ea:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019f1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019f4:	ff 75 10             	push   0x10(%ebp)
  8019f7:	ff 75 0c             	push   0xc(%ebp)
  8019fa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a00:	50                   	push   %eax
  801a01:	68 8e 19 80 00       	push   $0x80198e
  801a06:	e8 78 ea ff ff       	call   800483 <vprintfmt>
	if (b.idx > 0)
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a15:	7f 11                	jg     801a28 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a17:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    
		writebuf(&b);
  801a28:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a2e:	e8 1c ff ff ff       	call   80194f <writebuf>
  801a33:	eb e2                	jmp    801a17 <vfprintf+0x53>

00801a35 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a3b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a3e:	50                   	push   %eax
  801a3f:	ff 75 0c             	push   0xc(%ebp)
  801a42:	ff 75 08             	push   0x8(%ebp)
  801a45:	e8 7a ff ff ff       	call   8019c4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <printf>:

int
printf(const char *fmt, ...)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a52:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a55:	50                   	push   %eax
  801a56:	ff 75 08             	push   0x8(%ebp)
  801a59:	6a 01                	push   $0x1
  801a5b:	e8 64 ff ff ff       	call   8019c4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	56                   	push   %esi
  801a66:	53                   	push   %ebx
  801a67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	ff 75 08             	push   0x8(%ebp)
  801a70:	e8 c9 f6 ff ff       	call   80113e <fd2data>
  801a75:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a77:	83 c4 08             	add    $0x8,%esp
  801a7a:	68 9b 25 80 00       	push   $0x80259b
  801a7f:	53                   	push   %ebx
  801a80:	e8 bc f0 ff ff       	call   800b41 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a85:	8b 46 04             	mov    0x4(%esi),%eax
  801a88:	2b 06                	sub    (%esi),%eax
  801a8a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a90:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a97:	00 00 00 
	stat->st_dev = &devpipe;
  801a9a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801aa1:	30 80 00 
	return 0;
}
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 0c             	sub    $0xc,%esp
  801ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aba:	53                   	push   %ebx
  801abb:	6a 00                	push   $0x0
  801abd:	e8 00 f5 ff ff       	call   800fc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ac2:	89 1c 24             	mov    %ebx,(%esp)
  801ac5:	e8 74 f6 ff ff       	call   80113e <fd2data>
  801aca:	83 c4 08             	add    $0x8,%esp
  801acd:	50                   	push   %eax
  801ace:	6a 00                	push   $0x0
  801ad0:	e8 ed f4 ff ff       	call   800fc2 <sys_page_unmap>
}
  801ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <_pipeisclosed>:
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 1c             	sub    $0x1c,%esp
  801ae3:	89 c7                	mov    %eax,%edi
  801ae5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ae7:	a1 00 40 80 00       	mov    0x804000,%eax
  801aec:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	57                   	push   %edi
  801af3:	e8 88 03 00 00       	call   801e80 <pageref>
  801af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801afb:	89 34 24             	mov    %esi,(%esp)
  801afe:	e8 7d 03 00 00       	call   801e80 <pageref>
		nn = thisenv->env_runs;
  801b03:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801b09:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	39 cb                	cmp    %ecx,%ebx
  801b11:	74 1b                	je     801b2e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b13:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b16:	75 cf                	jne    801ae7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b18:	8b 42 58             	mov    0x58(%edx),%eax
  801b1b:	6a 01                	push   $0x1
  801b1d:	50                   	push   %eax
  801b1e:	53                   	push   %ebx
  801b1f:	68 a2 25 80 00       	push   $0x8025a2
  801b24:	e8 63 e8 ff ff       	call   80038c <cprintf>
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	eb b9                	jmp    801ae7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b2e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b31:	0f 94 c0             	sete   %al
  801b34:	0f b6 c0             	movzbl %al,%eax
}
  801b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <devpipe_write>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	57                   	push   %edi
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 28             	sub    $0x28,%esp
  801b48:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b4b:	56                   	push   %esi
  801b4c:	e8 ed f5 ff ff       	call   80113e <fd2data>
  801b51:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b5e:	75 09                	jne    801b69 <devpipe_write+0x2a>
	return i;
  801b60:	89 f8                	mov    %edi,%eax
  801b62:	eb 23                	jmp    801b87 <devpipe_write+0x48>
			sys_yield();
  801b64:	e8 b5 f3 ff ff       	call   800f1e <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b69:	8b 43 04             	mov    0x4(%ebx),%eax
  801b6c:	8b 0b                	mov    (%ebx),%ecx
  801b6e:	8d 51 20             	lea    0x20(%ecx),%edx
  801b71:	39 d0                	cmp    %edx,%eax
  801b73:	72 1a                	jb     801b8f <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801b75:	89 da                	mov    %ebx,%edx
  801b77:	89 f0                	mov    %esi,%eax
  801b79:	e8 5c ff ff ff       	call   801ada <_pipeisclosed>
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	74 e2                	je     801b64 <devpipe_write+0x25>
				return 0;
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b8a:	5b                   	pop    %ebx
  801b8b:	5e                   	pop    %esi
  801b8c:	5f                   	pop    %edi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b92:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b96:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b99:	89 c2                	mov    %eax,%edx
  801b9b:	c1 fa 1f             	sar    $0x1f,%edx
  801b9e:	89 d1                	mov    %edx,%ecx
  801ba0:	c1 e9 1b             	shr    $0x1b,%ecx
  801ba3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ba6:	83 e2 1f             	and    $0x1f,%edx
  801ba9:	29 ca                	sub    %ecx,%edx
  801bab:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801baf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bb3:	83 c0 01             	add    $0x1,%eax
  801bb6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bb9:	83 c7 01             	add    $0x1,%edi
  801bbc:	eb 9d                	jmp    801b5b <devpipe_write+0x1c>

00801bbe <devpipe_read>:
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 18             	sub    $0x18,%esp
  801bc7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bca:	57                   	push   %edi
  801bcb:	e8 6e f5 ff ff       	call   80113e <fd2data>
  801bd0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	be 00 00 00 00       	mov    $0x0,%esi
  801bda:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bdd:	75 13                	jne    801bf2 <devpipe_read+0x34>
	return i;
  801bdf:	89 f0                	mov    %esi,%eax
  801be1:	eb 02                	jmp    801be5 <devpipe_read+0x27>
				return i;
  801be3:	89 f0                	mov    %esi,%eax
}
  801be5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5f                   	pop    %edi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    
			sys_yield();
  801bed:	e8 2c f3 ff ff       	call   800f1e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801bf2:	8b 03                	mov    (%ebx),%eax
  801bf4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bf7:	75 18                	jne    801c11 <devpipe_read+0x53>
			if (i > 0)
  801bf9:	85 f6                	test   %esi,%esi
  801bfb:	75 e6                	jne    801be3 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	89 f8                	mov    %edi,%eax
  801c01:	e8 d4 fe ff ff       	call   801ada <_pipeisclosed>
  801c06:	85 c0                	test   %eax,%eax
  801c08:	74 e3                	je     801bed <devpipe_read+0x2f>
				return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0f:	eb d4                	jmp    801be5 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c11:	99                   	cltd   
  801c12:	c1 ea 1b             	shr    $0x1b,%edx
  801c15:	01 d0                	add    %edx,%eax
  801c17:	83 e0 1f             	and    $0x1f,%eax
  801c1a:	29 d0                	sub    %edx,%eax
  801c1c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c24:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c27:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c2a:	83 c6 01             	add    $0x1,%esi
  801c2d:	eb ab                	jmp    801bda <devpipe_read+0x1c>

00801c2f <pipe>:
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3a:	50                   	push   %eax
  801c3b:	e8 15 f5 ff ff       	call   801155 <fd_alloc>
  801c40:	89 c3                	mov    %eax,%ebx
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	0f 88 23 01 00 00    	js     801d70 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	68 07 04 00 00       	push   $0x407
  801c55:	ff 75 f4             	push   -0xc(%ebp)
  801c58:	6a 00                	push   $0x0
  801c5a:	e8 de f2 ff ff       	call   800f3d <sys_page_alloc>
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	85 c0                	test   %eax,%eax
  801c66:	0f 88 04 01 00 00    	js     801d70 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801c6c:	83 ec 0c             	sub    $0xc,%esp
  801c6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c72:	50                   	push   %eax
  801c73:	e8 dd f4 ff ff       	call   801155 <fd_alloc>
  801c78:	89 c3                	mov    %eax,%ebx
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	0f 88 db 00 00 00    	js     801d60 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	68 07 04 00 00       	push   $0x407
  801c8d:	ff 75 f0             	push   -0x10(%ebp)
  801c90:	6a 00                	push   $0x0
  801c92:	e8 a6 f2 ff ff       	call   800f3d <sys_page_alloc>
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	83 c4 10             	add    $0x10,%esp
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	0f 88 bc 00 00 00    	js     801d60 <pipe+0x131>
	va = fd2data(fd0);
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	ff 75 f4             	push   -0xc(%ebp)
  801caa:	e8 8f f4 ff ff       	call   80113e <fd2data>
  801caf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb1:	83 c4 0c             	add    $0xc,%esp
  801cb4:	68 07 04 00 00       	push   $0x407
  801cb9:	50                   	push   %eax
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 7c f2 ff ff       	call   800f3d <sys_page_alloc>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	0f 88 82 00 00 00    	js     801d50 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	ff 75 f0             	push   -0x10(%ebp)
  801cd4:	e8 65 f4 ff ff       	call   80113e <fd2data>
  801cd9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	56                   	push   %esi
  801ce4:	6a 00                	push   $0x0
  801ce6:	e8 95 f2 ff ff       	call   800f80 <sys_page_map>
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	83 c4 20             	add    $0x20,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 4e                	js     801d42 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801cf4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cfc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d01:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d0b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d10:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d17:	83 ec 0c             	sub    $0xc,%esp
  801d1a:	ff 75 f4             	push   -0xc(%ebp)
  801d1d:	e8 0c f4 ff ff       	call   80112e <fd2num>
  801d22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d25:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d27:	83 c4 04             	add    $0x4,%esp
  801d2a:	ff 75 f0             	push   -0x10(%ebp)
  801d2d:	e8 fc f3 ff ff       	call   80112e <fd2num>
  801d32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d35:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d40:	eb 2e                	jmp    801d70 <pipe+0x141>
	sys_page_unmap(0, va);
  801d42:	83 ec 08             	sub    $0x8,%esp
  801d45:	56                   	push   %esi
  801d46:	6a 00                	push   $0x0
  801d48:	e8 75 f2 ff ff       	call   800fc2 <sys_page_unmap>
  801d4d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d50:	83 ec 08             	sub    $0x8,%esp
  801d53:	ff 75 f0             	push   -0x10(%ebp)
  801d56:	6a 00                	push   $0x0
  801d58:	e8 65 f2 ff ff       	call   800fc2 <sys_page_unmap>
  801d5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	ff 75 f4             	push   -0xc(%ebp)
  801d66:	6a 00                	push   $0x0
  801d68:	e8 55 f2 ff ff       	call   800fc2 <sys_page_unmap>
  801d6d:	83 c4 10             	add    $0x10,%esp
}
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    

00801d79 <pipeisclosed>:
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d82:	50                   	push   %eax
  801d83:	ff 75 08             	push   0x8(%ebp)
  801d86:	e8 1a f4 ff ff       	call   8011a5 <fd_lookup>
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 18                	js     801daa <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	ff 75 f4             	push   -0xc(%ebp)
  801d98:	e8 a1 f3 ff ff       	call   80113e <fd2data>
  801d9d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	e8 33 fd ff ff       	call   801ada <_pipeisclosed>
  801da7:	83 c4 10             	add    $0x10,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
  801db1:	8b 75 08             	mov    0x8(%ebp),%esi
  801db4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	ff 75 0c             	push   0xc(%ebp)
  801dbd:	e8 2b f3 ff ff       	call   8010ed <sys_ipc_recv>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	78 2b                	js     801df4 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801dc9:	85 f6                	test   %esi,%esi
  801dcb:	74 0a                	je     801dd7 <ipc_recv+0x2b>
  801dcd:	a1 00 40 80 00       	mov    0x804000,%eax
  801dd2:	8b 40 74             	mov    0x74(%eax),%eax
  801dd5:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801dd7:	85 db                	test   %ebx,%ebx
  801dd9:	74 0a                	je     801de5 <ipc_recv+0x39>
  801ddb:	a1 00 40 80 00       	mov    0x804000,%eax
  801de0:	8b 40 78             	mov    0x78(%eax),%eax
  801de3:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801de5:	a1 00 40 80 00       	mov    0x804000,%eax
  801dea:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ded:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801df4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df9:	eb f2                	jmp    801ded <ipc_recv+0x41>

00801dfb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	57                   	push   %edi
  801dff:	56                   	push   %esi
  801e00:	53                   	push   %ebx
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e07:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801e0d:	ff 75 14             	push   0x14(%ebp)
  801e10:	53                   	push   %ebx
  801e11:	56                   	push   %esi
  801e12:	57                   	push   %edi
  801e13:	e8 b2 f2 ff ff       	call   8010ca <sys_ipc_try_send>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	79 20                	jns    801e3f <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801e1f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e22:	75 07                	jne    801e2b <ipc_send+0x30>
		sys_yield();
  801e24:	e8 f5 f0 ff ff       	call   800f1e <sys_yield>
  801e29:	eb e2                	jmp    801e0d <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801e2b:	83 ec 04             	sub    $0x4,%esp
  801e2e:	68 ba 25 80 00       	push   $0x8025ba
  801e33:	6a 2e                	push   $0x2e
  801e35:	68 ca 25 80 00       	push   $0x8025ca
  801e3a:	e8 72 e4 ff ff       	call   8002b1 <_panic>
	}
}
  801e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e42:	5b                   	pop    %ebx
  801e43:	5e                   	pop    %esi
  801e44:	5f                   	pop    %edi
  801e45:	5d                   	pop    %ebp
  801e46:	c3                   	ret    

00801e47 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e52:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e55:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e5b:	8b 52 50             	mov    0x50(%edx),%edx
  801e5e:	39 ca                	cmp    %ecx,%edx
  801e60:	74 11                	je     801e73 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801e62:	83 c0 01             	add    $0x1,%eax
  801e65:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e6a:	75 e6                	jne    801e52 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e71:	eb 0b                	jmp    801e7e <ipc_find_env+0x37>
			return envs[i].env_id;
  801e73:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e76:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e7b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e86:	89 c2                	mov    %eax,%edx
  801e88:	c1 ea 16             	shr    $0x16,%edx
  801e8b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801e97:	f6 c1 01             	test   $0x1,%cl
  801e9a:	74 1c                	je     801eb8 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801e9c:	c1 e8 0c             	shr    $0xc,%eax
  801e9f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ea6:	a8 01                	test   $0x1,%al
  801ea8:	74 0e                	je     801eb8 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eaa:	c1 e8 0c             	shr    $0xc,%eax
  801ead:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801eb4:	ef 
  801eb5:	0f b7 d2             	movzwl %dx,%edx
}
  801eb8:	89 d0                	mov    %edx,%eax
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <__udivdi3>:
  801ec0:	f3 0f 1e fb          	endbr32 
  801ec4:	55                   	push   %ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 1c             	sub    $0x1c,%esp
  801ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ecf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ed3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ed7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801edb:	85 c0                	test   %eax,%eax
  801edd:	75 19                	jne    801ef8 <__udivdi3+0x38>
  801edf:	39 f3                	cmp    %esi,%ebx
  801ee1:	76 4d                	jbe    801f30 <__udivdi3+0x70>
  801ee3:	31 ff                	xor    %edi,%edi
  801ee5:	89 e8                	mov    %ebp,%eax
  801ee7:	89 f2                	mov    %esi,%edx
  801ee9:	f7 f3                	div    %ebx
  801eeb:	89 fa                	mov    %edi,%edx
  801eed:	83 c4 1c             	add    $0x1c,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	8d 76 00             	lea    0x0(%esi),%esi
  801ef8:	39 f0                	cmp    %esi,%eax
  801efa:	76 14                	jbe    801f10 <__udivdi3+0x50>
  801efc:	31 ff                	xor    %edi,%edi
  801efe:	31 c0                	xor    %eax,%eax
  801f00:	89 fa                	mov    %edi,%edx
  801f02:	83 c4 1c             	add    $0x1c,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
  801f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f10:	0f bd f8             	bsr    %eax,%edi
  801f13:	83 f7 1f             	xor    $0x1f,%edi
  801f16:	75 48                	jne    801f60 <__udivdi3+0xa0>
  801f18:	39 f0                	cmp    %esi,%eax
  801f1a:	72 06                	jb     801f22 <__udivdi3+0x62>
  801f1c:	31 c0                	xor    %eax,%eax
  801f1e:	39 eb                	cmp    %ebp,%ebx
  801f20:	77 de                	ja     801f00 <__udivdi3+0x40>
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	eb d7                	jmp    801f00 <__udivdi3+0x40>
  801f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f30:	89 d9                	mov    %ebx,%ecx
  801f32:	85 db                	test   %ebx,%ebx
  801f34:	75 0b                	jne    801f41 <__udivdi3+0x81>
  801f36:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	f7 f3                	div    %ebx
  801f3f:	89 c1                	mov    %eax,%ecx
  801f41:	31 d2                	xor    %edx,%edx
  801f43:	89 f0                	mov    %esi,%eax
  801f45:	f7 f1                	div    %ecx
  801f47:	89 c6                	mov    %eax,%esi
  801f49:	89 e8                	mov    %ebp,%eax
  801f4b:	89 f7                	mov    %esi,%edi
  801f4d:	f7 f1                	div    %ecx
  801f4f:	89 fa                	mov    %edi,%edx
  801f51:	83 c4 1c             	add    $0x1c,%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    
  801f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f60:	89 f9                	mov    %edi,%ecx
  801f62:	ba 20 00 00 00       	mov    $0x20,%edx
  801f67:	29 fa                	sub    %edi,%edx
  801f69:	d3 e0                	shl    %cl,%eax
  801f6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f6f:	89 d1                	mov    %edx,%ecx
  801f71:	89 d8                	mov    %ebx,%eax
  801f73:	d3 e8                	shr    %cl,%eax
  801f75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f79:	09 c1                	or     %eax,%ecx
  801f7b:	89 f0                	mov    %esi,%eax
  801f7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f81:	89 f9                	mov    %edi,%ecx
  801f83:	d3 e3                	shl    %cl,%ebx
  801f85:	89 d1                	mov    %edx,%ecx
  801f87:	d3 e8                	shr    %cl,%eax
  801f89:	89 f9                	mov    %edi,%ecx
  801f8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f8f:	89 eb                	mov    %ebp,%ebx
  801f91:	d3 e6                	shl    %cl,%esi
  801f93:	89 d1                	mov    %edx,%ecx
  801f95:	d3 eb                	shr    %cl,%ebx
  801f97:	09 f3                	or     %esi,%ebx
  801f99:	89 c6                	mov    %eax,%esi
  801f9b:	89 f2                	mov    %esi,%edx
  801f9d:	89 d8                	mov    %ebx,%eax
  801f9f:	f7 74 24 08          	divl   0x8(%esp)
  801fa3:	89 d6                	mov    %edx,%esi
  801fa5:	89 c3                	mov    %eax,%ebx
  801fa7:	f7 64 24 0c          	mull   0xc(%esp)
  801fab:	39 d6                	cmp    %edx,%esi
  801fad:	72 19                	jb     801fc8 <__udivdi3+0x108>
  801faf:	89 f9                	mov    %edi,%ecx
  801fb1:	d3 e5                	shl    %cl,%ebp
  801fb3:	39 c5                	cmp    %eax,%ebp
  801fb5:	73 04                	jae    801fbb <__udivdi3+0xfb>
  801fb7:	39 d6                	cmp    %edx,%esi
  801fb9:	74 0d                	je     801fc8 <__udivdi3+0x108>
  801fbb:	89 d8                	mov    %ebx,%eax
  801fbd:	31 ff                	xor    %edi,%edi
  801fbf:	e9 3c ff ff ff       	jmp    801f00 <__udivdi3+0x40>
  801fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fcb:	31 ff                	xor    %edi,%edi
  801fcd:	e9 2e ff ff ff       	jmp    801f00 <__udivdi3+0x40>
  801fd2:	66 90                	xchg   %ax,%ax
  801fd4:	66 90                	xchg   %ax,%ax
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	66 90                	xchg   %ax,%ax
  801fda:	66 90                	xchg   %ax,%ax
  801fdc:	66 90                	xchg   %ax,%ax
  801fde:	66 90                	xchg   %ax,%ax

00801fe0 <__umoddi3>:
  801fe0:	f3 0f 1e fb          	endbr32 
  801fe4:	55                   	push   %ebp
  801fe5:	57                   	push   %edi
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 1c             	sub    $0x1c,%esp
  801feb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801fef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ff3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801ff7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	89 da                	mov    %ebx,%edx
  801fff:	85 ff                	test   %edi,%edi
  802001:	75 15                	jne    802018 <__umoddi3+0x38>
  802003:	39 dd                	cmp    %ebx,%ebp
  802005:	76 39                	jbe    802040 <__umoddi3+0x60>
  802007:	f7 f5                	div    %ebp
  802009:	89 d0                	mov    %edx,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	83 c4 1c             	add    $0x1c,%esp
  802010:	5b                   	pop    %ebx
  802011:	5e                   	pop    %esi
  802012:	5f                   	pop    %edi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    
  802015:	8d 76 00             	lea    0x0(%esi),%esi
  802018:	39 df                	cmp    %ebx,%edi
  80201a:	77 f1                	ja     80200d <__umoddi3+0x2d>
  80201c:	0f bd cf             	bsr    %edi,%ecx
  80201f:	83 f1 1f             	xor    $0x1f,%ecx
  802022:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802026:	75 40                	jne    802068 <__umoddi3+0x88>
  802028:	39 df                	cmp    %ebx,%edi
  80202a:	72 04                	jb     802030 <__umoddi3+0x50>
  80202c:	39 f5                	cmp    %esi,%ebp
  80202e:	77 dd                	ja     80200d <__umoddi3+0x2d>
  802030:	89 da                	mov    %ebx,%edx
  802032:	89 f0                	mov    %esi,%eax
  802034:	29 e8                	sub    %ebp,%eax
  802036:	19 fa                	sbb    %edi,%edx
  802038:	eb d3                	jmp    80200d <__umoddi3+0x2d>
  80203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802040:	89 e9                	mov    %ebp,%ecx
  802042:	85 ed                	test   %ebp,%ebp
  802044:	75 0b                	jne    802051 <__umoddi3+0x71>
  802046:	b8 01 00 00 00       	mov    $0x1,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f5                	div    %ebp
  80204f:	89 c1                	mov    %eax,%ecx
  802051:	89 d8                	mov    %ebx,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f1                	div    %ecx
  802057:	89 f0                	mov    %esi,%eax
  802059:	f7 f1                	div    %ecx
  80205b:	89 d0                	mov    %edx,%eax
  80205d:	31 d2                	xor    %edx,%edx
  80205f:	eb ac                	jmp    80200d <__umoddi3+0x2d>
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	8b 44 24 04          	mov    0x4(%esp),%eax
  80206c:	ba 20 00 00 00       	mov    $0x20,%edx
  802071:	29 c2                	sub    %eax,%edx
  802073:	89 c1                	mov    %eax,%ecx
  802075:	89 e8                	mov    %ebp,%eax
  802077:	d3 e7                	shl    %cl,%edi
  802079:	89 d1                	mov    %edx,%ecx
  80207b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80207f:	d3 e8                	shr    %cl,%eax
  802081:	89 c1                	mov    %eax,%ecx
  802083:	8b 44 24 04          	mov    0x4(%esp),%eax
  802087:	09 f9                	or     %edi,%ecx
  802089:	89 df                	mov    %ebx,%edi
  80208b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80208f:	89 c1                	mov    %eax,%ecx
  802091:	d3 e5                	shl    %cl,%ebp
  802093:	89 d1                	mov    %edx,%ecx
  802095:	d3 ef                	shr    %cl,%edi
  802097:	89 c1                	mov    %eax,%ecx
  802099:	89 f0                	mov    %esi,%eax
  80209b:	d3 e3                	shl    %cl,%ebx
  80209d:	89 d1                	mov    %edx,%ecx
  80209f:	89 fa                	mov    %edi,%edx
  8020a1:	d3 e8                	shr    %cl,%eax
  8020a3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020a8:	09 d8                	or     %ebx,%eax
  8020aa:	f7 74 24 08          	divl   0x8(%esp)
  8020ae:	89 d3                	mov    %edx,%ebx
  8020b0:	d3 e6                	shl    %cl,%esi
  8020b2:	f7 e5                	mul    %ebp
  8020b4:	89 c7                	mov    %eax,%edi
  8020b6:	89 d1                	mov    %edx,%ecx
  8020b8:	39 d3                	cmp    %edx,%ebx
  8020ba:	72 06                	jb     8020c2 <__umoddi3+0xe2>
  8020bc:	75 0e                	jne    8020cc <__umoddi3+0xec>
  8020be:	39 c6                	cmp    %eax,%esi
  8020c0:	73 0a                	jae    8020cc <__umoddi3+0xec>
  8020c2:	29 e8                	sub    %ebp,%eax
  8020c4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8020c8:	89 d1                	mov    %edx,%ecx
  8020ca:	89 c7                	mov    %eax,%edi
  8020cc:	89 f5                	mov    %esi,%ebp
  8020ce:	8b 74 24 04          	mov    0x4(%esp),%esi
  8020d2:	29 fd                	sub    %edi,%ebp
  8020d4:	19 cb                	sbb    %ecx,%ebx
  8020d6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	d3 e0                	shl    %cl,%eax
  8020df:	89 f1                	mov    %esi,%ecx
  8020e1:	d3 ed                	shr    %cl,%ebp
  8020e3:	d3 eb                	shr    %cl,%ebx
  8020e5:	09 e8                	or     %ebp,%eax
  8020e7:	89 da                	mov    %ebx,%edx
  8020e9:	83 c4 1c             	add    $0x1c,%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	5f                   	pop    %edi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
