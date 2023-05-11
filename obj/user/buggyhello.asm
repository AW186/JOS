
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 5d 00 00 00       	call   80009f <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 c6 00 00 00       	call   80011d <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800093:	6a 00                	push   $0x0
  800095:	e8 42 00 00 00       	call   8000dc <sys_env_destroy>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b0:	89 c3                	mov    %eax,%ebx
  8000b2:	89 c7                	mov    %eax,%edi
  8000b4:	89 c6                	mov    %eax,%esi
  8000b6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b8:	5b                   	pop    %ebx
  8000b9:	5e                   	pop    %esi
  8000ba:	5f                   	pop    %edi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cd:	89 d1                	mov    %edx,%ecx
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	89 d6                	mov    %edx,%esi
  8000d5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f2:	89 cb                	mov    %ecx,%ebx
  8000f4:	89 cf                	mov    %ecx,%edi
  8000f6:	89 ce                	mov    %ecx,%esi
  8000f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7f 08                	jg     800106 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800101:	5b                   	pop    %ebx
  800102:	5e                   	pop    %esi
  800103:	5f                   	pop    %edi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	50                   	push   %eax
  80010a:	6a 03                	push   $0x3
  80010c:	68 8a 10 80 00       	push   $0x80108a
  800111:	6a 23                	push   $0x23
  800113:	68 a7 10 80 00       	push   $0x8010a7
  800118:	e8 2f 02 00 00       	call   80034c <_panic>

