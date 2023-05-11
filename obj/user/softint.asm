
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $13");	// GP, not page fault
  800033:	cd 0d                	int    $0xd
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800041:	e8 c6 00 00 00       	call   80010c <sys_getenvid>
  800046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80004e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800053:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800058:	85 db                	test   %ebx,%ebx
  80005a:	7e 07                	jle    800063 <libmain+0x2d>
		binaryname = argv[0];
  80005c:	8b 06                	mov    (%esi),%eax
  80005e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800063:	83 ec 08             	sub    $0x8,%esp
  800066:	56                   	push   %esi
  800067:	53                   	push   %ebx
  800068:	e8 c6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006d:	e8 0a 00 00 00       	call   80007c <exit>
}
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800078:	5b                   	pop    %ebx
  800079:	5e                   	pop    %esi
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800082:	6a 00                	push   $0x0
  800084:	e8 42 00 00 00       	call   8000cb <sys_env_destroy>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	c9                   	leave  
  80008d:	c3                   	ret    

0080008e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80008e:	55                   	push   %ebp
  80008f:	89 e5                	mov    %esp,%ebp
  800091:	57                   	push   %edi
  800092:	56                   	push   %esi
  800093:	53                   	push   %ebx
	asm volatile("int %1\n"
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	8b 55 08             	mov    0x8(%ebp),%edx
  80009c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80009f:	89 c3                	mov    %eax,%ebx
  8000a1:	89 c7                	mov    %eax,%edi
  8000a3:	89 c6                	mov    %eax,%esi
  8000a5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5f                   	pop    %edi
  8000aa:	5d                   	pop    %ebp
  8000ab:	c3                   	ret    

008000ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bc:	89 d1                	mov    %edx,%ecx
  8000be:	89 d3                	mov    %edx,%ebx
  8000c0:	89 d7                	mov    %edx,%edi
  8000c2:	89 d6                	mov    %edx,%esi
  8000c4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c6:	5b                   	pop    %ebx
  8000c7:	5e                   	pop    %esi
  8000c8:	5f                   	pop    %edi
  8000c9:	5d                   	pop    %ebp
  8000ca:	c3                   	ret    

008000cb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
  8000d1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e1:	89 cb                	mov    %ecx,%ebx
  8000e3:	89 cf                	mov    %ecx,%edi
  8000e5:	89 ce                	mov    %ecx,%esi
  8000e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	7f 08                	jg     8000f5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5e                   	pop    %esi
  8000f2:	5f                   	pop    %edi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	50                   	push   %eax
  8000f9:	6a 03                	push   $0x3
  8000fb:	68 6a 10 80 00       	push   $0x80106a
  800100:	6a 23                	push   $0x23
  800102:	68 87 10 80 00       	push   $0x801087
  800107:	e8 2f 02 00 00       	call   80033b <_panic>

0080010c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	57                   	push   %edi
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
	asm volatile("int %1\n"
  800112:	ba 00 00 00 00       	mov    $0x0,%edx
  800117:	b8 02 00 00 00       	mov    $0x2,%eax
  80011c:	89 d1                	mov    %edx,%ecx
  80011e:	89 d3                	mov    %edx,%ebx
  800120:	89 d7                	mov    %edx,%edi
  800122:	89 d6                	mov    %edx,%esi
  800124:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5f                   	pop    %edi
  800129:	5d                   	pop    %ebp
  80012a:	c3                   	ret    

0080012b <sys_yield>:

void
sys_yield(void)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	57                   	push   %edi
  80012f:	56                   	push   %esi
  800130:	53                   	push   %ebx
	asm volatile("int %1\n"
  800131:	ba 00 00 00 00       	mov    $0x0,%edx
  800136:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013b:	89 d1                	mov    %edx,%ecx
  80013d:	89 d3                	mov    %edx,%ebx
  80013f:	89 d7                	mov    %edx,%edi
  800141:	89 d6                	mov    %edx,%esi
  800143:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800153:	be 00 00 00 00       	mov    $0x0,%esi
  800158:	8b 55 08             	mov    0x8(%ebp),%edx
  80015b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015e:	b8 04 00 00 00       	mov    $0x4,%eax
  800163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800166:	89 f7                	mov    %esi,%edi
  800168:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016a:	85 c0                	test   %eax,%eax
  80016c:	7f 08                	jg     800176 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5f                   	pop    %edi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	6a 04                	push   $0x4
  80017c:	68 6a 10 80 00       	push   $0x80106a
  800181:	6a 23                	push   $0x23
  800183:	68 87 10 80 00       	push   $0x801087
  800188:	e8 ae 01 00 00       	call   80033b <_panic>

0080018d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	57                   	push   %edi
  800191:	56                   	push   %esi
  800192:	53                   	push   %ebx
  800193:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800196:	8b 55 08             	mov    0x8(%ebp),%edx
  800199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019c:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	7f 08                	jg     8001b8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	5f                   	pop    %edi
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	6a 05                	push   $0x5
  8001be:	68 6a 10 80 00       	push   $0x80106a
  8001c3:	6a 23                	push   $0x23
  8001c5:	68 87 10 80 00       	push   $0x801087
  8001ca:	e8 6c 01 00 00       	call   80033b <_panic>

008001cf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	57                   	push   %edi
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e8:	89 df                	mov    %ebx,%edi
  8001ea:	89 de                	mov    %ebx,%esi
  8001ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	7f 08                	jg     8001fa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f5:	5b                   	pop    %ebx
  8001f6:	5e                   	pop    %esi
  8001f7:	5f                   	pop    %edi
  8001f8:	5d                   	pop    %ebp
  8001f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	6a 06                	push   $0x6
  800200:	68 6a 10 80 00       	push   $0x80106a
  800205:	6a 23                	push   $0x23
  800207:	68 87 10 80 00       	push   $0x801087
  80020c:	e8 2a 01 00 00       	call   80033b <_panic>

00800211 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	57                   	push   %edi
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
  800217:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021f:	8b 55 08             	mov    0x8(%ebp),%edx
  800222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800225:	b8 08 00 00 00       	mov    $0x8,%eax
  80022a:	89 df                	mov    %ebx,%edi
  80022c:	89 de                	mov    %ebx,%esi
  80022e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800230:	85 c0                	test   %eax,%eax
  800232:	7f 08                	jg     80023c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800237:	5b                   	pop    %ebx
  800238:	5e                   	pop    %esi
  800239:	5f                   	pop    %edi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	50                   	push   %eax
  800240:	6a 08                	push   $0x8
  800242:	68 6a 10 80 00       	push   $0x80106a
  800247:	6a 23                	push   $0x23
  800249:	68 87 10 80 00       	push   $0x801087
  80024e:	e8 e8 00 00 00       	call   80033b <_panic>

00800253 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	57                   	push   %edi
  800257:	56                   	push   %esi
  800258:	53                   	push   %ebx
  800259:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800261:	8b 55 08             	mov    0x8(%ebp),%edx
  800264:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800267:	b8 09 00 00 00       	mov    $0x9,%eax
  80026c:	89 df                	mov    %ebx,%edi
  80026e:	89 de                	mov    %ebx,%esi
  800270:	cd 30                	int    $0x30
	if(check && ret > 0)
  800272:	85 c0                	test   %eax,%eax
  800274:	7f 08                	jg     80027e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	6a 09                	push   $0x9
  800284:	68 6a 10 80 00       	push   $0x80106a
  800289:	6a 23                	push   $0x23
  80028b:	68 87 10 80 00       	push   $0x801087
  800290:	e8 a6 00 00 00       	call   80033b <_panic>

00800295 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	57                   	push   %edi
  800299:	56                   	push   %esi
  80029a:	53                   	push   %ebx
  80029b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80029e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ae:	89 df                	mov    %ebx,%edi
  8002b0:	89 de                	mov    %ebx,%esi
  8002b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	7f 08                	jg     8002c0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	50                   	push   %eax
  8002c4:	6a 0a                	push   $0xa
  8002c6:	68 6a 10 80 00       	push   $0x80106a
  8002cb:	6a 23                	push   $0x23
  8002cd:	68 87 10 80 00       	push   $0x801087
  8002d2:	e8 64 00 00 00       	call   80033b <_panic>

008002d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f5:	5b                   	pop    %ebx
  8002f6:	5e                   	pop    %esi
  8002f7:	5f                   	pop    %edi
  8002f8:	5d                   	pop    %ebp
  8002f9:	c3                   	ret    

008002fa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800303:	b9 00 00 00 00       	mov    $0x0,%ecx
  800308:	8b 55 08             	mov    0x8(%ebp),%edx
  80030b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800310:	89 cb                	mov    %ecx,%ebx
  800312:	89 cf                	mov    %ecx,%edi
  800314:	89 ce                	mov    %ecx,%esi
  800316:	cd 30                	int    $0x30
	if(check && ret > 0)
  800318:	85 c0                	test   %eax,%eax
  80031a:	7f 08                	jg     800324 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80031c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031f:	5b                   	pop    %ebx
  800320:	5e                   	pop    %esi
  800321:	5f                   	pop    %edi
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	6a 0d                	push   $0xd
  80032a:	68 6a 10 80 00       	push   $0x80106a
  80032f:	6a 23                	push   $0x23
  800331:	68 87 10 80 00       	push   $0x801087
  800336:	e8 00 00 00 00       	call   80033b <_panic>

0080033b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	56                   	push   %esi
  80033f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800340:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800343:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800349:	e8 be fd ff ff       	call   80010c <sys_getenvid>
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	ff 75 0c             	push   0xc(%ebp)
  800354:	ff 75 08             	push   0x8(%ebp)
  800357:	56                   	push   %esi
  800358:	50                   	push   %eax
  800359:	68 98 10 80 00       	push   $0x801098
  80035e:	e8 b3 00 00 00       	call   800416 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800363:	83 c4 18             	add    $0x18,%esp
  800366:	53                   	push   %ebx
  800367:	ff 75 10             	push   0x10(%ebp)
  80036a:	e8 56 00 00 00       	call   8003c5 <vcprintf>
	cprintf("\n");
  80036f:	c7 04 24 bb 10 80 00 	movl   $0x8010bb,(%esp)
  800376:	e8 9b 00 00 00       	call   800416 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037e:	cc                   	int3   
  80037f:	eb fd                	jmp    80037e <_panic+0x43>

00800381 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	53                   	push   %ebx
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038b:	8b 13                	mov    (%ebx),%edx
  80038d:	8d 42 01             	lea    0x1(%edx),%eax
  800390:	89 03                	mov    %eax,(%ebx)
  800392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800395:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800399:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039e:	74 09                	je     8003a9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	68 ff 00 00 00       	push   $0xff
  8003b1:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b4:	50                   	push   %eax
  8003b5:	e8 d4 fc ff ff       	call   80008e <sys_cputs>
		b->idx = 0;
  8003ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	eb db                	jmp    8003a0 <putch+0x1f>

008003c5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d5:	00 00 00 
	b.cnt = 0;
  8003d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003df:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e2:	ff 75 0c             	push   0xc(%ebp)
  8003e5:	ff 75 08             	push   0x8(%ebp)
  8003e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	68 81 03 80 00       	push   $0x800381
  8003f4:	e8 14 01 00 00       	call   80050d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f9:	83 c4 08             	add    $0x8,%esp
  8003fc:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800402:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	e8 80 fc ff ff       	call   80008e <sys_cputs>

	return b.cnt;
}
  80040e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800414:	c9                   	leave  
  800415:	c3                   	ret    

00800416 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80041c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80041f:	50                   	push   %eax
  800420:	ff 75 08             	push   0x8(%ebp)
  800423:	e8 9d ff ff ff       	call   8003c5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
  800430:	83 ec 1c             	sub    $0x1c,%esp
  800433:	89 c7                	mov    %eax,%edi
  800435:	89 d6                	mov    %edx,%esi
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043d:	89 d1                	mov    %edx,%ecx
  80043f:	89 c2                	mov    %eax,%edx
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800447:	8b 45 10             	mov    0x10(%ebp),%eax
  80044a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80044d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800450:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800457:	39 c2                	cmp    %eax,%edx
  800459:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80045c:	72 3e                	jb     80049c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff 75 18             	push   0x18(%ebp)
  800464:	83 eb 01             	sub    $0x1,%ebx
  800467:	53                   	push   %ebx
  800468:	50                   	push   %eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	ff 75 e4             	push   -0x1c(%ebp)
  80046f:	ff 75 e0             	push   -0x20(%ebp)
  800472:	ff 75 dc             	push   -0x24(%ebp)
  800475:	ff 75 d8             	push   -0x28(%ebp)
  800478:	e8 a3 09 00 00       	call   800e20 <__udivdi3>
  80047d:	83 c4 18             	add    $0x18,%esp
  800480:	52                   	push   %edx
  800481:	50                   	push   %eax
  800482:	89 f2                	mov    %esi,%edx
  800484:	89 f8                	mov    %edi,%eax
  800486:	e8 9f ff ff ff       	call   80042a <printnum>
  80048b:	83 c4 20             	add    $0x20,%esp
  80048e:	eb 13                	jmp    8004a3 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	56                   	push   %esi
  800494:	ff 75 18             	push   0x18(%ebp)
  800497:	ff d7                	call   *%edi
  800499:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80049c:	83 eb 01             	sub    $0x1,%ebx
  80049f:	85 db                	test   %ebx,%ebx
  8004a1:	7f ed                	jg     800490 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	56                   	push   %esi
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	ff 75 e4             	push   -0x1c(%ebp)
  8004ad:	ff 75 e0             	push   -0x20(%ebp)
  8004b0:	ff 75 dc             	push   -0x24(%ebp)
  8004b3:	ff 75 d8             	push   -0x28(%ebp)
  8004b6:	e8 85 0a 00 00       	call   800f40 <__umoddi3>
  8004bb:	83 c4 14             	add    $0x14,%esp
  8004be:	0f be 80 bd 10 80 00 	movsbl 0x8010bd(%eax),%eax
  8004c5:	50                   	push   %eax
  8004c6:	ff d7                	call   *%edi
}
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ce:	5b                   	pop    %ebx
  8004cf:	5e                   	pop    %esi
  8004d0:	5f                   	pop    %edi
  8004d1:	5d                   	pop    %ebp
  8004d2:	c3                   	ret    

008004d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004dd:	8b 10                	mov    (%eax),%edx
  8004df:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e2:	73 0a                	jae    8004ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e7:	89 08                	mov    %ecx,(%eax)
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	88 02                	mov    %al,(%edx)
}
  8004ee:	5d                   	pop    %ebp
  8004ef:	c3                   	ret    

