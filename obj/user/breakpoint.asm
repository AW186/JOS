
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800040:	e8 c6 00 00 00       	call   80010b <sys_getenvid>
  800045:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80004d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800052:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800057:	85 db                	test   %ebx,%ebx
  800059:	7e 07                	jle    800062 <libmain+0x2d>
		binaryname = argv[0];
  80005b:	8b 06                	mov    (%esi),%eax
  80005d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	56                   	push   %esi
  800066:	53                   	push   %ebx
  800067:	e8 c7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006c:	e8 0a 00 00 00       	call   80007b <exit>
}
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800077:	5b                   	pop    %ebx
  800078:	5e                   	pop    %esi
  800079:	5d                   	pop    %ebp
  80007a:	c3                   	ret    

0080007b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800081:	6a 00                	push   $0x0
  800083:	e8 42 00 00 00       	call   8000ca <sys_env_destroy>
}
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    

0080008d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	57                   	push   %edi
  800091:	56                   	push   %esi
  800092:	53                   	push   %ebx
	asm volatile("int %1\n"
  800093:	b8 00 00 00 00       	mov    $0x0,%eax
  800098:	8b 55 08             	mov    0x8(%ebp),%edx
  80009b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80009e:	89 c3                	mov    %eax,%ebx
  8000a0:	89 c7                	mov    %eax,%edi
  8000a2:	89 c6                	mov    %eax,%esi
  8000a4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000a6:	5b                   	pop    %ebx
  8000a7:	5e                   	pop    %esi
  8000a8:	5f                   	pop    %edi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	57                   	push   %edi
  8000af:	56                   	push   %esi
  8000b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bb:	89 d1                	mov    %edx,%ecx
  8000bd:	89 d3                	mov    %edx,%ebx
  8000bf:	89 d7                	mov    %edx,%edi
  8000c1:	89 d6                	mov    %edx,%esi
  8000c3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
  8000d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000db:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e0:	89 cb                	mov    %ecx,%ebx
  8000e2:	89 cf                	mov    %ecx,%edi
  8000e4:	89 ce                	mov    %ecx,%esi
  8000e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	7f 08                	jg     8000f4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	6a 03                	push   $0x3
  8000fa:	68 6a 10 80 00       	push   $0x80106a
  8000ff:	6a 23                	push   $0x23
  800101:	68 87 10 80 00       	push   $0x801087
  800106:	e8 2f 02 00 00       	call   80033a <_panic>

0080010b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
	asm volatile("int %1\n"
  800111:	ba 00 00 00 00       	mov    $0x0,%edx
  800116:	b8 02 00 00 00       	mov    $0x2,%eax
  80011b:	89 d1                	mov    %edx,%ecx
  80011d:	89 d3                	mov    %edx,%ebx
  80011f:	89 d7                	mov    %edx,%edi
  800121:	89 d6                	mov    %edx,%esi
  800123:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5f                   	pop    %edi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <sys_yield>:

void
sys_yield(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
  80014f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800152:	be 00 00 00 00       	mov    $0x0,%esi
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
  80015a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015d:	b8 04 00 00 00       	mov    $0x4,%eax
  800162:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800165:	89 f7                	mov    %esi,%edi
  800167:	cd 30                	int    $0x30
	if(check && ret > 0)
  800169:	85 c0                	test   %eax,%eax
  80016b:	7f 08                	jg     800175 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80016d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800170:	5b                   	pop    %ebx
  800171:	5e                   	pop    %esi
  800172:	5f                   	pop    %edi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	50                   	push   %eax
  800179:	6a 04                	push   $0x4
  80017b:	68 6a 10 80 00       	push   $0x80106a
  800180:	6a 23                	push   $0x23
  800182:	68 87 10 80 00       	push   $0x801087
  800187:	e8 ae 01 00 00       	call   80033a <_panic>

0080018c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	57                   	push   %edi
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019b:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001a9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ab:	85 c0                	test   %eax,%eax
  8001ad:	7f 08                	jg     8001b7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	50                   	push   %eax
  8001bb:	6a 05                	push   $0x5
  8001bd:	68 6a 10 80 00       	push   $0x80106a
  8001c2:	6a 23                	push   $0x23
  8001c4:	68 87 10 80 00       	push   $0x801087
  8001c9:	e8 6c 01 00 00       	call   80033a <_panic>

008001ce <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	57                   	push   %edi
  8001d2:	56                   	push   %esi
  8001d3:	53                   	push   %ebx
  8001d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e7:	89 df                	mov    %ebx,%edi
  8001e9:	89 de                	mov    %ebx,%esi
  8001eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ed:	85 c0                	test   %eax,%eax
  8001ef:	7f 08                	jg     8001f9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5e                   	pop    %esi
  8001f6:	5f                   	pop    %edi
  8001f7:	5d                   	pop    %ebp
  8001f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	50                   	push   %eax
  8001fd:	6a 06                	push   $0x6
  8001ff:	68 6a 10 80 00       	push   $0x80106a
  800204:	6a 23                	push   $0x23
  800206:	68 87 10 80 00       	push   $0x801087
  80020b:	e8 2a 01 00 00       	call   80033a <_panic>

00800210 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800219:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021e:	8b 55 08             	mov    0x8(%ebp),%edx
  800221:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800224:	b8 08 00 00 00       	mov    $0x8,%eax
  800229:	89 df                	mov    %ebx,%edi
  80022b:	89 de                	mov    %ebx,%esi
  80022d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022f:	85 c0                	test   %eax,%eax
  800231:	7f 08                	jg     80023b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800233:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800236:	5b                   	pop    %ebx
  800237:	5e                   	pop    %esi
  800238:	5f                   	pop    %edi
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	50                   	push   %eax
  80023f:	6a 08                	push   $0x8
  800241:	68 6a 10 80 00       	push   $0x80106a
  800246:	6a 23                	push   $0x23
  800248:	68 87 10 80 00       	push   $0x801087
  80024d:	e8 e8 00 00 00       	call   80033a <_panic>

00800252 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800260:	8b 55 08             	mov    0x8(%ebp),%edx
  800263:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800266:	b8 09 00 00 00       	mov    $0x9,%eax
  80026b:	89 df                	mov    %ebx,%edi
  80026d:	89 de                	mov    %ebx,%esi
  80026f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800271:	85 c0                	test   %eax,%eax
  800273:	7f 08                	jg     80027d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	50                   	push   %eax
  800281:	6a 09                	push   $0x9
  800283:	68 6a 10 80 00       	push   $0x80106a
  800288:	6a 23                	push   $0x23
  80028a:	68 87 10 80 00       	push   $0x801087
  80028f:	e8 a6 00 00 00       	call   80033a <_panic>

00800294 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80029d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ad:	89 df                	mov    %ebx,%edi
  8002af:	89 de                	mov    %ebx,%esi
  8002b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b3:	85 c0                	test   %eax,%eax
  8002b5:	7f 08                	jg     8002bf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ba:	5b                   	pop    %ebx
  8002bb:	5e                   	pop    %esi
  8002bc:	5f                   	pop    %edi
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	50                   	push   %eax
  8002c3:	6a 0a                	push   $0xa
  8002c5:	68 6a 10 80 00       	push   $0x80106a
  8002ca:	6a 23                	push   $0x23
  8002cc:	68 87 10 80 00       	push   $0x801087
  8002d1:	e8 64 00 00 00       	call   80033a <_panic>

008002d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	57                   	push   %edi
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e7:	be 00 00 00 00       	mov    $0x0,%esi
  8002ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f4:	5b                   	pop    %ebx
  8002f5:	5e                   	pop    %esi
  8002f6:	5f                   	pop    %edi
  8002f7:	5d                   	pop    %ebp
  8002f8:	c3                   	ret    

008002f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	57                   	push   %edi
  8002fd:	56                   	push   %esi
  8002fe:	53                   	push   %ebx
  8002ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	8b 55 08             	mov    0x8(%ebp),%edx
  80030a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80030f:	89 cb                	mov    %ecx,%ebx
  800311:	89 cf                	mov    %ecx,%edi
  800313:	89 ce                	mov    %ecx,%esi
  800315:	cd 30                	int    $0x30
	if(check && ret > 0)
  800317:	85 c0                	test   %eax,%eax
  800319:	7f 08                	jg     800323 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80031b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5e                   	pop    %esi
  800320:	5f                   	pop    %edi
  800321:	5d                   	pop    %ebp
  800322:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	50                   	push   %eax
  800327:	6a 0d                	push   $0xd
  800329:	68 6a 10 80 00       	push   $0x80106a
  80032e:	6a 23                	push   $0x23
  800330:	68 87 10 80 00       	push   $0x801087
  800335:	e8 00 00 00 00       	call   80033a <_panic>

0080033a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800342:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800348:	e8 be fd ff ff       	call   80010b <sys_getenvid>
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	ff 75 0c             	push   0xc(%ebp)
  800353:	ff 75 08             	push   0x8(%ebp)
  800356:	56                   	push   %esi
  800357:	50                   	push   %eax
  800358:	68 98 10 80 00       	push   $0x801098
  80035d:	e8 b3 00 00 00       	call   800415 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800362:	83 c4 18             	add    $0x18,%esp
  800365:	53                   	push   %ebx
  800366:	ff 75 10             	push   0x10(%ebp)
  800369:	e8 56 00 00 00       	call   8003c4 <vcprintf>
	cprintf("\n");
  80036e:	c7 04 24 bb 10 80 00 	movl   $0x8010bb,(%esp)
  800375:	e8 9b 00 00 00       	call   800415 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037d:	cc                   	int3   
  80037e:	eb fd                	jmp    80037d <_panic+0x43>

00800380 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	53                   	push   %ebx
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038a:	8b 13                	mov    (%ebx),%edx
  80038c:	8d 42 01             	lea    0x1(%edx),%eax
  80038f:	89 03                	mov    %eax,(%ebx)
  800391:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800394:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800398:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039d:	74 09                	je     8003a8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80039f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	68 ff 00 00 00       	push   $0xff
  8003b0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b3:	50                   	push   %eax
  8003b4:	e8 d4 fc ff ff       	call   80008d <sys_cputs>
		b->idx = 0;
  8003b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	eb db                	jmp    80039f <putch+0x1f>

008003c4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d4:	00 00 00 
	b.cnt = 0;
  8003d7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003de:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e1:	ff 75 0c             	push   0xc(%ebp)
  8003e4:	ff 75 08             	push   0x8(%ebp)
  8003e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ed:	50                   	push   %eax
  8003ee:	68 80 03 80 00       	push   $0x800380
  8003f3:	e8 14 01 00 00       	call   80050c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f8:	83 c4 08             	add    $0x8,%esp
  8003fb:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800401:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800407:	50                   	push   %eax
  800408:	e8 80 fc ff ff       	call   80008d <sys_cputs>

	return b.cnt;
}
  80040d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80041b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80041e:	50                   	push   %eax
  80041f:	ff 75 08             	push   0x8(%ebp)
  800422:	e8 9d ff ff ff       	call   8003c4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	57                   	push   %edi
  80042d:	56                   	push   %esi
  80042e:	53                   	push   %ebx
  80042f:	83 ec 1c             	sub    $0x1c,%esp
  800432:	89 c7                	mov    %eax,%edi
  800434:	89 d6                	mov    %edx,%esi
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043c:	89 d1                	mov    %edx,%ecx
  80043e:	89 c2                	mov    %eax,%edx
  800440:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800443:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800446:	8b 45 10             	mov    0x10(%ebp),%eax
  800449:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80044c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800456:	39 c2                	cmp    %eax,%edx
  800458:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80045b:	72 3e                	jb     80049b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045d:	83 ec 0c             	sub    $0xc,%esp
  800460:	ff 75 18             	push   0x18(%ebp)
  800463:	83 eb 01             	sub    $0x1,%ebx
  800466:	53                   	push   %ebx
  800467:	50                   	push   %eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	ff 75 e4             	push   -0x1c(%ebp)
  80046e:	ff 75 e0             	push   -0x20(%ebp)
  800471:	ff 75 dc             	push   -0x24(%ebp)
  800474:	ff 75 d8             	push   -0x28(%ebp)
  800477:	e8 a4 09 00 00       	call   800e20 <__udivdi3>
  80047c:	83 c4 18             	add    $0x18,%esp
  80047f:	52                   	push   %edx
  800480:	50                   	push   %eax
  800481:	89 f2                	mov    %esi,%edx
  800483:	89 f8                	mov    %edi,%eax
  800485:	e8 9f ff ff ff       	call   800429 <printnum>
  80048a:	83 c4 20             	add    $0x20,%esp
  80048d:	eb 13                	jmp    8004a2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	56                   	push   %esi
  800493:	ff 75 18             	push   0x18(%ebp)
  800496:	ff d7                	call   *%edi
  800498:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80049b:	83 eb 01             	sub    $0x1,%ebx
  80049e:	85 db                	test   %ebx,%ebx
  8004a0:	7f ed                	jg     80048f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	56                   	push   %esi
  8004a6:	83 ec 04             	sub    $0x4,%esp
  8004a9:	ff 75 e4             	push   -0x1c(%ebp)
  8004ac:	ff 75 e0             	push   -0x20(%ebp)
  8004af:	ff 75 dc             	push   -0x24(%ebp)
  8004b2:	ff 75 d8             	push   -0x28(%ebp)
  8004b5:	e8 86 0a 00 00       	call   800f40 <__umoddi3>
  8004ba:	83 c4 14             	add    $0x14,%esp
  8004bd:	0f be 80 bd 10 80 00 	movsbl 0x8010bd(%eax),%eax
  8004c4:	50                   	push   %eax
  8004c5:	ff d7                	call   *%edi
}
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004cd:	5b                   	pop    %ebx
  8004ce:	5e                   	pop    %esi
  8004cf:	5f                   	pop    %edi
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    

008004d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004dc:	8b 10                	mov    (%eax),%edx
  8004de:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e1:	73 0a                	jae    8004ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e6:	89 08                	mov    %ecx,(%eax)
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	88 02                	mov    %al,(%edx)
}
  8004ed:	5d                   	pop    %ebp
  8004ee:	c3                   	ret    