0080011d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	57                   	push   %edi
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
	asm volatile("int %1\n"
  800123:	ba 00 00 00 00       	mov    $0x0,%edx
  800128:	b8 02 00 00 00       	mov    $0x2,%eax
  80012d:	89 d1                	mov    %edx,%ecx
  80012f:	89 d3                	mov    %edx,%ebx
  800131:	89 d7                	mov    %edx,%edi
  800133:	89 d6                	mov    %edx,%esi
  800135:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <sys_yield>:

void
sys_yield(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
	asm volatile("int %1\n"
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014c:	89 d1                	mov    %edx,%ecx
  80014e:	89 d3                	mov    %edx,%ebx
  800150:	89 d7                	mov    %edx,%edi
  800152:	89 d6                	mov    %edx,%esi
  800154:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5f                   	pop    %edi
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800164:	be 00 00 00 00       	mov    $0x0,%esi
  800169:	8b 55 08             	mov    0x8(%ebp),%edx
  80016c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016f:	b8 04 00 00 00       	mov    $0x4,%eax
  800174:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800177:	89 f7                	mov    %esi,%edi
  800179:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017b:	85 c0                	test   %eax,%eax
  80017d:	7f 08                	jg     800187 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800182:	5b                   	pop    %ebx
  800183:	5e                   	pop    %esi
  800184:	5f                   	pop    %edi
  800185:	5d                   	pop    %ebp
  800186:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	50                   	push   %eax
  80018b:	6a 04                	push   $0x4
  80018d:	68 8a 10 80 00       	push   $0x80108a
  800192:	6a 23                	push   $0x23
  800194:	68 a7 10 80 00       	push   $0x8010a7
  800199:	e8 ae 01 00 00       	call   80034c <_panic>

0080019e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ad:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	7f 08                	jg     8001c9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	6a 05                	push   $0x5
  8001cf:	68 8a 10 80 00       	push   $0x80108a
  8001d4:	6a 23                	push   $0x23
  8001d6:	68 a7 10 80 00       	push   $0x8010a7
  8001db:	e8 6c 01 00 00       	call   80034c <_panic>

008001e0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f9:	89 df                	mov    %ebx,%edi
  8001fb:	89 de                	mov    %ebx,%esi
  8001fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	7f 08                	jg     80020b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	6a 06                	push   $0x6
  800211:	68 8a 10 80 00       	push   $0x80108a
  800216:	6a 23                	push   $0x23
  800218:	68 a7 10 80 00       	push   $0x8010a7
  80021d:	e8 2a 01 00 00       	call   80034c <_panic>

00800222 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	57                   	push   %edi
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800236:	b8 08 00 00 00       	mov    $0x8,%eax
  80023b:	89 df                	mov    %ebx,%edi
  80023d:	89 de                	mov    %ebx,%esi
  80023f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	7f 08                	jg     80024d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	6a 08                	push   $0x8
  800253:	68 8a 10 80 00       	push   $0x80108a
  800258:	6a 23                	push   $0x23
  80025a:	68 a7 10 80 00       	push   $0x8010a7
  80025f:	e8 e8 00 00 00       	call   80034c <_panic>

00800264 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800278:	b8 09 00 00 00       	mov    $0x9,%eax
  80027d:	89 df                	mov    %ebx,%edi
  80027f:	89 de                	mov    %ebx,%esi
  800281:	cd 30                	int    $0x30
	if(check && ret > 0)
  800283:	85 c0                	test   %eax,%eax
  800285:	7f 08                	jg     80028f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	6a 09                	push   $0x9
  800295:	68 8a 10 80 00       	push   $0x80108a
  80029a:	6a 23                	push   $0x23
  80029c:	68 a7 10 80 00       	push   $0x8010a7
  8002a1:	e8 a6 00 00 00       	call   80034c <_panic>

008002a6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	89 de                	mov    %ebx,%esi
  8002c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	7f 08                	jg     8002d1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	50                   	push   %eax
  8002d5:	6a 0a                	push   $0xa
  8002d7:	68 8a 10 80 00       	push   $0x80108a
  8002dc:	6a 23                	push   $0x23
  8002de:	68 a7 10 80 00       	push   $0x8010a7
  8002e3:	e8 64 00 00 00       	call   80034c <_panic>

008002e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f9:	be 00 00 00 00       	mov    $0x0,%esi
  8002fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800301:	8b 7d 14             	mov    0x14(%ebp),%edi
  800304:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800314:	b9 00 00 00 00       	mov    $0x0,%ecx
  800319:	8b 55 08             	mov    0x8(%ebp),%edx
  80031c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800321:	89 cb                	mov    %ecx,%ebx
  800323:	89 cf                	mov    %ecx,%edi
  800325:	89 ce                	mov    %ecx,%esi
  800327:	cd 30                	int    $0x30
	if(check && ret > 0)
  800329:	85 c0                	test   %eax,%eax
  80032b:	7f 08                	jg     800335 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800330:	5b                   	pop    %ebx
  800331:	5e                   	pop    %esi
  800332:	5f                   	pop    %edi
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	6a 0d                	push   $0xd
  80033b:	68 8a 10 80 00       	push   $0x80108a
  800340:	6a 23                	push   $0x23
  800342:	68 a7 10 80 00       	push   $0x8010a7
  800347:	e8 00 00 00 00       	call   80034c <_panic>

0080034c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800351:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800354:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80035a:	e8 be fd ff ff       	call   80011d <sys_getenvid>
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 0c             	push   0xc(%ebp)
  800365:	ff 75 08             	push   0x8(%ebp)
  800368:	56                   	push   %esi
  800369:	50                   	push   %eax
  80036a:	68 b8 10 80 00       	push   $0x8010b8
  80036f:	e8 b3 00 00 00       	call   800427 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800374:	83 c4 18             	add    $0x18,%esp
  800377:	53                   	push   %ebx
  800378:	ff 75 10             	push   0x10(%ebp)
  80037b:	e8 56 00 00 00       	call   8003d6 <vcprintf>
	cprintf("\n");
  800380:	c7 04 24 db 10 80 00 	movl   $0x8010db,(%esp)
  800387:	e8 9b 00 00 00       	call   800427 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038f:	cc                   	int3   
  800390:	eb fd                	jmp    80038f <_panic+0x43>

00800392 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	53                   	push   %ebx
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039c:	8b 13                	mov    (%ebx),%edx
  80039e:	8d 42 01             	lea    0x1(%edx),%eax
  8003a1:	89 03                	mov    %eax,(%ebx)
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	74 09                	je     8003ba <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	68 ff 00 00 00       	push   $0xff
  8003c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c5:	50                   	push   %eax
  8003c6:	e8 d4 fc ff ff       	call   80009f <sys_cputs>
		b->idx = 0;
  8003cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	eb db                	jmp    8003b1 <putch+0x1f>

008003d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f3:	ff 75 0c             	push   0xc(%ebp)
  8003f6:	ff 75 08             	push   0x8(%ebp)
  8003f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	68 92 03 80 00       	push   $0x800392
  800405:	e8 14 01 00 00       	call   80051e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040a:	83 c4 08             	add    $0x8,%esp
  80040d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800413:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	e8 80 fc ff ff       	call   80009f <sys_cputs>

	return b.cnt;
}
  80041f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 08             	push   0x8(%ebp)
  800434:	e8 9d ff ff ff       	call   8003d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	57                   	push   %edi
  80043f:	56                   	push   %esi
  800440:	53                   	push   %ebx
  800441:	83 ec 1c             	sub    $0x1c,%esp
  800444:	89 c7                	mov    %eax,%edi
  800446:	89 d6                	mov    %edx,%esi
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044e:	89 d1                	mov    %edx,%ecx
  800450:	89 c2                	mov    %eax,%edx
  800452:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800455:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800458:	8b 45 10             	mov    0x10(%ebp),%eax
  80045b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80045e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800461:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800468:	39 c2                	cmp    %eax,%edx
  80046a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046d:	72 3e                	jb     8004ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	ff 75 18             	push   0x18(%ebp)
  800475:	83 eb 01             	sub    $0x1,%ebx
  800478:	53                   	push   %ebx
  800479:	50                   	push   %eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 e4             	push   -0x1c(%ebp)
  800480:	ff 75 e0             	push   -0x20(%ebp)
  800483:	ff 75 dc             	push   -0x24(%ebp)
  800486:	ff 75 d8             	push   -0x28(%ebp)
  800489:	e8 a2 09 00 00       	call   800e30 <__udivdi3>
  80048e:	83 c4 18             	add    $0x18,%esp
  800491:	52                   	push   %edx
  800492:	50                   	push   %eax
  800493:	89 f2                	mov    %esi,%edx
  800495:	89 f8                	mov    %edi,%eax
  800497:	e8 9f ff ff ff       	call   80043b <printnum>
  80049c:	83 c4 20             	add    $0x20,%esp
  80049f:	eb 13                	jmp    8004b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	56                   	push   %esi
  8004a5:	ff 75 18             	push   0x18(%ebp)
  8004a8:	ff d7                	call   *%edi
  8004aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004ad:	83 eb 01             	sub    $0x1,%ebx
  8004b0:	85 db                	test   %ebx,%ebx
  8004b2:	7f ed                	jg     8004a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	56                   	push   %esi
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 e4             	push   -0x1c(%ebp)
  8004be:	ff 75 e0             	push   -0x20(%ebp)
  8004c1:	ff 75 dc             	push   -0x24(%ebp)
  8004c4:	ff 75 d8             	push   -0x28(%ebp)
  8004c7:	e8 84 0a 00 00       	call   800f50 <__umoddi3>
  8004cc:	83 c4 14             	add    $0x14,%esp
  8004cf:	0f be 80 dd 10 80 00 	movsbl 0x8010dd(%eax),%eax
  8004d6:	50                   	push   %eax
  8004d7:	ff d7                	call   *%edi
}
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004df:	5b                   	pop    %ebx
  8004e0:	5e                   	pop    %esi
  8004e1:	5f                   	pop    %edi
  8004e2:	5d                   	pop    %ebp
  8004e3:	c3                   	ret    

008004e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ee:	8b 10                	mov    (%eax),%edx
  8004f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f3:	73 0a                	jae    8004ff <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f8:	89 08                	mov    %ecx,(%eax)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	88 02                	mov    %al,(%edx)
}
  8004ff:	5d                   	pop    %ebp
  800500:	c3                   	ret    

