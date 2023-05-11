
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	push   0x802000
  800044:	e8 5d 00 00 00       	call   8000a6 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 c6 00 00 00       	call   800124 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80009a:	6a 00                	push   $0x0
  80009c:	e8 42 00 00 00       	call   8000e3 <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b7:	89 c3                	mov    %eax,%ebx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 c6                	mov    %eax,%esi
  8000bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bf:	5b                   	pop    %ebx
  8000c0:	5e                   	pop    %esi
  8000c1:	5f                   	pop    %edi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	89 d3                	mov    %edx,%ebx
  8000d8:	89 d7                	mov    %edx,%edi
  8000da:	89 d6                	mov    %edx,%esi
  8000dc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f9:	89 cb                	mov    %ecx,%ebx
  8000fb:	89 cf                	mov    %ecx,%edi
  8000fd:	89 ce                	mov    %ecx,%esi
  8000ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800101:	85 c0                	test   %eax,%eax
  800103:	7f 08                	jg     80010d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800108:	5b                   	pop    %ebx
  800109:	5e                   	pop    %esi
  80010a:	5f                   	pop    %edi
  80010b:	5d                   	pop    %ebp
  80010c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	50                   	push   %eax
  800111:	6a 03                	push   $0x3
  800113:	68 98 10 80 00       	push   $0x801098
  800118:	6a 23                	push   $0x23
  80011a:	68 b5 10 80 00       	push   $0x8010b5
  80011f:	e8 2f 02 00 00       	call   800353 <_panic>

00800124 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012a:	ba 00 00 00 00       	mov    $0x0,%edx
  80012f:	b8 02 00 00 00       	mov    $0x2,%eax
  800134:	89 d1                	mov    %edx,%ecx
  800136:	89 d3                	mov    %edx,%ebx
  800138:	89 d7                	mov    %edx,%edi
  80013a:	89 d6                	mov    %edx,%esi
  80013c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_yield>:

