
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 b0 05 00 00       	call   8005e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	push   0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 d1 16 80 00       	push   $0x8016d1
  800049:	68 a0 16 80 00       	push   $0x8016a0
  80004e:	e8 c1 06 00 00       	call   800714 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	push   (%ebx)
  800055:	ff 36                	push   (%esi)
  800057:	68 b0 16 80 00       	push   $0x8016b0
  80005c:	68 b4 16 80 00       	push   $0x8016b4
  800061:	e8 ae 06 00 00       	call   800714 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c8 16 80 00       	push   $0x8016c8
  80007b:	e8 94 06 00 00       	call   800714 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	push   0x4(%ebx)
  80008b:	ff 76 04             	push   0x4(%esi)
  80008e:	68 d2 16 80 00       	push   $0x8016d2
  800093:	68 b4 16 80 00       	push   $0x8016b4
  800098:	e8 77 06 00 00       	call   800714 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 c8 16 80 00       	push   $0x8016c8
  8000b4:	e8 5b 06 00 00       	call   800714 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	push   0x8(%ebx)
  8000c4:	ff 76 08             	push   0x8(%esi)
  8000c7:	68 d6 16 80 00       	push   $0x8016d6
  8000cc:	68 b4 16 80 00       	push   $0x8016b4
  8000d1:	e8 3e 06 00 00       	call   800714 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 c8 16 80 00       	push   $0x8016c8
  8000ed:	e8 22 06 00 00       	call   800714 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	push   0x10(%ebx)
  8000fd:	ff 76 10             	push   0x10(%esi)
  800100:	68 da 16 80 00       	push   $0x8016da
  800105:	68 b4 16 80 00       	push   $0x8016b4
  80010a:	e8 05 06 00 00       	call   800714 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 c8 16 80 00       	push   $0x8016c8
  800126:	e8 e9 05 00 00       	call   800714 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	push   0x14(%ebx)
  800136:	ff 76 14             	push   0x14(%esi)
  800139:	68 de 16 80 00       	push   $0x8016de
  80013e:	68 b4 16 80 00       	push   $0x8016b4
  800143:	e8 cc 05 00 00       	call   800714 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 c8 16 80 00       	push   $0x8016c8
  80015f:	e8 b0 05 00 00       	call   800714 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	push   0x18(%ebx)
  80016f:	ff 76 18             	push   0x18(%esi)
  800172:	68 e2 16 80 00       	push   $0x8016e2
  800177:	68 b4 16 80 00       	push   $0x8016b4
  80017c:	e8 93 05 00 00       	call   800714 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 c8 16 80 00       	push   $0x8016c8
  800198:	e8 77 05 00 00       	call   800714 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	push   0x1c(%ebx)
  8001a8:	ff 76 1c             	push   0x1c(%esi)
  8001ab:	68 e6 16 80 00       	push   $0x8016e6
  8001b0:	68 b4 16 80 00       	push   $0x8016b4
  8001b5:	e8 5a 05 00 00       	call   800714 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 c8 16 80 00       	push   $0x8016c8
  8001d1:	e8 3e 05 00 00       	call   800714 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	push   0x20(%ebx)
  8001e1:	ff 76 20             	push   0x20(%esi)
  8001e4:	68 ea 16 80 00       	push   $0x8016ea
  8001e9:	68 b4 16 80 00       	push   $0x8016b4
  8001ee:	e8 21 05 00 00       	call   800714 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 c8 16 80 00       	push   $0x8016c8
  80020a:	e8 05 05 00 00       	call   800714 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	push   0x24(%ebx)
  80021a:	ff 76 24             	push   0x24(%esi)
  80021d:	68 ee 16 80 00       	push   $0x8016ee
  800222:	68 b4 16 80 00       	push   $0x8016b4
  800227:	e8 e8 04 00 00       	call   800714 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 c8 16 80 00       	push   $0x8016c8
  800243:	e8 cc 04 00 00       	call   800714 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	push   0x28(%ebx)
  80024b:	ff 76 28             	push   0x28(%esi)
  80024e:	68 f5 16 80 00       	push   $0x8016f5
  800253:	68 b4 16 80 00       	push   $0x8016b4
  800258:	e8 b7 04 00 00       	call   800714 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 c8 16 80 00       	push   $0x8016c8
  800274:	e8 9b 04 00 00       	call   800714 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	push   0xc(%ebp)
  80027f:	68 f9 16 80 00       	push   $0x8016f9
  800284:	e8 8b 04 00 00       	call   800714 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 c8 16 80 00       	push   $0x8016c8
  800294:	e8 7b 04 00 00       	call   800714 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 c4 16 80 00       	push   $0x8016c4
  8002a9:	e8 66 04 00 00       	call   800714 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 c4 16 80 00       	push   $0x8016c4
  8002c3:	e8 4c 04 00 00       	call   800714 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 c4 16 80 00       	push   $0x8016c4
  8002d8:	e8 37 04 00 00       	call   800714 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 c4 16 80 00       	push   $0x8016c4
  8002ed:	e8 22 04 00 00       	call   800714 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 c4 16 80 00       	push   $0x8016c4
  800302:	e8 0d 04 00 00       	call   800714 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 c4 16 80 00       	push   $0x8016c4
  800317:	e8 f8 03 00 00       	call   800714 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 c4 16 80 00       	push   $0x8016c4
  80032c:	e8 e3 03 00 00       	call   800714 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 c4 16 80 00       	push   $0x8016c4
  800341:	e8 ce 03 00 00       	call   800714 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 c4 16 80 00       	push   $0x8016c4
  800356:	e8 b9 03 00 00       	call   800714 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	push   0x28(%ebx)
  80035e:	ff 76 28             	push   0x28(%esi)
  800361:	68 f5 16 80 00       	push   $0x8016f5
  800366:	68 b4 16 80 00       	push   $0x8016b4
  80036b:	e8 a4 03 00 00       	call   800714 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 c4 16 80 00       	push   $0x8016c4
  800387:	e8 88 03 00 00       	call   800714 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	push   0xc(%ebp)
  800392:	68 f9 16 80 00       	push   $0x8016f9
  800397:	e8 78 03 00 00       	call   800714 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 c4 16 80 00       	push   $0x8016c4
  8003af:	e8 60 03 00 00       	call   800714 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 c4 16 80 00       	push   $0x8016c4
  8003c7:	e8 48 03 00 00       	call   800714 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	push   0xc(%ebp)
  8003d2:	68 f9 16 80 00       	push   $0x8016f9
  8003d7:	e8 38 03 00 00       	call   800714 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 60 20 80 00    	mov    %edx,0x802060
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 64 20 80 00    	mov    %edx,0x802064
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 68 20 80 00    	mov    %edx,0x802068
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 70 20 80 00    	mov    %edx,0x802070
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 74 20 80 00    	mov    %edx,0x802074
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 78 20 80 00    	mov    %edx,0x802078
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 1f 17 80 00       	push   $0x80171f
  80046b:	68 2d 17 80 00       	push   $0x80172d
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba 18 17 80 00       	mov    $0x801718,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 40 0d 00 00       	call   8011d5 <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	push   0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 60 17 80 00       	push   $0x801760
  8004aa:	6a 50                	push   $0x50
  8004ac:	68 07 17 80 00       	push   $0x801707
  8004b1:	e8 83 01 00 00       	call   800639 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 34 17 80 00       	push   $0x801734
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 07 17 80 00       	push   $0x801707
  8004c3:	e8 71 01 00 00       	call   800639 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 ee 0e 00 00       	call   8013c6 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004f9:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004ff:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  800505:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  80050b:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800511:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  800517:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  80051c:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 20 20 80 00    	mov    %edi,0x802020
  800532:	89 35 24 20 80 00    	mov    %esi,0x802024
  800538:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  80053e:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800544:	89 15 34 20 80 00    	mov    %edx,0x802034
  80054a:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800550:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800555:	89 25 48 20 80 00    	mov    %esp,0x802048
  80055b:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800561:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  800567:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  80056d:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800573:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  800579:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  80057f:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800584:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 44 20 80 00       	mov    %eax,0x802044
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	75 30                	jne    8005cf <umain+0x107>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  80059f:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005a4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 47 17 80 00       	push   $0x801747
  8005b1:	68 58 17 80 00       	push   $0x801758
  8005b6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005bb:	ba 18 17 80 00       	mov    $0x801718,%edx
  8005c0:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 94 17 80 00       	push   $0x801794
  8005d7:	e8 38 01 00 00       	call   800714 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ec:	e8 a6 0b 00 00       	call   801197 <sys_getenvid>
  8005f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fe:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800603:	85 db                	test   %ebx,%ebx
  800605:	7e 07                	jle    80060e <libmain+0x2d>
		binaryname = argv[0];
  800607:	8b 06                	mov    (%esi),%eax
  800609:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	56                   	push   %esi
  800612:	53                   	push   %ebx
  800613:	e8 b0 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800618:	e8 0a 00 00 00       	call   800627 <exit>
}
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800623:	5b                   	pop    %ebx
  800624:	5e                   	pop    %esi
  800625:	5d                   	pop    %ebp
  800626:	c3                   	ret    

