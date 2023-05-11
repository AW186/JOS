
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
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
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 4c                	jmp    8000a1 <umain+0x6e>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 00 1f 80 00       	push   $0x801f00
  80005d:	ff 76 04             	push   0x4(%esi)
  800060:	e8 c3 01 00 00       	call   800228 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 34 9e             	push   (%esi,%ebx,4)
  800088:	e8 af 00 00 00       	call   80013c <strlen>
  80008d:	83 c4 0c             	add    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	ff 34 9e             	push   (%esi,%ebx,4)
  800094:	6a 01                	push   $0x1
  800096:	e8 72 0a 00 00       	call   800b0d <write>
	for (i = 1; i < argc; i++) {
  80009b:	83 c3 01             	add    $0x1,%ebx
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	39 df                	cmp    %ebx,%edi
  8000a3:	7e 1b                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000a5:	83 fb 01             	cmp    $0x1,%ebx
  8000a8:	7e d8                	jle    800082 <umain+0x4f>
			write(1, " ", 1);
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 01                	push   $0x1
  8000af:	68 03 1f 80 00       	push   $0x801f03
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 52 0a 00 00       	call   800b0d <write>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	eb c2                	jmp    800082 <umain+0x4f>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 4d 23 80 00       	push   $0x80234d
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 2e 0a 00 00       	call   800b0d <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 41 04 00 00       	call   800535 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800130:	6a 00                	push   $0x0
  800132:	e8 bd 03 00 00       	call   8004f4 <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800142:	b8 00 00 00 00       	mov    $0x0,%eax
  800147:	eb 03                	jmp    80014c <strlen+0x10>
		n++;
  800149:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80014c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800150:	75 f7                	jne    800149 <strlen+0xd>
	return n;
}
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	eb 03                	jmp    800167 <strnlen+0x13>
		n++;
  800164:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800167:	39 d0                	cmp    %edx,%eax
  800169:	74 08                	je     800173 <strnlen+0x1f>
  80016b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80016f:	75 f3                	jne    800164 <strnlen+0x10>
  800171:	89 c2                	mov    %eax,%edx
	return n;
}
  800173:	89 d0                	mov    %edx,%eax
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	53                   	push   %ebx
  80017b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80018a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80018d:	83 c0 01             	add    $0x1,%eax
  800190:	84 d2                	test   %dl,%dl
  800192:	75 f2                	jne    800186 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800194:	89 c8                	mov    %ecx,%eax
  800196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	83 ec 10             	sub    $0x10,%esp
  8001a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a5:	53                   	push   %ebx
  8001a6:	e8 91 ff ff ff       	call   80013c <strlen>
  8001ab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001ae:	ff 75 0c             	push   0xc(%ebp)
  8001b1:	01 d8                	add    %ebx,%eax
  8001b3:	50                   	push   %eax
  8001b4:	e8 be ff ff ff       	call   800177 <strcpy>
	return dst;
}
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cb:	89 f3                	mov    %esi,%ebx
  8001cd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001d0:	89 f0                	mov    %esi,%eax
  8001d2:	eb 0f                	jmp    8001e3 <strncpy+0x23>
		*dst++ = *src;
  8001d4:	83 c0 01             	add    $0x1,%eax
  8001d7:	0f b6 0a             	movzbl (%edx),%ecx
  8001da:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001dd:	80 f9 01             	cmp    $0x1,%cl
  8001e0:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  8001e3:	39 d8                	cmp    %ebx,%eax
  8001e5:	75 ed                	jne    8001d4 <strncpy+0x14>
	}
	return ret;
}
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f8:	8b 55 10             	mov    0x10(%ebp),%edx
  8001fb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001fd:	85 d2                	test   %edx,%edx
  8001ff:	74 21                	je     800222 <strlcpy+0x35>
  800201:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800205:	89 f2                	mov    %esi,%edx
  800207:	eb 09                	jmp    800212 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800209:	83 c1 01             	add    $0x1,%ecx
  80020c:	83 c2 01             	add    $0x1,%edx
  80020f:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800212:	39 c2                	cmp    %eax,%edx
  800214:	74 09                	je     80021f <strlcpy+0x32>
  800216:	0f b6 19             	movzbl (%ecx),%ebx
  800219:	84 db                	test   %bl,%bl
  80021b:	75 ec                	jne    800209 <strlcpy+0x1c>
  80021d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80021f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800222:	29 f0                	sub    %esi,%eax
}
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800231:	eb 06                	jmp    800239 <strcmp+0x11>
		p++, q++;
  800233:	83 c1 01             	add    $0x1,%ecx
  800236:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800239:	0f b6 01             	movzbl (%ecx),%eax
  80023c:	84 c0                	test   %al,%al
  80023e:	74 04                	je     800244 <strcmp+0x1c>
  800240:	3a 02                	cmp    (%edx),%al
  800242:	74 ef                	je     800233 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800244:	0f b6 c0             	movzbl %al,%eax
  800247:	0f b6 12             	movzbl (%edx),%edx
  80024a:	29 d0                	sub    %edx,%eax
}
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	53                   	push   %ebx
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	8b 55 0c             	mov    0xc(%ebp),%edx
  800258:	89 c3                	mov    %eax,%ebx
  80025a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80025d:	eb 06                	jmp    800265 <strncmp+0x17>
		n--, p++, q++;
  80025f:	83 c0 01             	add    $0x1,%eax
  800262:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800265:	39 d8                	cmp    %ebx,%eax
  800267:	74 18                	je     800281 <strncmp+0x33>
  800269:	0f b6 08             	movzbl (%eax),%ecx
  80026c:	84 c9                	test   %cl,%cl
  80026e:	74 04                	je     800274 <strncmp+0x26>
  800270:	3a 0a                	cmp    (%edx),%cl
  800272:	74 eb                	je     80025f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800274:	0f b6 00             	movzbl (%eax),%eax
  800277:	0f b6 12             	movzbl (%edx),%edx
  80027a:	29 d0                	sub    %edx,%eax
}
  80027c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027f:	c9                   	leave  
  800280:	c3                   	ret    
		return 0;
  800281:	b8 00 00 00 00       	mov    $0x0,%eax
  800286:	eb f4                	jmp    80027c <strncmp+0x2e>

00800288 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800292:	eb 03                	jmp    800297 <strchr+0xf>
  800294:	83 c0 01             	add    $0x1,%eax
  800297:	0f b6 10             	movzbl (%eax),%edx
  80029a:	84 d2                	test   %dl,%dl
  80029c:	74 06                	je     8002a4 <strchr+0x1c>
		if (*s == c)
  80029e:	38 ca                	cmp    %cl,%dl
  8002a0:	75 f2                	jne    800294 <strchr+0xc>
  8002a2:	eb 05                	jmp    8002a9 <strchr+0x21>
			return (char *) s;
	return 0;
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002b5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002b8:	38 ca                	cmp    %cl,%dl
  8002ba:	74 09                	je     8002c5 <strfind+0x1a>
  8002bc:	84 d2                	test   %dl,%dl
  8002be:	74 05                	je     8002c5 <strfind+0x1a>
	for (; *s; s++)
  8002c0:	83 c0 01             	add    $0x1,%eax
  8002c3:	eb f0                	jmp    8002b5 <strfind+0xa>
			break;
	return (char *) s;
}
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    

008002c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	57                   	push   %edi
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002d3:	85 c9                	test   %ecx,%ecx
  8002d5:	74 2f                	je     800306 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002d7:	89 f8                	mov    %edi,%eax
  8002d9:	09 c8                	or     %ecx,%eax
  8002db:	a8 03                	test   $0x3,%al
  8002dd:	75 21                	jne    800300 <memset+0x39>
		c &= 0xFF;
  8002df:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	c1 e0 08             	shl    $0x8,%eax
  8002e8:	89 d3                	mov    %edx,%ebx
  8002ea:	c1 e3 18             	shl    $0x18,%ebx
  8002ed:	89 d6                	mov    %edx,%esi
  8002ef:	c1 e6 10             	shl    $0x10,%esi
  8002f2:	09 f3                	or     %esi,%ebx
  8002f4:	09 da                	or     %ebx,%edx
  8002f6:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8002f8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002fb:	fc                   	cld    
  8002fc:	f3 ab                	rep stos %eax,%es:(%edi)
  8002fe:	eb 06                	jmp    800306 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	fc                   	cld    
  800304:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800306:	89 f8                	mov    %edi,%eax
  800308:	5b                   	pop    %ebx
  800309:	5e                   	pop    %esi
  80030a:	5f                   	pop    %edi
  80030b:	5d                   	pop    %ebp
  80030c:	c3                   	ret    

0080030d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	8b 75 0c             	mov    0xc(%ebp),%esi
  800318:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80031b:	39 c6                	cmp    %eax,%esi
  80031d:	73 32                	jae    800351 <memmove+0x44>
  80031f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800322:	39 c2                	cmp    %eax,%edx
  800324:	76 2b                	jbe    800351 <memmove+0x44>
		s += n;
		d += n;
  800326:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800329:	89 d6                	mov    %edx,%esi
  80032b:	09 fe                	or     %edi,%esi
  80032d:	09 ce                	or     %ecx,%esi
  80032f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800335:	75 0e                	jne    800345 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800337:	83 ef 04             	sub    $0x4,%edi
  80033a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80033d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800340:	fd                   	std    
  800341:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800343:	eb 09                	jmp    80034e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800345:	83 ef 01             	sub    $0x1,%edi
  800348:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80034b:	fd                   	std    
  80034c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80034e:	fc                   	cld    
  80034f:	eb 1a                	jmp    80036b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800351:	89 f2                	mov    %esi,%edx
  800353:	09 c2                	or     %eax,%edx
  800355:	09 ca                	or     %ecx,%edx
  800357:	f6 c2 03             	test   $0x3,%dl
  80035a:	75 0a                	jne    800366 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80035c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80035f:	89 c7                	mov    %eax,%edi
  800361:	fc                   	cld    
  800362:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800364:	eb 05                	jmp    80036b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800366:	89 c7                	mov    %eax,%edi
  800368:	fc                   	cld    
  800369:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80036b:	5e                   	pop    %esi
  80036c:	5f                   	pop    %edi
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800375:	ff 75 10             	push   0x10(%ebp)
  800378:	ff 75 0c             	push   0xc(%ebp)
  80037b:	ff 75 08             	push   0x8(%ebp)
  80037e:	e8 8a ff ff ff       	call   80030d <memmove>
}
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800390:	89 c6                	mov    %eax,%esi
  800392:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800395:	eb 06                	jmp    80039d <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800397:	83 c0 01             	add    $0x1,%eax
  80039a:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  80039d:	39 f0                	cmp    %esi,%eax
  80039f:	74 14                	je     8003b5 <memcmp+0x30>
		if (*s1 != *s2)
  8003a1:	0f b6 08             	movzbl (%eax),%ecx
  8003a4:	0f b6 1a             	movzbl (%edx),%ebx
  8003a7:	38 d9                	cmp    %bl,%cl
  8003a9:	74 ec                	je     800397 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  8003ab:	0f b6 c1             	movzbl %cl,%eax
  8003ae:	0f b6 db             	movzbl %bl,%ebx
  8003b1:	29 d8                	sub    %ebx,%eax
  8003b3:	eb 05                	jmp    8003ba <memcmp+0x35>
	}

	return 0;
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c7:	89 c2                	mov    %eax,%edx
  8003c9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003cc:	eb 03                	jmp    8003d1 <memfind+0x13>
  8003ce:	83 c0 01             	add    $0x1,%eax
  8003d1:	39 d0                	cmp    %edx,%eax
  8003d3:	73 04                	jae    8003d9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003d5:	38 08                	cmp    %cl,(%eax)
  8003d7:	75 f5                	jne    8003ce <memfind+0x10>
			break;
	return (void *) s;
}
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	57                   	push   %edi
  8003df:	56                   	push   %esi
  8003e0:	53                   	push   %ebx
  8003e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e7:	eb 03                	jmp    8003ec <strtol+0x11>
		s++;
  8003e9:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  8003ec:	0f b6 02             	movzbl (%edx),%eax
  8003ef:	3c 20                	cmp    $0x20,%al
  8003f1:	74 f6                	je     8003e9 <strtol+0xe>
  8003f3:	3c 09                	cmp    $0x9,%al
  8003f5:	74 f2                	je     8003e9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f7:	3c 2b                	cmp    $0x2b,%al
  8003f9:	74 2a                	je     800425 <strtol+0x4a>
	int neg = 0;
  8003fb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800400:	3c 2d                	cmp    $0x2d,%al
  800402:	74 2b                	je     80042f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800404:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80040a:	75 0f                	jne    80041b <strtol+0x40>
  80040c:	80 3a 30             	cmpb   $0x30,(%edx)
  80040f:	74 28                	je     800439 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800411:	85 db                	test   %ebx,%ebx
  800413:	b8 0a 00 00 00       	mov    $0xa,%eax
  800418:	0f 44 d8             	cmove  %eax,%ebx
  80041b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800423:	eb 46                	jmp    80046b <strtol+0x90>
		s++;
  800425:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800428:	bf 00 00 00 00       	mov    $0x0,%edi
  80042d:	eb d5                	jmp    800404 <strtol+0x29>
		s++, neg = 1;
  80042f:	83 c2 01             	add    $0x1,%edx
  800432:	bf 01 00 00 00       	mov    $0x1,%edi
  800437:	eb cb                	jmp    800404 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800439:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80043d:	74 0e                	je     80044d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80043f:	85 db                	test   %ebx,%ebx
  800441:	75 d8                	jne    80041b <strtol+0x40>
		s++, base = 8;
  800443:	83 c2 01             	add    $0x1,%edx
  800446:	bb 08 00 00 00       	mov    $0x8,%ebx
  80044b:	eb ce                	jmp    80041b <strtol+0x40>
		s += 2, base = 16;
  80044d:	83 c2 02             	add    $0x2,%edx
  800450:	bb 10 00 00 00       	mov    $0x10,%ebx
  800455:	eb c4                	jmp    80041b <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800457:	0f be c0             	movsbl %al,%eax
  80045a:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80045d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800460:	7d 3a                	jge    80049c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800462:	83 c2 01             	add    $0x1,%edx
  800465:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800469:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  80046b:	0f b6 02             	movzbl (%edx),%eax
  80046e:	8d 70 d0             	lea    -0x30(%eax),%esi
  800471:	89 f3                	mov    %esi,%ebx
  800473:	80 fb 09             	cmp    $0x9,%bl
  800476:	76 df                	jbe    800457 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800478:	8d 70 9f             	lea    -0x61(%eax),%esi
  80047b:	89 f3                	mov    %esi,%ebx
  80047d:	80 fb 19             	cmp    $0x19,%bl
  800480:	77 08                	ja     80048a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800482:	0f be c0             	movsbl %al,%eax
  800485:	83 e8 57             	sub    $0x57,%eax
  800488:	eb d3                	jmp    80045d <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  80048a:	8d 70 bf             	lea    -0x41(%eax),%esi
  80048d:	89 f3                	mov    %esi,%ebx
  80048f:	80 fb 19             	cmp    $0x19,%bl
  800492:	77 08                	ja     80049c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800494:	0f be c0             	movsbl %al,%eax
  800497:	83 e8 37             	sub    $0x37,%eax
  80049a:	eb c1                	jmp    80045d <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  80049c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a0:	74 05                	je     8004a7 <strtol+0xcc>
		*endptr = (char *) s;
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8004a7:	89 c8                	mov    %ecx,%eax
  8004a9:	f7 d8                	neg    %eax
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	0f 45 c8             	cmovne %eax,%ecx
}
  8004b0:	89 c8                	mov    %ecx,%eax
  8004b2:	5b                   	pop    %ebx
  8004b3:	5e                   	pop    %esi
  8004b4:	5f                   	pop    %edi
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	57                   	push   %edi
  8004bb:	56                   	push   %esi
  8004bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c8:	89 c3                	mov    %eax,%ebx
  8004ca:	89 c7                	mov    %eax,%edi
  8004cc:	89 c6                	mov    %eax,%esi
  8004ce:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004d0:	5b                   	pop    %ebx
  8004d1:	5e                   	pop    %esi
  8004d2:	5f                   	pop    %edi
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    