008004f0 <printfmt>:
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 10             	push   0x10(%ebp)
  8004fd:	ff 75 0c             	push   0xc(%ebp)
  800500:	ff 75 08             	push   0x8(%ebp)
  800503:	e8 05 00 00 00       	call   80050d <vprintfmt>
}
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <vprintfmt>:
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	57                   	push   %edi
  800511:	56                   	push   %esi
  800512:	53                   	push   %ebx
  800513:	83 ec 3c             	sub    $0x3c,%esp
  800516:	8b 75 08             	mov    0x8(%ebp),%esi
  800519:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80051f:	eb 0a                	jmp    80052b <vprintfmt+0x1e>
			putch(ch, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	53                   	push   %ebx
  800525:	50                   	push   %eax
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052b:	83 c7 01             	add    $0x1,%edi
  80052e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800532:	83 f8 25             	cmp    $0x25,%eax
  800535:	74 0c                	je     800543 <vprintfmt+0x36>
			if (ch == '\0')
  800537:	85 c0                	test   %eax,%eax
  800539:	75 e6                	jne    800521 <vprintfmt+0x14>
}
  80053b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053e:	5b                   	pop    %ebx
  80053f:	5e                   	pop    %esi
  800540:	5f                   	pop    %edi
  800541:	5d                   	pop    %ebp
  800542:	c3                   	ret    
		padc = ' ';
  800543:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800547:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80054e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800555:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8d 47 01             	lea    0x1(%edi),%eax
  800564:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800567:	0f b6 17             	movzbl (%edi),%edx
  80056a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056d:	3c 55                	cmp    $0x55,%al
  80056f:	0f 87 a6 04 00 00    	ja     800a1b <vprintfmt+0x50e>
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  80057f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800582:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800586:	eb d9                	jmp    800561 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80058b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80058f:	eb d0                	jmp    800561 <vprintfmt+0x54>
  800591:	0f b6 d2             	movzbl %dl,%edx
  800594:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80059f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ac:	83 f9 09             	cmp    $0x9,%ecx
  8005af:	77 55                	ja     800606 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005b1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b4:	eb e9                	jmp    80059f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8005ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ce:	79 91                	jns    800561 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005dd:	eb 82                	jmp    800561 <vprintfmt+0x54>
  8005df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e2:	85 d2                	test   %edx,%edx
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	0f 49 c2             	cmovns %edx,%eax
  8005ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ef:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8005f2:	e9 6a ff ff ff       	jmp    800561 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8005f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8005fa:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800601:	e9 5b ff ff ff       	jmp    800561 <vprintfmt+0x54>
  800606:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800609:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060c:	eb bc                	jmp    8005ca <vprintfmt+0xbd>
			lflag++;
  80060e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800611:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800614:	e9 48 ff ff ff       	jmp    800561 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 78 04             	lea    0x4(%eax),%edi
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	ff 30                	push   (%eax)
  800625:	ff d6                	call   *%esi
			break;
  800627:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062d:	e9 88 03 00 00       	jmp    8009ba <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 78 04             	lea    0x4(%eax),%edi
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	89 d0                	mov    %edx,%eax
  80063c:	f7 d8                	neg    %eax
  80063e:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800641:	83 f8 0f             	cmp    $0xf,%eax
  800644:	7f 23                	jg     800669 <vprintfmt+0x15c>
  800646:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  80064d:	85 d2                	test   %edx,%edx
  80064f:	74 18                	je     800669 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  800651:	52                   	push   %edx
  800652:	68 de 10 80 00       	push   $0x8010de
  800657:	53                   	push   %ebx
  800658:	56                   	push   %esi
  800659:	e8 92 fe ff ff       	call   8004f0 <printfmt>
  80065e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800661:	89 7d 14             	mov    %edi,0x14(%ebp)
  800664:	e9 51 03 00 00       	jmp    8009ba <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800669:	50                   	push   %eax
  80066a:	68 d5 10 80 00       	push   $0x8010d5
  80066f:	53                   	push   %ebx
  800670:	56                   	push   %esi
  800671:	e8 7a fe ff ff       	call   8004f0 <printfmt>
  800676:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800679:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067c:	e9 39 03 00 00       	jmp    8009ba <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	83 c0 04             	add    $0x4,%eax
  800687:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068f:	85 d2                	test   %edx,%edx
  800691:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  800696:	0f 45 c2             	cmovne %edx,%eax
  800699:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a0:	7e 06                	jle    8006a8 <vprintfmt+0x19b>
  8006a2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a6:	75 0d                	jne    8006b5 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ab:	89 c7                	mov    %eax,%edi
  8006ad:	03 45 d4             	add    -0x2c(%ebp),%eax
  8006b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006b3:	eb 55                	jmp    80070a <vprintfmt+0x1fd>
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 e0             	push   -0x20(%ebp)
  8006bb:	ff 75 cc             	push   -0x34(%ebp)
  8006be:	e8 f5 03 00 00       	call   800ab8 <strnlen>
  8006c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c6:	29 c2                	sub    %eax,%edx
  8006c8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d7:	eb 0f                	jmp    8006e8 <vprintfmt+0x1db>
					putch(padc, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	ff 75 d4             	push   -0x2c(%ebp)
  8006e0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e2:	83 ef 01             	sub    $0x1,%edi
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	85 ff                	test   %edi,%edi
  8006ea:	7f ed                	jg     8006d9 <vprintfmt+0x1cc>
  8006ec:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ef:	85 d2                	test   %edx,%edx
  8006f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f6:	0f 49 c2             	cmovns %edx,%eax
  8006f9:	29 c2                	sub    %eax,%edx
  8006fb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006fe:	eb a8                	jmp    8006a8 <vprintfmt+0x19b>
					putch(ch, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	52                   	push   %edx
  800705:	ff d6                	call   *%esi
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80070d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070f:	83 c7 01             	add    $0x1,%edi
  800712:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800716:	0f be d0             	movsbl %al,%edx
  800719:	85 d2                	test   %edx,%edx
  80071b:	74 4b                	je     800768 <vprintfmt+0x25b>
  80071d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800721:	78 06                	js     800729 <vprintfmt+0x21c>
  800723:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800727:	78 1e                	js     800747 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800729:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80072d:	74 d1                	je     800700 <vprintfmt+0x1f3>
  80072f:	0f be c0             	movsbl %al,%eax
  800732:	83 e8 20             	sub    $0x20,%eax
  800735:	83 f8 5e             	cmp    $0x5e,%eax
  800738:	76 c6                	jbe    800700 <vprintfmt+0x1f3>
					putch('?', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 3f                	push   $0x3f
  800740:	ff d6                	call   *%esi
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb c3                	jmp    80070a <vprintfmt+0x1fd>
  800747:	89 cf                	mov    %ecx,%edi
  800749:	eb 0e                	jmp    800759 <vprintfmt+0x24c>
				putch(' ', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 20                	push   $0x20
  800751:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800753:	83 ef 01             	sub    $0x1,%edi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	85 ff                	test   %edi,%edi
  80075b:	7f ee                	jg     80074b <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  80075d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
  800763:	e9 52 02 00 00       	jmp    8009ba <vprintfmt+0x4ad>
  800768:	89 cf                	mov    %ecx,%edi
  80076a:	eb ed                	jmp    800759 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80077a:	85 d2                	test   %edx,%edx
  80077c:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  800781:	0f 45 c2             	cmovne %edx,%eax
  800784:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800787:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078b:	7e 06                	jle    800793 <vprintfmt+0x286>
  80078d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800791:	75 0d                	jne    8007a0 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800793:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800796:	89 c7                	mov    %eax,%edi
  800798:	03 45 d4             	add    -0x2c(%ebp),%eax
  80079b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80079e:	eb 55                	jmp    8007f5 <vprintfmt+0x2e8>
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 e0             	push   -0x20(%ebp)
  8007a6:	ff 75 cc             	push   -0x34(%ebp)
  8007a9:	e8 0a 03 00 00       	call   800ab8 <strnlen>
  8007ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b1:	29 c2                	sub    %eax,%edx
  8007b3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007bb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c2:	eb 0f                	jmp    8007d3 <vprintfmt+0x2c6>
					putch(padc, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 d4             	push   -0x2c(%ebp)
  8007cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	83 ef 01             	sub    $0x1,%edi
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	85 ff                	test   %edi,%edi
  8007d5:	7f ed                	jg     8007c4 <vprintfmt+0x2b7>
  8007d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007da:	85 d2                	test   %edx,%edx
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	0f 49 c2             	cmovns %edx,%eax
  8007e4:	29 c2                	sub    %eax,%edx
  8007e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007e9:	eb a8                	jmp    800793 <vprintfmt+0x286>
					putch(ch, putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	53                   	push   %ebx
  8007ef:	52                   	push   %edx
  8007f0:	ff d6                	call   *%esi
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007f8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  8007fa:	83 c7 01             	add    $0x1,%edi
  8007fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800801:	0f be d0             	movsbl %al,%edx
  800804:	3c 3a                	cmp    $0x3a,%al
  800806:	74 4b                	je     800853 <vprintfmt+0x346>
  800808:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80080c:	78 06                	js     800814 <vprintfmt+0x307>
  80080e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800812:	78 1e                	js     800832 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800814:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800818:	74 d1                	je     8007eb <vprintfmt+0x2de>
  80081a:	0f be c0             	movsbl %al,%eax
  80081d:	83 e8 20             	sub    $0x20,%eax
  800820:	83 f8 5e             	cmp    $0x5e,%eax
  800823:	76 c6                	jbe    8007eb <vprintfmt+0x2de>
					putch('?', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	6a 3f                	push   $0x3f
  80082b:	ff d6                	call   *%esi
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	eb c3                	jmp    8007f5 <vprintfmt+0x2e8>
  800832:	89 cf                	mov    %ecx,%edi
  800834:	eb 0e                	jmp    800844 <vprintfmt+0x337>
				putch(' ', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 20                	push   $0x20
  80083c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80083e:	83 ef 01             	sub    $0x1,%edi
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 ff                	test   %edi,%edi
  800846:	7f ee                	jg     800836 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800848:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	e9 67 01 00 00       	jmp    8009ba <vprintfmt+0x4ad>
  800853:	89 cf                	mov    %ecx,%edi
  800855:	eb ed                	jmp    800844 <vprintfmt+0x337>
	if (lflag >= 2)
  800857:	83 f9 01             	cmp    $0x1,%ecx
  80085a:	7f 1b                	jg     800877 <vprintfmt+0x36a>
	else if (lflag)
  80085c:	85 c9                	test   %ecx,%ecx
  80085e:	74 63                	je     8008c3 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800868:	99                   	cltd   
  800869:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	eb 17                	jmp    80088e <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 50 04             	mov    0x4(%eax),%edx
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800882:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 08             	lea    0x8(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800891:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800894:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800899:	85 c9                	test   %ecx,%ecx
  80089b:	0f 89 ff 00 00 00    	jns    8009a0 <vprintfmt+0x493>
				putch('-', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	6a 2d                	push   $0x2d
  8008a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008af:	f7 da                	neg    %edx
  8008b1:	83 d1 00             	adc    $0x0,%ecx
  8008b4:	f7 d9                	neg    %ecx
  8008b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008be:	e9 dd 00 00 00       	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, int);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008cb:	99                   	cltd   
  8008cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 40 04             	lea    0x4(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	eb b4                	jmp    80088e <vprintfmt+0x381>
	if (lflag >= 2)
  8008da:	83 f9 01             	cmp    $0x1,%ecx
  8008dd:	7f 1e                	jg     8008fd <vprintfmt+0x3f0>
	else if (lflag)
  8008df:	85 c9                	test   %ecx,%ecx
  8008e1:	74 32                	je     800915 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	8b 10                	mov    (%eax),%edx
  8008e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ed:	8d 40 04             	lea    0x4(%eax),%eax
  8008f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f3:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  8008f8:	e9 a3 00 00 00       	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8b 10                	mov    (%eax),%edx
  800902:	8b 48 04             	mov    0x4(%eax),%ecx
  800905:	8d 40 08             	lea    0x8(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090b:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800910:	e9 8b 00 00 00       	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091f:	8d 40 04             	lea    0x4(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800925:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  80092a:	eb 74                	jmp    8009a0 <vprintfmt+0x493>
	if (lflag >= 2)
  80092c:	83 f9 01             	cmp    $0x1,%ecx
  80092f:	7f 1b                	jg     80094c <vprintfmt+0x43f>
	else if (lflag)
  800931:	85 c9                	test   %ecx,%ecx
  800933:	74 2c                	je     800961 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800945:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  80094a:	eb 54                	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 10                	mov    (%eax),%edx
  800951:	8b 48 04             	mov    0x4(%eax),%ecx
  800954:	8d 40 08             	lea    0x8(%eax),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095a:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  80095f:	eb 3f                	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8b 10                	mov    (%eax),%edx
  800966:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096b:	8d 40 04             	lea    0x4(%eax),%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800971:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800976:	eb 28                	jmp    8009a0 <vprintfmt+0x493>
			putch('0', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 30                	push   $0x30
  80097e:	ff d6                	call   *%esi
			putch('x', putdat);
  800980:	83 c4 08             	add    $0x8,%esp
  800983:	53                   	push   %ebx
  800984:	6a 78                	push   $0x78
  800986:	ff d6                	call   *%esi
			num = (unsigned long long)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8b 10                	mov    (%eax),%edx
  80098d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800992:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800995:	8d 40 04             	lea    0x4(%eax),%eax
  800998:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099b:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  8009a0:	83 ec 0c             	sub    $0xc,%esp
  8009a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a7:	50                   	push   %eax
  8009a8:	ff 75 d4             	push   -0x2c(%ebp)
  8009ab:	57                   	push   %edi
  8009ac:	51                   	push   %ecx
  8009ad:	52                   	push   %edx
  8009ae:	89 da                	mov    %ebx,%edx
  8009b0:	89 f0                	mov    %esi,%eax
  8009b2:	e8 73 fa ff ff       	call   80042a <printnum>
			break;
  8009b7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009ba:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bd:	e9 69 fb ff ff       	jmp    80052b <vprintfmt+0x1e>
	if (lflag >= 2)
  8009c2:	83 f9 01             	cmp    $0x1,%ecx
  8009c5:	7f 1b                	jg     8009e2 <vprintfmt+0x4d5>
	else if (lflag)
  8009c7:	85 c9                	test   %ecx,%ecx
  8009c9:	74 2c                	je     8009f7 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8b 10                	mov    (%eax),%edx
  8009d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d5:	8d 40 04             	lea    0x4(%eax),%eax
  8009d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009db:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  8009e0:	eb be                	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  8009e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e5:	8b 10                	mov    (%eax),%edx
  8009e7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ea:	8d 40 08             	lea    0x8(%eax),%eax
  8009ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f0:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  8009f5:	eb a9                	jmp    8009a0 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	8b 10                	mov    (%eax),%edx
  8009fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a01:	8d 40 04             	lea    0x4(%eax),%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a07:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800a0c:	eb 92                	jmp    8009a0 <vprintfmt+0x493>
			putch(ch, putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	53                   	push   %ebx
  800a12:	6a 25                	push   $0x25
  800a14:	ff d6                	call   *%esi
			break;
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	eb 9f                	jmp    8009ba <vprintfmt+0x4ad>
			putch('%', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	53                   	push   %ebx
  800a1f:	6a 25                	push   $0x25
  800a21:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	89 f8                	mov    %edi,%eax
  800a28:	eb 03                	jmp    800a2d <vprintfmt+0x520>
  800a2a:	83 e8 01             	sub    $0x1,%eax
  800a2d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a31:	75 f7                	jne    800a2a <vprintfmt+0x51d>
  800a33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a36:	eb 82                	jmp    8009ba <vprintfmt+0x4ad>

00800a38 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 18             	sub    $0x18,%esp
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a47:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a55:	85 c0                	test   %eax,%eax
  800a57:	74 26                	je     800a7f <vsnprintf+0x47>
  800a59:	85 d2                	test   %edx,%edx
  800a5b:	7e 22                	jle    800a7f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5d:	ff 75 14             	push   0x14(%ebp)
  800a60:	ff 75 10             	push   0x10(%ebp)
  800a63:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a66:	50                   	push   %eax
  800a67:	68 d3 04 80 00       	push   $0x8004d3
  800a6c:	e8 9c fa ff ff       	call   80050d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a74:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
}
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    
		return -E_INVAL;
  800a7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a84:	eb f7                	jmp    800a7d <vsnprintf+0x45>

00800a86 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a8f:	50                   	push   %eax
  800a90:	ff 75 10             	push   0x10(%ebp)
  800a93:	ff 75 0c             	push   0xc(%ebp)
  800a96:	ff 75 08             	push   0x8(%ebp)
  800a99:	e8 9a ff ff ff       	call   800a38 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	eb 03                	jmp    800ab0 <strlen+0x10>
		n++;
  800aad:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ab0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab4:	75 f7                	jne    800aad <strlen+0xd>
	return n;
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	eb 03                	jmp    800acb <strnlen+0x13>
		n++;
  800ac8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acb:	39 d0                	cmp    %edx,%eax
  800acd:	74 08                	je     800ad7 <strnlen+0x1f>
  800acf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ad3:	75 f3                	jne    800ac8 <strnlen+0x10>
  800ad5:	89 c2                	mov    %eax,%edx
	return n;
}
  800ad7:	89 d0                	mov    %edx,%eax
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800aee:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800af1:	83 c0 01             	add    $0x1,%eax
  800af4:	84 d2                	test   %dl,%dl
  800af6:	75 f2                	jne    800aea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af8:	89 c8                	mov    %ecx,%eax
  800afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	53                   	push   %ebx
  800b03:	83 ec 10             	sub    $0x10,%esp
  800b06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b09:	53                   	push   %ebx
  800b0a:	e8 91 ff ff ff       	call   800aa0 <strlen>
  800b0f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b12:	ff 75 0c             	push   0xc(%ebp)
  800b15:	01 d8                	add    %ebx,%eax
  800b17:	50                   	push   %eax
  800b18:	e8 be ff ff ff       	call   800adb <strcpy>
	return dst;
}
  800b1d:	89 d8                	mov    %ebx,%eax
  800b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 75 08             	mov    0x8(%ebp),%esi
  800b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2f:	89 f3                	mov    %esi,%ebx
  800b31:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b34:	89 f0                	mov    %esi,%eax
  800b36:	eb 0f                	jmp    800b47 <strncpy+0x23>
		*dst++ = *src;
  800b38:	83 c0 01             	add    $0x1,%eax
  800b3b:	0f b6 0a             	movzbl (%edx),%ecx
  800b3e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b41:	80 f9 01             	cmp    $0x1,%cl
  800b44:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800b47:	39 d8                	cmp    %ebx,%eax
  800b49:	75 ed                	jne    800b38 <strncpy+0x14>
	}
	return ret;
}
  800b4b:	89 f0                	mov    %esi,%eax
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 75 08             	mov    0x8(%ebp),%esi
  800b59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5c:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b61:	85 d2                	test   %edx,%edx
  800b63:	74 21                	je     800b86 <strlcpy+0x35>
  800b65:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b69:	89 f2                	mov    %esi,%edx
  800b6b:	eb 09                	jmp    800b76 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b6d:	83 c1 01             	add    $0x1,%ecx
  800b70:	83 c2 01             	add    $0x1,%edx
  800b73:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	74 09                	je     800b83 <strlcpy+0x32>
  800b7a:	0f b6 19             	movzbl (%ecx),%ebx
  800b7d:	84 db                	test   %bl,%bl
  800b7f:	75 ec                	jne    800b6d <strlcpy+0x1c>
  800b81:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b86:	29 f0                	sub    %esi,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b95:	eb 06                	jmp    800b9d <strcmp+0x11>
		p++, q++;
  800b97:	83 c1 01             	add    $0x1,%ecx
  800b9a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b9d:	0f b6 01             	movzbl (%ecx),%eax
  800ba0:	84 c0                	test   %al,%al
  800ba2:	74 04                	je     800ba8 <strcmp+0x1c>
  800ba4:	3a 02                	cmp    (%edx),%al
  800ba6:	74 ef                	je     800b97 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba8:	0f b6 c0             	movzbl %al,%eax
  800bab:	0f b6 12             	movzbl (%edx),%edx
  800bae:	29 d0                	sub    %edx,%eax
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	53                   	push   %ebx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 c3                	mov    %eax,%ebx
  800bbe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc1:	eb 06                	jmp    800bc9 <strncmp+0x17>
		n--, p++, q++;
  800bc3:	83 c0 01             	add    $0x1,%eax
  800bc6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc9:	39 d8                	cmp    %ebx,%eax
  800bcb:	74 18                	je     800be5 <strncmp+0x33>
  800bcd:	0f b6 08             	movzbl (%eax),%ecx
  800bd0:	84 c9                	test   %cl,%cl
  800bd2:	74 04                	je     800bd8 <strncmp+0x26>
  800bd4:	3a 0a                	cmp    (%edx),%cl
  800bd6:	74 eb                	je     800bc3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd8:	0f b6 00             	movzbl (%eax),%eax
  800bdb:	0f b6 12             	movzbl (%edx),%edx
  800bde:	29 d0                	sub    %edx,%eax
}
  800be0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    
		return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	eb f4                	jmp    800be0 <strncmp+0x2e>

00800bec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf6:	eb 03                	jmp    800bfb <strchr+0xf>
  800bf8:	83 c0 01             	add    $0x1,%eax
  800bfb:	0f b6 10             	movzbl (%eax),%edx
  800bfe:	84 d2                	test   %dl,%dl
  800c00:	74 06                	je     800c08 <strchr+0x1c>
		if (*s == c)
  800c02:	38 ca                	cmp    %cl,%dl
  800c04:	75 f2                	jne    800bf8 <strchr+0xc>
  800c06:	eb 05                	jmp    800c0d <strchr+0x21>
			return (char *) s;
	return 0;
  800c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c1c:	38 ca                	cmp    %cl,%dl
  800c1e:	74 09                	je     800c29 <strfind+0x1a>
  800c20:	84 d2                	test   %dl,%dl
  800c22:	74 05                	je     800c29 <strfind+0x1a>
	for (; *s; s++)
  800c24:	83 c0 01             	add    $0x1,%eax
  800c27:	eb f0                	jmp    800c19 <strfind+0xa>
			break;
	return (char *) s;
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c37:	85 c9                	test   %ecx,%ecx
  800c39:	74 2f                	je     800c6a <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c3b:	89 f8                	mov    %edi,%eax
  800c3d:	09 c8                	or     %ecx,%eax
  800c3f:	a8 03                	test   $0x3,%al
  800c41:	75 21                	jne    800c64 <memset+0x39>
		c &= 0xFF;
  800c43:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c47:	89 d0                	mov    %edx,%eax
  800c49:	c1 e0 08             	shl    $0x8,%eax
  800c4c:	89 d3                	mov    %edx,%ebx
  800c4e:	c1 e3 18             	shl    $0x18,%ebx
  800c51:	89 d6                	mov    %edx,%esi
  800c53:	c1 e6 10             	shl    $0x10,%esi
  800c56:	09 f3                	or     %esi,%ebx
  800c58:	09 da                	or     %ebx,%edx
  800c5a:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c5c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c5f:	fc                   	cld    
  800c60:	f3 ab                	rep stos %eax,%es:(%edi)
  800c62:	eb 06                	jmp    800c6a <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	fc                   	cld    
  800c68:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c6a:	89 f8                	mov    %edi,%eax
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7f:	39 c6                	cmp    %eax,%esi
  800c81:	73 32                	jae    800cb5 <memmove+0x44>
  800c83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c86:	39 c2                	cmp    %eax,%edx
  800c88:	76 2b                	jbe    800cb5 <memmove+0x44>
		s += n;
		d += n;
  800c8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8d:	89 d6                	mov    %edx,%esi
  800c8f:	09 fe                	or     %edi,%esi
  800c91:	09 ce                	or     %ecx,%esi
  800c93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c99:	75 0e                	jne    800ca9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c9b:	83 ef 04             	sub    $0x4,%edi
  800c9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca4:	fd                   	std    
  800ca5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca7:	eb 09                	jmp    800cb2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca9:	83 ef 01             	sub    $0x1,%edi
  800cac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800caf:	fd                   	std    
  800cb0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb2:	fc                   	cld    
  800cb3:	eb 1a                	jmp    800ccf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb5:	89 f2                	mov    %esi,%edx
  800cb7:	09 c2                	or     %eax,%edx
  800cb9:	09 ca                	or     %ecx,%edx
  800cbb:	f6 c2 03             	test   $0x3,%dl
  800cbe:	75 0a                	jne    800cca <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cc0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc3:	89 c7                	mov    %eax,%edi
  800cc5:	fc                   	cld    
  800cc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc8:	eb 05                	jmp    800ccf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cca:	89 c7                	mov    %eax,%edi
  800ccc:	fc                   	cld    
  800ccd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd9:	ff 75 10             	push   0x10(%ebp)
  800cdc:	ff 75 0c             	push   0xc(%ebp)
  800cdf:	ff 75 08             	push   0x8(%ebp)
  800ce2:	e8 8a ff ff ff       	call   800c71 <memmove>
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf4:	89 c6                	mov    %eax,%esi
  800cf6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf9:	eb 06                	jmp    800d01 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cfb:	83 c0 01             	add    $0x1,%eax
  800cfe:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800d01:	39 f0                	cmp    %esi,%eax
  800d03:	74 14                	je     800d19 <memcmp+0x30>
		if (*s1 != *s2)
  800d05:	0f b6 08             	movzbl (%eax),%ecx
  800d08:	0f b6 1a             	movzbl (%edx),%ebx
  800d0b:	38 d9                	cmp    %bl,%cl
  800d0d:	74 ec                	je     800cfb <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800d0f:	0f b6 c1             	movzbl %cl,%eax
  800d12:	0f b6 db             	movzbl %bl,%ebx
  800d15:	29 d8                	sub    %ebx,%eax
  800d17:	eb 05                	jmp    800d1e <memcmp+0x35>
	}

	return 0;
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2b:	89 c2                	mov    %eax,%edx
  800d2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d30:	eb 03                	jmp    800d35 <memfind+0x13>
  800d32:	83 c0 01             	add    $0x1,%eax
  800d35:	39 d0                	cmp    %edx,%eax
  800d37:	73 04                	jae    800d3d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	38 08                	cmp    %cl,(%eax)
  800d3b:	75 f5                	jne    800d32 <memfind+0x10>
			break;
	return (void *) s;
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4b:	eb 03                	jmp    800d50 <strtol+0x11>
		s++;
  800d4d:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d50:	0f b6 02             	movzbl (%edx),%eax
  800d53:	3c 20                	cmp    $0x20,%al
  800d55:	74 f6                	je     800d4d <strtol+0xe>
  800d57:	3c 09                	cmp    $0x9,%al
  800d59:	74 f2                	je     800d4d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d5b:	3c 2b                	cmp    $0x2b,%al
  800d5d:	74 2a                	je     800d89 <strtol+0x4a>
	int neg = 0;
  800d5f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d64:	3c 2d                	cmp    $0x2d,%al
  800d66:	74 2b                	je     800d93 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d68:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d6e:	75 0f                	jne    800d7f <strtol+0x40>
  800d70:	80 3a 30             	cmpb   $0x30,(%edx)
  800d73:	74 28                	je     800d9d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d75:	85 db                	test   %ebx,%ebx
  800d77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7c:	0f 44 d8             	cmove  %eax,%ebx
  800d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d84:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d87:	eb 46                	jmp    800dcf <strtol+0x90>
		s++;
  800d89:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800d91:	eb d5                	jmp    800d68 <strtol+0x29>
		s++, neg = 1;
  800d93:	83 c2 01             	add    $0x1,%edx
  800d96:	bf 01 00 00 00       	mov    $0x1,%edi
  800d9b:	eb cb                	jmp    800d68 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800da1:	74 0e                	je     800db1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	75 d8                	jne    800d7f <strtol+0x40>
		s++, base = 8;
  800da7:	83 c2 01             	add    $0x1,%edx
  800daa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800daf:	eb ce                	jmp    800d7f <strtol+0x40>
		s += 2, base = 16;
  800db1:	83 c2 02             	add    $0x2,%edx
  800db4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db9:	eb c4                	jmp    800d7f <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800dbb:	0f be c0             	movsbl %al,%eax
  800dbe:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc4:	7d 3a                	jge    800e00 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800dcd:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800dcf:	0f b6 02             	movzbl (%edx),%eax
  800dd2:	8d 70 d0             	lea    -0x30(%eax),%esi
  800dd5:	89 f3                	mov    %esi,%ebx
  800dd7:	80 fb 09             	cmp    $0x9,%bl
  800dda:	76 df                	jbe    800dbb <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800ddc:	8d 70 9f             	lea    -0x61(%eax),%esi
  800ddf:	89 f3                	mov    %esi,%ebx
  800de1:	80 fb 19             	cmp    $0x19,%bl
  800de4:	77 08                	ja     800dee <strtol+0xaf>
			dig = *s - 'a' + 10;
  800de6:	0f be c0             	movsbl %al,%eax
  800de9:	83 e8 57             	sub    $0x57,%eax
  800dec:	eb d3                	jmp    800dc1 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800dee:	8d 70 bf             	lea    -0x41(%eax),%esi
  800df1:	89 f3                	mov    %esi,%ebx
  800df3:	80 fb 19             	cmp    $0x19,%bl
  800df6:	77 08                	ja     800e00 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df8:	0f be c0             	movsbl %al,%eax
  800dfb:	83 e8 37             	sub    $0x37,%eax
  800dfe:	eb c1                	jmp    800dc1 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e04:	74 05                	je     800e0b <strtol+0xcc>
		*endptr = (char *) s;
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e0b:	89 c8                	mov    %ecx,%eax
  800e0d:	f7 d8                	neg    %eax
  800e0f:	85 ff                	test   %edi,%edi
  800e11:	0f 45 c8             	cmovne %eax,%ecx
}
  800e14:	89 c8                	mov    %ecx,%eax
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
  800e1b:	66 90                	xchg   %ax,%ax
  800e1d:	66 90                	xchg   %ax,%ax
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