00800627 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80062d:	6a 00                	push   $0x0
  80062f:	e8 22 0b 00 00       	call   801156 <sys_env_destroy>
}
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
  80063c:	56                   	push   %esi
  80063d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80063e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800641:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800647:	e8 4b 0b 00 00       	call   801197 <sys_getenvid>
  80064c:	83 ec 0c             	sub    $0xc,%esp
  80064f:	ff 75 0c             	push   0xc(%ebp)
  800652:	ff 75 08             	push   0x8(%ebp)
  800655:	56                   	push   %esi
  800656:	50                   	push   %eax
  800657:	68 c0 17 80 00       	push   $0x8017c0
  80065c:	e8 b3 00 00 00       	call   800714 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800661:	83 c4 18             	add    $0x18,%esp
  800664:	53                   	push   %ebx
  800665:	ff 75 10             	push   0x10(%ebp)
  800668:	e8 56 00 00 00       	call   8006c3 <vcprintf>
	cprintf("\n");
  80066d:	c7 04 24 d0 16 80 00 	movl   $0x8016d0,(%esp)
  800674:	e8 9b 00 00 00       	call   800714 <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80067c:	cc                   	int3   
  80067d:	eb fd                	jmp    80067c <_panic+0x43>

0080067f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 04             	sub    $0x4,%esp
  800686:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800689:	8b 13                	mov    (%ebx),%edx
  80068b:	8d 42 01             	lea    0x1(%edx),%eax
  80068e:	89 03                	mov    %eax,(%ebx)
  800690:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800693:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800697:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069c:	74 09                	je     8006a7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80069e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	68 ff 00 00 00       	push   $0xff
  8006af:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 61 0a 00 00       	call   801119 <sys_cputs>
		b->idx = 0;
  8006b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	eb db                	jmp    80069e <putch+0x1f>

008006c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d3:	00 00 00 
	b.cnt = 0;
  8006d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006dd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e0:	ff 75 0c             	push   0xc(%ebp)
  8006e3:	ff 75 08             	push   0x8(%ebp)
  8006e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ec:	50                   	push   %eax
  8006ed:	68 7f 06 80 00       	push   $0x80067f
  8006f2:	e8 14 01 00 00       	call   80080b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006f7:	83 c4 08             	add    $0x8,%esp
  8006fa:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800700:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	e8 0d 0a 00 00       	call   801119 <sys_cputs>

	return b.cnt;
}
  80070c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80071a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80071d:	50                   	push   %eax
  80071e:	ff 75 08             	push   0x8(%ebp)
  800721:	e8 9d ff ff ff       	call   8006c3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800726:	c9                   	leave  
  800727:	c3                   	ret    

