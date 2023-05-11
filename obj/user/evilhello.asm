
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 5d 00 00 00       	call   8000a2 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 c6 00 00 00       	call   800120 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 8a 10 80 00       	push   $0x80108a
  800114:	6a 23                	push   $0x23
  800116:	68 a7 10 80 00       	push   $0x8010a7
  80011b:	e8 2f 02 00 00       	call   80034f <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 8a 10 80 00       	push   $0x80108a
  800195:	6a 23                	push   $0x23
  800197:	68 a7 10 80 00       	push   $0x8010a7
  80019c:	e8 ae 01 00 00       	call   80034f <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 8a 10 80 00       	push   $0x80108a
  8001d7:	6a 23                	push   $0x23
  8001d9:	68 a7 10 80 00       	push   $0x8010a7
  8001de:	e8 6c 01 00 00       	call   80034f <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 8a 10 80 00       	push   $0x80108a
  800219:	6a 23                	push   $0x23
  80021b:	68 a7 10 80 00       	push   $0x8010a7
  800220:	e8 2a 01 00 00       	call   80034f <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 8a 10 80 00       	push   $0x80108a
  80025b:	6a 23                	push   $0x23
  80025d:	68 a7 10 80 00       	push   $0x8010a7
  800262:	e8 e8 00 00 00       	call   80034f <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 8a 10 80 00       	push   $0x80108a
  80029d:	6a 23                	push   $0x23
  80029f:	68 a7 10 80 00       	push   $0x8010a7
  8002a4:	e8 a6 00 00 00       	call   80034f <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 8a 10 80 00       	push   $0x80108a
  8002df:	6a 23                	push   $0x23
  8002e1:	68 a7 10 80 00       	push   $0x8010a7
  8002e6:	e8 64 00 00 00       	call   80034f <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 8a 10 80 00       	push   $0x80108a
  800343:	6a 23                	push   $0x23
  800345:	68 a7 10 80 00       	push   $0x8010a7
  80034a:	e8 00 00 00 00       	call   80034f <_panic>

0080034f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	56                   	push   %esi
  800353:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800354:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800357:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80035d:	e8 be fd ff ff       	call   800120 <sys_getenvid>
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 0c             	push   0xc(%ebp)
  800368:	ff 75 08             	push   0x8(%ebp)
  80036b:	56                   	push   %esi
  80036c:	50                   	push   %eax
  80036d:	68 b8 10 80 00       	push   $0x8010b8
  800372:	e8 b3 00 00 00       	call   80042a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800377:	83 c4 18             	add    $0x18,%esp
  80037a:	53                   	push   %ebx
  80037b:	ff 75 10             	push   0x10(%ebp)
  80037e:	e8 56 00 00 00       	call   8003d9 <vcprintf>
	cprintf("\n");
  800383:	c7 04 24 db 10 80 00 	movl   $0x8010db,(%esp)
  80038a:	e8 9b 00 00 00       	call   80042a <cprintf>
  80038f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800392:	cc                   	int3   
  800393:	eb fd                	jmp    800392 <_panic+0x43>

00800395 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	53                   	push   %ebx
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039f:	8b 13                	mov    (%ebx),%edx
  8003a1:	8d 42 01             	lea    0x1(%edx),%eax
  8003a4:	89 03                	mov    %eax,(%ebx)
  8003a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b2:	74 09                	je     8003bd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	68 ff 00 00 00       	push   $0xff
  8003c5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c8:	50                   	push   %eax
  8003c9:	e8 d4 fc ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  8003ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb db                	jmp    8003b4 <putch+0x1f>

