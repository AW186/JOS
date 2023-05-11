
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 32 01 00 00       	call   800179 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 6e 02 00 00       	call   8002c4 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 c6 00 00 00       	call   80013b <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	e8 42 00 00 00       	call   8000fa <sys_env_destroy>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ce:	89 c3                	mov    %eax,%ebx
  8000d0:	89 c7                	mov    %eax,%edi
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_cgetc>:

int
sys_cgetc(void)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000eb:	89 d1                	mov    %edx,%ecx
  8000ed:	89 d3                	mov    %edx,%ebx
  8000ef:	89 d7                	mov    %edx,%edi
  8000f1:	89 d6                	mov    %edx,%esi
  8000f3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f5:	5b                   	pop    %ebx
  8000f6:	5e                   	pop    %esi
  8000f7:	5f                   	pop    %edi
  8000f8:	5d                   	pop    %ebp
  8000f9:	c3                   	ret    

008000fa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800103:	b9 00 00 00 00       	mov    $0x0,%ecx
  800108:	8b 55 08             	mov    0x8(%ebp),%edx
  80010b:	b8 03 00 00 00       	mov    $0x3,%eax
  800110:	89 cb                	mov    %ecx,%ebx
  800112:	89 cf                	mov    %ecx,%edi
  800114:	89 ce                	mov    %ecx,%esi
  800116:	cd 30                	int    $0x30
	if(check && ret > 0)
  800118:	85 c0                	test   %eax,%eax
  80011a:	7f 08                	jg     800124 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	6a 03                	push   $0x3
  80012a:	68 aa 10 80 00       	push   $0x8010aa
  80012f:	6a 23                	push   $0x23
  800131:	68 c7 10 80 00       	push   $0x8010c7
  800136:	e8 2f 02 00 00       	call   80036a <_panic>

0080013b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 02 00 00 00       	mov    $0x2,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_yield>:

void
sys_yield(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	8b 55 08             	mov    0x8(%ebp),%edx
  80018a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018d:	b8 04 00 00 00       	mov    $0x4,%eax
  800192:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800195:	89 f7                	mov    %esi,%edi
  800197:	cd 30                	int    $0x30
	if(check && ret > 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	7f 08                	jg     8001a5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a0:	5b                   	pop    %ebx
  8001a1:	5e                   	pop    %esi
  8001a2:	5f                   	pop    %edi
  8001a3:	5d                   	pop    %ebp
  8001a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	50                   	push   %eax
  8001a9:	6a 04                	push   $0x4
  8001ab:	68 aa 10 80 00       	push   $0x8010aa
  8001b0:	6a 23                	push   $0x23
  8001b2:	68 c7 10 80 00       	push   $0x8010c7
  8001b7:	e8 ae 01 00 00       	call   80036a <_panic>

008001bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	57                   	push   %edi
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	7f 08                	jg     8001e7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	50                   	push   %eax
  8001eb:	6a 05                	push   $0x5
  8001ed:	68 aa 10 80 00       	push   $0x8010aa
  8001f2:	6a 23                	push   $0x23
  8001f4:	68 c7 10 80 00       	push   $0x8010c7
  8001f9:	e8 6c 01 00 00       	call   80036a <_panic>

008001fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800212:	b8 06 00 00 00       	mov    $0x6,%eax
  800217:	89 df                	mov    %ebx,%edi
  800219:	89 de                	mov    %ebx,%esi
  80021b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021d:	85 c0                	test   %eax,%eax
  80021f:	7f 08                	jg     800229 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	50                   	push   %eax
  80022d:	6a 06                	push   $0x6
  80022f:	68 aa 10 80 00       	push   $0x8010aa
  800234:	6a 23                	push   $0x23
  800236:	68 c7 10 80 00       	push   $0x8010c7
  80023b:	e8 2a 01 00 00       	call   80036a <_panic>

00800240 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	b8 08 00 00 00       	mov    $0x8,%eax
  800259:	89 df                	mov    %ebx,%edi
  80025b:	89 de                	mov    %ebx,%esi
  80025d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80025f:	85 c0                	test   %eax,%eax
  800261:	7f 08                	jg     80026b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	6a 08                	push   $0x8
  800271:	68 aa 10 80 00       	push   $0x8010aa
  800276:	6a 23                	push   $0x23
  800278:	68 c7 10 80 00       	push   $0x8010c7
  80027d:	e8 e8 00 00 00       	call   80036a <_panic>

00800282 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	57                   	push   %edi
  800286:	56                   	push   %esi
  800287:	53                   	push   %ebx
  800288:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80028b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800296:	b8 09 00 00 00       	mov    $0x9,%eax
  80029b:	89 df                	mov    %ebx,%edi
  80029d:	89 de                	mov    %ebx,%esi
  80029f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	7f 08                	jg     8002ad <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a8:	5b                   	pop    %ebx
  8002a9:	5e                   	pop    %esi
  8002aa:	5f                   	pop    %edi
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	50                   	push   %eax
  8002b1:	6a 09                	push   $0x9
  8002b3:	68 aa 10 80 00       	push   $0x8010aa
  8002b8:	6a 23                	push   $0x23
  8002ba:	68 c7 10 80 00       	push   $0x8010c7
  8002bf:	e8 a6 00 00 00       	call   80036a <_panic>

008002c4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	57                   	push   %edi
  8002c8:	56                   	push   %esi
  8002c9:	53                   	push   %ebx
  8002ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002dd:	89 df                	mov    %ebx,%edi
  8002df:	89 de                	mov    %ebx,%esi
  8002e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002e3:	85 c0                	test   %eax,%eax
  8002e5:	7f 08                	jg     8002ef <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	50                   	push   %eax
  8002f3:	6a 0a                	push   $0xa
  8002f5:	68 aa 10 80 00       	push   $0x8010aa
  8002fa:	6a 23                	push   $0x23
  8002fc:	68 c7 10 80 00       	push   $0x8010c7
  800301:	e8 64 00 00 00       	call   80036a <_panic>

00800306 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80030c:	8b 55 08             	mov    0x8(%ebp),%edx
  80030f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800312:	b8 0c 00 00 00       	mov    $0xc,%eax
  800317:	be 00 00 00 00       	mov    $0x0,%esi
  80031c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80031f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800322:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800324:	5b                   	pop    %ebx
  800325:	5e                   	pop    %esi
  800326:	5f                   	pop    %edi
  800327:	5d                   	pop    %ebp
  800328:	c3                   	ret    

00800329 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	57                   	push   %edi
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
  80032f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
  800337:	8b 55 08             	mov    0x8(%ebp),%edx
  80033a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80033f:	89 cb                	mov    %ecx,%ebx
  800341:	89 cf                	mov    %ecx,%edi
  800343:	89 ce                	mov    %ecx,%esi
  800345:	cd 30                	int    $0x30
	if(check && ret > 0)
  800347:	85 c0                	test   %eax,%eax
  800349:	7f 08                	jg     800353 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80034b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034e:	5b                   	pop    %ebx
  80034f:	5e                   	pop    %esi
  800350:	5f                   	pop    %edi
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	50                   	push   %eax
  800357:	6a 0d                	push   $0xd
  800359:	68 aa 10 80 00       	push   $0x8010aa
  80035e:	6a 23                	push   $0x23
  800360:	68 c7 10 80 00       	push   $0x8010c7
  800365:	e8 00 00 00 00       	call   80036a <_panic>

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	56                   	push   %esi
  80036e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80036f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800372:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800378:	e8 be fd ff ff       	call   80013b <sys_getenvid>
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	ff 75 0c             	push   0xc(%ebp)
  800383:	ff 75 08             	push   0x8(%ebp)
  800386:	56                   	push   %esi
  800387:	50                   	push   %eax
  800388:	68 d8 10 80 00       	push   $0x8010d8
  80038d:	e8 b3 00 00 00       	call   800445 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	53                   	push   %ebx
  800396:	ff 75 10             	push   0x10(%ebp)
  800399:	e8 56 00 00 00       	call   8003f4 <vcprintf>
	cprintf("\n");
  80039e:	c7 04 24 fb 10 80 00 	movl   $0x8010fb,(%esp)
  8003a5:	e8 9b 00 00 00       	call   800445 <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ad:	cc                   	int3   
  8003ae:	eb fd                	jmp    8003ad <_panic+0x43>

008003b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ba:	8b 13                	mov    (%ebx),%edx
  8003bc:	8d 42 01             	lea    0x1(%edx),%eax
  8003bf:	89 03                	mov    %eax,(%ebx)
  8003c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cd:	74 09                	je     8003d8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	68 ff 00 00 00       	push   $0xff
  8003e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e3:	50                   	push   %eax
  8003e4:	e8 d4 fc ff ff       	call   8000bd <sys_cputs>
		b->idx = 0;
  8003e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	eb db                	jmp    8003cf <putch+0x1f>

008003f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800404:	00 00 00 
	b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800411:	ff 75 0c             	push   0xc(%ebp)
  800414:	ff 75 08             	push   0x8(%ebp)
  800417:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041d:	50                   	push   %eax
  80041e:	68 b0 03 80 00       	push   $0x8003b0
  800423:	e8 14 01 00 00       	call   80053c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800428:	83 c4 08             	add    $0x8,%esp
  80042b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800431:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	e8 80 fc ff ff       	call   8000bd <sys_cputs>

	return b.cnt;
}
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80044b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80044e:	50                   	push   %eax
  80044f:	ff 75 08             	push   0x8(%ebp)
  800452:	e8 9d ff ff ff       	call   8003f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	57                   	push   %edi
  80045d:	56                   	push   %esi
  80045e:	53                   	push   %ebx
  80045f:	83 ec 1c             	sub    $0x1c,%esp
  800462:	89 c7                	mov    %eax,%edi
  800464:	89 d6                	mov    %edx,%esi
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	89 d1                	mov    %edx,%ecx
  80046e:	89 c2                	mov    %eax,%edx
  800470:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800473:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800476:	8b 45 10             	mov    0x10(%ebp),%eax
  800479:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800486:	39 c2                	cmp    %eax,%edx
  800488:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80048b:	72 3e                	jb     8004cb <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff 75 18             	push   0x18(%ebp)
  800493:	83 eb 01             	sub    $0x1,%ebx
  800496:	53                   	push   %ebx
  800497:	50                   	push   %eax
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 e4             	push   -0x1c(%ebp)
  80049e:	ff 75 e0             	push   -0x20(%ebp)
  8004a1:	ff 75 dc             	push   -0x24(%ebp)
  8004a4:	ff 75 d8             	push   -0x28(%ebp)
  8004a7:	e8 a4 09 00 00       	call   800e50 <__udivdi3>
  8004ac:	83 c4 18             	add    $0x18,%esp
  8004af:	52                   	push   %edx
  8004b0:	50                   	push   %eax
  8004b1:	89 f2                	mov    %esi,%edx
  8004b3:	89 f8                	mov    %edi,%eax
  8004b5:	e8 9f ff ff ff       	call   800459 <printnum>
  8004ba:	83 c4 20             	add    $0x20,%esp
  8004bd:	eb 13                	jmp    8004d2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	56                   	push   %esi
  8004c3:	ff 75 18             	push   0x18(%ebp)
  8004c6:	ff d7                	call   *%edi
  8004c8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004cb:	83 eb 01             	sub    $0x1,%ebx
  8004ce:	85 db                	test   %ebx,%ebx
  8004d0:	7f ed                	jg     8004bf <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	56                   	push   %esi
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 e4             	push   -0x1c(%ebp)
  8004dc:	ff 75 e0             	push   -0x20(%ebp)
  8004df:	ff 75 dc             	push   -0x24(%ebp)
  8004e2:	ff 75 d8             	push   -0x28(%ebp)
  8004e5:	e8 86 0a 00 00       	call   800f70 <__umoddi3>
  8004ea:	83 c4 14             	add    $0x14,%esp
  8004ed:	0f be 80 fd 10 80 00 	movsbl 0x8010fd(%eax),%eax
  8004f4:	50                   	push   %eax
  8004f5:	ff d7                	call   *%edi
}
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fd:	5b                   	pop    %ebx
  8004fe:	5e                   	pop    %esi
  8004ff:	5f                   	pop    %edi
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800508:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80050c:	8b 10                	mov    (%eax),%edx
  80050e:	3b 50 04             	cmp    0x4(%eax),%edx
  800511:	73 0a                	jae    80051d <sprintputch+0x1b>
		*b->buf++ = ch;
  800513:	8d 4a 01             	lea    0x1(%edx),%ecx
  800516:	89 08                	mov    %ecx,(%eax)
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	88 02                	mov    %al,(%edx)
}
  80051d:	5d                   	pop    %ebp
  80051e:	c3                   	ret    