00800728 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	57                   	push   %edi
  80072c:	56                   	push   %esi
  80072d:	53                   	push   %ebx
  80072e:	83 ec 1c             	sub    $0x1c,%esp
  800731:	89 c7                	mov    %eax,%edi
  800733:	89 d6                	mov    %edx,%esi
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 d1                	mov    %edx,%ecx
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800745:	8b 45 10             	mov    0x10(%ebp),%eax
  800748:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80074b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80074e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800755:	39 c2                	cmp    %eax,%edx
  800757:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80075a:	72 3e                	jb     80079a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075c:	83 ec 0c             	sub    $0xc,%esp
  80075f:	ff 75 18             	push   0x18(%ebp)
  800762:	83 eb 01             	sub    $0x1,%ebx
  800765:	53                   	push   %ebx
  800766:	50                   	push   %eax
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 e4             	push   -0x1c(%ebp)
  80076d:	ff 75 e0             	push   -0x20(%ebp)
  800770:	ff 75 dc             	push   -0x24(%ebp)
  800773:	ff 75 d8             	push   -0x28(%ebp)
  800776:	e8 e5 0c 00 00       	call   801460 <__udivdi3>
  80077b:	83 c4 18             	add    $0x18,%esp
  80077e:	52                   	push   %edx
  80077f:	50                   	push   %eax
  800780:	89 f2                	mov    %esi,%edx
  800782:	89 f8                	mov    %edi,%eax
  800784:	e8 9f ff ff ff       	call   800728 <printnum>
  800789:	83 c4 20             	add    $0x20,%esp
  80078c:	eb 13                	jmp    8007a1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	56                   	push   %esi
  800792:	ff 75 18             	push   0x18(%ebp)
  800795:	ff d7                	call   *%edi
  800797:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80079a:	83 eb 01             	sub    $0x1,%ebx
  80079d:	85 db                	test   %ebx,%ebx
  80079f:	7f ed                	jg     80078e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	56                   	push   %esi
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	ff 75 e4             	push   -0x1c(%ebp)
  8007ab:	ff 75 e0             	push   -0x20(%ebp)
  8007ae:	ff 75 dc             	push   -0x24(%ebp)
  8007b1:	ff 75 d8             	push   -0x28(%ebp)
  8007b4:	e8 c7 0d 00 00       	call   801580 <__umoddi3>
  8007b9:	83 c4 14             	add    $0x14,%esp
  8007bc:	0f be 80 e3 17 80 00 	movsbl 0x8017e3(%eax),%eax
  8007c3:	50                   	push   %eax
  8007c4:	ff d7                	call   *%edi
}
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007cc:	5b                   	pop    %ebx
  8007cd:	5e                   	pop    %esi
  8007ce:	5f                   	pop    %edi
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007db:	8b 10                	mov    (%eax),%edx
  8007dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8007e0:	73 0a                	jae    8007ec <sprintputch+0x1b>
		*b->buf++ = ch;
  8007e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007e5:	89 08                	mov    %ecx,(%eax)
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	88 02                	mov    %al,(%edx)
}
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <printfmt>:
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007f7:	50                   	push   %eax
  8007f8:	ff 75 10             	push   0x10(%ebp)
  8007fb:	ff 75 0c             	push   0xc(%ebp)
  8007fe:	ff 75 08             	push   0x8(%ebp)
  800801:	e8 05 00 00 00       	call   80080b <vprintfmt>
}
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <vprintfmt>:
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	57                   	push   %edi
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 3c             	sub    $0x3c,%esp
  800814:	8b 75 08             	mov    0x8(%ebp),%esi
  800817:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80081a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80081d:	eb 0a                	jmp    800829 <vprintfmt+0x1e>
			putch(ch, putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	53                   	push   %ebx
  800823:	50                   	push   %eax
  800824:	ff d6                	call   *%esi
  800826:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800829:	83 c7 01             	add    $0x1,%edi
  80082c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800830:	83 f8 25             	cmp    $0x25,%eax
  800833:	74 0c                	je     800841 <vprintfmt+0x36>
			if (ch == '\0')
  800835:	85 c0                	test   %eax,%eax
  800837:	75 e6                	jne    80081f <vprintfmt+0x14>
}
  800839:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083c:	5b                   	pop    %ebx
  80083d:	5e                   	pop    %esi
  80083e:	5f                   	pop    %edi
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    
		padc = ' ';
  800841:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800845:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80084c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  800853:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80085a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80085f:	8d 47 01             	lea    0x1(%edi),%eax
  800862:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800865:	0f b6 17             	movzbl (%edi),%edx
  800868:	8d 42 dd             	lea    -0x23(%edx),%eax
  80086b:	3c 55                	cmp    $0x55,%al
  80086d:	0f 87 a6 04 00 00    	ja     800d19 <vprintfmt+0x50e>
  800873:	0f b6 c0             	movzbl %al,%eax
  800876:	ff 24 85 20 19 80 00 	jmp    *0x801920(,%eax,4)
  80087d:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800880:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800884:	eb d9                	jmp    80085f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800886:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800889:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80088d:	eb d0                	jmp    80085f <vprintfmt+0x54>
  80088f:	0f b6 d2             	movzbl %dl,%edx
  800892:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80089d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008a0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008a4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008a7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8008aa:	83 f9 09             	cmp    $0x9,%ecx
  8008ad:	77 55                	ja     800904 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8008af:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008b2:	eb e9                	jmp    80089d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 04             	lea    0x4(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  8008c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008cc:	79 91                	jns    80085f <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8008d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8008db:	eb 82                	jmp    80085f <vprintfmt+0x54>
  8008dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e0:	85 d2                	test   %edx,%edx
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	0f 49 c2             	cmovns %edx,%eax
  8008ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8008f0:	e9 6a ff ff ff       	jmp    80085f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8008f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  8008f8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008ff:	e9 5b ff ff ff       	jmp    80085f <vprintfmt+0x54>
  800904:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800907:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80090a:	eb bc                	jmp    8008c8 <vprintfmt+0xbd>
			lflag++;
  80090c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80090f:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800912:	e9 48 ff ff ff       	jmp    80085f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8d 78 04             	lea    0x4(%eax),%edi
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	53                   	push   %ebx
  800921:	ff 30                	push   (%eax)
  800923:	ff d6                	call   *%esi
			break;
  800925:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800928:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80092b:	e9 88 03 00 00       	jmp    800cb8 <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 78 04             	lea    0x4(%eax),%edi
  800936:	8b 10                	mov    (%eax),%edx
  800938:	89 d0                	mov    %edx,%eax
  80093a:	f7 d8                	neg    %eax
  80093c:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80093f:	83 f8 0f             	cmp    $0xf,%eax
  800942:	7f 23                	jg     800967 <vprintfmt+0x15c>
  800944:	8b 14 85 80 1a 80 00 	mov    0x801a80(,%eax,4),%edx
  80094b:	85 d2                	test   %edx,%edx
  80094d:	74 18                	je     800967 <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  80094f:	52                   	push   %edx
  800950:	68 04 18 80 00       	push   $0x801804
  800955:	53                   	push   %ebx
  800956:	56                   	push   %esi
  800957:	e8 92 fe ff ff       	call   8007ee <printfmt>
  80095c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80095f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800962:	e9 51 03 00 00       	jmp    800cb8 <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800967:	50                   	push   %eax
  800968:	68 fb 17 80 00       	push   $0x8017fb
  80096d:	53                   	push   %ebx
  80096e:	56                   	push   %esi
  80096f:	e8 7a fe ff ff       	call   8007ee <printfmt>
  800974:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800977:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80097a:	e9 39 03 00 00       	jmp    800cb8 <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 c0 04             	add    $0x4,%eax
  800985:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80098d:	85 d2                	test   %edx,%edx
  80098f:	b8 f4 17 80 00       	mov    $0x8017f4,%eax
  800994:	0f 45 c2             	cmovne %edx,%eax
  800997:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80099a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80099e:	7e 06                	jle    8009a6 <vprintfmt+0x19b>
  8009a0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009a4:	75 0d                	jne    8009b3 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009a9:	89 c7                	mov    %eax,%edi
  8009ab:	03 45 d4             	add    -0x2c(%ebp),%eax
  8009ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8009b1:	eb 55                	jmp    800a08 <vprintfmt+0x1fd>
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 e0             	push   -0x20(%ebp)
  8009b9:	ff 75 cc             	push   -0x34(%ebp)
  8009bc:	e8 f5 03 00 00       	call   800db6 <strnlen>
  8009c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009c4:	29 c2                	sub    %eax,%edx
  8009c6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8009ce:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d5:	eb 0f                	jmp    8009e6 <vprintfmt+0x1db>
					putch(padc, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	53                   	push   %ebx
  8009db:	ff 75 d4             	push   -0x2c(%ebp)
  8009de:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e0:	83 ef 01             	sub    $0x1,%edi
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	85 ff                	test   %edi,%edi
  8009e8:	7f ed                	jg     8009d7 <vprintfmt+0x1cc>
  8009ea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8009ed:	85 d2                	test   %edx,%edx
  8009ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f4:	0f 49 c2             	cmovns %edx,%eax
  8009f7:	29 c2                	sub    %eax,%edx
  8009f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009fc:	eb a8                	jmp    8009a6 <vprintfmt+0x19b>
					putch(ch, putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	53                   	push   %ebx
  800a02:	52                   	push   %edx
  800a03:	ff d6                	call   *%esi
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800a0b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0d:	83 c7 01             	add    $0x1,%edi
  800a10:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a14:	0f be d0             	movsbl %al,%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	74 4b                	je     800a66 <vprintfmt+0x25b>
  800a1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1f:	78 06                	js     800a27 <vprintfmt+0x21c>
  800a21:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800a25:	78 1e                	js     800a45 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800a27:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a2b:	74 d1                	je     8009fe <vprintfmt+0x1f3>
  800a2d:	0f be c0             	movsbl %al,%eax
  800a30:	83 e8 20             	sub    $0x20,%eax
  800a33:	83 f8 5e             	cmp    $0x5e,%eax
  800a36:	76 c6                	jbe    8009fe <vprintfmt+0x1f3>
					putch('?', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	53                   	push   %ebx
  800a3c:	6a 3f                	push   $0x3f
  800a3e:	ff d6                	call   *%esi
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	eb c3                	jmp    800a08 <vprintfmt+0x1fd>
  800a45:	89 cf                	mov    %ecx,%edi
  800a47:	eb 0e                	jmp    800a57 <vprintfmt+0x24c>
				putch(' ', putdat);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	53                   	push   %ebx
  800a4d:	6a 20                	push   $0x20
  800a4f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a51:	83 ef 01             	sub    $0x1,%edi
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	85 ff                	test   %edi,%edi
  800a59:	7f ee                	jg     800a49 <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800a5b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	e9 52 02 00 00       	jmp    800cb8 <vprintfmt+0x4ad>
  800a66:	89 cf                	mov    %ecx,%edi
  800a68:	eb ed                	jmp    800a57 <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 c0 04             	add    $0x4,%eax
  800a70:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a78:	85 d2                	test   %edx,%edx
  800a7a:	b8 f4 17 80 00       	mov    $0x8017f4,%eax
  800a7f:	0f 45 c2             	cmovne %edx,%eax
  800a82:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a85:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a89:	7e 06                	jle    800a91 <vprintfmt+0x286>
  800a8b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a8f:	75 0d                	jne    800a9e <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a94:	89 c7                	mov    %eax,%edi
  800a96:	03 45 d4             	add    -0x2c(%ebp),%eax
  800a99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a9c:	eb 55                	jmp    800af3 <vprintfmt+0x2e8>
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 e0             	push   -0x20(%ebp)
  800aa4:	ff 75 cc             	push   -0x34(%ebp)
  800aa7:	e8 0a 03 00 00       	call   800db6 <strnlen>
  800aac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800aaf:	29 c2                	sub    %eax,%edx
  800ab1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800ab9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800abd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac0:	eb 0f                	jmp    800ad1 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	53                   	push   %ebx
  800ac6:	ff 75 d4             	push   -0x2c(%ebp)
  800ac9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800acb:	83 ef 01             	sub    $0x1,%edi
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	85 ff                	test   %edi,%edi
  800ad3:	7f ed                	jg     800ac2 <vprintfmt+0x2b7>
  800ad5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ad8:	85 d2                	test   %edx,%edx
  800ada:	b8 00 00 00 00       	mov    $0x0,%eax
  800adf:	0f 49 c2             	cmovns %edx,%eax
  800ae2:	29 c2                	sub    %eax,%edx
  800ae4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ae7:	eb a8                	jmp    800a91 <vprintfmt+0x286>
					putch(ch, putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	53                   	push   %ebx
  800aed:	52                   	push   %edx
  800aee:	ff d6                	call   *%esi
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800af6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800af8:	83 c7 01             	add    $0x1,%edi
  800afb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800aff:	0f be d0             	movsbl %al,%edx
  800b02:	3c 3a                	cmp    $0x3a,%al
  800b04:	74 4b                	je     800b51 <vprintfmt+0x346>
  800b06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b0a:	78 06                	js     800b12 <vprintfmt+0x307>
  800b0c:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800b10:	78 1e                	js     800b30 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800b12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b16:	74 d1                	je     800ae9 <vprintfmt+0x2de>
  800b18:	0f be c0             	movsbl %al,%eax
  800b1b:	83 e8 20             	sub    $0x20,%eax
  800b1e:	83 f8 5e             	cmp    $0x5e,%eax
  800b21:	76 c6                	jbe    800ae9 <vprintfmt+0x2de>
					putch('?', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	53                   	push   %ebx
  800b27:	6a 3f                	push   $0x3f
  800b29:	ff d6                	call   *%esi
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	eb c3                	jmp    800af3 <vprintfmt+0x2e8>
  800b30:	89 cf                	mov    %ecx,%edi
  800b32:	eb 0e                	jmp    800b42 <vprintfmt+0x337>
				putch(' ', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	53                   	push   %ebx
  800b38:	6a 20                	push   $0x20
  800b3a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b3c:	83 ef 01             	sub    $0x1,%edi
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	85 ff                	test   %edi,%edi
  800b44:	7f ee                	jg     800b34 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800b46:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4c:	e9 67 01 00 00       	jmp    800cb8 <vprintfmt+0x4ad>
  800b51:	89 cf                	mov    %ecx,%edi
  800b53:	eb ed                	jmp    800b42 <vprintfmt+0x337>
	if (lflag >= 2)
  800b55:	83 f9 01             	cmp    $0x1,%ecx
  800b58:	7f 1b                	jg     800b75 <vprintfmt+0x36a>
	else if (lflag)
  800b5a:	85 c9                	test   %ecx,%ecx
  800b5c:	74 63                	je     800bc1 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b66:	99                   	cltd   
  800b67:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	8d 40 04             	lea    0x4(%eax),%eax
  800b70:	89 45 14             	mov    %eax,0x14(%ebp)
  800b73:	eb 17                	jmp    800b8c <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800b75:	8b 45 14             	mov    0x14(%ebp),%eax
  800b78:	8b 50 04             	mov    0x4(%eax),%edx
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b80:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b83:	8b 45 14             	mov    0x14(%ebp),%eax
  800b86:	8d 40 08             	lea    0x8(%eax),%eax
  800b89:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b8f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800b92:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800b97:	85 c9                	test   %ecx,%ecx
  800b99:	0f 89 ff 00 00 00    	jns    800c9e <vprintfmt+0x493>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	53                   	push   %ebx
  800ba3:	6a 2d                	push   $0x2d
  800ba5:	ff d6                	call   *%esi
				num = -(long long) num;
  800ba7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800baa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800bad:	f7 da                	neg    %edx
  800baf:	83 d1 00             	adc    $0x0,%ecx
  800bb2:	f7 d9                	neg    %ecx
  800bb4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bb7:	bf 0a 00 00 00       	mov    $0xa,%edi
  800bbc:	e9 dd 00 00 00       	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, int);
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bc9:	99                   	cltd   
  800bca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd0:	8d 40 04             	lea    0x4(%eax),%eax
  800bd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd6:	eb b4                	jmp    800b8c <vprintfmt+0x381>
	if (lflag >= 2)
  800bd8:	83 f9 01             	cmp    $0x1,%ecx
  800bdb:	7f 1e                	jg     800bfb <vprintfmt+0x3f0>
	else if (lflag)
  800bdd:	85 c9                	test   %ecx,%ecx
  800bdf:	74 32                	je     800c13 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800be1:	8b 45 14             	mov    0x14(%ebp),%eax
  800be4:	8b 10                	mov    (%eax),%edx
  800be6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800beb:	8d 40 04             	lea    0x4(%eax),%eax
  800bee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf1:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800bf6:	e9 a3 00 00 00       	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfe:	8b 10                	mov    (%eax),%edx
  800c00:	8b 48 04             	mov    0x4(%eax),%ecx
  800c03:	8d 40 08             	lea    0x8(%eax),%eax
  800c06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c09:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800c0e:	e9 8b 00 00 00       	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1d:	8d 40 04             	lea    0x4(%eax),%eax
  800c20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c23:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800c28:	eb 74                	jmp    800c9e <vprintfmt+0x493>
	if (lflag >= 2)
  800c2a:	83 f9 01             	cmp    $0x1,%ecx
  800c2d:	7f 1b                	jg     800c4a <vprintfmt+0x43f>
	else if (lflag)
  800c2f:	85 c9                	test   %ecx,%ecx
  800c31:	74 2c                	je     800c5f <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800c33:	8b 45 14             	mov    0x14(%ebp),%eax
  800c36:	8b 10                	mov    (%eax),%edx
  800c38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3d:	8d 40 04             	lea    0x4(%eax),%eax
  800c40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c43:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800c48:	eb 54                	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4d:	8b 10                	mov    (%eax),%edx
  800c4f:	8b 48 04             	mov    0x4(%eax),%ecx
  800c52:	8d 40 08             	lea    0x8(%eax),%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c58:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800c5d:	eb 3f                	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800c5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c69:	8d 40 04             	lea    0x4(%eax),%eax
  800c6c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c6f:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800c74:	eb 28                	jmp    800c9e <vprintfmt+0x493>
			putch('0', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	53                   	push   %ebx
  800c7a:	6a 30                	push   $0x30
  800c7c:	ff d6                	call   *%esi
			putch('x', putdat);
  800c7e:	83 c4 08             	add    $0x8,%esp
  800c81:	53                   	push   %ebx
  800c82:	6a 78                	push   $0x78
  800c84:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	8b 10                	mov    (%eax),%edx
  800c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c90:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c93:	8d 40 04             	lea    0x4(%eax),%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c99:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800c9e:	83 ec 0c             	sub    $0xc,%esp
  800ca1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800ca5:	50                   	push   %eax
  800ca6:	ff 75 d4             	push   -0x2c(%ebp)
  800ca9:	57                   	push   %edi
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	89 da                	mov    %ebx,%edx
  800cae:	89 f0                	mov    %esi,%eax
  800cb0:	e8 73 fa ff ff       	call   800728 <printnum>
			break;
  800cb5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800cb8:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbb:	e9 69 fb ff ff       	jmp    800829 <vprintfmt+0x1e>
	if (lflag >= 2)
  800cc0:	83 f9 01             	cmp    $0x1,%ecx
  800cc3:	7f 1b                	jg     800ce0 <vprintfmt+0x4d5>
	else if (lflag)
  800cc5:	85 c9                	test   %ecx,%ecx
  800cc7:	74 2c                	je     800cf5 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	8b 10                	mov    (%eax),%edx
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	8d 40 04             	lea    0x4(%eax),%eax
  800cd6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cd9:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800cde:	eb be                	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800ce0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce3:	8b 10                	mov    (%eax),%edx
  800ce5:	8b 48 04             	mov    0x4(%eax),%ecx
  800ce8:	8d 40 08             	lea    0x8(%eax),%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cee:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800cf3:	eb a9                	jmp    800c9e <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	8b 10                	mov    (%eax),%edx
  800cfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cff:	8d 40 04             	lea    0x4(%eax),%eax
  800d02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d05:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800d0a:	eb 92                	jmp    800c9e <vprintfmt+0x493>
			putch(ch, putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	53                   	push   %ebx
  800d10:	6a 25                	push   $0x25
  800d12:	ff d6                	call   *%esi
			break;
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	eb 9f                	jmp    800cb8 <vprintfmt+0x4ad>
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	53                   	push   %ebx
  800d1d:	6a 25                	push   $0x25
  800d1f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	89 f8                	mov    %edi,%eax
  800d26:	eb 03                	jmp    800d2b <vprintfmt+0x520>
  800d28:	83 e8 01             	sub    $0x1,%eax
  800d2b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d2f:	75 f7                	jne    800d28 <vprintfmt+0x51d>
  800d31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d34:	eb 82                	jmp    800cb8 <vprintfmt+0x4ad>

00800d36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 18             	sub    $0x18,%esp
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d45:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d49:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	74 26                	je     800d7d <vsnprintf+0x47>
  800d57:	85 d2                	test   %edx,%edx
  800d59:	7e 22                	jle    800d7d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5b:	ff 75 14             	push   0x14(%ebp)
  800d5e:	ff 75 10             	push   0x10(%ebp)
  800d61:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d64:	50                   	push   %eax
  800d65:	68 d1 07 80 00       	push   $0x8007d1
  800d6a:	e8 9c fa ff ff       	call   80080b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d78:	83 c4 10             	add    $0x10,%esp
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    
		return -E_INVAL;
  800d7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d82:	eb f7                	jmp    800d7b <vsnprintf+0x45>

00800d84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8d:	50                   	push   %eax
  800d8e:	ff 75 10             	push   0x10(%ebp)
  800d91:	ff 75 0c             	push   0xc(%ebp)
  800d94:	ff 75 08             	push   0x8(%ebp)
  800d97:	e8 9a ff ff ff       	call   800d36 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da4:	b8 00 00 00 00       	mov    $0x0,%eax
  800da9:	eb 03                	jmp    800dae <strlen+0x10>
		n++;
  800dab:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800dae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800db2:	75 f7                	jne    800dab <strlen+0xd>
	return n;
}
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc4:	eb 03                	jmp    800dc9 <strnlen+0x13>
		n++;
  800dc6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc9:	39 d0                	cmp    %edx,%eax
  800dcb:	74 08                	je     800dd5 <strnlen+0x1f>
  800dcd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800dd1:	75 f3                	jne    800dc6 <strnlen+0x10>
  800dd3:	89 c2                	mov    %eax,%edx
	return n;
}
  800dd5:	89 d0                	mov    %edx,%eax
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	53                   	push   %ebx
  800ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
  800de8:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800dec:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800def:	83 c0 01             	add    $0x1,%eax
  800df2:	84 d2                	test   %dl,%dl
  800df4:	75 f2                	jne    800de8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800df6:	89 c8                	mov    %ecx,%eax
  800df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	53                   	push   %ebx
  800e01:	83 ec 10             	sub    $0x10,%esp
  800e04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e07:	53                   	push   %ebx
  800e08:	e8 91 ff ff ff       	call   800d9e <strlen>
  800e0d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e10:	ff 75 0c             	push   0xc(%ebp)
  800e13:	01 d8                	add    %ebx,%eax
  800e15:	50                   	push   %eax
  800e16:	e8 be ff ff ff       	call   800dd9 <strcpy>
	return dst;
}
  800e1b:	89 d8                	mov    %ebx,%eax
  800e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	89 f3                	mov    %esi,%ebx
  800e2f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e32:	89 f0                	mov    %esi,%eax
  800e34:	eb 0f                	jmp    800e45 <strncpy+0x23>
		*dst++ = *src;
  800e36:	83 c0 01             	add    $0x1,%eax
  800e39:	0f b6 0a             	movzbl (%edx),%ecx
  800e3c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e3f:	80 f9 01             	cmp    $0x1,%cl
  800e42:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800e45:	39 d8                	cmp    %ebx,%eax
  800e47:	75 ed                	jne    800e36 <strncpy+0x14>
	}
	return ret;
}
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	8b 75 08             	mov    0x8(%ebp),%esi
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	8b 55 10             	mov    0x10(%ebp),%edx
  800e5d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e5f:	85 d2                	test   %edx,%edx
  800e61:	74 21                	je     800e84 <strlcpy+0x35>
  800e63:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e67:	89 f2                	mov    %esi,%edx
  800e69:	eb 09                	jmp    800e74 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800e6b:	83 c1 01             	add    $0x1,%ecx
  800e6e:	83 c2 01             	add    $0x1,%edx
  800e71:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800e74:	39 c2                	cmp    %eax,%edx
  800e76:	74 09                	je     800e81 <strlcpy+0x32>
  800e78:	0f b6 19             	movzbl (%ecx),%ebx
  800e7b:	84 db                	test   %bl,%bl
  800e7d:	75 ec                	jne    800e6b <strlcpy+0x1c>
  800e7f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e84:	29 f0                	sub    %esi,%eax
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e90:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e93:	eb 06                	jmp    800e9b <strcmp+0x11>
		p++, q++;
  800e95:	83 c1 01             	add    $0x1,%ecx
  800e98:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e9b:	0f b6 01             	movzbl (%ecx),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 04                	je     800ea6 <strcmp+0x1c>
  800ea2:	3a 02                	cmp    (%edx),%al
  800ea4:	74 ef                	je     800e95 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	0f b6 c0             	movzbl %al,%eax
  800ea9:	0f b6 12             	movzbl (%edx),%edx
  800eac:	29 d0                	sub    %edx,%eax
}
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	53                   	push   %ebx
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eba:	89 c3                	mov    %eax,%ebx
  800ebc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ebf:	eb 06                	jmp    800ec7 <strncmp+0x17>
		n--, p++, q++;
  800ec1:	83 c0 01             	add    $0x1,%eax
  800ec4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ec7:	39 d8                	cmp    %ebx,%eax
  800ec9:	74 18                	je     800ee3 <strncmp+0x33>
  800ecb:	0f b6 08             	movzbl (%eax),%ecx
  800ece:	84 c9                	test   %cl,%cl
  800ed0:	74 04                	je     800ed6 <strncmp+0x26>
  800ed2:	3a 0a                	cmp    (%edx),%cl
  800ed4:	74 eb                	je     800ec1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ed6:	0f b6 00             	movzbl (%eax),%eax
  800ed9:	0f b6 12             	movzbl (%edx),%edx
  800edc:	29 d0                	sub    %edx,%eax
}
  800ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    
		return 0;
  800ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee8:	eb f4                	jmp    800ede <strncmp+0x2e>

00800eea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ef4:	eb 03                	jmp    800ef9 <strchr+0xf>
  800ef6:	83 c0 01             	add    $0x1,%eax
  800ef9:	0f b6 10             	movzbl (%eax),%edx
  800efc:	84 d2                	test   %dl,%dl
  800efe:	74 06                	je     800f06 <strchr+0x1c>
		if (*s == c)
  800f00:	38 ca                	cmp    %cl,%dl
  800f02:	75 f2                	jne    800ef6 <strchr+0xc>
  800f04:	eb 05                	jmp    800f0b <strchr+0x21>
			return (char *) s;
	return 0;
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f17:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f1a:	38 ca                	cmp    %cl,%dl
  800f1c:	74 09                	je     800f27 <strfind+0x1a>
  800f1e:	84 d2                	test   %dl,%dl
  800f20:	74 05                	je     800f27 <strfind+0x1a>
	for (; *s; s++)
  800f22:	83 c0 01             	add    $0x1,%eax
  800f25:	eb f0                	jmp    800f17 <strfind+0xa>
			break;
	return (char *) s;
}
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f35:	85 c9                	test   %ecx,%ecx
  800f37:	74 2f                	je     800f68 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f39:	89 f8                	mov    %edi,%eax
  800f3b:	09 c8                	or     %ecx,%eax
  800f3d:	a8 03                	test   $0x3,%al
  800f3f:	75 21                	jne    800f62 <memset+0x39>
		c &= 0xFF;
  800f41:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f45:	89 d0                	mov    %edx,%eax
  800f47:	c1 e0 08             	shl    $0x8,%eax
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	c1 e3 18             	shl    $0x18,%ebx
  800f4f:	89 d6                	mov    %edx,%esi
  800f51:	c1 e6 10             	shl    $0x10,%esi
  800f54:	09 f3                	or     %esi,%ebx
  800f56:	09 da                	or     %ebx,%edx
  800f58:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f5a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f5d:	fc                   	cld    
  800f5e:	f3 ab                	rep stos %eax,%es:(%edi)
  800f60:	eb 06                	jmp    800f68 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	fc                   	cld    
  800f66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f68:	89 f8                	mov    %edi,%eax
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7d:	39 c6                	cmp    %eax,%esi
  800f7f:	73 32                	jae    800fb3 <memmove+0x44>
  800f81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f84:	39 c2                	cmp    %eax,%edx
  800f86:	76 2b                	jbe    800fb3 <memmove+0x44>
		s += n;
		d += n;
  800f88:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f8b:	89 d6                	mov    %edx,%esi
  800f8d:	09 fe                	or     %edi,%esi
  800f8f:	09 ce                	or     %ecx,%esi
  800f91:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f97:	75 0e                	jne    800fa7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f99:	83 ef 04             	sub    $0x4,%edi
  800f9c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fa2:	fd                   	std    
  800fa3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fa5:	eb 09                	jmp    800fb0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fa7:	83 ef 01             	sub    $0x1,%edi
  800faa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fad:	fd                   	std    
  800fae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fb0:	fc                   	cld    
  800fb1:	eb 1a                	jmp    800fcd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fb3:	89 f2                	mov    %esi,%edx
  800fb5:	09 c2                	or     %eax,%edx
  800fb7:	09 ca                	or     %ecx,%edx
  800fb9:	f6 c2 03             	test   $0x3,%dl
  800fbc:	75 0a                	jne    800fc8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fbe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fc1:	89 c7                	mov    %eax,%edi
  800fc3:	fc                   	cld    
  800fc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fc6:	eb 05                	jmp    800fcd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fc8:	89 c7                	mov    %eax,%edi
  800fca:	fc                   	cld    
  800fcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fd7:	ff 75 10             	push   0x10(%ebp)
  800fda:	ff 75 0c             	push   0xc(%ebp)
  800fdd:	ff 75 08             	push   0x8(%ebp)
  800fe0:	e8 8a ff ff ff       	call   800f6f <memmove>
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff2:	89 c6                	mov    %eax,%esi
  800ff4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ff7:	eb 06                	jmp    800fff <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ff9:	83 c0 01             	add    $0x1,%eax
  800ffc:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800fff:	39 f0                	cmp    %esi,%eax
  801001:	74 14                	je     801017 <memcmp+0x30>
		if (*s1 != *s2)
  801003:	0f b6 08             	movzbl (%eax),%ecx
  801006:	0f b6 1a             	movzbl (%edx),%ebx
  801009:	38 d9                	cmp    %bl,%cl
  80100b:	74 ec                	je     800ff9 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  80100d:	0f b6 c1             	movzbl %cl,%eax
  801010:	0f b6 db             	movzbl %bl,%ebx
  801013:	29 d8                	sub    %ebx,%eax
  801015:	eb 05                	jmp    80101c <memcmp+0x35>
	}

	return 0;
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801029:	89 c2                	mov    %eax,%edx
  80102b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80102e:	eb 03                	jmp    801033 <memfind+0x13>
  801030:	83 c0 01             	add    $0x1,%eax
  801033:	39 d0                	cmp    %edx,%eax
  801035:	73 04                	jae    80103b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801037:	38 08                	cmp    %cl,(%eax)
  801039:	75 f5                	jne    801030 <memfind+0x10>
			break;
	return (void *) s;
}
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801049:	eb 03                	jmp    80104e <strtol+0x11>
		s++;
  80104b:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  80104e:	0f b6 02             	movzbl (%edx),%eax
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f6                	je     80104b <strtol+0xe>
  801055:	3c 09                	cmp    $0x9,%al
  801057:	74 f2                	je     80104b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801059:	3c 2b                	cmp    $0x2b,%al
  80105b:	74 2a                	je     801087 <strtol+0x4a>
	int neg = 0;
  80105d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801062:	3c 2d                	cmp    $0x2d,%al
  801064:	74 2b                	je     801091 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801066:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80106c:	75 0f                	jne    80107d <strtol+0x40>
  80106e:	80 3a 30             	cmpb   $0x30,(%edx)
  801071:	74 28                	je     80109b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801073:	85 db                	test   %ebx,%ebx
  801075:	b8 0a 00 00 00       	mov    $0xa,%eax
  80107a:	0f 44 d8             	cmove  %eax,%ebx
  80107d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801082:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801085:	eb 46                	jmp    8010cd <strtol+0x90>
		s++;
  801087:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  80108a:	bf 00 00 00 00       	mov    $0x0,%edi
  80108f:	eb d5                	jmp    801066 <strtol+0x29>
		s++, neg = 1;
  801091:	83 c2 01             	add    $0x1,%edx
  801094:	bf 01 00 00 00       	mov    $0x1,%edi
  801099:	eb cb                	jmp    801066 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80109b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80109f:	74 0e                	je     8010af <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8010a1:	85 db                	test   %ebx,%ebx
  8010a3:	75 d8                	jne    80107d <strtol+0x40>
		s++, base = 8;
  8010a5:	83 c2 01             	add    $0x1,%edx
  8010a8:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010ad:	eb ce                	jmp    80107d <strtol+0x40>
		s += 2, base = 16;
  8010af:	83 c2 02             	add    $0x2,%edx
  8010b2:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010b7:	eb c4                	jmp    80107d <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8010b9:	0f be c0             	movsbl %al,%eax
  8010bc:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c2:	7d 3a                	jge    8010fe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010c4:	83 c2 01             	add    $0x1,%edx
  8010c7:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  8010cb:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  8010cd:	0f b6 02             	movzbl (%edx),%eax
  8010d0:	8d 70 d0             	lea    -0x30(%eax),%esi
  8010d3:	89 f3                	mov    %esi,%ebx
  8010d5:	80 fb 09             	cmp    $0x9,%bl
  8010d8:	76 df                	jbe    8010b9 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  8010da:	8d 70 9f             	lea    -0x61(%eax),%esi
  8010dd:	89 f3                	mov    %esi,%ebx
  8010df:	80 fb 19             	cmp    $0x19,%bl
  8010e2:	77 08                	ja     8010ec <strtol+0xaf>
			dig = *s - 'a' + 10;
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	83 e8 57             	sub    $0x57,%eax
  8010ea:	eb d3                	jmp    8010bf <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  8010ec:	8d 70 bf             	lea    -0x41(%eax),%esi
  8010ef:	89 f3                	mov    %esi,%ebx
  8010f1:	80 fb 19             	cmp    $0x19,%bl
  8010f4:	77 08                	ja     8010fe <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010f6:	0f be c0             	movsbl %al,%eax
  8010f9:	83 e8 37             	sub    $0x37,%eax
  8010fc:	eb c1                	jmp    8010bf <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 05                	je     801109 <strtol+0xcc>
		*endptr = (char *) s;
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801109:	89 c8                	mov    %ecx,%eax
  80110b:	f7 d8                	neg    %eax
  80110d:	85 ff                	test   %edi,%edi
  80110f:	0f 45 c8             	cmovne %eax,%ecx
}
  801112:	89 c8                	mov    %ecx,%eax
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112a:	89 c3                	mov    %eax,%ebx
  80112c:	89 c7                	mov    %eax,%edi
  80112e:	89 c6                	mov    %eax,%esi
  801130:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_cgetc>:

int
sys_cgetc(void)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113d:	ba 00 00 00 00       	mov    $0x0,%edx
  801142:	b8 01 00 00 00       	mov    $0x1,%eax
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 d3                	mov    %edx,%ebx
  80114b:	89 d7                	mov    %edx,%edi
  80114d:	89 d6                	mov    %edx,%esi
  80114f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
  80115c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80115f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801164:	8b 55 08             	mov    0x8(%ebp),%edx
  801167:	b8 03 00 00 00       	mov    $0x3,%eax
  80116c:	89 cb                	mov    %ecx,%ebx
  80116e:	89 cf                	mov    %ecx,%edi
  801170:	89 ce                	mov    %ecx,%esi
  801172:	cd 30                	int    $0x30
	if(check && ret > 0)
  801174:	85 c0                	test   %eax,%eax
  801176:	7f 08                	jg     801180 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	50                   	push   %eax
  801184:	6a 03                	push   $0x3
  801186:	68 df 1a 80 00       	push   $0x801adf
  80118b:	6a 23                	push   $0x23
  80118d:	68 fc 1a 80 00       	push   $0x801afc
  801192:	e8 a2 f4 ff ff       	call   800639 <_panic>

00801197 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80119d:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011a7:	89 d1                	mov    %edx,%ecx
  8011a9:	89 d3                	mov    %edx,%ebx
  8011ab:	89 d7                	mov    %edx,%edi
  8011ad:	89 d6                	mov    %edx,%esi
  8011af:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011b1:	5b                   	pop    %ebx
  8011b2:	5e                   	pop    %esi
  8011b3:	5f                   	pop    %edi
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <sys_yield>:

void
sys_yield(void)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	57                   	push   %edi
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011c6:	89 d1                	mov    %edx,%ecx
  8011c8:	89 d3                	mov    %edx,%ebx
  8011ca:	89 d7                	mov    %edx,%edi
  8011cc:	89 d6                	mov    %edx,%esi
  8011ce:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5f                   	pop    %edi
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011de:	be 00 00 00 00       	mov    $0x0,%esi
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8011ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f1:	89 f7                	mov    %esi,%edi
  8011f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	7f 08                	jg     801201 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	50                   	push   %eax
  801205:	6a 04                	push   $0x4
  801207:	68 df 1a 80 00       	push   $0x801adf
  80120c:	6a 23                	push   $0x23
  80120e:	68 fc 1a 80 00       	push   $0x801afc
  801213:	e8 21 f4 ff ff       	call   800639 <_panic>

00801218 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801227:	b8 05 00 00 00       	mov    $0x5,%eax
  80122c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80122f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801232:	8b 75 18             	mov    0x18(%ebp),%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 05                	push   $0x5
  801249:	68 df 1a 80 00       	push   $0x801adf
  80124e:	6a 23                	push   $0x23
  801250:	68 fc 1a 80 00       	push   $0x801afc
  801255:	e8 df f3 ff ff       	call   800639 <_panic>

