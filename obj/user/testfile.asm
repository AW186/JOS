
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 36 0e 00 00       	call   800e7d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 ac 14 00 00       	call   801505 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 51 14 00 00       	call   8014b9 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 f1 13 00 00       	call   80146a <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 a0 24 80 00       	mov    $0x8024a0,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 d5 24 80 00       	mov    $0x8024d5,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 f6 24 80 00       	push   $0x8024f6
  8000f4:	e8 bf 06 00 00       	call   8007b8 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	push   0x803000
  800122:	e8 1b 0d 00 00       	call   800e42 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 18 25 80 00       	push   $0x802518
  80013b:	e8 78 06 00 00       	call   8007b8 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 77 0e 00 00       	call   800fcd <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	push   0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 a4 0d 00 00       	call   800f2e <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 57 25 80 00       	push   $0x802557
  80019d:	e8 16 06 00 00       	call   8007b8 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 79 25 80 00       	push   $0x802579
  8001c2:	e8 f1 05 00 00       	call   8007b8 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 08 11 00 00       	call   8012fe <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 8d 25 80 00       	push   $0x80258d
  800223:	e8 90 05 00 00       	call   8007b8 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 a3 25 80 00       	mov    $0x8025a3,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	push   0x803000
  800251:	e8 ec 0b 00 00       	call   800e42 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	push   0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	push   0x803000
  800272:	e8 cb 0b 00 00       	call   800e42 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 d5 25 80 00       	push   $0x8025d5
  80028a:	e8 29 05 00 00       	call   8007b8 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 1e 0d 00 00       	call   800fcd <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	push   0x803000
  8002d9:	e8 64 0b 00 00       	call   800e42 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	push   0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 30 0c 00 00       	call   800f2e <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 9c 27 80 00       	push   $0x80279c
  800311:	e8 a2 04 00 00       	call   8007b8 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 a0 24 80 00       	push   $0x8024a0
  800320:	e8 95 19 00 00       	call   801cba <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 d5 24 80 00       	push   $0x8024d5
  800347:	e8 6e 19 00 00       	call   801cba <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 fc 24 80 00       	push   $0x8024fc
  80038a:	e8 29 04 00 00       	call   8007b8 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 04 26 80 00       	push   $0x802604
  80039c:	e8 19 19 00 00       	call   801cba <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 09 0c 00 00       	call   800fcd <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 03 15 00 00       	call   8018e7 <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 d7 12 00 00       	call   8016dd <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 04 26 80 00       	push   $0x802604
  800410:	e8 a5 18 00 00       	call   801cba <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 63 14 00 00       	call   8018a0 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 65 12 00 00       	call   8016dd <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 49 26 80 00 	movl   $0x802649,(%esp)
  80047f:	e8 34 03 00 00       	call   8007b8 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 ab 24 80 00       	push   $0x8024ab
  800495:	6a 20                	push   $0x20
  800497:	68 c5 24 80 00       	push   $0x8024c5
  80049c:	e8 3c 02 00 00       	call   8006dd <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 60 26 80 00       	push   $0x802660
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 c5 24 80 00       	push   $0x8024c5
  8004b0:	e8 28 02 00 00       	call   8006dd <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 de 24 80 00       	push   $0x8024de
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 c5 24 80 00       	push   $0x8024c5
  8004c2:	e8 16 02 00 00       	call   8006dd <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 84 26 80 00       	push   $0x802684
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 c5 24 80 00       	push   $0x8024c5
  8004d6:	e8 02 02 00 00       	call   8006dd <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 0a 25 80 00       	push   $0x80250a
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 c5 24 80 00       	push   $0x8024c5
  8004e8:	e8 f0 01 00 00       	call   8006dd <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	push   0x803000
  8004f6:	e8 47 09 00 00       	call   800e42 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	push   -0x34(%ebp)
  800501:	68 b4 26 80 00       	push   $0x8026b4
  800506:	6a 2d                	push   $0x2d
  800508:	68 c5 24 80 00       	push   $0x8024c5
  80050d:	e8 cb 01 00 00       	call   8006dd <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 2b 25 80 00       	push   $0x80252b
  800518:	6a 32                	push   $0x32
  80051a:	68 c5 24 80 00       	push   $0x8024c5
  80051f:	e8 b9 01 00 00       	call   8006dd <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 39 25 80 00       	push   $0x802539
  80052c:	6a 34                	push   $0x34
  80052e:	68 c5 24 80 00       	push   $0x8024c5
  800533:	e8 a5 01 00 00       	call   8006dd <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 6a 25 80 00       	push   $0x80256a
  80053e:	6a 38                	push   $0x38
  800540:	68 c5 24 80 00       	push   $0x8024c5
  800545:	e8 93 01 00 00       	call   8006dd <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 dc 26 80 00       	push   $0x8026dc
  800550:	6a 43                	push   $0x43
  800552:	68 c5 24 80 00       	push   $0x8024c5
  800557:	e8 81 01 00 00       	call   8006dd <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 ad 25 80 00       	push   $0x8025ad
  800562:	6a 48                	push   $0x48
  800564:	68 c5 24 80 00       	push   $0x8024c5
  800569:	e8 6f 01 00 00       	call   8006dd <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 c6 25 80 00       	push   $0x8025c6
  800574:	6a 4b                	push   $0x4b
  800576:	68 c5 24 80 00       	push   $0x8024c5
  80057b:	e8 5d 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 14 27 80 00       	push   $0x802714
  800586:	6a 51                	push   $0x51
  800588:	68 c5 24 80 00       	push   $0x8024c5
  80058d:	e8 4b 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 34 27 80 00       	push   $0x802734
  800598:	6a 53                	push   $0x53
  80059a:	68 c5 24 80 00       	push   $0x8024c5
  80059f:	e8 39 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 6c 27 80 00       	push   $0x80276c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 c5 24 80 00       	push   $0x8024c5
  8005b3:	e8 25 01 00 00       	call   8006dd <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 b1 24 80 00       	push   $0x8024b1
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 c5 24 80 00       	push   $0x8024c5
  8005c5:	e8 13 01 00 00       	call   8006dd <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 e9 25 80 00       	push   $0x8025e9
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 c5 24 80 00       	push   $0x8024c5
  8005d9:	e8 ff 00 00 00       	call   8006dd <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 e4 24 80 00       	push   $0x8024e4
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 c5 24 80 00       	push   $0x8024c5
  8005eb:	e8 ed 00 00 00       	call   8006dd <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 c0 27 80 00       	push   $0x8027c0
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 c5 24 80 00       	push   $0x8024c5
  8005ff:	e8 d9 00 00 00       	call   8006dd <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 09 26 80 00       	push   $0x802609
  80060a:	6a 67                	push   $0x67
  80060c:	68 c5 24 80 00       	push   $0x8024c5
  800611:	e8 c7 00 00 00       	call   8006dd <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 18 26 80 00       	push   $0x802618
  800620:	6a 6c                	push   $0x6c
  800622:	68 c5 24 80 00       	push   $0x8024c5
  800627:	e8 b1 00 00 00       	call   8006dd <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 2a 26 80 00       	push   $0x80262a
  800632:	6a 71                	push   $0x71
  800634:	68 c5 24 80 00       	push   $0x8024c5
  800639:	e8 9f 00 00 00       	call   8006dd <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 38 26 80 00       	push   $0x802638
  800648:	6a 75                	push   $0x75
  80064a:	68 c5 24 80 00       	push   $0x8024c5
  80064f:	e8 89 00 00 00       	call   8006dd <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 e8 27 80 00       	push   $0x8027e8
  800663:	6a 77                	push   $0x77
  800665:	68 c5 24 80 00       	push   $0x8024c5
  80066a:	e8 6e 00 00 00       	call   8006dd <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 14 28 80 00       	push   $0x802814
  800679:	6a 7a                	push   $0x7a
  80067b:	68 c5 24 80 00       	push   $0x8024c5
  800680:	e8 58 00 00 00       	call   8006dd <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800690:	e8 a6 0b 00 00       	call   80123b <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 00 40 80 00       	mov    %eax,0x804000

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7e 07                	jle    8006b2 <libmain+0x2d>
		binaryname = argv[0];
  8006ab:	8b 06                	mov    (%esi),%eax
  8006ad:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	53                   	push   %ebx
  8006b7:	e8 c2 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bc:	e8 0a 00 00 00       	call   8006cb <exit>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8006d1:	6a 00                	push   $0x0
  8006d3:	e8 22 0b 00 00       	call   8011fa <sys_env_destroy>
}
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006e2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006e5:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8006eb:	e8 4b 0b 00 00       	call   80123b <sys_getenvid>
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	ff 75 0c             	push   0xc(%ebp)
  8006f6:	ff 75 08             	push   0x8(%ebp)
  8006f9:	56                   	push   %esi
  8006fa:	50                   	push   %eax
  8006fb:	68 6c 28 80 00       	push   $0x80286c
  800700:	e8 b3 00 00 00       	call   8007b8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800705:	83 c4 18             	add    $0x18,%esp
  800708:	53                   	push   %ebx
  800709:	ff 75 10             	push   0x10(%ebp)
  80070c:	e8 56 00 00 00       	call   800767 <vcprintf>
	cprintf("\n");
  800711:	c7 04 24 d8 2b 80 00 	movl   $0x802bd8,(%esp)
  800718:	e8 9b 00 00 00       	call   8007b8 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800720:	cc                   	int3   
  800721:	eb fd                	jmp    800720 <_panic+0x43>

00800723 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	53                   	push   %ebx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80072d:	8b 13                	mov    (%ebx),%edx
  80072f:	8d 42 01             	lea    0x1(%edx),%eax
  800732:	89 03                	mov    %eax,(%ebx)
  800734:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800737:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80073b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800740:	74 09                	je     80074b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800742:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800749:	c9                   	leave  
  80074a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	68 ff 00 00 00       	push   $0xff
  800753:	8d 43 08             	lea    0x8(%ebx),%eax
  800756:	50                   	push   %eax
  800757:	e8 61 0a 00 00       	call   8011bd <sys_cputs>
		b->idx = 0;
  80075c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	eb db                	jmp    800742 <putch+0x1f>

