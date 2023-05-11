
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 d8 09 00 00       	call   800a09 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 1a                	je     800060 <_gettoken+0x2d>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80004d:	7f 31                	jg     800080 <_gettoken+0x4d>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  80004f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800055:	8b 45 10             	mov    0x10(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005e:	eb 3a                	jmp    80009a <_gettoken+0x67>
		return 0;
  800060:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800065:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80006c:	7e 59                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	68 60 33 80 00       	push   $0x803360
  800076:	e8 c1 0a 00 00       	call   800b3c <cprintf>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	eb 47                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	53                   	push   %ebx
  800084:	68 6f 33 80 00       	push   $0x80336f
  800089:	e8 ae 0a 00 00       	call   800b3c <cprintf>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	eb bc                	jmp    80004f <_gettoken+0x1c>
		*s++ = 0;
  800093:	83 c3 01             	add    $0x1,%ebx
  800096:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	0f be 03             	movsbl (%ebx),%eax
  8000a0:	50                   	push   %eax
  8000a1:	68 7d 33 80 00       	push   $0x80337d
  8000a6:	e8 57 13 00 00       	call   801402 <strchr>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 e1                	jne    800093 <_gettoken+0x60>
	if (*s == 0) {
  8000b2:	0f b6 03             	movzbl (%ebx),%eax
  8000b5:	84 c0                	test   %al,%al
  8000b7:	75 2a                	jne    8000e3 <_gettoken+0xb0>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000be:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c5:	7f 0a                	jg     8000d1 <_gettoken+0x9e>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c7:	89 f0                	mov    %esi,%eax
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
			cprintf("EOL\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 82 33 80 00       	push   $0x803382
  8000d9:	e8 5e 0a 00 00       	call   800b3c <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 93 33 80 00       	push   $0x803393
  8000ef:	e8 0e 13 00 00       	call   801402 <strchr>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2c                	je     800127 <_gettoken+0xf4>
		t = *s;
  8000fb:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000fe:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800100:	c6 03 00             	movb   $0x0,(%ebx)
  800103:	83 c3 01             	add    $0x1,%ebx
  800106:	8b 45 10             	mov    0x10(%ebp),%eax
  800109:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 87 33 80 00       	push   $0x803387
  80011d:	e8 1a 0a 00 00       	call   800b3c <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb a0                	jmp    8000c7 <_gettoken+0x94>
	*p1 = s;
  800127:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800129:	eb 03                	jmp    80012e <_gettoken+0xfb>
		s++;
  80012b:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012e:	0f b6 03             	movzbl (%ebx),%eax
  800131:	84 c0                	test   %al,%al
  800133:	74 18                	je     80014d <_gettoken+0x11a>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	0f be c0             	movsbl %al,%eax
  80013b:	50                   	push   %eax
  80013c:	68 8f 33 80 00       	push   $0x80338f
  800141:	e8 bc 12 00 00       	call   801402 <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	push   (%edi)
  80016f:	68 9b 33 80 00       	push   $0x80339b
  800174:	e8 c3 09 00 00       	call   800b3c <cprintf>
		**p2 = t;
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 f2                	mov    %esi,%edx
  800180:	88 10                	mov    %dl,(%eax)
  800182:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800185:	be 77 00 00 00       	mov    $0x77,%esi
  80018a:	e9 38 ff ff ff       	jmp    8000c7 <_gettoken+0x94>

0080018f <gettoken>:

int
gettoken(char *s, char **p1)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 22                	je     8001be <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	68 0c 50 80 00       	push   $0x80500c
  8001a4:	68 10 50 80 00       	push   $0x805010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	c = nc;
  8001be:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c3:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001c8:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 50 80 00       	push   $0x80500c
  8001db:	68 10 50 80 00       	push   $0x805010
  8001e0:	ff 35 0c 50 80 00    	push   0x80500c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c2                	jmp    8001bc <gettoken+0x2d>

008001fa <runcmd>:
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800206:	6a 00                	push   $0x0
  800208:	ff 75 08             	push   0x8(%ebp)
  80020b:	e8 7f ff ff ff       	call   80018f <gettoken>
  800210:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800213:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800216:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 32 01 00 00    	je     800366 <runcmd+0x16c>
  800234:	7f 49                	jg     80027f <runcmd+0x85>
  800236:	85 c0                	test   %eax,%eax
  800238:	0f 84 1c 02 00 00    	je     80045a <runcmd+0x260>
  80023e:	83 f8 3c             	cmp    $0x3c,%eax
  800241:	0f 85 ef 02 00 00    	jne    800536 <runcmd+0x33c>
			if (gettoken(0, &t) != 'w') {
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	6a 00                	push   $0x0
  80024d:	e8 3d ff ff ff       	call   80018f <gettoken>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	83 f8 77             	cmp    $0x77,%eax
  800258:	0f 85 ba 00 00 00    	jne    800318 <runcmd+0x11e>
			if ((fd = open(t, O_RDONLY)) < 0) {
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	6a 00                	push   $0x0
  800263:	ff 75 a4             	push   -0x5c(%ebp)
  800266:	e8 d5 21 00 00       	call   802440 <open>
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	85 c0                	test   %eax,%eax
  800272:	0f 88 ba 00 00 00    	js     800332 <runcmd+0x138>
			if (fd != 0) {
  800278:	74 a1                	je     80021b <runcmd+0x21>
  80027a:	e9 cc 00 00 00       	jmp    80034b <runcmd+0x151>
		switch ((c = gettoken(0, &t))) {
  80027f:	83 f8 77             	cmp    $0x77,%eax
  800282:	74 69                	je     8002ed <runcmd+0xf3>
  800284:	83 f8 7c             	cmp    $0x7c,%eax
  800287:	0f 85 a9 02 00 00    	jne    800536 <runcmd+0x33c>
			if ((r = pipe(p)) < 0) {
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	e8 0f 2b 00 00       	call   802dab <pipe>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	0f 88 41 01 00 00    	js     8003e8 <runcmd+0x1ee>
			if (debug)
  8002a7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002ae:	0f 85 4f 01 00 00    	jne    800403 <runcmd+0x209>
			if ((r = fork()) < 0) {
  8002b4:	e8 24 17 00 00       	call   8019dd <fork>
  8002b9:	89 c3                	mov    %eax,%ebx
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	0f 88 61 01 00 00    	js     800424 <runcmd+0x22a>
			if (r == 0) {
  8002c3:	0f 85 71 01 00 00    	jne    80043a <runcmd+0x240>
				if (p[0] != 0) {
  8002c9:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	0f 85 1d 02 00 00    	jne    8004f4 <runcmd+0x2fa>
				close(p[1]);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff b5 a0 fb ff ff    	push   -0x460(%ebp)
  8002e0:	e8 7e 1b 00 00       	call   801e63 <close>
				goto again;
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	e9 29 ff ff ff       	jmp    800216 <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002ed:	83 ff 10             	cmp    $0x10,%edi
  8002f0:	74 0f                	je     800301 <runcmd+0x107>
			argv[argc++] = t;
  8002f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f5:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  8002f9:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  8002fc:	e9 1a ff ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	68 a5 33 80 00       	push   $0x8033a5
  800309:	e8 2e 08 00 00       	call   800b3c <cprintf>
				exit();
  80030e:	e8 3c 07 00 00       	call   800a4f <exit>
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	eb da                	jmp    8002f2 <runcmd+0xf8>
				cprintf("syntax error: < not followed by word\n");
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	68 f0 34 80 00       	push   $0x8034f0
  800320:	e8 17 08 00 00       	call   800b3c <cprintf>
				exit();
  800325:	e8 25 07 00 00       	call   800a4f <exit>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	e9 2c ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	50                   	push   %eax
  800336:	ff 75 a4             	push   -0x5c(%ebp)
  800339:	68 b9 33 80 00       	push   $0x8033b9
  80033e:	e8 f9 07 00 00       	call   800b3c <cprintf>
				exit();
  800343:	e8 07 07 00 00       	call   800a4f <exit>
  800348:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	6a 00                	push   $0x0
  800350:	53                   	push   %ebx
  800351:	e8 5f 1b 00 00       	call   801eb5 <dup>
				close(fd);
  800356:	89 1c 24             	mov    %ebx,(%esp)
  800359:	e8 05 1b 00 00       	call   801e63 <close>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	e9 b5 fe ff ff       	jmp    80021b <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	56                   	push   %esi
  80036a:	6a 00                	push   $0x0
  80036c:	e8 1e fe ff ff       	call   80018f <gettoken>
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	83 f8 77             	cmp    $0x77,%eax
  800377:	75 24                	jne    80039d <runcmd+0x1a3>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	68 01 03 00 00       	push   $0x301
  800381:	ff 75 a4             	push   -0x5c(%ebp)
  800384:	e8 b7 20 00 00       	call   802440 <open>
  800389:	89 c3                	mov    %eax,%ebx
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	85 c0                	test   %eax,%eax
  800390:	78 22                	js     8003b4 <runcmd+0x1ba>
			if (fd != 1) {
  800392:	83 f8 01             	cmp    $0x1,%eax
  800395:	0f 84 80 fe ff ff    	je     80021b <runcmd+0x21>
  80039b:	eb 30                	jmp    8003cd <runcmd+0x1d3>
				cprintf("syntax error: > not followed by word\n");
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	68 18 35 80 00       	push   $0x803518
  8003a5:	e8 92 07 00 00       	call   800b3c <cprintf>
				exit();
  8003aa:	e8 a0 06 00 00       	call   800a4f <exit>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	eb c5                	jmp    800379 <runcmd+0x17f>
				cprintf("open %s for write: %e", t, fd);
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 a4             	push   -0x5c(%ebp)
  8003bb:	68 ce 33 80 00       	push   $0x8033ce
  8003c0:	e8 77 07 00 00       	call   800b3c <cprintf>
				exit();
  8003c5:	e8 85 06 00 00       	call   800a4f <exit>
  8003ca:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	6a 01                	push   $0x1
  8003d2:	53                   	push   %ebx
  8003d3:	e8 dd 1a 00 00       	call   801eb5 <dup>
				close(fd);
  8003d8:	89 1c 24             	mov    %ebx,(%esp)
  8003db:	e8 83 1a 00 00       	call   801e63 <close>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	e9 33 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	50                   	push   %eax
  8003ec:	68 e4 33 80 00       	push   $0x8033e4
  8003f1:	e8 46 07 00 00       	call   800b3c <cprintf>
				exit();
  8003f6:	e8 54 06 00 00       	call   800a4f <exit>
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	e9 a4 fe ff ff       	jmp    8002a7 <runcmd+0xad>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	ff b5 a0 fb ff ff    	push   -0x460(%ebp)
  80040c:	ff b5 9c fb ff ff    	push   -0x464(%ebp)
  800412:	68 ed 33 80 00       	push   $0x8033ed
  800417:	e8 20 07 00 00       	call   800b3c <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	e9 90 fe ff ff       	jmp    8002b4 <runcmd+0xba>
				cprintf("fork: %e", r);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	50                   	push   %eax
  800428:	68 35 39 80 00       	push   $0x803935
  80042d:	e8 0a 07 00 00       	call   800b3c <cprintf>
				exit();
  800432:	e8 18 06 00 00       	call   800a4f <exit>
  800437:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043a:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800440:	83 f8 01             	cmp    $0x1,%eax
  800443:	0f 85 cc 00 00 00    	jne    800515 <runcmd+0x31b>
				close(p[0]);
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	ff b5 9c fb ff ff    	push   -0x464(%ebp)
  800452:	e8 0c 1a 00 00       	call   801e63 <close>
				goto runit;
  800457:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  80045a:	85 ff                	test   %edi,%edi
  80045c:	0f 84 e6 00 00 00    	je     800548 <runcmd+0x34e>
	if (argv[0][0] != '/') {
  800462:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800465:	80 38 2f             	cmpb   $0x2f,(%eax)
  800468:	0f 85 f5 00 00 00    	jne    800563 <runcmd+0x369>
	argv[argc] = 0;
  80046e:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800475:	00 
	if (debug) {
  800476:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80047d:	0f 85 08 01 00 00    	jne    80058b <runcmd+0x391>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800489:	50                   	push   %eax
  80048a:	ff 75 a8             	push   -0x58(%ebp)
  80048d:	e8 66 21 00 00       	call   8025f8 <spawn>
  800492:	89 c6                	mov    %eax,%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	85 c0                	test   %eax,%eax
  800499:	0f 88 3a 01 00 00    	js     8005d9 <runcmd+0x3df>
	close_all();
  80049f:	e8 ec 19 00 00       	call   801e90 <close_all>
		if (debug)
  8004a4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004ab:	0f 85 75 01 00 00    	jne    800626 <runcmd+0x42c>
		wait(r);
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	56                   	push   %esi
  8004b5:	e8 6e 2a 00 00       	call   802f28 <wait>
		if (debug)
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004c4:	0f 85 7b 01 00 00    	jne    800645 <runcmd+0x44b>
	if (pipe_child) {
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	74 19                	je     8004e7 <runcmd+0x2ed>
		wait(pipe_child);
  8004ce:	83 ec 0c             	sub    $0xc,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	e8 51 2a 00 00       	call   802f28 <wait>
		if (debug)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004e1:	0f 85 79 01 00 00    	jne    800660 <runcmd+0x466>
	exit();
  8004e7:	e8 63 05 00 00       	call   800a4f <exit>
}
  8004ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ef:	5b                   	pop    %ebx
  8004f0:	5e                   	pop    %esi
  8004f1:	5f                   	pop    %edi
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    
					dup(p[0], 0);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	6a 00                	push   $0x0
  8004f9:	50                   	push   %eax
  8004fa:	e8 b6 19 00 00       	call   801eb5 <dup>
					close(p[0]);
  8004ff:	83 c4 04             	add    $0x4,%esp
  800502:	ff b5 9c fb ff ff    	push   -0x464(%ebp)
  800508:	e8 56 19 00 00       	call   801e63 <close>
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	e9 c2 fd ff ff       	jmp    8002d7 <runcmd+0xdd>
					dup(p[1], 1);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	6a 01                	push   $0x1
  80051a:	50                   	push   %eax
  80051b:	e8 95 19 00 00       	call   801eb5 <dup>
					close(p[1]);
  800520:	83 c4 04             	add    $0x4,%esp
  800523:	ff b5 a0 fb ff ff    	push   -0x460(%ebp)
  800529:	e8 35 19 00 00       	call   801e63 <close>
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	e9 13 ff ff ff       	jmp    800449 <runcmd+0x24f>
			panic("bad return %d from gettoken", c);
  800536:	53                   	push   %ebx
  800537:	68 fa 33 80 00       	push   $0x8033fa
  80053c:	6a 76                	push   $0x76
  80053e:	68 16 34 80 00       	push   $0x803416
  800543:	e8 19 05 00 00       	call   800a61 <_panic>
		if (debug)
  800548:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80054f:	74 9b                	je     8004ec <runcmd+0x2f2>
			cprintf("EMPTY COMMAND\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 20 34 80 00       	push   $0x803420
  800559:	e8 de 05 00 00       	call   800b3c <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	eb 89                	jmp    8004ec <runcmd+0x2f2>
		argv0buf[0] = '/';
  800563:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	50                   	push   %eax
  80056e:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  800574:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 71 0d 00 00       	call   8012f1 <strcpy>
		argv[0] = argv0buf;
  800580:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	e9 e3 fe ff ff       	jmp    80046e <runcmd+0x274>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058b:	a1 14 50 80 00       	mov    0x805014,%eax
  800590:	8b 40 48             	mov    0x48(%eax),%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	50                   	push   %eax
  800597:	68 2f 34 80 00       	push   $0x80342f
  80059c:	e8 9b 05 00 00       	call   800b3c <cprintf>
  8005a1:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	eb 11                	jmp    8005ba <runcmd+0x3c0>
			cprintf(" %s", argv[i]);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	50                   	push   %eax
  8005ad:	68 b7 34 80 00       	push   $0x8034b7
  8005b2:	e8 85 05 00 00       	call   800b3c <cprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
		for (i = 0; argv[i]; i++)
  8005ba:	83 c6 04             	add    $0x4,%esi
  8005bd:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	75 e5                	jne    8005a9 <runcmd+0x3af>
		cprintf("\n");
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	68 80 33 80 00       	push   $0x803380
  8005cc:	e8 6b 05 00 00       	call   800b3c <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	e9 aa fe ff ff       	jmp    800483 <runcmd+0x289>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	50                   	push   %eax
  8005dd:	ff 75 a8             	push   -0x58(%ebp)
  8005e0:	68 3d 34 80 00       	push   $0x80343d
  8005e5:	e8 52 05 00 00       	call   800b3c <cprintf>
	close_all();
  8005ea:	e8 a1 18 00 00       	call   801e90 <close_all>
  8005ef:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f2:	85 db                	test   %ebx,%ebx
  8005f4:	0f 84 ed fe ff ff    	je     8004e7 <runcmd+0x2ed>
		if (debug)
  8005fa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800601:	0f 84 c7 fe ff ff    	je     8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800607:	a1 14 50 80 00       	mov    0x805014,%eax
  80060c:	8b 40 48             	mov    0x48(%eax),%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	53                   	push   %ebx
  800613:	50                   	push   %eax
  800614:	68 76 34 80 00       	push   $0x803476
  800619:	e8 1e 05 00 00       	call   800b3c <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	e9 a8 fe ff ff       	jmp    8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800626:	a1 14 50 80 00       	mov    0x805014,%eax
  80062b:	8b 40 48             	mov    0x48(%eax),%eax
  80062e:	56                   	push   %esi
  80062f:	ff 75 a8             	push   -0x58(%ebp)
  800632:	50                   	push   %eax
  800633:	68 4b 34 80 00       	push   $0x80344b
  800638:	e8 ff 04 00 00       	call   800b3c <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	e9 6c fe ff ff       	jmp    8004b1 <runcmd+0x2b7>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800645:	a1 14 50 80 00       	mov    0x805014,%eax
  80064a:	8b 40 48             	mov    0x48(%eax),%eax
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	50                   	push   %eax
  800651:	68 60 34 80 00       	push   $0x803460
  800656:	e8 e1 04 00 00       	call   800b3c <cprintf>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	eb 92                	jmp    8005f2 <runcmd+0x3f8>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800660:	a1 14 50 80 00       	mov    0x805014,%eax
  800665:	8b 40 48             	mov    0x48(%eax),%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	50                   	push   %eax
  80066c:	68 60 34 80 00       	push   $0x803460
  800671:	e8 c6 04 00 00       	call   800b3c <cprintf>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	e9 69 fe ff ff       	jmp    8004e7 <runcmd+0x2ed>

0080067e <usage>:


void
usage(void)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800684:	68 40 35 80 00       	push   $0x803540
  800689:	e8 ae 04 00 00       	call   800b3c <cprintf>
	exit();
  80068e:	e8 bc 03 00 00       	call   800a4f <exit>
}
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <umain>:

void
umain(int argc, char **argv)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	57                   	push   %edi
  80069c:	56                   	push   %esi
  80069d:	53                   	push   %ebx
  80069e:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 0c             	push   0xc(%ebp)
  8006a8:	8d 45 08             	lea    0x8(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	e8 c4 14 00 00       	call   801b75 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b1:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006bb:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006c3:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006c8:	eb 10                	jmp    8006da <umain+0x42>
			debug++;
  8006ca:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006d1:	eb 07                	jmp    8006da <umain+0x42>
			interactive = 1;
  8006d3:	89 f7                	mov    %esi,%edi
  8006d5:	eb 03                	jmp    8006da <umain+0x42>
		switch (r) {
  8006d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	53                   	push   %ebx
  8006de:	e8 c2 14 00 00       	call   801ba5 <argnext>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	78 16                	js     800700 <umain+0x68>
		switch (r) {
  8006ea:	83 f8 69             	cmp    $0x69,%eax
  8006ed:	74 e4                	je     8006d3 <umain+0x3b>
  8006ef:	83 f8 78             	cmp    $0x78,%eax
  8006f2:	74 e3                	je     8006d7 <umain+0x3f>
  8006f4:	83 f8 64             	cmp    $0x64,%eax
  8006f7:	74 d1                	je     8006ca <umain+0x32>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006f9:	e8 80 ff ff ff       	call   80067e <usage>
  8006fe:	eb da                	jmp    8006da <umain+0x42>
		}

	if (argc > 2)
  800700:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800704:	7f 1f                	jg     800725 <umain+0x8d>
		usage();
	if (argc == 2) {
  800706:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070a:	74 20                	je     80072c <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80070c:	83 ff 3f             	cmp    $0x3f,%edi
  80070f:	74 75                	je     800786 <umain+0xee>
  800711:	85 ff                	test   %edi,%edi
  800713:	bf bb 34 80 00       	mov    $0x8034bb,%edi
  800718:	b8 00 00 00 00       	mov    $0x0,%eax
  80071d:	0f 44 f8             	cmove  %eax,%edi
  800720:	e9 06 01 00 00       	jmp    80082b <umain+0x193>
		usage();
  800725:	e8 54 ff ff ff       	call   80067e <usage>
  80072a:	eb da                	jmp    800706 <umain+0x6e>
		close(0);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	6a 00                	push   $0x0
  800731:	e8 2d 17 00 00       	call   801e63 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800736:	83 c4 08             	add    $0x8,%esp
  800739:	6a 00                	push   $0x0
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	ff 70 04             	push   0x4(%eax)
  800741:	e8 fa 1c 00 00       	call   802440 <open>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 c0                	test   %eax,%eax
  80074b:	78 1b                	js     800768 <umain+0xd0>
		assert(r == 0);
  80074d:	74 bd                	je     80070c <umain+0x74>
  80074f:	68 9f 34 80 00       	push   $0x80349f
  800754:	68 a6 34 80 00       	push   $0x8034a6
  800759:	68 27 01 00 00       	push   $0x127
  80075e:	68 16 34 80 00       	push   $0x803416
  800763:	e8 f9 02 00 00       	call   800a61 <_panic>
			panic("open %s: %e", argv[1], r);
  800768:	83 ec 0c             	sub    $0xc,%esp
  80076b:	50                   	push   %eax
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076f:	ff 70 04             	push   0x4(%eax)
  800772:	68 93 34 80 00       	push   $0x803493
  800777:	68 26 01 00 00       	push   $0x126
  80077c:	68 16 34 80 00       	push   $0x803416
  800781:	e8 db 02 00 00       	call   800a61 <_panic>
		interactive = iscons(0);
  800786:	83 ec 0c             	sub    $0xc,%esp
  800789:	6a 00                	push   $0x0
  80078b:	e8 fb 01 00 00       	call   80098b <iscons>
  800790:	89 c7                	mov    %eax,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	e9 77 ff ff ff       	jmp    800711 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80079a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007a1:	75 0a                	jne    8007ad <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  8007a3:	e8 a7 02 00 00       	call   800a4f <exit>
  8007a8:	e9 94 00 00 00       	jmp    800841 <umain+0x1a9>
				cprintf("EXITING\n");
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	68 be 34 80 00       	push   $0x8034be
  8007b5:	e8 82 03 00 00       	call   800b3c <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb e4                	jmp    8007a3 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	68 c7 34 80 00       	push   $0x8034c7
  8007c8:	e8 6f 03 00 00       	call   800b3c <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	eb 7c                	jmp    80084e <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	68 d1 34 80 00       	push   $0x8034d1
  8007db:	e8 02 1e 00 00       	call   8025e2 <printf>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	eb 78                	jmp    80085d <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	68 d7 34 80 00       	push   $0x8034d7
  8007ed:	e8 4a 03 00 00       	call   800b3c <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb 73                	jmp    80086a <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007f7:	50                   	push   %eax
  8007f8:	68 35 39 80 00       	push   $0x803935
  8007fd:	68 3e 01 00 00       	push   $0x13e
  800802:	68 16 34 80 00       	push   $0x803416
  800807:	e8 55 02 00 00       	call   800a61 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	50                   	push   %eax
  800810:	68 e4 34 80 00       	push   $0x8034e4
  800815:	e8 22 03 00 00       	call   800b3c <cprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	eb 5f                	jmp    80087e <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	56                   	push   %esi
  800823:	e8 00 27 00 00       	call   802f28 <wait>
  800828:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082b:	83 ec 0c             	sub    $0xc,%esp
  80082e:	57                   	push   %edi
  80082f:	e8 92 09 00 00       	call   8011c6 <readline>
  800834:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	0f 84 59 ff ff ff    	je     80079a <umain+0x102>
		if (debug)
  800841:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800848:	0f 85 71 ff ff ff    	jne    8007bf <umain+0x127>
		if (buf[0] == '#')
  80084e:	80 3b 23             	cmpb   $0x23,(%ebx)
  800851:	74 d8                	je     80082b <umain+0x193>
		if (echocmds)
  800853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800857:	0f 85 75 ff ff ff    	jne    8007d2 <umain+0x13a>
		if (debug)
  80085d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800864:	0f 85 7b ff ff ff    	jne    8007e5 <umain+0x14d>
		if ((r = fork()) < 0)
  80086a:	e8 6e 11 00 00       	call   8019dd <fork>
  80086f:	89 c6                	mov    %eax,%esi
  800871:	85 c0                	test   %eax,%eax
  800873:	78 82                	js     8007f7 <umain+0x15f>
		if (debug)
  800875:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80087c:	75 8e                	jne    80080c <umain+0x174>
		if (r == 0) {
  80087e:	85 f6                	test   %esi,%esi
  800880:	75 9d                	jne    80081f <umain+0x187>
			runcmd(buf);
  800882:	83 ec 0c             	sub    $0xc,%esp
  800885:	53                   	push   %ebx
  800886:	e8 6f f9 ff ff       	call   8001fa <runcmd>
			exit();
  80088b:	e8 bf 01 00 00       	call   800a4f <exit>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	eb 96                	jmp    80082b <umain+0x193>

00800895 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	c3                   	ret    

0080089b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008a1:	68 61 35 80 00       	push   $0x803561
  8008a6:	ff 75 0c             	push   0xc(%ebp)
  8008a9:	e8 43 0a 00 00       	call   8012f1 <strcpy>
	return 0;
}
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <devcons_write>:
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	57                   	push   %edi
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008cc:	eb 2e                	jmp    8008fc <devcons_write+0x47>
		m = n - tot;
  8008ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008d1:	29 f3                	sub    %esi,%ebx
  8008d3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008d8:	39 c3                	cmp    %eax,%ebx
  8008da:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	89 f0                	mov    %esi,%eax
  8008e3:	03 45 0c             	add    0xc(%ebp),%eax
  8008e6:	50                   	push   %eax
  8008e7:	57                   	push   %edi
  8008e8:	e8 9a 0b 00 00       	call   801487 <memmove>
		sys_cputs(buf, m);
  8008ed:	83 c4 08             	add    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	57                   	push   %edi
  8008f2:	e8 3a 0d 00 00       	call   801631 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008f7:	01 de                	add    %ebx,%esi
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008ff:	72 cd                	jb     8008ce <devcons_write+0x19>
}
  800901:	89 f0                	mov    %esi,%eax
  800903:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800906:	5b                   	pop    %ebx
  800907:	5e                   	pop    %esi
  800908:	5f                   	pop    %edi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <devcons_read>:
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800916:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80091a:	75 07                	jne    800923 <devcons_read+0x18>
  80091c:	eb 1f                	jmp    80093d <devcons_read+0x32>
		sys_yield();
  80091e:	e8 ab 0d 00 00       	call   8016ce <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800923:	e8 27 0d 00 00       	call   80164f <sys_cgetc>
  800928:	85 c0                	test   %eax,%eax
  80092a:	74 f2                	je     80091e <devcons_read+0x13>
	if (c < 0)
  80092c:	78 0f                	js     80093d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80092e:	83 f8 04             	cmp    $0x4,%eax
  800931:	74 0c                	je     80093f <devcons_read+0x34>
	*(char*)vbuf = c;
  800933:	8b 55 0c             	mov    0xc(%ebp),%edx
  800936:	88 02                	mov    %al,(%edx)
	return 1;
  800938:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    
		return 0;
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	eb f7                	jmp    80093d <devcons_read+0x32>

00800946 <cputchar>:
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800952:	6a 01                	push   $0x1
  800954:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 d4 0c 00 00       	call   801631 <sys_cputs>
}
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	c9                   	leave  
  800961:	c3                   	ret    

00800962 <getchar>:
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800968:	6a 01                	push   $0x1
  80096a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096d:	50                   	push   %eax
  80096e:	6a 00                	push   $0x0
  800970:	e8 2a 16 00 00       	call   801f9f <read>
	if (r < 0)
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	85 c0                	test   %eax,%eax
  80097a:	78 06                	js     800982 <getchar+0x20>
	if (r < 1)
  80097c:	74 06                	je     800984 <getchar+0x22>
	return c;
  80097e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800982:	c9                   	leave  
  800983:	c3                   	ret    
		return -E_EOF;
  800984:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800989:	eb f7                	jmp    800982 <getchar+0x20>

0080098b <iscons>:
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800991:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800994:	50                   	push   %eax
  800995:	ff 75 08             	push   0x8(%ebp)
  800998:	e8 9e 13 00 00       	call   801d3b <fd_lookup>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	85 c0                	test   %eax,%eax
  8009a2:	78 11                	js     8009b5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a7:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009ad:	39 10                	cmp    %edx,(%eax)
  8009af:	0f 94 c0             	sete   %al
  8009b2:	0f b6 c0             	movzbl %al,%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <opencons>:
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 25 13 00 00       	call   801ceb <fd_alloc>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	78 3a                	js     800a07 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009cd:	83 ec 04             	sub    $0x4,%esp
  8009d0:	68 07 04 00 00       	push   $0x407
  8009d5:	ff 75 f4             	push   -0xc(%ebp)
  8009d8:	6a 00                	push   $0x0
  8009da:	e8 0e 0d 00 00       	call   8016ed <sys_page_alloc>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	78 21                	js     800a07 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e9:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009ef:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009fb:	83 ec 0c             	sub    $0xc,%esp
  8009fe:	50                   	push   %eax
  8009ff:	e8 c0 12 00 00       	call   801cc4 <fd2num>
  800a04:	83 c4 10             	add    $0x10,%esp
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	56                   	push   %esi
  800a0d:	53                   	push   %ebx
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a11:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a14:	e8 96 0c 00 00       	call   8016af <sys_getenvid>
  800a19:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a21:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a26:	a3 14 50 80 00       	mov    %eax,0x805014

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	7e 07                	jle    800a36 <libmain+0x2d>
		binaryname = argv[0];
  800a2f:	8b 06                	mov    (%esi),%eax
  800a31:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	56                   	push   %esi
  800a3a:	53                   	push   %ebx
  800a3b:	e8 58 fc ff ff       	call   800698 <umain>

	// exit gracefully
	exit();
  800a40:	e8 0a 00 00 00       	call   800a4f <exit>
}
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800a55:	6a 00                	push   $0x0
  800a57:	e8 12 0c 00 00       	call   80166e <sys_env_destroy>
}
  800a5c:	83 c4 10             	add    $0x10,%esp
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a66:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a69:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a6f:	e8 3b 0c 00 00       	call   8016af <sys_getenvid>
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	ff 75 0c             	push   0xc(%ebp)
  800a7a:	ff 75 08             	push   0x8(%ebp)
  800a7d:	56                   	push   %esi
  800a7e:	50                   	push   %eax
  800a7f:	68 78 35 80 00       	push   $0x803578
  800a84:	e8 b3 00 00 00       	call   800b3c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a89:	83 c4 18             	add    $0x18,%esp
  800a8c:	53                   	push   %ebx
  800a8d:	ff 75 10             	push   0x10(%ebp)
  800a90:	e8 56 00 00 00       	call   800aeb <vcprintf>
	cprintf("\n");
  800a95:	c7 04 24 80 33 80 00 	movl   $0x803380,(%esp)
  800a9c:	e8 9b 00 00 00       	call   800b3c <cprintf>
  800aa1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aa4:	cc                   	int3   
  800aa5:	eb fd                	jmp    800aa4 <_panic+0x43>

00800aa7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	83 ec 04             	sub    $0x4,%esp
  800aae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ab1:	8b 13                	mov    (%ebx),%edx
  800ab3:	8d 42 01             	lea    0x1(%edx),%eax
  800ab6:	89 03                	mov    %eax,(%ebx)
  800ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800abf:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ac4:	74 09                	je     800acf <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800ac6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	68 ff 00 00 00       	push   $0xff
  800ad7:	8d 43 08             	lea    0x8(%ebx),%eax
  800ada:	50                   	push   %eax
  800adb:	e8 51 0b 00 00       	call   801631 <sys_cputs>
		b->idx = 0;
  800ae0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	eb db                	jmp    800ac6 <putch+0x1f>

00800aeb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800afb:	00 00 00 
	b.cnt = 0;
  800afe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b05:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b08:	ff 75 0c             	push   0xc(%ebp)
  800b0b:	ff 75 08             	push   0x8(%ebp)
  800b0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b14:	50                   	push   %eax
  800b15:	68 a7 0a 80 00       	push   $0x800aa7
  800b1a:	e8 14 01 00 00       	call   800c33 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b1f:	83 c4 08             	add    $0x8,%esp
  800b22:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800b28:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b2e:	50                   	push   %eax
  800b2f:	e8 fd 0a 00 00       	call   801631 <sys_cputs>

	return b.cnt;
}
  800b34:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b42:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b45:	50                   	push   %eax
  800b46:	ff 75 08             	push   0x8(%ebp)
  800b49:	e8 9d ff ff ff       	call   800aeb <vcprintf>
	va_end(ap);

	return cnt;
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	83 ec 1c             	sub    $0x1c,%esp
  800b59:	89 c7                	mov    %eax,%edi
  800b5b:	89 d6                	mov    %edx,%esi
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b63:	89 d1                	mov    %edx,%ecx
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800b7d:	39 c2                	cmp    %eax,%edx
  800b7f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800b82:	72 3e                	jb     800bc2 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	ff 75 18             	push   0x18(%ebp)
  800b8a:	83 eb 01             	sub    $0x1,%ebx
  800b8d:	53                   	push   %ebx
  800b8e:	50                   	push   %eax
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 e4             	push   -0x1c(%ebp)
  800b95:	ff 75 e0             	push   -0x20(%ebp)
  800b98:	ff 75 dc             	push   -0x24(%ebp)
  800b9b:	ff 75 d8             	push   -0x28(%ebp)
  800b9e:	e8 7d 25 00 00       	call   803120 <__udivdi3>
  800ba3:	83 c4 18             	add    $0x18,%esp
  800ba6:	52                   	push   %edx
  800ba7:	50                   	push   %eax
  800ba8:	89 f2                	mov    %esi,%edx
  800baa:	89 f8                	mov    %edi,%eax
  800bac:	e8 9f ff ff ff       	call   800b50 <printnum>
  800bb1:	83 c4 20             	add    $0x20,%esp
  800bb4:	eb 13                	jmp    800bc9 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	56                   	push   %esi
  800bba:	ff 75 18             	push   0x18(%ebp)
  800bbd:	ff d7                	call   *%edi
  800bbf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800bc2:	83 eb 01             	sub    $0x1,%ebx
  800bc5:	85 db                	test   %ebx,%ebx
  800bc7:	7f ed                	jg     800bb6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	56                   	push   %esi
  800bcd:	83 ec 04             	sub    $0x4,%esp
  800bd0:	ff 75 e4             	push   -0x1c(%ebp)
  800bd3:	ff 75 e0             	push   -0x20(%ebp)
  800bd6:	ff 75 dc             	push   -0x24(%ebp)
  800bd9:	ff 75 d8             	push   -0x28(%ebp)
  800bdc:	e8 5f 26 00 00       	call   803240 <__umoddi3>
  800be1:	83 c4 14             	add    $0x14,%esp
  800be4:	0f be 80 9b 35 80 00 	movsbl 0x80359b(%eax),%eax
  800beb:	50                   	push   %eax
  800bec:	ff d7                	call   *%edi
}
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800bff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c03:	8b 10                	mov    (%eax),%edx
  800c05:	3b 50 04             	cmp    0x4(%eax),%edx
  800c08:	73 0a                	jae    800c14 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0d:	89 08                	mov    %ecx,(%eax)
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	88 02                	mov    %al,(%edx)
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <printfmt>:
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c1c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c1f:	50                   	push   %eax
  800c20:	ff 75 10             	push   0x10(%ebp)
  800c23:	ff 75 0c             	push   0xc(%ebp)
  800c26:	ff 75 08             	push   0x8(%ebp)
  800c29:	e8 05 00 00 00       	call   800c33 <vprintfmt>
}
  800c2e:	83 c4 10             	add    $0x10,%esp
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <vprintfmt>:
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 3c             	sub    $0x3c,%esp
  800c3c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c42:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c45:	eb 0a                	jmp    800c51 <vprintfmt+0x1e>
			putch(ch, putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	53                   	push   %ebx
  800c4b:	50                   	push   %eax
  800c4c:	ff d6                	call   *%esi
  800c4e:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c51:	83 c7 01             	add    $0x1,%edi
  800c54:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c58:	83 f8 25             	cmp    $0x25,%eax
  800c5b:	74 0c                	je     800c69 <vprintfmt+0x36>
			if (ch == '\0')
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	75 e6                	jne    800c47 <vprintfmt+0x14>
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
		padc = ' ';
  800c69:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800c6d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800c74:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800c7b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800c82:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c87:	8d 47 01             	lea    0x1(%edi),%eax
  800c8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c8d:	0f b6 17             	movzbl (%edi),%edx
  800c90:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c93:	3c 55                	cmp    $0x55,%al
  800c95:	0f 87 a6 04 00 00    	ja     801141 <vprintfmt+0x50e>
  800c9b:	0f b6 c0             	movzbl %al,%eax
  800c9e:	ff 24 85 e0 36 80 00 	jmp    *0x8036e0(,%eax,4)
  800ca5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800ca8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800cac:	eb d9                	jmp    800c87 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800cae:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800cb1:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800cb5:	eb d0                	jmp    800c87 <vprintfmt+0x54>
  800cb7:	0f b6 d2             	movzbl %dl,%edx
  800cba:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cc5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cc8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800ccc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800ccf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800cd2:	83 f9 09             	cmp    $0x9,%ecx
  800cd5:	77 55                	ja     800d2c <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800cd7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cda:	eb e9                	jmp    800cc5 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	8d 40 04             	lea    0x4(%eax),%eax
  800cea:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ced:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  800cf0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800cf4:	79 91                	jns    800c87 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800cfc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800d03:	eb 82                	jmp    800c87 <vprintfmt+0x54>
  800d05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d08:	85 d2                	test   %edx,%edx
  800d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0f:	0f 49 c2             	cmovns %edx,%eax
  800d12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d15:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800d18:	e9 6a ff ff ff       	jmp    800c87 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800d1d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800d20:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d27:	e9 5b ff ff ff       	jmp    800c87 <vprintfmt+0x54>
  800d2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d32:	eb bc                	jmp    800cf0 <vprintfmt+0xbd>
			lflag++;
  800d34:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d37:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800d3a:	e9 48 ff ff ff       	jmp    800c87 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800d3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d42:	8d 78 04             	lea    0x4(%eax),%edi
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	53                   	push   %ebx
  800d49:	ff 30                	push   (%eax)
  800d4b:	ff d6                	call   *%esi
			break;
  800d4d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d50:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d53:	e9 88 03 00 00       	jmp    8010e0 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	8d 78 04             	lea    0x4(%eax),%edi
  800d5e:	8b 10                	mov    (%eax),%edx
  800d60:	89 d0                	mov    %edx,%eax
  800d62:	f7 d8                	neg    %eax
  800d64:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d67:	83 f8 0f             	cmp    $0xf,%eax
  800d6a:	7f 23                	jg     800d8f <vprintfmt+0x15c>
  800d6c:	8b 14 85 40 38 80 00 	mov    0x803840(,%eax,4),%edx
  800d73:	85 d2                	test   %edx,%edx
  800d75:	74 18                	je     800d8f <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800d77:	52                   	push   %edx
  800d78:	68 b8 34 80 00       	push   $0x8034b8
  800d7d:	53                   	push   %ebx
  800d7e:	56                   	push   %esi
  800d7f:	e8 92 fe ff ff       	call   800c16 <printfmt>
  800d84:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d87:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d8a:	e9 51 03 00 00       	jmp    8010e0 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800d8f:	50                   	push   %eax
  800d90:	68 b3 35 80 00       	push   $0x8035b3
  800d95:	53                   	push   %ebx
  800d96:	56                   	push   %esi
  800d97:	e8 7a fe ff ff       	call   800c16 <printfmt>
  800d9c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d9f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800da2:	e9 39 03 00 00       	jmp    8010e0 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800da7:	8b 45 14             	mov    0x14(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800db0:	8b 45 14             	mov    0x14(%ebp),%eax
  800db3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800db5:	85 d2                	test   %edx,%edx
  800db7:	b8 ac 35 80 00       	mov    $0x8035ac,%eax
  800dbc:	0f 45 c2             	cmovne %edx,%eax
  800dbf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800dc2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800dc6:	7e 06                	jle    800dce <vprintfmt+0x19b>
  800dc8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800dcc:	75 0d                	jne    800ddb <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800dd1:	89 c7                	mov    %eax,%edi
  800dd3:	03 45 d4             	add    -0x2c(%ebp),%eax
  800dd6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800dd9:	eb 55                	jmp    800e30 <vprintfmt+0x1fd>
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 e0             	push   -0x20(%ebp)
  800de1:	ff 75 cc             	push   -0x34(%ebp)
  800de4:	e8 e5 04 00 00       	call   8012ce <strnlen>
  800de9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800dec:	29 c2                	sub    %eax,%edx
  800dee:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800df1:	83 c4 10             	add    $0x10,%esp
  800df4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800df6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800dfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfd:	eb 0f                	jmp    800e0e <vprintfmt+0x1db>
					putch(padc, putdat);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	53                   	push   %ebx
  800e03:	ff 75 d4             	push   -0x2c(%ebp)
  800e06:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e08:	83 ef 01             	sub    $0x1,%edi
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	85 ff                	test   %edi,%edi
  800e10:	7f ed                	jg     800dff <vprintfmt+0x1cc>
  800e12:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e15:	85 d2                	test   %edx,%edx
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1c:	0f 49 c2             	cmovns %edx,%eax
  800e1f:	29 c2                	sub    %eax,%edx
  800e21:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800e24:	eb a8                	jmp    800dce <vprintfmt+0x19b>
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	53                   	push   %ebx
  800e2a:	52                   	push   %edx
  800e2b:	ff d6                	call   *%esi
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e33:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	83 c7 01             	add    $0x1,%edi
  800e38:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e3c:	0f be d0             	movsbl %al,%edx
  800e3f:	85 d2                	test   %edx,%edx
  800e41:	74 4b                	je     800e8e <vprintfmt+0x25b>
  800e43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e47:	78 06                	js     800e4f <vprintfmt+0x21c>
  800e49:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800e4d:	78 1e                	js     800e6d <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800e4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e53:	74 d1                	je     800e26 <vprintfmt+0x1f3>
  800e55:	0f be c0             	movsbl %al,%eax
  800e58:	83 e8 20             	sub    $0x20,%eax
  800e5b:	83 f8 5e             	cmp    $0x5e,%eax
  800e5e:	76 c6                	jbe    800e26 <vprintfmt+0x1f3>
					putch('?', putdat);
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	53                   	push   %ebx
  800e64:	6a 3f                	push   $0x3f
  800e66:	ff d6                	call   *%esi
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	eb c3                	jmp    800e30 <vprintfmt+0x1fd>
  800e6d:	89 cf                	mov    %ecx,%edi
  800e6f:	eb 0e                	jmp    800e7f <vprintfmt+0x24c>
				putch(' ', putdat);
  800e71:	83 ec 08             	sub    $0x8,%esp
  800e74:	53                   	push   %ebx
  800e75:	6a 20                	push   $0x20
  800e77:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e79:	83 ef 01             	sub    $0x1,%edi
  800e7c:	83 c4 10             	add    $0x10,%esp
  800e7f:	85 ff                	test   %edi,%edi
  800e81:	7f ee                	jg     800e71 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800e83:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e86:	89 45 14             	mov    %eax,0x14(%ebp)
  800e89:	e9 52 02 00 00       	jmp    8010e0 <vprintfmt+0x4ad>
  800e8e:	89 cf                	mov    %ecx,%edi
  800e90:	eb ed                	jmp    800e7f <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800e92:	8b 45 14             	mov    0x14(%ebp),%eax
  800e95:	83 c0 04             	add    $0x4,%eax
  800e98:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800e9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800ea0:	85 d2                	test   %edx,%edx
  800ea2:	b8 ac 35 80 00       	mov    $0x8035ac,%eax
  800ea7:	0f 45 c2             	cmovne %edx,%eax
  800eaa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800ead:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800eb1:	7e 06                	jle    800eb9 <vprintfmt+0x286>
  800eb3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800eb7:	75 0d                	jne    800ec6 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	03 45 d4             	add    -0x2c(%ebp),%eax
  800ec1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800ec4:	eb 55                	jmp    800f1b <vprintfmt+0x2e8>
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e0             	push   -0x20(%ebp)
  800ecc:	ff 75 cc             	push   -0x34(%ebp)
  800ecf:	e8 fa 03 00 00       	call   8012ce <strnlen>
  800ed4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ed7:	29 c2                	sub    %eax,%edx
  800ed9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800ee1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800ee5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee8:	eb 0f                	jmp    800ef9 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	53                   	push   %ebx
  800eee:	ff 75 d4             	push   -0x2c(%ebp)
  800ef1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef3:	83 ef 01             	sub    $0x1,%edi
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	85 ff                	test   %edi,%edi
  800efb:	7f ed                	jg     800eea <vprintfmt+0x2b7>
  800efd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800f00:	85 d2                	test   %edx,%edx
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
  800f07:	0f 49 c2             	cmovns %edx,%eax
  800f0a:	29 c2                	sub    %eax,%edx
  800f0c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f0f:	eb a8                	jmp    800eb9 <vprintfmt+0x286>
					putch(ch, putdat);
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	53                   	push   %ebx
  800f15:	52                   	push   %edx
  800f16:	ff d6                	call   *%esi
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800f1e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800f20:	83 c7 01             	add    $0x1,%edi
  800f23:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f27:	0f be d0             	movsbl %al,%edx
  800f2a:	3c 3a                	cmp    $0x3a,%al
  800f2c:	74 4b                	je     800f79 <vprintfmt+0x346>
  800f2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f32:	78 06                	js     800f3a <vprintfmt+0x307>
  800f34:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800f38:	78 1e                	js     800f58 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800f3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f3e:	74 d1                	je     800f11 <vprintfmt+0x2de>
  800f40:	0f be c0             	movsbl %al,%eax
  800f43:	83 e8 20             	sub    $0x20,%eax
  800f46:	83 f8 5e             	cmp    $0x5e,%eax
  800f49:	76 c6                	jbe    800f11 <vprintfmt+0x2de>
					putch('?', putdat);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	53                   	push   %ebx
  800f4f:	6a 3f                	push   $0x3f
  800f51:	ff d6                	call   *%esi
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	eb c3                	jmp    800f1b <vprintfmt+0x2e8>
  800f58:	89 cf                	mov    %ecx,%edi
  800f5a:	eb 0e                	jmp    800f6a <vprintfmt+0x337>
				putch(' ', putdat);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	53                   	push   %ebx
  800f60:	6a 20                	push   $0x20
  800f62:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800f64:	83 ef 01             	sub    $0x1,%edi
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	85 ff                	test   %edi,%edi
  800f6c:	7f ee                	jg     800f5c <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800f6e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800f71:	89 45 14             	mov    %eax,0x14(%ebp)
  800f74:	e9 67 01 00 00       	jmp    8010e0 <vprintfmt+0x4ad>
  800f79:	89 cf                	mov    %ecx,%edi
  800f7b:	eb ed                	jmp    800f6a <vprintfmt+0x337>
	if (lflag >= 2)
  800f7d:	83 f9 01             	cmp    $0x1,%ecx
  800f80:	7f 1b                	jg     800f9d <vprintfmt+0x36a>
	else if (lflag)
  800f82:	85 c9                	test   %ecx,%ecx
  800f84:	74 63                	je     800fe9 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	8b 00                	mov    (%eax),%eax
  800f8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f8e:	99                   	cltd   
  800f8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f92:	8b 45 14             	mov    0x14(%ebp),%eax
  800f95:	8d 40 04             	lea    0x4(%eax),%eax
  800f98:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9b:	eb 17                	jmp    800fb4 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa0:	8b 50 04             	mov    0x4(%eax),%edx
  800fa3:	8b 00                	mov    (%eax),%eax
  800fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fa8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800fab:	8b 45 14             	mov    0x14(%ebp),%eax
  800fae:	8d 40 08             	lea    0x8(%eax),%eax
  800fb1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800fb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fb7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800fba:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800fbf:	85 c9                	test   %ecx,%ecx
  800fc1:	0f 89 ff 00 00 00    	jns    8010c6 <vprintfmt+0x493>
				putch('-', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	53                   	push   %ebx
  800fcb:	6a 2d                	push   $0x2d
  800fcd:	ff d6                	call   *%esi
				num = -(long long) num;
  800fcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800fd5:	f7 da                	neg    %edx
  800fd7:	83 d1 00             	adc    $0x0,%ecx
  800fda:	f7 d9                	neg    %ecx
  800fdc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800fdf:	bf 0a 00 00 00       	mov    $0xa,%edi
  800fe4:	e9 dd 00 00 00       	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800fe9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fec:	8b 00                	mov    (%eax),%eax
  800fee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ff1:	99                   	cltd   
  800ff2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff8:	8d 40 04             	lea    0x4(%eax),%eax
  800ffb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ffe:	eb b4                	jmp    800fb4 <vprintfmt+0x381>
	if (lflag >= 2)
  801000:	83 f9 01             	cmp    $0x1,%ecx
  801003:	7f 1e                	jg     801023 <vprintfmt+0x3f0>
	else if (lflag)
  801005:	85 c9                	test   %ecx,%ecx
  801007:	74 32                	je     80103b <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  801009:	8b 45 14             	mov    0x14(%ebp),%eax
  80100c:	8b 10                	mov    (%eax),%edx
  80100e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801013:	8d 40 04             	lea    0x4(%eax),%eax
  801016:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801019:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80101e:	e9 a3 00 00 00       	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801023:	8b 45 14             	mov    0x14(%ebp),%eax
  801026:	8b 10                	mov    (%eax),%edx
  801028:	8b 48 04             	mov    0x4(%eax),%ecx
  80102b:	8d 40 08             	lea    0x8(%eax),%eax
  80102e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801031:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  801036:	e9 8b 00 00 00       	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80103b:	8b 45 14             	mov    0x14(%ebp),%eax
  80103e:	8b 10                	mov    (%eax),%edx
  801040:	b9 00 00 00 00       	mov    $0x0,%ecx
  801045:	8d 40 04             	lea    0x4(%eax),%eax
  801048:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80104b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  801050:	eb 74                	jmp    8010c6 <vprintfmt+0x493>
	if (lflag >= 2)
  801052:	83 f9 01             	cmp    $0x1,%ecx
  801055:	7f 1b                	jg     801072 <vprintfmt+0x43f>
	else if (lflag)
  801057:	85 c9                	test   %ecx,%ecx
  801059:	74 2c                	je     801087 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80105b:	8b 45 14             	mov    0x14(%ebp),%eax
  80105e:	8b 10                	mov    (%eax),%edx
  801060:	b9 00 00 00 00       	mov    $0x0,%ecx
  801065:	8d 40 04             	lea    0x4(%eax),%eax
  801068:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80106b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  801070:	eb 54                	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801072:	8b 45 14             	mov    0x14(%ebp),%eax
  801075:	8b 10                	mov    (%eax),%edx
  801077:	8b 48 04             	mov    0x4(%eax),%ecx
  80107a:	8d 40 08             	lea    0x8(%eax),%eax
  80107d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801080:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  801085:	eb 3f                	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  801087:	8b 45 14             	mov    0x14(%ebp),%eax
  80108a:	8b 10                	mov    (%eax),%edx
  80108c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801091:	8d 40 04             	lea    0x4(%eax),%eax
  801094:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801097:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80109c:	eb 28                	jmp    8010c6 <vprintfmt+0x493>
			putch('0', putdat);
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	53                   	push   %ebx
  8010a2:	6a 30                	push   $0x30
  8010a4:	ff d6                	call   *%esi
			putch('x', putdat);
  8010a6:	83 c4 08             	add    $0x8,%esp
  8010a9:	53                   	push   %ebx
  8010aa:	6a 78                	push   $0x78
  8010ac:	ff d6                	call   *%esi
			num = (unsigned long long)
  8010ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b1:	8b 10                	mov    (%eax),%edx
  8010b3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8010b8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8010bb:	8d 40 04             	lea    0x4(%eax),%eax
  8010be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010c1:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8010c6:	83 ec 0c             	sub    $0xc,%esp
  8010c9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8010cd:	50                   	push   %eax
  8010ce:	ff 75 d4             	push   -0x2c(%ebp)
  8010d1:	57                   	push   %edi
  8010d2:	51                   	push   %ecx
  8010d3:	52                   	push   %edx
  8010d4:	89 da                	mov    %ebx,%edx
  8010d6:	89 f0                	mov    %esi,%eax
  8010d8:	e8 73 fa ff ff       	call   800b50 <printnum>
			break;
  8010dd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8010e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e3:	e9 69 fb ff ff       	jmp    800c51 <vprintfmt+0x1e>
	if (lflag >= 2)
  8010e8:	83 f9 01             	cmp    $0x1,%ecx
  8010eb:	7f 1b                	jg     801108 <vprintfmt+0x4d5>
	else if (lflag)
  8010ed:	85 c9                	test   %ecx,%ecx
  8010ef:	74 2c                	je     80111d <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8010f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f4:	8b 10                	mov    (%eax),%edx
  8010f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fb:	8d 40 04             	lea    0x4(%eax),%eax
  8010fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801101:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  801106:	eb be                	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801108:	8b 45 14             	mov    0x14(%ebp),%eax
  80110b:	8b 10                	mov    (%eax),%edx
  80110d:	8b 48 04             	mov    0x4(%eax),%ecx
  801110:	8d 40 08             	lea    0x8(%eax),%eax
  801113:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801116:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  80111b:	eb a9                	jmp    8010c6 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	8b 10                	mov    (%eax),%edx
  801122:	b9 00 00 00 00       	mov    $0x0,%ecx
  801127:	8d 40 04             	lea    0x4(%eax),%eax
  80112a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80112d:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  801132:	eb 92                	jmp    8010c6 <vprintfmt+0x493>
			putch(ch, putdat);
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	53                   	push   %ebx
  801138:	6a 25                	push   $0x25
  80113a:	ff d6                	call   *%esi
			break;
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	eb 9f                	jmp    8010e0 <vprintfmt+0x4ad>
			putch('%', putdat);
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	53                   	push   %ebx
  801145:	6a 25                	push   $0x25
  801147:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	89 f8                	mov    %edi,%eax
  80114e:	eb 03                	jmp    801153 <vprintfmt+0x520>
  801150:	83 e8 01             	sub    $0x1,%eax
  801153:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801157:	75 f7                	jne    801150 <vprintfmt+0x51d>
  801159:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80115c:	eb 82                	jmp    8010e0 <vprintfmt+0x4ad>

0080115e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 18             	sub    $0x18,%esp
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80116d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801171:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	74 26                	je     8011a5 <vsnprintf+0x47>
  80117f:	85 d2                	test   %edx,%edx
  801181:	7e 22                	jle    8011a5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801183:	ff 75 14             	push   0x14(%ebp)
  801186:	ff 75 10             	push   0x10(%ebp)
  801189:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118c:	50                   	push   %eax
  80118d:	68 f9 0b 80 00       	push   $0x800bf9
  801192:	e8 9c fa ff ff       	call   800c33 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80119d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    
		return -E_INVAL;
  8011a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011aa:	eb f7                	jmp    8011a3 <vsnprintf+0x45>

008011ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011b2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8011b5:	50                   	push   %eax
  8011b6:	ff 75 10             	push   0x10(%ebp)
  8011b9:	ff 75 0c             	push   0xc(%ebp)
  8011bc:	ff 75 08             	push   0x8(%ebp)
  8011bf:	e8 9a ff ff ff       	call   80115e <vsnprintf>
	va_end(ap);

	return rc;
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	74 13                	je     8011e9 <readline+0x23>
		fprintf(1, "%s", prompt);
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	50                   	push   %eax
  8011da:	68 b8 34 80 00       	push   $0x8034b8
  8011df:	6a 01                	push   $0x1
  8011e1:	e8 e5 13 00 00       	call   8025cb <fprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 98 f7 ff ff       	call   80098b <iscons>
  8011f3:	89 c7                	mov    %eax,%edi
  8011f5:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8011f8:	be 00 00 00 00       	mov    $0x0,%esi
  8011fd:	eb 4b                	jmp    80124a <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801204:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801207:	75 08                	jne    801211 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	53                   	push   %ebx
  801215:	68 9f 38 80 00       	push   $0x80389f
  80121a:	e8 1d f9 ff ff       	call   800b3c <cprintf>
  80121f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	eb e0                	jmp    801209 <readline+0x43>
			if (echoing)
  801229:	85 ff                	test   %edi,%edi
  80122b:	75 05                	jne    801232 <readline+0x6c>
			i--;
  80122d:	83 ee 01             	sub    $0x1,%esi
  801230:	eb 18                	jmp    80124a <readline+0x84>
				cputchar('\b');
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	6a 08                	push   $0x8
  801237:	e8 0a f7 ff ff       	call   800946 <cputchar>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	eb ec                	jmp    80122d <readline+0x67>
			buf[i++] = c;
  801241:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  801247:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  80124a:	e8 13 f7 ff ff       	call   800962 <getchar>
  80124f:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801251:	85 c0                	test   %eax,%eax
  801253:	78 aa                	js     8011ff <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801255:	83 f8 08             	cmp    $0x8,%eax
  801258:	0f 94 c0             	sete   %al
  80125b:	83 fb 7f             	cmp    $0x7f,%ebx
  80125e:	0f 94 c2             	sete   %dl
  801261:	08 d0                	or     %dl,%al
  801263:	74 04                	je     801269 <readline+0xa3>
  801265:	85 f6                	test   %esi,%esi
  801267:	7f c0                	jg     801229 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801269:	83 fb 1f             	cmp    $0x1f,%ebx
  80126c:	7e 1a                	jle    801288 <readline+0xc2>
  80126e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801274:	7f 12                	jg     801288 <readline+0xc2>
			if (echoing)
  801276:	85 ff                	test   %edi,%edi
  801278:	74 c7                	je     801241 <readline+0x7b>
				cputchar(c);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	53                   	push   %ebx
  80127e:	e8 c3 f6 ff ff       	call   800946 <cputchar>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	eb b9                	jmp    801241 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  801288:	83 fb 0a             	cmp    $0xa,%ebx
  80128b:	74 05                	je     801292 <readline+0xcc>
  80128d:	83 fb 0d             	cmp    $0xd,%ebx
  801290:	75 b8                	jne    80124a <readline+0x84>
			if (echoing)
  801292:	85 ff                	test   %edi,%edi
  801294:	75 11                	jne    8012a7 <readline+0xe1>
			buf[i] = 0;
  801296:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  80129d:	b8 20 50 80 00       	mov    $0x805020,%eax
  8012a2:	e9 62 ff ff ff       	jmp    801209 <readline+0x43>
				cputchar('\n');
  8012a7:	83 ec 0c             	sub    $0xc,%esp
  8012aa:	6a 0a                	push   $0xa
  8012ac:	e8 95 f6 ff ff       	call   800946 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	eb e0                	jmp    801296 <readline+0xd0>

008012b6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	eb 03                	jmp    8012c6 <strlen+0x10>
		n++;
  8012c3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8012c6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012ca:	75 f7                	jne    8012c3 <strlen+0xd>
	return n;
}
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	eb 03                	jmp    8012e1 <strnlen+0x13>
		n++;
  8012de:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e1:	39 d0                	cmp    %edx,%eax
  8012e3:	74 08                	je     8012ed <strnlen+0x1f>
  8012e5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8012e9:	75 f3                	jne    8012de <strnlen+0x10>
  8012eb:	89 c2                	mov    %eax,%edx
	return n;
}
  8012ed:	89 d0                	mov    %edx,%eax
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	53                   	push   %ebx
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801304:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801307:	83 c0 01             	add    $0x1,%eax
  80130a:	84 d2                	test   %dl,%dl
  80130c:	75 f2                	jne    801300 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80130e:	89 c8                	mov    %ecx,%eax
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	53                   	push   %ebx
  801319:	83 ec 10             	sub    $0x10,%esp
  80131c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80131f:	53                   	push   %ebx
  801320:	e8 91 ff ff ff       	call   8012b6 <strlen>
  801325:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801328:	ff 75 0c             	push   0xc(%ebp)
  80132b:	01 d8                	add    %ebx,%eax
  80132d:	50                   	push   %eax
  80132e:	e8 be ff ff ff       	call   8012f1 <strcpy>
	return dst;
}
  801333:	89 d8                	mov    %ebx,%eax
  801335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	8b 75 08             	mov    0x8(%ebp),%esi
  801342:	8b 55 0c             	mov    0xc(%ebp),%edx
  801345:	89 f3                	mov    %esi,%ebx
  801347:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80134a:	89 f0                	mov    %esi,%eax
  80134c:	eb 0f                	jmp    80135d <strncpy+0x23>
		*dst++ = *src;
  80134e:	83 c0 01             	add    $0x1,%eax
  801351:	0f b6 0a             	movzbl (%edx),%ecx
  801354:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801357:	80 f9 01             	cmp    $0x1,%cl
  80135a:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80135d:	39 d8                	cmp    %ebx,%eax
  80135f:	75 ed                	jne    80134e <strncpy+0x14>
	}
	return ret;
}
  801361:	89 f0                	mov    %esi,%eax
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
  80136c:	8b 75 08             	mov    0x8(%ebp),%esi
  80136f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801372:	8b 55 10             	mov    0x10(%ebp),%edx
  801375:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801377:	85 d2                	test   %edx,%edx
  801379:	74 21                	je     80139c <strlcpy+0x35>
  80137b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80137f:	89 f2                	mov    %esi,%edx
  801381:	eb 09                	jmp    80138c <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801383:	83 c1 01             	add    $0x1,%ecx
  801386:	83 c2 01             	add    $0x1,%edx
  801389:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80138c:	39 c2                	cmp    %eax,%edx
  80138e:	74 09                	je     801399 <strlcpy+0x32>
  801390:	0f b6 19             	movzbl (%ecx),%ebx
  801393:	84 db                	test   %bl,%bl
  801395:	75 ec                	jne    801383 <strlcpy+0x1c>
  801397:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801399:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80139c:	29 f0                	sub    %esi,%eax
}
  80139e:	5b                   	pop    %ebx
  80139f:	5e                   	pop    %esi
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    

008013a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8013ab:	eb 06                	jmp    8013b3 <strcmp+0x11>
		p++, q++;
  8013ad:	83 c1 01             	add    $0x1,%ecx
  8013b0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8013b3:	0f b6 01             	movzbl (%ecx),%eax
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 04                	je     8013be <strcmp+0x1c>
  8013ba:	3a 02                	cmp    (%edx),%al
  8013bc:	74 ef                	je     8013ad <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	0f b6 c0             	movzbl %al,%eax
  8013c1:	0f b6 12             	movzbl (%edx),%edx
  8013c4:	29 d0                	sub    %edx,%eax
}
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	53                   	push   %ebx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d2:	89 c3                	mov    %eax,%ebx
  8013d4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8013d7:	eb 06                	jmp    8013df <strncmp+0x17>
		n--, p++, q++;
  8013d9:	83 c0 01             	add    $0x1,%eax
  8013dc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8013df:	39 d8                	cmp    %ebx,%eax
  8013e1:	74 18                	je     8013fb <strncmp+0x33>
  8013e3:	0f b6 08             	movzbl (%eax),%ecx
  8013e6:	84 c9                	test   %cl,%cl
  8013e8:	74 04                	je     8013ee <strncmp+0x26>
  8013ea:	3a 0a                	cmp    (%edx),%cl
  8013ec:	74 eb                	je     8013d9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ee:	0f b6 00             	movzbl (%eax),%eax
  8013f1:	0f b6 12             	movzbl (%edx),%edx
  8013f4:	29 d0                	sub    %edx,%eax
}
  8013f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    
		return 0;
  8013fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801400:	eb f4                	jmp    8013f6 <strncmp+0x2e>

00801402 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80140c:	eb 03                	jmp    801411 <strchr+0xf>
  80140e:	83 c0 01             	add    $0x1,%eax
  801411:	0f b6 10             	movzbl (%eax),%edx
  801414:	84 d2                	test   %dl,%dl
  801416:	74 06                	je     80141e <strchr+0x1c>
		if (*s == c)
  801418:	38 ca                	cmp    %cl,%dl
  80141a:	75 f2                	jne    80140e <strchr+0xc>
  80141c:	eb 05                	jmp    801423 <strchr+0x21>
			return (char *) s;
	return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80142f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801432:	38 ca                	cmp    %cl,%dl
  801434:	74 09                	je     80143f <strfind+0x1a>
  801436:	84 d2                	test   %dl,%dl
  801438:	74 05                	je     80143f <strfind+0x1a>
	for (; *s; s++)
  80143a:	83 c0 01             	add    $0x1,%eax
  80143d:	eb f0                	jmp    80142f <strfind+0xa>
			break;
	return (char *) s;
}
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	57                   	push   %edi
  801445:	56                   	push   %esi
  801446:	53                   	push   %ebx
  801447:	8b 7d 08             	mov    0x8(%ebp),%edi
  80144a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80144d:	85 c9                	test   %ecx,%ecx
  80144f:	74 2f                	je     801480 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801451:	89 f8                	mov    %edi,%eax
  801453:	09 c8                	or     %ecx,%eax
  801455:	a8 03                	test   $0x3,%al
  801457:	75 21                	jne    80147a <memset+0x39>
		c &= 0xFF;
  801459:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80145d:	89 d0                	mov    %edx,%eax
  80145f:	c1 e0 08             	shl    $0x8,%eax
  801462:	89 d3                	mov    %edx,%ebx
  801464:	c1 e3 18             	shl    $0x18,%ebx
  801467:	89 d6                	mov    %edx,%esi
  801469:	c1 e6 10             	shl    $0x10,%esi
  80146c:	09 f3                	or     %esi,%ebx
  80146e:	09 da                	or     %ebx,%edx
  801470:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801472:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801475:	fc                   	cld    
  801476:	f3 ab                	rep stos %eax,%es:(%edi)
  801478:	eb 06                	jmp    801480 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	fc                   	cld    
  80147e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801480:	89 f8                	mov    %edi,%eax
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5f                   	pop    %edi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	57                   	push   %edi
  80148b:	56                   	push   %esi
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801492:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801495:	39 c6                	cmp    %eax,%esi
  801497:	73 32                	jae    8014cb <memmove+0x44>
  801499:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80149c:	39 c2                	cmp    %eax,%edx
  80149e:	76 2b                	jbe    8014cb <memmove+0x44>
		s += n;
		d += n;
  8014a0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014a3:	89 d6                	mov    %edx,%esi
  8014a5:	09 fe                	or     %edi,%esi
  8014a7:	09 ce                	or     %ecx,%esi
  8014a9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8014af:	75 0e                	jne    8014bf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014b1:	83 ef 04             	sub    $0x4,%edi
  8014b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8014b7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8014ba:	fd                   	std    
  8014bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014bd:	eb 09                	jmp    8014c8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bf:	83 ef 01             	sub    $0x1,%edi
  8014c2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8014c5:	fd                   	std    
  8014c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c8:	fc                   	cld    
  8014c9:	eb 1a                	jmp    8014e5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014cb:	89 f2                	mov    %esi,%edx
  8014cd:	09 c2                	or     %eax,%edx
  8014cf:	09 ca                	or     %ecx,%edx
  8014d1:	f6 c2 03             	test   $0x3,%dl
  8014d4:	75 0a                	jne    8014e0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014d6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8014d9:	89 c7                	mov    %eax,%edi
  8014db:	fc                   	cld    
  8014dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014de:	eb 05                	jmp    8014e5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8014e0:	89 c7                	mov    %eax,%edi
  8014e2:	fc                   	cld    
  8014e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014e5:	5e                   	pop    %esi
  8014e6:	5f                   	pop    %edi
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014ef:	ff 75 10             	push   0x10(%ebp)
  8014f2:	ff 75 0c             	push   0xc(%ebp)
  8014f5:	ff 75 08             	push   0x8(%ebp)
  8014f8:	e8 8a ff ff ff       	call   801487 <memmove>
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	89 c6                	mov    %eax,%esi
  80150c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80150f:	eb 06                	jmp    801517 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801511:	83 c0 01             	add    $0x1,%eax
  801514:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  801517:	39 f0                	cmp    %esi,%eax
  801519:	74 14                	je     80152f <memcmp+0x30>
		if (*s1 != *s2)
  80151b:	0f b6 08             	movzbl (%eax),%ecx
  80151e:	0f b6 1a             	movzbl (%edx),%ebx
  801521:	38 d9                	cmp    %bl,%cl
  801523:	74 ec                	je     801511 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  801525:	0f b6 c1             	movzbl %cl,%eax
  801528:	0f b6 db             	movzbl %bl,%ebx
  80152b:	29 d8                	sub    %ebx,%eax
  80152d:	eb 05                	jmp    801534 <memcmp+0x35>
	}

	return 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801541:	89 c2                	mov    %eax,%edx
  801543:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801546:	eb 03                	jmp    80154b <memfind+0x13>
  801548:	83 c0 01             	add    $0x1,%eax
  80154b:	39 d0                	cmp    %edx,%eax
  80154d:	73 04                	jae    801553 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80154f:	38 08                	cmp    %cl,(%eax)
  801551:	75 f5                	jne    801548 <memfind+0x10>
			break;
	return (void *) s;
}
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    

00801555 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	57                   	push   %edi
  801559:	56                   	push   %esi
  80155a:	53                   	push   %ebx
  80155b:	8b 55 08             	mov    0x8(%ebp),%edx
  80155e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801561:	eb 03                	jmp    801566 <strtol+0x11>
		s++;
  801563:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  801566:	0f b6 02             	movzbl (%edx),%eax
  801569:	3c 20                	cmp    $0x20,%al
  80156b:	74 f6                	je     801563 <strtol+0xe>
  80156d:	3c 09                	cmp    $0x9,%al
  80156f:	74 f2                	je     801563 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801571:	3c 2b                	cmp    $0x2b,%al
  801573:	74 2a                	je     80159f <strtol+0x4a>
	int neg = 0;
  801575:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80157a:	3c 2d                	cmp    $0x2d,%al
  80157c:	74 2b                	je     8015a9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80157e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801584:	75 0f                	jne    801595 <strtol+0x40>
  801586:	80 3a 30             	cmpb   $0x30,(%edx)
  801589:	74 28                	je     8015b3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80158b:	85 db                	test   %ebx,%ebx
  80158d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801592:	0f 44 d8             	cmove  %eax,%ebx
  801595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80159a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80159d:	eb 46                	jmp    8015e5 <strtol+0x90>
		s++;
  80159f:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  8015a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a7:	eb d5                	jmp    80157e <strtol+0x29>
		s++, neg = 1;
  8015a9:	83 c2 01             	add    $0x1,%edx
  8015ac:	bf 01 00 00 00       	mov    $0x1,%edi
  8015b1:	eb cb                	jmp    80157e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8015b7:	74 0e                	je     8015c7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8015b9:	85 db                	test   %ebx,%ebx
  8015bb:	75 d8                	jne    801595 <strtol+0x40>
		s++, base = 8;
  8015bd:	83 c2 01             	add    $0x1,%edx
  8015c0:	bb 08 00 00 00       	mov    $0x8,%ebx
  8015c5:	eb ce                	jmp    801595 <strtol+0x40>
		s += 2, base = 16;
  8015c7:	83 c2 02             	add    $0x2,%edx
  8015ca:	bb 10 00 00 00       	mov    $0x10,%ebx
  8015cf:	eb c4                	jmp    801595 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8015d1:	0f be c0             	movsbl %al,%eax
  8015d4:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8015d7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015da:	7d 3a                	jge    801616 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8015dc:	83 c2 01             	add    $0x1,%edx
  8015df:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  8015e3:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  8015e5:	0f b6 02             	movzbl (%edx),%eax
  8015e8:	8d 70 d0             	lea    -0x30(%eax),%esi
  8015eb:	89 f3                	mov    %esi,%ebx
  8015ed:	80 fb 09             	cmp    $0x9,%bl
  8015f0:	76 df                	jbe    8015d1 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  8015f2:	8d 70 9f             	lea    -0x61(%eax),%esi
  8015f5:	89 f3                	mov    %esi,%ebx
  8015f7:	80 fb 19             	cmp    $0x19,%bl
  8015fa:	77 08                	ja     801604 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8015fc:	0f be c0             	movsbl %al,%eax
  8015ff:	83 e8 57             	sub    $0x57,%eax
  801602:	eb d3                	jmp    8015d7 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  801604:	8d 70 bf             	lea    -0x41(%eax),%esi
  801607:	89 f3                	mov    %esi,%ebx
  801609:	80 fb 19             	cmp    $0x19,%bl
  80160c:	77 08                	ja     801616 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80160e:	0f be c0             	movsbl %al,%eax
  801611:	83 e8 37             	sub    $0x37,%eax
  801614:	eb c1                	jmp    8015d7 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  801616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161a:	74 05                	je     801621 <strtol+0xcc>
		*endptr = (char *) s;
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801621:	89 c8                	mov    %ecx,%eax
  801623:	f7 d8                	neg    %eax
  801625:	85 ff                	test   %edi,%edi
  801627:	0f 45 c8             	cmovne %eax,%ecx
}
  80162a:	89 c8                	mov    %ecx,%eax
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	57                   	push   %edi
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
	asm volatile("int %1\n"
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	8b 55 08             	mov    0x8(%ebp),%edx
  80163f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801642:	89 c3                	mov    %eax,%ebx
  801644:	89 c7                	mov    %eax,%edi
  801646:	89 c6                	mov    %eax,%esi
  801648:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5f                   	pop    %edi
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    

0080164f <sys_cgetc>:

int
sys_cgetc(void)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	57                   	push   %edi
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
	asm volatile("int %1\n"
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	b8 01 00 00 00       	mov    $0x1,%eax
  80165f:	89 d1                	mov    %edx,%ecx
  801661:	89 d3                	mov    %edx,%ebx
  801663:	89 d7                	mov    %edx,%edi
  801665:	89 d6                	mov    %edx,%esi
  801667:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5f                   	pop    %edi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801677:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167c:	8b 55 08             	mov    0x8(%ebp),%edx
  80167f:	b8 03 00 00 00       	mov    $0x3,%eax
  801684:	89 cb                	mov    %ecx,%ebx
  801686:	89 cf                	mov    %ecx,%edi
  801688:	89 ce                	mov    %ecx,%esi
  80168a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80168c:	85 c0                	test   %eax,%eax
  80168e:	7f 08                	jg     801698 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5f                   	pop    %edi
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801698:	83 ec 0c             	sub    $0xc,%esp
  80169b:	50                   	push   %eax
  80169c:	6a 03                	push   $0x3
  80169e:	68 af 38 80 00       	push   $0x8038af
  8016a3:	6a 23                	push   $0x23
  8016a5:	68 cc 38 80 00       	push   $0x8038cc
  8016aa:	e8 b2 f3 ff ff       	call   800a61 <_panic>

008016af <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	57                   	push   %edi
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8016bf:	89 d1                	mov    %edx,%ecx
  8016c1:	89 d3                	mov    %edx,%ebx
  8016c3:	89 d7                	mov    %edx,%edi
  8016c5:	89 d6                	mov    %edx,%esi
  8016c7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5f                   	pop    %edi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    

008016ce <sys_yield>:

void
sys_yield(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	57                   	push   %edi
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016de:	89 d1                	mov    %edx,%ecx
  8016e0:	89 d3                	mov    %edx,%ebx
  8016e2:	89 d7                	mov    %edx,%edi
  8016e4:	89 d6                	mov    %edx,%esi
  8016e6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016e8:	5b                   	pop    %ebx
  8016e9:	5e                   	pop    %esi
  8016ea:	5f                   	pop    %edi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	57                   	push   %edi
  8016f1:	56                   	push   %esi
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016f6:	be 00 00 00 00       	mov    $0x0,%esi
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801701:	b8 04 00 00 00       	mov    $0x4,%eax
  801706:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801709:	89 f7                	mov    %esi,%edi
  80170b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80170d:	85 c0                	test   %eax,%eax
  80170f:	7f 08                	jg     801719 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801711:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5f                   	pop    %edi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	50                   	push   %eax
  80171d:	6a 04                	push   $0x4
  80171f:	68 af 38 80 00       	push   $0x8038af
  801724:	6a 23                	push   $0x23
  801726:	68 cc 38 80 00       	push   $0x8038cc
  80172b:	e8 31 f3 ff ff       	call   800a61 <_panic>

00801730 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	57                   	push   %edi
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801739:	8b 55 08             	mov    0x8(%ebp),%edx
  80173c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173f:	b8 05 00 00 00       	mov    $0x5,%eax
  801744:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801747:	8b 7d 14             	mov    0x14(%ebp),%edi
  80174a:	8b 75 18             	mov    0x18(%ebp),%esi
  80174d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80174f:	85 c0                	test   %eax,%eax
  801751:	7f 08                	jg     80175b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5f                   	pop    %edi
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	50                   	push   %eax
  80175f:	6a 05                	push   $0x5
  801761:	68 af 38 80 00       	push   $0x8038af
  801766:	6a 23                	push   $0x23
  801768:	68 cc 38 80 00       	push   $0x8038cc
  80176d:	e8 ef f2 ff ff       	call   800a61 <_panic>

00801772 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	57                   	push   %edi
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
  801778:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80177b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801780:	8b 55 08             	mov    0x8(%ebp),%edx
  801783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801786:	b8 06 00 00 00       	mov    $0x6,%eax
  80178b:	89 df                	mov    %ebx,%edi
  80178d:	89 de                	mov    %ebx,%esi
  80178f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801791:	85 c0                	test   %eax,%eax
  801793:	7f 08                	jg     80179d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801795:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801798:	5b                   	pop    %ebx
  801799:	5e                   	pop    %esi
  80179a:	5f                   	pop    %edi
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80179d:	83 ec 0c             	sub    $0xc,%esp
  8017a0:	50                   	push   %eax
  8017a1:	6a 06                	push   $0x6
  8017a3:	68 af 38 80 00       	push   $0x8038af
  8017a8:	6a 23                	push   $0x23
  8017aa:	68 cc 38 80 00       	push   $0x8038cc
  8017af:	e8 ad f2 ff ff       	call   800a61 <_panic>

008017b4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	57                   	push   %edi
  8017b8:	56                   	push   %esi
  8017b9:	53                   	push   %ebx
  8017ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017cd:	89 df                	mov    %ebx,%edi
  8017cf:	89 de                	mov    %ebx,%esi
  8017d1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	7f 08                	jg     8017df <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017da:	5b                   	pop    %ebx
  8017db:	5e                   	pop    %esi
  8017dc:	5f                   	pop    %edi
  8017dd:	5d                   	pop    %ebp
  8017de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017df:	83 ec 0c             	sub    $0xc,%esp
  8017e2:	50                   	push   %eax
  8017e3:	6a 08                	push   $0x8
  8017e5:	68 af 38 80 00       	push   $0x8038af
  8017ea:	6a 23                	push   $0x23
  8017ec:	68 cc 38 80 00       	push   $0x8038cc
  8017f1:	e8 6b f2 ff ff       	call   800a61 <_panic>

008017f6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	57                   	push   %edi
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801804:	8b 55 08             	mov    0x8(%ebp),%edx
  801807:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180a:	b8 09 00 00 00       	mov    $0x9,%eax
  80180f:	89 df                	mov    %ebx,%edi
  801811:	89 de                	mov    %ebx,%esi
  801813:	cd 30                	int    $0x30
	if(check && ret > 0)
  801815:	85 c0                	test   %eax,%eax
  801817:	7f 08                	jg     801821 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801819:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5f                   	pop    %edi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	50                   	push   %eax
  801825:	6a 09                	push   $0x9
  801827:	68 af 38 80 00       	push   $0x8038af
  80182c:	6a 23                	push   $0x23
  80182e:	68 cc 38 80 00       	push   $0x8038cc
  801833:	e8 29 f2 ff ff       	call   800a61 <_panic>

00801838 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801841:	bb 00 00 00 00       	mov    $0x0,%ebx
  801846:	8b 55 08             	mov    0x8(%ebp),%edx
  801849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801851:	89 df                	mov    %ebx,%edi
  801853:	89 de                	mov    %ebx,%esi
  801855:	cd 30                	int    $0x30
	if(check && ret > 0)
  801857:	85 c0                	test   %eax,%eax
  801859:	7f 08                	jg     801863 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80185b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	50                   	push   %eax
  801867:	6a 0a                	push   $0xa
  801869:	68 af 38 80 00       	push   $0x8038af
  80186e:	6a 23                	push   $0x23
  801870:	68 cc 38 80 00       	push   $0x8038cc
  801875:	e8 e7 f1 ff ff       	call   800a61 <_panic>

0080187a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801880:	8b 55 08             	mov    0x8(%ebp),%edx
  801883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801886:	b8 0c 00 00 00       	mov    $0xc,%eax
  80188b:	be 00 00 00 00       	mov    $0x0,%esi
  801890:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801893:	8b 7d 14             	mov    0x14(%ebp),%edi
  801896:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5f                   	pop    %edi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    

0080189d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	57                   	push   %edi
  8018a1:	56                   	push   %esi
  8018a2:	53                   	push   %ebx
  8018a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ae:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018b3:	89 cb                	mov    %ecx,%ebx
  8018b5:	89 cf                	mov    %ecx,%edi
  8018b7:	89 ce                	mov    %ecx,%esi
  8018b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	7f 08                	jg     8018c7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5f                   	pop    %edi
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	50                   	push   %eax
  8018cb:	6a 0d                	push   $0xd
  8018cd:	68 af 38 80 00       	push   $0x8038af
  8018d2:	6a 23                	push   $0x23
  8018d4:	68 cc 38 80 00       	push   $0x8038cc
  8018d9:	e8 83 f1 ff ff       	call   800a61 <_panic>

008018de <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8018e8:	8b 18                	mov    (%eax),%ebx
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// pte_t *uvpt = (pte_t *)UVPT;
	
	if (!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW) || !(uvpt[PGNUM(addr)] & PTE_P)) 
  8018ea:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8018ee:	0f 84 99 00 00 00    	je     80198d <pgfault+0xaf>
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	c1 e8 16             	shr    $0x16,%eax
  8018f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801900:	a8 01                	test   $0x1,%al
  801902:	0f 84 85 00 00 00    	je     80198d <pgfault+0xaf>
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	c1 e8 0c             	shr    $0xc,%eax
  80190d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801914:	f6 c6 08             	test   $0x8,%dh
  801917:	74 74                	je     80198d <pgfault+0xaf>
  801919:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801920:	a8 01                	test   $0x1,%al
  801922:	74 69                	je     80198d <pgfault+0xaf>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if (sys_page_alloc(0, (void *)PFTEMP, PTE_W | PTE_P | PTE_U) < 0)
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	6a 07                	push   $0x7
  801929:	68 00 f0 7f 00       	push   $0x7ff000
  80192e:	6a 00                	push   $0x0
  801930:	e8 b8 fd ff ff       	call   8016ed <sys_page_alloc>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 65                	js     8019a1 <pgfault+0xc3>
		panic("Unable to alloc page\n");
	memcpy((void *)PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80193c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 00 10 00 00       	push   $0x1000
  80194a:	53                   	push   %ebx
  80194b:	68 00 f0 7f 00       	push   $0x7ff000
  801950:	e8 94 fb ff ff       	call   8014e9 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
  801955:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80195c:	53                   	push   %ebx
  80195d:	6a 00                	push   $0x0
  80195f:	68 00 f0 7f 00       	push   $0x7ff000
  801964:	6a 00                	push   $0x0
  801966:	e8 c5 fd ff ff       	call   801730 <sys_page_map>
  80196b:	83 c4 20             	add    $0x20,%esp
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 43                	js     8019b5 <pgfault+0xd7>
		panic("Unable to map\n");
	if (sys_page_unmap(0, PFTEMP) < 0)
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	68 00 f0 7f 00       	push   $0x7ff000
  80197a:	6a 00                	push   $0x0
  80197c:	e8 f1 fd ff ff       	call   801772 <sys_page_unmap>
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 41                	js     8019c9 <pgfault+0xeb>
		panic("Unable to unmap\n");
}
  801988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    
		panic("invalid permision\n");
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	68 da 38 80 00       	push   $0x8038da
  801995:	6a 1f                	push   $0x1f
  801997:	68 ed 38 80 00       	push   $0x8038ed
  80199c:	e8 c0 f0 ff ff       	call   800a61 <_panic>
		panic("Unable to alloc page\n");
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	68 f8 38 80 00       	push   $0x8038f8
  8019a9:	6a 28                	push   $0x28
  8019ab:	68 ed 38 80 00       	push   $0x8038ed
  8019b0:	e8 ac f0 ff ff       	call   800a61 <_panic>
		panic("Unable to map\n");
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	68 0e 39 80 00       	push   $0x80390e
  8019bd:	6a 2b                	push   $0x2b
  8019bf:	68 ed 38 80 00       	push   $0x8038ed
  8019c4:	e8 98 f0 ff ff       	call   800a61 <_panic>
		panic("Unable to unmap\n");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 1d 39 80 00       	push   $0x80391d
  8019d1:	6a 2d                	push   $0x2d
  8019d3:	68 ed 38 80 00       	push   $0x8038ed
  8019d8:	e8 84 f0 ff ff       	call   800a61 <_panic>

008019dd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	57                   	push   %edi
  8019e1:	56                   	push   %esi
  8019e2:	53                   	push   %ebx
  8019e3:	83 ec 18             	sub    $0x18,%esp
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	set_pgfault_handler(pgfault);
  8019e6:	68 de 18 80 00       	push   $0x8018de
  8019eb:	e8 87 15 00 00       	call   802f77 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019f0:	b8 07 00 00 00       	mov    $0x7,%eax
  8019f5:	cd 30                	int    $0x30
  8019f7:	89 c6                	mov    %eax,%esi
	envid = sys_exofork();
	if (envid < 0)
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 23                	js     801a23 <fork+0x46>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801a00:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (envid == 0) {
  801a05:	75 6d                	jne    801a74 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a07:	e8 a3 fc ff ff       	call   8016af <sys_getenvid>
  801a0c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a11:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a19:	a3 14 50 80 00       	mov    %eax,0x805014
		return 0;
  801a1e:	e9 02 01 00 00       	jmp    801b25 <fork+0x148>
		panic("sys_exofork: %e", envid);
  801a23:	50                   	push   %eax
  801a24:	68 2e 39 80 00       	push   $0x80392e
  801a29:	6a 6d                	push   $0x6d
  801a2b:	68 ed 38 80 00       	push   $0x8038ed
  801a30:	e8 2c f0 ff ff       	call   800a61 <_panic>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801a35:	c1 e0 0c             	shl    $0xc,%eax
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	56                   	push   %esi
  801a44:	50                   	push   %eax
  801a45:	6a 00                	push   $0x0
  801a47:	e8 e4 fc ff ff       	call   801730 <sys_page_map>
  801a4c:	83 c4 20             	add    $0x20,%esp
  801a4f:	eb 15                	jmp    801a66 <fork+0x89>
	} else if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U)) < 0) return r;
  801a51:	c1 e0 0c             	shl    $0xc,%eax
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	6a 05                	push   $0x5
  801a59:	50                   	push   %eax
  801a5a:	56                   	push   %esi
  801a5b:	50                   	push   %eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	e8 cd fc ff ff       	call   801730 <sys_page_map>
  801a63:	83 c4 20             	add    $0x20,%esp
	for (addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801a66:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a6c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801a72:	74 7a                	je     801aee <fork+0x111>
		((uvpd[PDX(addr)] & PTE_P) && 
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	c1 e8 16             	shr    $0x16,%eax
  801a79:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
		(uvpt[PGNUM(addr)] & PTE_P) && 
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801a80:	a8 01                	test   $0x1,%al
  801a82:	74 e2                	je     801a66 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	c1 e8 0c             	shr    $0xc,%eax
  801a89:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		((uvpd[PDX(addr)] & PTE_P) && 
  801a90:	f6 c2 01             	test   $0x1,%dl
  801a93:	74 d1                	je     801a66 <fork+0x89>
		(uvpt[PGNUM(addr)] & PTE_U) && 
  801a95:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		(uvpt[PGNUM(addr)] & PTE_P) && 
  801a9c:	f6 c2 04             	test   $0x4,%dl
  801a9f:	74 c5                	je     801a66 <fork+0x89>
	if (uvpt[pn] & PTE_SHARE) return sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  801aa1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aa8:	f6 c6 04             	test   $0x4,%dh
  801aab:	75 88                	jne    801a35 <fork+0x58>
	if (uvpt[pn] & (PTE_COW | PTE_W)) {
  801aad:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801ab3:	74 9c                	je     801a51 <fork+0x74>
		if ((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0 ||
  801ab5:	c1 e0 0c             	shl    $0xc,%eax
  801ab8:	89 c7                	mov    %eax,%edi
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	68 05 08 00 00       	push   $0x805
  801ac2:	50                   	push   %eax
  801ac3:	56                   	push   %esi
  801ac4:	50                   	push   %eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	e8 64 fc ff ff       	call   801730 <sys_page_map>
  801acc:	83 c4 20             	add    $0x20,%esp
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	78 93                	js     801a66 <fork+0x89>
			(r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P | PTE_U | PTE_COW)) < 0)
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	68 05 08 00 00       	push   $0x805
  801adb:	57                   	push   %edi
  801adc:	6a 00                	push   $0x0
  801ade:	57                   	push   %edi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 4a fc ff ff       	call   801730 <sys_page_map>
  801ae6:	83 c4 20             	add    $0x20,%esp
  801ae9:	e9 78 ff ff ff       	jmp    801a66 <fork+0x89>
		(duppage(envid, PGNUM(addr)) == 0));
	}

	if (sys_page_alloc(envid, (void *)UXSTACKTOP - PGSIZE, PTE_U | PTE_P | PTE_W) < 0)
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	6a 07                	push   $0x7
  801af3:	68 00 f0 bf ee       	push   $0xeebff000
  801af8:	56                   	push   %esi
  801af9:	e8 ef fb ff ff       	call   8016ed <sys_page_alloc>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 2a                	js     801b2f <fork+0x152>
		panic("failed to alloc page");
		
	//setup page fault handler for child
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	68 e6 2f 80 00       	push   $0x802fe6
  801b0d:	56                   	push   %esi
  801b0e:	e8 25 fd ff ff       	call   801838 <sys_env_set_pgfault_upcall>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801b13:	83 c4 08             	add    $0x8,%esp
  801b16:	6a 02                	push   $0x2
  801b18:	56                   	push   %esi
  801b19:	e8 96 fc ff ff       	call   8017b4 <sys_env_set_status>
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 21                	js     801b46 <fork+0x169>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801b25:	89 f0                	mov    %esi,%eax
  801b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2a:	5b                   	pop    %ebx
  801b2b:	5e                   	pop    %esi
  801b2c:	5f                   	pop    %edi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    
		panic("failed to alloc page");
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	68 3e 39 80 00       	push   $0x80393e
  801b37:	68 82 00 00 00       	push   $0x82
  801b3c:	68 ed 38 80 00       	push   $0x8038ed
  801b41:	e8 1b ef ff ff       	call   800a61 <_panic>
		panic("sys_env_set_status: %e", r);
  801b46:	50                   	push   %eax
  801b47:	68 53 39 80 00       	push   $0x803953
  801b4c:	68 89 00 00 00       	push   $0x89
  801b51:	68 ed 38 80 00       	push   $0x8038ed
  801b56:	e8 06 ef ff ff       	call   800a61 <_panic>

00801b5b <sfork>:

// Challenge!
int
sfork(void)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801b61:	68 6a 39 80 00       	push   $0x80396a
  801b66:	68 92 00 00 00       	push   $0x92
  801b6b:	68 ed 38 80 00       	push   $0x8038ed
  801b70:	e8 ec ee ff ff       	call   800a61 <_panic>

00801b75 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	8b 55 08             	mov    0x8(%ebp),%edx
  801b7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b7e:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801b81:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801b83:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b86:	83 3a 01             	cmpl   $0x1,(%edx)
  801b89:	7e 09                	jle    801b94 <argstart+0x1f>
  801b8b:	ba 81 33 80 00       	mov    $0x803381,%edx
  801b90:	85 c9                	test   %ecx,%ecx
  801b92:	75 05                	jne    801b99 <argstart+0x24>
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801b9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    

00801ba5 <argnext>:

int
argnext(struct Argstate *args)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801baf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801bb6:	8b 43 08             	mov    0x8(%ebx),%eax
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	74 74                	je     801c31 <argnext+0x8c>
		return -1;

	if (!*args->curarg) {
  801bbd:	80 38 00             	cmpb   $0x0,(%eax)
  801bc0:	75 48                	jne    801c0a <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801bc2:	8b 0b                	mov    (%ebx),%ecx
  801bc4:	83 39 01             	cmpl   $0x1,(%ecx)
  801bc7:	74 5a                	je     801c23 <argnext+0x7e>
		    || args->argv[1][0] != '-'
  801bc9:	8b 53 04             	mov    0x4(%ebx),%edx
  801bcc:	8b 42 04             	mov    0x4(%edx),%eax
  801bcf:	80 38 2d             	cmpb   $0x2d,(%eax)
  801bd2:	75 4f                	jne    801c23 <argnext+0x7e>
		    || args->argv[1][1] == '\0')
  801bd4:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801bd8:	74 49                	je     801c23 <argnext+0x7e>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bda:	83 c0 01             	add    $0x1,%eax
  801bdd:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 01                	mov    (%ecx),%eax
  801be5:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801bec:	50                   	push   %eax
  801bed:	8d 42 08             	lea    0x8(%edx),%eax
  801bf0:	50                   	push   %eax
  801bf1:	83 c2 04             	add    $0x4,%edx
  801bf4:	52                   	push   %edx
  801bf5:	e8 8d f8 ff ff       	call   801487 <memmove>
		(*args->argc)--;
  801bfa:	8b 03                	mov    (%ebx),%eax
  801bfc:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801bff:	8b 43 08             	mov    0x8(%ebx),%eax
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c08:	74 13                	je     801c1d <argnext+0x78>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c0a:	8b 43 08             	mov    0x8(%ebx),%eax
  801c0d:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801c10:	83 c0 01             	add    $0x1,%eax
  801c13:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801c16:	89 d0                	mov    %edx,%eax
  801c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c1d:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c21:	75 e7                	jne    801c0a <argnext+0x65>
	args->curarg = 0;
  801c23:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801c2a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801c2f:	eb e5                	jmp    801c16 <argnext+0x71>
		return -1;
  801c31:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801c36:	eb de                	jmp    801c16 <argnext+0x71>

00801c38 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	53                   	push   %ebx
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801c42:	8b 43 08             	mov    0x8(%ebx),%eax
  801c45:	85 c0                	test   %eax,%eax
  801c47:	74 12                	je     801c5b <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801c49:	80 38 00             	cmpb   $0x0,(%eax)
  801c4c:	74 12                	je     801c60 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801c4e:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801c51:	c7 43 08 81 33 80 00 	movl   $0x803381,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801c58:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    
	} else if (*args->argc > 1) {
  801c60:	8b 13                	mov    (%ebx),%edx
  801c62:	83 3a 01             	cmpl   $0x1,(%edx)
  801c65:	7f 10                	jg     801c77 <argnextvalue+0x3f>
		args->argvalue = 0;
  801c67:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801c6e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801c75:	eb e1                	jmp    801c58 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801c77:	8b 43 04             	mov    0x4(%ebx),%eax
  801c7a:	8b 48 04             	mov    0x4(%eax),%ecx
  801c7d:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 12                	mov    (%edx),%edx
  801c85:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801c8c:	52                   	push   %edx
  801c8d:	8d 50 08             	lea    0x8(%eax),%edx
  801c90:	52                   	push   %edx
  801c91:	83 c0 04             	add    $0x4,%eax
  801c94:	50                   	push   %eax
  801c95:	e8 ed f7 ff ff       	call   801487 <memmove>
		(*args->argc)--;
  801c9a:	8b 03                	mov    (%ebx),%eax
  801c9c:	83 28 01             	subl   $0x1,(%eax)
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	eb b4                	jmp    801c58 <argnextvalue+0x20>

00801ca4 <argvalue>:
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 08             	sub    $0x8,%esp
  801caa:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cad:	8b 42 0c             	mov    0xc(%edx),%eax
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	74 02                	je     801cb6 <argvalue+0x12>
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	52                   	push   %edx
  801cba:	e8 79 ff ff ff       	call   801c38 <argnextvalue>
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	eb f0                	jmp    801cb4 <argvalue+0x10>

00801cc4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	05 00 00 00 30       	add    $0x30000000,%eax
  801ccf:	c1 e8 0c             	shr    $0xc,%eax
}
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ce4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cf3:	89 c2                	mov    %eax,%edx
  801cf5:	c1 ea 16             	shr    $0x16,%edx
  801cf8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cff:	f6 c2 01             	test   $0x1,%dl
  801d02:	74 29                	je     801d2d <fd_alloc+0x42>
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	c1 ea 0c             	shr    $0xc,%edx
  801d09:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d10:	f6 c2 01             	test   $0x1,%dl
  801d13:	74 18                	je     801d2d <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  801d15:	05 00 10 00 00       	add    $0x1000,%eax
  801d1a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d1f:	75 d2                	jne    801cf3 <fd_alloc+0x8>
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  801d26:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  801d2b:	eb 05                	jmp    801d32 <fd_alloc+0x47>
			return 0;
  801d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  801d32:	8b 55 08             	mov    0x8(%ebp),%edx
  801d35:	89 02                	mov    %eax,(%edx)
}
  801d37:	89 c8                	mov    %ecx,%eax
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d41:	83 f8 1f             	cmp    $0x1f,%eax
  801d44:	77 30                	ja     801d76 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d46:	c1 e0 0c             	shl    $0xc,%eax
  801d49:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d4e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801d54:	f6 c2 01             	test   $0x1,%dl
  801d57:	74 24                	je     801d7d <fd_lookup+0x42>
  801d59:	89 c2                	mov    %eax,%edx
  801d5b:	c1 ea 0c             	shr    $0xc,%edx
  801d5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d65:	f6 c2 01             	test   $0x1,%dl
  801d68:	74 1a                	je     801d84 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	89 02                	mov    %eax,(%edx)
	return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    
		return -E_INVAL;
  801d76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d7b:	eb f7                	jmp    801d74 <fd_lookup+0x39>
		return -E_INVAL;
  801d7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d82:	eb f0                	jmp    801d74 <fd_lookup+0x39>
  801d84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d89:	eb e9                	jmp    801d74 <fd_lookup+0x39>