008003d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e9:	00 00 00 
	b.cnt = 0;
  8003ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f6:	ff 75 0c             	push   0xc(%ebp)
  8003f9:	ff 75 08             	push   0x8(%ebp)
  8003fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800402:	50                   	push   %eax
  800403:	68 95 03 80 00       	push   $0x800395
  800408:	e8 14 01 00 00       	call   800521 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040d:	83 c4 08             	add    $0x8,%esp
  800410:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800416:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041c:	50                   	push   %eax
  80041d:	e8 80 fc ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  800422:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800430:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800433:	50                   	push   %eax
  800434:	ff 75 08             	push   0x8(%ebp)
  800437:	e8 9d ff ff ff       	call   8003d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 1c             	sub    $0x1c,%esp
  800447:	89 c7                	mov    %eax,%edi
  800449:	89 d6                	mov    %edx,%esi
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800451:	89 d1                	mov    %edx,%ecx
  800453:	89 c2                	mov    %eax,%edx
  800455:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800458:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045b:	8b 45 10             	mov    0x10(%ebp),%eax
  80045e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800461:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800464:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046b:	39 c2                	cmp    %eax,%edx
  80046d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800470:	72 3e                	jb     8004b0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 18             	push   0x18(%ebp)
  800478:	83 eb 01             	sub    $0x1,%ebx
  80047b:	53                   	push   %ebx
  80047c:	50                   	push   %eax
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	ff 75 e4             	push   -0x1c(%ebp)
  800483:	ff 75 e0             	push   -0x20(%ebp)
  800486:	ff 75 dc             	push   -0x24(%ebp)
  800489:	ff 75 d8             	push   -0x28(%ebp)
  80048c:	e8 9f 09 00 00       	call   800e30 <__udivdi3>
  800491:	83 c4 18             	add    $0x18,%esp
  800494:	52                   	push   %edx
  800495:	50                   	push   %eax
  800496:	89 f2                	mov    %esi,%edx
  800498:	89 f8                	mov    %edi,%eax
  80049a:	e8 9f ff ff ff       	call   80043e <printnum>
  80049f:	83 c4 20             	add    $0x20,%esp
  8004a2:	eb 13                	jmp    8004b7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	56                   	push   %esi
  8004a8:	ff 75 18             	push   0x18(%ebp)
  8004ab:	ff d7                	call   *%edi
  8004ad:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b0:	83 eb 01             	sub    $0x1,%ebx
  8004b3:	85 db                	test   %ebx,%ebx
  8004b5:	7f ed                	jg     8004a4 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	56                   	push   %esi
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	ff 75 e4             	push   -0x1c(%ebp)
  8004c1:	ff 75 e0             	push   -0x20(%ebp)
  8004c4:	ff 75 dc             	push   -0x24(%ebp)
  8004c7:	ff 75 d8             	push   -0x28(%ebp)
  8004ca:	e8 81 0a 00 00       	call   800f50 <__umoddi3>
  8004cf:	83 c4 14             	add    $0x14,%esp
  8004d2:	0f be 80 dd 10 80 00 	movsbl 0x8010dd(%eax),%eax
  8004d9:	50                   	push   %eax
  8004da:	ff d7                	call   *%edi
}
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e2:	5b                   	pop    %ebx
  8004e3:	5e                   	pop    %esi
  8004e4:	5f                   	pop    %edi
  8004e5:	5d                   	pop    %ebp
  8004e6:	c3                   	ret    