008004ef <printfmt>:
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 10             	push   0x10(%ebp)
  8004fc:	ff 75 0c             	push   0xc(%ebp)
  8004ff:	ff 75 08             	push   0x8(%ebp)
  800502:	e8 05 00 00 00       	call   80050c <vprintfmt>
}
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <vprintfmt>:
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	57                   	push   %edi
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 3c             	sub    $0x3c,%esp
  800515:	8b 75 08             	mov    0x8(%ebp),%esi
  800518:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80051e:	eb 0a                	jmp    80052a <vprintfmt+0x1e>
			putch(ch, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	50                   	push   %eax
  800525:	ff d6                	call   *%esi
  800527:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	83 c7 01             	add    $0x1,%edi
  80052d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800531:	83 f8 25             	cmp    $0x25,%eax
  800534:	74 0c                	je     800542 <vprintfmt+0x36>
			if (ch == '\0')
  800536:	85 c0                	test   %eax,%eax
  800538:	75 e6                	jne    800520 <vprintfmt+0x14>
}
  80053a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053d:	5b                   	pop    %ebx
  80053e:	5e                   	pop    %esi
  80053f:	5f                   	pop    %edi
  800540:	5d                   	pop    %ebp
  800541:	c3                   	ret    
		padc = ' ';
  800542:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800546:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80054d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800554:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80055b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8d 47 01             	lea    0x1(%edi),%eax
  800563:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800566:	0f b6 17             	movzbl (%edi),%edx
  800569:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056c:	3c 55                	cmp    $0x55,%al
  80056e:	0f 87 a6 04 00 00    	ja     800a1a <vprintfmt+0x50e>
  800574:	0f b6 c0             	movzbl %al,%eax
  800577:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  80057e:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800581:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800585:	eb d9                	jmp    800560 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80058a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80058e:	eb d0                	jmp    800560 <vprintfmt+0x54>
  800590:	0f b6 d2             	movzbl %dl,%edx
  800593:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800596:	b8 00 00 00 00       	mov    $0x0,%eax
  80059b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80059e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ab:	83 f9 09             	cmp    $0x9,%ecx
  8005ae:	77 55                	ja     800605 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b3:	eb e9                	jmp    80059e <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005cd:	79 91                	jns    800560 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005dc:	eb 82                	jmp    800560 <vprintfmt+0x54>
  8005de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e1:	85 d2                	test   %edx,%edx
  8005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e8:	0f 49 c2             	cmovns %edx,%eax
  8005eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005f1:	e9 6a ff ff ff       	jmp    800560 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8005f9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800600:	e9 5b ff ff ff       	jmp    800560 <vprintfmt+0x54>
  800605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800608:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060b:	eb bc                	jmp    8005c9 <vprintfmt+0xbd>
			lflag++;
  80060d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800613:	e9 48 ff ff ff       	jmp    800560 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 78 04             	lea    0x4(%eax),%edi
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	ff 30                	push   (%eax)
  800624:	ff d6                	call   *%esi
			break;
  800626:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800629:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062c:	e9 88 03 00 00       	jmp    8009b9 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 78 04             	lea    0x4(%eax),%edi
  800637:	8b 10                	mov    (%eax),%edx
  800639:	89 d0                	mov    %edx,%eax
  80063b:	f7 d8                	neg    %eax
  80063d:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800640:	83 f8 0f             	cmp    $0xf,%eax
  800643:	7f 23                	jg     800668 <vprintfmt+0x15c>
  800645:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  80064c:	85 d2                	test   %edx,%edx
  80064e:	74 18                	je     800668 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800650:	52                   	push   %edx
  800651:	68 de 10 80 00       	push   $0x8010de
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 92 fe ff ff       	call   8004ef <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
  800663:	e9 51 03 00 00       	jmp    8009b9 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800668:	50                   	push   %eax
  800669:	68 d5 10 80 00       	push   $0x8010d5
  80066e:	53                   	push   %ebx
  80066f:	56                   	push   %esi
  800670:	e8 7a fe ff ff       	call   8004ef <printfmt>
  800675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800678:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067b:	e9 39 03 00 00       	jmp    8009b9 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	83 c0 04             	add    $0x4,%eax
  800686:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  800695:	0f 45 c2             	cmovne %edx,%eax
  800698:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80069f:	7e 06                	jle    8006a7 <vprintfmt+0x19b>
  8006a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a5:	75 0d                	jne    8006b4 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006aa:	89 c7                	mov    %eax,%edi
  8006ac:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006b2:	eb 55                	jmp    800709 <vprintfmt+0x1fd>
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 e0             	push   -0x20(%ebp)
  8006ba:	ff 75 cc             	push   -0x34(%ebp)
  8006bd:	e8 f5 03 00 00       	call   800ab7 <strnlen>
  8006c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c5:	29 c2                	sub    %eax,%edx
  8006c7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006cf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	eb 0f                	jmp    8006e7 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	ff 75 d4             	push   -0x2c(%ebp)
  8006df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 ef 01             	sub    $0x1,%edi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	85 ff                	test   %edi,%edi
  8006e9:	7f ed                	jg     8006d8 <vprintfmt+0x1cc>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006fd:	eb a8                	jmp    8006a7 <vprintfmt+0x19b>
					putch(ch, putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	52                   	push   %edx
  800704:	ff d6                	call   *%esi
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80070c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 c7 01             	add    $0x1,%edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	0f be d0             	movsbl %al,%edx
  800718:	85 d2                	test   %edx,%edx
  80071a:	74 4b                	je     800767 <vprintfmt+0x25b>
  80071c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800720:	78 06                	js     800728 <vprintfmt+0x21c>
  800722:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800726:	78 1e                	js     800746 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800728:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80072c:	74 d1                	je     8006ff <vprintfmt+0x1f3>
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 e8 20             	sub    $0x20,%eax
  800734:	83 f8 5e             	cmp    $0x5e,%eax
  800737:	76 c6                	jbe    8006ff <vprintfmt+0x1f3>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 3f                	push   $0x3f
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb c3                	jmp    800709 <vprintfmt+0x1fd>
  800746:	89 cf                	mov    %ecx,%edi
  800748:	eb 0e                	jmp    800758 <vprintfmt+0x24c>
				putch(' ', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 20                	push   $0x20
  800750:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800752:	83 ef 01             	sub    $0x1,%edi
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	85 ff                	test   %edi,%edi
  80075a:	7f ee                	jg     80074a <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	e9 52 02 00 00       	jmp    8009b9 <vprintfmt+0x4ad>
  800767:	89 cf                	mov    %ecx,%edi
  800769:	eb ed                	jmp    800758 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	83 c0 04             	add    $0x4,%eax
  800771:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800779:	85 d2                	test   %edx,%edx
  80077b:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  800780:	0f 45 c2             	cmovne %edx,%eax
  800783:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800786:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078a:	7e 06                	jle    800792 <vprintfmt+0x286>
  80078c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800790:	75 0d                	jne    80079f <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800792:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800795:	89 c7                	mov    %eax,%edi
  800797:	03 45 d4             	add    -0x2c(%ebp),%eax
  80079a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80079d:	eb 55                	jmp    8007f4 <vprintfmt+0x2e8>
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 e0             	push   -0x20(%ebp)
  8007a5:	ff 75 cc             	push   -0x34(%ebp)
  8007a8:	e8 0a 03 00 00       	call   800ab7 <strnlen>
  8007ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b0:	29 c2                	sub    %eax,%edx
  8007b2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007ba:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	eb 0f                	jmp    8007d2 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	ff 75 d4             	push   -0x2c(%ebp)
  8007ca:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cc:	83 ef 01             	sub    $0x1,%edi
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	85 ff                	test   %edi,%edi
  8007d4:	7f ed                	jg     8007c3 <vprintfmt+0x2b7>
  8007d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d9:	85 d2                	test   %edx,%edx
  8007db:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e0:	0f 49 c2             	cmovns %edx,%eax
  8007e3:	29 c2                	sub    %eax,%edx
  8007e5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007e8:	eb a8                	jmp    800792 <vprintfmt+0x286>
					putch(ch, putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	53                   	push   %ebx
  8007ee:	52                   	push   %edx
  8007ef:	ff d6                	call   *%esi
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007f7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8007f9:	83 c7 01             	add    $0x1,%edi
  8007fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800800:	0f be d0             	movsbl %al,%edx
  800803:	3c 3a                	cmp    $0x3a,%al
  800805:	74 4b                	je     800852 <vprintfmt+0x346>
  800807:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80080b:	78 06                	js     800813 <vprintfmt+0x307>
  80080d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800811:	78 1e                	js     800831 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800813:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800817:	74 d1                	je     8007ea <vprintfmt+0x2de>
  800819:	0f be c0             	movsbl %al,%eax
  80081c:	83 e8 20             	sub    $0x20,%eax
  80081f:	83 f8 5e             	cmp    $0x5e,%eax
  800822:	76 c6                	jbe    8007ea <vprintfmt+0x2de>
					putch('?', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	53                   	push   %ebx
  800828:	6a 3f                	push   $0x3f
  80082a:	ff d6                	call   *%esi
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	eb c3                	jmp    8007f4 <vprintfmt+0x2e8>
  800831:	89 cf                	mov    %ecx,%edi
  800833:	eb 0e                	jmp    800843 <vprintfmt+0x337>
				putch(' ', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 20                	push   $0x20
  80083b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80083d:	83 ef 01             	sub    $0x1,%edi
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	85 ff                	test   %edi,%edi
  800845:	7f ee                	jg     800835 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800847:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
  80084d:	e9 67 01 00 00       	jmp    8009b9 <vprintfmt+0x4ad>
  800852:	89 cf                	mov    %ecx,%edi
  800854:	eb ed                	jmp    800843 <vprintfmt+0x337>
	if (lflag >= 2)
  800856:	83 f9 01             	cmp    $0x1,%ecx
  800859:	7f 1b                	jg     800876 <vprintfmt+0x36a>
	else if (lflag)
  80085b:	85 c9                	test   %ecx,%ecx
  80085d:	74 63                	je     8008c2 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800867:	99                   	cltd   
  800868:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
  800874:	eb 17                	jmp    80088d <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8b 50 04             	mov    0x4(%eax),%edx
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800881:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 08             	lea    0x8(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800893:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800898:	85 c9                	test   %ecx,%ecx
  80089a:	0f 89 ff 00 00 00    	jns    80099f <vprintfmt+0x493>
				putch('-', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008ae:	f7 da                	neg    %edx
  8008b0:	83 d1 00             	adc    $0x0,%ecx
  8008b3:	f7 d9                	neg    %ecx
  8008b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008bd:	e9 dd 00 00 00       	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ca:	99                   	cltd   
  8008cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	eb b4                	jmp    80088d <vprintfmt+0x381>
	if (lflag >= 2)
  8008d9:	83 f9 01             	cmp    $0x1,%ecx
  8008dc:	7f 1e                	jg     8008fc <vprintfmt+0x3f0>
	else if (lflag)
  8008de:	85 c9                	test   %ecx,%ecx
  8008e0:	74 32                	je     800914 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 10                	mov    (%eax),%edx
  8008e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f2:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8008f7:	e9 a3 00 00 00       	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8b 10                	mov    (%eax),%edx
  800901:	8b 48 04             	mov    0x4(%eax),%ecx
  800904:	8d 40 08             	lea    0x8(%eax),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090a:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  80090f:	e9 8b 00 00 00       	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8b 10                	mov    (%eax),%edx
  800919:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091e:	8d 40 04             	lea    0x4(%eax),%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800924:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800929:	eb 74                	jmp    80099f <vprintfmt+0x493>
	if (lflag >= 2)
  80092b:	83 f9 01             	cmp    $0x1,%ecx
  80092e:	7f 1b                	jg     80094b <vprintfmt+0x43f>
	else if (lflag)
  800930:	85 c9                	test   %ecx,%ecx
  800932:	74 2c                	je     800960 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 10                	mov    (%eax),%edx
  800939:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093e:	8d 40 04             	lea    0x4(%eax),%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800944:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800949:	eb 54                	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8b 10                	mov    (%eax),%edx
  800950:	8b 48 04             	mov    0x4(%eax),%ecx
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800959:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80095e:	eb 3f                	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8b 10                	mov    (%eax),%edx
  800965:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096a:	8d 40 04             	lea    0x4(%eax),%eax
  80096d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800970:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800975:	eb 28                	jmp    80099f <vprintfmt+0x493>
			putch('0', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	6a 30                	push   $0x30
  80097d:	ff d6                	call   *%esi
			putch('x', putdat);
  80097f:	83 c4 08             	add    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 78                	push   $0x78
  800985:	ff d6                	call   *%esi
			num = (unsigned long long)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8b 10                	mov    (%eax),%edx
  80098c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800991:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800994:	8d 40 04             	lea    0x4(%eax),%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099a:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  80099f:	83 ec 0c             	sub    $0xc,%esp
  8009a2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 d4             	push   -0x2c(%ebp)
  8009aa:	57                   	push   %edi
  8009ab:	51                   	push   %ecx
  8009ac:	52                   	push   %edx
  8009ad:	89 da                	mov    %ebx,%edx
  8009af:	89 f0                	mov    %esi,%eax
  8009b1:	e8 73 fa ff ff       	call   800429 <printnum>
			break;
  8009b6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009b9:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	e9 69 fb ff ff       	jmp    80052a <vprintfmt+0x1e>
	if (lflag >= 2)
  8009c1:	83 f9 01             	cmp    $0x1,%ecx
  8009c4:	7f 1b                	jg     8009e1 <vprintfmt+0x4d5>
	else if (lflag)
  8009c6:	85 c9                	test   %ecx,%ecx
  8009c8:	74 2c                	je     8009f6 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	8b 10                	mov    (%eax),%edx
  8009cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d4:	8d 40 04             	lea    0x4(%eax),%eax
  8009d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009da:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009df:	eb be                	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	8b 10                	mov    (%eax),%edx
  8009e6:	8b 48 04             	mov    0x4(%eax),%ecx
  8009e9:	8d 40 08             	lea    0x8(%eax),%eax
  8009ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ef:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009f4:	eb a9                	jmp    80099f <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	8b 10                	mov    (%eax),%edx
  8009fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a00:	8d 40 04             	lea    0x4(%eax),%eax
  800a03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a06:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a0b:	eb 92                	jmp    80099f <vprintfmt+0x493>
			putch(ch, putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	53                   	push   %ebx
  800a11:	6a 25                	push   $0x25
  800a13:	ff d6                	call   *%esi
			break;
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	eb 9f                	jmp    8009b9 <vprintfmt+0x4ad>
			putch('%', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	53                   	push   %ebx
  800a1e:	6a 25                	push   $0x25
  800a20:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a22:	83 c4 10             	add    $0x10,%esp
  800a25:	89 f8                	mov    %edi,%eax
  800a27:	eb 03                	jmp    800a2c <vprintfmt+0x520>
  800a29:	83 e8 01             	sub    $0x1,%eax
  800a2c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a30:	75 f7                	jne    800a29 <vprintfmt+0x51d>
  800a32:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a35:	eb 82                	jmp    8009b9 <vprintfmt+0x4ad>

00800a37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	83 ec 18             	sub    $0x18,%esp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a46:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a54:	85 c0                	test   %eax,%eax
  800a56:	74 26                	je     800a7e <vsnprintf+0x47>
  800a58:	85 d2                	test   %edx,%edx
  800a5a:	7e 22                	jle    800a7e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5c:	ff 75 14             	push   0x14(%ebp)
  800a5f:	ff 75 10             	push   0x10(%ebp)
  800a62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	68 d2 04 80 00       	push   $0x8004d2
  800a6b:	e8 9c fa ff ff       	call   80050c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a79:	83 c4 10             	add    $0x10,%esp
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    
		return -E_INVAL;
  800a7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a83:	eb f7                	jmp    800a7c <vsnprintf+0x45>

00800a85 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a8e:	50                   	push   %eax
  800a8f:	ff 75 10             	push   0x10(%ebp)
  800a92:	ff 75 0c             	push   0xc(%ebp)
  800a95:	ff 75 08             	push   0x8(%ebp)
  800a98:	e8 9a ff ff ff       	call   800a37 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 03                	jmp    800aaf <strlen+0x10>
		n++;
  800aac:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800aaf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab3:	75 f7                	jne    800aac <strlen+0xd>
	return n;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	eb 03                	jmp    800aca <strnlen+0x13>
		n++;
  800ac7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aca:	39 d0                	cmp    %edx,%eax
  800acc:	74 08                	je     800ad6 <strnlen+0x1f>
  800ace:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ad2:	75 f3                	jne    800ac7 <strnlen+0x10>
  800ad4:	89 c2                	mov    %eax,%edx
	return n;
}
  800ad6:	89 d0                	mov    %edx,%eax
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae9:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800aed:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800af0:	83 c0 01             	add    $0x1,%eax
  800af3:	84 d2                	test   %dl,%dl
  800af5:	75 f2                	jne    800ae9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af7:	89 c8                	mov    %ecx,%eax
  800af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <strcat>:

char *
strcat(char *dst, const char *src)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	53                   	push   %ebx
  800b02:	83 ec 10             	sub    $0x10,%esp
  800b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b08:	53                   	push   %ebx
  800b09:	e8 91 ff ff ff       	call   800a9f <strlen>
  800b0e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b11:	ff 75 0c             	push   0xc(%ebp)
  800b14:	01 d8                	add    %ebx,%eax
  800b16:	50                   	push   %eax
  800b17:	e8 be ff ff ff       	call   800ada <strcpy>
	return dst;
}
  800b1c:	89 d8                	mov    %ebx,%eax
  800b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	56                   	push   %esi
  800b27:	53                   	push   %ebx
  800b28:	8b 75 08             	mov    0x8(%ebp),%esi
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2e:	89 f3                	mov    %esi,%ebx
  800b30:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b33:	89 f0                	mov    %esi,%eax
  800b35:	eb 0f                	jmp    800b46 <strncpy+0x23>
		*dst++ = *src;
  800b37:	83 c0 01             	add    $0x1,%eax
  800b3a:	0f b6 0a             	movzbl (%edx),%ecx
  800b3d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b40:	80 f9 01             	cmp    $0x1,%cl
  800b43:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b46:	39 d8                	cmp    %ebx,%eax
  800b48:	75 ed                	jne    800b37 <strncpy+0x14>
	}
	return ret;
}
  800b4a:	89 f0                	mov    %esi,%eax
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 75 08             	mov    0x8(%ebp),%esi
  800b58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b60:	85 d2                	test   %edx,%edx
  800b62:	74 21                	je     800b85 <strlcpy+0x35>
  800b64:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b68:	89 f2                	mov    %esi,%edx
  800b6a:	eb 09                	jmp    800b75 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b6c:	83 c1 01             	add    $0x1,%ecx
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	74 09                	je     800b82 <strlcpy+0x32>
  800b79:	0f b6 19             	movzbl (%ecx),%ebx
  800b7c:	84 db                	test   %bl,%bl
  800b7e:	75 ec                	jne    800b6c <strlcpy+0x1c>
  800b80:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b82:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b85:	29 f0                	sub    %esi,%eax
}
  800b87:	5b                   	pop    %ebx
  800b88:	5e                   	pop    %esi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b94:	eb 06                	jmp    800b9c <strcmp+0x11>
		p++, q++;
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b9c:	0f b6 01             	movzbl (%ecx),%eax
  800b9f:	84 c0                	test   %al,%al
  800ba1:	74 04                	je     800ba7 <strcmp+0x1c>
  800ba3:	3a 02                	cmp    (%edx),%al
  800ba5:	74 ef                	je     800b96 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba7:	0f b6 c0             	movzbl %al,%eax
  800baa:	0f b6 12             	movzbl (%edx),%edx
  800bad:	29 d0                	sub    %edx,%eax
}
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	53                   	push   %ebx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc0:	eb 06                	jmp    800bc8 <strncmp+0x17>
		n--, p++, q++;
  800bc2:	83 c0 01             	add    $0x1,%eax
  800bc5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc8:	39 d8                	cmp    %ebx,%eax
  800bca:	74 18                	je     800be4 <strncmp+0x33>
  800bcc:	0f b6 08             	movzbl (%eax),%ecx
  800bcf:	84 c9                	test   %cl,%cl
  800bd1:	74 04                	je     800bd7 <strncmp+0x26>
  800bd3:	3a 0a                	cmp    (%edx),%cl
  800bd5:	74 eb                	je     800bc2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd7:	0f b6 00             	movzbl (%eax),%eax
  800bda:	0f b6 12             	movzbl (%edx),%edx
  800bdd:	29 d0                	sub    %edx,%eax
}
  800bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    
		return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	eb f4                	jmp    800bdf <strncmp+0x2e>

00800beb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf5:	eb 03                	jmp    800bfa <strchr+0xf>
  800bf7:	83 c0 01             	add    $0x1,%eax
  800bfa:	0f b6 10             	movzbl (%eax),%edx
  800bfd:	84 d2                	test   %dl,%dl
  800bff:	74 06                	je     800c07 <strchr+0x1c>
		if (*s == c)
  800c01:	38 ca                	cmp    %cl,%dl
  800c03:	75 f2                	jne    800bf7 <strchr+0xc>
  800c05:	eb 05                	jmp    800c0c <strchr+0x21>
			return (char *) s;
	return 0;
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c18:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c1b:	38 ca                	cmp    %cl,%dl
  800c1d:	74 09                	je     800c28 <strfind+0x1a>
  800c1f:	84 d2                	test   %dl,%dl
  800c21:	74 05                	je     800c28 <strfind+0x1a>
	for (; *s; s++)
  800c23:	83 c0 01             	add    $0x1,%eax
  800c26:	eb f0                	jmp    800c18 <strfind+0xa>
			break;
	return (char *) s;
}
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c36:	85 c9                	test   %ecx,%ecx
  800c38:	74 2f                	je     800c69 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c3a:	89 f8                	mov    %edi,%eax
  800c3c:	09 c8                	or     %ecx,%eax
  800c3e:	a8 03                	test   $0x3,%al
  800c40:	75 21                	jne    800c63 <memset+0x39>
		c &= 0xFF;
  800c42:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	c1 e0 08             	shl    $0x8,%eax
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	c1 e3 18             	shl    $0x18,%ebx
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	c1 e6 10             	shl    $0x10,%esi
  800c55:	09 f3                	or     %esi,%ebx
  800c57:	09 da                	or     %ebx,%edx
  800c59:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c5b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c5e:	fc                   	cld    
  800c5f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c61:	eb 06                	jmp    800c69 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	fc                   	cld    
  800c67:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c69:	89 f8                	mov    %edi,%eax
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7e:	39 c6                	cmp    %eax,%esi
  800c80:	73 32                	jae    800cb4 <memmove+0x44>
  800c82:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	76 2b                	jbe    800cb4 <memmove+0x44>
		s += n;
		d += n;
  800c89:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8c:	89 d6                	mov    %edx,%esi
  800c8e:	09 fe                	or     %edi,%esi
  800c90:	09 ce                	or     %ecx,%esi
  800c92:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c98:	75 0e                	jne    800ca8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c9a:	83 ef 04             	sub    $0x4,%edi
  800c9d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca3:	fd                   	std    
  800ca4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca6:	eb 09                	jmp    800cb1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca8:	83 ef 01             	sub    $0x1,%edi
  800cab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cae:	fd                   	std    
  800caf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb1:	fc                   	cld    
  800cb2:	eb 1a                	jmp    800cce <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	89 f2                	mov    %esi,%edx
  800cb6:	09 c2                	or     %eax,%edx
  800cb8:	09 ca                	or     %ecx,%edx
  800cba:	f6 c2 03             	test   $0x3,%dl
  800cbd:	75 0a                	jne    800cc9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cbf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc2:	89 c7                	mov    %eax,%edi
  800cc4:	fc                   	cld    
  800cc5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc7:	eb 05                	jmp    800cce <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cc9:	89 c7                	mov    %eax,%edi
  800ccb:	fc                   	cld    
  800ccc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd8:	ff 75 10             	push   0x10(%ebp)
  800cdb:	ff 75 0c             	push   0xc(%ebp)
  800cde:	ff 75 08             	push   0x8(%ebp)
  800ce1:	e8 8a ff ff ff       	call   800c70 <memmove>
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf3:	89 c6                	mov    %eax,%esi
  800cf5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf8:	eb 06                	jmp    800d00 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d00:	39 f0                	cmp    %esi,%eax
  800d02:	74 14                	je     800d18 <memcmp+0x30>
		if (*s1 != *s2)
  800d04:	0f b6 08             	movzbl (%eax),%ecx
  800d07:	0f b6 1a             	movzbl (%edx),%ebx
  800d0a:	38 d9                	cmp    %bl,%cl
  800d0c:	74 ec                	je     800cfa <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d0e:	0f b6 c1             	movzbl %cl,%eax
  800d11:	0f b6 db             	movzbl %bl,%ebx
  800d14:	29 d8                	sub    %ebx,%eax
  800d16:	eb 05                	jmp    800d1d <memcmp+0x35>
	}

	return 0;
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2a:	89 c2                	mov    %eax,%edx
  800d2c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d2f:	eb 03                	jmp    800d34 <memfind+0x13>
  800d31:	83 c0 01             	add    $0x1,%eax
  800d34:	39 d0                	cmp    %edx,%eax
  800d36:	73 04                	jae    800d3c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	38 08                	cmp    %cl,(%eax)
  800d3a:	75 f5                	jne    800d31 <memfind+0x10>
			break;
	return (void *) s;
}
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4a:	eb 03                	jmp    800d4f <strtol+0x11>
		s++;
  800d4c:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d4f:	0f b6 02             	movzbl (%edx),%eax
  800d52:	3c 20                	cmp    $0x20,%al
  800d54:	74 f6                	je     800d4c <strtol+0xe>
  800d56:	3c 09                	cmp    $0x9,%al
  800d58:	74 f2                	je     800d4c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	74 2a                	je     800d88 <strtol+0x4a>
	int neg = 0;
  800d5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d63:	3c 2d                	cmp    $0x2d,%al
  800d65:	74 2b                	je     800d92 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d67:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d6d:	75 0f                	jne    800d7e <strtol+0x40>
  800d6f:	80 3a 30             	cmpb   $0x30,(%edx)
  800d72:	74 28                	je     800d9c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d74:	85 db                	test   %ebx,%ebx
  800d76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7b:	0f 44 d8             	cmove  %eax,%ebx
  800d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d83:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d86:	eb 46                	jmp    800dce <strtol+0x90>
		s++;
  800d88:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d90:	eb d5                	jmp    800d67 <strtol+0x29>
		s++, neg = 1;
  800d92:	83 c2 01             	add    $0x1,%edx
  800d95:	bf 01 00 00 00       	mov    $0x1,%edi
  800d9a:	eb cb                	jmp    800d67 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9c:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800da0:	74 0e                	je     800db0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da2:	85 db                	test   %ebx,%ebx
  800da4:	75 d8                	jne    800d7e <strtol+0x40>
		s++, base = 8;
  800da6:	83 c2 01             	add    $0x1,%edx
  800da9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dae:	eb ce                	jmp    800d7e <strtol+0x40>
		s += 2, base = 16;
  800db0:	83 c2 02             	add    $0x2,%edx
  800db3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db8:	eb c4                	jmp    800d7e <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dba:	0f be c0             	movsbl %al,%eax
  800dbd:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc3:	7d 3a                	jge    800dff <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dc5:	83 c2 01             	add    $0x1,%edx
  800dc8:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dcc:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dce:	0f b6 02             	movzbl (%edx),%eax
  800dd1:	8d 70 d0             	lea    -0x30(%eax),%esi
  800dd4:	89 f3                	mov    %esi,%ebx
  800dd6:	80 fb 09             	cmp    $0x9,%bl
  800dd9:	76 df                	jbe    800dba <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800ddb:	8d 70 9f             	lea    -0x61(%eax),%esi
  800dde:	89 f3                	mov    %esi,%ebx
  800de0:	80 fb 19             	cmp    $0x19,%bl
  800de3:	77 08                	ja     800ded <strtol+0xaf>
			dig = *s - 'a' + 10;
  800de5:	0f be c0             	movsbl %al,%eax
  800de8:	83 e8 57             	sub    $0x57,%eax
  800deb:	eb d3                	jmp    800dc0 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800ded:	8d 70 bf             	lea    -0x41(%eax),%esi
  800df0:	89 f3                	mov    %esi,%ebx
  800df2:	80 fb 19             	cmp    $0x19,%bl
  800df5:	77 08                	ja     800dff <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df7:	0f be c0             	movsbl %al,%eax
  800dfa:	83 e8 37             	sub    $0x37,%eax
  800dfd:	eb c1                	jmp    800dc0 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e03:	74 05                	je     800e0a <strtol+0xcc>
		*endptr = (char *) s;
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e0a:	89 c8                	mov    %ecx,%eax
  800e0c:	f7 d8                	neg    %eax
  800e0e:	85 ff                	test   %edi,%edi
  800e10:	0f 45 c8             	cmovne %eax,%ecx
}
  800e13:	89 c8                	mov    %ecx,%eax
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
  800e1a:	66 90                	xchg   %ax,%ax
  800e1c:	66 90                	xchg   %ax,%ax
  800e1e:	66 90                	xchg   %ax,%ax