00800767 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800770:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800777:	00 00 00 
	b.cnt = 0;
  80077a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800781:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800784:	ff 75 0c             	push   0xc(%ebp)
  800787:	ff 75 08             	push   0x8(%ebp)
  80078a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 23 07 80 00       	push   $0x800723
  800796:	e8 14 01 00 00       	call   8008af <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80079b:	83 c4 08             	add    $0x8,%esp
  80079e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  8007a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	e8 0d 0a 00 00       	call   8011bd <sys_cputs>

	return b.cnt;
}
  8007b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007be:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c1:	50                   	push   %eax
  8007c2:	ff 75 08             	push   0x8(%ebp)
  8007c5:	e8 9d ff ff ff       	call   800767 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	57                   	push   %edi
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 1c             	sub    $0x1c,%esp
  8007d5:	89 c7                	mov    %eax,%edi
  8007d7:	89 d6                	mov    %edx,%esi
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007df:	89 d1                	mov    %edx,%ecx
  8007e1:	89 c2                	mov    %eax,%edx
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8007fe:	72 3e                	jb     80083e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800800:	83 ec 0c             	sub    $0xc,%esp
  800803:	ff 75 18             	push   0x18(%ebp)
  800806:	83 eb 01             	sub    $0x1,%ebx
  800809:	53                   	push   %ebx
  80080a:	50                   	push   %eax
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 e4             	push   -0x1c(%ebp)
  800811:	ff 75 e0             	push   -0x20(%ebp)
  800814:	ff 75 dc             	push   -0x24(%ebp)
  800817:	ff 75 d8             	push   -0x28(%ebp)
  80081a:	e8 41 1a 00 00       	call   802260 <__udivdi3>
  80081f:	83 c4 18             	add    $0x18,%esp
  800822:	52                   	push   %edx
  800823:	50                   	push   %eax
  800824:	89 f2                	mov    %esi,%edx
  800826:	89 f8                	mov    %edi,%eax
  800828:	e8 9f ff ff ff       	call   8007cc <printnum>
  80082d:	83 c4 20             	add    $0x20,%esp
  800830:	eb 13                	jmp    800845 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	56                   	push   %esi
  800836:	ff 75 18             	push   0x18(%ebp)
  800839:	ff d7                	call   *%edi
  80083b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80083e:	83 eb 01             	sub    $0x1,%ebx
  800841:	85 db                	test   %ebx,%ebx
  800843:	7f ed                	jg     800832 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	56                   	push   %esi
  800849:	83 ec 04             	sub    $0x4,%esp
  80084c:	ff 75 e4             	push   -0x1c(%ebp)
  80084f:	ff 75 e0             	push   -0x20(%ebp)
  800852:	ff 75 dc             	push   -0x24(%ebp)
  800855:	ff 75 d8             	push   -0x28(%ebp)
  800858:	e8 23 1b 00 00       	call   802380 <__umoddi3>
  80085d:	83 c4 14             	add    $0x14,%esp
  800860:	0f be 80 8f 28 80 00 	movsbl 0x80288f(%eax),%eax
  800867:	50                   	push   %eax
  800868:	ff d7                	call   *%edi
}
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800870:	5b                   	pop    %ebx
  800871:	5e                   	pop    %esi
  800872:	5f                   	pop    %edi
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80087b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	3b 50 04             	cmp    0x4(%eax),%edx
  800884:	73 0a                	jae    800890 <sprintputch+0x1b>
		*b->buf++ = ch;
  800886:	8d 4a 01             	lea    0x1(%edx),%ecx
  800889:	89 08                	mov    %ecx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	88 02                	mov    %al,(%edx)
}
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <printfmt>:
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800898:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80089b:	50                   	push   %eax
  80089c:	ff 75 10             	push   0x10(%ebp)
  80089f:	ff 75 0c             	push   0xc(%ebp)
  8008a2:	ff 75 08             	push   0x8(%ebp)
  8008a5:	e8 05 00 00 00       	call   8008af <vprintfmt>
}
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <vprintfmt>:
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	57                   	push   %edi
  8008b3:	56                   	push   %esi
  8008b4:	53                   	push   %ebx
  8008b5:	83 ec 3c             	sub    $0x3c,%esp
  8008b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008c1:	eb 0a                	jmp    8008cd <vprintfmt+0x1e>
			putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	50                   	push   %eax
  8008c8:	ff d6                	call   *%esi
  8008ca:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cd:	83 c7 01             	add    $0x1,%edi
  8008d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d4:	83 f8 25             	cmp    $0x25,%eax
  8008d7:	74 0c                	je     8008e5 <vprintfmt+0x36>
			if (ch == '\0')
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	75 e6                	jne    8008c3 <vprintfmt+0x14>
}
  8008dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5f                   	pop    %edi
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    
		padc = ' ';
  8008e5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8008e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8008f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
  8008f7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8008fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800903:	8d 47 01             	lea    0x1(%edi),%eax
  800906:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800909:	0f b6 17             	movzbl (%edi),%edx
  80090c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80090f:	3c 55                	cmp    $0x55,%al
  800911:	0f 87 a6 04 00 00    	ja     800dbd <vprintfmt+0x50e>
  800917:	0f b6 c0             	movzbl %al,%eax
  80091a:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
  800921:	8b 7d dc             	mov    -0x24(%ebp),%edi
			padc = '-';
  800924:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800928:	eb d9                	jmp    800903 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80092d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800931:	eb d0                	jmp    800903 <vprintfmt+0x54>
  800933:	0f b6 d2             	movzbl %dl,%edx
  800936:	8b 7d dc             	mov    -0x24(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800939:	b8 00 00 00 00       	mov    $0x0,%eax
  80093e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800941:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800944:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800948:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80094b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80094e:	83 f9 09             	cmp    $0x9,%ecx
  800951:	77 55                	ja     8009a8 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800953:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800956:	eb e9                	jmp    800941 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 40 04             	lea    0x4(%eax),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800969:	8b 7d dc             	mov    -0x24(%ebp),%edi
			if (width < 0)
  80096c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800970:	79 91                	jns    800903 <vprintfmt+0x54>
				width = precision, precision = -1;
  800972:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800975:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800978:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80097f:	eb 82                	jmp    800903 <vprintfmt+0x54>
  800981:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	0f 49 c2             	cmovns %edx,%eax
  80098e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800991:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  800994:	e9 6a ff ff ff       	jmp    800903 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800999:	8b 7d dc             	mov    -0x24(%ebp),%edi
			altflag = 1;
  80099c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8009a3:	e9 5b ff ff ff       	jmp    800903 <vprintfmt+0x54>
  8009a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009ae:	eb bc                	jmp    80096c <vprintfmt+0xbd>
			lflag++;
  8009b0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009b3:	8b 7d dc             	mov    -0x24(%ebp),%edi
			goto reswitch;
  8009b6:	e9 48 ff ff ff       	jmp    800903 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 78 04             	lea    0x4(%eax),%edi
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	53                   	push   %ebx
  8009c5:	ff 30                	push   (%eax)
  8009c7:	ff d6                	call   *%esi
			break;
  8009c9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009cc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009cf:	e9 88 03 00 00       	jmp    800d5c <vprintfmt+0x4ad>
			err = va_arg(ap, int);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8d 78 04             	lea    0x4(%eax),%edi
  8009da:	8b 10                	mov    (%eax),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	f7 d8                	neg    %eax
  8009e0:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009e3:	83 f8 0f             	cmp    $0xf,%eax
  8009e6:	7f 23                	jg     800a0b <vprintfmt+0x15c>
  8009e8:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  8009ef:	85 d2                	test   %edx,%edx
  8009f1:	74 18                	je     800a0b <vprintfmt+0x15c>
				printfmt(putch, putdat, "%s", p);
  8009f3:	52                   	push   %edx
  8009f4:	68 89 2c 80 00       	push   $0x802c89
  8009f9:	53                   	push   %ebx
  8009fa:	56                   	push   %esi
  8009fb:	e8 92 fe ff ff       	call   800892 <printfmt>
  800a00:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a03:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a06:	e9 51 03 00 00       	jmp    800d5c <vprintfmt+0x4ad>
				printfmt(putch, putdat, "error %d", err);
  800a0b:	50                   	push   %eax
  800a0c:	68 a7 28 80 00       	push   $0x8028a7
  800a11:	53                   	push   %ebx
  800a12:	56                   	push   %esi
  800a13:	e8 7a fe ff ff       	call   800892 <printfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a1b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a1e:	e9 39 03 00 00       	jmp    800d5c <vprintfmt+0x4ad>
			if ((p = va_arg(ap, char *)) == NULL)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 c0 04             	add    $0x4,%eax
  800a29:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a31:	85 d2                	test   %edx,%edx
  800a33:	b8 a0 28 80 00       	mov    $0x8028a0,%eax
  800a38:	0f 45 c2             	cmovne %edx,%eax
  800a3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a3e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a42:	7e 06                	jle    800a4a <vprintfmt+0x19b>
  800a44:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a48:	75 0d                	jne    800a57 <vprintfmt+0x1a8>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a4d:	89 c7                	mov    %eax,%edi
  800a4f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800a52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a55:	eb 55                	jmp    800aac <vprintfmt+0x1fd>
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 e0             	push   -0x20(%ebp)
  800a5d:	ff 75 cc             	push   -0x34(%ebp)
  800a60:	e8 f5 03 00 00       	call   800e5a <strnlen>
  800a65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800a72:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a79:	eb 0f                	jmp    800a8a <vprintfmt+0x1db>
					putch(padc, putdat);
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	53                   	push   %ebx
  800a7f:	ff 75 d4             	push   -0x2c(%ebp)
  800a82:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a84:	83 ef 01             	sub    $0x1,%edi
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	85 ff                	test   %edi,%edi
  800a8c:	7f ed                	jg     800a7b <vprintfmt+0x1cc>
  800a8e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a91:	85 d2                	test   %edx,%edx
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	0f 49 c2             	cmovns %edx,%eax
  800a9b:	29 c2                	sub    %eax,%edx
  800a9d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800aa0:	eb a8                	jmp    800a4a <vprintfmt+0x19b>
					putch(ch, putdat);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	53                   	push   %ebx
  800aa6:	52                   	push   %edx
  800aa7:	ff d6                	call   *%esi
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800aaf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab1:	83 c7 01             	add    $0x1,%edi
  800ab4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab8:	0f be d0             	movsbl %al,%edx
  800abb:	85 d2                	test   %edx,%edx
  800abd:	74 4b                	je     800b0a <vprintfmt+0x25b>
  800abf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac3:	78 06                	js     800acb <vprintfmt+0x21c>
  800ac5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800ac9:	78 1e                	js     800ae9 <vprintfmt+0x23a>
				if (altflag && (ch < ' ' || ch > '~'))
  800acb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800acf:	74 d1                	je     800aa2 <vprintfmt+0x1f3>
  800ad1:	0f be c0             	movsbl %al,%eax
  800ad4:	83 e8 20             	sub    $0x20,%eax
  800ad7:	83 f8 5e             	cmp    $0x5e,%eax
  800ada:	76 c6                	jbe    800aa2 <vprintfmt+0x1f3>
					putch('?', putdat);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	53                   	push   %ebx
  800ae0:	6a 3f                	push   $0x3f
  800ae2:	ff d6                	call   *%esi
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	eb c3                	jmp    800aac <vprintfmt+0x1fd>
  800ae9:	89 cf                	mov    %ecx,%edi
  800aeb:	eb 0e                	jmp    800afb <vprintfmt+0x24c>
				putch(' ', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	53                   	push   %ebx
  800af1:	6a 20                	push   $0x20
  800af3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800af5:	83 ef 01             	sub    $0x1,%edi
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	85 ff                	test   %edi,%edi
  800afd:	7f ee                	jg     800aed <vprintfmt+0x23e>
			if ((p = va_arg(ap, char *)) == NULL)
  800aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b02:	89 45 14             	mov    %eax,0x14(%ebp)
  800b05:	e9 52 02 00 00       	jmp    800d5c <vprintfmt+0x4ad>
  800b0a:	89 cf                	mov    %ecx,%edi
  800b0c:	eb ed                	jmp    800afb <vprintfmt+0x24c>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	83 c0 04             	add    $0x4,%eax
  800b14:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b17:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800b1c:	85 d2                	test   %edx,%edx
  800b1e:	b8 a0 28 80 00       	mov    $0x8028a0,%eax
  800b23:	0f 45 c2             	cmovne %edx,%eax
  800b26:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800b29:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b2d:	7e 06                	jle    800b35 <vprintfmt+0x286>
  800b2f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800b33:	75 0d                	jne    800b42 <vprintfmt+0x293>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b38:	89 c7                	mov    %eax,%edi
  800b3a:	03 45 d4             	add    -0x2c(%ebp),%eax
  800b3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b40:	eb 55                	jmp    800b97 <vprintfmt+0x2e8>
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 e0             	push   -0x20(%ebp)
  800b48:	ff 75 cc             	push   -0x34(%ebp)
  800b4b:	e8 0a 03 00 00       	call   800e5a <strnlen>
  800b50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b53:	29 c2                	sub    %eax,%edx
  800b55:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800b58:	83 c4 10             	add    $0x10,%esp
  800b5b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800b5d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800b61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	eb 0f                	jmp    800b75 <vprintfmt+0x2c6>
					putch(padc, putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	53                   	push   %ebx
  800b6a:	ff 75 d4             	push   -0x2c(%ebp)
  800b6d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6f:	83 ef 01             	sub    $0x1,%edi
  800b72:	83 c4 10             	add    $0x10,%esp
  800b75:	85 ff                	test   %edi,%edi
  800b77:	7f ed                	jg     800b66 <vprintfmt+0x2b7>
  800b79:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b7c:	85 d2                	test   %edx,%edx
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	0f 49 c2             	cmovns %edx,%eax
  800b86:	29 c2                	sub    %eax,%edx
  800b88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b8b:	eb a8                	jmp    800b35 <vprintfmt+0x286>
					putch(ch, putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	53                   	push   %ebx
  800b91:	52                   	push   %edx
  800b92:	ff d6                	call   *%esi
  800b94:	83 c4 10             	add    $0x10,%esp
  800b97:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800b9a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != ':' && (precision < 0 || --precision >= 0); width--)
  800b9c:	83 c7 01             	add    $0x1,%edi
  800b9f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ba3:	0f be d0             	movsbl %al,%edx
  800ba6:	3c 3a                	cmp    $0x3a,%al
  800ba8:	74 4b                	je     800bf5 <vprintfmt+0x346>
  800baa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bae:	78 06                	js     800bb6 <vprintfmt+0x307>
  800bb0:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800bb4:	78 1e                	js     800bd4 <vprintfmt+0x325>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800bba:	74 d1                	je     800b8d <vprintfmt+0x2de>
  800bbc:	0f be c0             	movsbl %al,%eax
  800bbf:	83 e8 20             	sub    $0x20,%eax
  800bc2:	83 f8 5e             	cmp    $0x5e,%eax
  800bc5:	76 c6                	jbe    800b8d <vprintfmt+0x2de>
					putch('?', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	53                   	push   %ebx
  800bcb:	6a 3f                	push   $0x3f
  800bcd:	ff d6                	call   *%esi
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	eb c3                	jmp    800b97 <vprintfmt+0x2e8>
  800bd4:	89 cf                	mov    %ecx,%edi
  800bd6:	eb 0e                	jmp    800be6 <vprintfmt+0x337>
				putch(' ', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	53                   	push   %ebx
  800bdc:	6a 20                	push   $0x20
  800bde:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800be0:	83 ef 01             	sub    $0x1,%edi
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	85 ff                	test   %edi,%edi
  800be8:	7f ee                	jg     800bd8 <vprintfmt+0x329>
			if ((p = va_arg(ap, char *)) == NULL)
  800bea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf0:	e9 67 01 00 00       	jmp    800d5c <vprintfmt+0x4ad>
  800bf5:	89 cf                	mov    %ecx,%edi
  800bf7:	eb ed                	jmp    800be6 <vprintfmt+0x337>
	if (lflag >= 2)
  800bf9:	83 f9 01             	cmp    $0x1,%ecx
  800bfc:	7f 1b                	jg     800c19 <vprintfmt+0x36a>
	else if (lflag)
  800bfe:	85 c9                	test   %ecx,%ecx
  800c00:	74 63                	je     800c65 <vprintfmt+0x3b6>
		return va_arg(*ap, long);
  800c02:	8b 45 14             	mov    0x14(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c0a:	99                   	cltd   
  800c0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c11:	8d 40 04             	lea    0x4(%eax),%eax
  800c14:	89 45 14             	mov    %eax,0x14(%ebp)
  800c17:	eb 17                	jmp    800c30 <vprintfmt+0x381>
		return va_arg(*ap, long long);
  800c19:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1c:	8b 50 04             	mov    0x4(%eax),%edx
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	8d 40 08             	lea    0x8(%eax),%eax
  800c2d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800c30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c33:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
  800c36:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800c3b:	85 c9                	test   %ecx,%ecx
  800c3d:	0f 89 ff 00 00 00    	jns    800d42 <vprintfmt+0x493>
				putch('-', putdat);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	53                   	push   %ebx
  800c47:	6a 2d                	push   $0x2d
  800c49:	ff d6                	call   *%esi
				num = -(long long) num;
  800c4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800c51:	f7 da                	neg    %edx
  800c53:	83 d1 00             	adc    $0x0,%ecx
  800c56:	f7 d9                	neg    %ecx
  800c58:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c5b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c60:	e9 dd 00 00 00       	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, int);
  800c65:	8b 45 14             	mov    0x14(%ebp),%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c6d:	99                   	cltd   
  800c6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c71:	8b 45 14             	mov    0x14(%ebp),%eax
  800c74:	8d 40 04             	lea    0x4(%eax),%eax
  800c77:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7a:	eb b4                	jmp    800c30 <vprintfmt+0x381>
	if (lflag >= 2)
  800c7c:	83 f9 01             	cmp    $0x1,%ecx
  800c7f:	7f 1e                	jg     800c9f <vprintfmt+0x3f0>
	else if (lflag)
  800c81:	85 c9                	test   %ecx,%ecx
  800c83:	74 32                	je     800cb7 <vprintfmt+0x408>
		return va_arg(*ap, unsigned long);
  800c85:	8b 45 14             	mov    0x14(%ebp),%eax
  800c88:	8b 10                	mov    (%eax),%edx
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	8d 40 04             	lea    0x4(%eax),%eax
  800c92:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c95:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long);
  800c9a:	e9 a3 00 00 00       	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	8b 10                	mov    (%eax),%edx
  800ca4:	8b 48 04             	mov    0x4(%eax),%ecx
  800ca7:	8d 40 08             	lea    0x8(%eax),%eax
  800caa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cad:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned long long);
  800cb2:	e9 8b 00 00 00       	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	8b 10                	mov    (%eax),%edx
  800cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc1:	8d 40 04             	lea    0x4(%eax),%eax
  800cc4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cc7:	bf 0a 00 00 00       	mov    $0xa,%edi
		return va_arg(*ap, unsigned int);
  800ccc:	eb 74                	jmp    800d42 <vprintfmt+0x493>
	if (lflag >= 2)
  800cce:	83 f9 01             	cmp    $0x1,%ecx
  800cd1:	7f 1b                	jg     800cee <vprintfmt+0x43f>
	else if (lflag)
  800cd3:	85 c9                	test   %ecx,%ecx
  800cd5:	74 2c                	je     800d03 <vprintfmt+0x454>
		return va_arg(*ap, unsigned long);
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	8b 10                	mov    (%eax),%edx
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	8d 40 04             	lea    0x4(%eax),%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ce7:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long);
  800cec:	eb 54                	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800cee:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf1:	8b 10                	mov    (%eax),%edx
  800cf3:	8b 48 04             	mov    0x4(%eax),%ecx
  800cf6:	8d 40 08             	lea    0x8(%eax),%eax
  800cf9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cfc:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned long long);
  800d01:	eb 3f                	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	8b 10                	mov    (%eax),%edx
  800d08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0d:	8d 40 04             	lea    0x4(%eax),%eax
  800d10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d13:	bf 08 00 00 00       	mov    $0x8,%edi
		return va_arg(*ap, unsigned int);
  800d18:	eb 28                	jmp    800d42 <vprintfmt+0x493>
			putch('0', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	53                   	push   %ebx
  800d1e:	6a 30                	push   $0x30
  800d20:	ff d6                	call   *%esi
			putch('x', putdat);
  800d22:	83 c4 08             	add    $0x8,%esp
  800d25:	53                   	push   %ebx
  800d26:	6a 78                	push   $0x78
  800d28:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2d:	8b 10                	mov    (%eax),%edx
  800d2f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800d34:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d37:	8d 40 04             	lea    0x4(%eax),%eax
  800d3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d3d:	bf 10 00 00 00       	mov    $0x10,%edi
			printnum(putch, putdat, num, base, width, padc);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800d49:	50                   	push   %eax
  800d4a:	ff 75 d4             	push   -0x2c(%ebp)
  800d4d:	57                   	push   %edi
  800d4e:	51                   	push   %ecx
  800d4f:	52                   	push   %edx
  800d50:	89 da                	mov    %ebx,%edx
  800d52:	89 f0                	mov    %esi,%eax
  800d54:	e8 73 fa ff ff       	call   8007cc <printnum>
			break;
  800d59:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d5c:	8b 7d dc             	mov    -0x24(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5f:	e9 69 fb ff ff       	jmp    8008cd <vprintfmt+0x1e>
	if (lflag >= 2)
  800d64:	83 f9 01             	cmp    $0x1,%ecx
  800d67:	7f 1b                	jg     800d84 <vprintfmt+0x4d5>
	else if (lflag)
  800d69:	85 c9                	test   %ecx,%ecx
  800d6b:	74 2c                	je     800d99 <vprintfmt+0x4ea>
		return va_arg(*ap, unsigned long);
  800d6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d70:	8b 10                	mov    (%eax),%edx
  800d72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d77:	8d 40 04             	lea    0x4(%eax),%eax
  800d7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d7d:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long);
  800d82:	eb be                	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned long long);
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	8b 10                	mov    (%eax),%edx
  800d89:	8b 48 04             	mov    0x4(%eax),%ecx
  800d8c:	8d 40 08             	lea    0x8(%eax),%eax
  800d8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d92:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned long long);
  800d97:	eb a9                	jmp    800d42 <vprintfmt+0x493>
		return va_arg(*ap, unsigned int);
  800d99:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9c:	8b 10                	mov    (%eax),%edx
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	8d 40 04             	lea    0x4(%eax),%eax
  800da6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800da9:	bf 10 00 00 00       	mov    $0x10,%edi
		return va_arg(*ap, unsigned int);
  800dae:	eb 92                	jmp    800d42 <vprintfmt+0x493>
			putch(ch, putdat);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	53                   	push   %ebx
  800db4:	6a 25                	push   $0x25
  800db6:	ff d6                	call   *%esi
			break;
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	eb 9f                	jmp    800d5c <vprintfmt+0x4ad>
			putch('%', putdat);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	53                   	push   %ebx
  800dc1:	6a 25                	push   $0x25
  800dc3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	89 f8                	mov    %edi,%eax
  800dca:	eb 03                	jmp    800dcf <vprintfmt+0x520>
  800dcc:	83 e8 01             	sub    $0x1,%eax
  800dcf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800dd3:	75 f7                	jne    800dcc <vprintfmt+0x51d>
  800dd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dd8:	eb 82                	jmp    800d5c <vprintfmt+0x4ad>