0080125a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801263:	bb 00 00 00 00       	mov    $0x0,%ebx
  801268:	8b 55 08             	mov    0x8(%ebp),%edx
  80126b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126e:	b8 06 00 00 00       	mov    $0x6,%eax
  801273:	89 df                	mov    %ebx,%edi
  801275:	89 de                	mov    %ebx,%esi
  801277:	cd 30                	int    $0x30
	if(check && ret > 0)
  801279:	85 c0                	test   %eax,%eax
  80127b:	7f 08                	jg     801285 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80127d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801280:	5b                   	pop    %ebx
  801281:	5e                   	pop    %esi
  801282:	5f                   	pop    %edi
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	50                   	push   %eax
  801289:	6a 06                	push   $0x6
  80128b:	68 df 1a 80 00       	push   $0x801adf
  801290:	6a 23                	push   $0x23
  801292:	68 fc 1a 80 00       	push   $0x801afc
  801297:	e8 9d f3 ff ff       	call   800639 <_panic>

0080129c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8012b5:	89 df                	mov    %ebx,%edi
  8012b7:	89 de                	mov    %ebx,%esi
  8012b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	7f 08                	jg     8012c7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c7:	83 ec 0c             	sub    $0xc,%esp
  8012ca:	50                   	push   %eax
  8012cb:	6a 08                	push   $0x8
  8012cd:	68 df 1a 80 00       	push   $0x801adf
  8012d2:	6a 23                	push   $0x23
  8012d4:	68 fc 1a 80 00       	push   $0x801afc
  8012d9:	e8 5b f3 ff ff       	call   800639 <_panic>