0080051f <printfmt>:
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800525:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800528:	50                   	push   %eax
  800529:	ff 75 10             	push   0x10(%ebp)
  80052c:	ff 75 0c             	push   0xc(%ebp)
  80052f:	ff 75 08             	push   0x8(%ebp)
  800532:	e8 05 00 00 00       	call   80053c <vprintfmt>
}
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <vprintfmt>:
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	57                   	push   %edi
  800540:	56                   	push   %esi
  800541:	53                   	push   %ebx
  800542:	83 ec 3c             	sub    $0x3c,%esp
  800545:	8b 75 08             	mov    0x8(%ebp),%esi
  800548:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80054b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80054e:	eb 0a                	jmp    80055a <vprintfmt+0x1e>
			putch(ch, putdat);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	53                   	push   %ebx
  800554:	50                   	push   %eax
  800555:	ff d6                	call   *%esi
  800557:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055a:	83 c7 01             	add    $0x1,%edi
  80055d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800561:	83 f8 25             	cmp    $0x25,%eax
  800564:	74 0c                	je     800572 <vprintfmt+0x36>
			if (ch == '\0')
  800566:	85 c0                	test   %eax,%eax
  800568:	75 e6                	jne    800550 <vprintfmt+0x14>
}
  80056a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80056d:	5b                   	pop    %ebx
  80056e:	5e                   	pop    %esi
  80056f:	5f                   	pop    %edi
  800570:	5d                   	pop    %ebp
  800571:	c3                   	ret    
		padc = ' ';
  800572:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800576:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80057d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800584:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80058b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800590:	8d 47 01             	lea    0x1(%edi),%eax
  800593:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800596:	0f b6 17             	movzbl (%edi),%edx
  800599:	8d 42 dd             	lea    -0x23(%edx),%eax
  80059c:	3c 55                	cmp    $0x55,%al
  80059e:	0f 87 a6 04 00 00    	ja     800a4a <vprintfmt+0x50e>
  8005a4:	0f b6 c0             	movzbl %al,%eax
  8005a7:	ff 24 85 40 12 80 00 	jmp    *0x801240(,%eax,4)
  8005ae:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8005b1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005b5:	eb d9                	jmp    800590 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005b7:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005ba:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005be:	eb d0                	jmp    800590 <vprintfmt+0x54>
  8005c0:	0f b6 d2             	movzbl %dl,%edx
  8005c3:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005d1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005d5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005d8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005db:	83 f9 09             	cmp    $0x9,%ecx
  8005de:	77 55                	ja     800635 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005e0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005e3:	eb e9                	jmp    8005ce <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005fd:	79 91                	jns    800590 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800602:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800605:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80060c:	eb 82                	jmp    800590 <vprintfmt+0x54>
  80060e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800611:	85 d2                	test   %edx,%edx
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	0f 49 c2             	cmovns %edx,%eax
  80061b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80061e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800621:	e9 6a ff ff ff       	jmp    800590 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800626:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800629:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800630:	e9 5b ff ff ff       	jmp    800590 <vprintfmt+0x54>
  800635:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	eb bc                	jmp    8005f9 <vprintfmt+0xbd>
			lflag++;
  80063d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800640:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800643:	e9 48 ff ff ff       	jmp    800590 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 78 04             	lea    0x4(%eax),%edi
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	ff 30                	push   (%eax)
  800654:	ff d6                	call   *%esi
			break;
  800656:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800659:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80065c:	e9 88 03 00 00       	jmp    8009e9 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 78 04             	lea    0x4(%eax),%edi
  800667:	8b 10                	mov    (%eax),%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	f7 d8                	neg    %eax
  80066d:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800670:	83 f8 0f             	cmp    $0xf,%eax
  800673:	7f 23                	jg     800698 <vprintfmt+0x15c>
  800675:	8b 14 85 a0 13 80 00 	mov    0x8013a0(,%eax,4),%edx
  80067c:	85 d2                	test   %edx,%edx
  80067e:	74 18                	je     800698 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800680:	52                   	push   %edx
  800681:	68 1e 11 80 00       	push   $0x80111e
  800686:	53                   	push   %ebx
  800687:	56                   	push   %esi
  800688:	e8 92 fe ff ff       	call   80051f <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800690:	89 7d 14             	mov    %edi,0x14(%ebp)
  800693:	e9 51 03 00 00       	jmp    8009e9 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800698:	50                   	push   %eax
  800699:	68 15 11 80 00       	push   $0x801115
  80069e:	53                   	push   %ebx
  80069f:	56                   	push   %esi
  8006a0:	e8 7a fe ff ff       	call   80051f <printfmt>
  8006a5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006ab:	e9 39 03 00 00       	jmp    8009e9 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	83 c0 04             	add    $0x4,%eax
  8006b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006be:	85 d2                	test   %edx,%edx
  8006c0:	b8 0e 11 80 00       	mov    $0x80110e,%eax
  8006c5:	0f 45 c2             	cmovne %edx,%eax
  8006c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006cf:	7e 06                	jle    8006d7 <vprintfmt+0x19b>
  8006d1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006d5:	75 0d                	jne    8006e4 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006da:	89 c7                	mov    %eax,%edi
  8006dc:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006e2:	eb 55                	jmp    800739 <vprintfmt+0x1fd>
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 e0             	push   -0x20(%ebp)
  8006ea:	ff 75 cc             	push   -0x34(%ebp)
  8006ed:	e8 f5 03 00 00       	call   800ae7 <strnlen>
  8006f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006f5:	29 c2                	sub    %eax,%edx
  8006f7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006ff:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800703:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800706:	eb 0f                	jmp    800717 <vprintfmt+0x1db>
					putch(padc, putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	ff 75 d4             	push   -0x2c(%ebp)
  80070f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	83 ef 01             	sub    $0x1,%edi
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	85 ff                	test   %edi,%edi
  800719:	7f ed                	jg     800708 <vprintfmt+0x1cc>
  80071b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	0f 49 c2             	cmovns %edx,%eax
  800728:	29 c2                	sub    %eax,%edx
  80072a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80072d:	eb a8                	jmp    8006d7 <vprintfmt+0x19b>
					putch(ch, putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	52                   	push   %edx
  800734:	ff d6                	call   *%esi
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80073c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073e:	83 c7 01             	add    $0x1,%edi
  800741:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800745:	0f be d0             	movsbl %al,%edx
  800748:	85 d2                	test   %edx,%edx
  80074a:	74 4b                	je     800797 <vprintfmt+0x25b>
  80074c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800750:	78 06                	js     800758 <vprintfmt+0x21c>
  800752:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800756:	78 1e                	js     800776 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800758:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80075c:	74 d1                	je     80072f <vprintfmt+0x1f3>
  80075e:	0f be c0             	movsbl %al,%eax
  800761:	83 e8 20             	sub    $0x20,%eax
  800764:	83 f8 5e             	cmp    $0x5e,%eax
  800767:	76 c6                	jbe    80072f <vprintfmt+0x1f3>
					putch('?', putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 3f                	push   $0x3f
  80076f:	ff d6                	call   *%esi
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	eb c3                	jmp    800739 <vprintfmt+0x1fd>
  800776:	89 cf                	mov    %ecx,%edi
  800778:	eb 0e                	jmp    800788 <vprintfmt+0x24c>
				putch(' ', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	6a 20                	push   $0x20
  800780:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800782:	83 ef 01             	sub    $0x1,%edi
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	85 ff                	test   %edi,%edi
  80078a:	7f ee                	jg     80077a <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80078c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
  800792:	e9 52 02 00 00       	jmp    8009e9 <vprintfmt+0x4ad>
  800797:	89 cf                	mov    %ecx,%edi
  800799:	eb ed                	jmp    800788 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	83 c0 04             	add    $0x4,%eax
  8007a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	b8 0e 11 80 00       	mov    $0x80110e,%eax
  8007b0:	0f 45 c2             	cmovne %edx,%eax
  8007b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8007b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ba:	7e 06                	jle    8007c2 <vprintfmt+0x286>
  8007bc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8007c0:	75 0d                	jne    8007cf <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007c5:	89 c7                	mov    %eax,%edi
  8007c7:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007cd:	eb 55                	jmp    800824 <vprintfmt+0x2e8>
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 e0             	push   -0x20(%ebp)
  8007d5:	ff 75 cc             	push   -0x34(%ebp)
  8007d8:	e8 0a 03 00 00       	call   800ae7 <strnlen>
  8007dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007e0:	29 c2                	sub    %eax,%edx
  8007e2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007ea:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	eb 0f                	jmp    800802 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	ff 75 d4             	push   -0x2c(%ebp)
  8007fa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fc:	83 ef 01             	sub    $0x1,%edi
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 ff                	test   %edi,%edi
  800804:	7f ed                	jg     8007f3 <vprintfmt+0x2b7>
  800806:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800809:	85 d2                	test   %edx,%edx
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
  800810:	0f 49 c2             	cmovns %edx,%eax
  800813:	29 c2                	sub    %eax,%edx
  800815:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800818:	eb a8                	jmp    8007c2 <vprintfmt+0x286>
					putch(ch, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	52                   	push   %edx
  80081f:	ff d6                	call   *%esi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800827:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800829:	83 c7 01             	add    $0x1,%edi
  80082c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800830:	0f be d0             	movsbl %al,%edx
  800833:	3c 3a                	cmp    $0x3a,%al
  800835:	74 4b                	je     800882 <vprintfmt+0x346>
  800837:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80083b:	78 06                	js     800843 <vprintfmt+0x307>
  80083d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800841:	78 1e                	js     800861 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800843:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800847:	74 d1                	je     80081a <vprintfmt+0x2de>
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 e8 20             	sub    $0x20,%eax
  80084f:	83 f8 5e             	cmp    $0x5e,%eax
  800852:	76 c6                	jbe    80081a <vprintfmt+0x2de>
					putch('?', putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	53                   	push   %ebx
  800858:	6a 3f                	push   $0x3f
  80085a:	ff d6                	call   *%esi
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	eb c3                	jmp    800824 <vprintfmt+0x2e8>
  800861:	89 cf                	mov    %ecx,%edi
  800863:	eb 0e                	jmp    800873 <vprintfmt+0x337>
				putch(' ', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 20                	push   $0x20
  80086b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80086d:	83 ef 01             	sub    $0x1,%edi
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	85 ff                	test   %edi,%edi
  800875:	7f ee                	jg     800865 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800877:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	e9 67 01 00 00       	jmp    8009e9 <vprintfmt+0x4ad>
  800882:	89 cf                	mov    %ecx,%edi
  800884:	eb ed                	jmp    800873 <vprintfmt+0x337>
	if (lflag >= 2)
  800886:	83 f9 01             	cmp    $0x1,%ecx
  800889:	7f 1b                	jg     8008a6 <vprintfmt+0x36a>
	else if (lflag)
  80088b:	85 c9                	test   %ecx,%ecx
  80088d:	74 63                	je     8008f2 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800897:	99                   	cltd   
  800898:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8d 40 04             	lea    0x4(%eax),%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	eb 17                	jmp    8008bd <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 50 04             	mov    0x4(%eax),%edx
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8d 40 08             	lea    0x8(%eax),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8008c3:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008c8:	85 c9                	test   %ecx,%ecx
  8008ca:	0f 89 ff 00 00 00    	jns    8009cf <vprintfmt+0x493>
				putch('-', putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	53                   	push   %ebx
  8008d4:	6a 2d                	push   $0x2d
  8008d6:	ff d6                	call   *%esi
				num = -(long long) num;
  8008d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008de:	f7 da                	neg    %edx
  8008e0:	83 d1 00             	adc    $0x0,%ecx
  8008e3:	f7 d9                	neg    %ecx
  8008e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008e8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ed:	e9 dd 00 00 00       	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008fa:	99                   	cltd   
  8008fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 40 04             	lea    0x4(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	eb b4                	jmp    8008bd <vprintfmt+0x381>
	if (lflag >= 2)
  800909:	83 f9 01             	cmp    $0x1,%ecx
  80090c:	7f 1e                	jg     80092c <vprintfmt+0x3f0>
	else if (lflag)
  80090e:	85 c9                	test   %ecx,%ecx
  800910:	74 32                	je     800944 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8b 10                	mov    (%eax),%edx
  800917:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091c:	8d 40 04             	lea    0x4(%eax),%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800922:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800927:	e9 a3 00 00 00       	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 10                	mov    (%eax),%edx
  800931:	8b 48 04             	mov    0x4(%eax),%ecx
  800934:	8d 40 08             	lea    0x8(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80093a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80093f:	e9 8b 00 00 00       	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8b 10                	mov    (%eax),%edx
  800949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094e:	8d 40 04             	lea    0x4(%eax),%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800954:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800959:	eb 74                	jmp    8009cf <vprintfmt+0x493>
	if (lflag >= 2)
  80095b:	83 f9 01             	cmp    $0x1,%ecx
  80095e:	7f 1b                	jg     80097b <vprintfmt+0x43f>
	else if (lflag)
  800960:	85 c9                	test   %ecx,%ecx
  800962:	74 2c                	je     800990 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8b 10                	mov    (%eax),%edx
  800969:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096e:	8d 40 04             	lea    0x4(%eax),%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800974:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800979:	eb 54                	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8b 10                	mov    (%eax),%edx
  800980:	8b 48 04             	mov    0x4(%eax),%ecx
  800983:	8d 40 08             	lea    0x8(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800989:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80098e:	eb 3f                	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8b 10                	mov    (%eax),%edx
  800995:	b9 00 00 00 00       	mov    $0x0,%ecx
  80099a:	8d 40 04             	lea    0x4(%eax),%eax
  80099d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a0:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8009a5:	eb 28                	jmp    8009cf <vprintfmt+0x493>
			putch('0', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	53                   	push   %ebx
  8009ab:	6a 30                	push   $0x30
  8009ad:	ff d6                	call   *%esi
			putch('x', putdat);
  8009af:	83 c4 08             	add    $0x8,%esp
  8009b2:	53                   	push   %ebx
  8009b3:	6a 78                	push   $0x78
  8009b5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8b 10                	mov    (%eax),%edx
  8009bc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009c4:	8d 40 04             	lea    0x4(%eax),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ca:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009cf:	83 ec 0c             	sub    $0xc,%esp
  8009d2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	ff 75 d4             	push   -0x2c(%ebp)
  8009da:	57                   	push   %edi
  8009db:	51                   	push   %ecx
  8009dc:	52                   	push   %edx
  8009dd:	89 da                	mov    %ebx,%edx
  8009df:	89 f0                	mov    %esi,%eax
  8009e1:	e8 73 fa ff ff       	call   800459 <printnum>
			break;
  8009e6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ec:	e9 69 fb ff ff       	jmp    80055a <vprintfmt+0x1e>
	if (lflag >= 2)
  8009f1:	83 f9 01             	cmp    $0x1,%ecx
  8009f4:	7f 1b                	jg     800a11 <vprintfmt+0x4d5>
	else if (lflag)
  8009f6:	85 c9                	test   %ecx,%ecx
  8009f8:	74 2c                	je     800a26 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	8b 10                	mov    (%eax),%edx
  8009ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a04:	8d 40 04             	lea    0x4(%eax),%eax
  800a07:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0a:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800a0f:	eb be                	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	8b 10                	mov    (%eax),%edx
  800a16:	8b 48 04             	mov    0x4(%eax),%ecx
  800a19:	8d 40 08             	lea    0x8(%eax),%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800a24:	eb a9                	jmp    8009cf <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	8b 10                	mov    (%eax),%edx
  800a2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a30:	8d 40 04             	lea    0x4(%eax),%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a36:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a3b:	eb 92                	jmp    8009cf <vprintfmt+0x493>
			putch(ch, putdat);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	53                   	push   %ebx
  800a41:	6a 25                	push   $0x25
  800a43:	ff d6                	call   *%esi
			break;
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	eb 9f                	jmp    8009e9 <vprintfmt+0x4ad>
			putch('%', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	53                   	push   %ebx
  800a4e:	6a 25                	push   $0x25
  800a50:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 f8                	mov    %edi,%eax
  800a57:	eb 03                	jmp    800a5c <vprintfmt+0x520>
  800a59:	83 e8 01             	sub    $0x1,%eax
  800a5c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a60:	75 f7                	jne    800a59 <vprintfmt+0x51d>
  800a62:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a65:	eb 82                	jmp    8009e9 <vprintfmt+0x4ad>

00800a67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	83 ec 18             	sub    $0x18,%esp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a76:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a84:	85 c0                	test   %eax,%eax
  800a86:	74 26                	je     800aae <vsnprintf+0x47>
  800a88:	85 d2                	test   %edx,%edx
  800a8a:	7e 22                	jle    800aae <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8c:	ff 75 14             	push   0x14(%ebp)
  800a8f:	ff 75 10             	push   0x10(%ebp)
  800a92:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	68 02 05 80 00       	push   $0x800502
  800a9b:	e8 9c fa ff ff       	call   80053c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
}
  800aac:	c9                   	leave  
  800aad:	c3                   	ret    
		return -E_INVAL;
  800aae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab3:	eb f7                	jmp    800aac <vsnprintf+0x45>

00800ab5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800abb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800abe:	50                   	push   %eax
  800abf:	ff 75 10             	push   0x10(%ebp)
  800ac2:	ff 75 0c             	push   0xc(%ebp)
  800ac5:	ff 75 08             	push   0x8(%ebp)
  800ac8:	e8 9a ff ff ff       	call   800a67 <vsnprintf>
	va_end(ap);

	return rc;
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ada:	eb 03                	jmp    800adf <strlen+0x10>
		n++;
  800adc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800adf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ae3:	75 f7                	jne    800adc <strlen+0xd>
	return n;
}
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
  800af5:	eb 03                	jmp    800afa <strnlen+0x13>
		n++;
  800af7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afa:	39 d0                	cmp    %edx,%eax
  800afc:	74 08                	je     800b06 <strnlen+0x1f>
  800afe:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b02:	75 f3                	jne    800af7 <strnlen+0x10>
  800b04:	89 c2                	mov    %eax,%edx
	return n;
}
  800b06:	89 d0                	mov    %edx,%eax
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b1d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	84 d2                	test   %dl,%dl
  800b25:	75 f2                	jne    800b19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b27:	89 c8                	mov    %ecx,%eax
  800b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	53                   	push   %ebx
  800b32:	83 ec 10             	sub    $0x10,%esp
  800b35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b38:	53                   	push   %ebx
  800b39:	e8 91 ff ff ff       	call   800acf <strlen>
  800b3e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b41:	ff 75 0c             	push   0xc(%ebp)
  800b44:	01 d8                	add    %ebx,%eax
  800b46:	50                   	push   %eax
  800b47:	e8 be ff ff ff       	call   800b0a <strcpy>
	return dst;
}
  800b4c:	89 d8                	mov    %ebx,%eax
  800b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 f3                	mov    %esi,%ebx
  800b60:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b63:	89 f0                	mov    %esi,%eax
  800b65:	eb 0f                	jmp    800b76 <strncpy+0x23>
		*dst++ = *src;
  800b67:	83 c0 01             	add    $0x1,%eax
  800b6a:	0f b6 0a             	movzbl (%edx),%ecx
  800b6d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b70:	80 f9 01             	cmp    $0x1,%cl
  800b73:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b76:	39 d8                	cmp    %ebx,%eax
  800b78:	75 ed                	jne    800b67 <strncpy+0x14>
	}
	return ret;
}
  800b7a:	89 f0                	mov    %esi,%eax
  800b7c:	5b                   	pop    %ebx
  800b7d:	5e                   	pop    %esi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
  800b85:	8b 75 08             	mov    0x8(%ebp),%esi
  800b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b8e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b90:	85 d2                	test   %edx,%edx
  800b92:	74 21                	je     800bb5 <strlcpy+0x35>
  800b94:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b98:	89 f2                	mov    %esi,%edx
  800b9a:	eb 09                	jmp    800ba5 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b9c:	83 c1 01             	add    $0x1,%ecx
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800ba5:	39 c2                	cmp    %eax,%edx
  800ba7:	74 09                	je     800bb2 <strlcpy+0x32>
  800ba9:	0f b6 19             	movzbl (%ecx),%ebx
  800bac:	84 db                	test   %bl,%bl
  800bae:	75 ec                	jne    800b9c <strlcpy+0x1c>
  800bb0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bb5:	29 f0                	sub    %esi,%eax
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bc4:	eb 06                	jmp    800bcc <strcmp+0x11>
		p++, q++;
  800bc6:	83 c1 01             	add    $0x1,%ecx
  800bc9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bcc:	0f b6 01             	movzbl (%ecx),%eax
  800bcf:	84 c0                	test   %al,%al
  800bd1:	74 04                	je     800bd7 <strcmp+0x1c>
  800bd3:	3a 02                	cmp    (%edx),%al
  800bd5:	74 ef                	je     800bc6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd7:	0f b6 c0             	movzbl %al,%eax
  800bda:	0f b6 12             	movzbl (%edx),%edx
  800bdd:	29 d0                	sub    %edx,%eax
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	53                   	push   %ebx
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800beb:	89 c3                	mov    %eax,%ebx
  800bed:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bf0:	eb 06                	jmp    800bf8 <strncmp+0x17>
		n--, p++, q++;
  800bf2:	83 c0 01             	add    $0x1,%eax
  800bf5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bf8:	39 d8                	cmp    %ebx,%eax
  800bfa:	74 18                	je     800c14 <strncmp+0x33>
  800bfc:	0f b6 08             	movzbl (%eax),%ecx
  800bff:	84 c9                	test   %cl,%cl
  800c01:	74 04                	je     800c07 <strncmp+0x26>
  800c03:	3a 0a                	cmp    (%edx),%cl
  800c05:	74 eb                	je     800bf2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c07:	0f b6 00             	movzbl (%eax),%eax
  800c0a:	0f b6 12             	movzbl (%edx),%edx
  800c0d:	29 d0                	sub    %edx,%eax
}
  800c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    
		return 0;
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	eb f4                	jmp    800c0f <strncmp+0x2e>

00800c1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c25:	eb 03                	jmp    800c2a <strchr+0xf>
  800c27:	83 c0 01             	add    $0x1,%eax
  800c2a:	0f b6 10             	movzbl (%eax),%edx
  800c2d:	84 d2                	test   %dl,%dl
  800c2f:	74 06                	je     800c37 <strchr+0x1c>
		if (*s == c)
  800c31:	38 ca                	cmp    %cl,%dl
  800c33:	75 f2                	jne    800c27 <strchr+0xc>
  800c35:	eb 05                	jmp    800c3c <strchr+0x21>
			return (char *) s;
	return 0;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c48:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c4b:	38 ca                	cmp    %cl,%dl
  800c4d:	74 09                	je     800c58 <strfind+0x1a>
  800c4f:	84 d2                	test   %dl,%dl
  800c51:	74 05                	je     800c58 <strfind+0x1a>
	for (; *s; s++)
  800c53:	83 c0 01             	add    $0x1,%eax
  800c56:	eb f0                	jmp    800c48 <strfind+0xa>
			break;
	return (char *) s;
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c66:	85 c9                	test   %ecx,%ecx
  800c68:	74 2f                	je     800c99 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c6a:	89 f8                	mov    %edi,%eax
  800c6c:	09 c8                	or     %ecx,%eax
  800c6e:	a8 03                	test   $0x3,%al
  800c70:	75 21                	jne    800c93 <memset+0x39>
		c &= 0xFF;
  800c72:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c76:	89 d0                	mov    %edx,%eax
  800c78:	c1 e0 08             	shl    $0x8,%eax
  800c7b:	89 d3                	mov    %edx,%ebx
  800c7d:	c1 e3 18             	shl    $0x18,%ebx
  800c80:	89 d6                	mov    %edx,%esi
  800c82:	c1 e6 10             	shl    $0x10,%esi
  800c85:	09 f3                	or     %esi,%ebx
  800c87:	09 da                	or     %ebx,%edx
  800c89:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c8b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c8e:	fc                   	cld    
  800c8f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c91:	eb 06                	jmp    800c99 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	fc                   	cld    
  800c97:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c99:	89 f8                	mov    %edi,%eax
  800c9b:	5b                   	pop    %ebx
  800c9c:	5e                   	pop    %esi
  800c9d:	5f                   	pop    %edi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cae:	39 c6                	cmp    %eax,%esi
  800cb0:	73 32                	jae    800ce4 <memmove+0x44>
  800cb2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cb5:	39 c2                	cmp    %eax,%edx
  800cb7:	76 2b                	jbe    800ce4 <memmove+0x44>
		s += n;
		d += n;
  800cb9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cbc:	89 d6                	mov    %edx,%esi
  800cbe:	09 fe                	or     %edi,%esi
  800cc0:	09 ce                	or     %ecx,%esi
  800cc2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cc8:	75 0e                	jne    800cd8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cca:	83 ef 04             	sub    $0x4,%edi
  800ccd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cd0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cd3:	fd                   	std    
  800cd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cd6:	eb 09                	jmp    800ce1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cd8:	83 ef 01             	sub    $0x1,%edi
  800cdb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cde:	fd                   	std    
  800cdf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ce1:	fc                   	cld    
  800ce2:	eb 1a                	jmp    800cfe <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce4:	89 f2                	mov    %esi,%edx
  800ce6:	09 c2                	or     %eax,%edx
  800ce8:	09 ca                	or     %ecx,%edx
  800cea:	f6 c2 03             	test   $0x3,%dl
  800ced:	75 0a                	jne    800cf9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cf2:	89 c7                	mov    %eax,%edi
  800cf4:	fc                   	cld    
  800cf5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf7:	eb 05                	jmp    800cfe <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cf9:	89 c7                	mov    %eax,%edi
  800cfb:	fc                   	cld    
  800cfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d08:	ff 75 10             	push   0x10(%ebp)
  800d0b:	ff 75 0c             	push   0xc(%ebp)
  800d0e:	ff 75 08             	push   0x8(%ebp)
  800d11:	e8 8a ff ff ff       	call   800ca0 <memmove>
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d23:	89 c6                	mov    %eax,%esi
  800d25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d28:	eb 06                	jmp    800d30 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d30:	39 f0                	cmp    %esi,%eax
  800d32:	74 14                	je     800d48 <memcmp+0x30>
		if (*s1 != *s2)
  800d34:	0f b6 08             	movzbl (%eax),%ecx
  800d37:	0f b6 1a             	movzbl (%edx),%ebx
  800d3a:	38 d9                	cmp    %bl,%cl
  800d3c:	74 ec                	je     800d2a <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d3e:	0f b6 c1             	movzbl %cl,%eax
  800d41:	0f b6 db             	movzbl %bl,%ebx
  800d44:	29 d8                	sub    %ebx,%eax
  800d46:	eb 05                	jmp    800d4d <memcmp+0x35>
	}

	return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d5f:	eb 03                	jmp    800d64 <memfind+0x13>
  800d61:	83 c0 01             	add    $0x1,%eax
  800d64:	39 d0                	cmp    %edx,%eax
  800d66:	73 04                	jae    800d6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d68:	38 08                	cmp    %cl,(%eax)
  800d6a:	75 f5                	jne    800d61 <memfind+0x10>
			break;
	return (void *) s;
}
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7a:	eb 03                	jmp    800d7f <strtol+0x11>
		s++;
  800d7c:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d7f:	0f b6 02             	movzbl (%edx),%eax
  800d82:	3c 20                	cmp    $0x20,%al
  800d84:	74 f6                	je     800d7c <strtol+0xe>
  800d86:	3c 09                	cmp    $0x9,%al
  800d88:	74 f2                	je     800d7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d8a:	3c 2b                	cmp    $0x2b,%al
  800d8c:	74 2a                	je     800db8 <strtol+0x4a>
	int neg = 0;
  800d8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d93:	3c 2d                	cmp    $0x2d,%al
  800d95:	74 2b                	je     800dc2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d9d:	75 0f                	jne    800dae <strtol+0x40>
  800d9f:	80 3a 30             	cmpb   $0x30,(%edx)
  800da2:	74 28                	je     800dcc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dab:	0f 44 d8             	cmove  %eax,%ebx
  800dae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800db6:	eb 46                	jmp    800dfe <strtol+0x90>
		s++;
  800db8:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc0:	eb d5                	jmp    800d97 <strtol+0x29>
		s++, neg = 1;
  800dc2:	83 c2 01             	add    $0x1,%edx
  800dc5:	bf 01 00 00 00       	mov    $0x1,%edi
  800dca:	eb cb                	jmp    800d97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dcc:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dd0:	74 0e                	je     800de0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dd2:	85 db                	test   %ebx,%ebx
  800dd4:	75 d8                	jne    800dae <strtol+0x40>
		s++, base = 8;
  800dd6:	83 c2 01             	add    $0x1,%edx
  800dd9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dde:	eb ce                	jmp    800dae <strtol+0x40>
		s += 2, base = 16;
  800de0:	83 c2 02             	add    $0x2,%edx
  800de3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800de8:	eb c4                	jmp    800dae <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800df0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df3:	7d 3a                	jge    800e2f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800df5:	83 c2 01             	add    $0x1,%edx
  800df8:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dfc:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dfe:	0f b6 02             	movzbl (%edx),%eax
  800e01:	8d 70 d0             	lea    -0x30(%eax),%esi
  800e04:	89 f3                	mov    %esi,%ebx
  800e06:	80 fb 09             	cmp    $0x9,%bl
  800e09:	76 df                	jbe    800dea <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800e0b:	8d 70 9f             	lea    -0x61(%eax),%esi
  800e0e:	89 f3                	mov    %esi,%ebx
  800e10:	80 fb 19             	cmp    $0x19,%bl
  800e13:	77 08                	ja     800e1d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 57             	sub    $0x57,%eax
  800e1b:	eb d3                	jmp    800df0 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e1d:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e20:	89 f3                	mov    %esi,%ebx
  800e22:	80 fb 19             	cmp    $0x19,%bl
  800e25:	77 08                	ja     800e2f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e27:	0f be c0             	movsbl %al,%eax
  800e2a:	83 e8 37             	sub    $0x37,%eax
  800e2d:	eb c1                	jmp    800df0 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e33:	74 05                	je     800e3a <strtol+0xcc>
		*endptr = (char *) s;
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e3a:	89 c8                	mov    %ecx,%eax
  800e3c:	f7 d8                	neg    %eax
  800e3e:	85 ff                	test   %edi,%edi
  800e40:	0f 45 c8             	cmovne %eax,%ecx
}
  800e43:	89 c8                	mov    %ecx,%eax
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
  800e4a:	66 90                	xchg   %ax,%ax
  800e4c:	66 90                	xchg   %ax,%ax
  800e4e:	66 90                	xchg   %ax,%ax

00800e50 <__udivdi3>:
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 1c             	sub    $0x1c,%esp
  800e5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e63:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 19                	jne    800e88 <__udivdi3+0x38>
  800e6f:	39 f3                	cmp    %esi,%ebx
  800e71:	76 4d                	jbe    800ec0 <__udivdi3+0x70>
  800e73:	31 ff                	xor    %edi,%edi
  800e75:	89 e8                	mov    %ebp,%eax
  800e77:	89 f2                	mov    %esi,%edx
  800e79:	f7 f3                	div    %ebx
  800e7b:	89 fa                	mov    %edi,%edx
  800e7d:	83 c4 1c             	add    $0x1c,%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
  800e85:	8d 76 00             	lea    0x0(%esi),%esi
  800e88:	39 f0                	cmp    %esi,%eax
  800e8a:	76 14                	jbe    800ea0 <__udivdi3+0x50>
  800e8c:	31 ff                	xor    %edi,%edi
  800e8e:	31 c0                	xor    %eax,%eax
  800e90:	89 fa                	mov    %edi,%edx
  800e92:	83 c4 1c             	add    $0x1c,%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    
  800e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ea0:	0f bd f8             	bsr    %eax,%edi
  800ea3:	83 f7 1f             	xor    $0x1f,%edi
  800ea6:	75 48                	jne    800ef0 <__udivdi3+0xa0>
  800ea8:	39 f0                	cmp    %esi,%eax
  800eaa:	72 06                	jb     800eb2 <__udivdi3+0x62>
  800eac:	31 c0                	xor    %eax,%eax
  800eae:	39 eb                	cmp    %ebp,%ebx
  800eb0:	77 de                	ja     800e90 <__udivdi3+0x40>
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	eb d7                	jmp    800e90 <__udivdi3+0x40>
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 d9                	mov    %ebx,%ecx
  800ec2:	85 db                	test   %ebx,%ebx
  800ec4:	75 0b                	jne    800ed1 <__udivdi3+0x81>
  800ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	f7 f3                	div    %ebx
  800ecf:	89 c1                	mov    %eax,%ecx
  800ed1:	31 d2                	xor    %edx,%edx
  800ed3:	89 f0                	mov    %esi,%eax
  800ed5:	f7 f1                	div    %ecx
  800ed7:	89 c6                	mov    %eax,%esi
  800ed9:	89 e8                	mov    %ebp,%eax
  800edb:	89 f7                	mov    %esi,%edi
  800edd:	f7 f1                	div    %ecx
  800edf:	89 fa                	mov    %edi,%edx
  800ee1:	83 c4 1c             	add    $0x1c,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 f9                	mov    %edi,%ecx
  800ef2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ef7:	29 fa                	sub    %edi,%edx
  800ef9:	d3 e0                	shl    %cl,%eax
  800efb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 d8                	mov    %ebx,%eax
  800f03:	d3 e8                	shr    %cl,%eax
  800f05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f09:	09 c1                	or     %eax,%ecx
  800f0b:	89 f0                	mov    %esi,%eax
  800f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f11:	89 f9                	mov    %edi,%ecx
  800f13:	d3 e3                	shl    %cl,%ebx
  800f15:	89 d1                	mov    %edx,%ecx
  800f17:	d3 e8                	shr    %cl,%eax
  800f19:	89 f9                	mov    %edi,%ecx
  800f1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f1f:	89 eb                	mov    %ebp,%ebx
  800f21:	d3 e6                	shl    %cl,%esi
  800f23:	89 d1                	mov    %edx,%ecx
  800f25:	d3 eb                	shr    %cl,%ebx
  800f27:	09 f3                	or     %esi,%ebx
  800f29:	89 c6                	mov    %eax,%esi
  800f2b:	89 f2                	mov    %esi,%edx
  800f2d:	89 d8                	mov    %ebx,%eax
  800f2f:	f7 74 24 08          	divl   0x8(%esp)
  800f33:	89 d6                	mov    %edx,%esi
  800f35:	89 c3                	mov    %eax,%ebx
  800f37:	f7 64 24 0c          	mull   0xc(%esp)
  800f3b:	39 d6                	cmp    %edx,%esi
  800f3d:	72 19                	jb     800f58 <__udivdi3+0x108>
  800f3f:	89 f9                	mov    %edi,%ecx
  800f41:	d3 e5                	shl    %cl,%ebp
  800f43:	39 c5                	cmp    %eax,%ebp
  800f45:	73 04                	jae    800f4b <__udivdi3+0xfb>
  800f47:	39 d6                	cmp    %edx,%esi
  800f49:	74 0d                	je     800f58 <__udivdi3+0x108>
  800f4b:	89 d8                	mov    %ebx,%eax
  800f4d:	31 ff                	xor    %edi,%edi
  800f4f:	e9 3c ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f5b:	31 ff                	xor    %edi,%edi
  800f5d:	e9 2e ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f62:	66 90                	xchg   %ax,%ax
  800f64:	66 90                	xchg   %ax,%ax
  800f66:	66 90                	xchg   %ax,%ax
  800f68:	66 90                	xchg   %ax,%ax
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__umoddi3>:
  800f70:	f3 0f 1e fb          	endbr32 
  800f74:	55                   	push   %ebp
  800f75:	57                   	push   %edi
  800f76:	56                   	push   %esi
  800f77:	53                   	push   %ebx
  800f78:	83 ec 1c             	sub    $0x1c,%esp
  800f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f83:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f87:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	89 da                	mov    %ebx,%edx
  800f8f:	85 ff                	test   %edi,%edi
  800f91:	75 15                	jne    800fa8 <__umoddi3+0x38>
  800f93:	39 dd                	cmp    %ebx,%ebp
  800f95:	76 39                	jbe    800fd0 <__umoddi3+0x60>
  800f97:	f7 f5                	div    %ebp
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	83 c4 1c             	add    $0x1c,%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	39 df                	cmp    %ebx,%edi
  800faa:	77 f1                	ja     800f9d <__umoddi3+0x2d>
  800fac:	0f bd cf             	bsr    %edi,%ecx
  800faf:	83 f1 1f             	xor    $0x1f,%ecx
  800fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fb6:	75 40                	jne    800ff8 <__umoddi3+0x88>
  800fb8:	39 df                	cmp    %ebx,%edi
  800fba:	72 04                	jb     800fc0 <__umoddi3+0x50>
  800fbc:	39 f5                	cmp    %esi,%ebp
  800fbe:	77 dd                	ja     800f9d <__umoddi3+0x2d>
  800fc0:	89 da                	mov    %ebx,%edx
  800fc2:	89 f0                	mov    %esi,%eax
  800fc4:	29 e8                	sub    %ebp,%eax
  800fc6:	19 fa                	sbb    %edi,%edx
  800fc8:	eb d3                	jmp    800f9d <__umoddi3+0x2d>
  800fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fd0:	89 e9                	mov    %ebp,%ecx
  800fd2:	85 ed                	test   %ebp,%ebp
  800fd4:	75 0b                	jne    800fe1 <__umoddi3+0x71>
  800fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f5                	div    %ebp
  800fdf:	89 c1                	mov    %eax,%ecx
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	31 d2                	xor    %edx,%edx
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 f0                	mov    %esi,%eax
  800fe9:	f7 f1                	div    %ecx
  800feb:	89 d0                	mov    %edx,%eax
  800fed:	31 d2                	xor    %edx,%edx
  800fef:	eb ac                	jmp    800f9d <__umoddi3+0x2d>
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ffc:	ba 20 00 00 00       	mov    $0x20,%edx
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 c1                	mov    %eax,%ecx
  801005:	89 e8                	mov    %ebp,%eax
  801007:	d3 e7                	shl    %cl,%edi
  801009:	89 d1                	mov    %edx,%ecx
  80100b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80100f:	d3 e8                	shr    %cl,%eax
  801011:	89 c1                	mov    %eax,%ecx
  801013:	8b 44 24 04          	mov    0x4(%esp),%eax
  801017:	09 f9                	or     %edi,%ecx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	d3 e5                	shl    %cl,%ebp
  801023:	89 d1                	mov    %edx,%ecx
  801025:	d3 ef                	shr    %cl,%edi
  801027:	89 c1                	mov    %eax,%ecx
  801029:	89 f0                	mov    %esi,%eax
  80102b:	d3 e3                	shl    %cl,%ebx
  80102d:	89 d1                	mov    %edx,%ecx
  80102f:	89 fa                	mov    %edi,%edx
  801031:	d3 e8                	shr    %cl,%eax
  801033:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801038:	09 d8                	or     %ebx,%eax
  80103a:	f7 74 24 08          	divl   0x8(%esp)
  80103e:	89 d3                	mov    %edx,%ebx
  801040:	d3 e6                	shl    %cl,%esi
  801042:	f7 e5                	mul    %ebp
  801044:	89 c7                	mov    %eax,%edi
  801046:	89 d1                	mov    %edx,%ecx
  801048:	39 d3                	cmp    %edx,%ebx
  80104a:	72 06                	jb     801052 <__umoddi3+0xe2>
  80104c:	75 0e                	jne    80105c <__umoddi3+0xec>
  80104e:	39 c6                	cmp    %eax,%esi
  801050:	73 0a                	jae    80105c <__umoddi3+0xec>
  801052:	29 e8                	sub    %ebp,%eax
  801054:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	89 c7                	mov    %eax,%edi
  80105c:	89 f5                	mov    %esi,%ebp
  80105e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801062:	29 fd                	sub    %edi,%ebp
  801064:	19 cb                	sbb    %ecx,%ebx
  801066:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80106b:	89 d8                	mov    %ebx,%eax
  80106d:	d3 e0                	shl    %cl,%eax
  80106f:	89 f1                	mov    %esi,%ecx
  801071:	d3 ed                	shr    %cl,%ebp
  801073:	d3 eb                	shr    %cl,%ebx
  801075:	09 e8                	or     %ebp,%eax
  801077:	89 da                	mov    %ebx,%edx
  801079:	83 c4 1c             	add    $0x1c,%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