008004d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	57                   	push   %edi
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004db:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8004e5:	89 d1                	mov    %edx,%ecx
  8004e7:	89 d3                	mov    %edx,%ebx
  8004e9:	89 d7                	mov    %edx,%edi
  8004eb:	89 d6                	mov    %edx,%esi
  8004ed:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004ef:	5b                   	pop    %ebx
  8004f0:	5e                   	pop    %esi
  8004f1:	5f                   	pop    %edi
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    

008004f4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	57                   	push   %edi
  8004f8:	56                   	push   %esi
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800502:	8b 55 08             	mov    0x8(%ebp),%edx
  800505:	b8 03 00 00 00       	mov    $0x3,%eax
  80050a:	89 cb                	mov    %ecx,%ebx
  80050c:	89 cf                	mov    %ecx,%edi
  80050e:	89 ce                	mov    %ecx,%esi
  800510:	cd 30                	int    $0x30
	if(check && ret > 0)
  800512:	85 c0                	test   %eax,%eax
  800514:	7f 08                	jg     80051e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800516:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800519:	5b                   	pop    %ebx
  80051a:	5e                   	pop    %esi
  80051b:	5f                   	pop    %edi
  80051c:	5d                   	pop    %ebp
  80051d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	50                   	push   %eax
  800522:	6a 03                	push   $0x3
  800524:	68 0f 1f 80 00       	push   $0x801f0f
  800529:	6a 23                	push   $0x23
  80052b:	68 2c 1f 80 00       	push   $0x801f2c
  800530:	e8 0e 0f 00 00       	call   801443 <_panic>

00800535 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	57                   	push   %edi
  800539:	56                   	push   %esi
  80053a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80053b:	ba 00 00 00 00       	mov    $0x0,%edx
  800540:	b8 02 00 00 00       	mov    $0x2,%eax
  800545:	89 d1                	mov    %edx,%ecx
  800547:	89 d3                	mov    %edx,%ebx
  800549:	89 d7                	mov    %edx,%edi
  80054b:	89 d6                	mov    %edx,%esi
  80054d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80054f:	5b                   	pop    %ebx
  800550:	5e                   	pop    %esi
  800551:	5f                   	pop    %edi
  800552:	5d                   	pop    %ebp
  800553:	c3                   	ret    

00800554 <sys_yield>:

void
sys_yield(void)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	57                   	push   %edi
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
	asm volatile("int %1\n"
  80055a:	ba 00 00 00 00       	mov    $0x0,%edx
  80055f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800564:	89 d1                	mov    %edx,%ecx
  800566:	89 d3                	mov    %edx,%ebx
  800568:	89 d7                	mov    %edx,%edi
  80056a:	89 d6                	mov    %edx,%esi
  80056c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80056e:	5b                   	pop    %ebx
  80056f:	5e                   	pop    %esi
  800570:	5f                   	pop    %edi
  800571:	5d                   	pop    %ebp
  800572:	c3                   	ret    

00800573 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	57                   	push   %edi
  800577:	56                   	push   %esi
  800578:	53                   	push   %ebx
  800579:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80057c:	be 00 00 00 00       	mov    $0x0,%esi
  800581:	8b 55 08             	mov    0x8(%ebp),%edx
  800584:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800587:	b8 04 00 00 00       	mov    $0x4,%eax
  80058c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058f:	89 f7                	mov    %esi,%edi
  800591:	cd 30                	int    $0x30
	if(check && ret > 0)
  800593:	85 c0                	test   %eax,%eax
  800595:	7f 08                	jg     80059f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800597:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	50                   	push   %eax
  8005a3:	6a 04                	push   $0x4
  8005a5:	68 0f 1f 80 00       	push   $0x801f0f
  8005aa:	6a 23                	push   $0x23
  8005ac:	68 2c 1f 80 00       	push   $0x801f2c
  8005b1:	e8 8d 0e 00 00       	call   801443 <_panic>

008005b6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	57                   	push   %edi
  8005ba:	56                   	push   %esi
  8005bb:	53                   	push   %ebx
  8005bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8005ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8005d3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d5:	85 c0                	test   %eax,%eax
  8005d7:	7f 08                	jg     8005e1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005dc:	5b                   	pop    %ebx
  8005dd:	5e                   	pop    %esi
  8005de:	5f                   	pop    %edi
  8005df:	5d                   	pop    %ebp
  8005e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e1:	83 ec 0c             	sub    $0xc,%esp
  8005e4:	50                   	push   %eax
  8005e5:	6a 05                	push   $0x5
  8005e7:	68 0f 1f 80 00       	push   $0x801f0f
  8005ec:	6a 23                	push   $0x23
  8005ee:	68 2c 1f 80 00       	push   $0x801f2c
  8005f3:	e8 4b 0e 00 00       	call   801443 <_panic>

008005f8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	57                   	push   %edi
  8005fc:	56                   	push   %esi
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800601:	bb 00 00 00 00       	mov    $0x0,%ebx
  800606:	8b 55 08             	mov    0x8(%ebp),%edx
  800609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80060c:	b8 06 00 00 00       	mov    $0x6,%eax
  800611:	89 df                	mov    %ebx,%edi
  800613:	89 de                	mov    %ebx,%esi
  800615:	cd 30                	int    $0x30
	if(check && ret > 0)
  800617:	85 c0                	test   %eax,%eax
  800619:	7f 08                	jg     800623 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80061b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061e:	5b                   	pop    %ebx
  80061f:	5e                   	pop    %esi
  800620:	5f                   	pop    %edi
  800621:	5d                   	pop    %ebp
  800622:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800623:	83 ec 0c             	sub    $0xc,%esp
  800626:	50                   	push   %eax
  800627:	6a 06                	push   $0x6
  800629:	68 0f 1f 80 00       	push   $0x801f0f
  80062e:	6a 23                	push   $0x23
  800630:	68 2c 1f 80 00       	push   $0x801f2c
  800635:	e8 09 0e 00 00       	call   801443 <_panic>

0080063a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	57                   	push   %edi
  80063e:	56                   	push   %esi
  80063f:	53                   	push   %ebx
  800640:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800643:	bb 00 00 00 00       	mov    $0x0,%ebx
  800648:	8b 55 08             	mov    0x8(%ebp),%edx
  80064b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064e:	b8 08 00 00 00       	mov    $0x8,%eax
  800653:	89 df                	mov    %ebx,%edi
  800655:	89 de                	mov    %ebx,%esi
  800657:	cd 30                	int    $0x30
	if(check && ret > 0)
  800659:	85 c0                	test   %eax,%eax
  80065b:	7f 08                	jg     800665 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80065d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800660:	5b                   	pop    %ebx
  800661:	5e                   	pop    %esi
  800662:	5f                   	pop    %edi
  800663:	5d                   	pop    %ebp
  800664:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800665:	83 ec 0c             	sub    $0xc,%esp
  800668:	50                   	push   %eax
  800669:	6a 08                	push   $0x8
  80066b:	68 0f 1f 80 00       	push   $0x801f0f
  800670:	6a 23                	push   $0x23
  800672:	68 2c 1f 80 00       	push   $0x801f2c
  800677:	e8 c7 0d 00 00       	call   801443 <_panic>

0080067c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800685:	bb 00 00 00 00       	mov    $0x0,%ebx
  80068a:	8b 55 08             	mov    0x8(%ebp),%edx
  80068d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800690:	b8 09 00 00 00       	mov    $0x9,%eax
  800695:	89 df                	mov    %ebx,%edi
  800697:	89 de                	mov    %ebx,%esi
  800699:	cd 30                	int    $0x30
	if(check && ret > 0)
  80069b:	85 c0                	test   %eax,%eax
  80069d:	7f 08                	jg     8006a7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80069f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a2:	5b                   	pop    %ebx
  8006a3:	5e                   	pop    %esi
  8006a4:	5f                   	pop    %edi
  8006a5:	5d                   	pop    %ebp
  8006a6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a7:	83 ec 0c             	sub    $0xc,%esp
  8006aa:	50                   	push   %eax
  8006ab:	6a 09                	push   $0x9
  8006ad:	68 0f 1f 80 00       	push   $0x801f0f
  8006b2:	6a 23                	push   $0x23
  8006b4:	68 2c 1f 80 00       	push   $0x801f2c
  8006b9:	e8 85 0d 00 00       	call   801443 <_panic>

008006be <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	57                   	push   %edi
  8006c2:	56                   	push   %esi
  8006c3:	53                   	push   %ebx
  8006c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d7:	89 df                	mov    %ebx,%edi
  8006d9:	89 de                	mov    %ebx,%esi
  8006db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	7f 08                	jg     8006e9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e4:	5b                   	pop    %ebx
  8006e5:	5e                   	pop    %esi
  8006e6:	5f                   	pop    %edi
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e9:	83 ec 0c             	sub    $0xc,%esp
  8006ec:	50                   	push   %eax
  8006ed:	6a 0a                	push   $0xa
  8006ef:	68 0f 1f 80 00       	push   $0x801f0f
  8006f4:	6a 23                	push   $0x23
  8006f6:	68 2c 1f 80 00       	push   $0x801f2c
  8006fb:	e8 43 0d 00 00       	call   801443 <_panic>

00800700 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	57                   	push   %edi
  800704:	56                   	push   %esi
  800705:	53                   	push   %ebx
	asm volatile("int %1\n"
  800706:	8b 55 08             	mov    0x8(%ebp),%edx
  800709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800711:	be 00 00 00 00       	mov    $0x0,%esi
  800716:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800719:	8b 7d 14             	mov    0x14(%ebp),%edi
  80071c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80071e:	5b                   	pop    %ebx
  80071f:	5e                   	pop    %esi
  800720:	5f                   	pop    %edi
  800721:	5d                   	pop    %ebp
  800722:	c3                   	ret    

00800723 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	57                   	push   %edi
  800727:	56                   	push   %esi
  800728:	53                   	push   %ebx
  800729:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80072c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800731:	8b 55 08             	mov    0x8(%ebp),%edx
  800734:	b8 0d 00 00 00       	mov    $0xd,%eax
  800739:	89 cb                	mov    %ecx,%ebx
  80073b:	89 cf                	mov    %ecx,%edi
  80073d:	89 ce                	mov    %ecx,%esi
  80073f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800741:	85 c0                	test   %eax,%eax
  800743:	7f 08                	jg     80074d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800745:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800748:	5b                   	pop    %ebx
  800749:	5e                   	pop    %esi
  80074a:	5f                   	pop    %edi
  80074b:	5d                   	pop    %ebp
  80074c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80074d:	83 ec 0c             	sub    $0xc,%esp
  800750:	50                   	push   %eax
  800751:	6a 0d                	push   $0xd
  800753:	68 0f 1f 80 00       	push   $0x801f0f
  800758:	6a 23                	push   $0x23
  80075a:	68 2c 1f 80 00       	push   $0x801f2c
  80075f:	e8 df 0c 00 00       	call   801443 <_panic>

00800764 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	05 00 00 00 30       	add    $0x30000000,%eax
  80076f:	c1 e8 0c             	shr    $0xc,%eax
}
  800772:	5d                   	pop    %ebp
  800773:	c3                   	ret    

00800774 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80077f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800784:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800793:	89 c2                	mov    %eax,%edx
  800795:	c1 ea 16             	shr    $0x16,%edx
  800798:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80079f:	f6 c2 01             	test   $0x1,%dl
  8007a2:	74 29                	je     8007cd <fd_alloc+0x42>
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	c1 ea 0c             	shr    $0xc,%edx
  8007a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007b0:	f6 c2 01             	test   $0x1,%dl
  8007b3:	74 18                	je     8007cd <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  8007b5:	05 00 10 00 00       	add    $0x1000,%eax
  8007ba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007bf:	75 d2                	jne    800793 <fd_alloc+0x8>
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8007c6:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8007cb:	eb 05                	jmp    8007d2 <fd_alloc+0x47>
			return 0;
  8007cd:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8007d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d5:	89 02                	mov    %eax,(%edx)
}
  8007d7:	89 c8                	mov    %ecx,%eax
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007e1:	83 f8 1f             	cmp    $0x1f,%eax
  8007e4:	77 30                	ja     800816 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8007e6:	c1 e0 0c             	shl    $0xc,%eax
  8007e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007ee:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8007f4:	f6 c2 01             	test   $0x1,%dl
  8007f7:	74 24                	je     80081d <fd_lookup+0x42>
  8007f9:	89 c2                	mov    %eax,%edx
  8007fb:	c1 ea 0c             	shr    $0xc,%edx
  8007fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800805:	f6 c2 01             	test   $0x1,%dl
  800808:	74 1a                	je     800824 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	89 02                	mov    %eax,(%edx)
	return 0;
  80080f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    
		return -E_INVAL;
  800816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081b:	eb f7                	jmp    800814 <fd_lookup+0x39>
		return -E_INVAL;
  80081d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800822:	eb f0                	jmp    800814 <fd_lookup+0x39>
  800824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800829:	eb e9                	jmp    800814 <fd_lookup+0x39>