00800e20 <__udivdi3>:
  800e20:	f3 0f 1e fb          	endbr32 
  800e24:	55                   	push   %ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 1c             	sub    $0x1c,%esp
  800e2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e2f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e33:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e37:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	75 19                	jne    800e58 <__udivdi3+0x38>
  800e3f:	39 f3                	cmp    %esi,%ebx
  800e41:	76 4d                	jbe    800e90 <__udivdi3+0x70>
  800e43:	31 ff                	xor    %edi,%edi
  800e45:	89 e8                	mov    %ebp,%eax
  800e47:	89 f2                	mov    %esi,%edx
  800e49:	f7 f3                	div    %ebx
  800e4b:	89 fa                	mov    %edi,%edx
  800e4d:	83 c4 1c             	add    $0x1c,%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    
  800e55:	8d 76 00             	lea    0x0(%esi),%esi
  800e58:	39 f0                	cmp    %esi,%eax
  800e5a:	76 14                	jbe    800e70 <__udivdi3+0x50>
  800e5c:	31 ff                	xor    %edi,%edi
  800e5e:	31 c0                	xor    %eax,%eax
  800e60:	89 fa                	mov    %edi,%edx
  800e62:	83 c4 1c             	add    $0x1c,%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    
  800e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e70:	0f bd f8             	bsr    %eax,%edi
  800e73:	83 f7 1f             	xor    $0x1f,%edi
  800e76:	75 48                	jne    800ec0 <__udivdi3+0xa0>
  800e78:	39 f0                	cmp    %esi,%eax
  800e7a:	72 06                	jb     800e82 <__udivdi3+0x62>
  800e7c:	31 c0                	xor    %eax,%eax
  800e7e:	39 eb                	cmp    %ebp,%ebx
  800e80:	77 de                	ja     800e60 <__udivdi3+0x40>
  800e82:	b8 01 00 00 00       	mov    $0x1,%eax
  800e87:	eb d7                	jmp    800e60 <__udivdi3+0x40>
  800e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e90:	89 d9                	mov    %ebx,%ecx
  800e92:	85 db                	test   %ebx,%ebx
  800e94:	75 0b                	jne    800ea1 <__udivdi3+0x81>
  800e96:	b8 01 00 00 00       	mov    $0x1,%eax
  800e9b:	31 d2                	xor    %edx,%edx
  800e9d:	f7 f3                	div    %ebx
  800e9f:	89 c1                	mov    %eax,%ecx
  800ea1:	31 d2                	xor    %edx,%edx
  800ea3:	89 f0                	mov    %esi,%eax
  800ea5:	f7 f1                	div    %ecx
  800ea7:	89 c6                	mov    %eax,%esi
  800ea9:	89 e8                	mov    %ebp,%eax
  800eab:	89 f7                	mov    %esi,%edi
  800ead:	f7 f1                	div    %ecx
  800eaf:	89 fa                	mov    %edi,%edx
  800eb1:	83 c4 1c             	add    $0x1c,%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 f9                	mov    %edi,%ecx
  800ec2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ec7:	29 fa                	sub    %edi,%edx
  800ec9:	d3 e0                	shl    %cl,%eax
  800ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ecf:	89 d1                	mov    %edx,%ecx
  800ed1:	89 d8                	mov    %ebx,%eax
  800ed3:	d3 e8                	shr    %cl,%eax
  800ed5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ed9:	09 c1                	or     %eax,%ecx
  800edb:	89 f0                	mov    %esi,%eax
  800edd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ee1:	89 f9                	mov    %edi,%ecx
  800ee3:	d3 e3                	shl    %cl,%ebx
  800ee5:	89 d1                	mov    %edx,%ecx
  800ee7:	d3 e8                	shr    %cl,%eax
  800ee9:	89 f9                	mov    %edi,%ecx
  800eeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800eef:	89 eb                	mov    %ebp,%ebx
  800ef1:	d3 e6                	shl    %cl,%esi
  800ef3:	89 d1                	mov    %edx,%ecx
  800ef5:	d3 eb                	shr    %cl,%ebx
  800ef7:	09 f3                	or     %esi,%ebx
  800ef9:	89 c6                	mov    %eax,%esi
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	89 d8                	mov    %ebx,%eax
  800eff:	f7 74 24 08          	divl   0x8(%esp)
  800f03:	89 d6                	mov    %edx,%esi
  800f05:	89 c3                	mov    %eax,%ebx
  800f07:	f7 64 24 0c          	mull   0xc(%esp)
  800f0b:	39 d6                	cmp    %edx,%esi
  800f0d:	72 19                	jb     800f28 <__udivdi3+0x108>
  800f0f:	89 f9                	mov    %edi,%ecx
  800f11:	d3 e5                	shl    %cl,%ebp
  800f13:	39 c5                	cmp    %eax,%ebp
  800f15:	73 04                	jae    800f1b <__udivdi3+0xfb>
  800f17:	39 d6                	cmp    %edx,%esi
  800f19:	74 0d                	je     800f28 <__udivdi3+0x108>
  800f1b:	89 d8                	mov    %ebx,%eax
  800f1d:	31 ff                	xor    %edi,%edi
  800f1f:	e9 3c ff ff ff       	jmp    800e60 <__udivdi3+0x40>
  800f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f2b:	31 ff                	xor    %edi,%edi
  800f2d:	e9 2e ff ff ff       	jmp    800e60 <__udivdi3+0x40>
  800f32:	66 90                	xchg   %ax,%ax
  800f34:	66 90                	xchg   %ax,%ax
  800f36:	66 90                	xchg   %ax,%ax
  800f38:	66 90                	xchg   %ax,%ax
  800f3a:	66 90                	xchg   %ax,%ax
  800f3c:	66 90                	xchg   %ax,%ax
  800f3e:	66 90                	xchg   %ax,%ax

