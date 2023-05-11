
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	push   0x10(%ebp)
  80005a:	68 42 23 80 00       	push   $0x802342
  80005f:	e8 b4 1a 00 00       	call   801b18 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 25 28 80 00       	mov    $0x802825,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 4b 23 80 00       	push   $0x80234b
  80007f:	e8 94 1a 00 00       	call   801b18 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	push   0x14(%ebp)
  80008d:	68 d1 27 80 00       	push   $0x8027d1
  800092:	e8 81 1a 00 00       	call   801b18 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 18 41 80 00 00 	cmpl   $0x0,0x804118
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 24 28 80 00       	push   $0x802824
  8000b1:	e8 62 1a 00 00       	call   801b18 <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 ba 09 00 00       	call   800a83 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 40 23 80 00       	mov    $0x802340,%eax
  8000d6:	ba 25 28 80 00       	mov    $0x802825,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 40 23 80 00       	push   $0x802340
  8000e8:	e8 2b 1a 00 00       	call   801b18 <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 6d 18 00 00       	call   801976 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 35 14 00 00       	call   80155c <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	push   -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	push   0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 50 23 80 00       	push   $0x802350
  800166:	6a 1d                	push   $0x1d
  800168:	68 5c 23 80 00       	push   $0x80235c
  80016d:	e8 ac 01 00 00       	call   80031e <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0a                	jg     800180 <lsdir+0x8e>
	if (n < 0)
  800176:	78 1a                	js     800192 <lsdir+0xa0>
}
  800178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5f                   	pop    %edi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    
		panic("short read in directory %s", path);
  800180:	57                   	push   %edi
  800181:	68 66 23 80 00       	push   $0x802366
  800186:	6a 22                	push   $0x22
  800188:	68 5c 23 80 00       	push   $0x80235c
  80018d:	e8 8c 01 00 00       	call   80031e <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 ac 23 80 00       	push   $0x8023ac
  80019c:	6a 24                	push   $0x24
  80019e:	68 5c 23 80 00       	push   $0x80235c
  8001a3:	e8 76 01 00 00       	call   80031e <_panic>

008001a8 <ls>:
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	53                   	push   %ebx
  8001bd:	e8 80 15 00 00       	call   801742 <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d 90 41 80 00 00 	cmpl   $0x0,0x804190
  8001d7:	74 32                	je     80020b <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001d9:	53                   	push   %ebx
  8001da:	ff 75 ec             	push   -0x14(%ebp)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	0f 95 c0             	setne  %al
  8001e2:	0f b6 c0             	movzbl %al,%eax
  8001e5:	50                   	push   %eax
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 46 fe ff ff       	call   800033 <ls1>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	53                   	push   %ebx
  8001fa:	68 81 23 80 00       	push   $0x802381
  8001ff:	6a 0f                	push   $0xf
  800201:	68 5c 23 80 00       	push   $0x80235c
  800206:	e8 13 01 00 00       	call   80031e <_panic>
		lsdir(path, prefix);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	push   0xc(%ebp)
  800211:	53                   	push   %ebx
  800212:	e8 db fe ff ff       	call   8000f2 <lsdir>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d4                	jmp    8001f0 <ls+0x48>

0080021c <usage>:

void
usage(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800222:	68 8d 23 80 00       	push   $0x80238d
  800227:	e8 ec 18 00 00       	call   801b18 <printf>
	exit();
  80022c:	e8 db 00 00 00       	call   80030c <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <umain>:

void
umain(int argc, char **argv)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	83 ec 14             	sub    $0x14,%esp
  80023e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800241:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	56                   	push   %esi
  800246:	8d 45 08             	lea    0x8(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 5c 0e 00 00       	call   8010ab <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 00 40 80 00 	addl   $0x1,0x804000(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 73 0e 00 00       	call   8010db <argnext>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	85 c0                	test   %eax,%eax
  80026d:	78 16                	js     800285 <umain+0x4f>
		switch (i) {
  80026f:	89 c2                	mov    %eax,%edx
  800271:	83 e2 f7             	and    $0xfffffff7,%edx
  800274:	83 fa 64             	cmp    $0x64,%edx
  800277:	74 de                	je     800257 <umain+0x21>
  800279:	83 f8 46             	cmp    $0x46,%eax
  80027c:	74 d9                	je     800257 <umain+0x21>
			break;
		default:
			usage();
  80027e:	e8 99 ff ff ff       	call   80021c <usage>
  800283:	eb da                	jmp    80025f <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800285:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028e:	75 2a                	jne    8002ba <umain+0x84>
		ls("/", "");
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 25 28 80 00       	push   $0x802825
  800298:	68 40 23 80 00       	push   $0x802340
  80029d:	e8 06 ff ff ff       	call   8001a8 <ls>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	eb 18                	jmp    8002bf <umain+0x89>
			ls(argv[i], argv[i]);
  8002a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	50                   	push   %eax
  8002af:	e8 f4 fe ff ff       	call   8001a8 <ls>
		for (i = 1; i < argc; i++)
  8002b4:	83 c3 01             	add    $0x1,%ebx
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bd:	7f e8                	jg     8002a7 <umain+0x71>
	}
}
  8002bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ce:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d1:	e8 a6 0b 00 00       	call   800e7c <sys_getenvid>
  8002d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002db:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e3:	a3 00 44 80 00       	mov    %eax,0x804400

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e8:	85 db                	test   %ebx,%ebx
  8002ea:	7e 07                	jle    8002f3 <libmain+0x2d>
		binaryname = argv[0];
  8002ec:	8b 06                	mov    (%esi),%eax
  8002ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	56                   	push   %esi
  8002f7:	53                   	push   %ebx
  8002f8:	e8 39 ff ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  8002fd:	e8 0a 00 00 00       	call   80030c <exit>
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800308:	5b                   	pop    %ebx
  800309:	5e                   	pop    %esi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800312:	6a 00                	push   $0x0
  800314:	e8 22 0b 00 00       	call   800e3b <sys_env_destroy>
}
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800323:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800326:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80032c:	e8 4b 0b 00 00       	call   800e7c <sys_getenvid>
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 0c             	push   0xc(%ebp)
  800337:	ff 75 08             	push   0x8(%ebp)
  80033a:	56                   	push   %esi
  80033b:	50                   	push   %eax
  80033c:	68 d8 23 80 00       	push   $0x8023d8
  800341:	e8 b3 00 00 00       	call   8003f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800346:	83 c4 18             	add    $0x18,%esp
  800349:	53                   	push   %ebx
  80034a:	ff 75 10             	push   0x10(%ebp)
  80034d:	e8 56 00 00 00       	call   8003a8 <vcprintf>
	cprintf("\n");
  800352:	c7 04 24 24 28 80 00 	movl   $0x802824,(%esp)
  800359:	e8 9b 00 00 00       	call   8003f9 <cprintf>
  80035e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800361:	cc                   	int3   
  800362:	eb fd                	jmp    800361 <_panic+0x43>

00800364 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	53                   	push   %ebx
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80036e:	8b 13                	mov    (%ebx),%edx
  800370:	8d 42 01             	lea    0x1(%edx),%eax
  800373:	89 03                	mov    %eax,(%ebx)
  800375:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800378:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80037c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800381:	74 09                	je     80038c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800383:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 ff 00 00 00       	push   $0xff
  800394:	8d 43 08             	lea    0x8(%ebx),%eax
  800397:	50                   	push   %eax
  800398:	e8 61 0a 00 00       	call   800dfe <sys_cputs>
		b->idx = 0;
  80039d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	eb db                	jmp    800383 <putch+0x1f>

008003a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b8:	00 00 00 
	b.cnt = 0;
  8003bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c5:	ff 75 0c             	push   0xc(%ebp)
  8003c8:	ff 75 08             	push   0x8(%ebp)
  8003cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d1:	50                   	push   %eax
  8003d2:	68 64 03 80 00       	push   $0x800364
  8003d7:	e8 14 01 00 00       	call   8004f0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003dc:	83 c4 08             	add    $0x8,%esp
  8003df:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8003e5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	e8 0d 0a 00 00       	call   800dfe <sys_cputs>

	return b.cnt;
}
  8003f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800402:	50                   	push   %eax
  800403:	ff 75 08             	push   0x8(%ebp)
  800406:	e8 9d ff ff ff       	call   8003a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 1c             	sub    $0x1c,%esp
  800416:	89 c7                	mov    %eax,%edi
  800418:	89 d6                	mov    %edx,%esi
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800420:	89 d1                	mov    %edx,%ecx
  800422:	89 c2                	mov    %eax,%edx
  800424:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800427:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80042a:	8b 45 10             	mov    0x10(%ebp),%eax
  80042d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80043a:	39 c2                	cmp    %eax,%edx
  80043c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80043f:	72 3e                	jb     80047f <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800441:	83 ec 0c             	sub    $0xc,%esp
  800444:	ff 75 18             	push   0x18(%ebp)
  800447:	83 eb 01             	sub    $0x1,%ebx
  80044a:	53                   	push   %ebx
  80044b:	50                   	push   %eax
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	ff 75 e4             	push   -0x1c(%ebp)
  800452:	ff 75 e0             	push   -0x20(%ebp)
  800455:	ff 75 dc             	push   -0x24(%ebp)
  800458:	ff 75 d8             	push   -0x28(%ebp)
  80045b:	e8 a0 1c 00 00       	call   802100 <__udivdi3>
  800460:	83 c4 18             	add    $0x18,%esp
  800463:	52                   	push   %edx
  800464:	50                   	push   %eax
  800465:	89 f2                	mov    %esi,%edx
  800467:	89 f8                	mov    %edi,%eax
  800469:	e8 9f ff ff ff       	call   80040d <printnum>
  80046e:	83 c4 20             	add    $0x20,%esp
  800471:	eb 13                	jmp    800486 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	56                   	push   %esi
  800477:	ff 75 18             	push   0x18(%ebp)
  80047a:	ff d7                	call   *%edi
  80047c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	85 db                	test   %ebx,%ebx
  800484:	7f ed                	jg     800473 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	56                   	push   %esi
  80048a:	83 ec 04             	sub    $0x4,%esp
  80048d:	ff 75 e4             	push   -0x1c(%ebp)
  800490:	ff 75 e0             	push   -0x20(%ebp)
  800493:	ff 75 dc             	push   -0x24(%ebp)
  800496:	ff 75 d8             	push   -0x28(%ebp)
  800499:	e8 82 1d 00 00       	call   802220 <__umoddi3>
  80049e:	83 c4 14             	add    $0x14,%esp
  8004a1:	0f be 80 fb 23 80 00 	movsbl 0x8023fb(%eax),%eax
  8004a8:	50                   	push   %eax
  8004a9:	ff d7                	call   *%edi
}
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b1:	5b                   	pop    %ebx
  8004b2:	5e                   	pop    %esi
  8004b3:	5f                   	pop    %edi
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c5:	73 0a                	jae    8004d1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ca:	89 08                	mov    %ecx,(%eax)
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	88 02                	mov    %al,(%edx)
}
  8004d1:	5d                   	pop    %ebp
  8004d2:	c3                   	ret    

