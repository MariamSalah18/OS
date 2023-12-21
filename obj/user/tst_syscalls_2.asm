
obj/user/tst_syscalls_2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 5d 15 00 00       	call   8015a0 <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 20 30 80 00       	mov    0x803020,%eax
  800048:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  80004e:	a1 20 30 80 00       	mov    0x803020,%eax
  800053:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 20 30 80 00       	mov    0x803020,%eax
  800060:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 40 1b 80 00       	push   $0x801b40
  80006e:	e8 e1 13 00 00       	call   801454 <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 ee 13 00 00       	call   801472 <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 20 30 80 00       	mov    0x803020,%eax
  80008c:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  800092:	a1 20 30 80 00       	mov    0x803020,%eax
  800097:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a4:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 4c 1b 80 00       	push   $0x801b4c
  8000b2:	e8 9d 13 00 00       	call   801454 <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 aa 13 00 00       	call   801472 <sys_run_env>
  8000c8:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d0:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8000d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000db:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8000e1:	89 c1                	mov    %eax,%ecx
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8000ee:	52                   	push   %edx
  8000ef:	51                   	push   %ecx
  8000f0:	50                   	push   %eax
  8000f1:	68 58 1b 80 00       	push   $0x801b58
  8000f6:	e8 59 13 00 00       	call   801454 <sys_create_env>
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	e8 66 13 00 00       	call   801472 <sys_run_env>
  80010c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 10 27 00 00       	push   $0x2710
  800117:	e8 fd 16 00 00       	call   801819 <env_sleep>
  80011c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80011f:	e8 f6 14 00 00       	call   80161a <gettst>
  800124:	85 c0                	test   %eax,%eax
  800126:	74 12                	je     80013a <_main+0x102>
		cprintf("\ntst_syscalls_2 Failed.\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 64 1b 80 00       	push   $0x801b64
  800130:	e8 1a 02 00 00       	call   80034f <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");

}
  800138:	eb 10                	jmp    80014a <_main+0x112>
	env_sleep(10000);

	if (gettst() != 0)
		cprintf("\ntst_syscalls_2 Failed.\n");
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 80 1b 80 00       	push   $0x801b80
  800142:	e8 08 02 00 00       	call   80034f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp

}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800153:	e8 6a 13 00 00       	call   8014c2 <sys_getenvindex>
  800158:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80015b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80015e:	89 d0                	mov    %edx,%eax
  800160:	01 c0                	add    %eax,%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	c1 e0 06             	shl    $0x6,%eax
  800167:	29 d0                	sub    %edx,%eax
  800169:	c1 e0 03             	shl    $0x3,%eax
  80016c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800171:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8a 40 68             	mov    0x68(%eax),%al
  80017e:	84 c0                	test   %al,%al
  800180:	74 0d                	je     80018f <libmain+0x42>
		binaryname = myEnv->prog_name;
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	83 c0 68             	add    $0x68,%eax
  80018a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800193:	7e 0a                	jle    80019f <libmain+0x52>
		binaryname = argv[0];
  800195:	8b 45 0c             	mov    0xc(%ebp),%eax
  800198:	8b 00                	mov    (%eax),%eax
  80019a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	ff 75 0c             	pushl  0xc(%ebp)
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	e8 8b fe ff ff       	call   800038 <_main>
  8001ad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b0:	e8 1a 11 00 00       	call   8012cf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 d8 1b 80 00       	push   $0x801bd8
  8001bd:	e8 8d 01 00 00       	call   80034f <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ca:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8001d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d5:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	52                   	push   %edx
  8001df:	50                   	push   %eax
  8001e0:	68 00 1c 80 00       	push   $0x801c00
  8001e5:	e8 65 01 00 00       	call   80034f <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f2:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8001f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fd:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80020e:	51                   	push   %ecx
  80020f:	52                   	push   %edx
  800210:	50                   	push   %eax
  800211:	68 28 1c 80 00       	push   $0x801c28
  800216:	e8 34 01 00 00       	call   80034f <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	50                   	push   %eax
  80022d:	68 80 1c 80 00       	push   $0x801c80
  800232:	e8 18 01 00 00       	call   80034f <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 d8 1b 80 00       	push   $0x801bd8
  800242:	e8 08 01 00 00       	call   80034f <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024a:	e8 9a 10 00 00       	call   8012e9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024f:	e8 19 00 00 00       	call   80026d <exit>
}
  800254:	90                   	nop
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 00                	push   $0x0
  800262:	e8 27 12 00 00       	call   80148e <sys_destroy_env>
  800267:	83 c4 10             	add    $0x10,%esp
}
  80026a:	90                   	nop
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <exit>:

void
exit(void)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800273:	e8 7c 12 00 00       	call   8014f4 <sys_exit_env>
}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800281:	8b 45 0c             	mov    0xc(%ebp),%eax
  800284:	8b 00                	mov    (%eax),%eax
  800286:	8d 48 01             	lea    0x1(%eax),%ecx
  800289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028c:	89 0a                	mov    %ecx,(%edx)
  80028e:	8b 55 08             	mov    0x8(%ebp),%edx
  800291:	88 d1                	mov    %dl,%cl
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a4:	75 2c                	jne    8002d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a6:	a0 24 30 80 00       	mov    0x803024,%al
  8002ab:	0f b6 c0             	movzbl %al,%eax
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	8b 12                	mov    (%edx),%edx
  8002b3:	89 d1                	mov    %edx,%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	83 c2 08             	add    $0x8,%edx
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	50                   	push   %eax
  8002bf:	51                   	push   %ecx
  8002c0:	52                   	push   %edx
  8002c1:	e8 b0 0e 00 00       	call   801176 <sys_cputs>
  8002c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d5:	8b 40 04             	mov    0x4(%eax),%eax
  8002d8:	8d 50 01             	lea    0x1(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f4:	00 00 00 
	b.cnt = 0;
  8002f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030d:	50                   	push   %eax
  80030e:	68 7b 02 80 00       	push   $0x80027b
  800313:	e8 11 02 00 00       	call   800529 <vprintfmt>
  800318:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80031b:	a0 24 30 80 00       	mov    0x803024,%al
  800320:	0f b6 c0             	movzbl %al,%eax
  800323:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800329:	83 ec 04             	sub    $0x4,%esp
  80032c:	50                   	push   %eax
  80032d:	52                   	push   %edx
  80032e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800334:	83 c0 08             	add    $0x8,%eax
  800337:	50                   	push   %eax
  800338:	e8 39 0e 00 00       	call   801176 <sys_cputs>
  80033d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800340:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800347:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <cprintf>:

int cprintf(const char *fmt, ...) {
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800355:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	ff 75 f4             	pushl  -0xc(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 73 ff ff ff       	call   8002e4 <vcprintf>
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800377:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800382:	e8 48 0f 00 00       	call   8012cf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800387:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	ff 75 f4             	pushl  -0xc(%ebp)
  800396:	50                   	push   %eax
  800397:	e8 48 ff ff ff       	call   8002e4 <vcprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003a2:	e8 42 0f 00 00       	call   8012e9 <sys_enable_interrupt>
	return cnt;
  8003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	53                   	push   %ebx
  8003b0:	83 ec 14             	sub    $0x14,%esp
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ca:	77 55                	ja     800421 <printnum+0x75>
  8003cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cf:	72 05                	jb     8003d6 <printnum+0x2a>
  8003d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d4:	77 4b                	ja     800421 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8003df:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ec:	e8 df 14 00 00       	call   8018d0 <__udivdi3>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	83 ec 04             	sub    $0x4,%esp
  8003f7:	ff 75 20             	pushl  0x20(%ebp)
  8003fa:	53                   	push   %ebx
  8003fb:	ff 75 18             	pushl  0x18(%ebp)
  8003fe:	52                   	push   %edx
  8003ff:	50                   	push   %eax
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	e8 a1 ff ff ff       	call   8003ac <printnum>
  80040b:	83 c4 20             	add    $0x20,%esp
  80040e:	eb 1a                	jmp    80042a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	ff 75 0c             	pushl  0xc(%ebp)
  800416:	ff 75 20             	pushl  0x20(%ebp)
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	ff d0                	call   *%eax
  80041e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800421:	ff 4d 1c             	decl   0x1c(%ebp)
  800424:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800428:	7f e6                	jg     800410 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800438:	53                   	push   %ebx
  800439:	51                   	push   %ecx
  80043a:	52                   	push   %edx
  80043b:	50                   	push   %eax
  80043c:	e8 9f 15 00 00       	call   8019e0 <__umoddi3>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	05 b4 1e 80 00       	add    $0x801eb4,%eax
  800449:	8a 00                	mov    (%eax),%al
  80044b:	0f be c0             	movsbl %al,%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	ff 75 0c             	pushl  0xc(%ebp)
  800454:	50                   	push   %eax
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	ff d0                	call   *%eax
  80045a:	83 c4 10             	add    $0x10,%esp
}
  80045d:	90                   	nop
  80045e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800466:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046a:	7e 1c                	jle    800488 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	8d 50 08             	lea    0x8(%eax),%edx
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	89 10                	mov    %edx,(%eax)
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	83 e8 08             	sub    $0x8,%eax
  800481:	8b 50 04             	mov    0x4(%eax),%edx
  800484:	8b 00                	mov    (%eax),%eax
  800486:	eb 40                	jmp    8004c8 <getuint+0x65>
	else if (lflag)
  800488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048c:	74 1e                	je     8004ac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 10                	mov    %edx,(%eax)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 e8 04             	sub    $0x4,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004aa:	eb 1c                	jmp    8004c8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	8d 50 04             	lea    0x4(%eax),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	83 e8 04             	sub    $0x4,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c8:	5d                   	pop    %ebp
  8004c9:	c3                   	ret    

008004ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d1:	7e 1c                	jle    8004ef <getint+0x25>
		return va_arg(*ap, long long);
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	8d 50 08             	lea    0x8(%eax),%edx
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 10                	mov    %edx,(%eax)
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	83 e8 08             	sub    $0x8,%eax
  8004e8:	8b 50 04             	mov    0x4(%eax),%edx
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	eb 38                	jmp    800527 <getint+0x5d>
	else if (lflag)
  8004ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f3:	74 1a                	je     80050f <getint+0x45>
		return va_arg(*ap, long);
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	8d 50 04             	lea    0x4(%eax),%edx
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	89 10                	mov    %edx,(%eax)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	83 e8 04             	sub    $0x4,%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	99                   	cltd   
  80050d:	eb 18                	jmp    800527 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	8d 50 04             	lea    0x4(%eax),%edx
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	89 10                	mov    %edx,(%eax)
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	83 e8 04             	sub    $0x4,%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	99                   	cltd   
}
  800527:	5d                   	pop    %ebp
  800528:	c3                   	ret    

00800529 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	56                   	push   %esi
  80052d:	53                   	push   %ebx
  80052e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800531:	eb 17                	jmp    80054a <vprintfmt+0x21>
			if (ch == '\0')
  800533:	85 db                	test   %ebx,%ebx
  800535:	0f 84 af 03 00 00    	je     8008ea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 0c             	pushl  0xc(%ebp)
  800541:	53                   	push   %ebx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	ff d0                	call   *%eax
  800547:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8d 50 01             	lea    0x1(%eax),%edx
  800550:	89 55 10             	mov    %edx,0x10(%ebp)
  800553:	8a 00                	mov    (%eax),%al
  800555:	0f b6 d8             	movzbl %al,%ebx
  800558:	83 fb 25             	cmp    $0x25,%ebx
  80055b:	75 d6                	jne    800533 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80055d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800561:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800568:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800576:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 45 10             	mov    0x10(%ebp),%eax
  800580:	8d 50 01             	lea    0x1(%eax),%edx
  800583:	89 55 10             	mov    %edx,0x10(%ebp)
  800586:	8a 00                	mov    (%eax),%al
  800588:	0f b6 d8             	movzbl %al,%ebx
  80058b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80058e:	83 f8 55             	cmp    $0x55,%eax
  800591:	0f 87 2b 03 00 00    	ja     8008c2 <vprintfmt+0x399>
  800597:	8b 04 85 d8 1e 80 00 	mov    0x801ed8(,%eax,4),%eax
  80059e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a4:	eb d7                	jmp    80057d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005aa:	eb d1                	jmp    80057d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 02             	shl    $0x2,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d8                	add    %ebx,%eax
  8005c1:	83 e8 30             	sub    $0x30,%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ca:	8a 00                	mov    (%eax),%al
  8005cc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005cf:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d2:	7e 3e                	jle    800612 <vprintfmt+0xe9>
  8005d4:	83 fb 39             	cmp    $0x39,%ebx
  8005d7:	7f 39                	jg     800612 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005dc:	eb d5                	jmp    8005b3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	83 c0 04             	add    $0x4,%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	83 e8 04             	sub    $0x4,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f2:	eb 1f                	jmp    800613 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f8:	79 83                	jns    80057d <vprintfmt+0x54>
				width = 0;
  8005fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800601:	e9 77 ff ff ff       	jmp    80057d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800606:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060d:	e9 6b ff ff ff       	jmp    80057d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800612:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800613:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800617:	0f 89 60 ff ff ff    	jns    80057d <vprintfmt+0x54>
				width = precision, precision = -1;
  80061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800623:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062a:	e9 4e ff ff ff       	jmp    80057d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800632:	e9 46 ff ff ff       	jmp    80057d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	83 c0 04             	add    $0x4,%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	83 e8 04             	sub    $0x4,%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
			break;
  800657:	e9 89 02 00 00       	jmp    8008e5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	83 c0 04             	add    $0x4,%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	83 e8 04             	sub    $0x4,%eax
  80066b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066d:	85 db                	test   %ebx,%ebx
  80066f:	79 02                	jns    800673 <vprintfmt+0x14a>
				err = -err;
  800671:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800673:	83 fb 64             	cmp    $0x64,%ebx
  800676:	7f 0b                	jg     800683 <vprintfmt+0x15a>
  800678:	8b 34 9d 20 1d 80 00 	mov    0x801d20(,%ebx,4),%esi
  80067f:	85 f6                	test   %esi,%esi
  800681:	75 19                	jne    80069c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800683:	53                   	push   %ebx
  800684:	68 c5 1e 80 00       	push   $0x801ec5
  800689:	ff 75 0c             	pushl  0xc(%ebp)
  80068c:	ff 75 08             	pushl  0x8(%ebp)
  80068f:	e8 5e 02 00 00       	call   8008f2 <printfmt>
  800694:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800697:	e9 49 02 00 00       	jmp    8008e5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069c:	56                   	push   %esi
  80069d:	68 ce 1e 80 00       	push   $0x801ece
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	ff 75 08             	pushl  0x8(%ebp)
  8006a8:	e8 45 02 00 00       	call   8008f2 <printfmt>
  8006ad:	83 c4 10             	add    $0x10,%esp
			break;
  8006b0:	e9 30 02 00 00       	jmp    8008e5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	83 c0 04             	add    $0x4,%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	83 e8 04             	sub    $0x4,%eax
  8006c4:	8b 30                	mov    (%eax),%esi
  8006c6:	85 f6                	test   %esi,%esi
  8006c8:	75 05                	jne    8006cf <vprintfmt+0x1a6>
				p = "(null)";
  8006ca:	be d1 1e 80 00       	mov    $0x801ed1,%esi
			if (width > 0 && padc != '-')
  8006cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d3:	7e 6d                	jle    800742 <vprintfmt+0x219>
  8006d5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d9:	74 67                	je     800742 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	50                   	push   %eax
  8006e2:	56                   	push   %esi
  8006e3:	e8 0c 03 00 00       	call   8009f4 <strnlen>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ee:	eb 16                	jmp    800706 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800703:	ff 4d e4             	decl   -0x1c(%ebp)
  800706:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070a:	7f e4                	jg     8006f0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070c:	eb 34                	jmp    800742 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80070e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800712:	74 1c                	je     800730 <vprintfmt+0x207>
  800714:	83 fb 1f             	cmp    $0x1f,%ebx
  800717:	7e 05                	jle    80071e <vprintfmt+0x1f5>
  800719:	83 fb 7e             	cmp    $0x7e,%ebx
  80071c:	7e 12                	jle    800730 <vprintfmt+0x207>
					putch('?', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	6a 3f                	push   $0x3f
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	eb 0f                	jmp    80073f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073f:	ff 4d e4             	decl   -0x1c(%ebp)
  800742:	89 f0                	mov    %esi,%eax
  800744:	8d 70 01             	lea    0x1(%eax),%esi
  800747:	8a 00                	mov    (%eax),%al
  800749:	0f be d8             	movsbl %al,%ebx
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	74 24                	je     800774 <vprintfmt+0x24b>
  800750:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800754:	78 b8                	js     80070e <vprintfmt+0x1e5>
  800756:	ff 4d e0             	decl   -0x20(%ebp)
  800759:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075d:	79 af                	jns    80070e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075f:	eb 13                	jmp    800774 <vprintfmt+0x24b>
				putch(' ', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	6a 20                	push   $0x20
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800771:	ff 4d e4             	decl   -0x1c(%ebp)
  800774:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800778:	7f e7                	jg     800761 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077a:	e9 66 01 00 00       	jmp    8008e5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 e8             	pushl  -0x18(%ebp)
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	e8 3c fd ff ff       	call   8004ca <getint>
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800794:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	85 d2                	test   %edx,%edx
  80079f:	79 23                	jns    8007c4 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 2d                	push   $0x2d
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b7:	f7 d8                	neg    %eax
  8007b9:	83 d2 00             	adc    $0x0,%edx
  8007bc:	f7 da                	neg    %edx
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cb:	e9 bc 00 00 00       	jmp    80088c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 84 fc ff ff       	call   800463 <getuint>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ef:	e9 98 00 00 00       	jmp    80088c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	6a 58                	push   $0x58
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	ff d0                	call   *%eax
  800801:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	6a 58                	push   $0x58
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	ff d0                	call   *%eax
  800811:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	6a 58                	push   $0x58
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
			break;
  800824:	e9 bc 00 00 00       	jmp    8008e5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 30                	push   $0x30
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	6a 78                	push   $0x78
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	ff d0                	call   *%eax
  800846:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 c0 04             	add    $0x4,%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800864:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086b:	eb 1f                	jmp    80088c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 e8             	pushl  -0x18(%ebp)
  800873:	8d 45 14             	lea    0x14(%ebp),%eax
  800876:	50                   	push   %eax
  800877:	e8 e7 fb ff ff       	call   800463 <getuint>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800882:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800885:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800893:	83 ec 04             	sub    $0x4,%esp
  800896:	52                   	push   %edx
  800897:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089a:	50                   	push   %eax
  80089b:	ff 75 f4             	pushl  -0xc(%ebp)
  80089e:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 00 fb ff ff       	call   8003ac <printnum>
  8008ac:	83 c4 20             	add    $0x20,%esp
			break;
  8008af:	eb 34                	jmp    8008e5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	53                   	push   %ebx
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
			break;
  8008c0:	eb 23                	jmp    8008e5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	6a 25                	push   $0x25
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d2:	ff 4d 10             	decl   0x10(%ebp)
  8008d5:	eb 03                	jmp    8008da <vprintfmt+0x3b1>
  8008d7:	ff 4d 10             	decl   0x10(%ebp)
  8008da:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dd:	48                   	dec    %eax
  8008de:	8a 00                	mov    (%eax),%al
  8008e0:	3c 25                	cmp    $0x25,%al
  8008e2:	75 f3                	jne    8008d7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008e4:	90                   	nop
		}
	}
  8008e5:	e9 47 fc ff ff       	jmp    800531 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ee:	5b                   	pop    %ebx
  8008ef:	5e                   	pop    %esi
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fb:	83 c0 04             	add    $0x4,%eax
  8008fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800901:	8b 45 10             	mov    0x10(%ebp),%eax
  800904:	ff 75 f4             	pushl  -0xc(%ebp)
  800907:	50                   	push   %eax
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	e8 16 fc ff ff       	call   800529 <vprintfmt>
  800913:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800916:	90                   	nop
  800917:	c9                   	leave  
  800918:	c3                   	ret    

00800919 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	8b 40 08             	mov    0x8(%eax),%eax
  800922:	8d 50 01             	lea    0x1(%eax),%edx
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	8b 10                	mov    (%eax),%edx
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	8b 40 04             	mov    0x4(%eax),%eax
  800936:	39 c2                	cmp    %eax,%edx
  800938:	73 12                	jae    80094c <sprintputch+0x33>
		*b->buf++ = ch;
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 48 01             	lea    0x1(%eax),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	89 0a                	mov    %ecx,(%edx)
  800947:	8b 55 08             	mov    0x8(%ebp),%edx
  80094a:	88 10                	mov    %dl,(%eax)
}
  80094c:	90                   	nop
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	01 d0                	add    %edx,%eax
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800970:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800974:	74 06                	je     80097c <vsnprintf+0x2d>
  800976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097a:	7f 07                	jg     800983 <vsnprintf+0x34>
		return -E_INVAL;
  80097c:	b8 03 00 00 00       	mov    $0x3,%eax
  800981:	eb 20                	jmp    8009a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800983:	ff 75 14             	pushl  0x14(%ebp)
  800986:	ff 75 10             	pushl  0x10(%ebp)
  800989:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098c:	50                   	push   %eax
  80098d:	68 19 09 80 00       	push   $0x800919
  800992:	e8 92 fb ff ff       	call   800529 <vprintfmt>
  800997:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80099a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ae:	83 c0 04             	add    $0x4,%eax
  8009b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ba:	50                   	push   %eax
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	ff 75 08             	pushl  0x8(%ebp)
  8009c1:	e8 89 ff ff ff       	call   80094f <vsnprintf>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009de:	eb 06                	jmp    8009e6 <strlen+0x15>
		n++;
  8009e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e3:	ff 45 08             	incl   0x8(%ebp)
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	84 c0                	test   %al,%al
  8009ed:	75 f1                	jne    8009e0 <strlen+0xf>
		n++;
	return n;
  8009ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a01:	eb 09                	jmp    800a0c <strnlen+0x18>
		n++;
  800a03:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a06:	ff 45 08             	incl   0x8(%ebp)
  800a09:	ff 4d 0c             	decl   0xc(%ebp)
  800a0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a10:	74 09                	je     800a1b <strnlen+0x27>
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 e8                	jne    800a03 <strnlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2c:	90                   	nop
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8d 50 01             	lea    0x1(%eax),%edx
  800a33:	89 55 08             	mov    %edx,0x8(%ebp)
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a3f:	8a 12                	mov    (%edx),%dl
  800a41:	88 10                	mov    %dl,(%eax)
  800a43:	8a 00                	mov    (%eax),%al
  800a45:	84 c0                	test   %al,%al
  800a47:	75 e4                	jne    800a2d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4c:	c9                   	leave  
  800a4d:	c3                   	ret    