00801d8b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	53                   	push   %ebx
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	8b 55 08             	mov    0x8(%ebp),%edx
  801d95:	b8 fc 39 80 00       	mov    $0x8039fc,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801d9a:	bb 20 40 80 00       	mov    $0x804020,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801d9f:	39 13                	cmp    %edx,(%ebx)
  801da1:	74 32                	je     801dd5 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  801da3:	83 c0 04             	add    $0x4,%eax
  801da6:	8b 18                	mov    (%eax),%ebx
  801da8:	85 db                	test   %ebx,%ebx
  801daa:	75 f3                	jne    801d9f <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dac:	a1 14 50 80 00       	mov    0x805014,%eax
  801db1:	8b 40 48             	mov    0x48(%eax),%eax
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	68 80 39 80 00       	push   $0x803980
  801dbe:	e8 79 ed ff ff       	call   800b3c <cprintf>
	*dev = 0;
	return -E_INVAL;
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dce:	89 1a                	mov    %ebx,(%edx)
}
  801dd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    
			return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb ef                	jmp    801dcb <dev_lookup+0x40>

00801ddc <fd_close>:
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	57                   	push   %edi
  801de0:	56                   	push   %esi
  801de1:	53                   	push   %ebx
  801de2:	83 ec 24             	sub    $0x24,%esp
  801de5:	8b 75 08             	mov    0x8(%ebp),%esi
  801de8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801deb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801dee:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801def:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801df5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801df8:	50                   	push   %eax
  801df9:	e8 3d ff ff ff       	call   801d3b <fd_lookup>
  801dfe:	89 c3                	mov    %eax,%ebx
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 05                	js     801e0c <fd_close+0x30>
	    || fd != fd2)
  801e07:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801e0a:	74 16                	je     801e22 <fd_close+0x46>
		return (must_exist ? r : 0);
  801e0c:	89 f8                	mov    %edi,%eax
  801e0e:	84 c0                	test   %al,%al
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	0f 44 d8             	cmove  %eax,%ebx
}
  801e18:	89 d8                	mov    %ebx,%eax
  801e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e28:	50                   	push   %eax
  801e29:	ff 36                	push   (%esi)
  801e2b:	e8 5b ff ff ff       	call   801d8b <dev_lookup>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 1a                	js     801e53 <fd_close+0x77>
		if (dev->dev_close)
  801e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801e44:	85 c0                	test   %eax,%eax
  801e46:	74 0b                	je     801e53 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801e48:	83 ec 0c             	sub    $0xc,%esp
  801e4b:	56                   	push   %esi
  801e4c:	ff d0                	call   *%eax
  801e4e:	89 c3                	mov    %eax,%ebx
  801e50:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	56                   	push   %esi
  801e57:	6a 00                	push   $0x0
  801e59:	e8 14 f9 ff ff       	call   801772 <sys_page_unmap>
	return r;
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	eb b5                	jmp    801e18 <fd_close+0x3c>