00800dda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 18             	sub    $0x18,%esp
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800de9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ded:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800df0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	74 26                	je     800e21 <vsnprintf+0x47>
  800dfb:	85 d2                	test   %edx,%edx
  800dfd:	7e 22                	jle    800e21 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dff:	ff 75 14             	push   0x14(%ebp)
  800e02:	ff 75 10             	push   0x10(%ebp)
  800e05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	68 75 08 80 00       	push   $0x800875
  800e0e:	e8 9c fa ff ff       	call   8008af <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    
		return -E_INVAL;
  800e21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e26:	eb f7                	jmp    800e1f <vsnprintf+0x45>

00800e28 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e2e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e31:	50                   	push   %eax
  800e32:	ff 75 10             	push   0x10(%ebp)
  800e35:	ff 75 0c             	push   0xc(%ebp)
  800e38:	ff 75 08             	push   0x8(%ebp)
  800e3b:	e8 9a ff ff ff       	call   800dda <vsnprintf>
	va_end(ap);

	return rc;
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 03                	jmp    800e52 <strlen+0x10>
		n++;
  800e4f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800e52:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e56:	75 f7                	jne    800e4f <strlen+0xd>
	return n;
}
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e60:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
  800e68:	eb 03                	jmp    800e6d <strnlen+0x13>
		n++;
  800e6a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	39 d0                	cmp    %edx,%eax
  800e6f:	74 08                	je     800e79 <strnlen+0x1f>
  800e71:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800e75:	75 f3                	jne    800e6a <strnlen+0x10>
  800e77:	89 c2                	mov    %eax,%edx
	return n;
}
  800e79:	89 d0                	mov    %edx,%eax
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	53                   	push   %ebx
  800e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800e90:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800e93:	83 c0 01             	add    $0x1,%eax
  800e96:	84 d2                	test   %dl,%dl
  800e98:	75 f2                	jne    800e8c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e9a:	89 c8                	mov    %ecx,%eax
  800e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 10             	sub    $0x10,%esp
  800ea8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800eab:	53                   	push   %ebx
  800eac:	e8 91 ff ff ff       	call   800e42 <strlen>
  800eb1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800eb4:	ff 75 0c             	push   0xc(%ebp)
  800eb7:	01 d8                	add    %ebx,%eax
  800eb9:	50                   	push   %eax
  800eba:	e8 be ff ff ff       	call   800e7d <strcpy>
	return dst;
}
  800ebf:	89 d8                	mov    %ebx,%eax
  800ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
  800ecb:	8b 75 08             	mov    0x8(%ebp),%esi
  800ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed1:	89 f3                	mov    %esi,%ebx
  800ed3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	89 f0                	mov    %esi,%eax
  800ed8:	eb 0f                	jmp    800ee9 <strncpy+0x23>
		*dst++ = *src;
  800eda:	83 c0 01             	add    $0x1,%eax
  800edd:	0f b6 0a             	movzbl (%edx),%ecx
  800ee0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ee3:	80 f9 01             	cmp    $0x1,%cl
  800ee6:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800ee9:	39 d8                	cmp    %ebx,%eax
  800eeb:	75 ed                	jne    800eda <strncpy+0x14>
	}
	return ret;
}
  800eed:	89 f0                	mov    %esi,%eax
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	8b 75 08             	mov    0x8(%ebp),%esi
  800efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efe:	8b 55 10             	mov    0x10(%ebp),%edx
  800f01:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f03:	85 d2                	test   %edx,%edx
  800f05:	74 21                	je     800f28 <strlcpy+0x35>
  800f07:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f0b:	89 f2                	mov    %esi,%edx
  800f0d:	eb 09                	jmp    800f18 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f0f:	83 c1 01             	add    $0x1,%ecx
  800f12:	83 c2 01             	add    $0x1,%edx
  800f15:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800f18:	39 c2                	cmp    %eax,%edx
  800f1a:	74 09                	je     800f25 <strlcpy+0x32>
  800f1c:	0f b6 19             	movzbl (%ecx),%ebx
  800f1f:	84 db                	test   %bl,%bl
  800f21:	75 ec                	jne    800f0f <strlcpy+0x1c>
  800f23:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	29 f0                	sub    %esi,%eax
}
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f34:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0x11>
		p++, q++;
  800f39:	83 c1 01             	add    $0x1,%ecx
  800f3c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800f3f:	0f b6 01             	movzbl (%ecx),%eax
  800f42:	84 c0                	test   %al,%al
  800f44:	74 04                	je     800f4a <strcmp+0x1c>
  800f46:	3a 02                	cmp    (%edx),%al
  800f48:	74 ef                	je     800f39 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	0f b6 12             	movzbl (%edx),%edx
  800f50:	29 d0                	sub    %edx,%eax
}
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	53                   	push   %ebx
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	89 c3                	mov    %eax,%ebx
  800f60:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f63:	eb 06                	jmp    800f6b <strncmp+0x17>
		n--, p++, q++;
  800f65:	83 c0 01             	add    $0x1,%eax
  800f68:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f6b:	39 d8                	cmp    %ebx,%eax
  800f6d:	74 18                	je     800f87 <strncmp+0x33>
  800f6f:	0f b6 08             	movzbl (%eax),%ecx
  800f72:	84 c9                	test   %cl,%cl
  800f74:	74 04                	je     800f7a <strncmp+0x26>
  800f76:	3a 0a                	cmp    (%edx),%cl
  800f78:	74 eb                	je     800f65 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7a:	0f b6 00             	movzbl (%eax),%eax
  800f7d:	0f b6 12             	movzbl (%edx),%edx
  800f80:	29 d0                	sub    %edx,%eax
}
  800f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    
		return 0;
  800f87:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8c:	eb f4                	jmp    800f82 <strncmp+0x2e>