00800a4e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a61:	eb 1f                	jmp    800a82 <strncpy+0x34>
		*dst++ = *src;
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8d 50 01             	lea    0x1(%eax),%edx
  800a69:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	8a 12                	mov    (%edx),%dl
  800a71:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	84 c0                	test   %al,%al
  800a7a:	74 03                	je     800a7f <strncpy+0x31>
			src++;
  800a7c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7f:	ff 45 fc             	incl   -0x4(%ebp)
  800a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a85:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a88:	72 d9                	jb     800a63 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9f:	74 30                	je     800ad1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa1:	eb 16                	jmp    800ab9 <strlcpy+0x2a>
			*dst++ = *src++;
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8d 50 01             	lea    0x1(%eax),%edx
  800aa9:	89 55 08             	mov    %edx,0x8(%ebp)
  800aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab5:	8a 12                	mov    (%edx),%dl
  800ab7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac0:	74 09                	je     800acb <strlcpy+0x3c>
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	84 c0                	test   %al,%al
  800ac9:	75 d8                	jne    800aa3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad7:	29 c2                	sub    %eax,%edx
  800ad9:	89 d0                	mov    %edx,%eax
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae0:	eb 06                	jmp    800ae8 <strcmp+0xb>
		p++, q++;
  800ae2:	ff 45 08             	incl   0x8(%ebp)
  800ae5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	84 c0                	test   %al,%al
  800aef:	74 0e                	je     800aff <strcmp+0x22>
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 10                	mov    (%eax),%dl
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	38 c2                	cmp    %al,%dl
  800afd:	74 e3                	je     800ae2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	0f b6 d0             	movzbl %al,%edx
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	29 c2                	sub    %eax,%edx
  800b11:	89 d0                	mov    %edx,%eax
}
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b18:	eb 09                	jmp    800b23 <strncmp+0xe>
		n--, p++, q++;
  800b1a:	ff 4d 10             	decl   0x10(%ebp)
  800b1d:	ff 45 08             	incl   0x8(%ebp)
  800b20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b27:	74 17                	je     800b40 <strncmp+0x2b>
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	84 c0                	test   %al,%al
  800b30:	74 0e                	je     800b40 <strncmp+0x2b>
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8a 10                	mov    (%eax),%dl
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	38 c2                	cmp    %al,%dl
  800b3e:	74 da                	je     800b1a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b44:	75 07                	jne    800b4d <strncmp+0x38>
		return 0;
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	eb 14                	jmp    800b61 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	0f b6 d0             	movzbl %al,%edx
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	0f b6 c0             	movzbl %al,%eax
  800b5d:	29 c2                	sub    %eax,%edx
  800b5f:	89 d0                	mov    %edx,%eax
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b6f:	eb 12                	jmp    800b83 <strchr+0x20>
		if (*s == c)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b79:	75 05                	jne    800b80 <strchr+0x1d>
			return (char *) s;
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	eb 11                	jmp    800b91 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b80:	ff 45 08             	incl   0x8(%ebp)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	75 e5                	jne    800b71 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 04             	sub    $0x4,%esp
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9f:	eb 0d                	jmp    800bae <strfind+0x1b>
		if (*s == c)
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba9:	74 0e                	je     800bb9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bab:	ff 45 08             	incl   0x8(%ebp)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	84 c0                	test   %al,%al
  800bb5:	75 ea                	jne    800ba1 <strfind+0xe>
  800bb7:	eb 01                	jmp    800bba <strfind+0x27>
		if (*s == c)
			break;
  800bb9:	90                   	nop
	return (char *) s;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd1:	eb 0e                	jmp    800be1 <memset+0x22>
		*p++ = c;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd6:	8d 50 01             	lea    0x1(%eax),%edx
  800bd9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be1:	ff 4d f8             	decl   -0x8(%ebp)
  800be4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be8:	79 e9                	jns    800bd3 <memset+0x14>
		*p++ = c;

	return v;
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c01:	eb 16                	jmp    800c19 <memcpy+0x2a>
		*d++ = *s++;
  800c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c22:	85 c0                	test   %eax,%eax
  800c24:	75 dd                	jne    800c03 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c40:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c43:	73 50                	jae    800c95 <memmove+0x6a>
  800c45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c48:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4b:	01 d0                	add    %edx,%eax
  800c4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c50:	76 43                	jbe    800c95 <memmove+0x6a>
		s += n;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c5e:	eb 10                	jmp    800c70 <memmove+0x45>
			*--d = *--s;
  800c60:	ff 4d f8             	decl   -0x8(%ebp)
  800c63:	ff 4d fc             	decl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	8a 10                	mov    (%eax),%dl
  800c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c6e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c76:	89 55 10             	mov    %edx,0x10(%ebp)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	75 e3                	jne    800c60 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7d:	eb 23                	jmp    800ca2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	75 dd                	jne    800c7f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb9:	eb 2a                	jmp    800ce5 <memcmp+0x3e>
		if (*s1 != *s2)
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	8a 10                	mov    (%eax),%dl
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	38 c2                	cmp    %al,%dl
  800cc7:	74 16                	je     800cdf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	0f b6 d0             	movzbl %al,%edx
  800cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 c0             	movzbl %al,%eax
  800cd9:	29 c2                	sub    %eax,%edx
  800cdb:	89 d0                	mov    %edx,%eax
  800cdd:	eb 18                	jmp    800cf7 <memcmp+0x50>
		s1++, s2++;
  800cdf:	ff 45 fc             	incl   -0x4(%ebp)
  800ce2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ceb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	75 c9                	jne    800cbb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf7:	c9                   	leave  
  800cf8:	c3                   	ret    