0080082b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	8b 55 08             	mov    0x8(%ebp),%edx
  800835:	b8 b8 1f 80 00       	mov    $0x801fb8,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  80083a:	bb 04 30 80 00       	mov    $0x803004,%ebx
		if (devtab[i]->dev_id == dev_id) {
  80083f:	39 13                	cmp    %edx,(%ebx)
  800841:	74 32                	je     800875 <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	8b 18                	mov    (%eax),%ebx
  800848:	85 db                	test   %ebx,%ebx
  80084a:	75 f3                	jne    80083f <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80084c:	a1 00 40 80 00       	mov    0x804000,%eax
  800851:	8b 40 48             	mov    0x48(%eax),%eax
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	52                   	push   %edx
  800858:	50                   	push   %eax
  800859:	68 3c 1f 80 00       	push   $0x801f3c
  80085e:	e8 bb 0c 00 00       	call   80151e <cprintf>
	*dev = 0;
	return -E_INVAL;
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  80086b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086e:	89 1a                	mov    %ebx,(%edx)
}
  800870:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800873:	c9                   	leave  
  800874:	c3                   	ret    
			return 0;
  800875:	b8 00 00 00 00       	mov    $0x0,%eax
  80087a:	eb ef                	jmp    80086b <dev_lookup+0x40>

0080087c <fd_close>:
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	57                   	push   %edi
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	83 ec 24             	sub    $0x24,%esp
  800885:	8b 75 08             	mov    0x8(%ebp),%esi
  800888:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80088b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80088e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80088f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800895:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800898:	50                   	push   %eax
  800899:	e8 3d ff ff ff       	call   8007db <fd_lookup>
  80089e:	89 c3                	mov    %eax,%ebx
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	78 05                	js     8008ac <fd_close+0x30>
	    || fd != fd2)
  8008a7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008aa:	74 16                	je     8008c2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8008ac:	89 f8                	mov    %edi,%eax
  8008ae:	84 c0                	test   %al,%al
  8008b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b5:	0f 44 d8             	cmove  %eax,%ebx
}
  8008b8:	89 d8                	mov    %ebx,%eax
  8008ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5f                   	pop    %edi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008c8:	50                   	push   %eax
  8008c9:	ff 36                	push   (%esi)
  8008cb:	e8 5b ff ff ff       	call   80082b <dev_lookup>
  8008d0:	89 c3                	mov    %eax,%ebx
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	85 c0                	test   %eax,%eax
  8008d7:	78 1a                	js     8008f3 <fd_close+0x77>
		if (dev->dev_close)
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8008df:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	74 0b                	je     8008f3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8008e8:	83 ec 0c             	sub    $0xc,%esp
  8008eb:	56                   	push   %esi
  8008ec:	ff d0                	call   *%eax
  8008ee:	89 c3                	mov    %eax,%ebx
  8008f0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	56                   	push   %esi
  8008f7:	6a 00                	push   $0x0
  8008f9:	e8 fa fc ff ff       	call   8005f8 <sys_page_unmap>
	return r;
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	eb b5                	jmp    8008b8 <fd_close+0x3c>

00800903 <close>:

int
close(int fdnum)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80090c:	50                   	push   %eax
  80090d:	ff 75 08             	push   0x8(%ebp)
  800910:	e8 c6 fe ff ff       	call   8007db <fd_lookup>
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	85 c0                	test   %eax,%eax
  80091a:	79 02                	jns    80091e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    
		return fd_close(fd, 1);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	6a 01                	push   $0x1
  800923:	ff 75 f4             	push   -0xc(%ebp)
  800926:	e8 51 ff ff ff       	call   80087c <fd_close>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	eb ec                	jmp    80091c <close+0x19>

00800930 <close_all>:

void
close_all(void)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	53                   	push   %ebx
  800934:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800937:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	53                   	push   %ebx
  800940:	e8 be ff ff ff       	call   800903 <close>
	for (i = 0; i < MAXFD; i++)
  800945:	83 c3 01             	add    $0x1,%ebx
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	83 fb 20             	cmp    $0x20,%ebx
  80094e:	75 ec                	jne    80093c <close_all+0xc>
}
  800950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	57                   	push   %edi
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80095e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800961:	50                   	push   %eax
  800962:	ff 75 08             	push   0x8(%ebp)
  800965:	e8 71 fe ff ff       	call   8007db <fd_lookup>
  80096a:	89 c3                	mov    %eax,%ebx
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	85 c0                	test   %eax,%eax
  800971:	78 7f                	js     8009f2 <dup+0x9d>
		return r;
	close(newfdnum);
  800973:	83 ec 0c             	sub    $0xc,%esp
  800976:	ff 75 0c             	push   0xc(%ebp)
  800979:	e8 85 ff ff ff       	call   800903 <close>

	newfd = INDEX2FD(newfdnum);
  80097e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800981:	c1 e6 0c             	shl    $0xc,%esi
  800984:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80098a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80098d:	89 3c 24             	mov    %edi,(%esp)
  800990:	e8 df fd ff ff       	call   800774 <fd2data>
  800995:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800997:	89 34 24             	mov    %esi,(%esp)
  80099a:	e8 d5 fd ff ff       	call   800774 <fd2data>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009a5:	89 d8                	mov    %ebx,%eax
  8009a7:	c1 e8 16             	shr    $0x16,%eax
  8009aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009b1:	a8 01                	test   $0x1,%al
  8009b3:	74 11                	je     8009c6 <dup+0x71>
  8009b5:	89 d8                	mov    %ebx,%eax
  8009b7:	c1 e8 0c             	shr    $0xc,%eax
  8009ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009c1:	f6 c2 01             	test   $0x1,%dl
  8009c4:	75 36                	jne    8009fc <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009c6:	89 f8                	mov    %edi,%eax
  8009c8:	c1 e8 0c             	shr    $0xc,%eax
  8009cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8009d2:	83 ec 0c             	sub    $0xc,%esp
  8009d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8009da:	50                   	push   %eax
  8009db:	56                   	push   %esi
  8009dc:	6a 00                	push   $0x0
  8009de:	57                   	push   %edi
  8009df:	6a 00                	push   $0x0
  8009e1:	e8 d0 fb ff ff       	call   8005b6 <sys_page_map>
  8009e6:	89 c3                	mov    %eax,%ebx
  8009e8:	83 c4 20             	add    $0x20,%esp
  8009eb:	85 c0                	test   %eax,%eax
  8009ed:	78 33                	js     800a22 <dup+0xcd>
		goto err;

	return newfdnum;
  8009ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8009f2:	89 d8                	mov    %ebx,%eax
  8009f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009f7:	5b                   	pop    %ebx
  8009f8:	5e                   	pop    %esi
  8009f9:	5f                   	pop    %edi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a03:	83 ec 0c             	sub    $0xc,%esp
  800a06:	25 07 0e 00 00       	and    $0xe07,%eax
  800a0b:	50                   	push   %eax
  800a0c:	ff 75 d4             	push   -0x2c(%ebp)
  800a0f:	6a 00                	push   $0x0
  800a11:	53                   	push   %ebx
  800a12:	6a 00                	push   $0x0
  800a14:	e8 9d fb ff ff       	call   8005b6 <sys_page_map>
  800a19:	89 c3                	mov    %eax,%ebx
  800a1b:	83 c4 20             	add    $0x20,%esp
  800a1e:	85 c0                	test   %eax,%eax
  800a20:	79 a4                	jns    8009c6 <dup+0x71>
	sys_page_unmap(0, newfd);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	56                   	push   %esi
  800a26:	6a 00                	push   $0x0
  800a28:	e8 cb fb ff ff       	call   8005f8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a2d:	83 c4 08             	add    $0x8,%esp
  800a30:	ff 75 d4             	push   -0x2c(%ebp)
  800a33:	6a 00                	push   $0x0
  800a35:	e8 be fb ff ff       	call   8005f8 <sys_page_unmap>
	return r;
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	eb b3                	jmp    8009f2 <dup+0x9d>

00800a3f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	83 ec 18             	sub    $0x18,%esp
  800a47:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a4d:	50                   	push   %eax
  800a4e:	56                   	push   %esi
  800a4f:	e8 87 fd ff ff       	call   8007db <fd_lookup>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 3c                	js     800a97 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a5b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	ff 33                	push   (%ebx)
  800a67:	e8 bf fd ff ff       	call   80082b <dev_lookup>
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	85 c0                	test   %eax,%eax
  800a71:	78 24                	js     800a97 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a73:	8b 43 08             	mov    0x8(%ebx),%eax
  800a76:	83 e0 03             	and    $0x3,%eax
  800a79:	83 f8 01             	cmp    $0x1,%eax
  800a7c:	74 20                	je     800a9e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a81:	8b 40 08             	mov    0x8(%eax),%eax
  800a84:	85 c0                	test   %eax,%eax
  800a86:	74 37                	je     800abf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	ff 75 10             	push   0x10(%ebp)
  800a8e:	ff 75 0c             	push   0xc(%ebp)
  800a91:	53                   	push   %ebx
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
}
  800a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a9e:	a1 00 40 80 00       	mov    0x804000,%eax
  800aa3:	8b 40 48             	mov    0x48(%eax),%eax
  800aa6:	83 ec 04             	sub    $0x4,%esp
  800aa9:	56                   	push   %esi
  800aaa:	50                   	push   %eax
  800aab:	68 7d 1f 80 00       	push   $0x801f7d
  800ab0:	e8 69 0a 00 00       	call   80151e <cprintf>
		return -E_INVAL;
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800abd:	eb d8                	jmp    800a97 <read+0x58>
		return -E_NOT_SUPP;
  800abf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ac4:	eb d1                	jmp    800a97 <read+0x58>