00801e63 <close>:

int
close(int fdnum)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	ff 75 08             	push   0x8(%ebp)
  801e70:	e8 c6 fe ff ff       	call   801d3b <fd_lookup>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	79 02                	jns    801e7e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    
		return fd_close(fd, 1);
  801e7e:	83 ec 08             	sub    $0x8,%esp
  801e81:	6a 01                	push   $0x1
  801e83:	ff 75 f4             	push   -0xc(%ebp)
  801e86:	e8 51 ff ff ff       	call   801ddc <fd_close>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	eb ec                	jmp    801e7c <close+0x19>

00801e90 <close_all>:

void
close_all(void)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	53                   	push   %ebx
  801e94:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e97:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	53                   	push   %ebx
  801ea0:	e8 be ff ff ff       	call   801e63 <close>
	for (i = 0; i < MAXFD; i++)
  801ea5:	83 c3 01             	add    $0x1,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	83 fb 20             	cmp    $0x20,%ebx
  801eae:	75 ec                	jne    801e9c <close_all+0xc>
}
  801eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	57                   	push   %edi
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ebe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ec1:	50                   	push   %eax
  801ec2:	ff 75 08             	push   0x8(%ebp)
  801ec5:	e8 71 fe ff ff       	call   801d3b <fd_lookup>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 7f                	js     801f52 <dup+0x9d>
		return r;
	close(newfdnum);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	ff 75 0c             	push   0xc(%ebp)
  801ed9:	e8 85 ff ff ff       	call   801e63 <close>

	newfd = INDEX2FD(newfdnum);
  801ede:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ee1:	c1 e6 0c             	shl    $0xc,%esi
  801ee4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801eea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801eed:	89 3c 24             	mov    %edi,(%esp)
  801ef0:	e8 df fd ff ff       	call   801cd4 <fd2data>
  801ef5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ef7:	89 34 24             	mov    %esi,(%esp)
  801efa:	e8 d5 fd ff ff       	call   801cd4 <fd2data>
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f05:	89 d8                	mov    %ebx,%eax
  801f07:	c1 e8 16             	shr    $0x16,%eax
  801f0a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f11:	a8 01                	test   $0x1,%al
  801f13:	74 11                	je     801f26 <dup+0x71>
  801f15:	89 d8                	mov    %ebx,%eax
  801f17:	c1 e8 0c             	shr    $0xc,%eax
  801f1a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f21:	f6 c2 01             	test   $0x1,%dl
  801f24:	75 36                	jne    801f5c <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f26:	89 f8                	mov    %edi,%eax
  801f28:	c1 e8 0c             	shr    $0xc,%eax
  801f2b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	25 07 0e 00 00       	and    $0xe07,%eax
  801f3a:	50                   	push   %eax
  801f3b:	56                   	push   %esi
  801f3c:	6a 00                	push   $0x0
  801f3e:	57                   	push   %edi
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 ea f7 ff ff       	call   801730 <sys_page_map>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 20             	add    $0x20,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 33                	js     801f82 <dup+0xcd>
		goto err;

	return newfdnum;
  801f4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f5c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	25 07 0e 00 00       	and    $0xe07,%eax
  801f6b:	50                   	push   %eax
  801f6c:	ff 75 d4             	push   -0x2c(%ebp)
  801f6f:	6a 00                	push   $0x0
  801f71:	53                   	push   %ebx
  801f72:	6a 00                	push   $0x0
  801f74:	e8 b7 f7 ff ff       	call   801730 <sys_page_map>
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	83 c4 20             	add    $0x20,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	79 a4                	jns    801f26 <dup+0x71>
	sys_page_unmap(0, newfd);
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	56                   	push   %esi
  801f86:	6a 00                	push   $0x0
  801f88:	e8 e5 f7 ff ff       	call   801772 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801f8d:	83 c4 08             	add    $0x8,%esp
  801f90:	ff 75 d4             	push   -0x2c(%ebp)
  801f93:	6a 00                	push   $0x0
  801f95:	e8 d8 f7 ff ff       	call   801772 <sys_page_unmap>
	return r;
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	eb b3                	jmp    801f52 <dup+0x9d>