00800f8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f98:	eb 03                	jmp    800f9d <strchr+0xf>
  800f9a:	83 c0 01             	add    $0x1,%eax
  800f9d:	0f b6 10             	movzbl (%eax),%edx
  800fa0:	84 d2                	test   %dl,%dl
  800fa2:	74 06                	je     800faa <strchr+0x1c>
		if (*s == c)
  800fa4:	38 ca                	cmp    %cl,%dl
  800fa6:	75 f2                	jne    800f9a <strchr+0xc>
  800fa8:	eb 05                	jmp    800faf <strchr+0x21>
			return (char *) s;
	return 0;
  800faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fbb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800fbe:	38 ca                	cmp    %cl,%dl
  800fc0:	74 09                	je     800fcb <strfind+0x1a>
  800fc2:	84 d2                	test   %dl,%dl
  800fc4:	74 05                	je     800fcb <strfind+0x1a>
	for (; *s; s++)
  800fc6:	83 c0 01             	add    $0x1,%eax
  800fc9:	eb f0                	jmp    800fbb <strfind+0xa>
			break;
	return (char *) s;
}
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800fd9:	85 c9                	test   %ecx,%ecx
  800fdb:	74 2f                	je     80100c <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fdd:	89 f8                	mov    %edi,%eax
  800fdf:	09 c8                	or     %ecx,%eax
  800fe1:	a8 03                	test   $0x3,%al
  800fe3:	75 21                	jne    801006 <memset+0x39>
		c &= 0xFF;
  800fe5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	c1 e0 08             	shl    $0x8,%eax
  800fee:	89 d3                	mov    %edx,%ebx
  800ff0:	c1 e3 18             	shl    $0x18,%ebx
  800ff3:	89 d6                	mov    %edx,%esi
  800ff5:	c1 e6 10             	shl    $0x10,%esi
  800ff8:	09 f3                	or     %esi,%ebx
  800ffa:	09 da                	or     %ebx,%edx
  800ffc:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ffe:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801001:	fc                   	cld    
  801002:	f3 ab                	rep stos %eax,%es:(%edi)
  801004:	eb 06                	jmp    80100c <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	fc                   	cld    
  80100a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80100c:	89 f8                	mov    %edi,%eax
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80101e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801021:	39 c6                	cmp    %eax,%esi
  801023:	73 32                	jae    801057 <memmove+0x44>
  801025:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801028:	39 c2                	cmp    %eax,%edx
  80102a:	76 2b                	jbe    801057 <memmove+0x44>
		s += n;
		d += n;
  80102c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80102f:	89 d6                	mov    %edx,%esi
  801031:	09 fe                	or     %edi,%esi
  801033:	09 ce                	or     %ecx,%esi
  801035:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80103b:	75 0e                	jne    80104b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80103d:	83 ef 04             	sub    $0x4,%edi
  801040:	8d 72 fc             	lea    -0x4(%edx),%esi
  801043:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801046:	fd                   	std    
  801047:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801049:	eb 09                	jmp    801054 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80104b:	83 ef 01             	sub    $0x1,%edi
  80104e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801051:	fd                   	std    
  801052:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801054:	fc                   	cld    
  801055:	eb 1a                	jmp    801071 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801057:	89 f2                	mov    %esi,%edx
  801059:	09 c2                	or     %eax,%edx
  80105b:	09 ca                	or     %ecx,%edx
  80105d:	f6 c2 03             	test   $0x3,%dl
  801060:	75 0a                	jne    80106c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801062:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801065:	89 c7                	mov    %eax,%edi
  801067:	fc                   	cld    
  801068:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80106a:	eb 05                	jmp    801071 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80106c:	89 c7                	mov    %eax,%edi
  80106e:	fc                   	cld    
  80106f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801071:	5e                   	pop    %esi
  801072:	5f                   	pop    %edi
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80107b:	ff 75 10             	push   0x10(%ebp)
  80107e:	ff 75 0c             	push   0xc(%ebp)
  801081:	ff 75 08             	push   0x8(%ebp)
  801084:	e8 8a ff ff ff       	call   801013 <memmove>
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8b 55 0c             	mov    0xc(%ebp),%edx
  801096:	89 c6                	mov    %eax,%esi
  801098:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80109b:	eb 06                	jmp    8010a3 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80109d:	83 c0 01             	add    $0x1,%eax
  8010a0:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  8010a3:	39 f0                	cmp    %esi,%eax
  8010a5:	74 14                	je     8010bb <memcmp+0x30>
		if (*s1 != *s2)
  8010a7:	0f b6 08             	movzbl (%eax),%ecx
  8010aa:	0f b6 1a             	movzbl (%edx),%ebx
  8010ad:	38 d9                	cmp    %bl,%cl
  8010af:	74 ec                	je     80109d <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  8010b1:	0f b6 c1             	movzbl %cl,%eax
  8010b4:	0f b6 db             	movzbl %bl,%ebx
  8010b7:	29 d8                	sub    %ebx,%eax
  8010b9:	eb 05                	jmp    8010c0 <memcmp+0x35>
	}

	return 0;
  8010bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010cd:	89 c2                	mov    %eax,%edx
  8010cf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010d2:	eb 03                	jmp    8010d7 <memfind+0x13>
  8010d4:	83 c0 01             	add    $0x1,%eax
  8010d7:	39 d0                	cmp    %edx,%eax
  8010d9:	73 04                	jae    8010df <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010db:	38 08                	cmp    %cl,(%eax)
  8010dd:	75 f5                	jne    8010d4 <memfind+0x10>
			break;
	return (void *) s;
}
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ed:	eb 03                	jmp    8010f2 <strtol+0x11>
		s++;
  8010ef:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  8010f2:	0f b6 02             	movzbl (%edx),%eax
  8010f5:	3c 20                	cmp    $0x20,%al
  8010f7:	74 f6                	je     8010ef <strtol+0xe>
  8010f9:	3c 09                	cmp    $0x9,%al
  8010fb:	74 f2                	je     8010ef <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8010fd:	3c 2b                	cmp    $0x2b,%al
  8010ff:	74 2a                	je     80112b <strtol+0x4a>
	int neg = 0;
  801101:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801106:	3c 2d                	cmp    $0x2d,%al
  801108:	74 2b                	je     801135 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80110a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801110:	75 0f                	jne    801121 <strtol+0x40>
  801112:	80 3a 30             	cmpb   $0x30,(%edx)
  801115:	74 28                	je     80113f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801117:	85 db                	test   %ebx,%ebx
  801119:	b8 0a 00 00 00       	mov    $0xa,%eax
  80111e:	0f 44 d8             	cmove  %eax,%ebx
  801121:	b9 00 00 00 00       	mov    $0x0,%ecx
  801126:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801129:	eb 46                	jmp    801171 <strtol+0x90>
		s++;
  80112b:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  80112e:	bf 00 00 00 00       	mov    $0x0,%edi
  801133:	eb d5                	jmp    80110a <strtol+0x29>
		s++, neg = 1;
  801135:	83 c2 01             	add    $0x1,%edx
  801138:	bf 01 00 00 00       	mov    $0x1,%edi
  80113d:	eb cb                	jmp    80110a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80113f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801143:	74 0e                	je     801153 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801145:	85 db                	test   %ebx,%ebx
  801147:	75 d8                	jne    801121 <strtol+0x40>
		s++, base = 8;
  801149:	83 c2 01             	add    $0x1,%edx
  80114c:	bb 08 00 00 00       	mov    $0x8,%ebx
  801151:	eb ce                	jmp    801121 <strtol+0x40>
		s += 2, base = 16;
  801153:	83 c2 02             	add    $0x2,%edx
  801156:	bb 10 00 00 00       	mov    $0x10,%ebx
  80115b:	eb c4                	jmp    801121 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80115d:	0f be c0             	movsbl %al,%eax
  801160:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801163:	3b 45 10             	cmp    0x10(%ebp),%eax
  801166:	7d 3a                	jge    8011a2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801168:	83 c2 01             	add    $0x1,%edx
  80116b:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  80116f:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  801171:	0f b6 02             	movzbl (%edx),%eax
  801174:	8d 70 d0             	lea    -0x30(%eax),%esi
  801177:	89 f3                	mov    %esi,%ebx
  801179:	80 fb 09             	cmp    $0x9,%bl
  80117c:	76 df                	jbe    80115d <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  80117e:	8d 70 9f             	lea    -0x61(%eax),%esi
  801181:	89 f3                	mov    %esi,%ebx
  801183:	80 fb 19             	cmp    $0x19,%bl
  801186:	77 08                	ja     801190 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801188:	0f be c0             	movsbl %al,%eax
  80118b:	83 e8 57             	sub    $0x57,%eax
  80118e:	eb d3                	jmp    801163 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  801190:	8d 70 bf             	lea    -0x41(%eax),%esi
  801193:	89 f3                	mov    %esi,%ebx
  801195:	80 fb 19             	cmp    $0x19,%bl
  801198:	77 08                	ja     8011a2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80119a:	0f be c0             	movsbl %al,%eax
  80119d:	83 e8 37             	sub    $0x37,%eax
  8011a0:	eb c1                	jmp    801163 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a6:	74 05                	je     8011ad <strtol+0xcc>
		*endptr = (char *) s;
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ad:	89 c8                	mov    %ecx,%eax
  8011af:	f7 d8                	neg    %eax
  8011b1:	85 ff                	test   %edi,%edi
  8011b3:	0f 45 c8             	cmovne %eax,%ecx
}
  8011b6:	89 c8                	mov    %ecx,%eax
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ce:	89 c3                	mov    %eax,%ebx
  8011d0:	89 c7                	mov    %eax,%edi
  8011d2:	89 c6                	mov    %eax,%esi
  8011d4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <sys_cgetc>:

int
sys_cgetc(void)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8011eb:	89 d1                	mov    %edx,%ecx
  8011ed:	89 d3                	mov    %edx,%ebx
  8011ef:	89 d7                	mov    %edx,%edi
  8011f1:	89 d6                	mov    %edx,%esi
  8011f3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801203:	b9 00 00 00 00       	mov    $0x0,%ecx
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
  80120b:	b8 03 00 00 00       	mov    $0x3,%eax
  801210:	89 cb                	mov    %ecx,%ebx
  801212:	89 cf                	mov    %ecx,%edi
  801214:	89 ce                	mov    %ecx,%esi
  801216:	cd 30                	int    $0x30
	if(check && ret > 0)
  801218:	85 c0                	test   %eax,%eax
  80121a:	7f 08                	jg     801224 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	50                   	push   %eax
  801228:	6a 03                	push   $0x3
  80122a:	68 9f 2b 80 00       	push   $0x802b9f
  80122f:	6a 23                	push   $0x23
  801231:	68 bc 2b 80 00       	push   $0x802bbc
  801236:	e8 a2 f4 ff ff       	call   8006dd <_panic>

0080123b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
	asm volatile("int %1\n"
  801241:	ba 00 00 00 00       	mov    $0x0,%edx
  801246:	b8 02 00 00 00       	mov    $0x2,%eax
  80124b:	89 d1                	mov    %edx,%ecx
  80124d:	89 d3                	mov    %edx,%ebx
  80124f:	89 d7                	mov    %edx,%edi
  801251:	89 d6                	mov    %edx,%esi
  801253:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <sys_yield>:

void
sys_yield(void)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801260:	ba 00 00 00 00       	mov    $0x0,%edx
  801265:	b8 0b 00 00 00       	mov    $0xb,%eax
  80126a:	89 d1                	mov    %edx,%ecx
  80126c:	89 d3                	mov    %edx,%ebx
  80126e:	89 d7                	mov    %edx,%edi
  801270:	89 d6                	mov    %edx,%esi
  801272:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801274:	5b                   	pop    %ebx
  801275:	5e                   	pop    %esi
  801276:	5f                   	pop    %edi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
  80127f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801282:	be 00 00 00 00       	mov    $0x0,%esi
  801287:	8b 55 08             	mov    0x8(%ebp),%edx
  80128a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128d:	b8 04 00 00 00       	mov    $0x4,%eax
  801292:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801295:	89 f7                	mov    %esi,%edi
  801297:	cd 30                	int    $0x30
	if(check && ret > 0)
  801299:	85 c0                	test   %eax,%eax
  80129b:	7f 08                	jg     8012a5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a0:	5b                   	pop    %ebx
  8012a1:	5e                   	pop    %esi
  8012a2:	5f                   	pop    %edi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	50                   	push   %eax
  8012a9:	6a 04                	push   $0x4
  8012ab:	68 9f 2b 80 00       	push   $0x802b9f
  8012b0:	6a 23                	push   $0x23
  8012b2:	68 bc 2b 80 00       	push   $0x802bbc
  8012b7:	e8 21 f4 ff ff       	call   8006dd <_panic>

008012bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8012d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8012d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	7f 08                	jg     8012e7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	50                   	push   %eax
  8012eb:	6a 05                	push   $0x5
  8012ed:	68 9f 2b 80 00       	push   $0x802b9f
  8012f2:	6a 23                	push   $0x23
  8012f4:	68 bc 2b 80 00       	push   $0x802bbc
  8012f9:	e8 df f3 ff ff       	call   8006dd <_panic>

008012fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801307:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130c:	8b 55 08             	mov    0x8(%ebp),%edx
  80130f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801312:	b8 06 00 00 00       	mov    $0x6,%eax
  801317:	89 df                	mov    %ebx,%edi
  801319:	89 de                	mov    %ebx,%esi
  80131b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80131d:	85 c0                	test   %eax,%eax
  80131f:	7f 08                	jg     801329 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801321:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801324:	5b                   	pop    %ebx
  801325:	5e                   	pop    %esi
  801326:	5f                   	pop    %edi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	50                   	push   %eax
  80132d:	6a 06                	push   $0x6
  80132f:	68 9f 2b 80 00       	push   $0x802b9f
  801334:	6a 23                	push   $0x23
  801336:	68 bc 2b 80 00       	push   $0x802bbc
  80133b:	e8 9d f3 ff ff       	call   8006dd <_panic>

00801340 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	57                   	push   %edi
  801344:	56                   	push   %esi
  801345:	53                   	push   %ebx
  801346:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801349:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134e:	8b 55 08             	mov    0x8(%ebp),%edx
  801351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801354:	b8 08 00 00 00       	mov    $0x8,%eax
  801359:	89 df                	mov    %ebx,%edi
  80135b:	89 de                	mov    %ebx,%esi
  80135d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80135f:	85 c0                	test   %eax,%eax
  801361:	7f 08                	jg     80136b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801363:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5f                   	pop    %edi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	50                   	push   %eax
  80136f:	6a 08                	push   $0x8
  801371:	68 9f 2b 80 00       	push   $0x802b9f
  801376:	6a 23                	push   $0x23
  801378:	68 bc 2b 80 00       	push   $0x802bbc
  80137d:	e8 5b f3 ff ff       	call   8006dd <_panic>

00801382 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	57                   	push   %edi
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80138b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801390:	8b 55 08             	mov    0x8(%ebp),%edx
  801393:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801396:	b8 09 00 00 00       	mov    $0x9,%eax
  80139b:	89 df                	mov    %ebx,%edi
  80139d:	89 de                	mov    %ebx,%esi
  80139f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	7f 08                	jg     8013ad <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a8:	5b                   	pop    %ebx
  8013a9:	5e                   	pop    %esi
  8013aa:	5f                   	pop    %edi
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	50                   	push   %eax
  8013b1:	6a 09                	push   $0x9
  8013b3:	68 9f 2b 80 00       	push   $0x802b9f
  8013b8:	6a 23                	push   $0x23
  8013ba:	68 bc 2b 80 00       	push   $0x802bbc
  8013bf:	e8 19 f3 ff ff       	call   8006dd <_panic>

008013c4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	57                   	push   %edi
  8013c8:	56                   	push   %esi
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013dd:	89 df                	mov    %ebx,%edi
  8013df:	89 de                	mov    %ebx,%esi
  8013e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	7f 08                	jg     8013ef <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ea:	5b                   	pop    %ebx
  8013eb:	5e                   	pop    %esi
  8013ec:	5f                   	pop    %edi
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	6a 0a                	push   $0xa
  8013f5:	68 9f 2b 80 00       	push   $0x802b9f
  8013fa:	6a 23                	push   $0x23
  8013fc:	68 bc 2b 80 00       	push   $0x802bbc
  801401:	e8 d7 f2 ff ff       	call   8006dd <_panic>

00801406 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	57                   	push   %edi
  80140a:	56                   	push   %esi
  80140b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80140c:	8b 55 08             	mov    0x8(%ebp),%edx
  80140f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801412:	b8 0c 00 00 00       	mov    $0xc,%eax
  801417:	be 00 00 00 00       	mov    $0x0,%esi
  80141c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80141f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801422:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    

00801429 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	57                   	push   %edi
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
  80142f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801432:	b9 00 00 00 00       	mov    $0x0,%ecx
  801437:	8b 55 08             	mov    0x8(%ebp),%edx
  80143a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80143f:	89 cb                	mov    %ecx,%ebx
  801441:	89 cf                	mov    %ecx,%edi
  801443:	89 ce                	mov    %ecx,%esi
  801445:	cd 30                	int    $0x30
	if(check && ret > 0)
  801447:	85 c0                	test   %eax,%eax
  801449:	7f 08                	jg     801453 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	50                   	push   %eax
  801457:	6a 0d                	push   $0xd
  801459:	68 9f 2b 80 00       	push   $0x802b9f
  80145e:	6a 23                	push   $0x23
  801460:	68 bc 2b 80 00       	push   $0x802bbc
  801465:	e8 73 f2 ff ff       	call   8006dd <_panic>

0080146a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	56                   	push   %esi
  80146e:	53                   	push   %ebx
  80146f:	8b 75 08             	mov    0x8(%ebp),%esi
  801472:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  801475:	83 ec 0c             	sub    $0xc,%esp
  801478:	ff 75 0c             	push   0xc(%ebp)
  80147b:	e8 a9 ff ff ff       	call   801429 <sys_ipc_recv>
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	85 c0                	test   %eax,%eax
  801485:	78 2b                	js     8014b2 <ipc_recv+0x48>
	if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801487:	85 f6                	test   %esi,%esi
  801489:	74 0a                	je     801495 <ipc_recv+0x2b>
  80148b:	a1 00 40 80 00       	mov    0x804000,%eax
  801490:	8b 40 74             	mov    0x74(%eax),%eax
  801493:	89 06                	mov    %eax,(%esi)
	if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801495:	85 db                	test   %ebx,%ebx
  801497:	74 0a                	je     8014a3 <ipc_recv+0x39>
  801499:	a1 00 40 80 00       	mov    0x804000,%eax
  80149e:	8b 40 78             	mov    0x78(%eax),%eax
  8014a1:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8014a3:	a1 00 40 80 00       	mov    0x804000,%eax
  8014a8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8014ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ae:	5b                   	pop    %ebx
  8014af:	5e                   	pop    %esi
  8014b0:	5d                   	pop    %ebp
  8014b1:	c3                   	ret    
	if (sys_ipc_recv(pg) < 0) return -E_INVAL;
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b7:	eb f2                	jmp    8014ab <ipc_recv+0x41>

008014b9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	57                   	push   %edi
  8014bd:	56                   	push   %esi
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int err;
	while((err = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8014cb:	ff 75 14             	push   0x14(%ebp)
  8014ce:	53                   	push   %ebx
  8014cf:	56                   	push   %esi
  8014d0:	57                   	push   %edi
  8014d1:	e8 30 ff ff ff       	call   801406 <sys_ipc_try_send>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	79 20                	jns    8014fd <ipc_send+0x44>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8014dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014e0:	75 07                	jne    8014e9 <ipc_send+0x30>
		sys_yield();
  8014e2:	e8 73 fd ff ff       	call   80125a <sys_yield>
  8014e7:	eb e2                	jmp    8014cb <ipc_send+0x12>
		if (err != -E_IPC_NOT_RECV) panic("IPC SEND ERROR\n");
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	68 ca 2b 80 00       	push   $0x802bca
  8014f1:	6a 2e                	push   $0x2e
  8014f3:	68 da 2b 80 00       	push   $0x802bda
  8014f8:	e8 e0 f1 ff ff       	call   8006dd <_panic>
	}
}
  8014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801510:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801513:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801519:	8b 52 50             	mov    0x50(%edx),%edx
  80151c:	39 ca                	cmp    %ecx,%edx
  80151e:	74 11                	je     801531 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801520:	83 c0 01             	add    $0x1,%eax
  801523:	3d 00 04 00 00       	cmp    $0x400,%eax
  801528:	75 e6                	jne    801510 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	eb 0b                	jmp    80153c <ipc_find_env+0x37>
			return envs[i].env_id;
  801531:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801534:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801539:	8b 40 48             	mov    0x48(%eax),%eax
}
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	05 00 00 00 30       	add    $0x30000000,%eax
  801549:	c1 e8 0c             	shr    $0xc,%eax
}
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    