00800ac6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	53                   	push   %ebx
  800acc:	83 ec 0c             	sub    $0xc,%esp
  800acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ad5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ada:	eb 02                	jmp    800ade <readn+0x18>
  800adc:	01 c3                	add    %eax,%ebx
  800ade:	39 f3                	cmp    %esi,%ebx
  800ae0:	73 21                	jae    800b03 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800ae2:	83 ec 04             	sub    $0x4,%esp
  800ae5:	89 f0                	mov    %esi,%eax
  800ae7:	29 d8                	sub    %ebx,%eax
  800ae9:	50                   	push   %eax
  800aea:	89 d8                	mov    %ebx,%eax
  800aec:	03 45 0c             	add    0xc(%ebp),%eax
  800aef:	50                   	push   %eax
  800af0:	57                   	push   %edi
  800af1:	e8 49 ff ff ff       	call   800a3f <read>
		if (m < 0)
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	85 c0                	test   %eax,%eax
  800afb:	78 04                	js     800b01 <readn+0x3b>
			return m;
		if (m == 0)
  800afd:	75 dd                	jne    800adc <readn+0x16>
  800aff:	eb 02                	jmp    800b03 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b01:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b03:	89 d8                	mov    %ebx,%eax
  800b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	83 ec 18             	sub    $0x18,%esp
  800b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b1b:	50                   	push   %eax
  800b1c:	53                   	push   %ebx
  800b1d:	e8 b9 fc ff ff       	call   8007db <fd_lookup>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	85 c0                	test   %eax,%eax
  800b27:	78 37                	js     800b60 <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b29:	8b 75 f0             	mov    -0x10(%ebp),%esi
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	ff 36                	push   (%esi)
  800b35:	e8 f1 fc ff ff       	call   80082b <dev_lookup>
  800b3a:	83 c4 10             	add    $0x10,%esp
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	78 1f                	js     800b60 <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b41:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  800b45:	74 20                	je     800b67 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	74 37                	je     800b88 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b51:	83 ec 04             	sub    $0x4,%esp
  800b54:	ff 75 10             	push   0x10(%ebp)
  800b57:	ff 75 0c             	push   0xc(%ebp)
  800b5a:	56                   	push   %esi
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
}
  800b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b67:	a1 00 40 80 00       	mov    0x804000,%eax
  800b6c:	8b 40 48             	mov    0x48(%eax),%eax
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	53                   	push   %ebx
  800b73:	50                   	push   %eax
  800b74:	68 99 1f 80 00       	push   $0x801f99
  800b79:	e8 a0 09 00 00       	call   80151e <cprintf>
		return -E_INVAL;
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b86:	eb d8                	jmp    800b60 <write+0x53>
		return -E_NOT_SUPP;
  800b88:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b8d:	eb d1                	jmp    800b60 <write+0x53>

00800b8f <seek>:

int
seek(int fdnum, off_t offset)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b98:	50                   	push   %eax
  800b99:	ff 75 08             	push   0x8(%ebp)
  800b9c:	e8 3a fc ff ff       	call   8007db <fd_lookup>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	78 0e                	js     800bb6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bae:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 18             	sub    $0x18,%esp
  800bc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bc6:	50                   	push   %eax
  800bc7:	53                   	push   %ebx
  800bc8:	e8 0e fc ff ff       	call   8007db <fd_lookup>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	78 34                	js     800c08 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bd4:	8b 75 f0             	mov    -0x10(%ebp),%esi
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bdd:	50                   	push   %eax
  800bde:	ff 36                	push   (%esi)
  800be0:	e8 46 fc ff ff       	call   80082b <dev_lookup>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	85 c0                	test   %eax,%eax
  800bea:	78 1c                	js     800c08 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bec:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  800bf0:	74 1d                	je     800c0f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf5:	8b 40 18             	mov    0x18(%eax),%eax
  800bf8:	85 c0                	test   %eax,%eax
  800bfa:	74 34                	je     800c30 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	push   0xc(%ebp)
  800c02:	56                   	push   %esi
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
}
  800c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c0f:	a1 00 40 80 00       	mov    0x804000,%eax
  800c14:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c17:	83 ec 04             	sub    $0x4,%esp
  800c1a:	53                   	push   %ebx
  800c1b:	50                   	push   %eax
  800c1c:	68 5c 1f 80 00       	push   $0x801f5c
  800c21:	e8 f8 08 00 00       	call   80151e <cprintf>
		return -E_INVAL;
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c2e:	eb d8                	jmp    800c08 <ftruncate+0x50>
		return -E_NOT_SUPP;
  800c30:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c35:	eb d1                	jmp    800c08 <ftruncate+0x50>

00800c37 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	83 ec 18             	sub    $0x18,%esp
  800c3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c45:	50                   	push   %eax
  800c46:	ff 75 08             	push   0x8(%ebp)
  800c49:	e8 8d fb ff ff       	call   8007db <fd_lookup>
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	85 c0                	test   %eax,%eax
  800c53:	78 49                	js     800c9e <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c55:	8b 75 f0             	mov    -0x10(%ebp),%esi
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c5e:	50                   	push   %eax
  800c5f:	ff 36                	push   (%esi)
  800c61:	e8 c5 fb ff ff       	call   80082b <dev_lookup>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	85 c0                	test   %eax,%eax
  800c6b:	78 31                	js     800c9e <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  800c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c70:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c74:	74 2f                	je     800ca5 <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800c76:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800c79:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800c80:	00 00 00 
	stat->st_isdir = 0;
  800c83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c8a:	00 00 00 
	stat->st_dev = dev;
  800c8d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	53                   	push   %ebx
  800c97:	56                   	push   %esi
  800c98:	ff 50 14             	call   *0x14(%eax)
  800c9b:	83 c4 10             	add    $0x10,%esp
}
  800c9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
		return -E_NOT_SUPP;
  800ca5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800caa:	eb f2                	jmp    800c9e <fstat+0x67>

00800cac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	6a 00                	push   $0x0
  800cb6:	ff 75 08             	push   0x8(%ebp)
  800cb9:	e8 22 02 00 00       	call   800ee0 <open>
  800cbe:	89 c3                	mov    %eax,%ebx
  800cc0:	83 c4 10             	add    $0x10,%esp
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	78 1b                	js     800ce2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	push   0xc(%ebp)
  800ccd:	50                   	push   %eax
  800cce:	e8 64 ff ff ff       	call   800c37 <fstat>
  800cd3:	89 c6                	mov    %eax,%esi
	close(fd);
  800cd5:	89 1c 24             	mov    %ebx,(%esp)
  800cd8:	e8 26 fc ff ff       	call   800903 <close>
	return r;
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	89 f3                	mov    %esi,%ebx
}
  800ce2:	89 d8                	mov    %ebx,%eax
  800ce4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	89 c6                	mov    %eax,%esi
  800cf2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800cf4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800cfb:	74 27                	je     800d24 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800cfd:	6a 07                	push   $0x7
  800cff:	68 00 50 80 00       	push   $0x805000
  800d04:	56                   	push   %esi
  800d05:	ff 35 00 60 80 00    	push   0x806000
  800d0b:	e8 e7 0e 00 00       	call   801bf7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d10:	83 c4 0c             	add    $0xc,%esp
  800d13:	6a 00                	push   $0x0
  800d15:	53                   	push   %ebx
  800d16:	6a 00                	push   $0x0
  800d18:	e8 8b 0e 00 00       	call   801ba8 <ipc_recv>
}
  800d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	6a 01                	push   $0x1
  800d29:	e8 15 0f 00 00       	call   801c43 <ipc_find_env>
  800d2e:	a3 00 60 80 00       	mov    %eax,0x806000
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	eb c5                	jmp    800cfd <fsipc+0x12>

00800d38 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 40 0c             	mov    0xc(%eax),%eax
  800d44:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	e8 8b ff ff ff       	call   800ceb <fsipc>
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <devfile_flush>:
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 40 0c             	mov    0xc(%eax),%eax
  800d6e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d73:	ba 00 00 00 00       	mov    $0x0,%edx
  800d78:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7d:	e8 69 ff ff ff       	call   800ceb <fsipc>
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <devfile_stat>:
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	53                   	push   %ebx
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 40 0c             	mov    0xc(%eax),%eax
  800d94:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	b8 05 00 00 00       	mov    $0x5,%eax
  800da3:	e8 43 ff ff ff       	call   800ceb <fsipc>
  800da8:	85 c0                	test   %eax,%eax
  800daa:	78 2c                	js     800dd8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	68 00 50 80 00       	push   $0x805000
  800db4:	53                   	push   %ebx
  800db5:	e8 bd f3 ff ff       	call   800177 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800dba:	a1 80 50 80 00       	mov    0x805080,%eax
  800dbf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800dc5:	a1 84 50 80 00       	mov    0x805084,%eax
  800dca:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800dd0:	83 c4 10             	add    $0x10,%esp
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <devfile_write>:
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	53                   	push   %ebx
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 40 0c             	mov    0xc(%eax),%eax
  800ded:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800df2:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800df8:	53                   	push   %ebx
  800df9:	ff 75 0c             	push   0xc(%ebp)
  800dfc:	68 08 50 80 00       	push   $0x805008
  800e01:	e8 69 f5 ff ff       	call   80036f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800e06:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e10:	e8 d6 fe ff ff       	call   800ceb <fsipc>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	78 0b                	js     800e27 <devfile_write+0x4a>
	assert(r <= n);
  800e1c:	39 d8                	cmp    %ebx,%eax
  800e1e:	77 0c                	ja     800e2c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  800e20:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e25:	7f 1e                	jg     800e45 <devfile_write+0x68>
}
  800e27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    
	assert(r <= n);
  800e2c:	68 c8 1f 80 00       	push   $0x801fc8
  800e31:	68 cf 1f 80 00       	push   $0x801fcf
  800e36:	68 97 00 00 00       	push   $0x97
  800e3b:	68 e4 1f 80 00       	push   $0x801fe4
  800e40:	e8 fe 05 00 00       	call   801443 <_panic>
	assert(r <= PGSIZE);
  800e45:	68 ef 1f 80 00       	push   $0x801fef
  800e4a:	68 cf 1f 80 00       	push   $0x801fcf
  800e4f:	68 98 00 00 00       	push   $0x98
  800e54:	68 e4 1f 80 00       	push   $0x801fe4
  800e59:	e8 e5 05 00 00       	call   801443 <_panic>

00800e5e <devfile_read>:
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8b 40 0c             	mov    0xc(%eax),%eax
  800e6c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800e71:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e77:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e81:	e8 65 fe ff ff       	call   800ceb <fsipc>
  800e86:	89 c3                	mov    %eax,%ebx
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	78 1f                	js     800eab <devfile_read+0x4d>
	assert(r <= n);
  800e8c:	39 f0                	cmp    %esi,%eax
  800e8e:	77 24                	ja     800eb4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800e90:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e95:	7f 33                	jg     800eca <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800e97:	83 ec 04             	sub    $0x4,%esp
  800e9a:	50                   	push   %eax
  800e9b:	68 00 50 80 00       	push   $0x805000
  800ea0:	ff 75 0c             	push   0xc(%ebp)
  800ea3:	e8 65 f4 ff ff       	call   80030d <memmove>
	return r;
  800ea8:	83 c4 10             	add    $0x10,%esp
}
  800eab:	89 d8                	mov    %ebx,%eax
  800ead:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
	assert(r <= n);
  800eb4:	68 c8 1f 80 00       	push   $0x801fc8
  800eb9:	68 cf 1f 80 00       	push   $0x801fcf
  800ebe:	6a 7c                	push   $0x7c
  800ec0:	68 e4 1f 80 00       	push   $0x801fe4
  800ec5:	e8 79 05 00 00       	call   801443 <_panic>
	assert(r <= PGSIZE);
  800eca:	68 ef 1f 80 00       	push   $0x801fef
  800ecf:	68 cf 1f 80 00       	push   $0x801fcf
  800ed4:	6a 7d                	push   $0x7d
  800ed6:	68 e4 1f 80 00       	push   $0x801fe4
  800edb:	e8 63 05 00 00       	call   801443 <_panic>

00800ee0 <open>:
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 1c             	sub    $0x1c,%esp
  800ee8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800eeb:	56                   	push   %esi
  800eec:	e8 4b f2 ff ff       	call   80013c <strlen>
  800ef1:	83 c4 10             	add    $0x10,%esp
  800ef4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ef9:	7f 6c                	jg     800f67 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 84 f8 ff ff       	call   80078b <fd_alloc>
  800f07:	89 c3                	mov    %eax,%ebx
  800f09:	83 c4 10             	add    $0x10,%esp
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	78 3c                	js     800f4c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	56                   	push   %esi
  800f14:	68 00 50 80 00       	push   $0x805000
  800f19:	e8 59 f2 ff ff       	call   800177 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	b8 01 00 00 00       	mov    $0x1,%eax
  800f2e:	e8 b8 fd ff ff       	call   800ceb <fsipc>
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	78 19                	js     800f55 <open+0x75>
	return fd2num(fd);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	ff 75 f4             	push   -0xc(%ebp)
  800f42:	e8 1d f8 ff ff       	call   800764 <fd2num>
  800f47:	89 c3                	mov    %eax,%ebx
  800f49:	83 c4 10             	add    $0x10,%esp
}
  800f4c:	89 d8                	mov    %ebx,%eax
  800f4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
		fd_close(fd, 0);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	6a 00                	push   $0x0
  800f5a:	ff 75 f4             	push   -0xc(%ebp)
  800f5d:	e8 1a f9 ff ff       	call   80087c <fd_close>
		return r;
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	eb e5                	jmp    800f4c <open+0x6c>
		return -E_BAD_PATH;
  800f67:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f6c:	eb de                	jmp    800f4c <open+0x6c>