00801f9f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	56                   	push   %esi
  801fa3:	53                   	push   %ebx
  801fa4:	83 ec 18             	sub    $0x18,%esp
  801fa7:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801faa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fad:	50                   	push   %eax
  801fae:	56                   	push   %esi
  801faf:	e8 87 fd ff ff       	call   801d3b <fd_lookup>
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	78 3c                	js     801ff7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fbb:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801fbe:	83 ec 08             	sub    $0x8,%esp
  801fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc4:	50                   	push   %eax
  801fc5:	ff 33                	push   (%ebx)
  801fc7:	e8 bf fd ff ff       	call   801d8b <dev_lookup>
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	78 24                	js     801ff7 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fd3:	8b 43 08             	mov    0x8(%ebx),%eax
  801fd6:	83 e0 03             	and    $0x3,%eax
  801fd9:	83 f8 01             	cmp    $0x1,%eax
  801fdc:	74 20                	je     801ffe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	74 37                	je     80201f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	ff 75 10             	push   0x10(%ebp)
  801fee:	ff 75 0c             	push   0xc(%ebp)
  801ff1:	53                   	push   %ebx
  801ff2:	ff d0                	call   *%eax
  801ff4:	83 c4 10             	add    $0x10,%esp
}
  801ff7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffa:	5b                   	pop    %ebx
  801ffb:	5e                   	pop    %esi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ffe:	a1 14 50 80 00       	mov    0x805014,%eax
  802003:	8b 40 48             	mov    0x48(%eax),%eax
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	56                   	push   %esi
  80200a:	50                   	push   %eax
  80200b:	68 c1 39 80 00       	push   $0x8039c1
  802010:	e8 27 eb ff ff       	call   800b3c <cprintf>
		return -E_INVAL;
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80201d:	eb d8                	jmp    801ff7 <read+0x58>
		return -E_NOT_SUPP;
  80201f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802024:	eb d1                	jmp    801ff7 <read+0x58>