008012de <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	57                   	push   %edi
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f2:	b8 09 00 00 00       	mov    $0x9,%eax
  8012f7:	89 df                	mov    %ebx,%edi
  8012f9:	89 de                	mov    %ebx,%esi
  8012fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	7f 08                	jg     801309 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801301:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5f                   	pop    %edi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	50                   	push   %eax
  80130d:	6a 09                	push   $0x9
  80130f:	68 df 1a 80 00       	push   $0x801adf
  801314:	6a 23                	push   $0x23
  801316:	68 fc 1a 80 00       	push   $0x801afc
  80131b:	e8 19 f3 ff ff       	call   800639 <_panic>

00801320 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	57                   	push   %edi
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801329:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132e:	8b 55 08             	mov    0x8(%ebp),%edx
  801331:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801334:	b8 0a 00 00 00       	mov    $0xa,%eax
  801339:	89 df                	mov    %ebx,%edi
  80133b:	89 de                	mov    %ebx,%esi
  80133d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80133f:	85 c0                	test   %eax,%eax
  801341:	7f 08                	jg     80134b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801343:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	50                   	push   %eax
  80134f:	6a 0a                	push   $0xa
  801351:	68 df 1a 80 00       	push   $0x801adf
  801356:	6a 23                	push   $0x23
  801358:	68 fc 1a 80 00       	push   $0x801afc
  80135d:	e8 d7 f2 ff ff       	call   800639 <_panic>