00800f6e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800f74:	ba 00 00 00 00       	mov    $0x0,%edx
  800f79:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7e:	e8 68 fd ff ff       	call   800ceb <fsipc>
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
  800f8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	ff 75 08             	push   0x8(%ebp)
  800f93:	e8 dc f7 ff ff       	call   800774 <fd2data>
  800f98:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800f9a:	83 c4 08             	add    $0x8,%esp
  800f9d:	68 fb 1f 80 00       	push   $0x801ffb
  800fa2:	53                   	push   %ebx
  800fa3:	e8 cf f1 ff ff       	call   800177 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fa8:	8b 46 04             	mov    0x4(%esi),%eax
  800fab:	2b 06                	sub    (%esi),%eax
  800fad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fba:	00 00 00 
	stat->st_dev = &devpipe;
  800fbd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800fc4:	30 80 00 
	return 0;
}
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 0c             	sub    $0xc,%esp
  800fda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800fdd:	53                   	push   %ebx
  800fde:	6a 00                	push   $0x0
  800fe0:	e8 13 f6 ff ff       	call   8005f8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800fe5:	89 1c 24             	mov    %ebx,(%esp)
  800fe8:	e8 87 f7 ff ff       	call   800774 <fd2data>
  800fed:	83 c4 08             	add    $0x8,%esp
  800ff0:	50                   	push   %eax
  800ff1:	6a 00                	push   $0x0
  800ff3:	e8 00 f6 ff ff       	call   8005f8 <sys_page_unmap>
}
  800ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <_pipeisclosed>:
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
  801003:	83 ec 1c             	sub    $0x1c,%esp
  801006:	89 c7                	mov    %eax,%edi
  801008:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80100a:	a1 00 40 80 00       	mov    0x804000,%eax
  80100f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	57                   	push   %edi
  801016:	e8 61 0c 00 00       	call   801c7c <pageref>
  80101b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80101e:	89 34 24             	mov    %esi,(%esp)
  801021:	e8 56 0c 00 00       	call   801c7c <pageref>
		nn = thisenv->env_runs;
  801026:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80102c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80102f:	83 c4 10             	add    $0x10,%esp
  801032:	39 cb                	cmp    %ecx,%ebx
  801034:	74 1b                	je     801051 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801036:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801039:	75 cf                	jne    80100a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80103b:	8b 42 58             	mov    0x58(%edx),%eax
  80103e:	6a 01                	push   $0x1
  801040:	50                   	push   %eax
  801041:	53                   	push   %ebx
  801042:	68 02 20 80 00       	push   $0x802002
  801047:	e8 d2 04 00 00       	call   80151e <cprintf>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	eb b9                	jmp    80100a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801051:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801054:	0f 94 c0             	sete   %al
  801057:	0f b6 c0             	movzbl %al,%eax
}
  80105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <devpipe_write>:
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 28             	sub    $0x28,%esp
  80106b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80106e:	56                   	push   %esi
  80106f:	e8 00 f7 ff ff       	call   800774 <fd2data>
  801074:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	bf 00 00 00 00       	mov    $0x0,%edi
  80107e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801081:	75 09                	jne    80108c <devpipe_write+0x2a>
	return i;
  801083:	89 f8                	mov    %edi,%eax
  801085:	eb 23                	jmp    8010aa <devpipe_write+0x48>
			sys_yield();
  801087:	e8 c8 f4 ff ff       	call   800554 <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80108c:	8b 43 04             	mov    0x4(%ebx),%eax
  80108f:	8b 0b                	mov    (%ebx),%ecx
  801091:	8d 51 20             	lea    0x20(%ecx),%edx
  801094:	39 d0                	cmp    %edx,%eax
  801096:	72 1a                	jb     8010b2 <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801098:	89 da                	mov    %ebx,%edx
  80109a:	89 f0                	mov    %esi,%eax
  80109c:	e8 5c ff ff ff       	call   800ffd <_pipeisclosed>
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	74 e2                	je     801087 <devpipe_write+0x25>
				return 0;
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010b9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010bc:	89 c2                	mov    %eax,%edx
  8010be:	c1 fa 1f             	sar    $0x1f,%edx
  8010c1:	89 d1                	mov    %edx,%ecx
  8010c3:	c1 e9 1b             	shr    $0x1b,%ecx
  8010c6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010c9:	83 e2 1f             	and    $0x1f,%edx
  8010cc:	29 ca                	sub    %ecx,%edx
  8010ce:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010d6:	83 c0 01             	add    $0x1,%eax
  8010d9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8010dc:	83 c7 01             	add    $0x1,%edi
  8010df:	eb 9d                	jmp    80107e <devpipe_write+0x1c>

008010e1 <devpipe_read>:
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 18             	sub    $0x18,%esp
  8010ea:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8010ed:	57                   	push   %edi
  8010ee:	e8 81 f6 ff ff       	call   800774 <fd2data>
  8010f3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	be 00 00 00 00       	mov    $0x0,%esi
  8010fd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801100:	75 13                	jne    801115 <devpipe_read+0x34>
	return i;
  801102:	89 f0                	mov    %esi,%eax
  801104:	eb 02                	jmp    801108 <devpipe_read+0x27>
				return i;
  801106:	89 f0                	mov    %esi,%eax
}
  801108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
			sys_yield();
  801110:	e8 3f f4 ff ff       	call   800554 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801115:	8b 03                	mov    (%ebx),%eax
  801117:	3b 43 04             	cmp    0x4(%ebx),%eax
  80111a:	75 18                	jne    801134 <devpipe_read+0x53>
			if (i > 0)
  80111c:	85 f6                	test   %esi,%esi
  80111e:	75 e6                	jne    801106 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801120:	89 da                	mov    %ebx,%edx
  801122:	89 f8                	mov    %edi,%eax
  801124:	e8 d4 fe ff ff       	call   800ffd <_pipeisclosed>
  801129:	85 c0                	test   %eax,%eax
  80112b:	74 e3                	je     801110 <devpipe_read+0x2f>
				return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
  801132:	eb d4                	jmp    801108 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801134:	99                   	cltd   
  801135:	c1 ea 1b             	shr    $0x1b,%edx
  801138:	01 d0                	add    %edx,%eax
  80113a:	83 e0 1f             	and    $0x1f,%eax
  80113d:	29 d0                	sub    %edx,%eax
  80113f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801144:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801147:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80114a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80114d:	83 c6 01             	add    $0x1,%esi
  801150:	eb ab                	jmp    8010fd <devpipe_read+0x1c>

00801152 <pipe>:
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80115a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	e8 28 f6 ff ff       	call   80078b <fd_alloc>
  801163:	89 c3                	mov    %eax,%ebx
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	0f 88 23 01 00 00    	js     801293 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	68 07 04 00 00       	push   $0x407
  801178:	ff 75 f4             	push   -0xc(%ebp)
  80117b:	6a 00                	push   $0x0
  80117d:	e8 f1 f3 ff ff       	call   800573 <sys_page_alloc>
  801182:	89 c3                	mov    %eax,%ebx
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	0f 88 04 01 00 00    	js     801293 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80118f:	83 ec 0c             	sub    $0xc,%esp
  801192:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801195:	50                   	push   %eax
  801196:	e8 f0 f5 ff ff       	call   80078b <fd_alloc>
  80119b:	89 c3                	mov    %eax,%ebx
  80119d:	83 c4 10             	add    $0x10,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	0f 88 db 00 00 00    	js     801283 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	68 07 04 00 00       	push   $0x407
  8011b0:	ff 75 f0             	push   -0x10(%ebp)
  8011b3:	6a 00                	push   $0x0
  8011b5:	e8 b9 f3 ff ff       	call   800573 <sys_page_alloc>
  8011ba:	89 c3                	mov    %eax,%ebx
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	0f 88 bc 00 00 00    	js     801283 <pipe+0x131>
	va = fd2data(fd0);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	ff 75 f4             	push   -0xc(%ebp)
  8011cd:	e8 a2 f5 ff ff       	call   800774 <fd2data>
  8011d2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011d4:	83 c4 0c             	add    $0xc,%esp
  8011d7:	68 07 04 00 00       	push   $0x407
  8011dc:	50                   	push   %eax
  8011dd:	6a 00                	push   $0x0
  8011df:	e8 8f f3 ff ff       	call   800573 <sys_page_alloc>
  8011e4:	89 c3                	mov    %eax,%ebx
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	0f 88 82 00 00 00    	js     801273 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	ff 75 f0             	push   -0x10(%ebp)
  8011f7:	e8 78 f5 ff ff       	call   800774 <fd2data>
  8011fc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801203:	50                   	push   %eax
  801204:	6a 00                	push   $0x0
  801206:	56                   	push   %esi
  801207:	6a 00                	push   $0x0
  801209:	e8 a8 f3 ff ff       	call   8005b6 <sys_page_map>
  80120e:	89 c3                	mov    %eax,%ebx
  801210:	83 c4 20             	add    $0x20,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	78 4e                	js     801265 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801217:	a1 20 30 80 00       	mov    0x803020,%eax
  80121c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80122b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801233:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80123a:	83 ec 0c             	sub    $0xc,%esp
  80123d:	ff 75 f4             	push   -0xc(%ebp)
  801240:	e8 1f f5 ff ff       	call   800764 <fd2num>
  801245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801248:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80124a:	83 c4 04             	add    $0x4,%esp
  80124d:	ff 75 f0             	push   -0x10(%ebp)
  801250:	e8 0f f5 ff ff       	call   800764 <fd2num>
  801255:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801258:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801263:	eb 2e                	jmp    801293 <pipe+0x141>
	sys_page_unmap(0, va);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	56                   	push   %esi
  801269:	6a 00                	push   $0x0
  80126b:	e8 88 f3 ff ff       	call   8005f8 <sys_page_unmap>
  801270:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	ff 75 f0             	push   -0x10(%ebp)
  801279:	6a 00                	push   $0x0
  80127b:	e8 78 f3 ff ff       	call   8005f8 <sys_page_unmap>
  801280:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	ff 75 f4             	push   -0xc(%ebp)
  801289:	6a 00                	push   $0x0
  80128b:	e8 68 f3 ff ff       	call   8005f8 <sys_page_unmap>
  801290:	83 c4 10             	add    $0x10,%esp
}
  801293:	89 d8                	mov    %ebx,%eax
  801295:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <pipeisclosed>:
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	ff 75 08             	push   0x8(%ebp)
  8012a9:	e8 2d f5 ff ff       	call   8007db <fd_lookup>
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	78 18                	js     8012cd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012b5:	83 ec 0c             	sub    $0xc,%esp
  8012b8:	ff 75 f4             	push   -0xc(%ebp)
  8012bb:	e8 b4 f4 ff ff       	call   800774 <fd2data>
  8012c0:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8012c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c5:	e8 33 fd ff ff       	call   800ffd <_pipeisclosed>
  8012ca:	83 c4 10             	add    $0x10,%esp
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8012cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d4:	c3                   	ret    

008012d5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8012db:	68 1a 20 80 00       	push   $0x80201a
  8012e0:	ff 75 0c             	push   0xc(%ebp)
  8012e3:	e8 8f ee ff ff       	call   800177 <strcpy>
	return 0;
}
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <devcons_write>:
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
  8012f5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8012fb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801300:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801306:	eb 2e                	jmp    801336 <devcons_write+0x47>
		m = n - tot;
  801308:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80130b:	29 f3                	sub    %esi,%ebx
  80130d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801312:	39 c3                	cmp    %eax,%ebx
  801314:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	53                   	push   %ebx
  80131b:	89 f0                	mov    %esi,%eax
  80131d:	03 45 0c             	add    0xc(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	57                   	push   %edi
  801322:	e8 e6 ef ff ff       	call   80030d <memmove>
		sys_cputs(buf, m);
  801327:	83 c4 08             	add    $0x8,%esp
  80132a:	53                   	push   %ebx
  80132b:	57                   	push   %edi
  80132c:	e8 86 f1 ff ff       	call   8004b7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801331:	01 de                	add    %ebx,%esi
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	3b 75 10             	cmp    0x10(%ebp),%esi
  801339:	72 cd                	jb     801308 <devcons_write+0x19>
}
  80133b:	89 f0                	mov    %esi,%eax
  80133d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5f                   	pop    %edi
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <devcons_read>:
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801350:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801354:	75 07                	jne    80135d <devcons_read+0x18>
  801356:	eb 1f                	jmp    801377 <devcons_read+0x32>
		sys_yield();
  801358:	e8 f7 f1 ff ff       	call   800554 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80135d:	e8 73 f1 ff ff       	call   8004d5 <sys_cgetc>
  801362:	85 c0                	test   %eax,%eax
  801364:	74 f2                	je     801358 <devcons_read+0x13>
	if (c < 0)
  801366:	78 0f                	js     801377 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801368:	83 f8 04             	cmp    $0x4,%eax
  80136b:	74 0c                	je     801379 <devcons_read+0x34>
	*(char*)vbuf = c;
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	88 02                	mov    %al,(%edx)
	return 1;
  801372:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    
		return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	eb f7                	jmp    801377 <devcons_read+0x32>

00801380 <cputchar>:
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80138c:	6a 01                	push   $0x1
  80138e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801391:	50                   	push   %eax
  801392:	e8 20 f1 ff ff       	call   8004b7 <sys_cputs>
}
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <getchar>:
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013a2:	6a 01                	push   $0x1
  8013a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	6a 00                	push   $0x0
  8013aa:	e8 90 f6 ff ff       	call   800a3f <read>
	if (r < 0)
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 06                	js     8013bc <getchar+0x20>
	if (r < 1)
  8013b6:	74 06                	je     8013be <getchar+0x22>
	return c;
  8013b8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    
		return -E_EOF;
  8013be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8013c3:	eb f7                	jmp    8013bc <getchar+0x20>