00802026 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	57                   	push   %edi
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802032:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802035:	bb 00 00 00 00       	mov    $0x0,%ebx
  80203a:	eb 02                	jmp    80203e <readn+0x18>
  80203c:	01 c3                	add    %eax,%ebx
  80203e:	39 f3                	cmp    %esi,%ebx
  802040:	73 21                	jae    802063 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	89 f0                	mov    %esi,%eax
  802047:	29 d8                	sub    %ebx,%eax
  802049:	50                   	push   %eax
  80204a:	89 d8                	mov    %ebx,%eax
  80204c:	03 45 0c             	add    0xc(%ebp),%eax
  80204f:	50                   	push   %eax
  802050:	57                   	push   %edi
  802051:	e8 49 ff ff ff       	call   801f9f <read>
		if (m < 0)
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	85 c0                	test   %eax,%eax
  80205b:	78 04                	js     802061 <readn+0x3b>
			return m;
		if (m == 0)
  80205d:	75 dd                	jne    80203c <readn+0x16>
  80205f:	eb 02                	jmp    802063 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802061:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802063:	89 d8                	mov    %ebx,%eax
  802065:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802068:	5b                   	pop    %ebx
  802069:	5e                   	pop    %esi
  80206a:	5f                   	pop    %edi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    

0080206d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	83 ec 18             	sub    $0x18,%esp
  802075:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802078:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	53                   	push   %ebx
  80207d:	e8 b9 fc ff ff       	call   801d3b <fd_lookup>
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	85 c0                	test   %eax,%eax
  802087:	78 37                	js     8020c0 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802089:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80208c:	83 ec 08             	sub    $0x8,%esp
  80208f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802092:	50                   	push   %eax
  802093:	ff 36                	push   (%esi)
  802095:	e8 f1 fc ff ff       	call   801d8b <dev_lookup>
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 1f                	js     8020c0 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020a1:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8020a5:	74 20                	je     8020c7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	74 37                	je     8020e8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	ff 75 10             	push   0x10(%ebp)
  8020b7:	ff 75 0c             	push   0xc(%ebp)
  8020ba:	56                   	push   %esi
  8020bb:	ff d0                	call   *%eax
  8020bd:	83 c4 10             	add    $0x10,%esp
}
  8020c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020c7:	a1 14 50 80 00       	mov    0x805014,%eax
  8020cc:	8b 40 48             	mov    0x48(%eax),%eax
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	53                   	push   %ebx
  8020d3:	50                   	push   %eax
  8020d4:	68 dd 39 80 00       	push   $0x8039dd
  8020d9:	e8 5e ea ff ff       	call   800b3c <cprintf>
		return -E_INVAL;
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e6:	eb d8                	jmp    8020c0 <write+0x53>
		return -E_NOT_SUPP;
  8020e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020ed:	eb d1                	jmp    8020c0 <write+0x53>