008004d3 <printfmt>:
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004d9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004dc:	50                   	push   %eax
  8004dd:	ff 75 10             	push   0x10(%ebp)
  8004e0:	ff 75 0c             	push   0xc(%ebp)
  8004e3:	ff 75 08             	push   0x8(%ebp)
  8004e6:	e8 05 00 00 00       	call   8004f0 <vprintfmt>
}
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <vprintfmt>:
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 3c             	sub    $0x3c,%esp
  8004f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  800502:	eb 0a                	jmp    80050e <vprintfmt+0x1e>
			putch(ch, putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	53                   	push   %ebx
  800508:	50                   	push   %eax
  800509:	ff d6                	call   *%esi
  80050b:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80050e:	83 c7 01             	add    $0x1,%edi
  800511:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800515:	83 f8 25             	cmp    $0x25,%eax
  800518:	74 0c                	je     800526 <vprintfmt+0x36>
			if (ch == '\0')
  80051a:	85 c0                	test   %eax,%eax
  80051c:	75 e6                	jne    800504 <vprintfmt+0x14>
}
  80051e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800521:	5b                   	pop    %ebx
  800522:	5e                   	pop    %esi
  800523:	5f                   	pop    %edi
  800524:	5d                   	pop    %ebp
  800525:	c3                   	ret    
		padc = ' ';
  800526:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80052a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800531:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800538:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80053f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800544:	8d 47 01             	lea    0x1(%edi),%eax
  800547:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054a:	0f b6 17             	movzbl (%edi),%edx
  80054d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800550:	3c 55                	cmp    $0x55,%al
  800552:	0f 87 a6 04 00 00    	ja     8009fe <vprintfmt+0x50e>
  800558:	0f b6 c0             	movzbl %al,%eax
  80055b:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  800562:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800565:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800569:	eb d9                	jmp    800544 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80056e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800572:	eb d0                	jmp    800544 <vprintfmt+0x54>
  800574:	0f b6 d2             	movzbl %dl,%edx
  800577:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80057a:	b8 00 00 00 00       	mov    $0x0,%eax
  80057f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800582:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800585:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800589:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80058f:	83 f9 09             	cmp    $0x9,%ecx
  800592:	77 55                	ja     8005e9 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800594:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800597:	eb e9                	jmp    800582 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b1:	79 91                	jns    800544 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005c0:	eb 82                	jmp    800544 <vprintfmt+0x54>
  8005c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c5:	85 d2                	test   %edx,%edx
  8005c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cc:	0f 49 c2             	cmovns %edx,%eax
  8005cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005d5:	e9 6a ff ff ff       	jmp    800544 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8005dd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005e4:	e9 5b ff ff ff       	jmp    800544 <vprintfmt+0x54>
  8005e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ef:	eb bc                	jmp    8005ad <vprintfmt+0xbd>
			lflag++;
  8005f1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005f7:	e9 48 ff ff ff       	jmp    800544 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 78 04             	lea    0x4(%eax),%edi
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	ff 30                	push   (%eax)
  800608:	ff d6                	call   *%esi
			break;
  80060a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80060d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800610:	e9 88 03 00 00       	jmp    80099d <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 78 04             	lea    0x4(%eax),%edi
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	89 d0                	mov    %edx,%eax
  80061f:	f7 d8                	neg    %eax
  800621:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800624:	83 f8 0f             	cmp    $0xf,%eax
  800627:	7f 23                	jg     80064c <vprintfmt+0x15c>
  800629:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  800630:	85 d2                	test   %edx,%edx
  800632:	74 18                	je     80064c <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800634:	52                   	push   %edx
  800635:	68 d1 27 80 00       	push   $0x8027d1
  80063a:	53                   	push   %ebx
  80063b:	56                   	push   %esi
  80063c:	e8 92 fe ff ff       	call   8004d3 <printfmt>
  800641:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800644:	89 7d 14             	mov    %edi,0x14(%ebp)
  800647:	e9 51 03 00 00       	jmp    80099d <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80064c:	50                   	push   %eax
  80064d:	68 13 24 80 00       	push   $0x802413
  800652:	53                   	push   %ebx
  800653:	56                   	push   %esi
  800654:	e8 7a fe ff ff       	call   8004d3 <printfmt>
  800659:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80065f:	e9 39 03 00 00       	jmp    80099d <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800672:	85 d2                	test   %edx,%edx
  800674:	b8 0c 24 80 00       	mov    $0x80240c,%eax
  800679:	0f 45 c2             	cmovne %edx,%eax
  80067c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80067f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800683:	7e 06                	jle    80068b <vprintfmt+0x19b>
  800685:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800689:	75 0d                	jne    800698 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80068e:	89 c7                	mov    %eax,%edi
  800690:	03 45 d4             	add    -0x2c(%ebp),%eax
  800693:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800696:	eb 55                	jmp    8006ed <vprintfmt+0x1fd>
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	ff 75 e0             	push   -0x20(%ebp)
  80069e:	ff 75 cc             	push   -0x34(%ebp)
  8006a1:	e8 f5 03 00 00       	call   800a9b <strnlen>
  8006a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a9:	29 c2                	sub    %eax,%edx
  8006ab:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006b3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x1db>
					putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	ff 75 d4             	push   -0x2c(%ebp)
  8006c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	85 ff                	test   %edi,%edi
  8006cd:	7f ed                	jg     8006bc <vprintfmt+0x1cc>
  8006cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006d2:	85 d2                	test   %edx,%edx
  8006d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d9:	0f 49 c2             	cmovns %edx,%eax
  8006dc:	29 c2                	sub    %eax,%edx
  8006de:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006e1:	eb a8                	jmp    80068b <vprintfmt+0x19b>
					putch(ch, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	52                   	push   %edx
  8006e8:	ff d6                	call   *%esi
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f2:	83 c7 01             	add    $0x1,%edi
  8006f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f9:	0f be d0             	movsbl %al,%edx
  8006fc:	85 d2                	test   %edx,%edx
  8006fe:	74 4b                	je     80074b <vprintfmt+0x25b>
  800700:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800704:	78 06                	js     80070c <vprintfmt+0x21c>
  800706:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80070a:	78 1e                	js     80072a <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80070c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800710:	74 d1                	je     8006e3 <vprintfmt+0x1f3>
  800712:	0f be c0             	movsbl %al,%eax
  800715:	83 e8 20             	sub    $0x20,%eax
  800718:	83 f8 5e             	cmp    $0x5e,%eax
  80071b:	76 c6                	jbe    8006e3 <vprintfmt+0x1f3>
					putch('?', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 3f                	push   $0x3f
  800723:	ff d6                	call   *%esi
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	eb c3                	jmp    8006ed <vprintfmt+0x1fd>
  80072a:	89 cf                	mov    %ecx,%edi
  80072c:	eb 0e                	jmp    80073c <vprintfmt+0x24c>
				putch(' ', putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	53                   	push   %ebx
  800732:	6a 20                	push   $0x20
  800734:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800736:	83 ef 01             	sub    $0x1,%edi
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	85 ff                	test   %edi,%edi
  80073e:	7f ee                	jg     80072e <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800740:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
  800746:	e9 52 02 00 00       	jmp    80099d <vprintfmt+0x4ad>
  80074b:	89 cf                	mov    %ecx,%edi
  80074d:	eb ed                	jmp    80073c <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	83 c0 04             	add    $0x4,%eax
  800755:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80075d:	85 d2                	test   %edx,%edx
  80075f:	b8 0c 24 80 00       	mov    $0x80240c,%eax
  800764:	0f 45 c2             	cmovne %edx,%eax
  800767:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80076a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80076e:	7e 06                	jle    800776 <vprintfmt+0x286>
  800770:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800774:	75 0d                	jne    800783 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800776:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800779:	89 c7                	mov    %eax,%edi
  80077b:	03 45 d4             	add    -0x2c(%ebp),%eax
  80077e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800781:	eb 55                	jmp    8007d8 <vprintfmt+0x2e8>
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 e0             	push   -0x20(%ebp)
  800789:	ff 75 cc             	push   -0x34(%ebp)
  80078c:	e8 0a 03 00 00       	call   800a9b <strnlen>
  800791:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800794:	29 c2                	sub    %eax,%edx
  800796:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80079e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a5:	eb 0f                	jmp    8007b6 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	ff 75 d4             	push   -0x2c(%ebp)
  8007ae:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b0:	83 ef 01             	sub    $0x1,%edi
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	85 ff                	test   %edi,%edi
  8007b8:	7f ed                	jg     8007a7 <vprintfmt+0x2b7>
  8007ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007bd:	85 d2                	test   %edx,%edx
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	0f 49 c2             	cmovns %edx,%eax
  8007c7:	29 c2                	sub    %eax,%edx
  8007c9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007cc:	eb a8                	jmp    800776 <vprintfmt+0x286>
					putch(ch, putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	52                   	push   %edx
  8007d3:	ff d6                	call   *%esi
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8007dd:	83 c7 01             	add    $0x1,%edi
  8007e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e4:	0f be d0             	movsbl %al,%edx
  8007e7:	3c 3a                	cmp    $0x3a,%al
  8007e9:	74 4b                	je     800836 <vprintfmt+0x346>
  8007eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ef:	78 06                	js     8007f7 <vprintfmt+0x307>
  8007f1:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8007f5:	78 1e                	js     800815 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007fb:	74 d1                	je     8007ce <vprintfmt+0x2de>
  8007fd:	0f be c0             	movsbl %al,%eax
  800800:	83 e8 20             	sub    $0x20,%eax
  800803:	83 f8 5e             	cmp    $0x5e,%eax
  800806:	76 c6                	jbe    8007ce <vprintfmt+0x2de>
					putch('?', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 3f                	push   $0x3f
  80080e:	ff d6                	call   *%esi
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	eb c3                	jmp    8007d8 <vprintfmt+0x2e8>
  800815:	89 cf                	mov    %ecx,%edi
  800817:	eb 0e                	jmp    800827 <vprintfmt+0x337>
				putch(' ', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 20                	push   $0x20
  80081f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800821:	83 ef 01             	sub    $0x1,%edi
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	85 ff                	test   %edi,%edi
  800829:	7f ee                	jg     800819 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80082b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	e9 67 01 00 00       	jmp    80099d <vprintfmt+0x4ad>
  800836:	89 cf                	mov    %ecx,%edi
  800838:	eb ed                	jmp    800827 <vprintfmt+0x337>
	if (lflag >= 2)
  80083a:	83 f9 01             	cmp    $0x1,%ecx
  80083d:	7f 1b                	jg     80085a <vprintfmt+0x36a>
	else if (lflag)
  80083f:	85 c9                	test   %ecx,%ecx
  800841:	74 63                	je     8008a6 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084b:	99                   	cltd   
  80084c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	eb 17                	jmp    800871 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 50 04             	mov    0x4(%eax),%edx
  800860:	8b 00                	mov    (%eax),%eax
  800862:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800865:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 08             	lea    0x8(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800871:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800874:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800877:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80087c:	85 c9                	test   %ecx,%ecx
  80087e:	0f 89 ff 00 00 00    	jns    800983 <vprintfmt+0x493>
				putch('-', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 2d                	push   $0x2d
  80088a:	ff d6                	call   *%esi
				num = -(long long) num;
  80088c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80088f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800892:	f7 da                	neg    %edx
  800894:	83 d1 00             	adc    $0x0,%ecx
  800897:	f7 d9                	neg    %ecx
  800899:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80089c:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008a1:	e9 dd 00 00 00       	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ae:	99                   	cltd   
  8008af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	eb b4                	jmp    800871 <vprintfmt+0x381>
	if (lflag >= 2)
  8008bd:	83 f9 01             	cmp    $0x1,%ecx
  8008c0:	7f 1e                	jg     8008e0 <vprintfmt+0x3f0>
	else if (lflag)
  8008c2:	85 c9                	test   %ecx,%ecx
  8008c4:	74 32                	je     8008f8 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8b 10                	mov    (%eax),%edx
  8008cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d6:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8008db:	e9 a3 00 00 00       	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8b 10                	mov    (%eax),%edx
  8008e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8008e8:	8d 40 08             	lea    0x8(%eax),%eax
  8008eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ee:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  8008f3:	e9 8b 00 00 00       	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	8b 10                	mov    (%eax),%edx
  8008fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800902:	8d 40 04             	lea    0x4(%eax),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800908:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80090d:	eb 74                	jmp    800983 <vprintfmt+0x493>
	if (lflag >= 2)
  80090f:	83 f9 01             	cmp    $0x1,%ecx
  800912:	7f 1b                	jg     80092f <vprintfmt+0x43f>
	else if (lflag)
  800914:	85 c9                	test   %ecx,%ecx
  800916:	74 2c                	je     800944 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8b 10                	mov    (%eax),%edx
  80091d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800922:	8d 40 04             	lea    0x4(%eax),%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800928:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80092d:	eb 54                	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 10                	mov    (%eax),%edx
  800934:	8b 48 04             	mov    0x4(%eax),%ecx
  800937:	8d 40 08             	lea    0x8(%eax),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80093d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800942:	eb 3f                	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8b 10                	mov    (%eax),%edx
  800949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094e:	8d 40 04             	lea    0x4(%eax),%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800954:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800959:	eb 28                	jmp    800983 <vprintfmt+0x493>
			putch('0', putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	53                   	push   %ebx
  80095f:	6a 30                	push   $0x30
  800961:	ff d6                	call   *%esi
			putch('x', putdat);
  800963:	83 c4 08             	add    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 78                	push   $0x78
  800969:	ff d6                	call   *%esi
			num = (unsigned long long)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8b 10                	mov    (%eax),%edx
  800970:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800975:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800978:	8d 40 04             	lea    0x4(%eax),%eax
  80097b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097e:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800983:	83 ec 0c             	sub    $0xc,%esp
  800986:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	ff 75 d4             	push   -0x2c(%ebp)
  80098e:	57                   	push   %edi
  80098f:	51                   	push   %ecx
  800990:	52                   	push   %edx
  800991:	89 da                	mov    %ebx,%edx
  800993:	89 f0                	mov    %esi,%eax
  800995:	e8 73 fa ff ff       	call   80040d <printnum>
			break;
  80099a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80099d:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a0:	e9 69 fb ff ff       	jmp    80050e <vprintfmt+0x1e>
	if (lflag >= 2)
  8009a5:	83 f9 01             	cmp    $0x1,%ecx
  8009a8:	7f 1b                	jg     8009c5 <vprintfmt+0x4d5>
	else if (lflag)
  8009aa:	85 c9                	test   %ecx,%ecx
  8009ac:	74 2c                	je     8009da <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	8b 10                	mov    (%eax),%edx
  8009b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009b8:	8d 40 04             	lea    0x4(%eax),%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009be:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009c3:	eb be                	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	8b 10                	mov    (%eax),%edx
  8009ca:	8b 48 04             	mov    0x4(%eax),%ecx
  8009cd:	8d 40 08             	lea    0x8(%eax),%eax
  8009d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009d8:	eb a9                	jmp    800983 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8b 10                	mov    (%eax),%edx
  8009df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e4:	8d 40 04             	lea    0x4(%eax),%eax
  8009e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ea:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  8009ef:	eb 92                	jmp    800983 <vprintfmt+0x493>
			putch(ch, putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	53                   	push   %ebx
  8009f5:	6a 25                	push   $0x25
  8009f7:	ff d6                	call   *%esi
			break;
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	eb 9f                	jmp    80099d <vprintfmt+0x4ad>
			putch('%', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	53                   	push   %ebx
  800a02:	6a 25                	push   $0x25
  800a04:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 f8                	mov    %edi,%eax
  800a0b:	eb 03                	jmp    800a10 <vprintfmt+0x520>
  800a0d:	83 e8 01             	sub    $0x1,%eax
  800a10:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a14:	75 f7                	jne    800a0d <vprintfmt+0x51d>
  800a16:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a19:	eb 82                	jmp    80099d <vprintfmt+0x4ad>

00800a1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	83 ec 18             	sub    $0x18,%esp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a2e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a38:	85 c0                	test   %eax,%eax
  800a3a:	74 26                	je     800a62 <vsnprintf+0x47>
  800a3c:	85 d2                	test   %edx,%edx
  800a3e:	7e 22                	jle    800a62 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a40:	ff 75 14             	push   0x14(%ebp)
  800a43:	ff 75 10             	push   0x10(%ebp)
  800a46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a49:	50                   	push   %eax
  800a4a:	68 b6 04 80 00       	push   $0x8004b6
  800a4f:	e8 9c fa ff ff       	call   8004f0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    
		return -E_INVAL;
  800a62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a67:	eb f7                	jmp    800a60 <vsnprintf+0x45>

00800a69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a6f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a72:	50                   	push   %eax
  800a73:	ff 75 10             	push   0x10(%ebp)
  800a76:	ff 75 0c             	push   0xc(%ebp)
  800a79:	ff 75 08             	push   0x8(%ebp)
  800a7c:	e8 9a ff ff ff       	call   800a1b <vsnprintf>
	va_end(ap);

	return rc;
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a89:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8e:	eb 03                	jmp    800a93 <strlen+0x10>
		n++;
  800a90:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a97:	75 f7                	jne    800a90 <strlen+0xd>
	return n;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	eb 03                	jmp    800aae <strnlen+0x13>
		n++;
  800aab:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aae:	39 d0                	cmp    %edx,%eax
  800ab0:	74 08                	je     800aba <strnlen+0x1f>
  800ab2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ab6:	75 f3                	jne    800aab <strnlen+0x10>
  800ab8:	89 c2                	mov    %eax,%edx
	return n;
}
  800aba:	89 d0                	mov    %edx,%eax
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	53                   	push   %ebx
  800ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800ad1:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	84 d2                	test   %dl,%dl
  800ad9:	75 f2                	jne    800acd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800adb:	89 c8                	mov    %ecx,%eax
  800add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	53                   	push   %ebx
  800ae6:	83 ec 10             	sub    $0x10,%esp
  800ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aec:	53                   	push   %ebx
  800aed:	e8 91 ff ff ff       	call   800a83 <strlen>
  800af2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800af5:	ff 75 0c             	push   0xc(%ebp)
  800af8:	01 d8                	add    %ebx,%eax
  800afa:	50                   	push   %eax
  800afb:	e8 be ff ff ff       	call   800abe <strcpy>
	return dst;
}
  800b00:	89 d8                	mov    %ebx,%eax
  800b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b17:	89 f0                	mov    %esi,%eax
  800b19:	eb 0f                	jmp    800b2a <strncpy+0x23>
		*dst++ = *src;
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	0f b6 0a             	movzbl (%edx),%ecx
  800b21:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b24:	80 f9 01             	cmp    $0x1,%cl
  800b27:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b2a:	39 d8                	cmp    %ebx,%eax
  800b2c:	75 ed                	jne    800b1b <strncpy+0x14>
	}
	return ret;
}
  800b2e:	89 f0                	mov    %esi,%eax
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3f:	8b 55 10             	mov    0x10(%ebp),%edx
  800b42:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b44:	85 d2                	test   %edx,%edx
  800b46:	74 21                	je     800b69 <strlcpy+0x35>
  800b48:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b4c:	89 f2                	mov    %esi,%edx
  800b4e:	eb 09                	jmp    800b59 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b50:	83 c1 01             	add    $0x1,%ecx
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b59:	39 c2                	cmp    %eax,%edx
  800b5b:	74 09                	je     800b66 <strlcpy+0x32>
  800b5d:	0f b6 19             	movzbl (%ecx),%ebx
  800b60:	84 db                	test   %bl,%bl
  800b62:	75 ec                	jne    800b50 <strlcpy+0x1c>
  800b64:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b66:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b69:	29 f0                	sub    %esi,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b78:	eb 06                	jmp    800b80 <strcmp+0x11>
		p++, q++;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b80:	0f b6 01             	movzbl (%ecx),%eax
  800b83:	84 c0                	test   %al,%al
  800b85:	74 04                	je     800b8b <strcmp+0x1c>
  800b87:	3a 02                	cmp    (%edx),%al
  800b89:	74 ef                	je     800b7a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b8b:	0f b6 c0             	movzbl %al,%eax
  800b8e:	0f b6 12             	movzbl (%edx),%edx
  800b91:	29 d0                	sub    %edx,%eax
}
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9f:	89 c3                	mov    %eax,%ebx
  800ba1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba4:	eb 06                	jmp    800bac <strncmp+0x17>
		n--, p++, q++;
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bac:	39 d8                	cmp    %ebx,%eax
  800bae:	74 18                	je     800bc8 <strncmp+0x33>
  800bb0:	0f b6 08             	movzbl (%eax),%ecx
  800bb3:	84 c9                	test   %cl,%cl
  800bb5:	74 04                	je     800bbb <strncmp+0x26>
  800bb7:	3a 0a                	cmp    (%edx),%cl
  800bb9:	74 eb                	je     800ba6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbb:	0f b6 00             	movzbl (%eax),%eax
  800bbe:	0f b6 12             	movzbl (%edx),%edx
  800bc1:	29 d0                	sub    %edx,%eax
}
  800bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    
		return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcd:	eb f4                	jmp    800bc3 <strncmp+0x2e>

00800bcf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd9:	eb 03                	jmp    800bde <strchr+0xf>
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	0f b6 10             	movzbl (%eax),%edx
  800be1:	84 d2                	test   %dl,%dl
  800be3:	74 06                	je     800beb <strchr+0x1c>
		if (*s == c)
  800be5:	38 ca                	cmp    %cl,%dl
  800be7:	75 f2                	jne    800bdb <strchr+0xc>
  800be9:	eb 05                	jmp    800bf0 <strchr+0x21>
			return (char *) s;
	return 0;
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bff:	38 ca                	cmp    %cl,%dl
  800c01:	74 09                	je     800c0c <strfind+0x1a>
  800c03:	84 d2                	test   %dl,%dl
  800c05:	74 05                	je     800c0c <strfind+0x1a>
	for (; *s; s++)
  800c07:	83 c0 01             	add    $0x1,%eax
  800c0a:	eb f0                	jmp    800bfc <strfind+0xa>
			break;
	return (char *) s;
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c1a:	85 c9                	test   %ecx,%ecx
  800c1c:	74 2f                	je     800c4d <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c1e:	89 f8                	mov    %edi,%eax
  800c20:	09 c8                	or     %ecx,%eax
  800c22:	a8 03                	test   $0x3,%al
  800c24:	75 21                	jne    800c47 <memset+0x39>
		c &= 0xFF;
  800c26:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c2a:	89 d0                	mov    %edx,%eax
  800c2c:	c1 e0 08             	shl    $0x8,%eax
  800c2f:	89 d3                	mov    %edx,%ebx
  800c31:	c1 e3 18             	shl    $0x18,%ebx
  800c34:	89 d6                	mov    %edx,%esi
  800c36:	c1 e6 10             	shl    $0x10,%esi
  800c39:	09 f3                	or     %esi,%ebx
  800c3b:	09 da                	or     %ebx,%edx
  800c3d:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c3f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c42:	fc                   	cld    
  800c43:	f3 ab                	rep stos %eax,%es:(%edi)
  800c45:	eb 06                	jmp    800c4d <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4d:	89 f8                	mov    %edi,%eax
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c62:	39 c6                	cmp    %eax,%esi
  800c64:	73 32                	jae    800c98 <memmove+0x44>
  800c66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c69:	39 c2                	cmp    %eax,%edx
  800c6b:	76 2b                	jbe    800c98 <memmove+0x44>
		s += n;
		d += n;
  800c6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c70:	89 d6                	mov    %edx,%esi
  800c72:	09 fe                	or     %edi,%esi
  800c74:	09 ce                	or     %ecx,%esi
  800c76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7c:	75 0e                	jne    800c8c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c7e:	83 ef 04             	sub    $0x4,%edi
  800c81:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c87:	fd                   	std    
  800c88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8a:	eb 09                	jmp    800c95 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c8c:	83 ef 01             	sub    $0x1,%edi
  800c8f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c92:	fd                   	std    
  800c93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c95:	fc                   	cld    
  800c96:	eb 1a                	jmp    800cb2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c98:	89 f2                	mov    %esi,%edx
  800c9a:	09 c2                	or     %eax,%edx
  800c9c:	09 ca                	or     %ecx,%edx
  800c9e:	f6 c2 03             	test   $0x3,%dl
  800ca1:	75 0a                	jne    800cad <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ca6:	89 c7                	mov    %eax,%edi
  800ca8:	fc                   	cld    
  800ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cab:	eb 05                	jmp    800cb2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cad:	89 c7                	mov    %eax,%edi
  800caf:	fc                   	cld    
  800cb0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cbc:	ff 75 10             	push   0x10(%ebp)
  800cbf:	ff 75 0c             	push   0xc(%ebp)
  800cc2:	ff 75 08             	push   0x8(%ebp)
  800cc5:	e8 8a ff ff ff       	call   800c54 <memmove>
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd7:	89 c6                	mov    %eax,%esi
  800cd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cdc:	eb 06                	jmp    800ce4 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cde:	83 c0 01             	add    $0x1,%eax
  800ce1:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800ce4:	39 f0                	cmp    %esi,%eax
  800ce6:	74 14                	je     800cfc <memcmp+0x30>
		if (*s1 != *s2)
  800ce8:	0f b6 08             	movzbl (%eax),%ecx
  800ceb:	0f b6 1a             	movzbl (%edx),%ebx
  800cee:	38 d9                	cmp    %bl,%cl
  800cf0:	74 ec                	je     800cde <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800cf2:	0f b6 c1             	movzbl %cl,%eax
  800cf5:	0f b6 db             	movzbl %bl,%ebx
  800cf8:	29 d8                	sub    %ebx,%eax
  800cfa:	eb 05                	jmp    800d01 <memcmp+0x35>
	}

	return 0;
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d13:	eb 03                	jmp    800d18 <memfind+0x13>
  800d15:	83 c0 01             	add    $0x1,%eax
  800d18:	39 d0                	cmp    %edx,%eax
  800d1a:	73 04                	jae    800d20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d1c:	38 08                	cmp    %cl,(%eax)
  800d1e:	75 f5                	jne    800d15 <memfind+0x10>
			break;
	return (void *) s;
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2e:	eb 03                	jmp    800d33 <strtol+0x11>
		s++;
  800d30:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d33:	0f b6 02             	movzbl (%edx),%eax
  800d36:	3c 20                	cmp    $0x20,%al
  800d38:	74 f6                	je     800d30 <strtol+0xe>
  800d3a:	3c 09                	cmp    $0x9,%al
  800d3c:	74 f2                	je     800d30 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d3e:	3c 2b                	cmp    $0x2b,%al
  800d40:	74 2a                	je     800d6c <strtol+0x4a>
	int neg = 0;
  800d42:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d47:	3c 2d                	cmp    $0x2d,%al
  800d49:	74 2b                	je     800d76 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d51:	75 0f                	jne    800d62 <strtol+0x40>
  800d53:	80 3a 30             	cmpb   $0x30,(%edx)
  800d56:	74 28                	je     800d80 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d58:	85 db                	test   %ebx,%ebx
  800d5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d5f:	0f 44 d8             	cmove  %eax,%ebx
  800d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d67:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d6a:	eb 46                	jmp    800db2 <strtol+0x90>
		s++;
  800d6c:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d74:	eb d5                	jmp    800d4b <strtol+0x29>
		s++, neg = 1;
  800d76:	83 c2 01             	add    $0x1,%edx
  800d79:	bf 01 00 00 00       	mov    $0x1,%edi
  800d7e:	eb cb                	jmp    800d4b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d80:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d84:	74 0e                	je     800d94 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d86:	85 db                	test   %ebx,%ebx
  800d88:	75 d8                	jne    800d62 <strtol+0x40>
		s++, base = 8;
  800d8a:	83 c2 01             	add    $0x1,%edx
  800d8d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d92:	eb ce                	jmp    800d62 <strtol+0x40>
		s += 2, base = 16;
  800d94:	83 c2 02             	add    $0x2,%edx
  800d97:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d9c:	eb c4                	jmp    800d62 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d9e:	0f be c0             	movsbl %al,%eax
  800da1:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800da4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da7:	7d 3a                	jge    800de3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800da9:	83 c2 01             	add    $0x1,%edx
  800dac:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800db0:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800db2:	0f b6 02             	movzbl (%edx),%eax
  800db5:	8d 70 d0             	lea    -0x30(%eax),%esi
  800db8:	89 f3                	mov    %esi,%ebx
  800dba:	80 fb 09             	cmp    $0x9,%bl
  800dbd:	76 df                	jbe    800d9e <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800dbf:	8d 70 9f             	lea    -0x61(%eax),%esi
  800dc2:	89 f3                	mov    %esi,%ebx
  800dc4:	80 fb 19             	cmp    $0x19,%bl
  800dc7:	77 08                	ja     800dd1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dc9:	0f be c0             	movsbl %al,%eax
  800dcc:	83 e8 57             	sub    $0x57,%eax
  800dcf:	eb d3                	jmp    800da4 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800dd1:	8d 70 bf             	lea    -0x41(%eax),%esi
  800dd4:	89 f3                	mov    %esi,%ebx
  800dd6:	80 fb 19             	cmp    $0x19,%bl
  800dd9:	77 08                	ja     800de3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ddb:	0f be c0             	movsbl %al,%eax
  800dde:	83 e8 37             	sub    $0x37,%eax
  800de1:	eb c1                	jmp    800da4 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	74 05                	je     800dee <strtol+0xcc>
		*endptr = (char *) s;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dee:	89 c8                	mov    %ecx,%eax
  800df0:	f7 d8                	neg    %eax
  800df2:	85 ff                	test   %edi,%edi
  800df4:	0f 45 c8             	cmovne %eax,%ecx
}
  800df7:	89 c8                	mov    %ecx,%eax
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	57                   	push   %edi
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	89 c7                	mov    %eax,%edi
  800e13:	89 c6                	mov    %eax,%esi
  800e15:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <sys_cgetc>:

int
sys_cgetc(void)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
  800e27:	b8 01 00 00 00       	mov    $0x1,%eax
  800e2c:	89 d1                	mov    %edx,%ecx
  800e2e:	89 d3                	mov    %edx,%ebx
  800e30:	89 d7                	mov    %edx,%edi
  800e32:	89 d6                	mov    %edx,%esi
  800e34:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e51:	89 cb                	mov    %ecx,%ebx
  800e53:	89 cf                	mov    %ecx,%edi
  800e55:	89 ce                	mov    %ecx,%esi
  800e57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7f 08                	jg     800e65 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	50                   	push   %eax
  800e69:	6a 03                	push   $0x3
  800e6b:	68 ff 26 80 00       	push   $0x8026ff
  800e70:	6a 23                	push   $0x23
  800e72:	68 1c 27 80 00       	push   $0x80271c
  800e77:	e8 a2 f4 ff ff       	call   80031e <_panic>

00800e7c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e82:	ba 00 00 00 00       	mov    $0x0,%edx
  800e87:	b8 02 00 00 00       	mov    $0x2,%eax
  800e8c:	89 d1                	mov    %edx,%ecx
  800e8e:	89 d3                	mov    %edx,%ebx
  800e90:	89 d7                	mov    %edx,%edi
  800e92:	89 d6                	mov    %edx,%esi
  800e94:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_yield>:

void
sys_yield(void)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eab:	89 d1                	mov    %edx,%ecx
  800ead:	89 d3                	mov    %edx,%ebx
  800eaf:	89 d7                	mov    %edx,%edi
  800eb1:	89 d6                	mov    %edx,%esi
  800eb3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec3:	be 00 00 00 00       	mov    $0x0,%esi
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ece:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed6:	89 f7                	mov    %esi,%edi
  800ed8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eda:	85 c0                	test   %eax,%eax
  800edc:	7f 08                	jg     800ee6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	6a 04                	push   $0x4
  800eec:	68 ff 26 80 00       	push   $0x8026ff
  800ef1:	6a 23                	push   $0x23
  800ef3:	68 1c 27 80 00       	push   $0x80271c
  800ef8:	e8 21 f4 ff ff       	call   80031e <_panic>

00800efd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0c:	b8 05 00 00 00       	mov    $0x5,%eax
  800f11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f17:	8b 75 18             	mov    0x18(%ebp),%esi
  800f1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7f 08                	jg     800f28 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f28:	83 ec 0c             	sub    $0xc,%esp
  800f2b:	50                   	push   %eax
  800f2c:	6a 05                	push   $0x5
  800f2e:	68 ff 26 80 00       	push   $0x8026ff
  800f33:	6a 23                	push   $0x23
  800f35:	68 1c 27 80 00       	push   $0x80271c
  800f3a:	e8 df f3 ff ff       	call   80031e <_panic>

00800f3f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f53:	b8 06 00 00 00       	mov    $0x6,%eax
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	89 de                	mov    %ebx,%esi
  800f5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7f 08                	jg     800f6a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	50                   	push   %eax
  800f6e:	6a 06                	push   $0x6
  800f70:	68 ff 26 80 00       	push   $0x8026ff
  800f75:	6a 23                	push   $0x23
  800f77:	68 1c 27 80 00       	push   $0x80271c
  800f7c:	e8 9d f3 ff ff       	call   80031e <_panic>

00800f81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	b8 08 00 00 00       	mov    $0x8,%eax
  800f9a:	89 df                	mov    %ebx,%edi
  800f9c:	89 de                	mov    %ebx,%esi
  800f9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	7f 08                	jg     800fac <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fac:	83 ec 0c             	sub    $0xc,%esp
  800faf:	50                   	push   %eax
  800fb0:	6a 08                	push   $0x8
  800fb2:	68 ff 26 80 00       	push   $0x8026ff
  800fb7:	6a 23                	push   $0x23
  800fb9:	68 1c 27 80 00       	push   $0x80271c
  800fbe:	e8 5b f3 ff ff       	call   80031e <_panic>

00800fc3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	b8 09 00 00 00       	mov    $0x9,%eax
  800fdc:	89 df                	mov    %ebx,%edi
  800fde:	89 de                	mov    %ebx,%esi
  800fe0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	7f 08                	jg     800fee <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fee:	83 ec 0c             	sub    $0xc,%esp
  800ff1:	50                   	push   %eax
  800ff2:	6a 09                	push   $0x9
  800ff4:	68 ff 26 80 00       	push   $0x8026ff
  800ff9:	6a 23                	push   $0x23
  800ffb:	68 1c 27 80 00       	push   $0x80271c
  801000:	e8 19 f3 ff ff       	call   80031e <_panic>

00801005 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	b8 0a 00 00 00       	mov    $0xa,%eax
  80101e:	89 df                	mov    %ebx,%edi
  801020:	89 de                	mov    %ebx,%esi
  801022:	cd 30                	int    $0x30
	if(check && ret > 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	7f 08                	jg     801030 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  801034:	6a 0a                	push   $0xa
  801036:	68 ff 26 80 00       	push   $0x8026ff
  80103b:	6a 23                	push   $0x23
  80103d:	68 1c 27 80 00       	push   $0x80271c
  801042:	e8 d7 f2 ff ff       	call   80031e <_panic>

00801047 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	b8 0c 00 00 00       	mov    $0xc,%eax
  801058:	be 00 00 00 00       	mov    $0x0,%esi
  80105d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801060:	8b 7d 14             	mov    0x14(%ebp),%edi
  801063:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801073:	b9 00 00 00 00       	mov    $0x0,%ecx
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801080:	89 cb                	mov    %ecx,%ebx
  801082:	89 cf                	mov    %ecx,%edi
  801084:	89 ce                	mov    %ecx,%esi
  801086:	cd 30                	int    $0x30
	if(check && ret > 0)
  801088:	85 c0                	test   %eax,%eax
  80108a:	7f 08                	jg     801094 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 0d                	push   $0xd
  80109a:	68 ff 26 80 00       	push   $0x8026ff
  80109f:	6a 23                	push   $0x23
  8010a1:	68 1c 27 80 00       	push   $0x80271c
  8010a6:	e8 73 f2 ff ff       	call   80031e <_panic>

008010ab <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010b7:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8010b9:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010bc:	83 3a 01             	cmpl   $0x1,(%edx)
  8010bf:	7e 09                	jle    8010ca <argstart+0x1f>
  8010c1:	ba 25 28 80 00       	mov    $0x802825,%edx
  8010c6:	85 c9                	test   %ecx,%ecx
  8010c8:	75 05                	jne    8010cf <argstart+0x24>
  8010ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cf:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8010d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <argnext>:

int
argnext(struct Argstate *args)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	53                   	push   %ebx
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010e5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010ec:	8b 43 08             	mov    0x8(%ebx),%eax
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	74 74                	je     801167 <argnext+0x8c>
		return -1;

	if (!*args->curarg) {
  8010f3:	80 38 00             	cmpb   $0x0,(%eax)
  8010f6:	75 48                	jne    801140 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010f8:	8b 0b                	mov    (%ebx),%ecx
  8010fa:	83 39 01             	cmpl   $0x1,(%ecx)
  8010fd:	74 5a                	je     801159 <argnext+0x7e>
		    || args->argv[1][0] != '-'
  8010ff:	8b 53 04             	mov    0x4(%ebx),%edx
  801102:	8b 42 04             	mov    0x4(%edx),%eax
  801105:	80 38 2d             	cmpb   $0x2d,(%eax)
  801108:	75 4f                	jne    801159 <argnext+0x7e>
		    || args->argv[1][1] == '\0')
  80110a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80110e:	74 49                	je     801159 <argnext+0x7e>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801110:	83 c0 01             	add    $0x1,%eax
  801113:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	8b 01                	mov    (%ecx),%eax
  80111b:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801122:	50                   	push   %eax
  801123:	8d 42 08             	lea    0x8(%edx),%eax
  801126:	50                   	push   %eax
  801127:	83 c2 04             	add    $0x4,%edx
  80112a:	52                   	push   %edx
  80112b:	e8 24 fb ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  801130:	8b 03                	mov    (%ebx),%eax
  801132:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801135:	8b 43 08             	mov    0x8(%ebx),%eax
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80113e:	74 13                	je     801153 <argnext+0x78>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801140:	8b 43 08             	mov    0x8(%ebx),%eax
  801143:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801146:	83 c0 01             	add    $0x1,%eax
  801149:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80114c:	89 d0                	mov    %edx,%eax
  80114e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801151:	c9                   	leave  
  801152:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801153:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801157:	75 e7                	jne    801140 <argnext+0x65>
	args->curarg = 0;
  801159:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801160:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801165:	eb e5                	jmp    80114c <argnext+0x71>
		return -1;
  801167:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80116c:	eb de                	jmp    80114c <argnext+0x71>

0080116e <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	53                   	push   %ebx
  801172:	83 ec 04             	sub    $0x4,%esp
  801175:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801178:	8b 43 08             	mov    0x8(%ebx),%eax
  80117b:	85 c0                	test   %eax,%eax
  80117d:	74 12                	je     801191 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  80117f:	80 38 00             	cmpb   $0x0,(%eax)
  801182:	74 12                	je     801196 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801184:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801187:	c7 43 08 25 28 80 00 	movl   $0x802825,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80118e:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801194:	c9                   	leave  
  801195:	c3                   	ret    
	} else if (*args->argc > 1) {
  801196:	8b 13                	mov    (%ebx),%edx
  801198:	83 3a 01             	cmpl   $0x1,(%edx)
  80119b:	7f 10                	jg     8011ad <argnextvalue+0x3f>
		args->argvalue = 0;
  80119d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011a4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011ab:	eb e1                	jmp    80118e <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8011ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8011b0:	8b 48 04             	mov    0x4(%eax),%ecx
  8011b3:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011b6:	83 ec 04             	sub    $0x4,%esp
  8011b9:	8b 12                	mov    (%edx),%edx
  8011bb:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011c2:	52                   	push   %edx
  8011c3:	8d 50 08             	lea    0x8(%eax),%edx
  8011c6:	52                   	push   %edx
  8011c7:	83 c0 04             	add    $0x4,%eax
  8011ca:	50                   	push   %eax
  8011cb:	e8 84 fa ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  8011d0:	8b 03                	mov    (%ebx),%eax
  8011d2:	83 28 01             	subl   $0x1,(%eax)
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	eb b4                	jmp    80118e <argnextvalue+0x20>

008011da <argvalue>:
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 08             	sub    $0x8,%esp
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011e3:	8b 42 0c             	mov    0xc(%edx),%eax
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	74 02                	je     8011ec <argvalue+0x12>
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011ec:	83 ec 0c             	sub    $0xc,%esp
  8011ef:	52                   	push   %edx
  8011f0:	e8 79 ff ff ff       	call   80116e <argnextvalue>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	eb f0                	jmp    8011ea <argvalue+0x10>

008011fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	05 00 00 00 30       	add    $0x30000000,%eax
  801205:	c1 e8 0c             	shr    $0xc,%eax
}
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801215:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80121a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801229:	89 c2                	mov    %eax,%edx
  80122b:	c1 ea 16             	shr    $0x16,%edx
  80122e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801235:	f6 c2 01             	test   $0x1,%dl
  801238:	74 29                	je     801263 <fd_alloc+0x42>
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	c1 ea 0c             	shr    $0xc,%edx
  80123f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801246:	f6 c2 01             	test   $0x1,%dl
  801249:	74 18                	je     801263 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80124b:	05 00 10 00 00       	add    $0x1000,%eax
  801250:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801255:	75 d2                	jne    801229 <fd_alloc+0x8>
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  80125c:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801261:	eb 05                	jmp    801268 <fd_alloc+0x47>
			return 0;
  801263:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  801268:	8b 55 08             	mov    0x8(%ebp),%edx
  80126b:	89 02                	mov    %eax,(%edx)
}
  80126d:	89 c8                	mov    %ecx,%eax
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    

00801271 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801277:	83 f8 1f             	cmp    $0x1f,%eax
  80127a:	77 30                	ja     8012ac <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80127c:	c1 e0 0c             	shl    $0xc,%eax
  80127f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801284:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80128a:	f6 c2 01             	test   $0x1,%dl
  80128d:	74 24                	je     8012b3 <fd_lookup+0x42>
  80128f:	89 c2                	mov    %eax,%edx
  801291:	c1 ea 0c             	shr    $0xc,%edx
  801294:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129b:	f6 c2 01             	test   $0x1,%dl
  80129e:	74 1a                	je     8012ba <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    
		return -E_INVAL;
  8012ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b1:	eb f7                	jmp    8012aa <fd_lookup+0x39>
		return -E_INVAL;
  8012b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b8:	eb f0                	jmp    8012aa <fd_lookup+0x39>
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb e9                	jmp    8012aa <fd_lookup+0x39>

008012c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 04             	sub    $0x4,%esp
  8012c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cb:	b8 a8 27 80 00       	mov    $0x8027a8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  8012d0:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  8012d5:	39 13                	cmp    %edx,(%ebx)
  8012d7:	74 32                	je     80130b <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  8012d9:	83 c0 04             	add    $0x4,%eax
  8012dc:	8b 18                	mov    (%eax),%ebx
  8012de:	85 db                	test   %ebx,%ebx
  8012e0:	75 f3                	jne    8012d5 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012e2:	a1 00 44 80 00       	mov    0x804400,%eax
  8012e7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	52                   	push   %edx
  8012ee:	50                   	push   %eax
  8012ef:	68 2c 27 80 00       	push   $0x80272c
  8012f4:	e8 00 f1 ff ff       	call   8003f9 <cprintf>
	*dev = 0;
	return -E_INVAL;
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801301:	8b 55 0c             	mov    0xc(%ebp),%edx
  801304:	89 1a                	mov    %ebx,(%edx)
}
  801306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801309:	c9                   	leave  
  80130a:	c3                   	ret    
			return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
  801310:	eb ef                	jmp    801301 <dev_lookup+0x40>

00801312 <fd_close>:
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 24             	sub    $0x24,%esp
  80131b:	8b 75 08             	mov    0x8(%ebp),%esi
  80131e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801321:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801324:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801325:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80132b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132e:	50                   	push   %eax
  80132f:	e8 3d ff ff ff       	call   801271 <fd_lookup>
  801334:	89 c3                	mov    %eax,%ebx
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 05                	js     801342 <fd_close+0x30>
	    || fd != fd2)
  80133d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801340:	74 16                	je     801358 <fd_close+0x46>
		return (must_exist ? r : 0);
  801342:	89 f8                	mov    %edi,%eax
  801344:	84 c0                	test   %al,%al
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	0f 44 d8             	cmove  %eax,%ebx
}
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801353:	5b                   	pop    %ebx
  801354:	5e                   	pop    %esi
  801355:	5f                   	pop    %edi
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	ff 36                	push   (%esi)
  801361:	e8 5b ff ff ff       	call   8012c1 <dev_lookup>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 1a                	js     801389 <fd_close+0x77>
		if (dev->dev_close)
  80136f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801372:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801375:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80137a:	85 c0                	test   %eax,%eax
  80137c:	74 0b                	je     801389 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	56                   	push   %esi
  801382:	ff d0                	call   *%eax
  801384:	89 c3                	mov    %eax,%ebx
  801386:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	56                   	push   %esi
  80138d:	6a 00                	push   $0x0
  80138f:	e8 ab fb ff ff       	call   800f3f <sys_page_unmap>
	return r;
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	eb b5                	jmp    80134e <fd_close+0x3c>

