
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 c6 00 00 00       	call   800110 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800057:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005c:	85 db                	test   %ebx,%ebx
  80005e:	7e 07                	jle    800067 <libmain+0x2d>
		binaryname = argv[0];
  800060:	8b 06                	mov    (%esi),%eax
  800062:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	56                   	push   %esi
  80006b:	53                   	push   %ebx
  80006c:	e8 c2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800071:	e8 0a 00 00 00       	call   800080 <exit>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007c:	5b                   	pop    %ebx
  80007d:	5e                   	pop    %esi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800086:	6a 00                	push   $0x0
  800088:	e8 42 00 00 00       	call   8000cf <sys_env_destroy>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
	asm volatile("int %1\n"
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a3:	89 c3                	mov    %eax,%ebx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 c6                	mov    %eax,%esi
  8000a9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ab:	5b                   	pop    %ebx
  8000ac:	5e                   	pop    %esi
  8000ad:	5f                   	pop    %edi
  8000ae:	5d                   	pop    %ebp
  8000af:	c3                   	ret    

008000b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	89 d3                	mov    %edx,%ebx
  8000c4:	89 d7                	mov    %edx,%edi
  8000c6:	89 d6                	mov    %edx,%esi
  8000c8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e5:	89 cb                	mov    %ecx,%ebx
  8000e7:	89 cf                	mov    %ecx,%edi
  8000e9:	89 ce                	mov    %ecx,%esi
  8000eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000ed:	85 c0                	test   %eax,%eax
  8000ef:	7f 08                	jg     8000f9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f4:	5b                   	pop    %ebx
  8000f5:	5e                   	pop    %esi
  8000f6:	5f                   	pop    %edi
  8000f7:	5d                   	pop    %ebp
  8000f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f9:	83 ec 0c             	sub    $0xc,%esp
  8000fc:	50                   	push   %eax
  8000fd:	6a 03                	push   $0x3
  8000ff:	68 6a 10 80 00       	push   $0x80106a
  800104:	6a 23                	push   $0x23
  800106:	68 87 10 80 00       	push   $0x801087
  80010b:	e8 2f 02 00 00       	call   80033f <_panic>

00800110 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	57                   	push   %edi
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
	asm volatile("int %1\n"
  800116:	ba 00 00 00 00       	mov    $0x0,%edx
  80011b:	b8 02 00 00 00       	mov    $0x2,%eax
  800120:	89 d1                	mov    %edx,%ecx
  800122:	89 d3                	mov    %edx,%ebx
  800124:	89 d7                	mov    %edx,%edi
  800126:	89 d6                	mov    %edx,%esi
  800128:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <sys_yield>:

void
sys_yield(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
	asm volatile("int %1\n"
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	89 d3                	mov    %edx,%ebx
  800143:	89 d7                	mov    %edx,%edi
  800145:	89 d6                	mov    %edx,%esi
  800147:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
  800154:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800157:	be 00 00 00 00       	mov    $0x0,%esi
  80015c:	8b 55 08             	mov    0x8(%ebp),%edx
  80015f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800162:	b8 04 00 00 00       	mov    $0x4,%eax
  800167:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016a:	89 f7                	mov    %esi,%edi
  80016c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016e:	85 c0                	test   %eax,%eax
  800170:	7f 08                	jg     80017a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	50                   	push   %eax
  80017e:	6a 04                	push   $0x4
  800180:	68 6a 10 80 00       	push   $0x80106a
  800185:	6a 23                	push   $0x23
  800187:	68 87 10 80 00       	push   $0x801087
  80018c:	e8 ae 01 00 00       	call   80033f <_panic>

00800191 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	57                   	push   %edi
  800195:	56                   	push   %esi
  800196:	53                   	push   %ebx
  800197:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019a:	8b 55 08             	mov    0x8(%ebp),%edx
  80019d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b0:	85 c0                	test   %eax,%eax
  8001b2:	7f 08                	jg     8001bc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	50                   	push   %eax
  8001c0:	6a 05                	push   $0x5
  8001c2:	68 6a 10 80 00       	push   $0x80106a
  8001c7:	6a 23                	push   $0x23
  8001c9:	68 87 10 80 00       	push   $0x801087
  8001ce:	e8 6c 01 00 00       	call   80033f <_panic>

008001d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ec:	89 df                	mov    %ebx,%edi
  8001ee:	89 de                	mov    %ebx,%esi
  8001f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	7f 08                	jg     8001fe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f9:	5b                   	pop    %ebx
  8001fa:	5e                   	pop    %esi
  8001fb:	5f                   	pop    %edi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	50                   	push   %eax
  800202:	6a 06                	push   $0x6
  800204:	68 6a 10 80 00       	push   $0x80106a
  800209:	6a 23                	push   $0x23
  80020b:	68 87 10 80 00       	push   $0x801087
  800210:	e8 2a 01 00 00       	call   80033f <_panic>

00800215 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	57                   	push   %edi
  800219:	56                   	push   %esi
  80021a:	53                   	push   %ebx
  80021b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800223:	8b 55 08             	mov    0x8(%ebp),%edx
  800226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800229:	b8 08 00 00 00       	mov    $0x8,%eax
  80022e:	89 df                	mov    %ebx,%edi
  800230:	89 de                	mov    %ebx,%esi
  800232:	cd 30                	int    $0x30
	if(check && ret > 0)
  800234:	85 c0                	test   %eax,%eax
  800236:	7f 08                	jg     800240 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023b:	5b                   	pop    %ebx
  80023c:	5e                   	pop    %esi
  80023d:	5f                   	pop    %edi
  80023e:	5d                   	pop    %ebp
  80023f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	50                   	push   %eax
  800244:	6a 08                	push   $0x8
  800246:	68 6a 10 80 00       	push   $0x80106a
  80024b:	6a 23                	push   $0x23
  80024d:	68 87 10 80 00       	push   $0x801087
  800252:	e8 e8 00 00 00       	call   80033f <_panic>

00800257 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800260:	bb 00 00 00 00       	mov    $0x0,%ebx
  800265:	8b 55 08             	mov    0x8(%ebp),%edx
  800268:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026b:	b8 09 00 00 00       	mov    $0x9,%eax
  800270:	89 df                	mov    %ebx,%edi
  800272:	89 de                	mov    %ebx,%esi
  800274:	cd 30                	int    $0x30
	if(check && ret > 0)
  800276:	85 c0                	test   %eax,%eax
  800278:	7f 08                	jg     800282 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	50                   	push   %eax
  800286:	6a 09                	push   $0x9
  800288:	68 6a 10 80 00       	push   $0x80106a
  80028d:	6a 23                	push   $0x23
  80028f:	68 87 10 80 00       	push   $0x801087
  800294:	e8 a6 00 00 00       	call   80033f <_panic>

00800299 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b2:	89 df                	mov    %ebx,%edi
  8002b4:	89 de                	mov    %ebx,%esi
  8002b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b8:	85 c0                	test   %eax,%eax
  8002ba:	7f 08                	jg     8002c4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	6a 0a                	push   $0xa
  8002ca:	68 6a 10 80 00       	push   $0x80106a
  8002cf:	6a 23                	push   $0x23
  8002d1:	68 87 10 80 00       	push   $0x801087
  8002d6:	e8 64 00 00 00       	call   80033f <_panic>

008002db <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	57                   	push   %edi
  8002df:	56                   	push   %esi
  8002e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ec:	be 00 00 00 00       	mov    $0x0,%esi
  8002f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f9:	5b                   	pop    %ebx
  8002fa:	5e                   	pop    %esi
  8002fb:	5f                   	pop    %edi
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    

008002fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	57                   	push   %edi
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800307:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030c:	8b 55 08             	mov    0x8(%ebp),%edx
  80030f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800314:	89 cb                	mov    %ecx,%ebx
  800316:	89 cf                	mov    %ecx,%edi
  800318:	89 ce                	mov    %ecx,%esi
  80031a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80031c:	85 c0                	test   %eax,%eax
  80031e:	7f 08                	jg     800328 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	6a 0d                	push   $0xd
  80032e:	68 6a 10 80 00       	push   $0x80106a
  800333:	6a 23                	push   $0x23
  800335:	68 87 10 80 00       	push   $0x801087
  80033a:	e8 00 00 00 00       	call   80033f <_panic>

0080033f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800344:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800347:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80034d:	e8 be fd ff ff       	call   800110 <sys_getenvid>
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	ff 75 0c             	push   0xc(%ebp)
  800358:	ff 75 08             	push   0x8(%ebp)
  80035b:	56                   	push   %esi
  80035c:	50                   	push   %eax
  80035d:	68 98 10 80 00       	push   $0x801098
  800362:	e8 b3 00 00 00       	call   80041a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	53                   	push   %ebx
  80036b:	ff 75 10             	push   0x10(%ebp)
  80036e:	e8 56 00 00 00       	call   8003c9 <vcprintf>
	cprintf("\n");
  800373:	c7 04 24 bb 10 80 00 	movl   $0x8010bb,(%esp)
  80037a:	e8 9b 00 00 00       	call   80041a <cprintf>
  80037f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800382:	cc                   	int3   
  800383:	eb fd                	jmp    800382 <_panic+0x43>

00800385 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	53                   	push   %ebx
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038f:	8b 13                	mov    (%ebx),%edx
  800391:	8d 42 01             	lea    0x1(%edx),%eax
  800394:	89 03                	mov    %eax,(%ebx)
  800396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800399:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a2:	74 09                	je     8003ad <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	68 ff 00 00 00       	push   $0xff
  8003b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b8:	50                   	push   %eax
  8003b9:	e8 d4 fc ff ff       	call   800092 <sys_cputs>
		b->idx = 0;
  8003be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	eb db                	jmp    8003a4 <putch+0x1f>

008003c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d9:	00 00 00 
	b.cnt = 0;
  8003dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e6:	ff 75 0c             	push   0xc(%ebp)
  8003e9:	ff 75 08             	push   0x8(%ebp)
  8003ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	68 85 03 80 00       	push   $0x800385
  8003f8:	e8 14 01 00 00       	call   800511 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fd:	83 c4 08             	add    $0x8,%esp
  800400:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800406:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 80 fc ff ff       	call   800092 <sys_cputs>

	return b.cnt;
}
  800412:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800420:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800423:	50                   	push   %eax
  800424:	ff 75 08             	push   0x8(%ebp)
  800427:	e8 9d ff ff ff       	call   8003c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 1c             	sub    $0x1c,%esp
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 d6                	mov    %edx,%esi
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800441:	89 d1                	mov    %edx,%ecx
  800443:	89 c2                	mov    %eax,%edx
  800445:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800448:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80044b:	8b 45 10             	mov    0x10(%ebp),%eax
  80044e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800460:	72 3e                	jb     8004a0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 18             	push   0x18(%ebp)
  800468:	83 eb 01             	sub    $0x1,%ebx
  80046b:	53                   	push   %ebx
  80046c:	50                   	push   %eax
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 e4             	push   -0x1c(%ebp)
  800473:	ff 75 e0             	push   -0x20(%ebp)
  800476:	ff 75 dc             	push   -0x24(%ebp)
  800479:	ff 75 d8             	push   -0x28(%ebp)
  80047c:	e8 9f 09 00 00       	call   800e20 <__udivdi3>
  800481:	83 c4 18             	add    $0x18,%esp
  800484:	52                   	push   %edx
  800485:	50                   	push   %eax
  800486:	89 f2                	mov    %esi,%edx
  800488:	89 f8                	mov    %edi,%eax
  80048a:	e8 9f ff ff ff       	call   80042e <printnum>
  80048f:	83 c4 20             	add    $0x20,%esp
  800492:	eb 13                	jmp    8004a7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	56                   	push   %esi
  800498:	ff 75 18             	push   0x18(%ebp)
  80049b:	ff d7                	call   *%edi
  80049d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a0:	83 eb 01             	sub    $0x1,%ebx
  8004a3:	85 db                	test   %ebx,%ebx
  8004a5:	7f ed                	jg     800494 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	56                   	push   %esi
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	ff 75 e4             	push   -0x1c(%ebp)
  8004b1:	ff 75 e0             	push   -0x20(%ebp)
  8004b4:	ff 75 dc             	push   -0x24(%ebp)
  8004b7:	ff 75 d8             	push   -0x28(%ebp)
  8004ba:	e8 81 0a 00 00       	call   800f40 <__umoddi3>
  8004bf:	83 c4 14             	add    $0x14,%esp
  8004c2:	0f be 80 bd 10 80 00 	movsbl 0x8010bd(%eax),%eax
  8004c9:	50                   	push   %eax
  8004ca:	ff d7                	call   *%edi
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5f                   	pop    %edi
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004dd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e1:	8b 10                	mov    (%eax),%edx
  8004e3:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e6:	73 0a                	jae    8004f2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004eb:	89 08                	mov    %ecx,(%eax)
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	88 02                	mov    %al,(%edx)
}
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    

008004f4 <printfmt>:
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004fa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 10             	push   0x10(%ebp)
  800501:	ff 75 0c             	push   0xc(%ebp)
  800504:	ff 75 08             	push   0x8(%ebp)
  800507:	e8 05 00 00 00       	call   800511 <vprintfmt>
}
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <vprintfmt>:
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	57                   	push   %edi
  800515:	56                   	push   %esi
  800516:	53                   	push   %ebx
  800517:	83 ec 3c             	sub    $0x3c,%esp
  80051a:	8b 75 08             	mov    0x8(%ebp),%esi
  80051d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800520:	8b 7d 10             	mov    0x10(%ebp),%edi
  800523:	eb 0a                	jmp    80052f <vprintfmt+0x1e>
			putch(ch, putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	50                   	push   %eax
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052f:	83 c7 01             	add    $0x1,%edi
  800532:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800536:	83 f8 25             	cmp    $0x25,%eax
  800539:	74 0c                	je     800547 <vprintfmt+0x36>
			if (ch == '\0')
  80053b:	85 c0                	test   %eax,%eax
  80053d:	75 e6                	jne    800525 <vprintfmt+0x14>
}
  80053f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800542:	5b                   	pop    %ebx
  800543:	5e                   	pop    %esi
  800544:	5f                   	pop    %edi
  800545:	5d                   	pop    %ebp
  800546:	c3                   	ret    
		padc = ' ';
  800547:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800552:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800559:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8d 47 01             	lea    0x1(%edi),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80056b:	0f b6 17             	movzbl (%edi),%edx
  80056e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800571:	3c 55                	cmp    $0x55,%al
  800573:	0f 87 a6 04 00 00    	ja     800a1f <vprintfmt+0x50e>
  800579:	0f b6 c0             	movzbl %al,%eax
  80057c:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  800583:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800586:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80058a:	eb d9                	jmp    800565 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80058f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800593:	eb d0                	jmp    800565 <vprintfmt+0x54>
  800595:	0f b6 d2             	movzbl %dl,%edx
  800598:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059b:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ad:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b0:	83 f9 09             	cmp    $0x9,%ecx
  8005b3:	77 55                	ja     80060a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b8:	eb e9                	jmp    8005a3 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d2:	79 91                	jns    800565 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005e1:	eb 82                	jmp    800565 <vprintfmt+0x54>
  8005e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e6:	85 d2                	test   %edx,%edx
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	0f 49 c2             	cmovns %edx,%eax
  8005f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005f6:	e9 6a ff ff ff       	jmp    800565 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8005fe:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800605:	e9 5b ff ff ff       	jmp    800565 <vprintfmt+0x54>
  80060a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800610:	eb bc                	jmp    8005ce <vprintfmt+0xbd>
			lflag++;
  800612:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800618:	e9 48 ff ff ff       	jmp    800565 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 78 04             	lea    0x4(%eax),%edi
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	ff 30                	push   (%eax)
  800629:	ff d6                	call   *%esi
			break;
  80062b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800631:	e9 88 03 00 00       	jmp    8009be <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 78 04             	lea    0x4(%eax),%edi
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	89 d0                	mov    %edx,%eax
  800640:	f7 d8                	neg    %eax
  800642:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800645:	83 f8 0f             	cmp    $0xf,%eax
  800648:	7f 23                	jg     80066d <vprintfmt+0x15c>
  80064a:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  800651:	85 d2                	test   %edx,%edx
  800653:	74 18                	je     80066d <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800655:	52                   	push   %edx
  800656:	68 de 10 80 00       	push   $0x8010de
  80065b:	53                   	push   %ebx
  80065c:	56                   	push   %esi
  80065d:	e8 92 fe ff ff       	call   8004f4 <printfmt>
  800662:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800665:	89 7d 14             	mov    %edi,0x14(%ebp)
  800668:	e9 51 03 00 00       	jmp    8009be <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  80066d:	50                   	push   %eax
  80066e:	68 d5 10 80 00       	push   $0x8010d5
  800673:	53                   	push   %ebx
  800674:	56                   	push   %esi
  800675:	e8 7a fe ff ff       	call   8004f4 <printfmt>
  80067a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80067d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800680:	e9 39 03 00 00       	jmp    8009be <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	83 c0 04             	add    $0x4,%eax
  80068b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800693:	85 d2                	test   %edx,%edx
  800695:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  80069a:	0f 45 c2             	cmovne %edx,%eax
  80069d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a4:	7e 06                	jle    8006ac <vprintfmt+0x19b>
  8006a6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006aa:	75 0d                	jne    8006b9 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006af:	89 c7                	mov    %eax,%edi
  8006b1:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006b7:	eb 55                	jmp    80070e <vprintfmt+0x1fd>
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	ff 75 e0             	push   -0x20(%ebp)
  8006bf:	ff 75 cc             	push   -0x34(%ebp)
  8006c2:	e8 f5 03 00 00       	call   800abc <strnlen>
  8006c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ca:	29 c2                	sub    %eax,%edx
  8006cc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006db:	eb 0f                	jmp    8006ec <vprintfmt+0x1db>
					putch(padc, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	ff 75 d4             	push   -0x2c(%ebp)
  8006e4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	83 ef 01             	sub    $0x1,%edi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	85 ff                	test   %edi,%edi
  8006ee:	7f ed                	jg     8006dd <vprintfmt+0x1cc>
  8006f0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f3:	85 d2                	test   %edx,%edx
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	0f 49 c2             	cmovns %edx,%eax
  8006fd:	29 c2                	sub    %eax,%edx
  8006ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800702:	eb a8                	jmp    8006ac <vprintfmt+0x19b>
					putch(ch, putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	52                   	push   %edx
  800709:	ff d6                	call   *%esi
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800711:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800713:	83 c7 01             	add    $0x1,%edi
  800716:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071a:	0f be d0             	movsbl %al,%edx
  80071d:	85 d2                	test   %edx,%edx
  80071f:	74 4b                	je     80076c <vprintfmt+0x25b>
  800721:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800725:	78 06                	js     80072d <vprintfmt+0x21c>
  800727:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80072b:	78 1e                	js     80074b <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  80072d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800731:	74 d1                	je     800704 <vprintfmt+0x1f3>
  800733:	0f be c0             	movsbl %al,%eax
  800736:	83 e8 20             	sub    $0x20,%eax
  800739:	83 f8 5e             	cmp    $0x5e,%eax
  80073c:	76 c6                	jbe    800704 <vprintfmt+0x1f3>
					putch('?', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	6a 3f                	push   $0x3f
  800744:	ff d6                	call   *%esi
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	eb c3                	jmp    80070e <vprintfmt+0x1fd>
  80074b:	89 cf                	mov    %ecx,%edi
  80074d:	eb 0e                	jmp    80075d <vprintfmt+0x24c>
				putch(' ', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	6a 20                	push   $0x20
  800755:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800757:	83 ef 01             	sub    $0x1,%edi
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	85 ff                	test   %edi,%edi
  80075f:	7f ee                	jg     80074f <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800761:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	e9 52 02 00 00       	jmp    8009be <vprintfmt+0x4ad>
  80076c:	89 cf                	mov    %ecx,%edi
  80076e:	eb ed                	jmp    80075d <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80077e:	85 d2                	test   %edx,%edx
  800780:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  800785:	0f 45 c2             	cmovne %edx,%eax
  800788:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80078b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078f:	7e 06                	jle    800797 <vprintfmt+0x286>
  800791:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800795:	75 0d                	jne    8007a4 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800797:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80079a:	89 c7                	mov    %eax,%edi
  80079c:	03 45 d4             	add    -0x2c(%ebp),%eax
  80079f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8007a2:	eb 55                	jmp    8007f9 <vprintfmt+0x2e8>
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 e0             	push   -0x20(%ebp)
  8007aa:	ff 75 cc             	push   -0x34(%ebp)
  8007ad:	e8 0a 03 00 00       	call   800abc <strnlen>
  8007b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b5:	29 c2                	sub    %eax,%edx
  8007b7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007bf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c6:	eb 0f                	jmp    8007d7 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	ff 75 d4             	push   -0x2c(%ebp)
  8007cf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	83 ef 01             	sub    $0x1,%edi
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	85 ff                	test   %edi,%edi
  8007d9:	7f ed                	jg     8007c8 <vprintfmt+0x2b7>
  8007db:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	0f 49 c2             	cmovns %edx,%eax
  8007e8:	29 c2                	sub    %eax,%edx
  8007ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007ed:	eb a8                	jmp    800797 <vprintfmt+0x286>
					putch(ch, putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	52                   	push   %edx
  8007f4:	ff d6                	call   *%esi
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007fc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8007fe:	83 c7 01             	add    $0x1,%edi
  800801:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800805:	0f be d0             	movsbl %al,%edx
  800808:	3c 3a                	cmp    $0x3a,%al
  80080a:	74 4b                	je     800857 <vprintfmt+0x346>
  80080c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800810:	78 06                	js     800818 <vprintfmt+0x307>
  800812:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800816:	78 1e                	js     800836 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800818:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80081c:	74 d1                	je     8007ef <vprintfmt+0x2de>
  80081e:	0f be c0             	movsbl %al,%eax
  800821:	83 e8 20             	sub    $0x20,%eax
  800824:	83 f8 5e             	cmp    $0x5e,%eax
  800827:	76 c6                	jbe    8007ef <vprintfmt+0x2de>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	53                   	push   %ebx
  80082d:	6a 3f                	push   $0x3f
  80082f:	ff d6                	call   *%esi
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	eb c3                	jmp    8007f9 <vprintfmt+0x2e8>
  800836:	89 cf                	mov    %ecx,%edi
  800838:	eb 0e                	jmp    800848 <vprintfmt+0x337>
				putch(' ', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	53                   	push   %ebx
  80083e:	6a 20                	push   $0x20
  800840:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800842:	83 ef 01             	sub    $0x1,%edi
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	85 ff                	test   %edi,%edi
  80084a:	7f ee                	jg     80083a <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  80084c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
  800852:	e9 67 01 00 00       	jmp    8009be <vprintfmt+0x4ad>
  800857:	89 cf                	mov    %ecx,%edi
  800859:	eb ed                	jmp    800848 <vprintfmt+0x337>
	if (lflag >= 2)
  80085b:	83 f9 01             	cmp    $0x1,%ecx
  80085e:	7f 1b                	jg     80087b <vprintfmt+0x36a>
	else if (lflag)
  800860:	85 c9                	test   %ecx,%ecx
  800862:	74 63                	je     8008c7 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086c:	99                   	cltd   
  80086d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8d 40 04             	lea    0x4(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
  800879:	eb 17                	jmp    800892 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8b 50 04             	mov    0x4(%eax),%edx
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800886:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 08             	lea    0x8(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800892:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800895:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800898:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80089d:	85 c9                	test   %ecx,%ecx
  80089f:	0f 89 ff 00 00 00    	jns    8009a4 <vprintfmt+0x493>
				putch('-', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	6a 2d                	push   $0x2d
  8008ab:	ff d6                	call   *%esi
				num = -(long long) num;
  8008ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008b3:	f7 da                	neg    %edx
  8008b5:	83 d1 00             	adc    $0x0,%ecx
  8008b8:	f7 d9                	neg    %ecx
  8008ba:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008bd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008c2:	e9 dd 00 00 00       	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008cf:	99                   	cltd   
  8008d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8d 40 04             	lea    0x4(%eax),%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	eb b4                	jmp    800892 <vprintfmt+0x381>
	if (lflag >= 2)
  8008de:	83 f9 01             	cmp    $0x1,%ecx
  8008e1:	7f 1e                	jg     800901 <vprintfmt+0x3f0>
	else if (lflag)
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	74 32                	je     800919 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8b 10                	mov    (%eax),%edx
  8008ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f1:	8d 40 04             	lea    0x4(%eax),%eax
  8008f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f7:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8008fc:	e9 a3 00 00 00       	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	8b 10                	mov    (%eax),%edx
  800906:	8b 48 04             	mov    0x4(%eax),%ecx
  800909:	8d 40 08             	lea    0x8(%eax),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090f:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800914:	e9 8b 00 00 00       	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 10                	mov    (%eax),%edx
  80091e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800923:	8d 40 04             	lea    0x4(%eax),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800929:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80092e:	eb 74                	jmp    8009a4 <vprintfmt+0x493>
	if (lflag >= 2)
  800930:	83 f9 01             	cmp    $0x1,%ecx
  800933:	7f 1b                	jg     800950 <vprintfmt+0x43f>
	else if (lflag)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	74 2c                	je     800965 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800949:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80094e:	eb 54                	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 10                	mov    (%eax),%edx
  800955:	8b 48 04             	mov    0x4(%eax),%ecx
  800958:	8d 40 08             	lea    0x8(%eax),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095e:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800963:	eb 3f                	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8b 10                	mov    (%eax),%edx
  80096a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800975:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  80097a:	eb 28                	jmp    8009a4 <vprintfmt+0x493>
			putch('0', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	53                   	push   %ebx
  800980:	6a 30                	push   $0x30
  800982:	ff d6                	call   *%esi
			putch('x', putdat);
  800984:	83 c4 08             	add    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 78                	push   $0x78
  80098a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8b 10                	mov    (%eax),%edx
  800991:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800996:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800999:	8d 40 04             	lea    0x4(%eax),%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099f:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009a4:	83 ec 0c             	sub    $0xc,%esp
  8009a7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009ab:	50                   	push   %eax
  8009ac:	ff 75 d4             	push   -0x2c(%ebp)
  8009af:	57                   	push   %edi
  8009b0:	51                   	push   %ecx
  8009b1:	52                   	push   %edx
  8009b2:	89 da                	mov    %ebx,%edx
  8009b4:	89 f0                	mov    %esi,%eax
  8009b6:	e8 73 fa ff ff       	call   80042e <printnum>
			break;
  8009bb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009be:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c1:	e9 69 fb ff ff       	jmp    80052f <vprintfmt+0x1e>
	if (lflag >= 2)
  8009c6:	83 f9 01             	cmp    $0x1,%ecx
  8009c9:	7f 1b                	jg     8009e6 <vprintfmt+0x4d5>
	else if (lflag)
  8009cb:	85 c9                	test   %ecx,%ecx
  8009cd:	74 2c                	je     8009fb <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 10                	mov    (%eax),%edx
  8009d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d9:	8d 40 04             	lea    0x4(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009df:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009e4:	eb be                	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8b 10                	mov    (%eax),%edx
  8009eb:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ee:	8d 40 08             	lea    0x8(%eax),%eax
  8009f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f4:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009f9:	eb a9                	jmp    8009a4 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	8b 10                	mov    (%eax),%edx
  800a00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a05:	8d 40 04             	lea    0x4(%eax),%eax
  800a08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0b:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a10:	eb 92                	jmp    8009a4 <vprintfmt+0x493>
			putch(ch, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	53                   	push   %ebx
  800a16:	6a 25                	push   $0x25
  800a18:	ff d6                	call   *%esi
			break;
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	eb 9f                	jmp    8009be <vprintfmt+0x4ad>
			putch('%', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	53                   	push   %ebx
  800a23:	6a 25                	push   $0x25
  800a25:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 f8                	mov    %edi,%eax
  800a2c:	eb 03                	jmp    800a31 <vprintfmt+0x520>
  800a2e:	83 e8 01             	sub    $0x1,%eax
  800a31:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a35:	75 f7                	jne    800a2e <vprintfmt+0x51d>
  800a37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a3a:	eb 82                	jmp    8009be <vprintfmt+0x4ad>

00800a3c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 18             	sub    $0x18,%esp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a59:	85 c0                	test   %eax,%eax
  800a5b:	74 26                	je     800a83 <vsnprintf+0x47>
  800a5d:	85 d2                	test   %edx,%edx
  800a5f:	7e 22                	jle    800a83 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a61:	ff 75 14             	push   0x14(%ebp)
  800a64:	ff 75 10             	push   0x10(%ebp)
  800a67:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6a:	50                   	push   %eax
  800a6b:	68 d7 04 80 00       	push   $0x8004d7
  800a70:	e8 9c fa ff ff       	call   800511 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a78:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7e:	83 c4 10             	add    $0x10,%esp
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    
		return -E_INVAL;
  800a83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a88:	eb f7                	jmp    800a81 <vsnprintf+0x45>

00800a8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a90:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a93:	50                   	push   %eax
  800a94:	ff 75 10             	push   0x10(%ebp)
  800a97:	ff 75 0c             	push   0xc(%ebp)
  800a9a:	ff 75 08             	push   0x8(%ebp)
  800a9d:	e8 9a ff ff ff       	call   800a3c <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaf:	eb 03                	jmp    800ab4 <strlen+0x10>
		n++;
  800ab1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ab4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab8:	75 f7                	jne    800ab1 <strlen+0xd>
	return n;
}
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb 03                	jmp    800acf <strnlen+0x13>
		n++;
  800acc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acf:	39 d0                	cmp    %edx,%eax
  800ad1:	74 08                	je     800adb <strnlen+0x1f>
  800ad3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ad7:	75 f3                	jne    800acc <strnlen+0x10>
  800ad9:	89 c2                	mov    %eax,%edx
	return n;
}
  800adb:	89 d0                	mov    %edx,%eax
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	53                   	push   %ebx
  800ae3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aee:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800af2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	84 d2                	test   %dl,%dl
  800afa:	75 f2                	jne    800aee <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800afc:	89 c8                	mov    %ecx,%eax
  800afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	83 ec 10             	sub    $0x10,%esp
  800b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b0d:	53                   	push   %ebx
  800b0e:	e8 91 ff ff ff       	call   800aa4 <strlen>
  800b13:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b16:	ff 75 0c             	push   0xc(%ebp)
  800b19:	01 d8                	add    %ebx,%eax
  800b1b:	50                   	push   %eax
  800b1c:	e8 be ff ff ff       	call   800adf <strcpy>
	return dst;
}
  800b21:	89 d8                	mov    %ebx,%eax
  800b23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	89 f3                	mov    %esi,%ebx
  800b35:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b38:	89 f0                	mov    %esi,%eax
  800b3a:	eb 0f                	jmp    800b4b <strncpy+0x23>
		*dst++ = *src;
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	0f b6 0a             	movzbl (%edx),%ecx
  800b42:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b45:	80 f9 01             	cmp    $0x1,%cl
  800b48:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b4b:	39 d8                	cmp    %ebx,%eax
  800b4d:	75 ed                	jne    800b3c <strncpy+0x14>
	}
	return ret;
}
  800b4f:	89 f0                	mov    %esi,%eax
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	8b 55 10             	mov    0x10(%ebp),%edx
  800b63:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b65:	85 d2                	test   %edx,%edx
  800b67:	74 21                	je     800b8a <strlcpy+0x35>
  800b69:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b6d:	89 f2                	mov    %esi,%edx
  800b6f:	eb 09                	jmp    800b7a <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b71:	83 c1 01             	add    $0x1,%ecx
  800b74:	83 c2 01             	add    $0x1,%edx
  800b77:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 09                	je     800b87 <strlcpy+0x32>
  800b7e:	0f b6 19             	movzbl (%ecx),%ebx
  800b81:	84 db                	test   %bl,%bl
  800b83:	75 ec                	jne    800b71 <strlcpy+0x1c>
  800b85:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8a:	29 f0                	sub    %esi,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b99:	eb 06                	jmp    800ba1 <strcmp+0x11>
		p++, q++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
  800b9e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ba1:	0f b6 01             	movzbl (%ecx),%eax
  800ba4:	84 c0                	test   %al,%al
  800ba6:	74 04                	je     800bac <strcmp+0x1c>
  800ba8:	3a 02                	cmp    (%edx),%al
  800baa:	74 ef                	je     800b9b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bac:	0f b6 c0             	movzbl %al,%eax
  800baf:	0f b6 12             	movzbl (%edx),%edx
  800bb2:	29 d0                	sub    %edx,%eax
}
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	89 c3                	mov    %eax,%ebx
  800bc2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc5:	eb 06                	jmp    800bcd <strncmp+0x17>
		n--, p++, q++;
  800bc7:	83 c0 01             	add    $0x1,%eax
  800bca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bcd:	39 d8                	cmp    %ebx,%eax
  800bcf:	74 18                	je     800be9 <strncmp+0x33>
  800bd1:	0f b6 08             	movzbl (%eax),%ecx
  800bd4:	84 c9                	test   %cl,%cl
  800bd6:	74 04                	je     800bdc <strncmp+0x26>
  800bd8:	3a 0a                	cmp    (%edx),%cl
  800bda:	74 eb                	je     800bc7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bdc:	0f b6 00             	movzbl (%eax),%eax
  800bdf:	0f b6 12             	movzbl (%edx),%edx
  800be2:	29 d0                	sub    %edx,%eax
}
  800be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    
		return 0;
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	eb f4                	jmp    800be4 <strncmp+0x2e>

00800bf0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfa:	eb 03                	jmp    800bff <strchr+0xf>
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	0f b6 10             	movzbl (%eax),%edx
  800c02:	84 d2                	test   %dl,%dl
  800c04:	74 06                	je     800c0c <strchr+0x1c>
		if (*s == c)
  800c06:	38 ca                	cmp    %cl,%dl
  800c08:	75 f2                	jne    800bfc <strchr+0xc>
  800c0a:	eb 05                	jmp    800c11 <strchr+0x21>
			return (char *) s;
	return 0;
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c1d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c20:	38 ca                	cmp    %cl,%dl
  800c22:	74 09                	je     800c2d <strfind+0x1a>
  800c24:	84 d2                	test   %dl,%dl
  800c26:	74 05                	je     800c2d <strfind+0x1a>
	for (; *s; s++)
  800c28:	83 c0 01             	add    $0x1,%eax
  800c2b:	eb f0                	jmp    800c1d <strfind+0xa>
			break;
	return (char *) s;
}
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c3b:	85 c9                	test   %ecx,%ecx
  800c3d:	74 2f                	je     800c6e <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c3f:	89 f8                	mov    %edi,%eax
  800c41:	09 c8                	or     %ecx,%eax
  800c43:	a8 03                	test   $0x3,%al
  800c45:	75 21                	jne    800c68 <memset+0x39>
		c &= 0xFF;
  800c47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c4b:	89 d0                	mov    %edx,%eax
  800c4d:	c1 e0 08             	shl    $0x8,%eax
  800c50:	89 d3                	mov    %edx,%ebx
  800c52:	c1 e3 18             	shl    $0x18,%ebx
  800c55:	89 d6                	mov    %edx,%esi
  800c57:	c1 e6 10             	shl    $0x10,%esi
  800c5a:	09 f3                	or     %esi,%ebx
  800c5c:	09 da                	or     %ebx,%edx
  800c5e:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c63:	fc                   	cld    
  800c64:	f3 ab                	rep stos %eax,%es:(%edi)
  800c66:	eb 06                	jmp    800c6e <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	fc                   	cld    
  800c6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c6e:	89 f8                	mov    %edi,%eax
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c83:	39 c6                	cmp    %eax,%esi
  800c85:	73 32                	jae    800cb9 <memmove+0x44>
  800c87:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c8a:	39 c2                	cmp    %eax,%edx
  800c8c:	76 2b                	jbe    800cb9 <memmove+0x44>
		s += n;
		d += n;
  800c8e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c91:	89 d6                	mov    %edx,%esi
  800c93:	09 fe                	or     %edi,%esi
  800c95:	09 ce                	or     %ecx,%esi
  800c97:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c9d:	75 0e                	jne    800cad <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c9f:	83 ef 04             	sub    $0x4,%edi
  800ca2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca8:	fd                   	std    
  800ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cab:	eb 09                	jmp    800cb6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cad:	83 ef 01             	sub    $0x1,%edi
  800cb0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cb3:	fd                   	std    
  800cb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb6:	fc                   	cld    
  800cb7:	eb 1a                	jmp    800cd3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb9:	89 f2                	mov    %esi,%edx
  800cbb:	09 c2                	or     %eax,%edx
  800cbd:	09 ca                	or     %ecx,%edx
  800cbf:	f6 c2 03             	test   $0x3,%dl
  800cc2:	75 0a                	jne    800cce <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cc4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc7:	89 c7                	mov    %eax,%edi
  800cc9:	fc                   	cld    
  800cca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccc:	eb 05                	jmp    800cd3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cce:	89 c7                	mov    %eax,%edi
  800cd0:	fc                   	cld    
  800cd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cdd:	ff 75 10             	push   0x10(%ebp)
  800ce0:	ff 75 0c             	push   0xc(%ebp)
  800ce3:	ff 75 08             	push   0x8(%ebp)
  800ce6:	e8 8a ff ff ff       	call   800c75 <memmove>
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf8:	89 c6                	mov    %eax,%esi
  800cfa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cfd:	eb 06                	jmp    800d05 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cff:	83 c0 01             	add    $0x1,%eax
  800d02:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d05:	39 f0                	cmp    %esi,%eax
  800d07:	74 14                	je     800d1d <memcmp+0x30>
		if (*s1 != *s2)
  800d09:	0f b6 08             	movzbl (%eax),%ecx
  800d0c:	0f b6 1a             	movzbl (%edx),%ebx
  800d0f:	38 d9                	cmp    %bl,%cl
  800d11:	74 ec                	je     800cff <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d13:	0f b6 c1             	movzbl %cl,%eax
  800d16:	0f b6 db             	movzbl %bl,%ebx
  800d19:	29 d8                	sub    %ebx,%eax
  800d1b:	eb 05                	jmp    800d22 <memcmp+0x35>
	}

	return 0;
  800d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2f:	89 c2                	mov    %eax,%edx
  800d31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d34:	eb 03                	jmp    800d39 <memfind+0x13>
  800d36:	83 c0 01             	add    $0x1,%eax
  800d39:	39 d0                	cmp    %edx,%eax
  800d3b:	73 04                	jae    800d41 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d3d:	38 08                	cmp    %cl,(%eax)
  800d3f:	75 f5                	jne    800d36 <memfind+0x10>
			break;
	return (void *) s;
}
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4f:	eb 03                	jmp    800d54 <strtol+0x11>
		s++;
  800d51:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d54:	0f b6 02             	movzbl (%edx),%eax
  800d57:	3c 20                	cmp    $0x20,%al
  800d59:	74 f6                	je     800d51 <strtol+0xe>
  800d5b:	3c 09                	cmp    $0x9,%al
  800d5d:	74 f2                	je     800d51 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d5f:	3c 2b                	cmp    $0x2b,%al
  800d61:	74 2a                	je     800d8d <strtol+0x4a>
	int neg = 0;
  800d63:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	74 2b                	je     800d97 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d6c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d72:	75 0f                	jne    800d83 <strtol+0x40>
  800d74:	80 3a 30             	cmpb   $0x30,(%edx)
  800d77:	74 28                	je     800da1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d79:	85 db                	test   %ebx,%ebx
  800d7b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d80:	0f 44 d8             	cmove  %eax,%ebx
  800d83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d88:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d8b:	eb 46                	jmp    800dd3 <strtol+0x90>
		s++;
  800d8d:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d90:	bf 00 00 00 00       	mov    $0x0,%edi
  800d95:	eb d5                	jmp    800d6c <strtol+0x29>
		s++, neg = 1;
  800d97:	83 c2 01             	add    $0x1,%edx
  800d9a:	bf 01 00 00 00       	mov    $0x1,%edi
  800d9f:	eb cb                	jmp    800d6c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da1:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800da5:	74 0e                	je     800db5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da7:	85 db                	test   %ebx,%ebx
  800da9:	75 d8                	jne    800d83 <strtol+0x40>
		s++, base = 8;
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	bb 08 00 00 00       	mov    $0x8,%ebx
  800db3:	eb ce                	jmp    800d83 <strtol+0x40>
		s += 2, base = 16;
  800db5:	83 c2 02             	add    $0x2,%edx
  800db8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dbd:	eb c4                	jmp    800d83 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dbf:	0f be c0             	movsbl %al,%eax
  800dc2:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc8:	7d 3a                	jge    800e04 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dca:	83 c2 01             	add    $0x1,%edx
  800dcd:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dd1:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dd3:	0f b6 02             	movzbl (%edx),%eax
  800dd6:	8d 70 d0             	lea    -0x30(%eax),%esi
  800dd9:	89 f3                	mov    %esi,%ebx
  800ddb:	80 fb 09             	cmp    $0x9,%bl
  800dde:	76 df                	jbe    800dbf <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800de0:	8d 70 9f             	lea    -0x61(%eax),%esi
  800de3:	89 f3                	mov    %esi,%ebx
  800de5:	80 fb 19             	cmp    $0x19,%bl
  800de8:	77 08                	ja     800df2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 e8 57             	sub    $0x57,%eax
  800df0:	eb d3                	jmp    800dc5 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800df2:	8d 70 bf             	lea    -0x41(%eax),%esi
  800df5:	89 f3                	mov    %esi,%ebx
  800df7:	80 fb 19             	cmp    $0x19,%bl
  800dfa:	77 08                	ja     800e04 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dfc:	0f be c0             	movsbl %al,%eax
  800dff:	83 e8 37             	sub    $0x37,%eax
  800e02:	eb c1                	jmp    800dc5 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e08:	74 05                	je     800e0f <strtol+0xcc>
		*endptr = (char *) s;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e0f:	89 c8                	mov    %ecx,%eax
  800e11:	f7 d8                	neg    %eax
  800e13:	85 ff                	test   %edi,%edi
  800e15:	0f 45 c8             	cmovne %eax,%ecx
}
  800e18:	89 c8                	mov    %ecx,%eax
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    
  800e1f:	90                   	nop

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