00801362 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	57                   	push   %edi
  801366:	56                   	push   %esi
  801367:	53                   	push   %ebx
	asm volatile("int %1\n"
  801368:	8b 55 08             	mov    0x8(%ebp),%edx
  80136b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801373:	be 00 00 00 00       	mov    $0x0,%esi
  801378:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80137b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80137e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801380:	5b                   	pop    %ebx
  801381:	5e                   	pop    %esi
  801382:	5f                   	pop    %edi
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    

00801385 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	57                   	push   %edi
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80138e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801393:	8b 55 08             	mov    0x8(%ebp),%edx
  801396:	b8 0d 00 00 00       	mov    $0xd,%eax
  80139b:	89 cb                	mov    %ecx,%ebx
  80139d:	89 cf                	mov    %ecx,%edi
  80139f:	89 ce                	mov    %ecx,%esi
  8013a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	7f 08                	jg     8013af <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	50                   	push   %eax
  8013b3:	6a 0d                	push   $0xd
  8013b5:	68 df 1a 80 00       	push   $0x801adf
  8013ba:	6a 23                	push   $0x23
  8013bc:	68 fc 1a 80 00       	push   $0x801afc
  8013c1:	e8 73 f2 ff ff       	call   800639 <_panic>

008013c6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013cc:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  8013d3:	74 20                	je     8013f5 <set_pgfault_handler+0x2f>
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
			panic("set_pgfault_handler: sys_page_alloc error\n");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	a3 d0 20 80 00       	mov    %eax,0x8020d0
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	68 35 14 80 00       	push   $0x801435
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 34 ff ff ff       	call   801320 <sys_env_set_pgfault_upcall>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 2e                	js     801421 <set_pgfault_handler+0x5b>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	6a 07                	push   $0x7
  8013fa:	68 00 f0 bf ee       	push   $0xeebff000
  8013ff:	6a 00                	push   $0x0
  801401:	e8 cf fd ff ff       	call   8011d5 <sys_page_alloc>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	79 c8                	jns    8013d5 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	68 0c 1b 80 00       	push   $0x801b0c
  801415:	6a 21                	push   $0x21
  801417:	68 6f 1b 80 00       	push   $0x801b6f
  80141c:	e8 18 f2 ff ff       	call   800639 <_panic>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	68 38 1b 80 00       	push   $0x801b38
  801429:	6a 27                	push   $0x27
  80142b:	68 6f 1b 80 00       	push   $0x801b6f
  801430:	e8 04 f2 ff ff       	call   800639 <_panic>

00801435 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801435:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801436:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  80143b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80143d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax	// trap-time eip
  801440:	8b 44 24 28          	mov    0x28(%esp),%eax
	subl $0x4, 0x30(%esp)	// we have to use subl now because we can't use after popfl
  801444:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %ebx   // trap-time esp-4
  801449:	8b 5c 24 30          	mov    0x30(%esp),%ebx
	movl %eax, (%ebx)		// push trap-time eip to trap-time stack
  80144d:	89 03                	mov    %eax,(%ebx)
	addl $0x8, %esp			// skip fault_va and error code
  80144f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801452:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  801453:	83 c4 04             	add    $0x4,%esp
	popfl
  801456:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801457:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801458:	c3                   	ret    
  801459:	66 90                	xchg   %ax,%ax
  80145b:	66 90                	xchg   %ax,%ax
  80145d:	66 90                	xchg   %ax,%ax
  80145f:	90                   	nop

00801460 <__udivdi3>:
  801460:	f3 0f 1e fb          	endbr32 
  801464:	55                   	push   %ebp
  801465:	57                   	push   %edi
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
  801468:	83 ec 1c             	sub    $0x1c,%esp
  80146b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80146f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801473:	8b 74 24 34          	mov    0x34(%esp),%esi
  801477:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80147b:	85 c0                	test   %eax,%eax
  80147d:	75 19                	jne    801498 <__udivdi3+0x38>
  80147f:	39 f3                	cmp    %esi,%ebx
  801481:	76 4d                	jbe    8014d0 <__udivdi3+0x70>
  801483:	31 ff                	xor    %edi,%edi
  801485:	89 e8                	mov    %ebp,%eax
  801487:	89 f2                	mov    %esi,%edx
  801489:	f7 f3                	div    %ebx
  80148b:	89 fa                	mov    %edi,%edx
  80148d:	83 c4 1c             	add    $0x1c,%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    
  801495:	8d 76 00             	lea    0x0(%esi),%esi
  801498:	39 f0                	cmp    %esi,%eax
  80149a:	76 14                	jbe    8014b0 <__udivdi3+0x50>
  80149c:	31 ff                	xor    %edi,%edi
  80149e:	31 c0                	xor    %eax,%eax
  8014a0:	89 fa                	mov    %edi,%edx
  8014a2:	83 c4 1c             	add    $0x1c,%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
  8014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014b0:	0f bd f8             	bsr    %eax,%edi
  8014b3:	83 f7 1f             	xor    $0x1f,%edi
  8014b6:	75 48                	jne    801500 <__udivdi3+0xa0>
  8014b8:	39 f0                	cmp    %esi,%eax
  8014ba:	72 06                	jb     8014c2 <__udivdi3+0x62>
  8014bc:	31 c0                	xor    %eax,%eax
  8014be:	39 eb                	cmp    %ebp,%ebx
  8014c0:	77 de                	ja     8014a0 <__udivdi3+0x40>
  8014c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c7:	eb d7                	jmp    8014a0 <__udivdi3+0x40>
  8014c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014d0:	89 d9                	mov    %ebx,%ecx
  8014d2:	85 db                	test   %ebx,%ebx
  8014d4:	75 0b                	jne    8014e1 <__udivdi3+0x81>
  8014d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8014db:	31 d2                	xor    %edx,%edx
  8014dd:	f7 f3                	div    %ebx
  8014df:	89 c1                	mov    %eax,%ecx
  8014e1:	31 d2                	xor    %edx,%edx
  8014e3:	89 f0                	mov    %esi,%eax
  8014e5:	f7 f1                	div    %ecx
  8014e7:	89 c6                	mov    %eax,%esi
  8014e9:	89 e8                	mov    %ebp,%eax
  8014eb:	89 f7                	mov    %esi,%edi
  8014ed:	f7 f1                	div    %ecx
  8014ef:	89 fa                	mov    %edi,%edx
  8014f1:	83 c4 1c             	add    $0x1c,%esp
  8014f4:	5b                   	pop    %ebx
  8014f5:	5e                   	pop    %esi
  8014f6:	5f                   	pop    %edi
  8014f7:	5d                   	pop    %ebp
  8014f8:	c3                   	ret    
  8014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801500:	89 f9                	mov    %edi,%ecx
  801502:	ba 20 00 00 00       	mov    $0x20,%edx
  801507:	29 fa                	sub    %edi,%edx
  801509:	d3 e0                	shl    %cl,%eax
  80150b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80150f:	89 d1                	mov    %edx,%ecx
  801511:	89 d8                	mov    %ebx,%eax
  801513:	d3 e8                	shr    %cl,%eax
  801515:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801519:	09 c1                	or     %eax,%ecx
  80151b:	89 f0                	mov    %esi,%eax
  80151d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801521:	89 f9                	mov    %edi,%ecx
  801523:	d3 e3                	shl    %cl,%ebx
  801525:	89 d1                	mov    %edx,%ecx
  801527:	d3 e8                	shr    %cl,%eax
  801529:	89 f9                	mov    %edi,%ecx
  80152b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80152f:	89 eb                	mov    %ebp,%ebx
  801531:	d3 e6                	shl    %cl,%esi
  801533:	89 d1                	mov    %edx,%ecx
  801535:	d3 eb                	shr    %cl,%ebx
  801537:	09 f3                	or     %esi,%ebx
  801539:	89 c6                	mov    %eax,%esi
  80153b:	89 f2                	mov    %esi,%edx
  80153d:	89 d8                	mov    %ebx,%eax
  80153f:	f7 74 24 08          	divl   0x8(%esp)
  801543:	89 d6                	mov    %edx,%esi
  801545:	89 c3                	mov    %eax,%ebx
  801547:	f7 64 24 0c          	mull   0xc(%esp)
  80154b:	39 d6                	cmp    %edx,%esi
  80154d:	72 19                	jb     801568 <__udivdi3+0x108>
  80154f:	89 f9                	mov    %edi,%ecx
  801551:	d3 e5                	shl    %cl,%ebp
  801553:	39 c5                	cmp    %eax,%ebp
  801555:	73 04                	jae    80155b <__udivdi3+0xfb>
  801557:	39 d6                	cmp    %edx,%esi
  801559:	74 0d                	je     801568 <__udivdi3+0x108>
  80155b:	89 d8                	mov    %ebx,%eax
  80155d:	31 ff                	xor    %edi,%edi
  80155f:	e9 3c ff ff ff       	jmp    8014a0 <__udivdi3+0x40>
  801564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801568:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80156b:	31 ff                	xor    %edi,%edi
  80156d:	e9 2e ff ff ff       	jmp    8014a0 <__udivdi3+0x40>
  801572:	66 90                	xchg   %ax,%ax
  801574:	66 90                	xchg   %ax,%ax
  801576:	66 90                	xchg   %ax,%ax
  801578:	66 90                	xchg   %ax,%ax
  80157a:	66 90                	xchg   %ax,%ax
  80157c:	66 90                	xchg   %ax,%ax
  80157e:	66 90                	xchg   %ax,%ax

00801580 <__umoddi3>:
  801580:	f3 0f 1e fb          	endbr32 
  801584:	55                   	push   %ebp
  801585:	57                   	push   %edi
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	83 ec 1c             	sub    $0x1c,%esp
  80158b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80158f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801593:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  801597:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80159b:	89 f0                	mov    %esi,%eax
  80159d:	89 da                	mov    %ebx,%edx
  80159f:	85 ff                	test   %edi,%edi
  8015a1:	75 15                	jne    8015b8 <__umoddi3+0x38>
  8015a3:	39 dd                	cmp    %ebx,%ebp
  8015a5:	76 39                	jbe    8015e0 <__umoddi3+0x60>
  8015a7:	f7 f5                	div    %ebp
  8015a9:	89 d0                	mov    %edx,%eax
  8015ab:	31 d2                	xor    %edx,%edx
  8015ad:	83 c4 1c             	add    $0x1c,%esp
  8015b0:	5b                   	pop    %ebx
  8015b1:	5e                   	pop    %esi
  8015b2:	5f                   	pop    %edi
  8015b3:	5d                   	pop    %ebp
  8015b4:	c3                   	ret    
  8015b5:	8d 76 00             	lea    0x0(%esi),%esi
  8015b8:	39 df                	cmp    %ebx,%edi
  8015ba:	77 f1                	ja     8015ad <__umoddi3+0x2d>
  8015bc:	0f bd cf             	bsr    %edi,%ecx
  8015bf:	83 f1 1f             	xor    $0x1f,%ecx
  8015c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015c6:	75 40                	jne    801608 <__umoddi3+0x88>
  8015c8:	39 df                	cmp    %ebx,%edi
  8015ca:	72 04                	jb     8015d0 <__umoddi3+0x50>
  8015cc:	39 f5                	cmp    %esi,%ebp
  8015ce:	77 dd                	ja     8015ad <__umoddi3+0x2d>
  8015d0:	89 da                	mov    %ebx,%edx
  8015d2:	89 f0                	mov    %esi,%eax
  8015d4:	29 e8                	sub    %ebp,%eax
  8015d6:	19 fa                	sbb    %edi,%edx
  8015d8:	eb d3                	jmp    8015ad <__umoddi3+0x2d>
  8015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015e0:	89 e9                	mov    %ebp,%ecx
  8015e2:	85 ed                	test   %ebp,%ebp
  8015e4:	75 0b                	jne    8015f1 <__umoddi3+0x71>
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015eb:	31 d2                	xor    %edx,%edx
  8015ed:	f7 f5                	div    %ebp
  8015ef:	89 c1                	mov    %eax,%ecx
  8015f1:	89 d8                	mov    %ebx,%eax
  8015f3:	31 d2                	xor    %edx,%edx
  8015f5:	f7 f1                	div    %ecx
  8015f7:	89 f0                	mov    %esi,%eax
  8015f9:	f7 f1                	div    %ecx
  8015fb:	89 d0                	mov    %edx,%eax
  8015fd:	31 d2                	xor    %edx,%edx
  8015ff:	eb ac                	jmp    8015ad <__umoddi3+0x2d>
  801601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801608:	8b 44 24 04          	mov    0x4(%esp),%eax
  80160c:	ba 20 00 00 00       	mov    $0x20,%edx
  801611:	29 c2                	sub    %eax,%edx
  801613:	89 c1                	mov    %eax,%ecx
  801615:	89 e8                	mov    %ebp,%eax
  801617:	d3 e7                	shl    %cl,%edi
  801619:	89 d1                	mov    %edx,%ecx
  80161b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80161f:	d3 e8                	shr    %cl,%eax
  801621:	89 c1                	mov    %eax,%ecx
  801623:	8b 44 24 04          	mov    0x4(%esp),%eax
  801627:	09 f9                	or     %edi,%ecx
  801629:	89 df                	mov    %ebx,%edi
  80162b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80162f:	89 c1                	mov    %eax,%ecx
  801631:	d3 e5                	shl    %cl,%ebp
  801633:	89 d1                	mov    %edx,%ecx
  801635:	d3 ef                	shr    %cl,%edi
  801637:	89 c1                	mov    %eax,%ecx
  801639:	89 f0                	mov    %esi,%eax
  80163b:	d3 e3                	shl    %cl,%ebx
  80163d:	89 d1                	mov    %edx,%ecx
  80163f:	89 fa                	mov    %edi,%edx
  801641:	d3 e8                	shr    %cl,%eax
  801643:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801648:	09 d8                	or     %ebx,%eax
  80164a:	f7 74 24 08          	divl   0x8(%esp)
  80164e:	89 d3                	mov    %edx,%ebx
  801650:	d3 e6                	shl    %cl,%esi
  801652:	f7 e5                	mul    %ebp
  801654:	89 c7                	mov    %eax,%edi
  801656:	89 d1                	mov    %edx,%ecx
  801658:	39 d3                	cmp    %edx,%ebx
  80165a:	72 06                	jb     801662 <__umoddi3+0xe2>
  80165c:	75 0e                	jne    80166c <__umoddi3+0xec>
  80165e:	39 c6                	cmp    %eax,%esi
  801660:	73 0a                	jae    80166c <__umoddi3+0xec>
  801662:	29 e8                	sub    %ebp,%eax
  801664:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801668:	89 d1                	mov    %edx,%ecx
  80166a:	89 c7                	mov    %eax,%edi
  80166c:	89 f5                	mov    %esi,%ebp
  80166e:	8b 74 24 04          	mov    0x4(%esp),%esi
  801672:	29 fd                	sub    %edi,%ebp
  801674:	19 cb                	sbb    %ecx,%ebx
  801676:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80167b:	89 d8                	mov    %ebx,%eax
  80167d:	d3 e0                	shl    %cl,%eax
  80167f:	89 f1                	mov    %esi,%ecx
  801681:	d3 ed                	shr    %cl,%ebp
  801683:	d3 eb                	shr    %cl,%ebx
  801685:	09 e8                	or     %ebp,%eax
  801687:	89 da                	mov    %ebx,%edx
  801689:	83 c4 1c             	add    $0x1c,%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