0080154e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801559:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80156d:	89 c2                	mov    %eax,%edx
  80156f:	c1 ea 16             	shr    $0x16,%edx
  801572:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801579:	f6 c2 01             	test   $0x1,%dl
  80157c:	74 29                	je     8015a7 <fd_alloc+0x42>
  80157e:	89 c2                	mov    %eax,%edx
  801580:	c1 ea 0c             	shr    $0xc,%edx
  801583:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80158a:	f6 c2 01             	test   $0x1,%dl
  80158d:	74 18                	je     8015a7 <fd_alloc+0x42>
	for (i = 0; i < MAXFD; i++) {
  80158f:	05 00 10 00 00       	add    $0x1000,%eax
  801594:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801599:	75 d2                	jne    80156d <fd_alloc+0x8>
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
  8015a0:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  8015a5:	eb 05                	jmp    8015ac <fd_alloc+0x47>
			return 0;
  8015a7:	b9 00 00 00 00       	mov    $0x0,%ecx
			*fd_store = fd;
  8015ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8015af:	89 02                	mov    %eax,(%edx)
}
  8015b1:	89 c8                	mov    %ecx,%eax
  8015b3:	5d                   	pop    %ebp
  8015b4:	c3                   	ret    

008015b5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015bb:	83 f8 1f             	cmp    $0x1f,%eax
  8015be:	77 30                	ja     8015f0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015c0:	c1 e0 0c             	shl    $0xc,%eax
  8015c3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015c8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015ce:	f6 c2 01             	test   $0x1,%dl
  8015d1:	74 24                	je     8015f7 <fd_lookup+0x42>
  8015d3:	89 c2                	mov    %eax,%edx
  8015d5:	c1 ea 0c             	shr    $0xc,%edx
  8015d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	74 1a                	je     8015fe <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	89 02                	mov    %eax,(%edx)
	return 0;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    
		return -E_INVAL;
  8015f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f5:	eb f7                	jmp    8015ee <fd_lookup+0x39>
		return -E_INVAL;
  8015f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fc:	eb f0                	jmp    8015ee <fd_lookup+0x39>
  8015fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801603:	eb e9                	jmp    8015ee <fd_lookup+0x39>

00801605 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	53                   	push   %ebx
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	8b 55 08             	mov    0x8(%ebp),%edx
  80160f:	b8 60 2c 80 00       	mov    $0x802c60,%eax
	int i;
	for (i = 0; devtab[i]; i++)
  801614:	bb 08 30 80 00       	mov    $0x803008,%ebx
		if (devtab[i]->dev_id == dev_id) {
  801619:	39 13                	cmp    %edx,(%ebx)
  80161b:	74 32                	je     80164f <dev_lookup+0x4a>
	for (i = 0; devtab[i]; i++)
  80161d:	83 c0 04             	add    $0x4,%eax
  801620:	8b 18                	mov    (%eax),%ebx
  801622:	85 db                	test   %ebx,%ebx
  801624:	75 f3                	jne    801619 <dev_lookup+0x14>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801626:	a1 00 40 80 00       	mov    0x804000,%eax
  80162b:	8b 40 48             	mov    0x48(%eax),%eax
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	68 e4 2b 80 00       	push   $0x802be4
  801638:	e8 7b f1 ff ff       	call   8007b8 <cprintf>
	*dev = 0;
	return -E_INVAL;
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			*dev = devtab[i];
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	89 1a                	mov    %ebx,(%edx)
}
  80164a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    
			return 0;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
  801654:	eb ef                	jmp    801645 <dev_lookup+0x40>

00801656 <fd_close>:
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	57                   	push   %edi
  80165a:	56                   	push   %esi
  80165b:	53                   	push   %ebx
  80165c:	83 ec 24             	sub    $0x24,%esp
  80165f:	8b 75 08             	mov    0x8(%ebp),%esi
  801662:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801665:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801668:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801669:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80166f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801672:	50                   	push   %eax
  801673:	e8 3d ff ff ff       	call   8015b5 <fd_lookup>
  801678:	89 c3                	mov    %eax,%ebx
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 05                	js     801686 <fd_close+0x30>
	    || fd != fd2)
  801681:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801684:	74 16                	je     80169c <fd_close+0x46>
		return (must_exist ? r : 0);
  801686:	89 f8                	mov    %edi,%eax
  801688:	84 c0                	test   %al,%al
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
  80168f:	0f 44 d8             	cmove  %eax,%ebx
}
  801692:	89 d8                	mov    %ebx,%eax
  801694:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801697:	5b                   	pop    %ebx
  801698:	5e                   	pop    %esi
  801699:	5f                   	pop    %edi
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80169c:	83 ec 08             	sub    $0x8,%esp
  80169f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016a2:	50                   	push   %eax
  8016a3:	ff 36                	push   (%esi)
  8016a5:	e8 5b ff ff ff       	call   801605 <dev_lookup>
  8016aa:	89 c3                	mov    %eax,%ebx
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 1a                	js     8016cd <fd_close+0x77>
		if (dev->dev_close)
  8016b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	74 0b                	je     8016cd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	56                   	push   %esi
  8016c6:	ff d0                	call   *%eax
  8016c8:	89 c3                	mov    %eax,%ebx
  8016ca:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	56                   	push   %esi
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 26 fc ff ff       	call   8012fe <sys_page_unmap>
	return r;
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	eb b5                	jmp    801692 <fd_close+0x3c>

008016dd <close>:

int
close(int fdnum)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e6:	50                   	push   %eax
  8016e7:	ff 75 08             	push   0x8(%ebp)
  8016ea:	e8 c6 fe ff ff       	call   8015b5 <fd_lookup>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	79 02                	jns    8016f8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    
		return fd_close(fd, 1);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	6a 01                	push   $0x1
  8016fd:	ff 75 f4             	push   -0xc(%ebp)
  801700:	e8 51 ff ff ff       	call   801656 <fd_close>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	eb ec                	jmp    8016f6 <close+0x19>

0080170a <close_all>:

void
close_all(void)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	53                   	push   %ebx
  80170e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801711:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	53                   	push   %ebx
  80171a:	e8 be ff ff ff       	call   8016dd <close>
	for (i = 0; i < MAXFD; i++)
  80171f:	83 c3 01             	add    $0x1,%ebx
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	83 fb 20             	cmp    $0x20,%ebx
  801728:	75 ec                	jne    801716 <close_all+0xc>
}
  80172a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	57                   	push   %edi
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
  801735:	83 ec 34             	sub    $0x34,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801738:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80173b:	50                   	push   %eax
  80173c:	ff 75 08             	push   0x8(%ebp)
  80173f:	e8 71 fe ff ff       	call   8015b5 <fd_lookup>
  801744:	89 c3                	mov    %eax,%ebx
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	78 7f                	js     8017cc <dup+0x9d>
		return r;
	close(newfdnum);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	ff 75 0c             	push   0xc(%ebp)
  801753:	e8 85 ff ff ff       	call   8016dd <close>

	newfd = INDEX2FD(newfdnum);
  801758:	8b 75 0c             	mov    0xc(%ebp),%esi
  80175b:	c1 e6 0c             	shl    $0xc,%esi
  80175e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801767:	89 3c 24             	mov    %edi,(%esp)
  80176a:	e8 df fd ff ff       	call   80154e <fd2data>
  80176f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801771:	89 34 24             	mov    %esi,(%esp)
  801774:	e8 d5 fd ff ff       	call   80154e <fd2data>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80177f:	89 d8                	mov    %ebx,%eax
  801781:	c1 e8 16             	shr    $0x16,%eax
  801784:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80178b:	a8 01                	test   $0x1,%al
  80178d:	74 11                	je     8017a0 <dup+0x71>
  80178f:	89 d8                	mov    %ebx,%eax
  801791:	c1 e8 0c             	shr    $0xc,%eax
  801794:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80179b:	f6 c2 01             	test   $0x1,%dl
  80179e:	75 36                	jne    8017d6 <dup+0xa7>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017a0:	89 f8                	mov    %edi,%eax
  8017a2:	c1 e8 0c             	shr    $0xc,%eax
  8017a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	25 07 0e 00 00       	and    $0xe07,%eax
  8017b4:	50                   	push   %eax
  8017b5:	56                   	push   %esi
  8017b6:	6a 00                	push   $0x0
  8017b8:	57                   	push   %edi
  8017b9:	6a 00                	push   $0x0
  8017bb:	e8 fc fa ff ff       	call   8012bc <sys_page_map>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 20             	add    $0x20,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 33                	js     8017fc <dup+0xcd>
		goto err;

	return newfdnum;
  8017c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017cc:	89 d8                	mov    %ebx,%eax
  8017ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d1:	5b                   	pop    %ebx
  8017d2:	5e                   	pop    %esi
  8017d3:	5f                   	pop    %edi
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e5:	50                   	push   %eax
  8017e6:	ff 75 d4             	push   -0x2c(%ebp)
  8017e9:	6a 00                	push   $0x0
  8017eb:	53                   	push   %ebx
  8017ec:	6a 00                	push   $0x0
  8017ee:	e8 c9 fa ff ff       	call   8012bc <sys_page_map>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	83 c4 20             	add    $0x20,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	79 a4                	jns    8017a0 <dup+0x71>
	sys_page_unmap(0, newfd);
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	56                   	push   %esi
  801800:	6a 00                	push   $0x0
  801802:	e8 f7 fa ff ff       	call   8012fe <sys_page_unmap>
	sys_page_unmap(0, nva);
  801807:	83 c4 08             	add    $0x8,%esp
  80180a:	ff 75 d4             	push   -0x2c(%ebp)
  80180d:	6a 00                	push   $0x0
  80180f:	e8 ea fa ff ff       	call   8012fe <sys_page_unmap>
	return r;
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	eb b3                	jmp    8017cc <dup+0x9d>