008020ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f8:	50                   	push   %eax
  8020f9:	ff 75 08             	push   0x8(%ebp)
  8020fc:	e8 3a fc ff ff       	call   801d3b <fd_lookup>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	85 c0                	test   %eax,%eax
  802106:	78 0e                	js     802116 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	56                   	push   %esi
  80211c:	53                   	push   %ebx
  80211d:	83 ec 18             	sub    $0x18,%esp
  802120:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802123:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802126:	50                   	push   %eax
  802127:	53                   	push   %ebx
  802128:	e8 0e fc ff ff       	call   801d3b <fd_lookup>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	78 34                	js     802168 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802134:	8b 75 f0             	mov    -0x10(%ebp),%esi
  802137:	83 ec 08             	sub    $0x8,%esp
  80213a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213d:	50                   	push   %eax
  80213e:	ff 36                	push   (%esi)
  802140:	e8 46 fc ff ff       	call   801d8b <dev_lookup>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 1c                	js     802168 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80214c:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  802150:	74 1d                	je     80216f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 40 18             	mov    0x18(%eax),%eax
  802158:	85 c0                	test   %eax,%eax
  80215a:	74 34                	je     802190 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	ff 75 0c             	push   0xc(%ebp)
  802162:	56                   	push   %esi
  802163:	ff d0                	call   *%eax
  802165:	83 c4 10             	add    $0x10,%esp
}
  802168:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80216f:	a1 14 50 80 00       	mov    0x805014,%eax
  802174:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	53                   	push   %ebx
  80217b:	50                   	push   %eax
  80217c:	68 a0 39 80 00       	push   $0x8039a0
  802181:	e8 b6 e9 ff ff       	call   800b3c <cprintf>
		return -E_INVAL;
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80218e:	eb d8                	jmp    802168 <ftruncate+0x50>
		return -E_NOT_SUPP;
  802190:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802195:	eb d1                	jmp    802168 <ftruncate+0x50>

00802197 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	56                   	push   %esi
  80219b:	53                   	push   %ebx
  80219c:	83 ec 18             	sub    $0x18,%esp
  80219f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021a5:	50                   	push   %eax
  8021a6:	ff 75 08             	push   0x8(%ebp)
  8021a9:	e8 8d fb ff ff       	call   801d3b <fd_lookup>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 49                	js     8021fe <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021b5:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8021b8:	83 ec 08             	sub    $0x8,%esp
  8021bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021be:	50                   	push   %eax
  8021bf:	ff 36                	push   (%esi)
  8021c1:	e8 c5 fb ff ff       	call   801d8b <dev_lookup>
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	78 31                	js     8021fe <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8021d4:	74 2f                	je     802205 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8021d6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8021d9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8021e0:	00 00 00 
	stat->st_isdir = 0;
  8021e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021ea:	00 00 00 
	stat->st_dev = dev;
  8021ed:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8021f3:	83 ec 08             	sub    $0x8,%esp
  8021f6:	53                   	push   %ebx
  8021f7:	56                   	push   %esi
  8021f8:	ff 50 14             	call   *0x14(%eax)
  8021fb:	83 c4 10             	add    $0x10,%esp
}
  8021fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
		return -E_NOT_SUPP;
  802205:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80220a:	eb f2                	jmp    8021fe <fstat+0x67>

0080220c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	56                   	push   %esi
  802210:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802211:	83 ec 08             	sub    $0x8,%esp
  802214:	6a 00                	push   $0x0
  802216:	ff 75 08             	push   0x8(%ebp)
  802219:	e8 22 02 00 00       	call   802440 <open>
  80221e:	89 c3                	mov    %eax,%ebx
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	85 c0                	test   %eax,%eax
  802225:	78 1b                	js     802242 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802227:	83 ec 08             	sub    $0x8,%esp
  80222a:	ff 75 0c             	push   0xc(%ebp)
  80222d:	50                   	push   %eax
  80222e:	e8 64 ff ff ff       	call   802197 <fstat>
  802233:	89 c6                	mov    %eax,%esi
	close(fd);
  802235:	89 1c 24             	mov    %ebx,(%esp)
  802238:	e8 26 fc ff ff       	call   801e63 <close>
	return r;
  80223d:	83 c4 10             	add    $0x10,%esp
  802240:	89 f3                	mov    %esi,%ebx
}
  802242:	89 d8                	mov    %ebx,%eax
  802244:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5d                   	pop    %ebp
  80224a:	c3                   	ret    

0080224b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	56                   	push   %esi
  80224f:	53                   	push   %ebx
  802250:	89 c6                	mov    %eax,%esi
  802252:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802254:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80225b:	74 27                	je     802284 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80225d:	6a 07                	push   $0x7
  80225f:	68 00 60 80 00       	push   $0x806000
  802264:	56                   	push   %esi
  802265:	ff 35 00 70 80 00    	push   0x807000
  80226b:	e8 e9 0d 00 00       	call   803059 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802270:	83 c4 0c             	add    $0xc,%esp
  802273:	6a 00                	push   $0x0
  802275:	53                   	push   %ebx
  802276:	6a 00                	push   $0x0
  802278:	e8 8d 0d 00 00       	call   80300a <ipc_recv>
}
  80227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	6a 01                	push   $0x1
  802289:	e8 17 0e 00 00       	call   8030a5 <ipc_find_env>
  80228e:	a3 00 70 80 00       	mov    %eax,0x807000
  802293:	83 c4 10             	add    $0x10,%esp
  802296:	eb c5                	jmp    80225d <fsipc+0x12>

00802298 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ac:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8022b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b6:	b8 02 00 00 00       	mov    $0x2,%eax
  8022bb:	e8 8b ff ff ff       	call   80224b <fsipc>
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <devfile_flush>:
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ce:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8022d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8022dd:	e8 69 ff ff ff       	call   80224b <fsipc>
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <devfile_stat>:
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8022f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022fe:	b8 05 00 00 00       	mov    $0x5,%eax
  802303:	e8 43 ff ff ff       	call   80224b <fsipc>
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 2c                	js     802338 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80230c:	83 ec 08             	sub    $0x8,%esp
  80230f:	68 00 60 80 00       	push   $0x806000
  802314:	53                   	push   %ebx
  802315:	e8 d7 ef ff ff       	call   8012f1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80231a:	a1 80 60 80 00       	mov    0x806080,%eax
  80231f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802325:	a1 84 60 80 00       	mov    0x806084,%eax
  80232a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802330:	83 c4 10             	add    $0x10,%esp
  802333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <devfile_write>:
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	53                   	push   %ebx
  802341:	83 ec 08             	sub    $0x8,%esp
  802344:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8b 40 0c             	mov    0xc(%eax),%eax
  80234d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802352:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802358:	53                   	push   %ebx
  802359:	ff 75 0c             	push   0xc(%ebp)
  80235c:	68 08 60 80 00       	push   $0x806008
  802361:	e8 83 f1 ff ff       	call   8014e9 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802366:	ba 00 00 00 00       	mov    $0x0,%edx
  80236b:	b8 04 00 00 00       	mov    $0x4,%eax
  802370:	e8 d6 fe ff ff       	call   80224b <fsipc>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 c0                	test   %eax,%eax
  80237a:	78 0b                	js     802387 <devfile_write+0x4a>
	assert(r <= n);
  80237c:	39 d8                	cmp    %ebx,%eax
  80237e:	77 0c                	ja     80238c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802380:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802385:	7f 1e                	jg     8023a5 <devfile_write+0x68>
}
  802387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    
	assert(r <= n);
  80238c:	68 0c 3a 80 00       	push   $0x803a0c
  802391:	68 a6 34 80 00       	push   $0x8034a6
  802396:	68 97 00 00 00       	push   $0x97
  80239b:	68 13 3a 80 00       	push   $0x803a13
  8023a0:	e8 bc e6 ff ff       	call   800a61 <_panic>
	assert(r <= PGSIZE);
  8023a5:	68 1e 3a 80 00       	push   $0x803a1e
  8023aa:	68 a6 34 80 00       	push   $0x8034a6
  8023af:	68 98 00 00 00       	push   $0x98
  8023b4:	68 13 3a 80 00       	push   $0x803a13
  8023b9:	e8 a3 e6 ff ff       	call   800a61 <_panic>

008023be <devfile_read>:
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	56                   	push   %esi
  8023c2:	53                   	push   %ebx
  8023c3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8023d1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8023d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8023e1:	e8 65 fe ff ff       	call   80224b <fsipc>
  8023e6:	89 c3                	mov    %eax,%ebx
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	78 1f                	js     80240b <devfile_read+0x4d>
	assert(r <= n);
  8023ec:	39 f0                	cmp    %esi,%eax
  8023ee:	77 24                	ja     802414 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8023f0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8023f5:	7f 33                	jg     80242a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8023f7:	83 ec 04             	sub    $0x4,%esp
  8023fa:	50                   	push   %eax
  8023fb:	68 00 60 80 00       	push   $0x806000
  802400:	ff 75 0c             	push   0xc(%ebp)
  802403:	e8 7f f0 ff ff       	call   801487 <memmove>
	return r;
  802408:	83 c4 10             	add    $0x10,%esp
}
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    
	assert(r <= n);
  802414:	68 0c 3a 80 00       	push   $0x803a0c
  802419:	68 a6 34 80 00       	push   $0x8034a6
  80241e:	6a 7c                	push   $0x7c
  802420:	68 13 3a 80 00       	push   $0x803a13
  802425:	e8 37 e6 ff ff       	call   800a61 <_panic>
	assert(r <= PGSIZE);
  80242a:	68 1e 3a 80 00       	push   $0x803a1e
  80242f:	68 a6 34 80 00       	push   $0x8034a6
  802434:	6a 7d                	push   $0x7d
  802436:	68 13 3a 80 00       	push   $0x803a13
  80243b:	e8 21 e6 ff ff       	call   800a61 <_panic>

00802440 <open>:
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	56                   	push   %esi
  802444:	53                   	push   %ebx
  802445:	83 ec 1c             	sub    $0x1c,%esp
  802448:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80244b:	56                   	push   %esi
  80244c:	e8 65 ee ff ff       	call   8012b6 <strlen>
  802451:	83 c4 10             	add    $0x10,%esp
  802454:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802459:	7f 6c                	jg     8024c7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80245b:	83 ec 0c             	sub    $0xc,%esp
  80245e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802461:	50                   	push   %eax
  802462:	e8 84 f8 ff ff       	call   801ceb <fd_alloc>
  802467:	89 c3                	mov    %eax,%ebx
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	85 c0                	test   %eax,%eax
  80246e:	78 3c                	js     8024ac <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802470:	83 ec 08             	sub    $0x8,%esp
  802473:	56                   	push   %esi
  802474:	68 00 60 80 00       	push   $0x806000
  802479:	e8 73 ee ff ff       	call   8012f1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80247e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802481:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802486:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802489:	b8 01 00 00 00       	mov    $0x1,%eax
  80248e:	e8 b8 fd ff ff       	call   80224b <fsipc>
  802493:	89 c3                	mov    %eax,%ebx
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	85 c0                	test   %eax,%eax
  80249a:	78 19                	js     8024b5 <open+0x75>
	return fd2num(fd);
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	ff 75 f4             	push   -0xc(%ebp)
  8024a2:	e8 1d f8 ff ff       	call   801cc4 <fd2num>
  8024a7:	89 c3                	mov    %eax,%ebx
  8024a9:	83 c4 10             	add    $0x10,%esp
}
  8024ac:	89 d8                	mov    %ebx,%eax
  8024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    
		fd_close(fd, 0);
  8024b5:	83 ec 08             	sub    $0x8,%esp
  8024b8:	6a 00                	push   $0x0
  8024ba:	ff 75 f4             	push   -0xc(%ebp)
  8024bd:	e8 1a f9 ff ff       	call   801ddc <fd_close>
		return r;
  8024c2:	83 c4 10             	add    $0x10,%esp
  8024c5:	eb e5                	jmp    8024ac <open+0x6c>
		return -E_BAD_PATH;
  8024c7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8024cc:	eb de                	jmp    8024ac <open+0x6c>

008024ce <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8024d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8024de:	e8 68 fd ff ff       	call   80224b <fsipc>
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8024e5:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8024e9:	7f 01                	jg     8024ec <writebuf+0x7>
  8024eb:	c3                   	ret    
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 08             	sub    $0x8,%esp
  8024f3:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8024f5:	ff 70 04             	push   0x4(%eax)
  8024f8:	8d 40 10             	lea    0x10(%eax),%eax
  8024fb:	50                   	push   %eax
  8024fc:	ff 33                	push   (%ebx)
  8024fe:	e8 6a fb ff ff       	call   80206d <write>
		if (result > 0)
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	85 c0                	test   %eax,%eax
  802508:	7e 03                	jle    80250d <writebuf+0x28>
			b->result += result;
  80250a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80250d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802510:	74 0d                	je     80251f <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  802512:	85 c0                	test   %eax,%eax
  802514:	ba 00 00 00 00       	mov    $0x0,%edx
  802519:	0f 4f c2             	cmovg  %edx,%eax
  80251c:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <putch>:

static void
putch(int ch, void *thunk)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	53                   	push   %ebx
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80252e:	8b 53 04             	mov    0x4(%ebx),%edx
  802531:	8d 42 01             	lea    0x1(%edx),%eax
  802534:	89 43 04             	mov    %eax,0x4(%ebx)
  802537:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80253e:	3d 00 01 00 00       	cmp    $0x100,%eax
  802543:	74 05                	je     80254a <putch+0x26>
		writebuf(b);
		b->idx = 0;
	}
}
  802545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802548:	c9                   	leave  
  802549:	c3                   	ret    
		writebuf(b);
  80254a:	89 d8                	mov    %ebx,%eax
  80254c:	e8 94 ff ff ff       	call   8024e5 <writebuf>
		b->idx = 0;
  802551:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802558:	eb eb                	jmp    802545 <putch+0x21>

0080255a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80256c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802573:	00 00 00 
	b.result = 0;
  802576:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80257d:	00 00 00 
	b.error = 1;
  802580:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802587:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80258a:	ff 75 10             	push   0x10(%ebp)
  80258d:	ff 75 0c             	push   0xc(%ebp)
  802590:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802596:	50                   	push   %eax
  802597:	68 24 25 80 00       	push   $0x802524
  80259c:	e8 92 e6 ff ff       	call   800c33 <vprintfmt>
	if (b.idx > 0)
  8025a1:	83 c4 10             	add    $0x10,%esp
  8025a4:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8025ab:	7f 11                	jg     8025be <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8025ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    
		writebuf(&b);
  8025be:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025c4:	e8 1c ff ff ff       	call   8024e5 <writebuf>
  8025c9:	eb e2                	jmp    8025ad <vfprintf+0x53>

008025cb <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8025d1:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8025d4:	50                   	push   %eax
  8025d5:	ff 75 0c             	push   0xc(%ebp)
  8025d8:	ff 75 08             	push   0x8(%ebp)
  8025db:	e8 7a ff ff ff       	call   80255a <vfprintf>
	va_end(ap);

	return cnt;
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <printf>:

int
printf(const char *fmt, ...)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8025e8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8025eb:	50                   	push   %eax
  8025ec:	ff 75 08             	push   0x8(%ebp)
  8025ef:	6a 01                	push   $0x1
  8025f1:	e8 64 ff ff ff       	call   80255a <vfprintf>
	va_end(ap);

	return cnt;
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	57                   	push   %edi
  8025fc:	56                   	push   %esi
  8025fd:	53                   	push   %ebx
  8025fe:	81 ec 84 02 00 00    	sub    $0x284,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802604:	6a 00                	push   $0x0
  802606:	ff 75 08             	push   0x8(%ebp)
  802609:	e8 32 fe ff ff       	call   802440 <open>
  80260e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802614:	83 c4 10             	add    $0x10,%esp
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 d0 04 00 00    	js     802aef <spawn+0x4f7>
  80261f:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 00 02 00 00       	push   $0x200
  802629:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80262f:	50                   	push   %eax
  802630:	51                   	push   %ecx
  802631:	e8 f0 f9 ff ff       	call   802026 <readn>
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	3d 00 02 00 00       	cmp    $0x200,%eax
  80263e:	75 57                	jne    802697 <spawn+0x9f>
	    || elf->e_magic != ELF_MAGIC) {
  802640:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802647:	45 4c 46 
  80264a:	75 4b                	jne    802697 <spawn+0x9f>
  80264c:	b8 07 00 00 00       	mov    $0x7,%eax
  802651:	cd 30                	int    $0x30
  802653:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802659:	85 c0                	test   %eax,%eax
  80265b:	0f 88 82 04 00 00    	js     802ae3 <spawn+0x4eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802661:	25 ff 03 00 00       	and    $0x3ff,%eax
  802666:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802669:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80266f:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802675:	b9 11 00 00 00       	mov    $0x11,%ecx
  80267a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80267c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802682:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802688:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80268d:	be 00 00 00 00       	mov    $0x0,%esi
  802692:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  802695:	eb 4b                	jmp    8026e2 <spawn+0xea>
		close(fd);
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8026a0:	e8 be f7 ff ff       	call   801e63 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8026a5:	83 c4 0c             	add    $0xc,%esp
  8026a8:	68 7f 45 4c 46       	push   $0x464c457f
  8026ad:	ff b5 e8 fd ff ff    	push   -0x218(%ebp)
  8026b3:	68 2a 3a 80 00       	push   $0x803a2a
  8026b8:	e8 7f e4 ff ff       	call   800b3c <cprintf>
		return -E_NOT_EXEC;
  8026bd:	83 c4 10             	add    $0x10,%esp
  8026c0:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  8026c7:	ff ff ff 
  8026ca:	e9 20 04 00 00       	jmp    802aef <spawn+0x4f7>
		string_size += strlen(argv[argc]) + 1;
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	50                   	push   %eax
  8026d3:	e8 de eb ff ff       	call   8012b6 <strlen>
  8026d8:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8026dc:	83 c3 01             	add    $0x1,%ebx
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8026e9:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	75 df                	jne    8026cf <spawn+0xd7>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8026f0:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8026f6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8026fc:	b8 00 10 40 00       	mov    $0x401000,%eax
  802701:	29 f0                	sub    %esi,%eax
  802703:	89 c7                	mov    %eax,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802705:	89 c2                	mov    %eax,%edx
  802707:	83 e2 fc             	and    $0xfffffffc,%edx
  80270a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802711:	29 c2                	sub    %eax,%edx
  802713:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802719:	8d 42 f8             	lea    -0x8(%edx),%eax
  80271c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802721:	0f 86 eb 03 00 00    	jbe    802b12 <spawn+0x51a>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	6a 07                	push   $0x7
  80272c:	68 00 00 40 00       	push   $0x400000
  802731:	6a 00                	push   $0x0
  802733:	e8 b5 ef ff ff       	call   8016ed <sys_page_alloc>
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	0f 88 d4 03 00 00    	js     802b17 <spawn+0x51f>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802743:	be 00 00 00 00       	mov    $0x0,%esi
  802748:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  80274e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802751:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  802757:	7e 32                	jle    80278b <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  802759:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80275f:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802765:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802768:	83 ec 08             	sub    $0x8,%esp
  80276b:	ff 34 b3             	push   (%ebx,%esi,4)
  80276e:	57                   	push   %edi
  80276f:	e8 7d eb ff ff       	call   8012f1 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802774:	83 c4 04             	add    $0x4,%esp
  802777:	ff 34 b3             	push   (%ebx,%esi,4)
  80277a:	e8 37 eb ff ff       	call   8012b6 <strlen>
  80277f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802783:	83 c6 01             	add    $0x1,%esi
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	eb c6                	jmp    802751 <spawn+0x159>
	}
	argv_store[argc] = 0;
  80278b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802791:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802797:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80279e:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8027a4:	0f 85 8c 00 00 00    	jne    802836 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8027aa:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8027b0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8027b6:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  8027b9:	89 f8                	mov    %edi,%eax
  8027bb:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  8027c1:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8027c4:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8027c9:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	6a 07                	push   $0x7
  8027d4:	68 00 d0 bf ee       	push   $0xeebfd000
  8027d9:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8027df:	68 00 00 40 00       	push   $0x400000
  8027e4:	6a 00                	push   $0x0
  8027e6:	e8 45 ef ff ff       	call   801730 <sys_page_map>
  8027eb:	89 c3                	mov    %eax,%ebx
  8027ed:	83 c4 20             	add    $0x20,%esp
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	0f 88 27 03 00 00    	js     802b1f <spawn+0x527>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8027f8:	83 ec 08             	sub    $0x8,%esp
  8027fb:	68 00 00 40 00       	push   $0x400000
  802800:	6a 00                	push   $0x0
  802802:	e8 6b ef ff ff       	call   801772 <sys_page_unmap>
  802807:	89 c3                	mov    %eax,%ebx
  802809:	83 c4 10             	add    $0x10,%esp
  80280c:	85 c0                	test   %eax,%eax
  80280e:	0f 88 0b 03 00 00    	js     802b1f <spawn+0x527>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802814:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80281a:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802821:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802827:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  80282e:	00 00 00 
  802831:	e9 4e 01 00 00       	jmp    802984 <spawn+0x38c>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802836:	68 88 3a 80 00       	push   $0x803a88
  80283b:	68 a6 34 80 00       	push   $0x8034a6
  802840:	68 f2 00 00 00       	push   $0xf2
  802845:	68 44 3a 80 00       	push   $0x803a44
  80284a:	e8 12 e2 ff ff       	call   800a61 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	6a 07                	push   $0x7
  802854:	68 00 00 40 00       	push   $0x400000
  802859:	6a 00                	push   $0x0
  80285b:	e8 8d ee ff ff       	call   8016ed <sys_page_alloc>
  802860:	83 c4 10             	add    $0x10,%esp
  802863:	85 c0                	test   %eax,%eax
  802865:	0f 88 92 02 00 00    	js     802afd <spawn+0x505>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80286b:	83 ec 08             	sub    $0x8,%esp
  80286e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802874:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
  80287a:	50                   	push   %eax
  80287b:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  802881:	e8 69 f8 ff ff       	call   8020ef <seek>
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	85 c0                	test   %eax,%eax
  80288b:	0f 88 73 02 00 00    	js     802b04 <spawn+0x50c>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	89 f8                	mov    %edi,%eax
  802896:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
  80289c:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028a1:	39 d0                	cmp    %edx,%eax
  8028a3:	0f 47 c2             	cmova  %edx,%eax
  8028a6:	50                   	push   %eax
  8028a7:	68 00 00 40 00       	push   $0x400000
  8028ac:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  8028b2:	e8 6f f7 ff ff       	call   802026 <readn>
  8028b7:	83 c4 10             	add    $0x10,%esp
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	0f 88 49 02 00 00    	js     802b0b <spawn+0x513>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8028c2:	83 ec 0c             	sub    $0xc,%esp
  8028c5:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  8028cb:	56                   	push   %esi
  8028cc:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  8028d2:	68 00 00 40 00       	push   $0x400000
  8028d7:	6a 00                	push   $0x0
  8028d9:	e8 52 ee ff ff       	call   801730 <sys_page_map>
  8028de:	83 c4 20             	add    $0x20,%esp
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	78 7c                	js     802961 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8028e5:	83 ec 08             	sub    $0x8,%esp
  8028e8:	68 00 00 40 00       	push   $0x400000
  8028ed:	6a 00                	push   $0x0
  8028ef:	e8 7e ee ff ff       	call   801772 <sys_page_unmap>
  8028f4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8028f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8028fd:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802903:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802909:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
  80290f:	76 65                	jbe    802976 <spawn+0x37e>
		if (i >= filesz) {
  802911:	39 df                	cmp    %ebx,%edi
  802913:	0f 87 36 ff ff ff    	ja     80284f <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	ff b5 84 fd ff ff    	push   -0x27c(%ebp)
  802922:	56                   	push   %esi
  802923:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802929:	e8 bf ed ff ff       	call   8016ed <sys_page_alloc>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	85 c0                	test   %eax,%eax
  802933:	79 c2                	jns    8028f7 <spawn+0x2ff>
  802935:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802940:	e8 29 ed ff ff       	call   80166e <sys_env_destroy>
	close(fd);
  802945:	83 c4 04             	add    $0x4,%esp
  802948:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  80294e:	e8 10 f5 ff ff       	call   801e63 <close>
	return r;
  802953:	83 c4 10             	add    $0x10,%esp
  802956:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  80295c:	e9 8e 01 00 00       	jmp    802aef <spawn+0x4f7>
				panic("spawn: sys_page_map data: %e", r);
  802961:	50                   	push   %eax
  802962:	68 50 3a 80 00       	push   $0x803a50
  802967:	68 25 01 00 00       	push   $0x125
  80296c:	68 44 3a 80 00       	push   $0x803a44
  802971:	e8 eb e0 ff ff       	call   800a61 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802976:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80297d:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  802984:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80298b:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802991:	7e 67                	jle    8029fa <spawn+0x402>
		if (ph->p_type != ELF_PROG_LOAD)
  802993:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  802999:	83 39 01             	cmpl   $0x1,(%ecx)
  80299c:	75 d8                	jne    802976 <spawn+0x37e>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80299e:	8b 41 18             	mov    0x18(%ecx),%eax
  8029a1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8029a7:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8029aa:	83 f8 01             	cmp    $0x1,%eax
  8029ad:	19 c0                	sbb    %eax,%eax
  8029af:	83 e0 fe             	and    $0xfffffffe,%eax
  8029b2:	83 c0 07             	add    $0x7,%eax
  8029b5:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8029bb:	8b 51 04             	mov    0x4(%ecx),%edx
  8029be:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  8029c4:	8b 79 10             	mov    0x10(%ecx),%edi
  8029c7:	8b 59 14             	mov    0x14(%ecx),%ebx
  8029ca:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8029d0:	8b 71 08             	mov    0x8(%ecx),%esi
	if ((i = PGOFF(va))) {
  8029d3:	89 f0                	mov    %esi,%eax
  8029d5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8029da:	74 14                	je     8029f0 <spawn+0x3f8>
		va -= i;
  8029dc:	29 c6                	sub    %eax,%esi
		memsz += i;
  8029de:	01 c3                	add    %eax,%ebx
  8029e0:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
		filesz += i;
  8029e6:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  8029e8:	29 c2                	sub    %eax,%edx
  8029ea:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8029f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029f5:	e9 09 ff ff ff       	jmp    802903 <spawn+0x30b>
	close(fd);
  8029fa:	83 ec 0c             	sub    $0xc,%esp
  8029fd:	ff b5 8c fd ff ff    	push   -0x274(%ebp)
  802a03:	e8 5b f4 ff ff       	call   801e63 <close>
  802a08:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  802a0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a10:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802a16:	eb 2d                	jmp    802a45 <spawn+0x44d>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
			 sys_page_map(0, (void *)(pn * PGSIZE), child, (void *)(pn * PGSIZE), uvpt[pn] & PTE_SYSCALL);
  802a18:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802a1f:	89 da                	mov    %ebx,%edx
  802a21:	c1 e2 0c             	shl    $0xc,%edx
  802a24:	83 ec 0c             	sub    $0xc,%esp
  802a27:	25 07 0e 00 00       	and    $0xe07,%eax
  802a2c:	50                   	push   %eax
  802a2d:	52                   	push   %edx
  802a2e:	56                   	push   %esi
  802a2f:	52                   	push   %edx
  802a30:	6a 00                	push   $0x0
  802a32:	e8 f9 ec ff ff       	call   801730 <sys_page_map>
  802a37:	83 c4 20             	add    $0x20,%esp
	for (int pn = 0; pn < UTOP / PGSIZE; pn++) {
  802a3a:	83 c3 01             	add    $0x1,%ebx
  802a3d:	81 fb 00 ec 0e 00    	cmp    $0xeec00,%ebx
  802a43:	74 29                	je     802a6e <spawn+0x476>
		if ((uvpd[pn >> 10]) && (uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  802a45:	89 d8                	mov    %ebx,%eax
  802a47:	c1 f8 0a             	sar    $0xa,%eax
  802a4a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 e5                	je     802a3a <spawn+0x442>
  802a55:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802a5c:	a8 01                	test   $0x1,%al
  802a5e:	74 da                	je     802a3a <spawn+0x442>
  802a60:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802a67:	f6 c4 04             	test   $0x4,%ah
  802a6a:	74 ce                	je     802a3a <spawn+0x442>
  802a6c:	eb aa                	jmp    802a18 <spawn+0x420>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802a6e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802a75:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802a78:	83 ec 08             	sub    $0x8,%esp
  802a7b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802a81:	50                   	push   %eax
  802a82:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802a88:	e8 69 ed ff ff       	call   8017f6 <sys_env_set_trapframe>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	85 c0                	test   %eax,%eax
  802a92:	78 25                	js     802ab9 <spawn+0x4c1>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802a94:	83 ec 08             	sub    $0x8,%esp
  802a97:	6a 02                	push   $0x2
  802a99:	ff b5 88 fd ff ff    	push   -0x278(%ebp)
  802a9f:	e8 10 ed ff ff       	call   8017b4 <sys_env_set_status>
  802aa4:	83 c4 10             	add    $0x10,%esp
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	78 23                	js     802ace <spawn+0x4d6>
	return child;
  802aab:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802ab1:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802ab7:	eb 36                	jmp    802aef <spawn+0x4f7>
		panic("sys_env_set_trapframe: %e", r);
  802ab9:	50                   	push   %eax
  802aba:	68 6d 3a 80 00       	push   $0x803a6d
  802abf:	68 86 00 00 00       	push   $0x86
  802ac4:	68 44 3a 80 00       	push   $0x803a44
  802ac9:	e8 93 df ff ff       	call   800a61 <_panic>
		panic("sys_env_set_status: %e", r);
  802ace:	50                   	push   %eax
  802acf:	68 53 39 80 00       	push   $0x803953
  802ad4:	68 89 00 00 00       	push   $0x89
  802ad9:	68 44 3a 80 00       	push   $0x803a44
  802ade:	e8 7e df ff ff       	call   800a61 <_panic>
		return r;
  802ae3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802ae9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  802aef:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af8:	5b                   	pop    %ebx
  802af9:	5e                   	pop    %esi
  802afa:	5f                   	pop    %edi
  802afb:	5d                   	pop    %ebp
  802afc:	c3                   	ret    
  802afd:	89 c7                	mov    %eax,%edi
  802aff:	e9 33 fe ff ff       	jmp    802937 <spawn+0x33f>
  802b04:	89 c7                	mov    %eax,%edi
  802b06:	e9 2c fe ff ff       	jmp    802937 <spawn+0x33f>
  802b0b:	89 c7                	mov    %eax,%edi
  802b0d:	e9 25 fe ff ff       	jmp    802937 <spawn+0x33f>
		return -E_NO_MEM;
  802b12:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802b17:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802b1d:	eb d0                	jmp    802aef <spawn+0x4f7>
	sys_page_unmap(0, UTEMP);
  802b1f:	83 ec 08             	sub    $0x8,%esp
  802b22:	68 00 00 40 00       	push   $0x400000
  802b27:	6a 00                	push   $0x0
  802b29:	e8 44 ec ff ff       	call   801772 <sys_page_unmap>
  802b2e:	83 c4 10             	add    $0x10,%esp
  802b31:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802b37:	eb b6                	jmp    802aef <spawn+0x4f7>

00802b39 <spawnl>:
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
  802b3c:	56                   	push   %esi
  802b3d:	53                   	push   %ebx
	va_start(vl, arg0);
  802b3e:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802b46:	eb 05                	jmp    802b4d <spawnl+0x14>
		argc++;
  802b48:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802b4b:	89 ca                	mov    %ecx,%edx
  802b4d:	8d 4a 04             	lea    0x4(%edx),%ecx
  802b50:	83 3a 00             	cmpl   $0x0,(%edx)
  802b53:	75 f3                	jne    802b48 <spawnl+0xf>
	const char *argv[argc+2];
  802b55:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802b5c:	89 d3                	mov    %edx,%ebx
  802b5e:	83 e3 f0             	and    $0xfffffff0,%ebx
  802b61:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802b67:	89 e1                	mov    %esp,%ecx
  802b69:	29 d1                	sub    %edx,%ecx
  802b6b:	39 cc                	cmp    %ecx,%esp
  802b6d:	74 10                	je     802b7f <spawnl+0x46>
  802b6f:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802b75:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802b7c:	00 
  802b7d:	eb ec                	jmp    802b6b <spawnl+0x32>
  802b7f:	89 da                	mov    %ebx,%edx
  802b81:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802b87:	29 d4                	sub    %edx,%esp
  802b89:	85 d2                	test   %edx,%edx
  802b8b:	74 05                	je     802b92 <spawnl+0x59>
  802b8d:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802b92:	8d 5c 24 03          	lea    0x3(%esp),%ebx
  802b96:	89 da                	mov    %ebx,%edx
  802b98:	c1 ea 02             	shr    $0x2,%edx
  802b9b:	83 e3 fc             	and    $0xfffffffc,%ebx
	argv[0] = arg0;
  802b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ba1:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802ba8:	c7 44 83 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,4)
  802baf:	00 
	va_start(vl, arg0);
  802bb0:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802bb3:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bba:	eb 0b                	jmp    802bc7 <spawnl+0x8e>
		argv[i+1] = va_arg(vl, const char *);
  802bbc:	83 c0 01             	add    $0x1,%eax
  802bbf:	8b 31                	mov    (%ecx),%esi
  802bc1:	89 34 83             	mov    %esi,(%ebx,%eax,4)
  802bc4:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802bc7:	39 d0                	cmp    %edx,%eax
  802bc9:	75 f1                	jne    802bbc <spawnl+0x83>
	return spawn(prog, argv);
  802bcb:	83 ec 08             	sub    $0x8,%esp
  802bce:	53                   	push   %ebx
  802bcf:	ff 75 08             	push   0x8(%ebp)
  802bd2:	e8 21 fa ff ff       	call   8025f8 <spawn>
}
  802bd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bda:	5b                   	pop    %ebx
  802bdb:	5e                   	pop    %esi
  802bdc:	5d                   	pop    %ebp
  802bdd:	c3                   	ret    

00802bde <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
  802be1:	56                   	push   %esi
  802be2:	53                   	push   %ebx
  802be3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802be6:	83 ec 0c             	sub    $0xc,%esp
  802be9:	ff 75 08             	push   0x8(%ebp)
  802bec:	e8 e3 f0 ff ff       	call   801cd4 <fd2data>
  802bf1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bf3:	83 c4 08             	add    $0x8,%esp
  802bf6:	68 ae 3a 80 00       	push   $0x803aae
  802bfb:	53                   	push   %ebx
  802bfc:	e8 f0 e6 ff ff       	call   8012f1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c01:	8b 46 04             	mov    0x4(%esi),%eax
  802c04:	2b 06                	sub    (%esi),%eax
  802c06:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c0c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c13:	00 00 00 
	stat->st_dev = &devpipe;
  802c16:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802c1d:	40 80 00 
	return 0;
}
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
  802c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c28:	5b                   	pop    %ebx
  802c29:	5e                   	pop    %esi
  802c2a:	5d                   	pop    %ebp
  802c2b:	c3                   	ret    

00802c2c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
  802c2f:	53                   	push   %ebx
  802c30:	83 ec 0c             	sub    $0xc,%esp
  802c33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c36:	53                   	push   %ebx
  802c37:	6a 00                	push   $0x0
  802c39:	e8 34 eb ff ff       	call   801772 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c3e:	89 1c 24             	mov    %ebx,(%esp)
  802c41:	e8 8e f0 ff ff       	call   801cd4 <fd2data>
  802c46:	83 c4 08             	add    $0x8,%esp
  802c49:	50                   	push   %eax
  802c4a:	6a 00                	push   $0x0
  802c4c:	e8 21 eb ff ff       	call   801772 <sys_page_unmap>
}
  802c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <_pipeisclosed>:
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	57                   	push   %edi
  802c5a:	56                   	push   %esi
  802c5b:	53                   	push   %ebx
  802c5c:	83 ec 1c             	sub    $0x1c,%esp
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c63:	a1 14 50 80 00       	mov    0x805014,%eax
  802c68:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c6b:	83 ec 0c             	sub    $0xc,%esp
  802c6e:	57                   	push   %edi
  802c6f:	e8 6a 04 00 00       	call   8030de <pageref>
  802c74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c77:	89 34 24             	mov    %esi,(%esp)
  802c7a:	e8 5f 04 00 00       	call   8030de <pageref>
		nn = thisenv->env_runs;
  802c7f:	8b 15 14 50 80 00    	mov    0x805014,%edx
  802c85:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c88:	83 c4 10             	add    $0x10,%esp
  802c8b:	39 cb                	cmp    %ecx,%ebx
  802c8d:	74 1b                	je     802caa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802c8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802c92:	75 cf                	jne    802c63 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c94:	8b 42 58             	mov    0x58(%edx),%eax
  802c97:	6a 01                	push   $0x1
  802c99:	50                   	push   %eax
  802c9a:	53                   	push   %ebx
  802c9b:	68 b5 3a 80 00       	push   $0x803ab5
  802ca0:	e8 97 de ff ff       	call   800b3c <cprintf>
  802ca5:	83 c4 10             	add    $0x10,%esp
  802ca8:	eb b9                	jmp    802c63 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802caa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cad:	0f 94 c0             	sete   %al
  802cb0:	0f b6 c0             	movzbl %al,%eax
}
  802cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cb6:	5b                   	pop    %ebx
  802cb7:	5e                   	pop    %esi
  802cb8:	5f                   	pop    %edi
  802cb9:	5d                   	pop    %ebp
  802cba:	c3                   	ret    

00802cbb <devpipe_write>:
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	57                   	push   %edi
  802cbf:	56                   	push   %esi
  802cc0:	53                   	push   %ebx
  802cc1:	83 ec 28             	sub    $0x28,%esp
  802cc4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cc7:	56                   	push   %esi
  802cc8:	e8 07 f0 ff ff       	call   801cd4 <fd2data>
  802ccd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ccf:	83 c4 10             	add    $0x10,%esp
  802cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cda:	75 09                	jne    802ce5 <devpipe_write+0x2a>
	return i;
  802cdc:	89 f8                	mov    %edi,%eax
  802cde:	eb 23                	jmp    802d03 <devpipe_write+0x48>
			sys_yield();
  802ce0:	e8 e9 e9 ff ff       	call   8016ce <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ce5:	8b 43 04             	mov    0x4(%ebx),%eax
  802ce8:	8b 0b                	mov    (%ebx),%ecx
  802cea:	8d 51 20             	lea    0x20(%ecx),%edx
  802ced:	39 d0                	cmp    %edx,%eax
  802cef:	72 1a                	jb     802d0b <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  802cf1:	89 da                	mov    %ebx,%edx
  802cf3:	89 f0                	mov    %esi,%eax
  802cf5:	e8 5c ff ff ff       	call   802c56 <_pipeisclosed>
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 e2                	je     802ce0 <devpipe_write+0x25>
				return 0;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d06:	5b                   	pop    %ebx
  802d07:	5e                   	pop    %esi
  802d08:	5f                   	pop    %edi
  802d09:	5d                   	pop    %ebp
  802d0a:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d0e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d12:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d15:	89 c2                	mov    %eax,%edx
  802d17:	c1 fa 1f             	sar    $0x1f,%edx
  802d1a:	89 d1                	mov    %edx,%ecx
  802d1c:	c1 e9 1b             	shr    $0x1b,%ecx
  802d1f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d22:	83 e2 1f             	and    $0x1f,%edx
  802d25:	29 ca                	sub    %ecx,%edx
  802d27:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d2b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d2f:	83 c0 01             	add    $0x1,%eax
  802d32:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d35:	83 c7 01             	add    $0x1,%edi
  802d38:	eb 9d                	jmp    802cd7 <devpipe_write+0x1c>

00802d3a <devpipe_read>:
{
  802d3a:	55                   	push   %ebp
  802d3b:	89 e5                	mov    %esp,%ebp
  802d3d:	57                   	push   %edi
  802d3e:	56                   	push   %esi
  802d3f:	53                   	push   %ebx
  802d40:	83 ec 18             	sub    $0x18,%esp
  802d43:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d46:	57                   	push   %edi
  802d47:	e8 88 ef ff ff       	call   801cd4 <fd2data>
  802d4c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d4e:	83 c4 10             	add    $0x10,%esp
  802d51:	be 00 00 00 00       	mov    $0x0,%esi
  802d56:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d59:	75 13                	jne    802d6e <devpipe_read+0x34>
	return i;
  802d5b:	89 f0                	mov    %esi,%eax
  802d5d:	eb 02                	jmp    802d61 <devpipe_read+0x27>
				return i;
  802d5f:	89 f0                	mov    %esi,%eax
}
  802d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d64:	5b                   	pop    %ebx
  802d65:	5e                   	pop    %esi
  802d66:	5f                   	pop    %edi
  802d67:	5d                   	pop    %ebp
  802d68:	c3                   	ret    
			sys_yield();
  802d69:	e8 60 e9 ff ff       	call   8016ce <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d6e:	8b 03                	mov    (%ebx),%eax
  802d70:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d73:	75 18                	jne    802d8d <devpipe_read+0x53>
			if (i > 0)
  802d75:	85 f6                	test   %esi,%esi
  802d77:	75 e6                	jne    802d5f <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  802d79:	89 da                	mov    %ebx,%edx
  802d7b:	89 f8                	mov    %edi,%eax
  802d7d:	e8 d4 fe ff ff       	call   802c56 <_pipeisclosed>
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 e3                	je     802d69 <devpipe_read+0x2f>
				return 0;
  802d86:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8b:	eb d4                	jmp    802d61 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d8d:	99                   	cltd   
  802d8e:	c1 ea 1b             	shr    $0x1b,%edx
  802d91:	01 d0                	add    %edx,%eax
  802d93:	83 e0 1f             	and    $0x1f,%eax
  802d96:	29 d0                	sub    %edx,%eax
  802d98:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802da0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802da3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802da6:	83 c6 01             	add    $0x1,%esi
  802da9:	eb ab                	jmp    802d56 <devpipe_read+0x1c>

00802dab <pipe>:
{
  802dab:	55                   	push   %ebp
  802dac:	89 e5                	mov    %esp,%ebp
  802dae:	56                   	push   %esi
  802daf:	53                   	push   %ebx
  802db0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802db3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db6:	50                   	push   %eax
  802db7:	e8 2f ef ff ff       	call   801ceb <fd_alloc>
  802dbc:	89 c3                	mov    %eax,%ebx
  802dbe:	83 c4 10             	add    $0x10,%esp
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	0f 88 23 01 00 00    	js     802eec <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	68 07 04 00 00       	push   $0x407
  802dd1:	ff 75 f4             	push   -0xc(%ebp)
  802dd4:	6a 00                	push   $0x0
  802dd6:	e8 12 e9 ff ff       	call   8016ed <sys_page_alloc>
  802ddb:	89 c3                	mov    %eax,%ebx
  802ddd:	83 c4 10             	add    $0x10,%esp
  802de0:	85 c0                	test   %eax,%eax
  802de2:	0f 88 04 01 00 00    	js     802eec <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802de8:	83 ec 0c             	sub    $0xc,%esp
  802deb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802dee:	50                   	push   %eax
  802def:	e8 f7 ee ff ff       	call   801ceb <fd_alloc>
  802df4:	89 c3                	mov    %eax,%ebx
  802df6:	83 c4 10             	add    $0x10,%esp
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	0f 88 db 00 00 00    	js     802edc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e01:	83 ec 04             	sub    $0x4,%esp
  802e04:	68 07 04 00 00       	push   $0x407
  802e09:	ff 75 f0             	push   -0x10(%ebp)
  802e0c:	6a 00                	push   $0x0
  802e0e:	e8 da e8 ff ff       	call   8016ed <sys_page_alloc>
  802e13:	89 c3                	mov    %eax,%ebx
  802e15:	83 c4 10             	add    $0x10,%esp
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	0f 88 bc 00 00 00    	js     802edc <pipe+0x131>
	va = fd2data(fd0);
  802e20:	83 ec 0c             	sub    $0xc,%esp
  802e23:	ff 75 f4             	push   -0xc(%ebp)
  802e26:	e8 a9 ee ff ff       	call   801cd4 <fd2data>
  802e2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e2d:	83 c4 0c             	add    $0xc,%esp
  802e30:	68 07 04 00 00       	push   $0x407
  802e35:	50                   	push   %eax
  802e36:	6a 00                	push   $0x0
  802e38:	e8 b0 e8 ff ff       	call   8016ed <sys_page_alloc>
  802e3d:	89 c3                	mov    %eax,%ebx
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	85 c0                	test   %eax,%eax
  802e44:	0f 88 82 00 00 00    	js     802ecc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e4a:	83 ec 0c             	sub    $0xc,%esp
  802e4d:	ff 75 f0             	push   -0x10(%ebp)
  802e50:	e8 7f ee ff ff       	call   801cd4 <fd2data>
  802e55:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e5c:	50                   	push   %eax
  802e5d:	6a 00                	push   $0x0
  802e5f:	56                   	push   %esi
  802e60:	6a 00                	push   $0x0
  802e62:	e8 c9 e8 ff ff       	call   801730 <sys_page_map>
  802e67:	89 c3                	mov    %eax,%ebx
  802e69:	83 c4 20             	add    $0x20,%esp
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	78 4e                	js     802ebe <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e70:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e78:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802e84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e87:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 f4             	push   -0xc(%ebp)
  802e99:	e8 26 ee ff ff       	call   801cc4 <fd2num>
  802e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ea1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ea3:	83 c4 04             	add    $0x4,%esp
  802ea6:	ff 75 f0             	push   -0x10(%ebp)
  802ea9:	e8 16 ee ff ff       	call   801cc4 <fd2num>
  802eae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ebc:	eb 2e                	jmp    802eec <pipe+0x141>
	sys_page_unmap(0, va);
  802ebe:	83 ec 08             	sub    $0x8,%esp
  802ec1:	56                   	push   %esi
  802ec2:	6a 00                	push   $0x0
  802ec4:	e8 a9 e8 ff ff       	call   801772 <sys_page_unmap>
  802ec9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ecc:	83 ec 08             	sub    $0x8,%esp
  802ecf:	ff 75 f0             	push   -0x10(%ebp)
  802ed2:	6a 00                	push   $0x0
  802ed4:	e8 99 e8 ff ff       	call   801772 <sys_page_unmap>
  802ed9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802edc:	83 ec 08             	sub    $0x8,%esp
  802edf:	ff 75 f4             	push   -0xc(%ebp)
  802ee2:	6a 00                	push   $0x0
  802ee4:	e8 89 e8 ff ff       	call   801772 <sys_page_unmap>
  802ee9:	83 c4 10             	add    $0x10,%esp
}
  802eec:	89 d8                	mov    %ebx,%eax
  802eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef1:	5b                   	pop    %ebx
  802ef2:	5e                   	pop    %esi
  802ef3:	5d                   	pop    %ebp
  802ef4:	c3                   	ret    