void
sys_yield(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	asm volatile("int %1\n"
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
  800168:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016b:	be 00 00 00 00       	mov    $0x0,%esi
  800170:	8b 55 08             	mov    0x8(%ebp),%edx
  800173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800176:	b8 04 00 00 00       	mov    $0x4,%eax
  80017b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017e:	89 f7                	mov    %esi,%edi
  800180:	cd 30                	int    $0x30
	if(check && ret > 0)
  800182:	85 c0                	test   %eax,%eax
  800184:	7f 08                	jg     80018e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	6a 04                	push   $0x4
  800194:	68 98 10 80 00       	push   $0x801098
  800199:	6a 23                	push   $0x23
  80019b:	68 b5 10 80 00       	push   $0x8010b5
  8001a0:	e8 ae 01 00 00       	call   800353 <_panic>

008001a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	7f 08                	jg     8001d0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cb:	5b                   	pop    %ebx
  8001cc:	5e                   	pop    %esi
  8001cd:	5f                   	pop    %edi
  8001ce:	5d                   	pop    %ebp
  8001cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	6a 05                	push   $0x5
  8001d6:	68 98 10 80 00       	push   $0x801098
  8001db:	6a 23                	push   $0x23
  8001dd:	68 b5 10 80 00       	push   $0x8010b5
  8001e2:	e8 6c 01 00 00       	call   800353 <_panic>

008001e7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	57                   	push   %edi
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fb:	b8 06 00 00 00       	mov    $0x6,%eax
  800200:	89 df                	mov    %ebx,%edi
  800202:	89 de                	mov    %ebx,%esi
  800204:	cd 30                	int    $0x30
	if(check && ret > 0)
  800206:	85 c0                	test   %eax,%eax
  800208:	7f 08                	jg     800212 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5f                   	pop    %edi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	6a 06                	push   $0x6
  800218:	68 98 10 80 00       	push   $0x801098
  80021d:	6a 23                	push   $0x23
  80021f:	68 b5 10 80 00       	push   $0x8010b5
  800224:	e8 2a 01 00 00       	call   800353 <_panic>

00800229 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	57                   	push   %edi
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
  80022f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800232:	bb 00 00 00 00       	mov    $0x0,%ebx
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
  80023a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023d:	b8 08 00 00 00       	mov    $0x8,%eax
  800242:	89 df                	mov    %ebx,%edi
  800244:	89 de                	mov    %ebx,%esi
  800246:	cd 30                	int    $0x30
	if(check && ret > 0)
  800248:	85 c0                	test   %eax,%eax
  80024a:	7f 08                	jg     800254 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	50                   	push   %eax
  800258:	6a 08                	push   $0x8
  80025a:	68 98 10 80 00       	push   $0x801098
  80025f:	6a 23                	push   $0x23
  800261:	68 b5 10 80 00       	push   $0x8010b5
  800266:	e8 e8 00 00 00       	call   800353 <_panic>

0080026b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	57                   	push   %edi
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800274:	bb 00 00 00 00       	mov    $0x0,%ebx
  800279:	8b 55 08             	mov    0x8(%ebp),%edx
  80027c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027f:	b8 09 00 00 00       	mov    $0x9,%eax
  800284:	89 df                	mov    %ebx,%edi
  800286:	89 de                	mov    %ebx,%esi
  800288:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028a:	85 c0                	test   %eax,%eax
  80028c:	7f 08                	jg     800296 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	50                   	push   %eax
  80029a:	6a 09                	push   $0x9
  80029c:	68 98 10 80 00       	push   $0x801098
  8002a1:	6a 23                	push   $0x23
  8002a3:	68 b5 10 80 00       	push   $0x8010b5
  8002a8:	e8 a6 00 00 00       	call   800353 <_panic>

008002ad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c6:	89 df                	mov    %ebx,%edi
  8002c8:	89 de                	mov    %ebx,%esi
  8002ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	7f 08                	jg     8002d8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 0a                	push   $0xa
  8002de:	68 98 10 80 00       	push   $0x801098
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 b5 10 80 00       	push   $0x8010b5
  8002ea:	e8 64 00 00 00       	call   800353 <_panic>

008002ef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	57                   	push   %edi
  8002f3:	56                   	push   %esi
  8002f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800300:	be 00 00 00 00       	mov    $0x0,%esi
  800305:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800308:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030d:	5b                   	pop    %ebx
  80030e:	5e                   	pop    %esi
  80030f:	5f                   	pop    %edi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	b8 0d 00 00 00       	mov    $0xd,%eax
  800328:	89 cb                	mov    %ecx,%ebx
  80032a:	89 cf                	mov    %ecx,%edi
  80032c:	89 ce                	mov    %ecx,%esi
  80032e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800330:	85 c0                	test   %eax,%eax
  800332:	7f 08                	jg     80033c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	6a 0d                	push   $0xd
  800342:	68 98 10 80 00       	push   $0x801098
  800347:	6a 23                	push   $0x23
  800349:	68 b5 10 80 00       	push   $0x8010b5
  80034e:	e8 00 00 00 00       	call   800353 <_panic>

00800353 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800358:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80035b:	8b 35 04 20 80 00    	mov    0x802004,%esi
  800361:	e8 be fd ff ff       	call   800124 <sys_getenvid>
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	ff 75 0c             	push   0xc(%ebp)
  80036c:	ff 75 08             	push   0x8(%ebp)
  80036f:	56                   	push   %esi
  800370:	50                   	push   %eax
  800371:	68 c4 10 80 00       	push   $0x8010c4
  800376:	e8 b3 00 00 00       	call   80042e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80037b:	83 c4 18             	add    $0x18,%esp
  80037e:	53                   	push   %ebx
  80037f:	ff 75 10             	push   0x10(%ebp)
  800382:	e8 56 00 00 00       	call   8003dd <vcprintf>
	cprintf("\n");
  800387:	c7 04 24 8c 10 80 00 	movl   $0x80108c,(%esp)
  80038e:	e8 9b 00 00 00       	call   80042e <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800396:	cc                   	int3   
  800397:	eb fd                	jmp    800396 <_panic+0x43>

00800399 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	53                   	push   %ebx
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a3:	8b 13                	mov    (%ebx),%edx
  8003a5:	8d 42 01             	lea    0x1(%edx),%eax
  8003a8:	89 03                	mov    %eax,(%ebx)
  8003aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b6:	74 09                	je     8003c1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 ff 00 00 00       	push   $0xff
  8003c9:	8d 43 08             	lea    0x8(%ebx),%eax
  8003cc:	50                   	push   %eax
  8003cd:	e8 d4 fc ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  8003d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	eb db                	jmp    8003b8 <putch+0x1f>

008003dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ed:	00 00 00 
	b.cnt = 0;
  8003f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003fa:	ff 75 0c             	push   0xc(%ebp)
  8003fd:	ff 75 08             	push   0x8(%ebp)
  800400:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800406:	50                   	push   %eax
  800407:	68 99 03 80 00       	push   $0x800399
  80040c:	e8 14 01 00 00       	call   800525 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800411:	83 c4 08             	add    $0x8,%esp
  800414:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80041a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800420:	50                   	push   %eax
  800421:	e8 80 fc ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  800426:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800434:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800437:	50                   	push   %eax
  800438:	ff 75 08             	push   0x8(%ebp)
  80043b:	e8 9d ff ff ff       	call   8003dd <vcprintf>
	va_end(ap);

	return cnt;
}
  800440:	c9                   	leave  
  800441:	c3                   	ret    

00800442 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	57                   	push   %edi
  800446:	56                   	push   %esi
  800447:	53                   	push   %ebx
  800448:	83 ec 1c             	sub    $0x1c,%esp
  80044b:	89 c7                	mov    %eax,%edi
  80044d:	89 d6                	mov    %edx,%esi
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 d1                	mov    %edx,%ecx
  800457:	89 c2                	mov    %eax,%edx
  800459:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800465:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800468:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046f:	39 c2                	cmp    %eax,%edx
  800471:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800474:	72 3e                	jb     8004b4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	83 ec 0c             	sub    $0xc,%esp
  800479:	ff 75 18             	push   0x18(%ebp)
  80047c:	83 eb 01             	sub    $0x1,%ebx
  80047f:	53                   	push   %ebx
  800480:	50                   	push   %eax
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 e4             	push   -0x1c(%ebp)
  800487:	ff 75 e0             	push   -0x20(%ebp)
  80048a:	ff 75 dc             	push   -0x24(%ebp)
  80048d:	ff 75 d8             	push   -0x28(%ebp)
  800490:	e8 ab 09 00 00       	call   800e40 <__udivdi3>
  800495:	83 c4 18             	add    $0x18,%esp
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	89 f2                	mov    %esi,%edx
  80049c:	89 f8                	mov    %edi,%eax
  80049e:	e8 9f ff ff ff       	call   800442 <printnum>
  8004a3:	83 c4 20             	add    $0x20,%esp
  8004a6:	eb 13                	jmp    8004bb <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	56                   	push   %esi
  8004ac:	ff 75 18             	push   0x18(%ebp)
  8004af:	ff d7                	call   *%edi
  8004b1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b4:	83 eb 01             	sub    $0x1,%ebx
  8004b7:	85 db                	test   %ebx,%ebx
  8004b9:	7f ed                	jg     8004a8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	56                   	push   %esi
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	ff 75 e4             	push   -0x1c(%ebp)
  8004c5:	ff 75 e0             	push   -0x20(%ebp)
  8004c8:	ff 75 dc             	push   -0x24(%ebp)
  8004cb:	ff 75 d8             	push   -0x28(%ebp)
  8004ce:	e8 8d 0a 00 00       	call   800f60 <__umoddi3>
  8004d3:	83 c4 14             	add    $0x14,%esp
  8004d6:	0f be 80 e7 10 80 00 	movsbl 0x8010e7(%eax),%eax
  8004dd:	50                   	push   %eax
  8004de:	ff d7                	call   *%edi
}
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e6:	5b                   	pop    %ebx
  8004e7:	5e                   	pop    %esi
  8004e8:	5f                   	pop    %edi
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f5:	8b 10                	mov    (%eax),%edx
  8004f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fa:	73 0a                	jae    800506 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ff:	89 08                	mov    %ecx,(%eax)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	88 02                	mov    %al,(%edx)
}
  800506:	5d                   	pop    %ebp
  800507:	c3                   	ret    