00801819 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 18             	sub    $0x18,%esp
  801821:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801824:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801827:	50                   	push   %eax
  801828:	56                   	push   %esi
  801829:	e8 87 fd ff ff       	call   8015b5 <fd_lookup>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	85 c0                	test   %eax,%eax
  801833:	78 3c                	js     801871 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801835:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183e:	50                   	push   %eax
  80183f:	ff 33                	push   (%ebx)
  801841:	e8 bf fd ff ff       	call   801605 <dev_lookup>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	78 24                	js     801871 <read+0x58>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80184d:	8b 43 08             	mov    0x8(%ebx),%eax
  801850:	83 e0 03             	and    $0x3,%eax
  801853:	83 f8 01             	cmp    $0x1,%eax
  801856:	74 20                	je     801878 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185b:	8b 40 08             	mov    0x8(%eax),%eax
  80185e:	85 c0                	test   %eax,%eax
  801860:	74 37                	je     801899 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	ff 75 10             	push   0x10(%ebp)
  801868:	ff 75 0c             	push   0xc(%ebp)
  80186b:	53                   	push   %ebx
  80186c:	ff d0                	call   *%eax
  80186e:	83 c4 10             	add    $0x10,%esp
}
  801871:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801878:	a1 00 40 80 00       	mov    0x804000,%eax
  80187d:	8b 40 48             	mov    0x48(%eax),%eax
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	56                   	push   %esi
  801884:	50                   	push   %eax
  801885:	68 25 2c 80 00       	push   $0x802c25
  80188a:	e8 29 ef ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801897:	eb d8                	jmp    801871 <read+0x58>
		return -E_NOT_SUPP;
  801899:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189e:	eb d1                	jmp    801871 <read+0x58>

008018a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b4:	eb 02                	jmp    8018b8 <readn+0x18>
  8018b6:	01 c3                	add    %eax,%ebx
  8018b8:	39 f3                	cmp    %esi,%ebx
  8018ba:	73 21                	jae    8018dd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	89 f0                	mov    %esi,%eax
  8018c1:	29 d8                	sub    %ebx,%eax
  8018c3:	50                   	push   %eax
  8018c4:	89 d8                	mov    %ebx,%eax
  8018c6:	03 45 0c             	add    0xc(%ebp),%eax
  8018c9:	50                   	push   %eax
  8018ca:	57                   	push   %edi
  8018cb:	e8 49 ff ff ff       	call   801819 <read>
		if (m < 0)
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 04                	js     8018db <readn+0x3b>
			return m;
		if (m == 0)
  8018d7:	75 dd                	jne    8018b6 <readn+0x16>
  8018d9:	eb 02                	jmp    8018dd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018db:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    

008018e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 18             	sub    $0x18,%esp
  8018ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	53                   	push   %ebx
  8018f7:	e8 b9 fc ff ff       	call   8015b5 <fd_lookup>
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 37                	js     80193a <write+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801903:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	ff 36                	push   (%esi)
  80190f:	e8 f1 fc ff ff       	call   801605 <dev_lookup>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 1f                	js     80193a <write+0x53>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80191b:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  80191f:	74 20                	je     801941 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	8b 40 0c             	mov    0xc(%eax),%eax
  801927:	85 c0                	test   %eax,%eax
  801929:	74 37                	je     801962 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	ff 75 10             	push   0x10(%ebp)
  801931:	ff 75 0c             	push   0xc(%ebp)
  801934:	56                   	push   %esi
  801935:	ff d0                	call   *%eax
  801937:	83 c4 10             	add    $0x10,%esp
}
  80193a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193d:	5b                   	pop    %ebx
  80193e:	5e                   	pop    %esi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801941:	a1 00 40 80 00       	mov    0x804000,%eax
  801946:	8b 40 48             	mov    0x48(%eax),%eax
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	53                   	push   %ebx
  80194d:	50                   	push   %eax
  80194e:	68 41 2c 80 00       	push   $0x802c41
  801953:	e8 60 ee ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801960:	eb d8                	jmp    80193a <write+0x53>
		return -E_NOT_SUPP;
  801962:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801967:	eb d1                	jmp    80193a <write+0x53>

00801969 <seek>:

int
seek(int fdnum, off_t offset)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	ff 75 08             	push   0x8(%ebp)
  801976:	e8 3a fc ff ff       	call   8015b5 <fd_lookup>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 0e                	js     801990 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801988:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	56                   	push   %esi
  801996:	53                   	push   %ebx
  801997:	83 ec 18             	sub    $0x18,%esp
  80199a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a0:	50                   	push   %eax
  8019a1:	53                   	push   %ebx
  8019a2:	e8 0e fc ff ff       	call   8015b5 <fd_lookup>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 34                	js     8019e2 <ftruncate+0x50>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ae:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8019b1:	83 ec 08             	sub    $0x8,%esp
  8019b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	ff 36                	push   (%esi)
  8019ba:	e8 46 fc ff ff       	call   801605 <dev_lookup>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 1c                	js     8019e2 <ftruncate+0x50>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019c6:	f6 46 08 03          	testb  $0x3,0x8(%esi)
  8019ca:	74 1d                	je     8019e9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cf:	8b 40 18             	mov    0x18(%eax),%eax
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	74 34                	je     801a0a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	push   0xc(%ebp)
  8019dc:	56                   	push   %esi
  8019dd:	ff d0                	call   *%eax
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8019ee:	8b 40 48             	mov    0x48(%eax),%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	53                   	push   %ebx
  8019f5:	50                   	push   %eax
  8019f6:	68 04 2c 80 00       	push   $0x802c04
  8019fb:	e8 b8 ed ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a08:	eb d8                	jmp    8019e2 <ftruncate+0x50>
		return -E_NOT_SUPP;
  801a0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0f:	eb d1                	jmp    8019e2 <ftruncate+0x50>

00801a11 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
  801a16:	83 ec 18             	sub    $0x18,%esp
  801a19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1f:	50                   	push   %eax
  801a20:	ff 75 08             	push   0x8(%ebp)
  801a23:	e8 8d fb ff ff       	call   8015b5 <fd_lookup>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 49                	js     801a78 <fstat+0x67>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2f:	8b 75 f0             	mov    -0x10(%ebp),%esi
  801a32:	83 ec 08             	sub    $0x8,%esp
  801a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a38:	50                   	push   %eax
  801a39:	ff 36                	push   (%esi)
  801a3b:	e8 c5 fb ff ff       	call   801605 <dev_lookup>
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 31                	js     801a78 <fstat+0x67>
		return r;
	if (!dev->dev_stat)
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a4e:	74 2f                	je     801a7f <fstat+0x6e>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a50:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a53:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a5a:	00 00 00 
	stat->st_isdir = 0;
  801a5d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a64:	00 00 00 
	stat->st_dev = dev;
  801a67:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	53                   	push   %ebx
  801a71:	56                   	push   %esi
  801a72:	ff 50 14             	call   *0x14(%eax)
  801a75:	83 c4 10             	add    $0x10,%esp
}
  801a78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    
		return -E_NOT_SUPP;
  801a7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a84:	eb f2                	jmp    801a78 <fstat+0x67>

00801a86 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	56                   	push   %esi
  801a8a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 08             	push   0x8(%ebp)
  801a93:	e8 22 02 00 00       	call   801cba <open>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 1b                	js     801abc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	ff 75 0c             	push   0xc(%ebp)
  801aa7:	50                   	push   %eax
  801aa8:	e8 64 ff ff ff       	call   801a11 <fstat>
  801aad:	89 c6                	mov    %eax,%esi
	close(fd);
  801aaf:	89 1c 24             	mov    %ebx,(%esp)
  801ab2:	e8 26 fc ff ff       	call   8016dd <close>
	return r;
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	89 f3                	mov    %esi,%ebx
}
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    

00801ac5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	56                   	push   %esi
  801ac9:	53                   	push   %ebx
  801aca:	89 c6                	mov    %eax,%esi
  801acc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ace:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ad5:	74 27                	je     801afe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ad7:	6a 07                	push   $0x7
  801ad9:	68 00 50 80 00       	push   $0x805000
  801ade:	56                   	push   %esi
  801adf:	ff 35 00 60 80 00    	push   0x806000
  801ae5:	e8 cf f9 ff ff       	call   8014b9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aea:	83 c4 0c             	add    $0xc,%esp
  801aed:	6a 00                	push   $0x0
  801aef:	53                   	push   %ebx
  801af0:	6a 00                	push   $0x0
  801af2:	e8 73 f9 ff ff       	call   80146a <ipc_recv>
}
  801af7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5d                   	pop    %ebp
  801afd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801afe:	83 ec 0c             	sub    $0xc,%esp
  801b01:	6a 01                	push   $0x1
  801b03:	e8 fd f9 ff ff       	call   801505 <ipc_find_env>
  801b08:	a3 00 60 80 00       	mov    %eax,0x806000
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	eb c5                	jmp    801ad7 <fsipc+0x12>

00801b12 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b26:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	b8 02 00 00 00       	mov    $0x2,%eax
  801b35:	e8 8b ff ff ff       	call   801ac5 <fsipc>
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <devfile_flush>:
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	8b 40 0c             	mov    0xc(%eax),%eax
  801b48:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	b8 06 00 00 00       	mov    $0x6,%eax
  801b57:	e8 69 ff ff ff       	call   801ac5 <fsipc>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <devfile_stat>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	53                   	push   %ebx
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b73:	ba 00 00 00 00       	mov    $0x0,%edx
  801b78:	b8 05 00 00 00       	mov    $0x5,%eax
  801b7d:	e8 43 ff ff ff       	call   801ac5 <fsipc>
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 2c                	js     801bb2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	68 00 50 80 00       	push   $0x805000
  801b8e:	53                   	push   %ebx
  801b8f:	e8 e9 f2 ff ff       	call   800e7d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b94:	a1 80 50 80 00       	mov    0x805080,%eax
  801b99:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b9f:	a1 84 50 80 00       	mov    0x805084,%eax
  801ba4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <devfile_write>:
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801bcc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bd2:	53                   	push   %ebx
  801bd3:	ff 75 0c             	push   0xc(%ebp)
  801bd6:	68 08 50 80 00       	push   $0x805008
  801bdb:	e8 95 f4 ff ff       	call   801075 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801be0:	ba 00 00 00 00       	mov    $0x0,%edx
  801be5:	b8 04 00 00 00       	mov    $0x4,%eax
  801bea:	e8 d6 fe ff ff       	call   801ac5 <fsipc>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 0b                	js     801c01 <devfile_write+0x4a>
	assert(r <= n);
  801bf6:	39 d8                	cmp    %ebx,%eax
  801bf8:	77 0c                	ja     801c06 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bfa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bff:	7f 1e                	jg     801c1f <devfile_write+0x68>
}
  801c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    
	assert(r <= n);
  801c06:	68 70 2c 80 00       	push   $0x802c70
  801c0b:	68 77 2c 80 00       	push   $0x802c77
  801c10:	68 97 00 00 00       	push   $0x97
  801c15:	68 8c 2c 80 00       	push   $0x802c8c
  801c1a:	e8 be ea ff ff       	call   8006dd <_panic>
	assert(r <= PGSIZE);
  801c1f:	68 97 2c 80 00       	push   $0x802c97
  801c24:	68 77 2c 80 00       	push   $0x802c77
  801c29:	68 98 00 00 00       	push   $0x98
  801c2e:	68 8c 2c 80 00       	push   $0x802c8c
  801c33:	e8 a5 ea ff ff       	call   8006dd <_panic>

00801c38 <devfile_read>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8b 40 0c             	mov    0xc(%eax),%eax
  801c46:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c4b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5b:	e8 65 fe ff ff       	call   801ac5 <fsipc>
  801c60:	89 c3                	mov    %eax,%ebx
  801c62:	85 c0                	test   %eax,%eax
  801c64:	78 1f                	js     801c85 <devfile_read+0x4d>
	assert(r <= n);
  801c66:	39 f0                	cmp    %esi,%eax
  801c68:	77 24                	ja     801c8e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c6f:	7f 33                	jg     801ca4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	50                   	push   %eax
  801c75:	68 00 50 80 00       	push   $0x805000
  801c7a:	ff 75 0c             	push   0xc(%ebp)
  801c7d:	e8 91 f3 ff ff       	call   801013 <memmove>
	return r;
  801c82:	83 c4 10             	add    $0x10,%esp
}
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5e                   	pop    %esi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    
	assert(r <= n);
  801c8e:	68 70 2c 80 00       	push   $0x802c70
  801c93:	68 77 2c 80 00       	push   $0x802c77
  801c98:	6a 7c                	push   $0x7c
  801c9a:	68 8c 2c 80 00       	push   $0x802c8c
  801c9f:	e8 39 ea ff ff       	call   8006dd <_panic>
	assert(r <= PGSIZE);
  801ca4:	68 97 2c 80 00       	push   $0x802c97
  801ca9:	68 77 2c 80 00       	push   $0x802c77
  801cae:	6a 7d                	push   $0x7d
  801cb0:	68 8c 2c 80 00       	push   $0x802c8c
  801cb5:	e8 23 ea ff ff       	call   8006dd <_panic>

