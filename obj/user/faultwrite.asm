
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 c6 00 00 00       	call   800114 <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80008a:	6a 00                	push   $0x0
  80008c:	e8 42 00 00 00       	call   8000d3 <sys_env_destroy>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	57                   	push   %edi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a7:	89 c3                	mov    %eax,%ebx
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	89 c6                	mov    %eax,%esi
  8000ad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5f                   	pop    %edi
  8000b2:	5d                   	pop    %ebp
  8000b3:	c3                   	ret    

008000b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c4:	89 d1                	mov    %edx,%ecx
  8000c6:	89 d3                	mov    %edx,%ebx
  8000c8:	89 d7                	mov    %edx,%edi
  8000ca:	89 d6                	mov    %edx,%esi
  8000cc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e9:	89 cb                	mov    %ecx,%ebx
  8000eb:	89 cf                	mov    %ecx,%edi
  8000ed:	89 ce                	mov    %ecx,%esi
  8000ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	7f 08                	jg     8000fd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	50                   	push   %eax
  800101:	6a 03                	push   $0x3
  800103:	68 8a 10 80 00       	push   $0x80108a
  800108:	6a 23                	push   $0x23
  80010a:	68 a7 10 80 00       	push   $0x8010a7
  80010f:	e8 2f 02 00 00       	call   800343 <_panic>

00800114 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	57                   	push   %edi
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011a:	ba 00 00 00 00       	mov    $0x0,%edx
  80011f:	b8 02 00 00 00       	mov    $0x2,%eax
  800124:	89 d1                	mov    %edx,%ecx
  800126:	89 d3                	mov    %edx,%ebx
  800128:	89 d7                	mov    %edx,%edi
  80012a:	89 d6                	mov    %edx,%esi
  80012c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    

00800133 <sys_yield>:

void
sys_yield(void)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
	asm volatile("int %1\n"
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800143:	89 d1                	mov    %edx,%ecx
  800145:	89 d3                	mov    %edx,%ebx
  800147:	89 d7                	mov    %edx,%edi
  800149:	89 d6                	mov    %edx,%esi
  80014b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5f                   	pop    %edi
  800150:	5d                   	pop    %ebp
  800151:	c3                   	ret    

00800152 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	8b 55 08             	mov    0x8(%ebp),%edx
  800163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800166:	b8 04 00 00 00       	mov    $0x4,%eax
  80016b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016e:	89 f7                	mov    %esi,%edi
  800170:	cd 30                	int    $0x30
	if(check && ret > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 08                	jg     80017e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	6a 04                	push   $0x4
  800184:	68 8a 10 80 00       	push   $0x80108a
  800189:	6a 23                	push   $0x23
  80018b:	68 a7 10 80 00       	push   $0x8010a7
  800190:	e8 ae 01 00 00       	call   800343 <_panic>

00800195 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	57                   	push   %edi
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001af:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 05                	push   $0x5
  8001c6:	68 8a 10 80 00       	push   $0x80108a
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 a7 10 80 00       	push   $0x8010a7
  8001d2:	e8 6c 01 00 00       	call   800343 <_panic>

008001d7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f0:	89 df                	mov    %ebx,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	7f 08                	jg     800202 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fd:	5b                   	pop    %ebx
  8001fe:	5e                   	pop    %esi
  8001ff:	5f                   	pop    %edi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	6a 06                	push   $0x6
  800208:	68 8a 10 80 00       	push   $0x80108a
  80020d:	6a 23                	push   $0x23
  80020f:	68 a7 10 80 00       	push   $0x8010a7
  800214:	e8 2a 01 00 00       	call   800343 <_panic>

00800219 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022d:	b8 08 00 00 00       	mov    $0x8,%eax
  800232:	89 df                	mov    %ebx,%edi
  800234:	89 de                	mov    %ebx,%esi
  800236:	cd 30                	int    $0x30
	if(check && ret > 0)
  800238:	85 c0                	test   %eax,%eax
  80023a:	7f 08                	jg     800244 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	6a 08                	push   $0x8
  80024a:	68 8a 10 80 00       	push   $0x80108a
  80024f:	6a 23                	push   $0x23
  800251:	68 a7 10 80 00       	push   $0x8010a7
  800256:	e8 e8 00 00 00       	call   800343 <_panic>

0080025b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	57                   	push   %edi
  80025f:	56                   	push   %esi
  800260:	53                   	push   %ebx
  800261:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800264:	bb 00 00 00 00       	mov    $0x0,%ebx
  800269:	8b 55 08             	mov    0x8(%ebp),%edx
  80026c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026f:	b8 09 00 00 00       	mov    $0x9,%eax
  800274:	89 df                	mov    %ebx,%edi
  800276:	89 de                	mov    %ebx,%esi
  800278:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027a:	85 c0                	test   %eax,%eax
  80027c:	7f 08                	jg     800286 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	6a 09                	push   $0x9
  80028c:	68 8a 10 80 00       	push   $0x80108a
  800291:	6a 23                	push   $0x23
  800293:	68 a7 10 80 00       	push   $0x8010a7
  800298:	e8 a6 00 00 00       	call   800343 <_panic>

0080029d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b6:	89 df                	mov    %ebx,%edi
  8002b8:	89 de                	mov    %ebx,%esi
  8002ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	7f 08                	jg     8002c8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	6a 0a                	push   $0xa
  8002ce:	68 8a 10 80 00       	push   $0x80108a
  8002d3:	6a 23                	push   $0x23
  8002d5:	68 a7 10 80 00       	push   $0x8010a7
  8002da:	e8 64 00 00 00       	call   800343 <_panic>

008002df <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	57                   	push   %edi
  8002e3:	56                   	push   %esi
  8002e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002eb:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f0:	be 00 00 00 00       	mov    $0x0,%esi
  8002f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fd:	5b                   	pop    %ebx
  8002fe:	5e                   	pop    %esi
  8002ff:	5f                   	pop    %edi
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800310:	8b 55 08             	mov    0x8(%ebp),%edx
  800313:	b8 0d 00 00 00       	mov    $0xd,%eax
  800318:	89 cb                	mov    %ecx,%ebx
  80031a:	89 cf                	mov    %ecx,%edi
  80031c:	89 ce                	mov    %ecx,%esi
  80031e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800320:	85 c0                	test   %eax,%eax
  800322:	7f 08                	jg     80032c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5f                   	pop    %edi
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	6a 0d                	push   $0xd
  800332:	68 8a 10 80 00       	push   $0x80108a
  800337:	6a 23                	push   $0x23
  800339:	68 a7 10 80 00       	push   $0x8010a7
  80033e:	e8 00 00 00 00       	call   800343 <_panic>

00800343 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800348:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800351:	e8 be fd ff ff       	call   800114 <sys_getenvid>
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	ff 75 0c             	push   0xc(%ebp)
  80035c:	ff 75 08             	push   0x8(%ebp)
  80035f:	56                   	push   %esi
  800360:	50                   	push   %eax
  800361:	68 b8 10 80 00       	push   $0x8010b8
  800366:	e8 b3 00 00 00       	call   80041e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036b:	83 c4 18             	add    $0x18,%esp
  80036e:	53                   	push   %ebx
  80036f:	ff 75 10             	push   0x10(%ebp)
  800372:	e8 56 00 00 00       	call   8003cd <vcprintf>
	cprintf("\n");
  800377:	c7 04 24 db 10 80 00 	movl   $0x8010db,(%esp)
  80037e:	e8 9b 00 00 00       	call   80041e <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800386:	cc                   	int3   
  800387:	eb fd                	jmp    800386 <_panic+0x43>

00800389 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	53                   	push   %ebx
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800393:	8b 13                	mov    (%ebx),%edx
  800395:	8d 42 01             	lea    0x1(%edx),%eax
  800398:	89 03                	mov    %eax,(%ebx)
  80039a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a6:	74 09                	je     8003b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	68 ff 00 00 00       	push   $0xff
  8003b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bc:	50                   	push   %eax
  8003bd:	e8 d4 fc ff ff       	call   800096 <sys_cputs>
		b->idx = 0;
  8003c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	eb db                	jmp    8003a8 <putch+0x1f>

008003cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003dd:	00 00 00 
	b.cnt = 0;
  8003e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ea:	ff 75 0c             	push   0xc(%ebp)
  8003ed:	ff 75 08             	push   0x8(%ebp)
  8003f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f6:	50                   	push   %eax
  8003f7:	68 89 03 80 00       	push   $0x800389
  8003fc:	e8 14 01 00 00       	call   800515 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800401:	83 c4 08             	add    $0x8,%esp
  800404:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80040a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800410:	50                   	push   %eax
  800411:	e8 80 fc ff ff       	call   800096 <sys_cputs>

	return b.cnt;
}
  800416:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800424:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800427:	50                   	push   %eax
  800428:	ff 75 08             	push   0x8(%ebp)
  80042b:	e8 9d ff ff ff       	call   8003cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	57                   	push   %edi
  800436:	56                   	push   %esi
  800437:	53                   	push   %ebx
  800438:	83 ec 1c             	sub    $0x1c,%esp
  80043b:	89 c7                	mov    %eax,%edi
  80043d:	89 d6                	mov    %edx,%esi
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 55 0c             	mov    0xc(%ebp),%edx
  800445:	89 d1                	mov    %edx,%ecx
  800447:	89 c2                	mov    %eax,%edx
  800449:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80044f:	8b 45 10             	mov    0x10(%ebp),%eax
  800452:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800455:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800458:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80045f:	39 c2                	cmp    %eax,%edx
  800461:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800464:	72 3e                	jb     8004a4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	ff 75 18             	push   0x18(%ebp)
  80046c:	83 eb 01             	sub    $0x1,%ebx
  80046f:	53                   	push   %ebx
  800470:	50                   	push   %eax
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	ff 75 e4             	push   -0x1c(%ebp)
  800477:	ff 75 e0             	push   -0x20(%ebp)
  80047a:	ff 75 dc             	push   -0x24(%ebp)
  80047d:	ff 75 d8             	push   -0x28(%ebp)
  800480:	e8 ab 09 00 00       	call   800e30 <__udivdi3>
  800485:	83 c4 18             	add    $0x18,%esp
  800488:	52                   	push   %edx
  800489:	50                   	push   %eax
  80048a:	89 f2                	mov    %esi,%edx
  80048c:	89 f8                	mov    %edi,%eax
  80048e:	e8 9f ff ff ff       	call   800432 <printnum>
  800493:	83 c4 20             	add    $0x20,%esp
  800496:	eb 13                	jmp    8004ab <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	56                   	push   %esi
  80049c:	ff 75 18             	push   0x18(%ebp)
  80049f:	ff d7                	call   *%edi
  8004a1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a4:	83 eb 01             	sub    $0x1,%ebx
  8004a7:	85 db                	test   %ebx,%ebx
  8004a9:	7f ed                	jg     800498 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	56                   	push   %esi
  8004af:	83 ec 04             	sub    $0x4,%esp
  8004b2:	ff 75 e4             	push   -0x1c(%ebp)
  8004b5:	ff 75 e0             	push   -0x20(%ebp)
  8004b8:	ff 75 dc             	push   -0x24(%ebp)
  8004bb:	ff 75 d8             	push   -0x28(%ebp)
  8004be:	e8 8d 0a 00 00       	call   800f50 <__umoddi3>
  8004c3:	83 c4 14             	add    $0x14,%esp
  8004c6:	0f be 80 dd 10 80 00 	movsbl 0x8010dd(%eax),%eax
  8004cd:	50                   	push   %eax
  8004ce:	ff d7                	call   *%edi
}
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d6:	5b                   	pop    %ebx
  8004d7:	5e                   	pop    %esi
  8004d8:	5f                   	pop    %edi
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    