00800f40 <__umoddi3>:
  800f40:	f3 0f 1e fb          	endbr32 
  800f44:	55                   	push   %ebp
  800f45:	57                   	push   %edi
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 1c             	sub    $0x1c,%esp
  800f4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f53:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f57:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f5b:	89 f0                	mov    %esi,%eax
  800f5d:	89 da                	mov    %ebx,%edx
  800f5f:	85 ff                	test   %edi,%edi
  800f61:	75 15                	jne    800f78 <__umoddi3+0x38>
  800f63:	39 dd                	cmp    %ebx,%ebp
  800f65:	76 39                	jbe    800fa0 <__umoddi3+0x60>
  800f67:	f7 f5                	div    %ebp
  800f69:	89 d0                	mov    %edx,%eax
  800f6b:	31 d2                	xor    %edx,%edx
  800f6d:	83 c4 1c             	add    $0x1c,%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	39 df                	cmp    %ebx,%edi
  800f7a:	77 f1                	ja     800f6d <__umoddi3+0x2d>
  800f7c:	0f bd cf             	bsr    %edi,%ecx
  800f7f:	83 f1 1f             	xor    $0x1f,%ecx
  800f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f86:	75 40                	jne    800fc8 <__umoddi3+0x88>
  800f88:	39 df                	cmp    %ebx,%edi
  800f8a:	72 04                	jb     800f90 <__umoddi3+0x50>
  800f8c:	39 f5                	cmp    %esi,%ebp
  800f8e:	77 dd                	ja     800f6d <__umoddi3+0x2d>
  800f90:	89 da                	mov    %ebx,%edx
  800f92:	89 f0                	mov    %esi,%eax
  800f94:	29 e8                	sub    %ebp,%eax
  800f96:	19 fa                	sbb    %edi,%edx
  800f98:	eb d3                	jmp    800f6d <__umoddi3+0x2d>
  800f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fa0:	89 e9                	mov    %ebp,%ecx
  800fa2:	85 ed                	test   %ebp,%ebp
  800fa4:	75 0b                	jne    800fb1 <__umoddi3+0x71>
  800fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fab:	31 d2                	xor    %edx,%edx
  800fad:	f7 f5                	div    %ebp
  800faf:	89 c1                	mov    %eax,%ecx
  800fb1:	89 d8                	mov    %ebx,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f1                	div    %ecx
  800fb7:	89 f0                	mov    %esi,%eax
  800fb9:	f7 f1                	div    %ecx
  800fbb:	89 d0                	mov    %edx,%eax
  800fbd:	31 d2                	xor    %edx,%edx
  800fbf:	eb ac                	jmp    800f6d <__umoddi3+0x2d>
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fcc:	ba 20 00 00 00       	mov    $0x20,%edx
  800fd1:	29 c2                	sub    %eax,%edx
  800fd3:	89 c1                	mov    %eax,%ecx
  800fd5:	89 e8                	mov    %ebp,%eax
  800fd7:	d3 e7                	shl    %cl,%edi
  800fd9:	89 d1                	mov    %edx,%ecx
  800fdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fdf:	d3 e8                	shr    %cl,%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fe7:	09 f9                	or     %edi,%ecx
  800fe9:	89 df                	mov    %ebx,%edi
  800feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fef:	89 c1                	mov    %eax,%ecx
  800ff1:	d3 e5                	shl    %cl,%ebp
  800ff3:	89 d1                	mov    %edx,%ecx
  800ff5:	d3 ef                	shr    %cl,%edi
  800ff7:	89 c1                	mov    %eax,%ecx
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	d3 e3                	shl    %cl,%ebx
  800ffd:	89 d1                	mov    %edx,%ecx
  800fff:	89 fa                	mov    %edi,%edx
  801001:	d3 e8                	shr    %cl,%eax
  801003:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801008:	09 d8                	or     %ebx,%eax
  80100a:	f7 74 24 08          	divl   0x8(%esp)
  80100e:	89 d3                	mov    %edx,%ebx
  801010:	d3 e6                	shl    %cl,%esi
  801012:	f7 e5                	mul    %ebp
  801014:	89 c7                	mov    %eax,%edi
  801016:	89 d1                	mov    %edx,%ecx
  801018:	39 d3                	cmp    %edx,%ebx
  80101a:	72 06                	jb     801022 <__umoddi3+0xe2>
  80101c:	75 0e                	jne    80102c <__umoddi3+0xec>
  80101e:	39 c6                	cmp    %eax,%esi
  801020:	73 0a                	jae    80102c <__umoddi3+0xec>
  801022:	29 e8                	sub    %ebp,%eax
  801024:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801028:	89 d1                	mov    %edx,%ecx
  80102a:	89 c7                	mov    %eax,%edi
  80102c:	89 f5                	mov    %esi,%ebp
  80102e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801032:	29 fd                	sub    %edi,%ebp
  801034:	19 cb                	sbb    %ecx,%ebx
  801036:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80103b:	89 d8                	mov    %ebx,%eax
  80103d:	d3 e0                	shl    %cl,%eax
  80103f:	89 f1                	mov    %esi,%ecx
  801041:	d3 ed                	shr    %cl,%ebp
  801043:	d3 eb                	shr    %cl,%ebx
  801045:	09 e8                	or     %ebp,%eax
  801047:	89 da                	mov    %ebx,%edx
  801049:	83 c4 1c             	add    $0x1c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