00801399 <close>:

int
close(int fdnum)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	ff 75 08             	push   0x8(%ebp)
  8013a6:	e8 c6 fe ff ff       	call   801271 <fd_lookup>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	79 02                	jns    8013b4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    
		return fd_close(fd, 1);
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	6a 01                	push   $0x1
  8013b9:	ff 75 f4             	push   -0xc(%ebp)
  8013bc:	e8 51 ff ff ff       	call   801312 <fd_close>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	eb ec                	jmp    8013b2 <close+0x19>

008013c6 <close_all>:

void
close_all(void)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	53                   	push   %ebx
  8013d6:	e8 be ff ff ff       	call   801399 <close>
	for (i = 0; i < MAXFD; i++)
  8013db:	83 c3 01             	add    $0x1,%ebx
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	83 fb 20             	cmp    $0x20,%ebx
  8013e4:	75 ec                	jne    8013d2 <close_all+0xc>
}
  8013e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	57                   	push   %edi
  8013ef:	56                   	push   %esi
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 08             	push   0x8(%ebp)
  8013fb:	e8 71 fe ff ff       	call   801271 <fd_lookup>
  801400:	89 c3                	mov    %eax,%ebx
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 7f                	js     801488 <dup+0x9d>
		return r;
	close(newfdnum);
  801409:	83 ec 0c             	sub    $0xc,%esp
  80140c:	ff 75 0c             	push   0xc(%ebp)
  80140f:	e8 85 ff ff ff       	call   801399 <close>

	newfd = INDEX2FD(newfdnum);
  801414:	8b 75 0c             	mov    0xc(%ebp),%esi
  801417:	c1 e6 0c             	shl    $0xc,%esi
  80141a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801423:	89 3c 24             	mov    %edi,(%esp)
  801426:	e8 df fd ff ff       	call   80120a <fd2data>
  80142b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80142d:	89 34 24             	mov    %esi,(%esp)
  801430:	e8 d5 fd ff ff       	call   80120a <fd2data>
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80143b:	89 d8                	mov    %ebx,%eax
  80143d:	c1 e8 16             	shr    $0x16,%eax
  801440:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801447:	a8 01                	test   $0x1,%al
  801449:	74 11                	je     80145c <dup+0x71>
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	c1 e8 0c             	shr    $0xc,%eax
  801450:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801457:	f6 c2 01             	test   $0x1,%dl
  80145a:	75 36                	jne    801492 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145c:	89 f8                	mov    %edi,%eax
  80145e:	c1 e8 0c             	shr    $0xc,%eax
  801461:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801468:	83 ec 0c             	sub    $0xc,%esp
  80146b:	25 07 0e 00 00       	and    $0xe07,%eax
  801470:	50                   	push   %eax
  801471:	56                   	push   %esi
  801472:	6a 00                	push   $0x0
  801474:	57                   	push   %edi
  801475:	6a 00                	push   $0x0
  801477:	e8 81 fa ff ff       	call   800efd <sys_page_map>
  80147c:	89 c3                	mov    %eax,%ebx
  80147e:	83 c4 20             	add    $0x20,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 33                	js     8014b8 <dup+0xcd>
		goto err;

	return newfdnum;
  801485:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5e                   	pop    %esi
  80148f:	5f                   	pop    %edi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801492:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a1:	50                   	push   %eax
  8014a2:	ff 75 d4             	push   -0x2c(%ebp)
  8014a5:	6a 00                	push   $0x0
  8014a7:	53                   	push   %ebx
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 4e fa ff ff       	call   800efd <sys_page_map>
  8014af:	89 c3                	mov    %eax,%ebx
  8014b1:	83 c4 20             	add    $0x20,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	79 a4                	jns    80145c <dup+0x71>
	sys_page_unmap(0, newfd);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	56                   	push   %esi
  8014bc:	6a 00                	push   $0x0
  8014be:	e8 7c fa ff ff       	call   800f3f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c3:	83 c4 08             	add    $0x8,%esp
  8014c6:	ff 75 d4             	push   -0x2c(%ebp)
  8014c9:	6a 00                	push   $0x0
  8014cb:	e8 6f fa ff ff       	call   800f3f <sys_page_unmap>
	return r;
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	eb b3                	jmp    801488 <dup+0x9d>

