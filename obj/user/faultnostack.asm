
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 59 03 80 00       	push   $0x800359
  80003e:	6a 00                	push   $0x0
  800040:	e8 6e 02 00 00       	call   8002b3 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 c6 00 00 00       	call   80012a <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 42 00 00 00       	call   8000e9 <sys_env_destroy>
}
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	c9                   	leave  
  8000ab:	c3                   	ret    

008000ac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	89 c7                	mov    %eax,%edi
  8000c1:	89 c6                	mov    %eax,%esi
  8000c3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000da:	89 d1                	mov    %edx,%ecx
  8000dc:	89 d3                	mov    %edx,%ebx
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	89 d6                	mov    %edx,%esi
  8000e2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ff:	89 cb                	mov    %ecx,%ebx
  800101:	89 cf                	mov    %ecx,%edi
  800103:	89 ce                	mov    %ecx,%esi
  800105:	cd 30                	int    $0x30
	if(check && ret > 0)
  800107:	85 c0                	test   %eax,%eax
  800109:	7f 08                	jg     800113 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	50                   	push   %eax
  800117:	6a 03                	push   $0x3
  800119:	68 2a 11 80 00       	push   $0x80112a
  80011e:	6a 23                	push   $0x23
  800120:	68 47 11 80 00       	push   $0x801147
  800125:	e8 53 02 00 00       	call   80037d <_panic>

0080012a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 02 00 00 00       	mov    $0x2,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_yield>:

void
sys_yield(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014f:	ba 00 00 00 00       	mov    $0x0,%edx
  800154:	b8 0b 00 00 00       	mov    $0xb,%eax
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	89 d3                	mov    %edx,%ebx
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	89 d6                	mov    %edx,%esi
  800161:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	57                   	push   %edi
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800171:	be 00 00 00 00       	mov    $0x0,%esi
  800176:	8b 55 08             	mov    0x8(%ebp),%edx
  800179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017c:	b8 04 00 00 00       	mov    $0x4,%eax
  800181:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800184:	89 f7                	mov    %esi,%edi
  800186:	cd 30                	int    $0x30
	if(check && ret > 0)
  800188:	85 c0                	test   %eax,%eax
  80018a:	7f 08                	jg     800194 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	5f                   	pop    %edi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	6a 04                	push   $0x4
  80019a:	68 2a 11 80 00       	push   $0x80112a
  80019f:	6a 23                	push   $0x23
  8001a1:	68 47 11 80 00       	push   $0x801147
  8001a6:	e8 d2 01 00 00       	call   80037d <_panic>

008001ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	57                   	push   %edi
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ba:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	7f 08                	jg     8001d6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	50                   	push   %eax
  8001da:	6a 05                	push   $0x5
  8001dc:	68 2a 11 80 00       	push   $0x80112a
  8001e1:	6a 23                	push   $0x23
  8001e3:	68 47 11 80 00       	push   $0x801147
  8001e8:	e8 90 01 00 00       	call   80037d <_panic>

008001ed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800201:	b8 06 00 00 00       	mov    $0x6,%eax
  800206:	89 df                	mov    %ebx,%edi
  800208:	89 de                	mov    %ebx,%esi
  80020a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020c:	85 c0                	test   %eax,%eax
  80020e:	7f 08                	jg     800218 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	6a 06                	push   $0x6
  80021e:	68 2a 11 80 00       	push   $0x80112a
  800223:	6a 23                	push   $0x23
  800225:	68 47 11 80 00       	push   $0x801147
  80022a:	e8 4e 01 00 00       	call   80037d <_panic>

0080022f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800243:	b8 08 00 00 00       	mov    $0x8,%eax
  800248:	89 df                	mov    %ebx,%edi
  80024a:	89 de                	mov    %ebx,%esi
  80024c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024e:	85 c0                	test   %eax,%eax
  800250:	7f 08                	jg     80025a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	6a 08                	push   $0x8
  800260:	68 2a 11 80 00       	push   $0x80112a
  800265:	6a 23                	push   $0x23
  800267:	68 47 11 80 00       	push   $0x801147
  80026c:	e8 0c 01 00 00       	call   80037d <_panic>

00800271 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
  800282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800285:	b8 09 00 00 00       	mov    $0x9,%eax
  80028a:	89 df                	mov    %ebx,%edi
  80028c:	89 de                	mov    %ebx,%esi
  80028e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7f 08                	jg     80029c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	6a 09                	push   $0x9
  8002a2:	68 2a 11 80 00       	push   $0x80112a
  8002a7:	6a 23                	push   $0x23
  8002a9:	68 47 11 80 00       	push   $0x801147
  8002ae:	e8 ca 00 00 00       	call   80037d <_panic>

008002b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002cc:	89 df                	mov    %ebx,%edi
  8002ce:	89 de                	mov    %ebx,%esi
  8002d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	7f 08                	jg     8002de <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	6a 0a                	push   $0xa
  8002e4:	68 2a 11 80 00       	push   $0x80112a
  8002e9:	6a 23                	push   $0x23
  8002eb:	68 47 11 80 00       	push   $0x801147
  8002f0:	e8 88 00 00 00       	call   80037d <_panic>

008002f5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	b8 0c 00 00 00       	mov    $0xc,%eax
  800306:	be 00 00 00 00       	mov    $0x0,%esi
  80030b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800311:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800321:	b9 00 00 00 00       	mov    $0x0,%ecx
  800326:	8b 55 08             	mov    0x8(%ebp),%edx
  800329:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032e:	89 cb                	mov    %ecx,%ebx
  800330:	89 cf                	mov    %ecx,%edi
  800332:	89 ce                	mov    %ecx,%esi
  800334:	cd 30                	int    $0x30
	if(check && ret > 0)
  800336:	85 c0                	test   %eax,%eax
  800338:	7f 08                	jg     800342 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800342:	83 ec 0c             	sub    $0xc,%esp
  800345:	50                   	push   %eax
  800346:	6a 0d                	push   $0xd
  800348:	68 2a 11 80 00       	push   $0x80112a
  80034d:	6a 23                	push   $0x23
  80034f:	68 47 11 80 00       	push   $0x801147
  800354:	e8 24 00 00 00       	call   80037d <_panic>

00800359 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800359:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80035a:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80035f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800361:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  800364:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  800368:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  80036d:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  800371:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  800373:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800376:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800377:	83 c4 04             	add    $0x4,%esp
	popfl
  80037a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80037b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80037c:	c3                   	ret    

0080037d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	56                   	push   %esi
  800381:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80038b:	e8 9a fd ff ff       	call   80012a <sys_getenvid>
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	ff 75 0c             	push   0xc(%ebp)
  800396:	ff 75 08             	push   0x8(%ebp)
  800399:	56                   	push   %esi
  80039a:	50                   	push   %eax
  80039b:	68 58 11 80 00       	push   $0x801158
  8003a0:	e8 b3 00 00 00       	call   800458 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003a5:	83 c4 18             	add    $0x18,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 75 10             	push   0x10(%ebp)
  8003ac:	e8 56 00 00 00       	call   800407 <vcprintf>
	cprintf("\n");
  8003b1:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003b8:	e8 9b 00 00 00       	call   800458 <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c0:	cc                   	int3   
  8003c1:	eb fd                	jmp    8003c0 <_panic+0x43>

008003c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	53                   	push   %ebx
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003cd:	8b 13                	mov    (%ebx),%edx
  8003cf:	8d 42 01             	lea    0x1(%edx),%eax
  8003d2:	89 03                	mov    %eax,(%ebx)
  8003d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003db:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e0:	74 09                	je     8003eb <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e9:	c9                   	leave  
  8003ea:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	68 ff 00 00 00       	push   $0xff
  8003f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f6:	50                   	push   %eax
  8003f7:	e8 b0 fc ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  8003fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	eb db                	jmp    8003e2 <putch+0x1f>

00800407 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800417:	00 00 00 
	b.cnt = 0;
  80041a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800421:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800424:	ff 75 0c             	push   0xc(%ebp)
  800427:	ff 75 08             	push   0x8(%ebp)
  80042a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	68 c3 03 80 00       	push   $0x8003c3
  800436:	e8 14 01 00 00       	call   80054f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80043b:	83 c4 08             	add    $0x8,%esp
  80043e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800444:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044a:	50                   	push   %eax
  80044b:	e8 5c fc ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  800450:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80045e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800461:	50                   	push   %eax
  800462:	ff 75 08             	push   0x8(%ebp)
  800465:	e8 9d ff ff ff       	call   800407 <vcprintf>
	va_end(ap);

	return cnt;
}
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	57                   	push   %edi
  800470:	56                   	push   %esi
  800471:	53                   	push   %ebx
  800472:	83 ec 1c             	sub    $0x1c,%esp
  800475:	89 c7                	mov    %eax,%edi
  800477:	89 d6                	mov    %edx,%esi
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047f:	89 d1                	mov    %edx,%ecx
  800481:	89 c2                	mov    %eax,%edx
  800483:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800486:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800489:	8b 45 10             	mov    0x10(%ebp),%eax
  80048c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80048f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800492:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800499:	39 c2                	cmp    %eax,%edx
  80049b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80049e:	72 3e                	jb     8004de <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	ff 75 18             	push   0x18(%ebp)
  8004a6:	83 eb 01             	sub    $0x1,%ebx
  8004a9:	53                   	push   %ebx
  8004aa:	50                   	push   %eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	ff 75 e4             	push   -0x1c(%ebp)
  8004b1:	ff 75 e0             	push   -0x20(%ebp)
  8004b4:	ff 75 dc             	push   -0x24(%ebp)
  8004b7:	ff 75 d8             	push   -0x28(%ebp)
  8004ba:	e8 11 0a 00 00       	call   800ed0 <__udivdi3>
  8004bf:	83 c4 18             	add    $0x18,%esp
  8004c2:	52                   	push   %edx
  8004c3:	50                   	push   %eax
  8004c4:	89 f2                	mov    %esi,%edx
  8004c6:	89 f8                	mov    %edi,%eax
  8004c8:	e8 9f ff ff ff       	call   80046c <printnum>
  8004cd:	83 c4 20             	add    $0x20,%esp
  8004d0:	eb 13                	jmp    8004e5 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	56                   	push   %esi
  8004d6:	ff 75 18             	push   0x18(%ebp)
  8004d9:	ff d7                	call   *%edi
  8004db:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004de:	83 eb 01             	sub    $0x1,%ebx
  8004e1:	85 db                	test   %ebx,%ebx
  8004e3:	7f ed                	jg     8004d2 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	56                   	push   %esi
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	ff 75 e4             	push   -0x1c(%ebp)
  8004ef:	ff 75 e0             	push   -0x20(%ebp)
  8004f2:	ff 75 dc             	push   -0x24(%ebp)
  8004f5:	ff 75 d8             	push   -0x28(%ebp)
  8004f8:	e8 f3 0a 00 00       	call   800ff0 <__umoddi3>
  8004fd:	83 c4 14             	add    $0x14,%esp
  800500:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  800507:	50                   	push   %eax
  800508:	ff d7                	call   *%edi
}
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800510:	5b                   	pop    %ebx
  800511:	5e                   	pop    %esi
  800512:	5f                   	pop    %edi
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    