008013c5 <iscons>:
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	ff 75 08             	push   0x8(%ebp)
  8013d2:	e8 04 f4 ff ff       	call   8007db <fd_lookup>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 11                	js     8013ef <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8013de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8013e7:	39 10                	cmp    %edx,(%eax)
  8013e9:	0f 94 c0             	sete   %al
  8013ec:	0f b6 c0             	movzbl %al,%eax
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <opencons>:
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8013f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	e8 8b f3 ff ff       	call   80078b <fd_alloc>
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 3a                	js     801441 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	68 07 04 00 00       	push   $0x407
  80140f:	ff 75 f4             	push   -0xc(%ebp)
  801412:	6a 00                	push   $0x0
  801414:	e8 5a f1 ff ff       	call   800573 <sys_page_alloc>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 21                	js     801441 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801429:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	50                   	push   %eax
  801439:	e8 26 f3 ff ff       	call   800764 <fd2num>
  80143e:	83 c4 10             	add    $0x10,%esp
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801448:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80144b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801451:	e8 df f0 ff ff       	call   800535 <sys_getenvid>
  801456:	83 ec 0c             	sub    $0xc,%esp
  801459:	ff 75 0c             	push   0xc(%ebp)
  80145c:	ff 75 08             	push   0x8(%ebp)
  80145f:	56                   	push   %esi
  801460:	50                   	push   %eax
  801461:	68 28 20 80 00       	push   $0x802028
  801466:	e8 b3 00 00 00       	call   80151e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80146b:	83 c4 18             	add    $0x18,%esp
  80146e:	53                   	push   %ebx
  80146f:	ff 75 10             	push   0x10(%ebp)
  801472:	e8 56 00 00 00       	call   8014cd <vcprintf>
	cprintf("\n");
  801477:	c7 04 24 4d 23 80 00 	movl   $0x80234d,(%esp)
  80147e:	e8 9b 00 00 00       	call   80151e <cprintf>
  801483:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801486:	cc                   	int3   
  801487:	eb fd                	jmp    801486 <_panic+0x43>

00801489 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	53                   	push   %ebx
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801493:	8b 13                	mov    (%ebx),%edx
  801495:	8d 42 01             	lea    0x1(%edx),%eax
  801498:	89 03                	mov    %eax,(%ebx)
  80149a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80149d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014a6:	74 09                	je     8014b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	68 ff 00 00 00       	push   $0xff
  8014b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8014bc:	50                   	push   %eax
  8014bd:	e8 f5 ef ff ff       	call   8004b7 <sys_cputs>
		b->idx = 0;
  8014c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	eb db                	jmp    8014a8 <putch+0x1f>

008014cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014dd:	00 00 00 
	b.cnt = 0;
  8014e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8014e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8014ea:	ff 75 0c             	push   0xc(%ebp)
  8014ed:	ff 75 08             	push   0x8(%ebp)
  8014f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014f6:	50                   	push   %eax
  8014f7:	68 89 14 80 00       	push   $0x801489
  8014fc:	e8 14 01 00 00       	call   801615 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801501:	83 c4 08             	add    $0x8,%esp
  801504:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80150a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	e8 a1 ef ff ff       	call   8004b7 <sys_cputs>

	return b.cnt;
}
  801516:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801524:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801527:	50                   	push   %eax
  801528:	ff 75 08             	push   0x8(%ebp)
  80152b:	e8 9d ff ff ff       	call   8014cd <vcprintf>
	va_end(ap);

	return cnt;
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	57                   	push   %edi
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 1c             	sub    $0x1c,%esp
  80153b:	89 c7                	mov    %eax,%edi
  80153d:	89 d6                	mov    %edx,%esi
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	89 d1                	mov    %edx,%ecx
  801547:	89 c2                	mov    %eax,%edx
  801549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80154c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
  801552:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801555:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801558:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80155f:	39 c2                	cmp    %eax,%edx
  801561:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801564:	72 3e                	jb     8015a4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801566:	83 ec 0c             	sub    $0xc,%esp
  801569:	ff 75 18             	push   0x18(%ebp)
  80156c:	83 eb 01             	sub    $0x1,%ebx
  80156f:	53                   	push   %ebx
  801570:	50                   	push   %eax
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	ff 75 e4             	push   -0x1c(%ebp)
  801577:	ff 75 e0             	push   -0x20(%ebp)
  80157a:	ff 75 dc             	push   -0x24(%ebp)
  80157d:	ff 75 d8             	push   -0x28(%ebp)
  801580:	e8 3b 07 00 00       	call   801cc0 <__udivdi3>
  801585:	83 c4 18             	add    $0x18,%esp
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	89 f2                	mov    %esi,%edx
  80158c:	89 f8                	mov    %edi,%eax
  80158e:	e8 9f ff ff ff       	call   801532 <printnum>
  801593:	83 c4 20             	add    $0x20,%esp
  801596:	eb 13                	jmp    8015ab <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	56                   	push   %esi
  80159c:	ff 75 18             	push   0x18(%ebp)
  80159f:	ff d7                	call   *%edi
  8015a1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015a4:	83 eb 01             	sub    $0x1,%ebx
  8015a7:	85 db                	test   %ebx,%ebx
  8015a9:	7f ed                	jg     801598 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	56                   	push   %esi
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	ff 75 e4             	push   -0x1c(%ebp)
  8015b5:	ff 75 e0             	push   -0x20(%ebp)
  8015b8:	ff 75 dc             	push   -0x24(%ebp)
  8015bb:	ff 75 d8             	push   -0x28(%ebp)
  8015be:	e8 1d 08 00 00       	call   801de0 <__umoddi3>
  8015c3:	83 c4 14             	add    $0x14,%esp
  8015c6:	0f be 80 4b 20 80 00 	movsbl 0x80204b(%eax),%eax
  8015cd:	50                   	push   %eax
  8015ce:	ff d7                	call   *%edi
}
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5f                   	pop    %edi
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    

008015db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8015e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8015e5:	8b 10                	mov    (%eax),%edx
  8015e7:	3b 50 04             	cmp    0x4(%eax),%edx
  8015ea:	73 0a                	jae    8015f6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8015ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ef:	89 08                	mov    %ecx,(%eax)
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	88 02                	mov    %al,(%edx)
}
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    