008014d5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 18             	sub    $0x18,%esp
  8014dd:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	56                   	push   %esi
  8014e5:	e8 87 fd ff ff       	call   801271 <fd_lookup>
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	78 3c                	js     80152d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f1:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fa:	50                   	push   %eax
  8014fb:	ff 33                	push   (%ebx)
  8014fd:	e8 bf fd ff ff       	call   8012c1 <dev_lookup>
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	78 24                	js     80152d <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801509:	8b 43 08             	mov    0x8(%ebx),%eax
  80150c:	83 e0 03             	and    $0x3,%eax
  80150f:	83 f8 01             	cmp    $0x1,%eax
  801512:	74 20                	je     801534 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	8b 40 08             	mov    0x8(%eax),%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 37                	je     801555 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	ff 75 10             	push   0x10(%ebp)
  801524:	ff 75 0c             	push   0xc(%ebp)
  801527:	53                   	push   %ebx
  801528:	ff d0                	call   *%eax
  80152a:	83 c4 10             	add    $0x10,%esp
}
  80152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801534:	a1 00 44 80 00       	mov    0x804400,%eax
  801539:	8b 40 48             	mov    0x48(%eax),%eax
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	56                   	push   %esi
  801540:	50                   	push   %eax
  801541:	68 6d 27 80 00       	push   $0x80276d
  801546:	e8 ae ee ff ff       	call   8003f9 <cprintf>
		return -E_INVAL;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801553:	eb d8                	jmp    80152d <read+0x58>
		return -E_NOT_SUPP;
  801555:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155a:	eb d1                	jmp    80152d <read+0x58>