00800cf9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	01 d0                	add    %edx,%eax
  800d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d0a:	eb 15                	jmp    800d21 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f b6 d0             	movzbl %al,%edx
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	0f b6 c0             	movzbl %al,%eax
  800d1a:	39 c2                	cmp    %eax,%edx
  800d1c:	74 0d                	je     800d2b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d1e:	ff 45 08             	incl   0x8(%ebp)
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d27:	72 e3                	jb     800d0c <memfind+0x13>
  800d29:	eb 01                	jmp    800d2c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d2b:	90                   	nop
	return (void *) s;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d45:	eb 03                	jmp    800d4a <strtol+0x19>
		s++;
  800d47:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3c 20                	cmp    $0x20,%al
  800d51:	74 f4                	je     800d47 <strtol+0x16>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	3c 09                	cmp    $0x9,%al
  800d5a:	74 eb                	je     800d47 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3c 2b                	cmp    $0x2b,%al
  800d63:	75 05                	jne    800d6a <strtol+0x39>
		s++;
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	eb 13                	jmp    800d7d <strtol+0x4c>
	else if (*s == '-')
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	3c 2d                	cmp    $0x2d,%al
  800d71:	75 0a                	jne    800d7d <strtol+0x4c>
		s++, neg = 1;
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d81:	74 06                	je     800d89 <strtol+0x58>
  800d83:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d87:	75 20                	jne    800da9 <strtol+0x78>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 30                	cmp    $0x30,%al
  800d90:	75 17                	jne    800da9 <strtol+0x78>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	40                   	inc    %eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3c 78                	cmp    $0x78,%al
  800d9a:	75 0d                	jne    800da9 <strtol+0x78>
		s += 2, base = 16;
  800d9c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da7:	eb 28                	jmp    800dd1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	75 15                	jne    800dc4 <strtol+0x93>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	3c 30                	cmp    $0x30,%al
  800db6:	75 0c                	jne    800dc4 <strtol+0x93>
		s++, base = 8;
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc2:	eb 0d                	jmp    800dd1 <strtol+0xa0>
	else if (base == 0)
  800dc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc8:	75 07                	jne    800dd1 <strtol+0xa0>
		base = 10;
  800dca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	3c 2f                	cmp    $0x2f,%al
  800dd8:	7e 19                	jle    800df3 <strtol+0xc2>
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	3c 39                	cmp    $0x39,%al
  800de1:	7f 10                	jg     800df3 <strtol+0xc2>
			dig = *s - '0';
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	0f be c0             	movsbl %al,%eax
  800deb:	83 e8 30             	sub    $0x30,%eax
  800dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df1:	eb 42                	jmp    800e35 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	3c 60                	cmp    $0x60,%al
  800dfa:	7e 19                	jle    800e15 <strtol+0xe4>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3c 7a                	cmp    $0x7a,%al
  800e03:	7f 10                	jg     800e15 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	0f be c0             	movsbl %al,%eax
  800e0d:	83 e8 57             	sub    $0x57,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e13:	eb 20                	jmp    800e35 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	3c 40                	cmp    $0x40,%al
  800e1c:	7e 39                	jle    800e57 <strtol+0x126>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	3c 5a                	cmp    $0x5a,%al
  800e25:	7f 30                	jg     800e57 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	0f be c0             	movsbl %al,%eax
  800e2f:	83 e8 37             	sub    $0x37,%eax
  800e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e38:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e3b:	7d 19                	jge    800e56 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e43:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e51:	e9 7b ff ff ff       	jmp    800dd1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e56:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5b:	74 08                	je     800e65 <strtol+0x134>
		*endptr = (char *) s;
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e65:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e69:	74 07                	je     800e72 <strtol+0x141>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6e:	f7 d8                	neg    %eax
  800e70:	eb 03                	jmp    800e75 <strtol+0x144>
  800e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <ltostr>:

void
ltostr(long value, char *str)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e84:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e8f:	79 13                	jns    800ea4 <ltostr+0x2d>
	{
		neg = 1;
  800e91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e9e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eac:	99                   	cltd   
  800ead:	f7 f9                	idiv   %ecx
  800eaf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	01 d0                	add    %edx,%eax
  800ec2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec5:	83 c2 30             	add    $0x30,%edx
  800ec8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed2:	f7 e9                	imul   %ecx
  800ed4:	c1 fa 02             	sar    $0x2,%edx
  800ed7:	89 c8                	mov    %ecx,%eax
  800ed9:	c1 f8 1f             	sar    $0x1f,%eax
  800edc:	29 c2                	sub    %eax,%edx
  800ede:	89 d0                	mov    %edx,%eax
  800ee0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ee3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eeb:	f7 e9                	imul   %ecx
  800eed:	c1 fa 02             	sar    $0x2,%edx
  800ef0:	89 c8                	mov    %ecx,%eax
  800ef2:	c1 f8 1f             	sar    $0x1f,%eax
  800ef5:	29 c2                	sub    %eax,%edx
  800ef7:	89 d0                	mov    %edx,%eax
  800ef9:	c1 e0 02             	shl    $0x2,%eax
  800efc:	01 d0                	add    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	29 c1                	sub    %eax,%ecx
  800f02:	89 ca                	mov    %ecx,%edx
  800f04:	85 d2                	test   %edx,%edx
  800f06:	75 9c                	jne    800ea4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f12:	48                   	dec    %eax
  800f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f1a:	74 3d                	je     800f59 <ltostr+0xe2>
		start = 1 ;
  800f1c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f23:	eb 34                	jmp    800f59 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	01 d0                	add    %edx,%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	01 c2                	add    %eax,%edx
  800f3a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	01 c8                	add    %ecx,%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	01 c2                	add    %eax,%edx
  800f4e:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f51:	88 02                	mov    %al,(%edx)
		start++ ;
  800f53:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f56:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5f:	7c c4                	jl     800f25 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f61:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	01 d0                	add    %edx,%eax
  800f69:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f6c:	90                   	nop
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f75:	ff 75 08             	pushl  0x8(%ebp)
  800f78:	e8 54 fa ff ff       	call   8009d1 <strlen>
  800f7d:	83 c4 04             	add    $0x4,%esp
  800f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	e8 46 fa ff ff       	call   8009d1 <strlen>
  800f8b:	83 c4 04             	add    $0x4,%esp
  800f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f9f:	eb 17                	jmp    800fb8 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fa1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	01 c2                	add    %eax,%edx
  800fa9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	01 c8                	add    %ecx,%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fb5:	ff 45 fc             	incl   -0x4(%ebp)
  800fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fbe:	7c e1                	jl     800fa1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fce:	eb 1f                	jmp    800fef <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fde:	01 c2                	add    %eax,%edx
  800fe0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	01 c8                	add    %ecx,%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fec:	ff 45 f8             	incl   -0x8(%ebp)
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff5:	7c d9                	jl     800fd0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	c6 00 00             	movb   $0x0,(%eax)
}
  801002:	90                   	nop
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801008:	8b 45 14             	mov    0x14(%ebp),%eax
  80100b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801011:	8b 45 14             	mov    0x14(%ebp),%eax
  801014:	8b 00                	mov    (%eax),%eax
  801016:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 d0                	add    %edx,%eax
  801022:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801028:	eb 0c                	jmp    801036 <strsplit+0x31>
			*string++ = 0;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 08             	mov    %edx,0x8(%ebp)
  801033:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	84 c0                	test   %al,%al
  80103d:	74 18                	je     801057 <strsplit+0x52>
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f be c0             	movsbl %al,%eax
  801047:	50                   	push   %eax
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	e8 13 fb ff ff       	call   800b63 <strchr>
  801050:	83 c4 08             	add    $0x8,%esp
  801053:	85 c0                	test   %eax,%eax
  801055:	75 d3                	jne    80102a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	84 c0                	test   %al,%al
  80105e:	74 5a                	je     8010ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	8b 00                	mov    (%eax),%eax
  801065:	83 f8 0f             	cmp    $0xf,%eax
  801068:	75 07                	jne    801071 <strsplit+0x6c>
		{
			return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
  80106f:	eb 66                	jmp    8010d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801071:	8b 45 14             	mov    0x14(%ebp),%eax
  801074:	8b 00                	mov    (%eax),%eax
  801076:	8d 48 01             	lea    0x1(%eax),%ecx
  801079:	8b 55 14             	mov    0x14(%ebp),%edx
  80107c:	89 0a                	mov    %ecx,(%edx)
  80107e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	01 c2                	add    %eax,%edx
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108f:	eb 03                	jmp    801094 <strsplit+0x8f>
			string++;
  801091:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	84 c0                	test   %al,%al
  80109b:	74 8b                	je     801028 <strsplit+0x23>
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	0f be c0             	movsbl %al,%eax
  8010a5:	50                   	push   %eax
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	e8 b5 fa ff ff       	call   800b63 <strchr>
  8010ae:	83 c4 08             	add    $0x8,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	74 dc                	je     801091 <strsplit+0x8c>
			string++;
	}
  8010b5:	e9 6e ff ff ff       	jmp    801028 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8010df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e6:	eb 4c                	jmp    801134 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8010e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	01 d0                	add    %edx,%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 40                	cmp    $0x40,%al
  8010f4:	7e 27                	jle    80111d <str2lower+0x44>
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 5a                	cmp    $0x5a,%al
  801102:	7f 19                	jg     80111d <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801104:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80110f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801112:	01 ca                	add    %ecx,%edx
  801114:	8a 12                	mov    (%edx),%dl
  801116:	83 c2 20             	add    $0x20,%edx
  801119:	88 10                	mov    %dl,(%eax)
  80111b:	eb 14                	jmp    801131 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80111d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	01 c2                	add    %eax,%edx
  801125:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	01 c8                	add    %ecx,%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801131:	ff 45 fc             	incl   -0x4(%ebp)
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 95 f8 ff ff       	call   8009d1 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801142:	7f a4                	jg     8010e8 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80115d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801160:	8b 7d 18             	mov    0x18(%ebp),%edi
  801163:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801166:	cd 30                	int    $0x30
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80116b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801182:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	52                   	push   %edx
  80118e:	ff 75 0c             	pushl  0xc(%ebp)
  801191:	50                   	push   %eax
  801192:	6a 00                	push   $0x0
  801194:	e8 b2 ff ff ff       	call   80114b <syscall>
  801199:	83 c4 18             	add    $0x18,%esp
}
  80119c:	90                   	nop
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <sys_cgetc>:

int
sys_cgetc(void)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 01                	push   $0x1
  8011ae:	e8 98 ff ff ff       	call   80114b <syscall>
  8011b3:	83 c4 18             	add    $0x18,%esp
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	52                   	push   %edx
  8011c8:	50                   	push   %eax
  8011c9:	6a 05                	push   $0x5
  8011cb:	e8 7b ff ff ff       	call   80114b <syscall>
  8011d0:	83 c4 18             	add    $0x18,%esp
}
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	56                   	push   %esi
  8011d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011da:	8b 75 18             	mov    0x18(%ebp),%esi
  8011dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	51                   	push   %ecx
  8011ec:	52                   	push   %edx
  8011ed:	50                   	push   %eax
  8011ee:	6a 06                	push   $0x6
  8011f0:	e8 56 ff ff ff       	call   80114b <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    

008011ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	52                   	push   %edx
  80120f:	50                   	push   %eax
  801210:	6a 07                	push   $0x7
  801212:	e8 34 ff ff ff       	call   80114b <syscall>
  801217:	83 c4 18             	add    $0x18,%esp
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	ff 75 08             	pushl  0x8(%ebp)
  80122b:	6a 08                	push   $0x8
  80122d:	e8 19 ff ff ff       	call   80114b <syscall>
  801232:	83 c4 18             	add    $0x18,%esp
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 09                	push   $0x9
  801246:	e8 00 ff ff ff       	call   80114b <syscall>
  80124b:	83 c4 18             	add    $0x18,%esp
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 0a                	push   $0xa
  80125f:	e8 e7 fe ff ff       	call   80114b <syscall>
  801264:	83 c4 18             	add    $0x18,%esp
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 0b                	push   $0xb
  801278:	e8 ce fe ff ff       	call   80114b <syscall>
  80127d:	83 c4 18             	add    $0x18,%esp
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 0c                	push   $0xc
  801291:	e8 b5 fe ff ff       	call   80114b <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	ff 75 08             	pushl  0x8(%ebp)
  8012a9:	6a 0d                	push   $0xd
  8012ab:	e8 9b fe ff ff       	call   80114b <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 0e                	push   $0xe
  8012c4:	e8 82 fe ff ff       	call   80114b <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	90                   	nop
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 11                	push   $0x11
  8012de:	e8 68 fe ff ff       	call   80114b <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
}
  8012e6:	90                   	nop
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 12                	push   $0x12
  8012f8:	e8 4e fe ff ff       	call   80114b <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_cputc>:


void
sys_cputc(const char c)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80130f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	50                   	push   %eax
  80131c:	6a 13                	push   $0x13
  80131e:	e8 28 fe ff ff       	call   80114b <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 14                	push   $0x14
  801338:	e8 0e fe ff ff       	call   80114b <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	90                   	nop
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	50                   	push   %eax
  801353:	6a 15                	push   $0x15
  801355:	e8 f1 fd ff ff       	call   80114b <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	52                   	push   %edx
  80136f:	50                   	push   %eax
  801370:	6a 18                	push   $0x18
  801372:	e8 d4 fd ff ff       	call   80114b <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80137f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	52                   	push   %edx
  80138c:	50                   	push   %eax
  80138d:	6a 16                	push   $0x16
  80138f:	e8 b7 fd ff ff       	call   80114b <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	90                   	nop
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80139d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	52                   	push   %edx
  8013aa:	50                   	push   %eax
  8013ab:	6a 17                	push   $0x17
  8013ad:	e8 99 fd ff ff       	call   80114b <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	90                   	nop
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	6a 00                	push   $0x0
  8013d0:	51                   	push   %ecx
  8013d1:	52                   	push   %edx
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	50                   	push   %eax
  8013d6:	6a 19                	push   $0x19
  8013d8:	e8 6e fd ff ff       	call   80114b <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	52                   	push   %edx
  8013f2:	50                   	push   %eax
  8013f3:	6a 1a                	push   $0x1a
  8013f5:	e8 51 fd ff ff       	call   80114b <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801402:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801405:	8b 55 0c             	mov    0xc(%ebp),%edx
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	51                   	push   %ecx
  801410:	52                   	push   %edx
  801411:	50                   	push   %eax
  801412:	6a 1b                	push   $0x1b
  801414:	e8 32 fd ff ff       	call   80114b <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	52                   	push   %edx
  80142e:	50                   	push   %eax
  80142f:	6a 1c                	push   $0x1c
  801431:	e8 15 fd ff ff       	call   80114b <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 1d                	push   $0x1d
  80144a:	e8 fc fc ff ff       	call   80114b <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	6a 00                	push   $0x0
  80145c:	ff 75 14             	pushl  0x14(%ebp)
  80145f:	ff 75 10             	pushl  0x10(%ebp)
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	6a 1e                	push   $0x1e
  801468:	e8 de fc ff ff       	call   80114b <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	50                   	push   %eax
  801481:	6a 1f                	push   $0x1f
  801483:	e8 c3 fc ff ff       	call   80114b <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	90                   	nop
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	50                   	push   %eax
  80149d:	6a 20                	push   $0x20
  80149f:	e8 a7 fc ff ff       	call   80114b <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 02                	push   $0x2
  8014b8:	e8 8e fc ff ff       	call   80114b <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 03                	push   $0x3
  8014d1:	e8 75 fc ff ff       	call   80114b <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 04                	push   $0x4
  8014ea:	e8 5c fc ff ff       	call   80114b <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_exit_env>:


void sys_exit_env(void)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 21                	push   $0x21
  801503:	e8 43 fc ff ff       	call   80114b <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	90                   	nop
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801514:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801517:	8d 50 04             	lea    0x4(%eax),%edx
  80151a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	6a 22                	push   $0x22
  801527:	e8 1f fc ff ff       	call   80114b <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
	return result;
  80152f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801535:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801538:	89 01                	mov    %eax,(%ecx)
  80153a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	c9                   	leave  
  801541:	c2 04 00             	ret    $0x4

00801544 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	ff 75 10             	pushl  0x10(%ebp)
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	6a 10                	push   $0x10
  801556:	e8 f0 fb ff ff       	call   80114b <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
	return ;
  80155e:	90                   	nop
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sys_rcr2>:
uint32 sys_rcr2()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 23                	push   $0x23
  801570:	e8 d6 fb ff ff       	call   80114b <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801586:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	50                   	push   %eax
  801593:	6a 24                	push   $0x24
  801595:	e8 b1 fb ff ff       	call   80114b <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
	return ;
  80159d:	90                   	nop
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <rsttst>:
void rsttst()
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 26                	push   $0x26
  8015af:	e8 97 fb ff ff       	call   80114b <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b7:	90                   	nop
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015c6:	8b 55 18             	mov    0x18(%ebp),%edx
  8015c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015cd:	52                   	push   %edx
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 10             	pushl  0x10(%ebp)
  8015d2:	ff 75 0c             	pushl  0xc(%ebp)
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	6a 25                	push   $0x25
  8015da:	e8 6c fb ff ff       	call   80114b <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e2:	90                   	nop
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <chktst>:
void chktst(uint32 n)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	6a 27                	push   $0x27
  8015f5:	e8 51 fb ff ff       	call   80114b <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fd:	90                   	nop
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <inctst>:

void inctst()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 28                	push   $0x28
  80160f:	e8 37 fb ff ff       	call   80114b <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
	return ;
  801617:	90                   	nop
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <gettst>:
uint32 gettst()
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 29                	push   $0x29
  801629:	e8 1d fb ff ff       	call   80114b <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 2a                	push   $0x2a
  801645:	e8 01 fb ff ff       	call   80114b <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
  80164d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801650:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801654:	75 07                	jne    80165d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801656:	b8 01 00 00 00       	mov    $0x1,%eax
  80165b:	eb 05                	jmp    801662 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 2a                	push   $0x2a
  801676:	e8 d0 fa ff ff       	call   80114b <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
  80167e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801681:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801685:	75 07                	jne    80168e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801687:	b8 01 00 00 00       	mov    $0x1,%eax
  80168c:	eb 05                	jmp    801693 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 2a                	push   $0x2a
  8016a7:	e8 9f fa ff ff       	call   80114b <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
  8016af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016b2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016b6:	75 07                	jne    8016bf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bd:	eb 05                	jmp    8016c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 2a                	push   $0x2a
  8016d8:	e8 6e fa ff ff       	call   80114b <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
  8016e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016e3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016e7:	75 07                	jne    8016f0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ee:	eb 05                	jmp    8016f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	6a 2b                	push   $0x2b
  801707:	e8 3f fa ff ff       	call   80114b <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
	return ;
  80170f:	90                   	nop
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801716:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801719:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	6a 00                	push   $0x0
  801724:	53                   	push   %ebx
  801725:	51                   	push   %ecx
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 2c                	push   $0x2c
  80172a:	e8 1c fa ff ff       	call   80114b <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 2d                	push   $0x2d
  80174a:	e8 fc f9 ff ff       	call   80114b <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801757:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	51                   	push   %ecx
  801763:	ff 75 10             	pushl  0x10(%ebp)
  801766:	52                   	push   %edx
  801767:	50                   	push   %eax
  801768:	6a 2e                	push   $0x2e
  80176a:	e8 dc f9 ff ff       	call   80114b <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 0f                	push   $0xf
  801786:	e8 c0 f9 ff ff       	call   80114b <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	50                   	push   %eax
  8017a0:	6a 2f                	push   $0x2f
  8017a2:	e8 a4 f9 ff ff       	call   80114b <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp

}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	6a 30                	push   $0x30
  8017bd:	e8 89 f9 ff ff       	call   80114b <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
	return;
  8017c5:	90                   	nop
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 31                	push   $0x31
  8017d9:	e8 6d f9 ff ff       	call   80114b <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
	return;
  8017e1:	90                   	nop
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 32                	push   $0x32
  8017f3:	e8 53 f9 ff ff       	call   80114b <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	50                   	push   %eax
  80180c:	6a 33                	push   $0x33
  80180e:	e8 38 f9 ff ff       	call   80114b <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	90                   	nop
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80181f:	8b 55 08             	mov    0x8(%ebp),%edx
  801822:	89 d0                	mov    %edx,%eax
  801824:	c1 e0 02             	shl    $0x2,%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801830:	01 d0                	add    %edx,%eax
  801832:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801839:	01 d0                	add    %edx,%eax
  80183b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801842:	01 d0                	add    %edx,%eax
  801844:	c1 e0 04             	shl    $0x4,%eax
  801847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80184a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801851:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	50                   	push   %eax
  801858:	e8 b1 fc ff ff       	call   80150e <sys_get_virtual_time>
  80185d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801860:	eb 41                	jmp    8018a3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801862:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	50                   	push   %eax
  801869:	e8 a0 fc ff ff       	call   80150e <sys_get_virtual_time>
  80186e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801871:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801877:	29 c2                	sub    %eax,%edx
  801879:	89 d0                	mov    %edx,%eax
  80187b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80187e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801884:	89 d1                	mov    %edx,%ecx
  801886:	29 c1                	sub    %eax,%ecx
  801888:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80188b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	0f 97 c0             	seta   %al
  801893:	0f b6 c0             	movzbl %al,%eax
  801896:	29 c1                	sub    %eax,%ecx
  801898:	89 c8                	mov    %ecx,%eax
  80189a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80189d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a9:	72 b7                	jb     801862 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018bb:	eb 03                	jmp    8018c0 <busy_wait+0x12>
  8018bd:	ff 45 fc             	incl   -0x4(%ebp)
  8018c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018c6:	72 f5                	jb     8018bd <busy_wait+0xf>
	return i;
  8018c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    
  8018cd:	66 90                	xchg   %ax,%ax
  8018cf:	90                   	nop

008018d0 <__udivdi3>:
  8018d0:	55                   	push   %ebp
  8018d1:	57                   	push   %edi
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 1c             	sub    $0x1c,%esp
  8018d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018e7:	89 ca                	mov    %ecx,%edx
  8018e9:	89 f8                	mov    %edi,%eax
  8018eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018ef:	85 f6                	test   %esi,%esi
  8018f1:	75 2d                	jne    801920 <__udivdi3+0x50>
  8018f3:	39 cf                	cmp    %ecx,%edi
  8018f5:	77 65                	ja     80195c <__udivdi3+0x8c>
  8018f7:	89 fd                	mov    %edi,%ebp
  8018f9:	85 ff                	test   %edi,%edi
  8018fb:	75 0b                	jne    801908 <__udivdi3+0x38>
  8018fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801902:	31 d2                	xor    %edx,%edx
  801904:	f7 f7                	div    %edi
  801906:	89 c5                	mov    %eax,%ebp
  801908:	31 d2                	xor    %edx,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	f7 f5                	div    %ebp
  80190e:	89 c1                	mov    %eax,%ecx
  801910:	89 d8                	mov    %ebx,%eax
  801912:	f7 f5                	div    %ebp
  801914:	89 cf                	mov    %ecx,%edi
  801916:	89 fa                	mov    %edi,%edx
  801918:	83 c4 1c             	add    $0x1c,%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5f                   	pop    %edi
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    
  801920:	39 ce                	cmp    %ecx,%esi
  801922:	77 28                	ja     80194c <__udivdi3+0x7c>
  801924:	0f bd fe             	bsr    %esi,%edi
  801927:	83 f7 1f             	xor    $0x1f,%edi
  80192a:	75 40                	jne    80196c <__udivdi3+0x9c>
  80192c:	39 ce                	cmp    %ecx,%esi
  80192e:	72 0a                	jb     80193a <__udivdi3+0x6a>
  801930:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801934:	0f 87 9e 00 00 00    	ja     8019d8 <__udivdi3+0x108>
  80193a:	b8 01 00 00 00       	mov    $0x1,%eax
  80193f:	89 fa                	mov    %edi,%edx
  801941:	83 c4 1c             	add    $0x1c,%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    
  801949:	8d 76 00             	lea    0x0(%esi),%esi
  80194c:	31 ff                	xor    %edi,%edi
  80194e:	31 c0                	xor    %eax,%eax
  801950:	89 fa                	mov    %edi,%edx
  801952:	83 c4 1c             	add    $0x1c,%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5f                   	pop    %edi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    
  80195a:	66 90                	xchg   %ax,%ax
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	f7 f7                	div    %edi
  801960:	31 ff                	xor    %edi,%edi
  801962:	89 fa                	mov    %edi,%edx
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
  80196c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801971:	89 eb                	mov    %ebp,%ebx
  801973:	29 fb                	sub    %edi,%ebx
  801975:	89 f9                	mov    %edi,%ecx
  801977:	d3 e6                	shl    %cl,%esi
  801979:	89 c5                	mov    %eax,%ebp
  80197b:	88 d9                	mov    %bl,%cl
  80197d:	d3 ed                	shr    %cl,%ebp
  80197f:	89 e9                	mov    %ebp,%ecx
  801981:	09 f1                	or     %esi,%ecx
  801983:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801987:	89 f9                	mov    %edi,%ecx
  801989:	d3 e0                	shl    %cl,%eax
  80198b:	89 c5                	mov    %eax,%ebp
  80198d:	89 d6                	mov    %edx,%esi
  80198f:	88 d9                	mov    %bl,%cl
  801991:	d3 ee                	shr    %cl,%esi
  801993:	89 f9                	mov    %edi,%ecx
  801995:	d3 e2                	shl    %cl,%edx
  801997:	8b 44 24 08          	mov    0x8(%esp),%eax
  80199b:	88 d9                	mov    %bl,%cl
  80199d:	d3 e8                	shr    %cl,%eax
  80199f:	09 c2                	or     %eax,%edx
  8019a1:	89 d0                	mov    %edx,%eax
  8019a3:	89 f2                	mov    %esi,%edx
  8019a5:	f7 74 24 0c          	divl   0xc(%esp)
  8019a9:	89 d6                	mov    %edx,%esi
  8019ab:	89 c3                	mov    %eax,%ebx
  8019ad:	f7 e5                	mul    %ebp
  8019af:	39 d6                	cmp    %edx,%esi
  8019b1:	72 19                	jb     8019cc <__udivdi3+0xfc>
  8019b3:	74 0b                	je     8019c0 <__udivdi3+0xf0>
  8019b5:	89 d8                	mov    %ebx,%eax
  8019b7:	31 ff                	xor    %edi,%edi
  8019b9:	e9 58 ff ff ff       	jmp    801916 <__udivdi3+0x46>
  8019be:	66 90                	xchg   %ax,%ax
  8019c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019c4:	89 f9                	mov    %edi,%ecx
  8019c6:	d3 e2                	shl    %cl,%edx
  8019c8:	39 c2                	cmp    %eax,%edx
  8019ca:	73 e9                	jae    8019b5 <__udivdi3+0xe5>
  8019cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019cf:	31 ff                	xor    %edi,%edi
  8019d1:	e9 40 ff ff ff       	jmp    801916 <__udivdi3+0x46>
  8019d6:	66 90                	xchg   %ax,%ax
  8019d8:	31 c0                	xor    %eax,%eax
  8019da:	e9 37 ff ff ff       	jmp    801916 <__udivdi3+0x46>
  8019df:	90                   	nop