00801cba <open>:
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	56                   	push   %esi
  801cbe:	53                   	push   %ebx
  801cbf:	83 ec 1c             	sub    $0x1c,%esp
  801cc2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cc5:	56                   	push   %esi
  801cc6:	e8 77 f1 ff ff       	call   800e42 <strlen>
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cd3:	7f 6c                	jg     801d41 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	50                   	push   %eax
  801cdc:	e8 84 f8 ff ff       	call   801565 <fd_alloc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	78 3c                	js     801d26 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cea:	83 ec 08             	sub    $0x8,%esp
  801ced:	56                   	push   %esi
  801cee:	68 00 50 80 00       	push   $0x805000
  801cf3:	e8 85 f1 ff ff       	call   800e7d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d03:	b8 01 00 00 00       	mov    $0x1,%eax
  801d08:	e8 b8 fd ff ff       	call   801ac5 <fsipc>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 19                	js     801d2f <open+0x75>
	return fd2num(fd);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 f4             	push   -0xc(%ebp)
  801d1c:	e8 1d f8 ff ff       	call   80153e <fd2num>
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	83 c4 10             	add    $0x10,%esp
}
  801d26:	89 d8                	mov    %ebx,%eax
  801d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    
		fd_close(fd, 0);
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	6a 00                	push   $0x0
  801d34:	ff 75 f4             	push   -0xc(%ebp)
  801d37:	e8 1a f9 ff ff       	call   801656 <fd_close>
		return r;
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	eb e5                	jmp    801d26 <open+0x6c>
		return -E_BAD_PATH;
  801d41:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d46:	eb de                	jmp    801d26 <open+0x6c>

00801d48 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d53:	b8 08 00 00 00       	mov    $0x8,%eax
  801d58:	e8 68 fd ff ff       	call   801ac5 <fsipc>
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	push   0x8(%ebp)
  801d6d:	e8 dc f7 ff ff       	call   80154e <fd2data>
  801d72:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d74:	83 c4 08             	add    $0x8,%esp
  801d77:	68 a3 2c 80 00       	push   $0x802ca3
  801d7c:	53                   	push   %ebx
  801d7d:	e8 fb f0 ff ff       	call   800e7d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d82:	8b 46 04             	mov    0x4(%esi),%eax
  801d85:	2b 06                	sub    (%esi),%eax
  801d87:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d94:	00 00 00 
	stat->st_dev = &devpipe;
  801d97:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801d9e:	30 80 00 
	return 0;
}
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da9:	5b                   	pop    %ebx
  801daa:	5e                   	pop    %esi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    

00801dad <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	53                   	push   %ebx
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801db7:	53                   	push   %ebx
  801db8:	6a 00                	push   $0x0
  801dba:	e8 3f f5 ff ff       	call   8012fe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dbf:	89 1c 24             	mov    %ebx,(%esp)
  801dc2:	e8 87 f7 ff ff       	call   80154e <fd2data>
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	50                   	push   %eax
  801dcb:	6a 00                	push   $0x0
  801dcd:	e8 2c f5 ff ff       	call   8012fe <sys_page_unmap>
}
  801dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <_pipeisclosed>:
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	57                   	push   %edi
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	83 ec 1c             	sub    $0x1c,%esp
  801de0:	89 c7                	mov    %eax,%edi
  801de2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801de4:	a1 00 40 80 00       	mov    0x804000,%eax
  801de9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	57                   	push   %edi
  801df0:	e8 28 04 00 00       	call   80221d <pageref>
  801df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801df8:	89 34 24             	mov    %esi,(%esp)
  801dfb:	e8 1d 04 00 00       	call   80221d <pageref>
		nn = thisenv->env_runs;
  801e00:	8b 15 00 40 80 00    	mov    0x804000,%edx
  801e06:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	39 cb                	cmp    %ecx,%ebx
  801e0e:	74 1b                	je     801e2b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e10:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e13:	75 cf                	jne    801de4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e15:	8b 42 58             	mov    0x58(%edx),%eax
  801e18:	6a 01                	push   $0x1
  801e1a:	50                   	push   %eax
  801e1b:	53                   	push   %ebx
  801e1c:	68 aa 2c 80 00       	push   $0x802caa
  801e21:	e8 92 e9 ff ff       	call   8007b8 <cprintf>
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	eb b9                	jmp    801de4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e2b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e2e:	0f 94 c0             	sete   %al
  801e31:	0f b6 c0             	movzbl %al,%eax
}
  801e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <devpipe_write>:
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 28             	sub    $0x28,%esp
  801e45:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e48:	56                   	push   %esi
  801e49:	e8 00 f7 ff ff       	call   80154e <fd2data>
  801e4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	bf 00 00 00 00       	mov    $0x0,%edi
  801e58:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e5b:	75 09                	jne    801e66 <devpipe_write+0x2a>
	return i;
  801e5d:	89 f8                	mov    %edi,%eax
  801e5f:	eb 23                	jmp    801e84 <devpipe_write+0x48>
			sys_yield();
  801e61:	e8 f4 f3 ff ff       	call   80125a <sys_yield>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e66:	8b 43 04             	mov    0x4(%ebx),%eax
  801e69:	8b 0b                	mov    (%ebx),%ecx
  801e6b:	8d 51 20             	lea    0x20(%ecx),%edx
  801e6e:	39 d0                	cmp    %edx,%eax
  801e70:	72 1a                	jb     801e8c <devpipe_write+0x50>
			if (_pipeisclosed(fd, p))
  801e72:	89 da                	mov    %ebx,%edx
  801e74:	89 f0                	mov    %esi,%eax
  801e76:	e8 5c ff ff ff       	call   801dd7 <_pipeisclosed>
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	74 e2                	je     801e61 <devpipe_write+0x25>
				return 0;
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e93:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e96:	89 c2                	mov    %eax,%edx
  801e98:	c1 fa 1f             	sar    $0x1f,%edx
  801e9b:	89 d1                	mov    %edx,%ecx
  801e9d:	c1 e9 1b             	shr    $0x1b,%ecx
  801ea0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ea3:	83 e2 1f             	and    $0x1f,%edx
  801ea6:	29 ca                	sub    %ecx,%edx
  801ea8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801eac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eb0:	83 c0 01             	add    $0x1,%eax
  801eb3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801eb6:	83 c7 01             	add    $0x1,%edi
  801eb9:	eb 9d                	jmp    801e58 <devpipe_write+0x1c>

00801ebb <devpipe_read>:
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	57                   	push   %edi
  801ebf:	56                   	push   %esi
  801ec0:	53                   	push   %ebx
  801ec1:	83 ec 18             	sub    $0x18,%esp
  801ec4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ec7:	57                   	push   %edi
  801ec8:	e8 81 f6 ff ff       	call   80154e <fd2data>
  801ecd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	be 00 00 00 00       	mov    $0x0,%esi
  801ed7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eda:	75 13                	jne    801eef <devpipe_read+0x34>
	return i;
  801edc:	89 f0                	mov    %esi,%eax
  801ede:	eb 02                	jmp    801ee2 <devpipe_read+0x27>
				return i;
  801ee0:	89 f0                	mov    %esi,%eax
}
  801ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee5:	5b                   	pop    %ebx
  801ee6:	5e                   	pop    %esi
  801ee7:	5f                   	pop    %edi
  801ee8:	5d                   	pop    %ebp
  801ee9:	c3                   	ret    
			sys_yield();
  801eea:	e8 6b f3 ff ff       	call   80125a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eef:	8b 03                	mov    (%ebx),%eax
  801ef1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ef4:	75 18                	jne    801f0e <devpipe_read+0x53>
			if (i > 0)
  801ef6:	85 f6                	test   %esi,%esi
  801ef8:	75 e6                	jne    801ee0 <devpipe_read+0x25>
			if (_pipeisclosed(fd, p))
  801efa:	89 da                	mov    %ebx,%edx
  801efc:	89 f8                	mov    %edi,%eax
  801efe:	e8 d4 fe ff ff       	call   801dd7 <_pipeisclosed>
  801f03:	85 c0                	test   %eax,%eax
  801f05:	74 e3                	je     801eea <devpipe_read+0x2f>
				return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	eb d4                	jmp    801ee2 <devpipe_read+0x27>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f0e:	99                   	cltd   
  801f0f:	c1 ea 1b             	shr    $0x1b,%edx
  801f12:	01 d0                	add    %edx,%eax
  801f14:	83 e0 1f             	and    $0x1f,%eax
  801f17:	29 d0                	sub    %edx,%eax
  801f19:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f21:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f24:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f27:	83 c6 01             	add    $0x1,%esi
  801f2a:	eb ab                	jmp    801ed7 <devpipe_read+0x1c>

00801f2c <pipe>:
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f37:	50                   	push   %eax
  801f38:	e8 28 f6 ff ff       	call   801565 <fd_alloc>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	0f 88 23 01 00 00    	js     80206d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4a:	83 ec 04             	sub    $0x4,%esp
  801f4d:	68 07 04 00 00       	push   $0x407
  801f52:	ff 75 f4             	push   -0xc(%ebp)
  801f55:	6a 00                	push   $0x0
  801f57:	e8 1d f3 ff ff       	call   801279 <sys_page_alloc>
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	85 c0                	test   %eax,%eax
  801f63:	0f 88 04 01 00 00    	js     80206d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f6f:	50                   	push   %eax
  801f70:	e8 f0 f5 ff ff       	call   801565 <fd_alloc>
  801f75:	89 c3                	mov    %eax,%ebx
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	0f 88 db 00 00 00    	js     80205d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 07 04 00 00       	push   $0x407
  801f8a:	ff 75 f0             	push   -0x10(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 e5 f2 ff ff       	call   801279 <sys_page_alloc>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	0f 88 bc 00 00 00    	js     80205d <pipe+0x131>
	va = fd2data(fd0);
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	ff 75 f4             	push   -0xc(%ebp)
  801fa7:	e8 a2 f5 ff ff       	call   80154e <fd2data>
  801fac:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fae:	83 c4 0c             	add    $0xc,%esp
  801fb1:	68 07 04 00 00       	push   $0x407
  801fb6:	50                   	push   %eax
  801fb7:	6a 00                	push   $0x0
  801fb9:	e8 bb f2 ff ff       	call   801279 <sys_page_alloc>
  801fbe:	89 c3                	mov    %eax,%ebx
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	0f 88 82 00 00 00    	js     80204d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	ff 75 f0             	push   -0x10(%ebp)
  801fd1:	e8 78 f5 ff ff       	call   80154e <fd2data>
  801fd6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fdd:	50                   	push   %eax
  801fde:	6a 00                	push   $0x0
  801fe0:	56                   	push   %esi
  801fe1:	6a 00                	push   $0x0
  801fe3:	e8 d4 f2 ff ff       	call   8012bc <sys_page_map>
  801fe8:	89 c3                	mov    %eax,%ebx
  801fea:	83 c4 20             	add    $0x20,%esp
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 4e                	js     80203f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ff1:	a1 24 30 80 00       	mov    0x803024,%eax
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffe:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802005:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802008:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	ff 75 f4             	push   -0xc(%ebp)
  80201a:	e8 1f f5 ff ff       	call   80153e <fd2num>
  80201f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802022:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802024:	83 c4 04             	add    $0x4,%esp
  802027:	ff 75 f0             	push   -0x10(%ebp)
  80202a:	e8 0f f5 ff ff       	call   80153e <fd2num>
  80202f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802032:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	bb 00 00 00 00       	mov    $0x0,%ebx
  80203d:	eb 2e                	jmp    80206d <pipe+0x141>
	sys_page_unmap(0, va);
  80203f:	83 ec 08             	sub    $0x8,%esp
  802042:	56                   	push   %esi
  802043:	6a 00                	push   $0x0
  802045:	e8 b4 f2 ff ff       	call   8012fe <sys_page_unmap>
  80204a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80204d:	83 ec 08             	sub    $0x8,%esp
  802050:	ff 75 f0             	push   -0x10(%ebp)
  802053:	6a 00                	push   $0x0
  802055:	e8 a4 f2 ff ff       	call   8012fe <sys_page_unmap>
  80205a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80205d:	83 ec 08             	sub    $0x8,%esp
  802060:	ff 75 f4             	push   -0xc(%ebp)
  802063:	6a 00                	push   $0x0
  802065:	e8 94 f2 ff ff       	call   8012fe <sys_page_unmap>
  80206a:	83 c4 10             	add    $0x10,%esp
}
  80206d:	89 d8                	mov    %ebx,%eax
  80206f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802072:	5b                   	pop    %ebx
  802073:	5e                   	pop    %esi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    

00802076 <pipeisclosed>:
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80207f:	50                   	push   %eax
  802080:	ff 75 08             	push   0x8(%ebp)
  802083:	e8 2d f5 ff ff       	call   8015b5 <fd_lookup>
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 18                	js     8020a7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	ff 75 f4             	push   -0xc(%ebp)
  802095:	e8 b4 f4 ff ff       	call   80154e <fd2data>
  80209a:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	e8 33 fd ff ff       	call   801dd7 <_pipeisclosed>
  8020a4:	83 c4 10             	add    $0x10,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	c3                   	ret    

008020af <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020b5:	68 c2 2c 80 00       	push   $0x802cc2
  8020ba:	ff 75 0c             	push   0xc(%ebp)
  8020bd:	e8 bb ed ff ff       	call   800e7d <strcpy>
	return 0;
}
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <devcons_write>:
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	57                   	push   %edi
  8020cd:	56                   	push   %esi
  8020ce:	53                   	push   %ebx
  8020cf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020d5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020da:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020e0:	eb 2e                	jmp    802110 <devcons_write+0x47>
		m = n - tot;
  8020e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020e5:	29 f3                	sub    %esi,%ebx
  8020e7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ec:	39 c3                	cmp    %eax,%ebx
  8020ee:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	53                   	push   %ebx
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	03 45 0c             	add    0xc(%ebp),%eax
  8020fa:	50                   	push   %eax
  8020fb:	57                   	push   %edi
  8020fc:	e8 12 ef ff ff       	call   801013 <memmove>
		sys_cputs(buf, m);
  802101:	83 c4 08             	add    $0x8,%esp
  802104:	53                   	push   %ebx
  802105:	57                   	push   %edi
  802106:	e8 b2 f0 ff ff       	call   8011bd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80210b:	01 de                	add    %ebx,%esi
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	3b 75 10             	cmp    0x10(%ebp),%esi
  802113:	72 cd                	jb     8020e2 <devcons_write+0x19>
}
  802115:	89 f0                	mov    %esi,%eax
  802117:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80211a:	5b                   	pop    %ebx
  80211b:	5e                   	pop    %esi
  80211c:	5f                   	pop    %edi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <devcons_read>:
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 08             	sub    $0x8,%esp
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80212a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212e:	75 07                	jne    802137 <devcons_read+0x18>
  802130:	eb 1f                	jmp    802151 <devcons_read+0x32>
		sys_yield();
  802132:	e8 23 f1 ff ff       	call   80125a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802137:	e8 9f f0 ff ff       	call   8011db <sys_cgetc>
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 f2                	je     802132 <devcons_read+0x13>
	if (c < 0)
  802140:	78 0f                	js     802151 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802142:	83 f8 04             	cmp    $0x4,%eax
  802145:	74 0c                	je     802153 <devcons_read+0x34>
	*(char*)vbuf = c;
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	88 02                	mov    %al,(%edx)
	return 1;
  80214c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    
		return 0;
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
  802158:	eb f7                	jmp    802151 <devcons_read+0x32>