0080155c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	8b 7d 08             	mov    0x8(%ebp),%edi
  801568:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801570:	eb 02                	jmp    801574 <readn+0x18>
  801572:	01 c3                	add    %eax,%ebx
  801574:	39 f3                	cmp    %esi,%ebx
  801576:	73 21                	jae    801599 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	89 f0                	mov    %esi,%eax
  80157d:	29 d8                	sub    %ebx,%eax
  80157f:	50                   	push   %eax
  801580:	89 d8                	mov    %ebx,%eax
  801582:	03 45 0c             	add    0xc(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	57                   	push   %edi
  801587:	e8 49 ff ff ff       	call   8014d5 <read>
		if (m < 0)
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 04                	js     801597 <readn+0x3b>
			return m;
		if (m == 0)
  801593:	75 dd                	jne    801572 <readn+0x16>
  801595:	eb 02                	jmp    801599 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801597:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801599:	89 d8                	mov    %ebx,%eax
  80159b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5f                   	pop    %edi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 18             	sub    $0x18,%esp
  8015ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	53                   	push   %ebx
  8015b3:	e8 b9 fc ff ff       	call   801271 <fd_lookup>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 37                	js     8015f6 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bf:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	ff 36                	push   (%esi)
  8015cb:	e8 f1 fc ff ff       	call   8012c1 <dev_lookup>
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 1f                	js     8015f6 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d7:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8015db:	74 20                	je     8015fd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	74 37                	je     80161e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	ff 75 10             	push   0x10(%ebp)
  8015ed:	ff 75 0c             	push   0xc(%ebp)
  8015f0:	56                   	push   %esi
  8015f1:	ff d0                	call   *%eax
  8015f3:	83 c4 10             	add    $0x10,%esp
}
  8015f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fd:	a1 00 44 80 00       	mov    0x804400,%eax
  801602:	8b 40 48             	mov    0x48(%eax),%eax
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	53                   	push   %ebx
  801609:	50                   	push   %eax
  80160a:	68 89 27 80 00       	push   $0x802789
  80160f:	e8 e5 ed ff ff       	call   8003f9 <cprintf>
		return -E_INVAL;
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb d8                	jmp    8015f6 <write+0x53>
		return -E_NOT_SUPP;
  80161e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801623:	eb d1                	jmp    8015f6 <write+0x53>

00801625 <seek>:

int
seek(int fdnum, off_t offset)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	ff 75 08             	push   0x8(%ebp)
  801632:	e8 3a fc ff ff       	call   801271 <fd_lookup>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 0e                	js     80164c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	83 ec 18             	sub    $0x18,%esp
  801656:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801659:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165c:	50                   	push   %eax
  80165d:	53                   	push   %ebx
  80165e:	e8 0e fc ff ff       	call   801271 <fd_lookup>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 34                	js     80169e <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801673:	50                   	push   %eax
  801674:	ff 36                	push   (%esi)
  801676:	e8 46 fc ff ff       	call   8012c1 <dev_lookup>
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 1c                	js     80169e <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801682:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  801686:	74 1d                	je     8016a5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	8b 40 18             	mov    0x18(%eax),%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 34                	je     8016c6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	ff 75 0c             	push   0xc(%ebp)
  801698:	56                   	push   %esi
  801699:	ff d0                	call   *%eax
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016a5:	a1 00 44 80 00       	mov    0x804400,%eax
  8016aa:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	53                   	push   %ebx
  8016b1:	50                   	push   %eax
  8016b2:	68 4c 27 80 00       	push   $0x80274c
  8016b7:	e8 3d ed ff ff       	call   8003f9 <cprintf>
		return -E_INVAL;
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c4:	eb d8                	jmp    80169e <ftruncate+0x50>
		return -E_NOT_SUPP;
  8016c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cb:	eb d1                	jmp    80169e <ftruncate+0x50>

008016cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 18             	sub    $0x18,%esp
  8016d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	ff 75 08             	push   0x8(%ebp)
  8016df:	e8 8d fb ff ff       	call   801271 <fd_lookup>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 49                	js     801734 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016eb:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	ff 36                	push   (%esi)
  8016f7:	e8 c5 fb ff ff       	call   8012c1 <dev_lookup>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 31                	js     801734 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801706:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80170a:	74 2f                	je     80173b <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80170c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801716:	00 00 00 
	stat->st_isdir = 0;
  801719:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801720:	00 00 00 
	stat->st_dev = dev;
  801723:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	53                   	push   %ebx
  80172d:	56                   	push   %esi
  80172e:	ff 50 14             	call   *0x14(%eax)
  801731:	83 c4 10             	add    $0x10,%esp
}
  801734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    
		return -E_NOT_SUPP;
  80173b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801740:	eb f2                	jmp    801734 <fstat+0x67>

00801742 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	56                   	push   %esi
  801746:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 08             	push   0x8(%ebp)
  80174f:	e8 22 02 00 00       	call   801976 <open>
  801754:	89 c3                	mov    %eax,%ebx
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 1b                	js     801778 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	ff 75 0c             	push   0xc(%ebp)
  801763:	50                   	push   %eax
  801764:	e8 64 ff ff ff       	call   8016cd <fstat>
  801769:	89 c6                	mov    %eax,%esi
	close(fd);
  80176b:	89 1c 24             	mov    %ebx,(%esp)
  80176e:	e8 26 fc ff ff       	call   801399 <close>
	return r;
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	89 f3                	mov    %esi,%ebx
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	89 c6                	mov    %eax,%esi
  801788:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80178a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801791:	74 27                	je     8017ba <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801793:	6a 07                	push   $0x7
  801795:	68 00 50 80 00       	push   $0x805000
  80179a:	56                   	push   %esi
  80179b:	ff 35 00 60 80 00    	push   0x806000
  8017a1:	e8 95 08 00 00       	call   80203b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a6:	83 c4 0c             	add    $0xc,%esp
  8017a9:	6a 00                	push   $0x0
  8017ab:	53                   	push   %ebx
  8017ac:	6a 00                	push   $0x0
  8017ae:	e8 39 08 00 00       	call   801fec <ipc_recv>
}
  8017b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	6a 01                	push   $0x1
  8017bf:	e8 c3 08 00 00       	call   802087 <ipc_find_env>
  8017c4:	a3 00 60 80 00       	mov    %eax,0x806000
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	eb c5                	jmp    801793 <fsipc+0x12>

008017ce <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017da:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f1:	e8 8b ff ff ff       	call   801781 <fsipc>
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <devfile_flush>:
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8b 40 0c             	mov    0xc(%eax),%eax
  801804:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801809:	ba 00 00 00 00       	mov    $0x0,%edx
  80180e:	b8 06 00 00 00       	mov    $0x6,%eax
  801813:	e8 69 ff ff ff       	call   801781 <fsipc>
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <devfile_stat>:
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	53                   	push   %ebx
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8b 40 0c             	mov    0xc(%eax),%eax
  80182a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182f:	ba 00 00 00 00       	mov    $0x0,%edx
  801834:	b8 05 00 00 00       	mov    $0x5,%eax
  801839:	e8 43 ff ff ff       	call   801781 <fsipc>
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 2c                	js     80186e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	68 00 50 80 00       	push   $0x805000
  80184a:	53                   	push   %ebx
  80184b:	e8 6e f2 ff ff       	call   800abe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801850:	a1 80 50 80 00       	mov    0x805080,%eax
  801855:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80185b:	a1 84 50 80 00       	mov    0x805084,%eax
  801860:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <devfile_write>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801888:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80188e:	53                   	push   %ebx
  80188f:	ff 75 0c             	push   0xc(%ebp)
  801892:	68 08 50 80 00       	push   $0x805008
  801897:	e8 1a f4 ff ff       	call   800cb6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80189c:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a1:	b8 04 00 00 00       	mov    $0x4,%eax
  8018a6:	e8 d6 fe ff ff       	call   801781 <fsipc>
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 0b                	js     8018bd <devfile_write+0x4a>
	assert(r <= n);
  8018b2:	39 d8                	cmp    %ebx,%eax
  8018b4:	77 0c                	ja     8018c2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018b6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018bb:	7f 1e                	jg     8018db <devfile_write+0x68>
}
  8018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    
	assert(r <= n);
  8018c2:	68 b8 27 80 00       	push   $0x8027b8
  8018c7:	68 bf 27 80 00       	push   $0x8027bf
  8018cc:	68 97 00 00 00       	push   $0x97
  8018d1:	68 d4 27 80 00       	push   $0x8027d4
  8018d6:	e8 43 ea ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  8018db:	68 df 27 80 00       	push   $0x8027df
  8018e0:	68 bf 27 80 00       	push   $0x8027bf
  8018e5:	68 98 00 00 00       	push   $0x98
  8018ea:	68 d4 27 80 00       	push   $0x8027d4
  8018ef:	e8 2a ea ff ff       	call   80031e <_panic>

008018f4 <devfile_read>:
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
  8018f9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801902:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801907:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
  801912:	b8 03 00 00 00       	mov    $0x3,%eax
  801917:	e8 65 fe ff ff       	call   801781 <fsipc>
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 1f                	js     801941 <devfile_read+0x4d>
	assert(r <= n);
  801922:	39 f0                	cmp    %esi,%eax
  801924:	77 24                	ja     80194a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801926:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80192b:	7f 33                	jg     801960 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	50                   	push   %eax
  801931:	68 00 50 80 00       	push   $0x805000
  801936:	ff 75 0c             	push   0xc(%ebp)
  801939:	e8 16 f3 ff ff       	call   800c54 <memmove>
	return r;
  80193e:	83 c4 10             	add    $0x10,%esp
}
  801941:	89 d8                	mov    %ebx,%eax
  801943:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    
	assert(r <= n);
  80194a:	68 b8 27 80 00       	push   $0x8027b8
  80194f:	68 bf 27 80 00       	push   $0x8027bf
  801954:	6a 7c                	push   $0x7c
  801956:	68 d4 27 80 00       	push   $0x8027d4
  80195b:	e8 be e9 ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  801960:	68 df 27 80 00       	push   $0x8027df
  801965:	68 bf 27 80 00       	push   $0x8027bf
  80196a:	6a 7d                	push   $0x7d
  80196c:	68 d4 27 80 00       	push   $0x8027d4
  801971:	e8 a8 e9 ff ff       	call   80031e <_panic>

00801976 <open>:
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	83 ec 1c             	sub    $0x1c,%esp
  80197e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801981:	56                   	push   %esi
  801982:	e8 fc f0 ff ff       	call   800a83 <strlen>
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80198f:	7f 6c                	jg     8019fd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 84 f8 ff ff       	call   801221 <fd_alloc>
  80199d:	89 c3                	mov    %eax,%ebx
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 3c                	js     8019e2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	56                   	push   %esi
  8019aa:	68 00 50 80 00       	push   $0x805000
  8019af:	e8 0a f1 ff ff       	call   800abe <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c4:	e8 b8 fd ff ff       	call   801781 <fsipc>
  8019c9:	89 c3                	mov    %eax,%ebx
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 19                	js     8019eb <open+0x75>
	return fd2num(fd);
  8019d2:	83 ec 0c             	sub    $0xc,%esp
  8019d5:	ff 75 f4             	push   -0xc(%ebp)
  8019d8:	e8 1d f8 ff ff       	call   8011fa <fd2num>
  8019dd:	89 c3                	mov    %eax,%ebx
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	89 d8                	mov    %ebx,%eax
  8019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5e                   	pop    %esi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    
		fd_close(fd, 0);
  8019eb:	83 ec 08             	sub    $0x8,%esp
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 f4             	push   -0xc(%ebp)
  8019f3:	e8 1a f9 ff ff       	call   801312 <fd_close>
		return r;
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	eb e5                	jmp    8019e2 <open+0x6c>
		return -E_BAD_PATH;
  8019fd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a02:	eb de                	jmp    8019e2 <open+0x6c>

00801a04 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a14:	e8 68 fd ff ff       	call   801781 <fsipc>
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a1b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a1f:	7f 01                	jg     801a22 <writebuf+0x7>
  801a21:	c3                   	ret    
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	53                   	push   %ebx
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a2b:	ff 70 04             	push   0x4(%eax)
  801a2e:	8d 40 10             	lea    0x10(%eax),%eax
  801a31:	50                   	push   %eax
  801a32:	ff 33                	push   (%ebx)
  801a34:	e8 6a fb ff ff       	call   8015a3 <write>
		if (result > 0)
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	7e 03                	jle    801a43 <writebuf+0x28>
			b->result += result;
  801a40:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a43:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a46:	74 0d                	je     801a55 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	0f 4f c2             	cmovg  %edx,%eax
  801a52:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <putch>:

static void
putch(int ch, void *thunk)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a64:	8b 53 04             	mov    0x4(%ebx),%edx
  801a67:	8d 42 01             	lea    0x1(%edx),%eax
  801a6a:	89 43 04             	mov    %eax,0x4(%ebx)
  801a6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a70:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a74:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a79:	74 05                	je     801a80 <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  801a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    
		writebuf(b);
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	e8 94 ff ff ff       	call   801a1b <writebuf>
		b->idx = 0;
  801a87:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a8e:	eb eb                	jmp    801a7b <putch+0x21>

00801a90 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801aa2:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801aa9:	00 00 00 
	b.result = 0;
  801aac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ab3:	00 00 00 
	b.error = 1;
  801ab6:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801abd:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ac0:	ff 75 10             	push   0x10(%ebp)
  801ac3:	ff 75 0c             	push   0xc(%ebp)
  801ac6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801acc:	50                   	push   %eax
  801acd:	68 5a 1a 80 00       	push   $0x801a5a
  801ad2:	e8 19 ea ff ff       	call   8004f0 <vprintfmt>
	if (b.idx > 0)
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ae1:	7f 11                	jg     801af4 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801ae3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    
		writebuf(&b);
  801af4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801afa:	e8 1c ff ff ff       	call   801a1b <writebuf>
  801aff:	eb e2                	jmp    801ae3 <vfprintf+0x53>

00801b01 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b0a:	50                   	push   %eax
  801b0b:	ff 75 0c             	push   0xc(%ebp)
  801b0e:	ff 75 08             	push   0x8(%ebp)
  801b11:	e8 7a ff ff ff       	call   801a90 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <printf>:

int
printf(const char *fmt, ...)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b1e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b21:	50                   	push   %eax
  801b22:	ff 75 08             	push   0x8(%ebp)
  801b25:	6a 01                	push   $0x1
  801b27:	e8 64 ff ff ff       	call   801a90 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	56                   	push   %esi
  801b32:	53                   	push   %ebx
  801b33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	ff 75 08             	push   0x8(%ebp)
  801b3c:	e8 c9 f6 ff ff       	call   80120a <fd2data>
  801b41:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b43:	83 c4 08             	add    $0x8,%esp
  801b46:	68 eb 27 80 00       	push   $0x8027eb
  801b4b:	53                   	push   %ebx
  801b4c:	e8 6d ef ff ff       	call   800abe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b51:	8b 46 04             	mov    0x4(%esi),%eax
  801b54:	2b 06                	sub    (%esi),%eax
  801b56:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b5c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b63:	00 00 00 
	stat->st_dev = &devpipe;
  801b66:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b6d:	30 80 00 
	return 0;
}
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
  801b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b86:	53                   	push   %ebx
  801b87:	6a 00                	push   $0x0
  801b89:	e8 b1 f3 ff ff       	call   800f3f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b8e:	89 1c 24             	mov    %ebx,(%esp)
  801b91:	e8 74 f6 ff ff       	call   80120a <fd2data>
  801b96:	83 c4 08             	add    $0x8,%esp
  801b99:	50                   	push   %eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	e8 9e f3 ff ff       	call   800f3f <sys_page_unmap>
}
  801ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <_pipeisclosed>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 1c             	sub    $0x1c,%esp
  801baf:	89 c7                	mov    %eax,%edi
  801bb1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bb3:	a1 00 44 80 00       	mov    0x804400,%eax
  801bb8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	57                   	push   %edi
  801bbf:	e8 fc 04 00 00       	call   8020c0 <pageref>
  801bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc7:	89 34 24             	mov    %esi,(%esp)
  801bca:	e8 f1 04 00 00       	call   8020c0 <pageref>
		nn = thisenv->env_runs;
  801bcf:	8b 15 00 44 80 00    	mov    0x804400,%edx
  801bd5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	39 cb                	cmp    %ecx,%ebx
  801bdd:	74 1b                	je     801bfa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bdf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801be2:	75 cf                	jne    801bb3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801be4:	8b 42 58             	mov    0x58(%edx),%eax
  801be7:	6a 01                	push   $0x1
  801be9:	50                   	push   %eax
  801bea:	53                   	push   %ebx
  801beb:	68 f2 27 80 00       	push   $0x8027f2
  801bf0:	e8 04 e8 ff ff       	call   8003f9 <cprintf>
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	eb b9                	jmp    801bb3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bfa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bfd:	0f 94 c0             	sete   %al
  801c00:	0f b6 c0             	movzbl %al,%eax
}
  801c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5f                   	pop    %edi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    