008019e0 <__umoddi3>:
  8019e0:	55                   	push   %ebp
  8019e1:	57                   	push   %edi
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 1c             	sub    $0x1c,%esp
  8019e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ff:	89 f3                	mov    %esi,%ebx
  801a01:	89 fa                	mov    %edi,%edx
  801a03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a07:	89 34 24             	mov    %esi,(%esp)
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	75 1a                	jne    801a28 <__umoddi3+0x48>
  801a0e:	39 f7                	cmp    %esi,%edi
  801a10:	0f 86 a2 00 00 00    	jbe    801ab8 <__umoddi3+0xd8>
  801a16:	89 c8                	mov    %ecx,%eax
  801a18:	89 f2                	mov    %esi,%edx
  801a1a:	f7 f7                	div    %edi
  801a1c:	89 d0                	mov    %edx,%eax
  801a1e:	31 d2                	xor    %edx,%edx
  801a20:	83 c4 1c             	add    $0x1c,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    
  801a28:	39 f0                	cmp    %esi,%eax
  801a2a:	0f 87 ac 00 00 00    	ja     801adc <__umoddi3+0xfc>
  801a30:	0f bd e8             	bsr    %eax,%ebp
  801a33:	83 f5 1f             	xor    $0x1f,%ebp
  801a36:	0f 84 ac 00 00 00    	je     801ae8 <__umoddi3+0x108>
  801a3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a41:	29 ef                	sub    %ebp,%edi
  801a43:	89 fe                	mov    %edi,%esi
  801a45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 e0                	shl    %cl,%eax
  801a4d:	89 d7                	mov    %edx,%edi
  801a4f:	89 f1                	mov    %esi,%ecx
  801a51:	d3 ef                	shr    %cl,%edi
  801a53:	09 c7                	or     %eax,%edi
  801a55:	89 e9                	mov    %ebp,%ecx
  801a57:	d3 e2                	shl    %cl,%edx
  801a59:	89 14 24             	mov    %edx,(%esp)
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	d3 e0                	shl    %cl,%eax
  801a60:	89 c2                	mov    %eax,%edx
  801a62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a66:	d3 e0                	shl    %cl,%eax
  801a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a70:	89 f1                	mov    %esi,%ecx
  801a72:	d3 e8                	shr    %cl,%eax
  801a74:	09 d0                	or     %edx,%eax
  801a76:	d3 eb                	shr    %cl,%ebx
  801a78:	89 da                	mov    %ebx,%edx
  801a7a:	f7 f7                	div    %edi
  801a7c:	89 d3                	mov    %edx,%ebx
  801a7e:	f7 24 24             	mull   (%esp)
  801a81:	89 c6                	mov    %eax,%esi
  801a83:	89 d1                	mov    %edx,%ecx
  801a85:	39 d3                	cmp    %edx,%ebx
  801a87:	0f 82 87 00 00 00    	jb     801b14 <__umoddi3+0x134>
  801a8d:	0f 84 91 00 00 00    	je     801b24 <__umoddi3+0x144>
  801a93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a97:	29 f2                	sub    %esi,%edx
  801a99:	19 cb                	sbb    %ecx,%ebx
  801a9b:	89 d8                	mov    %ebx,%eax
  801a9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801aa1:	d3 e0                	shl    %cl,%eax
  801aa3:	89 e9                	mov    %ebp,%ecx
  801aa5:	d3 ea                	shr    %cl,%edx
  801aa7:	09 d0                	or     %edx,%eax
  801aa9:	89 e9                	mov    %ebp,%ecx
  801aab:	d3 eb                	shr    %cl,%ebx
  801aad:	89 da                	mov    %ebx,%edx
  801aaf:	83 c4 1c             	add    $0x1c,%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5f                   	pop    %edi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    
  801ab7:	90                   	nop
  801ab8:	89 fd                	mov    %edi,%ebp
  801aba:	85 ff                	test   %edi,%edi
  801abc:	75 0b                	jne    801ac9 <__umoddi3+0xe9>
  801abe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac3:	31 d2                	xor    %edx,%edx
  801ac5:	f7 f7                	div    %edi
  801ac7:	89 c5                	mov    %eax,%ebp
  801ac9:	89 f0                	mov    %esi,%eax
  801acb:	31 d2                	xor    %edx,%edx
  801acd:	f7 f5                	div    %ebp
  801acf:	89 c8                	mov    %ecx,%eax
  801ad1:	f7 f5                	div    %ebp
  801ad3:	89 d0                	mov    %edx,%eax
  801ad5:	e9 44 ff ff ff       	jmp    801a1e <__umoddi3+0x3e>
  801ada:	66 90                	xchg   %ax,%ax
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	89 f2                	mov    %esi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	3b 04 24             	cmp    (%esp),%eax
  801aeb:	72 06                	jb     801af3 <__umoddi3+0x113>
  801aed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801af1:	77 0f                	ja     801b02 <__umoddi3+0x122>
  801af3:	89 f2                	mov    %esi,%edx
  801af5:	29 f9                	sub    %edi,%ecx
  801af7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801afb:	89 14 24             	mov    %edx,(%esp)
  801afe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b02:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b06:	8b 14 24             	mov    (%esp),%edx
  801b09:	83 c4 1c             	add    $0x1c,%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
  801b11:	8d 76 00             	lea    0x0(%esi),%esi
  801b14:	2b 04 24             	sub    (%esp),%eax
  801b17:	19 fa                	sbb    %edi,%edx
  801b19:	89 d1                	mov    %edx,%ecx
  801b1b:	89 c6                	mov    %eax,%esi
  801b1d:	e9 71 ff ff ff       	jmp    801a93 <__umoddi3+0xb3>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b28:	72 ea                	jb     801b14 <__umoddi3+0x134>
  801b2a:	89 d9                	mov    %ebx,%ecx
  801b2c:	e9 62 ff ff ff       	jmp    801a93 <__umoddi3+0xb3>
