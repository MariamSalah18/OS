
obj/user/tst_page_replacement_FIFO_1:     file format elf32-i386


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
  800031:	e8 19 01 00 00       	call   80014f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedFinalVAs[11] = {
		0xeebfd000, /*will be created during the call of sys_check_WS_list*/ //Stack
		0x80a000, 0x80b000, 0x804000, 0x80c000,0x807000,0x808000,0x800000,0x801000,0x809000,0x803000,	//Code & Data
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80003e:	6a 01                	push   $0x1
  800040:	68 00 00 20 00       	push   $0x200000
  800045:	6a 0b                	push   $0xb
  800047:	68 20 30 80 00       	push   $0x803020
  80004c:	e8 ec 18 00 00       	call   80193d <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 80 1c 80 00       	push   $0x801c80
  800065:	6a 1d                	push   $0x1d
  800067:	68 f4 1c 80 00       	push   $0x801cf4
  80006c:	e8 0c 02 00 00       	call   80027d <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800071:	e8 aa 13 00 00       	call   801420 <sys_calculate_free_frames>
  800076:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800079:	e8 ed 13 00 00       	call   80146b <sys_pf_calculate_allocated_pages>
  80007e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  800081:	a0 bf e0 80 00       	mov    0x80e0bf,%al
  800086:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  800089:	a0 bf f0 80 00       	mov    0x80f0bf,%al
  80008e:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;
	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800091:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800098:	eb 26                	jmp    8000c0 <_main+0x88>
	{
		arr[i] = 'A' ;
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	05 c0 30 80 00       	add    $0x8030c0,%eax
  8000a2:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8000a5:	a1 00 30 80 00       	mov    0x803000,%eax
  8000aa:	8a 00                	mov    (%eax),%al
  8000ac:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *ptr2 ;
  8000af:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b4:	8a 00                	mov    (%eax),%al
  8000b6:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage1 = arr[PAGE_SIZE*11-1];
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4,garbage5;
	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000b9:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000c0:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000c7:	7e d1                	jle    80009a <_main+0x62>
	}

	//===================
	//cprintf("Checking PAGE FIFO algorithm... \n");
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x807000, 1);
  8000c9:	6a 01                	push   $0x1
  8000cb:	68 00 70 80 00       	push   $0x807000
  8000d0:	6a 0b                	push   $0xb
  8000d2:	68 60 30 80 00       	push   $0x803060
  8000d7:	e8 61 18 00 00       	call   80193d <sys_check_WS_list>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8000e2:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8000e6:	74 14                	je     8000fc <_main+0xc4>
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	68 18 1d 80 00       	push   $0x801d18
  8000f0:	6a 3c                	push   $0x3c
  8000f2:	68 f4 1c 80 00       	push   $0x801cf4
  8000f7:	e8 81 01 00 00       	call   80027d <_panic>
	}
	{
		if (garbage4 != *ptr) panic("test failed!");
  8000fc:	a1 00 30 80 00       	mov    0x803000,%eax
  800101:	8a 00                	mov    (%eax),%al
  800103:	3a 45 f7             	cmp    -0x9(%ebp),%al
  800106:	74 14                	je     80011c <_main+0xe4>
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	68 64 1d 80 00       	push   $0x801d64
  800110:	6a 3f                	push   $0x3f
  800112:	68 f4 1c 80 00       	push   $0x801cf4
  800117:	e8 61 01 00 00       	call   80027d <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  80011c:	a1 04 30 80 00       	mov    0x803004,%eax
  800121:	8a 00                	mov    (%eax),%al
  800123:	3a 45 f6             	cmp    -0xa(%ebp),%al
  800126:	74 14                	je     80013c <_main+0x104>
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	68 64 1d 80 00       	push   $0x801d64
  800130:	6a 40                	push   $0x40
  800132:	68 f4 1c 80 00       	push   $0x801cf4
  800137:	e8 41 01 00 00       	call   80027d <_panic>
	}
	cprintf("Congratulations!! test PAGE replacement [FIFO 1] is completed successfully.\n");
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	68 74 1d 80 00       	push   $0x801d74
  800144:	e8 f1 03 00 00       	call   80053a <cprintf>
  800149:	83 c4 10             	add    $0x10,%esp
	return;
  80014c:	90                   	nop
}
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800155:	e8 51 15 00 00       	call   8016ab <sys_getenvindex>
  80015a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80015d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800160:	89 d0                	mov    %edx,%eax
  800162:	01 c0                	add    %eax,%eax
  800164:	01 d0                	add    %edx,%eax
  800166:	c1 e0 06             	shl    $0x6,%eax
  800169:	29 d0                	sub    %edx,%eax
  80016b:	c1 e0 03             	shl    $0x3,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80017d:	8a 40 68             	mov    0x68(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800184:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800189:	83 c0 68             	add    $0x68,%eax
  80018c:	a3 8c 30 80 00       	mov    %eax,0x80308c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x52>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 8c 30 80 00       	mov    %eax,0x80308c

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b2:	e8 01 13 00 00       	call   8014b8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 dc 1d 80 00       	push   $0x801ddc
  8001bf:	e8 76 03 00 00       	call   80053a <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c7:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001cc:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8001d2:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001d7:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	68 04 1e 80 00       	push   $0x801e04
  8001e7:	e8 4e 03 00 00       	call   80053a <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ef:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001f4:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8001fa:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001ff:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800205:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80020a:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800210:	51                   	push   %ecx
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 2c 1e 80 00       	push   $0x801e2c
  800218:	e8 1d 03 00 00       	call   80053a <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800225:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 84 1e 80 00       	push   $0x801e84
  800234:	e8 01 03 00 00       	call   80053a <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 dc 1d 80 00       	push   $0x801ddc
  800244:	e8 f1 02 00 00       	call   80053a <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024c:	e8 81 12 00 00       	call   8014d2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 0e 14 00 00       	call   801677 <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 63 14 00 00       	call   8016dd <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800283:	8d 45 10             	lea    0x10(%ebp),%eax
  800286:	83 c0 04             	add    $0x4,%eax
  800289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028c:	a1 98 f1 80 00       	mov    0x80f198,%eax
  800291:	85 c0                	test   %eax,%eax
  800293:	74 16                	je     8002ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  800295:	a1 98 f1 80 00       	mov    0x80f198,%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 98 1e 80 00       	push   $0x801e98
  8002a3:	e8 92 02 00 00       	call   80053a <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ab:	a1 8c 30 80 00       	mov    0x80308c,%eax
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	50                   	push   %eax
  8002b7:	68 9d 1e 80 00       	push   $0x801e9d
  8002bc:	e8 79 02 00 00       	call   80053a <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cd:	50                   	push   %eax
  8002ce:	e8 fc 01 00 00       	call   8004cf <vcprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	6a 00                	push   $0x0
  8002db:	68 b9 1e 80 00       	push   $0x801eb9
  8002e0:	e8 ea 01 00 00       	call   8004cf <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e8:	e8 82 ff ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  8002ed:	eb fe                	jmp    8002ed <_panic+0x70>

008002ef <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f5:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002fa:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	74 14                	je     80031b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	68 bc 1e 80 00       	push   $0x801ebc
  80030f:	6a 26                	push   $0x26
  800311:	68 08 1f 80 00       	push   $0x801f08
  800316:	e8 62 ff ff ff       	call   80027d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800329:	e9 c5 00 00 00       	jmp    8003f3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800331:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 d0                	add    %edx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	75 08                	jne    80034b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800343:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800346:	e9 a5 00 00 00       	jmp    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80034b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800359:	eb 69                	jmp    8003c4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800360:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8a 40 04             	mov    0x4(%eax),%al
  800377:	84 c0                	test   %al,%al
  800379:	75 46                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800380:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800386:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800389:	89 d0                	mov    %edx,%eax
  80038b:	01 c0                	add    %eax,%eax
  80038d:	01 d0                	add    %edx,%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800399:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b4:	39 c2                	cmp    %eax,%edx
  8003b6:	75 09                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bf:	eb 15                	jmp    8003d6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c1:	ff 45 e8             	incl   -0x18(%ebp)
  8003c4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003c9:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8003cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	77 85                	ja     80035b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003da:	75 14                	jne    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 14 1f 80 00       	push   $0x801f14
  8003e4:	6a 3a                	push   $0x3a
  8003e6:	68 08 1f 80 00       	push   $0x801f08
  8003eb:	e8 8d fe ff ff       	call   80027d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f0:	ff 45 f0             	incl   -0x10(%ebp)
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f9:	0f 8c 2f ff ff ff    	jl     80032e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800406:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040d:	eb 26                	jmp    800435 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040f:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800414:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80041a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041d:	89 d0                	mov    %edx,%eax
  80041f:	01 c0                	add    %eax,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	c1 e0 03             	shl    $0x3,%eax
  800426:	01 c8                	add    %ecx,%eax
  800428:	8a 40 04             	mov    0x4(%eax),%al
  80042b:	3c 01                	cmp    $0x1,%al
  80042d:	75 03                	jne    800432 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80042f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800432:	ff 45 e0             	incl   -0x20(%ebp)
  800435:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80043a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	39 c2                	cmp    %eax,%edx
  800445:	77 c8                	ja     80040f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80044d:	74 14                	je     800463 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80044f:	83 ec 04             	sub    $0x4,%esp
  800452:	68 68 1f 80 00       	push   $0x801f68
  800457:	6a 44                	push   $0x44
  800459:	68 08 1f 80 00       	push   $0x801f08
  80045e:	e8 1a fe ff ff       	call   80027d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800463:	90                   	nop
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	8d 48 01             	lea    0x1(%eax),%ecx
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 0a                	mov    %ecx,(%edx)
  800479:	8b 55 08             	mov    0x8(%ebp),%edx
  80047c:	88 d1                	mov    %dl,%cl
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048f:	75 2c                	jne    8004bd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800491:	a0 a4 30 80 00       	mov    0x8030a4,%al
  800496:	0f b6 c0             	movzbl %al,%eax
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	8b 12                	mov    (%edx),%edx
  80049e:	89 d1                	mov    %edx,%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	83 c2 08             	add    $0x8,%edx
  8004a6:	83 ec 04             	sub    $0x4,%esp
  8004a9:	50                   	push   %eax
  8004aa:	51                   	push   %ecx
  8004ab:	52                   	push   %edx
  8004ac:	e8 ae 0e 00 00       	call   80135f <sys_cputs>
  8004b1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	8b 40 04             	mov    0x4(%eax),%eax
  8004c3:	8d 50 01             	lea    0x1(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004cc:	90                   	nop
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004df:	00 00 00 
	b.cnt = 0;
  8004e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	ff 75 08             	pushl  0x8(%ebp)
  8004f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f8:	50                   	push   %eax
  8004f9:	68 66 04 80 00       	push   $0x800466
  8004fe:	e8 11 02 00 00       	call   800714 <vprintfmt>
  800503:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800506:	a0 a4 30 80 00       	mov    0x8030a4,%al
  80050b:	0f b6 c0             	movzbl %al,%eax
  80050e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800514:	83 ec 04             	sub    $0x4,%esp
  800517:	50                   	push   %eax
  800518:	52                   	push   %edx
  800519:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051f:	83 c0 08             	add    $0x8,%eax
  800522:	50                   	push   %eax
  800523:	e8 37 0e 00 00       	call   80135f <sys_cputs>
  800528:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052b:	c6 05 a4 30 80 00 00 	movb   $0x0,0x8030a4
	return b.cnt;
  800532:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <cprintf>:

int cprintf(const char *fmt, ...) {
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800540:	c6 05 a4 30 80 00 01 	movb   $0x1,0x8030a4
	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 73 ff ff ff       	call   8004cf <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056d:	e8 46 0f 00 00       	call   8014b8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800572:	8d 45 0c             	lea    0xc(%ebp),%eax
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	ff 75 f4             	pushl  -0xc(%ebp)
  800581:	50                   	push   %eax
  800582:	e8 48 ff ff ff       	call   8004cf <vcprintf>
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80058d:	e8 40 0f 00 00       	call   8014d2 <sys_enable_interrupt>
	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 14             	sub    $0x14,%esp
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005aa:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b5:	77 55                	ja     80060c <printnum+0x75>
  8005b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ba:	72 05                	jb     8005c1 <printnum+0x2a>
  8005bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bf:	77 4b                	ja     80060c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cf:	52                   	push   %edx
  8005d0:	50                   	push   %eax
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d7:	e8 28 14 00 00       	call   801a04 <__udivdi3>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	ff 75 20             	pushl  0x20(%ebp)
  8005e5:	53                   	push   %ebx
  8005e6:	ff 75 18             	pushl  0x18(%ebp)
  8005e9:	52                   	push   %edx
  8005ea:	50                   	push   %eax
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 a1 ff ff ff       	call   800597 <printnum>
  8005f6:	83 c4 20             	add    $0x20,%esp
  8005f9:	eb 1a                	jmp    800615 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	ff 75 0c             	pushl  0xc(%ebp)
  800601:	ff 75 20             	pushl  0x20(%ebp)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060c:	ff 4d 1c             	decl   0x1c(%ebp)
  80060f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800613:	7f e6                	jg     8005fb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800615:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800618:	bb 00 00 00 00       	mov    $0x0,%ebx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800623:	53                   	push   %ebx
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	50                   	push   %eax
  800627:	e8 e8 14 00 00       	call   801b14 <__umoddi3>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	05 d4 21 80 00       	add    $0x8021d4,%eax
  800634:	8a 00                	mov    (%eax),%al
  800636:	0f be c0             	movsbl %al,%eax
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	50                   	push   %eax
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	ff d0                	call   *%eax
  800645:	83 c4 10             	add    $0x10,%esp
}
  800648:	90                   	nop
  800649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800651:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800655:	7e 1c                	jle    800673 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 50 08             	lea    0x8(%eax),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	89 10                	mov    %edx,(%eax)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	83 e8 08             	sub    $0x8,%eax
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	eb 40                	jmp    8006b3 <getuint+0x65>
	else if (lflag)
  800673:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800677:	74 1e                	je     800697 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 10                	mov    %edx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	eb 1c                	jmp    8006b3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8d 50 04             	lea    0x4(%eax),%edx
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	89 10                	mov    %edx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	83 e8 04             	sub    $0x4,%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b3:	5d                   	pop    %ebp
  8006b4:	c3                   	ret    

008006b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006bc:	7e 1c                	jle    8006da <getint+0x25>
		return va_arg(*ap, long long);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	8d 50 08             	lea    0x8(%eax),%edx
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 10                	mov    %edx,(%eax)
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 e8 08             	sub    $0x8,%eax
  8006d3:	8b 50 04             	mov    0x4(%eax),%edx
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	eb 38                	jmp    800712 <getint+0x5d>
	else if (lflag)
  8006da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006de:	74 1a                	je     8006fa <getint+0x45>
		return va_arg(*ap, long);
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	89 10                	mov    %edx,(%eax)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 e8 04             	sub    $0x4,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	99                   	cltd   
  8006f8:	eb 18                	jmp    800712 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
}
  800712:	5d                   	pop    %ebp
  800713:	c3                   	ret    

00800714 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	56                   	push   %esi
  800718:	53                   	push   %ebx
  800719:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	eb 17                	jmp    800735 <vprintfmt+0x21>
			if (ch == '\0')
  80071e:	85 db                	test   %ebx,%ebx
  800720:	0f 84 af 03 00 00    	je     800ad5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	53                   	push   %ebx
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	8b 45 10             	mov    0x10(%ebp),%eax
  800738:	8d 50 01             	lea    0x1(%eax),%edx
  80073b:	89 55 10             	mov    %edx,0x10(%ebp)
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f b6 d8             	movzbl %al,%ebx
  800743:	83 fb 25             	cmp    $0x25,%ebx
  800746:	75 d6                	jne    80071e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800748:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80074c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800753:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800761:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 45 10             	mov    0x10(%ebp),%eax
  80076b:	8d 50 01             	lea    0x1(%eax),%edx
  80076e:	89 55 10             	mov    %edx,0x10(%ebp)
  800771:	8a 00                	mov    (%eax),%al
  800773:	0f b6 d8             	movzbl %al,%ebx
  800776:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800779:	83 f8 55             	cmp    $0x55,%eax
  80077c:	0f 87 2b 03 00 00    	ja     800aad <vprintfmt+0x399>
  800782:	8b 04 85 f8 21 80 00 	mov    0x8021f8(,%eax,4),%eax
  800789:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078f:	eb d7                	jmp    800768 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800791:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800795:	eb d1                	jmp    800768 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800797:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	c1 e0 02             	shl    $0x2,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	01 c0                	add    %eax,%eax
  8007aa:	01 d8                	add    %ebx,%eax
  8007ac:	83 e8 30             	sub    $0x30,%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ba:	83 fb 2f             	cmp    $0x2f,%ebx
  8007bd:	7e 3e                	jle    8007fd <vprintfmt+0xe9>
  8007bf:	83 fb 39             	cmp    $0x39,%ebx
  8007c2:	7f 39                	jg     8007fd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c7:	eb d5                	jmp    80079e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007dd:	eb 1f                	jmp    8007fe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e3:	79 83                	jns    800768 <vprintfmt+0x54>
				width = 0;
  8007e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ec:	e9 77 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f8:	e9 6b ff ff ff       	jmp    800768 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007fd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800802:	0f 89 60 ff ff ff    	jns    800768 <vprintfmt+0x54>
				width = precision, precision = -1;
  800808:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800815:	e9 4e ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80081d:	e9 46 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			break;
  800842:	e9 89 02 00 00       	jmp    800ad0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800858:	85 db                	test   %ebx,%ebx
  80085a:	79 02                	jns    80085e <vprintfmt+0x14a>
				err = -err;
  80085c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085e:	83 fb 64             	cmp    $0x64,%ebx
  800861:	7f 0b                	jg     80086e <vprintfmt+0x15a>
  800863:	8b 34 9d 40 20 80 00 	mov    0x802040(,%ebx,4),%esi
  80086a:	85 f6                	test   %esi,%esi
  80086c:	75 19                	jne    800887 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086e:	53                   	push   %ebx
  80086f:	68 e5 21 80 00       	push   $0x8021e5
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 08             	pushl  0x8(%ebp)
  80087a:	e8 5e 02 00 00       	call   800add <printfmt>
  80087f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800882:	e9 49 02 00 00       	jmp    800ad0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800887:	56                   	push   %esi
  800888:	68 ee 21 80 00       	push   $0x8021ee
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 08             	pushl  0x8(%ebp)
  800893:	e8 45 02 00 00       	call   800add <printfmt>
  800898:	83 c4 10             	add    $0x10,%esp
			break;
  80089b:	e9 30 02 00 00       	jmp    800ad0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 c0 04             	add    $0x4,%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 30                	mov    (%eax),%esi
  8008b1:	85 f6                	test   %esi,%esi
  8008b3:	75 05                	jne    8008ba <vprintfmt+0x1a6>
				p = "(null)";
  8008b5:	be f1 21 80 00       	mov    $0x8021f1,%esi
			if (width > 0 && padc != '-')
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	7e 6d                	jle    80092d <vprintfmt+0x219>
  8008c0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c4:	74 67                	je     80092d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	50                   	push   %eax
  8008cd:	56                   	push   %esi
  8008ce:	e8 0c 03 00 00       	call   800bdf <strnlen>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d9:	eb 16                	jmp    8008f1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	50                   	push   %eax
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7f e4                	jg     8008db <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f7:	eb 34                	jmp    80092d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fd:	74 1c                	je     80091b <vprintfmt+0x207>
  8008ff:	83 fb 1f             	cmp    $0x1f,%ebx
  800902:	7e 05                	jle    800909 <vprintfmt+0x1f5>
  800904:	83 fb 7e             	cmp    $0x7e,%ebx
  800907:	7e 12                	jle    80091b <vprintfmt+0x207>
					putch('?', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	6a 3f                	push   $0x3f
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092a:	ff 4d e4             	decl   -0x1c(%ebp)
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	8d 70 01             	lea    0x1(%eax),%esi
  800932:	8a 00                	mov    (%eax),%al
  800934:	0f be d8             	movsbl %al,%ebx
  800937:	85 db                	test   %ebx,%ebx
  800939:	74 24                	je     80095f <vprintfmt+0x24b>
  80093b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093f:	78 b8                	js     8008f9 <vprintfmt+0x1e5>
  800941:	ff 4d e0             	decl   -0x20(%ebp)
  800944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800948:	79 af                	jns    8008f9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094a:	eb 13                	jmp    80095f <vprintfmt+0x24b>
				putch(' ', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 20                	push   $0x20
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095c:	ff 4d e4             	decl   -0x1c(%ebp)
  80095f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800963:	7f e7                	jg     80094c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800965:	e9 66 01 00 00       	jmp    800ad0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 3c fd ff ff       	call   8006b5 <getint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800988:	85 d2                	test   %edx,%edx
  80098a:	79 23                	jns    8009af <vprintfmt+0x29b>
				putch('-', putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	6a 2d                	push   $0x2d
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a2:	f7 d8                	neg    %eax
  8009a4:	83 d2 00             	adc    $0x0,%edx
  8009a7:	f7 da                	neg    %edx
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b6:	e9 bc 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 84 fc ff ff       	call   80064e <getuint>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009da:	e9 98 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			break;
  800a0f:	e9 bc 00 00 00       	jmp    800ad0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 30                	push   $0x30
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 78                	push   $0x78
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 c0 04             	add    $0x4,%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 e8 04             	sub    $0x4,%eax
  800a43:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a56:	eb 1f                	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a61:	50                   	push   %eax
  800a62:	e8 e7 fb ff ff       	call   80064e <getuint>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a77:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	52                   	push   %edx
  800a82:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a85:	50                   	push   %eax
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	e8 00 fb ff ff       	call   800597 <printnum>
  800a97:	83 c4 20             	add    $0x20,%esp
			break;
  800a9a:	eb 34                	jmp    800ad0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			break;
  800aab:	eb 23                	jmp    800ad0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	6a 25                	push   $0x25
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abd:	ff 4d 10             	decl   0x10(%ebp)
  800ac0:	eb 03                	jmp    800ac5 <vprintfmt+0x3b1>
  800ac2:	ff 4d 10             	decl   0x10(%ebp)
  800ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac8:	48                   	dec    %eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	3c 25                	cmp    $0x25,%al
  800acd:	75 f3                	jne    800ac2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acf:	90                   	nop
		}
	}
  800ad0:	e9 47 fc ff ff       	jmp    80071c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
  800aef:	ff 75 f4             	pushl  -0xc(%ebp)
  800af2:	50                   	push   %eax
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 16 fc ff ff       	call   800714 <vprintfmt>
  800afe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b01:	90                   	nop
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 40 08             	mov    0x8(%eax),%eax
  800b0d:	8d 50 01             	lea    0x1(%eax),%edx
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 10                	mov    (%eax),%edx
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8b 40 04             	mov    0x4(%eax),%eax
  800b21:	39 c2                	cmp    %eax,%edx
  800b23:	73 12                	jae    800b37 <sprintputch+0x33>
		*b->buf++ = ch;
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b30:	89 0a                	mov    %ecx,(%edx)
  800b32:	8b 55 08             	mov    0x8(%ebp),%edx
  800b35:	88 10                	mov    %dl,(%eax)
}
  800b37:	90                   	nop
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	01 d0                	add    %edx,%eax
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5f:	74 06                	je     800b67 <vsnprintf+0x2d>
  800b61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b65:	7f 07                	jg     800b6e <vsnprintf+0x34>
		return -E_INVAL;
  800b67:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6c:	eb 20                	jmp    800b8e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6e:	ff 75 14             	pushl  0x14(%ebp)
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b77:	50                   	push   %eax
  800b78:	68 04 0b 80 00       	push   $0x800b04
  800b7d:	e8 92 fb ff ff       	call   800714 <vprintfmt>
  800b82:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b96:	8d 45 10             	lea    0x10(%ebp),%eax
  800b99:	83 c0 04             	add    $0x4,%eax
  800b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba5:	50                   	push   %eax
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 89 ff ff ff       	call   800b3a <vsnprintf>
  800bb1:	83 c4 10             	add    $0x10,%esp
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc9:	eb 06                	jmp    800bd1 <strlen+0x15>
		n++;
  800bcb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bce:	ff 45 08             	incl   0x8(%ebp)
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	84 c0                	test   %al,%al
  800bd8:	75 f1                	jne    800bcb <strlen+0xf>
		n++;
	return n;
  800bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bec:	eb 09                	jmp    800bf7 <strnlen+0x18>
		n++;
  800bee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf1:	ff 45 08             	incl   0x8(%ebp)
  800bf4:	ff 4d 0c             	decl   0xc(%ebp)
  800bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfb:	74 09                	je     800c06 <strnlen+0x27>
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 e8                	jne    800bee <strnlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c17:	90                   	nop
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2a:	8a 12                	mov    (%edx),%dl
  800c2c:	88 10                	mov    %dl,(%eax)
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	84 c0                	test   %al,%al
  800c32:	75 e4                	jne    800c18 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4c:	eb 1f                	jmp    800c6d <strncpy+0x34>
		*dst++ = *src;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 08             	mov    %edx,0x8(%ebp)
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	84 c0                	test   %al,%al
  800c65:	74 03                	je     800c6a <strncpy+0x31>
			src++;
  800c67:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6a:	ff 45 fc             	incl   -0x4(%ebp)
  800c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c70:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c73:	72 d9                	jb     800c4e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8a:	74 30                	je     800cbc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c8c:	eb 16                	jmp    800ca4 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca0:	8a 12                	mov    (%edx),%dl
  800ca2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca4:	ff 4d 10             	decl   0x10(%ebp)
  800ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cab:	74 09                	je     800cb6 <strlcpy+0x3c>
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	84 c0                	test   %al,%al
  800cb4:	75 d8                	jne    800c8e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc2:	29 c2                	sub    %eax,%edx
  800cc4:	89 d0                	mov    %edx,%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ccb:	eb 06                	jmp    800cd3 <strcmp+0xb>
		p++, q++;
  800ccd:	ff 45 08             	incl   0x8(%ebp)
  800cd0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	84 c0                	test   %al,%al
  800cda:	74 0e                	je     800cea <strcmp+0x22>
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 10                	mov    (%eax),%dl
  800ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	38 c2                	cmp    %al,%dl
  800ce8:	74 e3                	je     800ccd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	0f b6 d0             	movzbl %al,%edx
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	0f b6 c0             	movzbl %al,%eax
  800cfa:	29 c2                	sub    %eax,%edx
  800cfc:	89 d0                	mov    %edx,%eax
}
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d03:	eb 09                	jmp    800d0e <strncmp+0xe>
		n--, p++, q++;
  800d05:	ff 4d 10             	decl   0x10(%ebp)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d12:	74 17                	je     800d2b <strncmp+0x2b>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 0e                	je     800d2b <strncmp+0x2b>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 da                	je     800d05 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2f:	75 07                	jne    800d38 <strncmp+0x38>
		return 0;
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
  800d36:	eb 14                	jmp    800d4c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	0f b6 c0             	movzbl %al,%eax
  800d48:	29 c2                	sub    %eax,%edx
  800d4a:	89 d0                	mov    %edx,%eax
}
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5a:	eb 12                	jmp    800d6e <strchr+0x20>
		if (*s == c)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d64:	75 05                	jne    800d6b <strchr+0x1d>
			return (char *) s;
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	eb 11                	jmp    800d7c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 e5                	jne    800d5c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 0d                	jmp    800d99 <strfind+0x1b>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	74 0e                	je     800da4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d96:	ff 45 08             	incl   0x8(%ebp)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 ea                	jne    800d8c <strfind+0xe>
  800da2:	eb 01                	jmp    800da5 <strfind+0x27>
		if (*s == c)
			break;
  800da4:	90                   	nop
	return (char *) s;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db6:	8b 45 10             	mov    0x10(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dbc:	eb 0e                	jmp    800dcc <memset+0x22>
		*p++ = c;
  800dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc1:	8d 50 01             	lea    0x1(%eax),%edx
  800dc4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dcc:	ff 4d f8             	decl   -0x8(%ebp)
  800dcf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dd3:	79 e9                	jns    800dbe <memset+0x14>
		*p++ = c;

	return v;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dec:	eb 16                	jmp    800e04 <memcpy+0x2a>
		*d++ = *s++;
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dfd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e00:	8a 12                	mov    (%edx),%dl
  800e02:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 dd                	jne    800dee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2e:	73 50                	jae    800e80 <memmove+0x6a>
  800e30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3b:	76 43                	jbe    800e80 <memmove+0x6a>
		s += n;
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e49:	eb 10                	jmp    800e5b <memmove+0x45>
			*--d = *--s;
  800e4b:	ff 4d f8             	decl   -0x8(%ebp)
  800e4e:	ff 4d fc             	decl   -0x4(%ebp)
  800e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e54:	8a 10                	mov    (%eax),%dl
  800e56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e59:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e61:	89 55 10             	mov    %edx,0x10(%ebp)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	75 e3                	jne    800e4b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e68:	eb 23                	jmp    800e8d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6d:	8d 50 01             	lea    0x1(%eax),%edx
  800e70:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e79:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e7c:	8a 12                	mov    (%edx),%dl
  800e7e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e86:	89 55 10             	mov    %edx,0x10(%ebp)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	75 dd                	jne    800e6a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea4:	eb 2a                	jmp    800ed0 <memcmp+0x3e>
		if (*s1 != *s2)
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8a 10                	mov    (%eax),%dl
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	38 c2                	cmp    %al,%dl
  800eb2:	74 16                	je     800eca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	0f b6 d0             	movzbl %al,%edx
  800ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f b6 c0             	movzbl %al,%eax
  800ec4:	29 c2                	sub    %eax,%edx
  800ec6:	89 d0                	mov    %edx,%eax
  800ec8:	eb 18                	jmp    800ee2 <memcmp+0x50>
		s1++, s2++;
  800eca:	ff 45 fc             	incl   -0x4(%ebp)
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	75 c9                	jne    800ea6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 d0                	add    %edx,%eax
  800ef2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef5:	eb 15                	jmp    800f0c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f b6 d0             	movzbl %al,%edx
  800eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f02:	0f b6 c0             	movzbl %al,%eax
  800f05:	39 c2                	cmp    %eax,%edx
  800f07:	74 0d                	je     800f16 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f09:	ff 45 08             	incl   0x8(%ebp)
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f12:	72 e3                	jb     800ef7 <memfind+0x13>
  800f14:	eb 01                	jmp    800f17 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f16:	90                   	nop
	return (void *) s;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1a:	c9                   	leave  
  800f1b:	c3                   	ret    

00800f1c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f29:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f30:	eb 03                	jmp    800f35 <strtol+0x19>
		s++;
  800f32:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 20                	cmp    $0x20,%al
  800f3c:	74 f4                	je     800f32 <strtol+0x16>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 09                	cmp    $0x9,%al
  800f45:	74 eb                	je     800f32 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 2b                	cmp    $0x2b,%al
  800f4e:	75 05                	jne    800f55 <strtol+0x39>
		s++;
  800f50:	ff 45 08             	incl   0x8(%ebp)
  800f53:	eb 13                	jmp    800f68 <strtol+0x4c>
	else if (*s == '-')
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 2d                	cmp    $0x2d,%al
  800f5c:	75 0a                	jne    800f68 <strtol+0x4c>
		s++, neg = 1;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
  800f61:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6c:	74 06                	je     800f74 <strtol+0x58>
  800f6e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f72:	75 20                	jne    800f94 <strtol+0x78>
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 30                	cmp    $0x30,%al
  800f7b:	75 17                	jne    800f94 <strtol+0x78>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	40                   	inc    %eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 78                	cmp    $0x78,%al
  800f85:	75 0d                	jne    800f94 <strtol+0x78>
		s += 2, base = 16;
  800f87:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f8b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f92:	eb 28                	jmp    800fbc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	75 15                	jne    800faf <strtol+0x93>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 30                	cmp    $0x30,%al
  800fa1:	75 0c                	jne    800faf <strtol+0x93>
		s++, base = 8;
  800fa3:	ff 45 08             	incl   0x8(%ebp)
  800fa6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fad:	eb 0d                	jmp    800fbc <strtol+0xa0>
	else if (base == 0)
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 07                	jne    800fbc <strtol+0xa0>
		base = 10;
  800fb5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 2f                	cmp    $0x2f,%al
  800fc3:	7e 19                	jle    800fde <strtol+0xc2>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 39                	cmp    $0x39,%al
  800fcc:	7f 10                	jg     800fde <strtol+0xc2>
			dig = *s - '0';
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	0f be c0             	movsbl %al,%eax
  800fd6:	83 e8 30             	sub    $0x30,%eax
  800fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fdc:	eb 42                	jmp    801020 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 60                	cmp    $0x60,%al
  800fe5:	7e 19                	jle    801000 <strtol+0xe4>
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 7a                	cmp    $0x7a,%al
  800fee:	7f 10                	jg     801000 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	0f be c0             	movsbl %al,%eax
  800ff8:	83 e8 57             	sub    $0x57,%eax
  800ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffe:	eb 20                	jmp    801020 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	3c 40                	cmp    $0x40,%al
  801007:	7e 39                	jle    801042 <strtol+0x126>
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 5a                	cmp    $0x5a,%al
  801010:	7f 30                	jg     801042 <strtol+0x126>
			dig = *s - 'A' + 10;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	0f be c0             	movsbl %al,%eax
  80101a:	83 e8 37             	sub    $0x37,%eax
  80101d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801023:	3b 45 10             	cmp    0x10(%ebp),%eax
  801026:	7d 19                	jge    801041 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801028:	ff 45 08             	incl   0x8(%ebp)
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801032:	89 c2                	mov    %eax,%edx
  801034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80103c:	e9 7b ff ff ff       	jmp    800fbc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801041:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801042:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801046:	74 08                	je     801050 <strtol+0x134>
		*endptr = (char *) s;
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801050:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801054:	74 07                	je     80105d <strtol+0x141>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	f7 d8                	neg    %eax
  80105b:	eb 03                	jmp    801060 <strtol+0x144>
  80105d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <ltostr>:

void
ltostr(long value, char *str)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801068:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107a:	79 13                	jns    80108f <ltostr+0x2d>
	{
		neg = 1;
  80107c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801089:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80108c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801097:	99                   	cltd   
  801098:	f7 f9                	idiv   %ecx
  80109a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80109d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a0:	8d 50 01             	lea    0x1(%eax),%edx
  8010a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	01 d0                	add    %edx,%eax
  8010ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b0:	83 c2 30             	add    $0x30,%edx
  8010b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010bd:	f7 e9                	imul   %ecx
  8010bf:	c1 fa 02             	sar    $0x2,%edx
  8010c2:	89 c8                	mov    %ecx,%eax
  8010c4:	c1 f8 1f             	sar    $0x1f,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d6:	f7 e9                	imul   %ecx
  8010d8:	c1 fa 02             	sar    $0x2,%edx
  8010db:	89 c8                	mov    %ecx,%eax
  8010dd:	c1 f8 1f             	sar    $0x1f,%eax
  8010e0:	29 c2                	sub    %eax,%edx
  8010e2:	89 d0                	mov    %edx,%eax
  8010e4:	c1 e0 02             	shl    $0x2,%eax
  8010e7:	01 d0                	add    %edx,%eax
  8010e9:	01 c0                	add    %eax,%eax
  8010eb:	29 c1                	sub    %eax,%ecx
  8010ed:	89 ca                	mov    %ecx,%edx
  8010ef:	85 d2                	test   %edx,%edx
  8010f1:	75 9c                	jne    80108f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	48                   	dec    %eax
  8010fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801101:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801105:	74 3d                	je     801144 <ltostr+0xe2>
		start = 1 ;
  801107:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110e:	eb 34                	jmp    801144 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80111d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	01 c2                	add    %eax,%edx
  801125:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	01 c8                	add    %ecx,%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801131:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	01 c2                	add    %eax,%edx
  801139:	8a 45 eb             	mov    -0x15(%ebp),%al
  80113c:	88 02                	mov    %al,(%edx)
		start++ ;
  80113e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801141:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801147:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80114a:	7c c4                	jl     801110 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80114c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801157:	90                   	nop
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801160:	ff 75 08             	pushl  0x8(%ebp)
  801163:	e8 54 fa ff ff       	call   800bbc <strlen>
  801168:	83 c4 04             	add    $0x4,%esp
  80116b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	e8 46 fa ff ff       	call   800bbc <strlen>
  801176:	83 c4 04             	add    $0x4,%esp
  801179:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118a:	eb 17                	jmp    8011a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80118c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118f:	8b 45 10             	mov    0x10(%ebp),%eax
  801192:	01 c2                	add    %eax,%edx
  801194:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	01 c8                	add    %ecx,%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a9:	7c e1                	jl     80118c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b9:	eb 1f                	jmp    8011da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011be:	8d 50 01             	lea    0x1(%eax),%edx
  8011c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c4:	89 c2                	mov    %eax,%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d7:	ff 45 f8             	incl   -0x8(%ebp)
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e0:	7c d9                	jl     8011bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ed:	90                   	nop
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ff:	8b 00                	mov    (%eax),%eax
  801201:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801213:	eb 0c                	jmp    801221 <strsplit+0x31>
			*string++ = 0;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8d 50 01             	lea    0x1(%eax),%edx
  80121b:	89 55 08             	mov    %edx,0x8(%ebp)
  80121e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	74 18                	je     801242 <strsplit+0x52>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	0f be c0             	movsbl %al,%eax
  801232:	50                   	push   %eax
  801233:	ff 75 0c             	pushl  0xc(%ebp)
  801236:	e8 13 fb ff ff       	call   800d4e <strchr>
  80123b:	83 c4 08             	add    $0x8,%esp
  80123e:	85 c0                	test   %eax,%eax
  801240:	75 d3                	jne    801215 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	84 c0                	test   %al,%al
  801249:	74 5a                	je     8012a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80124b:	8b 45 14             	mov    0x14(%ebp),%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	83 f8 0f             	cmp    $0xf,%eax
  801253:	75 07                	jne    80125c <strsplit+0x6c>
		{
			return 0;
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	eb 66                	jmp    8012c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80125c:	8b 45 14             	mov    0x14(%ebp),%eax
  80125f:	8b 00                	mov    (%eax),%eax
  801261:	8d 48 01             	lea    0x1(%eax),%ecx
  801264:	8b 55 14             	mov    0x14(%ebp),%edx
  801267:	89 0a                	mov    %ecx,(%edx)
  801269:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 c2                	add    %eax,%edx
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127a:	eb 03                	jmp    80127f <strsplit+0x8f>
			string++;
  80127c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	74 8b                	je     801213 <strsplit+0x23>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f be c0             	movsbl %al,%eax
  801290:	50                   	push   %eax
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	e8 b5 fa ff ff       	call   800d4e <strchr>
  801299:	83 c4 08             	add    $0x8,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	74 dc                	je     80127c <strsplit+0x8c>
			string++;
	}
  8012a0:	e9 6e ff ff ff       	jmp    801213 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a9:	8b 00                	mov    (%eax),%eax
  8012ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d1:	eb 4c                	jmp    80131f <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8012d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	01 d0                	add    %edx,%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 40                	cmp    $0x40,%al
  8012df:	7e 27                	jle    801308 <str2lower+0x44>
  8012e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 5a                	cmp    $0x5a,%al
  8012ed:	7f 19                	jg     801308 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	01 d0                	add    %edx,%eax
  8012f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	01 ca                	add    %ecx,%edx
  8012ff:	8a 12                	mov    (%edx),%dl
  801301:	83 c2 20             	add    $0x20,%edx
  801304:	88 10                	mov    %dl,(%eax)
  801306:	eb 14                	jmp    80131c <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	01 c2                	add    %eax,%edx
  801310:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	01 c8                	add    %ecx,%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80131c:	ff 45 fc             	incl   -0x4(%ebp)
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	e8 95 f8 ff ff       	call   800bbc <strlen>
  801327:	83 c4 04             	add    $0x4,%esp
  80132a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80132d:	7f a4                	jg     8012d3 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	57                   	push   %edi
  801338:	56                   	push   %esi
  801339:	53                   	push   %ebx
  80133a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8b 55 0c             	mov    0xc(%ebp),%edx
  801343:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801346:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801349:	8b 7d 18             	mov    0x18(%ebp),%edi
  80134c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80134f:	cd 30                	int    $0x30
  801351:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801354:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	5b                   	pop    %ebx
  80135b:	5e                   	pop    %esi
  80135c:	5f                   	pop    %edi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	8b 45 10             	mov    0x10(%ebp),%eax
  801368:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80136b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	52                   	push   %edx
  801377:	ff 75 0c             	pushl  0xc(%ebp)
  80137a:	50                   	push   %eax
  80137b:	6a 00                	push   $0x0
  80137d:	e8 b2 ff ff ff       	call   801334 <syscall>
  801382:	83 c4 18             	add    $0x18,%esp
}
  801385:	90                   	nop
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_cgetc>:

int
sys_cgetc(void)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 01                	push   $0x1
  801397:	e8 98 ff ff ff       	call   801334 <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	52                   	push   %edx
  8013b1:	50                   	push   %eax
  8013b2:	6a 05                	push   $0x5
  8013b4:	e8 7b ff ff ff       	call   801334 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	56                   	push   %esi
  8013d3:	53                   	push   %ebx
  8013d4:	51                   	push   %ecx
  8013d5:	52                   	push   %edx
  8013d6:	50                   	push   %eax
  8013d7:	6a 06                	push   $0x6
  8013d9:	e8 56 ff ff ff       	call   801334 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    

008013e8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	52                   	push   %edx
  8013f8:	50                   	push   %eax
  8013f9:	6a 07                	push   $0x7
  8013fb:	e8 34 ff ff ff       	call   801334 <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	ff 75 0c             	pushl  0xc(%ebp)
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	6a 08                	push   $0x8
  801416:	e8 19 ff ff ff       	call   801334 <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 09                	push   $0x9
  80142f:	e8 00 ff ff ff       	call   801334 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 0a                	push   $0xa
  801448:	e8 e7 fe ff ff       	call   801334 <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 0b                	push   $0xb
  801461:	e8 ce fe ff ff       	call   801334 <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 0c                	push   $0xc
  80147a:	e8 b5 fe ff ff       	call   801334 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	6a 0d                	push   $0xd
  801494:	e8 9b fe ff ff       	call   801334 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 0e                	push   $0xe
  8014ad:	e8 82 fe ff ff       	call   801334 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 11                	push   $0x11
  8014c7:	e8 68 fe ff ff       	call   801334 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 12                	push   $0x12
  8014e1:	e8 4e fe ff ff       	call   801334 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_cputc>:


void
sys_cputc(const char c)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	50                   	push   %eax
  801505:	6a 13                	push   $0x13
  801507:	e8 28 fe ff ff       	call   801334 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 14                	push   $0x14
  801521:	e8 0e fe ff ff       	call   801334 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	6a 15                	push   $0x15
  80153e:	e8 f1 fd ff ff       	call   801334 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	52                   	push   %edx
  801558:	50                   	push   %eax
  801559:	6a 18                	push   $0x18
  80155b:	e8 d4 fd ff ff       	call   801334 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	52                   	push   %edx
  801575:	50                   	push   %eax
  801576:	6a 16                	push   $0x16
  801578:	e8 b7 fd ff ff       	call   801334 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	90                   	nop
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801586:	8b 55 0c             	mov    0xc(%ebp),%edx
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 17                	push   $0x17
  801596:	e8 99 fd ff ff       	call   801334 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	90                   	nop
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	51                   	push   %ecx
  8015ba:	52                   	push   %edx
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	50                   	push   %eax
  8015bf:	6a 19                	push   $0x19
  8015c1:	e8 6e fd ff ff       	call   801334 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	52                   	push   %edx
  8015db:	50                   	push   %eax
  8015dc:	6a 1a                	push   $0x1a
  8015de:	e8 51 fd ff ff       	call   801334 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	51                   	push   %ecx
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	6a 1b                	push   $0x1b
  8015fd:	e8 32 fd ff ff       	call   801334 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80160a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	52                   	push   %edx
  801617:	50                   	push   %eax
  801618:	6a 1c                	push   $0x1c
  80161a:	e8 15 fd ff ff       	call   801334 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 1d                	push   $0x1d
  801633:	e8 fc fc ff ff       	call   801334 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	6a 00                	push   $0x0
  801645:	ff 75 14             	pushl  0x14(%ebp)
  801648:	ff 75 10             	pushl  0x10(%ebp)
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	50                   	push   %eax
  80164f:	6a 1e                	push   $0x1e
  801651:	e8 de fc ff ff       	call   801334 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	50                   	push   %eax
  80166a:	6a 1f                	push   $0x1f
  80166c:	e8 c3 fc ff ff       	call   801334 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	50                   	push   %eax
  801686:	6a 20                	push   $0x20
  801688:	e8 a7 fc ff ff       	call   801334 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 02                	push   $0x2
  8016a1:	e8 8e fc ff ff       	call   801334 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 03                	push   $0x3
  8016ba:	e8 75 fc ff ff       	call   801334 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 04                	push   $0x4
  8016d3:	e8 5c fc ff ff       	call   801334 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_exit_env>:


void sys_exit_env(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 21                	push   $0x21
  8016ec:	e8 43 fc ff ff       	call   801334 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801700:	8d 50 04             	lea    0x4(%eax),%edx
  801703:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 22                	push   $0x22
  801710:	e8 1f fc ff ff       	call   801334 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
	return result;
  801718:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801721:	89 01                	mov    %eax,(%ecx)
  801723:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	c9                   	leave  
  80172a:	c2 04 00             	ret    $0x4

0080172d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	ff 75 10             	pushl  0x10(%ebp)
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	ff 75 08             	pushl  0x8(%ebp)
  80173d:	6a 10                	push   $0x10
  80173f:	e8 f0 fb ff ff       	call   801334 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
	return ;
  801747:	90                   	nop
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_rcr2>:
uint32 sys_rcr2()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 23                	push   $0x23
  801759:	e8 d6 fb ff ff       	call   801334 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80176f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	50                   	push   %eax
  80177c:	6a 24                	push   $0x24
  80177e:	e8 b1 fb ff ff       	call   801334 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
	return ;
  801786:	90                   	nop
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <rsttst>:
void rsttst()
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 26                	push   $0x26
  801798:	e8 97 fb ff ff       	call   801334 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017af:	8b 55 18             	mov    0x18(%ebp),%edx
  8017b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	ff 75 10             	pushl  0x10(%ebp)
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	6a 25                	push   $0x25
  8017c3:	e8 6c fb ff ff       	call   801334 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cb:	90                   	nop
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <chktst>:
void chktst(uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 27                	push   $0x27
  8017de:	e8 51 fb ff ff       	call   801334 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <inctst>:

void inctst()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 28                	push   $0x28
  8017f8:	e8 37 fb ff ff       	call   801334 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801800:	90                   	nop
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <gettst>:
uint32 gettst()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 29                	push   $0x29
  801812:	e8 1d fb ff ff       	call   801334 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 2a                	push   $0x2a
  80182e:	e8 01 fb ff ff       	call   801334 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
  801836:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801839:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80183d:	75 07                	jne    801846 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80183f:	b8 01 00 00 00       	mov    $0x1,%eax
  801844:	eb 05                	jmp    80184b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 2a                	push   $0x2a
  80185f:	e8 d0 fa ff ff       	call   801334 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
  801867:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80186a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80186e:	75 07                	jne    801877 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801870:	b8 01 00 00 00       	mov    $0x1,%eax
  801875:	eb 05                	jmp    80187c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 2a                	push   $0x2a
  801890:	e8 9f fa ff ff       	call   801334 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
  801898:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80189b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80189f:	75 07                	jne    8018a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a6:	eb 05                	jmp    8018ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 2a                	push   $0x2a
  8018c1:	e8 6e fa ff ff       	call   801334 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
  8018c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018cc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018d0:	75 07                	jne    8018d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d7:	eb 05                	jmp    8018de <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 2b                	push   $0x2b
  8018f0:	e8 3f fa ff ff       	call   801334 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f8:	90                   	nop
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801902:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	53                   	push   %ebx
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 2c                	push   $0x2c
  801913:	e8 1c fa ff ff       	call   801334 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 2d                	push   $0x2d
  801933:	e8 fc f9 ff ff       	call   801334 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801940:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	51                   	push   %ecx
  80194c:	ff 75 10             	pushl  0x10(%ebp)
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 2e                	push   $0x2e
  801953:	e8 dc f9 ff ff       	call   801334 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 10             	pushl  0x10(%ebp)
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 0f                	push   $0xf
  80196f:	e8 c0 f9 ff ff       	call   801334 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	50                   	push   %eax
  801989:	6a 2f                	push   $0x2f
  80198b:	e8 a4 f9 ff ff       	call   801334 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp

}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 30                	push   $0x30
  8019a6:	e8 89 f9 ff ff       	call   801334 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	6a 31                	push   $0x31
  8019c2:	e8 6d f9 ff ff       	call   801334 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
	return;
  8019ca:	90                   	nop
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 32                	push   $0x32
  8019dc:	e8 53 f9 ff ff       	call   801334 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	50                   	push   %eax
  8019f5:	6a 33                	push   $0x33
  8019f7:	e8 38 f9 ff ff       	call   801334 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    
  801a02:	66 90                	xchg   %ax,%ax

00801a04 <__udivdi3>:
  801a04:	55                   	push   %ebp
  801a05:	57                   	push   %edi
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 1c             	sub    $0x1c,%esp
  801a0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1b:	89 ca                	mov    %ecx,%edx
  801a1d:	89 f8                	mov    %edi,%eax
  801a1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a23:	85 f6                	test   %esi,%esi
  801a25:	75 2d                	jne    801a54 <__udivdi3+0x50>
  801a27:	39 cf                	cmp    %ecx,%edi
  801a29:	77 65                	ja     801a90 <__udivdi3+0x8c>
  801a2b:	89 fd                	mov    %edi,%ebp
  801a2d:	85 ff                	test   %edi,%edi
  801a2f:	75 0b                	jne    801a3c <__udivdi3+0x38>
  801a31:	b8 01 00 00 00       	mov    $0x1,%eax
  801a36:	31 d2                	xor    %edx,%edx
  801a38:	f7 f7                	div    %edi
  801a3a:	89 c5                	mov    %eax,%ebp
  801a3c:	31 d2                	xor    %edx,%edx
  801a3e:	89 c8                	mov    %ecx,%eax
  801a40:	f7 f5                	div    %ebp
  801a42:	89 c1                	mov    %eax,%ecx
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	f7 f5                	div    %ebp
  801a48:	89 cf                	mov    %ecx,%edi
  801a4a:	89 fa                	mov    %edi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	39 ce                	cmp    %ecx,%esi
  801a56:	77 28                	ja     801a80 <__udivdi3+0x7c>
  801a58:	0f bd fe             	bsr    %esi,%edi
  801a5b:	83 f7 1f             	xor    $0x1f,%edi
  801a5e:	75 40                	jne    801aa0 <__udivdi3+0x9c>
  801a60:	39 ce                	cmp    %ecx,%esi
  801a62:	72 0a                	jb     801a6e <__udivdi3+0x6a>
  801a64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a68:	0f 87 9e 00 00 00    	ja     801b0c <__udivdi3+0x108>
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	89 fa                	mov    %edi,%edx
  801a75:	83 c4 1c             	add    $0x1c,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5e                   	pop    %esi
  801a7a:	5f                   	pop    %edi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    
  801a7d:	8d 76 00             	lea    0x0(%esi),%esi
  801a80:	31 ff                	xor    %edi,%edi
  801a82:	31 c0                	xor    %eax,%eax
  801a84:	89 fa                	mov    %edi,%edx
  801a86:	83 c4 1c             	add    $0x1c,%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5f                   	pop    %edi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	89 d8                	mov    %ebx,%eax
  801a92:	f7 f7                	div    %edi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	89 fa                	mov    %edi,%edx
  801a98:	83 c4 1c             	add    $0x1c,%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5f                   	pop    %edi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    
  801aa0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa5:	89 eb                	mov    %ebp,%ebx
  801aa7:	29 fb                	sub    %edi,%ebx
  801aa9:	89 f9                	mov    %edi,%ecx
  801aab:	d3 e6                	shl    %cl,%esi
  801aad:	89 c5                	mov    %eax,%ebp
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 ed                	shr    %cl,%ebp
  801ab3:	89 e9                	mov    %ebp,%ecx
  801ab5:	09 f1                	or     %esi,%ecx
  801ab7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801abb:	89 f9                	mov    %edi,%ecx
  801abd:	d3 e0                	shl    %cl,%eax
  801abf:	89 c5                	mov    %eax,%ebp
  801ac1:	89 d6                	mov    %edx,%esi
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ee                	shr    %cl,%esi
  801ac7:	89 f9                	mov    %edi,%ecx
  801ac9:	d3 e2                	shl    %cl,%edx
  801acb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 e8                	shr    %cl,%eax
  801ad3:	09 c2                	or     %eax,%edx
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	89 f2                	mov    %esi,%edx
  801ad9:	f7 74 24 0c          	divl   0xc(%esp)
  801add:	89 d6                	mov    %edx,%esi
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	f7 e5                	mul    %ebp
  801ae3:	39 d6                	cmp    %edx,%esi
  801ae5:	72 19                	jb     801b00 <__udivdi3+0xfc>
  801ae7:	74 0b                	je     801af4 <__udivdi3+0xf0>
  801ae9:	89 d8                	mov    %ebx,%eax
  801aeb:	31 ff                	xor    %edi,%edi
  801aed:	e9 58 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af8:	89 f9                	mov    %edi,%ecx
  801afa:	d3 e2                	shl    %cl,%edx
  801afc:	39 c2                	cmp    %eax,%edx
  801afe:	73 e9                	jae    801ae9 <__udivdi3+0xe5>
  801b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b03:	31 ff                	xor    %edi,%edi
  801b05:	e9 40 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	31 c0                	xor    %eax,%eax
  801b0e:	e9 37 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b13:	90                   	nop

00801b14 <__umoddi3>:
  801b14:	55                   	push   %ebp
  801b15:	57                   	push   %edi
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	83 ec 1c             	sub    $0x1c,%esp
  801b1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b33:	89 f3                	mov    %esi,%ebx
  801b35:	89 fa                	mov    %edi,%edx
  801b37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3b:	89 34 24             	mov    %esi,(%esp)
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	75 1a                	jne    801b5c <__umoddi3+0x48>
  801b42:	39 f7                	cmp    %esi,%edi
  801b44:	0f 86 a2 00 00 00    	jbe    801bec <__umoddi3+0xd8>
  801b4a:	89 c8                	mov    %ecx,%eax
  801b4c:	89 f2                	mov    %esi,%edx
  801b4e:	f7 f7                	div    %edi
  801b50:	89 d0                	mov    %edx,%eax
  801b52:	31 d2                	xor    %edx,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	39 f0                	cmp    %esi,%eax
  801b5e:	0f 87 ac 00 00 00    	ja     801c10 <__umoddi3+0xfc>
  801b64:	0f bd e8             	bsr    %eax,%ebp
  801b67:	83 f5 1f             	xor    $0x1f,%ebp
  801b6a:	0f 84 ac 00 00 00    	je     801c1c <__umoddi3+0x108>
  801b70:	bf 20 00 00 00       	mov    $0x20,%edi
  801b75:	29 ef                	sub    %ebp,%edi
  801b77:	89 fe                	mov    %edi,%esi
  801b79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b7d:	89 e9                	mov    %ebp,%ecx
  801b7f:	d3 e0                	shl    %cl,%eax
  801b81:	89 d7                	mov    %edx,%edi
  801b83:	89 f1                	mov    %esi,%ecx
  801b85:	d3 ef                	shr    %cl,%edi
  801b87:	09 c7                	or     %eax,%edi
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 e2                	shl    %cl,%edx
  801b8d:	89 14 24             	mov    %edx,(%esp)
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 c2                	mov    %eax,%edx
  801b96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba4:	89 f1                	mov    %esi,%ecx
  801ba6:	d3 e8                	shr    %cl,%eax
  801ba8:	09 d0                	or     %edx,%eax
  801baa:	d3 eb                	shr    %cl,%ebx
  801bac:	89 da                	mov    %ebx,%edx
  801bae:	f7 f7                	div    %edi
  801bb0:	89 d3                	mov    %edx,%ebx
  801bb2:	f7 24 24             	mull   (%esp)
  801bb5:	89 c6                	mov    %eax,%esi
  801bb7:	89 d1                	mov    %edx,%ecx
  801bb9:	39 d3                	cmp    %edx,%ebx
  801bbb:	0f 82 87 00 00 00    	jb     801c48 <__umoddi3+0x134>
  801bc1:	0f 84 91 00 00 00    	je     801c58 <__umoddi3+0x144>
  801bc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bcb:	29 f2                	sub    %esi,%edx
  801bcd:	19 cb                	sbb    %ecx,%ebx
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd5:	d3 e0                	shl    %cl,%eax
  801bd7:	89 e9                	mov    %ebp,%ecx
  801bd9:	d3 ea                	shr    %cl,%edx
  801bdb:	09 d0                	or     %edx,%eax
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 eb                	shr    %cl,%ebx
  801be1:	89 da                	mov    %ebx,%edx
  801be3:	83 c4 1c             	add    $0x1c,%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5f                   	pop    %edi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    
  801beb:	90                   	nop
  801bec:	89 fd                	mov    %edi,%ebp
  801bee:	85 ff                	test   %edi,%edi
  801bf0:	75 0b                	jne    801bfd <__umoddi3+0xe9>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f7                	div    %edi
  801bfb:	89 c5                	mov    %eax,%ebp
  801bfd:	89 f0                	mov    %esi,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f5                	div    %ebp
  801c03:	89 c8                	mov    %ecx,%eax
  801c05:	f7 f5                	div    %ebp
  801c07:	89 d0                	mov    %edx,%eax
  801c09:	e9 44 ff ff ff       	jmp    801b52 <__umoddi3+0x3e>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	89 c8                	mov    %ecx,%eax
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	3b 04 24             	cmp    (%esp),%eax
  801c1f:	72 06                	jb     801c27 <__umoddi3+0x113>
  801c21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c25:	77 0f                	ja     801c36 <__umoddi3+0x122>
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	29 f9                	sub    %edi,%ecx
  801c2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c2f:	89 14 24             	mov    %edx,(%esp)
  801c32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3a:	8b 14 24             	mov    (%esp),%edx
  801c3d:	83 c4 1c             	add    $0x1c,%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    
  801c45:	8d 76 00             	lea    0x0(%esi),%esi
  801c48:	2b 04 24             	sub    (%esp),%eax
  801c4b:	19 fa                	sbb    %edi,%edx
  801c4d:	89 d1                	mov    %edx,%ecx
  801c4f:	89 c6                	mov    %eax,%esi
  801c51:	e9 71 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c5c:	72 ea                	jb     801c48 <__umoddi3+0x134>
  801c5e:	89 d9                	mov    %ebx,%ecx
  801c60:	e9 62 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>