00801c0b <devpipe_write>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	57                   	push   %edi
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	83 ec 28             	sub    $0x28,%esp
  801c14:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c17:	56                   	push   %esi
  801c18:	e8 ed f5 ff ff       	call   80120a <fd2data>
  801c1d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	bf 00 00 00 00       	mov    $0x0,%edi
  801c27:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c2a:	75 09                	jne    801c35 <devpipe_write+0x2a>
	return i;
  801c2c:	89 f8                	mov    %edi,%eax
  801c2e:	eb 23                	jmp    801c53 <devpipe_write+0x48>
			sys_yield();
  801c30:	e8 66 f2 ff ff       	call   800e9b <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c35:	8b 43 04             	mov    0x4(%ebx),%eax
  801c38:	8b 0b                	mov    (%ebx),%ecx
  801c3a:	8d 51 20             	lea    0x20(%ecx),%edx
  801c3d:	39 d0                	cmp    %edx,%eax
  801c3f:	72 1a                	jb     801c5b <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801c41:	89 da                	mov    %ebx,%edx
  801c43:	89 f0                	mov    %esi,%eax
  801c45:	e8 5c ff ff ff       	call   801ba6 <_pipeisclosed>
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	74 e2                	je     801c30 <devpipe_write+0x25>
				return 0;
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5f                   	pop    %edi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c5e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c62:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c65:	89 c2                	mov    %eax,%edx
  801c67:	c1 fa 1f             	sar    $0x1f,%edx
  801c6a:	89 d1                	mov    %edx,%ecx
  801c6c:	c1 e9 1b             	shr    $0x1b,%ecx
  801c6f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c72:	83 e2 1f             	and    $0x1f,%edx
  801c75:	29 ca                	sub    %ecx,%edx
  801c77:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c7b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c7f:	83 c0 01             	add    $0x1,%eax
  801c82:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c85:	83 c7 01             	add    $0x1,%edi
  801c88:	eb 9d                	jmp    801c27 <devpipe_write+0x1c>

00801c8a <devpipe_read>:
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	57                   	push   %edi
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 18             	sub    $0x18,%esp
  801c93:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c96:	57                   	push   %edi
  801c97:	e8 6e f5 ff ff       	call   80120a <fd2data>
  801c9c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	be 00 00 00 00       	mov    $0x0,%esi
  801ca6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ca9:	75 13                	jne    801cbe <devpipe_read+0x34>
	return i;
  801cab:	89 f0                	mov    %esi,%eax
  801cad:	eb 02                	jmp    801cb1 <devpipe_read+0x27>
				return i;
  801caf:	89 f0                	mov    %esi,%eax
}
  801cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5f                   	pop    %edi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
			sys_yield();
  801cb9:	e8 dd f1 ff ff       	call   800e9b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cbe:	8b 03                	mov    (%ebx),%eax
  801cc0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc3:	75 18                	jne    801cdd <devpipe_read+0x53>
			if (i > 0)
  801cc5:	85 f6                	test   %esi,%esi
  801cc7:	75 e6                	jne    801caf <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801cc9:	89 da                	mov    %ebx,%edx
  801ccb:	89 f8                	mov    %edi,%eax
  801ccd:	e8 d4 fe ff ff       	call   801ba6 <_pipeisclosed>
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	74 e3                	je     801cb9 <devpipe_read+0x2f>
				return 0;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdb:	eb d4                	jmp    801cb1 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cdd:	99                   	cltd   
  801cde:	c1 ea 1b             	shr    $0x1b,%edx
  801ce1:	01 d0                	add    %edx,%eax
  801ce3:	83 e0 1f             	and    $0x1f,%eax
  801ce6:	29 d0                	sub    %edx,%eax
  801ce8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cf3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cf6:	83 c6 01             	add    $0x1,%esi
  801cf9:	eb ab                	jmp    801ca6 <devpipe_read+0x1c>

00801cfb <pipe>:
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	56                   	push   %esi
  801cff:	53                   	push   %ebx
  801d00:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d06:	50                   	push   %eax
  801d07:	e8 15 f5 ff ff       	call   801221 <fd_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	0f 88 23 01 00 00    	js     801e3c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	68 07 04 00 00       	push   $0x407
  801d21:	ff 75 f4             	push   -0xc(%ebp)
  801d24:	6a 00                	push   $0x0
  801d26:	e8 8f f1 ff ff       	call   800eba <sys_page_alloc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	0f 88 04 01 00 00    	js     801e3c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3e:	50                   	push   %eax
  801d3f:	e8 dd f4 ff ff       	call   801221 <fd_alloc>
  801d44:	89 c3                	mov    %eax,%ebx
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	0f 88 db 00 00 00    	js     801e2c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	68 07 04 00 00       	push   $0x407
  801d59:	ff 75 f0             	push   -0x10(%ebp)
  801d5c:	6a 00                	push   $0x0
  801d5e:	e8 57 f1 ff ff       	call   800eba <sys_page_alloc>
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	0f 88 bc 00 00 00    	js     801e2c <pipe+0x131>
	va = fd2data(fd0);
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	ff 75 f4             	push   -0xc(%ebp)
  801d76:	e8 8f f4 ff ff       	call   80120a <fd2data>
  801d7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7d:	83 c4 0c             	add    $0xc,%esp
  801d80:	68 07 04 00 00       	push   $0x407
  801d85:	50                   	push   %eax
  801d86:	6a 00                	push   $0x0
  801d88:	e8 2d f1 ff ff       	call   800eba <sys_page_alloc>
  801d8d:	89 c3                	mov    %eax,%ebx
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	85 c0                	test   %eax,%eax
  801d94:	0f 88 82 00 00 00    	js     801e1c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	ff 75 f0             	push   -0x10(%ebp)
  801da0:	e8 65 f4 ff ff       	call   80120a <fd2data>
  801da5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dac:	50                   	push   %eax
  801dad:	6a 00                	push   $0x0
  801daf:	56                   	push   %esi
  801db0:	6a 00                	push   $0x0
  801db2:	e8 46 f1 ff ff       	call   800efd <sys_page_map>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 20             	add    $0x20,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 4e                	js     801e0e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801dc0:	a1 20 30 80 00       	mov    0x803020,%eax
  801dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	ff 75 f4             	push   -0xc(%ebp)
  801de9:	e8 0c f4 ff ff       	call   8011fa <fd2num>
  801dee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801df3:	83 c4 04             	add    $0x4,%esp
  801df6:	ff 75 f0             	push   -0x10(%ebp)
  801df9:	e8 fc f3 ff ff       	call   8011fa <fd2num>
  801dfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e01:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e0c:	eb 2e                	jmp    801e3c <pipe+0x141>
	sys_page_unmap(0, va);
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	56                   	push   %esi
  801e12:	6a 00                	push   $0x0
  801e14:	e8 26 f1 ff ff       	call   800f3f <sys_page_unmap>
  801e19:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e1c:	83 ec 08             	sub    $0x8,%esp
  801e1f:	ff 75 f0             	push   -0x10(%ebp)
  801e22:	6a 00                	push   $0x0
  801e24:	e8 16 f1 ff ff       	call   800f3f <sys_page_unmap>
  801e29:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e2c:	83 ec 08             	sub    $0x8,%esp
  801e2f:	ff 75 f4             	push   -0xc(%ebp)
  801e32:	6a 00                	push   $0x0
  801e34:	e8 06 f1 ff ff       	call   800f3f <sys_page_unmap>
  801e39:	83 c4 10             	add    $0x10,%esp
}
  801e3c:	89 d8                	mov    %ebx,%eax
  801e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <pipeisclosed>:
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4e:	50                   	push   %eax
  801e4f:	ff 75 08             	push   0x8(%ebp)
  801e52:	e8 1a f4 ff ff       	call   801271 <fd_lookup>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 18                	js     801e76 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	ff 75 f4             	push   -0xc(%ebp)
  801e64:	e8 a1 f3 ff ff       	call   80120a <fd2data>
  801e69:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	e8 33 fd ff ff       	call   801ba6 <_pipeisclosed>
  801e73:	83 c4 10             	add    $0x10,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	c3                   	ret    

00801e7e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e84:	68 0a 28 80 00       	push   $0x80280a
  801e89:	ff 75 0c             	push   0xc(%ebp)
  801e8c:	e8 2d ec ff ff       	call   800abe <strcpy>
	return 0;
}
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <devcons_write>:
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	57                   	push   %edi
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ea4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ea9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801eaf:	eb 2e                	jmp    801edf <devcons_write+0x47>
		m = n - tot;
  801eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eb4:	29 f3                	sub    %esi,%ebx
  801eb6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ebb:	39 c3                	cmp    %eax,%ebx
  801ebd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	53                   	push   %ebx
  801ec4:	89 f0                	mov    %esi,%eax
  801ec6:	03 45 0c             	add    0xc(%ebp),%eax
  801ec9:	50                   	push   %eax
  801eca:	57                   	push   %edi
  801ecb:	e8 84 ed ff ff       	call   800c54 <memmove>
		sys_cputs(buf, m);
  801ed0:	83 c4 08             	add    $0x8,%esp
  801ed3:	53                   	push   %ebx
  801ed4:	57                   	push   %edi
  801ed5:	e8 24 ef ff ff       	call   800dfe <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801eda:	01 de                	add    %ebx,%esi
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ee2:	72 cd                	jb     801eb1 <devcons_write+0x19>
}
  801ee4:	89 f0                	mov    %esi,%eax
  801ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee9:	5b                   	pop    %ebx
  801eea:	5e                   	pop    %esi
  801eeb:	5f                   	pop    %edi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    

00801eee <devcons_read>:
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ef9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801efd:	75 07                	jne    801f06 <devcons_read+0x18>
  801eff:	eb 1f                	jmp    801f20 <devcons_read+0x32>
		sys_yield();
  801f01:	e8 95 ef ff ff       	call   800e9b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f06:	e8 11 ef ff ff       	call   800e1c <sys_cgetc>
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 f2                	je     801f01 <devcons_read+0x13>
	if (c < 0)
  801f0f:	78 0f                	js     801f20 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f11:	83 f8 04             	cmp    $0x4,%eax
  801f14:	74 0c                	je     801f22 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f19:	88 02                	mov    %al,(%edx)
	return 1;
  801f1b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    
		return 0;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	eb f7                	jmp    801f20 <devcons_read+0x32>

00801f29 <cputchar>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f35:	6a 01                	push   $0x1
  801f37:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	e8 be ee ff ff       	call   800dfe <sys_cputs>
}
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <getchar>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f4b:	6a 01                	push   $0x1
  801f4d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f50:	50                   	push   %eax
  801f51:	6a 00                	push   $0x0
  801f53:	e8 7d f5 ff ff       	call   8014d5 <read>
	if (r < 0)
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 06                	js     801f65 <getchar+0x20>
	if (r < 1)
  801f5f:	74 06                	je     801f67 <getchar+0x22>
	return c;
  801f61:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    
		return -E_EOF;
  801f67:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f6c:	eb f7                	jmp    801f65 <getchar+0x20>

00801f6e <iscons>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f77:	50                   	push   %eax
  801f78:	ff 75 08             	push   0x8(%ebp)
  801f7b:	e8 f1 f2 ff ff       	call   801271 <fd_lookup>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 11                	js     801f98 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f90:	39 10                	cmp    %edx,(%eax)
  801f92:	0f 94 c0             	sete   %al
  801f95:	0f b6 c0             	movzbl %al,%eax
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <opencons>:
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fa0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa3:	50                   	push   %eax
  801fa4:	e8 78 f2 ff ff       	call   801221 <fd_alloc>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 3a                	js     801fea <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 07 04 00 00       	push   $0x407
  801fb8:	ff 75 f4             	push   -0xc(%ebp)
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 f8 ee ff ff       	call   800eba <sys_page_alloc>
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 21                	js     801fea <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fd2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	50                   	push   %eax
  801fe2:	e8 13 f2 ff ff       	call   8011fa <fd2num>
  801fe7:	83 c4 10             	add    $0x10,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	8b 75 08             	mov    0x8(%ebp),%esi
  801ff4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	ff 75 0c             	push   0xc(%ebp)
  801ffd:	e8 68 f0 ff ff       	call   80106a <sys_ipc_recv>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 2b                	js     802034 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802009:	85 f6                	test   %esi,%esi
  80200b:	74 0a                	je     802017 <ipc_recv+0x2b>
  80200d:	a1 00 44 80 00       	mov    0x804400,%eax
  802012:	8b 40 74             	mov    0x74(%eax),%eax
  802015:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802017:	85 db                	test   %ebx,%ebx
  802019:	74 0a                	je     802025 <ipc_recv+0x39>
  80201b:	a1 00 44 80 00       	mov    0x804400,%eax
  802020:	8b 40 78             	mov    0x78(%eax),%eax
  802023:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802025:	a1 00 44 80 00       	mov    0x804400,%eax
  80202a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80202d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  802034:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802039:	eb f2                	jmp    80202d <ipc_recv+0x41>