00802ef5 <pipeisclosed>:
{
  802ef5:	55                   	push   %ebp
  802ef6:	89 e5                	mov    %esp,%ebp
  802ef8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802efb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802efe:	50                   	push   %eax
  802eff:	ff 75 08             	push   0x8(%ebp)
  802f02:	e8 34 ee ff ff       	call   801d3b <fd_lookup>
  802f07:	83 c4 10             	add    $0x10,%esp
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	78 18                	js     802f26 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f0e:	83 ec 0c             	sub    $0xc,%esp
  802f11:	ff 75 f4             	push   -0xc(%ebp)
  802f14:	e8 bb ed ff ff       	call   801cd4 <fd2data>
  802f19:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	e8 33 fd ff ff       	call   802c56 <_pipeisclosed>
  802f23:	83 c4 10             	add    $0x10,%esp
}
  802f26:	c9                   	leave  
  802f27:	c3                   	ret    

00802f28 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
  802f2b:	56                   	push   %esi
  802f2c:	53                   	push   %ebx
  802f2d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f30:	85 f6                	test   %esi,%esi
  802f32:	74 13                	je     802f47 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802f34:	89 f3                	mov    %esi,%ebx
  802f36:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f3c:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802f3f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802f45:	eb 1b                	jmp    802f62 <wait+0x3a>
	assert(envid != 0);
  802f47:	68 cd 3a 80 00       	push   $0x803acd
  802f4c:	68 a6 34 80 00       	push   $0x8034a6
  802f51:	6a 09                	push   $0x9
  802f53:	68 d8 3a 80 00       	push   $0x803ad8
  802f58:	e8 04 db ff ff       	call   800a61 <_panic>
		sys_yield();
  802f5d:	e8 6c e7 ff ff       	call   8016ce <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f62:	8b 43 48             	mov    0x48(%ebx),%eax
  802f65:	39 f0                	cmp    %esi,%eax
  802f67:	75 07                	jne    802f70 <wait+0x48>
  802f69:	8b 43 54             	mov    0x54(%ebx),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	75 ed                	jne    802f5d <wait+0x35>
}
  802f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f73:	5b                   	pop    %ebx
  802f74:	5e                   	pop    %esi
  802f75:	5d                   	pop    %ebp
  802f76:	c3                   	ret    

00802f77 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
  802f7a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f7d:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  802f84:	74 20                	je     802fa6 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	a3 04 70 80 00       	mov    %eax,0x807004
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802f8e:	83 ec 08             	sub    $0x8,%esp
  802f91:	68 e6 2f 80 00       	push   $0x802fe6
  802f96:	6a 00                	push   $0x0
  802f98:	e8 9b e8 ff ff       	call   801838 <sys_env_set_pgfault_upcall>
  802f9d:	83 c4 10             	add    $0x10,%esp
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	78 2e                	js     802fd2 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  802fa6:	83 ec 04             	sub    $0x4,%esp
  802fa9:	6a 07                	push   $0x7
  802fab:	68 00 f0 bf ee       	push   $0xeebff000
  802fb0:	6a 00                	push   $0x0
  802fb2:	e8 36 e7 ff ff       	call   8016ed <sys_page_alloc>
  802fb7:	83 c4 10             	add    $0x10,%esp
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	79 c8                	jns    802f86 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 e4 3a 80 00       	push   $0x803ae4
  802fc6:	6a 21                	push   $0x21
  802fc8:	68 47 3b 80 00       	push   $0x803b47
  802fcd:	e8 8f da ff ff       	call   800a61 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802fd2:	83 ec 04             	sub    $0x4,%esp
  802fd5:	68 10 3b 80 00       	push   $0x803b10
  802fda:	6a 27                	push   $0x27
  802fdc:	68 47 3b 80 00       	push   $0x803b47
  802fe1:	e8 7b da ff ff       	call   800a61 <_panic>

00802fe6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802fe6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802fe7:	a1 04 70 80 00       	mov    0x807004,%eax
	call *%eax
  802fec:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802fee:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  802ff1:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  802ff5:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  802ffa:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  802ffe:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  803000:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  803003:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  803004:	83 c4 04             	add    $0x4,%esp
	popfl
  803007:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803008:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803009:	c3                   	ret    

0080300a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
  80300d:	56                   	push   %esi
  80300e:	53                   	push   %ebx
  80300f:	8b 75 08             	mov    0x8(%ebp),%esi
  803012:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  803015:	83 ec 0c             	sub    $0xc,%esp
  803018:	ff 75 0c             	push   0xc(%ebp)
  80301b:	e8 7d e8 ff ff       	call   80189d <sys_ipc_recv>
  803020:	83 c4 10             	add    $0x10,%esp
  803023:	85 c0                	test   %eax,%eax
  803025:	78 2b                	js     803052 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  803027:	85 f6                	test   %esi,%esi
  803029:	74 0a                	je     803035 <ipc_recv+0x2b>
  80302b:	a1 14 50 80 00       	mov    0x805014,%eax
  803030:	8b 40 74             	mov    0x74(%eax),%eax
  803033:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  803035:	85 db                	test   %ebx,%ebx
  803037:	74 0a                	je     803043 <ipc_recv+0x39>
  803039:	a1 14 50 80 00       	mov    0x805014,%eax
  80303e:	8b 40 78             	mov    0x78(%eax),%eax
  803041:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  803043:	a1 14 50 80 00       	mov    0x805014,%eax
  803048:	8b 40 70             	mov    0x70(%eax),%eax
}
  80304b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80304e:	5b                   	pop    %ebx
  80304f:	5e                   	pop    %esi
  803050:	5d                   	pop    %ebp
  803051:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  803052:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803057:	eb f2                	jmp    80304b <ipc_recv+0x41>

00803059 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	57                   	push   %edi
  80305d:	56                   	push   %esi
  80305e:	53                   	push   %ebx
  80305f:	83 ec 0c             	sub    $0xc,%esp
  803062:	8b 7d 08             	mov    0x8(%ebp),%edi
  803065:	8b 75 0c             	mov    0xc(%ebp),%esi
  803068:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80306b:	ff 75 14             	push   0x14(%ebp)
  80306e:	53                   	push   %ebx
  80306f:	56                   	push   %esi
  803070:	57                   	push   %edi
  803071:	e8 04 e8 ff ff       	call   80187a <sys_ipc_try_send>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	85 c0                	test   %eax,%eax
  80307b:	79 20                	jns    80309d <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  80307d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803080:	75 07                	jne    803089 <ipc_send+0x30>
		sys_yield();
  803082:	e8 47 e6 ff ff       	call   8016ce <sys_yield>
  803087:	eb e2                	jmp    80306b <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 55 3b 80 00       	push   $0x803b55
  803091:	6a 2e                	push   $0x2e
  803093:	68 65 3b 80 00       	push   $0x803b65
  803098:	e8 c4 d9 ff ff       	call   800a61 <_panic>
	}
}
  80309d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030a0:	5b                   	pop    %ebx
  8030a1:	5e                   	pop    %esi
  8030a2:	5f                   	pop    %edi
  8030a3:	5d                   	pop    %ebp
  8030a4:	c3                   	ret    

008030a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030a5:	55                   	push   %ebp
  8030a6:	89 e5                	mov    %esp,%ebp
  8030a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8030b0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8030b3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8030b9:	8b 52 50             	mov    0x50(%edx),%edx
  8030bc:	39 ca                	cmp    %ecx,%edx
  8030be:	74 11                	je     8030d1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8030c0:	83 c0 01             	add    $0x1,%eax
  8030c3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8030c8:	75 e6                	jne    8030b0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8030ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cf:	eb 0b                	jmp    8030dc <ipc_find_env+0x37>
			return envs[i].env_id;
  8030d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8030d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8030d9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8030dc:	5d                   	pop    %ebp
  8030dd:	c3                   	ret    

008030de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8030e4:	89 c2                	mov    %eax,%edx
  8030e6:	c1 ea 16             	shr    $0x16,%edx
  8030e9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8030f0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8030f5:	f6 c1 01             	test   $0x1,%cl
  8030f8:	74 1c                	je     803116 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  8030fa:	c1 e8 0c             	shr    $0xc,%eax
  8030fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803104:	a8 01                	test   $0x1,%al
  803106:	74 0e                	je     803116 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803108:	c1 e8 0c             	shr    $0xc,%eax
  80310b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803112:	ef 
  803113:	0f b7 d2             	movzwl %dx,%edx
}
  803116:	89 d0                	mov    %edx,%eax
  803118:	5d                   	pop    %ebp
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	66 90                	xchg   %ax,%ax
  80311e:	66 90                	xchg   %ax,%ax

00803120 <__udivdi3>:
  803120:	f3 0f 1e fb          	endbr32 
  803124:	55                   	push   %ebp
  803125:	57                   	push   %edi
  803126:	56                   	push   %esi
  803127:	53                   	push   %ebx
  803128:	83 ec 1c             	sub    $0x1c,%esp
  80312b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80312f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803133:	8b 74 24 34          	mov    0x34(%esp),%esi
  803137:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80313b:	85 c0                	test   %eax,%eax
  80313d:	75 19                	jne    803158 <__udivdi3+0x38>
  80313f:	39 f3                	cmp    %esi,%ebx
  803141:	76 4d                	jbe    803190 <__udivdi3+0x70>
  803143:	31 ff                	xor    %edi,%edi
  803145:	89 e8                	mov    %ebp,%eax
  803147:	89 f2                	mov    %esi,%edx
  803149:	f7 f3                	div    %ebx
  80314b:	89 fa                	mov    %edi,%edx
  80314d:	83 c4 1c             	add    $0x1c,%esp
  803150:	5b                   	pop    %ebx
  803151:	5e                   	pop    %esi
  803152:	5f                   	pop    %edi
  803153:	5d                   	pop    %ebp
  803154:	c3                   	ret    
  803155:	8d 76 00             	lea    0x0(%esi),%esi
  803158:	39 f0                	cmp    %esi,%eax
  80315a:	76 14                	jbe    803170 <__udivdi3+0x50>
  80315c:	31 ff                	xor    %edi,%edi
  80315e:	31 c0                	xor    %eax,%eax
  803160:	89 fa                	mov    %edi,%edx
  803162:	83 c4 1c             	add    $0x1c,%esp
  803165:	5b                   	pop    %ebx
  803166:	5e                   	pop    %esi
  803167:	5f                   	pop    %edi
  803168:	5d                   	pop    %ebp
  803169:	c3                   	ret    
  80316a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803170:	0f bd f8             	bsr    %eax,%edi
  803173:	83 f7 1f             	xor    $0x1f,%edi
  803176:	75 48                	jne    8031c0 <__udivdi3+0xa0>
  803178:	39 f0                	cmp    %esi,%eax
  80317a:	72 06                	jb     803182 <__udivdi3+0x62>
  80317c:	31 c0                	xor    %eax,%eax
  80317e:	39 eb                	cmp    %ebp,%ebx
  803180:	77 de                	ja     803160 <__udivdi3+0x40>
  803182:	b8 01 00 00 00       	mov    $0x1,%eax
  803187:	eb d7                	jmp    803160 <__udivdi3+0x40>
  803189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803190:	89 d9                	mov    %ebx,%ecx
  803192:	85 db                	test   %ebx,%ebx
  803194:	75 0b                	jne    8031a1 <__udivdi3+0x81>
  803196:	b8 01 00 00 00       	mov    $0x1,%eax
  80319b:	31 d2                	xor    %edx,%edx
  80319d:	f7 f3                	div    %ebx
  80319f:	89 c1                	mov    %eax,%ecx
  8031a1:	31 d2                	xor    %edx,%edx
  8031a3:	89 f0                	mov    %esi,%eax
  8031a5:	f7 f1                	div    %ecx
  8031a7:	89 c6                	mov    %eax,%esi
  8031a9:	89 e8                	mov    %ebp,%eax
  8031ab:	89 f7                	mov    %esi,%edi
  8031ad:	f7 f1                	div    %ecx
  8031af:	89 fa                	mov    %edi,%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031c0:	89 f9                	mov    %edi,%ecx
  8031c2:	ba 20 00 00 00       	mov    $0x20,%edx
  8031c7:	29 fa                	sub    %edi,%edx
  8031c9:	d3 e0                	shl    %cl,%eax
  8031cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031cf:	89 d1                	mov    %edx,%ecx
  8031d1:	89 d8                	mov    %ebx,%eax
  8031d3:	d3 e8                	shr    %cl,%eax
  8031d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031d9:	09 c1                	or     %eax,%ecx
  8031db:	89 f0                	mov    %esi,%eax
  8031dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031e1:	89 f9                	mov    %edi,%ecx
  8031e3:	d3 e3                	shl    %cl,%ebx
  8031e5:	89 d1                	mov    %edx,%ecx
  8031e7:	d3 e8                	shr    %cl,%eax
  8031e9:	89 f9                	mov    %edi,%ecx
  8031eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8031ef:	89 eb                	mov    %ebp,%ebx
  8031f1:	d3 e6                	shl    %cl,%esi
  8031f3:	89 d1                	mov    %edx,%ecx
  8031f5:	d3 eb                	shr    %cl,%ebx
  8031f7:	09 f3                	or     %esi,%ebx
  8031f9:	89 c6                	mov    %eax,%esi
  8031fb:	89 f2                	mov    %esi,%edx
  8031fd:	89 d8                	mov    %ebx,%eax
  8031ff:	f7 74 24 08          	divl   0x8(%esp)
  803203:	89 d6                	mov    %edx,%esi
  803205:	89 c3                	mov    %eax,%ebx
  803207:	f7 64 24 0c          	mull   0xc(%esp)
  80320b:	39 d6                	cmp    %edx,%esi
  80320d:	72 19                	jb     803228 <__udivdi3+0x108>
  80320f:	89 f9                	mov    %edi,%ecx
  803211:	d3 e5                	shl    %cl,%ebp
  803213:	39 c5                	cmp    %eax,%ebp
  803215:	73 04                	jae    80321b <__udivdi3+0xfb>
  803217:	39 d6                	cmp    %edx,%esi
  803219:	74 0d                	je     803228 <__udivdi3+0x108>
  80321b:	89 d8                	mov    %ebx,%eax
  80321d:	31 ff                	xor    %edi,%edi
  80321f:	e9 3c ff ff ff       	jmp    803160 <__udivdi3+0x40>
  803224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803228:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80322b:	31 ff                	xor    %edi,%edi
  80322d:	e9 2e ff ff ff       	jmp    803160 <__udivdi3+0x40>
  803232:	66 90                	xchg   %ax,%ax
  803234:	66 90                	xchg   %ax,%ax
  803236:	66 90                	xchg   %ax,%ax
  803238:	66 90                	xchg   %ax,%ax
  80323a:	66 90                	xchg   %ax,%ax
  80323c:	66 90                	xchg   %ax,%ax
  80323e:	66 90                	xchg   %ax,%ax

00803240 <__umoddi3>:
  803240:	f3 0f 1e fb          	endbr32 
  803244:	55                   	push   %ebp
  803245:	57                   	push   %edi
  803246:	56                   	push   %esi
  803247:	53                   	push   %ebx
  803248:	83 ec 1c             	sub    $0x1c,%esp
  80324b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80324f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803253:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  803257:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80325b:	89 f0                	mov    %esi,%eax
  80325d:	89 da                	mov    %ebx,%edx
  80325f:	85 ff                	test   %edi,%edi
  803261:	75 15                	jne    803278 <__umoddi3+0x38>
  803263:	39 dd                	cmp    %ebx,%ebp
  803265:	76 39                	jbe    8032a0 <__umoddi3+0x60>
  803267:	f7 f5                	div    %ebp
  803269:	89 d0                	mov    %edx,%eax
  80326b:	31 d2                	xor    %edx,%edx
  80326d:	83 c4 1c             	add    $0x1c,%esp
  803270:	5b                   	pop    %ebx
  803271:	5e                   	pop    %esi
  803272:	5f                   	pop    %edi
  803273:	5d                   	pop    %ebp
  803274:	c3                   	ret    
  803275:	8d 76 00             	lea    0x0(%esi),%esi
  803278:	39 df                	cmp    %ebx,%edi
  80327a:	77 f1                	ja     80326d <__umoddi3+0x2d>
  80327c:	0f bd cf             	bsr    %edi,%ecx
  80327f:	83 f1 1f             	xor    $0x1f,%ecx
  803282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803286:	75 40                	jne    8032c8 <__umoddi3+0x88>
  803288:	39 df                	cmp    %ebx,%edi
  80328a:	72 04                	jb     803290 <__umoddi3+0x50>
  80328c:	39 f5                	cmp    %esi,%ebp
  80328e:	77 dd                	ja     80326d <__umoddi3+0x2d>
  803290:	89 da                	mov    %ebx,%edx
  803292:	89 f0                	mov    %esi,%eax
  803294:	29 e8                	sub    %ebp,%eax
  803296:	19 fa                	sbb    %edi,%edx
  803298:	eb d3                	jmp    80326d <__umoddi3+0x2d>
  80329a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032a0:	89 e9                	mov    %ebp,%ecx
  8032a2:	85 ed                	test   %ebp,%ebp
  8032a4:	75 0b                	jne    8032b1 <__umoddi3+0x71>
  8032a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	f7 f5                	div    %ebp
  8032af:	89 c1                	mov    %eax,%ecx
  8032b1:	89 d8                	mov    %ebx,%eax
  8032b3:	31 d2                	xor    %edx,%edx
  8032b5:	f7 f1                	div    %ecx
  8032b7:	89 f0                	mov    %esi,%eax
  8032b9:	f7 f1                	div    %ecx
  8032bb:	89 d0                	mov    %edx,%eax
  8032bd:	31 d2                	xor    %edx,%edx
  8032bf:	eb ac                	jmp    80326d <__umoddi3+0x2d>
  8032c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032cc:	ba 20 00 00 00       	mov    $0x20,%edx
  8032d1:	29 c2                	sub    %eax,%edx
  8032d3:	89 c1                	mov    %eax,%ecx
  8032d5:	89 e8                	mov    %ebp,%eax
  8032d7:	d3 e7                	shl    %cl,%edi
  8032d9:	89 d1                	mov    %edx,%ecx
  8032db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8032df:	d3 e8                	shr    %cl,%eax
  8032e1:	89 c1                	mov    %eax,%ecx
  8032e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032e7:	09 f9                	or     %edi,%ecx
  8032e9:	89 df                	mov    %ebx,%edi
  8032eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032ef:	89 c1                	mov    %eax,%ecx
  8032f1:	d3 e5                	shl    %cl,%ebp
  8032f3:	89 d1                	mov    %edx,%ecx
  8032f5:	d3 ef                	shr    %cl,%edi
  8032f7:	89 c1                	mov    %eax,%ecx
  8032f9:	89 f0                	mov    %esi,%eax
  8032fb:	d3 e3                	shl    %cl,%ebx
  8032fd:	89 d1                	mov    %edx,%ecx
  8032ff:	89 fa                	mov    %edi,%edx
  803301:	d3 e8                	shr    %cl,%eax
  803303:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803308:	09 d8                	or     %ebx,%eax
  80330a:	f7 74 24 08          	divl   0x8(%esp)
  80330e:	89 d3                	mov    %edx,%ebx
  803310:	d3 e6                	shl    %cl,%esi
  803312:	f7 e5                	mul    %ebp
  803314:	89 c7                	mov    %eax,%edi
  803316:	89 d1                	mov    %edx,%ecx
  803318:	39 d3                	cmp    %edx,%ebx
  80331a:	72 06                	jb     803322 <__umoddi3+0xe2>
  80331c:	75 0e                	jne    80332c <__umoddi3+0xec>
  80331e:	39 c6                	cmp    %eax,%esi
  803320:	73 0a                	jae    80332c <__umoddi3+0xec>
  803322:	29 e8                	sub    %ebp,%eax
  803324:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803328:	89 d1                	mov    %edx,%ecx
  80332a:	89 c7                	mov    %eax,%edi
  80332c:	89 f5                	mov    %esi,%ebp
  80332e:	8b 74 24 04          	mov    0x4(%esp),%esi
  803332:	29 fd                	sub    %edi,%ebp
  803334:	19 cb                	sbb    %ecx,%ebx
  803336:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80333b:	89 d8                	mov    %ebx,%eax
  80333d:	d3 e0                	shl    %cl,%eax
  80333f:	89 f1                	mov    %esi,%ecx
  803341:	d3 ed                	shr    %cl,%ebp
  803343:	d3 eb                	shr    %cl,%ebx
  803345:	09 e8                	or     %ebp,%eax
  803347:	89 da                	mov    %ebx,%edx
  803349:	83 c4 1c             	add    $0x1c,%esp
  80334c:	5b                   	pop    %ebx
  80334d:	5e                   	pop    %esi
  80334e:	5f                   	pop    %edi
  80334f:	5d                   	pop    %ebp
  803350:	c3                   	ret    