008015f8 <printfmt>:
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8015fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801601:	50                   	push   %eax
  801602:	ff 75 10             	push   0x10(%ebp)
  801605:	ff 75 0c             	push   0xc(%ebp)
  801608:	ff 75 08             	push   0x8(%ebp)
  80160b:	e8 05 00 00 00       	call   801615 <vprintfmt>
}
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <vprintfmt>:
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	57                   	push   %edi
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	83 ec 3c             	sub    $0x3c,%esp
  80161e:	8b 75 08             	mov    0x8(%ebp),%esi
  801621:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801624:	8b 7d 10             	mov    0x10(%ebp),%edi
  801627:	eb 0a                	jmp    801633 <vprintfmt+0x1e>
			putch(ch, putdat);
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	53                   	push   %ebx
  80162d:	50                   	push   %eax
  80162e:	ff d6                	call   *%esi
  801630:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801633:	83 c7 01             	add    $0x1,%edi
  801636:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80163a:	83 f8 25             	cmp    $0x25,%eax
  80163d:	74 0c                	je     80164b <vprintfmt+0x36>
			if (ch == '\0')
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 e6                	jne    801629 <vprintfmt+0x14>
}
  801643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5f                   	pop    %edi
  801649:	5d                   	pop    %ebp
  80164a:	c3                   	ret    
		padc = ' ';
  80164b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80164f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801656:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80165d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  801664:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801669:	8d 47 01             	lea    0x1(%edi),%eax
  80166c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80166f:	0f b6 17             	movzbl (%edi),%edx
  801672:	8d 42 dd             	lea    -0x23(%edx),%eax
  801675:	3c 55                	cmp    $0x55,%al
  801677:	0f 87 a6 04 00 00    	ja     801b23 <vprintfmt+0x50e>
  80167d:	0f b6 c0             	movzbl %al,%eax
  801680:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  801687:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80168a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80168e:	eb d9                	jmp    801669 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801690:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801693:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801697:	eb d0                	jmp    801669 <vprintfmt+0x54>
  801699:	0f b6 d2             	movzbl %dl,%edx
  80169c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016aa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016ae:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016b1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016b4:	83 f9 09             	cmp    $0x9,%ecx
  8016b7:	77 55                	ja     80170e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8016b9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016bc:	eb e9                	jmp    8016a7 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8016be:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	8d 40 04             	lea    0x4(%eax),%eax
  8016cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016cf:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8016d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016d6:	79 91                	jns    801669 <vprintfmt+0x54>
				width = precision, precision = -1;
  8016d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8016e5:	eb 82                	jmp    801669 <vprintfmt+0x54>
  8016e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8016ea:	85 d2                	test   %edx,%edx
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	0f 49 c2             	cmovns %edx,%eax
  8016f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8016fa:	e9 6a ff ff ff       	jmp    801669 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8016ff:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  801702:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801709:	e9 5b ff ff ff       	jmp    801669 <vprintfmt+0x54>
  80170e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801711:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801714:	eb bc                	jmp    8016d2 <vprintfmt+0xbd>
			lflag++;
  801716:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801719:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80171c:	e9 48 ff ff ff       	jmp    801669 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  801721:	8b 45 14             	mov    0x14(%ebp),%eax
  801724:	8d 78 04             	lea    0x4(%eax),%edi
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	53                   	push   %ebx
  80172b:	ff 30                	push   (%eax)
  80172d:	ff d6                	call   *%esi
			break;
  80172f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801732:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801735:	e9 88 03 00 00       	jmp    801ac2 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80173a:	8b 45 14             	mov    0x14(%ebp),%eax
  80173d:	8d 78 04             	lea    0x4(%eax),%edi
  801740:	8b 10                	mov    (%eax),%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	f7 d8                	neg    %eax
  801746:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801749:	83 f8 0f             	cmp    $0xf,%eax
  80174c:	7f 23                	jg     801771 <vprintfmt+0x15c>
  80174e:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  801755:	85 d2                	test   %edx,%edx
  801757:	74 18                	je     801771 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  801759:	52                   	push   %edx
  80175a:	68 e1 1f 80 00       	push   $0x801fe1
  80175f:	53                   	push   %ebx
  801760:	56                   	push   %esi
  801761:	e8 92 fe ff ff       	call   8015f8 <printfmt>
  801766:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801769:	89 7d 14             	mov    %edi,0x14(%ebp)
  80176c:	e9 51 03 00 00       	jmp    801ac2 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  801771:	50                   	push   %eax
  801772:	68 63 20 80 00       	push   $0x802063
  801777:	53                   	push   %ebx
  801778:	56                   	push   %esi
  801779:	e8 7a fe ff ff       	call   8015f8 <printfmt>
  80177e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801781:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801784:	e9 39 03 00 00       	jmp    801ac2 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  801789:	8b 45 14             	mov    0x14(%ebp),%eax
  80178c:	83 c0 04             	add    $0x4,%eax
  80178f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801797:	85 d2                	test   %edx,%edx
  801799:	b8 5c 20 80 00       	mov    $0x80205c,%eax
  80179e:	0f 45 c2             	cmovne %edx,%eax
  8017a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8017a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8017a8:	7e 06                	jle    8017b0 <vprintfmt+0x19b>
  8017aa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8017ae:	75 0d                	jne    8017bd <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017b3:	89 c7                	mov    %eax,%edi
  8017b5:	03 45 d4             	add    -0x2c(%ebp),%eax
  8017b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8017bb:	eb 55                	jmp    801812 <vprintfmt+0x1fd>
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	ff 75 e0             	push   -0x20(%ebp)
  8017c3:	ff 75 cc             	push   -0x34(%ebp)
  8017c6:	e8 89 e9 ff ff       	call   800154 <strnlen>
  8017cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8017ce:	29 c2                	sub    %eax,%edx
  8017d0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8017d8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8017dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8017df:	eb 0f                	jmp    8017f0 <vprintfmt+0x1db>
					putch(padc, putdat);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	53                   	push   %ebx
  8017e5:	ff 75 d4             	push   -0x2c(%ebp)
  8017e8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8017ea:	83 ef 01             	sub    $0x1,%edi
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	85 ff                	test   %edi,%edi
  8017f2:	7f ed                	jg     8017e1 <vprintfmt+0x1cc>
  8017f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8017f7:	85 d2                	test   %edx,%edx
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	0f 49 c2             	cmovns %edx,%eax
  801801:	29 c2                	sub    %eax,%edx
  801803:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  801806:	eb a8                	jmp    8017b0 <vprintfmt+0x19b>
					putch(ch, putdat);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	53                   	push   %ebx
  80180c:	52                   	push   %edx
  80180d:	ff d6                	call   *%esi
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801815:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801817:	83 c7 01             	add    $0x1,%edi
  80181a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80181e:	0f be d0             	movsbl %al,%edx
  801821:	85 d2                	test   %edx,%edx
  801823:	74 4b                	je     801870 <vprintfmt+0x25b>
  801825:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801829:	78 06                	js     801831 <vprintfmt+0x21c>
  80182b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80182f:	78 1e                	js     80184f <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  801831:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801835:	74 d1                	je     801808 <vprintfmt+0x1f3>
  801837:	0f be c0             	movsbl %al,%eax
  80183a:	83 e8 20             	sub    $0x20,%eax
  80183d:	83 f8 5e             	cmp    $0x5e,%eax
  801840:	76 c6                	jbe    801808 <vprintfmt+0x1f3>
					putch('?', putdat);
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	53                   	push   %ebx
  801846:	6a 3f                	push   $0x3f
  801848:	ff d6                	call   *%esi
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	eb c3                	jmp    801812 <vprintfmt+0x1fd>
  80184f:	89 cf                	mov    %ecx,%edi
  801851:	eb 0e                	jmp    801861 <vprintfmt+0x24c>
				putch(' ', putdat);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	53                   	push   %ebx
  801857:	6a 20                	push   $0x20
  801859:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80185b:	83 ef 01             	sub    $0x1,%edi
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 ff                	test   %edi,%edi
  801863:	7f ee                	jg     801853 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  801865:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801868:	89 45 14             	mov    %eax,0x14(%ebp)
  80186b:	e9 52 02 00 00       	jmp    801ac2 <vprintfmt+0x4ad>
  801870:	89 cf                	mov    %ecx,%edi
  801872:	eb ed                	jmp    801861 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 c0 04             	add    $0x4,%eax
  80187a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80187d:	8b 45 14             	mov    0x14(%ebp),%eax
  801880:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801882:	85 d2                	test   %edx,%edx
  801884:	b8 5c 20 80 00       	mov    $0x80205c,%eax
  801889:	0f 45 c2             	cmovne %edx,%eax
  80188c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80188f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801893:	7e 06                	jle    80189b <vprintfmt+0x286>
  801895:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801899:	75 0d                	jne    8018a8 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80189b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80189e:	89 c7                	mov    %eax,%edi
  8018a0:	03 45 d4             	add    -0x2c(%ebp),%eax
  8018a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018a6:	eb 55                	jmp    8018fd <vprintfmt+0x2e8>
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	ff 75 e0             	push   -0x20(%ebp)
  8018ae:	ff 75 cc             	push   -0x34(%ebp)
  8018b1:	e8 9e e8 ff ff       	call   800154 <strnlen>
  8018b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8018b9:	29 c2                	sub    %eax,%edx
  8018bb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8018c3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8018c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ca:	eb 0f                	jmp    8018db <vprintfmt+0x2c6>
					putch(padc, putdat);
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	53                   	push   %ebx
  8018d0:	ff 75 d4             	push   -0x2c(%ebp)
  8018d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8018d5:	83 ef 01             	sub    $0x1,%edi
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 ff                	test   %edi,%edi
  8018dd:	7f ed                	jg     8018cc <vprintfmt+0x2b7>
  8018df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018e2:	85 d2                	test   %edx,%edx
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	0f 49 c2             	cmovns %edx,%eax
  8018ec:	29 c2                	sub    %eax,%edx
  8018ee:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8018f1:	eb a8                	jmp    80189b <vprintfmt+0x286>
					putch(ch, putdat);
  8018f3:	83 ec 08             	sub    $0x8,%esp
  8018f6:	53                   	push   %ebx
  8018f7:	52                   	push   %edx
  8018f8:	ff d6                	call   *%esi
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801900:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  801902:	83 c7 01             	add    $0x1,%edi
  801905:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801909:	0f be d0             	movsbl %al,%edx
  80190c:	3c 3a                	cmp    $0x3a,%al
  80190e:	74 4b                	je     80195b <vprintfmt+0x346>
  801910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801914:	78 06                	js     80191c <vprintfmt+0x307>
  801916:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80191a:	78 1e                	js     80193a <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80191c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801920:	74 d1                	je     8018f3 <vprintfmt+0x2de>
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 20             	sub    $0x20,%eax
  801928:	83 f8 5e             	cmp    $0x5e,%eax
  80192b:	76 c6                	jbe    8018f3 <vprintfmt+0x2de>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	53                   	push   %ebx
  801931:	6a 3f                	push   $0x3f
  801933:	ff d6                	call   *%esi
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	eb c3                	jmp    8018fd <vprintfmt+0x2e8>
  80193a:	89 cf                	mov    %ecx,%edi
  80193c:	eb 0e                	jmp    80194c <vprintfmt+0x337>
				putch(' ', putdat);
  80193e:	83 ec 08             	sub    $0x8,%esp
  801941:	53                   	push   %ebx
  801942:	6a 20                	push   $0x20
  801944:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801946:	83 ef 01             	sub    $0x1,%edi
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 ff                	test   %edi,%edi
  80194e:	7f ee                	jg     80193e <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  801950:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801953:	89 45 14             	mov    %eax,0x14(%ebp)
  801956:	e9 67 01 00 00       	jmp    801ac2 <vprintfmt+0x4ad>
  80195b:	89 cf                	mov    %ecx,%edi
  80195d:	eb ed                	jmp    80194c <vprintfmt+0x337>
	if (lflag >= 2)
  80195f:	83 f9 01             	cmp    $0x1,%ecx
  801962:	7f 1b                	jg     80197f <vprintfmt+0x36a>
	else if (lflag)
  801964:	85 c9                	test   %ecx,%ecx
  801966:	74 63                	je     8019cb <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  801968:	8b 45 14             	mov    0x14(%ebp),%eax
  80196b:	8b 00                	mov    (%eax),%eax
  80196d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801970:	99                   	cltd   
  801971:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801974:	8b 45 14             	mov    0x14(%ebp),%eax
  801977:	8d 40 04             	lea    0x4(%eax),%eax
  80197a:	89 45 14             	mov    %eax,0x14(%ebp)
  80197d:	eb 17                	jmp    801996 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80197f:	8b 45 14             	mov    0x14(%ebp),%eax
  801982:	8b 50 04             	mov    0x4(%eax),%edx
  801985:	8b 00                	mov    (%eax),%eax
  801987:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80198a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8d 40 08             	lea    0x8(%eax),%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801996:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801999:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80199c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8019a1:	85 c9                	test   %ecx,%ecx
  8019a3:	0f 89 ff 00 00 00    	jns    801aa8 <vprintfmt+0x493>
				putch('-', putdat);
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	53                   	push   %ebx
  8019ad:	6a 2d                	push   $0x2d
  8019af:	ff d6                	call   *%esi
				num = -(long long) num;
  8019b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8019b7:	f7 da                	neg    %edx
  8019b9:	83 d1 00             	adc    $0x0,%ecx
  8019bc:	f7 d9                	neg    %ecx
  8019be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8019c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c6:	e9 dd 00 00 00       	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8019cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ce:	8b 00                	mov    (%eax),%eax
  8019d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019d3:	99                   	cltd   
  8019d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8019d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019da:	8d 40 04             	lea    0x4(%eax),%eax
  8019dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8019e0:	eb b4                	jmp    801996 <vprintfmt+0x381>
	if (lflag >= 2)
  8019e2:	83 f9 01             	cmp    $0x1,%ecx
  8019e5:	7f 1e                	jg     801a05 <vprintfmt+0x3f0>
	else if (lflag)
  8019e7:	85 c9                	test   %ecx,%ecx
  8019e9:	74 32                	je     801a1d <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8019eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ee:	8b 10                	mov    (%eax),%edx
  8019f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f5:	8d 40 04             	lea    0x4(%eax),%eax
  8019f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019fb:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  801a00:	e9 a3 00 00 00       	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	8b 10                	mov    (%eax),%edx
  801a0a:	8b 48 04             	mov    0x4(%eax),%ecx
  801a0d:	8d 40 08             	lea    0x8(%eax),%eax
  801a10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a13:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  801a18:	e9 8b 00 00 00       	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  801a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a20:	8b 10                	mov    (%eax),%edx
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	8d 40 04             	lea    0x4(%eax),%eax
  801a2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a2d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  801a32:	eb 74                	jmp    801aa8 <vprintfmt+0x493>
	if (lflag >= 2)
  801a34:	83 f9 01             	cmp    $0x1,%ecx
  801a37:	7f 1b                	jg     801a54 <vprintfmt+0x43f>
	else if (lflag)
  801a39:	85 c9                	test   %ecx,%ecx
  801a3b:	74 2c                	je     801a69 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  801a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a40:	8b 10                	mov    (%eax),%edx
  801a42:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a47:	8d 40 04             	lea    0x4(%eax),%eax
  801a4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a4d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  801a52:	eb 54                	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801a54:	8b 45 14             	mov    0x14(%ebp),%eax
  801a57:	8b 10                	mov    (%eax),%edx
  801a59:	8b 48 04             	mov    0x4(%eax),%ecx
  801a5c:	8d 40 08             	lea    0x8(%eax),%eax
  801a5f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a62:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  801a67:	eb 3f                	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8b 10                	mov    (%eax),%edx
  801a6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a73:	8d 40 04             	lea    0x4(%eax),%eax
  801a76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a79:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  801a7e:	eb 28                	jmp    801aa8 <vprintfmt+0x493>
			putch('0', putdat);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	53                   	push   %ebx
  801a84:	6a 30                	push   $0x30
  801a86:	ff d6                	call   *%esi
			putch('x', putdat);
  801a88:	83 c4 08             	add    $0x8,%esp
  801a8b:	53                   	push   %ebx
  801a8c:	6a 78                	push   $0x78
  801a8e:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a90:	8b 45 14             	mov    0x14(%ebp),%eax
  801a93:	8b 10                	mov    (%eax),%edx
  801a95:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a9a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a9d:	8d 40 04             	lea    0x4(%eax),%eax
  801aa0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa3:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801aaf:	50                   	push   %eax
  801ab0:	ff 75 d4             	push   -0x2c(%ebp)
  801ab3:	57                   	push   %edi
  801ab4:	51                   	push   %ecx
  801ab5:	52                   	push   %edx
  801ab6:	89 da                	mov    %ebx,%edx
  801ab8:	89 f0                	mov    %esi,%eax
  801aba:	e8 73 fa ff ff       	call   801532 <printnum>
			break;
  801abf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801ac2:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ac5:	e9 69 fb ff ff       	jmp    801633 <vprintfmt+0x1e>
	if (lflag >= 2)
  801aca:	83 f9 01             	cmp    $0x1,%ecx
  801acd:	7f 1b                	jg     801aea <vprintfmt+0x4d5>
	else if (lflag)
  801acf:	85 c9                	test   %ecx,%ecx
  801ad1:	74 2c                	je     801aff <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  801ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad6:	8b 10                	mov    (%eax),%edx
  801ad8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801add:	8d 40 04             	lea    0x4(%eax),%eax
  801ae0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ae3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  801ae8:	eb be                	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  801aea:	8b 45 14             	mov    0x14(%ebp),%eax
  801aed:	8b 10                	mov    (%eax),%edx
  801aef:	8b 48 04             	mov    0x4(%eax),%ecx
  801af2:	8d 40 08             	lea    0x8(%eax),%eax
  801af5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801af8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  801afd:	eb a9                	jmp    801aa8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  801aff:	8b 45 14             	mov    0x14(%ebp),%eax
  801b02:	8b 10                	mov    (%eax),%edx
  801b04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b09:	8d 40 04             	lea    0x4(%eax),%eax
  801b0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b0f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  801b14:	eb 92                	jmp    801aa8 <vprintfmt+0x493>
			putch(ch, putdat);
  801b16:	83 ec 08             	sub    $0x8,%esp
  801b19:	53                   	push   %ebx
  801b1a:	6a 25                	push   $0x25
  801b1c:	ff d6                	call   *%esi
			break;
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	eb 9f                	jmp    801ac2 <vprintfmt+0x4ad>
			putch('%', putdat);
  801b23:	83 ec 08             	sub    $0x8,%esp
  801b26:	53                   	push   %ebx
  801b27:	6a 25                	push   $0x25
  801b29:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	89 f8                	mov    %edi,%eax
  801b30:	eb 03                	jmp    801b35 <vprintfmt+0x520>
  801b32:	83 e8 01             	sub    $0x1,%eax
  801b35:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b39:	75 f7                	jne    801b32 <vprintfmt+0x51d>
  801b3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b3e:	eb 82                	jmp    801ac2 <vprintfmt+0x4ad>

00801b40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 18             	sub    $0x18,%esp
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b4f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b53:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	74 26                	je     801b87 <vsnprintf+0x47>
  801b61:	85 d2                	test   %edx,%edx
  801b63:	7e 22                	jle    801b87 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b65:	ff 75 14             	push   0x14(%ebp)
  801b68:	ff 75 10             	push   0x10(%ebp)
  801b6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b6e:	50                   	push   %eax
  801b6f:	68 db 15 80 00       	push   $0x8015db
  801b74:	e8 9c fa ff ff       	call   801615 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b82:	83 c4 10             	add    $0x10,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    
		return -E_INVAL;
  801b87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b8c:	eb f7                	jmp    801b85 <vsnprintf+0x45>

00801b8e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b94:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b97:	50                   	push   %eax
  801b98:	ff 75 10             	push   0x10(%ebp)
  801b9b:	ff 75 0c             	push   0xc(%ebp)
  801b9e:	ff 75 08             	push   0x8(%ebp)
  801ba1:	e8 9a ff ff ff       	call   801b40 <vsnprintf>
	va_end(ap);

	return rc;
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	56                   	push   %esi
  801bac:	53                   	push   %ebx
  801bad:	8b 75 08             	mov    0x8(%ebp),%esi
  801bb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801bb3:	83 ec 0c             	sub    $0xc,%esp
  801bb6:	ff 75 0c             	push   0xc(%ebp)
  801bb9:	e8 65 eb ff ff       	call   800723 <sys_ipc_recv>
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	78 2b                	js     801bf0 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801bc5:	85 f6                	test   %esi,%esi
  801bc7:	74 0a                	je     801bd3 <ipc_recv+0x2b>
  801bc9:	a1 00 40 80 00       	mov    0x804000,%eax
  801bce:	8b 40 74             	mov    0x74(%eax),%eax
  801bd1:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801bd3:	85 db                	test   %ebx,%ebx
  801bd5:	74 0a                	je     801be1 <ipc_recv+0x39>
  801bd7:	a1 00 40 80 00       	mov    0x804000,%eax
  801bdc:	8b 40 78             	mov    0x78(%eax),%eax
  801bdf:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801be1:	a1 00 40 80 00       	mov    0x804000,%eax
  801be6:	8b 40 70             	mov    0x70(%eax),%eax
}
  801be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801bf0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf5:	eb f2                	jmp    801be9 <ipc_recv+0x41>