0080203b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	57                   	push   %edi
  80203f:	56                   	push   %esi
  802040:	53                   	push   %ebx
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	8b 7d 08             	mov    0x8(%ebp),%edi
  802047:	8b 75 0c             	mov    0xc(%ebp),%esi
  80204a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80204d:	ff 75 14             	push   0x14(%ebp)
  802050:	53                   	push   %ebx
  802051:	56                   	push   %esi
  802052:	57                   	push   %edi
  802053:	e8 ef ef ff ff       	call   801047 <sys_ipc_try_send>
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	79 20                	jns    80207f <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80205f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802062:	75 07                	jne    80206b <ipc_send+0x30>
		sys_yield();
  802064:	e8 32 ee ff ff       	call   800e9b <sys_yield>
  802069:	eb e2                	jmp    80204d <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 16 28 80 00       	push   $0x802816
  802073:	6a 2e                	push   $0x2e
  802075:	68 26 28 80 00       	push   $0x802826
  80207a:	e8 9f e2 ff ff       	call   80031e <_panic>
	}
}
  80207f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802082:	5b                   	pop    %ebx
  802083:	5e                   	pop    %esi
  802084:	5f                   	pop    %edi
  802085:	5d                   	pop    %ebp
  802086:	c3                   	ret    

00802087 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802092:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802095:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80209b:	8b 52 50             	mov    0x50(%edx),%edx
  80209e:	39 ca                	cmp    %ecx,%edx
  8020a0:	74 11                	je     8020b3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020a2:	83 c0 01             	add    $0x1,%eax
  8020a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020aa:	75 e6                	jne    802092 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	eb 0b                	jmp    8020be <ipc_find_env+0x37>
			return envs[i].env_id;
  8020b3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020bb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020c6:	89 c2                	mov    %eax,%edx
  8020c8:	c1 ea 16             	shr    $0x16,%edx
  8020cb:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020d2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020d7:	f6 c1 01             	test   $0x1,%cl
  8020da:	74 1c                	je     8020f8 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8020dc:	c1 e8 0c             	shr    $0xc,%eax
  8020df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020e6:	a8 01                	test   $0x1,%al
  8020e8:	74 0e                	je     8020f8 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ea:	c1 e8 0c             	shr    $0xc,%eax
  8020ed:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020f4:	ef 
  8020f5:	0f b7 d2             	movzwl %dx,%edx
}
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <__udivdi3>:
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 1c             	sub    $0x1c,%esp
  80210b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80210f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802113:	8b 74 24 34          	mov    0x34(%esp),%esi
  802117:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80211b:	85 c0                	test   %eax,%eax
  80211d:	75 19                	jne    802138 <__udivdi3+0x38>
  80211f:	39 f3                	cmp    %esi,%ebx
  802121:	76 4d                	jbe    802170 <__udivdi3+0x70>
  802123:	31 ff                	xor    %edi,%edi
  802125:	89 e8                	mov    %ebp,%eax
  802127:	89 f2                	mov    %esi,%edx
  802129:	f7 f3                	div    %ebx
  80212b:	89 fa                	mov    %edi,%edx
  80212d:	83 c4 1c             	add    $0x1c,%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5f                   	pop    %edi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
  802135:	8d 76 00             	lea    0x0(%esi),%esi
  802138:	39 f0                	cmp    %esi,%eax
  80213a:	76 14                	jbe    802150 <__udivdi3+0x50>
  80213c:	31 ff                	xor    %edi,%edi
  80213e:	31 c0                	xor    %eax,%eax
  802140:	89 fa                	mov    %edi,%edx
  802142:	83 c4 1c             	add    $0x1c,%esp
  802145:	5b                   	pop    %ebx
  802146:	5e                   	pop    %esi
  802147:	5f                   	pop    %edi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    
  80214a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802150:	0f bd f8             	bsr    %eax,%edi
  802153:	83 f7 1f             	xor    $0x1f,%edi
  802156:	75 48                	jne    8021a0 <__udivdi3+0xa0>
  802158:	39 f0                	cmp    %esi,%eax
  80215a:	72 06                	jb     802162 <__udivdi3+0x62>
  80215c:	31 c0                	xor    %eax,%eax
  80215e:	39 eb                	cmp    %ebp,%ebx
  802160:	77 de                	ja     802140 <__udivdi3+0x40>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	eb d7                	jmp    802140 <__udivdi3+0x40>
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d9                	mov    %ebx,%ecx
  802172:	85 db                	test   %ebx,%ebx
  802174:	75 0b                	jne    802181 <__udivdi3+0x81>
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f3                	div    %ebx
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	31 d2                	xor    %edx,%edx
  802183:	89 f0                	mov    %esi,%eax
  802185:	f7 f1                	div    %ecx
  802187:	89 c6                	mov    %eax,%esi
  802189:	89 e8                	mov    %ebp,%eax
  80218b:	89 f7                	mov    %esi,%edi
  80218d:	f7 f1                	div    %ecx
  80218f:	89 fa                	mov    %edi,%edx
  802191:	83 c4 1c             	add    $0x1c,%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    
  802199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	89 f9                	mov    %edi,%ecx
  8021a2:	ba 20 00 00 00       	mov    $0x20,%edx
  8021a7:	29 fa                	sub    %edi,%edx
  8021a9:	d3 e0                	shl    %cl,%eax
  8021ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021af:	89 d1                	mov    %edx,%ecx
  8021b1:	89 d8                	mov    %ebx,%eax
  8021b3:	d3 e8                	shr    %cl,%eax
  8021b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021b9:	09 c1                	or     %eax,%ecx
  8021bb:	89 f0                	mov    %esi,%eax
  8021bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021c1:	89 f9                	mov    %edi,%ecx
  8021c3:	d3 e3                	shl    %cl,%ebx
  8021c5:	89 d1                	mov    %edx,%ecx
  8021c7:	d3 e8                	shr    %cl,%eax
  8021c9:	89 f9                	mov    %edi,%ecx
  8021cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021cf:	89 eb                	mov    %ebp,%ebx
  8021d1:	d3 e6                	shl    %cl,%esi
  8021d3:	89 d1                	mov    %edx,%ecx
  8021d5:	d3 eb                	shr    %cl,%ebx
  8021d7:	09 f3                	or     %esi,%ebx
  8021d9:	89 c6                	mov    %eax,%esi
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	89 d8                	mov    %ebx,%eax
  8021df:	f7 74 24 08          	divl   0x8(%esp)
  8021e3:	89 d6                	mov    %edx,%esi
  8021e5:	89 c3                	mov    %eax,%ebx
  8021e7:	f7 64 24 0c          	mull   0xc(%esp)
  8021eb:	39 d6                	cmp    %edx,%esi
  8021ed:	72 19                	jb     802208 <__udivdi3+0x108>
  8021ef:	89 f9                	mov    %edi,%ecx
  8021f1:	d3 e5                	shl    %cl,%ebp
  8021f3:	39 c5                	cmp    %eax,%ebp
  8021f5:	73 04                	jae    8021fb <__udivdi3+0xfb>
  8021f7:	39 d6                	cmp    %edx,%esi
  8021f9:	74 0d                	je     802208 <__udivdi3+0x108>
  8021fb:	89 d8                	mov    %ebx,%eax
  8021fd:	31 ff                	xor    %edi,%edi
  8021ff:	e9 3c ff ff ff       	jmp    802140 <__udivdi3+0x40>
  802204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802208:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80220b:	31 ff                	xor    %edi,%edi
  80220d:	e9 2e ff ff ff       	jmp    802140 <__udivdi3+0x40>
  802212:	66 90                	xchg   %ax,%ax
  802214:	66 90                	xchg   %ax,%ax
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__umoddi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80222f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802233:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802237:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80223b:	89 f0                	mov    %esi,%eax
  80223d:	89 da                	mov    %ebx,%edx
  80223f:	85 ff                	test   %edi,%edi
  802241:	75 15                	jne    802258 <__umoddi3+0x38>
  802243:	39 dd                	cmp    %ebx,%ebp
  802245:	76 39                	jbe    802280 <__umoddi3+0x60>
  802247:	f7 f5                	div    %ebp
  802249:	89 d0                	mov    %edx,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 df                	cmp    %ebx,%edi
  80225a:	77 f1                	ja     80224d <__umoddi3+0x2d>
  80225c:	0f bd cf             	bsr    %edi,%ecx
  80225f:	83 f1 1f             	xor    $0x1f,%ecx
  802262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802266:	75 40                	jne    8022a8 <__umoddi3+0x88>
  802268:	39 df                	cmp    %ebx,%edi
  80226a:	72 04                	jb     802270 <__umoddi3+0x50>
  80226c:	39 f5                	cmp    %esi,%ebp
  80226e:	77 dd                	ja     80224d <__umoddi3+0x2d>
  802270:	89 da                	mov    %ebx,%edx
  802272:	89 f0                	mov    %esi,%eax
  802274:	29 e8                	sub    %ebp,%eax
  802276:	19 fa                	sbb    %edi,%edx
  802278:	eb d3                	jmp    80224d <__umoddi3+0x2d>
  80227a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802280:	89 e9                	mov    %ebp,%ecx
  802282:	85 ed                	test   %ebp,%ebp
  802284:	75 0b                	jne    802291 <__umoddi3+0x71>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f5                	div    %ebp
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	89 d8                	mov    %ebx,%eax
  802293:	31 d2                	xor    %edx,%edx
  802295:	f7 f1                	div    %ecx
  802297:	89 f0                	mov    %esi,%eax
  802299:	f7 f1                	div    %ecx
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	31 d2                	xor    %edx,%edx
  80229f:	eb ac                	jmp    80224d <__umoddi3+0x2d>
  8022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ac:	ba 20 00 00 00       	mov    $0x20,%edx
  8022b1:	29 c2                	sub    %eax,%edx
  8022b3:	89 c1                	mov    %eax,%ecx
  8022b5:	89 e8                	mov    %ebp,%eax
  8022b7:	d3 e7                	shl    %cl,%edi
  8022b9:	89 d1                	mov    %edx,%ecx
  8022bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022bf:	d3 e8                	shr    %cl,%eax
  8022c1:	89 c1                	mov    %eax,%ecx
  8022c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022c7:	09 f9                	or     %edi,%ecx
  8022c9:	89 df                	mov    %ebx,%edi
  8022cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	d3 e5                	shl    %cl,%ebp
  8022d3:	89 d1                	mov    %edx,%ecx
  8022d5:	d3 ef                	shr    %cl,%edi
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	d3 e3                	shl    %cl,%ebx
  8022dd:	89 d1                	mov    %edx,%ecx
  8022df:	89 fa                	mov    %edi,%edx
  8022e1:	d3 e8                	shr    %cl,%eax
  8022e3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022e8:	09 d8                	or     %ebx,%eax
  8022ea:	f7 74 24 08          	divl   0x8(%esp)
  8022ee:	89 d3                	mov    %edx,%ebx
  8022f0:	d3 e6                	shl    %cl,%esi
  8022f2:	f7 e5                	mul    %ebp
  8022f4:	89 c7                	mov    %eax,%edi
  8022f6:	89 d1                	mov    %edx,%ecx
  8022f8:	39 d3                	cmp    %edx,%ebx
  8022fa:	72 06                	jb     802302 <__umoddi3+0xe2>
  8022fc:	75 0e                	jne    80230c <__umoddi3+0xec>
  8022fe:	39 c6                	cmp    %eax,%esi
  802300:	73 0a                	jae    80230c <__umoddi3+0xec>
  802302:	29 e8                	sub    %ebp,%eax
  802304:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802308:	89 d1                	mov    %edx,%ecx
  80230a:	89 c7                	mov    %eax,%edi
  80230c:	89 f5                	mov    %esi,%ebp
  80230e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802312:	29 fd                	sub    %edi,%ebp
  802314:	19 cb                	sbb    %ecx,%ebx
  802316:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80231b:	89 d8                	mov    %ebx,%eax
  80231d:	d3 e0                	shl    %cl,%eax
  80231f:	89 f1                	mov    %esi,%ecx
  802321:	d3 ed                	shr    %cl,%ebp
  802323:	d3 eb                	shr    %cl,%ebx
  802325:	09 e8                	or     %ebp,%eax
  802327:	89 da                	mov    %ebx,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