00800515 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80051b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80051f:	8b 10                	mov    (%eax),%edx
  800521:	3b 50 04             	cmp    0x4(%eax),%edx
  800524:	73 0a                	jae    800530 <sprintputch+0x1b>
		*b->buf++ = ch;
  800526:	8d 4a 01             	lea    0x1(%edx),%ecx
  800529:	89 08                	mov    %ecx,(%eax)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	88 02                	mov    %al,(%edx)
}
  800530:	5d                   	pop    %ebp
  800531:	c3                   	ret    

00800532 <printfmt>:
{
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800538:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80053b:	50                   	push   %eax
  80053c:	ff 75 10             	push   0x10(%ebp)
  80053f:	ff 75 0c             	push   0xc(%ebp)
  800542:	ff 75 08             	push   0x8(%ebp)
  800545:	e8 05 00 00 00       	call   80054f <vprintfmt>
}
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    

0080054f <vprintfmt>:
{
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	57                   	push   %edi
  800553:	56                   	push   %esi
  800554:	53                   	push   %ebx
  800555:	83 ec 3c             	sub    $0x3c,%esp
  800558:	8b 75 08             	mov    0x8(%ebp),%esi
  80055b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800561:	eb 0a                	jmp    80056d <vprintfmt+0x1e>
			putch(ch, putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	50                   	push   %eax
  800568:	ff d6                	call   *%esi
  80056a:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80056d:	83 c7 01             	add    $0x1,%edi
  800570:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800574:	83 f8 25             	cmp    $0x25,%eax
  800577:	74 0c                	je     800585 <vprintfmt+0x36>
			if (ch == '\0')
  800579:	85 c0                	test   %eax,%eax
  80057b:	75 e6                	jne    800563 <vprintfmt+0x14>
}
  80057d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800580:	5b                   	pop    %ebx
  800581:	5e                   	pop    %esi
  800582:	5f                   	pop    %edi
  800583:	5d                   	pop    %ebp
  800584:	c3                   	ret    
		padc = ' ';
  800585:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800589:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800590:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800597:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80059e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a3:	8d 47 01             	lea    0x1(%edi),%eax
  8005a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a9:	0f b6 17             	movzbl (%edi),%edx
  8005ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005af:	3c 55                	cmp    $0x55,%al
  8005b1:	0f 87 a6 04 00 00    	ja     800a5d <vprintfmt+0x50e>
  8005b7:	0f b6 c0             	movzbl %al,%eax
  8005ba:	ff 24 85 c0 12 80 00 	jmp    *0x8012c0(,%eax,4)
  8005c1:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  8005c4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005c8:	eb d9                	jmp    8005a3 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005cd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005d1:	eb d0                	jmp    8005a3 <vprintfmt+0x54>
  8005d3:	0f b6 d2             	movzbl %dl,%edx
  8005d6:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005e4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005e8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005eb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ee:	83 f9 09             	cmp    $0x9,%ecx
  8005f1:	77 55                	ja     800648 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005f6:	eb e9                	jmp    8005e1 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80060c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800610:	79 91                	jns    8005a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800612:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800615:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800618:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80061f:	eb 82                	jmp    8005a3 <vprintfmt+0x54>
  800621:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800624:	85 d2                	test   %edx,%edx
  800626:	b8 00 00 00 00       	mov    $0x0,%eax
  80062b:	0f 49 c2             	cmovns %edx,%eax
  80062e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800631:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800634:	e9 6a ff ff ff       	jmp    8005a3 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800639:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80063c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800643:	e9 5b ff ff ff       	jmp    8005a3 <vprintfmt+0x54>
  800648:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064e:	eb bc                	jmp    80060c <vprintfmt+0xbd>
			lflag++;
  800650:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800653:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800656:	e9 48 ff ff ff       	jmp    8005a3 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 78 04             	lea    0x4(%eax),%edi
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	ff 30                	push   (%eax)
  800667:	ff d6                	call   *%esi
			break;
  800669:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80066c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80066f:	e9 88 03 00 00       	jmp    8009fc <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 78 04             	lea    0x4(%eax),%edi
  80067a:	8b 10                	mov    (%eax),%edx
  80067c:	89 d0                	mov    %edx,%eax
  80067e:	f7 d8                	neg    %eax
  800680:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800683:	83 f8 0f             	cmp    $0xf,%eax
  800686:	7f 23                	jg     8006ab <vprintfmt+0x15c>
  800688:	8b 14 85 20 14 80 00 	mov    0x801420(,%eax,4),%edx
  80068f:	85 d2                	test   %edx,%edx
  800691:	74 18                	je     8006ab <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800693:	52                   	push   %edx
  800694:	68 9e 11 80 00       	push   $0x80119e
  800699:	53                   	push   %ebx
  80069a:	56                   	push   %esi
  80069b:	e8 92 fe ff ff       	call   800532 <printfmt>
  8006a0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a6:	e9 51 03 00 00       	jmp    8009fc <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  8006ab:	50                   	push   %eax
  8006ac:	68 95 11 80 00       	push   $0x801195
  8006b1:	53                   	push   %ebx
  8006b2:	56                   	push   %esi
  8006b3:	e8 7a fe ff ff       	call   800532 <printfmt>
  8006b8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006bb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006be:	e9 39 03 00 00       	jmp    8009fc <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	83 c0 04             	add    $0x4,%eax
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006d1:	85 d2                	test   %edx,%edx
  8006d3:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  8006d8:	0f 45 c2             	cmovne %edx,%eax
  8006db:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006e2:	7e 06                	jle    8006ea <vprintfmt+0x19b>
  8006e4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006e8:	75 0d                	jne    8006f7 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ed:	89 c7                	mov    %eax,%edi
  8006ef:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006f5:	eb 55                	jmp    80074c <vprintfmt+0x1fd>
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 e0             	push   -0x20(%ebp)
  8006fd:	ff 75 cc             	push   -0x34(%ebp)
  800700:	e8 f5 03 00 00       	call   800afa <strnlen>
  800705:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800708:	29 c2                	sub    %eax,%edx
  80070a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800712:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800716:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800719:	eb 0f                	jmp    80072a <vprintfmt+0x1db>
					putch(padc, putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	ff 75 d4             	push   -0x2c(%ebp)
  800722:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800724:	83 ef 01             	sub    $0x1,%edi
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	85 ff                	test   %edi,%edi
  80072c:	7f ed                	jg     80071b <vprintfmt+0x1cc>
  80072e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800731:	85 d2                	test   %edx,%edx
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	0f 49 c2             	cmovns %edx,%eax
  80073b:	29 c2                	sub    %eax,%edx
  80073d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800740:	eb a8                	jmp    8006ea <vprintfmt+0x19b>
					putch(ch, putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	52                   	push   %edx
  800747:	ff d6                	call   *%esi
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80074f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800751:	83 c7 01             	add    $0x1,%edi
  800754:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800758:	0f be d0             	movsbl %al,%edx
  80075b:	85 d2                	test   %edx,%edx
  80075d:	74 4b                	je     8007aa <vprintfmt+0x25b>
  80075f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800763:	78 06                	js     80076b <vprintfmt+0x21c>
  800765:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800769:	78 1e                	js     800789 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80076b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80076f:	74 d1                	je     800742 <vprintfmt+0x1f3>
  800771:	0f be c0             	movsbl %al,%eax
  800774:	83 e8 20             	sub    $0x20,%eax
  800777:	83 f8 5e             	cmp    $0x5e,%eax
  80077a:	76 c6                	jbe    800742 <vprintfmt+0x1f3>
					putch('?', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 3f                	push   $0x3f
  800782:	ff d6                	call   *%esi
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	eb c3                	jmp    80074c <vprintfmt+0x1fd>
  800789:	89 cf                	mov    %ecx,%edi
  80078b:	eb 0e                	jmp    80079b <vprintfmt+0x24c>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	53                   	push   %ebx
  800791:	6a 20                	push   $0x20
  800793:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800795:	83 ef 01             	sub    $0x1,%edi
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	85 ff                	test   %edi,%edi
  80079d:	7f ee                	jg     80078d <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80079f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	e9 52 02 00 00       	jmp    8009fc <vprintfmt+0x4ad>
  8007aa:	89 cf                	mov    %ecx,%edi
  8007ac:	eb ed                	jmp    80079b <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	83 c0 04             	add    $0x4,%eax
  8007b4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8007bc:	85 d2                	test   %edx,%edx
  8007be:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  8007c3:	0f 45 c2             	cmovne %edx,%eax
  8007c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8007c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007cd:	7e 06                	jle    8007d5 <vprintfmt+0x286>
  8007cf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8007d3:	75 0d                	jne    8007e2 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007d8:	89 c7                	mov    %eax,%edi
  8007da:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007e0:	eb 55                	jmp    800837 <vprintfmt+0x2e8>
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 e0             	push   -0x20(%ebp)
  8007e8:	ff 75 cc             	push   -0x34(%ebp)
  8007eb:	e8 0a 03 00 00       	call   800afa <strnlen>
  8007f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007f3:	29 c2                	sub    %eax,%edx
  8007f5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007fd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800801:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800804:	eb 0f                	jmp    800815 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	53                   	push   %ebx
  80080a:	ff 75 d4             	push   -0x2c(%ebp)
  80080d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80080f:	83 ef 01             	sub    $0x1,%edi
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	85 ff                	test   %edi,%edi
  800817:	7f ed                	jg     800806 <vprintfmt+0x2b7>
  800819:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80081c:	85 d2                	test   %edx,%edx
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	0f 49 c2             	cmovns %edx,%eax
  800826:	29 c2                	sub    %eax,%edx
  800828:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80082b:	eb a8                	jmp    8007d5 <vprintfmt+0x286>
					putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	53                   	push   %ebx
  800831:	52                   	push   %edx
  800832:	ff d6                	call   *%esi
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80083a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80083c:	83 c7 01             	add    $0x1,%edi
  80083f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800843:	0f be d0             	movsbl %al,%edx
  800846:	3c 3a                	cmp    $0x3a,%al
  800848:	74 4b                	je     800895 <vprintfmt+0x346>
  80084a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80084e:	78 06                	js     800856 <vprintfmt+0x307>
  800850:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800854:	78 1e                	js     800874 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800856:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80085a:	74 d1                	je     80082d <vprintfmt+0x2de>
  80085c:	0f be c0             	movsbl %al,%eax
  80085f:	83 e8 20             	sub    $0x20,%eax
  800862:	83 f8 5e             	cmp    $0x5e,%eax
  800865:	76 c6                	jbe    80082d <vprintfmt+0x2de>
					putch('?', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	53                   	push   %ebx
  80086b:	6a 3f                	push   $0x3f
  80086d:	ff d6                	call   *%esi
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	eb c3                	jmp    800837 <vprintfmt+0x2e8>
  800874:	89 cf                	mov    %ecx,%edi
  800876:	eb 0e                	jmp    800886 <vprintfmt+0x337>
				putch(' ', putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	6a 20                	push   $0x20
  80087e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800880:	83 ef 01             	sub    $0x1,%edi
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	85 ff                	test   %edi,%edi
  800888:	7f ee                	jg     800878 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80088a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
  800890:	e9 67 01 00 00       	jmp    8009fc <vprintfmt+0x4ad>
  800895:	89 cf                	mov    %ecx,%edi
  800897:	eb ed                	jmp    800886 <vprintfmt+0x337>
	if (lflag >= 2)
  800899:	83 f9 01             	cmp    $0x1,%ecx
  80089c:	7f 1b                	jg     8008b9 <vprintfmt+0x36a>
	else if (lflag)
  80089e:	85 c9                	test   %ecx,%ecx
  8008a0:	74 63                	je     800905 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008aa:	99                   	cltd   
  8008ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b7:	eb 17                	jmp    8008d0 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 40 08             	lea    0x8(%eax),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8008d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8008d6:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008db:	85 c9                	test   %ecx,%ecx
  8008dd:	0f 89 ff 00 00 00    	jns    8009e2 <vprintfmt+0x493>
				putch('-', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 2d                	push   $0x2d
  8008e9:	ff d6                	call   *%esi
				num = -(long long) num;
  8008eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f1:	f7 da                	neg    %edx
  8008f3:	83 d1 00             	adc    $0x0,%ecx
  8008f6:	f7 d9                	neg    %ecx
  8008f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800900:	e9 dd 00 00 00       	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80090d:	99                   	cltd   
  80090e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8d 40 04             	lea    0x4(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
  80091a:	eb b4                	jmp    8008d0 <vprintfmt+0x381>
	if (lflag >= 2)
  80091c:	83 f9 01             	cmp    $0x1,%ecx
  80091f:	7f 1e                	jg     80093f <vprintfmt+0x3f0>
	else if (lflag)
  800921:	85 c9                	test   %ecx,%ecx
  800923:	74 32                	je     800957 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8b 10                	mov    (%eax),%edx
  80092a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092f:	8d 40 04             	lea    0x4(%eax),%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800935:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80093a:	e9 a3 00 00 00       	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8b 10                	mov    (%eax),%edx
  800944:	8b 48 04             	mov    0x4(%eax),%ecx
  800947:	8d 40 08             	lea    0x8(%eax),%eax
  80094a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094d:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800952:	e9 8b 00 00 00       	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800961:	8d 40 04             	lea    0x4(%eax),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800967:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80096c:	eb 74                	jmp    8009e2 <vprintfmt+0x493>
	if (lflag >= 2)
  80096e:	83 f9 01             	cmp    $0x1,%ecx
  800971:	7f 1b                	jg     80098e <vprintfmt+0x43f>
	else if (lflag)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	74 2c                	je     8009a3 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8b 10                	mov    (%eax),%edx
  80097c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800981:	8d 40 04             	lea    0x4(%eax),%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800987:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80098c:	eb 54                	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8b 10                	mov    (%eax),%edx
  800993:	8b 48 04             	mov    0x4(%eax),%ecx
  800996:	8d 40 08             	lea    0x8(%eax),%eax
  800999:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80099c:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  8009a1:	eb 3f                	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8b 10                	mov    (%eax),%edx
  8009a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ad:	8d 40 04             	lea    0x4(%eax),%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b3:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  8009b8:	eb 28                	jmp    8009e2 <vprintfmt+0x493>
			putch('0', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	53                   	push   %ebx
  8009be:	6a 30                	push   $0x30
  8009c0:	ff d6                	call   *%esi
			putch('x', putdat);
  8009c2:	83 c4 08             	add    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	6a 78                	push   $0x78
  8009c8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	8b 10                	mov    (%eax),%edx
  8009cf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009d4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009d7:	8d 40 04             	lea    0x4(%eax),%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009dd:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	ff 75 d4             	push   -0x2c(%ebp)
  8009ed:	57                   	push   %edi
  8009ee:	51                   	push   %ecx
  8009ef:	52                   	push   %edx
  8009f0:	89 da                	mov    %ebx,%edx
  8009f2:	89 f0                	mov    %esi,%eax
  8009f4:	e8 73 fa ff ff       	call   80046c <printnum>
			break;
  8009f9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009fc:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ff:	e9 69 fb ff ff       	jmp    80056d <vprintfmt+0x1e>
	if (lflag >= 2)
  800a04:	83 f9 01             	cmp    $0x1,%ecx
  800a07:	7f 1b                	jg     800a24 <vprintfmt+0x4d5>
	else if (lflag)
  800a09:	85 c9                	test   %ecx,%ecx
  800a0b:	74 2c                	je     800a39 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8b 10                	mov    (%eax),%edx
  800a12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a17:	8d 40 04             	lea    0x4(%eax),%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1d:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800a22:	eb be                	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	8b 10                	mov    (%eax),%edx
  800a29:	8b 48 04             	mov    0x4(%eax),%ecx
  800a2c:	8d 40 08             	lea    0x8(%eax),%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a32:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800a37:	eb a9                	jmp    8009e2 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	8b 10                	mov    (%eax),%edx
  800a3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a43:	8d 40 04             	lea    0x4(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a49:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a4e:	eb 92                	jmp    8009e2 <vprintfmt+0x493>
			putch(ch, putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	53                   	push   %ebx
  800a54:	6a 25                	push   $0x25
  800a56:	ff d6                	call   *%esi
			break;
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	eb 9f                	jmp    8009fc <vprintfmt+0x4ad>
			putch('%', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	53                   	push   %ebx
  800a61:	6a 25                	push   $0x25
  800a63:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 f8                	mov    %edi,%eax
  800a6a:	eb 03                	jmp    800a6f <vprintfmt+0x520>
  800a6c:	83 e8 01             	sub    $0x1,%eax
  800a6f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a73:	75 f7                	jne    800a6c <vprintfmt+0x51d>
  800a75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a78:	eb 82                	jmp    8009fc <vprintfmt+0x4ad>

00800a7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 18             	sub    $0x18,%esp
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a89:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a8d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a97:	85 c0                	test   %eax,%eax
  800a99:	74 26                	je     800ac1 <vsnprintf+0x47>
  800a9b:	85 d2                	test   %edx,%edx
  800a9d:	7e 22                	jle    800ac1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a9f:	ff 75 14             	push   0x14(%ebp)
  800aa2:	ff 75 10             	push   0x10(%ebp)
  800aa5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	68 15 05 80 00       	push   $0x800515
  800aae:	e8 9c fa ff ff       	call   80054f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800abc:	83 c4 10             	add    $0x10,%esp
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    
		return -E_INVAL;
  800ac1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ac6:	eb f7                	jmp    800abf <vsnprintf+0x45>

00800ac8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ace:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ad1:	50                   	push   %eax
  800ad2:	ff 75 10             	push   0x10(%ebp)
  800ad5:	ff 75 0c             	push   0xc(%ebp)
  800ad8:	ff 75 08             	push   0x8(%ebp)
  800adb:	e8 9a ff ff ff       	call   800a7a <vsnprintf>
	va_end(ap);

	return rc;
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aed:	eb 03                	jmp    800af2 <strlen+0x10>
		n++;
  800aef:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800af2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800af6:	75 f7                	jne    800aef <strlen+0xd>
	return n;
}
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
  800b08:	eb 03                	jmp    800b0d <strnlen+0x13>
		n++;
  800b0a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0d:	39 d0                	cmp    %edx,%eax
  800b0f:	74 08                	je     800b19 <strnlen+0x1f>
  800b11:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b15:	75 f3                	jne    800b0a <strnlen+0x10>
  800b17:	89 c2                	mov    %eax,%edx
	return n;
}
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b30:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	84 d2                	test   %dl,%dl
  800b38:	75 f2                	jne    800b2c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b3a:	89 c8                	mov    %ecx,%eax
  800b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	53                   	push   %ebx
  800b45:	83 ec 10             	sub    $0x10,%esp
  800b48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b4b:	53                   	push   %ebx
  800b4c:	e8 91 ff ff ff       	call   800ae2 <strlen>
  800b51:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b54:	ff 75 0c             	push   0xc(%ebp)
  800b57:	01 d8                	add    %ebx,%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 be ff ff ff       	call   800b1d <strcpy>
	return dst;
}
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 f3                	mov    %esi,%ebx
  800b73:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b76:	89 f0                	mov    %esi,%eax
  800b78:	eb 0f                	jmp    800b89 <strncpy+0x23>
		*dst++ = *src;
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	0f b6 0a             	movzbl (%edx),%ecx
  800b80:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b83:	80 f9 01             	cmp    $0x1,%cl
  800b86:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b89:	39 d8                	cmp    %ebx,%eax
  800b8b:	75 ed                	jne    800b7a <strncpy+0x14>
	}
	return ret;
}
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	8b 75 08             	mov    0x8(%ebp),%esi
  800b9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9e:	8b 55 10             	mov    0x10(%ebp),%edx
  800ba1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ba3:	85 d2                	test   %edx,%edx
  800ba5:	74 21                	je     800bc8 <strlcpy+0x35>
  800ba7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bab:	89 f2                	mov    %esi,%edx
  800bad:	eb 09                	jmp    800bb8 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800baf:	83 c1 01             	add    $0x1,%ecx
  800bb2:	83 c2 01             	add    $0x1,%edx
  800bb5:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	74 09                	je     800bc5 <strlcpy+0x32>
  800bbc:	0f b6 19             	movzbl (%ecx),%ebx
  800bbf:	84 db                	test   %bl,%bl
  800bc1:	75 ec                	jne    800baf <strlcpy+0x1c>
  800bc3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bc5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bc8:	29 f0                	sub    %esi,%eax
}
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bd7:	eb 06                	jmp    800bdf <strcmp+0x11>
		p++, q++;
  800bd9:	83 c1 01             	add    $0x1,%ecx
  800bdc:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bdf:	0f b6 01             	movzbl (%ecx),%eax
  800be2:	84 c0                	test   %al,%al
  800be4:	74 04                	je     800bea <strcmp+0x1c>
  800be6:	3a 02                	cmp    (%edx),%al
  800be8:	74 ef                	je     800bd9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bea:	0f b6 c0             	movzbl %al,%eax
  800bed:	0f b6 12             	movzbl (%edx),%edx
  800bf0:	29 d0                	sub    %edx,%eax
}
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	53                   	push   %ebx
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfe:	89 c3                	mov    %eax,%ebx
  800c00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c03:	eb 06                	jmp    800c0b <strncmp+0x17>
		n--, p++, q++;
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c0b:	39 d8                	cmp    %ebx,%eax
  800c0d:	74 18                	je     800c27 <strncmp+0x33>
  800c0f:	0f b6 08             	movzbl (%eax),%ecx
  800c12:	84 c9                	test   %cl,%cl
  800c14:	74 04                	je     800c1a <strncmp+0x26>
  800c16:	3a 0a                	cmp    (%edx),%cl
  800c18:	74 eb                	je     800c05 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1a:	0f b6 00             	movzbl (%eax),%eax
  800c1d:	0f b6 12             	movzbl (%edx),%edx
  800c20:	29 d0                	sub    %edx,%eax
}
  800c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    
		return 0;
  800c27:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2c:	eb f4                	jmp    800c22 <strncmp+0x2e>

00800c2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c38:	eb 03                	jmp    800c3d <strchr+0xf>
  800c3a:	83 c0 01             	add    $0x1,%eax
  800c3d:	0f b6 10             	movzbl (%eax),%edx
  800c40:	84 d2                	test   %dl,%dl
  800c42:	74 06                	je     800c4a <strchr+0x1c>
		if (*s == c)
  800c44:	38 ca                	cmp    %cl,%dl
  800c46:	75 f2                	jne    800c3a <strchr+0xc>
  800c48:	eb 05                	jmp    800c4f <strchr+0x21>
			return (char *) s;
	return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c5b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c5e:	38 ca                	cmp    %cl,%dl
  800c60:	74 09                	je     800c6b <strfind+0x1a>
  800c62:	84 d2                	test   %dl,%dl
  800c64:	74 05                	je     800c6b <strfind+0x1a>
	for (; *s; s++)
  800c66:	83 c0 01             	add    $0x1,%eax
  800c69:	eb f0                	jmp    800c5b <strfind+0xa>
			break;
	return (char *) s;
}
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c79:	85 c9                	test   %ecx,%ecx
  800c7b:	74 2f                	je     800cac <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c7d:	89 f8                	mov    %edi,%eax
  800c7f:	09 c8                	or     %ecx,%eax
  800c81:	a8 03                	test   $0x3,%al
  800c83:	75 21                	jne    800ca6 <memset+0x39>
		c &= 0xFF;
  800c85:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c89:	89 d0                	mov    %edx,%eax
  800c8b:	c1 e0 08             	shl    $0x8,%eax
  800c8e:	89 d3                	mov    %edx,%ebx
  800c90:	c1 e3 18             	shl    $0x18,%ebx
  800c93:	89 d6                	mov    %edx,%esi
  800c95:	c1 e6 10             	shl    $0x10,%esi
  800c98:	09 f3                	or     %esi,%ebx
  800c9a:	09 da                	or     %ebx,%edx
  800c9c:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c9e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ca1:	fc                   	cld    
  800ca2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ca4:	eb 06                	jmp    800cac <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	fc                   	cld    
  800caa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cac:	89 f8                	mov    %edi,%eax
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc1:	39 c6                	cmp    %eax,%esi
  800cc3:	73 32                	jae    800cf7 <memmove+0x44>
  800cc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cc8:	39 c2                	cmp    %eax,%edx
  800cca:	76 2b                	jbe    800cf7 <memmove+0x44>
		s += n;
		d += n;
  800ccc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccf:	89 d6                	mov    %edx,%esi
  800cd1:	09 fe                	or     %edi,%esi
  800cd3:	09 ce                	or     %ecx,%esi
  800cd5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cdb:	75 0e                	jne    800ceb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cdd:	83 ef 04             	sub    $0x4,%edi
  800ce0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ce3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ce6:	fd                   	std    
  800ce7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce9:	eb 09                	jmp    800cf4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ceb:	83 ef 01             	sub    $0x1,%edi
  800cee:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cf1:	fd                   	std    
  800cf2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cf4:	fc                   	cld    
  800cf5:	eb 1a                	jmp    800d11 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf7:	89 f2                	mov    %esi,%edx
  800cf9:	09 c2                	or     %eax,%edx
  800cfb:	09 ca                	or     %ecx,%edx
  800cfd:	f6 c2 03             	test   $0x3,%dl
  800d00:	75 0a                	jne    800d0c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d02:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d05:	89 c7                	mov    %eax,%edi
  800d07:	fc                   	cld    
  800d08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d0a:	eb 05                	jmp    800d11 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d0c:	89 c7                	mov    %eax,%edi
  800d0e:	fc                   	cld    
  800d0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d1b:	ff 75 10             	push   0x10(%ebp)
  800d1e:	ff 75 0c             	push   0xc(%ebp)
  800d21:	ff 75 08             	push   0x8(%ebp)
  800d24:	e8 8a ff ff ff       	call   800cb3 <memmove>
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	89 c6                	mov    %eax,%esi
  800d38:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d3b:	eb 06                	jmp    800d43 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d3d:	83 c0 01             	add    $0x1,%eax
  800d40:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d43:	39 f0                	cmp    %esi,%eax
  800d45:	74 14                	je     800d5b <memcmp+0x30>
		if (*s1 != *s2)
  800d47:	0f b6 08             	movzbl (%eax),%ecx
  800d4a:	0f b6 1a             	movzbl (%edx),%ebx
  800d4d:	38 d9                	cmp    %bl,%cl
  800d4f:	74 ec                	je     800d3d <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d51:	0f b6 c1             	movzbl %cl,%eax
  800d54:	0f b6 db             	movzbl %bl,%ebx
  800d57:	29 d8                	sub    %ebx,%eax
  800d59:	eb 05                	jmp    800d60 <memcmp+0x35>
	}

	return 0;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d72:	eb 03                	jmp    800d77 <memfind+0x13>
  800d74:	83 c0 01             	add    $0x1,%eax
  800d77:	39 d0                	cmp    %edx,%eax
  800d79:	73 04                	jae    800d7f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d7b:	38 08                	cmp    %cl,(%eax)
  800d7d:	75 f5                	jne    800d74 <memfind+0x10>
			break;
	return (void *) s;
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d8d:	eb 03                	jmp    800d92 <strtol+0x11>
		s++;
  800d8f:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d92:	0f b6 02             	movzbl (%edx),%eax
  800d95:	3c 20                	cmp    $0x20,%al
  800d97:	74 f6                	je     800d8f <strtol+0xe>
  800d99:	3c 09                	cmp    $0x9,%al
  800d9b:	74 f2                	je     800d8f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d9d:	3c 2b                	cmp    $0x2b,%al
  800d9f:	74 2a                	je     800dcb <strtol+0x4a>
	int neg = 0;
  800da1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800da6:	3c 2d                	cmp    $0x2d,%al
  800da8:	74 2b                	je     800dd5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800db0:	75 0f                	jne    800dc1 <strtol+0x40>
  800db2:	80 3a 30             	cmpb   $0x30,(%edx)
  800db5:	74 28                	je     800ddf <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800db7:	85 db                	test   %ebx,%ebx
  800db9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbe:	0f 44 d8             	cmove  %eax,%ebx
  800dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dc9:	eb 46                	jmp    800e11 <strtol+0x90>
		s++;
  800dcb:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800dce:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd3:	eb d5                	jmp    800daa <strtol+0x29>
		s++, neg = 1;
  800dd5:	83 c2 01             	add    $0x1,%edx
  800dd8:	bf 01 00 00 00       	mov    $0x1,%edi
  800ddd:	eb cb                	jmp    800daa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ddf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800de3:	74 0e                	je     800df3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800de5:	85 db                	test   %ebx,%ebx
  800de7:	75 d8                	jne    800dc1 <strtol+0x40>
		s++, base = 8;
  800de9:	83 c2 01             	add    $0x1,%edx
  800dec:	bb 08 00 00 00       	mov    $0x8,%ebx
  800df1:	eb ce                	jmp    800dc1 <strtol+0x40>
		s += 2, base = 16;
  800df3:	83 c2 02             	add    $0x2,%edx
  800df6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dfb:	eb c4                	jmp    800dc1 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dfd:	0f be c0             	movsbl %al,%eax
  800e00:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e06:	7d 3a                	jge    800e42 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e08:	83 c2 01             	add    $0x1,%edx
  800e0b:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800e0f:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800e11:	0f b6 02             	movzbl (%edx),%eax
  800e14:	8d 70 d0             	lea    -0x30(%eax),%esi
  800e17:	89 f3                	mov    %esi,%ebx
  800e19:	80 fb 09             	cmp    $0x9,%bl
  800e1c:	76 df                	jbe    800dfd <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800e1e:	8d 70 9f             	lea    -0x61(%eax),%esi
  800e21:	89 f3                	mov    %esi,%ebx
  800e23:	80 fb 19             	cmp    $0x19,%bl
  800e26:	77 08                	ja     800e30 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e28:	0f be c0             	movsbl %al,%eax
  800e2b:	83 e8 57             	sub    $0x57,%eax
  800e2e:	eb d3                	jmp    800e03 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e30:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e33:	89 f3                	mov    %esi,%ebx
  800e35:	80 fb 19             	cmp    $0x19,%bl
  800e38:	77 08                	ja     800e42 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e3a:	0f be c0             	movsbl %al,%eax
  800e3d:	83 e8 37             	sub    $0x37,%eax
  800e40:	eb c1                	jmp    800e03 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e46:	74 05                	je     800e4d <strtol+0xcc>
		*endptr = (char *) s;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e4d:	89 c8                	mov    %ecx,%eax
  800e4f:	f7 d8                	neg    %eax
  800e51:	85 ff                	test   %edi,%edi
  800e53:	0f 45 c8             	cmovne %eax,%ecx
}
  800e56:	89 c8                	mov    %ecx,%eax
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e63:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800e6a:	74 20                	je     800e8c <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	a3 08 20 80 00       	mov    %eax,0x802008
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	68 59 03 80 00       	push   $0x800359
  800e7c:	6a 00                	push   $0x0
  800e7e:	e8 30 f4 ff ff       	call   8002b3 <sys_env_set_pgfault_upcall>
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	85 c0                	test   %eax,%eax
  800e88:	78 2e                	js     800eb8 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  800e8c:	83 ec 04             	sub    $0x4,%esp
  800e8f:	6a 07                	push   $0x7
  800e91:	68 00 f0 bf ee       	push   $0xeebff000
  800e96:	6a 00                	push   $0x0
  800e98:	e8 cb f2 ff ff       	call   800168 <sys_page_alloc>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	79 c8                	jns    800e6c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  800ea4:	83 ec 04             	sub    $0x4,%esp
  800ea7:	68 80 14 80 00       	push   $0x801480
  800eac:	6a 21                	push   $0x21
  800eae:	68 e3 14 80 00       	push   $0x8014e3
  800eb3:	e8 c5 f4 ff ff       	call   80037d <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	68 ac 14 80 00       	push   $0x8014ac
  800ec0:	6a 27                	push   $0x27
  800ec2:	68 e3 14 80 00       	push   $0x8014e3
  800ec7:	e8 b1 f4 ff ff       	call   80037d <_panic>
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__udivdi3>:
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 1c             	sub    $0x1c,%esp
  800edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800edf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ee3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 19                	jne    800f08 <__udivdi3+0x38>
  800eef:	39 f3                	cmp    %esi,%ebx
  800ef1:	76 4d                	jbe    800f40 <__udivdi3+0x70>
  800ef3:	31 ff                	xor    %edi,%edi
  800ef5:	89 e8                	mov    %ebp,%eax
  800ef7:	89 f2                	mov    %esi,%edx
  800ef9:	f7 f3                	div    %ebx
  800efb:	89 fa                	mov    %edi,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	39 f0                	cmp    %esi,%eax
  800f0a:	76 14                	jbe    800f20 <__udivdi3+0x50>
  800f0c:	31 ff                	xor    %edi,%edi
  800f0e:	31 c0                	xor    %eax,%eax
  800f10:	89 fa                	mov    %edi,%edx
  800f12:	83 c4 1c             	add    $0x1c,%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
  800f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f20:	0f bd f8             	bsr    %eax,%edi
  800f23:	83 f7 1f             	xor    $0x1f,%edi
  800f26:	75 48                	jne    800f70 <__udivdi3+0xa0>
  800f28:	39 f0                	cmp    %esi,%eax
  800f2a:	72 06                	jb     800f32 <__udivdi3+0x62>
  800f2c:	31 c0                	xor    %eax,%eax
  800f2e:	39 eb                	cmp    %ebp,%ebx
  800f30:	77 de                	ja     800f10 <__udivdi3+0x40>
  800f32:	b8 01 00 00 00       	mov    $0x1,%eax
  800f37:	eb d7                	jmp    800f10 <__udivdi3+0x40>
  800f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f40:	89 d9                	mov    %ebx,%ecx
  800f42:	85 db                	test   %ebx,%ebx
  800f44:	75 0b                	jne    800f51 <__udivdi3+0x81>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f3                	div    %ebx
  800f4f:	89 c1                	mov    %eax,%ecx
  800f51:	31 d2                	xor    %edx,%edx
  800f53:	89 f0                	mov    %esi,%eax
  800f55:	f7 f1                	div    %ecx
  800f57:	89 c6                	mov    %eax,%esi
  800f59:	89 e8                	mov    %ebp,%eax
  800f5b:	89 f7                	mov    %esi,%edi
  800f5d:	f7 f1                	div    %ecx
  800f5f:	89 fa                	mov    %edi,%edx
  800f61:	83 c4 1c             	add    $0x1c,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
  800f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	ba 20 00 00 00       	mov    $0x20,%edx
  800f77:	29 fa                	sub    %edi,%edx
  800f79:	d3 e0                	shl    %cl,%eax
  800f7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f7f:	89 d1                	mov    %edx,%ecx
  800f81:	89 d8                	mov    %ebx,%eax
  800f83:	d3 e8                	shr    %cl,%eax
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 c1                	or     %eax,%ecx
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 d1                	mov    %edx,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 f3                	or     %esi,%ebx
  800fa9:	89 c6                	mov    %eax,%esi
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 d8                	mov    %ebx,%eax
  800faf:	f7 74 24 08          	divl   0x8(%esp)
  800fb3:	89 d6                	mov    %edx,%esi
  800fb5:	89 c3                	mov    %eax,%ebx
  800fb7:	f7 64 24 0c          	mull   0xc(%esp)
  800fbb:	39 d6                	cmp    %edx,%esi
  800fbd:	72 19                	jb     800fd8 <__udivdi3+0x108>
  800fbf:	89 f9                	mov    %edi,%ecx
  800fc1:	d3 e5                	shl    %cl,%ebp
  800fc3:	39 c5                	cmp    %eax,%ebp
  800fc5:	73 04                	jae    800fcb <__udivdi3+0xfb>
  800fc7:	39 d6                	cmp    %edx,%esi
  800fc9:	74 0d                	je     800fd8 <__udivdi3+0x108>
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	31 ff                	xor    %edi,%edi
  800fcf:	e9 3c ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fdb:	31 ff                	xor    %edi,%edi
  800fdd:	e9 2e ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fe2:	66 90                	xchg   %ax,%ax
  800fe4:	66 90                	xchg   %ax,%ax
  800fe6:	66 90                	xchg   %ax,%ax
  800fe8:	66 90                	xchg   %ax,%ax
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <__umoddi3>:
  800ff0:	f3 0f 1e fb          	endbr32 
  800ff4:	55                   	push   %ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 1c             	sub    $0x1c,%esp
  800ffb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801003:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801007:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	89 da                	mov    %ebx,%edx
  80100f:	85 ff                	test   %edi,%edi
  801011:	75 15                	jne    801028 <__umoddi3+0x38>
  801013:	39 dd                	cmp    %ebx,%ebp
  801015:	76 39                	jbe    801050 <__umoddi3+0x60>
  801017:	f7 f5                	div    %ebp
  801019:	89 d0                	mov    %edx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	83 c4 1c             	add    $0x1c,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
  801025:	8d 76 00             	lea    0x0(%esi),%esi
  801028:	39 df                	cmp    %ebx,%edi
  80102a:	77 f1                	ja     80101d <__umoddi3+0x2d>
  80102c:	0f bd cf             	bsr    %edi,%ecx
  80102f:	83 f1 1f             	xor    $0x1f,%ecx
  801032:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801036:	75 40                	jne    801078 <__umoddi3+0x88>
  801038:	39 df                	cmp    %ebx,%edi
  80103a:	72 04                	jb     801040 <__umoddi3+0x50>
  80103c:	39 f5                	cmp    %esi,%ebp
  80103e:	77 dd                	ja     80101d <__umoddi3+0x2d>
  801040:	89 da                	mov    %ebx,%edx
  801042:	89 f0                	mov    %esi,%eax
  801044:	29 e8                	sub    %ebp,%eax
  801046:	19 fa                	sbb    %edi,%edx
  801048:	eb d3                	jmp    80101d <__umoddi3+0x2d>
  80104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801050:	89 e9                	mov    %ebp,%ecx
  801052:	85 ed                	test   %ebp,%ebp
  801054:	75 0b                	jne    801061 <__umoddi3+0x71>
  801056:	b8 01 00 00 00       	mov    $0x1,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	f7 f5                	div    %ebp
  80105f:	89 c1                	mov    %eax,%ecx
  801061:	89 d8                	mov    %ebx,%eax
  801063:	31 d2                	xor    %edx,%edx
  801065:	f7 f1                	div    %ecx
  801067:	89 f0                	mov    %esi,%eax
  801069:	f7 f1                	div    %ecx
  80106b:	89 d0                	mov    %edx,%eax
  80106d:	31 d2                	xor    %edx,%edx
  80106f:	eb ac                	jmp    80101d <__umoddi3+0x2d>
  801071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801078:	8b 44 24 04          	mov    0x4(%esp),%eax
  80107c:	ba 20 00 00 00       	mov    $0x20,%edx
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 c1                	mov    %eax,%ecx
  801085:	89 e8                	mov    %ebp,%eax
  801087:	d3 e7                	shl    %cl,%edi
  801089:	89 d1                	mov    %edx,%ecx
  80108b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80108f:	d3 e8                	shr    %cl,%eax
  801091:	89 c1                	mov    %eax,%ecx
  801093:	8b 44 24 04          	mov    0x4(%esp),%eax
  801097:	09 f9                	or     %edi,%ecx
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80109f:	89 c1                	mov    %eax,%ecx
  8010a1:	d3 e5                	shl    %cl,%ebp
  8010a3:	89 d1                	mov    %edx,%ecx
  8010a5:	d3 ef                	shr    %cl,%edi
  8010a7:	89 c1                	mov    %eax,%ecx
  8010a9:	89 f0                	mov    %esi,%eax
  8010ab:	d3 e3                	shl    %cl,%ebx
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	89 fa                	mov    %edi,%edx
  8010b1:	d3 e8                	shr    %cl,%eax
  8010b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010b8:	09 d8                	or     %ebx,%eax
  8010ba:	f7 74 24 08          	divl   0x8(%esp)
  8010be:	89 d3                	mov    %edx,%ebx
  8010c0:	d3 e6                	shl    %cl,%esi
  8010c2:	f7 e5                	mul    %ebp
  8010c4:	89 c7                	mov    %eax,%edi
  8010c6:	89 d1                	mov    %edx,%ecx
  8010c8:	39 d3                	cmp    %edx,%ebx
  8010ca:	72 06                	jb     8010d2 <__umoddi3+0xe2>
  8010cc:	75 0e                	jne    8010dc <__umoddi3+0xec>
  8010ce:	39 c6                	cmp    %eax,%esi
  8010d0:	73 0a                	jae    8010dc <__umoddi3+0xec>
  8010d2:	29 e8                	sub    %ebp,%eax
  8010d4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010d8:	89 d1                	mov    %edx,%ecx
  8010da:	89 c7                	mov    %eax,%edi
  8010dc:	89 f5                	mov    %esi,%ebp
  8010de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010e2:	29 fd                	sub    %edi,%ebp
  8010e4:	19 cb                	sbb    %ecx,%ebx
  8010e6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	d3 e0                	shl    %cl,%eax
  8010ef:	89 f1                	mov    %esi,%ecx
  8010f1:	d3 ed                	shr    %cl,%ebp
  8010f3:	d3 eb                	shr    %cl,%ebx
  8010f5:	09 e8                	or     %ebp,%eax
  8010f7:	89 da                	mov    %ebx,%edx
  8010f9:	83 c4 1c             	add    $0x1c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