00800508 <printfmt>:
{
  800508:	55                   	push   %ebp
  800509:	89 e5                	mov    %esp,%ebp
  80050b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800511:	50                   	push   %eax
  800512:	ff 75 10             	push   0x10(%ebp)
  800515:	ff 75 0c             	push   0xc(%ebp)
  800518:	ff 75 08             	push   0x8(%ebp)
  80051b:	e8 05 00 00 00       	call   800525 <vprintfmt>
}
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <vprintfmt>:
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	57                   	push   %edi
  800529:	56                   	push   %esi
  80052a:	53                   	push   %ebx
  80052b:	83 ec 3c             	sub    $0x3c,%esp
  80052e:	8b 75 08             	mov    0x8(%ebp),%esi
  800531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800534:	8b 7d 10             	mov    0x10(%ebp),%edi
  800537:	eb 0a                	jmp    800543 <vprintfmt+0x1e>
			putch(ch, putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	53                   	push   %ebx
  80053d:	50                   	push   %eax
  80053e:	ff d6                	call   *%esi
  800540:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	83 c7 01             	add    $0x1,%edi
  800546:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054a:	83 f8 25             	cmp    $0x25,%eax
  80054d:	74 0c                	je     80055b <vprintfmt+0x36>
			if (ch == '\0')
  80054f:	85 c0                	test   %eax,%eax
  800551:	75 e6                	jne    800539 <vprintfmt+0x14>
}
  800553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800556:	5b                   	pop    %ebx
  800557:	5e                   	pop    %esi
  800558:	5f                   	pop    %edi
  800559:	5d                   	pop    %ebp
  80055a:	c3                   	ret    
		padc = ' ';
  80055b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80055f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800566:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80056d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800574:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800579:	8d 47 01             	lea    0x1(%edi),%eax
  80057c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80057f:	0f b6 17             	movzbl (%edi),%edx
  800582:	8d 42 dd             	lea    -0x23(%edx),%eax
  800585:	3c 55                	cmp    $0x55,%al
  800587:	0f 87 a6 04 00 00    	ja     800a33 <vprintfmt+0x50e>
  80058d:	0f b6 c0             	movzbl %al,%eax
  800590:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  800597:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80059a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80059e:	eb d9                	jmp    800579 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005a3:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005a7:	eb d0                	jmp    800579 <vprintfmt+0x54>
  8005a9:	0f b6 d2             	movzbl %dl,%edx
  8005ac:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005af:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ba:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005be:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005c1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c4:	83 f9 09             	cmp    $0x9,%ecx
  8005c7:	77 55                	ja     80061e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005c9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005cc:	eb e9                	jmp    8005b7 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005e6:	79 91                	jns    800579 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005f5:	eb 82                	jmp    800579 <vprintfmt+0x54>
  8005f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fa:	85 d2                	test   %edx,%edx
  8005fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800601:	0f 49 c2             	cmovns %edx,%eax
  800604:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800607:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80060a:	e9 6a ff ff ff       	jmp    800579 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80060f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800612:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800619:	e9 5b ff ff ff       	jmp    800579 <vprintfmt+0x54>
  80061e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800621:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800624:	eb bc                	jmp    8005e2 <vprintfmt+0xbd>
			lflag++;
  800626:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800629:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80062c:	e9 48 ff ff ff       	jmp    800579 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 78 04             	lea    0x4(%eax),%edi
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	ff 30                	push   (%eax)
  80063d:	ff d6                	call   *%esi
			break;
  80063f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800642:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800645:	e9 88 03 00 00       	jmp    8009d2 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 78 04             	lea    0x4(%eax),%edi
  800650:	8b 10                	mov    (%eax),%edx
  800652:	89 d0                	mov    %edx,%eax
  800654:	f7 d8                	neg    %eax
  800656:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800659:	83 f8 0f             	cmp    $0xf,%eax
  80065c:	7f 23                	jg     800681 <vprintfmt+0x15c>
  80065e:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800665:	85 d2                	test   %edx,%edx
  800667:	74 18                	je     800681 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800669:	52                   	push   %edx
  80066a:	68 08 11 80 00       	push   $0x801108
  80066f:	53                   	push   %ebx
  800670:	56                   	push   %esi
  800671:	e8 92 fe ff ff       	call   800508 <printfmt>
  800676:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800679:	89 7d 14             	mov    %edi,0x14(%ebp)
  80067c:	e9 51 03 00 00       	jmp    8009d2 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800681:	50                   	push   %eax
  800682:	68 ff 10 80 00       	push   $0x8010ff
  800687:	53                   	push   %ebx
  800688:	56                   	push   %esi
  800689:	e8 7a fe ff ff       	call   800508 <printfmt>
  80068e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800691:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800694:	e9 39 03 00 00       	jmp    8009d2 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	83 c0 04             	add    $0x4,%eax
  80069f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006a7:	85 d2                	test   %edx,%edx
  8006a9:	b8 f8 10 80 00       	mov    $0x8010f8,%eax
  8006ae:	0f 45 c2             	cmovne %edx,%eax
  8006b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b8:	7e 06                	jle    8006c0 <vprintfmt+0x19b>
  8006ba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006be:	75 0d                	jne    8006cd <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c3:	89 c7                	mov    %eax,%edi
  8006c5:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006cb:	eb 55                	jmp    800722 <vprintfmt+0x1fd>
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 e0             	push   -0x20(%ebp)
  8006d3:	ff 75 cc             	push   -0x34(%ebp)
  8006d6:	e8 f5 03 00 00       	call   800ad0 <strnlen>
  8006db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006de:	29 c2                	sub    %eax,%edx
  8006e0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006e8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ef:	eb 0f                	jmp    800700 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	ff 75 d4             	push   -0x2c(%ebp)
  8006f8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fa:	83 ef 01             	sub    $0x1,%edi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 ff                	test   %edi,%edi
  800702:	7f ed                	jg     8006f1 <vprintfmt+0x1cc>
  800704:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800707:	85 d2                	test   %edx,%edx
  800709:	b8 00 00 00 00       	mov    $0x0,%eax
  80070e:	0f 49 c2             	cmovns %edx,%eax
  800711:	29 c2                	sub    %eax,%edx
  800713:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800716:	eb a8                	jmp    8006c0 <vprintfmt+0x19b>
					putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	52                   	push   %edx
  80071d:	ff d6                	call   *%esi
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800725:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800727:	83 c7 01             	add    $0x1,%edi
  80072a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072e:	0f be d0             	movsbl %al,%edx
  800731:	85 d2                	test   %edx,%edx
  800733:	74 4b                	je     800780 <vprintfmt+0x25b>
  800735:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800739:	78 06                	js     800741 <vprintfmt+0x21c>
  80073b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80073f:	78 1e                	js     80075f <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800741:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800745:	74 d1                	je     800718 <vprintfmt+0x1f3>
  800747:	0f be c0             	movsbl %al,%eax
  80074a:	83 e8 20             	sub    $0x20,%eax
  80074d:	83 f8 5e             	cmp    $0x5e,%eax
  800750:	76 c6                	jbe    800718 <vprintfmt+0x1f3>
					putch('?', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 3f                	push   $0x3f
  800758:	ff d6                	call   *%esi
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	eb c3                	jmp    800722 <vprintfmt+0x1fd>
  80075f:	89 cf                	mov    %ecx,%edi
  800761:	eb 0e                	jmp    800771 <vprintfmt+0x24c>
				putch(' ', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	53                   	push   %ebx
  800767:	6a 20                	push   $0x20
  800769:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80076b:	83 ef 01             	sub    $0x1,%edi
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	85 ff                	test   %edi,%edi
  800773:	7f ee                	jg     800763 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800775:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	e9 52 02 00 00       	jmp    8009d2 <vprintfmt+0x4ad>
  800780:	89 cf                	mov    %ecx,%edi
  800782:	eb ed                	jmp    800771 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	83 c0 04             	add    $0x4,%eax
  80078a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800792:	85 d2                	test   %edx,%edx
  800794:	b8 f8 10 80 00       	mov    $0x8010f8,%eax
  800799:	0f 45 c2             	cmovne %edx,%eax
  80079c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80079f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a3:	7e 06                	jle    8007ab <vprintfmt+0x286>
  8007a5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8007a9:	75 0d                	jne    8007b8 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007ae:	89 c7                	mov    %eax,%edi
  8007b0:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007b6:	eb 55                	jmp    80080d <vprintfmt+0x2e8>
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 e0             	push   -0x20(%ebp)
  8007be:	ff 75 cc             	push   -0x34(%ebp)
  8007c1:	e8 0a 03 00 00       	call   800ad0 <strnlen>
  8007c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007c9:	29 c2                	sub    %eax,%edx
  8007cb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007d3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007da:	eb 0f                	jmp    8007eb <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	ff 75 d4             	push   -0x2c(%ebp)
  8007e3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e5:	83 ef 01             	sub    $0x1,%edi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	85 ff                	test   %edi,%edi
  8007ed:	7f ed                	jg     8007dc <vprintfmt+0x2b7>
  8007ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f9:	0f 49 c2             	cmovns %edx,%eax
  8007fc:	29 c2                	sub    %eax,%edx
  8007fe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800801:	eb a8                	jmp    8007ab <vprintfmt+0x286>
					putch(ch, putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	52                   	push   %edx
  800808:	ff d6                	call   *%esi
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800810:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800812:	83 c7 01             	add    $0x1,%edi
  800815:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800819:	0f be d0             	movsbl %al,%edx
  80081c:	3c 3a                	cmp    $0x3a,%al
  80081e:	74 4b                	je     80086b <vprintfmt+0x346>
  800820:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800824:	78 06                	js     80082c <vprintfmt+0x307>
  800826:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80082a:	78 1e                	js     80084a <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80082c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800830:	74 d1                	je     800803 <vprintfmt+0x2de>
  800832:	0f be c0             	movsbl %al,%eax
  800835:	83 e8 20             	sub    $0x20,%eax
  800838:	83 f8 5e             	cmp    $0x5e,%eax
  80083b:	76 c6                	jbe    800803 <vprintfmt+0x2de>
					putch('?', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	53                   	push   %ebx
  800841:	6a 3f                	push   $0x3f
  800843:	ff d6                	call   *%esi
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	eb c3                	jmp    80080d <vprintfmt+0x2e8>
  80084a:	89 cf                	mov    %ecx,%edi
  80084c:	eb 0e                	jmp    80085c <vprintfmt+0x337>
				putch(' ', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	53                   	push   %ebx
  800852:	6a 20                	push   $0x20
  800854:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800856:	83 ef 01             	sub    $0x1,%edi
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	85 ff                	test   %edi,%edi
  80085e:	7f ee                	jg     80084e <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800860:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
  800866:	e9 67 01 00 00       	jmp    8009d2 <vprintfmt+0x4ad>
  80086b:	89 cf                	mov    %ecx,%edi
  80086d:	eb ed                	jmp    80085c <vprintfmt+0x337>
	if (lflag >= 2)
  80086f:	83 f9 01             	cmp    $0x1,%ecx
  800872:	7f 1b                	jg     80088f <vprintfmt+0x36a>
	else if (lflag)
  800874:	85 c9                	test   %ecx,%ecx
  800876:	74 63                	je     8008db <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800880:	99                   	cltd   
  800881:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	eb 17                	jmp    8008a6 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 50 04             	mov    0x4(%eax),%edx
  800895:	8b 00                	mov    (%eax),%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80089a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 08             	lea    0x8(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8008a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8008ac:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008b1:	85 c9                	test   %ecx,%ecx
  8008b3:	0f 89 ff 00 00 00    	jns    8009b8 <vprintfmt+0x493>
				putch('-', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 2d                	push   $0x2d
  8008bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8008c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008c7:	f7 da                	neg    %edx
  8008c9:	83 d1 00             	adc    $0x0,%ecx
  8008cc:	f7 d9                	neg    %ecx
  8008ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008d1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d6:	e9 dd 00 00 00       	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e3:	99                   	cltd   
  8008e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 40 04             	lea    0x4(%eax),%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	eb b4                	jmp    8008a6 <vprintfmt+0x381>
	if (lflag >= 2)
  8008f2:	83 f9 01             	cmp    $0x1,%ecx
  8008f5:	7f 1e                	jg     800915 <vprintfmt+0x3f0>
	else if (lflag)
  8008f7:	85 c9                	test   %ecx,%ecx
  8008f9:	74 32                	je     80092d <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	b9 00 00 00 00       	mov    $0x0,%ecx
  800905:	8d 40 04             	lea    0x4(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800910:	e9 a3 00 00 00       	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	8b 48 04             	mov    0x4(%eax),%ecx
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800923:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800928:	e9 8b 00 00 00       	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8b 10                	mov    (%eax),%edx
  800932:	b9 00 00 00 00       	mov    $0x0,%ecx
  800937:	8d 40 04             	lea    0x4(%eax),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80093d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800942:	eb 74                	jmp    8009b8 <vprintfmt+0x493>
	if (lflag >= 2)
  800944:	83 f9 01             	cmp    $0x1,%ecx
  800947:	7f 1b                	jg     800964 <vprintfmt+0x43f>
	else if (lflag)
  800949:	85 c9                	test   %ecx,%ecx
  80094b:	74 2c                	je     800979 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8b 10                	mov    (%eax),%edx
  800952:	b9 00 00 00 00       	mov    $0x0,%ecx
  800957:	8d 40 04             	lea    0x4(%eax),%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800962:	eb 54                	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8b 10                	mov    (%eax),%edx
  800969:	8b 48 04             	mov    0x4(%eax),%ecx
  80096c:	8d 40 08             	lea    0x8(%eax),%eax
  80096f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800972:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800977:	eb 3f                	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	8b 10                	mov    (%eax),%edx
  80097e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800983:	8d 40 04             	lea    0x4(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800989:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80098e:	eb 28                	jmp    8009b8 <vprintfmt+0x493>
			putch('0', putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	53                   	push   %ebx
  800994:	6a 30                	push   $0x30
  800996:	ff d6                	call   *%esi
			putch('x', putdat);
  800998:	83 c4 08             	add    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	6a 78                	push   $0x78
  80099e:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a3:	8b 10                	mov    (%eax),%edx
  8009a5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009aa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009ad:	8d 40 04             	lea    0x4(%eax),%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b3:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009b8:	83 ec 0c             	sub    $0xc,%esp
  8009bb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009bf:	50                   	push   %eax
  8009c0:	ff 75 d4             	push   -0x2c(%ebp)
  8009c3:	57                   	push   %edi
  8009c4:	51                   	push   %ecx
  8009c5:	52                   	push   %edx
  8009c6:	89 da                	mov    %ebx,%edx
  8009c8:	89 f0                	mov    %esi,%eax
  8009ca:	e8 73 fa ff ff       	call   800442 <printnum>
			break;
  8009cf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009d2:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d5:	e9 69 fb ff ff       	jmp    800543 <vprintfmt+0x1e>
	if (lflag >= 2)
  8009da:	83 f9 01             	cmp    $0x1,%ecx
  8009dd:	7f 1b                	jg     8009fa <vprintfmt+0x4d5>
	else if (lflag)
  8009df:	85 c9                	test   %ecx,%ecx
  8009e1:	74 2c                	je     800a0f <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	8b 10                	mov    (%eax),%edx
  8009e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ed:	8d 40 04             	lea    0x4(%eax),%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009f8:	eb be                	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	8b 10                	mov    (%eax),%edx
  8009ff:	8b 48 04             	mov    0x4(%eax),%ecx
  800a02:	8d 40 08             	lea    0x8(%eax),%eax
  800a05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a08:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800a0d:	eb a9                	jmp    8009b8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	8b 10                	mov    (%eax),%edx
  800a14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a19:	8d 40 04             	lea    0x4(%eax),%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a24:	eb 92                	jmp    8009b8 <vprintfmt+0x493>
			putch(ch, putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	53                   	push   %ebx
  800a2a:	6a 25                	push   $0x25
  800a2c:	ff d6                	call   *%esi
			break;
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	eb 9f                	jmp    8009d2 <vprintfmt+0x4ad>
			putch('%', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	53                   	push   %ebx
  800a37:	6a 25                	push   $0x25
  800a39:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a3b:	83 c4 10             	add    $0x10,%esp
  800a3e:	89 f8                	mov    %edi,%eax
  800a40:	eb 03                	jmp    800a45 <vprintfmt+0x520>
  800a42:	83 e8 01             	sub    $0x1,%eax
  800a45:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a49:	75 f7                	jne    800a42 <vprintfmt+0x51d>
  800a4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a4e:	eb 82                	jmp    8009d2 <vprintfmt+0x4ad>

00800a50 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 18             	sub    $0x18,%esp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a63:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a6d:	85 c0                	test   %eax,%eax
  800a6f:	74 26                	je     800a97 <vsnprintf+0x47>
  800a71:	85 d2                	test   %edx,%edx
  800a73:	7e 22                	jle    800a97 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a75:	ff 75 14             	push   0x14(%ebp)
  800a78:	ff 75 10             	push   0x10(%ebp)
  800a7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a7e:	50                   	push   %eax
  800a7f:	68 eb 04 80 00       	push   $0x8004eb
  800a84:	e8 9c fa ff ff       	call   800525 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a92:	83 c4 10             	add    $0x10,%esp
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    
		return -E_INVAL;
  800a97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a9c:	eb f7                	jmp    800a95 <vsnprintf+0x45>

00800a9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aa7:	50                   	push   %eax
  800aa8:	ff 75 10             	push   0x10(%ebp)
  800aab:	ff 75 0c             	push   0xc(%ebp)
  800aae:	ff 75 08             	push   0x8(%ebp)
  800ab1:	e8 9a ff ff ff       	call   800a50 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac3:	eb 03                	jmp    800ac8 <strlen+0x10>
		n++;
  800ac5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ac8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800acc:	75 f7                	jne    800ac5 <strlen+0xd>
	return n;
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	eb 03                	jmp    800ae3 <strnlen+0x13>
		n++;
  800ae0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae3:	39 d0                	cmp    %edx,%eax
  800ae5:	74 08                	je     800aef <strnlen+0x1f>
  800ae7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aeb:	75 f3                	jne    800ae0 <strnlen+0x10>
  800aed:	89 c2                	mov    %eax,%edx
	return n;
}
  800aef:	89 d0                	mov    %edx,%eax
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	53                   	push   %ebx
  800af7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
  800b02:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b06:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b09:	83 c0 01             	add    $0x1,%eax
  800b0c:	84 d2                	test   %dl,%dl
  800b0e:	75 f2                	jne    800b02 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b10:	89 c8                	mov    %ecx,%eax
  800b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 10             	sub    $0x10,%esp
  800b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b21:	53                   	push   %ebx
  800b22:	e8 91 ff ff ff       	call   800ab8 <strlen>
  800b27:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b2a:	ff 75 0c             	push   0xc(%ebp)
  800b2d:	01 d8                	add    %ebx,%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 be ff ff ff       	call   800af3 <strcpy>
	return dst;
}
  800b35:	89 d8                	mov    %ebx,%eax
  800b37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	8b 75 08             	mov    0x8(%ebp),%esi
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	89 f3                	mov    %esi,%ebx
  800b49:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4c:	89 f0                	mov    %esi,%eax
  800b4e:	eb 0f                	jmp    800b5f <strncpy+0x23>
		*dst++ = *src;
  800b50:	83 c0 01             	add    $0x1,%eax
  800b53:	0f b6 0a             	movzbl (%edx),%ecx
  800b56:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b59:	80 f9 01             	cmp    $0x1,%cl
  800b5c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b5f:	39 d8                	cmp    %ebx,%eax
  800b61:	75 ed                	jne    800b50 <strncpy+0x14>
	}
	return ret;
}
  800b63:	89 f0                	mov    %esi,%eax
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 75 08             	mov    0x8(%ebp),%esi
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b74:	8b 55 10             	mov    0x10(%ebp),%edx
  800b77:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b79:	85 d2                	test   %edx,%edx
  800b7b:	74 21                	je     800b9e <strlcpy+0x35>
  800b7d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b81:	89 f2                	mov    %esi,%edx
  800b83:	eb 09                	jmp    800b8e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b85:	83 c1 01             	add    $0x1,%ecx
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b8e:	39 c2                	cmp    %eax,%edx
  800b90:	74 09                	je     800b9b <strlcpy+0x32>
  800b92:	0f b6 19             	movzbl (%ecx),%ebx
  800b95:	84 db                	test   %bl,%bl
  800b97:	75 ec                	jne    800b85 <strlcpy+0x1c>
  800b99:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b9b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9e:	29 f0                	sub    %esi,%eax
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bad:	eb 06                	jmp    800bb5 <strcmp+0x11>
		p++, q++;
  800baf:	83 c1 01             	add    $0x1,%ecx
  800bb2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bb5:	0f b6 01             	movzbl (%ecx),%eax
  800bb8:	84 c0                	test   %al,%al
  800bba:	74 04                	je     800bc0 <strcmp+0x1c>
  800bbc:	3a 02                	cmp    (%edx),%al
  800bbe:	74 ef                	je     800baf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc0:	0f b6 c0             	movzbl %al,%eax
  800bc3:	0f b6 12             	movzbl (%edx),%edx
  800bc6:	29 d0                	sub    %edx,%eax
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	89 c3                	mov    %eax,%ebx
  800bd6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd9:	eb 06                	jmp    800be1 <strncmp+0x17>
		n--, p++, q++;
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800be1:	39 d8                	cmp    %ebx,%eax
  800be3:	74 18                	je     800bfd <strncmp+0x33>
  800be5:	0f b6 08             	movzbl (%eax),%ecx
  800be8:	84 c9                	test   %cl,%cl
  800bea:	74 04                	je     800bf0 <strncmp+0x26>
  800bec:	3a 0a                	cmp    (%edx),%cl
  800bee:	74 eb                	je     800bdb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf0:	0f b6 00             	movzbl (%eax),%eax
  800bf3:	0f b6 12             	movzbl (%edx),%edx
  800bf6:	29 d0                	sub    %edx,%eax
}
  800bf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    
		return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800c02:	eb f4                	jmp    800bf8 <strncmp+0x2e>

00800c04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c0e:	eb 03                	jmp    800c13 <strchr+0xf>
  800c10:	83 c0 01             	add    $0x1,%eax
  800c13:	0f b6 10             	movzbl (%eax),%edx
  800c16:	84 d2                	test   %dl,%dl
  800c18:	74 06                	je     800c20 <strchr+0x1c>
		if (*s == c)
  800c1a:	38 ca                	cmp    %cl,%dl
  800c1c:	75 f2                	jne    800c10 <strchr+0xc>
  800c1e:	eb 05                	jmp    800c25 <strchr+0x21>
			return (char *) s;
	return 0;
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c31:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c34:	38 ca                	cmp    %cl,%dl
  800c36:	74 09                	je     800c41 <strfind+0x1a>
  800c38:	84 d2                	test   %dl,%dl
  800c3a:	74 05                	je     800c41 <strfind+0x1a>
	for (; *s; s++)
  800c3c:	83 c0 01             	add    $0x1,%eax
  800c3f:	eb f0                	jmp    800c31 <strfind+0xa>
			break;
	return (char *) s;
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c4f:	85 c9                	test   %ecx,%ecx
  800c51:	74 2f                	je     800c82 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c53:	89 f8                	mov    %edi,%eax
  800c55:	09 c8                	or     %ecx,%eax
  800c57:	a8 03                	test   $0x3,%al
  800c59:	75 21                	jne    800c7c <memset+0x39>
		c &= 0xFF;
  800c5b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c5f:	89 d0                	mov    %edx,%eax
  800c61:	c1 e0 08             	shl    $0x8,%eax
  800c64:	89 d3                	mov    %edx,%ebx
  800c66:	c1 e3 18             	shl    $0x18,%ebx
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	c1 e6 10             	shl    $0x10,%esi
  800c6e:	09 f3                	or     %esi,%ebx
  800c70:	09 da                	or     %ebx,%edx
  800c72:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c74:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c77:	fc                   	cld    
  800c78:	f3 ab                	rep stos %eax,%es:(%edi)
  800c7a:	eb 06                	jmp    800c82 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	fc                   	cld    
  800c80:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c82:	89 f8                	mov    %edi,%eax
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c97:	39 c6                	cmp    %eax,%esi
  800c99:	73 32                	jae    800ccd <memmove+0x44>
  800c9b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9e:	39 c2                	cmp    %eax,%edx
  800ca0:	76 2b                	jbe    800ccd <memmove+0x44>
		s += n;
		d += n;
  800ca2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca5:	89 d6                	mov    %edx,%esi
  800ca7:	09 fe                	or     %edi,%esi
  800ca9:	09 ce                	or     %ecx,%esi
  800cab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cb1:	75 0e                	jne    800cc1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cb3:	83 ef 04             	sub    $0x4,%edi
  800cb6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cbc:	fd                   	std    
  800cbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbf:	eb 09                	jmp    800cca <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cc1:	83 ef 01             	sub    $0x1,%edi
  800cc4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc7:	fd                   	std    
  800cc8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cca:	fc                   	cld    
  800ccb:	eb 1a                	jmp    800ce7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccd:	89 f2                	mov    %esi,%edx
  800ccf:	09 c2                	or     %eax,%edx
  800cd1:	09 ca                	or     %ecx,%edx
  800cd3:	f6 c2 03             	test   $0x3,%dl
  800cd6:	75 0a                	jne    800ce2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cdb:	89 c7                	mov    %eax,%edi
  800cdd:	fc                   	cld    
  800cde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce0:	eb 05                	jmp    800ce7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ce2:	89 c7                	mov    %eax,%edi
  800ce4:	fc                   	cld    
  800ce5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf1:	ff 75 10             	push   0x10(%ebp)
  800cf4:	ff 75 0c             	push   0xc(%ebp)
  800cf7:	ff 75 08             	push   0x8(%ebp)
  800cfa:	e8 8a ff ff ff       	call   800c89 <memmove>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	89 c6                	mov    %eax,%esi
  800d0e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d11:	eb 06                	jmp    800d19 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d13:	83 c0 01             	add    $0x1,%eax
  800d16:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d19:	39 f0                	cmp    %esi,%eax
  800d1b:	74 14                	je     800d31 <memcmp+0x30>
		if (*s1 != *s2)
  800d1d:	0f b6 08             	movzbl (%eax),%ecx
  800d20:	0f b6 1a             	movzbl (%edx),%ebx
  800d23:	38 d9                	cmp    %bl,%cl
  800d25:	74 ec                	je     800d13 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d27:	0f b6 c1             	movzbl %cl,%eax
  800d2a:	0f b6 db             	movzbl %bl,%ebx
  800d2d:	29 d8                	sub    %ebx,%eax
  800d2f:	eb 05                	jmp    800d36 <memcmp+0x35>
	}

	return 0;
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d43:	89 c2                	mov    %eax,%edx
  800d45:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d48:	eb 03                	jmp    800d4d <memfind+0x13>
  800d4a:	83 c0 01             	add    $0x1,%eax
  800d4d:	39 d0                	cmp    %edx,%eax
  800d4f:	73 04                	jae    800d55 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d51:	38 08                	cmp    %cl,(%eax)
  800d53:	75 f5                	jne    800d4a <memfind+0x10>
			break;
	return (void *) s;
}
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d63:	eb 03                	jmp    800d68 <strtol+0x11>
		s++;
  800d65:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d68:	0f b6 02             	movzbl (%edx),%eax
  800d6b:	3c 20                	cmp    $0x20,%al
  800d6d:	74 f6                	je     800d65 <strtol+0xe>
  800d6f:	3c 09                	cmp    $0x9,%al
  800d71:	74 f2                	je     800d65 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d73:	3c 2b                	cmp    $0x2b,%al
  800d75:	74 2a                	je     800da1 <strtol+0x4a>
	int neg = 0;
  800d77:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d7c:	3c 2d                	cmp    $0x2d,%al
  800d7e:	74 2b                	je     800dab <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d80:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d86:	75 0f                	jne    800d97 <strtol+0x40>
  800d88:	80 3a 30             	cmpb   $0x30,(%edx)
  800d8b:	74 28                	je     800db5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d8d:	85 db                	test   %ebx,%ebx
  800d8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d94:	0f 44 d8             	cmove  %eax,%ebx
  800d97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d9c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9f:	eb 46                	jmp    800de7 <strtol+0x90>
		s++;
  800da1:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800da4:	bf 00 00 00 00       	mov    $0x0,%edi
  800da9:	eb d5                	jmp    800d80 <strtol+0x29>
		s++, neg = 1;
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	bf 01 00 00 00       	mov    $0x1,%edi
  800db3:	eb cb                	jmp    800d80 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db5:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db9:	74 0e                	je     800dc9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dbb:	85 db                	test   %ebx,%ebx
  800dbd:	75 d8                	jne    800d97 <strtol+0x40>
		s++, base = 8;
  800dbf:	83 c2 01             	add    $0x1,%edx
  800dc2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc7:	eb ce                	jmp    800d97 <strtol+0x40>
		s += 2, base = 16;
  800dc9:	83 c2 02             	add    $0x2,%edx
  800dcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dd1:	eb c4                	jmp    800d97 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dd3:	0f be c0             	movsbl %al,%eax
  800dd6:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dd9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ddc:	7d 3a                	jge    800e18 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dde:	83 c2 01             	add    $0x1,%edx
  800de1:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800de5:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800de7:	0f b6 02             	movzbl (%edx),%eax
  800dea:	8d 70 d0             	lea    -0x30(%eax),%esi
  800ded:	89 f3                	mov    %esi,%ebx
  800def:	80 fb 09             	cmp    $0x9,%bl
  800df2:	76 df                	jbe    800dd3 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800df4:	8d 70 9f             	lea    -0x61(%eax),%esi
  800df7:	89 f3                	mov    %esi,%ebx
  800df9:	80 fb 19             	cmp    $0x19,%bl
  800dfc:	77 08                	ja     800e06 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dfe:	0f be c0             	movsbl %al,%eax
  800e01:	83 e8 57             	sub    $0x57,%eax
  800e04:	eb d3                	jmp    800dd9 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e06:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e09:	89 f3                	mov    %esi,%ebx
  800e0b:	80 fb 19             	cmp    $0x19,%bl
  800e0e:	77 08                	ja     800e18 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e10:	0f be c0             	movsbl %al,%eax
  800e13:	83 e8 37             	sub    $0x37,%eax
  800e16:	eb c1                	jmp    800dd9 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 05                	je     800e23 <strtol+0xcc>
		*endptr = (char *) s;
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e23:	89 c8                	mov    %ecx,%eax
  800e25:	f7 d8                	neg    %eax
  800e27:	85 ff                	test   %edi,%edi
  800e29:	0f 45 c8             	cmovne %eax,%ecx
}
  800e2c:	89 c8                	mov    %ecx,%eax
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
  800e33:	66 90                	xchg   %ax,%ax
  800e35:	66 90                	xchg   %ax,%ax
  800e37:	66 90                	xchg   %ax,%ax
  800e39:	66 90                	xchg   %ax,%ax
  800e3b:	66 90                	xchg   %ax,%ax
  800e3d:	66 90                	xchg   %ax,%ax
  800e3f:	90                   	nop

00800e40 <__udivdi3>:
  800e40:	f3 0f 1e fb          	endbr32 
  800e44:	55                   	push   %ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 1c             	sub    $0x1c,%esp
  800e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e53:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	75 19                	jne    800e78 <__udivdi3+0x38>
  800e5f:	39 f3                	cmp    %esi,%ebx
  800e61:	76 4d                	jbe    800eb0 <__udivdi3+0x70>
  800e63:	31 ff                	xor    %edi,%edi
  800e65:	89 e8                	mov    %ebp,%eax
  800e67:	89 f2                	mov    %esi,%edx
  800e69:	f7 f3                	div    %ebx
  800e6b:	89 fa                	mov    %edi,%edx
  800e6d:	83 c4 1c             	add    $0x1c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
  800e75:	8d 76 00             	lea    0x0(%esi),%esi
  800e78:	39 f0                	cmp    %esi,%eax
  800e7a:	76 14                	jbe    800e90 <__udivdi3+0x50>
  800e7c:	31 ff                	xor    %edi,%edi
  800e7e:	31 c0                	xor    %eax,%eax
  800e80:	89 fa                	mov    %edi,%edx
  800e82:	83 c4 1c             	add    $0x1c,%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
  800e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e90:	0f bd f8             	bsr    %eax,%edi
  800e93:	83 f7 1f             	xor    $0x1f,%edi
  800e96:	75 48                	jne    800ee0 <__udivdi3+0xa0>
  800e98:	39 f0                	cmp    %esi,%eax
  800e9a:	72 06                	jb     800ea2 <__udivdi3+0x62>
  800e9c:	31 c0                	xor    %eax,%eax
  800e9e:	39 eb                	cmp    %ebp,%ebx
  800ea0:	77 de                	ja     800e80 <__udivdi3+0x40>
  800ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea7:	eb d7                	jmp    800e80 <__udivdi3+0x40>
  800ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800eb0:	89 d9                	mov    %ebx,%ecx
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	75 0b                	jne    800ec1 <__udivdi3+0x81>
  800eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ebb:	31 d2                	xor    %edx,%edx
  800ebd:	f7 f3                	div    %ebx
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	31 d2                	xor    %edx,%edx
  800ec3:	89 f0                	mov    %esi,%eax
  800ec5:	f7 f1                	div    %ecx
  800ec7:	89 c6                	mov    %eax,%esi
  800ec9:	89 e8                	mov    %ebp,%eax
  800ecb:	89 f7                	mov    %esi,%edi
  800ecd:	f7 f1                	div    %ecx
  800ecf:	89 fa                	mov    %edi,%edx
  800ed1:	83 c4 1c             	add    $0x1c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
  800ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ee0:	89 f9                	mov    %edi,%ecx
  800ee2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ee7:	29 fa                	sub    %edi,%edx
  800ee9:	d3 e0                	shl    %cl,%eax
  800eeb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eef:	89 d1                	mov    %edx,%ecx
  800ef1:	89 d8                	mov    %ebx,%eax
  800ef3:	d3 e8                	shr    %cl,%eax
  800ef5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ef9:	09 c1                	or     %eax,%ecx
  800efb:	89 f0                	mov    %esi,%eax
  800efd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f01:	89 f9                	mov    %edi,%ecx
  800f03:	d3 e3                	shl    %cl,%ebx
  800f05:	89 d1                	mov    %edx,%ecx
  800f07:	d3 e8                	shr    %cl,%eax
  800f09:	89 f9                	mov    %edi,%ecx
  800f0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f0f:	89 eb                	mov    %ebp,%ebx
  800f11:	d3 e6                	shl    %cl,%esi
  800f13:	89 d1                	mov    %edx,%ecx
  800f15:	d3 eb                	shr    %cl,%ebx
  800f17:	09 f3                	or     %esi,%ebx
  800f19:	89 c6                	mov    %eax,%esi
  800f1b:	89 f2                	mov    %esi,%edx
  800f1d:	89 d8                	mov    %ebx,%eax
  800f1f:	f7 74 24 08          	divl   0x8(%esp)
  800f23:	89 d6                	mov    %edx,%esi
  800f25:	89 c3                	mov    %eax,%ebx
  800f27:	f7 64 24 0c          	mull   0xc(%esp)
  800f2b:	39 d6                	cmp    %edx,%esi
  800f2d:	72 19                	jb     800f48 <__udivdi3+0x108>
  800f2f:	89 f9                	mov    %edi,%ecx
  800f31:	d3 e5                	shl    %cl,%ebp
  800f33:	39 c5                	cmp    %eax,%ebp
  800f35:	73 04                	jae    800f3b <__udivdi3+0xfb>
  800f37:	39 d6                	cmp    %edx,%esi
  800f39:	74 0d                	je     800f48 <__udivdi3+0x108>
  800f3b:	89 d8                	mov    %ebx,%eax
  800f3d:	31 ff                	xor    %edi,%edi
  800f3f:	e9 3c ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f4b:	31 ff                	xor    %edi,%edi
  800f4d:	e9 2e ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f52:	66 90                	xchg   %ax,%ax
  800f54:	66 90                	xchg   %ax,%ax
  800f56:	66 90                	xchg   %ax,%ax
  800f58:	66 90                	xchg   %ax,%ax
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__umoddi3>:
  800f60:	f3 0f 1e fb          	endbr32 
  800f64:	55                   	push   %ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 1c             	sub    $0x1c,%esp
  800f6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f73:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f77:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f7b:	89 f0                	mov    %esi,%eax
  800f7d:	89 da                	mov    %ebx,%edx
  800f7f:	85 ff                	test   %edi,%edi
  800f81:	75 15                	jne    800f98 <__umoddi3+0x38>
  800f83:	39 dd                	cmp    %ebx,%ebp
  800f85:	76 39                	jbe    800fc0 <__umoddi3+0x60>
  800f87:	f7 f5                	div    %ebp
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	83 c4 1c             	add    $0x1c,%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	39 df                	cmp    %ebx,%edi
  800f9a:	77 f1                	ja     800f8d <__umoddi3+0x2d>
  800f9c:	0f bd cf             	bsr    %edi,%ecx
  800f9f:	83 f1 1f             	xor    $0x1f,%ecx
  800fa2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fa6:	75 40                	jne    800fe8 <__umoddi3+0x88>
  800fa8:	39 df                	cmp    %ebx,%edi
  800faa:	72 04                	jb     800fb0 <__umoddi3+0x50>
  800fac:	39 f5                	cmp    %esi,%ebp
  800fae:	77 dd                	ja     800f8d <__umoddi3+0x2d>
  800fb0:	89 da                	mov    %ebx,%edx
  800fb2:	89 f0                	mov    %esi,%eax
  800fb4:	29 e8                	sub    %ebp,%eax
  800fb6:	19 fa                	sbb    %edi,%edx
  800fb8:	eb d3                	jmp    800f8d <__umoddi3+0x2d>
  800fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fc0:	89 e9                	mov    %ebp,%ecx
  800fc2:	85 ed                	test   %ebp,%ebp
  800fc4:	75 0b                	jne    800fd1 <__umoddi3+0x71>
  800fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	f7 f5                	div    %ebp
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 d8                	mov    %ebx,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f1                	div    %ecx
  800fd7:	89 f0                	mov    %esi,%eax
  800fd9:	f7 f1                	div    %ecx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	31 d2                	xor    %edx,%edx
  800fdf:	eb ac                	jmp    800f8d <__umoddi3+0x2d>
  800fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fe8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fec:	ba 20 00 00 00       	mov    $0x20,%edx
  800ff1:	29 c2                	sub    %eax,%edx
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	89 e8                	mov    %ebp,%eax
  800ff7:	d3 e7                	shl    %cl,%edi
  800ff9:	89 d1                	mov    %edx,%ecx
  800ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fff:	d3 e8                	shr    %cl,%eax
  801001:	89 c1                	mov    %eax,%ecx
  801003:	8b 44 24 04          	mov    0x4(%esp),%eax
  801007:	09 f9                	or     %edi,%ecx
  801009:	89 df                	mov    %ebx,%edi
  80100b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80100f:	89 c1                	mov    %eax,%ecx
  801011:	d3 e5                	shl    %cl,%ebp
  801013:	89 d1                	mov    %edx,%ecx
  801015:	d3 ef                	shr    %cl,%edi
  801017:	89 c1                	mov    %eax,%ecx
  801019:	89 f0                	mov    %esi,%eax
  80101b:	d3 e3                	shl    %cl,%ebx
  80101d:	89 d1                	mov    %edx,%ecx
  80101f:	89 fa                	mov    %edi,%edx
  801021:	d3 e8                	shr    %cl,%eax
  801023:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801028:	09 d8                	or     %ebx,%eax
  80102a:	f7 74 24 08          	divl   0x8(%esp)
  80102e:	89 d3                	mov    %edx,%ebx
  801030:	d3 e6                	shl    %cl,%esi
  801032:	f7 e5                	mul    %ebp
  801034:	89 c7                	mov    %eax,%edi
  801036:	89 d1                	mov    %edx,%ecx
  801038:	39 d3                	cmp    %edx,%ebx
  80103a:	72 06                	jb     801042 <__umoddi3+0xe2>
  80103c:	75 0e                	jne    80104c <__umoddi3+0xec>
  80103e:	39 c6                	cmp    %eax,%esi
  801040:	73 0a                	jae    80104c <__umoddi3+0xec>
  801042:	29 e8                	sub    %ebp,%eax
  801044:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801048:	89 d1                	mov    %edx,%ecx
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	89 f5                	mov    %esi,%ebp
  80104e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801052:	29 fd                	sub    %edi,%ebp
  801054:	19 cb                	sbb    %ecx,%ebx
  801056:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	d3 e0                	shl    %cl,%eax
  80105f:	89 f1                	mov    %esi,%ecx
  801061:	d3 ed                	shr    %cl,%ebp
  801063:	d3 eb                	shr    %cl,%ebx
  801065:	09 e8                	or     %ebp,%eax
  801067:	89 da                	mov    %ebx,%edx
  801069:	83 c4 1c             	add    $0x1c,%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