00800501 <printfmt>:
{
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800507:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050a:	50                   	push   %eax
  80050b:	ff 75 10             	push   0x10(%ebp)
  80050e:	ff 75 0c             	push   0xc(%ebp)
  800511:	ff 75 08             	push   0x8(%ebp)
  800514:	e8 05 00 00 00       	call   80051e <vprintfmt>
}
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <vprintfmt>:
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	57                   	push   %edi
  800522:	56                   	push   %esi
  800523:	53                   	push   %ebx
  800524:	83 ec 3c             	sub    $0x3c,%esp
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
  80052a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800530:	eb 0a                	jmp    80053c <vprintfmt+0x1e>
			putch(ch, putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	50                   	push   %eax
  800537:	ff d6                	call   *%esi
  800539:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053c:	83 c7 01             	add    $0x1,%edi
  80053f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800543:	83 f8 25             	cmp    $0x25,%eax
  800546:	74 0c                	je     800554 <vprintfmt+0x36>
			if (ch == '\0')
  800548:	85 c0                	test   %eax,%eax
  80054a:	75 e6                	jne    800532 <vprintfmt+0x14>
}
  80054c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80054f:	5b                   	pop    %ebx
  800550:	5e                   	pop    %esi
  800551:	5f                   	pop    %edi
  800552:	5d                   	pop    %ebp
  800553:	c3                   	ret    
		padc = ' ';
  800554:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800558:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80055f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800566:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80056d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8d 47 01             	lea    0x1(%edi),%eax
  800575:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800578:	0f b6 17             	movzbl (%edi),%edx
  80057b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80057e:	3c 55                	cmp    $0x55,%al
  800580:	0f 87 a6 04 00 00    	ja     800a2c <vprintfmt+0x50e>
  800586:	0f b6 c0             	movzbl %al,%eax
  800589:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  800590:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800593:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800597:	eb d9                	jmp    800572 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800599:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80059c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005a0:	eb d0                	jmp    800572 <vprintfmt+0x54>
  8005a2:	0f b6 d2             	movzbl %dl,%edx
  8005a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005b7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ba:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005bd:	83 f9 09             	cmp    $0x9,%ecx
  8005c0:	77 55                	ja     800617 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005c2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c5:	eb e9                	jmp    8005b0 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005df:	79 91                	jns    800572 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005ee:	eb 82                	jmp    800572 <vprintfmt+0x54>
  8005f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f3:	85 d2                	test   %edx,%edx
  8005f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fa:	0f 49 c2             	cmovns %edx,%eax
  8005fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800600:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800603:	e9 6a ff ff ff       	jmp    800572 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800608:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80060b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800612:	e9 5b ff ff ff       	jmp    800572 <vprintfmt+0x54>
  800617:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061d:	eb bc                	jmp    8005db <vprintfmt+0xbd>
			lflag++;
  80061f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800622:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800625:	e9 48 ff ff ff       	jmp    800572 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 78 04             	lea    0x4(%eax),%edi
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	ff 30                	push   (%eax)
  800636:	ff d6                	call   *%esi
			break;
  800638:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80063b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80063e:	e9 88 03 00 00       	jmp    8009cb <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 78 04             	lea    0x4(%eax),%edi
  800649:	8b 10                	mov    (%eax),%edx
  80064b:	89 d0                	mov    %edx,%eax
  80064d:	f7 d8                	neg    %eax
  80064f:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800652:	83 f8 0f             	cmp    $0xf,%eax
  800655:	7f 23                	jg     80067a <vprintfmt+0x15c>
  800657:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  80065e:	85 d2                	test   %edx,%edx
  800660:	74 18                	je     80067a <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800662:	52                   	push   %edx
  800663:	68 fe 10 80 00       	push   $0x8010fe
  800668:	53                   	push   %ebx
  800669:	56                   	push   %esi
  80066a:	e8 92 fe ff ff       	call   800501 <printfmt>
  80066f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800672:	89 7d 14             	mov    %edi,0x14(%ebp)
  800675:	e9 51 03 00 00       	jmp    8009cb <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80067a:	50                   	push   %eax
  80067b:	68 f5 10 80 00       	push   $0x8010f5
  800680:	53                   	push   %ebx
  800681:	56                   	push   %esi
  800682:	e8 7a fe ff ff       	call   800501 <printfmt>
  800687:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80068a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80068d:	e9 39 03 00 00       	jmp    8009cb <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 c0 04             	add    $0x4,%eax
  800698:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006a0:	85 d2                	test   %edx,%edx
  8006a2:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  8006a7:	0f 45 c2             	cmovne %edx,%eax
  8006aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b1:	7e 06                	jle    8006b9 <vprintfmt+0x19b>
  8006b3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006b7:	75 0d                	jne    8006c6 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006bc:	89 c7                	mov    %eax,%edi
  8006be:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006c4:	eb 55                	jmp    80071b <vprintfmt+0x1fd>
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 e0             	push   -0x20(%ebp)
  8006cc:	ff 75 cc             	push   -0x34(%ebp)
  8006cf:	e8 f5 03 00 00       	call   800ac9 <strnlen>
  8006d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d7:	29 c2                	sub    %eax,%edx
  8006d9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006e1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e8:	eb 0f                	jmp    8006f9 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	ff 75 d4             	push   -0x2c(%ebp)
  8006f1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f3:	83 ef 01             	sub    $0x1,%edi
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	85 ff                	test   %edi,%edi
  8006fb:	7f ed                	jg     8006ea <vprintfmt+0x1cc>
  8006fd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800700:	85 d2                	test   %edx,%edx
  800702:	b8 00 00 00 00       	mov    $0x0,%eax
  800707:	0f 49 c2             	cmovns %edx,%eax
  80070a:	29 c2                	sub    %eax,%edx
  80070c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80070f:	eb a8                	jmp    8006b9 <vprintfmt+0x19b>
					putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	52                   	push   %edx
  800716:	ff d6                	call   *%esi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80071e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800720:	83 c7 01             	add    $0x1,%edi
  800723:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800727:	0f be d0             	movsbl %al,%edx
  80072a:	85 d2                	test   %edx,%edx
  80072c:	74 4b                	je     800779 <vprintfmt+0x25b>
  80072e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800732:	78 06                	js     80073a <vprintfmt+0x21c>
  800734:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800738:	78 1e                	js     800758 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80073e:	74 d1                	je     800711 <vprintfmt+0x1f3>
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 e8 20             	sub    $0x20,%eax
  800746:	83 f8 5e             	cmp    $0x5e,%eax
  800749:	76 c6                	jbe    800711 <vprintfmt+0x1f3>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 3f                	push   $0x3f
  800751:	ff d6                	call   *%esi
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	eb c3                	jmp    80071b <vprintfmt+0x1fd>
  800758:	89 cf                	mov    %ecx,%edi
  80075a:	eb 0e                	jmp    80076a <vprintfmt+0x24c>
				putch(' ', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	6a 20                	push   $0x20
  800762:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800764:	83 ef 01             	sub    $0x1,%edi
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	85 ff                	test   %edi,%edi
  80076c:	7f ee                	jg     80075c <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80076e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800771:	89 45 14             	mov    %eax,0x14(%ebp)
  800774:	e9 52 02 00 00       	jmp    8009cb <vprintfmt+0x4ad>
  800779:	89 cf                	mov    %ecx,%edi
  80077b:	eb ed                	jmp    80076a <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	83 c0 04             	add    $0x4,%eax
  800783:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80078b:	85 d2                	test   %edx,%edx
  80078d:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  800792:	0f 45 c2             	cmovne %edx,%eax
  800795:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800798:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80079c:	7e 06                	jle    8007a4 <vprintfmt+0x286>
  80079e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8007a2:	75 0d                	jne    8007b1 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007a7:	89 c7                	mov    %eax,%edi
  8007a9:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007af:	eb 55                	jmp    800806 <vprintfmt+0x2e8>
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 e0             	push   -0x20(%ebp)
  8007b7:	ff 75 cc             	push   -0x34(%ebp)
  8007ba:	e8 0a 03 00 00       	call   800ac9 <strnlen>
  8007bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007c2:	29 c2                	sub    %eax,%edx
  8007c4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007cc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d3:	eb 0f                	jmp    8007e4 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	ff 75 d4             	push   -0x2c(%ebp)
  8007dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007de:	83 ef 01             	sub    $0x1,%edi
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	85 ff                	test   %edi,%edi
  8007e6:	7f ed                	jg     8007d5 <vprintfmt+0x2b7>
  8007e8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f2:	0f 49 c2             	cmovns %edx,%eax
  8007f5:	29 c2                	sub    %eax,%edx
  8007f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007fa:	eb a8                	jmp    8007a4 <vprintfmt+0x286>
					putch(ch, putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	53                   	push   %ebx
  800800:	52                   	push   %edx
  800801:	ff d6                	call   *%esi
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800809:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80080b:	83 c7 01             	add    $0x1,%edi
  80080e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800812:	0f be d0             	movsbl %al,%edx
  800815:	3c 3a                	cmp    $0x3a,%al
  800817:	74 4b                	je     800864 <vprintfmt+0x346>
  800819:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081d:	78 06                	js     800825 <vprintfmt+0x307>
  80081f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800823:	78 1e                	js     800843 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800825:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800829:	74 d1                	je     8007fc <vprintfmt+0x2de>
  80082b:	0f be c0             	movsbl %al,%eax
  80082e:	83 e8 20             	sub    $0x20,%eax
  800831:	83 f8 5e             	cmp    $0x5e,%eax
  800834:	76 c6                	jbe    8007fc <vprintfmt+0x2de>
					putch('?', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 3f                	push   $0x3f
  80083c:	ff d6                	call   *%esi
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	eb c3                	jmp    800806 <vprintfmt+0x2e8>
  800843:	89 cf                	mov    %ecx,%edi
  800845:	eb 0e                	jmp    800855 <vprintfmt+0x337>
				putch(' ', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	53                   	push   %ebx
  80084b:	6a 20                	push   $0x20
  80084d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80084f:	83 ef 01             	sub    $0x1,%edi
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	85 ff                	test   %edi,%edi
  800857:	7f ee                	jg     800847 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800859:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
  80085f:	e9 67 01 00 00       	jmp    8009cb <vprintfmt+0x4ad>
  800864:	89 cf                	mov    %ecx,%edi
  800866:	eb ed                	jmp    800855 <vprintfmt+0x337>
	if (lflag >= 2)
  800868:	83 f9 01             	cmp    $0x1,%ecx
  80086b:	7f 1b                	jg     800888 <vprintfmt+0x36a>
	else if (lflag)
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	74 63                	je     8008d4 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800879:	99                   	cltd   
  80087a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8d 40 04             	lea    0x4(%eax),%eax
  800883:	89 45 14             	mov    %eax,0x14(%ebp)
  800886:	eb 17                	jmp    80089f <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	8b 50 04             	mov    0x4(%eax),%edx
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800893:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8d 40 08             	lea    0x8(%eax),%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80089f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8008a5:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008aa:	85 c9                	test   %ecx,%ecx
  8008ac:	0f 89 ff 00 00 00    	jns    8009b1 <vprintfmt+0x493>
				putch('-', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 2d                	push   $0x2d
  8008b8:	ff d6                	call   *%esi
				num = -(long long) num;
  8008ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008c0:	f7 da                	neg    %edx
  8008c2:	83 d1 00             	adc    $0x0,%ecx
  8008c5:	f7 d9                	neg    %ecx
  8008c7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008ca:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008cf:	e9 dd 00 00 00       	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008dc:	99                   	cltd   
  8008dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 40 04             	lea    0x4(%eax),%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	eb b4                	jmp    80089f <vprintfmt+0x381>
	if (lflag >= 2)
  8008eb:	83 f9 01             	cmp    $0x1,%ecx
  8008ee:	7f 1e                	jg     80090e <vprintfmt+0x3f0>
	else if (lflag)
  8008f0:	85 c9                	test   %ecx,%ecx
  8008f2:	74 32                	je     800926 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8b 10                	mov    (%eax),%edx
  8008f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008fe:	8d 40 04             	lea    0x4(%eax),%eax
  800901:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800904:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800909:	e9 a3 00 00 00       	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 10                	mov    (%eax),%edx
  800913:	8b 48 04             	mov    0x4(%eax),%ecx
  800916:	8d 40 08             	lea    0x8(%eax),%eax
  800919:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091c:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800921:	e9 8b 00 00 00       	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	8b 10                	mov    (%eax),%edx
  80092b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800930:	8d 40 04             	lea    0x4(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800936:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80093b:	eb 74                	jmp    8009b1 <vprintfmt+0x493>
	if (lflag >= 2)
  80093d:	83 f9 01             	cmp    $0x1,%ecx
  800940:	7f 1b                	jg     80095d <vprintfmt+0x43f>
	else if (lflag)
  800942:	85 c9                	test   %ecx,%ecx
  800944:	74 2c                	je     800972 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 10                	mov    (%eax),%edx
  80094b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800956:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80095b:	eb 54                	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8b 10                	mov    (%eax),%edx
  800962:	8b 48 04             	mov    0x4(%eax),%ecx
  800965:	8d 40 08             	lea    0x8(%eax),%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096b:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800970:	eb 3f                	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800972:	8b 45 14             	mov    0x14(%ebp),%eax
  800975:	8b 10                	mov    (%eax),%edx
  800977:	b9 00 00 00 00       	mov    $0x0,%ecx
  80097c:	8d 40 04             	lea    0x4(%eax),%eax
  80097f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800982:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800987:	eb 28                	jmp    8009b1 <vprintfmt+0x493>
			putch('0', putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	53                   	push   %ebx
  80098d:	6a 30                	push   $0x30
  80098f:	ff d6                	call   *%esi
			putch('x', putdat);
  800991:	83 c4 08             	add    $0x8,%esp
  800994:	53                   	push   %ebx
  800995:	6a 78                	push   $0x78
  800997:	ff d6                	call   *%esi
			num = (unsigned long long)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	8b 10                	mov    (%eax),%edx
  80099e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009a3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009a6:	8d 40 04             	lea    0x4(%eax),%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ac:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009b1:	83 ec 0c             	sub    $0xc,%esp
  8009b4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	ff 75 d4             	push   -0x2c(%ebp)
  8009bc:	57                   	push   %edi
  8009bd:	51                   	push   %ecx
  8009be:	52                   	push   %edx
  8009bf:	89 da                	mov    %ebx,%edx
  8009c1:	89 f0                	mov    %esi,%eax
  8009c3:	e8 73 fa ff ff       	call   80043b <printnum>
			break;
  8009c8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ce:	e9 69 fb ff ff       	jmp    80053c <vprintfmt+0x1e>
	if (lflag >= 2)
  8009d3:	83 f9 01             	cmp    $0x1,%ecx
  8009d6:	7f 1b                	jg     8009f3 <vprintfmt+0x4d5>
	else if (lflag)
  8009d8:	85 c9                	test   %ecx,%ecx
  8009da:	74 2c                	je     800a08 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	8b 10                	mov    (%eax),%edx
  8009e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e6:	8d 40 04             	lea    0x4(%eax),%eax
  8009e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ec:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009f1:	eb be                	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	8b 10                	mov    (%eax),%edx
  8009f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8009fb:	8d 40 08             	lea    0x8(%eax),%eax
  8009fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a01:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800a06:	eb a9                	jmp    8009b1 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8b 10                	mov    (%eax),%edx
  800a0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a12:	8d 40 04             	lea    0x4(%eax),%eax
  800a15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a18:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a1d:	eb 92                	jmp    8009b1 <vprintfmt+0x493>
			putch(ch, putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	53                   	push   %ebx
  800a23:	6a 25                	push   $0x25
  800a25:	ff d6                	call   *%esi
			break;
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	eb 9f                	jmp    8009cb <vprintfmt+0x4ad>
			putch('%', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	53                   	push   %ebx
  800a30:	6a 25                	push   $0x25
  800a32:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a34:	83 c4 10             	add    $0x10,%esp
  800a37:	89 f8                	mov    %edi,%eax
  800a39:	eb 03                	jmp    800a3e <vprintfmt+0x520>
  800a3b:	83 e8 01             	sub    $0x1,%eax
  800a3e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a42:	75 f7                	jne    800a3b <vprintfmt+0x51d>
  800a44:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a47:	eb 82                	jmp    8009cb <vprintfmt+0x4ad>

00800a49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	83 ec 18             	sub    $0x18,%esp
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a58:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a5c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a66:	85 c0                	test   %eax,%eax
  800a68:	74 26                	je     800a90 <vsnprintf+0x47>
  800a6a:	85 d2                	test   %edx,%edx
  800a6c:	7e 22                	jle    800a90 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a6e:	ff 75 14             	push   0x14(%ebp)
  800a71:	ff 75 10             	push   0x10(%ebp)
  800a74:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a77:	50                   	push   %eax
  800a78:	68 e4 04 80 00       	push   $0x8004e4
  800a7d:	e8 9c fa ff ff       	call   80051e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    
		return -E_INVAL;
  800a90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a95:	eb f7                	jmp    800a8e <vsnprintf+0x45>

00800a97 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a9d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 10             	push   0x10(%ebp)
  800aa4:	ff 75 0c             	push   0xc(%ebp)
  800aa7:	ff 75 08             	push   0x8(%ebp)
  800aaa:	e8 9a ff ff ff       	call   800a49 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  800abc:	eb 03                	jmp    800ac1 <strlen+0x10>
		n++;
  800abe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ac1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ac5:	75 f7                	jne    800abe <strlen+0xd>
	return n;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	eb 03                	jmp    800adc <strnlen+0x13>
		n++;
  800ad9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adc:	39 d0                	cmp    %edx,%eax
  800ade:	74 08                	je     800ae8 <strnlen+0x1f>
  800ae0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ae4:	75 f3                	jne    800ad9 <strnlen+0x10>
  800ae6:	89 c2                	mov    %eax,%edx
	return n;
}
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	53                   	push   %ebx
  800af0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800af6:	b8 00 00 00 00       	mov    $0x0,%eax
  800afb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800aff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	84 d2                	test   %dl,%dl
  800b07:	75 f2                	jne    800afb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b09:	89 c8                	mov    %ecx,%eax
  800b0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	53                   	push   %ebx
  800b14:	83 ec 10             	sub    $0x10,%esp
  800b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b1a:	53                   	push   %ebx
  800b1b:	e8 91 ff ff ff       	call   800ab1 <strlen>
  800b20:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b23:	ff 75 0c             	push   0xc(%ebp)
  800b26:	01 d8                	add    %ebx,%eax
  800b28:	50                   	push   %eax
  800b29:	e8 be ff ff ff       	call   800aec <strcpy>
	return dst;
}
  800b2e:	89 d8                	mov    %ebx,%eax
  800b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b33:	c9                   	leave  
  800b34:	c3                   	ret    

00800b35 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	89 f3                	mov    %esi,%ebx
  800b42:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b45:	89 f0                	mov    %esi,%eax
  800b47:	eb 0f                	jmp    800b58 <strncpy+0x23>
		*dst++ = *src;
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	0f b6 0a             	movzbl (%edx),%ecx
  800b4f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b52:	80 f9 01             	cmp    $0x1,%cl
  800b55:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b58:	39 d8                	cmp    %ebx,%eax
  800b5a:	75 ed                	jne    800b49 <strncpy+0x14>
	}
	return ret;
}
  800b5c:	89 f0                	mov    %esi,%eax
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
  800b67:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6d:	8b 55 10             	mov    0x10(%ebp),%edx
  800b70:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b72:	85 d2                	test   %edx,%edx
  800b74:	74 21                	je     800b97 <strlcpy+0x35>
  800b76:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b7a:	89 f2                	mov    %esi,%edx
  800b7c:	eb 09                	jmp    800b87 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b7e:	83 c1 01             	add    $0x1,%ecx
  800b81:	83 c2 01             	add    $0x1,%edx
  800b84:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b87:	39 c2                	cmp    %eax,%edx
  800b89:	74 09                	je     800b94 <strlcpy+0x32>
  800b8b:	0f b6 19             	movzbl (%ecx),%ebx
  800b8e:	84 db                	test   %bl,%bl
  800b90:	75 ec                	jne    800b7e <strlcpy+0x1c>
  800b92:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b97:	29 f0                	sub    %esi,%eax
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba6:	eb 06                	jmp    800bae <strcmp+0x11>
		p++, q++;
  800ba8:	83 c1 01             	add    $0x1,%ecx
  800bab:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bae:	0f b6 01             	movzbl (%ecx),%eax
  800bb1:	84 c0                	test   %al,%al
  800bb3:	74 04                	je     800bb9 <strcmp+0x1c>
  800bb5:	3a 02                	cmp    (%edx),%al
  800bb7:	74 ef                	je     800ba8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb9:	0f b6 c0             	movzbl %al,%eax
  800bbc:	0f b6 12             	movzbl (%edx),%edx
  800bbf:	29 d0                	sub    %edx,%eax
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	53                   	push   %ebx
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcd:	89 c3                	mov    %eax,%ebx
  800bcf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd2:	eb 06                	jmp    800bda <strncmp+0x17>
		n--, p++, q++;
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bda:	39 d8                	cmp    %ebx,%eax
  800bdc:	74 18                	je     800bf6 <strncmp+0x33>
  800bde:	0f b6 08             	movzbl (%eax),%ecx
  800be1:	84 c9                	test   %cl,%cl
  800be3:	74 04                	je     800be9 <strncmp+0x26>
  800be5:	3a 0a                	cmp    (%edx),%cl
  800be7:	74 eb                	je     800bd4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800be9:	0f b6 00             	movzbl (%eax),%eax
  800bec:	0f b6 12             	movzbl (%edx),%edx
  800bef:	29 d0                	sub    %edx,%eax
}
  800bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    
		return 0;
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	eb f4                	jmp    800bf1 <strncmp+0x2e>

00800bfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c07:	eb 03                	jmp    800c0c <strchr+0xf>
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	0f b6 10             	movzbl (%eax),%edx
  800c0f:	84 d2                	test   %dl,%dl
  800c11:	74 06                	je     800c19 <strchr+0x1c>
		if (*s == c)
  800c13:	38 ca                	cmp    %cl,%dl
  800c15:	75 f2                	jne    800c09 <strchr+0xc>
  800c17:	eb 05                	jmp    800c1e <strchr+0x21>
			return (char *) s;
	return 0;
  800c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c2a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c2d:	38 ca                	cmp    %cl,%dl
  800c2f:	74 09                	je     800c3a <strfind+0x1a>
  800c31:	84 d2                	test   %dl,%dl
  800c33:	74 05                	je     800c3a <strfind+0x1a>
	for (; *s; s++)
  800c35:	83 c0 01             	add    $0x1,%eax
  800c38:	eb f0                	jmp    800c2a <strfind+0xa>
			break;
	return (char *) s;
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c48:	85 c9                	test   %ecx,%ecx
  800c4a:	74 2f                	je     800c7b <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4c:	89 f8                	mov    %edi,%eax
  800c4e:	09 c8                	or     %ecx,%eax
  800c50:	a8 03                	test   $0x3,%al
  800c52:	75 21                	jne    800c75 <memset+0x39>
		c &= 0xFF;
  800c54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c58:	89 d0                	mov    %edx,%eax
  800c5a:	c1 e0 08             	shl    $0x8,%eax
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	c1 e3 18             	shl    $0x18,%ebx
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	c1 e6 10             	shl    $0x10,%esi
  800c67:	09 f3                	or     %esi,%ebx
  800c69:	09 da                	or     %ebx,%edx
  800c6b:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c70:	fc                   	cld    
  800c71:	f3 ab                	rep stos %eax,%es:(%edi)
  800c73:	eb 06                	jmp    800c7b <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	fc                   	cld    
  800c79:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7b:	89 f8                	mov    %edi,%eax
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c90:	39 c6                	cmp    %eax,%esi
  800c92:	73 32                	jae    800cc6 <memmove+0x44>
  800c94:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	76 2b                	jbe    800cc6 <memmove+0x44>
		s += n;
		d += n;
  800c9b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9e:	89 d6                	mov    %edx,%esi
  800ca0:	09 fe                	or     %edi,%esi
  800ca2:	09 ce                	or     %ecx,%esi
  800ca4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800caa:	75 0e                	jne    800cba <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cac:	83 ef 04             	sub    $0x4,%edi
  800caf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb5:	fd                   	std    
  800cb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb8:	eb 09                	jmp    800cc3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cba:	83 ef 01             	sub    $0x1,%edi
  800cbd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc0:	fd                   	std    
  800cc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc3:	fc                   	cld    
  800cc4:	eb 1a                	jmp    800ce0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc6:	89 f2                	mov    %esi,%edx
  800cc8:	09 c2                	or     %eax,%edx
  800cca:	09 ca                	or     %ecx,%edx
  800ccc:	f6 c2 03             	test   $0x3,%dl
  800ccf:	75 0a                	jne    800cdb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	fc                   	cld    
  800cd7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cd9:	eb 05                	jmp    800ce0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cdb:	89 c7                	mov    %eax,%edi
  800cdd:	fc                   	cld    
  800cde:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cea:	ff 75 10             	push   0x10(%ebp)
  800ced:	ff 75 0c             	push   0xc(%ebp)
  800cf0:	ff 75 08             	push   0x8(%ebp)
  800cf3:	e8 8a ff ff ff       	call   800c82 <memmove>
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	89 c6                	mov    %eax,%esi
  800d07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0a:	eb 06                	jmp    800d12 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d0c:	83 c0 01             	add    $0x1,%eax
  800d0f:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d12:	39 f0                	cmp    %esi,%eax
  800d14:	74 14                	je     800d2a <memcmp+0x30>
		if (*s1 != *s2)
  800d16:	0f b6 08             	movzbl (%eax),%ecx
  800d19:	0f b6 1a             	movzbl (%edx),%ebx
  800d1c:	38 d9                	cmp    %bl,%cl
  800d1e:	74 ec                	je     800d0c <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d20:	0f b6 c1             	movzbl %cl,%eax
  800d23:	0f b6 db             	movzbl %bl,%ebx
  800d26:	29 d8                	sub    %ebx,%eax
  800d28:	eb 05                	jmp    800d2f <memcmp+0x35>
	}

	return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d3c:	89 c2                	mov    %eax,%edx
  800d3e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d41:	eb 03                	jmp    800d46 <memfind+0x13>
  800d43:	83 c0 01             	add    $0x1,%eax
  800d46:	39 d0                	cmp    %edx,%eax
  800d48:	73 04                	jae    800d4e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d4a:	38 08                	cmp    %cl,(%eax)
  800d4c:	75 f5                	jne    800d43 <memfind+0x10>
			break;
	return (void *) s;
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5c:	eb 03                	jmp    800d61 <strtol+0x11>
		s++;
  800d5e:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d61:	0f b6 02             	movzbl (%edx),%eax
  800d64:	3c 20                	cmp    $0x20,%al
  800d66:	74 f6                	je     800d5e <strtol+0xe>
  800d68:	3c 09                	cmp    $0x9,%al
  800d6a:	74 f2                	je     800d5e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d6c:	3c 2b                	cmp    $0x2b,%al
  800d6e:	74 2a                	je     800d9a <strtol+0x4a>
	int neg = 0;
  800d70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d75:	3c 2d                	cmp    $0x2d,%al
  800d77:	74 2b                	je     800da4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d7f:	75 0f                	jne    800d90 <strtol+0x40>
  800d81:	80 3a 30             	cmpb   $0x30,(%edx)
  800d84:	74 28                	je     800dae <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d86:	85 db                	test   %ebx,%ebx
  800d88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d8d:	0f 44 d8             	cmove  %eax,%ebx
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d98:	eb 46                	jmp    800de0 <strtol+0x90>
		s++;
  800d9a:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800da2:	eb d5                	jmp    800d79 <strtol+0x29>
		s++, neg = 1;
  800da4:	83 c2 01             	add    $0x1,%edx
  800da7:	bf 01 00 00 00       	mov    $0x1,%edi
  800dac:	eb cb                	jmp    800d79 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dae:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db2:	74 0e                	je     800dc2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	75 d8                	jne    800d90 <strtol+0x40>
		s++, base = 8;
  800db8:	83 c2 01             	add    $0x1,%edx
  800dbb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc0:	eb ce                	jmp    800d90 <strtol+0x40>
		s += 2, base = 16;
  800dc2:	83 c2 02             	add    $0x2,%edx
  800dc5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dca:	eb c4                	jmp    800d90 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dcc:	0f be c0             	movsbl %al,%eax
  800dcf:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd5:	7d 3a                	jge    800e11 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dd7:	83 c2 01             	add    $0x1,%edx
  800dda:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dde:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800de0:	0f b6 02             	movzbl (%edx),%eax
  800de3:	8d 70 d0             	lea    -0x30(%eax),%esi
  800de6:	89 f3                	mov    %esi,%ebx
  800de8:	80 fb 09             	cmp    $0x9,%bl
  800deb:	76 df                	jbe    800dcc <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800ded:	8d 70 9f             	lea    -0x61(%eax),%esi
  800df0:	89 f3                	mov    %esi,%ebx
  800df2:	80 fb 19             	cmp    $0x19,%bl
  800df5:	77 08                	ja     800dff <strtol+0xaf>
			dig = *s - 'a' + 10;
  800df7:	0f be c0             	movsbl %al,%eax
  800dfa:	83 e8 57             	sub    $0x57,%eax
  800dfd:	eb d3                	jmp    800dd2 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800dff:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e02:	89 f3                	mov    %esi,%ebx
  800e04:	80 fb 19             	cmp    $0x19,%bl
  800e07:	77 08                	ja     800e11 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e09:	0f be c0             	movsbl %al,%eax
  800e0c:	83 e8 37             	sub    $0x37,%eax
  800e0f:	eb c1                	jmp    800dd2 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e15:	74 05                	je     800e1c <strtol+0xcc>
		*endptr = (char *) s;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e1c:	89 c8                	mov    %ecx,%eax
  800e1e:	f7 d8                	neg    %eax
  800e20:	85 ff                	test   %edi,%edi
  800e22:	0f 45 c8             	cmovne %eax,%ecx
}
  800e25:	89 c8                	mov    %ecx,%eax
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
  800e2c:	66 90                	xchg   %ax,%ax
  800e2e:	66 90                	xchg   %ax,%ax

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