008004e7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ed:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f1:	8b 10                	mov    (%eax),%edx
  8004f3:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f6:	73 0a                	jae    800502 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fb:	89 08                	mov    %ecx,(%eax)
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	88 02                	mov    %al,(%edx)
}
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <printfmt>:
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050d:	50                   	push   %eax
  80050e:	ff 75 10             	push   0x10(%ebp)
  800511:	ff 75 0c             	push   0xc(%ebp)
  800514:	ff 75 08             	push   0x8(%ebp)
  800517:	e8 05 00 00 00       	call   800521 <vprintfmt>
}
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <vprintfmt>:
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	57                   	push   %edi
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 3c             	sub    $0x3c,%esp
  80052a:	8b 75 08             	mov    0x8(%ebp),%esi
  80052d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800530:	8b 7d 10             	mov    0x10(%ebp),%edi
  800533:	eb 0a                	jmp    80053f <vprintfmt+0x1e>
			putch(ch, putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	50                   	push   %eax
  80053a:	ff d6                	call   *%esi
  80053c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053f:	83 c7 01             	add    $0x1,%edi
  800542:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800546:	83 f8 25             	cmp    $0x25,%eax
  800549:	74 0c                	je     800557 <vprintfmt+0x36>
			if (ch == '\0')
  80054b:	85 c0                	test   %eax,%eax
  80054d:	75 e6                	jne    800535 <vprintfmt+0x14>
}
  80054f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800552:	5b                   	pop    %ebx
  800553:	5e                   	pop    %esi
  800554:	5f                   	pop    %edi
  800555:	5d                   	pop    %ebp
  800556:	c3                   	ret    
		padc = ' ';
  800557:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80055b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800562:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800569:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800570:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8d 47 01             	lea    0x1(%edi),%eax
  800578:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80057b:	0f b6 17             	movzbl (%edi),%edx
  80057e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800581:	3c 55                	cmp    $0x55,%al
  800583:	0f 87 a6 04 00 00    	ja     800a2f <vprintfmt+0x50e>
  800589:	0f b6 c0             	movzbl %al,%eax
  80058c:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  800593:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800596:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80059a:	eb d9                	jmp    800575 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80059c:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80059f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005a3:	eb d0                	jmp    800575 <vprintfmt+0x54>
  8005a5:	0f b6 d2             	movzbl %dl,%edx
  8005a8:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c0:	83 f9 09             	cmp    $0x9,%ecx
  8005c3:	77 55                	ja     80061a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c8:	eb e9                	jmp    8005b3 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 40 04             	lea    0x4(%eax),%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005db:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005e2:	79 91                	jns    800575 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005f1:	eb 82                	jmp    800575 <vprintfmt+0x54>
  8005f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fd:	0f 49 c2             	cmovns %edx,%eax
  800600:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800603:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800606:	e9 6a ff ff ff       	jmp    800575 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80060b:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80060e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800615:	e9 5b ff ff ff       	jmp    800575 <vprintfmt+0x54>
  80061a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800620:	eb bc                	jmp    8005de <vprintfmt+0xbd>
			lflag++;
  800622:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800628:	e9 48 ff ff ff       	jmp    800575 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 78 04             	lea    0x4(%eax),%edi
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	ff 30                	push   (%eax)
  800639:	ff d6                	call   *%esi
			break;
  80063b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80063e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800641:	e9 88 03 00 00       	jmp    8009ce <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 78 04             	lea    0x4(%eax),%edi
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	89 d0                	mov    %edx,%eax
  800650:	f7 d8                	neg    %eax
  800652:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800655:	83 f8 0f             	cmp    $0xf,%eax
  800658:	7f 23                	jg     80067d <vprintfmt+0x15c>
  80065a:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800661:	85 d2                	test   %edx,%edx
  800663:	74 18                	je     80067d <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800665:	52                   	push   %edx
  800666:	68 fe 10 80 00       	push   $0x8010fe
  80066b:	53                   	push   %ebx
  80066c:	56                   	push   %esi
  80066d:	e8 92 fe ff ff       	call   800504 <printfmt>
  800672:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800675:	89 7d 14             	mov    %edi,0x14(%ebp)
  800678:	e9 51 03 00 00       	jmp    8009ce <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80067d:	50                   	push   %eax
  80067e:	68 f5 10 80 00       	push   $0x8010f5
  800683:	53                   	push   %ebx
  800684:	56                   	push   %esi
  800685:	e8 7a fe ff ff       	call   800504 <printfmt>
  80068a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80068d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800690:	e9 39 03 00 00       	jmp    8009ce <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 c0 04             	add    $0x4,%eax
  80069b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006a3:	85 d2                	test   %edx,%edx
  8006a5:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  8006aa:	0f 45 c2             	cmovne %edx,%eax
  8006ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b4:	7e 06                	jle    8006bc <vprintfmt+0x19b>
  8006b6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006ba:	75 0d                	jne    8006c9 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006bf:	89 c7                	mov    %eax,%edi
  8006c1:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006c7:	eb 55                	jmp    80071e <vprintfmt+0x1fd>
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 e0             	push   -0x20(%ebp)
  8006cf:	ff 75 cc             	push   -0x34(%ebp)
  8006d2:	e8 f5 03 00 00       	call   800acc <strnlen>
  8006d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006da:	29 c2                	sub    %eax,%edx
  8006dc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006e4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006eb:	eb 0f                	jmp    8006fc <vprintfmt+0x1db>
					putch(padc, putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	ff 75 d4             	push   -0x2c(%ebp)
  8006f4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f6:	83 ef 01             	sub    $0x1,%edi
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	85 ff                	test   %edi,%edi
  8006fe:	7f ed                	jg     8006ed <vprintfmt+0x1cc>
  800700:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800703:	85 d2                	test   %edx,%edx
  800705:	b8 00 00 00 00       	mov    $0x0,%eax
  80070a:	0f 49 c2             	cmovns %edx,%eax
  80070d:	29 c2                	sub    %eax,%edx
  80070f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800712:	eb a8                	jmp    8006bc <vprintfmt+0x19b>
					putch(ch, putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	52                   	push   %edx
  800719:	ff d6                	call   *%esi
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800721:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800723:	83 c7 01             	add    $0x1,%edi
  800726:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072a:	0f be d0             	movsbl %al,%edx
  80072d:	85 d2                	test   %edx,%edx
  80072f:	74 4b                	je     80077c <vprintfmt+0x25b>
  800731:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800735:	78 06                	js     80073d <vprintfmt+0x21c>
  800737:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80073b:	78 1e                	js     80075b <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80073d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800741:	74 d1                	je     800714 <vprintfmt+0x1f3>
  800743:	0f be c0             	movsbl %al,%eax
  800746:	83 e8 20             	sub    $0x20,%eax
  800749:	83 f8 5e             	cmp    $0x5e,%eax
  80074c:	76 c6                	jbe    800714 <vprintfmt+0x1f3>
					putch('?', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 3f                	push   $0x3f
  800754:	ff d6                	call   *%esi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	eb c3                	jmp    80071e <vprintfmt+0x1fd>
  80075b:	89 cf                	mov    %ecx,%edi
  80075d:	eb 0e                	jmp    80076d <vprintfmt+0x24c>
				putch(' ', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	53                   	push   %ebx
  800763:	6a 20                	push   $0x20
  800765:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800767:	83 ef 01             	sub    $0x1,%edi
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	85 ff                	test   %edi,%edi
  80076f:	7f ee                	jg     80075f <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800771:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	e9 52 02 00 00       	jmp    8009ce <vprintfmt+0x4ad>
  80077c:	89 cf                	mov    %ecx,%edi
  80077e:	eb ed                	jmp    80076d <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	83 c0 04             	add    $0x4,%eax
  800786:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80078e:	85 d2                	test   %edx,%edx
  800790:	b8 ee 10 80 00       	mov    $0x8010ee,%eax
  800795:	0f 45 c2             	cmovne %edx,%eax
  800798:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80079b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80079f:	7e 06                	jle    8007a7 <vprintfmt+0x286>
  8007a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8007a5:	75 0d                	jne    8007b4 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007aa:	89 c7                	mov    %eax,%edi
  8007ac:	03 45 d4             	add    -0x2c(%ebp),%eax
  8007af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007b2:	eb 55                	jmp    800809 <vprintfmt+0x2e8>
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 e0             	push   -0x20(%ebp)
  8007ba:	ff 75 cc             	push   -0x34(%ebp)
  8007bd:	e8 0a 03 00 00       	call   800acc <strnlen>
  8007c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007c5:	29 c2                	sub    %eax,%edx
  8007c7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007cf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d6:	eb 0f                	jmp    8007e7 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	53                   	push   %ebx
  8007dc:	ff 75 d4             	push   -0x2c(%ebp)
  8007df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e1:	83 ef 01             	sub    $0x1,%edi
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	85 ff                	test   %edi,%edi
  8007e9:	7f ed                	jg     8007d8 <vprintfmt+0x2b7>
  8007eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	0f 49 c2             	cmovns %edx,%eax
  8007f8:	29 c2                	sub    %eax,%edx
  8007fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007fd:	eb a8                	jmp    8007a7 <vprintfmt+0x286>
					putch(ch, putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	53                   	push   %ebx
  800803:	52                   	push   %edx
  800804:	ff d6                	call   *%esi
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80080c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  80080e:	83 c7 01             	add    $0x1,%edi
  800811:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800815:	0f be d0             	movsbl %al,%edx
  800818:	3c 3a                	cmp    $0x3a,%al
  80081a:	74 4b                	je     800867 <vprintfmt+0x346>
  80081c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800820:	78 06                	js     800828 <vprintfmt+0x307>
  800822:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800826:	78 1e                	js     800846 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800828:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80082c:	74 d1                	je     8007ff <vprintfmt+0x2de>
  80082e:	0f be c0             	movsbl %al,%eax
  800831:	83 e8 20             	sub    $0x20,%eax
  800834:	83 f8 5e             	cmp    $0x5e,%eax
  800837:	76 c6                	jbe    8007ff <vprintfmt+0x2de>
					putch('?', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	53                   	push   %ebx
  80083d:	6a 3f                	push   $0x3f
  80083f:	ff d6                	call   *%esi
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	eb c3                	jmp    800809 <vprintfmt+0x2e8>
  800846:	89 cf                	mov    %ecx,%edi
  800848:	eb 0e                	jmp    800858 <vprintfmt+0x337>
				putch(' ', putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	53                   	push   %ebx
  80084e:	6a 20                	push   $0x20
  800850:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800852:	83 ef 01             	sub    $0x1,%edi
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	85 ff                	test   %edi,%edi
  80085a:	7f ee                	jg     80084a <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80085c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	e9 67 01 00 00       	jmp    8009ce <vprintfmt+0x4ad>
  800867:	89 cf                	mov    %ecx,%edi
  800869:	eb ed                	jmp    800858 <vprintfmt+0x337>
	if (lflag >= 2)
  80086b:	83 f9 01             	cmp    $0x1,%ecx
  80086e:	7f 1b                	jg     80088b <vprintfmt+0x36a>
	else if (lflag)
  800870:	85 c9                	test   %ecx,%ecx
  800872:	74 63                	je     8008d7 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80087c:	99                   	cltd   
  80087d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
  800889:	eb 17                	jmp    8008a2 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	8b 50 04             	mov    0x4(%eax),%edx
  800891:	8b 00                	mov    (%eax),%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800896:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8d 40 08             	lea    0x8(%eax),%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  8008a8:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008ad:	85 c9                	test   %ecx,%ecx
  8008af:	0f 89 ff 00 00 00    	jns    8009b4 <vprintfmt+0x493>
				putch('-', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	6a 2d                	push   $0x2d
  8008bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008c3:	f7 da                	neg    %edx
  8008c5:	83 d1 00             	adc    $0x0,%ecx
  8008c8:	f7 d9                	neg    %ecx
  8008ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008cd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d2:	e9 dd 00 00 00       	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008df:	99                   	cltd   
  8008e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	8d 40 04             	lea    0x4(%eax),%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	eb b4                	jmp    8008a2 <vprintfmt+0x381>
	if (lflag >= 2)
  8008ee:	83 f9 01             	cmp    $0x1,%ecx
  8008f1:	7f 1e                	jg     800911 <vprintfmt+0x3f0>
	else if (lflag)
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	74 32                	je     800929 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8b 10                	mov    (%eax),%edx
  8008fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800901:	8d 40 04             	lea    0x4(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800907:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  80090c:	e9 a3 00 00 00       	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 10                	mov    (%eax),%edx
  800916:	8b 48 04             	mov    0x4(%eax),%ecx
  800919:	8d 40 08             	lea    0x8(%eax),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091f:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800924:	e9 8b 00 00 00       	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8b 10                	mov    (%eax),%edx
  80092e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800933:	8d 40 04             	lea    0x4(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800939:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80093e:	eb 74                	jmp    8009b4 <vprintfmt+0x493>
	if (lflag >= 2)
  800940:	83 f9 01             	cmp    $0x1,%ecx
  800943:	7f 1b                	jg     800960 <vprintfmt+0x43f>
	else if (lflag)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	74 2c                	je     800975 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8b 10                	mov    (%eax),%edx
  80094e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800953:	8d 40 04             	lea    0x4(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800959:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80095e:	eb 54                	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8b 10                	mov    (%eax),%edx
  800965:	8b 48 04             	mov    0x4(%eax),%ecx
  800968:	8d 40 08             	lea    0x8(%eax),%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096e:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800973:	eb 3f                	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8b 10                	mov    (%eax),%edx
  80097a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80097f:	8d 40 04             	lea    0x4(%eax),%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800985:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80098a:	eb 28                	jmp    8009b4 <vprintfmt+0x493>
			putch('0', putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	53                   	push   %ebx
  800990:	6a 30                	push   $0x30
  800992:	ff d6                	call   *%esi
			putch('x', putdat);
  800994:	83 c4 08             	add    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 78                	push   $0x78
  80099a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8b 10                	mov    (%eax),%edx
  8009a1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009a9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009af:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	ff 75 d4             	push   -0x2c(%ebp)
  8009bf:	57                   	push   %edi
  8009c0:	51                   	push   %ecx
  8009c1:	52                   	push   %edx
  8009c2:	89 da                	mov    %ebx,%edx
  8009c4:	89 f0                	mov    %esi,%eax
  8009c6:	e8 73 fa ff ff       	call   80043e <printnum>
			break;
  8009cb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009ce:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d1:	e9 69 fb ff ff       	jmp    80053f <vprintfmt+0x1e>
	if (lflag >= 2)
  8009d6:	83 f9 01             	cmp    $0x1,%ecx
  8009d9:	7f 1b                	jg     8009f6 <vprintfmt+0x4d5>
	else if (lflag)
  8009db:	85 c9                	test   %ecx,%ecx
  8009dd:	74 2c                	je     800a0b <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8b 10                	mov    (%eax),%edx
  8009e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ef:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009f4:	eb be                	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	8b 10                	mov    (%eax),%edx
  8009fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8009fe:	8d 40 08             	lea    0x8(%eax),%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a04:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800a09:	eb a9                	jmp    8009b4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8b 10                	mov    (%eax),%edx
  800a10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a15:	8d 40 04             	lea    0x4(%eax),%eax
  800a18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1b:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a20:	eb 92                	jmp    8009b4 <vprintfmt+0x493>
			putch(ch, putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	53                   	push   %ebx
  800a26:	6a 25                	push   $0x25
  800a28:	ff d6                	call   *%esi
			break;
  800a2a:	83 c4 10             	add    $0x10,%esp
  800a2d:	eb 9f                	jmp    8009ce <vprintfmt+0x4ad>
			putch('%', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	53                   	push   %ebx
  800a33:	6a 25                	push   $0x25
  800a35:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	89 f8                	mov    %edi,%eax
  800a3c:	eb 03                	jmp    800a41 <vprintfmt+0x520>
  800a3e:	83 e8 01             	sub    $0x1,%eax
  800a41:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a45:	75 f7                	jne    800a3e <vprintfmt+0x51d>
  800a47:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a4a:	eb 82                	jmp    8009ce <vprintfmt+0x4ad>

00800a4c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 18             	sub    $0x18,%esp
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a5f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a69:	85 c0                	test   %eax,%eax
  800a6b:	74 26                	je     800a93 <vsnprintf+0x47>
  800a6d:	85 d2                	test   %edx,%edx
  800a6f:	7e 22                	jle    800a93 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a71:	ff 75 14             	push   0x14(%ebp)
  800a74:	ff 75 10             	push   0x10(%ebp)
  800a77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a7a:	50                   	push   %eax
  800a7b:	68 e7 04 80 00       	push   $0x8004e7
  800a80:	e8 9c fa ff ff       	call   800521 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    
		return -E_INVAL;
  800a93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a98:	eb f7                	jmp    800a91 <vsnprintf+0x45>

00800a9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 10             	push   0x10(%ebp)
  800aa7:	ff 75 0c             	push   0xc(%ebp)
  800aaa:	ff 75 08             	push   0x8(%ebp)
  800aad:	e8 9a ff ff ff       	call   800a4c <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	eb 03                	jmp    800ac4 <strlen+0x10>
		n++;
  800ac1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ac4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ac8:	75 f7                	jne    800ac1 <strlen+0xd>
	return n;
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ada:	eb 03                	jmp    800adf <strnlen+0x13>
		n++;
  800adc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adf:	39 d0                	cmp    %edx,%eax
  800ae1:	74 08                	je     800aeb <strnlen+0x1f>
  800ae3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ae7:	75 f3                	jne    800adc <strnlen+0x10>
  800ae9:	89 c2                	mov    %eax,%edx
	return n;
}
  800aeb:	89 d0                	mov    %edx,%eax
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	53                   	push   %ebx
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800af9:	b8 00 00 00 00       	mov    $0x0,%eax
  800afe:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b02:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	75 f2                	jne    800afe <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b0c:	89 c8                	mov    %ecx,%eax
  800b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	53                   	push   %ebx
  800b17:	83 ec 10             	sub    $0x10,%esp
  800b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b1d:	53                   	push   %ebx
  800b1e:	e8 91 ff ff ff       	call   800ab4 <strlen>
  800b23:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b26:	ff 75 0c             	push   0xc(%ebp)
  800b29:	01 d8                	add    %ebx,%eax
  800b2b:	50                   	push   %eax
  800b2c:	e8 be ff ff ff       	call   800aef <strcpy>
	return dst;
}
  800b31:	89 d8                	mov    %ebx,%eax
  800b33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b43:	89 f3                	mov    %esi,%ebx
  800b45:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b48:	89 f0                	mov    %esi,%eax
  800b4a:	eb 0f                	jmp    800b5b <strncpy+0x23>
		*dst++ = *src;
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	0f b6 0a             	movzbl (%edx),%ecx
  800b52:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b55:	80 f9 01             	cmp    $0x1,%cl
  800b58:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b5b:	39 d8                	cmp    %ebx,%eax
  800b5d:	75 ed                	jne    800b4c <strncpy+0x14>
	}
	return ret;
}
  800b5f:	89 f0                	mov    %esi,%eax
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
  800b6a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b70:	8b 55 10             	mov    0x10(%ebp),%edx
  800b73:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b75:	85 d2                	test   %edx,%edx
  800b77:	74 21                	je     800b9a <strlcpy+0x35>
  800b79:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b7d:	89 f2                	mov    %esi,%edx
  800b7f:	eb 09                	jmp    800b8a <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b81:	83 c1 01             	add    $0x1,%ecx
  800b84:	83 c2 01             	add    $0x1,%edx
  800b87:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b8a:	39 c2                	cmp    %eax,%edx
  800b8c:	74 09                	je     800b97 <strlcpy+0x32>
  800b8e:	0f b6 19             	movzbl (%ecx),%ebx
  800b91:	84 db                	test   %bl,%bl
  800b93:	75 ec                	jne    800b81 <strlcpy+0x1c>
  800b95:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b97:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9a:	29 f0                	sub    %esi,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba9:	eb 06                	jmp    800bb1 <strcmp+0x11>
		p++, q++;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bb1:	0f b6 01             	movzbl (%ecx),%eax
  800bb4:	84 c0                	test   %al,%al
  800bb6:	74 04                	je     800bbc <strcmp+0x1c>
  800bb8:	3a 02                	cmp    (%edx),%al
  800bba:	74 ef                	je     800bab <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbc:	0f b6 c0             	movzbl %al,%eax
  800bbf:	0f b6 12             	movzbl (%edx),%edx
  800bc2:	29 d0                	sub    %edx,%eax
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	53                   	push   %ebx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 c3                	mov    %eax,%ebx
  800bd2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd5:	eb 06                	jmp    800bdd <strncmp+0x17>
		n--, p++, q++;
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bdd:	39 d8                	cmp    %ebx,%eax
  800bdf:	74 18                	je     800bf9 <strncmp+0x33>
  800be1:	0f b6 08             	movzbl (%eax),%ecx
  800be4:	84 c9                	test   %cl,%cl
  800be6:	74 04                	je     800bec <strncmp+0x26>
  800be8:	3a 0a                	cmp    (%edx),%cl
  800bea:	74 eb                	je     800bd7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bec:	0f b6 00             	movzbl (%eax),%eax
  800bef:	0f b6 12             	movzbl (%edx),%edx
  800bf2:	29 d0                	sub    %edx,%eax
}
  800bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    
		return 0;
  800bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfe:	eb f4                	jmp    800bf4 <strncmp+0x2e>

00800c00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c0a:	eb 03                	jmp    800c0f <strchr+0xf>
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	0f b6 10             	movzbl (%eax),%edx
  800c12:	84 d2                	test   %dl,%dl
  800c14:	74 06                	je     800c1c <strchr+0x1c>
		if (*s == c)
  800c16:	38 ca                	cmp    %cl,%dl
  800c18:	75 f2                	jne    800c0c <strchr+0xc>
  800c1a:	eb 05                	jmp    800c21 <strchr+0x21>
			return (char *) s;
	return 0;
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c2d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c30:	38 ca                	cmp    %cl,%dl
  800c32:	74 09                	je     800c3d <strfind+0x1a>
  800c34:	84 d2                	test   %dl,%dl
  800c36:	74 05                	je     800c3d <strfind+0x1a>
	for (; *s; s++)
  800c38:	83 c0 01             	add    $0x1,%eax
  800c3b:	eb f0                	jmp    800c2d <strfind+0xa>
			break;
	return (char *) s;
}
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c4b:	85 c9                	test   %ecx,%ecx
  800c4d:	74 2f                	je     800c7e <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4f:	89 f8                	mov    %edi,%eax
  800c51:	09 c8                	or     %ecx,%eax
  800c53:	a8 03                	test   $0x3,%al
  800c55:	75 21                	jne    800c78 <memset+0x39>
		c &= 0xFF;
  800c57:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	c1 e0 08             	shl    $0x8,%eax
  800c60:	89 d3                	mov    %edx,%ebx
  800c62:	c1 e3 18             	shl    $0x18,%ebx
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	c1 e6 10             	shl    $0x10,%esi
  800c6a:	09 f3                	or     %esi,%ebx
  800c6c:	09 da                	or     %ebx,%edx
  800c6e:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c70:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c73:	fc                   	cld    
  800c74:	f3 ab                	rep stos %eax,%es:(%edi)
  800c76:	eb 06                	jmp    800c7e <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	fc                   	cld    
  800c7c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7e:	89 f8                	mov    %edi,%eax
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c93:	39 c6                	cmp    %eax,%esi
  800c95:	73 32                	jae    800cc9 <memmove+0x44>
  800c97:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9a:	39 c2                	cmp    %eax,%edx
  800c9c:	76 2b                	jbe    800cc9 <memmove+0x44>
		s += n;
		d += n;
  800c9e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca1:	89 d6                	mov    %edx,%esi
  800ca3:	09 fe                	or     %edi,%esi
  800ca5:	09 ce                	or     %ecx,%esi
  800ca7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cad:	75 0e                	jne    800cbd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800caf:	83 ef 04             	sub    $0x4,%edi
  800cb2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb8:	fd                   	std    
  800cb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbb:	eb 09                	jmp    800cc6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbd:	83 ef 01             	sub    $0x1,%edi
  800cc0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc3:	fd                   	std    
  800cc4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc6:	fc                   	cld    
  800cc7:	eb 1a                	jmp    800ce3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc9:	89 f2                	mov    %esi,%edx
  800ccb:	09 c2                	or     %eax,%edx
  800ccd:	09 ca                	or     %ecx,%edx
  800ccf:	f6 c2 03             	test   $0x3,%dl
  800cd2:	75 0a                	jne    800cde <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	fc                   	cld    
  800cda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdc:	eb 05                	jmp    800ce3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cde:	89 c7                	mov    %eax,%edi
  800ce0:	fc                   	cld    
  800ce1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ced:	ff 75 10             	push   0x10(%ebp)
  800cf0:	ff 75 0c             	push   0xc(%ebp)
  800cf3:	ff 75 08             	push   0x8(%ebp)
  800cf6:	e8 8a ff ff ff       	call   800c85 <memmove>
}
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	89 c6                	mov    %eax,%esi
  800d0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0d:	eb 06                	jmp    800d15 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d0f:	83 c0 01             	add    $0x1,%eax
  800d12:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d15:	39 f0                	cmp    %esi,%eax
  800d17:	74 14                	je     800d2d <memcmp+0x30>
		if (*s1 != *s2)
  800d19:	0f b6 08             	movzbl (%eax),%ecx
  800d1c:	0f b6 1a             	movzbl (%edx),%ebx
  800d1f:	38 d9                	cmp    %bl,%cl
  800d21:	74 ec                	je     800d0f <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d23:	0f b6 c1             	movzbl %cl,%eax
  800d26:	0f b6 db             	movzbl %bl,%ebx
  800d29:	29 d8                	sub    %ebx,%eax
  800d2b:	eb 05                	jmp    800d32 <memcmp+0x35>
	}

	return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d3f:	89 c2                	mov    %eax,%edx
  800d41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d44:	eb 03                	jmp    800d49 <memfind+0x13>
  800d46:	83 c0 01             	add    $0x1,%eax
  800d49:	39 d0                	cmp    %edx,%eax
  800d4b:	73 04                	jae    800d51 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d4d:	38 08                	cmp    %cl,(%eax)
  800d4f:	75 f5                	jne    800d46 <memfind+0x10>
			break;
	return (void *) s;
}
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5f:	eb 03                	jmp    800d64 <strtol+0x11>
		s++;
  800d61:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d64:	0f b6 02             	movzbl (%edx),%eax
  800d67:	3c 20                	cmp    $0x20,%al
  800d69:	74 f6                	je     800d61 <strtol+0xe>
  800d6b:	3c 09                	cmp    $0x9,%al
  800d6d:	74 f2                	je     800d61 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d6f:	3c 2b                	cmp    $0x2b,%al
  800d71:	74 2a                	je     800d9d <strtol+0x4a>
	int neg = 0;
  800d73:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d78:	3c 2d                	cmp    $0x2d,%al
  800d7a:	74 2b                	je     800da7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d82:	75 0f                	jne    800d93 <strtol+0x40>
  800d84:	80 3a 30             	cmpb   $0x30,(%edx)
  800d87:	74 28                	je     800db1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d89:	85 db                	test   %ebx,%ebx
  800d8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d90:	0f 44 d8             	cmove  %eax,%ebx
  800d93:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9b:	eb 46                	jmp    800de3 <strtol+0x90>
		s++;
  800d9d:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800da0:	bf 00 00 00 00       	mov    $0x0,%edi
  800da5:	eb d5                	jmp    800d7c <strtol+0x29>
		s++, neg = 1;
  800da7:	83 c2 01             	add    $0x1,%edx
  800daa:	bf 01 00 00 00       	mov    $0x1,%edi
  800daf:	eb cb                	jmp    800d7c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db5:	74 0e                	je     800dc5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800db7:	85 db                	test   %ebx,%ebx
  800db9:	75 d8                	jne    800d93 <strtol+0x40>
		s++, base = 8;
  800dbb:	83 c2 01             	add    $0x1,%edx
  800dbe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc3:	eb ce                	jmp    800d93 <strtol+0x40>
		s += 2, base = 16;
  800dc5:	83 c2 02             	add    $0x2,%edx
  800dc8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dcd:	eb c4                	jmp    800d93 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dcf:	0f be c0             	movsbl %al,%eax
  800dd2:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dd5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd8:	7d 3a                	jge    800e14 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dda:	83 c2 01             	add    $0x1,%edx
  800ddd:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800de1:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800de3:	0f b6 02             	movzbl (%edx),%eax
  800de6:	8d 70 d0             	lea    -0x30(%eax),%esi
  800de9:	89 f3                	mov    %esi,%ebx
  800deb:	80 fb 09             	cmp    $0x9,%bl
  800dee:	76 df                	jbe    800dcf <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800df0:	8d 70 9f             	lea    -0x61(%eax),%esi
  800df3:	89 f3                	mov    %esi,%ebx
  800df5:	80 fb 19             	cmp    $0x19,%bl
  800df8:	77 08                	ja     800e02 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dfa:	0f be c0             	movsbl %al,%eax
  800dfd:	83 e8 57             	sub    $0x57,%eax
  800e00:	eb d3                	jmp    800dd5 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800e02:	8d 70 bf             	lea    -0x41(%eax),%esi
  800e05:	89 f3                	mov    %esi,%ebx
  800e07:	80 fb 19             	cmp    $0x19,%bl
  800e0a:	77 08                	ja     800e14 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e0c:	0f be c0             	movsbl %al,%eax
  800e0f:	83 e8 37             	sub    $0x37,%eax
  800e12:	eb c1                	jmp    800dd5 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 05                	je     800e1f <strtol+0xcc>
		*endptr = (char *) s;
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e1f:	89 c8                	mov    %ecx,%eax
  800e21:	f7 d8                	neg    %eax
  800e23:	85 ff                	test   %edi,%edi
  800e25:	0f 45 c8             	cmovne %eax,%ecx
}
  800e28:	89 c8                	mov    %ecx,%eax
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    
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