0080215a <cputchar>:
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802166:	6a 01                	push   $0x1
  802168:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80216b:	50                   	push   %eax
  80216c:	e8 4c f0 ff ff       	call   8011bd <sys_cputs>
}
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <getchar>:
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80217c:	6a 01                	push   $0x1
  80217e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802181:	50                   	push   %eax
  802182:	6a 00                	push   $0x0
  802184:	e8 90 f6 ff ff       	call   801819 <read>
	if (r < 0)
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 06                	js     802196 <getchar+0x20>
	if (r < 1)
  802190:	74 06                	je     802198 <getchar+0x22>
	return c;
  802192:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    
		return -E_EOF;
  802198:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80219d:	eb f7                	jmp    802196 <getchar+0x20>

0080219f <iscons>:
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a8:	50                   	push   %eax
  8021a9:	ff 75 08             	push   0x8(%ebp)
  8021ac:	e8 04 f4 ff ff       	call   8015b5 <fd_lookup>
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	78 11                	js     8021c9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021c1:	39 10                	cmp    %edx,(%eax)
  8021c3:	0f 94 c0             	sete   %al
  8021c6:	0f b6 c0             	movzbl %al,%eax
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <opencons>:
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d4:	50                   	push   %eax
  8021d5:	e8 8b f3 ff ff       	call   801565 <fd_alloc>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 3a                	js     80221b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021e1:	83 ec 04             	sub    $0x4,%esp
  8021e4:	68 07 04 00 00       	push   $0x407
  8021e9:	ff 75 f4             	push   -0xc(%ebp)
  8021ec:	6a 00                	push   $0x0
  8021ee:	e8 86 f0 ff ff       	call   801279 <sys_page_alloc>
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 21                	js     80221b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802203:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	50                   	push   %eax
  802213:	e8 26 f3 ff ff       	call   80153e <fd2num>
  802218:	83 c4 10             	add    $0x10,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802223:	89 c2                	mov    %eax,%edx
  802225:	c1 ea 16             	shr    $0x16,%edx
  802228:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802234:	f6 c1 01             	test   $0x1,%cl
  802237:	74 1c                	je     802255 <pageref+0x38>
	pte = uvpt[PGNUM(v)];
  802239:	c1 e8 0c             	shr    $0xc,%eax
  80223c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802243:	a8 01                	test   $0x1,%al
  802245:	74 0e                	je     802255 <pageref+0x38>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802247:	c1 e8 0c             	shr    $0xc,%eax
  80224a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802251:	ef 
  802252:	0f b7 d2             	movzwl %dx,%edx
}
  802255:	89 d0                	mov    %edx,%eax
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
  802259:	66 90                	xchg   %ax,%ax
  80225b:	66 90                	xchg   %ax,%ax
  80225d:	66 90                	xchg   %ax,%ax
  80225f:	90                   	nop

00802260 <__udivdi3>:
  802260:	f3 0f 1e fb          	endbr32 
  802264:	55                   	push   %ebp
  802265:	57                   	push   %edi
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	83 ec 1c             	sub    $0x1c,%esp
  80226b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80226f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802273:	8b 74 24 34          	mov    0x34(%esp),%esi
  802277:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80227b:	85 c0                	test   %eax,%eax
  80227d:	75 19                	jne    802298 <__udivdi3+0x38>
  80227f:	39 f3                	cmp    %esi,%ebx
  802281:	76 4d                	jbe    8022d0 <__udivdi3+0x70>
  802283:	31 ff                	xor    %edi,%edi
  802285:	89 e8                	mov    %ebp,%eax
  802287:	89 f2                	mov    %esi,%edx
  802289:	f7 f3                	div    %ebx
  80228b:	89 fa                	mov    %edi,%edx
  80228d:	83 c4 1c             	add    $0x1c,%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	39 f0                	cmp    %esi,%eax
  80229a:	76 14                	jbe    8022b0 <__udivdi3+0x50>
  80229c:	31 ff                	xor    %edi,%edi
  80229e:	31 c0                	xor    %eax,%eax
  8022a0:	89 fa                	mov    %edi,%edx
  8022a2:	83 c4 1c             	add    $0x1c,%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b0:	0f bd f8             	bsr    %eax,%edi
  8022b3:	83 f7 1f             	xor    $0x1f,%edi
  8022b6:	75 48                	jne    802300 <__udivdi3+0xa0>
  8022b8:	39 f0                	cmp    %esi,%eax
  8022ba:	72 06                	jb     8022c2 <__udivdi3+0x62>
  8022bc:	31 c0                	xor    %eax,%eax
  8022be:	39 eb                	cmp    %ebp,%ebx
  8022c0:	77 de                	ja     8022a0 <__udivdi3+0x40>
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	eb d7                	jmp    8022a0 <__udivdi3+0x40>
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 d9                	mov    %ebx,%ecx
  8022d2:	85 db                	test   %ebx,%ebx
  8022d4:	75 0b                	jne    8022e1 <__udivdi3+0x81>
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f3                	div    %ebx
  8022df:	89 c1                	mov    %eax,%ecx
  8022e1:	31 d2                	xor    %edx,%edx
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	f7 f1                	div    %ecx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	89 e8                	mov    %ebp,%eax
  8022eb:	89 f7                	mov    %esi,%edi
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 fa                	mov    %edi,%edx
  8022f1:	83 c4 1c             	add    $0x1c,%esp
  8022f4:	5b                   	pop    %ebx
  8022f5:	5e                   	pop    %esi
  8022f6:	5f                   	pop    %edi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	89 f9                	mov    %edi,%ecx
  802302:	ba 20 00 00 00       	mov    $0x20,%edx
  802307:	29 fa                	sub    %edi,%edx
  802309:	d3 e0                	shl    %cl,%eax
  80230b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230f:	89 d1                	mov    %edx,%ecx
  802311:	89 d8                	mov    %ebx,%eax
  802313:	d3 e8                	shr    %cl,%eax
  802315:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802319:	09 c1                	or     %eax,%ecx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802321:	89 f9                	mov    %edi,%ecx
  802323:	d3 e3                	shl    %cl,%ebx
  802325:	89 d1                	mov    %edx,%ecx
  802327:	d3 e8                	shr    %cl,%eax
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80232f:	89 eb                	mov    %ebp,%ebx
  802331:	d3 e6                	shl    %cl,%esi
  802333:	89 d1                	mov    %edx,%ecx
  802335:	d3 eb                	shr    %cl,%ebx
  802337:	09 f3                	or     %esi,%ebx
  802339:	89 c6                	mov    %eax,%esi
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 d8                	mov    %ebx,%eax
  80233f:	f7 74 24 08          	divl   0x8(%esp)
  802343:	89 d6                	mov    %edx,%esi
  802345:	89 c3                	mov    %eax,%ebx
  802347:	f7 64 24 0c          	mull   0xc(%esp)
  80234b:	39 d6                	cmp    %edx,%esi
  80234d:	72 19                	jb     802368 <__udivdi3+0x108>
  80234f:	89 f9                	mov    %edi,%ecx
  802351:	d3 e5                	shl    %cl,%ebp
  802353:	39 c5                	cmp    %eax,%ebp
  802355:	73 04                	jae    80235b <__udivdi3+0xfb>
  802357:	39 d6                	cmp    %edx,%esi
  802359:	74 0d                	je     802368 <__udivdi3+0x108>
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	31 ff                	xor    %edi,%edi
  80235f:	e9 3c ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  802364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802368:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80236b:	31 ff                	xor    %edi,%edi
  80236d:	e9 2e ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  802372:	66 90                	xchg   %ax,%ax
  802374:	66 90                	xchg   %ax,%ax
  802376:	66 90                	xchg   %ax,%ax
  802378:	66 90                	xchg   %ax,%ax
  80237a:	66 90                	xchg   %ax,%ax
  80237c:	66 90                	xchg   %ax,%ax
  80237e:	66 90                	xchg   %ax,%ax

00802380 <__umoddi3>:
  802380:	f3 0f 1e fb          	endbr32 
  802384:	55                   	push   %ebp
  802385:	57                   	push   %edi
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	83 ec 1c             	sub    $0x1c,%esp
  80238b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80238f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802393:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802397:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	89 da                	mov    %ebx,%edx
  80239f:	85 ff                	test   %edi,%edi
  8023a1:	75 15                	jne    8023b8 <__umoddi3+0x38>
  8023a3:	39 dd                	cmp    %ebx,%ebp
  8023a5:	76 39                	jbe    8023e0 <__umoddi3+0x60>
  8023a7:	f7 f5                	div    %ebp
  8023a9:	89 d0                	mov    %edx,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	83 c4 1c             	add    $0x1c,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5e                   	pop    %esi
  8023b2:	5f                   	pop    %edi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	39 df                	cmp    %ebx,%edi
  8023ba:	77 f1                	ja     8023ad <__umoddi3+0x2d>
  8023bc:	0f bd cf             	bsr    %edi,%ecx
  8023bf:	83 f1 1f             	xor    $0x1f,%ecx
  8023c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023c6:	75 40                	jne    802408 <__umoddi3+0x88>
  8023c8:	39 df                	cmp    %ebx,%edi
  8023ca:	72 04                	jb     8023d0 <__umoddi3+0x50>
  8023cc:	39 f5                	cmp    %esi,%ebp
  8023ce:	77 dd                	ja     8023ad <__umoddi3+0x2d>
  8023d0:	89 da                	mov    %ebx,%edx
  8023d2:	89 f0                	mov    %esi,%eax
  8023d4:	29 e8                	sub    %ebp,%eax
  8023d6:	19 fa                	sbb    %edi,%edx
  8023d8:	eb d3                	jmp    8023ad <__umoddi3+0x2d>
  8023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023e0:	89 e9                	mov    %ebp,%ecx
  8023e2:	85 ed                	test   %ebp,%ebp
  8023e4:	75 0b                	jne    8023f1 <__umoddi3+0x71>
  8023e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	f7 f5                	div    %ebp
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 d8                	mov    %ebx,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f1                	div    %ecx
  8023f7:	89 f0                	mov    %esi,%eax
  8023f9:	f7 f1                	div    %ecx
  8023fb:	89 d0                	mov    %edx,%eax
  8023fd:	31 d2                	xor    %edx,%edx
  8023ff:	eb ac                	jmp    8023ad <__umoddi3+0x2d>
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	8b 44 24 04          	mov    0x4(%esp),%eax
  80240c:	ba 20 00 00 00       	mov    $0x20,%edx
  802411:	29 c2                	sub    %eax,%edx
  802413:	89 c1                	mov    %eax,%ecx
  802415:	89 e8                	mov    %ebp,%eax
  802417:	d3 e7                	shl    %cl,%edi
  802419:	89 d1                	mov    %edx,%ecx
  80241b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80241f:	d3 e8                	shr    %cl,%eax
  802421:	89 c1                	mov    %eax,%ecx
  802423:	8b 44 24 04          	mov    0x4(%esp),%eax
  802427:	09 f9                	or     %edi,%ecx
  802429:	89 df                	mov    %ebx,%edi
  80242b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	d3 e5                	shl    %cl,%ebp
  802433:	89 d1                	mov    %edx,%ecx
  802435:	d3 ef                	shr    %cl,%edi
  802437:	89 c1                	mov    %eax,%ecx
  802439:	89 f0                	mov    %esi,%eax
  80243b:	d3 e3                	shl    %cl,%ebx
  80243d:	89 d1                	mov    %edx,%ecx
  80243f:	89 fa                	mov    %edi,%edx
  802441:	d3 e8                	shr    %cl,%eax
  802443:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802448:	09 d8                	or     %ebx,%eax
  80244a:	f7 74 24 08          	divl   0x8(%esp)
  80244e:	89 d3                	mov    %edx,%ebx
  802450:	d3 e6                	shl    %cl,%esi
  802452:	f7 e5                	mul    %ebp
  802454:	89 c7                	mov    %eax,%edi
  802456:	89 d1                	mov    %edx,%ecx
  802458:	39 d3                	cmp    %edx,%ebx
  80245a:	72 06                	jb     802462 <__umoddi3+0xe2>
  80245c:	75 0e                	jne    80246c <__umoddi3+0xec>
  80245e:	39 c6                	cmp    %eax,%esi
  802460:	73 0a                	jae    80246c <__umoddi3+0xec>
  802462:	29 e8                	sub    %ebp,%eax
  802464:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802468:	89 d1                	mov    %edx,%ecx
  80246a:	89 c7                	mov    %eax,%edi
  80246c:	89 f5                	mov    %esi,%ebp
  80246e:	8b 74 24 04          	mov    0x4(%esp),%esi
  802472:	29 fd                	sub    %edi,%ebp
  802474:	19 cb                	sbb    %ecx,%ebx
  802476:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	d3 e0                	shl    %cl,%eax
  80247f:	89 f1                	mov    %esi,%ecx
  802481:	d3 ed                	shr    %cl,%ebp
  802483:	d3 eb                	shr    %cl,%ebx
  802485:	09 e8                	or     %ebp,%eax
  802487:	89 da                	mov    %ebx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