00801bf7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	57                   	push   %edi
  801bfb:	56                   	push   %esi
  801bfc:	53                   	push   %ebx
  801bfd:	83 ec 0c             	sub    $0xc,%esp
  801c00:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c03:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801c09:	ff 75 14             	push   0x14(%ebp)
  801c0c:	53                   	push   %ebx
  801c0d:	56                   	push   %esi
  801c0e:	57                   	push   %edi
  801c0f:	e8 ec ea ff ff       	call   800700 <sys_ipc_try_send>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	85 c0                	test   %eax,%eax
  801c19:	79 20                	jns    801c3b <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801c1b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c1e:	75 07                	jne    801c27 <ipc_send+0x30>
		sys_yield();
  801c20:	e8 2f e9 ff ff       	call   800554 <sys_yield>
  801c25:	eb e2                	jmp    801c09 <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	68 3f 23 80 00       	push   $0x80233f
  801c2f:	6a 2e                	push   $0x2e
  801c31:	68 4f 23 80 00       	push   $0x80234f
  801c36:	e8 08 f8 ff ff       	call   801443 <_panic>
	}
}
  801c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5e                   	pop    %esi
  801c40:	5f                   	pop    %edi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c4e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c51:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c57:	8b 52 50             	mov    0x50(%edx),%edx
  801c5a:	39 ca                	cmp    %ecx,%edx
  801c5c:	74 11                	je     801c6f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801c5e:	83 c0 01             	add    $0x1,%eax
  801c61:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c66:	75 e6                	jne    801c4e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	eb 0b                	jmp    801c7a <ipc_find_env+0x37>
			return envs[i].env_id;
  801c6f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c72:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c77:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    

00801c7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c82:	89 c2                	mov    %eax,%edx
  801c84:	c1 ea 16             	shr    $0x16,%edx
  801c87:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c93:	f6 c1 01             	test   $0x1,%cl
  801c96:	74 1c                	je     801cb4 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  801c98:	c1 e8 0c             	shr    $0xc,%eax
  801c9b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ca2:	a8 01                	test   $0x1,%al
  801ca4:	74 0e                	je     801cb4 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca6:	c1 e8 0c             	shr    $0xc,%eax
  801ca9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801cb0:	ef 
  801cb1:	0f b7 d2             	movzwl %dx,%edx
}
  801cb4:	89 d0                	mov    %edx,%eax
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	66 90                	xchg   %ax,%ax
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	66 90                	xchg   %ax,%ax
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__udivdi3>:
  801cc0:	f3 0f 1e fb          	endbr32 
  801cc4:	55                   	push   %ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	75 19                	jne    801cf8 <__udivdi3+0x38>
  801cdf:	39 f3                	cmp    %esi,%ebx
  801ce1:	76 4d                	jbe    801d30 <__udivdi3+0x70>
  801ce3:	31 ff                	xor    %edi,%edi
  801ce5:	89 e8                	mov    %ebp,%eax
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	f7 f3                	div    %ebx
  801ceb:	89 fa                	mov    %edi,%edx
  801ced:	83 c4 1c             	add    $0x1c,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    
  801cf5:	8d 76 00             	lea    0x0(%esi),%esi
  801cf8:	39 f0                	cmp    %esi,%eax
  801cfa:	76 14                	jbe    801d10 <__udivdi3+0x50>
  801cfc:	31 ff                	xor    %edi,%edi
  801cfe:	31 c0                	xor    %eax,%eax
  801d00:	89 fa                	mov    %edi,%edx
  801d02:	83 c4 1c             	add    $0x1c,%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
  801d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d10:	0f bd f8             	bsr    %eax,%edi
  801d13:	83 f7 1f             	xor    $0x1f,%edi
  801d16:	75 48                	jne    801d60 <__udivdi3+0xa0>
  801d18:	39 f0                	cmp    %esi,%eax
  801d1a:	72 06                	jb     801d22 <__udivdi3+0x62>
  801d1c:	31 c0                	xor    %eax,%eax
  801d1e:	39 eb                	cmp    %ebp,%ebx
  801d20:	77 de                	ja     801d00 <__udivdi3+0x40>
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	eb d7                	jmp    801d00 <__udivdi3+0x40>
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	89 d9                	mov    %ebx,%ecx
  801d32:	85 db                	test   %ebx,%ebx
  801d34:	75 0b                	jne    801d41 <__udivdi3+0x81>
  801d36:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f3                	div    %ebx
  801d3f:	89 c1                	mov    %eax,%ecx
  801d41:	31 d2                	xor    %edx,%edx
  801d43:	89 f0                	mov    %esi,%eax
  801d45:	f7 f1                	div    %ecx
  801d47:	89 c6                	mov    %eax,%esi
  801d49:	89 e8                	mov    %ebp,%eax
  801d4b:	89 f7                	mov    %esi,%edi
  801d4d:	f7 f1                	div    %ecx
  801d4f:	89 fa                	mov    %edi,%edx
  801d51:	83 c4 1c             	add    $0x1c,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    
  801d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d60:	89 f9                	mov    %edi,%ecx
  801d62:	ba 20 00 00 00       	mov    $0x20,%edx
  801d67:	29 fa                	sub    %edi,%edx
  801d69:	d3 e0                	shl    %cl,%eax
  801d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6f:	89 d1                	mov    %edx,%ecx
  801d71:	89 d8                	mov    %ebx,%eax
  801d73:	d3 e8                	shr    %cl,%eax
  801d75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d79:	09 c1                	or     %eax,%ecx
  801d7b:	89 f0                	mov    %esi,%eax
  801d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d81:	89 f9                	mov    %edi,%ecx
  801d83:	d3 e3                	shl    %cl,%ebx
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	d3 e8                	shr    %cl,%eax
  801d89:	89 f9                	mov    %edi,%ecx
  801d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d8f:	89 eb                	mov    %ebp,%ebx
  801d91:	d3 e6                	shl    %cl,%esi
  801d93:	89 d1                	mov    %edx,%ecx
  801d95:	d3 eb                	shr    %cl,%ebx
  801d97:	09 f3                	or     %esi,%ebx
  801d99:	89 c6                	mov    %eax,%esi
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	89 d8                	mov    %ebx,%eax
  801d9f:	f7 74 24 08          	divl   0x8(%esp)
  801da3:	89 d6                	mov    %edx,%esi
  801da5:	89 c3                	mov    %eax,%ebx
  801da7:	f7 64 24 0c          	mull   0xc(%esp)
  801dab:	39 d6                	cmp    %edx,%esi
  801dad:	72 19                	jb     801dc8 <__udivdi3+0x108>
  801daf:	89 f9                	mov    %edi,%ecx
  801db1:	d3 e5                	shl    %cl,%ebp
  801db3:	39 c5                	cmp    %eax,%ebp
  801db5:	73 04                	jae    801dbb <__udivdi3+0xfb>
  801db7:	39 d6                	cmp    %edx,%esi
  801db9:	74 0d                	je     801dc8 <__udivdi3+0x108>
  801dbb:	89 d8                	mov    %ebx,%eax
  801dbd:	31 ff                	xor    %edi,%edi
  801dbf:	e9 3c ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801dc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dcb:	31 ff                	xor    %edi,%edi
  801dcd:	e9 2e ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dd2:	66 90                	xchg   %ax,%ax
  801dd4:	66 90                	xchg   %ax,%ax
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	66 90                	xchg   %ax,%ax
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	66 90                	xchg   %ax,%ax
  801dde:	66 90                	xchg   %ax,%ax

00801de0 <__umoddi3>:
  801de0:	f3 0f 1e fb          	endbr32 
  801de4:	55                   	push   %ebp
  801de5:	57                   	push   %edi
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 1c             	sub    $0x1c,%esp
  801deb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801def:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801df3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801df7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  801dfb:	89 f0                	mov    %esi,%eax
  801dfd:	89 da                	mov    %ebx,%edx
  801dff:	85 ff                	test   %edi,%edi
  801e01:	75 15                	jne    801e18 <__umoddi3+0x38>
  801e03:	39 dd                	cmp    %ebx,%ebp
  801e05:	76 39                	jbe    801e40 <__umoddi3+0x60>
  801e07:	f7 f5                	div    %ebp
  801e09:	89 d0                	mov    %edx,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	83 c4 1c             	add    $0x1c,%esp
  801e10:	5b                   	pop    %ebx
  801e11:	5e                   	pop    %esi
  801e12:	5f                   	pop    %edi
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    
  801e15:	8d 76 00             	lea    0x0(%esi),%esi
  801e18:	39 df                	cmp    %ebx,%edi
  801e1a:	77 f1                	ja     801e0d <__umoddi3+0x2d>
  801e1c:	0f bd cf             	bsr    %edi,%ecx
  801e1f:	83 f1 1f             	xor    $0x1f,%ecx
  801e22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e26:	75 40                	jne    801e68 <__umoddi3+0x88>
  801e28:	39 df                	cmp    %ebx,%edi
  801e2a:	72 04                	jb     801e30 <__umoddi3+0x50>
  801e2c:	39 f5                	cmp    %esi,%ebp
  801e2e:	77 dd                	ja     801e0d <__umoddi3+0x2d>
  801e30:	89 da                	mov    %ebx,%edx
  801e32:	89 f0                	mov    %esi,%eax
  801e34:	29 e8                	sub    %ebp,%eax
  801e36:	19 fa                	sbb    %edi,%edx
  801e38:	eb d3                	jmp    801e0d <__umoddi3+0x2d>
  801e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e40:	89 e9                	mov    %ebp,%ecx
  801e42:	85 ed                	test   %ebp,%ebp
  801e44:	75 0b                	jne    801e51 <__umoddi3+0x71>
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f5                	div    %ebp
  801e4f:	89 c1                	mov    %eax,%ecx
  801e51:	89 d8                	mov    %ebx,%eax
  801e53:	31 d2                	xor    %edx,%edx
  801e55:	f7 f1                	div    %ecx
  801e57:	89 f0                	mov    %esi,%eax
  801e59:	f7 f1                	div    %ecx
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	31 d2                	xor    %edx,%edx
  801e5f:	eb ac                	jmp    801e0d <__umoddi3+0x2d>
  801e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e68:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e6c:	ba 20 00 00 00       	mov    $0x20,%edx
  801e71:	29 c2                	sub    %eax,%edx
  801e73:	89 c1                	mov    %eax,%ecx
  801e75:	89 e8                	mov    %ebp,%eax
  801e77:	d3 e7                	shl    %cl,%edi
  801e79:	89 d1                	mov    %edx,%ecx
  801e7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e7f:	d3 e8                	shr    %cl,%eax
  801e81:	89 c1                	mov    %eax,%ecx
  801e83:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e87:	09 f9                	or     %edi,%ecx
  801e89:	89 df                	mov    %ebx,%edi
  801e8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e8f:	89 c1                	mov    %eax,%ecx
  801e91:	d3 e5                	shl    %cl,%ebp
  801e93:	89 d1                	mov    %edx,%ecx
  801e95:	d3 ef                	shr    %cl,%edi
  801e97:	89 c1                	mov    %eax,%ecx
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	d3 e3                	shl    %cl,%ebx
  801e9d:	89 d1                	mov    %edx,%ecx
  801e9f:	89 fa                	mov    %edi,%edx
  801ea1:	d3 e8                	shr    %cl,%eax
  801ea3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ea8:	09 d8                	or     %ebx,%eax
  801eaa:	f7 74 24 08          	divl   0x8(%esp)
  801eae:	89 d3                	mov    %edx,%ebx
  801eb0:	d3 e6                	shl    %cl,%esi
  801eb2:	f7 e5                	mul    %ebp
  801eb4:	89 c7                	mov    %eax,%edi
  801eb6:	89 d1                	mov    %edx,%ecx
  801eb8:	39 d3                	cmp    %edx,%ebx
  801eba:	72 06                	jb     801ec2 <__umoddi3+0xe2>
  801ebc:	75 0e                	jne    801ecc <__umoddi3+0xec>
  801ebe:	39 c6                	cmp    %eax,%esi
  801ec0:	73 0a                	jae    801ecc <__umoddi3+0xec>
  801ec2:	29 e8                	sub    %ebp,%eax
  801ec4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ec8:	89 d1                	mov    %edx,%ecx
  801eca:	89 c7                	mov    %eax,%edi
  801ecc:	89 f5                	mov    %esi,%ebp
  801ece:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ed2:	29 fd                	sub    %edi,%ebp
  801ed4:	19 cb                	sbb    %ecx,%ebx
  801ed6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801edb:	89 d8                	mov    %ebx,%eax
  801edd:	d3 e0                	shl    %cl,%eax
  801edf:	89 f1                	mov    %esi,%ecx
  801ee1:	d3 ed                	shr    %cl,%ebp
  801ee3:	d3 eb                	shr    %cl,%ebx
  801ee5:	09 e8                	or     %ebp,%eax
  801ee7:	89 da                	mov    %ebx,%edx
  801ee9:	83 c4 1c             	add    $0x1c,%esp
  801eec:	5b                   	pop    %ebx
  801eed:	5e                   	pop    %esi
  801eee:	5f                   	pop    %edi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    