008004db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e5:	8b 10                	mov    (%eax),%edx
  8004e7:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ea:	73 0a                	jae    8004f6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ef:	89 08                	mov    %ecx,(%eax)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	88 02                	mov    %al,(%edx)
}
  8004f6:	5d                   	pop    %ebp
  8004f7:	c3                   	ret    

008004f8 <printfmt>:
{
  8004f8:	55                   	push   %ebp
  8004f9:	89 e5                	mov    %esp,%ebp
  8004fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800501:	50                   	push   %eax
  800502:	ff 75 10             	push   0x10(%ebp)
  800505:	ff 75 0c             	push   0xc(%ebp)
  800508:	ff 75 08             	push   0x8(%ebp)
  80050b:	e8 05 00 00 00       	call   800515 <vprintfmt>
}
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <vprintfmt>:
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	83 ec 3c             	sub    $0x3c,%esp
  80051e:	8b 75 08             	mov    0x8(%ebp),%esi
  800521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800524:	8b 7d 10             	mov    0x10(%ebp),%edi
  800527:	eb 0a                	jmp    800533 <vprintfmt+0x1e>
			putch(ch, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	50                   	push   %eax
  80052e:	ff d6                	call   *%esi
  800530:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	83 c7 01             	add    $0x1,%edi
  800536:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053a:	83 f8 25             	cmp    $0x25,%eax
  80053d:	74 0c                	je     80054b <vprintfmt+0x36>
			if (ch == '\0')
  80053f:	85 c0                	test   %eax,%eax
  800541:	75 e6                	jne    800529 <vprintfmt+0x14>
}
  800543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800546:	5b                   	pop    %ebx
  800547:	5e                   	pop    %esi
  800548:	5f                   	pop    %edi
  800549:	5d                   	pop    %ebp
  80054a:	c3                   	ret    
		padc = ' ';
  80054b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800556:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  80055d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800569:	8d 47 01             	lea    0x1(%edi),%eax
  80056c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80056f:	0f b6 17             	movzbl (%edi),%edx
  800572:	8d 42 dd             	lea    -0x23(%edx),%eax
  800575:	3c 55                	cmp    $0x55,%al
  800577:	0f 87 a6 04 00 00    	ja     800a23 <vprintfmt+0x50e>
  80057d:	0f b6 c0             	movzbl %al,%eax
  800580:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  800587:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  80058a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80058e:	eb d9                	jmp    800569 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800590:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800593:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800597:	eb d0                	jmp    800569 <vprintfmt+0x54>
  800599:	0f b6 d2             	movzbl %dl,%edx
  80059c:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059f:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005aa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ae:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005b1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b4:	83 f9 09             	cmp    $0x9,%ecx
  8005b7:	77 55                	ja     80060e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005b9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005bc:	eb e9                	jmp    8005a7 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005cf:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d6:	79 91                	jns    800569 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005e5:	eb 82                	jmp    800569 <vprintfmt+0x54>
  8005e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ea:	85 d2                	test   %edx,%edx
  8005ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f1:	0f 49 c2             	cmovns %edx,%eax
  8005f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005fa:	e9 6a ff ff ff       	jmp    800569 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005ff:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  800602:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800609:	e9 5b ff ff ff       	jmp    800569 <vprintfmt+0x54>
  80060e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800611:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800614:	eb bc                	jmp    8005d2 <vprintfmt+0xbd>
			lflag++;
  800616:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800619:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  80061c:	e9 48 ff ff ff       	jmp    800569 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 78 04             	lea    0x4(%eax),%edi
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	53                   	push   %ebx
  80062b:	ff 30                	push   (%eax)
  80062d:	ff d6                	call   *%esi
			break;
  80062f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800632:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800635:	e9 88 03 00 00       	jmp    8009c2 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 78 04             	lea    0x4(%eax),%edi
  800640:	8b 10                	mov    (%eax),%edx
  800642:	89 d0                	mov    %edx,%eax
  800644:	f7 d8                	neg    %eax
  800646:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800649:	83 f8 0f             	cmp    $0xf,%eax
  80064c:	7f 23                	jg     800671 <vprintfmt+0x15c>
  80064e:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800655:	85 d2                	test   %edx,%edx
  800657:	74 18                	je     800671 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800659:	52                   	push   %edx
  80065a:	68 fe 10 80 00       	push   $0x8010fe
  80065f:	53                   	push   %ebx
  800660:	56                   	push   %esi
  800661:	e8 92 fe ff ff       	call   8004f8 <printfmt>
  800666:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800669:	89 7d 14             	mov    %edi,0x14(%ebp)
  80066c:	e9 51 03 00 00       	jmp    8009c2 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800671:	50                   	push   %eax
  800672:	68 f5 10 80 00       	push   $0x8010f5
  800677:	53                   	push   %ebx
  800678:	56                   	push   %esi
  800679:	e8 7a fe ff ff       	call   8004f8 <printfmt>
  80067e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800681:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800684:	e9 39 03 00 00       	jmp    8009c2 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800697:	85 d2                	test   %edx,%edx
  800699:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  80069e:	0f 45 c2             	cmovne %edx,%eax
  8006a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a8:	7e 06                	jle    8006b0 <vprintfmt+0x19b>
  8006aa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006ae:	75 0d                	jne    8006bd <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006b3:	89 c7                	mov    %eax,%edi
  8006b5:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006bb:	eb 55                	jmp    800712 <vprintfmt+0x1fd>
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 e0             	push   -0x20(%ebp)
  8006c3:	ff 75 cc             	push   -0x34(%ebp)
  8006c6:	e8 f5 03 00 00       	call   800ac0 <strnlen>
  8006cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ce:	29 c2                	sub    %eax,%edx
  8006d0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006df:	eb 0f                	jmp    8006f0 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	ff 75 d4             	push   -0x2c(%ebp)
  8006e8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ea:	83 ef 01             	sub    $0x1,%edi
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	85 ff                	test   %edi,%edi
  8006f2:	7f ed                	jg     8006e1 <vprintfmt+0x1cc>
  8006f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fe:	0f 49 c2             	cmovns %edx,%eax
  800701:	29 c2                	sub    %eax,%edx
  800703:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800706:	eb a8                	jmp    8006b0 <vprintfmt+0x19b>
					putch(ch, putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	52                   	push   %edx
  80070d:	ff d6                	call   *%esi
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800715:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800717:	83 c7 01             	add    $0x1,%edi
  80071a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071e:	0f be d0             	movsbl %al,%edx
  800721:	85 d2                	test   %edx,%edx
  800723:	74 4b                	je     800770 <vprintfmt+0x25b>
  800725:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800729:	78 06                	js     800731 <vprintfmt+0x21c>
  80072b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80072f:	78 1e                	js     80074f <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800731:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800735:	74 d1                	je     800708 <vprintfmt+0x1f3>
  800737:	0f be c0             	movsbl %al,%eax
  80073a:	83 e8 20             	sub    $0x20,%eax
  80073d:	83 f8 5e             	cmp    $0x5e,%eax
  800740:	76 c6                	jbe    800708 <vprintfmt+0x1f3>
					putch('?', putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	6a 3f                	push   $0x3f
  800748:	ff d6                	call   *%esi
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	eb c3                	jmp    800712 <vprintfmt+0x1fd>
  80074f:	89 cf                	mov    %ecx,%edi
  800751:	eb 0e                	jmp    800761 <vprintfmt+0x24c>
				putch(' ', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 20                	push   $0x20
  800759:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80075b:	83 ef 01             	sub    $0x1,%edi
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	85 ff                	test   %edi,%edi
  800763:	7f ee                	jg     800753 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800765:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800768:	89 45 14             	mov    %eax,0x14(%ebp)
  80076b:	e9 52 02 00 00       	jmp    8009c2 <vprintfmt+0x4ad>
  800770:	89 cf                	mov    %ecx,%edi
  800772:	eb ed                	jmp    800761 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	83 c0 04             	add    $0x4,%eax
  80077a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800782:	85 d2                	test   %edx,%edx
  800784:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  800789:	0f 45 c2             	cmovne %edx,%eax
  80078c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80078f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800793:	7e 06                	jle    80079b <vprintfmt+0x286>
  800795:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800799:	75 0d                	jne    8007a8 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  80079b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80079e:	89 c7                	mov    %eax,%edi
  8007a0:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007a6:	eb 55                	jmp    8007fd <vprintfmt+0x2e8>
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 e0             	push   -0x20(%ebp)
  8007ae:	ff 75 cc             	push   -0x34(%ebp)
  8007b1:	e8 0a 03 00 00       	call   800ac0 <strnlen>
  8007b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b9:	29 c2                	sub    %eax,%edx
  8007bb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007c3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ca:	eb 0f                	jmp    8007db <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	ff 75 d4             	push   -0x2c(%ebp)
  8007d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d5:	83 ef 01             	sub    $0x1,%edi
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	85 ff                	test   %edi,%edi
  8007dd:	7f ed                	jg     8007cc <vprintfmt+0x2b7>
  8007df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007e2:	85 d2                	test   %edx,%edx
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e9:	0f 49 c2             	cmovns %edx,%eax
  8007ec:	29 c2                	sub    %eax,%edx
  8007ee:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007f1:	eb a8                	jmp    80079b <vprintfmt+0x286>
					putch(ch, putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	52                   	push   %edx
  8007f8:	ff d6                	call   *%esi
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800800:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800802:	83 c7 01             	add    $0x1,%edi
  800805:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800809:	0f be d0             	movsbl %al,%edx
  80080c:	3c 3a                	cmp    $0x3a,%al
  80080e:	74 4b                	je     80085b <vprintfmt+0x346>
  800810:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800814:	78 06                	js     80081c <vprintfmt+0x307>
  800816:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80081a:	78 1e                	js     80083a <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  80081c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800820:	74 d1                	je     8007f3 <vprintfmt+0x2de>
  800822:	0f be c0             	movsbl %al,%eax
  800825:	83 e8 20             	sub    $0x20,%eax
  800828:	83 f8 5e             	cmp    $0x5e,%eax
  80082b:	76 c6                	jbe    8007f3 <vprintfmt+0x2de>
					putch('?', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	53                   	push   %ebx
  800831:	6a 3f                	push   $0x3f
  800833:	ff d6                	call   *%esi
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	eb c3                	jmp    8007fd <vprintfmt+0x2e8>
  80083a:	89 cf                	mov    %ecx,%edi
  80083c:	eb 0e                	jmp    80084c <vprintfmt+0x337>
				putch(' ', putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	6a 20                	push   $0x20
  800844:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800846:	83 ef 01             	sub    $0x1,%edi
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	85 ff                	test   %edi,%edi
  80084e:	7f ee                	jg     80083e <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800850:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
  800856:	e9 67 01 00 00       	jmp    8009c2 <vprintfmt+0x4ad>
  80085b:	89 cf                	mov    %ecx,%edi
  80085d:	eb ed                	jmp    80084c <vprintfmt+0x337>
	if (lflag >= 2)
  80085f:	83 f9 01             	cmp    $0x1,%ecx
  800862:	7f 1b                	jg     80087f <vprintfmt+0x36a>
	else if (lflag)
  800864:	85 c9                	test   %ecx,%ecx
  800866:	74 63                	je     8008cb <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800870:	99                   	cltd   
  800871:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 04             	lea    0x4(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	eb 17                	jmp    800896 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 50 04             	mov    0x4(%eax),%edx
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 08             	lea    0x8(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  80089c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008a1:	85 c9                	test   %ecx,%ecx
  8008a3:	0f 89 ff 00 00 00    	jns    8009a8 <vprintfmt+0x493>
				putch('-', putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 2d                	push   $0x2d
  8008af:	ff d6                	call   *%esi
				num = -(long long) num;
  8008b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008b7:	f7 da                	neg    %edx
  8008b9:	83 d1 00             	adc    $0x0,%ecx
  8008bc:	f7 d9                	neg    %ecx
  8008be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008c6:	e9 dd 00 00 00       	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008d3:	99                   	cltd   
  8008d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 40 04             	lea    0x4(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	eb b4                	jmp    800896 <vprintfmt+0x381>
	if (lflag >= 2)
  8008e2:	83 f9 01             	cmp    $0x1,%ecx
  8008e5:	7f 1e                	jg     800905 <vprintfmt+0x3f0>
	else if (lflag)
  8008e7:	85 c9                	test   %ecx,%ecx
  8008e9:	74 32                	je     80091d <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8b 10                	mov    (%eax),%edx
  8008f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f5:	8d 40 04             	lea    0x4(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fb:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800900:	e9 a3 00 00 00       	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 10                	mov    (%eax),%edx
  80090a:	8b 48 04             	mov    0x4(%eax),%ecx
  80090d:	8d 40 08             	lea    0x8(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800913:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800918:	e9 8b 00 00 00       	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 10                	mov    (%eax),%edx
  800922:	b9 00 00 00 00       	mov    $0x0,%ecx
  800927:	8d 40 04             	lea    0x4(%eax),%eax
  80092a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80092d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800932:	eb 74                	jmp    8009a8 <vprintfmt+0x493>
	if (lflag >= 2)
  800934:	83 f9 01             	cmp    $0x1,%ecx
  800937:	7f 1b                	jg     800954 <vprintfmt+0x43f>
	else if (lflag)
  800939:	85 c9                	test   %ecx,%ecx
  80093b:	74 2c                	je     800969 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 10                	mov    (%eax),%edx
  800942:	b9 00 00 00 00       	mov    $0x0,%ecx
  800947:	8d 40 04             	lea    0x4(%eax),%eax
  80094a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80094d:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800952:	eb 54                	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	8b 10                	mov    (%eax),%edx
  800959:	8b 48 04             	mov    0x4(%eax),%ecx
  80095c:	8d 40 08             	lea    0x8(%eax),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800962:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800967:	eb 3f                	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8b 10                	mov    (%eax),%edx
  80096e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800973:	8d 40 04             	lea    0x4(%eax),%eax
  800976:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800979:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80097e:	eb 28                	jmp    8009a8 <vprintfmt+0x493>
			putch('0', putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	53                   	push   %ebx
  800984:	6a 30                	push   $0x30
  800986:	ff d6                	call   *%esi
			putch('x', putdat);
  800988:	83 c4 08             	add    $0x8,%esp
  80098b:	53                   	push   %ebx
  80098c:	6a 78                	push   $0x78
  80098e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8b 10                	mov    (%eax),%edx
  800995:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80099a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80099d:	8d 40 04             	lea    0x4(%eax),%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a3:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	ff 75 d4             	push   -0x2c(%ebp)
  8009b3:	57                   	push   %edi
  8009b4:	51                   	push   %ecx
  8009b5:	52                   	push   %edx
  8009b6:	89 da                	mov    %ebx,%edx
  8009b8:	89 f0                	mov    %esi,%eax
  8009ba:	e8 73 fa ff ff       	call   800432 <printnum>
			break;
  8009bf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009c2:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c5:	e9 69 fb ff ff       	jmp    800533 <vprintfmt+0x1e>
	if (lflag >= 2)
  8009ca:	83 f9 01             	cmp    $0x1,%ecx
  8009cd:	7f 1b                	jg     8009ea <vprintfmt+0x4d5>
	else if (lflag)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 2c                	je     8009ff <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d6:	8b 10                	mov    (%eax),%edx
  8009d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009dd:	8d 40 04             	lea    0x4(%eax),%eax
  8009e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e3:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009e8:	eb be                	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8b 10                	mov    (%eax),%edx
  8009ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8009f2:	8d 40 08             	lea    0x8(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f8:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009fd:	eb a9                	jmp    8009a8 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a09:	8d 40 04             	lea    0x4(%eax),%eax
  800a0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0f:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a14:	eb 92                	jmp    8009a8 <vprintfmt+0x493>
			putch(ch, putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	53                   	push   %ebx
  800a1a:	6a 25                	push   $0x25
  800a1c:	ff d6                	call   *%esi
			break;
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	eb 9f                	jmp    8009c2 <vprintfmt+0x4ad>
			putch('%', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	53                   	push   %ebx
  800a27:	6a 25                	push   $0x25
  800a29:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	89 f8                	mov    %edi,%eax
  800a30:	eb 03                	jmp    800a35 <vprintfmt+0x520>
  800a32:	83 e8 01             	sub    $0x1,%eax
  800a35:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a39:	75 f7                	jne    800a32 <vprintfmt+0x51d>
  800a3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a3e:	eb 82                	jmp    8009c2 <vprintfmt+0x4ad>

00800a40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 18             	sub    $0x18,%esp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a53:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	74 26                	je     800a87 <vsnprintf+0x47>
  800a61:	85 d2                	test   %edx,%edx
  800a63:	7e 22                	jle    800a87 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a65:	ff 75 14             	push   0x14(%ebp)
  800a68:	ff 75 10             	push   0x10(%ebp)
  800a6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6e:	50                   	push   %eax
  800a6f:	68 db 04 80 00       	push   $0x8004db
  800a74:	e8 9c fa ff ff       	call   800515 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a82:	83 c4 10             	add    $0x10,%esp
}
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    
		return -E_INVAL;
  800a87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a8c:	eb f7                	jmp    800a85 <vsnprintf+0x45>

00800a8e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a94:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a97:	50                   	push   %eax
  800a98:	ff 75 10             	push   0x10(%ebp)
  800a9b:	ff 75 0c             	push   0xc(%ebp)
  800a9e:	ff 75 08             	push   0x8(%ebp)
  800aa1:	e8 9a ff ff ff       	call   800a40 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	eb 03                	jmp    800ab8 <strlen+0x10>
		n++;
  800ab5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ab8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800abc:	75 f7                	jne    800ab5 <strlen+0xd>
	return n;
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ace:	eb 03                	jmp    800ad3 <strnlen+0x13>
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad3:	39 d0                	cmp    %edx,%eax
  800ad5:	74 08                	je     800adf <strnlen+0x1f>
  800ad7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800adb:	75 f3                	jne    800ad0 <strnlen+0x10>
  800add:	89 c2                	mov    %eax,%edx
	return n;
}
  800adf:	89 d0                	mov    %edx,%eax
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	53                   	push   %ebx
  800ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800af6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800af9:	83 c0 01             	add    $0x1,%eax
  800afc:	84 d2                	test   %dl,%dl
  800afe:	75 f2                	jne    800af2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b00:	89 c8                	mov    %ecx,%eax
  800b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 10             	sub    $0x10,%esp
  800b0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b11:	53                   	push   %ebx
  800b12:	e8 91 ff ff ff       	call   800aa8 <strlen>
  800b17:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b1a:	ff 75 0c             	push   0xc(%ebp)
  800b1d:	01 d8                	add    %ebx,%eax
  800b1f:	50                   	push   %eax
  800b20:	e8 be ff ff ff       	call   800ae3 <strcpy>
	return dst;
}
  800b25:	89 d8                	mov    %ebx,%eax
  800b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 75 08             	mov    0x8(%ebp),%esi
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 f3                	mov    %esi,%ebx
  800b39:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b3c:	89 f0                	mov    %esi,%eax
  800b3e:	eb 0f                	jmp    800b4f <strncpy+0x23>
		*dst++ = *src;
  800b40:	83 c0 01             	add    $0x1,%eax
  800b43:	0f b6 0a             	movzbl (%edx),%ecx
  800b46:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b49:	80 f9 01             	cmp    $0x1,%cl
  800b4c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b4f:	39 d8                	cmp    %ebx,%eax
  800b51:	75 ed                	jne    800b40 <strncpy+0x14>
	}
	return ret;
}
  800b53:	89 f0                	mov    %esi,%eax
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800b61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b64:	8b 55 10             	mov    0x10(%ebp),%edx
  800b67:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b69:	85 d2                	test   %edx,%edx
  800b6b:	74 21                	je     800b8e <strlcpy+0x35>
  800b6d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b71:	89 f2                	mov    %esi,%edx
  800b73:	eb 09                	jmp    800b7e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b75:	83 c1 01             	add    $0x1,%ecx
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b7e:	39 c2                	cmp    %eax,%edx
  800b80:	74 09                	je     800b8b <strlcpy+0x32>
  800b82:	0f b6 19             	movzbl (%ecx),%ebx
  800b85:	84 db                	test   %bl,%bl
  800b87:	75 ec                	jne    800b75 <strlcpy+0x1c>
  800b89:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b8b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8e:	29 f0                	sub    %esi,%eax
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b9d:	eb 06                	jmp    800ba5 <strcmp+0x11>
		p++, q++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
  800ba2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ba5:	0f b6 01             	movzbl (%ecx),%eax
  800ba8:	84 c0                	test   %al,%al
  800baa:	74 04                	je     800bb0 <strcmp+0x1c>
  800bac:	3a 02                	cmp    (%edx),%al
  800bae:	74 ef                	je     800b9f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb0:	0f b6 c0             	movzbl %al,%eax
  800bb3:	0f b6 12             	movzbl (%edx),%edx
  800bb6:	29 d0                	sub    %edx,%eax
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	53                   	push   %ebx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc4:	89 c3                	mov    %eax,%ebx
  800bc6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc9:	eb 06                	jmp    800bd1 <strncmp+0x17>
		n--, p++, q++;
  800bcb:	83 c0 01             	add    $0x1,%eax
  800bce:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bd1:	39 d8                	cmp    %ebx,%eax
  800bd3:	74 18                	je     800bed <strncmp+0x33>
  800bd5:	0f b6 08             	movzbl (%eax),%ecx
  800bd8:	84 c9                	test   %cl,%cl
  800bda:	74 04                	je     800be0 <strncmp+0x26>
  800bdc:	3a 0a                	cmp    (%edx),%cl
  800bde:	74 eb                	je     800bcb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800be0:	0f b6 00             	movzbl (%eax),%eax
  800be3:	0f b6 12             	movzbl (%edx),%edx
  800be6:	29 d0                	sub    %edx,%eax
}
  800be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    
		return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	eb f4                	jmp    800be8 <strncmp+0x2e>

00800bf4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfe:	eb 03                	jmp    800c03 <strchr+0xf>
  800c00:	83 c0 01             	add    $0x1,%eax
  800c03:	0f b6 10             	movzbl (%eax),%edx
  800c06:	84 d2                	test   %dl,%dl
  800c08:	74 06                	je     800c10 <strchr+0x1c>
		if (*s == c)
  800c0a:	38 ca                	cmp    %cl,%dl
  800c0c:	75 f2                	jne    800c00 <strchr+0xc>
  800c0e:	eb 05                	jmp    800c15 <strchr+0x21>
			return (char *) s;
	return 0;
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c21:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c24:	38 ca                	cmp    %cl,%dl
  800c26:	74 09                	je     800c31 <strfind+0x1a>
  800c28:	84 d2                	test   %dl,%dl
  800c2a:	74 05                	je     800c31 <strfind+0x1a>
	for (; *s; s++)
  800c2c:	83 c0 01             	add    $0x1,%eax
  800c2f:	eb f0                	jmp    800c21 <strfind+0xa>
			break;
	return (char *) s;
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c3f:	85 c9                	test   %ecx,%ecx
  800c41:	74 2f                	je     800c72 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c43:	89 f8                	mov    %edi,%eax
  800c45:	09 c8                	or     %ecx,%eax
  800c47:	a8 03                	test   $0x3,%al
  800c49:	75 21                	jne    800c6c <memset+0x39>
		c &= 0xFF;
  800c4b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	c1 e0 08             	shl    $0x8,%eax
  800c54:	89 d3                	mov    %edx,%ebx
  800c56:	c1 e3 18             	shl    $0x18,%ebx
  800c59:	89 d6                	mov    %edx,%esi
  800c5b:	c1 e6 10             	shl    $0x10,%esi
  800c5e:	09 f3                	or     %esi,%ebx
  800c60:	09 da                	or     %ebx,%edx
  800c62:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c64:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c67:	fc                   	cld    
  800c68:	f3 ab                	rep stos %eax,%es:(%edi)
  800c6a:	eb 06                	jmp    800c72 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	fc                   	cld    
  800c70:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c72:	89 f8                	mov    %edi,%eax
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c84:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c87:	39 c6                	cmp    %eax,%esi
  800c89:	73 32                	jae    800cbd <memmove+0x44>
  800c8b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c8e:	39 c2                	cmp    %eax,%edx
  800c90:	76 2b                	jbe    800cbd <memmove+0x44>
		s += n;
		d += n;
  800c92:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c95:	89 d6                	mov    %edx,%esi
  800c97:	09 fe                	or     %edi,%esi
  800c99:	09 ce                	or     %ecx,%esi
  800c9b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ca1:	75 0e                	jne    800cb1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ca3:	83 ef 04             	sub    $0x4,%edi
  800ca6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cac:	fd                   	std    
  800cad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800caf:	eb 09                	jmp    800cba <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cb1:	83 ef 01             	sub    $0x1,%edi
  800cb4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cb7:	fd                   	std    
  800cb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cba:	fc                   	cld    
  800cbb:	eb 1a                	jmp    800cd7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cbd:	89 f2                	mov    %esi,%edx
  800cbf:	09 c2                	or     %eax,%edx
  800cc1:	09 ca                	or     %ecx,%edx
  800cc3:	f6 c2 03             	test   $0x3,%dl
  800cc6:	75 0a                	jne    800cd2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cc8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ccb:	89 c7                	mov    %eax,%edi
  800ccd:	fc                   	cld    
  800cce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cd0:	eb 05                	jmp    800cd7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cd2:	89 c7                	mov    %eax,%edi
  800cd4:	fc                   	cld    
  800cd5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ce1:	ff 75 10             	push   0x10(%ebp)
  800ce4:	ff 75 0c             	push   0xc(%ebp)
  800ce7:	ff 75 08             	push   0x8(%ebp)
  800cea:	e8 8a ff ff ff       	call   800c79 <memmove>
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	89 c6                	mov    %eax,%esi
  800cfe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d01:	eb 06                	jmp    800d09 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d03:	83 c0 01             	add    $0x1,%eax
  800d06:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d09:	39 f0                	cmp    %esi,%eax
  800d0b:	74 14                	je     800d21 <memcmp+0x30>
		if (*s1 != *s2)
  800d0d:	0f b6 08             	movzbl (%eax),%ecx
  800d10:	0f b6 1a             	movzbl (%edx),%ebx
  800d13:	38 d9                	cmp    %bl,%cl
  800d15:	74 ec                	je     800d03 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d17:	0f b6 c1             	movzbl %cl,%eax
  800d1a:	0f b6 db             	movzbl %bl,%ebx
  800d1d:	29 d8                	sub    %ebx,%eax
  800d1f:	eb 05                	jmp    800d26 <memcmp+0x35>
	}

	return 0;
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d33:	89 c2                	mov    %eax,%edx
  800d35:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d38:	eb 03                	jmp    800d3d <memfind+0x13>
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	39 d0                	cmp    %edx,%eax
  800d3f:	73 04                	jae    800d45 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d41:	38 08                	cmp    %cl,(%eax)
  800d43:	75 f5                	jne    800d3a <memfind+0x10>
			break;
	return (void *) s;
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d53:	eb 03                	jmp    800d58 <strtol+0x11>
		s++;
  800d55:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d58:	0f b6 02             	movzbl (%edx),%eax
  800d5b:	3c 20                	cmp    $0x20,%al
  800d5d:	74 f6                	je     800d55 <strtol+0xe>
  800d5f:	3c 09                	cmp    $0x9,%al
  800d61:	74 f2                	je     800d55 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d63:	3c 2b                	cmp    $0x2b,%al
  800d65:	74 2a                	je     800d91 <strtol+0x4a>
	int neg = 0;
  800d67:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d6c:	3c 2d                	cmp    $0x2d,%al
  800d6e:	74 2b                	je     800d9b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d70:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d76:	75 0f                	jne    800d87 <strtol+0x40>
  800d78:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7b:	74 28                	je     800da5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d7d:	85 db                	test   %ebx,%ebx
  800d7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d84:	0f 44 d8             	cmove  %eax,%ebx
  800d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d8f:	eb 46                	jmp    800dd7 <strtol+0x90>
		s++;
  800d91:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d94:	bf 00 00 00 00       	mov    $0x0,%edi
  800d99:	eb d5                	jmp    800d70 <strtol+0x29>
		s++, neg = 1;
  800d9b:	83 c2 01             	add    $0x1,%edx
  800d9e:	bf 01 00 00 00       	mov    $0x1,%edi
  800da3:	eb cb                	jmp    800d70 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da5:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800da9:	74 0e                	je     800db9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dab:	85 db                	test   %ebx,%ebx
  800dad:	75 d8                	jne    800d87 <strtol+0x40>
		s++, base = 8;
  800daf:	83 c2 01             	add    $0x1,%edx
  800db2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800db7:	eb ce                	jmp    800d87 <strtol+0x40>
		s += 2, base = 16;
  800db9:	83 c2 02             	add    $0x2,%edx
  800dbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dc1:	eb c4                	jmp    800d87 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dc3:	0f be c0             	movsbl %al,%eax
  800dc6:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dcc:	7d 3a                	jge    800e08 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dd5:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dd7:	0f b6 02             	movzbl (%edx),%eax
  800dda:	8d 70 d0             	lea    -0x30(%eax),%esi
  800ddd:	89 f3                	mov    %esi,%ebx
  800ddf:	80 fb 09             	cmp    $0x9,%bl
  800de2:	76 df                	jbe    800dc3 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800de4:	8d 70 9f             	lea    -0x61(%eax),%esi
  800de7:	89 f3                	mov    %esi,%ebx
  800de9:	80 fb 19             	cmp    $0x19,%bl
  800dec:	77 08                	ja     800df6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dee:	0f be c0             	movsbl %al,%eax
  800df1:	83 e8 57             	sub    $0x57,%eax
  800df4:	eb d3                	jmp    800dc9 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800df6:	8d 70 bf             	lea    -0x41(%eax),%esi
  800df9:	89 f3                	mov    %esi,%ebx
  800dfb:	80 fb 19             	cmp    $0x19,%bl
  800dfe:	77 08                	ja     800e08 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e00:	0f be c0             	movsbl %al,%eax
  800e03:	83 e8 37             	sub    $0x37,%eax
  800e06:	eb c1                	jmp    800dc9 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0c:	74 05                	je     800e13 <strtol+0xcc>
		*endptr = (char *) s;
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e13:	89 c8                	mov    %ecx,%eax
  800e15:	f7 d8                	neg    %eax
  800e17:	85 ff                	test   %edi,%edi
  800e19:	0f 45 c8             	cmovne %eax,%ecx
}
  800e1c:	89 c8                	mov    %ecx,%eax
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
  800e23:	66 90                	xchg   %ax,%ax
  800e25:	66 90                	xchg   %ax,%ax
  800e27:	66 90                	xchg   %ax,%ax
  800e29:	66 90                	xchg   %ax,%ax
  800e2b:	66 90                	xchg   %ax,%ax
  800e2d:	66 90                	xchg   %ax,%ax
  800e2f:	90                   	nop

00800e30 <__udivdi3>:
  800e30:	f3 0f 1e fb          	endbr32 
  800e34:	55                   	push   %ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 1c             	sub    $0x1c,%esp
  800e3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e43:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	75 19                	jne    800e68 <__udivdi3+0x38>
  800e4f:	39 f3                	cmp    %esi,%ebx
  800e51:	76 4d                	jbe    800ea0 <__udivdi3+0x70>
  800e53:	31 ff                	xor    %edi,%edi
  800e55:	89 e8                	mov    %ebp,%eax
  800e57:	89 f2                	mov    %esi,%edx
  800e59:	f7 f3                	div    %ebx
  800e5b:	89 fa                	mov    %edi,%edx
  800e5d:	83 c4 1c             	add    $0x1c,%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
  800e65:	8d 76 00             	lea    0x0(%esi),%esi
  800e68:	39 f0                	cmp    %esi,%eax
  800e6a:	76 14                	jbe    800e80 <__udivdi3+0x50>
  800e6c:	31 ff                	xor    %edi,%edi
  800e6e:	31 c0                	xor    %eax,%eax
  800e70:	89 fa                	mov    %edi,%edx
  800e72:	83 c4 1c             	add    $0x1c,%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
  800e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e80:	0f bd f8             	bsr    %eax,%edi
  800e83:	83 f7 1f             	xor    $0x1f,%edi
  800e86:	75 48                	jne    800ed0 <__udivdi3+0xa0>
  800e88:	39 f0                	cmp    %esi,%eax
  800e8a:	72 06                	jb     800e92 <__udivdi3+0x62>
  800e8c:	31 c0                	xor    %eax,%eax
  800e8e:	39 eb                	cmp    %ebp,%ebx
  800e90:	77 de                	ja     800e70 <__udivdi3+0x40>
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	eb d7                	jmp    800e70 <__udivdi3+0x40>
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	89 d9                	mov    %ebx,%ecx
  800ea2:	85 db                	test   %ebx,%ebx
  800ea4:	75 0b                	jne    800eb1 <__udivdi3+0x81>
  800ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  800eab:	31 d2                	xor    %edx,%edx
  800ead:	f7 f3                	div    %ebx
  800eaf:	89 c1                	mov    %eax,%ecx
  800eb1:	31 d2                	xor    %edx,%edx
  800eb3:	89 f0                	mov    %esi,%eax
  800eb5:	f7 f1                	div    %ecx
  800eb7:	89 c6                	mov    %eax,%esi
  800eb9:	89 e8                	mov    %ebp,%eax
  800ebb:	89 f7                	mov    %esi,%edi
  800ebd:	f7 f1                	div    %ecx
  800ebf:	89 fa                	mov    %edi,%edx
  800ec1:	83 c4 1c             	add    $0x1c,%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
  800ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ed0:	89 f9                	mov    %edi,%ecx
  800ed2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ed7:	29 fa                	sub    %edi,%edx
  800ed9:	d3 e0                	shl    %cl,%eax
  800edb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800edf:	89 d1                	mov    %edx,%ecx
  800ee1:	89 d8                	mov    %ebx,%eax
  800ee3:	d3 e8                	shr    %cl,%eax
  800ee5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ee9:	09 c1                	or     %eax,%ecx
  800eeb:	89 f0                	mov    %esi,%eax
  800eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ef1:	89 f9                	mov    %edi,%ecx
  800ef3:	d3 e3                	shl    %cl,%ebx
  800ef5:	89 d1                	mov    %edx,%ecx
  800ef7:	d3 e8                	shr    %cl,%eax
  800ef9:	89 f9                	mov    %edi,%ecx
  800efb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800eff:	89 eb                	mov    %ebp,%ebx
  800f01:	d3 e6                	shl    %cl,%esi
  800f03:	89 d1                	mov    %edx,%ecx
  800f05:	d3 eb                	shr    %cl,%ebx
  800f07:	09 f3                	or     %esi,%ebx
  800f09:	89 c6                	mov    %eax,%esi
  800f0b:	89 f2                	mov    %esi,%edx
  800f0d:	89 d8                	mov    %ebx,%eax
  800f0f:	f7 74 24 08          	divl   0x8(%esp)
  800f13:	89 d6                	mov    %edx,%esi
  800f15:	89 c3                	mov    %eax,%ebx
  800f17:	f7 64 24 0c          	mull   0xc(%esp)
  800f1b:	39 d6                	cmp    %edx,%esi
  800f1d:	72 19                	jb     800f38 <__udivdi3+0x108>
  800f1f:	89 f9                	mov    %edi,%ecx
  800f21:	d3 e5                	shl    %cl,%ebp
  800f23:	39 c5                	cmp    %eax,%ebp
  800f25:	73 04                	jae    800f2b <__udivdi3+0xfb>
  800f27:	39 d6                	cmp    %edx,%esi
  800f29:	74 0d                	je     800f38 <__udivdi3+0x108>
  800f2b:	89 d8                	mov    %ebx,%eax
  800f2d:	31 ff                	xor    %edi,%edi
  800f2f:	e9 3c ff ff ff       	jmp    800e70 <__udivdi3+0x40>
  800f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f3b:	31 ff                	xor    %edi,%edi
  800f3d:	e9 2e ff ff ff       	jmp    800e70 <__udivdi3+0x40>
  800f42:	66 90                	xchg   %ax,%ax
  800f44:	66 90                	xchg   %ax,%ax
  800f46:	66 90                	xchg   %ax,%ax
  800f48:	66 90                	xchg   %ax,%ax
  800f4a:	66 90                	xchg   %ax,%ax
  800f4c:	66 90                	xchg   %ax,%ax
  800f4e:	66 90                	xchg   %ax,%ax

00800f50 <__umoddi3>:
  800f50:	f3 0f 1e fb          	endbr32 
  800f54:	55                   	push   %ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 1c             	sub    $0x1c,%esp
  800f5b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f5f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f63:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800f67:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800f6b:	89 f0                	mov    %esi,%eax
  800f6d:	89 da                	mov    %ebx,%edx
  800f6f:	85 ff                	test   %edi,%edi
  800f71:	75 15                	jne    800f88 <__umoddi3+0x38>
  800f73:	39 dd                	cmp    %ebx,%ebp
  800f75:	76 39                	jbe    800fb0 <__umoddi3+0x60>
  800f77:	f7 f5                	div    %ebp
  800f79:	89 d0                	mov    %edx,%eax
  800f7b:	31 d2                	xor    %edx,%edx
  800f7d:	83 c4 1c             	add    $0x1c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	8d 76 00             	lea    0x0(%esi),%esi
  800f88:	39 df                	cmp    %ebx,%edi
  800f8a:	77 f1                	ja     800f7d <__umoddi3+0x2d>
  800f8c:	0f bd cf             	bsr    %edi,%ecx
  800f8f:	83 f1 1f             	xor    $0x1f,%ecx
  800f92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f96:	75 40                	jne    800fd8 <__umoddi3+0x88>
  800f98:	39 df                	cmp    %ebx,%edi
  800f9a:	72 04                	jb     800fa0 <__umoddi3+0x50>
  800f9c:	39 f5                	cmp    %esi,%ebp
  800f9e:	77 dd                	ja     800f7d <__umoddi3+0x2d>
  800fa0:	89 da                	mov    %ebx,%edx
  800fa2:	89 f0                	mov    %esi,%eax
  800fa4:	29 e8                	sub    %ebp,%eax
  800fa6:	19 fa                	sbb    %edi,%edx
  800fa8:	eb d3                	jmp    800f7d <__umoddi3+0x2d>
  800faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fb0:	89 e9                	mov    %ebp,%ecx
  800fb2:	85 ed                	test   %ebp,%ebp
  800fb4:	75 0b                	jne    800fc1 <__umoddi3+0x71>
  800fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	f7 f5                	div    %ebp
  800fbf:	89 c1                	mov    %eax,%ecx
  800fc1:	89 d8                	mov    %ebx,%eax
  800fc3:	31 d2                	xor    %edx,%edx
  800fc5:	f7 f1                	div    %ecx
  800fc7:	89 f0                	mov    %esi,%eax
  800fc9:	f7 f1                	div    %ecx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	31 d2                	xor    %edx,%edx
  800fcf:	eb ac                	jmp    800f7d <__umoddi3+0x2d>
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fdc:	ba 20 00 00 00       	mov    $0x20,%edx
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 c1                	mov    %eax,%ecx
  800fe5:	89 e8                	mov    %ebp,%eax
  800fe7:	d3 e7                	shl    %cl,%edi
  800fe9:	89 d1                	mov    %edx,%ecx
  800feb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fef:	d3 e8                	shr    %cl,%eax
  800ff1:	89 c1                	mov    %eax,%ecx
  800ff3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ff7:	09 f9                	or     %edi,%ecx
  800ff9:	89 df                	mov    %ebx,%edi
  800ffb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fff:	89 c1                	mov    %eax,%ecx
  801001:	d3 e5                	shl    %cl,%ebp
  801003:	89 d1                	mov    %edx,%ecx
  801005:	d3 ef                	shr    %cl,%edi
  801007:	89 c1                	mov    %eax,%ecx
  801009:	89 f0                	mov    %esi,%eax
  80100b:	d3 e3                	shl    %cl,%ebx
  80100d:	89 d1                	mov    %edx,%ecx
  80100f:	89 fa                	mov    %edi,%edx
  801011:	d3 e8                	shr    %cl,%eax
  801013:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801018:	09 d8                	or     %ebx,%eax
  80101a:	f7 74 24 08          	divl   0x8(%esp)
  80101e:	89 d3                	mov    %edx,%ebx
  801020:	d3 e6                	shl    %cl,%esi
  801022:	f7 e5                	mul    %ebp
  801024:	89 c7                	mov    %eax,%edi
  801026:	89 d1                	mov    %edx,%ecx
  801028:	39 d3                	cmp    %edx,%ebx
  80102a:	72 06                	jb     801032 <__umoddi3+0xe2>
  80102c:	75 0e                	jne    80103c <__umoddi3+0xec>
  80102e:	39 c6                	cmp    %eax,%esi
  801030:	73 0a                	jae    80103c <__umoddi3+0xec>
  801032:	29 e8                	sub    %ebp,%eax
  801034:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801038:	89 d1                	mov    %edx,%ecx
  80103a:	89 c7                	mov    %eax,%edi
  80103c:	89 f5                	mov    %esi,%ebp
  80103e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801042:	29 fd                	sub    %edi,%ebp
  801044:	19 cb                	sbb    %ecx,%ebx
  801046:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80104b:	89 d8                	mov    %ebx,%eax
  80104d:	d3 e0                	shl    %cl,%eax
  80104f:	89 f1                	mov    %esi,%ecx
  801051:	d3 ed                	shr    %cl,%ebp
  801053:	d3 eb                	shr    %cl,%ebx
  801055:	09 e8                	or     %ebp,%eax
  801057:	89 da                	mov    %ebx,%edx
  801059:	83 c4 1c             	add    $0x1c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
